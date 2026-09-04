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

//! Implements reusable number, percent, multi-icon, and binary-icon widgets with classic-background
//! restoration.

import r_defs
import doomdef
import z_zone
import v_video
import m_swap
import i_system
import w_wad
import st_stuff
import r_local

/// Defines stlib bg for the st lib subsystem.
const STlib_BG = 4
/// Defines stlib fg for the st lib subsystem.
const STlib_FG = 0

/// Describes a fixed-width numeric widget, including screen position, digit patches, referenced
/// value/visibility, and last drawn value.
struct st_number_t
  /// Horizontal map- or screen-space coordinate stored by `st_number_t`
  x
  /// Vertical map- or screen-space coordinate stored by `st_number_t`
  y
  /// Width in pixels or map units stored by `st_number_t`
  width
  /// Stores oldnum for `st_number_t`
  oldnum
  /// Stores num for `st_number_t`
  num
  /// Stores on for `st_number_t`
  on
  /// Stores p for `st_number_t`
  p
  /// Payload owned or referenced by this record stored by `st_number_t`
  data
end struct

/// Combines a three-digit numeric widget with the percent-sign patch drawn beside it.
struct st_percent_t
  /// Stores n for `st_percent_t`
  n
  /// Stores p for `st_percent_t`
  p
end struct

/// Tracks an indexed icon widget, its patch set, referenced selection/visibility, and previously drawn index
/// for background restoration.
struct st_multicon_t
  /// Horizontal map- or screen-space coordinate stored by `st_multicon_t`
  x
  /// Vertical map- or screen-space coordinate stored by `st_multicon_t`
  y
  /// Stores oldinum for `st_multicon_t`
  oldinum
  /// Stores inum for `st_multicon_t`
  inum
  /// Stores on for `st_multicon_t`
  on
  /// Stores p for `st_multicon_t`
  p
  /// Payload owned or referenced by this record stored by `st_multicon_t`
  data
end struct

/// Tracks a boolean icon widget and its prior value so toggles can draw or erase only the affected patch
/// bounds.
struct st_binicon_t
  /// Horizontal map- or screen-space coordinate stored by `st_binicon_t`
  x
  /// Vertical map- or screen-space coordinate stored by `st_binicon_t`
  y
  /// Stores oldval for `st_binicon_t`
  oldval
  /// Stores val for `st_binicon_t`
  val
  /// Stores on for `st_binicon_t`
  on
  /// Stores p for `st_binicon_t`
  p
  /// Payload owned or referenced by this record stored by `st_binicon_t`
  data
end struct

/// Holds the optional sttminus resource used by the st lib subsystem.
sttminus = void
/// Stores the stlib patch name data collection used by the st lib subsystem.
stlib_patch_name_data =[]
/// Stores the stlib patch name names collection used by the st lib subsystem.
stlib_patch_name_names =[]

/// Appends one patch/name pair without relying on array concatenation.
/// @param patch Patch value supplied to `_STL_AddPatchName`.
/// @param name Resource or object name to resolve.
/// @internal
function _STL_AddPatchName(patch, name)
  global stlib_patch_name_data
  global stlib_patch_name_names

  n = 0
  if typeof(stlib_patch_name_data) == "array" then n = len(stlib_patch_name_data) end if
  newData = array(n + 1)
  newNames = array(n + 1)
  i = 0
  while i < n
    newData[i] = stlib_patch_name_data[i]
    if typeof(stlib_patch_name_names) == "array" and i < len(stlib_patch_name_names) then
      newNames[i] = stlib_patch_name_names[i]
    else
      newNames[i] = ""
    end if
    i = i + 1
  end while
  newData[n] = patch
  newNames[n] = name
  stlib_patch_name_data = newData
  stlib_patch_name_names = newNames
end function

/// Associates patch bytes with their lump name for optional HD overlays, replacing an existing mapping for the
/// same object.
/// @param patch Patch value supplied to `STlib_RegisterPatchName`.
/// @param name Resource or object name to resolve.
function STlib_RegisterPatchName(patch, name)
  global stlib_patch_name_data
  global stlib_patch_name_names
  if typeof(patch) != "bytes" or typeof(name) != "string" or name == "" then return end if
  i = 0
  while i < len(stlib_patch_name_data) and i < len(stlib_patch_name_names)
    if stlib_patch_name_data[i] == patch then
      stlib_patch_name_names[i] = name
      return
    end if
    i = i + 1
  end while
  _STL_AddPatchName(patch, name)
end function

/// Resolves a registered patch object back to the lump name required by the HD overlay path.
/// @param patch Patch value supplied to `_STL_NameForPatch`.
/// @internal
function _STL_NameForPatch(patch)
  if typeof(patch) != "bytes" then return "" end if
  i = 0
  while i < len(stlib_patch_name_data) and i < len(stlib_patch_name_names)
    if stlib_patch_name_data[i] == patch then return stlib_patch_name_names[i] end if
    i = i + 1
  end while
  return ""
end function

/// Draws the classic patch and, on the foreground screen, overlays its registered high-resolution counterpart
/// at offset-corrected coordinates.
/// @param x Horizontal map- or screen-space coordinate.
/// @param y Vertical map- or screen-space coordinate.
/// @param scrn Scrn value supplied to `_STL_DrawPatchHD`.
/// @param patch Patch value supplied to `_STL_DrawPatchHD`.
/// @internal
function _STL_DrawPatchHD(x, y, scrn, patch)
  V_DrawPatch(x, y, scrn, patch)
  if scrn != STlib_FG or typeof(V_DrawNamedUpscaledPatchOverlay) != "function" then return end if
  name = _STL_NameForPatch(patch)
  if name == "" then return end if
  V_DrawNamedUpscaledPatchOverlay(x - _STL_PatchLeft(patch), y - _STL_PatchTop(patch), name, false)
end function

/// Dereferences the library's single-element reference convention and returns a fallback for empty or void
/// values.
/// @param refv Refv value supplied to `_STL_GetRefValue`.
/// @param fallback Value returned when the requested conversion or lookup is unavailable.
/// @internal
function inline _STL_GetRefValue(refv, fallback)
  if typeof(refv) == "array" then
    if len(refv) > 0 then return refv[0] end if
    return fallback
  end if
  if refv is void then return fallback end if
  return refv
end function

/// Writes through the widget library's mutable single-element reference convention when storage is present.
/// @param refv Refv value supplied to `_STL_SetRefValue`.
/// @param v Value consumed by the operation.
/// @internal
function inline _STL_SetRefValue(refv, v)
  if typeof(refv) == "array" and len(refv) > 0 then
    refv[0] = v
  end if
end function

/// Converts supported scalar values to the widget visibility truth convention.
/// @param v Value consumed by the operation.
/// @internal
function inline _STL_AsBool(v)
  if typeof(v) == "bool" then return v end if
  if typeof(v) == "int" or typeof(v) == "float" then return v != 0 end if
  if typeof(v) == "string" then return len(v) > 0 end if
  return v is not void
end function

/// Dereferences a widget value and normalizes it to a visibility boolean.
/// @param refv Refv value supplied to `_STL_RefBool`.
/// @internal
function inline _STL_RefBool(refv)
  return _STL_AsBool(_STL_GetRefValue(refv, false))
end function

/// Converts numeric/string widget values to integers by truncating toward zero, retaining the fallback on
/// failure.
/// @param v Value consumed by the operation.
/// @param fallback Value returned when the requested conversion or lookup is unavailable.
/// @internal
function _STL_ToInt(v, fallback)
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

/// Divides widget layout integers with truncation toward zero and returns zero for a zero divisor.
/// @param a First input operand.
/// @param b Second input operand.
/// @internal
function inline _STL_IDiv(a, b)
  a = _STL_ToInt(a, 0)
  b = _STL_ToInt(b, 0)
  if b == 0 then return 0 end if
  q = a / b
  if q >= 0 then return std.math.floor(q) end if
  return std.math.ceil(q)
end function

/// Dereferences and truncates a widget value to an integer, retaining the supplied fallback on invalid input.
/// @param refv Refv value supplied to `_STL_RefInt`.
/// @param fallback Value returned when the requested conversion or lookup is unavailable.
/// @internal
function inline _STL_RefInt(refv, fallback)
  v = _STL_GetRefValue(refv, fallback)
  return _STL_ToInt(v, fallback)
end function

/// Reads the signed little-endian width from a validated Doom patch header.
/// @param p Object or data record consumed by the operation.
/// @internal
function inline _STL_PatchWidth(p)
  if typeof(p) != "bytes" then return 0 end if
  return RDefs_I16LE(p, 0)
end function

/// Reads the signed little-endian height from a validated Doom patch header.
/// @param p Object or data record consumed by the operation.
/// @internal
function inline _STL_PatchHeight(p)
  if typeof(p) != "bytes" then return 0 end if
  return RDefs_I16LE(p, 2)
end function

/// Reads the patch left offset used to restore its exact background rectangle.
/// @param p Object or data record consumed by the operation.
/// @internal
function inline _STL_PatchLeft(p)
  if typeof(p) != "bytes" then return 0 end if
  return RDefs_I16LE(p, 4)
end function

/// Reads the patch top offset used to restore its exact background rectangle.
/// @param p Object or data record consumed by the operation.
/// @internal
function inline _STL_PatchTop(p)
  if typeof(p) != "bytes" then return 0 end if
  return RDefs_I16LE(p, 6)
end function

/// Safely resolves one patch from an array/list after integer normalization and bounds checks.
/// @param patches Patches value supplied to `_STL_GetPatch`.
/// @param idx Zero-based element or table index.
/// @internal
function inline _STL_GetPatch(patches, idx)
  tp = typeof(patches)
  if tp != "array" and tp != "list" then return void end if
  i = _STL_ToInt(idx, -2147483648)
  if i < 0 or i >= len(patches) then return void end if
  return patches[i]
end function

/// Caches and registers the optional minus-sign patch used by negative numeric widgets.
function STlib_init()
  global sttminus

  sttminus = void
  if typeof(W_CheckNumForName) == "function" and W_CheckNumForName("STTMINUS") != -1 then
    sttminus = W_CacheLumpName("STTMINUS", PU_STATIC)
    STlib_RegisterPatchName(sttminus, "STTMINUS")
  end if
end function

/// Binds a numeric widget to coordinates, digit patches, referenced value/visibility, and fixed digit width.
/// @param n Number of values to process.
/// @param x Horizontal map- or screen-space coordinate.
/// @param y Vertical map- or screen-space coordinate.
/// @param pl Pl value supplied to `STlib_initNum`.
/// @param num Index identifying the requested item.
/// @param on On value supplied to `STlib_initNum`.
/// @param width Width of the target in pixels or map units.
function STlib_initNum(n, x, y, pl, num, on, width)
  n.x = x
  n.y = y
  n.p = pl
  n.num = num
  n.on = on
  n.width = width
  n.oldnum = 0
end function

/// Restores the old digit area and draws a changed fixed-width signed value right-to-left, honoring Doom's 1994
/// sentinel.
/// @param n Number of values to process.
/// @param refresh Refresh value supplied to `STlib_drawNum`.
function STlib_drawNum(n, refresh)
  refresh = refresh
  if n == 0 then return end if

  numdigits = n.width
  rawnum = _STL_RefInt(n.num, 0)
  if not refresh and n.oldnum == rawnum then return end if
  num = rawnum

  p0 = _STL_GetPatch(n.p, 0)
  w = _STL_PatchWidth(p0)
  h = _STL_PatchHeight(p0)
  if w <= 0 or h <= 0 then return end if

  n.oldnum = rawnum

  neg = num < 0
  if neg then
    if numdigits == 2 and num < -9 then
      num = -9
    else if numdigits == 3 and num < -99 then
      num = -99
    end if
    num = -num
  end if

  x = n.x - numdigits * w
  if n.y - ST_Y < 0 then
    if typeof(I_Error) == "function" then
      I_Error("STlib_drawNum: n.y - ST_Y < 0")
    end if
    return
  end if
  V_CopyRect(x, n.y - ST_Y, STlib_BG, w * numdigits, h, x, n.y, STlib_FG)

  if num == 1994 then return end if

  x = n.x

  if num == 0 then
    _STL_DrawPatchHD(x - w, n.y, STlib_FG, p0)
  end if

  while num != 0 and numdigits > 0
    x = x - w
    d = num % 10
    pd = _STL_GetPatch(n.p, d)
    if pd is not void then
      _STL_DrawPatchHD(x, n.y, STlib_FG, pd)
    end if
    num = _STL_IDiv(num - d, 10)
    numdigits = numdigits - 1
  end while

  if neg and sttminus is not void then
    _STL_DrawPatchHD(x - 8, n.y, STlib_FG, sttminus)
  end if
end function

/// Initializes a three-digit numeric widget and attaches its percent-sign patch.
/// @param p Object or data record consumed by the operation.
/// @param x Horizontal map- or screen-space coordinate.
/// @param y Vertical map- or screen-space coordinate.
/// @param pl Pl value supplied to `STlib_initPercent`.
/// @param num Index identifying the requested item.
/// @param on On value supplied to `STlib_initPercent`.
/// @param percentPatch Percent patch value supplied to `STlib_initPercent`.
function STlib_initPercent(p, x, y, pl, num, on, percentPatch)
  p.n = st_number_t(0, 0, 0, 0, 0, 0, 0, 0)
  STlib_initNum(p.n, x, y, pl, num, on, 3)
  p.p = percentPatch
end function

/// Draws the percent sign on refresh when visible, then updates the associated numeric widget.
/// @param p Object or data record consumed by the operation.
/// @param refresh Refresh value supplied to `STlib_drawPercent`.
function STlib_drawPercent(p, refresh)
  if p == 0 then return end if
  if refresh and _STL_RefBool(p.n.on) and p.p is not void then
    _STL_DrawPatchHD(p.n.x, p.n.y, STlib_FG, p.p)
  end if
  STlib_drawNum(p.n, refresh)
end function

/// Binds an indexed icon widget to its patch array, referenced index/visibility, coordinates, and invalid
/// initial cache.
/// @param i Zero-based iteration index.
/// @param x Horizontal map- or screen-space coordinate.
/// @param y Vertical map- or screen-space coordinate.
/// @param il Il value supplied to `STlib_initMultIcon`.
/// @param inum Index identifying i.
/// @param on On value supplied to `STlib_initMultIcon`.
function STlib_initMultIcon(i, x, y, il, inum, on)
  i.x = x
  i.y = y
  i.p = il
  i.inum = inum
  i.on = on
  i.oldinum = -1
end function

/// Erases a changed prior icon from the status background and draws the newly selected patch when visible.
/// @param i Zero-based iteration index.
/// @param refresh Refresh value supplied to `STlib_drawMultIcon`.
function STlib_drawMultIcon(i, refresh)
  if i == 0 then return end if

  if _STL_RefBool(i.on) then
    cur = _STL_RefInt(i.inum, -1)
    if (i.oldinum != cur or refresh) and cur != -1 then
      if i.oldinum != -1 then
        oldp = _STL_GetPatch(i.p, i.oldinum)
        if oldp is not void then
          x = i.x - _STL_PatchLeft(oldp)
          y = i.y - _STL_PatchTop(oldp)
          w = _STL_PatchWidth(oldp)
          h = _STL_PatchHeight(oldp)
          if y - ST_Y < 0 then
            if typeof(I_Error) == "function" then I_Error("STlib_drawMultIcon: y - ST_Y < 0") end if
            return
          end if
          V_CopyRect(x, y - ST_Y, STlib_BG, w, h, x, y, STlib_FG)
        end if
      end if

      p = _STL_GetPatch(i.p, cur)
      if p is not void then
        _STL_DrawPatchHD(i.x, i.y, STlib_FG, p)
      end if
      i.oldinum = cur
    end if
  end if
end function

/// Binds a boolean icon widget to its patch, coordinates, referenced value, and visibility control.
/// @param b Second input operand.
/// @param x Horizontal map- or screen-space coordinate.
/// @param y Vertical map- or screen-space coordinate.
/// @param patch Patch value supplied to `STlib_initBinIcon`.
/// @param val Val value supplied to `STlib_initBinIcon`.
/// @param on On value supplied to `STlib_initBinIcon`.
function STlib_initBinIcon(b, x, y, patch, val, on)
  b.x = x
  b.y = y
  b.p = patch
  b.val = val
  b.on = on
  b.oldval = 0
end function

/// Draws or erases a boolean icon only when its value changes or a full refresh is requested.
/// @param b Second input operand.
/// @param refresh Refresh value supplied to `STlib_drawBinIcon`.
function STlib_drawBinIcon(b, refresh)
  if b == 0 then return end if

  if _STL_RefBool(b.on) then
    v = _STL_RefBool(b.val)
    if b.oldval != v or refresh then
      x = b.x - _STL_PatchLeft(b.p)
      y = b.y - _STL_PatchTop(b.p)
      w = _STL_PatchWidth(b.p)
      h = _STL_PatchHeight(b.p)

      if y - ST_Y < 0 then
        if typeof(I_Error) == "function" then I_Error("STlib_drawBinIcon: y - ST_Y < 0") end if
        return
      end if

      if v then
        _STL_DrawPatchHD(b.x, b.y, STlib_FG, b.p)
      else
        V_CopyRect(x, y - ST_Y, STlib_BG, w, h, x, y, STlib_FG)
      end if
      b.oldval = v
    end if
  end if
end function

/// Redraws an enabled numeric widget when its value changed or a full refresh was requested.
/// @param n Number of values to process.
/// @param refresh Refresh value supplied to `STlib_updateNum`.
function STlib_updateNum(n, refresh)
  if _STL_RefBool(n.on) then STlib_drawNum(n, refresh) end if
end function

/// Updates a percentage widget, including its percent patch and visibility-controlled numeric value.
/// @param p Object or data record consumed by the operation.
/// @param refresh Refresh value supplied to `STlib_updatePercent`.
function STlib_updatePercent(p, refresh)
  STlib_drawPercent(p, refresh)
end function

/// Replaces a multi-icon widget when its referenced icon index changes or the status bar refreshes.
/// @param i Zero-based iteration index.
/// @param refresh Refresh value supplied to `STlib_updateMultIcon`.
function STlib_updateMultIcon(i, refresh)
  STlib_drawMultIcon(i, refresh)
end function

/// Shows or erases a binary icon when its referenced boolean changes or the status bar refreshes.
/// @param b Second input operand.
/// @param refresh Refresh value supplied to `STlib_updateBinIcon`.
function STlib_updateBinIcon(b, refresh)
  STlib_drawBinIcon(b, refresh)
end function



