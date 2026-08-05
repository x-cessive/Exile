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

    private _obj = vehicle _playerObject;
    _obj setVelocity [0, 0, 0];
    _obj setPosATL [_x, _y, 0.5];

    [_sessionID, "toastRequest", ["SuccessTitleAndText",
        ["Admin teleport", format ["Moved to %1 [%2, %3].", _label, round _x, round _y]]]]
        call ExileServer_system_network_send_to;

    diag_log format ["[XCSV_TP] %1 teleported to %2 [%3,%4]", _uid, _label, _x, _y];
}
catch {
    [_sessionID, "toastRequest", ["ErrorTitleAndText", ["Admin teleport", _exception]]]
        call ExileServer_system_network_send_to;
    diag_log format ["[XCSV_TP] refused: %1", _exception];
};

true
