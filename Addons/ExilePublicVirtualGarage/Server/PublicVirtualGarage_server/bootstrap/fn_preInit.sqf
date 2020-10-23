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
	['ExileServer_system_vg_network_VGPublic_Load', 'PublicVirtualGarage_server\code\ExileServer_system_vg_network_VGPublic_Load.sqf'],
	['ExileServer_system_vg_network_VGPublic_Store', 'PublicVirtualGarage_server\code\ExileServer_system_vg_network_VGPublic_Store.sqf']
];


true