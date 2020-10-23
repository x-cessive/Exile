/*
	by Ghostrider [GRG]

	--------------------------
	License
	--------------------------
	All the code and information provided here is provided under an Attribution Non-Commercial ShareAlike 4.0 Commons License.

	http://creativecommons.org/licenses/by-nc-sa/4.0/	
*/
#include "\q\addons\custom_server\Configs\blck_defines.hpp";

params["_vehicle"];
blck_sm_Vehicles pushBack [_vehicle,grpNull,0];
//diag_log format["_fnc_sm_AddVehicle: _vehicle = %1",_vehicle];
true