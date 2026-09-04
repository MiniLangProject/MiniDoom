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

//! Defines map/render geometry records and decodes Doom patch headers consumed by software rasterization.

import doomdef
import m_fixed
import d_think
import p_mobj

/// Defines sil none for the r defs subsystem.
const SIL_NONE = 0
/// Defines sil bottom for the r defs subsystem.
const SIL_BOTTOM = 1
/// Defines sil top for the r defs subsystem.
const SIL_TOP = 2
/// Defines sil both for the r defs subsystem.
const SIL_BOTH = 3

/// Defines the maximum maxdrawsegs accepted by the r defs subsystem.
const MAXDRAWSEGS = 256

/// Decodes an unsigned 16-bit little-endian field from renderer resource bytes.
/// @param b Second input operand.
/// @param off Zero-based byte or element offset.
function inline RDefs_U16LE(b, off)
  return b[off] +(b[off + 1] * 256)
end function

/// Decodes a two-byte little-endian field with signed 16-bit interpretation.
/// @param b Second input operand.
/// @param off Zero-based byte or element offset.
function inline RDefs_I16LE(b, off)
  x = RDefs_U16LE(b, off)
  if x >= 32768 then return x - 65536 end if
  return x
end function

/// Decodes an unsigned 32-bit little-endian field from renderer resource bytes.
/// @param b Second input operand.
/// @param off Zero-based byte or element offset.
function inline RDefs_U32LE(b, off)
  return b[off] +(b[off + 1] * 256) +(b[off + 2] * 65536) +(b[off + 3] * 16777216)
end function

/// Decodes a four-byte little-endian field with signed 32-bit interpretation.
/// @param b Second input operand.
/// @param off Zero-based byte or element offset.
function inline RDefs_I32LE(b, off)
  x = RDefs_U32LE(b, off)
  if x >= 2147483648 then return x - 4294967296 end if
  return x
end function

/// Returns the signed pixel width stored at the start of a Doom patch header.
/// @param patchBytes Patch bytes value supplied to `Patch_Width`.
function Patch_Width(patchBytes)
  return RDefs_I16LE(patchBytes, 0)
end function

/// Returns the signed pixel height stored in a Doom patch header.
/// @param patchBytes Patch bytes value supplied to `Patch_Height`.
function Patch_Height(patchBytes)
  return RDefs_I16LE(patchBytes, 2)
end function

/// Returns the signed horizontal origin offset used to place a Doom patch.
/// @param patchBytes Patch bytes value supplied to `Patch_LeftOffset`.
function inline Patch_LeftOffset(patchBytes)
  return RDefs_I16LE(patchBytes, 4)
end function

/// Returns the signed vertical origin offset used to place a Doom patch.
/// @param patchBytes Patch bytes value supplied to `Patch_TopOffset`.
function inline Patch_TopOffset(patchBytes)
  return RDefs_I16LE(patchBytes, 6)
end function

/// Decodes the file-relative byte offset of one column stream from a Doom patch directory.
/// @param patchBytes Patch bytes value supplied to `Patch_ColumnOffset`.
/// @param colIndex Index identifying col.
function inline Patch_ColumnOffset(patchBytes, colIndex)

  return RDefs_I32LE(patchBytes, 8 + colIndex * 4)
end function

/// Describes vertex geometry or asset data used by the renderer system.
struct vertex_t
  /// Horizontal map- or screen-space coordinate stored by `vertex_t`
  x
  /// Vertical map- or screen-space coordinate stored by `vertex_t`
  y
end struct

/// Supplies a position-only pseudo-mobj used as a sector's spatial sound origin.
struct degenmobj_t
  /// Stores thinker for `degenmobj_t`
  thinker
  /// Horizontal map- or screen-space coordinate stored by `degenmobj_t`
  x
  /// Vertical map- or screen-space coordinate stored by `degenmobj_t`
  y
  /// Vertical world-space coordinate stored by `degenmobj_t`
  z
end struct

/// Describes sector geometry or asset data used by the renderer system.
struct sector_t
  /// Stores floorheight for `sector_t`
  floorheight
  /// Stores ceilingheight for `sector_t`
  ceilingheight
  /// Stores floorpic for `sector_t`
  floorpic
  /// Stores ceilingpic for `sector_t`
  ceilingpic
  /// Stores lightlevel for `sector_t`
  lightlevel
  /// Stores special for `sector_t`
  special
  /// Stores tag for `sector_t`
  tag

  /// Stores soundtraversed for `sector_t`
  soundtraversed
  /// Stores soundtarget for `sector_t`
  soundtarget
  /// Stores blockbox for `sector_t`
  blockbox
  /// Stores soundorg for `sector_t`
  soundorg

  /// Stores validcount for `sector_t`
  validcount
  /// Stores thinglist for `sector_t`
  thinglist
  /// Stores specialdata for `sector_t`
  specialdata
  /// Stores linecount for `sector_t`
  linecount
  /// Stores lines for `sector_t`
  lines
end struct

/// Describes side geometry or asset data used by the renderer system.
struct side_t
  /// Stores textureoffset for `side_t`
  textureoffset
  /// Stores rowoffset for `side_t`
  rowoffset
  /// Stores toptexture for `side_t`
  toptexture
  /// Stores bottomtexture for `side_t`
  bottomtexture
  /// Stores midtexture for `side_t`
  midtexture
  /// Stores sector for `side_t`
  sector
end struct

/// Classifies linedef direction as horizontal, vertical, positive slope, or negative slope for fast geometry
/// tests.
enum slopetype_t
  /// Represents st horizontal in `slopetype_t`
  ST_HORIZONTAL,
  /// Represents st vertical in `slopetype_t`
  ST_VERTICAL,
  /// Represents st positive in `slopetype_t`
  ST_POSITIVE,
  /// Represents st negative in `slopetype_t`
  ST_NEGATIVE
end enum

/// Describes line geometry or asset data used by the renderer system.
struct line_t
  /// Stores v1 for `line_t`
  v1
  /// Stores v2 for `line_t`
  v2
  /// Horizontal direction or extent stored by `line_t`
  dx
  /// Vertical direction or extent stored by `line_t`
  dy
  /// Bit flags controlling this record's behavior stored by `line_t`
  flags
  /// Stores special for `line_t`
  special
  /// Stores tag for `line_t`
  tag
  /// Stores sidenum for `line_t`
  sidenum
  /// Stores bbox for `line_t`
  bbox
  /// Stores slopetype for `line_t`
  slopetype
  /// Stores frontsector for `line_t`
  frontsector
  /// Stores backsector for `line_t`
  backsector
  /// Stores validcount for `line_t`
  validcount
  /// Stores specialdata for `line_t`
  specialdata
end struct

/// Describes subsector geometry or asset data used by the renderer system.
struct subsector_t
  /// Stores sector for `subsector_t`
  sector
  /// Stores numlines for `subsector_t`
  numlines
  /// Stores firstline for `subsector_t`
  firstline
end struct

/// Describes seg geometry or asset data used by the renderer system.
struct seg_t
  /// Stores v1 for `seg_t`
  v1
  /// Stores v2 for `seg_t`
  v2
  /// Stores offset for `seg_t`
  offset
  /// Doom binary-angle orientation stored by `seg_t`
  angle
  /// Stores sidedef for `seg_t`
  sidedef
  /// Stores linedef for `seg_t`
  linedef
  /// Stores frontsector for `seg_t`
  frontsector
  /// Stores backsector for `seg_t`
  backsector
end struct

/// Describes node geometry or asset data used by the renderer system.
struct node_t
  /// Horizontal map- or screen-space coordinate stored by `node_t`
  x
  /// Vertical map- or screen-space coordinate stored by `node_t`
  y
  /// Horizontal direction or extent stored by `node_t`
  dx
  /// Vertical direction or extent stored by `node_t`
  dy
  /// Stores bbox for `node_t`
  bbox
  /// Stores children for `node_t`
  children
end struct

/// Represents a decoded Doom patch-column run by its starting row and pixel count.
struct post_t
  /// Stores topdelta for `post_t`
  topdelta
  /// Stores length for `post_t`
  length
end struct

/// Describes drawseg geometry or asset data used by the renderer system.
struct drawseg_t
  /// Stores curline for `drawseg_t`
  curline
  /// Stores x1 for `drawseg_t`
  x1
  /// Stores x2 for `drawseg_t`
  x2
  /// Stores scale1 for `drawseg_t`
  scale1
  /// Stores scale2 for `drawseg_t`
  scale2
  /// Stores scalestep for `drawseg_t`
  scalestep
  /// Stores silhouette for `drawseg_t`
  silhouette
  /// Stores bsilheight for `drawseg_t`
  bsilheight
  /// Stores tsilheight for `drawseg_t`
  tsilheight
  /// Stores sprtopclip for `drawseg_t`
  sprtopclip
  /// Stores sprbottomclip for `drawseg_t`
  sprbottomclip
  /// Stores maskedtexturecol for `drawseg_t`
  maskedtexturecol
end struct

/// Describes patch geometry or asset data used by the renderer system.
struct patch_t
  /// Width in pixels or map units stored by `patch_t`
  width
  /// Height in pixels or map units stored by `patch_t`
  height
  /// Stores leftoffset for `patch_t`
  leftoffset
  /// Stores topoffset for `patch_t`
  topoffset
  /// Stores columnofs for `patch_t`
  columnofs
end struct

/// Describes vissprite geometry or asset data used by the renderer system.
struct vissprite_t
  /// Previous linked record in traversal order stored by `vissprite_t`
  prev
  /// Next linked record in traversal order stored by `vissprite_t`
  next
  /// Stores x1 for `vissprite_t`
  x1
  /// Stores x2 for `vissprite_t`
  x2
  /// Stores gx for `vissprite_t`
  gx
  /// Stores gy for `vissprite_t`
  gy
  /// Stores gz for `vissprite_t`
  gz
  /// Stores gzt for `vissprite_t`
  gzt
  /// Stores startfrac for `vissprite_t`
  startfrac
  /// Stores scale for `vissprite_t`
  scale
  /// Stores xiscale for `vissprite_t`
  xiscale
  /// Stores texturemid for `vissprite_t`
  texturemid
  /// Stores patch for `vissprite_t`
  patch
  /// Stores colormap for `vissprite_t`
  colormap
  /// Stores mobjflags for `vissprite_t`
  mobjflags
end struct

/// Describes spriteframe geometry or asset data used by the renderer system.
struct spriteframe_t
  /// Stores rotate for `spriteframe_t`
  rotate
  /// Stores lump for `spriteframe_t`
  lump
  /// Stores flip for `spriteframe_t`
  flip
end struct

/// Describes spritedef geometry or asset data used by the renderer system.
struct spritedef_t
  /// Stores numframes for `spritedef_t`
  numframes
  /// Stores spriteframes for `spritedef_t`
  spriteframes
end struct

/// Describes visplane geometry or asset data used by the renderer system.
struct visplane_t
  /// Height in pixels or map units stored by `visplane_t`
  height
  /// Stores picnum for `visplane_t`
  picnum
  /// Stores lightlevel for `visplane_t`
  lightlevel
  /// Stores minx for `visplane_t`
  minx
  /// Stores maxx for `visplane_t`
  maxx
  /// Stores top for `visplane_t`
  top
  /// Stores bottom for `visplane_t`
  bottom
end struct



