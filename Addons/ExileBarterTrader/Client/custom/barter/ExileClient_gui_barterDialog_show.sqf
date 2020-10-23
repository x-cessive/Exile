 /*
 *
 * Author: Andrew_S90
 *
 * This work is protected by Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International (CC BY-NC-SA 4.0). 
 *
 */

private ["_dialog", "_dropdown", "_claim", "_index", "_nearVehicles", "_background", "_title", "_claimCode", "_edit"]; 
disableSerialization;

createDialog "RscExileBarterDialog";
waitUntil { !isNull findDisplay 47347 };
_dialog = uiNameSpace getVariable ["RscExileBarterDialog", displayNull];

ExileClientPlayerBarterItems = ExileClientPlayerBarterMasterList select _this;
ExileClientPlayerBarterNumber = _this;
ExileClientPlayerBarterItemsComplete = ExileClientPlayerBarterItems;
ExileClientPlayerBarterOfferItems = [];
ExileClientPlayerInventoryOfferItems = [];
ExileClientPlayerInventoryItems = (player call ExileClient_util_playerCargo_list);
if (isNil "ExileClientPlayerTradedItems") then 
{
	ExileClientPlayerTradedItems = [];
};

_barterClear = _dialog displayCtrl 2019;
_inventoryClear = _dialog displayCtrl 2017;
_tradeButton = _dialog displayCtrl 2020;

_barterClear ctrlEnable false;
_inventoryClear ctrlEnable false;
_tradeButton ctrlEnable false;
_barterClear ctrlCommit 0;
_inventoryClear ctrlCommit 0;
_tradeButton ctrlCommit 0;

_withdrawBackground = _dialog displayCtrl 5000;
_withdrawTitle = _dialog displayCtrl 5001;
_withdrawLB = _dialog displayCtrl 5002;
_withdrawButton = _dialog displayCtrl 5003;
_withdrawDropdown = _dialog displayCtrl 5004;

_withdrawBackground ctrlEnable false;
_withdrawTitle ctrlEnable false;
_withdrawLB ctrlEnable false;
_withdrawButton ctrlEnable false;
_withdrawDropdown ctrlEnable false;

_withdrawBackground ctrlShow false;
_withdrawTitle ctrlShow false;
_withdrawLB ctrlShow false;
_withdrawButton ctrlShow false;
_withdrawDropdown ctrlShow false;

_withdrawBackground ctrlCommit 0;
_withdrawTitle ctrlCommit 0;
_withdrawLB ctrlCommit 0;
_withdrawButton ctrlCommit 0;
_withdrawDropdown ctrlCommit 0;

true call ExileClient_gui_postProcessing_toggleDialogBackgroundBlur;
true call ExileClient_gui_barterDialog_updateWithdrawListBox;
call ExileClient_gui_barterDialog_updateListBox;
true