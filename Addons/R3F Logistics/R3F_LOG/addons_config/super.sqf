/**
 * Logistics configuration for All in Arma.
 * The configuration is splitted in categories dispatched in the included files.
 */

// Load the logistics config only if the addon is used
if (isClass (configfile >> "CfgPatches" >> "AiA_Core")) then
{
    #include "Super\Air.sqf"
    #include "Super\LandVehicle.sqf"
    #include "Super\Ship.sqf"
    #include "Super\Building.sqf"
    #include "Super\ReammoBox.sqf"
    #include "Super\Others.sqf"
};