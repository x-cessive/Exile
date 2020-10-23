 /*
 *
 * Author: Andrew_S90
 *
 * This work is protected by Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International (CC BY-NC-SA 4.0). 
 *
 */
 
private ["_responseCode", "_itemClassName", "_containerType", "_containerNetID", "_containersBefore", "_vehicle", "_dialog", "_listBox"];
_responseCode = _this select 0;
ExileClientPlayerBarterMasterList = _this select 1;
_playerBarterOfferItems = _this select 2;

ExileClientIsWaitingForServerTradeResponse = false;
ExileClientPlayerBarterOfferItems = [];
ExileClientPlayerInventoryOfferItems = [];
if (_responseCode isEqualTo 0) then
{
	ExileClientPlayerTradedItems append _playerBarterOfferItems;
	_newTradedItems = [];
	_combined = [];
	_added = false;
	
	{
		_index = _forEachIndex;
		_itemInfo = _x;
		{
			if((_index != _forEachIndex) && ((_itemInfo select 0) isEqualTo (_x select 0)) && !((_itemInfo select 0) in _combined)) then
			{
				_newTradedItems pushBack [(_x select 0),((_itemInfo select 1) + (_x select 1))];
				_combined pushBack (_x select 0);
				_added = true;
			};
		} forEach ExileClientPlayerTradedItems;
		if (!_added && !((_itemInfo select 0) in _combined)) then
		{
			_newTradedItems pushBack [(_x select 0),(_x select 1)];
		};
		_added = false;
	} forEach ExileClientPlayerTradedItems;
	
	ExileClientPlayerTradedItems = _newTradedItems;
	
	["SuccessTitleAndText", ["Trade Completed!", "Pick up your items at any barter!"]] call ExileClient_gui_toaster_addTemplateToast;

	_dialog = uiNameSpace getVariable ["RscExileBarterDialog", displayNull];
	if !(_dialog isEqualTo displayNull) then
	{
		(_dialog displayCtrl 2012) progressSetPosition 0;
		(_dialog displayCtrl 2015) progressSetPosition 0;
		(_dialog displayCtrl 2012) ctrlSetTextColor [1, 1, 1, 1];
		(_dialog displayCtrl 2015) ctrlSetTextColor [1, 1, 1, 1];
		
		true call ExileClient_gui_barterDialog_updateWithdrawListBox;
		true call ExileClient_gui_barterDialog_updateListBox;
		
		_barterListBox = _dialog displayCtrl 2010;
		_barterListBox lbSetCurSel -1;
		
		_inventoryListBox = _dialog displayCtrl 2013;
		_inventoryListBox lbSetCurSel -1;
		
		_inventoryOfferListBox = _dialog displayCtrl 2016;
		_inventoryOfferListBox lbSetCurSel -1;
		
		_barterOfferListBox = _dialog displayCtrl 2018;
		_barterOfferListBox lbSetCurSel -1;
	};
}
else 
{
	ExileClientPlayerTradedItems append _playerBarterOfferItems;
	["ErrorTitleAndText", ["Whoops!", format ["Something went really wrong. Please tell a server admin that you have tried to barter for items and tell them the code '%1'. Thank you!", _responseCode]]] call ExileClient_gui_toaster_addTemplateToast;
};