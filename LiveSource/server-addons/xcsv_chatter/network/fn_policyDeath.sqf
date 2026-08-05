/*
    xcsv_chatter\network\fn_policyDeath.sqf - SERVER side

    Dead Man's Switch payout (roadmap 12.6).

    WHY THIS DOES NOT TOUCH THE CORPSE, AND WHY THAT IS DELIBERATE:

    The obvious implementation is "move a fraction of carried poptabs into the
    locker instead of dropping them". That requires reducing ExileMoney before
    Exile's own death handling reads it -- and the order in which a Killed
    event handler runs relative to ExileServer_object_player_death is NOT
    guaranteed. Get it wrong in one direction and the player loses money twice;
    get it wrong in the other and the money is duplicated. Neither failure is
    visible in testing until someone dies at the wrong moment.

    So this pays out as genuine insurance instead: the corpse still drops
    everything it was carrying, and the locker is credited separately. That is
    completely independent of ordering, does not interfere with Exile's death
    path at all, and leaves PvP loot untouched -- killing someone still yields
    exactly what they carried.

    THE ECONOMY IS A SINK, NOT A FAUCET. Premium 2500, payout 50% of carried
    capped at 6000, so the maximum possible payout is 3000. A player only comes
    out ahead by dying while carrying more than 5000 poptabs, which is a bad
    strategy on purpose. Everyone else is funding the house.

    NO OVERRIDE. This is a Killed event handler added on connect, not a
    CfgExileCustomCode replacement of ExileServer_object_player_death. Two
    reasons: overriding it would mean reimplementing or copying Exile's death
    logic, and pasting Exile's source into our addon is the one thing the
    CC BY-NC-ND licence actually forbids (roadmap 6.0). Adding no override is
    also the design goal that made the Chronicle safe.
*/

if (!isServer) exitWith {};

XCSV_POLICY_PAYOUT_PCT = 50;     // percent of carried poptabs
XCSV_POLICY_PAYOUT_CAP = 6000;   // ...of at most this much

/*
    Called with the dying player object. Kept separate from the event handler
    registration so it can be tested by calling it directly.
*/
XCSV_fnc_policyPayout = {
    params [["_unit", objNull]];
    if (isNull _unit) exitWith { false };

    private _uid = getPlayerUID _unit;
    if (_uid isEqualTo "") exitWith { false };

    private _charges = _unit getVariable ["XCSV_PolicyCharges", 0];
    if (_charges <= 0) exitWith { false };

    private _carried = _unit getVariable ["ExileMoney", 0];
    if (_carried <= 0) exitWith {
        // A policy is not consumed when there was nothing to insure. Burning a
        // charge on a death with empty pockets would feel like a bug.
        diag_log format ["[XCSV_POLICY] %1 died holding a policy but carried nothing - charge kept", _uid];
        false
    };

    private _insured = (_carried min XCSV_POLICY_PAYOUT_CAP);
    private _payout  = floor (_insured * XCSV_POLICY_PAYOUT_PCT / 100);
    if (_payout <= 0) exitWith { false };

    private _locker = _unit getVariable ["ExileLocker", 0];
    private _new = _locker + _payout;

    // Exile's own locker path: public setVariable, then persist by UID.
    _unit setVariable ["ExileLocker", _new, true];
    format ["updateLocker:%1:%2", _new, _uid] call ExileServer_system_database_query_fireAndForget;

    _charges = _charges - 1;
    _unit setVariable ["XCSV_PolicyCharges", _charges, true];
    format ["xcsvPolicyConsume:%1", _uid] call ExileServer_system_database_query_fireAndForget;

    diag_log format ["[XCSV_POLICY] payout %1 to %2 locker (carried %3, charges left %4)",
        _payout, _uid, _carried, _charges];

    // The player is dead and their client may already be on the respawn
    // screen, so this is a systemChat rather than a toast -- it survives the
    // transition and is still there when they read the death screen.
    [format ["DEAD MAN'S SWITCH: %1 poptabs recovered to your locker.", _payout]]
        remoteExec ["systemChat", owner _unit];

    true
};

/*
    Charges are authoritative in the database; the object variable is only a
    cache so the death path never has to wait on a query. This reloads it when
    a player connects.
*/
XCSV_fnc_policyLoad = {
    params [["_unit", objNull]];
    if (isNull _unit) exitWith {};
    private _uid = getPlayerUID _unit;
    if (_uid isEqualTo "") exitWith {};

    private _rows = format ["xcsvPolicyGet:%1", _uid] call ExileServer_system_database_query_selectSingle;
    private _charges = 0;
    if (!isNil "_rows" && {_rows isEqualType []} && {count _rows > 0}) then {
        _charges = parseNumber str (_rows select 0);
    };
    _unit setVariable ["XCSV_PolicyCharges", _charges, true];

    _unit addMPEventHandler ["MPKilled", {
        // MPKilled fires on every machine; only the server should pay out.
        if (isServer) then { [_this select 0] call XCSV_fnc_policyPayout };
    }];

    diag_log format ["[XCSV_POLICY] loaded %1 charge(s) for %2", _charges, _uid];
};

/*
    Initialise any player who has not been initialised yet.

    A sweep rather than a connect hook, on purpose. Exile does not expose a
    clean server-side "player object is ready" event that we can subscribe to
    without an override, and overriding one to get a callback would trade a real
    collision risk for a few seconds of latency. Riding the existing scheduler
    costs a `count allPlayers` every 30 s and cannot collide with anything.

    Idempotent by design: the guard variable means a player is only ever
    initialised once, so a second event handler can never be attached and a
    payout cannot fire twice.
*/
XCSV_fnc_policySweep = {
    {
        if (!isNull _x && {alive _x} && {!(_x getVariable ["XCSV_PolicyInit", false])}) then {
            // Set the guard BEFORE loading: the load does a database round
            // trip, and the next sweep must not start a second one.
            _x setVariable ["XCSV_PolicyInit", true];
            [_x] call XCSV_fnc_policyLoad;
        };
    } forEach allPlayers;
};

true
