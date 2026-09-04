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

//! Injects one .ico file into a Windows .exe using Win32 resource APIs.

import std.fs as fs

/// Win32 resource type identifier for one encoded icon image.
const RT_ICON = 3
/// Win32 resource type identifier for an icon directory.
const RT_GROUP_ICON = 14
/// Default numeric identifier of the emitted icon group.
const DEFAULT_GROUP_ID = 1
/// Default en-US language identifier assigned to icon resources.
const DEFAULT_LANG_ID = 1033
/// First resource identifier reserved for individual icon images.
const FIRST_ICON_ID = 1

/// Holds one decoded ICO directory entry plus its exact encoded image bytes for RT_ICON emission.
struct IcoImageEntry
  /// Width in pixels or map units stored by `IcoImageEntry`
  width
  /// Height in pixels or map units stored by `IcoImageEntry`
  height
  /// Stores color count for `IcoImageEntry`
  colorCount
  /// Stores reserved for `IcoImageEntry`
  reserved
  /// Stores planes for `IcoImageEntry`
  planes
  /// Stores bit count for `IcoImageEntry`
  bitCount
  /// Stores bytes in res for `IcoImageEntry`
  bytesInRes
  /// Payload owned or referenced by this record stored by `IcoImageEntry`
  data
end struct

/// Opens an executable's Win32 resource table for transactional updates while preserving unrelated resources.
/// @param fileName Filesystem name of the target resource.
/// @param deleteExisting `bool` value supplied as delete existing to `BeginUpdateResourceW`.
/// @returns Result returned by the native `BeginUpdateResourceW` binding as `ptr`.
extern function BeginUpdateResourceW(fileName as wstr, deleteExisting as bool) from "kernel32.dll" returns ptr
/// Adds or replaces one language-specific icon/group resource in an open executable update transaction.
/// @param hUpdate `ptr` value supplied as h update to `UpdateResourceW`.
/// @param typeId `int` value supplied as type id to `UpdateResourceW`.
/// @param nameId `int` value supplied as name id to `UpdateResourceW`.
/// @param language `int` value supplied as language to `UpdateResourceW`.
/// @param data Binary or structured data to process.
/// @param size Requested size in bytes or elements.
/// @returns Result returned by the native `UpdateResourceW` binding as `bool`.
extern function UpdateResourceW(
hUpdate as ptr,
typeId as int,
nameId as int,
language as int,
data as bytes,
size as int
) from "kernel32.dll" returns bool
/// Commits or discards the open executable resource transaction and releases its Win32 handle.
/// @param hUpdate `ptr` value supplied as h update to `EndUpdateResourceW`.
/// @param discard `bool` value supplied as discard to `EndUpdateResourceW`.
/// @returns Result returned by the native `EndUpdateResourceW` binding as `bool`.
extern function EndUpdateResourceW(hUpdate as ptr, discard as bool) from "kernel32.dll" returns bool
/// Returns the calling thread's Win32 error code after a failed resource API operation.
/// @returns The calling thread's Win32 error code after a failed resource API operation.
extern function GetLastError() from "kernel32.dll" returns int

/// Reads a little-endian uint16 from a bytes buffer.
/// @param b Second input operand.
/// @param off Zero-based byte or element offset.
/// @internal
function _u16le(b, off)
  if typeof(b) != "bytes" then
    return
  end if
  if typeof(off) != "int" then
    return
  end if
  if off < 0 or off + 1 >= len(b) then
    return
  end if
  return b[off] |(b[off + 1] << 8)
end function

/// Reads a little-endian uint32 from a bytes buffer.
/// @param b Second input operand.
/// @param off Zero-based byte or element offset.
/// @internal
function _u32le(b, off)
  if typeof(b) != "bytes" then
    return
  end if
  if typeof(off) != "int" then
    return
  end if
  if off < 0 or off + 3 >= len(b) then
    return
  end if
  return b[off] |(b[off + 1] << 8) |(b[off + 2] << 16) |(b[off + 3] << 24)
end function

/// Writes a little-endian uint16 into a bytes buffer.
/// @param b Second input operand.
/// @param off Zero-based byte or element offset.
/// @param value Value consumed by the operation.
/// @internal
function _setU16le(b, off, value)
  b[off] = value & 255
  b[off + 1] =(value >> 8) & 255
end function

/// Writes a little-endian uint32 into a bytes buffer.
/// @param b Second input operand.
/// @param off Zero-based byte or element offset.
/// @param value Value consumed by the operation.
/// @internal
function _setU32le(b, off, value)
  b[off] = value & 255
  b[off + 1] =(value >> 8) & 255
  b[off + 2] =(value >> 16) & 255
  b[off + 3] =(value >> 24) & 255
end function

/// Prints a formatted error and returns non-zero exit code.
/// @param msg Msg value supplied to `_fail`.
/// @internal
function _fail(msg)
  if typeof(msg) != "string" then
    print("Error.")
    return 1
  end if
  print("Error: " + msg)
  return 1
end function

/// Prints usage information.
/// @internal
function _usage()
  print("Usage:")
  print("  exe_icon_injector.exe <target.exe> <icon.ico> [groupId] [langId]")
  print("")
  print("Defaults:")
  print("  groupId = 1")
  print("  langId  = 1033 (en-US)")
end function

/// Converts an optional CLI argument to int or returns fallback.
/// @param args Args value supplied to `_parseIntArg`.
/// @param idx Zero-based element or table index.
/// @param fallback Value returned when the requested conversion or lookup is unavailable.
/// @internal
function _parseIntArg(args, idx, fallback)
  if typeof(args) != "array" then
    return
  end if
  if typeof(idx) != "int" then
    return
  end if
  if typeof(fallback) != "int" then
    return
  end if
  if idx < 0 or idx >= len(args) then
    return fallback
  end if
  n = toNumber(args[idx])
  if typeof(n) != "int" then
    return
  end if
  return n
end function

/// Parses a .ico file and returns image entries.
/// @param icoBytes Ico bytes value supplied to `_parseIco`.
/// @internal
function _parseIco(icoBytes)
  if typeof(icoBytes) != "bytes" then
    return error(1, "ICO data is not bytes")
  end if
  if len(icoBytes) < 6 then
    return error(1, "ICO too small")
  end if

  reserved = _u16le(icoBytes, 0)
  kind = _u16le(icoBytes, 2)
  count = _u16le(icoBytes, 4)
  if typeof(reserved) != "int" or typeof(kind) != "int" or typeof(count) != "int" then
    return error(1, "ICO header parse failed")
  end if
  if reserved != 0 then
    return error(1, "ICO header: reserved must be 0")
  end if
  if kind != 1 then
    return error(1, "ICO header: type must be 1")
  end if
  if count <= 0 then
    return error(1, "ICO header: no images")
  end if

  dirBytes = 6 + count * 16
  if dirBytes > len(icoBytes) then
    return error(1, "ICO directory truncated")
  end if

  entries =[]
  i = 0
  while i < count
    off = 6 + i * 16

    width = icoBytes[off]
    height = icoBytes[off + 1]
    colorCount = icoBytes[off + 2]
    reservedByte = icoBytes[off + 3]
    planes = _u16le(icoBytes, off + 4)
    bitCount = _u16le(icoBytes, off + 6)
    bytesInRes = _u32le(icoBytes, off + 8)
    imageOffset = _u32le(icoBytes, off + 12)

    if typeof(planes) != "int" or typeof(bitCount) != "int" then
      return error(1, "ICO entry parse failed (u16)")
    end if
    if typeof(bytesInRes) != "int" or typeof(imageOffset) != "int" then
      return error(1, "ICO entry parse failed (u32)")
    end if
    if bytesInRes <= 0 then
      return error(1, "ICO entry has empty image data")
    end if
    if imageOffset < 0 or imageOffset + bytesInRes > len(icoBytes) then
      return error(1, "ICO entry out of bounds")
    end if

    imgData = slice(icoBytes, imageOffset, bytesInRes)
    if typeof(imgData) != "bytes" then
      return error(1, "ICO image slice failed")
    end if

    entries = entries +[
    IcoImageEntry(
      width,
      height,
      colorCount,
      reservedByte,
      planes,
      bitCount,
      bytesInRes,
      imgData
    )
  ]

    i = i + 1
  end while

  return entries
end function

/// Builds RT_GROUP_ICON payload from parsed ICO entries.
/// @param entries Entries value supplied to `_buildGroupIconResource`.
/// @param firstIconId First icon id value supplied to `_buildGroupIconResource`.
/// @internal
function _buildGroupIconResource(entries, firstIconId)
  if typeof(entries) != "array" then
    return
  end if
  if typeof(firstIconId) != "int" then
    return
  end if
  n = len(entries)
  if n <= 0 then
    return
  end if

  grp = bytes(6 + n * 14, 0)
  _setU16le(grp, 0, 0)
  _setU16le(grp, 2, 1)
  _setU16le(grp, 4, n)

  i = 0
  while i < n
    e = entries[i]
    if typeof(e) != "struct" then
      return
    end if
    base = 6 + i * 14
    grp[base] = e.width
    grp[base + 1] = e.height
    grp[base + 2] = e.colorCount
    grp[base + 3] = e.reserved
    _setU16le(grp, base + 4, e.planes)
    _setU16le(grp, base + 6, e.bitCount)
    _setU32le(grp, base + 8, e.bytesInRes)
    _setU16le(grp, base + 12, firstIconId + i)
    i = i + 1
  end while

  return grp
end function

/// Replaces/creates icon resources in the target executable.
/// @param exePath Exe path value supplied to `_injectIcoIntoExe`.
/// @param icoPath Ico path value supplied to `_injectIcoIntoExe`.
/// @param groupId Group id value supplied to `_injectIcoIntoExe`.
/// @param langId Lang id value supplied to `_injectIcoIntoExe`.
/// @internal
function _injectIcoIntoExe(exePath, icoPath, groupId, langId)
  if typeof(exePath) != "string" or len(exePath) == 0 then
    return error(1, "Invalid exe path")
  end if
  if typeof(icoPath) != "string" or len(icoPath) == 0 then
    return error(1, "Invalid ico path")
  end if
  if typeof(groupId) != "int" or groupId <= 0 then
    return error(1, "groupId must be a positive int")
  end if
  if typeof(langId) != "int" or langId < 0 or langId > 65535 then
    return error(1, "langId must be in range 0..65535")
  end if
  if fs.isFile(exePath) == false then
    return error(1, "EXE not found: " + exePath)
  end if
  if fs.isFile(icoPath) == false then
    return error(1, "ICO not found: " + icoPath)
  end if

  icoBytes = fs.readAllBytes(icoPath)
  if typeof(icoBytes) == "error" then
    return error(1, "Failed to read ICO: " + icoBytes.message)
  end if

  entries = _parseIco(icoBytes)
  if typeof(entries) == "error" then
    return entries
  end if
  if typeof(entries) != "array" or len(entries) == 0 then
    return error(1, "No ICO entries parsed")
  end if

  hUpdate = BeginUpdateResourceW(exePath, false)
  if hUpdate == 0 then
    err = GetLastError()
    return error(1, "BeginUpdateResourceW failed (GetLastError=" + err + ")")
  end if

  i = 0
  while i < len(entries)
    entry = entries[i]
    iconId = FIRST_ICON_ID + i
    ok = UpdateResourceW(
      hUpdate,
      RT_ICON,
      iconId,
      langId,
      entry.data,
      len(entry.data)
    )
    if ok == false then
      err = GetLastError()
      EndUpdateResourceW(hUpdate, true)
      return error(
        1,
        "UpdateResourceW(RT_ICON, id=" + iconId + ") failed (GetLastError=" + err + ")"
      )
    end if
    i = i + 1
  end while

  groupData = _buildGroupIconResource(entries, FIRST_ICON_ID)
  if typeof(groupData) != "bytes" then
    EndUpdateResourceW(hUpdate, true)
    return error(1, "Failed to build RT_GROUP_ICON resource")
  end if

  okGroup = UpdateResourceW(
    hUpdate,
    RT_GROUP_ICON,
    groupId,
    langId,
    groupData,
    len(groupData)
  )
  if okGroup == false then
    err = GetLastError()
    EndUpdateResourceW(hUpdate, true)
    return error(
      1,
      "UpdateResourceW(RT_GROUP_ICON, id=" + groupId + ") failed (GetLastError=" + err + ")"
    )
  end if

  okEnd = EndUpdateResourceW(hUpdate, false)
  if okEnd == false then
    err = GetLastError()
    return error(1, "EndUpdateResourceW failed (GetLastError=" + err + ")")
  end if

  return true
end function

/// Validates CLI paths/resource identifiers, injects the ICO transactionally, and returns a shell-compatible
/// status code.
/// @param args Args value supplied to `main`.
function main(args)
  if typeof(args) != "array" or len(args) < 2 then
    _usage()
    return 1
  end if

  exePath = args[0]
  icoPath = args[1]

  groupId = _parseIntArg(args, 2, DEFAULT_GROUP_ID)
  if typeof(groupId) != "int" then
    return _fail("Invalid groupId (must be int)")
  end if

  langId = _parseIntArg(args, 3, DEFAULT_LANG_ID)
  if typeof(langId) != "int" then
    return _fail("Invalid langId (must be int)")
  end if

  result = _injectIcoIntoExe(exePath, icoPath, groupId, langId)
  if typeof(result) == "error" then
    return _fail(result.message)
  end if

  print("Icon injected successfully.")
  print("  exe: " + exePath)
  print("  ico: " + icoPath)
  print("  groupId: " + groupId)
  print("  langId: " + langId)
  return 0
end function
