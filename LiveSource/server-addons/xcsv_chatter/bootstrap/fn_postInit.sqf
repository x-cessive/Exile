/*
    xcsv_chatter - postInit

    Registers one repeating task on Exile's own scheduler and then gets out of
    the way.

    Why ExileServer_system_thread_addTask and not `while {true} do {sleep n}`:
    Arma runs every scheduled script on ONE thread, sharing roughly 3 ms per
    frame between all of them. A private loop does not get its own thread, it
    just takes a slice from everything else. Exile already owns a scheduler, so
    we ride it. a3_exile_lootbox broadcasts the same way, which is proof the
    mechanism works on this server.

    Delivery is remoteExecCall ["systemChat", -2] - text only, to every client.
    No object is created, so BattlEye stays quiet and no filter exception is
    needed. That is a deliberate constraint on this addon: the moment it spawns
    something, createVehicle filters come into play.
*/

if (!isServer) exitWith {};

// Rotation state. Kept in missionNamespace rather than a script-local so the
// task closure stays stateless and can be re-registered safely.
missionNamespace setVariable ["XCSV_CHATTER_LastChannel", -1];

private _weighted = [];
{
    private _name  = _x select 0;
    private _count = _x select 1;
    for "_i" from 1 to _count do { _weighted pushBack _name };
} forEach XCSV_CHATTER_Channels;
missionNamespace setVariable ["XCSV_CHATTER_Weighted", _weighted];

[
    XCSV_CHATTER_Interval,
    {
        private _weighted = missionNamespace getVariable ["XCSV_CHATTER_Weighted", []];
        if (_weighted isEqualTo []) exitWith {};

        // Never the same channel twice running - two Warden lines back to back
        // reads like a bug rather than a broadcast.
        private _last = missionNamespace getVariable ["XCSV_CHATTER_LastChannel", -1];
        private _pick = "";
        for "_try" from 1 to 8 do {
            _pick = selectRandom _weighted;
            if (!(_pick isEqualTo _last)) exitWith {};
        };
        missionNamespace setVariable ["XCSV_CHATTER_LastChannel", _pick];

        private _lines = missionNamespace getVariable [_pick, []];
        if (_lines isEqualTo []) exitWith {};

        private _line = selectRandom _lines;
        _line remoteExecCall ["systemChat", -2];
    },
    [],
    true
] call ExileServer_system_thread_addTask;

diag_log format [
    "[XCSV_CHATTER] armed: first transmission in ~%1s, then every %2s.",
    XCSV_CHATTER_FirstDelay,
    XCSV_CHATTER_Interval
];

/* ------------------------------------------------------------------------
   Scoreboard cache

   Same scheduler, same reasoning. One database read every few minutes,
   published as a public variable, so the XM8 app renders instantly from data
   the client already has and nothing a player does can trigger a query.

   Published once at startup so the board is not empty for the first interval.
   ------------------------------------------------------------------------ */

[
    XCSV_SB_Interval,
    { call xcsv_chatter_fnc_scoreboardPublish },
    [],
    true
] call ExileServer_system_thread_addTask;

// Faction standing rides the same refresh. One more read of the same table the
// scoreboard already touches, so it costs a query, not a design.
[
    XCSV_SB_Interval,
    { call xcsv_chatter_fnc_standingPublish },
    [],
    true
] call ExileServer_system_thread_addTask;

[] spawn {
    // Let extDB2 finish its own init before the first query. Exile locks the
    // connection after a successful setup, and a query fired into a half-open
    // connection is how "extDB2 is already setup & locked" noise starts.
    uiSleep 45;
    call xcsv_chatter_fnc_scoreboardPublish;
    uiSleep 3;
    call xcsv_chatter_fnc_standingPublish;
};

diag_log format ["[XCSV_SB] armed: refresh every %1s.", XCSV_SB_Interval];

/* ------------------------------------------------------------------------
   Island Chronicle

   Same scheduler again. Reads player_history and retells one real death per
   tick as radio traffic. One event at a time on purpose: a burst of six reads
   like a log dump, one every seven minutes reads like a radio station.

   Deliberately started after the chatter task so the two interleave rather
   than firing together.
   ------------------------------------------------------------------------ */

[
    XCSV_CHRON_Interval,
    { call xcsv_chatter_fnc_chronicleTick },
    [],
    true
] call ExileServer_system_thread_addTask;

diag_log format ["[XCSV_CHRON] armed: one report every %1s.", XCSV_CHRON_Interval];

/* ------------------------------------------------------------------------
   Blackouts

   A roll every CheckInterval rather than a fixed schedule, so storms are
   irregular. The tick itself decides whether anything happens and returns
   immediately if a storm is already running or the cooldown has not elapsed.

   Weather is left at Exile's default until the first storm fires - we do not
   touch the sky on startup, so a restart mid-storm simply comes back clear
   rather than inheriting a half-applied state.
   ------------------------------------------------------------------------ */

missionNamespace setVariable ["XCSV_BO_Active", false];
missionNamespace setVariable ["XCSV_BO_LastEnd", diag_tickTime];

[
    XCSV_BO_CheckInterval,
    { call xcsv_chatter_fnc_blackoutTick },
    [],
    true
] call ExileServer_system_thread_addTask;

diag_log format [
    "[XCSV_BO] armed: roll every %1s at %2%% chance, %3s cooldown.",
    XCSV_BO_CheckInterval, XCSV_BO_Chance * 100, XCSV_BO_Cooldown
];

/* ------------------------------------------------------------------------
   Courier wreck scenes

   A small server-authored content slice: guarded poptab transport wrecks
   and one locked safe. It is intentionally scheduled once after boot, not a
   private loop. The scene code owns its object budget and tags every object it
   creates so later cleanup/diagnostics can distinguish it from ordinary Exile
   state.
   ------------------------------------------------------------------------ */

[] spawn {
    uiSleep 120;
    call xcsv_chatter_fnc_courierScenes;
};

diag_log "[XCSV_SCENE] courier scenes scheduled after startup settle.";

/* ------------------------------------------------------------------------
   Dead Man's Switch — the first client->server write path (roadmap 12.6).

   Two wirings are needed and both are easy to get wrong:

   1. THE DISPATCHER LOOKS THE HANDLER UP BY NAME IN missionNamespace.
      ExileServer_system_network_dispatchIncomingMessage builds
      "ExileServer_<module>_network_<message>" from CfgNetworkMessages and then
      does `missionNamespace getVariable [_functionName, ""]`. CfgFunctions
      gives us `xcsv_chatter_fnc_policyBuyRequest`, which is NOT that name, so
      it has to be aliased or every request dies as "Invalid function call!".

   2. policyDeath only DEFINES things when called. It carries the payout
      constants and the XCSV_fnc_policy* functions, so it must run before the
      first sweep or the first death.
   ------------------------------------------------------------------------ */

call xcsv_chatter_fnc_policyDeath;

/*
    The message is declared as xcsvPolicyBuyRequest in CfgNetworkMessages, so
    Exile's dispatcher looks up ExileServer_system_xcsv_network_xcsvPolicyBuyRequest.
    The shorter policyBuyRequest alias is never called.
*/
ExileServer_system_xcsv_network_xcsvPolicyBuyRequest = xcsv_chatter_fnc_policyBuyRequest;
ExileServer_system_xcsv_network_xcsvTeleportRequest = xcsv_chatter_fnc_teleportRequest;
ExileServer_system_xcsv_network_xcsvInspectRequest = xcsv_chatter_fnc_inspectorRequest;

[
    30,
    { call XCSV_fnc_policySweep },
    [],
    true
] call ExileServer_system_thread_addTask;

/* ------------------------------------------------------------------------
   "While you were away"

   Same scheduler again. The tick scans for a returning player and pushes one
   private report; it briefs at most one player per pass so six people
   reconnecting after a restart cannot fire twenty-four queries into the same
   connection Exile is using for saves.

   briefingDefine carries the tuning constants and the two helper functions,
   and like policyDeath it only defines them when called - so it runs first or
   every tick resolves nil functions and fails silently.

   A short interval is fine because the common case is cheap: no unbriefed
   player means the tick exits after one array scan without touching the
   database.
   ------------------------------------------------------------------------ */

call xcsv_chatter_fnc_briefingDefine;

[
    20,
    { call xcsv_chatter_fnc_briefingTick },
    [],
    true
] call ExileServer_system_thread_addTask;

diag_log "[XCSV_BRIEF] armed: scanning every 20s, one briefing per pass.";

call xcsv_chatter_fnc_debugBridge;

[
    5,
    { call XCSV_fnc_debugTick },
    [],
    true
] call ExileServer_system_thread_addTask;

diag_log format [
    "[XCSV_POLICY] armed: write path live, payout %1%% of carried capped at %2, sweep every 30s.",
    XCSV_POLICY_PAYOUT_PCT, XCSV_POLICY_PAYOUT_CAP
];

true
