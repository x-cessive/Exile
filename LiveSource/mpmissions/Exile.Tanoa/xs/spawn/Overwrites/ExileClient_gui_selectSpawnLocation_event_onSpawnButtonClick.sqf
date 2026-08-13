/**
 * ExileClient_gui_selectSpawnLocation_event_onSpawnButtonClick
 *
 * Exile Mod
 * www.exilemod.com
 * © 2015 Exile Mod Team
 *
 * This work is licensed under the Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 International License. 
 * To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-nd/4.0/.
 */
 
 private ["_playerChoice","_curSel","_data","_num"];
 
_playerChoice = _this select 0;

if (_playerChoice isEqualTo 1) then {

	player setVariable ["playerWantsHaloSpawn",1,true];

} else {

	player setVariable ["playerWantsHaloSpawn",0,true];
	
};

disableSerialization;
_display = uiNamespace getVariable ["xstremeGroundorHaloDialog",displayNull];
_lB = _display displayCtrl 1500;
_curSel = lbCurSel _lB;
_data = _lB lbData _curSel;
_baseName = lbText [1500, _curSel];
spawnRegistry pushBack [_baseName, time];

if(_curSel >= defaultLBsize) then
{
	_num = parseNumber _data;
	_flag = playerFlags select _num;
};

ExileClientSpawnLocationSelectionDone = true;
uiSleep 0.1;
closeDialog 1;
true
