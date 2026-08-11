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

    /*
        COLUMNS

        Structured text has no table layout, so the columns are space-padded.
        That only works in a monospace face, which the control did not have -
        this file's own comment conceded the alignment was "approximate", and it
        was: the header put PLAYER at column 4 and SCORE at 34, while a data row
        put them at 5 and 36, because the row format string adds a literal space
        between fields that are already padded. The drift compounded across the
        row.

        Both halves are fixed here. The control is now EtelkaMonospacePro (see
        the class in config.cpp), which is already used elsewhere in this very
        mission - RscInGameUI.hpp and the paintshop addon - so it is proven
        available rather than hoped for. And the header is now BUILT FROM THE
        SAME WIDTHS as the rows, so the two cannot drift apart again by hand.

        Deliberately NOT done: resurrecting XCSV_fnc_sbCell, which emits
        <t align=...> per column and has sat unused in this file since it was
        written. It would not have worked. Multiple <t> elements on one line in
        Arma's structured text are INLINE - align applies to the line, not to a
        column box - so per-cell alignment cannot produce columns without one
        control per column. The dead helper is left in place for now rather than
        deleted, because deleting it belongs in a tidy-up rather than a fix.
    */
    private _w = [4, 30, 8, 7, 8];   // rank, name, score, kills, deaths

    // Left-align (pad on the right) for text, right-align (pad on the left) for
    // numbers. Numbers padded on the right make 9 and 1000 START at the same
    // column, which is exactly the alignment a reader does not want: digits
    // should line up by place value so the column can be scanned.
    private _pad  = { params ["_s", "_n"]; while { count _s < _n } do { _s = _s + " " }; _s };
    private _rpad = { params ["_s", "_n"]; while { count _s < _n } do { _s = " " + _s }; _s };

    // Header cells use the same aligner as the column beneath them, or the
    // label sits over the wrong end of its own numbers.
    private _head =
        ([ "#",      _w select 0] call _pad)  + " " +
        ([ "PLAYER", _w select 1] call _pad)  + " " +
        ([ "SCORE",  _w select 2] call _rpad) + " " +
        ([ "KILLS",  _w select 3] call _rpad) + " " +
        ([ "DEATHS", _w select 4] call _rpad) + " " + "K/D";

    // The rule under the header is drawn to the width the columns actually
    // occupy rather than to a hand-counted run of underscores.
    private _ruleWidth = 0;
    { _ruleWidth = _ruleWidth + _x + 1 } forEach _w;
    _ruleWidth = _ruleWidth + 3;
    private _bar = "";
    for "_i" from 1 to _ruleWidth do { _bar = _bar + "_" };

    // Header, rule and rows must all render at the SAME size. A monospace face
    // gives a fixed advance width per glyph AT A GIVEN SIZE - it does not make
    // 0.85 and 0.8 line up with each other. The header used to be 0.85 and the
    // rule 0.7 against 0.8 rows, which mattered little while nothing aligned
    // anyway and would have quietly undone this fix.
    private _size = "0.8";

    private _html = format ["<t size='%1' color='#3D9CFF'>%2</t><br/>", _size, _head];
    _html = _html + format ["<t size='%1' color='#2A303A'>%2</t><br/>", _size, _bar];

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

        // The escape was missing entirely until 2026-08-10. A Steam name
        // containing "&" or "<" corrupted the markup for the whole board, for
        // every player who opened it - one row poisoning the entire control.
        // fn_standing.sqf had spotted this and handled it; this file had not,
        // because the helper looked like part of that app. It is now in
        // xcsv\fn_shared.sqf.
        //
        // Order is truncate -> pad -> escape, and all three positions matter.
        //
        // Truncate first, because escaping first would let the 17-character cut
        // land inside an entity like "&amp;" and emit "&am".
        //
        // Escape LAST, after padding, because the padding counts CHARACTERS and
        // the escape changes the character count without changing the rendered
        // width: "&" is one glyph but "&amp;" is five. Escaping before padding
        // pads on markup length, so any name containing "&" or "<" would sit
        // short and pull every column after it out of line. That was invisible
        // while the face was proportional and everything was slightly wrong
        // anyway; with a monospace face it would be obvious.
        // Truncation is driven by the column width rather than a separate
        // literal. It was hardcoded to 18 against a 30-wide column, throwing
        // away twelve glyphs of a name for no reason, and pretending to be
        // width-driven while not being.
        private _nameMax = (_w select 1) - 1;
        private _shown = _name;
        if (count _shown > _nameMax + 1) then { _shown = (_shown select [0, _nameMax]) + "." };
        _shown = [[_shown, _w select 1] call _pad] call XCSV_fnc_esc;

        // _pad and _w come from above, so the header and the rows are padded to
        // the SAME widths by construction. This used to define its own _pad
        // inside the loop - redefining an identical function once per player -
        // while the header carried hand-counted spacing that did not match it.
        private _colour = switch (_rank) do {
            case 1: { "#E8B339" };   // gold
            case 2: { "#C0C6CE" };
            case 3: { "#B87333" };
            default { "#E2E7EE" };
        };

        _html = _html + format [
            "<t size='" + _size + "' color='%1'>%2 %3 %4 %5 %6 %7</t><br/>",
            _colour,
            [format ["%1.", _rank], _w select 0] call _pad,
            _shown,
            [[_score] call XCSV_fnc_num, _w select 2] call _rpad,
            [str _kills, _w select 3] call _rpad,
            [str _deaths, _w select 4] call _rpad,
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
    [_ctrl] call XCSV_fnc_fitText;   // so the group can scroll when this overflows

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
