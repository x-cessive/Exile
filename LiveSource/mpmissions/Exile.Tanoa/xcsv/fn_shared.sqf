/*
    xcsv/fn_shared.sqf - CLIENT side, shared helpers for every XCSV XM8 app.

    WHY THIS FILE EXISTS

    XCSV_fnc_esc lived inside fn_standing.sqf, which is where the need for it was
    first noticed. fn_scoreboard.sqf renders player names into structured text
    too and never escaped them, because the helper was not visible as something
    shared - it looked like part of the Standing app.

    That is the same shape as two other defects found on 2026-08-10: GUARD and
    doctor each holding their own literal copy of mission_src, and the Inspector's
    admin list existing on both sides of the network. A helper that two apps need
    belongs in one place, or the second app quietly does without it.

    LOADING

    initPlayerLocal.sqf runs this with `call compile preprocessFileLineNumbers`
    rather than execVM. execVM is scheduled, so two execVM'd files have no
    guaranteed order between them; a synchronous call cannot be beaten by the
    files that depend on it. In practice the apps only call these at render time,
    minutes later - but "in practice" is how the escape got missed in the first
    place.
*/

if (!hasInterface) exitWith {};

/*
    Escape text that came from a player before it reaches parseText.

    Structured text is XML-ish: "<" opens a tag and "&" opens an entity, so one
    player with "&" or "<" in their Steam name corrupts the markup of the whole
    control - for everyone reading it, not just for that player.

    Single pass over the characters. Escaping "&" first in a multi-pass version
    would then re-escape the "&" it just emitted and turn "<" into "&amp;lt;".
*/
XCSV_fnc_esc = {
    params ["_s"];
    if (isNil "_s" || {!(_s isEqualType "")}) exitWith { "" };
    private _out = "";
    {
        _out = _out + (switch (_x) do {
            case "&": { "&amp;" };
            case "<": { "&lt;"  };
            case ">": { "&gt;"  };
            default  { _x };
        });
    } forEach (_s splitString "");
    _out
};

/*
    Format a number for display without Arma's scientific notation.

    `str` emits roughly six significant figures and then switches to exponent
    form: str 1234567 is "1.23457e+006". A respect leaderboard shows the largest
    numbers on the server, so it is exactly where that threshold gets crossed.

    The k/m convention matches what the XM8 home screen already does for respect
    and poptabs in custom\ExileClient_gui_xm8_slide_apps_onOpen.sqf, so the two
    screens agree rather than each inventing a format.
*/
XCSV_fnc_num = {
    params ["_n"];
    if (isNil "_n" || {!(_n isEqualType 0)}) exitWith { "0" };
    if (_n > 999999) exitWith { format ["%1m", floor (_n / 1000000)] };
    if (_n > 999)    exitWith { format ["%1k", floor (_n / 1000)] };
    str _n
};

/*
    Grow a structured-text control to the height its content needs, so the
    controls group around it can scroll.

    A CT_CONTROLS_GROUP scrolls only when a CHILD overflows it. Every XCSV app
    declared its text control exactly as tall as its group, so nothing could ever
    overflow, the scrollbar had nothing to scroll, and a long list was silently
    CLIPPED instead - which is what happens to the scoreboard as soon as there
    are more players than fit.

    The group's declared height is kept as a floor, so a short list still fills
    the panel and the background does not collapse around three rows.
*/
XCSV_fnc_fitText = {
    disableSerialization;
    params ["_ctrl"];
    if (isNull _ctrl) exitWith {};

    private _pos    = ctrlPosition _ctrl;
    private _needed = ctrlTextHeight _ctrl;

    // Guarded: if ctrlTextHeight cannot measure in the same frame as the
    // ctrlSetStructuredText that preceded it, this degrades to exactly the old
    // behaviour rather than collapsing the control to zero height.
    if (_needed > 0) then {
        _ctrl ctrlSetPosition [
            _pos select 0,
            _pos select 1,
            _pos select 2,
            (_pos select 3) max _needed
        ];
        _ctrl ctrlCommit 0;
    };
};

diag_log "[XCSV_SHARED] helpers ready.";
