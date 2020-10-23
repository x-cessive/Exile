/**
	Name: GADD_TT_Smoke
	Description: This is one of the Tricks for players.
	Author: [GADD]Monkeynutz
**/

["ErrorTitleAndText", ["Trick or Treat!", "Let's see if you get noticed now..."]] call ExileClient_gui_toaster_addTemplateToast; 
 
_smokeColour = ["SmokeShell","SmokeShellRed","SmokeShellGreen","SmokeShellYellow","SmokeShellPurple","SmokeShellBlue","SmokeShellOrange"]; 
 
_smoke = selectRandom _smokeColour createVehicle position player;
_smoke attachTo [player, [0, 0, 0.5]];
_smoke = selectRandom _smokeColour createVehicle position player;
_smoke attachTo [player, [0, 0, 1]];
_smoke = selectRandom _smokeColour createVehicle position player;
_smoke attachTo [player, [0, 0, 1.5]];