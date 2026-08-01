/**
 * ExileClient_object_player_safezone_checkSafezone
 *
 * Exile Mod
 * www.exilemod.com
 * © 2015 Exile Mod Team
 *
 * This work is licensed under the Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 International License. 
 * To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-nd/4.0/.
 */
if!((secondaryWeapon player) isEqualTo []) then
{
	if ((secondaryWeapon player) isEqualTo "Exile_Melee_Axe") then
	{
		if !("Exile_Magazine_Swing" in (secondaryWeaponMagazine player)) then
		{
			player addSecondaryWeaponItem "Exile_Magazine_Swing";
			if (needReload player == 1) then {reload player};
		};
	};
	if ((secondaryWeapon player) isEqualTo "Exile_Melee_SledgeHammer") then
	{
		if !("Exile_Magazine_Swoosh" in (secondaryWeaponMagazine player)) then
		{
			player addSecondaryWeaponItem "Exile_Magazine_Swoosh";
			if (needReload player == 1) then {reload player};
		};
	};
	if ((secondaryWeapon player) isEqualTo "Exile_Melee_Shovel") then
	{
		if !("Exile_Magazine_Boing" in (secondaryWeaponMagazine player)) then
		{
			player addSecondaryWeaponItem "Exile_Magazine_Boing";
			if (needReload player == 1) then {reload player};
		};
	};
};
if !(ExilePlayerInSafezone) then 
{
	if ((getPosATL (vehicle player)) call ExileClient_util_world_isInTraderZone) then 
	{
		[] call ExileClient_object_player_event_onEnterSafezone; 
	};
	ExileClientPlayerLastSafeZoneCheckAt = diag_tickTime;
}
else 
{
	if (diag_tickTime - ExileClientPlayerLastSafeZoneCheckAt >= 30) then
	{
		if !((vehicle player) call ExileClient_util_world_isInTraderZone) then 
		{
			[] call ExileClient_object_player_event_onLeaveSafezone; 
		};
		ExileClientPlayerLastSafeZoneCheckAt = diag_tickTime;
	};
};