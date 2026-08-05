/**
	Name: Trick or Treat
	Description: It's Halloween lol
	Author: [GADD]Monkeynutz
**/

_door = _this;
_uid = getPlayerUID player;
_flag = player call ExileClient_util_world_getTerritoryAtPosition;
_buildRights = _flag getVariable ["ExileTerritoryBuildRights", []];
_flagNetId = netId _flag;

if (isNull _flag) exitWith 
{
	["ErrorTitleAndText", ["Trick or Treat!", "You must be within a territory to be able to do this."]] call ExileClient_gui_toaster_addTemplateToast;
};
if (_uid in _buildRights) exitWith 
{
	["ErrorTitleAndText", ["Trick or Treat!", "You can't knock on your own door!"]] call ExileClient_gui_toaster_addTemplateToast;
};
			 
_door say3D selectRandom ["Knock1", "Knock2"];

uiSleep 3;
playSound "TrickOrTreat1";
["InfoTitleAndText", ["Trick or Treat!", "But what will it be.....?"]] call ExileClient_gui_toaster_addTemplateToast;
uiSleep 3;

["getFlagKnocked", [_flagNetId,_uid]] call ExileClient_system_network_send;
