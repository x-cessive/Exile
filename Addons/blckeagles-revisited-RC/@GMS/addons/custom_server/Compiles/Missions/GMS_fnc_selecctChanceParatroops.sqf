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
private["_chancePara"];
switch (toLower (_aiDifficultyLevel)) do
{
		case "blue": 	{_chancePara = blck_chanceParaBlue};
		case "red": 	{_chancePara = blck_chanceParaRed};
		case "green": 	{_chancePara = blck_chanceParaGreen};
		case "orange": 	{_chancePara = blck_chanceParaOrange};
		default {_chancePara = blck_chanceParaRed};
};
_chancePara