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
	Deleting them would destroy the very slide an app is switching into. Hiding
	is also what actually fixes the bleed: our slides are created on the display,
	so when ExileClient_gui_xm8_slide "slides one away" it merely moves it to
	x = -19 * 0.05 - which for a display-level control is not off-screen at all,
	it is just somewhere else on the monitor. That is why app content appeared
	stacked over other apps and floating beside the tablet.

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

	Only ever touches ids we created. Stock's controls are stock's business.
*/

private _display = uiNameSpace getVariable ["RscExileXM8", displayNull];
if (isNull _display) exitWith {};

// The app buttons.
private _idcs = uiNamespace getVariable ["XCSV_XM8_ExtraAppIDCs", []];
{
	private _ctrl = _display displayCtrl _x;
	if (!isNull _ctrl) then { ctrlDelete _ctrl };
} forEach _idcs;
uiNamespace setVariable ["XCSV_XM8_ExtraAppIDCs", []];

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
