/*
    xcsv_chatter\briefing\fn_briefingDefine.sqf - SERVER side

    Tuning constants and the two helpers the briefing tick needs.

    Structured the same way as policyDeath: this file only DEFINES things when
    called, so postInit must call it before the first tick or the tick resolves
    nil functions and every briefing dies silently.

    Kept separate from preInit because these belong to the briefing and nothing
    else reads them - the next person tuning "how long is away" should not have
    to read the chatter channel weights to find it.
*/

if (!isServer) exitWith {};

/* ---- tuning -------------------------------------------------------------- */

// How long a player must be present before being briefed. Long enough to be
// past the loading screen; short enough that they have not wandered off.
XCSV_BRIEF_SettleSeconds = 45;

// Below this, say nothing at all. A relog is not a return, and an empty
// "welcome back, nothing happened" is worse than silence.
XCSV_BRIEF_MinAwayMinutes = 30;

// Warn about protection this far ahead. Two days is enough to actually do
// something about it across a couple of sessions.
XCSV_BRIEF_WarnHours = 48;

// A death this close to a flag counts as "on your ground". Territory radius
// tops out well under this, so it covers the approach as well as the base.
XCSV_BRIEF_NearMetres = 350;

/* ---- helpers ------------------------------------------------------------- */

/*
    XCSV_fnc_briefDuration - minutes to something a human reads.

    "2 days" and "3 hours" land; "4321 minutes" does not.
*/
XCSV_fnc_briefDuration = {
    params ["_minutes"];
    if (!(_minutes isEqualType 0) || {_minutes < 0}) exitWith { "a while" };

    if (_minutes < 90) exitWith { format ["%1 minutes", floor _minutes] };

    private _hours = floor (_minutes / 60);
    if (_hours < 48) exitWith {
        if (_hours isEqualTo 1) then { "1 hour" } else { format ["%1 hours", _hours] }
    };

    private _days = floor (_hours / 24);
    if (_days isEqualTo 1) exitWith { "1 day" };
    format ["%1 days", _days]
};

/*
    XCSV_fnc_briefSend - one line to one client.

    Text only, to a single owner id. No object is created, so BattlEye stays out
    of it - see the header of fn_briefingTick for why that matters right now.

    The line is passed as an ARGUMENT to remoteExecCall, never compiled, and the
    only player-controlled string that can reach it is a territory name. That
    goes to systemChat, which is plain text, so markup in a name cannot render.
    Do not route this into structured text without escaping first.
*/
XCSV_fnc_briefSend = {
    params ["_line", "_owner"];
    if (!(_line isEqualType "") || {_line isEqualTo ""}) exitWith { false };
    if (isNil "_owner") exitWith { false };
    _line remoteExecCall ["systemChat", _owner];
    true
};

diag_log format [
    "[XCSV_BRIEF] defined: settle %1s, min away %2 min, warn %3 h ahead, near %4 m.",
    XCSV_BRIEF_SettleSeconds, XCSV_BRIEF_MinAwayMinutes, XCSV_BRIEF_WarnHours, XCSV_BRIEF_NearMetres
];

true
