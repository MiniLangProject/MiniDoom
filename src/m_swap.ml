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

//! Normalizes signed 16-bit values and byte-swaps 16- and 32-bit integers across host endianness.


/// Defines big endian for the m swap subsystem.
/// @internal
const __BIG_ENDIAN__ = false

/// Reverses the two bytes in the low 16 bits of an integer.
/// @param x Horizontal map- or screen-space coordinate.
function SwapSHORT(x)
  u = x & 0xFFFF
  return ((u >> 8) & 0xFF) |((u << 8) & 0xFF00)
end function

/// Reverses all four bytes of an integer's low 32-bit representation.
/// @param x Horizontal map- or screen-space coordinate.
function SwapLONG(x)
  u = x & 0xFFFFFFFF
  return ((u >> 24) & 0xFF) |
  ((u >> 8) & 0xFF00) |
  ((u << 8) & 0xFF0000) |
  ((u << 24) & 0xFF000000)
end function

/// Byte-swaps the low 16 bits and returns the result with signed 16-bit interpretation.
/// @param x Horizontal map- or screen-space coordinate.
function SHORT(x)
  if __BIG_ENDIAN__ then return SwapSHORT(x) end if
  return x
end function

/// Reverses all four bytes of a 32-bit value and returns the signed result.
/// @param x Horizontal map- or screen-space coordinate.
function LONG(x)
  if __BIG_ENDIAN__ then return SwapLONG(x) end if
  return x
end function



