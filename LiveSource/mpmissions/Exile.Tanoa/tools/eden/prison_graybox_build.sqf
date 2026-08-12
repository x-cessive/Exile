/*
    PRISON-GRAYBOX-001 - parametrized graybox builder for the chosen site.

    Site: A_NORTH_CENTRAL_COAST (Architect-selected 2026-08-12)
      anchor    [7140, 11800, 0]
      footprint 520m x 360m   heading 35 deg

    Run this file from the Eden debug console AFTER loading
    `tools\eden\prison_graybox_tools.sqf`:

        execVM "tools\eden\prison_graybox_tools.sqf";
        execVM "tools\eden\prison_graybox_build.sqf";

    The whole perimeter + interior is created as ONE undoable history step, in
    the PRISON_* layers. It does not save `mission.sqm`; the accepted layout
    must remain editable Eden source under Git custody. Temporary building
    classnames are verified against the running-server classdump; positions are
    draft order and can be tuned before Architect visually accepts the graybox.

    NOTE: this file creates entities directly inside a single collect3DENHistory
    block. Do not place entities inside here by calling helpers that wrap their
    own collect3DENHistory; only XCSV_fnc_prisonLayerId is used, and it does not
    wrap history.
*/

if (!is3DEN) exitWith {
    systemChat "PRISON-GRAYBOX-001: open the mission in Eden before running the graybox builder.";
};

if (isNil "XCSV_fnc_prisonLayerId") then {
    call compile preprocessFileLineNumbers "tools\eden\prison_graybox_tools.sqf";
};

/*
    Local coordinate frame:
      local x is along the site heading (sin h, cos h)
      local y is 90 deg clockwise when facing north (cos h, -sin h)
    worldPos(lx, ly) = anchor + lx * fwd + ly * right
*/
XCSV_fnc_prisonBuildLocalToWorld = {
    params ["_site", "_local"];
    _site params ["_id", "_anchor", "_heading"];
    _local params ["_lx", "_ly"];

    private _h = _heading;
    private _worldX = (_anchor select 0) + (sin _h) * _lx + (cos _h) * _ly;
    private _worldY = (_anchor select 1) + (cos _h) * _lx - (sin _h) * _ly;
    [_worldX, _worldY, _anchor select 2]
};

/*
    Place a single mass object at a local coordinate. Returns the created object.
*/
XCSV_fnc_prisonBuildMass = {
    params ["_site", "_layerName", "_className", "_local", "_relHeading", "_name"];

    private _world = [_site, _local] call XCSV_fnc_prisonBuildLocalToWorld;
    private _worldHeading = (_site select 2) + _relHeading;
    private _layerId = [_layerName] call XCSV_fnc_prisonLayerId;

    private _created = create3DENEntity ["Object", _className, _world];
    _created set3DENAttribute ["Name", _name];
    _created set3DENAttribute ["rotation", [0, 0, _worldHeading]];
    _created set3DENLayer _layerId;
    _created
};

/*
    Place a wall run of spacing-apart wall segments between two local
    coordinates. Returns created objects.
*/
XCSV_fnc_prisonBuildWallRun = {
    params ["_site", "_layerName", "_className", "_a", "_b", "_spacing", "_prefix"];

    private _wa = [_site, _a] call XCSV_fnc_prisonBuildLocalToWorld;
    private _wb = [_site, _b] call XCSV_fnc_prisonBuildLocalToWorld;

    private _delta = _wb vectorDiff _wa;
    private _length = sqrt ((_delta select 0) ^ 2 + (_delta select 1) ^ 2);
    if (_length <= 0.1) exitWith { [] };

    private _count = floor (_length / _spacing) max 1;
    private _heading = ((_delta select 0) atan2 (_delta select 1));
    private _step = _delta vectorMultiply (1 / _count);
    private _layerId = [_layerName] call XCSV_fnc_prisonLayerId;
    private _created = [];

    for "_i" from 0 to _count do {
        private _pos = _wa vectorAdd (_step vectorMultiply _i);
        private _obj = create3DENEntity ["Object", _className, _pos];
        _obj set3DENAttribute ["Name", format ["%1_%2", _prefix, _i + 1]];
        _obj set3DENAttribute ["rotation", [0, 0, _heading]];
        _obj set3DENLayer _layerId;
        _created pushBack _obj;
    };

    _created
};

/*
    Build the full site-A graybox in a single undo step.
*/
XCSV_fnc_prisonBuildSite = {

    // Site record: id, anchor, heading, footprint [W,L]
    private _site = [
        "A_NORTH_CENTRAL_COAST",
        [7140, 11800, 0],
        35,
        [520, 360]
    ];
    _site params ["_id", "_anchor", "_heading", "_footprint"];
    _footprint params ["_width", "_length"];
    private _hw = _width / 2;
    private _hl = _length / 2;
    private _WALL = "Land_Mil_WallBig_4m_F";
    private _TOWER = "Land_Cargo_Patrol_V3_F";

    ["PRISON-GRAYBOX-001 build site A", "PRISON_GRAYBOX", "a3\3den\data\cfg3den\history\create_ca.paa"] collect3DENHistory {

        { [_x] call XCSV_fnc_prisonLayerId; } forEach XCSV_PRISON_Layers;

        /*
            Perimeter walls.
            South wall has a 16m vehicle gate gap centered on local x=0.
        */
        [_site, "PRISON_PERIMETER", _WALL, [-_hw, -_hl], [-8, -_hl], 4, "PRISON_WALL_SW"] call XCSV_fnc_prisonBuildWallRun;
        [_site, "PRISON_PERIMETER", _WALL, [8, -_hl], [_hw, -_hl], 4, "PRISON_WALL_SE"] call XCSV_fnc_prisonBuildWallRun;
        [_site, "PRISON_PERIMETER", _WALL, [_hw, -_hl], [_hw, _hl], 4, "PRISON_WALL_E"] call XCSV_fnc_prisonBuildWallRun;
        [_site, "PRISON_PERIMETER", _WALL, [_hw, _hl], [-_hw, _hl], 4, "PRISON_WALL_N"] call XCSV_fnc_prisonBuildWallRun;
        [_site, "PRISON_PERIMETER", _WALL, [-_hw, _hl], [-_hw, -_hl], 4, "PRISON_WALL_W"] call XCSV_fnc_prisonBuildWallRun;

        /*
            Perimeter towers: corners + gate flanks + north (dock) oversight.
        */
        [_site, "PRISON_PERIMETER", _TOWER, [-_hw, -_hl], 0, "PRISON_TOWER_SW"] call XCSV_fnc_prisonBuildMass;
        [_site, "PRISON_PERIMETER", _TOWER, [_hw, -_hl], 0, "PRISON_TOWER_SE"] call XCSV_fnc_prisonBuildMass;
        [_site, "PRISON_PERIMETER", _TOWER, [_hw, _hl], 0, "PRISON_TOWER_NE"] call XCSV_fnc_prisonBuildMass;
        [_site, "PRISON_PERIMETER", _TOWER, [-_hw, _hl], 0, "PRISON_TOWER_NW"] call XCSV_fnc_prisonBuildMass;
        [_site, "PRISON_PERIMETER", _TOWER, [-130, -_hl], 0, "PRISON_TOWER_GATE_W"] call XCSV_fnc_prisonBuildMass;
        [_site, "PRISON_PERIMETER", _TOWER, [130, -_hl], 0, "PRISON_TOWER_GATE_E"] call XCSV_fnc_prisonBuildMass;
        [_site, "PRISON_PERIMETER", _TOWER, [0, _hl], 0, "PRISON_TOWER_DOCK"] call XCSV_fnc_prisonBuildMass;

        /*
            Gatehouse / intake band, just inside the south gate.
        */
        [_site, "PRISON_GATEHOUSE", "Land_Cargo_HQ_V4_F", [0, -170], 90, "PRISON_GATEHOUSE"] call XCSV_fnc_prisonBuildMass;
        [_site, "PRISON_INTAKE", "Land_CargoBox_V1_F", [-40, -150], 90, "PRISON_INTAKE_BOX_1"] call XCSV_fnc_prisonBuildMass;
        [_site, "PRISON_INTAKE", "Land_CargoBox_V1_F", [40, -150], 90, "PRISON_INTAKE_BOX_2"] call XCSV_fnc_prisonBuildMass;

        /*
            Cellblocks: two medium-security wings flanking the central yard.
        */
        [_site, "PRISON_CELLBLOCK_A", "Land_Barracks_01_grey_F", [-130, -70], 0, "PRISON_CELLBLOCK_A"] call XCSV_fnc_prisonBuildMass;
        [_site, "PRISON_CELLBLOCK_B", "Land_Barracks_01_grey_F", [130, -70], 180, "PRISON_CELLBLOCK_B"] call XCSV_fnc_prisonBuildMass;

        /*
            Max-sec cellblock + SHU in the northern band.
        */
        [_site, "PRISON_MAXSEC", "Land_Barracks_01_camo_F", [-130, 70], 0, "PRISON_MAXSEC"] call XCSV_fnc_prisonBuildMass;
        [_site, "PRISON_SHU", "Land_Cargo_House_V4_F", [130, 70], 180, "PRISON_SHU"] call XCSV_fnc_prisonBuildMass;

        /*
            Medical + workshop along the outer wings.
        */
        [_site, "PRISON_MEDICAL", "Land_Medevac_house_V1_F", [-130, 140], 0, "PRISON_MEDICAL"] call XCSV_fnc_prisonBuildMass;
        [_site, "PRISON_WORKSHOP", "Land_Offices_01_V1_F", [130, 140], 180, "PRISON_WORKSHOP"] call XCSV_fnc_prisonBuildMass;

        /*
            Armory / guard services near the gate, utilities behind the yard.
        */
        [_site, "PRISON_ARMORY", "Land_GuardHouse_02_F", [-45, -110], 90, "PRISON_ARMORY"] call XCSV_fnc_prisonBuildMass;
        [_site, "PRISON_UTILITIES", "Land_ContainerLine_02_F", [0, 10], 0, "PRISON_UTILITIES"] call XCSV_fnc_prisonBuildMass;

        /*
            Dock staging on the coastal (north) edge; containers + oversight.
        */
        [_site, "PRISON_DOCK", "Land_CargoBox_V1_F", [-60, 175], 90, "PRISON_DOCK_BOX_1"] call XCSV_fnc_prisonBuildMass;
        [_site, "PRISON_DOCK", "Land_CargoBox_V1_F", [-20, 175], 90, "PRISON_DOCK_BOX_2"] call XCSV_fnc_prisonBuildMass;
        [_site, "PRISON_DOCK", "Land_CargoBox_V1_F", [20, 175], 90, "PRISON_DOCK_BOX_3"] call XCSV_fnc_prisonBuildMass;
    };

    systemChat format ["PRISON-GRAYBOX-001: site %1 graybox created in PRISON_* layers. Undo once to remove.", _id];
};

XCSV_fnc_prisonBuildSite;
nil;