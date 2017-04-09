// Include shit in here

/*
include map content.
Call compile preprocess'ing them is MUCH better. 
Creating spawn/execvm's IS BAD unless the script is a long running one.
If you try call compile and it all goes to shit, use execvm =P
*/

diag_log "Starting Custom Content PBO";

[] execVM "a3_custom\mapcontent\Tanoka.sqf";
//[] execVM "a3_custom\mapcontent\MountTanoa.sqf";
//[] execVM "a3_custom\mapcontent\MountTanoaFencingRoadblocks.sqf";
//[] execVM "a3_custom\mapcontent\Airport.sqf";
[] execVM "a3_custom\mapcontent\banditbridge.sqf";
[] execVM "a3_custom\mapcontent\adminisland.sqf";
[] execVM "a3_custom\mapcontent\mining.sqf";
[] execVM "a3_custom\mapcontent\castle.sqf";
[] execVM "a3_custom\mapcontent\vagala.sqf";
[] execVM "a3_custom\mapcontent\northwestairfield.sqf";
[] execVM "a3_custom\mapcontent\tanokaradzone.sqf";



