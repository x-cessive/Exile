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
private["_backpacks"];
switch (toLower (_aiDifficultyLevel)) do
{
	case "blue": 	{_backpacks = blck_backpacks_blue};
	case "red": 	{_backpacks = blck_backpacks_red};
	case "green": 	{_backpacks = blck_backpacks_green};
	case "orange": 	{_backpacks = blck_backpacks_orange};
	default 		{_backpacks = blck_backpacks};
};
_backpacks