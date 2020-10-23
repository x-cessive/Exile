/*
	By Ghostrider [GRG]
	Copyright 2016
	
	--------------------------
	License
	--------------------------
	All the code and information provided here is provided under an Attribution Non-Commercial ShareAlike 4.0 Commons License.

	http://creativecommons.org/licenses/by-nc-sa/4.0/	
*/

//Based on the Random Loot Crates addon by Darth_Rogue & Chisel (tdwhite)  
// Re-written by Ghostrider [GRG] to add features and clean up code

// Do not touch anything below this line.
/// ********************************************************************************************************************************************************************************************************************************
_box1_loadout = [[_loot_pistols,_box1_Pistols],[_loot_rifles,_box1_Rifles],[_loot_LMG,_box1_LMG],[_loot_snipers,_box1_Snipers],[_loot_magazines,_box1_Mags],[_loot_optics,_box1_Optics],[_loot_silencers,_box1_Silencers],
				[_loot_explosives,_box1_Explosives],[_loot_food,_box1_FoodDrink],[_loot_Misc,_box1_Misc],[_loot_backpacks,_box1_Backpacks],[_loot_build,_box1_BuildingSupplies],[_loot_tools,_box1_Tools],[_loot_Misc,_box1_Misc],
				[_loot_launchers,_box1_launchers],[_box1_bonus_items,_box1_bonus]];
_box2_loadout = [[_loot_pistols,_box2_Pistols],[_loot_rifles,_box2_Rifles],[_loot_LMG,_box2_LMG],[_loot_snipers,_box2_Snipers],[_loot_magazines,_box2_Mags],[_loot_optics,_box2_Optics],[_loot_silencers,_box2_Silencers],
				[_loot_explosives,_box2_Explosives],[_loot_food,_box2_FoodDrink],[_loot_Misc,_box2_Misc],[_loot_backpacks,_box2_Backpacks],[_loot_build,_box2_BuildingSupplies],[_loot_tools,_box2_Tools],[_loot_Misc,_box2_Misc],
				[_loot_launchers,_box2_launchers],[_box2_bonus_items,_box2_bonus]];
_box3_loadout = [[_loot_pistols,_box3_Pistols],[_loot_rifles,_box3_Rifles],[_loot_LMG,_box3_LMG],[_loot_snipers,_box3_Snipers],[_loot_magazines,_box3_Mags],[_loot_optics,_box3_Optics],[_loot_silencers,_box3_Silencers],
				[_loot_explosives,_box3_Explosives],[_loot_food,_box3_FoodDrink],[_loot_Misc,_box3_Misc],[_loot_backpacks,_box3_Backpacks],[_loot_build,_box3_BuildingSupplies],[_loot_tools,_box3_Tools],[_loot_Misc,_box3_Misc],
				[_loot_launchers,_box3_launchers],[_box3_bonus_items,_box3_bonus]];
				
// allows a visible cue to be spawned near the crate
_fn_smokeAtCrate = { // adapted from Ritchies heli crash addon
		params["_pos"];
		private["_wreckChoices"];
		_wreckChoices = ["Land_Wreck_Car2_F","Land_Wreck_Car3_F","Land_Wreck_Car_F","Land_Wreck_Offroad2_F","Land_Wreck_Offroad_F","Land_Tyres_F","Land_Pallets_F","Land_MetalBarrel_F"];
		//  params["_pos","_mode",["_maxDist",12],["_wreckChoices",_wrecks],["_addFire",false]];
		[_pos,"random",8,_wreckChoices,false] call blck_fnc_smokeAtCrates;
};
  
// fill the crate with something
_fn_spawnCrate = {
	private["_crate","_minDistfromCenter","_maxDistfromCenter","_clossestObj","_spawnOnWater","_spawnAtShore","_pos","_px","_py","_pz"];

	params["_cratePos",["_randomLocation",true]];
	
	// Spawn an Empty a Crate
	// find a safe location for the crate
	_minDistfromCenter = 0;
	_maxDistfromCenter = 25;
	_clossestObj = 10;
	_spawnOnWater = 0; // water mode 0: cannot be in water , 1: can either be in water or not , 2: must be in water
	_spawnAtShore = 0; // 0: does not have to be at a shore , 1: must be at a shore
	
	if (_randomLocation) then{
		_pos = [_cratePos,_minDistfromCenter,_maxDistfromCenter,_clossestObj,_spawnOnWater,20,_spawnAtShore] call BIS_fnc_findSafePos; // find a random loc 
		if (count _pos < 3) then {_pos pushback 0;};
	}
	else
	{
		_pos = _cratePos;
		//diag_log format["crate spawner using exact position %1",_pos];
	};
	#ifdef blck_debugMode
	if (blck_debugLevel > 0) then
	{
		diag_log format["[blckeagls[ SLS ::  _fn_spawnCrate %1  _randomLocation %2  crate position %3",_cratePos,_randomLocation,_pos];
	};
	#endif
	private["_crateTypes","_selectedCrateType"];
	//_crateTypes = ["I_CargoNet_01_ammo_F","O_CargoNet_01_ammo_F","B_CargoNet_01_ammo_F","I_supplyCrate_F","Box_East_AmmoVeh_F","Box_NATO_AmmoVeh_F"];
	_selectedCrateType = selectRandom blck_crateTypes;	
	_crate = [[0,0,0],_selectedCrateType] call blck_fnc_spawnCrate;
	_crate setPosATL _pos;
	_crate setDir round(random(360));
	_crate setVectorUp surfaceNormal _pos;
	_crate
};

_fn_setupCrates = {
	params["_location","_lootType","_randomPos","_useSmoke"];
	private["_crate"];
	
	_crate = [_location,_randomPos] call _fn_SpawnCrate;
	_lootType = selectrandom [1,2,3];
	switch(_lootType) do
	{
		// format here is [_arrayOfLoot, crateToLoad, magazinesToAddForEachWeaponLoaded]
		case 1:{[_box1_loadout,_crate,3] call blck_fnc_loadLootItemsFromArray;};
		case 2:{[_box2_loadout, _crate,3] call blck_fnc_loadLootItemsFromArray;};
		case 3:{[_box3_loadout, _crate,3] call blck_fnc_loadLootItemsFromArray;};
	};
	if (_useSmoke) then {[getPos _crate] call _fn_smokeAtCrate;};
	#ifdef blck_debugMode
	if (blck_debugON) then 
	{
		_blck_localMissionMarker = [format["SLS%1%2",_location select 0, _location select 1],(getPos _crate),"","","ColorGreen",["mil_box",[]]];
		diag_log format["[blckeagls] SLS:: spawning diagnostic marker at %1",getPos _crate];
		// params["_missionType","_markerPos","_markerLabel","_markerLabelType","_markerColor","_markerType"];
		[_blck_localMissionMarker] call blck_fnc_spawnMarker;
	};
	#endif
	_crate
};
//diag_log "[blckeagls] SLS System: Functions Initialized!";
private["_cratePos","_lootType","_randomPos","_useSmoke"];
{
	_x params ["_map","_name","_no","_ar"];
	private["_index"];
	_index = 1;
	if (blck_debugON) then
	{
		diag_log format["[blckeagls] SLS :: main function: Location name = %3 |count _ar = %1 | _index = %2", count _ar, _index, _name];
		diag_log format["[blckeagls] SLS :: main function: count _ar = %1", _ar];
	};
	if ((tolower _map) isEqualto (toLower(worldName))) then
	{
		for "_i" from 1 to _no do
		{
			// Pick a random element and be sure it has not already been selected
			_ar = _ar call Bis_fnc_arrayshuffle;
			_crateParams = _ar deleteat 0;
			if (blck_debugON) then
			{
				diag_log format["[blckeagls] SLS:: spawning crate spawning crate at location name %1 with parameters of %2 --->>> %1",_name,_crateParams];
			};
//			_crateParams params["_cratePos","_lootType","_randomPos","_useSmoke"];
			_crateParams call _fn_setupCrates;
		};
	};
} forEach _lootBoxes; 
							

