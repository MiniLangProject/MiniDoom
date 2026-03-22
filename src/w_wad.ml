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

  Script: w_wad.ml
  Purpose: Implements WAD/lump lookup, caching, and resource loading helpers.
*/
import doomtype
import m_swap
import i_system
import z_zone
import w_wad
import d_main
import m_argv

import std.fs as fs
import std.math

/*
* Struct: wadinfo_t
* Purpose: Stores runtime data for wadinfo type.
*/
struct wadinfo_t
  identification
  numlumps
  infotableofs
end struct

/*
* Struct: filelump_t
* Purpose: Stores runtime data for filelump type.
*/
struct filelump_t
  filepos
  size
  name
end struct

/*
* Struct: lumpinfo_t
* Purpose: Stores runtime data for lumpinfo type.
*/
struct lumpinfo_t
  name
  handle
  position
  size
end struct

lumpcache = void
lumpinfo = void
numlumps = 0
const _W_CACHE_NULL_PTR = -1

/*
* Struct: wadfile_t
* Purpose: Stores runtime data for wadfile type.
*/
struct wadfile_t
  path
  data
end struct

_W_files =[]
reloadname = void
reloadlump = 0
reloadfile = -1

/*
* Function: _W_ReadI32LE
* Purpose: Implements the _W_ReadI32LE routine for the internal module support.
*/
function inline _W_ReadI32LE(b, off)

  return (b[off] |(b[off + 1] << 8) |(b[off + 2] << 16) |(b[off + 3] << 24))
end function

/*
* Function: _W_CopyBytes
* Purpose: Implements the _W_CopyBytes routine for the internal module support.
*/
function inline _W_CopyBytes(b, off, n)

  return slice(b, off, n)
end function

/*
* Function: _W_ToUpperAscii
* Purpose: Implements the _W_ToUpperAscii routine for the internal module support.
*/
function inline _W_ToUpperAscii(s)

  b = bytes(s)
  for i = 0 to len(b) - 1
    c = b[i]
    if c >= 97 and c <= 122 then
      b[i] = c - 32
    end if
  end for
  return decode(b)
end function

/*
* Function: strupr
* Purpose: Implements the strupr routine for the engine module behavior.
*/
function inline strupr(s)
  return _W_ToUpperAscii(s)
end function

/*
* Function: filelength
* Purpose: Implements the filelength routine for the engine module behavior.
*/
function inline filelength(handle)
  if typeof(handle) != "int" then return 0 end if
  if handle < 0 or handle >= len(_W_files) then return 0 end if
  d = _W_files[handle].data
  if typeof(d) != "bytes" then return 0 end if
  return len(d)
end function

/*
* Function: _W_Name8FromString
* Purpose: Implements the _W_Name8FromString routine for the internal module support.
*/
function inline _W_Name8FromString(name)

  outBytes = bytes(8, 0)
  up = _W_ToUpperAscii(name)
  nb = bytes(up)
  n = len(nb)
  if n > 8 then n = 8 end if
  for i = 0 to n - 1
    outBytes[i] = nb[i]
  end for
  return outBytes
end function

/*
* Function: _W_Name8Equals
* Purpose: Implements the _W_Name8Equals routine for the internal module support.
*/
function inline _W_Name8Equals(a, b)

  for i = 0 to 7
    if a[i] != b[i] then return false end if
  end for
  return true
end function

/*
* Function: _W_IsWadFilename
* Purpose: Implements the _W_IsWadFilename routine for the internal module support.
*/
function inline _W_IsWadFilename(path)
  pb = bytes(path)
  if len(pb) < 3 then return false end if

  a = pb[len(pb) -3]
  b = pb[len(pb) -2]
  c = pb[len(pb) -1]

  if a >= 97 and a <= 122 then a = a - 32 end if
  if b >= 97 and b <= 122 then b = b - 32 end if
  if c >= 97 and c <= 122 then c = c - 32 end if
  return (a == 87 and b == 65 and c == 68)
end function

/*
* Function: _W_ExtractFileBase
* Purpose: Implements the _W_ExtractFileBase routine for the internal module support.
*/
function _W_ExtractFileBase(path)

  pb = bytes(path)
  start = 0
  for i = 0 to len(pb) - 1
    if pb[i] == 47 or pb[i] == 92 then
      start = i + 1
    end if
  end for

  outBytes = bytes(8, 0)
  count = 0
  i = start
  while i < len(pb) and pb[i] != 46
    count = count + 1
    if count == 9 then
      I_Error("Filename base of " + path + " >8 chars")
      return outBytes
    end if
    c = pb[i]
    if c >= 97 and c <= 122 then c = c - 32 end if
    outBytes[count - 1] = c
    i = i + 1
  end while
  return outBytes
end function

/*
* Function: ExtractFileBase
* Purpose: Implements the ExtractFileBase routine for the engine module behavior.
*/
function ExtractFileBase(path, dest)
  name8 = _W_ExtractFileBase(path)

  if typeof(dest) == "bytes" then
    n = len(dest)
    if n > 8 then n = 8 end if
    i = 0
    while i < n
      dest[i] = name8[i]
      i = i + 1
    end while
    return dest
  end if

  if typeof(dest) == "array" and len(dest) > 0 then
    dest[0] = name8
  end if

  return name8
end function

/*
* Function: _W_ToPathString
* Purpose: Implements the _W_ToPathString routine for the internal module support.
*/
function inline _W_ToPathString(v)
  if typeof(v) == "string" then
    return v
  end if
  if typeof(v) == "bytes" then
    return decodeZ(v)
  end if
  return ""
end function

/*
* Function: _W_ToIntOr
* Purpose: Implements the _W_ToIntOr routine for the internal module support.
*/
function _W_ToIntOr(v, fallback)
  if typeof(v) == "int" then
    return v
  end if
  if typeof(v) == "float" then
    if v >= 0 then
      return std.math.floor(v)
    end if
    return std.math.ceil(v)
  end if
  n = toNumber(v)
  if typeof(n) == "int" then
    return n
  end if
  if typeof(n) == "float" then
    if n >= 0 then
      return std.math.floor(n)
    end if
    return std.math.ceil(n)
  end if
  return fallback
end function

/*
* Function: _W_SlotEmpty
* Purpose: Implements the _W_SlotEmpty routine for the internal module support.
*/
function inline _W_SlotEmpty(slot)
  if typeof(slot) != "array" or len(slot) == 0 then
    return true
  end if
  v = slot[0]
  if typeof(v) == "void" then return true end if
  if typeof(v) == "int" and v < 0 then return true end if
  return false
end function

/*
* Function: _W_AddLoadedFile
* Purpose: Loads and prepares data required by the internal module support.
*/
function inline _W_AddLoadedFile(path, data)
  global _W_files

  _W_files = _W_files +[wadfile_t(path, data)]
  return len(_W_files) - 1
end function

/*
* Function: W_AddFile
* Purpose: Implements the W_AddFile routine for the WAD resource system.
*/
function W_AddFile(filename)
  global reloadname
  global reloadlump
  global reloadfile
  global lumpinfo
  global numlumps

  filename = _W_ToPathString(filename)
  if len(filename) == 0 then
    return
  end if

  fb = bytes(filename)
  if len(fb) > 0 and fb[0] == 126 then

    if len(fb) > 1 then
      filename = decode(slice(fb, 1, len(fb) - 1))
    else
      filename = ""
    end if
    reloadname = filename
    reloadlump = numlumps
  end if

  dataTry = try(fs.readAllBytes(filename))
  if typeof(dataTry) == "error" then
    print " couldn't open " + filename
    return
  end if
  data = dataTry
  if typeof(data) != "bytes" then
    print " couldn't open " + filename
    return
  end if
  fileIdx = _W_AddLoadedFile(filename, data)

  if typeof(reloadname) != "void" and reloadname == filename then
    reloadfile = fileIdx
  end if

  print " adding " + filename

  startlump = numlumps

  if typeof(lumpinfo) != "array" then lumpinfo =[] end if

  if not _W_IsWadFilename(filename) then

    name8 = _W_ExtractFileBase(filename)
    lumpinfo = lumpinfo +[lumpinfo_t(name8, fileIdx, 0, len(data))]
    numlumps = numlumps + 1
    return
  end if

  if len(data) < 12 then
    I_Error("W_AddFile: " + filename + " too small to be a WAD")
    return
  end if

  ident = _W_CopyBytes(data, 0, 4)
  idStr = decode(ident)
  if idStr != "IWAD" and idStr != "PWAD" then
    I_Error("Wad file " + filename + " doesn't have IWAD or PWAD id")
    return
  end if

  lumpcount = _W_ReadI32LE(data, 4)
  infotableofs = _W_ReadI32LE(data, 8)

  if infotableofs < 0 or infotableofs + lumpcount * 16 > len(data) then
    I_Error("W_AddFile: invalid directory for " + filename)
    return
  end if

  for i = 0 to lumpcount - 1
    off = infotableofs + i * 16
    filepos = _W_ReadI32LE(data, off + 0)
    size = _W_ReadI32LE(data, off + 4)
    name8 = _W_CopyBytes(data, off + 8, 8)
    lumpinfo = lumpinfo +[lumpinfo_t(name8, fileIdx, filepos, size)]
    numlumps = numlumps + 1
  end for
end function

/*
* Function: _W_AddFilesFromArgv
* Purpose: Implements the _W_AddFilesFromArgv routine for the internal module support.
*/
function _W_AddFilesFromArgv()
  if typeof(myargv) != "array" or typeof(myargc) != "int" then
    return
  end if

  i = 1
  while i < myargc
    a = _W_ToPathString(myargv[i])
    if len(a) == 0 then
      i = i + 1
      continue
    end if

    if a == "-iwad" and i < myargc - 1 then
      f = _W_ToPathString(myargv[i + 1])
      if len(f) > 0 then
        W_AddFile(f)
      end if
      i = i + 2
      continue
    end if

    if a == "-file" then
      j = i + 1
      while j < myargc
        f = _W_ToPathString(myargv[j])
        if len(f) == 0 then
          j = j + 1
          continue
        end if
        if bytes(f)[0] == 45 then
          break
        end if
        W_AddFile(f)
        j = j + 1
      end while
      i = j
      continue
    end if

    i = i + 1
  end while
end function

/*
* Function: W_InitMultipleFiles
* Purpose: Initializes state and dependencies for the WAD resource system.
*/
function W_InitMultipleFiles(filenames)
  global numlumps
  global lumpinfo
  global lumpcache
  global _W_files
  global reloadname
  global reloadlump
  global reloadfile

  numlumps = 0
  lumpinfo =[]
  lumpcache = void
  _W_files =[]
  reloadname = void
  reloadlump = 0
  reloadfile = -1

  if typeof(filenames) != "array" then
    if typeof(filenames) == "string" and len(filenames) > 0 then
      filenames =[filenames]
    else if typeof(wadfiles) == "array" then
      filenames = wadfiles
    else
      filenames =[]
    end if
  end if

  if typeof(filenames) != "array" then
    I_Error("W_InitMultipleFiles: filenames must be array")
    return
  end if

  for each f in filenames
    if typeof(f) == "string" and len(f) > 0 then
      W_AddFile(f)
    end if
  end for

  if numlumps == 0 then

    _W_AddFilesFromArgv()
  end if
  if numlumps == 0 then
    W_AddFile("Doom1.wad")
  end if
  if numlumps == 0 then
    W_AddFile("doom.wad")
  end if
  if numlumps == 0 then
    I_Error("W_InitFiles: no files found")
    return
  end if

  lumpcache =[]
  for i = 0 to numlumps - 1
    lumpcache = lumpcache +[[_W_CACHE_NULL_PTR]]
  end for
end function

/*
* Function: W_InitFile
* Purpose: Initializes state and dependencies for the WAD resource system.
*/
function W_InitFile(filename)
  W_InitMultipleFiles([filename])
end function

/*
* Function: W_NumLumps
* Purpose: Implements the W_NumLumps routine for the WAD resource system.
*/
function W_NumLumps()
  return numlumps
end function

/*
* Function: W_Reload
* Purpose: Loads and prepares data required by the WAD resource system.
*/
function W_Reload()
  global _W_files

  if typeof(reloadname) == "void" or reloadfile < 0 then
    return
  end if

  dataTry = try(fs.readAllBytes(reloadname))
  if typeof(dataTry) == "error" then
    I_Error("W_Reload: couldn't open " + reloadname)
    return
  end if
  data = dataTry
  if typeof(data) != "bytes" then
    I_Error("W_Reload: couldn't open " + reloadname)
    return
  end if

  _W_files[reloadfile].data = data

  if len(data) < 12 then
    I_Error("W_Reload: file too small")
    return
  end if

  lumpcount = _W_ReadI32LE(data, 4)
  infotableofs = _W_ReadI32LE(data, 8)

  if infotableofs < 0 or infotableofs + lumpcount * 16 > len(data) then
    I_Error("W_Reload: invalid directory")
    return
  end if

  for i = 0 to lumpcount - 1
    lump = reloadlump + i
    off = infotableofs + i * 16

    if lump < 0 or lump >= numlumps then
      break
    end if

    if typeof(lumpcache) == "array" then
      slot = lumpcache[lump]
      if not _W_SlotEmpty(slot) then
        Z_Free(slot[0])
        slot[0] = _W_CACHE_NULL_PTR
      end if
    end if

    l = lumpinfo[lump]
    l.position = _W_ReadI32LE(data, off + 0)
    l.size = _W_ReadI32LE(data, off + 4)
    lumpinfo[lump] = l
  end for
end function

/*
* Function: W_CheckNumForName
* Purpose: Evaluates conditions and returns a decision for the WAD resource system.
*/
function W_CheckNumForName(name)
  name8 = _W_Name8FromString(name)

  i = numlumps - 1
  while i >= 0
    if _W_Name8Equals(lumpinfo[i].name, name8) then
      return i
    end if
    i = i - 1
  end while

  return -1
end function

/*
* Function: W_GetNumForName
* Purpose: Reads or updates state used by the WAD resource system.
*/
function W_GetNumForName(name)
  i = W_CheckNumForName(name)
  if i == -1 then
    I_Error("W_GetNumForName: " + name + " not found!")
  end if
  return i
end function

/*
* Function: W_LumpLength
* Purpose: Implements the W_LumpLength routine for the WAD resource system.
*/
function W_LumpLength(lump)
  lump = _W_ToIntOr(lump, -1)
  if lump < 0 or lump >= numlumps then
    I_Error("W_LumpLength: " + lump + " >= numlumps")
    return 0
  end if
  return lumpinfo[lump].size
end function

/*
* Function: W_ReadLump
* Purpose: Implements the W_ReadLump routine for the WAD resource system.
*/
function W_ReadLump(lump, dest)
  lump = _W_ToIntOr(lump, -1)
  if lump < 0 or lump >= numlumps then
    I_Error("W_ReadLump: " + lump + " >= numlumps")
    return
  end if

  l = lumpinfo[lump]
  fileIdx = l.handle
  if fileIdx < 0 or fileIdx >= len(_W_files) then
    I_Error("W_ReadLump: invalid file index")
    return
  end if

  data = _W_files[fileIdx].data
  if typeof(data) != "bytes" then
    I_Error("W_ReadLump: file data missing")
    return
  end if

  if typeof(dest) == "int" then
    Z_PokeBytes(dest, data, l.position, l.size)
    return
  end if

  if typeof(dest) == "bytes" then
    for i = 0 to l.size - 1
      dest[i] = data[l.position + i]
    end for
    return
  end if

  I_Error("W_ReadLump: dest must be int (zone ptr) or bytes")
end function

/*
* Function: W_CacheLumpNum
* Purpose: Retrieves and caches data for the WAD resource system.
*/
function W_CacheLumpNum(lump, tag)
  lump = _W_ToIntOr(lump, -1)
  tag = _W_ToIntOr(tag, 0)

  if lump < 0 or lump >= numlumps then
    I_Error("W_CacheLumpNum: " + lump + " >= numlumps")
    return void
  end if

  slot = lumpcache[lump]
  if _W_SlotEmpty(slot) then

    if typeof(slot) != "array" or len(slot) == 0 then
      slot =[_W_CACHE_NULL_PTR]
      lumpcache[lump] = slot
    end if
    ptr = Z_Malloc(W_LumpLength(lump), tag, slot)
    W_ReadLump(lump, slot[0])
  else

    Z_ChangeTag(slot[0], tag)
  end if

  return Z_BytesAt(slot[0], W_LumpLength(lump))
end function

/*
* Function: W_GetCachedLumpPtr
* Purpose: Retrieves and caches data for the WAD resource system.
*/
function W_GetCachedLumpPtr(lump)
  lump = _W_ToIntOr(lump, -1)
  if lump < 0 or lump >= numlumps then
    return _W_CACHE_NULL_PTR
  end if
  if typeof(lumpcache) != "array" then
    return _W_CACHE_NULL_PTR
  end if
  slot = lumpcache[lump]
  if _W_SlotEmpty(slot) then
    return _W_CACHE_NULL_PTR
  end if
  ptr = slot[0]
  if typeof(ptr) != "int" then
    return _W_CACHE_NULL_PTR
  end if
  return ptr
end function

/*
* Function: W_CacheLumpName
* Purpose: Retrieves and caches data for the WAD resource system.
*/
function W_CacheLumpName(name, tag)
  return W_CacheLumpNum(W_GetNumForName(name), tag)
end function

_W_profile_info =[]
_W_profile_count = 0

/*
* Function: W_Profile
* Purpose: Implements the W_Profile routine for the WAD resource system.
*/
function W_Profile()
  global _W_profile_info
  global _W_profile_count

  if typeof(_W_profile_info) != "array" or len(_W_profile_info) != numlumps then
    _W_profile_info =[]
    i = 0
    while i < numlumps
      _W_profile_info = _W_profile_info +[[]]
      i = i + 1
    end while
    _W_profile_count = 0
  end if

  i = 0
  while i < numlumps
    ch = " "
    slot = lumpcache[i]
    if not _W_SlotEmpty(slot) then
      ch = "S"
    end if
    _W_profile_info[i] = _W_profile_info[i] +[ch]
    i = i + 1
  end while
  _W_profile_count = _W_profile_count + 1

  text = ""
  i = 0
  while i < numlumps
    nm = decodeZ(lumpinfo[i].name)
    while len(nm) < 8
      nm = nm + " "
    end while
    line = nm + " "
    j = 0
    while j < len(_W_profile_info[i])
      line = line + "    " + _W_profile_info[i][j]
      j = j + 1
    end while
    text = text + line + "\n"
    i = i + 1
  end while

  fs.writeAllBytes("waddump.txt", bytes(text))
end function



