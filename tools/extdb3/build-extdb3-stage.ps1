param(
    [string]$ServerDir = 'E:\arma3server',
    [string]$PboTool = 'E:\ExileRepo\tools\pbo\pbo.ps1',
    [string]$OutRoot = 'D:\CAGE\extdb3-stage'
)

$ErrorActionPreference = 'Stop'

function Copy-TextNoBom([string]$Path, [string]$Text) {
    $encoding = New-Object System.Text.UTF8Encoding($false)
    [System.IO.File]::WriteAllText($Path, $Text, $encoding)
}

function Convert-SqlCustomV2ToExtDb3([string]$Source, [string]$Destination) {
    $skip = @(
        'Number Of Inputs',
        'Number of Inputs',
        'Number Of Custom Inputs',
        'Number of Custom Inputs',
        'Prepared Statement Cache',
        'Sanitize Input Value Check',
        'Sanitize Output Value Check',
        'Strip',
        'Strip Chars Action',
        'Strip Custom Chars'
    )

    $lines = Get-Content -LiteralPath $Source
    $out = New-Object System.Collections.Generic.List[string]
    $out.Add('[Default]')
    $out.Add('Version = 1')
    $out.Add('Strip Chars = "\/\|;{}<>''"')
    $out.Add('Strip Chars Mode = 0')
    $out.Add('Input SQF Parser = false')
    $out.Add('')

    $inDefault = $false
    foreach ($line in $lines) {
        if ($line -match '^\[Default\]\s*$') {
            $inDefault = $true
            continue
        }
        if ($line -match '^\[') {
            $inDefault = $false
        }
        if ($inDefault) {
            continue
        }

        $trim = $line.Trim()
        $isSkipped = $false
        foreach ($key in $skip) {
            if ($trim -like "$key =*") {
                $isSkipped = $true
                break
            }
        }
        if (-not $isSkipped) {
            $out.Add($line)
        }
    }

    Copy-TextNoBom $Destination (($out -join [Environment]::NewLine) + [Environment]::NewLine)
}

function Assert-NoLeadingSlashEntries([string]$Pbo) {
    $list = & $PboTool List -Path $Pbo
    $bad = $list | Select-String -Pattern '^\s+\d+\s+\w+\s+\\\S'
    if ($bad) {
        throw "Packed PBO has leading-backslash entries: $($bad | Select-Object -First 1)"
    }
}

$stamp = Get-Date -Format 'yyyyMMdd-HHmmss'
$outDir = Join-Path $OutRoot $stamp
$workDir = Join-Path $outDir 'work\exile_server'
$bundleDir = Join-Path $outDir 'bundle'
$extDir = Join-Path $bundleDir '@ExileServer'
$pboOut = Join-Path $extDir 'addons\exile_server.pbo'

New-Item -ItemType Directory -Force -Path $workDir | Out-Null
New-Item -ItemType Directory -Force -Path (Split-Path -Parent $pboOut) | Out-Null
New-Item -ItemType Directory -Force -Path (Join-Path $extDir 'extDB\sql_custom') | Out-Null

$livePbo = Join-Path $ServerDir '@ExileServer\addons\exile_server.pbo'
$liveSql = Join-Path $ServerDir '@ExileServer\extDB\sql_custom_v2\exile.ini'
$quarantine = Join-Path $ServerDir '@ExileServer\_quarantine_20260801\extdb3'

& $PboTool Unpack -Path $livePbo -Out $workDir | Out-Null

$connect = @'
/**
 * ExileServer_system_database_connect
 *
 * XCSV extDB3 staged migration variant.
 */

private["_isConnected", "_result"];
_isConnected = false;
ExileServerDatabaseSessionId = "";
ExileServerRconSessionID = "";

try
{
    _result = "extDB3" callExtension "9:VERSION";
    if (_result isEqualTo "") then
    {
        throw "Unable to locate extDB3 extension!";
    };
    if ((parseNumber _result) < 1.027) then
    {
        throw format ["Update extDB3 to version 1.027 or later: %1", _result];
    };
    format ["Installed extDB3 version: %1", _result] call ExileServer_util_log;

    _result = parseSimpleArray ("extDB3" callExtension "9:ADD_DATABASE:exile");
    if (_result select 0 isEqualTo 0) then
    {
        throw format ["Could not add database: %1", _result];
    };
    "Connected to database!" call ExileServer_util_log;

    ExileServerDatabaseSessionId = str(round(random(999999)));
    _result = parseSimpleArray ("extDB3" callExtension format["9:ADD_DATABASE_PROTOCOL:exile:SQL_CUSTOM:%1:exile.ini", ExileServerDatabaseSessionId]);
    if ((_result select 0) isEqualTo 0) then
    {
        throw format ["Failed to initialize database protocol: %1", _result];
    };

    ExileServerStartTime = (call compile ("extDB3" callExtension "9:LOCAL_TIME")) select 1;
    "Database protocol initialized!" call ExileServer_util_log;
    "extDB3" callExtension "9:ADD_PROTOCOL:LOG:TRADING:Exile_TradingLog";
    "extDB3" callExtension "9:ADD_PROTOCOL:LOG:DEATH:Exile_DeathLog";
    "extDB3" callExtension "9:ADD_PROTOCOL:LOG:TERRITORY:Exile_TerritoryLog";
    "extDB3" callExtension "9:LOCK";
    _isConnected = true;
}
catch
{
    "MySQL connection error!" call ExileServer_util_log;
    "Please have a look at @ExileServer/extDB/logs/ to find out what went wrong." call ExileServer_util_log;
    format ["MySQL Error: %1", _exception] call ExileServer_util_log;
    "Server will shutdown now :(" call ExileServer_util_log;
};

_isConnected
'@

Copy-TextNoBom (Join-Path $workDir 'code\ExileServer_system_database_connect.sqf') $connect

Get-ChildItem -LiteralPath $workDir -Recurse -File -Include *.sqf,*.hpp,*.cpp | ForEach-Object {
    $text = Get-Content -LiteralPath $_.FullName -Raw
    $new = $text -replace '"extDB2"(\s*)callExtension', '"extDB3"$1callExtension'
    $new = $new -replace 'SQL_CUSTOM_V2', 'SQL_CUSTOM'
    if ($new -ne $text) {
        Copy-TextNoBom $_.FullName $new
    }
}

Convert-SqlCustomV2ToExtDb3 -Source $liveSql -Destination (Join-Path $extDir 'extDB\sql_custom\exile.ini')
Copy-Item -LiteralPath (Join-Path $quarantine 'root_extdb3-conf.ini') -Destination (Join-Path $extDir 'extdb3-conf.ini') -Force
Copy-Item -LiteralPath (Join-Path $quarantine 'root_extDB3.dll') -Destination (Join-Path $extDir 'extDB3.dll') -Force
Copy-Item -LiteralPath (Join-Path $quarantine 'root_extDB3_x64.dll') -Destination (Join-Path $extDir 'extDB3_x64.dll') -Force

& $PboTool Pack -Path $workDir -Out $pboOut -Prefix 'exile_server' | Out-Null
& $PboTool Verify -Path $pboOut | Out-Null
Assert-NoLeadingSlashEntries $pboOut

$remaining = rg -n '"extDB2"\s*callExtension|SQL_CUSTOM_V2|LOCK_STATUS' $workDir
if ($LASTEXITCODE -eq 0) {
    $remaining | Set-Content -LiteralPath (Join-Path $outDir 'remaining-extdb2-sites.txt') -Encoding UTF8
    throw "extDB2 migration guard failed; see remaining-extdb2-sites.txt"
}

$sections = Select-String -LiteralPath (Join-Path $extDir 'extDB\sql_custom\exile.ini') -Pattern '^\['
$report = [pscustomobject]@{
    Stage = $outDir
    Pbo = $pboOut
    SqlSections = $sections.Count
    ExtDb3Dll = Test-Path (Join-Path $extDir 'extDB3_x64.dll')
}
$report | Format-List
