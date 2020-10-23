/////////////////////////////////////////////////////////////////////////////////
//	Dynamic Event Management System		/////////////////////////////////////////////
// 	Created 6/1/19						/////////////////////////////////////////////
// 	Developed by TheOneWhoKnocks		/////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////
/*
Version 0.95

*/
CAMS_Version = "0.95";
publicVariable "CAMS_Version";

diag_log format ["[CAMS:%1] CAMSconfig.sqf: Launching...",CAMS_Version];




//////////////////////////////////////////////////////////////////////////////////
// Common Asset Manager System	//////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////

CAMS_useVanilla	= true;	// True - Loads Arma 3 Vanilla Content | False - Does not load vanilla assets | NOTE: If set to false, you need to be sure you have a VERY clean cart file that fills all minimum needs for system to run
CAMS_useExile		= true;	// True - Loads Exile Content | False - Does not load exile assets

CAMS_cartList = 	[	// Name of CART directory 
							"helicopters",
							"marksmen",
							"jets",
							"apex"
						];
						