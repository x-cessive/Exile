# Editor tools — CLIENT SIDE ONLY

> **Do not load anything in this folder on the server.** This directory was previously
> named `THIS IS FOR 3DEN EDITOR NOT FOR SERVER` to make that impossible to miss. The
> warning still applies — these are 3DEN editor mods for your Arma 3 *client*, not server
> addons. The one exception is `ExileServer-1.0.4a.zip`, which is a server archive kept
> here for reference.

| File | What it is |
|---|---|
| `@m3e_3den.rar` | M3Editor 3DEN plugin — place map objects, traders and custom bases, then export as SQF. Extract into your Arma 3 folder and load as a client mod. Upstream: [maca134/m3e_3den](https://github.com/maca134/m3e_3den) |
| `Exile3DEN-1.0.0.zip` | Exile's own 3DEN plugin — the internal tool the Exile team used to build the Tanoa mission |
| `LootTableCompiler-1.0.3b.zip` | Compiles custom Exile loot tables |
| `ExileServer-1.0.4a.zip` | The **stock Exile 1.0.4a server pack** — `exile_server.pbo`, `exile_server_config.pbo`, extDB2, XM8, BattlEye templates, all six stock missions and the MySQL schema. Useful as a clean baseline to diff a live install against |

To keep custom buildings out of a stealable mission PBO, export placements through
[`Addons/Objects-Server-Side`](../Addons/Objects-Server-Side) so they load server-side.
