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
	
//diag_log "[blckeagls] Spawning Orange Mission with template = resupplyCamp";

_crateLoot = blck_BoxLoot_Orange;
_lootCounts = blck_lootCountsOrange;
_startMsg = "A Bandit resupply camp has been spotted. Check the Orange marker on your map for its location";
_endMsg = "The Bandit resupply camp at the Orange Marker is under player control";
_markerLabel = "";
_markerType = ["ellipse",[250,250],"GRID"];
_markerColor = "ColorOrange";
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
_minNoAI = blck_MinAI_Orange;
_maxNoAI = blck_MaxAI_Orange;
_noAIGroups = blck_AIGrps_Orange;
_noVehiclePatrols = blck_SpawnVeh_Orange;
_noEmplacedWeapons = blck_SpawnEmplaced_Orange;
//_uniforms = blck_SkinList;
//_headgear = blck_headgear;

_chancePara = 0.75; // Setting this in the mission file overrides the defaults 
_noPara = 5;  // Setting this in the mission file overrides the defaults 
_paraTriggerDistance = 400; // Distance from mission at which a player triggers these reinforcements and any supplemental loot. 						// To have paras spawn at the time the mission spawns with/without accompanying loot set this to 0.
_paraSkill = "orange";  // Choose any skill you like; bump up skill or add AI to justify more valuable loot.

_chanceLoot = 0.7; 
private _lootIndex = selectRandom[1,2,3,4];
private _paralootChoices = [blck_contructionLoot,blck_contructionLoot,blck_highPoweredLoot,blck_supportLoot];
private _paralootCountsChoices = [[0,0,0,10,10,0],[0,0,0,10,10,0],[10,10,0,0,0,0],[0,0,0,0,15,0]];
_paraLoot = _paralootChoices select _lootIndex;
_paraLootCounts = _paralootCountsChoices select _lootIndex;  // Throw in something more exotic than found at a normal blue mission.

//_endCondition = "playerNear";  // Options are "allUnitsKilled", "playerNear", "allKilledOrPlayerNear"
//_timeOut = -1;
#include "\q\addons\custom_server\Compiles\Missions\GMS_fnc_missionSpawner.sqf"; 
