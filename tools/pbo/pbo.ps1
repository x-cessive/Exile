<#
.SYNOPSIS
    Pack, unpack and inspect Arma PBO archives. No external dependencies.

.DESCRIPTION
    PBO layout produced/consumed here:

        [header extension entry]   name="" mime='Vers' then key\0value\0 pairs, terminated by \0
        [file entries]             name\0 + UInt32 mime, originalSize, reserved, timeStamp, dataSize
        [terminator entry]         name="" + five zero UInt32s
        [file data]                concatenated, in entry order
        0x00
        [20-byte SHA1]             over every byte before that 0x00

    Reads and writes uncompressed entries (mime 0x00000000), which is what every
    Exile mission and server addon uses, and what Arma reads natively.

    LZSS-compressed entries (mime 0x43707273 'Cprs') are detected and reported but
    NOT extracted -- this tool has no verified decompressor, and silently emitting
    corrupt source would be worse than refusing. In practice only mod PBOs packed
    with Mikero's tools use compression (e.g. @Exile\addons\exile_client.pbo), and
    those are read-only references you would never repack. If you do need one,
    extract it with Mikero's ExtractPbo or Arma 3 Tools.

    The prefix header property is what lets Arma resolve paths like
    "myaddon\fn_thing.sqf" inside the PBO. An addon PBO without one will load but
    its CfgFunctions/#include paths will not resolve.

.EXAMPLE
    .\pbo.ps1 List   -Path E:\arma3server\mpmissions\Exile.Tanoa.pbo
    .\pbo.ps1 Unpack -Path E:\arma3server\mpmissions\Exile.Tanoa.pbo -Out E:\work\Exile.Tanoa
    .\pbo.ps1 Pack   -Path E:\work\Exile.Tanoa -Out E:\arma3server\mpmissions\Exile.Tanoa.pbo
    .\pbo.ps1 Pack   -Path E:\work\a3_dms -Out a3_dms.pbo -Prefix a3_dms
    .\pbo.ps1 Verify -Path E:\arma3server\@ExileServer\addons\exile_server.pbo
#>
[CmdletBinding()]
param(
    [Parameter(Mandatory, Position = 0)]
    [ValidateSet('List', 'Unpack', 'Pack', 'Verify')]
    [string]$Action,

    [Parameter(Mandatory, Position = 1)]
    [string]$Path,

    [string]$Out,

    # Prefix header property. If omitted when packing, taken from a $PBOPREFIX$ or
    # $PREFIX$ file in the source folder, else from the folder name.
    [string]$Prefix,

    # Extra header properties, e.g. -Property @{ version = '1.0.4' }
    [hashtable]$Property = @{}
)

$ErrorActionPreference = 'Stop'
Set-StrictMode -Version Latest

$MIME_UNCOMPRESSED = 0x00000000
$MIME_COMPRESSED   = 0x43707273  # 'Cprs'
$MIME_VERSION      = 0x56657273  # 'Vers'

# Files that describe the PBO rather than belong inside it.
$MetaFiles = @('$PBOPREFIX$', '$PREFIX$', '$PBOPROPS$.txt', 'pbo.properties')

function Read-CString([IO.BinaryReader]$Reader) {
    $bytes = New-Object System.Collections.Generic.List[byte]
    while ($true) {
        $b = $Reader.ReadByte()
        if ($b -eq 0) { break }
        $bytes.Add($b)
    }
    if ($bytes.Count -eq 0) { return '' }
    [Text.Encoding]::UTF8.GetString($bytes.ToArray())
}

function Write-CString([IO.BinaryWriter]$Writer, [string]$Value) {
    if ($Value) { $Writer.Write([Text.Encoding]::UTF8.GetBytes($Value)) }
    $Writer.Write([byte]0)
}

function Read-Pbo([string]$PboPath) {
    $bytes  = [IO.File]::ReadAllBytes($PboPath)
    $stream = New-Object IO.MemoryStream (, $bytes)
    $reader = New-Object IO.BinaryReader $stream

    $props   = [ordered]@{}
    $entries = New-Object System.Collections.Generic.List[object]

    while ($true) {
        $name = Read-CString $reader
        $mime = $reader.ReadUInt32()
        $orig = $reader.ReadUInt32()
        $resv = $reader.ReadUInt32()
        $time = $reader.ReadUInt32()
        $size = $reader.ReadUInt32()

        if ($name -eq '') {
            if ($mime -eq $MIME_VERSION) {
                while ($true) {
                    $k = Read-CString $reader
                    if ($k -eq '') { break }
                    $props[$k] = Read-CString $reader
                }
                continue
            }
            break   # terminator entry
        }

        $entries.Add([pscustomobject]@{
            Name = $name; Mime = $mime; OriginalSize = $orig
            TimeStamp = $time; DataSize = $size; DataOffset = 0
        })
    }

    $offset = $stream.Position
    foreach ($e in $entries) { $e.DataOffset = $offset; $offset += $e.DataSize }
    $reader.Dispose()

    [pscustomobject]@{ Bytes = $bytes; Properties = $props; Entries = $entries }
}

function Get-EntryBytes($Pbo, $Entry) {
    if ($Entry.DataSize -eq 0) { return , (New-Object byte[] 0) }
    if ($Entry.Mime -eq $MIME_COMPRESSED) {
        throw ("Entry '{0}' is LZSS-compressed; this tool cannot extract it. " +
               'Use Mikero ExtractPbo or Arma 3 Tools for compressed PBOs.') -f $Entry.Name
    }
    $buf = New-Object byte[] $Entry.DataSize
    [Array]::Copy($Pbo.Bytes, $Entry.DataOffset, $buf, 0, $Entry.DataSize)
    , $buf
}

function Test-PboChecksum([string]$PboPath) {
    $b = [IO.File]::ReadAllBytes($PboPath)
    if ($b.Length -lt 21) { return $false }
    if ($b[$b.Length - 21] -ne 0) { return $false }
    $stored = [BitConverter]::ToString($b[($b.Length - 20)..($b.Length - 1)]).Replace('-', '')
    $sha    = [Security.Cryptography.SHA1]::Create()
    $actual = [BitConverter]::ToString($sha.ComputeHash($b, 0, $b.Length - 21)).Replace('-', '')
    $stored -eq $actual
}

switch ($Action) {

    'List' {
        $pbo = Read-Pbo $Path
        if ($pbo.Properties.Count) {
            'Header properties:'
            foreach ($k in $pbo.Properties.Keys) { '    {0} = {1}' -f $k, $pbo.Properties[$k] }
        }
        else { 'Header properties: (none)  <- an addon PBO without a prefix will not resolve its own paths' }
        ''
        '{0} entries' -f $pbo.Entries.Count
        $pbo.Entries | ForEach-Object {
            '{0,10:N0}  {1}  {2}' -f $_.OriginalSize, $(if ($_.Mime -eq $MIME_COMPRESSED) { 'cprs' } else { 'raw ' }), $_.Name
        }
    }

    'Verify' {
        $ok  = Test-PboChecksum $Path
        $pbo = Read-Pbo $Path
        '{0}: checksum {1}, {2} entries, prefix {3}' -f (Split-Path $Path -Leaf),
            $(if ($ok) { 'OK' } else { 'BAD' }), $pbo.Entries.Count,
            $(if ($pbo.Properties.Contains('prefix')) { $pbo.Properties['prefix'] } else { '(none)' })
        if (-not $ok) { exit 1 }
    }

    'Unpack' {
        if (-not $Out) { throw '-Out <directory> is required for Unpack' }
        $pbo = Read-Pbo $Path
        $compressed = @($pbo.Entries | Where-Object { $_.Mime -eq $MIME_COMPRESSED })
        if ($compressed.Count) {
            throw ('{0} of {1} entries in this PBO are LZSS-compressed and cannot be extracted by this tool. ' +
                   'Use Mikero ExtractPbo or Arma 3 Tools instead.') -f $compressed.Count, $pbo.Entries.Count
        }
        New-Item -ItemType Directory -Path $Out -Force | Out-Null

        foreach ($e in $pbo.Entries) {
            $dest = Join-Path $Out $e.Name
            $dir  = Split-Path $dest -Parent
            if ($dir -and -not (Test-Path $dir)) { New-Item -ItemType Directory -Path $dir -Force | Out-Null }
            [IO.File]::WriteAllBytes($dest, (Get-EntryBytes $pbo $e))
        }

        if ($pbo.Properties.Contains('prefix')) {
            [IO.File]::WriteAllText((Join-Path $Out '$PBOPREFIX$'), $pbo.Properties['prefix'])
        }
        $extra = $pbo.Properties.Keys | Where-Object { $_ -ne 'prefix' }
        if ($extra) {
            $lines = $extra | ForEach-Object { '{0}={1}' -f $_, $pbo.Properties[$_] }
            [IO.File]::WriteAllLines((Join-Path $Out '$PBOPROPS$.txt'), [string[]]$lines)
        }

        'Unpacked {0} entries to {1}' -f $pbo.Entries.Count, $Out
    }

    'Pack' {
        if (-not $Out) { throw '-Out <file.pbo> is required for Pack' }
        if (-not (Test-Path $Path -PathType Container)) { throw "Source '$Path' is not a directory" }
        # Get-Item -> FullName, NOT Resolve-Path.
        #
        # Resolve-Path hands back the path in whatever form it was given, so a
        # source path containing an 8.3 short name ("C:\Users\ARCHIT~1\...")
        # stays short while Get-ChildItem below returns canonical long-form
        # FullName ("C:\Users\Architect\..."). ARCHIT~1 is 8 characters and
        # Architect is 9, so $root.Length came out one short and the relative
        # path calculation left a leading backslash on EVERY entry.
        #
        # That is not cosmetic. Arma resolves <prefix> + "\bootstrap\..." and
        # finds nothing, so the addon silently loads no code. It is what broke
        # exile_server.pbo, Server.pbo and safex_server.pbo on 2026-08-01 and
        # put the server in a 219-restart loop. A PBO corrupted this way still
        # passes a checksum verify, which is why it went unnoticed for hours.
        $root = (Get-Item -LiteralPath $Path).FullName.TrimEnd('\')

        # Prefix: explicit, else $PBOPREFIX$/$PREFIX$ in the folder, else folder name.
        if (-not $Prefix) {
            foreach ($f in '$PBOPREFIX$', '$PREFIX$') {
                $p = Join-Path $root $f
                if (Test-Path $p) {
                    $v = (Get-Content $p -Raw -ErrorAction SilentlyContinue)
                    if ($v) { $Prefix = $v.Trim(); break }
                }
            }
        }
        if (-not $Prefix) { $Prefix = Split-Path $root -Leaf }

        $props = [ordered]@{ prefix = $Prefix }
        $propsFile = Join-Path $root '$PBOPROPS$.txt'
        if (Test-Path $propsFile) {
            foreach ($line in Get-Content $propsFile) {
                if ($line -match '^\s*([^=]+?)\s*=\s*(.*)$') { $props[$Matches[1]] = $Matches[2] }
            }
        }
        foreach ($k in $Property.Keys) { $props[$k] = [string]$Property[$k] }

        $files = Get-ChildItem $root -Recurse -File |
                 Where-Object { $MetaFiles -notcontains $_.Name -and $_.Name -notin 'Thumbs.db', 'desktop.ini' } |
                 Where-Object { $_.FullName -notmatch '\\\.git\\' } |
                 Sort-Object FullName

        if (-not $files) { throw "No files to pack under '$root'" }

        $ms = New-Object IO.MemoryStream
        $bw = New-Object IO.BinaryWriter $ms

        # Header extension carrying the properties.
        Write-CString $bw ''
        $bw.Write([uint32]$MIME_VERSION)
        $bw.Write([uint32]0); $bw.Write([uint32]0); $bw.Write([uint32]0); $bw.Write([uint32]0)
        foreach ($k in $props.Keys) { Write-CString $bw $k; Write-CString $bw ([string]$props[$k]) }
        $bw.Write([byte]0)

        $epoch = [datetime]'1970-01-01Z'
        foreach ($f in $files) {
            # Trim the separator off rather than assuming exactly one character
            # of it, so any residual off-by-one cannot reintroduce the leading
            # backslash. Belt and braces on top of the $root fix above.
            $rel = $f.FullName.Substring($root.Length).TrimStart('\', '/').Replace('/', '\')
            if ([string]::IsNullOrWhiteSpace($rel) -or $rel.StartsWith('\')) {
                throw "refusing to pack: bad entry path '$rel' for $($f.FullName)"
            }
            $ts  = [uint32][math]::Max(0, [math]::Floor(($f.LastWriteTimeUtc - $epoch).TotalSeconds))
            Write-CString $bw $rel
            $bw.Write([uint32]$MIME_UNCOMPRESSED)
            $bw.Write([uint32]$f.Length)   # originalSize
            $bw.Write([uint32]0)           # reserved
            $bw.Write($ts)                 # timeStamp
            $bw.Write([uint32]$f.Length)   # dataSize
        }

        # Terminator entry.
        Write-CString $bw ''
        1..5 | ForEach-Object { $bw.Write([uint32]0) }

        foreach ($f in $files) { $bw.Write([IO.File]::ReadAllBytes($f.FullName)) }

        $bw.Flush()
        $body = $ms.ToArray()
        $bw.Dispose()

        $sha  = [Security.Cryptography.SHA1]::Create()
        $hash = $sha.ComputeHash($body)

        $outDir = Split-Path $Out -Parent
        if ($outDir -and -not (Test-Path $outDir)) { New-Item -ItemType Directory -Path $outDir -Force | Out-Null }

        $fs = [IO.File]::Create($Out)
        $fs.Write($body, 0, $body.Length)
        $fs.WriteByte(0)
        $fs.Write($hash, 0, $hash.Length)
        $fs.Dispose()

        'Packed {0} files -> {1} ({2:N0} bytes, prefix "{3}")' -f $files.Count, $Out, (Get-Item $Out).Length, $Prefix
    }
}
