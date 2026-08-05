/*
    xcsv/fn_census.sqf - CLIENT side, ADMIN ONLY

    A world-object census on demand.

    This exists because of a real incident. On 2026-08-02 the server sat at 22
    FPS with ~700 "vehicles" reported by infiSTAR, and working out what those
    objects actually were took hours of log archaeology. The answer was that
    a3_exile_lootbox had deadlocked partway through populating the map, and its
    props and crates were being counted as vehicles. This tool answers that
    question in one keystroke: what is out there, what class is it, and where.

    Design notes:

      * ADMIN ONLY, by UID. Same whitelist shape as sovran_zeus, our other
        in-house addon.
      * Markers are createMarkerLocal - they exist only on the admin's machine.
        No other player sees them, nothing is broadcast, and the server does not
        carry them. This is the opposite of the lootbox debug markers we turned
        off, which were global and exposed loot to everyone.
      * Markers are not objects, so createVehicle-class BattlEye filters are not
        involved at all.
      * Delivered as a self addAction rather than a keybind: infiSTAR strips
        unregistered key handlers, and an action cannot collide with one.
      * Counting runs on the client. The server does not pay for it.
*/

if (!hasInterface) exitWith {};

XCSV_CENSUS_ADMINS = [
    "76561198108041726"     // Mr. Sage
];

XCSV_CENSUS_MarkerPrefix = "xcsv_census_";
XCSV_CENSUS_Active = false;

// Remove every marker this tool created. Safe to call at any time.
XCSV_fnc_censusClear = {
    private _n = missionNamespace getVariable ["XCSV_CENSUS_Count", 0];
    for "_i" from 0 to (_n - 1) do {
        deleteMarkerLocal (XCSV_CENSUS_MarkerPrefix + str _i);
    };
    missionNamespace setVariable ["XCSV_CENSUS_Count", 0];
    XCSV_CENSUS_Active = false;
};

XCSV_fnc_censusRun = {
    call XCSV_fnc_censusClear;

    private _all = vehicles;   // every non-unit object the engine simulates
    private _idx = 0;
    private _byClass = createHashMap;

    {
        private _obj = _x;
        if (alive _obj) then {
            private _type = typeOf _obj;
            if !(_type isEqualTo "") then {

                // Bucket it. These are the categories that actually matter when
                // the object count runs away.
                private _bucket = switch (true) do {
                    case (_obj isKindOf "Exile_Container_Abstract"): { "loot container" };
                    case (_obj isKindOf "ReammoBox_F"):              { "crate" };
                    case (_obj isKindOf "Air"):                      { "aircraft" };
                    case (_obj isKindOf "Ship"):                     { "boat" };
                    case (_obj isKindOf "LandVehicle"):              { "land vehicle" };
                    case (_obj isKindOf "Exile_Construction_Abstract"): { "construction" };
                    default                                          { "prop / other" };
                };
                _byClass set [_bucket, (_byClass getOrDefault [_bucket, 0]) + 1];

                private _colour = switch (_bucket) do {
                    case "land vehicle":    { "ColorBlue" };
                    case "aircraft":        { "ColorRed" };
                    case "boat":            { "ColorGreen" };
                    case "loot container":  { "ColorYellow" };
                    case "crate":           { "ColorOrange" };
                    case "construction":    { "ColorBrown" };
                    default                 { "ColorGrey" };
                };

                private _m = createMarkerLocal
                    [XCSV_CENSUS_MarkerPrefix + str _idx, getPosATL _obj];
                _m setMarkerTypeLocal "mil_dot";
                _m setMarkerColorLocal _colour;
                _m setMarkerAlphaLocal 0.75;
                _idx = _idx + 1;
            };
        };
    } forEach _all;

    missionNamespace setVariable ["XCSV_CENSUS_Count", _idx];
    XCSV_CENSUS_Active = true;

    systemChat format ["XCSV CENSUS: %1 simulated objects, %2 AI units", _idx, count allUnits];
    {
        systemChat format ["   %1: %2", _x, _byClass get _x];
    } forEach (keys _byClass);
    systemChat "XCSV CENSUS: markers are local to you only. Run again to clear.";
};

[] spawn {
    uiSleep 30;
    waitUntil { uiSleep 2; alive player };

    if !((getPlayerUID player) in XCSV_CENSUS_ADMINS) exitWith {};

    player addAction [
        "<t color='#3D9CFF'>XCSV: World census</t>",
        {
            if (XCSV_CENSUS_Active) then {
                call XCSV_fnc_censusClear;
                systemChat "XCSV CENSUS: cleared.";
            } else {
                call XCSV_fnc_censusRun;
            };
        },
        nil, 1.5, false, true, "", "true", 5
    ];

    diag_log "[XCSV_CENSUS] admin census action added.";
};
