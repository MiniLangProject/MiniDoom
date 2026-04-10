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

  Script: r_draw.ml
  Purpose: Implements renderer data preparation and software rendering pipeline stages.
*/
import doomdef
import i_system
import z_zone
import w_wad
import r_local
import v_video
import doomstat
import std.math

dc_colormap = 0
dc_x = 0
dc_yl = 0
dc_yh = 0
dc_iscale = 0
dc_texturemid = 0
dc_source = 0

dc_sourcebase = void
dc_sourceoff = 0
dc_sourcelen = 0
dc_sourceclamp = false

ds_y = 0
ds_x1 = 0
ds_x2 = 0
ds_colormap = 0
ds_xfrac = 0
ds_yfrac = 0
ds_xstep = 0
ds_ystep = 0
ds_source = 0

translationtables = 0
dc_translation = 0

ylookup =[]
columnofs =[]
const SBARHEIGHT = 32

const FUZZTABLE = 50
fuzzoffset =[
SCREENWIDTH, - SCREENWIDTH, SCREENWIDTH, - SCREENWIDTH, SCREENWIDTH, SCREENWIDTH, - SCREENWIDTH,
SCREENWIDTH, SCREENWIDTH, - SCREENWIDTH, SCREENWIDTH, SCREENWIDTH, SCREENWIDTH, - SCREENWIDTH,
SCREENWIDTH, SCREENWIDTH, SCREENWIDTH, - SCREENWIDTH, - SCREENWIDTH, - SCREENWIDTH, - SCREENWIDTH,
SCREENWIDTH, - SCREENWIDTH, - SCREENWIDTH, SCREENWIDTH, SCREENWIDTH, SCREENWIDTH, SCREENWIDTH, - SCREENWIDTH,
SCREENWIDTH, - SCREENWIDTH, SCREENWIDTH, SCREENWIDTH, - SCREENWIDTH, - SCREENWIDTH, SCREENWIDTH,
SCREENWIDTH, - SCREENWIDTH, - SCREENWIDTH, - SCREENWIDTH, - SCREENWIDTH, SCREENWIDTH, SCREENWIDTH,
SCREENWIDTH, SCREENWIDTH, - SCREENWIDTH, SCREENWIDTH, SCREENWIDTH, - SCREENWIDTH, SCREENWIDTH
]
fuzzpos = 0

_rd_prof_col_calls = 0
_rd_prof_col_pixels = 0
_rd_prof_span_calls = 0
_rd_prof_span_pixels = 0
_rd_prof_enabled = false

/*
* Function: R_DrawProfileReset
* Purpose: Draws or renders output for the renderer.
*/
function R_DrawProfileReset()
  global _rd_prof_col_calls
  global _rd_prof_col_pixels
  global _rd_prof_span_calls
  global _rd_prof_span_pixels

  _rd_prof_col_calls = 0
  _rd_prof_col_pixels = 0
  _rd_prof_span_calls = 0
  _rd_prof_span_pixels = 0
end function

/*
* Function: R_DrawProfileSetEnabled
* Purpose: Draws or renders output for the renderer.
*/
function R_DrawProfileSetEnabled(on)
  global _rd_prof_enabled
  _rd_prof_enabled = on
end function

/*
* Function: R_DepthClear
* Purpose: Implements the R_DepthClear routine for the renderer.
*/
function R_DepthClear()

end function

/*
* Function: R_DepthBeginWall
* Purpose: Implements the R_DepthBeginWall routine for the renderer.
*/
function R_DepthBeginWall(scale)
  scale = scale
end function

/*
* Function: R_DepthEndWall
* Purpose: Implements the R_DepthEndWall routine for the renderer.
*/
function R_DepthEndWall()
end function

/*
* Function: R_DepthBeginSprite
* Purpose: Implements the R_DepthBeginSprite routine for the renderer.
*/
function R_DepthBeginSprite(scale)
  scale = scale
end function

/*
* Function: R_DepthEndSprite
* Purpose: Implements the R_DepthEndSprite routine for the renderer.
*/
function R_DepthEndSprite()
end function

/*
* Function: _RD_DepthPass
* Purpose: Implements the _RD_DepthPass routine for the internal module support.
*/
function inline _RD_DepthPass(di)
  di = di
  return true
end function

/*
* Function: _RD_DepthStore
* Purpose: Implements the _RD_DepthStore routine for the internal module support.
*/
function inline _RD_DepthStore(di)
  di = di
end function

/*
* Function: _RD_IDiv
* Purpose: Implements the _RD_IDiv routine for the internal module support.
*/
function inline _RD_IDiv(a, b)
  if typeof(a) != "int" or typeof(b) != "int" or b == 0 then return 0 end if
  q = a / b
  if q >= 0 then return std.math.floor(q) end if
  return std.math.ceil(q)
end function

/*
* Function: _RD_CenterY
* Purpose: Implements the _RD_CenterY routine for the internal module support.
*/
function inline _RD_CenterY()
  if typeof(centery) == "int" then return centery end if
  return _RD_IDiv(SCREENHEIGHT, 2)
end function

/*
* Function: _RD_WrapIndex
* Purpose: Implements the _RD_WrapIndex routine for the internal module support.
*/
function inline _RD_WrapIndex(i, n)
  if typeof(i) != "int" or typeof(n) != "int" or n <= 0 then return 0 end if
  if i < 0 then
    i = i % n
    if i < 0 then i = i + n end if
  end if
  if i >= n then i = i % n end if
  return i
end function

/*
* Function: _RD_IsPow2
* Purpose: Implements the _RD_IsPow2 routine for the internal module support.
*/
function inline _RD_IsPow2(n)
  if typeof(n) != "int" or n <= 0 then return false end if
  return (n &(n - 1)) == 0
end function

/*
* Function: _RD_DrawPatchIfExists
* Purpose: Draws or renders output for the internal module support.
*/
function inline _RD_DrawPatchIfExists(x, y, scrn, name)
  if typeof(W_CheckNumForName) != "function" then return end if
  lump = W_CheckNumForName(name)
  if typeof(lump) != "int" or lump < 0 then return end if
  V_DrawPatch(x, y, scrn, W_CacheLumpNum(lump, PU_CACHE))
end function

/*
* Function: R_InitBuffer
* Purpose: Initializes state and dependencies for the renderer.
*/
function R_InitBuffer(width, height)
  global ylookup
  global columnofs
  global viewwindowx
  global viewwindowy

  if typeof(width) != "int" or width <= 0 then width = SCREENWIDTH end if
  if typeof(height) != "int" or height <= 0 then height = SCREENHEIGHT end if
  if width > SCREENWIDTH then width = SCREENWIDTH end if
  if height > SCREENHEIGHT then height = SCREENHEIGHT end if

  viewwindowx =(SCREENWIDTH - width) >> 1

  columnofs =[]
  for x = 0 to width - 1
    columnofs = columnofs +[viewwindowx + x]
  end for

  if width == SCREENWIDTH then
    viewwindowy = 0
  else
    viewwindowy =(SCREENHEIGHT - SBARHEIGHT - height) >> 1
  end if

  ylookup =[]
  for y = 0 to height - 1
    ylookup = ylookup +[(y + viewwindowy) * SCREENWIDTH]
  end for
end function

/*
* Function: R_VideoErase
* Purpose: Implements the R_VideoErase routine for the renderer.
*/
function R_VideoErase(ofs, count)

  if count <= 0 then return end if
  if typeof(screens) != "array" or len(screens) < 2 then return end if
  src = screens[1]
  dst = screens[0]
  if typeof(src) != "bytes" or typeof(dst) != "bytes" then return end if
  if ofs < 0 then
    count = count + ofs
    ofs = 0
  end if
  if count <= 0 then return end if
  if ofs >= len(src) or ofs >= len(dst) then return end if
  maxcount = len(src) - ofs
  if (len(dst) - ofs) < maxcount then maxcount = len(dst) - ofs end if
  if count > maxcount then count = maxcount end if
  if count <= 0 then return end if
  copyBytes(dst, ofs, src, ofs, count)
end function

/*
* Function: R_DrawColumn
* Purpose: Draws or renders output for the renderer.
*/
function R_DrawColumn()
  global _rd_prof_col_calls
  global _rd_prof_col_pixels

  if typeof(screens) != "array" or len(screens) == 0 then return end if
  dest = screens[0]
  if typeof(dest) != "bytes" then return end if
  if typeof(dc_colormap) != "bytes" or len(dc_colormap) <= 0 then return end if
  if typeof(dc_x) != "int" or dc_x < 0 or dc_x >= len(columnofs) then return end if

  srcBase = dc_source
  srcOff = 0
  srcLen = 0
  srcClamp = false
  if typeof(srcBase) == "bytes" then srcLen = len(srcBase) end if
  if typeof(dc_sourcebase) == "bytes" and typeof(dc_sourcelen) == "int" and dc_sourcelen > 0 then
    srcBase = dc_sourcebase
    srcOff = dc_sourceoff
    if typeof(srcOff) != "int" then srcOff = 0 end if
    srcLen = dc_sourcelen
    srcClamp = dc_sourceclamp
    if srcOff < 0 then
      srcLen = srcLen + srcOff
      srcOff = 0
    end if
    if srcOff >= len(srcBase) then
      srcLen = 0
    else if srcOff + srcLen > len(srcBase) then
      srcLen = len(srcBase) - srcOff
    end if
  end if
  if typeof(srcBase) != "bytes" or srcLen <= 0 then return end if

  yl = dc_yl
  yh = dc_yh
  if typeof(yl) != "int" or typeof(yh) != "int" then return end if
  if yl < 0 then yl = 0 end if
  if yh >= len(ylookup) then yh = len(ylookup) - 1 end if

  count = yh - yl
  if count < 0 then return end if
  if _rd_prof_enabled then
    _rd_prof_col_calls = _rd_prof_col_calls + 1
    _rd_prof_col_pixels = _rd_prof_col_pixels +(count + 1)
  end if

  fracstep = dc_iscale
  frac = dc_texturemid +(yl - _RD_CenterY()) * fracstep

  x = columnofs[dc_x]
  cmapLen = len(dc_colormap)
  srcPow2 = _RD_IsPow2(srcLen) and(not srcClamp)
  srcMask = srcLen - 1

  if srcPow2 and cmapLen >= 256 then
    for y = yl to yh
      ti =(frac >> FRACBITS) & srcMask
      tex = srcBase[srcOff + ti]
      di = ylookup[y] + x
      dest[di] = dc_colormap[tex]
      frac = frac + fracstep
    end for
    return
  end if

  for y = yl to yh
    ti = frac >> FRACBITS
    if srcClamp then
      if ti < 0 then
        ti = 0
      else if ti >= srcLen then
        ti = srcLen - 1
      end if
    else
      ti = _RD_WrapIndex(ti, srcLen)
    end if
    tex = srcBase[srcOff + ti]
    if tex >= cmapLen then tex = tex % cmapLen end if
    if tex < 0 then tex = 0 end if
    di = ylookup[y] + x
    dest[di] = dc_colormap[tex]
    frac = frac + fracstep
  end for
end function

/*
* Function: R_DrawColumnLow
* Purpose: Draws or renders output for the renderer.
*/
function R_DrawColumnLow()
  global _rd_prof_col_calls
  global _rd_prof_col_pixels

  if typeof(screens) != "array" or len(screens) == 0 then return end if
  dest = screens[0]
  if typeof(dest) != "bytes" then return end if
  if typeof(dc_source) != "bytes" or len(dc_source) <= 0 then return end if
  if typeof(dc_colormap) != "bytes" or len(dc_colormap) <= 0 then return end if
  if typeof(dc_x) != "int" then return end if

  x1 = dc_x << 1
  x2 = x1 + 1
  if x1 < 0 or x2 >= len(columnofs) then
    R_DrawColumn()
    return
  end if

  yl = dc_yl
  yh = dc_yh
  if typeof(yl) != "int" or typeof(yh) != "int" then return end if
  if yl < 0 then yl = 0 end if
  if yh >= len(ylookup) then yh = len(ylookup) - 1 end if
  count = yh - yl
  if count < 0 then return end if
  if _rd_prof_enabled then
    _rd_prof_col_calls = _rd_prof_col_calls + 1
    _rd_prof_col_pixels = _rd_prof_col_pixels +((count + 1) * 2)
  end if

  fracstep = dc_iscale
  frac = dc_texturemid +(yl - _RD_CenterY()) * fracstep
  srcLen = len(dc_source)
  cmapLen = len(dc_colormap)
  srcPow2 = _RD_IsPow2(srcLen)
  srcMask = srcLen - 1
  sx1 = columnofs[x1]
  sx2 = columnofs[x2]

  if srcPow2 and cmapLen >= 256 then
    for y = yl to yh
      ti =(frac >> FRACBITS) & srcMask
      c = dc_colormap[dc_source[ti]]
      row = ylookup[y]
      di1 = row + sx1
      di2 = row + sx2
      dest[di1] = c
      dest[di2] = c
      frac = frac + fracstep
    end for
    return
  end if

  for y = yl to yh
    ti = _RD_WrapIndex(frac >> FRACBITS, srcLen)
    tex = dc_source[ti]
    if tex >= cmapLen then tex = tex % cmapLen end if
    if tex < 0 then tex = 0 end if
    c = dc_colormap[tex]
    row = ylookup[y]
    di1 = row + sx1
    di2 = row + sx2
    dest[di1] = c
    dest[di2] = c
    frac = frac + fracstep
  end for
end function

/*
* Function: R_DrawFuzzColumn
* Purpose: Draws or renders output for the renderer.
*/
function R_DrawFuzzColumn()
  global fuzzpos
  if typeof(screens) != "array" or len(screens) == 0 then return end if
  dest = screens[0]
  if typeof(dest) != "bytes" then return end if
  if typeof(colormaps) != "bytes" or len(colormaps) <(6 * 256 + 256) then return end if
  if typeof(dc_x) != "int" or dc_x < 0 or dc_x >= len(columnofs) then return end if

  yl = dc_yl
  yh = dc_yh
  if yl == 0 then yl = 1 end if
  if typeof(viewheight) == "int" and yh == viewheight - 1 then yh = viewheight - 2 end if
  if yl < 0 then yl = 0 end if
  if yh >= len(ylookup) then yh = len(ylookup) - 1 end if
  count = yh - yl
  if count < 0 then return end if

  sx = columnofs[dc_x]
  for y = yl to yh
    di = ylookup[y] + sx
    ni = di + fuzzoffset[fuzzpos]
    if ni < 0 then ni = 0 end if
    if ni >= len(dest) then ni = len(dest) - 1 end if
    c = dest[ni]
    dest[di] = colormaps[6 * 256 + c]
    fuzzpos = fuzzpos + 1
    if fuzzpos == FUZZTABLE then fuzzpos = 0 end if
  end for
end function

/*
* Function: R_DrawFuzzColumnLow
* Purpose: Draws or renders output for the renderer.
*/
function R_DrawFuzzColumnLow()
  R_DrawFuzzColumn()
end function

/*
* Function: R_DrawTranslatedColumn
* Purpose: Draws or renders output for the renderer.
*/
function R_DrawTranslatedColumn()
  if typeof(screens) != "array" or len(screens) == 0 then return end if
  dest = screens[0]
  if typeof(dest) != "bytes" then return end if
  if typeof(dc_colormap) != "bytes" or len(dc_colormap) <= 0 then return end if
  if typeof(dc_x) != "int" or dc_x < 0 or dc_x >= len(columnofs) then return end if

  srcBase = dc_source
  srcOff = 0
  slen = 0
  srcClamp = false
  if typeof(srcBase) == "bytes" then slen = len(srcBase) end if
  if typeof(dc_sourcebase) == "bytes" and typeof(dc_sourcelen) == "int" and dc_sourcelen > 0 then
    srcBase = dc_sourcebase
    srcOff = dc_sourceoff
    if typeof(srcOff) != "int" then srcOff = 0 end if
    slen = dc_sourcelen
    srcClamp = dc_sourceclamp
    if srcOff < 0 then
      slen = slen + srcOff
      srcOff = 0
    end if
    if srcOff >= len(srcBase) then
      slen = 0
    else if srcOff + slen > len(srcBase) then
      slen = len(srcBase) - srcOff
    end if
  end if
  if typeof(srcBase) != "bytes" or slen <= 0 then return end if

  yl = dc_yl
  yh = dc_yh
  if typeof(yl) != "int" or typeof(yh) != "int" then return end if
  if yl < 0 then yl = 0 end if
  if yh >= len(ylookup) then yh = len(ylookup) - 1 end if
  count = yh - yl
  if count < 0 then return end if

  fracstep = dc_iscale
  frac = dc_texturemid +(yl - _RD_CenterY()) * fracstep
  sx = columnofs[dc_x]
  cmapLen = len(dc_colormap)
  srcPow2 = _RD_IsPow2(slen) and(not srcClamp)
  srcMask = slen - 1
  tr = dc_translation
  hasTr =(typeof(tr) == "bytes" and len(tr) >= 256)

  if srcPow2 and cmapLen >= 256 then
    for y = yl to yh
      si =(frac >> FRACBITS) & srcMask
      c = srcBase[srcOff + si]
      if hasTr then c = tr[c] end if
      di = ylookup[y] + sx
      dest[di] = dc_colormap[c]
      frac = frac + fracstep
    end for
    return
  end if

  for y = yl to yh
    si = frac >> FRACBITS
    if srcClamp then
      if si < 0 then
        si = 0
      else if si >= slen then
        si = slen - 1
      end if
    else
      si = _RD_WrapIndex(si, slen)
    end if
    c = srcBase[srcOff + si]
    if hasTr then c = tr[c] end if
    if c >= cmapLen then c = c % cmapLen end if
    if c < 0 then c = 0 end if
    di = ylookup[y] + sx
    dest[di] = dc_colormap[c]
    frac = frac + fracstep
  end for
end function

/*
* Function: R_DrawTranslatedColumnLow
* Purpose: Draws or renders output for the renderer.
*/
function R_DrawTranslatedColumnLow()
  R_DrawTranslatedColumn()
end function

/*
* Function: R_DrawSpan
* Purpose: Draws or renders output for the renderer.
*/
function R_DrawSpan()
  global _rd_prof_span_calls
  global _rd_prof_span_pixels
  if ds_x2 < ds_x1 then return end if
  if typeof(ds_source) != "bytes" then return end if
  if typeof(ds_colormap) != "bytes" then return end if
  if len(ds_colormap) < 256 then return end if
  if typeof(ds_y) != "int" or ds_y < 0 or ds_y >= len(ylookup) then return end if
  if typeof(ds_x1) != "int" or typeof(ds_x2) != "int" then return end if
  if ds_x1 < 0 or ds_x2 >= len(columnofs) then return end if

  dest = screens[0]
  if typeof(dest) != "bytes" then return end if
  y = ds_y
  xf = ds_xfrac
  yf = ds_yfrac
  di = ylookup[y] + columnofs[ds_x1]
  count = ds_x2 - ds_x1
  if _rd_prof_enabled then
    _rd_prof_span_calls = _rd_prof_span_calls + 1
    _rd_prof_span_pixels = _rd_prof_span_pixels +(count + 1)
  end if

  for i = 0 to count
    spot =((yf >>(FRACBITS - 6)) &(63 * 64)) +((xf >> FRACBITS) & 63)
    dest[di + i] = ds_colormap[ds_source[spot]]
    xf = xf + ds_xstep
    yf = yf + ds_ystep
  end for

end function

/*
* Function: R_DrawSpanLow
* Purpose: Draws or renders output for the renderer.
*/
function R_DrawSpanLow()
  global _rd_prof_span_calls
  global _rd_prof_span_pixels
  if ds_x2 < ds_x1 then return end if
  if typeof(ds_source) != "bytes" then return end if
  if typeof(ds_colormap) != "bytes" then return end if
  if len(ds_colormap) < 256 then return end if
  if typeof(ds_y) != "int" or ds_y < 0 or ds_y >= len(ylookup) then return end if
  if typeof(ds_x1) != "int" or typeof(ds_x2) != "int" then return end if

  dest = screens[0]
  if typeof(dest) != "bytes" then return end if

  xf = ds_xfrac
  yf = ds_yfrac
  x = ds_x1
  if _rd_prof_enabled then
    _rd_prof_span_calls = _rd_prof_span_calls + 1
    _rd_prof_span_pixels = _rd_prof_span_pixels +((ds_x2 - ds_x1 + 1) * 2)
  end if
  while x <= ds_x2
    sx = x << 1
    if sx >= 0 and(sx + 1) < len(columnofs) then
      spot =((yf >>(FRACBITS - 6)) &(63 * 64)) +((xf >> FRACBITS) & 63)
      c = ds_colormap[ds_source[spot]]
      di = ylookup[ds_y] + columnofs[sx]
      dest[di] = c
      dest[di + 1] = c
    end if
    xf = xf + ds_xstep
    yf = yf + ds_ystep
    x = x + 1
  end while

end function

/*
* Function: R_InitTranslationTables
* Purpose: Initializes state and dependencies for the renderer.
*/
function R_InitTranslationTables()
  global translationtables
  global dc_translation

  translationtables = bytes(256 * 3, 0)
  i = 0
  while i < 256
    if i >= 0x70 and i <= 0x7f then
      translationtables[i] = 0x60 +(i & 0xf)
      translationtables[i + 256] = 0x40 +(i & 0xf)
      translationtables[i + 512] = 0x20 +(i & 0xf)
    else
      translationtables[i] = i
      translationtables[i + 256] = i
      translationtables[i + 512] = i
    end if
    i = i + 1
  end while

  dc_translation = slice(translationtables, 0, 256)
end function

/*
* Function: R_FillBackScreen
* Purpose: Implements the R_FillBackScreen routine for the renderer.
*/
function R_FillBackScreen()
  if typeof(scaledviewwidth) != "int" then return end if
  if scaledviewwidth == SCREENWIDTH then return end if
  if typeof(screens) != "array" or len(screens) < 2 then return end if
  dest = screens[1]
  if typeof(dest) != "bytes" then return end if

  name = "FLOOR7_2"
  if gamemode == GameMode_t.commercial then
    name = "GRNROCK"
  end if

  src = void
  if typeof(W_CheckNumForName) == "function" and W_CheckNumForName(name) >= 0 then
    src = W_CacheLumpName(name, PU_CACHE)
  end if

  y = 0
  maxy = SCREENHEIGHT - SBARHEIGHT
  while y < maxy
    row = y * SCREENWIDTH
    if typeof(src) == "bytes" and len(src) >= 4096 then
      soff =(y & 63) << 6
      x = 0
      while x < SCREENWIDTH
        run = 64
        if x + run > SCREENWIDTH then run = SCREENWIDTH - x end if
        copyBytes(dest, row + x, src, soff, run)
        x = x + run
      end while
    else
      fillBytes(dest, row, SCREENWIDTH, 0)
    end if
    y = y + 1
  end while

  x = 0
  while x < scaledviewwidth
    _RD_DrawPatchIfExists(viewwindowx + x, viewwindowy - 8, 1, "BRDR_T")
    _RD_DrawPatchIfExists(viewwindowx + x, viewwindowy + viewheight, 1, "BRDR_B")
    x = x + 8
  end while

  y = 0
  while y < viewheight
    _RD_DrawPatchIfExists(viewwindowx - 8, viewwindowy + y, 1, "BRDR_L")
    _RD_DrawPatchIfExists(viewwindowx + scaledviewwidth, viewwindowy + y, 1, "BRDR_R")
    y = y + 8
  end while

  _RD_DrawPatchIfExists(viewwindowx - 8, viewwindowy - 8, 1, "BRDR_TL")
  _RD_DrawPatchIfExists(viewwindowx + scaledviewwidth, viewwindowy - 8, 1, "BRDR_TR")
  _RD_DrawPatchIfExists(viewwindowx - 8, viewwindowy + viewheight, 1, "BRDR_BL")
  _RD_DrawPatchIfExists(viewwindowx + scaledviewwidth, viewwindowy + viewheight, 1, "BRDR_BR")
end function

/*
* Function: R_DrawViewBorder
* Purpose: Draws or renders output for the renderer.
*/
function R_DrawViewBorder()
  if typeof(scaledviewwidth) != "int" then return end if
  if scaledviewwidth == SCREENWIDTH then return end if

  top = _RD_IDiv((SCREENHEIGHT - SBARHEIGHT) - viewheight, 2)
  side = _RD_IDiv(SCREENWIDTH - scaledviewwidth, 2)
  if top < 0 or side < 0 then return end if

  R_VideoErase(0, top * SCREENWIDTH + side)

  ofs =(viewheight + top) * SCREENWIDTH - side
  R_VideoErase(ofs, top * SCREENWIDTH + side)

  ofs = top * SCREENWIDTH + SCREENWIDTH - side
  side2 = side << 1
  i = 1
  while i < viewheight
    R_VideoErase(ofs, side2)
    ofs = ofs + SCREENWIDTH
    i = i + 1
  end while

  V_MarkRect(0, 0, SCREENWIDTH, SCREENHEIGHT - SBARHEIGHT)
end function



