/*
    sovran_zeus persistence - make Zeus-placed objects survive a restart.

    Zeus normally builds nothing permanent: every object the curator spawns is a plain
    runtime object with no database row, so a restart wipes it. This stores placements
    in the Exile database (table `sovran_zeus_object`) through Exile's own extDB2
    pipeline, and respawns them at boot.

    Three things worth knowing:

    * Only STATIC objects are persisted by default. Zeus can spawn AI and vehicles, and
      resurrecting a squad of AI or a tank on every restart is almost never what you
      want. See SOVRAN_ZEUS_PERSIST_FILTER below.

    * Persisted objects have simulation disabled and are marked so Exile's garbage
      collector skips them. That marker is honoured in the shared
      ExileServer_system_garbageCollector_deleteObject override -- CfgExileCustomCode
      allows only ONE override per function, so it is shared with Claim-Vehicles rather
      than competing with it.

    * Object count costs server FPS at boot and thereafter. SOVRAN_ZEUS_PERSIST_LIMIT
      is a deliberate ceiling.
*/

if (!isServer) exitWith {};

SOVRAN_ZEUS_PERSIST_LIMIT = 2000;

/*
    Decides whether a Zeus placement is saved. Default: static scenery only -- no men,
    no vehicles, nothing with a crew. Widen at your own risk.
*/
SOVRAN_ZEUS_PERSIST_FILTER =
{
    params ["_object"];
    private _class = typeOf _object;

    if (_class isEqualTo "") exitWith { false };
    if (_object isKindOf "Man") exitWith { false };
    if (_object isKindOf "AllVehicles") exitWith { false };
    if (_object isKindOf "Exile_Construction_Abstract_Static") exitWith { false };  // Exile handles its own
    true
};

SOVRAN_ZEUS_MARK = "SOVRAN_ZEUS_PERSIST_ID";

/* ------------------------------------------------------------------ save --- */
SOVRAN_fnc_zeusPersistSave =
{
    params ["_object", ["_uid", ""]];

    if (isNull _object) exitWith {};
    if !([_object] call SOVRAN_ZEUS_PERSIST_FILTER) exitWith {};
    if !((_object getVariable [SOVRAN_ZEUS_MARK, -1]) isEqualTo -1) exitWith {};  // already saved

    private _pos = getPosASL _object;
    private _dir = vectorDir _object;
    private _up  = vectorUp _object;

    private _id = format ["sovranZeusInsert:%1:%2:%3:%4:%5:%6:%7:%8:%9:%10:%11",
        typeOf _object,
        _pos select 0, _pos select 1, _pos select 2,
        _dir select 0, _dir select 1, _dir select 2,
        _up  select 0, _up  select 1, _up  select 2,
        _uid] call ExileServer_system_database_query_insertSingle;

    _object setVariable [SOVRAN_ZEUS_MARK, _id, true];
    _object enableSimulationGlobal false;

    diag_log format ["[SOVRAN_ZEUS] saved %1 as id %2 (by %3)", typeOf _object, _id, _uid];
};

/* ---------------------------------------------------------------- delete --- */
SOVRAN_fnc_zeusPersistDelete =
{
    params ["_object"];

    private _id = _object getVariable [SOVRAN_ZEUS_MARK, -1];
    if (_id isEqualTo -1) exitWith {};

    format ["sovranZeusDelete:%1", _id] call ExileServer_system_database_query_fireAndForget;
    diag_log format ["[SOVRAN_ZEUS] removed persisted object id %1", _id];
};

/* ------------------------------------------------------------------ load --- */
SOVRAN_fnc_zeusPersistLoad =
{
    private _rows = "sovranZeusLoadAll" call ExileServer_system_database_query_selectFull;
    if (isNil "_rows") exitWith { diag_log "[SOVRAN_ZEUS] persistence load returned nil"; };

    private _spawned = 0;
    {
        _x params ["_id", "_class", "_px", "_py", "_pz", "_dx", "_dy", "_dz", "_ux", "_uy", "_uz"];

        if (_spawned >= SOVRAN_ZEUS_PERSIST_LIMIT) exitWith
        {
            diag_log format ["[SOVRAN_ZEUS] persistence limit %1 reached, remaining objects skipped", SOVRAN_ZEUS_PERSIST_LIMIT];
        };

        if (isClass (configFile >> "CfgVehicles" >> _class)) then
        {
            private _object = createVehicle [_class, [0, 0, 0], [], 0, "CAN_COLLIDE"];
            _object setPosASL [_px, _py, _pz];
            _object setVectorDirAndUp [[_dx, _dy, _dz], [_ux, _uy, _uz]];
            _object enableSimulationGlobal false;
            _object setVariable [SOVRAN_ZEUS_MARK, _id, true];
            _spawned = _spawned + 1;
        }
        else
        {
            // The class no longer exists -- a mod was removed, or it was renamed.
            diag_log format ["[SOVRAN_ZEUS] row %1 references unknown class '%2', skipped", _id, _class];
        };
    } forEach _rows;

    diag_log format ["[SOVRAN_ZEUS] persistence restored %1 object(s) of %2 row(s)", _spawned, count _rows];
};

diag_log "[SOVRAN_ZEUS] persistence module loaded";
[] call SOVRAN_fnc_zeusPersistLoad;
