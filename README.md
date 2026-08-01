# Exile server addon & script collection

A working collection of third-party addons, scripts, tools and reference data for
**Arma 3 Exile Mod 1.0.4 "Pineapple" / 1.0.4a**.

Nothing in this repository is original work. Every folder is a copy of someone else's release,
gathered here so a server can be rebuilt from one place. Authors, upstream repositories and licences
are listed per entry below â€” check the upstream before deploying anything, because several of these
projects have moved on since the copy here was taken.

**Repo status:** last commit 2021-11-14. Treat every folder as a 2018â€“2021 snapshot.

---

## What changed in this README

The previous version of this file was the contents of `reference/List Of Exile Scripts`, which
is a **wish-list** ("LIST OF MODS TO BE INSTALLED!!!"), not an inventory â€” followed by an unrelated
*Awesome README Templates* boilerplate block. It described roughly 50 things that are not in this
repository (A3XAI, AdminToolkit, bAdmin, IgiLoad, Air Drops, BRAma Recipes, Vector Building, Encrypted
PBO, Loot Positions, â€¦) and omitted most of what actually is here.

This README is generated from the actual folder contents.

---

## Repository layout

| Folder | Contents |
|---|---|
| [`tools/`](tools/README.md) | **Original tooling** â€” PBO packer, RPT triage, classname validation |
| [`docs/`](docs/DEVELOPMENT-SETUP.md) | Development environment setup and prerequisites |
| `Addons/` | 45 server-side addons and larger systems |
| `Scripts/` | 18 smaller mission-side scripts |
| `ExileLootDrop/` | C# source for maca134's loot-drop DLL extension |
| `ops/` | Server auto-restart and SteamCMD update batch files |
| `reference/` | Pricing spreadsheets, MySQL strict-mode fix, server rules, script wish-list |
| `editor-tools/` | 3DEN editor tooling + the stock Exile 1.0.4a server pack |

Everything outside `tools/` and `docs/` is third-party work under its authors' own
licences (see [Credits](#credits)). `tools/` and `docs/` were written for this repository.

**New here?** Start with [`docs/DEVELOPMENT-SETUP.md`](docs/DEVELOPMENT-SETUP.md) to get a
server running, then [`tools/README.md`](tools/README.md) for the packing and diagnostic
workflow, then the catalogue below to choose what to install.

---

## How to read the tables

**Ships** â€” what the folder actually contains:

- `PBO` â€” a ready-to-drop, pre-packed `.pbo`. Installable with no build tooling.
- `SRC` â€” source only. **You need a PBO packer** (Arma 3 Tools / AddonBuilder, Mikero's tools, or
  PBO Manager) before this can go on a server.
- `MIS` â€” mission-side files. They go *inside* your `Exile.<Map>.pbo`, which means unpacking and
  repacking the mission â€” again, a packer.

**Needs** â€” additional work beyond dropping in a file:

- `DB` â€” SQL to import, and usually new queries appended to `@ExileServer/extDB/sql_custom_v2/exile.ini`.
- `BE` â€” BattlEye filter exceptions, or players get kicked.
- `HC` â€” designed for, or much happier with, a headless client.
- `MOD` â€” requires a client-side mod that every player must also load.

---

## Anatomy of an Exile addon (why most of these are not one-file installs)

A typical Exile addon has up to five parts, and skipping any one of them leaves it silently broken:

1. **Server PBO** â†’ `@ExileServer/addons/`
2. **Mission files** â†’ inside `mpmissions/Exile.<Map>.pbo`, usually a folder plus edits to
   `config.cpp` (`CfgExileCustomCode`), `description.ext` and `initPlayerLocal.sqf`
3. **Database** â†’ a `.sql` import plus new query blocks in `exile.ini`
4. **BattlEye filters** â†’ exceptions in `battleye/scripts.txt`, `publicvariable.txt`, etc.
5. **Client mod** â†’ for the handful that need one (zombies, survival pack, VCOM as a mod)

The most common failure mode is installing 1 and 3 and forgetting 2. The server starts, the database
looks right, and the feature simply does not exist for players.

---

## Mission & AI systems

Pick **one** primary system. They all spawn AI and missions, and stacking them fights for the same
server budget.

| Name | Author | Ships | Needs | Notes |
|---|---|---|---|---|
| `Addons/DMS_Exile` | Defent & eraser1 | SRC | â€” | The de-facto standard Exile mission system, and a **hard dependency of Exile Occupation**. Upstream: [Defent/DMS_Exile](https://github.com/Defent/DMS_Exile). CC BY-NC-SA 4.0. |
| `Addons/a3_exile_occupation-development` | second_coming | PBO + SRC | DMS | Roaming/static/air/sea AI, survivor AI, loot crates, heli crashes, a public bus. **Will not run without `a3_dms`.** Upstream: [secondcoming/a3_exile_occupation](https://github.com/secondcoming/a3_exile_occupation). CC BY-SA 4.0. |
| `Addons/FuMS-HC-Exile` | horbin | PBO (3.4 MB) | HC | Fulcrum Mission System. The deepest and the most configuration-hungry. Read `Docs/` before touching it. Upstream: [horbin/FuMS-HC-Exile](https://github.com/horbin/FuMS-HC-Exile). |
| `Addons/ZCP-A3-Exile` | DevZupa | PBO | MIS | Zupa's Capture Points â€” timed capture bases as PvP magnets. Wiki: [DevZupa/ZCP-A3-Exile](https://github.com/DevZupa/ZCP-A3-Exile/wiki). Badges here say Exile 1.0.2, so it is the oldest system in the repo. |
| `Addons/a3_vemf_reloaded` | IT07 | SRC | â€” | VEMFr, town/location invasion missions. Upstream stopped in 2017: [IT07/a3_vemf_reloaded](https://github.com/IT07/a3_vemf_reloaded). |
| `Addons/A3_vemf_re-reloaded` | Porkeld (fork of IT07) | **PBO** | â€” | The maintained fork, and the only VEMF here that ships pre-packed (`a3_vemf_reloaded.pbo` + `_config.pbo`). Prefer this over the folder above. |
| `Addons/blckeagles-revisited-RC` | Ghostrider-GRG- | SRC + 3DEN PBO | BE | Full DMS alternative with built-in HC support and A3EDEN mission export. **Superseded upstream** â€” development moved to [GMS_RC](https://github.com/Ghostrider-DbD-/GMS_RC) + [GMSCore](https://github.com/Ghostrider-DbD-/GMSCore); get it from there instead. |
| `Addons/Sarge-AI` | Azroul13 (headers) | SRC | â€” | Faction-based AI that reacts to player *rating* â€” friendly AI turn hostile as your rating drops. Simulated PvE/PvP rather than mission-driven. Upstream: [Teh-Dango/Sarge-AI](https://github.com/Teh-Dango/Sarge-AI). |
| `Addons/VcomAI-3.0-3.3.2`, `Addons/VcomAI-3.0-develop` | genesis92x | MIS | â€” | **Not a mission system** â€” an AI *behaviour* overhaul (flanking, suppression, garrisoning) that makes whichever system above you choose far more dangerous. These are the **script versions** (`Vcom/` + `init.sqf` + `cfgFunctions.hpp` into the mission), so no CBA and no client mod. Upstream [genesis92x/VcomAI-3.0](https://github.com/genesis92x/VcomAI-3.0) is on hold as of 2023. |

---

## Zombies & creatures

| Name | Author | Ships | Needs | Notes |
|---|---|---|---|---|
| `Addons/ExileZ-Mod` | [FPS]kuplion, from ExileZ 2.0 by Patrix87 | PBO (570 KB) | DB, MOD | Dynamic zombie spawner, server-side, scales with players in a town; safezone-aware, optional exploding zombies and kill rewards. Requires the **Ryan's Zombies and Demons** client mod ([501966277](https://steamcommunity.com/sharedfiles/filedetails/?id=501966277)) and optionally RZ Infection ([614815221](https://steamcommunity.com/sharedfiles/filedetails/?id=614815221)). |
| `Addons/ExileReborn-Reborn_Zombies` | Happydayz / Enigma team | SRC | BE, MOD | The larger, heavier zombie option â€” 522 sqf files and its own BattlEye filters. |
| `Scripts/Alias-Anomaly-Creatures` | AliasCartoons, adapted for Exile by "aussie" | SRC | â€” | S.T.A.L.K.E.R.-style environmental anomalies. Original author's work: [patreon.com/aliascartoons](https://www.patreon.com/aliascartoons). |

---

## Economy & traders

| Name | Author | Ships | Needs | Notes |
|---|---|---|---|---|
| `Addons/PlayerMarketByCyunide` | Cyunide | PBO | DB, MIS | Player-to-player auction house as an XM8 app. Adds a `playermarket` table and six `exile.ini` queries. Upstream: [Cyunide/PlayerMarketByCyunide](https://github.com/Cyunide/PlayerMarketByCyunide). |
| `Addons/ExileBarterTrader` | Andrew_S90 | MIS | DB | Item-for-item trading, no poptabs. Configurable stock with per-item rarity. |
| `Addons/ExileSafeX` | Andrew_S90 | MIS | DB | Private per-player storage at traders, capacity scaling with respect. Prerequisite for MarXet-style setups. |
| `Addons/ExileVehicleCustomsMods` | Andrew_S90 | MIS | DB | Sell cosmetic vehicle attachments (RPG cages, camo nets) â€” anything placeable in the editor can be priced. |
| `Addons/A3EX_CMAT` v0.10 | El Rabito | SRC | â€” | Server-side custom mapping **and** custom traders â€” add trader towns without touching the mission PBO, which also keeps them out of the hands of PBO thieves. |
| `Scripts/Trader-Mod` | compiled by [CiC]red_ned | data | â€” | Not a script: a full trader/price data pack. Prebuilt trader configs plus class-name dumps for CUP, HLC, NIArsenal, RHS, ARMAV, BAF, Apex/Jets and vanilla. Feed into `exile_server_config`. |

---

## Vehicles

| Name | Author | Ships | Needs | Notes |
|---|---|---|---|---|
| `Addons/Arma-3-Exile-Virtual-Garage` | Shix (Shix07) | PBO | DB, MIS | Store vehicles out of world. Adds `virtual_garage` plus four `exile.ini` queries. Note Exile 1.0.4 has its own Virtual Garage â€” check you want this one before layering it. |
| `Addons/ExilePublicVirtualGarage` | Andrew_S90 | MIS | DB | Single-slot public garage, meant for an airfield or similar non-safezone spot. |
| `Addons/Claim-Vehicles` | MezoPlays | PBO | MIS | Claim non-persistent (mission/AI) vehicles with a code lock. Upstream: [MezoPlays/Claim-Vehicles](https://github.com/MezoPlays/Claim-Vehicles). |
| `Addons/AVS` | Rod-Serling, co-dev Vishpala | SRC | â€” | Advanced Vehicle System: persistent vehicle ammo, rearm points, weapon/ammo blacklists, thermal and night-vision limits including UAVs and statics. Config lives in `AVS_configuration.sqf`. |
| `Addons/ExilePersistentVehicles` | Andrew_S90 | MIS | â€” | Random **persistent** vehicle spawner with random / road / city / water / fixed-position modes. |
| `Addons/HalvPaintshop-Exile` | Halvhjearne | MIS | â€” | Vehicle and backpack paint shop. Upstream: [Halvhjearne/paintshop](https://github.com/Halvhjearne/paintshop). GPL. |
| `Addons/R3F Logistics` | Team R3F (Madbull) | MIS | BE | Lift, tow, and load cargo/vehicles into larger vehicles. Long-standing, well-documented ([EN documentation PDF](http://team-r3f.org/madbull/logistics/EN_DOCUMENTATION.pdf)). Ships its own BE filters â€” you will need them. |
| `Scripts/ExileMod-Advanced-Repair` | John | MIS | â€” | Repair and salvage engine/wheels with a selection menu. |
| `Scripts/Exilemod-Super-Advanced-Repair-System-SARS` v1.0 | Bones50 | MIS | â€” | The bigger sibling of the above. **Pick one, not both.** |
| `Scripts/Vehicle_Salvage` v1.0.1 | GADD (Gaming At Deaths Door) | MIS | â€” | Scroll-wheel salvage from destroyed vehicles with a progress bar. |
| `Addons/ExileIncomingMissile` | Andrew_S90 | MIS | â€” | Warning when a missile locks/launches at your vehicle. |
| `Scripts/A3WarningScript` | â€” | MIS | â€” | Same idea with sound + on-screen warning and a per-class blacklist. Redundant with the above. |

---

## Base & territory

| Name | Author | Ships | Needs | Notes |
|---|---|---|---|---|
| `Addons/Exile_Abandon_Territory` | MGTDB | PBO | BE, MIS | Lets players abandon a territory. Ships client `abandon.sqf` + `config.cpp` and BE filters for `deleteVehicle` and `publicvariable`. |
| `Addons/Abandon Flag` | â€” | PBO | MIS | A second, independent abandon implementation. Choose one; do not install both. |
| `Addons/ExileFlagHacking` | Andrew_S90 | MIS | DB | Hack a territory flag with `Exile_Item_Laptop` to steal its vehicles. Uses the `getKnockedList` / `updateFlagKnocked` queries. |
| `Addons/ExileBaseMover` | Andrew_S90 | MIS | â€” | **Admin tool** â€” relocate an entire base by moving its flag. |
| `Addons/ExileBuildCheck` | Andrew_S90 | MIS | â€” | Tells the player whether they can build where they are standing. Cuts a lot of support questions. |
| `Scripts/Build-Limits` | â€” | MIS | â€” | Build height caps. Drops into a `Custom/Build_Limits` folder in the mission. |
| `Addons/DMD_BuildingReplace` | DMD | PBO | â€” | Replaces non-enterable buildings (written for Chernarus) with enterable Arma 3 equivalents. Server-side only. |

---

## Survival, loot & farming

| Name | Author | Ships | Needs | Notes |
|---|---|---|---|---|
| `Addons/bigfoots-shipwrecks` v1.0.3 | Bigfoot | PBO | â€” | Underwater wrecks with loot crates, spawned at server start. Server-side only â€” genuinely a drop-in. APL-SA. |
| `Addons/ExileHelicrashes` | Andrew_S90 | MIS | â€” | Random helicopter crash sites at restart, with configurable loot and count. |
| `Addons/a3_exile_lootbox` v1.5 | nabek | SRC | â€” | Lootbox reward items. Badged for Arma 1.92 / Exile 1.0.4a â€” one of the newest things here. |
| `Addons/ClaimCrates` | â€” | SRC | â€” | Claimable supply crates. Builds on Claim-Vehicles and R3F WasteDumpOverride. Badged Exile 1.0.3. |
| `Scripts/Exile_Scavenge` v0.7 | â€” | MIS | â€” | Scavenge trash piles, bins and wrecks for loot. |
| `Scripts/Exile-Plants` | â€” | MIS | â€” | Plant and harvest crops (weed by default, retargetable). |
| `Addons/Farming-scripts-for-Extended-Survival-Pack-Mod` | ServerAtze | MIS | MOD | Weed and mushroom farms, ore/crystal mining. |
| `Addons/fishing-script-for-Extended-Survival-Pack-Mod`, `Scripts/FishingBoat` | JackFrost, modified by ServerAtze | MIS | MOD | Fishing, shore and boat variants. |
| `Addons/exile-tree-stay-down` | â€” | MIS | DB | Felled trees are written to MySQL and stay down across restarts. |

> The three Extended Survival Pack items require the **Extended Survival Pack** client mod by ServerAtze
> ([Workshop 1208270228](https://steamcommunity.com/sharedfiles/filedetails/?id=1208270228)) â€” 165 items,
> vehicles, skins and recipes. Its Workshop terms **do not permit redistribution inside a server/mod
> pack**; link players to a Steam Collection instead.

---

## Bounty & PvP

| Name | Author | Ships | Needs | Notes |
|---|---|---|---|---|
| `Addons/ExileBountySystem` | Andrew_S90 | MIS | â€” | Player bounty contracts. **Duplicated** at `Scripts/ExileBountySystem` â€” same content, ignore one. |
| `Addons/MostWanted` v1.5 | Taylor Swift & WolfkillArcadia | MIS | DB | Alternative bounty mod with extra anti-abuse handling. |

---

## Quality of life & UI

| Name | Author | Ships | Needs | Notes |
|---|---|---|---|---|
| `Scripts/Statusbar-32-64Bit-master` | â€” | MIS | â€” | HUD bar: players online, hunger, thirst, temp, health, respect, poptabs, locker, FPS, restart timer, compass. **It overwrites `ExileServer_system_database_connect.sqf` and ships separate 32-bit and 64-bit copies â€” pick the one matching the server exe you actually run.** |
| `Scripts/Exile-Safezone-Markers` | dtavana | MIS | â€” | Draws safezones on the map. Upstream: [dtavana/Exile-Safezone-Markers](https://github.com/dtavana/Exile-Safezone-Markers). |
| `Scripts/xsSpawn` | â€” | MIS | â€” | Custom spawn-point selection; `xs/` folder goes at the mission root. |
| `Scripts/ExAd-HaloParachute-Standalone` | Bjanski (ExAd) | MIS | â€” | HALO jump on spawn. Standalone extract from the ExAd suite ([bjanski.github.io/ExAd](http://bjanski.github.io/ExAd/)). |
| `Scripts/Exile-Anti-Floating-bug-script-aka-stair-bug` | â€” | MIS | â€” | One-file fix for the floating/stair-clipping bug â€” kills velocity instead of forcing prone. Highest value-per-line in the repo. |
| `Scripts/Helipad` | â€” | MIS | â€” | Helipad placement. |
| `Addons/ExileRevive` | Andrew_S90 | MIS | â€” | Revive system. |
| `Scripts/Enigma_Exile_Revive` v0.80 | Enigma | PBO | MIS | A second revive system. **Conflicts with the above â€” install exactly one.** |
| `Addons/Trick-Or-Treat` | [GADD]Monkeynutz | PBO | DB, MIS | Seasonal Halloween event that self-activates by date, so it is safe to leave installed all year. |

---

## Admin, mapping & tooling

| Name | Author | Ships | Notes |
|---|---|---|---|
| `Addons/Objects-Server-Side` | maca134 | PBO | Load custom map objects/buildings exported from M3Editor **server-side**, so they cannot be lifted out of your mission PBO. Includes `m3e_3den.pbo` and `exile_3den.pbo`. |
| `ExileLootDrop/` | maca134 | C# source | Replaces Exile's loot-drop function with a **native DLL extension** for speed and far more flexible loot tables. Needs a .NET build (`build.bat`, `ExileLootDrop.sln`) â€” **and the DLL's architecture must match your server exe**. Upstream: [maca134/ExileLootDrop](https://github.com/maca134/ExileLootDrop). CC BY-NC-ND 4.0. |
| `Addons/exile-loot-compiler-js` | â€” | Node | Loot-table compiler supporting arbitrarily nested groups/tables â€” finer control than the stock compiler. Needs [Node.js](https://nodejs.org/en/). |
| `editor-tools/` | â€” | archives | `@m3e_3den.rar` and `Exile3DEN-1.0.0.zip` (load as client mods in the 3DEN editor, **not** on the server), `LootTableCompiler-1.0.3b.zip`, and `ExileServer-1.0.4a.zip` â€” the **stock Exile 1.0.4a server pack**: `exile_server.pbo`, `exile_server_config.pbo`, extDB2, XM8, BattlEye templates, all six stock missions and the MySQL schema. Useful as a clean baseline to diff against. |
| `ops/autorestart.bat` | â€” | batch | Restart-on-exit loop. Hard-codes a public IP, `-cpuCount=4`, and a mod line of `@Exile;@Extended_Base_Mod;@NIArsenal;@ASDG_JR;@CBA_A3` with `-servermod=@exileserver;@ATS`. Retarget before use. Note it already uses `-autoinit`, which Exile needs in order to start the mission without waiting for a player. |
| `ops/download_arma3.bat` | â€” | batch | SteamCMD install/update for the dedicated server (app 233780). |
| `reference/` | â€” | docs | `Exile Balanced Pricing Generator.xlsx` and `Exile Vehicles.xlsx` (economy balancing), `Change Msql Strict Mode.txt` (the `sql-mode` fix Exile needs â€” the note targets MySQL 5.7 paths; adapt for MariaDB), `The steps to install Seelenlos Zeus on your server`, `General Rules` (server rules boilerplate), and `List Of Exile Scripts` (the wish-list that used to be this README). |

---

## Caveats worth knowing before you deploy

- **Age.** Everything targets Exile 1.0.4/1.0.4a and Arma 3 builds from 1.62â€“1.92. Arma 3 is well past
  that. Expect script errors and BattlEye kicks that the original authors never saw.
- **Dead links.** `exilemod.com` links throughout these READMEs are largely gone; the community forum
  now lives at **[exile.majormittens.co.uk](https://exile.majormittens.co.uk/)** with the same topic IDs,
  so an old `exilemod.com/topic/12345-...` URL usually resolves by swapping the domain.
- **Stale forks.** At minimum `blckeagles-revisited-RC` (â†’ GMS/GMSCore) and `a3_vemf_reloaded`
  (â†’ `A3_vemf_re-reloaded`) are outdated relative to upstream.
- **Duplicates and conflicts.** ExileBountySystem appears twice; ExileRevive vs Enigma Revive, the two
  Abandon addons, the two repair systems, and Virtual Garage vs Exile 1.0.4's built-in VG are all
  mutually exclusive choices.
- **Licences vary.** CC BY-NC-SA (DMS), CC BY-SA (Occupation), CC BY-NC-ND (ExileLootDrop), GPL
  (Paintshop), APL-SA (Shipwrecks), MIT, and several with no licence at all. There is no single licence
  covering this repository â€” respect each author's terms, especially the non-commercial ones.
- **Server architecture.** Exile's `extDB2.dll` and `XM8.dll` in the 1.0.4a pack are **32-bit only**, so
  a server loading them must run `arma3server.exe`, not `arma3server_x64.exe`. This decides which
  Statusbar file you use and which way you build ExileLootDrop.

---

## Credits

Every addon here belongs to its author. In alphabetical order of the names that appear in the source:
Alias (AliasCartoons), Andrew_S90, Azroul13, Bigfoot, Bjanski, Bones50, [CiC]red_ned, Cyunide, Defent,
DevZupa (Zupa), dtavana, El Rabito, Enigma, eraser1, [GADD]Monkeynutz, genesis92x, Ghostrider-GRG-,
Halvhjearne, Happydayz, horbin, IT07, JackFrost, John, kuplion, maca134, MezoPlays, MGTDB, nabek,
Patrix87, Porkeld, Rod-Serling, Sarge, second_coming, ServerAtze, Shix, Taylor Swift, Team R3F (Madbull),
Vishpala, WolfkillArcadia â€” and the Exile Mod team for the mod itself.
