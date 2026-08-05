/**
 * ExileClient_object_player_initialize
 *
 * Merged override for:
 * - Anti-Floor Peeking Fix (MGTDB)
 * - Anti-UAV Stealing / Static Weapon Assembly Ownership Fix (MGTDB)
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

// Exile Expansion / Scavenge.
//
// This line was LOST when the Anti-Floor-Peeking and Anti-UAV-Stealing
// overrides were merged into this file. Three overrides all wanted
// ExileClient_object_player_initialize; two of them made it into the merge and
// Scavenge silently did not. CfgExileCustomCode registers THIS file, so the
// copy under custom\scavenge\Exile_Client_Overrides\ is never loaded and no
// scavenge hold-action has ever appeared in game.
//
// If another addon ever wants this function, merge it here too -- do not add a
// second registration, only one can win.
[] call ExileExpansionClient_system_scavenge_initialize;

enableSentences false;
enableRadio false;
player setVariable ["BIS_noCoreConversations", true];
player disableConversation true;
player setSpeaker "NoVoice";
showSubtitles false;

// No Floor Peeking Fix
client_currentAnimation = animationState player;

// Anti UAV / Static Weapon Hijack Fix
player addEventHandler ["WeaponAssembled", {
	params ["_unit", "_staticWeapon"];
	clearItemCargoGlobal _staticWeapon;
	_staticWeapon setVariable ["ExileOwnerUID", getPlayerUID player, true];
	_staticWeapon enableSimulationGlobal true;
	_staticWeapon setOwner (owner player);
}];

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
true
