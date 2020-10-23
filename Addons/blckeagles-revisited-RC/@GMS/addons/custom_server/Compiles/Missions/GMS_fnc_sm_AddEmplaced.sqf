/*
	by Ghostrider [GRG]

	--------------------------
	License
	--------------------------
	All the code and information provided here is provided under an Attribution Non-Commercial ShareAlike 4.0 Commons License.

	http://creativecommons.org/licenses/by-nc-sa/4.0/	
*/
#include "\q\addons\custom_server\Configs\blck_defines.hpp";

params["_emplacedWeapon"];
blck_sm_Emplaced pushBack [_emplacedWeapon,grpNull,0];
diag_log format["_sm_AddEmplaced::-> _emplacedWeapon = %1, blck_sm_Emplaced = %2",_emplacedWeapon,blck_sm_Emplaced];
true