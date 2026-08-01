ns_blow_itemapsi = ["Item_artefact_psi_field"];
ns_blow_itemtype = 3;
ns_blow_removeapsi = false;
ns_blow_delaymod = 2;
ns_blow_damage_unprotected = 0.15;
ns_blow_damage_invehicle = 0;
ns_blow_damage_inbuilding = 0;
ns_prep_time = 60;
ns_blowout = true;
ns_blowout_exile = true;
ns_blow_prep = false;
ns_blow_status = false;
ns_blow_action = false;
phasAPSI = false;
ns_blow_lightning = false;
ns_blow_damage_vehicles = false;
ns_blow_vehicle_damageamount = 0.10;
ns_blow_disable_vehicles = false;
fnc_isInsideBuilding = compile preprocessFileLineNumbers "Custom\blowout\external\fn_isInsideBuilding.sqf";
fnc_hasAPSI = compile preprocessFileLineNumbers "Custom\blowout\external\fn_hasAPSI.sqf";
if (!isDedicated) then
{
	_bul = [] execVM "Custom\blowout\module\blowout_client.sqf";
	diag_log "BLOWOUT CLIENT - Loading";
};
if (isServer) then
{
	_bul = [] execVM "Custom\blowout\module\blowout_server.sqf";
	uiSleep 2;
};
systemChat "EVR, ready!";