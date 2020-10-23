class CfgPatches
{
	class PublicVirtualGarage_server
	{
		requiredVersion = 0.1;
		requiredAddons[] = {"exile_server_config"};
		units[] = {};
		weapons[] = {};
		magazines[] = {};
		ammo[] = {};
	};
};
class CfgFunctions
{
	class PublicVirtualGarage_server
	{
		class Bootstrap
		{
			file = "PublicVirtualGarage_server\bootstrap";
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