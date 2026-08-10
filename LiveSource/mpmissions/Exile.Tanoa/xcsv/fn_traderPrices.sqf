/*
    xcsv/fn_traderPrices.sqf - CLIENT side

    Trader price lookup on the XM8. Search any item and see what it costs, what
    it sells back for, and which trader actually stocks it.

    WHY THIS IS WORTH BUILDING (roadmap 10.2):

    Tanoa is large and the traders are far apart. Without this, finding out
    whether a trader carries an item means flying there and looking. That is a
    lot of the early game spent on logistics rather than play.

    WHERE THE DATA COMES FROM - all of it client-side config, no server call:

      CfgExileArsenal      className -> price, sellPrice, quality
      CfgTraderCategories  category  -> items[] and a display name
      CfgTraders           trader    -> categories[]
      CfgTrading           sellPriceFactor, used when sellPrice is absent

    Because every one of those lives in missionConfigFile, this app makes NO
    network call, touches NO database and creates NO objects. BattlEye is not
    involved and the server pays nothing for it. That is the whole reason this
    one is cheap while a territory browser is not.

    IF PRICES CHANGE IN CfgExileArsenal, NOTHING NEEDS CHANGING HERE. The index
    is built from the config at runtime, so unlike fn_fieldNotes.sqf this cannot
    drift out of date.

    SAFETY NOTE: the search box is player-typed text. It is used ONLY for
    matching with `find`, and is never interpolated into structured text -- so
    there is no markup-injection path. Keep it that way; the Standing app had to
    grow a character-by-character escaper for exactly this reason.
*/

if (!hasInterface) exitWith {};

XCSV_PRICE_Rows  = [];   // filtered rows currently shown: [display, class]
XCSV_PRICE_Index = [];   // every sellable item: [displayLower, display, class]

/*
    Resolve an item's human name.

    Deliberately checks the four config roots by hand rather than calling an
    Exile helper: `ExileClient_util_gear_getItemDisplayName` is not present on
    every install, and calling a function that may not exist is how a client
    script dies silently on one server and works on another (see roadmap 12.2).
*/
XCSV_fnc_priceName = {
    params ["_class"];
    private _n = "";
    {
        if (_n isEqualTo "") then {
            private _c = configFile >> _x >> _class;
            if (isClass _c) then {
                private _d = getText (_c >> "displayName");
                if !(_d isEqualTo "") then { _n = _d };
            };
        };
    } forEach ["CfgWeapons", "CfgMagazines", "CfgVehicles", "CfgGlasses"];
    if (_n isEqualTo "") then { _n = _class };
    _n
};

// class -> [trader display names]. Built once; the arsenal is ~3000 lines and
// re-walking it per keystroke would make the search feel broken.
XCSV_PRICE_Traders = createHashMap;

XCSV_fnc_priceBuild = {
    private _catToTraders = createHashMap;

    // trader -> categories[]  inverted into  category -> [trader names]
    {
        private _traderCfg = _x;
        private _tname = getText (_traderCfg >> "name");
        if (_tname isEqualTo "") then { _tname = configName _traderCfg };
        {
            private _cur = _catToTraders getOrDefault [_x, []];
            if !(_tname in _cur) then {
                _cur pushBack _tname;
                _catToTraders set [_x, _cur];
            };
        } forEach (getArray (_traderCfg >> "categories"));
    } forEach ("true" configClasses (missionConfigFile >> "CfgTraders"));

    // category -> items[]  joined through the map above to give item -> traders
    {
        private _catName = configName _x;
        private _traders = _catToTraders getOrDefault [_catName, []];
        {
            private _cur = XCSV_PRICE_Traders getOrDefault [_x, []];
            {
                if !(_x in _cur) then { _cur pushBack _x };
            } forEach _traders;
            XCSV_PRICE_Traders set [_x, _cur];
        } forEach (getArray (_x >> "items"));
    } forEach ("true" configClasses (missionConfigFile >> "CfgTraderCategories"));

    // Every priced item, whether or not a trader currently stocks it. An item
    // with a price but no trader is worth showing precisely because it tells
    // you not to go looking for one.
    XCSV_PRICE_Index = [];
    {
        private _class = configName _x;
        private _disp  = [_class] call XCSV_fnc_priceName;
        XCSV_PRICE_Index pushBack [toLower _disp, _disp, _class];
    } forEach ("true" configClasses (missionConfigFile >> "CfgExileArsenal"));

    XCSV_PRICE_Index sort true;
    diag_log format ["[XCSV_PRICE] indexed %1 priced items.", count XCSV_PRICE_Index];
};

XCSV_fnc_priceFill = {
    params [["_row", -1]];
    private _display = uiNamespace getVariable ["RscExileXM8", displayNull];
    if (isNull _display) exitWith {};
    private _body = _display displayCtrl 71853;
    if (isNull _body) exitWith {};

    if (_row < 0 || {_row >= count XCSV_PRICE_Rows}) exitWith {
        _body ctrlSetStructuredText parseText
            "<t color='#7E8896'>Type in the box above to search, then pick a result.</t>";
    };

    (XCSV_PRICE_Rows select _row) params ["_disp", "_class"];

    private _cfg   = missionConfigFile >> "CfgExileArsenal" >> _class;
    private _price = getNumber (_cfg >> "price");

    // sellPrice is optional; Exile falls back to price * sellPriceFactor. Read
    // the factor from config rather than hardcoding 0.5, so this stays correct
    // if the economy is ever retuned.
    private _sell = if (isNumber (_cfg >> "sellPrice")) then {
        getNumber (_cfg >> "sellPrice")
    } else {
        floor (_price * (getNumber (missionConfigFile >> "CfgTrading" >> "sellPriceFactor")))
    };

    private _quality = getNumber (_cfg >> "quality");
    private _traders = XCSV_PRICE_Traders getOrDefault [_class, []];

    private _where = if (_traders isEqualTo []) then {
        "<t color='#E05050'>No trader stocks this.</t>"
    } else {
        format ["<t color='#3FC16A'>%1</t>", _traders joinString ", "]
    };

    // _disp and _class come from config, not from the player, so they are safe
    // to place in structured text unescaped.
    _body ctrlSetStructuredText parseText format ["
        <t size='1.1' color='#3D9CFF'>%1</t><br/>
        <t size='0.8' color='#7E8896'>%2</t><br/><br/>
        <t color='#E8B339'>Buy</t>   <t size='1.1'>%3</t> poptabs<br/>
        <t color='#E8B339'>Sell</t>  <t size='1.1'>%4</t> poptabs<br/>
        <t size='0.8' color='#7E8896'>quality tier %5</t><br/><br/>
        <t color='#E8B339'>Sold at</t><br/>%6
    ", _disp, _class, _price, _sell, _quality, _where];
};

XCSV_fnc_priceSearch = {
    private _display = uiNamespace getVariable ["RscExileXM8", displayNull];
    if (isNull _display) exitWith {};
    private _edit = _display displayCtrl 71851;
    private _list = _display displayCtrl 71852;
    if (isNull _list) exitWith {};

    private _q = toLower (ctrlText _edit);

    XCSV_PRICE_Rows = [];
    {
        _x params ["_lower", "_disp", "_class"];
        if (_q isEqualTo "" || {(_lower find _q) > -1} || {(toLower _class find _q) > -1}) then {
            XCSV_PRICE_Rows pushBack [_disp, _class];
        };
    } forEach XCSV_PRICE_Index;

    // Cap the rendered rows. An empty query matches the whole arsenal and
    // filling a listbox with thousands of entries stalls the client.
    private _capped = false;
    if (count XCSV_PRICE_Rows > 300) then {
        XCSV_PRICE_Rows resize 300;
        _capped = true;
    };

    lbClear _list;
    { _list lbAdd (_x select 0) } forEach XCSV_PRICE_Rows;
    if (_capped) then { _list lbAdd "... narrow your search" };

    if (count XCSV_PRICE_Rows > 0) then {
        _list lbSetCurSel 0;
    } else {
        [-1] call XCSV_fnc_priceFill;
    };
};

XCSV_fnc_priceShow = {
    disableSerialization;

    ["xcsvPrices", 0] call ExileClient_gui_xm8_slide;

    if (XCSV_PRICE_Index isEqualTo []) then { call XCSV_fnc_priceBuild };

    call XCSV_fnc_priceSearch;
};

[] spawn {
    uiSleep 25;
    waitUntil { uiSleep 2; alive player };
    // Built up front so the first open is instant; it is a one-off config walk.
    call XCSV_fnc_priceBuild;
};
