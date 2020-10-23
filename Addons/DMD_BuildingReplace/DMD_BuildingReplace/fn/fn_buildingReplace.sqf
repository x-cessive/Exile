/* 
	file:	buildingReplace.sqf
	Original Script Here: http://forums.bistudio.com/showthread.php?190404-Chernarus-Takistan 

	Script edited by jakehekesfists[dmd] 08/05/2015
	-rev 2.9d (for Arma III)   2017-07-27
	Code Clean/Restructure
	
	Author: JakeHekesFists[DMD]
	Date:	11/12/2017
	Public Release version 1.0
*/
private _repCfg = configFile >> "DMD_BuildingReplace" >> "replacement" >> worldName;
private _enabled = ( getNumber ( _repCfg >> "enabled" ) );

if (_enabled isEqualTo 1) then {
	diag_log format ["### DMD buildingReplace is Enabled | Pre-Init Current FPS %1",diag_fps];
	private _clsHouse = ( getArray (_repCfg >> "closeHouse" ) );
	private _annoying = ( getArray (_repCfg >> "deleteObjs" ) );
	private _replcList = ( getArray (_repCfg >> "replacementList" ) );
	
	{ _x params ["_posX", "_objX"]; private _delObj1 = (_posX nearestObject _objX); deleteVehicle _delObj1; _delObj1 hideObjectGlobal true; } foreach _annoying;
	
	private _replaceThese = [];
	private _middle = worldSize/2;
	private _centerPos = [_middle, _middle, 0];	
	private _allMapObjs = nearestObjects [_centerPos, ["ALL"], (_middle)*2 ];
	
	for "_i" from 0 to (count _allMapObjs)-1 do {
		private _hse = _allMapObjs select _i;
		DMD_SimulateMePls pushback _hse;
		if ((typeOf _hse) in _clsHouse) then { _replaceThese pushback _hse; };
	};

	for "_i" from 0 to (count _replaceThese)-1 do {
		private _nBldg = _replaceThese select _i;
		private _dirVec = vectorDir _nBldg;
		private _objVec = vectorUp _nBldg;
		private _wldPos = ASLtoATL getPosASL _nBldg;
		_nBldg hideObjectGlobal true;
		deleteVehicle _nBldg;
		
		_tp = "x";
		call { { if ((typeof _nBldg) in (_x select 0)) exitWith { _tp = (_x select 1) select 0; }; } forEach _replcList; };		
		if !(_tp isEqualTo "x") then {
			private _house = createVehicle [_tp, _wldPos, [], 0, "CAN_COLLIDE"];
			_house setVectorDirAndUp [ _dirVec, _objVec];
			DMD_SimulateMePls pushback _house;
		};
	};
	diag_log format ["### DMD buildingReplace - %1 Buildings Replaced - Server FPS %2", (count _replaceThese), diag_fps];
	[DMD_SimulateMePls] spawn DMD_BR_fnc_simulationManager;	
} else { 
	diag_log format ["### DMD buildingReplace is NOT enabled for Map %1",worldName];
};