/*
	by Ghostrider [GRG]

	--------------------------
	License
	--------------------------
	All the code and information provided here is provided under an Attribution Non-Commercial ShareAlike 4.0 Commons License.

	http://creativecommons.org/licenses/by-nc-sa/4.0/	
*/
#include "\q\addons\custom_server\Configs\blck_defines.hpp";
params["_array","_patrolInformation",["_timesToRespawn",-1]];
waitUntil {blck_sm_monitoring isEqualTo 0};
_array pushBack [
	_patrolInformation,
	grpNull,
	0, // groupSpawned
	0, //  times Spawned
	0, // Respawn At
	_timesToRespawn  // Max Times to Respawn
];
_array
