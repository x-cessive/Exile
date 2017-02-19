/**
 * Created with Exile Mod 3DEN Plugin
 * www.exilemod.com
 * By Stefan, untriel.com
 */

ExileRouletteChairs = [];
ExileRouletteChairPositions = [];

// 23 Vehicles
private _vehicles = [
["Exile_Sign_Boat_Small", [5588.88, 10448.6, 1.14147], [0.826484, 0.56296, 0], [0, 0, 1], false],
["Exile_Sign_BoatCustoms_Small", [5587.42, 10450.8, 1.14147], [0.820117, 0.572195, 0], [0, 0, 1], false],
["Exile_Sign_WasteDump_Small", [5568.32, 10440.6, 3.36752], [-0.809182, -0.587559, 0], [0, 0, 1], false],
["Exile_Sign_Diving_Small", [5600.38, 10396.5, 1.48151], [-0.412004, -0.911182, 0], [0, 0, 1], false],
["Exile_Sign_Office", [5639.25, 10389, 3.2646], [-0.925608, 0.378484, 0], [0, 0, 1], false],
["Exile_Sign_Vehicles", [5657.11, 10401.3, 3.25105], [-0.91797, 0.396651, 0], [0, 0, 1], false],
["Exile_Sign_VehicleCustoms", [5658.01, 10403.3, 3.25105], [-0.920192, 0.391467, 0], [0, 0, 1], false],
["Exile_Sign_Hardware_Small", [5643.26, 10380.2, 1.65147], [-0.92968, 0.368368, 0], [0, 0, 1], false],
["Exile_Sign_Equipment_Small", [5641.86, 10376.9, 1.65147], [-0.924892, 0.380231, 0], [0, 0, 1], false],
["Exile_Sign_Armory_Small", [5640.67, 10374.1, 1.65147], [-0.925322, 0.379181, 0], [0, 0, 1], false],
["Exile_Sign_Food", [5638.18, 10386.4, 3.2646], [-0.925665, 0.378343, 0], [0, 0, 1], false],
["Exile_Locker", [5648.75, 10406.9, 2.2672], [0.381575, 0.924336, -0.00195283], [0.000771824, 0.00179406, 0.999998], true],
["Exile_Locker", [5650.49, 10406.2, 2.26665], [0.380175, 0.924913, -0.00194986], [0.000845734, 0.00176052, 0.999998], true],
["Exile_Locker", [5647.38, 10405.6, 2.27064], [-0.928551, 0.371206, 5.07128e-005], [0.000771824, 0.00179406, 0.999998], true],
["Exile_Sign_Locker", [5650.66, 10403.6, 2.95827], [-0.921414, 0.388582, 0], [0, 0, 1], false],
["Exile_Locker", [5650.4, 10404.3, 2.27072], [0.922953, -0.384913, -2.18017e-005], [0.000771824, 0.00179406, 0.999998], true],
["Exile_Sign_WasteDump", [5667.48, 10430.6, 3.25105], [0.415417, 0.909631, 0], [0, 0, 1], false],
["Exile_Sign_TraderCity", [5688.79, 10370, 4.7611], [-0.938029, 0.346556, 0], [0, 0, 1], false],
["Land_BarGate_F", [5688.86, 10379.7, 6.96963], [0.917859, -0.396908, 0], [0, 0, 1], true],
["Land_BarGate_F", [5677.21, 10427.9, 6.26028], [0.395834, 0.918322, 0], [0, 0, 1], true],
["Land_BarGate_F", [5641.7, 10349, 6.26028], [-0.387548, -0.92185, 0], [0, 0, 1], true],
["Land_WaterCooler_01_old_F", [5640.41, 10383.7, 2.95562], [-0.932284, 0.361727, 0], [0, 0, 1], false],
["Land_Shed_02_F", [5648.63, 10404.4, 3.11566], [0.422618, 0.906308, 0], [0, 0, 1], true]
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

// 90 Simple Objects
private _invisibleSelections = ["zasleh", "zasleh2", "box_nato_grenades_sign_f", "box_nato_ammoord_sign_f", "box_nato_support_sign_f"];
private _simpleObjects = [
["a3\boat_f_exp\scooter_transport_01\scooter_transport_01_f.p3d", [5582.31, 10449.6, 0.964795], [-0.813127, -0.582086, 0], [0, 0, 1]],
["a3\structures_f\wrecks\wreck_cardismantled_f.p3d", [5657.62, 10408, 3.09439], [-0.91341, 0.407041, 0], [0, 0, 1]],
["a3\structures_f\ind\cargo\cargo20_military_green_f.p3d", [5668.28, 10431.8, 3.53431], [0.39757, 0.917572, 0], [0, 0, 1]],
["a3\structures_f_epb\civ\garbage\garbagecontainer_closed_f.p3d", [5664.94, 10430.3, 2.99398], [0.903336, -0.428934, 0], [0, 0, 1]],
["a3\structures_f_heli\civ\constructions\tooltrolley_01_f.p3d", [5658.2, 10402, 2.70897], [-0.424576, -0.905392, 0], [0, 0, 1]],
["a3\supplies_f_heli\cargonets\cargonet_01_barrels_f.p3d", [5639.83, 10381.8, 2.78116], [0.925092, -0.379744, 0], [0, 0, 1]],
["a3\supplies_f_heli\cargonets\cargonet_01_ammo_f.p3d", [5638.71, 10379.6, 3.06355], [0.924025, -0.382331, 0], [0, 0, 1]],
["a3\supplies_f_heli\cargonets\cargonet_01_ammo_f.p3d", [5636.7, 10375.1, 3.06], [0.928407, -0.371566, 0], [0, 0, 1]],
["a3\supplies_f_heli\cargonets\cargonet_01_box_f.p3d", [5637.81, 10377.6, 2.87432], [0.908698, -0.417455, 0], [0, 0, 1]],
["a3\structures_f_epc\civ\accessories\lifeguardtower_01_f.p3d", [5634.68, 10352.8, 5.64632], [0, 1, 0], [0, 0, 1]],
["a3\structures_f_epc\civ\accessories\lifeguardtower_01_f.p3d", [5661.56, 10434.1, 5.5246], [-0.795344, -0.606159, 0], [0, 0, 1]],
["a3\boat_f\boat_transport_01\boat_transport_01_f.p3d", [5587.25, 10444.4, 0.85056], [-0.813865, -0.581053, 0], [0, 0, 1]],
["a3\boat_f_gamma\boat_civil_01\boat_civil_01_f.p3d", [5594.7, 10425, 0.688598], [-0.926824, 0.375497, 0], [0, 0, 1]],
["a3\props_f_exp\naval\boats\boat_03_abandoned_f.p3d", [5576.53, 10448, 3.48161], [-0.886746, 0.462257, 0], [0, 0, 1]],
["a3\weapons_f_exp\rifles\ak12\ak12_f.p3d", [5639.65, 10373.3, 3.171], [0, -4.37114e-008, -1], [-0.920505, 0.390731, -1.70794e-008]],
["a3\weapons_f_exp\rifles\arx\arx_f.p3d", [5639.89, 10373.1, 3.171], [6.45534e-008, 1.29656e-007, -1], [-0.937143, 0.348944, -1.52528e-008]],
["a3\weapons_f\pistols\rook40\rook40_f.p3d", [5639.89, 10372.7, 3.13992], [0, -4.37114e-008, -1], [-0.984808, 0.173648, -7.5904e-009]],
["a3\weapons_f_epa\pistols\pistol_heavy_01\pistol_heavy_01_f.p3d", [5640, 10372.9, 3.1312], [0, -4.37114e-008, -1], [-0.984808, 0.173648, -7.5904e-009]],
["a3\weapons_f\longrangerifles\gm6\gm6_f.p3d", [5640.95, 10375.4, 3.19], [0, -4.37114e-008, -1], [-0.929532, 0.368741, -1.61182e-008]],
["a3\weapons_f_exp\machineguns\lmg_03\lmg_03_f.p3d", [5640.65, 10375.5, 3.29655], [-0.919645, 0.392751, -6.89429e-006], [0.000655476, 0.00155238, 0.999999]],
["a3\weapons_f_mark\acc\acco_khs_hex_f.p3d", [5640.84, 10374.9, 3.17], [-4.328e-006, -9.66382e-006, -1], [0.912464, -0.409157, 4.87915e-009]],
["a3\structures_f_epb\items\military\magazine_rifle_f.p3d", [5640.26, 10374.7, 3.15824], [0.291355, 0.956615, -0.000376307], [0.00129158, 0, 0.999999]],
["a3\structures_f_epb\items\military\magazine_rifle_f.p3d", [5640.35, 10374.7, 3.16043], [0.356221, 0.934402, -0.000460087], [0.00129158, 0, 0.999999]],
["a3\weapons_f\longrangerifles\m320\m320_f.p3d", [5639.05, 10375.6, 2.68052], [-0.910091, 0.307641, -0.277652], [0.336813, 0.939456, -0.0630853]],
["a3\weapons_f\acc\accu_bipod_03_blk_f.p3d", [5640.62, 10374.6, 3.18], [0.53929, 0.84212, -4.97635e-006], [0.00108415, -0.000688378, 0.999999]],
["a3\weapons_f_exp\acc\acca_snds_65_ti_blk_f.p3d", [5640.49, 10374.7, 3.16977], [-0.934377, 0.356283, 0.00120682], [0.00129158, 0, 0.999999]],
["a3\weapons_f\acc\accv_flashlight_f.p3d", [5640.1, 10373.2, 3.11745], [0.955287, -0.295681, -3.3511e-006], [-0.000374713, -0.00122196, 0.999999]],
["a3\structures_f_epa\mil\scrapyard\pallet_milboxes_f.p3d", [5638.83, 10372.1, 2.67], [0.405954, 0.913894, 0], [0, 0, 1]],
["a3\structures_f_epb\items\military\ammobox_rounds_f.p3d", [5637.48, 10373.4, 3.24654], [0, 1, 0], [0, 0, 1]],
["a3\structures_f_epb\items\military\ammobox_rounds_f.p3d", [5637.4, 10373.1, 3.247], [0, 1, 0], [0, 0, 1]],
["a3\weapons_f\ammoboxes\wpnsbox_f.p3d", [5637.05, 10372.4, 3.29624], [-0.928705, 0.37082, 0], [0, 0, 1]],
["a3\weapons_f\ammoboxes\ammobox_f.p3d", [5637.76, 10374, 2.67], [0.342084, 0.939669, 0], [0, 0, 1]],
["a3\weapons_f\ammoboxes\wpnsbox_large_f.p3d", [5638.23, 10375.2, 3.30857], [-0.923873, 0.3827, 0], [0, 0, 1]],
["a3\supplies_f_exp\ammoboxes\uniforms_box_f.p3d", [5639.4, 10377.8, 3.52], [0.378727, 0.925508, 0], [0, 0, 1]],
["a3\weapons_f\ammoboxes\bags\backpack_tortila.p3d", [5639.77, 10378.8, 3.14911], [0.919529, -0.39302, -0.000948055], [0.000958745, -0.000169102, 1]],
["a3\weapons_f\ammoboxes\bags\backpack_bergen_f.p3d", [5639.95, 10379.4, 3.17026], [0.914164, -0.405345, 2.12007e-006], [-0.000392122, -0.000879113, 1]],
["a3\structures_f\items\electronics\laptop_unfolded_f.p3d", [5642.15, 10388.1, 3.33282], [-0.996814, 0.0797578, 0], [0, 0, 1]],
["a3\weapons_f\ammoboxes\bags\backpack_compact.p3d", [5640.31, 10379.9, 3.03554], [0.918581, -0.395232, -0.000896891], [0.000976388, 0, 1]],
["a3\characters_f\opfor\headgear_o_helmet_ballistic.p3d", [5641.22, 10376.2, 2.58695], [-0.900302, 0.160069, -0.404765], [-0.400698, 0.0583907, 0.914348]],
["a3\characters_f\blufor\headgear_b_helmet_light.p3d", [5641.29, 10376.6, 2.57446], [-0.953353, 0.104885, -0.283051], [-0.284451, 0.00166934, 0.958689]],
["a3\characters_f_exp\blufor\h_helmetb_ti_tna_f.p3d", [5641.54, 10376.3, 2.58151], [-0.906857, 0.150571, -0.393623], [-0.388308, 0.0644674, 0.919272]],
["a3\characters_f\blufor\equip_b_carrier_gl_rig.p3d", [5638.83, 10376.5, 3.34916], [0.000194624, 0.000480765, -1], [0.376099, 0.926579, 0.000518665]],
["a3\characters_f\opfor\equip_o_vest_gl.p3d", [5638.89, 10376.1, 2.35701], [-0.989275, 0.146068, 0], [0, 0, 1]],
["a3\characters_f_beta\indep\equip_ia_vest01.p3d", [5639.08, 10376.8, 2.32684], [-0.942241, 0.334934, 0], [0, 0, 1]],
["a3\characters_f\opfor\equip_o_vest01.p3d", [5639.27, 10377.3, 2.3752], [-0.924712, 0.380668, 0], [0, 0, 1]],
["a3\characters_f\common\suitpacks\suitpack_driver_f.p3d", [5641.74, 10378.3, 3.17067], [1.49777e-007, -1.03693e-007, -1], [0.371769, 0.928325, -4.05784e-008]],
["a3\characters_f\common\suitpacks\suitpack_original_f.p3d", [5641.6, 10377.9, 3.21], [2.773e-008, 1.8963e-008, -1], [-0.914489, 0.404611, -1.76861e-008]],
["a3\weapons_f\binocular\rangefinder_proxy.p3d", [5642.1, 10378.2, 3.17031], [0.905133, -0.425129, 3.25352e-006], [-0.00054573, -0.00115425, 0.999999]],
["a3\structures_f_epa\items\medical\bandage_f.p3d", [5641.93, 10377.9, 3.17035], [-0.921841, 0.387567, 0], [0, 0, 1]],
["a3\structures_f_epa\items\medical\bandage_f.p3d", [5642, 10377.9, 3.17039], [-0.919144, 0.393919, 0.00118715], [0.00129158, 0, 0.999999]],
["a3\structures_f\items\electronics\portable_generator_f.p3d", [5640.72, 10380.7, 2.75704], [0.903189, -0.429244, 0], [0, 0, 1]],
["a3\structures_f\items\tools\drillaku_f.p3d", [5642.38, 10379.5, 3.29968], [0, 1, 0], [0.00169117, 0, 0.999999]],
["a3\structures_f\items\electronics\extensioncord_f.p3d", [5642.29, 10378.9, 3.23525], [0.99983, 0.0184252, 3.19074e-006], [2.03292e-005, -0.00127632, 0.999999]],
["a3\structures_f\items\electronics\floodlight_f.p3d", [5641.56, 10382.2, 2.54436], [0.760601, 0.64922, 0], [0, 0, 1]],
["a3\structures_f\items\tools\grinder_f.p3d", [5643.37, 10381.1, 3.21], [0.716679, 0.687329, -0.118109], [0.0864102, 0.0805344, 0.992999]],
["a3\structures_f\items\tools\hammer_f.p3d", [5642.51, 10379.6, 3.16909], [-7.37165e-006, 0.998486, 0.0550143], [0.998156, 0.00334676, -0.0606084]],
["a3\structures_f\civ\constructions\woodenbox_f.p3d", [5641.11, 10381.4, 3.14724], [-0.873782, 0.486319, 0], [0, 0, 1]],
["a3\structures_f_bootcamp\items\food\foodcontainer_01_f.p3d", [5638.09, 10385.7, 2.48488], [0, 1, 0], [0, 0, 1]],
["exile_assets\model\exile_item_beefparts.p3d", [5640.19, 10384.2, 3.1554], [-0.921817, 0.387625, 0.000966928], [0.00107986, 7.35421e-005, 0.999999]],
["exile_assets\model\exile_item_bbqsandwich.p3d", [5640.25, 10384.4, 3.15396], [0.941162, -0.337954, -0.00102754], [0.00109178, 0, 0.999999]],
["exile_assets\model\exile_item_cheathas.p3d", [5640.41, 10384.6, 3.15356], [-0.929356, 0.369184, -1.26648e-005], [0.000387017, 0.00100855, 0.999999]],
["exile_assets\model\exile_item_toolbox.p3d", [5643.05, 10381.2, 3.14856], [0.586635, 0.809851, -2.1499e-006], [0.00135881, -0.000981632, 0.999999]],
["exile_assets\model\exile_item_cockonut.p3d", [5640.43, 10384.3, 3.15675], [-0.923413, 0.383807, -1.03104e-005], [0.00040466, 0.00100045, 0.999999]],
["exile_assets\model\exile_item_moobar.p3d", [5640.46, 10384.1, 3.158], [-0.397356, -0.917665, -6.78588e-006], [-0.000998816, 0.0004251, 0.999999]],
["exile_assets\model\exile_item_powerdrink.p3d", [5641, 10386.1, 3.15758], [-0.831829, -0.555033, -2.00485e-006], [-0.000605854, 0.000904383, 0.999999]],
["exile_assets\model\exile_item_beer.p3d", [5641.18, 10386.1, 3.16031], [0, 1, 0], [0.00109178, 0, 0.999999]],
["a3\structures_f_epa\items\food\bottleplastic_v2_f.p3d", [5640.87, 10386, 3.2847], [0, 1, 0], [0.00109178, 0, 0.999999]],
["a3\structures_f\civ\market\cratesshabby_f.p3d", [5639, 10387.5, 2.98753], [-0.898351, 0.439279, 0], [0, 0, 1]],
["a3\props_f_exp\commercial\market\woodencrate_01_stack_x3_f.p3d", [5638.28, 10382.9, 2.93159], [0.650362, -0.759624, 0], [0, 0, 1]],
["a3\structures_f\civ\constructions\woodenbox_f.p3d", [5648.92, 10345.7, 2.282], [0.381078, 0.924543, 0], [0, 0, 1]],
["a3\structures_f_exp\military\fortifications\bagfence_01_long_green_f.p3d", [5682.81, 10423.6, 2.72979], [0.417954, 0.908468, 0], [0, 0, 1]],
["a3\structures_f_exp\military\fortifications\bagfence_01_round_green_f.p3d", [5680.11, 10423.7, 2.62008], [0.582023, -0.813172, 0], [0, 0, 1]],
["a3\structures_f_exp\military\fortifications\bagfence_01_round_green_f.p3d", [5671.85, 10428.6, 2.62609], [0.95712, 0.289693, 0], [0, 0, 1]],
["a3\structures_f_exp\military\fortifications\bagfence_01_round_green_f.p3d", [5671.78, 10431.4, 2.62804], [-0.942413, -0.334452, 0], [0, 0, 1]],
["a3\structures_f_exp\military\fortifications\bagfence_01_long_green_f.p3d", [5664.08, 10435.4, 2.64852], [0.387256, 0.921972, 0], [0, 0, 1]],
["a3\structures_f_exp\military\fortifications\bagfence_01_long_green_f.p3d", [5661.33, 10436.6, 2.62538], [0.387269, 0.921967, 0], [0, 0, 1]],
["a3\structures_f_exp\military\fortifications\bagfence_01_end_green_f.p3d", [5659.58, 10437.4, 2.64622], [-0.405799, -0.913962, 0], [0, 0, 1]],
["a3\structures_f_exp\military\fortifications\bagfence_01_long_green_f.p3d", [5648.47, 10346.4, 2.72501], [-0.382724, -0.923863, 0], [0, 0, 1]],
["a3\structures_f_exp\military\fortifications\bagfence_01_end_green_f.p3d", [5650.27, 10345.7, 2.697], [0.359762, 0.933044, 0], [0, 0, 1]],
["a3\roads_f\runway\runwaylights\runway_edgelight_blue_f.p3d", [5562.1, 10462.1, 2.59547], [0, 1, 0], [0, 0, 1]],
["a3\roads_f\runway\runwaylights\runway_edgelight_blue_f.p3d", [5555.77, 10457.7, 2.55189], [0, 0.9994, -0.0346456], [-0.0665191, 0.0345688, 0.997186]],
["a3\structures_f\civ\lamps\lampharbour_f.p3d", [5638.57, 10392.3, 5.11497], [0.909092, -0.416595, 0], [0, 0, 1]],
["a3\structures_f\civ\lamps\lampharbour_f.p3d", [5637.68, 10354.4, 5.10797], [0.909668, -0.415336, 0], [0, 0, 1]],
["a3\structures_f\civ\lamps\lampharbour_f.p3d", [5637.74, 10371.5, 2.80797], [0.442487, 0.896775, 0], [0, 0, 1]],
["a3\structures_f\civ\lamps\lampharbour_f.p3d", [5612.54, 10399.9, 5.04373], [-0.914274, 0.405095, 0], [0, 0, 1]],
["a3\structures_f\civ\lamps\lampharbour_f.p3d", [5576.82, 10452.1, 5.00851], [0.584527, -0.811374, 0], [0, 0, 1]],
["a3\structures_f\civ\lamps\lampharbour_f.p3d", [5696.53, 10382.4, 5.92306], [-0.418769, -0.908093, 0], [0, 0, 1]],
["a3\structures_f\civ\lamps\lampharbour_f.p3d", [5688.27, 10425.6, 5.1164], [-0.919206, 0.393777, 0], [0, 0, 1]],
["a3\structures_f\civ\lamps\lampharbour_f.p3d", [5642.52, 10382, 2.80797], [-0.43602, -0.899937, 0], [0, 0, 1]],
["a3\structures_f\civ\lamps\lampharbour_f.p3d", [5657.39, 10402.4, 5.10797], [0.933442, -0.358729, 0], [0, 0, 1]]
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