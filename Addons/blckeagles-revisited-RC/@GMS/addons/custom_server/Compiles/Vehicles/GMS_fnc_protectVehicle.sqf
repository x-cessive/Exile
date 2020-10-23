// Protect Vehicles from being cleaned up by the server

/*
	--------------------------
	License
	--------------------------
	All the code and information provided here is provided under an Attribution Non-Commercial ShareAlike 4.0 Commons License.

	http://creativecommons.org/licenses/by-nc-sa/4.0/
*/
#include "\q\addons\custom_server\Configs\blck_defines.hpp";

params["_veh"];

if (blck_modType isEqualTo "Epoch") then
{
	_veh call EPOCH_server_setVToken;
};



