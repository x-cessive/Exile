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

XCSV_fnc_ownerTeleport = {
    params ["_pos", ["_label", "owner waypoint"]];
    private _dest = +_pos;
    _dest set [2, 0];
    ["xcsvTeleportRequest", [_dest, _label]] call ExileClient_system_network_send;
    systemChat format ["XCSV Owner: teleport requested - %1.", _label];
};

XCSV_fnc_ownerSafezoneAudit = {
    disableSerialization;

    private _rows = [];
    {
        private _markerType = markerType _x;
        if (_markerType in ["ExileTraderZone", "ExileTraderZoneIcon"]) then {
            private _dist = round (player distance2D (getMarkerPos _x));
            _rows pushBack [_dist, _x];
        };
    } forEach allMapMarkers;

    _rows sort true;
    private _html = "<t size='1.05' color='#E8B339'>Safezone Audit</t><br/><t size='0.78' color='#7E8896'>Nearest trader/safezone markers. Courier scenes reject locations inside 1000m.</t><br/><br/>";
    {
        if (_forEachIndex < 8) then {
            _html = _html + format ["<t color='#E2E7EE'>%1m</t><t color='#7E8896'> - %2</t><br/>", _x select 0, _x select 1];
        };
    } forEach _rows;

    private _display = uiNamespace getVariable ["RscExileXM8", displayNull];
    if !(isNull _display) then {
        private _body = _display displayCtrl 71881;
        if !(isNull _body) then { _body ctrlSetStructuredText parseText _html; };
    };
};

XCSV_fnc_ownerSpectateNearest = {
    private _near = (allPlayers - [player]) select { alive _x && { isPlayer _x } && {!((getPlayerUID _x) isEqualTo "")} };
    _near = [_near, [], { player distance2D _x }, "ASCEND"] call BIS_fnc_sortBy;
    if (_near isEqualTo []) exitWith { systemChat "XCSV Owner: no player to spectate."; };
    private _target = _near select 0;
    _target switchCamera "INTERNAL";
    missionNamespace setVariable ["XCSV_OWNER_Spectating", _target];
    systemChat format ["XCSV Owner: spectating %1.", name _target];
};

XCSV_fnc_ownerStopSpectate = {
    player switchCamera "INTERNAL";
    missionNamespace setVariable ["XCSV_OWNER_Spectating", objNull];
    systemChat "XCSV Owner: spectate off.";
};

XCSV_OWNER_LoadoutKits = createHashMapFromArray [
    ["loadoutBasic", [
        "U_I_CombatUniform", "V_PlateCarrier1_rgr", "B_AssaultPack_rgr", "H_HelmetB", "",
        "arifle_MX_F", "30Rnd_65x39_caseless_mag", ["optic_Holosight", "acc_pointer_IR"], 8,
        ["Exile_Item_XM8", "Exile_Item_InstaDoc", "Exile_Item_Bandage", "Exile_Item_Bandage", "Exile_Item_EnergyDrink", "Exile_Item_PlasticBottleFreshWater"]
    ]],
    ["loadoutMedium", [
        "U_B_CTRG_1", "V_PlateCarrier2_rgr", "B_Kitbag_rgr", "H_HelmetSpecB", "G_Balaclava_blk",
        "arifle_MXM_Black_F", "30Rnd_65x39_caseless_mag", ["optic_Hamr", "muzzle_snds_H", "acc_pointer_IR"], 12,
        ["Exile_Item_XM8", "Exile_Item_InstaDoc", "Exile_Item_InstaDoc", "Exile_Item_Bandage", "Exile_Item_Bandage", "Exile_Item_Vishpirin", "Exile_Item_EnergyDrink", "Exile_Item_PlasticBottleFreshWater", "Exile_Item_Matches"]
    ]],
    ["loadoutHigh", [
        "U_O_V_Soldier_Viper_hex_F", "V_PlateCarrierSpec_blk", "B_Carryall_ghex_F", "H_HelmetO_ViperSP_hex_F", "G_Balaclava_TI_blk_F",
        "arifle_SPAR_03_blk_F", "20Rnd_762x51_Mag", ["optic_DMS", "muzzle_snds_B", "acc_pointer_IR"], 14,
        ["Exile_Item_XM8", "Exile_Item_Defibrillator", "Exile_Item_InstaDoc", "Exile_Item_InstaDoc", "Exile_Item_Vishpirin", "Exile_Item_Vishpirin", "Exile_Item_CanOpener", "Exile_Item_CookingPot", "Exile_Item_Grinder", "Exile_Item_Laptop"]
    ]],
    ["loadoutGod", [
        "U_O_V_Soldier_Viper_F", "V_PlateCarrierGL_tna_F", "B_Carryall_oli", "H_HelmetO_ViperSP_ghex_F", "G_Balaclava_TI_G_tna_F",
        "srifle_DMR_02_camo_F", "10Rnd_338_Mag", ["optic_AMS_khk", "muzzle_snds_338_green", "bipod_01_F_khk"], 16,
        ["Exile_Item_XM8", "Exile_Item_Defibrillator", "Exile_Item_Defibrillator", "Exile_Item_InstaDoc", "Exile_Item_InstaDoc", "Exile_Item_Vishpirin", "Exile_Item_Vishpirin", "Exile_Item_Grinder", "Exile_Item_Laptop", "Exile_Item_ThermalScannerPro"]
    ]]
];

XCSV_fnc_ownerApplyLoadoutLocal = {
    params ["_tier"];

    private _kit = XCSV_OWNER_LoadoutKits getOrDefault [_tier, []];
    if (_kit isEqualTo []) exitWith { systemChat format ["XCSV Owner: unknown loadout %1.", _tier]; };

    _kit params ["_uniform", "_vest", "_backpack", "_headgear", "_goggles", "_weapon", "_mag", "_attachments", "_magCount", "_items"];

    removeAllWeapons player;
    removeAllItems player;
    removeAllAssignedItems player;
    removeUniform player;
    removeVest player;
    removeBackpackGlobal player;
    removeHeadgear player;
    removeGoggles player;

    player forceAddUniform _uniform;
    player addVest _vest;
    player addBackpackGlobal _backpack;
    player addHeadgear _headgear;
    if !(_goggles isEqualTo "") then { player addGoggles _goggles; };

    player addMagazines [_mag, _magCount];
    player addWeapon _weapon;
    { player addPrimaryWeaponItem _x; } forEach _attachments;

    if (_tier isEqualTo "loadoutGod") then {
        player addMagazines ["Titan_AA", 2];
        player addWeapon "launch_B_Titan_F";
    };

    {
        if (player canAdd _x) then {
            player addItem _x;
        } else {
            player addItemToBackpack _x;
        };
    } forEach _items;

    { player linkItem _x; } forEach ["Exile_Item_XM8", "ItemMap", "ItemCompass", "ItemGPS", "ItemRadio", "NVGoggles_OPFOR"];
    reload player;
    systemChat format ["XCSV Owner: %1 kit equipped locally.", _tier];
};

XCSV_fnc_ownerSetGodLocal = {
    params ["_enabled"];

    if (_enabled) then {
        player setVariable ["XCSV_OWNER_GodMode", true, true];
        player allowDamage false;
        player setDamage 0;

        private _oldEh = missionNamespace getVariable ["XCSV_OWNER_GodModeEH", -1];
        if (_oldEh >= 0) then { player removeEventHandler ["HandleDamage", _oldEh]; };

        private _eh = player addEventHandler ["HandleDamage", {
            params ["_unit", "", "_damage"];
            if (_unit getVariable ["XCSV_OWNER_GodMode", false]) exitWith { 0 };
            _damage
        }];
        missionNamespace setVariable ["XCSV_OWNER_GodModeEH", _eh];

        if (isNil "XCSV_OWNER_GodModeLoop") then {
            XCSV_OWNER_GodModeLoop = [] spawn {
                while { player getVariable ["XCSV_OWNER_GodMode", false] } do {
                    player allowDamage false;
                    player setDamage 0;
                    uiSleep 1;
                };
                XCSV_OWNER_GodModeLoop = nil;
            };
        };
        systemChat "XCSV Owner: god mode enforced locally.";
    } else {
        player setVariable ["XCSV_OWNER_GodMode", false, true];
        private _oldEh = missionNamespace getVariable ["XCSV_OWNER_GodModeEH", -1];
        if (_oldEh >= 0) then { player removeEventHandler ["HandleDamage", _oldEh]; };
        missionNamespace setVariable ["XCSV_OWNER_GodModeEH", -1];
        player allowDamage true;
        systemChat "XCSV Owner: god mode disabled locally.";
    };
};

XCSV_fnc_ownerLocal = {
    params ["_command"];

    switch (_command) do {
        case "tpSouth": { [[2265.13, 8596.37, 0], "Trader - South"] call XCSV_fnc_ownerTeleport; };
        case "tpMountain": { [[12190.4, 8167.03, 0], "Trader - Mountain"] call XCSV_fnc_ownerTeleport; };
        case "tpNorth": { [[7991.1, 12411.6, 0], "Trader - North"] call XCSV_fnc_ownerTeleport; };
        case "tpAirNorth": { [[11579.8, 13156.0, 0], "Aircraft - North"] call XCSV_fnc_ownerTeleport; };
        case "tpAirCentral": { [[7199.99, 6961.1, 0], "Aircraft - Central"] call XCSV_fnc_ownerTeleport; };
        case "tpBoatNE": { [[11074.7, 13391.8, 0], "Boat Trader - NE"] call XCSV_fnc_ownerTeleport; };
        case "tpPrison": { [[7140, 11800, 0], "Prison - Graybox"] call XCSV_fnc_ownerTeleport; };
        case "safezoneAudit": { call XCSV_fnc_ownerSafezoneAudit; };
        case "spectateNearest": { call XCSV_fnc_ownerSpectateNearest; };
        case "spectateOff": { call XCSV_fnc_ownerStopSpectate; };
        default { systemChat format ["XCSV Owner: unknown local command %1.", _command]; };
    };
};

XCSV_OWNER_ModeActions = createHashMapFromArray [
    ["loadouts", [
        "Loadouts",
        "<t size='1.05' color='#E8B339'>Owner Loadouts</t><br/><t size='0.78' color='#7E8896'>Each kit replaces your carried gear and includes weapon, ammo, armor, medical, tools, GPS/radio/NVG.</t><br/><br/><t color='#E2E7EE'>Basic</t><t color='#7E8896'> - MX 6.5mm, holo, pointer, 8 mags, light armor.</t><br/><t color='#E2E7EE'>Medium</t><t color='#7E8896'> - suppressed MXM, HAMR, pointer, 12 mags, CTRG kit.</t><br/><t color='#E2E7EE'>High</t><t color='#7E8896'> - black SPAR-17, DMS, suppressor, 14 mags, Viper armor.</t><br/><t color='#E2E7EE'>Godlike</t><t color='#7E8896'> - green MAR-10 .338, AMS khaki scope, green .338 suppressor, 16 mags, Titan AA, elite armor.</t>",
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
        [["GOD ON", "godOn"], ["GOD OFF", "godOff"], ["SPAWN TRADER", "traderSpawn"], ["DESPAWN", "traderDespawn"], ["SPAWN HUNTER", "vehicleSpawn"], ["REPAIR NEAR", "vehicleRepair"], ["FLIP VEH", "vehicleFlip"], ["UNLOCK VEH", "vehicleUnlock"]]
    ]],
    ["teleport", [
        "Teleport",
        "<t size='1.05' color='#E8B339'>Teleport Favorites</t><br/><t size='0.78' color='#7E8896'>Fast owner routes for testing traders, vehicle routes, aircraft, and staged mission locations. Teleport still uses the existing server-authorized teleport request path.</t>",
        [["SOUTH", "local:tpSouth"], ["MOUNTAIN", "local:tpMountain"], ["NORTH", "local:tpNorth"], ["AIR NORTH", "local:tpAirNorth"], ["AIR MID", "local:tpAirCentral"], ["BOAT NE", "local:tpBoatNE"], ["PRISON", "local:tpPrison"], ["SAFE AUDIT", "local:safezoneAudit"]]
    ]],
    ["assist", [
        "Assist",
        "<t size='1.05' color='#E8B339'>Player Assist</t><br/><t size='0.78' color='#7E8896'>Nearest-player tools for support and report checks. Economy actions target the nearest alive non-owner player within 80m, so stand near the player you mean to help.</t>",
        [["HEAL NEAR", "healNearestPlayer"], ["BRING NEAR", "bringNearestPlayer"], ["TP TO NEAR", "tpToNearestPlayer"], ["+10K TABS", "tabsNearest10k"], ["+10K RESPECT", "respectNearest10k"], ["SPECTATE", "local:spectateNearest"], ["STOP SPEC", "local:spectateOff"]]
    ]],
    ["server", [
        "Director",
        "<t size='1.05' color='#E8B339'>Server Director</t><br/><t size='0.78' color='#7E8896'>Mission, health, cleanup, test-crate, and cinematic world controls. Cleanup only deletes owner-spawned objects or tagged XCSV scene objects.</t>",
        [["HEALTH", "healthSnapshot"], ["RUN COURIER", "missionCourier"], ["TEST CRATE", "crateTest"], ["LOOT CRATE", "crateLoot"], ["CLEAN 10M", "cleanupRadius10"], ["MORNING", "timeMorning"], ["MIDDAY", "timeNoon"], ["SUNSET", "timeSunset"]]
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
    private _command = (_actions select _index) select 1;
    if ((_command select [0, 6]) isEqualTo "local:") exitWith {
        [_command select [6, (count _command) - 6]] call XCSV_fnc_ownerLocal;
    };
    [_command] call XCSV_fnc_ownerSend;
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

    if (_command isEqualTo "healthSnapshot") exitWith {
        _payload params ["_fps", "_players", "_objects", "_ownerObjects", "_courierSpawned", "_uptime"];
        private _html = format [
            "<t size='1.05' color='#E8B339'>Server Health</t><br/><br/><t color='#7E8896'>Server FPS</t><t color='#E2E7EE'> %1</t><br/><t color='#7E8896'>Players</t><t color='#E2E7EE'> %2</t><br/><t color='#7E8896'>Objects</t><t color='#E2E7EE'> %3</t><br/><t color='#7E8896'>Owner Objects</t><t color='#E2E7EE'> %4</t><br/><t color='#7E8896'>Courier Spawned</t><t color='#E2E7EE'> %5</t><br/><t color='#7E8896'>Uptime</t><t color='#E2E7EE'> %6s</t>",
            _fps, _players, _objects, _ownerObjects, _courierSpawned, _uptime
        ];
        private _display = uiNamespace getVariable ["RscExileXM8", displayNull];
        if !(isNull _display) then {
            private _body = _display displayCtrl 71881;
            if !(isNull _body) then { _body ctrlSetStructuredText parseText _html; };
        };
        systemChat "XCSV Owner: health snapshot updated.";
    };

    if (_command isEqualTo "applyLoadout") exitWith {
        _payload params ["_tier"];
        [_tier] call XCSV_fnc_ownerApplyLoadoutLocal;
    };

    if (_command isEqualTo "godMode") exitWith {
        _payload params ["_enabled"];
        [_enabled] call XCSV_fnc_ownerSetGodLocal;
    };
};

diag_log "[XCSV_OWNER] Owner Tools client app ready.";
