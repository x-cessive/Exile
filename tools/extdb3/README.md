# extDB3 / 64-bit staging

These tools build an extDB3 bundle without changing the live server.

Run:

```powershell
E:\ExileRepo\tools\extdb3\build-extdb3-stage.ps1
```

Output goes to `D:\CAGE\extdb3-stage\<timestamp>\bundle`.

The builder:

- unpacks the live `@ExileServer\addons\exile_server.pbo`;
- replaces direct `"extDB2" callExtension` sites with `extDB3`;
- replaces the database connect function with an extDB3 `SQL_CUSTOM` variant;
- copies the live extDB3 `sql_custom\exile.ini` when present; otherwise
  converts the legacy `extDB\sql_custom_v2\exile.ini`;
- writes both `sql_custom\exile.ini` and the legacy mirror
  `extDB\sql_custom\exile.ini` for loader compatibility;
- copies the live extDB3 config when present; otherwise converts the legacy
  extDB2 database config shape;
- copies live extDB3 DLL files when present, with quarantine as a fresh-migration fallback;
- packs and verifies a candidate `exile_server.pbo`;
- fails if old `extDB2` call sites, `SQL_CUSTOM_V2`, `LOCK_STATUS`, or leading
  slash PBO entries remain.

Tracked recovery fragments:

- `xcsv-briefing-sql.ini` contains the four `xcsvBriefing*` SQL_CUSTOM sections
  deployed for XCSV-CHATTER-001. The live `exile.ini` remains authoritative, but
  this fragment records the exact query block needed if the live template is
  rebuilt or repaired by hand.

Production was migrated on 2026-08-05 to `arma3server_x64.exe` plus extDB3. A
healthy boot shows `extDB3_x64.dll`, `Connected to database!`, `Database
protocol initialized!`, and `Game world initialized! Let the fun begin!` in the
newest x64 RPT.
