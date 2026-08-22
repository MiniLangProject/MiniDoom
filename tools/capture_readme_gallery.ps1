[CmdletBinding()]
param(
    [string]$RepoRoot,
    [string]$Doom1Wad,
    [string]$Doom2Wad,
    [string]$OutputDir,
    [ValidateSet('All', 'Doom1', 'Doom2')][string]$Game = 'All',
    [string[]]$Map = @(),
    [int]$TimeoutSeconds = 600,
    [int]$SettleMilliseconds = 5000,
    [ValidateRange(1, 4)][int]$RenderScale = 3,
    [switch]$Force
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

Add-Type -AssemblyName System.Drawing

if ([string]::IsNullOrWhiteSpace($RepoRoot)) {
    $RepoRoot = Split-Path -Parent $PSScriptRoot
}

<#
.SYNOPSIS
Resolves an optional gallery path against its explicit fallback.
#>
function Resolve-GalleryPath {
    param([string]$Path, [string]$Fallback)

    if ([string]::IsNullOrWhiteSpace($Path)) { $Path = $Fallback }
    return [IO.Path]::GetFullPath($Path)
}

<#
.SYNOPSIS
Reads unique E#M#/MAP## markers from a validated WAD directory in source order.
#>
function Get-WadMapNames {
    param([Parameter(Mandatory = $true)][string]$Path)

    $stream = [IO.File]::OpenRead($Path)
    try {
        $reader = [IO.BinaryReader]::new($stream)
        try {
            $magic = [Text.Encoding]::ASCII.GetString($reader.ReadBytes(4))
            if ($magic -notin @('IWAD', 'PWAD')) { throw "Unsupported WAD header '$magic': $Path" }

            $lumpCount = $reader.ReadInt32()
            $directoryOffset = $reader.ReadInt32()
            if ($lumpCount -lt 1 -or $directoryOffset -lt 12 -or $directoryOffset -ge $stream.Length) {
                throw "Invalid WAD directory: $Path"
            }

            $stream.Position = $directoryOffset
            $maps = [Collections.Generic.List[string]]::new()
            for ($i = 0; $i -lt $lumpCount; $i++) {
                [void]$reader.ReadInt32()
                [void]$reader.ReadInt32()
                $name = [Text.Encoding]::ASCII.GetString($reader.ReadBytes(8)).Trim([char]0)
                if ($name -match '^(E\dM\d|MAP\d\d)$') { $maps.Add($name) }
            }
            return @($maps | Select-Object -Unique)
        }
        finally {
            $reader.Dispose()
        }
    }
    finally {
        $stream.Dispose()
    }
}

<#
.SYNOPSIS
Validates a captured bitmap and writes the PNG artifact consumed by the README gallery.
#>
function Convert-BmpToPng {
    param(
        [Parameter(Mandatory = $true)][string]$Source,
        [Parameter(Mandatory = $true)][string]$Destination
    )

    $image = [Drawing.Image]::FromFile($Source)
    try {
        if ($image.Width -lt 320 -or $image.Height -lt 200) {
            throw "Captured frame has an unexpected size ($($image.Width)x$($image.Height)): $Source"
        }
        $image.Save($Destination, [Drawing.Imaging.ImageFormat]::Png)
    }
    finally {
        $image.Dispose()
    }

    if ((Get-Item -LiteralPath $Destination).Length -lt 1024) {
        throw "Captured PNG looks empty: $Destination"
    }
}

<#
.SYNOPSIS
Terminates only the MiniDoom process launched for the current gallery frame.
#>
function Stop-GalleryProcess {
    param([Diagnostics.Process]$Process)

    if ($null -eq $Process) { return }
    $Process.Refresh()
    if (-not $Process.HasExited) {
        Stop-Process -Id $Process.Id -Force -ErrorAction SilentlyContinue
        [void]$Process.WaitForExit(3000)
    }
}

<#
.SYNOPSIS
Launches one map/renderer combination, waits for a settled frame, and saves its gallery PNG.
#>
function Capture-GalleryFrame {
    param(
        [Parameter(Mandatory = $true)][string]$Exe,
        [Parameter(Mandatory = $true)][string]$Wad,
        [Parameter(Mandatory = $true)][string]$MapName,
        [Parameter(Mandatory = $true)][ValidateSet('classic', 'opengl')][string]$Renderer,
        [Parameter(Mandatory = $true)][string]$WorkingDirectory,
        [Parameter(Mandatory = $true)][string]$Destination,
        [Parameter(Mandatory = $true)][int]$Timeout,
        [Parameter(Mandatory = $true)][int]$SettleTime,
        [Parameter(Mandatory = $true)][int]$Scale
    )

    $arguments = @(
        '-iwad', ('"' + $Wad + '"'),
        '-windowed', '-renderscale', $Scale, '-shots'
    )
    if ($Renderer -eq 'opengl') {
        $arguments += @('-opengl', '-novsync', '-maxfps', '120')
    }
    $arguments += '-warp'
    if ($MapName -match '^E(\d)M(\d)$') {
        $arguments += @($Matches[1], $Matches[2])
    }
    else {
        $arguments += [int]$MapName.Substring(3)
    }

    $process = $null
    try {
        $process = Start-Process -FilePath $Exe -ArgumentList $arguments -WorkingDirectory $WorkingDirectory -WindowStyle Hidden -PassThru
        $renderOutput = Join-Path $WorkingDirectory 'render_output'
        $deadline = (Get-Date).AddSeconds($Timeout)
        $latest = $null

        while ((Get-Date) -lt $deadline) {
            Start-Sleep -Milliseconds 100
            $process.Refresh()
            if ($process.HasExited) {
                throw "MiniDoom exited while capturing $MapName ($Renderer), exit code $($process.ExitCode)."
            }

            $frames = @(Get-ChildItem -LiteralPath $renderOutput -Filter 'frame_*.bmp' -File -ErrorAction SilentlyContinue |
                Sort-Object LastWriteTimeUtc)
            if ($frames.Count -gt 0 -and $process.MainWindowTitle -match 'FPS:\s*[1-9]\d*') {
                # The first FPS update can overlap the startup melt transition.
                # Give the level a short, deterministic settling window so the
                # selected frame always shows normal gameplay.
                Start-Sleep -Milliseconds $SettleTime
                $latest = Get-ChildItem -LiteralPath $renderOutput -Filter 'frame_*.bmp' -File |
                    Sort-Object LastWriteTimeUtc |
                    Select-Object -Last 1
                break
            }
        }

        if ($null -eq $latest) {
            throw "Timed out after $Timeout seconds while capturing $MapName ($Renderer)."
        }

        Convert-BmpToPng -Source $latest.FullName -Destination $Destination
    }
    finally {
        Stop-GalleryProcess -Process $process
    }
}

$repo = Resolve-GalleryPath -Path $RepoRoot -Fallback $RepoRoot
$exe = Join-Path $repo 'build\MiniDoom.exe'
if (-not (Test-Path -LiteralPath $exe -PathType Leaf)) {
    throw "MiniDoom.exe not found: $exe"
}

$doom1 = Resolve-GalleryPath -Path $Doom1Wad -Fallback (Join-Path $repo 'build\Doom1.wad')
$doom2 = Resolve-GalleryPath -Path $Doom2Wad -Fallback (Join-Path $repo 'build\Doom2.wad')
$output = Resolve-GalleryPath -Path $OutputDir -Fallback (Join-Path $repo 'docs\gallery')

$games = @()
if ($Game -in @('All', 'Doom1')) {
    if (-not (Test-Path -LiteralPath $doom1 -PathType Leaf)) { throw "Doom 1 IWAD not found: $doom1" }
    $games += [pscustomobject]@{ Name = 'doom1'; Wad = $doom1; Maps = @(Get-WadMapNames -Path $doom1) }
}
if ($Game -in @('All', 'Doom2')) {
    if (-not (Test-Path -LiteralPath $doom2 -PathType Leaf)) { throw "Doom 2 IWAD not found: $doom2" }
    $games += [pscustomobject]@{ Name = 'doom2'; Wad = $doom2; Maps = @(Get-WadMapNames -Path $doom2) }
}

$mapFilter = @{}
foreach ($requestedMap in $Map) { $mapFilter[$requestedMap.ToUpperInvariant()] = $true }

$tempBase = [IO.Path]::GetFullPath([IO.Path]::GetTempPath())
$workRoot = Join-Path $tempBase ('MiniDoomGallery_' + [guid]::NewGuid().ToString('N'))
[void](New-Item -ItemType Directory -Path $workRoot -Force)

try {
    $captures = 0
    foreach ($gameInfo in $games) {
        $gameOutput = Join-Path $output $gameInfo.Name
        [void](New-Item -ItemType Directory -Path $gameOutput -Force)

        foreach ($mapName in $gameInfo.Maps) {
            if ($mapFilter.Count -gt 0 -and -not $mapFilter.ContainsKey($mapName.ToUpperInvariant())) { continue }

            foreach ($renderer in @('classic', 'opengl')) {
                $destination = Join-Path $gameOutput ($mapName.ToLowerInvariant() + '-' + $renderer + '.png')
                if ((-not $Force) -and (Test-Path -LiteralPath $destination -PathType Leaf)) {
                    Write-Host "SKIP $($gameInfo.Name) $mapName $renderer"
                    continue
                }

                $captureWork = Join-Path $workRoot ($gameInfo.Name + '_' + $mapName + '_' + $renderer)
                [void](New-Item -ItemType Directory -Path $captureWork -Force)
                Write-Host "CAPTURE $($gameInfo.Name) $mapName $renderer"
                Capture-GalleryFrame -Exe $exe -Wad $gameInfo.Wad -MapName $mapName -Renderer $renderer `
                    -WorkingDirectory $captureWork -Destination $destination -Timeout $TimeoutSeconds `
                    -SettleTime $SettleMilliseconds -Scale $RenderScale
                $captures++
            }
        }
    }

    Write-Host "Gallery capture complete: $captures new image(s) in $output"
}
finally {
    $resolvedWorkRoot = [IO.Path]::GetFullPath($workRoot)
    $leaf = Split-Path -Leaf $resolvedWorkRoot
    if ($resolvedWorkRoot.StartsWith($tempBase, [StringComparison]::OrdinalIgnoreCase) -and $leaf -like 'MiniDoomGallery_*') {
        Remove-Item -LiteralPath $resolvedWorkRoot -Recurse -Force -ErrorAction SilentlyContinue
    }
    else {
        Write-Warning "Refusing to remove unexpected temporary path: $resolvedWorkRoot"
    }
}
