// RESERVED FOR FUTURE USE

params["_searchString","_stringToSearch","_start","_end"];
private _r = if ( ([_stringToSearch,_start,_start + (count _searchString) - 1] call BIS_fnc_trimString) isEqualTo _searchString)  then {true} else {false};
_r