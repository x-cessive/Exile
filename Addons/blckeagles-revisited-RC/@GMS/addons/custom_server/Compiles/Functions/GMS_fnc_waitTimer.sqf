/*
	for ghostridergaming
	By Ghostrider [GRG]
	Copyright 2016
	
  Waits for a random period between _min and _max seconds
  Call as
  [_minTime, _maxTime] call blck_fnc_waitTimer
  Returns true; 
/*
	By Ghostrider [GRG]
	--------------------------
	License
	--------------------------
	All the code and information provided here is provided under an Attribution Non-Commercial ShareAlike 4.0 Commons License.

	http://creativecommons.org/licenses/by-nc-sa/4.0/
*/
#include "\q\addons\custom_server\Configs\blck_defines.hpp";
private["_wait","_Tstart"];
params["_min","_max"];
uiSleep round( _min + (_max - _min) );
true
