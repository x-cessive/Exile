/*
	By Ghostrider-GRG-

	--------------------------
	License
	--------------------------
	All the code and information provided here is provided under an Attribution Non-Commercial ShareAlike 4.0 Commons License.

	http://creativecommons.org/licenses/by-nc-sa/4.0/
*/
//#include "\q\addons\custom_server\Configs\blck_defines.hpp";

if (!isServer) exitWith {};
blck_fnc_countGroupsAssigned = {
	params["_HC"];
	private["_result"];
	_result = {(groupOwner _x) == (owner _HC)} count allGroups;
	_result
};

private["_numTransfered","_clientId","_allGroups","_groupsOwned","_groups","_idHC","_id","_swap","_rc"];
_numTransfered = 0;
_idHC = -2;
if (blck_limit_ai_offload_to_blckeagls) then {_groups = blck_monitoredMissionAIGroups} else {_groups = allGroups};
blck_connectedHCs = entities "HeadlessClient_F";  
//diag_log format["_fnc_passToHCs:: blck_connectedHCs = %1 | count _HCs = %2 | server FPS = %3",blck_connectedHCs,count blck_connectedHCs,diag_fps];
if !(blck_connectedHCs isEqualTo []) then
{
	_idHC = [blck_connectedHCs] call blck_fnc_HC_leastBurdened;
	{
			if ((groupOwner _x) == 2) then 
			{
				private _sgor = _x setGroupOwner (owner _idHC);
				if (_sgor) then
				{
					[_x] remoteExec["blck_fnc_HC_XferGroup",_idHC];
					_numTransfered = _numTransfered + 1;
				};
			};
		//};
	} forEach (_groups);
};
