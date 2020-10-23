Autor: Freakylein; erstmal ein dickes Danke an Firefox für das Unterstützen bei dem ganzen vorhaben!!! Und an alle die mir bei Bugs geholfen haben :)

Extended Base Mod für Exile Mod

Ich habe ein paar codes vom Exile Mod benutzt.
Dieser Inhalt gehört komplett dem Exile Mod Team! Ich habe nur ein paar Sachen zusammengefügt :)
So Leute, dieser mod ermöglicht euch einige Gebäude aus dem Original Arma 3 bei euch im Territorium zu bauen.


INSTALLATION:

Zuerst kopiert ihr die Battleye filter aus der "Battleye filter.txt" im Ordner!!
///////////////////////////////////////////////////////////////////////////////////////////////////////
Kopiert den "@Extended_Base_Mod" Ordner in euer Arma 3 Verzeichnis.
Dies sollte dort sein, wo euer Steam abliegt.
Steam -> steamapps -> common -> Arma 3 -> legt den Ordner hier ab.
Danach fügt zu euren Startparametern "-mod=@Extended_Base_Mod" hinzu.

Kopiert den "bikey" aus "Extended_Base_Mod\keys\ExtendedBase2.9.bikey" in euren "Keys" Ordner auf dem Server. löscht den alten key davor raus!
///////////////////////////////////////////////////////////////////////////////////////////////////////
Erstellt einen Ordner "EBM" in eurer Mission "Exile.Altis.pbo" und kopiert die Dateien "menus.hpp" und "recipes.hpp" hinein.
Fügt die folgende Zeile an die oberste Stelle der CfgCraftingRecipes in der config.cpp eurer Mission:
#include "EBM\recipes.hpp"

Fügt die folgende Zeile an die oberste Stelle der CfgInteractionMenus in der config.cpp eurer Mission:
#include "EBM\menus.hpp"

Fügt die folgende Zeile an die oberste Stelle der CfgTraderCategories in der config.cpp eurer Mission:
#include "EBM\traders.hpp"

Fügt die folgende Zeile an die oberste Stelle der CfgExileArsenal in der config.cpp eurer Mission:
#include "EBM\prices.hpp"

wenn ihr da Probleme habt schaut in den Example Ordner
///////////////////////////////////////////////////////////////////////////////////////////////////////
sucht nach class Exile_Trader_Hardware und fügt "ExtendedBaseMod" hinzu,
  
  	class Exile_Trader_Hardware
	{
		name = "HARDWARE";
		showWeaponFilter = 0;
		categories[] = 
		{
			"Hardware",
			"ExtendedBaseMod", //neeeeuuuu :D
			"Tools"
		};
	};
///////////////////////////////////////////////////////////////////////////////////////////////////////
Um die Lootpositionen zu fixen müsst ihr die "exileclient_system_lootmanager_thread_spawn.sqf" in euren EBM Ordner
in der Mission.pbo hineinkopieren.
Als nächstes fügt den Code:

exileclient_system_lootmanager_thread_spawn = "EBM\exileclient_system_lootmanager_thread_spawn.sqf";
exileServer_object_construction_database_load = "EBM\exileServer_object_construction_database_load.sqf"; //Originalfix von Eichi!

bei dem Eintrag "CfgExileCustomCode" in der config.cpp eurer Mission.pbo hinzu.
///////////////////////////////////////////////////////////////////////////////////////////////////////
Schaut euch für mögliche Änderungen alle Dateien an oder der Mod wird nicht wie gewollt funktionieren.
!!!! Versucht auch die Alternativen Rezepte von MrD !!!! - Danke für das Erstellen.

Um die "Wasserstelle" gangbar zu machen geht in eure config.cpp der Mission und sucht nach 
"WaterSource".


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

		
////////////////////////////////////////////////////////////////
// Diesen Schritt nicht ausführen!!! - Apex ist abgeschaltet  //	
////////////////////////////////////////////////////////////////
Um APEX Gebäude zu aktivieren müsst ihr in die "trader.hpp", "prices.hpp" und die "recipes.hpp" und oben bei der
Zeile
//#define USE_APEX_Buildings 1
die beiden // entfernen



///////////////////////////////////////////////////////////////////////////////////////////////////////
UPDATING:

Wenn ihr updated, dann nehmt diese Anleitung:
1. löscht den ganzen "@Extended_Base_Mod" Ordner auf eurem Server
2. löscht ExtendedBase2.8.bikey im Keys Ordner
3. Geht in die Datenbank und löscht alle APEX Gebäude (nur wenn Ihr von 2.8 zu 2.9 wechselt)
4. Kopiert den neuen "@Extended_Base_Mod" ordner von dem neu runtergeladenen
5. Kopiere ExtendedBase2.9.bikey in deinen Keys ordner
6. Überarbeitet eure recipes.hpp, menus.hpp, traders.hpp, prices.hpp in der Missionsdatei(Dringend ausführen!!)

///////////////////////////////////////////////////////////////////////////////////////////////////////

Änderungen:

V 0.3.0
- Huge Lamp Beleuchtung gefixt
- begrenzte Apex Gebäude verfügbar
- Türen gefixed (original by Eichi)

V 0.2.9
- Sorry leute, aber ich musste die APEX Gebäude entfernen. Arma hat die geändert....
- Das beschädigen von Gebäuden mittels Erdbeben und Sprengladungen wurde behoben.

V 0.2.8
- neue Gebäude: Airporthangar (Apex), Munitionsbox, Basaltwand 4m & 8m und Durchgang (Apex), Wellenbrecher nass & trocken (Apex), Huron Ammo- und Spritcontainer, IR Zelt groß & klein (Apex), Petroglyphwand 1 & 2 (Apex), Sandsack grün lang und kurz (Apex), Sandsackbunker groß grün (Apex), Sandsackturm grün (Apex), Aktenkoffer 
- alle neuen Wandelemente mit Snap-punkten
- höhensprung beim setzen der Pierbox & Airplanehangar gefixt
- Licht der Shabby lamp und der Camping Lamp gefixt

V 0.2.7
- neues Gebäude: Bungalow, Haus Groß, Plastikkiste, Forschungshaus klein & groß, Garagenunterstand (Apex)
- alle Dinge und Gebäude können jetzt mit den "Breaching Charges" zerstört werden

V 0.2.6
- neues Gebäude: Großer Bunker, Bunker Rechteckig, Bunker Hexagonal, Sandsackbunker klein grün, Bunkerwand 3m, Bunkerwand 6m,
			     Flughafenturm, Barrieren 3 & 5m, Sandsackturm grün, Gräben Forst & Graß(Apex), 
- lootspawn fixed!!! (Dickes Danke an second_coming !!)
- Preis und Traderlisten ausgelagert wie Menüs und die Rezepte (Danke an Greyfox, es ist jetzt einfacher für mich Apexgebäude einzufügen)

V 0.2.5
- neues Gebäude: Geldautomat
- Rastmodus für Wände (Nur gerade, keine Ecken oder Tore)
- Physik für Mülltonne und Metallregal mit 4 Einlegeböden entfernt
- Exile Wände sind nun nur noch durch die neuen Sprengladungen verwundbar.

V 0.2.4
- neue Gebäude: Zementmischer, Flagge CSAT, Mülltonne, Metallregal mit 4 Einlegeböden, Wasserstelle
- Rezepte überarbeitet
- "target" = "Land_CargoBox_V1_F_Kit"; in menus.hpp zu	target = "Land_CargoBox_V1_F";. Menü arbeitet korrekt.

V 0.2.3
- neue Gebäude: Campingstuhl V1 & V2, Campingtisch, Campinglampe, Karte von Altis, Gehsteig eng & gerade mit Ecken
- BRAMA kategorien zu den Rezepten hinzugefügt (Container, Walls, Flora, Misc, Buildings, Signs, Lamps)
- Battleyefilter hinzugefügt: !"MapBoard_altis_F"

V 0.2.2
- die Art und Weise wie die Rezepte und die Menüs implementiert wurden geändert. (via .hpp, Danke an Murgatroyd)
- neue Gebäude: Busch, Pier, 3 verschiedene Steine, Schlafsack, 2 Solarpaneelen
- Gewicht vom "Big Dome" auf 200 reduziert
- Rüstung von folgenden Objekten um die hälfte reduziert: CNC Wall,CNC Wall 1pc,Huge Container,Land Container Green
- light_1_hitpoint spam in der .rpt gefixt

V 0.2.1 Hotfix
- Großen Tank und Militärcheckpoint rausgenommen, aufgrund von Fehlern.

V 0.2.0
- Neue Gebäude: Airporttower, Barracken, Umkleide Strand, Großer Tank, Burgturm, Ungesprengte Munitionsschild, Militärcheckpoint, Sendemast
- Rüstung des Militärturms erhöht (100-fache)
- Gewicht vom Flugzeughangar reduziert

V 0.1.9
- Neue Gebäude: Dome (großer weißer), Flugzeughangar, Metallschuppen, Solarturm, Sonnenliege, Sonnenschirm, Schäbige Lampe
- Rüstung des Militärturms erhöht (10-fache)

V 0.1.8
- Neue Gebäude: Stuhl, Betonblock, kleiner Container,  Industriezaun 1stk, Industriezaun 3stk, Straßenlampe, Wellenbrecher, Taverne, Taverne Mittelstück
Alternativrezepte von MrD hinzugefügt

V 0.1.7
- Neue Gebäude: Tragbares Licht (2-fach), Kleines Radar, Slumplane, Tisch, Toilette, Pierbox

V 0.1.6
- Neue Gebäude: CNCBarrier1, Mittlere CNC Barriere, Leitplanke, Großer Schuppen, Touristen Schuppen, Wasserquelle, CNC Wand klein 4 + 8m, Militärschild Fahrzeuge + Kleine Basis
- Bug fixed wo Cargo Container ein Code Lock gedropt haben. -> siehe "addingmenutoitem.txt"
- Bug, wo Container herumgehüpft sind gefixt, jetzt haben diese die selben Eigenschaften wie die Aufbewahrungskiste ^^
- Rundes Zelt kann ausserhalb des Territoriums gesetzt werden.
- Rüstung des Militärturms erhöht (10-fache)
- Die Rüstung von allen HBarrieren leicht erhöht
- alternative Rezepte hinzugefügt

V 0.1.5
- Neue Gebäude: Kaputter Schuppen, Cargo Container Sand klein, CNC Treppe, Garage, Plattform, Zelt, Zelthangar
- Abschließbarkeit bei Containern hinzugefügt
- Bug gefixt, wo andere Spieler den Container ohne den Code einpacken konnten
- Basislichter sind immer an. Hoffe Ihr habt jetzt Spaß mit denen :)

V 0.1.4
- Neue Gebäude: CNC Unterstand, CNC Wand, Tankstellendach, Kleiner Schuppen, Stacheldraht
- Halogenlichter entfernt. Probleme mit dem Serverneustart :( sorry
- Massen von allen schweren Items verringert.

V 0.1.3
- Neue Gebäude: Slum Container, Cargo Container Groß, Große Halogenlampe, Militär Aussenposten klein
- Lockmenü zum Hangar hinzugefügt
- Rüstung von allen Gebäuden verbessert
- Hangar Masse wurde zu 310 gesetzt (Großer Rucksack hat 320)

V 0.1.2
- Neue Gebäude: Rusty Tank, Metal Shelve, Cargo Tower V2 Big, Fuelstation, BagBunker Large, Shootingpostition 
- Helipadlichter wegen Speicherproblemen entfernt!

V 0.1.1  Hotfix
- Neue Gebäude: Helipadlichter Blau, Weiß, Gelb, Holzpier.
- Inventar zu Gelben Regal und der Tiefkühlbox hinzugefügt
- Klappen des Aussenpostens können jetzt schließen
- Hangar ist nicht Lockbar... sorry Leute
- Ihr könnt Sandsäcke überall bauen!!! :)
				
V 0.1.0  Hauptpatch
- Neue Gebäude: ConcreteDoor, Schranke, Helipadlichter Grün/Rot, Tiefkühlbox, Militärareal Schild, Militär CncWand,
				Militäraussenposten, Stahlzaun,
- Türen können jetzt gelockt werden 

V 0.0.4
- Bugfixes
- Neue Gebäude: 3 verschiedene Zementwände; Helipad; Neues Regal

V 0.0.3
- Neue Gebäude: Ammobox, LandContainer, Sandsack Ecke, Sandsack Lang, Sandsackbunker, Regal
				Sandsackbunker klein, Hangar, Sandsackwand Groß Ecke, 6m, 4m, Betonrampe
- Leiter gefixt
- Steintor lockbar

V 0.0.2
- Neue Gebäude: CNCBarriere, Steinwand, Stonetor, Leiter, Waterspender
- FIXED Gebäude ließ sich nicht Bewegen-> battleye filter!!!


Neue sachen für den Serveradministrator: -> füge es in deine config.cpp in der mission.pbo
//////////////////////////////////////////////////////////
Um sie zur Traderliste hinzuzufügen:

		"Land_HBarrier_1_F_Kit",
		"Land_HBarrier_3_F_Kit",
		"Land_HBarrier_5_F_Kit",
		"Land_BagBunker_Tower_F_Kit",
		"CamoNet_OPFOR_open_F_Kit",
		"CamoNet_INDP_open_F_Kit",
		"CamoNet_BLUFOR_open_F_Kit",
		///////////////////////// V0.0.2
		"Land_CncBarrier_F_Kit",
		"Land_Stone_4m_F_Kit",
		"Land_Stone_Gate_F_Kit",
		"PierLadder_F_Kit",
		"Land_WaterCooler_01_new_F_Kit",
		///////////////////////// V0.0.3
		"Land_Pallet_MilBoxes_F_Kit",
		"Land_Cargo20_military_green_F_Kit",
		"Land_BagFence_Corner_F_Kit",
		"Land_BagFence_Long_F_Kit",
		"Land_HBarrierTower_F_Kit",
		"Land_Metal_wooden_rack_F_Kit",
		"Land_BagBunker_Small_F_Kit",
		"Land_Bunker_F_Kit",
		"Land_HBarrierWall_corner_F_Kit",
		"Land_HBarrierWall6_F_Kit",
		"Land_HBarrierWall4_F_Kit",
		"Land_RampConcrete_F_Kit",
		///////////////////////// V0.0.4
		"Land_Wall_IndCnc_4_F_Kit",
		"Land_City2_4m_F_Kit",
		"Land_City2_8m_F_Kit",
		"Land_HelipadCivil_F_Kit",
		"Land_Rack_F_Kit",
		///////////////////////// V0.1.0
		"Land_City_Gate_F_Kit",
		"Land_BarGate_F_Kit",
		"Land_Icebox_F_Kit",
		"Land_Sign_WarningMilitaryArea_F_Kit",
		"Land_Mil_WallBig_4m_F_Kit",
		"Land_Cargo_Patrol_V2_F_Kit",
		///////////////////////// V0.1.1
		"Land_Pier_small_F_Kit",
		"Land_Wall_Tin_4_Kit",
		///////////////////////// V0.1.2
		"Land_Tank_rust_F_Kit",
		"Land_ShelvesMetal_F_Kit",
		"Land_Cargo_Tower_V2_F_Kit",
		"Land_FuelStation_Feed_F_Kit",
		"Land_BagBunker_Large_F_Kit",
		"ShootingPos_F_Kit",
		///////////////////////// V0.1.3
		"Land_cargo_house_slum_F_Kit",
		"Land_Cargo40_light_green_F_Kit",
		"Land_Cargo_House_V2_F_Kit",
		"Land_LampHalogen_F_Kit",
		///////////////////////// V0.1.4
		"Land_LampAirport_F_Kit",
		"Land_CncShelter_F_Kit",
		"Land_Wall_IndCnc_2deco_F_Kit",
		"Land_CncWall4_F_Kit",
		"Land_FuelStation_Shed_F_Kit",
		"Land_Shed_Small_F_Kit",		
		"Land_Razorwire_F_Kit",
		///////////////////////// V0.1.5
		"Land_u_Addon_01_V1_F_Kit", //brokenshed
		"Land_Cargo20_sand_F_Kit",
		"Land_GH_Stairs_F_Kit",
		"Land_i_Garage_V2_F_Kit",
		"Land_GH_Platform_F_Kit",
		"Land_TentDome_F_Kit",
		"Land_TentHangar_V1_F_Kit",
		///////////////////////// V0.1.6
		"Land_CncWall1_F_Kit",
		"Land_CncBarrierMedium_F_Kit",
		"Land_Crash_barrier_F_Kit",
		"Land_Shed_Big_F_Kit",
		"Land_TouristShelter_01_F_Kit",
		"Land_Water_source_F_Kit",
		"Land_Sign_WarningMilitaryVehicles_F_Kit",
		"Land_Sign_WarningMilAreaSmall_F_Kit",
		"Land_Concrete_SmallWall_8m_F_Kit",
		"Land_Concrete_SmallWall_4m_F_Kit",
		///////////////////////// V0.1.7
		"Land_PortableLight_double_F_Kit",
		"Land_Radar_Small_F_Kit",
		"Land_Cargo_addon02_V2_F_Kit", //Slumplane
		"Land_TableDesk_F_Kit",
		"Land_ToiletBox_F_Kit",
		"Land_Pier_Box_F_Kit",
		///////////////////////// V0.1.8
		"Land_ChairWood_F_Kit",
		"BlockConcrete_F_Kit",
		"Land_CargoBox_V1_F_Kit",
		"Land_IndFnc_3_F_Kit",
		"Land_IndFnc_9_F_Kit",
		"Land_Sea_Wall_F_Kit",
		"Land_i_Addon_03_V1_F_Kit",
		"Land_i_Addon_03mid_V1_F_Kit",
		"Land_LampStreet_F_Kit",
		///////////////////////// V0.1.9
		"Land_Dome_Big_F_Kit",
		"Land_Hangar_F_Kit",
		"Land_Metal_Shed_F_Kit",
		"Land_spp_Tower_F_Kit",
		"Land_Sun_chair_F_Kit",
		"Land_Sunshade_04_F_Kit",
		"Land_LampShabby_F_Kit",
		///////////////////////// V0.2.0
		"Land_Airport_Tower_F_Kit",
		"Land_i_Barracks_V1_F_Kit",
		"Land_BeachBooth_01_F_Kit",
		"Land_Castle_01_tower_F_Kit",
		"Land_Sign_WarningUnexplodedAmmo_F_Kit",
		"Land_TTowerSmall_1_F_Kit",
		///////////////////////// V0.2.1 Hotfix
		///////////////////////// V0.2.2
		"Exile_Plant_GreenBush_Kit",
		"Land_nav_pier_m_F_Kit",
		"Land_SharpStone_01_F_Kit",
		"Land_SharpStone_02_F_Kit",
		"Land_Sleeping_bag_F_Kit",
		"Land_Small_Stone_02_F_Kit",
		"Land_SolarPanel_2_F_Kit",
		"Land_spp_Panel_F_Kit",
		///////////////////////// V0.2.3
		"Land_CampingChair_V2_F_Kit",
		"Land_CampingChair_V1_F_Kit",
		"Land_Camping_Light_F_Kit",
		"Land_CampingTable_F_Kit",
		"MapBoard_altis_F_Kit",
		"Land_Pavement_narrow_F_Kit",
		"Land_Pavement_narrow_corner_F_Kit",
		"Land_Pavement_wide_F_Kit",
		"Land_Pavement_wide_corner_F_Kit",
		///////////////////////// V0.2.4
		"Exile_ConcreteMixer_Kit",
		"Flag_CSAT_F_Kit",
		"Land_GarbageContainer_closed_F_Kit",
		"Land_Metal_rack_F_Kit",
		"Land_Sink_F_Kit",
		///////////////////////// V0.2.4
		"Land_Atm_02_F_Kit",
		
//////////////////////////////////////////////////////////
Um sie der Preisliste hinzuzufügen:

///////////////////////////////////////////////////////////////////////////////
// Extended Base Mod
//////////////////////////////////////////////////////////////////////////////
class Land_HBarrier_1_F_Kit				{ quality = 1; price = 5500;sellPrice = 50; };
class Land_HBarrier_3_F_Kit				{ quality = 1; price = 19000;sellPrice = 50;  };
class Land_HBarrier_5_F_Kit				{ quality = 1; price = 40000;sellPrice = 50;  };
class Land_BagBunker_Tower_F_Kit		{ quality = 1; price = 100000;sellPrice = 50;  };
class CamoNet_OPFOR_open_F_Kit			{ quality = 1; price = 1000; sellPrice = 50; };
class CamoNet_INDP_open_F_Kit			{ quality = 1; price = 1000;sellPrice = 50;  };
class CamoNet_BLUFOR_open_F_Kit			{ quality = 1; price = 1000;sellPrice = 50;  };
///////////////////////// V0.0.2
class Land_CncBarrier_F_Kit				{ quality = 1; price = 7500;sellPrice = 50;  };
class Land_Stone_4m_F_Kit				{ quality = 1; price = 15000;sellPrice = 50;  };
class Land_Stone_Gate_F_Kit				{ quality = 1; price = 15000;sellPrice = 50;  };
class PierLadder_F_Kit					{ quality = 1; price = 75000;sellPrice = 50;  };
class Land_WaterCooler_01_new_F_Kit		{ quality = 1; price = 180000;sellPrice = 50;  };
///////////////////////// V0.0.3
class Land_Pallet_MilBoxes_F_Kit		{ quality = 1; price = 39990;sellPrice = 50;  };
class Land_Cargo20_military_green_F_Kit	{ quality = 1; price = 50000;sellPrice = 50;  };
class Land_BagFence_Corner_F_Kit		{ quality = 1; price = 10000;sellPrice = 50;  };
class Land_BagFence_Long_F_Kit			{ quality = 1; price = 10000;sellPrice = 50; };
class Land_HBarrierTower_F_Kit			{ quality = 1; price = 75000;sellPrice = 50;  };
class Land_Metal_wooden_rack_F_Kit		{ quality = 1; price = 38000;sellPrice = 50;  };
class Land_BagBunker_Small_F_Kit		{ quality = 1; price = 65000;sellPrice = 50;  };
class Land_Bunker_F_Kit					{ quality = 1; price = 750000;sellPrice = 50;  };
class Land_HBarrierWall_corner_F_Kit	{ quality = 1; price = 50000;sellPrice = 50;  };
class Land_HBarrierWall6_F_Kit			{ quality = 1; price = 60000;sellPrice = 50;  };
class Land_HBarrierWall4_F_Kit			{ quality = 1; price = 35000;sellPrice = 50;  };
class Land_RampConcrete_F_Kit			{ quality = 1; price = 55000;sellPrice = 50;  };
///////////////////////// V0.0.4
class Land_Wall_IndCnc_4_F_Kit			{ quality = 1; price = 50000;sellPrice = 50;  };
class Land_City2_4m_F_Kit				{ quality = 1; price = 60000;sellPrice = 50;  };
class Land_City2_8m_F_Kit				{ quality = 1; price = 60000;sellPrice = 50;  };
class Land_HelipadCivil_F_Kit			{ quality = 1; price = 100000;sellPrice = 50;  };
class Land_Rack_F_Kit					{ quality = 1; price = 35000;sellPrice = 50;  };
///////////////////////// V0.1.0
class Land_City_Gate_F_Kit							{ quality = 1; price = 20000;sellPrice = 50;  };
class Land_BarGate_F_Kit							{ quality = 1; price = 20000;sellPrice = 50;  };
class Land_Icebox_F_Kit								{ quality = 1; price = 45000;sellPrice = 50;  };
class Land_Sign_WarningMilitaryArea_F_Kit			{ quality = 1; price = 1000;sellPrice = 50;  };
class Land_Mil_WallBig_4m_F_Kit						{ quality = 1; price = 60000;sellPrice = 50;  };
class Land_Cargo_Patrol_V2_F_Kit					{ quality = 1; price = 185000;sellPrice = 50;  };
///////////////////////// V0.1.1
class Land_Pier_small_F_Kit							{ quality = 1; price = 75000;sellPrice = 50;  };
class Land_Wall_Tin_4_Kit							{ quality = 1; price = 50000;sellPrice = 50;  };
///////////////////////// V0.1.2
class Land_Tank_rust_F_Kit							{ quality = 1; price = 50000;sellPrice = 50;  };
class Land_ShelvesMetal_F_Kit						{ quality = 1; price = 50000;sellPrice = 50;  };
class Land_Cargo_Tower_V2_F_Kit						{ quality = 1; price = 750000;sellPrice = 50;  };
class Land_FuelStation_Feed_F_Kit					{ quality = 1; price = 220000;sellPrice = 50;  };
class Land_BagBunker_Large_F_Kit					{ quality = 1; price = 100000;sellPrice = 50;  };
class ShootingPos_F_Kit								{ quality = 1; price = 1000;sellPrice = 50;  };
///////////////////////// V0.1.3
class Land_cargo_house_slum_F_Kit							{ quality = 1; price = 25000;sellPrice = 50;  };
class Land_Cargo40_light_green_F_Kit						{ quality = 1; price = 130000;sellPrice = 50;  };
class Land_Cargo_House_V2_F_Kit								{ quality = 1; price = 200000;sellPrice = 50;  };
class Land_LampHalogen_F_Kit								{ quality = 1; price = 65200;sellPrice = 50;  };
///////////////////////// V0.1.4
class Land_LampAirport_F_Kit								{ quality = 1; price = 85600;sellPrice = 50;  };
class Land_CncShelter_F_Kit									{ quality = 1; price = 40000;sellPrice = 50;  };
class Land_Wall_IndCnc_2deco_F_Kit							{ quality = 1; price = 60000;sellPrice = 50;  };
class Land_CncWall4_F_Kit									{ quality = 1; price = 60000;sellPrice = 50;  };
class Land_FuelStation_Shed_F_Kit							{ quality = 1; price = 65000;sellPrice = 50;  };
class Land_Shed_Small_F_Kit									{ quality = 1; price = 100000;sellPrice = 50;  };
class Land_Razorwire_F_Kit									{ quality = 1; price = 5000;sellPrice = 50;  };
///////////////////////// V0.1.5
class Land_u_Addon_01_V1_F_Kit								{ quality = 1; price = 50000;sellPrice = 50;  }; //brokenshed
class Land_Cargo20_sand_F_Kit								{ quality = 1; price = 80000;sellPrice = 50;  };
class Land_GH_Stairs_F_Kit									{ quality = 1; price = 50000;sellPrice = 50;  };
class Land_i_Garage_V2_F_Kit								{ quality = 1; price = 125000;sellPrice = 50;  };
class Land_GH_Platform_F_Kit								{ quality = 1; price = 50000;sellPrice = 50;  };
class Land_TentDome_F_Kit									{ quality = 1; price = 1000;sellPrice = 50;  };
class Land_TentHangar_V1_F_Kit								{ quality = 1; price = 350000;sellPrice = 50;  };
///////////////////////// V0.1.6
class Land_CncWall1_F_Kit									{ quality = 1; price = 15000;sellPrice = 50;  };
class Land_CncBarrierMedium_F_Kit							{ quality = 1; price = 15000;sellPrice = 50;  };
class Land_Crash_barrier_F_Kit								{ quality = 1; price = 10000;sellPrice = 50;  };
class Land_Shed_Big_F_Kit									{ quality = 1; price = 75000;sellPrice = 50;  };
class Land_TouristShelter_01_F_Kit							{ quality = 1; price = 50000;sellPrice = 50;  };
class Land_Water_source_F_Kit								{ quality = 1; price = 100000;sellPrice = 50;  };
class Land_Sign_WarningMilitaryVehicles_F_Kit				{ quality = 1; price = 10000;sellPrice = 50;  };
class Land_Sign_WarningMilAreaSmall_F_Kit					{ quality = 1; price = 10000;sellPrice = 50;  };
class Land_Concrete_SmallWall_8m_F_Kit						{ quality = 1; price = 20000;sellPrice = 50;  };
class Land_Concrete_SmallWall_4m_F_Kit						{ quality = 1; price = 20000;sellPrice = 50;  };
///////////////////////// V0.1.7
class Land_PortableLight_double_F_Kit						{ quality = 1; price = 25000;sellPrice = 50;  };
class Land_Radar_Small_F_Kit								{ quality = 1; price = 150000; sellPrice = 50;  };
class Land_Cargo_addon02_V2_F_Kit							{ quality = 1; price = 20000;sellPrice = 50;  }; //Slumplane	
class Land_TableDesk_F_Kit									{ quality = 1; price = 20000;sellPrice = 50;  };
class Land_ToiletBox_F_Kit									{ quality = 1; price = 10000;sellPrice = 50;  };
class Land_Pier_Box_F_Kit									{ quality = 1; price = 500000;sellPrice = 50;  };
///////////////////////// V0.1.8
class Land_ChairWood_F_Kit									{ quality = 1; price = 1000;sellPrice = 50;  };
class BlockConcrete_F_Kit									{ quality = 1; price = 20000;sellPrice = 50;  };
class Land_CargoBox_V1_F_Kit								{ quality = 1; price = 60000;sellPrice = 50;  };
class Land_IndFnc_3_F_Kit									{ quality = 1; price = 10000;sellPrice = 50;  };
class Land_IndFnc_9_F_Kit									{ quality = 1; price = 30000;sellPrice = 50;  };
class Land_Sea_Wall_F_Kit									{ quality = 1; price = 100000;sellPrice = 50;  };
class Land_i_Addon_03_V1_F_Kit								{ quality = 1; price = 50000;sellPrice = 50;  }; //Tavern
class Land_i_Addon_03mid_V1_F_Kit							{ quality = 1; price = 50000;sellPrice = 50;  }; //Tavernmiddle
class Land_LampStreet_F_Kit									{ quality = 1; price = 30000;sellPrice = 50;  };
///////////////////////// V0.1.9
class Land_Dome_Big_F_Kit									{ quality = 1; price = 300000;sellPrice = 50;  };
class Land_Hangar_F_Kit										{ quality = 1; price = 500000;sellPrice = 50;  };
class Land_Metal_Shed_F_Kit									{ quality = 1; price = 30000;sellPrice = 50;  };
class Land_spp_Tower_F_Kit									{ quality = 1; price = 700000;sellPrice = 50;  };
class Land_Sun_chair_F_Kit									{ quality = 1; price = 5000;sellPrice = 50;  };
class Land_Sunshade_04_F_Kit								{ quality = 1; price = 5000;sellPrice = 50;  };
class Land_LampShabby_F_Kit									{ quality = 1; price = 20000;sellPrice = 50;  };
///////////////////////// V0.2.0
class Land_Airport_Tower_F_Kit								{ quality = 1; price = 200000;sellPrice = 50;  };
class Land_i_Barracks_V1_F_Kit								{ quality = 1; price = 250000;sellPrice = 50;  };
class Land_BeachBooth_01_F_Kit								{ quality = 1; price = 10000;sellPrice = 50;  };
class Land_Castle_01_tower_F_Kit							{ quality = 1; price = 100000;sellPrice = 50;  };
class Land_Sign_WarningUnexplodedAmmo_F_Kit					{ quality = 1; price = 1000;sellPrice = 50;  };
class Land_TTowerSmall_1_F_Kit								{ quality = 1; price = 20000;sellPrice = 50;  };
///////////////////////// V0.2.1 Hotfix
///////////////////////// V0.2.2
class Exile_Plant_GreenBush_Kit								{ quality = 1; price = 10000;sellPrice = 50;  };
class Land_nav_pier_m_F_Kit									{ quality = 1; price = 200000;sellPrice = 50;  };
class Land_SharpStone_01_F_Kit								{ quality = 1; price = 26000;sellPrice = 50;  };
class Land_SharpStone_02_F_Kit								{ quality = 1; price = 25000;sellPrice = 50;  };
class Land_Sleeping_bag_F_Kit								{ quality = 1; price = 10000;sellPrice = 50;  };
class Land_Small_Stone_02_F_Kit								{ quality = 1; price = 23000;sellPrice = 50;  };
class Land_SolarPanel_2_F_Kit								{ quality = 1; price = 30000;sellPrice = 50;  };
class Land_spp_Panel_F_Kit									{ quality = 1; price = 35000;sellPrice = 50;  };
///////////////////////// V0.2.3
class Land_CampingChair_V2_F_Kit							{ quality = 1; price = 10000;sellPrice = 50;  };
class Land_CampingChair_V1_F_Kit							{ quality = 1; price = 10000;sellPrice = 50;  };
class Land_Camping_Light_F_Kit								{ quality = 1; price = 10000;sellPrice = 50;  };
class Land_CampingTable_F_Kit								{ quality = 1; price = 10000;sellPrice = 50;  };
class MapBoard_altis_F_Kit									{ quality = 1; price = 8000;sellPrice = 50;  };
class Land_Pavement_narrow_F_Kit							{ quality = 1; price = 5000;sellPrice = 50;  };
class Land_Pavement_narrow_corner_F_Kit						{ quality = 1; price = 5000;sellPrice = 50;  };
class Land_Pavement_wide_F_Kit								{ quality = 1; price = 5000;sellPrice = 50;  };
class Land_Pavement_wide_corner_F_Kit						{ quality = 1; price = 5000;sellPrice = 50;  };
///////////////////////// V0.2.4
class Exile_ConcreteMixer_Kit								{ quality = 6; price = 500000;sellPrice = 50;  };
class Flag_CSAT_F_Kit										{ quality = 1; price = 5000;sellPrice = 50;  };
class Land_GarbageContainer_closed_F_Kit					{ quality = 3; price = 3000;sellPrice = 50;  };
class Land_Metal_rack_F_Kit									{ quality = 1; price = 50000;sellPrice = 50;  };
class Land_Sink_F_Kit										{ quality = 2; price = 27000;sellPrice = 50;  };
class Land_Atm_02_F_Kit										{ quality = 6; price = 100000;sellPrice = 50;  };