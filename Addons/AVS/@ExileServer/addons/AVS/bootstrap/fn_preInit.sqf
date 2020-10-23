/*
© 2015 Zenix Gaming Ops
Developed by Rod-Serling
Co-Developed by Vishpala

All rights reserved.

Function:
	AVS_fnc_preInit - Initializes the configuration and sets the Exile hooks.
*/

private ["_worldFound", "_processVehicleSpawn"];

// ******************************************************************

// Load our configuration.
AVS_Version = (configFile >> "CfgPatches" >> "AVS" >> "AVS_Version") call BIS_fnc_GetCfgData;
diag_log format ["AVS - Loading AVS version: %1", AVS_Version];

AVS_configuration = compileFinal (preprocessFileLineNumbers "AVS\AVS_configuration.sqf");
AVS_fnc_getConfigLoadout = compileFinal (preprocessFileLineNumbers "AVS\AVS_fnc_getConfigLoadout.sqf");

call AVS_configuration;

// ******************************************************************

// Select world center and radius
_worldFound = false;
{
	if ((_x select 0) isEqualTo worldName) exitWith
	{
		AVS_WorldCenter = _x select 1;
		AVS_WorldRadius = _x select 2;
		_worldFound = true;
	}
} forEach AVS_WorldInfo;

if (!_worldFound) exitWith
{
	diag_log "AVS - CRITICAL ERROR: UNSUPPORTED MAP. SHUTTING DOWN.";
};

// ******************************************************************

// Hook Exile's functions.
{
	private ["_codeHook", "_codeOrig", "_function", "_file", "_hook"];
	_codeHook = '';
	_codeOrig = '';
	_function = _x select 0;
	_file = _x select 1;
	_hook = _x select 2;
	
	if (isText (missionConfigFile >> 'CfgExileCustomCode' >> _function)) then
	{
		_file = getText (missionConfigFile >> 'CfgExileCustomCode' >> _function);
	};
	
	_codeHook = compileFinal (preprocessFileLineNumbers _hook);                    
	_codeOrig = compileFinal (preprocessFileLineNumbers _file);
    missionNamespace setVariable [_function, _codeHook];
	missionNamespace setVariable [format["%1_ORIGINAL", _function], _codeOrig];
	diag_log format ["AVS - Hooked %1 to redirect to %2 | Was pointing to %3", _function, _hook, _file];
} forEach
[
	['ExileServer_object_player_createBambi', 'exile_server\code\ExileServer_object_player_createBambi.sqf', 'AVS\hooks\AVS_player_createBambi.sqf'],
	['ExileServer_object_player_database_load', 'exile_server\code\ExileServer_object_player_database_load.sqf', 'AVS\hooks\AVS_player_database_load.sqf'],
	['ExileServer_object_vehicle_createNonPersistentVehicle', 'exile_server\code\ExileServer_object_vehicle_createNonPersistentVehicle.sqf', 'AVS\hooks\AVS_createNonPersistentVehicle.sqf'],
	['ExileServer_object_vehicle_createPersistentVehicle', 'exile_server\code\ExileServer_object_vehicle_createPersistentVehicle.sqf', 'AVS\hooks\AVS_createPersistentVehicle.sqf'],
	['ExileServer_object_vehicle_database_insert', 'exile_server\code\ExileServer_object_vehicle_database_insert.sqf', 'AVS\hooks\AVS_vehicle_database_insert.sqf'],
	['ExileServer_object_vehicle_database_update', 'exile_server\code\ExileServer_object_vehicle_database_update.sqf', 'AVS\hooks\AVS_vehicle_database_update.sqf'],
	['ExileServer_object_vehicle_database_load', 'exile_server\code\ExileServer_object_vehicle_database_load.sqf', 'AVS\hooks\AVS_vehicle_database_load.sqf'],
	['ExileServer_system_database_connect', 'exile_server\code\ExileServer_system_database_connect.sqf', 'AVS\hooks\AVS_system_database_connect.sqf'],
	['ExileServer_world_initialize', 'exile_server\code\ExileServer_world_initialize.sqf', 'AVS\hooks\AVS_world_initialize.sqf']
	
];

// ******************************************************************

// Sanitize configuration.
{
	AVS_DisableVehicleThermal set [_forEachIndex, toLower _x];
} forEach AVS_DisableVehicleThermal;

{
	AVS_GlobalWeaponBlacklist set [_forEachIndex, toLower _x];
} forEach AVS_GlobalWeaponBlacklist;

{
	AVS_GlobalAmmoBlacklist set [_forEachIndex, toLower _x];
} forEach AVS_GlobalAmmoBlacklist;

{
	private ["_currentBlacklist"];
	_x set [0, toLower(_x select 0)];
	_currentBlacklist = _x select 1;
	{ 
		_currentBlacklist set [_forEachIndex, toLower _x];
	} forEach _currentBlacklist;
	
	// Append Global blacklist to this blacklist.
	_currentBlacklist = _currentBlacklist + AVS_GlobalWeaponBlacklist;
} forEach AVS_VehicleWeaponBlacklist;

{
	private ["_currentBlacklist"];
	_x set [0, toLower(_x select 0)];
	_currentBlacklist = _x select 1;
	{ 
		_currentBlacklist set [_forEachIndex, toLower _x];
	} forEach _currentBlacklist;
	
	// Append Global blacklist to this blacklist.
	_currentBlacklist = _currentBlacklist + AVS_GlobalAmmoBlacklist;
} forEach AVS_VehicleAmmoBlacklist;	

// ******************************************************************

// Setup vehicle UID trackers from config.

AVS_SpawnedVehicleTracker = [];
_processVehicleSpawn = 
{
	{
		AVS_SpawnedVehicleTracker pushBack [(_x select 0), 0];
	} forEach _this;
};

AVS_spawnedPersistentVehiclesLocation call _processVehicleSpawn;
AVS_spawned_NON_PersistentVehiclesLocation call _processVehicleSpawn;
AVS_spawnedPersistentVehiclesRoadside call _processVehicleSpawn;
AVS_spawned_NON_PersistentVehiclesRoadside call _processVehicleSpawn;
AVS_spawnedPersistentVehiclesRandom call _processVehicleSpawn;
AVS_spawned_NON_PersistentVehiclesRandom call _processVehicleSpawn;

// ******************************************************************

// Send info to the clients
publicVariable "AVS_Version";
publicVariable "AVS_RearmSystemActive";
if (AVS_RearmSystemActive) then
{
	diag_log "AVS - Rearm system active.";
	publicVariable "AVS_RearmDistance";
	publicVariable "AVS_RearmTime";
	publicVariable "AVS_RearmObjects";
	publicVariable "AVS_RearmCostDefault";
	publicVariable "AVS_RearmCosts";
};

diag_log "AVS - Initialized.";