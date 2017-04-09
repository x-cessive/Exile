//SERVER
ExileServer_system_database_connect                                     = "Exile_Server_Overrides\ExileServer_system_database_connect.sqf";
ExileServer_system_process_noobFilter                                   = "Exile_Server_Overrides\ExileServer_system_process_noobFilter.sqf";
ExileServer_world_initialize                                            = "Exile_Server_Overrides\ExileServer_world_initialize.sqf";
ExileServer_util_time_uptime                                            = "Exile_Server_Overrides\ExileServer_util_time_uptime.sqf";
ExileServer_util_time_currentTime                                       = "Exile_Server_Overrides\ExileServer_util_time_currentTime.sqf";
ExileServer_util_time_addTime                                           = "Exile_Server_Overrides\ExileServer_util_time_addTime.sqf";

//TRADING
ExileServer_system_trading_network_wasteDumpRequest                     = "Exile_Server_Overrides\ExileServer_system_trading_network_wasteDumpRequest.sqf";
ExileServer_system_trading_network_sellItemRequest                      = "Exile_Server_Overrides\ExileServer_system_trading_network_sellItemRequest.sqf";
ExileServer_system_trading_network_purchaseVehicleSkinRequest           = "Exile_Server_Overrides\ExileServer_system_trading_network_purchaseVehicleSkinRequest.sqf";
ExileServer_system_trading_network_purchaseVehicleRequest               = "Exile_Server_Overrides\ExileServer_system_trading_network_purchaseVehicleRequest.sqf";
ExileServer_system_trading_network_purchaseItemRequest                  = "Exile_Server_Overrides\ExileServer_system_trading_network_purchaseItemRequest.sqf";

//TERRITORY
ExileServer_system_territory_network_territoryUpgradeRequest            = "Exile_Server_Overrides\ExileServer_system_territory_network_territoryUpgradeRequest.sqf";
ExileServer_system_territory_network_restoreFlagRequest                 = "Exile_Server_Overrides\ExileServer_system_territory_network_restoreFlagRequest.sqf";
ExileServer_system_territory_network_purchaseTerritory                  = "Exile_Server_Overrides\ExileServer_system_territory_network_purchaseTerritory.sqf";
ExileServer_system_territory_network_payTerritoryProtectionMoneyRequest = "Exile_Server_Overrides\ExileServer_system_territory_network_payTerritoryProtectionMoneyRequest.sqf";
ExileServer_system_territory_network_payFlagRansomRequest               = "Exile_Server_Overrides\ExileServer_system_territory_network_payFlagRansomRequest.sqf";
ExileServer_system_territory_network_flagStolenRequest                  = "Exile_Server_Overrides\ExileServer_system_territory_network_flagStolenRequest.sqf";
ExileServer_system_territory_maintenance_recalculateDueDate             = "Exile_Server_Overrides\ExileServer_system_territory_maintenance_recalculateDueDate.sqf";
ExileServer_system_territory_database_insert                            = "Exile_Server_Overrides\ExileServer_system_territory_database_insert.sqf";

//DB QUERIES
ExileServer_system_database_query_selectSingleField                     = "Exile_Server_Overrides\ExileServer_system_database_query_selectSingleField.sqf";
ExileServer_system_database_query_selectSingle                          = "Exile_Server_Overrides\ExileServer_system_database_query_selectSingle.sqf";
ExileServer_system_database_query_selectFull                            = "Exile_Server_Overrides\ExileServer_system_database_query_selectFull.sqf";
ExileServer_system_database_query_insertSingle                          = "Exile_Server_Overrides\ExileServer_system_database_query_insertSingle.sqf";
ExileServer_system_database_query_fireAndForget                         = "Exile_Server_Overrides\ExileServer_system_database_query_fireAndForget.sqf";
ExileServer_system_database_handleBig                                   = "Exile_Server_Overrides\ExileServer_system_database_handleBig.sqf";

//VEHICLES
ExileServer_object_vehicle_database_load                                = "Exile_Server_Overrides\ExileServer_object_vehicle_database_load.sqf";
ExileServer_object_vehicle_createPersistentVehicle                      = "Exile_Server_Overrides\ExileServer_object_vehicle_createPersistentVehicle.sqf";
ExileServer_object_vehicle_createNonPersistentVehicle                   = "Exile_Server_Overrides\ExileServer_object_vehicle_createNonPersistentVehicle.sqf";

//PLAYER
ExileServer_object_player_event_onMpKilled                              = "Exile_Server_Overrides\ExileServer_object_player_event_onMpKilled.sqf";
ExileServer_object_player_database_load                                 = "Exile_Server_Overrides\ExileServer_object_player_database_load.sqf";
ExileServer_object_player_createBambi                                   = "Exile_Server_Overrides\ExileServer_object_player_createBambi.sqf";

//CONTAINERS
ExileServer_object_container_database_update                            = "Exile_Server_Overrides\ExileServer_object_container_database_update.sqf";
ExileServer_object_container_database_load                              = "Exile_Server_Overrides\ExileServer_object_container_database_load.sqf";
ExileServer_object_container_database_insert                            = "Exile_Server_Overrides\ExileServer_object_container_database_insert.sqf";
ExileServer_object_container_createContainer                            = "Exile_Server_Overrides\ExileServer_object_container_createContainer.sqf";

//CONSTRUCTION
ExileServer_object_construction_database_load                           = "Exile_Server_Overrides\ExileServer_object_construction_database_load.sqf";
ExileServer_object_construction_database_insert                         = "Exile_Server_Overrides\ExileServer_object_construction_database_insert.sqf";

//CLIENT
ExileClient_util_string_scalarToString                                  = "Exile_Client_Overrides\ExileClient_util_string_scalarToString.sqf";

//THESE FILES ARE COMBINED WITHIN THE EXTDB3 FILES ABOVE.
//ExileServer_object_player_createBambi                                   = "custom\loadout\ExileServer_object_player_createBambi.sqf";
//ExileServer_object_player_event_onMpKilled                              = "overwrites\KillMessages\ExileServer_object_player_event_onMpKilled.sqf";

ExileServer_object_player_network_createPlayerRequest                   = "custom\loadout\ExileServer_object_player_network_createPlayerRequest.sqf";
ExileClient_object_player_event_onEnterSafezon                          = "Igiload\ExileClient_object_player_event_onEnterSafezon.sqf";
ExileServer_system_territory_database_load                              = "ExAdClient\VirtualGarage\CustomCode\ExileServer_system_territory_database_load.sqf";
ExileClient_gui_xm8_slide                                               = "ExAdClient\XM8\CustomCode\ExileClient_gui_xm8_slide.sqf";
ExileClient_gui_xm8_show                                                = "ExAdClient\XM8\CustomCode\ExileClient_gui_xm8_show.sqf";
ExileClient_system_trading_network_purchaseVehicleResponse              = "overwrites\ExileClient_system_trading_network_purchaseVehicleResponse.sqf";
ExileClient_gui_hud_renderStatsPanel                                    = "ExileClient_gui_hud_renderStatsPanel.sqf";
ExileClient_gui_hud_renderVehiclePanel                                  = "ExileClient_gui_hud_renderVehiclePanel.sqf";
ExileClient_object_player_death_startBleedingOut                        = "custom\EnigmaRevive\ExileClient_object_player_death_startBleedingOut.sqf"; //Happys Revive
ExileClient_object_player_event_onInventoryOpened                       = "custom\EnigmaRevive\ExileClient_object_player_event_onInventoryOpened.sqf"; //Happys Revive AntiDupe ---NEW with v0.65
ExileClient_gui_selectSpawnLocation_event_onSpawnButtonClick            = "XG_Spawn_Override\ExileClient_gui_selectSpawnLocation_event_onSpawnButtonClick.sqf";
ExileClient_gui_selectSpawnLocation_show                                = "XG_Spawn_Override\ExileClient_gui_selectSpawnLocation_show.sqf";
exileclient_system_lootmanager_thread_spawn                             = "EBM\exileclient_system_lootmanager_thread_spawn.sqf";
ExileServer_system_rcon_thread_check                                    = "restart\ExileServer_system_rcon_thread_check.sqf";

ExileServer_system_trading_network_purchaseVehicleRequest               = "overwrites\ExileServer_system_trading_network_purchaseVehicleRequest.sqf";
