 /*
 *
 * Author: Andrew_S90
 *
 * This work is protected by Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International (CC BY-NC-SA 4.0). 
 *
 */
 
private ["_itemClassName", "_dialog", "_barterListBox", "_newBarterItems", "_itemQuantity", "_indexEntryIndex", "_configName", "_qualityColor", "_popTabColor", "_imageColor"];
_itemClassName = _this;
_dialog = uiNameSpace getVariable ["RscExileBarterDialog", displayNull];
_barterListBox = _dialog displayCtrl 2010;

["ErrorTitleAndText", ["Trade Updated!", "You removed an item from the barter's offer!"]] call ExileClient_gui_toaster_addTemplateToast;

lbClear _barterListBox;
_newBarterItems = [];
_added = false;

{
	if (_itemClassName isEqualTo (_x select 0)) then
	{
		_newBarterItems pushBack [_itemClassName,((_x select 1) + 1)];
		_added = true;
	}
	else
	{
		_newBarterItems pushBack [(_x select 0),(_x select 1)];
	};
} forEach ExileClientPlayerBarterItems;

ExileClientPlayerBarterItems = _newBarterItems;

if !(_added) then
{
	ExileClientPlayerBarterItems pushBack [_itemClassName,1];
};

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
		