<#
.SYNOPSIS
    Watch BattlEye logs for kicks and propose (or apply) filter exceptions.

.DESCRIPTION
    This cannot be an Arma addon. SQF cannot read or write arbitrary files, and the
    filters live outside the mission. It is an external watcher that tails
    battleye\*.log, parses kick records, and turns recurring ones into exceptions.

    SAFETY -- READ THIS BEFORE USING -Mode Auto
    ------------------------------------------
    Auto-whitelisting BattlEye filters is automated anti-cheat disablement. Exile's
    stock scripts.txt uses action 7 (log + kick + ban), so those rules are doing real
    work. A naive watcher that excepts everything it sees will happily write a
    cheater's exploit into the permanent allowlist.

    Four guards, all on by default:

      1. Mode=Propose. Nothing is written to a filter unless you ask for it. Findings
         land in a pending queue for review.
      2. Protected filters. The classic cheat vectors are never auto-applied, whatever
         the mode -- see $ProtectedFilters below. A broken mod script normally trips
         scripts.txt, not setpos.txt.
      3. Distinct-player threshold. A legitimate mod problem kicks everyone; an exploit
         usually kicks one person. Auto-apply requires -MinPlayers distinct players
         (default 2) to have hit the same rule with the same text.
      4. Backups and a changelog. Every write is backed up and appended to
         be-autofilter-changes.log, so any change can be traced and reverted.

    BattlEye reads filters at server start, so an applied fix needs a restart before it
    takes effect. The tool says so when it changes something.

.EXAMPLE
    .\be-autofilter.ps1                       # one pass, propose only
    .\be-autofilter.ps1 -Watch                # poll continuously
    .\be-autofilter.ps1 -Mode Auto -Watch     # apply safe fixes automatically
    .\be-autofilter.ps1 -ShowPending          # review the queue
    .\be-autofilter.ps1 -ApplyPending 3       # apply queued item 3
#>
[CmdletBinding()]
param(
    [string]$BePath = 'E:\arma3server\battleye',
    [string]$StateDir = 'E:\ArmaTools\be-state',
    [ValidateSet('Propose', 'Auto')][string]$Mode = 'Propose',
    [int]$MinPlayers = 2,
    [switch]$Watch,
    [int]$IntervalSeconds = 30,
    [switch]$ShowPending,
    [int]$ApplyPending = -1
)

$ErrorActionPreference = 'Stop'

# Cheat vectors. A mod that legitimately needs these should be excepted by hand,
# deliberately, by someone who has looked at what the script actually does.
$ProtectedFilters = @(
    'setpos', 'createvehicle', 'remoteexec', 'remotecontrol', 'selectplayer',
    'teamswitch', 'attachto', 'deletevehicle', 'setvariable', 'setvariableval',
    'publicvariableval', 'hideobject', 'mpeventhandler'
)

New-Item -ItemType Directory -Path $StateDir -Force | Out-Null
$OffsetFile  = Join-Path $StateDir 'offsets.json'
$PendingFile = Join-Path $StateDir 'pending.json'
$ChangeLog   = Join-Path $StateDir 'be-autofilter-changes.log'

function Read-Json([string]$Path, $Default) {
    if (-not (Test-Path $Path)) { return $Default }
    try { Get-Content $Path -Raw | ConvertFrom-Json } catch { $Default }
}
# Piping a generic List into ConvertTo-Json throws "Argument types do not match" on
# PowerShell 5.1. Materialise a plain object[] and use -InputObject instead.
function Write-Json([string]$Path, [object[]]$Items) {
    $json = if (-not $Items -or $Items.Count -eq 0) { '[]' } else { ConvertTo-Json -InputObject $Items -Depth 8 }
    [IO.File]::WriteAllText($Path, $json, (New-Object Text.UTF8Encoding $false))
}

function Write-JsonObject([string]$Path, $Object) {
    $json = ConvertTo-Json -InputObject $Object -Depth 8
    [IO.File]::WriteAllText($Path, $json, (New-Object Text.UTF8Encoding $false))
}
# Casting an array to List[object] in PowerShell 5.1 adds the array as ONE element
# rather than enumerating it, which silently collapses the whole queue into a single
# bogus entry. Build the list explicitly.
# ConvertFrom-Json on PowerShell 5.1 hands back a JSON array as ONE object, so @() wraps
# it rather than enumerating -- which collapses the whole queue into a single bogus entry.
# Enumerate explicitly instead.
function ConvertTo-List($Items) {
    $list = New-Object System.Collections.Generic.List[object]
    if ($null -ne $Items) {
        if ($Items -is [string] -or $Items -isnot [System.Collections.IEnumerable]) { $list.Add($Items) }
        else { foreach ($i in $Items) { if ($null -ne $i) { $list.Add($i) } } }
    }
    , $list
}

function ConvertTo-BeException([string]$Raw) {
    $s = $Raw -replace '"', '\"'
    $s = $s -replace "`r`n", '\n' -replace "`n", '\n' -replace "`r", '\n'
    '!="' + $s + '"'
}
function Get-RuleLines([string]$FilterFile) {
    $i = 0
    $out = New-Object System.Collections.Generic.List[object]
    $raw = Get-Content $FilterFile
    for ($n = 0; $n -lt $raw.Count; $n++) {
        if ($raw[$n] -match '^\s*$' -or $raw[$n] -match '^\s*//') { continue }
        $out.Add([pscustomobject]@{ Index = $i; FileLine = $n; Text = $raw[$n] })
        $i++
    }
    , $out
}

function Add-Exception([string]$FilterName, [int]$RuleIndex, [string]$Exception, [string]$Why) {
    $file = Join-Path $BePath "$FilterName.txt"
    if (-not (Test-Path $file)) { throw "Filter file '$file' not found" }

    $rules = Get-RuleLines $file
    $target = $rules | Where-Object Index -eq $RuleIndex
    if (-not $target) { throw "$FilterName has no rule #$RuleIndex" }
    if ($target.Text -like "*$Exception*") { return "already present" }

    $stamp = Get-Date -Format 'yyyyMMdd-HHmmss'
    $backupDir = Join-Path $StateDir 'backups'
    New-Item -ItemType Directory -Path $backupDir -Force | Out-Null
    Copy-Item $file (Join-Path $backupDir "$FilterName.txt.$stamp.bak")

    $raw = Get-Content $file
    $raw[$target.FileLine] = $target.Text.TrimEnd() + ' ' + $Exception
    Set-Content -Path $file -Value $raw -Encoding ascii

    Add-Content -Path $ChangeLog -Encoding utf8 -Value (
        '{0}  {1} rule #{2}  {3}{4}    exception: {5}' -f
        (Get-Date -Format 's'), $FilterName, $RuleIndex, $Why, [Environment]::NewLine, $Exception)

    return "applied"
}

# ---- review / apply from the queue -------------------------------------------
if ($ShowPending -or $ApplyPending -ge 0) {
    $pending = (ConvertTo-List (Read-Json $PendingFile @())).ToArray()
    if (-not $pending -or $pending.Count -eq 0) { 'Pending queue is empty.'; return }

    if ($ShowPending) {
        for ($i = 0; $i -lt $pending.Count; $i++) {
            $p = $pending[$i]
            ''
            '[{0}] {1} rule #{2}   players: {3}   hits: {4}{5}' -f $i, $p.Filter, $p.Rule, $p.PlayerCount, $p.Hits,
                $(if ($p.Protected) { '   [PROTECTED - manual review required]' } else { '' })
            '     {0}' -f $p.Preview
            '     {0}' -f $p.Exception
        }
        ''
        'Apply one with:  .\be-autofilter.ps1 -ApplyPending <n>'
        return
    }

    $p = $pending[$ApplyPending]
    if (-not $p) { throw "No pending item $ApplyPending" }
    if ($p.Protected) {
        Write-Warning "$($p.Filter) is a protected (cheat-vector) filter. Applying anyway because you asked explicitly."
    }
    $result = Add-Exception $p.Filter $p.Rule $p.Exception "manual apply from queue"
    '{0}: {1}' -f $p.Filter, $result
    'Restart the server for BattlEye to reload filters.'
    return
}

# ---- the scan pass ------------------------------------------------------------
function Invoke-Pass {
    $offsets = Read-Json $OffsetFile ([pscustomobject]@{})
    $offsetMap = @{}
    foreach ($prop in $offsets.PSObject.Properties) { $offsetMap[$prop.Name] = [long]$prop.Value }

    $pending = ConvertTo-List (Read-Json $PendingFile @())
    $logs = Get-ChildItem $BePath -Filter '*.log' -ErrorAction SilentlyContinue
    if (-not $logs) { return @() }

    $found = @()

    foreach ($log in $logs) {
        $filterName = [IO.Path]::GetFileNameWithoutExtension($log.Name)
        $prev = if ($offsetMap.ContainsKey($log.Name)) { $offsetMap[$log.Name] } else { 0 }
        if ($log.Length -lt $prev) { $prev = 0 }          # log rotated
        if ($log.Length -eq $prev) { continue }

        $fs = [IO.File]::Open($log.FullName, 'Open', 'Read', 'ReadWrite')
        $fs.Seek($prev, 'Begin') | Out-Null
        $sr = New-Object IO.StreamReader($fs)
        $new = $sr.ReadToEnd()
        $sr.Close(); $fs.Close()
        $offsetMap[$log.Name] = $log.Length
        if (-not $new.Trim()) { continue }

        $records = [regex]::Matches($new,
            '(?m)^(?:\d{2}\.\d{2}\.\d{4}\s+\d{2}:\d{2}:\d{2}:\s*)?(?<name>.+?)\s+\((?<ip>[\d\.]+)(?::\d+)?\)\s+(?<guid>[0-9a-fA-F]{32})\s+-\s+#(?<rule>\d+)\s+(?<text>.*?)(?=^(?:\d{2}\.\d{2}\.\d{4}\s+\d{2}:\d{2}:\d{2}:\s*)?\S.*?\([\d\.]+(?::\d+)?\)\s+[0-9a-fA-F]{32}\s+-\s+#|\z)',
            [Text.RegularExpressions.RegexOptions]::Singleline)

        foreach ($g in ($records | Group-Object { $_.Groups['rule'].Value + '|' + $_.Groups['text'].Value.Trim() })) {
            $first   = $g.Group[0]
            $ruleNo  = [int]$first.Groups['rule'].Value
            $text    = $first.Groups['text'].Value.Trim()
            $players = @($g.Group | ForEach-Object { $_.Groups['guid'].Value } | Sort-Object -Unique)
            $exception = ConvertTo-BeException $text
            $protected = $ProtectedFilters -contains $filterName.ToLower()

            $item = [pscustomobject]@{
                Filter      = $filterName
                Rule        = $ruleNo
                Exception   = $exception
                Preview     = ($text -replace "`r?`n", ' | ')
                PlayerCount = $players.Count
                Hits        = $g.Count
                Protected   = $protected
                FirstSeen   = (Get-Date -Format 's')
            }
            if ($item.Preview.Length -gt 140) { $item.Preview = $item.Preview.Substring(0, 140) + '...' }

            $dupe = $pending | Where-Object { $_.Filter -eq $item.Filter -and $_.Rule -eq $item.Rule -and $_.Exception -eq $item.Exception }
            if ($dupe) {
                $dupe.Hits += $item.Hits
                if ($item.PlayerCount -gt $dupe.PlayerCount) { $dupe.PlayerCount = $item.PlayerCount }
                $item = $dupe
            }
            else { $pending.Add($item) }

            $found += $item
        }
    }

    Write-JsonObject $OffsetFile ([pscustomobject]$offsetMap)

    # Auto-apply only what clears every guard.
    if ($Mode -eq 'Auto') {
        foreach ($item in @($found)) {
            $reasons = @()
            if ($item.Protected)                  { $reasons += 'protected filter' }
            if ($item.PlayerCount -lt $MinPlayers) { $reasons += "only $($item.PlayerCount) distinct player(s), need $MinPlayers" }

            if ($reasons.Count) {
                Write-Host ('  HELD  {0} #{1}: {2}' -f $item.Filter, $item.Rule, ($reasons -join '; '))
                continue
            }
            $result = Add-Exception $item.Filter $item.Rule $item.Exception "auto: $($item.PlayerCount) players, $($item.Hits) hits"
            Write-Host ('  {0}  {1} #{2}' -f $result.ToUpper(), $item.Filter, $item.Rule)
            if ($result -eq 'applied') {
                $pending = ConvertTo-List ($pending | Where-Object {
                    -not ($_.Filter -eq $item.Filter -and $_.Rule -eq $item.Rule -and $_.Exception -eq $item.Exception) })
                $script:RestartNeeded = $true
            }
        }
    }

    Write-Json $PendingFile $pending.ToArray()
    $found
}

$script:RestartNeeded = $false

if ($Watch) {
    'Watching {0} every {1}s  (mode: {2}, min distinct players for auto: {3})' -f $BePath, $IntervalSeconds, $Mode, $MinPlayers
    'Ctrl+C to stop.'
    while ($true) {
        $hits = Invoke-Pass
        if ($hits.Count) {
            '{0}  {1} new kick group(s)' -f (Get-Date -Format 'HH:mm:ss'), $hits.Count
            foreach ($h in $hits) { '   {0} #{1}  players={2} hits={3}  {4}' -f $h.Filter, $h.Rule, $h.PlayerCount, $h.Hits, $h.Preview }
            if ($script:RestartNeeded) { '   >> filters changed; restart the server to load them'; $script:RestartNeeded = $false }
        }
        Start-Sleep -Seconds $IntervalSeconds
    }
}
else {
    $hits = Invoke-Pass
    if (-not $hits -or $hits.Count -eq 0) {
        'No new kick records.'
        $pending = @(Read-Json $PendingFile @())
        if ($pending.Count) { '{0} item(s) already in the pending queue -- see -ShowPending.' -f $pending.Count }
    }
    else {
        '{0} kick group(s) found. Review with -ShowPending.' -f $hits.Count
        if ($script:RestartNeeded) { 'Filters were changed; restart the server to load them.' }
    }
}
