 /*
 *
 * Author: Andrew_S90
 *
 * This work is protected by Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International (CC BY-NC-SA 4.0). 
 *
 */
 
private ["_dialog", "_listBox", "_control", "_index", "_canAddOffer", "_itemClassName"];
disableSerialization;

params ["_control", "_button", "_xPos", "_yPos", "_shift", "_ctrl", "_alt"];
_dialog = uiNameSpace getVariable ["RscExileBarterDialog", displayNull];
_listBox = _control;
_index = lbCurSel _listBox;
_canAddOffer = true;

if (_index > -1) then
{
	_itemClassName = _listBox lbData _index;
	
	if (_itemClassName isEqualTo "blocked") then
	{
		_canAddOffer = false;
	};
	if (ExileClientIsWaitingForServerTradeResponse) then
	{
		_canAddOffer = false;
	};
	if (_canAddOffer) then 
	{
		if (count ExileClientPlayerInventoryItems > 0) then
		{
			_itemClassName call ExileClient_gui_barterDialog_removeInventoryItem;
			_itemClassName call ExileClient_gui_barterDialog_addInventoryOfferItem;
		};
	};
}
else 
{
	systemchat "Error in loading item.";
};
true