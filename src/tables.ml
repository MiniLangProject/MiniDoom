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

//! Provides precomputed lookup tables used by fixed-point math and rendering.

import m_fixed
import std.math
import tables

/// Defines pi for the tables subsystem.
const PI = 3.141592657

/// Defines fineangles for the tables subsystem.
const FINEANGLES = 8192
/// Defines finemask for the tables subsystem.
const FINEMASK = FINEANGLES - 1

/// Defines angletofineshift for the tables subsystem.
const ANGLETOFINESHIFT = 19

/// Holds the optional finesine resource used by the tables subsystem.
finesine = void
/// Holds the optional finecosine resource used by the tables subsystem.
finecosine = void
/// Holds the optional finetangent resource used by the tables subsystem.
finetangent = void

/// Holds the optional tantoangle resource used by the tables subsystem.
tantoangle = void

/// Defines ang45 for the tables subsystem.
const ANG45 = 0x20000000
/// Defines ang90 for the tables subsystem.
const ANG90 = 0x40000000
/// Defines ang180 for the tables subsystem.
const ANG180 = 0x80000000
/// Defines ang270 for the tables subsystem.
const ANG270 = 0xC0000000

/// Defines sloperange for the tables subsystem.
const SLOPERANGE = 2048
/// Defines slopebits for the tables subsystem.
const SLOPEBITS = 11
/// Defines dbits for the tables subsystem.
const DBITS = 5

/// Maps an unsigned rise/run ratio into Doom's bounded slope-table index without overflowing the numerator
/// shift.
/// @param num Index identifying the requested item.
/// @param den Den value supplied to `SlopeDiv`.
function SlopeDiv(num, den)

  num = num & 0xFFFFFFFF
  den = den & 0xFFFFFFFF

  if den < 512 then
    return SLOPERANGE
  end if

  den2 = den >> 8
  if den2 == 0 then
    return SLOPERANGE
  end if

  ans =(num << 3) & 0xFFFFFFFF
  rem = ans % den2
  q =(ans - rem) / den2
  if typeof(q) != "int" then
    q = std.math.floor(q)
  end if
  ans = q

  if ans <= SLOPERANGE then
    return ans
  end if
  return SLOPERANGE
end function

/// Truncates a numeric value toward zero for deterministic lookup-table generation.
/// @param v Value consumed by the operation.
/// @internal
function inline _TB_Trunc(v)
  if v >= 0 then
    return std.math.floor(v)
  end if
  return std.math.ceil(v)
end function

/// Lazily generates the fixed-point sine, cosine, tangent, and slope-to-angle lookup tables at their canonical
/// Doom sizes.
function Tables_Init()
  global finesine
  global finecosine
  global finetangent
  global tantoangle

  quarterFine = FINEANGLES >> 2
  halfFine = FINEANGLES >> 1
  nSineExpected =(5 * FINEANGLES) >> 2

  if typeof(finesine) == "array" and typeof(finecosine) == "array" and typeof(finetangent) == "array" and typeof(tantoangle) == "array" then
    if len(finesine) == nSineExpected and len(finecosine) == FINEANGLES and len(finetangent) == halfFine and len(tantoangle) ==(SLOPERANGE + 1) then
      return
    end if
  end if

  twoPi = 2.0 * PI
  fineStep = twoPi / FINEANGLES

  finesine =[]
  i = 0
  nSine = nSineExpected
  while i < nSine
    ang =(i + 0.5) * fineStep
    v = FRACUNIT * std.math.sin(ang)
    finesine = finesine +[_TB_Trunc(v)]
    i = i + 1
  end while

  finecosine =[]
  i = 0
  while i < FINEANGLES
    finecosine = finecosine +[finesine[i + quarterFine]]
    i = i + 1
  end while

  finetangent =[]
  i = 0
  nTan = halfFine
  while i < nTan
    ang =(i - quarterFine + 0.5) * fineStep
    tv = FRACUNIT * std.math.tan(ang)

    t = _TB_Trunc(tv)
    if t > 2147483647 then t = 2147483647 end if
    if t < -2147483648 then t = -2147483648 end if
    finetangent = finetangent +[t]
    i = i + 1
  end while

  tantoangle =[]
  i = 0
  while i <= SLOPERANGE
    ang = std.math.atan(i / SLOPERANGE)
    bam = std.math.round((ang / twoPi) * 4294967296.0)
    if bam < 0 then bam = 0 end if
    if bam > 2147483647 then bam = bam - 4294967296 end if
    tantoangle = tantoangle +[bam]
    i = i + 1
  end while
end function



