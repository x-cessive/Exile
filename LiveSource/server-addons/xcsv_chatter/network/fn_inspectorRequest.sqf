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

    // Strip LIKE wildcards. The client does this too, but the client runs on a
    // machine the player controls, so the authoritative strip is here.
    //
    // This is a CORRECTNESS guard, not an injection guard - the fragment is
    // bound as a positional ? and was never concatenated into SQL. The bug it
    // prevents is quieter than injection: a "%" makes "%<fragment>%" match every
    // account, and the query is ORDER BY last_connect_at DESC LIMIT 1, so the
    // app would confidently render the wrong player instead of failing.
    // Character codes, not string literals: the third character is a backslash
    // and Arma's preprocessor reads a backslash as a line continuation.
    // 37 = %, 95 = _, 92 = backslash.
    _fragment = toString ((toArray _fragment) select { !(_x in [37, 95, 92]) });
    if ((count _fragment) < 2) throw "Name too short after wildcard strip.";

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

    // Answer even on refusal. Without this the client sends a request and then
    // waits forever on a screen that looks identical to "still loading", which
    // is how a refused admin experiences a bug rather than a decision.
    //
    // The reply is deliberately an EMPTY result rather than the reason: it
    // renders as "No match", so a refusal and a genuine miss look the same to
    // the caller and this cannot be used to probe the whitelist. The real
    // reason is in the server log, where it belongs.
    try {
        [_sessionID, "xcsvInspectResponse", [[], []]] call ExileServer_system_network_send_to;
    } catch {};
};

true