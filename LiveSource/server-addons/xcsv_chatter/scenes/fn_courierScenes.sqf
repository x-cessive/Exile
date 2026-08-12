/*
    xcsv_chatter\scenes\fn_courierScenes.sqf

    Server-side authored scene slice: poptab courier vans that did not make it.
    Each scene is bounded and restart-local: wreck prop, dead couriers with
    carried poptabs, and one locked safe with a larger payout. No DB rows are
    created and no client receives object-creation authority.
*/

if (!isServer) exitWith {};
if (missionNamespace getVariable ["XCSV_SCENE_CouriersSpawned", false]) exitWith {};
missionNamespace setVariable ["XCSV_SCENE_CouriersSpawned", true];

private _maxScenes = 2;
private _objects = [];
private _markers = [];

private _anchors = [
    ["Lijnhaven road", [2283.58, 8591.60, 0], 80],
    ["Savu back road", [7986.06, 12437.40, 0], 260],
    ["Harcourt jungle road", [6120.00, 10520.00, 0], 40],
    ["Oumere north road", [12176.90, 8185.49, 0], 120],
    ["Georgetown old supply route", [5600.00, 9800.00, 0], 310]
];

private _bodyTypes = [
    "I_C_Soldier_Bandit_1_F",
    "I_C_Soldier_Bandit_2_F",
    "I_C_Soldier_Bandit_3_F",
    "I_C_Soldier_Bandit_4_F",
    "I_C_Soldier_Bandit_5_F"
];

private _bodyAnimations = [
    "AinjPpneMstpSnonWnonDnon",
    "AinjPpneMstpSnonWrflDnon"
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

private _selected = +_anchors;
_selected = _selected call BIS_fnc_arrayShuffle;
_selected resize (_maxScenes min (count _selected));

{
    private _sceneNumber = _forEachIndex + 1;
    private _sceneId = format ["courier-%1-%2", diag_tickTime, _sceneNumber];
    private _pose = [_x] call _fnc_roadPose;
    private _pos = _pose select 0;
    private _dir = _pose select 1;
    private _label = _x select 0;

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

    for "_i" from 0 to 2 do {
        private _offset = [
            [-2.0, -1.0, 0],
            [1.6, 1.4, 0],
            [-0.8, 3.0, 0]
        ] select _i;
        private _bodyPos = _wreck modelToWorld _offset;
        private _group = createGroup independent;
        private _unit = _group createUnit [selectRandom _bodyTypes, _bodyPos, [], 0, "CAN_COLLIDE"];
        _unit setDir (_dir + 70 + random 180);
        _unit setPosATL [_bodyPos select 0, _bodyPos select 1, 0];
        _unit setUnitPos "DOWN";
        removeAllWeapons _unit;
        removeBackpackGlobal _unit;
        removeHeadgear _unit;
        removeVest _unit;
        removeAllAssignedItems _unit;
        _unit disableAI "MOVE";
        _unit switchMove (selectRandom _bodyAnimations);
        _unit disableAI "ANIM";
        _unit setVariable ["ExileMoney", 450 + floor (random 1600), true];
        _unit setVariable ["ExileName", "Courier", true];
        [_unit, _sceneId] call _fnc_tag;
        _unit setDamage 1;
    };

    private _smoke = createVehicle ["test_EmptyObjectForSmoke", _wreck modelToWorld [-1.2, -1.8, 0.1], [], 0, "CAN_COLLIDE"];
    [_smoke, _sceneId] call _fnc_tag;

    format [
        "SALVAGE NET: A poptab courier van went dark near %1. Runners are down. Bring a grinder if you find the lockbox.",
        _label
    ] remoteExecCall ["systemChat", -2];

    private _areaMarker = createMarker [format ["XCSV_SCENE_%1_area", _sceneId], _pos];
    _areaMarker setMarkerShape "ELLIPSE";
    _areaMarker setMarkerSize [180, 180];
    _areaMarker setMarkerColor "ColorOrange";
    _areaMarker setMarkerBrush "Border";
    _areaMarker setMarkerAlpha 0.65;
    _markers pushBack _areaMarker;

    private _iconMarker = createMarker [format ["XCSV_SCENE_%1_icon", _sceneId], _pos];
    _iconMarker setMarkerShape "ICON";
    _iconMarker setMarkerType "hd_destroy";
    _iconMarker setMarkerColor "ColorOrange";
    _iconMarker setMarkerText "SALVAGE: Courier Wreck";
    _markers pushBack _iconMarker;

    diag_log format [
        "[XCSV_SCENE] courier scene %1 spawned near %2 at %3 with %4 objects, safe poptabs %5.",
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
