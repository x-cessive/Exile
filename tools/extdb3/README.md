# extDB3 / 64-bit staging

These tools build an extDB3 candidate bundle without changing the live server.

Run:

```powershell
E:\ExileRepo\tools\extdb3\build-extdb3-stage.ps1
```

Output goes to `D:\CAGE\extdb3-stage\<timestamp>\bundle`.

The builder:

- unpacks the live `@ExileServer\addons\exile_server.pbo`;
- replaces direct `"extDB2" callExtension` sites with `extDB3`;
- replaces the database connect function with an extDB3 `SQL_CUSTOM` variant;
- converts the live `extDB\sql_custom_v2\exile.ini` into
  `extDB\sql_custom\exile.ini`;
- copies staged extDB3 DLL/config files from the 2026-08-01 quarantine;
- packs and verifies a candidate `exile_server.pbo`;
- fails if old `extDB2` call sites, `SQL_CUSTOM_V2`, `LOCK_STATUS`, or leading
  slash PBO entries remain.

Do not deploy the bundle until it has been tested against a cloned database or a
short maintenance-window boot. Keep the production server on `arma3server.exe`
until the candidate proves player load/save, vehicle/container persistence,
trading, territory, and XCSV custom queries.
