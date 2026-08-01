This removes the need to drop melee weapons such as axe in Arma 3 Exile mod for it to work, it will check if player has the item and if it's loaded, if not, it will load the magazine and automatically reload it

Drop the file ExileClient_object_player_safezone_checkSafezone.sqf into your mission file in a folder named custom, create folder if necessary
Add this to your mission config in class CfgExileCustomCode 

ExileClient_object_player_safezone_checkSafezone = "custom\ExileClient_object_player_safezone_checkSafezone.sqf";

Pack mission