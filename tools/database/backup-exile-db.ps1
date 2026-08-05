# Creates a MariaDB dump of the Exile database using the live extDB3 config.
# The password is written only to a temporary defaults file and is never printed.

[CmdletBinding(SupportsShouldProcess = $true)]
param(
    [string]$ServerDir = 'E:\arma3server',
    [string]$OutDir = 'D:\CAGE\xcsv-db-backups',
    [string]$DumpExe = 'C:\Program Files\MariaDB 10.11\bin\mysqldump.exe',
    [int]$Keep = 14
)

$ErrorActionPreference = 'Stop'

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

$conf = Join-Path $ServerDir '@ExileServer\extdb3-conf.ini'
if (-not (Test-Path -LiteralPath $conf)) { throw "Missing extDB3 config: $conf" }
if (-not (Test-Path -LiteralPath $DumpExe)) { throw "Missing mysqldump: $DumpExe" }

$db = Read-IniSection -Path $conf -Section 'exile'
foreach ($required in 'Username','Password','IP','Port','Database') {
    if (-not $db.ContainsKey($required) -or -not $db[$required]) {
        throw "extDB3 config is missing [exile] $required"
    }
}

if (-not (Test-Path -LiteralPath $OutDir)) {
    New-Item -ItemType Directory -Force -Path $OutDir | Out-Null
}

$stamp = Get-Date -Format 'yyyyMMdd-HHmmss'
$dump = Join-Path $OutDir "exile-$stamp.sql"
$defaults = Join-Path $env:TEMP "xcsv-mysqldump-$stamp.cnf"

$defaultsText = @"
[client]
host=$($db['IP'])
port=$($db['Port'])
user=$($db['Username'])
password=$($db['Password'])
"@

$args = @(
    "--defaults-extra-file=$defaults",
    '--single-transaction',
    '--quick',
    '--routines',
    '--events',
    '--triggers',
    '--databases',
    $db['Database'],
    "--result-file=$dump"
)
$createdDump = $false
if ($PSCmdlet.ShouldProcess($dump, 'create MariaDB dump')) {
    try {
        Write-NoBom -Path $defaults -Text $defaultsText
        $out = & $DumpExe @args 2>&1
        if ($LASTEXITCODE -ne 0) {
            throw ("mysqldump failed with exit code $LASTEXITCODE" + [Environment]::NewLine + ($out -join [Environment]::NewLine))
        }
        $createdDump = $true
    } finally {
        if (Test-Path -LiteralPath $defaults) { Remove-Item -LiteralPath $defaults -Force }
    }
}

if (-not $createdDump) {
    [pscustomobject]@{
        Dump = $dump
        SizeMb = $null
        Created = $null
        Retention = $Keep
        PlannedOnly = $true
    }
    return
}

$old = Get-ChildItem -LiteralPath $OutDir -Filter 'exile-*.sql' -ErrorAction SilentlyContinue |
    Sort-Object LastWriteTime -Descending |
    Select-Object -Skip $Keep
foreach ($file in $old) {
    if ($PSCmdlet.ShouldProcess($file.FullName, 'remove old database backup')) {
        Remove-Item -LiteralPath $file.FullName -Force
    }
}

$item = Get-Item -LiteralPath $dump
[pscustomobject]@{
    Dump = $item.FullName
    SizeMb = [math]::Round($item.Length / 1MB, 2)
    Created = $item.LastWriteTime
    Retention = $Keep
}
