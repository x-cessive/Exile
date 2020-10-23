 /*
 *
 * Author: Andrew_S90
 *
 * This work is protected by Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International (CC BY-NC-SA 4.0). 
 *
 */
 
private ["_dialog", "_barterListBox", "_barterOfferListBox", "_inventoryListBox", "_inventoryOfferListBox", "_itemClassName", "_itemQuantity", "_indexEntryIndex", "_configName", "_qualityColor", "_popTabColor", "_imageColor", "_list", "_add", "_blocked"];
disableSerialization;

if (count ExileClientPlayerTradedItems > 0) then
{
	_dialog = uiNameSpace getVariable ["RscExileBarterDialog", displayNull];
	
	["ErrorTitleAndText", ["Warning!", "Traded items will only save until restart!"]] call ExileClient_gui_toaster_addTemplateToast;

	_withdrawBackground = _dialog displayCtrl 5000;
	_withdrawTitle = _dialog displayCtrl 5001;
	_withdrawLB = _dialog displayCtrl 5002;
	_withdrawButton = _dialog displayCtrl 5003;
	_withdrawDropdown = _dialog displayCtrl 5004;

	_withdrawBackground ctrlEnable true;
	_withdrawTitle ctrlEnable true;
	_withdrawLB ctrlEnable true;
	_withdrawButton ctrlEnable false;
	_withdrawDropdown ctrlEnable false;
	
	_withdrawBackground ctrlShow true;
	_withdrawTitle ctrlShow true;
	_withdrawLB ctrlShow true;
	_withdrawButton ctrlShow true;
	_withdrawDropdown ctrlShow true;
	
	_withdrawBackground ctrlCommit 0;
	_withdrawTitle ctrlCommit 0;
	_withdrawLB ctrlCommit 0;
	_withdrawButton ctrlCommit 0;
	_withdrawDropdown ctrlCommit 0;

	lbClear _withdrawLB;

	{
		_itemClassName = (_x select 0);
		_itemQuantity = (_x select 1);
		_indexEntryIndex = 1;

		_configName = _itemClassName call ExileClient_util_gear_getConfigNameByClassName;
		_indexEntryIndex = _withdrawLB lbAdd getText(configFile >> _configName >> _itemClassName >> "displayName");
		_withdrawLB lbSetPicture [_indexEntryIndex, getText(configFile >> _configName >> _itemClassName >> "picture")];
					
		_qualityColor = [1, 1, 1, 1];
		_popTabColor = [1, 1, 1, 1];
		_imageColor = [1, 1, 1, 1];
					
		_withdrawLB lbSetData [_indexEntryIndex, _itemClassName];
		_withdrawLB lbSetColor [_indexEntryIndex, _qualityColor];
					
		_withdrawLB lbSetPictureColor [_indexEntryIndex, _imageColor];
		_withdrawLB lbSetTextRight [_indexEntryIndex, format["%1", _itemQuantity]];
		_withdrawLB lbSetColorRight [_indexEntryIndex, _popTabColor];
		_withdrawLB lbSetPictureRightColor [_indexEntryIndex, _popTabColor];

	} forEach ExileClientPlayerTradedItems;
	
	lbClear _withdrawDropdown;
	_index = _withdrawDropdown lbAdd "Player";
	_withdrawDropdown lbSetValue [_index, 1];
	_withdrawDropdown lbSetCurSel 0;
	_nearVehicles = nearestObjects [player, ["LandVehicle", "Air", "Ship"], 80];
	{
		if (local _x) then
		{
			if (alive _x) then
			{
				_index = _withdrawDropdown lbAdd getText(configFile >> "CfgVehicles" >> (typeOf _x) >> "displayName");
				_withdrawDropdown lbSetData [_index, netId _x];
				_withdrawDropdown lbSetValue [_index, 2];
			};
		};
	}
	forEach _nearVehicles;
};