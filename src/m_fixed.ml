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

  Script: m_fixed.ml
  Purpose: Provides shared math, utility, and low-level helper routines.
*/
import stdlib
import doomtype
import i_system

import std.math

const FRACBITS = 16
const FRACUNIT = 1 << FRACBITS

const _S32_MIN = -2147483648
const _S32_MAX = 2147483647

/*
* Function: _u32
* Purpose: Implements the _u32 routine for the internal module support.
*/
function inline _u32(x)
  if typeof(x) == "int" then
    return x & 0xFFFFFFFF
  end if
  if typeof(x) == "float" then
    if x >= 0 then
      return std.math.floor(x) & 0xFFFFFFFF
    end if
    return std.math.ceil(x) & 0xFFFFFFFF
  end if
  n = toNumber(x)
  if typeof(n) == "int" then return n & 0xFFFFFFFF end if
  if typeof(n) == "float" then
    if n >= 0 then return std.math.floor(n) & 0xFFFFFFFF end if
    return std.math.ceil(n) & 0xFFFFFFFF
  end if
  return 0
end function

/*
* Function: _s32
* Purpose: Implements the _s32 routine for the internal module support.
*/
function _s32(x)
  xi = 0
  if typeof(x) == "int" then
    xi = x
  else if typeof(x) == "float" then
    if x >= 0 then
      xi = std.math.floor(x)
    else
      xi = std.math.ceil(x)
    end if
  else
    n = toNumber(x)
    if typeof(n) == "int" then
      xi = n
    else if typeof(n) == "float" then
      if n >= 0 then
        xi = std.math.floor(n)
      else
        xi = std.math.ceil(n)
      end if
    else
      return 0
    end if
  end if
  v = xi & 0xFFFFFFFF
  if v >= 0x80000000 then
    return v - 0x100000000
  end if
  return v
end function

/*
* Function: _absS32
* Purpose: Implements the _absS32 routine for the internal module support.
*/
function inline _absS32(x)
  x = _s32(x)
  if x < 0 then return - x end if
  return x
end function

/*
* Function: _idivS32
* Purpose: Implements the _idivS32 routine for the internal module support.
*/
function inline _idivS32(a, b)
  if typeof(a) != "int" or typeof(b) != "int" or b == 0 then return 0 end if
  q = a / b
  if q >= 0 then return std.math.floor(q) end if
  return std.math.ceil(q)
end function

/*
* Function: FixedMul
* Purpose: Implements the FixedMul routine for the engine module behavior.
*/
function inline FixedMul(a, b)

  a = _s32(a)
  b = _s32(b)
  return _s32((a * b) >> FRACBITS)
end function

/*
* Function: FixedDiv
* Purpose: Implements the FixedDiv routine for the engine module behavior.
*/
function FixedDiv(a, b)
  a = _s32(a)
  b = _s32(b)

  if ((_absS32(a) >> 14) >= _absS32(b)) then
    if _s32(a ^ b) < 0 then
      return _S32_MIN
    end if
    return _S32_MAX
  end if

  return FixedDiv2(a, b)
end function

/*
* Function: FixedDiv2
* Purpose: Implements the FixedDiv2 routine for the engine module behavior.
*/
function inline FixedDiv2(a, b)
  a = _s32(a)
  b = _s32(b)

  if b == 0 then
    I_Error("FixedDiv: divide by zero")
    return 0
  end if

  num = a * FRACUNIT
  c = _idivS32(num, b)
  return _s32(c)
end function



