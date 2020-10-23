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

params["_SDV","_pos","_difficulty","_numAI","_patrolRadius","_respawnTime"];

private["_vehicle","_group","_diveDepth"];
_group = [blck_AI_Side,true]  call blck_fnc_createGroup;
if !(isNull _group) then 
{
	[_group,_pos,_numAI,_numAI,_difficulty,_pos,_patrolRadius - 2,_patrolRadius,blck_UMS_uniforms,blck_UMS_headgear,true,blck_UMS_weapons,blck_UMS_vests,true] call blck_fnc_spawnGroup;
	_vehicle = [[_pos select 0, _pos select 1,0],[_pos select 0, _pos select 1,0],_vehType,_patrolRadius - 2,_patrolRadius,_group] call blck_fnc_spawnVehiclePatrol;
	_diveDepth = 0.5 * [_pos] call blck_fnc_findWaterDepth;
	(driver _vehicle) swiminDepth (_diveDepth select 2);
};
_group
