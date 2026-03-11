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

  Script: r_bsp.ml
  Purpose: Implements renderer data preparation and software rendering pipeline stages.
*/
import doomdef
import m_bbox
import i_system
import r_main
import r_plane
import r_things
import doomstat
import r_state
import std.time
import std.math

curline = void
sidedef = void
linedef = void
frontsector = void
backsector = void

rw_x = 0
rw_stopx = 0

segtextured = false
markfloor = false
markceiling = false
skymap = false

drawsegs =[]
ds_p = 0

hscalelight = void
vscalelight = void
dscalelight = void

/*
* Struct: cliprange_t
* Purpose: Stores runtime data for cliprange type.
*/
struct cliprange_t
  first
  last
end struct

const MAXSEGS = 32
solidsegs =[]
newend = 0
checkcoord =[
[3, 0, 2, 1],
[3, 0, 2, 0],
[3, 1, 2, 0],
[0, 0, 0, 0],
[2, 0, 2, 1],
[0, 0, 0, 0],
[3, 1, 3, 0],
[0, 0, 0, 0],
[2, 0, 3, 1],
[2, 1, 3, 1],
[2, 1, 3, 0],
[0, 0, 0, 0]
]

_rb_prof_addline_ms = 0
_rb_prof_addline_calls = 0
_rb_prof_store_ms = 0
_rb_prof_store_calls = 0
_rb_prof_segloop_ms = 0
_rb_prof_subsector_calls = 0
_rb_prof_bbox_ms = 0
_rb_prof_bbox_calls = 0
_rb_prof_pointonside_ms = 0
_rb_prof_pointonside_calls = 0
_rb_prof_node_calls = 0
_rb_prof_newend_max = 0
_rb_prof_revspans = 0
_rb_prof_enabled = false
_rbsp_disable_bbox_cull = false

/*
* Function: R_BspProfileSetEnabled
* Purpose: Reads or updates state used by the renderer.
*/
function R_BspProfileSetEnabled(on)
  global _rb_prof_enabled
  _rb_prof_enabled = on
end function

/*
* Function: R_BspProfileReset
* Purpose: Reads or updates state used by the renderer.
*/
function R_BspProfileReset()
  global _rb_prof_addline_ms
  global _rb_prof_addline_calls
  global _rb_prof_store_ms
  global _rb_prof_store_calls
  global _rb_prof_segloop_ms
  global _rb_prof_subsector_calls
  global _rb_prof_bbox_ms
  global _rb_prof_bbox_calls
  global _rb_prof_pointonside_ms
  global _rb_prof_pointonside_calls
  global _rb_prof_node_calls
  global _rb_prof_newend_max
  global _rb_prof_revspans

  _rb_prof_addline_ms = 0
  _rb_prof_addline_calls = 0
  _rb_prof_store_ms = 0
  _rb_prof_store_calls = 0
  _rb_prof_segloop_ms = 0
  _rb_prof_subsector_calls = 0
  _rb_prof_bbox_ms = 0
  _rb_prof_bbox_calls = 0
  _rb_prof_pointonside_ms = 0
  _rb_prof_pointonside_calls = 0
  _rb_prof_node_calls = 0
  _rb_prof_newend_max = 0
  _rb_prof_revspans = 0
end function

/*
* Function: _RBSP_TimeMs
* Purpose: Implements the _RBSP_TimeMs routine for the internal module support.
*/
function inline _RBSP_TimeMs()
  t = std.time.ticks()
  return _RBSP_ToInt(t, 0)
end function

/*
* Function: _RBSP_StoreWallRange
* Purpose: Implements the _RBSP_StoreWallRange routine for the internal module support.
*/
function inline _RBSP_StoreWallRange(first, last)
  global _rb_prof_store_ms
  global _rb_prof_store_calls

  if not _rb_prof_enabled then
    R_StoreWallRange(first, last)
    return
  end if

  t0 = _RBSP_TimeMs()
  R_StoreWallRange(first, last)
  _rb_prof_store_ms = _rb_prof_store_ms +(_RBSP_TimeMs() - t0)
  _rb_prof_store_calls = _rb_prof_store_calls + 1
end function

/*
* Function: _makeDrawseg
* Purpose: Draws or renders output for the internal module support.
*/
function inline _makeDrawseg()

  return drawseg_t(void, 0, 0, 0, 0, 0, 0, 0, 0, void, void, void)
end function

/*
* Function: _makeClip
* Purpose: Implements the _makeClip routine for the internal module support.
*/
function inline _makeClip(first, last)
  return cliprange_t(first, last)
end function

/*
* Function: _R_ClipGet
* Purpose: Reads or updates state used by the internal module support.
*/
function inline _R_ClipGet(i)
  if i < 0 or i >= len(solidsegs) then return _makeClip(0, 0) end if
  return solidsegs[i]
end function

/*
* Function: _R_ClipSet
* Purpose: Reads or updates state used by the internal module support.
*/
function inline _R_ClipSet(i, c)
  global solidsegs
  if i < 0 then return end if
  if i < len(solidsegs) then
    solidsegs[i] = c
    return
  end if
  while len(solidsegs) <= i
    solidsegs = solidsegs +[_makeClip(0, 0)]
  end while
  solidsegs[i] = c
end function

/*
* Function: _RBSP_IsSeq
* Purpose: Implements the _RBSP_IsSeq routine for the internal module support.
*/
function inline _RBSP_IsSeq(v)
  t = typeof(v)
  return t == "array" or t == "list"
end function

/*
* Function: _RBSP_ToInt
* Purpose: Implements the _RBSP_ToInt routine for the internal module support.
*/
function inline _RBSP_ToInt(v, fallback)
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

/*
* Function: _R_ViewAngleToX
* Purpose: Implements the _R_ViewAngleToX routine for the internal module support.
*/
function inline _R_ViewAngleToX(aidx)
  if not _RBSP_IsSeq(viewangletox) or len(viewangletox) == 0 then return centerx end if
  idx = _RBSP_ToInt(aidx, 0)
  if idx < 0 then idx = 0 end if
  if idx >= len(viewangletox) then idx = len(viewangletox) - 1 end if
  return viewangletox[idx]
end function

/*
* Function: _RBSP_AngNorm
* Purpose: Implements the _RBSP_AngNorm routine for the internal module support.
*/
function inline _RBSP_AngNorm(a)
  ai = _RBSP_ToInt(a, 0)
  return ai & 0xFFFFFFFF
end function

/*
* Function: _RBSP_AngSub
* Purpose: Implements the _RBSP_AngSub routine for the internal module support.
*/
function inline _RBSP_AngSub(a, b)
  return _RBSP_AngNorm(_RBSP_AngNorm(a) - _RBSP_AngNorm(b))
end function

/*
* Function: R_ClearDrawSegs
* Purpose: Draws or renders output for the renderer.
*/
function R_ClearDrawSegs()
  global ds_p
  global drawsegs

  ds_p = 0
  if len(drawsegs) == 0 then

    i = 0
    while i < MAXDRAWSEGS
      drawsegs = drawsegs +[_makeDrawseg()]
      i = i + 1
    end while
  end if
end function

/*
* Function: R_ClearClipSegs
* Purpose: Implements the R_ClearClipSegs routine for the renderer.
*/
function R_ClearClipSegs()
  global solidsegs
  global newend
  global _rb_prof_newend_max

  solidsegs =[_makeClip(-2147483647, -1), _makeClip(viewwidth, 2147483647)]
  newend = 2
  if _rb_prof_enabled and _rb_prof_newend_max < newend then _rb_prof_newend_max = newend end if
end function

/*
* Function: R_ClipSolidWallSegment
* Purpose: Implements the R_ClipSolidWallSegment routine for the renderer.
*/
function R_ClipSolidWallSegment(first, last)
  global newend
  global _rb_prof_newend_max
  if last < first then return end if
  if newend < 2 then R_ClearClipSegs() end if

  start = 0
  while start < newend and _R_ClipGet(start).last < first - 1
    start = start + 1
  end while
  if start >= newend then return end if

  sc = _R_ClipGet(start)
  if first < sc.first then
    if last < sc.first - 1 then

      _RBSP_StoreWallRange(first, last)

      i = newend
      newend = newend + 1
      while i > start
        _R_ClipSet(i, _R_ClipGet(i - 1))
        i = i - 1
      end while
      _R_ClipSet(i, _makeClip(first, last))
      if _rb_prof_enabled and _rb_prof_newend_max < newend then _rb_prof_newend_max = newend end if
      return
    end if

    _RBSP_StoreWallRange(first, sc.first - 1)
    sc.first = first
    _R_ClipSet(start, sc)
  end if

  if last <= _R_ClipGet(start).last then return end if

  next = start
  while (next + 1) < newend and last >= _R_ClipGet(next + 1).first - 1
    _RBSP_StoreWallRange(_R_ClipGet(next).last + 1, _R_ClipGet(next + 1).first - 1)
    next = next + 1

    if last <= _R_ClipGet(next).last then
      sc = _R_ClipGet(start)
      sc.last = _R_ClipGet(next).last
      _R_ClipSet(start, sc)
      if next == start then return end if
      while (next + 1) < newend
        next = next + 1
        start = start + 1
        _R_ClipSet(start, _R_ClipGet(next))
      end while
      newend = start + 1
      if _rb_prof_enabled and _rb_prof_newend_max < newend then _rb_prof_newend_max = newend end if
      return
    end if
  end while

  _RBSP_StoreWallRange(_R_ClipGet(next).last + 1, last)
  sc = _R_ClipGet(start)
  sc.last = last
  _R_ClipSet(start, sc)

  if next == start then return end if

  while (next + 1) < newend
    next = next + 1
    start = start + 1
    _R_ClipSet(start, _R_ClipGet(next))
  end while
  newend = start + 1
  if _rb_prof_enabled and _rb_prof_newend_max < newend then _rb_prof_newend_max = newend end if
end function

/*
* Function: R_ClipPassWallSegment
* Purpose: Implements the R_ClipPassWallSegment routine for the renderer.
*/
function R_ClipPassWallSegment(first, last)
  global _rb_prof_newend_max
  if last < first then return end if
  if newend < 2 then R_ClearClipSegs() end if

  start = 0
  while start < newend and _R_ClipGet(start).last < first - 1
    start = start + 1
  end while
  if start >= newend then return end if

  sc = _R_ClipGet(start)
  if first < sc.first then
    if last < sc.first - 1 then
      _RBSP_StoreWallRange(first, last)
      return
    end if
    _RBSP_StoreWallRange(first, sc.first - 1)
  end if

  if last <= sc.last then return end if

  while (start + 1) < newend and last >= _R_ClipGet(start + 1).first - 1
    _RBSP_StoreWallRange(_R_ClipGet(start).last + 1, _R_ClipGet(start + 1).first - 1)
    start = start + 1
    if last <= _R_ClipGet(start).last then return end if
  end while

  _RBSP_StoreWallRange(_R_ClipGet(start).last + 1, last)
  if _rb_prof_enabled and _rb_prof_newend_max < newend then _rb_prof_newend_max = newend end if
end function

/*
* Function: R_AddLine
* Purpose: Implements the R_AddLine routine for the renderer.
*/
function R_AddLine(line)
  global _rb_prof_addline_ms
  global _rb_prof_addline_calls
  global _rb_prof_revspans
  global _rb_prof_enabled
  global curline
  global backsector
  global frontsector
  global rw_angle1

  t0 = 0
  if _rb_prof_enabled then
    _rb_prof_addline_calls = _rb_prof_addline_calls + 1
    t0 = _RBSP_TimeMs()
  end if

  curline = line
  if line is void then return end if
  if line.v1 is void or line.v2 is void then return end if
  if frontsector is void then return end if

  angle1 = _RBSP_AngNorm(R_PointToAngle(line.v1.x, line.v1.y))
  angle2 = _RBSP_AngNorm(R_PointToAngle(line.v2.x, line.v2.y))
  span = _RBSP_AngSub(angle1, angle2)
  if span >= ANG180 then return end if

  rw_angle1 = angle1
  angle1 = _RBSP_AngSub(angle1, viewangle)
  angle2 = _RBSP_AngSub(angle2, viewangle)

  tspan = _RBSP_AngNorm(angle1 + clipangle)
  if tspan > 2 * clipangle then
    tspan = _RBSP_AngNorm(tspan -(2 * clipangle))
    if tspan >= span then return end if
    angle1 = clipangle
  end if

  tspan = _RBSP_AngSub(clipangle, angle2)
  if tspan > 2 * clipangle then
    tspan = _RBSP_AngNorm(tspan -(2 * clipangle))
    if tspan >= span then return end if
    angle2 = _RBSP_AngNorm(-clipangle)
  end if

  a1 = _RBSP_AngNorm(angle1 + ANG90) >> ANGLETOFINESHIFT
  a2 = _RBSP_AngNorm(angle2 + ANG90) >> ANGLETOFINESHIFT

  x1 = _R_ViewAngleToX(a1)
  x2 = _R_ViewAngleToX(a2)
  if x1 == x2 then return end if
  if x2 < x1 then
    _rb_prof_revspans = _rb_prof_revspans + 1
    return
  end if

  backsector = line.backsector
  if backsector is void then
    R_ClipSolidWallSegment(x1, x2 - 1)
    return
  end if

  if backsector.ceilingheight <= frontsector.floorheight or backsector.floorheight >= frontsector.ceilingheight then
    R_ClipSolidWallSegment(x1, x2 - 1)
    return
  end if

  if backsector.ceilingheight != frontsector.ceilingheight or backsector.floorheight != frontsector.floorheight then
    R_ClipPassWallSegment(x1, x2 - 1)
    return
  end if

  if backsector.ceilingpic == frontsector.ceilingpic and backsector.floorpic == frontsector.floorpic and backsector.lightlevel == frontsector.lightlevel and line.sidedef is not void and line.sidedef.midtexture == 0 then

    return
  end if

  R_ClipPassWallSegment(x1, x2 - 1)
  if _rb_prof_enabled then _rb_prof_addline_ms = _rb_prof_addline_ms +(_RBSP_TimeMs() - t0) end if
end function

/*
* Function: R_CheckBBox
* Purpose: Evaluates conditions and returns a decision for the renderer.
*/
function R_CheckBBox(bspcoord)
  if _rbsp_disable_bbox_cull then return true end if
  if bspcoord is void or len(bspcoord) < 4 then return false end if
  if newend < 2 then return true end if

  boxx = 0
  if viewx <= bspcoord[BOXLEFT] then
    boxx = 0
  else if viewx < bspcoord[BOXRIGHT] then
    boxx = 1
  else
    boxx = 2
  end if

  boxy = 0
  if viewy >= bspcoord[BOXTOP] then
    boxy = 0
  else if viewy > bspcoord[BOXBOTTOM] then
    boxy = 1
  else
    boxy = 2
  end if

  boxpos =(boxy << 2) + boxx
  if boxpos == 5 then return true end if
  if boxpos < 0 or boxpos >= len(checkcoord) then return true end if

  cc = checkcoord[boxpos]
  x1 = bspcoord[cc[0]]
  y1 = bspcoord[cc[1]]
  x2 = bspcoord[cc[2]]
  y2 = bspcoord[cc[3]]

  angle1 = _RBSP_AngSub(R_PointToAngle(x1, y1), viewangle)
  angle2 = _RBSP_AngSub(R_PointToAngle(x2, y2), viewangle)
  span = _RBSP_AngSub(angle1, angle2)
  if span >= ANG180 then return true end if

  tspan = _RBSP_AngNorm(angle1 + clipangle)
  if tspan > 2 * clipangle then
    tspan = _RBSP_AngNorm(tspan -(2 * clipangle))
    if tspan >= span then return false end if
    angle1 = clipangle
  end if

  tspan = _RBSP_AngSub(clipangle, angle2)
  if tspan > 2 * clipangle then
    tspan = _RBSP_AngNorm(tspan -(2 * clipangle))
    if tspan >= span then return false end if
    angle2 = _RBSP_AngNorm(-clipangle)
  end if

  a1 = _RBSP_AngNorm(angle1 + ANG90) >> ANGLETOFINESHIFT
  a2 = _RBSP_AngNorm(angle2 + ANG90) >> ANGLETOFINESHIFT

  sx1 = _R_ViewAngleToX(a1)
  sx2 = _R_ViewAngleToX(a2)
  if sx1 == sx2 then return false end if
  sx2 = sx2 - 1

  start = 0

  while start < newend and _R_ClipGet(start).last < sx2
    start = start + 1
  end while
  if start >= newend then return true end if

  c = _R_ClipGet(start)
  if sx1 >= c.first and sx2 <= c.last then return false end if
  return true
end function

/*
* Function: R_Subsector
* Purpose: Implements the R_Subsector routine for the renderer.
*/
function R_Subsector(num)
  global _rb_prof_subsector_calls
  global _rb_prof_segloop_ms
  global _rb_prof_enabled
  global sscount
  global frontsector
  global floorplane
  global ceilingplane

  if num < 0 then return end if
  if not _RBSP_IsSeq(subsectors) or num >= len(subsectors) then return end if

  sscount = sscount + 1
  if _rb_prof_enabled then _rb_prof_subsector_calls = _rb_prof_subsector_calls + 1 end if
  sub = subsectors[num]
  if sub is void then return end if
  frontsector = sub.sector
  if frontsector is void then return end if

  if frontsector.floorheight < viewz then
    floorplane = R_FindPlane(frontsector.floorheight, frontsector.floorpic, frontsector.lightlevel)
  else
    floorplane = void
  end if

  if frontsector.ceilingheight > viewz or frontsector.ceilingpic == skyflatnum then
    ceilingplane = R_FindPlane(frontsector.ceilingheight, frontsector.ceilingpic, frontsector.lightlevel)
  else
    ceilingplane = void
  end if

  R_AddSprites(frontsector)

  count = sub.numlines
  idx = sub.firstline
  if _rb_prof_enabled then
    t0 = _RBSP_TimeMs()
    while count > 0
      if _RBSP_IsSeq(segs) and idx >= 0 and idx < len(segs) then
        R_AddLine(segs[idx])
      end if
      idx = idx + 1
      count = count - 1
    end while
    _rb_prof_segloop_ms = _rb_prof_segloop_ms +(_RBSP_TimeMs() - t0)
  else
    while count > 0
      if _RBSP_IsSeq(segs) and idx >= 0 and idx < len(segs) then
        R_AddLine(segs[idx])
      end if
      idx = idx + 1
      count = count - 1
    end while
  end if
end function

/*
* Function: R_RenderBSPNode
* Purpose: Draws or renders output for the renderer.
*/
function R_RenderBSPNode(bspnum)
  global _rb_prof_bbox_ms
  global _rb_prof_bbox_calls
  global _rb_prof_pointonside_ms
  global _rb_prof_pointonside_calls
  global _rb_prof_node_calls
  global _rb_prof_enabled

  if _rb_prof_enabled then _rb_prof_node_calls = _rb_prof_node_calls + 1 end if

  if (bspnum & NF_SUBSECTOR) != 0 then
    if bspnum == -1 then
      R_Subsector(0)
    else
      R_Subsector(bspnum &(~NF_SUBSECTOR))
    end if
    return
  end if

  if not _RBSP_IsSeq(nodes) or bspnum < 0 or bspnum >= len(nodes) then return end if

  node = nodes[bspnum]
  if node is void then return end if

  side = 0
  if _rb_prof_enabled then
    t0 = _RBSP_TimeMs()
    side = R_PointOnSide(viewx, viewy, node)
    _rb_prof_pointonside_ms = _rb_prof_pointonside_ms +(_RBSP_TimeMs() - t0)
    _rb_prof_pointonside_calls = _rb_prof_pointonside_calls + 1
  else
    side = R_PointOnSide(viewx, viewy, node)
  end if
  child0 = node.children[side]
  child1 = node.children[side ^ 1]

  R_RenderBSPNode(child0)
  vis = false
  if _rb_prof_enabled then
    t0 = _RBSP_TimeMs()
    vis = R_CheckBBox(node.bbox[side ^ 1])
    _rb_prof_bbox_ms = _rb_prof_bbox_ms +(_RBSP_TimeMs() - t0)
    _rb_prof_bbox_calls = _rb_prof_bbox_calls + 1
  else
    vis = R_CheckBBox(node.bbox[side ^ 1])
  end if
  if vis then
    R_RenderBSPNode(child1)
  end if
end function



