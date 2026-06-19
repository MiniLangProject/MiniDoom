param(
    [Parameter(Mandatory = $true)][string]$RepoRoot,
    [Parameter(Mandatory = $true)][string]$Iwad,
    [Parameter(Mandatory = $true)][string]$ArtifactDir
)

$ErrorActionPreference = 'Stop'
Import-Module (Join-Path (Split-Path -Parent $PSScriptRoot) 'lib\MiniDoomTest.psm1') -Force

$hdwad = "$Iwad.hdwad"
$p = $null

if (-not (Test-Path $hdwad)) {
    try {
        $p = Start-MiniDoomForTest -RepoRoot $RepoRoot -Arguments @('-iwad', $Iwad, '-opengl', '-warp', '1', '-nomonsters') -WindowTimeoutSeconds 240
        $deadline = (Get-Date).AddMinutes(6)
        while ((Get-Date) -lt $deadline -and -not (Test-Path $hdwad)) {
            Assert-MiniDoomHealthy -Process $p
            Start-Sleep -Seconds 2
        }
        Assert-True (Test-Path $hdwad) "OpenGL start did not generate HDWAD at $hdwad."
    }
    finally {
        Stop-MiniDoomForTest -Process $p
    }
}

$info = Test-MiniDoomHDWADHeader -Path $hdwad
$info | ConvertTo-Json | Set-Content -Encoding UTF8 (Join-Path $ArtifactDir 'hdwad_header.json')

$p = $null
try {
    $p = Start-MiniDoomForTest -RepoRoot $RepoRoot -Arguments @('-iwad', $Iwad, '-opengl', '-warp', '1', '-nomonsters') -WindowTimeoutSeconds 45
    Start-Sleep -Seconds 4
    Assert-MiniDoomHealthy -Process $p
    $shot = Join-Path $ArtifactDir 'opengl_with_hdwad.png'
    Save-MiniDoomWindowImage -Process $p -Path $shot | Out-Null
    Assert-MiniDoomImageLooksDrawn -Path $shot -Label 'OpenGL with HDWAD'
}
finally {
    Stop-MiniDoomForTest -Process $p
}
