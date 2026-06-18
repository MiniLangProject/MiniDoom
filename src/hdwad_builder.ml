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

  Script: hdwad_builder.ml
  Purpose: Builds MiniDoom HDWAD cache files inside the game executable.
*/
import std.fs as fs
import std.math

const UP_MAGIC0 = 77
const UP_MAGIC1 = 68
const UP_MAGIC2 = 85
const UP_MAGIC3 = 80
const HD_MAGIC0 = 77
const HD_MAGIC1 = 68
const HD_MAGIC2 = 72
const HD_MAGIC3 = 68
const UP_VERSION = 6

const UP_TYPE_PATCH = 1
const UP_TYPE_FLAT = 2
const UP_TYPE_TEXTURE = 3
const UP_TYPE_SPRITE = 4

const UP_FLAG_TRANSPARENT = 1
const UP_TRANSPARENT_INDEX = 255
const UP_OPAQUE_255_REMAP = 254
const UP_XBRZ_DIST_LIMIT = 4200
const UP_XBRZ_BLEND_NONE = 0
const UP_XBRZ_BLEND_NORMAL = 1
const UP_XBRZ_BLEND_DOMINANT = 2
const UP_XBRZ_EQUAL_COLOR_TOLERANCE = 30.0
const UP_XBRZ_DOMINANT_DIRECTION_THRESHOLD = 3.6
const UP_XBRZ_STEEP_DIRECTION_THRESHOLD = 2.2

/*
* Function: UP_LoadingPulse
* Purpose: Pumps the host window while HDWAD generation performs long CPU-bound work.
*/
function inline UP_LoadingPulse()
  if typeof(I_LoadingPulse) == "function" then I_LoadingPulse() end if
end function

/*
* Function: UP_ReportProgress
* Purpose: Reports one or more HDWAD generation units to the frontend progress display.
*/
function inline UP_ReportProgress(units)
  if typeof(D_HDWADProgressStep) == "function" then
    D_HDWADProgressStep(units)
  else
    UP_LoadingPulse()
  end if
end function

/*
* Struct: up_lump_t
* Purpose: Stores one WAD directory entry.
*/
struct up_lump_t
  name
  filepos
  size
end struct

/*
* Struct: up_image_t
* Purpose: Stores one extracted image for the output package.
*/
struct up_image_t
  kind
  name
  width
  height
  xoffset
  yoffset
  flags
  data
end struct

/*
* Struct: up_texpatch_t
* Purpose: Stores one patch placement inside a wall texture.
*/
struct up_texpatch_t
  originx
  originy
  patch
end struct

/*
* Struct: up_texture_t
* Purpose: Stores one parsed TEXTURE1/TEXTURE2 definition.
*/
struct up_texture_t
  name
  width
  height
  patches
end struct

/*
* Function: UP_ReadU16
* Purpose: Reads a little-endian u16.
*/
function inline UP_ReadU16(b, off)
  return b[off] +(b[off + 1] << 8)
end function

/*
* Function: UP_ReadS16
* Purpose: Reads a little-endian s16.
*/
function inline UP_ReadS16(b, off)
  v = UP_ReadU16(b, off)
  if v >= 32768 then v = v - 65536 end if
  return v
end function

/*
* Function: UP_ReadU32
* Purpose: Reads a little-endian u32.
*/
function inline UP_ReadU32(b, off)
  return b[off] +(b[off + 1] << 8) +(b[off + 2] << 16) +(b[off + 3] << 24)
end function

/*
* Function: UP_ReadS32
* Purpose: Reads a little-endian s32.
*/
function inline UP_ReadS32(b, off)
  v = UP_ReadU32(b, off)
  if v >= 2147483648 then v = v - 4294967296 end if
  return v
end function

/*
* Function: UP_WriteU32
* Purpose: Writes a little-endian u32.
*/
function inline UP_WriteU32(b, off, value)
  if value < 0 then value = value + 4294967296 end if
  b[off] = value & 255
  b[off + 1] =(value >> 8) & 255
  b[off + 2] =(value >> 16) & 255
  b[off + 3] =(value >> 24) & 255
end function

/*
* Function: UP_ToIntOr
* Purpose: Converts a value to int with fallback.
*/
function UP_ToIntOr(v, fallback)
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
* Function: UP_ClampScale
* Purpose: Keeps output scale inside the supported package range.
*/
function inline UP_ClampScale(v)
  s = UP_ToIntOr(v, 2)
  if s < 2 then s = 2 end if
  if s > 4 then s = 4 end if
  return s
end function

/*
* Function: UP_Name8
* Purpose: Decodes a WAD name.
*/
function UP_Name8(b)
  src = b
  if typeof(b) == "string" then
    src = bytes(b)
  end if
  outName = bytes(8, 0)
  i = 0
  while i < 8 and i < len(src)
    c = src[i]
    if c == 0 then break end if
    if c >= 97 and c <= 122 then c = c - 32 end if
    outName[i] = c
    i = i + 1
  end while
  return decodeZ(outName)
end function

/*
* Function: UP_CopyBytes
* Purpose: Copies a byte range.
*/
function UP_CopyBytes(dst, dstOff, src, srcOff, count)
  i = 0
  while i < count
    dst[dstOff + i] = src[srcOff + i]
    i = i + 1
  end while
end function

/*
* Function: UP_FindMarker
* Purpose: Finds the first lump marker with the given name.
*/
function UP_FindMarker(lumps, name)
  n = UP_Name8(name)
  i = 0
  while i < len(lumps)
    if lumps[i].name == n then return i end if
    i = i + 1
  end while
  return -1
end function

/*
* Function: UP_FindLump
* Purpose: Finds a lump by name.
*/
function UP_FindLump(lumps, name)
  n = UP_Name8(name)
  i = len(lumps) - 1
  while i >= 0
    if lumps[i].name == n then return i end if
    i = i - 1
  end while
  return -1
end function

/*
* Function: UP_LumpBytes
* Purpose: Returns a lump payload or void.
*/
function UP_LumpBytes(wadData, lumps, idx)
  if typeof(idx) != "int" or idx < 0 or idx >= len(lumps) then return void end if
  l = lumps[idx]
  if l.filepos < 0 or l.size < 0 or l.filepos + l.size > len(wadData) then return void end if
  return slice(wadData, l.filepos, l.size)
end function

/*
* Function: UP_DefaultPalette
* Purpose: Builds a grayscale fallback palette.
*/
function UP_DefaultPalette()
  pal = bytes(768, 0)
  i = 0
  while i < 256
    o = i * 3
    pal[o] = i
    pal[o + 1] = i
    pal[o + 2] = i
    i = i + 1
  end while
  return pal
end function

/*
* Function: UP_LoadPalette
* Purpose: Extracts the first PLAYPAL palette from the WAD.
*/
function UP_LoadPalette(wadData, lumps)
  idx = UP_FindLump(lumps, "PLAYPAL")
  if idx < 0 then return UP_DefaultPalette() end if
  l = lumps[idx]
  if l.size < 768 or l.filepos < 0 or l.filepos + 768 > len(wadData) then
    return UP_DefaultPalette()
  end if
  return slice(wadData, l.filepos, 768)
end function

/*
* Function: UP_IsLikelyPatch
* Purpose: Performs conservative validation for Doom patch data.
*/
function UP_IsLikelyPatch(data)
  if typeof(data) != "bytes" or len(data) < 13 then return false end if
  w = UP_ReadS16(data, 0)
  h = UP_ReadS16(data, 2)
  if w <= 0 or h <= 0 then return false end if
  if w > 4096 or h > 4096 then return false end if
  if 8 + w * 4 > len(data) then return false end if
  firstCol = UP_ReadU32(data, 8)
  if firstCol < 8 + w * 4 or firstCol >= len(data) then return false end if
  return true
end function

/*
* Function: UP_DecodePatch
* Purpose: Converts a Doom patch lump into a palettized rectangular image.
*/
function UP_DecodePatch(name, kind, lumpData)
  if not UP_IsLikelyPatch(lumpData) then return void end if

  w = UP_ReadS16(lumpData, 0)
  h = UP_ReadS16(lumpData, 2)
  left = UP_ReadS16(lumpData, 4)
  top = UP_ReadS16(lumpData, 6)
  pixels = bytes(w * h, UP_TRANSPARENT_INDEX)

  x = 0
  while x < w
    colOfs = UP_ReadU32(lumpData, 8 + x * 4)
    p = colOfs
    guard = 0
    while p >= 0 and p < len(lumpData) and guard < 4096
      topdelta = lumpData[p]
      if topdelta == 255 then break end if
      if p + 3 >= len(lumpData) then break end if
      run = lumpData[p + 1]
      src = p + 3
      y = 0
      while y < run and src + y < len(lumpData)
        dy = topdelta + y
        if dy >= 0 and dy < h then
          c = lumpData[src + y]
          if c == UP_TRANSPARENT_INDEX then c = UP_OPAQUE_255_REMAP end if
          pixels[dy * w + x] = c
        end if
        y = y + 1
      end while
      p = p + run + 4
      guard = guard + 1
    end while
    x = x + 1
  end while

  return up_image_t(kind, UP_Name8(name), w, h, left, top, UP_FLAG_TRANSPARENT, pixels)
end function

/*
* Function: UP_ParsePnames
* Purpose: Builds PNAMES patch-name to lump-index mapping.
*/
function UP_ParsePnames(wadData, lumps)
  result =[]
  pidx = UP_FindLump(lumps, "PNAMES")
  data = UP_LumpBytes(wadData, lumps, pidx)
  if typeof(data) != "bytes" or len(data) < 4 then return result end if

  count = UP_ReadS32(data, 0)
  if count < 0 then return result end if
  i = 0
  while i < count
    off = 4 + i * 8
    if off + 8 > len(data) then break end if
    pname = UP_Name8(slice(data, off, 8))
    result = result +[UP_FindLump(lumps, pname)]
    i = i + 1
  end while
  return result
end function

/*
* Function: UP_ParseTextureLump
* Purpose: Parses TEXTURE1/TEXTURE2 wall texture definitions.
*/
function UP_ParseTextureLump(wadData, lumps, lumpName, patchLookup)
  result =[]
  tidx = UP_FindLump(lumps, lumpName)
  data = UP_LumpBytes(wadData, lumps, tidx)
  if typeof(data) != "bytes" or len(data) < 4 then return result end if

  count = UP_ReadS32(data, 0)
  if count < 0 then return result end if

  i = 0
  while i < count
    doff = 4 + i * 4
    if doff + 4 > len(data) then break end if
    off = UP_ReadS32(data, doff)
    if off < 0 or off + 22 > len(data) then
      i = i + 1
      continue
    end if

    name = UP_Name8(slice(data, off, 8))
    width = UP_ReadS16(data, off + 12)
    height = UP_ReadS16(data, off + 14)
    patchCount = UP_ReadS16(data, off + 20)
    if width <= 0 or height <= 0 or patchCount < 0 then
      i = i + 1
      continue
    end if

    patches =[]
    poff = off + 22
    p = 0
    while p < patchCount and poff + 10 <= len(data)
      ox = UP_ReadS16(data, poff)
      oy = UP_ReadS16(data, poff + 2)
      pnum = UP_ReadS16(data, poff + 4)
      plump = -1
      if pnum >= 0 and typeof(patchLookup) == "array" and pnum < len(patchLookup) then
        plump = patchLookup[pnum]
      end if
      if plump >= 0 then
        patches = patches +[up_texpatch_t(ox, oy, plump)]
      end if
      p = p + 1
      poff = poff + 10
    end while

    result = result +[up_texture_t(name, width, height, patches)]
    i = i + 1
  end while

  return result
end function

/*
* Function: UP_DrawPatchToTexture
* Purpose: Draws a decoded patch image into an indexed texture canvas.
*/
function UP_DrawPatchToTexture(patch, canvas, texW, texH, originX, originY)
  if patch is void or typeof(patch.data) != "bytes" then return end if
  y = 0
  while y < patch.height
    dstY = originY + y
    if dstY >= 0 and dstY < texH then
      x = 0
      while x < patch.width
        dstX = originX + x
        if dstX >= 0 and dstX < texW then
          c = patch.data[y * patch.width + x]
          if c != UP_TRANSPARENT_INDEX then
            canvas[dstY * texW + dstX] = c
          end if
        end if
        x = x + 1
      end while
    end if
    y = y + 1
  end while
end function

/*
* Function: UP_BuildTextureImage
* Purpose: Composites a wall texture from its source patch placements.
*/
function UP_BuildTextureImage(tex, wadData, lumps)
  if tex is void then return void end if
  canvas = bytes(tex.width * tex.height, UP_TRANSPARENT_INDEX)
  if typeof(tex.patches) == "array" then
    i = 0
    while i < len(tex.patches)
      tp = tex.patches[i]
      if tp is not void then
        lumpData = UP_LumpBytes(wadData, lumps, tp.patch)
        patch = UP_DecodePatch(lumps[tp.patch].name, UP_TYPE_PATCH, lumpData)
        if patch is not void then
          UP_DrawPatchToTexture(patch, canvas, tex.width, tex.height, tp.originx, tp.originy)
        end if
      end if
      i = i + 1
    end while
  end if
  return up_image_t(UP_TYPE_TEXTURE, tex.name, tex.width, tex.height, 0, 0, UP_FLAG_TRANSPARENT, canvas)
end function

/*
* Function: UP_IsTransparent
* Purpose: Checks whether an indexed pixel is transparent for patch-like images.
*/
function inline UP_IsTransparent(idx, hasAlpha)
  return hasAlpha and idx == UP_TRANSPARENT_INDEX
end function

/*
* Function: UP_ColorDistance
* Purpose: Computes weighted RGB distance for xBRZ edge decisions.
*/
function UP_ColorDistance(pal, a, b, hasAlpha)
  if a == b then return 0 end if
  if UP_IsTransparent(a, hasAlpha) or UP_IsTransparent(b, hasAlpha) then return 1000000000 end if

  ao = a * 3
  bo = b * 3
  dr = pal[ao] - pal[bo]
  dg = pal[ao + 1] - pal[bo + 1]
  db = pal[ao + 2] - pal[bo + 2]
  return dr * dr * 3 + dg * dg * 4 + db * db * 2
end function

/*
* Function: UP_ColorDistanceCached
* Purpose: Computes palette distance with a per-image 256x256 cache.
*/
function UP_ColorDistanceCached(pal, cache, a, b, hasAlpha)
  if a == b then return 0 end if
  key = a * 256 + b
  if typeof(cache) == "array" and key >= 0 and key < len(cache) and cache[key] >= 0 then return cache[key] end if
  d = UP_ColorDistance(pal, a, b, hasAlpha)
  if typeof(cache) == "array" and key >= 0 and key < len(cache) then
    cache[key] = d
    rkey = b * 256 + a
    if rkey >= 0 and rkey < len(cache) then cache[rkey] = d end if
  end if
  return d
end function

/*
* Function: UP_SimilarColor
* Purpose: Evaluates xBRZ-style color equality with a distance threshold.
*/
function inline UP_SimilarColor(pal, a, b, hasAlpha)
  return UP_ColorDistance(pal, a, b, hasAlpha) <= UP_XBRZ_DIST_LIMIT
end function

/*
* Function: UP_SimilarColorCached
* Purpose: Evaluates xBRZ-style equality using the per-image distance cache.
*/
function inline UP_SimilarColorCached(pal, cache, a, b, hasAlpha)
  return UP_ColorDistanceCached(pal, cache, a, b, hasAlpha) <= UP_XBRZ_DIST_LIMIT
end function

/*
* Function: UP_PixelAt
* Purpose: Reads a clamped source pixel.
*/
function inline UP_PixelAt(src, w, h, x, y)
  if x < 0 then x = 0 end if
  if y < 0 then y = 0 end if
  if x >= w then x = w - 1 end if
  if y >= h then y = h - 1 end if
  return src[y * w + x]
end function

/*
* Function: UP_NearestPaletteIndex
* Purpose: Quantizes an RGB color back to the Doom palette.
*/
function UP_NearestPaletteIndex(pal, r, g, b, hasAlpha)
  best = 0
  bestDist = 2147483647
  i = 0
  while i < 256
    if UP_IsTransparent(i, hasAlpha) then
      i = i + 1
      continue
    end if
    o = i * 3
    dr = r - pal[o]
    dg = g - pal[o + 1]
    db = b - pal[o + 2]
    d = dr * dr * 3 + dg * dg * 4 + db * db * 2
    if d < bestDist then
      bestDist = d
      best = i
      if d == 0 then return best end if
    end if
    i = i + 1
  end while
  return best
end function

/*
* Function: UP_BlendIndex
* Purpose: Blends two palette indices and quantizes the result.
*/
function UP_BlendIndex(pal, cache, base, edge, edgeWeight, hasAlpha)
  if edgeWeight <= 0 or base == edge then return base end if
  if edgeWeight > 3 then edgeWeight = 3 end if
  if UP_IsTransparent(base, hasAlpha) then return edge end if
  if UP_IsTransparent(edge, hasAlpha) then return base end if

  key =((base * 256) + edge) * 4 + edgeWeight
  if typeof(cache) == "array" and key >= 0 and key < len(cache) and cache[key] >= 0 then
    return cache[key]
  end if

  inv = 4 - edgeWeight
  bo = base * 3
  eo = edge * 3
  r = std.math.floor((pal[bo] * inv + pal[eo] * edgeWeight + 2) / 4)
  g = std.math.floor((pal[bo + 1] * inv + pal[eo + 1] * edgeWeight + 2) / 4)
  b = std.math.floor((pal[bo + 2] * inv + pal[eo + 2] * edgeWeight + 2) / 4)
  outIdx = UP_NearestPaletteIndex(pal, r, g, b, hasAlpha)

  if typeof(cache) == "array" and key >= 0 and key < len(cache) then cache[key] = outIdx end if
  return outIdx
end function

/*
* Function: UP_XbrzDistanceCached
* Purpose: Computes the palette distance used by the original xBRZ rules.
*/
function UP_XbrzDistanceCached(pal, cache, a, b, hasAlpha)
  if a == b then return 0.0 end if
  key = a * 256 + b
  if typeof(cache) == "array" and key >= 0 and key < len(cache) and cache[key] >= 0 then return cache[key] end if
  d = 0.0
  if UP_IsTransparent(a, hasAlpha) or UP_IsTransparent(b, hasAlpha) then
    d = 1000000000.0
  else
    ao = a * 3
    bo = b * 3
    rdiff = pal[ao] - pal[bo]
    gdiff = pal[ao + 1] - pal[bo + 1]
    bdiff = pal[ao + 2] - pal[bo + 2]
    kr = 0.2627
    kb = 0.0593
    kg = 1.0 - kr - kb
    yy = kr * rdiff + kg * gdiff + kb * bdiff
    cb = 0.5 /(1.0 - kb) *(bdiff - yy)
    cr = 0.5 /(1.0 - kr) *(rdiff - yy)
    d = std.math.sqrt(yy * yy + cb * cb + cr * cr)
  end if
  if typeof(cache) == "array" and key >= 0 and key < len(cache) then
    cache[key] = d
    rkey = b * 256 + a
    if rkey >= 0 and rkey < len(cache) then cache[rkey] = d end if
  end if
  return d
end function

/*
* Function: UP_XbrzEq
* Purpose: Tests palette equality using xBRZ's perceptual tolerance.
*/
function inline UP_XbrzEq(pal, cache, a, b, hasAlpha)
  return UP_XbrzDistanceCached(pal, cache, a, b, hasAlpha) < UP_XBRZ_EQUAL_COLOR_TOLERANCE
end function

/*
* Function: UP_BlendIndexRatio
* Purpose: Controls blend Index Ratio transitions in the HDWAD builder system.
*/
function UP_BlendIndexRatio(pal, cache, base, edge, ratioCode, hasAlpha)
  if base == edge then return base end if
  if UP_IsTransparent(base, hasAlpha) then return edge end if
  if UP_IsTransparent(edge, hasAlpha) then return base end if

  key =((base * 256) + edge) * 5 + ratioCode
  if typeof(cache) == "array" and key >= 0 and key < len(cache) and cache[key] >= 0 then return cache[key] end if

  m = 1
  n = 4
  if ratioCode == 1 then
    m = 3
    n = 4
  else if ratioCode == 2 then
    m = 1
    n = 8
  else if ratioCode == 3 then
    m = 7
    n = 8
  else if ratioCode == 4 then
    m = 45
    n = 100
  end if

  inv = n - m
  bo = base * 3
  eo = edge * 3
  r = std.math.floor((pal[bo] * inv + pal[eo] * m + std.math.floor(n / 2)) / n)
  g = std.math.floor((pal[bo + 1] * inv + pal[eo + 1] * m + std.math.floor(n / 2)) / n)
  b = std.math.floor((pal[bo + 2] * inv + pal[eo + 2] * m + std.math.floor(n / 2)) / n)
  outIdx = UP_NearestPaletteIndex(pal, r, g, b, hasAlpha)

  if typeof(cache) == "array" and key >= 0 and key < len(cache) then cache[key] = outIdx end if
  return outIdx
end function

/*
* Function: UP_XbrzGetTopL
* Purpose: Provides xBRZ get top left helper behavior for the HDWAD builder.
*/
function inline UP_XbrzGetTopL(b)
  return b & 3
end function

/*
* Function: UP_XbrzGetTopR
* Purpose: Provides xBRZ get top right helper behavior for the HDWAD builder.
*/
function inline UP_XbrzGetTopR(b)
  return (b >> 2) & 3
end function

/*
* Function: UP_XbrzGetBottomR
* Purpose: Provides xBRZ get bottom right helper behavior for the HDWAD builder.
*/
function inline UP_XbrzGetBottomR(b)
  return (b >> 4) & 3
end function

/*
* Function: UP_XbrzGetBottomL
* Purpose: Provides xBRZ get bottom left helper behavior for the HDWAD builder.
*/
function inline UP_XbrzGetBottomL(b)
  return (b >> 6) & 3
end function

/*
* Function: UP_XbrzSetTopL
* Purpose: Provides xBRZ set top left helper behavior for the HDWAD builder.
*/
function inline UP_XbrzSetTopL(b, bt)
  return b | bt
end function

/*
* Function: UP_XbrzSetTopR
* Purpose: Provides xBRZ set top right helper behavior for the HDWAD builder.
*/
function inline UP_XbrzSetTopR(b, bt)
  return b |(bt << 2)
end function

/*
* Function: UP_XbrzSetBottomR
* Purpose: Provides xBRZ set bottom right helper behavior for the HDWAD builder.
*/
function inline UP_XbrzSetBottomR(b, bt)
  return b |(bt << 4)
end function

/*
* Function: UP_XbrzSetBottomL
* Purpose: Provides xBRZ set bottom left helper behavior for the HDWAD builder.
*/
function inline UP_XbrzSetBottomL(b, bt)
  return b |(bt << 6)
end function

/*
* Function: UP_XbrzRotateBlendInfo
* Purpose: Controls xbrz Rotate Blend Info transitions in the HDWAD builder system.
*/
function UP_XbrzRotateBlendInfo(b, rot)
  if rot == 1 then return ((b << 2) |(b >> 6)) & 255 end if
  if rot == 2 then return ((b << 4) |(b >> 4)) & 255 end if
  if rot == 3 then return ((b << 6) |(b >> 2)) & 255 end if
  return b
end function

/*
* Function: UP_XbrzPreProcessCorners
* Purpose: Provides xBRZ pre process corners helper behavior for the HDWAD builder.
*/
function UP_XbrzPreProcessCorners(pal, cache, a, b, c, d, e, f, g, h, ii, j, k, l, m, n, o, p, hasAlpha)
  if (f == g and j == k) or(f == j and g == k) then return 0 end if

  weight = 4.0
  jg = UP_XbrzDistanceCached(pal, cache, ii, f, hasAlpha) + UP_XbrzDistanceCached(pal, cache, f, c, hasAlpha) + UP_XbrzDistanceCached(pal, cache, n, k, hasAlpha) + UP_XbrzDistanceCached(pal, cache, k, h, hasAlpha) + weight * UP_XbrzDistanceCached(pal, cache, j, g, hasAlpha)
  fk = UP_XbrzDistanceCached(pal, cache, e, j, hasAlpha) + UP_XbrzDistanceCached(pal, cache, j, o, hasAlpha) + UP_XbrzDistanceCached(pal, cache, b, g, hasAlpha) + UP_XbrzDistanceCached(pal, cache, g, l, hasAlpha) + weight * UP_XbrzDistanceCached(pal, cache, f, k, hasAlpha)

  result = 0
  if jg < fk then
    bt = UP_XBRZ_BLEND_NORMAL
    if UP_XBRZ_DOMINANT_DIRECTION_THRESHOLD * jg < fk then bt = UP_XBRZ_BLEND_DOMINANT end if
    if f != g and f != j then result = result | bt end if
    if k != j and k != g then result = result |(bt << 6) end if
  else if fk < jg then
    bt = UP_XBRZ_BLEND_NORMAL
    if UP_XBRZ_DOMINANT_DIRECTION_THRESHOLD * fk < jg then bt = UP_XBRZ_BLEND_DOMINANT end if
    if j != f and j != k then result = result |(bt << 4) end if
    if g != f and g != k then result = result |(bt << 2) end if
  end if
  return result
end function

/*
* Function: UP_XbrzRotGet
* Purpose: Provides xBRZ rot get helper behavior for the HDWAD builder.
*/
function UP_XbrzRotGet(rot, pos, a, b, c, d, e, f, g, h, ii)
  if rot == 1 then
    if pos == 0 then return g end if
    if pos == 1 then return d end if
    if pos == 2 then return a end if
    if pos == 3 then return h end if
    if pos == 4 then return e end if
    if pos == 5 then return b end if
    if pos == 6 then return ii end if
    if pos == 7 then return f end if
    return c
  else if rot == 2 then
    if pos == 0 then return ii end if
    if pos == 1 then return h end if
    if pos == 2 then return g end if
    if pos == 3 then return f end if
    if pos == 4 then return e end if
    if pos == 5 then return d end if
    if pos == 6 then return c end if
    if pos == 7 then return b end if
    return a
  else if rot == 3 then
    if pos == 0 then return c end if
    if pos == 1 then return f end if
    if pos == 2 then return ii end if
    if pos == 3 then return b end if
    if pos == 4 then return e end if
    if pos == 5 then return h end if
    if pos == 6 then return a end if
    if pos == 7 then return d end if
    return g
  end if

  if pos == 0 then return a end if
  if pos == 1 then return b end if
  if pos == 2 then return c end if
  if pos == 3 then return d end if
  if pos == 4 then return e end if
  if pos == 5 then return f end if
  if pos == 6 then return g end if
  if pos == 7 then return h end if
  return ii
end function

/*
* Function: UP_XbrzRefIndex3
* Purpose: Finds xbrz Ref Index3 information for HDWAD builder processing.
*/
function UP_XbrzRefIndex3(dw, blockX, blockY, rot, i, j)
  rr = i
  cc = j
  if rot == 1 then
    rr = 2 - j
    cc = i
  else if rot == 2 then
    rr = 2 - i
    cc = 2 - j
  else if rot == 3 then
    rr = j
    cc = 2 - i
  end if
  return (blockY + rr) * dw + blockX + cc
end function

/*
* Function: UP_XbrzBlendRef3
* Purpose: Controls xbrz Blend Ref3 transitions in the HDWAD builder system.
*/
function UP_XbrzBlendRef3(dst, dw, blockX, blockY, rot, i, j, col, pal, blendCache, hasAlpha, ratioCode)
  idx = UP_XbrzRefIndex3(dw, blockX, blockY, rot, i, j)
  dst[idx] = UP_BlendIndexRatio(pal, blendCache, dst[idx], col, ratioCode, hasAlpha)
end function

/*
* Function: UP_XbrzSetRef3
* Purpose: Provides xBRZ set ref3 helper behavior for the HDWAD builder.
*/
function inline UP_XbrzSetRef3(dst, dw, blockX, blockY, rot, i, j, col)
  dst[UP_XbrzRefIndex3(dw, blockX, blockY, rot, i, j)] = col
end function

/*
* Function: UP_XbrzBlendLineShallow3
* Purpose: Provides xBRZ blend line shallow3 helper behavior for the HDWAD builder.
*/
function UP_XbrzBlendLineShallow3(dst, dw, blockX, blockY, rot, col, pal, blendCache, hasAlpha)
  UP_XbrzBlendRef3(dst, dw, blockX, blockY, rot, 2, 0, col, pal, blendCache, hasAlpha, 0)
  UP_XbrzBlendRef3(dst, dw, blockX, blockY, rot, 1, 2, col, pal, blendCache, hasAlpha, 0)
  UP_XbrzBlendRef3(dst, dw, blockX, blockY, rot, 2, 1, col, pal, blendCache, hasAlpha, 1)
  UP_XbrzSetRef3(dst, dw, blockX, blockY, rot, 2, 2, col)
end function

/*
* Function: UP_XbrzBlendLineSteep3
* Purpose: Provides xBRZ blend line steep3 helper behavior for the HDWAD builder.
*/
function UP_XbrzBlendLineSteep3(dst, dw, blockX, blockY, rot, col, pal, blendCache, hasAlpha)
  UP_XbrzBlendRef3(dst, dw, blockX, blockY, rot, 0, 2, col, pal, blendCache, hasAlpha, 0)
  UP_XbrzBlendRef3(dst, dw, blockX, blockY, rot, 2, 1, col, pal, blendCache, hasAlpha, 0)
  UP_XbrzBlendRef3(dst, dw, blockX, blockY, rot, 1, 2, col, pal, blendCache, hasAlpha, 1)
  UP_XbrzSetRef3(dst, dw, blockX, blockY, rot, 2, 2, col)
end function

/*
* Function: UP_XbrzBlendLineSteepAndShallow3
* Purpose: Provides xBRZ blend line steep and shallow3 helper behavior for the HDWAD builder.
*/
function UP_XbrzBlendLineSteepAndShallow3(dst, dw, blockX, blockY, rot, col, pal, blendCache, hasAlpha)
  UP_XbrzBlendRef3(dst, dw, blockX, blockY, rot, 2, 0, col, pal, blendCache, hasAlpha, 0)
  UP_XbrzBlendRef3(dst, dw, blockX, blockY, rot, 0, 2, col, pal, blendCache, hasAlpha, 0)
  UP_XbrzBlendRef3(dst, dw, blockX, blockY, rot, 2, 1, col, pal, blendCache, hasAlpha, 1)
  UP_XbrzBlendRef3(dst, dw, blockX, blockY, rot, 1, 2, col, pal, blendCache, hasAlpha, 1)
  UP_XbrzSetRef3(dst, dw, blockX, blockY, rot, 2, 2, col)
end function

/*
* Function: UP_XbrzBlendLineDiagonal3
* Purpose: Provides xBRZ blend line diagonal3 helper behavior for the HDWAD builder.
*/
function UP_XbrzBlendLineDiagonal3(dst, dw, blockX, blockY, rot, col, pal, blendCache, hasAlpha)
  UP_XbrzBlendRef3(dst, dw, blockX, blockY, rot, 1, 2, col, pal, blendCache, hasAlpha, 2)
  UP_XbrzBlendRef3(dst, dw, blockX, blockY, rot, 2, 1, col, pal, blendCache, hasAlpha, 2)
  UP_XbrzBlendRef3(dst, dw, blockX, blockY, rot, 2, 2, col, pal, blendCache, hasAlpha, 3)
end function

/*
* Function: UP_XbrzBlendCorner3
* Purpose: Controls xbrz Blend Corner3 transitions in the HDWAD builder system.
*/
function UP_XbrzBlendCorner3(dst, dw, blockX, blockY, rot, col, pal, blendCache, hasAlpha)
  UP_XbrzBlendRef3(dst, dw, blockX, blockY, rot, 2, 2, col, pal, blendCache, hasAlpha, 4)
end function

/*
* Function: UP_XbrzBlendPixel3
* Purpose: Controls xbrz Blend Pixel3 transitions in the HDWAD builder system.
*/
function UP_XbrzBlendPixel3(dst, dw, blockX, blockY, blendInfo, rot, pal, distCache, blendCache, hasAlpha, a0, b0, c0, d0, e0, f0, g0, h0, i0)
  blend = UP_XbrzRotateBlendInfo(blendInfo, rot)
  if UP_XbrzGetBottomR(blend) < UP_XBRZ_BLEND_NORMAL then return end if

  a = UP_XbrzRotGet(rot, 0, a0, b0, c0, d0, e0, f0, g0, h0, i0)
  b = UP_XbrzRotGet(rot, 1, a0, b0, c0, d0, e0, f0, g0, h0, i0)
  c = UP_XbrzRotGet(rot, 2, a0, b0, c0, d0, e0, f0, g0, h0, i0)
  d = UP_XbrzRotGet(rot, 3, a0, b0, c0, d0, e0, f0, g0, h0, i0)
  e = UP_XbrzRotGet(rot, 4, a0, b0, c0, d0, e0, f0, g0, h0, i0)
  f = UP_XbrzRotGet(rot, 5, a0, b0, c0, d0, e0, f0, g0, h0, i0)
  g = UP_XbrzRotGet(rot, 6, a0, b0, c0, d0, e0, f0, g0, h0, i0)
  h = UP_XbrzRotGet(rot, 7, a0, b0, c0, d0, e0, f0, g0, h0, i0)
  ii = UP_XbrzRotGet(rot, 8, a0, b0, c0, d0, e0, f0, g0, h0, i0)

  doLineBlend = true
  if UP_XbrzGetBottomR(blend) < UP_XBRZ_BLEND_DOMINANT then
    if UP_XbrzGetTopR(blend) != UP_XBRZ_BLEND_NONE and not UP_XbrzEq(pal, distCache, e, g, hasAlpha) then doLineBlend = false end if
    if UP_XbrzGetBottomL(blend) != UP_XBRZ_BLEND_NONE and not UP_XbrzEq(pal, distCache, e, c, hasAlpha) then doLineBlend = false end if
    if (not UP_XbrzEq(pal, distCache, e, ii, hasAlpha)) and UP_XbrzEq(pal, distCache, g, h, hasAlpha) and UP_XbrzEq(pal, distCache, h, ii, hasAlpha) and UP_XbrzEq(pal, distCache, ii, f, hasAlpha) and UP_XbrzEq(pal, distCache, f, c, hasAlpha) then
      doLineBlend = false
    end if
  end if

  px = h
  if UP_XbrzDistanceCached(pal, distCache, e, f, hasAlpha) <= UP_XbrzDistanceCached(pal, distCache, e, h, hasAlpha) then px = f end if

  if doLineBlend then
    fg = UP_XbrzDistanceCached(pal, distCache, f, g, hasAlpha)
    hc = UP_XbrzDistanceCached(pal, distCache, h, c, hasAlpha)
    haveShallowLine = UP_XBRZ_STEEP_DIRECTION_THRESHOLD * fg <= hc and e != g and d != g
    haveSteepLine = UP_XBRZ_STEEP_DIRECTION_THRESHOLD * hc <= fg and e != c and b != c
    if haveShallowLine then
      if haveSteepLine then
        UP_XbrzBlendLineSteepAndShallow3(dst, dw, blockX, blockY, rot, px, pal, blendCache, hasAlpha)
      else
        UP_XbrzBlendLineShallow3(dst, dw, blockX, blockY, rot, px, pal, blendCache, hasAlpha)
      end if
    else
      if haveSteepLine then
        UP_XbrzBlendLineSteep3(dst, dw, blockX, blockY, rot, px, pal, blendCache, hasAlpha)
      else
        UP_XbrzBlendLineDiagonal3(dst, dw, blockX, blockY, rot, px, pal, blendCache, hasAlpha)
      end if
    end if
  else
    UP_XbrzBlendCorner3(dst, dw, blockX, blockY, rot, px, pal, blendCache, hasAlpha)
  end if
end function

/*
* Function: UP_XbrzScaleIndexed3
* Purpose: Provides xBRZ scale indexed3 helper behavior for the HDWAD builder.
*/
function UP_XbrzScaleIndexed3(img, pal)
  if img is void then return void end if
  sw = img.width
  sh = img.height
  dw = sw * 3
  dh = sh * 3
  src = img.data
  dst = bytes(dw * dh, UP_TRANSPARENT_INDEX)
  hasAlpha =((img.flags & UP_FLAG_TRANSPARENT) != 0)
  blendCache = array(256 * 256 * 5, -1)
  distCache = array(256 * 256, -1.0)
  preProc = array(sw, 0)

  sy = 0
  while sy < sh
    if (sy & 7) == 0 then UP_LoadingPulse() end if
    sx = 0
    blend_xy1 = 0
    while sx < sw
      x_m1 = sx - 1
      if x_m1 < 0 then x_m1 = 0 end if
      x_p1 = sx + 1
      if x_p1 >= sw then x_p1 = sw - 1 end if
      x_p2 = sx + 2
      if x_p2 >= sw then x_p2 = sw - 1 end if
      y_m1 = sy - 1
      if y_m1 < 0 then y_m1 = 0 end if
      y_p1 = sy + 1
      if y_p1 >= sh then y_p1 = sh - 1 end if
      y_p2 = sy + 2
      if y_p2 >= sh then y_p2 = sh - 1 end if

      a = src[y_m1 * sw + x_m1]
      b = src[y_m1 * sw + sx]
      c = src[y_m1 * sw + x_p1]
      d = src[y_m1 * sw + x_p2]
      e = src[sy * sw + x_m1]
      f = src[sy * sw + sx]
      g = src[sy * sw + x_p1]
      h = src[sy * sw + x_p2]
      ii = src[y_p1 * sw + x_m1]
      j = src[y_p1 * sw + sx]
      k = src[y_p1 * sw + x_p1]
      l = src[y_p1 * sw + x_p2]
      m = src[y_p2 * sw + x_m1]
      n = src[y_p2 * sw + sx]
      o = src[y_p2 * sw + x_p1]
      p = src[y_p2 * sw + x_p2]

      res = UP_XbrzPreProcessCorners(pal, distCache, a, b, c, d, e, f, g, h, ii, j, k, l, m, n, o, p, hasAlpha)
      blend_xy = preProc[sx]
      blend_xy = UP_XbrzSetBottomR(blend_xy, res & 3)
      blend_xy1 = UP_XbrzSetTopR(blend_xy1, (res >> 4) & 3)
      preProc[sx] = blend_xy1
      blend_xy1 = UP_XbrzSetTopL(0, (res >> 6) & 3)
      if sx + 1 < sw then
        preProc[sx + 1] = UP_XbrzSetBottomL(preProc[sx + 1], (res >> 2) & 3)
      end if

      blockX = sx * 3
      blockY = sy * 3
      row = blockY * dw + blockX
      dst[row] = f
      dst[row + 1] = f
      dst[row + 2] = f
      row = row + dw
      dst[row] = f
      dst[row + 1] = f
      dst[row + 2] = f
      row = row + dw
      dst[row] = f
      dst[row + 1] = f
      dst[row + 2] = f

      if blend_xy != 0 then
        UP_XbrzBlendPixel3(dst, dw, blockX, blockY, blend_xy, 0, pal, distCache, blendCache, hasAlpha, a, b, c, e, f, g, ii, j, k)
        UP_XbrzBlendPixel3(dst, dw, blockX, blockY, blend_xy, 1, pal, distCache, blendCache, hasAlpha, a, b, c, e, f, g, ii, j, k)
        UP_XbrzBlendPixel3(dst, dw, blockX, blockY, blend_xy, 2, pal, distCache, blendCache, hasAlpha, a, b, c, e, f, g, ii, j, k)
        UP_XbrzBlendPixel3(dst, dw, blockX, blockY, blend_xy, 3, pal, distCache, blendCache, hasAlpha, a, b, c, e, f, g, ii, j, k)
      end if

      sx = sx + 1
    end while
    sy = sy + 1
  end while

  return up_image_t(img.kind, img.name, dw, dh, img.xoffset * 3, img.yoffset * 3, img.flags, dst)
end function

/*
* Function: UP_BestEdgeColor
* Purpose: Chooses the closer edge color for a corner blend.
*/
function UP_BestEdgeColor(pal, center, a, b, hasAlpha)
  da = UP_ColorDistance(pal, center, a, hasAlpha)
  db = UP_ColorDistance(pal, center, b, hasAlpha)
  if da <= db then return a end if
  return b
end function

/*
* Function: UP_BestEdgeColorCached
* Purpose: Chooses the closer edge color using cached palette distances.
*/
function UP_BestEdgeColorCached(pal, cache, center, a, b, hasAlpha)
  da = UP_ColorDistanceCached(pal, cache, center, a, hasAlpha)
  db = UP_ColorDistanceCached(pal, cache, center, b, hasAlpha)
  if da <= db then return a end if
  return b
end function

/*
* Function: UP_CornerWeight
* Purpose: Returns the local xBRZ corner blend weight for one block coordinate.
*/
function inline UP_CornerWeight(dist, scale)
  if dist >= scale then return 0 end if
  w = 3 - std.math.floor((dist * 3) / scale)
  if w < 1 then w = 1 end if
  if w > 3 then w = 3 end if
  return w
end function

/*
* Function: UP_BlendCorner
* Purpose: Applies a triangular xBRZ corner blend inside one scaled block.
*/
function UP_BlendCorner(dst, dw, blockX, blockY, scale, corner, base, edge, pal, cache, hasAlpha)
  yy = 0
  while yy < scale
    xx = 0
    while xx < scale
      dist = 0
      if corner == 0 then
        dist = xx + yy
      else if corner == 1 then
        dist =(scale - 1 - xx) + yy
      else if corner == 2 then
        dist = xx +(scale - 1 - yy)
      else
        dist =(scale - 1 - xx) +(scale - 1 - yy)
      end if

      weight = UP_CornerWeight(dist, scale)
      if weight > 0 then
        di =(blockY + yy) * dw + blockX + xx
        cur = dst[di]
        if cur != base then
          dst[di] = UP_BlendIndex(pal, cache, cur, edge, weight, hasAlpha)
        else
          dst[di] = UP_BlendIndex(pal, cache, base, edge, weight, hasAlpha)
        end if
      end if
      xx = xx + 1
    end while
    yy = yy + 1
  end while
end function

/*
* Function: UP_BlendEdgeRow
* Purpose: Blends one horizontal edge of a scaled block toward a neighboring edge color.
*/
function UP_BlendEdgeRow(dst, dw, blockX, blockY, scale, row, base, edge, pal, cache, hasAlpha, weight)
  if edge == base or UP_IsTransparent(edge, hasAlpha) then return end if
  yy = blockY + row
  xx = 0
  while xx < scale
    di = yy * dw + blockX + xx
    dst[di] = UP_BlendIndex(pal, cache, dst[di], edge, weight, hasAlpha)
    xx = xx + 1
  end while
end function

/*
* Function: UP_BlendEdgeColumn
* Purpose: Blends one vertical edge of a scaled block toward a neighboring edge color.
*/
function UP_BlendEdgeColumn(dst, dw, blockX, blockY, scale, col, base, edge, pal, cache, hasAlpha, weight)
  if edge == base or UP_IsTransparent(edge, hasAlpha) then return end if
  xx = blockX + col
  yy = 0
  while yy < scale
    di = (blockY + yy) * dw + xx
    dst[di] = UP_BlendIndex(pal, cache, dst[di], edge, weight, hasAlpha)
    yy = yy + 1
  end while
end function

/*
* Function: UP_StrongEdgeWeight
* Purpose: Chooses a slightly stronger blend for hard pixel-art edges.
*/
function inline UP_StrongEdgeWeight(pal, base, edge, hasAlpha)
  dist = UP_ColorDistance(pal, base, edge, hasAlpha)
  if dist > 26000 then return 2 end if
  return 1
end function

/*
* Function: UP_StrongEdgeWeightCached
* Purpose: Chooses blend strength using cached palette distances.
*/
function inline UP_StrongEdgeWeightCached(pal, cache, base, edge, hasAlpha)
  dist = UP_ColorDistanceCached(pal, cache, base, edge, hasAlpha)
  if dist > 26000 then return 2 end if
  return 1
end function

/*
* Function: UP_XbrzScaleIndexed
* Purpose: Scales an indexed image with palette-aware xBRZ-style edge reconstruction.
*/
function UP_XbrzScaleIndexed(img, scale, pal)
  if img is void then return void end if
  s = UP_ClampScale(scale)
  if s == 3 then return UP_XbrzScaleIndexed3(img, pal) end if
  sw = img.width
  sh = img.height
  dw = sw * s
  dh = sh * s
  src = img.data
  dst = bytes(dw * dh, UP_TRANSPARENT_INDEX)
  hasAlpha =((img.flags & UP_FLAG_TRANSPARENT) != 0)
  blendCache = array(256 * 256 * 4, -1)
  distCache = array(256 * 256, -1)

  sy = 0
  while sy < sh
    if (sy & 7) == 0 then UP_LoadingPulse() end if
    sx = 0
    while sx < sw
      a = UP_PixelAt(src, sw, sh, sx - 1, sy - 1)
      b = UP_PixelAt(src, sw, sh, sx, sy - 1)
      c = UP_PixelAt(src, sw, sh, sx + 1, sy - 1)
      d = UP_PixelAt(src, sw, sh, sx - 1, sy)
      e = UP_PixelAt(src, sw, sh, sx, sy)
      f = UP_PixelAt(src, sw, sh, sx + 1, sy)
      g = UP_PixelAt(src, sw, sh, sx - 1, sy + 1)
      h = UP_PixelAt(src, sw, sh, sx, sy + 1)
      ii = UP_PixelAt(src, sw, sh, sx + 1, sy + 1)

      blockX = sx * s
      blockY = sy * s
      yy = 0
      while yy < s
        row = (blockY + yy) * dw + blockX
        xx = 0
        while xx < s
          dst[row + xx] = e
          xx = xx + 1
        end while
        yy = yy + 1
      end while

      if (not UP_SimilarColorCached(pal, distCache, b, h, hasAlpha)) and(not UP_SimilarColorCached(pal, distCache, d, f, hasAlpha)) then
        if UP_SimilarColorCached(pal, distCache, d, b, hasAlpha) and(not UP_SimilarColorCached(pal, distCache, e, a, hasAlpha)) then
          edge = UP_BestEdgeColorCached(pal, distCache, e, d, b, hasAlpha)
          UP_BlendCorner(dst, dw, blockX, blockY, s, 0, e, edge, pal, blendCache, hasAlpha)
        end if
        if UP_SimilarColorCached(pal, distCache, b, f, hasAlpha) and(not UP_SimilarColorCached(pal, distCache, e, c, hasAlpha)) then
          edge = UP_BestEdgeColorCached(pal, distCache, e, b, f, hasAlpha)
          UP_BlendCorner(dst, dw, blockX, blockY, s, 1, e, edge, pal, blendCache, hasAlpha)
        end if
        if UP_SimilarColorCached(pal, distCache, d, h, hasAlpha) and(not UP_SimilarColorCached(pal, distCache, e, g, hasAlpha)) then
          edge = UP_BestEdgeColorCached(pal, distCache, e, d, h, hasAlpha)
          UP_BlendCorner(dst, dw, blockX, blockY, s, 2, e, edge, pal, blendCache, hasAlpha)
        end if
        if UP_SimilarColorCached(pal, distCache, h, f, hasAlpha) and(not UP_SimilarColorCached(pal, distCache, e, ii, hasAlpha)) then
          edge = UP_BestEdgeColorCached(pal, distCache, e, h, f, hasAlpha)
          UP_BlendCorner(dst, dw, blockX, blockY, s, 3, e, edge, pal, blendCache, hasAlpha)
        end if
      end if

      if not UP_IsTransparent(e, hasAlpha) then
        if (not UP_SimilarColorCached(pal, distCache, e, b, hasAlpha)) and(UP_SimilarColorCached(pal, distCache, d, b, hasAlpha) or UP_SimilarColorCached(pal, distCache, f, b, hasAlpha) or(not UP_SimilarColorCached(pal, distCache, d, f, hasAlpha))) then
          UP_BlendEdgeRow(dst, dw, blockX, blockY, s, 0, e, b, pal, blendCache, hasAlpha, UP_StrongEdgeWeightCached(pal, distCache, e, b, hasAlpha))
        end if
        if (not UP_SimilarColorCached(pal, distCache, e, h, hasAlpha)) and(UP_SimilarColorCached(pal, distCache, d, h, hasAlpha) or UP_SimilarColorCached(pal, distCache, f, h, hasAlpha) or(not UP_SimilarColorCached(pal, distCache, d, f, hasAlpha))) then
          UP_BlendEdgeRow(dst, dw, blockX, blockY, s, s - 1, e, h, pal, blendCache, hasAlpha, UP_StrongEdgeWeightCached(pal, distCache, e, h, hasAlpha))
        end if
        if (not UP_SimilarColorCached(pal, distCache, e, d, hasAlpha)) and(UP_SimilarColorCached(pal, distCache, b, d, hasAlpha) or UP_SimilarColorCached(pal, distCache, h, d, hasAlpha) or(not UP_SimilarColorCached(pal, distCache, b, h, hasAlpha))) then
          UP_BlendEdgeColumn(dst, dw, blockX, blockY, s, 0, e, d, pal, blendCache, hasAlpha, UP_StrongEdgeWeightCached(pal, distCache, e, d, hasAlpha))
        end if
        if (not UP_SimilarColorCached(pal, distCache, e, f, hasAlpha)) and(UP_SimilarColorCached(pal, distCache, b, f, hasAlpha) or UP_SimilarColorCached(pal, distCache, h, f, hasAlpha) or(not UP_SimilarColorCached(pal, distCache, b, h, hasAlpha))) then
          UP_BlendEdgeColumn(dst, dw, blockX, blockY, s, s - 1, e, f, pal, blendCache, hasAlpha, UP_StrongEdgeWeightCached(pal, distCache, e, f, hasAlpha))
        end if
      end if
      sx = sx + 1
    end while
    sy = sy + 1
  end while

  return up_image_t(img.kind, img.name, dw, dh, img.xoffset * s, img.yoffset * s, img.flags, dst)
end function

/*
* Function: UP_LoadWad
* Purpose: Reads a WAD and returns [data, lumps].
*/
function UP_LoadWad(path)
  dataTry = try(fs.readAllBytes(path))
  if typeof(dataTry) == "error" then
    print "HDWAD: could not read " + path
    return void
  end if
  data = dataTry
  if typeof(data) != "bytes" or len(data) < 12 then return void end if

  id = decode(slice(data, 0, 4))
  if id != "IWAD" and id != "PWAD" then
    print "HDWAD: not a WAD: " + path
    return void
  end if

  count = UP_ReadU32(data, 4)
  dirOfs = UP_ReadU32(data, 8)
  if count < 0 or dirOfs < 0 or dirOfs + count * 16 > len(data) then
    print "HDWAD: invalid WAD directory"
    return void
  end if

  lumps =[]
  i = 0
  while i < count
    off = dirOfs + i * 16
    pos = UP_ReadU32(data, off)
    size = UP_ReadU32(data, off + 4)
    name = UP_Name8(slice(data, off + 8, 8))
    lumps = lumps +[up_lump_t(name, pos, size)]
    i = i + 1
  end while

  return [data, lumps]
end function

/*
* Function: UP_AddFlatRange
* Purpose: Extracts flat images from a marker range.
*/
function UP_AddFlatRange(images, wadData, lumps, startName, endName, scale, pal)
  start = UP_FindMarker(lumps, startName)
  finish = UP_FindMarker(lumps, endName)
  if start < 0 or finish < 0 or finish <= start then return images end if

  i = start + 1
  while i < finish
    if (i & 15) == 0 then UP_LoadingPulse() end if
    l = lumps[i]
    if l.size == 4096 and l.filepos >= 0 and l.filepos + l.size <= len(wadData) then
      img = up_image_t(UP_TYPE_FLAT, l.name, 64, 64, 0, 0, 0, slice(wadData, l.filepos, l.size))
      images = images +[UP_XbrzScaleIndexed(img, scale, pal)]
    end if
    UP_ReportProgress(1)
    i = i + 1
  end while
  return images
end function

/*
* Function: UP_AddPatchRange
* Purpose: Extracts Doom patch images from a marker range.
*/
function UP_AddPatchRange(images, wadData, lumps, startName, endName, kind, scale, pal)
  start = UP_FindMarker(lumps, startName)
  finish = UP_FindMarker(lumps, endName)
  if start < 0 or finish < 0 or finish <= start then return images end if

  i = start + 1
  while i < finish
    if (i & 15) == 0 then UP_LoadingPulse() end if
    l = lumps[i]
    if l.size > 0 and l.filepos >= 0 and l.filepos + l.size <= len(wadData) then
      patch = UP_DecodePatch(l.name, kind, slice(wadData, l.filepos, l.size))
      if patch is not void then
        images = images +[UP_XbrzScaleIndexed(patch, scale, pal)]
      end if
    end if
    UP_ReportProgress(1)
    i = i + 1
  end while
  return images
end function

/*
* Function: UP_HasImage
* Purpose: Checks whether an image with the same kind/name was already emitted.
*/
function UP_HasImage(images, kind, name)
  n = UP_Name8(name)
  i = 0
  while i < len(images)
    img = images[i]
    if img is not void and img.kind == kind and img.name == n then return true end if
    i = i + 1
  end while
  return false
end function

/*
* Function: UP_IsMarkerName
* Purpose: Avoids trying marker/control lumps as patch images.
*/
function UP_IsMarkerName(name)
  if name == "" then return true end if
  if name == "P_START" or name == "P_END" or name == "PP_START" or name == "PP_END" then return true end if
  if name == "S_START" or name == "S_END" or name == "SS_START" or name == "SS_END" then return true end if
  if name == "F_START" or name == "F_END" or name == "FF_START" or name == "FF_END" then return true end if
  if name == "TEXTURE1" or name == "TEXTURE2" or name == "PNAMES" or name == "PLAYPAL" or name == "COLORMAP" then return true end if
  return false
end function

/*
* Function: UP_AddAllPatchLumps
* Purpose: Extracts all remaining Doom patch-format graphics such as HUD, menu, title, finale and fonts.
*/
function UP_AddAllPatchLumps(images, wadData, lumps, scale, pal)
  i = 0
  added = 0
  while i < len(lumps)
    if (i & 31) == 0 then UP_LoadingPulse() end if
    l = lumps[i]
    if l.size > 0 and l.filepos >= 0 and l.filepos + l.size <= len(wadData) and not UP_IsMarkerName(l.name) then
      if not UP_HasImage(images, UP_TYPE_PATCH, l.name) then
        patch = UP_DecodePatch(l.name, UP_TYPE_PATCH, slice(wadData, l.filepos, l.size))
        if patch is not void then
          images = images +[UP_XbrzScaleIndexed(patch, scale, pal)]
          added = added + 1
        end if
      end if
    end if
    UP_ReportProgress(1)
    i = i + 1
  end while
  if added > 0 then print "HDWAD: added " + added + " general patch graphics" end if
  return images
end function

/*
* Function: UP_AddTextureLump
* Purpose: Adds composited wall textures from TEXTURE1/TEXTURE2.
*/
function UP_AddTextureLump(images, wadData, lumps, lumpName, patchLookup, scale, pal)
  textures = UP_ParseTextureLump(wadData, lumps, lumpName, patchLookup)
  i = 0
  while i < len(textures)
    if (i & 7) == 0 then UP_LoadingPulse() end if
    img = UP_BuildTextureImage(textures[i], wadData, lumps)
    if img is not void then
      images = images +[UP_XbrzScaleIndexed(img, scale, pal)]
    end if
    UP_ReportProgress(1)
    i = i + 1
  end while
  return images
end function

/*
* Function: UP_CountMarkerRange
* Purpose: Counts WAD lumps between two marker names for progress estimation.
*/
function UP_CountMarkerRange(lumps, startName, endName)
  start = UP_FindMarker(lumps, startName)
  finish = UP_FindMarker(lumps, endName)
  if start < 0 or finish < 0 or finish <= start then return 0 end if
  return finish - start - 1
end function

/*
* Function: HDB_EstimateImageProgressUnits
* Purpose: Estimates the progress units emitted while HDWAD graphics are built.
*/
function HDB_EstimateImageProgressUnits(wadData, lumps, scale)
  patchLookup = UP_ParsePnames(wadData, lumps)
  total = len(UP_ParseTextureLump(wadData, lumps, "TEXTURE1", patchLookup))
  total = total + len(UP_ParseTextureLump(wadData, lumps, "TEXTURE2", patchLookup))
  total = total + UP_CountMarkerRange(lumps, "F_START", "F_END")
  total = total + UP_CountMarkerRange(lumps, "FF_START", "FF_END")
  total = total + UP_CountMarkerRange(lumps, "P_START", "P_END")
  total = total + UP_CountMarkerRange(lumps, "S_START", "S_END")
  total = total + UP_CountMarkerRange(lumps, "SS_START", "SS_END")
  total = total + len(lumps)
  if total < 1 then total = 1 end if
  return total
end function

/*
* Function: UP_WritePackage
* Purpose: Writes extracted images as a MiniDoom upscaled package.
*/
function UP_WritePackage(path, images, scale)
  count = len(images)
  pixelBytes = 0
  i = 0
  while i < count
    if images[i] is not void and typeof(images[i].data) == "bytes" then
      pixelBytes = pixelBytes + len(images[i].data)
    end if
    i = i + 1
  end while

  headerSize = 20
  dirSize = count * 40
  dataOfs = headerSize
  dirOfs = headerSize + pixelBytes
  totalSize = headerSize + pixelBytes + dirSize
  packageBytes = bytes(totalSize, 0)

  packageBytes[0] = UP_MAGIC0
  packageBytes[1] = UP_MAGIC1
  packageBytes[2] = UP_MAGIC2
  packageBytes[3] = UP_MAGIC3
  UP_WriteU32(packageBytes, 4, UP_VERSION)
  UP_WriteU32(packageBytes, 8, UP_ClampScale(scale))
  UP_WriteU32(packageBytes, 12, count)
  UP_WriteU32(packageBytes, 16, dirOfs)

  i = 0
  curData = dataOfs
  while i < count
    img = images[i]
    dir = dirOfs + i * 40
    dataSize = 0
    if img is not void and typeof(img.data) == "bytes" then
      dataSize = len(img.data)
      UP_CopyBytes(packageBytes, curData, img.data, 0, dataSize)
    end if

    UP_WriteU32(packageBytes, dir + 0, img.kind)
    nameBytes = bytes(img.name)
    n = len(nameBytes)
    if n > 8 then n = 8 end if
    j = 0
    while j < n
      packageBytes[dir + 4 + j] = nameBytes[j]
      j = j + 1
    end while
    UP_WriteU32(packageBytes, dir + 12, img.width)
    UP_WriteU32(packageBytes, dir + 16, img.height)
    UP_WriteU32(packageBytes, dir + 20, img.xoffset)
    UP_WriteU32(packageBytes, dir + 24, img.yoffset)
    UP_WriteU32(packageBytes, dir + 28, img.flags)
    UP_WriteU32(packageBytes, dir + 32, curData)
    UP_WriteU32(packageBytes, dir + 36, dataSize)
    curData = curData + dataSize
    i = i + 1
  end while

  wr = fs.writeAllBytes(path, packageBytes)
  if typeof(wr) == "error" then
    print "HDWAD: write failed: " + wr.message
    return false
  end if
  print "HDWAD: wrote legacy upscaled package " + path + " (" + count + " images, xBRZ scale " + scale + "x)"
  return true
end function

/*
* Function: UP_WriteHDWADPackage
* Purpose: Writes HDWAD package data for the HDWAD builder.
*/
function UP_WriteHDWADPackage(path, wadData, lumps, images, scale)
  return UP_WriteHDWADPackageWithExtraLumps(path, wadData, lumps, images, [], [], scale)
end function

/*
* Function: UP_WriteHDWADPackageWithExtraLumps
* Purpose: Writes HDWAD package with extra lumps data for the HDWAD builder.
*/
function UP_WriteHDWADPackageWithExtraLumps(path, wadData, lumps, images, extraNames, extraDatas, scale)
  lumpCount = len(lumps)
  extraCount = 0
  if typeof(extraNames) == "array" and typeof(extraDatas) == "array" then
    extraCount = len(extraNames)
    if len(extraDatas) < extraCount then extraCount = len(extraDatas) end if
  end if
  totalLumpCount = lumpCount + extraCount
  imageCount = len(images)

  lumpBytes = 0
  i = 0
  while i < lumpCount
    l = lumps[i]
    if l is not void and typeof(l.size) == "int" and l.size > 0 then lumpBytes = lumpBytes + l.size end if
    i = i + 1
  end while
  i = 0
  while i < extraCount
    if typeof(extraDatas[i]) == "bytes" then lumpBytes = lumpBytes + len(extraDatas[i]) end if
    i = i + 1
  end while

  imageBytes = 0
  i = 0
  while i < imageCount
    if images[i] is not void and typeof(images[i].data) == "bytes" then
      imageBytes = imageBytes + len(images[i].data)
    end if
    i = i + 1
  end while

  headerSize = 28
  lumpDirSize = totalLumpCount * 16
  imageDirSize = imageCount * 40
  dataOfs = headerSize
  lumpDirOfs = headerSize + lumpBytes + imageBytes
  imageDirOfs = lumpDirOfs + lumpDirSize
  totalSize = imageDirOfs + imageDirSize
  packageBytes = bytes(totalSize, 0)

  packageBytes[0] = HD_MAGIC0
  packageBytes[1] = HD_MAGIC1
  packageBytes[2] = HD_MAGIC2
  packageBytes[3] = HD_MAGIC3
  UP_WriteU32(packageBytes, 4, UP_VERSION)
  UP_WriteU32(packageBytes, 8, UP_ClampScale(scale))
  UP_WriteU32(packageBytes, 12, totalLumpCount)
  UP_WriteU32(packageBytes, 16, imageCount)
  UP_WriteU32(packageBytes, 20, lumpDirOfs)
  UP_WriteU32(packageBytes, 24, imageDirOfs)

  curData = dataOfs
  i = 0
  while i < lumpCount
    l = lumps[i]
    dir = lumpDirOfs + i * 16
    dataSize = 0
    if l is not void and typeof(l.size) == "int" and l.size > 0 then
      dataSize = l.size
      UP_CopyBytes(packageBytes, curData, wadData, l.filepos, dataSize)
    end if
    UP_WriteU32(packageBytes, dir + 0, curData)
    UP_WriteU32(packageBytes, dir + 4, dataSize)
    nameBytes = bytes(l.name)
    n = len(nameBytes)
    if n > 8 then n = 8 end if
    j = 0
    while j < n
      packageBytes[dir + 8 + j] = nameBytes[j]
      j = j + 1
    end while
    curData = curData + dataSize
    i = i + 1
  end while

  i = 0
  while i < extraCount
    extraData = extraDatas[i]
    dir = lumpDirOfs + (lumpCount + i) * 16
    dataSize = 0
    if typeof(extraData) == "bytes" then
      dataSize = len(extraData)
      UP_CopyBytes(packageBytes, curData, extraData, 0, dataSize)
    end if
    UP_WriteU32(packageBytes, dir + 0, curData)
    UP_WriteU32(packageBytes, dir + 4, dataSize)
    nameBytes = bytes(UP_Name8(extraNames[i]))
    n = len(nameBytes)
    if n > 8 then n = 8 end if
    j = 0
    while j < n
      packageBytes[dir + 8 + j] = nameBytes[j]
      j = j + 1
    end while
    curData = curData + dataSize
    i = i + 1
  end while

  i = 0
  while i < imageCount
    img = images[i]
    dir = imageDirOfs + i * 40
    dataSize = 0
    if img is not void and typeof(img.data) == "bytes" then
      dataSize = len(img.data)
      UP_CopyBytes(packageBytes, curData, img.data, 0, dataSize)
    end if

    UP_WriteU32(packageBytes, dir + 0, img.kind)
    nameBytes = bytes(img.name)
    n = len(nameBytes)
    if n > 8 then n = 8 end if
    j = 0
    while j < n
      packageBytes[dir + 4 + j] = nameBytes[j]
      j = j + 1
    end while
    UP_WriteU32(packageBytes, dir + 12, img.width)
    UP_WriteU32(packageBytes, dir + 16, img.height)
    UP_WriteU32(packageBytes, dir + 20, img.xoffset)
    UP_WriteU32(packageBytes, dir + 24, img.yoffset)
    UP_WriteU32(packageBytes, dir + 28, img.flags)
    UP_WriteU32(packageBytes, dir + 32, curData)
    UP_WriteU32(packageBytes, dir + 36, dataSize)
    curData = curData + dataSize
    i = i + 1
  end while

  wr = fs.writeAllBytes(path, packageBytes)
  if typeof(wr) == "error" then
    print "HDWAD: write failed: " + wr.message
    return false
  end if
  print "HDWAD: wrote " + path + " (" + totalLumpCount + " lumps, " + imageCount + " HD images, " + extraCount + " GL maps, xBRZ scale " + scale + "x)"
  return true
end function

/*
* Function: HDB_BuildImages
* Purpose: Provides build images helper behavior for the HDWAD builder.
*/
function HDB_BuildImages(wadData, lumps, scale)
  UP_LoadingPulse()
  pal = UP_LoadPalette(wadData, lumps)
  patchLookup = UP_ParsePnames(wadData, lumps)
  images =[]

  images = UP_AddTextureLump(images, wadData, lumps, "TEXTURE1", patchLookup, scale, pal)
  UP_LoadingPulse()
  images = UP_AddTextureLump(images, wadData, lumps, "TEXTURE2", patchLookup, scale, pal)
  UP_LoadingPulse()
  images = UP_AddFlatRange(images, wadData, lumps, "F_START", "F_END", scale, pal)
  images = UP_AddFlatRange(images, wadData, lumps, "FF_START", "FF_END", scale, pal)
  UP_LoadingPulse()
  images = UP_AddPatchRange(images, wadData, lumps, "P_START", "P_END", UP_TYPE_PATCH, scale, pal)
  images = UP_AddPatchRange(images, wadData, lumps, "S_START", "S_END", UP_TYPE_SPRITE, scale, pal)
  images = UP_AddPatchRange(images, wadData, lumps, "SS_START", "SS_END", UP_TYPE_SPRITE, scale, pal)
  UP_LoadingPulse()
  images = UP_AddAllPatchLumps(images, wadData, lumps, scale, pal)
  UP_LoadingPulse()
  return images
end function

/*
* Function: HDB_LoadWadForBuild
* Purpose: Provides load WAD for build helper behavior for the HDWAD builder.
*/
function HDB_LoadWadForBuild(path)
  return UP_LoadWad(path)
end function

/*
* Function: HDB_WriteHDWAD
* Purpose: Writes HDWAD data for the HDWAD builder.
*/
function HDB_WriteHDWAD(path, wadData, lumps, images, extraNames, extraDatas, scale)
  return UP_WriteHDWADPackageWithExtraLumps(path, wadData, lumps, images, extraNames, extraDatas, scale)
end function

/*
* Function: HDB_LegacyToolMain
* Purpose: Legacy helper kept for manual module testing.
*/
function HDB_LegacyToolMain(args)
  if typeof(args) != "array" or len(args) < 1 then
    print "Usage: hdwad_builder <input.wad> [output.hdwad] [scale]"
    return 1
  end if

  inPath = args[0]
  outPath = inPath + ".hdwad"
  if len(args) >= 2 then outPath = args[1] end if
  scale = 2
  if len(args) >= 3 then scale = UP_ClampScale(args[2]) end if

  loaded = UP_LoadWad(inPath)
  if loaded is void then return 1 end if

  wadData = loaded[0]
  lumps = loaded[1]
  pal = UP_LoadPalette(wadData, lumps)
  patchLookup = UP_ParsePnames(wadData, lumps)
  images =[]

  images = UP_AddTextureLump(images, wadData, lumps, "TEXTURE1", patchLookup, scale, pal)
  images = UP_AddTextureLump(images, wadData, lumps, "TEXTURE2", patchLookup, scale, pal)
  images = UP_AddFlatRange(images, wadData, lumps, "F_START", "F_END", scale, pal)
  images = UP_AddFlatRange(images, wadData, lumps, "FF_START", "FF_END", scale, pal)
  images = UP_AddPatchRange(images, wadData, lumps, "P_START", "P_END", UP_TYPE_PATCH, scale, pal)
  images = UP_AddPatchRange(images, wadData, lumps, "S_START", "S_END", UP_TYPE_SPRITE, scale, pal)
  images = UP_AddPatchRange(images, wadData, lumps, "SS_START", "SS_END", UP_TYPE_SPRITE, scale, pal)
  images = UP_AddAllPatchLumps(images, wadData, lumps, scale, pal)

  if len(images) == 0 then
    print "HDWAD: no graphics extracted"
    return 1
  end if

  outUpper = UP_Name8(outPath)
  isOldUpscaled = false
  ob = bytes(outPath)
  if len(ob) >= 9 then
    tail = decode(slice(ob, len(ob) - 9, 9))
    if tail == ".UPSCALED" or tail == ".upscaled" then isOldUpscaled = true end if
  end if
  if isOldUpscaled then
    if not UP_WritePackage(outPath, images, scale) then return 1 end if
  else
    if not UP_WriteHDWADPackage(outPath, wadData, lumps, images, scale) then return 1 end if
  end if
  return 0
end function
