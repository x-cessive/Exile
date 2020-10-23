class CfgBarter
{
	#include "custom\barter\CfgBarter.cpp"
};

class CfgNetworkMessages
{
	//barter
	class tradeItemsRequest 
	{
		module="system_barter";
		parameters[]=
		{
			"ARRAY",
			"ARRAY",
			"ARRAY",
			"ARRAY",
			"SCALAR"
		};
	};
	
	class tradeItemsResponse 
	{
		module="system_barter";
		parameters[]=
		{
			"SCALAR",
			"ARRAY",
			"ARRAY"
		};
	};
	
	class withdrawTradeItemRequest
	{
		module="system_barter";
		parameters[]=
		{
			"STRING",
			"SCALAR",
			"STRING",
			"ARRAY"
		};
	};
	
	class withdrawTradeItemResponse
	{
		module="system_barter";
		parameters[]=
		{
			"SCALAR",
			"STRING",
			"SCALAR",
			"STRING",
			"ARRAY"
		};
	};
};