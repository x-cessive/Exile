/*
*
*  ExileServer_MostWanted_network_masterListRequest.sqf
*  © 2016 Mezo, Shix, and WolfkillArcadia
*  This work is licensed under the Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 International License.
*  To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-nd/4.0/.
*/
[_this select 0,"masterListResponse",[MostWanted_MasterBountyList]] call ExileServer_system_network_send_to;
