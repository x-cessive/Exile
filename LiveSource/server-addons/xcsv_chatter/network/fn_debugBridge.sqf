/*
    xcsv_chatter\network\fn_debugBridge.sqf - SERVER side

    OPERATOR DEBUG BRIDGE.

    Built 2026-08-03 to answer a real problem: the client-side features we ship
    -- XM8 apps, the purchase path, the payout -- can only be exercised by a
    human pressing buttons in a running game. Verifying them meant asking the
    owner to fly somewhere, buy something and die on cue. This lets the operator
    stage those scenarios from outside the game.

    ============================ WHAT THIS IS NOT ============================

    It is NOT an eval channel. Nothing in the database is ever compiled or
    executed. `action` is matched against a fixed switch below and anything
    unrecognised is refused and logged. Adding a capability means editing this
    file and repacking the addon -- deliberately, so the command set cannot grow
    by writing a row.

    ============================== THE GUARDS ===============================

    1. ADMIN UIDS ONLY. Every command names a target UID and it must be in
       XCSV_DEBUG_ADMINS. A row naming an ordinary player is refused. This is
       the guard that matters: it means a bad or stale row cannot reach a real
       player's inventory, position or money.

    2. LOCAL DATABASE ONLY. MariaDB listens on 127.0.0.1. Writing a command
       requires an account on this machine, which is the same level of access
       needed to edit the addon anyway.

    3. EVERY COMMAND IS AUDITED. Rows are never deleted by this code -- they are
       marked done/refused with a result string, so the queue is a log of
       everything that was asked for and what happened.

    4. ONE-SHOT. A row is claimed before it is executed, so a command cannot run
       twice if a tick overlaps.

    ============================ TURNING IT OFF =============================

    Set XCSV_DEBUG_ENABLED = false in bootstrap\fn_preInit.sqf and repack. The
    task stops polling and pending rows are ignored.
*/

if (!isServer) exitWith {};

// Only these UIDs can be the TARGET of a command.
XCSV_DEBUG_ADMINS = [
    "76561198108041726"     // Mr. Sage
];

/*
    Coerce an extDB column to a plain string.

    `str` is NOT safe here. extDB2 returns a STRING-typed column as an actual
    SQF string, and `str "abc"` wraps it in quotes -- so a UID came back as
    "76561198108041726" *including the quote characters* and never matched the
    admin list. The symptom was every command refused, with a result string that
    looked correct at a glance.

    (The earlier failure was the opposite end of the same problem: without
    `-STRING` in the query's OUTPUT, extDB inferred the 17-digit UID as a number
    and returned 7.65612e+16. Both halves have to be right.)
*/
XCSV_fnc_debugStr = {
    params ["_v"];
    if (_v isEqualType "") exitWith { _v };
    str _v
};

XCSV_fnc_debugFinish = {
    params ["_id", "_status", "_result"];
    // Result is truncated: the column is 255 and extDB2 will not thank us for
    // a query longer than the field.
    private _r = _result;
    if (count _r > 200) then { _r = _r select [0, 200] };
    format ["xcsvDebugDone:%1:%2:%3", _status, _r, _id] call ExileServer_system_database_query_fireAndForget;
    diag_log format ["[XCSV_DEBUG] #%1 %2 - %3", _id, _status, _r];
};

/*
    Find a connected player by UID. Returns objNull when they are not on the
    server, which every action treats as a refusal rather than an error -- the
    operator queuing a command before logging in is the normal case.
*/
XCSV_fnc_debugFindPlayer = {
    params ["_uid"];
    private _found = objNull;
    {
        if (getPlayerUID _x isEqualTo _uid) exitWith { _found = _x };
    } forEach allPlayers;
    _found
};

XCSV_fnc_debugTick = {
    if (!XCSV_DEBUG_ENABLED) exitWith {};

    private _rows = "xcsvDebugPending" call ExileServer_system_database_query_selectFull;
    if (isNil "_rows" || {!(_rows isEqualType [])}) exitWith {};

    {
        if (_x isEqualType [] && {count _x >= 5}) then {
            private _id     = parseNumber ([_x select 0] call XCSV_fnc_debugStr);
            private _action = toLower ([_x select 1] call XCSV_fnc_debugStr);
            private _uid    = [_x select 2] call XCSV_fnc_debugStr;
            private _a1     = [_x select 3] call XCSV_fnc_debugStr;
            private _a2     = [_x select 4] call XCSV_fnc_debugStr;

            /*
                Claim in memory, not in the database.

                The first version wrote status='running' and then wrote the
                final status, both through fireAndForget -- which is
                asynchronous, so the two updates could land out of order and a
                finished command would be left reading 'running' forever. That
                actually happened on the first live test.

                A server-side seen-set is exact, costs nothing, and survives the
                async window. Its only weakness is a server restart, which
                re-runs any row still marked pending -- acceptable for a debug
                tool, and the alternative (a synchronous claim) would block the
                scheduler on every tick.
            */
            private _seen = missionNamespace getVariable ["XCSV_DEBUG_Seen", createHashMap];
            private _already = _seen getOrDefault [_id, false];
            _seen set [_id, true];
            missionNamespace setVariable ["XCSV_DEBUG_Seen", _seen];

            // NOT `exitWith`. Inside a forEach, exitWith leaves the ENCLOSING
            // scope, so it would abandon every remaining row in the batch, not
            // just this one. That is the same defect that broke the scavenge
            // progress bar (fixed 2026-08-03); it is easy to write twice.
            if (_already) then {
                // already handled in an earlier tick, do nothing
            } else {
            if !(_uid in XCSV_DEBUG_ADMINS) then {
                [_id, "refused", format ["target %1 is not an admin UID", _uid]] call XCSV_fnc_debugFinish;
            } else {
                private _p = [_uid] call XCSV_fnc_debugFindPlayer;

                switch (_action) do {

                    // Where is everything? The single most useful command:
                    // reports live state without changing any of it.
                    case "info": {
                        if (isNull _p) then {
                            [_id, "done", "player not connected"] call XCSV_fnc_debugFinish;
                        } else {
                            private _pos = getPosATL _p;
                            [_id, "done", format [
                                "pos %1,%2 money %3 locker %4 policy %5 alive %6",
                                round (_pos select 0), round (_pos select 1),
                                _p getVariable ["ExileMoney", 0],
                                _p getVariable ["ExileLocker", 0],
                                _p getVariable ["XCSV_PolicyCharges", 0],
                                alive _p
                            ]] call XCSV_fnc_debugFinish;
                        };
                    };

                    // Teleport. Moves `vehicle _p`, not the player, so nobody
                    // gets dropped out of a moving helicopter -- same reasoning
                    // as fn_adminTeleport.sqf.
                    case "tp": {
                        if (isNull _p) exitWith {
                            [_id, "refused", "player not connected"] call XCSV_fnc_debugFinish;
                        };
                        private _x1 = parseNumber _a1;
                        private _y1 = parseNumber _a2;
                        if (_x1 <= 0 || {_y1 <= 0} || {_x1 > 15360} || {_y1 > 15360}) exitWith {
                            // Tanoa is 15360 m. Off-map coordinates are how the
                            // shipwrecks ended up in the ocean; refuse them here.
                            [_id, "refused", format ["off-map %1,%2", _x1, _y1]] call XCSV_fnc_debugFinish;
                        };
                        (vehicle _p) setPosATL [_x1, _y1, 0.5];
                        [_id, "done", format ["moved to %1,%2", _x1, _y1]] call XCSV_fnc_debugFinish;
                    };

                    // Set carried poptabs, for staging a purchase or payout
                    // test at a known starting balance.
                    case "money": {
                        if (isNull _p) exitWith {
                            [_id, "refused", "player not connected"] call XCSV_fnc_debugFinish;
                        };
                        private _n = round (parseNumber _a1);
                        if (_n < 0 || {_n > 500000}) exitWith {
                            [_id, "refused", "amount out of range"] call XCSV_fnc_debugFinish;
                        };
                        _p setVariable ["ExileMoney", _n, true];
                        format ["setPlayerMoney:%1:%2", _n, _p getVariable ["ExileDatabaseID", 0]]
                            call ExileServer_system_database_query_fireAndForget;
                        [_id, "done", format ["money set to %1", _n]] call XCSV_fnc_debugFinish;
                    };

                    // Force the Dead Man's Switch payout without dying, so the
                    // locker credit and charge consumption can be verified
                    // independently of the death path.
                    case "payout": {
                        if (isNull _p) exitWith {
                            [_id, "refused", "player not connected"] call XCSV_fnc_debugFinish;
                        };
                        private _before = _p getVariable ["ExileLocker", 0];
                        private _ok = [_p] call XCSV_fnc_policyPayout;
                        [_id, "done", format ["payout ran=%1 locker %2 -> %3",
                            _ok, _before, _p getVariable ["ExileLocker", 0]]] call XCSV_fnc_debugFinish;
                    };

                    // Message the operator in game, to confirm the bridge is
                    // reaching the right session.
                    case "say": {
                        if (isNull _p) exitWith {
                            [_id, "refused", "player not connected"] call XCSV_fnc_debugFinish;
                        };
                        // _a1 comes from the database, not from a player, but
                        // it is passed as an ARGUMENT to format rather than as
                        // the format string -- the Chronicle's rule.
                        [format ["XCSV DEBUG: %1", _a1]] remoteExec ["systemChat", owner _p];
                        [_id, "done", "sent"] call XCSV_fnc_debugFinish;
                    };

                    default {
                        [_id, "refused", format ["unknown action '%1'", _action]] call XCSV_fnc_debugFinish;
                    };
                };
            };
            };  // closes the `if (_already) then {} else {`
        };
    } forEach _rows;
};

true
