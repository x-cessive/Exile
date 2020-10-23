#define ENABLE_ALL false //enable it for all vehicles, ignore all the other options except blacklist
#define BLACKLIST [] //vehicle classes to be blacklisted using isKindOf (blacklist subclasses)

#define ALLOWED ["Plane","Tank","Helicopter","Wheeled_APC"] //vehicles to be included if enable all is set to false

//if there is a vehicle in both Blacklist and allowed, it will be blacklisted since blacklist is checked last
