/*
    xcsv/fn_droneControl.sqf - CLIENT side

    XM8 App22: Drone Control.

    Native Arma UAV systems remain the authority for flight, driving, camera,
    assembly and disassembly. This app is deliberately a thin XCSV status layer
    plus native terminal/connect convenience. It does not create drones, persist
    ownership, emulate controls or run a background scanner.
*/

if (!hasInterface) exitWith {};

XCSV_DRONE_Rows = [];

XCSV_fnc_droneDisplay = {
    params ["_class"];
    private _label = "";
    {
        if (_label isEqualTo "") then {
            private _cfg = configFile >> _x >> _class;
            if (isClass _cfg) then {
                private _display = getText (_cfg >> "displayName");
                if !(_display isEqualTo "") then { _label = _display };
            };
        };
    } forEach ["CfgVehicles", "CfgWeapons", "CfgMagazines"];
    if (_label isEqualTo "") then { _label = _class };
    _label
};

XCSV_fnc_droneSerial = {
    params ["_uav"];
    private _kind = switch (true) do {
        case (_uav isKindOf "UAV_01_base_F"): { "AR-2" };
        case (_uav isKindOf "UGV_01_base_F"): { "STOMPER" };
        case (_uav isKindOf "UAV_02_base_F"): { "K40" };
        default { "UAV" };
    };
    private _net = netId _uav;
    private _seed = 0;
    { _seed = _seed + _x } forEach (toArray _net);
    format ["%1 #%2%3", _kind, ["A","B","C","D","E"] select (_seed mod 5), 100 + (_seed mod 900)]
};

XCSV_fnc_droneHasTerminal = {
    ("I_UavTerminal" in assignedItems player)
    || {"I_UavTerminal" in items player}
    || {"I_UavTerminal" in weapons player}
};

XCSV_fnc_droneHasDetector = {
    ("ItemRadio" in assignedItems player)
    || {"ItemRadio" in items player}
    || {"ItemRadio" in weapons player}
    || {call XCSV_fnc_droneHasTerminal}
};

XCSV_fnc_droneRfSignal = {
    private _nearest = 999999;
    {
        private _uav = vehicle _x;
        if (!isNull _uav && {alive _uav}) then {
            _nearest = _nearest min (player distance _uav);
        };
    } forEach allUnitsUAV;

    if (_nearest > 750) exitWith { "<t color='#7E8896'>NO DRONE LINK DETECTED</t>" };
    if (_nearest > 350) exitWith { "<t color='#E8B339'>SIGNAL WEAK</t>" };
    "<t color='#E05050'>SIGNAL STRONG</t>"
};

XCSV_fnc_droneScan = {
    private _connected = getConnectedUAV player;
    private _seen = [];
    private _rows = [];

    if (!isNull _connected) then {
        _seen pushBack _connected;
        _rows pushBack [_connected, "CONNECTED"];
    };

    {
        private _uav = vehicle _x;
        if (!isNull _uav && {alive _uav} && {!(_uav in _seen)}) then {
            private _dist = player distance _uav;
            if (_dist <= 1500) then {
                _seen pushBack _uav;
                _rows pushBack [_uav, "NEARBY"];
            };
        };
    } forEach allUnitsUAV;

    _rows
};

XCSV_fnc_droneFill = {
    disableSerialization;
    params [["_row", -1]];

    private _display = uiNamespace getVariable ["RscExileXM8", displayNull];
    if (isNull _display) exitWith {};

    private _body = _display displayCtrl 71872;
    if (isNull _body) exitWith {};

    private _hasTerminal = call XCSV_fnc_droneHasTerminal;
    private _hasDetector = call XCSV_fnc_droneHasDetector;
    private _connected = getConnectedUAV player;
    private _terminalText = if (_hasTerminal) then {
        "<t color='#3FC16A'>INSTALLED</t>"
    } else {
        "<t color='#E05050'>MISSING</t>"
    };
    private _rfText = if (_hasDetector) then {
        call XCSV_fnc_droneRfSignal
    } else {
        "<t color='#7E8896'>RADIO OR UAV TERMINAL REQUIRED</t>"
    };

    if (_row < 0 || {_row >= count XCSV_DRONE_Rows}) exitWith {
        _body ctrlSetStructuredText parseText format ["
            <t size='1.1' color='#3D9CFF'>DRONE CONTROL</t><br/><br/>
            <t color='#E8B339'>TERMINAL</t><br/>
            AAF UAV Terminal: %1<br/><br/>
            <t color='#E8B339'>RF DETECTOR</t><br/>
            %2<br/>
            <t size='0.8' color='#7E8896'>Coarse link awareness only. No exact
            drone position and no owner identity are exposed.</t><br/><br/>
            <t color='#7E8896'>No native UAV or UGV is connected or detected within 1.5 km.</t><br/><br/>
            Buy an AAF UAV Terminal and AR-2 Darter from DRONES &amp; ELECTRONICS,
            assemble the backpack drone, then refresh this app. AR-2 counterplay
            remains ordinary weapons plus dedicated AA where lock behavior is
            proven in live testing.
        ", _terminalText, _rfText];
        [_body] call XCSV_fnc_fitText;
    };

    (XCSV_DRONE_Rows select _row) params ["_uav", "_state"];
    if (isNull _uav) exitWith {};

    private _class = typeOf _uav;
    private _displayLabel = [_class] call XCSV_fnc_droneDisplay;
    private _serial = [_uav] call XCSV_fnc_droneSerial;
    private _condition = round ((1 - damage _uav) * 100);
    private _fuel = round ((fuel _uav) * 100);
    private _dist = round (player distance _uav);
    private _connectedText = if (_uav isEqualTo _connected) then {
        "<t color='#3FC16A'>CONNECTED</t>"
    } else {
        "<t color='#7E8896'>NOT CONNECTED</t>"
    };
    private _crew = crew _uav;
    private _crewText = if (_crew isEqualTo []) then { "No crew" } else { format ["%1 native crew", count _crew] };

    private _bodyText = format ["
        <t size='1.1' color='#3D9CFF'>%1</t><br/>
        <t size='0.8' color='#7E8896'>%2</t><br/><br/>
        <t color='#E8B339'>TERMINAL</t><br/>
        AAF UAV Terminal: %3<br/><br/>
        <t color='#E8B339'>RF DETECTOR</t><br/>
        %4<br/><br/>
        <t color='#E8B339'>CONNECTED DRONE</t><br/>
    ", _serial, _displayLabel, _terminalText, _rfText];

    _bodyText = _bodyText + format ["
        State: %1<br/>
        Link: %2<br/>
        Class: <t color='#7E8896'>%3</t><br/>
        Condition: %4%%<br/>
        Fuel: %5%%<br/>
        Distance: %6 m<br/>
        Crew: %7<br/><br/>
        <t color='#7E8896'>XCSV V1 filters and manages detected native UAVs only.
        Native UAV terminal behavior remains authoritative. Ownership and
        restart persistence are not claimed by this client screen.</t>
    ", _state, _connectedText, _class, _condition, _fuel, _dist, _crewText];

    _body ctrlSetStructuredText parseText _bodyText;
    [_body] call XCSV_fnc_fitText;
};

XCSV_fnc_droneRefresh = {
    disableSerialization;

    private _display = uiNamespace getVariable ["RscExileXM8", displayNull];
    if (isNull _display) exitWith {};

    private _list = _display displayCtrl 71871;
    if (isNull _list) exitWith {};

    XCSV_DRONE_Rows = call XCSV_fnc_droneScan;
    lbClear _list;

    {
        _x params ["_uav", "_state"];
        private _label = format [
            "%1  %2 m",
            [_uav] call XCSV_fnc_droneSerial,
            round (player distance _uav)
        ];
        private _idx = _list lbAdd _label;
        _list lbSetTooltip [_idx, format ["%1 - %2", [typeOf _uav] call XCSV_fnc_droneDisplay, _state]];
    } forEach XCSV_DRONE_Rows;

    if (count XCSV_DRONE_Rows > 0) then {
        _list lbSetCurSel 0;
        [0] call XCSV_fnc_droneFill;
    } else {
        [-1] call XCSV_fnc_droneFill;
    };

    diag_log format ["[XCSV_DRONE] refreshed (%1 detected).", count XCSV_DRONE_Rows];
};

XCSV_fnc_droneOpenTerminal = {
    if !(call XCSV_fnc_droneHasTerminal) exitWith {
        systemChat "XCSV Drone Control: buy/equip an AAF UAV Terminal first.";
        call XCSV_fnc_droneRefresh;
    };

    player action ["UAVTerminalOpen", player];
    diag_log "[XCSV_DRONE] native UAV terminal open requested.";
};

XCSV_fnc_droneConnectSelected = {
    disableSerialization;

    if !(call XCSV_fnc_droneHasTerminal) exitWith {
        systemChat "XCSV Drone Control: AAF UAV Terminal is missing.";
        call XCSV_fnc_droneRefresh;
    };

    private _display = uiNamespace getVariable ["RscExileXM8", displayNull];
    if (isNull _display) exitWith {};
    private _list = _display displayCtrl 71871;
    if (isNull _list) exitWith {};

    private _row = lbCurSel _list;
    if (_row < 0 || {_row >= count XCSV_DRONE_Rows}) exitWith {
        systemChat "XCSV Drone Control: no drone selected.";
    };

    private _uav = (XCSV_DRONE_Rows select _row) select 0;
    if (isNull _uav || {!alive _uav}) exitWith {
        systemChat "XCSV Drone Control: selected drone is gone.";
        call XCSV_fnc_droneRefresh;
    };

    player connectTerminalToUAV _uav;
    diag_log format ["[XCSV_DRONE] connect requested for %1 (%2).", typeOf _uav, netId _uav];
    call XCSV_fnc_droneRefresh;
};

XCSV_fnc_droneDisconnect = {
    player connectTerminalToUAV objNull;
    diag_log "[XCSV_DRONE] disconnect requested.";
    call XCSV_fnc_droneRefresh;
};

XCSV_fnc_droneShow = {
    disableSerialization;
    ["xcsvDrone", 0] call ExileClient_gui_xm8_slide;
    call XCSV_fnc_droneRefresh;
};

if (isNil "XCSV_DRONE_OwnerThread") then {
    XCSV_DRONE_OwnerThread = [1, {
        private _uav = getConnectedUAV player;
        if (!isNull _uav && {alive _uav}) then {
            private _ownerUID = _uav getVariable ["ExileOwnerUID", ""];
            if (!(_ownerUID isEqualTo "") && {!(_ownerUID isEqualTo (getPlayerUID player))}) then {
                player connectTerminalToUAV objNull;
                if (!isNull (findDisplay 160)) then {
                    (findDisplay 160) closeDisplay 0;
                };
                systemChat "XCSV Drone Control: link refused, drone belongs to another survivor.";
                diag_log format ["[XCSV_DRONE] ownership refusal for %1 (%2), owner %3.", typeOf _uav, netId _uav, _ownerUID];
            };
        };
    }, [], true, false] call ExileClient_system_thread_addTask;
};

diag_log "[XCSV_DRONE] Drone Control app ready (native terminal V1).";
