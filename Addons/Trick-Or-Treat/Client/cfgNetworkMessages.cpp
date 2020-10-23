class CfgNetworkMessages
{	
	// Trick or Treat
	class getFlagKnocked
	{
		module = "gaddTT";
		parameters[] =
		{
			"STRING",
			"STRING"
		};
	};
	class trickOrTreatResponse
	{
		module = "gadd";
		parameters[] =
		{
			"STRING"
		};
	};
};