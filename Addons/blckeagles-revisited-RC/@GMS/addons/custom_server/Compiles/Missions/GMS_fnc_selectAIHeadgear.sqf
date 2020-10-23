/*
	by Ghostrider [GRG]

	--------------------------
	License
	--------------------------
	All the code and information provided here is provided under an Attribution Non-Commercial ShareAlike 4.0 Commons License.

	http://creativecommons.org/licenses/by-nc-sa/4.0/	
*/

#include "\q\addons\custom_server\Configs\blck_defines.hpp";

params["_aiDifficultyLevel"];
private["_headgear"];
switch (toLower (_aiDifficultyLevel)) do
{
	case "blue": 	{_headGear = blck_headgear_blue};
	case "red": 	{_headGear = blck_headgear_red};
	case "green": 	{_headGear = blck_headgear_green};
	case "orange": 	{_headGear = blck_headgear_orange};
	default 		{_headGear = blck_headgear};
};
_headgear