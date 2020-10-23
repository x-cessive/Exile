# ExileBaseMover
ADMIN ONLY TOOL

Move a base completely based on flag location. 
Use: "call ExileClient_admin_baseMover;" to start the script - call again to place base

Showcase video: https://www.youtube.com/watch?v=RhatjGaZgoo

This was developed on a test server with EXTDB2, no infistar and no battleye.


# Install Instructions:

### Client

**config.cpp**

Paste the contents into the top of your config file. Modify existing network message section if needed.

**initplayerlocal.sqf**

After `if (!hasInterface || isServer) exitWith {};` paste the contents of initplayerlocal.sqf found in the Client folder

If you are having trouble please view the example mission included.

### Server

**Code**

No overrides needed, simply pbo the server folder and place inside your servermod folder (such as @ExileServer)

**Exile.ini**

Paste the contents at the bottom of your exile.ini **MODIFY** if using extdb3

For support feel free to post in Exile Discord #support channel: https://discord.gg/cmMMHyJ

Unless something is broken or missing in this initial release I will not provide support or installation help, you are free to use this release as you wish.

Thank you!
