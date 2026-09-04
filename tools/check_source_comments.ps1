[CmdletBinding()]
param(
    [string]$RepoRoot,
    [switch]$Quiet,
    [switch]$Summary
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

# This audit intentionally rejects comments that merely restate a declaration name.
# MiniLang declarations use MiniDoc's //! file and /// declaration syntax; native
# helper sources retain the documentation conventions of their own language.
if ([string]::IsNullOrWhiteSpace($RepoRoot)) {
    $RepoRoot = Split-Path -Parent $PSScriptRoot
}
$repo = [IO.Path]::GetFullPath($RepoRoot)
$failures = [Collections.Generic.List[object]]::new()
$genericPatterns = @(
    '^Provides(?:\s|$)',
    '^Draws .+ output',
    '^Stores .+ data used',
    '^Processes .+ events',
    '^Manages .+ data',
    '^Handles .+ events',
    '^Initializes state and dependencies',
    '^Loads .+ resources used',
    '^Runs .+ behavior',
    '^Runs .+ lifecycle logic',
    '^Creates and initializes runtime objects',
    '^Reads .+ data (?:for|from)',
    '^Writes .+ data (?:for|to|from)',
    '^Builds .+ data for',
    '^Converts int values for',
    '^(?:Reads|Writes|Builds|Runs|Updates|Converts|Computes|Checks|Finds) .+ for the utility\.$',
    '^Updates .+ state',
    '^Computes movement/collision behavior',
    '^Finds .+ information',
    '^Advances .+ logic',
    '^Starts runtime behavior',
    '^Stops or tears down runtime behavior',
    '^Retrieves and caches data',
    '^Performs integer division with .+ rounding and guard rules',
    '^Maps the external .+ binding used for',
    '^Defines named constants for',
    '^Checks .+ conditions for',
    '^Clamps .+ values to the supported',
    '^Shuts down .+ resources owned'
)
$genericHeaderPatterns = @(
    '^Provides shared math, utility, and low-level helper routines',
    '^Contains Doom engine module logic for this subsystem',
    '^Implements core gameplay simulation: map logic, physics, AI, and world interaction',
    '^Implements renderer data preparation and software rendering pipeline stages',
    '^Implements platform integration for input, timing, video, audio, and OS services',
    '^Defines core Doom data types, shared state, and bootstrap flow',
    '^Implements in-game HUD text and messaging behaviors',
    '^Implements status bar and HUD presentation logic'
)

# Return the contiguous documentation block immediately preceding a declaration.
<#
.SYNOPSIS
Returns the contiguous line or block comment immediately preceding a declaration.
#>
function Get-DeclarationComment {
    param(
        [string[]]$Lines,
        [int]$DeclarationIndex
    )

    $end = $DeclarationIndex - 1
    while ($end -ge 0 -and [string]::IsNullOrWhiteSpace($Lines[$end])) { $end-- }
    if ($end -lt 0) { return $null }
    $trimmed = $Lines[$end].Trim()
    if ($trimmed.StartsWith('///')) {
        $start = $end
        while ($start -gt 0 -and $Lines[$start - 1].Trim().StartsWith('///')) { $start-- }
        return (($Lines[$start..$end] -join "`n").Trim())
    }
    if ($trimmed.StartsWith('//')) { return $trimmed.Substring(2).Trim() }
    if ($trimmed -ne '*/') { return $null }

    $start = $end
    while ($start -ge 0 -and $Lines[$start] -notmatch '/\*') { $start-- }
    if ($start -lt 0) { return $null }
    return (($Lines[$start..$end] -join "`n").Trim())
}

# Extract the semantic summary from MiniDoc or a native declaration docblock.
<#
.SYNOPSIS
Extracts the semantic summary used to reject missing or tautological documentation.
#>
function Get-SummaryText {
    param([string]$Comment)

    if ([string]::IsNullOrWhiteSpace($Comment)) { return '' }
    if ($Comment -match '(?m)^\s*///') {
        $summary = [Collections.Generic.List[string]]::new()
        foreach ($line in ($Comment -split "`r?`n")) {
            $value = ($line -replace '^\s*///\s?', '').Trim()
            if ($value.StartsWith('@')) { break }
            if ($value) { $summary.Add($value) }
        }
        return (($summary -join ' ').Trim())
    }
    if ($Comment -match '(?m)^\s*\*?\s*Purpose:\s*(.+?)\s*$') { return $Matches[1].Trim() }
    # Get-DeclarationComment already removes the leading // marker.
    if (-not $Comment.Contains("`n") -and -not $Comment.Contains('/*')) { return $Comment.Trim() }
    return ''
}

$miniLangFiles = @(
    Get-ChildItem -LiteralPath (Join-Path $repo 'src') -Filter '*.ml' -File
    Get-ChildItem -LiteralPath (Join-Path $repo 'tools') -Filter '*.ml' -File
    if (Test-Path -LiteralPath (Join-Path $repo 'tests\fixtures')) {
        Get-ChildItem -LiteralPath (Join-Path $repo 'tests\fixtures') -Filter '*.ml' -File
    }
)
foreach ($file in $miniLangFiles) {
    $lines = @(Get-Content -LiteralPath $file.FullName)
    $fileDocLines = @(
        $lines | Select-Object -First 55 | Where-Object { $_ -match '^\s*//!' } |
            ForEach-Object { ($_ -replace '^\s*//!\s?', '').Trim() }
    )
    $headerPurpose = ($fileDocLines -join ' ').Trim()
    $headerGeneric = $false
    foreach ($pattern in $genericHeaderPatterns) {
        if ($headerPurpose -match $pattern) {
            $headerGeneric = $true
            break
        }
    }
    if ([string]::IsNullOrWhiteSpace($headerPurpose) -or
        $headerPurpose.Length -lt 18 -or $headerGeneric) {
        $failures.Add([pscustomobject]@{
            File = [IO.Path]::GetRelativePath($repo, $file.FullName)
            Line = 1
            Kind = 'file'
            Name = $file.Name
            Problem = 'missing useful, source-specific //! file documentation in first 55 lines'
        })
    }
    for ($i = 0; $i -lt $lines.Count; $i++) {
        $kind = ''
        $name = ''
        if ($lines[$i] -match '^\s*(?:extern\s+)?function(?:\s+inline)?\s+([A-Za-z_][A-Za-z0-9_]*)') {
            $kind = 'function'
            $name = $Matches[1]
        }
        elseif ($lines[$i] -match '^\s*struct\s+([A-Za-z_][A-Za-z0-9_]*)') {
            $kind = 'struct'
            $name = $Matches[1]
        }
        elseif ($lines[$i] -match '^\s*enum\s+([A-Za-z_][A-Za-z0-9_]*)') {
            $kind = 'enum'
            $name = $Matches[1]
        }
        else { continue }

        $comment = Get-DeclarationComment -Lines $lines -DeclarationIndex $i
        $purpose = Get-SummaryText -Comment $comment
        $reason = ''
        if ([string]::IsNullOrWhiteSpace($comment)) { $reason = 'missing adjacent documentation block' }
        elseif ($comment -notmatch '(?m)^\s*///') { $reason = 'MiniLang declaration must use an adjacent /// MiniDoc block' }
        elseif ([string]::IsNullOrWhiteSpace($purpose)) { $reason = 'missing MiniDoc summary text' }
        elseif ($purpose.Length -lt 18) { $reason = 'MiniDoc summary is too short to explain behavior' }
        else {
            foreach ($pattern in $genericPatterns) {
                if ($purpose -match $pattern) {
                    $reason = "generic Purpose text: $purpose"
                    break
                }
            }
        }
        if ($reason) {
            $failures.Add([pscustomobject]@{
                File = [IO.Path]::GetRelativePath($repo, $file.FullName)
                Line = $i + 1
                Kind = $kind
                Name = $name
                Problem = $reason
            })
        }
    }
}

$pythonFiles = @(Get-ChildItem -LiteralPath $repo -Filter '*.py' -File)
foreach ($file in $pythonFiles) {
    $lines = @(Get-Content -LiteralPath $file.FullName)
    for ($i = 0; $i -lt $lines.Count; $i++) {
        if ($lines[$i] -notmatch '^\s*(?:async\s+)?def\s+([A-Za-z_][A-Za-z0-9_]*)') { continue }
        $name = $Matches[1]
        $signatureEnd = $i
        while ($signatureEnd -lt $lines.Count -and $lines[$signatureEnd] -notmatch ':\s*$') { $signatureEnd++ }
        $body = $signatureEnd + 1
        while ($body -lt $lines.Count -and [string]::IsNullOrWhiteSpace($lines[$body])) { $body++ }
        if ($body -ge $lines.Count -or $lines[$body].TrimStart() -notmatch '^(?:"""|'''''')') {
            $failures.Add([pscustomobject]@{
                File = [IO.Path]::GetRelativePath($repo, $file.FullName)
                Line = $i + 1
                Kind = 'Python function'
                Name = $name
                Problem = 'missing function docstring'
            })
        }
    }
}

$powerShellFiles = @(
    Get-ChildItem -LiteralPath (Join-Path $repo 'tools') -Filter '*.ps1' -File
    if (Test-Path -LiteralPath (Join-Path $repo 'tests')) {
        Get-ChildItem -LiteralPath (Join-Path $repo 'tests') -Include '*.ps1', '*.psm1' -File -Recurse
    }
)
foreach ($file in $powerShellFiles) {
    $lines = @(Get-Content -LiteralPath $file.FullName)
    for ($i = 0; $i -lt $lines.Count; $i++) {
        if ($lines[$i] -notmatch '^\s*function\s+([A-Za-z_][A-Za-z0-9_-]*)') { continue }
        $name = $Matches[1]
        $end = $i - 1
        while ($end -ge 0 -and [string]::IsNullOrWhiteSpace($lines[$end])) { $end-- }
        $documented = $false
        if ($end -ge 0 -and $lines[$end] -match '^\s*#\s*Purpose:\s*(.{18,})$') {
            $documented = $true
        }
        elseif ($end -ge 0 -and $lines[$end].Trim() -eq '#>') {
            $start = $end
            while ($start -ge 0 -and $lines[$start] -notmatch '<#') { $start-- }
            if ($start -ge 0) {
                $help = $lines[$start..$end] -join "`n"
                $documented = $help -match '(?m)^\s*\.SYNOPSIS\s*$' -and $help.Length -ge 35
            }
        }
        if (-not $documented) {
            $failures.Add([pscustomobject]@{
                File = [IO.Path]::GetRelativePath($repo, $file.FullName)
                Line = $i + 1
                Kind = 'PowerShell function'
                Name = $name
                Problem = 'missing adjacent # Purpose or comment-based .SYNOPSIS help'
            })
        }
    }
}

$cFile = Join-Path $repo 'tools\minidoom_gl_helper.c'
if (Test-Path -LiteralPath $cFile) {
    $lines = @(Get-Content -LiteralPath $cFile)
    for ($i = 0; $i -lt $lines.Count; $i++) {
        if ($lines[$i] -match '^\s*typedef\s+struct\s+([A-Za-z_][A-Za-z0-9_]*)') {
            $name = $Matches[1]
            $comment = Get-DeclarationComment -Lines $lines -DeclarationIndex $i
            if ([string]::IsNullOrWhiteSpace($comment)) {
                $failures.Add([pscustomobject]@{
                    File = [IO.Path]::GetRelativePath($repo, $cFile)
                    Line = $i + 1
                    Kind = 'C struct'
                    Name = $name
                    Problem = 'missing adjacent documentation block'
                })
            }
            continue
        }
        if ($lines[$i] -notmatch '^\s*(?:(?:static|__declspec\([^)]*\))\s+)*(?:BOOL|void|int|int32_t|int64_t|uint32_t|double|PROC|GLubyte|GLuint|unsigned\s+char(?:\s*\*)?)\s+(?:__stdcall\s+)?([A-Za-z_][A-Za-z0-9_]*)\s*\(') { continue }
        $name = $Matches[1]
        $comment = Get-DeclarationComment -Lines $lines -DeclarationIndex $i
        if ([string]::IsNullOrWhiteSpace($comment)) {
            $failures.Add([pscustomobject]@{
                File = [IO.Path]::GetRelativePath($repo, $cFile)
                Line = $i + 1
                Kind = 'C function'
                Name = $name
                Problem = 'missing adjacent documentation block'
            })
        }
    }
}

if ($failures.Count -gt 0) {
    if ($Summary) {
        $failures |
            Group-Object File |
            Sort-Object -Property @{ Expression = 'Count'; Descending = $true }, Name |
            Select-Object Count, Name |
            Format-Table -AutoSize |
            Out-Host
    }
    elseif (-not $Quiet) {
        $failures | Sort-Object File, Line | Format-Table -AutoSize | Out-Host
    }
    throw "Source comment audit failed for $($failures.Count) declaration(s)."
}

Write-Host "PASS: every audited source declaration has adjacent, non-generic documentation."
