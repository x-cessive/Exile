/**
 * ExileServer_system_vehicleSaveQueue_addVehicle
 *
 * Exile Mod
 * www.exilemod.com
 * © 2015 Exile Mod Team
 *
 * This work is licensed under the Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 International License. 
 * To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-nd/4.0/.
 */
 
private["_vehicleObject"];
_vehicleObject = _this;
if !(_vehicleObject in ExileServerVehicleSaveQueue) then
{
	if (_vehicleObject getVariable ["ExileIsPersistent", false]) then
	{
		_vehicleObject setVariable ["ExileVehicleSaveQueuedAt", time];
		ExileServerVehicleSaveQueue pushBack _vehicleObject;
	};
};
true;