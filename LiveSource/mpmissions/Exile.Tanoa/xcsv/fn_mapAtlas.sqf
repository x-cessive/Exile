/*
    xcsv/fn_mapAtlas.sqf - CLIENT side

    Shows a compact XCSV atlas overlay while the main map is open.
*/

if (!hasInterface) exitWith {};

XCSV_fnc_mapAtlasCreateText = {
    params ["_display", "_idc", "_pos", "_text"];

    private _ctrl = _display ctrlCreate ["RscStructuredText", _idc];
    _ctrl ctrlSetPosition _pos;
    _ctrl ctrlSetBackgroundColor [0, 0, 0, 0.62];
    _ctrl ctrlSetStructuredText parseText _text;
    _ctrl ctrlCommit 0;
    _ctrl
};

XCSV_fnc_mapAtlasCreate = {
    params ["_display"];

    if !(isNull (_display displayCtrl 71990)) exitWith {};

    [
        _display,
        71990,
        [safezoneX + safezoneW * 0.245, safezoneY + safezoneH * 0.012, safezoneW * 0.51, safezoneH * 0.112],
        "<t size='0.84' color='#E8B339' align='center'>MISSION DIFFICULTY AND MAP SIGNALS</t><br/><t size='0.68' color='#E2E7EE' align='center'>Green low  |  Yellow medium  |  Orange hard  |  Red elite  |  Blue water/coastal</t><br/><t size='0.64' color='#7E8896' align='center'>Spawn markers are fresh-start choices. Cash Van markers are guarded poptab transport wrecks.</t>"
    ] call XCSV_fnc_mapAtlasCreateText;

    [
        _display,
        71991,
        [safezoneX + safezoneW * 0.008, safezoneY + safezoneH * 0.135, safezoneW * 0.17, safezoneH * 0.47],
        "<t size='0.82' color='#3D9CFF'>TRADER AND SPAWN DIRECTORY</t><br/><t size='0.66' color='#E2E7EE'>South Trader</t><t size='0.66' color='#7E8896'> - general goods</t><br/><t size='0.66' color='#E2E7EE'>Mountain Trader</t><t size='0.66' color='#7E8896'> - inland staging</t><br/><t size='0.66' color='#E2E7EE'>North Trader</t><t size='0.66' color='#7E8896'> - Savu/Oumere route</t><br/><t size='0.66' color='#E2E7EE'>Aircraft</t><t size='0.66' color='#7E8896'> - airframes and parts</t><br/><t size='0.66' color='#E2E7EE'>Boat Trader</t><t size='0.66' color='#7E8896'> - coastal logistics</t><br/><br/><t size='0.72' color='#3FC16A'>ISLAND STARTS</t><br/><t size='0.64' color='#E2E7EE'>Tuvanaka, La Rochelle, Lijnhaven, Savu</t><br/><t size='0.62' color='#7E8896'>Outer-island starts are quieter for looting and boat routes. Main-island starts are faster for traders.</t>"
    ] call XCSV_fnc_mapAtlasCreateText;

    [
        _display,
        71992,
        [safezoneX + safezoneW * 0.823, safezoneY + safezoneH * 0.135, safezoneW * 0.17, safezoneH * 0.47],
        "<t size='0.82' color='#E8B339'>XCSV ICON ATLAS</t><br/><t size='0.66' color='#E2E7EE'>Spawn</t><t size='0.66' color='#7E8896'> - fresh start zone</t><br/><t size='0.66' color='#E2E7EE'>Cash Van</t><t size='0.66' color='#7E8896'> - guarded poptabs safe</t><br/><t size='0.66' color='#E2E7EE'>Heli Crash</t><t size='0.66' color='#7E8896'> - weapons and parts</t><br/><t size='0.66' color='#E2E7EE'>Shipwreck</t><t size='0.66' color='#7E8896'> - coastal crates</t><br/><t size='0.66' color='#E2E7EE'>Vehicle Heist</t><t size='0.66' color='#7E8896'> - recoverable ride</t><br/><t size='0.66' color='#E2E7EE'>Gear Crate</t><t size='0.66' color='#7E8896'> - fast loot</t><br/><br/><t size='0.64' color='#E8B339'>Courier wrecks reject trader and safezone markers inside 1km.</t>"
    ] call XCSV_fnc_mapAtlasCreateText;

    [
        _display,
        71993,
        [safezoneX + safezoneW * 0.19, safezoneY + safezoneH * 0.885, safezoneW * 0.62, safezoneH * 0.095],
        "<t size='0.76' color='#3FC16A' align='center'>FRESH ARRIVAL ROUTE</t><br/><t size='0.64' color='#E2E7EE' align='center'>Spawn, loot one town, find water, then choose: trader run, boat route, or green mission. No safezone combat, no vehicle parking in trader circles, and orange/red missions are group work.</t>"
    ] call XCSV_fnc_mapAtlasCreateText;
};

[] spawn {
    private _showing = false;

    while { true } do {
        uiSleep 0.25;
        if (visibleMap) then {
            if (!_showing) then {
                private _display = findDisplay 12;
                if !(isNull _display) then {
                    [_display] call XCSV_fnc_mapAtlasCreate;
                    _showing = true;
                };
            };
        } else {
            if (_showing) then {
                _showing = false;
            };
        };
    };
};

diag_log "[XCSV_MAP] atlas overlay watcher ready.";
