/**
 * ExileClient_object_player_initialize
 *
 * Exile Mod
 * www.exilemod.com
 * © 2015 Exile Mod Team
 *
 * This work is licensed under the Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 International License. 
 * To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-nd/4.0/.
 */
 
private["_newPlayerObject", "_oldPlayerObject", "_goggles"];
_newPlayerObject = _this;
_oldPlayerObject = player;
_goggles = goggles _newPlayerObject;
player reveal [_newPlayerObject, 4];
selectPlayer _newPlayerObject;
[_goggles] spawn
{
	uiSleep 3;
	removeGoggles player;
	if !((_this select 0) isEqualTo "") then 
	{
		player addGoggles (_this select 0);
	};
};
if (_oldPlayerObject isKindOf "Exile_Unit_GhostPlayer") then 
{
	deleteVehicle _oldPlayerObject;
};
player setVariable ["ExileXM8IsOnline", (profileNamespace getVariable ["ExileEnable8GNetwork", false]), true];
enableSentences false;
enableRadio false;
player setVariable ["BIS_noCoreConversations", true];
player disableConversation true;
player setSpeaker "NoVoice";
showSubtitles false;
[] call ExileClient_object_player_event_hook;
ExileGasMaskNextSoundAt = diag_tickTime;
if (ExileClientGasMaskVisible) then 
{
	false call ExileClient_gui_gasMask_toggle;
};
[] call ExileClient_object_player_stats_reset;
[] call ExileClient_gui_postProcessing_reset;
[] call ExileClient_system_breathing_event_onPlayerSpawned;
[] call ExileClient_system_snow_event_onPlayerSpawned;
[] call ExileClient_system_radiation_event_onPlayerSpawned;
ExileClientIsWaitingForInventoryMoneyTransaction = false;

player addAction ["<t color='#0066cc'>Store in public garage!</t>", {["VGPublic_Store", [netId (vehicle player)]] call ExileClient_system_network_send;}, [], 1.5, false, false, "", "!ExileClientPlayerIsInCombat and {(vehicle player) != player and {speed ((vehicle player)) < 1} and {driver (vehicle player) == player} and {((position player) distance PublicVirtualGarageLocation) < PublicVirtualGarageDistance}}"]; 
player addAction ["<t color='#0066cc'>Load from public garage!</t>", {["VGPublic_Load", [netId (vehicle player)]] call ExileClient_system_network_send;}, [], 1.5, false, false, "", "!ExileClientPlayerIsInCombat and {(vehicle player) == player and {((position player) distance PublicVirtualGarageLocation) < PublicVirtualGarageDistance}}"]; 

true