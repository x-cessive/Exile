//Reinforcements.sqf
// Horbin
// 1/18/15
// Mission designed to be launched in response to a call for reinforcements.
// No triggers and no loot for this mission, just Troops!
// Units will spawn 250m to the east and proceed to within 75mn of the encounter and patrol!
// Be cautious when editing data.
// Updated 9/29/18 by TheOneWhoKnocks to add mission annoucements and clean up layout

[
	["HeloDrop", 200], // Mission Title NOSPACES!, and encounter radius
	["HeloDrop","mil_dot","ELLIPSE","ColorGreen","FDiagonal",200],    // Map Markers ["MapText", "SHAPE", "COLOR", "FILL", size];
	[  
		[   // NOTIFICATION Messages and Map display Control.
			false, "ALL", 0, // Notify players via Radio Message, radio channel, range from encounter center (0=unlimited.
			true, // Notify players via global message
			false,// Show encounter area on the map
			10,    // Win delay: Time in seconds after a WIN before mission cleanup is performed
			10       // Lose delay: Time in seconds after a lose before mission cleanup is performed
			//NOTE: the above delay must occur before the mission is considered 'complete' by the mission manager control loop.
		],
		// Spawn Mission Message
		[
			"ALERT!", // title line, do not remove these!
			"Reinforcements have arrived." //description/radio message.
		],  
		// Mission Success Message
		[
			"",
			"Seems quiet now..."
		], 
		// Mission Failure Message
		[
			"",
			""
		] 
	],
	[  //  Loot Config:  Refer to LootData.sqf for specifcs
		["None" , [18,-9] ], //[static loot, offset location] - spawns with the mission
		["None" , [-5,0] ], // Win loot, offset location - spawns after mission success
		["None" , [0,0] ]  // Failure loot, offset location - spawns on mission failure
	],
	[//BUILDINGS: persist = 0: building deleted at event completion, 1= building remains until server reset.
	  
	],
	[ // AI GROUPS. Only options marked 'Def:' implemented.
		//  [["RESISTANCE","COMBAT","RED","COLUMN"],   [  [1,"Sniper"],[2,"Rifleman"],[2,"Hunter"]  ],   ["BoxPatrol",[250,0],[0,0],[75]   ]]
		//   [["RESISTANCE","COMBAT","RED","LINE"],   [  [3,"Rifleman"]                                         ],   ["Sentry",[-20,10],[0,0],[70] ]],
		//[["RESISTANCE","COMBAT","RED","LINE"],   [  [2,"Hunter"]                                              ],   ["Guard",[6,6],[0,0],[30]     ]]
	],
	// Vehicles
	[
		[  // Division #1
			[         // Vehicle                                 Offset     Crew (only 1 type!)   CargoLoot (see Loot section below for more detail!)
				//     [  "O_Heli_Light_02_unarmed_EPOCH",[0,-1900],[1,"Rifleman"],        "TruckJunk"      ], 
				//     [  "O_Heli_Light_02_unarmed_EPOCH"           ,[0,-1800],[1,"Rifleman"],     "None"      ], 
				[  FuMS_Heli_Mohawks         ,[0,-1700],[1,"Rifleman_E"],     "None"      ]
			],
			[  
				// Pilots                                                          # and type  |         Patrol     |    spawn   | dest  | 'Patrol' options
			   [["EAST","COMBAT","RED","COLUMN"],   [  [1, "Driver_E"]  ],   ["ParaDrop",[0,-1700],[0,0],["Full", 100, true,true  ]   ]]
			],
			[   
				// Troops : These are distributed across all aircraft in the division. These lines are identical to the lines in the group section.
				//  Troop behaviour and side options                    # and type of Troops     Patrol logic |  spawn     |dest |'Patrol' options
				//   [["RESISTANCE","COMBAT","RED","COLUMN"],[[1,"Sniper"],[6,"Rifleman"]],["BoxPatrol",[-70,-1900],[0,0],[0]]],
				//   [["RESISTANCE","COMBAT","RED","COLUMN"],[[1,"Sniper"],[6,"Rifleman"]],["BoxPatrol",[-70,-1800],[50,0],[50]]],
				[["EAST","COMBAT","RED","COLUMN"],[[1,"Sniper_E"],[2,"Rifleman_E"]],["BoxPatrol",[0,-1700],[0,0],[50]]]
				// 'dest' for troops is where they will go to perform their 'Patrol Logic' once they get on deck
			]
	   ]
	],
	[
		[
			//Define all the triggers this mission will be using
			// Trigger names must be unique within each mission.
			// NOTE: "FuMS_KillMe" is a reserved trigger word. Do not use!!!
			// NOTE: "OK" is a reserved trigger. Do not define it here.
			//  "OK" can be used in the actions section to force an action to occur at mission start!	 
			//	  ["PROX",["ProxPlayer",[0,0],80,1]  ],
				  ["LUCNT",["LowUnitCount","EAST",0,0,[0,0]]  ]
			//	  ["HUCNT",["HighUnitCount","GUER",6,0,[0,0]] ],
			//	  ["Detect",["Detected","ALL","ALL"] ],
			//	  ["BodyCount",["BodyCount",9] ]
			//	  ["Timer",["TIMER", 1800] ],
			//                                   offset      radius    time(s)  Name
			//	  ["Zuppa", ["ZuppaCapture",[ [ [-100,-100], 50,         90,  "Point 1" ],
			 //                               [ [100,100],   50,         90,  "Point 2" ]   ]]  ],
			//    ["VehDmg1", ["DmgVehicles", "1",0.8]  ],
			//    ["BldgDmg1",["DmgBuildings","2,3,7",1.0]  ]
		  
		],
		[
			// Define what actions should occur when above trigger logics evaluate to true
			// Note: a comma between two logics is interpreted as "AND"
			//	  [["WIN"],["LUCNT"     ]],  // 
			//  [["CHILD","Help_Helo",[0,0]],["OK"      ]],  // 
			// [["Reinforce","Help_Vehicle","Trig4"]], 
			//	  [["LOSE"],["TIMER", "OR", "VehDmg1", "BldgDmg1"]   ],
			[["END"],["LUCNT"     ]]  
		]      
	]
];
