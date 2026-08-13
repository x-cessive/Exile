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

    _body ctrlSetStructuredText parseText (
        "<t size='1.1' color='#E8B339' align='center'>OWNER TOOLS</t><br/>" +
        "<t size='0.75' color='#7E8896' align='center'>All actions are server-authorized by UID.</t><br/><br/>" +
        "<t color='#3D9CFF'>Loadouts</t><br/>Basic, Medium, High, Godlike gear sets with matching ammo and tools.<br/><br/>" +
        "<t color='#3D9CFF'>Economy</t><br/>Add carried poptabs, respect, or a shopping bankroll for the portable trader.<br/><br/>" +
        "<t color='#3D9CFF'>World</t><br/>Toggle god mode, spawn/despawn the owner trader, run mission/event tools, repair or clear nearby objects, and control weather/time."
    );
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
