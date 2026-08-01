_handle  = [] spawn {
	while {true} do {
		//waitUntil{!isNil "ExileClientLoadedIn"};
		//UISleep 0.1;
		//waitUntil{ExileClientLoadedIn};
		//UISleep 0.1;
		waitUntil{alive player}; //All above, code to be sure to wait for the exile client to be fully loaded in.;
		//need to wait until player gets in helicopter or plane and into the pilot seat, doesn't show if copilot seat and take control
		waitUntil{player != vehicle player && player == driver vehicle player && ((vehicle player isKindOf "Plane") || (vehicle player isKindOf "Helicopter"))  }; 
		
		_veh = vehicle player;
		//find the index of flares first, no need to loop through them again everytime since their position won't change unlike the weapons
		//_flares = ("CMFlareLauncher" in _PilotWeapons) || ("CMFlareLauncher_Singles" in _PilotWeapons) || ("CMFlareLauncher_Triples" in _PilotWeapons);
		//gives the weapon class names, use this to check if flares exists
		_PilotWeapons = vehicle player weaponsTurret [-1]; 
		_hasFlareLauncher = _PilotWeapons findIf {_x  isKindOf  ["CMFlareLauncher", configFile >> "CfgWeapons"]} > -1;
		//flares aren't going to change and cannot be changed
		_wsPilot = weaponState [_veh, [-1]];
		_magazines = magazinesAllTurrets _veh;
		_flareMagIndex = _magazines findIf {(_x select 0) isKindOf  ["60Rnd_CMFlareMagazine", configFile >> "CfgMagazines"]};
		if (_flareMagIndex < 0) then
		{
			_flareMagIndex = _magazines findIf {(_x select 0) isKindOf  ["60Rnd_CMFlareMagazine", configFile >> "CfgMagazines"]};
		};
		
		
		while {true} do
		{
			//_veh = vehicle player;
			if (!alive player || player == _veh || player != driver _veh || !(_veh isKindOf "Plane" || _veh isKindOf "Helicopter")) exitWith {};
									
				
			//get the flares first, since it shouldn't matter if pilot is in manual fire
			_magazines = magazinesAllTurrets _veh;
			_TotalAmmoCount = 0;
			_TotalFlareCount = 0;
			
			if (_hasFlareLauncher) then
			{
				//use the previously index of the flaremag
				_TotalFlareCount = _TotalFlareCount + ((_magazines select _flareMagIndex) select 2);
			};
									
			_turretNum = if (isManualFire _veh) then [ {0}, {-1} ];					
			//use this to get the classname of the current select weapon and firemode
			_wsPilot = weaponState [_veh, [_turretNum]];
			
			
			_PilotWeaponClass = _wsPilot select 0;
			_PilotFireMode = _wsPilot select 2;
			_PilotMagazineClass = _wsPilot select 3;
			
			_displayName = getText (configFile >>  "CfgWeapons" >> _PilotWeaponClass >> "displayName");
			if (_PilotFireMode isEqualTo _PilotWeaponClass) then 
			{ 
				_PilotFireMode = getText (configFile >>  "CfgMagazines" >> _PilotMagazineClass >> "displayNameShort");
			};
						
			if (_PilotWeaponClass isKindOf ["Laserdesignator_mounted", configFile >> "CfgWeapons"]) then 
			{
				_TotalAmmoCount = if (isLaserOn _veh) then [ {"ON"}, {"OFF"} ];	
			}
			else
			{
				//get the ammo for all turrets, compare the names and get the ammo count			
				{
					_magazineClass = _x select 0;
					_ammoCount = _x select 2;
					if (_magazineClass isEqualTo _PilotMagazineClass) then { _TotalAmmoCount = _TotalAmmoCount + _ammoCount; };
				} forEach _magazines;	
			
			};			
						
			("PilotHUDLayer" call BIS_fnc_rscLayer) cutRsc ["PilotHUD","PLAIN"]; //show
			waitUntil {!isNull (uiNameSpace getVariable "PilotHUD") };
			_display = uiNameSpace getVariable "PilotHUD";
			_textctrl = _display displayCtrl 2395;
			_string = "";
			
			if (not (_PilotWeaponClass isEqualTo "")) then
			{
				_string = _string + format["<t align='right' size='2'>%1</t><br/><t align='left'>%2</t><t align='right' size='3.5'>%3</t><br/>", _displayName, _PilotFireMode, _TotalAmmoCount];
			}
			else
			{
				_string = _string + "<t size='2'>&#160;</t><br/><t size='3.5'>&#160;</t><br/>";
			};
			
			
			if (_hasFlareLauncher) then
			{
				_string = _string + format["<t align='left' size='2'>Flares</t><t align='right' size='2'>%1</t><br/>", _TotalFlareCount];
			}
			else
			{
				_string = _string + "<t size='2'>&#160;</t><br/>";
			};
			
			if (_veh isKindOf "Plane") then
			{
				_trottle = airplaneThrottle (_veh);
				_trottle = (round(_trottle*100));
				_string = _string + format["<t align='right'>%1%2</t><br/>", _trottle,"%"];
			};
			
			_Stxt = parseText(_string);
			_textctrl ctrlSetStructuredText (_Stxt);
			sleep 0.1;
			
			("PilotHUDLayer" call BIS_fnc_rscLayer) cutText ["","PLAIN"]; //remove
			
		};	
	};
};