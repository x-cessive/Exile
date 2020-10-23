/*
	by Ghostrider [GRG]
	Copyright 2016
	--------------------------
	License
	--------------------------
	All the code and information provided here is provided under an Attribution Non-Commercial ShareAlike 4.0 Commons License.

	http://creativecommons.org/licenses/by-nc-sa/4.0/	
*/
#include "\q\addons\custom_server\Configs\blck_defines.hpp";
private["_mapCenter","_waterPos","_priorUMSpositions"];

switch (toLower worldName) do 
{
	case "altis": {_mapCenter = [15000,19000,0];_maxDistance = 20000};
	case "tanoa": {_mapCenter = getArray(configFile >> "CfgWorlds" >> worldName >> "centerPosition");_maxDistance = 10000};
	case "malden": {_mapCenter = [6000,7000,0];_maxDistance = 5500};
	case "namalsk": {_mapCenter = getArray(configFile >> "CfgWorlds" >> worldName >> "centerPosition");_maxDistance = 5000}; 
	case "taviana": {_mapCenter = [12000,12000,0];_maxDistance = 12000};
	case "napf" : {_mapCenter = getArray(configFile >> "CfgWorlds" >> worldName >> "centerPosition");_maxDistance = 12000};
	case "lythium": {_mapCenter = [10000,10000,0]; _maxDistance = 6000;};
	default {_mapCenter = [6000,6000,0]; _maxDistance = 6000;};	
};

_evaluate = true;
 while {_evaluate} do
{
	_waterPos = [
		_mapCenter, // center of search area
		2, // min distance to search 
		20000, // max distance to search
		0, // distance to nearest object
		2, // water mode [2 = water only]
		25, // max gradient
		0  // shoreMode [0 = anywhere]
		] call BIS_fnc_findSafePos;
		/*
	_priorUMSpositions = +blck_priorDynamicUMS_Missions;
	{
		if (diag_tickTime > ((_x select 1) + 1800) then 
		{
			blck_priorDynamicUMS_Missions = blck_priorDynamicUMS_Missions - _x;
		} else {
			if (_waterPos distance2D (_x select  0) < 2000) exitWith {_evaluate = false};
		};
	} forEach _priorUMSpositions;
	*/
	if (_evaluate) then
	{
		if (abs(getTerrainHeightASL _waterPos) < 30) then
		{
			if (abs(getTerrainHeightASL _waterPos) > 1) then
			{
				//_waterMarker = createMarker [format["water mission %1",getTerrainHeightASL _waterPos],_waterPos];
				//_waterMarker setMarkerColor "ColorRed";
				//_waterMarker setMarkerType "mil_triangle";
				//_waterMarker setMarkerText format["Depth %1",getTerrainHeightASL _waterPos];
				_evaluate = false;
			};
		};
	};
};
_waterPos







