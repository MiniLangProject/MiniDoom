param(
    [Parameter(Mandatory = $true)][string]$RepoRoot,
    [Parameter(Mandatory = $true)][string]$Iwad,
    [Parameter(Mandatory = $true)][string]$ArtifactDir
)

$ErrorActionPreference = 'Stop'
Import-Module (Join-Path (Split-Path -Parent $PSScriptRoot) 'lib\MiniDoomTest.psm1') -Force

$classic = $null
$gl = $null
try {
    $classic = Start-MiniDoomForTest -RepoRoot $RepoRoot -Arguments @('-iwad', $Iwad, '-warp', '1', '-nomonsters') -WindowTimeoutSeconds 20
    Start-Sleep -Seconds 4
    Assert-MiniDoomHealthy -Process $classic
    $classicShot = Join-Path $ArtifactDir 'classic_warp1.png'
    Save-MiniDoomWindowImage -Process $classic -Path $classicShot | Out-Null
    Assert-MiniDoomImageLooksDrawn -Path $classicShot -Label 'classic smoke'
}
finally {
    Stop-MiniDoomForTest -Process $classic
}

try {
    $gl = Start-MiniDoomForTest -RepoRoot $RepoRoot -Arguments @('-iwad', $Iwad, '-opengl', '-warp', '1', '-nomonsters') -WindowTimeoutSeconds 45
    Start-Sleep -Seconds 5
    Assert-MiniDoomHealthy -Process $gl
    $glShot = Join-Path $ArtifactDir 'opengl_warp1.png'
    Save-MiniDoomWindowImage -Process $gl -Path $glShot | Out-Null
    Assert-MiniDoomImageLooksDrawn -Path $glShot -Label 'opengl smoke'
}
finally {
    Stop-MiniDoomForTest -Process $gl
}
