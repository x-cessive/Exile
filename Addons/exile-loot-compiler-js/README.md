# exile-loot-compiler-js
A node script to compile exile loot tables, this version allows you com nest "groups/tables" as much as you like allowing for more control over loot tables.
All .h files -> CfgLootTables.hpp

To use it, install [NodeJS](https://nodejs.org/en/).
Then run install.bat and then compile.bat to generate a CfgLootTables.hpp

```
> CivillianLowerClass
// loot.h
30, Drinks
28, Food
14, Exile_Item_Beer
17, Exile_Item_EnergyDrink

> Food
3, Exile_Item_CookingPot
5, Exile_Item_CanOpener

> Drinks
7, Exile_Item_PowerDrink
12, Exile_Item_PlasticBottleFreshWater

```
Compiles into
```
/*
Loot Groups
CivillianLowerClass
Food
Drinks
*/
class CfgLootTables {
	class CivillianLowerClass {
		count = 6;
		half = 6005.32;
		halfIndex = 2;
		sum = 10000;
		items[] = 
		{
			{2128.92, "Exile_Item_PlasticBottleFreshWater"},// 21.2892%
			{4095.21, "Exile_Item_CanOpener"},// 19.6629%
			{6005.32, "Exile_Item_EnergyDrink"},// 19.1011%
			{7578.36, "Exile_Item_Beer"},// 15.7303%
			{8820.22, "Exile_Item_PowerDrink"},// 12.4187%
			{10000, "Exile_Item_CookingPot"}// 11.7978% 
		};
	};
	class Food {
		count = 2;
		half = 6250;
		halfIndex = 0;
		sum = 10000;
		items[] = 
		{
			{6250, "Exile_Item_CanOpener"},// 62.5%
			{10000, "Exile_Item_CookingPot"}// 37.5% 
		};
	};
	class Drinks {
		count = 2;
		half = 6315.79;
		halfIndex = 0;
		sum = 10000;
		items[] = 
		{
			{6315.79, "Exile_Item_PlasticBottleFreshWater"},// 63.1579%
			{10000, "Exile_Item_PowerDrink"}// 36.8421% 
		};
	};
};
```