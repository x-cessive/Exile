/*
	Check if an HC is connected and if so transfer some AI to it.

	By Ghostrider [GRG]
	Copyright 2016	
	--------------------------
	License
	--------------------------
	All the code and information provided here is provided under an Attribution Non-Commercial ShareAlike 4.0 Commons License.

	http://creativecommons.org/licenses/by-nc-sa/4.0/
*/
#include "\q\addons\custom_server\Configs\blck_defines.hpp";
//  blck_connectedHCs  // list of connected HCs at last check.
_HCs = entities "HeadlessClient_F";  //  currently connected HCs.

{
	if ([_x] call _fn_HC_disconnected) then
	{
		// Remove any event handlers added by the HC
		
	};
}forEach blck_connectedHCs;
