 /*
 *
 * Author: Andrew_S90
 *
 * This work is protected by Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International (CC BY-NC-SA 4.0). 
 *
 */
 
private ["_dialog", "_barterListBox", "_barterOfferListBox", "_inventoryListBox", "_inventoryOfferListBox", "_itemClassName", "_itemQuantity", "_indexEntryIndex", "_configName", "_qualityColor", "_popTabColor", "_imageColor", "_list", "_add", "_blocked"];
disableSerialization;
_dialog = uiNameSpace getVariable ["RscExileBarterDialog", displayNull];

_barterListBox = _dialog displayCtrl 2010;
_barterOfferListBox = _dialog displayCtrl 2018;
_inventoryListBox = _dialog displayCtrl 2013;
_inventoryOfferListBox = _dialog displayCtrl 2016;

lbClear _barterListBox;
lbClear _barterOfferListBox;
lbClear _inventoryListBox;
lbClear _inventoryOfferListBox;

{
	_itemClassName = (_x select 0);
	_itemQuantity = (_x select 1);
	_indexEntryIndex = 1;

	_configName = _itemClassName call ExileClient_util_gear_getConfigNameByClassName;
	_indexEntryIndex = _barterListBox lbAdd getText(configFile >> _configName >> _itemClassName >> "displayName");
	_barterListBox lbSetPicture [_indexEntryIndex, getText(configFile >> _configName >> _itemClassName >> "picture")];
	
	_qualityColor = [1, 1, 1, 1];
	_popTabColor = [1, 1, 1, 1];
	_imageColor = [1, 1, 1, 1];
	
	_barterListBox lbSetData [_indexEntryIndex, _itemClassName];
	_barterListBox lbSetColor [_indexEntryIndex, _qualityColor];
	
	_barterListBox lbSetPictureColor [_indexEntryIndex, _imageColor];
	_barterListBox lbSetTextRight [_indexEntryIndex, format["%1", _itemQuantity]];
	_barterListBox lbSetColorRight [_indexEntryIndex, _popTabColor];
	_barterListBox lbSetPictureRightColor [_indexEntryIndex, _popTabColor];

} forEach ExileClientPlayerBarterItems;
		

_list = [uniform player,vest player,backpack player];

{
	_itemClassName = _x;
	if (!((_itemClassName splitString "_") select ((count (_itemClassName splitString "_"))-1) == "secondary")) then
	{
		_indexEntryIndex = 1;
		_add = true;
		_blocked = false;
		
		if({_x == _itemClassName} count (getArray (MissionConfigFile >> "CfgBarter" >> "Settings" >> "BlockedItems")) > 0) then
		{
			_blocked = true;
		};
		
		if(_itemClassName in _list) then 
		{
			switch (_itemClassName) do
			{
				case (uniform player):
				{
					if!(count ((uniformContainer player) call ExileClient_util_containerCargo_list) == 0) then {
						_add = false;
					};
				};
				case (vest player):
				{
					if!(count ((vestContainer player) call ExileClient_util_containerCargo_list) == 0) then {
						_add = false;
					};
				};
				case (backpack player):
				{
					if!(count ((backpackContainer player) call ExileClient_util_containerCargo_list) == 0) then {
						_add = false;
					};
				};
				default 
				{
					_add = false;
				};
			};
		};
		
		
		_configName = _itemClassName call ExileClient_util_gear_getConfigNameByClassName;
		_indexEntryIndex = _inventoryListBox lbAdd getText(configFile >> _configName >> _itemClassName >> "displayName");
		_inventoryListBox lbSetPicture [_indexEntryIndex, getText(configFile >> _configName >> _itemClassName >> "picture")];
		
		_qualityColor = [1, 1, 1, 1];
		_popTabColor = [1, 1, 1, 1];
		_imageColor = [1, 1, 1, 1];

		_inventoryListBox lbSetData [_indexEntryIndex, _itemClassName];
		_inventoryListBox lbSetColor [_indexEntryIndex, _qualityColor];
		
		_inventoryListBox lbSetPictureColor [_indexEntryIndex, _imageColor];
		_inventoryListBox lbSetColorRight [_indexEntryIndex, _popTabColor];
		_inventoryListBox lbSetPictureRightColor [_indexEntryIndex, _popTabColor];
		
		if !(_add) then 
		{
			_inventoryListBox lbSetColor [_indexEntryIndex, [0.7,0.7,0.7,1]];
			_inventoryListBox lbSetColorRight [_indexEntryIndex, [0.7,0.7,0.7,1]];
			_inventoryListBox lbSetTextRight [_indexEntryIndex, "(Empty me)"];
			_inventoryListBox lbSetData [_indexEntryIndex, "blocked"];
		};
		
		if(_blocked) then
		{
			_inventoryListBox lbSetColorRight [_indexEntryIndex, [1,0,0,1]];
			_inventoryListBox lbSetColor [_indexEntryIndex, [1,0,0,1]];
			_inventoryListBox lbSetTextRight [_indexEntryIndex, "(Blacklisted)"];
			_inventoryListBox lbSetData [_indexEntryIndex, "blocked"];
		};
	};
} forEach ExileClientPlayerInventoryItems;


