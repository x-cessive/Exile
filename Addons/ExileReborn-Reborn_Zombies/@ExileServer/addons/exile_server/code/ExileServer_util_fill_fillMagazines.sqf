/**
 * ExileServer_util_fill_fillMagazines
 *
 * Exile Mod
 * www.exilemod.com
 * © 2015 Exile Mod Team
 *
 * This work is licensed under the Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 International License. 
 * To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-nd/4.0/.
 */
 
private["_object","_magazines"];
_object = _this select 0;
_magazines = _this select 1;
if ((typeName _magazines) isEqualTo "ARRAY") then 
{	
	if!(_magazines isEqualTo [])then
	{
		{
			_object addMagazineAmmoCargo [_x select 0, 1 , _x select 1];
		}
		forEach _magazines;
	};
};
true