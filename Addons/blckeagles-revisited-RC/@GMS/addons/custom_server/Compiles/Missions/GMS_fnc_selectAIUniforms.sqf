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
private["_uniforms"];
	switch (toLower (_aiDifficultyLevel)) do
	{
		case "blue": 	{_uniforms = blck_SkinList_blue};
		case "red": 	{_uniforms = blck_SkinList_red};
		case "green": 	{_uniforms = blck_SkinList_green};
		case "orange": 	{_uniforms = blck_SkinList_orange};
		default 		{_uniforms = blck_SkinList};
	};
_uniforms