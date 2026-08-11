/*
	custom\xm8ExtraAppsClear.sqf - CLIENT side

	Tears down what our extraApps page put on screen: deletes the app buttons it
	created, and hides every XCSV app slide.

	Lives in its own file because BOTH halves of the open/close pair need it and
	neither may assume the other ran first: onOpen must be able to clear a grid
	left by a previous open, and onClose must work even if the page never opened
	cleanly.

	WHY THE SLIDES ARE HIDDEN HERE AND NOT DELETED
	==============================================
	Deleting them would destroy the very slide an app is switching into.

	The hide is belt-and-braces rather than the load-bearing part, and the
	original note here got the reason wrong: it claimed x = -19 * 0.05 leaves a
	display-level control "not off-screen at all". It does move off. An
	RscExileXM8Slide is w = 34 * 0.025 = 0.85, so parked at x = -0.95 its right
	edge sits at -0.10, clear of the UI area - and stock relies on exactly that,
	since ExileClient_gui_xm8_slide never calls ctrlShow false on the outgoing
	slide at all.

	The real cause of the bleed was that the slides were being created VISIBLE
	(ctrlCreate does not honour show = false) and never parked in the first
	place. Both halves are fixed in extraApps_onOpen; this hide simply guarantees
	the resting state rather than trusting the animation to have run.

	Keeping the wrong reason written down would send the next reader chasing a
	problem that does not exist.

	WHY DOING THIS IN BOTH DIRECTIONS IS SAFE
	=========================================
	ExileClient_gui_xm8_slide runs the incoming slide's onOpen, then the outgoing
	slide's onClose, and only THEN shows the incoming slide. So:

	  * leaving the grid for an app - our onClose hides everything, then the
	    target is shown a moment later. Correct.
	  * returning to the grid - our onOpen hides everything including the app
	    just left. Correct.

	Hiding the target before it is shown is harmless; hiding it after would not
	be, which is why this must never run later than onClose.

	Only ever touches controls we created. Stock's controls are stock's business.

	That was an aspiration rather than a fact until 2026-08-10: the grid was
	registering four STOCK slides (Settings, Health Scanner, Sloth Machine,
	Player Market) into the list below, because they are declared in this
	mission's config.cpp and so the id lookup found them. Fixed at the source, in
	extraApps_onOpen.
*/

private _display = uiNameSpace getVariable ["RscExileXM8", displayNull];
if (isNull _display) exitWith {};

// The app buttons. These are CONTROLS, not ids - deleting by reference cannot
// race a same-frame ctrlCreate that reuses the id, which deleting by id could.
/*
	Deleted on a 0.25s delay, in a spawned thread, because that is what STOCK
	does and the reason is not cosmetic.

	Stock Exile's own extraApps_onClose is:

		[] spawn { uiSleep 0.25; ... { ctrlDelete _x } forEach ... };

	This teardown is reached from extraApps_onClose, which the slide switcher
	calls from INSIDE the ButtonClick handler of one of these very tiles. Doing
	it synchronously destroys the control the engine is currently dispatching a
	click through. The delay gets the deletion out of that frame - and 0.25s is
	also exactly the slide animation length.

	The list is captured and cleared SYNCHRONOUSLY, before the spawn, so it
	cannot race the re-create in extraApps_onOpen a few lines later. Stock reads
	its list inside the spawn, which is the weaker version of this.
*/
private _ctrls = uiNamespace getVariable ["XCSV_XM8_ExtraAppCtrls", []];
uiNamespace setVariable ["XCSV_XM8_ExtraAppCtrls", []];
_ctrls spawn {
	uiSleep 0.25;
	{ if (!isNull _x) then { ctrlDelete _x } } forEach _this;
};

// One-time sweep of the previous build's list, which held IDs rather than
// controls. uiNamespace outlives a mission reload, so without this a client
// that ran the old build keeps 16 orphaned buttons until it restarts Arma.
private _legacy = uiNamespace getVariable ["XCSV_XM8_ExtraAppIDCs", []];
if !(_legacy isEqualTo []) then {
	{
		if (_x isEqualType 0) then {
			private _old = _display displayCtrl _x;
			if (!isNull _old) then { ctrlDelete _old };
		};
	} forEach _legacy;
	uiNamespace setVariable ["XCSV_XM8_ExtraAppIDCs", []];
};

// The app slides. Kept alive, parked out of the way.
private _slides = uiNamespace getVariable ["XCSV_XM8_SlideIDCs", []];
{
	private _slide = _display displayCtrl _x;
	if (!isNull _slide) then {
		_slide ctrlShow false;
		_slide ctrlSetPosition [(19 * 0.05), 0];
		_slide ctrlCommit 0;
	};
} forEach _slides;
