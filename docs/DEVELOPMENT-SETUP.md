# Development environment for an Arma 3 Exile server

Everything needed to build, run and modify an Exile server, in dependency order.

Third-party software is **linked, not vendored** â€” most of it is licence-restricted,
some is hundreds of megabytes, and all of it goes stale. The only binaries-equivalent
in this repo are the PowerShell tools under [`tools/`](../tools/README.md), which are
original work.

---

## Required

### 1. Arma 3 dedicated server â€” Steam app `233780`

Free; does not require an Arma 3 licence. Installed via SteamCMD:

```
steamcmd +force_install_dir <path> +login <user> +app_update 233780 validate +quit
```

Anonymous login works for the dedicated server itself. Downloading `@Exile` from the
Workshop (item `1487484880`) **does** require a real Steam account that owns Arma 3.

> The dedicated-server package ships stripped PBOs â€” `characters_f.pbo` is 57 MB against
> the client's 597 MB. Configs are intact, models and textures are not. Size differences
> against a client install are expected and not corruption.

### 2. SteamCMD

<https://developer.valvesoftware.com/wiki/SteamCMD>

Also the update path for the server and for Workshop mods.

### 3. Exile Mod 1.0.4 / 1.0.4a

- **Server side** â€” `@ExileServer`, plus the MySQL schema. The complete stock pack is
  archived in this repo at
  `editor-tools/ExileServer-1.0.4a.zip`, which is useful as a
  clean baseline to diff a live install against.
- **Client side** â€” `@Exile`, Steam Workshop item `1487484880`. Required on the server
  *and* by every player.

### 4. MySQL or MariaDB

Exile persists everything through extDB2. MariaDB 10.11 LTS is a safe choice.

- Bind to `127.0.0.1` unless you deliberately want remote access.
- Exile needs `sql-mode` relaxed â€” see `reference/Change Msql Strict Mode.txt`
  (written for MySQL 5.7 paths; adapt for MariaDB's `my.ini`).
- Import `MySQL/exile.sql` from the server pack, then apply the `upgrade-*.sql` files in
  order.

### 5. extDB2

Ships inside `@ExileServer`. **Critically, the 1.0.4a pack contains 32-bit `extDB2.dll`
and `XM8.dll` only.** The 64-bit server looks for `extDB2_x64.dll`, does not find it, and
runs with no database at all â€” with no obvious error. Either run the 32-bit
`arma3server.exe`, or source 64-bit builds of both extensions (or migrate to extDB3).

Requires the Visual C++ redistributables (2013 and 2015â€“2022).

### 6. PBO tooling

Use [`tools/pbo/pbo.ps1`](../tools/pbo/pbo.ps1) in this repo. It covers everything needed
for mission and addon work with no install.

Only reach for external tools when you need to *binarise* models/configs or extract a
compressed PBO:

- **Arma 3 Tools** â€” Steam app `233800`, free. AddonBuilder, CfgConvert, FileBank.
- **Mikero's tools** â€” ExtractPbo, MakePbo, pboProject, DeRap.

---

## Strongly recommended

### BEC â€” BattlEye Extended Controls

<https://github.com/TheGamingChief/BattlEye-Extended-Controls>

Scheduled restarts with staged in-game warnings, scheduled announcements, admin chat
commands, whitelisting, kick/ban management. Talks to the server over BattlEye RCon, so
it needs `RConPassword` / `RConPort` set in `battleye/BEServer_x64.cfg` (the x64 server
reads the `_x64` filename; the 32-bit server reads `BEServer.cfg`).

Exile server FPS degrades over hours â€” a restart cycle every 3â€“4 hours is standard
practice, not an optimisation.

### A code editor with SQF support

- **VS Code** + the SQF Language extension, and `SQFLint` for static checking.
- Catches syntax errors before they become RPT archaeology, which matters a lot given how
  much of this repo is unvalidated 2017-era SQF.

### A database client

HeidiSQL or DBeaver against the `exile` schema. Useful for inspecting player/territory
state and for the SQL that most addons require.

### 3DEN editor tooling (client-side)

Needed to place map objects, trader cities and custom bases:

- **M3Editor / m3e_3den** â€” <https://github.com/maca134/m3e_3den>
- **Exile 3DEN plugin**

Both are archived in `editor-tools/`. Load them as client mods
in the editor, never on the server. Export via `Addons/Objects-Server-Side` to keep custom
buildings server-side and out of a stealable mission PBO.

---

## Situational

| Need | Tool |
|---|---|
| Custom loot tables | `LootTableCompiler-1.0.3b.zip`, or `Addons/exile-loot-compiler-js` (needs [Node.js](https://nodejs.org/)) |
| Native loot-drop replacement | `ExileLootDrop/` â€” C# source, needs a .NET build. **Build 32-bit to match a 32-bit server exe.** |
| Trader/price setup | `Scripts/Trader-Mod` class lists, `reference/*.xlsx` pricing sheets |
| Player mod distribution | A3Launcher, or a Steam Workshop Collection |
| Performance monitoring | Arma Server Monitor (ASM) by Fred41 â€” reports server FPS and thread load |
| Headless client | A second Arma 3 instance to offload AI; wanted by FuMS and blckeagls/GMS |

**Deliberately not recommended:** infiSTAR (commercial, licence-locked; nothing here
expects it) and GUI PBO managers (superseded by `tools/pbo/pbo.ps1`).

---

## Firewall / ports

| Port | Protocol | Purpose |
|---|---|---|
| 2302 | UDP | Game port |
| 2303 | UDP | Steam query |
| 2304â€“2306 | UDP | Steam/BattlEye ancillary |
| 3306 | TCP | MySQL â€” **localhost only** unless you have a reason |

Open `2302â€“2306/UDP` inbound for the server executable. Note the rule must point at the
executable you actually run â€” if you switch between the 32-bit and 64-bit server, repoint
it.

---

## Gotchas worth knowing up front

1. **`-autoInit` is mandatory** for an unattended server. Without it the dedicated server
   boots fully â€” host created, BattlEye up â€” and then sits in an empty lobby, never
   initialising the mission, so the database is never touched. It looks like a broken
   install and produces no error.
2. **32-bit vs 64-bit decides more than performance** â€” see extDB2 above. It also decides
   which `Scripts/Statusbar-32-64Bit-master` file you use and how you build ExileLootDrop.
3. **`Warning Message: ...dependent on downloadable content that has been deleted.\na3_characters_f`
   is noise.** It appears on a vanilla server running a mission that declares zero addons.
   Do not chase it.
4. **Most addons are not one-file installs.** A typical one has a server PBO, mission-side
   files, a SQL import, BattlEye filter exceptions, and sometimes a client mod. Installing
   the server half alone yields a server that starts fine and a feature that does not
   exist. See the main [README](../README.md) for which parts each addon needs.
