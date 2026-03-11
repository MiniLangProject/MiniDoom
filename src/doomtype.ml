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

  Script: doomtype.ml
  Purpose: Contains Doom engine module logic for this subsystem.
*/

const BYTE_MAX = 0xFF
const BYTE_MASK = 0xFF

const MAXCHAR = 0x7f
const MAXSHORT = 0x7fff
const MAXINT = 0x7fffffff
const MAXLONG = 0x7fffffff

const MINCHAR = 0x80
const MINSHORT = 0x8000
const MININT = 0x80000000
const MINLONG = 0x80000000

/*
* Function: asByte
* Purpose: Implements the asByte routine for the engine module behavior.
*/
function asByte(x)
  return x & BYTE_MASK
end function



