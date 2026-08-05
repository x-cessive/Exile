# Read-only sanity checks for the extDB3-backed Exile persistence layer.
# Uses the live extDB3 config without printing credentials.

[CmdletBinding()]
param(
    [string]$ServerDir = 'E:\arma3server',
    [string]$MysqlExe = 'C:\Program Files\MariaDB 10.11\bin\mysql.exe'
)

$ErrorActionPreference = 'Stop'
$results = @()

function Add-Result([string]$Name, [string]$Status, [string]$Detail) {
    $script:results += [pscustomobject]@{ check = $Name; status = $Status; detail = $Detail }
}
function Pass($n, $d) { Add-Result $n 'PASS' $d }
function Fail($n, $d) { Add-Result $n 'FAIL' $d }

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

function Write-NoBom([string]$Path, [string]$Text) {
    $encoding = New-Object System.Text.UTF8Encoding($false)
    [System.IO.File]::WriteAllText($Path, $Text, $encoding)
}

function Invoke-Mysql([string]$Sql) {
    $out = & $MysqlExe "--defaults-extra-file=$script:defaults" '--batch' '--raw' '--skip-column-names' $script:database '--execute' $Sql 2>&1
    if ($LASTEXITCODE -ne 0) { throw ($out -join [Environment]::NewLine) }
    $out
}

$conf = Join-Path $ServerDir '@ExileServer\extdb3-conf.ini'
$ini = Join-Path $ServerDir '@ExileServer\sql_custom\exile.ini'
if (-not (Test-Path -LiteralPath $conf)) { throw "Missing extDB3 config: $conf" }
if (-not (Test-Path -LiteralPath $ini)) { throw "Missing extDB3 SQL_CUSTOM file: $ini" }
if (-not (Test-Path -LiteralPath $MysqlExe)) { throw "Missing mysql client: $MysqlExe" }

$sections = Select-String -LiteralPath $ini -Pattern '^\[(.+?)\]' | ForEach-Object { $_.Matches[0].Groups[1].Value }
$requiredSections = @(
    'isKnownAccount',
    'createAccount',
    'startAccountSession',
    'endAccountSession',
    'getAccountStats',
    'loadPlayer',
    'loadVehicle',
    'loadContainer',
    'loadTerritory',
    'updatePlayer',
    'updateVehicle',
    'updateContainer',
    'maintainTerritory'
)
foreach ($name in $requiredSections) {
    if ($sections -contains $name) { Pass "sql-section-$name" 'present' } else { Fail "sql-section-$name" 'missing' }
}

$db = Read-IniSection -Path $conf -Section 'exile'
foreach ($required in 'Username','Password','IP','Port','Database') {
    if (-not $db.ContainsKey($required) -or -not $db[$required]) {
        throw "extDB3 config is missing [exile] $required"
    }
}

$script:database = $db['Database']
$stamp = Get-Date -Format 'yyyyMMdd-HHmmss'
$script:defaults = Join-Path $env:TEMP "xcsv-mysql-$stamp.cnf"
$defaultsText = @"
[client]
host=$($db['IP'])
port=$($db['Port'])
user=$($db['Username'])
password=$($db['Password'])
"@

try {
    Write-NoBom -Path $script:defaults -Text $defaultsText
    $tables = Invoke-Mysql 'SHOW TABLES;'
    foreach ($table in 'account','player','vehicle','container','territory') {
        if ($tables -contains $table) {
            $count = Invoke-Mysql "SELECT COUNT(*) FROM ``$table``;" | Select-Object -First 1
            Pass "db-table-$table" "$count rows"
        } else {
            Fail "db-table-$table" 'missing'
        }
    }
    $recent = Invoke-Mysql @'
SELECT 'player', COALESCE(CAST(MAX(last_updated_at) AS CHAR), '') FROM player
UNION ALL SELECT 'vehicle', COALESCE(CAST(MAX(last_updated_at) AS CHAR), '') FROM vehicle
UNION ALL SELECT 'container', COALESCE(CAST(MAX(last_updated_at) AS CHAR), '') FROM container
UNION ALL SELECT 'territory', COALESCE(CAST(MAX(last_paid_at) AS CHAR), '') FROM territory;
'@
    foreach ($line in $recent) {
        if ($line -match '^(\w+)\s+(.*)$') { Pass "db-recent-$($Matches[1])" $Matches[2] }
    }
} finally {
    if (Test-Path -LiteralPath $script:defaults) { Remove-Item -LiteralPath $script:defaults -Force }
}

$results | Format-Table -AutoSize
if (@($results | Where-Object status -eq 'FAIL').Count) { exit 1 }
