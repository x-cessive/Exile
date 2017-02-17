//Written by William
// to change colors "SuccessTitleAndText" is green "InfoTitleAndText" is blue "ErrorTitleAndText" is red, enjoy
// for custom smaller text below the big message change of of the lines to this 			["InfoTitleAndText", ["Big Text", "custom smaller text"]] call ExileClient_gui_toaster_addTemplateToast; sleep 7;
// DON'T INCLUDE sleep (number) on the last one

waitUntil{!isNull (findDisplay 46)};  

if ( alive player ) then {

  	sleep 14;
	["InfoTitleAndText", ["Deploy Bike/Quad With Extension Cord Via MX8"]] call ExileClient_gui_toaster_addTemplateToast; sleep 30;
	["InfoTitleAndText", ["Join Our Community At WWW.X-CESSIVE.US"]] call ExileClient_gui_toaster_addTemplateToast; sleep 90;
	["InfoTitleAndText", ["TS3 @ x-cessive.game-server.cc"]] call ExileClient_gui_toaster_addTemplateToast; sleep 90;
	["InfoTitleAndText", ["Looking For Staff, Apply @ Website"]] call ExileClient_gui_toaster_addTemplateToast; sleep 90;
	["SuccessTitleAndText", ["Read Rules In XM8"]] call ExileClient_gui_toaster_addTemplateToast;
	
};