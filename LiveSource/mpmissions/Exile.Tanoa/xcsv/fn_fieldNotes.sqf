/*
    xcsv/fn_fieldNotes.sqf - CLIENT side

    A field manual on the XM8. Exile explains almost nothing, and a server with
    a handful of players cannot afford to lose one to confusion in their first
    hour.

    DESIGN CHANGE FROM THE ORIGINAL PROPOSAL:

    This was specced as an unlock system - notes earned by doing things. That is
    backwards. The whole point is comprehension, and gating the manual behind
    achievements withholds it from exactly the player who needs it. Everything
    is readable from the first minute.

    THE NUMBERS HERE ARE THIS SERVER'S, NOT GENERIC EXILE.

    Territory prices, radii, the 150 m build ceiling, the 0.5 sell factor, the
    virtual garage capacities - all read out of this mission's own config.cpp
    and CfgTerritories. That is the entire value: a generic Exile guide is a web
    search away, a guide that matches the server you are standing on is not.

    IF YOU CHANGE THOSE CONFIG VALUES, CHANGE THEM HERE TOO. A manual that lies
    is worse than no manual.

    Static text, client-side only. No server call, no database, no objects, so
    BattlEye is not involved and this costs the server nothing.
*/

if (!hasInterface) exitWith {};

// [ title, body ]. Body is structured text - escape any dynamic content before
// it goes in here. Everything below is a literal, so nothing needs escaping.
XCSV_NOTES = [

    ["Staying alive", "
    <t size='1.0' color='#3D9CFF'>STAYING ALIVE</t><br/><br/>
    Hunger and thirst fall constantly. Thirst falls faster. Neither kills you
    quickly, but both slow you down and stack with everything else.<br/><br/>
    <t color='#E8B339'>Temperature</t> matters on Tanoa more than people expect.
    Rain plus night plus wet clothing drops you fast. Get dry, get inside, or
    light a fire.<br/><br/>
    <t color='#E8B339'>Bleeding</t> does not stop on its own. A bandage stops it.
    If your screen is greying at the edges you are already losing.<br/><br/>
    Drink from wells and taps rather than the sea. Cook meat before eating it.
    "],

    ["Medical", "
    <t size='1.0' color='#3D9CFF'>MEDICAL</t><br/><br/>
    Exile's medical model is short and unforgiving, and nothing in game explains
    it.<br/><br/>
    <t color='#E8B339'>Bandage</t> - stops bleeding. Does not restore health.<br/>
    <t color='#E8B339'>Vishpirin</t> - restores health slowly over time. Take it
    after you have stopped the bleeding, not before.<br/>
    <t color='#E8B339'>Instadoc</t> - immediate, expensive, for emergencies.<br/>
    <t color='#E8B339'>Defibrillator</t> - revives someone who has gone down but
    not yet respawned. Somebody else has to use it on you.<br/><br/>
    Order matters: stop the bleeding first. Vishpirin on an open wound is poptabs
    poured into the dirt.
    "],

    ["Money and respect", "
    <t size='1.0' color='#3D9CFF'>POPTABS AND RESPECT</t><br/><br/>
    <t color='#E8B339'>Poptabs</t> are cash. Carry them and you can lose them.
    Put them in your <t color='#3FC16A'>locker</t> at a trader and they are safe
    from everything.<br/><br/>
    <t color='#E8B339'>Respect</t> is not money. You cannot spend it and you
    cannot lose it by dying. It gates what you are allowed to buy and how far you
    can upgrade a territory.<br/><br/>
    Traders buy at <t color='#E05050'>half</t> what they sell for on this server
    (sell factor 0.5). Do not expect to make money moving goods between two
    traders.<br/><br/>
    Re-keying a vehicle you have claimed costs 10% of its value.
    "],

    ["Territory and decay", "
    <t size='1.0' color='#3D9CFF'>TERRITORY</t><br/><br/>
    A flag makes a base yours. Without one, anything you build is anyone's.<br/><br/>
    On this server:<br/>
    - Level 1 costs <t color='#E8B339'>5,000 poptabs</t>, 15 m radius, 30 objects.<br/>
    - Levels 2 and up cost <t color='#E8B339'>respect</t>, not poptabs.<br/>
    - Level 10 reaches 150 m and 300 objects.<br/>
    - You may own <t color='#E8B339'>2</t> territories.<br/>
    - Flags must be <t color='#E8B339'>1,000 m</t> from any trader or spawn zone,
      and <t color='#E8B339'>325 m</t> from another territory.<br/><br/>
    <t color='#E05050'>DECAY IS THE THING THAT KILLS BASES.</t> Protection money
    is due regularly - <t color='#E8B339'>10 poptabs per object, per flag
    level</t>. A level 5 base with 100 objects costs 5,000 a cycle, and it gets
    more expensive every time you upgrade. Let it lapse and the base is deleted.
    Not raided. Deleted.<br/><br/>
    After a charge is planted on your territory, building is blocked for 5
    minutes, so you cannot wall in an attacker mid-raid.
    "],

    ["Building", "
    <t size='1.0' color='#3D9CFF'>BUILDING</t><br/><br/>
    You need a hammer and the right materials. Build inside your flag's radius or
    it does not count as yours.<br/><br/>
    The build height ceiling on this server is <t color='#E8B339'>150 m</t>. You
    will be told when you hit it.<br/><br/>
    Objects count against your territory level. A level 1 flag holds 30. Upgrade
    before you run out, not after.<br/><br/>
    Doors and safes take codes. <t color='#E05050'>Forget the code and it is
    gone</t> - nobody can recover it for you.
    "],

    ["Vehicles and the garage", "
    <t size='1.0' color='#3D9CFF'>VEHICLES</t><br/><br/>
    Lock everything. An unlocked vehicle belongs to whoever sits in it.<br/><br/>
    <t color='#E8B339'>Virtual Garage</t> is accessed at your territory flag. A
    stored vehicle leaves the world entirely - it cannot be found, raided or
    blown up, and it stops costing the server anything.<br/><br/>
    Capacity by flag level: level 1 cannot store at all; level 2 holds 5, rising
    to 28 at level 10.<br/><br/>
    <t color='#E05050'>Storing a vehicle empties it.</t> Inventory and money are
    dumped on the ground where the vehicle stood. Take your things out first.<br/><br/>
    You cannot use the garage while in combat.
    "],

    ["Safe zones and rules", "
    <t size='1.0' color='#3D9CFF'>SAFE ZONES</t><br/><br/>
    Trader areas are protected. You cannot shoot there, and you should not try -
    the protection is enforced, not requested.<br/><br/>
    Vehicles left in a safe zone are not safe forever. Take them with you.<br/><br/>
    <t color='#E8B339'>The server is publicly listed and running BattlEye and
    infiSTAR.</t> Both log. Play straight and neither will ever bother you.<br/><br/>
    If something looks broken rather than unfair, report it - broken things get
    fixed here.
    "],

    ["The island", "
    <t size='1.0' color='#3D9CFF'>THE ISLAND</t><br/><br/>
    2039. A resource war over Greece emptied the treasuries, and the deflation
    that followed emptied everything else.<br/><br/>
    The Security Council exiled the overflow here and largely forgot about it. A
    private contractor holds the paperwork, runs the safe zones and takes a cut
    of the trade.<br/><br/>
    Three voices still transmit:<br/>
    <t color='#E05050'>WARDEN CONTROL</t> - the contractor. Announcements, not
    conversation.<br/>
    <t color='#E8B339'>THE YARD</t> - the inmates. Rumour and threat.<br/>
    <t color='#3FC16A'>SALVAGE NET</t> - trade and scavenging. The one worth
    listening to.<br/><br/>
    Poptabs are prison scrip. Respect is standing among inmates. Territory tax is
    protection money. You are not a hero here; you are overflow.
    "]
];

XCSV_fnc_notesFill = {
    disableSerialization;
    params [["_index", 0]];

    private _display = uiNamespace getVariable ["RscExileXM8", displayNull];
    if (isNull _display) exitWith {};

    private _body = _display displayCtrl 71812;
    if (isNull _body) exitWith {};

    if (_index < 0 || {_index >= (count XCSV_NOTES)}) exitWith {};

    _body ctrlSetStructuredText parseText ((XCSV_NOTES select _index) select 1);

    // Render heartbeat - see the note in fn_scoreboard.sqf.
    diag_log format ["[XCSV_NOTES] rendered topic %1.", _index];
};

XCSV_fnc_notesShow = {
    disableSerialization;

    ["xcsvNotes", 0] call ExileClient_gui_xm8_slide;

    private _display = uiNamespace getVariable ["RscExileXM8", displayNull];
    if (isNull _display) exitWith {};

    private _list = _display displayCtrl 71811;
    if (isNull _list) exitWith {};

    lbClear _list;
    { _list lbAdd (_x select 0) } forEach XCSV_NOTES;
    _list lbSetCurSel 0;

    [0] call XCSV_fnc_notesFill;
};

diag_log format ["[XCSV_NOTES] field manual ready (%1 topics).", count XCSV_NOTES];
