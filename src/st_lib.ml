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
  Purpose: Implements status bar and HUD presentation logic.
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
* Purpose: Stores runtime data for st number type.
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
* Purpose: Stores runtime data for st percent type.
*/
struct st_percent_t
  n
  p
end struct

/*
* Struct: st_multicon_t
* Purpose: Stores runtime data for st multicon type.
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
* Purpose: Stores runtime data for st binicon type.
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

/*
* Function: _STL_GetRefValue
* Purpose: Reads or updates state used by the internal module support.
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
* Purpose: Reads or updates state used by the internal module support.
*/
function inline _STL_SetRefValue(refv, v)
  if typeof(refv) == "array" and len(refv) > 0 then
    refv[0] = v
  end if
end function

/*
* Function: _STL_AsBool
* Purpose: Implements the _STL_AsBool routine for the internal module support.
*/
function inline _STL_AsBool(v)
  if typeof(v) == "bool" then return v end if
  if typeof(v) == "int" or typeof(v) == "float" then return v != 0 end if
  if typeof(v) == "string" then return len(v) > 0 end if
  return v is not void
end function

/*
* Function: _STL_RefBool
* Purpose: Implements the _STL_RefBool routine for the internal module support.
*/
function inline _STL_RefBool(refv)
  return _STL_AsBool(_STL_GetRefValue(refv, false))
end function

/*
* Function: _STL_ToInt
* Purpose: Implements the _STL_ToInt routine for the internal module support.
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
* Purpose: Implements the _STL_IDiv routine for the internal module support.
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
* Purpose: Implements the _STL_RefInt routine for the internal module support.
*/
function inline _STL_RefInt(refv, fallback)
  v = _STL_GetRefValue(refv, fallback)
  return _STL_ToInt(v, fallback)
end function

/*
* Function: _STL_PatchWidth
* Purpose: Implements the _STL_PatchWidth routine for the internal module support.
*/
function inline _STL_PatchWidth(p)
  if typeof(p) != "bytes" then return 0 end if
  return RDefs_I16LE(p, 0)
end function

/*
* Function: _STL_PatchHeight
* Purpose: Implements the _STL_PatchHeight routine for the internal module support.
*/
function inline _STL_PatchHeight(p)
  if typeof(p) != "bytes" then return 0 end if
  return RDefs_I16LE(p, 2)
end function

/*
* Function: _STL_PatchLeft
* Purpose: Implements the _STL_PatchLeft routine for the internal module support.
*/
function inline _STL_PatchLeft(p)
  if typeof(p) != "bytes" then return 0 end if
  return RDefs_I16LE(p, 4)
end function

/*
* Function: _STL_PatchTop
* Purpose: Implements the _STL_PatchTop routine for the internal module support.
*/
function inline _STL_PatchTop(p)
  if typeof(p) != "bytes" then return 0 end if
  return RDefs_I16LE(p, 6)
end function

/*
* Function: _STL_GetPatch
* Purpose: Reads or updates state used by the internal module support.
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
* Purpose: Initializes state and dependencies for the engine module behavior.
*/
function STlib_init()
  global sttminus

  sttminus = void
  if typeof(W_CheckNumForName) == "function" and W_CheckNumForName("STTMINUS") != -1 then
    sttminus = W_CacheLumpName("STTMINUS", PU_STATIC)
  end if
end function

/*
* Function: STlib_initNum
* Purpose: Initializes state and dependencies for the engine module behavior.
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
* Purpose: Draws or renders output for the engine module behavior.
*/
function STlib_drawNum(n, refresh)
  refresh = refresh
  if n == 0 then return end if

  numdigits = n.width
  rawnum = _STL_RefInt(n.num, 0)
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
    V_DrawPatch(x - w, n.y, STlib_FG, p0)
  end if

  while num != 0 and numdigits > 0
    x = x - w
    d = num % 10
    pd = _STL_GetPatch(n.p, d)
    if pd is not void then
      V_DrawPatch(x, n.y, STlib_FG, pd)
    end if
    num = _STL_IDiv(num - d, 10)
    numdigits = numdigits - 1
  end while

  if neg and sttminus is not void then
    V_DrawPatch(x - 8, n.y, STlib_FG, sttminus)
  end if
end function

/*
* Function: STlib_initPercent
* Purpose: Initializes state and dependencies for the engine module behavior.
*/
function STlib_initPercent(p, x, y, pl, num, on, percentPatch)
  p.n = st_number_t(0, 0, 0, 0, 0, 0, 0, 0)
  STlib_initNum(p.n, x, y, pl, num, on, 3)
  p.p = percentPatch
end function

/*
* Function: STlib_drawPercent
* Purpose: Draws or renders output for the engine module behavior.
*/
function STlib_drawPercent(p, refresh)
  if p == 0 then return end if
  if refresh and _STL_RefBool(p.n.on) and p.p is not void then
    V_DrawPatch(p.n.x, p.n.y, STlib_FG, p.p)
  end if
  STlib_drawNum(p.n, refresh)
end function

/*
* Function: STlib_initMultIcon
* Purpose: Initializes state and dependencies for the engine module behavior.
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
* Purpose: Draws or renders output for the engine module behavior.
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
        V_DrawPatch(i.x, i.y, STlib_FG, p)
      end if
      i.oldinum = cur
    end if
  end if
end function

/*
* Function: STlib_initBinIcon
* Purpose: Initializes state and dependencies for the engine module behavior.
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
* Purpose: Draws or renders output for the engine module behavior.
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
        V_DrawPatch(b.x, b.y, STlib_FG, b.p)
      else
        V_CopyRect(x, y - ST_Y, STlib_BG, w, h, x, y, STlib_FG)
      end if
      b.oldval = v
    end if
  end if
end function

/*
* Function: STlib_updateNum
* Purpose: Advances per-tick logic for the engine module behavior.
*/
function STlib_updateNum(n, refresh)
  if _STL_RefBool(n.on) then STlib_drawNum(n, refresh) end if
end function

/*
* Function: STlib_updatePercent
* Purpose: Advances per-tick logic for the engine module behavior.
*/
function STlib_updatePercent(p, refresh)
  STlib_drawPercent(p, refresh)
end function

/*
* Function: STlib_updateMultIcon
* Purpose: Advances per-tick logic for the engine module behavior.
*/
function STlib_updateMultIcon(i, refresh)
  STlib_drawMultIcon(i, refresh)
end function

/*
* Function: STlib_updateBinIcon
* Purpose: Advances per-tick logic for the engine module behavior.
*/
function STlib_updateBinIcon(b, refresh)
  STlib_drawBinIcon(b, refresh)
end function



