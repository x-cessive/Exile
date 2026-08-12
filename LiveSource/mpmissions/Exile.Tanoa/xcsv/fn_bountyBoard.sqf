/*
    xcsv/fn_bountyBoard.sqf - CLIENT side

    Bounty Board, XM8 App21. First slice only: a read-only contract board
    surface. It deliberately does not post bounties, reserve poptabs, listen to
    death events, or call the server. The existing bounty addons need a separate
    integration pass before any write/death-hook path is safe to expose.
*/

if (!hasInterface) exitWith {};

XCSV_BOUNTY_TOPICS = [
    ["Status", "
    <t size='1.0' color='#3D9CFF'>BOUNTY BOARD</t><br/><br/>
    The board is being brought online in slices. This version is read-only: it
    explains how contracts will work, but it does not take poptabs and it does
    not mark anybody as hunted yet.<br/><br/>
    That is intentional. Bounties touch money, player death, target selection
    and public notifications, so the live write path will not be enabled until
    it has its own server-side audit trail and rollback evidence.
    "],

    ["Contract rules", "
    <t size='1.0' color='#E8B339'>CONTRACT RULES</t><br/><br/>
    Planned contract flow:<br/>
    - A player posts poptabs on a target.<br/>
    - The server holds the amount, not the client.<br/>
    - A valid kill claims the reward.<br/>
    - Safe-zone and abuse cases are refused server-side.<br/><br/>
    No client-supplied amount, target name, or kill claim will be trusted by
    itself. The server must re-resolve every identity and every payout.
    "],

    ["Why locked", "
    <t size='1.0' color='#E05050'>WHY THIS IS LOCKED</t><br/><br/>
    There are unused bounty systems in the source tree, but turning one on is
    not the same as shipping a server feature. They carry their own network
    messages, reward code, timers, markers and death hooks.<br/><br/>
    XCSV will integrate the smallest safe path first: visible board, server
    contract ledger, then payout verification. Anything that pays on a death
    needs live evidence before it graduates from this screen.
    "]
];

XCSV_fnc_bountyFill = {
    disableSerialization;
    params [["_index", 0]];

    private _display = uiNamespace getVariable ["RscExileXM8", displayNull];
    if (isNull _display) exitWith {};

    private _body = _display displayCtrl 71862;
    if (isNull _body) exitWith {};

    if (_index < 0 || {_index >= (count XCSV_BOUNTY_TOPICS)}) exitWith {};

    _body ctrlSetStructuredText parseText ((XCSV_BOUNTY_TOPICS select _index) select 1);
    [_body] call XCSV_fnc_fitText;

    diag_log format ["[XCSV_BOUNTY] rendered topic %1.", _index];
};

XCSV_fnc_bountyShow = {
    disableSerialization;

    ["xcsvBounty", 0] call ExileClient_gui_xm8_slide;

    private _display = uiNamespace getVariable ["RscExileXM8", displayNull];
    if (isNull _display) exitWith {};

    private _list = _display displayCtrl 71861;
    if (isNull _list) exitWith {};

    lbClear _list;
    { _list lbAdd (_x select 0) } forEach XCSV_BOUNTY_TOPICS;
    _list lbSetCurSel 0;

    [0] call XCSV_fnc_bountyFill;
};

diag_log format ["[XCSV_BOUNTY] board ready (%1 topics, read-only).", count XCSV_BOUNTY_TOPICS];
