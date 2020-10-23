/*

ExileZ Mod by [FPS]kuplion - Based on ExileZ 2.0 by Patrix87

*/

//Variable declaration
private ["_tempTriggerPosition","_triggerPosition","_trigger","_nearestLocation","_groupSize","_triggerRadius","_activationDelay","_spawnDelay","_respawnDelay","_showTriggerOnMap","_zMarkerColor","_zMarkerAlpha","_vestGroup","_lootGroup","_zombiegroup","_lootBox","_zMarkerText","_mission","_marker","_marker2","_zMarkerBrush","_missionLRadius"];


//Current spawner position

_triggerPosition		= _this select 0;
_triggerRadius			= _triggerPosition select 2;
_triggerPosition		= [_triggerPosition select 0,_triggerPosition select 1];
_groupSize 				= (_this select 1) Select 2;
_activationDelay 		= (_this select 1) Select 3;
_spawnDelay 			= (_this select 1) Select 4;
_respawnDelay 			= (_this select 1) Select 5;
_showTriggerOnMap 		= (_this select 1) Select 6;
_zMarkerColor 			= (_this select 1) Select 7;
_zMarkerBrush			= (_this select 1) Select 8;
_zMarkerAlpha 			= (_this select 1) Select 9;
_zMarkerText 			= (_this select 1) Select 10;
_vestGroup 				= (_this select 1) Select 11;
_lootGroup 				= (_this select 1) Select 12;
_zombieGroup 			= (_this select 1) Select 13;
_missionLRadius			= (_this select 1) Select 14;
_mission                = (_this select 1) Select 15;
_lootBox                = (_this select 1) Select 16;

_nearestLocation 		= text nearestLocation [_triggerPosition, ""];

_validLocation = false;
if (_missionLRadius > 0) then {
	while {!_validLocation} do 
	{
		_tempTriggerPosition = [_triggerPosition,0,_missionLRadius] call EZM_GetRandomLocation;
		_validLocation = [_tempTriggerPosition,true] call EZM_VerifyLocation;
		uisleep 0.05;
	};
	_triggerPosition = _tempTriggerPosition;
};

//Create trigger area
_trigger = createTrigger["EmptyDetector", _triggerPosition];
_trigger setTriggerArea[_triggerRadius, _triggerRadius, 0, true]; 	//this is a sphere
_trigger setTriggerTimeout [_activationDelay, _activationDelay, _activationDelay, false];
_trigger setTriggerActivation["GUER", "PRESENT", TRUE]; 			//Only Exile player can trigger
_trigger setTriggerStatements["this && {isplayer vehicle _x}count thislist > 0", "nul = [thisTrigger] spawn EZM_TriggerLoop;", ""];

if (_showTriggerOnMap) then {
	//circle
	_marker = createmarker [format["Zombies-pos-%1,%2",(_triggerPosition select 0),(_triggerPosition select 1)], _triggerPosition];
	_marker setMarkerShape "ELLIPSE";
	_marker setMarkerSize [_triggerRadius, _triggerRadius];
	_marker setMarkerAlpha _zMarkerAlpha;
	_marker setMarkerColor _zMarkerColor;
	_marker setMarkerBrush _zMarkerBrush;
	//dot and text
	if !(_zMarkerText == "") then 
	{
		_marker2 = createmarker [format["Zombies-pos-%1,%2-2",(_triggerPosition select 0),(_triggerPosition select 1)], _triggerPosition];
		_marker2 setMarkerShape "ELLIPSE";

		_marker2 setMarkerSize [_triggerRadius, _triggerRadius];
		_marker2 setMarkerColor "ColorBlack";
		_marker2 setMarkerBrush "Border";
		
		_marker3 = createmarker [format["Zombies-pos-%1,%2-3",(_triggerPosition select 0),(_triggerPosition select 1)], _triggerPosition];
		_marker3 setMarkerShape "ICON";
		_marker3 setMarkerColor "ColorWhite";
		_marker3 setMarkerType "KIA";
		_marker3 setMarkerText _zMarkerText;
	};
};


if (EZM_Debug) then
{
	diag_log format["ExileZ Mod: Creating Trigger	|	Position : %1 	|	Radius : %2m	|	Near : %3 ",_triggerPosition,_triggerRadius,_nearestLocation];
};

// Store Variables in the trigger.

_trigger setvariable ["groupSize", _groupSize, False];

_trigger setvariable ["vestGroup",_vestGroup, False];
_trigger setvariable ["lootGroup",_lootGroup, False];
_trigger setvariable ["zombieGroup",_zombieGroup, False];

_trigger setvariable ["spawnDelay",_spawnDelay, False];
_trigger setvariable ["respawnDelay",_respawnDelay, False];


// Spawn Mission sqf
if !(isnil "_mission") then
{
	nul = [] spawn _mission;
};

// Spawn loot box
if !(isnil "_lootBox") then
{
	nul = [_triggerPosition] spawn _lootBox;
};