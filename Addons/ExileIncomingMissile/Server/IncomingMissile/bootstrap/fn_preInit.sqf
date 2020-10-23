 /*
 *
 * Author: Andrew_S90
 *
 * This work is protected by Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International (CC BY-NC-SA 4.0). 
 *
 */

{
    _code = compileFinal (preprocessFileLineNumbers (_x select 1));
    missionNamespace setVariable [(_x select 0), _code];
}
forEach
[
    ['ExileServer_object_vehicle_event_incomingMissile','IncomingMissile\code\ExileServer_object_vehicle_event_incomingMissile.sqf']
];
diag_log "Loaded IncomingMissle";
true
