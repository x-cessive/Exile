<#
.SYNOPSIS
    Classify an Arma 3 server RPT into real problems vs known noise.

.DESCRIPTION
    Arma RPTs are mostly noise. This separates the signal, groups repeated errors
    (a broken loop can emit the same line thousands of times), and attributes
    errors to an addon where the text names one.

    Defaults to the newest RPT in E:\arma3server\profiles.

.EXAMPLE
    .\rpt-triage.ps1
    .\rpt-triage.ps1 -Path 'E:\arma3server\profiles\arma3server_2026-08-01_04-12-33.rpt' -Detail
#>
[CmdletBinding()]
param(
    [string]$Path,
    [switch]$Detail,
    [int]$Samples = 3
)

$ErrorActionPreference = 'Stop'

if (-not $Path) {
    $Path = (Get-ChildItem 'E:\arma3server\profiles' -Filter '*.rpt' |
             Sort-Object LastWriteTime -Descending | Select-Object -First 1).FullName
}
if (-not (Test-Path $Path)) { throw "No RPT found at '$Path'" }

# Confirmed-harmless on this deployment. Every one of these was verified during
# the 2026-08-01 build-out; see SERVER_SETUP_NOTES.md.
$Noise = @(
    "doesn't exist in skeleton"
    'Updating base class'
    'looped for animation'
    'dependent on downloadable content that has been deleted'   # fires even for a mission with zero addons declared
    'No such texture'
    'cannot load material'
    'Cannot delete class'
    'Conflicting addon'
    'Strange convex component'
    'not found in class HitPoints'
    '32-Bit version may become deprecated'
    'VoteThreshold'
    '\[CLASSDUMP\]'
)

# Ordered: first match wins, so put specific patterns above generic ones.
$Categories = [ordered]@{
    'Script error (expression)' = 'Error in expression|Error position|Error Undefined variable|Error Zero divisor|Error Generic error'
    'Script error (type)'       = "Error Type .*, expected"
    'Missing file / script'     = 'Script .* not found|File .* not found|Cannot open file|preprocessor failed'
    'Missing config entry'      = "No entry '|Config : some input after EndOfFile|Undefined base class"
    'Missing classname'         = 'Vehicle class .* no longer exists|No such class|Unknown weapon|Unknown magazine'
    'Network / remoteExec'      = 'remoteExec|RemoteExec .* not allowed|is not allowed to be executed'
    'BattlEye'                  = 'BattlEye .*(kick|Kick|ban|Ban|restriction)'
    'Database / extDB'          = 'extDB|SQL|Database|MySQL'
    'Warning message'           = 'Warning Message:'
}

$lines = Get-Content $Path
$noiseRegex = ($Noise -join '|')

$hits = @{}
$noiseCount = 0

foreach ($line in $lines) {
    if ($line -match $noiseRegex) { $noiseCount++; continue }

    foreach ($cat in $Categories.Keys) {
        if ($line -match $Categories[$cat]) {
            # Normalise volatile parts so repeats collapse into one bucket.
            $key = $line -replace '^\s*\d+:\d+:\d+\s*', ''
            $key = $key -replace '0x[0-9a-fA-F]+', '0xADDR'
            $key = $key -replace '\d+\.\d+', 'N.N'
            $key = $key -replace '\b\d{3,}\b', 'N'
            if ($key.Length -gt 220) { $key = $key.Substring(0, 220) }

            if (-not $hits.ContainsKey($cat)) { $hits[$cat] = @{} }
            if (-not $hits[$cat].ContainsKey($key)) {
                $hits[$cat][$key] = [pscustomobject]@{ Count = 0; Samples = New-Object System.Collections.Generic.List[string] }
            }
            $hits[$cat][$key].Count++
            if ($hits[$cat][$key].Samples.Count -lt $Samples) { $hits[$cat][$key].Samples.Add($line.Trim()) }
            break
        }
    }
}

# Attribute to an addon by any path-ish token in the text.
$addonNames = @()
foreach ($dir in 'E:\arma3server\@ExileServer\addons') {
    if (Test-Path $dir) {
        $addonNames += (Get-ChildItem $dir -Filter '*.pbo' | ForEach-Object { [IO.Path]::GetFileNameWithoutExtension($_.Name) })
    }
}

'RPT triage: {0}' -f (Split-Path $Path -Leaf)
'  {0:N0} lines, {1:N0} suppressed as known noise' -f $lines.Count, $noiseCount
''

if ($hits.Keys.Count -eq 0) {
    'No categorised problems found.'
    return
}

foreach ($cat in $Categories.Keys) {
    if (-not $hits.ContainsKey($cat)) { continue }
    $bucket  = $hits[$cat]
    $total   = ($bucket.Values | Measure-Object Count -Sum).Sum
    '== {0} -- {1:N0} occurrence(s), {2} distinct ==' -f $cat, $total, $bucket.Keys.Count

    $ranked = $bucket.GetEnumerator() | Sort-Object { $_.Value.Count } -Descending
    foreach ($e in $ranked) {
        $blame = $addonNames | Where-Object { $e.Key -match [regex]::Escape($_) } | Select-Object -First 1
        '  [{0,5}x]{1} {2}' -f $e.Value.Count, $(if ($blame) { " ($blame)" } else { '' }), $e.Key
        if ($Detail) { foreach ($s in $e.Value.Samples) { '          | ' + $s } }
    }
    ''
}
