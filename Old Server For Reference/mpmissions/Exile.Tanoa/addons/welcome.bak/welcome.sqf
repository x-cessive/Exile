//    @file Version: 1.0
//    @file Name: welcome.sqf
//    @file Author: Cael817
//    @file Credits: iCEtIMed, Pain2407
//    @file Info: Shows a informational window when you load into a mission. Based on iCEtIMed's Warning Messages

waitUntil {!isNull (findDisplay 46)};
waitUntil {!dialog};

sleep 6;

_att = format["[Welcome to X-Cessive Exile %1]", name player]; //uncomment this if you want the player name in the headline, and comment out the other one
//_att = format["[Welcome to %1]", serverName]; //uncomment this if you want the server name in the headline (needs to be pretty short thou) and comment out the other one.
_att hintC [
    parseText "<t shadow='2'size='1' >Rule #1</t><br/><t shadow='2'size='0.75' >Don't be a dickhead. Harrasment, cheating, griefing, racial slur/insults etc. is not accepted and will result in a permanent ban.</t>",
    parseText "<t shadow='2'size='1' >Rule #2</t><br/><t shadow='2'size='0.75' >You may be in a free fall so hurry up and read this, its in the XM8 if you need it.</t>",
    parseText "<t shadow='2'size='1' >Rule #3</t><br/><t shadow='2'size='0.75' >Use English in side chat(no talking) and keep it civil, rule 1 applies.</t>",
    parseText "<t shadow='2'size='1' >Rule #4</t><br/><t shadow='2'size='0.75' >Have fun =)!</t>",
    parseText "<t shadow='2'size='1' >Info !</t><br/><t shadow='2'size='0.75' >
    Check XM8 For more info, deploy bike, BRarma, Virtual Garage, Customize Status bar and more!
    <br/>
    1. Bring Mask To Radiation Zone Or Die Like a Little Bitch.
    <br/>
    2. This server doesn't hold your hand, If you need that, find another server. I.e. shouting for an admin every 5s will not help and rule 2 applies.
    <br/>
    3. No, your lost items and money will not be replaced. This is ArmA, deal with it. Crying is done somewhere else.
    <br/>
    However, backups is made every hour so if shit hits the fan, we can go back.
    <br/>
    That being said, try to help out if someone asks, we where all new once, be patient and helpful to other players.
    <br/>
    4. Theft In Trader areas Is Welcome and Heart Warming.  Lock Your Shit Jackass! Working on Removing Safe Zones at ALL Traders So prepare yourself!
    <br/>
    By clicking ""Continue"", you accept the rules and will not complain, ever!
    </t>" //No comma at the last line =)
];

 hintC_arr_EH = findDisplay 72 displayAddEventHandler ["unload", {
    0 = _this spawn {
        _this select 0 displayRemoveEventHandler ["unload", hintC_arr_EH];
        hintSilent "";
    };
}]; 