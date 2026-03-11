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

  Script: d_player.ml
  Purpose: Defines core Doom data types, shared state, and bootstrap flow.
*/
import d_items
import p_pspr
import p_mobj
import d_ticcmd

/*
* Enum: playerstate_t
* Purpose: Defines named constants for playerstate type.
*/
enum playerstate_t
  PST_LIVE
  PST_DEAD
  PST_REBORN
end enum

/*
* Enum: cheat_t
* Purpose: Defines named constants for cheat type.
*/
enum cheat_t
  CF_NOCLIP = 1
  CF_GODMODE = 2
  CF_NOMOMENTUM = 4
end enum

/*
* Struct: player_t
* Purpose: Stores runtime data for player type.
*/
struct player_t
  mo
  playerstate
  cmd

  viewz
  viewheight
  deltaviewheight
  bob

  health
  armorpoints
  armortype

  powers
  cards
  backpack

  frags
  readyweapon
  pendingweapon

  weaponowned
  ammo
  maxammo

  attackdown
  usedown

  cheats
  refire

  killcount
  itemcount
  secretcount

  message

  damagecount
  bonuscount

  attacker

  extralight
  fixedcolormap
  colormap

  psprites

  didsecret
end struct

/*
* Struct: wbplayerstruct_t
* Purpose: Stores runtime data for wbplayerstruct type.
*/
struct wbplayerstruct_t
  inum
  skills
  sitems
  ssecret
  stime
  frags
  score
end struct

/*
* Struct: wbstartstruct_t
* Purpose: Stores runtime data for wbstartstruct type.
*/
struct wbstartstruct_t
  epsd
  didsecret
  last
  next
  maxkills
  maxitems
  maxsecret
  maxfrags
  partime
  pnum
  plyr
end struct

/*
* Function: _DP_IntArray
* Purpose: Implements the _DP_IntArray routine for the internal module support.
*/
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

/*
* Function: _DP_BoolArray
* Purpose: Implements the _DP_BoolArray routine for the internal module support.
*/
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

/*
* Function: Player_MakeDefault
* Purpose: Implements the Player_MakeDefault routine for the engine module behavior.
*/
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



