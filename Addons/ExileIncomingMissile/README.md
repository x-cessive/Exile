# ExileIncomingMissile
Triggers a warning when a missile is shot at the vehicle

Showcase video: https://www.youtube.com/watch?v=VrcfySy-D7A

This was developed on a test server with EXTDB2, no infistar and no battleye.


# Install Instructions:

### Client

**config.cpp**

Paste the contents into the top of your config file. Modify existing network message section if needed.
Add the overrides to CfgExileCustomCode

**initplayerlocal.sqf**

After `if (!hasInterface || isServer) exitWith {};` paste the contents of initplayerlocal.sqf found in the Client folder

If you are having trouble please view the example mission included.

### Server

**Code**

Server overrides are in client\customcode\server folder if they are needed to be moved or modified for server side. Otherwise no further modification is needed
Pbo the server folder and place inside your servermod folder (such as @ExileServer)

For support feel free to post in Exile Discord #support channel: https://discord.gg/cmMMHyJ

Unless something is broken or missing in this initial release I will not provide support or installation help, you are free to use this release as you wish.

Thank you!
