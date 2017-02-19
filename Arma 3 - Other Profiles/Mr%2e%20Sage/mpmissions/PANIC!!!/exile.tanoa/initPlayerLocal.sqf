/**
 * Created with Exile Mod 3DEN Plugin
 * www.exilemod.com
 */

 // Georgetown Trader City, add to the top or bottom of this file. -Untriel
#include "custom\untTraderCityGeorgetown_player.sqf";

if (!hasInterface || isServer) exitWith {};


// Water Mark
_pic = "wm.paa";
[
    '<img align=''left'' size=''1.0'' shadow=''1'' image='+(str(_pic))+' />',
    safeZoneX+0.027,
    safeZoneY+safeZoneH-0.1,
    99999,
    0,
    0,
    3090
] spawn bis_fnc_dynamicText;

