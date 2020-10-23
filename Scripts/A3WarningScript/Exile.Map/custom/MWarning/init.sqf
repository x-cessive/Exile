#include "config.hpp"

_handle  = [] spawn {
	while {true} do {
		//waitUntil{!isNil "ExileClientLoadedIn"};
		//UISleep 0.1;
		//waitUntil{ExileClientLoadedIn};
		//UISleep 0.1;
		waitUntil{alive player}; //All above, code to be sure to wait for the exile client to be fully loaded in.
		waitUntil{ (player != vehicle player) }; //All above, code to be sure to wait for the exile client to be fully loaded in.

		_veh = vehicle player;
		_add =  false;
		if (ENABLE_ALL) then
		{
			_add = true;
		}
		else
		{
			{
				if (_veh isKindOf _x) exitWith { _add = true; }; 	
			} forEach ALLOWED;	
		};
		
		{
			if (_veh isKindOf _x) exitWith 
			{ 
				_add = false; 
			}; 	
		} forEach BLACKLIST;	
		
		private "_eventhandle";
		if (_add) then
		{
			_eventhandle = _veh addEventHandler ["IncomingMissile", 
			{
				_isNull = isNull (uiNameSpace getVariable ["MWarning", displayNull]);			
				if (_isNull) then
				{
					playSound "MWarningAlarm";
					null = []execVM "custom\MWarning\ShowMWarning.sqf"; 
				};	
			}];
		};
		
		
		waitUntil{ ((!alive player) || (player == vehicle player)) };
		
		if (_add) then
		{	
			_veh removeEventHandler ["IncomingMissile",_eventhandle];
		};
		
	};
};