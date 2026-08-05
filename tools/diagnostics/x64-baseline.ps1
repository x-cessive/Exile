# Captures an x64/extDB3 operating baseline for the live XCSV Exile server.
# Does not read or print credentials.

[CmdletBinding()]
param(
    [string]$ServerDir = 'E:\arma3server',
    [string]$OutDir = 'D:\CAGE\xcsv-baselines'
)

$ErrorActionPreference = 'Stop'

function New-Directory([string]$Path) {
    if (-not (Test-Path -LiteralPath $Path)) {
        New-Item -ItemType Directory -Force -Path $Path | Out-Null
    }
}

function Latest-File([string]$Path, [string]$Filter) {
    Get-ChildItem -LiteralPath $Path -Filter $Filter -ErrorAction SilentlyContinue |
        Sort-Object LastWriteTime -Descending |
        Select-Object -First 1
}

function Write-NoBom([string]$Path, [string]$Text) {
    $encoding = New-Object System.Text.UTF8Encoding($false)
    [System.IO.File]::WriteAllText($Path, $Text, $encoding)
}

function Read-LatestMetric([string]$ServerDir) {
    $meta = Join-Path $ServerDir '@infiSTAR_A3_vision\meta_data.log'
    if (-not (Test-Path -LiteralPath $meta)) { return $null }
    $line = Get-Content -LiteralPath $meta -Tail 200 -ErrorAction SilentlyContinue |
        Where-Object { $_ -match '\{.*\}' } |
        Select-Object -Last 1
    if (-not $line) { return $null }
    $json = [regex]::Match($line, '\{.*\}').Value
    try { $json | ConvertFrom-Json } catch { $null }
}

function Select-RptEvidence([string]$RptPath) {
    if (-not (Test-Path -LiteralPath $RptPath)) { return @() }
    Get-Content -LiteralPath $RptPath -ErrorAction SilentlyContinue |
        Select-String -Pattern 'arma3server_x64|-maxMem|Allocator|PhysMem|extDB3|Database protocol initialized|Game world initialized|Server is up|LOOTBOX|FuMS|Headless|No more slot|Failed|Error in expression|Unknown Protocol' |
        Select-Object -Last 120 |
        ForEach-Object { $_.Line }
}

New-Directory $OutDir
$stamp = Get-Date -Format 'yyyyMMdd-HHmmss'
$rpt = Latest-File -Path (Join-Path $ServerDir 'profiles') -Filter 'arma3server_x64_*.rpt'
$extLogRoot = Join-Path $ServerDir '@ExileServer\logs'
$extLog = if (Test-Path -LiteralPath $extLogRoot) {
    Get-ChildItem -LiteralPath $extLogRoot -Recurse -Filter '*.log' -ErrorAction SilentlyContinue |
        Where-Object { $_.Name -notmatch '^Exile_' } |
        Sort-Object LastWriteTime -Descending |
        Select-Object -First 1
} else { $null }

$server = Get-Process arma3server_x64 -ErrorAction SilentlyContinue | Select-Object -First 1
$hc = Get-Process arma3_x64 -ErrorAction SilentlyContinue |
    Where-Object { $_.Path -like '*\SteamLibrary\steamapps\common\Arma 3\arma3_x64.exe' } |
    Sort-Object StartTime -Descending |
    Select-Object -First 1
$metric = Read-LatestMetric -ServerDir $ServerDir

$data = [pscustomobject]@{
    captured_at = (Get-Date).ToString('o')
    server = if ($server) {
        [pscustomobject]@{
            pid = $server.Id
            started = $server.StartTime
            working_set_mb = [math]::Round($server.WorkingSet64 / 1MB, 1)
            cpu_seconds = [math]::Round($server.CPU, 1)
            path = $server.Path
        }
    } else { $null }
    headless_client = if ($hc) {
        [pscustomobject]@{
            pid = $hc.Id
            started = $hc.StartTime
            working_set_mb = [math]::Round($hc.WorkingSet64 / 1MB, 1)
            cpu_seconds = [math]::Round($hc.CPU, 1)
            path = $hc.Path
        }
    } else { $null }
    latest_metric = $metric
    rpt = if ($rpt) {
        [pscustomobject]@{
            path = $rpt.FullName
            size_mb = [math]::Round($rpt.Length / 1MB, 2)
            last_write = $rpt.LastWriteTime
            evidence = Select-RptEvidence -RptPath $rpt.FullName
        }
    } else { $null }
    extdb3_log = if ($extLog) {
        [pscustomobject]@{
            path = $extLog.FullName
            size = $extLog.Length
            last_write = $extLog.LastWriteTime
        }
    } else { $null }
}

$jsonPath = Join-Path $OutDir "baseline-$stamp.json"
$mdPath = Join-Path $OutDir "baseline-$stamp.md"
Write-NoBom -Path $jsonPath -Text (($data | ConvertTo-Json -Depth 8) + [Environment]::NewLine)

$lines = New-Object System.Collections.Generic.List[string]
$lines.Add("# XCSV x64 baseline $stamp")
$lines.Add("")
$lines.Add("- Server: " + $(if ($data.server) { "pid $($data.server.pid), $($data.server.working_set_mb) MB" } else { "not running" }))
$lines.Add("- Headless client candidate: " + $(if ($data.headless_client) { "pid $($data.headless_client.pid), $($data.headless_client.working_set_mb) MB" } else { "not found" }))
$lines.Add("- RPT: " + $(if ($data.rpt) { "$($data.rpt.path) ($($data.rpt.size_mb) MB)" } else { "not found" }))
$lines.Add("- extDB3 log: " + $(if ($data.extdb3_log) { $data.extdb3_log.path } else { "not found" }))
if ($metric -and $metric.data) {
    $lines.Add("- infiSTAR metric: FPS $($metric.data.server_fps), FPS min $($metric.data.server_fpsmin), players $($metric.data.server_players), vehicles $($metric.data.server_vehicles), memory $($metric.data.server_memory) MB")
}
$lines.Add("")
$lines.Add("## Evidence")
$lines.Add("")
if ($data.rpt -and $data.rpt.evidence) {
    foreach ($line in $data.rpt.evidence) { $lines.Add("    " + $line) }
}
Write-NoBom -Path $mdPath -Text (($lines -join [Environment]::NewLine) + [Environment]::NewLine)

[pscustomobject]@{
    Json = $jsonPath
    Markdown = $mdPath
    ServerPid = if ($server) { $server.Id } else { $null }
    ServerMemoryMb = if ($server) { [math]::Round($server.WorkingSet64 / 1MB, 1) } else { $null }
}
