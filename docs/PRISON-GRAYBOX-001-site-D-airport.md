# PRISON-GRAYBOX-001 — Site D: Tanoa Airport

Proposed fourth candidate, added at the Architect's direction ("we need a spot
with a big open field...like maybe one of the airports?"). Sites A, B and C came
from the earlier `READY_FOR_ARCHITECT_SITE_SELECTION` checkpoint; none of them
were chosen for open flat ground.

## Anchor

| | value |
|---|---|
| anchor | `[7228, 6986]` |
| proposed footprint | 520 × 360 m |
| source | `Addons/a3_exile_occupation-development/source/a3_exile_occupation/config.sqf:212` |

That coordinate is not estimated from the map. It is the position this server
already uses to blacklist the airport from occupation missions:

```sqf
[[7228,6986,0],		250,	"Tanoa"]			// Tanoa Airport
```

## What already occupies the site

Two existing systems, both verified in source:

| system | extent | detail |
|---|---|---|
| occupation missions | 250 m | **already blacklisted here** — `a3_exile_occupation/config.sqf:212` |
| lootbox airfield spawn | 400 m | 3 boxes; `air`/`guerilla`/`car` vehicles; `ammo`, `asalt`, `sniper`, `scope`, `explosives`, `books` — `Addons/a3_exile_lootbox/config.sqf:594` |

The lootbox entry is keyed on Tanoa's `Airport` location type, not on a
coordinate, so it follows the airfield rather than a fixed point.

## Why it fits the issue #28 brief

- **Open flat ground, already cleared and road-connected** — the stated
  requirement, and the thing sites A/B/C did not obviously satisfy.
- **Institutional asset language.** Control tower, hangars, terminal and
  perimeter fencing read as infrastructure rather than as a military compound.
  Issue #28 explicitly warns against the prison feeling like "a decorative
  military compound".
- **Occupation missions are already excluded here**, which serves #28's
  "minimal conflict with existing high-value mission systems" better than the
  other three candidates.
- **It makes the helipad canon.** #28 asks for a helipad as an
  "emergency/security transfer point" and a dock for prisoner transfer. At an
  airfield, prisoner transfer by air becomes the reason the facility exists
  rather than a decorative afterthought.

## Recommendation: beside the apron, not on the runway

Building across the runway would do two bad things: destroy the airfield as a
usable location for anyone flying, and drop the compound directly on top of an
existing high-tier loot spawn with no separation.

Siting the compound alongside the apron instead keeps the runway flyable, gives
the prison ready-made approach roads and a perimeter to build against, and turns
the existing lootbox spawn into natural PvP pressure at the gates rather than a
collision.

Exact placement within the airfield is an Architect visual decision and is not
settled here.

## Status

`PROPOSED` — not accepted, not built.

Markers for A, B, C and D, plus rings for the two systems above, are placed in
the throwaway Eden working copy `PrisonWork.Tanoa` for visual inspection. Per
`PRISON-GRAYBOX-001-custody.md`, that copy is outside Git on purpose and nothing
from it is committed; only text SQF placements will be.

`XCSV-DRONE-001` (#27) remains `PARTIAL_DEPLOYED`. Nothing here changes that.

## Open question

This is the only Tanoa airfield with a hard coordinate anywhere in the repo.
Tanoa has smaller strips, but no config pins them, so they are not proposed here
rather than guessed at.
