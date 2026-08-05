 /*
 *
 * Author: Andrew_S90
 *
 * This work is protected by Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International (CC BY-NC-SA 4.0). 
 *
 */

private ["_minimumDistanceToTraderZones","_minimumDistanceToSpawnZones","_minimumDistanceToOtherTerritories","_canbuild","_position"];

_position = _this;
_minimumDistanceToTraderZones = getNumber (missionConfigFile >> "CfgTerritories" >> "minimumDistanceToTraderZones");
_minimumDistanceToSpawnZones = getNumber (missionConfigFile >> "CfgTerritories" >> "minimumDistanceToSpawnZones");
_minimumDistanceToOtherTerritories = getNumber (missionConfigFile >> "CfgTerritories" >> "minimumDistanceToOtherTerritories");

_canbuild = true;

if ([_position, _minimumDistanceToTraderZones] call ExileClient_util_world_isTraderZoneInRange) then
{
	private ["_text"];
	_text = "Too Close to a Trader!";
	["ErrorTitleAndText", ["Build Check", _text]] call ExileClient_gui_toaster_addTemplateToast;
	_canbuild = false;
};
if ([_position, _minimumDistanceToSpawnZones] call ExileClient_util_world_isSpawnZoneInRange) then
{	
	private ["_text"];
	_text = "Too Close to a Spawn Zone!";
	["ErrorTitleAndText", ["Build Check", _text]] call ExileClient_gui_toaster_addTemplateToast;
	_canbuild = false;
};
if ([_position, _minimumDistanceToOtherTerritories] call ExileClient_util_world_isTerritoryInRange) then
{
	private ["_text"];
	_text = "Too Close to an Enemy Territory!";
	["ErrorTitleAndText", ["Build Check", _text]] call ExileClient_gui_toaster_addTemplateToast;
	_canbuild = false;
};
if (_position call ExileClient_util_world_isInNonConstructionZone) then
{
	private ["_text"];
	_text = "In Block Zone!";
	["ErrorTitleAndText", ["Build Check", _text]] call ExileClient_gui_toaster_addTemplateToast;
	_canbuild = false;
};
if (_position call ExileClient_util_world_isInRadiatedZone) then
{
	private ["_text"];
	_text = "In Rad Zone!";
	["ErrorTitleAndText", ["Build Check", _text]] call ExileClient_gui_toaster_addTemplateToast;
	_canbuild = false;
};

if (_canbuild) then {
	private ["_text"];
	_text = "You can build here!!";
	["SuccessTitleAndText", ["Build Check", _text]] call ExileClient_gui_toaster_addTemplateToast;
};
_canbuild