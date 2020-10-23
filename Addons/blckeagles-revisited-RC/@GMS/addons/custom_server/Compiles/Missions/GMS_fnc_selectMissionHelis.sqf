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
private["_missionHelis"];
switch (toLower (_aiDifficultyLevel)) do
{
	case "blue":	{_missionHelis = blck_patrolHelisBlue};
	case "red":		{_missionHelis = blck_patrolHelisRed};
	case "green": 	{_missionHelis = blck_patrolHelisGreen};
	case "orange": 	{_missionHelis = blck_patrolHelisOrange};
	default			{_missionHelis = blck_patrolHelisBlue};
};
_missionHelis