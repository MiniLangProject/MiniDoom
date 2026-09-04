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

//! Owns mutable texture/sprite metrics, view geometry, clipping, lighting, and camera state shared by renderer
//! passes.

import d_player
import r_data

/// Holds the optional textureheight resource used by the r state subsystem.
textureheight = void
/// Holds the optional spritewidth resource used by the r state subsystem.
spritewidth = void
/// Holds the optional spriteoffset resource used by the r state subsystem.
spriteoffset = void
/// Holds the optional spritetopoffset resource used by the r state subsystem.
spritetopoffset = void
/// Holds the optional colormaps resource used by the r state subsystem.
colormaps = void

/// Tracks the mutable viewwidth value used by the r state subsystem.
viewwidth = 0
/// Tracks the mutable scaledviewwidth value used by the r state subsystem.
scaledviewwidth = 0
/// Tracks the mutable viewheight value used by the r state subsystem.
viewheight = 0

/// Tracks the mutable firstflat value used by the r state subsystem.
firstflat = 0
/// Holds the optional flattranslation resource used by the r state subsystem.
flattranslation = void
/// Holds the optional texturetranslation resource used by the r state subsystem.
texturetranslation = void

/// Tracks the mutable firstspritelump value used by the r state subsystem.
firstspritelump = 0
/// Tracks the mutable lastspritelump value used by the r state subsystem.
lastspritelump = 0
/// Tracks the mutable numspritelumps value used by the r state subsystem.
numspritelumps = 0

/// Tracks the mutable numsprites value used by the r state subsystem.
numsprites = 0
/// Holds the optional sprites resource used by the r state subsystem.
sprites = void

/// Tracks the mutable numvertexes value used by the r state subsystem.
numvertexes = 0
/// Holds the optional vertexes resource used by the r state subsystem.
vertexes = void

/// Tracks the mutable numsegs value used by the r state subsystem.
numsegs = 0
/// Holds the optional segs resource used by the r state subsystem.
segs = void

/// Tracks the mutable numsectors value used by the r state subsystem.
numsectors = 0
/// Holds the optional sectors resource used by the r state subsystem.
sectors = void

/// Tracks the mutable numsubsectors value used by the r state subsystem.
numsubsectors = 0
/// Holds the optional subsectors resource used by the r state subsystem.
subsectors = void

/// Tracks the mutable numnodes value used by the r state subsystem.
numnodes = 0
/// Holds the optional nodes resource used by the r state subsystem.
nodes = void

/// Tracks the mutable numlines value used by the r state subsystem.
numlines = 0
/// Holds the optional lines resource used by the r state subsystem.
lines = void

/// Tracks the mutable numsides value used by the r state subsystem.
numsides = 0
/// Holds the optional sides resource used by the r state subsystem.
sides = void

/// Tracks the mutable viewx value used by the r state subsystem.
viewx = 0
/// Tracks the mutable viewy value used by the r state subsystem.
viewy = 0
/// Tracks the mutable viewz value used by the r state subsystem.
viewz = 0
/// Tracks the mutable viewangle value used by the r state subsystem.
viewangle = 0
/// Holds the optional viewplayer resource used by the r state subsystem.
viewplayer = void

/// Tracks the mutable clipangle value used by the r state subsystem.
clipangle = 0

/// Holds the optional viewangletox resource used by the r state subsystem.
viewangletox = void

/// Holds the optional xtoviewangle resource used by the r state subsystem.
xtoviewangle = void

/// Tracks the mutable rw distance value used by the r state subsystem.
rw_distance = 0
/// Tracks the mutable rw normalangle value used by the r state subsystem.
rw_normalangle = 0
/// Tracks the mutable rw angle1 value used by the r state subsystem.
rw_angle1 = 0

/// Tracks the mutable sscount value used by the r state subsystem.
sscount = 0
/// Holds the optional floorplane resource used by the r state subsystem.
floorplane = void
/// Holds the optional ceilingplane resource used by the r state subsystem.
ceilingplane = void



