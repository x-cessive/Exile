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
	
//diag_log "[blckeagls] Spawning Red Mission with template = medicalCamp";
_crateLoot = blck_BoxLoot_Red;
_lootCounts = blck_lootCountsRed;
_startMsg = "A Bandit Medical camp has been spotted. Check the Red marker on your map for its location";
_endMsg = "The Bandit Medical camp at the Red Marker is under survivor control!";
_markerLabel = "";
_markerType = ["ellipse",[200,200],"GRID"];
_markerColor = "ColorRed";
_markerMissionName = "Medical Camp";
_missionLandscapeMode = "precise"; // acceptable values are "none","random","precise"
_missionLandscape = [
		["Flag_AAF_F",[6,5,0],0,[false,true]], 
		["Land_dp_transformer_F",[1.698242,-10.4668,-0.00763702],271.32,[true,true]], 
		["Land_Wreck_BRDM2_F",[1.37012,13.498,0.00109863],184.487,[true,true]], 
		["Land_BagBunker_Small_F",[18.4512,-3.66406,0.00780487],305.003,[true,true]], 
		["Land_Cargo_HQ_V1_F",[-20.1367,11.7539,0],90.8565,[true,false]], 
		["Land_BagBunker_Small_F",[-22.707,-3.75586,-0.0130234],44.9901,[true,true]], 
		["Land_Cargo_House_V1_F",[24.3584,7.45313,0.00111389],91.6329,[true,true]],  
		["StorageBladder_01_fuel_forest_F",[1.29492,29.3184,0.000999451],179.65,[false,true]], 
		["Land_GarbageBags_F",[-9.45996,31.252,0.02005],184.595,[false,true]], 
		["Land_GarbageBags_F",[-13.0459,32.668,-0.0283051],184.595,[false,false,true]], 
		["Land_GarbageBags_F",[-11.5957,33.125,-0.598007],184.595,[false,false,true]], 
		["Land_GarbageBags_F",[-8.98145,34.5801,-0.00514221],184.592,[false,true]], 
		["Land_Addon_02_V1_ruins_F",[24.8369,24.6582,-0.00820923],90.9637,[false,true]], 
		["Land_GarbageBags_F",[-10.9443,35.0449,0.577057],184.592,[false,true]], 
		["Land_Cargo20_military_green_F",[14.6533,32.9004,0.000480652],90.0989,[false,true]], 
		["Land_BagBunker_Small_F",[-23.0186,28.6738,-0.0271301],120.012,[false,true]], 
		["Land_BagBunker_Small_F",[37.1504,34.5742,0.0146866],255,[false,true]]
		]; // list of objects to spawn as landscape
_missionLootBoxes = [];  //  Parameters are "Box Item Code", array defining the loot to be spawned, and position.
_missionLootVehicles = []; //  Parameters are "Box Item Code", array defining the loot to be spawned, and position.
_missionEmplacedWeapons = []; // can be used to define the precise placement of static weapons [[1,2,3] /*loc 1*/, [2,3,4] /*loc 2*/]; if blank random locations will be used
_minNoAI = blck_MinAI_Red;
_maxNoAI = blck_MaxAI_Red;
_noAIGroups = blck_AIGrps_Red;
_noVehiclePatrols = blck_SpawnVeh_Red;
_noEmplacedWeapons = blck_SpawnEmplaced_Red;
//  Change _useMines to true/false below to enable mission-specific settings.
//_useMines = blck_useMines;
//_uniforms = blck_SkinList;  // Setting this in the mission file overrides the defaults 
//_headgear = blck_headgear;  // Setting this in the mission file overrides the defaults 
//_vests = blck_vests;
//_backpacks = blck_backpacks;
//_weaponList = ["blue"] call blck_fnc_selectAILoadout;
//_sideArms = blck_Pistols;
//_chanceHeliPatrol = blck_chanceHeliPatrolRed;  // Setting this in the mission file overrides the defaults 
//_noChoppers = blck_noPatrolHelisRed;
//_missionHelis = blck_patrolHelisRed;

//_chancePara = 0.0; // Setting this in the mission file overrides the defaults 
//_noPara = 3;  // Setting this in the mission file overrides the defaults 
//_paraTriggerDistance = 400; // Distance from mission at which a player triggers these reinforcements and any supplemental loot. 						// To have paras spawn at the time the mission spawns with/without accompanying loot set this to 0.
//_paraSkill = "red";  // Choose any skill you like; bump up skill or add AI to justify more valuable loot.

//_chanceLoot = 0.999999990; 
//_paraLoot = blck_BoxLoot_Red;
//_paraLootCounts = blck_lootCountsRed;  // Throw in something more exotic than found at a normal blue mission.

//_spawnCratesTiming = blck_spawnCratesTiming; // Choices: "atMissionSpawnGround","atMissionEndGround","atMissionEndAir". 
						 // Crates spawned in the air will be spawned at mission center or the position(s) defined in the mission file and dropped under a parachute.
						 //  This sets the default value but can be overridden by defining  _spawnCrateTiming in the file defining a particular mission.
//_loadCratesTiming = blck_loadCratesTiming; // valid choices are "atMissionCompletion" and "atMissionSpawn"; 
						// Pertains only to crates spawned at mission spawn.
						// This sets the default but can be overridden for specific missions by defining _loadCratesTiming
						
						// Examples:
						// To spawn crates at mission start loaded with gear set blck_spawnCratesTiming = "atMissionSpawnGround" && blck_loadCratesTiming = "atMissionSpawn"
						// To spawn crates at mission start but load gear only after the mission is completed set blck_spawnCratesTiming = "atMissionSpawnGround" && blck_loadCratesTiming = "atMissionCompletion"
						// To spawn crates on the ground at mission completion set blck_spawnCratesTiming = "atMissionEndGround" // Note that a loaded crate will be spawned.
						// To spawn crates in the air and drop them by chutes set blck_spawnCratesTiming = "atMissionEndAir" // Note that a loaded crate will be spawned.
//_endCondition = blck_missionEndCondition;  // Options are "allUnitsKilled", "playerNear", "allKilledOrPlayerNear"
									// Setting this in the mission file overrides the defaults 

//_endCondition = "playerNear";  // Options are "allUnitsKilled", "playerNear", "allKilledOrPlayerNear"
//_timeOut = -1;
#include "\q\addons\custom_server\Compiles\Missions\GMS_fnc_missionSpawner.sqf"; 

