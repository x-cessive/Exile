 /*
 *
 * Author: Andrew_S90
 *
 * This work is protected by Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International (CC BY-NC-SA 4.0). 
 *
 */
if(isNil 'BaseMover') then 
{
	BaseMover = true;
	BaseInformation = [];
	BaseFlag = objNull;
};

if(BaseMover)then
{
	private _nearFlag = nearestObject [player, "Exile_Construction_Flag_Static"];
	if !(isNull _nearFlag) then 
	{
		systemChat "Flag found, lets split up and look for clues!";
		private _territoryOwner = _nearFlag getVariable ["ExileOwnerUID", ""];
		private _territorySize = _nearFlag getVariable ["ExileTerritorySize", ""];
		private _territoryName = _nearFlag getVariable ["ExileTerritoryName", ""];
		private _territoryLevel = _nearFlag getVariable ["ExileTerritoryLevel", ""];
		private _territoryStolen = _nearFlag getVariable ["ExileFlagStolen", ""];
		private _parts = count (_nearFlag nearObjects ["Exile_Construction_Abstract_Static", _territorySize]);
		private _containers = count (_nearFlag nearObjects ["Exile_Container_Abstract", _territorySize]);
		private _ownerObject = _territoryOwner call ExileClient_util_player_objectFromPlayerUID;
		private _online = "Yes";
		if (isNull _ownerObject) then 
		{
			_online = "No";
		};
		
		['SuccessTitleAndText', [ format["<t color='#0000ff'>Flag Details:</t><br/>
		Flag Name: %1<br/>
		Flag Level: %5<br/>
		Flag Size: %2<br/>
		Flag Parts: %7<br/>
		Flag Containers: %8<br/>
		Flag Owner: %3<br/>
		Flag Owner Online: %4<br/>
		Flag Stolen: %6<br/>
		",_territoryName,_territorySize,_territoryOwner,_online,_territoryLevel,_territoryStolen,_parts,_containers] ]] call ExileClient_gui_toaster_addTemplateToast;
		
		if(_territoryStolen isEqualTo 0) then
		{
			[_nearFlag,_territorySize] spawn 
			{
				private _nearFlag = _this select 0;
				private _territorySize = _this select 1;
				disableSerialization;
				
				private _result = ["Do you want to move this territory? For a scooby-snack?", "Start the Mistery Machine?", "Scooby!", "Ruh-Roh"] call BIS_fnc_guiMessage;
				waitUntil { !isNil "_result" };
				if (_result) then
				{
					systemChat "Lets get to it gang!";
					private _objects = nearestObjects [_nearFlag, ["Exile_Construction_House_Base","Exile_Construction_Abstract_Static","Exile_Container_Abstract","Land_WaterCooler_01_new_F","Land_FuelStation_Feed_F","Land_Atm_02_F","Exile_ConcreteMixer"], _territorySize];
					_objects = _objects + ((allSimpleObjects []) select {_x distance2D _nearFlag <= _territorySize and _x isKindOf "Exile_Construction_Abstract_Static"});
					{
						private _offset = _nearFlag worldToModel (getPosATL _x); 
						BaseInformation pushBack [_x,_offset];
					}
					forEach _objects;
					BaseFlag = _nearFlag;
					BaseMover = false;
				}
				else
				{
					systemChat "Better luck next time.";
				};
			};
		}
		else
		{
			systemChat "I would have been able to move this flag if it weren't for those meddling flag stealers!";
		};
	}
	else
	{
		systemChat "Zoinks scoob you need to be near a flag to do that!";
	};
}
else
{
	private _flags = nearestObjects[player, ["Exile_Construction_Flag_Static"], 5000];
	private _nearestFlagDist = floor(player distance2D (_flags select 0));
	private _nearFlag = BaseFlag;
	ExileTraderNoGodMode = [];
	{
		switch (getMarkerType _x) do 
		{
			case "ExileMissionStrongholdIcon":
			{
				ExileTraderNoGodMode pushBack (getMarkerPos _x);
			};
		};
	}
	forEach allMapMarkers;
	
	private _distance = 99999;
	_markers = ExileTraderZoneMarkerPositions+ExileTraderNoGodMode;
	{
		if ((player distance2D _x) < _distance) then
		{
			_distance = floor(player distance2D _x);
		};
	}
	forEach _markers;
	
	private _distanceSpawn = 99999;
	{
		if ((player distance2D _x) < _distanceSpawn) then
		{
			_distanceSpawn = floor(player distance2D _x);
		};
	}
	forEach ExileSpawnZoneMarkerPositions;
	
	
	private _territoryOwner = _nearFlag getVariable ["ExileOwnerUID", ""];
	private _territorySize = _nearFlag getVariable ["ExileTerritorySize", ""];
	private _territoryName = _nearFlag getVariable ["ExileTerritoryName", ""];
	private _territoryLevel = _nearFlag getVariable ["ExileTerritoryLevel", ""];
	private _territoryStolen = _nearFlag getVariable ["ExileFlagStolen", ""];
	private _parts = count (_nearFlag nearObjects ["Exile_Construction_Abstract_Static", _territorySize]);
	private _containers = count (_nearFlag nearObjects ["Exile_Container_Abstract", _territorySize]);
	private _ownerObject = _territoryOwner call ExileClient_util_player_objectFromPlayerUID;
	private _online = "Yes";
	if (isNull _ownerObject) then 
	{
		_online = "No";
	};
	
	['SuccessTitleAndText', [ format["<t color='#0000ff'>Flag Details:</t><br/>
	Flag Name: %1<br/>
	Flag Level: %5<br/>
	Flag Size: %2<br/>
	Flag Parts: %7<br/>
	Flag Containers: %8<br/>
	Flag Owner: %3<br/>
	Flag Owner Online: %4<br/>
	Flag Stolen: %6<br/><br/><br/>
	<t color='#0000ff'>Current Location Info:</t><br/>
	Closest Flag: %9m<br/>
	Closest Trader: %10m<br/>
	Closest Spawn: %11m<br/>
	",_territoryName,_territorySize,_territoryOwner,_online,_territoryLevel,_territoryStolen,_parts,_containers,_nearestFlagDist,_distance,_distanceSpawn] ]] call ExileClient_gui_toaster_addTemplateToast;
		
	[_territorySize] spawn 
	{
		_territorySize = _this select 0;
		disableSerialization;
		
		private _result = ["Do you want to cancel the move?", "Go back to the Mistery Machine and regroup?", "Yeah!", "No Way!"] call BIS_fnc_guiMessage;
		waitUntil { !isNil "_result" };
		if (_result) exitWith
		{
			systemChat "Better luck next time.";
			BaseMover = true;
			BaseFlag = objNull;
			BaseInformation = [];
		};

		uiSleep 1.5;
		private _result2 = ["Is this the spot Scooby-Doo?", "Is this the bad guy for sure?", "Yeah!", "Uh.. No"] call BIS_fnc_guiMessage;
		waitUntil { !isNil "_result2" };
		if (_result2) then
		{
			systemChat "Base Moving..";
			private _oldPosition = (getPosATL BaseFlag);
			systemChat format["Base Old Position %1",_oldPosition];
			private _newPosition = (getPosATL player);
			
			BaseFlag setPosATL _newPosition;
			waitUntil { (floor(BaseFlag distance2D _newPosition) < 5) };
			systemChat format["Well gang it looks like it will take about %1 seconds to move everything. Sit tight while we work on a plan!",count BaseInformation];
			["moveTerritoryRequest",[BaseFlag,BaseInformation]] call ExileClient_system_network_send;
			
			systemChat format["Base New Position %1",getPosATL BaseFlag];

			BaseMover = true;
			BaseFlag = objNull;
			BaseInformation = [];
			systemChat "The boss will let you know when the job is done!";
		}
		else
		{
			systemChat "Maybe a few more scooby-snacks will do the trick..";
		};
		
	};
};