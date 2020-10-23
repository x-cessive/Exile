/*
	Static loot crate spawner
	by Ghostrider [GRG]
	For Arma 3 Exile and Epoch
	Last Updated 11/12/16
	--------------------------
	License
	--------------------------
	All the code and information provided here is provided under an Attribution Non-Commercial ShareAlike 4.0 Commons License.

	http://creativecommons.org/licenses/by-nc-sa/4.0/	
*/

#include "\q\addons\custom_server\Configs\blck_defines.hpp";

if ((tolower blck_modType) isEqualto "epoch") then
{
	call compile preprocessfilelinenumbers "\q\addons\custom_server\SLS\SLS_init_epoch.sqf";
};
if ((tolower blck_modType) isEqualto "exile") then
{
	call compile preprocessfilelinenumbers "\q\addons\custom_server\SLS\SLS_init_exile.sqf";
};
diag_log "[blckeagls] SLS System: Static loot crates ran successfully!";
blck_SLSComplete = true;
