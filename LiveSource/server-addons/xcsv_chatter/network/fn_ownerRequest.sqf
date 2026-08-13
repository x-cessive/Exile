/*
    xcsv_chatter\network\fn_ownerRequest.sqf - SERVER side

    Owner Tools (XM8 App23). This is intentionally not a generic admin console:
    the client sends one fixed command string, and this handler re-resolves the
    session and UID before applying server-owned effects.
*/

private _sessionID = _this select 0;
private _params = _this select 1;

XCSV_OWNER_SERVER_ADMINS = [
    "76561198108041726"     // Mr. Sage
];

private _fnc_toast = {
    params ["_title", "_body", ["_kind", "SuccessTitleAndText"]];
    [_sessionID, "toastRequest", [_kind, [_title, _body]]]
        call ExileServer_system_network_send_to;
};

private _fnc_ownerClient = {
    params ["_command", ["_payload", []]];
    [_sessionID, "xcsvOwnerResponse", [_command, _payload]]
        call ExileServer_system_network_send_to;
};

private _fnc_addTabs = {
    params ["_playerObject", "_amount"];
    private _money = (_playerObject getVariable ["ExileMoney", 0]) + _amount;
    _playerObject setVariable ["ExileMoney", _money, true];
    format ["setPlayerMoney:%1:%2", _money, _playerObject getVariable ["ExileDatabaseID", 0]]
        call ExileServer_system_database_query_fireAndForget;
    _money
};

private _fnc_addRespect = {
    params ["_playerObject", "_amount"];
    private _uid = getPlayerUID _playerObject;
    private _score = (_playerObject getVariable ["ExileScore", 0]) + _amount;
    _playerObject setVariable ["ExileScore", _score, true];
    format ["setAccountScore:%1:%2", _score, _uid]
        call ExileServer_system_database_query_fireAndForget;
    _score
};

private _fnc_ownerObjects = {
    params ["_uid"];
    missionNamespace getVariable [format ["XCSV_OWNER_OBJECTS_%1", _uid], []]
};

private _fnc_setOwnerObjects = {
    params ["_uid", "_objects"];
    missionNamespace setVariable [format ["XCSV_OWNER_OBJECTS_%1", _uid], _objects select { !(isNull _x) }];
};

private _fnc_nearestPlayer = {
    params ["_playerObject", ["_range", 80]];
    private _candidates = allPlayers select {
        _x != _playerObject
        && { alive _x }
        && { isPlayer _x }
        && {!((getPlayerUID _x) isEqualTo "")}
        && { (_x distance2D _playerObject) <= _range }
    };
    if (_candidates isEqualTo []) exitWith { objNull };
    private _ranked = _candidates apply { [_x distance2D _playerObject, _x] };
    _ranked sort true;
    (_ranked select 0) select 1
};

private _fnc_cleanupRadius = {
    params ["_playerObject", "_uid", "_radius"];
    private _targets = nearestObjects [_playerObject, [], _radius];
    private _count = 0;
    {
        if (
            !(_x isEqualTo _playerObject)
            && {!(_x isKindOf "Man")}
            && {
                ((_x getVariable ["XCSV_OWNER_UID", ""]) isEqualTo _uid)
                || {!((_x getVariable ["XCSV_SCENE", ""]) isEqualTo "")}
            }
        ) then {
            deleteVehicle _x;
            _count = _count + 1;
        };
    } forEach _targets;
    _count
};

private _fnc_spawnCrate = {
    params ["_playerObject", "_uid", "_tier"];

    private _pos = _playerObject modelToWorld [0, 4, 0];
    _pos set [2, 0];
    private _crate = "Exile_Container_SupplyBox" createVehicle _pos;
    clearWeaponCargoGlobal _crate;
    clearMagazineCargoGlobal _crate;
    clearItemCargoGlobal _crate;
    clearBackpackCargoGlobal _crate;

    if (_tier isEqualTo "test") then {
        _crate addItemCargoGlobal ["Exile_Item_InstaDoc", 5];
        _crate addItemCargoGlobal ["Exile_Item_Bandage", 10];
        _crate addItemCargoGlobal ["Exile_Item_EnergyDrink", 5];
        _crate addItemCargoGlobal ["Exile_Item_PlasticBottleFreshWater", 5];
    } else {
        _crate addWeaponCargoGlobal ["arifle_SPAR_03_blk_F", 2];
        _crate addMagazineCargoGlobal ["20Rnd_762x51_Mag", 20];
        _crate addItemCargoGlobal ["optic_DMS", 2];
        _crate addItemCargoGlobal ["muzzle_snds_B", 2];
        _crate addItemCargoGlobal ["Exile_Item_Defibrillator", 2];
        _crate addItemCargoGlobal ["Exile_Item_Grinder", 2];
        _crate addBackpackCargoGlobal ["B_Carryall_ghex_F", 2];
    };

    _crate setVariable ["XCSV_OWNER_KIND", "crate", true];
    _crate setVariable ["XCSV_OWNER_UID", _uid, true];
    _crate
};

private _fnc_applyLoadout = {
    params ["_playerObject", "_tier"];

    private _kits = createHashMapFromArray [
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

    private _kit = _kits getOrDefault [_tier, []];
    if (_kit isEqualTo []) throw "Unknown loadout.";

    _kit params ["_uniform", "_vest", "_backpack", "_headgear", "_goggles", "_weapon", "_mag", "_attachments", "_magCount", "_items"];

    removeAllWeapons _playerObject;
    removeAllItems _playerObject;
    removeAllAssignedItems _playerObject;
    removeUniform _playerObject;
    removeVest _playerObject;
    removeBackpackGlobal _playerObject;
    removeHeadgear _playerObject;
    removeGoggles _playerObject;

    _playerObject forceAddUniform _uniform;
    _playerObject addVest _vest;
    _playerObject addBackpackGlobal _backpack;
    _playerObject addHeadgear _headgear;
    if !(_goggles isEqualTo "") then { _playerObject addGoggles _goggles; };

    _playerObject addMagazines [_mag, _magCount];
    _playerObject addWeapon _weapon;
    { _playerObject addPrimaryWeaponItem _x; } forEach _attachments;

    if (_tier isEqualTo "loadoutGod") then {
        _playerObject addMagazines ["Titan_AA", 2];
        _playerObject addWeapon "launch_B_Titan_F";
    };

    {
        if (_playerObject canAdd _x) then {
            _playerObject addItem _x;
        } else {
            _playerObject addItemToBackpack _x;
        };
    } forEach _items;

    {
        _playerObject linkItem _x;
    } forEach ["ItemMap", "ItemCompass", "ItemGPS", "ItemRadio", "NVGoggles_OPFOR"];
};

try {
    private _playerObject = _sessionID call ExileServer_system_session_getPlayerObject;
    if (isNull _playerObject) throw "Invalid owner session.";
    if !(alive _playerObject) throw "Owner Tools cannot run while dead.";

    private _uid = getPlayerUID _playerObject;
    if !(_uid in XCSV_OWNER_SERVER_ADMINS) throw "Not authorised.";

    private _command = _params select 0;
    if !(_command isEqualType "") throw "Invalid command.";

    private _objects = [_uid] call _fnc_ownerObjects;

    switch (_command) do {
        case "loadoutBasic": {
            [_playerObject, _command] call _fnc_applyLoadout;
            ["applyLoadout", [_command]] call _fnc_ownerClient;
            ["Owner loadout", format ["Applied %1 with local weapon/ammo sync.", _command]] call _fnc_toast;
        };
        case "loadoutMedium": {
            [_playerObject, _command] call _fnc_applyLoadout;
            ["applyLoadout", [_command]] call _fnc_ownerClient;
            ["Owner loadout", format ["Applied %1 with local weapon/ammo sync.", _command]] call _fnc_toast;
        };
        case "loadoutHigh": {
            [_playerObject, _command] call _fnc_applyLoadout;
            ["applyLoadout", [_command]] call _fnc_ownerClient;
            ["Owner loadout", format ["Applied %1 with local weapon/ammo sync.", _command]] call _fnc_toast;
        };
        case "loadoutGod": {
            [_playerObject, _command] call _fnc_applyLoadout;
            ["applyLoadout", [_command]] call _fnc_ownerClient;
            ["Owner loadout", format ["Applied %1 with local weapon/ammo sync.", _command]] call _fnc_toast;
        };

        case "tabs10k": {
            private _money = [_playerObject, 10000] call _fnc_addTabs;
            ["Owner economy", format ["Added 10,000 poptabs. Carrying %1.", _money]] call _fnc_toast;
        };
        case "tabs100k": {
            private _money = [_playerObject, 100000] call _fnc_addTabs;
            ["Owner economy", format ["Added 100,000 poptabs. Carrying %1.", _money]] call _fnc_toast;
        };
        case "shoppingBankroll": {
            private _money = [_playerObject, 10000000] call _fnc_addTabs;
            ["Owner market", format ["Added 10,000,000 shopping poptabs. Carrying %1.", _money]] call _fnc_toast;
        };

        case "respect10k": {
            private _score = [_playerObject, 10000] call _fnc_addRespect;
            ["Owner respect", format ["Added 10,000 respect. Score %1.", _score]] call _fnc_toast;
        };
        case "respect100k": {
            private _score = [_playerObject, 100000] call _fnc_addRespect;
            ["Owner respect", format ["Added 100,000 respect. Score %1.", _score]] call _fnc_toast;
        };

        case "godOn": {
            _playerObject allowDamage false;
            _playerObject setVariable ["XCSV_OWNER_GodMode", true, true];
            ["godMode", [true]] call _fnc_ownerClient;
            ["Owner god mode", "God mode enabled."] call _fnc_toast;
        };
        case "godOff": {
            _playerObject allowDamage true;
            _playerObject setVariable ["XCSV_OWNER_GodMode", false, true];
            ["godMode", [false]] call _fnc_ownerClient;
            ["Owner god mode", "God mode disabled."] call _fnc_toast;
        };

        case "traderSpawn": {
            private _pos = _playerObject modelToWorld [0, 3.2, 0];
            _pos set [2, 0];
            ["traderSpawnLocal", [_pos, getDir _playerObject + 180]] call _fnc_ownerClient;
            ["Owner market", "Portable owner trader spawned. Use Shopping Bankroll for zero-friction purchases."] call _fnc_toast;
        };
        case "traderDespawn": {
            ["traderDespawnLocal", []] call _fnc_ownerClient;
            ["Owner market", "Portable owner trader despawn requested."] call _fnc_toast;
        };

        case "vehicleSpawn": {
            private _pos = _playerObject modelToWorld [0, 8, 0];
            _pos set [2, 0.2];
            private _veh = createVehicle ["Exile_Car_Hunter", _pos, [], 0, "CAN_COLLIDE"];
            _veh setDir (getDir _playerObject);
            _veh setVariable ["ExileOwnerUID", _uid, true];
            _veh setVariable ["ExileIsLocked", -1, true];
            _veh setVariable ["ExileIsPersistent", false, true];
            _veh setVariable ["XCSV_OWNER_KIND", "vehicle", true];
            _veh setVariable ["XCSV_OWNER_UID", _uid, true];
            _veh setFuel 1;
            _veh setDamage 0;
            _objects pushBack _veh;
            [_uid, _objects] call _fnc_setOwnerObjects;
            ["Owner vehicle pad", "Spawned non-persistent Hunter."] call _fnc_toast;
        };
        case "vehicleRepair": {
            private _near = nearestObjects [_playerObject, ["LandVehicle", "Air", "Ship"], 25];
            if (_near isEqualTo []) throw "No vehicle within 25m.";
            private _veh = _near select 0;
            _veh setDamage 0;
            _veh setFuel 1;
            _veh setVehicleAmmo 1;
            ["Owner vehicle pad", format ["Repaired/refueled %1.", typeOf _veh]] call _fnc_toast;
        };
        case "vehicleFlip": {
            private _near = nearestObjects [_playerObject, ["LandVehicle", "Air", "Ship"], 25];
            if (_near isEqualTo []) throw "No vehicle within 25m.";
            private _veh = _near select 0;
            _veh setVectorUp [0, 0, 1];
            _veh setPosATL [(getPosATL _veh) select 0, (getPosATL _veh) select 1, 0.25];
            ["Owner vehicle pad", format ["Flipped %1.", typeOf _veh]] call _fnc_toast;
        };
        case "vehicleUnlock": {
            private _near = nearestObjects [_playerObject, ["LandVehicle", "Air", "Ship"], 25];
            if (_near isEqualTo []) throw "No vehicle within 25m.";
            private _veh = _near select 0;
            _veh lock 0;
            _veh setVariable ["ExileIsLocked", -1, true];
            ["Owner vehicle pad", format ["Unlocked %1.", typeOf _veh]] call _fnc_toast;
        };

        case "healNearestPlayer": {
            private _target = [_playerObject, 80] call _fnc_nearestPlayer;
            if (isNull _target) throw "No alive player within 80m.";
            _target setDamage 0;
            ["Owner assist", format ["Healed %1.", name _target]] call _fnc_toast;
        };
        case "bringNearestPlayer": {
            private _target = [_playerObject, 80] call _fnc_nearestPlayer;
            if (isNull _target) throw "No alive player within 80m.";
            private _pos = _playerObject modelToWorld [0, 2, 0];
            _pos set [2, 0.2];
            vehicle _target setPosATL _pos;
            ["Owner assist", format ["Brought %1.", name _target]] call _fnc_toast;
        };
        case "tpToNearestPlayer": {
            private _target = [_playerObject, 80] call _fnc_nearestPlayer;
            if (isNull _target) throw "No alive player within 80m.";
            private _pos = getPosATL _target;
            _pos set [2, 0.2];
            vehicle _playerObject setPosATL _pos;
            ["Owner assist", format ["Moved to %1.", name _target]] call _fnc_toast;
        };
        case "tabsNearest10k": {
            private _target = [_playerObject, 80] call _fnc_nearestPlayer;
            if (isNull _target) throw "No alive player within 80m.";
            [_target, 10000] call _fnc_addTabs;
            ["Owner assist", format ["Added 10,000 tabs to %1.", name _target]] call _fnc_toast;
        };
        case "respectNearest10k": {
            private _target = [_playerObject, 80] call _fnc_nearestPlayer;
            if (isNull _target) throw "No alive player within 80m.";
            [_target, 10000] call _fnc_addRespect;
            ["Owner assist", format ["Added 10,000 respect to %1.", name _target]] call _fnc_toast;
        };

        case "missionCourier": {
            missionNamespace setVariable ["XCSV_SCENE_CouriersSpawned", false];
            call xcsv_chatter_fnc_courierScenes;
            ["Owner mission control", "Courier scene trigger requested."] call _fnc_toast;
        };
        case "healthSnapshot": {
            private _payload = [
                round (diag_fps * 10) / 10,
                count allPlayers,
                count (allMissionObjects "All"),
                count (_objects select { !(isNull _x) }),
                missionNamespace getVariable ["XCSV_SCENE_CouriersSpawned", false],
                round diag_tickTime
            ];
            ["healthSnapshot", _payload] call _fnc_ownerClient;
            ["Owner director", "Health snapshot sent."] call _fnc_toast;
        };
        case "crateTest": {
            private _crate = [_playerObject, _uid, "test"] call _fnc_spawnCrate;
            _objects pushBack _crate;
            [_uid, _objects] call _fnc_setOwnerObjects;
            ["Owner crate", "Spawned owner test crate."] call _fnc_toast;
        };
        case "crateLoot": {
            private _crate = [_playerObject, _uid, "loot"] call _fnc_spawnCrate;
            _objects pushBack _crate;
            [_uid, _objects] call _fnc_setOwnerObjects;
            ["Owner crate", "Spawned owner loot crate."] call _fnc_toast;
        };

        case "cleanupNearest": {
            private _near = nearestObjects [_playerObject, [], 15];
            private _target = objNull;
            {
                if (
                    !(_x isEqualTo _playerObject)
                    && {!(_x isKindOf "Man")}
                    && {
                        ((_x getVariable ["XCSV_OWNER_UID", ""]) isEqualTo _uid)
                        || {!((_x getVariable ["XCSV_SCENE", ""]) isEqualTo "")}
                    }
                ) exitWith {
                    _target = _x;
                };
            } forEach _near;
            if (isNull _target) throw "No owner/XCSV scene object within 15m.";
            private _kind = typeOf _target;
            deleteVehicle _target;
            ["Owner cleanup", format ["Deleted nearest %1.", _kind]] call _fnc_toast;
        };
        case "cleanupRadius10": {
            private _count = [_playerObject, _uid, 10] call _fnc_cleanupRadius;
            ["Owner cleanup", format ["Deleted %1 tagged object(s) within 10m.", _count]] call _fnc_toast;
        };
        case "cleanupRadius25": {
            private _count = [_playerObject, _uid, 25] call _fnc_cleanupRadius;
            ["Owner cleanup", format ["Deleted %1 tagged object(s) within 25m.", _count]] call _fnc_toast;
        };
        case "cleanupRadius50": {
            private _count = [_playerObject, _uid, 50] call _fnc_cleanupRadius;
            ["Owner cleanup", format ["Deleted %1 tagged object(s) within 50m.", _count]] call _fnc_toast;
        };
        case "clearAdminObjects": {
            private _count = 0;
            {
                if !(isNull _x) then {
                    deleteVehicle _x;
                    _count = _count + 1;
                };
            } forEach _objects;
            [_uid, []] call _fnc_setOwnerObjects;
            ["Owner cleanup", format ["Deleted %1 owner-spawned object(s).", _count]] call _fnc_toast;
        };

        case "weatherClear": {
            0 setOvercast 0;
            0 setRain 0;
            0 setFog 0;
            forceWeatherChange;
            ["Owner director", "Weather cleared."] call _fnc_toast;
        };
        case "weatherStorm": {
            30 setOvercast 1;
            30 setRain 0.8;
            30 setFog 0.18;
            forceWeatherChange;
            ["Owner director", "Storm weather requested."] call _fnc_toast;
        };
        case "timeNoon": {
            skipTime ((12 - daytime + 24) mod 24);
            ["Owner director", "Time shifted to noon."] call _fnc_toast;
        };
        case "timeNight": {
            skipTime ((22 - daytime + 24) mod 24);
            ["Owner director", "Time shifted to night."] call _fnc_toast;
        };
        case "timeMorning": {
            60 setOvercast 0.18;
            60 setRain 0;
            60 setFog 0.03;
            skipTime ((6 - daytime + 24) mod 24);
            forceWeatherChange;
            ["Owner director", "Time shifted to morning preset."] call _fnc_toast;
        };
        case "timeSunset": {
            60 setOvercast 0.35;
            60 setRain 0;
            60 setFog 0.05;
            skipTime ((18 - daytime + 24) mod 24);
            forceWeatherChange;
            ["Owner director", "Time shifted to sunset preset."] call _fnc_toast;
        };

        default {
            throw format ["Unknown owner command '%1'.", _command];
        };
    };

    diag_log format ["[XCSV_OWNER] %1 ran %2", _uid, _command];
}
catch {
    ["Owner Tools", _exception, "ErrorTitleAndText"] call _fnc_toast;
    diag_log format ["[XCSV_OWNER] refused: %1", _exception];
};

true
