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

//! Handles configuration defaults, screenshots, file buffers, and Doom patch-backed utility output.

import doomtype
import doomdef
import z_zone
import m_swap
import m_argv
import w_wad
import i_system
import i_video
import v_video
import hu_stuff
import m_menu
import doomstat
import dstrings
import m_misc
import mp_state
import std.fs as fs

/// Decodes one unsigned little-endian 16-bit value from a byte buffer with bounds checks.
/// @param b Second input operand.
/// @param off Zero-based byte or element offset.
/// @internal
function inline _M_u16le(b, off)
  return b[off] +(b[off + 1] << 8)
end function

/// Reads a Doom patch's little-endian width field, returning zero for malformed data.
/// @param patch Patch value supplied to `_M_patchWidth`.
/// @internal
function inline _M_patchWidth(patch)
  if typeof(patch) != "bytes" then return 0 end if
  return _M_u16le(patch, 0)
end function

/// Folds one lowercase ASCII byte to uppercase while leaving all other bytes unchanged.
/// @param c C value supplied to `_M_UpperAscii`.
/// @internal
function inline _M_UpperAscii(c)
  if c >= 97 and c <= 122 then return c - 32 end if
  return c
end function

/// Returns a signed quotient truncated toward zero, or zero for invalid operands and a zero divisor in
/// `_MMISC_IDiv`
/// @param a First input operand.
/// @param b Second input operand.
/// @internal
function inline _MMISC_IDiv(a, b)
  if typeof(a) != "int" or typeof(b) != "int" or b == 0 then return 0 end if
  q = a / b
  if q >= 0 then return std.math.floor(q) end if
  return std.math.ceil(q)
end function

/// Encodes the low 16 bits of a value at a byte-buffer offset in little-endian order.
/// @param buf Buf value supplied to `_M_WriteU16LE`.
/// @param off Zero-based byte or element offset.
/// @param value Value consumed by the operation.
/// @internal
function inline _M_WriteU16LE(buf, off, value)
  if value < 0 then value = value + 65536 end if
  buf[off] = value & 255
  buf[off + 1] =(value >> 8) & 255
end function

/// Formats a two-digit screenshot slot as the classic DOOMnn.pcx filename.
/// @param i Zero-based iteration index.
/// @internal
function inline _M_MakeShotName(i)
  b = bytes("DOOM00.pcx")
  b[4] = 48 +(_MMISC_IDiv(i, 10) % 10)
  b[5] = 48 +(i % 10)
  return decode(b)
end function

/// Validates indexed pixels and palette, RLE-encodes a complete 8-bit PCX image, and saves it to disk.
/// @param filename Filesystem name of the target resource.
/// @param data Binary or structured data to process.
/// @param width Width of the target in pixels or map units.
/// @param height Height of the target in pixels or map units.
/// @param palette Palette value supplied to `_M_WritePCXfile`.
/// @internal
function _M_WritePCXfile(filename, data, width, height, palette)
  if typeof(filename) != "string" then return false end if
  if typeof(data) != "bytes" then return false end if
  if typeof(palette) != "bytes" then return false end if
  if width <= 0 or height <= 0 then return false end if
  if len(data) <(width * height) then return false end if
  if len(palette) < 768 then return false end if

  maxLen = 128 +(width * height * 2) + 769
  pcx = bytes(maxLen, 0)

  pcx[0] = 0x0A
  pcx[1] = 5
  pcx[2] = 1
  pcx[3] = 8
  _M_WriteU16LE(pcx, 4, 0)
  _M_WriteU16LE(pcx, 6, 0)
  _M_WriteU16LE(pcx, 8, width - 1)
  _M_WriteU16LE(pcx, 10, height - 1)
  _M_WriteU16LE(pcx, 12, width)
  _M_WriteU16LE(pcx, 14, height)
  pcx[64] = 0
  pcx[65] = 1
  _M_WriteU16LE(pcx, 66, width)
  _M_WriteU16LE(pcx, 68, 2)

  pack = 128
  pixCount = width * height
  i = 0
  while i < pixCount
    v = data[i]
    if (v & 0xC0) != 0xC0 then
      pcx[pack] = v
      pack = pack + 1
    else
      pcx[pack] = 0xC1
      pcx[pack + 1] = v
      pack = pack + 2
    end if
    i = i + 1
  end while

  pcx[pack] = 0x0C
  pack = pack + 1

  i = 0
  while i < 768
    pcx[pack] = palette[i]
    pack = pack + 1
    i = i + 1
  end while

  return M_WriteFile(filename, pcx, pack)
end function

/// Exposes the validated 8-bit PCX encoder through Doom's public screenshot-writing entry point.
/// @param filename Filesystem name of the target resource.
/// @param data Binary or structured data to process.
/// @param width Width of the target in pixels or map units.
/// @param height Height of the target in pixels or map units.
/// @param palette Palette value supplied to `WritePCXfile`.
function WritePCXfile(filename, data, width, height, palette)
  return _M_WritePCXfile(filename, data, width, height, palette)
end function

/// Recognizes the space and horizontal-tab delimiters accepted in configuration lines.
/// @param c C value supplied to `_M_IsSpaceByte`.
/// @internal
function inline _M_IsSpaceByte(c)
  return c == 32 or c == 9
end function

/// Removes leading and trailing configuration whitespace without altering embedded spaces.
/// @param s0 S0 value supplied to `_M_Trim`.
/// @internal
function _M_Trim(s0)
  if typeof(s0) != "string" then return "" end if
  b = bytes(s0)
  if len(b) == 0 then return "" end if

  a = 0
  z = len(b) - 1

  while a <= z and _M_IsSpaceByte(b[a])
    a = a + 1
  end while
  while z >= a and _M_IsSpaceByte(b[z])
    z = z - 1
  end while

  if z < a then return "" end if
  return decode(slice(b, a,(z - a) + 1))
end function

/// Parses parse Int input into utility runtime data.
/// @param s0 S0 value supplied to `_M_ParseInt`.
/// @internal
function _M_ParseInt(s0)
  if typeof(s0) != "string" then return end if
  s0 = _M_Trim(s0)
  if s0 == "" then return end if

  b = bytes(s0)
  if len(b) >= 2 and b[0] == 34 and b[len(b) - 1] == 34 then
    s0 = decode(slice(b, 1, len(b) - 2))
    b = bytes(s0)
  end if
  if len(b) == 0 then return end if

  if len(b) >= 3 and b[0] == 48 and(b[1] == 120 or b[1] == 88) then
    v = 0
    i = 2
    while i < len(b)
      d = -1
      c = b[i]
      if c >= 48 and c <= 57 then
        d = c - 48
      else if c >= 65 and c <= 70 then
        d = 10 +(c - 65)
      else if c >= 97 and c <= 102 then
        d = 10 +(c - 97)
      else
        return
      end if
      v =(v * 16) + d
      i = i + 1
    end while
    return v
  end if

  n = toNumber(s0)
  if typeof(n) == "int" then return n end if
  return
end function

/// Parses optional quoted text value from config lines.
/// @param s0 S0 value supplied to `_M_ParseText`.
/// @internal
function inline _M_ParseText(s0)
  if typeof(s0) != "string" then return "" end if
  s0 = _M_Trim(s0)
  if s0 == "" then return "" end if
  b = bytes(s0)
  if len(b) >= 2 and b[0] == 34 and b[len(b) - 1] == 34 then
    return decode(slice(b, 1, len(b) - 2))
  end if
  return s0
end function

/// Wraps text in quotes for config persistence.
/// @param s0 S0 value supplied to `_M_QuoteText`.
/// @internal
function _M_QuoteText(s0)
  if typeof(s0) != "string" then s0 = "" end if
  b = bytes(s0)
  qb = bytes(len(b) + 2, 0)
  qb[0] = 34
  i = 0
  while i < len(b)
    qb[i + 1] = b[i]
    i = i + 1
  end while
  qb[len(qb) - 1] = 34
  return decode(qb)
end function

/// Parses one configuration key/value pair and assigns the converted value to the matching registered default.
/// @param key Input key code to process.
/// @param val Val value supplied to `_M_ApplyDefaultKV`.
/// @internal
function _M_ApplyDefaultKV(key, val)
  global mouseSensitivity
  global snd_SfxVolume
  global snd_MusicVolume
  global showMessages
  global usemouse
  global usejoystick
  global screenblocks
  global detailLevel
  global usegamma
  global mp_join_host
  global mp_join_port
  global mp_host_port
  global mp_host_mode
  global mp_host_skill
  global mp_host_max_players
  global mp_dm_frag_limit
  global mp_dm_time_limit
  if typeof(key) != "string" or typeof(val) != "string" then return end if
  key = _M_Trim(key)
  val = _M_Trim(val)
  if key == "" then return end if

  n = _M_ParseInt(val)

  if key == "mouse_sensitivity" and typeof(n) == "int" then
    mouseSensitivity = n
    return
  end if
  if key == "sfx_volume" and typeof(n) == "int" then
    snd_SfxVolume = n
    return
  end if
  if key == "music_volume" and typeof(n) == "int" then
    snd_MusicVolume = n
    return
  end if
  if key == "show_messages" and typeof(n) == "int" then
    showMessages = n
    return
  end if
  if key == "use_mouse" and typeof(n) == "int" then
    usemouse = n
    return
  end if
  if key == "use_joystick" and typeof(n) == "int" then
    usejoystick = n
    return
  end if
  if key == "screenblocks" and typeof(n) == "int" then
    screenblocks = n
    return
  end if
  if key == "detaillevel" and typeof(n) == "int" then
    detailLevel = 0
    return
  end if
  if key == "brightness" and typeof(n) == "int" then
    usegamma = n
    return
  end if
  if key == "usegamma" and typeof(n) == "int" then
    usegamma = n
    return
  end if
  if key == "mp_player_name" then
    MP_SetPlayerName(_M_ParseText(val))
    return
  end if
  if key == "mp_join_host" then
    mp_join_host = _M_ParseText(val)
    return
  end if
  if key == "mp_join_port" and typeof(n) == "int" then
    mp_join_port = n
    return
  end if
  if key == "mp_host_port" and typeof(n) == "int" then
    mp_host_port = n
    return
  end if
  if key == "mp_host_mode" and typeof(n) == "int" then
    MP_SetMode(n)
    return
  end if
  if key == "mp_host_skill" and typeof(n) == "int" then
    mp_host_skill = n
    return
  end if
  if key == "mp_host_max_players" and typeof(n) == "int" then
    mp_host_max_players = n
    return
  end if
  if key == "mp_dm_frag_limit" and typeof(n) == "int" then
    mp_dm_frag_limit = n
    return
  end if
  if key == "mp_dm_time_limit" and typeof(n) == "int" then
    mp_dm_time_limit = n
    return
  end if
  if key == "mp_map_name" then
    MP_SetSelectedMapByName(_M_ParseText(val))
    return
  end if
end function

/// Chooses the configuration path from -config, the -cdrom legacy location, an existing base override, or
/// default.cfg.
/// @internal
function _M_GetDefaultFilePath()
  i = M_CheckParm("-config")
  if i != 0 and i < myargc - 1 then
    return myargv[i + 1]
  end if

  if M_CheckParm("-cdrom") != 0 then
    return "c:\\doomdata\\default.cfg"
  end if

  if typeof(basedefault) == "string" and basedefault != "" then
    return basedefault
  end if
  return "default.cfg"
end function

/// Parses parse Default Line input into utility runtime data.
/// @param line Map line or text line affected by the operation.
/// @internal
function _M_ParseDefaultLine(line)
  if typeof(line) != "string" then return end if
  line = _M_Trim(line)
  if line == "" then return end if
  b = bytes(line)
  if len(b) == 0 then return end if
  if b[0] == 35 or b[0] == 59 then return end if

  i = 0
  while i < len(b) and not _M_IsSpaceByte(b[i])
    i = i + 1
  end while
  if i <= 0 then return end if
  key = decode(slice(b, 0, i))

  while i < len(b) and _M_IsSpaceByte(b[i])
    i = i + 1
  end while
  if i >= len(b) then return end if
  val = decode(slice(b, i, len(b) - i))

  _M_ApplyDefaultKV(key, val)
end function

/// Determines whether a target path can be written by verifying that its parent directory exists.
/// @param path Filesystem path to process.
/// @internal
function _M_ParentDirExists(path)
  if typeof(path) != "string" then return false end if
  b = bytes(path)
  if len(b) == 0 then return false end if

  last = -1
  i = 0
  while i < len(b)
    if b[i] == 92 or b[i] == 47 then last = i end if
    i = i + 1
  end while

  if last < 0 then return true end if
  if last == 0 then return true end if

  dir = decode(slice(b, 0, last))
  if dir == "" then return true end if
  return fs.isDir(dir)
end function

/// Persists exactly the requested byte prefix and returns false when validation or filesystem output fails.
/// @param name Resource or object name to resolve.
/// @param source Source value or buffer.
/// @param length Number of bytes or elements in the associated value.
function M_WriteFile(name, source, length)
  if typeof(name) != "string" then return false end if
  if typeof(source) != "bytes" then return false end if
  if typeof(length) != "int" then return false end if
  if length < 0 then return false end if
  if length > len(source) then return false end if

  data = source
  if length < len(source) then
    data = slice(source, 0, length)
  end if

  wr = fs.writeAllBytes(name, data)
  if typeof(wr) == "error" then
    return false
  end if
  return true
end function

/// Loads an entire file into an output reference, returning its byte count and routing failures through
/// I_Error.
/// @param name Resource or object name to resolve.
/// @param bufferOut Buffer out value supplied to `M_ReadFile`.
function M_ReadFile(name, bufferOut)
  if typeof(bufferOut) == "array" and len(bufferOut) > 0 then

    bufferOut[0] = bytes(0, 0)
  end if

  if typeof(name) != "string" then
    if typeof(I_Error) == "function" then I_Error("Couldn't read file <invalid>") end if
    return 0
  end if

  rd = fs.readAllBytes(name)
  if typeof(rd) == "error" then
    if typeof(I_Error) == "function" then I_Error("Couldn't read file " + name) end if
    return 0
  end if

  if typeof(bufferOut) == "array" and len(bufferOut) > 0 then
    bufferOut[0] = rd
  end if
  return len(rd)
end function

/// Chooses the next unused DOOMxx screenshot name and writes the current framebuffer as a PCX image.
function M_ScreenShot()
  linear = 0
  if typeof(screens) == "array" and len(screens) > 2 and typeof(screens[2]) == "bytes" then
    linear = screens[2]
  else
    linear = bytes(SCREENWIDTH * SCREENHEIGHT, 0)
    if typeof(screens) == "array" and len(screens) > 2 then
      screens[2] = linear
    end if
  end if

  I_ReadScreen(linear)

  lbmname = ""
  found = false
  for i = 0 to 99
    n = _M_MakeShotName(i)
    if not fs.exists(n) then
      lbmname = n
      found = true
      break
    end if
  end for

  if not found then
    if typeof(I_Error) == "function" then I_Error("M_ScreenShot: Couldn't create a PCX") end if
    return
  end if

  pal = W_CacheLumpName("PLAYPAL", PU_CACHE)
  ok = _M_WritePCXfile(lbmname, linear, SCREENWIDTH, SCREENHEIGHT, pal)
  if not ok then
    if typeof(I_Error) == "function" then I_Error("M_ScreenShot: Failed writing " + lbmname) end if
    return
  end if

  if typeof(players) == "array" and consoleplayer >= 0 and consoleplayer < len(players) then
    p = players[consoleplayer]
    if typeof(p) == "struct" then
      p.message = "screen shot"
    end if
  end if
end function

/// Restores built-in settings, parses recognized configuration keys, applies CLI multiplayer overrides, and
/// clamps the result.
function M_LoadDefaults()
  global defaultfile
  global numdefaults
  global mp_join_host
  global mp_join_port
  global mp_host_port
  global mp_host_mode
  global mp_host_skill
  global mp_host_max_players
  global mp_dm_frag_limit
  global mp_dm_time_limit

  mouseSensitivity = 5
  snd_SfxVolume = 8
  snd_MusicVolume = 8
  showMessages = 1
  global usemouse
  usemouse = 1
  global usejoystick
  usejoystick = 0
  screenblocks = 10
  detailLevel = 0
  usegamma = 0
  MP_SetPlayerName("Player")
  mp_join_host = "127.0.0.1"
  mp_join_port = MP_DEFAULT_PORT
  mp_host_port = MP_DEFAULT_PORT
  mp_host_mode = MP_MODE_COOP
  mp_host_skill = MP_SKILL_MEDIUM
  mp_host_max_players = 4
  mp_dm_frag_limit = 20
  mp_dm_time_limit = 10

  defaultfile = _M_GetDefaultFilePath()
  numdefaults = 19

  if typeof(defaultfile) == "string" and defaultfile != "" and fs.exists(defaultfile) and fs.isFile(defaultfile) then
    rdTry = try(fs.readAllLines(defaultfile))
    rd = void
    if typeof(rdTry) != "error" then rd = rdTry end if
    if typeof(rd) == "array" then
      i = 0
      while i < len(rd)
        _M_ParseDefaultLine(rd[i])
        i = i + 1
      end while
    end if
  end if

  MP_RebuildMapList()
  MP_ClampSettings()
end function

/// Serializes current input, audio, message, and multiplayer settings to the selected configuration file.
function M_SaveDefaults()
  global defaultfile
  global numdefaults

  if typeof(defaultfile) != "string" or defaultfile == "" then
    defaultfile = _M_GetDefaultFilePath()
  end if
  numdefaults = 19
  MP_ClampSettings()

  t = ""
  t = t + "mouse_sensitivity\t\t" + mouseSensitivity + "\n"
  t = t + "sfx_volume\t\t" + snd_SfxVolume + "\n"
  t = t + "music_volume\t\t" + snd_MusicVolume + "\n"
  t = t + "show_messages\t\t" + showMessages + "\n"
  t = t + "use_mouse\t\t" + usemouse + "\n"
  t = t + "use_joystick\t\t" + usejoystick + "\n"
  t = t + "screenblocks\t\t" + screenblocks + "\n"
  t = t + "detaillevel\t\t" + detailLevel + "\n"
  t = t + "brightness\t\t" + usegamma + "\n"
  t = t + "usegamma\t\t" + usegamma + "\n"
  t = t + "mp_player_name\t\t" + _M_QuoteText(MP_GetPlayerName()) + "\n"
  t = t + "mp_join_host\t\t" + _M_QuoteText(mp_join_host) + "\n"
  t = t + "mp_join_port\t\t" + mp_join_port + "\n"
  t = t + "mp_host_port\t\t" + mp_host_port + "\n"
  t = t + "mp_host_mode\t\t" + mp_host_mode + "\n"
  t = t + "mp_host_skill\t\t" + mp_host_skill + "\n"
  t = t + "mp_host_max_players\t\t" + mp_host_max_players + "\n"
  t = t + "mp_dm_frag_limit\t\t" + mp_dm_frag_limit + "\n"
  t = t + "mp_dm_time_limit\t\t" + mp_dm_time_limit + "\n"
  t = t + "mp_map_name\t\t" + _M_QuoteText(MP_GetSelectedMap()) + "\n"

  if _M_ParentDirExists(defaultfile) then
    wrTry = try(fs.writeAllText(defaultfile, t))
    if typeof(wrTry) == "error" then
      print "M_SaveDefaults: failed to write " + defaultfile
    end if
  end if
end function

/// Draws an uppercase patch-font string at logical screen coordinates and returns the x position after the
/// final glyph.
/// @param x Horizontal map- or screen-space coordinate.
/// @param y Vertical map- or screen-space coordinate.
/// @param direct Direct value supplied to `M_DrawText`.
/// @param string String value supplied to `M_DrawText`.
function M_DrawText(x, y, direct, string)
  b = 0
  if typeof(string) == "bytes" then
    b = string
  else if typeof(string) == "string" then
    b = bytes(string)
  else
    return x
  end if

  if typeof(hu_font) != "array" then return x end if

  i = 0
  while i < len(b)
    c = b[i]
    i = i + 1

    if c == 0 then break end if

    c = _M_UpperAscii(c) - HU_FONTSTART
    if c < 0 or c >= HU_FONTSIZE then
      x = x + 4
      continue
    end if

    patch = hu_font[c]
    if typeof(patch) != "bytes" then
      x = x + 4
      continue
    end if

    w = _M_patchWidth(patch)
    if x + w > SCREENWIDTH then break end if

    if direct then
      V_DrawPatchDirect(x, y, 0, patch)
    else
      V_DrawPatch(x, y, 0, patch)
    end if
    x = x + w
  end while

  return x
end function

/// Tracks the mutable usemouse value used by the m misc subsystem.
usemouse = 0
/// Tracks the mutable usejoystick value used by the m misc subsystem.
usejoystick = 0

/// Tracks the mutable numdefaults value used by the m misc subsystem.
numdefaults = 0
/// Holds the optional defaultfile resource used by the m misc subsystem.
defaultfile = void

/// Binds a configuration key to its mutable runtime reference, default value, and numeric range metadata.
struct default_t
  /// Stable resource or object name stored by `default_t`
  name
  /// Stores location for `default_t`
  location
  /// Stores defaultvalue for `default_t`
  defaultvalue
  /// Stores scantranslate for `default_t`
  scantranslate
  /// Stores untranslated for `default_t`
  untranslated
end struct

/// Stores the defaults collection used by the m misc subsystem.
defaults =[]



