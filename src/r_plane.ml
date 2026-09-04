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

//! Aggregates visible floor, ceiling, and sky regions into visplanes and rasterizes their horizontal spans or
//! sky columns.

import r_data
import i_system
import z_zone
import w_wad
import doomdef
import doomstat
import r_local
import r_sky
import r_main
import r_upscaled
import r_hires
import std.math

/// Holds the optional lastopening resource used by the r plane subsystem.
lastopening = void

/// Holds the optional floorfunc resource used by the r plane subsystem.
floorfunc = void
/// Holds the optional ceilingfunc t resource used by the r plane subsystem.
ceilingfunc_t = void

/// Stores the floorclip collection used by the r plane subsystem.
floorclip =[]
/// Stores the ceilingclip collection used by the r plane subsystem.
ceilingclip =[]

/// Stores the yslope collection used by the r plane subsystem.
yslope =[]
/// Stores the distscale collection used by the r plane subsystem.
distscale =[]

/// Defines the maximum maxvisplanes accepted by the r plane subsystem.
const MAXVISPLANES = 128
/// Defines the maximum maxopenings accepted by the r plane subsystem.
const MAXOPENINGS = SCREENWIDTH * 64
/// Defines the maximum rp maxvisplanes hard accepted by the r plane subsystem.
const RP_MAXVISPLANES_HARD = 4096
/// Defines rp span sentinel for the r plane subsystem.
const RP_SPAN_SENTINEL = 2147483647

/// Stores the openings collection used by the r plane subsystem.
openings =[]
/// Stores the visplanes collection used by the r plane subsystem.
visplanes =[]
/// Tracks the mutable visplanes last value used by the r plane subsystem.
visplanes_last = 0
/// Holds the optional rp default colormap resource used by the r plane subsystem.
/// @internal
_rp_default_colormap = void

/// Holds the optional planezlight resource used by the r plane subsystem.
planezlight = void
/// Tracks the mutable planeheight value used by the r plane subsystem.
planeheight = 0
/// Tracks the mutable basexscale value used by the r plane subsystem.
basexscale = 0
/// Tracks the mutable baseyscale value used by the r plane subsystem.
baseyscale = 0

/// Holds the optional floorplane resource used by the r plane subsystem.
floorplane = void
/// Holds the optional ceilingplane resource used by the r plane subsystem.
ceilingplane = void

/// Stores the spanstart collection used by the r plane subsystem.
spanstart =[]
/// Stores the spanstop collection used by the r plane subsystem.
spanstop =[]
/// Stores the cachedheight collection used by the r plane subsystem.
cachedheight =[]
/// Stores the cacheddistance collection used by the r plane subsystem.
cacheddistance =[]
/// Stores the cachedxstep collection used by the r plane subsystem.
cachedxstep =[]
/// Stores the cachedystep collection used by the r plane subsystem.
cachedystep =[]
/// Tracks the mutable rp prof visplanes total value used by the r plane subsystem.
/// @internal
_rp_prof_visplanes_total = 0
/// Tracks the mutable rp prof visplanes sky value used by the r plane subsystem.
/// @internal
_rp_prof_visplanes_sky = 0
/// Tracks the mutable rp prof visplanes flat value used by the r plane subsystem.
/// @internal
_rp_prof_visplanes_flat = 0
/// Tracks the mutable rp prof mapplane calls value used by the r plane subsystem.
/// @internal
_rp_prof_mapplane_calls = 0

/// Returns a signed quotient truncated toward zero, or zero for invalid operands and a zero divisor in
/// `_RP_IDiv`
/// @param a First input operand.
/// @param b Second input operand.
/// @internal
function inline _RP_IDiv(a, b)
  if typeof(a) != "int" or typeof(b) != "int" or b == 0 then return 0 end if
  q = a / b
  if q >= 0 then return std.math.floor(q) end if
  return std.math.ceil(q)
end function

/// Coerces numeric values to truncation-toward-zero integers and returns a caller fallback on conversion
/// failure.
/// @param v Value consumed by the operation.
/// @param fallback Value returned when the requested conversion or lookup is unavailable.
/// @internal
function inline _RP_I(v, fallback)
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

/// Returns the non-negative integer magnitude of a possibly non-integer plane value.
/// @param v Value consumed by the operation.
/// @internal
function inline _RP_Abs(v)
  vi = _RP_I(v, 0)
  if vi < 0 then return - vi end if
  return vi
end function

/// Recognizes both array and list containers accepted by plane tables and geometry records.
/// @param v Value consumed by the operation.
/// @internal
function inline _RP_IsSeq(v)
  t = typeof(v)
  return t == "array" or t == "list"
end function

/// Normalizes a coerced angle to Doom's unsigned 32-bit binary-angle domain.
/// @param a First input operand.
/// @internal
function inline _RP_AngNorm(a)
  ai = _RP_I(a, 0)
  return ai & 0xFFFFFFFF
end function

/// Samples a fine-angle lookup table with wraparound and returns zero when the table is unavailable.
/// @param tab Tab value supplied to `_RP_FineAt`.
/// @param idx Zero-based element or table index.
/// @internal
function inline _RP_FineAt(tab, idx)
  if not _RP_IsSeq(tab) or len(tab) == 0 then return 0 end if
  if typeof(idx) != "int" then idx = 0 end if
  if idx < 0 then
    idx = idx % len(tab)
    if idx < 0 then idx = idx + len(tab) end if
  end if
  if idx >= len(tab) then idx = idx % len(tab) end if
  return tab[idx]
end function

/// Caches the first 256-byte colormap for unlit sky columns, falling back to a zeroed map when assets are
/// absent.
/// @internal
function inline _RP_DefaultColorMap()
  global _rp_default_colormap

  if typeof(_rp_default_colormap) == "bytes" and len(_rp_default_colormap) >= 256 then
    return _rp_default_colormap
  end if
  if typeof(colormaps) == "bytes" and len(colormaps) >= 256 then
    _rp_default_colormap = slice(colormaps, 0, 256)
    return _rp_default_colormap
  end if
  if typeof(_rp_default_colormap) != "bytes" then
    _rp_default_colormap = bytes(256, 0)
  end if
  return _rp_default_colormap
end function

/// Returns active world render width.
/// @internal
function inline _RP_TargetWidth()
  if typeof(RH_IsActive) == "function" and RH_IsActive() then return RH_Width() end if
  return SCREENWIDTH
end function

/// Returns active world render height.
/// @internal
function inline _RP_TargetHeight()
  if typeof(RH_IsActive) == "function" and RH_IsActive() then return RH_Height() end if
  return SCREENHEIGHT
end function

/// Constructs an unused visplane with target-width top/bottom arrays and sentinel horizontal bounds.
/// @param height Height of the target in pixels or map units.
/// @param picnum Index identifying pic.
/// @param lightlevel Lightlevel value supplied to `_RP_NewPlane`.
/// @internal
function inline _RP_NewPlane(height, picnum, lightlevel)
  w = _RP_TargetWidth()
  return visplane_t(height, picnum, lightlevel, w, -1, array(w, RP_SPAN_SENTINEL), array(w, 0))
end function

/// Geometrically grows reusable visplane storage up to a hard safety limit and initializes every new slot.
/// @param needIndex Index identifying need.
/// @internal
function _RP_EnsurePlaneCapacity(needIndex)
  global visplanes

  if typeof(needIndex) != "int" or needIndex < 0 then return false end if
  if needIndex < len(visplanes) then return true end if
  if len(visplanes) >= RP_MAXVISPLANES_HARD then return false end if

  target = len(visplanes)
  if target <= 0 then target = MAXVISPLANES end if
  while target <= needIndex
    target = target * 2
    if target > RP_MAXVISPLANES_HARD then
      target = RP_MAXVISPLANES_HARD
      break
    end if
  end while

  if len(visplanes) < target then
    oldLen = len(visplanes)
    visplanes = visplanes + array(target - oldLen)
    i = oldLen
    while i < target
      visplanes[i] = _RP_NewPlane(0, 0, 0)
      i = i + 1
    end while
  end if
  return needIndex < len(visplanes)
end function

/// Recycles a visplane for new height, texture, and light keys while clearing every covered-column marker.
/// @param pl Pl value supplied to `_RP_ResetPlane`.
/// @param height Height of the target in pixels or map units.
/// @param picnum Index identifying pic.
/// @param lightlevel Lightlevel value supplied to `_RP_ResetPlane`.
/// @param minx Minx value supplied to `_RP_ResetPlane`.
/// @param maxx Maxx value supplied to `_RP_ResetPlane`.
/// @internal
function _RP_ResetPlane(pl, height, picnum, lightlevel, minx, maxx)
  if pl is void then return end if

  pl.height = height
  pl.picnum = picnum
  pl.lightlevel = lightlevel
  pl.minx = minx
  pl.maxx = maxx

  w = _RP_TargetWidth()
  if not _RP_IsSeq(pl.top) or len(pl.top) != w then
    pl.top = array(w, RP_SPAN_SENTINEL)
  else
    i = 0
    while i < w
      pl.top[i] = RP_SPAN_SENTINEL
      i = i + 1
    end while
  end if

  if not _RP_IsSeq(pl.bottom) or len(pl.bottom) != w then
    pl.bottom = array(w, 0)
  else
    i = 0
    while i < w
      pl.bottom[i] = 0
      i = i + 1
    end while
  end if
end function

/// Rebuilds row distance slopes and per-column perspective correction factors for the active view geometry.
/// @internal
function _RP_RecomputeSlopeTables()
  global viewheight
  global viewwidth
  global detailshift
  global xtoviewangle
  global finecosine

  if typeof(viewheight) != "int" or viewheight <= 0 then return end if
  if typeof(viewwidth) != "int" or viewwidth <= 0 then return end if

  base = _RP_IDiv((viewwidth << detailshift), 2) * FRACUNIT

  i = 0
  while i < viewheight and i < len(yslope)
    dy =((i - _RP_IDiv(viewheight, 2)) << FRACBITS) + _RP_IDiv(FRACUNIT, 2)
    if dy < 0 then dy = -dy end if
    if dy == 0 then dy = 1 end if
    yslope[i] = FixedDiv(base, dy)
    i = i + 1
  end while

  i = 0
  while i < viewwidth and i < len(distscale)
    a = 0
    if _RP_IsSeq(xtoviewangle) and i < len(xtoviewangle) then
      a = xtoviewangle[i] >> ANGLETOFINESHIFT
    end if
    cosadj = _RP_Abs(_RP_FineAt(finecosine, a))
    if cosadj == 0 then cosadj = 1 end if
    distscale[i] = FixedDiv(FRACUNIT, cosadj)
    i = i + 1
  end while
end function

/// Sizes clipping, slope, span, opening, cache, and visplane workspaces for the active logical or HD render
/// target.
function R_InitPlanes()
  global floorclip
  global ceilingclip
  global yslope
  global distscale
  global openings
  global lastopening
  global spanstart
  global spanstop
  global cachedheight
  global cacheddistance
  global cachedxstep
  global cachedystep
  global visplanes
  global visplanes_last
  global _rp_default_colormap

  targetW = _RP_TargetWidth()
  targetH = _RP_TargetHeight()

  if len(floorclip) != targetW then
    floorclip = array(targetW, 0)
    ceilingclip = array(targetW, 0)
    distscale = array(targetW, 0)
  end if

  if len(yslope) != targetH then
    yslope = array(targetH, 0)
    spanstart = array(targetH, 0)
    spanstop = array(targetH, 0)
    cachedheight = array(targetH, 0)
    cacheddistance = array(targetH, 0)
    cachedxstep = array(targetH, 0)
    cachedystep = array(targetH, 0)
  end if

  if len(openings) < targetW * 64 then
    openings = array(targetW * 64, 0)
  end if

  if len(visplanes) == 0 then
    visplanes = array(MAXVISPLANES)
    i = 0
    while i < MAXVISPLANES
      visplanes[i] = _RP_NewPlane(0, 0, 0)
      i = i + 1
    end while
  end if

  lastopening = 0
  visplanes_last = 0
  _rp_default_colormap = void
end function

/// Resets per-column floor/ceiling clips and visplane allocation, invalidates row caches, and derives
/// view-relative texture scales.
function R_ClearPlanes()
  global visplanes_last
  global lastopening
  global basexscale
  global baseyscale
  global viewwidth
  global viewheight
  global viewangle
  global centerxfrac
  global finecosine
  global finesine

  x = 0
  limit = _RP_TargetWidth()
  if typeof(viewwidth) == "int" and viewwidth > 0 and viewwidth < limit then
    limit = viewwidth
  end if
  while x < limit
    floorclip[x] = viewheight
    ceilingclip[x] = -1
    x = x + 1
  end while

  visplanes_last = 0
  lastopening = 0

  i = 0
  while i < viewheight and i < len(cachedheight)
    cachedheight[i] = 0
    i = i + 1
  end while

  _RP_RecomputeSlopeTables()

  angle = _RP_AngNorm(viewangle - ANG90) >> ANGLETOFINESHIFT
  if centerxfrac != 0 then
    basexscale = FixedDiv(_RP_FineAt(finecosine, angle), centerxfrac)
    baseyscale = -FixedDiv(_RP_FineAt(finesine, angle), centerxfrac)
  else
    basexscale = 0
    baseyscale = 0
  end if
end function

/// Derives perspective distance, texture stepping, origin, and lighting for one horizontal plane span before
/// rasterization.
/// @param y Vertical map- or screen-space coordinate.
/// @param x1 Horizontal coordinate of the first endpoint.
/// @param x2 Horizontal coordinate of the second endpoint.
function R_MapPlane(y, x1, x2)
  global ds_xstep
  global ds_ystep
  global ds_xfrac
  global ds_yfrac
  global ds_colormap
  global ds_y
  global ds_x1
  global ds_x2
  global _rp_prof_mapplane_calls
  global viewheight
  global viewwidth
  global xtoviewangle
  global viewangle
  global viewx
  global viewy
  global fixedcolormap
  global finecosine
  global finesine

  if x2 < x1 then return end if
  if typeof(y) != "int" or y < 0 or y >= viewheight then return end if
  if y >= len(yslope) or y >= len(cachedheight) then return end if
  if x1 < 0 then x1 = 0 end if
  if x2 >= viewwidth then x2 = viewwidth - 1 end if
  if x2 < x1 then return end if
  if x1 >= len(distscale) then return end if

  distance = 0
  if planeheight != cachedheight[y] then
    cachedheight[y] = planeheight
    distance = FixedMul(planeheight, yslope[y])
    cacheddistance[y] = distance
    ds_xstep = FixedMul(distance, basexscale)
    ds_ystep = FixedMul(distance, baseyscale)
    cachedxstep[y] = ds_xstep
    cachedystep[y] = ds_ystep
  else
    distance = cacheddistance[y]
    ds_xstep = cachedxstep[y]
    ds_ystep = cachedystep[y]
  end if

  length = FixedMul(distance, distscale[x1])
  angle = 0
  if _RP_IsSeq(xtoviewangle) and x1 < len(xtoviewangle) then
    angle = _RP_AngNorm(viewangle + xtoviewangle[x1]) >> ANGLETOFINESHIFT
  else
    angle = _RP_AngNorm(viewangle) >> ANGLETOFINESHIFT
  end if

  ds_xfrac = viewx + FixedMul(_RP_FineAt(finecosine, angle), length)
  ds_yfrac = -viewy - FixedMul(_RP_FineAt(finesine, angle), length)

  if typeof(fixedcolormap) == "bytes" then
    ds_colormap = fixedcolormap
  else
    idx = distance >> LIGHTZSHIFT
    if idx < 0 then idx = 0 end if
    if idx >= MAXLIGHTZ then idx = MAXLIGHTZ - 1 end if
    if _RP_IsSeq(planezlight) and idx < len(planezlight) then
      ds_colormap = planezlight[idx]
    else
      ds_colormap = _RP_DefaultColorMap()
    end if
  end if

  ds_y = y
  ds_x1 = x1
  ds_x2 = x2
  _rp_prof_mapplane_calls = _rp_prof_mapplane_calls + 1

  if detailshift != 0 then
    R_DrawSpanLow()
  else
    R_DrawSpan()
  end if
end function

/// Compares adjacent visplane column bounds, closes rows that ended, and records starting columns for newly
/// opened rows.
/// @param x Horizontal map- or screen-space coordinate.
/// @param t1 T1 value supplied to `R_MakeSpans`.
/// @param b1 B1 value supplied to `R_MakeSpans`.
/// @param t2 T2 value supplied to `R_MakeSpans`.
/// @param b2 B2 value supplied to `R_MakeSpans`.
function R_MakeSpans(x, t1, b1, t2, b2)
  while t1 < t2 and t1 <= b1
    if t1 >= 0 and t1 < len(spanstart) then
      R_MapPlane(t1, spanstart[t1], x - 1)
    end if
    t1 = t1 + 1
  end while

  while b1 > b2 and b1 >= t1
    if b1 >= 0 and b1 < len(spanstart) then
      R_MapPlane(b1, spanstart[b1], x - 1)
    end if
    b1 = b1 - 1
  end while

  while t2 < t1 and t2 <= b2
    if t2 >= 0 and t2 < len(spanstart) then spanstart[t2] = x end if
    t2 = t2 + 1
  end while

  while b2 > b1 and b2 >= t2
    if b2 >= 0 and b2 < len(spanstart) then spanstart[b2] = x end if
    b2 = b2 - 1
  end while
end function

/// Rasterizes queued sky visplanes as vertical texture columns and ordinary flats as lit horizontal spans,
/// updating profile counts.
/// @internal
function _RP_DrawVisplanes()
  global dc_iscale
  global dc_colormap
  global dc_texturemid
  global dc_yl
  global dc_yh
  global dc_x
  global dc_source
  global ds_source
  global ds_source_width
  global ds_source_height
  global planeheight
  global planezlight
  global _rp_prof_visplanes_total
  global _rp_prof_visplanes_sky
  global _rp_prof_visplanes_flat
  global viewwidth
  global viewangle
  global xtoviewangle
  global fixedcolormap

  drew = false
  _rp_prof_visplanes_total = 0
  _rp_prof_visplanes_sky = 0
  _rp_prof_visplanes_flat = 0
  i = 0
  while i < visplanes_last and i < len(visplanes)
    pl = visplanes[i]
    i = i + 1
    if pl is void then continue end if
    if pl.minx > pl.maxx then continue end if
    drew = true
    _rp_prof_visplanes_total = _rp_prof_visplanes_total + 1

    if pl.picnum == skyflatnum then
      _rp_prof_visplanes_sky = _rp_prof_visplanes_sky + 1
      dc_iscale = pspriteiscale >> detailshift
      if dc_iscale == 0 then dc_iscale = FRACUNIT end if
      dc_colormap = _RP_DefaultColorMap()
      dc_texturemid = skytexturemid

      x = pl.minx
      if x < 0 then x = 0 end if
      maxx = pl.maxx
      if maxx >= viewwidth then maxx = viewwidth - 1 end if

      while x <= maxx
        if x >= len(pl.top) or x >= len(pl.bottom) then
          x = x + 1
          continue
        end if
        dc_yl = pl.top[x]
        dc_yh = pl.bottom[x]
        if dc_yl <= dc_yh then
          angle = 0
          if _RP_IsSeq(xtoviewangle) and x < len(xtoviewangle) then
            angle = _RP_AngNorm(viewangle + xtoviewangle[x]) >> ANGLETOSKYSHIFT
          end if
          dc_x = x
          dc_source = R_GetColumn(skytexture, angle)
          if detailshift != 0 then
            R_DrawColumnLow()
          else
            R_DrawColumn()
          end if
        end if
        x = x + 1
      end while
      continue
    end if

    _rp_prof_visplanes_flat = _rp_prof_visplanes_flat + 1
    flatnum = pl.picnum
    if _RP_IsSeq(flattranslation) and flatnum >= 0 and flatnum < len(flattranslation) then
      flatnum = flattranslation[flatnum]
    end if
    ds_source_width = 64
    ds_source_height = 64
    flatLump = firstflat + flatnum
    flatEntry = void
    if typeof(RU_GetFlat) == "function" and _RP_IsSeq(lumpinfo) and flatLump >= 0 and flatLump < len(lumpinfo) then
      flatEntry = RU_GetFlat(lumpinfo[flatLump].name)
    end if
    if flatEntry is not void and typeof(flatEntry.data) == "bytes" then
      ds_source = flatEntry.data
      ds_source_width = flatEntry.width
      ds_source_height = flatEntry.height
    else
      ds_source = W_CacheLumpNum(flatLump, PU_STATIC)
    end if
    if typeof(ds_source) != "bytes" then continue end if

    planeheight = _RP_Abs(pl.height - viewz)
    light =(pl.lightlevel >> LIGHTSEGSHIFT) + extralight
    if light >= LIGHTLEVELS then light = LIGHTLEVELS - 1 end if
    if light < 0 then light = 0 end if
    if _RP_IsSeq(zlight) and light < len(zlight) then
      planezlight = zlight[light]
    else
      planezlight =[]
    end if

    left = pl.minx
    right = pl.maxx
    if left < 0 then left = 0 end if
    if right >= viewwidth then right = viewwidth - 1 end if
    if left > right then
      continue
    end if

    stop = right + 1
    x = left
    while x <= stop
      t1 = RP_SPAN_SENTINEL
      b1 = 0
      t2 = RP_SPAN_SENTINEL
      b2 = 0

      if x != left and(x - 1) >= 0 and(x - 1) < len(pl.top) then
        t1 = pl.top[x - 1]
        b1 = pl.bottom[x - 1]
      end if
      if x != stop and x >= 0 and x < len(pl.top) then
        t2 = pl.top[x]
        b2 = pl.bottom[x]
      end if
      R_MakeSpans(x, t1, b1, t2, b2)
      x = x + 1
    end while

  end while
  return drew
end function

/// Executes the queued visplane rasterization pass after wall clipping has finalized visible column bounds.
function R_DrawPlanes()
  _RP_DrawVisplanes()
end function

/// Reuses a visplane with matching height, texture, and light keys or allocates a cleared entry for a new
/// region.
/// @param height Height of the target in pixels or map units.
/// @param picnum Index identifying pic.
/// @param lightlevel Lightlevel value supplied to `R_FindPlane`.
function R_FindPlane(height, picnum, lightlevel)
  global visplanes
  global visplanes_last

  if picnum == skyflatnum then
    height = 0
    lightlevel = 0
  end if

  i = 0
  while i < visplanes_last and i < len(visplanes)
    check = visplanes[i]
    if check.height == height and check.picnum == picnum and check.lightlevel == lightlevel then
      return check
    end if
    i = i + 1
  end while

  if not _RP_EnsurePlaneCapacity(visplanes_last) then
    I_Error("R_FindPlane: no more visplanes")
    return void
  end if

  pl = visplanes[visplanes_last]
  _RP_ResetPlane(pl, height, picnum, lightlevel, _RP_TargetWidth(), -1)
  visplanes_last = visplanes_last + 1
  return pl
end function

/// Extends a visplane across unused columns or splits it into a duplicate when the requested range overlaps
/// existing spans.
/// @param pl Pl value supplied to `R_CheckPlane`.
/// @param start Start value supplied to `R_CheckPlane`.
/// @param stop Stop value supplied to `R_CheckPlane`.
function R_CheckPlane(pl, start, stop)
  global visplanes
  global visplanes_last

  if pl is void then return void end if

  intrl = 0
  intrh = 0
  unionl = 0
  unionh = 0

  if start < pl.minx then
    intrl = pl.minx
    unionl = start
  else
    unionl = pl.minx
    intrl = start
  end if

  if stop > pl.maxx then
    intrh = pl.maxx
    unionh = stop
  else
    unionh = pl.maxx
    intrh = stop
  end if

  x = intrl
  while x <= intrh
    if x >= 0 and x < len(pl.top) and pl.top[x] != RP_SPAN_SENTINEL then break end if
    x = x + 1
  end while

  if x > intrh then
    pl.minx = unionl
    pl.maxx = unionh
    return pl
  end if

  if not _RP_EnsurePlaneCapacity(visplanes_last) then
    I_Error("R_CheckPlane: no more visplanes")
    return pl
  end if

  npl = visplanes[visplanes_last]
  _RP_ResetPlane(npl, pl.height, pl.picnum, pl.lightlevel, start, stop)
  visplanes_last = visplanes_last + 1
  return npl
end function



