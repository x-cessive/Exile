// GADD Trick or Treat
#include "GADD_Apps\TrickOrTreat\config.cpp"

class CfgInteractionMenus
{
	class Construction
	{
		targetType = 2;
		target = "Exile_Construction_Abstract_Static";

		class Actions 
		{
			// GADD Trick or Treat
			class TrickOrTreat: ExileAbstractAction
			{
				title = "<t color='#fc9403'>Trick or Treat?";
				condition = "((typeOf ExileClientInteractionObject == 'Exile_Construction_ConcreteGate_Static') || (typeOf ExileClientInteractionObject == 'Exile_Construction_ConcreteDoor_Static')) && ((systemTime select 1 == 10) && (systemTime select 2 == 31))";
				action = "_this call GADD_TrickOrTreat_Request";
			};
		};
	};
};