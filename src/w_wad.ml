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

//! Implements WAD/lump lookup, caching, and resource loading helpers.

import doomtype
import m_swap
import i_system
import z_zone
import w_wad
import d_main
import m_argv

import std.fs as fs
import std.math

/// Defines the minimum w hdwad min version accepted by the w wad subsystem.
const W_HDWAD_MIN_VERSION = 1
/// Defines the maximum w hdwad max version accepted by the w wad subsystem.
const W_HDWAD_MAX_VERSION = 6

/// Mirrors a WAD header's identification, directory count, and directory byte offset.
struct wadinfo_t
  /// Stores identification for `wadinfo_t`
  identification
  /// Stores numlumps for `wadinfo_t`
  numlumps
  /// Stores infotableofs for `wadinfo_t`
  infotableofs
end struct

/// Mirrors one on-disk WAD directory entry with file position, byte size, and fixed eight-byte name.
struct filelump_t
  /// Stores filepos for `filelump_t`
  filepos
  /// Stores size for `filelump_t`
  size
  /// Stable resource or object name stored by `filelump_t`
  name
end struct

/// Records a merged lump's canonical name, source-file handle, byte position, and size.
struct lumpinfo_t
  /// Stable resource or object name stored by `lumpinfo_t`
  name
  /// Stores handle for `lumpinfo_t`
  handle
  /// Stores position for `lumpinfo_t`
  position
  /// Stores size for `lumpinfo_t`
  size
end struct

/// Holds the optional lumpcache resource used by the w wad subsystem.
lumpcache = void
/// Holds the optional lumpinfo resource used by the w wad subsystem.
lumpinfo = void
/// Tracks the mutable numlumps value used by the w wad subsystem.
numlumps = 0
/// Stores the wad cached patch bytes collection used by the w wad subsystem.
wad_cached_patch_bytes =[]
/// Stores the wad cached patch names collection used by the w wad subsystem.
wad_cached_patch_names =[]
/// Holds the optional wad cached patch last data resource used by the w wad subsystem.
wad_cached_patch_last_data = void
/// Stores the mutable wad cached patch last name text used by the w wad subsystem.
wad_cached_patch_last_name = ""
/// Defines w cache null ptr for the w wad subsystem.
/// @internal
const _W_CACHE_NULL_PTR = -1

/// Owns one loaded WAD path and its immutable file bytes for indexed lump reads.
struct wadfile_t
  /// Stores path for `wadfile_t`
  path
  /// Payload owned or referenced by this record stored by `wadfile_t`
  data
end struct

/// Stores the w files collection used by the w wad subsystem.
/// @internal
_W_files =[]
/// Holds the optional reloadname resource used by the w wad subsystem.
reloadname = void
/// Tracks the mutable reloadlump value used by the w wad subsystem.
reloadlump = 0
/// Tracks the mutable reloadfile value used by the w wad subsystem.
reloadfile = -1

/// Decodes one signed 32-bit little-endian field from a WAD header or directory entry.
/// @param b Second input operand.
/// @param off Zero-based byte or element offset.
/// @internal
function inline _W_ReadI32LE(b, off)

  return (b[off] |(b[off + 1] << 8) |(b[off + 2] << 16) |(b[off + 3] << 24))
end function

/// Returns an independent byte slice for a requested WAD-file range.
/// @param b Second input operand.
/// @param off Zero-based byte or element offset.
/// @param n Number of values to process.
/// @internal
function inline _W_CopyBytes(b, off, n)

  return slice(b, off, n)
end function

/// Uppercases ASCII lump-name characters in a newly allocated string while preserving nonletters.
/// @param s S value supplied to `_W_ToUpperAscii`.
/// @internal
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

/// Exposes allocation-safe ASCII uppercase conversion under the legacy WAD API name.
/// @param s S value supplied to `strupr`.
function inline strupr(s)
  return _W_ToUpperAscii(s)
end function

/// Returns the byte length of a validated loaded-file handle.
/// @param handle Handle value supplied to `filelength`.
function inline filelength(handle)
  if typeof(handle) != "int" then return 0 end if
  if handle < 0 or handle >= len(_W_files) then return 0 end if
  d = _W_files[handle].data
  if typeof(d) != "bytes" then return 0 end if
  return len(d)
end function

/// Uppercases, truncates, and zero-pads a string to Doom's fixed eight-byte lump-name representation.
/// @param name Resource or object name to resolve.
/// @internal
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

/// Converts an internal eight-byte lump name to a safe display string.
/// @param name Resource or object name to resolve.
/// @internal
function _W_Name8ToString(name)
  if typeof(name) == "string" then return name end if
  if typeof(name) != "bytes" then return "" end if
  n = len(name)
  if n > 8 then n = 8 end if
  outBytes = bytes(n, 0)
  i = 0
  while i < n
    c = name[i]
    if c == 0 then break end if
    outBytes[i] = c
    i = i + 1
  end while
  if i <= 0 then return "" end if
  return decode(slice(outBytes, 0, i))
end function

/// Compares two canonical eight-byte lump names without string allocation.
/// @param a First input operand.
/// @param b Second input operand.
/// @internal
function inline _W_Name8Equals(a, b)

  for i = 0 to 7
    if a[i] != b[i] then return false end if
  end for
  return true
end function

/// Recognizes a case-insensitive .wad suffix without allocating a normalized path copy.
/// @param path Filesystem path to process.
/// @internal
function inline _W_IsWadFilename(path)
  pb = bytes(path)
  if len(pb) < 4 then return false end if

  dot = pb[len(pb) -4]
  a = pb[len(pb) -3]
  b = pb[len(pb) -2]
  c = pb[len(pb) -1]

  if dot >= 97 and dot <= 122 then dot = dot - 32 end if
  if a >= 97 and a <= 122 then a = a - 32 end if
  if b >= 97 and b <= 122 then b = b - 32 end if
  if c >= 97 and c <= 122 then c = c - 32 end if
  return (dot == 46 and a == 87 and b == 65 and c == 68)
end function

/// Validates the minimum header length and four-byte MDHD signature of an in-memory HDWAD package.
/// @param data Binary or structured data to process.
/// @internal
function inline _W_IsHDWADData(data)
  if typeof(data) != "bytes" or len(data) < 28 then return false end if
  return data[0] == 77 and data[1] == 68 and data[2] == 72 and data[3] == 68
end function

/// Extracts an uppercase, extension-free filename into an eight-byte lump name and rejects overlong bases.
/// @param path Filesystem path to process.
/// @internal
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

/// Copies a canonical filename base into a byte buffer or reference slot for compatibility with the original
/// API.
/// @param path Filesystem path to process.
/// @param dest Dest value supplied to `ExtractFileBase`.
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

/// Converts path string values for the WAD resource.
/// @param v Value consumed by the operation.
/// @internal
function inline _W_ToPathString(v)
  if typeof(v) == "string" then
    return v
  end if
  if typeof(v) == "bytes" then
    return decodeZ(v)
  end if
  return ""
end function

/// Formats integer values for WAD diagnostics without implicit stringification.
/// @param v Value consumed by the operation.
/// @internal
function _W_IntToString(v)
  n = _W_ToIntOr(v, 0)
  if n == 0 then return "0" end if
  neg = false
  if n < 0 then
    neg = true
    n = -n
  end if
  txt = ""
  while n > 0
    d = n % 10
    ch = "0"
    if d == 1 then ch = "1"
    else if d == 2 then ch = "2"
    else if d == 3 then ch = "3"
    else if d == 4 then ch = "4"
    else if d == 5 then ch = "5"
    else if d == 6 then ch = "6"
    else if d == 7 then ch = "7"
    else if d == 8 then ch = "8"
    else if d == 9 then ch = "9"
    end if
    txt = ch + txt
    n = std.math.floor(n / 10)
  end while
  if neg then txt = "-" + txt end if
  return txt
end function

/// Converts int or values for the WAD resource.
/// @param v Value consumed by the operation.
/// @param fallback Value returned when the requested conversion or lookup is unavailable.
/// @internal
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
  if typeof(v) != "string" then return fallback end if
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

/// Tests the cache-slot convention in which empty, void, or negative pointer values mean no resident lump.
/// @param slot Slot value supplied to `_W_SlotEmpty`.
/// @internal
function inline _W_SlotEmpty(slot)
  if typeof(slot) != "array" or len(slot) == 0 then
    return true
  end if
  v = slot[0]
  if typeof(v) == "void" then return true end if
  if typeof(v) == "int" and v < 0 then return true end if
  return false
end function

/// Appends an in-memory WAD file record and returns the stable index stored by its lump directory entries.
/// @param path Filesystem path to process.
/// @param data Binary or structured data to process.
/// @internal
function inline _W_AddLoadedFile(path, data)
  global _W_files

  _W_files = _W_files +[wadfile_t(path, data)]
  return len(_W_files) - 1
end function

/// Loads a WAD or single-lump file, validates its directory, and appends normalized entries in load-order
/// override precedence.
/// @param filename Filesystem name of the target resource.
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

  if _W_IsHDWADData(data) then
    version = _W_ReadI32LE(data, 4)
    if version < W_HDWAD_MIN_VERSION or version > W_HDWAD_MAX_VERSION then
      I_Error("HDWAD file " + filename + " has unsupported version")
      return
    end if
    lumpcount = _W_ReadI32LE(data, 12)
    lumpDirOfs = _W_ReadI32LE(data, 20)
    if lumpcount < 0 or lumpDirOfs < 28 or lumpDirOfs + lumpcount * 16 > len(data) then
      I_Error("W_AddFile: invalid HDWAD directory for " + filename)
      return
    end if

    i = 0
    while i < lumpcount
      off = lumpDirOfs + i * 16
      filepos = _W_ReadI32LE(data, off + 0)
      size = _W_ReadI32LE(data, off + 4)
      name8 = _W_CopyBytes(data, off + 8, 8)
      if size < 0 or filepos < 0 or filepos + size > len(data) then
        I_Error("W_AddFile: invalid HDWAD lump in " + filename)
        return
      end if
      lumpinfo = lumpinfo +[lumpinfo_t(name8, fileIdx, filepos, size)]
      numlumps = numlumps + 1
      i = i + 1
    end while
    return
  end if

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

/// Adds files from argument entries to the WAD resource.
/// @internal
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

    if (a == "-hdwad" or a == "--hdwad") and i < myargc - 1 then
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

/// Clears prior resource state, loads each configured WAD in order, validates the result, and creates empty
/// zone-cache slots.
/// @param filenames Filenames value supplied to `W_InitMultipleFiles`.
function W_InitMultipleFiles(filenames)
  global numlumps
  global lumpinfo
  global lumpcache
  global _W_files
  global reloadname
  global reloadlump
  global reloadfile
  global wad_cached_patch_bytes
  global wad_cached_patch_names

  numlumps = 0
  lumpinfo =[]
  lumpcache = void
  _W_files =[]
  reloadname = void
  reloadlump = 0
  reloadfile = -1
  wad_cached_patch_bytes =[]
  wad_cached_patch_names =[]

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

/// Initializes the merged lump directory and cache from a single WAD path.
/// @param filename Filesystem name of the target resource.
function W_InitFile(filename)
  W_InitMultipleFiles([filename])
end function

/// Returns the current merged directory size after all WAD and single-lump files have been added.
function W_NumLumps()
  return numlumps
end function

/// Re-reads the designated reloadable WAD, invalidates its resident cache entries, and updates directory
/// positions and sizes in place.
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

/// Searches the merged directory backward so later WADs override earlier lumps with the same canonical name.
/// @param name Resource or object name to resolve.
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

/// Resolves a lump name to its overriding directory index and raises a fatal error when absent.
/// @param name Resource or object name to resolve.
function W_GetNumForName(name)
  i = W_CheckNumForName(name)
  if i == -1 then
    I_Error("W_GetNumForName: " + name + " not found!")
  end if
  return i
end function

/// Validates a lump index and returns its directory byte size.
/// @param lump Lump value supplied to `W_LumpLength`.
function W_LumpLength(lump)
  lump = _W_ToIntOr(lump, -1)
  if lump < 0 or lump >= numlumps then
    I_Error("W_LumpLength: " + _W_IntToString(lump) + " >= numlumps")
    return 0
  end if
  return lumpinfo[lump].size
end function

/// Copies one validated lump byte range from its owning loaded file into the caller's destination buffer.
/// @param lump Lump value supplied to `W_ReadLump`.
/// @param dest Dest value supplied to `W_ReadLump`.
function W_ReadLump(lump, dest)
  lump = _W_ToIntOr(lump, -1)
  if lump < 0 or lump >= numlumps then
    I_Error("W_ReadLump: " + _W_IntToString(lump) + " >= numlumps")
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

/// Appends one data/name pair to the cached lump name lookup without using concatenation.
/// @param data Binary or structured data to process.
/// @param name Resource or object name to resolve.
/// @internal
function _W_AddCachedDataName(data, name)
  global wad_cached_patch_bytes
  global wad_cached_patch_names

  n = 0
  if typeof(wad_cached_patch_bytes) == "array" then n = len(wad_cached_patch_bytes) end if
  newBytes = array(n + 1)
  newNames = array(n + 1)
  i = 0
  while i < n
    newBytes[i] = wad_cached_patch_bytes[i]
    if typeof(wad_cached_patch_names) == "array" and i < len(wad_cached_patch_names) then
      newNames[i] = wad_cached_patch_names[i]
    else
      newNames[i] = ""
    end if
    i = i + 1
  end while
  newBytes[n] = data
  if typeof(name) == "string" then
    newNames[n] = name
  else
    newNames[n] = ""
  end if
  wad_cached_patch_bytes = newBytes
  wad_cached_patch_names = newNames
end function

/// Allocates and fills a lump's zone-cache slot on first use, retags resident data, and records patch-name
/// identity.
/// @param lump Lump value supplied to `W_CacheLumpNum`.
/// @param tag Zone-memory or resource-lifetime tag.
function W_CacheLumpNum(lump, tag)
  global wad_cached_patch_bytes
  global wad_cached_patch_names

  lump = _W_ToIntOr(lump, -1)
  tag = _W_ToIntOr(tag, 0)

  if lump < 0 or lump >= numlumps then
    I_Error("W_CacheLumpNum: invalid lump index")
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

  data = Z_BytesAt(slot[0], W_LumpLength(lump))
  if typeof(data) == "bytes" and typeof(lumpinfo) == "array" and lump >= 0 and lump < len(lumpinfo) then
    found = false
    i = 0
    while i < len(wad_cached_patch_bytes)
      if wad_cached_patch_bytes[i] == data then
        found = true
        break
      end if
      i = i + 1
    end while
    if not found then
      _W_AddCachedDataName(data, "")
    end if
  end if
  return data
end function

/// Associates cached lump bytes with a known name without touching lumpinfo metadata.
/// @param data Binary or structured data to process.
/// @param name Resource or object name to resolve.
/// @internal
function _W_RememberCachedDataName(data, name)
  global wad_cached_patch_bytes
  global wad_cached_patch_names

  if typeof(data) != "bytes" or typeof(name) != "string" or name == "" then return end if
  cacheName = _W_ToUpperAscii(name)
  i = 0
  while i < len(wad_cached_patch_bytes)
    if wad_cached_patch_bytes[i] == data then
      if i < len(wad_cached_patch_names) then
        wad_cached_patch_names[i] = cacheName
      end if
      return
    end if
    i = i + 1
  end while

  _W_AddCachedDataName(data, cacheName)
end function

/// Returns the WAD lump name for a cached byte view, when known.
/// @param data Binary or structured data to process.
function W_NameForCachedData(data)
  global wad_cached_patch_last_data
  global wad_cached_patch_last_name

  if typeof(data) != "bytes" then return "" end if
  if wad_cached_patch_last_data == data then return wad_cached_patch_last_name end if

  i = 0
  while i < len(wad_cached_patch_bytes) and i < len(wad_cached_patch_names)
    if wad_cached_patch_bytes[i] == data then
      wad_cached_patch_last_data = data
      wad_cached_patch_last_name = wad_cached_patch_names[i]
      if typeof(wad_cached_patch_last_name) != "string" then wad_cached_patch_last_name = "" end if
      return wad_cached_patch_last_name
    end if
    i = i + 1
  end while

  if len(data) > 32768 then return "" end if
  i = 0
  while i < len(wad_cached_patch_bytes) and i < len(wad_cached_patch_names)
    cached = wad_cached_patch_bytes[i]
    if typeof(cached) == "bytes" and len(cached) == len(data) then
      same = true
      j = 0
      while j < len(data)
        if cached[j] != data[j] then
          same = false
          break
        end if
        j = j + 1
      end while
      if same then
        wad_cached_patch_last_data = data
        wad_cached_patch_last_name = wad_cached_patch_names[i]
        if typeof(wad_cached_patch_last_name) != "string" then wad_cached_patch_last_name = "" end if
        return wad_cached_patch_last_name
      end if
    end if
    i = i + 1
  end while
  return ""
end function

/// Returns a resident lump's zone pointer without loading it, or the null-pointer sentinel for invalid or empty
/// slots.
/// @param lump Lump value supplied to `W_GetCachedLumpPtr`.
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

/// Resolves a canonical lump name, ensures its data is resident under the requested tag, and preserves name
/// metadata for patch users.
/// @param name Resource or object name to resolve.
/// @param tag Zone-memory or resource-lifetime tag.
function W_CacheLumpName(name, tag)
  lump = W_GetNumForName(name)
  data = W_CacheLumpNum(lump, tag)
  _W_RememberCachedDataName(data, name)
  return data
end function

/// Stores the w profile info collection used by the w wad subsystem.
/// @internal
_W_profile_info =[]
/// Tracks the mutable w profile count value used by the w wad subsystem.
/// @internal
_W_profile_count = 0

/// Samples cache residency for every lump and accumulates a per-snapshot history used to inspect resource-cache
/// behavior.
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



