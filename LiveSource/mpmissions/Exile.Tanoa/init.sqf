/*
    init.sqf - runs on EVERY machine (dedicated server and each client).

    This mission had no init.sqf until 2026-08-03. Exile's own bootstrap uses
    initServer.sqf and initPlayerLocal.sqf, and everything XCSV had added so far
    fitted one of those two.

    R3F Logistics needs this one specifically. Its init branches internally on
    `isServer` and `isDedicated` and sets up a different half on each, so it
    cannot be moved into initPlayerLocal (clients only) or initServer (server
    only) without breaking one side.

    Keep this file for machine-agnostic bootstraps only. If something is
    client-only it belongs in initPlayerLocal.sqf, and server-only work belongs
    in initServer.sqf or in the xcsv_chatter addon.
*/

/*
    R3F Logistics - lifting, towing and moving objects.

    HISTORY, so this is not re-litigated a third time: R3F was installed and
    reverted on 2026-08-03 after appearing to halve server FPS. That measurement
    was contaminated -- a second XCSV GUARD instance was running and IT was the
    cost (see roadmap 1.8). Reinstalled for a clean retest against a known
    baseline of 45.5-46.6 FPS at 111-114 AI.

    The creation factory stays DISABLED
    (R3F_LOG_CFG_string_condition_allow_creation_factory_on_this_client =
    "false"). It lets players spawn objects from a category whitelist, which on
    a persistent survival server is free loot. Do not enable it.

    BattlEye: R3F ships a 55 KB scripts.txt that is a wholesale REPLACEMENT, not
    a patch, and applying it would clobber this server's tuned exceptions. It is
    deliberately not applied. Every BE rule here is action 1 (log only) today so
    nothing can be kicked -- but if enforcement is ever raised (roadmap 0.8),
    the R3F lines must be merged by hand first or lifting will kick people.
*/
[] execVM "R3F_LOG\init.sqf";
