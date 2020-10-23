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

#define DMS_missionMarkerRootName "DMS_MissionMarker"
private _dmsMarkers = [DMS_missionMarkerRootName] call blck_fnc_getAllMarkersOfSubtype;
_dmsMarkers
