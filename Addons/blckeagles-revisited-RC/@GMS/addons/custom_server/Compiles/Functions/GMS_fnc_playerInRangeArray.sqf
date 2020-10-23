//////////////////////////////////////////////////////
// Test whether one object (e.g., a player) is within a certain range of any of an array of other objects
/*
	By Ghostrider [GRG]
	Copyright 2016	
	--------------------------
	License
	--------------------------
	All the code and information provided here is provided under an Attribution Non-Commercial ShareAlike 4.0 Commons License.

	http://creativecommons.org/licenses/by-nc-sa/4.0/
*/
#include "\q\addons\custom_server\Configs\blck_defines.hpp";

params["_locations","_dist",["_onFootOnly",false]];
private _nearLocations = _locations select {[_x,_dist,_onFootOnly] call blck_fnc_playerInRange};
//diag_log format["_fnc_playerInRangeArray: _locations = %1 | _dist = %2 | _nearLocations = %3",_locations,_dist,_nearLocations];
private _return = if (_nearLocations isEqualTo []) then {false} else {true};
_return
/*
{
	_result = [_x,_dist,_onFootOnly] call blck_fnc_playerInRange;
	if (_result) exitWith {};
} forEach _locations;
_result
