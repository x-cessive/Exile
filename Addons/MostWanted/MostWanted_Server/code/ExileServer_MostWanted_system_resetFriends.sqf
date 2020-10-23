/*
*
*  ExileServer_MostWanted_system_resetFriends.sqf
*  © 2016 Mezo, Shix, and WolfkillArcadia
*  This work is licensed under the Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 International License.
*  To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-nd/4.0/.
*/
private["_resetTime"];
_resetTime = getNumber(missionConfigFile >> "CfgMostWanted" >> "Database" >> "Cleanup" >> "friendsLifetime");
format["resetFriends:%1",_resetTime] call ExileServer_system_database_query_fireAndForget;
