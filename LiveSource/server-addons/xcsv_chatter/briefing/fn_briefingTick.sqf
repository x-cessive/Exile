/*
    xcsv_chatter\briefing\fn_briefingTick.sqf - SERVER side

    "While you were away." One private situation report per returning player,
    covering the things that change without them: protection running down, a
    stolen flag, vehicles collected by the garbage collector, and who died near
    their ground.

    WHY THIS EXISTS

    A low-population server does not lose people because the server is bad. It
    loses them because logging in feels like nothing happened. Exile already
    records everything needed to prove otherwise - it just never tells anyone.
    The most expensive silence is territory decay: a player can lose a base they
    spent weeks on, while offline, with no warning they could have acted on.

    WHY THIS OVERRIDES NOTHING

    Every field read here is one Exile already writes: account.last_disconnect_at,
    territory.last_paid_at / flag_stolen, vehicle.deleted_at, player_history.
    So this is a pure READ, exactly like the Chronicle. No CfgExileCustomCode
    entry, no hook into the login sequence, nothing to merge and nothing for a
    future addon to collide with.

    WHY THERE IS NO REQUEST/RESPONSE PAIR

    The client never asks for this. The server notices a player is present and
    pushes once. A client that cannot ask cannot spam the database, which is the
    same reasoning the scoreboard is built on. It also means there is no new
    network message to whitelist and no new trust boundary to get wrong.

    BATTLEYE

    Creates no object, moves nothing, writes nothing. Delivery is
    remoteExecCall ["systemChat", owner _unit] - text, to one client. BE is not
    involved, which matters more than usual right now: as of 2026-08-10 rules #0
    (eventHandler) and #2 (ctrlCreate) are enforcing with a kick, so anything
    that renders UI needs a filter pass first. Text does not.

    TERRITORY LIFETIME IS READ FROM EXILE, NOT HARDCODED

    Exile computes the maintenance due date from
    CfgSettings >> GarbageCollector >> Database >> territoryLifeTime, in days
    (see ExileServer_system_territory_maintenance_recalculateDueDate). Reading
    the same value means this warning cannot drift away from the rule the server
    actually enforces. Hardcoding 7 here would produce a briefing that is
    confidently wrong the day someone tunes the setting.
*/

if (!isServer) exitWith {};

private _lifeDays = getNumber (configFile >> "CfgSettings" >> "GarbageCollector" >> "Database" >> "territoryLifeTime");
// A missing or nonsensical setting must not silently become "expires today".
if (_lifeDays <= 0) then { _lifeDays = 7 };

private _done  = missionNamespace getVariable ["XCSV_BRIEF_Done", []];
private _seen  = missionNamespace getVariable ["XCSV_BRIEF_Seen", []];   // [uid, firstSeenTick]
private _now   = diag_tickTime;

// The headless client is in allPlayers and has no account. Excluding it here is
// cheaper than discovering it via an empty query result.
private _humans = allPlayers select { !(_x isKindOf "HeadlessClient_F") };

// Whoever has been present long enough to have finished loading. Briefing a
// player mid-loading-screen means they never see it.
private _target = objNull;
private _targetUID = "";
{
    private _uid = getPlayerUID _x;
    if (!(_uid isEqualTo "") && {!(_uid in _done)}) then {
        private _firstSeen = -1;
        {
            if ((_x select 0) isEqualTo _uid) exitWith { _firstSeen = _x select 1 };
        } forEach _seen;

        if (_firstSeen < 0) then {
            _seen pushBack [_uid, _now];
        } else {
            if ((_now - _firstSeen) >= XCSV_BRIEF_SettleSeconds && {isNull _target}) then {
                _target = _x;
                _targetUID = _uid;
            };
        };
    };
} forEach _humans;

// Bound the seen list to whoever is actually connected, so a long-running server
// does not accumulate one entry per visitor forever.
private _liveUIDs = _humans apply { getPlayerUID _x };
_seen = _seen select { (_x select 0) in _liveUIDs };
missionNamespace setVariable ["XCSV_BRIEF_Seen", _seen];

// One player per tick. Four queries at once for six returning players would be a
// burst on the same connection Exile is using for saves.
if (isNull _target) exitWith { true };

_done pushBack _targetUID;
if (count _done > 200) then { _done = _done select [(count _done) - 200, 200]; };
missionNamespace setVariable ["XCSV_BRIEF_Done", _done];

private _owner = owner _target;

/* ---- how long were they gone -------------------------------------------- */

private _acct = format ["xcsvBriefingAccount:%1", _targetUID] call ExileServer_system_database_query_selectFull;
if (isNil "_acct" || {!(_acct isEqualType [])} || {_acct isEqualTo []}) exitWith {
    diag_log format ["[XCSV_BRIEF] no account row for %1, skipped", _targetUID];
    true
};

private _row      = _acct select 0;
private _awayMin  = parseNumber str (_row select 0);
private _visits   = parseNumber str (_row select 1);

// -1 is the COALESCE for "never disconnected", i.e. a first-ever session.
if (_awayMin < 0) exitWith {
    ["XCSV NET: first contact logged. Your XM8 field notes explain the island.", _owner] call XCSV_fnc_briefSend;
    true
};

// Nothing meaningful decays in a few minutes, and a relog should not produce a
// report. Silence is the correct output here, not an empty briefing.
if (_awayMin < XCSV_BRIEF_MinAwayMinutes) exitWith { true };

private _lines = [];
private _awayText = [_awayMin] call XCSV_fnc_briefDuration;
_lines pushBack format ["XCSV NET: welcome back. You were away %1. Visit %2.", _awayText, _visits];

/* ---- territories: the part that actually loses people -------------------- */

private _terr = format ["xcsvBriefingTerritory:%1", _targetUID] call ExileServer_system_database_query_selectFull;
private _terrRows = [];
if (!isNil "_terr" && {_terr isEqualType []}) then { _terrRows = _terr };

private _myPositions = [];
{
    if ((_x isEqualType []) && {(count _x) >= 6}) then {
        private _tName    = _x select 0;
        private _tLevel   = parseNumber str (_x select 1);
        private _paidHrs  = parseNumber str (_x select 2);
        private _stolen   = parseNumber str (_x select 3);
        private _tx       = parseNumber str (_x select 4);
        private _ty       = parseNumber str (_x select 5);

        _myPositions pushBack [_tx, _ty];

        if (_stolen > 0) then {
            // The loudest thing that can happen to a base. Say it first and plainly.
            _lines pushBack format ["XCSV NET: ALERT - the flag at %1 has been STOLEN.", _tName];
        };

        private _hoursLeft = (_lifeDays * 24) - _paidHrs;
        if (_hoursLeft <= 0) then {
            _lines pushBack format ["XCSV NET: %1 is PAST DUE and can be collected at any time. Pay protection now.", _tName];
        } else {
            if (_hoursLeft <= XCSV_BRIEF_WarnHours) then {
                // briefDuration takes MINUTES.
                _lines pushBack format ["XCSV NET: %1 (level %2) loses protection in %3. Pay before it decays.",
                    _tName, _tLevel, [floor (_hoursLeft * 60)] call XCSV_fnc_briefDuration];
            };
        };
    };
} forEach _terrRows;

/* ---- what the garbage collector took ------------------------------------- */

private _lost = format ["xcsvBriefingLostVehicles:%1", _targetUID] call ExileServer_system_database_query_selectFull;
if (!isNil "_lost" && {_lost isEqualType []} && {!(_lost isEqualTo [])}) then {
    private _n = parseNumber str ((_lost select 0) select 0);
    if (_n > 0) then {
        _lines pushBack format ["XCSV NET: %1 of your vehicle(s) were removed while you were gone.", _n];
    };
};

/* ---- who died on your ground --------------------------------------------- */

if !(_myPositions isEqualTo []) then {
    private _deaths = format ["xcsvBriefingDeathsNear:%1", _targetUID] call ExileServer_system_database_query_selectFull;
    if (!isNil "_deaths" && {_deaths isEqualType []}) then {
        private _near = 0;
        {
            if ((_x isEqualType []) && {(count _x) >= 3}) then {
                private _dx = parseNumber str (_x select 1);
                private _dy = parseNumber str (_x select 2);
                {
                    if (((_x select 0) - _dx) ^ 2 + ((_x select 1) - _dy) ^ 2 < (XCSV_BRIEF_NearMetres ^ 2)) exitWith {
                        _near = _near + 1;
                    };
                } forEach _myPositions;
            };
        } forEach _deaths;

        if (_near > 0) then {
            _lines pushBack format ["XCSV NET: %1 death(s) recorded near your territory while you were away.", _near];
        };
    };
};

/* ---- deliver -------------------------------------------------------------- */

// Spaced out, because six systemChat lines in one frame scroll each other off
// the screen before they can be read.
[_lines, _owner] spawn {
    params ["_lines", "_owner"];
    {
        [_x, _owner] call XCSV_fnc_briefSend;
        uiSleep 1.5;
    } forEach _lines;
};

diag_log format ["[XCSV_BRIEF] briefed %1 after %2 min away, %3 line(s)", _targetUID, _awayMin, count _lines];

true
