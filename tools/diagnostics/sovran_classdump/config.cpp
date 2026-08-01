/*
    sovran_classdump - one-shot diagnostic addon

    Dumps every class the RUNNING server actually knows about to the RPT, so
    addon-referenced classnames can be diffed against ground truth instead of
    guessed at. Install, boot once, harvest the RPT, then REMOVE it -- it writes
    several MB to the log on every startup and has no business living on a
    production server.
*/
class CfgPatches
{
    class sovran_classdump
    {
        requiredVersion = 0.1;
        requiredAddons[] = {"exile_server"};
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
        class Diagnostics
        {
            file = "sovran_classdump";
            class dumpClasses { postInit = 1; };
        };
    };
};
