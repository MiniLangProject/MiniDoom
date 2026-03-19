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

  Script: r_main.ml
  Purpose: Implements renderer data preparation and software rendering pipeline stages.
*/
import d_player
import r_data
import doomdef
import d_net
import doomstat
import m_argv
import m_bbox
import r_local
import r_sky
import std.math
import std.time

viewcos = 0
viewsin = 0

viewwidth = 0
viewheight = 0
viewwindowx = 0
viewwindowy = 0

centerx = 0
centery = 0
centerxfrac = 0
centeryfrac = 0
projection = 0

validcount = 1

linecount = 0
loopcount = 0

const LIGHTLEVELS = 16
const LIGHTSEGSHIFT = 4
const MAXLIGHTSCALE = 48
const LIGHTSCALESHIFT = 12
const MAXLIGHTZ = 128
const LIGHTZSHIFT = 20
const NUMCOLORMAPS = 32

scalelight = void
scalelightfixed = void
zlight = void

extralight = 0
fixedcolormap = void

detailshift = 0
setsizeneeded = false
setblocks = 10
setdetail = 0

colfunc = void
basecolfunc = void
fuzzcolfunc = void
transcolfunc = void
spanfunc = void

const FIELDOFVIEW = 2048

viewangleoffset = 0

framecount = 0
sscount = 0

_r_prof_enabled = false
_r_prof_t0 = 0
_r_prof_frames = 0
_r_prof_clear_ms = 0
_r_prof_bsp_ms = 0
_r_prof_planes_ms = 0
_r_prof_masked_ms = 0

_r_interp_player = void
_r_interp_last_tic = -1
_r_interp_prev_x = 0
_r_interp_prev_y = 0
_r_interp_prev_z = 0
_r_interp_prev_angle = 0
_r_interp_cur_x = 0
_r_interp_cur_y = 0
_r_interp_cur_z = 0
_r_interp_cur_angle = 0

/*
* Function: _R_TimeMs
* Purpose: Implements the _R_TimeMs routine for the internal module support.
*/
function inline _R_TimeMs()
  t = std.time.ticks()
  return _R_ToIntOr(t, 0)
end function

/*
* Function: _R_ProfileFlushMaybe
* Purpose: Implements the _R_ProfileFlushMaybe routine for the internal module support.
*/
function _R_ProfileFlushMaybe()
  global _r_prof_t0
  global _r_prof_frames
  global _r_prof_clear_ms
  global _r_prof_bsp_ms
  global _r_prof_planes_ms
  global _r_prof_masked_ms

  if not _r_prof_enabled then return end if
  now = _R_TimeMs()
  if _r_prof_t0 == 0 then
    _r_prof_t0 = now
    return
  end if
  elapsed = now - _r_prof_t0
  if elapsed < 1000 then return end if

  fps = 0
  if elapsed > 0 then fps = _R_IDiv(_r_prof_frames * 1000, elapsed) end if
  cCalls = 0
  cPix = 0
  sCalls = 0
  sPix = 0
  aCalls = 0
  aMs = 0
  stCalls = 0
  stMs = 0
  segLoopMs = 0
  subCalls = 0
  bboxMs = 0
  bboxCalls = 0
  sideMs = 0
  sideCalls = 0
  nodeCalls = 0
  clipMax = 0
  revSpans = 0
  ss = 0
  dsCount = 0
  if typeof(_rd_prof_col_calls) == "int" then cCalls = _rd_prof_col_calls end if
  if typeof(_rd_prof_col_pixels) == "int" then cPix = _rd_prof_col_pixels end if
  if typeof(_rd_prof_span_calls) == "int" then sCalls = _rd_prof_span_calls end if
  if typeof(_rd_prof_span_pixels) == "int" then sPix = _rd_prof_span_pixels end if
  if typeof(_rb_prof_addline_calls) == "int" then aCalls = _rb_prof_addline_calls end if
  if typeof(_rb_prof_addline_ms) == "int" then aMs = _rb_prof_addline_ms end if
  if typeof(_rb_prof_store_calls) == "int" then stCalls = _rb_prof_store_calls end if
  if typeof(_rb_prof_store_ms) == "int" then stMs = _rb_prof_store_ms end if
  if typeof(_rb_prof_segloop_ms) == "int" then segLoopMs = _rb_prof_segloop_ms end if
  if typeof(_rb_prof_subsector_calls) == "int" then subCalls = _rb_prof_subsector_calls end if
  if typeof(_rb_prof_bbox_ms) == "int" then bboxMs = _rb_prof_bbox_ms end if
  if typeof(_rb_prof_bbox_calls) == "int" then bboxCalls = _rb_prof_bbox_calls end if
  if typeof(_rb_prof_pointonside_ms) == "int" then sideMs = _rb_prof_pointonside_ms end if
  if typeof(_rb_prof_pointonside_calls) == "int" then sideCalls = _rb_prof_pointonside_calls end if
  if typeof(_rb_prof_node_calls) == "int" then nodeCalls = _rb_prof_node_calls end if
  if typeof(_rb_prof_newend_max) == "int" then clipMax = _rb_prof_newend_max end if
  if typeof(_rb_prof_revspans) == "int" then revSpans = _rb_prof_revspans end if
  if typeof(sscount) == "int" then ss = sscount end if
  if typeof(ds_p) == "int" then dsCount = ds_p end if
  spThings = 0
  spProj = 0
  spRej = 0
  spDraw = 0
  rNoThing = 0
  rNoSprites = 0
  rBadSprite = 0
  rBehind = 0
  rSide = 0
  rBadDef = 0
  rBadFrame = 0
  rNoFrame = 0
  rBadLump = 0
  rOffR = 0
  rOffL = 0
  rNoVis = 0
  if typeof(_rt_profThings) == "int" then spThings = _rt_profThings end if
  if typeof(_rt_profProjected) == "int" then spProj = _rt_profProjected end if
  if typeof(_rt_profRejected) == "int" then spRej = _rt_profRejected end if
  if typeof(_rt_profDrawn) == "int" then spDraw = _rt_profDrawn end if
  if typeof(_rt_rejNoThing) == "int" then rNoThing = _rt_rejNoThing end if
  if typeof(_rt_rejNoSprites) == "int" then rNoSprites = _rt_rejNoSprites end if
  if typeof(_rt_rejBadSprite) == "int" then rBadSprite = _rt_rejBadSprite end if
  if typeof(_rt_rejBehind) == "int" then rBehind = _rt_rejBehind end if
  if typeof(_rt_rejSide) == "int" then rSide = _rt_rejSide end if
  if typeof(_rt_rejBadDef) == "int" then rBadDef = _rt_rejBadDef end if
  if typeof(_rt_rejBadFrame) == "int" then rBadFrame = _rt_rejBadFrame end if
  if typeof(_rt_rejNoFrame) == "int" then rNoFrame = _rt_rejNoFrame end if
  if typeof(_rt_rejBadLump) == "int" then rBadLump = _rt_rejBadLump end if
  if typeof(_rt_rejOffRight) == "int" then rOffR = _rt_rejOffRight end if
  if typeof(_rt_rejOffLeft) == "int" then rOffL = _rt_rejOffLeft end if
  if typeof(_rt_rejNoVis) == "int" then rNoVis = _rt_rejNoVis end if
  vpAll = 0
  vpSky = 0
  vpFlat = 0
  mpCalls = 0
  if typeof(_rp_prof_visplanes_total) == "int" then vpAll = _rp_prof_visplanes_total end if
  if typeof(_rp_prof_visplanes_sky) == "int" then vpSky = _rp_prof_visplanes_sky end if
  if typeof(_rp_prof_visplanes_flat) == "int" then vpFlat = _rp_prof_visplanes_flat end if
  if typeof(_rp_prof_mapplane_calls) == "int" then mpCalls = _rp_prof_mapplane_calls end if
  print "PROFILE r_main: fps=" + fps + " clear=" + _r_prof_clear_ms + "ms bsp=" + _r_prof_bsp_ms + "ms planes=" + _r_prof_planes_ms + "ms masked=" + _r_prof_masked_ms + "ms ss=" + ss + " ds=" + dsCount + " things=" + spThings + " proj=" + spProj + " rej=" + spRej + " draw=" + spDraw + " vp=" + vpAll + " sky=" + vpSky + " flat=" + vpFlat + " spans=" + mpCalls
  print "PROFILE r_things: noThing=" + rNoThing + " noSprites=" + rNoSprites + " badSprite=" + rBadSprite + " behind=" + rBehind + " side=" + rSide + " badDef=" + rBadDef + " badFrame=" + rBadFrame + " noFrame=" + rNoFrame + " badLump=" + rBadLump + " offR=" + rOffR + " offL=" + rOffL + " noVis=" + rNoVis
  print "PROFILE r_main2: nodes=" + nodeCalls + " subCalls=" + subCalls + " segLoop=" + segLoopMs + "ms addLine=" + aMs + "ms/" + aCalls + " store=" + stMs + "ms/" + stCalls + " bbox=" + bboxMs + "ms/" + bboxCalls + " side=" + sideMs + "ms/" + sideCalls + " clipMax=" + clipMax + " revSpans=" + revSpans + " colCalls=" + cCalls + " colPix=" + cPix + " spanCalls=" + sCalls + " spanPix=" + sPix

  _r_prof_t0 = now
  _r_prof_frames = 0
  _r_prof_clear_ms = 0
  _r_prof_bsp_ms = 0
  _r_prof_planes_ms = 0
  _r_prof_masked_ms = 0
  if typeof(R_DrawProfileReset) == "function" then R_DrawProfileReset() end if
  if typeof(R_BspProfileReset) == "function" then R_BspProfileReset() end if
end function

/*
* Function: _R_Abs
* Purpose: Implements the _R_Abs routine for the internal module support.
*/
function inline _R_Abs(x)
  xi = _R_ToIntOr(x, 0)
  if xi < 0 then return - xi end if
  return xi
end function

/*
* Function: _R_IDiv
* Purpose: Implements the _R_IDiv routine for the internal module support.
*/
function inline _R_IDiv(a, b)
  a = _R_ToIntOr(a, 0)
  b = _R_ToIntOr(b, 0)
  if b == 0 then return 0 end if
  q = a / b
  if q >= 0 then return std.math.floor(q) end if
  return std.math.ceil(q)
end function

/*
* Function: _R_ToIntOr
* Purpose: Implements the _R_ToIntOr routine for the internal module support.
*/
function inline _R_ToIntOr(v, fallback)
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
* Function: _R_IsSeq
* Purpose: Implements the _R_IsSeq routine for the internal module support.
*/
function inline _R_IsSeq(v)
  t = typeof(v)
  return t == "array" or t == "list"
end function

/*
* Function: _R_AngNorm
* Purpose: Implements the _R_AngNorm routine for the internal module support.
*/
function inline _R_AngNorm(a)
  ai = _R_ToIntOr(a, 0)
  return ai & 0xFFFFFFFF
end function

/*
* Function: _R_AngSub
* Purpose: Implements the _R_AngSub routine for the internal module support.
*/
function inline _R_AngSub(a, b)
  return _R_AngNorm(_R_AngNorm(a) - _R_AngNorm(b))
end function

/*
* Function: _R_FineSineAt
* Purpose: Implements the _R_FineSineAt routine for the internal module support.
*/
function inline _R_FineSineAt(angle)
  if not _R_IsSeq(finesine) or len(finesine) == 0 then return 0 end if
  idx = angle >> ANGLETOFINESHIFT
  if idx < 0 then
    idx = idx % len(finesine)
    if idx < 0 then idx = idx + len(finesine) end if
  end if
  if idx >= len(finesine) then idx = idx % len(finesine) end if
  return finesine[idx]
end function

/*
* Function: _R_TanToAngle
* Purpose: Implements the _R_TanToAngle routine for the internal module support.
*/
function inline _R_TanToAngle(num, den)
  if not _R_IsSeq(tantoangle) or len(tantoangle) == 0 then return 0 end if
  num = _R_ToIntOr(num, 0)
  den = _R_ToIntOr(den, 0)
  if num < 0 then num = -num end if
  if den < 0 then den = -den end if

  idx = _R_ToIntOr(SlopeDiv(num, den), 0)
  if idx < 0 then idx = 0 end if
  if idx >= len(tantoangle) then idx = len(tantoangle) - 1 end if
  return tantoangle[idx]
end function

/*
* Function: _R_ColorMapAt
* Purpose: Implements the _R_ColorMapAt routine for the internal module support.
*/
function inline _R_ColorMapAt(level)
  if typeof(colormaps) != "bytes" or len(colormaps) < 256 then
    return bytes(256, 0)
  end if

  if level < 0 then level = 0 end if
  maxLevel = _R_IDiv(len(colormaps), 256) - 1
  if maxLevel < 0 then maxLevel = 0 end if
  if level > maxLevel then level = maxLevel end if
  return slice(colormaps, level * 256, 256)
end function

/*
* Function: _R_HasSignBit
* Purpose: Implements the _R_HasSignBit routine for the internal module support.
*/
function inline _R_HasSignBit(v)
  return (_R_AngNorm(v) & 0x80000000) != 0
end function

/*
* Function: _R_S32
* Purpose: Implements the _R_S32 routine for the internal module support.
*/
function _R_S32(v)
  vi = 0
  if typeof(v) == "int" then
    vi = v
  else if typeof(v) == "float" then
    if v >= 0 then
      vi = std.math.floor(v)
    else
      vi = std.math.ceil(v)
    end if
  else
    n = toNumber(v)
    if typeof(n) == "int" then
      vi = n
    else if typeof(n) == "float" then
      if n >= 0 then
        vi = std.math.floor(n)
      else
        vi = std.math.ceil(n)
      end if
    else
      return 0
    end if
  end if
  x = vi & 0xFFFFFFFF
  if x >= 0x80000000 then return x - 0x100000000 end if
  return x
end function

/*
* Function: _R_ToFrac
* Purpose: Implements the _R_ToFrac routine for the internal module support.
*/
function inline _R_ToFrac(v)
  if typeof(v) == "float" then
    if v < 0 then return 0 end if
    if v > 1 then return 1 end if
    return v
  end if
  if typeof(v) == "int" then
    if v <= 0 then return 0 end if
    return 1
  end if
  n = toNumber(v)
  if typeof(n) == "float" then
    if n < 0 then return 0 end if
    if n > 1 then return 1 end if
    return n
  end if
  if typeof(n) == "int" then
    if n <= 0 then return 0 end if
    return 1
  end if
  return 1
end function

/*
* Function: _R_LerpS32
* Purpose: Implements the _R_LerpS32 routine for the internal module support.
*/
function inline _R_LerpS32(a, b, frac)
  if frac <= 0 then return _R_S32(a) end if
  if frac >= 1 then return _R_S32(b) end if
  da = _R_S32(a)
  db = _R_S32(b)
  return _R_S32(_R_ToIntOr(da +(db - da) * frac, da))
end function

/*
* Function: _R_LerpAngle
* Purpose: Implements the _R_LerpAngle routine for the internal module support.
*/
function inline _R_LerpAngle(a, b, frac)
  if frac <= 0 then return _R_AngNorm(_R_ToIntOr(a, 0)) end if
  if frac >= 1 then return _R_AngNorm(_R_ToIntOr(b, 0)) end if
  aa = _R_AngNorm(_R_ToIntOr(a, 0))
  bb = _R_AngNorm(_R_ToIntOr(b, 0))
  d =(bb - aa) & 0xFFFFFFFF
  if _R_HasSignBit(d) then d = d - 0x100000000 end if
  return _R_AngNorm(aa + _R_ToIntOr(d * frac, 0))
end function

/*
* Function: R_PointOnSide
* Purpose: Implements the R_PointOnSide routine for the renderer.
*/
function inline R_PointOnSide(x, y, node)

  if node is void then return 0 end if

  ndx = _R_S32(node.dx)
  ndy = _R_S32(node.dy)

  if ndx == 0 then
    if x <= node.x then
      if ndy > 0 then return 1 else return 0 end if
    else
      if ndy < 0 then return 1 else return 0 end if
    end if
  end if

  if ndy == 0 then
    if y <= node.y then
      if ndx < 0 then return 1 else return 0 end if
    else
      if ndx > 0 then return 1 else return 0 end if
    end if
  end if

  dx = _R_S32(x - node.x)
  dy = _R_S32(y - node.y)

  if ((ndy ^ ndx ^ dx ^ dy) & 0x80000000) != 0 then
    if ((ndy ^ dx) & 0x80000000) != 0 then
      return 1
    end if
    return 0
  end if

  left = FixedMul(ndy >> FRACBITS, dx)
  right = FixedMul(dy, ndx >> FRACBITS)

  if right < left then return 0 else return 1 end if
end function

/*
* Function: R_PointOnSegSide
* Purpose: Implements the R_PointOnSegSide routine for the renderer.
*/
function inline R_PointOnSegSide(x, y, seg)
  if seg is void then return 0 end if
  v1 = seg.v1
  v2 = seg.v2
  if v1 is void or v2 is void then return 0 end if

  lx = v1.x
  ly = v1.y

  ldx = _R_S32(v2.x - lx)
  ldy = _R_S32(v2.y - ly)

  if ldx == 0 then
    if x <= lx then
      if ldy > 0 then return 1 else return 0 end if
    else
      if ldy < 0 then return 1 else return 0 end if
    end if
  end if
  if ldy == 0 then
    if y <= ly then
      if ldx < 0 then return 1 else return 0 end if
    else
      if ldx > 0 then return 1 else return 0 end if
    end if
  end if

  dx = _R_S32(x - lx)
  dy = _R_S32(y - ly)

  if ((ldy ^ ldx ^ dx ^ dy) & 0x80000000) != 0 then
    if ((ldy ^ dx) & 0x80000000) != 0 then
      return 1
    end if
    return 0
  end if

  left = FixedMul(ldy >> FRACBITS, dx)
  right = FixedMul(dy, ldx >> FRACBITS)

  if right < left then return 0 else return 1 end if
end function

/*
* Function: R_PointToAngle
* Purpose: Implements the R_PointToAngle routine for the renderer.
*/
function R_PointToAngle(x, y)
  global viewx
  global viewy

  x = _R_S32(_R_ToIntOr(x, 0) - _R_ToIntOr(viewx, 0))
  y = _R_S32(_R_ToIntOr(y, 0) - _R_ToIntOr(viewy, 0))

  if x == 0 and y == 0 then return 0 end if

  a = 0

  if x >= 0 then
    if y >= 0 then
      if x > y then
        a = _R_TanToAngle(y, x)
      else
        a = ANG90 - 1 - _R_TanToAngle(x, y)
      end if
    else
      y = -y
      if x > y then
        a = -_R_TanToAngle(y, x)
      else
        a = ANG270 + _R_TanToAngle(x, y)
      end if
    end if
  else
    x = -x
    if y >= 0 then
      if x > y then
        a = ANG180 - 1 - _R_TanToAngle(y, x)
      else
        a = ANG90 + _R_TanToAngle(x, y)
      end if
    else
      y = -y
      if x > y then
        a = ANG180 + _R_TanToAngle(y, x)
      else
        a = ANG270 - 1 - _R_TanToAngle(x, y)
      end if
    end if
  end if

  return _R_AngNorm(a)
end function

/*
* Function: R_PointToAngle2
* Purpose: Implements the R_PointToAngle2 routine for the renderer.
*/
function inline R_PointToAngle2(x1, y1, x2, y2)
  global viewx
  global viewy

  oldx = viewx
  oldy = viewy
  viewx = x1
  viewy = y1
  a = R_PointToAngle(x2, y2)
  viewx = oldx
  viewy = oldy
  return a
end function

/*
* Function: R_PointToDist
* Purpose: Implements the R_PointToDist routine for the renderer.
*/
function inline R_PointToDist(x, y)
  global viewx
  global viewy

  dx = _R_Abs(_R_S32(_R_ToIntOr(x, 0) - _R_ToIntOr(viewx, 0)))
  dy = _R_Abs(_R_S32(_R_ToIntOr(y, 0) - _R_ToIntOr(viewy, 0)))

  if dy > dx then
    t = dx
    dx = dy
    dy = t
  end if

  if dx == 0 then return 0 end if
  if not _R_IsSeq(tantoangle) or len(tantoangle) == 0 then return dx end if
  if not _R_IsSeq(finesine) or len(finesine) == 0 then return dx end if

  idx = FixedDiv(dy, dx) >> DBITS
  if idx < 0 then idx = 0 end if
  if idx >= len(tantoangle) then idx = len(tantoangle) - 1 end if

  ang =(tantoangle[idx] + ANG90) >> ANGLETOFINESHIFT
  if ang < 0 then
    ang = ang % len(finesine)
    if ang < 0 then ang = ang + len(finesine) end if
  end if
  if ang >= len(finesine) then ang = ang % len(finesine) end if

  sinv = finesine[ang]
  if sinv == 0 then return dx end if
  return FixedDiv(dx, sinv)
end function

/*
* Function: R_ScaleFromGlobalAngle
* Purpose: Implements the R_ScaleFromGlobalAngle routine for the renderer.
*/
function R_ScaleFromGlobalAngle(visangle)
  global rw_distance
  global viewangle
  global rw_normalangle
  global projection
  global detailshift

  if not _R_IsSeq(finesine) or len(finesine) == 0 then return FRACUNIT end if
  if rw_distance == 0 then return 64 * FRACUNIT end if

  anglea = _R_AngNorm(ANG90 + _R_AngSub(visangle, viewangle))
  angleb = _R_AngNorm(ANG90 + _R_AngSub(visangle, rw_normalangle))

  ia = anglea >> ANGLETOFINESHIFT
  ib = angleb >> ANGLETOFINESHIFT

  if ia < 0 then
    ia = ia % len(finesine)
    if ia < 0 then ia = ia + len(finesine) end if
  end if
  if ib < 0 then
    ib = ib % len(finesine)
    if ib < 0 then ib = ib + len(finesine) end if
  end if
  if ia >= len(finesine) then ia = ia % len(finesine) end if
  if ib >= len(finesine) then ib = ib % len(finesine) end if

  sinea = finesine[ia]
  sineb = finesine[ib]

  num = FixedMul(projection, sineb) << detailshift
  den = FixedMul(rw_distance, sinea)

  if den >(num >> 16) then
    scale = FixedDiv(num, den)
    if scale > 64 * FRACUNIT then
      scale = 64 * FRACUNIT
    else if scale < 256 then
      scale = 256
    end if
    return scale
  end if

  return 64 * FRACUNIT
end function

/*
* Function: R_PointInSubsector
* Purpose: Implements the R_PointInSubsector routine for the renderer.
*/
function R_PointInSubsector(x, y)
  if numnodes <= 0 then
    if typeof(subsectors) == "array" and len(subsectors) > 0 then return subsectors[0] end if
    return void
  end if

  nodenum = numnodes - 1
  while (nodenum & NF_SUBSECTOR) == 0
    if typeof(nodes) != "array" or nodenum < 0 or nodenum >= len(nodes) then return void end if
    node = nodes[nodenum]
    if node is void then return void end if
    side = R_PointOnSide(x, y, node)
    nodenum = node.children[side]
  end while

  sidx = nodenum &(~NF_SUBSECTOR)
  if typeof(subsectors) == "array" and sidx >= 0 and sidx < len(subsectors) then return subsectors[sidx] end if
  return void
end function

/*
* Function: R_AddPointToBox
* Purpose: Implements the R_AddPointToBox routine for the renderer.
*/
function R_AddPointToBox(x, y, box)

  if box is void or len(box) < 4 then return end if

  if x < box[BOXLEFT] then
    box[BOXLEFT] = x
  else if x > box[BOXRIGHT] then
    box[BOXRIGHT] = x
  end if

  if y < box[BOXBOTTOM] then
    box[BOXBOTTOM] = y
  else if y > box[BOXTOP] then
    box[BOXTOP] = y
  end if
end function

/*
* Function: R_Init
* Purpose: Initializes state and dependencies for the renderer.
*/
function R_Init()
  global _r_prof_enabled

  R_InitData()
  R_InitPlanes()
  R_InitPointToAngle()
  R_InitTables()
  R_InitLightTables()

  blocks = 10
  detail = 0
  if typeof(screenblocks) == "int" then blocks = screenblocks end if
  if typeof(detailLevel) == "int" then detail = detailLevel end if
  R_SetViewSize(blocks, detail)
  R_InitTextureMapping()

  if typeof(R_InitTranslationTables) == "function" then R_InitTranslationTables() end if
  if typeof(M_CheckParm) == "function" then
    _r_prof_enabled =(M_CheckParm("-profile-render") != 0 or M_CheckParm("--profile-render") != 0)
  end if
  if typeof(R_BspProfileSetEnabled) == "function" then
    R_BspProfileSetEnabled(_r_prof_enabled)
  end if
  if typeof(R_DrawProfileSetEnabled) == "function" then
    R_DrawProfileSetEnabled(_r_prof_enabled)
  end if
  if typeof(R_ThingsProfileSetEnabled) == "function" then
    R_ThingsProfileSetEnabled(_r_prof_enabled)
  end if
  if _r_prof_enabled and typeof(R_DrawProfileReset) == "function" then
    R_DrawProfileReset()
  end if
  if _r_prof_enabled and typeof(R_BspProfileReset) == "function" then
    R_BspProfileReset()
  end if
end function

/*
* Function: R_SetViewSize
* Purpose: Reads or updates state used by the renderer.
*/
function R_SetViewSize(blocks, detail)
  global detailshift
  global setsizeneeded
  global setblocks
  global setdetail
  global viewwidth
  global viewheight
  global viewwindowx
  global viewwindowy
  global centerx
  global centery
  global centerxfrac
  global centeryfrac
  global projection
  global scaledviewwidth
  global colfunc
  global basecolfunc
  global fuzzcolfunc
  global transcolfunc
  global spanfunc
  global pspritescale
  global pspriteiscale

  setsizeneeded = true
  setblocks = blocks
  setdetail = detail

  blocks = _R_ToIntOr(blocks, 10)
  detail = _R_ToIntOr(detail, 0)
  if blocks < 3 then blocks = 3 end if
  if blocks > 11 then blocks = 11 end if
  if detail < 0 then detail = 0 end if
  if detail > 1 then detail = 1 end if

  if blocks == 11 then
    scaledviewwidth = SCREENWIDTH
    viewheight = SCREENHEIGHT
  else
    scaledviewwidth = blocks * 32
    viewheight =(_R_IDiv(blocks * 168, 10)) &(~7)
  end if

  detailshift = detail
  viewwidth = scaledviewwidth >> detailshift

  if viewwidth <= 0 then viewwidth = 1 end if
  if scaledviewwidth > SCREENWIDTH then scaledviewwidth = SCREENWIDTH end if
  if viewwidth > SCREENWIDTH then viewwidth = SCREENWIDTH end if
  if viewheight > SCREENHEIGHT then viewheight = SCREENHEIGHT end if

  centerx = _R_IDiv(viewwidth, 2)
  centery = _R_IDiv(viewheight, 2)
  centerxfrac = centerx * FRACUNIT
  centeryfrac = centery * FRACUNIT

  projection = centerxfrac

  if detailshift == 0 then
    colfunc = R_DrawColumn
    basecolfunc = R_DrawColumn
    fuzzcolfunc = R_DrawFuzzColumn
    transcolfunc = R_DrawTranslatedColumn
    spanfunc = R_DrawSpan
  else
    colfunc = R_DrawColumnLow
    basecolfunc = R_DrawColumnLow
    fuzzcolfunc = R_DrawFuzzColumn
    transcolfunc = R_DrawTranslatedColumn
    spanfunc = R_DrawSpanLow
  end if

  if typeof(R_InitBuffer) == "function" then
    R_InitBuffer(scaledviewwidth, viewheight)
  end if
  _R_InitTextureMapping()
  if typeof(R_InitSkyMap) == "function" then R_InitSkyMap() end if

  pspritescale = _R_IDiv(FRACUNIT * viewwidth, SCREENWIDTH)
  if viewwidth > 0 then
    pspriteiscale = _R_IDiv(FRACUNIT * SCREENWIDTH, viewwidth)
  else
    pspriteiscale = FRACUNIT
  end if

  if _R_IsSeq(screenheightarray) then
    i = 0
    while i < len(screenheightarray) and i < viewwidth
      screenheightarray[i] = viewheight
      i = i + 1
    end while
  end if

  _R_RebuildScaleLight()
  setsizeneeded = false
end function

/*
* Function: R_ExecuteSetViewSize
* Purpose: Reads or updates state used by the renderer.
*/
function R_ExecuteSetViewSize()
  if not setsizeneeded then return end if
  R_SetViewSize(setblocks, setdetail)
end function

/*
* Function: R_InitPointToAngle
* Purpose: Initializes state and dependencies for the renderer.
*/
function R_InitPointToAngle()
  if typeof(Tables_Init) == "function" then Tables_Init() end if
end function

/*
* Function: R_InitTables
* Purpose: Initializes state and dependencies for the renderer.
*/
function R_InitTables()
  if typeof(Tables_Init) == "function" then Tables_Init() end if
end function

/*
* Function: R_InitLightTables
* Purpose: Initializes state and dependencies for the renderer.
*/
function R_InitLightTables()
  global zlight
  global scalelight
  global scalelightfixed

  zlight =[]
  i = 0
  while i < LIGHTLEVELS
    startmap = _R_IDiv(((LIGHTLEVELS - 1 - i) * 2) * NUMCOLORMAPS, LIGHTLEVELS)
    row =[]
    j = 0
    while j < MAXLIGHTZ

      scale = FixedDiv((_R_IDiv(SCREENWIDTH, 2) * FRACUNIT),(j + 1) << LIGHTZSHIFT)
      scale = scale >> LIGHTSCALESHIFT
      level = startmap - _R_IDiv(scale, 2)
      if level < 0 then level = 0 end if
      if level >= NUMCOLORMAPS then level = NUMCOLORMAPS - 1 end if
      row = row +[_R_ColorMapAt(level)]
      j = j + 1
    end while
    zlight = zlight +[row]
    i = i + 1
  end while

  _R_RebuildScaleLight()

  scalelightfixed =[]
  i = 0
  while i < MAXLIGHTSCALE
    scalelightfixed = scalelightfixed +[_R_ColorMapAt(0)]
    i = i + 1
  end while
end function

/*
* Function: _R_RebuildScaleLight
* Purpose: Implements the _R_RebuildScaleLight routine for the internal module support.
*/
function _R_RebuildScaleLight()
  global scalelight

  denom = viewwidth << detailshift
  if denom <= 0 then denom = 1 end if

  scalelight =[]
  i = 0
  while i < LIGHTLEVELS
    startmap = _R_IDiv(((LIGHTLEVELS - 1 - i) * 2) * NUMCOLORMAPS, LIGHTLEVELS)
    row =[]
    j = 0
    while j < MAXLIGHTSCALE
      level = startmap - _R_IDiv(_R_IDiv(j * SCREENWIDTH, denom), 2)
      if level < 0 then level = 0 end if
      if level >= NUMCOLORMAPS then level = NUMCOLORMAPS - 1 end if
      row = row +[_R_ColorMapAt(level)]
      j = j + 1
    end while
    scalelight = scalelight +[row]
    i = i + 1
  end while
end function

/*
* Function: R_InitTextureMapping
* Purpose: Initializes state and dependencies for the renderer.
*/
function R_InitTextureMapping()
  _R_InitTextureMapping()
end function

/*
* Function: R_SetupFrame
* Purpose: Reads or updates state used by the renderer.
*/
function R_SetupFrame(player)
  _R_SetupFrame(player)
end function

/*
* Function: R_RenderPlayerView
* Purpose: Draws or renders output for the renderer.
*/
function R_RenderPlayerView(player)
  global _r_prof_enabled
  global _r_prof_frames
  global _r_prof_clear_ms
  global _r_prof_bsp_ms
  global _r_prof_planes_ms
  global _r_prof_masked_ms

  renderPlayer = player
  if renderPlayer is void or renderPlayer.mo is void or renderPlayer.mo.subsector is void then
    if typeof(viewplayer) == "struct" and viewplayer.mo is not void and viewplayer.mo.subsector is not void then
      renderPlayer = viewplayer
    end if
  end if

  _R_SetupFrame(renderPlayer)

  // In client-authoritative snapshot gaps, keep drawing the last valid pose instead of blanking.
  if renderPlayer is void or renderPlayer.mo is void or renderPlayer.mo.subsector is void then
    return
  end if

  if _r_prof_enabled then
    t0 = _R_TimeMs()
    R_ClearClipSegs()
    R_ClearDrawSegs()
    if typeof(R_ClearSolidClipScales) == "function" then R_ClearSolidClipScales() end if
    R_DepthClear()
    R_ClearPlanes()
    R_ClearSprites()
    _r_prof_clear_ms = _r_prof_clear_ms +(_R_TimeMs() - t0)
  else
    R_ClearClipSegs()
    R_ClearDrawSegs()
    if typeof(R_ClearSolidClipScales) == "function" then R_ClearSolidClipScales() end if
    R_DepthClear()
    R_ClearPlanes()
    R_ClearSprites()
  end if

  if typeof(NetUpdate) == "function" then
    if typeof(_DNet_MPIsAuthoritative) == "function" and _DNet_MPIsAuthoritative() then
      // Avoid authoritative state mutation while a frame is mid-render.
    else
      NetUpdate()
    end if
  end if
  if _r_prof_enabled then
    t0 = _R_TimeMs()
    R_RenderBSPNode(numnodes - 1)
    _r_prof_bsp_ms = _r_prof_bsp_ms +(_R_TimeMs() - t0)
  else
    R_RenderBSPNode(numnodes - 1)
  end if
  if typeof(NetUpdate) == "function" then
    if typeof(_DNet_MPIsAuthoritative) == "function" and _DNet_MPIsAuthoritative() then
      // Avoid authoritative state mutation while a frame is mid-render.
    else
      NetUpdate()
    end if
  end if
  if _r_prof_enabled then
    t0 = _R_TimeMs()
    R_DrawPlanes()
    _r_prof_planes_ms = _r_prof_planes_ms +(_R_TimeMs() - t0)
  else
    R_DrawPlanes()
  end if
  if typeof(NetUpdate) == "function" then
    if typeof(_DNet_MPIsAuthoritative) == "function" and _DNet_MPIsAuthoritative() then
      // Avoid authoritative state mutation while a frame is mid-render.
    else
      NetUpdate()
    end if
  end if
  if _r_prof_enabled then
    t0 = _R_TimeMs()
    R_DrawMasked()
    _r_prof_masked_ms = _r_prof_masked_ms +(_R_TimeMs() - t0)
  else
    R_DrawMasked()
  end if
  if typeof(NetUpdate) == "function" then
    if typeof(_DNet_MPIsAuthoritative) == "function" and _DNet_MPIsAuthoritative() then
      // Avoid authoritative state mutation while a frame is mid-render.
    else
      NetUpdate()
    end if
  end if

  if _r_prof_enabled then
    _r_prof_frames = _r_prof_frames + 1
    _R_ProfileFlushMaybe()
  end if
end function

/*
* Function: _R_SetupFrame
* Purpose: Reads or updates state used by the internal module support.
*/
function _R_SetupFrame(player)
  global viewplayer
  global viewx
  global viewy
  global viewz
  global viewangle
  global extralight
  global viewsin
  global viewcos
  global sscount
  global fixedcolormap
  global framecount
  global validcount
  global walllights
  global _r_interp_player
  global _r_interp_last_tic
  global _r_interp_prev_x
  global _r_interp_prev_y
  global _r_interp_prev_z
  global _r_interp_prev_angle
  global _r_interp_cur_x
  global _r_interp_cur_y
  global _r_interp_cur_z
  global _r_interp_cur_angle

  viewplayer = player

  if player is void or player.mo is void then
    _r_interp_player = void
    _r_interp_last_tic = -1
    framecount = framecount + 1
    validcount = validcount + 1
    return
  end if

  rawx = _R_S32(_R_ToIntOr(player.mo.x, 0))
  rawy = _R_S32(_R_ToIntOr(player.mo.y, 0))
  rawz = _R_S32(_R_ToIntOr(player.viewz, 0))
  rawangle = _R_AngNorm(_R_ToIntOr(player.mo.angle, 0) + _R_ToIntOr(viewangleoffset, 0))

  if typeof(uncapped_render) != "void" and uncapped_render and typeof(interp_view) != "void" and interp_view then
    tic = _R_ToIntOr(gametic, 0)
    frac = _R_ToFrac(render_lerp_frac)

    frac = 0.85 +(frac * 0.15)
    if frac > 1 then frac = 1 end if
    samePlayer =(_r_interp_player == player.mo)

    if (not samePlayer) or _r_interp_last_tic < 0 then
      _r_interp_player = player.mo
      _r_interp_last_tic = tic
      _r_interp_prev_x = rawx
      _r_interp_prev_y = rawy
      _r_interp_prev_z = rawz
      _r_interp_prev_angle = rawangle
      _r_interp_cur_x = rawx
      _r_interp_cur_y = rawy
      _r_interp_cur_z = rawz
      _r_interp_cur_angle = rawangle
    else if tic != _r_interp_last_tic then
      _r_interp_prev_x = _r_interp_cur_x
      _r_interp_prev_y = _r_interp_cur_y
      _r_interp_prev_z = _r_interp_cur_z
      _r_interp_prev_angle = _r_interp_cur_angle
      _r_interp_cur_x = rawx
      _r_interp_cur_y = rawy
      _r_interp_cur_z = rawz
      _r_interp_cur_angle = rawangle
      _r_interp_last_tic = tic
    else
      _r_interp_cur_x = rawx
      _r_interp_cur_y = rawy
      _r_interp_cur_z = rawz
      _r_interp_cur_angle = rawangle
    end if

    viewx = _R_LerpS32(_r_interp_prev_x, _r_interp_cur_x, frac)
    viewy = _R_LerpS32(_r_interp_prev_y, _r_interp_cur_y, frac)
    viewz = _R_LerpS32(_r_interp_prev_z, _r_interp_cur_z, frac)
    viewangle = _R_LerpAngle(_r_interp_prev_angle, _r_interp_cur_angle, frac)
  else
    viewx = rawx
    viewy = rawy
    viewz = rawz
    viewangle = rawangle
  end if

  extralight = _R_ToIntOr(player.extralight, 0)

  if _R_IsSeq(finesine) and len(finesine) > 0 and _R_IsSeq(finecosine) and len(finecosine) > 0 then
    aidx =(_R_AngNorm(viewangle) >> ANGLETOFINESHIFT)
    angmod = 0
    if typeof(FINEANGLES) == "int" and FINEANGLES > 0 then
      angmod = FINEANGLES
    else
      angmod = len(finecosine)
    end if
    if angmod > 0 then
      aidx = aidx % angmod
      if aidx < 0 then aidx = aidx + angmod end if
    end if
    if aidx >= len(finesine) then aidx = aidx % len(finesine) end if
    cidx = aidx
    if cidx >= len(finecosine) then cidx = cidx % len(finecosine) end if
    viewsin = finesine[aidx]
    viewcos = finecosine[cidx]
  else
    viewsin = 0
    viewcos = 0
  end if

  sscount = 0

  if player.fixedcolormap is not void and player.fixedcolormap != 0 and typeof(colormaps) == "bytes" then

    off = player.fixedcolormap * 256
    if off < 0 then off = 0 end if
    if off >= len(colormaps) then off = 0 end if
    n = len(colormaps) - off
    if n > 256 then n = 256 end if
    fixedcolormap = bytes(n, 0)
    i = 0
    while i < n
      fixedcolormap[i] = colormaps[off + i]
      i = i + 1
    end while
    walllights = scalelightfixed
    if _R_IsSeq(scalelightfixed) then
      i = 0
      while i < len(scalelightfixed)
        scalelightfixed[i] = fixedcolormap
        i = i + 1
      end while
    end if
  else
    fixedcolormap = void
  end if

  framecount = framecount + 1
  validcount = validcount + 1
end function

/*
* Function: _R_InitTextureMapping
* Purpose: Initializes state and dependencies for the internal module support.
*/
function _R_InitTextureMapping()
  global viewangletox
  global xtoviewangle
  global clipangle

  halfFine = FINEANGLES >> 1
  quarterFine = FINEANGLES >> 2
  halfFov = FIELDOFVIEW >> 1

  if viewwidth <= 0 then
    viewangletox =[]
    xtoviewangle =[]
    clipangle = ANG45
    return
  end if

  if not _R_IsSeq(finetangent) or len(finetangent) < halfFine then

    clip = ANG45
    clipangle = clip
    viewangletox =[]
    xtoviewangle =[]
    x = 0
    while x <= viewwidth
      a = _R_AngNorm(clip - _R_IDiv(x *(2 * clip), viewwidth))
      xtoviewangle = xtoviewangle +[a]
      x = x + 1
    end while
    return
  end if

  fidx = quarterFine + halfFov
  denom = finetangent[fidx]
  if denom == 0 then denom = 1 end if
  focallength = FixedDiv(centerxfrac, denom)

  viewangletox =[]
  i = 0
  while i < halfFine
    t = 0
    ft = finetangent[i]
    if ft > FRACUNIT * 2 then
      t = -1
    else if ft < -FRACUNIT * 2 then
      t = viewwidth + 1
    else
      t = FixedMul(ft, focallength)
      t =(centerxfrac - t + FRACUNIT - 1) >> FRACBITS
      if t < -1 then
        t = -1
      else if t > viewwidth + 1 then
        t = viewwidth + 1
      end if
    end if
    viewangletox = viewangletox +[t]
    i = i + 1
  end while

  xtoviewangle =[]
  x = 0
  while x <= viewwidth
    i = 0
    while i < len(viewangletox) and viewangletox[i] > x
      i = i + 1
    end while
    xtoviewangle = xtoviewangle +[_R_AngNorm((i << ANGLETOFINESHIFT) - ANG90)]
    x = x + 1
  end while

  i = 0
  while i < len(viewangletox)
    if viewangletox[i] == -1 then
      viewangletox[i] = 0
    else if viewangletox[i] == viewwidth + 1 then
      viewangletox[i] = viewwidth
    end if
    i = i + 1
  end while

  if len(xtoviewangle) > 0 then
    clipangle = _R_AngNorm(xtoviewangle[0])
  else
    clipangle = ANG45
  end if
end function



