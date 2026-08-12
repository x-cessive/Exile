# XCSV Eden Tools

Read-only construction helpers for XCSV map-editing work.

These scripts are intended to be run manually from the Eden debug console after
opening the current Tanoa mission source:

`E:\ExileRepo\LiveSource\mpmissions\Exile.Tanoa`

They are construction aids, not canonical runtime systems. The accepted prison
layout must remain editable Eden source under Git custody.

## PRISON-GRAYBOX-001

Use this order:

1. Confirm the mission source is clean in Git.
2. Record `mission.sqm` SHA256 before any save.
3. Open `Exile.Tanoa` in Eden.
4. Run this from the Eden debug console:
   `execVM "tools\eden\prison_site_candidates.sqf";`
5. Architect visually inspects the `PRISON_SITE_CANDIDATES` layer and selects a
   site.
6. Record the selected anchor coordinate and orientation.
7. Only then run graybox helper functions from `prison_graybox_tools.sqf`.

Do not save candidate markers as accepted prison geometry unless Architect
explicitly chooses to keep them as evidence. They are temporary inspection aids.
