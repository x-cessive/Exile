# PRISON-GRAYBOX-001 - Eden Prep Checkpoint

GitHub issue: https://github.com/x-cessive/XCSV/issues/28

## Architect Override

Architect explicitly authorized The Prison Project to begin before
`XCSV-DRONE-001` reaches runtime verification. `XCSV-DRONE-001` remains
`PARTIAL_DEPLOYED`; drone/counter-UAS runtime proof is still pending and must not
be represented as complete.

## Current Source Custody

- Current mission source: `E:\ExileRepo\LiveSource\mpmissions\Exile.Tanoa`
- Canonical Eden mission candidate:
  `E:\ExileRepo\LiveSource\mpmissions\Exile.Tanoa\mission.sqm`
- Current static-object convention:
  `E:\ExileRepo\LiveSource\mpmissions\Exile.Tanoa\initServer.sqf`
- Live mission PBO:
  `E:\arma3server\mpmissions\Exile.Tanoa.pbo`

Current hashes recorded before any prison map mutation:

| artifact | SHA256 |
|---|---|
| `mission.sqm` | `11B504C4743EE648B6C0AEE7CF722828ECD7DE8B671600B9218D325B5C9B9105` |
| `initServer.sqf` | `15BA4963870E41986F7802C4E8B2A7406383CA31E70817BA6C32B4164D04F22B` |
| live `Exile.Tanoa.pbo` | `40C746125B278505112CD8D3FE6AC9BB9425235F7ECAE02B5B1F5AA31D0D9E28` |

No live server state was changed for this checkpoint.

## Stale Documentation Corrections

Older documentation still references `E:\ArmaTools\mission\Exile.Tanoa` and
32-bit/extDB2 launch assumptions. The current reconciled source path for prison
work is `E:\ExileRepo\LiveSource\mpmissions\Exile.Tanoa`, and the live server is
the x64/extDB3 stack supervised by XCSV GUARD.

## Graybox Custody Decision

Use direct Eden-authored `mission.sqm` / Eden mission source for
`PRISON-GRAYBOX-001`.

Do not move the first graybox into `Objects-Server-Side` or a runtime spawn file.
The server-side object addon path can be evaluated after the graybox exists and
object count/performance/custody tradeoffs are measurable.

## Candidate Sites For Architect Review

These are inspection candidates only. Terrain slope and visual fit remain
`UNKNOWN` until Architect reviews them in Eden.

| id | anchor | approximate footprint | orientation | notes |
|---|---:|---:|---:|---|
| `A_NORTH_CENTRAL_COAST` | `[7140,11800,0]` | 520m x 360m | 35 deg | Coastal/dock concept, road-network potential, must verify separation from north trader/spawn activity. |

## Selected Site: A_NORTH_CENTRAL_COAST (2026-08-12)

Architect selected `A_NORTH_CENTRAL_COAST`, anchor `[7140,11800,0]`, footprint
`520m x 360m`, heading `35 deg`.

`tools/eden/prison_graybox_build.sqf` is the parametrized graybox builder for the
selected site. Run in Eden after loading `prison_graybox_tools.sqf`:

```
execVM "tools\eden\prison_graybox_tools.sqf";
execVM "tools\eden\prison_graybox_build.sqf";
```

The builder creates the perimeter, towers, gatehouse/intake band, cellblocks,
max-sec/SHU, medical/workshop, armory/utilities and dock staging as ONE undoable
history step in the `PRISON_*` layers. Every classname used is verified against
the running-server classdump. The builder never saves `mission.sqm`; the accepted
layout remains editable Eden source under Git custody. Terrain slope/visual fit
remain to be accepted in Eden before any `PASS_GRAYBOX_VERIFIED` claim.
| `B_EAST_INLAND_APPROACH` | `[13300,10400,0]` | 560m x 380m | 315 deg | Isolated approach and good sight-line concept, dock support uncertain. |
| `C_WESTERN_COASTAL_EDGE` | `[4400,11850,0]` | 500m x 340m | 80 deg | Strong transfer-dock flavor, but contaminated-zone separation and road approach need visual proof. |

## Eden Helper Tooling

- `tools\eden\prison_site_candidates.sqf` creates temporary candidate comments
  and footprint markers in an undoable `PRISON_SITE_CANDIDATES` layer.
- `tools\eden\prison_graybox_tools.sqf` defines narrow helpers for layers, line
  placement, major mass placement and selected-object baseline measurement.
- Mission-local copies are available under
  `LiveSource\mpmissions\Exile.Tanoa\tools\eden\`, so Eden can run:
  `execVM "tools\eden\prison_site_candidates.sqf";`

The helpers use Eden APIs only as construction aids. The resulting accepted
objects must remain editable in Eden.

## Runtime Deployment (2026-08-12, temporary in-game test)

The Eden builder is `is3DEN`-gated and cannot run headless, so a temporary
server-side graybox was added for in-game inspection pending the accepted Eden
layout:

- `LiveSource\mpmissions\Exile.Tanoa\xcsv\fn_prisonGraybox.sqf` spawns the
  selected site (anchor `[7140,11800,0]`, heading `35 deg`) terrain-snapped via
  `setPosATL`, gated by `XCSV_PRISON_GRAYBOX_TEST` (default true). This is
  TEMPORARY test geometry; canonical custody stays with the Eden-authored
  mission source once accepted.
- Hooked at the end of `LiveSource\mpmissions\Exile.Tanoa\initServer.sqf`.
- Packed with `tools\pbo\pbo.ps1`; round-trip verified (363 files each way, zero
  path deltas, prefix `Exile.Tanoa`, checksum OK).
- Live PBO backed up to
  `E:\arma3server\mpmissions\Exile.Tanoa.pbo.20260812-011829.PRECAGE.bak`
  (SHA256 `40C746125B278505112CD8D3FE6AC9BB9425235F7ECAE02B5B1F5AA31D0D9E28`).
  Deployed PBO SHA256
  `E337E72407F62A521C97FB917D750974F52CC0FFF81ADB66C14D0E5A3E68D79B`
  (4,401,405 bytes, 362 entries).
- Server RPT `arma3server_x64_2026-08-12_01-19-44.rpt` confirms:
  `[PRISON-GRAYBOX-001] building A_NORTH_CENTRAL_COAST runtime graybox` and
  `[PRISON-GRAYBOX-001] graybox spawned: 441 wall segments, tower/mass
  placements done`.
- Source committed in `E:\ExileRepo` as `c213636`.

## Stop Condition

This checkpoint stops before permanent prison geometry. Next required action is
Architect visual inspection of the runtime graybox in game and the site in Eden.

Verdict: `RUNTIME_GRAYBOX_DEPLOYED` (temporary test only, awaiting Architect
in-game and in-Eden acceptance before `PASS_GRAYBOX_VERIFIED`).
