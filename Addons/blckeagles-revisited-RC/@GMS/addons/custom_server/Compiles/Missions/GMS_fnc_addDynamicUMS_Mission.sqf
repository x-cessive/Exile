/*
	by Ghostrider [GRG]
	Copyright 2016
	--------------------------
	License
	--------------------------
	All the code and information provided here is provided under an Attribution Non-Commercial ShareAlike 4.0 Commons License.

	http://creativecommons.org/licenses/by-nc-sa/4.0/	
*/
#include "\q\addons\custom_server\Configs\blck_defines.hpp";
//params["_pos"];
private["_UMS_mission","_waitTime","_mission","_pos"];

if (count blck_dynamicUMS_MissionList == 0) exitWith
{
	blck_numberUnderwaterDynamicMissions = -1;
	diag_log "No Dynamic UMS Missions Listed <spawning disabled>";
};
_UMS_mission = selectRandom blck_dynamicUMS_MissionList;
_waitTime = (blck_TMin_UMS) + random(blck_TMax_UMS - blck_TMin_UMS);
_mission = format["%1%2","Mafia Pirates",floor(random(1000000))];
_pos = call blck_fnc_findShoreLocation;
#ifdef blck_debugMode
if (blck_debugLevel >= 2) then {diag_log format["_fnc_addDynamicUMS_Mission: blck_dynamicUMS_MissionsRuning = %1 | blck_missionsRunning = %2 | blck_UMS_ActiveDynamicMissions = %3",blck_dynamicUMS_MissionsRuning,blck_missionsRunning,blck_UMS_ActiveDynamicMissions]};;
#endif
blck_UMS_ActiveDynamicMissions pushBack _pos;
blck_missionsRunning = blck_missionsRunning + 1;
blck_dynamicUMS_MissionsRuning = blck_dynamicUMS_MissionsRuning + 1;
//diag_log format["[blckeagls] UMS Spawner:-> waiting for %1",_waitTime];
uiSleep _waitTime;
//diag_log format["[blckeagls] UMS Spawner:-> spawning mission %1",_UMS_mission];
[_pos,_mission] call compileFinal preprocessFileLineNumbers format["q\addons\custom_server\Missions\UMS\dynamicMissions\%1",_UMS_mission];
