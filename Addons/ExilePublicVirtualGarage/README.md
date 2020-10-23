# ExilePublicVirtualGarage
Basic 1 Vehicle VG for anyone

This is based on location and can be used in an airfield or non safezone location. You are free to adapt it to be trader based or a scroll wheel action on a trader. It is pretty simple.

Showcase video: https://www.youtube.com/watch?v=hxUIN_YniDg

This was developed on a test server with EXTDB2, no infistar and no battleye.


# Install Instructions:

### Client

**config.cpp**

Paste the contents into the top of your config file. Modify existing network message section if needed.
Add the override to ExileCustomCode

**initplayerlocal.sqf**

After `if (!hasInterface || isServer) exitWith {};` paste the upper contents of initplayerlocal.sqf found in the Client folder


If you are having trouble please view the example mission included.

### Server

**Code**

Pbo the server folder and place inside your servermod folder (such as @ExileServer)
Overrides are in the client/mission folder

**SQL**

There is a column in vehicle table that is needed for this to function properly. Please execute the SQL on your Exile database

**Exile.ini**

loadVehicleIdPage needs to be modified - found at the top of the exile.ini

Paste the contents at the bottom of your exile.ini **MODIFY** if using extdb3


For support feel free to post in Exile Discord #support channel: https://discord.gg/cmMMHyJ

Unless something is broken or missing in this initial release I will not provide support or installation help, you are free to use this release as you wish.

Thank you!
