 /*
 *
 * Author: Andrew_S90
 *
 * This work is protected by Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International (CC BY-NC-SA 4.0). 
 *
 */
 
private ["_listBox", "_index", "_dialog", "_withdrawListBox"];
disableSerialization;

_listBox = _this select 0;
_index = _this select 1;
_dialog = uiNameSpace getVariable ["RscExileBarterDialog", displayNull];
_withdrawListBox = _dialog displayCtrl 5002;
_withdrawListBox lbSetCurSel -1;
true