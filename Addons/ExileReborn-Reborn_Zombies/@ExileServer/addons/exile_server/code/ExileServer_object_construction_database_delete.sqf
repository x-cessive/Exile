/**
 * ExileServer_object_construction_database_delete
 *
 * Exile Mod
 * www.exilemod.com
 * © 2015 Exile Mod Team
 *
 * This work is licensed under the Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 International License. 
 * To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-nd/4.0/.
 */
 
private["_constructionObject","_constructionID"];
_constructionObject = _this;
_constructionID = _constructionObject getVariable ["ExileDatabaseID", -1];
if (_constructionID > -1) then
{
	format ["deleteConstruction:%1", _constructionID] call ExileServer_system_database_query_fireAndForget;
};
true