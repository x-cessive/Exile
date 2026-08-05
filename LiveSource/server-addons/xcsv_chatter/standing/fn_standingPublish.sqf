/*
    xcsv_chatter\standing\fn_standingPublish.sqf - SERVER side

    Faction standing. The three radio voices stop being decoration and start
    having an opinion about each player.

    SCOPE, STATED HONESTLY:

    The original design had standing gate trader prices and stock. That needs
    overrides on Exile's trading functions AND a client->server write path,
    which is the same dependency Dead Man's Switch has. Rather than half-build
    that twice, standing here is DERIVED and READ-ONLY: computed from account
    data the server already stores, published for display, gating nothing yet.

    That is a real feature - a player can see how the island reads them, and it
    changes as they play - and it establishes the data model that gating will
    use later. It is not a substitute for gating, and the roadmap says so.

    THE MODEL (deliberately simple and bounded):

      THE YARD        violence and notoriety. Kills, with a kill/death bonus.
      SALVAGE NET     trade and accumulation. Locker wealth plus respect.
      WARDEN CONTROL  endurance and compliance. Sessions survived, minus deaths.

    Every term is clamped to 0-100, so no value can run away and no divide can
    blow up on a fresh account with zero deaths.

    Pure read. No override, no write, no objects.
*/

if (!isServer) exitWith {};

private _rows = "getStandingData" call ExileServer_system_database_query_selectFull;

if (isNil "_rows" || {!(_rows isEqualType [])}) exitWith {
    diag_log "[XCSV_STAND] no usable data - keeping the previous standings";
};

private _out = [];

{
    if ((_x isEqualType []) && {(count _x) >= 7}) then {
        private _uid    = _x select 0;
        private _name   = _x select 1;
        private _score  = parseNumber str (_x select 2);
        private _kills  = parseNumber str (_x select 3);
        private _deaths = parseNumber str (_x select 4);
        private _locker = parseNumber str (_x select 5);
        private _conns  = parseNumber str (_x select 6);

        // Deaths of zero is legitimate on a new account, so guard the ratio
        // rather than assuming there is always a denominator.
        private _kd = if (_deaths > 0) then { _kills / _deaths } else { _kills };

        private _yard    = (( _kills * 8) + (_kd * 10)) min 100 max 0;
        private _salvage = ((( _locker / 5000) * 40) + ((_score / 200) * 40)) min 100 max 0;
        private _warden  = ((_conns * 2) + (0 max (30 - (_deaths * 3)))) min 100 max 0;

        _out pushBack [
            _uid, _name,
            round _yard, round _salvage, round _warden
        ];
    };
} forEach _rows;

missionNamespace setVariable ["XCSV_Standing", _out, true];

diag_log format ["[XCSV_STAND] published standing for %1 player(s)", count _out];

true
