/*
	Mission Template by Ghostrider [GRG]
	Mission Compositions by Bill prepared for ghostridergaming
	Copyright 2016
	Last modified 3/20/17
	
	--------------------------
	License
	--------------------------
	All the code and information provided here is provided under an Attribution Non-Commercial ShareAlike 4.0 Commons License.

	http://creativecommons.org/licenses/by-nc-sa/4.0/
*/
#include "\q\addons\custom_server\Configs\blck_defines.hpp";
#include "\q\addons\custom_server\Missions\privateVars.sqf";
	
//diag_log "[blckeagls] Spawning Green Mission with template = resupplyCamp";
_crateLoot = blck_BoxLoot_Green;
_lootCounts = blck_lootCountsGreen;
_startMsg = "A Bandit resupply camp has been spotted. Check the Green marker on your map for its location";
_endMsg = "The Bandit resupply camp at the Green Marker is under player control";
_markerLabel = "";
_markerType = ["ellipse",[225,225],"GRID"];
_markerColor = "ColorGreen";
_markerMissionName = "Resupply Camp";
_missionLandscapeMode = "precise"; // acceptable values are "none","random","precise"
_missionLandscape = [
		["Land_Cargo_Patrol_V1_F",[-29.41016,0.13477,-0.0224228],359.992,[true,true]], 
		["Land_Cargo_House_V1_F",[29.2988,-0.1,0.150505],54.9965,[true,true]], 
		["CamoNet_INDP_big_F",[-20.4346,15.43164,-0.00395203],54.9965,[false,true]], 
		["Land_BagBunker_Small_F",[-20.4346,15.43164,-0.0138168],119.996,[false,true]], 
		["Land_BagBunker_Small_F",[-20.3604,-15.6035,-0.0130463],44.9901,[false,true]], 
		["Land_BagBunker_Small_F",[18.4453,-15.791,0.00744629],305.003,[false,true]], 
		["Land_BagBunker_Small_F",[18.3711,15.5703,0.0101624],254.999,[false,true]],
		["CamoNet_INDP_big_F",[18.3711,15.5703,-0.00395203],54.9965,[false,true]]
		]; // list of objects to spawn as landscape
_missionLootBoxes = [];  //  Parameters are "Box Item Code", array defining the loot to be spawned, and position.
_missionLootVehicles = []; //  Parameters are "Box Item Code", array defining the loot to be spawned, and position.
_missionEmplacedWeapons = []; // can be used to define the precise placement of static weapons [[1,2,3] /*loc 1*/, [2,3,4] /*loc 2*/]; if blank random locations will be used
//  Change _useMines to true/false below to enable mission-specific settings.
_useMines = blck_useMines;
_minNoAI = blck_MinAI_Green;
_maxNoAI = blck_MaxAI_Green;
_noAIGroups = blck_AIGrps_Green;
_noVehiclePatrols = blck_SpawnVeh_Green;
_noEmplacedWeapons = blck_SpawnEmplaced_Green;
//_uniforms = blck_SkinList;
//_headgear = blck_headgear;
_chanceLoot = 0.6; 
private _lootIndex = selectRandom[1,2,3,4];
private _paralootChoices = [blck_contructionLoot,blck_contructionLoot,blck_highPoweredLoot,blck_supportLoot];
private _paralootCountsChoices = [[0,0,0,8,8,0],[0,0,0,8,8,0],[8,8,0,0,0,0],[0,0,0,0,12,0]];
_paraLoot = _paralootChoices select _lootIndex;
_paraLootCounts = _paralootCountsChoices select _lootIndex;  // Throw in something more exotic than found at a normal blue mission.
//_endCondition = "playerNear";  // Options are "allUnitsKilled", "playerNear", "allKilledOrPlayerNear"
//_timeOut = -1;
#include "\q\addons\custom_server\Compiles\Missions\GMS_fnc_missionSpawner.sqf"; 
