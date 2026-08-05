/*
	Exile Status Bar by [FPS]kuplion - Based on Stats Bar by Creampie
*/

class StatusBar
{
	idd = -1;
	onLoad = "uiNamespace setVariable ['StatusBar', _this select 0]";
	onUnload = "uiNamespace setVariable ['StatusBar', objNull]";
	onDestroy = "uiNamespace setVariable ['StatusBar', objNull]";
	fadein = 0;
	fadeout = 0;
	duration = 10e10;
	movingEnable = 0;
	controlsBackground[] = {};
	objects[] = {};
	class controls
	{
		class statusBarText
		{
			idc = 55554;
			// Height and offset are normalised (fractions of screen height), NOT
			// pixel-based. The font size below (0.04) is normalised too, so a
			// pixel-derived height clips the text on high-DPI displays: 30*pixelH
			// is ~2.8% of screen height at 1080p but only ~1.4% at 2160p, while the
			// glyphs stay 4% tall either way. That is what cut the bar in half at 4K.
			x = safezoneX;
			y = safeZoneY + safeZoneH - 0.055;
			w = safeZoneW;
			h = 0.05;
			shadow = 2;
			font = "OrbitronLight";
			size = 0.04;
			type = 13;
			style = 2;
			text="";
			class Attributes
			{
				align="center";
				color = "#ffffff";
                font = "OrbitronLight";
			};
		};
	};
};