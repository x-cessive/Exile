/*
    xcsv/fn_mapAtlas.sqf - CLIENT side

    DMS-style map notes placed as local markers in the off-map black area.
    These are not screen overlays; they zoom and pan with the map like mission
    markers, so they do not cover the playable map while players inspect it.
*/

if (!hasInterface) exitWith {};

XCSV_fnc_mapAtlasMarker = {
    params ["_name", "_pos", "_type", "_color", "_text", ["_size", [0.75, 0.75]]];

    deleteMarkerLocal _name;
    private _marker = createMarkerLocal [_name, _pos];
    _marker setMarkerTypeLocal _type;
    _marker setMarkerColorLocal _color;
    _marker setMarkerTextLocal _text;
    _marker setMarkerSizeLocal _size;
    _marker setMarkerAlphaLocal 1;
    _marker
};

XCSV_fnc_mapAtlasBuild = {
    private _originX = -1450;
    private _originY = 1650;
    private _row = 165;

    ["XCSV_ATLAS_Header", [_originX, _originY, 0], "mil_dot", "ColorRed", "XCSV Map Legend", [0.85, 0.85]] call XCSV_fnc_mapAtlasMarker;
    ["XCSV_ATLAS_Easy", [_originX + 210, _originY - _row, 0], "mil_circle", "ColorGreen", "Easy / starter mission", [0.8, 0.8]] call XCSV_fnc_mapAtlasMarker;
    ["XCSV_ATLAS_Medium", [_originX + 210, _originY - (_row * 2), 0], "mil_circle", "ColorYellow", "Moderate mission", [0.8, 0.8]] call XCSV_fnc_mapAtlasMarker;
    ["XCSV_ATLAS_Hard", [_originX + 210, _originY - (_row * 3), 0], "mil_warning", "ColorOrange", "Hard mission", [0.8, 0.8]] call XCSV_fnc_mapAtlasMarker;
    ["XCSV_ATLAS_Elite", [_originX + 210, _originY - (_row * 4), 0], "mil_destroy", "ColorRed", "Elite / group work", [0.8, 0.8]] call XCSV_fnc_mapAtlasMarker;

    ["XCSV_ATLAS_Spawn", [_originX + 950, _originY - _row, 0], "mil_triangle", "ColorGreen", "Spawn town", [0.8, 0.8]] call XCSV_fnc_mapAtlasMarker;
    ["XCSV_ATLAS_Trader", [_originX + 950, _originY - (_row * 2), 0], "mil_dot", "ColorBlue", "Trader / safezone", [0.8, 0.8]] call XCSV_fnc_mapAtlasMarker;
    ["XCSV_ATLAS_CashVan", [_originX + 950, _originY - (_row * 3), 0], "mil_box", "ColorRed", "Cash Van - guarded poptabs", [0.8, 0.8]] call XCSV_fnc_mapAtlasMarker;
    ["XCSV_ATLAS_Water", [_originX + 950, _originY - (_row * 4), 0], "mil_objective", "ColorBlue", "Water / coastal loot", [0.8, 0.8]] call XCSV_fnc_mapAtlasMarker;

    ["XCSV_ATLAS_Rule1", [_originX, _originY - (_row * 5.6), 0], "mil_dot", "ColorWhite", "No combat or vehicle parking in safezones.", [0.65, 0.65]] call XCSV_fnc_mapAtlasMarker;
    ["XCSV_ATLAS_Rule2", [_originX, _originY - (_row * 6.55), 0], "mil_dot", "ColorWhite", "Courier wrecks stay 1km away from traders.", [0.65, 0.65]] call XCSV_fnc_mapAtlasMarker;
    ["XCSV_ATLAS_Rule3", [_originX, _originY - (_row * 7.5), 0], "mil_dot", "ColorWhite", "Fresh route: loot town, water, trader or green mission.", [0.65, 0.65]] call XCSV_fnc_mapAtlasMarker;
};

[] spawn {
    waitUntil { !isNull player };
    call XCSV_fnc_mapAtlasBuild;
};

diag_log "[XCSV_MAP] marker atlas ready.";
