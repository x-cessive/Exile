/*
	By Ghostrider [GRG]

	--------------------------
	License
	--------------------------
	All the code and information provided here is provided under an Attribution Non-Commercial ShareAlike 4.0 Commons License.

	http://creativecommons.org/licenses/by-nc-sa/4.0/
*/
	params["_ai"];
	{deleteVehicle _x}forEach nearestObjects [(getPosATL _ai), ['GroundWeaponHolder','WeaponHolderSimulated','WeaponHolder'], 3];   //Adapted from the AI cleanup logic by KiloSwiss
	[_ai] call blck_fnc_removeGear;