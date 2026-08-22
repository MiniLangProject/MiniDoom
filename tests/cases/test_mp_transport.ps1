param(
    [Parameter(Mandatory = $true)][string]$RepoRoot,
    [Parameter(Mandatory = $true)][string]$Iwad,
    [Parameter(Mandatory = $true)][string]$ArtifactDir
)

# Scenario: compile and run an isolated console fixture covering wire-codec
# corruption rejection, netbuffer atomicity, queue bounds, and freshness.

$ErrorActionPreference = 'Stop'
Import-Module (Join-Path (Split-Path -Parent $PSScriptRoot) 'lib\MiniDoomTest.psm1') -Force

# The IWAD parameter is part of the common case contract; codec coverage does
# not open it because the FNV implementation uses a fixed known vector here.
$null = $Iwad
$compiler = Resolve-MiniDoomCompiler
$python = Resolve-MiniDoomPython
$std = Resolve-MiniDoomStd -Compiler $compiler
$fixture = Join-Path $RepoRoot 'tests\fixtures\mp_transport_unit.ml'
$exe = Join-Path $ArtifactDir 'mp_transport_unit.exe'
$stdout = Join-Path $ArtifactDir 'mp_transport_unit.stdout.log'
$stderr = Join-Path $ArtifactDir 'mp_transport_unit.stderr.log'
$glHelper = Join-Path $RepoRoot 'build\MiniDoomGL.dll'

Assert-True (Test-Path $fixture) "MP transport fixture is missing: $fixture"
Assert-True (Test-Path $glHelper) "MiniDoomGL.dll is required for imported platform extern validation: $glHelper"
Copy-Item -LiteralPath $glHelper -Destination (Join-Path $ArtifactDir 'MiniDoomGL.dll') -Force
& $python $compiler $fixture $exe '-I' (Join-Path $RepoRoot 'src') '-I' (Split-Path -Parent $std) '--subsystem' 'console'
Assert-True ($LASTEXITCODE -eq 0) "MP transport fixture compilation failed with exit code $LASTEXITCODE."

$p = Start-Process -FilePath $exe -WorkingDirectory $ArtifactDir -RedirectStandardOutput $stdout -RedirectStandardError $stderr -PassThru
if (-not $p.WaitForExit(30000)) {
    Stop-Process -Id $p.Id -Force -ErrorAction SilentlyContinue
    throw 'MP transport fixture timed out.'
}
$p.Refresh()
$out = if (Test-Path $stdout) { Get-Content -LiteralPath $stdout -Raw } else { '' }
$err = if (Test-Path $stderr) { Get-Content -LiteralPath $stderr -Raw } else { '' }
Assert-True ($p.ExitCode -eq 0) "MP transport fixture failed with exit code $($p.ExitCode). stdout=$out stderr=$err"
Assert-True ($out -match 'MP transport unit PASS') "MP transport fixture did not emit its PASS marker. stdout=$out"
