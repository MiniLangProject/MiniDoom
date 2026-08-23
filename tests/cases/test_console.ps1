param(
    [Parameter(Mandatory = $true)][string]$RepoRoot,
    [Parameter(Mandatory = $true)][string]$Iwad,
    [Parameter(Mandatory = $true)][string]$ArtifactDir
)

$ErrorActionPreference = 'Stop'
Import-Module (Join-Path (Split-Path -Parent $PSScriptRoot) 'lib\MiniDoomTest.psm1') -Force

# Purpose: Loads one source file from the repository with a stable missing-file diagnostic.
function Get-SourceText {
    param([Parameter(Mandatory = $true)][string]$RelativePath)
    $path = Join-Path $RepoRoot $RelativePath
    if (-not (Test-Path -LiteralPath $path -PathType Leaf)) { throw "Missing console source: $RelativePath" }
    return Get-Content -LiteralPath $path -Raw
}

# Purpose: Requires one regex data-flow marker in a source module.
function Assert-SourcePattern {
    param(
        [Parameter(Mandatory = $true)][string]$Source,
        [Parameter(Mandatory = $true)][string]$Pattern,
        [Parameter(Mandatory = $true)][string]$Message
    )
    if ($Source -notmatch $Pattern) { throw $Message }
}

$ui = Get-SourceText 'src\console_ui.ml'
$commands = Get-SourceText 'src\console_cmd.ml'
$game = Get-SourceText 'src\g_game.ml'
$main = Get-SourceText 'src\d_main.ml'
$video = Get-SourceText 'src\i_video.ml'
$hud = Get-SourceText 'src\hu_stuff.ml'
$ticker = Get-SourceText 'src\p_tick.ml'
$enemy = Get-SourceText 'src\p_enemy.ml'
$weapon = Get-SourceText 'src\p_pspr.ml'
$interaction = Get-SourceText 'src\p_inter.ml'

Assert-SourcePattern $ui '(?m)^import console_cmd$' 'Console UI no longer delegates to the command module.'
if ($commands -match '(?m)^import console_ui$') { throw 'Command parser must not depend on console drawing or input state.' }
Assert-SourcePattern $ui 'CUI_ANIMATION_MS\s*=\s*200' 'Console animation is no longer approximately 0.2 seconds.'
Assert-SourcePattern $ui 'CUI_PANEL_HEIGHT\s*=\s*68' 'Console no longer covers approximately the top third of the 200-pixel viewport.'
Assert-SourcePattern $ui 'KEY_PAGEUP' 'Console scrollback has no Page Up input path.'
Assert-SourcePattern $ui 'KEY_PAGEDOWN' 'Console scrollback has no Page Down input path.'
Assert-SourcePattern $ui 'paused\s*=\s*true' 'Opening the console no longer pauses gameplay.'
Assert-SourcePattern $ui 'G_ClearInputState\(\)' 'Opening the console no longer releases latched gameplay controls.'
Assert-SourcePattern $ui 'V_DrawDitheredOverlayRect' 'Console background no longer uses the OpenGL-safe translucent overlay primitive.'
Assert-SourcePattern $main 'function inline _D_StatusBarVisible\(\)' 'OpenGL status-bar visibility has no scale-independent decision path.'
Assert-SourcePattern $main 'R_RendererIsOpenGL\(\)\s+and\s+_D_StatusBarVisible\(\)' 'OpenGL frames no longer preserve a visible status-bar overlay.'
Assert-SourcePattern $main 'st_fullscreen\s*=\s*not\s+_D_StatusBarVisible\(\)' 'Status drawing again compares physical HD height with logical screen height.'
Assert-SourcePattern $main 'gamestate\s*==\s*gamestate_t\.GS_LEVEL\s+and\s+typeof\(ST_ForceRefresh\).*ST_ForceRefresh\(\)' 'Level wipes no longer schedule a complete status-bar rebuild.'
Assert-SourcePattern $video 'function inline _I_StatusOverlayY\(\)' 'OpenGL presentation has no dynamic status-overlay boundary.'
Assert-SourcePattern $video '(?s)if\s+typeof\(_D_StatusBarVisible\).*?_D_StatusBarVisible\(\).*?return\s+SCREENHEIGHT' 'Fullscreen OpenGL may still cover the lower world with stale logical pixels.'

$consoleResponder = $main.IndexOf('CUI_Responder(ev)')
$menuResponder = $main.IndexOf('M_Responder(ev)')
if ($consoleResponder -lt 0 -or $menuResponder -lt 0 -or $consoleResponder -gt $menuResponder) {
    throw 'Console responder must run before the menu and gameplay responders.'
}
$consoleDrawer = $main.IndexOf('CUI_Drawer()')
$endOverlay = $main.IndexOf('V_EndOverlayMask()', $consoleDrawer)
if ($consoleDrawer -lt 0 -or $endOverlay -lt 0 -or $consoleDrawer -gt $endOverlay) {
    throw 'Console drawer must contribute to the late OpenGL overlay mask.'
}

foreach ($command in @('help', 'cheats', 'iddqd', 'idkfa', 'idfa', 'idclip', 'idclev', 'invisible', 'freeze', 'kill monsters', 'name', 'fps', 'clear', 'quit')) {
    Assert-SourcePattern $commands ([regex]::Escape('"' + $command + '"')) "Missing console command dispatch: $command"
}
Assert-SourcePattern $commands 'console_command_result_t' 'Command parser no longer returns a UI-neutral result structure.'
Assert-SourcePattern $commands 'PAGEUP/PAGEDOWN - SCROLL LOG' 'Help does not describe scrollback navigation.'
Assert-SourcePattern $commands 'KILL MONSTERS - KILL ALL ENEMIES' 'Cheat help does not cover every gameplay cheat.'
Assert-SourcePattern $ui 'str\.split\(message, "\\n"\)' 'Console log does not split multi-line help output into scrollable lines.'
Assert-SourcePattern $commands 'netgame.*DISABLED IN MULTIPLAYER' 'World commands no longer guard multiplayer synchronization.'
Assert-SourcePattern $commands 'gamemode\s*!=\s*GameMode_t\.commercial.*epsd\s*<\s*1' 'Doom II idclev is incorrectly rejected by Doom episode validation.'
Assert-SourcePattern $commands 'function CCMD_DirectCheatResponder\(ev\)' 'Classic IDCLEV has no ordinary gameplay-key responder.'
Assert-SourcePattern $commands 'stringSlice\(_ccmd_direct_cheat_buffer, 0, 6\)\s*!=\s*"idclev"' 'Direct IDCLEV no longer requires the exact classic prefix.'
Assert-SourcePattern $game 'CCMD_DirectCheatResponder\(ev\)' 'Gameplay does not forward ordinary key events to the classic cheat recognizer.'
Assert-SourcePattern $commands 'D_NetMPSetPlayerName\(requested\)' 'The name command no longer propagates through active multiplayer sessions.'
Assert-SourcePattern $ui '_cui_shift_down\s+and\s+key\s*>=\s*97.*?key\s*=\s*key\s*-\s*32' 'Console text entry cannot preserve uppercase player names.'

Assert-SourcePattern $video '_I_AddKeyMap\(0xC0, KEY_CONSOLE\)' 'US tilde/German O-umlaut virtual key is not mapped to the console.'
Assert-SourcePattern $video '_I_AddKeyMap\(0xBA, KEY_CONSOLE\)' 'Alternate O-umlaut virtual key is not mapped to the console.'
Assert-SourcePattern $video '_I_AddKeyMap\(0xDC, KEY_CONSOLE\)' 'German caret/dead-key is not mapped to the console.'
Assert-SourcePattern $video 'consoleTildeDown\s*=\s*ctrlDown\s+and\s+altDown\s+and\s+plusDown' 'German AltGr+Plus tilde chord is not mapped to the console.'
Assert-SourcePattern $video 'pressedSincePoll.*st\s*&\s*1' 'Sub-tic keyboard taps are not preserved.'

Assert-SourcePattern $hud 'CUI_SetFont\(hu_font, HU_FONTSTART\)' 'Console does not share the HUD message font.'
$hudMirrorCount = [regex]::Matches($hud, 'CUI_Log\(msg\)').Count
if ($hudMirrorCount -lt 2) { throw 'HUD and network/chat messages are not both mirrored into console scrollback.' }

$playerThink = $ticker.IndexOf('P_PlayerThink(players[i])')
$freezeReturn = $ticker.IndexOf('if consolefreeze then')
$frozenPlayerThinker = $ticker.IndexOf('P_RunFrozenPlayerMobjs()', $freezeReturn)
$runThinkers = $ticker.IndexOf('P_RunThinkers()', $freezeReturn)
if ($playerThink -lt 0 -or $freezeReturn -lt $playerThink -or $frozenPlayerThinker -lt $freezeReturn -or $runThinkers -lt $frozenPlayerThinker) {
    throw 'Freeze must advance the player mobj while stopping world thinkers and specials.'
}
Assert-SourcePattern $ticker '(?s)function P_RunFrozenPlayerMobjs\(\).*?P_MobjThinker\(player\.mo\)' 'Freeze does not consume player movement through the player mobj thinker.'
Assert-SourcePattern $enemy '_PE_IsNoTargetMobj\(player\.mo\)' 'Monster sight acquisition ignores the notarget flag.'
Assert-SourcePattern $enemy '_PE_IsNoTargetMobj\(targ\)' 'Monster sound acquisition ignores the notarget flag.'
Assert-SourcePattern $enemy 'function P_ForgetPlayerTarget' 'Existing monster targets are not cleared when invisibility is enabled.'
Assert-SourcePattern $enemy 'function _PE_DropHiddenTarget' 'Invisible has no central path for cancelling active monster attacks.'
Assert-SourcePattern $enemy '(?s)function _PE_DropHiddenTarget.*?MF_SKULLFLY.*?momx\s*=\s*0.*?spawnstate' 'Invisible does not cancel active monster charge momentum safely.'
Assert-SourcePattern $enemy '(?s)function P_ForgetPlayerTarget.*?actor\.tracer\s*==\s*playerMo.*?actor\.tracer\s*=\s*void' 'Invisible does not release active homing or Arch-vile tracer locks.'
Assert-SourcePattern $enemy '(?s)function P_NoiseAlert\(target, emmiter\).*?_PE_IsNoTargetMobj\(target\).*?return' 'Invisible weapon noise can still wake monsters.'
Assert-SourcePattern $interaction '(?s)function P_DamageMobj.*?not _PI_IsNoTargetPlayerMobj\(source\).*?target\.target\s*=\s*source' 'Damaging a monster while invisible can still make it retaliate.'
Assert-SourcePattern $weapon 'P_NoiseAlert.*player\.cheats.*CF_NOTARGET.*==\s*0' 'Weapon fire does not suppress monster alerts while invisible.'
if ($weapon -match 'player\.cheats\s*=\s*player\.cheats\s*&.*CF_NOTARGET') { throw 'Firing still disables persistent invisible mode.' }
Assert-SourcePattern $commands 'INVISIBLE - MONSTERS NEVER TARGET YOU' 'Cheat help still describes invisible as ending when the player fires.'

# Purpose: Types an ASCII command through the same polled Win32 key path used by real gameplay.
function Send-ConsoleCommand {
    param(
        [Parameter(Mandatory = $true)][System.Diagnostics.Process]$Process,
        [Parameter(Mandatory = $true)][string]$Command
    )

    foreach ($character in $Command.ToUpperInvariant().ToCharArray()) {
        $virtualKey = [int][char]$character
        Send-MiniDoomKey -Process $Process -VirtualKey $virtualKey -HoldMilliseconds 45
    }
    Send-MiniDoomKey -Process $Process -VirtualKey 0x0D -HoldMilliseconds 70
}

# Purpose: Measures only the 3D viewport so weapon bob and the window caption cannot fake player movement.
function Measure-ViewportDifference {
    param(
        [Parameter(Mandatory = $true)][string]$A,
        [Parameter(Mandatory = $true)][string]$B
    )

    Add-Type -AssemblyName System.Drawing
    $left = [System.Drawing.Bitmap]::FromFile($A)
    $right = [System.Drawing.Bitmap]::FromFile($B)
    try {
        $width = [Math]::Min($left.Width, $right.Width)
        $height = [Math]::Min($left.Height, $right.Height)
        $startY = 40
        $endY = [int]($height * 0.62)
        [double]$sum = 0
        [int]$channels = 0
        for ($y = $startY; $y -lt $endY; $y += 3) {
            for ($x = 0; $x -lt $width; $x += 3) {
                $ca = $left.GetPixel($x, $y)
                $cb = $right.GetPixel($x, $y)
                $sum += [Math]::Abs($ca.R - $cb.R) + [Math]::Abs($ca.G - $cb.G) + [Math]::Abs($ca.B - $cb.B)
                $channels += 3
            }
        }
        if ($channels -eq 0) { return 0.0 }
        return $sum / $channels
    }
    finally {
        $left.Dispose()
        $right.Dispose()
    }
}

$runtime = $null
try {
    $runtime = Start-MiniDoomForTest -RepoRoot $RepoRoot -Arguments @('-iwad', $Iwad, '-windowed', '-opengl', '-nohdwad', '-warp', '1', '-nomonsters') -WindowTimeoutSeconds 45
    Start-Sleep -Seconds 4
    Assert-MiniDoomHealthy -Process $runtime

    $closedShot = Join-Path $ArtifactDir '01_console_closed.png'
    Save-MiniDoomWindowImage -Process $runtime -Path $closedShot | Out-Null
    Send-MiniDoomKey -Process $runtime -VirtualKey 0xDC -HoldMilliseconds 120
    Start-Sleep -Milliseconds 350
    $openShot = Join-Path $ArtifactDir '02_console_open_via_caret.png'
    Save-MiniDoomWindowImage -Process $runtime -Path $openShot | Out-Null
    Assert-MiniDoomImageLooksDrawn -Path $openShot -Label 'console opened by German caret key'
    $consoleDifference = Measure-MiniDoomImageDifference -A $closedShot -B $openShot
    Assert-True ($consoleDifference -gt 2.0) "German caret key did not visibly open the console (mean diff $consoleDifference)."

    Send-ConsoleCommand -Process $runtime -Command 'freeze'
    Send-MiniDoomKey -Process $runtime -VirtualKey 0xDC -HoldMilliseconds 120
    Start-Sleep -Milliseconds 350
    $beforeMove = Join-Path $ArtifactDir '03_frozen_before_player_move.png'
    Save-MiniDoomWindowImage -Process $runtime -Path $beforeMove | Out-Null
    Send-MiniDoomKey -Process $runtime -VirtualKey 0x57 -HoldMilliseconds 1200
    Start-Sleep -Milliseconds 350
    $afterMove = Join-Path $ArtifactDir '04_frozen_after_player_move.png'
    Save-MiniDoomWindowImage -Process $runtime -Path $afterMove | Out-Null
    $movementDifference = Measure-ViewportDifference -A $beforeMove -B $afterMove
    Assert-True ($movementDifference -gt 1.0) "Player view did not move while freeze was active (viewport mean diff $movementDifference)."
}
finally {
    Stop-MiniDoomForTest -Process $runtime
}

Write-Output 'Drop-down console architecture, caret input, commands, and freeze movement PASS.'
