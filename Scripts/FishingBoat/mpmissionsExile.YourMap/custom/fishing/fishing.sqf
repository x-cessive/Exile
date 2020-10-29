/*
 Basic fishing script for exile by JackFrost, modify by Serveratze [Fishing Boat]
*/

diag_log format['A Player starting fishing'];


if (isNil {alreadyFishing}) then  {
	alreadyFishing = 0;
};


if (alreadyFishing == 1) exitWith {
	
	["ErrorTitleAndText",["Fishing Info", "You're already fishing"]] call ExileClient_gui_toaster_addTemplateToast;
	
};

alreadyFishing = 1;

timeFishing = 12; // time to wait while throw the net

private["_fisharray"];

if (ExileClientPlayerIsInCombat) exitWith
{
	[
	    "ErrorTitleAndText", 
	    ["Fishing Info", "You are in combat!"]
	] call ExileClient_gui_toaster_addTemplateToast;
		alreadyFishing = 0
};
if (ExilePlayerInSafezone) exitWith
{
 	[
	    "ErrorTitleAndText", 
	    ["Fishing Info", "Please leave the safezone first!"]
	] call ExileClient_gui_toaster_addTemplateToast;
		alreadyFishing = 0
};
if (speed vehicle player >= 5) exitwith
{ 
    [
	    "ErrorTitleAndText",
	    ["Fishing Info", "You are moving too fast to throw your net!"]
	] call ExileClient_gui_toaster_addTemplateToast;
		alreadyFishing = 0
};
if (speed vehicle player <= -5) exitwith
{ 
    [
	    "ErrorTitleAndText",
		["Fishing Info", "You are moving too fast to throw your net!"]
	] call ExileClient_gui_toaster_addTemplateToast;
		alreadyFishing = 0
};
if !("Exile_Item_BurlapSack" in magazines player) exitwith
{ 
    [
	    "ErrorTitleAndText",
		["Fishing Info", "You need a burlap sack to be able to fish!"]
    ] call ExileClient_gui_toaster_addTemplateToast;
		alreadyFishing = 0
};
if !(vehicle player isKindOf "Ship") exitwith
{ 
    [
	    "ErrorTitleAndText",
	    ["Fishing Info", "You must be in a boat to fish!"]
	] call ExileClient_gui_toaster_addTemplateToast;
		alreadyFishing = 0
};
if (abs (getTerrainHeightASL getPos player) <= 30) exitwith 
{ 
    [
        "ErrorTitleAndText", 
        [ "No catches here!", "You will have to go to deeper waters to find bigger fish!" ]
    ] call ExileClient_gui_toaster_addTemplateToast;
        alreadyFishing = 0
}; 
if ("Exile_Item_BurlapSack" in magazines player) then {
  
		["You throw your net"] spawn ExileClient_gui_baguette_show;
  
	while
		{	
			timeFishing > 0 && speed vehicle player <= 5 && speed vehicle player >= -5
		}
		do
			{
				timeFishing = timeFishing-1;
				sleep 1;
			
				if (timeFishing == 0)then
					{
						completed = 1;
					}
				else
					{
						completed = 0};
			};
		
	if (completed == 1) then
		{	
			fishingChance = random 1;
				
			if (fishingChance > 0.85) then
				{
					_fisharray =[
	                    "Exile_Item_Catsharkfilet_Raw",
	                    "Exile_Item_MackerelFilet_Raw",
	                    "Exile_Item_MackerelFilet_Raw",
	                    "Exile_Item_MackerelFilet_Raw",
	                    "Exile_Item_MulletFilet_Raw",
	                    "Exile_Item_MulletFilet_Raw",
	                    "Exile_Item_MulletFilet_Raw",
	                    "Exile_Item_OrnateFilet_Raw",
	                    "Exile_Item_OrnateFilet_Raw",
	                    "Exile_Item_OrnateFilet_Raw",
	                    "Exile_Item_TunaFilet_Raw",
	                    "Exile_Item_SalemaFilet_Raw",
	                    "Exile_Item_SalemaFilet_Raw",
	                    "Exile_Item_SalemaFilet_Raw",
	                    "Exile_Item_TurtleFilet_Raw"
						] call BIS_fnc_selectRandom;
					["You've got something"] spawn ExileClient_gui_baguette_show;
						sleep 3;
					["ErrorTitleAndText",["Fishing Info", "Gutting"]] call ExileClient_gui_toaster_addTemplateToast; 
						sleep 3;
					["ErrorTitleAndText",["Fishing Info", "Done!"]] call ExileClient_gui_toaster_addTemplateToast; 
						sleep 2;
						player addItem _fisharray;
					
				}
			else			
				{
					["You didn't catch anything"] spawn ExileClient_gui_baguette_show;
				};
			
			if (random 1 > 0.98) then
				{
					player removeItem "Exile_Item_BurlapSack";
					[
					"InfoTitleAndText",
					["Fishing Info", "You've lost the net!"]
					] call ExileClient_gui_toaster_addTemplateToast;
						alreadyFishing = 0
				};
		}
		else
		{
		    ["ErrorTitleAndText",["Fishing Info", "You cannot move while fishing"]] call ExileClient_gui_toaster_addTemplateToast;
			alreadyFishing = 0
		}
};

alreadyFishing = 0;
