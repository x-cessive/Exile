/*
	By Ghostrider-GRG-
	Copyright 2016
	--------------------------
	License
	--------------------------
	All the code and information provided here is provided under an Attribution Non-Commercial ShareAlike 4.0 Commons License.

	http://creativecommons.org/licenses/by-nc-sa/4.0/	
*/

#include "\q\addons\custom_server\Configs\blck_defines.hpp";

// can probably hook this onto signalEnd as they do the same things
// Left here for legacy compatability with some GRG addons.
params["_crate"];

[_crate] call blck_fnc_signalEnd;
