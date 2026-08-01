<#
.SYNOPSIS
    Find classnames an addon references that the running server does not have.

.DESCRIPTION
    Extracts quoted string literals that look like Arma classnames from SQF/config
    sources and diffs them against the ground-truth dump produced by
    sovran_classdump + extract-classdump.ps1.

    This is a HEURISTIC. String literals in SQF are used for many things besides
    classnames -- variable names, event names, mission types, file paths. The
    filters below remove the obvious non-classes, and results are ranked by
    frequency, but the output is a triage list for a human to confirm, not a
    verdict. False positives are expected; a name appearing here means "worth
    checking", not "definitely broken".

.EXAMPLE
    .\check-classnames.ps1 -Path 'E:\ExileRepo\Addons\DMS_Exile'
    .\check-classnames.ps1 -Path 'E:\ExileRepo\Addons' -PerFolder
#>
[CmdletBinding()]
param(
    [Parameter(Mandatory)][string]$Path,
    [string]$Classes = 'E:\ArmaTools\classes\ALL.txt',
    [switch]$PerFolder,
    [int]$Top = 40
)

$ErrorActionPreference = 'Stop'
if (-not (Test-Path $Classes)) { throw "Class list '$Classes' not found. Run extract-classdump.ps1 first." }

$known = [System.Collections.Generic.HashSet[string]]::new(
    [string[]](Get-Content $Classes), [StringComparer]::OrdinalIgnoreCase)

# Identifier prefixes that are code, not content.
$codePrefixes = @(
    'BIS_', 'BIN_', 'Exile[CS]', 'ExileClient', 'ExileServer', 'DMS_', 'A3XAI', 'ZCP_', 'VCOM',
    'FuMS', 'UPSMON', 'SAR_', 'blck', 'GMS_', 'CBA_', 'ACE_', 'fn_', 'fnc_', 'RscTitles', 'Rsc',
    'Cfg', 'Item_', 'STR_', 'TAG_', 'my', 'temp', 'test'
)
$codeRegex = '^(' + ($codePrefixes -join '|') + ')'

# Words that pass the shape test but are plainly not classnames.
$stopWords = @(
    'true','false','east','west','civilian','resistance','guer','logic','none','any','all',
    'this','player','server','client','mission','init','start','stop','end','begin','error',
    'debug','info','warning','random','default','custom','main','name','type','value','data'
)

$exts = '*.sqf','*.hpp','*.cpp','*.h','*.ext'

function Get-Candidates([string]$Root) {
    $counts = @{}
    $files = Get-ChildItem $Root -Recurse -File -Include $exts -ErrorAction SilentlyContinue |
             Where-Object { $_.FullName -notmatch '\\\.git\\' }
    foreach ($f in $files) {
        $text = Get-Content $f.FullName -Raw -ErrorAction SilentlyContinue
        if (-not $text) { continue }
        foreach ($m in [regex]::Matches($text, '"([A-Za-z][A-Za-z0-9_]{3,63})"')) {
            $name = $m.Groups[1].Value
            if ($name -notmatch '_')            { continue }   # nearly all classnames contain _
            if ($name -match $codeRegex)        { continue }
            if ($stopWords -contains $name.ToLower()) { continue }
            if ($known.Contains($name))         { continue }
            if (-not $counts.ContainsKey($name)) { $counts[$name] = [pscustomobject]@{ Count = 0; Files = [System.Collections.Generic.HashSet[string]]::new() } }
            $counts[$name].Count++
            [void]$counts[$name].Files.Add($f.Name)
        }
    }
    $counts
}

function Show-Result($Label, $Counts, $Root) {
    $total = $Counts.Keys.Count
    if ($total -eq 0) { '{0,-46} clean' -f $Label; return }
    '{0,-46} {1} unresolved candidate(s)' -f $Label, $total
    if (-not $PerFolder) {
        $Counts.GetEnumerator() | Sort-Object { $_.Value.Count } -Descending | Select-Object -First $Top | ForEach-Object {
            '   [{0,4}x] {1,-44} {2}' -f $_.Value.Count, $_.Key, (($_.Value.Files | Select-Object -First 2) -join ', ')
        }
    }
}

'Ground truth: {0:N0} classnames from {1}' -f $known.Count, $Classes
''

if ($PerFolder) {
    foreach ($d in Get-ChildItem $Path -Directory) {
        Show-Result $d.Name (Get-Candidates $d.FullName) $d.FullName
    }
}
else {
    Show-Result (Split-Path $Path -Leaf) (Get-Candidates $Path) $Path
}
