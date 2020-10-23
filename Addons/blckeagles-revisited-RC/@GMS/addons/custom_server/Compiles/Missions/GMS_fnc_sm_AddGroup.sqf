/*
	by Ghostrider [GRG]

	--------------------------
	License
	--------------------------
	All the code and information provided here is provided under an Attribution Non-Commercial ShareAlike 4.0 Commons License.

	http://creativecommons.org/licenses/by-nc-sa/4.0/	
*/
#include "\q\addons\custom_server\Configs\blck_defines.hpp";

params["_group"];
blck_sm_Groups pushBack [_group,grpNull,0];
diag_log format["_sm_AddGroup:: blck_sm_Groups = %1",blck_sm_Groups];
true