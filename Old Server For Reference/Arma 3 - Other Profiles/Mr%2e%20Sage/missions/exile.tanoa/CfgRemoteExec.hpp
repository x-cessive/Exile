class CfgRemoteExec
{
	class Functions
	{
		mode = 1;
		jip = 0;
		class fnc_AdminReq { allowedTargets=2; };
		class ExileServer_system_network_dispatchIncomingMessage { allowedTargets=2; };
		class SA_Simulate_Towing 			{ allowedTargets=0; }; 
		class SA_Attach_Tow_Ropes 			{ allowedTargets=0; }; 
		class SA_Take_Tow_Ropes 			{ allowedTargets=0; }; 
		class SA_Put_Away_Tow_Ropes 			{ allowedTargets=0; }; 
		class SA_Pickup_Tow_Ropes 			{ allowedTargets=0; }; 
		class SA_Drop_Tow_Ropes  			{ allowedTargets=0; }; 
		class SA_Set_Owner 				{ allowedTargets=2; }; 
		class SA_Hint  				{ allowedTargets=1; }; 
		class SA_Hide_Object_Global  			{ allowedTargets=2; };
	};
	class Commands
	{
		mode=0;
		jip=0;
	};
};