/* ----------------------------------------------------------------------------------------------------
Function:
	GKB_fnc_writeToMapFont

Author:
	Gekkibi

Terms for copying, distribution and modification:
	Attribution-NonCommercial-ShareAlike 3.0 Unported (CC BY-NC-SA 3.0)
	http://creativecommons.org/licenses/by-nc-sa/3.0/

Description:
	Defines marker axis positions, sizes, angles and offset for GKB_fnc_writeToMap.

Parameters:
	1st	String			Symbol

Returns:
	Marker axis positions, sizes, angles and offset in an array
	[[[posX, posY], size, angle], ...], offset]

Example:
	_symbol = "G" call GKB_fnc_writeToMapFont;
---------------------------------------------------------------------------------------------------- */

private ["_return", "_symbol"];
_symbol = _this;
call {
	if (_symbol == "0") exitWith {_return = [[[[-5, 0], 10, 0], [[0, -10], 4, 90], [[0, 10], 4, 90], [[5, 0], 10, 0]], 15];};
	if (_symbol == "1") exitWith {_return = [[[[-5, 8], 1, 0], [[-3, 0], 11, 0]], 7];};
	if (_symbol == "2") exitWith {_return = [[[[-5, -5.5], 5.5, 0], [[-5, 8], 2, 0], [[0, 0], 4, 90], [[0, 10], 4, 90], [[1, -10], 5, 90], [[5, 5], 5, 0]], 15];};
	if (_symbol == "3") exitWith {_return = [[[[-5, -8], 2, 0], [[-5, 8], 2, 0], [[0, -10], 4, 90], [[0, 10], 4, 90], [[2, 0], 3, 90], [[5, -5.5], 4.5, 0], [[5, 5.5], 4.5, 0]], 15];};
	if (_symbol == "4") exitWith {_return = [[[[-5, 3], 4, 0], [[-3, 8.5], 2.5, 0], [[1, 0], 5, 90], [[4, -6], 5, 0], [[4, 6], 5, 0]], 14];};
	if (_symbol == "5") exitWith {_return = [[[[-5, -8], 2, 0], [[-5, 5], 6, 0], [[0, -10], 4, 90], [[0, 0], 4, 90], [[1, 10], 5, 90], [[5, -5], 5, 0]], 15];};
	if (_symbol == "6") exitWith {_return = [[[[-5, 0], 10, 0], [[0, -10], 4, 90], [[0, 0], 4, 90], [[0, 10], 4, 90], [[5, -5], 5, 0], [[5, 8], 2, 0]], 15];};
	if (_symbol == "7") exitWith {_return = [[[[0, 10], 6, 90], [[1, -5], 6, 0], [[3, 2], 2, 0], [[5, 6], 3, 0]], 15];};
	if (_symbol == "8") exitWith {_return = [[[[-5, -5.5], 4.5, 0], [[-5, 5.5], 4.5, 0], [[0, -10], 4, 90], [[0, 0], 5, 90], [[0, 10], 4, 90], [[5, -5.5], 4.5, 0], [[5, 5.5], 4.5, 0]], 15];};
	if (_symbol == "9") exitWith {_return = [[[[-5, -8], 2, 0], [[-5, 5], 5, 0], [[0, -10], 4, 90], [[0, 0], 4, 90], [[0, 10], 4, 90], [[5, 0], 10, 0]], 15];};
	if (_symbol == "A") exitWith {_return = [[[[-5, -0.5], 10.5, 0], [[0, 0], 4, 90], [[0, 10], 4, 90], [[5, -0.5], 10.5, 0]], 15];};
	if (_symbol == "B") exitWith {_return = [[[[-5, 0], 11, 0], [[0, -10], 4, 90], [[0, 10], 4, 90], [[0.5, 0], 4.5, 90], [[5, -5.5], 4.5, 0], [[5, 5.5], 4.5, 0]], 15];};
	if (_symbol == "C") exitWith {_return = [[[[-5, 0], 10, 0], [[0, -10], 4, 90], [[0, 10], 4, 90], [[5, -8], 2, 0], [[5, 8], 2, 0]], 15];};
	if (_symbol == "D") exitWith {_return = [[[[-5, 0], 11, 0], [[0, -10], 4, 90], [[0, 10], 4, 90], [[5, 0], 10, 0]], 15];};
	if (_symbol == "E") exitWith {_return = [[[[-5, 0], 11, 0], [[-1, 0], 3, 90], [[1, -10], 5, 90], [[1, 10], 5, 90]], 15];};
	if (_symbol == "F") exitWith {_return = [[[[-5, 0], 11, 0], [[-1, 0], 3, 90], [[1, 10], 5, 90]], 15];};
	if (_symbol == "G") exitWith {_return = [[[[-5, 0], 10, 0], [[0, -10], 4, 90], [[0, 10], 4, 90], [[2, 0], 2, 90], [[5, -4.5], 5.5, 0], [[5, 8], 2, 0]], 15];};
	if (_symbol == "H") exitWith {_return = [[[[-5, 0], 11, 0], [[0, 0], 4, 90], [[5, 0], 11, 0]], 15];};
	if (_symbol == "I") exitWith {_return = [[[[-5, 0], 11, 0]], 5];};
	if (_symbol == "J") exitWith {_return = [[[[-5, -8], 2, 0], [[0, -10], 4, 90], [[5, 0.5], 10.5, 0]], 15];};
	if (_symbol == "K") exitWith {_return = [[[[-5, 0], 11, 0], [[-1.5, 0], 2.5, 90], [[1, -3], 2, 0], [[1, 3], 2, 0], [[3, -6], 2, 0], [[3, 6], 2, 0], [[5, -9], 2, 0], [[5, 9], 2, 0]], 15];};
	if (_symbol == "L") exitWith {_return = [[[[-5, 0], 11, 0], [[0, -10], 4, 90]], 13];};
	if (_symbol == "M") exitWith {_return = [[[[-5, 0], 11, 0], [[-3, 10], 1, 0], [[-2, 7], 2, 0], [[0, 4], 2, 0], [[2, 7], 2, 0], [[3, 10], 1, 0], [[5, 0], 11, 0]], 15];};
	if (_symbol == "N") exitWith {_return = [[[[-5, 0], 11, 0], [[-3, 10], 1, 0], [[-2, 6], 3, 0], [[0, 0], 4, 0], [[2, -6], 3, 0], [[3, -10], 1, 0], [[5, 0], 11, 0]], 15];};
	if (_symbol == "O") exitWith {_return = [[[[-5, 0], 10, 0], [[0, -10], 4, 90], [[0, 10], 4, 90], [[5, 0], 10, 0]], 15];};
	if (_symbol == "P") exitWith {_return = [[[[-5, 0], 11, 0], [[0, 0], 4, 90], [[0, 10], 4, 90], [[5, 5], 5, 0]], 15];};
	if (_symbol == "Q") exitWith {_return = [[[[-5, 0], 10, 0], [[0, -10], 4, 90], [[0, 10], 4, 90], [[2, -8], 1, 0], [[3, -12], 1, 0], [[5, 0], 10, 0]], 15];};
	if (_symbol == "R") exitWith {_return = [[[[-5, 0], 11, 0], [[0, 0], 4, 90], [[0, 10], 4, 90], [[1, -3], 2, 0], [[3, -6], 2, 0], [[5, -9], 2, 0], [[5, 5], 5, 0]], 15];};
	if (_symbol == "S") exitWith {_return = [[[[-5, -8], 2, 0], [[-5, 5], 5, 0], [[0, -10], 4, 90], [[0, 0], 4, 90], [[0, 10], 4, 90], [[5, -5], 5, 0], [[5, 8], 2, 0]], 15];};
	if (_symbol == "T") exitWith {_return = [[[[0, -1], 10, 0], [[0, 10], 6, 90]], 15];};
	if (_symbol == "U") exitWith {_return = [[[[-5, 1], 10, 0], [[0, -10], 5, 90], [[5, 1], 10, 0]], 15];};
	if (_symbol == "V") exitWith {_return = [[[[-5, 7], 4, 0], [[-4, 1], 2, 0], [[-3, -3], 2, 0], [[-2, -7], 2, 0], [[-0.5, -10], 1.5, 90], [[1, -7], 2, 0], [[2, -3], 2, 0], [[3, 1], 2, 0], [[4, 7], 4, 0]], 14];};
	if (_symbol == "W") exitWith {_return = [[[[-5, 6], 5, 0], [[-4, -4], 5, 0], [[-2.5, -10], 1.5, 90], [[0, -8], 2, 90], [[0, -5], 2, 0], [[2.5, -10], 1.5, 90], [[4, -4], 5, 0], [[5, 6], 5, 0]], 15];};
	if (_symbol == "X") exitWith {_return = [[[[-5, -8], 3, 0], [[-5, 8], 3, 0], [[-4, -3], 2, 0], [[-4, 3], 2, 0], [[-1.5, 0], 2.5, 90], [[1, -3], 2, 0], [[1, 3], 2, 0], [[2, -8], 3, 0], [[2, 8], 3, 0]], 12];};
	if (_symbol == "Y") exitWith {_return = [[[[-5, 9.5], 1.5, 0], [[-4, 6.5], 1.5, 0], [[-3, 3.5], 1.5, 0], [[-2, 1], 1, 0], [[0, -6.5], 4.5, 0], [[0, -1], 2, 90], [[2, 1], 1, 0], [[3, 3.5], 1.5, 0], [[4, 6.5], 1.5, 0], [[5, 9.5], 1.5, 0]], 15];};
	if (_symbol == "Z") exitWith {_return = [[[[-4, -8], 1, 0], [[-3, -6], 1, 0], [[-2, -4], 1, 0], [[-1, -2], 1, 0], [[0, -10], 6, 90], [[0, 0], 1, 0], [[0, 10], 6, 90], [[1, 2], 1, 0], [[2, 4], 1, 0], [[3, 6], 1, 0], [[4, 8], 1, 0]], 15];};
	if (_symbol == " ") exitWith {_return = [[], 15];};
	if (_symbol == ".") exitWith {_return = [[[[-5, -10], 1, 0]], 5];};
	if (_symbol == ",") exitWith {_return = [[[[-5, -11], 2, 0]], 5];};
	if (_symbol == "!") exitWith {_return = [[[[-5, -10], 1, 0], [[-5, 2], 9, 0]], 5];};
	if (_symbol == "?") exitWith {_return = [[[[-5, 8], 2, 0], [[0, -10], 1, 0], [[0, -3.5], 3.5, 0], [[0, 10], 4, 90], [[2.5, 0], 1.5, 90], [[5, 5], 5, 0]], 15];};
	if (_symbol == "-") exitWith {_return = [[[[-4, 0], 3, 90]], 7];};
	if (_symbol == "'") exitWith {_return = [[[[-5, 10], 3, 0]], 5];};
	_return = [[], 0];
};
_return