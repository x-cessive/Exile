/*
    xcsv/fn_mapAtlas.sqf - CLIENT side

    Shows a compact XCSV atlas overlay while the main map is open. The controls
    are declared in description.ext via RscTitles; this file only toggles the
    layer. That avoids runtime ctrlCreate, which is BattlEye-sensitive here.
*/

if (!hasInterface) exitWith {};

[] spawn {
    private _layer = "XCSVMapAtlasLayer" call BIS_fnc_rscLayer;
    private _showing = false;

    while { true } do {
        uiSleep 0.25;
        if (visibleMap) then {
            if (!_showing) then {
                _layer cutRsc ["XCSVMapAtlas", "PLAIN", 0, false];
                _showing = true;
            };
        } else {
            if (_showing) then {
                _layer cutText ["", "PLAIN"];
                _showing = false;
            };
        };
    };
};

diag_log "[XCSV_MAP] atlas overlay watcher ready.";
