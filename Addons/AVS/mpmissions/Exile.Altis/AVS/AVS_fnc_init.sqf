/*
© 2015 Zenix Gaming Ops
Developed by Rod-Serling
Co-Developed by Vishpala

All rights reserved.

Function:
	AVS_fnc_init - Initializes AVS mission file code.

Usage:
	call AVS_fnc_init;

Return Value:
	None
*/

if (isNil "AVS_Version") exitWith
{
	diag_log "AVS - Mission code initialization cancelled. Server code not detected.";
};

AVS_fnc_getConfigLoadout = compileFinal (preprocessFileLineNumbers "AVS\AVS_fnc_getConfigLoadout.sqf");

if (AVS_RearmSystemActive) then
{
	diag_log "AVS Rearm System active.";
	AVS_fnc_getRearmCost = compileFinal (preprocessFileLineNumbers "AVS\AVS_fnc_getRearmCost.sqf");
	AVS_fnc_getVehicleLoadout = compileFinal (preprocessFileLineNumbers "AVS\AVS_fnc_getVehicleLoadout.sqf");
	AVS_fnc_rearmTurret = compileFinal (preprocessFileLineNumbers "AVS\AVS_fnc_rearmTurret.sqf");
	AVS_fnc_requestRearm = compileFinal (preprocessFileLineNumbers "AVS\AVS_fnc_requestRearm.sqf");
	AVS_fnc_setPlayerMoney = compileFinal (preprocessFileLineNumbers "AVS\AVS_fnc_setPlayerMoney.sqf");
	AVS_fnc_updateInteractionMenu = compileFinal (preprocessFileLineNumbers "AVS\AVS_fnc_updateInteractionMenu.sqf");

	diag_log format ["!hasInterfaction: %1; isServer: %2", !hasInterface, isServer];
	if (!hasInterface || isServer) then
	{
		diag_log "AVS - Mission code initialized.";
	}
	else
	{
		// Client-side only stuff.
		AVS_fnc_getConfigLoadout = compileFinal (preprocessFileLineNumbers "AVS\AVS_fnc_getConfigLoadout.sqf");	// Server already processed this file.
		[] spawn AVS_fnc_updateInteractionMenu;
		diag_log format ["AVS - Client code version %1 initialized.", AVS_Version];
	};
};