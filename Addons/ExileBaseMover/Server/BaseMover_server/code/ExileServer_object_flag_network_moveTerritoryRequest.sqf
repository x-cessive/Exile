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
_flag = _paramaters select 0;
_baseInformation = _paramaters select 1;
try
{
	diag_log format["BaseMover Starting for %1 with %2 parts",_flag,count _baseInformation];
	if (isNull _flag) then 
	{
		throw "Construction object is null!";
	};
	_playerObject = _sessionID call ExileServer_system_session_getPlayerObject;
	if (isNull _playerObject)then 
	{
		throw "Player null";
	};
	_playerUID = getPlayerUID _playerObject;
	_flagDatabaseID = _flag getVariable ['ExileDatabaseID',-1];
	_territoryName = _flag getVariable ["ExileTerritoryName", ""];
	_position = getPosATL _flag;
	
	_data =
	[
		_position select 0,
		_position select 1,
		_position select 2,
		_flagDatabaseID
	];
	_extDB2Message = ["updateFlagPosition", _data] call ExileServer_util_extDB2_createMessage;
	_extDB2Message call ExileServer_system_database_query_fireAndForget;
	diag_log format["BaseMover updateFlagPosition for %1 (%2) at position %3 database ID %4",_flag,_territoryName,_position,_flagDatabaseID];
	[_flag,_baseInformation,_playerObject,_playerUID,_territoryName,_sessionID] spawn
	{
		private ["_flag", "_baseInformation", "_playerObject", "_playerUID", "_territoryName", "_sessionID", "_object", "_offset", "_position", "_vectorDirection", "_vectorUp", "_dbID", "_constructionObject", "_data", "_extDB2Message", "_territoryLog"];
		_flag = _this select 0;
		_baseInformation = _this select 1;
		_playerObject = _this select 2;
		_playerUID = _this select 3;
		_territoryName = _this select 4;
		_sessionID = _this select 5;
		{ 
			private _object = _x select 0;
			private _offset = _x select 1;
			private _position = _flag modelToWorld _offset;
			_object setPosATL _position;
			if(_object isKindOf "Exile_Container_Abstract") then
			{
				_object call ExileServer_object_container_database_update;
			}
			else
			{
				_vectorDirection = vectorDir _object;
				_vectorUp = vectorUp _object;
				_dbID = _object getVariable ["ExileDatabaseID", -1];
				_data =
				[
					_position select 0,
					_position select 1,
					_position select 2,
					_vectorDirection select 0,
					_vectorDirection select 1,
					_vectorDirection select 2,
					_vectorUp select 0,
					_vectorUp select 1,
					_vectorUp select 2,
					_dbID
				];
				_extDB2Message = ["updateConstructionPosition", _data] call ExileServer_util_extDB2_createMessage;
				_extDB2Message call ExileServer_system_database_query_fireAndForget;
				
			};
		}
		forEach _baseInformation;
		
		_territoryLog = format ["%1 (%2) MOVED A TERRITORY %3 AT %4 %5",_playerObject,_playerUID,_territoryName,mapGridPosition _flag,getPosATL _flag];
		"extDB2" callExtension format["1:TERRITORY:%1", _territoryLog];
		diag_log format["BaseMover moved territory %1 to position %2 by %3 (%4)",_territoryName,getPosATL _flag,_playerObject,_playerUID];
		[_sessionID, "toastRequest", ["SuccessTitleAndText", ["Moved Territory!", "All base parts have been moved, great job team!"]]] call ExileServer_system_network_send_to;
	};
}
catch
{
	[_sessionID, "toastRequest", ["ErrorTitleAndText", ["Failed to move territory!", _exception]]] call ExileServer_system_network_send_to;
	_exception call ExileServer_util_log;
};
