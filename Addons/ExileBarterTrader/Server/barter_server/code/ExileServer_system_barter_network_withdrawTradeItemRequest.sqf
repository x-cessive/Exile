 /*
 *
 * Author: Andrew_S90
 *
 * This work is protected by Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International (CC BY-NC-SA 4.0). 
 *
 */

private ["_sessionID", "_targetUID", "_hasSafeXPlayer", "_parameters", "_itemClassName", "_containerType", "_containerNetID", "_playerObject", "_vehicleObject", "_playerTraderItems", "_index", "_current", "_amt", "_playerUID", "_logging", "_itemLogging", "_traderLog", "_responseCode"];
_sessionID = _this select 0;
_parameters = _this select 1;
_itemClassName = _parameters select 0;
_containerType = _parameters select 1;
_containerNetID = _parameters select 2;
_playerTraderItems = _parameters select 3;

try 
{
	_playerObject = _sessionID call ExileServer_system_session_getPlayerObject;
	_targetUID = getPlayerUID _playerObject;
	if (_targetUID isEqualTo "") then 
	{
		//throw "getPlayerUID returned an empty string!";
		throw 5;
	};
	if (_playerObject getVariable ["ExileMutex",false]) then
	{
		throw 12;
	};
	_playerObject setVariable ["ExileMutex",true];
	_vehicleObject = objNull;
	if (_containerType isEqualTo 2) then 
	{
		_vehicleObject = objectFromNetID(_containerNetID);
	};
	if (isNull _playerObject) then
	{
		throw 1;
	};
	if !(alive _playerObject) then
	{
		throw 2;
	};
	
	_data = [];
	
	_index = [_playerTraderItems,_itemClassName] call ExileServer_util_searchItemsArray;
	
	if(_index != -1) then 
	{
		_current = _playerTraderItems select _index;
		_amt = (_current select 1)-1;
		if(_amt <= 0) then {
			_playerTraderItems deleteAt _index;
		} else {
			_playerTraderItems set [_index, [(_current select 0),_amt]];
		};
	};
	
	if(_index == -1) then 
	{
		throw -1;
	};
	
	[_sessionID, "withdrawTradeItemResponse", [0, _itemClassName, _containerType, _containerNetID, _playerTraderItems]] call ExileServer_system_network_send_to;
	
	_logging = getNumber(configFile >> "CfgSettings" >> "Logging" >> "traderLogging");
	if (_logging isEqualTo 1) then
	{
		_traderLog = format ["PLAYER: ( %1 ) %2 WITHDREW ITEM %3 FROM BARTER",getPlayerUID _playerObject,_playerObject,_itemClassName];
		"extDB3" callExtension format["1:TRADING:%1",_traderLog];
	};
	if !(_vehicleObject isEqualTo objNull) then
	{
		_vehicleObject call ExileServer_object_vehicle_database_update;
	}
	else 
	{
		_playerObject call ExileServer_object_player_database_update;
	};
}
catch 
{
	_responseCode = _exception;
	[_sessionID, "withdrawTradeItemResponse", [_responseCode, "", 0, "",[]]] call ExileServer_system_network_send_to;
};	
_playerObject setVariable ["ExileMutex",false];
true