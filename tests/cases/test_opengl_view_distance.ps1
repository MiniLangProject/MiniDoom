param(
    [Parameter(Mandatory = $true)][string]$RepoRoot,
    [Parameter(Mandatory = $true)][string]$Iwad,
    [Parameter(Mandatory = $true)][string]$ArtifactDir
)

$ErrorActionPreference = 'Stop'
Import-Module (Join-Path (Split-Path -Parent $PSScriptRoot) 'lib\MiniDoomTest.psm1') -Force
$null = $ArtifactDir

$renderer = Get-Content -LiteralPath (Join-Path $RepoRoot 'src\r_gl.ml') -Raw
$distanceMatch = [regex]::Match($renderer, '(?m)^const RGL_WORLD_VIEW_DISTANCE\s*=\s*(?<value>[0-9.]+)\s*$')
Assert-True $distanceMatch.Success 'OpenGL renderer has no shared world-view-distance constant.'
$viewDistance = [double]::Parse($distanceMatch.Groups['value'].Value, [Globalization.CultureInfo]::InvariantCulture)
Assert-True ($viewDistance -ge 8192.0) "OpenGL world view distance remains too short ($viewDistance)."

Assert-True ($renderer -match 'farz\s*=\s*RGL_WORLD_VIEW_DISTANCE') 'OpenGL projection does not use the shared view distance.'
$spriteUses = [regex]::Matches($renderer, 'farDist\s*=\s*RGL_WORLD_VIEW_DISTANCE\s*\*\s*RGL_WORLD_VIEW_DISTANCE').Count
Assert-True ($spriteUses -eq 2) "Native and fallback sprite culling are not both using the shared view distance ($spriteUses/2)."

# MAP32 extends almost 7000 map units north of player one. Validate the configured
# distance against the actual local IWAD when this test runs with DOOM II.
$wad = [IO.File]::ReadAllBytes((Resolve-Path -LiteralPath $Iwad).Path)
$lumpCount = [BitConverter]::ToInt32($wad, 4)
$directoryOffset = [BitConverter]::ToInt32($wad, 8)
$entries = @()
for ($index = 0; $index -lt $lumpCount; $index++) {
    $entryOffset = $directoryOffset + $index * 16
    $name = [Text.Encoding]::ASCII.GetString($wad, $entryOffset + 8, 8).Trim([char]0)
    $entries += [pscustomobject]@{
        Name = $name
        Offset = [BitConverter]::ToInt32($wad, $entryOffset)
        Size = [BitConverter]::ToInt32($wad, $entryOffset + 4)
    }
}

$map32Index = -1
for ($index = 0; $index -lt $entries.Count; $index++) {
    if ($entries[$index].Name -eq 'MAP32') { $map32Index = $index; break }
}
if ($map32Index -ge 0) {
    $mapLumps = @{}
    for ($index = $map32Index + 1; $index -lt [Math]::Min($entries.Count, $map32Index + 12); $index++) {
        $mapLumps[$entries[$index].Name] = $entries[$index]
    }
    Assert-True ($mapLumps.ContainsKey('THINGS') -and $mapLumps.ContainsKey('VERTEXES')) 'MAP32 has no THINGS/VERTEXES lumps.'

    $things = $mapLumps['THINGS']
    $playerX = $null
    $playerY = $null
    for ($offset = 0; $offset + 10 -le $things.Size; $offset += 10) {
        $type = [BitConverter]::ToInt16($wad, $things.Offset + $offset + 6)
        if ($type -eq 1) {
            $playerX = [BitConverter]::ToInt16($wad, $things.Offset + $offset)
            $playerY = [BitConverter]::ToInt16($wad, $things.Offset + $offset + 2)
            break
        }
    }
    Assert-True ($null -ne $playerX) 'MAP32 has no player-one start.'

    $vertices = $mapLumps['VERTEXES']
    [double]$farthest = 0.0
    for ($offset = 0; $offset + 4 -le $vertices.Size; $offset += 4) {
        $x = [BitConverter]::ToInt16($wad, $vertices.Offset + $offset)
        $y = [BitConverter]::ToInt16($wad, $vertices.Offset + $offset + 2)
        $distance = [Math]::Sqrt(($x - $playerX) * ($x - $playerX) + ($y - $playerY) * ($y - $playerY))
        if ($distance -gt $farthest) { $farthest = $distance }
    }
    Assert-True ($viewDistance -ge $farthest + 512.0) "OpenGL view distance $viewDistance does not cover MAP32's $([Math]::Round($farthest, 1))-unit start sightline with margin."
}

Write-Output "OpenGL view distance PASS ($viewDistance map units)."
