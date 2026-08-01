class PilotHUD
{
	idd = 28818;
	movingEnable =  0;
	enableSimulation = 1;
	enableDisplay = 1;
	duration     =  9999;
	fadein       =  0;
	fadeout      =  0;
	name = "PilotHUD";
	onLoad = "with uiNameSpace do { PilotHUD = _this select 0 }";

	class controls
	{
		class RscStructuredText
		{
			access = 0;
			type = 13;
			style = 0x00;
			lineSpacing = 1;
			idc = 2395;
			text = ""; //--- ToDo: Localize;
			x = safeZoneX + safeZoneW * 0.87011719;
			y = safeZoneY + safeZoneH * 0.00694445;
			w = safeZoneW * 0.125;
			h = safeZoneH * 0.10590278;
			size = 0.020;
			colorText[] = {1,1,1,1};
			colorBackground[] = {0,0,0,0.5};
			font = "PuristaSemiBold";
			
			class Attributes
			{
				font = "PuristaSemiBold";
				color = "#ffffff";
				align = "CENTER";
				valign = "middle";
				shadow = false;
				shadowColor = "#000000";
				underline = false;
				size = "2";
			}; 
		};
	};
};
	
		
		
		
		
