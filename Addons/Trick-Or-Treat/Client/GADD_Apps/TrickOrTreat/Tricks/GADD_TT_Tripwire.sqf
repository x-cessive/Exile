/**
	Name: GADD_TT_Tripwire
	Description: This is one of the Tricks for players.
	Author: [GADD]Monkeynutz
**/

["ErrorTitleAndText", ["Trick or Treat!", "Tread Carefully!"]] call ExileClient_gui_toaster_addTemplateToast; 

_mine = createMine ["APERSTripMine", position player, [], 0]; 
_mine setPosATL [getPosATL player select 0, (getPosATL player select 1)+6, (getPosATL player select 2)];
_mine setDir 0;
_mine = createMine ["APERSTripMine", position player, [], 0]; 
_mine setPosATL [getPosATL player select 0, (getPosATL player select 1)-6, (getPosATL player select 2)];
_mine setDir 0;
_mine = createMine ["APERSTripMine", position player, [], 0]; 
_mine setPosATL [(getPosATL player select 0)+6, (getPosATL player select 1), (getPosATL player select 2)];
_mine setDir 90;
_mine = createMine ["APERSTripMine", position player, [], 0]; 
_mine setPosATL [(getPosATL player select 0)-6, (getPosATL player select 1), (getPosATL player select 2)];
_mine setDir 90;