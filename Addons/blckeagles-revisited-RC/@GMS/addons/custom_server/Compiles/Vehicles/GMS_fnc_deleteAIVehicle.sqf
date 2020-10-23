/*
  Delete a unit.
  by Ghostrider
	--------------------------
	License
	--------------------------
	All the code and information provided here is provided under an Attribution Non-Commercial ShareAlike 4.0 Commons License.

	http://creativecommons.org/licenses/by-nc-sa/4.0/
*/
#include "\q\addons\custom_server\Configs\blck_defines.hpp";

params["_veh"];
blck_monitoredVehicles = blck_monitoredVehicles - [_veh];			
deleteVehicle _veh;
