//add to top of initPlayerLocal.sqf underneath if (!hasInterface || isServer) exitWith {};
client_lowKneelAnimations = "getText(_x >> 'actions') in ['RifleAdjustBKneelActions', 'PistolAdjustBKneelActions'] && getNumber(_x >> 'looped') == 1" configClasses (configFile >> "CfgMovesMaleSdr" >> "States") apply {toLower configName _x};
client_toLowKneelAnimations = [];
{_anim = _x; client_toLowKneelAnimations append ("_anim in (getArray(_x >> 'connectTo') select {_x isEqualType ''} apply {toLower _x})" configClasses (configFile >> "CfgMovesMaleSdr" >> "States") apply {toLower configName _x})} forEach client_lowKneelAnimations;
client_inLowKneel = false;