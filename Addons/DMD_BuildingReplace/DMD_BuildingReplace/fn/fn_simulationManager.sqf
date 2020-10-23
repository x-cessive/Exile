/*
	Author: JakeHekesFists[DMD]
	Date:	11/12/2017
	Public Release version 1.0
	
	this script is spawned after building replace fires. it only enables simulation manager AFTER the buildings have been replaced. 
	and makes use of the exile simulation manager, so only buildings with a player nearby will be simulated.
	
*/

params ["_objects"];
{
	_x enableSimulationGlobal true; 
	_x call ExileServer_system_simulationMonitor_addVehicle;
	sleep 0.001; 
} forEach _objects;