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

//! Defines weapon state-machine metadata and the canonical table describing every player weapon.

import doomdef
import info

/// Describes a weapon's ammo type and ready, fire, lower, and raise states for the player weapon state machine.
struct weaponinfo_t
  /// Stores ammo for `weaponinfo_t`
  ammo
  /// Stores upstate for `weaponinfo_t`
  upstate
  /// Stores downstate for `weaponinfo_t`
  downstate
  /// Stores readystate for `weaponinfo_t`
  readystate
  /// Stores atkstate for `weaponinfo_t`
  atkstate
  /// Stores flashstate for `weaponinfo_t`
  flashstate
end struct

/// Stores the weaponinfo collection used by the d items subsystem.
weaponinfo =[

weaponinfo_t(
ammotype_t.am_noammo,
statenum_t.S_PUNCHUP,
statenum_t.S_PUNCHDOWN,
statenum_t.S_PUNCH,
statenum_t.S_PUNCH1,
statenum_t.S_NULL
),

weaponinfo_t(
ammotype_t.am_clip,
statenum_t.S_PISTOLUP,
statenum_t.S_PISTOLDOWN,
statenum_t.S_PISTOL,
statenum_t.S_PISTOL1,
statenum_t.S_PISTOLFLASH
),

weaponinfo_t(
ammotype_t.am_shell,
statenum_t.S_SGUNUP,
statenum_t.S_SGUNDOWN,
statenum_t.S_SGUN,
statenum_t.S_SGUN1,
statenum_t.S_SGUNFLASH1
),

weaponinfo_t(
ammotype_t.am_clip,
statenum_t.S_CHAINUP,
statenum_t.S_CHAINDOWN,
statenum_t.S_CHAIN,
statenum_t.S_CHAIN1,
statenum_t.S_CHAINFLASH1
),

weaponinfo_t(
ammotype_t.am_misl,
statenum_t.S_MISSILEUP,
statenum_t.S_MISSILEDOWN,
statenum_t.S_MISSILE,
statenum_t.S_MISSILE1,
statenum_t.S_MISSILEFLASH1
),

weaponinfo_t(
ammotype_t.am_cell,
statenum_t.S_PLASMAUP,
statenum_t.S_PLASMADOWN,
statenum_t.S_PLASMA,
statenum_t.S_PLASMA1,
statenum_t.S_PLASMAFLASH1
),

weaponinfo_t(
ammotype_t.am_cell,
statenum_t.S_BFGUP,
statenum_t.S_BFGDOWN,
statenum_t.S_BFG,
statenum_t.S_BFG1,
statenum_t.S_BFGFLASH1
),

weaponinfo_t(
ammotype_t.am_noammo,
statenum_t.S_SAWUP,
statenum_t.S_SAWDOWN,
statenum_t.S_SAW,
statenum_t.S_SAW1,
statenum_t.S_NULL
),

weaponinfo_t(
ammotype_t.am_shell,
statenum_t.S_DSGUNUP,
statenum_t.S_DSGUNDOWN,
statenum_t.S_DSGUN,
statenum_t.S_DSGUN1,
statenum_t.S_DSGUNFLASH1
)
]



