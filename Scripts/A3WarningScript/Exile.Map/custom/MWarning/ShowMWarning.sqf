disableSerialization;

("MWarningLayer" call BIS_fnc_rscLayer) cutRsc ["MWarning","PLAIN"]; //show
waitUntil {!isNull (uiNameSpace getVariable "MWarning") };
sleep 3;
("MWarningLayer" call BIS_fnc_rscLayer) cutText ["","PLAIN"]; //remove