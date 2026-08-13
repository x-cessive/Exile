/*
    xcsv/fn_adminTeleport.sqf - CLIENT side, ADMIN ONLY

    Admin teleport: to a map click, to a player, or to a named location. Built
    for testing the dialogue addons without walking the length of Tanoa.

    ------------------------------------------------------------------------
    READ THIS BEFORE ENABLING BATTLEYE ENFORCEMENT
    ------------------------------------------------------------------------
    Teleport is executed server-side through xcsvTeleportRequest. The client
    only asks for a position; the server resolves identity from the Exile
    session, checks its own UID whitelist, validates the Tanoa coordinate range
    and moves `vehicle player` from server locality. This avoids local setPos
    being undone by Exile/infiSTAR sync and keeps the permission check off the
    client.
    ------------------------------------------------------------------------

    Design:
      * admin-gated by UID, same shape as fn_census and sovran_zeus
      * no objects created; only the player (and their vehicle) is moved
      * SHIFT-click on the map is ALWAYS live for a whitelisted admin from
        session start; there is no arming step and no XM8 button to press
        first (changed 2026-08-12 at the operator's request)
      * everything is local; nothing is broadcast to other clients
*/

if (!hasInterface) exitWith {};

XCSV_TP_ADMINS = [
    "76561198108041726"     // Mr. Sage
];

// The persistent map-click handler is re-asserted on this interval. Nothing in
// SQF can read the current onMapSingleClick handler back, so if another script
// (an Exile dialog, a third-party addon) installs its own and clears it, ours
// would be gone for good. Re-asserting costs one assignment per interval and
// makes the feature self-healing.
XCSV_TP_ReassertSeconds = 30;

// Named jump targets for testing the dialogue addons. These are verified
// mission marker/trader coordinates, not rough town centers.
XCSV_TP_Places = [
    ["Trader - South",       [2265.13, 8596.37, 0]],
    ["Trader - Mountain",    [12190.4, 8167.03, 0]],
    ["Trader - North",       [7991.1, 12411.6, 0]],
    ["Aircraft - North",     [11579.8, 13156.0, 0]],
    ["Aircraft - Central",   [7199.99, 6961.1, 0]],
    ["Boat Trader - NE",     [11074.7, 13391.8, 0]],
    ["Prison - Graybox",     [7140, 11800, 0]]
];

XCSV_fnc_tpTo = {
    params ["_pos", ["_what", "position"]];
    if (isNil "_pos" || {(_pos select 0) <= 0}) exitWith {
        systemChat "XCSV TP: invalid destination.";
    };

    private _dest = +_pos;
    _dest set [2, 0];

    ["xcsvTeleportRequest", [_dest, _what]] call ExileClient_system_network_send;
    systemChat format ["XCSV TP: requested %1 [%2, %3]",
        _what, round (_dest select 0), round (_dest select 1)];
};

/*
    Install the persistent SHIFT-click handler.

    onMapSingleClick gives us the shift state without fighting Exile's own map
    handlers, and it is deliberately NOT cleared after use: a whitelisted admin
    can shift-click the map at any time for the whole session.

    The handler only acts while SHIFT is held. With shift up the `if` yields
    nil, which the engine reads as false, so normal map behaviour (Exile's own
    marker placement) is untouched.
*/
XCSV_fnc_tpInstallMapClick = {
    onMapSingleClick "
        if (_shift) then {
            [_pos, 'map click'] call XCSV_fnc_tpTo;
            true
        };
    ";
    missionNamespace setVariable ["XCSV_TP_Armed", true];
};

// Kept under the old name: config.cpp's XM8 button and any older call site
// still reach it, but there is nothing left to arm.
XCSV_fnc_tpArmMapClick = {
    call XCSV_fnc_tpInstallMapClick;
    systemChat "XCSV TP: SHIFT-click the map any time - always on, no arming needed.";
};

// Entry point called by the XM8 button.
XCSV_fnc_tpMenu = {
    if !((getPlayerUID player) in XCSV_TP_ADMINS) exitWith {
        systemChat "XCSV TP: not authorised.";
    };

    systemChat "--- XCSV ADMIN TELEPORT ---";
    call XCSV_fnc_tpArmMapClick;

    // Players and named places are offered as scroll actions rather than a
    // dialog: no custom Rsc controls to maintain, and they disappear when the
    // target does.
    private _added = missionNamespace getVariable ["XCSV_TP_Actions", []];
    { player removeAction _x } forEach _added;
    _added = [];

    {
        private _p = _x;
        if (!(isNull _p) && {_p != player}) then {
            _added pushBack (player addAction [
                format ["<t color='#3D9CFF'>TP to %1</t>", name _p],
                {
                    private _target = (_this select 3) select 0;
                    [getPosATL _target, format ["player %1", name _target]] call XCSV_fnc_tpTo;
                },
                [_p], 2.0, false, true, "", "true", 10
            ]);
        };
    } forEach allPlayers;

    {
        private _label = _x select 0;
        private _pos   = _x select 1;
        _added pushBack (player addAction [
            format ["<t color='#7E8896'>TP: %1</t>", _label],
            {
                private _args = _this select 3;
                [_args select 0, _args select 1] call XCSV_fnc_tpTo;
            },
            [_pos, _label], 1.0, false, true, "", "true", 10
        ]);
    } forEach XCSV_TP_Places;

    missionNamespace setVariable ["XCSV_TP_Actions", _added];
    systemChat format ["XCSV TP: %1 destinations added to your scroll menu.", count _added];
};

[] spawn {
    uiSleep 30;
    waitUntil { uiSleep 2; alive player };
    if !((getPlayerUID player) in XCSV_TP_ADMINS) exitWith {};
    diag_log "[XCSV_TP] admin teleport available (map SHIFT-click + XM8 app + scroll menu).";

    // Always-on map teleport. The XM8 app is now a convenience for the named
    // places and player list, not a prerequisite for shift-click.
    call XCSV_fnc_tpInstallMapClick;
    systemChat "XCSV TP: SHIFT-click the map to teleport (always on).";

    // Not gated on `alive player`: dying must not end the loop, or the handler
    // would be lost for the rest of the session after the first respawn.
    [] spawn {
        while { true } do {
            uiSleep XCSV_TP_ReassertSeconds;
            call XCSV_fnc_tpInstallMapClick;
        };
    };

    // Prison - Graybox, always on the scroll wheel for the admin (no XM8
    // needed). Uses the same server-side xcsvTeleportRequest path.
    player addAction [
        "<t color='#FF7D3D'>XCSV TP: Prison - Graybox</t>",
        {
            _this select 3 call XCSV_fnc_tpTo;
        },
        [[7140, 11800, 0], "Prison - Graybox"], 3.0, false, true, "", "true", 12
    ];
};
