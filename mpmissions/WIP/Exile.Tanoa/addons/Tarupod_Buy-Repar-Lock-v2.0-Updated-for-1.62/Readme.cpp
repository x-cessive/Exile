/*
Created by crackerjack0903
Donate-paypal:https://www.paypal.com/us/cgi-bin/webscr?cmd=_flow&SESSION=Qtgzd1W6CuRn6zaCrZ1IqAXTn_C4vU9qu79VtjpmDvc4BP4pkpjrUlYHwcm&dispatch=5885d80a13c0db1f8e263663d3faee8d64813b57e559a2578463e58274899069
or donate to tftgamingmsg@gmail.com
Thank you for your support.
*/

// #1 Add the tarupodrepair folder inside of your addons folder in you mpmissions folder.

// #2 Add overwrites folder to the root of your mpmissions folder.

// #3 Add to "class CfgExileCustomCode"
//Taru Pods
	ExileClient_system_trading_network_purchaseVehicleResponse = "overwrites\ExileClient_system_trading_network_purchaseVehicleResponse.sqf";


//////////////////--ADD ALL OF THE FOLLOWING INSIDE OF YOUR config.cpp file in your mpmissions folder--//////////////////
// #4 Add Price configuration
	///////////////////////////////////////////////////////////////////////////////
    // Camo Taru Pods
    ///////////////////////////////////////////////////////////////////////////////  //added All PODS
    class Land_Pod_Heli_Transport_04_covered_F              { quality = 1; price = 10000; };
    class Land_Pod_Heli_Transport_04_fuel_F                 { quality = 1; price = 15000; };
    class Land_Pod_Heli_Transport_04_box_F                  { quality = 1; price = 15000; };
    class Land_Pod_Heli_Transport_04_repair_F               { quality = 1; price = 12000; };
    class Land_Pod_Heli_Transport_04_medevac_F              { quality = 1; price = 12000; };
    class Land_Pod_Heli_Transport_04_bench_F                { quality = 1; price = 11000; };
	class Land_Pod_Heli_Transport_04_ammo_F					{ quality = 1; price = 200000; };





// #5 Add Class PODS below class cars
class PODS 
	{
		targetType = 2;
		target = "StaticWeapon";

		class Actions 
		{
			class ScanLock: ExileAbstractAction
			{
				title = "Scan Lock";
				condition = "('Exile_Item_ThermalScannerPro' in (magazines player)) && !ExilePlayerInSafezone && ((locked ExileClientInteractionObject) != 1)";
				action = "_this call ExileClient_object_lock_scan";
			};

			// Locks a vehicle
			class Lock: ExileAbstractAction
			{
				title = "Lock";
				condition = "((locked ExileClientInteractionObject) isEqualTo 0) && ((locked ExileClientInteractionObject) != 1)";
				action = "true spawn ExileClient_object_lock_toggle";
			};

			// Unlocks a vehicle
			class Unlock: ExileAbstractAction
			{
				title = "Unlock";
				condition = "((locked ExileClientInteractionObject) isEqualTo 2) && ((locked ExileClientInteractionObject) != 1)";
				action = "false spawn ExileClient_object_lock_toggle";
			};

			// Repairs a vehicle to 100%. Requires Duckttape
			class Repair: ExileAbstractAction
			{
				title = "Repair";
				condition = "call ExileClient_object_vehicle_interaction_show";
				action = "execVM 'addons\tarupodrepair\tarupodrepair.sqf';"; //this is why you DO NOT have to call this file from your init.sqf
			};
			
			// Flips a vehicle so the player doesnt have to call an admin.
			// Check if vector up is all messed up.
			class Flip: ExileAbstractAction
			{
				title = "Flip";
				condition = "call ExileClient_object_vehicle_interaction_show";
				action = "_this call ExileClient_object_vehicle_flip";
			};
		};
	};
	
// #6 Add class TaruPods below class Choppers

class TaruPods //added
	{ 
		name = "Taru Pods";
		icon = "a3\ui_f\data\gui\Rsc\RscDisplayArsenal\itemacc_ca.paa";
		items[] = 
		{
			"Land_Pod_Heli_Transport_04_covered_F",
			"Land_Pod_Heli_Transport_04_fuel_F",
			"Land_Pod_Heli_Transport_04_box_F",
			"Land_Pod_Heli_Transport_04_repair_F",
			"Land_Pod_Heli_Transport_04_medevac_F",
			"Land_Pod_Heli_Transport_04_bench_F",
			"Land_Pod_Heli_Transport_04_ammo_F"
		};
	};

// #7 Add TaruPods class to the trader config just search class "Exile_Trader_Aircraft"
	/**
	 * Sells choppers and planes
	 */
	class Exile_Trader_Aircraft
	{
		name = "AIRCRAFT";
		showWeaponFilter = 0;
		categories[] = 
		{
			"Choppers", 
			"Planes",
			"TaruPods" //added
		};
	};