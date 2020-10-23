/*
	By Ghostrider [GRG]
	Copyright 2016

	--------------------------
	License
	--------------------------
	All the code and information provided here is provided under an Attribution Non-Commercial ShareAlike 4.0 Commons License.

	http://creativecommons.org/licenses/by-nc-sa/4.0/
*/
// assumptions: there are no crew in vehicle. there are no players in vehicle. thus we can just be sure the owner is the server then set the lock locally
#include "\q\addons\custom_server\Configs\blck_defines.hpp";
params["_veh"];

if (local _veh) then
{
	_veh lock 1;
}
else
{
	[_veh, 1] remoteExecCall ["lock", _veh];
};
