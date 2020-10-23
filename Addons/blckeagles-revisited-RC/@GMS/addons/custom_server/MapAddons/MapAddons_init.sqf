/*
	Run scripts exported from M3EDEN Editor plug in for Arma 3 or other map addons. 
	Add addons to the arrays for Epoch or Exile as appropriate.
	Arrays should contain ["mapname", "name of folder within mapaddons","name of file to execute"]
	by Ghostrider [GRG]
	for ghostridergaming
	11/12/16
	--------------------------
	License
	--------------------------
	All the code and information provided here is provided under an Attribution Non-Commercial ShareAlike 4.0 Commons License.

	http://creativecommons.org/licenses/by-nc-sa/4.0/	
*/

#include "\q\addons\custom_server\Configs\blck_defines.hpp";

if (!isServer) exitWith{};
_addonsPath = "\q\addons\custom_server\MapAddons\mapcontent\";
_addonsEpoch = [
	//["mapName","subfolder","filename.sqf"]
	// when "subfolder" equals "" then the spawner will look for the file in the mapcontent directory 

];

_addonsExile = [
	//["mapName","subfolder","filename.sqf"]
	// when "subfolder" equals "" then the spawner will look for the file in the mapcontent directory 
];


_fnc_runIt = 
{
	params["_addons"];
	if (blck_debugON) then {diag_log format["[blckeagls] MapAddons:: addons list is %1",_addons];};
	_worldName = toLower (worldName);
	{
		if (toLower format["%1",_x select 0] isEqualTo _worldName) then
		{
			_path = "";
			if ( (_x select 1) isEqualTo "") then 
			{
				_path = _addonsPath;
			} else {
				_path = format["%1%2%3",_addonsPath,_x select 1,"\"];
			};
			if (blck_debugLevel >= 1) then {diag_log format["[blckeagls] MapAddons::-->> Running the following script: %1%2",_path,_x select 2];};
			diag_log format["[blckeagls] MapAddons::-->> Running the following script: %1%2",_path,_x select 2];
			[] execVM format["%1%2",_path,_x select 2];
		};
	}forEach _addons;
};

if not (isNull( configFile >> "CfgPatches" >> "a3_epoch_server" )) then
{
	diag_log "[blckeagls] Running Map Addons for Epoch";
	[_addonsEpoch] call _fnc_runIt;
};

if not (isNull( configFile >> "CfgPatches" >> "exile_server" )) then
{
	diag_log "[blckeagls] Running Map Addons for Exile";
	[_addonsExile] call _fnc_runIt;
};
