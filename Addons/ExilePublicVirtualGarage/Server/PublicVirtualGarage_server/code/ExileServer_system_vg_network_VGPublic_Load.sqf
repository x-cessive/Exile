private["_sessionID","_parameters", "_playerObject", "_VehicleID", "_data", "_extDBMessage", "_vehicleObject", "_pincode"];

_sessionID = _this select 0;
_parameters = _this select 1;
_playerObject = _sessionID call ExileServer_system_session_getPlayerObject;

_VehicleID = format["loadVehicleFromVGPublicFirst:%1", (getPlayerUID _playerObject)] call ExileServer_system_database_query_selectSingle;
if(_VehicleID isEqualType []) exitWith 
{
	_vehicleObject = (_VehicleID select 0) call ExileServer_object_vehicle_database_load;

	_data = [(_VehicleID select 0)];

	_extDBMessage = ["loadVehicleFromVGPublic", _data] call ExileServer_util_extDB2_createMessage;
	_extDBMessage call ExileServer_system_database_query_fireAndForget;
	_pincode = _vehicleObject getVariable ["ExileAccessCode", 0000];
	
	[
		[
			netId _vehicleObject,
			_pincode
		],
		{
			params ['_vehicleNetID', '_pincode'];
			_vehicleObject = objectFromNetId _vehicleNetID;
			player moveInDriver _vehicleObject;
			if (profileNameSpace getVariable ["ExileStreamFriendlyUI", false]) then
			{
				["SuccessTitleAndText", ["Public Garage", "Vehicle Loaded! We do not show you the PIN in streamer friendly mode."]] call ExileClient_gui_toaster_addTemplateToast;
			}
			else 
			{
				["SuccessTitleAndText", ["Public Garage", format ["Vehicle Loaded! Your PIN is %1.", _pincode]]] call ExileClient_gui_toaster_addTemplateToast;
			};
		}
	] remoteExecCall ['call',owner _playerObject,false];
	
	true
};
[_sessionID, "toastRequest", ["ErrorTitleAndText", ["Public Garage", "No vehicle found!"]]] call ExileServer_system_network_send_to;
true