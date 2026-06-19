param(
    [Parameter(Mandatory = $true)][string]$RepoRoot,
    [Parameter(Mandatory = $true)][string]$Iwad,
    [Parameter(Mandatory = $true)][string]$ArtifactDir
)

$ErrorActionPreference = 'Stop'
Import-Module (Join-Path (Split-Path -Parent $PSScriptRoot) 'lib\MiniDoomTest.psm1') -Force

$p = $null
try {
    $p = Start-MiniDoomForTest -RepoRoot $RepoRoot -Arguments @('-iwad', $Iwad, '-opengl', '-warp', '1', '-nomonsters') -WindowTimeoutSeconds 45
    Start-Sleep -Seconds 5
    Assert-MiniDoomHealthy -Process $p

    $glStart = Join-Path $ArtifactDir '01_opengl_start.png'
    Save-MiniDoomWindowImage -Process $p -Path $glStart | Out-Null
    Assert-MiniDoomImageLooksDrawn -Path $glStart -Label 'OpenGL before toggle'

    Send-MiniDoomAltG -Process $p
    $classic = Join-Path $ArtifactDir '02_classic_after_alt_g.png'
    Save-MiniDoomWindowImage -Process $p -Path $classic | Out-Null
    Assert-MiniDoomImageLooksDrawn -Path $classic -Label 'classic after Alt+G'

    Send-MiniDoomAltG -Process $p
    $glBack = Join-Path $ArtifactDir '03_opengl_after_alt_g.png'
    Save-MiniDoomWindowImage -Process $p -Path $glBack | Out-Null
    Assert-MiniDoomImageLooksDrawn -Path $glBack -Label 'OpenGL after second Alt+G'

    $diffToClassic = Measure-MiniDoomImageDifference -A $glStart -B $classic
    $diffBack = Measure-MiniDoomImageDifference -A $classic -B $glBack

    Assert-True ($diffToClassic -gt 2.0) "Alt+G did not visibly switch from OpenGL to classic (mean diff $diffToClassic)."
    Assert-True ($diffBack -gt 2.0) "Second Alt+G did not visibly switch back to OpenGL (mean diff $diffBack)."
}
finally {
    Stop-MiniDoomForTest -Process $p
}
