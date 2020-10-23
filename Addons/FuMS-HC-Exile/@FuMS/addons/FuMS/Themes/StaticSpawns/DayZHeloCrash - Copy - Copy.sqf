//LandPatrol.sqf
// Horbin
// 1/20/15
// Be cautious when editing data.

[
["DayZHeloCrash", 300, "LAND"], // Mission Title NOSPACES!, and encounter radius
["DayZHeloCrash","mil_dot","ELLIPSE","ColorYellow","FDiagonal",25],    // Map Markers ["MapText", "SHAPE", "COLOR", "FILL", size];
[  
    [// NOTIFICATION Messages and Map display Control.
	false, 0, 0, // Notify players via Radio Message, radio channel, range from encounter center (0=unlimited.
    false, // Notify players via global message
    false,// Show encounter area on the map
    30,    // Win delay: Time in seconds after a WIN before mission cleanup is performed
    10       // Lose delay: Time in seconds after a lose before mission cleanup is performed
          //NOTE: the above delay must occur before the mission is considered 'complete' by the mission manager control loop.
    ],
    // Spawn Mission Message 
    [
     	"", // title line, do not remove these!
     	"" //description/radio message.
    ],  
    // Mission Success Message
    [
        "Mission Success",
        ""
    ], 
    
    // Mission Failure Message
    [
        "Mission Failure!",
        ""
    ] 
],
[  //  Loot Config:  Refer to LootData.sqf for specifics
// Loot for this mission is contained in the Vehicles!
["Scatter" , [0,0] ], //[static loot, offset location] - spawns with the mission
   // static loot will also spawn if 'NO TRIGGERS' is enabled.
["None" , [0,0] ], // Win loot, offset location - spawns after mission success
["None" , [0,0] ]  // Failure loot, offset location - spawns on mission failure
],
[//BUILDINGS: persist = 0: building deleted at event completion, 1= building remains until server reset.
  [
    ["Land_UWreck_Heli_Attack_02_F","Land_Wreck_Heli_Attack_01_F"],
    [0,0], // location
	0, // rotation
	0, // persist flag
	"Fire_Big"
  ]
  
],
[ // AI GROUPS. Only options marked 'Def:' implemented.
 //  [["RESISTANCE","COMBAT","RED","COLUMN"],   [  [1,"Sniper"],[2,"Rifleman"],[2,"Hunter"]  ],   ["BoxPatrol",[0,75],[0,0],[0]   ]],
 //   [["RESISTANCE","COMBAT","RED","LINE"],   [  [3,"Rifleman"]                                         ],   ["Sentry",[-20,10],[0,0],[70] ]],
 //  [["RESISTANCE","COMBAT","RED","LINE"],   [  [2,"Hunter"]                                              ],   ["Guard",[6,6],[0,0],[30]     ]]
],
//Example: PatrolBehavior: ["BoxPatrol", [100,0], [0,0],0 ]  
// AI will spawn 100m east of encounter center, a 4 point patrol will be set up at 80% encounter radius. AI will move to this and start patrolling.
// spawnoffsetloc: [x,y] where x and y are offsets in meters from the encounter center.Sets the spawn location for the group.
// patroloffsetloc:[x,y] where x and y are offsets in meters from encounter center. Sets the center of the group's patrol zone,
//                     or where it should travel too before starting its patrol pattern.
// radius: in meters - used in establishing patrol geometry. If zero, then 80% of encounter radius will be used.
//###Patrol Options### 
//Def:   "Perimeter", spawnloc, patrolloc, radius: - 12 waypoints set at radius from loc, group goes from point to point
//Def:   "BoxPatrol", spawnloc, patrolloc, radius: - 4 waypoints set at radius from loc, group goes from point to point
//Def:  "Explore", spawnloc, patrolloc, radius: - 12 waypoints set up at radius from loc, group moves randomly from point to point
//Def:  "Guard", spawnloc, patrolloc, radius: - group patrols inside of buildings found within radius of loc.
//Def:  "Sentry", spawnloc, patrolloc radius: - group moves to nearest building and takes up station in highest points within the building
//     NOTE: if no buildings are located within 'radius' both Guard and Sentry will locate nearest buildings to the encounter and move there!
//  "Loiter", loc, radius: - group just hangs out, in an unaware mode in vicinity of loc-radius.
//  "Convoy", loc, data: group follows roads from startloc to stoploc, then loops back.
//  "XCountry", loc, data: group goes from startloc to stoploc, then loops back.

// Vehicles
[
     [  // Convoy #1                     
    [         // Vehicle                     Offset     Crew (only 1 type!)   CargoLoot (see Loot section below for more detail!)
       //    [  "C_Offroad_01_EPOCH"          ,[0,0],[1 ,"Rifleman"],        "Random"      ], 
           //[  "C_Offroad_01_EPOCH"          ,[0,50],[1 ,"Rifleman"],     "Random"      ], 
		//   [  "B_G_Offroad_01_armed_F"          ,[0,50],[1 ,"Rifleman"],     "Random"      ], 
       //    [  "C_Offroad_01_EPOCH"          ,[0,75],[1 ,"Rifleman"],     "Random"      ]
		//   [  "C_Quadbike_01_EPOCH"          ,[-50,-600],[1,"Rifleman"],     "None"      ], 
		 //  [  "C_Quadbike_01_EPOCH"          ,[-50,-600],[1,"Rifleman"],     "None"      ], 
         //  [  "C_Quadbike_01_EPOCH"          ,[-50,-600],[ 1, "Rifleman"],     "Truck01"]   
                 // If driver-less vehicles are desired, place them at the bottom of the list. 
				 // Troops WILL be placed into 'driver-less' vehicles if the other vehicles are full!!!
      ],
      [  
          // "Convoy": spawn at -500,-500, drop off cargo at -50,-50, then return to base. (ie 'Convoy' logic behaviour)
           // Drivers                                                          # and type  |         Patrol     |    spawn   | dest       | 'Patrol' options
        //  [["RESISTANCE","COMBAT","RED","COLUMN"],   [  [3, "Driver"]  ],   ["TrackRoute",[0,0],[0,0],["SAFE","LIMITED",["Villages","Villages"],true,true,false,0]   ]]
         // proceed to 0,-15, drop off troops, then return to spawn location and despawn!
      ],
      // Troops : These are distributed across all vehicles in this convoy.                                                         
     [      //  Troop behaviour and side options                        # and type of Troops                               Patrol logic |  spawn     |dest |'Patrol' options
       //  [["RESISTANCE","COMBAT","RED","COLUMN"],   [  [3,"Sniper"],[2,"Rifleman"]  ],   ["BoxPatrol",[0,0],[0,0],[100]   ]]
        // [["RESISTANCE","COMBAT","RED","COLUMN"],   [  [1,"Sniper"],[2,"Rifleman"] ],   ["BoxPatrol",[-70,-600],[50,0],[50]   ]],
        // [["RESISTANCE","COMBAT","RED","COLUMN"],   [  [1,"Sniper"],[3,"Rifleman"]  ],   ["BoxPatrol",[-70,-600],[-50,0],[50]   ]]
            // 'dest' for troops is where they will go to perform their 'Patrol Logic' once the disembark the convoy IF their vehicle's driver group is using the 'Convoy' patrol logic.
            // otherwise troops will remain in vehicle unless it is engaged. Once vehicle destroyed, Troops will move onto their 'Patrol Logic'.
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
//	  ["PROX",["ProxPlayer",[0,0],100,1]  ],
//	  ["LUCNT",["LowUnitCount","GUER",1,0,[0,0]]  ],
//	  ["HUCNT",["HighUnitCount","GUER",6,0,[0,0]] ],
//	  ["Detect",["Detected","ALL","ALL"] ],
//	  ["BodyCount",["BodyCount",9] ]
	  ["Timer",["TIMER", 30000] ]
	  //                            offset      radius    time(s)  Name
//	  ["Zuppa", ["ZuppaCapture",[ [ [-100,-100], 50,         90,  "Point 1" ],
 //                               [ [100,100],   50,         90,  "Point 2" ]   ]]  ],
//       ["VehDmg1", ["DmgVehicles", "1",0.8]  ],
//       ["BldgDmg1",["DmgBuildings","2,3,7",1.0]  ]
	  
	],
	[
	  // Define what actions should occur when above trigger logics evaluate to true
	   // Note: a comma between two logics is interpreted as "AND"
//	  [["WIN"],["LUCNT","PROX"    ]],  // 
	//  [["CHILD","Help_Helo",[0,0]],["OK"      ]],  // 
	// [["Reinforce","Help_Vehicle","Trig4"]], 
//	  [["LOSE"],["TIMER"]   ],
      [["END"],["TIMER"     ]]  
	]      
]
];
