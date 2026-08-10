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
