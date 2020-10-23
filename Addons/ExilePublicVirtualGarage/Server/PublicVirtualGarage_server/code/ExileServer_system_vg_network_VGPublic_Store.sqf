private["_sessionID","_parameters","_playerObject","_vehicle","_dbID","_data","_extDBMessage"];

_sessionID = _this select 0;
_parameters = _this select 1;

_vehicle = objectFromNetId (_parameters select 0);
_playerObject = _sessionID call ExileServer_system_session_getPlayerObject;
if!(_vehicle getVariable ["ExileIsPersistent", false])exitWith{[_sessionID, "toastRequest", ["ErrorTitleAndText", ["Public Garage", "Vehicle is non persistant!"]]] call ExileServer_system_network_send_to; false};
_VehicleID = format["loadVehicleFromVGPublicFirst:%1", (getPlayerUID _playerObject)] call ExileServer_system_database_query_selectSingle;
if (_VehicleID isEqualType []) exitWith {[_sessionID, "toastRequest", ["ErrorTitleAndText", ["Public Garage", "You already have a vehicle in the garage!"]]] call ExileServer_system_network_send_to; false};
_vehicle call ExileServer_object_vehicle_database_update;
_dbID = _vehicle getVariable ["ExileDatabaseID",-1];

if(_dbID > -1) then 
{
	_data = [(getPlayerUID _playerObject), _dbID];
	
	_extDBMessage = ["loadVehicleToVGPublic", _data] call ExileServer_util_extDB2_createMessage;
	_extDBMessage call ExileServer_system_database_query_fireAndForget;
	
	_vehicle call ExileServer_system_vehicleSaveQueue_removeVehicle;
	_vehicle call ExileServer_system_simulationMonitor_removeVehicle;
	
	deleteVehicle _vehicle;
	[_sessionID, "toastRequest", ["SuccessTitleAndText", ["Public Garage", "Vehicle Stored!"]]] call ExileServer_system_network_send_to;
};

true