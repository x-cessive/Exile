
/*
	Killed handler for _units
	By Ghostrider-GRG-

	--------------------------
	License
	--------------------------
	All the code and information provided here is provided under an Attribution Non-Commercial ShareAlike 4.0 Commons License.

	http://creativecommons.org/licenses/by-nc-sa/4.0/
*/
//#include "\q\addons\custom_server\Configs\blck_defines.hpp";
#define unit _this select 0
if (isServer) then {_this call blck_fnc_processAIKill};
if (local (unit)) then  {_this call blck_fnc_processAIKill};
