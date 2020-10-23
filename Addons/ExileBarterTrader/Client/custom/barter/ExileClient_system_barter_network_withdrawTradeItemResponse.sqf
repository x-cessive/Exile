 /*
 *
 * Author: Andrew_S90
 *
 * This work is protected by Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International (CC BY-NC-SA 4.0). 
 *
 */
 
private ["_responseCode", "_itemClassName", "_containerType", "_containerNetID", "_vehicle", "_dialog", "_listBox"];
_responseCode = _this select 0;
_itemClassName = _this select 1;
_containerType = _this select 2;
_containerNetID = _this select 3;
ExileClientPlayerTradedItems = _this select 4; 
_dialog = uiNameSpace getVariable ["RscExileBarterDialog", displayNull];
if !(_dialog isEqualTo displayNull) then
{
	true call ExileClient_gui_barterDialog_updateWithdrawListBox;
	_withdrawListBox = _dialog displayCtrl 5002;
	_withdrawListBox lbSetCurSel -1;
};

ExileClientIsWaitingForServerTradeResponse = false;
if (_responseCode isEqualTo 0) then
{
	if(_itemClassName != "") then
	{
		switch (_containerType) do
		{
			case 1:
			{	
				[player, _itemClassName] call ExileClient_util_playerCargo_add;
			};
			case 2:
			{
				if(_containerNetID != "") then
				{
					_vehicle = objectFromNetId _containerNetID;
					[_vehicle, _itemClassName] call ExileClient_util_containerCargo_add;
				};
			};
			default
			{
			};
		};
		["SuccessTitleAndText", ["Item Withdrawn!", "You successfully withdrew your item."]] call ExileClient_gui_toaster_addTemplateToast;
	};
}
else 
{
	["ErrorTitleAndText", ["Whoops!", format ["Something went really wrong. Please tell a server admin that you have tried to withdraw an item and tell them the code '%1'. Thank you!", _responseCode]]] call ExileClient_gui_toaster_addTemplateToast;
};