class CfgPatches {
	class TKO_Objects {
		units[] = {};
		weapons[] = {};
		requiredVersion = 0.1;
		requiredAddons[] = {};
	};
};

class CfgFunctions {
	class A3C {
		class TKO_Objects {
			file = "TKO_Objects\init";
			class init {
				postInit = 1;
			};
		};
	};
};