
// Last modified 8/13/17 by Ghostrider [GRG]
/*
	By Ghostrider [GRG]
	Copyright 2016	
	--------------------------
	License
	--------------------------
	All the code and information provided here is provided under an Attribution Non-Commercial ShareAlike 4.0 Commons License.

	http://creativecommons.org/licenses/by-nc-sa/4.0/
*/
#include "\q\addons\custom_server\Configs\blck_defines.hpp";

params["_data"];
_value = 0;
if (typeName _data isEqualTo "ARRAY") then
{
	_data params["_min","_max"];
	if (_max > _min) then 
	{
		_value = _min + round(random(_max - _min));
	} else {
		_value = _min;
	};
} else {
	if (typeName _data isEqualTo "SCALAR") then
	{
		_value = _data;
	};
};
_value