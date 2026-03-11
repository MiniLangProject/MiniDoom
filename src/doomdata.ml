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

  Script: doomdata.ml
  Purpose: Contains Doom engine module logic for this subsystem.
*/
import doomtype
import doomdef

const ML_LABEL = 0
const ML_THINGS = 1
const ML_LINEDEFS = 2
const ML_SIDEDEFS = 3
const ML_VERTEXES = 4
const ML_SEGS = 5
const ML_SSECTORS = 6
const ML_NODES = 7
const ML_SECTORS = 8
const ML_REJECT = 9
const ML_BLOCKMAP = 10

/*
* Struct: mapvertex_t
* Purpose: Stores runtime data for mapvertex type.
*/
struct mapvertex_t
  x
  y
end struct

/*
* Struct: mapsidedef_t
* Purpose: Stores runtime data for mapsidedef type.
*/
struct mapsidedef_t
  textureoffset
  rowoffset
  toptexture
  bottomtexture
  midtexture
  sector
end struct

/*
* Struct: maplinedef_t
* Purpose: Stores runtime data for maplinedef type.
*/
struct maplinedef_t
  v1
  v2
  flags
  special
  tag
  sidenum
end struct

const ML_BLOCKING = 1
const ML_BLOCKMONSTERS = 2
const ML_TWOSIDED = 4
const ML_DONTPEGTOP = 8
const ML_DONTPEGBOTTOM = 16
const ML_SECRET = 32
const ML_SOUNDBLOCK = 64
const ML_DONTDRAW = 128
const ML_MAPPED = 256

/*
* Struct: mapsector_t
* Purpose: Stores runtime data for mapsector type.
*/
struct mapsector_t
  floorheight
  ceilingheight
  floorpic
  ceilingpic
  lightlevel
  special
  tag
end struct

/*
* Struct: mapsubsector_t
* Purpose: Stores runtime data for mapsubsector type.
*/
struct mapsubsector_t
  numsegs
  firstseg
end struct

/*
* Struct: mapseg_t
* Purpose: Stores runtime data for mapseg type.
*/
struct mapseg_t
  v1
  v2
  angle
  linedef
  side
  offset
end struct

const NF_SUBSECTOR = 0x8000

/*
* Struct: mapnode_t
* Purpose: Stores runtime data for mapnode type.
*/
struct mapnode_t
  x
  y
  dx
  dy

  bbox
  children
end struct

/*
* Struct: mapthing_t
* Purpose: Stores runtime data for mapthing type.
*/
struct mapthing_t
  x
  y
  angle
  type
  options
end struct



