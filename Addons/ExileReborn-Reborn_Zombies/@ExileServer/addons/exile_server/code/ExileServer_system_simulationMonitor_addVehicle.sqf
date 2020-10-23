/**
 * ExileServer_system_simulationMonitor_addVehicle
 *
 * Exile Mod
 * www.exilemod.com
 * © 2015 Exile Mod Team
 *
 * This work is licensed under the Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 International License. 
 * To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-nd/4.0/.
 */
 
private["_vehicle"];
_vehicle = _this;
if !(isNull _vehicle) then
{
	if !(_vehicle getVariable["ExileIsSimulationMonitored", false]) then
	{
		_vehicle setVariable ["ExileIsSimulationMonitored", true];
		ExileSimulationMonitoredVehicles pushBack _vehicle;
	};
};
true