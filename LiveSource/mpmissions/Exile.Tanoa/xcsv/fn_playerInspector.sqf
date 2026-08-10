/*
    xcsv/fn_playerInspector.sqf - CLIENT side, ADMIN ONLY

    Player Inspector (roadmap 10.1.2, XM8 App20). Admin types a name fragment,
    the server resolves the matching account + territory rows and answers, and
    the app renders them in the slide XM8SlideXcsvInspector.

    HOW THE DATA GETS HERE:

    The client never queries the database directly. It sends xcsvInspectRequest
    (a name fragment) through Exile's dispatcher; the server-side handler in
    xcsv_chatter\network\fn_inspectorRequest.sqf re-resolves the session, checks
    its own UID whitelist, binds the fragment as a positional ? like value and
    answers with a single xcsvInspectResponse routed only to the requesting
    session. Read-only, so no object is created and BattlEye is not involved.

    The response handler is named for Exile's client dispatcher: it maps
    CfgNetworkMessages >> xcsvInspectResponse >> module="system_xcsv" onto
    ExileClient_system_xcsv_network_xcsvInspectResponse, exactly like the
    server side maps the request message onto ExileServer_system_xcsv_network_.

    Row layout (columns 3..6 map to exteDB's sql_custom ):
        [0] uid, [1] name, [2] respect, [3] kills, [4] deaths,
        [5] locker, [6] first_connect, [7] last_connect, [8] total_connections
*/

if (!hasInterface) exitWith {};

/*
    ADVISORY ONLY. The authoritative whitelist is XCSV_INSPECTOR_SERVER_ADMINS in
    xcsv_chatter\network\fn_inspectorRequest.sqf, which re-resolves the player
    from the session and refuses anyone not on it. This copy exists so a
    non-admin gets a message instead of silence; it grants nothing, and a client
    that edits it still gets refused by the server.

    It is still two literals that must agree, which is a shape that has already
    bitten this estate twice in one day (GUARD's mission_src and doctor's copy of
    the same path). Drift here is not a security hole - it is a confusing one:
    an admin removed from the SERVER list still gets a working-looking search box
    that silently returns nothing. If this list grows past one UID, that is the
    point to make the server publish it rather than keeping a second copy.
*/
XCSV_INSPECTOR_ADMINS = [
    "76561198108041726"     // Mr. Sage
];

// onKeyDown from the search box (Enter). Pulls the edit text and ships the
// request. The server does the whitelist + length checks; we only pre-guard
// so a non-admin gets a gentle message instead of silence.
XCSV_fnc_inspectorRequest = {
    disableSerialization;

    if !((getPlayerUID player) in XCSV_INSPECTOR_ADMINS) exitWith {
        systemChat "XCSV INS: not authorised.";
    };

    private _display = uiNamespace getVariable ["RscExileXM8", displayNull];
    if (isNull _display) exitWith {};

    private _edit = _display displayCtrl 71841;
    if (isNull _edit) exitWith {};

    private _fragment = toLower (ctrlText _edit);
    if ((count _fragment) < 2) exitWith {
        systemChat "XCSV INS: type at least 2 characters.";
    };

    // LIKE wildcards are stripped rather than escaped. The fragment is already
    // bound as a positional ? so this is not an injection guard - it is a
    // CORRECTNESS one. A stray "%" turns "%<fragment>%" into a pattern that
    // matches every account, and the query is ORDER BY last_connect_at LIMIT 1,
    // so the app would confidently show the wrong player rather than fail.
    // Stripping keeps the query shape "find a name containing this text", which
    // is the only thing the box claims to do. The server strips again, because
    // this check runs on a machine the player controls.
    // Deliberately plain string handling rather than regexMatch/regexReplace:
    // new engine commands have to be cleared through BattlEye's scripts.txt
    // before they can be used on a live client, and a filter kick is a far
    // worse outcome than a slightly longer loop.
    //
    // Character CODES rather than string literals, because the character being
    // filtered is a backslash and Arma's preprocessor treats a backslash as a
    // line continuation. Writing it as "\" is asking a preprocessor question
    // nobody should have to answer. 37 = %, 95 = _, 92 = backslash.
    private _clean = toString ((toArray _fragment) select { !(_x in [37, 95, 92]) });

    if (_clean != _fragment) then {
        systemChat "XCSV INS: wildcards removed from the search.";
        _fragment = _clean;
    };
    if ((count _fragment) < 2) exitWith {
        systemChat "XCSV INS: type at least 2 characters.";
    };

    ["xcsvInspectRequest", [_fragment]] call ExileClient_system_network_send;
    systemChat format ["XCSV INS: looking up '%1'...", _fragment];
};

// The detail pane's resting state. This app is a search box, so it is EMPTY
// until an admin types a name - and an empty pane beside a "Player Inspector"
// title reads as a broken app, which is exactly how it was reported on
// 2026-08-10. Trader Prices already says what to do; this now does too.
XCSV_fnc_inspectorHint = {
    disableSerialization;
    private _bodyCtrl = call XCSV_fnc_inspectorBody;
    if (isNull _bodyCtrl) exitWith {};

    _bodyCtrl ctrlSetStructuredText parseText (
        "<t size='1.0' color='#3D9CFF'>Player Inspector</t><br/><br/>" +
        "<t color='#7E8896'>Type part of a player name in the box on the left " +
        "and press Enter. Matching accounts appear in the list; pick one to " +
        "read it here.</t><br/><br/>" +
        "<t size='0.8' color='#7E8896'>Admin only. Read-only - nothing here " +
        "writes to the database.</t>"
    );
};

// Resolve the detail pane. Looked up on demand rather than cached: the app
// slides are created at runtime by extraApps_onOpen, so a handle stashed on one
// open is not guaranteed to still address a live control on the next.
XCSV_fnc_inspectorBody = {
    disableSerialization;
    private _display = uiNamespace getVariable ["RscExileXM8", displayNull];
    if (isNull _display) exitWith { controlNull };
    _display displayCtrl 71843
};

// onLBSelChanged from the result list. Row 0 is always the header we prepend;
// real account rows live at index+1.
XCSV_fnc_inspectorFill = {
    disableSerialization;
    params [["_row", -1]];
    if (_row < 1) exitWith {};

    private _bodyCtrl = call XCSV_fnc_inspectorBody;
    if (isNull _bodyCtrl) exitWith {};

    private _rows = missionNamespace getVariable ["XCSV_INSPECTOR_Rows", []];
    if ((count _rows) == 0 || (_row - 1) >= (count _rows)) exitWith {};

    private _r = _rows select (_row - 1);

    private _html = format [
        "<t size='1.1' color='#3D9CFF' align='center'>%1</t><br/>", _r select 1
    ];
    _html = _html + format ["<t color='#7E8896'>UID &nbsp;</t><t color='#E2E7EE'>%1</t><br/>", _r select 0];
    _html = _html + format ["<t color='#7E8896'>First &nbsp;</t><t color='#E2E7EE'>%1</t><br/>", _r select 6];
    _html = _html + format ["<t color='#7E8896'>Last &nbsp;</t><t color='#E2E7EE'>%1</t><br/>", _r select 7];
    private _deaths = _r select 4;
    private _kd = if (_deaths > 0) then {
        (round (((_r select 3) / _deaths) * 100)) / 100
    } else {
        _r select 3
    };
    _html = _html + format [
        "<br/><t color='#7E8896'>Respect <t color='#E2E7EE'>%1</t><br/>" +
        "Kills <t color='#E2E7EE'>%2</t> &nbsp; Deaths <t color='#E2E7EE'>%3</t> &nbsp; K/D <t color='#E2E7EE'>%5</t><br/>" +
        "Locker <t color='#E2E7EE'>%4</t><br/>Connections <t color='#E2E7EE'>%6</t>",
        _r select 2, _r select 3, _deaths, _r select 5, _kd, _r select 8
    ];

    // Fill territory rows from the buffer into the same pane.
    private _frags = missionNamespace getVariable ["XCSV_INSPECTOR_Territories", []];
    if ((count _frags) > 0) then {
        _html = _html + "<br/><t size='0.85' color='#3D9CFF' align='center'>Flags</t><br/>";
        {
            _html = _html + format ["<t color='#E2E7EE'>%1:%2</t><br/>", _x select 0, _x select 1];
        } forEach _frags;
    };

    _html = _html + "<br/><t color='#7E8896'>Territory keys (all constructed server-side, never here).</t>";

    _bodyCtrl ctrlSetStructuredText parseText _html;
};

// Entry point for the XM8 button: authorise, switch to the slide, bind the
// detail pane, then wipe prior results.
XCSV_fnc_inspectorShow = {
    disableSerialization;
    if !((getPlayerUID player) in XCSV_INSPECTOR_ADMINS) exitWith {
        systemChat "XCSV INS: not authorised.";
    };

    ["xcsvInspector", 0] call ExileClient_gui_xm8_slide;

    private _display = uiNamespace getVariable ["RscExileXM8", displayNull];
    if (isNull _display) exitWith {};

    missionNamespace setVariable ["XCSV_INSPECTOR_Rows", []];
    missionNamespace setVariable ["XCSV_INSPECTOR_Territories", []];

    private _list = _display displayCtrl 71842;
    if (!(isNull _list)) then { lbClear _list; };

    // Say what the app wants, rather than presenting a blank pane.
    call XCSV_fnc_inspectorHint;
};

// Called by DISPATCH, _this = [rows, terrRows], where rows has one account row
// and terrRows are the flag rows (a "P" flag reference format from the server).
ExileClient_system_xcsv_network_xcsvInspectResponse = {
    disableSerialization;
    private _rows     = _this select 0;
    private _terrRows = _this select 1;

    missionNamespace setVariable ["XCSV_INSPECTOR_Rows", _rows];
    missionNamespace setVariable ["XCSV_INSPECTOR_Territories", _terrRows];

    private _display = uiNamespace getVariable ["RscExileXM8", displayNull];
    if (isNull _display) exitWith {};

    private _list = _display displayCtrl 71842;
    if (isNull _list) exitWith {};

    // Keep row0 as a clickable header (0 = open app, no player selected).
    lbClear _list;
    _list lbAdd "-- select a player --";
    {
        _list lbAdd format ["%1  (uid %2)", _x select 1, _x select 0];
    } forEach _rows;

    // A search that matched nothing and a search that was never sent look the
    // same on screen otherwise, so say which happened.
    if ((count _rows) == 0) then {
        private _bodyCtrl = call XCSV_fnc_inspectorBody;
        if (!(isNull _bodyCtrl)) then {
            _bodyCtrl ctrlSetStructuredText parseText (
                "<t size='1.0' color='#E8B339'>No match</t><br/><br/>" +
                "<t color='#7E8896'>No account name contains that fragment. " +
                "The lookup matches on the stored name, so try a shorter " +
                "piece of it.</t>"
            );
        };
    };

    diag_log format ["[XCSV_INS] response: %1 account row(s), %2 territory row(s).",
        (count _rows), (count _terrRows)];
};