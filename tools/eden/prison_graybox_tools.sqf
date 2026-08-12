/*
    PRISON-GRAYBOX-001 - narrow Eden helper functions.

    Load this file in Eden after Architect selects a site. The helpers create
    editable Eden objects inside named layers. They are not the canonical prison
    representation; the saved Eden mission source is.
*/

if (!is3DEN) exitWith {
    systemChat "PRISON-GRAYBOX-001: open the mission in Eden before loading graybox helpers.";
};

XCSV_PRISON_Layers = [
    "PRISON_PERIMETER",
    "PRISON_INTAKE",
    "PRISON_CELLBLOCK_A",
    "PRISON_CELLBLOCK_B",
    "PRISON_MAXSEC",
    "PRISON_SHU",
    "PRISON_YARD",
    "PRISON_MEDICAL",
    "PRISON_WORKSHOP",
    "PRISON_ARMORY",
    "PRISON_UTILITIES",
    "PRISON_DOCK",
    "PRISON_DETAIL"
];

XCSV_fnc_prisonLayerId = {
    params ["_layerName"];

    private _layerId = -1;
    {
        private _name = (_x get3DENAttribute "name") param [0, ""];
        if (_name isEqualTo _layerName) exitWith {
            _layerId = _x;
        };
    } forEach ((all3DENEntities) select 6);

    if (_layerId isEqualTo -1) then {
        _layerId = -1 add3DENLayer _layerName;
    };

    _layerId
};

XCSV_fnc_prisonCreateLayers = {
    ["PRISON-GRAYBOX-001 create layers", "PRISON_LAYERS", "a3\3den\data\cfg3den\history\addtolayer_ca.paa"] collect3DENHistory {
        {
            [_x] call XCSV_fnc_prisonLayerId;
        } forEach XCSV_PRISON_Layers;
    };
};

XCSV_fnc_prisonVectorFromHeading = {
    params ["_heading", "_distance"];
    [sin _heading * _distance, cos _heading * _distance, 0]
};

XCSV_fnc_prisonPlaceLine = {
    params [
        ["_layerName", "PRISON_PERIMETER"],
        ["_className", "Land_Mil_WallBig_4m_F"],
        ["_start", [0, 0, 0]],
        ["_end", [0, 0, 0]],
        ["_spacing", 4],
        ["_namePrefix", "PRISON_WALL"]
    ];

    private _delta = _end vectorDiff _start;
    private _length = sqrt ((_delta select 0) ^ 2 + (_delta select 1) ^ 2);
    if (_length <= 0.1) exitWith { [] };

    private _count = floor (_length / _spacing) max 1;
    private _heading = ((_delta select 0) atan2 (_delta select 1));
    private _step = _delta vectorMultiply (1 / _count);
    private _layerId = [_layerName] call XCSV_fnc_prisonLayerId;
    private _created = [];

    [format ["PRISON-GRAYBOX-001 place %1", _namePrefix], _namePrefix, "a3\3den\data\cfg3den\history\create_ca.paa"] collect3DENHistory {
        for "_i" from 0 to _count do {
            private _pos = _start vectorAdd (_step vectorMultiply _i);
            private _obj = create3DENEntity ["Object", _className, _pos];
            _obj set3DENAttribute ["Name", format ["%1_%2", _namePrefix, _i + 1]];
            _obj set3DENAttribute ["rotation", [0, 0, _heading]];
            _obj set3DENLayer _layerId;
            _created pushBack _obj;
        };
    };

    _created
};

XCSV_fnc_prisonPlaceMass = {
    params [
        ["_layerName", "PRISON_INTAKE"],
        ["_className", "Land_Cargo_HQ_V4_F"],
        ["_pos", [0, 0, 0]],
        ["_heading", 0],
        ["_name", "PRISON_MASS"]
    ];

    private _layerId = [_layerName] call XCSV_fnc_prisonLayerId;
    private _created = objNull;

    [format ["PRISON-GRAYBOX-001 place %1", _name], _name, "a3\3den\data\cfg3den\history\create_ca.paa"] collect3DENHistory {
        _created = create3DENEntity ["Object", _className, _pos];
        _created set3DENAttribute ["Name", _name];
        _created set3DENAttribute ["rotation", [0, 0, _heading]];
        _created set3DENLayer _layerId;
    };

    _created
};

XCSV_fnc_prisonBaselineSelection = {
    private _entities = get3DENSelected "Object";
    private _simEnabled = 0;
    private _dynamicLights = 0;
    private _interactive = 0;

    {
        private _class = typeOf _x;
        private _sim = (_x get3DENAttribute "enableSimulation") param [0, true];
        if (_sim) then { _simEnabled = _simEnabled + 1; };
        if (_class isKindOf "Lamps_base_F") then { _dynamicLights = _dynamicLights + 1; };
        if (_sim || {_class isKindOf "House"} || {_class isKindOf "ThingX"}) then {
            _interactive = _interactive + 1;
        };
    } forEach _entities;

    private _text = format [
        "PRISON-GRAYBOX-001 selected-object baseline\nTotal selected: %1\nSimulation enabled: %2\nDynamic light candidates: %3\nInteractive/destructible candidates: %4",
        count _entities,
        _simEnabled,
        _dynamicLights,
        _interactive
    ];

    copyToClipboard _text;
    systemChat "PRISON-GRAYBOX-001: selected-object baseline copied to clipboard.";
    _text
};

systemChat "PRISON-GRAYBOX-001: graybox helpers loaded. Call XCSV_fnc_prisonCreateLayers after site selection.";
