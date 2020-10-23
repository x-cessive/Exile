// Configures a mission vehicle
/*
	By Ghostrider [GRG]
	
	spawns a vehicle of _vehType and mans it with units in _group.
	returns _veh, the vehicle spawned.
	--------------------------
	License
	--------------------------
	All the code and information provided here is provided under an Attribution Non-Commercial ShareAlike 4.0 Commons License.

	http://creativecommons.org/licenses/by-nc-sa/4.0/
*/
#include "\q\addons\custom_server\Configs\blck_defines.hpp";

params["_veh",["_locked",0]];
private["_unit"];
_veh lock _locked;

_veh addMPEventHandler["MPHit",{if (isServer) then {_this call blck_fnc_AIVehicle_HandleHit}}];
_veh addMPEventHandler["MPKilled",{if (isServer) then {_this call blck_fnc_processAIVehicleKill}}];
#define vehicleAffected _this select 0
_veh addEventHandler["GetOut",{if (isServer || local (vehicleAffected)) then {_this call blck_fnc_handleVehicleGetOut}}];

blck_monitoredVehicles pushBackUnique _veh;
if (blck_modType isEqualTo "Epoch") then
{
	// Adds compatability with Halv's black market traders
	if (blck_allowSalesAtBlackMktTraders) then {_veh setVariable["HSHALFPRICE",1,true]};
};
if (blck_modType isEqualTo "Exile")	then 
{
	// Adds compatability with claim vehicle scripts
	if (blck_allowClaimVehicle) then 
	{
		_veh setVariable ["ExileIsPersistent", false];
	};
};

_veh
