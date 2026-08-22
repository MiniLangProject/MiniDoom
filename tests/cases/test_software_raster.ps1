param(
    [Parameter(Mandatory = $true)][string]$RepoRoot,
    [Parameter(Mandatory = $true)][string]$Iwad,
    [Parameter(Mandatory = $true)][string]$ArtifactDir
)

$ErrorActionPreference = 'Stop'
$dll = (Resolve-Path -LiteralPath (Join-Path $RepoRoot 'build\MiniDoomGL.dll')).Path
$escapedDll = $dll.Replace('"', '""')
$interop = @"
using System;
using System.Runtime.InteropServices;
public static class MiniDoomSoftwareRasterNative {
  [DllImport(@"$escapedDll", CallingConvention=CallingConvention.StdCall)]
  [return: MarshalAs(UnmanagedType.Bool)]
  public static extern bool MGL_RasterColumn8([In,Out] byte[] dest, int destBytes, int destIndex, int destStride, int count, byte[] source, int sourceBytes, int sourceOffset, int sourceLength, byte[] colormap, int colormapLength, int frac, int fracStep, int sourceClamp);
  [DllImport(@"$escapedDll", CallingConvention=CallingConvention.StdCall)]
  [return: MarshalAs(UnmanagedType.Bool)]
  public static extern bool MGL_RasterSpan8([In,Out] byte[] dest, int destBytes, int destIndex, int count, byte[] source, int sourceBytes, byte[] colormap, int colormapLength, int sourceWidth, int sourceHeight, int xFrac, int yFrac, int xStep, int yStep);
  [DllImport(@"$escapedDll", CallingConvention=CallingConvention.StdCall)]
  [return: MarshalAs(UnmanagedType.Bool)]
  public static extern bool MGL_ExpandIndexed8(byte[] source, int sourceBytes, [In,Out] byte[] dest, int destBytes, byte[] palette, int paletteBytes, int pixels);
}
"@
Add-Type -TypeDefinition $interop

$rng = [Random]::new(20260822)
for ($case = 0; $case -lt 256; $case++) {
    $expected = [byte[]]::new(4096)
    $rng.NextBytes($expected)
    $actual = [byte[]]$expected.Clone()
    $source = [byte[]]::new($rng.Next(1, 300))
    $rng.NextBytes($source)
    $sourceOffset = $rng.Next(0, $source.Length)
    $sourceLength = $rng.Next(1, $source.Length - $sourceOffset + 1)
    $colormap = [byte[]]::new($rng.Next(1, 257))
    $rng.NextBytes($colormap)
    $stride = $rng.Next(1, 321)
    $count = $rng.Next(1, 13)
    $destIndex = $rng.Next(0, $actual.Length - (($count - 1) * $stride))
    $frac = $rng.Next(-200000000, 200000000)
    $fracStep = $rng.Next(-2000000, 2000000)
    $clamp = $rng.Next(0, 2)
    $fracValue = [int64]$frac

    for ($i = 0; $i -lt $count; $i++) {
        $textureIndex = [int]($fracValue -shr 16)
        if ($clamp -ne 0) {
            if ($textureIndex -lt 0) { $textureIndex = 0 }
            elseif ($textureIndex -ge $sourceLength) { $textureIndex = $sourceLength - 1 }
        }
        else {
            $textureIndex %= $sourceLength
            if ($textureIndex -lt 0) { $textureIndex += $sourceLength }
        }
        $texel = [int]$source[$sourceOffset + $textureIndex]
        if ($texel -ge $colormap.Length) { $texel %= $colormap.Length }
        $expected[$destIndex + $i * $stride] = $colormap[$texel]
        $fracValue += $fracStep
    }

    $ok = [MiniDoomSoftwareRasterNative]::MGL_RasterColumn8($actual, $actual.Length, $destIndex, $stride, $count, $source, $source.Length, $sourceOffset, $sourceLength, $colormap, $colormap.Length, $frac, $fracStep, $clamp)
    if (-not $ok -or [Convert]::ToBase64String($actual) -ne [Convert]::ToBase64String($expected)) {
        throw "Native software column differs from the reference at case $case."
    }
}

$dimensions = @(@(64,64), @(128,64), @(192,128), @(32,32), @(96,48), @(127,65))
for ($case = 0; $case -lt 256; $case++) {
    $dimension = $dimensions[$rng.Next(0, $dimensions.Count)]
    $width = $dimension[0]
    $height = $dimension[1]
    $source = [byte[]]::new($width * $height)
    $rng.NextBytes($source)
    $colormap = [byte[]]::new($rng.Next(1, 257))
    $rng.NextBytes($colormap)
    $expected = [byte[]]::new(1024)
    $rng.NextBytes($expected)
    $actual = [byte[]]$expected.Clone()
    $count = $rng.Next(1, 321)
    $destIndex = $rng.Next(0, $actual.Length - $count + 1)
    $xFrac = $rng.Next(-200000000, 200000000)
    $yFrac = $rng.Next(-200000000, 200000000)
    $xStep = $rng.Next(-2000000, 2000000)
    $yStep = $rng.Next(-2000000, 2000000)
    $xValue = [int64]$xFrac
    $yValue = [int64]$yFrac
    $period = 64 -shl 16

    for ($i = 0; $i -lt $count; $i++) {
        $xCoord = $xValue % $period
        $yCoord = $yValue % $period
        if ($xCoord -lt 0) { $xCoord += $period }
        if ($yCoord -lt 0) { $yCoord += $period }
        $sourceX = [int][Math]::Floor(($xCoord * $width) / [double]$period)
        $sourceY = [int][Math]::Floor(($yCoord * $height) / [double]$period)
        $texel = [int]$source[$sourceY * $width + $sourceX]
        if ($texel -ge $colormap.Length) { $texel %= $colormap.Length }
        $expected[$destIndex + $i] = $colormap[$texel]
        $xValue += $xStep
        $yValue += $yStep
    }

    $ok = [MiniDoomSoftwareRasterNative]::MGL_RasterSpan8($actual, $actual.Length, $destIndex, $count, $source, $source.Length, $colormap, $colormap.Length, $width, $height, $xFrac, $yFrac, $xStep, $yStep)
    if (-not $ok -or [Convert]::ToBase64String($actual) -ne [Convert]::ToBase64String($expected)) {
        throw "Native software span differs from the reference at case $case."
    }
}

$pixels = 320 * 200
$indexed = [byte[]]::new($pixels)
$palette = [byte[]]::new(768)
$rng.NextBytes($indexed)
$rng.NextBytes($palette)
$expectedRgba = [byte[]]::new($pixels * 4)
for ($i = 0; $i -lt $pixels; $i++) {
    $paletteOffset = [int]$indexed[$i] * 3
    $destOffset = $i * 4
    $expectedRgba[$destOffset] = $palette[$paletteOffset]
    $expectedRgba[$destOffset + 1] = $palette[$paletteOffset + 1]
    $expectedRgba[$destOffset + 2] = $palette[$paletteOffset + 2]
    $expectedRgba[$destOffset + 3] = 255
}
$actualRgba = [byte[]]::new($pixels * 4)
$expanded = [MiniDoomSoftwareRasterNative]::MGL_ExpandIndexed8($indexed, $indexed.Length, $actualRgba, $actualRgba.Length, $palette, $palette.Length, $pixels)
if (-not $expanded -or [Convert]::ToBase64String($actualRgba) -ne [Convert]::ToBase64String($expectedRgba)) {
    throw 'Native indexed-to-RGBA expansion differs from the reference.'
}

$guard = [byte[]](1,2,3,4)
if ([MiniDoomSoftwareRasterNative]::MGL_RasterColumn8($guard, 4, 3, 2, 2, $guard, 4, 0, 4, $guard, 4, 0, 1, 0)) { throw 'Malformed column range was accepted.' }
if ([MiniDoomSoftwareRasterNative]::MGL_RasterSpan8($guard, 4, 3, 2, $guard, 4, $guard, 4, 2, 2, 0, 0, 1, 1)) { throw 'Malformed span range was accepted.' }
if ([MiniDoomSoftwareRasterNative]::MGL_ExpandIndexed8($guard, 4, $guard, 4, $palette, $palette.Length, 4)) { throw 'Malformed RGBA destination was accepted.' }

Write-Output 'Native software raster PASS (256 columns, 256 spans, RGBA expansion, malformed ranges).'
