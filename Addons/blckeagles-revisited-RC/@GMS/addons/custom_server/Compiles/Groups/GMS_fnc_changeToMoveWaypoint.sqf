// Changes type of waypont0 for the specified group to "MOVE" and updates  time stamps, WP postion and Timout parameters accordinglyD.
/*
	for ghostridergaming
	By Ghostrider [GRG]
	Copyright 2016
	
	--------------------------
	License
	--------------------------
	All the code and information provided here is provided under an Attribution Non-Commercial ShareAlike 4.0 Commons License.

	http://creativecommons.org/licenses/by-nc-sa/4.0/

	// TODO: used for 'unstuck' cases
*/
#include "\q\addons\custom_server\Configs\blck_defines.hpp";
#ifdef blck_debugMode
//diag_log "_fnc_changeToMoveWaypoint: blck_debugMode enabled";
#endif
private["_group","_wp","_wpPos","_dis","_arc","_dir","_newPos","_marker","_center","_minDis","_maxDis"];

_group = group _this;
_group setcombatmode "YELLOW";
_group setBehaviour "COMBAT";
_group setVariable["timeStamp",diag_tickTime];
_wp = [_group, 0];
_wpPos = getPos ((units _group) select 0);
_dir = _group getVariable["wpDir",0];
_center = _group getVariable ["patrolCenter",_wpPos];
if (_group getVariable["wpMode","random"] isEqualTo "random") then
{
	_dir = random(360);
} else {
	_dir = (_group getVariable["wpDir",0]) + 70;
	_group setVariable["wpDir",_dir];
};
_minDis = _group getVariable["minDis",25];
_maxDis = _group getVariable["maxDis",30];
_dis = (_minDis) + random( (_maxDis) - (_minDis) );
_newPos = (_center) getPos[_dis,_dir];
_wp setWPPos [_newPos select 0, _newPos select 1];
_wp setWaypointCompletionRadius (_group getVariable["wpRadius",0]);
_wp setWaypointType "MOVE";
_wp setWaypointName "move";
_wp setWaypointBehaviour "COMBAT";
_wp setWaypointCombatMode "RED";
_wp setWaypointTimeout [10,15,20];
_wp setWaypointLoiterRadius (_group getVariable["wpRadius",30]);
_wp setWaypointLoiterType "CIRCLE";
_wp setWaypointSpeed "LIMITED";
_group setCurrentWaypoint _wp;
diag_log format["_fnc_changeToMoveWaypoint:: -- >> group to update is %1 and new Waypoint position is %2",_group, getWPPos _wp];
#ifdef blck_debugMode
if (blck_debugLevel > 2) then
{
	diag_log format["_fnc_changeToMoveWaypoint (4/25/17): _this = %1", _this];
	diag_log format["_fnc_changeToMoveWaypoint: typeName _this = %1", typeName _this];
	diag_log format["_fnc_changeToMoveWaypoint:_group = %1",_group];
	diag_log format["_fnc_changeToMoveWaypoint:_group timestamp updated to %1", _group getVariable "timeStamp"];
	diag_log format["_fnc_changeToMoveWaypoint:: -- >> wpMode %1 _dir %2 _dis %3 _center %4",_group getVariable["wpMode","random"], _dir, _dis,_center];
	diag_log format["_fnc_changeToMoveWaypoint:: -- >> group to update is %1 and new position is %2",_group, _newPos];
	diag_log format["_fnc_changeToMoveWaypoint:: -- >> group to update is %1 and new Waypoint position is %2",_group, getWPPos _wp];
	diag_log format["_fnc_changeToMoveWaypoint:_group %1 basic waypoint parameters updates", _group getVariable "timeStamp"];
	_marker =_group getVariable["wpMarker",""];
	_marker setMarkerColor "ColorBlue";
	diag_log format["_fnc_changeToMoveWaypoint:: -- >> Waypoint marker for group %1 have been configured as %2",_group, _group getVariable "wpMarker"];	
};
#endif
if (_group getVariable["wpPatrolMode",""] isEqualTo "SAD") then
{
	#ifdef blck_debugMode
	if (blck_debugLevel > 2) then
	{
		diag_log format["_fnc_changeToMoveWaypoint: seting waypoint script for group %1 to SAD Mode",_group];
	};
	_wp setWaypointStatements ["true","this call blck_fnc_changeToSADWaypoint; diag_log format['====Updating timestamp for group %1 and changing its WP to a SAD Waypoint',group this];"];
	#else
	_wp setWaypointStatements ["true","this call blck_fnc_changeToSADWaypoint;"];
	#endif
};
if (_group getVariable["wpPatrolMode",""] isEqualTo "SENTRY") then
{
	#ifdef blck_debugMode
	if (blck_debugLevel > 2) then
	{
		diag_log format["_fnc_changeToMoveWaypoint: seting waypoint script for group %1 to SENTRY Mode",_group];
	};
	_wp setWaypointStatements ["true","this call blck_fnc_changeToSentryWaypoint; diag_log format['====Updating timestamp for group %1 and changing its WP to a SENTRY Waypoint',group this];"];
	#else
	_wp setWaypointStatements ["true","this call blck_fnc_changeToSentryWaypoint;"];
	#endif
};
#ifdef blck_debugMode
if (blck_debugLevel > 2) then
{
	diag_log format["_fnc_changeToMoveWaypoint:: -- >> Waypoint statements for group %1 have been configured as %2",_group, waypointStatements _wp];
};
#endif
