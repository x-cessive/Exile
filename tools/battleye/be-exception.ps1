<#
.SYNOPSIS
    Turn a BattlEye kick/ban log entry into a filter exception, and locate the exact
    rule line it belongs on.

.DESCRIPTION
    BattlEye filter files contain numbered rules. A kick logs as

        PlayerName (1.2.3.4) 0123456789abcdef0123456789abcdef - #43 "some script text"

    where #43 is the index of the RULE that fired -- counted over rule lines only,
    ignoring comments and blank lines. To stop the kick you append an exception to
    THAT rule, not a new line.

    Building the exception by hand is error-prone: every " must become \", every real
    newline must become \n, and the whole thing is prefixed with != and re-quoted.
    This does that mechanically.

    Filter action codes (the leading number on each rule) are a bitmask:
        1 = log, 2 = kick, 4 = ban.
    So `7` is log + kick + ban, which is what Exile's stock scripts.txt uses. A missing
    exception there does not merely annoy a player, it bans them.

.EXAMPLE
    # Scan the BE logs for kicks and print ready-to-use exceptions
    .\be-exception.ps1

.EXAMPLE
    # Convert a pasted kick string
    .\be-exception.ps1 -Text 'To _playerUID)exitWith
    {
    _playerObject = _x;
    }'

.EXAMPLE
    # Show what rule #43 of scripts.txt currently is, and the patched line
    .\be-exception.ps1 -Text '...' -Filter scripts -Rule 43 -Apply
#>
[CmdletBinding()]
param(
    [string]$BePath = 'E:\arma3server\battleye',
    [string]$Text,
    [string]$Filter,
    [int]$Rule = -1,
    [switch]$Apply
)

$ErrorActionPreference = 'Stop'

function ConvertTo-BeException([string]$Raw) {
    # Order matters: escape quotes before introducing \n sequences.
    $s = $Raw -replace '"', '\"'
    $s = $s -replace "`r`n", '\n' -replace "`n", '\n' -replace "`r", '\n'
    '!="' + $s + '"'
}

function Get-RuleLines([string]$FilterFile) {
    # Returns rule lines with their BattlEye index (comments/blanks are not counted).
    $i = 0
    $out = New-Object System.Collections.Generic.List[object]
    $raw = Get-Content $FilterFile
    for ($n = 0; $n -lt $raw.Count; $n++) {
        $line = $raw[$n]
        if ($line -match '^\s*$' -or $line -match '^\s*//') { continue }
        $out.Add([pscustomobject]@{ Index = $i; FileLine = $n; Text = $line })
        $i++
    }
    , $out
}

# ---- Mode 1: explicit text ----------------------------------------------------
if ($Text) {
    $exception = ConvertTo-BeException $Text
    'Exception:'
    '  ' + $exception
    ''

    if ($Filter) {
        $file = Join-Path $BePath ($Filter -replace '\.txt$', '')
        $file = "$file.txt"
        if (-not (Test-Path $file)) { throw "Filter file '$file' not found" }

        $rules = Get-RuleLines $file
        if ($Rule -ge 0) {
            $target = $rules | Where-Object Index -eq $Rule
            if (-not $target) { throw "Filter '$Filter' has no rule #$Rule (it has $($rules.Count) rules)" }

            $action = if ($target.Text -match '^\s*(\d+)') { [int]$Matches[1] } else { -1 }
            $meaning = @()
            if ($action -band 1) { $meaning += 'log' }
            if ($action -band 2) { $meaning += 'kick' }
            if ($action -band 4) { $meaning += 'ban' }

            'Filter : {0}  rule #{1}  (file line {2})' -f (Split-Path $file -Leaf), $Rule, ($target.FileLine + 1)
            'Action : {0} = {1}' -f $action, ($meaning -join ' + ')
            'Current:'
            '  ' + $target.Text.Substring(0, [Math]::Min(160, $target.Text.Length))
            'Patched:'
            $patched = $target.Text.TrimEnd() + ' ' + $exception
            '  ' + $patched.Substring(0, [Math]::Min(160, $patched.Length))

            if ($Apply) {
                $stamp = Get-Date -Format 'yyyyMMdd-HHmmss'
                $backupDir = Join-Path $BePath '_backups'
                New-Item -ItemType Directory -Path $backupDir -Force | Out-Null
                Copy-Item $file (Join-Path $backupDir ((Split-Path $file -Leaf) + ".$stamp.bak"))
                $raw = Get-Content $file
                $raw[$target.FileLine] = $patched
                Set-Content -Path $file -Value $raw -Encoding ascii
                ''
                'APPLIED. Backup in {0}. Restart the server for BattlEye to reload filters.' -f $backupDir
            }
            else {
                ''
                'Re-run with -Apply to write this change (a backup is taken automatically).'
            }
        }
        else {
            'Filter {0} has {1} rules. Pass -Rule <n> (the #n from the kick log) to target one.' -f $Filter, $rules.Count
        }
    }
    return
}

# ---- Mode 2: scan the logs ----------------------------------------------------
$logs = Get-ChildItem $BePath -Filter '*.log' -ErrorAction SilentlyContinue
if (-not $logs) {
    'No BattlEye .log files in {0}.' -f $BePath
    ''
    'BattlEye only writes a log once a rule with the log bit (action 1, 3, 5 or 7) actually'
    'fires, which needs a connected player doing something. An empty folder means either'
    'nobody has played since the filters were installed, or nothing has tripped a rule.'
    return
}

foreach ($log in $logs) {
    $filterName = [IO.Path]::GetFileNameWithoutExtension($log.Name)
    $content = Get-Content $log.FullName -Raw
    if (-not $content) { continue }

    # Entries look like: Name (IP) GUID - #N text...  (text may span lines)
    $matches = [regex]::Matches($content,
        '(?m)^(?:\d{2}\.\d{2}\.\d{4}\s+\d{2}:\d{2}:\d{2}:\s*)?(?<name>.+?)\s+\((?<ip>[\d\.]+)(?::\d+)?\)\s+(?<guid>[0-9a-fA-F]{32})\s+-\s+#(?<rule>\d+)\s+(?<text>.*?)(?=^(?:\d{2}\.\d{2}\.\d{4}\s+\d{2}:\d{2}:\d{2}:\s*)?\S.*?\([\d\.]+(?::\d+)?\)\s+[0-9a-fA-F]{32}\s+-\s+#|\z)',
        [Text.RegularExpressions.RegexOptions]::Singleline)

    if ($matches.Count -eq 0) { continue }

    '===== {0} : {1} kick record(s) =====' -f $log.Name, $matches.Count
    $groups = $matches | Group-Object { $_.Groups['rule'].Value + '|' + $_.Groups['text'].Value.Trim() }

    foreach ($g in $groups | Sort-Object Count -Descending) {
        $first = $g.Group[0]
        $ruleNo = $first.Groups['rule'].Value
        $text = $first.Groups['text'].Value.Trim()
        $players = ($g.Group | ForEach-Object { $_.Groups['name'].Value } | Sort-Object -Unique) -join ', '

        ''
        '  rule #{0}  x{1}  players: {2}' -f $ruleNo, $g.Count, $players
        '  text   : {0}' -f ($text -replace "`r?`n", ' | ').Substring(0, [Math]::Min(120, ($text -replace "`r?`n", ' | ').Length))
        '  fix    : .\be-exception.ps1 -Filter {0} -Rule {1} -Apply -Text ''{2}''' -f $filterName, $ruleNo, ($text -replace "'", "''")
        '  except : {0}' -f (ConvertTo-BeException $text)
    }
    ''
}
