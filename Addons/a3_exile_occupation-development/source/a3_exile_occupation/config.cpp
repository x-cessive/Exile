class CfgPatches
{
	class a3_exile_occupation
	{
		units[] = {};
		weapons[] = {};
		requiredVersion = 0.1;
		a3_exile_occupation_version = "V71 (23-01-2019)";
		requiredAddons[] = {"a3_dms"};
		author[]= {"second_coming - updated/modified by [FPS]kuplion"};
	};
};

class CfgFunctions
{
	class yorkshire
	{
		class main
		{			
			class YORKS_init
			{
				postInit = 1;
				file = "\x\addons\a3_exile_occupation\initServer.sqf";
			};
		};
	};
};
