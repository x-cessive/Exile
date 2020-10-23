
/*
	for ghostridergaming
	By Ghostrider [GRG]
	Copyright 2016
	
	--------------------------
	License
	--------------------------
	All the code and information provided here is provided under an Attribution Non-Commercial ShareAlike 4.0 Commons License.

	http://creativecommons.org/licenses/by-nc-sa/4.0/
*/
#include "\q\addons\custom_server\Configs\blck_defines.hpp";

private["_group","_wp"];
_group = group _this;
_group setVariable["timeStamp",diag_tickTime];
_wp = [_group, 0];
_group setCurrentWaypoint _wp;

