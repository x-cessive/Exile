/*
    xcsv_chatter\network\fn_teleportRequest.sqf - SERVER side

    Admin teleport request from xcsv\fn_adminTeleport.sqf.

    The client is not trusted for identity or authority. Exile's dispatcher
    gives us the session ID, then this handler resolves the player object and
    UID server-side before doing anything.
*/

private _sessionID = _this select 0;
private _params = _this select 1;

XCSV_TP_SERVER_ADMINS = [
    "76561198108041726"     // Mr. Sage
];

try {
    private _playerObject = _sessionID call ExileServer_system_session_getPlayerObject;
    if (isNull _playerObject) throw "Invalid player object";
    if !(alive _playerObject) throw "You cannot teleport while dead.";

    private _uid = getPlayerUID _playerObject;
    if !(_uid in XCSV_TP_SERVER_ADMINS) throw "Not authorised.";

    private _pos = _params select 0;
    private _label = _params select 1;
    if !(_pos isEqualType []) throw "Invalid destination.";
    if ((count _pos) < 2) throw "Invalid destination.";

    private _x = parseNumber str (_pos select 0);
    private _y = parseNumber str (_pos select 1);
    if (_x <= 0 || {_y <= 0} || {_x > 15360} || {_y > 15360}) then {
        throw format ["Off-map destination %1,%2.", _x, _y];
    };

    private _requested = [_x, _y, 0];
    private _safe2D = [_requested, 0, 175, 7, 0, 0.35, 0, [], [0, 0]]
        call BIS_fnc_findSafePos;

    if ((_safe2D isEqualTo [0, 0]) || {surfaceIsWater _safe2D}) then {
        throw format ["No safe ground near %1 [%2,%3].", _label, round _x, round _y];
    };
    if ((_safe2D distance2D _requested) > 350) then {
        throw format ["Nearest safe ground is too far from %1.", _label];
    };

    private _obj = vehicle _playerObject;
    private _z = [0.25, 1.0] select (_obj != _playerObject);
    private _safe = [_safe2D select 0, _safe2D select 1, _z];

    _playerObject allowDamage false;
    _obj allowDamage false;
    _obj setVelocity [0, 0, 0];
    _obj setPosATL _safe;
    _obj setVectorUp (surfaceNormal _safe);

    [_playerObject, _obj] spawn {
        params ["_playerObject", "_obj"];
        sleep 5;
        if !(isNull _obj) then {
            _obj allowDamage true;
        };
        if !(isNull _playerObject) then {
            _playerObject allowDamage true;
        };
    };

    [_sessionID, "toastRequest", ["SuccessTitleAndText",
        ["Admin teleport", format ["Moved to %1 [%2, %3].", _label, round (_safe select 0), round (_safe select 1)]]]]
        call ExileServer_system_network_send_to;

    diag_log format ["[XCSV_TP] %1 teleported to %2 requested [%3,%4] safe [%5,%6]",
        _uid, _label, _x, _y, _safe select 0, _safe select 1];
}
catch {
    [_sessionID, "toastRequest", ["ErrorTitleAndText", ["Admin teleport", _exception]]]
        call ExileServer_system_network_send_to;
    diag_log format ["[XCSV_TP] refused: %1", _exception];
};

true
