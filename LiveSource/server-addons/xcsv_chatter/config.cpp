/*
    xcsv_chatter - in-world faction radio for XCSV EXILE

    Gives the island a voice. Exile's mechanics are already diegetic (poptabs are
    prison scrip, respect is standing among inmates, territory tax is gang
    extortion) but nothing ever speaks. This broadcasts short transmissions
    attributed to in-world factions instead of a plain "Server :" announcer.

    OUR OWN WORK. Exile is CC BY-NC-ND 4.0: we may not distribute modified
    Exile, but this is an independent addon that only *calls* Exile functions.
    No Exile source is copied into it. Our copyright, our licence.

    DESIGN CONSTRAINTS (all deliberate):

    * Server-side only. Lives in @ExileServer\addons. Players download nothing.

    * Most modules create no objects. The XCSV scene module is the exception:
      it creates bounded server-side world content only. Clients still get no
      createVehicle authority, so BattlEye filter exposure stays unchanged.

    * Uses ExileServer_system_thread_addTask, NOT its own `while {true}` loop.
      Arma runs every scheduled script on ONE thread sharing ~3ms per frame;
      adding another spinning loop steals from that budget. Exile's scheduler
      already exists, so we ride it. This is the same mechanism a3_exile_lootbox
      uses for its broadcasts, which is proven working on this server.

    * Lines are STATIC DATA. Nothing here is generated at runtime. If an LLM is
      ever used to write more lines it runs OFFLINE, output is reviewed by a
      human, and the result is pasted in as literals. There is no model process,
      no socket, no API. Players cannot influence what is not running.
      DO NOT ADD A RUNTIME INFERENCE PATH.
*/

class CfgPatches
{
    class xcsv_chatter
    {
        requiredVersion = 0.1;
        // exile_server so we load after Exile's scheduler exists.
        requiredAddons[] = {"exile_server"};
        units[] = {};
        weapons[] = {};
        magazines[] = {};
        ammo[] = {};
    };
};

class CfgFunctions
{
    class xcsv_chatter
    {
        class Bootstrap
        {
            file = "xcsv_chatter\bootstrap";

            class preInit  { preInit  = 1; };
            class postInit { postInit = 1; };
        };

        // Leaderboard cache. Server-only: it reads the database and publishes
        // the result as a public variable for the XM8 app to render. No
        // request/response pair, so a client cannot ask for anything and
        // therefore cannot spam the database.
        class Scoreboard
        {
            file = "xcsv_chatter\scoreboard";

            class scoreboardPublish {};
        };

        // Island Chronicle. Reads Exile's own player_history and retells real
        // deaths as radio traffic. Overrides nothing - it is a pure read, so
        // there is no CfgExileCustomCode entry for a future addon to collide
        // with.
        class Chronicle
        {
            file = "xcsv_chatter\chronicle";

            class chronicleTick {};
        };
        // Blackouts. Server-side weather only - the commands propagate to
        // clients on their own, and Exile's own temperature/wetness model
        // supplies the mechanical bite, so nothing is hooked or overridden.
        // Faction standing. Derived and read-only: computed from account data
        // the server already holds. Gating prices needs trading overrides and a
        // client->server write path, deferred with 12.6 so that path is built
        // once, properly.
        class Standing
        {
            file = "xcsv_chatter\standing";

            class standingPublish {};
        };
        class Weather
        {
            file = "xcsv_chatter\weather";

            class blackoutTick {};
        };

        // Server-authored world scenes. First slice: poptab courier vans with
        // dead runners and a locked safe that uses Exile's existing grinder
        // action. Bounded count, tagged objects, no database persistence.
        class Scenes
        {
            file = "xcsv_chatter\scenes";

            class courierScenes {};
        };

        // "While you were away." A private situation report pushed once to each
        // returning player: protection running down, a stolen flag, vehicles the
        // garbage collector took, deaths on their ground.
        //
        // Pure read of fields Exile already writes, so like the Chronicle there
        // is no CfgExileCustomCode entry to collide with. No request/response
        // pair either - the server notices and pushes, so a client cannot ask
        // and therefore cannot spam the database.
        //
        // briefingDefine only DEFINES things when called; postInit must call it
        // before the first tick.
        class Briefing
        {
            file = "xcsv_chatter\briefing";

            class briefingDefine {};
            class briefingTick {};
        };

        // Dead Man's Switch (roadmap 12.6). THE FIRST CLIENT -> SERVER WRITE
        // PATH in our addons -- everything before it was read-only or
        // server-push. Read fn_policyBuyRequest.sqf before adding a second
        // one; it documents what the engine validates for you and what it
        // does not.
        //
        // policyBuyRequest is reached by Exile's network dispatcher, which
        // resolves ExileServer_<module>_network_<message> from
        // CfgNetworkMessages. The dispatcher looks that name up in
        // missionNamespace, so postInit aliases it there.
        class Policy
        {
            file = "xcsv_chatter\network";

class policyBuyRequest {};
            class policyDeath {};
            class debugBridge {};
            class teleportRequest {};
            class inspectorRequest {};
        };
    };
};
