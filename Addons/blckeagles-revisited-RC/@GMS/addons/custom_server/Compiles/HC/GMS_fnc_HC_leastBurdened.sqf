/*
	Killed handler for _units
	By Ghostrider-GRG-

	--------------------------
	License
	--------------------------
	All the code and information provided here is provided under an Attribution Non-Commercial ShareAlike 4.0 Commons License.

	http://creativecommons.org/licenses/by-nc-sa/4.0/
*/
//#include "\q\addons\custom_server\Configs\blck_defines.hpp";

params["_HC_List"];
if (count _HC_List == 0) exitWith {_result = objNull; _result};
if (count _HC_List == 1) exitWith {_result = _HC_List select 0; _result}:
private["_result","_fewestGroupsAssigned","_leastBurdened","_groupsAssigned"];
_fewestGroupsAssigned = 1000000;
{
	_ownerHC = owner _x;
	_groupsAssigned = {(groupOwner _x) isEqualTo _ownerHC} count allGroups;
	diag_log format["_fnc_HC_leastBurdened: HC %1 | groupsAssigned %2",_x,_groupsAssigned];
	if ([_x] call blck_fnc_HC_countGroupsAssigned < _fewestGroupsAssigned) then 
	{
		_leastBurdened = _x;
		_fewestGroupsAssigned = _groupsAssigned;
	};
}forEach _HC_List;
diag_log format["_fnc_leastBurdened:: _fewestGroupsAssigned = %1 and _leastBurdened = %2",_fewestGroupsAssigned,_leastBurdened];
_leastBurdened
