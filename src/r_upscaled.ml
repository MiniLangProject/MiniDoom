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

  Script: r_upscaled.ml
  Purpose: Loads optional MiniDoom upscaled graphics packages and shared render-scale settings.
*/
import m_argv
import std.fs as fs
import std.math

const RU_MAGIC0 = 77
const RU_MAGIC1 = 68
const RU_MAGIC2 = 85
const RU_MAGIC3 = 80
const RH_MAGIC2 = 72
const RH_MAGIC3 = 68
const RU_VERSION = 6

const RU_TYPE_PATCH = 1
const RU_TYPE_FLAT = 2
const RU_TYPE_TEXTURE = 3
const RU_TYPE_SPRITE = 4

/*
* Struct: ru_entry_t
* Purpose: Describes one image stored in an upscaled package.
*/
struct ru_entry_t
  kind
  name
  width
  height
  xoffset
  yoffset
  flags
  data
end struct

ru_enabled = false
ru_loaded = false
ru_path = ""
ru_scale = 1
ru_entries =[]

/*
* Function: RU_ReadU32
* Purpose: Reads a little-endian u32 from package bytes.
*/
function inline RU_ReadU32(b, off)
  return b[off] +(b[off + 1] << 8) +(b[off + 2] << 16) +(b[off + 3] << 24)
end function

/*
* Function: RU_ReadS32
* Purpose: Reads a little-endian s32 from package bytes.
*/
function inline RU_ReadS32(b, off)
  v = RU_ReadU32(b, off)
  if v >= 2147483648 then v = v - 4294967296 end if
  return v
end function

/*
* Function: RU_ToIntOr
* Purpose: Converts a MiniLang value to int with fallback.
*/
function RU_ToIntOr(v, fallback)
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
* Function: RU_ClampScale
* Purpose: Keeps renderer scale inside the supported range.
*/
function inline RU_ClampScale(v)
  s = RU_ToIntOr(v, 1)
  if s < 1 then s = 1 end if
  if s > 4 then s = 4 end if
  return s
end function

/*
* Function: RU_ToUpperAscii
* Purpose: Converts a string to uppercase ASCII for WAD-style names.
*/
function RU_ToUpperAscii(s)
  if typeof(s) != "string" then return "" end if
  b = bytes(s)
  i = 0
  while i < len(b)
    c = b[i]
    if c >= 97 and c <= 122 then b[i] = c - 32 end if
    i = i + 1
  end while
  return decode(b)
end function

/*
* Function: RU_Name8
* Purpose: Normalizes names to Doom's 8-character lump namespace.
*/
function RU_Name8(name)
  s = name
  if typeof(s) == "bytes" then s = decodeZ(s) end if
  if typeof(s) != "string" then return "" end if
  up = RU_ToUpperAscii(s)
  b = bytes(up)
  outName = bytes(8, 0)
  n = len(b)
  if n > 8 then n = 8 end if
  i = 0
  while i < n
    if b[i] == 0 then break end if
    outName[i] = b[i]
    i = i + 1
  end while
  return decodeZ(outName)
end function

/*
* Function: RU_ArgValue
* Purpose: Reads the value after a command-line flag.
*/
function RU_ArgValue(flag)
  if typeof(M_CheckParm) != "function" then return "" end if
  p = M_CheckParm(flag)
  if p == 0 or p >= myargc - 1 then return "" end if
  v = myargv[p + 1]
  if typeof(v) != "string" then return "" end if
  return v
end function

/*
* Function: RU_ParseScaleFromArgs
* Purpose: Initializes the requested physical render scale.
*/
function RU_ParseScaleFromArgs()
  global ru_scale

  ru_scale = 1
  if typeof(M_CheckParm) == "function" then
    if M_CheckParm("-opengl") != 0 or M_CheckParm("--opengl") != 0 or M_CheckParm("-gl") != 0 or M_CheckParm("--gl") != 0 then
      ru_scale = 3
    end if
  end if
end function

/*
* Function: RU_FindPackagePath
* Purpose: Resolves explicit or automatic upscaled package path.
*/
function RU_FindPackagePath(iwadPath)
  p = RU_ArgValue("-hdwad")
  if p == "" then p = RU_ArgValue("--hdwad") end if
  if p != "" then return p end if

  p = RU_ArgValue("-upscaled")
  if p == "" then p = RU_ArgValue("--upscaled") end if
  if p != "" then return p end if

  if typeof(iwadPath) == "string" and iwadPath != "" then
    ib = bytes(iwadPath)
    if len(ib) >= 6 then
      tail = decode(slice(ib, len(ib) - 6, 6))
      if tail == ".hdwad" or tail == ".HDWAD" then
        if fs.exists(iwadPath) and fs.isFile(iwadPath) then return iwadPath end if
      end if
    end if
    auto = iwadPath + ".hdwad"
    if fs.exists(auto) and fs.isFile(auto) then return auto end if
    auto = iwadPath + ".upscaled"
    if fs.exists(auto) and fs.isFile(auto) then return auto end if
  end if

  return ""
end function

/*
* Function: RU_ParsePackage
* Purpose: Parses MiniDoom upscaled package bytes.
*/
function RU_ParsePackage(data)
  global ru_entries
  global ru_scale

  ru_entries =[]
  if typeof(data) != "bytes" or len(data) < 20 then return false end if
  if data[0] != RU_MAGIC0 or data[1] != RU_MAGIC1 then return false end if
  isHDWAD = false
  if data[2] == RH_MAGIC2 and data[3] == RH_MAGIC3 then
    isHDWAD = true
    if len(data) < 28 then return false end if
  else if data[2] == RU_MAGIC2 and data[3] == RU_MAGIC3 then
    isHDWAD = false
  else
    return false
  end if

  version = RU_ReadU32(data, 4)
  if version != RU_VERSION then return false end if

  pkgScale = RU_ClampScale(RU_ReadU32(data, 8))
  count = 0
  dirOfs = 0
  if isHDWAD then
    count = RU_ReadU32(data, 16)
    dirOfs = RU_ReadU32(data, 24)
  else
    count = RU_ReadU32(data, 12)
    dirOfs = RU_ReadU32(data, 16)
  end if
  if count < 0 or dirOfs < 20 then return false end if
  if dirOfs + count * 40 > len(data) then return false end if

  if ru_scale <= 1 then ru_scale = pkgScale end if

  i = 0
  while i < count
    off = dirOfs + i * 40
    kind = RU_ReadU32(data, off + 0)
    name = RU_Name8(slice(data, off + 4, 8))
    width = RU_ReadU32(data, off + 12)
    height = RU_ReadU32(data, off + 16)
    xoffset = RU_ReadS32(data, off + 20)
    yoffset = RU_ReadS32(data, off + 24)
    flags = RU_ReadU32(data, off + 28)
    dataOfs = RU_ReadU32(data, off + 32)
    dataSize = RU_ReadU32(data, off + 36)

    if width > 0 and height > 0 and dataOfs >= 0 and dataSize >= 0 and dataOfs + dataSize <= len(data) then
      pixels = slice(data, dataOfs, dataSize)
      ru_entries = ru_entries +[ru_entry_t(kind, name, width, height, xoffset, yoffset, flags, pixels)]
    end if
    i = i + 1
  end while

  return true
end function

/*
* Function: RU_LoadPackage
* Purpose: Loads an upscaled package from disk.
*/
function RU_LoadPackage(path)
  global ru_loaded
  global ru_enabled
  global ru_path

  ru_loaded = false
  ru_enabled = false
  ru_path = ""

  if typeof(path) != "string" or path == "" then return false end if
  if not fs.exists(path) or not fs.isFile(path) then return false end if

  dataTry = try(fs.readAllBytes(path))
  if typeof(dataTry) == "error" then
    print "R_Upscaled: could not read " + path
    return false
  end if

  if RU_ParsePackage(dataTry) then
    ru_loaded = true
    ru_enabled = true
    ru_path = path
    print "R_Upscaled: loaded " + path + " (" + len(ru_entries) + " images, scale " + ru_scale + "x)"
    return true
  end if

  print "R_Upscaled: invalid package " + path
  return false
end function

/*
* Function: RU_Init
* Purpose: Initializes optional upscaled graphics support.
*/
function RU_Init(iwadPath)
  RU_ParseScaleFromArgs()
  path = RU_FindPackagePath(iwadPath)
  if path != "" then
    RU_LoadPackage(path)
  else if ru_scale > 1 then
    print "R_Upscaled: render scale " + ru_scale + "x enabled without package"
  end if
end function

/*
* Function: RU_RenderScale
* Purpose: Returns the physical render scale requested for this run.
*/
function inline RU_RenderScale()
  return ru_scale
end function

/*
* Function: RU_IsEnabled
* Purpose: Returns true when a package is active.
*/
function inline RU_IsEnabled()
  return ru_enabled
end function

/*
* Function: RU_FindEntry
* Purpose: Finds an entry by kind and Doom name.
*/
function RU_FindEntry(kind, name)
  if not ru_enabled then return void end if
  n = RU_Name8(name)
  i = 0
  while i < len(ru_entries)
    e = ru_entries[i]
    if e is not void and e.kind == kind and e.name == n then return e end if
    i = i + 1
  end while
  return void
end function

/*
* Function: RU_GetFlat
* Purpose: Returns an upscaled flat image entry or void.
*/
function inline RU_GetFlat(name)
  return RU_FindEntry(RU_TYPE_FLAT, name)
end function

/*
* Function: RU_GetTexture
* Purpose: Returns an upscaled wall texture image entry or void.
*/
function inline RU_GetTexture(name)
  return RU_FindEntry(RU_TYPE_TEXTURE, name)
end function

/*
* Function: RU_GetPatch
* Purpose: Returns an upscaled patch image entry or void.
*/
function inline RU_GetPatch(name)
  return RU_FindEntry(RU_TYPE_PATCH, name)
end function

/*
* Function: RU_GetSprite
* Purpose: Returns an upscaled sprite image entry or void.
*/
function inline RU_GetSprite(name)
  return RU_FindEntry(RU_TYPE_SPRITE, name)
end function
