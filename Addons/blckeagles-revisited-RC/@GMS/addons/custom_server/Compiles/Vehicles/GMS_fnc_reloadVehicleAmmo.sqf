

/*
	Reloaded eventhandler for _units
	By Ghostrider-GRG-

	--------------------------
	License
	--------------------------
	All the code and information provided here is provided under an Attribution Non-Commercial ShareAlike 4.0 Commons License.

	http://creativecommons.org/licenses/by-nc-sa/4.0/
*/
#include "\q\addons\custom_server\Configs\blck_defines.hpp";

	params["_veh"];
	private ["_crew","_mag","_allMags","_cnt"];
	//  https://community.bistudio.com/wiki/fullCrew
	if ({alive _x and !(isPlayer _x)} count (crew _veh) > 0) then
	{
		_crew = fullCrew _veh;
		{
			_mag = _veh currentMagazineTurret (_x select 3);
			if (count _mag > 0) then
			{
				_allMags = magazinesAmmo _veh;
	
				_cnt = ( {_mag isEqualTo (_x select 0)}count _allMags);
				if (_cnt < 2) then {_veh addMagazineCargo [_mag,2]};
			};
		} forEach _crew;
	};
