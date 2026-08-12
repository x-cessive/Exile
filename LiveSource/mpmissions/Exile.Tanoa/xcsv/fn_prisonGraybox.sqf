/*
    xcsv/fn_prisonGraybox.sqf - SERVER side temporary graybox for
    PRISON-GRAYBOX-001, site A_NORTH_CENTRAL_COAST.

    Architect selected site A on 2026-08-12 and asked to test it live. The
    Eden-only builder (tools\eden\prison_graybox_build.sqf) cannot run
    headlessly, so this runtime spawn mirrors the same site record, local-to-
    world math and classnames. Objects are terrain-snapped with setPosATL, so
    the engine handles slope; no mission.sqm Z values are hand-baked.

    This is a TEMPORARY TEST GRAYBOX. It is not the accepted geometry. Once
    Architect visually accepts the layout, the canonical representation moves
    back to Eden-authored mission source via the tools\eden builder, and this
    spawn is removed. Gated by XCSV_PRISON_GRAYBOX_TEST (server).
*/

if (!isServer) exitWith {};
if (isNil "XCSV_PRISON_GRAYBOX_TEST") then { XCSV_PRISON_GRAYBOX_TEST = true; };
if (!XCSV_PRISON_GRAYBOX_TEST) exitWith {
    diag_log "[PRISON-GRAYBOX-001] disabled (XCSV_PRISON_GRAYBOX_TEST false)";
};

private _siteId      = "A_NORTH_CENTRAL_COAST";
private _siteAnchor  = [7140, 11800, 0];
private _siteHeading = 35;
private _footprint   = [520, 360];
_footprint params ["_width", "_length"];
private _hw = _width / 2;
private _hl = _length / 2;

private _WALL  = "Land_Mil_WallBig_4m_F";
private _TOWER = "Land_Cargo_Patrol_V3_F";

XCSV_fnc_prisonTestWorld = {
    params ["_lx", "_ly"];
    private _h = _siteHeading;
    [
        (_siteAnchor select 0) + (sin _h) * _lx + (cos _h) * _ly,
        (_siteAnchor select 1) + (cos _h) * _lx - (sin _h) * _ly,
        _siteAnchor select 2
    ]
};

XCSV_fnc_prisonTestSpawn = {
    params ["_class", "_lx", "_ly", "_heading", "_name"];
    private _world = [_lx, _ly] call XCSV_fnc_prisonTestWorld;
    private _obj = _class createVehicle [0, 0, 0];
    _obj setPosATL [(_world select 0), (_world select 1), 0];
    _obj setDir (_siteHeading + _heading);
    _obj allowDamage false;
    _obj setVariable ["XCSV_PrisonGraybox", true, true];
    _obj setVariable ["BIS_fnc_animalBehaviour_disable", true];
    _obj
};

XCSV_fnc_prisonTestWallRun = {
    params ["_a", "_b", "_prefix", "_spacing"];
    _spacing = if (isNil "_spacing") then { 4 } else { _spacing };
    private _lx = (_b select 0) - (_a select 0);
    private _ly = (_b select 1) - (_a select 1);
    private _len = sqrt (_lx ^ 2 + _ly ^ 2);
    if (_len <= 0.1) exitWith {};
    private _count = floor (_len / _spacing) max 1;
    private _heading = ((_b select 0) - (_a select 0)) atan2 ((_b select 1) - (_a select 1));
    private _stepX = _lx / _count;
    private _stepY = _ly / _count;
    private _created = [];
    for "_i" from 0 to _count do {
        private _obj = [_WALL, (_a select 0) + _stepX * _i, (_a select 1) + _stepY * _i, _heading, format ["%1_%2", _prefix, _i + 1]] call XCSV_fnc_prisonTestSpawn;
        _created pushBack _obj;
    };
    _created
};

diag_log format ["[PRISON-GRAYBOX-001] building %1 runtime graybox", _siteId];

// --- Perimeter walls (south wall has a 16m vehicle gate gap) ---
private _walls = [];
_walls append ([[- _hw, -_hl], [-8, -_hl], "PRISON_WALL_SW"] call XCSV_fnc_prisonTestWallRun);
_walls append ([[8, -_hl], [_hw, -_hl], "PRISON_WALL_SE"] call XCSV_fnc_prisonTestWallRun);
_walls append ([[_hw, -_hl], [_hw, _hl], "PRISON_WALL_E"] call XCSV_fnc_prisonTestWallRun);
_walls append ([[_hw, _hl], [-_hw, _hl], "PRISON_WALL_N"] call XCSV_fnc_prisonTestWallRun);
_walls append ([[- _hw, _hl], [-_hw, -_hl], "PRISON_WALL_W"] call XCSV_fnc_prisonTestWallRun);

// --- Perimeter towers: corners + gate flanks + north (dock) oversight ---
[_TOWER, -_hw, -_hl, 0, "PRISON_TOWER_SW"] call XCSV_fnc_prisonTestSpawn;
[_TOWER, _hw, -_hl, 0, "PRISON_TOWER_SE"] call XCSV_fnc_prisonTestSpawn;
[_TOWER, _hw, _hl, 0, "PRISON_TOWER_NE"] call XCSV_fnc_prisonTestSpawn;
[_TOWER, -_hw, _hl, 0, "PRISON_TOWER_NW"] call XCSV_fnc_prisonTestSpawn;
[_TOWER, -130, -_hl, 0, "PRISON_TOWER_GATE_W"] call XCSV_fnc_prisonTestSpawn;
[_TOWER, 130, -_hl, 0, "PRISON_TOWER_GATE_E"] call XCSV_fnc_prisonTestSpawn;
[_TOWER, 0, _hl, 0, "PRISON_TOWER_DOCK"] call XCSV_fnc_prisonTestSpawn;

// --- Gatehouse / intake band ---
["Land_Cargo_HQ_V4_F", 0, -170, 90, "PRISON_GATEHOUSE"] call XCSV_fnc_prisonTestSpawn;
["Land_CargoBox_V1_F", -40, -150, 90, "PRISON_INTAKE_BOX_1"] call XCSV_fnc_prisonTestSpawn;
["Land_CargoBox_V1_F", 40, -150, 90, "PRISON_INTAKE_BOX_2"] call XCSV_fnc_prisonTestSpawn;

// --- Cellblocks ---
["Land_Barracks_01_grey_F", -130, -70, 0, "PRISON_CELLBLOCK_A"] call XCSV_fnc_prisonTestSpawn;
["Land_Barracks_01_grey_F", 130, -70, 180, "PRISON_CELLBLOCK_B"] call XCSV_fnc_prisonTestSpawn;

// --- Max-sec + SHU ---
["Land_Barracks_01_camo_F", -130, 70, 0, "PRISON_MAXSEC"] call XCSV_fnc_prisonTestSpawn;
["Land_Cargo_House_V4_F", 130, 70, 180, "PRISON_SHU"] call XCSV_fnc_prisonTestSpawn;

// --- Medical + workshop ---
["Land_Medevac_house_V1_F", -130, 140, 0, "PRISON_MEDICAL"] call XCSV_fnc_prisonTestSpawn;
["Land_Offices_01_V1_F", 130, 140, 180, "PRISON_WORKSHOP"] call XCSV_fnc_prisonTestSpawn;

// --- Armory / utilities ---
["Land_GuardHouse_02_F", -45, -110, 90, "PRISON_ARMORY"] call XCSV_fnc_prisonTestSpawn;
["Land_ContainerLine_02_F", 0, 10, 0, "PRISON_UTILITIES"] call XCSV_fnc_prisonTestSpawn;

// --- Dock staging (coastal north edge) ---
["Land_CargoBox_V1_F", -60, 175, 90, "PRISON_DOCK_BOX_1"] call XCSV_fnc_prisonTestSpawn;
["Land_CargoBox_V1_F", -20, 175, 90, "PRISON_DOCK_BOX_2"] call XCSV_fnc_prisonTestSpawn;
["Land_CargoBox_V1_F", 20, 175, 90, "PRISON_DOCK_BOX_3"] call XCSV_fnc_prisonTestSpawn;

diag_log format ["[PRISON-GRAYBOX-001] graybox spawned: %1 wall segments, tower/mass placements done", count _walls];