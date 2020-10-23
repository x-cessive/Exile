/*
	By Ghostrider [GRG]
	--------------------------
	License
	--------------------------
	All the code and information provided here is provided under an Attribution Non-Commercial ShareAlike 4.0 Commons License.

	http://creativecommons.org/licenses/by-nc-sa/4.0/
*/
for "_i" from 1 to (count blck_illuminatedCrates) do 
{	
	if (_i > (count blck_illuminatedCrates)) exitWith {};
	private _c = blck_illuminatedCrates deleteAt 0;
    _c params["_crate","_smoke","_light","_smokeShell","_lightSource","_refreshTime","_endAt"];
	//diag_log format["_unpdateCrateSignals: [_crate %1 | _smoke %2 | _light %3 |_smokeShell %4 | _lightSource %5 | curr time %8 | _refreshTime %6 |_endAt %7",_crate,_smoke,_light,_smokeShell,_lightSource,_refreshTime,_endAt,diag_tickTime];
	if (diag_tickTime < _endAt) then 
	{
		if (diag_tickTime > _refreshTime) then 
		{
			if !(isNull _smoke) then 
			{
				detach _smoke;
				deleteVehicle _smoke;
			};
			if !(isNull _light) then
			{
				detach _light;
				deleteVehicle _light;
			};
			_smoke = _smokeShell createVehicle getPosATL _crate;
			_smoke setPosATL (getPosATL _crate);
			_smoke attachTo [_crate,[0,0,(0.5)]]; // put the smoke a fixed distance above the top of any object to make it as visible as possible
			if(sunOrMoon < 0.2) then
			{
				_light = _lightSource createVehicle getPosATL _crate;
				_light setPosATL (getPosATL _crate);
				_light attachTo [_crate,[0,0,(0.55)]];
			};    
			blck_illuminatedCrates pushBack [_crate,_smoke,_light,_smokeShell,_lightSource,diag_tickTime + 120,_endAt];	
		} else {
			//diag_log format["_updateCrateSignals: refresh light at %1",_refreshTime];
			//blck_illuminatedCrates pushBack [_crate,_smoke,_light,_smokeShell,_lightSource,_refreshTime,_endAt];				
			blck_illuminatedCrates pushBack _c;
		};	
		
	}  else {
		//diag_log format["_updateCrateSignals: crate has been illuminated for enough time, no need to continue"];
	};
};