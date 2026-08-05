/*
© 2015 Zenix Gaming Ops
Developed by Rod-Serling
Co-Developed by Vishpala

All rights reserved.

Function:
	AVS_fnc_updateInteractionMenu - Updates the interaction menu to allow the player to rearm a vehicle.

Usage (from the server):
	[] spawn AVS_fnc_updateInteractionMenu

Return Value:
	None
*/
if (hasInterface) then
{
	AVS_rearmAction = 0;
	AVS_actionAdded = false;
	AVS_previousRearmCost = 0;
	while {true} do
	{
		try
		{
			_vehicle = vehicle player;

			if (!alive player || {_vehicle == player}) then
			{
				throw 1;
			};

			if (!local _vehicle) then
			{
				throw 1;
			};

			_pos = getPos _vehicle;

			if (_pos select 2 > 0.1) then
			{
				throw 1;
			};

			_vel = velocity _vehicle;

			if (_vel select 0 > 0.1 || _vel select 1 > 0.1 || _vel select 2 > 0.1) then
			{
				throw 1;
			};

			_servicePoints = (nearestObjects [getPosATL _vehicle, ["Land_fs_feed_F"], 15]);

			if (count _servicePoints == 0) then
			{
				throw 1;
			};

			_rearmCost = _vehicle call AVS_fnc_getRearmCost;

			if (_rearmCost == 0) then
			{
				throw 1;
			};

			if (AVS_actionAdded) then
			{
				if (AVS_previousRearmCost != _rearmCost) then
				{
					player removeAction AVS_rearmAction;
				}
				else
				{
					throw 2;
				};
			};

			_rearmTitle = format ["Rearm: %1 poptabs", _rearmCost];
			AVS_rearmAction = player addAction [_rearmTitle, AVS_fnc_requestRearm, [_vehicle]];
			AVS_previousRearmCost = _rearmCost;
			AVS_actionAdded = true;
		}
		catch
		{
			if (_exception == 1) then
			{
				if (AVS_actionAdded) then
				{
					player removeAction AVS_rearmAction;
					AVS_actionAdded = false;
				};
			};
		};
		sleep 2;
	};
};