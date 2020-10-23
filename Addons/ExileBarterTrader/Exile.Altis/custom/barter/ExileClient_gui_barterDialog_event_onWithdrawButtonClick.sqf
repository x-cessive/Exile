 /*
 *
 * Author: Andrew_S90
 *
 * This work is protected by Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International (CC BY-NC-SA 4.0). 
 *
 */
 
private ["_dialog", "_tradedListbox", "_dropdown", "_deposit", "_withdraw", "_selectedSafeXLBIndex", "_itemClassName", "_selected", "_currentContainerType", "_containerNetID"];
disableSerialization;

_dialog = uiNameSpace getVariable ["RscExileBarterDialog", displayNull];
_tradedListbox = _dialog displayCtrl 5002;
_withdraw = _dialog displayCtrl 5003;
_dropdown = _dialog displayCtrl 5004;

_withdraw ctrlEnable false;
_withdraw ctrlCommit 0;
_dropdown ctrlEnable false;
_dropdown ctrlCommit 0;


_selectedIndex = lbCurSel _tradedListbox;
if !(_selectedIndex isEqualTo -1) then
{
	_itemClassName = _tradedListbox lbData _selectedIndex;
	if !(_itemClassName isEqualTo "") then
	{
		if !(ExileClientIsWaitingForServerTradeResponse) then
		{
			_selected = lbCurSel _dropdown;
			_currentContainerType = _dropdown lbValue _selected;
			_containerNetID = "";
			if (_currentContainerType isEqualTo 2) then
			{
				_containerNetID = _dropdown lbData _selected;
			};
			ExileClientIsWaitingForServerTradeResponse = true;
			["withdrawTradeItemRequest", [_itemClassName, _currentContainerType, _containerNetID,ExileClientPlayerTradedItems]] call ExileClient_system_network_send;

		};
	};
};
true