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
/*
	Purpose: returns the nearest marker of a specific type 
	Parameters: type of marker to search for as a "STRING"
	Returns: The nearest marker of that type
*/

params["_mType"];
private _nearestMarker = [player, (allMapMarkers select {(getMarkerType _x) isEqualTo _mType})] BIS_fnc_nearestPosition;
_nearestMarker;
