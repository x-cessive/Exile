/*
	XCSV override of ExileClient_gui_xm8_slide_extraApps_onClose.

	Exile creates the extra-apps grid on open and destroys it on close. We had
	overridden only the open half, so stock's cleanup removed stock's controls
	and left ours alive on the display - visible on top of the XM8 home screen,
	and stacking one more grid every time the page was opened.

	This is the missing other half. It deletes exactly the controls our onOpen
	created, by the ids it recorded, and nothing else.
*/

disableSerialization;

if (isNil "XCSV_fnc_xm8ExtraAppsClear") then {
	XCSV_fnc_xm8ExtraAppsClear = compile preprocessFileLineNumbers "custom\xm8ExtraAppsClear.sqf";
};

call XCSV_fnc_xm8ExtraAppsClear;

/*
	Hide the grid slide on the way out, not merely park it.

	ExileClient_gui_xm8_slide NEVER hides an outgoing slide - it only moves it to
	x = -19*0.05 and commits. A CT_CONTROLS_GROUP that has been moved but not
	hidden is still a live control, and this estate has already been bitten twice
	by a controls group taking mouse input that something underneath it should
	have received: once when the grid buttons were parented to the display
	instead of this slide, and once when each app's content group covered its own
	GO BACK button.

	The reported symptom is GO BACK working on an app opened straight from the
	grid and dying after bouncing between apps - which is a hit-testing fault,
	not a rendering one, because the button is drawn correctly throughout.

	Hiding costs the grid its slide-out animation. The stock switcher calls
	ctrlShow true on the incoming slide before animating it, so the grid still
	slides back IN correctly; only the outgoing sweep is lost. That is a cheap
	price for removing an entire class of input ambiguity.

	Resolved through CfgXM8 rather than hardcoding the id, for the same reason
	extraApps_onOpen does: the id lives in config and drift between the two is
	silent.
*/
private _display = uiNamespace getVariable ["RscExileXM8", displayNull];
if (!isNull _display) then {
	private _src = if (isClass (configFile >> "CfgXM8" >> "extraApps")) then { configFile } else { missionConfigFile };
	private _gridId = getNumber (_src >> "CfgXM8" >> "extraApps" >> "controlID");
	if (_gridId > 0) then {
		private _grid = _display displayCtrl _gridId;
		if (!isNull _grid) then { _grid ctrlShow false };
	};
};
