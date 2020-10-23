/*
	by Ghostrider

	Removes an AI launcher and ammo
	--------------------------
	License
	--------------------------
	All the code and information provided here is provided under an Attribution Non-Commercial ShareAlike 4.0 Commons License.

	http://creativecommons.org/licenses/by-nc-sa/4.0/
*/
#include "\q\addons\custom_server\Configs\blck_defines.hpp";

private["_launcher","_launcherRounds"];
params["_unit"];  // = _this select 0;
_launcher = _unit getVariable ["Launcher",""];
_unit removeWeapon _Launcher;
if (_launcher != "") then 
{
	_unit removeWeapon _Launcher;
	{
		if (_launcher in weaponCargo _x) exitWith {
			deleteVehicle _x;
		};
	} forEach ((getPosATL _unit) nearObjects ["WeaponHolderSimulated",10]);	
	_launcherRounds = getArray (configFile >> "CfgWeapons" >> _Launcher >> "magazines"); //0;
	{
		if(_x in _launcherRounds) then {_unit removeMagazine _x;};
	} count magazines _unit;
};

