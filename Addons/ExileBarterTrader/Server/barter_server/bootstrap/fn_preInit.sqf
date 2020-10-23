 /*
 *
 * Author: Andrew_S90
 *
 * This work is protected by Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International (CC BY-NC-SA 4.0). 
 *
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
	['ExileServer_system_barter_network_tradeItemsRequest', 'barter_server\code\ExileServer_system_barter_network_tradeItemsRequest.sqf'],
	['ExileServer_system_barter_network_withdrawTradeItemRequest', 'barter_server\code\ExileServer_system_barter_network_withdrawTradeItemRequest.sqf'],
	['ExileServer_util_searchItemsArray', 'barter_server\code\ExileServer_util_searchItemsArray.sqf'],
	['ExileServer_World_loadAllBarters', 'barter_server\code\ExileServer_World_loadAllBarters.sqf']
];


true