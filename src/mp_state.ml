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

  Script: mp_state.ml
  Purpose: Stores multiplayer runtime/config state and utility helpers for map lists and WAD checks.
*/

import doomdef
import m_argv
import mp_fnv1a
import std.fs as fs
import std.math

const MP_MODE_COOP = 0
const MP_MODE_DEATHMATCH = 1
const MP_MAX_NAME_LEN = 25
const MP_DEFAULT_PORT = 2342
const MP_SKILL_BABY = 0
const MP_SKILL_EASY = 1
const MP_SKILL_MEDIUM = 2
const MP_SKILL_HARD = 3
const MP_SKILL_NIGHTMARE = 4

mp_player_name = "Player"
mp_join_host = "127.0.0.1"
mp_join_port = MP_DEFAULT_PORT
mp_host_port = MP_DEFAULT_PORT
mp_host_mode = MP_MODE_COOP
mp_host_skill = MP_SKILL_MEDIUM
mp_host_max_players = 4
mp_dm_frag_limit = 20
mp_dm_time_limit = 10

mp_map_list = []
mp_map_index = 0
mp_preferred_map_name = "MAP01"

mp_iwad_path = ""
mp_iwad_fnv1a_hex = ""

/*
* Function: _MP_ToInt
* Purpose: Converts values to int with safe fallback.
*/
function _MP_ToInt(v, fallback)
  if typeof(v) == "int" then return v end if
  if typeof(v) == "float" then
    if v >= 0 then return std.math.floor(v) end if
    return std.math.ceil(v)
  end if
  n = toNumber(v)
  if typeof(n) == "int" then return n end if
  if typeof(n) == "float" then
    if n >= 0 then return std.math.floor(n) end if
    return std.math.ceil(n)
  end if
  return fallback
end function

/*
* Function: _MP_Clamp
* Purpose: Clamps integer values.
*/
function _MP_Clamp(v, lo, hi)
  vi = _MP_ToInt(v, 0)
  lo_i = _MP_ToInt(lo, 0)
  hi_i = _MP_ToInt(hi, lo_i)
  if hi_i < lo_i then
    t = lo_i
    lo_i = hi_i
    hi_i = t
  end if
  if vi < lo_i then return lo_i end if
  if vi > hi_i then return hi_i end if
  return vi
end function

/*
* Function: _MP_ToUpperAscii
* Purpose: Converts ASCII letters to uppercase.
*/
function _MP_ToUpperAscii(s)
  if typeof(s) != "string" then return "" end if
  b = bytes(s)
  i = 0
  while i < len(b)
    if b[i] >= 97 and b[i] <= 122 then b[i] = b[i] - 32 end if
    i = i + 1
  end while
  return decode(b)
end function

/*
* Function: _MP_StrContains
* Purpose: Checks if haystack contains needle.
*/
function _MP_StrContains(haystack, needle)
  if typeof(haystack) != "string" or typeof(needle) != "string" then return false end if
  hb = bytes(haystack)
  nb = bytes(needle)
  if len(nb) == 0 then return true end if
  if len(nb) > len(hb) then return false end if
  i = 0
  while i <= len(hb) - len(nb)
    ok = true
    j = 0
    while j < len(nb)
      if hb[i + j] != nb[j] then
        ok = false
        break
      end if
      j = j + 1
    end while
    if ok then return true end if
    i = i + 1
  end while
  return false
end function

/*
* Function: _MP_IsAllowedNameByte
* Purpose: Validates player-name ASCII bytes.
*/
function inline _MP_IsAllowedNameByte(c)
  if c >= 48 and c <= 57 then return true end if
  if c >= 65 and c <= 90 then return true end if
  if c >= 97 and c <= 122 then return true end if
  if c == 32 or c == 45 or c == 95 then return true end if
  return false
end function

/*
* Function: MP_SanitizeName
* Purpose: Sanitizes and trims player names to protocol constraints.
*/
function MP_SanitizeName(name)
  if typeof(name) != "string" then return "Player" end if
  src = bytes(name)
  if len(src) == 0 then return "Player" end if

  namebuf = bytes(MP_MAX_NAME_LEN, 0)
  oi = 0
  i = 0
  while i < len(src) and oi < MP_MAX_NAME_LEN
    c = src[i]
    if _MP_IsAllowedNameByte(c) then
      namebuf[oi] = c
      oi = oi + 1
    end if
    i = i + 1
  end while

  if oi == 0 then return "Player" end if
  while oi > 0 and namebuf[oi - 1] == 32
    oi = oi - 1
  end while
  if oi <= 0 then return "Player" end if
  return decode(slice(namebuf, 0, oi))
end function

/*
* Function: MP_SetPlayerName
* Purpose: Stores sanitized multiplayer player name.
*/
function MP_SetPlayerName(name)
  global mp_player_name
  mp_player_name = MP_SanitizeName(name)
end function

/*
* Function: MP_GetPlayerName
* Purpose: Returns current multiplayer player name.
*/
function MP_GetPlayerName()
  if typeof(mp_player_name) != "string" or mp_player_name == "" then return "Player" end if
  return mp_player_name
end function

/*
* Function: _MP_TwoDigits
* Purpose: Formats a number as two ASCII digits.
*/
function inline _MP_TwoDigits(v)
  if v < 0 then v = 0 end if
  if v > 99 then v = 99 end if
  d1 = std.math.floor(v / 10)
  d2 = v % 10
  b = bytes(2, 0)
  b[0] = 48 + d1
  b[1] = 48 + d2
  return decode(b)
end function

/*
* Function: MP_RebuildMapList
* Purpose: Rebuilds host-map selection list based on IWAD filename family.
*/
function MP_RebuildMapList()
  global mp_map_list
  global mp_map_index

  low = _MP_ToUpperAscii(MP_GetIwadPath())
  isCommercial = _MP_StrContains(low, "DOOM2") or _MP_StrContains(low, "PLUTONIA") or _MP_StrContains(low, "TNT")
  isShareware = _MP_StrContains(low, "DOOM1")

  lst = []
  if isCommercial then
    m = 1
    while m <= 32
      lst = lst + ["MAP" + _MP_TwoDigits(m)]
      m = m + 1
    end while
  else
    eEnd = 4
    if isShareware then eEnd = 1 end if
    e = 1
    while e <= eEnd
      m = 1
      while m <= 9
        lst = lst + ["E" + e + "M" + m]
        m = m + 1
      end while
      e = e + 1
    end while
  end if

  if len(lst) == 0 then lst = ["MAP01"] end if
  mp_map_list = lst
  MP_SetSelectedMapByName(mp_preferred_map_name)
end function

/*
* Function: MP_GetSelectedMap
* Purpose: Returns currently selected host map name.
*/
function MP_GetSelectedMap()
  global mp_preferred_map_name
  global mp_map_index
  if typeof(mp_map_list) != "array" or len(mp_map_list) == 0 then MP_RebuildMapList() end if
  if len(mp_map_list) == 0 then return "MAP01" end if
  if mp_map_index < 0 then mp_map_index = 0 end if
  if mp_map_index >= len(mp_map_list) then mp_map_index = len(mp_map_list) - 1 end if
  mp_preferred_map_name = _MP_ToUpperAscii(mp_map_list[mp_map_index])
  return mp_map_list[mp_map_index]
end function

/*
* Function: MP_StepMap
* Purpose: Moves selected map index by delta with wraparound.
*/
function MP_StepMap(delta)
  global mp_map_index
  global mp_preferred_map_name
  if typeof(mp_map_list) != "array" or len(mp_map_list) == 0 then MP_RebuildMapList() end if
  if len(mp_map_list) == 0 then return end if
  n = len(mp_map_list)
  idx = mp_map_index + _MP_ToInt(delta, 1)
  while idx < 0
    idx = idx + n
  end while
  while idx >= n
    idx = idx - n
  end while
  mp_map_index = idx
  mp_preferred_map_name = _MP_ToUpperAscii(mp_map_list[mp_map_index])
end function

/*
* Function: MP_SetSelectedMapByName
* Purpose: Selects map by name if present and stores it as preferred map.
*/
function MP_SetSelectedMapByName(name)
  global mp_map_index
  global mp_preferred_map_name
  if typeof(name) != "string" or name == "" then return false end if
  target = _MP_ToUpperAscii(name)
  mp_preferred_map_name = target
  if typeof(mp_map_list) != "array" or len(mp_map_list) == 0 then MP_RebuildMapList() end if
  i = 0
  while i < len(mp_map_list)
    if _MP_ToUpperAscii(mp_map_list[i]) == target then
      mp_map_index = i
      return true
    end if
    i = i + 1
  end while
  return false
end function

/*
* Function: MP_SetMode
* Purpose: Sets multiplayer host mode.
*/
function MP_SetMode(mode)
  global mp_host_mode
  m = _MP_ToInt(mode, MP_MODE_COOP)
  if m != MP_MODE_DEATHMATCH then m = MP_MODE_COOP end if
  mp_host_mode = m
end function

/*
* Function: MP_GetIwadPath
* Purpose: Returns selected IWAD file path if available.
*/
function MP_GetIwadPath()
  p = M_CheckParm("-iwad")
  if p != 0 and p < myargc - 1 then
    cliPath = myargv[p + 1]
    if typeof(cliPath) == "string" and cliPath != "" and fs.exists(cliPath) and fs.isFile(cliPath) then
      return cliPath
    end if
  end if

  cands = [
  "doom2.wad",
  "plutonia.wad",
  "tnt.wad",
  "doomu.wad",
  "doom.wad",
  "doom1.wad",
  "Doom2.wad",
  "Doom1.wad"
]
  i = 0
  while i < len(cands)
    cp = cands[i]
    if fs.exists(cp) and fs.isFile(cp) then return cp end if
    i = i + 1
  end while
  return ""
end function

/*
* Function: MP_UpdateIwadFingerprint
* Purpose: Computes and stores a fast non-cryptographic fingerprint of currently active IWAD file.
*/
function MP_UpdateIwadFingerprint()
  global mp_iwad_path
  global mp_iwad_fnv1a_hex
  newPath = MP_GetIwadPath()
  if newPath == "" then
    mp_iwad_path = ""
    mp_iwad_fnv1a_hex = ""
    return false
  end if

  // Reuse existing fingerprint while path is unchanged.
  if mp_iwad_path == newPath and typeof(mp_iwad_fnv1a_hex) == "string" and mp_iwad_fnv1a_hex != "" then
    return true
  end if

  raw = fs.readAllBytes(newPath)
  if typeof(raw) != "bytes" then return false end if
  mp_iwad_path = newPath
  mp_iwad_fnv1a_hex = MP_FNV1A_Hex(raw)
  return typeof(mp_iwad_fnv1a_hex) == "string" and mp_iwad_fnv1a_hex != ""
end function

/*
* Function: MP_ClampSettings
* Purpose: Normalizes multiplayer configuration ranges.
*/
function MP_ClampSettings()
  global mp_join_host
  global mp_join_port
  global mp_host_port
  global mp_host_mode
  global mp_host_skill
  global mp_host_max_players
  global mp_dm_frag_limit
  global mp_dm_time_limit

  mp_join_port = _MP_Clamp(_MP_ToInt(mp_join_port, MP_DEFAULT_PORT), 1, 65535)
  mp_host_port = _MP_Clamp(_MP_ToInt(mp_host_port, MP_DEFAULT_PORT), 1, 65535)
  mp_host_mode = _MP_ToInt(mp_host_mode, MP_MODE_COOP)
  if mp_host_mode != MP_MODE_DEATHMATCH then mp_host_mode = MP_MODE_COOP end if
  mp_host_skill = _MP_Clamp(_MP_ToInt(mp_host_skill, MP_SKILL_MEDIUM), MP_SKILL_BABY, MP_SKILL_NIGHTMARE)
  mp_host_max_players = _MP_Clamp(_MP_ToInt(mp_host_max_players, 4), 2, MAXPLAYERS)
  mp_dm_frag_limit = _MP_Clamp(_MP_ToInt(mp_dm_frag_limit, 20), 0, 999)
  mp_dm_time_limit = _MP_Clamp(_MP_ToInt(mp_dm_time_limit, 10), 0, 180)
  if typeof(mp_join_host) != "string" or mp_join_host == "" then mp_join_host = "127.0.0.1" end if
  MP_SetPlayerName(mp_player_name)
end function
