# PRISON-GRAYBOX-001 — source custody decision

Supersedes the custody model recorded in the `READY_FOR_ARCHITECT_SITE_SELECTION`
checkpoint of issue #28, which named "direct Eden-authored mission source /
`mission.sqm`" as the graybox custody model. That model does not survive contact
with Eden.

## The defect it fixes

Loading `Exile.Tanoa` in Eden rewrites `mission.sqm` from editable text into
binarized form — 51,319 bytes of `version = 52; class EditorData…` became 32,597
bytes beginning with the `\0raP` binarized-config magic, on load, with no `Save`
issued.

That breaks two of issue #28's own rules:

- *"Preserve: editable Eden source"*
- *"AI-generated helper scripts are construction tools, not a substitute for
  canonical editable map source."*

It cannot be undone after the fact: there is no `CfgConvert` and no Arma 3 Tools
install on this machine, and Eden exposes no unbinarized-save setting in the
profile.

## The decision

**Author in Eden on a throwaway copy. Commit placements as text SQF. Never
commit `mission.sqm`.**

This is not a new convention — it is the one this repository already uses.
`LiveSource/mpmissions/Exile.Tanoa/initServer.sqf` already carries 134 static
objects as plain text, exported by the Exile Mod 3DEN Plugin:

```sqf
["Land_WaterCooler_01_new_F", [2249.94, 8597.73, 1.87218], [0.00569499, -0.999984, 0], [0, 0, 1], false],
```

That form is diffable, reviewable, rollback-able, and already proven in
production here. Issue #28 deferred `Objects-Server-Side` until "after a
measurable graybox exists"; the binarization defect makes it the correct choice
*for* the graybox, not after it.

## How the work is arranged

| | path | under Git? | Eden may write? |
|---|---|---|---|
| canonical source | `E:\ExileRepo\LiveSource\mpmissions\Exile.Tanoa` | yes | **no** |
| Eden working copy | `…\Arma 3 - Other Profiles\Mr%2e%20Sage\mpmissions\PrisonWork.Tanoa` | no | yes |

The junctions that previously exposed the canonical source to Eden — under both
the `Mr.` and `Mr. Sage` profiles — have been removed. `Exile` no longer appears
in Eden's `MPMissions` list, which is the intended state. The working copy is
disposable: binarizing it costs nothing.

## Guard

`.git/hooks/pre-commit` refuses any staged `*.sqm` whose first bytes are the
`\0raP` magic, with recovery instructions. Verified: staging the binarized file
and committing is blocked; the text form commits normally.

This hook is local to the clone (`.git/hooks` is not tracked). If the estate ever
grows past this machine, promote the same check into CI.

## Site candidates

Written directly into the working copy's `mission.sqm` as six marker entities
(anchor icon plus footprint rectangle per site), so Eden renders them on load and
no debug-console scripting is needed:

| id | anchor | footprint | heading | colour |
|---|---|---|---|---|
| `A_NORTH_CENTRAL_COAST` | `[7140, 11800]` | 520 × 360 m | 35° | red |
| `B_EAST_INLAND_APPROACH` | `[13300, 10400]` | 560 × 380 m | 315° | blue |
| `C_WESTERN_COASTAL_EDGE` | `[4400, 11850]` | 500 × 340 m | 80° | green |

All three render correctly in Eden's 2D map view.

## Still open

Site selection remains an Architect decision, per issue #28. `XCSV-DRONE-001`
(#27) remains `PARTIAL_DEPLOYED`; nothing here changes that.
