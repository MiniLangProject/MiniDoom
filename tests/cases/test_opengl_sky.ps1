param(
    [Parameter(Mandatory = $true)][string]$RepoRoot,
    [Parameter(Mandatory = $true)][string]$Iwad,
    [Parameter(Mandatory = $true)][string]$ArtifactDir
)

$ErrorActionPreference = 'Stop'
Import-Module (Join-Path (Split-Path -Parent $PSScriptRoot) 'lib\MiniDoomTest.psm1') -Force

$renderer = Get-Content -LiteralPath (Join-Path $RepoRoot 'src\r_gl.ml') -Raw

if ($renderer -notmatch '(?s)function RGL_DrawSky\(yaw\).*?skyCenter\s*=\s*RGL_NormalizeDegrees\(yaw\)\s*/\s*90\.0') {
    throw 'OpenGL sky no longer anchors its horizontal texture origin to camera yaw.'
}
if ($renderer -notmatch '(?s)function RGL_DrawSky\(yaw\).*?s0\s*=\s*skyCenter\s*\+\s*0\.5.*?s1\s*=\s*skyCenter\s*-\s*0\.5') {
    throw 'OpenGL sky span no longer follows Doom xtoviewangle orientation.'
}

# Purpose: Measures the upper game-window band where Doom II MAP13 exposes the sky at its outdoor start.
function Measure-SkyBandDifference {
    param(
        [Parameter(Mandatory = $true)][string]$A,
        [Parameter(Mandatory = $true)][string]$B
    )

    Add-Type -AssemblyName System.Drawing
    $left = [System.Drawing.Bitmap]::FromFile($A)
    $right = [System.Drawing.Bitmap]::FromFile($B)
    try {
        $width = [Math]::Min($left.Width, $right.Width)
        $height = [Math]::Min($left.Height, $right.Height)
        $startY = 40
        $endY = [int]($height * 0.30)
        [double]$sum = 0
        [int]$channels = 0
        $startX = [int]($width * 0.49)
        $endX = [int]($width * 0.56)
        for ($y = $startY; $y -lt $endY; $y += 2) {
            for ($x = $startX; $x -lt $endX; $x += 2) {
                $ca = $left.GetPixel($x, $y)
                $cb = $right.GetPixel($x, $y)
                $sum += [Math]::Abs($ca.R - $cb.R) + [Math]::Abs($ca.G - $cb.G) + [Math]::Abs($ca.B - $cb.B)
                $channels += 3
            }
        }
        if ($channels -eq 0) { return 0.0 }
        return $sum / $channels
    }
    finally {
        $left.Dispose()
        $right.Dispose()
    }
}

$runtime = $null
try {
    $runtime = Start-MiniDoomForTest -RepoRoot $RepoRoot -Arguments @('-iwad', $Iwad, '-windowed', '-opengl', '-warp', '13', '-nomonsters') -WindowTimeoutSeconds 45
    Start-Sleep -Seconds 5
    Assert-MiniDoomHealthy -Process $runtime
    $beforeTurn = Join-Path $ArtifactDir '01_map13_sky_before_turn.png'
    Save-MiniDoomWindowImage -Process $runtime -Path $beforeTurn | Out-Null
    # A short slow-turn keeps the same central sky opening visible in both frames.
    Send-MiniDoomKey -Process $runtime -VirtualKey 0x25 -HoldMilliseconds 150
    Start-Sleep -Milliseconds 350
    $afterTurn = Join-Path $ArtifactDir '02_map13_sky_after_turn.png'
    Save-MiniDoomWindowImage -Process $runtime -Path $afterTurn | Out-Null
    Assert-MiniDoomImageLooksDrawn -Path $afterTurn -Label 'OpenGL sky after camera turn'
    $skyDifference = Measure-SkyBandDifference -A $beforeTurn -B $afterTurn
    Assert-True ($skyDifference -gt 1.0) "OpenGL sky remained screen-locked after a camera turn (upper-band mean diff $skyDifference)."
}
finally {
    Stop-MiniDoomForTest -Process $runtime
}

Write-Output 'OpenGL yaw-anchored sky projection and runtime turn PASS.'
