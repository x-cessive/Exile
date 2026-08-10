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
				// Stock resources live in configFile and are already instantiated,
				// so they resolve to 0 here and are correctly skipped.
				if (_slideIdc > 0) then {
					if (isNull (_display displayCtrl _slideIdc)) then {
						private _sc = _display ctrlCreate [_res, _slideIdc];
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
					};
					// Remembered so the teardown can hide them. Not deleted - the app
					// being switched to must survive this function.
					private _slides = uiNamespace getVariable ["XCSV_XM8_SlideIDCs", []];
					if !(_slideIdc in _slides) then {
						_slides pushBack _slideIdc;
						uiNamespace setVariable ["XCSV_XM8_SlideIDCs", _slides];
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

			_created pushBack _idc;
		};
	};
};

uiNamespace setVariable ["XCSV_XM8_ExtraAppIDCs", _created];

diag_log format ["[XCSV_XM8] extra apps grid: %1 buttons in slide %2", count _created, _slideId];
