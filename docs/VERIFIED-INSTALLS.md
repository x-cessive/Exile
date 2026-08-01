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
| `Addons/ExileLoadouts` | Loadouts | Server PBO repaired and loading | **no** |
| `Scripts/Exile-Anti-Floating-bug-script-aka-stair-bug` | QoL | Installed | **no** |

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
