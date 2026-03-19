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

  Script: p_enemy.ml
  Purpose: Implements core gameplay simulation: map logic, physics, AI, and world interaction.
*/
import m_random
import i_system
import doomdef
import p_local
import m_fixed
import tables
import p_map
import p_maputl
import p_sight
import p_mobj
import p_inter
import p_switch
import p_doors
import p_floor
import s_sound
import g_game
import doomstat
import r_state
import r_main
import sounds
import std.math

const DI_EAST = 0
const DI_NORTHEAST = 1
const DI_NORTH = 2
const DI_NORTHWEST = 3
const DI_WEST = 4
const DI_SOUTHWEST = 5
const DI_SOUTH = 6
const DI_SOUTHEAST = 7
const DI_NODIR = 8
const PE_FRACUNIT = 65536

opposite =[DI_WEST, DI_SOUTHWEST, DI_SOUTH, DI_SOUTHEAST, DI_EAST, DI_NORTHEAST, DI_NORTH, DI_NORTHWEST, DI_NODIR]
diags =[DI_NORTHWEST, DI_NORTHEAST, DI_SOUTHWEST, DI_SOUTHEAST]
xspeed =[PE_FRACUNIT, 47000, 0, -47000, - PE_FRACUNIT, -47000, 0, 47000]
yspeed =[0, 47000, PE_FRACUNIT, 47000, 0, -47000, - PE_FRACUNIT, -47000]

const TRACEANGLE = 0xc000000
const FATSPREAD = ANG90 >> 3
const SKULLSPEED = 20 * PE_FRACUNIT

soundtarget = void
corpsehit = void
vileobj = void
viletryx = 0
viletryy = 0
braintargets =[]
numbraintargets = 0
braintargeton = 0
_PE_brain_easy = 0

/*
* Function: _PE_Abs
* Purpose: Implements the _PE_Abs routine for the internal module support.
*/
function _PE_Abs(v)
  if v < 0 then return - v end if
  return v
end function

/*
* Function: _PE_IDiv
* Purpose: Implements the _PE_IDiv routine for the internal module support.
*/
function _PE_IDiv(a, b)
  if typeof(a) != "int" or typeof(b) != "int" or b == 0 then return 0 end if
  q = a / b
  if q >= 0 then return std.math.floor(q) end if
  return std.math.ceil(q)
end function

/*
* Function: _PE_StartSound
* Purpose: Starts runtime behavior in the internal module support.
*/
function _PE_StartSound(origin, sfx)
  if typeof(S_StartSound) == "function" then
    S_StartSound(origin, sfx)
  end if
end function

/*
* Function: _PE_JunkLineWithTag
* Purpose: Implements the _PE_JunkLineWithTag routine for the internal module support.
*/
function _PE_JunkLineWithTag(tag)
  return line_t(void, void, 0, 0, 0, 0, tag,[0, -1],[0, 0, 0, 0], 0, void, void, 0, void)
end function

/*
* Function: _PE_ResolveThinkerMobj
* Purpose: Advances per-tick logic for the internal module support.
*/
function _PE_ResolveThinkerMobj(cur)
  if cur is void then return void end if
  if cur.func is void or cur.func.acp1 != P_MobjThinker then return void end if
  obj = cur
  if typeof(P_ResolveThinkerOwner) == "function" then
    own = P_ResolveThinkerOwner(cur)
    if own is not void then obj = own end if
  end if
  return obj
end function

/*
* Function: _PE_HasOtherAliveType
* Purpose: Implements the _PE_HasOtherAliveType routine for the internal module support.
*/
function _PE_HasOtherAliveType(exceptMo, moType)
  cur = thinkercap.next
  while cur is not void and cur != thinkercap
    obj = _PE_ResolveThinkerMobj(cur)
    if obj is not void and obj != exceptMo and obj.type == moType and obj.health > 0 then
      return true
    end if
    cur = cur.next
  end while
  return false
end function

/*
* Function: P_RecursiveSound
* Purpose: Implements the P_RecursiveSound routine for the gameplay and world simulation.
*/
function P_RecursiveSound(sec, soundblocks)
  global soundtarget

  if sec is void then return end if

  if sec.validcount == validcount and sec.soundtraversed <= soundblocks + 1 then
    return
  end if

  sec.validcount = validcount
  sec.soundtraversed = soundblocks + 1
  sec.soundtarget = soundtarget

  i = 0
  while i < sec.linecount
    check = sec.lines[i]
    if (check.flags & ML_TWOSIDED) == 0 then
      i = i + 1
      continue
    end if

    P_LineOpening(check)
    if openrange <= 0 then
      i = i + 1
      continue
    end if

    other = void
    if sides[check.sidenum[0]].sector == sec then
      other = sides[check.sidenum[1]].sector
    else
      other = sides[check.sidenum[0]].sector
    end if

    if (check.flags & ML_SOUNDBLOCK) != 0 then
      if soundblocks == 0 then
        P_RecursiveSound(other, 1)
      end if
    else
      P_RecursiveSound(other, soundblocks)
    end if
    i = i + 1
  end while
end function

/*
* Function: P_NoiseAlert
* Purpose: Implements the P_NoiseAlert routine for the gameplay and world simulation.
*/
function P_NoiseAlert(target, emmiter)
  global soundtarget
  global validcount

  soundtarget = target
  validcount = validcount + 1
  P_RecursiveSound(emmiter.subsector.sector, 0)
end function

/*
* Function: P_CheckMeleeRange
* Purpose: Evaluates conditions and returns a decision for the gameplay and world simulation.
*/
function P_CheckMeleeRange(actor)
  if actor is void or actor.target is void then return false end if
  pl = actor.target
  if pl.info is void then return false end if

  dist = P_AproxDistance(pl.x - actor.x, pl.y - actor.y)
  if dist >= MELEERANGE - 20 * PE_FRACUNIT + pl.info.radius then
    return false
  end if

  return P_CheckSight(actor, actor.target)
end function

/*
* Function: P_CheckMissileRange
* Purpose: Evaluates conditions and returns a decision for the gameplay and world simulation.
*/
function P_CheckMissileRange(actor)
  if actor is void or actor.target is void then return false end if
  if not P_CheckSight(actor, actor.target) then return false end if

  if (actor.flags & mobjflag_t.MF_JUSTHIT) != 0 then
    actor.flags = actor.flags &(~mobjflag_t.MF_JUSTHIT)
    return true
  end if

  if actor.reactiontime then return false end if

  dist = P_AproxDistance(actor.x - actor.target.x, actor.y - actor.target.y) - 64 * PE_FRACUNIT
  if actor.info is not void and(actor.info.meleestate is void or actor.info.meleestate == statenum_t.S_NULL) then
    dist = dist - 128 * PE_FRACUNIT
  end if
  dist = dist >> 16

  if actor.type == mobjtype_t.MT_VILE and dist > 14 * 64 then return false end if

  if actor.type == mobjtype_t.MT_UNDEAD then
    if dist < 196 then return false end if
    dist = dist >> 1
  end if

  if actor.type == mobjtype_t.MT_CYBORG or actor.type == mobjtype_t.MT_SPIDER or actor.type == mobjtype_t.MT_SKULL then
    dist = dist >> 1
  end if

  if dist > 200 then dist = 200 end if
  if actor.type == mobjtype_t.MT_CYBORG and dist > 160 then dist = 160 end if

  if P_Random() < dist then return false end if
  return true
end function

/*
* Function: P_Move
* Purpose: Computes movement/collision behavior in the gameplay and world simulation.
*/
function P_Move(actor)
  global numspechit
  global spechit

  if actor is void or actor.info is void then return false end if
  if actor.movedir == DI_NODIR then return false end if
  if actor.movedir < 0 or actor.movedir >= 8 then
    if typeof(I_Error) == "function" then I_Error("P_Move: Weird actor.movedir") end if
    return false
  end if

  tryx = actor.x + actor.info.speed * xspeed[actor.movedir]
  tryy = actor.y + actor.info.speed * yspeed[actor.movedir]
  try_ok = P_TryMove(actor, tryx, tryy)

  if not try_ok then
    if (actor.flags & mobjflag_t.MF_FLOAT) != 0 and floatok then
      if actor.z < tmfloorz then
        actor.z = actor.z + FLOATSPEED
      else
        actor.z = actor.z - FLOATSPEED
      end if
      actor.flags = actor.flags | mobjflag_t.MF_INFLOAT
      return true
    end if

    if numspechit == 0 then return false end if

    actor.movedir = DI_NODIR
    good = false
    while numspechit > 0
      numspechit = numspechit - 1
      ld = spechit[numspechit]
      if typeof(P_UseSpecialLine) == "function" and ld is not void then
        if P_UseSpecialLine(actor, ld, 0) then good = true end if
      end if
    end while
    return good
  end if

  actor.flags = actor.flags &(~mobjflag_t.MF_INFLOAT)
  if (actor.flags & mobjflag_t.MF_FLOAT) == 0 then
    actor.z = actor.floorz
  end if
  return true
end function

/*
* Function: P_TryWalk
* Purpose: Computes movement/collision behavior in the gameplay and world simulation.
*/
function P_TryWalk(actor)
  if not P_Move(actor) then return false end if
  actor.movecount = P_Random() & 15
  return true
end function

/*
* Function: P_NewChaseDir
* Purpose: Implements the P_NewChaseDir routine for the gameplay and world simulation.
*/
function P_NewChaseDir(actor)
  if actor is void or actor.target is void then
    if typeof(I_Error) == "function" then I_Error("P_NewChaseDir: no target") end if
    return
  end if

  olddir = actor.movedir
  if olddir < 0 or olddir >= len(opposite) then olddir = DI_NODIR end if
  turnaround = opposite[olddir]

  deltax = actor.target.x - actor.x
  deltay = actor.target.y - actor.y

  d1 = DI_NODIR
  if deltax > 10 * PE_FRACUNIT then
    d1 = DI_EAST
  else if deltax < -10 * PE_FRACUNIT then
    d1 = DI_WEST
  end if

  d2 = DI_NODIR
  if deltay < -10 * PE_FRACUNIT then
    d2 = DI_SOUTH
  else if deltay > 10 * PE_FRACUNIT then
    d2 = DI_NORTH
  end if

  if d1 != DI_NODIR and d2 != DI_NODIR then
    didx = 0
    if deltay < 0 then didx = didx + 2 end if
    if deltax > 0 then didx = didx + 1 end if
    actor.movedir = diags[didx]
    if actor.movedir != turnaround and P_TryWalk(actor) then return end if
  end if

  if P_Random() > 200 or _PE_Abs(deltay) > _PE_Abs(deltax) then
    td = d1
    d1 = d2
    d2 = td
  end if

  if d1 == turnaround then d1 = DI_NODIR end if
  if d2 == turnaround then d2 = DI_NODIR end if

  if d1 != DI_NODIR then
    actor.movedir = d1
    if P_TryWalk(actor) then return end if
  end if
  if d2 != DI_NODIR then
    actor.movedir = d2
    if P_TryWalk(actor) then return end if
  end if

  if olddir != DI_NODIR then
    actor.movedir = olddir
    if P_TryWalk(actor) then return end if
  end if

  if (P_Random() & 1) != 0 then
    tdir = DI_EAST
    while tdir <= DI_SOUTHEAST
      if tdir != turnaround then
        actor.movedir = tdir
        if P_TryWalk(actor) then return end if
      end if
      tdir = tdir + 1
    end while
  else
    tdir = DI_SOUTHEAST
    while tdir >= DI_EAST
      if tdir != turnaround then
        actor.movedir = tdir
        if P_TryWalk(actor) then return end if
      end if
      tdir = tdir - 1
    end while
  end if

  if turnaround != DI_NODIR then
    actor.movedir = turnaround
    if P_TryWalk(actor) then return end if
  end if

  actor.movedir = DI_NODIR
end function

/*
* Function: P_LookForPlayers
* Purpose: Implements the P_LookForPlayers routine for the gameplay and world simulation.
*/
function P_LookForPlayers(actor, allaround)
  if actor is void then return false end if
  if typeof(players) != "array" or typeof(playeringame) != "array" then return false end if

  c = 0
  stop =(actor.lastlook - 1) & 3

  while true
    idx = actor.lastlook & 3

    if idx >= len(playeringame) or(not playeringame[idx]) then
      actor.lastlook =(idx + 1) & 3
      continue
    end if

    if c == 2 or idx == stop then
      return false
    end if
    c = c + 1

    if idx >= len(players) then
      actor.lastlook =(idx + 1) & 3
      continue
    end if
    player = players[idx]
    if player is void or player.mo is void or player.health <= 0 then
      actor.lastlook =(idx + 1) & 3
      continue
    end if

    if not P_CheckSight(actor, player.mo) then
      actor.lastlook =(idx + 1) & 3
      continue
    end if

    if not allaround then
      an = R_PointToAngle2(actor.x, actor.y, player.mo.x, player.mo.y) - actor.angle
      if an > ANG90 and an < ANG270 then
        dist = P_AproxDistance(player.mo.x - actor.x, player.mo.y - actor.y)
        if dist > MELEERANGE then
          actor.lastlook =(idx + 1) & 3
          continue
        end if
      end if
    end if

    actor.target = player.mo
    return true
  end while

  return false
end function

/*
* Function: A_Fall
* Purpose: Implements the A_Fall routine for the engine module behavior.
*/
function A_Fall(actor)
  if actor is void then return end if
  actor.flags = actor.flags &(~mobjflag_t.MF_SOLID)
end function

/*
* Function: A_KeenDie
* Purpose: Implements the A_KeenDie routine for the engine module behavior.
*/
function A_KeenDie(mo)
  if mo is void then return end if
  A_Fall(mo)

  if _PE_HasOtherAliveType(mo, mo.type) then return end if

  junk = _PE_JunkLineWithTag(666)
  EV_DoDoor(junk, vldoor_e.open)
end function

/*
* Function: A_Look
* Purpose: Implements the A_Look routine for the engine module behavior.
*/
function A_Look(actor)
  if actor is void then return end if
  actor.threshold = 0

  targ = void
  if actor.subsector is not void and actor.subsector.sector is not void then
    targ = actor.subsector.sector.soundtarget
  end if

  seeyou = false
  if targ is not void and(targ.flags & mobjflag_t.MF_SHOOTABLE) != 0 then
    actor.target = targ
    if (actor.flags & mobjflag_t.MF_AMBUSH) != 0 then
      if P_CheckSight(actor, actor.target) then seeyou = true end if
    else
      seeyou = true
    end if
  end if

  if (not seeyou) and(not P_LookForPlayers(actor, false)) then
    return
  end if

  if actor.info is not void and actor.info.seesound is not void and actor.info.seesound != sfxenum_t.sfx_None then
    sound = actor.info.seesound
    if sound == sfxenum_t.sfx_posit1 or sound == sfxenum_t.sfx_posit2 or sound == sfxenum_t.sfx_posit3 then
      sound = sfxenum_t.sfx_posit1 +(P_Random() % 3)
    else if sound == sfxenum_t.sfx_bgsit1 or sound == sfxenum_t.sfx_bgsit2 then
      sound = sfxenum_t.sfx_bgsit1 +(P_Random() % 2)
    end if

    if actor.type == mobjtype_t.MT_SPIDER or actor.type == mobjtype_t.MT_CYBORG then
      _PE_StartSound(void, sound)
    else
      _PE_StartSound(actor, sound)
    end if
  end if

  if actor.info is not void then
    P_SetMobjState(actor, actor.info.seestate)
  end if
end function

/*
* Function: A_Chase
* Purpose: Implements the A_Chase routine for the engine module behavior.
*/
function A_Chase(actor)
  if actor is void or actor.info is void then return end if

  if actor.reactiontime then actor.reactiontime = actor.reactiontime - 1 end if

  if actor.threshold then
    if actor.target is void or actor.target.health <= 0 then
      actor.threshold = 0
    else
      actor.threshold = actor.threshold - 1
    end if
  end if

  if actor.movedir >= 0 and actor.movedir < 8 then
    actor.angle = actor.angle &(7 << 29)
    delta = actor.angle -(actor.movedir << 29)
    if delta > 0 then
      actor.angle = actor.angle -(ANG90 >> 1)
    else if delta < 0 then
      actor.angle = actor.angle +(ANG90 >> 1)
    end if
  end if

  if actor.target is void or(actor.target.flags & mobjflag_t.MF_SHOOTABLE) == 0 then
    if P_LookForPlayers(actor, true) then return end if
    P_SetMobjState(actor, actor.info.spawnstate)
    return
  end if

  if (actor.flags & mobjflag_t.MF_JUSTATTACKED) != 0 then
    actor.flags = actor.flags &(~mobjflag_t.MF_JUSTATTACKED)
    if gameskill != sk_nightmare and(not fastparm) then
      P_NewChaseDir(actor)
    end if
    return
  end if

  if actor.info.meleestate is not void and actor.info.meleestate != statenum_t.S_NULL and P_CheckMeleeRange(actor) then
    if actor.info.attacksound is not void and actor.info.attacksound != sfxenum_t.sfx_None then
      _PE_StartSound(actor, actor.info.attacksound)
    end if
    P_SetMobjState(actor, actor.info.meleestate)
    return
  end if

  if actor.info.missilestate is not void and actor.info.missilestate != statenum_t.S_NULL then
    if gameskill != sk_nightmare and(not fastparm) and actor.movecount then

    else
      if P_CheckMissileRange(actor) then
        P_SetMobjState(actor, actor.info.missilestate)
        actor.flags = actor.flags | mobjflag_t.MF_JUSTATTACKED
        return
      end if
    end if
  end if

  if netgame and(not actor.threshold) and(not P_CheckSight(actor, actor.target)) then
    if P_LookForPlayers(actor, true) then return end if
  end if

  actor.movecount = actor.movecount - 1
  if actor.movecount < 0 or(not P_Move(actor)) then
    P_NewChaseDir(actor)
  end if

  if actor.info.activesound is not void and actor.info.activesound != sfxenum_t.sfx_None and P_Random() < 3 then
    _PE_StartSound(actor, actor.info.activesound)
  end if
end function

/*
* Function: A_FaceTarget
* Purpose: Reads or updates state used by the engine module behavior.
*/
function A_FaceTarget(actor)
  if actor is void or actor.target is void then return end if
  actor.flags = actor.flags &(~mobjflag_t.MF_AMBUSH)
  actor.angle = R_PointToAngle2(actor.x, actor.y, actor.target.x, actor.target.y)
  if (actor.target.flags & mobjflag_t.MF_SHADOW) != 0 then
    actor.angle = actor.angle +((P_Random() - P_Random()) << 21)
  end if
end function

/*
* Function: A_PosAttack
* Purpose: Implements the A_PosAttack routine for the engine module behavior.
*/
function A_PosAttack(actor)
  if actor is void or actor.target is void then return end if
  A_FaceTarget(actor)
  angle = actor.angle
  slope = P_AimLineAttack(actor, angle, MISSILERANGE)
  _PE_StartSound(actor, sfxenum_t.sfx_pistol)
  angle = angle +((P_Random() - P_Random()) << 20)
  damage =((P_Random() % 5) + 1) * 3
  P_LineAttack(actor, angle, MISSILERANGE, slope, damage)
end function

/*
* Function: A_SPosAttack
* Purpose: Implements the A_SPosAttack routine for the engine module behavior.
*/
function A_SPosAttack(actor)
  if actor is void or actor.target is void then return end if
  _PE_StartSound(actor, sfxenum_t.sfx_shotgn)
  A_FaceTarget(actor)
  bangle = actor.angle
  slope = P_AimLineAttack(actor, bangle, MISSILERANGE)

  for i = 0 to 2
    angle = bangle +((P_Random() - P_Random()) << 20)
    damage =((P_Random() % 5) + 1) * 3
    P_LineAttack(actor, angle, MISSILERANGE, slope, damage)
  end for
end function

/*
* Function: A_CPosAttack
* Purpose: Implements the A_CPosAttack routine for the engine module behavior.
*/
function A_CPosAttack(actor)
  if actor is void or actor.target is void then return end if
  _PE_StartSound(actor, sfxenum_t.sfx_shotgn)
  A_FaceTarget(actor)
  bangle = actor.angle
  slope = P_AimLineAttack(actor, bangle, MISSILERANGE)
  angle = bangle +((P_Random() - P_Random()) << 20)
  damage =((P_Random() % 5) + 1) * 3
  P_LineAttack(actor, angle, MISSILERANGE, slope, damage)
end function

/*
* Function: A_CPosRefire
* Purpose: Implements the A_CPosRefire routine for the engine module behavior.
*/
function A_CPosRefire(actor)
  if actor is void then return end if
  A_FaceTarget(actor)
  if P_Random() < 40 then return end if
  if actor.target is void or actor.target.health <= 0 or(not P_CheckSight(actor, actor.target)) then
    if actor.info is not void then P_SetMobjState(actor, actor.info.seestate) end if
  end if
end function

/*
* Function: A_SpidRefire
* Purpose: Implements the A_SpidRefire routine for the engine module behavior.
*/
function A_SpidRefire(actor)
  if actor is void then return end if
  A_FaceTarget(actor)
  if P_Random() < 10 then return end if
  if actor.target is void or actor.target.health <= 0 or(not P_CheckSight(actor, actor.target)) then
    if actor.info is not void then P_SetMobjState(actor, actor.info.seestate) end if
  end if
end function

/*
* Function: A_BspiAttack
* Purpose: Implements the A_BspiAttack routine for the engine module behavior.
*/
function A_BspiAttack(actor)
  if actor is void or actor.target is void then return end if
  A_FaceTarget(actor)
  P_SpawnMissile(actor, actor.target, mobjtype_t.MT_ARACHPLAZ)
end function

/*
* Function: A_TroopAttack
* Purpose: Implements the A_TroopAttack routine for the engine module behavior.
*/
function A_TroopAttack(actor)
  if actor is void or actor.target is void then return end if
  A_FaceTarget(actor)
  if P_CheckMeleeRange(actor) then
    _PE_StartSound(actor, sfxenum_t.sfx_claw)
    damage =((P_Random() % 8) + 1) * 3
    P_DamageMobj(actor.target, actor, actor, damage)
    return
  end if
  P_SpawnMissile(actor, actor.target, mobjtype_t.MT_TROOPSHOT)
end function

/*
* Function: A_SargAttack
* Purpose: Implements the A_SargAttack routine for the engine module behavior.
*/
function A_SargAttack(actor)
  if actor is void or actor.target is void then return end if
  A_FaceTarget(actor)
  if P_CheckMeleeRange(actor) then
    damage =((P_Random() % 10) + 1) * 4
    P_DamageMobj(actor.target, actor, actor, damage)
  end if
end function

/*
* Function: A_HeadAttack
* Purpose: Implements the A_HeadAttack routine for the engine module behavior.
*/
function A_HeadAttack(actor)
  if actor is void or actor.target is void then return end if
  A_FaceTarget(actor)
  if P_CheckMeleeRange(actor) then
    damage =((P_Random() % 6) + 1) * 10
    P_DamageMobj(actor.target, actor, actor, damage)
    return
  end if
  P_SpawnMissile(actor, actor.target, mobjtype_t.MT_HEADSHOT)
end function

/*
* Function: A_CyberAttack
* Purpose: Implements the A_CyberAttack routine for the engine module behavior.
*/
function A_CyberAttack(actor)
  if actor is void or actor.target is void then return end if
  A_FaceTarget(actor)
  P_SpawnMissile(actor, actor.target, mobjtype_t.MT_ROCKET)
end function

/*
* Function: A_BruisAttack
* Purpose: Implements the A_BruisAttack routine for the engine module behavior.
*/
function A_BruisAttack(actor)
  if actor is void or actor.target is void then return end if
  if P_CheckMeleeRange(actor) then
    _PE_StartSound(actor, sfxenum_t.sfx_claw)
    damage =((P_Random() % 8) + 1) * 10
    P_DamageMobj(actor.target, actor, actor, damage)
    return
  end if
  P_SpawnMissile(actor, actor.target, mobjtype_t.MT_BRUISERSHOT)
end function

/*
* Function: A_SkelMissile
* Purpose: Implements the A_SkelMissile routine for the engine module behavior.
*/
function A_SkelMissile(actor)
  if actor is void or actor.target is void then return end if
  A_FaceTarget(actor)
  actor.z = actor.z + 16 * PE_FRACUNIT
  mo = P_SpawnMissile(actor, actor.target, mobjtype_t.MT_TRACER)
  actor.z = actor.z - 16 * PE_FRACUNIT
  if mo is not void then
    mo.x = mo.x + mo.momx
    mo.y = mo.y + mo.momy
    mo.tracer = actor.target
  end if
end function

/*
* Function: A_Tracer
* Purpose: Implements the A_Tracer routine for the engine module behavior.
*/
function A_Tracer(actor)
  if actor is void then return end if
  if (gametic & 3) != 0 then return end if

  if typeof(P_SpawnPuff) == "function" then
    P_SpawnPuff(actor.x, actor.y, actor.z)
  end if

  th = P_SpawnMobj(actor.x - actor.momx, actor.y - actor.momy, actor.z, mobjtype_t.MT_SMOKE)
  if th is not void then
    th.momz = PE_FRACUNIT
    th.tics = th.tics -(P_Random() & 3)
    if th.tics < 1 then th.tics = 1 end if
  end if

  dest = actor.tracer
  if dest is void or dest.health <= 0 then return end if

  exact = R_PointToAngle2(actor.x, actor.y, dest.x, dest.y)
  if exact != actor.angle then
    if exact > actor.angle then
      actor.angle = actor.angle + TRACEANGLE
      if exact - actor.angle < TRACEANGLE then actor.angle = exact end if
    else
      actor.angle = actor.angle - TRACEANGLE
      if actor.angle - exact < TRACEANGLE then actor.angle = exact end if
    end if
  end if

  an =(actor.angle >> ANGLETOFINESHIFT) & FINEMASK
  speed = 0
  if actor.info is not void and typeof(actor.info.speed) == "int" then speed = actor.info.speed end if
  actor.momx = FixedMul(speed, finecosine[an])
  actor.momy = FixedMul(speed, finesine[an])

  dist = P_AproxDistance(dest.x - actor.x, dest.y - actor.y)
  if speed != 0 then
    dist = _PE_IDiv(dist, speed)
  else
    dist = 1
  end if
  if dist < 1 then dist = 1 end if

  slope = _PE_IDiv((dest.z + 40 * PE_FRACUNIT - actor.z), dist)
  if slope < actor.momz then
    actor.momz = actor.momz -(PE_FRACUNIT >> 3)
  else
    actor.momz = actor.momz +(PE_FRACUNIT >> 3)
  end if
end function

/*
* Function: A_SkelWhoosh
* Purpose: Implements the A_SkelWhoosh routine for the engine module behavior.
*/
function A_SkelWhoosh(actor)
  if actor is void or actor.target is void then return end if
  A_FaceTarget(actor)
  _PE_StartSound(actor, sfxenum_t.sfx_skeswg)
end function

/*
* Function: A_SkelFist
* Purpose: Implements the A_SkelFist routine for the engine module behavior.
*/
function A_SkelFist(actor)
  if actor is void or actor.target is void then return end if
  A_FaceTarget(actor)
  if P_CheckMeleeRange(actor) then
    damage =((P_Random() % 10) + 1) * 6
    _PE_StartSound(actor, sfxenum_t.sfx_skepch)
    P_DamageMobj(actor.target, actor, actor, damage)
  end if
end function

/*
* Function: PIT_VileCheck
* Purpose: Evaluates conditions and returns a decision for the engine module behavior.
*/
function PIT_VileCheck(thing)
  global corpsehit
  global viletryx
  global viletryy

  if thing is void then return true end if
  if (thing.flags & mobjflag_t.MF_CORPSE) == 0 then return true end if
  if thing.tics != -1 then return true end if
  if thing.info is void or thing.info.raisestate == statenum_t.S_NULL then return true end if

  maxdist = thing.info.radius
  if typeof(mobjinfo) == "array" and mobjtype_t.MT_VILE < len(mobjinfo) and mobjinfo[mobjtype_t.MT_VILE] is not void then
    maxdist = maxdist + mobjinfo[mobjtype_t.MT_VILE].radius
  end if

  if _PE_Abs(thing.x - viletryx) > maxdist or _PE_Abs(thing.y - viletryy) > maxdist then
    return true
  end if

  corpsehit = thing
  corpsehit.momx = 0
  corpsehit.momy = 0
  oldh = corpsehit.height
  corpsehit.height = corpsehit.height << 2

  check = true
  if typeof(P_CheckPosition) == "function" then
    check = P_CheckPosition(corpsehit, corpsehit.x, corpsehit.y)
  end if
  corpsehit.height = oldh

  if not check then return true end if
  return false
end function

/*
* Function: A_VileChase
* Purpose: Implements the A_VileChase routine for the engine module behavior.
*/
function A_VileChase(actor)
  global viletryx
  global viletryy
  global corpsehit
  global vileobj

  if actor is void then return end if

  if actor.movedir != DI_NODIR then
    viletryx = actor.x + actor.info.speed * xspeed[actor.movedir]
    viletryy = actor.y + actor.info.speed * yspeed[actor.movedir]

    xl =(viletryx - bmaporgx - MAXRADIUS * 2) >> MAPBLOCKSHIFT
    xh =(viletryx - bmaporgx + MAXRADIUS * 2) >> MAPBLOCKSHIFT
    yl =(viletryy - bmaporgy - MAXRADIUS * 2) >> MAPBLOCKSHIFT
    yh =(viletryy - bmaporgy + MAXRADIUS * 2) >> MAPBLOCKSHIFT

    vileobj = actor
    bx = xl
    while bx <= xh
      by = yl
      while by <= yh
        if typeof(P_BlockThingsIterator) == "function" then
          if not P_BlockThingsIterator(bx, by, PIT_VileCheck) then
            temp = actor.target
            actor.target = corpsehit
            A_FaceTarget(actor)
            actor.target = temp

            P_SetMobjState(actor, statenum_t.S_VILE_HEAL1)
            _PE_StartSound(corpsehit, sfxenum_t.sfx_slop)

            info = corpsehit.info
            if info is not void then
              P_SetMobjState(corpsehit, info.raisestate)
              corpsehit.height = corpsehit.height << 2
              corpsehit.flags = info.flags
              corpsehit.health = info.spawnhealth
              corpsehit.target = void
            end if
            return
          end if
        end if
        by = by + 1
      end while
      bx = bx + 1
    end while
  end if

  A_Chase(actor)
end function

/*
* Function: A_VileStart
* Purpose: Starts runtime behavior in the engine module behavior.
*/
function A_VileStart(actor)
  if actor is void then return end if
  _PE_StartSound(actor, sfxenum_t.sfx_vilatk)
end function

/*
* Function: A_StartFire
* Purpose: Starts runtime behavior in the engine module behavior.
*/
function A_StartFire(actor)
  if actor is void then return end if
  _PE_StartSound(actor, sfxenum_t.sfx_flamst)
  A_Fire(actor)
end function

/*
* Function: A_FireCrackle
* Purpose: Implements the A_FireCrackle routine for the engine module behavior.
*/
function A_FireCrackle(actor)
  if actor is void then return end if
  _PE_StartSound(actor, sfxenum_t.sfx_flame)
  A_Fire(actor)
end function

/*
* Function: A_Fire
* Purpose: Implements the A_Fire routine for the engine module behavior.
*/
function A_Fire(actor)
  if actor is void then return end if
  dest = actor.tracer
  if dest is void then return end if
  if actor.target is void then return end if

  if not P_CheckSight(actor.target, dest) then return end if

  an =(dest.angle >> ANGLETOFINESHIFT) & FINEMASK
  P_UnsetThingPosition(actor)
  actor.x = dest.x + FixedMul(24 * FRACUNIT, finecosine[an])
  actor.y = dest.y + FixedMul(24 * FRACUNIT, finesine[an])
  actor.z = dest.z
  P_SetThingPosition(actor)
end function

/*
* Function: A_VileTarget
* Purpose: Reads or updates state used by the engine module behavior.
*/
function A_VileTarget(actor)
  if actor is void or actor.target is void then return end if

  A_FaceTarget(actor)

  fog = P_SpawnMobj(actor.target.x, actor.target.x, actor.target.z, mobjtype_t.MT_FIRE)
  if fog is void then return end if
  actor.tracer = fog
  fog.target = actor
  fog.tracer = actor.target
  A_Fire(fog)
end function

/*
* Function: A_VileAttack
* Purpose: Implements the A_VileAttack routine for the engine module behavior.
*/
function A_VileAttack(actor)
  if actor is void or actor.target is void then return end if

  A_FaceTarget(actor)
  if not P_CheckSight(actor, actor.target) then return end if

  _PE_StartSound(actor, sfxenum_t.sfx_barexp)
  P_DamageMobj(actor.target, actor, actor, 20)

  mass = 1
  if actor.target.info is not void and actor.target.info.mass is not void and actor.target.info.mass != 0 then
    mass = actor.target.info.mass
  end if
  actor.target.momz = _PE_IDiv((1000 * FRACUNIT), mass)

  an =(actor.angle >> ANGLETOFINESHIFT) & FINEMASK
  fire = actor.tracer
  if fire is void then return end if

  fire.x = actor.target.x - FixedMul(24 * FRACUNIT, finecosine[an])
  fire.y = actor.target.y - FixedMul(24 * FRACUNIT, finesine[an])
  P_RadiusAttack(fire, actor, 70)
end function

/*
* Function: A_FatRaise
* Purpose: Implements the A_FatRaise routine for the engine module behavior.
*/
function A_FatRaise(actor)
  if actor is void then return end if
  A_FaceTarget(actor)
  _PE_StartSound(actor, sfxenum_t.sfx_manatk)
end function

/*
* Function: A_FatAttack1
* Purpose: Implements the A_FatAttack1 routine for the engine module behavior.
*/
function A_FatAttack1(actor)
  if actor is void or actor.target is void then return end if
  A_FaceTarget(actor)
  actor.angle = actor.angle + FATSPREAD
  P_SpawnMissile(actor, actor.target, mobjtype_t.MT_FATSHOT)

  mo = P_SpawnMissile(actor, actor.target, mobjtype_t.MT_FATSHOT)
  if mo is not void then
    mo.angle = mo.angle + FATSPREAD
    an =(mo.angle >> ANGLETOFINESHIFT) & FINEMASK
    speed = 0
    if mo.info is not void and typeof(mo.info.speed) == "int" then speed = mo.info.speed end if
    mo.momx = FixedMul(speed, finecosine[an])
    mo.momy = FixedMul(speed, finesine[an])
  end if
end function

/*
* Function: A_FatAttack2
* Purpose: Implements the A_FatAttack2 routine for the engine module behavior.
*/
function A_FatAttack2(actor)
  if actor is void or actor.target is void then return end if
  A_FaceTarget(actor)
  actor.angle = actor.angle - FATSPREAD
  P_SpawnMissile(actor, actor.target, mobjtype_t.MT_FATSHOT)

  mo = P_SpawnMissile(actor, actor.target, mobjtype_t.MT_FATSHOT)
  if mo is not void then
    mo.angle = mo.angle - FATSPREAD * 2
    an =(mo.angle >> ANGLETOFINESHIFT) & FINEMASK
    speed = 0
    if mo.info is not void and typeof(mo.info.speed) == "int" then speed = mo.info.speed end if
    mo.momx = FixedMul(speed, finecosine[an])
    mo.momy = FixedMul(speed, finesine[an])
  end if
end function

/*
* Function: A_FatAttack3
* Purpose: Implements the A_FatAttack3 routine for the engine module behavior.
*/
function A_FatAttack3(actor)
  if actor is void or actor.target is void then return end if
  A_FaceTarget(actor)

  mo = P_SpawnMissile(actor, actor.target, mobjtype_t.MT_FATSHOT)
  if mo is not void then
    mo.angle = mo.angle -(FATSPREAD >> 1)
    an =(mo.angle >> ANGLETOFINESHIFT) & FINEMASK
    speed = 0
    if mo.info is not void and typeof(mo.info.speed) == "int" then speed = mo.info.speed end if
    mo.momx = FixedMul(speed, finecosine[an])
    mo.momy = FixedMul(speed, finesine[an])
  end if

  mo = P_SpawnMissile(actor, actor.target, mobjtype_t.MT_FATSHOT)
  if mo is not void then
    mo.angle = mo.angle +(FATSPREAD >> 1)
    an =(mo.angle >> ANGLETOFINESHIFT) & FINEMASK
    speed = 0
    if mo.info is not void and typeof(mo.info.speed) == "int" then speed = mo.info.speed end if
    mo.momx = FixedMul(speed, finecosine[an])
    mo.momy = FixedMul(speed, finesine[an])
  end if
end function

/*
* Function: A_SkullAttack
* Purpose: Implements the A_SkullAttack routine for the engine module behavior.
*/
function A_SkullAttack(actor)
  if actor is void or actor.target is void then return end if

  dest = actor.target
  actor.flags = actor.flags | mobjflag_t.MF_SKULLFLY
  if actor.info is not void and actor.info.attacksound is not void and actor.info.attacksound != sfxenum_t.sfx_None then
    _PE_StartSound(actor, actor.info.attacksound)
  end if

  A_FaceTarget(actor)
  an =(actor.angle >> ANGLETOFINESHIFT) & FINEMASK
  actor.momx = FixedMul(SKULLSPEED, finecosine[an])
  actor.momy = FixedMul(SKULLSPEED, finesine[an])

  dist = _PE_IDiv(P_AproxDistance(dest.x - actor.x, dest.y - actor.y), SKULLSPEED)
  if dist < 1 then dist = 1 end if
  actor.momz = _PE_IDiv((dest.z +(dest.height >> 1) - actor.z), dist)
end function

/*
* Function: _PE_PainShootSkull
* Purpose: Implements the _PE_PainShootSkull routine for the internal module support.
*/
function _PE_PainShootSkull(actor, angle)
  if actor is void or actor.target is void then return end if
  if typeof(mobjinfo) != "array" then return end if

  count = 0
  if thinkercap is not void then
    cur = thinkercap.next
    while cur is not void and cur != thinkercap
      obj = cur
      if typeof(P_ResolveThinkerOwner) == "function" then
        own = P_ResolveThinkerOwner(cur)
        if own is not void then obj = own end if
      end if
      if obj is not void and obj.type == mobjtype_t.MT_SKULL then count = count + 1 end if
      cur = cur.next
    end while
  end if
  if count > 20 then return end if

  an =(angle >> ANGLETOFINESHIFT) & FINEMASK
  prestep = 4 * PE_FRACUNIT + _PE_IDiv(3 *(actor.info.radius + mobjinfo[mobjtype_t.MT_SKULL].radius), 2)
  x = actor.x + FixedMul(prestep, finecosine[an])
  y = actor.y + FixedMul(prestep, finesine[an])
  z = actor.z + 8 * PE_FRACUNIT

  newmobj = P_SpawnMobj(x, y, z, mobjtype_t.MT_SKULL)
  if newmobj is void then return end if

  if not P_TryMove(newmobj, newmobj.x, newmobj.y) then
    P_DamageMobj(newmobj, actor, actor, 10000)
    return
  end if

  newmobj.target = actor.target
  A_SkullAttack(newmobj)
end function

/*
* Function: A_PainShootSkull
* Purpose: Implements the A_PainShootSkull routine for the engine module behavior.
*/
function A_PainShootSkull(actor, angle)
  _PE_PainShootSkull(actor, angle)
end function

/*
* Function: A_PainAttack
* Purpose: Implements the A_PainAttack routine for the engine module behavior.
*/
function A_PainAttack(actor)
  if actor is void or actor.target is void then return end if
  A_FaceTarget(actor)
  A_PainShootSkull(actor, actor.angle)
end function

/*
* Function: A_PainDie
* Purpose: Implements the A_PainDie routine for the engine module behavior.
*/
function A_PainDie(actor)
  if actor is void then return end if
  A_Fall(actor)
  A_PainShootSkull(actor, actor.angle + ANG90)
  A_PainShootSkull(actor, actor.angle + ANG180)
  A_PainShootSkull(actor, actor.angle + ANG270)
end function

/*
* Function: A_Scream
* Purpose: Implements the A_Scream routine for the engine module behavior.
*/
function A_Scream(actor)
  if actor is void or actor.info is void then return end if
  ds = actor.info.deathsound
  if ds is void or ds == 0 or ds == sfxenum_t.sfx_None then return end if

  sound = ds
  if ds == sfxenum_t.sfx_podth1 or ds == sfxenum_t.sfx_podth2 or ds == sfxenum_t.sfx_podth3 then
    sound = sfxenum_t.sfx_podth1 +(P_Random() % 3)
  else if ds == sfxenum_t.sfx_bgdth1 or ds == sfxenum_t.sfx_bgdth2 then
    sound = sfxenum_t.sfx_bgdth1 +(P_Random() % 2)
  end if

  if actor.type == mobjtype_t.MT_SPIDER or actor.type == mobjtype_t.MT_CYBORG then
    _PE_StartSound(void, sound)
  else
    _PE_StartSound(actor, sound)
  end if
end function

/*
* Function: A_XScream
* Purpose: Implements the A_XScream routine for the engine module behavior.
*/
function A_XScream(actor)
  _PE_StartSound(actor, sfxenum_t.sfx_slop)
end function

/*
* Function: A_Pain
* Purpose: Implements the A_Pain routine for the engine module behavior.
*/
function A_Pain(actor)
  if actor is void or actor.info is void then return end if
  if actor.info.painsound is not void and actor.info.painsound != sfxenum_t.sfx_None then
    _PE_StartSound(actor, actor.info.painsound)
  end if
end function

/*
* Function: A_Explode
* Purpose: Implements the A_Explode routine for the engine module behavior.
*/
function A_Explode(thingy)
  if thingy is void then return end if
  if typeof(P_RadiusAttack) == "function" then
    P_RadiusAttack(thingy, thingy.target, 128)
  end if
end function

/*
* Function: A_BossDeath
* Purpose: Implements the A_BossDeath routine for the engine module behavior.
*/
function A_BossDeath(mo)
  if mo is void then return end if

  if gamemode == commercial then
    if gamemap != 7 then return end if
    if mo.type != mobjtype_t.MT_FATSO and mo.type != mobjtype_t.MT_BABY then return end if
  else
    switch gameepisode
      case 1
        if gamemap != 8 then return end if
        if mo.type != mobjtype_t.MT_BRUISER then return end if
      end case

      case 2
        if gamemap != 8 then return end if
        if mo.type != mobjtype_t.MT_CYBORG then return end if
      end case

      case 3
        if gamemap != 8 then return end if
        if mo.type != mobjtype_t.MT_SPIDER then return end if
      end case

      case 4
        switch gamemap
          case 6
            if mo.type != mobjtype_t.MT_CYBORG then return end if
          end case
          case 8
            if mo.type != mobjtype_t.MT_SPIDER then return end if
          end case
          case default
            return
          end case
        end switch
      end case

      case default
        if gamemap != 8 then return end if
      end case
    end switch
  end if

  anyAlive = false
  i = 0
  while i < MAXPLAYERS
    if i < len(playeringame) and playeringame[i] and i < len(players) and typeof(players[i]) == "struct" and players[i].health > 0 then
      anyAlive = true
      break
    end if
    i = i + 1
  end while
  if not anyAlive then return end if

  if _PE_HasOtherAliveType(mo, mo.type) then return end if

  junk = _PE_JunkLineWithTag(0)

  if gamemode == commercial then
    if gamemap == 7 then
      if mo.type == mobjtype_t.MT_FATSO then
        junk.tag = 666
        EV_DoFloor(junk, floor_e.lowerFloorToLowest)
        return
      end if

      if mo.type == mobjtype_t.MT_BABY then
        junk.tag = 667
        EV_DoFloor(junk, floor_e.raiseToTexture)
        return
      end if
    end if
  else
    switch gameepisode
      case 1
        junk.tag = 666
        EV_DoFloor(junk, floor_e.lowerFloorToLowest)
        return
      end case

      case 4
        switch gamemap
          case 6
            junk.tag = 666
            EV_DoDoor(junk, vldoor_e.blazeOpen)
            return
          end case

          case 8
            junk.tag = 666
            EV_DoFloor(junk, floor_e.lowerFloorToLowest)
            return
          end case
        end switch
      end case
    end switch
  end if

  if typeof(G_ExitLevel) == "function" then G_ExitLevel() end if
end function

/*
* Function: A_Hoof
* Purpose: Implements the A_Hoof routine for the engine module behavior.
*/
function A_Hoof(mo)
  _PE_StartSound(mo, sfxenum_t.sfx_hoof)
  A_Chase(mo)
end function

/*
* Function: A_Metal
* Purpose: Implements the A_Metal routine for the engine module behavior.
*/
function A_Metal(mo)
  _PE_StartSound(mo, sfxenum_t.sfx_metal)
  A_Chase(mo)
end function

/*
* Function: A_BabyMetal
* Purpose: Implements the A_BabyMetal routine for the engine module behavior.
*/
function A_BabyMetal(mo)
  _PE_StartSound(mo, sfxenum_t.sfx_bspwlk)
  A_Chase(mo)
end function

/*
* Function: A_OpenShotgun2
* Purpose: Implements the A_OpenShotgun2 routine for the engine module behavior.
*/
function A_OpenShotgun2(player, psp)
  psp = psp
  if player is void then return end if
  if player.mo is void then return end if
  _PE_StartSound(player.mo, sfxenum_t.sfx_dbopn)
end function

/*
* Function: A_LoadShotgun2
* Purpose: Loads and prepares data required by the engine module behavior.
*/
function A_LoadShotgun2(player, psp)
  psp = psp
  if player is void then return end if
  if player.mo is void then return end if
  _PE_StartSound(player.mo, sfxenum_t.sfx_dbload)
end function

/*
* Function: A_CloseShotgun2
* Purpose: Implements the A_CloseShotgun2 routine for the engine module behavior.
*/
function A_CloseShotgun2(player, psp)
  if player is not void and player.mo is not void then
    _PE_StartSound(player.mo, sfxenum_t.sfx_dbcls)
  end if
  if typeof(A_ReFire) == "function" then
    A_ReFire(player, psp)
  end if
end function

/*
* Function: A_BrainAwake
* Purpose: Implements the A_BrainAwake routine for the engine module behavior.
*/
function A_BrainAwake(mo)
  global braintargets
  global numbraintargets
  global braintargeton

  mo = mo
  braintargets =[]
  numbraintargets = 0
  braintargeton = 0

  thinker = thinkercap.next
  while thinker is not void and thinker != thinkercap
    m = _PE_ResolveThinkerMobj(thinker)
    if m is not void and m.type == mobjtype_t.MT_BOSSTARGET then
      if len(braintargets) < 32 then
        braintargets = braintargets +[m]
        numbraintargets = len(braintargets)
      end if
    end if
    thinker = thinker.next
  end while

  _PE_StartSound(void, sfxenum_t.sfx_bossit)
end function

/*
* Function: A_BrainPain
* Purpose: Implements the A_BrainPain routine for the engine module behavior.
*/
function A_BrainPain(mo)
  mo = mo
  _PE_StartSound(void, sfxenum_t.sfx_bospn)
end function

/*
* Function: A_BrainScream
* Purpose: Implements the A_BrainScream routine for the engine module behavior.
*/
function A_BrainScream(mo)
  if mo is void then return end if

  x = mo.x - 196 * FRACUNIT
  while x < mo.x + 320 * FRACUNIT
    y = mo.y - 320 * FRACUNIT
    z = 128 + P_Random() * 2 * FRACUNIT
    th = P_SpawnMobj(x, y, z, mobjtype_t.MT_ROCKET)
    if th is not void then
      th.momz = P_Random() * 512
      P_SetMobjState(th, statenum_t.S_BRAINEXPLODE1)
      th.tics = th.tics -(P_Random() & 7)
      if th.tics < 1 then th.tics = 1 end if
    end if
    x = x + FRACUNIT * 8
  end while

  _PE_StartSound(void, sfxenum_t.sfx_bosdth)
end function

/*
* Function: A_BrainExplode
* Purpose: Implements the A_BrainExplode routine for the engine module behavior.
*/
function A_BrainExplode(mo)
  if mo is void then return end if
  x = mo.x +(P_Random() - P_Random()) * 2048
  y = mo.y
  z = 128 + P_Random() * 2 * FRACUNIT
  th = P_SpawnMobj(x, y, z, mobjtype_t.MT_ROCKET)
  if th is void then return end if
  th.momz = P_Random() * 512
  P_SetMobjState(th, statenum_t.S_BRAINEXPLODE1)
  th.tics = th.tics -(P_Random() & 7)
  if th.tics < 1 then th.tics = 1 end if
end function

/*
* Function: A_BrainDie
* Purpose: Implements the A_BrainDie routine for the engine module behavior.
*/
function A_BrainDie(mo)
  mo = mo
  if typeof(G_ExitLevel) == "function" then G_ExitLevel() end if
end function

/*
* Function: A_BrainSpit
* Purpose: Implements the A_BrainSpit routine for the engine module behavior.
*/
function A_BrainSpit(mo)
  global _PE_brain_easy
  global braintargeton

  if mo is void then return end if

  _PE_brain_easy = _PE_brain_easy ^ 1
  if gameskill <= sk_easy and _PE_brain_easy == 0 then
    return
  end if

  if typeof(braintargets) != "array" or len(braintargets) == 0 then
    return
  end if

  targ = braintargets[braintargeton]
  braintargeton =(braintargeton + 1) % len(braintargets)

  if targ is void then return end if
  newmobj = P_SpawnMissile(mo, targ, mobjtype_t.MT_SPAWNSHOT)
  if newmobj is void then return end if
  newmobj.target = targ

  den1 = newmobj.momy
  if den1 == 0 then den1 = 1 end if

  den2 = 1
  if typeof(newmobj.state) == "struct" and newmobj.state.tics is not void and newmobj.state.tics != 0 then
    den2 = newmobj.state.tics
  else if newmobj.tics is not void and newmobj.tics != 0 then
    den2 = newmobj.tics
  end if

  newmobj.reactiontime = _PE_IDiv(_PE_IDiv((targ.y - mo.y), den1), den2)
  _PE_StartSound(void, sfxenum_t.sfx_bospit)
end function

/*
* Function: A_SpawnFly
* Purpose: Creates and initializes runtime objects for the engine module behavior.
*/
function A_SpawnFly(mo)
  if mo is void then return end if

  mo.reactiontime = mo.reactiontime - 1
  if mo.reactiontime != 0 then return end if

  targ = mo.target
  if targ is void then
    P_RemoveMobj(mo)
    return
  end if

  fog = P_SpawnMobj(targ.x, targ.y, targ.z, mobjtype_t.MT_SPAWNFIRE)
  _PE_StartSound(fog, sfxenum_t.sfx_telept)

  r = P_Random()
  spawnType = mobjtype_t.MT_TROOP
  if r < 50 then
    spawnType = mobjtype_t.MT_TROOP
  else if r < 90 then
    spawnType = mobjtype_t.MT_SERGEANT
  else if r < 120 then
    spawnType = mobjtype_t.MT_SHADOWS
  else if r < 130 then
    spawnType = mobjtype_t.MT_PAIN
  else if r < 160 then
    spawnType = mobjtype_t.MT_HEAD
  else if r < 162 then
    spawnType = mobjtype_t.MT_VILE
  else if r < 172 then
    spawnType = mobjtype_t.MT_UNDEAD
  else if r < 192 then
    spawnType = mobjtype_t.MT_BABY
  else if r < 222 then
    spawnType = mobjtype_t.MT_FATSO
  else if r < 246 then
    spawnType = mobjtype_t.MT_KNIGHT
  else
    spawnType = mobjtype_t.MT_BRUISER
  end if

  newmobj = P_SpawnMobj(targ.x, targ.y, targ.z, spawnType)
  if newmobj is not void then
    if P_LookForPlayers(newmobj, true) then
      if newmobj.info is not void then
        P_SetMobjState(newmobj, newmobj.info.seestate)
      end if
    end if
    P_TeleportMove(newmobj, newmobj.x, newmobj.y)
  end if

  P_RemoveMobj(mo)
end function

/*
* Function: A_SpawnSound
* Purpose: Creates and initializes runtime objects for the engine module behavior.
*/
function A_SpawnSound(mo)
  _PE_StartSound(mo, sfxenum_t.sfx_boscub)
  A_SpawnFly(mo)
end function

/*
* Function: A_PlayerScream
* Purpose: Implements the A_PlayerScream routine for the engine module behavior.
*/
function A_PlayerScream(mo)
  if mo is void then return end if
  sound = sfxenum_t.sfx_pldeth
  if gamemode == commercial and mo.health < -50 then
    sound = sfxenum_t.sfx_pdiehi
  end if
  _PE_StartSound(mo, sound)
end function



