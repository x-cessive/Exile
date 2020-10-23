
class CfgInteractionMenus
{
	class Car 
	{
		targetType = 2;
		target = "Car";

		class Actions 
		{
			// Save Paint
			class ExileSavePaint: ExileAbstractAction
			{
				title = "Save Paint";
				condition = "((locked ExileClientInteractionObject) isEqualTo 0) && ((locked ExileClientInteractionObject) != 1)  && ExilePlayerInSafezone";
				action = "_this call NR_fnc_exileSavePaint";
			};
		};
	};
	
	class Tank 
	{
		targetType = 2;
		target = "Tank";

		class Actions 
		{
			// Save Paint
			class ExileSavePaint: ExileAbstractAction
			{
				title = "Save Paint";
				condition = "((locked ExileClientInteractionObject) isEqualTo 0) && ((locked ExileClientInteractionObject) != 1)  && ExilePlayerInSafezone";
				action = "_this call NR_fnc_exileSavePaint";
			};
		};
	};
	
	class Air
	{
		target = "Air";
		targetType = 2;

		class Actions
		{
			// Save Paint
			class ExileSavePaint: ExileAbstractAction
			{
				title = "Save Paint";
				condition = "((locked ExileClientInteractionObject) isEqualTo 0) && ((locked ExileClientInteractionObject) != 1)  && ExilePlayerInSafezone"; 
				//"((locked ExileClientInteractionObject) != 1) && ExilePlayerInSafezone"; // "true"
				action = "_this call NR_fnc_exileSavePaint";
			};
		};
	};
