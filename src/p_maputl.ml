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

//! Supplies fixed-point geometry tests, blockmap linking, opening calculations, and ordered path traversal.

import m_bbox
import doomdef
import p_local
import r_state
import r_main
import m_argv

/// Returns an integer magnitude for distance and side-of-line calculations.
/// @param x Horizontal map- or screen-space coordinate.
/// @internal
function inline _abs(x)
  if x < 0 then return - x end if
  return x
end function

/// Normalizes an integer to unsigned 32-bit form for sign-bit tests that emulate Doom C arithmetic.
/// @param v Value consumed by the operation.
/// @internal
function inline _PMU_U32(v)
  if typeof(v) != "int" then return 0 end if
  return v & 0xFFFFFFFF
end function

/// Tests bit 31 of a value after unsigned 32-bit normalization.
/// @param v Value consumed by the operation.
/// @internal
function inline _PMU_HasSignBit(v)
  return (_PMU_U32(v) & 0x80000000) != 0
end function

/// Accepts arrays and byte buffers as the indexable sequence forms used by compatibility helpers.
/// @param v Value consumed by the operation.
/// @internal
function inline _PMU_IsSeq(v)
  t = typeof(v)
  return t == "array" or t == "list"
end function

/// Tracks whether pmu diag use init is active in the p maputl subsystem.
/// @internal
_pmuDiagUseInit = false
/// Tracks whether pmu diag use is active in the p maputl subsystem.
/// @internal
_pmuDiagUse = false
/// Tracks the mutable pmu diag use count value used by the p maputl subsystem.
/// @internal
_pmuDiagUseCount = 0

/// Caches whether path/use diagnostic output was requested on the command line.
/// @internal
function inline _PMU_DiagUseEnabled()
  global _pmuDiagUseInit
  global _pmuDiagUse
  if _pmuDiagUseInit then return _pmuDiagUse end if
  _pmuDiagUseInit = true
  _pmuDiagUse = false
  if typeof(M_CheckParm) == "function" then
    if M_CheckParm("-diaguse") or M_CheckParm("--diaguse") then
      _pmuDiagUse = true
    end if
  end if
  if _pmuDiagUse then
    print "P_MapUtl: -diaguse enabled"
  end if
  return _pmuDiagUse
end function

/// Emits a map-use diagnostic only when the cached diagnostic option is active.
/// @param msg Msg value supplied to `_PMU_DiagUseLog`.
/// @internal
function inline _PMU_DiagUseLog(msg)
  global _pmuDiagUseCount
  if not _PMU_DiagUseEnabled() then return end if
  _pmuDiagUseCount = _pmuDiagUseCount + 1
  if _pmuDiagUseCount <= 80 or(_pmuDiagUseCount & 127) == 0 then
    print "P_PathTraverse: " + msg
  end if
end function

/// Computes Doom's inexpensive fixed-point distance approximation from horizontal and vertical deltas.
/// @param dx Horizontal coordinate or vector component represented by dx.
/// @param dy Vertical coordinate or vector component represented by dy.
function inline P_AproxDistance(dx, dy)
  dx = _abs(dx)
  dy = _abs(dy)
  if dx < dy then
    return dx + dy -(dx >> 1)
  end if
  return dx + dy -(dy >> 1)
end function

/// Classifies a fixed-point point against a partition line while preserving Doom's vertical, horizontal, and
/// sign-bit shortcuts.
/// @param x Horizontal map- or screen-space coordinate.
/// @param y Vertical map- or screen-space coordinate.
/// @param line Map line or text line affected by the operation.
function inline P_PointOnLineSide(x, y, line)
  if line is void then return 0 end if

  if line.dx == 0 then
    if x <= line.v1.x then
      if line.dy > 0 then return 1 else return 0 end if
    end if
    if line.dy < 0 then return 1 else return 0 end if
  end if

  if line.dy == 0 then
    if y <= line.v1.y then
      if line.dx < 0 then return 1 else return 0 end if
    end if
    if line.dx > 0 then return 1 else return 0 end if
  end if

  dx = x - line.v1.x
  dy = y - line.v1.y

  left = FixedMul(line.dy >> FRACBITS, dx)
  right = FixedMul(dy, line.dx >> FRACBITS)

  if right < left then return 0 end if
  return 1
end function

/// Classifies an axis-aligned bounding box against a line, returning -1 when the box straddles both sides.
/// @param tmbox Temporary movement bounding box to read or update.
/// @param ld Ld value supplied to `P_BoxOnLineSide`.
function inline P_BoxOnLineSide(tmbox, ld)
  if tmbox is void or ld is void then return 0 end if

  p1 = 0
  p2 = 0

  if ld.slopetype == slopetype_t.ST_HORIZONTAL then
    if tmbox[BOXTOP] > ld.v1.y then p1 = 1 else p1 = 0 end if
    if tmbox[BOXBOTTOM] > ld.v1.y then p2 = 1 else p2 = 0 end if
    if ld.dx < 0 then
      p1 = p1 ^ 1
      p2 = p2 ^ 1
    end if
  else if ld.slopetype == slopetype_t.ST_VERTICAL then
    if tmbox[BOXRIGHT] < ld.v1.x then p1 = 1 else p1 = 0 end if
    if tmbox[BOXLEFT] < ld.v1.x then p2 = 1 else p2 = 0 end if
    if ld.dy < 0 then
      p1 = p1 ^ 1
      p2 = p2 ^ 1
    end if
  else if ld.slopetype == slopetype_t.ST_POSITIVE then
    p1 = P_PointOnLineSide(tmbox[BOXLEFT], tmbox[BOXTOP], ld)
    p2 = P_PointOnLineSide(tmbox[BOXRIGHT], tmbox[BOXBOTTOM], ld)
  else
    p1 = P_PointOnLineSide(tmbox[BOXRIGHT], tmbox[BOXTOP], ld)
    p2 = P_PointOnLineSide(tmbox[BOXLEFT], tmbox[BOXBOTTOM], ld)
  end if

  if p1 == p2 then return p1 end if
  return -1
end function

/// Classifies a fixed-point point against an infinite divline using overflow-safe sign tests and scaled cross
/// products.
/// @param x Horizontal map- or screen-space coordinate.
/// @param y Vertical map- or screen-space coordinate.
/// @param line Map line or text line affected by the operation.
function inline P_PointOnDivlineSide(x, y, line)
  if line is void then return 0 end if

  if line.dx == 0 then
    if x <= line.x then
      if line.dy > 0 then return 1 else return 0 end if
    end if
    if line.dy < 0 then return 1 else return 0 end if
  end if

  if line.dy == 0 then
    if y <= line.y then
      if line.dx < 0 then return 1 else return 0 end if
    end if
    if line.dx > 0 then return 1 else return 0 end if
  end if

  dx = x - line.x
  dy = y - line.y

  if _PMU_HasSignBit(line.dy ^ line.dx ^ dx ^ dy) then
    if _PMU_HasSignBit(line.dy ^ dx) then
      return 1
    end if
    return 0
  end if

  left = FixedMul(line.dy >> 8, dx >> 8)
  right = FixedMul(dy >> 8, line.dx >> 8)

  if right < left then return 0 end if
  return 1
end function

/// Copies a linedef's first vertex and direction into the lightweight divline form used by trace calculations.
/// @param li Li value supplied to `P_MakeDivline`.
/// @param dl Dl value supplied to `P_MakeDivline`.
function inline P_MakeDivline(li, dl)
  if li is void or dl is void then return end if
  dl.x = li.v1.x
  dl.y = li.v1.y
  dl.dx = li.dx
  dl.dy = li.dy
end function

/// Computes the fixed-point fraction where one divline intersects another, returning zero for parallel traces.
/// @param v2 V2 value supplied to `P_InterceptVector`.
/// @param v1 V1 value supplied to `P_InterceptVector`.
function inline P_InterceptVector(v2, v1)
  den = FixedMul(v1.dy >> 8, v2.dx) - FixedMul(v1.dx >> 8, v2.dy)
  if den == 0 then
    return 0
  end if

  num = FixedMul((v1.x - v2.x) >> 8, v1.dy) + FixedMul((v2.y - v1.y) >> 8, v1.dx)
  return FixedDiv(num, den)
end function

/// Computes the vertical opening, top, bottom, and low-floor values across a two-sided line into shared trace
/// globals.
/// @param linedef Linedef value supplied to `P_LineOpening`.
function P_LineOpening(linedef)
  global opentop
  global openbottom
  global openrange
  global lowfloor

  if linedef is void then
    opentop = 0
    openbottom = 0
    openrange = 0
    lowfloor = 0
    return
  end if

  if not _PMU_IsSeq(linedef.sidenum) or len(linedef.sidenum) < 2 or linedef.sidenum[1] == -1 then
    opentop = 0
    openbottom = 0
    openrange = 0
    lowfloor = 0
    return
  end if

  front = linedef.frontsector
  back = linedef.backsector

  if front is void or back is void then
    opentop = 0
    openbottom = 0
    openrange = 0
    lowfloor = 0
    return
  end if

  if front.ceilingheight < back.ceilingheight then
    opentop = front.ceilingheight
  else
    opentop = back.ceilingheight
  end if

  if front.floorheight > back.floorheight then
    openbottom = front.floorheight
    lowfloor = back.floorheight
  else
    openbottom = back.floorheight
    lowfloor = front.floorheight
  end if

  openrange = opentop - openbottom
end function

/// Unlinks a mobj from sector and blockmap chains before movement, honoring no-sector and no-blockmap flags.
/// @param thing World object affected by the operation.
function P_UnsetThingPosition(thing)
  if thing is void then return end if

  if (thing.flags & mobjflag_t.MF_NOSECTOR) == 0 then
    if thing.snext is not void then
      thing.snext.sprev = thing.sprev
    end if

    if thing.sprev is not void then
      thing.sprev.snext = thing.snext
    else

      if thing.subsector is not void and thing.subsector.sector is not void then
        thing.subsector.sector.thinglist = thing.snext
      end if
    end if
  end if

  if (thing.flags & mobjflag_t.MF_NOBLOCKMAP) == 0 then
    if thing.bnext is not void then
      thing.bnext.bprev = thing.bprev
    end if

    if thing.bprev is not void then
      thing.bprev.bnext = thing.bnext
    else

      if blocklinks is void then return end if
      blockx =(thing.x - bmaporgx) >> MAPBLOCKSHIFT
      blocky =(thing.y - bmaporgy) >> MAPBLOCKSHIFT

      if blockx >= 0 and blockx < bmapwidth and blocky >= 0 and blocky < bmapheight then
        idx = blocky * bmapwidth + blockx
        if thing.bnext is not void then
          blocklinks[idx] = thing.bnext
        else

          blocklinks[idx] = 0
        end if
      end if
    end if
  end if
end function

/// Finds a thing's subsector and links it into sector and blockmap lists unless its flags suppress either
/// index.
/// @param thing World object affected by the operation.
function P_SetThingPosition(thing)
  if thing is void then return end if

  ss = R_PointInSubsector(thing.x, thing.y)
  thing.subsector = ss

  if (thing.flags & mobjflag_t.MF_NOSECTOR) == 0 then
    if ss is not void and ss.sector is not void then
      sec = ss.sector
      thing.sprev = void
      thing.snext = sec.thinglist
      if sec.thinglist is not void then
        sec.thinglist.sprev = thing
      end if
      sec.thinglist = thing
    end if
  end if

  if (thing.flags & mobjflag_t.MF_NOBLOCKMAP) == 0 then
    if blocklinks is void or bmapwidth <= 0 or bmapheight <= 0 then
      thing.bnext = void
      thing.bprev = void
      return
    end if

    blockx =(thing.x - bmaporgx) >> MAPBLOCKSHIFT
    blocky =(thing.y - bmaporgy) >> MAPBLOCKSHIFT

    if blockx >= 0 and blockx < bmapwidth and blocky >= 0 and blocky < bmapheight then
      idx = blocky * bmapwidth + blockx
      link = blocklinks[idx]
      if typeof(link) != "struct" then link = void end if
      thing.bprev = void
      thing.bnext = link
      if link is not void then
        link.bprev = thing
      end if
      blocklinks[idx] = thing
    else
      thing.bnext = void
      thing.bprev = void
    end if
  end if
end function

/// Visits each valid line in one blockmap cell once per traversal and stops immediately when the callback
/// rejects it.
/// @param x Horizontal map- or screen-space coordinate.
/// @param y Vertical map- or screen-space coordinate.
/// @param func Func value supplied to `P_BlockLinesIterator`.
function P_BlockLinesIterator(x, y, func)
  global validcount

  if func is void then return true end if
  if x < 0 or y < 0 or x >= bmapwidth or y >= bmapheight then
    return true
  end if
  if not _PMU_IsSeq(blockmap) or not _PMU_IsSeq(blockmaplump) or not _PMU_IsSeq(lines) then
    return true
  end if

  offsetIndex = y * bmapwidth + x
  if offsetIndex < 0 or offsetIndex >= len(blockmap) then
    return true
  end if

  offset = blockmap[offsetIndex]
  if typeof(offset) != "int" then return true end if

  if offset < 0 then offset = offset + 65536 end if
  if offset < 0 or offset >= len(blockmaplump) then return true end if

  i = offset
  while i < len(blockmaplump)
    lnum = blockmaplump[i]
    if lnum == -1 then
      break
    end if
    if lnum >= 0 and lnum < len(lines) then
      ld = lines[lnum]
      if ld is not void then
        if typeof(validcount) != "int" then validcount = 1 end if
        if typeof(ld.validcount) != "int" or ld.validcount != validcount then
          ld.validcount = validcount
          if func(ld) == false then
            return false
          end if
        end if
      end if
    end if
    i = i + 1
  end while

  return true
end function

/// Walks the mobj chain for one blockmap cell and stops when the callback returns false.
/// @param x Horizontal map- or screen-space coordinate.
/// @param y Vertical map- or screen-space coordinate.
/// @param func Func value supplied to `P_BlockThingsIterator`.
function P_BlockThingsIterator(x, y, func)
  if func is void then return true end if
  if x < 0 or y < 0 or x >= bmapwidth or y >= bmapheight then
    return true
  end if
  if not _PMU_IsSeq(blocklinks) then
    return true
  end if

  mobj = blocklinks[y * bmapwidth + x]
  if typeof(mobj) != "struct" then mobj = void end if
  while mobj is not void
    if func(mobj) == false then
      return false
    end if
    mobj = mobj.bnext
    if typeof(mobj) != "struct" then mobj = void end if
  end while
  return true
end function

/// Defines pt addlines for the p maputl subsystem.
const PT_ADDLINES = 1
/// Defines pt addthings for the p maputl subsystem.
const PT_ADDTHINGS = 2
/// Defines pt earlyout for the p maputl subsystem.
const PT_EARLYOUT = 4

/// Tracks whether earlyout is active in the p maputl subsystem.
earlyout = false
/// Tracks the mutable ptflags value used by the p maputl subsystem.
ptflags = 0

/// Lazily allocates the reusable baseline intercept records required before path traversal begins.
/// @internal
function inline _EnsureIntercepts()
  global intercepts
  if len(intercepts) == 0 then
    i = 0
    while i < MAXINTERCEPTS
      intercepts = intercepts +[intercept_t(0, false, void, void)]
      i = i + 1
    end while
  end if
end function

/// Lazily allocates and geometrically grows the reusable intercept array required by path traversal.
/// @param need Need value supplied to `_PT_EnsureInterceptCapacity`.
/// @internal
function _PT_EnsureInterceptCapacity(need)
  global intercepts
  if typeof(need) != "int" then return end if
  if need <= len(intercepts) then return end if
  if len(intercepts) == 0 then
    _EnsureIntercepts()
  end if

  target = len(intercepts)
  if target < 1 then target = MAXINTERCEPTS end if
  while target < need
    target = target * 2
    if target < 1 then
      target = need
      break
    end if
  end while

  i = len(intercepts)
  while i < target
    intercepts = intercepts +[intercept_t(0, false, void, void)]
    i = i + 1
  end while

  _PMU_DiagUseLog("intercept-capacity=" + len(intercepts))
end function

/// Tests one line against the active trace and appends its in-range fractional crossing to the intercept
/// buffer.
/// @param ld Ld value supplied to `_PT_AddLineIntercept`.
/// @internal
function _PT_AddLineIntercept(ld)
  global intercept_p
  if ld is void then return true end if

  s1 = 0
  s2 = 0
  frac = 0
  dl = divline_t(0, 0, 0, 0)

  if trace.dx > FRACUNIT * 16 or trace.dy > FRACUNIT * 16 or trace.dx < -FRACUNIT * 16 or trace.dy < -FRACUNIT * 16 then
    s1 = P_PointOnDivlineSide(ld.v1.x, ld.v1.y, trace)
    s2 = P_PointOnDivlineSide(ld.v2.x, ld.v2.y, trace)
  else
    s1 = P_PointOnLineSide(trace.x, trace.y, ld)
    s2 = P_PointOnLineSide(trace.x + trace.dx, trace.y + trace.dy, ld)
  end if

  if s1 == s2 then
    return true
  end if

  P_MakeDivline(ld, dl)
  frac = P_InterceptVector(trace, dl)

  if frac < 0 then
    return true
  end if

  if earlyout and frac < FRACUNIT and ld.backsector is void then
    return false
  end if

  _PT_EnsureInterceptCapacity(intercept_p + 1)

  intercepts[intercept_p] = intercept_t(frac, true, void, ld)
  intercept_p = intercept_p + 1
  return true
end function

/// Approximates a thing as a trace-facing diagonal and appends an in-range crossing intercept.
/// @param thing World object affected by the operation.
/// @internal
function _PT_AddThingIntercept(thing)
  global intercept_p
  if thing is void then return true end if

  tracepositive = false
  x1 = 0
  y1 = 0
  x2 = 0
  y2 = 0
  s1 = 0
  s2 = 0
  frac = 0

  tracepositive =(trace.dx ^ trace.dy) > 0

  if tracepositive then
    x1 = thing.x - thing.radius
    y1 = thing.y + thing.radius
    x2 = thing.x + thing.radius
    y2 = thing.y - thing.radius
  else
    x1 = thing.x - thing.radius
    y1 = thing.y - thing.radius
    x2 = thing.x + thing.radius
    y2 = thing.y + thing.radius
  end if

  s1 = P_PointOnDivlineSide(x1, y1, trace)
  s2 = P_PointOnDivlineSide(x2, y2, trace)
  if s1 == s2 then
    return true
  end if

  dl = divline_t(x1, y1, x2 - x1, y2 - y1)
  frac = P_InterceptVector(trace, dl)
  if frac < 0 then
    return true
  end if

  _PT_EnsureInterceptCapacity(intercept_p + 1)

  intercepts[intercept_p] = intercept_t(frac, false, thing, void)
  intercept_p = intercept_p + 1
  return true
end function

/// Adapts blockmap line iteration to the current path-traversal intercept collector.
/// @param ld Ld value supplied to `PIT_AddLineIntercepts`.
function PIT_AddLineIntercepts(ld)
  return _PT_AddLineIntercept(ld)
end function

/// Adapts blockmap thing iteration to the current path-traversal intercept collector.
/// @param thing World object affected by the operation.
function PIT_AddThingIntercepts(thing)
  return _PT_AddThingIntercept(thing)
end function

/// Computes intercepts values for the map utility.
/// @param func Func value supplied to `P_TraverseIntercepts`.
/// @param maxfrac Maxfrac value supplied to `P_TraverseIntercepts`.
function P_TraverseIntercepts(func, maxfrac)
  if typeof(func) != "function" then return true end if

  count = intercept_p
  while count > 0
    dist = 2147483647
    inIdx = -1
    i = 0
    while i < intercept_p
      if intercepts[i].frac < dist then
        dist = intercepts[i].frac
        inIdx = i
      end if
      i = i + 1
    end while

    if inIdx < 0 then
      return true
    end if
    if dist > maxfrac then
      return true
    end if

    if func(intercepts[inIdx]) == false then
      return false
    end if

    intercepts[inIdx].frac = 2147483647
    count = count - 1
  end while

  return true
end function

/// Steps a trace through blockmap cells, collects requested line and thing crossings, sorts them by fraction,
/// and invokes the traverser in order.
/// @param x1 Horizontal coordinate of the first endpoint.
/// @param y1 Vertical coordinate of the first endpoint.
/// @param x2 Horizontal coordinate of the second endpoint.
/// @param y2 Vertical coordinate of the second endpoint.
/// @param flags Bit flags that control the operation.
/// @param trav Trav value supplied to `P_PathTraverse`.
function P_PathTraverse(x1, y1, x2, y2, flags, trav)
  global intercept_p
  global ptflags
  global earlyout
  global trace
  global validcount

  if typeof(trav) != "function" then
    return true
  end if

  _EnsureIntercepts()
  intercept_p = 0
  ptflags = flags
  earlyout =(flags & PT_EARLYOUT) != 0
  if typeof(validcount) != "int" then validcount = 1 end if
  validcount = validcount + 1

  if ((x1 - bmaporgx) &(MAPBLOCKSIZE - 1)) == 0 then
    x1 = x1 + FRACUNIT
  end if
  if ((y1 - bmaporgy) &(MAPBLOCKSIZE - 1)) == 0 then
    y1 = y1 + FRACUNIT
  end if

  trace.x = x1
  trace.y = y1
  trace.dx = x2 - x1
  trace.dy = y2 - y1

  bx1 = x1 - bmaporgx
  by1 = y1 - bmaporgy
  bx2 = x2 - bmaporgx
  by2 = y2 - bmaporgy

  xt1 = bx1 >> MAPBLOCKSHIFT
  yt1 = by1 >> MAPBLOCKSHIFT
  xt2 = bx2 >> MAPBLOCKSHIFT
  yt2 = by2 >> MAPBLOCKSHIFT

  mapxstep = 0
  mapystep = 0
  partial = 0
  ystep = 0
  xstep = 0
  den = 0

  if xt2 > xt1 then
    mapxstep = 1
    partial = FRACUNIT -((bx1 >> MAPBTOFRAC) &(FRACUNIT - 1))
    den = _abs(bx2 - bx1)
    if den == 0 then
      ystep = 256 * FRACUNIT
    else
      ystep = FixedDiv(by2 - by1, den)
    end if
  else if xt2 < xt1 then
    mapxstep = -1
    partial =(bx1 >> MAPBTOFRAC) &(FRACUNIT - 1)
    den = _abs(bx2 - bx1)
    if den == 0 then
      ystep = 256 * FRACUNIT
    else
      ystep = FixedDiv(by2 - by1, den)
    end if
  else
    mapxstep = 0
    partial = FRACUNIT
    ystep = 256 * FRACUNIT
  end if

  yintercept =(by1 >> MAPBTOFRAC) + FixedMul(partial, ystep)

  if yt2 > yt1 then
    mapystep = 1
    partial = FRACUNIT -((by1 >> MAPBTOFRAC) &(FRACUNIT - 1))
    den = _abs(by2 - by1)
    if den == 0 then
      xstep = 256 * FRACUNIT
    else
      xstep = FixedDiv(bx2 - bx1, den)
    end if
  else if yt2 < yt1 then
    mapystep = -1
    partial =(by1 >> MAPBTOFRAC) &(FRACUNIT - 1)
    den = _abs(by2 - by1)
    if den == 0 then
      xstep = 256 * FRACUNIT
    else
      xstep = FixedDiv(bx2 - bx1, den)
    end if
  else
    mapystep = 0
    partial = FRACUNIT
    xstep = 256 * FRACUNIT
  end if

  xintercept =(bx1 >> MAPBTOFRAC) + FixedMul(partial, xstep)

  mapx = xt1
  mapy = yt1
  steps = 0

  count = 0
  while count < 64
    if (flags & PT_ADDLINES) != 0 then
      if P_BlockLinesIterator(mapx, mapy, _PT_AddLineIntercept) == false then
        return false
      end if
    end if

    if (flags & PT_ADDTHINGS) != 0 then
      if P_BlockThingsIterator(mapx, mapy, _PT_AddThingIntercept) == false then
        return false
      end if
    end if

    if mapx == xt2 and mapy == yt2 then
      break
    end if

    if (yintercept >> FRACBITS) == mapy then
      yintercept = yintercept + ystep
      mapx = mapx + mapxstep
    else if (xintercept >> FRACBITS) == mapx then
      xintercept = xintercept + xstep
      mapy = mapy + mapystep
    end if

    count = count + 1
    steps = steps + 1
  end while

  _PMU_DiagUseLog("from (" + xt1 + "," + yt1 + ") to (" + xt2 + "," + yt2 + ") end=(" + mapx + "," + mapy + ") steps=" + steps + " intercepts=" + intercept_p + " flags=" + flags)
  return P_TraverseIntercepts(trav, FRACUNIT)
end function



