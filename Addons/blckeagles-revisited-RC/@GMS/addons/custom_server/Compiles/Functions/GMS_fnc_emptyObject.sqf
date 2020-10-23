
/*
		Remove all inventory from an object.

	By Ghostrider [GRG]
	Copyright 2016	
	--------------------------
	License
	--------------------------
	All the code and information provided here is provided under an Attribution Non-Commercial ShareAlike 4.0 Commons License.

	http://creativecommons.org/licenses/by-nc-sa/4.0/
*/
#include "\q\addons\custom_server\Configs\blck_defines.hpp";
	
params["_veh"];
clearWeaponCargoGlobal    _veh;
clearMagazineCargoGlobal  _veh;
clearBackpackCargoGlobal  _veh;
clearItemCargoGlobal      _veh;
