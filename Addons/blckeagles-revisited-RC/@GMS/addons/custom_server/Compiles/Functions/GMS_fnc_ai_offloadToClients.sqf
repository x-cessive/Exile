/*
	blck_fnc_ai_offloadToClients
	Addapted for blckeagls from:
    DMS_fnc_AILocalityManager
	Created by Defent and eraser1
	https://github.com/Defent/DMS_Exile/wiki/DMS_fnc_AILocalityManager
	Offloads AI groups to a nearby client in order to improve server performance.
*/
private ["_groups"];
if (isNil "blck_ai_offload_to_client") exitWith {blck_ai_offload_to_client = false};
if (!blck_ai_offload_to_client) exitWith {};
if (blck_limit_ai_offload_to_blckeagls) then {_groups = blck_monitoredMissionAIGroups} else {_groups = allGroups};

#ifdef blck_debugMode
diag_log format[
	"_fnc_ai_offloadToClients: blck_ai_offload_to_client = %1 | blck_limit_ai_offload_to_blckeagls = %2 | count blck_monitoredMissionAIGroups = %3", 
	blck_ai_offload_to_client, 
	blck_limit_ai_offload_to_blckeagls, 
	count _groups
	];
#endif 

{
	//diag_log format["_fnc_ai_offloadToClients(26): _x = %1 | units _x = %2 | blck_lockLocality = %3",_x, units _x, _x getVariable["blck_LockLocality",false]];
	if (((count (units _x))>1) && {!(_x getVariable ["blck_LockLocality",false])}) then
	{
		private _leader = leader _x;
		private _group = _x;
		//diag_log format["_fnc_ai_offloadToClients(31): evaluating group _x = %1 | leader _x = %2 | blck_lockLocality = %3",_x, leader _x, _x getVariable["blck_LockLocality",false]];
		if !(isPlayer _leader) then
		{
			// Ignore Exile flyovers.
			//if (((side _group) isEqualTo independent) && {(count (units _group)) isEqualTo 1}) exitWith {};
			#ifdef blck_debugMode
			if (blck_debugOn) then
			{
				(format ["AILocalityManager :: Finding owner for group: %1",_group]) call blck_fnc_DebugLog;
			};
			#endif
			//diag_log format["_fnc_ai_offloadToClients(42): _x =%1 with owner = %2 is not a player's group so look for a home for it if still on the server",_x, groupOwner _x];
			private _groupOwner = groupOwner _group;
			private _ownerObj = objNull;
			private _isLocal = local _group;

			if !(_isLocal) then								// Only check for the group owner in players if it doesn't belong to the server.
			{
				{
					if (_groupOwner isEqualTo (owner _x)) exitWith
					{
						_ownerObj = _x;
					};
				} forEach allPlayers;
			};
			//diag_log format["_fnc_ai_offloadToClients(56): _group = %1 | _groupOwner = %2 | _ownerObj = %3 | _isLocal = %4",_group,_groupOwner,_ownerObj,_isLocal];
			// If the owner doesn't exist or is too far away...				Attempt to set a new player owner, and if none are found...	and if the group doesn't belong to the server...
			if (((isNull _ownerObj) || {(_ownerObj distance2D _leader)>3500}) && {!([_group,_leader] call blck_fnc_SetAILocality)} && {!_isLocal}) then
			{
				// Reset locality to the server
				//diag_log format["_fnc_ai_offloadToClients: setting locality of group %1 to server",_group];
				_group setGroupOwner 2;

				#ifdef blck_debugMode
				if (blck_debugOn) then
				{
					(format ["AILocalityManager :: Current owner of group %1 is too far away and no other viable owner found; resetting ownership to the server.",_group]) call DMS_fnc_DebugLog;
				};
				#endif
			};
		};
	};
} forEach _groups;