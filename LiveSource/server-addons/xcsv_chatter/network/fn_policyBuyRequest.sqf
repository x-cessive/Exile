/*
    xcsv_chatter\network\fn_policyBuyRequest.sqf - SERVER side

    THE FIRST CLIENT -> SERVER WRITE PATH IN OUR ADDONS.

    Everything we have shipped so far is read-only or server-push: the
    Chronicle reads player_history, Standing and the Scoreboard publish a public
    variable, Field Notes and Prices read config. Nothing a player did could
    change server state. This can, and it spends their money, so it is written
    with more care than a feature of this size would normally justify -- the
    point is that everything after it copies this file.

    WHAT THE ENGINE ALREADY GUARANTEES (ExileServer_system_network_dispatchIncomingMessage):

      * the session ID exists and is registered
      * the message name is declared in CfgNetworkMessages
      * the parameter COUNT and TYPES match the declaration

    WHAT IT DOES NOT, AND SO THIS FILE MUST:

      * identity      - never trust a client-supplied UID. The player object is
                        resolved from the session ID, and the UID is read off
                        that object.
      * value         - the price is a server-side constant. The client sends
                        NO parameters at all, so there is nothing to tamper
                        with. Never accept an amount from a client.
      * affordability - checked against ExileMoney server-side, immediately
                        before the deduction.
      * rate          - a cooldown per UID, so a modified client cannot spam the
                        database with purchase requests.
      * atomicity     - money comes off before the policy is granted. If the
                        grant somehow fails the player is out the tabs, which is
                        the safe direction to fail; granting first would let a
                        failed deduction mint free policies.

    Money is mutated exactly the way Exile does it in
    ExileServer_system_territory_network_payTerritoryProtectionMoneyRequest:
    setVariable with public=true, then `setPlayerMoney` to persist. Doing it any
    other way desyncs the client's own display.
*/

private _sessionID = _this select 0;

// Price and cooldown live here, server-side, on purpose.
#define XCSV_POLICY_PRICE     2500
#define XCSV_POLICY_COOLDOWN  20
#define XCSV_POLICY_MAXCHARGES 3

try {
    private _playerObject = _sessionID call ExileServer_system_session_getPlayerObject;
    if (isNull _playerObject) throw "Invalid player object";
    if !(alive _playerObject) throw "You cannot buy a policy while dead.";

    private _uid = getPlayerUID _playerObject;
    if (_uid isEqualTo "") throw "No UID on that player";

    // Rate limit, keyed on UID rather than session so reconnecting does not
    // reset it. Stored on the server only.
    private _cooldowns = missionNamespace getVariable ["XCSV_POLICY_Cooldowns", createHashMap];
    private _now = diag_tickTime;
    private _last = _cooldowns getOrDefault [_uid, -9999];
    if ((_now - _last) < XCSV_POLICY_COOLDOWN) throw "Slow down.";

    // Stamp the cooldown on ATTEMPT, not on success.
    //
    // It used to be stamped further down, past every validation, so only a
    // COMPLETED purchase started the clock. Every refusal path - dead, broke,
    // already at max charges - was therefore free to repeat immediately, and
    // the client-side 3s timer that would normally hide that runs on a machine
    // the player controls. A modified client could hold the button down and
    // generate unbounded toasts and log writes.
    //
    // The database is not exposed by this: every refusal returns before any
    // query. This is a log and CPU abuse fix, not a data one.
    _cooldowns set [_uid, _now];
    missionNamespace setVariable ["XCSV_POLICY_Cooldowns", _cooldowns];

    private _held = _playerObject getVariable ["XCSV_PolicyCharges", 0];
    if (_held >= XCSV_POLICY_MAXCHARGES) then {
        throw format ["You already hold %1 policies.", _held];
    };

    private _money = _playerObject getVariable ["ExileMoney", 0];
    if (_money < XCSV_POLICY_PRICE) then {
        throw format ["Costs %1 poptabs, you carry %2.", XCSV_POLICY_PRICE, _money];
    };

    // --- past this point we are committing --------------------------------
    _money = _money - XCSV_POLICY_PRICE;
    _playerObject setVariable ["ExileMoney", _money, true];
    format ["setPlayerMoney:%1:%2", _money, _playerObject getVariable ["ExileDatabaseID", 0]]
        call ExileServer_system_database_query_fireAndForget;

    format ["xcsvPolicyBuy:%1", _uid] call ExileServer_system_database_query_fireAndForget;

    // Mirror onto the object so the death handler does not need a database
    // round-trip at the worst possible moment.
    _held = _held + 1;
    _playerObject setVariable ["XCSV_PolicyCharges", _held, true];

    [_sessionID, "toastRequest", ["SuccessTitleAndText",
        ["Policy purchased", format ["%1 held. On death, %2%3 of carried poptabs goes to your locker.",
            _held, XCSV_POLICY_PAYOUT_PCT, "%"]]]] call ExileServer_system_network_send_to;

    diag_log format ["[XCSV_POLICY] %1 bought a policy for %2 (now holds %3, carries %4)",
        _uid, XCSV_POLICY_PRICE, _held, _money];
}
catch {
    // Exile's own pattern: tell the player why, log it, never leave them
    // guessing at a silent no-op.
    [_sessionID, "toastRequest", ["ErrorTitleAndText", ["Policy", _exception]]]
        call ExileServer_system_network_send_to;
    diag_log format ["[XCSV_POLICY] refused: %1", _exception];
};

true
