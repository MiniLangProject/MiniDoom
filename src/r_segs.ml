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

  Script: r_segs.ml
  Purpose: Implements renderer data preparation and software rendering pipeline stages.
*/
import i_system
import doomdef
import doomstat
import r_local
import r_sky
import std.math

walllights = void

maskedtexturecol = void

maskedtexture = false
toptexture = 0
bottomtexture = 0
midtexture = 0

rw_centerangle = 0
rw_offset = 0
rw_scale = 0
rw_scalestep = 0
rw_midtexturemid = 0
rw_toptexturemid = 0
rw_bottomtexturemid = 0

worldtop = 0
worldbottom = 0
worldhigh = 0
worldlow = 0

pixhigh = 0
pixlow = 0
pixhighstep = 0
pixlowstep = 0

topfrac = 0
topstep = 0
bottomfrac = 0
bottomstep = 0

const HEIGHTBITS = 12
const HEIGHTUNIT = 1 << HEIGHTBITS
const RS_INV_SCALE_NUM = 4294967295

rw_solidwall = false

/*
* Function: _RS_IDiv
* Purpose: Implements the _RS_IDiv routine for the internal module support.
*/
function inline _RS_IDiv(a, b)
  if typeof(a) != "int" or typeof(b) != "int" or b == 0 then return 0 end if
  q = a / b
  if q >= 0 then return std.math.floor(q) end if
  return std.math.ceil(q)
end function

/*
* Function: _RS_ToInt
* Purpose: Implements the _RS_ToInt routine for the internal module support.
*/
function inline _RS_ToInt(v, fallback)
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
* Function: _RS_Clamp
* Purpose: Implements the _RS_Clamp routine for the internal module support.
*/
function inline _RS_Clamp(v, lo, hi)
  if v < lo then return lo end if
  if v > hi then return hi end if
  return v
end function

/*
* Function: _RS_Abs
* Purpose: Implements the _RS_Abs routine for the internal module support.
*/
function inline _RS_Abs(v)
  vi = _RS_ToInt(v, 0)
  if vi < 0 then return - vi end if
  return vi
end function

/*
* Function: _RS_WrapIndex
* Purpose: Implements the _RS_WrapIndex routine for the internal module support.
*/
function inline _RS_WrapIndex(i, n)
  if typeof(i) != "int" then i = 0 end if
  if typeof(n) != "int" or n <= 0 then return 0 end if
  if i < 0 then
    i = i % n
    if i < 0 then i = i + n end if
  end if
  if i >= n then i = i % n end if
  return i
end function

/*
* Function: _RS_ClampIndex
* Purpose: Implements the _RS_ClampIndex routine for the internal module support.
*/
function inline _RS_ClampIndex(i, n)
  if typeof(i) != "int" then i = 0 end if
  if typeof(n) != "int" or n <= 0 then return 0 end if
  if i < 0 then return 0 end if
  if i >= n then return n - 1 end if
  return i
end function

/*
* Function: _RS_IsSeq
* Purpose: Implements the _RS_IsSeq routine for the internal module support.
*/
function inline _RS_IsSeq(v)
  t = typeof(v)
  return t == "array" or t == "list"
end function

/*
* Function: _RS_AllocIntList
* Purpose: Implements the _RS_AllocIntList routine for the internal module support.
*/
function inline _RS_AllocIntList(n, fill)
  lst =[]
  i = 0
  while i < n
    lst = lst +[fill]
    i = i + 1
  end while
  return lst
end function

/*
* Function: _RS_EnsureOpeningsCapacity
* Purpose: Implements the _RS_EnsureOpeningsCapacity routine for the internal module support.
*/
function _RS_EnsureOpeningsCapacity(needed)
  global openings

  if typeof(needed) != "int" or needed < 0 then return false end if
  if not _RS_IsSeq(openings) then openings =[] end if
  if needed <= len(openings) then return true end if

  cap = len(openings)
  if cap <= 0 then cap = MAXOPENINGS end if
  if cap <= 0 then cap = SCREENWIDTH * 64 end if
  if cap <= 0 then cap = 4096 end if

  while cap < needed
    cap = cap * 2
    if cap <= 0 then return false end if
  end while

  grow = cap - len(openings)
  if grow > 0 then
    openings = openings + _RS_AllocIntList(grow, 0)
  end if
  return needed <= len(openings)
end function

/*
* Function: R_ClearSolidClipScales
* Purpose: Implements the R_ClearSolidClipScales routine for the renderer.
*/
function R_ClearSolidClipScales()

end function

/*
* Function: _RS_AngNorm
* Purpose: Implements the _RS_AngNorm routine for the internal module support.
*/
function inline _RS_AngNorm(a)
  ai = _RS_ToInt(a, 0)
  return ai & 0xFFFFFFFF
end function

/*
* Function: _RS_AngSub
* Purpose: Implements the _RS_AngSub routine for the internal module support.
*/
function inline _RS_AngSub(a, b)
  return _RS_AngNorm(_RS_AngNorm(a) - _RS_AngNorm(b))
end function

/*
* Function: _RS_ResolveTexture
* Purpose: Implements the _RS_ResolveTexture routine for the internal module support.
*/
function inline _RS_ResolveTexture(texId)
  t = texId
  if typeof(t) != "int" or t <= 0 then return 0 end if
  if _RS_IsSeq(texturetranslation) and t < len(texturetranslation) then
    t = texturetranslation[t]
  end if
  if typeof(t) != "int" or t < 0 then return 0 end if
  if _RS_IsSeq(textures) and t >= len(textures) then return 0 end if
  return t
end function

/*
* Function: _RS_SelectWallLights
* Purpose: Implements the _RS_SelectWallLights routine for the internal module support.
*/
function _RS_SelectWallLights(line, sec)
  global walllights

  if typeof(fixedcolormap) == "bytes" then
    walllights = scalelightfixed
    return
  end if

  lightnum = 0
  if sec is not void and typeof(sec.lightlevel) == "int" then
    lightnum =(sec.lightlevel >> LIGHTSEGSHIFT) + extralight
  end if

  if line is not void and line.v1 is not void and line.v2 is not void then
    if line.v1.y == line.v2.y then
      lightnum = lightnum - 1
    else if line.v1.x == line.v2.x then
      lightnum = lightnum + 1
    end if
  end if

  if not _RS_IsSeq(scalelight) or len(scalelight) == 0 then
    walllights =[]
    return
  end if

  if lightnum < 0 then
    walllights = scalelight[0]
  else if lightnum >= len(scalelight) then
    walllights = scalelight[len(scalelight) - 1]
  else
    walllights = scalelight[lightnum]
  end if
end function

/*
* Function: _RS_GetClipValue
* Purpose: Reads or updates state used by the internal module support.
*/
function inline _RS_GetClipValue(clipref, x, fallback)
  if typeof(x) != "int" or x < 0 then return fallback end if
  if _RS_IsSeq(clipref) then
    if x < len(clipref) then return clipref[x] end if
    return fallback
  end if
  if typeof(clipref) == "int" and _RS_IsSeq(openings) then
    idx = clipref + x
    if idx >= 0 and idx < len(openings) then return openings[idx] end if
  end if
  return fallback
end function

/*
* Function: _RS_SetClipValue
* Purpose: Reads or updates state used by the internal module support.
*/
function inline _RS_SetClipValue(clipref, x, value)
  if typeof(x) != "int" or x < 0 then return end if
  if _RS_IsSeq(clipref) then
    if x < len(clipref) then clipref[x] = value end if
    return
  end if
  if typeof(clipref) == "int" and _RS_IsSeq(openings) then
    idx = clipref + x
    if idx >= 0 and idx < len(openings) then openings[idx] = value end if
  end if
end function

/*
* Function: _RS_CopyClipToOpenings
* Purpose: Implements the _RS_CopyClipToOpenings routine for the internal module support.
*/
function _RS_CopyClipToOpenings(src, start, stop, fallback)
  global lastopening

  if typeof(start) != "int" or typeof(stop) != "int" then return void end if
  if stop < start then return void end if
  if not _RS_IsSeq(openings) then return void end if
  if typeof(lastopening) != "int" then lastopening = 0 end if

  count = stop - start + 1
  if count <= 0 then return void end if
  if not _RS_EnsureOpeningsCapacity(lastopening + count) then return void end if

  base = lastopening
  i = 0
  while i < count
    x = start + i
    v = fallback
    if _RS_IsSeq(src) and x >= 0 and x < len(src) then v = src[x] end if
    openings[base + i] = v
    i = i + 1
  end while
  lastopening = lastopening + count
  return base - start
end function

/*
* Function: _RS_AllocMaskedCols
* Purpose: Implements the _RS_AllocMaskedCols routine for the internal module support.
*/
function _RS_AllocMaskedCols(start, stop)
  global lastopening

  if typeof(start) != "int" or typeof(stop) != "int" then return void end if
  if stop < start then return void end if
  if not _RS_IsSeq(openings) then return void end if
  if typeof(lastopening) != "int" then lastopening = 0 end if

  count = stop - start + 1
  if count <= 0 then return void end if
  if not _RS_EnsureOpeningsCapacity(lastopening + count) then return void end if

  base = lastopening
  i = 0
  while i < count
    openings[base + i] = MAXSHORT
    i = i + 1
  end while
  lastopening = lastopening + count
  return base - start
end function

/*
* Function: _RS_ReadMaskedCol
* Purpose: Implements the _RS_ReadMaskedCol routine for the internal module support.
*/
function inline _RS_ReadMaskedCol(maskref, x)
  if typeof(x) != "int" or x < 0 then return MAXSHORT end if
  if _RS_IsSeq(maskref) then
    if x < len(maskref) then return maskref[x] end if
    return MAXSHORT
  end if
  if typeof(maskref) == "int" and _RS_IsSeq(openings) then
    idx = maskref + x
    if idx >= 0 and idx < len(openings) then return openings[idx] end if
  end if
  return MAXSHORT
end function

/*
* Function: _RS_WriteMaskedCol
* Purpose: Implements the _RS_WriteMaskedCol routine for the internal module support.
*/
function inline _RS_WriteMaskedCol(maskref, x, value)
  if typeof(x) != "int" or x < 0 then return end if
  if _RS_IsSeq(maskref) then
    if x < len(maskref) then maskref[x] = value end if
    return
  end if
  if typeof(maskref) == "int" and _RS_IsSeq(openings) then
    idx = maskref + x
    if idx >= 0 and idx < len(openings) then openings[idx] = value end if
  end if
end function

/*
* Function: _RS_DrawTexturedRange
* Purpose: Draws or renders output for the internal module support.
*/
function _RS_DrawTexturedRange(fb, x, y1, y2, texnum, texCol, cmap)
  if y2 < y1 then return end if
  if typeof(fb) != "bytes" then return end if
  col = R_GetColumn(texnum, texCol)
  if typeof(col) != "bytes" or len(col) <= 0 then return end if
  if typeof(cmap) != "bytes" or len(cmap) < 256 then return end if

  segH = y2 - y1 + 1
  if segH <= 0 then return end if
  texH = len(col)
  y = y1
  while y <= y2
    ti = _RS_IDiv((y - y1) * texH, segH)
    if ti < 0 then ti = 0 end if
    if ti >= texH then ti = texH - 1 end if
    v = col[ti]
    fb[y * SCREENWIDTH + x] = cmap[v]
    y = y + 1
  end while
end function

/*
* Function: _RS_DrawMaskedTextureColumn
* Purpose: Draws or renders output for the internal module support.
*/
function _RS_DrawMaskedTextureColumn(x, texnum, texturecolumn, texturemid, yscale, topclip, bottomclip)
  global colfunc
  global dc_colormap
  global dc_yl
  global dc_yh
  global dc_source
  global dc_sourcebase
  global dc_sourceoff
  global dc_sourcelen
  global dc_sourceclamp
  global dc_texturemid
  global dc_iscale
  global dc_x

  if typeof(yscale) != "int" or yscale <= 0 then yscale = FRACUNIT end if

  if typeof(dc_colormap) != "bytes" or len(dc_colormap) < 256 then
    if typeof(colormaps) == "bytes" and len(colormaps) >= 256 then
      dc_colormap = slice(colormaps, 0, 256)
    else
      return
    end if
  end if

  raw = void
  if typeof(R_GetMaskedColumnRaw) == "function" then
    raw = R_GetMaskedColumnRaw(texnum, texturecolumn)
  end if

  if _RS_IsSeq(raw) and len(raw) >= 2 and typeof(raw[0]) == "bytes" and typeof(raw[1]) == "int" then
    patchBytes = raw[0]
    off = raw[1]
    basetexturemid = texturemid
    oldSource = dc_source
    oldSourceBase = dc_sourcebase
    oldSourceOff = dc_sourceoff
    oldSourceLen = dc_sourcelen
    oldSourceClamp = dc_sourceclamp
    dc_source = patchBytes
    dc_sourcebase = patchBytes
    dc_sourceclamp = true
    sprtopscreen = centeryfrac - FixedMul(texturemid, yscale)
    dc_iscale = _RS_IDiv(RS_INV_SCALE_NUM, yscale)
    if dc_iscale <= 0 then dc_iscale = FRACUNIT end if

    while off >= 0 and off < len(patchBytes)
      topdelta = patchBytes[off]
      if topdelta == 255 then break end if
      if off + 3 >= len(patchBytes) then break end if

      run = patchBytes[off + 1]
      if run <= 0 then
        off = off + 4
        continue
      end if
      if off + 3 + run > len(patchBytes) then break end if

      topscreen = sprtopscreen + yscale * topdelta
      bottomscreen = topscreen + yscale * run

      y1 =(topscreen + FRACUNIT - 1) >> FRACBITS
      y2 =(bottomscreen - 1) >> FRACBITS

      bclip = _RS_GetClipValue(bottomclip, x, viewheight)
      if y2 >= bclip then y2 = bclip - 1 end if
      tclip = _RS_GetClipValue(topclip, x, -1)
      if y1 <= tclip then y1 = tclip + 1 end if

      y1 = _RS_Clamp(y1, 0, SCREENHEIGHT - 1)
      y2 = _RS_Clamp(y2, 0, SCREENHEIGHT - 1)

      if y2 >= y1 then
        dc_x = x
        dc_yl = y1
        dc_yh = y2
        dc_sourceoff = off + 3
        dc_sourcelen = run
        dc_texturemid = basetexturemid -(topdelta << FRACBITS)
        R_DepthBeginWall(yscale)
        if typeof(colfunc) == "function" then
          colfunc()
        else
          R_DrawColumn()
        end if
        R_DepthEndWall()
      end if

      off = off + run + 4
    end while

    dc_texturemid = basetexturemid
    dc_source = oldSource
    dc_sourcebase = oldSourceBase
    dc_sourceoff = oldSourceOff
    dc_sourcelen = oldSourceLen
    dc_sourceclamp = oldSourceClamp
    return
  end if

  return
end function

/*
* Function: R_RenderMaskedSegRange
* Purpose: Draws or renders output for the renderer.
*/
function R_RenderMaskedSegRange(ds, x1, x2)
  global curline
  global frontsector
  global backsector
  global maskedtexturecol
  global rw_scalestep
  global spryscale
  global mfloorclip
  global mceilingclip
  global dc_texturemid
  global dc_colormap
  global dc_x

  if ds is void or ds.curline is void or ds.curline.sidedef is void then return end if
  if x2 < x1 then return end if

  curline = ds.curline
  frontsector = curline.frontsector
  backsector = curline.backsector
  if frontsector is void or backsector is void then return end if

  texnum = _RS_ResolveTexture(curline.sidedef.midtexture)
  if texnum == 0 then return end if

  _RS_SelectWallLights(curline, frontsector)
  maskedtexturecol = ds.maskedtexturecol
  if typeof(maskedtexturecol) != "int" and(not _RS_IsSeq(maskedtexturecol) or len(maskedtexturecol) == 0) then
    return
  end if

  if x1 < ds.x1 then x1 = ds.x1 end if
  if x2 > ds.x2 then x2 = ds.x2 end if
  if x2 < x1 then return end if

  rw_scalestep = ds.scalestep
  spryscale = ds.scale1 +(x1 - ds.x1) * rw_scalestep
  mfloorclip = ds.sprbottomclip
  mceilingclip = ds.sprtopclip

  if curline.linedef is not void and(curline.linedef.flags & ML_DONTPEGBOTTOM) != 0 then
    dc_texturemid = frontsector.floorheight
    if backsector.floorheight > dc_texturemid then dc_texturemid = backsector.floorheight end if
    if typeof(textureheight) == "array" and texnum >= 0 and texnum < len(textureheight) then
      dc_texturemid = dc_texturemid + textureheight[texnum] - viewz
    else
      dc_texturemid = dc_texturemid - viewz
    end if
  else
    dc_texturemid = frontsector.ceilingheight
    if backsector.ceilingheight < dc_texturemid then dc_texturemid = backsector.ceilingheight end if
    dc_texturemid = dc_texturemid - viewz
  end if
  dc_texturemid = dc_texturemid + curline.sidedef.rowoffset

  if typeof(fixedcolormap) == "bytes" then
    dc_colormap = fixedcolormap
  end if

  dc_x = x1
  while dc_x <= x2
    texcol = _RS_ReadMaskedCol(maskedtexturecol, dc_x)
    if texcol != MAXSHORT then
      if typeof(fixedcolormap) != "bytes" then
        index = spryscale >> LIGHTSCALESHIFT
        if index < 0 then index = 0 end if
        if _RS_IsSeq(walllights) and len(walllights) > 0 then
          if index >= len(walllights) then index = len(walllights) - 1 end if
          dc_colormap = walllights[index]
        end if
      end if

      _RS_DrawMaskedTextureColumn(dc_x, texnum, texcol, dc_texturemid, spryscale, mceilingclip, mfloorclip)
      _RS_WriteMaskedCol(maskedtexturecol, dc_x, MAXSHORT)
    end if
    spryscale = spryscale + rw_scalestep
    dc_x = dc_x + 1
  end while
end function

/*
* Function: R_RenderSegLoop
* Purpose: Draws or renders output for the renderer.
*/
function R_RenderSegLoop()
  global rw_x
  global rw_scale
  global topfrac
  global bottomfrac
  global pixhigh
  global pixlow
  global dc_colormap
  global dc_x
  global dc_iscale
  global dc_yl
  global dc_yh
  global dc_texturemid
  global dc_source

  if rw_stopx <= rw_x then return end if

  while rw_x < rw_stopx
    yl =(topfrac + HEIGHTUNIT - 1) >> HEIGHTBITS
    if _RS_IsSeq(ceilingclip) and rw_x < len(ceilingclip) and yl <(ceilingclip[rw_x] + 1) then
      yl = ceilingclip[rw_x] + 1
    end if

    if markceiling and ceilingplane is not void and rw_x >= 0 and rw_x < len(ceilingplane.top) then
      top = ceilingclip[rw_x] + 1
      bottom = yl - 1
      if bottom >= floorclip[rw_x] then bottom = floorclip[rw_x] - 1 end if
      if top <= bottom then
        ceilingplane.top[rw_x] = top
        ceilingplane.bottom[rw_x] = bottom
      end if
    end if

    yh = bottomfrac >> HEIGHTBITS
    if _RS_IsSeq(floorclip) and rw_x < len(floorclip) and yh >= floorclip[rw_x] then
      yh = floorclip[rw_x] - 1
    end if

    if markfloor and floorplane is not void and rw_x >= 0 and rw_x < len(floorplane.top) then
      top = yh + 1
      bottom = floorclip[rw_x] - 1
      if top <= ceilingclip[rw_x] then top = ceilingclip[rw_x] + 1 end if
      if top <= bottom then
        floorplane.top[rw_x] = top
        floorplane.bottom[rw_x] = bottom
      end if
    end if

    texturecolumn = 0
    if segtextured then
      angle = _RS_AngNorm(rw_centerangle + xtoviewangle[rw_x]) >> ANGLETOFINESHIFT
      if _RS_IsSeq(finetangent) and len(finetangent) > 0 then

        angle = _RS_WrapIndex(angle, len(finetangent))
        texturecolumn = rw_offset - FixedMul(finetangent[angle], rw_distance)
        texturecolumn = texturecolumn >> FRACBITS
      end if

      index = rw_scale >> LIGHTSCALESHIFT
      if index < 0 then index = 0 end if
      if _RS_IsSeq(walllights) and len(walllights) > 0 then
        if index >= len(walllights) then index = len(walllights) - 1 end if
        dc_colormap = walllights[index]
      else if typeof(colormaps) == "bytes" and len(colormaps) >= 256 then
        dc_colormap = slice(colormaps, 0, 256)
      end if

      dc_x = rw_x
      if rw_scale != 0 then
        dc_iscale = _RS_IDiv(RS_INV_SCALE_NUM, rw_scale)
      else
        dc_iscale = FRACUNIT
      end if
    end if

    if midtexture != 0 then
      dc_yl = yl
      dc_yh = yh
      dc_texturemid = rw_midtexturemid
      dc_source = R_GetColumn(midtexture, texturecolumn)
      if typeof(dc_source) == "bytes" then
        R_DepthBeginWall(rw_scale)
        colfunc()
        R_DepthEndWall()
      end if
      ceilingclip[rw_x] = viewheight
      floorclip[rw_x] = -1
    else
      if toptexture != 0 then
        mid = pixhigh >> HEIGHTBITS
        pixhigh = pixhigh + pixhighstep

        if mid >= floorclip[rw_x] then mid = floorclip[rw_x] - 1 end if
        if mid >= yl then
          dc_yl = yl
          dc_yh = mid
          dc_texturemid = rw_toptexturemid
          dc_source = R_GetColumn(toptexture, texturecolumn)
          if typeof(dc_source) == "bytes" then
            R_DepthBeginWall(rw_scale)
            colfunc()
            R_DepthEndWall()
          end if
          ceilingclip[rw_x] = mid
        else
          ceilingclip[rw_x] = yl - 1
        end if
      else
        if markceiling then ceilingclip[rw_x] = yl - 1 end if
      end if

      if bottomtexture != 0 then
        mid =(pixlow + HEIGHTUNIT - 1) >> HEIGHTBITS
        pixlow = pixlow + pixlowstep

        if mid <= ceilingclip[rw_x] then mid = ceilingclip[rw_x] + 1 end if
        if mid <= yh then
          dc_yl = mid
          dc_yh = yh
          dc_texturemid = rw_bottomtexturemid
          dc_source = R_GetColumn(bottomtexture, texturecolumn)
          if typeof(dc_source) == "bytes" then
            R_DepthBeginWall(rw_scale)
            colfunc()
            R_DepthEndWall()
          end if
          floorclip[rw_x] = mid
        else
          floorclip[rw_x] = yh + 1
        end if
      else
        if markfloor then floorclip[rw_x] = yh + 1 end if
      end if

      if maskedtexture then
        _RS_WriteMaskedCol(maskedtexturecol, rw_x, texturecolumn)
      end if
    end if

    rw_scale = rw_scale + rw_scalestep
    topfrac = topfrac + topstep
    bottomfrac = bottomfrac + bottomstep
    rw_x = rw_x + 1
  end while
end function

/*
* Function: R_StoreWallRange
* Purpose: Implements the R_StoreWallRange routine for the renderer.
*/
function R_StoreWallRange(start, stop)
  global sidedef
  global linedef
  global rw_x
  global rw_stopx
  global rw_distance
  global rw_normalangle
  global rw_angle1
  global rw_centerangle
  global rw_offset
  global rw_scale
  global rw_scalestep
  global rw_midtexturemid
  global rw_toptexturemid
  global rw_bottomtexturemid
  global rw_solidwall
  global worldtop
  global worldbottom
  global worldhigh
  global worldlow
  global pixhigh
  global pixlow
  global pixhighstep
  global pixlowstep
  global topfrac
  global topstep
  global bottomfrac
  global bottomstep
  global segtextured
  global markfloor
  global markceiling
  global maskedtexture
  global midtexture
  global toptexture
  global bottomtexture
  global maskedtexturecol
  global ds_p
  global drawsegs
  global ceilingplane
  global floorplane

  if ds_p >= len(drawsegs) then return end if
  if start >= viewwidth or start > stop then return end if
  if curline is void or curline.v1 is void or curline.sidedef is void then return end if

  vtop = 0

  sidedef = curline.sidedef
  linedef = curline.linedef

  if linedef is not void and typeof(linedef.flags) == "int" then
    linedef.flags = linedef.flags | ML_MAPPED
  end if

  rw_normalangle = _RS_AngNorm(curline.angle + ANG90)
  offsetangle = _RS_AngSub(rw_normalangle, rw_angle1)
  if offsetangle > ANG180 then
    offsetangle = _RS_AngNorm(-offsetangle)
  end if
  if offsetangle > ANG90 then offsetangle = ANG90 end if

  distangle = ANG90 - offsetangle
  hyp = R_PointToDist(curline.v1.x, curline.v1.y)
  sineval = _R_FineSineAt(distangle)
  rw_distance = FixedMul(hyp, sineval)

  ds = drawsegs[ds_p]
  ds.x1 = start
  ds.x2 = stop
  ds.curline = curline
  rw_x = start
  rw_stopx = stop + 1

  rw_scale = R_ScaleFromGlobalAngle(viewangle + xtoviewangle[start])
  ds.scale1 = rw_scale
  if stop > start then
    ds.scale2 = R_ScaleFromGlobalAngle(viewangle + xtoviewangle[stop])
    rw_scalestep = _RS_IDiv(ds.scale2 - rw_scale, stop - start)
    ds.scalestep = rw_scalestep
  else
    ds.scale2 = ds.scale1
    rw_scalestep = 0
    ds.scalestep = 0
  end if

  worldtop = frontsector.ceilingheight - viewz
  worldbottom = frontsector.floorheight - viewz

  midtexture = 0
  toptexture = 0
  bottomtexture = 0
  maskedtexture = false
  rw_solidwall = false
  maskedtexturecol = void
  ds.maskedtexturecol = void

  if backsector is void then
    rw_solidwall = true
    midtexture = _RS_ResolveTexture(sidedef.midtexture)
    markfloor = true
    markceiling = true

    if linedef is not void and(linedef.flags & ML_DONTPEGBOTTOM) != 0 then
      if typeof(textureheight) == "array" and midtexture >= 0 and midtexture < len(textureheight) then
        vtop = frontsector.floorheight + textureheight[midtexture]
      else
        vtop = frontsector.floorheight
      end if
      rw_midtexturemid = vtop - viewz
    else
      rw_midtexturemid = worldtop
    end if
    rw_midtexturemid = rw_midtexturemid + sidedef.rowoffset

    ds.silhouette = SIL_BOTH
    ds.sprtopclip = screenheightarray
    ds.sprbottomclip = negonearray
    ds.bsilheight = 2147483647
    ds.tsilheight = -2147483648
  else
    ds.sprtopclip = void
    ds.sprbottomclip = void
    ds.silhouette = 0

    if frontsector.floorheight > backsector.floorheight then
      ds.silhouette = ds.silhouette | SIL_BOTTOM
      ds.bsilheight = frontsector.floorheight
    else if backsector.floorheight > viewz then
      ds.silhouette = ds.silhouette | SIL_BOTTOM
      ds.bsilheight = 2147483647
    end if

    if frontsector.ceilingheight < backsector.ceilingheight then
      ds.silhouette = ds.silhouette | SIL_TOP
      ds.tsilheight = frontsector.ceilingheight
    else if backsector.ceilingheight < viewz then
      ds.silhouette = ds.silhouette | SIL_TOP
      ds.tsilheight = -2147483648
    end if

    if backsector.ceilingheight <= frontsector.floorheight then
      ds.sprbottomclip = negonearray
      ds.bsilheight = 2147483647
      ds.silhouette = ds.silhouette | SIL_BOTTOM
    end if

    if backsector.floorheight >= frontsector.ceilingheight then
      ds.sprtopclip = screenheightarray
      ds.tsilheight = -2147483648
      ds.silhouette = ds.silhouette | SIL_TOP
    end if

    worldhigh = backsector.ceilingheight - viewz
    worldlow = backsector.floorheight - viewz

    if frontsector.ceilingpic == skyflatnum and backsector.ceilingpic == skyflatnum then
      worldtop = worldhigh
    end if

    markfloor = false
    if worldlow != worldbottom or backsector.floorpic != frontsector.floorpic or backsector.lightlevel != frontsector.lightlevel then
      markfloor = true
    end if

    markceiling = false
    if worldhigh != worldtop or backsector.ceilingpic != frontsector.ceilingpic or backsector.lightlevel != frontsector.lightlevel then
      markceiling = true
    end if

    if backsector.ceilingheight <= frontsector.floorheight or backsector.floorheight >= frontsector.ceilingheight then
      rw_solidwall = true
      markceiling = true
      markfloor = true
    end if

    if worldhigh < worldtop then
      toptexture = _RS_ResolveTexture(sidedef.toptexture)
      if linedef is not void and(linedef.flags & ML_DONTPEGTOP) != 0 then
        rw_toptexturemid = worldtop
      else
        if typeof(textureheight) == "array" and toptexture >= 0 and toptexture < len(textureheight) then
          vtop = backsector.ceilingheight + textureheight[toptexture]
        else
          vtop = backsector.ceilingheight
        end if
        rw_toptexturemid = vtop - viewz
      end if
    end if

    if worldlow > worldbottom then
      bottomtexture = _RS_ResolveTexture(sidedef.bottomtexture)
      if linedef is not void and(linedef.flags & ML_DONTPEGBOTTOM) != 0 then
        rw_bottomtexturemid = worldtop
      else
        rw_bottomtexturemid = worldlow
      end if
    end if

    rw_toptexturemid = rw_toptexturemid + sidedef.rowoffset
    rw_bottomtexturemid = rw_bottomtexturemid + sidedef.rowoffset

    if typeof(sidedef.midtexture) == "int" and sidedef.midtexture != 0 then
      maskedtexture = true
      maskedtexturecol = _RS_AllocMaskedCols(start, stop)
      ds.maskedtexturecol = maskedtexturecol
    end if
  end if

  segtextured =(midtexture != 0) or(toptexture != 0) or(bottomtexture != 0) or maskedtexture
  if segtextured then
    offsetangle = _RS_AngSub(rw_normalangle, rw_angle1)
    if offsetangle > ANG180 then offsetangle = _RS_AngNorm(-offsetangle) end if
    if offsetangle > ANG90 then offsetangle = ANG90 end if

    sineval = _R_FineSineAt(offsetangle)
    rw_offset = FixedMul(hyp, sineval)
    if _RS_AngSub(rw_normalangle, rw_angle1) < ANG180 then rw_offset = -rw_offset end if
    rw_offset = rw_offset + sidedef.textureoffset + curline.offset
    rw_centerangle = _RS_AngNorm(ANG90 + viewangle - rw_normalangle)

    _RS_SelectWallLights(curline, frontsector)
  end if

  if frontsector.floorheight >= viewz then markfloor = false end if
  if frontsector.ceilingheight <= viewz and frontsector.ceilingpic != skyflatnum then markceiling = false end if

  wt = worldtop >> 4
  wb = worldbottom >> 4

  topstep = -FixedMul(rw_scalestep, wt)
  topfrac =(centeryfrac >> 4) - FixedMul(wt, rw_scale)

  bottomstep = -FixedMul(rw_scalestep, wb)
  bottomfrac =(centeryfrac >> 4) - FixedMul(wb, rw_scale)

  if backsector is not void then
    wh = worldhigh >> 4
    wl = worldlow >> 4

    if wh < wt then
      pixhigh =(centeryfrac >> 4) - FixedMul(wh, rw_scale)
      pixhighstep = -FixedMul(rw_scalestep, wh)
    end if

    if wl > wb then
      pixlow =(centeryfrac >> 4) - FixedMul(wl, rw_scale)
      pixlowstep = -FixedMul(rw_scalestep, wl)
    end if
  end if

  if markceiling then ceilingplane = R_CheckPlane(ceilingplane, rw_x, rw_stopx - 1) end if
  if markfloor then floorplane = R_CheckPlane(floorplane, rw_x, rw_stopx - 1) end if

  R_RenderSegLoop()

  if (((ds.silhouette & SIL_TOP) != 0) or maskedtexture) and ds.sprtopclip is void then
    ds.sprtopclip = _RS_CopyClipToOpenings(ceilingclip, start, rw_stopx - 1, -1)
  end if

  if (((ds.silhouette & SIL_BOTTOM) != 0) or maskedtexture) and ds.sprbottomclip is void then
    ds.sprbottomclip = _RS_CopyClipToOpenings(floorclip, start, rw_stopx - 1, viewheight)
  end if

  if maskedtexture and(ds.silhouette & SIL_TOP) == 0 then
    ds.silhouette = ds.silhouette | SIL_TOP
    ds.tsilheight = -2147483648
  end if
  if maskedtexture and(ds.silhouette & SIL_BOTTOM) == 0 then
    ds.silhouette = ds.silhouette | SIL_BOTTOM
    ds.bsilheight = 2147483647
  end if

  drawsegs[ds_p] = ds
  ds_p = ds_p + 1
end function



