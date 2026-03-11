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

  Script: p_local.ml
  Purpose: Implements core gameplay simulation: map logic, physics, AI, and world interaction.
*/
import r_local
import p_spec

const FLOATSPEED = 262144

const MAXHEALTH = 100
const VIEWHEIGHT = 2686976

const MAPBLOCKUNITS = 128
const MAPBLOCKSIZE = 8388608
const MAPBLOCKSHIFT = 23
const MAPBMASK = 8388607
const MAPBTOFRAC = 7

const PLAYERRADIUS = 1048576
const MAXRADIUS = 2097152

const GRAVITY = 65536
const MAXMOVE = 1966080

const USERANGE = 4194304
const MELEERANGE = 4194304
const MISSILERANGE = 134217728

const BASETHRESHOLD = 100

const ONFLOORZ = -2147483648
const ONCEILINGZ = 2147483647

/*
* Struct: divline_t
* Purpose: Stores runtime data for divline type.
*/
struct divline_t
  x
  y
  dx
  dy
end struct

/*
* Struct: intercept_t
* Purpose: Stores runtime data for intercept type.
*/
struct intercept_t
  frac
  isaline
  thing
  line
end struct

const MAXINTERCEPTS = 128

intercepts =[]
intercept_p = 0
trace = divline_t(0, 0, 0, 0)

opentop = 0
openbottom = 0
openrange = 0
lowfloor = 0

floatok = false
tmfloorz = 0
tmceilingz = 0
ceilingline = void
linetarget = void

rejectmatrix = void
blockmaplump = void
blockmap = void
bmapwidth = 0
bmapheight = 0
bmaporgx = 0
bmaporgy = 0
blocklinks = void



