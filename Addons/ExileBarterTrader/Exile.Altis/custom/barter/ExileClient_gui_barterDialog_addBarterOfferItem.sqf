 /*
 *
 * Author: Andrew_S90
 *
 * This work is protected by Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International (CC BY-NC-SA 4.0). 
 *
 */
 
private ["_itemClassName", "_dialog", "_barterOfferListBox", "_newBarterOfferItems", "_added", "_itemQuantity", "_indexEntryIndex", "_configName", "_qualityColor", "_popTabColor", "_imageColor"];
_itemClassName = _this;
_dialog = uiNameSpace getVariable ["RscExileBarterDialog", displayNull];
_barterOfferListBox = _dialog displayCtrl 2018;

lbClear _barterOfferListBox;
_newBarterOfferItems = [];
_added = false;
{
	if (_itemClassName isEqualTo (_x select 0)) then
	{
		_newBarterOfferItems pushBack [_itemClassName,((_x select 1) + 1)];
		_added = true;
	}
	else
	{
		_newBarterOfferItems pushBack [(_x select 0),(_x select 1)];
	};
} forEach ExileClientPlayerBarterOfferItems;

ExileClientPlayerBarterOfferItems = _newBarterOfferItems;

if !(_added) then
{
	ExileClientPlayerBarterOfferItems pushBack [_itemClassName,1];
};

{
	private _itemClassName = (_x select 0);
	private _itemQuantity = (_x select 1);
	private _indexEntryIndex = 1;

	_configName = _itemClassName call ExileClient_util_gear_getConfigNameByClassName;
	_indexEntryIndex = _barterOfferListBox lbAdd getText(configFile >> _configName >> _itemClassName >> "displayName");
	_barterOfferListBox lbSetPicture [_indexEntryIndex, getText(configFile >> _configName >> _itemClassName >> "picture")];
	
	_qualityColor = [1, 1, 1, 1];
	_popTabColor = [1, 1, 1, 1];
	_imageColor = [1, 1, 1, 1];
	
	_barterOfferListBox lbSetData [_indexEntryIndex, _itemClassName];
	_barterOfferListBox lbSetColor [_indexEntryIndex, _qualityColor];
	
	_barterOfferListBox lbSetPictureColor [_indexEntryIndex, _imageColor];
	_barterOfferListBox lbSetTextRight [_indexEntryIndex, format["%1", _itemQuantity]];
	_barterOfferListBox lbSetColorRight [_indexEntryIndex, _popTabColor];
	_barterOfferListBox lbSetPictureRightColor [_indexEntryIndex, _popTabColor];

} forEach ExileClientPlayerBarterOfferItems;

if (count ExileClientPlayerBarterOfferItems > 0) then
{
	_barterClear = _dialog displayCtrl 2019;

	_barterClear ctrlEnable true;
	_barterClear ctrlCommit 0;
	
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
			_totalPriceOffer = _totalPriceOffer + (_salesPrice * (_x select 1));
		};
	} forEach ExileClientPlayerBarterOfferItems;
	
	_loadBarter = _dialog displayCtrl 2012;
	_loadBarter progressSetPosition (_totalPriceOffer / (_totalPriceBarter max 1));
};

if ((progressPosition (_dialog displayCtrl 2012)) < (progressPosition (_dialog displayCtrl 2015))) then
{
	(_dialog displayCtrl 2015) ctrlSetTextColor [0, 1, 0, 1];
}
else
{
	(_dialog displayCtrl 2015) ctrlSetTextColor [1, 0, 0, 1];
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
