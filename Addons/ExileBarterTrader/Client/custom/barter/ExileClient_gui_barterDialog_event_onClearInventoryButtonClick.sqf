 /*
 *
 * Author: Andrew_S90
 *
 * This work is protected by Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International (CC BY-NC-SA 4.0). 
 *
 */
 
private ["_dialog", "_rewardsLB", "_claim", "_dropdown", "_selectedRewardsLBIndex", "_itemClassName", "_selected", "_currentContainerType", "_containerNetID"];
disableSerialization;

_dialog = uiNameSpace getVariable ["RscExileBarterDialog", displayNull];
_inventoryClear = _dialog displayCtrl 2017;
_tradeButton = _dialog displayCtrl 2020;
_inventoryListBox = _dialog displayCtrl 2013;
_inventoryOfferListBox = _dialog displayCtrl 2016;

lbClear _inventoryOfferListBox;
lbClear _inventoryListBox;

["ErrorTitleAndText", ["Trade Updated!", "Cleared your offer!"]] call ExileClient_gui_toaster_addTemplateToast;

_inventoryClear ctrlEnable false;
_tradeButton ctrlEnable false;
_inventoryClear ctrlCommit 0;
_tradeButton ctrlCommit 0;

ExileClientPlayerInventoryOfferItems = [];
ExileClientPlayerInventoryItems = (player call ExileClient_util_playerCargo_list);

_list = [uniform player,vest player,backpack player];

{
	_itemClassName = _x;
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

} forEach ExileClientPlayerInventoryItems;

_totalPriceBarter = 0;
{
	if (isClass (missionConfigFile >> "CfgExileArsenal" >> (_x select 0))) then
	{
		private _salesPrice = getNumber(missionConfigFile >> "CfgExileArsenal" >> (_x select 0) >> "price");
		_totalPriceBarter = _totalPriceBarter + (_salesPrice * (_x select 1));
	};
} forEach ExileClientPlayerBarterItemsComplete;

_totalPriceOffer = 0;
{
	if (isClass (missionConfigFile >> "CfgExileArsenal" >> (_x select 0))) then
	{
		private _salesPrice = getNumber(missionConfigFile >> "CfgExileArsenal" >> (_x select 0) >> "price");
		if (_salesPrice > 0) then
		{
			_salesPrice = _salesPrice * 0.5;
		}
		else
		{
			_salesPrice = 100;
		};
		_totalPriceOffer = _totalPriceOffer + (_salesPrice * (_x select 1));
	};
} forEach ExileClientPlayerInventoryOfferItems;

_loadInventory = _dialog displayCtrl 2015;
_loadInventory progressSetPosition (_totalPriceOffer / (_totalPriceBarter max 1));

if ((progressPosition (_dialog displayCtrl 2012)) <= (progressPosition (_dialog displayCtrl 2015))) then
{
	(_dialog displayCtrl 2015) ctrlSetTextColor [0, 1, 0, 1];
}
else
{
	(_dialog displayCtrl 2015) ctrlSetTextColor [1, 0, 0, 1];
};