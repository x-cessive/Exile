{
    _x params [["_function",""],["_file",""]];
    _code = compileFinal (preprocessFileLineNumbers _file);
    missionNamespace setVariable [_function,_code];
} 
forEach
[
	['ExAd_fnc_showEject','HaloParachute\Functions\fn_showEject.sqf'],
	['ExAd_fnc_ejectPlayer','HaloParachute\Functions\fn_ejectPlayer.sqf'],
	['ExAd_fnc_parachuteSafeMode','HaloParachute\Functions\fn_parachuteSafeMode.sqf'],
	['ExAd_fnc_pullParachute','HaloParachute\Functions\fn_pullParachute.sqf'],
	['ExAd_fnc_showParachute','HaloParachute\Functions\fn_showParachute.sqf'],
	['ExAd_Para_Postinit','HaloParachute\postInit.sqf']
];

