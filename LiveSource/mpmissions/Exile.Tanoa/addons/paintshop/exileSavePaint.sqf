private["_object","_vehicleObj","_objectNetId","_NR_usedTextures"];
_object = _this select 0;
_vehicleObj = _object;
_objectNetId = netId _object;
_NR_usedTextures = getObjectTextures _vehicleObj;

hint "Paint Saved!";
// hint format ["Vehicle textures = %1 \n \n ObjectNetId = %2 \n \n Object = %3", _NR_usedTextures, _ObjectNetId, _vehicleObj];


["saveVehiclePaintRequest",[_objectNetId,_NR_usedTextures]] call ExileClient_system_network_send;
/*
_object = cursorTarget;
_vehicleObj = _object;
_objectNetId = netId _object;
_object = typeOf _object;

_NR_usedTextures = getObjectTextures _vehicleObj;


hint format ["Vehicle textures = %1 \n \n ObjectNetId = %2", _NR_usedTextures, _ObjectNetId];
//["NR_exileSavePaintshop",[_NR_usedTextures,_ObjectNetId]] call ExileClient_system_network_send;
	
	*/
	
	/*_vehicleID = _vehicleObject getVariable ["ExileDatabaseID", -1];
	format["updateVehicleSkin:%1:%2", _NR_usedTextures, _vehicleID] call ExileServer_system_database_query_fireAndForget;*/
	