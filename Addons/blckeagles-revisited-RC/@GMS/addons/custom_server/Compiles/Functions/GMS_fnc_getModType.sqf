/*
   Based on code by IT07 written for VEMF_r
	--------------------------
	License
	--------------------------
	All the code and information provided here is provided under an Attribution Non-Commercial ShareAlike 4.0 Commons License.

	http://creativecommons.org/licenses/by-nc-sa/4.0/
*/
#include "\q\addons\custom_server\Configs\blck_defines.hpp";

private "_mod";

_mod = "";

if not ( isNull ( configFile >> "CfgPatches" >> "exile_server" ) ) then { _mod = "Exile" };
if not ( isNull ( configFile >> "CfgPatches" >> "a3_epoch_server" ) ) then { _mod = "Epoch" };

_mod
