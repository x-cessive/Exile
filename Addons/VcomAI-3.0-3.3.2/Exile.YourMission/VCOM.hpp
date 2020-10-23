class VCOM_ESCButton
{
	idd = 5230;
	movingenable = true;
	moving = 1;
	class  Controls
	{
		class VCOM_Infotext: RscText
		{
			idc = 1001;
			text = "Mouse Here for VCOM Options."; //--- ToDo: Localize;
			x = 0.85 * safezoneW + safezoneX;
			y = 0.1 * safezoneH + safezoneY;
			w = 0.159844 * safezoneW;
			h = 0.022 * safezoneH;
		};
		class VCOMAI_ButtonOptions: RscButton
		{
			idc = 1600;
			text = "VCOMAI - OPTIONS"; //--- ToDo: Localize;
			x = 0.85 * safezoneW + safezoneX;
			y = 0.1 * safezoneH + safezoneY;
			w = 0.159844 * safezoneW;
			h = 0.022 * safezoneH;
			onButtonClick	= "null = [] call VCOM_PARAMSOPTIONS;";
			colorBackground[] = {0.34,0.99,0.22,1};
			colorActive[] = {0.34,0.99,0.22,1};
			tooltip = "Open VCOMAI's options menu. Only the host's changes will be made global."; //--- ToDo: Localize;
		};
	};
};
////////////////////////////////////////////////////////
// GUI EDITOR OUTPUT START (by Genesis, v1.063, #Rysaji)
////////////////////////////////////////////////////////

class VCOM_PARAMS
{
	idd = 7123;
	movingenable = true;
	class  Controls
	{
		class RscPicture_1200: RscPicture
		{
			idc = 1200;
			text = "#(argb,8,8,3)color(1,1,1,1)";
			x = 0.2525 * safezoneW + safezoneX;
			y = 0.192 * safezoneH + safezoneY;
			w = 0.45375 * safezoneW;
			h = 0.583 * safezoneH;
		};
		class VCOMAI_ParameterList: RscListbox
		{
			idc = 1500;
			x = 0.304062 * safezoneW + safezoneX;
			y = 0.247 * safezoneH + safezoneY;
			w = 0.134062 * safezoneW;
			h = 0.484 * safezoneH;
			colorBackground[] = {0,0,0,1};
			colorActive[] = {0,0,0,1};	
			tooltip = "Displays all easily changeable params here."; //--- ToDo: Localize;
		};
		class VCOMAI_SETPARAMTEXT: RscEdit
		{
			idc = 1400;
			x = 0.5 * safezoneW + safezoneX;
			y = 0.599 * safezoneH + safezoneY;
			w = 0.154687 * safezoneW;
			h = 0.022 * safezoneH;
			tooltip = "Enter the value you want here. Becareful with this! You can cause some major problems."; //--- ToDo: Localize;
			onButtonClick	= "closedialog 7123";
		};
		class VCOM_TEXT1: RscText
		{
			idc = 1000;
			text = "VALUE:"; //--- ToDo: Localize;
			x = 0.5 * safezoneW + safezoneX;
			y = 0.577 * safezoneH + safezoneY;
			w = 0.061875 * safezoneW;
			h = 0.022 * safezoneH;
		};
		class RscTextInfo: RscControlsGroup
		{
			idc = 27200;
					x = 0.45875 * safezoneW + safezoneX;
					y = 0.247 * safezoneH + safezoneY;
					w = 0.237187 * safezoneW;
					h = 0.308 * safezoneH;
			class VScrollbar
			{
				idc = 20;
				color[] = {1,1,1,0.5};
				width = 0.021;
				autoScrollEnabled = 0;
				autoScrollSpeed = 0;
				autoScrollRewind = 0;
				colorActive[] = {1,1,1,1};
				colorDisabled[] = {1,1,1,0.3};
				thumb = "#(argb,8,8,3)color(0,0,0,1)";
				arrowEmpty = "\A3\ui_f\data\GUI\RscCommon\rsccombo\arrow_combo_active_ca.paa";
				arrowFull = "\A3\ui_f\data\GUI\RscCommon\rsccombo\arrow_combo_active_ca.paa";
				border = "#(argb,8,8,3)color(1,1,1,1)";
			};
			class HScrollbar
			{
				idc = 21;
				color[] = {1,1,1,0.5};
				width = 0.021;
				autoScrollEnabled = 1;
				autoScrollSpeed = 0.2;
				autoScrollRewind = 0.2;
				colorActive[] = {1,1,1,1};
				colorDisabled[] = {1,1,1,0.3};
				thumb = "#(argb,8,8,3)color(0,0,0,1)";
				arrowEmpty = "\A3\ui_f\data\GUI\RscCommon\rsccombo\arrow_combo_active_ca.paa";
				arrowFull = "\A3\ui_f\data\GUI\RscCommon\rsccombo\arrow_combo_active_ca.paa";
				border = "#(argb,8,8,3)color(1,1,1,1)";
			};				
			sizeEx = 0.02;
			class Controls
			{
				class VCOMAI_StructuredText: RscStructuredText
				{
					idc = 27201;
					x = 0;
					y = 0;
					w = 0.24 * safezoneW;
					h = 1;
					text = "";
					colorText[] = {1,1,1,1};
					shadow = 0;
					colorBackground[] = {0,0,0,1};
				};
	 
			};
		};
		class VCOMAI_ChangeButton: RscButton
		{
			idc = 1600;
			text = "CONFIRM"; //--- ToDo: Localize;
			x = 0.546406 * safezoneW + safezoneX;
			y = 0.643 * safezoneH + safezoneY;
			w = 0.061875 * safezoneW;
			h = 0.044 * safezoneH;
			tooltip = "Confirm the value listed above."; //--- ToDo: Localize;
			onButtonClick	= "null = [] call VCOM_PARAMCHANGE";
		};
		class VCOMAI_ButtonExit: RscButton
		{
			idc = 1601;
			text = "EXIT"; //--- ToDo: Localize;
			x = 0.2525 * safezoneW + safezoneX;
			y = 0.192 * safezoneH + safezoneY;
			w = 0.04125 * safezoneW;
			h = 0.033 * safezoneH;
			onButtonClick	= "closedialog 7123";
		};
		class VCOM_AITEXTLIST: RscText
		{
			idc = 1001;
			text = "PARAMETERS"; //--- ToDo: Localize;
			x = 0.335 * safezoneW + safezoneX;
			y = 0.225 * safezoneH + safezoneY;
			w = 0.0928125 * safezoneW;
			h = 0.022 * safezoneH;
		};
	};
};