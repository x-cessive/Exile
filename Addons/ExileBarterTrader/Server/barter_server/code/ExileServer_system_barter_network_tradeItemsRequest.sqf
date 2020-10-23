 /*
 *
 * Author: Andrew_S90
 *
 * This work is protected by Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International (CC BY-NC-SA 4.0). 
 *
 */
private ["_sessionID", "_paramaters", "_flag", "_baseInformation", "_playerObject", "_playerUID", "_lastAttackedAt", "_constructionBlockDuration", "_flagDatabaseID", "_territoryName", "_nearFlag", "_position", "_data", "_extDB2Message"];

_sessionID = _this select 0;
_paramaters = _this select 1;
_playerBarterItems = _paramaters select 0;
_playerBarterOfferItems = _paramaters select 1;
_playerInventoryItems = _paramaters select 2;
_playerInventoryOfferItems = _paramaters select 3;
_playerBarterNumber = _paramaters select 4;

try
{
	_playerObject = _sessionID call ExileServer_system_session_getPlayerObject;
	
	if (isNull _playerObject)then 
	{
		throw 0;
	};
	
	_playerUID = getPlayerUID _playerObject;
	if (_playerUID isEqualTo "") then 
	{
		throw 1;
	};
	if (_playerObject getVariable ["ExileMutex",false]) then
	{
		throw 12;
	};
	_playerObject setVariable ["ExileMutex",true];
	
	_isKnownData = format["isKnownData:%1", _playerUID] call ExileServer_system_database_query_selectSingleField;
	
	if !(_isKnownData) then
	{
		format["addPlayerBarterInfo:%1:%2", _playerUID,BarterMasterList] call ExileServer_system_database_query_fireAndForget;
	};
	
	BarterMasterList set [_playerBarterNumber,_playerBarterItems];
	
	format["updatePlayerBarterInfo:%1:%2", BarterMasterList,_playerUID] call ExileServer_system_database_query_fireAndForget;
	
	_tradeLog = format ["%1 (%2) TRADED BARTER %3 WITH %4 FOR %5",_playerObject,_playerUID,_playerBarterNumber,_playerInventoryOfferItems,_playerBarterOfferItems];
	"extDB3" callExtension format["1:TRADING:%1", _tradeLog];
	
	[_sessionID, "tradeItemsResponse", [0, BarterMasterList, _playerBarterOfferItems]] call ExileServer_system_network_send_to;
}
catch
{
	[_sessionID, "tradeItemsResponse", [_exception, BarterMasterList, _playerInventoryOfferItems]] call ExileServer_system_network_send_to;
	_exception call ExileServer_util_log;
};
_playerObject setVariable ["ExileMutex",false];