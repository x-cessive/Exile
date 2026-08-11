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
	NOT hiding the grid slide here, deliberately.

	A previous pass added `ctrlShow false` on the grid at this point, on the
	theory that a parked-but-not-hidden controls group was still hit-testing and
	stealing GO BACK's clicks. That theory is REFUTED, on two independent
	grounds:

	  * Stock Exile parks every outgoing slide at x = +/-0.95 and never calls
	    ctrlShow false on any of them. If a parked group still took input, the
	    stock XM8 would be unusable.
	  * These slides are children of control 4007, which is itself a
	    CT_CONTROLS_GROUP at x=0.075 w=0.85. A child parked at relative -0.95 is
	    clipped out of its parent entirely - for rendering AND for input.

	The real cause was found elsewhere: the Player Market created unguarded
	full-tablet slide groups into 4007 that were never deleted and sat above
	every XCSV app slide. See MarketByCyunide\Functions\onSell*.sqf.

	Keeping a change whose justification has been disproved is how a codebase
	accumulates cargo, so it is removed rather than left in as insurance - and
	the grid gets its slide-out animation back.
*/
