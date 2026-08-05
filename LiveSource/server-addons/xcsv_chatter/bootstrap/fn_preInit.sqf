/*
    xcsv_chatter - preInit

    Defines the static line tables. Nothing here is generated at runtime.

    If these lines are ever expanded with help from a language model, that
    happens OFFLINE: generate, read every line, paste the survivors in here as
    literals. There is deliberately no model call, no socket and no file read at
    runtime, so a player has no path to influence what the world says.

    Tone: Exile is set in 2039 on a prison island after a resource war in
    Greece and a European deflation crisis. NATO exiled its convicts here and
    then largely forgot them. Poptabs are prison scrip, respect is standing
    among inmates, territory tax is protection money, and the XM8 is a
    contraband phone. The register is dry and a bit bleak - not heroic, not
    fantasy. Keep new lines in that voice.
*/

// Grace period after server start before the first transmission, in seconds.
// Long enough that the world has finished populating and players are not
// reading radio traffic over a loading screen.
XCSV_CHATTER_FirstDelay = 300;

// Seconds between transmissions. 11 minutes is deliberately not a round number
// so it does not lock step with the loot, mission or restart cycles.
XCSV_CHATTER_Interval = 660;

/*
    WARDEN CONTROL - the private security contractor that runs the island.
    Bureaucratic, bored, faintly contemptuous. Never threatening directly; it
    does not need to be.
*/
XCSV_CHATTER_Warden = [
    "WARDEN CONTROL: Headcount is a formality. We stopped expecting the numbers to match.",
    "WARDEN CONTROL: Reminder that salvage rights on this island belong to the contract holder. That is not you.",
    "WARDEN CONTROL: Perimeter drones are down for maintenance. They have been down for maintenance for nine months.",
    "WARDEN CONTROL: Medical resupply has been rescheduled to next quarter. Again.",
    "WARDEN CONTROL: Territory levies are due. Non-payment is not punished. It is simply noted, and then forgotten about, along with the territory.",
    "WARDEN CONTROL: Any inmate reaching the mainland will be recorded as deceased for accounting purposes.",
    "WARDEN CONTROL: We are aware of the trading. We take a cut. Carry on.",
    "WARDEN CONTROL: Your sentence length is on file. The file is on the mainland. Nobody is going to check it."
];

/*
    THE YARD - inmates talking to inmates. Practical, gallows humour, the voice
    of people who have been here long enough to stop being frightened.
*/
XCSV_CHATTER_Yard = [
    "THE YARD: New arrivals came in on the drop. Give them a day before you take anything off them. Or don't.",
    "THE YARD: Somebody's been leaving traps in the good houses again. Watch your step up north.",
    "THE YARD: If a trader smiles at you, check your poptabs before you leave the safe zone.",
    "THE YARD: Wrecks out on the reef still have fuel in them. Bring a canister and a friend you trust.",
    "THE YARD: The old hands can tell a Bambi by how fast they run at a helicopter crash.",
    "THE YARD: Flag went dark over in the west. Either they paid up late or they are not coming back.",
    "THE YARD: Rule of the island: lock it, bury it, or lose it.",
    "THE YARD: Everyone here was somebody on the mainland. Nobody here cares."
];

/*
    SALVAGE NET - the trading and scavenging channel. Rumour, tips, market
    noise. This is where a player learns something useful.
*/
XCSV_CHATTER_Salvage = [
    "SALVAGE NET: Crash sites cool off fast. If the smoke has stopped, so has your window.",
    "SALVAGE NET: Somebody is buying laptops. No questions, no names, good rate.",
    "SALVAGE NET: Word is there are traders working outside the safe zones. Find them before someone else does.",
    "SALVAGE NET: Lockpicks are cheap. What they open is not.",
    "SALVAGE NET: Fuel is worth more than ammunition this week. It usually is.",
    "SALVAGE NET: If you can carry it, it is yours. If you cannot, it is somebody else's.",
    "SALVAGE NET: Check the bins. Everyone walks past the bins."
];

// Weighted rotation: the Warden speaks least, so it still lands when it does.
XCSV_CHATTER_Channels = [
    ["XCSV_CHATTER_Yard",    4],
    ["XCSV_CHATTER_Salvage", 3],
    ["XCSV_CHATTER_Warden",  2]
];

/* ------------------------------------------------------------------------
   Scoreboard settings

   How often the leaderboard is re-read from the database and re-published.
   300s is deliberately slow: the board is a curiosity, not a HUD, and every
   query competes with the same single server thread as everything else.
   ------------------------------------------------------------------------ */
XCSV_SB_Interval = 300;

/* ------------------------------------------------------------------------
   Island Chronicle

   Real deaths, read from Exile's own player_history table, retold as radio
   traffic. Offset from the chatter interval so the two do not fire together
   and read as a wall of text.

   Every line takes exactly two arguments: %1 the player's name, %2 the nearest
   named place. Both are passed as ARGUMENTS to format, never as the format
   string - a player's name is whatever they typed into Steam and must never be
   able to carry format specifiers.

   Tone matches the chatter: dry, bleak, no heroics. The island does not mourn.
   ------------------------------------------------------------------------ */
XCSV_CHRON_Interval = 420;

XCSV_CHRON_Lines = [
    "SALVAGE NET: %1 stopped moving near %2. Their kit did not.",
    "SALVAGE NET: Word from %2 - %1 is not coming back for their things.",
    "SALVAGE NET: Somebody found what is left of %1 outside %2. Somebody always does.",
    "SALVAGE NET: %1 went quiet around %2. If you are quick, that is an opportunity.",
    "THE YARD: %1 got themselves killed near %2. Learn from it or do not.",
    "THE YARD: They are carrying %1 out of %2 in pieces. The island keeps score.",
    "THE YARD: %2 took another one. %1 this time.",
    "WARDEN CONTROL: Inmate %1 flatlined near %2. No recovery team is coming.",
    "WARDEN CONTROL: Vitals lost on %1, last position %2. Logged and forgotten.",
    "SALVAGE NET: %1's last known position was %2. Draw your own conclusions."
];

/* ------------------------------------------------------------------------
   Blackouts

   Periodic storms. The mechanical effect is free: Exile's own temperature and
   wetness model already punishes being caught out in heavy rain, so the storm
   bites without a single client-side hook.

   Rolled every CheckInterval with probability Chance, subject to a cooldown -
   so storms are irregular, which is the point. At 900s / 0.30 / 3600s cooldown
   the island averages roughly one storm every couple of hours.
   ------------------------------------------------------------------------ */
XCSV_BO_CheckInterval = 900;   // how often a roll happens
XCSV_BO_Chance        = 0.30;  // probability per roll
XCSV_BO_Cooldown      = 3600;  // minimum quiet time after one ends
XCSV_BO_Duration      = 900;   // how long the storm holds at full strength
XCSV_BO_RampIn        = 120;   // seconds to darken
XCSV_BO_RampOut       = 180;   // seconds to clear

XCSV_BO_WarnLines = [
    "WARDEN CONTROL: Pressure is dropping fast. Weather advisory for the whole island.",
    "WARDEN CONTROL: Front moving in from the north-east. Secure what you cannot afford to lose.",
    "SALVAGE NET: Sky is going the wrong colour. If you are in the open, stop being in the open."
];

XCSV_BO_HitLines = [
    "WARDEN CONTROL: Storm is over the island. Visibility is gone and so is any help.",
    "THE YARD: Anyone still out in this is either desperate or hunting. Assume hunting.",
    "SALVAGE NET: Nobody can see you in this. That cuts exactly both ways."
];

XCSV_BO_ClearLines = [
    "WARDEN CONTROL: Front is passing. Conditions easing island-wide.",
    "SALVAGE NET: Sky is clearing. Whatever the storm moved is still out there.",
    "THE YARD: Storm is done. Count what you have left."
];

/* ------------------------------------------------------------------------
   Operator debug bridge (network/fn_debugBridge.sqf).

   Lets the operator stage test scenarios from outside the game -- teleport,
   set poptabs, force a payout -- because client-side features otherwise need
   a human at the keyboard to exercise them.

   It is a FIXED command set, not an eval channel, and every command is gated
   to admin UIDs. Set this to false and repack to switch it off entirely.
   ------------------------------------------------------------------------ */
XCSV_DEBUG_ENABLED = true;

diag_log "[XCSV_CHATTER] line tables loaded (static, no runtime generation).";
true
