/*
    xcsv/fn_scoreboard.sqf - CLIENT side

    Renders the leaderboard inside the XM8, in the app slide XM8SlideXcsvScoreboard.

    This exists because the server has been advertising a scoreboard for as long
    as it has been up - a3_exile_lootbox's broadcast told players to press P -
    and no scoreboard was ever installed. Pressing P did nothing.

    HOW THE DATA GETS HERE:

    It is already here. The server reads the database on a timer and publishes
    XCSV_Scoreboard as a public variable (see xcsv_chatter\scoreboard). This
    function only formats what is in memory. There is no request, so opening the
    app cannot touch the database and cannot be used to hammer it.

    A client can obviously overwrite its own copy of the variable. That is
    harmless: it is display-only, nothing is written back, and the player would
    be lying to themselves.

    NO OBJECTS ARE CREATED, so no BattlEye filter is involved.
*/

if (!hasInterface) exitWith {};

// Right-aligned fixed-width columns in structured text. Arma's structured text
// has no table layout, so the alignment comes from an outer <t> per column.
XCSV_fnc_sbCell = {
    params ["_text", "_x", "_w", ["_align", "left"], ["_colour", "#E2E7EE"], ["_size", "0.8"]];
    format [
        "<t align='%1' color='%2' size='%3'>%4</t>",
        _align, _colour, _size, _text
    ];
};

XCSV_fnc_scoreboardFill = {
    disableSerialization;

    private _display = uiNamespace getVariable ["RscExileXM8", displayNull];
    if (isNull _display) exitWith {};

    private _ctrl = _display displayCtrl 71801;
    if (isNull _ctrl) exitWith {};

    private _rows = missionNamespace getVariable ["XCSV_Scoreboard", []];

    if (_rows isEqualTo []) exitWith {
        _ctrl ctrlSetStructuredText parseText (
            "<t size='0.9' color='#7E8896'>No scores yet.<br/><br/>" +
            "The board is published by the server every few minutes. " +
            "If this stays empty, the server has not finished its first refresh.</t>"
        );
    };

    // Header, then one line per player. <br/> rather than a real table because
    // structured text has no columns; the widths below are eyeballed against
    // the XM8 slide and hold for names up to roughly 18 characters.
    private _html = "<t size='0.85' color='#3D9CFF'>#   PLAYER                        SCORE   KILLS  DEATHS   K/D</t><br/>";
    _html = _html + "<t size='0.7' color='#2A303A'>______________________________________________________________</t><br/>";

    private _rank = 0;
    {
        _x params ["_name", "_score", "_kills", "_deaths", "_conns"];
        _rank = _rank + 1;

        // Deaths of zero would divide by zero; Exile counts a fresh spawn as no
        // death at all, so a new player legitimately sits at 0.
        private _kd = if (_deaths > 0) then {
            (round ((_kills / _deaths) * 100)) / 100
        } else {
            _kills
        };

        // Trim rather than let a long name push every column out of line.
        private _shown = _name;
        if (count _shown > 18) then { _shown = (_shown select [0, 17]) + "." };

        // Pad to fixed widths. A monospace face is not guaranteed here, so this
        // is approximate - good enough to read as columns, and it degrades to a
        // readable list rather than to nonsense.
        private _pad = { params ["_s", "_n"]; while { count _s < _n } do { _s = _s + " " }; _s };
        private _colour = switch (_rank) do {
            case 1: { "#E8B339" };   // gold
            case 2: { "#C0C6CE" };
            case 3: { "#B87333" };
            default { "#E2E7EE" };
        };

        _html = _html + format [
            "<t size='0.8' color='%1'>%2 %3 %4 %5 %6 %7</t><br/>",
            _colour,
            [format ["%1.", _rank], 4] call _pad,
            [_shown, 30] call _pad,
            [str _score, 8] call _pad,
            [str _kills, 7] call _pad,
            [str _deaths, 8] call _pad,
            str _kd
        ];
    } forEach _rows;

    private _age = diag_tickTime - (missionNamespace getVariable ["XCSV_ScoreboardAt", diag_tickTime]);
    _html = _html + format [
        "<br/><t size='0.7' color='#7E8896'>%1 player(s) ranked by respect. Updated %2 minute(s) ago.</t>",
        count _rows,
        round (_age / 60)
    ];

    _ctrl ctrlSetStructuredText parseText _html;
};

// Entry point for the XM8 button: switch to the slide, then fill it. The slide
// has to exist before its controls can be written to, which is why this is two
// steps and not one.
XCSV_fnc_scoreboardShow = {
    ["xcsvScoreboard", 0] call ExileClient_gui_xm8_slide;
    call XCSV_fnc_scoreboardFill;
};

diag_log "[XCSV_SB] scoreboard app ready.";
