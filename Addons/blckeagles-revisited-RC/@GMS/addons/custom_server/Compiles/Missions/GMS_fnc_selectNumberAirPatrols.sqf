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
private["_noChoppers"];
switch (toLower (_aiDifficultyLevel)) do
{
	case "blue": 	{_noChoppers = blck_noPatrolHelisBlue};
	case "red": 	{_noChoppers = blck_noPatrolHelisRed};
	case "green": 	{_noChoppers = blck_noPatrolHelisGreen};
	case "orange": 	{_noChoppers = blck_noPatrolHelisOrange};
	default 		{_noChoppers = 0};
};
_noChoppers