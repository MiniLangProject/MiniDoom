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

  Script: p_map.ml
  Purpose: Implements core gameplay simulation: map logic, physics, AI, and world interaction.
*/
import m_bbox
import m_fixed
import m_random
import i_system
import doomdef
import m_argv
import tables
import p_local
import p_maputl
import p_mobj
import p_inter
import p_spec
import p_switch
import p_sight
import s_sound
import doomstat
import r_state
import r_main
import r_sky
import info
import sounds

tmbbox =[0, 0, 0, 0]
tmthing = void
tmflags = 0
tmx = 0
tmy = 0

tmdropoffz = 0

const MAXSPECIALCROSS = 8
spechit =[void, void, void, void, void, void, void, void]
numspechit = 0

/*
* Function: _MapAbs
* Purpose: Implements the _MapAbs routine for the internal module support.
*/
function inline _MapAbs(x)
  if x < 0 then return - x end if
  return x
end function

/*
* Function: _PMAP_IDiv
* Purpose: Implements the _PMAP_IDiv routine for the internal module support.
*/
function inline _PMAP_IDiv(a, b)
  if typeof(a) != "int" or typeof(b) != "int" or b == 0 then return 0 end if
  q = a / b
  if q >= 0 then return std.math.floor(q) end if
  return std.math.ceil(q)
end function

/*
* Function: _PMAP_S32
* Purpose: Implements the _PMAP_S32 routine for the internal module support.
*/
function inline _PMAP_S32(v)
  if typeof(v) != "int" then return 0 end if
  v = v & 0xFFFFFFFF
  if v >= 0x80000000 then v = v - 0x100000000 end if
  return v
end function

/*
* Function: _SetTMBox
* Purpose: Reads or updates state used by the internal module support.
*/
function inline _SetTMBox(x, y, radius)
  tmbbox[BOXTOP] = y + radius
  tmbbox[BOXBOTTOM] = y - radius
  tmbbox[BOXRIGHT] = x + radius
  tmbbox[BOXLEFT] = x - radius
end function

/*
* Function: _LineIndex
* Purpose: Implements the _LineIndex routine for the internal module support.
*/
function _LineIndex(ld)
  if ld is void then return -1 end if
  if typeof(lines) != "array" then return -1 end if
  i = 0
  while i < len(lines)
    if lines[i] == ld then return i end if
    i = i + 1
  end while
  return -1
end function

bestslidefrac = 0
secondslidefrac = 0
bestslideline = void
secondslideline = void
slidemo = void
tmxmove = 0
tmymove = 0

usething = void

crushchange = false
nofit = false

_pmDiagMoveInit = false
_pmDiagMove = false
_pmDiagTryCount = 0
_pmDiagFailCount = 0
_pmDiagPlayerTry = 0
_pmDiagPlayerFail = 0
_pmDiagLineChecksCur = 0
_pmDiagLineChecksLast = 0
_pmDiagLineCandCur = 0
_pmDiagLineCandLast = 0
_pmDiagUseInit = false
_pmDiagUse = false
_pmDiagUseCount = 0

/*
* Function: _PM_TryMoveDiagEnabled
* Purpose: Computes movement/collision behavior in the internal module support.
*/
function inline _PM_TryMoveDiagEnabled()
  global _pmDiagMoveInit
  global _pmDiagMove
  if _pmDiagMoveInit then return _pmDiagMove end if
  _pmDiagMoveInit = true
  _pmDiagMove = false
  if typeof(M_CheckParm) == "function" then
    if M_CheckParm("-diagmove") or M_CheckParm("--diagmove") then
      _pmDiagMove = true
    end if
  end if
  if _pmDiagMove then
    print "P_Map: -diagmove enabled"
  end if
  return _pmDiagMove
end function

/*
* Function: _PM_DiagMovePrint
* Purpose: Computes movement/collision behavior in the internal module support.
*/
function inline _PM_DiagMovePrint(msg)
  if not _PM_TryMoveDiagEnabled() then return end if
  if typeof(msg) != "string" then return end if
  print msg
end function

/*
* Function: _PM_UseDiagEnabled
* Purpose: Implements the _PM_UseDiagEnabled routine for the internal module support.
*/
function inline _PM_UseDiagEnabled()
  global _pmDiagUseInit
  global _pmDiagUse
  if _pmDiagUseInit then return _pmDiagUse end if
  _pmDiagUseInit = true
  _pmDiagUse = false
  if typeof(M_CheckParm) == "function" then
    if M_CheckParm("-diaguse") or M_CheckParm("--diaguse") then
      _pmDiagUse = true
    end if
  end if
  if _pmDiagUse then
    print "P_Map: -diaguse enabled"
  end if
  return _pmDiagUse
end function

/*
* Function: _PM_UseDiagLog
* Purpose: Implements the _PM_UseDiagLog routine for the internal module support.
*/
function inline _PM_UseDiagLog(msg)
  global _pmDiagUseCount
  if not _PM_UseDiagEnabled() then return end if
  if typeof(msg) != "string" then return end if
  _pmDiagUseCount = _pmDiagUseCount + 1
  if _pmDiagUseCount <= 80 or(_pmDiagUseCount & 127) == 0 then
    print "P_UseLines: " + msg
  end if
end function

/*
* Function: PIT_StompThing
* Purpose: Implements the PIT_StompThing routine for the engine module behavior.
*/
function PIT_StompThing(thing)
  if thing is void then return true end if
  if (thing.flags & mobjflag_t.MF_SHOOTABLE) == 0 then return true end if

  blockdist = thing.radius + tmthing.radius
  if _MapAbs(thing.x - tmx) >= blockdist or _MapAbs(thing.y - tmy) >= blockdist then
    return true
  end if

  if thing == tmthing then return true end if

  if tmthing.player is void and gamemap != 30 then
    return false
  end if

  P_DamageMobj(thing, tmthing, tmthing, 10000)
  return true
end function

/*
* Function: PIT_CheckLine
* Purpose: Evaluates conditions and returns a decision for the engine module behavior.
*/
function PIT_CheckLine(ld)
  global tmfloorz
  global tmceilingz
  global tmdropoffz
  global ceilingline
  global numspechit
  global _pmDiagLineChecksCur

  if ld is void then return true end if
  _pmDiagLineChecksCur = _pmDiagLineChecksCur + 1

  if tmbbox[BOXRIGHT] <= ld.bbox[BOXLEFT] or tmbbox[BOXLEFT] >= ld.bbox[BOXRIGHT] or tmbbox[BOXTOP] <= ld.bbox[BOXBOTTOM] or tmbbox[BOXBOTTOM] >= ld.bbox[BOXTOP] then
    return true
  end if

  if P_BoxOnLineSide(tmbbox, ld) != -1 then
    return true
  end if

  if ld.backsector is void then
    _PM_DiagMovePrint("PIT_CheckLine: one-sided block")
    return false
  end if

  if (tmthing.flags & mobjflag_t.MF_MISSILE) == 0 then
    if (ld.flags & ML_BLOCKING) != 0 then
      _PM_DiagMovePrint("PIT_CheckLine: ML_BLOCKING")
      return false
    end if

    if tmthing.player is void and(ld.flags & ML_BLOCKMONSTERS) != 0 then
      _PM_DiagMovePrint("PIT_CheckLine: ML_BLOCKMONSTERS")
      return false
    end if
  end if

  P_LineOpening(ld)

  if opentop < tmceilingz then
    tmceilingz = opentop
    ceilingline = ld
  end if

  if openbottom > tmfloorz then
    tmfloorz = openbottom
  end if

  if lowfloor < tmdropoffz then
    tmdropoffz = lowfloor
  end if

  if ld.special != 0 and numspechit < MAXSPECIALCROSS then
    spechit[numspechit] = ld
    numspechit = numspechit + 1
  end if

  return true
end function

/*
* Function: PIT_CheckThing
* Purpose: Evaluates conditions and returns a decision for the engine module behavior.
*/
function PIT_CheckThing(thing)
  if thing is void then return true end if

  if (thing.flags &(mobjflag_t.MF_SOLID | mobjflag_t.MF_SPECIAL | mobjflag_t.MF_SHOOTABLE)) == 0 then
    return true
  end if

  blockdist = thing.radius + tmthing.radius
  if _MapAbs(thing.x - tmx) >= blockdist or _MapAbs(thing.y - tmy) >= blockdist then
    return true
  end if

  if thing == tmthing then return true end if

  if (tmthing.flags & mobjflag_t.MF_SKULLFLY) != 0 then
    damage = 0
    if tmthing.info is not void and typeof(tmthing.info.damage) == "int" then
      damage =((P_Random() % 8) + 1) * tmthing.info.damage
    end if
    P_DamageMobj(thing, tmthing, tmthing, damage)

    tmthing.flags = tmthing.flags & ~mobjflag_t.MF_SKULLFLY
    tmthing.momx = 0
    tmthing.momy = 0
    tmthing.momz = 0
    if tmthing.info is not void and typeof(P_SetMobjState) == "function" then
      P_SetMobjState(tmthing, tmthing.info.spawnstate)
    end if

    return false
  end if

  if (tmthing.flags & mobjflag_t.MF_MISSILE) != 0 then
    if tmthing.z > thing.z + thing.height then return true end if
    if tmthing.z + tmthing.height < thing.z then return true end if

    if tmthing.target is not void and(tmthing.target.type == thing.type or
      (tmthing.target.type == mobjtype_t.MT_KNIGHT and thing.type == mobjtype_t.MT_BRUISER) or
      (tmthing.target.type == mobjtype_t.MT_BRUISER and thing.type == mobjtype_t.MT_KNIGHT)) then
      if thing == tmthing.target then return true end if
      if thing.type != mobjtype_t.MT_PLAYER then
        return false
      end if
    end if

    if (thing.flags & mobjflag_t.MF_SHOOTABLE) == 0 then
      return (thing.flags & mobjflag_t.MF_SOLID) == 0
    end if

    damage = 0
    if tmthing.info is not void and typeof(tmthing.info.damage) == "int" then
      damage =((P_Random() % 8) + 1) * tmthing.info.damage
    end if
    P_DamageMobj(thing, tmthing, tmthing.target, damage)
    return false
  end if

  if (thing.flags & mobjflag_t.MF_SPECIAL) != 0 then
    solid =(thing.flags & mobjflag_t.MF_SOLID) != 0
    if (tmflags & mobjflag_t.MF_PICKUP) != 0 and typeof(P_TouchSpecialThing) == "function" then
      P_TouchSpecialThing(thing, tmthing)
    end if
    return (not solid)
  end if

  return (thing.flags & mobjflag_t.MF_SOLID) == 0
end function

/*
* Function: P_CheckPosition
* Purpose: Evaluates conditions and returns a decision for the gameplay and world simulation.
*/
function P_CheckPosition(thing, x, y)
  global tmthing
  global tmflags
  global tmx
  global tmy
  global tmfloorz
  global tmceilingz
  global tmdropoffz
  global ceilingline
  global numspechit
  global validcount
  global _pmDiagLineChecksCur
  global _pmDiagLineChecksLast
  global _pmDiagLineCandCur
  global _pmDiagLineCandLast

  tmthing = thing
  tmflags = 0
  if thing is not void then tmflags = thing.flags end if
  tmx = x
  tmy = y

  radius = 0
  if thing is not void and typeof(thing.radius) == "int" then radius = thing.radius end if
  _SetTMBox(x, y, radius)

  ss = R_PointInSubsector(x, y)
  ceilingline = void

  if ss is not void and ss.sector is not void then
    tmfloorz = ss.sector.floorheight
    tmdropoffz = ss.sector.floorheight
    tmceilingz = ss.sector.ceilingheight
  else
    tmfloorz = 0
    tmdropoffz = 0
    tmceilingz = 0
  end if

  if typeof(validcount) != "int" then validcount = 1 end if
  validcount = validcount + 1
  numspechit = 0
  _pmDiagLineChecksCur = 0
  _pmDiagLineCandCur = 0

  if (tmflags & mobjflag_t.MF_NOCLIP) != 0 then
    _pmDiagLineChecksLast = _pmDiagLineChecksCur
    _pmDiagLineCandLast = _pmDiagLineCandCur
    return true
  end if

  xl =(tmbbox[BOXLEFT] - bmaporgx - MAXRADIUS) >> MAPBLOCKSHIFT
  xh =(tmbbox[BOXRIGHT] - bmaporgx + MAXRADIUS) >> MAPBLOCKSHIFT
  yl =(tmbbox[BOXBOTTOM] - bmaporgy - MAXRADIUS) >> MAPBLOCKSHIFT
  yh =(tmbbox[BOXTOP] - bmaporgy + MAXRADIUS) >> MAPBLOCKSHIFT

  for bx = xl to xh
    for by = yl to yh
      if not P_BlockThingsIterator(bx, by, PIT_CheckThing) then
        return false
      end if
    end for
  end for

  xl =(tmbbox[BOXLEFT] - bmaporgx) >> MAPBLOCKSHIFT
  xh =(tmbbox[BOXRIGHT] - bmaporgx) >> MAPBLOCKSHIFT
  yl =(tmbbox[BOXBOTTOM] - bmaporgy) >> MAPBLOCKSHIFT
  yh =(tmbbox[BOXTOP] - bmaporgy) >> MAPBLOCKSHIFT

  for bx = xl to xh
    for by = yl to yh
      if not P_BlockLinesIterator(bx, by, PIT_CheckLine) then
        _pmDiagLineChecksLast = _pmDiagLineChecksCur
        _pmDiagLineCandLast = _pmDiagLineCandCur
        return false
      end if
    end for
  end for

  _pmDiagLineChecksLast = _pmDiagLineChecksCur
  _pmDiagLineCandLast = _pmDiagLineCandCur
  return true
end function

/*
* Function: P_TryMove
* Purpose: Computes movement/collision behavior in the gameplay and world simulation.
*/
function P_TryMove(thing, x, y)
  global floatok
  global numspechit
  global _pmDiagTryCount
  global _pmDiagFailCount
  global _pmDiagPlayerTry
  global _pmDiagPlayerFail
  global _pmDiagLineChecksLast
  global _pmDiagLineCandLast

  if thing is void then return false end if

  _pmDiagTryCount = _pmDiagTryCount + 1
  isPlayerThing =(thing.player is not void)
  if isPlayerThing then
    _pmDiagPlayerTry = _pmDiagPlayerTry + 1
  end if
  if _PM_TryMoveDiagEnabled() and(_pmDiagTryCount & 511) == 0 then
    _PM_DiagMovePrint("P_TryMove: progress tries=" + _pmDiagTryCount + " fails=" + _pmDiagFailCount)
  end if
  if _PM_TryMoveDiagEnabled() and isPlayerThing and(_pmDiagPlayerTry & 63) == 0 then
    bx =(x - bmaporgx) >> MAPBLOCKSHIFT
    by =(y - bmaporgy) >> MAPBLOCKSHIFT
    _PM_DiagMovePrint("P_TryMove[player]: tries=" + _pmDiagPlayerTry + " fails=" + _pmDiagPlayerFail + " x=" + x + " y=" + y + " r=" + thing.radius + " h=" + thing.height + " z=" + thing.z + " flags=" + thing.flags + " bx=" + bx + " by=" + by + " bmw=" + bmapwidth + " bmh=" + bmapheight + " bmx0=" + bmaporgx + " bmy0=" + bmaporgy + " lcand=" + _pmDiagLineCandLast + " lchk=" + _pmDiagLineChecksLast)
  end if
  if _PM_TryMoveDiagEnabled() and(thing.flags & mobjflag_t.MF_NOCLIP) != 0 and _pmDiagTryCount <= 8 then
    _PM_DiagMovePrint("P_TryMove: MF_NOCLIP active flags=" + thing.flags)
  end if
  floatok = false
  if not P_CheckPosition(thing, x, y) then
    _pmDiagFailCount = _pmDiagFailCount + 1
    if isPlayerThing then _pmDiagPlayerFail = _pmDiagPlayerFail + 1 end if
    if _PM_TryMoveDiagEnabled() then
      if _pmDiagFailCount <= 16 or(_pmDiagFailCount & 31) == 0 then
        _PM_DiagMovePrint("P_TryMove: blocked x=" + x + " y=" + y + " flags=" + thing.flags + " fail=" + _pmDiagFailCount + "/" + _pmDiagTryCount)
      end if
    end if
    return false
  end if

  if (thing.flags & mobjflag_t.MF_NOCLIP) == 0 then
    if tmceilingz - tmfloorz < thing.height then
      _pmDiagFailCount = _pmDiagFailCount + 1
      if isPlayerThing then _pmDiagPlayerFail = _pmDiagPlayerFail + 1 end if
      _PM_DiagMovePrint("P_TryMove: blocked (height) fail=" + _pmDiagFailCount + "/" + _pmDiagTryCount)
      return false
    end if

    floatok = true

    if (thing.flags & mobjflag_t.MF_TELEPORT) == 0 and tmceilingz - thing.z < thing.height then
      _pmDiagFailCount = _pmDiagFailCount + 1
      if isPlayerThing then _pmDiagPlayerFail = _pmDiagPlayerFail + 1 end if
      _PM_DiagMovePrint("P_TryMove: blocked (ceiling) fail=" + _pmDiagFailCount + "/" + _pmDiagTryCount)
      return false
    end if

    if (thing.flags & mobjflag_t.MF_TELEPORT) == 0 and tmfloorz - thing.z > 24 * FRACUNIT then
      _pmDiagFailCount = _pmDiagFailCount + 1
      if isPlayerThing then _pmDiagPlayerFail = _pmDiagPlayerFail + 1 end if
      _PM_DiagMovePrint("P_TryMove: blocked (stepup) fail=" + _pmDiagFailCount + "/" + _pmDiagTryCount)
      return false
    end if

    if (thing.flags &(mobjflag_t.MF_DROPOFF | mobjflag_t.MF_FLOAT)) == 0 and tmfloorz - tmdropoffz > 24 * FRACUNIT then
      _pmDiagFailCount = _pmDiagFailCount + 1
      if isPlayerThing then _pmDiagPlayerFail = _pmDiagPlayerFail + 1 end if
      _PM_DiagMovePrint("P_TryMove: blocked (dropoff) fail=" + _pmDiagFailCount + "/" + _pmDiagTryCount)
      return false
    end if
  end if

  P_UnsetThingPosition(thing)

  oldx = thing.x
  oldy = thing.y
  thing.floorz = tmfloorz
  thing.ceilingz = tmceilingz
  thing.x = x
  thing.y = y

  P_SetThingPosition(thing)

  if (thing.flags &(mobjflag_t.MF_TELEPORT | mobjflag_t.MF_NOCLIP)) == 0 then
    while numspechit > 0
      numspechit = numspechit - 1
      ld = spechit[numspechit]
      if ld is void then continue end if

      side = P_PointOnLineSide(thing.x, thing.y, ld)
      oldside = P_PointOnLineSide(oldx, oldy, ld)
      if side != oldside and ld.special != 0 then
        lnum = _LineIndex(ld)
        if lnum >= 0 and typeof(P_CrossSpecialLine) == "function" then
          P_CrossSpecialLine(lnum, oldside, thing)
        end if
      end if
    end while
  end if

  return true
end function

/*
* Function: P_TeleportMove
* Purpose: Computes movement/collision behavior in the gameplay and world simulation.
*/
function P_TeleportMove(thing, x, y)
  global tmthing
  global tmflags
  global tmx
  global tmy
  global tmfloorz
  global tmceilingz
  global tmdropoffz
  global ceilingline
  global numspechit

  if thing is void then return false end if

  tmthing = thing
  tmflags = thing.flags
  tmx = x
  tmy = y
  _SetTMBox(x, y, thing.radius)

  ss = R_PointInSubsector(x, y)
  if ss is void or ss.sector is void then return false end if
  ceilingline = void
  tmfloorz = ss.sector.floorheight
  tmdropoffz = ss.sector.floorheight
  tmceilingz = ss.sector.ceilingheight
  numspechit = 0

  xl =(tmbbox[BOXLEFT] - bmaporgx - MAXRADIUS) >> MAPBLOCKSHIFT
  xh =(tmbbox[BOXRIGHT] - bmaporgx + MAXRADIUS) >> MAPBLOCKSHIFT
  yl =(tmbbox[BOXBOTTOM] - bmaporgy - MAXRADIUS) >> MAPBLOCKSHIFT
  yh =(tmbbox[BOXTOP] - bmaporgy + MAXRADIUS) >> MAPBLOCKSHIFT

  for bx = xl to xh
    for by = yl to yh
      if not P_BlockThingsIterator(bx, by, PIT_StompThing) then
        return false
      end if
    end for
  end for

  P_UnsetThingPosition(thing)
  thing.floorz = tmfloorz
  thing.ceilingz = tmceilingz
  thing.x = x
  thing.y = y
  P_SetThingPosition(thing)

  return true
end function

/*
* Function: P_ThingHeightClip
* Purpose: Implements the P_ThingHeightClip routine for the gameplay and world simulation.
*/
function P_ThingHeightClip(thing)
  if thing is void then return false end if

  onfloor =(thing.z == thing.floorz)

  P_CheckPosition(thing, thing.x, thing.y)
  thing.floorz = tmfloorz
  thing.ceilingz = tmceilingz

  if onfloor then
    thing.z = thing.floorz
  else
    if thing.z + thing.height > thing.ceilingz then
      thing.z = thing.ceilingz - thing.height
    end if
  end if

  if thing.ceilingz - thing.floorz < thing.height then return false end if
  return true
end function

/*
* Function: P_HitSlideLine
* Purpose: Computes movement/collision behavior in the gameplay and world simulation.
*/
function P_HitSlideLine(ld)
  global tmxmove
  global tmymove

  if ld is void then return end if

  if ld.slopetype == slopetype_t.ST_HORIZONTAL then
    tmymove = 0
    return
  end if

  if ld.slopetype == slopetype_t.ST_VERTICAL then
    tmxmove = 0
    return
  end if

  side = 0
  if slidemo is not void then
    side = P_PointOnLineSide(slidemo.x, slidemo.y, ld)
  end if

  lineangle = 0
  if typeof(R_PointToAngle2) == "function" then
    lineangle = R_PointToAngle2(0, 0, ld.dx, ld.dy)
  end if
  if side == 1 then
    lineangle = lineangle + ANG180
  end if

  moveangle = 0
  if typeof(R_PointToAngle2) == "function" then
    moveangle = R_PointToAngle2(0, 0, tmxmove, tmymove)
  end if
  deltaangle = moveangle - lineangle
  if deltaangle > ANG180 then
    deltaangle = deltaangle + ANG180
  end if

  lineangle =(lineangle >> ANGLETOFINESHIFT) & FINEMASK
  deltaangle =(deltaangle >> ANGLETOFINESHIFT) & FINEMASK

  movelen = P_AproxDistance(tmxmove, tmymove)
  newlen = FixedMul(movelen, finecosine[deltaangle])

  tmxmove = FixedMul(newlen, finecosine[lineangle])
  tmymove = FixedMul(newlen, finesine[lineangle])
end function

/*
* Function: PTR_SlideTraverse
* Purpose: Computes movement/collision behavior in the engine module behavior.
*/
function PTR_SlideTraverse(inter)
  global bestslidefrac
  global secondslidefrac
  global bestslideline
  global secondslideline

  if inter is void then return true end if
  if not inter.isaline then
    I_Error("PTR_SlideTraverse: not a line?")
    return true
  end if

  li = inter.line
  if li is void then return true end if

  blocking = false
  if (li.flags & ML_TWOSIDED) == 0 then
    if slidemo is not void and P_PointOnLineSide(slidemo.x, slidemo.y, li) == 1 then
      return true
    end if
    blocking = true
  else
    P_LineOpening(li)
    if slidemo is void then return true end if
    if openrange < slidemo.height then blocking = true end if
    if opentop - slidemo.z < slidemo.height then blocking = true end if
    if openbottom - slidemo.z > 24 * FRACUNIT then blocking = true end if
  end if

  if not blocking then
    return true
  end if

  if inter.frac < bestslidefrac then
    secondslidefrac = bestslidefrac
    secondslideline = bestslideline
    bestslidefrac = inter.frac
    bestslideline = li
  end if

  return false
end function

/*
* Function: PTR_UseTraverse
* Purpose: Reads or updates state used by the engine module behavior.
*/
function PTR_UseTraverse(inter)
  global usething

  if inter is void then return true end if
  if not inter.isaline then return true end if
  li = inter.line
  if li is void then return true end if

  if li.special == 0 then
    P_LineOpening(li)
    if openrange <= 0 then
      _PM_UseDiagLog("blocked noway")
      if usething is not void and typeof(S_StartSound) == "function" then
        S_StartSound(usething, sfxenum_t.sfx_noway)
      end if
      return false
    end if
    return true
  end if

  side = 0
  if usething is not void and P_PointOnLineSide(usething.x, usething.y, li) == 1 then
    side = 1
  end if

  if typeof(P_UseSpecialLine) == "function" then
    _PM_UseDiagLog("special=" + li.special + " side=" + side)
    used = P_UseSpecialLine(usething, li, side)

    if used == false and side == 1 and usething is not void and usething.player is not void then
      _PM_UseDiagLog("retry special=" + li.special + " side=0")
      P_UseSpecialLine(usething, li, 0)
    end if
  end if
  return false
end function

/*
* Function: P_SlideMove
* Purpose: Computes movement/collision behavior in the gameplay and world simulation.
*/
function P_SlideMove(mo)
  global slidemo
  global bestslidefrac
  global secondslidefrac
  global bestslideline
  global secondslideline
  global tmxmove
  global tmymove

  if mo is void then return end if

  slidemo = mo
  hitcount = 0

  loop
    hitcount = hitcount + 1
    if hitcount == 3 then
      if not P_TryMove(mo, mo.x, mo.y + mo.momy) then
        P_TryMove(mo, mo.x + mo.momx, mo.y)
      end if
      return
    end if

    leadx = 0
    trailx = 0
    leady = 0
    traily = 0
    if mo.momx > 0 then
      leadx = mo.x + mo.radius
      trailx = mo.x - mo.radius
    else
      leadx = mo.x - mo.radius
      trailx = mo.x + mo.radius
    end if

    if mo.momy > 0 then
      leady = mo.y + mo.radius
      traily = mo.y - mo.radius
    else
      leady = mo.y - mo.radius
      traily = mo.y + mo.radius
    end if

    bestslidefrac = FRACUNIT + 1
    secondslidefrac = FRACUNIT + 1
    bestslideline = void
    secondslideline = void

    P_PathTraverse(leadx, leady, leadx + mo.momx, leady + mo.momy, PT_ADDLINES, PTR_SlideTraverse)
    P_PathTraverse(trailx, leady, trailx + mo.momx, leady + mo.momy, PT_ADDLINES, PTR_SlideTraverse)
    P_PathTraverse(leadx, traily, leadx + mo.momx, traily + mo.momy, PT_ADDLINES, PTR_SlideTraverse)

    if bestslidefrac == FRACUNIT + 1 then
      if not P_TryMove(mo, mo.x, mo.y + mo.momy) then
        P_TryMove(mo, mo.x + mo.momx, mo.y)
      end if
      return
    end if

    bestslidefrac = bestslidefrac - 0x800
    if bestslidefrac > 0 then
      newx = FixedMul(mo.momx, bestslidefrac)
      newy = FixedMul(mo.momy, bestslidefrac)
      if not P_TryMove(mo, mo.x + newx, mo.y + newy) then
        if not P_TryMove(mo, mo.x, mo.y + mo.momy) then
          P_TryMove(mo, mo.x + mo.momx, mo.y)
        end if
        return
      end if
    end if

    bestslidefrac = FRACUNIT -(bestslidefrac + 0x800)
    if bestslidefrac > FRACUNIT then bestslidefrac = FRACUNIT end if
    if bestslidefrac <= 0 then return end if

    tmxmove = FixedMul(mo.momx, bestslidefrac)
    tmymove = FixedMul(mo.momy, bestslidefrac)
    if bestslideline is void then return end if
    P_HitSlideLine(bestslideline)

    mo.momx = tmxmove
    mo.momy = tmymove

    if P_TryMove(mo, mo.x + tmxmove, mo.y + tmymove) then
      return
    end if
    while true
    end loop
  end function

  /*
  * Function: P_UseLines
  * Purpose: Implements the P_UseLines routine for the gameplay and world simulation.
  */
  function P_UseLines(player)
    global usething

    if player is void or player.mo is void then return end if

    usething = player.mo
    angle =(player.mo.angle >> ANGLETOFINESHIFT) & FINEMASK
    x1 = player.mo.x
    y1 = player.mo.y
    x2 = x1 +(USERANGE >> FRACBITS) * finecosine[angle]
    y2 = y1 +(USERANGE >> FRACBITS) * finesine[angle]
    _PM_UseDiagLog("trace x1=" + x1 + " y1=" + y1 + " x2=" + x2 + " y2=" + y2)

    P_PathTraverse(x1, y1, x2, y2, PT_ADDLINES, PTR_UseTraverse)
  end function

  /*
  * Function: PIT_ChangeSector
  * Purpose: Implements the PIT_ChangeSector routine for the engine module behavior.
  */
  function PIT_ChangeSector(thing)
    global nofit

    if thing is void then return true end if

    if P_ThingHeightClip(thing) then
      return true
    end if

    if thing.health <= 0 then
      if typeof(P_SetMobjState) == "function" then
        P_SetMobjState(thing, statenum_t.S_GIBS)
      end if
      thing.flags = thing.flags & ~mobjflag_t.MF_SOLID
      thing.height = 0
      thing.radius = 0
      return true
    end if

    if (thing.flags & mobjflag_t.MF_DROPPED) != 0 then
      if typeof(P_RemoveMobj) == "function" then
        P_RemoveMobj(thing)
      end if
      return true
    end if

    if (thing.flags & mobjflag_t.MF_SHOOTABLE) == 0 then
      return true
    end if

    nofit = true

    if crushchange and((leveltime & 3) == 0) then
      P_DamageMobj(thing, void, void, 10)
      mo = P_SpawnMobj(thing.x, thing.y, thing.z +(thing.height >> 1), mobjtype_t.MT_BLOOD)
      if mo is not void then
        mo.momx =(P_Random() - P_Random()) << 12
        mo.momy =(P_Random() - P_Random()) << 12
      end if
    end if

    return true
  end function

  /*
  * Function: P_ChangeSector
  * Purpose: Implements the P_ChangeSector routine for the gameplay and world simulation.
  */
  function P_ChangeSector(sector, crunch)
    global nofit
    global crushchange

    if sector is void then return false end if
    if typeof(sector.blockbox) != "array" or len(sector.blockbox) < 4 then return false end if

    nofit = false
    crushchange = crunch

    for x = sector.blockbox[BOXLEFT] to sector.blockbox[BOXRIGHT]
      for y = sector.blockbox[BOXBOTTOM] to sector.blockbox[BOXTOP]
        P_BlockThingsIterator(x, y, PIT_ChangeSector)
      end for
    end for

    return nofit
  end function

  bombsource = void
  bombspot = void
  bombdamage = 0

  /*
  * Function: PIT_RadiusAttack
  * Purpose: Implements the PIT_RadiusAttack routine for the engine module behavior.
  */
  function PIT_RadiusAttack(thing)
    if thing is void then return true end if
    if (thing.flags & mobjflag_t.MF_SHOOTABLE) == 0 then return true end if

    if thing.type == mobjtype_t.MT_CYBORG or thing.type == mobjtype_t.MT_SPIDER then
      return true
    end if

    dx = _MapAbs(thing.x - bombspot.x)
    dy = _MapAbs(thing.y - bombspot.y)
    dist = dx
    if dy > dist then dist = dy end if
    dist =(dist - thing.radius) >> FRACBITS
    if dist < 0 then dist = 0 end if

    if dist >= bombdamage then return true end if

    if P_CheckSight(thing, bombspot) then
      P_DamageMobj(thing, bombspot, bombsource, bombdamage - dist)
    end if
    return true
  end function

  /*
  * Function: P_RadiusAttack
  * Purpose: Implements the P_RadiusAttack routine for the gameplay and world simulation.
  */
  function P_RadiusAttack(spot, source, damage)
    if spot is void then return end if

    dist = _PMAP_S32((damage + MAXRADIUS) << FRACBITS)
    yh =(spot.y + dist - bmaporgy) >> MAPBLOCKSHIFT
    yl =(spot.y - dist - bmaporgy) >> MAPBLOCKSHIFT
    xh =(spot.x + dist - bmaporgx) >> MAPBLOCKSHIFT
    xl =(spot.x - dist - bmaporgx) >> MAPBLOCKSHIFT

    global bombspot
    bombspot = spot
    global bombsource
    bombsource = source
    global bombdamage
    bombdamage = damage

    for y = yl to yh
      for x = xl to xh
        P_BlockThingsIterator(x, y, PIT_RadiusAttack)
      end for
    end for
  end function

  shootthing = void
  shootz = 0
  la_damage = 0
  attackrange = 0
  aimslope = 0
  topslope = 0
  bottomslope = 0

  /*
  * Function: PTR_AimTraverse
  * Purpose: Implements the PTR_AimTraverse routine for the engine module behavior.
  */
  function PTR_AimTraverse(inter)
    global linetarget
    global aimslope
    global topslope
    global bottomslope

    if inter is void then return true end if

    if inter.isaline then
      li = inter.line
      if li is void then return true end if

      if (li.flags & ML_TWOSIDED) == 0 then
        return false
      end if

      P_LineOpening(li)
      if openbottom >= opentop then
        return false
      end if

      dist = FixedMul(attackrange, inter.frac)
      if dist == 0 then return true end if

      if li.frontsector is not void and li.backsector is not void and li.frontsector.floorheight != li.backsector.floorheight then
        slope = FixedDiv(openbottom - shootz, dist)
        if slope > bottomslope then
          bottomslope = slope
        end if
      end if

      if li.frontsector is not void and li.backsector is not void and li.frontsector.ceilingheight != li.backsector.ceilingheight then
        slope = FixedDiv(opentop - shootz, dist)
        if slope < topslope then
          topslope = slope
        end if
      end if

      if topslope <= bottomslope then
        return false
      end if

      return true
    end if

    th = inter.thing
    if th is void then return true end if
    if th == shootthing then return true end if
    if (th.flags & mobjflag_t.MF_SHOOTABLE) == 0 then return true end if

    dist = FixedMul(attackrange, inter.frac)
    if dist == 0 then return true end if

    thingtopslope = FixedDiv(th.z + th.height - shootz, dist)
    if thingtopslope < bottomslope then return true end if

    thingbottomslope = FixedDiv(th.z - shootz, dist)
    if thingbottomslope > topslope then return true end if

    if thingtopslope > topslope then thingtopslope = topslope end if
    if thingbottomslope < bottomslope then thingbottomslope = bottomslope end if

    aimslope = _PMAP_IDiv(thingtopslope + thingbottomslope, 2)
    linetarget = th
    return false
  end function

  /*
  * Function: PTR_ShootTraverse
  * Purpose: Implements the PTR_ShootTraverse routine for the engine module behavior.
  */
  function PTR_ShootTraverse(inter)
    global linetarget

    if inter is void then return true end if

    if inter.isaline then
      li = inter.line
      if li is void then return true end if

      if li.special then
        if typeof(P_ShootSpecialLine) == "function" then
          P_ShootSpecialLine(shootthing, li)
        end if
      end if

      hitline = false
      if (li.flags & ML_TWOSIDED) == 0 then
        hitline = true
      else
        P_LineOpening(li)
        dist = FixedMul(attackrange, inter.frac)
        if dist <= 0 then
          hitline = true
        else
          if li.frontsector is not void and li.backsector is not void and li.frontsector.floorheight != li.backsector.floorheight then
            slope = FixedDiv(openbottom - shootz, dist)
            if slope > aimslope then hitline = true end if
          end if
          if (not hitline) and li.frontsector is not void and li.backsector is not void and li.frontsector.ceilingheight != li.backsector.ceilingheight then
            slope = FixedDiv(opentop - shootz, dist)
            if slope < aimslope then hitline = true end if
          end if
        end if
      end if

      if not hitline then
        return true
      end if

      frac = inter.frac
      if attackrange > 0 then
        frac = frac - FixedDiv(4 * FRACUNIT, attackrange)
      end if

      x = trace.x + FixedMul(trace.dx, frac)
      y = trace.y + FixedMul(trace.dy, frac)
      z = shootz + FixedMul(aimslope, FixedMul(frac, attackrange))

      if li.frontsector is not void and li.frontsector.ceilingpic == skyflatnum then
        if z > li.frontsector.ceilingheight then
          return false
        end if

        if li.backsector is not void and li.backsector.ceilingpic == skyflatnum then
          return false
        end if
      end if

      P_SpawnPuff(x, y, z)
      return false
    end if

    th = inter.thing
    if th is void then return true end if
    if th == shootthing then return true end if
    if (th.flags & mobjflag_t.MF_SHOOTABLE) == 0 then return true end if

    dist = FixedMul(attackrange, inter.frac)
    if dist <= 0 then return true end if

    thingtopslope = FixedDiv(th.z + th.height - shootz, dist)
    if thingtopslope < aimslope then return true end if

    thingbottomslope = FixedDiv(th.z - shootz, dist)
    if thingbottomslope > aimslope then return true end if

    frac = inter.frac
    if attackrange > 0 then
      frac = frac - FixedDiv(10 * FRACUNIT, attackrange)
    end if

    x = trace.x + FixedMul(trace.dx, frac)
    y = trace.y + FixedMul(trace.dy, frac)
    z = shootz + FixedMul(aimslope, FixedMul(frac, attackrange))

    if (th.flags & mobjflag_t.MF_NOBLOOD) != 0 then
      P_SpawnPuff(x, y, z)
    else
      P_SpawnBlood(x, y, z, la_damage)
    end if

    if la_damage != 0 and typeof(P_DamageMobj) == "function" then
      P_DamageMobj(th, shootthing, shootthing, la_damage)
    end if

    linetarget = th
    return false
  end function

  /*
  * Function: P_AimLineAttack
  * Purpose: Implements the P_AimLineAttack routine for the gameplay and world simulation.
  */
  function P_AimLineAttack(t1, angle, distance)
    global shootthing
    global shootz
    global attackrange
    global topslope
    global bottomslope
    global linetarget

    if t1 is void then return 0 end if
    if typeof(finecosine) != "array" or typeof(finesine) != "array" then return 0 end if

    an =(angle >> ANGLETOFINESHIFT) & FINEMASK
    shootthing = t1

    x2 = t1.x +((distance >> FRACBITS) * finecosine[an])
    y2 = t1.y +((distance >> FRACBITS) * finesine[an])
    shootz = t1.z +(t1.height >> 1) + 8 * FRACUNIT

    topslope = _PMAP_IDiv(100 * FRACUNIT, 160)
    bottomslope = -_PMAP_IDiv(100 * FRACUNIT, 160)

    attackrange = distance
    linetarget = void

    P_PathTraverse(t1.x, t1.y, x2, y2, PT_ADDLINES | PT_ADDTHINGS, PTR_AimTraverse)

    if linetarget is not void then
      return aimslope
    end if
    return 0
  end function

  /*
  * Function: P_LineAttack
  * Purpose: Implements the P_LineAttack routine for the gameplay and world simulation.
  */
  function P_LineAttack(t1, angle, distance, slope, damage)
    global shootthing
    global la_damage
    global shootz
    global attackrange
    global aimslope

    if t1 is void then return end if
    if typeof(finecosine) != "array" or typeof(finesine) != "array" then return end if

    an =(angle >> ANGLETOFINESHIFT) & FINEMASK
    shootthing = t1
    la_damage = damage

    x2 = t1.x +((distance >> FRACBITS) * finecosine[an])
    y2 = t1.y +((distance >> FRACBITS) * finesine[an])
    shootz = t1.z +(t1.height >> 1) + 8 * FRACUNIT
    attackrange = distance
    aimslope = slope

    P_PathTraverse(t1.x, t1.y, x2, y2, PT_ADDLINES | PT_ADDTHINGS, PTR_ShootTraverse)
  end function



