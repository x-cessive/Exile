uiSleep 30;

/*
	MAP CENTER POSITIONS: (CREDIT GOES TO FACE FOR THESE)

["altis",[15834.2,15787.8,0] ["australia",[21966.2,22728.5,0] ["bootcamp_acr",[1938.24,1884.16,0] ["caribou",[3938.9722, 4195.7417] ["chernarus",[7652.9634, 7870.8076] ["chernarus_summer",[6669.88,9251.68,0] ["desert_e",[1034.26,1022.18,0] ["esseker",[6206.94,5920.05,0] ["fallujah",[5139.8008, 4092.6797] ["fdf_isle1_a",[10771.362, 8389.2568] ["intro",[2914.44,2771.61,0] ["isladuala",[4945.3438, 4919.6616], ["lingor",[5166.5581, 5108.8301], ["mbg_celle2",[6163.52, 6220.3984], ["mountains_acr",[3223.09,3242.13,0], ["namalsk",[5880.1313, 8889.1045], ["napf",[10725.096, 9339.918], ["oring",[5191.1069, 5409.1938], ["panthera2",[5343.6953, 4366.2534], ["porto",[2641.45,2479.77,0], ["sara",[12693.104, 11544.386], ["saralite",[5357.5,5000.67,0], ["sara_dbe1",[11995.3,11717.9,0], ["sauerland",[12270.443, 13632.132], ["smd_sahrani_a2",[12693.104, 11544.386], ["stratis",[3937.6,4774.51,0], ["takistan",[6368.2764, 6624.2744], ["tavi",[10887.825, 11084.657], ["trinity",[7183.8403, 7067.4727], ["utes",[3519.8037, 3703.0649], ["woodland_acr",[3884.41,3896.44,0], ["zargabad",[3917.6201, 3800.0376];

*/

interval = 360; 														// How often the script will check required conditions to spawn the storms -- Default 10 mins
_randomInterval = true;													// Additional random amount of time to ontop of the interval time to call a storm
_randomIntervalTime = 360;												// Amount of time in seconds to be randomly added to the interval time

boltAmount = 60;														// Defines the amount of lightning strikes around a location each time the storm happens

mapCenter = [800.00,800.00];										    // Default Strats -- Select the correct center pos from the list above
useDynamicStorms = true;												// If true, ensure mapCenter above is set for your map. If false, ensure the array below is populated.
fixedStormPositions = [[0,0,0],[0,0,0]];								// Array of randomly selected positions that you can define.
strikeRadius = 600;														// Radius around the Storm center lightning bolts can strike
requiredRain = 0.5;														// Required rain level for storms to spawn

/*
	Warning message settings -- Format is Chat: Alpha: Bravo
	Example message players receive for the below settings -- Global chat: ELECTRICAL STORM WARNING: An intense electrical storm has been seen near: 081495
*/

warnPlayers = true;													// If true - players receive a warning of an incoming storm
stormMessageAlpha = "ELECTRIC STORM WARNING";							// First portion of the message
stormMessageBravo = "An intense electric storm has been detected near";	// Second portion of the message
showGridLocation = true;												// If true, the grid location of the storm is displayed in the warning message
messageNumber = 1;														// How many times you want the message to display
messageDelay = 2;														// Delay in seconds between each message
stormDelay = 20;														// Delay in seconds after the messages for the storm to start **THIS CANNOT EXCEDE YOUR INTERVAL SETTINGS**

stormMarker = true;													// Create a marker at the center of the storm

debugStorms = false;													// Removes delays for testing and removes conditions to activate storms

if (_randomInterval) then
{
	interval = interval + floor (random _randomIntervalTime);
};

if (debugStorms) then
{	
	interval = 30;
	diag_log format ["Debug active interval set to %1",interval];
};

if (stormDelay >= interval) then
{
	stormDelay = 0;
	diag_log format ["Storm delay is more than storm interval -- Storm delay:%1 Storm interval:%1 -- Removing storm delay",stormDelay,interval];
};	

diag_log format ["STORM SYSTEM ACTIVATED WITH [Storm interval:%1][Randomized Storm:%2][Bolt amount:%3][Strike Radius:%4][Required rain:%5][Warn players:%6][Show grid:%7][Show marker:%8]",interval,_randomInterval,boltAmount,strikeRadius,requiredRain,warnPlayers,showGridLocation,stormMarker];

[] execVM "JohnO_fnc_storm.sqf";