/*
    sovran_zeus - whitelisted in-game Zeus (Curator) for an Exile server

    Grants the vanilla Arma 3 Curator interface to specific player UIDs, so an admin
    can build and spawn live while players are on the server. Server-side only:
    players need no mod, no download, no client change.

    This is the same job @SLZ (Seelenlos Zeus) does. We do not need it -- every
    curator class is already in the base game and present on this server.

    IMPORTANT, read before using:

    * Zeus placements are NOT persistent. Anything spawned through the Zeus interface
      disappears at the next restart. For permanent map edits, build in 3DEN/M3Editor
      and export server-side via Addons/Objects-Server-Side.

    * BattlEye WILL fight this. Zeus spawns and deletes objects, which trips
      createVehicle / deleteVehicle / setPos rules -- the exact cheat-vector filters
      that should never be auto-whitelisted. Run tools/battleye/be-autofilter.ps1 in
      Propose mode while testing, then apply the specific exceptions by hand.

    * Anyone on the whitelist can spawn anything. Treat the UID list as a
      permission grant, not a convenience.
*/
class CfgPatches
{
    class sovran_zeus
    {
        requiredVersion = 0.1;
        requiredAddons[] = {"exile_server", "A3_Modules_F_Curator"};
        units[] = {};
        weapons[] = {};
        magazines[] = {};
        ammo[] = {};
    };
};

class CfgFunctions
{
    class SOVRAN
    {
        class Zeus
        {
            file = "sovran_zeus";
            class zeusInit { postInit = 1; };
        };
    };
};
