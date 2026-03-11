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

  Script: r_plane.ml
  Purpose: Implements renderer data preparation and software rendering pipeline stages.
*/
import r_data
import i_system
import z_zone
import w_wad
import doomdef
import doomstat
import r_local
import r_sky
import r_main
import std.math

lastopening = void

floorfunc = void
ceilingfunc_t = void

floorclip =[]
ceilingclip =[]

yslope =[]
distscale =[]

const MAXVISPLANES = 128
const MAXOPENINGS = SCREENWIDTH * 64
const RP_MAXVISPLANES_HARD = 4096

openings =[]
visplanes =[]
visplanes_last = 0
_rp_default_colormap = void

planezlight = void
planeheight = 0
basexscale = 0
baseyscale = 0

floorplane = void
ceilingplane = void

spanstart =[]
spanstop =[]
cachedheight =[]
cacheddistance =[]
cachedxstep =[]
cachedystep =[]
_rp_prof_visplanes_total = 0
_rp_prof_visplanes_sky = 0
_rp_prof_visplanes_flat = 0
_rp_prof_mapplane_calls = 0

/*
* Function: _RP_IDiv
* Purpose: Implements the _RP_IDiv routine for the internal module support.
*/
function inline _RP_IDiv(a, b)
  if typeof(a) != "int" or typeof(b) != "int" or b == 0 then return 0 end if
  q = a / b
  if q >= 0 then return std.math.floor(q) end if
  return std.math.ceil(q)
end function

/*
* Function: _RP_I
* Purpose: Implements the _RP_I routine for the internal module support.
*/
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

/*
* Function: _RP_Abs
* Purpose: Implements the _RP_Abs routine for the internal module support.
*/
function inline _RP_Abs(v)
  vi = _RP_I(v, 0)
  if vi < 0 then return - vi end if
  return vi
end function

/*
* Function: _RP_IsSeq
* Purpose: Implements the _RP_IsSeq routine for the internal module support.
*/
function inline _RP_IsSeq(v)
  t = typeof(v)
  return t == "array" or t == "list"
end function

/*
* Function: _RP_AngNorm
* Purpose: Implements the _RP_AngNorm routine for the internal module support.
*/
function inline _RP_AngNorm(a)
  ai = _RP_I(a, 0)
  return ai & 0xFFFFFFFF
end function

/*
* Function: _RP_FineAt
* Purpose: Implements the _RP_FineAt routine for the internal module support.
*/
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

/*
* Function: _RP_DefaultColorMap
* Purpose: Implements the _RP_DefaultColorMap routine for the internal module support.
*/
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

/*
* Function: _RP_NewPlane
* Purpose: Implements the _RP_NewPlane routine for the internal module support.
*/
function inline _RP_NewPlane(height, picnum, lightlevel)
  return visplane_t(height, picnum, lightlevel, SCREENWIDTH, -1, bytes(SCREENWIDTH, 255), bytes(SCREENWIDTH, 0))
end function

/*
* Function: _RP_EnsurePlaneCapacity
* Purpose: Implements the _RP_EnsurePlaneCapacity routine for the internal module support.
*/
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

  while len(visplanes) < target
    visplanes = visplanes +[_RP_NewPlane(0, 0, 0)]
  end while
  return needIndex < len(visplanes)
end function

/*
* Function: _RP_ResetPlane
* Purpose: Reads or updates state used by the internal module support.
*/
function _RP_ResetPlane(pl, height, picnum, lightlevel, minx, maxx)
  if pl is void then return end if

  pl.height = height
  pl.picnum = picnum
  pl.lightlevel = lightlevel
  pl.minx = minx
  pl.maxx = maxx

  if typeof(pl.top) != "bytes" or len(pl.top) != SCREENWIDTH then
    pl.top = bytes(SCREENWIDTH, 255)
  else
    x = 0
    while x < SCREENWIDTH
      pl.top[x] = 255
      x = x + 1
    end while
  end if

  if typeof(pl.bottom) != "bytes" or len(pl.bottom) != SCREENWIDTH then
    pl.bottom = bytes(SCREENWIDTH, 0)
  else
    x = 0
    while x < SCREENWIDTH
      pl.bottom[x] = 0
      x = x + 1
    end while
  end if
end function

/*
* Function: _RP_RecomputeSlopeTables
* Purpose: Implements the _RP_RecomputeSlopeTables routine for the internal module support.
*/
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

/*
* Function: R_InitPlanes
* Purpose: Initializes state and dependencies for the renderer.
*/
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

  if len(floorclip) == 0 then
    i = 0
    while i < SCREENWIDTH
      floorclip = floorclip +[0]
      ceilingclip = ceilingclip +[0]
      distscale = distscale +[0]
      i = i + 1
    end while
  end if

  if len(yslope) == 0 then
    i = 0
    while i < SCREENHEIGHT
      yslope = yslope +[0]
      spanstart = spanstart +[0]
      spanstop = spanstop +[0]
      cachedheight = cachedheight +[0]
      cacheddistance = cacheddistance +[0]
      cachedxstep = cachedxstep +[0]
      cachedystep = cachedystep +[0]
      i = i + 1
    end while
  end if

  if len(openings) == 0 then
    i = 0
    while i < MAXOPENINGS
      openings = openings +[0]
      i = i + 1
    end while
  end if

  if len(visplanes) == 0 then
    i = 0
    while i < MAXVISPLANES
      visplanes = visplanes +[_RP_NewPlane(0, 0, 0)]
      i = i + 1
    end while
  end if

  lastopening = 0
  visplanes_last = 0
  _rp_default_colormap = void
end function

/*
* Function: R_ClearPlanes
* Purpose: Implements the R_ClearPlanes routine for the renderer.
*/
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
  limit = SCREENWIDTH
  if typeof(viewwidth) == "int" and viewwidth > 0 and viewwidth < SCREENWIDTH then
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

/*
* Function: R_MapPlane
* Purpose: Implements the R_MapPlane routine for the renderer.
*/
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

/*
* Function: R_MakeSpans
* Purpose: Implements the R_MakeSpans routine for the renderer.
*/
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

/*
* Function: _RP_DrawVisplanes
* Purpose: Draws or renders output for the internal module support.
*/
function _RP_DrawVisplanes()
  global dc_iscale
  global dc_colormap
  global dc_texturemid
  global dc_yl
  global dc_yh
  global dc_x
  global dc_source
  global ds_source
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
    ds_source = W_CacheLumpNum(firstflat + flatnum, PU_STATIC)
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
      t1 = 255
      b1 = 0
      t2 = 255
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

/*
* Function: R_DrawPlanes
* Purpose: Draws or renders output for the renderer.
*/
function R_DrawPlanes()
  _RP_DrawVisplanes()
end function

/*
* Function: R_FindPlane
* Purpose: Implements the R_FindPlane routine for the renderer.
*/
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
  _RP_ResetPlane(pl, height, picnum, lightlevel, SCREENWIDTH, -1)
  visplanes_last = visplanes_last + 1
  return pl
end function

/*
* Function: R_CheckPlane
* Purpose: Evaluates conditions and returns a decision for the renderer.
*/
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
    if x >= 0 and x < len(pl.top) and pl.top[x] != 255 then break end if
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



