/*
*
*  ExileClient_MostWanted_Dialog_HideBountiesTab.sqf
*  © 2016 Mezo, Shix, and WolfkillArcadia
*  This work is licensed under the Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 International License.
*  To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-nd/4.0/.
*/
private["_display","_hide"];
_display = uiNameSpace getVariable ["MostWantedDialog", displayNull];
{
    _hide = (_display displayCtrl _x);
    _hide ctrlShow false;
    ctrlEnable [_x, false];
} forEach [1501,2404,1007];
