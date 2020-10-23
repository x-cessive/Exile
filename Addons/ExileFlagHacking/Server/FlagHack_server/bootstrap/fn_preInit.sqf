/*
    Pre-Initialization
*/
private ['_code', '_function', '_file'];

{
    _code = '';
    _function = _x select 0;
    _file = _x select 1;

    if (isText (missionConfigFile >> 'CfgExileCustomCode' >> _function)) then
    {
        _file = getText (missionConfigFile >> 'CfgExileCustomCode' >> _function);
    };

    _code = compileFinal (preprocessFileLineNumbers _file);                    

    missionNamespace setVariable [_function, _code];
}
forEach 
[
	['ExileServer_object_flag_network_hackFlagRequest', 'FlagHack_server\code\ExileServer_object_flag_network_hackFlagRequest.sqf'],
	['ExileServer_object_flag_network_startFlagHackRequest', 'FlagHack_server\code\ExileServer_object_flag_network_startFlagHackRequest.sqf'],
	['ExileServer_object_flag_network_updateFlagHackAttemptRequest', 'FlagHack_server\code\ExileServer_object_flag_network_updateFlagHackAttemptRequest.sqf']
];


true