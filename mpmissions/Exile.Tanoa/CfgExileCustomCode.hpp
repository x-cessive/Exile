//SERVER
ExileServer_system_database_connect                                     = "ExtDB3\Exile_Server_Overrides\ExileServer_system_database_connect.sqf";
ExileServer_system_process_noobFilter                                   = "ExtDB3\Exile_Server_Overrides\ExileServer_system_process_noobFilter.sqf";
ExileServer_world_initialize                                            = "ExtDB3\Exile_Server_Overrides\ExileServer_world_initialize.sqf";
ExileServer_util_time_uptime                                            = "ExtDB3\Exile_Server_Overrides\ExileServer_util_time_uptime.sqf";
ExileServer_util_time_currentTime                                       = "ExtDB3\Exile_Server_Overrides\ExileServer_util_time_currentTime.sqf";
ExileServer_util_time_addTime                                           = "ExtDB3\Exile_Server_Overrides\ExileServer_util_time_addTime.sqf";

//TRADING
ExileServer_system_trading_network_wasteDumpRequest                     = "ExtDB3\Exile_Server_Overrides\ExileServer_system_trading_network_wasteDumpRequest.sqf";
ExileServer_system_trading_network_sellItemRequest                      = "ExtDB3\Exile_Server_Overrides\ExileServer_system_trading_network_sellItemRequest.sqf";
ExileServer_system_trading_network_purchaseVehicleSkinRequest           = "ExtDB3\Exile_Server_Overrides\ExileServer_system_trading_network_purchaseVehicleSkinRequest.sqf";
ExileServer_system_trading_network_purchaseVehicleRequest               = "ExtDB3\Exile_Server_Overrides\ExileServer_system_trading_network_purchaseVehicleRequest.sqf";
ExileServer_system_trading_network_purchaseItemRequest                  = "ExtDB3\Exile_Server_Overrides\ExileServer_system_trading_network_purchaseItemRequest.sqf";

//TERRITORY
ExileServer_system_territory_network_territoryUpgradeRequest            = "ExtDB3\Exile_Server_Overrides\ExileServer_system_territory_network_territoryUpgradeRequest.sqf";
ExileServer_system_territory_network_restoreFlagRequest                 = "ExtDB3\Exile_Server_Overrides\ExileServer_system_territory_network_restoreFlagRequest.sqf";
ExileServer_system_territory_network_purchaseTerritory                  = "ExtDB3\Exile_Server_Overrides\ExileServer_system_territory_network_purchaseTerritory.sqf";
ExileServer_system_territory_network_payTerritoryProtectionMoneyRequest = "ExtDB3\Exile_Server_Overrides\ExileServer_system_territory_network_payTerritoryProtectionMoneyRequest.sqf";
ExileServer_system_territory_network_payFlagRansomRequest               = "ExtDB3\Exile_Server_Overrides\ExileServer_system_territory_network_payFlagRansomRequest.sqf";
ExileServer_system_territory_network_flagStolenRequest                  = "ExtDB3\Exile_Server_Overrides\ExileServer_system_territory_network_flagStolenRequest.sqf";
ExileServer_system_territory_maintenance_recalculateDueDate             = "ExtDB3\Exile_Server_Overrides\ExileServer_system_territory_maintenance_recalculateDueDate.sqf";
ExileServer_system_territory_database_insert                            = "ExtDB3\Exile_Server_Overrides\ExileServer_system_territory_database_insert.sqf";

//DB QUERIES
ExileServer_system_database_query_selectSingleField                     = "ExtDB3\Exile_Server_Overrides\ExileServer_system_database_query_selectSingleField.sqf";
ExileServer_system_database_query_selectSingle                          = "ExtDB3\Exile_Server_Overrides\ExileServer_system_database_query_selectSingle.sqf";
ExileServer_system_database_query_selectFull                            = "ExtDB3\Exile_Server_Overrides\ExileServer_system_database_query_selectFull.sqf";
ExileServer_system_database_query_insertSingle                          = "ExtDB3\Exile_Server_Overrides\ExileServer_system_database_query_insertSingle.sqf";
ExileServer_system_database_query_fireAndForget                         = "ExtDB3\Exile_Server_Overrides\ExileServer_system_database_query_fireAndForget.sqf";
ExileServer_system_database_handleBig                                   = "ExtDB3\Exile_Server_Overrides\ExileServer_system_database_handleBig.sqf";

//VEHICLES
ExileServer_object_vehicle_database_load                                = "ExtDB3\Exile_Server_Overrides\ExileServer_object_vehicle_database_load.sqf";
ExileServer_object_vehicle_createPersistentVehicle                      = "ExtDB3\Exile_Server_Overrides\ExileServer_object_vehicle_createPersistentVehicle.sqf";
ExileServer_object_vehicle_createNonPersistentVehicle                   = "ExtDB3\Exile_Server_Overrides\ExileServer_object_vehicle_createNonPersistentVehicle.sqf";

//PLAYER
ExileServer_object_player_event_onMpKilled                              = "ExtDB3\Exile_Server_Overrides\ExileServer_object_player_event_onMpKilled.sqf";
ExileServer_object_player_database_load                                 = "ExtDB3\Exile_Server_Overrides\ExileServer_object_player_database_load.sqf";
ExileServer_object_player_createBambi                                   = "ExtDB3\Exile_Server_Overrides\ExileServer_object_player_createBambi.sqf";

//CONTAINERS
ExileServer_object_container_database_update                            = "ExtDB3\Exile_Server_Overrides\ExileServer_object_container_database_update.sqf";
ExileServer_object_container_database_load                              = "ExtDB3\Exile_Server_Overrides\ExileServer_object_container_database_load.sqf";
ExileServer_object_container_database_insert                            = "ExtDB3\Exile_Server_Overrides\ExileServer_object_container_database_insert.sqf";
ExileServer_object_container_createContainer                            = "ExtDB3\Exile_Server_Overrides\ExileServer_object_container_createContainer.sqf";

//CONSTRUCTION
ExileServer_object_construction_database_load                           = "ExtDB3\Exile_Server_Overrides\ExileServer_object_construction_database_load.sqf";
ExileServer_object_construction_database_insert                         = "ExtDB3\Exile_Server_Overrides\ExileServer_object_construction_database_insert.sqf";

//CLIENT
ExileClient_util_string_scalarToString                                  = "ExtDB3\Exile_Client_Overrides\ExileClient_util_string_scalarToString.sqf";

//THESE FILES ARE COMBINED WITHIN THE EXTDB3 FILES ABOVE.
//ExileServer_object_player_createBambi                                   = "custom\loadout\ExileServer_object_player_createBambi.sqf";
//ExileServer_object_player_event_onMpKilled                              = "overwrites\KillMessages\ExileServer_object_player_event_onMpKilled.sqf";

ExileServer_object_player_network_createPlayerRequest                   = "custom\loadout\ExileServer_object_player_network_createPlayerRequest.sqf";
ExileClient_object_player_event_onEnterSafezone                         = "overwrites\ExileClient_object_player_event_onEnterSafezone.sqf";
ExileServer_system_territory_database_load                              = "ExAdClient\VirtualGarage\CustomCode\ExileServer_system_territory_database_load.sqf";
ExileClient_gui_xm8_slide                                               = "ExAdClient\XM8\CustomCode\ExileClient_gui_xm8_slide.sqf";
ExileClient_gui_xm8_show                                                = "ExAdClient\XM8\CustomCode\ExileClient_gui_xm8_show.sqf";
ExileClient_system_trading_network_purchaseVehicleResponse              = "overwrites\ExileClient_system_trading_network_purchaseVehicleResponse.sqf";
ExileClient_gui_hud_renderStatsPanel                                    = "overwrites\ExileClient_gui_hud_renderStatsPanel.sqf";
ExileClient_gui_hud_renderVehiclePanel                                  = "overwrites\ExileClient_gui_hud_renderVehiclePanel.sqf";
ExileClient_object_player_death_startBleedingOut                        = "custom\EnigmaRevive\ExileClient_object_player_death_startBleedingOut.sqf"; //Happys Revive
ExileClient_object_player_event_onInventoryOpened                       = "custom\EnigmaRevive\ExileClient_object_player_event_onInventoryOpened.sqf"; //Happys Revive AntiDupe ---NEW with v0.65
ExileClient_gui_selectSpawnLocation_event_onSpawnButtonClick            = "XG_Spawn_Override\ExileClient_gui_selectSpawnLocation_event_onSpawnButtonClick.sqf";
ExileClient_gui_selectSpawnLocation_show                                = "XG_Spawn_Override\ExileClient_gui_selectSpawnLocation_show.sqf";
exileclient_system_lootmanager_thread_spawn                             = "EBM\exileclient_system_lootmanager_thread_spawn.sqf";
ExileServer_system_rcon_thread_check                                    = "restart\ExileServer_system_rcon_thread_check.sqf";

ExileServer_system_trading_network_purchaseVehicleRequest               = "overwrites\ExileServer_system_trading_network_purchaseVehicleRequest.sqf";