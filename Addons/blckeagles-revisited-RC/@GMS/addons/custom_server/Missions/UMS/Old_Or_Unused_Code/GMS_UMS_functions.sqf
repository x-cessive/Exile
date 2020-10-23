/*
	by Ghostrider [GRG]
	Copyright 20167
	--------------------------
	License
	--------------------------
	All the code and information provided here is provided under an Attribution Non-Commercial ShareAlike 4.0 Commons License.

	http://creativecommons.org/licenses/by-nc-sa/4.0/	
*/
#include "\q\addons\custom_server\Configs\blck_defines.hpp";
blck_fnc_findShoreLocation = compileFinal preprocessFileLineNumbers "q\addons\custom_server\Missions\UMS\code\GMS_UMS_fnc_findShoreLocation.sqf";
blck_fnc_addDyanamicUMS_Mission = compileFinal preprocessFileLineNumbers "q\addons\custom_server\Missions\UMS\code\GMS_fnc_addDynamicUMS_Mission.sqf";
blck_fnc_findWaterDepth  = compileFinal preprocessFileLineNumbers "q\addons\custom_server\Missions\UMS\code\GMS_UMS_fnc_findWaterDepth.sqf";

diag_log "[blckeagls] UMS functions Functions compiled";
