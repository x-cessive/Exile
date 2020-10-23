/*
	Author: IT07

	Description:
	will put mission notification on either all screens or just on given

	Params:
	_this select 0: SCALAR - mission color
	_this select 1: STRING - notification title
	_this select 2: STRING - notification message
	_this select 3: ARRAY (optional) - specific clients to (ONLY) send notification to

	Returns:
	nothing
*/

params [ "_mc", "_title", "_line", "_to" ];
if ( isNil "_to" ) then { _to = allPlayers };
{
	VEMFrMsgToClient = [ [ _mc, _title, _line ], "" ];
	( owner _x ) publicVariableClient "VEMFrMsgToClient";
} forEach _to;
