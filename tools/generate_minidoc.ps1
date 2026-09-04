[CmdletBinding()]
param(
    [string]$MiniDoc,
    [string]$CompilerRoot,
    [switch]$Check
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$repo = [IO.Path]::GetFullPath((Split-Path -Parent $PSScriptRoot))
$workspace = Split-Path -Parent $repo

if ([string]::IsNullOrWhiteSpace($MiniDoc)) {
    $candidates = @(
        $env:MINIDOC_EXE,
        (Join-Path $workspace 'MiniLangCompilerOptimization\MiniDoc\build\minidoc.exe'),
        (Join-Path $workspace 'MiniDoc\build\minidoc.exe')
    ) | Where-Object { -not [string]::IsNullOrWhiteSpace($_) }
    $MiniDoc = $candidates | Where-Object { Test-Path -LiteralPath $_ -PathType Leaf } | Select-Object -First 1
    if ([string]::IsNullOrWhiteSpace($MiniDoc)) {
        $command = Get-Command minidoc -ErrorAction SilentlyContinue
        if ($command) { $MiniDoc = $command.Source }
    }
}
if ([string]::IsNullOrWhiteSpace($MiniDoc) -or -not (Test-Path -LiteralPath $MiniDoc -PathType Leaf)) {
    throw 'MiniDoc was not found. Pass -MiniDoc or set MINIDOC_EXE.'
}

if ([string]::IsNullOrWhiteSpace($CompilerRoot)) {
    $compilerCandidates = @(
        $env:MINILANG_ROOT,
        (Join-Path $workspace 'MiniLangCompilerOptimization\MiniLangCompilerPy'),
        (Join-Path $workspace 'MiniLangCompilerPy')
    ) | Where-Object { -not [string]::IsNullOrWhiteSpace($_) }
    $CompilerRoot = $compilerCandidates |
        Where-Object { Test-Path -LiteralPath (Join-Path $_ 'std') -PathType Container } |
        Select-Object -First 1
}
if ([string]::IsNullOrWhiteSpace($CompilerRoot) -or
    -not (Test-Path -LiteralPath (Join-Path $CompilerRoot 'std') -PathType Container)) {
    throw 'MiniLang compiler root was not found. Pass -CompilerRoot or set MINILANG_ROOT.'
}

$arguments = @(
    '--config', (Join-Path $repo 'minidoc.toml'),
    '-I', ([IO.Path]::GetFullPath($CompilerRoot))
)
if ($Check) { $arguments += '--check' }

Push-Location $repo
try {
    & $MiniDoc @arguments
    if ($LASTEXITCODE -ne 0) {
        throw "MiniDoc failed with exit code $LASTEXITCODE."
    }
}
finally {
    Pop-Location
}
