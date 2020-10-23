class CfgPatches
{
	class FlagHack_server
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
	class FlagHack_server
	{
		class Bootstrap
		{
			file = "FlagHack_server\bootstrap";
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