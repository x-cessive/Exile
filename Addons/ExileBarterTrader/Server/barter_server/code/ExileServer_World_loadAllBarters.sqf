 /*
 *
 * Author: Andrew_S90
 *
 * This work is protected by Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International (CC BY-NC-SA 4.0). 
 *
 */
 
private["_continueLoading", "_page", "_pageSize", "_clanIDs", "_numberOfClans", "_i"];
"Loading Barter lists..." call ExileServer_util_log;

BarterMasterList = [];
"Clearing saved trader info..." call ExileServer_util_log;
format["clearSavedBarterInfo"] call ExileServer_system_database_query_fireAndForget;


_traderTypes = (missionConfigfile >> "CfgBarter" >> "Barters") call BIS_fnc_returnChildren;

for "_i" from 0 to ((count _traderTypes) - 1) do 
{
	_traderItems = (_traderTypes select _i) call BIS_fnc_returnChildren;
	_traderArray = [];
	_traderClassnames = [];
	{
		_chance = getNumber (_x >> "chance");
		_min = getNumber (_x >> "min");
		_max = getNumber (_x >> "max");
		_blockItem = getText (_x >> "block_item");
		if((floor (random 100)) < _chance) then
		{
			_quantity = round ((random (_max-_min)) + _min);
			if !(_blockItem in _traderClassnames) then
			{
				_traderArray pushBack [configName _x,_quantity];
				_traderClassnames pushBack (configName _x);
			};
		};
	} forEach _traderItems; 
	BarterMasterList pushBack _traderArray;
};
ExileClientPlayerBarterMasterList = BarterMasterList;
publicVariable "ExileClientPlayerBarterMasterList";

"Done loading Barter lists!" call ExileServer_util_log;
true