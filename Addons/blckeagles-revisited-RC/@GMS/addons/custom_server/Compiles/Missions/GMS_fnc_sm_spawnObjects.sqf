/*
	by Ghostrider [GRG]

	--------------------------
	License
	--------------------------
	All the code and information provided here is provided under an Attribution Non-Commercial ShareAlike 4.0 Commons License.

	http://creativecommons.org/licenses/by-nc-sa/4.0/	
*/
#include "\q\addons\custom_server\Configs\blck_defines.hpp";

params["_objects"];
private["_objects","_object"];
{
	_object = [_x select 0, _x select 1, _x select 2, _x select 3] call blck_fnc_sm_spawnObjectASLVectorDirUp;
} forEach _objects;


