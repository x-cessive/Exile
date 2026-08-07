/*
	XCSV override of ExileClient_gui_xm8_slide_extraApps_onOpen.

	WHY this override exists
	========================
	The exiled client renders the XM8 "extra apps" page (the grid reachable
	from the phone home screen) with a hardcoded loop:

	        for "_i" from 1 to 14 do { ... create XM8_AppNN_Button ... }

	Only app slots 01..14 are ever instantiated. Our custom apps live in slots
	App15..App20 (Scoreboard, Field Notes, Standing, Prices, Dead Man's Switch,
	Player Inspector) so they never appear. This override rebuilds the same grid
	but iterates every configured XM8_AppNN_Button class in missionConfigFile
	(App01..App26), so the full set renders.

	Each button is ctrlCreate'd from its config class; because that class already
	carries its own textureNoShortcut / text / onButtonClick / resource entries,
	the click behaviour, label, icon and slide wiring come straight from the
	mission config and need no duplication here. Grid geometry mirrors the stock
	layout exactly (5 columns, cells 6.5*0.025 wide x 2.5*0.04 tall, origin
	(1*0.025, 2*0.04) in the decoded stock SetPos formula) so the existing apps
	01..14 keep their exact current positions.
*/

private _display = uiNameSpace getVariable ["RscExileXM8", displayNull];

if (isNull _display) exitWith {};

disableSerialization;

private _maxApp  = 26;   // highest configured app slot to scan (scanned, not all shown)
private _cols    = 5;

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
		private _col = (_appIndex - 1) % _cols;
		private _row = floor ((_appIndex - 1) / _cols);

		private _button = _display ctrlCreate [_buttonClassName, 500 + _appIndex];
		_button ctrlSetPosition [
			(1 + (6.5 * _col)) * (0.025),
			(2 + (2.5 * _row)) * (0.04),
			6.5 * (0.025),
			2.5 * (0.04)
		];
		_button ctrlCommit 0;
	};
};