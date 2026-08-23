param(
    [Parameter(Mandatory = $true)][string]$RepoRoot,
    [Parameter(Mandatory = $true)][string]$Iwad,
    [Parameter(Mandatory = $true)][string]$ArtifactDir
)

$ErrorActionPreference = 'Stop'
Import-Module (Join-Path (Split-Path -Parent $PSScriptRoot) 'lib\MiniDoomTest.psm1') -Force

# Purpose: Types one console command through MiniDoom's real polled keyboard path.
function Send-InvisibleTestCommand {
    param(
        [Parameter(Mandatory = $true)][System.Diagnostics.Process]$Process,
        [Parameter(Mandatory = $true)][string]$Command
    )

    foreach ($character in $Command.ToUpperInvariant().ToCharArray()) {
        Send-MiniDoomKey -Process $Process -VirtualKey ([int][char]$character) -HoldMilliseconds 45
    }
    Send-MiniDoomKey -Process $Process -VirtualKey 0x0D -HoldMilliseconds 70
}

# Purpose: Measures a normalized window region so HUD assertions remain independent of window scale.
function Measure-NormalizedRegionDifference {
    param(
        [Parameter(Mandatory = $true)][string]$A,
        [Parameter(Mandatory = $true)][string]$B,
        [Parameter(Mandatory = $true)][double]$Left,
        [Parameter(Mandatory = $true)][double]$Top,
        [Parameter(Mandatory = $true)][double]$Right,
        [Parameter(Mandatory = $true)][double]$Bottom
    )

    Add-Type -AssemblyName System.Drawing
    $before = [System.Drawing.Bitmap]::FromFile($A)
    $after = [System.Drawing.Bitmap]::FromFile($B)
    try {
        $width = [Math]::Min($before.Width, $after.Width)
        $height = [Math]::Min($before.Height, $after.Height)
        $x0 = [int]($width * $Left)
        $x1 = [int]($width * $Right)
        $y0 = [int]($height * $Top)
        $y1 = [int]($height * $Bottom)
        [double]$sum = 0
        [int]$channels = 0
        for ($y = $y0; $y -lt $y1; $y += 2) {
            for ($x = $x0; $x -lt $x1; $x += 2) {
                $ca = $before.GetPixel($x, $y)
                $cb = $after.GetPixel($x, $y)
                $sum += [Math]::Abs($ca.R - $cb.R) + [Math]::Abs($ca.G - $cb.G) + [Math]::Abs($ca.B - $cb.B)
                $channels += 3
            }
        }
        if ($channels -eq 0) { return 0.0 }
        return $sum / $channels
    }
    finally {
        $before.Dispose()
        $after.Dispose()
    }
}

$p = $null
try {
    $p = Start-MiniDoomForTest -RepoRoot $RepoRoot -Arguments @('-iwad', $Iwad, '-windowed', '-opengl', '-warp', '1') -WindowTimeoutSeconds 45
    Start-Sleep -Seconds 2
    Assert-MiniDoomHealthy -Process $p

    Send-MiniDoomKey -Process $p -VirtualKey 0xDC -HoldMilliseconds 120
    Start-Sleep -Milliseconds 300
    Send-InvisibleTestCommand -Process $p -Command 'invisible'
    Send-MiniDoomKey -Process $p -VirtualKey 0xDC -HoldMilliseconds 120
    Start-Sleep -Seconds 1

    $beforeShot = Join-Path $ArtifactDir '01_invisible_before_shot.png'
    Save-MiniDoomWindowImage -Process $p -Path $beforeShot | Out-Null
    Send-MiniDoomKey -Process $p -VirtualKey 0x11 -HoldMilliseconds 100
    Start-Sleep -Seconds 8
    $afterShot = Join-Path $ArtifactDir '02_invisible_after_shot.png'
    Save-MiniDoomWindowImage -Process $p -Path $afterShot | Out-Null
    Assert-MiniDoomImageLooksDrawn -Path $afterShot -Label 'persistent invisible after firing near monsters'

    $ammoDifference = Measure-NormalizedRegionDifference -A $beforeShot -B $afterShot -Left 0.04 -Top 0.86 -Right 0.14 -Bottom 0.97
    Assert-True ($ammoDifference -gt 0.25) "Test shot did not visibly consume ammunition (ammo-region mean diff $ammoDifference)."
    $healthDifference = Measure-NormalizedRegionDifference -A $beforeShot -B $afterShot -Left 0.15 -Top 0.86 -Right 0.32 -Bottom 0.97
    Assert-True ($healthDifference -lt 0.25) "Monsters damaged the persistent invisible player after firing (health-region mean diff $healthDifference)."
}
finally {
    Stop-MiniDoomForTest -Process $p
}

Write-Output 'Persistent invisible ignores sight, sound, firing, and damage retaliation PASS.'
