/**
 * Created with Exile Mod 3DEN Plugin
 * www.exilemod.com
 */

ExileRouletteChairs = [];
ExileRouletteChairPositions = [];

// 77 Vehicles
private _vehicles = [
["Land_BackAlley_01_l_gate_F", [11387.7, 5298.31, 8.19221], [0.161486, -0.986732, -0.0167916], [-0.00715956, -0.0181859, 0.999809], true],
["Land_ConcreteWall_01_l_gate_F", [11381.5, 5300.8, 7.47496], [0.140994, -0.989831, -0.0188491], [-0.0047272, -0.0197122, 0.999795], true],
["Land_IndFnc_3_F", [11386.1, 5299.55, 7.2429], [0.996111, 0.0871574, -0.0128766], [0.0154282, -0.0286657, 0.99947], true],
["Land_BagFence_01_end_green_F", [11389.4, 5299.03, 6.87935], [-0.838663, 0.538546, 0.0813198], [0.0981895, 0.00263923, 0.995164], true],
["Land_BagFence_01_end_green_F", [11389.9, 5299.07, 6.83401], [0.754321, -0.652468, -0.072696], [0.0981895, 0.00263923, 0.995164], true],
["Land_BagFence_01_end_green_F", [11390, 5299.93, 6.82424], [0.684269, -0.726274, -0.0655884], [0.0981895, 0.00263923, 0.995164], true],
["Land_BagFence_End_F", [11390.5, 5299.69, 6.77761], [-0.979272, 0.178272, 0.0961487], [0.0981895, 0.00263923, 0.995164], true],
["Land_BackAlley_01_l_gate_F", [11305.6, 5896.21, 22.2165], [-0.210023, 0.977552, -0.0167867], [0.00624826, 0.0185113, 0.999809], true],
["Land_ConcreteWall_01_l_gate_F", [11312, 5894.03, 21.6781], [-0.189707, 0.98166, -0.0188459], [0.00374442, 0.0199176, 0.999795], true],
["Land_IndFnc_3_F", [11307.3, 5895.06, 21.4035], [-0.990591, -0.136249, -0.0128723], [-0.0168205, 0.0278661, 0.99947], true],
["Land_BagFence_01_end_green_F", [11304, 5895.4, 21.1899], [0.868237, -0.492264, 0.0619805], [0.0026744, 0.129564, 0.991567], true],
["Land_BagFence_01_end_green_F", [11303.5, 5895.34, 21.2085], [-0.7892, 0.60923, -0.0774771], [0.0026744, 0.129564, 0.991567], true],
["Land_BagFence_01_end_green_F", [11303.4, 5894.48, 21.2797], [-0.72253, 0.691337, 0.00191615], [0.00265199, 0, 0.999996], true],
["Land_BagFence_End_F", [11303, 5894.69, 21.1678], [0.993132, -0.116971, -0.00263379], [0.00265199, 0, 0.999996], true],
["Land_Cargo_Tower_V3_F", [11337.7, 5747.41, 34.9604], [-0.113255, 0.993566, 0], [0, 0, 1], true],
["Land_Cargo_Tower_V3_F", [11348.4, 5510.92, 34.949], [0.103664, -0.994612, 0], [0, 0, 1], true],
["Land_AirstripPlatform_01_F", [11340.7, 5750.81, 9.76139], [0.991669, 0.12881, 0], [0, 0, 1], true],
["Land_AirstripPlatform_01_F", [11344, 5513.27, 9.74993], [0.991669, 0.12881, 0], [0, 0, 1], true],
["Land_PierWooden_02_barrel_F", [11308.2, 5828.42, -17.4379], [-0.126265, 0.991996, 0], [0, 0, 1], true],
["Land_PierWooden_01_16m_F", [11309.5, 5816.37, -17.1057], [-0.0882452, 0.996099, 0], [0, 0, 1], true],
["Land_PierWooden_01_16m_F", [11310.9, 5800.47, -17.1247], [-0.0882452, 0.996099, 0], [0, 0, 1], true],
["Land_PierWooden_01_16m_F", [11307.9, 5786.4, -17.13], [0.501137, 0.865368, 0], [0, 0, 1], true],
["Land_PierWooden_01_dock_F", [11304.3, 5770.15, -15.4441], [-0.468237, -0.883603, 0], [0, 0, 1], true],
["Land_PierWooden_01_platform_F", [11295.9, 5764.37, -17.1065], [-0.444467, -0.895795, 0], [0, 0, 1], true],
["Land_PierWooden_01_platform_F", [11327.1, 5763.94, -17.1271], [0.859866, -0.51052, 0], [0, 0, 1], true],
["Land_PierWooden_01_16m_F", [11319.3, 5768.61, -17.1241], [-0.857809, 0.513968, 0], [0, 0, 1], true],
["Land_PierWooden_02_barrel_F", [11360.9, 5425.95, -17.5118], [0.699273, -0.714854, 0], [0, 0, 1], true],
["Land_PierWooden_01_16m_F", [11352.7, 5434.68, -17.1481], [0.67143, -0.741068, 0], [0, 0, 1], true],
["Land_PierWooden_01_16m_F", [11341.9, 5446.49, -17.1079], [0.67143, -0.741068, 0], [0, 0, 1], true],
["Land_PierWooden_01_16m_F", [11335.9, 5459.54, -17.1294], [0.122556, -0.992462, 0], [0, 0, 1], true],
["Land_PierWooden_01_dock_F", [11328.9, 5474.66, -15.4551], [-0.159794, 0.98715, 0], [0, 0, 1], true],
["Land_PierWooden_01_platform_F", [11332.2, 5484.35, -17.1425], [-0.186106, 0.98253, 0], [0, 0, 1], true],
["Land_PierWooden_01_platform_F", [11307, 5465.86, -17.0916], [-0.993736, -0.111753, 0], [0, 0, 1], true],
["Land_PierWooden_01_16m_F", [11316, 5466.83, -17.1094], [0.994177, 0.107763, 0], [0, 0, 1], true],
["Land_Bulldozer_01_wreck_F", [11311.8, 5855.47, 23.4391], [0, 1, 0], [0, 0, 1], true],
["Land_Wreck_HMMWV_F", [11322.8, 5815.73, 22.8381], [-0.993389, -0.114797, 0], [0, 0, 1], true],
["MetalBarrel_burning_F", [11332.3, 5754.13, 22.4227], [0, 1, 0], [0, 0, 1], true],
["MetalBarrel_burning_F", [11335.7, 5747.11, 40.3864], [0, 1, 0], [0, 0, 1], true],
["MetalBarrel_burning_F", [11304.1, 5893.63, 21.5916], [0, 0.99662, -0.0821454], [-0.0101074, 0.0821412, 0.996569], true],
["MetalBarrel_burning_F", [11342, 5754.72, 22.4969], [0, 1, 0], [0, 0, 1], true],
["MetalBarrel_burning_F", [11332.5, 5745.06, 22.4227], [0, 1, 0], [0, 0, 1], true],
["MetalBarrel_burning_F", [11351.4, 5520.41, 22.423], [0, 1, 0], [0, 0, 1], true],
["MetalBarrel_burning_F", [11389.7, 5300.65, 7.23205], [0, 0.999696, 0.0246646], [0.00302964, -0.0246645, 0.999691], true],
["MetalBarrel_burning_F", [11352.4, 5517.16, 22.4227], [0, 1, 0], [0, 0, 1], true],
["Land_Wreck_Plane_Transport_01_F", [11290.6, 5906.22, 19.1084], [-0.0130486, -0.998554, 0.0521421], [-0.0850248, 0.0530657, 0.994965], true],
["Land_Wreck_CarDismantled_F", [11351.5, 5524.84, 22.8844], [0, 1, 0], [0, 0, 1], true],
["Land_MiningShovel_01_abandoned_F", [11324.6, 5436.11, 5.63404], [0.919248, 0.391771, -0.03872], [0.00800059, 0.0797428, 0.996783], true],
["Land_Wreck_Offroad_F", [11369.4, 5383.02, 14.2189], [0.814553, -0.576982, -0.0599644], [0.0108577, -0.0881882, 0.996045], true],
["Land_HistoricalPlaneDebris_03_F", [11304.9, 5911.82, 20.3826], [0, 1, 0.000488106], [-0.0396213, -0.000487723, 0.999215], true],
["Land_HistoricalPlaneDebris_02_F", [11304.5, 5921.01, 19.8534], [0, 0.998974, -0.0452881], [-0.0399685, 0.045252, 0.998176], true],
["Land_HistoricalPlaneDebris_01_F", [11304.9, 5911.85, 20.0557], [0, 0.999712, -0.0239937], [-0.061218, 0.0239487, 0.997837], true],
["Land_HistoricalPlaneWreck_02_front_F", [11202.7, 5847.32, 6.53629], [0, 0.904326, 0.426842], [0.108686, -0.424313, 0.898969], true],
["Land_HistoricalPlaneWreck_02_wing_left_F", [11301.7, 5908.25, 20.1886], [0, 0.99885, -0.0479448], [-0.0585655, 0.0478625, 0.997136], true],
["Land_Garbage_square3_F", [11322.6, 5830.96, 22.0519], [0, 1, 0], [0, 0, 1], true],
["Land_Garbage_square5_F", [11322.4, 5819.66, 22.0394], [0, 1, 0], [0, 0, 1], true],
["Land_GarbageBags_F", [11310.7, 5860.39, 22.4336], [0, 1, 0], [0, 0, 1], true],
["Land_Garbage_line_F", [11323.6, 5824.5, 22.0502], [-0.0119353, 0.999929, 0], [0, 0, 1], true],
["Land_GarbagePallet_F", [11338.9, 5750.21, 22.3305], [0, 1, 0], [0, 0, 1], true],
["Land_GarbageWashingMachine_F", [11329.1, 5699.72, 22.4516], [0, 1, 0], [0, 0, 1], true],
["Land_GarbageHeap_01_F", [11313.8, 5891.92, 21.4261], [0.999733, 0.0215378, 0.00836426], [-0.0101074, 0.0821412, 0.996569], true],
["Land_GarbageHeap_02_F", [11329.1, 5708.57, 22.1141], [-0.0119357, 0.999929, 0], [0, 0, 1], true],
["Land_GarbageHeap_03_F", [11323.8, 5825.97, 22.5271], [0.796611, -0.604493, 0], [0, 0, 1], true],
["Land_GarbageHeap_04_F", [11313.4, 5829.58, 22.5123], [0, 1, 0], [0, 0, 1], true],
["Land_GarbageContainer_open_F", [11380.1, 5302.5, 7.36627], [0.584674, 0.811063, 0.0182387], [0.00302964, -0.0246645, 0.999691], true],
["Land_GarbageContainer_open_F", [11315.8, 5889.28, 21.9161], [-0.998901, -0.0460843, -0.00857035], [-0.0117895, 0.070043, 0.997474], true],
["Land_Garbage_line_F", [11323.6, 5787.07, 22.0502], [-0.0119353, 0.999929, 0], [0, 0, 1], true],
["Land_Garbage_line_F", [11330.5, 5759.49, 22.0502], [0.943794, 0.330534, 0], [0, 0, 1], true],
["Land_Garbage_line_F", [11339.4, 5664.76, 22.0502], [-0.0119353, 0.999929, 0], [0, 0, 1], true],
["Land_Cargo40_blue_F", [11318.3, 5915.47, 21.1342], [-0.999562, 0.0231763, 0.0184116], [0.0186626, 0.0106622, 0.999769], true],
["Land_Cargo40_brick_red_F", [11313.1, 5844.8, 2.96762], [-0.825226, -0.564787, 0.00425949], [0.0667902, -0.0900948, 0.993691], true],
["Land_Cargo10_orange_F", [11299.4, 5828.31, 0.528837], [0, 0.992237, 0.12436], [-0.223531, -0.121213, 0.96713], true],
["MetalBarrel_burning_F", [11325.1, 5810.05, 22.4227], [0, 1, 0], [0, 0, 1], true],
["MetalBarrel_burning_F", [11334, 5743.45, 35.2615], [0, 1, 0], [0, 0, 1], true],
["MetalBarrel_burning_F", [11353.7, 5508.87, 35.2501], [0, 1, 0], [0, 0, 1], true],
["MetalBarrel_burning_F", [11351, 5512.58, 40.3749], [0, 1, 0], [0, 0, 1], true],
["Land_PortableHelipadLight_01_F", [11348.9, 5509.39, 42.6629], [0, 1, 0], [0, 0, 1], true],
["PortableHelipadLight_01_green_F", [11337.4, 5749.13, 42.6741], [0, 1, 0], [0, 0, 1], true]
];

{
    private _vehicle = (_x select 0) createVehicle (_x select 1);
    _vehicle allowDamage false;
    _vehicle setPosWorld (_x select 1);
    _vehicle setVectorDirAndUp [_x select 2, _x select 3];
    _vehicle enableSimulationGlobal (_x select 4);
    _vehicle setVariable ["ExileIsLocked", -1, true];
    
    if (_vehicle isKindOf "Exile_RussianRouletteChair") then
    {
        ExileRouletteChairs pushBack _vehicle;
        ExileRouletteChairPositions pushBack [_x select 1, getDir _vehicle];
    };
}
forEach _vehicles;

// 2 Simple Objects
private _invisibleSelections = ["zasleh", "zasleh2", "box_nato_grenades_sign_f", "box_nato_ammoord_sign_f", "box_nato_support_sign_f"];
private _simpleObjects = [
["a3\structures_f_epb\civ\garbage\garbagecontainer_closed_f.p3d", [11378, 5302.81, 7.42361], [0.999982, 0.00516859, -0.00290301], [0.00302964, -0.0246645, 0.999691]],
["a3\structures_f_epb\civ\garbage\garbagecontainer_closed_f.p3d", [11316.1, 5892.49, 21.7294], [0.982662, 0.18533, -0.0053093], [-0.0101074, 0.0821412, 0.996569]]
];

{
    private _simpleObject = createSimpleObject [_x select 0, _x select 1];
    _simpleObject setVectorDirAndUp [_x select 2, _x select 3];
    
    {
        if ((toLower _x) in _invisibleSelections) then 
        {
            _simpleObject hideSelection [_x, true];
        };
    }
    forEach (selectionNames _simpleObject);
}
forEach _simpleObjects;