
/*
	algorhytm one: pure chance base on inverse of distance. More efficient.
	algorhythm two: based on canSee. More detailed.
*/
/*
	By Ghostrider [GRG]
	Copyright 2016
	--------------------------
	License
	--------------------------
	All the code and information provided here is provided under an Attribution Non-Commercial ShareAlike 4.0 Commons License.

	http://creativecommons.org/licenses/by-nc-sa/4.0/
*/
params["_vehicle","_searchRadius","_detectionOdds"];
private["_player","_detectionOdds","_nearbyPlayers","_knowsAbout","_cansee","_knowledgeGained"];
_nearbyPlayers = [position _vehicle, _vehicle getVariable["blck_vehicleSearchRange",500]] call blck_fnc_nearestPlayers;

switch blck_revealMode do {
	case "detailed": {
		private["_crew"];
		_crew = crew _vehicle;
		if !(_crew isequalto []) then {
			{
				if (random(1) < _detectionOdds) then {
					_player = _x;
					{
						_cansee = [objNull, "VIEW"] checkVisibility [eyePos _x, position _player];
						if (_cansee > 0) then {
							_knowledgeGained = _cansee;
						}
						else {
							_knowledgeGained = _x knowsAbout _player;
							if (_knowledgeGained == 0) then {_knowledgeGained = 0.1};
						};
						_x reveal[_player,_knowledgeGained];
					}forEach _crew;
				};
			}forEach _nearbyPlayers;
		};
	};
	case "basic": {
		{
			_player = _x;
			if (random(1) < _detectionOdds) then {
				_knowsAbout = (_vehicle) knowsAbout _player;
				if (_knowsAbout > 0) then {
					_knowledgeGained = _knowsAbout;
				}
				else {
					_knowledgeGained = (_searchRadius  - (_x distance _vehicle))/_searchRadius;
				};
				_x reveal[_player, _knowledgeGained];
			};
		}forEach _nearbyPlayers;
	};
};