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

  Script: m_swap.ml
  Purpose: Provides shared math, utility, and low-level helper routines.
*/

const __BIG_ENDIAN__ = false

/*
* Function: SwapSHORT
* Purpose: Implements the SwapSHORT routine for the engine module behavior.
*/
function SwapSHORT(x)
  u = x & 0xFFFF
  return ((u >> 8) & 0xFF) |((u << 8) & 0xFF00)
end function

/*
* Function: SwapLONG
* Purpose: Implements the SwapLONG routine for the engine module behavior.
*/
function SwapLONG(x)
  u = x & 0xFFFFFFFF
  return ((u >> 24) & 0xFF) |
  ((u >> 8) & 0xFF00) |
  ((u << 8) & 0xFF0000) |
  ((u << 24) & 0xFF000000)
end function

/*
* Function: SHORT
* Purpose: Implements the SHORT routine for the engine module behavior.
*/
function SHORT(x)
  if __BIG_ENDIAN__ then return SwapSHORT(x) end if
  return x
end function

/*
* Function: LONG
* Purpose: Implements the LONG routine for the engine module behavior.
*/
function LONG(x)
  if __BIG_ENDIAN__ then return SwapLONG(x) end if
  return x
end function



