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
      * map-click arming is time-boxed, so a stray click a minute later does
        not fling you across the island
      * everything is local; nothing is broadcast to other clients
*/

if (!hasInterface) exitWith {};

XCSV_TP_ADMINS = [
    "76561198108041726"     // Mr. Sage
];

// How long the map stays armed after choosing "teleport to map click".
XCSV_TP_ArmSeconds = 45;

// Named jump targets for testing the dialogue addons. These are verified
// mission marker/trader coordinates, not rough town centers.
XCSV_TP_Places = [
    ["Trader - South",       [2265.13, 8596.37, 0]],
    ["Trader - Mountain",    [12190.4, 8167.03, 0]],
    ["Trader - North",       [7991.1, 12411.6, 0]],
    ["Aircraft - North",     [11579.8, 13156.0, 0]],
    ["Aircraft - Central",   [7199.99, 6961.1, 0]],
    ["Boat Trader - NE",     [11074.7, 13391.8, 0]]
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

XCSV_fnc_tpArmMapClick = {
    if (missionNamespace getVariable ["XCSV_TP_Armed", false]) exitWith {
        systemChat "XCSV TP: map already armed.";
    };
    missionNamespace setVariable ["XCSV_TP_Armed", true];
    systemChat format
        ["XCSV TP: open the map and SHIFT-CLICK a destination (%1s).", XCSV_TP_ArmSeconds];

    // onMapSingleClick gives us shift state without fighting Exile's own map
    // handlers. Cleared on use or on timeout so it cannot linger.
    onMapSingleClick "
        if (_shift) then {
            [_pos, 'map click'] call XCSV_fnc_tpTo;
            missionNamespace setVariable ['XCSV_TP_Armed', false];
            onMapSingleClick '';
        };
    ";

    [] spawn {
        uiSleep XCSV_TP_ArmSeconds;
        if (missionNamespace getVariable ["XCSV_TP_Armed", false]) then {
            missionNamespace setVariable ["XCSV_TP_Armed", false];
            onMapSingleClick "";
            systemChat "XCSV TP: map disarmed.";
        };
    };
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
    diag_log "[XCSV_TP] admin teleport available (XM8 app + scroll menu).";
};
