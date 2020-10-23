/*
	[
		_missionColor  // ["blue","red","green","orange"]
	] call blck_fnc_selectAILoadout;
	
	returns:
	_lootarray
	by Ghostrider [GRG]
	
	--------------------------
	License
	--------------------------
	All the code and information provided here is provided under an Attribution Non-Commercial ShareAlike 4.0 Commons License.

	http://creativecommons.org/licenses/by-nc-sa/4.0/	
*/
#include "\q\addons\custom_server\Configs\blck_defines.hpp";

private["_weaponList","_missionColor"];

_missionColor = _this select 0;
switch (_missionColor) do {
			case "blue": {_weaponList = blck_WeaponList_Blue;};
			case "red": {_weaponList = blck_WeaponList_Red;};
			case "green": {_weaponList = blck_WeaponList_Green;};
			case "orange": {_weaponList = blck_WeaponList_Orange;};
			default {_weaponList = blck_WeaponList_Blue;};
};
_weaponList	
