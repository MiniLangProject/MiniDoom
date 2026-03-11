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

/*
Script: exe_icon_injector.ml
Purpose: Injects one .ico file into a Windows .exe using Win32 resource APIs.
*/

import std.fs as fs

const RT_ICON = 3
const RT_GROUP_ICON = 14
const DEFAULT_GROUP_ID = 1
const DEFAULT_LANG_ID = 1033
const FIRST_ICON_ID = 1

struct IcoImageEntry
  width
  height
  colorCount
  reserved
  planes
  bitCount
  bytesInRes
  data
end struct

extern function BeginUpdateResourceW(fileName as wstr, deleteExisting as bool) from "kernel32.dll" returns ptr
extern function UpdateResourceW(
hUpdate as ptr,
typeId as int,
nameId as int,
language as int,
data as bytes,
size as int
) from "kernel32.dll" returns bool
extern function EndUpdateResourceW(hUpdate as ptr, discard as bool) from "kernel32.dll" returns bool
extern function GetLastError() from "kernel32.dll" returns int

/*
Function: _u16le
Purpose: Reads a little-endian uint16 from a bytes buffer.
*/
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

/*
Function: _u32le
Purpose: Reads a little-endian uint32 from a bytes buffer.
*/
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

/*
Function: _setU16le
Purpose: Writes a little-endian uint16 into a bytes buffer.
*/
function _setU16le(b, off, value)
  b[off] = value & 255
  b[off + 1] =(value >> 8) & 255
end function

/*
Function: _setU32le
Purpose: Writes a little-endian uint32 into a bytes buffer.
*/
function _setU32le(b, off, value)
  b[off] = value & 255
  b[off + 1] =(value >> 8) & 255
  b[off + 2] =(value >> 16) & 255
  b[off + 3] =(value >> 24) & 255
end function

/*
Function: _fail
Purpose: Prints a formatted error and returns non-zero exit code.
*/
function _fail(msg)
  if typeof(msg) != "string" then
    print("Error.")
    return 1
  end if
  print("Error: " + msg)
  return 1
end function

/*
Function: _usage
Purpose: Prints usage information.
*/
function _usage()
  print("Usage:")
  print("  exe_icon_injector.exe <target.exe> <icon.ico> [groupId] [langId]")
  print("")
  print("Defaults:")
  print("  groupId = 1")
  print("  langId  = 1033 (en-US)")
end function

/*
Function: _parseIntArg
Purpose: Converts an optional CLI argument to int or returns fallback.
*/
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

/*
Function: _parseIco
Purpose: Parses a .ico file and returns image entries.
*/
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

/*
Function: _buildGroupIconResource
Purpose: Builds RT_GROUP_ICON payload from parsed ICO entries.
*/
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

/*
Function: _injectIcoIntoExe
Purpose: Replaces/creates icon resources in the target executable.
*/
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

/*
Function: main
Purpose: CLI entrypoint.
*/
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
