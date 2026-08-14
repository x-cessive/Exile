/*
    xcsv/fn_mapAtlas.sqf - CLIENT side

    Map notes placed as local markers in the off-map black area.
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
    private _small = [0.55, 0.55];
    private _head = [0.65, 0.65];

    /*
        Two vertical columns only - no horizontal rows. MAPEDGE-009: marker text
        is drawn beside its icon at a near-fixed screen width, so a row of notes
        2600m apart ran together into one unreadable line once the map was
        zoomed out. Stacked entries always have empty black to their right.

        The side margins are also the only ones with room. Tanoa draws roughly
        680m of black above the north edge, so the old row at y=17750 sat
        outside the map control and was never visible at all.

        Longer labels belong in the right column, which has the most clear
        space before the screen edge.
    */

    ["XCSV_ATLAS_Left_Header", [-3500, 14400, 0], "mil_dot", "ColorBlue", "SERVER RULES", _head] call XCSV_fnc_mapAtlasMarker;
    ["XCSV_ATLAS_Left_Rule1", [-3500, 12800, 0], "mil_dot", "ColorWhite", "No safezone combat or ramming", _small] call XCSV_fnc_mapAtlasMarker;
    ["XCSV_ATLAS_Left_Rule2", [-3500, 11200, 0], "mil_dot", "ColorWhite", "No blocking traders or spawn exits", _small] call XCSV_fnc_mapAtlasMarker;
    ["XCSV_ATLAS_Left_Rule3", [-3500, 9600, 0], "mil_dot", "ColorWhite", "Report exploits instead of using them", _small] call XCSV_fnc_mapAtlasMarker;
    ["XCSV_ATLAS_Left_Rule4", [-3500, 8000, 0], "mil_dot", "ColorWhite", "Respect base build space", _small] call XCSV_fnc_mapAtlasMarker;

    ["XCSV_ATLAS_Left_RoutesHeader", [-3500, 5600, 0], "mil_dot", "ColorBlue", "START ROUTES", _head] call XCSV_fnc_mapAtlasMarker;
    ["XCSV_ATLAS_Left_Route1", [-3500, 4000, 0], "mil_dot", "ColorWhite", "Main island: fastest traders", _small] call XCSV_fnc_mapAtlasMarker;
    ["XCSV_ATLAS_Left_Route2", [-3500, 2400, 0], "mil_dot", "ColorWhite", "Outer islands: quieter loot", _small] call XCSV_fnc_mapAtlasMarker;
    ["XCSV_ATLAS_Left_Route3", [-3500, 800, 0], "mil_dot", "ColorWhite", "Find water, boat, then mission", _small] call XCSV_fnc_mapAtlasMarker;

    ["XCSV_ATLAS_Right_Header", [18850, 14400, 0], "mil_dot", "ColorBlue", "ICON NOTES", _head] call XCSV_fnc_mapAtlasMarker;
    ["XCSV_ATLAS_Right_Trader", [18850, 12800, 0], "mil_dot", "ColorBlue", "Trader and safezone", _small] call XCSV_fnc_mapAtlasMarker;
    ["XCSV_ATLAS_Right_Spawn", [18850, 11200, 0], "mil_triangle", "ColorGreen", "Town spawn point", _small] call XCSV_fnc_mapAtlasMarker;
    ["XCSV_ATLAS_Right_Water", [18850, 9600, 0], "mil_objective", "ColorBlue", "Coastal or water loot", _small] call XCSV_fnc_mapAtlasMarker;
    ["XCSV_ATLAS_Right_Wreck", [18850, 8000, 0], "mil_box", "ColorYellow", "Mission wreck or supply cache", _small] call XCSV_fnc_mapAtlasMarker;

    ["XCSV_ATLAS_Right_QuickHeader", [18850, 5600, 0], "mil_dot", "ColorBlue", "XCSV QUICK MAP", _head] call XCSV_fnc_mapAtlasMarker;
    ["XCSV_ATLAS_Right_Quick1", [18850, 4000, 0], "mil_box", "ColorYellow", "Cash Van: guarded poptabs and safe", _small] call XCSV_fnc_mapAtlasMarker;
    ["XCSV_ATLAS_Right_Quick2", [18850, 2400, 0], "mil_triangle", "ColorGreen", "Spawn menu uses town names only", _small] call XCSV_fnc_mapAtlasMarker;
    ["XCSV_ATLAS_Right_Quick3", [18850, 800, 0], "mil_flag", "ColorWhite", "Zoom out for atlas notes", _small] call XCSV_fnc_mapAtlasMarker;
};

[] spawn {
    waitUntil { !isNull player };
    call XCSV_fnc_mapAtlasBuild;
};

diag_log "[XCSV_MAP] marker atlas ready.";
