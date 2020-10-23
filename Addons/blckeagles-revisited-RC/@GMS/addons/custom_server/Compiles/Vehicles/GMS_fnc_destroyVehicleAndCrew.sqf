
/*
	By Ghostrider-GRG-

	--------------------------
	License
	--------------------------
	All the code and information provided here is provided under an Attribution Non-Commercial ShareAlike 4.0 Commons License.

	http://creativecommons.org/licenses/by-nc-sa/4.0/
*/
#include "\q\addons\custom_server\Configs\blck_defines.hpp";
params["_veh"];
{[_x] call blck_fnc_deleteAI;} forEach (crew _veh);
[_veh] call blck_fnc_deleteAIvehicle;
