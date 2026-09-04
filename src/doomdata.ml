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

//! Defines on-disk WAD map record layouts and lump-order constants used while decoding Doom levels.

import doomtype
import doomdef

/// Defines ml label for the doomdata subsystem.
const ML_LABEL = 0
/// Defines ml things for the doomdata subsystem.
const ML_THINGS = 1
/// Defines ml linedefs for the doomdata subsystem.
const ML_LINEDEFS = 2
/// Defines ml sidedefs for the doomdata subsystem.
const ML_SIDEDEFS = 3
/// Defines ml vertexes for the doomdata subsystem.
const ML_VERTEXES = 4
/// Defines ml segs for the doomdata subsystem.
const ML_SEGS = 5
/// Defines ml ssectors for the doomdata subsystem.
const ML_SSECTORS = 6
/// Defines ml nodes for the doomdata subsystem.
const ML_NODES = 7
/// Defines ml sectors for the doomdata subsystem.
const ML_SECTORS = 8
/// Defines ml reject for the doomdata subsystem.
const ML_REJECT = 9
/// Defines ml blockmap for the doomdata subsystem.
const ML_BLOCKMAP = 10

/// Describes mapvertex geometry or asset data used by the Doom shared system.
struct mapvertex_t
  /// Horizontal map- or screen-space coordinate stored by `mapvertex_t`
  x
  /// Vertical map- or screen-space coordinate stored by `mapvertex_t`
  y
end struct

/// Describes mapsidedef geometry or asset data used by the Doom shared system.
struct mapsidedef_t
  /// Stores textureoffset for `mapsidedef_t`
  textureoffset
  /// Stores rowoffset for `mapsidedef_t`
  rowoffset
  /// Stores toptexture for `mapsidedef_t`
  toptexture
  /// Stores bottomtexture for `mapsidedef_t`
  bottomtexture
  /// Stores midtexture for `mapsidedef_t`
  midtexture
  /// Stores sector for `mapsidedef_t`
  sector
end struct

/// Describes maplinedef geometry or asset data used by the Doom shared system.
struct maplinedef_t
  /// Stores v1 for `maplinedef_t`
  v1
  /// Stores v2 for `maplinedef_t`
  v2
  /// Bit flags controlling this record's behavior stored by `maplinedef_t`
  flags
  /// Stores special for `maplinedef_t`
  special
  /// Stores tag for `maplinedef_t`
  tag
  /// Stores sidenum for `maplinedef_t`
  sidenum
end struct

/// Defines ml blocking for the doomdata subsystem.
const ML_BLOCKING = 1
/// Defines ml blockmonsters for the doomdata subsystem.
const ML_BLOCKMONSTERS = 2
/// Defines ml twosided for the doomdata subsystem.
const ML_TWOSIDED = 4
/// Defines ml dontpegtop for the doomdata subsystem.
const ML_DONTPEGTOP = 8
/// Defines ml dontpegbottom for the doomdata subsystem.
const ML_DONTPEGBOTTOM = 16
/// Defines ml secret for the doomdata subsystem.
const ML_SECRET = 32
/// Defines ml soundblock for the doomdata subsystem.
const ML_SOUNDBLOCK = 64
/// Defines ml dontdraw for the doomdata subsystem.
const ML_DONTDRAW = 128
/// Defines ml mapped for the doomdata subsystem.
const ML_MAPPED = 256

/// Describes mapsector geometry or asset data used by the Doom shared system.
struct mapsector_t
  /// Stores floorheight for `mapsector_t`
  floorheight
  /// Stores ceilingheight for `mapsector_t`
  ceilingheight
  /// Stores floorpic for `mapsector_t`
  floorpic
  /// Stores ceilingpic for `mapsector_t`
  ceilingpic
  /// Stores lightlevel for `mapsector_t`
  lightlevel
  /// Stores special for `mapsector_t`
  special
  /// Stores tag for `mapsector_t`
  tag
end struct

/// Describes mapsubsector geometry or asset data used by the Doom shared system.
struct mapsubsector_t
  /// Stores numsegs for `mapsubsector_t`
  numsegs
  /// Stores firstseg for `mapsubsector_t`
  firstseg
end struct

/// Describes mapseg geometry or asset data used by the Doom shared system.
struct mapseg_t
  /// Stores v1 for `mapseg_t`
  v1
  /// Stores v2 for `mapseg_t`
  v2
  /// Doom binary-angle orientation stored by `mapseg_t`
  angle
  /// Stores linedef for `mapseg_t`
  linedef
  /// Stores side for `mapseg_t`
  side
  /// Stores offset for `mapseg_t`
  offset
end struct

/// Defines nf subsector for the doomdata subsystem.
const NF_SUBSECTOR = 0x8000

/// Describes mapnode geometry or asset data used by the Doom shared system.
struct mapnode_t
  /// Horizontal map- or screen-space coordinate stored by `mapnode_t`
  x
  /// Vertical map- or screen-space coordinate stored by `mapnode_t`
  y
  /// Horizontal direction or extent stored by `mapnode_t`
  dx
  /// Vertical direction or extent stored by `mapnode_t`
  dy

  /// Stores bbox for `mapnode_t`
  bbox
  /// Stores children for `mapnode_t`
  children
end struct

/// Mirrors one THINGS lump record: map position, facing angle, type number, and spawn-option flags.
struct mapthing_t
  /// Horizontal map- or screen-space coordinate stored by `mapthing_t`
  x
  /// Vertical map- or screen-space coordinate stored by `mapthing_t`
  y
  /// Doom binary-angle orientation stored by `mapthing_t`
  angle
  /// Kind discriminator for this record stored by `mapthing_t`
  type
  /// Stores options for `mapthing_t`
  options
end struct



