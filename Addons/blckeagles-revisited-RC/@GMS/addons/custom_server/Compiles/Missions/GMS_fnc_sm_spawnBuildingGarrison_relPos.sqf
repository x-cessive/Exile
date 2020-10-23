

params["_building","_skillLevel","_noStatics","_typesStatics","_noUnits"];
//diag_log format["_fnc_sm_spawnBuildingGarrison_relPos: handling _building = %1 | at location = %2",_building,position _building];
//{
	//diag_log format["_fnc_sm_spawnBuildingGarrison_relPos: _this %1 = %2",_foreachIndex,_this select _foreachindex];
//}forEach _this;
private _group = [blck_AI_Side,true] call blck_fnc_createGroup;
if !(isNull _group) then 
{
	// ["_building","_group","_noStatics","_typesStatics","_noUnits",["_aiDifficultyLevel","Red"],
	[_building,_group,_noStatics,[],_noUnits,_skillLevel] call blck_fnc_spawnGarrisonInsideBuilding_relPos;
};
_group