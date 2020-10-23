 /*
 *
 * Author: Andrew_S90
 *
 * This work is protected by Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International (CC BY-NC-SA 4.0). 
 *
 */
	class Settings
	{
		BlockedItems[] = //Items that can not be offered up to barter with
		{
		};
	};
	
	class Barters
	{
		class Community //trader 0
		{
			class Binocular 
			{
				chance = 75; //75% to appear
				block_item = ""; //if the classname in here is already in the list - do NOT add this item
				min = 1;
				max = 3;
			};
			class H_Cap_blk 
			{
				chance = 50; 
				block_item = ""; 
				min = 1;
				max = 3;
			};
			class H_Cap_grn 
			{
				chance = 50; 
				block_item = "H_Cap_blk"; 
				min = 1;
				max = 3;
			};
			class U_BG_Guerilla3_1 
			{
				chance = 100; 
				block_item = ""; 
				min = 1;
				max = 1;
			};
			class U_I_C_Soldier_Bandit_2_F 
			{
				chance = 100; 
				block_item = ""; 
				min = 1;
				max = 1;
			};
			class ItemMap 
			{
				chance = 100; 
				block_item = ""; 
				min = 1;
				max = 1;
			};
			class ItemGPS 
			{
				chance = 5; 
				block_item = ""; 
				min = 1;
				max = 1;
			};
			class Exile_Item_Bandage 
			{
				chance = 100; 
				block_item = ""; 
				min = 3;
				max = 10;
			};
			class Exile_Item_CanOpener 
			{
				chance = 75; 
				block_item = ""; 
				min = 1;
				max = 1;
			};
			class Exile_Item_CookingPot 
			{
				chance = 80; 
				block_item = ""; 
				min = 1;
				max = 1;
			};
			class Exile_Item_CamoTentKit 
			{
				chance = 100; 
				block_item = ""; 
				min = 1;
				max = 3;
			};
			class Exile_Item_FuelCanisterEmpty 
			{
				chance = 90; 
				block_item = ""; 
				min = 1;
				max = 5;
			};
			class Exile_Item_Matches 
			{
				chance = 90; 
				block_item = ""; 
				min = 1;
				max = 2;
			};
		};
		
		class Weapons //trader 1
		{
			class Exile_Magazine_8Rnd_74Slug 
			{
				chance = 25; //25% to appear
				block_item = ""; //if the classname in here is already in the list - do NOT add this item
				min = 3;
				max = 6;
			};
			class 30Rnd_45ACP_Mag_SMG_01 
			{
				chance = 25; 
				block_item = ""; 
				min = 3;
				max = 5;
			};
			class 30Rnd_9x21_Mag_SMG_02 
			{
				chance = 25; 
				block_item = ""; 
				min = 3;
				max = 5;
			};
			class optic_Arco 
			{
				chance = 10; 
				block_item = ""; 
				min = 1;
				max = 2;
			};
			class optic_LRPS 
			{
				chance = 10; 
				block_item = ""; 
				min = 1;
				max = 2;
			};
			class 30Rnd_556x45_Stanag 
			{
				chance = 30; 
				block_item = ""; 
				min = 3;
				max = 10;
			};
			class 30Rnd_762x39_Mag_F 
			{
				chance = 30; 
				block_item = ""; 
				min = 3;
				max = 10;
			};
			class 30Rnd_762x39_AK47_M 
			{
				chance = 30; 
				block_item = ""; 
				min = 3;
				max = 10;
			};
			class 30Rnd_65x39_caseless_mag 
			{
				chance = 30; 
				block_item = ""; 
				min = 3;
				max = 10;
			};
		};
		
		class Hardware //trader 2
		{
			class Exile_Item_DuctTape 
			{
				chance = 100; //100% chance to appear
				block_item = ""; //if the classname in here is already in the list - do NOT add this item
				min = 1;
				max = 5;
			};
			
			class Exile_Item_JunkMetal 
			{
				chance = 100; 
				block_item = ""; 
				min = 1;
				max = 3;
			};
			
			class Exile_Item_MetalBoard 
			{
				chance = 100; 
				block_item = ""; 
				min = 1;
				max = 3;
			};
			
			class Exile_Item_SafeKit 
			{
				chance = 70; 
				block_item = ""; 
				min = 1;
				max = 1;
			};
		};
	};