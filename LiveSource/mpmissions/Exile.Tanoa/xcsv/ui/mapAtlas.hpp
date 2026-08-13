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
            x = safezoneX + safezoneW * 0.245;
            y = safezoneY + safezoneH * 0.012;
            w = safezoneW * 0.51;
            h = safezoneH * 0.112;
            colorBackground[] = {0, 0, 0, 0.56};
            text = "<t size='0.84' color='#E8B339' align='center'>MISSION DIFFICULTY AND MAP SIGNALS</t><br/><t size='0.68' color='#E2E7EE' align='center'>Green low  |  Yellow medium  |  Orange hard  |  Red elite  |  Blue water/coastal</t><br/><t size='0.64' color='#7E8896' align='center'>Bambi pacifier markers are fresh-spawn choices. Cash Van markers are guarded poptab transport wrecks.</t>";
        };

        class LeftDirectory: RscStructuredText
        {
            idc = 71991;
            x = safezoneX + safezoneW * 0.008;
            y = safezoneY + safezoneH * 0.135;
            w = safezoneW * 0.17;
            h = safezoneH * 0.47;
            colorBackground[] = {0, 0, 0, 0.58};
            text = "<t size='0.82' color='#3D9CFF'>TRADER AND SPAWN DIRECTORY</t><br/><t size='0.66' color='#E2E7EE'>South Trader</t><t size='0.66' color='#7E8896'> - general goods</t><br/><t size='0.66' color='#E2E7EE'>Mountain Trader</t><t size='0.66' color='#7E8896'> - inland staging</t><br/><t size='0.66' color='#E2E7EE'>North Trader</t><t size='0.66' color='#7E8896'> - Savu/Oumere route</t><br/><t size='0.66' color='#E2E7EE'>Aircraft</t><t size='0.66' color='#7E8896'> - airframes and parts</t><br/><t size='0.66' color='#E2E7EE'>Boat Trader</t><t size='0.66' color='#7E8896'> - coastal logistics</t><br/><br/><t size='0.72' color='#3FC16A'>BAMBI ISLAND STARTS</t><br/><t size='0.64' color='#E2E7EE'>Tuvanaka, La Rochelle, Lijnhaven, Savu</t><br/><t size='0.62' color='#7E8896'>Outer-island starts are better for quiet looting and boat routes. Main-island starts are faster for traders.</t>";
        };

        class RightAtlas: RscStructuredText
        {
            idc = 71992;
            x = safezoneX + safezoneW * 0.823;
            y = safezoneY + safezoneH * 0.135;
            w = safezoneW * 0.17;
            h = safezoneH * 0.47;
            colorBackground[] = {0, 0, 0, 0.58};
            text = "<t size='0.82' color='#E8B339'>XCSV ICON ATLAS</t><br/><t size='0.66' color='#E2E7EE'>Pacifier</t><t size='0.66' color='#7E8896'> - bambi spawn zone</t><br/><t size='0.66' color='#E2E7EE'>Cash Van</t><t size='0.66' color='#7E8896'> - guarded poptabs safe</t><br/><t size='0.66' color='#E2E7EE'>Heli Crash</t><t size='0.66' color='#7E8896'> - weapons and parts</t><br/><t size='0.66' color='#E2E7EE'>Shipwreck</t><t size='0.66' color='#7E8896'> - coastal crates</t><br/><t size='0.66' color='#E2E7EE'>Vehicle Heist</t><t size='0.66' color='#7E8896'> - recoverable ride</t><br/><t size='0.66' color='#E2E7EE'>Gear Crate</t><t size='0.66' color='#7E8896'> - fast loot</t><br/><br/><t size='0.64' color='#E8B339'>Courier wrecks reject trader and safezone markers inside 1km.</t>";
        };

        class BottomSurvival: RscStructuredText
        {
            idc = 71993;
            x = safezoneX + safezoneW * 0.19;
            y = safezoneY + safezoneH * 0.885;
            w = safezoneW * 0.62;
            h = safezoneH * 0.095;
            colorBackground[] = {0, 0, 0, 0.56};
            text = "<t size='0.76' color='#3FC16A' align='center'>FRESH ARRIVAL ROUTE</t><br/><t size='0.64' color='#E2E7EE' align='center'>Spawn, loot one town, find water, then choose: trader run, boat route, or green mission. No safezone combat, no vehicle parking in trader circles, and orange/red missions are group work.</t>";
        };
    };
};
