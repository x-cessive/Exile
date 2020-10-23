class MWarning
{
	idd = 734698;
	movingEnable =  0;
	enableSimulation = 1;
	enableDisplay = 1;
	duration     =  3;
	fadein       =  0.1;
	fadeout      =  0;
	name = "MWarning";
	onLoad = "with uiNameSpace do { MWarning = _this select 0 }";
/* 		class controlsBackground 
	{
		class RscPicture
		{
			idc = 1200;
			text = "#(argb,8,8,3)color(0,0,0,0.5)";
			x = 0.36544 * safezoneW + safezoneX;
			y = 0.0711829 * safezoneH + safezoneY;
			w = 0.26912 * safezoneW;
			h = 0.0769672 * safezoneH;
			colorBackground[] = {0,0,0,0};
		};
	}; */
	class controls
	{
		class RscStructuredText
		{
			access = 0;
			type = 13;
			style = 0x00;
			lineSpacing = 1;
			idc = 1100;
			text = "Missile Incoming!"; //--- ToDo: Localize;
			x = 0.375791 * safezoneW + safezoneX;
			y = 0.0821782 * safezoneH + safezoneY;
			w = 0.248419 * safezoneW;
			h = 0.0549765 * safezoneH;
			size = 0.020;
			colorText[] = {1,1,1,1};
			colorBackground[] = {0,0,0,0.5};
			font = "PuristaSemiBold";
			
			class Attributes
			{
				font = "PuristaSemiBold";
				color = "#da1818";
				align = "CENTER";
				valign = "middle";
				shadow = false;
				shadowColor = "#000000";
				underline = false;
				size = "4";
			}; 
		};
	};
};
	
		
		
		
		
