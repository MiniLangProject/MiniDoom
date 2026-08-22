param(
    [Parameter(Mandatory = $true)][string]$RepoRoot,
    [Parameter(Mandatory = $true)][string]$Iwad,
    [Parameter(Mandatory = $true)][string]$ArtifactDir
)

$ErrorActionPreference = 'Stop'

# Purpose: Extracts one top-level MiniLang function body for source-level dispatcher auditing.
function Get-MiniLangFunctionBody {
    param(
        [Parameter(Mandatory = $true)][string]$Path,
        [Parameter(Mandatory = $true)][string]$Name
    )

    $source = Get-Content -LiteralPath $Path -Raw
    $pattern = '(?ms)^function\s+' + [regex]::Escape($Name) + '\s*\([^\r\n]*\)\s*\r?\n(?<body>.*?)^end function\s*$'
    $match = [regex]::Match($source, $pattern)
    if (-not $match.Success) { throw "Function $Name not found in $Path." }
    return $match.Groups['body'].Value
}

$moverCalls = '\b(?:EV_VerticalDoor|EV_DoCeiling|EV_CeilingCrushStop|EV_DoFloor|EV_DoDoor|EV_DoLockedDoor|EV_DoPlat|EV_StopPlat|EV_BuildStairs|EV_DoDonut)\s*\('
$expected = [Collections.Generic.HashSet[int]]::new()
$dispatchers = @(
    @((Join-Path $RepoRoot 'src\p_spec.ml'), 'P_ShootSpecialLine'),
    @((Join-Path $RepoRoot 'src\p_spec.ml'), 'P_CrossSpecialLine'),
    @((Join-Path $RepoRoot 'src\p_switch.ml'), 'P_UseSpecialLine')
)

foreach ($dispatcher in $dispatchers) {
    $body = Get-MiniLangFunctionBody -Path $dispatcher[0] -Name $dispatcher[1]
    $cases = [regex]::Matches($body, '(?ms)^\s*case\s+(?<ids>\d+(?:\s*,\s*\d+)*)\s*\r?\n(?<casebody>.*?)(?=^\s*end case\s*$)')
    foreach ($case in $cases) {
        if ($case.Groups['casebody'].Value -notmatch $moverCalls) { continue }
        foreach ($token in $case.Groups['ids'].Value -split ',') {
            [void]$expected.Add([int]$token.Trim())
        }
    }
}

$rglPath = Join-Path $RepoRoot 'src\r_gl.ml'
$rglBody = Get-MiniLangFunctionBody -Path $rglPath -Name 'RGL_LineMayMoveGeometry'
$actual = [Collections.Generic.HashSet[int]]::new()
foreach ($case in [regex]::Matches($rglBody, '(?m)^\s*case\s+(?<ids>\d+(?:\s*,\s*\d+)*)\s*$')) {
    foreach ($token in $case.Groups['ids'].Value -split ',') {
        [void]$actual.Add([int]$token.Trim())
    }
}

$missing = @($expected | Where-Object { -not $actual.Contains($_) } | Sort-Object)
$unexpected = @($actual | Where-Object { -not $expected.Contains($_) } | Sort-Object)
if ($missing.Count -gt 0 -or $unexpected.Count -gt 0) {
    throw "OpenGL mover classification differs from gameplay dispatchers. Missing=[$($missing -join ',')], unexpected=[$($unexpected -join ',')]."
}
if (-not $actual.Contains(49)) { throw 'Doom II MAP06 crusher special 49 is not classified as moving geometry.' }

Write-Output "OpenGL mover coverage PASS ($($actual.Count) line specials, including MAP06 crusher 49)."
