/*
	///////////////////////////////////////////////////////////////////////////////
	// Class Names
	///////////////////////////////////////////////////////////////////////////////

	Remember that item class names, group names and loot table names cannot 
	contain spaces. Also be 100% sure to have the exact same name as in Arma,
	as they are *case sensive*.

	///////////////////////////////////////////////////////////////////////////////
	// Item Groups
	///////////////////////////////////////////////////////////////////////////////

	You can link one group of items to loot tables.
	One item should only be in one group.

	Syntax:
	> <Group Name>
	<Spawn Chance Within Group>,<Item Class Name>

	///////////////////////////////////////////////////////////////////////////////
	// Propability
	///////////////////////////////////////////////////////////////////////////////

	<Spawn Chance>,<Item>

	10, Banana
	20, Tomato
	30, Cherry

	Sum of chances:
	10 + 20 + 30 = 60 = 100%

	Spawn chances:
	Banana	10 : 60 = 10 * 100 / 60 = 16.67%
	Tomato	20 : 60 = 20 * 100 / 60 = 33.33%
	Cherry	30 : 60 = 30 * 100 / 60 = 50%

	In words: 
	If Exile should spawn an item of the above group, it has a 33.33%
	chance to spawn a Tomato.
*/
	
/*
	Item Groups
*/

///////////////////////////////////////////////////////////////////////////////
// Food & Drinks
///////////////////////////////////////////////////////////////////////////////

> Food
3, Exile_Item_CookingPot
5, Exile_Item_CanOpener
5, Exile_Item_Matches
3, Exile_Item_EMRE						// 75% Hunger
6, Exile_Item_GloriousKnakworst			// 60% Hunger
7, Exile_Item_Surstromming				// 55% Hunger
7, Exile_Item_SausageGravy				// 50% Hunger
7, Exile_Item_ChristmasTinner			// 40% Hunger
7, Exile_Item_BBQSandwich				// 40% Hunger
7, Exile_Item_CatFood					// 40% Hunger
7, Exile_Item_Dogfood					// 30% Hunger
7, Exile_Item_BeefParts					// 30% Hunger
7, Exile_Item_Cheathas					// 30% Hunger
7, Exile_Item_Noodles					// 25% Hunger
8, Exile_Item_SeedAstics				// 20% Hunger
9, Exile_Item_Raisins					// 15% Hunger
9, Exile_Item_Moobar					// 10% Hunger
11, Exile_Item_InstantCoffee			//  5% Hunger

> Drinks
7, Exile_Item_PowerDrink					// +95% Thirst
12, Exile_Item_PlasticBottleFreshWater		// +80% Thirst
14, Exile_Item_Beer							// +75% Thirst
17, Exile_Item_EnergyDrink					// +75% Thirst
20, Exile_Item_MountainDupe					// +50% Thirst, spawns always twice!	
30, Exile_Item_PlasticBottleDirtyWater		// +10% Thirst


///////////////////////////////////////////////////////////////////////////////
// Weapons & Attachments
///////////////////////////////////////////////////////////////////////////////

> Pistols
20, hgun_ACPC2_F			// ACP-C2 .45
21, hgun_P07_F				// P07 9 mm
20, hgun_Rook40_F			// Rook-40 9 mm
13, hgun_Pistol_heavy_01_F	// 4-five .45
13, hgun_Pistol_heavy_02_F	// Zubr .45
13, hgun_Pistol_Signal_F	// Starter Pistol

> PistolAmmo
20, 11Rnd_45ACP_Mag			// 4-five
10, 16Rnd_9x21_Mag			// PDW2000, P07, ROOK-40
20, 30Rnd_9x21_Mag			// Sting, PDW2000, P07, ROOK-40
16, 6Rnd_45ACP_Cylinder		// Zubr
7, 6Rnd_GreenSignal_F		// Starter Pistol
7, 6Rnd_RedSignal_F			// Starter Pistol 
20, 9Rnd_45ACP_Mag			// ACP-C2

> PistolAttachments
36, muzzle_snds_L
36, muzzle_snds_acp
14, optic_Yorris		// No one needs this crap
14, optic_MRD

> SMG
34, SMG_01_F		// Vermin SMG .45 ACP
33, SMG_02_F		// Sting 9 mm
33, hgun_PDW2000_F	// PDW2000 9 mm

> SMGAmmo
50, 30Rnd_45ACP_Mag_SMG_01					// Vermin SMG
50, 30Rnd_45ACP_Mag_SMG_01_Tracer_Green		// Vermin SMG

> SMGAttachments
20, optic_Holosight_smg
20, optic_ACO_grn_smg
20, optic_Aco_smg
20, optic_ACO_grn
20, optic_Aco

> Rifles
10, arifle_Katiba_F			// Katiba 6.5 mm
8, arifle_Katiba_GL_F		// Katiba GL 6.5 mm
8, arifle_MXC_F				// MXC 6.5 mm
8, arifle_MX_F				// MX 6.5 mm
4, arifle_MX_GL_F			// MX 3GL 6.5 mm
6, arifle_MXM_F				// MXM 6.5 mm
3, arifle_MXM_Black_F		// MXM 6.5 mm (Black)
6, arifle_SDAR_F			// SDAR 5.56 mm
8, arifle_TRG21_F			// TRG-21 5.56 mm
8, arifle_TRG20_F			// TRG-20 5.56 mm
4, arifle_TRG21_GL_F		// TRG-21 EGLM 5.56 mm
7, arifle_Mk20_F			// Mk20 5.56 mm
7, arifle_Mk20C_F			// Mk20C 5.56 mm
4, arifle_Mk20_GL_F			// Mk20 EGLM 5.56 mm
3, arifle_MXC_Black_F		// MXC 6.5 mm (Black)
3, arifle_MX_Black_F		// MX 6.5 mm (Black)
3, arifle_MX_GL_Black_F		// MX 3GL 6.5 mm (Black)

> RifleAmmo
11, 20Rnd_556x45_UW_mag						// SDAR
15, 30Rnd_556x45_Stanag						// TRG-20, TRG-21/EGLM, Mk20/C/EGLM, SDAR
9, 30Rnd_556x45_Stanag_Tracer_Green			// TRG-20, TRG-21/EGLM, Mk20/C/EGLM, SDAR
9, 30Rnd_556x45_Stanag_Tracer_Red			// TRG-20, TRG-21/EGLM, Mk20/C/EGLM, SDAR
9, 30Rnd_556x45_Stanag_Tracer_Yellow		// TRG-20, TRG-21/EGLM, Mk20/C/EGLM, SDAR
15, 30Rnd_65x39_caseless_green				// Katiba
9, 30Rnd_65x39_caseless_green_mag_Tracer	// Katiba
9, 30Rnd_65x39_caseless_mag					// MX/C/M/SW/3GL
9, 30Rnd_65x39_caseless_mag_Tracer			// MX/C/M/SW/3GL

> RifleAttachments
10, muzzle_snds_M
10, muzzle_snds_H
10, optic_Arco
10, optic_Hamr
10, optic_Holosight
14, acc_flashlight
10, acc_pointer_IR
10, optic_MRCO
10, optic_DMS
5, optic_NVS
1, optic_tws

> LMG
25, arifle_MX_SW_Black_F	// MX SW 6.5 mm (Black)
25, arifle_MX_SW_F			// MX SW 6.5 mm
25, LMG_Mk200_F				// Mk200 6.5 mm
25, LMG_Zafir_F				// Zafir 7.62 mm

> LMGAmmo
12, 100Rnd_65x39_caseless_mag			// MX SW
10, 100Rnd_65x39_caseless_mag_Tracer	// MX SW
12, 150Rnd_762x54_Box					// Zafir
10, 150Rnd_762x54_Box_Tracer			// Zafir
5, 130Rnd_338_Mag
51, 150Rnd_93x64_Mag
//10, 200Rnd_65x39_Belt					// Mk200
//10, 200Rnd_65x39_Belt_Tracer_Green	// Mk200
//10, 200Rnd_65x39_Belt_Tracer_Red		// Mk200
//10, 200Rnd_65x39_Belt_Tracer_Yellow	// Mk200

> Snipers
28, srifle_DMR_01_F			// Rahim 7.62 mm
28, srifle_EBR_F			// Mk18 ABR 7.62 mm
22, srifle_GM6_F			// GM6 Lynx 12.7 mm
22, srifle_LRR_F			// M320 LRR .408

> SniperAmmo
17, 5Rnd_127x108_Mag		// GM6 Lynx
17, 7Rnd_408_Mag			// M320 LRR
28, 10Rnd_762x51_Mag		// Rahim
28, 20Rnd_762x51_Mag		// Mk18 ABR
10, 5Rnd_127x108_APDS_Mag	// GM6 Lynx 

> SniperAttachments
19, muzzle_snds_B
//1, optic_tws
//1, optic_tws_mg
27, optic_DMS
26, optic_SOS
26, optic_LRPS

> DLCRifles
// To overpowered. Do not use in vanilla Exile
//4, MMG_01_hex_F				//Navid
//4, MMG_01_tan_F				//Navid
//6, MMG_02_black_F				//SPMG
//6, MMG_02_camo_F				//SPMG
//6, MMG_02_sand_F				//SPMG
6, srifle_DMR_02_camo_F			//MAR10
6, srifle_DMR_02_F				//MAR10
6, srifle_DMR_02_sniper_F		//MAR10
3, srifle_DMR_03_F				//MK1EMR
3, srifle_DMR_03_khaki_F		//MK1EMR
3, srifle_DMR_03_tan_F			//MK1EMR
3, srifle_DMR_03_woodland_F		//MK1EMR
7, srifle_DMR_04_F				//ASP1KIR
7, srifle_DMR_04_Tan_F			//ASP1KIR
8, srifle_DMR_05_blk_F			//CYRUS
8, srifle_DMR_05_hex_F			//CYRUS
8, srifle_DMR_05_tan_F			//CYRUS
3, srifle_DMR_06_camo_F			//Mk14
3, srifle_DMR_06_olive_F		//Mk14

> DLCAmmo
//18, 150Rnd_93x64_Mag		//Navid
//25, 130Rnd_338_Mag			//SPMG
16, 10Rnd_338_Mag			//MAR10
11, 20Rnd_762x51_Mag		//MK1EMR
14, 10Rnd_127x54_Mag		//ASP1KIR
16, 10Rnd_93x64_DMR_05_Mag	//CYRUS

> DLCOptics
14, optic_AMS
14, optic_AMS_khk
14, optic_AMS_snd
14, optic_KHS_blk
14, optic_KHS_hex
14, optic_KHS_old
14, optic_KHS_tan

> DLCSupressor
40, muzzle_snds_338_black
40, muzzle_snds_338_green
40, muzzle_snds_338_sand
40, muzzle_snds_93mmg
40, muzzle_snds_93mmg_tan
40, muzzle_snds_B

> Bipods
17, bipod_03_F_oli
17, bipod_03_F_blk
17, bipod_02_F_tan
16, bipod_02_F_hex
17, bipod_02_F_blk
17, bipod_01_F_snd
16, bipod_01_F_mtp
17, bipod_01_F_blk

> HEGrenades
67, 1Rnd_HE_Grenade_shell
33, 3Rnd_HE_Grenade_shell

> UGLFlares
8, 3Rnd_UGL_FlareGreen_F
8, 3Rnd_UGL_FlareRed_F
8, 3Rnd_UGL_FlareWhite_F
8, 3Rnd_UGL_FlareYellow_F
17, UGL_FlareGreen_F
17, UGL_FlareRed_F
17, UGL_FlareWhite_F
17, UGL_FlareYellow_F
// No Infrared for now
//UGL_FlareCIR_F
//3Rnd_UGL_FlareCIR_F

> UGLSmokes
10, 1Rnd_Smoke_Grenade_shell
10, 1Rnd_SmokeBlue_Grenade_shell
10, 1Rnd_SmokeGreen_Grenade_shell
10, 1Rnd_SmokeOrange_Grenade_shell
10, 1Rnd_SmokePurple_Grenade_shell
10, 1Rnd_SmokeRed_Grenade_shell
10, 1Rnd_SmokeYellow_Grenade_shell
4, 3Rnd_Smoke_Grenade_shell
4, 3Rnd_SmokeBlue_Grenade_shell
4, 3Rnd_SmokeGreen_Grenade_shell
4, 3Rnd_SmokeOrange_Grenade_shell
4, 3Rnd_SmokePurple_Grenade_shell
4, 3Rnd_SmokeRed_Grenade_shell
4, 3Rnd_SmokeYellow_Grenade_shell

> HandGrenades
50, HandGrenade
50, MiniGrenade

> Explosives
12, DemoCharge_Remote_Mag
12, IEDUrbanSmall_Remote_Mag
12, IEDLandSmall_Remote_Mag
20, APERSMine_Range_Mag
20, APERSBoundingMine_Range_Mag
20, APERSTripMine_Wire_Mag
4, SatchelCharge_Remote_Mag

///////////////////////////////////////////////////////////////////////////////
// Clothing & Gear
///////////////////////////////////////////////////////////////////////////////

//Civilian

> CivilianItems
30, ItemWatch
30, ItemRadio
20, ItemGPS
20, Binocular

> CivilianClothing
9, U_C_Poor_1
9, U_C_Poor_2
9, U_C_Poor_shorts_1
9, U_C_HunterBody_grn
7, U_C_Poloshirt_salmon
7, U_C_Poloshirt_tricolour
7, U_C_Poloshirt_stripped
7, U_C_Poloshirt_burgundy
7, U_C_Poloshirt_blue
9, U_C_Journalist
9, U_C_Scientist
9, U_Rangemaster
1, U_OrestesBody
1, U_NikosBody
1, U_NikosAgedBody

> CivilianBackpacks
10, B_OutdoorPack_blk
9, B_OutdoorPack_tan
9, B_OutdoorPack_blu
8, B_HuntingBackpack
7, B_AssaultPack_khk
7, B_AssaultPack_dgtl
7, B_AssaultPack_rgr
7, B_AssaultPack_sgg
7, B_AssaultPack_blk
7, B_AssaultPack_cbr
7, B_AssaultPack_mcamo
5, B_Kitbag_mcamo
5, B_Kitbag_sgg
5, B_Kitbag_cbr

> CivilianVests
50, V_Rangemaster_belt
25, V_Press_F
25, V_TacVest_blk_POLICE

> CivilianHeadgear
5, H_Bandanna_surfer
5, H_Beret_blk_POLICE
5, H_Cap_blk
5, H_Cap_blk_Raven
5, H_Cap_blu
5, H_Cap_grn
5, H_Cap_headphones
5, H_Cap_oli
6, H_Cap_press
6, H_Cap_red
6, H_Cap_tan
6, H_Hat_blue
6, H_Hat_brown
6, H_Hat_checker
6, H_Hat_grey
6, H_Hat_tan
6, H_StrawHat
6, H_StrawHat_dark

//Guerilla

> GuerillaItems
25, Rangefinder
25, NVGoggles
50, ItemCompass

> GuerillaClothing
16, U_IG_Guerilla1_1
16, U_IG_Guerilla2_1
16, U_IG_Guerilla2_2
16, U_IG_Guerilla2_3
15, U_IG_Guerilla3_1
15, U_IG_Guerilla3_2
4, U_IG_leader
2, U_I_G_resistanceLeader_F

> GuerillaBackpacks
14, B_FieldPack_blk
14, B_FieldPack_ocamo
14, B_FieldPack_oucamo
14, B_FieldPack_cbr
11, B_Bergen_sgg
11, B_Bergen_mcamo
11, B_Bergen_rgr
11, B_Bergen_blk

> GuerillaVests
7, V_BandollierB_khk
7, V_BandollierB_cbr
7, V_BandollierB_rgr
7, V_BandollierB_blk
7, V_BandollierB_oli
5, V_Chestrig_khk
5, V_Chestrig_rgr
5, V_Chestrig_blk
5, V_Chestrig_oli
7, V_HarnessO_brn
7, V_HarnessOGL_brn
7, V_HarnessO_gry
7, V_HarnessOGL_gry
7, V_HarnessOSpec_brn
7, V_HarnessOSpec_gry
3, V_I_G_resistanceLeader_F

> GuerillaHeadgear
4, H_Booniehat_khk
4, H_Booniehat_indp
4, H_Booniehat_mcamo
4, H_Booniehat_grn
4, H_Booniehat_tan
4, H_Booniehat_dirty
4, H_Booniehat_dgtl
4, H_Booniehat_khk_hs
3, H_Bandanna_khk
3, H_Bandanna_khk_hs
3, H_Bandanna_cbr
3, H_Bandanna_sgg
3, H_Bandanna_gry
3, H_Bandanna_camo
3, H_Bandanna_mcamo
3, H_BandMask_blk
1, H_Beret_blk
1, H_Beret_red
1, H_Beret_grn
1, H_Beret_grn_SF
1, H_Beret_brn_SF
1, H_Beret_ocamo
1, H_Beret_02
1, H_Beret_Colonel
3, H_Hat_camo
3, H_Cap_brn_SPECOPS
3, H_Cap_tan_specops_US
3, H_Cap_khaki_specops_UK
3, H_Watchcap_blk
3, H_Watchcap_khk
2, H_Watchcap_camo
2, H_Watchcap_sgg
2, H_TurbanO_blk
2, H_Shemag_khk
2, H_Shemag_tan
2, H_Shemag_olive
2, H_Shemag_olive_hs
2, H_ShemagOpen_khk
2, H_ShemagOpen_tan

//Military

> MilitaryItems
100, Laserdesignator

> MilitaryClothing
7, U_B_CTRG_1						// CTRG Combat Uniform (UBACS)
7, U_B_CTRG_2						// CTRG Combat Uniform (UBACS2)
7, U_B_CTRG_3						// CTRG Combat Uniform (Tee)
5, U_B_CombatUniform_mcam			// Combat Fatigues (MTP)
7, U_B_CombatUniform_mcam_tshirt	// Combat Fatigues (MTP) (Tee)
7, U_B_CombatUniform_mcam_vest		// Recon Fatigues (MTP)
7, U_B_CombatUniform_mcam_worn		// Worn Combat Fatigues (MTP)
3, U_B_SpecopsUniform_sgg			// Specop Fatigues (Sage)
2, U_O_OfficerUniform_ocamo			// Officer Fatigues (Hex)
2, U_I_OfficerUniform				// Combat Fatigues [AAF] (Tee)
4, U_I_CombatUniform				// Combat Fatigues [AAF]
4, U_I_CombatUniform_tshirt			// Combat Fatigues [AAF] (Tee)
4, U_I_CombatUniform_shortsleeve	// Combat Fatigues [AAF]
4, U_B_HeliPilotCoveralls			// Heli Pilot Coveralls
4, U_O_PilotCoveralls				// Pilot Coveralls [CSAT]
4, U_B_PilotCoveralls				// Pilot Coveralls [NATO]
4, U_I_pilotCoveralls				// Pilot Coveralls [AAF]
4, U_I_HeliPilotCoveralls			// Heli Pilot Coveralls
2, U_B_Wetsuit						// Wetsuit [NATO]
2, U_O_Wetsuit						// Wetsuit [CSAT]
2, U_I_Wetsuit						// Wetsuit [AAF]
2, U_O_CombatUniform_ocamo			// Heli Pilot Coveralls
2, U_O_CombatUniform_oucamo			// Fatigues (Urban) [CSAT]
2, U_O_SpecopsUniform_ocamo			// Recon Fatigues (Hex)
2, U_O_SpecopsUniform_blk			// Recon Fatigues (Black)

> MilitaryBackpacks
15, B_Carryall_ocamo
15, B_Carryall_oucamo
15, B_Carryall_mcamo
18, B_Carryall_oli
18, B_Carryall_khk
19, B_Carryall_cbr

> MilitaryVests
10, V_PlateCarrier1_blk
10, V_PlateCarrier1_rgr
10, V_PlateCarrier2_rgr
10, V_PlateCarrier3_rgr
10, V_PlateCarrierGL_rgr
10, V_PlateCarrierIA1_dgtl
10, V_PlateCarrierIA2_dgtl
10, V_PlateCarrierIAGL_dgtl
10, V_PlateCarrierSpec_rgr
5, V_PlateCarrierL_CTRG
5, V_PlateCarrierH_CTRG

> MilitaryHeadgear
4, H_MilCap_ocamo
4, H_MilCap_mcamo
4, H_MilCap_oucamo
4, H_MilCap_blue
4, H_MilCap_rucamo
4, H_MilCap_dgtl
3, H_HelmetB
3, H_HelmetB_paint
3, H_HelmetB_light
3, H_HelmetB_plain_blk
3, H_HelmetSpecB
3, H_HelmetSpecB_paint1
3, H_HelmetSpecB_paint2
3, H_HelmetSpecB_blk
3, H_HelmetIA
2, H_HelmetIA_net
2, H_HelmetIA_camo
2, H_HelmetB_grass
2, H_HelmetB_snakeskin
2, H_HelmetB_desert
2, H_HelmetB_black
2, H_HelmetB_sand
2, H_HelmetB_light_grass
2, H_HelmetB_light_snakeskin
2, H_HelmetB_light_desert
2, H_HelmetB_light_black
2, H_HelmetB_light_sand
1, H_HelmetCrew_B
1, H_HelmetCrew_O
1, H_HelmetCrew_I
1, H_PilotHelmetFighter_B
1, H_PilotHelmetFighter_O
1, H_PilotHelmetFighter_I
1, H_PilotHelmetHeli_B
1, H_PilotHelmetHeli_O
1, H_PilotHelmetHeli_I
1, H_HelmetB_camo
1, H_CrewHelmetHeli_B
1, H_CrewHelmetHeli_O
1, H_CrewHelmetHeli_I
2, H_BandMask_khk
2, H_BandMask_reaper
2, H_BandMask_demon
1, H_HelmetO_oucamo
1, H_HelmetLeaderO_oucamo
1, H_HelmetSpecO_ocamo
1, H_HelmetSpecO_blk
1, H_HelmetO_ocamo
1, H_HelmetLeaderO_ocamo

> Ghillies
33, U_B_GhillieSuit			// Ghillie Suit [NATO]
33, U_O_GhillieSuit			// Ghillie Suit [CSAT]
34, U_I_GhillieSuit			// Ghillie Suit [AAF]

> DLCGhillies
11, U_B_FullGhillie_ard		
11, U_B_FullGhillie_lsh
11, U_B_FullGhillie_sard
11, U_O_FullGhillie_ard
11, U_O_FullGhillie_lsh
11, U_O_FullGhillie_sard
11, U_I_FullGhillie_ard
11, U_I_FullGhillie_lsh
12, U_I_FullGhillie_sard

> DLCVests
12, V_PlateCarrierGL_blk
12, V_PlateCarrierGL_mtp
12, V_PlateCarrierGL_rgr
12, V_PlateCarrierIAGL_dgtl
12, V_PlateCarrierIAGL_oli
13, V_PlateCarrierSpec_blk
13, V_PlateCarrierSpec_mtp
14, V_PlateCarrierSpec_rgr

> Rebreathers
33, V_RebreatherB
33, V_RebreatherIR
34, V_RebreatherIA

///////////////////////////////////////////////////////////////////////////////
// Other Items
///////////////////////////////////////////////////////////////////////////////

> MedicalItems
2, Exile_Item_InstaDoc
5, Exile_Item_Bandage
10, Exile_Item_Vishpirin

> IndustrialItems
1, Exile_Item_ThermalScannerPro
3, Exile_Item_FloodLightKit
3, Exile_Item_PortableGeneratorKit
4, Exile_Item_MetalBoard
11, Exile_Item_JunkMetal
13, Exile_Item_ExtensionCord
4, Exile_Item_Rope
9, Exile_Item_LightBulb
13, Exile_Item_Handsaw
13, Exile_Item_Pliers
22, Exile_Melee_Axe
4, Exile_Item_CamoTentKit

> Vehicle
40, Exile_Item_FuelCanisterFull
50, Exile_Item_FuelCanisterEmpty
10, Exile_Item_DuctTape

// Throwables

> Chemlights
25, Chemlight_blue
25, Chemlight_green
25, Chemlight_red
25, Chemlight_yellow

> RoadFlares
25, FlareGreen_F
25, FlareRed_F
25, FlareWhite_F
25, FlareYellow_F

> SmokeGrenades
14, SmokeShell
14, SmokeShellRed
14, SmokeShellGreen
14, SmokeShellYellow
14, SmokeShellPurple
15, SmokeShellBlue
15, SmokeShellOrange

> Restraints
100, Exile_Item_ZipTie

> Electronics
20, Exile_Item_Laptop
80, Exile_Item_BaseCameraKit

 // Trash or items not currently being used

> Trash
10, Exile_Item_Can_Empty
10, Exile_Item_ToiletPaper
10, Exile_Item_PlasticBottleEmpty			// Nothing :)

> Unused
3, Exile_Item_CordlessScrewdriver
3, Exile_Item_FireExtinguisher
7, Exile_Item_Foolbox
7, Exile_Item_Grinder
7, Exile_Item_Screwdriver
10, Exile_Item_OilCanister
14, Exile_Item_Hammer
14, Exile_Item_Shovel
17, Exile_Item_Screws
3, Exile_Item_Cement
5, Exile_Item_Sand
5, Exile_Item_Carwheel
5, Exile_Item_SleepingMat
5, Exile_Item_Defibrillator
5, Exile_Item_Wrench