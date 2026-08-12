// FuMS HC bootstrap: must run before the hasInterface guard below.
[] execVM "HC\init.sqf";

/**
 * Created with Exile Mod 3DEN Plugin
 * www.exilemod.com
 */

if (!hasInterface || isServer) exitWith {};

// 76 NPCs
private _npcs = [
["Exile_Trader_WasteDump", ["Acts_CivilListening_2"], "Exile_Trader_WasteDump", "Default", [[],[],[],["U_I_C_Soldier_Bandit_4_F",[]],[],[],"H_Hat_grey","",[],["","","","","",""]], [2253.92, 8581.53, 1.44809], [-0.031831, 0.999493, 0], [0, 0, 1]],
["Exile_Trader_Aircraft", ["LHD_krajPaluby"], "Exile_Trader_Aircraft", "AfricanHead_03", [[],[],[],["U_I_pilotCoveralls",[]],[],[],"H_PilotHelmetHeli_O","",[],["","","","","",""]], [2104.65, 3447.84, 12.9514], [-0.480545, 0.87697, 0], [0, 0, 1]],
["Exile_Trader_AircraftCustoms", ["HubStandingUA_idle1","HubStandingUA_idle2","HubStandingUA_idle3","HubStandingUA_move1","HubStandingUA_move2"], "Exile_Trader_AircraftCustoms", "WhiteHead_01", [[],[],[],["Exile_Uniform_ExileCustoms",[]],["V_RebreatherB",[]],[],"H_PilotHelmetFighter_B","G_Tactical_Clear",[],["","","","","",""]], [2096.73, 3442.05, 12.9514], [0.884801, 0.46597, 0], [0, 0, 1]],
["Exile_Trader_RussianRoulette", ["HubStandingUB_idle1","HubStandingUB_idle2","HubStandingUB_idle3","HubStandingUB_move1"], "Exile_Trader_RussianRoulette", "WhiteHead_04", [[],[],["hgun_Pistol_Signal_F","","","",[],[],""],["U_Marshal",[]],["V_Rangemaster_belt",[]],[],"H_Cap_marshal","G_Sport_Blackyellow",[],["","","","","",""]], [9385.44, 6210.36, 1.63078], [0.606488, 0.795093, 0], [0, 0, 1]],
["Exile_Trader_Armory", ["InBaseMoves_SittingRifle1","InBaseMoves_SittingRifle2"], "Exile_Trader_Armory", "WhiteHead_10", [["arifle_SPAR_03_khk_F","","","",["20Rnd_762x51_Mag",20],[],""],[],[],["U_I_C_Soldier_Para_1_F",[["20Rnd_762x51_Mag",20,2]]],["V_Rangemaster_belt",[["20Rnd_762x51_Mag",20,1]]],[],"","",[],["","","","","",""]], [2295.35, 8589.59, 1.50615], [-0.666272, 0.745709, 0], [0, 0, 1]],
["Exile_Trader_Equipment", ["HubStanding_idle1","HubStanding_idle2","HubStanding_idle3"], "Exile_Trader_Equipment", "WhiteHead_20", [["arifle_CTAR_blk_F","","","",["30Rnd_580x42_Mag_F",30],[],""],[],[],["U_I_C_Soldier_Para_4_F",[["30Rnd_580x42_Mag_F",30,3]]],["V_I_G_resistanceLeader_F",[]],[],"H_Bandanna_camo","G_Bandanna_tan",[],["","","","","",""]], [2287.87, 8588.71, 1.47454], [0, 1, 0], [0, 0, 1]],
["Exile_Trader_Hardware", ["HubSittingHighB_idle1","HubSittingHighB_idle2","HubSittingHighB_idle3"], "Exile_Trader_Hardware", "WhiteHead_14", [["arifle_SPAR_01_blk_F","","","",["30Rnd_556x45_Stanag",30],[],""],[],["hgun_Pistol_01_F","","","",[],[],""],["U_I_C_Soldier_Camo_F",[["16Rnd_9x21_Mag",16,4],["30Rnd_556x45_Stanag",30,1]]],["V_TacChestrig_oli_F",[["30Rnd_556x45_Stanag",30,2]]],[],"H_Booniehat_khk_hs","",[],["","","","","",""]], [2284.32, 8597.58, 1.52897], [0.765317, -0.643654, 0], [0, 0, 1]],
["Exile_Trader_Office", ["HubSittingChairUB_idle1","HubSittingChairUB_idle2","HubSittingChairUB_idle3","HubSittingChairUB_move1"], "Exile_Trader_Office", "WhiteHead_16", [[],[],[],["U_I_C_Soldier_Camo_F",[]],[],[],"H_Booniehat_khk","",[],["","","","","",""]], [2279.14, 8589.32, 4.06135], [0.675045, 0.737777, 0], [0, 0, 1]],
["Exile_Trader_Food", ["HubSittingChairB_idle1","HubSittingChairB_idle2","HubSittingChairB_idle3","HubSittingChairB_move1"], "Exile_Trader_Food", "AfricanHead_02", [[],[],[],["U_I_C_Soldier_Bandit_2_F",[]],[],[],"H_Bandanna_sand","",[],["","","","","",""]], [2251.37, 8602.04, 1.29314], [-0.604542, -0.796573, 0], [0, 0, 1]],
["Exile_Trader_Boat", ["HubSittingChairUB_idle1","HubSittingChairUB_idle2","HubSittingChairUB_idle3","HubSittingChairUB_move1"], "Exile_Trader_Boat", "WhiteHead_21", [[],[],[],["U_C_man_sport_1_F",[]],[],[],"H_Bandanna_surfer","G_Shades_Blue",[],["","","","","",""]], [2224.45, 8652.17, 1.29101], [-0.0264541, -0.99965, 0], [0, 0, 1]],
["Exile_Trader_BoatCustoms", ["Acts_passenger_flatground_leanright"], "Exile_Trader_BoatCustoms", "WhiteHead_04", [[],[],[],["U_C_man_sport_3_F",[]],[],[],"H_Bandanna_surfer_blk","",[],["","","","","",""]], [2222.15, 8651.68, 1.28518], [0.449575, -0.893243, 0], [0, 0, 1]],
["Exile_Trader_Vehicle", ["Kart_driver"], "Exile_Trader_Vehicle", "WhiteHead_01", [[],[],[],["Exile_Uniform_ExileCustoms",[]],[],[],"H_RacingHelmet_4_F","G_Combat",[],["","","","","",""]], [2217.15, 8605.66, 1.27332], [0.674077, 0.716846, -0.178193], [0.120389, 0.131394, 0.983993]],
["Exile_Trader_VehicleCustoms", ["InBaseMoves_table1"], "Exile_Trader_VehicleCustoms", "AfricanHead_02", [[],[],[],["Exile_Uniform_ExileCustoms",[]],[],[],"","G_Squares_Tinted",[],["","","","","",""]], [2212.38, 8596.92, 1.38616], [0, 1, 0], [0, 0, 1]],
["Exile_Trader_SpecialOperations", ["Acts_passenger_flatground_leanright"], "Exile_Trader_SpecialOperations", "AfricanHead_03", [[],[],[],["U_B_CTRG_Soldier_3_F",[]],["V_BandollierB_oli",[]],["B_ViperLightHarness_oli_F",[]],"H_HelmetB_TI_tna_F","G_Balaclava_TI_G_tna_F",[],["","","","","",""]], [4434.98, 4311.21, 14.0379], [0.743393, -0.668855, 0], [0, 0, 1]],
["Exile_Guard_01", ["InBaseMoves_SittingRifle1","InBaseMoves_SittingRifle2"], "", "GreekHead_A3_05", [["arifle_SPAR_03_khk_F","","","optic_AMS_khk",["20Rnd_762x51_Mag",20],[],""],[],[],["U_B_CTRG_Soldier_F",[["20Rnd_762x51_Mag",20,2]]],[],["B_ViperHarness_oli_F",[["20Rnd_762x51_Mag",20,1]]],"H_HelmetB_TI_tna_F","G_Balaclava_TI_G_tna_F",[],["","","","","",""]], [4442.91, 4311.77, 13.5701], [0.0396142, -0.999215, 0], [0, 0, 1]],
["Exile_Trader_WasteDump", ["InBaseMoves_HandsBehindBack1"], "Exile_Trader_WasteDump", "WhiteHead_12", [[],[],["hgun_P07_khk_F","","","",["16Rnd_9x21_Mag",16],[],""],["U_B_CTRG_Soldier_2_F",[["16Rnd_9x21_Mag",16,3]]],["V_Rangemaster_belt",[]],[],"H_Cap_oli","",[],["","","","","",""]], [12209.1, 8161.91, 49.5289], [-0.910106, -0.414376, 0], [0, 0, 1]],
["Exile_Trader_Armory", ["InBaseMoves_SittingRifle1","InBaseMoves_SittingRifle2"], "Exile_Trader_Armory", "GreekHead_A3_07", [["arifle_MX_GL_khk_F","muzzle_snds_H_khk_F","","optic_ERCO_khk_F",["30Rnd_65x39_caseless_mag",30],[],""],[],[],["U_B_T_Soldier_AR_F",[["30Rnd_65x39_caseless_mag",30,3]]],["V_Rangemaster_belt",[]],[],"H_HelmetB_Enh_tna_F","G_Shades_Green",[],["","","","","",""]], [12212.4, 8178.57, 50.7307], [0.261202, -0.965284, 0], [0, 0, 1]],
["Exile_Trader_Equipment", ["HubSittingHighB_idle1","HubSittingHighB_idle2","HubSittingHighB_idle3"], "Exile_Trader_Equipment", "GreekHead_A3_09", [["arifle_SPAR_03_khk_F","muzzle_snds_B_khk_F","","optic_LRPS_tna_F",["20Rnd_762x51_Mag",20],[],"bipod_01_F_khk"],[],[],["U_B_T_Soldier_SL_F",[["20Rnd_762x51_Mag",20,2]]],["V_PlateCarrier1_tna_F",[["20Rnd_762x51_Mag",20,1]]],[],"H_HelmetB_tna_F","G_Sport_Blackred",[],["","","","","",""]], [12207.7, 8172.72, 50.2165], [0.0895986, 0.992624, 0.0816693], [-0.0073427, -0.0813386, 0.996659]],
["Exile_Trader_Food", ["HubSittingChairUC_idle1","HubSittingChairUC_idle2","HubSittingChairUC_idle3","HubSittingChairUC_move1"], "Exile_Trader_Food", "WhiteHead_11", [[],[],[],["U_B_T_Soldier_F",[]],[],[],"","G_Spectacles_Tinted",[],["","","","","",""]], [12213, 8180.09, 51.9029], [-0.525523, 0.850779, 0], [0, 0, 1]],
["Exile_Trader_Office", ["HubSittingAtTableU_idle1","HubSittingAtTableU_idle2","HubSittingAtTableU_idle3"], "Exile_Trader_Office", "WhiteHead_07", [[],[],["hgun_P07_khk_F","","","",["16Rnd_9x21_Mag",16],[],""],["U_B_T_Soldier_AR_F",[["16Rnd_9x21_Mag",16,3]]],["V_Rangemaster_belt",[]],[],"H_MilCap_tna_F","",[],["","","","","",""]], [12179.6, 8195.8, 51.4501], [0.157762, 0.987477, 0], [0, 0, 1]],
["Exile_Guard_02", ["InBaseMoves_patrolling1"], "", "WhiteHead_21", [["arifle_SPAR_01_GL_khk_F","muzzle_snds_m_khk_F","","optic_Hamr_khk_F",["30Rnd_556x45_Stanag",30],[],""],[],[],["U_B_T_Soldier_F",[["30Rnd_556x45_Stanag",30,3]]],["V_PlateCarrier1_tna_F",[]],["B_AssaultPack_tna_F",[]],"H_HelmetB_Enh_tna_F","G_Combat_Goggles_tna_F",[],["","","","","",""]], [12192.7, 8153.75, 49.037], [0.934906, -0.354895, 0], [0, 0, 1]],
["Exile_Guard_01", ["InBaseMoves_patrolling2"], "", "WhiteHead_20", [["arifle_MX_khk_F","muzzle_snds_H_khk_F","","optic_ERCO_khk_F",["30Rnd_65x39_caseless_mag",30],[],"bipod_01_F_khk"],[],[],["U_B_T_Soldier_F",[["30Rnd_65x39_caseless_mag",30,3]]],["V_PlateCarrier1_tna_F",[]],["B_AssaultPack_tna_F",[]],"H_HelmetB_Enh_tna_F","G_Tactical_Black",[],["","","","","",""]], [12195.6, 8214.73, 51.2905], [0.761731, -0.647894, 0], [0, 0, 1]],
["Exile_Trader_Equipment", ["AmovPsitMstpSrasWrflDnon_WeaponCheck1","AmovPsitMstpSrasWrflDnon_WeaponCheck2","AmovPsitMstpSrasWrflDnon_Smoking"], "Exile_Trader_Equipment", "WhiteHead_07", [["Exile_Weapon_LeeEnfield","","","",["Exile_Magazine_10Rnd_303",10],[],""],[],[],["U_I_C_Soldier_Para_2_F",[["Exile_Magazine_10Rnd_303",10,3]]],["V_BandollierB_rgr",[]],[],"","G_Aviator",[],["","","","","",""]], [11655.5, 4123.17, 164.612], [0.818345, -0.574728, 0], [0, 0, 1]],
["Exile_Trader_Office", ["HubSittingChairUB_idle1","HubSittingChairUB_idle2","HubSittingChairUB_idle3","HubSittingChairUB_move1"], "Exile_Trader_Office", "WhiteHead_15", [[],[],[],["U_I_C_Soldier_Camo_F",[]],[],[],"H_Hat_tan","",[],["","","","","",""]], [11666, 4097.06, 165.242], [0.875696, -0.482863, 0], [0, 0, 1]],
["Exile_Trader_Armory", ["HubSittingChairC_idle1","HubSittingChairC_idle2","HubSittingChairC_idle3","HubSittingChairC_move1"], "Exile_Trader_Armory", "WhiteHead_19", [["arifle_AK12_GL_F","","","optic_MRCO",["30Rnd_762x39_Mag_F",30],[],""],[],[],["U_I_C_Soldier_Para_1_F",[["30Rnd_762x39_Mag_F",30,1]]],["V_Rangemaster_belt",[["30Rnd_762x39_Mag_F",30,2]]],[],"H_MilCap_gry","G_Shades_Black",[],["","","","","",""]], [11660.8, 4116.49, 164.629], [-0.679335, 0.733828, 0], [0, 0, 1]],
["Exile_Trader_Hardware", ["HubSittingHighB_idle1","HubSittingHighB_idle2","HubSittingHighB_idle3"], "Exile_Trader_Hardware", "WhiteHead_06", [["arifle_AKM_F","","","",["30Rnd_762x39_Mag_F",30],[],""],[],[],["U_I_C_Soldier_Para_4_F",[["30Rnd_762x39_Mag_F",30,3]]],["V_BandollierB_rgr",[]],["B_UAV_01_backpack_F",[]],"H_Booniehat_khk_hs","",[],["","","","","",""]], [11659.7, 4085.5, 164.747], [0.928693, 0.370849, 0], [0, 0, 1]],
["Exile_Trader_Food", ["InBaseMoves_table1"], "Exile_Trader_Food", "WhiteHead_12", [[],[],[],["U_I_C_Soldier_Para_3_F",[]],[],[],"H_Cap_blk","G_Aviator",[],["","","","","",""]], [11666.9, 4078.86, 165.219], [-0.9966, -0.0823912, 0], [0, 0, 1]],
["Exile_Trader_Vehicle", ["HubFixingVehicleProne_idle1"], "Exile_Trader_Vehicle", "AfricanHead_02", [[],[],[],["U_I_C_Soldier_Para_5_F",[]],[],[],"H_Bandanna_gry","G_Squares",[],["","","","","",""]], [11646.1, 4117.23, 164.377], [-0.960024, 0.232079, 0.156504], [0.160897, 0, 0.986971]],
["Exile_Trader_VehicleCustoms", ["InBaseMoves_assemblingVehicleErc"], "Exile_Trader_VehicleCustoms", "WhiteHead_04", [[],[],[],["U_I_C_Soldier_Bandit_5_F",[]],[],[],"H_StrawHat_dark","",[],["","","","","",""]], [11648.7, 4116.3, 164.199], [-0.99983, -0.018412, 0], [0, 0, 1]],
["Exile_Trader_WasteDump", ["HubStandingUA_idle1","HubStandingUA_idle2","HubStandingUA_idle3","HubStandingUA_move1","HubStandingUA_move2"], "Exile_Trader_WasteDump", "GreekHead_A3_08", [[],[],[],["U_I_C_Soldier_Bandit_1_F",[]],[],[],"H_Booniehat_tan","",[],["","","","","",""]], [11652.1, 4094, 165.567], [-0.980591, -0.196066, 0], [0, 0, 1]],
["Exile_Guard_01", ["InBaseMoves_patrolling1"], "", "WhiteHead_10", [["arifle_AK12_F","","","",["30Rnd_762x39_Mag_F",30],[],""],[],[],["U_I_C_Soldier_Para_1_F",[["30Rnd_762x39_Mag_F",30,3]]],["V_TacChestrig_grn_F",[]],["B_Kitbag_rgr",[]],"H_Bandanna_cbr","G_Squares_Tinted",[],["","","","","",""]], [11646.5, 4074.6, 166.088], [-0.278379, -0.960471, 0], [0, 0, 1]],
["Exile_Guard_02", ["InBaseMoves_patrolling2"], "", "WhiteHead_17", [["arifle_AKM_F","","","",["30Rnd_762x39_Mag_F",30],[],""],[],[],["U_I_C_Soldier_Camo_F",[["30Rnd_762x39_Mag_F",30,2]]],["V_TacChestrig_grn_F",[["30Rnd_762x39_Mag_F",30,1]]],[],"H_HelmetCrew_I","G_Bandanna_sport",[],["","","","","",""]], [11683.7, 4108.18, 162.002], [0.991671, 0.128795, 0], [0, 0, 1]],
["Exile_Guard_03", ["InBaseMoves_patrolling2"], "", "WhiteHead_03", [["srifle_GM6_ghex_F","","","optic_LRPS_ghex_F",["5Rnd_127x108_Mag",5],[],""],[],[],["U_O_V_Soldier_Viper_F",[]],[],["B_ViperLightHarness_ghex_F",[]],"H_HelmetO_ViperSP_ghex_F","G_Squares_Tinted",[],["","","","","",""]], [8906.68, 8519.94, 228.91], [-0.567758, 0.823196, 0], [0, 0, 1]],
["Exile_Trader_SpecialOperations", ["Acts_InjuredLookingRifle01","Acts_InjuredLookingRifle02","Acts_InjuredLookingRifle03","Acts_InjuredLookingRifle04","Acts_InjuredLookingRifle05"], "Exile_Trader_SpecialOperations", "WhiteHead_08", [["srifle_DMR_07_ghex_F","","","optic_DMS_ghex_F",["20Rnd_650x39_Cased_Mag_F",20],[],""],[],[],["U_O_T_Soldier_F",[["20Rnd_650x39_Cased_Mag_F",20,3]]],["V_HarnessO_ghex_F",[]],["B_FieldPack_ghex_F",[]],"","",[],["","","","","",""]], [8916.56, 8519.21, 229.426], [-0.788744, -0.614722, 0], [0, 0, 1]],
["Exile_Trader_Boat", ["HubSittingChairUB_idle1","HubSittingChairUB_idle2","HubSittingChairUB_idle3","HubSittingChairUB_move1"], "Exile_Trader_Boat", "WhiteHead_15", [[],[],[],["U_C_man_sport_2_F",[]],[],[],"H_Cap_red","",[],["","","","","",""]], [8939.25, 4777.67, 0.871102], [-0.884297, -0.466814, 0.0102042], [-0.0379412, 0.0936202, 0.994885]],
["Exile_Trader_Diving", ["AdvePercMstpSnonWrflDnon"], "Exile_Trader_Diving", "WhiteHead_11", [["arifle_SDAR_F","","","",[],[],""],[],[],["Exile_Uniform_Wetsuit_AAF",[]],["Exile_Vest_Rebreather_AAF",[]],[],"","Exile_Glasses_Diving_AAF",[],["","","","","",""]], [8923.01, 4786.47, -1.0074], [0.913176, -0.407566, 0], [0, 0, 1]],
["Exile_Trader_BoatCustoms", ["Acts_passenger_flatground_leanright"], "Exile_Trader_BoatCustoms", "WhiteHead_21", [[],[],[],["U_C_man_sport_1_F",[]],[],[],"H_Bandanna_surfer","G_Shades_Blue",[],["","","","","",""]], [8937.51, 4778.09, 0.420595], [0.453686, -0.881499, 0.130877], [-0.106065, 0.0924052, 0.990056]],
["Exile_Trader_Boat", ["c5efe_MichalLoop"], "Exile_Trader_Boat", "WhiteHead_19", [[],[],[],["U_C_man_sport_1_F",[]],[],[],"H_Bandanna_surfer","",[],["","","","","",""]], [5636.81, 5018.04, -0.0491986], [0.672607, 0.74, 0], [0, 0, 1]],
["Exile_Trader_BoatCustoms", ["HubSittingChairB_idle1","HubSittingChairB_idle2","HubSittingChairB_idle3","HubSittingChairB_move1"], "Exile_Trader_BoatCustoms", "WhiteHead_15", [["SMG_05_F","","","",["30Rnd_9x21_Mag_SMG_02",30],[],""],[],[],["U_I_C_Soldier_Bandit_1_F",[["30Rnd_9x21_Mag_SMG_02",30,2]]],[],[],"H_Cap_oli","G_Aviator",[],["","","","","",""]], [5635.67, 5015.97, -0.0169603], [0.60185, 0.798609, 0], [0, 0, 1]],
["Exile_Trader_Boat", ["HubSittingChairUB_idle1","HubSittingChairUB_idle2","HubSittingChairUB_idle3","HubSittingChairUB_move1"], "Exile_Trader_Boat", "WhiteHead_18", [[],[],[],["U_C_Man_casual_4_F",[]],[],[],"H_Cap_surfer","G_Shades_Blue",[],["","","","","",""]], [5407.33, 10940.9, 0.493368], [0.67103, 0.741317, 0.0129384], [-0.0192778, 0, 0.999814]],
["Exile_Trader_BoatCustoms", ["InBaseMoves_SittingRifle1","InBaseMoves_SittingRifle2"], "Exile_Trader_BoatCustoms", "WhiteHead_14", [["hgun_PDW2000_F","","","",["30Rnd_9x21_Mag",30],[],""],[],[],["U_C_man_sport_2_F",[["30Rnd_9x21_Mag",30,1]]],[],[],"","G_Sport_Blackred",[],["","","","","",""]], [5411.12, 10940.2, 0.937074], [-0.435074, 0.900395, 0], [0, 0, 1]],
["Exile_Trader_Boat", ["UnaErcPoslechVelitele1","UnaErcPoslechVelitele2","UnaErcPoslechVelitele3","UnaErcPoslechVelitele4"], "Exile_Trader_Boat", "GreekHead_A3_06", [[],[],[],["U_I_C_Soldier_Bandit_5_F",[]],[],[],"H_Booniehat_khk","",[],["","","","","",""]], [11050.7, 13373.2, 1.35528], [0.835724, -0.549149, 0], [0, 0, 1]],
["Exile_Trader_Boat", ["c5efe_MichalLoop"], "Exile_Trader_Boat", "WhiteHead_11", [[],[],[],["U_C_Man_casual_5_F",[]],[],[],"H_Hat_blue","G_Sport_Blackred",[],["","","","","",""]], [12300, 6565.68, 0.64466], [-0.645101, -0.764098, 0], [0, 0, 1]],
["Exile_Trader_BoatCustoms", ["InBaseMoves_Lean1"], "Exile_Trader_BoatCustoms", "GreekHead_A3_07", [["hgun_PDW2000_F","","","",["30Rnd_9x21_Mag",30],[],""],[],[],["U_C_Poloshirt_redwhite",[["30Rnd_9x21_Mag",30,1]]],[],[],"","",[],["","","","","",""]], [12298.8, 6567.54, 0.639293], [0.861109, 0.508421, 0], [0, 0, 1]],
["Exile_Trader_Boat", ["Acts_passenger_flatground_leanright"], "Exile_Trader_Boat", "WhiteHead_19", [["arifle_AKM_F","","","",["30Rnd_762x39_Mag_F",30],[],""],[],[],["U_C_Man_casual_6_F",[["30Rnd_762x39_Mag_F",30,2]]],[],[],"H_Hat_grey","G_Aviator",[],["","","","","",""]], [5401.26, 7569.42, 1.07069], [0.992494, 0.122289, 0], [0, 0, 1]],
["Exile_Trader_BoatCustoms", ["UnconsciousReviveDefault_A","UnconsciousReviveDefault_B","UnconsciousReviveDefault_C"], "Exile_Trader_BoatCustoms", "WhiteHead_04", [[],[],[],["U_C_Poloshirt_blue",[]],[],[],"H_Hat_blue","",[],["","","","","",""]], [5403.5, 7571.38, 1.08175], [-0.922454, 0.386107, 0], [0, 0, 1]],
["Exile_Trader_Hardware", ["InBaseMoves_Lean1"], "Exile_Trader_Hardware", "WhiteHead_17", [["arifle_MX_Black_F","","","",["30Rnd_65x39_caseless_mag",30],[],""],[],["hgun_P07_khk_F","","","",["16Rnd_9x21_Mag",16],[],""],["U_C_WorkerCoveralls",[["16Rnd_9x21_Mag",16,3]]],[],[],"Exile_Headgear_SafetyHelmet","",[],["","","","","",""]], [12182.8, 8187.64, 51.37], [0.625202, -0.780463, 0], [0, 0, 1]],
["Exile_Trader_Aircraft", ["LHD_krajPaluby"], "Exile_Trader_Aircraft", "WhiteHead_05", [[],[],[],["U_I_pilotCoveralls",[]],[],[],"H_PilotHelmetHeli_O","",[],["","","","","",""]], [11701.1, 3035.83, 4.69144], [0.789223, 0.614106, 0], [0, 0, 1]],
["Exile_Trader_AircraftCustoms", ["HubStandingUA_idle1","HubStandingUA_idle2","HubStandingUA_idle3","HubStandingUA_move1","HubStandingUA_move2"], "Exile_Trader_AircraftCustoms", "WhiteHead_11", [[],[],[],["Exile_Uniform_ExileCustoms",[]],["V_RebreatherB",[]],[],"H_PilotHelmetFighter_B","",[],["","","","","",""]], [11710.5, 3027.81, 4.69147], [0.628238, 0.778021, 0], [0, 0, 1]],
["Exile_Trader_Aircraft", ["LHD_krajPaluby"], "Exile_Trader_Aircraft", "WhiteHead_20", [[],[],[],["U_I_pilotCoveralls",[]],[],[],"H_PilotHelmetHeli_O","G_Tactical_Clear",[],["","","","","",""]], [7195.78, 6956.66, 2.65007], [0.942591, 0.333951, 0], [0, 0, 1]],
["Exile_Trader_AircraftCustoms", ["HubStandingUA_idle1","HubStandingUA_idle2","HubStandingUA_idle3","HubStandingUA_move1","HubStandingUA_move2"], "Exile_Trader_AircraftCustoms", "WhiteHead_17", [[],[],[],["Exile_Uniform_ExileCustoms",[]],["V_RebreatherB",[]],[],"H_PilotHelmetFighter_B","G_Tactical_Clear",[],["","","","","",""]], [7192.69, 6965.03, 2.6614], [0.947454, 0.319891, 0], [0, 0, 1]],
["Exile_Trader_Aircraft", ["LHD_krajPaluby"], "Exile_Trader_Aircraft", "AfricanHead_02", [[],[],[],["U_I_pilotCoveralls",[]],[],[],"H_PilotHelmetHeli_O","",[],["","","","","",""]], [11561.1, 13158.9, 6.95143], [0.477393, 0.87869, 0], [0, 0, 1]],
["Exile_Trader_AircraftCustoms", ["HubStandingUA_idle1","HubStandingUA_idle2","HubStandingUA_idle3","HubStandingUA_move1","HubStandingUA_move2"], "Exile_Trader_AircraftCustoms", "AfricanHead_01", [[],[],[],["Exile_Uniform_ExileCustoms",[]],["V_RebreatherB",[]],[],"H_PilotHelmetFighter_B","",[],["","","","","",""]], [11554.3, 13160.2, 6.95143], [0.564486, 0.825443, 0], [0, 0, 1]],
["Exile_Guard_01", ["InBaseMoves_patrolling1"], "", "WhiteHead_14", [["arifle_AK12_F","","","",["30Rnd_762x39_Mag_F",30],[],""],[],[],["U_I_C_Soldier_Para_1_F",[["30Rnd_762x39_Mag_F",30,3]]],["V_TacChestrig_grn_F",[]],["B_Kitbag_rgr",[]],"H_Bandanna_cbr","G_Squares_Tinted",[],["","","","","",""]], [2297.99, 8613.18, 1.29399], [-0.260873, 0.965373, 0], [0, 0, 1]],
["Exile_Guard_02", ["InBaseMoves_patrolling2"], "", "AfricanHead_03", [["arifle_AKM_F","","","",["30Rnd_762x39_Mag_F",30],[],""],[],[],["U_I_C_Soldier_Camo_F",[["30Rnd_762x39_Mag_F",30,2]]],["V_TacChestrig_grn_F",[["30Rnd_762x39_Mag_F",30,1]]],[],"H_HelmetCrew_I","G_Bandanna_sport",[],["","","","","",""]], [2258.9, 8588.05, 1.34072], [0.612935, -0.788651, 0.0483741], [0, 0.0612227, 0.998124]],
["Exile_Guard_01", ["AmovPercMstpSnonWnonDnon_exercisePushup","AmovPercMstpSnonWnonDnon_exercisePushup","AmovPercMstpSnonWnonDnon_exercisekneeBendA","AmovPercMstpSnonWnonDnon_exercisekneeBendA","AmovPercMstpSnonWnonDnon_exercisekneeBendB"], "", "WhiteHead_18", [[],[],[],["U_B_T_Soldier_AR_F",[]],[],[],"","",[],["","","","","",""]], [12211.5, 8190.11, 51.9022], [-0.63663, -0.771169, 0], [0, 0, 1]],
["Exile_Trader_Vehicle", ["Acts_carFixingWheel"], "Exile_Trader_Vehicle", "WhiteHead_12", [[],[],[],["U_B_T_Soldier_AR_F",[]],[],[],"H_Bandanna_gry","G_Squares",[],["","","","","",""]], [12172.9, 8182.72, 51.0935], [-0.982938, 0.183938, 0], [0, 0, 1]],
["Exile_Trader_VehicleCustoms", ["HubSittingChairUB_idle1","HubSittingChairUB_idle2","HubSittingChairUB_idle3","HubSittingChairUB_move1"], "Exile_Trader_VehicleCustoms", "AfricanHead_01", [[],[],[],["U_B_T_Soldier_F",[]],[],[],"H_Booniehat_tna_F","",[],["","","","","",""]], [12177.5, 8183.23, 51.1069], [-0.258837, -0.965921, 0], [0, 0, 1]],
["Exile_Trader_Office", ["HubBriefing_loop","HubBriefing_scratch","HubBriefing_stretch","HubBriefing_think"], "Exile_Trader_Office", "WhiteHead_14", [[],[],[],["U_I_G_resistanceLeader_F",[]],["V_Rangemaster_belt",[]],[],"H_Hat_brown","",[],["","","","","",""]], [7976.57, 12422.5, 123.01], [0.538646, 0.842533, 0], [0, 0, 1]],
["Exile_Trader_Armory", ["sitTableRfl_listening"], "Exile_Trader_Armory", "WhiteHead_19", [["srifle_DMR_06_olive_F","","","",[],[],""],[],[],["U_I_C_Soldier_Bandit_3_F",[]],["V_Rangemaster_belt",[]],[],"H_Cap_headphones","",[],["","","","","",""]], [8016.64, 12411.7, 125.162], [0.972369, -0.232096, 0.0250835], [0, 0.107448, 0.994211]],
["Exile_Trader_Equipment", ["InBaseMoves_table1"], "Exile_Trader_Equipment", "Default", [["arifle_RPK74","","","",["45Rnd_Green_Tracer_545x39_RPK",45],[],""],[],[],["U_I_C_Soldier_Bandit_2_F",[]],["V_I_G_resistanceLeader_F",[["45Rnd_Green_Tracer_545x39_RPK",45,3]]],[],"","G_Bandanna_oli",[],["","","","","",""]], [8005.56, 12429.2, 124.027], [-0.897935, 0.440127, 0], [0, 0, 1]],
["Exile_Trader_Food", ["InBaseMoves_SittingRifle1","InBaseMoves_SittingRifle2"], "Exile_Trader_Food", "WhiteHead_15", [["srifle_CZ550_base","","","",["5x_22_LR_17_HMR_M",5],[],""],[],[],["U_I_C_Soldier_Bandit_5_F",[["5x_22_LR_17_HMR_M",5,3]]],[],[],"H_Cap_tan","",[],["","","","","",""]], [7994.21, 12439.8, 123.897], [-0.085695, -0.996321, 0], [0, 0, 1]],
["Exile_Trader_Hardware", ["HubSittingChairUC_idle1","HubSittingChairUC_idle2","HubSittingChairUC_idle3","HubSittingChairUC_move1"], "Exile_Trader_Hardware", "AfricanHead_02", [[],[],[],["U_C_WorkerCoveralls",[]],["V_BandollierB_rgr",[]],[],"","G_Aviator",[],["","","","","",""]], [7988.36, 12440.8, 123.877], [0.48661, -0.873619, 0], [0, 0, 1]],
["Exile_Trader_WasteDump", ["Acts_CivilListening_2"], "Exile_Trader_WasteDump", "AfricanHead_01", [[],[],[],["U_I_C_Soldier_Para_4_F",[]],["V_Rangemaster_belt",[]],[],"H_MilCap_gry","G_Aviator",[],["","","","","",""]], [8007.16, 12388.3, 125.844], [0.137963, 0.990437, 0], [0, 0, 1]],
["Exile_Trader_Vehicle", ["HubFixingVehicleProne_idle1"], "Exile_Trader_Vehicle", "AfricanHead_02", [[],[],[],["U_I_C_Soldier_Bandit_1_F",[]],[],[],"H_Cap_red","",[],["","","","","",""]], [8010.04, 12423.3, 124.233], [-0.996794, 0.0676586, -0.0427131], [-0.0458379, -0.0453257, 0.99792]],
["Exile_Trader_VehicleCustoms", ["Acts_carFixingWheel"], "Exile_Trader_VehicleCustoms", "AfricanHead_03", [[],[],[],["U_I_C_Soldier_Bandit_4_F",[]],[],[],"","G_Aviator",[],["","","","","",""]], [8011.74, 12420.7, 124.424], [-0.752088, 0.659063, 0], [0, 0, 1]],
["Exile_Trader_Diving", ["c5efe_MichalLoop"], "Exile_Trader_Diving", "WhiteHead_21", [[],[],[],["Exile_Uniform_Wetsuit_NATO",[]],["Exile_Vest_Rebreather_NATO",[]],[],"","Exile_Glasses_Diving_NATO",[],["","","","","",""]], [5639.26, 5019.8, 1.13171], [0.127639, 0.991821, 0], [0, 0, 1]],
["Exile_Trader_Diving", ["AmovPsitMstpSrasWrflDnon_WeaponCheck1","AmovPsitMstpSrasWrflDnon_WeaponCheck2"], "Exile_Trader_Diving", "WhiteHead_15", [["arifle_SDAR_F","","","",["20Rnd_556x45_UW_mag",20],[],""],[],[],["Exile_Uniform_Wetsuit_CSAT",[["20Rnd_556x45_UW_mag",20,3]]],["V_RebreatherIR",[]],[],"","Exile_Glasses_Diving_CSAT",[],["","","","","",""]], [5409.85, 7559.8, 0.0954094], [0.296426, 0.955056, 0], [0, 0, 1]],
["Exile_Trader_Diving", ["HubSittingHighB_move1"], "Exile_Trader_Diving", "WhiteHead_20", [["arifle_SDAR_F","","","",["20Rnd_556x45_UW_mag",20],[],""],[],[],["Exile_Uniform_Wetsuit_AAF",[["20Rnd_556x45_UW_mag",20,3]]],["V_RebreatherIR",[]],[],"","Exile_Glasses_Diving_CSAT",[],["","","","","",""]], [12297.3, 6569.02, -0.218481], [-0.771331, 0.636435, 0], [0, 0, 1]],
["Exile_Trader_Diving", ["HubSittingHighB_move1"], "Exile_Trader_Diving", "WhiteHead_06", [["arifle_SDAR_F","","","",["20Rnd_556x45_UW_mag",20],[],""],[],[],["Exile_Uniform_Wetsuit_NATO",[["20Rnd_556x45_UW_mag",20,3]]],["Exile_Vest_Rebreather_NATO",[]],[],"","Exile_Glasses_Diving_NATO",[],["","","","","",""]], [5402.99, 10942.3, -0.0793096], [-0.982904, 0.184118, 0], [0, 0, 1]],
["Exile_Trader_Diving", ["AdvePercMstpSnonWrflDnon"], "Exile_Trader_Diving", "WhiteHead_20", [["arifle_SDAR_F","","","",["20Rnd_556x45_UW_mag",20],[],""],[],[],["Exile_Uniform_Wetsuit_NATO",[["20Rnd_556x45_UW_mag",20,3]]],["Exile_Vest_Rebreather_NATO",[]],[],"","Exile_Glasses_Diving_NATO",[],["","","","","",""]], [2267.78, 8616.37, -1.15847], [-0.857565, -0.514375, 0], [0, 0, 1]],
["Exile_Trader_Diving", ["AdvePercMstpSnonWrflDnon"], "Exile_Trader_Diving", "WhiteHead_09", [["arifle_SDAR_F","","","",["20Rnd_556x45_UW_mag",20],[],""],[],[],["Exile_Uniform_Wetsuit_NATO",[["20Rnd_556x45_UW_mag",20,3]]],["Exile_Vest_Rebreather_NATO",[]],[],"","Exile_Glasses_Diving_NATO",[],["","","","","",""]], [11061.8, 13373, -1.12118], [-0.890015, -0.455931, 0], [0, 0, 1]],
["Exile_Guard_01", ["Acts_TreatingWounded01","Acts_TreatingWounded02","Acts_TreatingWounded03","Acts_TreatingWounded04","Acts_TreatingWounded05","Acts_TreatingWounded06"], "", "WhiteHead_16", [[],[],[],["U_I_C_Soldier_Para_1_F",[]],[],[],"H_Cap_tan","",[],["","","","","",""]], [7980.3, 12419.1, 122.93], [-0.195554, -0.980272, 0.0287372], [0, 0.029303, 0.999571]],
["Exile_Guard_02", ["Acts_LyingWounded_loop1","Acts_LyingWounded_loop2","Acts_LyingWounded_loop3"], "", "WhiteHead_16", [[],[],[],["U_I_C_Soldier_Bandit_3_F",[]],[],[],"","",[],["","","","","",""]], [7979.94, 12418.6, 122.979], [-0.965939, 0.258769, 0], [0, 0, 1]],
["Exile_Guard_02", ["InBaseMoves_SittingRifle1","InBaseMoves_SittingRifle2"], "", "GreekHead_A3_09", [["arifle_AKM_F","","","",["30Rnd_762x39_Mag_F",30],[],""],[],[],["U_I_C_Soldier_Para_5_F",[["30Rnd_762x39_Mag_F",30,3]]],[],[],"H_StrawHat_dark","",[],["","","","","",""]], [7994.25, 12416.7, 123.691], [0.368708, 0.929545, 0], [0, 0, 1]],
["Exile_Trader_BoatCustoms", ["HubSittingChairB_idle1","HubSittingChairB_idle2","HubSittingChairB_idle3","HubSittingChairB_move1"], "Exile_Trader_BoatCustoms", "WhiteHead_06", [["arifle_CTAR_blk_F","","","",["30Rnd_580x42_Mag_F",30],[],""],[],[],["U_C_Poloshirt_salmon",[["30Rnd_580x42_Mag_F",30,1]]],[],[],"","",[],["","","","","",""]], [11058.1, 13384.3, 0.884787], [-0.881628, 0.471944, 0], [0, 0, 1]]
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
// Claim-Vehicles (MezoPlays) -- server side is ClaimVehicles_Server.pbo
[] execVM "ClaimVehicles_Client\ClaimVehicles_Client_init.sqf";

// Player Market By Cyunide
{
    _x params [['_function',''],['_file','']];
    _code = compileFinal (preprocessFileLineNumbers _file);
    missionNamespace setVariable [_function,_code];
} 
forEach
[
   ['ExileClient_system_transport_network_getItemGUIResponse','MarketByCyunide\Functions\ExileClient_system_transport_network_getItemGUIResponse.sqf'],
   ['ExileClient_system_transport_network_listPlayerMarketResponse','MarketByCyunide\Functions\ExileClient_system_transport_network_listPlayerMarketResponse.sqf'],
   ['ExileClient_gui_xm8_slide_cyMachine_onOpen','MarketByCyunide\Functions\onOpen.sqf'],
   ['ExileClient_gui_xm8_slide_cyMachineSell_onOpen','MarketByCyunide\Functions\onSellOpen.sqf']
];

// GADD Trick or Treat
{
    _code = '';
    _function = _x select 0;
    _file = _x select 1;

    _code = compileFinal (preprocessFileLineNumbers _file);                    

    missionNamespace setVariable [_function, _code];
}
forEach 
[
	['ExileClient_gadd_network_TrickOrTreatResponse', 'GADD_Apps\TrickOrTreat\ExileClient_gaddTT_network_TrickOrTreatResponse.sqf'],
	['GADD_TrickOrTreat_Request', 'GADD_Apps\TrickOrTreat\GADD_TrickOrTreat_Request.sqf'],
	['GADD_TT_Smoke', 'GADD_Apps\TrickOrTreat\Tricks\GADD_TT_Smoke.sqf'],
	['GADD_TT_Bombs', 'GADD_Apps\TrickOrTreat\Tricks\GADD_TT_Bombs.sqf'],
	['GADD_TT_Tripwire', 'GADD_Apps\TrickOrTreat\Tricks\GADD_TT_Tripwire.sqf']
];

// ExileLoadouts
ExileClientPlayerLoadoutServerName = getText(missionConfigFile >> "CfgLoadout" >> "Settings" >> "ServerName");
ExileClientPlayerLoadoutMax = getNumber(missionConfigFile >> "CfgLoadout" >> "Settings" >> "MaxLoadouts");
ExileClientPlayerLoadoutNumber = 1;

{
    _code = '';
    _function = _x select 0;
    _file = _x select 1;
    _code = compileFinal (preprocessFileLineNumbers _file);
    missionNamespace setVariable [_function, _code];
}
forEach
[
	['ExileClient_gui_loadoutDialog_calculateLoadoutPrice', 'custom\loadouts\ExileClient_gui_loadoutDialog_calculateLoadoutPrice.sqf'],
	['ExileClient_gui_loadoutDialog_canAddLoadoutItem', 'custom\loadouts\ExileClient_gui_loadoutDialog_canAddLoadoutItem.sqf'],
	['ExileClient_gui_loadoutDialog_containerCargo_list', 'custom\loadouts\ExileClient_gui_loadoutDialog_containerCargo_list.sqf'],
	['ExileClient_gui_loadoutDialog_event_checkLoadout', 'custom\loadouts\ExileClient_gui_loadoutDialog_event_checkLoadout.sqf'],
	['ExileClient_gui_loadoutDialog_event_onAddLoadoutButtonClick', 'custom\loadouts\ExileClient_gui_loadoutDialog_event_onAddLoadoutButtonClick.sqf'],
	['ExileClient_gui_loadoutDialog_event_onApplyLoadoutButtonClick', 'custom\loadouts\ExileClient_gui_loadoutDialog_event_onApplyLoadoutButtonClick.sqf'],
	['ExileClient_gui_loadoutDialog_event_onBuyLoadoutButtonClick', 'custom\loadouts\ExileClient_gui_loadoutDialog_event_onBuyLoadoutButtonClick.sqf'],
	['ExileClient_gui_loadoutDialog_event_onClearLoadoutButtonClick', 'custom\loadouts\ExileClient_gui_loadoutDialog_event_onClearLoadoutButtonClick.sqf'],
	['ExileClient_gui_loadoutDialog_event_onInventoryListBoxSelectionChanged', 'custom\loadouts\ExileClient_gui_loadoutDialog_event_onInventoryListBoxSelectionChanged.sqf'],
	['ExileClient_gui_loadoutDialog_event_onPlayerInventoryDropDownSelectionChanged', 'custom\loadouts\ExileClient_gui_loadoutDialog_event_onPlayerInventoryDropDownSelectionChanged.sqf'],
	['ExileClient_gui_loadoutDialog_event_onLoudoutDropDownSelectionChanged', 'custom\loadouts\ExileClient_gui_loadoutDialog_event_onLoudoutDropDownSelectionChanged.sqf'],
	['ExileClient_gui_loadoutDialog_event_onUnload', 'custom\loadouts\ExileClient_gui_loadoutDialog_event_onUnload.sqf'],
	['ExileClient_gui_loadoutDialog_event_onWarningCheckboxStateChanged', 'custom\loadouts\ExileClient_gui_loadoutDialog_event_onWarningCheckboxStateChanged.sqf'],
	['ExileClient_gui_loadoutDialog_event_save', 'custom\loadouts\ExileClient_gui_loadoutDialog_event_save.sqf'],
	['ExileClient_gui_loadoutDialog_getItemCapacity', 'custom\loadouts\ExileClient_gui_loadoutDialog_getItemCapacity.sqf'],
	['ExileClient_gui_loadoutDialog_getItemMass', 'custom\loadouts\ExileClient_gui_loadoutDialog_getItemMass.sqf'],
	['ExileClient_gui_loadoutDialog_removeLoadoutItem', 'custom\loadouts\ExileClient_gui_loadoutDialog_removeLoadoutItem.sqf'],
	['ExileClient_gui_loadoutDialog_removeLoadoutListboxItem', 'custom\loadouts\ExileClient_gui_loadoutDialog_removeLoadoutListboxItem.sqf'],
	['ExileClient_gui_loadoutDialog_show', 'custom\loadouts\ExileClient_gui_loadoutDialog_show.sqf'],
	['ExileClient_gui_loadoutDialog_updateInventoryDropdown', 'custom\loadouts\ExileClient_gui_loadoutDialog_updateInventoryDropdown.sqf'],
	['ExileClient_gui_loadoutDialog_updateInventoryListBox', 'custom\loadouts\ExileClient_gui_loadoutDialog_updateInventoryListBox.sqf'],
	['ExileClient_gui_loadoutDialog_updateLoadoutDropdown', 'custom\loadouts\ExileClient_gui_loadoutDialog_updateLoadoutDropdown.sqf'],
	['ExileClient_gui_loadoutDialog_updateLoadoutInterface', 'custom\loadouts\ExileClient_gui_loadoutDialog_updateLoadoutInterface.sqf'],
	['ExileClient_gui_loadoutDialog_updateLoadoutListBox', 'custom\loadouts\ExileClient_gui_loadoutDialog_updateLoadoutListBox.sqf'],
	['ExileClient_gui_loadoutDialog_updatePriceInterface', 'custom\loadouts\ExileClient_gui_loadoutDialog_updatePriceInterface.sqf'],
	['ExileClient_system_trading_network_purchaseLoadoutResponse', 'custom\loadouts\ExileClient_system_trading_network_purchaseLoadoutResponse.sqf'],
	['ExileClient_util_addCommas', 'custom\loadouts\ExileClient_util_addCommas.sqf']
];

// Anti-floating / stair bug fix (Scripts/Exile-Anti-Floating-bug-script-aka-stair-bug)
// Zeroes velocity when the player is stuck in a fall animation near ground level.
waitUntil {!isNil"ExileClientLoadedIn"};
[
    1,
    {
        _fs = ["afalpercmstpsraswrfldnon","afalpercmstpsnonwnondnon","afalpercmstpsraswpstdnon","afalpknlmstpsraswrfldnon","afalpknlmstpsnonwnondnon"];
        if ((animationState player) in _fs) then
        {
            _f = (getPos player select 2);
            if (_f < 0.1) then
            {
                player setvelocity [0,0,0];
            };
        };
    },
    [],
    true,
    true
] call ExileClient_system_thread_addtask;

// StatusBar (Statusbar-32-64Bit) -- health/hunger/thirst/temp/respect/wallet/locker/players/fps/restart
[] execVM "custom\StatusBar\statusBar_init.sqf";

// Build Limits config (ExileBuildHeightLimit)
execVM "custom\Build_Limits\config.sqf";

// Exile_Block_Floor_Peeking (Anti-floor peeking fix)
client_toLowKneelAnimations = ["amovpknlmstpsraswrfldnon_amovpknlmstpsraswpstdnon","amovpknlmstpsraswrfldnon_gear","amovpknlmstpsraswpstdnon_gear","amovpknlmstpsraswpstdnon_amovpknlmstpsraswrfldnon","amovpknlmstpsraswrfldnon_amovpknlmstpsnonwnondnon","amovpknlmstpsraswpstdnon_amovpknlmstpsnonwnondnon"];
client_lowKneelAnimations = ["aadjpknlmstpsraswrflddown","aadjpknlmstpsraswpstddown","aadjpknlmstpsnonwnonddown"];
client_inLowKneel = false;

// A3ExilePilotHUD (Pilot HUD for aircraft)
[] execVM "custom\PilotHUD\init.sqf";

// Exile-Vanilla-Hud (Vanilla Vehicle HUD)
0 execVM "custom\Hud\vanillaHud.sqf";

// w4_lockpick (Interactive Lockpicking System)
[] execVM "addons\w4_lockpick\initLockpick.sqf";

// Blowout Radioactive Emission Event (TOGGLED OFF by default in custom\blowout\blowout_config.sqf)
// To enable: set ns_blowout = true; in custom\blowout\blowout_config.sqf and uncomment line below
// [] execVM "custom\blowout\blowout_config.sqf";

// ExileFlagHacking
{
    private _code = compileFinal (preprocessFileLineNumbers (_x select 1));
    missionNamespace setVariable [_x select 0, _code];
} forEach [
	['ExileClient_action_hackFlag_aborted','custom\FlagHacking\ExileClient_action_hackFlag_aborted.sqf'],
	['ExileClient_action_hackFlag_completed','custom\FlagHacking\ExileClient_action_hackFlag_completed.sqf'],
	['ExileClient_action_hackFlag_condition','custom\FlagHacking\ExileClient_action_hackFlag_condition.sqf'],
	['ExileClient_action_hackFlag_duration','custom\FlagHacking\ExileClient_action_hackFlag_duration.sqf'],
	['ExileClient_action_hackFlag_failChance','custom\FlagHacking\ExileClient_action_hackFlag_failChance.sqf'],
	['ExileClient_action_hackFlag_failed','custom\FlagHacking\ExileClient_action_hackFlag_failed.sqf']
];

// ExileBuildCheck (XM8 Build Check App)
ExileClient_build_check = compileFinal preprocessFileLineNumbers "custom\buildCheck\build_here.sqf";

// ExileIncomingMissile (Vehicle Missile Lock Warning)
ExileClient_object_vehicle_network_incomingMissile = compileFinal preprocessFileLineNumbers "custom\missile\ExileClient_object_vehicle_network_incomingMissile.sqf";

// Halv's Paintshop (Vehicle & Backpack Reskin Shop)
[] execVM "addons\paintshop\paintshop.sqf";

// AVS disabled: server-side AVS extDB hook crashes this Exile/extDB2 setup.
// [] execVM "AVS\AVS_fnc_init.sqf";

// ExileSafeX (Private Player Safe Deposit)
ExileClientPlayerSafeXItems = [];
ExileClientPlayerMarXetItems = [];
{
    private _code = compileFinal (preprocessFileLineNumbers (_x select 1));
    missionNamespace setVariable [_x select 0, _code];
} forEach [
	['ExileClient_gui_safeXDialog_event_onDepositButtonClick','custom\SafeX\ExileClient_gui_safeXDialog_event_onDepositButtonClick.sqf'],
	['ExileClient_gui_safeXDialog_event_onDropDownSelectionChanged','custom\SafeX\ExileClient_gui_safeXDialog_event_onDropDownSelectionChanged.sqf'],
	['ExileClient_gui_safeXDialog_event_onInventoryListBoxSelectionChanged','custom\SafeX\ExileClient_gui_safeXDialog_event_onInventoryListBoxSelectionChanged.sqf'],
	['ExileClient_gui_safeXDialog_event_onListBoxSelectionChanged','custom\SafeX\ExileClient_gui_safeXDialog_event_onListBoxSelectionChanged.sqf'],
	['ExileClient_gui_safeXDialog_event_onWithdrawButtonClick','custom\SafeX\ExileClient_gui_safeXDialog_event_onWithdrawButtonClick.sqf'],
	['ExileClient_gui_safeXDialog_show','custom\SafeX\ExileClient_gui_safeXDialog_show.sqf'],
	['ExileClient_gui_safeXDialog_updateListBox','custom\SafeX\ExileClient_gui_safeXDialog_updateListBox.sqf'],
	['ExileClient_gui_safeXDialog_updateSelection','custom\SafeX\ExileClient_gui_safeXDialog_updateSelection.sqf'],
	['ExileClient_system_safeX_network_depositItemResponse','custom\SafeX\ExileClient_system_safeX_network_depositItemResponse.sqf'],
	['ExileClient_system_safeX_network_hasSafeXResponse','custom\SafeX\ExileClient_system_safeX_network_hasSafeXResponse.sqf'],
	['ExileClient_system_safeX_network_updateMarXetResponse','custom\SafeX\ExileClient_system_safeX_network_updateMarXetResponse.sqf'],
	['ExileClient_system_safeX_network_withdrawItemResponse','custom\SafeX\ExileClient_system_safeX_network_withdrawItemResponse.sqf'],
	['ExileClient_system_safeX_network_withdrawVehicleResponse','custom\SafeX\ExileClient_system_safeX_network_withdrawVehicleResponse.sqf']
];

// ---------------------------------------------------------------------------
//  XCSV client scripts (our own work - see E:\XCSV_ADDONS for the server side)
//
//  Client-side by necessity: xcsv_chatter.pbo lives in @ExileServer, which
//  clients never receive, and both of these are per-player UI.
//
//  Both are static-text only and create no objects, so BattlEye is untouched.
// ---------------------------------------------------------------------------
// Shared helpers (XCSV_fnc_esc, XCSV_fnc_num) used by more than one app.
//
// `call compile preprocessFileLineNumbers`, NOT execVM. execVM is scheduled, so
// two execVM'd files have no guaranteed order relative to each other, and a
// helper that half the apps depend on should not be racing the apps. This runs
// to completion before the line below it starts.
call compile preprocessFileLineNumbers "xcsv\fn_shared.sqf";

[] execVM "xcsv\fn_traderVoice.sqf";
[] execVM "xcsv\fn_welcome.sqf";
// Admin-only: self-gates on UID and exits immediately for everyone else.
// Uses local markers, so nothing is broadcast and no other player sees them.
[] execVM "xcsv\fn_census.sqf";

// Admin teleport, reachable from the XM8 "Admin TP" app (App14).
// Loaded for everyone so the XM8 button resolves, but every entry point checks
// the UID whitelist first. Trips BattlEye setpos - see the file header.
[] execVM "xcsv\fn_adminTeleport.sqf";

// Scoreboard, XM8 App15. Renders XCSV_Scoreboard, which the server publishes
// on a timer - the app never queries anything, so opening it costs nothing.
// Must be loaded before the button is pressed, hence here rather than on demand.
[] execVM "xcsv\fn_scoreboard.sqf";

// Field Notes, XM8 App16. Static reference text, no server call at all.
// Every number in it comes from this mission's own config - if CfgTerritories,
// the build height limit, the sell factor or the VG capacities change, the
// notes must change with them or the manual starts lying.
[] execVM "xcsv\fn_fieldNotes.sqf";

// Faction standing, XM8 App17. Reads the published XCSV_Standing variable.
[] execVM "xcsv\fn_standing.sqf";

// Trader price lookup, XM8 App18. Pure config read - CfgExileArsenal,
// CfgTraderCategories and CfgTraders are all in missionConfigFile, so this
// makes no server call and no database query. Unlike Field Notes it cannot
// drift out of date: the index is rebuilt from config every session.
[] execVM "xcsv\fn_traderPrices.sqf";

// Dead Man's Switch, XM8 App19. The only app that writes. It sends a
// parameterless request; price, affordability, rate limiting and identity are
// all decided server-side in xcsv_chatter\network\fn_policyBuyRequest.sqf.
[] execVM "xcsv\fn_policy.sqf";

// Player Inspector, XM8 App20 (roadmap 10.1.2). Admin-only: sends a name
// fragment over xcsvInspectRequest; the server re-resolves the session, checks
// its own whitelist and answers the requesting admin with the account + flag
// rows via xcsvInspectResponse. Read-only. See xcsv\fn_playerInspector.sqf.
[] execVM "xcsv\fn_playerInspector.sqf";

// Bounty Board, XM8 App21. First slice is read-only: it exposes the player
// board surface and planned rules without posting money, targeting anyone or
// installing death hooks.
[] execVM "xcsv\fn_bountyBoard.sqf";
