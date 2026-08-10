/*
    xcsv_chatter\scoreboard\fn_scoreboardPublish.sqf - SERVER side

    Reads the leaderboard from the database and publishes it to every client as
    a public variable. The XM8 app then renders whatever is already in memory.

    WHY A CACHE AND NOT A REQUEST/RESPONSE:

    Exile has a network-message system (CfgNetworkMessages) and it would work,
    but it means a new message class pair, a server handler and a client
    handler, all so a player can look at a table that changes on the order of
    minutes. A public variable refreshed on a timer is a fraction of the moving
    parts, cannot be spammed by a client, and the app opens instantly because
    the data is already local. The cost is that the board can be up to
    XCSV_SB_Interval seconds stale, which for a scoreboard is nothing.

    WHY THE UID FILTER MATTERS:

    Exile's `account` table is not a table of players. Addons create accounts
    too - this server has DMS_PersistentVehicle, RandomHeli, RandomVehicles,
    RandomBoats_Random, RandomVehicles_Road and one row per headless client
    session. Of nine accounts, seven are machinery. Without the regexp filter
    the "top players" board lists RandomHeli, which reads as broken software.

    Real Steam64 IDs are 17 digits beginning 7656119, which the query enforces.

    Creates no objects, so BattlEye is not involved.
*/

if (!isServer) exitWith {};

private _rows = [];

// selectFull returns every row as [[col1, col2, ...], ...]. A database that is
// briefly unavailable returns nothing rather than throwing, so treat any
// non-array as "no data" and leave the previous board in place.
private _result = "getTopPlayers" call ExileServer_system_database_query_selectFull;

if (isNil "_result" || {!(_result isEqualType [])}) exitWith {
    diag_log "[XCSV_SB] query returned no usable data - keeping the previous board";
};

{
    // Defensive: a malformed row must not poison the whole board.
    if ((_x isEqualType []) && {(count _x) >= 5}) then {
        _rows pushBack [
            _x select 0,            // name
            parseNumber str (_x select 1),   // score
            parseNumber str (_x select 2),   // kills
            parseNumber str (_x select 3),   // deaths
            parseNumber str (_x select 4)    // total connections
        ];
    };
} forEach _result;

// Published so clients can read it without asking. The `true` broadcasts it;
// clients joining later get it from the JIP queue on the next refresh.
missionNamespace setVariable ["XCSV_Scoreboard", _rows, true];
// serverTime, not diag_tickTime. diag_tickTime is per-machine engine uptime, so
// a client subtracting the server's value from its own got noise - routinely
// negative for a client that joined after the server started. serverTime reads
// identically on the server and on every client. fn_scoreboard.sqf reads this
// with the matching change; the two must move together.
missionNamespace setVariable ["XCSV_ScoreboardAt", serverTime, true];

diag_log format ["[XCSV_SB] published %1 player(s)", count _rows];

true
