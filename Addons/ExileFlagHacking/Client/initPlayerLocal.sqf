
{
    _code = '';
    _function = _x select 0;
    _file = _x select 1;

    _code = compileFinal (preprocessFileLineNumbers _file);

    missionNamespace setVariable [_function, _code];
}
forEach
[
	['ExileClient_action_hackFlag_aborted','custom\FlagHacking\ExileClient_action_hackFlag_aborted.sqf'],
	['ExileClient_action_hackFlag_completed','custom\FlagHacking\ExileClient_action_hackFlag_completed.sqf'],
	['ExileClient_action_hackFlag_condition','custom\FlagHacking\ExileClient_action_hackFlag_condition.sqf'],
	['ExileClient_action_hackFlag_duration','custom\FlagHacking\ExileClient_action_hackFlag_duration.sqf'],
	['ExileClient_action_hackFlag_failChance','custom\FlagHacking\ExileClient_action_hackFlag_failChance.sqf'],
	['ExileClient_action_hackFlag_failed','custom\FlagHacking\ExileClient_action_hackFlag_failed.sqf']
];
