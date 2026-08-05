/*
    xcsv_chatter\chronicle\fn_chronicleTick.sqf - SERVER side

    The island remembers. Turns real deaths into radio traffic, so SALVAGE NET
    reports what actually happened instead of reciting the same seven lines.

    WHY THIS OVERRIDES NOTHING:

    Exile already writes every death to `player_history` - account_uid, name,
    died_at, and the position. So this is a pure READ. No CfgExileCustomCode
    entry, no hook into ExileServer_object_player_death, nothing to merge and
    nothing for a future addon to collide with. Given that a lost merge on
    ExileClient_object_player_initialize silently killed Exile_Scavenge on this
    server for weeks, "adds no override" is a feature, not an accident.

    PLAYER NAMES ARE ATTACKER-CONTROLLED.

    A name arrives from the network and is whatever the player typed into Steam.
    It is passed as an ARGUMENT to format, never as the format string itself -
    `format ["%1", _name]` is safe, `format [_name]` would let a player inject
    format specifiers. Output goes to systemChat, which is plain text, so markup
    in a name cannot render. Do not route this into structured text without
    escaping it first.

    Creates no objects. BattlEye is not involved.
*/

if (!isServer) exitWith {};

private _rows = "getRecentDeaths" call ExileServer_system_database_query_selectFull;

if (isNil "_rows" || {!(_rows isEqualType [])} || {_rows isEqualTo []}) exitWith {};

// Deaths already broadcast. Kept server-side only; the list is bounded below so
// a long-running server does not accumulate ids forever.
private _seen = missionNamespace getVariable ["XCSV_CHRON_Seen", []];

// Oldest first, so the island tells its story in order rather than backwards.
private _fresh = [];
{
    if ((_x isEqualType []) && {(count _x) >= 4}) then {
        private _id = parseNumber str (_x select 0);
        if (!(_id in _seen)) then { _fresh pushBack _x };
    };
} forEach _rows;

if (_fresh isEqualTo []) exitWith {};

// One event per tick. A burst of six deaths reported at once reads like a log
// dump; one every few minutes reads like a radio station.
reverse _fresh;
private _event = _fresh select 0;

private _id   = parseNumber str (_event select 0);
private _name = _event select 1;
private _pos  = [parseNumber str (_event select 2), parseNumber str (_event select 3), 0];

// Nearest named place, so the line says "outside Georgetown" rather than a grid
// reference nobody can picture. Falls back to a bearing from the map centre.
private _where = "the interior";
private _near = nearestLocations [
    _pos,
    ["NameCityCapital", "NameCity", "NameVillage", "NameLocal", "Airport", "NameMarine"],
    2500
];
if !(_near isEqualTo []) then {
    _where = text (_near select 0);
};

if (_where isEqualTo "" || {isNil "_where"}) then { _where = "the interior" };

private _line = selectRandom XCSV_CHRON_Lines;

// _name and _where are ARGUMENTS. See the header - never the format string.
private _text = format [_line, _name, _where];
_text remoteExecCall ["systemChat", -2];

_seen pushBack _id;
// Bound the memory. The query only looks back 48 hours, so anything older than
// the newest 200 ids can never come back around.
if (count _seen > 200) then { _seen = _seen select [(count _seen) - 200, 200]; };
missionNamespace setVariable ["XCSV_CHRON_Seen", _seen];

diag_log format ["[XCSV_CHRON] reported death %1 near %2", _id, _where];

true
