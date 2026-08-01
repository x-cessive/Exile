# Verified installs

Things in this repository that have been **installed and confirmed running** on a live server,
with the exact integration steps and anything that bit along the way.

Test environment: Arma 3 `2.20.152984` (32-bit dedicated server), Exile `1.0.4a`, Exile Mod
client `1.0.4.2` (Workshop `1487484880`), MariaDB 10.11.11, map Tanoa.

"Verified" here means the server boots, the addon's own init appears in the RPT, and
`tools/diagnostics/rpt-triage.ps1` reports no new errors. It does **not** mean the feature has
been exercised by a player — anything requiring a live client is marked accordingly.

| Item | Type | Status | Player-tested |
|---|---|---|---|
| `Addons/DMS_Exile` | Mission system | Running — AI groups spawning | n/a (server-side) |
| `Addons/a3_exile_occupation-development` | AI spawner | Running — V71 starts ~20s after mission | n/a (server-side) |
| `Addons/bigfoots-shipwrecks` | Loot | Running — crates populated at boot | n/a (server-side) |
| `Addons/DMD_BuildingReplace` | Map | Loaded | n/a (server-side) |
| `Addons/Exile_Abandon_Territory` | Territory | Installed, `exile_abandon ready` | **no** |
| `Addons/Claim-Vehicles` | Vehicles | Installed, pre/postInit clean | **no** |
| `Addons/ExileLoadouts` | Loadouts | Installed — XM8 app + locker menu, server PBO live | **no** |
| `Addons/PlayerMarketByCyunide` | Economy | Installed — XM8 App05, DB table present | **no** |
| `Addons/ExileRevive` | Revive | Installed — network `ReviveRequest` + defibrillator | **no** |
| `Addons/Trick-Or-Treat` | Event | Installed — Halloween flag action, server PBO live | **no** |
| Virtual Garage | Stock Exile VG, no addon | Shix `VirtualGarage_Server.pbo` **removed** (redundant) | n/a (stock) |
| `Scripts/Exile-Anti-Floating-bug-script-aka-stair-bug` | QoL | Installed | **no** |
| `Scripts/Statusbar-32-64Bit-master` | HUD | Installed — 12 indicators, `RscTitles` created | **no** |
| `Addons/ExilePersistentVehicles` | Vehicles | Running — hooks confirmed, 58 vehicles spawned | n/a (server-side) |
| `Scripts/Exile-Safezone-Markers` | Map | Installed — `initServer` call | **no** |
| `Scripts/Build-Limits` | Building | Installed — `ExileBuildHeightLimit = 150` | **no** |
| `Scripts/Exile_auto_Reload_melee_weapons` | QoL | Installed — `CfgExileCustomCode` checkSafezone override | **no** |
| `Scripts/Exile_Block_Floor_Peeking` | Security | Installed — merged `initialize` + `stats_update` overrides | **no** |
| `Scripts/Exile-fix-drone-uav-stealing` | Security | Installed — merged `initialize` `WeaponAssembled` event handler | **no** |
| `Scripts/ExileMod-CruiseMode` | QoL | Installed — merged `onKeyUp` override (User8 keybind) | **no** |
| `Scripts/ExileMod-HolsterPlus` | QoL | Installed — merged `onKeyUp` + `onKeyDown` + `stats_reset` | **no** |
| `Scripts/ExileMod-StopMoaning` | Audio | Installed — `event_hook` `SoundPlayed` event handler | **no** |
| `Scripts/Exile-large-numbers-in-Xm8` | UI | Installed — `xm8_slide_apps_onOpen` formatted values | **no** |

---

## Addons vs Scripts — what actually differs

Less than the folder split suggests.

- **`Addons/`** items usually ship a **server PBO** plus mission-side files, and often SQL and
  BattlEye filters. The server half must be packed (or is pre-packed) and dropped into
  `@ExileServer/addons/`.
- **`Scripts/`** items are almost always **mission-side only** — a folder of `.sqf` plus a call
  from `initPlayerLocal.sqf`, sometimes a `config.cpp` entry. No PBO to build, no database, and
  usually no BattlEye exception.

So scripts are the *cheaper* category, not a lesser one. Both need the mission rebuilt, which is
the step that used to be the blocker; `tools/pbo/pbo.ps1` removes it.

---

## Exile_Abandon_Territory (MGTDB)

Server PBO was already present. Mission side:

1. `Client/abandon.sqf` → mission root.
2. In `config.cpp`, `class CfgInteractionMenus` → `class Flag` → `class Actions`, add the
   `AbandonTerritory` action from the README.

   Use the README's condition, **not** the one in `Client/config.cpp`. The bundled version omits
   the `ExileFlagStolen` check, which would let a raider abandon a territory they had just stolen:

   ```cpp
   condition = "((typeOf ExileClientInteractionObject) isEqualTo 'Exile_Construction_Flag_Static' && (call ExileClient_util_world_isInOwnTerritory) && ((ExileClientInteractionObject getvariable ['ExileFlagStolen',1]) isEqualTo 0))";
   ```

3. **BattlEye — this one matters.** `abandon.sqf` calls `publicVariableServer "abandon"`, and the
   stock `publicvariable.txt` rule is `7 ""`. Action 7 is log + kick + **ban**, so without an
   exception the first player to use the feature is banned. Append the exceptions to the existing
   rule lines rather than adding new ones (a new line is a new, more punitive rule):

   ```
   publicvariable.txt   7 "" !="abandon"
   deleteVehicle.txt    1 "" … !"Exile_Construction_Flag_Static"
   ```

Confirmed by `"exile_abandon ready"` in the RPT.

## Claim-Vehicles (MezoPlays)

Server PBO already present. Mission side:

1. `ClaimVehicles_Client/` → mission root.
2. `exile_server/code/ExileServer_system_garbageCollector_deleteObject.sqf` → somewhere in the
   mission (here `ClaimVehicles_Client/custom/`), then register it in `CfgExileCustomCode`:

   ```cpp
   ExileServer_system_garbageCollector_deleteObject = "ClaimVehicles_Client\custom\ExileServer_system_garbageCollector_deleteObject.sqf";
   ```

   This override adds one early exit — `if (_object getVariable ["claimed", false]) exitWith {}`
   — so the garbage collector stops deleting claimed vehicles. Skip it and the feature appears to
   work, then silently loses vehicles on the next cleanup pass.

3. Add the `ClaimVehicle` action to `CfgInteractionMenus`. The bundled `EXAMPLE_Config.cpp` shows
   one class; this mission has `class Car` and `class Air`, so it went in both.
4. `initPlayerLocal.sqf`: `[] execVM "ClaimVehicles_Client\ClaimVehicles_Client_init.sqf";`

Confirmed by `ClaimVehicles_Server_fnc_preInit` / `_postInit` in the RPT.

## Exile-Anti-Floating-bug (script)

Append the contents of its `initplayerlocal.sqf` to the mission's `initPlayerLocal.sqf`. That is
the entire installation — no PBO, no config, no database, no BattlEye. It registers a 1-second
Exile thread task that zeroes player velocity when stuck in a fall animation near ground level.

---

## Player Market By Cyunide

Server PBO: `@ExileServer/addons/PlayerMarketByCyunide.pbo` (pre-packed, has `.bisign` + bikey in
the repo; the live server uses the bare PBO — see note below).

Mission side:

1. `mission/MarketByCyunide/` → mission root (includes `CfgFunctions.cpp`, `Functions/` with the
   client response/UI handlers).
2. `description.ext`: add `class CfgFunctions { #include "MarketByCyunide\CfgFunctions.cpp" };`.
   This exposes `CyFs_fnc_RequestBuy` and `CyFs_fnc_doSearch`, which the XM8 slide's buttons call.
3. `config.cpp`:
   - `CfgXM8` gains `class cyMachine` (`appID = "App05"`) and `class cyMachineSell`.
   - `XM8_App05_Button` → Player Market (opens `XM8SlideCyunide`).
   - `XM8SlideCyunide` + `XM8SlideCyunideSell` controls (idc 85150–85166) pasted from the addon's
     install config; all `RscExileXM8*` parents exist in `RscDefines.hpp`.
   - `CfgNetworkMessages`: `getItemGUIRequest/Response`, `listItemPlayerMarketRequest`,
     `listPlayerMarketResponse`, all `module = "system_transport"`.
4. `initPlayerLocal.sqf`: register the four client functions (two network responses, two slide
   `onOpen` handlers).
5. `exile.ini` already contains the 10 PlayerMarket queries — no edit needed.
6. DB: `playermarket` table created by `install/playermarket.sql`.

**BattlEye**: the addon uses `ExileClient_system_network_send`, so no publicVariable exceptions
are needed.

**Bisign note**: the repo's `PlayerMarketByCyunide.pbo` ships signed (`.bisign`); the live server
runs the bare PBO. Keep them in sync — a signed PBO with a missing/rotated bikey will be rejected
when BattlEye is enforcing signatures.

Confirmed by `PlayerMarketByCyunide_fnc_preInit` / `_postInit` in the RPT. **Not player-tested.**

---

## Exile Revive (Enigma)

There are **two unrelated "Enigma revive" implementations** in the repo. Do not mix them:

| Implementation | Protocol | Server PBO |
|---|---|---|
| `Scripts/Enigma_Exile_Revive/` (classic) | `publicVariableServer "ENIGMA_revivePlayer"` + server `addPublicVariableEventHandler` | `enigma_exile_revive.pbo` |
| `Addons/ExileRevive/` (this one) | Exile network message `ReviveRequest` → module `system_revive` | `revive_server.pbo` (built from `Server/revive_server/`) |

The classic PBO was present in `@ExileServer/addons` but its client counterpart (`Custom/EnigmaRevive/`)
was not installed, so it was silently inert. **It was removed** and replaced with `revive_server.pbo`
built from `Addons/ExileRevive/Server/revive_server/` (prefix `revive_server`). Backup of the
classic PBO: `E:\ArmaTools\be-backups\revive-replacement\enigma_exile_revive_CLASSIC.pbo`.

Mission side (only config — no client `.sqf` files needed):

1. `config.cpp`:
   - `CfgNetworkMessages`: `class ReviveRequest { module = "system_revive"; parameters[] = {"STRING"}; };`.
   - In `CfgInteractionMenus` → Player menu → `Revive: ExileAbstractAction` (title "Revive Player",
     condition `player distance ExileClientInteractionObject < 3 and !(alive ...) and
     (magazines player find 'Exile_Item_Defibrillator' >= 0)`, action sends `ReviveRequest` with
     `netId ExileClientInteractionObject`).
2. The server PBO compiles `ExileServer_system_revive_network_ReviveRequest` in preInit — no
   `CfgExileCustomCode` entry required.
3. `Exile_Item_Defibrillator` exists in the stock item list; its trader price is commented out in
   `CfgTrading` (as shipped). The shipwrecks addon places defibrillators in loot crates, so the item
   is obtainable.

Confirmed by `revive_server_fnc_preInit` / `_postInit` in the RPT. **Not player-tested.**

---

## GADD Trick-Or-Treat

Server PBO: `@ExileServer/addons/GADD_TrickOrTreat_Server.pbo` (pre-packed).

Mission side (client folder from `Addons/Trick-Or-Treat/Client/`):

1. `GADD_Apps/TrickOrTreat/` → mission root (config, `GADD_TrickOrTreat_Request.sqf`,
   `ExileClient_gaddTT_network_trickOrTreatResponse.sqf`, `GADD_TreatList.sqf`, `Sounds/` 6 ogg,
   `Tricks/` 4 sqf).
2. `description.ext`: add `class CfgSounds` with the 6 ogg files (`Knock1/2`, `Laugh1/2/3`,
   `TrickOrTreat1`).
3. `config.cpp`:
   - Top of file: `#include "GADD_Apps\TrickOrTreat\config.cpp"` (defines `GADDTrickOrTreat`
     settings).
   - `CfgNetworkMessages`: `getFlagKnocked` (module `gaddTT`), `trickOrTreatResponse` (module
     `gadd`).
   - `CfgInteractionMenus` → Construction → `TrickOrTreat: ExileAbstractAction` (condition: target
     is `Exile_Construction_ConcreteGate_Static`/`ConcreteDoor_Static` **and** date is Oct 31).
4. `initPlayerLocal.sqf`: register 5 client functions (`ExileClient_gadd_network_TrickOrTreatResponse`,
   `GADD_TrickOrTreat_Request`, and the 3 trick handlers).
5. `exile.ini` already has the GADD queries (`getKnockedList`, `updateFlagKnocked`).
6. DB: run `TrickOrTreat.SQL` → `territory.knocked` column exists (verified 0 rows, empty).

Auto-disables outside Halloween via the date condition — safe to leave installed year-round.

Confirmed by `GADD_TrickOrTreat_Server_fnc_preInit` + "Starting GADD Trick or Treat Server side" /
"Finished Loading" in the RPT. **Not player-tested.**

---

## Exile Loadouts (Andrew_S90)

Server PBO: `@ExileServer/addons/Server.pbo` (repacked with prefix `loadout_server` from
`Addons/ExileLoadouts/Server/loadout_server/`).

Mission side (client folder from `Addons/ExileLoadouts/Client/`):

1. `custom/loadouts/` → mission root (27 `.sqf` + `loadoutDialog.hpp`).
2. `description.ext`: `#include "custom\loadouts\loadoutDialog.hpp"` (dialog idd 47147,
   `RscExileLoadoutDialog`). Must be included **after** `RscDefines.hpp`.
3. `config.cpp`:
   - `CfgLoadout`: `ServerName = "QuieteSpace"` (no spaces, unique), `MaxLoadouts = 5`,
     `BlockedItems[]` copied verbatim from the addon's client config.
   - `CfgNetworkMessages`: `purchaseLoadoutRequest` / `purchaseLoadoutResponse`
     (`module = "system_trading"`).
   - `CfgInteractionMenus` → `Locker` (target `Exile_Locker`, stock class) → `Loadout` action
     (`condition = "player call ExileClient_util_world_isInTraderZone"`, action opens the dialog).
4. `initPlayerLocal.sqf`: set `ExileClientPlayerLoadoutServerName` / `Max` from config, register
   all 27 client functions.
5. `initServer.sqf`: server-side compile of `ExileClient_gui_loadoutDialog_calculateLoadoutPrice`
   and `ExileClient_gui_loadoutDialog_event_checkLoadout` (used to price/validate purchases
   server-side).
6. No database / hextension needed — purchases run through stock `setAccountScore` /
   fire-and-forget `system_trading`.

Confirmed by `loadout_server_fnc_preInit` / `_postInit` in the RPT. **Not player-tested.**

---

## Virtual Garage — stock, no addon

Stock Exile VG is fully configured and **is** the live feature; the Shix `VirtualGarage_Server.pbo`
is redundant (its own config comments say it "disables/displaces" the stock XM8 VG). It was removed
from `@ExileServer/addons` and committed to `E:\ArmaTools\be-backups\shix-vg-removal\`.

Evidence VG is stock-live: mission `CfgVirtualGarage` `enableVirtualGarage = 1`,
`numberOfVehicles[]` and `allowedVehicleTypes[]` populated, `clearInventoryOnStore = 1`; stock
`exile_client.pbo` ships `virtualGarageDialog` + `ExileClient_gui_virtualGarageDialog_show`; stock
`exile.ini` has the 4 VG queries; `virtual_garage` table exists (0 rows).

---

## StatusBar (kuplion, from Stats Bar by Creampie)

Mission-side only, no server PBO, no database, no BattlEye exception.

1. `Scripts/Statusbar-32-64Bit-master/StatusBar/` → mission `custom/StatusBar/`.
2. Rename **`32bit!!!!!!!!!  ExileServer_system_database_connect.sqf`** →
   `ExileServer_system_database_connect.sqf` into that folder. The 32-bit variant is the correct
   one here: this server runs `arma3server.exe` (x86) with extDB2. Taking the 64-bit file would
   query a database handle that does not exist on this build.
3. `config.cpp` → `class CfgExileCustomCode`:

   ```cpp
   ExileServer_system_database_connect = "custom\StatusBar\ExileServer_system_database_connect.sqf";
   ```

   This override is what feeds the "players online" counter — the stock function does not expose it.
4. `description.ext`: this mission had **no `RscTitles` class at all** (only `Header`,
   `CfgFunctions`, `CfgSounds`, `CfgRemoteExec`). The README assumes one exists. Create it:

   ```cpp
   class RscTitles
   {
       #include "custom\StatusBar\statusBar.hpp"
   };
   ```
5. `initPlayerLocal.sqf`: `[] execVM "custom\StatusBar\statusBar_init.sqf";`

**Path case.** The script ships referencing `Custom\StatusBar\...`; this mission uses lowercase
`custom/`. Arma's PBO lookup is case-insensitive so either works, but the files were normalised to
lowercase for consistency. Beware when scripting that fix: PowerShell's `-replace` and `-ne` are
both case-**insensitive**, so the naive rewrite silently no-ops. Use `-creplace` / `-cne`.

**Layout bug — fixed here, not upstream.** As shipped, `statusBar.hpp` sets a pixel-derived height
against a normalised font size:

```cpp
y = safeZoneY + safeZoneH - 40 * pixelH;
h = 30 * pixelH;      // pixel-scaled
size = 0.04;          // normalised (fraction of screen height)
```

30 px is ~2.8% of screen height at 1080p but only ~1.4% at 2160p, while the glyphs stay 4% tall
regardless. On a 4K display the text overflows its control and renders visibly cut in half. Fixed by
making both values normalised:

```cpp
y = safeZoneY + safeZoneH - 0.055;
h = 0.05;
```

Restart times for the countdown indicator live in `statusBar_update.sqf`
(`_restartTimes = [0,6,12,18,24];`). **This server has no scheduled restart task**, so that
countdown is currently decorative — either add a restart task or edit the array to match reality.

Indicators: health, hunger, thirst, temperature, body damage, respect, wallet, locker, players
online, FPS, compass, restart countdown.

---

## ExilePersistentVehicles (Andrew_S90) — random vehicle spawner

Server-side only. No client or mission changes.

```powershell
E:\ArmaTools\pbo.ps1 Pack -Path <build>\vehicles -Out E:\arma3server\@ExileServer\addons\vehicles.pbo -Prefix vehicles
```

Prefix **must** be `vehicles` (matches the shipped `$PREFIX$`), or its `CfgFunctions` paths will not
resolve.

**Retuned from the shipped defaults — do not ship those as-is.** The upstream config is written for
Altis and is far heavier than it looks:

| Class | Shipped | Here | Active |
|---|---|---|---|
| `PersistantVehiclesRandom` → RandomVehicles | 100 | **30** | yes |
| → RandomHeli | 15 | **8** | yes |
| → RandomBoats | 40 | **12** | yes |
| → RandomTanks | 5 | 5 | **no** |
| → RandomAPC | 5 | 5 | **no** |
| `PersistantVehiclesRoad` → RandomVehicles | 15 | **8** | yes |
| `PersistantVehiclesTown` → RandomVehicles | 35 | 35 | **no** |
| `PersistantVehiclesLocation` → RandomHeli | 10 | 10 | **no** |

Active total went from **170 → 58**. Every one is a persistent row in the `vehicle` table, so the
shipped numbers cost both server FPS and database growth permanently.

`BigTowns[]` shipped as `{"Kavala","Athira","Pyrgos"}` — Altis towns, none of which exist on Tanoa.
Changed to `{"Georgetown","Lijnhaven","La Rochelle"}`. Only matters if `PersistantVehiclesTown` is
switched on, but leaving Altis names in a Tanoa config is a trap for the next reader.

`PersistantVehiclesLocation` ships `Active = 0` with a list of hardcoded **Altis** coordinates.
Leave it off unless you replace every coordinate with Tanoa ones.

It works by **hooking**, not overriding — it redirects `ExileServer_object_vehicle_database_load`
and `ExileServer_world_initialize` to its own copies and calls on to the originals. Confirmed in RPT:

```
VehicleServer - Hooked ExileServer_object_vehicle_database_load to redirect to vehicles\code\hooks\...
VehicleServer - Hooked ExileServer_world_initialize to redirect to vehicles\code\hooks\...
ExileServer - VehicleServer_world_spawnAllVehicles - Dynamic persistent vehicles spawned.
```

⚠ Its README states it was developed "with EXTDB2, no infistar and no battleye." This server runs
**both infiSTAR and BattlEye**. It loaded and spawned cleanly, but it has **not** been exercised with
BattlEye enforcing — see the BattlEye note at the bottom.

---

## Exile-Safezone-Markers (twist)

Mission-side only.

1. `Scripts/Exile-Safezone-Markers/*.sqf` → mission `custom/SafezoneMarkers/`.
2. Bottom of `initServer.sqf`:

   ```sqf
   call compile preprocessFileLineNumbers "custom\SafezoneMarkers\initSafezoneMarkers.sqf";
   ```

**Map-agnostic** — it discovers trader zones by scanning for markers of type
`ExileTraderZoneIcon`, so no Tanoa coordinates are needed. Defaults: safezone radius 125 m, no-combat
radius 250 m, both enabled. Tunable at the top of `initSafezoneMarkers.sqf`.

---

## Build-Limits

Mission-side only, client-side overrides.

1. `Scripts/Build-Limits/Build_Limits/` (4 files) → mission `custom/Build_Limits/`.
2. `config.cpp` → `class CfgExileCustomCode`:

   ```cpp
   ExileClient_construction_handleAbort = "custom\Build_Limits\ExileClient_construction_handleAbort.sqf";
   ExileClient_object_item_construct    = "custom\Build_Limits\ExileClient_object_item_construct.sqf";
   ExileClient_construction_threads     = "custom\Build_Limits\ExileClient_construction_threads.sqf";
   ```
3. `initPlayerLocal.sqf`: `execVM "custom\Build_Limits\config.sqf";`

   The README says `init.sqf`; this mission has no `init.sqf`. All three overrides are
   `ExileClient_*`, i.e. client-side, so `initPlayerLocal.sqf` is the correct home.

Height limit is `ExileBuildHeightLimit = 150;` in `config.sqf` (upstream default is 30).

---

## Method

Install **one thing per boot** and triage between. A ~90 second restart is cheap; untangling which
of four simultaneous changes broke something is not.

```powershell
tools\pbo\pbo.ps1 Unpack -Path mpmissions\Exile.Tanoa.pbo -Out work\Exile.Tanoa
#   ... edit ...
tools\pbo\pbo.ps1 Pack   -Path work\Exile.Tanoa -Out mpmissions\Exile.Tanoa.pbo
#   ... restart, then:
tools\diagnostics\rpt-triage.ps1
```

Back up the mission PBO before every rebuild. And note what the RPT **cannot** tell you: BattlEye
kicks never appear there. Anything marked "player-tested: no" above still carries kick risk until
a real client connects — see `tools/battleye/`.
