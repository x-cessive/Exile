 /*
 *
 * Author: Andrew_S90
 *
 * This work is protected by Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International (CC BY-NC-SA 4.0). 
 *
 */

private["_vehicleObject", "_players", "_sessionID"];
_vehicleObject = _this select 0;
_players = crew _vehicleObject;

{
	_sessionID = _x getVariable ["ExileSessionID", ""];
	[_sessionID,"incomingMissile",[_vehicleObject]] call ExileServer_system_network_send_to;
} forEach _players;
true

