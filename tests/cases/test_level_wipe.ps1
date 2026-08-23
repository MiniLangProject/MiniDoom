param(
    [Parameter(Mandatory = $true)][string]$RepoRoot,
    [Parameter(Mandatory = $true)][string]$Iwad,
    [Parameter(Mandatory = $true)][string]$ArtifactDir
)

$ErrorActionPreference = 'Stop'

$mobj = Get-Content -LiteralPath (Join-Path $RepoRoot 'src\p_mobj.ml') -Raw
$renderer = Get-Content -LiteralPath (Join-Path $RepoRoot 'src\r_main.ml') -Raw

if ($mobj -notmatch '(?s)p\.viewheight\s*=\s*VIEWHEIGHT.*?p\.viewz\s*=\s*mobj\.z\s*\+\s*p\.viewheight.*?mobj\.ceilingz\s*-\s*4\s*\*\s*FRACUNIT') {
    throw 'Player spawn does not initialize and ceiling-clamp eye height before the wipe destination render.'
}
if ($mobj -notmatch '(?s)players\[pnum\]\s*=\s*p.*?R_ResetViewInterpolation\(\)') {
    throw 'Player spawn does not reset stale camera interpolation before the first level frame.'
}
if ($renderer -notmatch '(?s)function R_ResetViewInterpolation\(\).*?_r_interp_player\s*=\s*void.*?_r_interp_last_tic\s*=\s*-1') {
    throw 'Renderer has no deterministic interpolation reset for level transitions.'
}

Write-Output 'Level-wipe destination camera initialization PASS.'
