bl_prep_inprogress = false;
bl_detection = 
{
    playSound "bl_detect";
    uiSleep 0.2;
    playSound "bl_detect";
    uiSleep 0.5;
    cutRsc ["RscAPSI_h1","PLAIN"];
    playSound "bl_detect";
    uiSleep 0.1;
    playSound "bl_detect";    
    uiSleep 1;
    cutRsc ["RscAPSI_h2","PLAIN"];
    uiSleep 1;
    playSound "bl_detect";        
    cutRsc ["RscAPSI_h3","PLAIN"];
    playSound "apsi_on";
    "filmGrain" ppEffectEnable true; 
    "filmGrain" ppEffectAdjust [0.15, 1, 1, 0.1, 1, false];
    "filmGrain" ppEffectCommit 0;
    uiSleep 1;
    playSound "bl_detect";
    uiSleep 0.2;
    playSound "bl_detect";
    cutRsc ["RscAPSI_h4","PLAIN"];
    uiSleep 23.8;
    if (isNil("ns_blow_status")) then { ns_blow_status = false; };
    waitUntil{ns_blow_status};
    playSound "bl_detect";
    uiSleep 0.2;
    playSound "bl_detect";
    cutRsc ["RscAPSI_h5","PLAIN"];
};
bl_flash =
{
    titleText["","WHITE OUT",1];  
    titleText["","WHITE IN",1]; 
    uiSleep 0.25;
};
bl_local_anims = 
{
    if (!([player] call fnc_hasAPSI) && (Alive player)) then
    {
        if ((vehicle player) == player) then
        {
            player switchMove "AcinPercMrunSnonWnonDf_agony";
        };
    };
};
bl_local_def_anim = 
{
    if (!([player] call fnc_hasAPSI)&& (Alive player)) then 
    {
        if ((vehicle player) == player) then 
        {
            player switchMove "";
        };
    };
};

bl_preparations = {
	bl_prep_inprogress = true;
    playSound "ns_fx_drone2";
    "chromAberration" ppEffectAdjust [0.25,0,true];
    "chromAberration" ppEffectEnable true;
    "chromAberration" ppEffectCommit 0.5;
    uiSleep 0.2; 
    "chromAberration" ppEffectAdjust [-0.15,0,true];
    "chromAberration" ppEffectCommit 0.35;
    uiSleep 0.1;
    "chromAberration" ppEffectAdjust [-0.05,0,true];
    "chromAberration" ppEffectCommit 0.20;
    uiSleep 0.1;
    "chromAberration" ppEffectAdjust [0,0,true];
    "chromAberration" ppEffectCommit 0.20;
    uiSleep 0.25; 
    "chromAberration" ppEffectEnable false;    
    uiSleep 4;    
    playSound "ns_fx_drone1";
    "chromAberration" ppEffectAdjust [0.25,0,true];
    "chromAberration" ppEffectEnable true;
    "chromAberration" ppEffectCommit 0.5;
    uiSleep 0.2; 
    "chromAberration" ppEffectAdjust [-0.15,0,true];
    "chromAberration" ppEffectCommit 0.35;
    uiSleep 0.1;
    "chromAberration" ppEffectAdjust [-0.05,0,true];
    "chromAberration" ppEffectCommit 0.20;
    uiSleep 0.1;
    "chromAberration" ppEffectAdjust [0,0,true];
    "chromAberration" ppEffectCommit 0.20;
    uiSleep 0.25; 
    "chromAberration" ppEffectEnable false;
    uiSleep 54;    
    playSound "ns_fx_misc4";
    uiSleep 13;    
    playSound "ns_fx_drone2";
    "chromAberration" ppEffectAdjust [0.25,0,true];
    "chromAberration" ppEffectEnable true;
    "chromAberration" ppEffectCommit 0.5;
    uiSleep 0.2; 
    "chromAberration" ppEffectAdjust [-0.15,0,true];
    "chromAberration" ppEffectCommit 0.35;
    uiSleep 0.1;
    "chromAberration" ppEffectAdjust [-0.05,0,true];
    "chromAberration" ppEffectCommit 0.20;
    uiSleep 0.1;
    "chromAberration" ppEffectAdjust [0,0,true];
    "chromAberration" ppEffectCommit 0.20;
    uiSleep 0.25; 
    "chromAberration" ppEffectEnable false;    
    uiSleep 10;    
    playSound "ns_fx_drone1";
    "chromAberration" ppEffectAdjust [0.25,0,true];
    "chromAberration" ppEffectEnable true;
    "chromAberration" ppEffectCommit 0.5;
    uiSleep 0.2; 
    "chromAberration" ppEffectAdjust [-0.15,0,true];
    "chromAberration" ppEffectCommit 0.35;
    uiSleep 0.1;
    "chromAberration" ppEffectAdjust [-0.05,0,true];
    "chromAberration" ppEffectCommit 0.20;
    uiSleep 0.1;
    "chromAberration" ppEffectAdjust [0,0,true];
    "chromAberration" ppEffectCommit 0.20;
    uiSleep 0.25; 
    "chromAberration" ppEffectEnable false;
    uiSleep 77;    
    playSound "ns_fx_drone2";
    "chromAberration" ppEffectAdjust [0.25,0,true];
    "chromAberration" ppEffectEnable true;
    "chromAberration" ppEffectCommit 0.5;
    uiSleep 0.2; 
    "chromAberration" ppEffectAdjust [-0.15,0,true];
    "chromAberration" ppEffectCommit 0.35;
    uiSleep 0.1;
    "chromAberration" ppEffectAdjust [-0.05,0,true];
    "chromAberration" ppEffectCommit 0.20;
    uiSleep 0.1;
    "chromAberration" ppEffectAdjust [0,0,true];
    "chromAberration" ppEffectCommit 0.20;
    uiSleep 0.25; 
    "chromAberration" ppEffectEnable false;    
    uiSleep 10;    
    playSound "ns_fx_drone1";
    "chromAberration" ppEffectAdjust [0.25,0,true];
    "chromAberration" ppEffectEnable true;
    "chromAberration" ppEffectCommit 0.5;
    uiSleep 0.2; 
    "chromAberration" ppEffectAdjust [-0.15,0,true];
    "chromAberration" ppEffectCommit 0.35;
    uiSleep 0.1;
    "chromAberration" ppEffectAdjust [-0.05,0,true];
    "chromAberration" ppEffectCommit 0.20;
    uiSleep 0.1;
    "chromAberration" ppEffectAdjust [0,0,true];
    "chromAberration" ppEffectCommit 0.20;
    uiSleep 0.25; 
    "chromAberration" ppEffectEnable false;
    uiSleep 50;    
    playSound "ns_fx_drone2";
    "chromAberration" ppEffectAdjust [0.25,0,true];
    "chromAberration" ppEffectEnable true;
    "chromAberration" ppEffectCommit 0.5;
    uiSleep 0.2; 
    "chromAberration" ppEffectAdjust [-0.15,0,true];
    "chromAberration" ppEffectCommit 0.35;
    uiSleep 0.1;
    "chromAberration" ppEffectAdjust [-0.05,0,true];
    "chromAberration" ppEffectCommit 0.20;
    uiSleep 0.1;
    "chromAberration" ppEffectAdjust [0,0,true];
    "chromAberration" ppEffectCommit 0.20;
    uiSleep 0.25; 
    "chromAberration" ppEffectEnable false;    
    uiSleep 7;    
    playSound "ns_fx_drone1";
    "chromAberration" ppEffectAdjust [0.25,0,true];
    "chromAberration" ppEffectEnable true;
    "chromAberration" ppEffectCommit 0.5;
    uiSleep 0.2; 
    "chromAberration" ppEffectAdjust [-0.15,0,true];
    "chromAberration" ppEffectCommit 0.35;
    uiSleep 0.1;
    "chromAberration" ppEffectAdjust [-0.05,0,true];
    "chromAberration" ppEffectCommit 0.20;
    uiSleep 0.1;
    "chromAberration" ppEffectAdjust [0,0,true];
    "chromAberration" ppEffectCommit 0.20;
    uiSleep 0.25; 
    "chromAberration" ppEffectEnable false;
    uiSleep 33;    
    playSound "ns_fx_drone2";
    "chromAberration" ppEffectAdjust [0.25,0,true];
    "chromAberration" ppEffectEnable true;
    "chromAberration" ppEffectCommit 0.5;
    uiSleep 0.2; 
    "chromAberration" ppEffectAdjust [-0.15,0,true];
    "chromAberration" ppEffectCommit 0.35;
    uiSleep 0.1;
    "chromAberration" ppEffectAdjust [-0.05,0,true];
    "chromAberration" ppEffectCommit 0.20;
    uiSleep 0.1;
    "chromAberration" ppEffectAdjust [0,0,true];
    "chromAberration" ppEffectCommit 0.20;
    uiSleep 0.25; 
    "chromAberration" ppEffectEnable false;    
    uiSleep 5;    
    playSound "ns_fx_drone1";
    "chromAberration" ppEffectAdjust [0.25,0,true];
    "chromAberration" ppEffectEnable true;
    "chromAberration" ppEffectCommit 0.5;
    uiSleep 0.2; 
    "chromAberration" ppEffectAdjust [-0.15,0,true];
    "chromAberration" ppEffectCommit 0.35;
    uiSleep 0.1;
    "chromAberration" ppEffectAdjust [-0.05,0,true];
    "chromAberration" ppEffectCommit 0.20;
    uiSleep 0.1;
    "chromAberration" ppEffectAdjust [0,0,true];
    "chromAberration" ppEffectCommit 0.20;
    uiSleep 0.25; 
    "chromAberration" ppEffectEnable false;
    uiSleep 25;    
    playSound "ns_fx_misc4";
    playSound "ns_fx_drone2";
    "chromAberration" ppEffectAdjust [0.25,0,true];
    "chromAberration" ppEffectEnable true;
    "chromAberration" ppEffectCommit 0.5;
    uiSleep 0.2; 
    "chromAberration" ppEffectAdjust [-0.15,0,true];
    "chromAberration" ppEffectCommit 0.35;
    uiSleep 0.1;
    "chromAberration" ppEffectAdjust [-0.05,0,true];
    "chromAberration" ppEffectCommit 0.20;
    uiSleep 0.1;
    "chromAberration" ppEffectAdjust [0,0,true];
    "chromAberration" ppEffectCommit 0.20;
    uiSleep 0.25; 
    "chromAberration" ppEffectEnable false;    
    uiSleep 3;    
    playSound "ns_fx_drone1";
    "chromAberration" ppEffectAdjust [0.25,0,true];
    "chromAberration" ppEffectEnable true;
    "chromAberration" ppEffectCommit 0.5;
    uiSleep 0.2; 
    "chromAberration" ppEffectAdjust [-0.15,0,true];
    "chromAberration" ppEffectCommit 0.35;
    uiSleep 0.1;
    "chromAberration" ppEffectAdjust [-0.05,0,true];
    "chromAberration" ppEffectCommit 0.20;
    uiSleep 0.1;
    "chromAberration" ppEffectAdjust [0,0,true];
    "chromAberration" ppEffectCommit 0.20;
    uiSleep 0.25; 
    "chromAberration" ppEffectEnable false;
	bl_prep_inprogress = false;
};
while {true} do {
    if (isNil("ns_blowout_exile")) then { ns_blowout_exile = false; };
    if (isNil("ns_blow_prep")) then { ns_blow_prep = false; };
    waitUntil{ns_blow_prep};
    diag_log format["[NAC BLOWOUT CLIENT] :: ns_blow_prep = %1 Blowout is preparing, take a cover!", ns_blow_prep];
    if ([player] call fnc_hasAPSI) then {
        _bul = [] spawn bl_detection;
    };
    _bul = [] spawn bl_preparations;
	if(bl_prep_inprogress)then{
	 waitUntil{!bl_prep_inprogress};
	};
    if (isNil("ns_blow_status")) then { ns_blow_status = false; };
    waitUntil{ns_blow_status};
    diag_log format["[NAC BLOWOUT CLIENT] :: ns_blow_status = %1 Blowout confirmation received.", ns_blow_status];
    if (ns_blowout_exile) then {
        ExileClientPlayerIsInCombat = true;
		ExileClientPlayerLastCombatAt = diag_tickTime;
		true call ExileClient_gui_hud_toggleCombatIcon;
    };
   if (isNil("ns_blow_action")) then { ns_blow_action = false; };
   waitUntil{ns_blow_action};   
   diag_log format["[NAC BLOWOUT CLIENT] :: ns_blow_action = %1 Blowout action received.", ns_blow_status];  
   playSound "bl_begin";
   "dynamicBlur" ppEffectAdjust [8];
   "dynamicBlur" ppEffectEnable true;
   "dynamicBlur" ppEffectCommit 0;
   "dynamicBlur" ppEffectAdjust [0.1];
   "dynamicBlur" ppEffectCommit 0.75;
   "chromAberration" ppEffectAdjust [0.25,0,true];
   "chromAberration" ppEffectEnable true;
   "chromAberration" ppEffectCommit 0.5;
   uiSleep 0.5; 
   "chromAberration" ppEffectAdjust [-0.15,0,true];
   "chromAberration" ppEffectCommit 0.35;
   uiSleep 0.5;
   "chromAberration" ppEffectAdjust [-0.05,0,true];
   "chromAberration" ppEffectCommit 0.20;
   uiSleep 0.20;
   "chromAberration" ppEffectAdjust [0,0,true];
   "chromAberration" ppEffectCommit 0.20;
   uiSleep 1; 
   "chromAberration" ppEffectEnable false;
   "dynamicBlur" ppEffectAdjust [3];
   "dynamicBlur" ppEffectCommit 2.75;
   uiSleep 5;   
    _bul = [] call bl_flash;
    _s = round (random 3); 
    switch (_s) do 
    {
        case 0: {playSound "bl_hit1";};
        case 1: {playSound "bl_hit2";};
        case 2: {playSound "bl_hit3";};
        case 3: {playSound "bl_hit1";};
    };
    "dynamicBlur" ppEffectAdjust [3];
    "dynamicBlur" ppEffectCommit 5;
    uiSleep 1;
    _bul = [] call bl_flash;
    _s = round (random 3); 
    switch (_s) do 
    {
        case 0: {playSound "bl_hit1";};
        case 1: {playSound "bl_hit2";};
        case 2: {playSound "bl_hit3";};
        case 3: {playSound "bl_hit1";};
    }; 
    "dynamicBlur" ppEffectAdjust [2.4];
    "dynamicBlur" ppEffectCommit 6;
    uiSleep 4;
    _s = round (random 3); 
    switch (_s) do 
    {
        case 0: {playSound "bl_wave1";};
        case 1: {playSound "bl_wave2";};
        case 2: {playSound "bl_wave3";};
        case 3: {playSound "bl_wave1";};
    };
    uiSleep 0.3;       
    _bul = [] call bl_flash; 
    _s = round (random 3); 
    switch (_s) do 
    {
        case 0: {playSound "bl_hit1";};
        case 1: {playSound "bl_hit2";};
        case 2: {playSound "bl_hit3";};
        case 3: {playSound "bl_hit1";};
    };
    uiSleep 1;    
    _s = round (random 3); 
    switch (_s) do 
    {
        case 0: {playSound "bl_wave1";};
        case 1: {playSound "bl_wave2";};
        case 2: {playSound "bl_wave3";};
        case 3: {playSound "bl_wave1";};
    };
    uiSleep 2;
    _bul = [] call bl_flash; 
    _s = round (random 3); 
    switch (_s) do 
    {
        case 0: {playSound "bl_hit1";};
        case 1: {playSound "bl_hit2";};
        case 2: {playSound "bl_hit3";};
        case 3: {playSound "bl_hit1";};
    };
    _nonapsi_ef = ppEffectCreate ["colorCorrections", 1555]; 
    _nonapsi_ef ppEffectEnable true;
    _nonapsi_ef ppEffectAdjust [1.0, 1.0, -0.1, [1.0, 0.2, 0.2, 0.0], [1.0, 0.4, 0.0, 0.1],[1.0,0.3,0.3, 0.5]];
    _nonapsi_ef ppEffectCommit 2;
    uiSleep 1;
    _bul = [] call bl_flash; 
    _s = round (random 3); 
    switch (_s) do 
    {
        case 0: {playSound "bl_wave1";};
        case 1: {playSound "bl_wave2";};
        case 2: {playSound "bl_wave3";};
        case 3: {playSound "bl_wave1";};
    };
    _bul = [] call bl_flash; 

    if (!([player] call fnc_hasAPSI)) then {
        playSound "bl_psi";
    };

    uiSleep 4;
    _bul = [] call bl_flash; 
    _s = round (random 3); 
    switch (_s) do 
    {
        case 0: {playSound "bl_wave1";};
        case 1: {playSound "bl_wave2";};
        case 2: {playSound "bl_wave3";};
        case 3: {playSound "bl_wave1";};
    };
    _nonapsi_ef ppEffectAdjust [1.0, 1.0, -0.1, [1.0, 0.1, 0.1, 0.0], [1.0, 0.1, 0.0, 0.1],[1.0,0.1,0.0, 0.5]];
    _nonapsi_ef ppEffectCommit 6;
    uiSleep 1;
    _s = round (random 3); 
    switch (_s) do 
    {
        case 0: {playSound "bl_hit1";};
        case 1: {playSound "bl_hit2";};
        case 2: {playSound "bl_hit3";};
        case 3: {playSound "bl_hit1";};
    };
    uiSleep 3;
    _bul = [] call bl_flash;
    _s = round (random 3); 
    switch (_s) do 
    {
        case 0: {playSound "bl_wave1";};
        case 1: {playSound "bl_wave2";};
        case 2: {playSound "bl_wave3";};
        case 3: {playSound "bl_wave1";};
    };

    _nonapsi_ef ppEffectAdjust [1.0, 1.0, -0.1, [0.0, 0.0, 0.0, 0.0], [0.0, 0.0, 0.0, 5.0],[0.4,0.0,0.0, 0.7]];
    _nonapsi_ef ppEffectCommit 1;

    _bul = [] call bl_local_anims;
    uiSleep 0.1;
    playSound "bl_full";
    uiSleep 0.1;
    titleText["","BLACK OUT",1];
    disableUserInput true;

    if(ns_blowout_exile) then {
        private["_isinbuilding","_isinvehicle"];
        _isinbuilding = false;
		_isinvehicle = false;
		if!(vehicle player isEqualTo player)then
        {
			_isinvehicle = true;
		};
        if([player] call fnc_isInsideBuilding) then {
            _isinbuilding = true;
        };
        if (!([player] call fnc_hasAPSI)) then {
            diag_log format["[NAC BLOWOUT CLIENT] :: Player does not have APSI"];
			
            if ((!_isinbuilding)&&(!_isinvehicle))then {			
					diag_log format["[NAC BLOWOUT CLIENT] :: and is unprotected."];
                    player setDamage (damage player + ns_blow_damage_unprotected);
            };
			
			if (_isinbuilding) then{
                   player setDamage (damage player + ns_blow_damage_inbuilding);
                diag_log format["[NAC BLOWOUT CLIENT] :: player is in a building."];
            };
			
			if(_isinvehicle) then{
					diag_log format["[NAC BLOWOUT CLIENT] :: player is in a vehicle."];
					player setDamage (damage player + ns_blow_damage_invehicle);
			};		
        } else {
            diag_log format["[NAC BLOWOUT CLIENT] :: Player does have APSI, I do not have problem with him."];
        };
    };
    
    uiSleep 1;
    4 fadeSound 0;
    uiSleep 5;
    if ([player] call fnc_hasAPSI) then {disableUserInput false;};
    uiSleep 6;
    6 fadeSound 1;
    titleText["","BLACK IN",10]; 
    ppEffectDestroy _nonapsi_ef;
    waitUntil {!ns_blow_action};
    diag_log format["[NAC BLOWOUT CLIENT] :: ns_blow_action = %1 Blowout actions end received.", ns_blow_action];

    if ([player] call fnc_hasAPSI) then{
        cutRsc ["RscAPSI_h6","PLAIN"];
        playSound "apsi_off";
        "filmGrain" ppEffectEnable false;
    };
	if (ns_blow_removeapsi) then{		
		if(ns_blow_itemtype == 3)then
        { 
			if ([player] call fnc_hasAPSI) then
            {
				player removeMagazine "Item_artefact_psi_field";
			};
		};
    };

    "dynamicBlur" ppEffectAdjust [0];
    "dynamicBlur" ppEffectCommit 16; 

    waitUntil {!ns_blow_status};
    disableUserInput false;
    diag_log format["[NAC BLOWOUT CLIENT] :: ns_blow_status = %1 Blowout end received.", ns_blow_status];  
    _bul = [] call bl_local_def_anim;
};