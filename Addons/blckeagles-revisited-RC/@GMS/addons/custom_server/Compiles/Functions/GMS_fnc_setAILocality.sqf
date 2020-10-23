
/*
    blck_fnc_setAILocality
	Addapted for blckeagls from:
	DMS_fnc_SetAILocality
	Created by Defent and eraser1
	Usage:
	[
		_groupOrUnit,
		_posOrObject 		// Does not have to be defined if element 1 is a unit
	] call DMS_fnc_SetAILocality;
	Makes a random player within 3 KM of the AI unit or group the owner.
	Offloading AI will improve server performance, but the unit will no longer be local, which will limit the server's control over it.
	Could however have negative effects if target player has a potato PC.
	Returns true if a viable owner was found, false otherwise.
*/

private _AI = param [0,objNull,[objNull,grpNull]];

if (isNull _AI) exitWith
{
	diag_log format ["blckeagls ERROR :: Calling blck_fnc_SetAILocality with null parameter; _this: %1",_this];
};

private _AIType = typeName _AI;

private _pos = if (_AIType isEqualTo "OBJECT") then {_AI} else {param [1,"",[objNull,[]],[2,3]]};

if (_pos isEqualTo "") exitWith
{
	diag_log format ["blckeagls ERROR :: Calling blck_fnc_SetAILocality with invalid position; this: %1",_this];
};


private _client = objNull;

{
	if ((alive _x) && {(_x distance2D _pos)<=3000}) exitWith
	{
		_client = _x;
	};
} forEach allPlayers;


if (!isNull _client) then
{
	private _swapped = if (_AIType isEqualTo "OBJECT") then {_AI setOwner (owner _client)} else {_AI setGroupOwner (owner _client)};
	if (toLower(blck_modType) isEqualTo "exile") then
	{
		if (!_swapped) then
		{
			ExileServerOwnershipSwapQueue pushBack [_AI,_client];
		};
	};

	if (blck_ai_offload_notifyClient) then
	{
		private _msg = format ["blckeagls :: AI %1 |%2| has been offloaded to you.",_AIType,_AI];
		_msg remoteExecCall ["systemChat", _client];
		_msg remoteExecCall ["diag_log", _client];
	};
	true
}
else
{
	false
};
