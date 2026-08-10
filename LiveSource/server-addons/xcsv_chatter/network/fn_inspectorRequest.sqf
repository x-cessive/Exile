/*
    xcsv_chatter\network\fn_inspectorRequest.sqf - SERVER side

    Player Inspector (roadmap 10.1.2, XM8 App20). Admin-only lookup of a
    named player's account + territory rows, answered as a single structured
    response to the requesting session.

    THE CLIENT IS NOT TRUSTED FOR IDENTITY OR AUTHORITY. Exile's dispatcher
    hands us the session ID; this handler resolves the requesting player and
    UID server-side and refuses anyone not on the admin whitelist. The query
    parameter is a name FRAGMENT, never a raw SQL string, and it is bound
    through extDB's positional ? via SQL1_INPUTS, not interpolated -- so there
    is no injection surface regardless of what a client sends.

    RESPONSE MODEL: the answer is one array
        [rows, terrRows]
    where rows is exactly one account row (or [] if no player matches) and
    terrRows is the live territory membership list (which is [] for a player
    who owns no flag). A missing account and an unlucky name both read the
    same: an empty rows array.

    Pure read: no object is created or moved, and nothing is written to the
    database, so BattlEye is not involved.
*/

private _sessionID = _this select 0;
private _params    = _this select 1;

XCSV_INSPECTOR_SERVER_ADMINS = [
    "76561198108041726"     // Mr. Sage
];

try {
    private _adminObject = _sessionID call ExileServer_system_session_getPlayerObject;
    if (isNull _adminObject) throw "Invalid admin session.";

    private _adminUID = getPlayerUID _adminObject;
    if !(_adminUID in XCSV_INSPECTOR_SERVER_ADMINS) throw "Not authorised.";

    private _fragment = _params select 0;
    if !(_fragment isEqualType "") throw "Invalid query.";
    if ((count _fragment) < 2) throw "Name too short.";
    if ((count _fragment) > 64) throw "Name too long.";

    // LIKE needs the fragment wrapped to match substrings. Both the fragment
    // and the % wildcards are bound values, never concatenated into SQL.
    private _pattern = "%" + _fragment + "%";

    // selectFull returns the raw array of rows. We asked for LIMIT 1, so the
    // row we want is the first element (or the array itself is empty).
    private _raw = format ["xcsvInspectorLookup:%1", _pattern]
        call ExileServer_system_database_query_selectFull;

    private _rows = [];
    if (_raw isEqualType []) then {
        if ((count _raw) > 0) then { _rows = [_raw select 0]; };
    };

    private _terrRows = [];
    if ((count _rows) > 0) then {
        private _uid = (_rows select 0) select 0;
        private _all = format ["xcsvInspectorTerritories:%1", _uid]
            call ExileServer_system_database_query_selectFull;
        if (_all isEqualType []) then { _terrRows = _all; };
    };

    [
        _sessionID,
        "xcsvInspectResponse",
        [_rows, _terrRows]
    ] call ExileServer_system_network_send_to;

    diag_log format ["[XCSV_INS] %1 inspected '%2' -> %3 row(s), %4 territory(ies)",
        _adminUID, _fragment, (count _rows), (count _terrRows)];
}
catch {
    diag_log format ["[XCSV_INS] refused: %1", _exception];
};

true