/*
	by Ghostrider [GRG]

	--------------------------
	License
	--------------------------
	All the code and information provided here is provided under an Attribution Non-Commercial ShareAlike 4.0 Commons License.

	http://creativecommons.org/licenses/by-nc-sa/4.0/	
*/

#include "\q\addons\custom_server\Configs\blck_defines.hpp";
//diag_log  format["_fnc_monitorVehicles: time %2 |  blck_sm_Vehicles %1",blck_sm_Vehicles,diag_tickTime];
for "_i" from 0 to (count blck_sm_Vehicles) do
{
	if (_i >= (count blck_sm_Vehicles)) exitWith {};
	private _element = blck_sm_Vehicles deleteAt 0;
	//diag_log  format["_fnc_monitorVehicles(18): _element %1",_element];
	_element params["_groupParameters","_group","_groupSpawned","_timesSpawned","_respawnAt","_maxRespawns"];
	//diag_log  format["_fnc_monitorVehicles: _groupParameters = %1",_groupParameters];
	//diag_log  format["_fnc_monitorVehicles (21): _group %1 | _groupSpawned %2 | _timesSpawned %3 | _respawnAt %4",_group,_groupSpawned,_timesSpawned,_respawnAt];
	_groupParameters params["_vehicleType","_pos","_difficulty","_patrolRadius","_respawnTime","_maxRespawns"];	
	//diag_log  format["_fnc_monitorVehicles(23): _vehicleType | %1 | _pos = %2 | _difficulty = %3 | _patrolRadius = %4 | _respawnTime = %5",_vehicleType,_pos,_difficulty,_patrolRadius,_respawnTime];
	
	if (!(isNull _group) && {alive _x} count (units _group) == 0) then
	{
		deleteGroup _group;
		_group = grpNull;
	};
	if (isNull _group) then
	{
		_mode = -1;
		if ((_timesSpawned == 0) && (_groupSpawned == 0)) then {_mode = 1};  // spawn-respawn
		if (_timesSpawned > 0) then
		{
			if ((_groupSpawned == 1) && (_respawnTime == 0)) then {_mode = 0}; // remove patrol from further evaluation
			if ((_timesSpawned > _maxRespawns) && (_maxRespawns != -1)) then {_mode = 0}; 			
			if ((_groupSpawned == 1) && (_respawnTime > 0)) then {_mode = 2}; // set up for respawn at a later time 
			if ((_groupSpawned == 0) && (diag_tickTime > _respawnAt)) then {_mode = 1};
		};
		switch (_mode) do
		{
			case 0: {};
			case 1: {
						
						if ([_pos,staticPatrolTriggerRange] call blck_fnc_playerInRange) then
						{
							// params["_coords","_noVehiclePatrols","_aiDifficultyLevel","_missionPatrolVehicles",["_useRelativePos",true],["_uniforms",[]], ["_headGear",[]],["_vests",[]],["_backpacks",[]],["_weaponList",[]],["_sideArms",[]], ["_isScubaGroup",false]];
							_return = [_pos,1,_difficulty,[_groupParameters],false] call blck_fnc_spawnMissionVehiclePatrols;
							//diag_log  format["_fnc_monitorVehicles(50): _return = %1",_return];
							_group = group ((_return select 1) select 0);
							// _element [[""Exile_Car_Offroad_Armed_Guerilla02"",[22809.5,16699.2,8.78706],""green"",600,90],O Alpha 1-1,1,1,0,-1]"
							//  _groupParameters = [""Exile_Car_Offroad_Armed_Guerilla02"",[22809.5,16699.2,8.78706],""green"",600,90]"
							_element set[patrolGroup,_group];
							_element set[groupSpawned,1];
							_element set[timesSpawned,_timesSpawned + 1];
							_element set[respawnAt,0];	
						};
						blck_sm_Vehicles pushBack _element;						
					};
			case 2: {
						_element set[respawnAt,diag_tickTime + _respawnTime];	
						_element set[groupSpawned,0];
						blck_sm_Vehicles pushBack _element;
						//diag_log  format["_fnc_monitorVehicles(63): update respawn time to %1",_respawnAt];						
					};
			default {};
		};
		//diag_log  format["_fnc_monitorVehicles(67) respawn conditions evaluated : _group = %1 | _groupSpawned = %2 | _timesSpawned = %3",_group,_groupSpawned,_timesSpawned];
	} else {
		//diag_log  format["_fnc_monitorVehicles(69): diag_tickTime = %1 | playerNearAt = %2 | _playerInRange = %3",diag_tickTime,_group getVariable["playerNearAt",-1],[_pos,staticPatrolTriggerRange] call blck_fnc_playerInRange];
		if ([_pos,staticPatrolTriggerRange] call blck_fnc_playerInRange) then
		{
			_group setVariable["playerNearAt",diag_tickTime];
			//diag_log  format["_fnc_monitorVehicles(73): playerNearAt updated to %1",_group getVariable["playerNearAt",-1]];
			blck_sm_Vehicles pushBack _element;	
		} else {
			if (diag_tickTime > (_group getVariable["playerNearAt",diag_tickTime]) + blck_sm_groupDespawnTime) then
			{
				//diag_log  format["_fnc_monitorVehicles(78): despanwing patrol for _element %1",_element];
				// _element [[""Exile_Car_Offroad_Armed_Guerilla02"",[22809.5,16699.2,8.78706],""green"",600,90],O Alpha 1-1,1,1,0,-1]"
				//  _groupParameters = [""Exile_Car_Offroad_Armed_Guerilla02"",[22809.5,16699.2,8.78706],""green"",600,90]"
				//_groupParameters set [2, {alive _x} count (units _group)];
				private _veh = vehicle (leader _group);
				{deleteVehicle _x} forEach (units _group);
				deleteGroup _group;
				[_veh] call blck_fnc_destroyVehicleAndCrew;
				_element set[groupParameters,_groupParameters];
				_element set[patrolGroup ,grpNull];
				_element set[timesSpawned,(_timesSpawned - 1)];
				_element set[groupSpawned,0];
			};
			blck_sm_Vehicles pushBack _element;			
		};
	};
};