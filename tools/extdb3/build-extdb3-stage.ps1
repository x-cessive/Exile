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
            $normalized = $line -replace 'DateTime_ISO8601', 'STRING'
            $normalized = $normalized -replace '^SQl(\d+_\d+\s*=)', 'SQL$1'
            $out.Add($normalized)
        }
    }

    Copy-TextNoBom $Destination (($out -join [Environment]::NewLine) + [Environment]::NewLine)
}

function Read-IniSection([string]$Path, [string]$Section) {
    $values = @{}
    $inSection = $false
    foreach ($line in Get-Content -LiteralPath $Path) {
        $trim = $line.Trim()
        if ($trim -match '^\[(.+?)\]\s*$') {
            $inSection = ($Matches[1] -ieq $Section)
            continue
        }
        if ($inSection -and $trim -match '^([^;#][^=]+?)\s*=\s*(.*)$') {
            $values[$Matches[1].Trim()] = $Matches[2].Trim()
        }
    }
    $values
}

function Convert-ExtDb2ConfToExtDb3([string]$Source, [string]$Destination) {
    $db = Read-IniSection -Path $Source -Section 'exile'
    foreach ($required in 'Username','Password','IP','Port') {
        if (-not $db.ContainsKey($required)) {
            throw "extDB2 config is missing [exile] $required"
        }
    }
    $database = if ($db.ContainsKey('Database') -and $db['Database']) { $db['Database'] } else { $db['Name'] }
    if (-not $database) {
        throw 'extDB2 config is missing [exile] Database/Name'
    }

    $text = @"
[Main]
Version = 1
Randomize Config File = false
Allow Reset = false
Thread = 0

[exile]
IP = $($db['IP'])
Port = $($db['Port'])
Username = $($db['Username'])
Password = $($db['Password'])
Database = $database
"@
    Copy-TextNoBom $Destination ($text + [Environment]::NewLine)
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
New-Item -ItemType Directory -Force -Path (Join-Path $extDir 'sql_custom') | Out-Null

$livePbo = Join-Path $ServerDir '@ExileServer\addons\exile_server.pbo'
$liveExtDb3Sql = Join-Path $ServerDir '@ExileServer\sql_custom\exile.ini'
$liveExtDb2Sql = Join-Path $ServerDir '@ExileServer\extDB\sql_custom_v2\exile.ini'
$liveExtDb3Conf = Join-Path $ServerDir '@ExileServer\extdb3-conf.ini'
$liveExtDb2Conf = Join-Path $ServerDir '@ExileServer\extdb-conf.ini'
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
    "Please have a look at @ExileServer/logs/ to find out what went wrong." call ExileServer_util_log;
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

$sqlCustom = Join-Path $extDir 'sql_custom\exile.ini'
if (Test-Path $liveExtDb3Sql) {
    Copy-Item -LiteralPath $liveExtDb3Sql -Destination $sqlCustom -Force
} elseif (Test-Path $liveExtDb2Sql) {
    Convert-SqlCustomV2ToExtDb3 -Source $liveExtDb2Sql -Destination $sqlCustom
} else {
    throw 'No live extDB3 SQL_CUSTOM or extDB2 SQL_CUSTOM_V2 exile.ini found'
}
Copy-Item -LiteralPath $sqlCustom -Destination (Join-Path $extDir 'extDB\sql_custom\exile.ini') -Force
if (Test-Path $liveExtDb3Conf) {
    Copy-Item -LiteralPath $liveExtDb3Conf -Destination (Join-Path $extDir 'extdb3-conf.ini') -Force
} elseif (Test-Path $liveExtDb2Conf) {
    Convert-ExtDb2ConfToExtDb3 -Source $liveExtDb2Conf -Destination (Join-Path $extDir 'extdb3-conf.ini')
} else {
    throw 'No live extDB3 or extDB2 database config found'
}
foreach ($dll in 'extDB3.dll','extDB3_x64.dll') {
    $liveDll = Join-Path $ServerDir "@ExileServer\$dll"
    $quarantineDll = Join-Path $quarantine ("root_" + $dll)
    if (Test-Path $liveDll) {
        Copy-Item -LiteralPath $liveDll -Destination (Join-Path $extDir $dll) -Force
    } elseif (Test-Path $quarantineDll) {
        Copy-Item -LiteralPath $quarantineDll -Destination (Join-Path $extDir $dll) -Force
    } else {
        throw "Missing $dll in live @ExileServer and quarantine"
    }
}

& $PboTool Pack -Path $workDir -Out $pboOut -Prefix 'exile_server' | Out-Null
& $PboTool Verify -Path $pboOut | Out-Null
Assert-NoLeadingSlashEntries $pboOut

$remaining = rg -n '"extDB2"\s*callExtension|SQL_CUSTOM_V2|LOCK_STATUS' $workDir
if ($LASTEXITCODE -eq 0) {
    $remaining | Set-Content -LiteralPath (Join-Path $outDir 'remaining-extdb2-sites.txt') -Encoding UTF8
    throw "extDB2 migration guard failed; see remaining-extdb2-sites.txt"
}

$sections = Select-String -LiteralPath $sqlCustom -Pattern '^\['
$report = [pscustomobject]@{
    Stage = $outDir
    Pbo = $pboOut
    SqlSections = $sections.Count
    ExtDb3Dll = Test-Path (Join-Path $extDir 'extDB3_x64.dll')
}
$report | Format-List
