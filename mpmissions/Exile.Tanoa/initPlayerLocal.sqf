/**
 * Created with Exile Mod 3DEN Plugin
 * www.exilemod.com
 */

// Georgetown Trader City, add to the top or bottom of this file. -Untriel
#include "custom\untTraderCityGeorgetown_player.sqf";

if (!hasInterface || isServer) exitWith {};

// 34 NPCs
private _npcs = [
["Exile_Guard_01", ["c4coming2cDf_genericstani1","c4coming2cDf_genericstani2","c4coming2cDf_genericstani3"], "", "WhiteHead_08", [["arifle_SPAR_02_blk_F","","acc_flashlight","optic_Nightstalker",["150Rnd_556x45_Drum_Mag_F",150],[],""],[],[],["U_B_GEN_Commander_F",[]],["V_TacVest_blk_POLICE",[]],[],"H_Cap_police","G_Aviator",[],["","","","","",""]], [6897.85, 7490.53, 6.81444], [-0.0312538, -0.999511, 0], [0, 0, 1]],
["Exile_Guard_01", ["c4coming2cDf_genericstani1","c4coming2cDf_genericstani2","c4coming2cDf_genericstani3"], "", "WhiteHead_19", [["arifle_SPAR_02_blk_F","","acc_flashlight","optic_Nightstalker",["150Rnd_556x45_Drum_Mag_F",150],[],""],[],[],["U_B_GEN_Commander_F",[]],["V_TacVest_blk_POLICE",[]],[],"H_Cap_police","G_Aviator",[],["","","","","",""]], [6905.29, 7424.46, 6.81292], [0.992106, 0.125403, 0], [0, 0, 1]],
["Exile_Guard_01", ["c4coming2cDf_genericstani1","c4coming2cDf_genericstani2","c4coming2cDf_genericstani3"], "", "WhiteHead_02", [["arifle_SPAR_02_blk_F","","acc_flashlight","optic_Nightstalker",["150Rnd_556x45_Drum_Mag_F",150],[],""],[],[],["U_B_GEN_Commander_F",[]],["V_TacVest_blk_POLICE",[]],[],"H_Cap_police","G_Aviator",[],["","","","","",""]], [6771.16, 7532, 10.5572], [-0.275252, 0.961372, 0], [0, 0, 1]],
["Exile_Trader_Vehicle", ["InBaseMoves_repairVehicleKnl","InBaseMoves_repairVehiclePne"], "Exile_Trader_Vehicle", "WhiteHead_14", [[],[],[],["U_C_Driver_4",[]],[],[],"H_Bandanna_gry","",[],["","","","","",""]], [6910.11, 7441.79, 2.66157], [0.177225, -0.98417, 0], [0, 0, 1]],
["Exile_Trader_Vehicle", ["Acts_carFixingWheel"], "Exile_Trader_Vehicle", "GreekHead_A3_07", [[],[],[],["U_C_Driver_3",[]],[],[],"","",[],["","","","","",""]], [6911.07, 7446.4, 2.66144], [-0.446161, 0.894953, 0], [0, 0, 1]],
["Exile_Trader_VehicleCustoms", ["HubBriefing_loop","HubBriefing_scratch","HubBriefing_stretch","HubBriefing_think"], "Exile_Trader_VehicleCustoms", "WhiteHead_05", [[],[],[],["U_I_G_Story_Protagonist_F",[]],[],[],"","G_Spectacles_Tinted",[],["","","","","",""]], [6899.87, 7448.62, 2.77756], [-0.163197, -0.986593, 0], [0, 0, 1]],
["Exile_Trader_Aircraft", ["Acts_carFixingWheel"], "Exile_Trader_Aircraft", "GreekHead_A3_08", [[],[],[],["U_I_pilotCoveralls",[]],[],[],"H_PilotHelmetHeli_O","G_Combat",[],["","","","","",""]], [6912.59, 7463.94, 2.66141], [-0.232707, 0.972547, 0], [0, 0, 1]],
["Exile_Trader_AircraftCustoms", ["HubBriefing_loop","HubBriefing_scratch","HubBriefing_stretch","HubBriefing_think"], "Exile_Trader_AircraftCustoms", "GreekHead_A3_05", [[],[],[],["Exile_Uniform_ExileCustoms",[]],["V_RebreatherB",[]],[],"H_PilotHelmetFighter_B","G_Tactical_Black",[],["","","","","",""]], [6904.49, 7462.62, 2.66144], [0.764145, -0.645044, 0], [0, 0, 1]],
["Exile_Trader_Office", ["HubBriefing_loop","HubBriefing_scratch","HubBriefing_stretch","HubBriefing_think"], "Exile_Trader_Office", "WhiteHead_21", [[],[],["hgun_P07_F","","","",["16Rnd_9x21_Mag",16],[],""],["U_B_GEN_Soldier_F",[["16Rnd_9x21_Mag",16,3]]],["V_Rangemaster_belt",[]],[],"H_MilCap_gen_F","G_Spectacles_Tinted",[],["","","","","",""]], [6900.47, 7424.1, 15.7314], [-0.971949, -0.235193, 0], [0, 0, 1]],
["Exile_Trader_Equipment", ["HubSittingChairUA_idle1","HubSittingChairUA_idle2","HubSittingChairUA_idle3","HubSittingChairUA_move1"], "Exile_Trader_Equipment", "WhiteHead_11", [["arifle_MX_GL_Black_F","","","",[],[],""],[],[],["U_BG_Guerrilla_6_1",[]],["V_I_G_resistanceLeader_F",[]],[],"H_Watchcap_khk","G_Tactical_Clear",[],["","","","","",""]], [6913.63, 7488.39, 3.22744], [0.611637, -0.791138, 0], [0, 0, 1]],
["Exile_Trader_Armory", ["HubStanding_idle1","HubStanding_idle2","HubStanding_idle3"], "Exile_Trader_Armory", "GreekHead_A3_08", [["arifle_SPAR_02_blk_F","","acc_flashlight","optic_Aco_smg",["150Rnd_556x45_Drum_Mag_F",150],[],""],[],["hgun_P07_khk_F","","","",["16Rnd_9x21_Mag",16],[],""],["U_I_G_Story_Protagonist_F",[["16Rnd_9x21_Mag",16,2]]],["V_Rangemaster_belt",[["16Rnd_9x21_Mag",16,1]]],[],"H_MilCap_dgtl","G_Shades_Black",[],["","","","","",""]], [6928.89, 7486.87, 3.22076], [-0.975424, 0.220335, 0], [0, 0, 1]],
["Exile_Trader_WasteDump", ["HubBriefing_loop","HubBriefing_scratch","HubBriefing_stretch","HubBriefing_think"], "Exile_Trader_WasteDump", "WhiteHead_06", [[],[],["hgun_P07_khk_F","","","",["16Rnd_9x21_Mag",16],[],""],["U_B_CTRG_Soldier_urb_3_F",[["16Rnd_9x21_Mag",16,3]]],["V_Rangemaster_belt",[]],[],"H_ShemagOpen_khk","",[],["","","","","",""]], [6933.71, 7490.82, 2.66144], [-0.210966, -0.977493, 0], [0, 0, 1]],
["Exile_Trader_Food", ["InBaseMoves_table1"], "Exile_Trader_Food", "WhiteHead_06", [[],[],[],["U_I_G_Story_Protagonist_F",[]],[],[],"H_Bandanna_blu","",[],["","","","","",""]], [6867.81, 7488.86, 2.85409], [0.581406, 0.813614, 0], [0, 0, 1]],
["Exile_Trader_Hardware", ["HubSittingAtTableU_idle1","HubSittingAtTableU_idle2","HubSittingAtTableU_idle3"], "Exile_Trader_Hardware", "WhiteHead_07", [[],[],[],["U_I_G_Story_Protagonist_F",[]],["V_HarnessOGL_brn",[]],[],"H_Cap_grn","",[],["","","","","",""]], [6940.66, 7501.85, 2.97077], [0.1063, -0.994334, 0], [0, 0, 1]],
["Exile_Trader_SpecialOperations", ["c4coming2cDf_genericstani1","c4coming2cDf_genericstani2","c4coming2cDf_genericstani3"], "Exile_Trader_SpecialOperations", "WhiteHead_19", [["arifle_MX_Black_F","","","",[],[],""],[],[],["U_B_CTRG_1",[]],["V_PlateCarrierGL_blk",[]],["B_Parachute",[]],"H_HelmetB_light_black","G_Balaclava_lowprofile",[],["","","","","","NVGoggles_OPFOR"]], [12167, 9399.15, 140.55], [-0.999961, 0.00877609, 0], [0, 0, 1]],
["Exile_Trader_SpecialOperations", ["c4coming2cDf_genericstani1","c4coming2cDf_genericstani2","c4coming2cDf_genericstani3"], "Exile_Trader_SpecialOperations", "WhiteHead_06", [["arifle_MX_Black_F","","","",[],[],""],[],[],["U_B_CTRG_1",[]],["V_PlateCarrierGL_blk",[]],["B_Parachute",[]],"H_HelmetB_light_black","G_Balaclava_lowprofile",[],["","","","","","NVGoggles_OPFOR"]], [4692.01, 3159.51, 88.573], [-0.655413, 0.75527, 0], [0, 0, 1]],
["Exile_Trader_Aircraft", ["Acts_carFixingWheel"], "Exile_Trader_Aircraft", "GreekHead_A3_05", [[],[],[],["U_I_pilotCoveralls",[]],[],[],"H_PilotHelmetHeli_O","G_Combat",[],["","","","","",""]], [11707.2, 13087.6, 6.95144], [0.984332, -0.176327, 0], [0, 0, 1]],
["Exile_Trader_VehicleCustoms", ["HubBriefing_loop","HubBriefing_scratch","HubBriefing_stretch","HubBriefing_think"], "Exile_Trader_VehicleCustoms", "WhiteHead_17", [[],[],[],["U_B_PilotCoveralls",[]],[],[],"","G_Spectacles_Tinted",[],["","","","","",""]], [11713.5, 13087.9, 6.95144], [-0.417277, 0.908779, 0], [0, 0, 1]],
["Exile_Trader_Aircraft", ["Acts_carFixingWheel"], "Exile_Trader_Aircraft", "WhiteHead_06", [[],[],[],["U_I_pilotCoveralls",[]],[],[],"H_PilotHelmetHeli_O","G_Combat",[],["","","","","",""]], [2248.97, 13409.8, 13.4514], [0.660882, 0.75049, 0], [0, 0, 1]],
["Exile_Trader_VehicleCustoms", ["HubBriefing_loop","HubBriefing_scratch","HubBriefing_stretch","HubBriefing_think"], "Exile_Trader_VehicleCustoms", "AfricanHead_01", [[],[],[],["U_B_PilotCoveralls",[]],[],[],"","G_Spectacles_Tinted",[],["","","","","",""]], [2251.93, 13415.3, 13.4514], [-0.993474, 0.114058, 0], [0, 0, 1]],
["Exile_Trader_Aircraft", ["Acts_carFixingWheel"], "Exile_Trader_Aircraft", "WhiteHead_20", [[],[],[],["U_I_pilotCoveralls",[]],[],[],"H_PilotHelmetHeli_O","G_Combat",[],["","","","","",""]], [2115.99, 3452.42, 12.9514], [0.384966, -0.922931, 0], [0, 0, 1]],
["Exile_Trader_VehicleCustoms", ["HubBriefing_loop","HubBriefing_scratch","HubBriefing_stretch","HubBriefing_think"], "Exile_Trader_VehicleCustoms", "WhiteHead_10", [[],[],[],["U_B_PilotCoveralls",[]],[],[],"","G_Spectacles_Tinted",[],["","","","","",""]], [2128.16, 3448.51, 12.9514], [-0.829588, 0.558376, 0], [0, 0, 1]],
["Exile_Trader_Aircraft", ["Acts_carFixingWheel"], "Exile_Trader_Aircraft", "WhiteHead_10", [[],[],[],["U_I_pilotCoveralls",[]],[],[],"H_PilotHelmetHeli_O","G_Combat",[],["","","","","",""]], [11744.3, 3005.71, 4.69145], [-0.789773, -0.613399, 0], [0, 0, 1]],
["Exile_Trader_VehicleCustoms", ["HubBriefing_loop","HubBriefing_scratch","HubBriefing_stretch","HubBriefing_think"], "Exile_Trader_VehicleCustoms", "WhiteHead_05", [[],[],[],["U_B_PilotCoveralls",[]],[],[],"","G_Spectacles_Tinted",[],["","","","","",""]], [11744.2, 2997.52, 4.6912], [-0.0715767, 0.997435, 0], [0, 0, 1]],
["Exile_Trader_WasteDump", ["c4coming2cDf_genericstani1","c4coming2cDf_genericstani2","c4coming2cDf_genericstani3"], "Exile_Trader_WasteDump", "WhiteHead_07", [["arifle_AK12_F","","","",["30Rnd_762x39_Mag_F",30],[],""],[],[],["U_I_G_Story_Protagonist_F",[["30Rnd_762x39_Mag_F",30,3]]],["V_Rangemaster_belt",[]],[],"H_Cap_red","G_Spectacles",[],["","","","","",""]], [2676.01, 12307.9, 171.334], [0.283551, 0.958957, 0], [0, 0, 1]],
["Exile_Trader_WasteDump", ["c4coming2cDf_genericstani1","c4coming2cDf_genericstani2","c4coming2cDf_genericstani3"], "Exile_Trader_WasteDump", "WhiteHead_01", [["arifle_ARX_hex_F","","","",["30Rnd_65x39_caseless_green",30],[],""],[],[],["U_I_G_Story_Protagonist_F",[["30Rnd_65x39_caseless_green",30,3]]],["V_Rangemaster_belt",[]],[],"H_Bandanna_blu","G_Squares_Tinted",[],["","","","","",""]], [13988.1, 9997.83, 116.426], [-0.949792, -0.312881, 0], [0, 0, 1]],
["Exile_Trader_WasteDump", ["c4coming2cDf_genericstani1","c4coming2cDf_genericstani2","c4coming2cDf_genericstani3"], "Exile_Trader_WasteDump", "WhiteHead_08", [["arifle_CTAR_ghex_F","","","",["30Rnd_580x42_Mag_F",30],[],""],[],[],["U_BG_Guerilla1_1",[["30Rnd_580x42_Mag_F",30,2]]],["V_Chestrig_khk",[["30Rnd_580x42_Mag_F",30,1]]],[],"H_MilCap_ocamo","",[],["","","","","",""]], [4703.47, 3154.32, 87.5264], [0.23755, -0.971375, 0], [0, 0, 1]],
["Exile_Trader_WasteDump", ["c4coming2cDf_genericstani1","c4coming2cDf_genericstani2","c4coming2cDf_genericstani3"], "Exile_Trader_WasteDump", "WhiteHead_16", [["LMG_Mk200_F","","","",[],[],""],[],[],["U_B_CTRG_2",[]],["V_Rangemaster_belt",[]],[],"H_Bandanna_camo","G_Spectacles_Tinted",[],["","","","","",""]], [11644.9, 4092.84, 166.207], [0.152209, 0.988348, 0], [0, 0, 1]],
["Exile_Guard_01", ["LHD_krajPaluby"], "", "WhiteHead_20", [[],[],[],["U_B_GEN_Soldier_F",[]],[],[],"H_Cap_police","",[],["","","","","",""]], [4792.87, 5130.27, 15.5068], [-0.624159, -0.781297, 0], [0, 0, 1]],
["Exile_Trader_Boat", ["HubSittingChairUC_idle1","HubSittingChairUC_idle2","HubSittingChairUC_idle3","HubSittingChairUC_move1"], "Exile_Trader_Boat", "WhiteHead_02", [[],[],[],["U_C_man_sport_3_F",[]],[],[],"H_Cap_blu","",[],["","","","","",""]], [3106.88, 10939.6, 1.24986], [-0.538532, 0.842605, 0], [0, 0, 1]],
["Exile_Trader_Boat", ["HubSittingChairUC_idle1","HubSittingChairUC_idle2","HubSittingChairUC_idle3","HubSittingChairUC_move1"], "Exile_Trader_Boat", "WhiteHead_03", [[],[],[],["U_C_man_sport_3_F",[]],[],[],"H_Cap_blu","",[],["","","","","",""]], [4525.07, 5229.36, 1.57091], [0.755488, -0.655163, 0], [0, 0, 1]],
["Exile_Trader_Boat", ["HubSittingChairUC_idle1","HubSittingChairUC_idle2","HubSittingChairUC_idle3","HubSittingChairUC_move1"], "Exile_Trader_Boat", "WhiteHead_10", [[],[],[],["U_C_man_sport_3_F",[]],[],[],"H_Cap_blu","",[],["","","","","",""]], [12973.6, 7267.67, 2.05452], [-0.174987, 0.984571, 0], [0, 0, 1]],
["Exile_Trader_Diving", ["HubSittingChairUB_idle1","HubSittingChairUB_idle2","HubSittingChairUB_idle3","HubSittingChairUB_move1"], "Exile_Trader_Diving", "WhiteHead_08", [[],[],[],["U_I_Wetsuit",[]],["V_RebreatherIA",[]],[],"","G_I_Diving",[],["","","","","",""]], [8676.44, 4349.81, 0.324647], [-0.924771, -0.380523, 0], [0, 0, 1]],
["Exile_Trader_RussianRoulette", ["HubBriefing_loop","HubBriefing_scratch","HubBriefing_stretch","HubBriefing_think"], "Exile_Trader_RussianRoulette", "GreekHead_A3_08", [[],[],[],["U_B_GEN_Commander_F",[]],["V_Rangemaster_belt",[]],["B_ViperLightHarness_blk_F",[]],"","G_Balaclava_blk",[],["","","","","",""]], [6846.7, 7484.18, 2.66144], [0.687164, -0.726503, 0], [0, 0, 1]]
];
 
{
    private _logic = "Logic" createVehicleLocal [0, 0, 0];
    private _trader = (_x select 0) createVehicleLocal [0, 0, 0];
    private _animations = _x select 1;
   
    _logic setPosWorld (_x select 5);
    _logic setVectorDirAndUp [_x select 6, _x select 7];
   
    _trader setVariable ["BIS_enableRandomization", false];
    _trader setVariable ["BIS_fnc_animalBehaviour_disable", true];
    _trader setVariable ["ExileAnimations", _animations];
    _trader setVariable ["ExileTraderType", _x select 2];
    _trader disableAI "ANIM";
    _trader disableAI "MOVE";
    _trader disableAI "FSM";
    _trader disableAI "AUTOTARGET";
    _trader disableAI "TARGET";
    _trader disableAI "CHECKVISIBLE";
    _trader allowDamage false;
    _trader setFace (_x select 3);
    _trader setUnitLoadOut (_x select 4);
    _trader setPosWorld (_x select 5);
    _trader setVectorDirAndUp [_x select 6, _x select 7];
    _trader reveal _logic;
    _trader attachTo [_logic, [0, 0, 0]];
    _trader switchMove (_animations select 0);
    _trader addEventHandler ["AnimDone", {_this call ExileClient_object_trader_event_onAnimationDone}];
}
forEach _npcs;