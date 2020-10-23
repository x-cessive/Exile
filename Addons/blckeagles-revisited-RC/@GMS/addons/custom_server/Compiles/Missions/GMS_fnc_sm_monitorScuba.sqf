/*
	by Ghostrider [GRG]

	--------------------------
	License
	--------------------------
	All the code and information provided here is provided under an Attribution Non-Commercial ShareAlike 4.0 Commons License.

	http://creativecommons.org/licenses/by-nc-sa/4.0/	
*/

#include "\q\addons\custom_server\Configs\blck_defines.hpp";
//diag_log  format["_fnc_monitorScubaGroups: time %2 |  blck_sm_scubaGroups %1",blck_sm_scubaGroups,diag_tickTime];
if (blck_sm_scubaGroups isEqualTo []) exitWith {};
for "_i" from 0 to (count blck_sm_scubaGroups) do
{
	if (_i >= (count blck_sm_scubaGroups)) exitWith {};
	private _element = blck_sm_scubaGroups deleteAt 0;
	_element params["_groupParameters","_group","_groupSpawned","_timesSpawned","_respawnAt","_maxRespawns"];
	//diag_log  format["_fnc_monitorScubaGroups: _element %1 | _i = %2",_element,_i];
	//diag_log  format["_fnc_monitorScubaGroups: _groupParameters = %1",_groupParameters];
	//diag_log  format["_fnc_monitorScubaGroups (9): _group %1 | _groupSpawned %2 | _timesSpawned %3 | _respawnAt %4",_group,_groupSpawned,_timesSpawned,_respawnAt];
	_groupParameters params["_pos","_difficulty","_units","_patrolRadius","_respawnTime","_maxRespawns"];
	//diag_log  format["_fnc_monitorScubaGroups: _pos = %1 | _difficulty = 2 | _units = %3 | _patrolRadius = %4 | _respawnTime = %5",_pos,_difficulty,_units,_patrolRadius,_respawnTime];
	
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
			case 0: {
				//diag_log  format["_fnc_sm_monitorInfantry(46): no further respawns requested for %1",_element];
			};
			case 1: {
						if ([_pos,staticPatrolTriggerRange] call blck_fnc_playerInRange) then
						{
							private _numAI = [_units] call blck_fnc_getNumberFromRange;
							private _group = [blck_AI_Side,true] call blck_fnc_createGroup;	
							if !(isNull _group) then 
							{
							//params["_pos",["_skillLevel","red"],["_numUnits",6],["_patrolRadius",15]];
								[_group,_pos,_difficulty,_units,_patrolRadius] call blck_fnc_spawnScubaGroup;
								_element set[patrolGroup,_group];
								_element set[groupSpawned,1];
								_element set[timesSpawned,_timesSpawned + 1];
								_element set[respawnAt,0];	
							};
						};
						blck_sm_scubaGroups pushBack _element;
					};
			case 2: {
						blck_liveMissionAI pushBack[_pos,units _group,diag_tickTime]; // schedule units of group for deletion now.
						_element set[respawnAt,diag_tickTime + _respawnTime];	
						_element set[groupSpawned,0];
						blck_sm_scubaGroups pushBack _element;
						//diag_log  format["_fnc_monitorScubaGroups: update respawn time to %1",_respawnAt];						
					};
			default {};
		};
		//diag_log  format["_fnc_monitorScubaGroups(56) respawn conditions evaluated : _group = %1 | _groupSpawned = %2 | _timesSpawned = %3",_group,_groupSpawned,_timesSpawned];
	} else {
		//diag_log  format["_fnc_monitorScubaGroups: diag_tickTime = %1 | playerNearAt = %2",diag_tickTime,_group getVariable["playerNearAt",-1]];
		if ([_pos,staticPatrolTriggerRange] call blck_fnc_playerInRange) then
		{
			_group setVariable["playerNearAt",diag_tickTime];
			blck_sm_scubaGroups pushBack _element;			
			//diag_log  format["_fnc_monitorScubaGroups: playerNearAt updated to %1",_group getVariable["playerNearAt",-1]];
		} else {
			if (diag_tickTime > (_group getVariable["playerNearAt",diag_tickTime]) + blck_sm_groupDespawnTime) then
			{
				//diag_log  format["_fnc_monitorScubaGroups: despanwing patrol for _element %1",_element];
				_groupParameters set [2, {alive _x} count (units _group)];
				{[_x] call blck_fnc_deleteAI} forEach (units _group);
				deleteGroup _group;
				_element set[groupParameters,_groupParameters];
				_element set[patrolGroup ,grpNull];
				_element set[timesSpawned,(_timesSpawned - 1)];
				_element set[groupSpawned,0];
			};
			blck_sm_scubaGroups pushBack _element;
		};
	};
};
