# Tools

Original tooling for working on an Arma 3 Exile server. Unlike the rest of this
repository — which is a collection of other people's addons — everything in here was
written for this repo and carries no third-party licence restrictions.

All scripts are dependency-free Windows PowerShell 5.1. No installer, no Steam login,
no GUI.

> **Paths.** Defaults point at `E:\arma3server` and `E:\ArmaTools\classes` because that
> is where this server lives. Every script takes parameters to override them — see
> `Get-Help <script> -Full`.

---

## `pbo/pbo.ps1` — pack, unpack and inspect PBOs

The gate on all mission-side work: installing most Exile addons means rebuilding
`Exile.<Map>.pbo`, and packing addon sources like DMS means building a PBO.

```powershell
.\pbo.ps1 List   -Path mpmissions\Exile.Tanoa.pbo
.\pbo.ps1 Verify -Path @ExileServer\addons\exile_server.pbo
.\pbo.ps1 Unpack -Path mpmissions\Exile.Tanoa.pbo -Out work\Exile.Tanoa
.\pbo.ps1 Pack   -Path work\Exile.Tanoa -Out mpmissions\Exile.Tanoa.pbo
.\pbo.ps1 Pack   -Path a3_dms -Out a3_dms.pbo -Prefix "x\addons\DMS"
```

Verified by round-tripping a stock `Exile.Tanoa.pbo` to the exact original byte length
with every entry hash-identical, and by building an `a3_dms.pbo` from
`Addons/DMS_Exile` that loads and runs in the engine.

**The prefix rule.** A PBO's `prefix` header property is how Arma resolves internal
paths. An addon PBO without one loads silently and then fails to find its own
`CfgFunctions` files. `Addons/ExileLoadouts/Server.pbo` ships with *no header
properties at all*, which is why it logs `Script loadout_server\bootstrap\fn_preInit.sqf
not found`; repacking it with `-Prefix loadout_server` fixes it.

**Limitation.** Reads and writes uncompressed entries only — which is what every Exile
mission and server addon uses. It deliberately *refuses* LZSS-compressed entries rather
than emit corrupt source. Only Mikero-packed mod PBOs are compressed (e.g.
`@Exile\addons\exile_client.pbo`, 684 of 711 entries); use Mikero's ExtractPbo or
Arma 3 Tools for those.

---

## `diagnostics/` — find what is actually broken

Most addons here were written for Arma 3 1.62–1.92. Very little of that is *syntactically*
broken on a modern build — Arma 3 removed almost no SQF commands, and this repo contains
zero uses of `setVehicleInit` / `processInitCommands`. What actually breaks is content
references: classnames that were renamed, moved behind DLC, or belong to mods you do not
run. You cannot find those by reading code, only by comparing against a running server.

### `sovran_classdump/` — ground truth

A one-shot server addon. Pack it, drop it in `@ExileServer/addons`, boot once, then
**remove it** — it writes megabytes to the RPT on every startup.

```powershell
..\pbo\pbo.ps1 Pack -Path .\sovran_classdump -Out sovran_classdump.pbo -Prefix sovran_classdump
```

It logs every class the running server knows across `CfgVehicles`, `CfgWeapons`,
`CfgMagazines`, `CfgAmmo`, `CfgGlasses`, `CfgFaces`, `CfgMarkers`, `CfgMarkerColors`,
`CfgVoice`, `CfgVehicleClasses` and `CfgMovesMaleSdr >> States` — about 18,700 names on a
stock Exile + Apex install.

Two engine quirks it works around, both of which silently corrupted earlier attempts:

- `diag_log` truncates a line at ~1024 characters, so batches are flushed by **string
  length**, not element count. Batching 200 names per line lost 68% of the dump.
- Each line therefore ends with a `count`/`emitted` self-check. Keep it. It is the only
  reason the truncation was caught.

### `extract-classdump.ps1`

Parses those RPT lines into sorted per-root class lists plus `ALL.txt`, cross-checks the
extracted totals against the addon's own `emitted=` counts, and rejects any token that
is not a valid identifier.

> `diag_log` wraps its output in double quotes, so the last name on every line arrives as
> `I_MRAP_03_F"`. The parser strips that; without it, roughly one name per line is
> silently corrupted.

### `check-classnames.ps1`

Diffs classnames referenced in addon sources against that ground truth.

```powershell
.\check-classnames.ps1 -Path ..\..\Addons\DMS_Exile
.\check-classnames.ps1 -Path ..\..\Addons -PerFolder
```

**This is a heuristic and produces false positives.** String literals in SQF are used for
plenty of things besides classnames. Output is a ranked triage list meaning "worth
checking", not "definitely broken". Real findings look like `Land_jbad_Fridge` (a
Chernarus map-mod object) or `Exile_Item_RazorWireKit_Long`; noise looks like
`diag_tickTime` or `CAN_COLLIDE`.

## `battleye/` — stop the anti-cheat kicking your players

BattlEye filters are the other half of "is this addon working", and the RPT cannot see
them. A missing exception does not log a script error — it kicks, and with Exile's stock
`scripts.txt` (action **7** = log + kick + ban) it bans. You only find out when a real
player tries to use a feature.

Filter action codes are a bitmask: `1` = log, `2` = kick, `4` = ban.

### `be-exception.ps1` — one kick, by hand

Turns a kick log entry into a correctly escaped exception and locates the rule it belongs
on. The `#N` in a kick record is the index of the rule that fired, counted over rule lines
only, ignoring comments — so it maps precisely back to a line.

```powershell
.\be-exception.ps1                                        # scan logs, print exceptions
.\be-exception.ps1 -Text 'execVM "thing.sqf"'             # convert a pasted string
.\be-exception.ps1 -Text '...' -Filter scripts -Rule 43   # show the target rule
.\be-exception.ps1 -Text '...' -Filter scripts -Rule 43 -Apply
```

Escaping is mechanical: every `"` becomes `\"`, every newline becomes `\n`, the result is
prefixed with `!=` and re-quoted. Doing that by hand is where filter edits go wrong.

### `be-autofilter.ps1` — watch and auto-fix

Tails `battleye\*.log`, groups repeated kicks, and turns them into exceptions.

```powershell
.\be-autofilter.ps1                     # one pass, propose only
.\be-autofilter.ps1 -Watch              # poll continuously
.\be-autofilter.ps1 -Mode Auto -Watch   # apply what clears the guards
.\be-autofilter.ps1 -ShowPending
.\be-autofilter.ps1 -ApplyPending 0
```

> **This is automated anti-cheat disablement.** The same rules that kick players for a
> broken mod script are the ones that catch cheaters. Four guards are on by default:
> propose-don't-apply; a protected list of cheat-vector filters (`setpos`, `createvehicle`,
> `remoteexec`, …) that are never auto-applied; a distinct-player threshold, because a
> broken mod kicks everyone while an exploit usually kicks one person; and a backup plus
> changelog for every write.
>
> BattlEye loads filters at server start, so an applied fix needs a restart.

Note it cannot be an Arma addon — SQF cannot read or write arbitrary files, and the
filters live outside the mission.

---

### `rpt-triage.ps1`

Classifies a server RPT into real problems vs known-harmless noise, collapsing repeated
errors and attributing them to an addon where the text names one.

```powershell
.\rpt-triage.ps1 -Detail
```

The noise list is empirically derived. Notably, `dependent on downloadable content that
has been deleted.\na3_characters_f` is **not** a real dependency failure — it appears on a
vanilla server running a mission that declares zero addons.
