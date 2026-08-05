/*
    xcsv_chatter\weather\fn_blackoutTick.sqf - SERVER side

    Blackouts: periodic storms, announced by WARDEN CONTROL before and after.

    WHY THIS NEEDS NO OVERRIDE AND NO CLIENT CODE:

    Weather commands run on the server and propagate to every client on their
    own. And the mechanical bite comes free: Exile's own temperature and wetness
    model already reacts to rain and overcast, so a storm genuinely punishes
    anyone caught outside without shelter or a fire. Nothing had to be hooked.

    CfgExileEnvironment was checked first - it governs fireflies, anomalies,
    breathing, snow, radiation and temperature, NOT overcast/rain/fog - and
    nothing else on this server sets weather. So this is not fighting an
    existing system.

    TWO BUGS FOUND ON FIRST DEPLOY, BOTH FIXED HERE:

    1. `setLightnings` did not parse - the engine read it as a variable and the
       whole function failed to compile. It is also unnecessary: Arma generates
       lightning from overcast by itself, so high overcast already produces a
       thunderstorm. Removed rather than replaced.

    2. The original used try/catch to guarantee the sky was handed back. SQF's
       catch only fires on an explicit `throw` - a runtime error does NOT
       trigger it - so the restore path was dead code that merely looked safe.
       Replaced with a watchdog: this tick force-clears the weather if a storm
       has been flagged active for longer than one could possibly last.

    Creates no objects. BattlEye is not involved.
*/

if (!isServer) exitWith {};

private _active = missionNamespace getVariable ["XCSV_BO_Active", false];
private _startedAt = missionNamespace getVariable ["XCSV_BO_StartedAt", 0];

// Watchdog. If a storm has been "active" for longer than the longest one can
// run, the spawn that owned it died somewhere. Take the sky back by force -
// weather that never lifts is worse than weather that never came.
private _maxLife = XCSV_BO_RampIn + XCSV_BO_Duration + XCSV_BO_RampOut + 120;
if (_active && {(diag_tickTime - _startedAt) > _maxLife}) then {
    diag_log "[XCSV_BO] WATCHDOG: storm overran its maximum life - forcing clear";
    60 setOvercast 0.3;
    60 setRain 0;
    60 setFog 0;
    forceWeatherChange;
    missionNamespace setVariable ["XCSV_BO_Active", false];
    missionNamespace setVariable ["XCSV_BO_LastEnd", diag_tickTime];
    _active = false;
};

if (_active) exitWith {};

// Cooldown, so two rolls in quick succession cannot chain storms together.
private _last = missionNamespace getVariable ["XCSV_BO_LastEnd", -99999];
if ((diag_tickTime - _last) < XCSV_BO_Cooldown) exitWith {};

if (random 1 > XCSV_BO_Chance) exitWith {};

missionNamespace setVariable ["XCSV_BO_Active", true];
missionNamespace setVariable ["XCSV_BO_StartedAt", diag_tickTime];

[] spawn {
    (selectRandom XCSV_BO_WarnLines) remoteExecCall ["systemChat", -2];

    // Ramp in rather than snapping. A sky that changes instantly reads as a
    // bug; one that darkens over two minutes reads as weather. Overcast near 1
    // is what makes Arma produce thunder on its own.
    uiSleep 20;
    XCSV_BO_RampIn setOvercast 1;
    XCSV_BO_RampIn setRain 0.85;
    XCSV_BO_RampIn setFog [0.35, 0.02, 10];

    uiSleep (XCSV_BO_RampIn min 120);
    (selectRandom XCSV_BO_HitLines) remoteExecCall ["systemChat", -2];

    uiSleep XCSV_BO_Duration;

    (selectRandom XCSV_BO_ClearLines) remoteExecCall ["systemChat", -2];

    XCSV_BO_RampOut setOvercast 0.25;
    XCSV_BO_RampOut setRain 0;
    XCSV_BO_RampOut setFog [0.02, 0.005, 5];

    uiSleep (XCSV_BO_RampOut min 180);

    missionNamespace setVariable ["XCSV_BO_Active", false];
    missionNamespace setVariable ["XCSV_BO_LastEnd", diag_tickTime];
    diag_log "[XCSV_BO] blackout ended, weather restored";
};

diag_log format ["[XCSV_BO] blackout starting: %1s ramp, %2s duration", XCSV_BO_RampIn, XCSV_BO_Duration];

true
