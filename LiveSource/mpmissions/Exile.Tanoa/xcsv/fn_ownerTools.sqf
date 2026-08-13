/*
    xcsv/fn_ownerTools.sqf - CLIENT side, OWNER ONLY

    XM8 App23 convenience surface for the server owner. This file is advisory:
    every command is re-authorized server-side in fn_ownerRequest.sqf.
*/

if (!hasInterface) exitWith {};

XCSV_OWNER_ADMINS = [
    "76561198108041726"     // Mr. Sage
];

XCSV_fnc_ownerSend = {
    params ["_command"];

    if !((getPlayerUID player) in XCSV_OWNER_ADMINS) exitWith {
        systemChat "XCSV Owner: not authorised.";
    };

    ["xcsvOwnerRequest", [_command]] call ExileClient_system_network_send;
    systemChat format ["XCSV Owner: requested %1.", _command];
};

XCSV_OWNER_ModeActions = createHashMapFromArray [
    ["loadouts", [
        "Loadouts",
        "<t size='1.05' color='#E8B339'>Owner Loadouts</t><br/><t size='0.78' color='#7E8896'>Four curated kits. Each one replaces your current carried gear, links essentials, and includes matching ammunition/tools.</t><br/><br/><t color='#E2E7EE'>Basic</t><t color='#7E8896'> - clean survival rifle kit.</t><br/><t color='#E2E7EE'>Medium</t><t color='#7E8896'> - suppressed marksman patrol kit.</t><br/><t color='#E2E7EE'>High</t><t color='#7E8896'> - premium Viper armor and 7.62 rifle.</t><br/><t color='#E2E7EE'>Godlike</t><t color='#7E8896'> - heavy MMG, thermal optic, launcher, elite armor.</t>",
        [["BASIC", "loadoutBasic"], ["MEDIUM", "loadoutMedium"], ["HIGH", "loadoutHigh"], ["GODLIKE", "loadoutGod"]]
    ]],
    ["economy", [
        "Economy",
        "<t size='1.05' color='#E8B339'>Economy</t><br/><t size='0.78' color='#7E8896'>Owner-only poptab and respect controls. These write through the server handler and persist to extDB where applicable.</t><br/><br/><t color='#E2E7EE'>Shopping Bankroll</t><t color='#7E8896'> adds enough carried poptabs to use the portable all-category market without friction.</t>",
        [["+10K TABS", "tabs10k"], ["+100K TABS", "tabs100k"], ["+10K RESPECT", "respect10k"], ["+100K RESPECT", "respect100k"], ["BANKROLL", "shoppingBankroll"]]
    ]],
    ["world", [
        "World",
        "<t size='1.05' color='#E8B339'>World Tools</t><br/><t size='0.78' color='#7E8896'>Personal survivability, owner market, and utility object cleanup. Portable traders are spawned locally after the server approves the request, matching how normal Exile traders are presented to clients.</t>",
        [["GOD ON", "godOn"], ["GOD OFF", "godOff"], ["SPAWN TRADER", "traderSpawn"], ["DESPAWN", "traderDespawn"], ["SPAWN HUNTER", "vehicleSpawn"], ["REPAIR NEAR", "vehicleRepair"]]
    ]],
    ["server", [
        "Director",
        "<t size='1.05' color='#E8B339'>Server Director</t><br/><t size='0.78' color='#7E8896'>Lightweight event controls for testing and staging. Cleanup only deletes owner-spawned objects or tagged XCSV scene objects, not arbitrary player property.</t>",
        [["RUN COURIER", "missionCourier"], ["CLEANUP", "cleanupNearest"], ["CLEAR OBJECTS", "clearAdminObjects"], ["CLEAR WX", "weatherClear"], ["STORM", "weatherStorm"], ["NOON", "timeNoon"], ["NIGHT", "timeNight"]]
    ]]
];

XCSV_fnc_ownerSelectMode = {
    disableSerialization;
    params [["_mode", "loadouts"]];

    private _entry = XCSV_OWNER_ModeActions getOrDefault [_mode, XCSV_OWNER_ModeActions get "loadouts"];
    _entry params ["_title", "_bodyText", "_actions"];

    missionNamespace setVariable ["XCSV_OWNER_CurrentActions", _actions];

    private _display = uiNamespace getVariable ["RscExileXM8", displayNull];
    if (isNull _display) exitWith {};

    private _body = _display displayCtrl 71881;
    if !(isNull _body) then {
        _body ctrlSetStructuredText parseText _bodyText;
        _body ctrlSetPosition [0, 0, 18.5 * 0.025, 14 * 0.04];
        _body ctrlCommit 0;
    };

    {
        private _ctrl = _display displayCtrl (71892 + _forEachIndex);
        if !(isNull _ctrl) then {
            if (_forEachIndex < (count _actions)) then {
                _ctrl ctrlSetText ((_actions select _forEachIndex) select 0);
                _ctrl ctrlShow true;
                _ctrl ctrlEnable true;
            } else {
                _ctrl ctrlSetText "";
                _ctrl ctrlShow false;
                _ctrl ctrlEnable false;
            };
        };
    } forEach [0, 1, 2, 3, 4, 5, 6, 7];

    systemChat format ["XCSV Owner: %1 tools.", _title];
};

XCSV_fnc_ownerRunAction = {
    params [["_index", -1]];
    private _actions = missionNamespace getVariable ["XCSV_OWNER_CurrentActions", []];
    if (_index < 0 || {_index >= count _actions}) exitWith {};
    [(_actions select _index) select 1] call XCSV_fnc_ownerSend;
};

XCSV_fnc_ownerShow = {
    disableSerialization;

    if !((getPlayerUID player) in XCSV_OWNER_ADMINS) exitWith {
        systemChat "XCSV Owner: not authorised.";
    };

    ["xcsvOwner", 0] call ExileClient_gui_xm8_slide;

    private _display = uiNamespace getVariable ["RscExileXM8", displayNull];
    if (isNull _display) exitWith {};

    private _body = _display displayCtrl 71881;
    if (isNull _body) exitWith {};

    ["loadouts"] call XCSV_fnc_ownerSelectMode;
};

ExileClient_system_xcsv_network_xcsvOwnerResponse = {
    params ["_command", ["_payload", []]];

    if (_command isEqualTo "traderSpawnLocal") exitWith {
        private _oldTrader = missionNamespace getVariable ["XCSV_OWNER_PortableTrader", objNull];
        if !(isNull _oldTrader) then { deleteVehicle _oldTrader; };

        _payload params ["_pos", "_dir"];
        private _trader = "Exile_Trader_Equipment" createVehicleLocal [0, 0, 0];
        _trader setVariable ["BIS_enableRandomization", false];
        _trader setVariable ["BIS_fnc_animalBehaviour_disable", true];
        _trader setVariable ["ExileAnimations", ["AmovPercMstpSnonWnonDnon"]];
        _trader setVariable ["ExileTraderType", "Exile_Trader_XCSVPortable"];
        _trader disableAI "ANIM";
        _trader disableAI "MOVE";
        _trader disableAI "FSM";
        _trader disableAI "AUTOTARGET";
        _trader disableAI "TARGET";
        _trader disableAI "CHECKVISIBLE";
        _trader allowDamage false;
        _trader setPosATL _pos;
        _trader setDir _dir;
        _trader switchMove "AmovPercMstpSnonWnonDnon";
        _trader addEventHandler ["AnimDone", {_this call ExileClient_object_trader_event_onAnimationDone}];
        missionNamespace setVariable ["XCSV_OWNER_PortableTrader", _trader];
        systemChat "XCSV Owner: portable owner trader spawned.";
    };

    if (_command isEqualTo "traderDespawnLocal") exitWith {
        private _trader = missionNamespace getVariable ["XCSV_OWNER_PortableTrader", objNull];
        if !(isNull _trader) then { deleteVehicle _trader; };
        missionNamespace setVariable ["XCSV_OWNER_PortableTrader", objNull];
        systemChat "XCSV Owner: portable owner trader despawned.";
    };
};

diag_log "[XCSV_OWNER] Owner Tools client app ready.";
