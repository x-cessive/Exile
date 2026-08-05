private["_hasAPSI","_x"];
_hasAPSI = 0;
if(ns_blow_itemtype == 1)then
{ 
	if ((headgear player) in ns_blow_itemapsi)then
	{
		_hasAPSI = true;
	}
	else
	{
		_hasAPSI = false;
	};
};
if(ns_blow_itemtype == 2)then
{ 
	if ((vest player) in ns_blow_itemapsi)then
	{
		_hasAPSI = true;
	}
	else
	{
		_hasAPSI = false;
	};
};
if(ns_blow_itemtype == 3)then
{ 
	{
		if (_x in ns_blow_itemapsi)then
		{
			_hasAPSI = true;
		}
		else
		{
			_hasAPSI = false;
		};
	} foreach (magazines player);
};
if(ns_blow_itemtype == 4)then
{ 
	if ((goggles player) in ns_blow_itemapsi)then
	{
		_hasAPSI = true;
	}
	else
	{
		_hasAPSI = false;
	};
};
if(ns_blow_itemtype == 5)then
{ 
	if ((uniform player) in ns_blow_itemapsi)then
	{
		_hasAPSI = true;
	}
	else
	{
		_hasAPSI = false;
	};
};
_hasAPSI