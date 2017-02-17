execVM "custom\acd_TB\run.sqf";
_GF = [] execVM "ground_fog.sqf";

[] execVM "addons\HEG_Xbrm_client\Xbrm_config.sqf";
[] execVM "IgiLoad\IgiLoadInit.sqf";
[] execVM "custom\money\takegive_poptab_init.sqf";
[] execVM "ToastIntro.sqf";
[] execVM "effect.sqf";
[] execVM "Custom\EnigmaRevive\init.sqf";
[] execVM "config_storms.sqf";
[] execVM "ClaimVehicles_Client\ClaimVehicles_Client_init.sqf";

if (hasInterface || isServer) then {
//[] call compileFinal preprocessFileLineNumbers "addons\welcome\welcome.sqf";
[] execVM "custom\service\service_point.sqf";
};



