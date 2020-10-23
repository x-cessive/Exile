/*
   Author: IT07

   Description:
   handles the broadcast of a systemChat kill message
*/

params [ "_t", "_nt", "_k", "_nk" ];
private [ "_crWpn", "_cfg" ];
if ( ( vehicle _k ) isEqualTo _k ) then { _crWpn = currentWeapon _k; _cfg = "CfgWeapons" }
else { _crWpn = typeOf ( vehicle _k ); _cfg = "CfgVehicles" };
_dist = _t distance _k;
_dspName = getText ( configFile >> _cfg >> _crWpn >> "displayName" );
_dspName = _dspName select [ 0, _dspName find " " ];
[ format [ "%1 killed %2 with %3 from %4m", _nk, if ( ( "sayKilledName" call VEMFr_fnc_config ) isEqualTo "yes" ) then { _nt + " (AI)" } else { "an AI" }, _dspName, round _dist ] ] ExecVM ( "systemChatToClient" call VEMFr_fnc_scriptPath );
