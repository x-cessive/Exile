/*
	Determines the total number of spawned groups on the side used by the mission system and returns this value.

	By Ghostrider [GRG]
	Copyright 2016	
	--------------------------
	License
	--------------------------
	All the code and information provided here is provided under an Attribution Non-Commercial ShareAlike 4.0 Commons License.

	http://creativecommons.org/licenses/by-nc-sa/4.0/
*/
#include "\q\addons\custom_server\Configs\blck_defines.hpp";

private _groups_AI_Side = {(side _x) isEqualTo blck_AI_side} count allGroups;

_groups_AI_Side
