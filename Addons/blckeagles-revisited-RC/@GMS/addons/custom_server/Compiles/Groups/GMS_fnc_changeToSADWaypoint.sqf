// Sets the WP type for WP for the specified group and updates other atributes accordingly.
/*
	for ghostridergaming
	By Ghostrider [GRG]
	Copyright 2016
	
	--------------------------
	License
	--------------------------
	All the code and information provided here is provided under an Attribution Non-Commercial ShareAlike 4.0 Commons License.

	http://creativecommons.org/licenses/by-nc-sa/4.0/

	// TODO: Still needed?
*/
#include "\q\addons\custom_server\Configs\blck_defines.hpp";

#ifdef blck_debugMode
diag_log "_fnc_changeToSADWaypoint: blck_debugMode enabled";
#endif

private["_group","_wp"];

_group = group _this;
_group setVariable["timeStamp",diag_tickTime];
_group setcombatmode "RED";
_group setBehaviour "COMBAT";
_wp = [_group, 0];
_group setCurrentWaypoint _wp;
_wp setWaypointType "SAD";
_wp setWaypointName "sad";
_wp setWaypointBehaviour "COMBAT";
_wp setWaypointCombatMode "RED";
_wp setWaypointTimeout [10,15,20];
diag_log format['====Updating timestamp for group %1 and changing its WP to a Move Waypoint',group this];
#ifdef blck_debugMode
if (blck_debugLevel > 2) then {_wp setWaypointStatements ["true","this call blck_fnc_changeToMoveWaypoint; diag_log format['====Updating timestamp for group %1 and changing its WP to a Move Waypoint',group this];"]};	
#else
_wp setWaypointStatements ["true","this call blck_fnc_changeToMoveWaypoint;"];
#endif

#ifdef blck_debugMode
if (blck_debugLevel > 2) then
{
	private ["_marker"];
	_marker = _group getVariable["wpMarker",""];
	_marker setMarkerColor "ColorRed";
	diag_log format["_fnc_changeToSADWaypoint:: -- :: _this = %1 and typName _this %2",_this, typeName _this];
	diag_log format["_fnc_changeToSADWaypoint:: -- >> group to update is %1 with typeName %2",_group, typeName _group];		
	diag_log format["_fnc_changeToSADWaypoint:: -- >> Waypoint statements for group %1 have been configured as %2",_group, waypointStatements _wp];		
	diag_log format["_fnc_changeToSADWaypoint:: -- >> Waypoint marker for group %1 have been configured as %2",_group, _group getVariable "wpMarker"];
};
#endif
