/*
	By Ghostrider [GRG]
	Copyright 2016
	--------------------------
	License
	--------------------------
	All the code and information provided here is provided under an Attribution Non-Commercial ShareAlike 4.0 Commons License.

	http://creativecommons.org/licenses/by-nc-sa/4.0/
*/
#include "\q\addons\custom_server\Configs\blck_defines.hpp";

params["_aiDifficulty"];
private["_vehicle"];
switch(toLower _aiDifficulty) do
{
	case "blue":{_vehicle = selectRandom blck_AIPatrolVehiclesBlue};
	case "red":{_vehicle = selectRandom blck_AIPatrolVehiclesRed};
	case "green":{_vehicle = selectRandom blck_AIPatrolVehiclesGreen};
	case "orange":{_vehicle = selectRandom blck_AIPatrolVehiclesOrange};
	default {_vehicle = blck_AIPatrolVehicles};
};

_vehicle



