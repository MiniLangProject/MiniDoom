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

//! Defines actor state, spawn/removal ownership, missile and player creation, movement, and item respawn.

import tables
import m_fixed
import d_think
import doomdata
import info
import i_system
import z_zone
import m_random
import doomdef
import p_local
import p_map
import p_maputl
import sounds
import st_stuff
import hu_stuff
import s_sound
import doomstat
import d_player
import p_pspr
import r_main
import std.math

/// Encodes actor collision, damage, gravity, AI allegiance, pickup, and render behavior bits.
enum mobjflag_t
  /// Represents mf special in `mobjflag_t`
  MF_SPECIAL = 1
  /// Represents mf solid in `mobjflag_t`
  MF_SOLID = 2
  /// Represents mf shootable in `mobjflag_t`
  MF_SHOOTABLE = 4
  /// Represents mf nosector in `mobjflag_t`
  MF_NOSECTOR = 8
  /// Represents mf noblockmap in `mobjflag_t`
  MF_NOBLOCKMAP = 16
  /// Represents mf ambush in `mobjflag_t`
  MF_AMBUSH = 32
  /// Represents mf justhit in `mobjflag_t`
  MF_JUSTHIT = 64
  /// Represents mf justattacked in `mobjflag_t`
  MF_JUSTATTACKED = 128
  /// Represents mf spawnceiling in `mobjflag_t`
  MF_SPAWNCEILING = 256
  /// Represents mf nogravity in `mobjflag_t`
  MF_NOGRAVITY = 512
  /// Represents mf dropoff in `mobjflag_t`
  MF_DROPOFF = 0x400
  /// Represents mf pickup in `mobjflag_t`
  MF_PICKUP = 0x800
  /// Represents mf noclip in `mobjflag_t`
  MF_NOCLIP = 0x1000
  /// Represents mf slide in `mobjflag_t`
  MF_SLIDE = 0x2000
  /// Represents mf float in `mobjflag_t`
  MF_FLOAT = 0x4000
  /// Represents mf teleport in `mobjflag_t`
  MF_TELEPORT = 0x8000
  /// Represents mf missile in `mobjflag_t`
  MF_MISSILE = 0x10000
  /// Represents mf dropped in `mobjflag_t`
  MF_DROPPED = 0x20000
  /// Represents mf shadow in `mobjflag_t`
  MF_SHADOW = 0x40000
  /// Represents mf noblood in `mobjflag_t`
  MF_NOBLOOD = 0x80000
  /// Represents mf corpse in `mobjflag_t`
  MF_CORPSE = 0x100000
  /// Represents mf infloat in `mobjflag_t`
  MF_INFLOAT = 0x200000
  /// Represents mf countkill in `mobjflag_t`
  MF_COUNTKILL = 0x400000
  /// Represents mf countitem in `mobjflag_t`
  MF_COUNTITEM = 0x800000
  /// Represents mf skullfly in `mobjflag_t`
  MF_SKULLFLY = 0x1000000
  /// Represents mf notdmatch in `mobjflag_t`
  MF_NOTDMATCH = 0x2000000
  /// Represents mf translation in `mobjflag_t`
  MF_TRANSLATION = 0xc000000
  /// Represents mf transshift in `mobjflag_t`
  MF_TRANSSHIFT = 26
end enum

/// Holds one live actor's thinker link, spatial state, presentation state, combat fields, and ownership.
struct mobj_t
  /// Stores thinker for `mobj_t`
  thinker

  /// Horizontal map- or screen-space coordinate stored by `mobj_t`
  x
  /// Vertical map- or screen-space coordinate stored by `mobj_t`
  y
  /// Vertical world-space coordinate stored by `mobj_t`
  z

  /// Stores snext for `mobj_t`
  snext
  /// Stores sprev for `mobj_t`
  sprev

  /// Doom binary-angle orientation stored by `mobj_t`
  angle
  /// Stores sprite for `mobj_t`
  sprite
  /// Stores frame for `mobj_t`
  frame

  /// Stores bnext for `mobj_t`
  bnext
  /// Stores bprev for `mobj_t`
  bprev
  /// Stores subsector for `mobj_t`
  subsector

  /// Stores floorz for `mobj_t`
  floorz
  /// Stores ceilingz for `mobj_t`
  ceilingz

  /// Stores radius for `mobj_t`
  radius
  /// Height in pixels or map units stored by `mobj_t`
  height

  /// Stores momx for `mobj_t`
  momx
  /// Stores momy for `mobj_t`
  momy
  /// Stores momz for `mobj_t`
  momz

  /// Stores validcount for `mobj_t`
  validcount

  /// Kind discriminator for this record stored by `mobj_t`
  type
  /// Stores info for `mobj_t`
  info

  /// Stores tics for `mobj_t`
  tics
  /// Current state-machine value stored by `mobj_t`
  state
  /// Bit flags controlling this record's behavior stored by `mobj_t`
  flags
  /// Stores health for `mobj_t`
  health

  /// Stores movedir for `mobj_t`
  movedir
  /// Stores movecount for `mobj_t`
  movecount

  /// Stores target for `mobj_t`
  target

  /// Stores reactiontime for `mobj_t`
  reactiontime
  /// Stores threshold for `mobj_t`
  threshold

  /// Stores player for `mobj_t`
  player

  /// Stores lastlook for `mobj_t`
  lastlook
  /// Stores spawnpoint for `mobj_t`
  spawnpoint
  /// Stores tracer for `mobj_t`
  tracer
  /// Stores mpuid for `mobj_t`
  mpuid
end struct

/// Defines itemquesize for the p mobj subsystem.
const ITEMQUESIZE = 128
/// Stores the itemrespawnque collection used by the p mobj subsystem.
itemrespawnque =[]
/// Stores the itemrespawntime collection used by the p mobj subsystem.
itemrespawntime =[]
/// Tracks the mutable iquehead value used by the p mobj subsystem.
iquehead = 0
/// Tracks the mutable iquetail value used by the p mobj subsystem.
iquetail = 0
/// Stores the pm thinker nodes collection used by the p mobj subsystem.
/// @internal
_pm_thinker_nodes =[]
/// Stores the pm thinker owners collection used by the p mobj subsystem.
/// @internal
_pm_thinker_owners =[]
/// Stores the pm thinker ids collection used by the p mobj subsystem.
/// @internal
_pm_thinker_ids =[]
/// Tracks the mutable pm next thinker id value used by the p mobj subsystem.
/// @internal
_pm_next_thinker_id = 1
/// Tracks the mutable pm next netuid value used by the p mobj subsystem.
/// @internal
_pm_next_netuid = 1

/// Allocates the bounded dropped-item mapthing/timestamp ring on first respawn-queue use.
/// @internal
function inline _InitItemRespawnQueue()
  global itemrespawnque
  global itemrespawntime

  if len(itemrespawnque) == 0 then
    i = 0
    while i < ITEMQUESIZE
      itemrespawnque = itemrespawnque +[mapthing_t(0, 0, 0, 0, 0)]
      itemrespawntime = itemrespawntime +[0]
      i = i + 1
    end while
  end if
end function

/// Records the stable thinker-node-to-mobj association used when callbacks receive only a node.
/// @param node Node value supplied to `_PM_RegisterThinker`.
/// @param owner Owner value supplied to `_PM_RegisterThinker`.
/// @internal
function inline _PM_RegisterThinker(node, owner)
  global _pm_thinker_nodes
  global _pm_thinker_owners
  global _pm_thinker_ids
  global _pm_next_thinker_id
  i = len(_pm_thinker_nodes) - 1
  while i >= 0
    if _pm_thinker_nodes[i] == node then
      _pm_thinker_owners[i] = owner
      if i >= len(_pm_thinker_ids) then
        _pm_thinker_ids = _pm_thinker_ids +[_pm_next_thinker_id]
        _pm_next_thinker_id = _pm_next_thinker_id + 1
      else if _PM_ToInt(_pm_thinker_ids[i], 0) <= 0 then
        _pm_thinker_ids[i] = _pm_next_thinker_id
        _pm_next_thinker_id = _pm_next_thinker_id + 1
      end if
      if _pm_next_thinker_id <= 0 then _pm_next_thinker_id = 1 end if
      return
    end if
    i = i - 1
  end while

  tid = _PM_ToInt(_pm_next_thinker_id, 1)
  if tid <= 0 then tid = 1 end if
  _pm_next_thinker_id = tid + 1
  if _pm_next_thinker_id <= 0 then _pm_next_thinker_id = 1 end if
  _pm_thinker_nodes = _pm_thinker_nodes +[node]
  _pm_thinker_owners = _pm_thinker_owners +[owner]
  _pm_thinker_ids = _pm_thinker_ids +[tid]
end function

/// Resolves either a direct mobj or its registered thinker node to the current actor owner.
/// @param node Node value supplied to `_PM_ResolveThinkerOwner`.
/// @internal
function inline _PM_ResolveThinkerOwner(node)
  i = len(_pm_thinker_nodes) - 1
  while i >= 0
    if _pm_thinker_nodes[i] == node then
      owner = _pm_thinker_owners[i]
      if typeof(owner) == "struct" then return owner end if
      return void
    end if
    i = i - 1
  end while
  return void
end function

/// Returns stable thinker registration id used for multiplayer actor mapping.
/// @param node Node value supplied to `_PM_ResolveThinkerId`.
/// @internal
function inline _PM_ResolveThinkerId(node)
  i = len(_pm_thinker_nodes) - 1
  while i >= 0
    if _pm_thinker_nodes[i] == node then
      if i < len(_pm_thinker_ids) then
        return _PM_ToInt(_pm_thinker_ids[i], 0)
      end if
      return 0
    end if
    i = i - 1
  end while
  return 0
end function

/// Removes a thinker-node ownership entry when its mobj leaves the world.
/// @param node Node value supplied to `_PM_UnregisterThinker`.
/// @internal
function inline _PM_UnregisterThinker(node)
  global _pm_thinker_nodes
  global _pm_thinker_owners
  global _pm_thinker_ids
  i = len(_pm_thinker_nodes) - 1
  while i >= 0
    if _pm_thinker_nodes[i] == node then
      _pm_thinker_nodes[i] = 0
      _pm_thinker_owners[i] = 0
      if i < len(_pm_thinker_ids) then _pm_thinker_ids[i] = 0 end if
      return
    end if
    i = i - 1
  end while
end function

/// Truncates actor movement quotients toward zero, returning zero for invalid operands.
/// @param a First input operand.
/// @param b Second input operand.
/// @internal
function inline _PM_IDiv(a, b)
  if typeof(a) != "int" or typeof(b) != "int" or b == 0 then return 0 end if
  q = a / b
  if q >= 0 then return std.math.floor(q) end if
  return std.math.ceil(q)
end function

/// Normalizes enum/numeric actor fields to truncating integers with a supplied fallback.
/// @param v Value consumed by the operation.
/// @param fallback Value returned when the requested conversion or lookup is unavailable.
/// @internal
function inline _PM_ToInt(v, fallback)
  if typeof(v) == "int" then return v end if
  if typeof(v) == "float" then
    if v >= 0 then return std.math.floor(v) end if
    return std.math.ceil(v)
  end if
  n = toNumber(v)
  if typeof(n) == "int" then return n end if
  if typeof(n) == "float" then
    if n >= 0 then return std.math.floor(n) end if
    return std.math.ceil(n)
  end if
  return fallback
end function

/// Converts a checked mobj type enum/value to an in-range mobjinfo table index.
/// @param v Value consumed by the operation.
/// @internal
function _PM_MobjTypeIndex(v)
  if typeof(v) == "int" then return v end if

  n = toNumber(v)
  if typeof(n) == "int" then return n end if
  if typeof(n) == "float" then
    if n >= 0 then return std.math.floor(n) end if
    return std.math.ceil(n)
  end if

  if typeof(v) != "enum" then return -1 end if

  lim = 0
  if typeof(mobjinfo) == "array" then
    lim = len(mobjinfo)
  else
    lim = _PM_ToInt(mobjtype_t.NUMMOBJTYPES, 0)
  end if
  if lim <= 0 then return -1 end if

  i = 0
  while i < lim
    if v == i then return i end if
    i = i + 1
  end while

  return -1
end function

/// Allocates a positive per-mobj uid used by multiplayer replication.
/// @internal
function inline _PM_AllocNetUid()
  global _pm_next_netuid
  idv = _PM_ToInt(_pm_next_netuid, 1)
  if idv <= 0 then idv = 1 end if
  _pm_next_netuid = idv + 1
  if _pm_next_netuid <= 0 then _pm_next_netuid = 1 end if
  return idv
end function

/// Constructs an unlinked inert actor whose fields satisfy mobj_t's runtime invariants.
/// @internal
function _Mobj_Default()

  return mobj_t(
  thinker_t(void, void, void, void),
  0, 0, 0,
  void, void,
  0, 0, 0,
  void, void, void,
  0, 0,
  0, 0,
  0, 0, 0,
  0,
  0, void,
  0, void, 0, 0,
  0, 0,
  void,
  0, 0,
  void,
  0,
  mapthing_t(0, 0, 0, 0, 0),
  void,
  0
)
end function

/// Converts a state sprite enum/value to a valid sprite table index or the null sprite.
/// @param spr Spr value supplied to `_PM_StateSpriteIndex`.
/// @internal
function inline _PM_StateSpriteIndex(spr)
  if typeof(spr) == "int" then return spr end if

  if typeof(spr) == "enum" then
    max = 0
    if typeof(sprnames) == "array" then max = len(sprnames) end if
    i = 0
    while i < max
      if spr == i then return i end if
      i = i + 1
    end while
  end if

  return 0
end function

/// Enters a state, runs its action, and follows zero-tic transitions until a timed or null state.
/// @param mobj Map object affected by the operation.
/// @param state Subsystem state read or updated by the operation.
function P_SetMobjState(mobj, state)
  if mobj is void then return false end if

  if states is void or len(states) == 0 then
    mobj.state = state
    mobj.tics = 0
    return true
  end if

  stateIdx = Info_StateIndex(state)
  if stateIdx == 0 then
    mobj.state = void
    mobj.tics = 0
    if typeof(P_RemoveMobj) == "function" then
      P_RemoveMobj(mobj)
    end if
    return false
  end if
  if stateIdx < 0 or stateIdx >= len(states) then
    mobj.state = void
    mobj.tics = 0
    return false
  end if

  st = states[stateIdx]
  mobj.state = st
  mobj.tics = st.tics
  mobj.sprite = _PM_StateSpriteIndex(st.sprite)
  mobj.frame = st.frame

  if st.action is not void then
    if typeof(st.action.acp1) == "function" then
      st.action.acp1(mobj)
    else if typeof(st.action.acv) == "function" then
      st.action.acv()
    end if

    if mobj.state is void then
      return false
    end if
    if mobj.thinker is not void and mobj.thinker.func is not void and mobj.thinker.func.acv == -1 then
      return false
    end if
  end if

  while mobj.tics == 0
    ns = Info_StateIndex(st.nextstate)
    if ns == 0 then
      mobj.state = void
      mobj.tics = 0
      if typeof(P_RemoveMobj) == "function" then
        P_RemoveMobj(mobj)
      end if
      return false
    end if
    if ns < 0 or ns >= len(states) then
      mobj.state = void
      return false
    end if
    st = states[ns]
    mobj.state = st
    mobj.tics = st.tics
    mobj.sprite = _PM_StateSpriteIndex(st.sprite)
    mobj.frame = st.frame

    if st.action is not void then
      if typeof(st.action.acp1) == "function" then
        st.action.acp1(mobj)
      else if typeof(st.action.acv) == "function" then
        st.action.acv()
      end if

      if mobj.state is void then
        return false
      end if
      if mobj.thinker is not void and mobj.thinker.func is not void and mobj.thinker.func.acv == -1 then
        return false
      end if
    end if
  end while

  return true
end function

/// Instantiates an actor from mobjinfo, links it spatially, and registers its thinker ownership.
/// @param x Horizontal map- or screen-space coordinate.
/// @param y Vertical map- or screen-space coordinate.
/// @param z Vertical world-space coordinate.
/// @param type Type value supplied to `P_SpawnMobj`.
function P_SpawnMobj(x, y, z, type)
  _InitItemRespawnQueue()

  typeIdx = _PM_MobjTypeIndex(type)
  if typeIdx < 0 then return void end if

  mo = _Mobj_Default()
  mo.x = x
  mo.y = y
  mo.z = z
  mo.type = typeIdx
  mo.mpuid = _PM_AllocNetUid()
  mo.lastlook = P_Random() % MAXPLAYERS

  if mo.thinker is void then
    mo.thinker = thinker_t(void, void, actionf_t(void, void, void), void)
  end if
  mo.thinker.func = actionf_t(P_MobjThinker, void, void)
  if typeof(P_RegisterThinkerOwner) == "function" then P_RegisterThinkerOwner(mo.thinker, mo) end if

  if typeof(P_AddThinker) == "function" then
    P_AddThinker(mo.thinker)
    _PM_RegisterThinker(mo.thinker, mo)
  end if

  if typeof(mobjinfo) == "array" and typeIdx >= 0 and typeIdx < len(mobjinfo) then
    mo.info = mobjinfo[typeIdx]
    mo.radius = mo.info.radius
    mo.height = mo.info.height
    mo.flags = mo.info.flags
    mo.health = mo.info.spawnhealth
    if typeof(mo.info.reactiontime) == "int" then
      mo.reactiontime = mo.info.reactiontime
    else
      mo.reactiontime = 0
    end if

    spawnIdx = Info_StateIndex(mo.info.spawnstate)
    if typeof(states) == "array" and spawnIdx >= 0 and spawnIdx < len(states) then
      st = states[spawnIdx]
      mo.state = st
      mo.tics = st.tics
      mo.sprite = _PM_StateSpriteIndex(st.sprite)
      mo.frame = st.frame
    else
      mo.state = void
      mo.tics = 0
      mo.sprite = 0
      mo.frame = 0
    end if
  else
    mo.info = void
    mo.radius = 0
    mo.height = 0
    mo.flags = 0
    mo.health = 0
    mo.state = void
    mo.tics = 0
    mo.sprite = 0
    mo.frame = 0
  end if

  if typeof(P_SetThingPosition) == "function" then
    P_SetThingPosition(mo)
  end if

  if mo.subsector is not void and mo.subsector.sector is not void then
    mo.floorz = mo.subsector.sector.floorheight
    mo.ceilingz = mo.subsector.sector.ceilingheight
  end if

  if z == ONFLOORZ then
    mo.z = mo.floorz
  else if z == ONCEILINGZ then
    mo.z = mo.ceilingz - mo.height
  else
    mo.z = z
  end if

  return mo
end function

/// Stops missile momentum, enters its death state, removes missile solidity, and plays its death cue.
/// @param mo Map object affected by the operation.
function P_ExplodeMissile(mo)
  if mo is void then return end if

  mo.momx = 0
  mo.momy = 0
  mo.momz = 0

  if mo.info is not void and mo.info.deathstate is not void then
    P_SetMobjState(mo, mo.info.deathstate)
  else
    P_SetMobjState(mo, statenum_t.S_NULL)
  end if

  if mo.info is not void and mo.info.deathsound is not void and mo.info.deathsound != sfxenum_t.sfx_None then
    if typeof(S_StartSound) == "function" then
      S_StartSound(mo, mo.info.deathsound)
    end if
  end if
end function

/// Advances a new missile half a tic and explodes it immediately if its initial position is blocked.
/// @param th Th value supplied to `P_CheckMissileSpawn`.
function P_CheckMissileSpawn(th)
  if th is void then return end if

  if typeof(th.tics) != "int" then th.tics = 1 end if
  th.tics = th.tics -(P_Random() & 3)
  if th.tics < 1 then th.tics = 1 end if

  th.x = th.x +(th.momx >> 1)
  th.y = th.y +(th.momy >> 1)
  th.z = th.z +(th.momz >> 1)

  if typeof(P_TryMove) == "function" then
    if not P_TryMove(th, th.x, th.y) then
      P_ExplodeMissile(th)
    end if
  end if
end function

/// Aims a projectile from source to destination, sets owner/momentum, and validates its first step.
/// @param source Source value or buffer.
/// @param dest Dest value supplied to `P_SpawnMissile`.
/// @param type Type value supplied to `P_SpawnMissile`.
function P_SpawnMissile(source, dest, type)
  if source is void or dest is void then return void end if
  if typeof(finecosine) != "array" or typeof(finesine) != "array" then return void end if

  th = P_SpawnMobj(source.x, source.y, source.z + 4 * 8 * FRACUNIT, type)
  if th is void then return void end if

  if th.info is not void and th.info.seesound is not void and th.info.seesound != sfxenum_t.sfx_None then
    if typeof(S_StartSound) == "function" then
      S_StartSound(th, th.info.seesound)
    end if
  end if

  th.target = source
  an = 0
  if typeof(R_PointToAngle2) == "function" then
    an = R_PointToAngle2(source.x, source.y, dest.x, dest.y)
  end if

  if (dest.flags & mobjflag_t.MF_SHADOW) != 0 then
    an = an +((P_Random() - P_Random()) << 20)
  end if

  th.angle = an
  aidx =(an >> ANGLETOFINESHIFT) & FINEMASK
  if aidx < 0 then aidx = 0 end if
  if aidx >= len(finecosine) then aidx = aidx % len(finecosine) end if
  if aidx >= len(finesine) then aidx = aidx % len(finesine) end if

  speed = 0
  if th.info is not void and typeof(th.info.speed) == "int" then speed = th.info.speed end if
  th.momx = FixedMul(speed, finecosine[aidx])
  th.momy = FixedMul(speed, finesine[aidx])

  dist = P_AproxDistance(dest.x - source.x, dest.y - source.y)
  if speed != 0 then
    dist = _PM_IDiv(dist, speed)
  else
    dist = 1
  end if
  if dist < 1 then dist = 1 end if

  th.momz = _PM_IDiv((dest.z - source.z), dist)
  P_CheckMissileSpawn(th)
  return th
end function

/// Auto-aims a player projectile across fallback angles before spawning and validating it.
/// @param source Source value or buffer.
/// @param type Type value supplied to `P_SpawnPlayerMissile`.
function P_SpawnPlayerMissile(source, type)
  global linetarget

  if source is void then return void end if
  if typeof(finecosine) != "array" or typeof(finesine) != "array" then
    return P_SpawnMobj(source.x, source.y, source.z +(32 * FRACUNIT), type)
  end if

  an = source.angle
  slope = 0
  slope = P_AimLineAttack(source, an, 16 * 64 * FRACUNIT)

  if linetarget is void then
    an = an +(1 << 26)
    slope = P_AimLineAttack(source, an, 16 * 64 * FRACUNIT)

    if linetarget is void then
      an = an -(2 << 26)
      slope = P_AimLineAttack(source, an, 16 * 64 * FRACUNIT)
    end if

    if linetarget is void then
      an = source.angle
      slope = 0
    end if
  end if

  x = source.x
  y = source.y
  z = source.z + 4 * 8 * FRACUNIT

  th = P_SpawnMobj(x, y, z, type)
  if th is void then return void end if

  if th.info is not void and th.info.seesound is not void and th.info.seesound != sfxenum_t.sfx_None then
    if typeof(S_StartSound) == "function" then
      S_StartSound(th, th.info.seesound)
    end if
  end if

  th.target = source
  th.angle = an

  aidx =(an >> ANGLETOFINESHIFT) & FINEMASK
  if aidx < 0 then aidx = 0 end if
  if aidx >= len(finecosine) then aidx = aidx % len(finecosine) end if
  if aidx >= len(finesine) then aidx = aidx % len(finesine) end if

  speed = 0
  if th.info is not void and typeof(th.info.speed) == "int" then speed = th.info.speed end if
  th.momx = FixedMul(speed, finecosine[aidx])
  th.momy = FixedMul(speed, finesine[aidx])
  th.momz = FixedMul(speed, slope)

  P_CheckMissileSpawn(th)
  return th
end function

/// Extends player and in-game arrays to MAXPLAYERS before mapthing-driven spawn access.
/// @internal
function _PM_EnsurePlayerSlots()
  global players
  global playerstarts
  global deathmatchstarts
  global deathmatch_p

  if typeof(players) != "array" then
    players =[void, void, void, void]
  end if

  if typeof(playerstarts) != "array" or len(playerstarts) < MAXPLAYERS then
    playerstarts =[]
    for i = 0 to MAXPLAYERS - 1
      playerstarts = playerstarts +[mapthing_t(0, 0, 0, 0, 0)]
    end for
  end if

  if typeof(deathmatchstarts) != "array" or len(deathmatchstarts) < 10 then
    deathmatchstarts =[]
    for i = 0 to 9
      deathmatchstarts = deathmatchstarts +[mapthing_t(0, 0, 0, 0, 0)]
    end for
  end if

  if typeof(deathmatch_p) != "int" then
    deathmatch_p = 0
  end if
end function

/// Converts a player start mapthing into a live pawn and attaches view, health, and reborn state.
/// @param mthing Mthing value supplied to `P_SpawnPlayer`.
function P_SpawnPlayer(mthing)
  global players

  if mthing is void then return end if
  _PM_EnsurePlayerSlots()

  pnum = mthing.type - 1
  if pnum < 0 or pnum >= MAXPLAYERS then return end if
  if typeof(playeringame) != "array" or pnum >= len(playeringame) or not playeringame[pnum] then
    return
  end if

  p = players[pnum]
  if typeof(p) != "struct" then
    p = Player_MakeDefault()
  end if
  if p.playerstate == playerstate_t.PST_REBORN then
    if typeof(G_PlayerReborn) == "function" then
      G_PlayerReborn(pnum)
      if typeof(players) == "array" and pnum < len(players) and typeof(players[pnum]) == "struct" then
        p = players[pnum]
      end if
    else
      p = Player_MakeDefault()
    end if
  end if

  x = mthing.x << FRACBITS
  y = mthing.y << FRACBITS
  z = ONFLOORZ

  mobj = P_SpawnMobj(x, y, z, mobjtype_t.MT_PLAYER)
  if mobj is void then return end if

  if mthing.type > 1 then
    mobj.flags = mobj.flags |((mthing.type - 1) << mobjflag_t.MF_TRANSSHIFT)
  end if

  mobj.angle = ANG45 * _PM_IDiv(mthing.angle, 45)
  mobj.player = p
  mobj.health = p.health

  p.mo = mobj
  p.playerstate = playerstate_t.PST_LIVE
  p.refire = 0
  p.message = void
  p.damagecount = 0
  p.bonuscount = 0
  p.extralight = 0
  p.fixedcolormap = 0
  p.viewheight = VIEWHEIGHT
  p.deltaviewheight = 0
  p.bob = 0
  // The wipe destination is rendered before the first gameplay tic. Seed the
  // real eye position now instead of leaving P_SetupLevel's sentinel viewz=1.
  p.viewz = mobj.z + p.viewheight
  viewCeiling = mobj.ceilingz - 4 * FRACUNIT
  if p.viewz > viewCeiling then p.viewz = viewCeiling end if

  if typeof(P_SetupPsprites) == "function" then
    P_SetupPsprites(p)
  end if

  if deathmatch and typeof(p.cards) == "array" then
    for i = 0 to NUMCARDS - 1
      if i < len(p.cards) then
        p.cards[i] = true
      end if
    end for
  end if

  players[pnum] = p

  if pnum == displayplayer and typeof(R_ResetViewInterpolation) == "function" then
    R_ResetViewInterpolation()
  end if

  if pnum == consoleplayer then
    if typeof(ST_Start) == "function" then ST_Start() end if
    if typeof(HU_Start) == "function" then HU_Start() end if
  end if
end function

/// Filters a mapthing by player/skill/type rules, then spawns its actor and map-derived flags.
/// @param mthing Mthing value supplied to `P_SpawnMapThing`.
function P_SpawnMapThing(mthing)
  global deathmatch_p
  global deathmatchstarts
  global playerstarts
  global totalkills
  global totalitems

  if mthing is void then return end if
  _PM_EnsurePlayerSlots()

  if mthing.type == 11 then
    if deathmatch_p < 10 then
      deathmatchstarts[deathmatch_p] = mthing
      deathmatch_p = deathmatch_p + 1
    end if
    return
  end if

  if mthing.type >= 1 and mthing.type <= 4 then
    playerstarts[mthing.type - 1] = mthing
    if not deathmatch then
      P_SpawnPlayer(mthing)
    end if
    return
  end if

  if (not netgame) and((mthing.options & 16) != 0) then
    return
  end if

  bit = 0
  if gameskill == skill_t.sk_baby then
    bit = 1
  else if gameskill == skill_t.sk_nightmare then
    bit = 4
  else if typeof(gameskill) == "int" then
    bit = 1 <<(gameskill - 1)
  else
    bit = 2
  end if
  if (mthing.options & bit) == 0 then
    return
  end if

  spawnType = -1
  if typeof(mobjinfo) == "array" then
    i = 0
    while i < len(mobjinfo)
      if mthing.type == mobjinfo[i].doomednum then
        spawnType = i
        break
      end if
      i = i + 1
    end while
  end if

  if spawnType < 0 then
    return
  end if

  infoRec = mobjinfo[spawnType]

  if deathmatch and((infoRec.flags & mobjflag_t.MF_NOTDMATCH) != 0) then
    return
  end if

  if nomonsters and(spawnType == mobjtype_t.MT_SKULL or((infoRec.flags & mobjflag_t.MF_COUNTKILL) != 0)) then
    return
  end if

  x = mthing.x << FRACBITS
  y = mthing.y << FRACBITS
  z = ONFLOORZ
  if (infoRec.flags & mobjflag_t.MF_SPAWNCEILING) != 0 then
    z = ONCEILINGZ
  end if

  mobj = P_SpawnMobj(x, y, z, spawnType)
  if mobj is void then return end if

  mobj.spawnpoint = mthing
  if mobj.tics > 0 then
    mobj.tics = 1 +(P_Random() % mobj.tics)
  end if
  if (mobj.flags & mobjflag_t.MF_COUNTKILL) != 0 then
    totalkills = totalkills + 1
  end if
  if (mobj.flags & mobjflag_t.MF_COUNTITEM) != 0 then
    totalitems = totalitems + 1
  end if

  mobj.angle = ANG45 * _PM_IDiv(mthing.angle, 45)
  if (mthing.options & MTF_AMBUSH) != 0 then
    mobj.flags = mobj.flags | mobjflag_t.MF_AMBUSH
  end if
end function

/// Queues eligible specials for respawn, unlinks the actor, and unregisters its thinker safely.
/// @param th Th value supplied to `P_RemoveMobj`.
function P_RemoveMobj(th)
  if th is void then return end if

  if (th.flags & mobjflag_t.MF_SPECIAL) != 0 and(th.flags & mobjflag_t.MF_DROPPED) == 0 and th.type != mobjtype_t.MT_INV and th.type != mobjtype_t.MT_INS then
    itemrespawnque[iquehead] = th.spawnpoint
    itemrespawntime[iquehead] = leveltime
    global iquehead
    iquehead =(iquehead + 1) &(ITEMQUESIZE - 1)
    if iquehead == iquetail then
      global iquetail
      iquetail =(iquetail + 1) &(ITEMQUESIZE - 1)
    end if
  end if

  if typeof(P_UnsetThingPosition) == "function" then
    P_UnsetThingPosition(th)
  end if

  if typeof(S_StopSound) == "function" then
    S_StopSound(th)
  end if

  if th.thinker is not void and typeof(P_RemoveThinker) == "function" then
    _PM_UnregisterThinker(th.thinker)
    P_RemoveThinker(th.thinker)
  end if
end function

/// Defines stopspeed for the p mobj subsystem.
const STOPSPEED = 0x1000
/// Defines friction for the p mobj subsystem.
const FRICTION = 0xe800

/// Applies bounded XY momentum through collision/slide logic, then friction for grounded actors.
/// @param mo Map object affected by the operation.
function P_XYMovement(mo)
  if mo is void then return end if

  if (mo.momx == 0 and mo.momy == 0) then
    if (mo.flags & mobjflag_t.MF_SKULLFLY) != 0 then
      mo.flags = mo.flags &(~mobjflag_t.MF_SKULLFLY)
      mo.momx = 0
      mo.momy = 0
      mo.momz = 0
      if mo.info is not void then
        P_SetMobjState(mo, mo.info.spawnstate)
      end if
    end if
    return
  end if

  player = mo.player

  if mo.momx > MAXMOVE then
    mo.momx = MAXMOVE
  else if mo.momx < -MAXMOVE then
    mo.momx = -MAXMOVE
  end if
  if mo.momy > MAXMOVE then
    mo.momy = MAXMOVE
  else if mo.momy < -MAXMOVE then
    mo.momy = -MAXMOVE
  end if

  xmove = mo.momx
  ymove = mo.momy

  while xmove != 0 or ymove != 0
    ptryx = mo.x
    ptryy = mo.y
    if xmove >(MAXMOVE >> 1) or ymove >(MAXMOVE >> 1) then
      ptryx = mo.x +(xmove >> 1)
      ptryy = mo.y +(ymove >> 1)
      xmove = xmove >> 1
      ymove = ymove >> 1
    else
      ptryx = mo.x + xmove
      ptryy = mo.y + ymove
      xmove = 0
      ymove = 0
    end if

    if typeof(P_TryMove) == "function" and not P_TryMove(mo, ptryx, ptryy) then
      if player is not void and typeof(P_SlideMove) == "function" then
        P_SlideMove(mo)
      else if (mo.flags & mobjflag_t.MF_MISSILE) != 0 then
        if ceilingline is not void and ceilingline.backsector is not void and ceilingline.backsector.ceilingpic == skyflatnum then
          P_RemoveMobj(mo)
          return
        end if
        P_ExplodeMissile(mo)
        return
      else
        mo.momx = 0
        mo.momy = 0
      end if
    end if
  end while

  if player is not void and(player.cheats & cheat_t.CF_NOMOMENTUM) != 0 then
    mo.momx = 0
    mo.momy = 0
    return
  end if

  if (mo.flags &(mobjflag_t.MF_MISSILE | mobjflag_t.MF_SKULLFLY)) != 0 then return end if
  if mo.z > mo.floorz then return end if

  if (mo.flags & mobjflag_t.MF_CORPSE) != 0 and mo.subsector is not void and mo.subsector.sector is not void then
    if mo.momx >(FRACUNIT >> 2) or mo.momx < -(FRACUNIT >> 2) or mo.momy >(FRACUNIT >> 2) or mo.momy < -(FRACUNIT >> 2) then
      if mo.floorz != mo.subsector.sector.floorheight then
        return
      end if
    end if
  end if

  isidle = true
  if player is not void and player.cmd is not void then
    if player.cmd.forwardmove != 0 or player.cmd.sidemove != 0 then
      isidle = false
    end if
  end if

  if mo.momx > -STOPSPEED and mo.momx < STOPSPEED and mo.momy > -STOPSPEED and mo.momy < STOPSPEED and isidle then
    if player is not void and player.mo is not void and player.mo.state is not void then
      psidx = Info_StateIndex(statenum_t.S_PLAY_RUN1)
      curidx = -1
      if typeof(player.mo.state) == "struct" then
        curidx = Info_StateIndex(player.mo.state)
      end if
      if curidx >= psidx and curidx < psidx + 4 then
        P_SetMobjState(player.mo, statenum_t.S_PLAY)
      end if
    end if
    mo.momx = 0
    mo.momy = 0
  else
    mo.momx = FixedMul(mo.momx, FRICTION)
    mo.momy = FixedMul(mo.momy, FRICTION)
  end if
end function

/// Integrates vertical momentum, gravity, floor/ceiling impacts, bouncing skulls, and missile explosions.
/// @param mo Map object affected by the operation.
function P_ZMovement(mo)
  if mo is void then return end if

  if mo.player is not void and mo.z < mo.floorz then
    mo.player.viewheight = mo.player.viewheight -(mo.floorz - mo.z)
    mo.player.deltaviewheight =(VIEWHEIGHT - mo.player.viewheight) >> 3
  end if

  mo.z = mo.z + mo.momz

  if (mo.flags & mobjflag_t.MF_FLOAT) != 0 and mo.target is not void then
    if (mo.flags & mobjflag_t.MF_SKULLFLY) == 0 and(mo.flags & mobjflag_t.MF_INFLOAT) == 0 then
      dist = P_AproxDistance(mo.x - mo.target.x, mo.y - mo.target.y)
      delta =(mo.target.z +(mo.height >> 1)) - mo.z
      if delta < 0 and dist < -(delta * 3) then
        mo.z = mo.z - FLOATSPEED
      else if delta > 0 and dist <(delta * 3) then
        mo.z = mo.z + FLOATSPEED
      end if
    end if
  end if

  if mo.z <= mo.floorz then
    if (mo.flags & mobjflag_t.MF_SKULLFLY) != 0 then
      mo.momz = -mo.momz
    end if

    if mo.momz < 0 then
      if mo.player is not void and mo.momz < -GRAVITY * 8 then
        mo.player.deltaviewheight = mo.momz >> 3
        if typeof(S_StartSound) == "function" then
          S_StartSound(mo, sfxenum_t.sfx_oof)
        end if
      end if
      mo.momz = 0
    end if
    mo.z = mo.floorz

    if (mo.flags & mobjflag_t.MF_MISSILE) != 0 and(mo.flags & mobjflag_t.MF_NOCLIP) == 0 then
      P_ExplodeMissile(mo)
      return
    end if
  else if (mo.flags & mobjflag_t.MF_NOGRAVITY) == 0 then
    if mo.momz == 0 then
      mo.momz = -GRAVITY * 2
    else
      mo.momz = mo.momz - GRAVITY
    end if
  end if

  if mo.z + mo.height > mo.ceilingz then
    if mo.momz > 0 then mo.momz = 0 end if
    mo.z = mo.ceilingz - mo.height

    if (mo.flags & mobjflag_t.MF_SKULLFLY) != 0 then
      mo.momz = -mo.momz
    end if

    if (mo.flags & mobjflag_t.MF_MISSILE) != 0 and(mo.flags & mobjflag_t.MF_NOCLIP) == 0 then
      P_ExplodeMissile(mo)
      return
    end if
  end if
end function

/// Recreates a killed monster at its original spawn point with teleport fog and reaction delay.
/// @param mobj Map object affected by the operation.
function P_NightmareRespawn(mobj)
  if mobj is void then return end if

  x = mobj.spawnpoint.x << FRACBITS
  y = mobj.spawnpoint.y << FRACBITS
  if typeof(P_CheckPosition) == "function" and not P_CheckPosition(mobj, x, y) then
    return
  end if

  if mobj.subsector is not void and mobj.subsector.sector is not void then
    mo = P_SpawnMobj(mobj.x, mobj.y, mobj.subsector.sector.floorheight, mobjtype_t.MT_TFOG)
    if typeof(S_StartSound) == "function" then
      S_StartSound(mo, sfxenum_t.sfx_telept)
    end if
  end if

  ss = void
  if typeof(R_PointInSubsector) == "function" then
    ss = R_PointInSubsector(x, y)
  end if
  if ss is not void and ss.sector is not void then
    mo = P_SpawnMobj(x, y, ss.sector.floorheight, mobjtype_t.MT_TFOG)
    if typeof(S_StartSound) == "function" then
      S_StartSound(mo, sfxenum_t.sfx_telept)
    end if
  end if

  mthing = mobj.spawnpoint
  z = ONFLOORZ
  if mobj.info is not void and(mobj.info.flags & mobjflag_t.MF_SPAWNCEILING) != 0 then
    z = ONCEILINGZ
  end if

  mo = P_SpawnMobj(x, y, z, mobj.type)
  if mo is void then return end if
  mo.spawnpoint = mobj.spawnpoint
  mo.angle = ANG45 * _PM_IDiv(mthing.angle, 45)
  if (mthing.options & MTF_AMBUSH) != 0 then
    mo.flags = mo.flags | mobjflag_t.MF_AMBUSH
  end if
  mo.reactiontime = 18

  P_RemoveMobj(mobj)
end function

/// Spawns a randomized-height bullet puff and selects its melee-safe animation variant.
/// @param x Horizontal map- or screen-space coordinate.
/// @param y Vertical map- or screen-space coordinate.
/// @param z Vertical world-space coordinate.
function P_SpawnPuff(x, y, z)
  z = z +((P_Random() - P_Random()) << 10)

  th = P_SpawnMobj(x, y, z, mobjtype_t.MT_PUFF)
  if th is void then return end if
  th.momz = FRACUNIT
  if typeof(th.tics) != "int" then th.tics = 1 end if
  th.tics = th.tics -(P_Random() & 3)
  if th.tics < 1 then th.tics = 1 end if

  if attackrange == MELEERANGE then
    P_SetMobjState(th, statenum_t.S_PUFF3)
  end if
end function

/// Spawns a randomized blood spray and selects its damage-scaled animation state.
/// @param x Horizontal map- or screen-space coordinate.
/// @param y Vertical map- or screen-space coordinate.
/// @param z Vertical world-space coordinate.
/// @param damage Damage value supplied to `P_SpawnBlood`.
function P_SpawnBlood(x, y, z, damage)
  z = z +((P_Random() - P_Random()) << 10)

  th = P_SpawnMobj(x, y, z, mobjtype_t.MT_BLOOD)
  if th is void then return end if
  th.momz = FRACUNIT * 2
  if typeof(th.tics) != "int" then th.tics = 1 end if
  th.tics = th.tics -(P_Random() & 3)
  if th.tics < 1 then th.tics = 1 end if

  if damage <= 12 and damage >= 9 then
    P_SetMobjState(th, statenum_t.S_BLOOD2)
  else if damage < 9 then
    P_SetMobjState(th, statenum_t.S_BLOOD3)
  end if
end function

/// Advances one actor's movement/state timer and triggers nightmare respawn when eligible.
/// @param mo Map object affected by the operation.
function P_MobjThinker(mo)
  if mo is void then return end if
  owner = _PM_ResolveThinkerOwner(mo)
  if owner is not void then
    mo = owner
  end if
  if mo is void then return end if

  if mo.momx is void then mo.momx = 0 end if
  if mo.momy is void then mo.momy = 0 end if
  if mo.momz is void then mo.momz = 0 end if

  if mo.momx != 0 or mo.momy != 0 or(mo.flags & mobjflag_t.MF_SKULLFLY) != 0 then
    P_XYMovement(mo)
    if mo.thinker is not void and mo.thinker.func is not void and mo.thinker.func.acv == -1 then
      return
    end if
  end if

  if mo.z != mo.floorz or mo.momz != 0 then
    P_ZMovement(mo)
    if mo.thinker is not void and mo.thinker.func is not void and mo.thinker.func.acv == -1 then
      return
    end if
  end if

  if mo.tics != -1 then
    if mo.tics > 0 then
      mo.tics = mo.tics - 1
      if mo.tics == 0 then
        if mo.state is void then return end if
        if typeof(mo.state) == "struct" and mo.state.nextstate is not void then
          if not P_SetMobjState(mo, mo.state.nextstate) then
            return
          end if
        end if
      end if
    end if
  else
    if (mo.flags & mobjflag_t.MF_COUNTKILL) == 0 then return end if
    if not respawnmonsters then return end if

    mo.movecount = mo.movecount + 1
    if mo.movecount < 12 * TICRATE then return end if
    if (leveltime & 31) != 0 then return end if
    if P_Random() > 4 then return end if

    P_NightmareRespawn(mo)
    return
  end if

  if typeof(P_RespawnSpecials) == "function" and respawnmonsters then

    if false then
      P_RespawnSpecials()
    end if
  end if
end function

/// Respawns one queued pickup after its delay when the destination is unoccupied.
function P_RespawnSpecials()
  dm = deathmatch
  if typeof(dm) != "int" then dm = 0 end if
  if dm != 2 then return end if

  if iquehead == iquetail then return end if
  if leveltime - itemrespawntime[iquetail] < 30 * TICRATE then return end if

  mthing = itemrespawnque[iquetail]
  x = mthing.x << FRACBITS
  y = mthing.y << FRACBITS

  ss = R_PointInSubsector(x, y)
  if ss is not void and ss.sector is not void then
    fog = P_SpawnMobj(x, y, ss.sector.floorheight, mobjtype_t.MT_IFOG)
    if typeof(S_StartSound) == "function" then S_StartSound(fog, sfxenum_t.sfx_itmbk) end if
  end if

  spawnType = -1
  i = 0
  while typeof(mobjinfo) == "array" and i < len(mobjinfo)
    if mobjinfo[i].doomednum == mthing.type then
      spawnType = i
      break
    end if
    i = i + 1
  end while
  if spawnType < 0 then return end if

  z = ONFLOORZ
  if (mobjinfo[spawnType].flags & mobjflag_t.MF_SPAWNCEILING) != 0 then
    z = ONCEILINGZ
  end if

  mo = P_SpawnMobj(x, y, z, spawnType)
  if mo is not void then
    mo.spawnpoint = mthing
    mo.angle = ANG45 * _PM_IDiv(mthing.angle, 45)
  end if

  global iquetail
  iquetail =(iquetail + 1) &(ITEMQUESIZE - 1)
end function



