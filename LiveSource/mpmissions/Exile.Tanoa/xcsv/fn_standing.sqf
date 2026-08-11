/*
    xcsv/fn_standing.sqf - CLIENT side

    Shows how the three factions read you. XM8 App17.

    Reads XCSV_Standing, which the server publishes on a timer - no request, so
    opening the app touches nothing.

    ESCAPING: a player name is attacker-controlled and this renders into
    STRUCTURED TEXT, where "<" would start a tag and "&" an entity. The
    Chronicle got away without escaping because systemChat is plain text; here
    it matters, so XCSV_fnc_esc runs over anything that came from a player.
*/

if (!hasInterface) exitWith {};

/*
    Minimal structured-text escape.

    Written character by character rather than with a string-replace helper: the
    obvious candidate, ExileClient_util_string_replace, could not be found in
    either Exile or any installed addon, and calling a function that may not
    exist is how a client script dies silently on one server and works on
    another. `splitString ""` yielding single characters is core engine
    behaviour and needs no such faith.

    A single pass also removes the double-escaping trap - replacing "&" after
    "<" would turn "&lt;" into "&amp;lt;".
*/
// XCSV_fnc_esc moved to xcsv\fn_shared.sqf on 2026-08-10. It lived here, which
// made it look like part of the Standing app; fn_scoreboard.sqf renders player
// names into structured text too and never escaped them because the helper was
// not visible as something shared. One definition, both callers.

XCSV_STAND_Bands = [
    [80, "TRUSTED"],
    [60, "KNOWN"],
    [40, "NOTED"],
    [20, "MARGINAL"],
    [0,  "UNKNOWN"]
];

XCSV_fnc_standBand = {
    params ["_v"];
    private _label = "UNKNOWN";
    { if (_v >= (_x select 0)) exitWith { _label = _x select 1 } } forEach XCSV_STAND_Bands;
    _label
};

// A bar drawn out of block characters. Structured text has no progress control,
// and this reads correctly at any UI scale.
XCSV_fnc_standBar = {
    params ["_v", "_colour"];
    private _filled = round (_v / 5);          // 0-20 cells
    private _bar = "";
    for "_i" from 1 to 20 do {
        _bar = _bar + (if (_i <= _filled) then { "|" } else { "." });
    };
    format ["<t color='%1'>%2</t>", _colour, _bar]
};

XCSV_fnc_standingShow = {
    disableSerialization;

    ["xcsvStanding", 0] call ExileClient_gui_xm8_slide;

    private _display = uiNamespace getVariable ["RscExileXM8", displayNull];
    if (isNull _display) exitWith {};
    private _ctrl = _display displayCtrl 71821;
    if (isNull _ctrl) exitWith {};

    private _all = missionNamespace getVariable ["XCSV_Standing", []];
    private _uid = getPlayerUID player;

    private _mine = [];
    { if ((_x select 0) isEqualTo _uid) exitWith { _mine = _x } } forEach _all;

    if (_mine isEqualTo []) exitWith {
        _ctrl ctrlSetStructuredText parseText (
            "<t size='0.9' color='#7E8896'>The island has not formed an opinion yet.<br/><br/>" +
            "Standing is recalculated on the server every few minutes. If you have " +
            "just arrived, come back shortly.</t>"
        );
    };

    _mine params ["_u", "_name", "_yard", "_salvage", "_warden"];

    private _html =
        "<t size='1.0' color='#3D9CFF'>FACTION STANDING</t><br/>" +
        format ["<t size='0.8' color='#7E8896'>%1</t><br/><br/>", [_name] call XCSV_fnc_esc] +

        format ["<t size='0.85' color='#E8B339'>THE YARD</t>  <t size='0.75' color='#7E8896'>%1</t><br/>",
            [_yard] call XCSV_fnc_standBand] +
        format ["%1  <t size='0.75'>%2</t><br/>", [_yard, "#E8B339"] call XCSV_fnc_standBar, _yard] +
        "<t size='0.7' color='#7E8896'>Violence and notoriety. The inmates notice who fights.</t><br/><br/>" +

        format ["<t size='0.85' color='#3FC16A'>SALVAGE NET</t>  <t size='0.75' color='#7E8896'>%1</t><br/>",
            [_salvage] call XCSV_fnc_standBand] +
        format ["%1  <t size='0.75'>%2</t><br/>", [_salvage, "#3FC16A"] call XCSV_fnc_standBar, _salvage] +
        "<t size='0.7' color='#7E8896'>Trade and accumulation. Wealth in the locker, respect earned.</t><br/><br/>" +

        format ["<t size='0.85' color='#E05050'>WARDEN CONTROL</t>  <t size='0.75' color='#7E8896'>%1</t><br/>",
            [_warden] call XCSV_fnc_standBand] +
        format ["%1  <t size='0.75'>%2</t><br/>", [_warden, "#E05050"] call XCSV_fnc_standBar, _warden] +
        "<t size='0.7' color='#7E8896'>Endurance and compliance. Sessions survived, deaths counted against you.</t><br/><br/>" +

        "<t size='0.7' color='#5f6a78'>Standing is observational. It does not change prices - yet.</t>";

    _ctrl ctrlSetStructuredText parseText _html;
    [_ctrl] call XCSV_fnc_fitText;   // so the group can scroll when this overflows

    // Render heartbeat - see the note in fn_scoreboard.sqf. Until 2026-08-10 the
    // only thing any XCSV app logged was that its file had loaded, which is why
    // "has this app ever actually drawn anything?" was unanswerable.
    diag_log "[XCSV_STAND] rendered standing.";
};

diag_log "[XCSV_STAND] standing app ready.";
