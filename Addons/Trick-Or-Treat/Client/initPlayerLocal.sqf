{
    _code = '';
    _function = _x select 0;
    _file = _x select 1;

    _code = compileFinal (preprocessFileLineNumbers _file);                    

    missionNamespace setVariable [_function, _code];
}
forEach 
[
	// GADD Trick or Treat
	['ExileClient_gadd_network_TrickOrTreatResponse', 'GADD_Apps\TrickOrTreat\ExileClient_gaddTT_network_TrickOrTreatResponse.sqf'],
	['GADD_TrickOrTreat_Request', 'GADD_Apps\TrickOrTreat\GADD_TrickOrTreat_Request.sqf'],
	// Tricks... Add more if you want :)
	['GADD_TT_Smoke', 'GADD_Apps\TrickOrTreat\Tricks\GADD_TT_Smoke.sqf'],
	['GADD_TT_Bombs', 'GADD_Apps\TrickOrTreat\Tricks\GADD_TT_Bombs.sqf'],
	['GADD_TT_Tripwire', 'GADD_Apps\TrickOrTreat\Tricks\GADD_TT_Tripwire.sqf']
];