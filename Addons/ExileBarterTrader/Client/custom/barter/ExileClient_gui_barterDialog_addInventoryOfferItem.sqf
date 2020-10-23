 /*
 *
 * Author: Andrew_S90
 *
 * This work is protected by Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International (CC BY-NC-SA 4.0). 
 *
 */
 
private ["_itemClassName", "_dialog", "_inventoryOfferListBox", "_newInventoryOfferItems", "_added", "_itemQuantity", "_indexEntryIndex", "_configName", "_qualityColor", "_popTabColor", "_imageColor"];
_itemClassName = _this;
_dialog = uiNameSpace getVariable ["RscExileBarterDialog", displayNull];
_inventoryOfferListBox = _dialog displayCtrl 2016;

lbClear _inventoryOfferListBox;
_newInventoryOfferItems = [];
_added = false;
{
	if (_itemClassName isEqualTo (_x select 0)) then
	{
		_newInventoryOfferItems pushBack [_itemClassName,((_x select 1) + 1)];
		_added = true;
	}
	else
	{
		_newInventoryOfferItems pushBack [(_x select 0),(_x select 1)];
	};
} forEach ExileClientPlayerInventoryOfferItems;

ExileClientPlayerInventoryOfferItems = _newInventoryOfferItems;

if !(_added) then
{
	ExileClientPlayerInventoryOfferItems pushBack [_itemClassName,1];
};

{
	private _itemClassName = (_x select 0);
	private _itemQuantity = (_x select 1);
	private _indexEntryIndex = 1;

	_configName = _itemClassName call ExileClient_util_gear_getConfigNameByClassName;
	_indexEntryIndex = _inventoryOfferListBox lbAdd getText(configFile >> _configName >> _itemClassName >> "displayName");
	_inventoryOfferListBox lbSetPicture [_indexEntryIndex, getText(configFile >> _configName >> _itemClassName >> "picture")];
	
	_qualityColor = [1, 1, 1, 1];
	_popTabColor = [1, 1, 1, 1];
	_imageColor = [1, 1, 1, 1];
	
	_inventoryOfferListBox lbSetData [_indexEntryIndex, _itemClassName];
	_inventoryOfferListBox lbSetColor [_indexEntryIndex, _qualityColor];
	
	_inventoryOfferListBox lbSetPictureColor [_indexEntryIndex, _imageColor];
	_inventoryOfferListBox lbSetTextRight [_indexEntryIndex, format["%1", _itemQuantity]];
	_inventoryOfferListBox lbSetColorRight [_indexEntryIndex, _popTabColor];
	_inventoryOfferListBox lbSetPictureRightColor [_indexEntryIndex, _popTabColor];

} forEach ExileClientPlayerInventoryOfferItems;

if (count ExileClientPlayerInventoryOfferItems > 0) then
{
	_inventoryClear = _dialog displayCtrl 2017;
	_tradeButton = _dialog displayCtrl 2020;

	_inventoryClear ctrlEnable true;
	_inventoryClear ctrlCommit 0;
	
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
	if ((progressPosition (_dialog displayCtrl 2012)) < (progressPosition (_dialog displayCtrl 2015))) then
	{
		_loadInventory ctrlSetTextColor [0, 1, 0, 1];
	}
	else
	{
		_loadInventory ctrlSetTextColor [1, 0, 0, 1];
	};
};

_tradeButton = _dialog displayCtrl 2020;
if ((progressPosition (_dialog displayCtrl 2015)) >= (progressPosition (_dialog displayCtrl 2012))) then
{
	if (count ExileClientPlayerBarterOfferItems > 0) then
	{
		_tradeButton ctrlEnable true;
		_tradeButton ctrlCommit 0;
	}
	else
	{
		_tradeButton ctrlEnable false;
		_tradeButton ctrlCommit 0;
	};
}
else
{
	_tradeButton ctrlEnable false;
	_tradeButton ctrlCommit 0;
};
		