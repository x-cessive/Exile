private ["_strikeCenter"];

while {true} do
{
	diag_log "STORM CYCLE BEGUN";

	if ((requiredRain >= 0.7) || (daytime >= 19 || daytime < 5) || (debugStorms)) then
	{	
		if (useDynamicStorms) then
		{	
			_spawnCenter = mapCenter; //Center of your map -- this is Stratis 
			_min = 1; // minimum distance from the center position (Number) in meters
			_max = 5000; // maximum distance from the center position (Number) in meters
			_mindist = 2; // minimum distance from the nearest object (Number) in meters, ie. create waypoint this distance away from anything within x meters..
			_water = 0; // water mode 0: cannot be in water , 1: can either be in water or not , 2: must be in water
			_shoremode = 0; // 0: does not have to be at a shore , 1: must be at a shore

			_strikeCenter = [_spawnCenter,_min,_max,_mindist,_water,1,_shoremode] call BIS_fnc_findSafePos;
		}
		else
		{
			_strikeCenter = selectRandom fixedStormPositions;
		};	

		if (stormMarker) then
		{	
			_mk = createMarker ["bolt",_strikeCenter];
			"bolt" setMarkerType "mil_warning";
			"bolt" setMarkerPos _strikeCenter;
		};	
		
		if (warnPlayers) then
		{	
			_titlePatrol = stormMessageAlpha;
			_messagePatrol = stormMessageBravo;

			if (showGridLocation)then
			{
				_location = mapGridPosition _strikeCenter;
				for "_i" from 1 to messageNumber do
				{
				    ["systemChatRequest", [format ["%1: %2: %3",_titlePatrol,_messagePatrol,_location]]] call ExileServer_system_network_send_broadcast;
				    uiSleep messageDelay;
				};
			}
			else
			{	
				for "_i" from 1 to messageNumber do
				{
				    ["systemChatRequest", [format ["%1: %2",_titlePatrol,_messagePatrol]]] call ExileServer_system_network_send_broadcast;
				    uiSleep messageDelay;
				};
			};
		};

		uiSleep stormDelay;
		
		for "_i" from 1 to boltAmount do
		{

			_pos = [(_strikeCenter select 0) + floor (random strikeRadius) - floor (random strikeRadius), (_strikeCenter select 1) +floor (random strikeRadius)- floor (random strikeRadius), 0];

			diag_log format ["Lightning strike created:%1",_pos];

			_dir =random 360;

			_bolt = createvehicle ["LightningBolt",_pos,[],0,"can collide"];								// Create lightning sound and destruction.
			_bolt setposatl _pos;
			_bolt setdamage 1;																						// SetDamage required for proper lightning effect. Also does damage to strike location.

			_light = "#lightpoint" createvehicle _pos;												// Create light flash effect.
			_light setposatl [_pos select 0,_pos select 1,(_pos select 2) + 10];
			_light setLightDayLight true;
			_light setLightBrightness 300;
			_light setLightAmbient [0.05, 0.05, 0.1];
			_light setlightcolor [1, 1, 2];
			
			_light setLightBrightness 0;
			

			_class = ["lightning1_F","lightning2_F"] call bis_Fnc_selectrandom;										// Choose and create visible lightning bolt object.
			_lightning = _class createvehicle [100,100,100];
			_lightning setdir _dir;
			_lightning setpos _pos;

			_duration = random 2;																					// Keep bolt on screen for random duration. Also adds a second flash of light for a bit more realism.
			for "_i" from 0 to _duration do 
			{
				_time = time + 0.1;
				_light setLightBrightness (100 + random 100);
				waituntil {time > _time};
			};
			deletevehicle _lightning;																				// Delete lightning bolt and light object.
			deletevehicle _light;
			uiSleep 0.5 + floor (random 2);
		};
		if (stormMarker) then
		{
			deleteMarker "bolt";
		};	
	};		

	uiSleep interval;

	diag_log "STORM CYCLE COMPLETE";
};	