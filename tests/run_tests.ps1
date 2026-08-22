param(
    [string]$Compiler,
    [string]$Std,
    [string]$Python,
    [string]$Iwad,
    [string[]]$Test,
    [switch]$SkipBuild,
    [switch]$CleanBuild,
    [switch]$KeepArtifacts
)

$ErrorActionPreference = 'Stop'
$RepoRoot = (Resolve-Path (Join-Path $PSScriptRoot '..')).Path
Import-Module (Join-Path $PSScriptRoot 'lib\MiniDoomTest.psm1') -Force

$compilerPath = Resolve-MiniDoomCompiler -Compiler $Compiler
$pythonPath = Resolve-MiniDoomPython -Python $Python
$stdPath = Resolve-MiniDoomStd -Std $Std -Compiler $compilerPath
$iwadPath = Resolve-MiniDoomIwad -RepoRoot $RepoRoot -Iwad $Iwad

if (-not $SkipBuild) {
    Invoke-MiniDoomBuild -RepoRoot $RepoRoot -Compiler $compilerPath -Std $stdPath -Python $pythonPath -Clean:$CleanBuild
}

$testsDir = Join-Path $PSScriptRoot 'cases'
$scripts = Get-ChildItem -Path $testsDir -Filter 'test_*.ps1' | Sort-Object Name
if ($Test -and $Test.Count -gt 0) {
    $wanted = @{}
    foreach ($t in $Test) { $wanted[$t.ToLowerInvariant()] = $true }
    $scripts = $scripts | Where-Object {
        $base = [IO.Path]::GetFileNameWithoutExtension($_.Name).ToLowerInvariant()
        $short = $base -replace '^test_', ''
        $wanted.ContainsKey($base) -or $wanted.ContainsKey($short)
    }
}

if (-not $scripts -or $scripts.Count -eq 0) {
    throw 'No tests selected.'
}

$artifactRoot = Join-Path $RepoRoot 'test-results'
New-Item -ItemType Directory -Force -Path $artifactRoot | Out-Null

$failures = @()
foreach ($script in $scripts) {
    $name = [IO.Path]::GetFileNameWithoutExtension($script.Name)
    $artifactDir = Join-Path $artifactRoot $name
    if (Test-Path $artifactDir) { Remove-Item -LiteralPath $artifactDir -Recurse -Force }
    New-Item -ItemType Directory -Force -Path $artifactDir | Out-Null

    Write-Host ""
    Write-Host "=== $name ==="
    try {
        & $script.FullName -RepoRoot $RepoRoot -Iwad $iwadPath -ArtifactDir $artifactDir
        Write-Host "PASS $name" -ForegroundColor Green
    }
    catch {
        $failures += [pscustomobject]@{ Test = $name; Error = $_.Exception.Message }
        Write-Host "FAIL $name`: $($_.Exception.Message)" -ForegroundColor Red
    }
}

if (-not $KeepArtifacts -and $failures.Count -eq 0) {
    Write-Host ""
    Write-Host "Artifacts kept in $artifactRoot for this first framework version."
}

Write-Host ""
if ($failures.Count -gt 0) {
    Write-Host "FAILED $($failures.Count) test(s):" -ForegroundColor Red
    foreach ($f in $failures) {
        Write-Host " - $($f.Test): $($f.Error)"
    }
    exit 1
}

Write-Host "All MiniDoom tests passed." -ForegroundColor Green
exit 0
