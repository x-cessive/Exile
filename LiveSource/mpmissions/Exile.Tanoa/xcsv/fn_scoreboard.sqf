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

        // Trim rather than let a long name push every column out of line, THEN
        // escape. That order matters: escaping first would let the 17-character
        // cut land inside an entity like "&amp;" and emit "&am", which is just
        // as broken as the character it replaced.
        //
        // The escape itself was missing entirely until 2026-08-10. A Steam name
        // containing "&" or "<" corrupted the markup for the whole board, for
        // every player who opened it - one row poisoning the entire control.
        // fn_standing.sqf had spotted this and handled it; this file had not,
        // because the helper looked like part of that app. It is now in
        // xcsv\fn_shared.sqf.
        private _shown = _name;
        if (count _shown > 18) then { _shown = (_shown select [0, 17]) + "." };
        _shown = [_shown] call XCSV_fnc_esc;

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
            [[_score] call XCSV_fnc_num, 8] call _pad,
            [str _kills, 7] call _pad,
            [str _deaths, 8] call _pad,
            str _kd
        ];
    } forEach _rows;

    // serverTime, not diag_tickTime. diag_tickTime is time since THIS machine's
    // engine started, so subtracting the server's value from the client's was
    // comparing two unrelated clocks: a client that had Arma open longer than
    // the server read a large positive age, a freshly joined one read a large
    // negative age, and the footer was only ever right by coincidence. The
    // publisher was changed to broadcast serverTime in the same pass - patching
    // one side alone leaves it broken.
    private _age = 0 max (serverTime - (missionNamespace getVariable ["XCSV_ScoreboardAt", serverTime]));
    _html = _html + format [
        "<br/><t size='0.7' color='#7E8896'>%1 player(s) ranked by respect. Updated %2 minute(s) ago.</t>",
        count _rows,
        round (_age / 60)
    ];

    _ctrl ctrlSetStructuredText parseText _html;

    // Render heartbeat. Every XCSV app was auditable only as far as "the file
    // loaded" until 2026-08-10, because the load-time diag_log at the bottom of
    // each file was the only thing any of them ever logged. That is how the
    // Player Inspector sat visibly broken with nobody able to prove whether its
    // render had ever run. One line here makes the question answerable from the
    // client RPT.
    diag_log format ["[XCSV_SB] rendered %1 row(s).", count _rows];
};

// Entry point for the XM8 button: switch to the slide, then fill it. The slide
// has to exist before its controls can be written to, which is why this is two
// steps and not one.
XCSV_fnc_scoreboardShow = {
    ["xcsvScoreboard", 0] call ExileClient_gui_xm8_slide;
    call XCSV_fnc_scoreboardFill;
};

diag_log "[XCSV_SB] scoreboard app ready.";
