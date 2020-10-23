/*
	Remove all gear from an AI _unit
	By Ghostrider [GRG]

	--------------------------
	License
	--------------------------
	All the code and information provided here is provided under an Attribution Non-Commercial ShareAlike 4.0 Commons License.

	http://creativecommons.org/licenses/by-nc-sa/4.0/
*/
#include "\q\addons\custom_server\Configs\blck_defines.hpp";

params["_unit"];

removeVest _unit;
removeHeadgear _unit;
removeGoggles _unit;
removeAllItems _unit;
removeAllWeapons _unit;
removeBackpackGlobal _unit;
removeUniform _unit;
