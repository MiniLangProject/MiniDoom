[CmdletBinding()]
param(
    [string]$RepoRoot,
    [string]$Doom1Wad,
    [string]$Doom2Wad,
    [ValidateSet('All', 'Doom1', 'Doom2')][string]$Game = 'All',
    [string[]]$Map = @(),
    [ValidateRange(1, 20)][int]$Samples = 3,
    [ValidateRange(0, 30)][int]$WarmupSeconds = 1,
    [ValidateRange(10, 600)][int]$TimeoutSeconds = 120,
    [string]$OutputCsv,
    [switch]$NoMonsters
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

if ([string]::IsNullOrWhiteSpace($RepoRoot)) {
    $RepoRoot = Split-Path -Parent $PSScriptRoot
}
$repo = [IO.Path]::GetFullPath($RepoRoot)
$exe = Join-Path $repo 'build\MiniDoom.exe'
if (-not (Test-Path -LiteralPath $exe -PathType Leaf)) { throw "MiniDoom.exe not found: $exe" }

if ([string]::IsNullOrWhiteSpace($Doom1Wad)) { $Doom1Wad = Join-Path $repo 'build\Doom1.wad' }
if ([string]::IsNullOrWhiteSpace($Doom2Wad)) { $Doom2Wad = Join-Path $repo 'build\Doom2.wad' }
if ([string]::IsNullOrWhiteSpace($OutputCsv)) { $OutputCsv = Join-Path $repo 'test-results\opengl-map-benchmark.csv' }

function Get-WadMapNames {
    param([Parameter(Mandatory = $true)][string]$Path)

    $resolved = (Resolve-Path -LiteralPath $Path).Path
    $stream = [IO.File]::OpenRead($resolved)
    try {
        $reader = [IO.BinaryReader]::new($stream)
        try {
            $magic = [Text.Encoding]::ASCII.GetString($reader.ReadBytes(4))
            if ($magic -notin @('IWAD', 'PWAD')) { throw "Unsupported WAD header '$magic': $resolved" }
            $count = $reader.ReadInt32()
            $directoryOffset = $reader.ReadInt32()
            if ($count -lt 1 -or $directoryOffset -lt 12 -or $directoryOffset -ge $stream.Length) {
                throw "Invalid WAD directory: $resolved"
            }
            $stream.Position = $directoryOffset
            $maps = [Collections.Generic.List[string]]::new()
            for ($i = 0; $i -lt $count; $i++) {
                [void]$reader.ReadInt32()
                [void]$reader.ReadInt32()
                $name = [Text.Encoding]::ASCII.GetString($reader.ReadBytes(8)).Trim([char]0)
                if ($name -match '^(E\dM\d|MAP\d\d)$') { $maps.Add($name) }
            }
            return @($maps | Select-Object -Unique)
        }
        finally { $reader.Dispose() }
    }
    finally { $stream.Dispose() }
}

function Stop-BenchmarkProcess {
    param([Diagnostics.Process]$Process)

    if ($null -eq $Process) { return }
    $Process.Refresh()
    if (-not $Process.HasExited) {
        Stop-Process -Id $Process.Id -Force -ErrorAction SilentlyContinue
        [void]$Process.WaitForExit(3000)
    }
}

function Measure-MapFps {
    param(
        [Parameter(Mandatory = $true)][string]$Wad,
        [Parameter(Mandatory = $true)][string]$MapName
    )

    $arguments = @('-iwad', ('"' + $Wad + '"'), '-windowed', '-opengl', '-novsync', '-maxfps', '0', '-warp')
    if ($NoMonsters) { $arguments += '-nomonsters' }
    if ($MapName -match '^E(\d)M(\d)$') {
        $arguments += @($Matches[1], $Matches[2])
    }
    else {
        $arguments += [int]$MapName.Substring(3)
    }

    $process = $null
    try {
        $process = Start-Process -FilePath $exe -ArgumentList $arguments -WorkingDirectory (Join-Path $repo 'build') -WindowStyle Hidden -PassThru
        $deadline = (Get-Date).AddSeconds($TimeoutSeconds)
        $firstFps = 0
        while ((Get-Date) -lt $deadline) {
            Start-Sleep -Milliseconds 100
            $process.Refresh()
            if ($process.HasExited) { throw "MiniDoom exited while starting $MapName (exit $($process.ExitCode))." }
            if ($process.MainWindowTitle -match 'FPS:\s*(\d+)' -and [int]$Matches[1] -gt 0) {
                $firstFps = [int]$Matches[1]
                break
            }
        }
        if ($firstFps -le 0) { throw "Timed out waiting for gameplay FPS on $MapName." }

        if ($WarmupSeconds -gt 0) { Start-Sleep -Seconds $WarmupSeconds }
        $values = [Collections.Generic.List[int]]::new()
        for ($i = 0; $i -lt $Samples; $i++) {
            Start-Sleep -Milliseconds 1100
            $process.Refresh()
            if ($process.HasExited) { throw "MiniDoom exited while benchmarking $MapName." }
            if ($process.MainWindowTitle -notmatch 'FPS:\s*(\d+)') { throw "Could not read FPS for $MapName." }
            $values.Add([int]$Matches[1])
        }

        $ordered = @($values | Sort-Object)
        $median = $ordered[[int][Math]::Floor($ordered.Count / 2)]
        return [pscustomobject]@{
            Map = $MapName
            MinFps = ($ordered | Measure-Object -Minimum).Minimum
            MedianFps = $median
            MaxFps = ($ordered | Measure-Object -Maximum).Maximum
            Samples = ($values -join ';')
        }
    }
    finally { Stop-BenchmarkProcess -Process $process }
}

$runs = @()
if ($Game -in @('All', 'Doom1')) {
    $resolved = (Resolve-Path -LiteralPath $Doom1Wad).Path
    $runs += [pscustomobject]@{ Game = 'Doom1'; Wad = $resolved; Maps = @(Get-WadMapNames -Path $resolved) }
}
if ($Game -in @('All', 'Doom2')) {
    $resolved = (Resolve-Path -LiteralPath $Doom2Wad).Path
    $runs += [pscustomobject]@{ Game = 'Doom2'; Wad = $resolved; Maps = @(Get-WadMapNames -Path $resolved) }
}

$results = [Collections.Generic.List[object]]::new()
$mapFilter = @{}
foreach ($requestedMap in $Map) { $mapFilter[$requestedMap.ToUpperInvariant()] = $true }
foreach ($run in $runs) {
    foreach ($mapName in $run.Maps) {
        if ($mapFilter.Count -gt 0 -and -not $mapFilter.ContainsKey($mapName.ToUpperInvariant())) { continue }
        $measurement = Measure-MapFps -Wad $run.Wad -MapName $mapName
        $row = [pscustomobject]@{
            Game = $run.Game
            Map = $measurement.Map
            MinFps = $measurement.MinFps
            MedianFps = $measurement.MedianFps
            MaxFps = $measurement.MaxFps
            Samples = $measurement.Samples
        }
        $results.Add($row)
        Write-Host ("{0} {1}: min={2} median={3} max={4}" -f $row.Game, $row.Map, $row.MinFps, $row.MedianFps, $row.MaxFps)
    }
}

$outputParent = Split-Path -Parent ([IO.Path]::GetFullPath($OutputCsv))
if (-not (Test-Path -LiteralPath $outputParent)) { [void](New-Item -ItemType Directory -Path $outputParent -Force) }
$results | Export-Csv -LiteralPath $OutputCsv -NoTypeInformation -Encoding UTF8

$slowest = $results | Sort-Object MedianFps, MinFps | Select-Object -First 10
Write-Host ""
Write-Host "Slowest maps:"
$slowest | Format-Table Game, Map, MinFps, MedianFps, MaxFps -AutoSize
Write-Host "Results: $OutputCsv"
