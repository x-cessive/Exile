
Autor: Freakylein a BIG Thank to Firefox because he supported me all the way!!!  And all others who told me some Bugs :)

Extended Base Mod for Exile Mod

I just took some codes from the Exile Mod.
This content belongs complete to the Exile Mod Team! I Just combined some things :)
Well guys, this mod allows you to build some fortifications from the original Arma 3
in your own Territory.

INSTALLATION:

First insert the Battleyefilter out of the "Battleye filter.txt" in the folder!!
///////////////////////////////////////////////////////////////////////////////////////////////////////
put the folder "@Extended_Base_Mod" in your default Arma 3. It should be where your Steam is located.
Steam -> steamapps -> common -> arma 3 -> paste it here.
Then add "-mod=@Extended_Base_Mod" to the startup Parameters.

Copy the "Extended_Base_Mod\keys\ExtendedBase2.9.bikey" into your "keys" folder. Then delete the old key.
///////////////////////////////////////////////////////////////////////////////////////////////////////
Copy the folder called "EBM" in your Mission Exile.Altis.pbo", then viel all files to fit your Server.
Add the following line at the top of the CfgCraftingRecipes inside your config.cpp of your mission:
#include "EBM\recipes.hpp" 

Add the following line at the top of the CfgInteractionMenus inside your config.cpp too:
#include "EBM\menus.hpp"

Add the following line at the top of the CfgTraderCategories inside your config.cpp too:
#include "EBM\traders.hpp"

Add the following line at the top of the CfgExileArsenal inside your config.cpp of your mission:
#include "EBM\prices.hpp"

if you got problems, there is a Example Folder ;)
///////////////////////////////////////////////////////////////////////////////////////////////////////
Locate the class Exile_Trader_Hardware and add "ExtendedBaseMod",
  
  	class Exile_Trader_Hardware
	{
		name = "HARDWARE";
		showWeaponFilter = 0;
		categories[] = 
		{
			"Hardware",
			"ExtendedBaseMod", //added new
			"Tools"
		};
	};
///////////////////////////////////////////////////////////////////////////////////////////////////////
to make the Lootspawn in the Buildings working you have to add the following line:

exileclient_system_lootmanager_thread_spawn = "EBM\exileclient_system_lootmanager_thread_spawn.sqf";
exileServer_object_construction_database_load = "EBM\exileServer_object_construction_database_load.sqf"; //Original fix by Eichi

to "CfgExileCustomCode" in your config.cpp in your mission.pbo.
///////////////////////////////////////////////////////////////////////////////////////////////////////

Check all the .txt for some changes! Or the Mod will not work correctly.
!!!! Try the alternative receips and tradervalues from MrD !!!!   -Thank you for creating these ones!

To make the Watersink working define the the config.cpp in your Missionfolder like this
look for "WaterSource"


class WaterSource
	{
		name = "Water tanks, barrels, coolers or pumps";
		models[] = 	
		{
			"barrelwater_f", 
			"barrelwater_grey_f",
			"waterbarrel_f",
			"watertank_f",
			"Tank_rust_F",// added new
			"Sink_F",// added new
			"Slingload_01_Fuel_F",// added new
			"stallwater_f",
			"waterpump_01_f",
			"water_source_f",
		};
		

//////////////////////////////////////////////////
// DO not do this - because APEX is disabled!!!	//	
//////////////////////////////////////////////////
To enable APEX buildings you simply go to the "prices.hpp", "traders.hpp" and the "recipes.hpp
and you have to remove the // in the line
//#define USE_APEX_Buildings 1



///////////////////////////////////////////////////////////////////////////////////////////////////////
UPDATING:

When you guys are updating pls follow this instructions:
1. delete the whole "@Extended_Base_Mod" folder on your server
2. remove the ExtendedBase2.8.bikey in the keys folder
3. Then go to your Database and delete all the APEX stuff. (only if you update from 2.8 to 2.9)
4. Copy the new "@Extended_Base_Mod" folder from the one you downloaded to the root of your server
5. Copy the ExtendedBase2.9.bikey to your keys folder
6. Update your recipes.hpp, menus.hpp, traders.hpp, prices.hpp in your missionfile (highly recommended!!!)

///////////////////////////////////////////////////////////////////////////////////////////////////////



changelog:

V 0.3.0
- Huge Lamp illmination fixed
- doors fixed (original by Eichi)
- certain apex buildings available

V 0.2.9
- Guys i am very sorry, but i had to remove the APEX buildings. Arma fucked it up :/
- fixed the damagetaking problem on earthquakes and explosives. (Breaching charges still work)

V 0.2.8
- new Buildables: Airporthangar (Apex), Ammobox, Basaltwall 4m & 8m and Gate (Apex), Breakwater dry & wet (Apex), Huron ammo- and fuelcontainer, IR tent big & small (Apex), Petroglyphwall 1 & 2 (Apex), sandbags green long & short (Apex), Sandbagbunker big green (Apex), Sandbagtower green (Apex), Suitcase 
- all new walls with snap points 
- fixed the light of the Shabby Lamp and the Camping Lamp
- fixed the height jump of the Pierbox & Airplanehangar

V 0.2.7
- new Buildables: Bungalow, House Big, Plastic crate, Researchfacility big and small, Garage Shelter (Apex)

V 0.2.6
- new Buildables: Big Bunker, Bunker Rectangle, Bunker Hexagonal, Bagbunker small green, Bunkerwall 3m
				  Bunkerwall 6m, Controltower, Barrier 3 green, Barrier 5 green, Sandbagtower green, Trench Forest & Grass(Apex) 
- lootspawn fixed!!! (BIG thanks to second_coming !!)
- excluded Price and Traderlist to make them like recipes and menus (Thank you Greyfox! It made Tanoa Buildings a lot easier!)

V 0.2.5
- new Buildables: ATM 
- Snapmode for walls (Just straight, No corners or gates yet)
- added Non-Physic for Garbage Container and Metalshed 4 Layers
- Exile Walls are only blowable by new charges

V 0.2.4
- new Buildables: Concrete Mixer, Flag CSAT, Garbage Container, Metalshed 4 Layers, Watersink
- fine tuned all recipes! 
- changed target = "Land_CargoBox_V1_F_Kit"; in menus.hpp  	to	target = "Land_CargoBox_V1_F";. menu now working correctly.

V 0.2.3
- new Buildables: Camping Chair V1 & V2, Camping Table, Camping Lamp, MapBoard Altis, Pavement straight and corner narrow and straight and corner wide.
- added BRAMA categories to the recipes (Container, Walls, Flora, Misc, Buildings, Signs, Lamps)
- Battleyefilter added: !"MapBoard_altis_F"


V 0.2.2
- changed the way receips and menus are working, now implemented via .hpp (thank you Murgatroyd)
- new Buildings: Bush, Pier, 3 kind of Stones, Sleepingbag, 2 Solarpanels
- mass of the Big Dome changed to 200
- Armor of following reduced by half:CNC Wall,CNC Wall 1pc,Huge Container,Land Container Green
- fixed light_1_hitpoint spam in .rpt

V 0.2.1 Hotfix
- removed Big Tank and Military Checkpoint. Doors not working and Errors.

V 0.2.0
- new Buildings: airporttower, Barracks, Beachbooth, BigTank, Castletower, UnexplodedAmmoSign, Military Checkpoint, Transmissiontower
- increased armor of military tower (100 times)
- reduced weight of Airplanehangar

V 0.1.9
- new Buildings: Dome (big white one), Airplanehangar, Metal Shed, Solartower, Sunchair, Sunshed, Shabby Lamp
- increased armor of military tower (10 times)

V 0.1.8
- new Buildings:Chair, Cncblock, ContainerSmall, Industryfence 1pt, industryfence 3pt, Lampstreet, Seawall, Tavern, Tavern middle
added alternative crafting receips from MrDynamite

V 0.1.7
- new Buildings:PortableFloodlight double, Radar Small, Slumplane, Table, Toilet, Pierbox
Floodlight coming with next patch Sorry guys

V 0.1.6
- new Buildings: CNCBarrier1, Medium CNC Barrier, Crashbarrier, Big Shed, Touristshed, Watersource, CNC Wall small 4 + 8m, Military Sign Vehicle + Base Small
- bug fixed where Cargo Containers spawned a lock. -> check "addingmenutoitem.txt"
- fixed the bug where containers bouncing around, now same behavior like storage crate ^^
- Tentdome can be placed outside territory
- increased armor of military tower again (10 times)
- slightly increased armor of all hbarriers
- added alternative crafting receips in a separate .txt

V 0.1.5
- new Buildings: Broken Shed, Cargo Container Sand Small, CNC Stairs, Garage, Platform, Tent, Tenthangar
- added lockability to cargo containers
- fixed the bug where other players can pack the container without entering the code.
- Baselights now always on! fixed it :) hope you have fun with them.

V 0.1.4
- new Buildings: CNC Shelter, CNC Wall, Fuelstation Shed, Small Shed,razorwire
- Removed HalogenLights. Problem with Server restart. :( sorry guys
- lowered Mass of all heavy items.

V 0.1.3
- new Buildings: Slum Container, Cargo Container Big, Big Halogenlamp, Military Outpost Small
- Hangar now lockable -Menu added
- on Rusty Tank you can refuel empty Canister, not Cars. :) 
- improved armor of all Buildings
- Hangar mass is set to 310 (carryall is 320)

V 0.1.2
- new Buildings: Rusty Tank, Metal Shelve, Cargo Tower V2 Big, Fuelstation, BagBunker Large, Shootingpostition 
- Hangar now lockable -Menu added
- removed Helipadlights due to Memoryproblems!

V 0.1.1  Hotfix
-new Buildings: Helipadlight Blue,White and Yellow, Wooden Pier.
- added inventory to the yellow shelf and the icebox
- Hatches from the outpost can be opened now
- Hangar is not Lockable... sorry guys
- You can build Sandbags everywhere!!! :)
				
V 0.1.0  Major Patch
-new Buildings: ConcreteDoor, BarGate, Helipadlights green/red, icebox, Sign Military Area, Military CncWall,
				Military Outpost, Steelfence,
-Fixed Door Locking! now working correctly 

V 0.0.4
- Bugfixes
- New Buildings: 3 different Types of concrete walls; Helipad; New Shelf

V 0.0.3
- New Buildings: Ammobox, LandContainer, Sandbag Corner, Sandbag long, Sandbagbunker, Shelf
				Sandbagbunker Small, Hangar, Sandbagwall Big Corner, 6m, 4m, ConcreteRamp
- Ladder fixed
- Stone Gate lockable

V 0.0.2
- New Buildings: CNCBarrier, Stonewall, Stonegate, Ladder, Watercooler
- FIXED building location was stuck! -> battleye filter!!!