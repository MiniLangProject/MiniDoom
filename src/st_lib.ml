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

  Script: st_lib.ml
  Purpose: Implements reusable number, percent, multi-icon, and binary-icon widgets with classic-background restoration.
*/
import r_defs
import doomdef
import z_zone
import v_video
import m_swap
import i_system
import w_wad
import st_stuff
import r_local

const STlib_BG = 4
const STlib_FG = 0

/*
* Struct: st_number_t
* Purpose: Describes a fixed-width numeric widget, including screen position, digit patches, referenced value/visibility, and last drawn value.
*/
struct st_number_t
  x
  y
  width
  oldnum
  num
  on
  p
  data
end struct

/*
* Struct: st_percent_t
* Purpose: Combines a three-digit numeric widget with the percent-sign patch drawn beside it.
*/
struct st_percent_t
  n
  p
end struct

/*
* Struct: st_multicon_t
* Purpose: Tracks an indexed icon widget, its patch set, referenced selection/visibility, and previously drawn index for background restoration.
*/
struct st_multicon_t
  x
  y
  oldinum
  inum
  on
  p
  data
end struct

/*
* Struct: st_binicon_t
* Purpose: Tracks a boolean icon widget and its prior value so toggles can draw or erase only the affected patch bounds.
*/
struct st_binicon_t
  x
  y
  oldval
  val
  on
  p
  data
end struct

sttminus = void
stlib_patch_name_data =[]
stlib_patch_name_names =[]

/*
* Function: _STL_AddPatchName
* Purpose: Appends one patch/name pair without relying on array concatenation.
*/
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

/*
* Function: STlib_RegisterPatchName
* Purpose: Associates patch bytes with their lump name for optional HD overlays, replacing an existing mapping for the same object.
*/
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

/*
* Function: _STL_NameForPatch
* Purpose: Resolves a registered patch object back to the lump name required by the HD overlay path.
*/
function _STL_NameForPatch(patch)
  if typeof(patch) != "bytes" then return "" end if
  i = 0
  while i < len(stlib_patch_name_data) and i < len(stlib_patch_name_names)
    if stlib_patch_name_data[i] == patch then return stlib_patch_name_names[i] end if
    i = i + 1
  end while
  return ""
end function

/*
* Function: _STL_DrawPatchHD
* Purpose: Draws the classic patch and, on the foreground screen, overlays its registered high-resolution counterpart at offset-corrected coordinates.
*/
function _STL_DrawPatchHD(x, y, scrn, patch)
  V_DrawPatch(x, y, scrn, patch)
  if scrn != STlib_FG or typeof(V_DrawNamedUpscaledPatchOverlay) != "function" then return end if
  name = _STL_NameForPatch(patch)
  if name == "" then return end if
  V_DrawNamedUpscaledPatchOverlay(x - _STL_PatchLeft(patch), y - _STL_PatchTop(patch), name, false)
end function

/*
* Function: _STL_GetRefValue
* Purpose: Dereferences the library's single-element reference convention and returns a fallback for empty or void values.
*/
function inline _STL_GetRefValue(refv, fallback)
  if typeof(refv) == "array" then
    if len(refv) > 0 then return refv[0] end if
    return fallback
  end if
  if refv is void then return fallback end if
  return refv
end function

/*
* Function: _STL_SetRefValue
* Purpose: Writes through the widget library's mutable single-element reference convention when storage is present.
*/
function inline _STL_SetRefValue(refv, v)
  if typeof(refv) == "array" and len(refv) > 0 then
    refv[0] = v
  end if
end function

/*
* Function: _STL_AsBool
* Purpose: Converts supported scalar values to the widget visibility truth convention.
*/
function inline _STL_AsBool(v)
  if typeof(v) == "bool" then return v end if
  if typeof(v) == "int" or typeof(v) == "float" then return v != 0 end if
  if typeof(v) == "string" then return len(v) > 0 end if
  return v is not void
end function

/*
* Function: _STL_RefBool
* Purpose: Dereferences a widget value and normalizes it to a visibility boolean.
*/
function inline _STL_RefBool(refv)
  return _STL_AsBool(_STL_GetRefValue(refv, false))
end function

/*
* Function: _STL_ToInt
* Purpose: Converts numeric/string widget values to integers by truncating toward zero, retaining the fallback on failure.
*/
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

/*
* Function: _STL_IDiv
* Purpose: Divides widget layout integers with truncation toward zero and returns zero for a zero divisor.
*/
function inline _STL_IDiv(a, b)
  a = _STL_ToInt(a, 0)
  b = _STL_ToInt(b, 0)
  if b == 0 then return 0 end if
  q = a / b
  if q >= 0 then return std.math.floor(q) end if
  return std.math.ceil(q)
end function

/*
* Function: _STL_RefInt
* Purpose: Dereferences and truncates a widget value to an integer, retaining the supplied fallback on invalid input.
*/
function inline _STL_RefInt(refv, fallback)
  v = _STL_GetRefValue(refv, fallback)
  return _STL_ToInt(v, fallback)
end function

/*
* Function: _STL_PatchWidth
* Purpose: Reads the signed little-endian width from a validated Doom patch header.
*/
function inline _STL_PatchWidth(p)
  if typeof(p) != "bytes" then return 0 end if
  return RDefs_I16LE(p, 0)
end function

/*
* Function: _STL_PatchHeight
* Purpose: Reads the signed little-endian height from a validated Doom patch header.
*/
function inline _STL_PatchHeight(p)
  if typeof(p) != "bytes" then return 0 end if
  return RDefs_I16LE(p, 2)
end function

/*
* Function: _STL_PatchLeft
* Purpose: Reads the patch left offset used to restore its exact background rectangle.
*/
function inline _STL_PatchLeft(p)
  if typeof(p) != "bytes" then return 0 end if
  return RDefs_I16LE(p, 4)
end function

/*
* Function: _STL_PatchTop
* Purpose: Reads the patch top offset used to restore its exact background rectangle.
*/
function inline _STL_PatchTop(p)
  if typeof(p) != "bytes" then return 0 end if
  return RDefs_I16LE(p, 6)
end function

/*
* Function: _STL_GetPatch
* Purpose: Safely resolves one patch from an array/list after integer normalization and bounds checks.
*/
function inline _STL_GetPatch(patches, idx)
  tp = typeof(patches)
  if tp != "array" and tp != "list" then return void end if
  i = _STL_ToInt(idx, -2147483648)
  if i < 0 or i >= len(patches) then return void end if
  return patches[i]
end function

/*
* Function: STlib_init
* Purpose: Caches and registers the optional minus-sign patch used by negative numeric widgets.
*/
function STlib_init()
  global sttminus

  sttminus = void
  if typeof(W_CheckNumForName) == "function" and W_CheckNumForName("STTMINUS") != -1 then
    sttminus = W_CacheLumpName("STTMINUS", PU_STATIC)
    STlib_RegisterPatchName(sttminus, "STTMINUS")
  end if
end function

/*
* Function: STlib_initNum
* Purpose: Binds a numeric widget to coordinates, digit patches, referenced value/visibility, and fixed digit width.
*/
function STlib_initNum(n, x, y, pl, num, on, width)
  n.x = x
  n.y = y
  n.p = pl
  n.num = num
  n.on = on
  n.width = width
  n.oldnum = 0
end function

/*
* Function: STlib_drawNum
* Purpose: Restores the old digit area and draws a changed fixed-width signed value right-to-left, honoring Doom's 1994 sentinel.
*/
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

/*
* Function: STlib_initPercent
* Purpose: Initializes a three-digit numeric widget and attaches its percent-sign patch.
*/
function STlib_initPercent(p, x, y, pl, num, on, percentPatch)
  p.n = st_number_t(0, 0, 0, 0, 0, 0, 0, 0)
  STlib_initNum(p.n, x, y, pl, num, on, 3)
  p.p = percentPatch
end function

/*
* Function: STlib_drawPercent
* Purpose: Draws the percent sign on refresh when visible, then updates the associated numeric widget.
*/
function STlib_drawPercent(p, refresh)
  if p == 0 then return end if
  if refresh and _STL_RefBool(p.n.on) and p.p is not void then
    _STL_DrawPatchHD(p.n.x, p.n.y, STlib_FG, p.p)
  end if
  STlib_drawNum(p.n, refresh)
end function

/*
* Function: STlib_initMultIcon
* Purpose: Binds an indexed icon widget to its patch array, referenced index/visibility, coordinates, and invalid initial cache.
*/
function STlib_initMultIcon(i, x, y, il, inum, on)
  i.x = x
  i.y = y
  i.p = il
  i.inum = inum
  i.on = on
  i.oldinum = -1
end function

/*
* Function: STlib_drawMultIcon
* Purpose: Erases a changed prior icon from the status background and draws the newly selected patch when visible.
*/
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

/*
* Function: STlib_initBinIcon
* Purpose: Binds a boolean icon widget to its patch, coordinates, referenced value, and visibility control.
*/
function STlib_initBinIcon(b, x, y, patch, val, on)
  b.x = x
  b.y = y
  b.p = patch
  b.val = val
  b.on = on
  b.oldval = 0
end function

/*
* Function: STlib_drawBinIcon
* Purpose: Draws or erases a boolean icon only when its value changes or a full refresh is requested.
*/
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

/*
* Function: STlib_updateNum
* Purpose: Redraws an enabled numeric widget when its value changed or a full refresh was requested.
*/
function STlib_updateNum(n, refresh)
  if _STL_RefBool(n.on) then STlib_drawNum(n, refresh) end if
end function

/*
* Function: STlib_updatePercent
* Purpose: Updates a percentage widget, including its percent patch and visibility-controlled numeric value.
*/
function STlib_updatePercent(p, refresh)
  STlib_drawPercent(p, refresh)
end function

/*
* Function: STlib_updateMultIcon
* Purpose: Replaces a multi-icon widget when its referenced icon index changes or the status bar refreshes.
*/
function STlib_updateMultIcon(i, refresh)
  STlib_drawMultIcon(i, refresh)
end function

/*
* Function: STlib_updateBinIcon
* Purpose: Shows or erases a binary icon when its referenced boolean changes or the status bar refreshes.
*/
function STlib_updateBinIcon(b, refresh)
  STlib_drawBinIcon(b, refresh)
end function



