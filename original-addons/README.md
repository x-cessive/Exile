# original-addons

Addons written for this server, as opposed to everything in `Addons/` and `Scripts/`,
which is other people's work. No third-party licence restrictions apply here.

Build any of these with the repo's own packer:

```powershell
tools\pbo\pbo.ps1 Pack -Path original-addons\<name> -Out <name>.pbo -Prefix <name>
```

then drop the `.pbo` into `@ExileServer\addons\` and restart.

| Addon | What it does | State |
|---|---|---|
| `sovran_zeus` | Grants the vanilla Zeus (Curator) interface to whitelisted Steam64 UIDs, so an admin can build and spawn live while players are connected. Server-side only — players need no mod. | Loads clean on Arma 3 2.20 / Exile 1.0.4a. **Not yet tested with a connected player.** |

## sovran_zeus notes

Eden (3DEN) is singleplayer-only; there is no live multiplayer Eden session. Zeus is the
multiplayer editor, and every curator class ships with the base game — which is why this needs
no download and no client mod. It does the same job as @SLZ (Seelenlos Zeus) in ~40 lines.

Three things to know before enabling it:

1. **Zeus placements are not persistent.** Anything spawned through Zeus is gone at the next
   restart. Permanent map edits belong in 3DEN/M3Editor, exported server-side via
   `Addons/Objects-Server-Side`.
2. **BattlEye will fight it.** Zeus spawns and deletes objects, tripping `createVehicle`,
   `deleteVehicle` and `setPos` — the cheat-vector filters that must never be auto-whitelisted.
   Run `tools/battleye/be-autofilter.ps1` in Propose mode while testing, then apply those
   specific exceptions by hand.
3. **A whitelisted UID can spawn anything.** Treat the list as a permission grant.

It polls rather than using a `PlayerConnected` handler on purpose: at PlayerConnected time the
player's unit does not exist yet, and Exile runs players through spawn selection before their
real unit appears.
