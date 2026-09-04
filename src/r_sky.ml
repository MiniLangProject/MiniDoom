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

//! Resolves the level sky flat and texture identifiers plus the vertical mapping origin used by sky columns.


/// Defines the skyflatname text used by the r sky subsystem.
const SKYFLATNAME = "F_SKY1"
/// Defines angletoskyshift for the r sky subsystem.
const ANGLETOSKYSHIFT = 22
import m_fixed
import r_data

/// Tracks the mutable skyflatnum value used by the r sky subsystem.
skyflatnum = 0
/// Tracks the mutable skytexture value used by the r sky subsystem.
skytexture = 0
/// Tracks the mutable skytexturemid value used by the r sky subsystem.
skytexturemid = 0

/// Resolves the sky flat and SKY1 texture indices and places the sky cylinder at the vanilla vertical midpoint.
function R_InitSkyMap()
  global skyflatnum
  global skytexture
  global skytexturemid

  sf = R_FlatNumForName(SKYFLATNAME)
  if typeof(sf) == "int" and sf >= 0 then
    skyflatnum = sf
  end if

  sk = R_CheckTextureNumForName("SKY1")
  if typeof(sk) == "int" and sk >= 0 then
    skytexture = sk
  else
    skytexture = 0
  end if

  skytexturemid = 100 * FRACUNIT
end function



