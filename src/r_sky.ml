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

  Script: r_sky.ml
  Purpose: Implements renderer data preparation and software rendering pipeline stages.
*/

const SKYFLATNAME = "F_SKY1"
const ANGLETOSKYSHIFT = 22
import m_fixed
import r_data

skyflatnum = 0
skytexture = 0
skytexturemid = 0

/*
* Function: R_InitSkyMap
* Purpose: Initializes state and dependencies for the renderer.
*/
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



