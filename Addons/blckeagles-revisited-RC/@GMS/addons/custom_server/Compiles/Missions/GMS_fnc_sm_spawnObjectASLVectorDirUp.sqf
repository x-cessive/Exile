
/*
	by Ghostrider [GRG]
	for ghostridergaming
	12/5/17
	--------------------------
	License
	--------------------------
	All the code and information provided here is provided under an Attribution Non-Commercial ShareAlike 4.0 Commons License.

	http://creativecommons.org/licenses/by-nc-sa/4.0/	
*/
#include "\q\addons\custom_server\Configs\blck_defines.hpp";
params["_buildingClassName","_posASL","_vectorDirUp","_enableDamSim"];
_object = createVehicle [_buildingClassName, [0,0,0], [], 0, "CAN_COLLIDE"];
_object setPosASL _posASL;
_object setVectorDirAndUp _vectorDirUp;
_object enableSimulationGlobal (_enableDamSim select 0);
_object allowDamage (_enableDamSim select 1);

_object