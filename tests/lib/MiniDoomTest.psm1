Set-StrictMode -Version Latest

$script:NativeLoaded = $false

function Get-MiniDoomRepoRoot {
    $p = Split-Path -Parent $PSScriptRoot
    return (Resolve-Path (Join-Path $p '..')).Path
}

function Resolve-MiniDoomPython {
    param([string]$Python)

    if ($Python) { return (Resolve-Path $Python).Path }
    if ($env:MINIDOOM_PYTHON) { return (Resolve-Path $env:MINIDOOM_PYTHON).Path }

    $bundled = Join-Path $env:USERPROFILE '.cache\codex-runtimes\codex-primary-runtime\dependencies\python\python.exe'
    if (Test-Path $bundled) { return $bundled }

    $cmd = Get-Command python -ErrorAction SilentlyContinue
    if ($cmd) { return $cmd.Source }

    throw 'Python not found. Pass -Python or set MINIDOOM_PYTHON.'
}

function Resolve-MiniDoomCompiler {
    param([string]$Compiler)

    if ($Compiler) { return (Resolve-Path $Compiler).Path }
    if ($env:MINIDOOM_COMPILER) { return (Resolve-Path $env:MINIDOOM_COMPILER).Path }

    $default = Join-Path $env:USERPROFILE 'Desktop\MiniLangCompilerPy\mlc_win64.py'
    if (Test-Path $default) { return $default }

    throw 'MiniLang compiler not found. Pass -Compiler or set MINIDOOM_COMPILER.'
}

function Resolve-MiniDoomStd {
    param(
        [string]$Std,
        [string]$Compiler
    )

    if ($Std) { return (Resolve-Path $Std).Path }
    if ($env:MINIDOOM_STD) { return (Resolve-Path $env:MINIDOOM_STD).Path }

    if ($Compiler) {
        $candidate = Join-Path (Split-Path -Parent $Compiler) 'std'
        if (Test-Path $candidate) { return $candidate }
    }

    $default = Join-Path $env:USERPROFILE 'Desktop\MiniLangCompilerPy\std'
    if (Test-Path $default) { return $default }

    throw 'MiniLang std folder not found. Pass -Std or set MINIDOOM_STD.'
}

function Resolve-MiniDoomIwad {
    param(
        [string]$RepoRoot,
        [string]$Iwad
    )

    if ($Iwad) { return (Resolve-Path $Iwad).Path }
    if ($env:MINIDOOM_IWAD) { return (Resolve-Path $env:MINIDOOM_IWAD).Path }

    $names = @('Doom2.wad', 'DOOM2.WAD', 'Doom1.wad', 'DOOM1.WAD', 'DOOM.WAD')
    foreach ($dir in @($RepoRoot, (Join-Path $RepoRoot 'build'))) {
        foreach ($name in $names) {
            $candidate = Join-Path $dir $name
            if (Test-Path $candidate) { return (Resolve-Path $candidate).Path }
        }
    }

    throw 'No IWAD found. Pass -Iwad or set MINIDOOM_IWAD.'
}

function Invoke-MiniDoomBuild {
    param(
        [string]$RepoRoot,
        [string]$Compiler,
        [string]$Std,
        [string]$Python,
        [switch]$Clean
    )

    $args = @(
        (Join-Path $RepoRoot 'build.py'),
        '--compiler', $Compiler,
        '--std', $Std,
        '--python', $Python
    )
    if ($Clean) { $args += '--clean' }

    Write-Host "Building MiniDoom..."
    & $Python @args
    if ($LASTEXITCODE -ne 0) {
        throw "Build failed with exit code $LASTEXITCODE."
    }
}

function Import-MiniDoomNative {
    if ($script:NativeLoaded) { return }
    if ('MiniDoomTestNative' -as [type]) {
        $script:NativeLoaded = $true
        return
    }

    Add-Type -AssemblyName System.Drawing
    Add-Type @'
using System;
using System.Runtime.InteropServices;

public class MiniDoomTestNative {
  [DllImport("user32.dll")] public static extern bool PostMessage(IntPtr hWnd, uint Msg, IntPtr wParam, IntPtr lParam);
  [DllImport("user32.dll")] public static extern bool PrintWindow(IntPtr hwnd, IntPtr hdcBlt, uint nFlags);
  [DllImport("user32.dll")] public static extern bool GetWindowRect(IntPtr hWnd, out RECT lpRect);
  [DllImport("user32.dll")] public static extern bool IsWindow(IntPtr hWnd);
  public struct RECT { public int Left; public int Top; public int Right; public int Bottom; }
}
'@
    $script:NativeLoaded = $true
}

function Assert-True {
    param(
        [bool]$Condition,
        [string]$Message
    )
    if (-not $Condition) { throw $Message }
}

function Assert-MiniDoomHealthy {
    param([System.Diagnostics.Process]$Process)

    $Process.Refresh()
    Assert-True (-not $Process.HasExited) "MiniDoom exited unexpectedly."
    $title = $Process.MainWindowTitle
    Assert-True ($title -notmatch 'Fatal Error') "MiniDoom opened a fatal error dialog: $title"
}

function Wait-MiniDoomWindow {
    param(
        [System.Diagnostics.Process]$Process,
        [int]$TimeoutSeconds = 20
    )

    $deadline = (Get-Date).AddSeconds($TimeoutSeconds)
    while ((Get-Date) -lt $deadline) {
        $Process.Refresh()
        if ($Process.HasExited) { throw "MiniDoom exited while waiting for a window." }
        if ($Process.MainWindowHandle -ne 0) { return }
        Start-Sleep -Milliseconds 100
    }
    throw "Timed out waiting for MiniDoom window."
}

function Start-MiniDoomForTest {
    param(
        [string]$RepoRoot,
        [string[]]$Arguments,
        [int]$WindowTimeoutSeconds = 20
    )

    $exe = Join-Path $RepoRoot 'build\MiniDoom.exe'
    Assert-True (Test-Path $exe) "MiniDoom.exe not found at $exe. Run build first."

    $p = Start-Process -FilePath $exe -ArgumentList $Arguments -WorkingDirectory (Join-Path $RepoRoot 'build') -WindowStyle Normal -PassThru
    Wait-MiniDoomWindow -Process $p -TimeoutSeconds $WindowTimeoutSeconds
    return $p
}

function Stop-MiniDoomForTest {
    param([System.Diagnostics.Process]$Process)

    if ($null -eq $Process) { return }
    $Process.Refresh()
    if (-not $Process.HasExited) {
        Stop-Process -Id $Process.Id -Force -ErrorAction SilentlyContinue
        $Process.WaitForExit(3000) | Out-Null
    }
}

function Save-MiniDoomWindowImage {
    param(
        [System.Diagnostics.Process]$Process,
        [string]$Path
    )

    Import-MiniDoomNative
    Assert-MiniDoomHealthy -Process $Process

    $rect = New-Object MiniDoomTestNative+RECT
    [MiniDoomTestNative]::GetWindowRect($Process.MainWindowHandle, [ref]$rect) | Out-Null
    $w = [Math]::Max(1, $rect.Right - $rect.Left)
    $h = [Math]::Max(1, $rect.Bottom - $rect.Top)

    $bmp = New-Object System.Drawing.Bitmap($w, $h)
    $g = [System.Drawing.Graphics]::FromImage($bmp)
    $hdc = $g.GetHdc()
    [MiniDoomTestNative]::PrintWindow($Process.MainWindowHandle, $hdc, 2) | Out-Null
    $g.ReleaseHdc($hdc)
    $g.Dispose()
    $bmp.Save($Path, [System.Drawing.Imaging.ImageFormat]::Png)
    $bmp.Dispose()

    return $Path
}

function Send-MiniDoomAltG {
    param([System.Diagnostics.Process]$Process)

    Import-MiniDoomNative
    Assert-MiniDoomHealthy -Process $Process
    $hwnd = $Process.MainWindowHandle

    [MiniDoomTestNative]::PostMessage($hwnd, 0x0104, [IntPtr]0x47, [IntPtr]0x20000000) | Out-Null
    Start-Sleep -Milliseconds 100
    [MiniDoomTestNative]::PostMessage($hwnd, 0x0105, [IntPtr]0x47, [IntPtr]0) | Out-Null
    Start-Sleep -Milliseconds 1200
    Assert-MiniDoomHealthy -Process $Process
}

function Get-MiniDoomImageStats {
    param([string]$Path)

    Add-Type -AssemblyName System.Drawing
    $bmp = [System.Drawing.Bitmap]::FromFile($Path)
    try {
        $stepX = [Math]::Max(1, [int]($bmp.Width / 96))
        $stepY = [Math]::Max(1, [int]($bmp.Height / 72))
        $count = 0
        $dark = 0
        $bright = 0
        $hash = @{}
        for ($y = 0; $y -lt $bmp.Height; $y += $stepY) {
            for ($x = 0; $x -lt $bmp.Width; $x += $stepX) {
                $c = $bmp.GetPixel($x, $y)
                $lum = [int](($c.R + $c.G + $c.B) / 3)
                if ($lum -lt 8) { $dark++ }
                if ($lum -gt 247) { $bright++ }
                $key = (($c.R -band 0xF0) -shl 8) -bor (($c.G -band 0xF0) -shl 4) -bor ($c.B -band 0xF0)
                $hash[$key] = $true
                $count++
            }
        }
        return [pscustomobject]@{
            Width = $bmp.Width
            Height = $bmp.Height
            Samples = $count
            DarkRatio = if ($count) { $dark / $count } else { 1 }
            BrightRatio = if ($count) { $bright / $count } else { 1 }
            ApproxColors = $hash.Count
        }
    }
    finally {
        $bmp.Dispose()
    }
}

function Assert-MiniDoomImageLooksDrawn {
    param(
        [string]$Path,
        [string]$Label
    )

    Assert-True (Test-Path $Path) "$Label image missing: $Path"
    $s = Get-MiniDoomImageStats -Path $Path
    Assert-True ($s.ApproxColors -ge 24) "$Label image has too few colors ($($s.ApproxColors)); it may be blank."
    Assert-True ($s.BrightRatio -lt 0.70) "$Label image is mostly white; possible missing frame."
    Assert-True ($s.DarkRatio -lt 0.85) "$Label image is mostly black; possible missing frame."
}

function Measure-MiniDoomImageDifference {
    param(
        [string]$A,
        [string]$B
    )

    Add-Type -AssemblyName System.Drawing
    $bmpA = [System.Drawing.Bitmap]::FromFile($A)
    $bmpB = [System.Drawing.Bitmap]::FromFile($B)
    try {
        $w = [Math]::Min($bmpA.Width, $bmpB.Width)
        $h = [Math]::Min($bmpA.Height, $bmpB.Height)
        $stepX = [Math]::Max(1, [int]($w / 160))
        $stepY = [Math]::Max(1, [int]($h / 100))
        [double]$sum = 0
        [int]$count = 0
        for ($y = 0; $y -lt $h; $y += $stepY) {
            for ($x = 0; $x -lt $w; $x += $stepX) {
                $ca = $bmpA.GetPixel($x, $y)
                $cb = $bmpB.GetPixel($x, $y)
                $sum += [Math]::Abs($ca.R - $cb.R)
                $sum += [Math]::Abs($ca.G - $cb.G)
                $sum += [Math]::Abs($ca.B - $cb.B)
                $count += 3
            }
        }
        if ($count -eq 0) { return 0 }
        return $sum / $count
    }
    finally {
        $bmpA.Dispose()
        $bmpB.Dispose()
    }
}

function Read-MiniDoomU32LE {
    param(
        [byte[]]$Bytes,
        [int]$Offset
    )
    return [uint32](
        ([uint32]$Bytes[$Offset]) -bor
        (([uint32]$Bytes[$Offset + 1]) -shl 8) -bor
        (([uint32]$Bytes[$Offset + 2]) -shl 16) -bor
        (([uint32]$Bytes[$Offset + 3]) -shl 24)
    )
}

function Test-MiniDoomHDWADHeader {
    param([string]$Path)

    Assert-True (Test-Path $Path) "HDWAD file missing: $Path"
    $fs = [System.IO.File]::OpenRead($Path)
    try {
        Assert-True ($fs.Length -ge 28) "HDWAD file is too small: $Path"
        $buf = New-Object byte[] 28
        [void]$fs.Read($buf, 0, $buf.Length)
    }
    finally {
        $fs.Dispose()
    }

    $magic = [Text.Encoding]::ASCII.GetString($buf, 0, 4)
    $version = Read-MiniDoomU32LE -Bytes $buf -Offset 4
    $scale = Read-MiniDoomU32LE -Bytes $buf -Offset 8
    $lumpCount = Read-MiniDoomU32LE -Bytes $buf -Offset 12
    $imageCount = Read-MiniDoomU32LE -Bytes $buf -Offset 16

    Assert-True ($magic -eq 'MDHD') "Unexpected HDWAD magic '$magic' in $Path"
    Assert-True ($version -ge 1 -and $version -le 6) "Unsupported HDWAD version $version in $Path"
    Assert-True ($scale -eq 3) "Expected HDWAD scale 3, got $scale in $Path"
    Assert-True ($lumpCount -gt 50) "Suspiciously low HDWAD lump count $lumpCount in $Path"
    Assert-True ($imageCount -gt 100) "Suspiciously low HDWAD image count $imageCount in $Path"

    return [pscustomobject]@{
        Path = $Path
        Version = $version
        Scale = $scale
        LumpCount = $lumpCount
        ImageCount = $imageCount
    }
}
