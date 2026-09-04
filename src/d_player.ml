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

//! Defines player runtime state, cheats, intermission statistics, and constructors for correctly initialized
//! player records.

import d_items
import p_pspr
import p_mobj
import d_ticcmd

/// Tracks whether a player is actively playing, awaiting rebirth, or has completed the current level.
enum playerstate_t
  /// Represents pst live in `playerstate_t`
  PST_LIVE
  /// Represents pst dead in `playerstate_t`
  PST_DEAD
  /// Represents pst reborn in `playerstate_t`
  PST_REBORN
end enum

/// Assigns independent bit flags for player cheats such as god mode, noclip, and temporary power effects.
enum cheat_t
  /// Represents cf noclip in `cheat_t`
  CF_NOCLIP = 1
  /// Represents cf godmode in `cheat_t`
  CF_GODMODE = 2
  /// Represents cf nomomentum in `cheat_t`
  CF_NOMOMENTUM = 4
  /// Represents cf notarget in `cheat_t`
  CF_NOTARGET = 8
end enum

/// Owns all persistent and per-tic state for one player, including its mobj link, controls, view, inventory,
/// powers, weapons, and HUD counters.
struct player_t
  /// Stores mo for `player_t`
  mo
  /// Stores playerstate for `player_t`
  playerstate
  /// Stores cmd for `player_t`
  cmd

  /// Stores viewz for `player_t`
  viewz
  /// Stores viewheight for `player_t`
  viewheight
  /// Stores deltaviewheight for `player_t`
  deltaviewheight
  /// Stores bob for `player_t`
  bob

  /// Stores health for `player_t`
  health
  /// Stores armorpoints for `player_t`
  armorpoints
  /// Stores armortype for `player_t`
  armortype

  /// Stores powers for `player_t`
  powers
  /// Stores cards for `player_t`
  cards
  /// Stores backpack for `player_t`
  backpack

  /// Stores frags for `player_t`
  frags
  /// Stores readyweapon for `player_t`
  readyweapon
  /// Stores pendingweapon for `player_t`
  pendingweapon

  /// Stores weaponowned for `player_t`
  weaponowned
  /// Stores ammo for `player_t`
  ammo
  /// Stores maxammo for `player_t`
  maxammo

  /// Stores attackdown for `player_t`
  attackdown
  /// Stores usedown for `player_t`
  usedown

  /// Stores cheats for `player_t`
  cheats
  /// Stores refire for `player_t`
  refire

  /// Stores killcount for `player_t`
  killcount
  /// Stores itemcount for `player_t`
  itemcount
  /// Stores secretcount for `player_t`
  secretcount

  /// Stores message for `player_t`
  message

  /// Stores damagecount for `player_t`
  damagecount
  /// Stores bonuscount for `player_t`
  bonuscount

  /// Stores attacker for `player_t`
  attacker

  /// Stores extralight for `player_t`
  extralight
  /// Stores fixedcolormap for `player_t`
  fixedcolormap
  /// Stores colormap for `player_t`
  colormap

  /// Stores psprites for `player_t`
  psprites

  /// Stores didsecret for `player_t`
  didsecret
end struct

/// Captures one player's end-of-level kill, item, secret, frag, and completion-time statistics for the
/// intermission.
struct wbplayerstruct_t
  /// Stores inum for `wbplayerstruct_t`
  inum
  /// Stores skills for `wbplayerstruct_t`
  skills
  /// Stores sitems for `wbplayerstruct_t`
  sitems
  /// Stores ssecret for `wbplayerstruct_t`
  ssecret
  /// Stores stime for `wbplayerstruct_t`
  stime
  /// Stores frags for `wbplayerstruct_t`
  frags
  /// Stores score for `wbplayerstruct_t`
  score
end struct

/// Packages level identity, par time, aggregate totals, and all player results passed into the intermission
/// state machine.
struct wbstartstruct_t
  /// Stores epsd for `wbstartstruct_t`
  epsd
  /// Stores didsecret for `wbstartstruct_t`
  didsecret
  /// Stores last for `wbstartstruct_t`
  last
  /// Next linked record in traversal order stored by `wbstartstruct_t`
  next
  /// Stores maxkills for `wbstartstruct_t`
  maxkills
  /// Stores maxitems for `wbstartstruct_t`
  maxitems
  /// Stores maxsecret for `wbstartstruct_t`
  maxsecret
  /// Stores maxfrags for `wbstartstruct_t`
  maxfrags
  /// Stores partime for `wbstartstruct_t`
  partime
  /// Stores pnum for `wbstartstruct_t`
  pnum
  /// Stores plyr for `wbstartstruct_t`
  plyr
end struct

/// Allocates a fixed-length integer array initialized to the supplied value.
/// @param n Number of values to process.
/// @param v Value consumed by the operation.
/// @internal
function _DP_IntArray(n, v)
  if typeof(n) != "int" or n < 0 then
    return []
  end if
  a =[]
  i = 0
  while i < n
    a = a +[v]
    i = i + 1
  end while
  return a
end function

/// Allocates a fixed-length boolean array initialized from a strictly boolean input.
/// @param n Number of values to process.
/// @param v Value consumed by the operation.
/// @internal
function _DP_BoolArray(n, v)
  if typeof(n) != "int" or n < 0 then
    return []
  end if
  a =[]
  i = 0
  while i < n
    a = a +[v]
    i = i + 1
  end while
  return a
end function

/// Constructs a player record with correctly sized inventory, weapon, power, frag, and psprite arrays and
/// canonical spawn defaults.
function Player_MakeDefault()

  cmd = ticcmd_t(0, 0, 0, 0, 0, 0)

  powers = _DP_IntArray(NUMPOWERS, 0)
  cards = _DP_BoolArray(NUMCARDS, false)
  frags = _DP_IntArray(MAXPLAYERS, 0)
  weaponowned = _DP_BoolArray(NUMWEAPONS, false)
  ammo = _DP_IntArray(NUMAMMO, 0)
  maxammo = _DP_IntArray(NUMAMMO, 0)

  ps =[]
  numPs = 0
  if typeof(NUMPSPRITES) == "int" and NUMPSPRITES > 0 then
    numPs = NUMPSPRITES
  end if
  i = 0
  while i < numPs
    ps = ps +[pspdef_t(void, 0, 0, 0)]
    i = i + 1
  end while

  return player_t(
  void,
  playerstate_t.PST_LIVE,
  cmd,

  0, 0, 0, 0,

  100, 0, 0,

  powers,
  cards,
  false,

  frags,
  weapontype_t.wp_pistol,
  weapontype_t.wp_nochange,

  weaponowned,
  ammo,
  maxammo,

  0, 0,

  0, 0,

  0, 0, 0,

  void,

  0, 0,

  void,

  0,
  0,
  0,

  ps,

  false
)
end function



