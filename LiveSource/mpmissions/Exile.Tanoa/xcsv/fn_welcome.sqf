/*
    xcsv/fn_welcome.sqf - CLIENT side

    The lore briefing. Exile's premise is already in the mechanics - poptabs are
    prison scrip, respect is standing among inmates, territory tax is protection
    money, Bambi is what the old hands call a new arrival - but the server has
    never once said so. This tells a new player where they are.

    Delivered on the XM8, in-fiction, as a message that was waiting on the
    handset when they picked it up. That framing is why the XM8 is the right
    surface: it is contraband, it is the only link off the island, and every
    player already has one.

    Shown ONCE per player profile. profileNamespace survives disconnects and
    restarts, so a returning player is not lectured every spawn. Set
    XCSV_WELCOME_Force = true in the debug console to see it again.

    Canon note: 2039, after a resource war in Greece and a European deflation
    crisis, NATO's Security Council exiles convicts to this island. Verified
    against the mission's own mission.sqm, which sets year = 2039.
    NOT canon and deliberately excluded: the "four gangs" framing that
    circulates - that comes from ExileLifeMod, a fork, not base Exile.
*/

if (!hasInterface) exitWith {};

[] spawn {
    // Wait for the player to actually be in the world with a working XM8.
    uiSleep 20;
    waitUntil { uiSleep 2; alive player && !isNull (findDisplay 46) };

    private _seen  = profileNamespace getVariable ["XCSV_WelcomeSeen", 0];
    private _force = missionNamespace getVariable ["XCSV_WELCOME_Force", false];

    // Version-gated: bumping this re-shows the briefing to everyone, which is
    // how a future rewrite reaches players who already saw version 1.
    private _version = 1;

    if (_seen >= _version && !_force) exitWith {};

    profileNamespace setVariable ["XCSV_WelcomeSeen", _version];
    saveProfileNamespace;

    private _lines = [
        "",
        "XCSV EXILE",
        "",
        "2039. The war over what was left of Greece emptied the treasuries, and",
        "the deflation that followed emptied everything else. Crime went where",
        "money went. The Security Council needed somewhere to put the overflow.",
        "",
        "They chose this island. Then they largely forgot about it.",
        "",
        "A private contractor holds the paperwork now. They run the safe zones,",
        "take a cut of the trade, and do not pretend to run anything else.",
        "",
        "What you need to know:",
        "  - Poptabs are prison scrip. Respect is what the old hands think of you.",
        "  - A flag is a claim, not a guarantee. Pay the levy or lose the ground.",
        "  - Fresh arrivals are called Bambi. It wears off. So does the protection.",
        "  - Lock it, bury it, or lose it.",
        "",
        "Nobody is coming for you. Build something anyway."
    ];

    // Toast first so it registers even if the XM8 is closed, then the full text.
    ["InfoTitleAndText", ["XCSV EXILE", "Incoming message on your XM8."]]
        call ExileClient_gui_toaster_addTemplateToast;

    uiSleep 3;
    {
        systemChat _x;
        uiSleep 0.35;
    } forEach _lines;

    diag_log "[XCSV_WELCOME] briefing delivered.";
};
