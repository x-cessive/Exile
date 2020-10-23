/*
	Author: original by Vampire, completely rewritten by IT07

	Description:
	spawns VEMFr AI using given _this0 and unit/group count. Handles their inventory and transfers them to a client

	Params:
	_this select 0: POSITION - where to spawn the units around
	_this select 1: SCALAR - how many groups to spawn
	_this select 2: SCALAR - how many units to put in each group
	_this select 3: SCALAR - AI mode
	_this select 4: STRING - exact config name of mission or addon
	_this select 5: SCALAR - (optional) altitude to create units at
	_this select 6: SCALAR - (optional) spawn radius

	Returns:
	ARRAY with group(s)
*/

params [ "_this0", "_this1", "_this2", "_this3", "_this4", "_this5", "_this6" ];

private _r = [];
private _allUnits = [];
_this0 = [ _this0 select 0, _this0 select 1, if not ( isNil "_this5" ) then { _this5 } else { 0 } ];
( [ [ "aiSkill", ( [ [ "aiSkill" ], [ "difficulty" ] ] call VEMFr_fnc_config ) select 0 ], [ "accuracy", "aimingShake", "aimingSpeed", "endurance", "spotDistance", "spotTime", "courage", "reloadSpeed", "commanding", "general" ] ] call VEMFr_fnc_config ) params [("_ccrcy"),("_mshk"),("_mspd"),("_stmn"),("_sptDst"),("_sptTm"),("_crg"),("_rldSpd"),("_cmmndng"),("_gnrl")];
for "_g" from 1 to _this1 do
	{
		private _grp = createGroup ( ( ( [ [ call VEMFr_fnc_whichMod ], [ "unitClass" ] ] call VEMFr_fnc_config ) select 0 ) call VEMFr_fnc_checkSide );
		_grp allowFleeing 0;
		for "_u" from 1 to _this2 do
			{
				private _unit = _grp createUnit [ ( [ [ call VEMFr_fnc_whichMod ], [ "unitClass" ] ] call VEMFr_fnc_config ) select 0, _this0, [], if not ( isNil "_this6" ) then { _this6 } else { 0 }, "FORM" ];
				_allUnits pushBack _unit;
				_unit addMPEventHandler [ "mpkilled", "if isDedicated then { [ _this select 0 ] ExecVM ( 'handleKillCleanup' call VEMFr_fnc_scriptPath ); [ _this select 0, name (_this select 0), _this select 1, name (_this select 1) ] ExecVM ( 'handleKillReward' call VEMFr_fnc_scriptPath ); ( _this select 0 ) removeAllEventHandlers 'MPKilled' }" ];
				// Set skills
				_unit setSkill [ "aimingAccuracy" , _ccrcy ];
				_unit setSkill [ "aimingShake", _mshk ];
				_unit setSkill [ "aimingSpeed", _mspd ];
				_unit setSkill [ "endurance", _stmn ];
				_unit setSkill [ "spotDistance", _sptDst ];
				_unit setSkill [ "spotTime", _sptTm ];
				_unit setSkill [ "courage", _crg ];
				_unit setSkill [ "reloadSpeed", _rldSpd ];
				_unit setSkill [ "commanding", _cmmndng ];
				_unit setSkill [ "general", _gnrl ];

				_unit enableAI "TARGET";
				_unit enableAI "AUTOTARGET";
				_unit enableAI "MOVE";
				_unit enableAI "ANIM";
				_unit disableAI "TEAMSWITCH";
				_unit enableAI "FSM";
				_unit enableAI "AIMINGERROR";
				_unit enableAI "SUPPRESSION";
				_unit enableAI "CHECKVISIBLE";
				_unit enableAI "COVER";
				_unit enableAI "AUTOCOMBAT";
				_unit enableAI "PATH";
			};
		_r pushBack _grp;
	};

[ _allUnits, _this4, _this3 ] ExecVM ( "loadInv" call VEMFr_fnc_scriptPath ); // Load the AI's inventory

_r
