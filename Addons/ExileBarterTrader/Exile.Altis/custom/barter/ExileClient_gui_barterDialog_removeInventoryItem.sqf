 /*
 *
 * Author: Andrew_S90
 *
 * This work is protected by Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International (CC BY-NC-SA 4.0). 
 *
 */
 
private ["_itemClassName", "_dialog", "_inventoryListBox", "_newBarterItems", "_itemQuantity", "_indexEntryIndex", "_configName", "_qualityColor", "_popTabColor", "_imageColor"];
_itemClassName = _this;
_dialog = uiNameSpace getVariable ["RscExileBarterDialog", displayNull];
_inventoryListBox = _dialog displayCtrl 2013;

["SuccessTitleAndText", ["Trade Updated!", "You added an item as an offer!"]] call ExileClient_gui_toaster_addTemplateToast;

lbClear _inventoryListBox;
_newInventoryItems = ExileClientPlayerInventoryItems;
_done = false;
_count = 0;

{
	if ((_itemClassName isEqualTo _x) && !_done) then
	{
		_count = {_x == _itemClassName} count ExileClientPlayerInventoryItems;
		_newInventoryItems = _newInventoryItems - [_itemClassName];
		_done = true;
	};
	if (_done) exitWith {};
} forEach ExileClientPlayerInventoryItems;

if(_count > 1) then
{
	for "_i" from 1 to (_count - 1) do 
	{
		_newInventoryItems pushBack _itemClassName;
	};
};

ExileClientPlayerInventoryItems = _newInventoryItems;
_list = [uniform player,vest player,backpack player];

{
	private _itemClassName = _x;
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