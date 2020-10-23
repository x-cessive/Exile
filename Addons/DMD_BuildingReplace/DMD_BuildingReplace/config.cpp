/* 
	Author: JakeHekesFists[DMD]
	Date:	11/12/2017
	Public Release version 1.0
	
	feel free to edit this however you see fit. 
	i wont be offering support
	have fun :)
*/

#include "defines.h"

class CfgPatches
{
	class DMD_BuildingReplace
	{
		units[] = {};
		weapons[] = {};
		magazines[] = {};
		ammo[] = {};
		requiredVersion = 0.1;
		requiredAddons[] = {"exile_server"};
		author[] = {"JakeHekesFists [DMD]"};
		website[] = {"http://www.dmdgaming.net"};
		contact[] = {"dmdgaming@tuta.io"};
		version = '1.00';
	};
};

class CfgFunctions {
	class DMD_BR {
		tag = "DMD_BR";
		
		class mainBR {
			class postInit {
				postInit = 1;
				file = "\DMD_BuildingReplace\fn\fn_Launch.sqf";
			};
		};
		
		class serverFunctionsBR {
			file = "DMD_BuildingReplace\fn";
			class simulationManager {};
			class buildingReplace {};

		};
	};
};

class DMD_BuildingReplace {
	
	class replacement {
		class chernarus {
			enabled = 1;	// 1 for on, 0 for off. 
			
			// this is an array of classnames that will be deleted or replaced. 
			closeHouse[] = {
				// DELETE ONLY 
				"CUP_A2_boots_ep1","CUP_A2_drevo_hromada","CUP_A2_haystack","CUP_A2_metalcase_01","CUP_A2_metalcase_02","CUP_A2_woodpile","Land_fuel_tank_small","Land_Hut06","Land_Ind_BoardsPack1","Land_Ind_BoardsPack2","Land_Ind_Timbers","Land_Kontejner","Land_loco_742_blue","Land_Misc_GContainer_Big","Land_Nasypka","Land_seno_balik","Land_Shed_M01","Land_Shed_M02","Land_Shed_M03","Land_Shed_W03","Land_SignB_Hotel_CZ2","Land_SignB_PostOffice","Land_SignB_Pub_CZ2","Land_SignB_Pub_CZ3","Land_SignB_Pub_RU3","Land_Sign_Bar_RU","Land_Tec","Land_wagon_box",
				// REPLACE
				"Land_A_Office02","Land_Church_01","Land_Ind_SawMill","Land_Church_02","Land_Church_02a","Land_HouseV2_01A","Land_HouseV2_01B","Land_HouseV2_02_Interier","Land_HouseV2_03","Land_HouseV2_03B","Land_HouseV2_04_interier","Land_HouseV2_05","Land_HouseV_1I1","Land_HouseV_1I2","Land_HouseV_1I3","Land_HouseV_1L2","Land_HouseV_1L1","Land_HouseV_1T","Land_HouseV_2I","Land_houseV_2T1","Land_houseV_2T2","Land_HouseV_3I1","Land_HouseV_3I2","Land_HouseV_3I3","Land_HouseV_3I4","Land_Ind_Workshop01_03","Land_Mil_Barracks","Land_Mil_Barracks_L","Land_Mil_Guardhouse","Land_Misc_WaterStation","Land_Shed_W4","Land_Shed_W02", "Land_Stodola_old", "Land_Stodola_open", "Land_Repair_center"
			};	

			/*
				the deleteObjs array below will remove some benches and junk around the map. 
				
				to display object IDs in 3Den editor, execute the code below and exit back into the editor.
				do3DENAction "ToggleMapIDs";
								
				{{_position}, objID} <-- format like this
				ensure you select a position very close to the object, or it will degrade performance. 
			
			*/
			
			deleteObjs[] = {
				{{8672,2467,0},357998},
				{{8672,2467,0},357948},
				{{8672,2467,0},358030},
				{{8672,2425,0},358098},
				{{8672,2425,0},358099},
				{{8672,2425,0},358074},
				{{9423,8929,0},244751},
				{{9423,8929,0},244752},
				{{9423,8929,0},244744},
				{{9423,8929,0},244746},
				{{9423,8929,0},244747},
				{{9423,8929,0},244749},
				{{9423,8929,0},244750},
				{{9423,8929,0},244753},
				{{9423,8929,0},244754},
				{{9423,8929,0},244755},
				{{9423,8929,0},244756},
				{{9423,8929,0},244757},
				{{9423,8929,0},244758},
				{{9423,8929,0},244759},
				{{9423,8929,0},244745},
				{{9423,8929,0},244743},
				{{9423,8929,0},244742},
				{{12016,9078,0},262014},
				{{12016,9078,0},262127},
				{{12016,9078,0},262126},
				{{12016,9078,0},262522},
				{{12016,9078,0},262196},
				{{12016,9078,0},261912},
				{{12016,9078,0},262527},
				{{12016,9078,0},262159},
				{{12016,9078,0},262160},
				{{12016,9078,0},262161},
				{{12016,9078,0},262162},
				{{12016,9078,0},262163},
				{{12016,9078,0},262164},
				{{12016,9078,0},262165},
				{{12016,9078,0},262166},
				{{12016,9078,0},262158},
				{{12016,9078,0},262167},
				{{12016,9078,0},262168},
				{{12016,9078,0},963460},
				{{6203,10405,0},993525},
				{{6203,10405,0},993526},
				{{10371,7427,0},275286},
				{{10371,7427,0},275287},
				{{10371,7427,0},275293},
				{{10453,8894,0},249766},
				{{6820,2777,0},966603},
				{{6820,2777,0},966594},
				{{6820,2777,0},966502},
				{{6820,2777,0},966631},
				{{6820,2777,0},966554},
				{{6820,2777,0},966513},
				{{6820,2777,0},966504},
				{{6820,2777,0},966555},
				{{6820,2777,0},966605},
				{{6820,2777,0},966604},
				{{6820,2777,0},966514},
				{{6820,2777,0},966606},
				{{6820,2777,0},966556},
				{{4564,9595,0},145259},
				{{4564,9595,0},145260}
			};
			
			/*
				replacementList is an array of buildings to replace
				ensure the class name is also included in closeHouse array above.
				
				format: 
				{{ building type to replace}, {building it will be replaced with}}, 
			*/
			
			replacementList[] = {
				{{"Land_Repair_center"},{"Land_Bunker_01_HQ_F"}},
				{{"Land_Stodola_open"},{"Land_Barn_01_brown_F"}},
				{{"Land_Stodola_old"},{"Land_Stodola_old_open"}},
				{{"Land_HouseV_1I2"},{"Land_i_Stone_Shed_V3_F"}},
				{{"Land_Ind_SawMill"},{"Land_dp_mainFactory_F"}},
				{{"Land_HouseV_1I1"},{"Land_i_House_Small_02_V1_F"}},
				{{"Land_Shed_W4"},{"Land_Slum_House03_F"}},
				{{"Land_HouseV_1I3"},{"Land_i_House_Small_03_V1_F"}},
				{{"Land_HouseV_1L2"},{"Land_i_House_Big_02_V1_F"}},
				{{"Land_Misc_WaterStation"},{"Land_ReservoirTank_V1_F"}},
				{{"Land_HouseV_2I"},{"Land_i_House_Big_01_V3_F"}},
				{{"Land_Mil_Barracks_L"},{"Land_Cargo_HQ_V1_F"}},
				{{"Land_Mil_Barracks"},{"Land_Unfinished_building_01_F"}},
				{{"Land_A_Office02"},{"Land_Offices_01_V1_F"}},
				{{"Land_Ind_Workshop01_03"},{"Land_Ind_Workshop01_04"}},
				{{"Land_Shed_W02"},{"Land_Slum_House01_F"}},
				{{"Land_HouseV_3I3"},{"Land_i_Shop_01_V1_F"}},
				{{"Land_HouseV_3I1"},{"Land_i_Shop_01_V2_F"}},
				{{"Land_HouseV_3I4"},{"Land_i_Shop_02_V1_F"}},
				{{"Land_HouseV_3I2"},{"Land_i_Shop_02_V3_F"}},
				{{"Land_HouseV_1L1"},{"Land_i_Stone_HouseBig_V2_F"}},
				{{"Land_houseV_2T1"},{"Land_i_Stone_HouseBig_V3_F"}},
				{{"Land_houseV_2T2"},{"Land_i_Stone_HouseSmall_V1_F"}},
				{{"Land_HouseV_1T"},{"Land_i_Stone_HouseSmall_V1_F"}},
				{{"Land_HouseV2_03B"},{"Land_i_Stone_HouseSmall_V3_F"}},
				{{"Land_HouseV2_01A"},{"CUP_A1_Cihlovej_dum_in"}},
				{{"Land_HouseV2_01B"},{"Land_i_House_Small_01_V3_F"}},
				{{"Land_HouseV2_03"},{"Land_i_House_Big_01_V3_F"}},
				{{"Land_HouseV2_02_Interier"},{"Land_i_House_Big_02_V2_dam_F"}},
				{{"Land_HouseV2_04_interier"},{"Land_i_Shop_01_V3_dam_F"}},
				{{"Land_HouseV2_05"},{"Land_CarService_F"}},
				{{"Land_Church_01"},{"Land_Chapel_V1_F"}},
				{{"Land_Church_02"},{"Land_Chapel_V1_F"}},
				{{"Land_Church_02a"},{"Land_Chapel_V1_F"}},
				{{"Land_Mil_Guardhouse"},{"Land_Cargo_Tower_V1_No5_F"}}
			};
		};
		// IF YOU WISH TO USE OTHER MAPS. FOLLOW THE FORMAT ABOVE 
		class xcam_taunus {
			enabled = 0;
			closeHouse[] = {};
			deleteObjs[] = {};
			replacementList[] = {};
		};
		
		class napf {
			enabled = 0;
			closeHouse[] = {};
			deleteObjs[] = {};
			replacementList[] = {};
		};
	};
};