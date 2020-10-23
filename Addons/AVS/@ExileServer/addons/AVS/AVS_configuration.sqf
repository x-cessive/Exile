/*
© 2015 Zenix Gaming Ops
Developed by Rod-Serling and Vishpala

All rights reserved.

Function:
	AVS_configuration - Defines the configuration for AVS.
*/

// This array contains world center and radius for maps supported.
AVS_WorldInfo =
[
    ["Altis", [15350, 15350, 0], 15350],
    ["Esseker", [6150,6150,0], 6150],
    ["Chernarus", [7700,8500,0], 11000]
];

//**************************************************************

// Setting this to true will disable thermal for all vehicles.
AVS_DisableVehicleThermalGlobal = true;

// If the above is not set to true, then this will disable thermal for specific classes of vehicles.
AVS_DisableVehicleThermal =
[
//	"VehicleClassName"
];

// Setting this to true will disable NVGs for all vehicles.
AVS_DisableVehicleNVGsGlobal = false;

// If the above is not set to true, then this will disable thermal for specific classes of vehicles.
AVS_DisableVehicleNVG =
[
//	"VehicleClassName"
];

// Any weapon classes listed here will be sanitized from all vehicles.
AVS_GlobalWeaponBlacklist =
[
//	"WeaponClassName"
	"missiles_DAR" 				// Removes DAR missiles from all vehicles
];

// Any ammo classes listed here will be sanitized from all vehicles.
AVS_GlobalAmmoBlacklist =
[
//	"AmmoClassName"
	"24Rnd_missiles"
];

// You may remove specific weapon classes from specific vehicle classes here.
AVS_VehicleWeaponBlacklist =
[
//	["VehicleClassName", ["WeaponClassName1", "WeaponClassName2", ...]]
];

// You may remove specific ammo classes from specific vehicle classes here.
AVS_VehicleAmmoBlacklist =
[
//	["VehicleClassName", ["AmmoClassName1", "AmmoClassName2", ...]]
];

//**************************************************************

// Set to false to disable the entire rearm system.
AVS_RearmSystemActive = true;

// Distance away from an object to get the rearm option.
AVS_RearmDistance = 15;

// Number of seconds it takes to rearm. (NOT YET IMPLEMENTED)
AVS_RearmTime = 15;

// Objects of this type will give the "rearm" action.
AVS_RearmObjects =
[
//	"ClassName"
	"Land_fs_feed_F"	// Gas station pump.
];

// Default cost of a magazine if not found in AVS_RearmCosts
AVS_RearmCostDefault = 99999999;

// Costs of individual magazines.
AVS_RearmCosts =
[
//	["MagazineClassName", cost]
	["Laserbatteries", 0],						// Laser Designator Batteries
	["SmokeLauncherMag", 20],					// Smoke CM magazine
	["200Rnd_127x99_mag_Tracer_Yellow", 400],	// Strider HMG gun
	["200Rnd_127x99_mag_Tracer_Red", 400],		// Hunter HMG gun
	["168Rnd_CMFlare_Chaff_Magazine", 20],		// Helicopter flares
	["2000Rnd_65x39_Belt_Tracer_Red", 4000],	// Ghosthawk guns
	["100Rnd_127x99_mag_Tracer_Yellow", 200],	// Armed Offroad magazine.
	["5000Rnd_762x51_Belt", 1000]				// Pawnee belt
];

//**************************************************************

AVS_DebugMarkers = false;
AVS_PersistentVehiclesPinCode = "0000";
AVS_PersistentVehiclesAmmoPercent = 0;

//**************************************************************

AVS_useSpawnedPersistentVehiclesLocation = true;
AVS_LocationSearchRadius = 50;
AVS_spawnedPersistentVehiclesLocation =
[
	["RandomVehicles", ["I_MRAP_03_hmg_F", "B_Heli_Light_01_armed_F"], [0.1, 0.75], 5, [[14909.1,16462.8,0.00143814], [15086.6,16636.2,0.00144386]]],
	// OR
	["RandomHeli", ["B_Heli_Light_01_armed_F"], 0.25, 2, [[15186.8,16741.9,0.00143814]]]
];

//**************************************************************

AVS_useSpawnedPersistentVehiclesRoadside = false;
AVS_RoadSearchRadius = 200;
AVS_spawnedPersistentVehiclesRoadside =
[
	["UID", ["Class1", "Class2"], [0.1, 0.75], 5],
	// OR
	["UID", ["Class1", "Class2"], 0.25, 2]
];

//**************************************************************

AVS_useSpawnedPersistentVehiclesRandom = false;
AVS_spawnedPersistentVehiclesRandom =
[
	["UID", ["Class1", "Class2"], [0.1, 0.75], 5],
	// OR
	["UID", ["Class1", "Class2"], 0.25, 2]
];
