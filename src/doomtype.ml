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

//! Defines primitive numeric limits, byte masks, booleans, and legacy aliases used by translated Doom code.


/// Defines the maximum byte max accepted by the doomtype subsystem.
const BYTE_MAX = 0xFF
/// Defines byte mask for the doomtype subsystem.
const BYTE_MASK = 0xFF

/// Defines the maximum maxchar accepted by the doomtype subsystem.
const MAXCHAR = 0x7f
/// Defines the maximum maxshort accepted by the doomtype subsystem.
const MAXSHORT = 0x7fff
/// Defines the maximum maxint accepted by the doomtype subsystem.
const MAXINT = 0x7fffffff
/// Defines the maximum maxlong accepted by the doomtype subsystem.
const MAXLONG = 0x7fffffff

/// Defines the minimum minchar accepted by the doomtype subsystem.
const MINCHAR = 0x80
/// Defines the minimum minshort accepted by the doomtype subsystem.
const MINSHORT = 0x8000
/// Defines the minimum minint accepted by the doomtype subsystem.
const MININT = 0x80000000
/// Defines the minimum minlong accepted by the doomtype subsystem.
const MINLONG = 0x80000000

/// Converts byte values for the engine.
/// @param x Horizontal map- or screen-space coordinate.
function inline asByte(x)
  return x & BYTE_MASK
end function



