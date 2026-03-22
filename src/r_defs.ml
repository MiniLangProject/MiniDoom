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

  Script: r_defs.ml
  Purpose: Implements renderer data preparation and software rendering pipeline stages.
*/
import doomdef
import m_fixed
import d_think
import p_mobj

const SIL_NONE = 0
const SIL_BOTTOM = 1
const SIL_TOP = 2
const SIL_BOTH = 3

const MAXDRAWSEGS = 256

/*
* Function: RDefs_U16LE
* Purpose: Implements the RDefs_U16LE routine for the engine module behavior.
*/
function inline RDefs_U16LE(b, off)
  return b[off] +(b[off + 1] * 256)
end function

/*
* Function: RDefs_I16LE
* Purpose: Implements the RDefs_I16LE routine for the engine module behavior.
*/
function inline RDefs_I16LE(b, off)
  x = RDefs_U16LE(b, off)
  if x >= 32768 then return x - 65536 end if
  return x
end function

/*
* Function: RDefs_U32LE
* Purpose: Implements the RDefs_U32LE routine for the engine module behavior.
*/
function inline RDefs_U32LE(b, off)
  return b[off] +(b[off + 1] * 256) +(b[off + 2] * 65536) +(b[off + 3] * 16777216)
end function

/*
* Function: RDefs_I32LE
* Purpose: Implements the RDefs_I32LE routine for the engine module behavior.
*/
function inline RDefs_I32LE(b, off)
  x = RDefs_U32LE(b, off)
  if x >= 2147483648 then return x - 4294967296 end if
  return x
end function

/*
* Function: Patch_Width
* Purpose: Implements the Patch_Width routine for the engine module behavior.
*/
function Patch_Width(patchBytes)
  return RDefs_I16LE(patchBytes, 0)
end function

/*
* Function: Patch_Height
* Purpose: Implements the Patch_Height routine for the engine module behavior.
*/
function Patch_Height(patchBytes)
  return RDefs_I16LE(patchBytes, 2)
end function

/*
* Function: Patch_LeftOffset
* Purpose: Reads or updates state used by the engine module behavior.
*/
function inline Patch_LeftOffset(patchBytes)
  return RDefs_I16LE(patchBytes, 4)
end function

/*
* Function: Patch_TopOffset
* Purpose: Reads or updates state used by the engine module behavior.
*/
function inline Patch_TopOffset(patchBytes)
  return RDefs_I16LE(patchBytes, 6)
end function

/*
* Function: Patch_ColumnOffset
* Purpose: Reads or updates state used by the engine module behavior.
*/
function inline Patch_ColumnOffset(patchBytes, colIndex)

  return RDefs_I32LE(patchBytes, 8 + colIndex * 4)
end function

/*
* Struct: vertex_t
* Purpose: Stores runtime data for vertex type.
*/
struct vertex_t
  x
  y
end struct

/*
* Struct: degenmobj_t
* Purpose: Stores runtime data for degenmobj type.
*/
struct degenmobj_t
  thinker
  x
  y
  z
end struct

/*
* Struct: sector_t
* Purpose: Stores runtime data for sector type.
*/
struct sector_t
  floorheight
  ceilingheight
  floorpic
  ceilingpic
  lightlevel
  special
  tag

  soundtraversed
  soundtarget
  blockbox
  soundorg

  validcount
  thinglist
  specialdata
  linecount
  lines
end struct

/*
* Struct: side_t
* Purpose: Stores runtime data for side type.
*/
struct side_t
  textureoffset
  rowoffset
  toptexture
  bottomtexture
  midtexture
  sector
end struct

/*
* Enum: slopetype_t
* Purpose: Defines named constants for slopetype type.
*/
enum slopetype_t
  ST_HORIZONTAL,
  ST_VERTICAL,
  ST_POSITIVE,
  ST_NEGATIVE
end enum

/*
* Struct: line_t
* Purpose: Stores runtime data for line type.
*/
struct line_t
  v1
  v2
  dx
  dy
  flags
  special
  tag
  sidenum
  bbox
  slopetype
  frontsector
  backsector
  validcount
  specialdata
end struct

/*
* Struct: subsector_t
* Purpose: Stores runtime data for subsector type.
*/
struct subsector_t
  sector
  numlines
  firstline
end struct

/*
* Struct: seg_t
* Purpose: Stores runtime data for seg type.
*/
struct seg_t
  v1
  v2
  offset
  angle
  sidedef
  linedef
  frontsector
  backsector
end struct

/*
* Struct: node_t
* Purpose: Stores runtime data for node type.
*/
struct node_t
  x
  y
  dx
  dy
  bbox
  children
end struct

/*
* Struct: post_t
* Purpose: Stores runtime data for post type.
*/
struct post_t
  topdelta
  length
end struct

/*
* Struct: drawseg_t
* Purpose: Stores runtime data for drawseg type.
*/
struct drawseg_t
  curline
  x1
  x2
  scale1
  scale2
  scalestep
  silhouette
  bsilheight
  tsilheight
  sprtopclip
  sprbottomclip
  maskedtexturecol
end struct

/*
* Struct: patch_t
* Purpose: Stores runtime data for patch type.
*/
struct patch_t
  width
  height
  leftoffset
  topoffset
  columnofs
end struct

/*
* Struct: vissprite_t
* Purpose: Stores runtime data for vissprite type.
*/
struct vissprite_t
  prev
  next
  x1
  x2
  gx
  gy
  gz
  gzt
  startfrac
  scale
  xiscale
  texturemid
  patch
  colormap
  mobjflags
end struct

/*
* Struct: spriteframe_t
* Purpose: Stores runtime data for spriteframe type.
*/
struct spriteframe_t
  rotate
  lump
  flip
end struct

/*
* Struct: spritedef_t
* Purpose: Stores runtime data for spritedef type.
*/
struct spritedef_t
  numframes
  spriteframes
end struct

/*
* Struct: visplane_t
* Purpose: Stores runtime data for visplane type.
*/
struct visplane_t
  height
  picnum
  lightlevel
  minx
  maxx
  top
  bottom
end struct



