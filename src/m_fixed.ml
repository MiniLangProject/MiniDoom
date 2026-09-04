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

//! Implements Doom's signed 16.16 fixed-point multiply and divide with explicit 32-bit wrap, saturation, and
//! zero handling.

import stdlib
import doomtype
import i_system

import std.math

/// Defines fracbits for the m fixed subsystem.
const FRACBITS = 16
/// Defines fracunit for the m fixed subsystem.
const FRACUNIT = 1 << FRACBITS

/// Defines the minimum s32 min accepted by the m fixed subsystem.
/// @internal
const _S32_MIN = -2147483648
/// Defines the maximum s32 max accepted by the m fixed subsystem.
/// @internal
const _S32_MAX = 2147483647

/// Normalizes an integer to its unsigned 32-bit representation.
/// @param x Horizontal map- or screen-space coordinate.
/// @internal
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

/// Reinterprets the low 32 bits of an integer as a signed two's-complement value.
/// @param x Horizontal map- or screen-space coordinate.
/// @internal
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

/// Returns a signed 32-bit magnitude while saturating the unrepresentable INT32_MIN case.
/// @param x Horizontal map- or screen-space coordinate.
/// @internal
function inline _absS32(x)
  x = _s32(x)
  if x < 0 then return - x end if
  return x
end function

/// Returns a signed integer quotient truncated toward zero, or zero for invalid operands and a zero divisor.
/// @param a First input operand.
/// @param b Second input operand.
/// @internal
function inline _idivS32(a, b)
  if typeof(a) != "int" or typeof(b) != "int" or b == 0 then return 0 end if
  q = a / b
  if q >= 0 then return std.math.floor(q) end if
  return std.math.ceil(q)
end function

/// Multiplies two 16.16 fixed-point operands with a 64-bit intermediate and returns a signed 32-bit fixed-point
/// result.
/// @param a First input operand.
/// @param b Second input operand.
function inline FixedMul(a, b)

  a = _s32(a)
  b = _s32(b)
  return _s32((a * b) >> FRACBITS)
end function

/// Divides two signed 16.16 values, saturating results whose shifted numerator would overflow signed 32-bit
/// range.
/// @param a First input operand.
/// @param b Second input operand.
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

/// Scales a signed numerator by FRACUNIT, divides with truncation toward zero, and reports a zero divisor
/// through I_Error.
/// @param a First input operand.
/// @param b Second input operand.
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



