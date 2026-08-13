/*
    xcsv_chatter\scenes\fn_courierScenes.sqf

    Server-side authored scene slice: poptab courier vans under armed guard.
    Each scene is bounded and restart-local: wreck prop, live guards around
    the lockbox, and one locked safe with a larger payout. No DB rows are
    created and no client receives object-creation authority.
*/

if (!isServer) exitWith {};
if (missionNamespace getVariable ["XCSV_SCENE_CouriersSpawned", false]) exitWith {};
missionNamespace setVariable ["XCSV_SCENE_CouriersSpawned", true];

private _maxScenes = 2;
private _safezoneExclusionRadius = 1000;
private _restrictedMarkerTypes = ["ExileTraderZone", "ExileTraderZoneIcon"];
private _objects = [];
private _markers = [];

private _anchors = [
    ["Lijnhaven road", [2283.58, 8591.60, 0], 80],
    ["Savu back road", [7986.06, 12437.40, 0], 260],
    ["Harcourt jungle road", [6120.00, 10520.00, 0], 40],
    ["Oumere north road", [12176.90, 8185.49, 0], 120],
    ["Georgetown old supply route", [5600.00, 9800.00, 0], 310]
];

private _guardTypes = [
    "O_G_Soldier_F",
    "O_G_Soldier_lite_F",
    "O_G_Soldier_AR_F"
];

private _guardLoadouts = [
    ["U_O_V_Soldier_Viper_F",     "V_PlateCarrierGL_tna_F",  "H_HelmetO_ViperSP_ghex_F", "arifle_ARX_ghex_F",     "30Rnd_65x39_caseless_green", "optic_Hamr_khk_F", "muzzle_snds_65_TI_ghex_F"],
    ["U_O_V_Soldier_Viper_hex_F", "V_PlateCarrierSpec_blk",  "H_HelmetO_ViperSP_hex_F",  "arifle_SPAR_03_blk_F",  "20Rnd_762x51_Mag",           "optic_DMS",        "muzzle_snds_B"],
    ["U_O_T_Soldier_F",           "V_PlateCarrierGL_blk",    "H_HelmetLeaderO_ghex_F",   "arifle_MX_SW_Black_F",  "100Rnd_65x39_caseless_mag",  "optic_Hamr",       "muzzle_snds_H_MG_blk_F"]
];

private _fnc_tag = {
    params ["_object", "_sceneId"];
    _object setVariable ["XCSV_SCENE", "CourierVan", true];
    _object setVariable ["XCSV_SCENE_ID", _sceneId, true];
    _object setVariable ["ExileIsPersistent", false, true];
    _objects pushBack _object;
};

private _fnc_roadPose = {
    params ["_anchor"];
    private _pos = _anchor select 1;
    private _dir = _anchor select 2;
    private _roads = _pos nearRoads 300;
    if !(_roads isEqualTo []) then {
        private _road = selectRandom _roads;
        _pos = getPosATL _road;
        private _connected = roadsConnectedTo _road;
        if !(_connected isEqualTo []) then {
            _dir = _road getDir (_connected select 0);
        };
    };
    [_pos, _dir]
};

private _fnc_isRestrictedPosition = {
    params ["_pos"];

    private _blocked = false;
    {
        if ((getMarkerType _x) in _restrictedMarkerTypes) then {
            if ((_pos distance2D (getMarkerPos _x)) < _safezoneExclusionRadius) exitWith {
                _blocked = true;
            };
        };
    } forEach allMapMarkers;
    _blocked
};

private _candidates = [];
{
    private _pose = [_x] call _fnc_roadPose;
    private _pos = _pose select 0;
    if ([_pos] call _fnc_isRestrictedPosition) then {
        diag_log format [
            "[XCSV_SCENE] courier anchor %1 rejected at %2: within %3m of trader/safezone marker.",
            _x select 0,
            _pos,
            _safezoneExclusionRadius
        ];
    } else {
        _candidates pushBack [_x, _pose];
    };
} forEach ((_anchors call BIS_fnc_arrayShuffle));

private _selected = +_candidates;
_selected resize (_maxScenes min (count _selected));

{
    private _sceneNumber = _forEachIndex + 1;
    private _sceneId = format ["courier-%1-%2", diag_tickTime, _sceneNumber];
    private _anchor = _x select 0;
    private _pose = _x select 1;
    private _pos = _pose select 0;
    private _dir = _pose select 1;
    private _label = _anchor select 0;

    private _wreck = createVehicle ["Land_Wreck_Van_F", _pos, [], 0, "CAN_COLLIDE"];
    _wreck setDir _dir;
    _wreck setPosATL _pos;
    _wreck setVectorUp (surfaceNormal _pos);
    [_wreck, _sceneId] call _fnc_tag;

    private _safePos = _wreck modelToWorld [2.8, -2.4, 0];
    _safePos set [2, 0];
    private _safe = createVehicle ["Exile_Container_Safe_Small", _safePos, [], 0, "CAN_COLLIDE"];
    _safe setDir (_dir + 25);
    _safe setPosATL _safePos;
    _safe setPosATL [_safePos select 0, _safePos select 1, -0.08];
    _safe setVectorUp (surfaceNormal _safePos);
    clearWeaponCargoGlobal _safe;
    clearItemCargoGlobal _safe;
    clearMagazineCargoGlobal _safe;
    clearBackpackCargoGlobal _safe;
    _safe setVariable ["ExileIsLocked", -1, true];
    _safe setVariable ["ExileAccessCode", "0000", true];
    _safe setVariable ["ExileOwnerUID", "XCSV_SCENE", true];
    _safe setVariable ["ExileMoney", 8500 + floor (random 9500), true];
    [_safe, _sceneId] call _fnc_tag;

    private _guardGroup = createGroup [east, true];
    _guardGroup setCombatMode "RED";
    _guardGroup setBehaviour "AWARE";
    _guardGroup enableAttack true;

    for "_i" from 0 to 2 do {
        private _offset = [
            [-5.0, -1.5, 0],
            [4.5, 2.0, 0],
            [-1.0, 6.0, 0]
        ] select _i;
        private _guardPos = _wreck modelToWorld _offset;
        private _unit = _guardGroup createUnit [selectRandom _guardTypes, _guardPos, [], 0, "CAN_COLLIDE"];
        private _kit = _guardLoadouts select (_i mod (count _guardLoadouts));
        _unit setDir (_dir + 70 + random 180);
        _unit setPosATL [_guardPos select 0, _guardPos select 1, 0];
        removeAllWeapons _unit;
        removeUniform _unit;
        removeVest _unit;
        removeHeadgear _unit;
        removeBackpackGlobal _unit;
        removeAllAssignedItems _unit;
        _unit forceAddUniform (_kit select 0);
        _unit addVest (_kit select 1);
        _unit addHeadgear (_kit select 2);
        _unit addMagazines [_kit select 4, 6];
        _unit addWeapon (_kit select 3);
        _unit addPrimaryWeaponItem (_kit select 5);
        _unit addPrimaryWeaponItem (_kit select 6);
        _unit linkItem "ItemMap";
        _unit linkItem "ItemCompass";
        _unit linkItem "ItemGPS";
        _unit linkItem "NVGoggles_OPFOR";
        _unit setSkill ["aimingAccuracy", 0.28];
        _unit setSkill ["aimingShake", 0.35];
        _unit setSkill ["spotDistance", 0.55];
        _unit setSkill ["courage", 0.75];
        _unit setUnitPos "MIDDLE";
        _unit doWatch _safe;
        _unit setVariable ["ExileMoney", 3500 + floor (random 4500), true];
        _unit setVariable ["ExileName", "Courier Guard", true];
        [_unit, _sceneId] call _fnc_tag;
    };

    private _guardWaypoint = _guardGroup addWaypoint [_safePos, 18];
    _guardWaypoint setWaypointType "SAD";
    _guardWaypoint setWaypointBehaviour "AWARE";
    _guardWaypoint setWaypointCombatMode "RED";

    private _smoke = createVehicle ["test_EmptyObjectForSmoke", _wreck modelToWorld [-1.2, -1.8, 0.1], [], 0, "CAN_COLLIDE"];
    [_smoke, _sceneId] call _fnc_tag;

    format [
        "SALVAGE NET: A poptab courier van went dark near %1. Guards are holding the wreck and safe. Bring a grinder and backup.",
        _label
    ] remoteExecCall ["systemChat", -2];

    private _areaMarker = createMarker [format ["XCSV_SCENE_%1_area", _sceneId], _pos];
    _areaMarker setMarkerShape "ELLIPSE";
    _areaMarker setMarkerSize [120, 120];
    _areaMarker setMarkerColor "ColorOrange";
    _areaMarker setMarkerBrush "Border";
    _areaMarker setMarkerAlpha 0.28;
    _markers pushBack _areaMarker;

    private _iconMarker = createMarker [format ["XCSV_SCENE_%1_icon", _sceneId], _pos];
    _iconMarker setMarkerShape "ICON";
    _iconMarker setMarkerType "mil_box";
    _iconMarker setMarkerColor "ColorOrange";
    _iconMarker setMarkerText "Cash Van";
    _markers pushBack _iconMarker;

    diag_log format [
        "[XCSV_SCENE] guarded courier scene %1 spawned near %2 at %3 with %4 objects, safe poptabs %5.",
        _sceneId,
        _label,
        _pos,
        6,
        _safe getVariable ["ExileMoney", 0]
    ];
} forEach _selected;

missionNamespace setVariable ["XCSV_SCENE_CourierObjects", _objects, false];
missionNamespace setVariable ["XCSV_SCENE_CourierMarkers", _markers, false];

diag_log format ["[XCSV_SCENE] courier scene spawn complete: %1 scene(s), %2 object(s), %3 marker(s).", count _selected, count _objects, count _markers];

true
