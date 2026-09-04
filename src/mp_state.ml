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

//! Stores multiplayer runtime/config state and utility helpers for map lists and WAD checks.


import doomdef
import m_argv
import mp_fnv1a
import std.fs as fs
import std.math

/// Defines mp mode coop for the mp state subsystem.
const MP_MODE_COOP = 0
/// Defines mp mode deathmatch for the mp state subsystem.
const MP_MODE_DEATHMATCH = 1
/// Defines the maximum mp max name len accepted by the mp state subsystem.
const MP_MAX_NAME_LEN = 25
/// Defines mp default port for the mp state subsystem.
const MP_DEFAULT_PORT = 2342
/// Defines mp skill baby for the mp state subsystem.
const MP_SKILL_BABY = 0
/// Defines mp skill easy for the mp state subsystem.
const MP_SKILL_EASY = 1
/// Defines mp skill medium for the mp state subsystem.
const MP_SKILL_MEDIUM = 2
/// Defines mp skill hard for the mp state subsystem.
const MP_SKILL_HARD = 3
/// Defines mp skill nightmare for the mp state subsystem.
const MP_SKILL_NIGHTMARE = 4

/// Stores the mutable mp player name text used by the mp state subsystem.
mp_player_name = "Player"
/// Stores the mutable mp join host text used by the mp state subsystem.
mp_join_host = "127.0.0.1"
/// Tracks the mutable mp join port value used by the mp state subsystem.
mp_join_port = MP_DEFAULT_PORT
/// Tracks the mutable mp host port value used by the mp state subsystem.
mp_host_port = MP_DEFAULT_PORT
/// Tracks the mutable mp host mode value used by the mp state subsystem.
mp_host_mode = MP_MODE_COOP
/// Tracks the mutable mp host skill value used by the mp state subsystem.
mp_host_skill = MP_SKILL_MEDIUM
/// Tracks the mutable mp host max players value used by the mp state subsystem.
mp_host_max_players = 4
/// Tracks the mutable mp dm frag limit value used by the mp state subsystem.
mp_dm_frag_limit = 20
/// Tracks the mutable mp dm time limit value used by the mp state subsystem.
mp_dm_time_limit = 10

/// Stores the mp map list collection used by the mp state subsystem.
mp_map_list = []
/// Tracks the mutable mp map index value used by the mp state subsystem.
mp_map_index = 0
/// Stores the mutable mp preferred map name text used by the mp state subsystem.
mp_preferred_map_name = "MAP01"

/// Stores the mutable mp iwad path text used by the mp state subsystem.
mp_iwad_path = ""
/// Stores the mutable mp iwad fnv1a hex text used by the mp state subsystem.
mp_iwad_fnv1a_hex = ""

/// Converts values to int with safe fallback.
/// @param v Value consumed by the operation.
/// @param fallback Value returned when the requested conversion or lookup is unavailable.
/// @internal
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

/// Clamps integer values.
/// @param v Value consumed by the operation.
/// @param lo Inclusive lower bound.
/// @param hi Inclusive upper bound.
/// @internal
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

/// Converts ASCII letters to uppercase.
/// @param s S value supplied to `_MP_ToUpperAscii`.
/// @internal
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

/// Checks if haystack contains needle.
/// @param haystack Haystack value supplied to `_MP_StrContains`.
/// @param needle Needle value supplied to `_MP_StrContains`.
/// @internal
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

/// Validates player-name ASCII bytes.
/// @param c C value supplied to `_MP_IsAllowedNameByte`.
/// @internal
function inline _MP_IsAllowedNameByte(c)
  if c >= 48 and c <= 57 then return true end if
  if c >= 65 and c <= 90 then return true end if
  if c >= 97 and c <= 122 then return true end if
  if c == 32 or c == 45 or c == 95 then return true end if
  return false
end function

/// Sanitizes and trims player names to protocol constraints.
/// @param name Resource or object name to resolve.
function MP_SanitizeName(name)
  if typeof(name) != "string" then return "Player" end if
  src = bytes(name)
  if len(src) == 0 then return "Player" end if

  namebuf = bytes(MP_MAX_NAME_LEN, 0)
  oi = 0
  i = 0
  while i < len(src) and oi < MP_MAX_NAME_LEN
    c = src[i]
    // Skip leading spaces even when invalid bytes preceded them.
    if _MP_IsAllowedNameByte(c) and(c != 32 or oi > 0) then
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

/// Stores sanitized multiplayer player name.
/// @param name Resource or object name to resolve.
function MP_SetPlayerName(name)
  global mp_player_name
  mp_player_name = MP_SanitizeName(name)
end function

/// Returns current multiplayer player name.
function MP_GetPlayerName()
  if typeof(mp_player_name) != "string" or mp_player_name == "" then return "Player" end if
  return mp_player_name
end function

/// Formats a number as two ASCII digits.
/// @param v Value consumed by the operation.
/// @internal
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

/// Rebuilds host-map selection list based on IWAD filename family.
function MP_RebuildMapList()
  global mp_map_list
  global mp_map_index

  low = _MP_ToUpperAscii(MP_GetIwadPath())
  isCommercial = gamemode == GameMode_t.commercial
  isShareware = gamemode == GameMode_t.shareware
  // Before IdentifyVersion/WAD init, retain the filename fallback used by the menu bootstrap.
  if typeof(gamemode) == "void" then
    isCommercial = _MP_StrContains(low, "DOOM2") or _MP_StrContains(low, "PLUTONIA") or _MP_StrContains(low, "TNT")
    isShareware = _MP_StrContains(low, "DOOM1")
  end if

  lst = []
  if isCommercial then
    m = 1
    while m <= 32
      token = "MAP" + _MP_TwoDigits(m)
      available = true
      if typeof(W_CheckNumForName) == "function" then available = W_CheckNumForName(token) >= 0 end if
      if available then lst = lst + [token] end if
      m = m + 1
    end while
  else
    eEnd = 4
    if isShareware then eEnd = 1 end if
    e = 1
    while e <= eEnd
      m = 1
      while m <= 9
        token = "E" + e + "M" + m
        available = true
        if typeof(W_CheckNumForName) == "function" then available = W_CheckNumForName(token) >= 0 end if
        if available then lst = lst + [token] end if
        m = m + 1
      end while
      e = e + 1
    end while
  end if

  if len(lst) == 0 then lst = ["MAP01"] end if
  mp_map_list = lst
  MP_SetSelectedMapByName(mp_preferred_map_name)
end function

/// Returns currently selected host map name.
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

/// Moves selected map index by delta with wraparound.
/// @param delta Delta value supplied to `MP_StepMap`.
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

/// Selects map by name if present and stores it as preferred map.
/// @param name Resource or object name to resolve.
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

/// Sets multiplayer host mode.
/// @param mode Mode value supplied to `MP_SetMode`.
function MP_SetMode(mode)
  global mp_host_mode
  m = _MP_ToInt(mode, MP_MODE_COOP)
  if m != MP_MODE_DEATHMATCH then m = MP_MODE_COOP end if
  mp_host_mode = m
end function

/// Returns selected IWAD file path if available.
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

/// Fingerprints every gameplay WAD in load order so host/client PWAD mismatches are rejected too.
function MP_UpdateIwadFingerprint()
  global mp_iwad_path
  global mp_iwad_fnv1a_hex
  newPath = MP_GetIwadPath()
  if newPath == "" then
    mp_iwad_path = ""
    mp_iwad_fnv1a_hex = ""
    return false
  end if

  paths = []
  if typeof(wadfiles) == "array" then
    i = 0
    while i < len(wadfiles)
      p = wadfiles[i]
      if typeof(p) == "string" then
        up = _MP_ToUpperAscii(p)
        pb = bytes(up)
        isWad = false
        if len(pb) >= 4 then
          n = len(pb)
          isWad = pb[n - 4] == 46 and pb[n - 3] == 87 and pb[n - 2] == 65 and pb[n - 1] == 68
        end if
        // Automatic .hdwad render caches are not gameplay compatibility inputs.
        if isWad and not _MP_StrContains(up, ".HDWAD") and fs.exists(p) and fs.isFile(p) then
          paths = paths + [p]
        end if
      end if
      i = i + 1
    end while
  end if
  if len(paths) == 0 then paths = [newPath] end if

  // Fold each loaded file into one FNV-1a state. A four-byte length delimiter keeps
  // different WAD partitions from hashing like the same concatenated byte run.
  h = 2166136261
  totalBytes = 0
  i = 0
  while i < len(paths)
    rawTry = try(fs.readAllBytes(paths[i]))
    if typeof(rawTry) == "error" or typeof(rawTry) != "bytes" then return false end if
    raw = rawTry
    fileLen = len(raw)
    shift = 0
    while shift < 32
      h = h ^ ((fileLen >> shift) & 255)
      h = _MP_HASH_U32(h * 16777619)
      shift = shift + 8
    end while
    j = 0
    while j < fileLen
      h = h ^ (raw[j] & 255)
      h = _MP_HASH_U32(h * 16777619)
      j = j + 1
    end while
    totalBytes = _MP_HASH_U32(totalBytes + fileLen)
    i = i + 1
  end while
  mp_iwad_path = newPath
  mp_iwad_fnv1a_hex = _MP_HASH_ToHex8(h) + _MP_HASH_ToHex8(totalBytes)
  return typeof(mp_iwad_fnv1a_hex) == "string" and mp_iwad_fnv1a_hex != ""
end function

/// Normalizes multiplayer configuration ranges.
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
