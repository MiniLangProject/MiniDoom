param(
    [Parameter(Mandatory = $true)][string]$RepoRoot,
    [Parameter(Mandatory = $true)][string]$Iwad,
    [Parameter(Mandatory = $true)][string]$ArtifactDir
)

$ErrorActionPreference = 'Stop'

# Purpose: Extracts one complete top-level MiniLang function for structural renderer regression checks.
function Get-MiniLangFunctionBody {
    param([Parameter(Mandatory = $true)][string]$Source, [Parameter(Mandatory = $true)][string]$Name)
    $pattern = '(?ms)^function\s+' + [regex]::Escape($Name) + '\s*\([^\r\n]*\)\s*\r?\n(?<body>.*?)^end function\s*$'
    $match = [regex]::Match($Source, $pattern)
    if (-not $match.Success) { throw "Function $Name was not found." }
    return $match.Groups['body'].Value
}

# Purpose: Rejects a missing data-flow edge with a focused diagnostic instead of a broad source diff.
function Assert-BodyPattern {
    param([Parameter(Mandatory = $true)][string]$Body, [Parameter(Mandatory = $true)][string]$Pattern, [Parameter(Mandatory = $true)][string]$Message)
    if ($Body -notmatch $Pattern) { throw $Message }
}

$source = Get-Content -LiteralPath (Join-Path $RepoRoot 'src\r_gl.ml') -Raw
if ($source -notmatch '(?m)^const\s+RGL_GEOM_VERSION\s*=\s*9\s*$') { throw 'OpenGL geometry cache version was not advanced for the UV layout correction.' }
$offsetBody = Get-MiniLangFunctionBody -Source $source -Name 'RGL_SegTextureOffset'
$segBody = Get-MiniLangFunctionBody -Source $source -Name 'RGL_DrawSeg'
$maskedBody = Get-MiniLangFunctionBody -Source $source -Name 'RGL_DrawMaskedSeg'
$skyBody = Get-MiniLangFunctionBody -Source $source -Name 'RGL_DrawSkyInteriorBoundarySeg'
$cachedBody = Get-MiniLangFunctionBody -Source $source -Name 'RGL_AddCachedWallQuad'
$immediateBody = Get-MiniLangFunctionBody -Source $source -Name 'RGL_DrawWallQuadTexMid'

Assert-BodyPattern -Body $offsetBody -Pattern 'RGL_FixedToFloat\(sg\.offset\)' -Message 'OpenGL no longer reads the map-authored BSP seg texture offset.'
Assert-BodyPattern -Body $offsetBody -Pattern 'remaining\s*=.*-\s*offset\s*-.*std\.math\.sqrt' -Message 'Opposite-side seg offset is not derived from the complementary linedef distance.'
Assert-BodyPattern -Body $segBody -Pattern 'RGL_DrawWallPiece\([^\r\n]*RGL_SegTextureOffset\(sg,\s*false\)\)' -Message 'Opaque BSP walls do not receive their seg texture offset.'
Assert-BodyPattern -Body $maskedBody -Pattern 'RGL_DrawMaskedMidtexture\([^\r\n]*RGL_SegTextureOffset\(sg,\s*false\)\)' -Message 'Front masked walls do not receive their seg texture offset.'
Assert-BodyPattern -Body $maskedBody -Pattern 'RGL_DrawMaskedMidtexture\([^\r\n]*RGL_SegTextureOffset\(sg,\s*true\)\)' -Message 'Back masked walls do not receive the complementary seg texture offset.'
Assert-BodyPattern -Body $skyBody -Pattern 'RGL_DrawWallQuadOffset\([^\r\n]*RGL_SegTextureOffset\(sg,\s*false\)\)' -Message 'Sky-boundary walls do not preserve the front seg offset.'
Assert-BodyPattern -Body $skyBody -Pattern 'RGL_DrawWallQuadOffset\([^\r\n]*RGL_SegTextureOffset\(sg,\s*true\)\)' -Message 'Sky-boundary back walls do not preserve the complementary seg offset.'
Assert-BodyPattern -Body $cachedBody -Pattern 'xoff\s*=\s*xoff\s*\+\s*wallOffset' -Message 'Cached wall UVs ignore the propagated seg offset.'
Assert-BodyPattern -Body $immediateBody -Pattern 'xoff\s*=\s*xoff\s*\+\s*wallOffset' -Message 'Immediate wall UVs ignore the propagated seg offset.'

# Confirm that the selected IWAD actually exercises nonzero split-seg offsets,
# so this regression guard is tied to real map data rather than dead plumbing.
$wad = [IO.File]::ReadAllBytes((Resolve-Path -LiteralPath $Iwad).Path)
if ($wad.Length -lt 12) { throw 'IWAD is too small.' }
$lumpCount = [BitConverter]::ToInt32($wad, 4)
$directoryOffset = [BitConverter]::ToInt32($wad, 8)
if ($lumpCount -le 0 -or $directoryOffset -lt 12 -or ([int64]$directoryOffset + [int64]$lumpCount * 16) -gt $wad.Length) { throw 'IWAD directory is invalid.' }
$nonzeroOffsets = 0
for ($i = 0; $i -lt $lumpCount; $i++) {
    $entry = $directoryOffset + $i * 16
    $name = [Text.Encoding]::ASCII.GetString($wad, $entry + 8, 8).TrimEnd([char]0)
    if ($name -ne 'SEGS') { continue }
    $dataOffset = [BitConverter]::ToInt32($wad, $entry)
    $dataSize = [BitConverter]::ToInt32($wad, $entry + 4)
    if ($dataOffset -lt 0 -or $dataSize -lt 0 -or ([int64]$dataOffset + $dataSize) -gt $wad.Length) { throw 'SEGS lump range is invalid.' }
    for ($seg = 0; ($seg + 1) * 12 -le $dataSize; $seg++) {
        $offset = [BitConverter]::ToInt16($wad, $dataOffset + $seg * 12 + 10)
        if ($offset -ne 0) { $nonzeroOffsets++ }
    }
}
if ($nonzeroOffsets -le 0) { throw 'IWAD contains no nonzero BSP seg offsets.' }

Write-Output "OpenGL wall-offset coverage PASS ($nonzeroOffsets nonzero IWAD seg offsets)."
