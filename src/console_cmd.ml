/*
  Copyright 2026 Nils Kopal

  Licensed under the Apache License, Version 2.0 (the "License");
  you may not use this file except in compliance with the License.
  You may obtain a copy of the License at

  http://www.apache.org/licenses/LICENSE-2.0

  Unless required by applicable law or agreed to in writing, software
  distributed under the License is distributed on an "AS IS" BASIS,
  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
  See the License for the specific language governing permissions and
  limitations under the License.

*/

//! Parses console command text and performs gameplay or utility actions without owning any UI state.

import doomdef
import doomstat
import p_mobj
import p_tick
import p_inter
import p_enemy
import g_game
import mp_state
import i_system
import std.string as str
import std.math

/// Returns parser output plus UI-neutral requests to clear history or close after a level warp.
struct console_command_result_t
  /// Stores handled for `console_command_result_t`
  handled
  /// Stores message for `console_command_result_t`
  message
  /// Stores clear log for `console_command_result_t`
  clearLog
  /// Stores close console for `console_command_result_t`
  closeConsole
end struct

// Rolling gameplay-key suffix used for classic, console-free IDCLEV entry.
/// Stores the mutable ccmd direct cheat buffer text used by the console cmd subsystem.
/// @internal
_ccmd_direct_cheat_buffer = ""

/// Constructs one normalized command result for the console UI boundary.
/// @param handled Handled value supplied to `_CCMD_Result`.
/// @param message Message text or payload to process.
/// @param clearLog Clear log value supplied to `_CCMD_Result`.
/// @param closeConsole Close console value supplied to `_CCMD_Result`.
/// @internal
function inline _CCMD_Result(handled, message, clearLog, closeConsole)
  return console_command_result_t(handled, message, clearLog, closeConsole)
end function

/// Resolves the checked local player record used by single-player cheat commands.
/// @internal
function inline _CCMD_CurrentPlayer()
  if typeof(players) != "array" then return void end if
  if typeof(consoleplayer) != "int" or consoleplayer < 0 or consoleplayer >= len(players) then return void end if
  if typeof(players[consoleplayer]) != "struct" then return void end if
  return players[consoleplayer]
end function

/// Rejects world-mutating commands outside a live single-player level to avoid network desynchronization.
/// @param requirePlayer Require player value supplied to `_CCMD_RequireGameplayCheat`.
/// @internal
function inline _CCMD_RequireGameplayCheat(requirePlayer)
  if netgame then return "GAMEPLAY COMMANDS ARE DISABLED IN MULTIPLAYER" end if
  if gamestate != gamestate_t.GS_LEVEL then return "THIS COMMAND REQUIRES AN ACTIVE LEVEL" end if
  if requirePlayer then
    p = _CCMD_CurrentPlayer()
    if p is void or p.mo is void then return "NO ACTIVE PLAYER" end if
  end if
  return ""
end function

/// Formats a stable enabled/disabled suffix shared by toggle command responses.
/// @param enabled Whether the requested feature should be enabled.
/// @internal
function inline _CCMD_OnOff(enabled)
  if enabled then return "ON" end if
  return "OFF"
end function

/// Gives armor, every weapon, full carried ammunition, and optionally every key to the local player.
/// @param player Player state affected by the operation.
/// @param includeKeys Include keys value supplied to `_CCMD_GrantArsenal`.
/// @internal
function _CCMD_GrantArsenal(player, includeKeys)
  if player is void then return end if

  player.armorpoints = 200
  player.armortype = 2

  i = 0
  while i < NUMWEAPONS
    if i < len(player.weaponowned) then player.weaponowned[i] = true end if
    i = i + 1
  end while

  i = 0
  while i < NUMAMMO
    if i < len(player.ammo) and i < len(player.maxammo) then
      player.ammo[i] = player.maxammo[i]
    end if
    i = i + 1
  end while

  if includeKeys then
    i = 0
    while i < NUMCARDS
      if i < len(player.cards) then player.cards[i] = true end if
      i = i + 1
    end while
  end if
end function

/// Toggles canonical Doom god mode and restores a viable health value when enabling it.
/// @internal
function _CCMD_God()
  reason = _CCMD_RequireGameplayCheat(true)
  if reason != "" then return _CCMD_Result(false, reason, false, false) end if

  p = _CCMD_CurrentPlayer()
  p.cheats = p.cheats ^ cheat_t.CF_GODMODE
  enabled = (p.cheats & cheat_t.CF_GODMODE) != 0
  if enabled then
    p.health = 100
    p.mo.health = 100
  end if
  return _CCMD_Result(true, "GOD MODE " + _CCMD_OnOff(enabled), false, false)
end function

/// Implements IDFA and IDKFA with their original distinction over key ownership.
/// @param includeKeys Include keys value supplied to `_CCMD_Ammo`.
/// @internal
function _CCMD_Ammo(includeKeys)
  reason = _CCMD_RequireGameplayCheat(true)
  if reason != "" then return _CCMD_Result(false, reason, false, false) end if

  _CCMD_GrantArsenal(_CCMD_CurrentPlayer(), includeKeys)
  if includeKeys then
    return _CCMD_Result(true, "WEAPONS AMMO AND KEYS ADDED", false, false)
  end if
  return _CCMD_Result(true, "WEAPONS AND AMMO ADDED", false, false)
end function

/// Toggles the player's collision-bypass cheat flag.
/// @internal
function _CCMD_NoClip()
  reason = _CCMD_RequireGameplayCheat(true)
  if reason != "" then return _CCMD_Result(false, reason, false, false) end if

  p = _CCMD_CurrentPlayer()
  p.cheats = p.cheats ^ cheat_t.CF_NOCLIP
  enabled = (p.cheats & cheat_t.CF_NOCLIP) != 0
  return _CCMD_Result(true, "NOCLIP " + _CCMD_OnOff(enabled), false, false)
end function

/// Parses one whitespace-trimmed positive decimal integer and rejects every non-digit byte.
/// @param text Text to process.
/// @internal
function _CCMD_ParsePositiveInt(text)
  s = str.trim(text)
  if typeof(s) != "string" or len(s) == 0 then return -1 end if

  b = bytes(s)
  value = 0
  i = 0
  while i < len(b)
    if b[i] < 48 or b[i] > 57 then return -1 end if
    value = value * 10 +(b[i] - 48)
    i = i + 1
  end while
  if value <= 0 then return -1 end if
  return value
end function

/// Validates a Doom II map number or Doom episode/map pair and queues the normal level transition.
/// @param argument Argument value supplied to `_CCMD_IdClev`.
/// @internal
function _CCMD_IdClev(argument)
  reason = _CCMD_RequireGameplayCheat(false)
  if reason != "" then return _CCMD_Result(false, reason, false, false) end if

  value = _CCMD_ParsePositiveInt(argument)
  if value < 0 then return _CCMD_Result(false, "USAGE: IDCLEV MAPNUMBER", false, false) end if

  epsd = gameepisode
  map = value
  if gamemode == GameMode_t.commercial then
    epsd = 0
    if map < 1 or map > 34 then return _CCMD_Result(false, "MAP NUMBER OUT OF RANGE", false, false) end if
  else if value >= 10 then
    epsd = std.math.floor(value / 10)
    map = value % 10
  end if

  if gamemode != GameMode_t.commercial and(epsd < 1 or map < 1 or map > 9) then
    return _CCMD_Result(false, "MAP NUMBER OUT OF RANGE", false, false)
  end if
  if gamemode == GameMode_t.retail and epsd > 4 then return _CCMD_Result(false, "EPISODE OUT OF RANGE", false, false) end if
  if gamemode == GameMode_t.registered and epsd > 3 then return _CCMD_Result(false, "EPISODE OUT OF RANGE", false, false) end if
  if gamemode == GameMode_t.shareware and epsd > 1 then return _CCMD_Result(false, "EPISODE OUT OF RANGE", false, false) end if

  G_DeferedInitNew(gameskill, epsd, map)
  return _CCMD_Result(true, "LEVEL CHANGE QUEUED", false, true)
end function

/// Toggles persistent monster notarget behavior and immediately cancels existing locks and attacks when
/// enabled.
/// @internal
function _CCMD_Invisible()
  reason = _CCMD_RequireGameplayCheat(true)
  if reason != "" then return _CCMD_Result(false, reason, false, false) end if

  p = _CCMD_CurrentPlayer()
  p.cheats = p.cheats ^ cheat_t.CF_NOTARGET
  enabled = (p.cheats & cheat_t.CF_NOTARGET) != 0
  if enabled and typeof(P_ForgetPlayerTarget) == "function" then
    P_ForgetPlayerTarget(p.mo)
  end if
  return _CCMD_Result(true, "INVISIBLE " + _CCMD_OnOff(enabled), false, false)
end function

/// Toggles suspension of non-player thinkers and world specials.
/// @internal
function _CCMD_Freeze()
  global consolefreeze

  reason = _CCMD_RequireGameplayCheat(false)
  if reason != "" then return _CCMD_Result(false, reason, false, false) end if
  consolefreeze = not consolefreeze
  return _CCMD_Result(true, "WORLD FREEZE " + _CCMD_OnOff(consolefreeze), false, false)
end function

/// Resolves one thinker node to its registered mobj owner for world command scans.
/// @param node Node value supplied to `_CCMD_ResolveMobj`.
/// @internal
function inline _CCMD_ResolveMobj(node)
  if node is void or node.func is void or node.func.acp1 != P_MobjThinker then return void end if
  if typeof(P_ResolveThinkerOwner) != "function" then return void end if
  return P_ResolveThinkerOwner(node)
end function

/// Applies lethal damage to every living counted monster, lost soul, and Icon of Sin brain in the level.
/// @internal
function _CCMD_KillMonsters()
  reason = _CCMD_RequireGameplayCheat(true)
  if reason != "" then return _CCMD_Result(false, reason, false, false) end if

  source = _CCMD_CurrentPlayer().mo
  killed = 0
  cur = thinkercap.next
  while cur is not void and cur != thinkercap
    next = cur.next
    mo = _CCMD_ResolveMobj(cur)
    if mo is not void and mo.player is void and mo.health > 0 and (mo.flags & mobjflag_t.MF_SHOOTABLE) != 0 then
      isMonster = (mo.flags & mobjflag_t.MF_COUNTKILL) != 0
      if mo.type == mobjtype_t.MT_SKULL or mo.type == mobjtype_t.MT_BOSSBRAIN then isMonster = true end if
      if isMonster then
        P_DamageMobj(mo, void, source, 1000000)
        killed = killed + 1
      end if
    end if
    cur = next
  end while
  return _CCMD_Result(true, "MONSTERS KILLED: " + killed, false, false)
end function

/// Toggles the in-game presentation-rate overlay independently of the window title.
/// @internal
function _CCMD_Fps()
  global console_show_fps
  console_show_fps = not console_show_fps
  return _CCMD_Result(true, "FPS DISPLAY " + _CCMD_OnOff(console_show_fps), false, false)
end function

/// Shows or changes the persistent local player name and announces it to an active multiplayer session.
/// @param argument Argument value supplied to `_CCMD_Name`.
/// @param setName Set name value supplied to `_CCMD_Name`.
/// @internal
function _CCMD_Name(argument, setName)
  if not setName then
    return _CCMD_Result(true, "PLAYER NAME: " + MP_GetPlayerName(), false, false)
  end if

  requested = str.trim(argument)
  if requested == "" then return _CCMD_Result(false, "USAGE: NAME PLAYERNAME", false, false) end if
  clean = ""
  if typeof(D_NetMPSetPlayerName) == "function" then
    clean = D_NetMPSetPlayerName(requested)
  else
    MP_SetPlayerName(requested)
    clean = MP_GetPlayerName()
  end if
  return _CCMD_Result(true, "PLAYER NAME: " + clean, false, false)
end function

/// Describes console activation, navigation, logging, pause behavior, and utility commands.
/// @internal
function _CCMD_Help()
  message = "HELP - CONSOLE CONTROLS\n"
  message = message + "~ OR O-UMLAUT - OPEN/CLOSE\n"
  message = message + "ENTER - RUN COMMAND\n"
  message = message + "UP/DOWN - COMMAND HISTORY\n"
  message = message + "PAGEUP/PAGEDOWN - SCROLL LOG\n"
  message = message + "ESC - CLOSE CONSOLE\n"
  message = message + "LOGS HUD, CHAT, ERRORS AND COMMANDS\n"
  message = message + "GAME IS PAUSED WHILE OPEN\n"
  message = message + "TOOLS: HELP, CHEATS, NAME, FPS, CLEAR, QUIT\n"
  message = message + "NAME PLAYERNAME - SHOW/CHANGE YOUR NAME"
  return _CCMD_Result(true, message, false, false)
end function

/// Lists every supported single-player gameplay cheat with concise usage text.
/// @internal
function _CCMD_Cheats()
  message = "CHEATS - SINGLE PLAYER ONLY\n"
  message = message + "IDDQD - TOGGLE GOD MODE\n"
  message = message + "IDKFA - WEAPONS AMMO AND KEYS\n"
  message = message + "IDFA - WEAPONS AND AMMO\n"
  message = message + "IDCLIP - TOGGLE WALL COLLISION\n"
  message = message + "IDCLEV NN - WARP; IDCLEVNN ALSO WORKS IN GAME\n"
  message = message + "INVISIBLE - MONSTERS NEVER TARGET YOU\n"
  message = message + "FREEZE - TOGGLE WORLD FREEZE\n"
  message = message + "KILL MONSTERS - KILL ALL ENEMIES"
  return _CCMD_Result(true, message, false, false)
end function

/// Normalizes one input line and dispatches it to isolated command implementations.
/// @param line Map line or text line affected by the operation.
function CCMD_Execute(line)
  if typeof(line) != "string" then return _CCMD_Result(false, "INVALID COMMAND", false, false) end if
  rawCommand = str.trim(line)
  command = str.toLowerAscii(rawCommand)
  if command == "" then return _CCMD_Result(false, "", false, false) end if

  if command == "help" then return _CCMD_Help() end if
  if command == "cheats" then return _CCMD_Cheats() end if
  if command == "iddqd" then return _CCMD_God() end if
  if command == "idkfa" then return _CCMD_Ammo(true) end if
  if command == "idfa" then return _CCMD_Ammo(false) end if
  if command == "idclip" then return _CCMD_NoClip() end if
  if str.startsWith(command, "idclev") then
    return _CCMD_IdClev(stringSlice(command, 6, len(command) - 6))
  end if
  if command == "invisible" then return _CCMD_Invisible() end if
  if command == "freeze" then return _CCMD_Freeze() end if
  if command == "kill monsters" then return _CCMD_KillMonsters() end if
  if command == "name" then return _CCMD_Name("", false) end if
  if str.startsWith(command, "name ") then
    return _CCMD_Name(stringSlice(rawCommand, 5, len(rawCommand) - 5), true)
  end if
  if command == "fps" then return _CCMD_Fps() end if
  if command == "clear" then return _CCMD_Result(true, "", true, false) end if
  if command == "quit" then
    I_Quit()
    return _CCMD_Result(true, "", false, false)
  end if

  return _CCMD_Result(false, "UNKNOWN COMMAND: " + command + " - TYPE HELP", false, false)
end function

/// Detects classic IDCLEV plus two digits in ordinary gameplay without consuming movement keys.
/// @param ev Input event to process.
function CCMD_DirectCheatResponder(ev)
  global _ccmd_direct_cheat_buffer
  if ev is void or ev.type != evtype_t.ev_keydown then return false end if
  if gamestate != gamestate_t.GS_LEVEL then
    _ccmd_direct_cheat_buffer = ""
    return false
  end if

  key = ev.data1
  if typeof(key) != "int" then return false end if
  if key >= 65 and key <= 90 then key = key + 32 end if
  isDigit = key >= 48 and key <= 57
  isLetter = key >= 97 and key <= 122
  if not isDigit and not isLetter then return false end if

  _ccmd_direct_cheat_buffer = _ccmd_direct_cheat_buffer + decode(bytes([key]))
  if len(_ccmd_direct_cheat_buffer) > 8 then
    _ccmd_direct_cheat_buffer = stringSlice(_ccmd_direct_cheat_buffer, len(_ccmd_direct_cheat_buffer) - 8, 8)
  end if
  if len(_ccmd_direct_cheat_buffer) != 8 then return false end if
  if stringSlice(_ccmd_direct_cheat_buffer, 0, 6) != "idclev" then return false end if

  digits = stringSlice(_ccmd_direct_cheat_buffer, 6, 2)
  db = bytes(digits)
  if len(db) != 2 or db[0] < 48 or db[0] > 57 or db[1] < 48 or db[1] > 57 then return false end if
  _ccmd_direct_cheat_buffer = ""
  result = _CCMD_IdClev(digits)
  if typeof(players) == "array" and consoleplayer >= 0 and consoleplayer < len(players) and typeof(players[consoleplayer]) == "struct" then
    p = players[consoleplayer]
    if result is not void and typeof(result.message) == "string" and result.message != "" then p.message = result.message end if
    players[consoleplayer] = p
  end if
  return false
end function
