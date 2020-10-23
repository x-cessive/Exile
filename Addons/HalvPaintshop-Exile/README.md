# Vehicle & backpack Paintshop By Halv


## Original Sources
https://github.com/Halvhjearne/paintshop


## Modifications
I (NRZ7) only makes a few modifications to enable full compatibility with exile, changing some eternaly false conditions, commenting a few lines and making a system to save paint into Exile DB.


## Install Instructions
1. Pack to .PBO ExileHalvPaintshop_Server
	1. Do not use PBO Manager. Use official BI addon builder, mikero's or other tools.
	2. Put ExileHalvPaintshop_Server.pbo to @ExileServer/addons

2. Merge mpmission folder with your current mission pbo
	1. Paste addons/paintshop to addons/paintshop in your mission PBO
	2. Merge the config.cpp with your config.cpp to add "Save Paint" action
	3. Put the lines from InitPlayerLocal.sqf in the top of your initPlayerLocal.sqf
	4. Put the lines from description.ext to your description.ext
	
3. Configure 
	1. Paste your textures to your mpmission or local modifications
	2. Open /mpmission/addons/paintshop/settings.sqf
	3. Edit the _texture array and add names and file paths to your custom images
	4. Add somewhere in your map a building described in "_paintshopbuildings". Preefered into a Safe Zone.

4. If you use infistar, whitelist the ID 6666


## Notes
- Do **NOT use PBO Manager to pack server pbo**, will broke the pbo. Use BI tools or other alternative.
- The save paint script is setted to work only in a safe zone with an open but lockable vehicle. If you want to change the condition see how works the config.cpp addactions.
- If the instructions are working, i do not offer support.
- The **textures are NOT included with the package**. All textures needs to be in all clients, inside the mission PBO or inside a local mod.
- A good size for textures are 512x512, 1024x1024 or 2048x2048 only with .JPG or .PAA formats.


## License
Copyright (C) 2015 Halvhjearne

This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with this program. If not, see http://www.gnu.org/licenses/.

Contact : halvhjearne@gmail.com


## Credits

* Halvjearne for Halv's Paintshop
* Mezo for give-me permission to use Claim Vehicles pluggin to learn how to interact with DB
