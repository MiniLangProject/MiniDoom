param(
    [Parameter(Mandatory = $true)][string]$RepoRoot,
    [Parameter(Mandatory = $true)][string]$Iwad,
    [Parameter(Mandatory = $true)][string]$ArtifactDir
)

# Scenario: run one host plus three real clients over IPv4 loopback, verify all
# slots and level input, denial/error paths, malformed traffic resilience,
# client liveness timeout, socket release, and a fresh rejoin.

$ErrorActionPreference = 'Stop'
Import-Module (Join-Path (Split-Path -Parent $PSScriptRoot) 'lib\MiniDoomTest.psm1') -Force

if (-not ('MiniDoomMpHash' -as [type])) {
    Add-Type @'
using System;
using System.IO;
public static class MiniDoomMpHash {
  public static string Compute(string path) {
    uint h = 2166136261u;
    long length = 0;
    byte[] buffer = new byte[1024 * 1024];
    using (FileStream stream = File.OpenRead(path)) {
      uint fileLength = unchecked((uint)stream.Length);
      unchecked {
        for (int shift = 0; shift < 32; shift += 8) {
          h ^= (byte)(fileLength >> shift);
          h *= 16777619u;
        }
      }
      int got;
      while ((got = stream.Read(buffer, 0, buffer.Length)) > 0) {
        length += got;
        unchecked {
          for (int i = 0; i < got; ++i) { h ^= buffer[i]; h *= 16777619u; }
        }
      }
    }
    return h.ToString("x8") + unchecked((uint)length).ToString("x8");
  }
}
'@
}

# Purpose: Reserves an ephemeral UDP port long enough to discover its number, then releases the probe socket.
function Get-FreeUdpPort {
    $probe = [Net.Sockets.UdpClient]::new(0)
    try { return ([Net.IPEndPoint]$probe.Client.LocalEndPoint).Port }
    finally { $probe.Dispose() }
}

# Purpose: Selects a valid commercial or episode-one start map by inspecting the IWAD directory.
function Get-IwadStartMap {
    param([string]$Path)
    $stream = [IO.File]::OpenRead($Path)
    $reader = [IO.BinaryReader]::new($stream, [Text.Encoding]::ASCII, $true)
    try {
        Assert-True ($stream.Length -ge 12) "IWAD is too small to contain a directory: $Path"
        [void]$reader.ReadBytes(4)
        $count = $reader.ReadInt32()
        $directoryOffset = $reader.ReadInt32()
        Assert-True ($count -gt 0 -and $directoryOffset -ge 12 -and ([int64]$directoryOffset + [int64]$count * 16) -le $stream.Length) "IWAD directory is invalid: $Path"
        $stream.Position = $directoryOffset
        $hasMap01 = $false
        $hasE1M1 = $false
        for ($i = 0; $i -lt $count; $i++) {
            [void]$reader.ReadInt32()
            [void]$reader.ReadInt32()
            $name = [Text.Encoding]::ASCII.GetString($reader.ReadBytes(8)).TrimEnd([char]0).ToUpperInvariant()
            if ($name -eq 'MAP01') { $hasMap01 = $true }
            if ($name -eq 'E1M1') { $hasE1M1 = $true }
        }
        if ($hasMap01) { return 'MAP01' }
        if ($hasE1M1) { return 'E1M1' }
        throw "IWAD contains neither MAP01 nor E1M1: $Path"
    }
    finally {
        $reader.Dispose()
        $stream.Dispose()
    }
}

# Purpose: Polls one process-local MP log until a machine-readable event appears or the deadline expires.
function Wait-LogPattern {
    param([string]$Path, [string]$Pattern, [int]$TimeoutSeconds = 15)
    $deadline = (Get-Date).AddSeconds($TimeoutSeconds)
    do {
        if (Test-Path $Path) {
            $text = Get-Content -LiteralPath $Path -Raw
            if ($text -match $Pattern) { return $text }
        }
        Start-Sleep -Milliseconds 100
    } while ((Get-Date) -lt $deadline)
    $actual = if (Test-Path $Path) { Get-Content -LiteralPath $Path -Raw } else { '<missing>' }
    throw "Timed out waiting for '$Pattern' in $Path. Actual: $actual"
}

# Purpose: Sends one synthetic control datagram from a fresh endpoint and optionally treats receive timeout as success.
function Invoke-UdpTextRequest {
    param([int]$Port, [string]$Text, [int]$TimeoutMilliseconds = 1500, [switch]$AllowTimeout)
    $udp = [Net.Sockets.UdpClient]::new(0)
    try {
        $udp.Client.ReceiveTimeout = $TimeoutMilliseconds
        $bytes = [Text.Encoding]::UTF8.GetBytes($Text)
        [void]$udp.Send($bytes, $bytes.Length, '127.0.0.1', $Port)
        $remote = [Net.IPEndPoint]::new([Net.IPAddress]::Any, 0)
        try {
            $reply = $udp.Receive([ref]$remote)
            return [Text.Encoding]::UTF8.GetString($reply)
        }
        catch [Net.Sockets.SocketException] {
            if ($AllowTimeout -and $_.Exception.SocketErrorCode -eq [Net.Sockets.SocketError]::TimedOut) { return $null }
            throw
        }
    }
    finally { $udp.Dispose() }
}

# Purpose: Injects one raw malformed/oversized datagram without retaining a socket or affecting game processes.
function Send-UdpBytes {
    param([int]$Port, [byte[]]$Bytes)
    $udp = [Net.Sockets.UdpClient]::new(0)
    try { [void]$udp.Send($Bytes, $Bytes.Length, '127.0.0.1', $Port) }
    finally { $udp.Dispose() }
}

# Purpose: Proves a process is rendering a live level by checking a targeted turn key changes its drawn frame.
function Assert-InLevelAndMoving {
    param([System.Diagnostics.Process]$Process, [string]$Label)
    $safe = $Label -replace '[^A-Za-z0-9_-]', '_'
    $before = Join-Path $ArtifactDir "$safe-before.png"
    $after = Join-Path $ArtifactDir "$safe-after.png"
    Save-MiniDoomWindowImage -Process $Process -Path $before | Out-Null
    Assert-MiniDoomImageLooksDrawn -Path $before -Label "$Label initial level"
    # Doom's stable default turn binding is Left Arrow; user config need not
    # provide a modern WASD alias.
    Send-MiniDoomKey -Process $Process -VirtualKey 0x25 -HoldMilliseconds 650
    Start-Sleep -Milliseconds 450
    Save-MiniDoomWindowImage -Process $Process -Path $after | Out-Null
    Assert-MiniDoomImageLooksDrawn -Path $after -Label "$Label moved level"
    $difference = Measure-MiniDoomImageDifference -A $before -B $after
    Assert-True ($difference -gt 0.75) "$Label did not react like a running level (mean image delta $difference)."
}

$port = Get-FreeUdpPort
$fingerprint = [MiniDoomMpHash]::Compute($Iwad)
$mapToken = Get-IwadStartMap -Path $Iwad
$hostProcess = $null
$clients = New-Object System.Collections.Generic.List[System.Diagnostics.Process]
$clientLogs = New-Object System.Collections.Generic.List[string]
$owned = New-Object System.Collections.Generic.List[System.Diagnostics.Process]
$hostLog = Join-Path $ArtifactDir 'host.log'

try {
    $hostProcess = Start-MiniDoomForTest -RepoRoot $RepoRoot -Arguments @(
        '-iwad', $Iwad, '-nohdwad', '-nomonsters', '-mp-host', "$port", '-mp-mode', 'coop',
        '-mp-map', $mapToken, '-mp-maxplayers', '4', '-mp-name', 'LoopHost', '-mp-log', $hostLog
    ) -WindowTimeoutSeconds 45
    $owned.Add($hostProcess)
    Wait-LogPattern -Path $hostLog -Pattern 'MPTEST HOST_READY .*active=1 max=4' -TimeoutSeconds 20 | Out-Null

    for ($slot = 1; $slot -le 3; $slot++) {
        $clientLog = Join-Path $ArtifactDir "client$slot.log"
        $client = Start-MiniDoomForTest -RepoRoot $RepoRoot -Arguments @(
            '-iwad', $Iwad, '-nohdwad', '-nomonsters', '-mp-join', '127.0.0.1', "$port",
            '-mp-name', "LoopClient$slot", '-mp-log', $clientLog
        ) -WindowTimeoutSeconds 45
        $clients.Add($client)
        $clientLogs.Add($clientLog)
        $owned.Add($client)
        Wait-LogPattern -Path $clientLog -Pattern "MPTEST CLIENT_CONNECTED slot=$slot " -TimeoutSeconds 20 | Out-Null
    }

    Wait-LogPattern -Path $hostLog -Pattern 'MPTEST PEER_JOINED slot=3 active=4' -TimeoutSeconds 10 | Out-Null
    for ($slot = 1; $slot -le 3; $slot++) {
        Wait-LogPattern -Path $hostLog -Pattern "MPTEST PEER_ACTIVE slot=$slot" -TimeoutSeconds 20 | Out-Null
        Wait-LogPattern -Path (Join-Path $ArtifactDir "client$slot.log") -Pattern "MPTEST CLIENT_ACTIVE slot=$slot" -TimeoutSeconds 20 | Out-Null
    }
    Start-Sleep -Seconds 2
    Assert-MiniDoomHealthy -Process $hostProcess
    foreach ($client in $clients) { Assert-MiniDoomHealthy -Process $client }

    Assert-InLevelAndMoving -Process $hostProcess -Label 'host'
    for ($i = 0; $i -lt $clients.Count; $i++) {
        Assert-InLevelAndMoving -Process $clients[$i] -Label "client$($i + 1)"
    }

    # Send a real two-character broadcast through the HUD input path. Stable
    # metadata-only events prove host relay and delivery without logging text.
    foreach ($key in @(0x54, 0x41, 0x42)) {
        Send-MiniDoomKey -Process $clients[0] -VirtualKey $key -HoldMilliseconds 80
    }
    $chatComposeFrame = Join-Path $ArtifactDir 'client1-chat-compose.png'
    Save-MiniDoomWindowImage -Process $clients[0] -Path $chatComposeFrame | Out-Null
    Send-MiniDoomKey -Process $clients[0] -VirtualKey 0x0D -HoldMilliseconds 250
    Start-Sleep -Milliseconds 350
    $chatSentFrame = Join-Path $ArtifactDir 'client1-chat-sent.png'
    Save-MiniDoomWindowImage -Process $clients[0] -Path $chatSentFrame | Out-Null
    Wait-LogPattern -Path $hostLog -Pattern 'MPTEST CHAT_RELAY sender=1 dest=5 length=2' -TimeoutSeconds 10 | Out-Null
    for ($slot = 1; $slot -le 3; $slot++) {
        Wait-LogPattern -Path $clientLogs[$slot - 1] -Pattern 'MPTEST CHAT_RECEIVED sender=1 dest=5 length=2' -TimeoutSeconds 10 | Out-Null
    }

    # Every client announces through the same host-authenticated packet path used
    # by the console NAME command. Slot 3 joins last, so all peers must receive it.
    for ($slot = 1; $slot -le 3; $slot++) {
        Wait-LogPattern -Path $clientLogs[$slot - 1] -Pattern "MPTEST NAME_SENT slot=$slot name=LoopClient$slot ok=1" -TimeoutSeconds 10 | Out-Null
        Wait-LogPattern -Path $hostLog -Pattern "MPTEST NAME_RELAY slot=$slot name=LoopClient$slot" -TimeoutSeconds 10 | Out-Null
        Wait-LogPattern -Path $clientLogs[$slot - 1] -Pattern "MPTEST NAME_RECEIVED slot=$slot name=LoopClient$slot" -TimeoutSeconds 10 | Out-Null
    }
    for ($receiver = 1; $receiver -le 3; $receiver++) {
        for ($namedSlot = 1; $namedSlot -le 3; $namedSlot++) {
            Wait-LogPattern -Path $clientLogs[$receiver - 1] -Pattern "MPTEST NAME_RECEIVED slot=$namedSlot name=LoopClient$namedSlot" -TimeoutSeconds 10 | Out-Null
        }
    }

    $mismatch = Invoke-UdpTextRequest -Port $port -Text "MDMP1|REQ|WrongWad|0000000000000000|0|$mapToken|2|4|0|0"
    Assert-True ($mismatch -match '^MDMP1\|DEN\|3\|') "WAD mismatch was not denied correctly: $mismatch"

    $full = Invoke-UdpTextRequest -Port $port -Text "MDMP1|REQ|Fourth|$fingerprint|0|$mapToken|2|4|0|0"
    Assert-True ($full -match '^MDMP1\|DEN\|2\|') "Fourth client was not denied as server_full: $full"

    # Exercise the same denials through the production CLI, including the WAD
    # loader/fingerprint path. Appending a trailing byte preserves WAD lumps.
    $mismatchIwad = Join-Path $ArtifactDir 'mismatch.wad'
    Copy-Item -LiteralPath $Iwad -Destination $mismatchIwad
    $mismatchStream = [IO.File]::Open($mismatchIwad, [IO.FileMode]::Append, [IO.FileAccess]::Write, [IO.FileShare]::None)
    try { $mismatchStream.WriteByte(0xA5) }
    finally { $mismatchStream.Dispose() }
    $mismatchLog = Join-Path $ArtifactDir 'mismatch-client.log'
    $mismatchClient = Start-MiniDoomForTest -RepoRoot $RepoRoot -Arguments @(
        '-iwad', $mismatchIwad, '-nohdwad', '-mp-join', '127.0.0.1', "$port",
        '-mp-name', 'MismatchClient', '-mp-log', $mismatchLog
    ) -WindowTimeoutSeconds 45
    $owned.Add($mismatchClient)
    Wait-LogPattern -Path $mismatchLog -Pattern 'MPTEST CLIENT_FAILED status=wad_mismatch' -TimeoutSeconds 15 | Out-Null
    Assert-MiniDoomHealthy -Process $mismatchClient
    Stop-MiniDoomForTest -Process $mismatchClient

    $fullLog = Join-Path $ArtifactDir 'full-client.log'
    $fullClient = Start-MiniDoomForTest -RepoRoot $RepoRoot -Arguments @(
        '-iwad', $Iwad, '-nohdwad', '-mp-join', '127.0.0.1', "$port",
        '-mp-name', 'FullClient', '-mp-log', $fullLog
    ) -WindowTimeoutSeconds 45
    $owned.Add($fullClient)
    Wait-LogPattern -Path $fullLog -Pattern 'MPTEST CLIENT_FAILED status=server_full' -TimeoutSeconds 15 | Out-Null
    Assert-MiniDoomHealthy -Process $fullClient
    Stop-MiniDoomForTest -Process $fullClient

    # Unknown peers receive no reflection response, and malformed/oversized
    # frames must not disturb the running host/client set.
    $pong = Invoke-UdpTextRequest -Port $port -Text 'MDMP1|PING|1' -TimeoutMilliseconds 500 -AllowTimeout
    Assert-True ($null -eq $pong) "Host reflected PONG to an unknown endpoint: $pong"
    Send-UdpBytes -Port $port -Bytes (New-Object byte[] 4096)
    Send-UdpBytes -Port $port -Bytes ([byte[]](77,68,71,49,1,1,0,99))
    Start-Sleep -Seconds 1
    Assert-MiniDoomHealthy -Process $hostProcess
    foreach ($client in $clients) { Assert-MiniDoomHealthy -Process $client }

    # Close one exact client through WM_CLOSE. Its normal shutdown sends LEAVE;
    # the live host must reclaim slot 3 and admit a replacement into that slot.
    Close-MiniDoomGracefully -Process $clients[2]
    Wait-LogPattern -Path $hostLog -Pattern 'MPTEST PEER_LEFT slot=3 active=3' -TimeoutSeconds 8 | Out-Null
    Assert-MiniDoomHealthy -Process $hostProcess
    Assert-MiniDoomHealthy -Process $clients[0]
    Assert-MiniDoomHealthy -Process $clients[1]

    $replacementLog = Join-Path $ArtifactDir 'replacement-client3.log'
    $replacementClient = Start-MiniDoomForTest -RepoRoot $RepoRoot -Arguments @(
        '-iwad', $Iwad, '-nohdwad', '-nomonsters', '-mp-join', '127.0.0.1', "$port",
        '-mp-name', 'Replacement3', '-mp-log', $replacementLog
    ) -WindowTimeoutSeconds 45
    $owned.Add($replacementClient)
    $clients[2] = $replacementClient
    $clientLogs[2] = $replacementLog
    Wait-LogPattern -Path $replacementLog -Pattern 'MPTEST CLIENT_CONNECTED slot=3 ' -TimeoutSeconds 20 | Out-Null
    Wait-LogPattern -Path $replacementLog -Pattern 'MPTEST CLIENT_ACTIVE slot=3' -TimeoutSeconds 20 | Out-Null
    Wait-LogPattern -Path $hostLog -Pattern 'MPTEST PEER_JOINED slot=3 active=4 name=Replacement3' -TimeoutSeconds 20 | Out-Null
    Wait-LogPattern -Path $hostLog -Pattern 'MPTEST PEER_ACTIVE slot=3 name=Replacement3' -TimeoutSeconds 20 | Out-Null
    Assert-InLevelAndMoving -Process $replacementClient -Label 'replacement-client3'

    # Force only the test-owned host down. Clients must detect silence through
    # the runtime liveness timeout; no unrelated MiniDoom process is touched.
    Stop-MiniDoomForTest -Process $hostProcess
    for ($slot = 1; $slot -le 3; $slot++) {
        $clientLog = $clientLogs[$slot - 1]
        Wait-LogPattern -Path $clientLog -Pattern 'MPTEST CLIENT_DISCONNECTED status=timeout' -TimeoutSeconds 16 | Out-Null
        Wait-LogPattern -Path $clientLog -Pattern 'MPTEST CLIENT_OFFLINE active=0 console=0 state=title' -TimeoutSeconds 3 | Out-Null
        Assert-MiniDoomHealthy -Process $clients[$slot - 1]
    }
    Start-Sleep -Seconds 1
    $offlineFrame = Join-Path $ArtifactDir 'timedout-client-offline.png'
    Save-MiniDoomWindowImage -Process $clients[0] -Path $offlineFrame | Out-Null
    Assert-MiniDoomImageLooksDrawn -Path $offlineFrame -Label 'timed-out client title screen'
    foreach ($client in $clients) { Stop-MiniDoomForTest -Process $client }
    $clients.Clear()

    $reHostLog = Join-Path $ArtifactDir 'rehost.log'
    $reHost = Start-MiniDoomForTest -RepoRoot $RepoRoot -Arguments @(
        '-iwad', $Iwad, '-nohdwad', '-nomonsters', '-mp-host', "$port", '-mp-map', $mapToken,
        '-mp-mode', 'deathmatch', '-mp-maxplayers', '4', '-mp-fraglimit', '10', '-mp-timelimit', '5',
        '-mp-name', 'ReHost', '-mp-log', $reHostLog
    ) -WindowTimeoutSeconds 45
    $owned.Add($reHost)
    Wait-LogPattern -Path $reHostLog -Pattern 'MPTEST HOST_READY .*mode=1 ' -TimeoutSeconds 20 | Out-Null

    $reClientLog = Join-Path $ArtifactDir 'reclient.log'
    $reClient = Start-MiniDoomForTest -RepoRoot $RepoRoot -Arguments @(
        '-iwad', $Iwad, '-nohdwad', '-nomonsters', '-mp-join', '127.0.0.1', "$port",
        '-mp-name', 'ReClient', '-mp-log', $reClientLog
    ) -WindowTimeoutSeconds 45
    $owned.Add($reClient)
    Wait-LogPattern -Path $reClientLog -Pattern 'MPTEST CLIENT_CONNECTED slot=1 .*mode=1 ' -TimeoutSeconds 20 | Out-Null
    Wait-LogPattern -Path $reHostLog -Pattern 'MPTEST PEER_ACTIVE slot=1' -TimeoutSeconds 20 | Out-Null
    Wait-LogPattern -Path $reClientLog -Pattern 'MPTEST CLIENT_ACTIVE slot=1' -TimeoutSeconds 20 | Out-Null
    Assert-InLevelAndMoving -Process $reClient -Label 'rejoined-client'
}
finally {
    foreach ($process in $owned) { Stop-MiniDoomForTest -Process $process }
}

# After exact-PID cleanup the host port must be reusable, proving socket
# lifetime ended without relying on a global process sweep.
$rebind = [Net.Sockets.UdpClient]::new()
try {
    $rebind.Client.Bind([Net.IPEndPoint]::new([Net.IPAddress]::Loopback, $port))
}
finally { $rebind.Dispose() }
