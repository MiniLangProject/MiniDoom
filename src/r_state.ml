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

  Script: r_state.ml
  Purpose: Implements renderer data preparation and software rendering pipeline stages.
*/
import d_player
import r_data

textureheight = void
spritewidth = void
spriteoffset = void
spritetopoffset = void
colormaps = void

viewwidth = 0
scaledviewwidth = 0
viewheight = 0

firstflat = 0
flattranslation = void
texturetranslation = void

firstspritelump = 0
lastspritelump = 0
numspritelumps = 0

numsprites = 0
sprites = void

numvertexes = 0
vertexes = void

numsegs = 0
segs = void

numsectors = 0
sectors = void

numsubsectors = 0
subsectors = void

numnodes = 0
nodes = void

numlines = 0
lines = void

numsides = 0
sides = void

viewx = 0
viewy = 0
viewz = 0
viewangle = 0
viewplayer = void

clipangle = 0

viewangletox = void

xtoviewangle = void

rw_distance = 0
rw_normalangle = 0
rw_angle1 = 0

sscount = 0
floorplane = void
ceilingplane = void



