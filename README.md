<div align="center">

# 📦 Arma 3 Exile Mod Addon &amp; Script Repository

**The catalogue: third-party addons, scripts, schemas and the tooling that packs them.**

[![Project page](https://img.shields.io/badge/project_page-x--cessive.github.io%2FXCSV%2Fcatalogue-3FC16A.svg?style=for-the-badge)](https://x-cessive.github.io/XCSV/catalogue/)
[![Part of XCSV](https://img.shields.io/badge/part_of-XCSV-3D9CFF.svg?style=for-the-badge)](https://x-cessive.github.io/XCSV/)

[![Arma 3](https://img.shields.io/badge/Arma_3-2.20.152984-blue.svg?logo=steam&logoColor=white)](https://arma3.com/)
[![Exile Mod](https://img.shields.io/badge/Exile_Mod-1.0.4a_Pineapple-00b2cd.svg)](https://exile.majormittens.co.uk/)
[![MariaDB](https://img.shields.io/badge/Database-MariaDB_10.11-003545.svg?logo=mariadb&logoColor=white)](https://mariadb.org/)
[![extDB2](https://img.shields.io/badge/Database_Driver-extDB2_v71-00599c.svg)](https://github.com/x-cessive/Exile)
[![Addons](https://img.shields.io/badge/Addons-51_Systems-ffb400.svg)](https://github.com/x-cessive/Exile/tree/master/Addons)
[![Scripts](https://img.shields.io/badge/Scripts-29_Mods-2ea44f.svg)](https://github.com/x-cessive/Exile/tree/master/Scripts)
[![Status](https://img.shields.io/badge/Server_Status-Active_%26_Verified-brightgreen.svg)](docs/VERIFIED-INSTALLS.md)

</div>

> **Part of the XCSV system** ·
> [Overview](https://x-cessive.github.io/XCSV/) ·
> [GUARD](https://x-cessive.github.io/XCSV/guard/) ·
> [Addons](https://x-cessive.github.io/XCSV/addons/) ·
> **[Catalogue](https://x-cessive.github.io/XCSV/catalogue/)** ·
> [Docs](https://x-cessive.github.io/XCSV/wiki/Home.html)

---

A comprehensive, production-tested repository of third-party addons, scripts, administrative tools, database schemas, and custom engine modifications for **Arma 3 Exile Mod 1.0.4 / 1.0.4a ("Pineapple")**.

This is the **catalogue** half of XCSV: everything here is other people's work,
collected and version-controlled. Our own content lives in
[XCSV_ADDONS](https://github.com/x-cessive/XCSV_ADDONS) and never mixes with it.
The exception is `tools/`, which is ours.

This repository brings together a full suite of community-developed features, security fixes, economic systems, and AI frameworks into a unified, version-controlled codebase.

---

## 📂 Repository Directory Layout

| Directory | Description |
|---|---|
| 🛠️ **[`tools/`](tools/README.md)** | **Custom Engineering Tooling** — PowerShell PBO packer/unpacker (`pbo.ps1`), BattlEye RPT auto-triage (`be-autofilter.ps1`), and classname validation |
| 📖 **[`docs/`](docs/DEVELOPMENT-SETUP.md)** | Dedicated server setup instructions, prerequisite guides, and [Verified Live Installs Matrix](docs/VERIFIED-INSTALLS.md) |
| 📦 **[`Addons/`](Addons/)** | 51 server-side addons, AI patrol engines, economy frameworks, and dynamic events |
| 📜 **[`Scripts/`](Scripts/)** | 29 mission-side scripts, UI overlays, QoL fixes, and player interaction extensions |
| ⚡ **[`ExileLootDrop/`](ExileLootDrop/)** | Native C# DLL extension source for accelerated loot distribution |
| ⚙️ **[`ops/`](ops/)** | Server auto-restart loops, SteamCMD update scripts, and process management batch files |
| 📊 **[`reference/`](reference/)** | Economy balancing spreadsheets, MySQL strict-mode SQL fixes, and server governance rules |
| 🧱 **[`editor-tools/`](editor-tools/)** | 3DEN editor plugins (`@m3e_3den`), loot table compilers, and stock Exile 1.0.4a server pack backups |

---

## ⚡ Quick Start & Deployment Guide

### Prerequisites
* **Arma 3 Dedicated Server** (32-bit `arma3server.exe` required for `extDB2.dll` and `XM8.dll` compatibility)
* **MariaDB 10.11+** or **MySQL 5.7+** with strict mode disabled
* **Exile Mod 1.0.4a** server build & client files

### Quick Server Launch
1. **Database Setup**: Import `exile.sql` into MariaDB, followed by addon SQL migrations (`scratchie.sql`, `lockpick.sql`, etc.).
2. **Mission Packing**: Use `tools/pbo.ps1` to pack the working mission directory into `Exile.Tanoa.pbo`:
   ```powershell
   .\tools\pbo.ps1 Pack -Path E:\ArmaTools\mission\Exile.Tanoa -Out E:\arma3server\mpmissions\Exile.Tanoa.pbo -Prefix Exile.Tanoa
   ```
3. **Server Execution**: Launch `arma3server.exe` with active servermod parameters:
   ```powershell
   arma3server.exe -mod=@Exile -servermod=@ExileServer;@infiSTAR_A3_vision;@ScratchieServer -config=@ExileServer\config.cfg -cfg=@ExileServer\basic.cfg -profiles=E:\arma3server\profiles -bepath=E:\arma3server\battleye -name=exile -port=2302 -world=empty -autoInit -filePatching -showScriptErrors -noPause -noSound -cpuCount=12 -exThreads=7 -enableHT
   ```
   **`-filePatching` is mandatory** — A3XAI reads `a3xai_config.sqf` as a loose
   file and without the flag it silently ends the mission during world init,
   putting the server into a restart loop. **`-world=empty` is a server-only
   flag**; passing it to the game client causes an `ACCESS_VIOLATION` in the
   graphics driver at startup.

---

## 🧩 Addon & Script Feature Directory

### ⚔️ AI & Mission Patrol Systems

| System | Type | Description |
|---|---|---|
| **[`Addons/A3XAI`](Addons/A3XAI)** | **LIVE** | Autonomous AI spawner — dynamic infantry, vehicle patrols, and air search/destroy groups. |
| **[`Addons/DMS_Exile`](Addons/DMS_Exile)** | **LIVE** | De-facto standard Exile mission system; hard dependency for Exile Occupation. |
| **[`Addons/a3_exile_occupation-development`](Addons/a3_exile_occupation-development)** | **LIVE** | Ambient AI occupation: roaming infantry, vehicle convoys, air patrols, and sea traders. |
| **[`Addons/FuMS-HC-Exile`](Addons/FuMS-HC-Exile)** | Standby | Fulcrum Mission System — advanced Headless Client offloaded mission engine. |
| **[`Addons/ZCP-A3-Exile`](Addons/ZCP-A3-Exile)** | Standby | Zupa's Capture Points — dynamic timed territory capture events for PvP combat. |
| **[`Addons/A3_vemf_re-reloaded`](Addons/A3_vemf_re-reloaded)** | Standby | VEMFr town invasion missions and military compound assault events. |
| **[`Addons/VcomAI-3.0-3.3.2`](Addons/VcomAI-3.0-3.3.2)** | Standby | AI tactical combat overhaul (flanking, suppressed movement, garrisoning). |

---

### 💰 Economy, Traders & Gambling

| System | Type | Description |
|---|---|---|
| **[`Addons/a3-exile-scratchie`](Addons/a3-exile-scratchie)** | **LIVE** | XM8 app lottery & scratchcard mini-game with instant vehicle/poptab prize delivery. |
| **[`Addons/ExileTravellingTrader`](Addons/ExileTravellingTrader)** | **LIVE** | Dynamic mobile roaming trader vehicle navigating map markers across land and water. |
| **[`Addons/PlayerMarketByCyunide`](Addons/PlayerMarketByCyunide)** | **LIVE** | Player-to-player XM8 auction house and trade market. |
| **[`Addons/ExileFlagHacking`](Addons/ExileFlagHacking)** | **LIVE** | Hack territory flags with laptops to steal base vehicles (`FlagHack_server.pbo`). |
| **[`Addons/ExileBuildCheck`](Addons/ExileBuildCheck)** | **LIVE** | XM8 app checking whether players can build where they are standing. |
| **[`Addons/ExileBaseMover`](Addons/ExileBaseMover)** | Standby | Admin tool to relocate an entire base by moving its flag. |
| **[`Addons/ExileBarterTrader`](Addons/ExileBarterTrader)** | Standby | Item-for-item barter trade system without poptab currency. |
| **[`Addons/ExileVehicleCustomsMods`](Addons/ExileVehicleCustomsMods)** | Standby | Customizable vehicle cosmetic attachments (camo nets, RPG cages). |

---

### 🛡️ Territory Protection, Raiding & Base Building

| System | Type | Description |
|---|---|---|
| **[`Addons/A3ExileVPS`](Addons/A3ExileVPS)** | **LIVE** | Vehicle Protection System — makes locked territory vehicles invincible on server restart. |
| **[`Scripts/w4_lockpick`](Scripts/w4_lockpick)** | **LIVE** | Interactive lockpicking system for vehicles, safes, and territory doors with SQL logging. |
| **[`Addons/Claim-Vehicles`](Addons/Claim-Vehicles)** | **LIVE** | Claim non-persistent mission/AI vehicles with a custom code lock. |
| **[`Scripts/Build-Limits`](Scripts/Build-Limits)** | **LIVE** | Configurable base building height caps (`ExileBuildHeightLimit = 150`). |
| **[`Addons/Exile_Abandon_Territory`](Addons/Exile_Abandon_Territory)** | **LIVE** | Allows base owners to abandon territory flags and reclaim protection money. |
| **[`Addons/ExileFlagHacking`](Addons/ExileFlagHacking)** | Standby | Hack enemy territory flags using laptops to seize control of base vehicles. |

---

### 🕹️ User Interface & Quality of Life (QoL)

| Feature | Type | Description |
|---|---|---|
| **[`Scripts/Statusbar-32-64Bit-master`](Scripts/Statusbar-32-64Bit-master)** | **LIVE** | 12-indicator bottom HUD bar (Health, Hunger, Thirst, Temp, Respect, Wallet, FPS, Restart). |
| **[`Scripts/A3ExilePilotHUD`](Scripts/A3ExilePilotHUD)** | **LIVE** | Aircraft pilot HUD overlay displaying weapon ammo, flare count, and jet throttle. |
| **[`Scripts/Exile-Vanilla-Hud`](Scripts/Exile-Vanilla-Hud)** | **LIVE** | Native Arma 3 vehicle radar, speed, and gear indicator HUD overlay. |
| **[`Scripts/xsSpawn`](Scripts/xsSpawn)** | **LIVE** | Custom spawn selection screen with ground vs HALO jump selection and server tips. |
| **[`Scripts/Exile_auto_Reload_melee_weapons`](Scripts/Exile_auto_Reload_melee_weapons)** | **LIVE** | Fixes wood/mining axe reload requirement by automatically feeding magazines. |
| **[`Scripts/Exile_Block_Floor_Peeking`](Scripts/Exile_Block_Floor_Peeking)** | **LIVE** | Anti-floor peeking exploit fix preventing 3rd person camera clipping through building floors. |
| **[`Scripts/Exile-fix-drone-uav-stealing`](Scripts/Exile-fix-drone-uav-stealing)** | **LIVE** | Safezone UAV connection hijack fix (`WeaponAssembled` event handler). |
| **[`Scripts/ExileMod-CruiseMode`](Scripts/ExileMod-CruiseMode)** | **LIVE** | Driver vehicle cruise control toggle (`User8` keybind). |
| **[`Scripts/ExileMod-HolsterPlus`](Scripts/ExileMod-HolsterPlus)** | **LIVE** | Preserves selected weapon firemode state when holstering and unholstering. |
| **[`Scripts/ExileMod-StopMoaning`](Scripts/ExileMod-StopMoaning)** | **LIVE** | Mutes repetitive pain moaning audio loops after healing. |
| **[`Scripts/Exile-large-numbers-in-Xm8`](Scripts/Exile-large-numbers-in-Xm8)** | **LIVE** | Formats large poptab and respect values with readable commas (`100k` / `1m`). |
| **[`Scripts/Exile-Safezone-Markers`](Scripts/Exile-Safezone-Markers)** | **LIVE** | Dynamic map-agnostic safezone and non-combat circle markers. |
| **[`Addons/ExileRevive`](Addons/ExileRevive)** | **LIVE** | Defibrillator revive system with network request handlers. |

---

### 📦 Loot, Events & Survival

| Addon / Script | Type | Description |
|---|---|---|
| **[`Addons/Exile-Vehicle-Crash-Loot`](Addons/Exile-Vehicle-Crash-Loot)** | **LIVE** | Turn destroyed vehicle wrecks into lootable cargo containers. |
| **[`Addons/ExileHelicrashes`](Addons/ExileHelicrashes)** | **LIVE** | Random helicopter crash sites at server restart with configurable loot (`helicrash_server.pbo`). |
| **[`Addons/HalvPaintshop-Exile`](Addons/HalvPaintshop-Exile)** | **LIVE** | Vehicle and backpack paint reskin shop with SQL paint persistence (`ExileHalvPaintshop_Server.pbo`). |
| **[`Addons/ExileIncomingMissile`](Addons/ExileIncomingMissile)** | **LIVE** | On-screen & audio warning when a missile locks/launches at player's vehicle. |
| **[`Scripts/Exile_Scavenge`](Scripts/Exile_Scavenge)** | **LIVE** | Interactive hold-action scavenging for trash piles, bins, wrecks, and furniture. |
| **[`Addons/bigfoots-shipwrecks`](Addons/bigfoots-shipwrecks)** | **LIVE** | Dynamic underwater shipwreck loot crates spawned at server start. |
| **[`Addons/Trick-Or-Treat`](Addons/Trick-Or-Treat)** | **LIVE** | Date-triggered seasonal event adding interactive trick-or-treat flag rewards. |
| **[`Scripts/Blowout`](Scripts/Blowout)** | **TOGGLED OFF** | S.T.A.L.K.E.R. radioactive emission storm event (`ns_blowout = false;`). |
| **[`Addons/AVS`](Addons/AVS)** | **LIVE** | Advanced Vehicle System: rearm points, thermal/NVG restrictions, and ammo DB persistence (`AVS.pbo`). |
| **[`Addons/a3_exile_lootbox`](Addons/a3_exile_lootbox)** | **LIVE** | Lootbox reward items & prize crates (`a3_exile_lootbox.pbo`). |
| **[`Addons/ExileSafeX`](Addons/ExileSafeX)** | **LIVE** | Private player safe deposit storage at safezone trader lockers (`safex_server.pbo`). |
| **[`Addons/ExileZ-Mod`](Addons/ExileZ-Mod)** | Standby | Dynamic zombie spawner scaling with player presence in towns (requires RZ mod). |
| **[`Addons/ExileHelicrashes`](Addons/ExileHelicrashes)** | Standby | Dynamic helicopter crash sites with high-tier military loot drops. |

---

## 🔒 Security & Architecture Directives

1. **`CfgExileCustomCode` Overrides**: Every function override must be declared strictly in `config.cpp` under `class CfgExileCustomCode`. Competing overrides for the same function name must be cleanly merged into a single `.sqf` file.
2. **UI Control Class Redefinition Safety**: In `RscTitles` definitions, never name a control instance inside `class controls` with the name of a global base class (e.g., use `class PilotHUDText`, NOT `class RscStructuredText`).
3. **UI Attribute Types**: In UI `class Attributes`, integer properties (`shadow = 0;`, `underline = 0;`) must NOT be assigned boolean values (`shadow = false;`).
4. **32-Bit Server Architecture**: `arma3server.exe` (x86) is required for 32-bit `extDB2.dll` and `XM8.dll` extension compatibility.

---

## ⚠️ Read this before using `tools/pbo/pbo.ps1`

**Always list the entry paths after packing.** A PBO whose entries all begin with
a leading `\` passes a checksum verify and still breaks the server completely —
Arma resolves `<prefix>` + `\path`, finds nothing, and the server core silently
never loads. It produced **219 mission starts in eight minutes** here, and every
visible error was a *database* error.

```powershell
tools\pbo\pbo.ps1 Pack -Path <src> -Out <dst> -Prefix <prefix>
tools\pbo\pbo.ps1 List -Path <dst>      # not optional. Read the paths.
```

The cause was in the packer itself: `Resolve-Path` hands a path back in whatever
form it was given, so a source path containing an 8.3 short name
(`C:\Users\ARCHIT~1\…`) stayed short while directory enumeration returned the
long form. One character of difference left a separator on every entry path. It
now uses `Get-Item -LiteralPath` and refuses to pack a bad entry — **verify
anyway.**

The corruption is arithmetically visible: broken files are exactly one byte
larger per entry.

| pbo | good | broken | delta | entries |
|---|---:|---:|---:|---:|
| `exile_server.pbo` | 506,736 | 507,018 | +282 | 285 |
| `safex_server.pbo` | 22,956 | 22,967 | +11 | 11 |
| `Server.pbo` | 4,818 | 4,822 | +4 | 4 |

[XCSV GUARD](https://github.com/x-cessive/XCSV_GUARD) checks this on every poll
and refuses to start the server while any PBO fails.

---

## 📜 Credits & Author Attribution

All third-party addons and scripts in this repository remain the intellectual property of their respective creators:

* **Developers & Contributors**: *AliasCartoons, Andrew_S90, Azroul13, Bigfoot, Bjanski, Bones50, Cyunide, Defent, DevZupa, dtavana, El Rabito, Enigma, eraser1, [GADD]Monkeynutz, genesis92x, Ghostrider-GRG-, Halvhjearne, Happydayz, horbin, IT07, JackFrost, John, kuplion, maca134, MezoPlays, MGTDB, nabek, Patrix87, Porkeld, Rod-Serling, Sarge, second_coming, ServerAtze, Shix, Taylor Swift, Team R3F, Vishpala, WolfkillArcadia, ynpmoose*, and the **Exile Mod Team**.

---

<div align="center">
<sub>
Part of <a href="https://github.com/x-cessive/XCSV">XCSV</a> ·
<a href="https://x-cessive.github.io/XCSV/">site</a> ·
<a href="https://x-cessive.github.io/XCSV/wiki/Runbook.html">runbook</a> ·
<a href="https://github.com/x-cessive/XCSV_ADDONS">our own addons</a>
</sub>
</div>
