# A3WarningScript
Plays a sound and display warning when a rocket is locked/launched at the vehicle, any vehicle class can be blacklisted in the config files and works for all vehicles by default (except quadbikes, blacklisted as an example)

## Installation
### Exile
Copy the custom folder into your Exile.MapName folder.  
Merge or copy the description.ext  
Merge or copy the initPlayerLocal.sqf  

  
## Settings
All the settings that can be changed are inside \custom\ChaosAutoPilot\AutoPilotConfig.h  


| Variable      | Purpose |
|---------------|---------|
| ENABLE_ALL | enable it for all vehicles, ignore all the other options except blacklist |
| BLACKLIST | vehicle classes to be blacklisted using isKindOf (blacklist subclasses) all quadbikes blacklisted by default |
| ALLOWED | vehicles to be included if enable all is set to false |

You can change the audio file by replacing the alarm.ogg file in the custom folder (keep the same name and file format)  
You can change the the volume in the description.ext "sound[] = {"custom\MWarning\alarm.ogg", 0.4, 0.8};" 0.4 being the volume and 0.8 the pitch  

### dialog.hpp
You can change the appearance of the dialog message inside dialog.hpp if you search for the ``` class Attributes ```  
and you can change the text by replacing whatever is inside ``` text = "Missile Incoming!"; ```
 

## License
Noncommercial - You may not use this material for any commercial purposes. 
Feel free to Modify and Distribute.
