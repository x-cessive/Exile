//Tarupod Repair by crackerjack0903
if (ExileClientPlayerIsInCombat) exitWith
{
	["ErrorTitleAndText", ["Whoops!", format ["Cannot perform this action while in combat!", _responseCode]]] call ExileClient_gui_toaster_addTemplateToast;
};

//Specifies Only The Taru Pods so that no other objects clash with this script.
if (typeOf cursorTarget == "Land_Pod_Heli_Transport_04_ammo_F") then {
	if ("Exile_Item_DuctTape" in Magazines player) then
	{
		cursortarget setdamage 0;
		player removeItem "Exile_Item_DuctTape";
		player playMove "AinvPknlMstpSnonWnonDr_medic3";
		["SuccessTitleAndText", ["Pod Repaired! Using 1 DuctTape.", format ["-%1<img image='\exile_assets\texture\ui\poptab_inline_ca.paa' size='24'/>", _salesPrice]]] call ExileClient_gui_toaster_addTemplateToast;
	}
	else 
	{
		["ErrorTitleAndText", ["Whoops!", format ["You need duct tape to make repairs!", _responseCode]]] call ExileClient_gui_toaster_addTemplateToast;
	};
};
if (typeOf cursorTarget == "Land_Pod_Heli_Transport_04_covered_F") then {
	if ("Exile_Item_DuctTape" in Magazines player) then
	{
		cursortarget setdamage 0;
		player removeItem "Exile_Item_DuctTape";
		player playMove "AinvPknlMstpSnonWnonDr_medic3";
		["SuccessTitleAndText", ["Pod Repaired! Using 1 DuctTape.", format ["-%1<img image='\exile_assets\texture\ui\poptab_inline_ca.paa' size='24'/>", _salesPrice]]] call ExileClient_gui_toaster_addTemplateToast;
	}
	else 
	{
		["ErrorTitleAndText", ["Whoops!", format ["You need duct tape to make repairs!", _responseCode]]] call ExileClient_gui_toaster_addTemplateToast;
	};
};
if (typeOf cursorTarget == "Land_Pod_Heli_Transport_04_fuel_F") then {
	if ("Exile_Item_DuctTape" in Magazines player) then
	{
		cursortarget setdamage 0;
		player removeItem "Exile_Item_DuctTape";
		player playMove "AinvPknlMstpSnonWnonDr_medic3";
		["SuccessTitleAndText", ["Pod Repaired! Using 1 DuctTape.", format ["-%1<img image='\exile_assets\texture\ui\poptab_inline_ca.paa' size='24'/>", _salesPrice]]] call ExileClient_gui_toaster_addTemplateToast;
	}
	else 
	{
		["ErrorTitleAndText", ["Whoops!", format ["You need duct tape to make repairs!", _responseCode]]] call ExileClient_gui_toaster_addTemplateToast;
	};
};
if (typeOf cursorTarget == "Land_Pod_Heli_Transport_04_box_F") then {
	if ("Exile_Item_DuctTape" in Magazines player) then
	{
		cursortarget setdamage 0;
		player removeItem "Exile_Item_DuctTape";
		player playMove "AinvPknlMstpSnonWnonDr_medic3";
		["SuccessTitleAndText", ["Pod Repaired! Using 1 DuctTape.", format ["-%1<img image='\exile_assets\texture\ui\poptab_inline_ca.paa' size='24'/>", _salesPrice]]] call ExileClient_gui_toaster_addTemplateToast;
	}
	else 
	{
		["ErrorTitleAndText", ["Whoops!", format ["You need duct tape to make repairs!", _responseCode]]] call ExileClient_gui_toaster_addTemplateToast;
	};
};
if (typeOf cursorTarget == "Land_Pod_Heli_Transport_04_repair_F") then {
	if ("Exile_Item_DuctTape" in Magazines player) then
	{
		cursortarget setdamage 0;
		player removeItem "Exile_Item_DuctTape";
		player playMove "AinvPknlMstpSnonWnonDr_medic3";
		["SuccessTitleAndText", ["Pod Repaired! Using 1 DuctTape.", format ["-%1<img image='\exile_assets\texture\ui\poptab_inline_ca.paa' size='24'/>", _salesPrice]]] call ExileClient_gui_toaster_addTemplateToast;
	}
	else 
	{
		["ErrorTitleAndText", ["Whoops!", format ["You need duct tape to make repairs!", _responseCode]]] call ExileClient_gui_toaster_addTemplateToast;
	};
};	
if (typeOf cursorTarget == "Land_Pod_Heli_Transport_04_medevac_F") then {
	if ("Exile_Item_DuctTape" in Magazines player) then
	{
		cursortarget setdamage 0;
		player removeItem "Exile_Item_DuctTape";
		player playMove "AinvPknlMstpSnonWnonDr_medic3";
		["SuccessTitleAndText", ["Pod Repaired! Using 1 DuctTape.", format ["-%1<img image='\exile_assets\texture\ui\poptab_inline_ca.paa' size='24'/>", _salesPrice]]] call ExileClient_gui_toaster_addTemplateToast;
	}
	else 
	{
		["ErrorTitleAndText", ["Whoops!", format ["You need duct tape to make repairs!", _responseCode]]] call ExileClient_gui_toaster_addTemplateToast;
	};
};	
if (typeOf cursorTarget == "Land_Pod_Heli_Transport_04_bench_F") then {
	if ("Exile_Item_DuctTape" in Magazines player) then
	{
		cursortarget setdamage 0;
		player removeItem "Exile_Item_DuctTape";
		player playMove "AinvPknlMstpSnonWnonDr_medic3";
		["SuccessTitleAndText", ["Pod Repaired! Using 1 DuctTape.", format ["-%1<img image='\exile_assets\texture\ui\poptab_inline_ca.paa' size='24'/>", _salesPrice]]] call ExileClient_gui_toaster_addTemplateToast;
	}	
	else 
	{
		["ErrorTitleAndText", ["Whoops!", format ["You need duct tape to make repairs!", _responseCode]]] call ExileClient_gui_toaster_addTemplateToast;
	};
};
true



