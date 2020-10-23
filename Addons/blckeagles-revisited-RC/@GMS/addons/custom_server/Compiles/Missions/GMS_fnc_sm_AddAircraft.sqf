/*
	by Ghostrider [GRG]

	--------------------------
	License
	--------------------------
	All the code and information provided here is provided under an Attribution Non-Commercial ShareAlike 4.0 Commons License.

	http://creativecommons.org/licenses/by-nc-sa/4.0/	
*/
#include "\q\addons\custom_server\Configs\blck_defines.hpp";
//diag_log format["_sm_addAircraft: _this = %5",_this];
params["_aircraftPatrol"];
//diag_log format["_sm_addAircraft: _aircraftPatrol = %1",_aircraftPatrol];
blck_sm_Aircraft pushBack [_aircraftPatrol,grpNull,0];
//diag_log format["_sm_addAircraft: updated blck_sm_Aircraft = %1",blck_sm_Aircraft];
true
