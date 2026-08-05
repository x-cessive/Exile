/**
 * ExileServer_system_database_connect
 *
 * XCSV extDB3 / x64 variant.
 */

private["_isConnected", "_result"];
_isConnected = false;
ExileServerDatabaseSessionId = "";
ExileServerRconSessionID = "";

try
{
    _result = "extDB3" callExtension "9:VERSION";
    if (_result isEqualTo "") then
    {
        throw "Unable to locate extDB3 extension!";
    };
    if ((parseNumber _result) < 1.027) then
    {
        throw format ["Update extDB3 to version 1.027 or later: %1", _result];
    };
    format ["Installed extDB3 version: %1", _result] call ExileServer_util_log;

    _result = parseSimpleArray ("extDB3" callExtension "9:ADD_DATABASE:exile");
    if (_result select 0 isEqualTo 0) then
    {
        throw format ["Could not add database: %1", _result];
    };
    "Connected to database!" call ExileServer_util_log;

    ExileServerDatabaseSessionId = str(round(random(999999)));
    _result = parseSimpleArray ("extDB3" callExtension format["9:ADD_DATABASE_PROTOCOL:exile:SQL_CUSTOM:%1:exile.ini", ExileServerDatabaseSessionId]);
    if ((_result select 0) isEqualTo 0) then
    {
        throw format ["Failed to initialize database protocol: %1", _result];
    };

    ExileServerStartTime = (call compile ("extDB3" callExtension "9:LOCAL_TIME")) select 1;
    publicVariable "ExileServerStartTime";
    "Database protocol initialized!" call ExileServer_util_log;
    "extDB3" callExtension "9:ADD_PROTOCOL:LOG:TRADING:Exile_TradingLog";
    "extDB3" callExtension "9:ADD_PROTOCOL:LOG:DEATH:Exile_DeathLog";
    "extDB3" callExtension "9:ADD_PROTOCOL:LOG:TERRITORY:Exile_TerritoryLog";
    "extDB3" callExtension "9:LOCK";
    _isConnected = true;
}
catch
{
    "MySQL connection error!" call ExileServer_util_log;
    "Please have a look at @ExileServer/logs/ to find out what went wrong." call ExileServer_util_log;
    format ["MySQL Error: %1", _exception] call ExileServer_util_log;
    "Server will shutdown now :(" call ExileServer_util_log;
};

_isConnected
