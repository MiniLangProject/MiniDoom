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

  Script: tables.ml
  Purpose: Provides precomputed lookup tables used by fixed-point math and rendering.
*/
import m_fixed
import std.math
import tables

const PI = 3.141592657

const FINEANGLES = 8192
const FINEMASK = FINEANGLES - 1

const ANGLETOFINESHIFT = 19

finesine = void
finecosine = void
finetangent = void

tantoangle = void

const ANG45 = 0x20000000
const ANG90 = 0x40000000
const ANG180 = 0x80000000
const ANG270 = 0xC0000000

const SLOPERANGE = 2048
const SLOPEBITS = 11
const DBITS = 5

/*
* Function: SlopeDiv
* Purpose: Implements the SlopeDiv routine for the engine module behavior.
*/
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

/*
* Function: _TB_Trunc
* Purpose: Implements the _TB_Trunc routine for the internal module support.
*/
function inline _TB_Trunc(v)
  if v >= 0 then
    return std.math.floor(v)
  end if
  return std.math.ceil(v)
end function

/*
* Function: Tables_Init
* Purpose: Initializes state and dependencies for the engine module behavior.
*/
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



