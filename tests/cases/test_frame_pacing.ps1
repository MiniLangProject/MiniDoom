param(
    [Parameter(Mandatory = $true)][string]$RepoRoot,
    [Parameter(Mandatory = $true)][string]$Iwad,
    [Parameter(Mandatory = $true)][string]$ArtifactDir
)

$ErrorActionPreference = 'Stop'
Import-Module (Join-Path (Split-Path -Parent $PSScriptRoot) 'lib\MiniDoomTest.psm1') -Force

$p = $null
$profilePath = Join-Path $RepoRoot 'build\minidoom_profile.log'
try {
    $p = Start-MiniDoomForTest -RepoRoot $RepoRoot -Arguments @(
        '-iwad', $Iwad,
        '-opengl', '-novsync', '-maxfps', '30', '-profile-render',
        '-warp', '1', '-nomonsters'
    ) -WindowTimeoutSeconds 45
    Start-Sleep -Seconds 8
    Assert-MiniDoomHealthy -Process $p
}
finally {
    Stop-MiniDoomForTest -Process $p
}

Assert-True (Test-Path $profilePath) "Frame-pacing profile log was not created."
$artifactLog = Join-Path $ArtifactDir 'minidoom_profile.log'
Copy-Item -LiteralPath $profilePath -Destination $artifactLog -Force
$lines = @(Get-Content -LiteralPath $profilePath)
$frameLines = @($lines | Where-Object { $_ -like 'PROFILE frame:*' })
$pacingLines = @($lines | Where-Object { $_ -like 'PROFILE pacing:*' })
Assert-True ($frameLines.Count -ge 2) "Expected at least two frame-profile windows, got $($frameLines.Count)."
Assert-True ($pacingLines.Count -ge 2) "Expected at least two pacing-profile windows, got $($pacingLines.Count)."

foreach ($line in @($frameLines | Select-Object -Last 2)) {
    Assert-True ($line -match 'fps=(\d+)') "Could not parse FPS from '$line'."
    $fps = [int]$Matches[1]
    Assert-True ($fps -ge 27 -and $fps -le 31) "30 FPS cap drifted outside tolerance: $fps FPS."
}

foreach ($line in @($pacingLines | Select-Object -Last 2)) {
    Assert-True ($line -match 'p50=(\d+)ms') "Could not parse p50 from '$line'."
    $p50 = [int]$Matches[1]
    Assert-True ($p50 -ge 32 -and $p50 -le 38) "30 FPS pacing has an unexpected median interval: ${p50}ms."
}
