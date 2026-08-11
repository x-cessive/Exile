/*
	XCSV override of ExileClient_gui_xm8_slide_extraApps_onOpen.

	Exile renders the extra-apps page from a hardcoded loop over slots 01..14, so
	our apps in 15..20 never appear. This rebuilds the grid over every configured
	XM8_AppNN_Button class instead.

	THE BUG THAT MADE THE PAGE UNUSABLE  (fixed 2026-08-10)
	======================================================
	The buttons were created on the DISPLAY:

	    _display ctrlCreate [_class, _idc]

	A control created that way belongs to no slide. Three consequences, all of
	which were visible at once:

	  * It is never hidden when the XM8 changes page, so the whole grid stayed
	    painted on top of the home screen.
	  * Its coordinates are display coordinates, not slide coordinates, so the
	    grid spilled past the top and bottom of the tablet.
	  * NOTHING COULD BE CLICKED - including the stock apps. The extraApps slide
	    is a controls group covering the tablet; it sits over display-level
	    controls and takes the mouse input they should have received. Buttons
	    were visible through it and deaf to it.

	The fix is to create them INSIDE the slide group. ExileClient_gui_xm8_slide
	resolves a slide by name through CfgXM8:

	    controlID = getNumber (configFile >> "CfgXM8" >> <slide> >> "controlID")

	so the group can be fetched at runtime without hardcoding an id - and stock
	owns "extraApps", so the lookup falls back to configFile. Children of the
	group get group-relative coordinates and the group's input handling, and the
	slide hides them on its own when the page changes.

	Geometry comes from RscXcsvXM8AppButtonGrid, which exists precisely so the
	icon and label offsets scale with the button. Do not resize these at runtime;
	see that class for why.
*/

private _display = uiNameSpace getVariable ["RscExileXM8", displayNull];
if (isNull _display) exitWith {};

disableSerialization;

// Guard-defined: neither half of the open/close pair may assume the other ran.
if (isNil "XCSV_fnc_xm8ExtraAppsClear") then {
	XCSV_fnc_xm8ExtraAppsClear = compile preprocessFileLineNumbers "custom\xm8ExtraAppsClear.sqf";
};
call XCSV_fnc_xm8ExtraAppsClear;

// The slide group. Stock defines "extraApps", so configFile answers; the
// missionConfigFile fallback matches how ExileClient_gui_xm8_slide resolves it.
private _src = missionConfigFile;
if (isClass (configFile >> "CfgXM8" >> "extraApps")) then { _src = configFile };
private _slideId = getNumber (_src >> "CfgXM8" >> "extraApps" >> "controlID");
private _slide = _display displayCtrl _slideId;

if (isNull _slide) exitWith {
	diag_log format ["[XCSV_XM8] extraApps slide %1 not found; grid not built", _slideId];
};

private _maxApp = 26;
private _cols   = 5;

/*
    4007 is the tablet's slide container, and EVERY other XM8 slide in this
    estate is created as a child of it. Ours were created on the display itself,
    and that single omission caused three separate reported faults:

      * GO BACK was visible but deaf. A display-level control created at runtime
        draws on top of 4007 yet receives none of the mouse input 4007 takes.
        This is the same divergence between render order and input order that
        XM8-APPS-001 hit from the other side, documented at the top of this file.
      * The app sat top-left and oversized, because a display-level control's
        0,0 is the SCREEN origin, while a child of 4007 has its 0,0 at the
        tablet's content origin. RscExileXM8Slide declares x=0,y=0, so a
        correctly parented slide lands centred in the tablet for free.
      * It survived powering the XM8 off. ExileClient_gui_xm8_show fades a fixed
        list of nine ids - 4002,4003,4004,4005,4007,4001,4010,4030,4020 - and a
        group's fade propagates to its children. Ours were not under 4007 and
        not in that list, so nothing ever faded them.

    Not a guess: MarketByCyunide\Functions\onSellOpen.sqf, onSellOpenFirst.sqf
    and onSellGoBack.sqf all resolve `_display displayCtrl 4007` as the slide
    parent, and so does ExAd's fn_createExtraApps.sqf. Four shipped
    implementations in this mission and its addons; ours was the only one that
    omitted the parent.

    Resolved once here rather than per app.
*/
private _slideParent = _display displayCtrl 4007;
if (isNull _slideParent) then {
    diag_log "[XCSV_XM8] WARNING: slide container 4007 not found - app slides will be created on the display and will not accept clicks.";
};

// Four rows of five is the space above GO BACK, so 20 buttons is the ceiling
// while _maxApp scans up to App26. Today 20 slots are declared and 16 carry an
// icon and a name, so this never binds - but a 21st real app would silently
// draw a fifth row straight through the GO BACK button, and the symptom would
// be "the grid looks wrong" rather than anything naming a cause.
private _maxSlots = 20;

// Slide-relative, in the same unit grid the slide's own children use
// (see GoBackButton at x = (30-3)*0.025, y = (19-2)*0.04).
private _btnW   = 6 * (0.025);
private _btnH   = 4.25 * (0.04);
private _pitchX = 6.5 * (0.025);
private _pitchY = 4.25 * (0.04);
private _originX = 0.5 * (0.025);
private _originY = 0 * (0.04);

private _created = [];

for "_appIndex" from 1 to _maxApp do
{
	private "_buttonClassName";
	if (_appIndex < 10) then
	{
		_buttonClassName = format ["XM8_App0%1_Button", _appIndex];
	}
	else
	{
		_buttonClassName = format ["XM8_App%1_Button", _appIndex];
	};

	if (isClass (missionConfigFile >> _buttonClassName)) then
	{
		// Slots 10..13 are declared but carry neither an icon nor a name. Drawing
		// them leaves four dead holes in the middle of the grid, so skip them and
		// let the real apps close ranks.
		private _cfg = missionConfigFile >> _buttonClassName;
		private _tex = getText (_cfg >> "textureNoShortcut");
		private _txt = getText (_cfg >> "text");

		if (!(_tex isEqualTo "") || {!(_txt isEqualTo "")}) then
		{
			private _slot = count _created;

			if (_slot >= _maxSlots) exitWith {
				diag_log format [
					"[XCSV_XM8] %1 apps have icons but only %2 fit above GO BACK - %3 not drawn.",
					_slot + 1, _maxSlots, _buttonClassName
				];
			};

			private _col  = _slot % _cols;
			private _row  = floor (_slot / _cols);

			// The app's slide must EXIST before the app can open it.
			//
			// Stock slides are part of the RscExileXM8 dialog, so displayCtrl
			// finds them. Ours are only CLASSES in the mission config - a class
			// is not a control. Nothing in the mission ever created them, so
			// ExileClient_gui_xm8_slide resolved the id, called displayCtrl,
			// got null, and silently did nothing to it: the title changed and
			// the page stayed blank with no GO BACK. Every XCSV app has behaved
			// this way since it shipped; the broken grid simply hid it, because
			// none of them could be clicked.
			//
			// Created hidden (RscExileXM8Slide sets show = false) and left
			// alive: the slide teardown must NOT remove these, or clicking an
			// app would delete the very slide it is switching to.
			private _res = getText (_cfg >> "resource");
			if !(_res isEqualTo "") then {
				private _slideIdc = getNumber (missionConfigFile >> _res >> "idc");
				if (_slideIdc > 0) then {
					if (isNull (_display displayCtrl _slideIdc)) then {
						// Parented to 4007 - see the note where _slideParent is
						// resolved. Falls back to display level only if 4007
						// could not be found, which is logged above; a visible
						// but unclickable app beats no app at all.
						private _sc = if (isNull _slideParent) then {
							_display ctrlCreate [_res, _slideIdc]
						} else {
							_display ctrlCreate [_res, _slideIdc, _slideParent]
						};
						// ctrlCreate does NOT honour the class's show = false, so a
						// freshly created slide is visible immediately. Creating six
						// of them stacks every app's content on screen at once.
						//
						// Parking it off to the right as well as hiding it matches
						// what ExileClient_gui_xm8_slide expects to find: it animates
						// a slide in from (19 * 0.05) and pushes the outgoing one to
						// (-19 * 0.05).
						_sc ctrlShow false;
						_sc ctrlSetPosition [(19 * 0.05), 0];
						_sc ctrlCommit 0;

						// Register ONLY slides we just created, which is why this sits
						// inside the creation branch rather than beside it.
						//
						// It used to sit outside, on the belief - stated in a comment
						// here until 2026-08-10 - that stock resources live only in
						// configFile and so resolve to 0 above. They do not:
						// XM8SlideSettings (4070), XM8SlideHealthScanner (4120),
						// XM8SlideSlothMachine (4140) and XM8SlideCyunide (85150) are
						// all declared in THIS mission's config.cpp. The lookup found
						// them, the isNull guard correctly declined to re-create them,
						// and then we added four stock ids to our own teardown list and
						// hid and reparked them on every grid open and every grid leave.
						//
						// Nothing visibly broke, because ExileClient_gui_xm8_slide runs
						// onOpen, then onClose, then shows the target. What it cost was
						// the slide-in animation for those four stock apps, and it
						// violated the invariant xm8ExtraAppsClear.sqf states about
						// itself: "Only ever touches ids we created."
						private _slides = uiNamespace getVariable ["XCSV_XM8_SlideIDCs", []];
						if !(_slideIdc in _slides) then {
							_slides pushBack _slideIdc;
							uiNamespace setVariable ["XCSV_XM8_SlideIDCs", _slides];
						};
					};

					// The slide id the grid creates comes from the resource class's
					// own idc, but ExileClient_gui_xm8_slide resolves the same slide
					// through CfgXM8 >> <name> >> controlID. Two sources of truth, and
					// drift between them is SILENT - the title changes and the page
					// stays blank, which is exactly the failure that went unnoticed
					// until 2026-08-10. Say so rather than letting it happen twice.
					private _declared = getNumber (_cfg >> "controlID");
					if (_declared > 0 && {_declared != _slideIdc}) then {
						diag_log format [
							"[XCSV_XM8] WARNING: %1 has idc %2 but CfgXM8 declares controlID %3 - the app will open blank.",
							_res, _slideIdc, _declared
						];
					};
				};
			};

			private _idc = 4900 + _slot;
			private _button = _display ctrlCreate [_buttonClassName, _idc, _slide];
			_button ctrlSetPosition [
				_originX + (_pitchX * _col),
				_originY + (_pitchY * _row),
				_btnW,
				_btnH
			];
			_button ctrlCommit 0;

			// Store the CONTROL, not its id.
			//
			// Deleting by id means looking the control up again at teardown time,
			// which quietly assumes that a ctrlDelete has fully retired the id
			// before a later ctrlCreate reuses it in the same frame. If that ever
			// fails you get two controls sharing an idc, displayCtrl finds one,
			// and the other is an orphan that accumulates one per open/close
			// cycle. Deleting by reference cannot race anything - and it is what
			// stock's own extraApps_onClose does.
			_created pushBack _button;
		};
	};
};

// Renamed from XCSV_XM8_ExtraAppIDCs when this stopped holding ids and started
// holding controls. A NEW key rather than the old one reused: uiNamespace
// survives a mission reload, so a client that ran the previous build could
// otherwise leave a list of numbers where the teardown now expects controls.
uiNamespace setVariable ["XCSV_XM8_ExtraAppCtrls", _created];

diag_log format ["[XCSV_XM8] extra apps grid: %1 buttons in slide %2", count _created, _slideId];
