/**
 * Created with Exile Mod 3DEN Plugin
 * www.exilemod.com
 * By Stefan, untriel.com
 */

if (!hasInterface || isServer) exitWith {};

// 21 NPCs
private _npcs = [
["Exile_Trader_Office", ["HubStandingUB_idle1","HubStandingUB_idle2","HubStandingUB_idle3","HubStandingUB_move1"], "Exile_Trader_Office", "WhiteHead_14", [[],[],[],["U_I_G_resistanceLeader_F",[]],["V_Rangemaster_belt",[]],[],"H_Hat_brown","G_Tactical_Clear",[],["","","","","",""]], [5641.13, 10387.9, 2.22445], [0.994699, -0.102827, 0], [0, 0, 1]],
["Exile_Trader_Vehicle", ["Acts_CivilListening_2"], "Exile_Trader_Vehicle", "WhiteHead_15", [[],[],[],["Exile_Uniform_ExileCustoms",[]],[],[],"H_RacingHelmet_4_F","",[],["","","","","",""]], [5657.72, 10400.8, 2.21144], [0.910323, -0.413899, 0], [0, 0, 1]],
["Exile_Trader_VehicleCustoms", ["HubStandingUB_idle1","HubStandingUB_idle2","HubStandingUB_idle3","HubStandingUB_move1"], "Exile_Trader_VehicleCustoms", "WhiteHead_04", [[],[],[],["Exile_Uniform_ExileCustoms",[]],[],[],"","G_Combat",[],["","","","","",""]], [5658.76, 10403.1, 2.21144], [0.924599, -0.380941, 0], [0, 0, 1]],
["Exile_Trader_WasteDump", ["Acts_CivilListening_2"], "Exile_Trader_WasteDump", "WhiteHead_18", [[],[],[],["U_I_G_Story_Protagonist_F",[]],["V_Rangemaster_belt",[]],[],"H_MilCap_gry","G_Combat",[],["","","","","",""]], [5667.19, 10430, 2.21144], [-0.310029, -0.950727, 0], [0, 0, 1]],
["Exile_Trader_Hardware", ["HubBriefing_loop"], "Exile_Trader_Hardware", "WhiteHead_04", [[],[],[],["U_C_WorkerCoveralls",[]],["V_BandollierB_rgr",[]],["B_UAV_01_backpack_F",[]],"H_Booniehat_khk_hs","",[],["","","","","",""]], [5642.24, 10380.8, 2.22544], [0.967374, -0.253353, 0], [0, 0, 1]],
["Exile_Trader_Food", ["Acts_CivilListening_2"], "Exile_Trader_Food", "AfricanHead_02", [[],[],[],["U_C_Poloshirt_blue",[]],[],[],"H_Cap_tan","G_Tactical_Clear",[],["","","","","",""]], [5640.21, 10385.6, 2.22491], [0.973459, -0.228861, 0], [0, 0, 1]],
["Exile_Trader_Equipment", ["HubStanding_idle1","HubStanding_idle2","HubStanding_idle3"], "Exile_Trader_Equipment", "AfricanHead_01", [["arifle_MX_GL_Black_F","","","",[],[],""],[],[],["U_BG_Guerrilla_6_1",[]],["V_I_G_resistanceLeader_F",[]],[],"H_Watchcap_khk","",[],["","","","","",""]], [5640.52, 10377.6, 2.22544], [0.957244, -0.289282, 0], [0, 0, 1]],
["Exile_Trader_Diving", ["AidlPsitMstpSnonWnonDnon_ground00"], "Exile_Trader_Diving", "WhiteHead_11", [["arifle_SDAR_F","","","",[],[],""],[],[],["U_I_Wetsuit",[]],["V_RebreatherIA",[]],[],"","G_I_Diving",[],["","","","","",""]], [5600.91, 10397.1, 0.350298], [0.842246, 0.539093, 0], [0, 0, 1]],
["Exile_Trader_Boat", ["c5efe_MichalLoop"], "Exile_Trader_Boat", "WhiteHead_21", [[],[],[],["U_OrestesBody",[]],[],[],"H_Cap_surfer","",[],["","","","","",""]], [5588.7, 10449, 0.00143886], [-0.860698, -0.509115, 0], [0, 0, 1]],
["Exile_Trader_BoatCustoms", ["UnaErcPoslechVelitele1","UnaErcPoslechVelitele2","UnaErcPoslechVelitele3","UnaErcPoslechVelitele4"], "Exile_Trader_BoatCustoms", "WhiteHead_16", [[],[],[],["Exile_Uniform_ExileCustoms",[]],[],[],"","G_Tactical_Clear",[],["","","","","",""]], [5586.88, 10450.4, 0.315175], [-0.616953, -0.787, 0], [0, 0, 1]],
["Exile_Trader_Armory", ["HubStanding_idle3","HubStanding_idle2","HubStanding_idle1"], "Exile_Trader_Armory", "WhiteHead_14", [["srifle_DMR_06_olive_F","","","",[],[],""],[],[],["U_Rangemaster",[]],["V_Rangemaster_belt",[]],[],"H_Cap_headphones","G_Shades_Black",[],["","","","","",""]], [5639.44, 10374.7, 2.22544], [0.945672, -0.325123, 0], [0, 0, 1]],
["Exile_Trader_WasteDump", ["Acts_CivilListening_2"], "Exile_Trader_WasteDump", "WhiteHead_03", [[],[],[],["U_I_G_Story_Protagonist_F",[]],["V_Rangemaster_belt",[]],[],"H_MilCap_gry","G_Combat",[],["","","","","",""]], [5568.78, 10440.9, 2.22768], [0.749268, 0.662267, 0], [0, 0, 1]],
["Exile_Guard_02", ["InBaseMoves_patrolling1"], "", "WhiteHead_18", [["arifle_Mk20_GL_F","","","",[],[],""],[],[],["U_BG_Guerilla1_1",[]],["V_PlateCarrierIA2_dgtl",[]],[],"H_Hat_camo","G_Tactical_Clear",[],["","","","","",""]], [5692.59, 10384.8, 2.74189], [0.78815, -0.615483, 0], [0, 0, 1]],
["Exile_Guard_03", ["InBaseMoves_patrolling2"], "", "WhiteHead_16", [["SMG_02_F","","","",[],[],""],[],[],["U_BG_Guerilla2_3",[]],["V_TacVestIR_blk",[]],[],"H_Bandanna_camo","G_Squares_Tinted",[],["","","","","",""]], [5681.3, 10422.7, 2.31861], [0, 1, 0], [0, 0, 1]],
["Exile_Guard_01", ["LHD_krajPaluby"], "", "WhiteHead_08", [["srifle_DMR_03_F","","","",[],[],""],[],[],["U_BG_Guerrilla_6_1",[]],["V_TacVest_khk",[]],[],"H_ShemagOpen_tan","G_Combat",[],["","","","","",""]], [5582.73, 10421, 2.22767], [-0.920204, -0.391438, 0], [0, 0, 1]],
["Exile_Guard_02", ["InBaseMoves_patrolling1"], "", "WhiteHead_16", [["arifle_Mk20_GL_F","","","",[],[],""],[],[],["U_BG_Guerilla1_1",[]],["V_PlateCarrierIA2_dgtl",[]],[],"H_Hat_camo","",[],["","","","","",""]], [5634.17, 10352.4, 6.78044], [0.299157, -0.954204, 0], [0, 0, 1]],
["Exile_Guard_02", ["InBaseMoves_patrolling1"], "", "WhiteHead_19", [["arifle_Mk20_GL_F","","","",[],[],""],[],[],["U_BG_Guerilla1_1",[]],["V_PlateCarrierIA2_dgtl",[]],[],"H_Hat_camo","G_Combat",[],["","","","","",""]], [5661.86, 10434.1, 6.65744], [0.784452, 0.62019, 0], [0, 0, 1]],
["Exile_Guard_03", ["AidlPsitMstpSnonWnonDnon_ground00"], "", "WhiteHead_14", [["SMG_02_F","","","",[],[],""],[],[],["U_BG_Guerilla2_3",[]],["V_TacVestIR_blk",[]],[],"H_Bandanna_camo","G_Squares_Tinted",[],["","","","","",""]], [5557.42, 10457.4, 2.23002], [-0.99649, 0.0837127, 0], [0, 0, 1]],
["Exile_Guard_02", ["InBaseMoves_patrolling2"], "", "WhiteHead_08", [["arifle_Mk20_GL_F","","","",[],[],""],[],[],["U_BG_Guerilla1_1",[]],["V_PlateCarrierIA2_dgtl",[]],[],"H_Hat_camo","G_Tactical_Clear",[],["","","","","",""]], [5686.65, 10373.2, 13.6943], [0.935135, 0.354291, 0], [0, 0, 1]],
["Exile_Guard_01", ["InBaseMoves_patrolling1"], "", "WhiteHead_10", [["srifle_DMR_03_F","","","",[],[],""],[],[],["U_BG_Guerrilla_6_1",[]],["V_TacVest_khk",[]],[],"H_ShemagOpen_tan","",[],["","","","","",""]], [5681.97, 10360.6, 13.69], [0.396123, -0.918198, 0], [0, 0, 1]],
["Exile_Guard_02", ["InBaseMoves_SittingRifle2"], "", "WhiteHead_18", [["arifle_Mk20_GL_F","","","",[],[],""],[],[],["U_BG_Guerilla1_1",[]],["V_PlateCarrierIA2_dgtl",[]],[],"H_Hat_camo","G_Combat",[],["","","","","",""]], [5648.89, 10345.6, 2.32041], [-0.465118, -0.885249, 0], [0, 0, 1]]
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