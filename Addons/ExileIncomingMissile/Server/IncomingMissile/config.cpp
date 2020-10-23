class CfgPatches {
    class IncomingMissile {
        requiredVersion = 0.1;
        requiredAddons[] = {
            "exile_server"
        };
        units[] = {};
        weapons[] = {};
    };
};
class CfgFunctions {
    class IncomingMissile {
        class main {
            file="IncomingMissile\bootstrap";
            class preInit {
                preInit = 1;
            };
            class postInit {
                postInit = 1;
            };
        };
    };
};
