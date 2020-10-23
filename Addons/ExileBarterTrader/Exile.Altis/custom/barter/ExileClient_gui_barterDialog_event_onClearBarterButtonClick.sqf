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
_barterClear = _dialog displayCtrl 2019;
_tradeButton = _dialog displayCtrl 2020;
_barterListBox = _dialog displayCtrl 2010;
_barterOfferListBox = _dialog displayCtrl 2018;

lbClear _barterListBox;
lbClear _barterOfferListBox;

["ErrorTitleAndText", ["Trade Updated!", "Cleared barter's offer!"]] call ExileClient_gui_toaster_addTemplateToast;

_barterClear ctrlEnable false;
_tradeButton ctrlEnable false;
_barterClear ctrlCommit 0;
_tradeButton ctrlCommit 0;

_newBarterItems = [];
_combined = [];
_added = false;

ExileClientPlayerBarterItems append ExileClientPlayerBarterOfferItems;
ExileClientPlayerBarterOfferItems = [];

{
	_index = _forEachIndex;
	_itemInfo = _x;
	{
		if((_index != _forEachIndex) && ((_itemInfo select 0) isEqualTo (_x select 0)) && !((_itemInfo select 0) in _combined)) then
		{
			_newBarterItems pushBack [(_x select 0),((_itemInfo select 1) + (_x select 1))];
			_combined pushBack (_x select 0);
			_added = true;
		};
	} forEach ExileClientPlayerBarterItems;
	if (!_added && !((_itemInfo select 0) in _combined)) then
	{
		_newBarterItems pushBack [(_x select 0),(_x select 1)];
	};
	_added = false;
} forEach ExileClientPlayerBarterItems;
ExileClientPlayerBarterItems = _newBarterItems;

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

if ((progressPosition (_dialog displayCtrl 2012)) <= (progressPosition (_dialog displayCtrl 2015))) then
{
	(_dialog displayCtrl 2015) ctrlSetTextColor [0, 1, 0, 1];
}
else
{
	(_dialog displayCtrl 2015) ctrlSetTextColor [1, 0, 0, 1];
};