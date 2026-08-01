/*
    Emits every configName under the listed config roots to the RPT, tagged
    [CLASSDUMP] so it can be extracted mechanically.

    diag_log truncates a line at ~1024 characters, so batches are flushed by
    STRING LENGTH, not by element count. Batching 200 names per line silently
    dropped ~68% of the dump before this was caught by comparing the emitted
    rows against the count= value logged with each BEGIN. Keep that check.
*/

#define CHUNK_LIMIT 850

// Collect class names under a config path, optionally one level deeper. CfgFaces
// nests its faces under a category class (Man_A3 etc), so a flat pass misses them.
private _collect =
{
    params ["_path", "_deep"];

    private _cfg = configFile;
    { _cfg = _cfg >> _x } forEach _path;

    private _direct = ("true" configClasses _cfg) apply { configName _x };
    if (!_deep) exitWith { _direct };

    private _out = +_direct;
    {
        private _child = _cfg >> _x;
        {
            _out pushBackUnique (configName _x);
        } forEach ("true" configClasses _child);
    } forEach _direct;
    _out
};

private _dumpRoot =
{
    params ["_spec"];
    _spec params ["_path", ["_deep", false]];

    private _rootName = _path joinString "_";
    private _classes = [_path, _deep] call _collect;
    diag_log format ["[CLASSDUMP] BEGIN %1 count=%2", _rootName, count _classes];

    private _chunk = [];
    private _chunkLen = 0;
    private _emitted = 0;

    {
        _chunk pushBack _x;
        _chunkLen = _chunkLen + (count _x) + 1;

        if (_chunkLen >= CHUNK_LIMIT) then
        {
            diag_log format ["[CLASSDUMP] %1 %2", _rootName, _chunk joinString ","];
            _emitted = _emitted + (count _chunk);
            _chunk = [];
            _chunkLen = 0;
        };
    } forEach _classes;

    if (count _chunk > 0) then
    {
        diag_log format ["[CLASSDUMP] %1 %2", _rootName, _chunk joinString ","];
        _emitted = _emitted + (count _chunk);
    };

    // Self-check: emitted must equal the count reported at BEGIN.
    diag_log format ["[CLASSDUMP] END %1 emitted=%2 expected=%3 ok=%4",
        _rootName, _emitted, count _classes, _emitted isEqualTo (count _classes)];
};

diag_log "[CLASSDUMP] ---- start ----";

{
    [_x] call _dumpRoot;
} forEach [
    [["CfgVehicles"]],
    [["CfgWeapons"]],
    [["CfgMagazines"]],
    [["CfgGlasses"]],
    [["CfgAmmo"]],
    [["CfgFaces"], true],              // faces nest under a category class
    [["CfgMarkers"]],
    [["CfgMarkerColors"]],
    [["CfgVoice"]],
    [["CfgVehicleClasses"]],
    [["CfgMovesMaleSdr", "States"]],   // animation states
    [["CfgMovesBasic", "Default"]]
];

diag_log "[CLASSDUMP] COMPLETE";
