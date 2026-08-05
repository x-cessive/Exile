/**
 * ExileExpansionClient_object_player_playScavengeEvent
 *
 * Exile Expansion Mod
 * www.reality-gaming.eu
 * © 2017 Exile Expansion Mod Team
 *
 * This work is licensed under the Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 International License.
 * To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-nd/4.0/.
 */
params ["_configName",	"_recipe",	"_possibleCraftQuantity", "_pos", "_object", "_pobject"];

private _clutter = objNull;
private _configReference = missionConfigFile >> "CfgExileScavenge";
private _chance = getNumber (_configReference >> _configName >> "chance");
private _searchtime = getNumber (_configReference >> _configName >> "searchtime");
private _timeToSearch = 0;
private _animationsList = getArray (_configReference >>_configName >> "animations");
private _animationToPlay = _animationsList call BIS_fnc_selectRandom;
private _player = player;
private _playerScavengeEvent = true;
private _objectsList = missionNamespace getVariable ["ExileClientSavengedObjects", []];
private _searchUIenabled = getNumber (missionConfigFile >> "Exile_ScavengeSettings" >> "showsearch_UI");

player setVariable ["CanScavenge", false];

if (_searchUIenabled == 1) then {
	( ["ExileScavengeUI"] call BIS_fnc_rscLayer ) cutRsc [ "ExileScavengeUI", "PLAIN", 1, false ];
};

if (_animationToPlay != "") then {
	_startAnimTime = time;
	_player playMove _animationToPlay;
	waitUntil {animationState _player != _animationToPlay};
} else {
	_player playAction "Crouch";
};

if ( typeName _searchtime  == "SCALAR") then {
	_timeToSearch = _searchtime;
};

private _searchradius = 1.5;
private _searchPos = getPosATL _player;

private _playerInSearchArea = [_player, _searchPos, _searchradius] spawn {
	params["_player", "_searchPos", "_searchradius", "_playerScavengeEvent"];
	waitUntil	{
		_player distanceSqr _searchPos >  ( _searchradius^2 )
	}
};
/*
	XCSV 2026-08-03 -- same defect as ExileExpansionClient_system_scavenge_createLoot.

	`exitWith` inside a for-loop exits the whole SCRIPT scope, not just the loop.
	Stepping outside the 1.5 m search radius skipped the cutRsc teardown (stuck
	progress bar), the terminate (leaked watcher), and the CanScavenge restore
	(scavenging dead until relog). See the sibling file for the full write-up.
*/
private _interrupted = false;

if (_searchUIenabled == 1) then {
	private _sleep = _timeToSearch;
	while { _sleep > 0 && {!_interrupted} } do {
		private _progress = linearConversion [0, _timeToSearch, _sleep, 0, 1];
		(uiNamespace getVariable "ExileScavengeUI" displayCtrl 2001) ctrlSetTextColor [1, 0.706, 0.094, _sleep % 1];
		(uiNamespace getVariable "ExileScavengeUI" displayCtrl 2002) progressSetPosition _progress;
		sleep 0.01;
		_sleep = _sleep - 0.01;
		if (scriptDone _playerInSearchArea) then { _interrupted = true; };
	};
} else {
	if (scriptDone _playerInSearchArea) then { _interrupted = true; };
};

// Unconditional teardown -- reached on every path now.
if (_searchUIenabled == 1) then {
	(["ExileScavengeUI"] call BIS_fnc_rscLayer) cutRsc ["Default", "PLAIN", 1, false];
};
terminate _playerInSearchArea;

if (_interrupted) then {
	["ErrorTitleOnly", ["Scavenge interrupted!"]] call ExileClient_gui_toaster_addTemplateToast;
	_playerScavengeEvent = false;
	player setVariable ["CanScavenge", true];
};

if ( _playerScavengeEvent ) then {
	if ((random 100) < _chance) then {
		["SuccessTitleOnly", ["You've found something!"]] call ExileClient_gui_toaster_addTemplateToast;
		uiSleep 2;
		_possibleCraftQuantity = 1;
		[_recipe, _possibleCraftQuantity] call ExileExpansionClient_system_scavenge_action_craftItem;
		player setVariable ["CanScavenge", true];
	}	else {
		["ErrorTitleOnly", ["Could not find anything."]] call ExileClient_gui_toaster_addTemplateToast;
		player setVariable ["CanScavenge", true];
	};
	if (_object isEqualTo _pobject) then {
    _objectsList pushBack _object;
    missionNamespace setVariable ["ExileClientSavengedObjects", _objectsList, true];
  } else {
    _objectsList pushBack _pos;
    missionNamespace setVariable ["ExileClientSavengedObjects", _objectsList, true];
  };
};
