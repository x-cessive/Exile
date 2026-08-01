/**
 * ExileClient_object_player_event_hook
 *
 * Exile Mod
 * www.exilemod.com
 * © 2015 Exile Mod Team
 *
 * This work is licensed under the Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 International License. 
 * To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-nd/4.0/.
 */
 
player addEventHandler ["Killed", { _this call ExileClient_object_player_event_onKilled}];
player addEventHandler ["Fired", { _this call ExileClient_object_player_event_onFired}];
player addEventHandler ["FiredNear", { _this call ExileClient_object_player_event_onFiredNear}];
player addEventHandler ["Explosion", { _this call ExileClient_object_player_event_onExplosion}];
player addEventHandler ["Hit", { _this call ExileClient_object_player_event_onHit}];
player addEventHandler ["HandleDamage", { _this call ExileClient_object_player_event_onHandleDamage}];
player addEventHandler ["Put", { _this call ExileClient_object_player_event_onPut}];
player addEventHandler ["Take", { _this call ExileClient_object_player_event_onTake}];
player addEventHandler ["InventoryOpened", { _this call ExileClient_object_player_event_onInventoryOpened}];
player addEventHandler ["InventoryClosed", { _this call ExileClient_object_player_event_onInventoryClosed}];
//StopMoaning Start
// _ExileClient_MinInjured_MoanThreshold = 80 // Character doesn't mean when injured if the health is greater than 80.
// By Arma/Exile default the player would already moan when the health is smaller then 90%.
player addEventHandler ["SoundPlayed", { 
  
 params ["_unit", "_soundID",["_volume","default"]]; 
 private _ExileClient_MinInjured_MoanThreshold = 80;
 if((_soundID isEqualTo 2) && {((ExileClientPlayerAttributes select 0) > _ExileClient_MinInjured_MoanThreshold)}) then {_volume = 0};
 _volume
}];
//StopMoaning End
true
