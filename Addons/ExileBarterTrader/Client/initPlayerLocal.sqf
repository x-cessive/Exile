
private ['_code', '_function', '_file'];
{
    _code = '';
    _function = _x select 0;
    _file = _x select 1;
    _code = compileFinal (preprocessFileLineNumbers _file);
    missionNamespace setVariable [_function, _code];
}
forEach
[
	//barter
	['ExileClient_gui_barterDialog_addBarterItem','custom\barter\ExileClient_gui_barterDialog_addBarterItem.sqf'],
	['ExileClient_gui_barterDialog_addBarterOfferItem','custom\barter\ExileClient_gui_barterDialog_addBarterOfferItem.sqf'],
	['ExileClient_gui_barterDialog_addInventoryItem','custom\barter\ExileClient_gui_barterDialog_addInventoryItem.sqf'],
	['ExileClient_gui_barterDialog_addInventoryOfferItem','custom\barter\ExileClient_gui_barterDialog_addInventoryOfferItem.sqf'],
	['ExileClient_gui_barterDialog_event_onBarterDoubleClick','custom\barter\ExileClient_gui_barterDialog_event_onBarterDoubleClick.sqf'],
	['ExileClient_gui_barterDialog_event_onBarterOfferDoubleClick','custom\barter\ExileClient_gui_barterDialog_event_onBarterOfferDoubleClick.sqf'],
	['ExileClient_gui_barterDialog_event_onClearBarterButtonClick','custom\barter\ExileClient_gui_barterDialog_event_onClearBarterButtonClick.sqf'],
	['ExileClient_gui_barterDialog_event_onClearInventoryButtonClick','custom\barter\ExileClient_gui_barterDialog_event_onClearInventoryButtonClick.sqf'],
	['ExileClient_gui_barterDialog_event_onDropDownSelectionChanged','custom\barter\ExileClient_gui_barterDialog_event_onDropDownSelectionChanged.sqf'],
	['ExileClient_gui_barterDialog_event_onInventoryDoubleClick','custom\barter\ExileClient_gui_barterDialog_event_onInventoryDoubleClick.sqf'],
	['ExileClient_gui_barterDialog_event_onInventoryOfferDoubleClick','custom\barter\ExileClient_gui_barterDialog_event_onInventoryOfferDoubleClick.sqf'],
	['ExileClient_gui_barterDialog_event_onTradeButtonClick','custom\barter\ExileClient_gui_barterDialog_event_onTradeButtonClick.sqf'],
	['ExileClient_gui_barterDialog_event_onWithdrawButtonClick','custom\barter\ExileClient_gui_barterDialog_event_onWithdrawButtonClick.sqf'],
	['ExileClient_gui_barterDialog_event_onWithdrawListBoxSelectionChanged','custom\barter\ExileClient_gui_barterDialog_event_onWithdrawListBoxSelectionChanged.sqf'],
	['ExileClient_gui_barterDialog_removeBarterItem','custom\barter\ExileClient_gui_barterDialog_removeBarterItem.sqf'],
	['ExileClient_gui_barterDialog_removeBarterOfferItem','custom\barter\ExileClient_gui_barterDialog_removeBarterOfferItem.sqf'],
	['ExileClient_gui_barterDialog_removeInventoryItem','custom\barter\ExileClient_gui_barterDialog_removeInventoryItem.sqf'],
	['ExileClient_gui_barterDialog_removeInventoryOfferItem','custom\barter\ExileClient_gui_barterDialog_removeInventoryOfferItem.sqf'],
	['ExileClient_gui_barterDialog_show','custom\barter\ExileClient_gui_barterDialog_show.sqf'],
	['ExileClient_gui_barterDialog_updateListBox','custom\barter\ExileClient_gui_barterDialog_updateListBox.sqf'],
	['ExileClient_gui_barterDialog_updateWithdrawListBox','custom\barter\ExileClient_gui_barterDialog_updateWithdrawListBox.sqf'],
	['ExileClient_system_barter_network_tradeItemsResponse','custom\barter\ExileClient_system_barter_network_tradeItemsResponse.sqf'],
	['ExileClient_system_barter_network_withdrawTradeItemResponse','custom\barter\ExileClient_system_barter_network_withdrawTradeItemResponse.sqf']
];

_trader addAction ["Hardware Barter", {2 call ExileClient_gui_barterDialog_show;},"",-5,true ,true ,"","true",3];

_trader addAction ["Weapons Barter", {1 call ExileClient_gui_barterDialog_show;},"",-5,true ,true ,"","true",3];

_trader addAction ["Community Barter", {0 call ExileClient_gui_barterDialog_show;},"",-5,true ,true ,"","true",3];

