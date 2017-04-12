/**
 * ExileClient_gui_selectSpawnLocation_show
 *
 * Exile Mod
 * www.exilemod.com
 * © 2015 Exile Mod Team
 *
 * This work is licensed under the Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 International License. 
 * To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-nd/4.0/.
 */
 
private["_display","_spawnButton","_listBox","_listItemIndex","_numberOfSpawnPoints","_randNum","_randData","_randomSpawnIndex"];
disableSerialization;
ExileClientSpawnLocationSelectionDone = false;
ExileClientSelectedSpawnLocationMarkerName = "";
createDialog "RscExileSelectSpawnLocationDialog";
waitUntil
{
	_display = findDisplay 24002;
	!isNull _display
};
_spawnButton = _display displayCtrl 24003;
_spawnButton ctrlEnable false;
_display displayAddEventHandler ["KeyDown", "_this call ExileClient_gui_loadingScreen_event_onKeyDown"];
_listBox = _display displayCtrl 24002;
lbClear _listBox;

if(isNil "XG_LastSpawnLocation") then
{
	XG_LastSpawnLocation = [];
};
if(isNil "XG_BaseMarkers") then
{
	XG_BaseMarkers = [];
};

/*
	refresh base building permission
	incase the user was removed
	or added
*/
if!(XG_BaseMarkers isEqualTo []) then
{
	{
		deleteMarker _x;
	} forEach XG_BaseMarkers;
	XG_BaseMarkers = [];
};
{
	_uid = getPlayerUID player;
	_flag = _x getVariable "ExileTerritoryBuildRights";
	if(_uid in _flag) then 
	{
		_name = _x getVariable "ExileTerritoryName";
		_marker = createMarker [_name,position _x];
		_marker setMarkerPos (position _x);
		_marker setMarkerAlpha 0;
		_marker setMarkerTextLocal _name;
		_marker	setMarkerTypelocal "ExileSpawnZone";
		XG_BaseMarkers pushBack _marker;
	};
} forEach (allMissionObjects "Exile_Construction_Flag_Static");

_numberOfSpawnPoints = 0;
{
	if (getMarkerType _x == "ExileSpawnZone") then
	{
		if!(_x in XG_LastSpawnLocation) then
		{
			_listItemIndex = _listBox lbAdd (markerText _x);
			_listBox lbSetData [_listItemIndex, _x];
			_numberOfSpawnPoints = _numberOfSpawnPoints + 1;
		};
	}
} forEach allMapMarkers;

if (_numberOfSpawnPoints isEqualTo 0) then 
{
	_randMarker = [];
	{
		if (getMarkerType _x == "ExileSpawnZone") then
		{
			_randMarker pushBack _x;
		};
	} forEach allMapMarkers;
	_randomSpawn = selectRandom _randMarker;
	_randomSpawnIndex = _listBox lbAdd "Random";
	_listBox lbSetData [_randomSpawnIndex, _randomSpawn];
};
true