/*
    sovran_zeus - grant the Curator (Zeus) interface to whitelisted players.

    Runs server-side only. Polls connected players and, for anyone on the whitelist
    who does not already hold a curator logic, creates one and assigns it.

    Polling rather than a PlayerConnected event handler is deliberate: at
    PlayerConnected time the player's unit does not exist yet, and Exile puts players
    through a spawn-selection screen before their real unit is created. Polling side-
    steps all of that, and a 15 second wait to gain Zeus is not worth extra complexity.
*/

if (!isServer) exitWith {};

// ---------------------------------------------------------------------------
// EDIT THIS: Steam64 IDs allowed to use Zeus.
// Find yours in the server RPT after connecting, or at steamid.io.
// ---------------------------------------------------------------------------
SOVRAN_ZEUS_UIDS =
[
    // "76561198000000000"
];

SOVRAN_ZEUS_POLL = 15;

diag_log format ["[SOVRAN_ZEUS] init - %1 UID(s) whitelisted, polling every %2s",
    count SOVRAN_ZEUS_UIDS, SOVRAN_ZEUS_POLL];

if (SOVRAN_ZEUS_UIDS isEqualTo []) exitWith
{
    diag_log "[SOVRAN_ZEUS] whitelist is empty - nobody will be granted Zeus. Edit SOVRAN_ZEUS_UIDS in fn_zeusInit.sqf and repack.";
};

[] spawn
{
    while {true} do
    {
        {
            private _player = _x;
            private _uid = getPlayerUID _player;

            if (_uid in SOVRAN_ZEUS_UIDS) then
            {
                // Already holding a curator? Leave it alone.
                if (isNull (getAssignedCuratorLogic _player)) then
                {
                    private _group = createGroup sideLogic;
                    private _curator = _group createUnit ["ModuleCurator_F", [0, 0, 0], [], 0, "NONE"];

                    // 3 = all addons available in the Zeus asset list
                    _curator setVariable ["Addons", 3, true];
                    _curator setVariable ["owner", _uid, true];

                    _player assignCurator _curator;
                    _curator addCuratorEditableObjects [entities "", true];

                    diag_log format ["[SOVRAN_ZEUS] granted Zeus to %1 (%2)", name _player, _uid];
                };
            };
        } forEach allPlayers;

        uiSleep SOVRAN_ZEUS_POLL;
    };
};
