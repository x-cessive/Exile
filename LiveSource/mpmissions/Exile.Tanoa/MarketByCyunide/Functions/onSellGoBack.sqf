private["_display","_slidesControlGroup","_slideControl","_configName","_itemDisplayName","_buffItem","_index","_buffData"];
disableSerialization;
_display = uiNameSpace getVariable ["RscExileXM8", displayNull];
_slidesControlGroup = _display displayCtrl 4007;
// XCSV 2026-08-11: guarded. 85150 is created by the Player Market's own open
// path, so this was making a DUPLICATE control on the same idc every time the
// player backed out of the Sell page. displayCtrl then finds only one of the
// two and the other is an orphan covering the tablet - RscExileXM8Slide is
// 0.85 x 0.76 and ctrlCreate ignores show = false, so it is visible at 0,0 and
// above the six XCSV app slides in 4007's child order, eating their clicks.
_slideControl = _display displayCtrl 85150;
if (isNull _slideControl) then {
	_slideControl = _display ctrlCreate ["XM8SlideCyunide", 85150, _slidesControlGroup];
};
['cyMachine', 1] call ExileClient_gui_xm8_slide; 
[] execVM 'MarketByCyunide\Functions\onOpen.sqf';