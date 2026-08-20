param(
    [Parameter(Mandatory = $true)][string]$RepoRoot,
    [Parameter(Mandatory = $true)][string]$Iwad,
    [Parameter(Mandatory = $true)][string]$ArtifactDir
)

$ErrorActionPreference = 'Stop'
Import-Module (Join-Path (Split-Path -Parent $PSScriptRoot) 'lib\MiniDoomTest.psm1') -Force

function Capture-Map01([bool]$NoMonsters, [string]$Path) {
    $p = $null
    $argsList = @('-iwad', $Iwad, '-windowed', '-opengl', '-warp', '1')
    if ($NoMonsters) { $argsList += '-nomonsters' }
    try {
        $p = Start-MiniDoomForTest -RepoRoot $RepoRoot -Arguments $argsList -WindowTimeoutSeconds 45
        Start-Sleep -Seconds 4
        Assert-MiniDoomHealthy -Process $p
        Save-MiniDoomWindowImage -Process $p -Path $Path | Out-Null
        Assert-MiniDoomImageLooksDrawn -Path $Path -Label 'OpenGL sprite regression'
    }
    finally {
        Stop-MiniDoomForTest -Process $p
    }
}

$withMonsters = Join-Path $ArtifactDir 'map01_with_monsters.png'
$withoutMonsters = Join-Path $ArtifactDir 'map01_without_monsters.png'
Capture-Map01 -NoMonsters $false -Path $withMonsters
Capture-Map01 -NoMonsters $true -Path $withoutMonsters

# MAP01 starts with two visible enemies.  If the native sprite stream drops
# texture uploads, both captures become nearly identical despite active mobjs.
$difference = Measure-MiniDoomImageDifference -A $withMonsters -B $withoutMonsters
Assert-True ($difference -gt 0.05) "OpenGL world sprites appear to be missing (mean image difference $difference)."
