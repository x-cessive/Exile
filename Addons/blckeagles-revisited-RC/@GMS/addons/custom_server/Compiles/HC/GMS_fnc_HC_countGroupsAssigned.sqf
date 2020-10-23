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

params["_HC"];
private["_result"];
_result = {(groupOwner _x) == (owner _HC)} count allGroups;
//diag_log format["_fnc_countGroupsAssigned = %1",_result];
_result
