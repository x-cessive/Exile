/*
© 2015 Zenix Gaming Ops
Developed by Rod-Serling and Vishpala

All rights reserved.

Function:
	config - Defines the configuration for AVS.
*/

#define _ARMA_

class CfgPatches
{
	class AVS
	{
		units[] = {};
		weapons[] = {};
		AVS_Version = "1.0.0 RC1";
	};
};

class CfgFunctions
{
	class AVS
	{
		class Bootstrap
		{
			file = "AVS\bootstrap";
			class preInit
			{
				preInit = 1;
			};
		};

		class compiles
		{
			file = "AVS\code";
			class getBlacklistedAmmo			{};
			class getBlacklistedWeapons			{};
			class loadAmmo						{};
			class rearmVehicle					{};
			class sanitizeVehicle				{};
			class saveAmmo						{};
			class spawnAllVehicles				{};
			class spawnPersistentVehicle		{};
		};
	};
};
