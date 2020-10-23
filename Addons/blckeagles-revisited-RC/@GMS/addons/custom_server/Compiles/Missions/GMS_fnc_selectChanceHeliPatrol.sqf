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
private["_chanceHeliPatrol"];
	switch (toLower(_aiDifficultyLevel)) do
	{
		case "blue": 	{_chanceHeliPatrol = blck_chanceHeliPatrolBlue};
		case "red": 	{_chanceHeliPatrol = blck_chanceHeliPatrolRed};
		case "green": 	{_chanceHeliPatrol = blck_chanceHeliPatrolGreen};
		case "orange": 	{_chanceHeliPatrol = blck_chanceHeliPatrolOrange};
		default 		{_chanceHeliPatrol = 0};
	};
_chanceHeliPatrol