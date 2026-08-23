param(
    [Parameter(Mandatory = $true)][string]$RepoRoot,
    [Parameter(Mandatory = $true)][string]$Iwad,
    [Parameter(Mandatory = $true)][string]$ArtifactDir
)

$ErrorActionPreference = 'Stop'
Import-Module (Join-Path (Split-Path -Parent $PSScriptRoot) 'lib\MiniDoomTest.psm1') -Force

# Purpose: Rejects an OpenGL-only stale strip at the bottom by comparing the same fullscreen map region against classic rendering.
function Measure-BottomBandDifference {
    param(
        [Parameter(Mandatory = $true)][string]$A,
        [Parameter(Mandatory = $true)][string]$B,
        [int]$BandHeight = 64
    )

    Add-Type -AssemblyName System.Drawing
    $left = [System.Drawing.Bitmap]::FromFile($A)
    $right = [System.Drawing.Bitmap]::FromFile($B)
    try {
        $width = [Math]::Min($left.Width, $right.Width)
        $height = [Math]::Min($left.Height, $right.Height)
        $startY = [Math]::Max(0, $height - $BandHeight)
        [double]$difference = 0
        [int]$channels = 0
        for ($y = $startY; $y -lt $height; $y += 2) {
            for ($x = 0; $x -lt $width; $x += 2) {
                $ca = $left.GetPixel($x, $y)
                $cb = $right.GetPixel($x, $y)
                $difference += [Math]::Abs($ca.R - $cb.R) + [Math]::Abs($ca.G - $cb.G) + [Math]::Abs($ca.B - $cb.B)
                $channels += 3
            }
        }
        if ($channels -eq 0) { return 255.0 }
        return $difference / $channels
    }
    finally {
        $left.Dispose()
        $right.Dispose()
    }
}

$classic = $null
$gl = $null
$fullscreenConfig = Join-Path $ArtifactDir 'fullscreen.cfg'
[System.IO.File]::WriteAllText($fullscreenConfig, "screenblocks`t`t11`n")
try {
    $classic = Start-MiniDoomForTest -RepoRoot $RepoRoot -Arguments @('-iwad', $Iwad, '-windowed', '-warp', '1', '-nomonsters', '-config', $fullscreenConfig) -WindowTimeoutSeconds 20
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
    $gl = Start-MiniDoomForTest -RepoRoot $RepoRoot -Arguments @('-iwad', $Iwad, '-windowed', '-opengl', '-warp', '1', '-nomonsters', '-config', $fullscreenConfig) -WindowTimeoutSeconds 45
    Start-Sleep -Seconds 5
    Assert-MiniDoomHealthy -Process $gl
    $glShot = Join-Path $ArtifactDir 'opengl_warp1.png'
    Save-MiniDoomWindowImage -Process $gl -Path $glShot | Out-Null
    Assert-MiniDoomImageLooksDrawn -Path $glShot -Label 'opengl smoke'
}
finally {
    Stop-MiniDoomForTest -Process $gl
}

$bottomDifference = Measure-BottomBandDifference -A $classicShot -B $glShot
Assert-True ($bottomDifference -lt 25.0) "OpenGL bottom strip differs from the classic world and may contain a stale page/status overlay (mean diff $bottomDifference)."
