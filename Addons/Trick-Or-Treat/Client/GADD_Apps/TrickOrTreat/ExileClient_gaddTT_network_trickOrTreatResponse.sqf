/**
	Name: Trick Or Treat Response
	Description: Spawns the reward items in for the Trick or Treaters.
	Author: [GADD]Monkeynutz
**/

#include "GADD_TreatList.sqf"

diag_log format ["GADDToTDEBUG: %1", _this];

_treatList = GADD_TreatList;
_numberOfMags = getNumber (missionConfigFile >> "GADDTrickOrTreat" >> "GADDTTNumberOfMags");

_selectedTreat = selectRandom _treatList;

_treatChance = getNumber (missionConfigFile >> "GADDTrickOrTreat" >> "GADDTreatChance");

_chance = round (random 100);
_trick = false;

if (_chance > _treatChance) then
{
	_trick = true;
};

if (_trick) then
{
	_script = selectRandom [ GADD_TT_Smoke, GADD_TT_Bombs, GADD_TT_Tripwire];
	playSound selectRandom ["Laugh1", "Laugh2", "Laugh3"];
	call _script;
}
else
{
	["SuccessTitleAndText", ["Trick or Treat!", "You've got yourself a nice Treat! It's on the floor by your feet!"]] call ExileClient_gui_toaster_addTemplateToast;
	_holder = "GroundWeaponHolder" createVehicle position player;
	_selectedTreatClass = _selectedTreat select 0;
	_selectedTreatTotal = _selectedTreat select 1;
	_cfgClass = _selectedTreatClass call ExileClient_util_gear_getConfigNameByClassName;
	if (_cfgClass == "CfgWeapons") then
	{
		_holder addWeaponCargoGlobal [_selectedTreatClass, 1];
		_ammo = getArray (configFile >> "CfgWeapons" >> _selectedTreatClass >> "magazines");
		_ammoSelect = selectRandom _ammo;
		_holder addMagazineCargoGlobal [_ammoSelect, _numberOfMags];
		_holder setPosATL getPosATL player;
	}
	else
	{
		_holder addItemCargoGlobal _selectedTreat;
		_holder setPosATL getPosATL player;
	};
};