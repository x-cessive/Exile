/**
	Name: GADD_TT_Bombs
	Description: This is one of the Tricks for players.
	Author: [GADD]Monkeynutz
**/

["ErrorTitleAndText", ["Trick or Treat!", "Did somebody say... Bombs? RUN!!!"]] call ExileClient_gui_toaster_addTemplateToast;

uiSleep 1;
"Bo_GBU12_LGB" createVehicle [getPosATL player select 0, (getPosATL player select 1) -150, (getPosATL player select 2) + 200];
uiSleep 1;
"Bo_GBU12_LGB" createVehicle [getPosATL player select 0, (getPosATL player select 1) -165, (getPosATL player select 2) + 200];
uiSleep 1;
"Bo_GBU12_LGB" createVehicle [(getPosATL player select 0) +10, (getPosATL player select 1) -165, (getPosATL player select 2) + 200];
uiSleep 1;
"Bo_GBU12_LGB" createVehicle [(getPosATL player select 0) -10, (getPosATL player select 1) -165, (getPosATL player select 2) + 200];