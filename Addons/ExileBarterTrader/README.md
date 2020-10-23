# ExileBarterTrader
Trade Items for random Trader Items, no currency involved

Fully customizable barter inventory, including min/max quantity, percent chance to appear and to not show an item if another is already in the list.

If you trade for items they will be gone and save for that restart so the stock there is what you get.

Showcase video: https://www.youtube.com/watch?v=jhmCA9vTrV8

This was developed on a test server with EXTDB2, no infistar and no battleye.


# Install Instructions:

### Client

**config.cpp**

Paste the contents into the top of your config file. Modify existing network message section if needed.

**description.ext**

Paste the contents anywhere after `#include "RscDefines.hpp"` appears in your description.ext file

**initplayerlocal.sqf**

After `if (!hasInterface || isServer) exitWith {};` paste the upper contents of initplayerlocal.sqf found in the Client folder

See the the lower portion of this file to see how to add actions to traders so you can open specific traders and their items

If you are having trouble please view the example mission included.

### Server

**Code**

No overrides needed, simply pbo the server folder and place inside your servermod folder (such as @ExileServer)

**SQL**

There is a table that is needed for this to function properly. Please execute the SQL on your Exile database

**Exile.ini**

Paste the contents at the bottom of your exile.ini **MODIFY** if using extdb3


For support feel free to post in Exile Discord #support channel: https://discord.gg/cmMMHyJ

Unless something is broken or missing in this initial release I will not provide support or installation help, you are free to use this release as you wish.

Thank you!
