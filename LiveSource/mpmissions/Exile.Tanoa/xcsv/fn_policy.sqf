/*
    xcsv/fn_policy.sqf - CLIENT side

    Dead Man's Switch, XM8 App19. The client half of the first client->server
    write path in our addons (roadmap 12.6).

    WHAT THIS FILE DELIBERATELY DOES NOT DO:

    It does not calculate the price, it does not check whether you can afford
    it, and it does not decide whether the purchase succeeds. It sends a
    parameterless request and renders whatever the server says. Every one of
    those decisions lives in xcsv_chatter\network\fn_policyBuyRequest.sqf,
    because anything decided here is decided on a machine the player controls.

    The button is disabled for a few seconds after a press. That is a courtesy
    to stop double-clicks, NOT a security control -- the real rate limit is a
    per-UID cooldown on the server, which a modified client cannot skip.
*/

if (!hasInterface) exitWith {};

XCSV_POLICY_LastSend = -9999;

XCSV_fnc_policyRefresh = {
    disableSerialization;
    private _display = uiNamespace getVariable ["RscExileXM8", displayNull];
    if (isNull _display) exitWith {};
    private _body = _display displayCtrl 71833;
    if (isNull _body) exitWith {};

    // Published by the server on the player object, so this is a read of state
    // the server owns rather than anything the client tracks itself.
    private _charges = player getVariable ["XCSV_PolicyCharges", 0];
    private _money   = player getVariable ["ExileMoney", 0];

    private _state = if (_charges > 0) then {
        format ["<t color='#3FC16A'>%1 policy(s) held</t>", _charges]
    } else {
        "<t color='#7E8896'>No policy held</t>"
    };

    _body ctrlSetStructuredText parseText format ["
        <t size='1.1' color='#3D9CFF'>DEAD MAN'S SWITCH</t><br/><br/>
        %1<br/>
        <t size='0.85' color='#7E8896'>You carry %2 poptabs.</t><br/><br/>
        Buy a policy and the next time you die, half of what you were carrying
        is credited to your <t color='#E8B339'>locker</t> - capped, and the
        locker is never lost.<br/><br/>
        <t size='0.85' color='#7E8896'>Your body still drops everything it was
        carrying. Whoever kills you loses nothing, and you are not paid twice:
        the payout comes from the house, not from your corpse.</t><br/><br/>
        <t size='0.85' color='#7E8896'>A policy is only spent on a death where
        you were actually carrying poptabs. Dying broke keeps the charge.</t>
    ", _state, _money];

    // Render heartbeat - see the note in fn_scoreboard.sqf. This one also
    // records the charge count, which is the number the whole feature turns on
    // and which had never once been observed as non-zero.
    diag_log format ["[XCSV_POLICY] rendered panel, %1 charge(s) held.", _charges];
};

XCSV_fnc_policyBuy = {
    private _now = diag_tickTime;
    if ((_now - XCSV_POLICY_LastSend) < 3) exitWith {
        systemChat "Wait a moment.";
    };
    XCSV_POLICY_LastSend = _now;

    // No parameters: the server decides the price and knows who we are from
    // the session. See CfgNetworkMessages >> xcsvPolicyBuyRequest.
    ["xcsvPolicyBuyRequest", []] call ExileClient_system_network_send;

    // The server answers with a toast either way. Refresh shortly after so the
    // held-count reflects a success without needing a response message of our
    // own.
    // Say something if the server says nothing.
    //
    // All feedback used to be delegated to a server toast, so when the request
    // could not reach its handler at all - which was the case from the day this
    // shipped until 2026-08-10, see the alias fix in xcsv_chatter's postInit -
    // the panel simply redrew itself unchanged. A failed purchase and a
    // successful one were byte-identical on screen.
    //
    // Comparing the charge count before and after is enough to tell them apart
    // without inventing a second network message, and it stays useful after the
    // alias fix: it now also covers a dropped packet or a server-side refusal.
    private _before = player getVariable ["XCSV_PolicyCharges", 0];
    [_before] spawn {
        params ["_before"];
        uiSleep 2.5;
        call XCSV_fnc_policyRefresh;
        if ((player getVariable ["XCSV_PolicyCharges", 0]) isEqualTo _before) then {
            // Deliberately does NOT claim the server failed to answer. A refusal
            // the server DID send - broke, already at max charges, dead - also
            // leaves the count unchanged, and the server's own toast explains
            // those. Claiming "no response" would contradict a message the
            // player can see on screen. All this line can honestly assert is
            // that nothing changed and nothing was taken.
            systemChat "Insurance: policy not purchased. Nothing was charged.";
        };
    };
};

XCSV_fnc_policyShow = {
    disableSerialization;
    ["xcsvPolicy", 0] call ExileClient_gui_xm8_slide;
    call XCSV_fnc_policyRefresh;
};

diag_log "[XCSV_POLICY] client app ready.";
