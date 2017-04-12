/*  
	fn_getTempStr.sqf
	
	Copyright 2016 Jan Babor

	Licensed under the Apache License, Version 2.0 (the "License");
	you may not use this file except in compliance with the License.
	You may obtain a copy of the License at

		http://www.apache.org/licenses/LICENSE-2.0

	Unless required by applicable law or agreed to in writing, software
	distributed under the License is distributed on an "AS IS" BASIS,
	WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
	See the License for the specific language governing permissions and
	limitations under the License.

*/
private["_request","_img","_text"];

_request = [];

_img = [ExAd_SB_ICON_TEMP] call ExAd_fnc_formatSBImage;
_temp = [ExileClientPlayerAttributes select 5, 1] call ExileClient_util_math_round;
_text = _temp;

_request pushBack [_img,_text, "°C"];

if(ExAd_SB_COMPONENTS_ACTIVE_COLORS)then{
	_request pushBack ([0,37,_text] call ExAd_fnc_getSBColor)
};

_request call ExAd_fnc_formatSBOutput