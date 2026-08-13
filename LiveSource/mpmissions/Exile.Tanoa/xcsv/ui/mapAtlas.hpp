class XCSVMapAtlas
{
    idd = -1;
    duration = 1000000;
    fadein = 0;
    fadeout = 0;
    movingEnable = 0;
    onLoad = "uiNamespace setVariable ['XCSVMapAtlas', _this select 0]";
    onUnload = "uiNamespace setVariable ['XCSVMapAtlas', displayNull]";

    class controls
    {
        class TopLegend: RscStructuredText
        {
            idc = 71990;
            x = safezoneX + safezoneW * 0.31;
            y = safezoneY + safezoneH * 0.015;
            w = safezoneW * 0.38;
            h = safezoneH * 0.105;
            colorBackground[] = {0, 0, 0, 0.56};
            text = "<t size='0.85' color='#E8B339' align='center'>MISSION DIFFICULTY</t><br/><t size='0.72' color='#7E8896' align='center'>Green low  |  Yellow medium  |  Orange hard  |  Red elite  |  Blue water/coastal</t>";
        };

        class LeftDirectory: RscStructuredText
        {
            idc = 71991;
            x = safezoneX + safezoneW * 0.008;
            y = safezoneY + safezoneH * 0.15;
            w = safezoneW * 0.17;
            h = safezoneH * 0.42;
            colorBackground[] = {0, 0, 0, 0.58};
            text = "<t size='0.82' color='#3D9CFF'>TRADER DIRECTORY</t><br/><t size='0.68' color='#E2E7EE'>South Trader</t><t size='0.68' color='#7E8896'> - general route</t><br/><t size='0.68' color='#E2E7EE'>Mountain Trader</t><t size='0.68' color='#7E8896'> - inland staging</t><br/><t size='0.68' color='#E2E7EE'>North Trader</t><t size='0.68' color='#7E8896'> - Savu/Oumere route</t><br/><t size='0.68' color='#E2E7EE'>Aircraft</t><t size='0.68' color='#7E8896'> - airframes and parts</t><br/><t size='0.68' color='#E2E7EE'>Boat Trader</t><t size='0.68' color='#7E8896'> - coastal logistics</t><br/><br/><t size='0.66' color='#E8B339'>No courier wrecks spawn within 1km of trader/safezone markers.</t>";
        };

        class RightAtlas: RscStructuredText
        {
            idc = 71992;
            x = safezoneX + safezoneW * 0.823;
            y = safezoneY + safezoneH * 0.15;
            w = safezoneW * 0.17;
            h = safezoneH * 0.42;
            colorBackground[] = {0, 0, 0, 0.58};
            text = "<t size='0.82' color='#E8B339'>XCSV ICON ATLAS</t><br/><t size='0.68' color='#E2E7EE'>Cash Van</t><t size='0.68' color='#7E8896'> - guarded poptabs</t><br/><t size='0.68' color='#E2E7EE'>Heli Crash</t><t size='0.68' color='#7E8896'> - weapons and parts</t><br/><t size='0.68' color='#E2E7EE'>Shipwreck</t><t size='0.68' color='#7E8896'> - coastal crates</t><br/><t size='0.68' color='#E2E7EE'>Vehicle Heist</t><t size='0.68' color='#7E8896'> - recoverable ride</t><br/><t size='0.68' color='#E2E7EE'>Gear Crate</t><t size='0.68' color='#7E8896'> - fast loot</t><br/><br/><t size='0.66' color='#7E8896'>Custom XCSV PAA icon pack is next; current pass standardizes meaning first.</t>";
        };

        class BottomSurvival: RscStructuredText
        {
            idc = 71993;
            x = safezoneX + safezoneW * 0.24;
            y = safezoneY + safezoneH * 0.895;
            w = safezoneW * 0.52;
            h = safezoneH * 0.085;
            colorBackground[] = {0, 0, 0, 0.56};
            text = "<t size='0.78' color='#3FC16A' align='center'>FRESH ARRIVAL</t><br/><t size='0.68' color='#E2E7EE' align='center'>Find a trader, buy a grinder, avoid safezone combat, carry spare water, read Field Notes, and treat orange/red missions as group work.</t>";
        };
    };
};
