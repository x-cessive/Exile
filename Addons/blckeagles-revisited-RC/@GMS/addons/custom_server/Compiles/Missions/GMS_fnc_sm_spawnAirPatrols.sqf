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

/*
_coords = _this select 0;
_skillAI = _this select 1;
_weapons = _this select 2;
_uniforms = _this select 3;
_headGear = _this select 4;
_helis = _this select 5;
*/

params["_airPatrols","_noAirPatrols","_heliTypes","_center","_difficulty","_uniforms","_headGear","_weapons"];
diag_log format["_sm_spawnAirPatrols:: _this = %1",_this];
diag_log format["_sm_spawnAirPatrols:: _airPatrols = %1",_airPatrols];
if (_airPatrols isEqualTo []) then
{
	for "_i" from 1 to _noAirPatrols do
	{
		/*
		_coords = _this select 0;
		_skillAI = _this select 1;
		_weapons = _this select 2;
		_uniforms = _this select 3;
		_headGear = _this select 4;
		_helis = _this select 5;
		*/
		// params["_coords","_skillAI","_helis",["_uniforms",[]], ["_headGear",[]],["_vests",[]],["_backpacks",[]],["_weaponList",[]],["_sideArms",[]],["_Launcher","none"],["_crewCount",4]];
		[_center,_difficulty,_weapons,_uniforms,_headGear,_heliTypes,0] call blck_fnc_spawnMissionHeli;
	};
} else {
	{
	/*
		/*[aircraft classname, position, difficulty(blue, red etc)]*/
		_x params["_aircraft","_pos","_difficulty"];
		//_aircraft = _x select 0;
		//_pos = _x select 1;
		//_difficulty = _x select 2;
		//params["_coords","_skillAI","_helis",["_uniforms",[]], ["_headGear",[]],["_vests",[]],["_backpacks",[]],["_weaponList",[]],["_sideArms",[]],["_Launcher","none"],["_crewCount",4]];
		[_pos,_difficulty,_weapons,_uniforms,_headGear,_aircraft] call blck_fnc_spawnMissionHeli;
	}forEach _airPatrols;
};

