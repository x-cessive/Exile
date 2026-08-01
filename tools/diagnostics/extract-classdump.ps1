<#
.SYNOPSIS
    Turn the [CLASSDUMP] lines emitted by sovran_classdump into per-root class lists.

.DESCRIPTION
    Produces one sorted, de-duplicated .txt per config root plus an all-classes file,
    which is the ground truth to diff addon-referenced classnames against.

.EXAMPLE
    .\extract-classdump.ps1 -Out E:\ArmaTools\classes
#>
[CmdletBinding()]
param(
    [string]$Path,
    [string]$Out = 'E:\ArmaTools\classes'
)

$ErrorActionPreference = 'Stop'

if (-not $Path) {
    $Path = (Get-ChildItem 'E:\arma3server\profiles' -Filter '*.rpt' |
             Sort-Object LastWriteTime -Descending |
             Where-Object { Select-String -Path $_.FullName -Pattern '\[CLASSDUMP\] COMPLETE' -Quiet } |
             Select-Object -First 1).FullName
}
if (-not $Path) { throw 'No RPT containing a completed [CLASSDUMP] was found.' }

New-Item -ItemType Directory -Path $Out -Force | Out-Null

$byRoot = @{}
$rejected = New-Object System.Collections.Generic.List[string]

foreach ($line in Get-Content $Path) {
    if ($line -notmatch '\[CLASSDUMP\]\s+(Cfg\w+)\s+(.+)$') { continue }
    $root = $Matches[1]
    $payload = $Matches[2]
    if ($payload -match '^(BEGIN|END|count=)') { continue }

    # diag_log wraps its output in double quotes, so the LAST name on every line
    # arrives as e.g. I_MRAP_03_F" -- strip that or ~1 name per line is corrupted.
    $payload = $payload.Trim().TrimEnd('"')

    if (-not $byRoot.ContainsKey($root)) { $byRoot[$root] = New-Object System.Collections.Generic.List[string] }
    foreach ($c in $payload -split ',') {
        $c = $c.Trim()
        if (-not $c) { continue }
        # Arma classnames are identifiers. Anything else means a parsing fault.
        if ($c -notmatch '^[A-Za-z0-9_]+$') { $rejected.Add("$root : $c"); continue }
        $byRoot[$root].Add($c)
    }
}

# Cross-check against the emitted= totals the addon logs, so a silent parsing
# loss can never pass unnoticed again.
$expected = @{}
foreach ($line in Get-Content $Path) {
    if ($line -match '\[CLASSDUMP\] END (Cfg\w+) emitted=(\d+)') { $expected[$Matches[1]] = [int]$Matches[2] }
}

$all = New-Object System.Collections.Generic.List[string]
foreach ($root in $byRoot.Keys | Sort-Object) {
    $sorted = $byRoot[$root] | Sort-Object -Unique
    $file = Join-Path $Out "$root.txt"
    Set-Content -Path $file -Value $sorted -Encoding ascii

    $note = ''
    if ($expected.ContainsKey($root)) {
        $raw = $byRoot[$root].Count
        $note = if ($raw -eq $expected[$root]) { 'ok' } else { "MISMATCH raw=$raw emitted=$($expected[$root])" }
    }
    '{0,-16} {1,7:N0} classes  {2,-32} -> {3}' -f $root, $sorted.Count, $note, $file
    $all.AddRange([string[]]$sorted)
}

if ($rejected.Count) {
    ''
    'WARNING: {0} token(s) rejected as non-identifiers (parsing fault):' -f $rejected.Count
    $rejected | Select-Object -First 10 | ForEach-Object { '  ' + $_ }
}

$allSorted = $all | Sort-Object -Unique
Set-Content -Path (Join-Path $Out 'ALL.txt') -Value $allSorted -Encoding ascii
''
'{0,-16} {1,7:N0} unique classnames -> {2}' -f 'TOTAL', $allSorted.Count, (Join-Path $Out 'ALL.txt')
