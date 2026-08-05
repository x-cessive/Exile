/*
    xcsv/fn_traderVoice.sqf - CLIENT side

    Traders on this server have never said a word. This gives each type a voice
    when you walk up to it.

    Why client-side and not in xcsv_chatter.pbo: that addon lives in
    @ExileServer, which is a SERVER mod. Clients never receive it, and this is
    per-player UI - only the person standing at the counter should hear it. So
    it belongs in the mission, which clients do download.

    Constraints kept deliberately the same as the server addon:
      * static lines only, no runtime generation, no model call
      * creates no objects, so BattlEye has nothing to complain about
      * one low-frequency loop, not a per-frame handler

    The loop is 4 s and only does a nearEntities check. Trader dialogue is not
    worth a single frame of server FPS, and this runs on the client anyway.
*/

if (!hasInterface) exitWith {};

XCSV_TRADER_Lines = createHashMapFromArray [
    ["Exile_Trader_Armory", [
        "Everything here has been fired before. Most of it still works.",
        "You break it out there, that is between you and the island.",
        "No refunds. No receipts. No questions."
    ]],
    ["Exile_Trader_Equipment", [
        "Take the bag. You will fill it with rubbish and be grateful for it.",
        "Boots and bandages outlast bravado. Every time.",
        "If you are buying rope you had better be building, not climbing."
    ]],
    ["Exile_Trader_Food", [
        "It is edible. That is the whole claim.",
        "Water first. Everyone forgets water until they cannot forget it.",
        "The tinned stuff came off a mainland shipment. Do not ask which one."
    ]],
    ["Exile_Trader_Hardware", [
        "Build something they cannot carry away. Then build a lock.",
        "Concrete outlasts everyone here, including me.",
        "Anyone can buy a codelock. Very few can remember the code."
    ]],
    ["Exile_Trader_Vehicle", [
        "It runs. I did not say it stops.",
        "Lock it or you are shopping for the next one tomorrow.",
        "The fuel is your problem the moment you turn the key."
    ]],
    ["Exile_Trader_VehicleCustoms", [
        "New paint will not make it faster. It will make it yours.",
        "Cosmetic. Entirely cosmetic. Worth every poptab."
    ]],
    ["Exile_Trader_Aircraft", [
        "Anything that goes up on this island comes down uninvited.",
        "You are buying altitude. Landing is sold separately.",
        "Rotors draw attention for miles. Bear that in mind."
    ]],
    ["Exile_Trader_AircraftCustoms", [
        "A repaint will not stop the missiles. It will look better on the way down."
    ]],
    ["Exile_Trader_Boat", [
        "The water is the only road nobody has claimed yet.",
        "Reef wrecks are worth a look. So is knowing when to leave one."
    ]],
    ["Exile_Trader_BoatCustoms", [
        "Paint below the waterline is a waste. Buy it anyway."
    ]],
    ["Exile_Trader_Diving", [
        "Whatever went down out there is still down there.",
        "Air is finite. So is your luck. Track both."
    ]],
    ["Exile_Trader_Office", [
        "Territory paperwork. The one thing on this island that is still filed properly.",
        "Pay the levy. The alternative is explaining yourself to somebody with a laptop.",
        "A flag is a claim, not a guarantee."
    ]],
    ["Exile_Trader_SpecialOperations", [
        "You are not special. The kit is.",
        "Buy this and people will assume you know what you are doing. Try to."
    ]],
    ["Exile_Trader_WasteDump", [
        "One survivor's rubbish. Priced accordingly.",
        "I buy anything. I said anything, not everything."
    ]],
    ["Exile_Trader_CommunityCustoms", [
        "Somebody else's leftovers, cleaned up and marked up."
    ]],
    ["Exile_Trader_RussianRoulette", [
        "The odds are printed on the wall. Nobody reads them.",
        "House does not lose. House occasionally pays."
    ]]
];

// Do not re-greet the same trader for this many seconds.
XCSV_TRADER_Cooldown = 240;
XCSV_TRADER_Range    = 12;

[] spawn {
    // Let Exile finish spawning the player and the trader objects first.
    uiSleep 25;

    private _lastSpoken = createHashMap;

    while {true} do {
        uiSleep 4;

        if (alive player) then {
            // nearEntities is cheap and scoped; this never touches the server.
            private _near = player nearEntities [["Exile_Trader_Abstract"], XCSV_TRADER_Range];
            if (count _near > 0) then {
                private _trader = _near select 0;
                private _type   = typeOf _trader;
                private _id     = str _trader;
                private _now    = time;
                private _last   = _lastSpoken getOrDefault [_id, -99999];

                if ((_now - _last) > XCSV_TRADER_Cooldown) then {
                    private _lines = XCSV_TRADER_Lines getOrDefault [_type, []];
                    if !(_lines isEqualTo []) then {
                        _lastSpoken set [_id, _now];
                        private _name = getText (configFile >> "CfgVehicles" >> _type >> "displayName");
                        if (_name isEqualTo "") then { _name = "Trader" };
                        systemChat format ["%1: %2", _name, selectRandom _lines];
                    };
                };
            };
        };
    };
};

diag_log "[XCSV_TRADER] trader voice active (client, static lines).";
