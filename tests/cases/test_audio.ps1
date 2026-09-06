param(
    [Parameter(Mandatory = $true)][string]$RepoRoot,
    [Parameter(Mandatory = $true)][string]$Iwad,
    [Parameter(Mandatory = $true)][string]$ArtifactDir,
    [switch]$Device
)

# Compile the real mixer as a console fixture; no game window or user input is required.
$ErrorActionPreference = 'Stop'
Import-Module (Join-Path (Split-Path -Parent $PSScriptRoot) 'lib\MiniDoomTest.psm1') -Force
$compiler = Resolve-MiniDoomCompiler
$python = Resolve-MiniDoomPython
$std = Resolve-MiniDoomStd -Compiler $compiler
$artifact = [IO.Path]::GetFullPath($ArtifactDir)
New-Item -ItemType Directory -Force -Path $artifact | Out-Null
$fixture = Join-Path $RepoRoot 'tests\fixtures\audio_unit.ml'
$exe = Join-Path $artifact 'audio_unit.exe'
$buildLog = Join-Path $artifact 'audio_unit.build.log'
$stdout = Join-Path $artifact 'audio_unit.stdout.log'
$stderr = Join-Path $artifact 'audio_unit.stderr.log'
$glHelper = Join-Path $RepoRoot 'build\MiniDoomGL.dll'
Assert-True (Test-Path -LiteralPath $glHelper) "MiniDoomGL.dll is required for imported platform bindings: $glHelper"
Copy-Item -LiteralPath $glHelper -Destination (Join-Path $artifact 'MiniDoomGL.dll') -Force
& $python $compiler $fixture $exe '-I' (Join-Path $RepoRoot 'src') '-I' (Split-Path -Parent $std) '--target' 'windows-x64' '--subsystem' 'console' *> $buildLog
Assert-True ($LASTEXITCODE -eq 0) "Audio fixture compilation failed. See $buildLog"

$fixtureArgs = @('"' + (Resolve-Path -LiteralPath $Iwad).Path + '"')
if ($Device) { $fixtureArgs += '--device' }
$process = Start-Process -FilePath $exe -ArgumentList $fixtureArgs -WorkingDirectory $artifact -WindowStyle Hidden -RedirectStandardOutput $stdout -RedirectStandardError $stderr -PassThru
if (-not $process.WaitForExit(30000)) {
    Stop-Process -Id $process.Id -Force -ErrorAction SilentlyContinue
    throw 'Audio fixture timed out.'
}
$process.Refresh()
$output = if (Test-Path -LiteralPath $stdout) { Get-Content -LiteralPath $stdout -Raw } else { '' }
$errorOutput = if (Test-Path -LiteralPath $stderr) { Get-Content -LiteralPath $stderr -Raw } else { '' }
Assert-True ($process.ExitCode -eq 0) "Audio fixture failed with exit code $($process.ExitCode). stdout=$output stderr=$errorOutput"
Assert-True ($output -match 'Audio unit PASS') "Audio fixture did not emit its PASS marker. stdout=$output"
Assert-True ($output -match 'Original DMX effects checked: [1-9]') 'Audio fixture did not exercise any original IWAD sound effects.'
Write-Output $output.TrimEnd()
