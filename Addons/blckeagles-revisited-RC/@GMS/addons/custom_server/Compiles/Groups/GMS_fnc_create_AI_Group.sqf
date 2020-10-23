/*
	[] call blck_fnc_createGroup
	By Ghostrider [GRG]
	Copyright 2016
	--------------------------
	License
	--------------------------
	All the code and information provided here is provided under an Attribution Non-Commercial ShareAlike 4.0 Commons License.

	http://creativecommons.org/licenses/by-nc-sa/4.0/
*/
#include "\q\addons\custom_server\Configs\blck_defines.hpp";
params[["_side",blck_AI_Side],["_deleteWhenEmpty",true]];
// for information about the _deleteWhenEmpty parameter see: https://community.bistudio.com/wiki/createGroup

private _groupSpawned = createGroup [_side, true]; 
if (isNull _groupSpawned) exitWith{"ERROR:-> Null Group created by blck_fnc_spawnGroup";};
if (blck_simulationManager == blck_useDynamicSimulationManagement) then 
{
	_groupSpawned enableDynamicSimulation true;
};
_groupSpawned setcombatmode "RED";
_groupSpawned setBehaviour "COMBAT";
_groupSpawned allowfleeing 0;
_groupSpawned setspeedmode "FULL";
_groupSpawned setFormation blck_groupFormation; 
_groupSpawned setVariable ["blck_group",1];
_groupSpawned