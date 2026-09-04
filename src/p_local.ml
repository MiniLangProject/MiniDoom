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

//! Defines shared play-simulation constants, traversal records, blockmap state, and collision result globals.

import r_local
import p_spec

/// Defines floatspeed for the p local subsystem.
const FLOATSPEED = 262144

/// Defines the maximum maxhealth accepted by the p local subsystem.
const MAXHEALTH = 100
/// Defines viewheight for the p local subsystem.
const VIEWHEIGHT = 2686976

/// Defines mapblockunits for the p local subsystem.
const MAPBLOCKUNITS = 128
/// Defines mapblocksize for the p local subsystem.
const MAPBLOCKSIZE = 8388608
/// Defines mapblockshift for the p local subsystem.
const MAPBLOCKSHIFT = 23
/// Defines mapbmask for the p local subsystem.
const MAPBMASK = 8388607
/// Defines mapbtofrac for the p local subsystem.
const MAPBTOFRAC = 7

/// Defines playerradius for the p local subsystem.
const PLAYERRADIUS = 1048576
/// Defines the maximum maxradius accepted by the p local subsystem.
const MAXRADIUS = 2097152

/// Defines gravity for the p local subsystem.
const GRAVITY = 65536
/// Defines the maximum maxmove accepted by the p local subsystem.
const MAXMOVE = 1966080

/// Defines userange for the p local subsystem.
const USERANGE = 4194304
/// Defines meleerange for the p local subsystem.
const MELEERANGE = 4194304
/// Defines missilerange for the p local subsystem.
const MISSILERANGE = 134217728

/// Defines basethreshold for the p local subsystem.
const BASETHRESHOLD = 100

/// Defines onfloorz for the p local subsystem.
const ONFLOORZ = -2147483648
/// Defines onceilingz for the p local subsystem.
const ONCEILINGZ = 2147483647

/// Describes divline geometry or asset data used by the play simulation system.
struct divline_t
  /// Horizontal map- or screen-space coordinate stored by `divline_t`
  x
  /// Vertical map- or screen-space coordinate stored by `divline_t`
  y
  /// Horizontal direction or extent stored by `divline_t`
  dx
  /// Vertical direction or extent stored by `divline_t`
  dy
end struct

/// Records the fractional position and line-or-thing payload of one path-traversal intersection.
struct intercept_t
  /// Stores frac for `intercept_t`
  frac
  /// Stores isaline for `intercept_t`
  isaline
  /// Stores thing for `intercept_t`
  thing
  /// Stores line for `intercept_t`
  line
end struct

/// Defines the maximum maxintercepts accepted by the p local subsystem.
const MAXINTERCEPTS = 128

/// Stores the intercepts collection used by the p local subsystem.
intercepts =[]
/// Tracks the mutable intercept p value used by the p local subsystem.
intercept_p = 0
/// Tracks the mutable trace value used by the p local subsystem.
trace = divline_t(0, 0, 0, 0)

/// Tracks the mutable opentop value used by the p local subsystem.
opentop = 0
/// Tracks the mutable openbottom value used by the p local subsystem.
openbottom = 0
/// Tracks the mutable openrange value used by the p local subsystem.
openrange = 0
/// Tracks the mutable lowfloor value used by the p local subsystem.
lowfloor = 0

/// Tracks whether floatok is active in the p local subsystem.
floatok = false
/// Tracks the mutable tmfloorz value used by the p local subsystem.
tmfloorz = 0
/// Tracks the mutable tmceilingz value used by the p local subsystem.
tmceilingz = 0
/// Holds the optional ceilingline resource used by the p local subsystem.
ceilingline = void
/// Holds the optional linetarget resource used by the p local subsystem.
linetarget = void

/// Holds the optional rejectmatrix resource used by the p local subsystem.
rejectmatrix = void
/// Holds the optional blockmaplump resource used by the p local subsystem.
blockmaplump = void
/// Holds the optional blockmap resource used by the p local subsystem.
blockmap = void
/// Tracks the mutable bmapwidth value used by the p local subsystem.
bmapwidth = 0
/// Tracks the mutable bmapheight value used by the p local subsystem.
bmapheight = 0
/// Tracks the mutable bmaporgx value used by the p local subsystem.
bmaporgx = 0
/// Tracks the mutable bmaporgy value used by the p local subsystem.
bmaporgy = 0
/// Holds the optional blocklinks resource used by the p local subsystem.
blocklinks = void



