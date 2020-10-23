/**
 * ExileServer_object_lock_network_hotwireLockRequest
 *
 * Exile Mod
 * www.exilemod.com
 * © 2015 Exile Mod Team
 *
 * This work is licensed under the Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 International License. 
 * To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-nd/4.0/.
 */
 
 diag_log "Paintshop server call executed";
 
 private["_sessionID","_parameters","_vehicleNetID","_skinTextures","_vehicleObject","_salesPrice","_vehicleID"];
 
_sessionID = _this select 0;
_parameters = _this select 1;
_vehicleNetID = _parameters select 0;
_skinTextures = _parameters select 1;
_vehicleObject = objectFromNetId _vehicleNetID;
	
	_vehicleID = _vehicleObject getVariable ["ExileDatabaseID", -1];
	format["updateVehicleSkin:%1:%2", _skinTextures, _vehicleID] call ExileServer_system_database_query_fireAndForget;

