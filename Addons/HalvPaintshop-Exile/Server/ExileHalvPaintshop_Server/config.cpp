class CfgPatches
{
	class exileHalvPaintshop_Server
	{
		requiredVersion = 0.1;
		requiredAddons[] = {"exile_client","exile_assets","exile_server_config"};
		units[] = {};
		weapons[] = {};
		magazines[] = {};
		ammo[] = {};
	};
};
class CfgFunctions
{
    class exileHalvPaintshop_Server
    {
        class Bootstrap
        {
            file = "exileHalvPaintshop_Server\bootstrap";
            class preInit
            {
                preInit = 1;
            };
            class postInit
            {
                postInit = 1;
            };
        };
    };
};
class CfgNetworkMessages
{
    class saveVehiclePaintRequest
    {
        module = "saveVehiclePaintRequest";
        parameters[] = {"STRING","ARRAY"};
    };
};
