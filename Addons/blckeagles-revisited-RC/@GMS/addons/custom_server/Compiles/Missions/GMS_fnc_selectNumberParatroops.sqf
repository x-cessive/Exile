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
private["_noPara"];
switch (toLower (_aiDifficultyLevel)) do
{
		case "blue": 	{_noPara = blck_noParaBlue};
		case "red": 	{_noPara = blck_noParaRed};
		case "green": 	{_noPara = blck_noParaGreen};
		case "orange": 	{_noPara = blck_noParaOrange};
		default 		{_noPara = 0};
};
_noPara