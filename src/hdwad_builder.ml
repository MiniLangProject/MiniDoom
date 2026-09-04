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

//! Builds MiniDoom HDWAD cache files inside the game executable.

import std.fs as fs
import std.math

/// Defines up magic0 for the hdwad builder subsystem.
const UP_MAGIC0 = 77
/// Defines up magic1 for the hdwad builder subsystem.
const UP_MAGIC1 = 68
/// Defines up magic2 for the hdwad builder subsystem.
const UP_MAGIC2 = 85
/// Defines up magic3 for the hdwad builder subsystem.
const UP_MAGIC3 = 80
/// Defines hd magic0 for the hdwad builder subsystem.
const HD_MAGIC0 = 77
/// Defines hd magic1 for the hdwad builder subsystem.
const HD_MAGIC1 = 68
/// Defines hd magic2 for the hdwad builder subsystem.
const HD_MAGIC2 = 72
/// Defines hd magic3 for the hdwad builder subsystem.
const HD_MAGIC3 = 68
/// Defines up version for the hdwad builder subsystem.
const UP_VERSION = 6

/// Defines up type patch for the hdwad builder subsystem.
const UP_TYPE_PATCH = 1
/// Defines up type flat for the hdwad builder subsystem.
const UP_TYPE_FLAT = 2
/// Defines up type texture for the hdwad builder subsystem.
const UP_TYPE_TEXTURE = 3
/// Defines up type sprite for the hdwad builder subsystem.
const UP_TYPE_SPRITE = 4

/// Defines up flag transparent for the hdwad builder subsystem.
const UP_FLAG_TRANSPARENT = 1
/// Defines up transparent index for the hdwad builder subsystem.
const UP_TRANSPARENT_INDEX = 255
/// Defines up opaque 255 remap for the hdwad builder subsystem.
const UP_OPAQUE_255_REMAP = 254
/// Defines up xbrz dist limit for the hdwad builder subsystem.
const UP_XBRZ_DIST_LIMIT = 4200
/// Defines up xbrz blend none for the hdwad builder subsystem.
const UP_XBRZ_BLEND_NONE = 0
/// Defines up xbrz blend normal for the hdwad builder subsystem.
const UP_XBRZ_BLEND_NORMAL = 1
/// Defines up xbrz blend dominant for the hdwad builder subsystem.
const UP_XBRZ_BLEND_DOMINANT = 2
/// Defines the Doom palette selection for up xbrz equal color tolerance.
const UP_XBRZ_EQUAL_COLOR_TOLERANCE = 30.0
/// Defines up xbrz dominant direction threshold for the hdwad builder subsystem.
const UP_XBRZ_DOMINANT_DIRECTION_THRESHOLD = 3.6
/// Defines up xbrz steep direction threshold for the hdwad builder subsystem.
const UP_XBRZ_STEEP_DIRECTION_THRESHOLD = 2.2

/// Pumps the host window while HDWAD generation performs long CPU-bound work.
function inline UP_LoadingPulse()
  if typeof(I_LoadingPulse) == "function" then I_LoadingPulse() end if
end function

/// Reports one or more HDWAD generation units to the frontend progress display.
/// @param units Units value supplied to `UP_ReportProgress`.
function inline UP_ReportProgress(units)
  if typeof(D_HDWADProgressStep) == "function" then
    D_HDWADProgressStep(units)
  else
    UP_LoadingPulse()
  end if
end function

/// Stores one WAD directory entry.
struct up_lump_t
  /// Stable resource or object name stored by `up_lump_t`
  name
  /// Stores filepos for `up_lump_t`
  filepos
  /// Stores size for `up_lump_t`
  size
end struct

/// Stores one extracted image for the output package.
struct up_image_t
  /// Stores kind for `up_image_t`
  kind
  /// Stable resource or object name stored by `up_image_t`
  name
  /// Width in pixels or map units stored by `up_image_t`
  width
  /// Height in pixels or map units stored by `up_image_t`
  height
  /// Stores xoffset for `up_image_t`
  xoffset
  /// Stores yoffset for `up_image_t`
  yoffset
  /// Bit flags controlling this record's behavior stored by `up_image_t`
  flags
  /// Payload owned or referenced by this record stored by `up_image_t`
  data
end struct

/// Stores one patch placement inside a wall texture.
struct up_texpatch_t
  /// Stores originx for `up_texpatch_t`
  originx
  /// Stores originy for `up_texpatch_t`
  originy
  /// Stores patch for `up_texpatch_t`
  patch
end struct

/// Stores one parsed TEXTURE1/TEXTURE2 definition.
struct up_texture_t
  /// Stable resource or object name stored by `up_texture_t`
  name
  /// Width in pixels or map units stored by `up_texture_t`
  width
  /// Height in pixels or map units stored by `up_texture_t`
  height
  /// Stores patches for `up_texture_t`
  patches
end struct

/// Reads a little-endian u16.
/// @param b Second input operand.
/// @param off Zero-based byte or element offset.
function inline UP_ReadU16(b, off)
  return b[off] +(b[off + 1] << 8)
end function

/// Reads a little-endian s16.
/// @param b Second input operand.
/// @param off Zero-based byte or element offset.
function inline UP_ReadS16(b, off)
  v = UP_ReadU16(b, off)
  if v >= 32768 then v = v - 65536 end if
  return v
end function

/// Reads a little-endian u32.
/// @param b Second input operand.
/// @param off Zero-based byte or element offset.
function inline UP_ReadU32(b, off)
  return b[off] +(b[off + 1] << 8) +(b[off + 2] << 16) +(b[off + 3] << 24)
end function

/// Reads a little-endian s32.
/// @param b Second input operand.
/// @param off Zero-based byte or element offset.
function inline UP_ReadS32(b, off)
  v = UP_ReadU32(b, off)
  if v >= 2147483648 then v = v - 4294967296 end if
  return v
end function

/// Writes a little-endian u32.
/// @param b Second input operand.
/// @param off Zero-based byte or element offset.
/// @param value Value consumed by the operation.
function inline UP_WriteU32(b, off, value)
  if value < 0 then value = value + 4294967296 end if
  b[off] = value & 255
  b[off + 1] =(value >> 8) & 255
  b[off + 2] =(value >> 16) & 255
  b[off + 3] =(value >> 24) & 255
end function

/// Converts a value to int with fallback.
/// @param v Value consumed by the operation.
/// @param fallback Value returned when the requested conversion or lookup is unavailable.
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

/// Keeps output scale inside the supported package range.
/// @param v Value consumed by the operation.
function inline UP_ClampScale(v)
  s = UP_ToIntOr(v, 2)
  if s < 2 then s = 2 end if
  if s > 4 then s = 4 end if
  return s
end function

/// Decodes a WAD name.
/// @param b Second input operand.
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

/// Copies a byte range.
/// @param dst Dst value supplied to `UP_CopyBytes`.
/// @param dstOff Dst off value supplied to `UP_CopyBytes`.
/// @param src Src value supplied to `UP_CopyBytes`.
/// @param srcOff Src off value supplied to `UP_CopyBytes`.
/// @param count Number of elements or iterations to process.
function UP_CopyBytes(dst, dstOff, src, srcOff, count)
  i = 0
  while i < count
    dst[dstOff + i] = src[srcOff + i]
    i = i + 1
  end while
end function

/// Finds the first lump marker with the given name.
/// @param lumps Lumps value supplied to `UP_FindMarker`.
/// @param name Resource or object name to resolve.
function UP_FindMarker(lumps, name)
  n = UP_Name8(name)
  i = 0
  while i < len(lumps)
    if lumps[i].name == n then return i end if
    i = i + 1
  end while
  return -1
end function

/// Finds a lump by name.
/// @param lumps Lumps value supplied to `UP_FindLump`.
/// @param name Resource or object name to resolve.
function UP_FindLump(lumps, name)
  n = UP_Name8(name)
  i = len(lumps) - 1
  while i >= 0
    if lumps[i].name == n then return i end if
    i = i - 1
  end while
  return -1
end function

/// Returns a lump payload or void.
/// @param wadData Wad data value supplied to `UP_LumpBytes`.
/// @param lumps Lumps value supplied to `UP_LumpBytes`.
/// @param idx Zero-based element or table index.
function UP_LumpBytes(wadData, lumps, idx)
  if typeof(idx) != "int" or idx < 0 or idx >= len(lumps) then return void end if
  l = lumps[idx]
  if l.filepos < 0 or l.size < 0 or l.filepos + l.size > len(wadData) then return void end if
  return slice(wadData, l.filepos, l.size)
end function

/// Builds a grayscale fallback palette.
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

/// Extracts the first PLAYPAL palette from the WAD.
/// @param wadData Wad data value supplied to `UP_LoadPalette`.
/// @param lumps Lumps value supplied to `UP_LoadPalette`.
function UP_LoadPalette(wadData, lumps)
  idx = UP_FindLump(lumps, "PLAYPAL")
  if idx < 0 then return UP_DefaultPalette() end if
  l = lumps[idx]
  if l.size < 768 or l.filepos < 0 or l.filepos + 768 > len(wadData) then
    return UP_DefaultPalette()
  end if
  return slice(wadData, l.filepos, 768)
end function

/// Performs conservative validation for Doom patch data.
/// @param data Binary or structured data to process.
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

/// Converts a Doom patch lump into a palettized rectangular image.
/// @param name Resource or object name to resolve.
/// @param kind Kind value supplied to `UP_DecodePatch`.
/// @param lumpData Lump data value supplied to `UP_DecodePatch`.
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

/// Builds PNAMES patch-name to lump-index mapping.
/// @param wadData Wad data value supplied to `UP_ParsePnames`.
/// @param lumps Lumps value supplied to `UP_ParsePnames`.
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

/// Parses TEXTURE1/TEXTURE2 wall texture definitions.
/// @param wadData Wad data value supplied to `UP_ParseTextureLump`.
/// @param lumps Lumps value supplied to `UP_ParseTextureLump`.
/// @param lumpName Lump name value supplied to `UP_ParseTextureLump`.
/// @param patchLookup Patch lookup value supplied to `UP_ParseTextureLump`.
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

/// Draws a decoded patch image into an indexed texture canvas.
/// @param patch Patch value supplied to `UP_DrawPatchToTexture`.
/// @param canvas Canvas value supplied to `UP_DrawPatchToTexture`.
/// @param texW Tex w value supplied to `UP_DrawPatchToTexture`.
/// @param texH Tex h value supplied to `UP_DrawPatchToTexture`.
/// @param originX Horizontal coordinate or vector component represented by origin x.
/// @param originY Vertical coordinate or vector component represented by origin y.
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

/// Composites a wall texture from its source patch placements.
/// @param tex Texture identifier or texture data to process.
/// @param wadData Wad data value supplied to `UP_BuildTextureImage`.
/// @param lumps Lumps value supplied to `UP_BuildTextureImage`.
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

/// Checks whether an indexed pixel is transparent for patch-like images.
/// @param idx Zero-based element or table index.
/// @param hasAlpha Whether has alpha holds.
function inline UP_IsTransparent(idx, hasAlpha)
  return hasAlpha and idx == UP_TRANSPARENT_INDEX
end function

/// Computes weighted RGB distance for xBRZ edge decisions.
/// @param pal Pal value supplied to `UP_ColorDistance`.
/// @param a First input operand.
/// @param b Second input operand.
/// @param hasAlpha Whether has alpha holds.
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

/// Computes palette distance with a per-image 256x256 cache.
/// @param pal Pal value supplied to `UP_ColorDistanceCached`.
/// @param cache Cache value supplied to `UP_ColorDistanceCached`.
/// @param a First input operand.
/// @param b Second input operand.
/// @param hasAlpha Whether has alpha holds.
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

/// Evaluates xBRZ-style color equality with a distance threshold.
/// @param pal Pal value supplied to `UP_SimilarColor`.
/// @param a First input operand.
/// @param b Second input operand.
/// @param hasAlpha Whether has alpha holds.
function inline UP_SimilarColor(pal, a, b, hasAlpha)
  return UP_ColorDistance(pal, a, b, hasAlpha) <= UP_XBRZ_DIST_LIMIT
end function

/// Evaluates xBRZ-style equality using the per-image distance cache.
/// @param pal Pal value supplied to `UP_SimilarColorCached`.
/// @param cache Cache value supplied to `UP_SimilarColorCached`.
/// @param a First input operand.
/// @param b Second input operand.
/// @param hasAlpha Whether has alpha holds.
function inline UP_SimilarColorCached(pal, cache, a, b, hasAlpha)
  return UP_ColorDistanceCached(pal, cache, a, b, hasAlpha) <= UP_XBRZ_DIST_LIMIT
end function

/// Reads a clamped source pixel.
/// @param src Src value supplied to `UP_PixelAt`.
/// @param w W value supplied to `UP_PixelAt`.
/// @param h H value supplied to `UP_PixelAt`.
/// @param x Horizontal map- or screen-space coordinate.
/// @param y Vertical map- or screen-space coordinate.
function inline UP_PixelAt(src, w, h, x, y)
  if x < 0 then x = 0 end if
  if y < 0 then y = 0 end if
  if x >= w then x = w - 1 end if
  if y >= h then y = h - 1 end if
  return src[y * w + x]
end function

/// Quantizes an RGB color back to the Doom palette.
/// @param pal Pal value supplied to `UP_NearestPaletteIndex`.
/// @param r R value supplied to `UP_NearestPaletteIndex`.
/// @param g G value supplied to `UP_NearestPaletteIndex`.
/// @param b Second input operand.
/// @param hasAlpha Whether has alpha holds.
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

/// Blends two palette indices and quantizes the result.
/// @param pal Pal value supplied to `UP_BlendIndex`.
/// @param cache Cache value supplied to `UP_BlendIndex`.
/// @param base Base value supplied to `UP_BlendIndex`.
/// @param edge Edge value supplied to `UP_BlendIndex`.
/// @param edgeWeight Edge weight value supplied to `UP_BlendIndex`.
/// @param hasAlpha Whether has alpha holds.
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

/// Computes the palette distance used by the original xBRZ rules.
/// @param pal Pal value supplied to `UP_XbrzDistanceCached`.
/// @param cache Cache value supplied to `UP_XbrzDistanceCached`.
/// @param a First input operand.
/// @param b Second input operand.
/// @param hasAlpha Whether has alpha holds.
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

/// Tests palette equality using xBRZ's perceptual tolerance.
/// @param pal Pal value supplied to `UP_XbrzEq`.
/// @param cache Cache value supplied to `UP_XbrzEq`.
/// @param a First input operand.
/// @param b Second input operand.
/// @param hasAlpha Whether has alpha holds.
function inline UP_XbrzEq(pal, cache, a, b, hasAlpha)
  return UP_XbrzDistanceCached(pal, cache, a, b, hasAlpha) < UP_XBRZ_EQUAL_COLOR_TOLERANCE
end function

/// Controls blend Index Ratio transitions in the HDWAD builder system.
/// @param pal Pal value supplied to `UP_BlendIndexRatio`.
/// @param cache Cache value supplied to `UP_BlendIndexRatio`.
/// @param base Base value supplied to `UP_BlendIndexRatio`.
/// @param edge Edge value supplied to `UP_BlendIndexRatio`.
/// @param ratioCode Ratio code value supplied to `UP_BlendIndexRatio`.
/// @param hasAlpha Whether has alpha holds.
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

/// Extracts the two-bit top-left corner blend classification from a packed xBRZ blend byte.
/// @param b Second input operand.
function inline UP_XbrzGetTopL(b)
  return b & 3
end function

/// Extracts the two-bit top-right corner blend classification from a packed xBRZ blend byte.
/// @param b Second input operand.
function inline UP_XbrzGetTopR(b)
  return (b >> 2) & 3
end function

/// Extracts the two-bit bottom-right corner blend classification from a packed xBRZ blend byte.
/// @param b Second input operand.
function inline UP_XbrzGetBottomR(b)
  return (b >> 4) & 3
end function

/// Extracts the two-bit bottom-left corner blend classification from a packed xBRZ blend byte.
/// @param b Second input operand.
function inline UP_XbrzGetBottomL(b)
  return (b >> 6) & 3
end function

/// Adds a top-left two-bit classification to a packed xBRZ blend byte.
/// @param b Second input operand.
/// @param bt Bt value supplied to `UP_XbrzSetTopL`.
function inline UP_XbrzSetTopL(b, bt)
  return b | bt
end function

/// Adds a top-right two-bit classification to a packed xBRZ blend byte.
/// @param b Second input operand.
/// @param bt Bt value supplied to `UP_XbrzSetTopR`.
function inline UP_XbrzSetTopR(b, bt)
  return b |(bt << 2)
end function

/// Adds a bottom-right two-bit classification to a packed xBRZ blend byte.
/// @param b Second input operand.
/// @param bt Bt value supplied to `UP_XbrzSetBottomR`.
function inline UP_XbrzSetBottomR(b, bt)
  return b |(bt << 4)
end function

/// Adds a bottom-left two-bit classification to a packed xBRZ blend byte.
/// @param b Second input operand.
/// @param bt Bt value supplied to `UP_XbrzSetBottomL`.
function inline UP_XbrzSetBottomL(b, bt)
  return b |(bt << 6)
end function

/// Controls xbrz Rotate Blend Info transitions in the HDWAD builder system.
/// @param b Second input operand.
/// @param rot Rot value supplied to `UP_XbrzRotateBlendInfo`.
function UP_XbrzRotateBlendInfo(b, rot)
  if rot == 1 then return ((b << 2) |(b >> 6)) & 255 end if
  if rot == 2 then return ((b << 4) |(b >> 4)) & 255 end if
  if rot == 3 then return ((b << 6) |(b >> 2)) & 255 end if
  return b
end function

/// Compares color-distance paths through a 4x4 neighborhood and classifies normal or dominant edge blends for
/// the central corners.
/// @param pal Pal value supplied to `UP_XbrzPreProcessCorners`.
/// @param cache Cache value supplied to `UP_XbrzPreProcessCorners`.
/// @param a First input operand.
/// @param b Second input operand.
/// @param c C value supplied to `UP_XbrzPreProcessCorners`.
/// @param d Divisor or direction value used by the operation.
/// @param e E value supplied to `UP_XbrzPreProcessCorners`.
/// @param f F value supplied to `UP_XbrzPreProcessCorners`.
/// @param g G value supplied to `UP_XbrzPreProcessCorners`.
/// @param h H value supplied to `UP_XbrzPreProcessCorners`.
/// @param ii Ii value supplied to `UP_XbrzPreProcessCorners`.
/// @param j Secondary zero-based iteration index.
/// @param k K value supplied to `UP_XbrzPreProcessCorners`.
/// @param l L value supplied to `UP_XbrzPreProcessCorners`.
/// @param m M value supplied to `UP_XbrzPreProcessCorners`.
/// @param n Number of values to process.
/// @param o O value supplied to `UP_XbrzPreProcessCorners`.
/// @param p Object or data record consumed by the operation.
/// @param hasAlpha Whether has alpha holds.
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

/// Returns a 3x3 neighborhood sample through a requested quarter-turn so one blend kernel handles all four
/// orientations.
/// @param rot Rot value supplied to `UP_XbrzRotGet`.
/// @param pos Pos value supplied to `UP_XbrzRotGet`.
/// @param a First input operand.
/// @param b Second input operand.
/// @param c C value supplied to `UP_XbrzRotGet`.
/// @param d Divisor or direction value used by the operation.
/// @param e E value supplied to `UP_XbrzRotGet`.
/// @param f F value supplied to `UP_XbrzRotGet`.
/// @param g G value supplied to `UP_XbrzRotGet`.
/// @param h H value supplied to `UP_XbrzRotGet`.
/// @param ii Ii value supplied to `UP_XbrzRotGet`.
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

/// Rotates a 3x3 xBRZ neighbor coordinate and returns its linear index in the source image.
/// @param dw Dw value supplied to `UP_XbrzRefIndex3`.
/// @param blockX Horizontal coordinate or vector component represented by block x.
/// @param blockY Vertical coordinate or vector component represented by block y.
/// @param rot Rot value supplied to `UP_XbrzRefIndex3`.
/// @param i Zero-based iteration index.
/// @param j Secondary zero-based iteration index.
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

/// Controls xbrz Blend Ref3 transitions in the HDWAD builder system.
/// @param dst Dst value supplied to `UP_XbrzBlendRef3`.
/// @param dw Dw value supplied to `UP_XbrzBlendRef3`.
/// @param blockX Horizontal coordinate or vector component represented by block x.
/// @param blockY Vertical coordinate or vector component represented by block y.
/// @param rot Rot value supplied to `UP_XbrzBlendRef3`.
/// @param i Zero-based iteration index.
/// @param j Secondary zero-based iteration index.
/// @param col Col value supplied to `UP_XbrzBlendRef3`.
/// @param pal Pal value supplied to `UP_XbrzBlendRef3`.
/// @param blendCache Blend cache value supplied to `UP_XbrzBlendRef3`.
/// @param hasAlpha Whether has alpha holds.
/// @param ratioCode Ratio code value supplied to `UP_XbrzBlendRef3`.
function UP_XbrzBlendRef3(dst, dw, blockX, blockY, rot, i, j, col, pal, blendCache, hasAlpha, ratioCode)
  idx = UP_XbrzRefIndex3(dw, blockX, blockY, rot, i, j)
  dst[idx] = UP_BlendIndexRatio(pal, blendCache, dst[idx], col, ratioCode, hasAlpha)
end function

/// Writes one output color to a rotation-relative cell of the current 3x3 destination block.
/// @param dst Dst value supplied to `UP_XbrzSetRef3`.
/// @param dw Dw value supplied to `UP_XbrzSetRef3`.
/// @param blockX Horizontal coordinate or vector component represented by block x.
/// @param blockY Vertical coordinate or vector component represented by block y.
/// @param rot Rot value supplied to `UP_XbrzSetRef3`.
/// @param i Zero-based iteration index.
/// @param j Secondary zero-based iteration index.
/// @param col Col value supplied to `UP_XbrzSetRef3`.
function inline UP_XbrzSetRef3(dst, dw, blockX, blockY, rot, i, j, col)
  dst[UP_XbrzRefIndex3(dw, blockX, blockY, rot, i, j)] = col
end function

/// Applies the xBRZ 3x shallow-edge coverage pattern with weighted blends and one fully replaced corner pixel.
/// @param dst Dst value supplied to `UP_XbrzBlendLineShallow3`.
/// @param dw Dw value supplied to `UP_XbrzBlendLineShallow3`.
/// @param blockX Horizontal coordinate or vector component represented by block x.
/// @param blockY Vertical coordinate or vector component represented by block y.
/// @param rot Rot value supplied to `UP_XbrzBlendLineShallow3`.
/// @param col Col value supplied to `UP_XbrzBlendLineShallow3`.
/// @param pal Pal value supplied to `UP_XbrzBlendLineShallow3`.
/// @param blendCache Blend cache value supplied to `UP_XbrzBlendLineShallow3`.
/// @param hasAlpha Whether has alpha holds.
function UP_XbrzBlendLineShallow3(dst, dw, blockX, blockY, rot, col, pal, blendCache, hasAlpha)
  UP_XbrzBlendRef3(dst, dw, blockX, blockY, rot, 2, 0, col, pal, blendCache, hasAlpha, 0)
  UP_XbrzBlendRef3(dst, dw, blockX, blockY, rot, 1, 2, col, pal, blendCache, hasAlpha, 0)
  UP_XbrzBlendRef3(dst, dw, blockX, blockY, rot, 2, 1, col, pal, blendCache, hasAlpha, 1)
  UP_XbrzSetRef3(dst, dw, blockX, blockY, rot, 2, 2, col)
end function

/// Applies the rotated xBRZ 3x steep-edge coverage pattern to the current destination block.
/// @param dst Dst value supplied to `UP_XbrzBlendLineSteep3`.
/// @param dw Dw value supplied to `UP_XbrzBlendLineSteep3`.
/// @param blockX Horizontal coordinate or vector component represented by block x.
/// @param blockY Vertical coordinate or vector component represented by block y.
/// @param rot Rot value supplied to `UP_XbrzBlendLineSteep3`.
/// @param col Col value supplied to `UP_XbrzBlendLineSteep3`.
/// @param pal Pal value supplied to `UP_XbrzBlendLineSteep3`.
/// @param blendCache Blend cache value supplied to `UP_XbrzBlendLineSteep3`.
/// @param hasAlpha Whether has alpha holds.
function UP_XbrzBlendLineSteep3(dst, dw, blockX, blockY, rot, col, pal, blendCache, hasAlpha)
  UP_XbrzBlendRef3(dst, dw, blockX, blockY, rot, 0, 2, col, pal, blendCache, hasAlpha, 0)
  UP_XbrzBlendRef3(dst, dw, blockX, blockY, rot, 2, 1, col, pal, blendCache, hasAlpha, 0)
  UP_XbrzBlendRef3(dst, dw, blockX, blockY, rot, 1, 2, col, pal, blendCache, hasAlpha, 1)
  UP_XbrzSetRef3(dst, dw, blockX, blockY, rot, 2, 2, col)
end function

/// Applies the combined xBRZ 3x corner pattern when both steep and shallow edge tests succeed.
/// @param dst Dst value supplied to `UP_XbrzBlendLineSteepAndShallow3`.
/// @param dw Dw value supplied to `UP_XbrzBlendLineSteepAndShallow3`.
/// @param blockX Horizontal coordinate or vector component represented by block x.
/// @param blockY Vertical coordinate or vector component represented by block y.
/// @param rot Rot value supplied to `UP_XbrzBlendLineSteepAndShallow3`.
/// @param col Col value supplied to `UP_XbrzBlendLineSteepAndShallow3`.
/// @param pal Pal value supplied to `UP_XbrzBlendLineSteepAndShallow3`.
/// @param blendCache Blend cache value supplied to `UP_XbrzBlendLineSteepAndShallow3`.
/// @param hasAlpha Whether has alpha holds.
function UP_XbrzBlendLineSteepAndShallow3(dst, dw, blockX, blockY, rot, col, pal, blendCache, hasAlpha)
  UP_XbrzBlendRef3(dst, dw, blockX, blockY, rot, 2, 0, col, pal, blendCache, hasAlpha, 0)
  UP_XbrzBlendRef3(dst, dw, blockX, blockY, rot, 0, 2, col, pal, blendCache, hasAlpha, 0)
  UP_XbrzBlendRef3(dst, dw, blockX, blockY, rot, 2, 1, col, pal, blendCache, hasAlpha, 1)
  UP_XbrzBlendRef3(dst, dw, blockX, blockY, rot, 1, 2, col, pal, blendCache, hasAlpha, 1)
  UP_XbrzSetRef3(dst, dw, blockX, blockY, rot, 2, 2, col)
end function

/// Applies the xBRZ 3x diagonal-edge weights to the two adjacent cells and corner cell.
/// @param dst Dst value supplied to `UP_XbrzBlendLineDiagonal3`.
/// @param dw Dw value supplied to `UP_XbrzBlendLineDiagonal3`.
/// @param blockX Horizontal coordinate or vector component represented by block x.
/// @param blockY Vertical coordinate or vector component represented by block y.
/// @param rot Rot value supplied to `UP_XbrzBlendLineDiagonal3`.
/// @param col Col value supplied to `UP_XbrzBlendLineDiagonal3`.
/// @param pal Pal value supplied to `UP_XbrzBlendLineDiagonal3`.
/// @param blendCache Blend cache value supplied to `UP_XbrzBlendLineDiagonal3`.
/// @param hasAlpha Whether has alpha holds.
function UP_XbrzBlendLineDiagonal3(dst, dw, blockX, blockY, rot, col, pal, blendCache, hasAlpha)
  UP_XbrzBlendRef3(dst, dw, blockX, blockY, rot, 1, 2, col, pal, blendCache, hasAlpha, 2)
  UP_XbrzBlendRef3(dst, dw, blockX, blockY, rot, 2, 1, col, pal, blendCache, hasAlpha, 2)
  UP_XbrzBlendRef3(dst, dw, blockX, blockY, rot, 2, 2, col, pal, blendCache, hasAlpha, 3)
end function

/// Controls xbrz Blend Corner3 transitions in the HDWAD builder system.
/// @param dst Dst value supplied to `UP_XbrzBlendCorner3`.
/// @param dw Dw value supplied to `UP_XbrzBlendCorner3`.
/// @param blockX Horizontal coordinate or vector component represented by block x.
/// @param blockY Vertical coordinate or vector component represented by block y.
/// @param rot Rot value supplied to `UP_XbrzBlendCorner3`.
/// @param col Col value supplied to `UP_XbrzBlendCorner3`.
/// @param pal Pal value supplied to `UP_XbrzBlendCorner3`.
/// @param blendCache Blend cache value supplied to `UP_XbrzBlendCorner3`.
/// @param hasAlpha Whether has alpha holds.
function UP_XbrzBlendCorner3(dst, dw, blockX, blockY, rot, col, pal, blendCache, hasAlpha)
  UP_XbrzBlendRef3(dst, dw, blockX, blockY, rot, 2, 2, col, pal, blendCache, hasAlpha, 4)
end function

/// Controls xbrz Blend Pixel3 transitions in the HDWAD builder system.
/// @param dst Dst value supplied to `UP_XbrzBlendPixel3`.
/// @param dw Dw value supplied to `UP_XbrzBlendPixel3`.
/// @param blockX Horizontal coordinate or vector component represented by block x.
/// @param blockY Vertical coordinate or vector component represented by block y.
/// @param blendInfo Blend info value supplied to `UP_XbrzBlendPixel3`.
/// @param rot Rot value supplied to `UP_XbrzBlendPixel3`.
/// @param pal Pal value supplied to `UP_XbrzBlendPixel3`.
/// @param distCache Dist cache value supplied to `UP_XbrzBlendPixel3`.
/// @param blendCache Blend cache value supplied to `UP_XbrzBlendPixel3`.
/// @param hasAlpha Whether has alpha holds.
/// @param a0 A0 value supplied to `UP_XbrzBlendPixel3`.
/// @param b0 B0 value supplied to `UP_XbrzBlendPixel3`.
/// @param c0 C0 value supplied to `UP_XbrzBlendPixel3`.
/// @param d0 D0 value supplied to `UP_XbrzBlendPixel3`.
/// @param e0 E0 value supplied to `UP_XbrzBlendPixel3`.
/// @param f0 F0 value supplied to `UP_XbrzBlendPixel3`.
/// @param g0 G0 value supplied to `UP_XbrzBlendPixel3`.
/// @param h0 H0 value supplied to `UP_XbrzBlendPixel3`.
/// @param i0 I0 value supplied to `UP_XbrzBlendPixel3`.
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

/// Upscales one indexed image by exactly 3x using cached palette distances, preclassified corners, and
/// rotation-invariant xBRZ edge blending.
/// @param img Img value supplied to `UP_XbrzScaleIndexed3`.
/// @param pal Pal value supplied to `UP_XbrzScaleIndexed3`.
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

/// Chooses the closer edge color for a corner blend.
/// @param pal Pal value supplied to `UP_BestEdgeColor`.
/// @param center Center value supplied to `UP_BestEdgeColor`.
/// @param a First input operand.
/// @param b Second input operand.
/// @param hasAlpha Whether has alpha holds.
function UP_BestEdgeColor(pal, center, a, b, hasAlpha)
  da = UP_ColorDistance(pal, center, a, hasAlpha)
  db = UP_ColorDistance(pal, center, b, hasAlpha)
  if da <= db then return a end if
  return b
end function

/// Chooses the closer edge color using cached palette distances.
/// @param pal Pal value supplied to `UP_BestEdgeColorCached`.
/// @param cache Cache value supplied to `UP_BestEdgeColorCached`.
/// @param center Center value supplied to `UP_BestEdgeColorCached`.
/// @param a First input operand.
/// @param b Second input operand.
/// @param hasAlpha Whether has alpha holds.
function UP_BestEdgeColorCached(pal, cache, center, a, b, hasAlpha)
  da = UP_ColorDistanceCached(pal, cache, center, a, hasAlpha)
  db = UP_ColorDistanceCached(pal, cache, center, b, hasAlpha)
  if da <= db then return a end if
  return b
end function

/// Returns the local xBRZ corner blend weight for one block coordinate.
/// @param dist Dist value supplied to `UP_CornerWeight`.
/// @param scale Scale value supplied to `UP_CornerWeight`.
function inline UP_CornerWeight(dist, scale)
  if dist >= scale then return 0 end if
  w = 3 - std.math.floor((dist * 3) / scale)
  if w < 1 then w = 1 end if
  if w > 3 then w = 3 end if
  return w
end function

/// Applies a triangular xBRZ corner blend inside one scaled block.
/// @param dst Dst value supplied to `UP_BlendCorner`.
/// @param dw Dw value supplied to `UP_BlendCorner`.
/// @param blockX Horizontal coordinate or vector component represented by block x.
/// @param blockY Vertical coordinate or vector component represented by block y.
/// @param scale Scale value supplied to `UP_BlendCorner`.
/// @param corner Corner value supplied to `UP_BlendCorner`.
/// @param base Base value supplied to `UP_BlendCorner`.
/// @param edge Edge value supplied to `UP_BlendCorner`.
/// @param pal Pal value supplied to `UP_BlendCorner`.
/// @param cache Cache value supplied to `UP_BlendCorner`.
/// @param hasAlpha Whether has alpha holds.
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

/// Blends one horizontal edge of a scaled block toward a neighboring edge color.
/// @param dst Dst value supplied to `UP_BlendEdgeRow`.
/// @param dw Dw value supplied to `UP_BlendEdgeRow`.
/// @param blockX Horizontal coordinate or vector component represented by block x.
/// @param blockY Vertical coordinate or vector component represented by block y.
/// @param scale Scale value supplied to `UP_BlendEdgeRow`.
/// @param row Row value supplied to `UP_BlendEdgeRow`.
/// @param base Base value supplied to `UP_BlendEdgeRow`.
/// @param edge Edge value supplied to `UP_BlendEdgeRow`.
/// @param pal Pal value supplied to `UP_BlendEdgeRow`.
/// @param cache Cache value supplied to `UP_BlendEdgeRow`.
/// @param hasAlpha Whether has alpha holds.
/// @param weight Weight value supplied to `UP_BlendEdgeRow`.
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

/// Blends one vertical edge of a scaled block toward a neighboring edge color.
/// @param dst Dst value supplied to `UP_BlendEdgeColumn`.
/// @param dw Dw value supplied to `UP_BlendEdgeColumn`.
/// @param blockX Horizontal coordinate or vector component represented by block x.
/// @param blockY Vertical coordinate or vector component represented by block y.
/// @param scale Scale value supplied to `UP_BlendEdgeColumn`.
/// @param col Col value supplied to `UP_BlendEdgeColumn`.
/// @param base Base value supplied to `UP_BlendEdgeColumn`.
/// @param edge Edge value supplied to `UP_BlendEdgeColumn`.
/// @param pal Pal value supplied to `UP_BlendEdgeColumn`.
/// @param cache Cache value supplied to `UP_BlendEdgeColumn`.
/// @param hasAlpha Whether has alpha holds.
/// @param weight Weight value supplied to `UP_BlendEdgeColumn`.
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

/// Chooses a slightly stronger blend for hard pixel-art edges.
/// @param pal Pal value supplied to `UP_StrongEdgeWeight`.
/// @param base Base value supplied to `UP_StrongEdgeWeight`.
/// @param edge Edge value supplied to `UP_StrongEdgeWeight`.
/// @param hasAlpha Whether has alpha holds.
function inline UP_StrongEdgeWeight(pal, base, edge, hasAlpha)
  dist = UP_ColorDistance(pal, base, edge, hasAlpha)
  if dist > 26000 then return 2 end if
  return 1
end function

/// Chooses blend strength using cached palette distances.
/// @param pal Pal value supplied to `UP_StrongEdgeWeightCached`.
/// @param cache Cache value supplied to `UP_StrongEdgeWeightCached`.
/// @param base Base value supplied to `UP_StrongEdgeWeightCached`.
/// @param edge Edge value supplied to `UP_StrongEdgeWeightCached`.
/// @param hasAlpha Whether has alpha holds.
function inline UP_StrongEdgeWeightCached(pal, cache, base, edge, hasAlpha)
  dist = UP_ColorDistanceCached(pal, cache, base, edge, hasAlpha)
  if dist > 26000 then return 2 end if
  return 1
end function

/// Scales an indexed image with palette-aware xBRZ-style edge reconstruction.
/// @param img Img value supplied to `UP_XbrzScaleIndexed`.
/// @param scale Scale value supplied to `UP_XbrzScaleIndexed`.
/// @param pal Pal value supplied to `UP_XbrzScaleIndexed`.
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

/// Reads a WAD and returns [data, lumps].
/// @param path Filesystem path to process.
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

/// Extracts flat images from a marker range.
/// @param images Images value supplied to `UP_AddFlatRange`.
/// @param wadData Wad data value supplied to `UP_AddFlatRange`.
/// @param lumps Lumps value supplied to `UP_AddFlatRange`.
/// @param startName Start name value supplied to `UP_AddFlatRange`.
/// @param endName End name value supplied to `UP_AddFlatRange`.
/// @param scale Scale value supplied to `UP_AddFlatRange`.
/// @param pal Pal value supplied to `UP_AddFlatRange`.
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

/// Extracts Doom patch images from a marker range.
/// @param images Images value supplied to `UP_AddPatchRange`.
/// @param wadData Wad data value supplied to `UP_AddPatchRange`.
/// @param lumps Lumps value supplied to `UP_AddPatchRange`.
/// @param startName Start name value supplied to `UP_AddPatchRange`.
/// @param endName End name value supplied to `UP_AddPatchRange`.
/// @param kind Kind value supplied to `UP_AddPatchRange`.
/// @param scale Scale value supplied to `UP_AddPatchRange`.
/// @param pal Pal value supplied to `UP_AddPatchRange`.
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

/// Checks whether an image with the same kind/name was already emitted.
/// @param images Images value supplied to `UP_HasImage`.
/// @param kind Kind value supplied to `UP_HasImage`.
/// @param name Resource or object name to resolve.
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

/// Avoids trying marker/control lumps as patch images.
/// @param name Resource or object name to resolve.
function UP_IsMarkerName(name)
  if name == "" then return true end if
  if name == "P_START" or name == "P_END" or name == "PP_START" or name == "PP_END" then return true end if
  if name == "S_START" or name == "S_END" or name == "SS_START" or name == "SS_END" then return true end if
  if name == "F_START" or name == "F_END" or name == "FF_START" or name == "FF_END" then return true end if
  if name == "TEXTURE1" or name == "TEXTURE2" or name == "PNAMES" or name == "PLAYPAL" or name == "COLORMAP" then return true end if
  return false
end function

/// Extracts all remaining Doom patch-format graphics such as HUD, menu, title, finale and fonts.
/// @param images Images value supplied to `UP_AddAllPatchLumps`.
/// @param wadData Wad data value supplied to `UP_AddAllPatchLumps`.
/// @param lumps Lumps value supplied to `UP_AddAllPatchLumps`.
/// @param scale Scale value supplied to `UP_AddAllPatchLumps`.
/// @param pal Pal value supplied to `UP_AddAllPatchLumps`.
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

/// Adds composited wall textures from TEXTURE1/TEXTURE2.
/// @param images Images value supplied to `UP_AddTextureLump`.
/// @param wadData Wad data value supplied to `UP_AddTextureLump`.
/// @param lumps Lumps value supplied to `UP_AddTextureLump`.
/// @param lumpName Lump name value supplied to `UP_AddTextureLump`.
/// @param patchLookup Patch lookup value supplied to `UP_AddTextureLump`.
/// @param scale Scale value supplied to `UP_AddTextureLump`.
/// @param pal Pal value supplied to `UP_AddTextureLump`.
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

/// Counts WAD lumps between two marker names for progress estimation.
/// @param lumps Lumps value supplied to `UP_CountMarkerRange`.
/// @param startName Start name value supplied to `UP_CountMarkerRange`.
/// @param endName End name value supplied to `UP_CountMarkerRange`.
function UP_CountMarkerRange(lumps, startName, endName)
  start = UP_FindMarker(lumps, startName)
  finish = UP_FindMarker(lumps, endName)
  if start < 0 or finish < 0 or finish <= start then return 0 end if
  return finish - start - 1
end function

/// Estimates the progress units emitted while HDWAD graphics are built.
/// @param wadData Wad data value supplied to `HDB_EstimateImageProgressUnits`.
/// @param lumps Lumps value supplied to `HDB_EstimateImageProgressUnits`.
/// @param scale Scale value supplied to `HDB_EstimateImageProgressUnits`.
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

/// Writes extracted images as a MiniDoom upscaled package.
/// @param path Filesystem path to process.
/// @param images Images value supplied to `UP_WritePackage`.
/// @param scale Scale value supplied to `UP_WritePackage`.
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

/// Emits a complete HDWAD containing original lumps and upscaled images by delegating with no synthetic lumps.
/// @param path Filesystem path to process.
/// @param wadData Wad data value supplied to `UP_WriteHDWADPackage`.
/// @param lumps Lumps value supplied to `UP_WriteHDWADPackage`.
/// @param images Images value supplied to `UP_WriteHDWADPackage`.
/// @param scale Scale value supplied to `UP_WriteHDWADPackage`.
function UP_WriteHDWADPackage(path, wadData, lumps, images, scale)
  return UP_WriteHDWADPackageWithExtraLumps(path, wadData, lumps, images, [], [], scale)
end function

/// Lays out an HDWAD header, original and synthetic lump payloads, image payloads, and both directories before
/// saving atomically.
/// @param path Filesystem path to process.
/// @param wadData Wad data value supplied to `UP_WriteHDWADPackageWithExtraLumps`.
/// @param lumps Lumps value supplied to `UP_WriteHDWADPackageWithExtraLumps`.
/// @param images Images value supplied to `UP_WriteHDWADPackageWithExtraLumps`.
/// @param extraNames Extra names value supplied to `UP_WriteHDWADPackageWithExtraLumps`.
/// @param extraDatas Extra datas value supplied to `UP_WriteHDWADPackageWithExtraLumps`.
/// @param scale Scale value supplied to `UP_WriteHDWADPackageWithExtraLumps`.
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

/// Loads the palette and patch namespace, then builds the complete HD image set from wall textures, flats,
/// sprites, and remaining patch lumps.
/// @param wadData Wad data value supplied to `HDB_BuildImages`.
/// @param lumps Lumps value supplied to `HDB_BuildImages`.
/// @param scale Scale value supplied to `HDB_BuildImages`.
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

/// Loads and validates the source WAD bytes and directory through the builder's shared WAD parser.
/// @param path Filesystem path to process.
function HDB_LoadWadForBuild(path)
  return UP_LoadWad(path)
end function

/// Exposes full HDWAD packaging, including synthetic lumps, through the builder module's stable public entry
/// point.
/// @param path Filesystem path to process.
/// @param wadData Wad data value supplied to `HDB_WriteHDWAD`.
/// @param lumps Lumps value supplied to `HDB_WriteHDWAD`.
/// @param images Images value supplied to `HDB_WriteHDWAD`.
/// @param extraNames Extra names value supplied to `HDB_WriteHDWAD`.
/// @param extraDatas Extra datas value supplied to `HDB_WriteHDWAD`.
/// @param scale Scale value supplied to `HDB_WriteHDWAD`.
function HDB_WriteHDWAD(path, wadData, lumps, images, extraNames, extraDatas, scale)
  return UP_WriteHDWADPackageWithExtraLumps(path, wadData, lumps, images, extraNames, extraDatas, scale)
end function

/// Legacy helper kept for manual module testing.
/// @param args Args value supplied to `HDB_LegacyToolMain`.
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
