class CfgFlagHacking
{
	enableHacking = 1;
	failChance = 25;
	hackDuration = 10;
	maxHackAttempts = 3;
	minPlayers = 30;
	maxHacks = 3;
	removeChance = 5;
	showMapIcon = 1;
	notifyServer = 1;
	notificationCooldown = 5;
}; 

class CfgExileDelayedActions
{
	class Abstract
	{
		duration=10;
		abortInCombatMode=1;
		durationFunction="";
		animation="";
		animationType="switchMove";
		failChance=0;
		conditionFunction="";
		completedFunction="";
		abortedFunction="";
		failedFunction="";
		repeatingCheckFunction="";
	};
	class HackFlag: Abstract
	{
		animationType="switchMove";
		animation="Acts_TerminalOpen";
		abortInCombatMode=0;
		failChanceFunction="ExileClient_action_hackFlag_failChance";
		durationFunction="ExileClient_action_hackFlag_duration";
		conditionFunction="ExileClient_action_hackFlag_condition";
		completedFunction="ExileClient_action_hackFlag_completed";
		failedFunction="ExileClient_action_hackFlag_failed";
		abortedFunction="ExileClient_action_hackFlag_aborted";
	};
};
 
class CfgNetworkMessages
{
	class hackFlagRequest
	{
		module="object_flag";
		parameters[]=
		{
			"STRING"
		};
	};
	class updateFlagHackAttemptRequest
	{
		module="object_flag";
		parameters[]=
		{
			"STRING"
		};
	};
	class startFlagHackRequest
	{
		module="object_flag";
		parameters[]=
		{
			"STRING"
		};
	};
};



//**************

class CfgExileCustomCode 
{
	/*
		You can overwrite every single file of our code without touching it.
		To do that, add the function name you want to overwrite plus the 
		path to your custom file here. If you wonder how this works, have a
		look at our bootstrap/fn_preInit.sqf function.

		Simply add the following scheme here:

		<Function Name of Exile> = "<New File Name>";

		Example:

		ExileClient_util_fusRoDah = "myaddon\myfunction.sqf";
	*/
	ExileClient_action_execute = "customcode\client\ExileClient_action_execute.sqf";
};


//**************


	class Flag
	{
		targetType = 2;
		target = "Exile_Construction_Flag_Static";

		class Actions
		{
			/*
			class Manage : ExileAbstractAction
			{
				title = "Manage";
				condition = "true";
				action = "_this call ExileClient_gui_baseManagement_event_show";
			};
			*/
			class HackFlag: ExileAbstractAction
			{
				title = "Hack Flag";
				condition = "(getNumber(missionConfigFile >> 'CfgFlagHacking' >> 'enableHacking') isEqualTo 1) && ('Exile_Item_Laptop' in (magazines player)) && !ExilePlayerInSafezone";
				action = "['HackFlag', _this select 0] call ExileClient_action_execute";
			};
			class StealFlag: ExileAbstractAction
			{
				title = "Steal Flag";
				condition = "((ExileClientInteractionObject getvariable ['ExileFlagStolen',1]) isEqualTo 0)";
				action = "['StealFlag', _this select 0] call ExileClient_action_execute";
			};
			
			class RestoreFlag: ExileAbstractAction
			{
				title = "Restore Flag";
				condition = "((ExileClientInteractionObject getvariable ['ExileFlagStolen',0]) isEqualTo 1)";
				action = "['restoreFlagRequest', [netID ExileClientInteractionObject]] call ExileClient_system_network_send";
			};
		};
	};