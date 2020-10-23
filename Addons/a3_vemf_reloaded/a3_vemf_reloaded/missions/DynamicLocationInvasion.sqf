/*
	DynamicLocationInvasion by IT07
*/

VEMFrMissionCount = VEMFrMissionCount + 1;
if ( isNil "VEMFrInvasionCount" ) then { VEMFrInvasionCount = 0; };
VEMFrInvasionCount = VEMFrInvasionCount + 1;
_this0 = _this select 0;
if ( VEMFrInvasionCount <= ( ( [ [ "missionSettings", _this0 ], [ "maxInvasions" ] ] call VEMFr_fnc_config ) select 0 ) ) then
{
	scopeName "outer";
	_mod = call VEMFr_fnc_whichMod;

	// Define the settings
	( [
		[ "missionSettings", _this0 ],
		[ "groupCount", "groupUnits", "maxDistancePrefered", "skipDistance", "useMarker", "markCrateVisual", "markCrateOnMap", "announce", "streetLightsEnabled", "streetLightsRestore", "streetLightsRange", "allowCrateLift", "allowRepeat", "randomModes", "spawnCrateFirst", "flairTypes", "smokeTypes", "skipDistanceReversed" ]
	] call VEMFr_fnc_config ) params [ "_ms0", "_ms1", "_ms2", "_ms3", "_ms4", "_ms5", "_ms6", "_ms7", "_ms8", "_ms9", "_ms10", "_ms11", "_ms12", "_ms13", "_ms14", "_ms15", "_ms16", "_ms17" ];

	( [ [ "missionSettings", _this0, "crateParachute" ], [ "enabled", "altitude" ] ] call VEMFr_fnc_config ) params [ "_cp0", "_cp1" ];

	( [ [ "missionSettings", _this0, "mines" ], [ "enabled", "cleanup" ] ] call VEMFr_fnc_config ) params [ "_ms18", "_ms19" ];

	_l = [ "loc", false, position ( selectRandom allPlayers ), if ( _ms17 > 0 ) then { _ms17 } else { _ms3 }, _ms2, if ( _ms17 > 0 ) then { _ms17 } else { _ms3 }, _this0 ] call VEMFr_fnc_findPos;
	if not ( isNil "_l" ) then
	{
		_ln = text _l;
		_lp = position _l;
		if ( _ln isEqualTo "" ) then { _ln = "Area" };
		[ _this0, 1, format [ "invading %1...", _ln ] ] ExecVM ( "log" call VEMFr_fnc_scriptPath );

		_m = ( [ [ _mod ], [ "aiMode" ] ] call VEMFr_fnc_config ) select 0;
		if ( _ms13 isEqualTo "yes" ) then { _m = [ 0, 1, 2 ]; if ( ( "Apex" call VEMFr_fnc_modAppID ) in ( getDLCs 1 ) ) then { _m pushBack 3; _m pushBack 4 }; _m = selectRandom _m };
		if ( _ms7 isEqualTo "yes" ) then
			{
				if ( _m isEqualTo 0 ) then { [ "ColorEAST", "NEW MISSION", format [ "%1 Guerillas have invaded %2 @ %3", worldName, _ln, mapGridPosition _lp ] ] ExecVM ( "notificationToClient" call VEMFr_fnc_scriptPath ) };
				if ( _m isEqualTo 1 ) then { [ "ColorWEST", "NEW MISSION", format [ "%1 Police forces are now controlling %2 @ %3", worldName, _ln, mapGridPosition _lp ] ] ExecVM ( "notificationToClient" call VEMFr_fnc_scriptPath ) };
				if ( _m isEqualTo 2 ) then { [ "ColorGrey", "NEW MISSION", format [ "%1 Special Forces are now raiding %2 @ %3", worldName, _ln, mapGridPosition _lp ] ] ExecVM ( "notificationToClient" call VEMFr_fnc_scriptPath ) };
				if ( _m isEqualTo 3 ) then { [ "ColorWEST", "NEW MISSION", format [ "The Gendarmerie has invaded %1 @ %2", _ln, mapGridPosition _lp ] ] ExecVM ( "notificationToClient" call VEMFr_fnc_scriptPath ) };
				if ( _m isEqualTo 4 ) then { [ "ColorEAST", "NEW MISSION", format [ "%1 bandits have taken %2 @ %3", worldName, _ln, mapGridPosition _lp ] ] ExecVM ( "notificationToClient" call VEMFr_fnc_scriptPath ) };
			};

		private "_mrkr";
		if ( _ms4 isEqualTo "yes" ) then
		{ // Create/place the marker if enabled
			_mrkr = createMarker [ format [ "VEMFrMarker%1", _ln ], _lp ];
			_mrkr setMarkerShape "ICON";
			_mrkr setMarkerType "o_art";
			_mrkr setMarkerSize [ 0.85, 0.85 ];

			if ( ( _m isEqualTo 0 ) OR ( _m isEqualTo 4 ) ) then { _mrkr setMarkerColor "ColorEAST" };
			if ( ( _m isEqualTo 1 ) OR ( _m isEqualTo 3 ) ) then { _mrkr setMarkerColor "ColorWEST" };
			if ( _m isEqualTo 2 ) then { _mrkr setMarkerColor "ColorGrey" };
		};

		// If enabled, kill all the lights
		if ( _ms8 isEqualTo "no" ) then
		{
			{
				if ( ( damage _x ) < 0.95 ) then
				{
					_x setDamage 0.95;
					uiSleep 0.1;
				};
			} forEach ( nearestObjects [ _lp, [ "Lamps_Base_F", "PowerLines_base_F", "Land_PowerPoleWooden_L_F" ], _ms10 ] );
		};

		private "_crate";
		_dSpwnCrt =
		{
			// Choose a box
			_bx = selectRandom ( ( [ [ "missionSettings", _this0], [ "crateTypes" ] ] call VEMFr_fnc_config ) select 0 );
			_ps = [ _lp, 0, 200, 0, 0, 300, 0 ] call bis_fnc_findSafePos;
			if ( _cp0 isEqualTo "yes" ) then
			{
				_cht = createVehicle [ "I_Parachute_02_F", _ps, [], 0, "FLY" ];
				if ( _mod isEqualTo "Epoch" ) then { _cht call EPOCH_server_setVToken };
				_cht setPos [ ( getPos _cht ) select 0, ( getPos _cht ) select 1, _cp1 ];
				_cht enableSimulationGlobal true;

				if not ( isNull _cht ) then
				{
					_crate = createVehicle [ _bx, getPos _cht, [], 0, "NONE" ];
					_crate allowDamage false;
					_crate enableSimulationGlobal true;
					_crate attachTo [ _cht, [ 0, 0, 0 ] ];
					[ _this0, 1, format [ "crate parachuted at: %1 / Grid: %2", ( getPosATL _crate ), mapGridPosition ( getPosATL _crate ) ] ] ExecVM ( "log" call VEMFr_fnc_scriptPath );
					[ _crate, _ln, _lp ] ExecVM ( "loadLoot" call VEMFr_fnc_scriptPath );
					waitUntil { if ( ( ( getPos _crate ) select 2 ) < 7 ) then { true } else { uiSleep 1; false } };
					detach _crate;
				} else { [ _this0, 0, "where is the chute??" ] ExecVM ( "log" call VEMFr_fnc_scriptPath ) };
			} else
			{
				_crate = createVehicle [ _bx, _ps, [], 0, "NONE" ];
				_crate allowDamage false;
				[ _crate, _ln, _lp ] ExecVM ( "loadLoot" call VEMFr_fnc_scriptPath );
			};

			if ( _ms11 > 0 ) then { _crate enableRopeAttach false } else { _crate enableRopeAttach true };
		};

		if ( [ _lp, 800 ] call VEMFr_fnc_waitForPlayers ) then
		{
			_spwnd = [ _lp, _m, _this0, 200 ] call VEMFr_fnc_spawnInvasionAI;
			_nts = [ ];
			{
				[ _x ] ExecVM ( "signAI" call VEMFr_fnc_scriptPath );
				{
					_nts pushBack _x;
				} forEach ( units _x );
			} forEach ( _spwnd select 0 );

			_cl50s = _spwnd select 1;

			( [ [ "missionSettings", _this0, "heliPatrol" ], [ "enabled", "classesVanilla", "classesHeliDLC", "classesApex", "locked" ] ] call VEMFr_fnc_config ) params [ "_hp0", "_hp1", "_hp2", "_hp3", "_hp4" ];
			if ( ( _hp0 isEqualTo "yes" ) AND ( ( _m isEqualTo 1 ) OR ( _m isEqualTo 2 ) OR (_m isEqualTo 3) ) ) then
				{
					[ _this0, 1, format [ "adding a heli patrol to the invasion of %1 at %2", _ln, mapGridPosition _lp ] ] ExecVM ( "log" call VEMFr_fnc_scriptPath );
					_classes = _hp1;
					if ( ( "Heli" call VEMFr_fnc_modAppID ) in ( getDLCs 1 ) ) then { _classes append _hp2 };
					if ( ( "Apex" call VEMFr_fnc_modAppID ) in ( getDLCs 1 ) ) then { _classes append _hp3 };
					_heli = createVehicle [ selectRandom _classes, _lp, [], 5, "FLY" ];
					if ( _mod isEqualTo "Epoch" ) then { _heli call EPOCH_server_setVToken };
					_heli setPosATL [ ( getPos _heli ) select 0, ( getPos _heli ) select 1, 750 ];
					_heli flyInHeight 80;
					if ( _hp4 isEqualTo "yes" ) then { _heli lock true };

					_trrts = allTurrets [ _heli, false ];

					_hlGrp = ( [ _lp, 1, ( ( count _trrts ) + ( _heli emptyPositions "commander" ) + 1 ), _m, _this0 ] call VEMFr_fnc_spawnVEMFrAI ) select 0;
					{
						if ( ( ( _heli emptyPositions "driver" ) isEqualTo 1 ) AND ( _x isEqualTo ( leader ( group _x ) ) ) ) then { _x moveInDriver _heli }
							else
								{
									private "_path";
									{
										if ( isNull ( _heli turretUnit _x ) ) then { _path = _x };
									} forEach _trrts;

									if not ( isNil "_path" ) then { _x moveInTurret [ _heli, _path ] }
										else
											{
												if ( ( _heli emptyPositions "commander" ) > 0 ) then { _x moveInCommander _heli };
											};
								};

						if not ( ( backPack _x ) isEqualTo "" ) then { removeBackpack _x };
						_x addBackpack "B_Parachute";
						_nts pushBack _x;
					} forEach ( units _hlGrp );

					_wp = _hlGrp addWaypoint [ [ _lp select 0, _lp select 1, 50 ], 1, 1 ];
					_wp setWaypointBehaviour "AWARE";
					_wp setWaypointCombatMode "RED";
					_wp setWaypointSpeed "NORMAL";
					_wp setWaypointType "SAD";
					//_wp setWaypointLoiterType "CIRCLE";
					//_wp setWaypointLoiterRadius 200;
					_hlGrp setCurrentWaypoint _wp;

					[ _hlGrp ] ExecVM ( "signAI" call VEMFr_fnc_scriptPath );
				};

			// Place the crate if enabled
			if (_ms14 isEqualTo "yes") then { call _dSpwnCrt };

			// Place mines if enabled
			private [ "_mnsPlcd", "_mines" ];
			if ( _ms18 isEqualTo "yes" ) then
				{
					_mnsPlcd = [ _lp, 5, 100, _this0 ] call VEMFr_fnc_mines;
					if not ( isNil "_mnsPlcd" ) then { [ _this0, 1, format [ "%1 mines placed at %2", count _mnsPlcd, _ln ] ] ExecVM ( "log" call VEMFr_fnc_scriptPath ) }
					else { [ _this0, 0, format [ "failed to place %1 mines at %2", count _mnsPlcd, _ln ] ] ExecVM ( "log" call VEMFr_fnc_scriptPath ) };
				};

			// Wait for Mission Completion
			_h = [ _nts, _this0 ] ExecVM ( "killedMonitor" call VEMFr_fnc_scriptPath );
			waitUntil { if ( scriptDone _h ) then { true } else { uiSleep 1; false } };

			[ "DynamicLocationInvasion", 1, format [ "mission in %1 has been completed!", _ln ] ] ExecVM ( "log" call VEMFr_fnc_scriptPath );

			if ( _ms12 isEqualTo "yes" ) then
				{
					_u = uiNamespace getVariable "VEMFrUsedLocs";
					_u deleteAt (_u find _l);
				};

			// Broadcast
			if ( _ms7 isEqualTo "yes" ) then
				{
					if ( _m isEqualTo 0 ) then { [ "ColorEAST", "MISSION ENDED", format [ "%1 @ %2 is now clear of %3 Guerillas", _ln, mapGridPosition _lp, worldName ] ] ExecVM ( "notificationToClient" call VEMFr_fnc_scriptPath ) };
					if ( _m isEqualTo 1 ) then { [ "ColorWEST", "MISSION ENDED", format [ "%1 @ %2 is now clear of %3 Police Forces", _ln, mapGridPosition _lp, worldName ] ] ExecVM ( "notificationToClient" call VEMFr_fnc_scriptPath ) };
					if ( _m isEqualTo 2 ) then { [ "ColorGrey", "MISSION ENDED", format [ "%1 @ %2 is now clear of %3 Special Forces", _ln, mapGridPosition _lp, worldName ] ] ExecVM ( "notificationToClient" call VEMFr_fnc_scriptPath ) };
					if ( _m isEqualTo 3 ) then { [ "ColorWEST", "MISSION ENDED", format [ "%1 @ %2 is now clear of %3 Gendarmerie", _ln, mapGridPosition _lp, worldName ] ] ExecVM ( "notificationToClient" call VEMFr_fnc_scriptPath ) };
					if ( _m isEqualTo 4 ) then { [ "ColorEAST", "MISSION ENDED", format [ "%1 @ %2 is now clear of %3 bandits", _ln, mapGridPosition _lp, worldName ] ] ExecVM ( "notificationToClient" call VEMFr_fnc_scriptPath ) };
				};

			// Deal with the 50s
			if not ( isNil "_cl50s" ) then
				{
					_d = ( [ [ "missionSettings", _this0 ], [ "cal50sDelete" ] ] call VEMFr_fnc_config ) select 0;
					if ( _d isEqualTo "yes" ) then { { deleteVehicle _x } forEach _cl50s };
					if ( _d isEqualTo "destroy" ) then { { _x setDamage 1 } forEach _cl50s };
				};

			if not ( isNil "_mrkr" ) then { deleteMarker _mrkr };
			if ( _ms14 isEqualTo "no" ) then { call _dSpwnCrt };

			// Put a marker on the crate if enabled
			if not ( isNil "_crate" ) then
				{
					if not ( isNull _crate ) then
						{
							if not ( [ getPos _crate, 3 ] call VEMFr_fnc_playerNear ) then
								{
									if ( _ms5 isEqualTo "yes" ) then
										{
											// If night, attach a chemlight
											if ( sunOrMoon <= 0.35 ) then
												{
													[ _this0, 1, "attaching a chemlight to the crate" ] ExecVM ( "log" call VEMFr_fnc_scriptPath );
													_lightType = selectRandom _ms15;
													( _lightType createVehicle ( position _crate ) ) attachTo [ _crate, [ 0, 0, 0 ] ];
												} else
												{
													[ _this0, 1, "attaching smoke to the crate" ] ExecVM ( "log" call VEMFr_fnc_scriptPath );
													// Attach smoke
													_rndmColor = selectRandom _ms16;
													( createVehicle [ _rndmColor, getPos _crate, [], 0, "CAN_COLLIDE" ] ) attachTo [ _crate, [ 0, 0, 0 ] ];
												};
										};

									if ( _ms6 isEqualTo "yes" ) then
										{
											private "_mrkr";
											_mrkr = createMarker [ format [ "VEMF_lootCrate_ID%1", random 9000 ], position _crate ];
											_mrkr setMarkerShape "ICON";
											_mrkr setMarkerType "mil_box";
											_mrkr setMarkerColor "colorBlack";
											_mrkr setMarkerText " Loot";
											[ _crate, _mrkr ] spawn
												{
													_crate = _this select 0;
													_mrkr = _this select 1;
													waitUntil { if ( [ getPos _crate, 3 ] call VEMFr_fnc_playerNear ) then { true } else { uiSleep 4; false } };
													deleteMarker _mrkr;
												};
										};
								};
						} else
						{
							[ _this0, 0, "isNull _crate!" ] ExecVM ( "log" call VEMFr_fnc_scriptPath );
						};
				} else
				{
					[ _this0, 0, "isNil _crate!" ] ExecVM ( "log" call VEMFr_fnc_scriptPath );
				};


			// Explode or remove the mines
			if not ( isNil "_mnsPlcd" ) then
				{
					if ( _ms19 isEqualTo "explode" ) then
						{
							[ _this0, _ln, _mnsPlcd ] spawn
								{
									uiSleep ( 5 + ( random 2 ) );
									[ _this select 0, 1, format [ "starting to explode all %1 mines at %2", count ( _this select 2 ), _this select 1 ] ] ExecVM ( "log" call VEMFr_fnc_scriptPath );
									{
										if not ( isNull _x ) then
											{
												_x setDamage 1;
												uiSleep ( 1.25 + ( random 3.5 ) );
											};
									} forEach ( _this select 2 );
									[ _this select 0, 1, format [ "successfully exploded all %1 mines at %2", count ( _this select 2 ), ( _this select  1 ) ] ] ExecVM ( "log" call VEMFr_fnc_scriptPath );
								};

							_mnsPlcd = nil;
						};
					if ( _ms19 isEqualTo "yes" ) then
						{
							[ _mnsPlcd ] spawn
								{
									{
										if not ( isNull _x ) then { deleteVehicle _x };
									} forEach ( _this select 0 );
								};

							[ _this0, 1, format [ "successfully deleted all %1 mines at %2", count _mnsPlcd, _ln ] ] ExecVM ( "log" call VEMFr_fnc_scriptPath );
						};
				};

			// If enabled, fix all the lights
			if ( _ms9 isEqualTo "yes" ) then
				{
					{
						if ( ( damage _x ) > 0.94 ) then
						{
							_x setDamage 0;
							uiSleep ( 1 + ( random 2 ) );
						};
					} forEach ( nearestObjects [ _lp, [ "Lamps_Base_F", "PowerLines_base_F", "Land_PowerPoleWooden_L_F" ], _ms10 ] );
				};
		} else
		{ // If done waiting, and no players were detected
			[ _this0, 1, format [ "invasion of %1 @ %2 timed out.", _ln, mapGridPosition _lp ] ] ExecVM ( "log" call VEMFr_fnc_scriptPath );
			if not ( isNil "_mrkr" ) then { deleteMarker _mrkr };
			_arr = uiNamespace getVariable "VEMFrUsedLocs";
			_arr deleteAt ( _arr find _l );
		};
	};
};

VEMFrInvasionCount = VEMFrInvasionCount - 1;
VEMFrMissionCount = VEMFrMissionCount - 1;
