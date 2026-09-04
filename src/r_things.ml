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

//! Builds sprite definitions, projects world/player sprites, clips them against drawsegs, and renders masked
//! content.

import doomdef
import m_swap
import i_system
import z_zone
import w_wad
import r_local
import v_video
import doomstat
import r_upscaled
import r_hires
import std.math

/// Defines the maximum maxvissprites accepted by the r things subsystem.
const MAXVISSPRITES = 128
/// Defines the minimum minz accepted by the r things subsystem.
const MINZ = 262144
/// Defines baseycenter for the r things subsystem.
const BASEYCENTER = 100
/// Defines rt transparent index for the r things subsystem.
const RT_TRANSPARENT_INDEX = 255

/// Stores the vissprites collection used by the r things subsystem.
vissprites =[]
/// Tracks the mutable vissprite p value used by the r things subsystem.
vissprite_p = 0
/// Holds the optional vsprsortedhead resource used by the r things subsystem.
vsprsortedhead = void

/// Stores the negonearray collection used by the r things subsystem.
negonearray =[]
/// Stores the screenheightarray collection used by the r things subsystem.
screenheightarray =[]

/// Holds the optional mfloorclip resource used by the r things subsystem.
mfloorclip = void
/// Holds the optional mceilingclip resource used by the r things subsystem.
mceilingclip = void
/// Tracks the mutable spryscale value used by the r things subsystem.
spryscale = 0
/// Tracks the mutable sprtopscreen value used by the r things subsystem.
sprtopscreen = 0

/// Tracks the mutable pspritescale value used by the r things subsystem.
pspritescale = 0
/// Tracks the mutable pspriteiscale value used by the r things subsystem.
pspriteiscale = 0
/// Holds the optional spritelights resource used by the r things subsystem.
spritelights = void

/// Stores the rt sorted collection used by the r things subsystem.
/// @internal
_rt_sorted =[]
/// Tracks the mutable rt sorted count value used by the r things subsystem.
/// @internal
_rt_sorted_count = 0
/// Holds the optional rt shadow map resource used by the r things subsystem.
/// @internal
_rt_shadowMap = void
/// Stores the rt colormap cache collection used by the r things subsystem.
/// @internal
_rt_colormap_cache =[]
/// Tracks the mutable rt colormap cache len value used by the r things subsystem.
/// @internal
_rt_colormap_cache_len = -1
/// Holds the optional rt draw translation resource used by the r things subsystem.
/// @internal
_rt_drawTranslation = void
/// Stores the rt clipbot work collection used by the r things subsystem.
/// @internal
_rt_clipbot_work =[]
/// Stores the rt cliptop work collection used by the r things subsystem.
/// @internal
_rt_cliptop_work =[]
/// Tracks whether rt prof enabled is active in the r things subsystem.
/// @internal
_rt_prof_enabled = false
/// Tracks the mutable rt prof things value used by the r things subsystem.
/// @internal
_rt_profThings = 0
/// Tracks the mutable rt prof projected value used by the r things subsystem.
/// @internal
_rt_profProjected = 0
/// Tracks the mutable rt prof rejected value used by the r things subsystem.
/// @internal
_rt_profRejected = 0
/// Tracks the mutable rt prof drawn value used by the r things subsystem.
/// @internal
_rt_profDrawn = 0
/// Tracks the mutable rt rej no thing value used by the r things subsystem.
/// @internal
_rt_rejNoThing = 0
/// Tracks the mutable rt rej no sprites value used by the r things subsystem.
/// @internal
_rt_rejNoSprites = 0
/// Tracks the mutable rt rej bad sprite value used by the r things subsystem.
/// @internal
_rt_rejBadSprite = 0
/// Tracks the mutable rt rej behind value used by the r things subsystem.
/// @internal
_rt_rejBehind = 0
/// Tracks the mutable rt rej side value used by the r things subsystem.
/// @internal
_rt_rejSide = 0
/// Tracks the mutable rt rej bad def value used by the r things subsystem.
/// @internal
_rt_rejBadDef = 0
/// Tracks the mutable rt rej bad frame value used by the r things subsystem.
/// @internal
_rt_rejBadFrame = 0
/// Tracks the mutable rt rej no frame value used by the r things subsystem.
/// @internal
_rt_rejNoFrame = 0
/// Tracks the mutable rt rej bad lump value used by the r things subsystem.
/// @internal
_rt_rejBadLump = 0
/// Tracks the mutable rt rej off right value used by the r things subsystem.
/// @internal
_rt_rejOffRight = 0
/// Tracks the mutable rt rej off left value used by the r things subsystem.
/// @internal
_rt_rejOffLeft = 0
/// Tracks the mutable rt rej no vis value used by the r things subsystem.
/// @internal
_rt_rejNoVis = 0
/// Tracks the mutable rt debug disable sprites value used by the r things subsystem.
/// @internal
_rt_debug_disable_sprites = 0

/// Enables or disables sprite/render profiling counters in hot paths.
/// @param on On value supplied to `R_ThingsProfileSetEnabled`.
function R_ThingsProfileSetEnabled(on)
  global _rt_prof_enabled
  _rt_prof_enabled = on
end function

/// Tracks visited things for renderer profiling when profiling is active.
/// @internal
function inline _RT_ProfThingSeen()
  global _rt_profThings
  if _rt_prof_enabled then _rt_profThings = _rt_profThings + 1 end if
end function

/// Tracks successful sprite projections for renderer profiling.
/// @internal
function inline _RT_ProfProjected()
  global _rt_profProjected
  if _rt_prof_enabled then _rt_profProjected = _rt_profProjected + 1 end if
end function

/// Tracks drawn sprites for renderer profiling.
/// @internal
function inline _RT_ProfDrawn()
  global _rt_profDrawn
  if _rt_prof_enabled then _rt_profDrawn = _rt_profDrawn + 1 end if
end function

/// Tracks sprite reject categories for renderer profiling.
/// @param kind Kind value supplied to `_RT_ProfReject`.
/// @internal
function inline _RT_ProfReject(kind)
  global _rt_profRejected
  global _rt_rejNoThing
  global _rt_rejNoSprites
  global _rt_rejBadSprite
  global _rt_rejBehind
  global _rt_rejSide
  global _rt_rejBadDef
  global _rt_rejBadFrame
  global _rt_rejNoFrame
  global _rt_rejBadLump
  global _rt_rejOffRight
  global _rt_rejOffLeft
  global _rt_rejNoVis
  if not _rt_prof_enabled then return end if
  _rt_profRejected = _rt_profRejected + 1
  if kind == 1 then _rt_rejNoThing = _rt_rejNoThing + 1
  else if kind == 2 then _rt_rejNoSprites = _rt_rejNoSprites + 1
  else if kind == 3 then _rt_rejBadSprite = _rt_rejBadSprite + 1
  else if kind == 4 then _rt_rejBehind = _rt_rejBehind + 1
  else if kind == 5 then _rt_rejSide = _rt_rejSide + 1
  else if kind == 6 then _rt_rejBadDef = _rt_rejBadDef + 1
  else if kind == 7 then _rt_rejBadFrame = _rt_rejBadFrame + 1
  else if kind == 8 then _rt_rejNoFrame = _rt_rejNoFrame + 1
  else if kind == 9 then _rt_rejBadLump = _rt_rejBadLump + 1
  else if kind == 10 then _rt_rejOffRight = _rt_rejOffRight + 1
  else if kind == 11 then _rt_rejOffLeft = _rt_rejOffLeft + 1
  else if kind == 12 then _rt_rejNoVis = _rt_rejNoVis + 1
  end if
end function

/// Allocates a zeroed visible-sprite record with no linked-list neighbors or colormap.
/// @internal
function inline _makeVisSprite()

  return vissprite_t(void, void, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, void, 0)
end function

/// Creates an unresolved sprite frame with eight missing rotation lumps and unflipped defaults.
/// @internal
function inline _RT_MakeEmptyFrame()
  lumps = array(8, -1)
  flips = array(8, 0)
  return spriteframe_t(-1, lumps, flips)
end function

/// Returns a signed quotient truncated toward zero, or zero for invalid operands and a zero divisor in
/// `_RT_IDiv`
/// @param a First input operand.
/// @param b Second input operand.
/// @internal
function inline _RT_IDiv(a, b)
  if typeof(a) != "int" or typeof(b) != "int" or b == 0 then return 0 end if
  q = a / b
  if q >= 0 then return std.math.floor(q) end if
  return std.math.ceil(q)
end function

/// Coerces a numeric value and returns its non-negative integer magnitude.
/// @param v Value consumed by the operation.
/// @internal
function inline _RT_Abs(v)
  vi = _RT_ToInt(v, 0)
  if vi < 0 then return - vi end if
  return vi
end function

/// Constrains a sprite-rendering scalar to the supplied inclusive bounds.
/// @param v Value consumed by the operation.
/// @param lo Inclusive lower bound.
/// @param hi Inclusive upper bound.
/// @internal
function inline _RT_Clamp(v, lo, hi)
  if v < lo then return lo end if
  if v > hi then return hi end if
  return v
end function

/// Coerces numeric values to truncation-toward-zero integers and returns fallback on failure in `_RT_ToInt`
/// @param v Value consumed by the operation.
/// @param fallback Value returned when the requested conversion or lookup is unavailable.
/// @internal
function inline _RT_ToInt(v, fallback)
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

/// Reinterprets the low 32 bits of a coerced numeric value as a signed coordinate.
/// @param v Value consumed by the operation.
/// @internal
function inline _RT_S32(v)
  vi = _RT_ToInt(v, 0)
  x = vi & 0xFFFFFFFF
  if x >= 0x80000000 then return x - 0x100000000 end if
  return x
end function

/// Normalizes a numeric value to Doom's unsigned 32-bit binary-angle domain.
/// @param a First input operand.
/// @internal
function inline _RT_AngNorm(a)
  ai = _RT_ToInt(a, 0)
  return ai & 0xFFFFFFFF
end function

/// Recognizes the array and list containers used for sprite definitions, clips, and renderer tables.
/// @param v Value consumed by the operation.
/// @internal
function inline _RT_IsSeq(v)
  t = typeof(v)
  return t == "array" or t == "list"
end function

/// Reads a column clip from a direct sequence or x-biased openings-arena reference.
/// @param clipref Clipref value supplied to `_RT_GetClipValue`.
/// @param x Horizontal map- or screen-space coordinate.
/// @param fallback Value returned when the requested conversion or lookup is unavailable.
/// @internal
function inline _RT_GetClipValue(clipref, x, fallback)
  if typeof(x) != "int" or x < 0 then return fallback end if
  if _RT_IsSeq(clipref) then
    if x < len(clipref) then return clipref[x] end if
    return fallback
  end if
  if typeof(clipref) == "int" and _RT_IsSeq(openings) then
    idx = clipref + x
    if idx >= 0 and idx < len(openings) then return openings[idx] end if
  end if
  return fallback
end function

/// Resolves integer, numeric, or enum values to a bounded sprite-table index, returning -1 when invalid.
/// @param v Value consumed by the operation.
/// @param limit Limit value supplied to `_RT_EnumIndex`.
/// @internal
function inline _RT_EnumIndex(v, limit)
  if typeof(v) == "int" then return v end if
  n = toNumber(v)
  if typeof(n) == "int" then return n end if
  if typeof(v) != "enum" then return -1 end if
  if typeof(limit) != "int" or limit <= 0 then return -1 end if

  i = 0
  while i < limit
    if v == i then return i end if
    i = i + 1
  end while
  return -1
end function

/// Resolves a sprite identifier against the loaded definition count.
/// @param v Value consumed by the operation.
/// @internal
function inline _RT_SpriteIndex(v)
  max = 0
  if _RT_IsSeq(sprites) then
    max = len(sprites)
  else if typeof(numsprites) == "int" then
    max = numsprites
  end if
  return _RT_EnumIndex(v, max)
end function

/// Normalizes lowercase ASCII bytes before comparing case-insensitive WAD sprite names.
/// @param c C value supplied to `_RT_UpperAscii`.
/// @internal
function inline _RT_UpperAscii(c)
  if c >= 97 and c <= 122 then return c - 32 end if
  return c
end function

/// Returns the uppercase four-byte sprite prefix from a name, or an empty string when too short.
/// @param s S value supplied to `_RT_Name4`.
/// @internal
function inline _RT_Name4(s)
  if typeof(s) != "string" then return "" end if
  b = bytes(s)
  if len(b) < 4 then return "" end if
  nm4 = bytes(4, 0)
  i = 0
  while i < 4
    nm4[i] = _RT_UpperAscii(b[i])
    i = i + 1
  end while
  return decode(nm4)
end function

/// Decodes a validated lump directory entry's zero-terminated eight-byte name.
/// @param lumpnum Index identifying lump.
/// @internal
function inline _RT_LumpNameAt(lumpnum)
  if not _RT_IsSeq(lumpinfo) then return "" end if
  if lumpnum < 0 or lumpnum >= len(lumpinfo) then return "" end if
  li = lumpinfo[lumpnum]
  if li is void or typeof(li.name) != "bytes" then return "" end if
  return decodeZ(li.name)
end function

/// Retains the classic public hook; sprite-lump installation is performed on explicit frame arrays by the
/// internal builder.
/// @param lump Lump value supplied to `R_InstallSpriteLump`.
/// @param frame Frame value supplied to `R_InstallSpriteLump`.
/// @param rotation Rotation value supplied to `R_InstallSpriteLump`.
/// @param flipped Flipped value supplied to `R_InstallSpriteLump`.
function R_InstallSpriteLump(lump, frame, rotation, flipped)

  lump = lump
  frame = frame
  rotation = rotation
  flipped = flipped
end function

/// Installs one rot=0 or directional lump into a frame table while rejecting mixed, duplicate, or invalid
/// rotations.
/// @param frames Frames value supplied to `_RT_InstallSpriteLump`.
/// @param frame Frame value supplied to `_RT_InstallSpriteLump`.
/// @param rotation Rotation value supplied to `_RT_InstallSpriteLump`.
/// @param lump Lump value supplied to `_RT_InstallSpriteLump`.
/// @param flipped Flipped value supplied to `_RT_InstallSpriteLump`.
/// @param sprname Sprname value supplied to `_RT_InstallSpriteLump`.
/// @param maxframe Maxframe value supplied to `_RT_InstallSpriteLump`.
/// @internal
function _RT_InstallSpriteLump(frames, frame, rotation, lump, flipped, sprname, maxframe)
  if frame < 0 or frame >= 29 or rotation < 0 or rotation > 8 then
    I_Error("R_InstallSpriteLump: bad frame/rotation")
    return maxframe
  end if
  if frame > maxframe then maxframe = frame end if

  sf = frames[frame]
  if sf is void then sf = _RT_MakeEmptyFrame() end if

  if rotation == 0 then
    if sf.rotate == 0 then
      I_Error("R_InitSprites: Sprite " + sprname + " has multiple rot=0 lumps")
      return maxframe
    end if
    if sf.rotate == 1 then
      I_Error("R_InitSprites: Sprite " + sprname + " mixes rotations with rot=0")
      return maxframe
    end if

    sf.rotate = 0
    r = 0
    while r < 8
      sf.lump[r] = lump
      sf.flip[r] = flipped
      r = r + 1
    end while
    frames[frame] = sf
    return maxframe
  end if

  if sf.rotate == 0 then
    I_Error("R_InitSprites: Sprite " + sprname + " mixes rotations with rot=0")
    return maxframe
  end if

  sf.rotate = 1
  rot = rotation - 1
  if sf.lump[rot] != -1 then
    I_Error("R_InitSprites: Sprite " + sprname + " has duplicate rotation")
    return maxframe
  end if

  sf.lump[rot] = lump
  sf.flip[rot] = flipped
  frames[frame] = sf
  return maxframe
end function

/// Scans the sprite lump namespace for a four-letter prefix, installs primary/flip pairs, and validates every
/// frame rotation.
/// @param sprname Sprname value supplied to `_RT_BuildSpriteDef`.
/// @internal
function _RT_BuildSpriteDef(sprname)
  frames = array(29)
  i = 0
  while i < 29
    frames[i] = _RT_MakeEmptyFrame()
    i = i + 1
  end while

  maxframe = -1

  l = firstspritelump
  while typeof(l) == "int" and l <= lastspritelump
    ln = _RT_LumpNameAt(l)
    b = bytes(ln)
    if len(b) >= 6 and _RT_Name4(ln) == sprname then
      f1 = b[4] - 65
      r1 = b[5] - 48
      if f1 >= 0 and f1 < 29 and r1 >= 0 and r1 <= 8 then
        maxframe = _RT_InstallSpriteLump(frames, f1, r1, l - firstspritelump, 0, sprname, maxframe)
      end if

      if len(b) >= 8 then
        f2 = b[6] - 65
        r2 = b[7] - 48
        if f2 >= 0 and f2 < 29 and r2 >= 0 and r2 <= 8 then
          maxframe = _RT_InstallSpriteLump(frames, f2, r2, l - firstspritelump, 1, sprname, maxframe)
        end if
      end if
    end if
    l = l + 1
  end while

  if maxframe < 0 then
    return spritedef_t(0,[])
  end if

  framesOut = array(maxframe + 1)
  fi = 0
  while fi <= maxframe
    sf = frames[fi]
    if sf.rotate == -1 then
      I_Error("R_InitSprites: No patches found for " + sprname + " frame " + fi)
      sf.rotate = 0
    else if sf.rotate == 1 then
      r = 0
      while r < 8
        if sf.lump[r] == -1 then
          I_Error("R_InitSprites: Sprite " + sprname + " frame " + fi + " missing rotations")
          break
        end if
        r = r + 1
      end while
    end if
    framesOut[fi] = sf
    fi = fi + 1
  end while

  return spritedef_t(maxframe + 1, framesOut)
end function

/// Resets the visible-sprite pool, sorting/clipping workspaces, profiler counters, and sentinel list for a new
/// frame.
function R_ClearSprites()
  global vissprites
  global vissprite_p
  global negonearray
  global screenheightarray
  global vsprsortedhead
  global _rt_sorted
  global _rt_sorted_count
  global _rt_clipbot_work
  global _rt_cliptop_work
  global _rt_profThings
  global _rt_profProjected
  global _rt_profRejected
  global _rt_profDrawn
  global _rt_rejNoThing
  global _rt_rejNoSprites
  global _rt_rejBadSprite
  global _rt_rejBehind
  global _rt_rejSide
  global _rt_rejBadDef
  global _rt_rejBadFrame
  global _rt_rejNoFrame
  global _rt_rejBadLump
  global _rt_rejOffRight
  global _rt_rejOffLeft
  global _rt_rejNoVis

  if len(vissprites) == 0 then
    vissprites = array(MAXVISSPRITES)
    i = 0
    while i < MAXVISSPRITES
      vissprites[i] = _makeVisSprite()
      i = i + 1
    end while
  end if
  vissprite_p = 0
  _rt_sorted_count = 0
  _rt_profThings = 0
  _rt_profProjected = 0
  _rt_profRejected = 0
  _rt_profDrawn = 0
  _rt_rejNoThing = 0
  _rt_rejNoSprites = 0
  _rt_rejBadSprite = 0
  _rt_rejBehind = 0
  _rt_rejSide = 0
  _rt_rejBadDef = 0
  _rt_rejBadFrame = 0
  _rt_rejNoFrame = 0
  _rt_rejBadLump = 0
  _rt_rejOffRight = 0
  _rt_rejOffLeft = 0
  _rt_rejNoVis = 0

  targetW = viewwidth
  if typeof(targetW) != "int" or targetW <= 0 then targetW = SCREENWIDTH end if

  if len(negonearray) != targetW then
    negonearray = array(targetW, -1)
    screenheightarray = array(targetW, viewheight)
  else
    x = 0
    while x < targetW and x < len(screenheightarray)
      screenheightarray[x] = viewheight
      x = x + 1
    end while
  end if

  if len(_rt_clipbot_work) != targetW then
    _rt_clipbot_work = array(targetW, -2)
    _rt_cliptop_work = array(targetW, -2)
  end if

  if vsprsortedhead is void then
    vsprsortedhead = _makeVisSprite()
    vsprsortedhead.prev = vsprsortedhead
    vsprsortedhead.next = vsprsortedhead
  end if
end function

/// Reserves the next preallocated visible-sprite record, returning void when MAXVISSPRITES is exhausted.
function R_NewVisSprite()
  global vissprite_p
  global vissprites
  if vissprite_p >= len(vissprites) then return void end if
  vis = vissprites[vissprite_p]
  vissprite_p = vissprite_p + 1
  return vis
end function

/// Builds reusable colormap slices to avoid per-sprite slice allocations.
/// @internal
function _RT_RebuildColormapCache()
  global _rt_colormap_cache
  global _rt_colormap_cache_len
  global _rt_shadowMap

  _rt_colormap_cache =[]
  _rt_shadowMap = void
  if typeof(colormaps) != "bytes" then
    _rt_colormap_cache_len = -1
    return
  end if
  if len(colormaps) < 256 then
    _rt_colormap_cache_len = len(colormaps)
    return
  end if

  levels = _RT_IDiv(len(colormaps), 256)
  if levels < 1 then levels = 1 end if
  _rt_colormap_cache = array(levels)
  i = 0
  while i < levels
    _rt_colormap_cache[i] = slice(colormaps, i * 256, 256)
    i = i + 1
  end while
  _rt_colormap_cache_len = len(colormaps)
end function

/// Returns a clamped cached 256-entry COLORMAP slice and rebuilds the cache when its source length changes.
/// @param idx Zero-based element or table index.
/// @internal
function inline _RT_ColormapAt(idx)
  global _rt_colormap_cache
  global _rt_colormap_cache_len
  if typeof(colormaps) != "bytes" then return void end if
  if len(colormaps) < 256 then return void end if
  if typeof(_rt_colormap_cache) != "array" or len(_rt_colormap_cache) == 0 or _rt_colormap_cache_len != len(colormaps) then
    _RT_RebuildColormapCache()
  end if
  if typeof(_rt_colormap_cache) != "array" or len(_rt_colormap_cache) == 0 then return void end if
  idx = _RT_Clamp(idx, 0, len(_rt_colormap_cache) - 1)
  return _rt_colormap_cache[idx]
end function

/// Lazily caches the dark level-24 colormap used when fuzz rendering is unavailable.
/// @internal
function inline _RT_ShadowColormap()
  global _rt_shadowMap

  if typeof(_rt_shadowMap) == "bytes" and len(_rt_shadowMap) >= 256 then
    return _rt_shadowMap
  end if
  _rt_shadowMap = _RT_ColormapAt(24)
  return _rt_shadowMap
end function

/// Selects and clamps the scale-light row used to shade sprites in the current sector.
/// @param lightnum Index identifying light.
/// @internal
function inline _RT_SelectSpriteLights(lightnum)
  global spritelights
  if not _RT_IsSeq(scalelight) or len(scalelight) == 0 then
    spritelights =[]
    return
  end if
  if lightnum < 0 then
    spritelights = scalelight[0]
  else if lightnum >= len(scalelight) then
    spritelights = scalelight[len(scalelight) - 1]
  else
    spritelights = scalelight[lightnum]
  end if
end function

/// Decodes and clips every post in one patch column, dispatches the active column drawer, and restores shared
/// source state.
/// @param patch Patch value supplied to `_RT_DrawMaskedPatchColumn`.
/// @param coloff Coloff value supplied to `_RT_DrawMaskedPatchColumn`.
/// @internal
function _RT_DrawMaskedPatchColumn(patch, coloff)
  global colfunc
  global dc_yl
  global dc_yh
  global dc_source
  global dc_sourcebase
  global dc_sourceoff
  global dc_sourcelen
  global dc_sourceclamp
  global dc_texturemid

  if typeof(patch) != "bytes" then return end if
  basetexturemid = dc_texturemid
  oldSource = dc_source
  oldSourceBase = dc_sourcebase
  oldSourceOff = dc_sourceoff
  oldSourceLen = dc_sourcelen
  oldSourceClamp = dc_sourceclamp

  dc_source = patch
  dc_sourcebase = patch
  dc_sourceclamp = true
  off = coloff
  while off >= 0 and off < len(patch)
    topdelta = patch[off]
    if topdelta == 255 then break end if
    if off + 3 >= len(patch) then break end if

    run = patch[off + 1]
    if run <= 0 then
      off = off + 4
      continue
    end if
    if off + 3 + run > len(patch) then break end if

    topscreen = sprtopscreen + spryscale * topdelta
    bottomscreen = topscreen + spryscale * run

    dc_yl =(topscreen + FRACUNIT - 1) >> FRACBITS
    dc_yh =(bottomscreen - 1) >> FRACBITS

    bclip = _RT_GetClipValue(mfloorclip, dc_x, viewheight)
    if dc_yh >= bclip then dc_yh = bclip - 1 end if
    tclip = _RT_GetClipValue(mceilingclip, dc_x, -1)
    if dc_yl <= tclip then dc_yl = tclip + 1 end if

    if dc_yl <= dc_yh then
      dc_sourceoff = off + 3
      dc_sourcelen = run
      dc_texturemid = basetexturemid -(topdelta << FRACBITS)
      if typeof(colfunc) == "function" then
        colfunc()
      else
        R_DrawColumn()
      end if
    end if

    off = off + run + 4
  end while

  dc_texturemid = basetexturemid
  dc_source = oldSource
  dc_sourcebase = oldSourceBase
  dc_sourceoff = oldSourceOff
  dc_sourcelen = oldSourceLen
  dc_sourceclamp = oldSourceClamp
end function

/// Retains the classic public hook; patch-column decoding is handled by _RT_DrawMaskedPatchColumn with explicit
/// bytes and offsets.
/// @param column Column value supplied to `R_DrawMaskedColumn`.
function R_DrawMaskedColumn(column)

  column = column
end function

/// Returns the active sprite render target.
/// @internal
function inline _RT_TargetBuffer()
  if typeof(RH_IsActive) == "function" and RH_IsActive() then return RH_Buffer() end if
  if typeof(screens) == "array" and len(screens) > 0 then return screens[0] end if
  return void
end function

/// Resolves the high-resolution source scale for an upscaled sprite entry.
/// @param entry Entry value supplied to `_RT_SourceScaleFromEntry`.
/// @param origW Orig w value supplied to `_RT_SourceScaleFromEntry`.
/// @internal
function inline _RT_SourceScaleFromEntry(entry, origW)
  if entry is void or typeof(entry.width) != "int" or typeof(origW) != "int" or origW <= 0 then return 1 end if
  s = _RT_IDiv(entry.width, origW)
  if s < 1 then s = 1 end if
  if s > 4 then s = 4 end if
  return s
end function

/// Draws an upscaled transparent sprite image directly into the active framebuffer.
/// @param vis Vis value supplied to `_RT_DrawUpscaledLinearSprite`.
/// @param entry Entry value supplied to `_RT_DrawUpscaledLinearSprite`.
/// @param origW Orig w value supplied to `_RT_DrawUpscaledLinearSprite`.
/// @param x1 Horizontal coordinate of the first endpoint.
/// @param x2 Horizontal coordinate of the second endpoint.
/// @internal
function _RT_DrawUpscaledLinearSprite(vis, entry, origW, x1, x2)
  global dc_translation

  if vis is void or entry is void then return false end if
  if typeof(entry.data) != "bytes" or typeof(entry.width) != "int" or typeof(entry.height) != "int" then return false end if
  if entry.width <= 0 or entry.height <= 0 or len(entry.data) < entry.width * entry.height then return false end if
  if typeof(vis.colormap) != "bytes" then return false end if

  dest = _RT_TargetBuffer()
  if typeof(dest) != "bytes" then return false end if
  if not _RT_IsSeq(columnofs) or not _RT_IsSeq(ylookup) then return false end if

  srcScale = _RT_SourceScaleFromEntry(entry, origW)
  if srcScale <= 0 then srcScale = 1 end if

  tr = void
  if (vis.mobjflags & mobjflag_t.MF_TRANSLATION) != 0 and typeof(translationtables) == "bytes" and len(translationtables) >=(256 * 3) then
    toff =(vis.mobjflags & mobjflag_t.MF_TRANSLATION) >>(mobjflag_t.MF_TRANSSHIFT - 8)
    base = toff - 256
    if base < 0 then base = 0 end if
    if (base + 256) <= len(translationtables) then tr = slice(translationtables, base, 256) end if
  end if

  frac = vis.startfrac
  spryscale = vis.scale
  if spryscale <= 0 then return false end if
  sprtopscreen = centeryfrac - FixedMul(vis.texturemid, spryscale)
  origH = _RT_IDiv(entry.height, srcScale)
  if origH <= 0 then origH = entry.height end if
  spriteTopY = sprtopscreen >> FRACBITS
  spriteBottomY = (sprtopscreen + spryscale * origH + FRACUNIT - 1) >> FRACBITS

  x = x1
  while x <= x2
    sampleFrac = frac * srcScale
    sx = sampleFrac >> FRACBITS
    hrep = 1 << detailshift
    if hrep < 1 then hrep = 1 end if
    destColumn = x << detailshift
    if sx >= 0 and sx < entry.width and destColumn >= 0 and destColumn < len(columnofs) then
      bclip = _RT_GetClipValue(mfloorclip, x, viewheight)
      tclip = _RT_GetClipValue(mceilingclip, x, -1)
      yl = tclip + 1
      yh = bclip - 1
      if yl < spriteTopY then yl = spriteTopY end if
      if yh > spriteBottomY then yh = spriteBottomY end if
      if yl < 0 then yl = 0 end if
      if yh >= viewheight then yh = viewheight - 1 end if
      if yh >= yl then
        sourceFixed = FixedDiv(((yl << FRACBITS) +(FRACUNIT >> 1)) - sprtopscreen, spryscale)
        sourceStep = FixedDiv(FRACUNIT, spryscale)
        y = yl
        while y <= yh
          sy = (sourceFixed * srcScale) >> FRACBITS
          if sy >= 0 and sy < entry.height then
            c = entry.data[sy * entry.width + sx]
            if c != RT_TRANSPARENT_INDEX then
              if typeof(tr) == "bytes" and c < len(tr) then c = tr[c] end if
              if c >= 0 and c < len(vis.colormap) then
                outc = vis.colormap[c]
                rx = 0
                while rx < hrep and(destColumn + rx) < len(columnofs)
                  di = ylookup[y] + columnofs[destColumn + rx]
                  if di >= 0 and di < len(dest) then dest[di] = outc end if
                  rx = rx + 1
                end while
              end if
            end if
          end if
          sourceFixed = sourceFixed + sourceStep
          y = y + 1
        end while
      end if
    end if
    frac = frac + vis.xiscale
    x = x + 1
  end while

  return true
end function

/// Selects fuzz/translation/base drawing, maps screen columns to patch columns, and renders a clipped visible
/// sprite.
/// @param vis Vis value supplied to `R_DrawVisSprite`.
/// @param x1 Horizontal coordinate of the first endpoint.
/// @param x2 Horizontal coordinate of the second endpoint.
function R_DrawVisSprite(vis, x1, x2)
  global _rt_drawTranslation
  global colfunc
  global basecolfunc
  global fuzzcolfunc
  global transcolfunc
  global dc_colormap
  global dc_translation
  global dc_iscale
  global dc_texturemid
  global dc_x
  global spryscale
  global sprtopscreen

  if vis is void then return end if
  if typeof(vis.patch) != "int" or vis.patch < 0 then return end if
  if x2 < x1 then return end if

  patch = W_CacheLumpNum(vis.patch + firstspritelump, PU_CACHE)
  if typeof(patch) != "bytes" then return end if

  pw = Patch_Width(patch)
  if typeof(pw) != "int" or pw <= 0 then return end if

  oldColFunc = colfunc
  oldTranslation = dc_translation
  _rt_drawTranslation = void
  dc_translation = void

  dc_colormap = vis.colormap
  if vis.colormap is void then
    if typeof(fuzzcolfunc) == "function" then
      colfunc = fuzzcolfunc
    else
      dc_colormap = _RT_ShadowColormap()
    end if
  else if (vis.mobjflags & mobjflag_t.MF_TRANSLATION) != 0 and typeof(transcolfunc) == "function" and typeof(translationtables) == "bytes" and len(translationtables) >=(256 * 3) then
    colfunc = transcolfunc
    toff =(vis.mobjflags & mobjflag_t.MF_TRANSLATION) >>(mobjflag_t.MF_TRANSSHIFT - 8)
    base = toff - 256
    if base < 0 then base = 0 end if
    if (base + 256) <= len(translationtables) then
      dc_translation = slice(translationtables, base, 256)
      _rt_drawTranslation = dc_translation
    end if
  else
    if typeof(basecolfunc) == "function" then colfunc = basecolfunc end if
  end if

  if typeof(colfunc) != "function" then colfunc = R_DrawColumn end if
  if colfunc != fuzzcolfunc and typeof(dc_colormap) != "bytes" then
    dc_colormap = _RT_ShadowColormap()
  end if
  if colfunc != fuzzcolfunc and typeof(dc_colormap) != "bytes" then
    colfunc = oldColFunc
    dc_translation = oldTranslation
    _rt_drawTranslation = void
    return
  end if

  dc_iscale = _RT_Abs(vis.xiscale) >> detailshift
  if dc_iscale <= 0 then dc_iscale = FRACUNIT end if
  dc_texturemid = vis.texturemid
  frac = vis.startfrac
  spryscale = vis.scale
  sprtopscreen = centeryfrac - FixedMul(dc_texturemid, spryscale)

  dc_x = x1
  while dc_x <= x2
    texturecolumn = frac >> FRACBITS
    if texturecolumn >= 0 and texturecolumn < pw then
      coloff = Patch_ColumnOffset(patch, texturecolumn)
      if typeof(coloff) == "int" and coloff >= 0 and coloff < len(patch) then
        _RT_DrawMaskedPatchColumn(patch, coloff)
      end if
    end if
    frac = frac + vis.xiscale
    dc_x = dc_x + 1
  end while
  colfunc = oldColFunc
  dc_translation = oldTranslation
  _rt_drawTranslation = void
end function

/// Transforms a world mobj into screen bounds, selects rotation/flip/light, and appends a visible sprite when
/// in view.
/// @param thing World object affected by the operation.
function R_ProjectSprite(thing)
  global viewx
  global viewy
  global viewcos
  global viewsin
  global projection
  global centerxfrac
  global viewwidth
  global detailshift
  global viewz
  global fixedcolormap

  if thing is void then
    _RT_ProfReject(1)
    return false
  end if
  if not _RT_IsSeq(sprites) then
    _RT_ProfReject(2)
    return false
  end if
  spriteIdx = _RT_SpriteIndex(thing.sprite)
  if spriteIdx < 0 or spriteIdx >= len(sprites) then
    _RT_ProfReject(3)
    return false
  end if

  thingx = _RT_S32(thing.x)
  thingy = _RT_S32(thing.y)
  thingz = _RT_S32(thing.z)
  thingangle = _RT_AngNorm(thing.angle)
  vx = _RT_S32(viewx)
  vy = _RT_S32(viewy)
  vz = _RT_S32(viewz)

  tr_x = _RT_S32(thingx - vx)
  tr_y = _RT_S32(thingy - vy)

  gxt = FixedMul(tr_x, _RT_S32(viewcos))
  gyt = -FixedMul(tr_y, _RT_S32(viewsin))
  tz = _RT_S32(gxt - gyt)
  if tz < MINZ then
    _RT_ProfReject(4)
    return false
  end if

  xscale = FixedDiv(projection, tz)

  gxt = -FixedMul(tr_x, _RT_S32(viewsin))
  gyt = FixedMul(tr_y, _RT_S32(viewcos))
  tx = _RT_S32(-(gyt + gxt))
  if _RT_Abs(tx) >(tz << 2) then
    _RT_ProfReject(5)
    return false
  end if

  sprdef = sprites[spriteIdx]
  if sprdef is void or typeof(sprdef.numframes) != "int" or sprdef.numframes <= 0 then
    _RT_ProfReject(6)
    return false
  end if

  frameIdx = thing.frame & FF_FRAMEMASK
  if frameIdx < 0 or frameIdx >= sprdef.numframes then
    _RT_ProfReject(7)
    return false
  end if
  sprframe = sprdef.spriteframes[frameIdx]
  if sprframe is void then
    _RT_ProfReject(8)
    return false
  end if

  rot = 0
  lump = -1
  flip = 0
  if sprframe.rotate == 1 then
    ang = R_PointToAngle(thingx, thingy)

    angdelta = _RT_AngNorm(ang - thingangle +((ANG45 >> 1) * 9))
    rot =(angdelta >> 29) & 7
    lump = sprframe.lump[rot]
    flip = sprframe.flip[rot]
  else
    lump = sprframe.lump[0]
    flip = sprframe.flip[0]
  end if
  if typeof(lump) != "int" or lump < 0 or lump >= numspritelumps then
    _RT_ProfReject(9)
    return false
  end if

  tx = _RT_S32(tx - spriteoffset[lump])
  x1 =(centerxfrac + FixedMul(tx, xscale)) >> FRACBITS
  if x1 > viewwidth then
    _RT_ProfReject(10)
    return false
  end if

  tx = _RT_S32(tx + spritewidth[lump])
  x2 =((centerxfrac + FixedMul(tx, xscale)) >> FRACBITS) - 1
  if x2 < 0 then
    _RT_ProfReject(11)
    return false
  end if

  vis = R_NewVisSprite()
  if vis is void then
    _RT_ProfReject(12)
    return false
  end if

  vis.mobjflags = thing.flags
  vis.scale = xscale << detailshift
  vis.gx = thingx
  vis.gy = thingy
  vis.gz = thingz
  vis.gzt = _RT_S32(thingz + spritetopoffset[lump])
  vis.texturemid = _RT_S32(vis.gzt - vz)
  vis.x1 = x1
  if vis.x1 < 0 then vis.x1 = 0 end if
  vis.x2 = x2
  if vis.x2 >= viewwidth then vis.x2 = viewwidth - 1 end if

  iscale = FixedDiv(FRACUNIT, xscale)
  if flip != 0 then
    vis.startfrac = spritewidth[lump] - 1
    vis.xiscale = -iscale
  else
    vis.startfrac = 0
    vis.xiscale = iscale
  end if
  if vis.x1 > x1 then
    vis.startfrac = vis.startfrac + vis.xiscale *(vis.x1 - x1)
  end if
  vis.patch = lump

  if (thing.flags & mobjflag_t.MF_SHADOW) != 0 then
    vis.colormap = void
  else if typeof(fixedcolormap) == "bytes" then
    vis.colormap = fixedcolormap
  else if (thing.frame & FF_FULLBRIGHT) != 0 then
    vis.colormap = _RT_ColormapAt(0)
  else
    idx = xscale >>(LIGHTSCALESHIFT - detailshift)
    if idx >= MAXLIGHTSCALE then idx = MAXLIGHTSCALE - 1 end if
    if idx < 0 then idx = 0 end if
    if _RT_IsSeq(spritelights) and len(spritelights) > 0 then
      if idx >= len(spritelights) then idx = len(spritelights) - 1 end if
      vis.colormap = spritelights[idx]
    else
      vis.colormap = _RT_ColormapAt(0)
    end if
  end if

  _RT_ProfProjected()
  return true
end function

/// Projects each non-viewplayer thing in a sector once per validcount using that sector's light row.
/// @param sec Sec value supplied to `R_AddSprites`.
function R_AddSprites(sec)
  global viewplayer
  if sec is void then return end if

  if typeof(sec.validcount) == "int" and sec.validcount == validcount then
    return
  end if
  sec.validcount = validcount

  lightnum =(sec.lightlevel >> LIGHTSEGSHIFT) + extralight
  _RT_SelectSpriteLights(lightnum)

  thing = sec.thinglist
  guard = 0
  while thing is not void and guard < 4096
    if viewplayer is not void and viewplayer.mo is not void and thing == viewplayer.mo then
      thing = thing.snext
      guard = guard + 1
      continue
    end if
    if typeof(thing) == "struct" then _RT_ProfThingSeen() end if
    _ = R_ProjectSprite(thing)
    thing = thing.snext
    guard = guard + 1
  end while
end function

/// Draws the display player's first-person weapon/flash layers after validating player ownership.
function R_AddPSprites()
  if not _RT_IsSeq(players) then return end if
  if displayplayer < 0 or displayplayer >= len(players) then return end if
  player = players[displayplayer]
  if player is void then return end if
  R_DrawPlayerSprites(player)
end function

/// Copies active visible sprites into reusable storage and insertion-sorts them back-to-front by projection
/// scale.
function R_SortVisSprites()
  global _rt_sorted
  global _rt_sorted_count

  if len(_rt_sorted) < MAXVISSPRITES then
    _rt_sorted = _rt_sorted + array(MAXVISSPRITES - len(_rt_sorted))
  end if

  _rt_sorted_count = 0
  i = 0
  while i < vissprite_p and i < len(vissprites) and i < len(_rt_sorted)
    _rt_sorted[i] = vissprites[i]
    _rt_sorted_count = _rt_sorted_count + 1
    i = i + 1
  end while

  i = 1
  while i < _rt_sorted_count
    key = _rt_sorted[i]
    j = i - 1
    while j >= 0 and _rt_sorted[j].scale > key.scale
      _rt_sorted[j + 1] = _rt_sorted[j]
      j = j - 1
    end while
    _rt_sorted[j + 1] = key
    i = i + 1
  end while
end function

/// Builds per-column top/bottom clips from overlapping drawseg silhouettes, draws nearer masked walls, then
/// renders the sprite.
/// @param spr Spr value supplied to `R_DrawSprite`.
function R_DrawSprite(spr)
  if spr is void then return end if
  if spr.x2 < spr.x1 then return end if

  clipbot = _rt_clipbot_work
  cliptop = _rt_cliptop_work
  x = spr.x1
  while x <= spr.x2 and x < viewwidth
    if x >= 0 then
      clipbot[x] = -2
      cliptop[x] = -2
    end if
    x = x + 1
  end while

  i = ds_p - 1
  if _RT_IsSeq(drawsegs) and len(drawsegs) > 0 and i >= len(drawsegs) then
    i = len(drawsegs) - 1
  end if
  while i >= 0 and _RT_IsSeq(drawsegs) and i < len(drawsegs)
    ds = drawsegs[i]
    if ds is void then
      i = i - 1
      continue
    end if

    if ds.x1 > spr.x2 or ds.x2 < spr.x1 then
      i = i - 1
      continue
    end if
    if ds.silhouette == 0 and(ds.maskedtexturecol is void) then
      i = i - 1
      continue
    end if

    r1 = ds.x1
    if r1 < spr.x1 then r1 = spr.x1 end if
    r2 = ds.x2
    if r2 > spr.x2 then r2 = spr.x2 end if

    scale = ds.scale1
    lowscale = ds.scale2
    if ds.scale2 > scale then
      scale = ds.scale2
      lowscale = ds.scale1
    end if

    sidev = 0
    if ds.curline is not void then
      sidev = R_PointOnSegSide(spr.gx, spr.gy, ds.curline)
    end if
    if scale < spr.scale or(lowscale < spr.scale and sidev == 0) then
      if ds.maskedtexturecol is not void then
        R_RenderMaskedSegRange(ds, r1, r2)
      end if
      i = i - 1
      continue
    end if

    sil = ds.silhouette
    if (sil & SIL_BOTTOM) != 0 and spr.gz >= ds.bsilheight then sil = sil ^ SIL_BOTTOM end if
    if (sil & SIL_TOP) != 0 and spr.gzt <= ds.tsilheight then sil = sil ^ SIL_TOP end if
    sb = ds.sprbottomclip
    st = ds.sprtopclip

    if sil == SIL_BOTTOM then
      x = r1
      while x <= r2
        if clipbot[x] == -2 then
          v = _RT_GetClipValue(sb, x, -2)
          if v != -2 then clipbot[x] = v end if
        end if
        x = x + 1
      end while
    else if sil == SIL_TOP then
      x = r1
      while x <= r2
        if cliptop[x] == -2 then
          v = _RT_GetClipValue(st, x, -2)
          if v != -2 then cliptop[x] = v end if
        end if
        x = x + 1
      end while
    else if sil == SIL_BOTH then
      x = r1
      while x <= r2
        if clipbot[x] == -2 then
          v = _RT_GetClipValue(sb, x, -2)
          if v != -2 then clipbot[x] = v end if
        end if
        if cliptop[x] == -2 then
          v = _RT_GetClipValue(st, x, -2)
          if v != -2 then cliptop[x] = v end if
        end if
        x = x + 1
      end while
    end if

    i = i - 1
  end while

  x = spr.x1
  while x <= spr.x2 and x < viewwidth
    if x >= 0 then
      if clipbot[x] == -2 then clipbot[x] = viewheight end if
      if cliptop[x] == -2 then cliptop[x] = -1 end if
    end if
    x = x + 1
  end while

  global mfloorclip
  mfloorclip = clipbot
  global mceilingclip
  mceilingclip = cliptop
  _RT_ProfDrawn()
  R_DrawVisSprite(spr, spr.x1, spr.x2)
end function

/// Sorts and renders all projected world sprites unless the sprite debug-disable flag is set.
function R_DrawSprites()
  global _rt_debug_disable_sprites
  if _rt_debug_disable_sprites != 0 then
    return
  end if
  R_SortVisSprites()
  i = 0
  while i < _rt_sorted_count and i < len(_rt_sorted)
    spr = _rt_sorted[i]
    if spr is not void then R_DrawSprite(spr) end if
    i = i + 1
  end while
end function

/// Sizes sprite clip sentinels and builds every named sprite definition from the WAD sprite-lump range.
/// @param namelist Namelist value supplied to `R_InitSprites`.
function R_InitSprites(namelist)
  global numsprites
  global sprites

  targetW = viewwidth
  if typeof(targetW) != "int" or targetW <= 0 then targetW = SCREENWIDTH end if

  if len(negonearray) != targetW then
    global negonearray
    negonearray = array(targetW, -1)
    global screenheightarray
    screenheightarray = array(targetW, viewheight)
  end if

  if not _RT_IsSeq(namelist) then
    numsprites = 0
    sprites =[]
    return
  end if

  numsprites = len(namelist)
  sprites = array(numsprites)
  i = 0
  while i < numsprites
    sn = _RT_Name4(namelist[i])
    sprites[i] = _RT_BuildSpriteDef(sn)
    i = i + 1
  end while

  if typeof(devparm) != "void" and devparm then
    active = 0
    i = 0
    while i < len(sprites)
      if sprites[i] is not void and typeof(sprites[i].numframes) == "int" and sprites[i].numframes > 0 then
        active = active + 1
      end if
      i = i + 1
    end while
    print "R_InitSprites: defs=" + numsprites + " active=" + active + " first=" + firstspritelump + " count=" + numspritelumps
  end if
end function

/// Compatibility entry point that rebuilds sprite definitions and clip arrays from a name list.
/// @param namelist Namelist value supplied to `R_InitSpriteDefs`.
function R_InitSpriteDefs(namelist)
  R_InitSprites(namelist)
end function

/// Projects one weapon/flash state in screen space, selects invisibility or lighting colormap, and draws its
/// patch.
/// @param player Player state affected by the operation.
/// @param psp Psp value supplied to `R_DrawPSprite`.
function R_DrawPSprite(player, psp)
  if player is void or psp is void or psp.state is void then return end if
  if not _RT_IsSeq(sprites) then return end if

  st = psp.state
  spriteIdx = _RT_SpriteIndex(st.sprite)
  if spriteIdx < 0 or spriteIdx >= len(sprites) then return end if
  sprdef = sprites[spriteIdx]
  if sprdef is void or typeof(sprdef.numframes) != "int" or sprdef.numframes <= 0 then return end if

  frameIdx = st.frame & FF_FRAMEMASK
  if frameIdx < 0 or frameIdx >= sprdef.numframes then return end if
  sprframe = sprdef.spriteframes[frameIdx]
  if sprframe is void then return end if

  lump = sprframe.lump[0]
  flip = sprframe.flip[0]
  if typeof(lump) != "int" or lump < 0 or lump >= numspritelumps then return end if

  tx = psp.sx - 160 * FRACUNIT
  tx = tx - spriteoffset[lump]
  x1 =(centerxfrac + FixedMul(tx, pspritescale)) >> FRACBITS
  if x1 > viewwidth then return end if

  tx = tx + spritewidth[lump]
  x2 =((centerxfrac + FixedMul(tx, pspritescale)) >> FRACBITS) - 1
  if x2 < 0 then return end if

  vis = _makeVisSprite()
  vis.mobjflags = 0
  vis.texturemid =(BASEYCENTER << FRACBITS) +(FRACUNIT >> 1) -(psp.sy - spritetopoffset[lump])
  vis.x1 = x1
  if vis.x1 < 0 then vis.x1 = 0 end if
  vis.x2 = x2
  if vis.x2 >= viewwidth then vis.x2 = viewwidth - 1 end if
  vis.scale = pspritescale << detailshift

  if flip != 0 then
    vis.xiscale = -pspriteiscale
    vis.startfrac = spritewidth[lump] - 1
  else
    vis.xiscale = pspriteiscale
    vis.startfrac = 0
  end if
  if vis.x1 > x1 then
    vis.startfrac = vis.startfrac + vis.xiscale *(vis.x1 - x1)
  end if
  vis.patch = lump

  invis = 0
  invIdx = -1
  if _RT_IsSeq(player.powers) then
    invIdx = _RT_EnumIndex(pw_invisibility, len(player.powers))
  end if
  if _RT_IsSeq(player.powers) and invIdx >= 0 and invIdx < len(player.powers) then
    invis = player.powers[invIdx]
    if typeof(invis) != "int" then invis = 0 end if
  end if

  if invis >(4 * 32) or(invis & 8) != 0 then
    vis.colormap = void
  else if typeof(fixedcolormap) == "bytes" then
    vis.colormap = fixedcolormap
  else if (st.frame & FF_FULLBRIGHT) != 0 then
    vis.colormap = _RT_ColormapAt(0)
  else if _RT_IsSeq(spritelights) and len(spritelights) > 0 then
    idx = MAXLIGHTSCALE - 1
    if idx >= len(spritelights) then idx = len(spritelights) - 1 end if
    vis.colormap = spritelights[idx]
  else
    vis.colormap = _RT_ColormapAt(0)
  end if

  R_DrawVisSprite(vis, vis.x1, vis.x2)
end function

/// Selects the player's sector lighting, disables world clipping, and draws each active first-person sprite
/// layer.
/// @param player Player state affected by the operation.
function R_DrawPlayerSprites(player)
  global mfloorclip
  global mceilingclip

  if player is void or player.mo is void or player.mo.subsector is void or player.mo.subsector.sector is void then return end if
  if not _RT_IsSeq(player.psprites) then return end if

  lightnum =(player.mo.subsector.sector.lightlevel >> LIGHTSEGSHIFT) + extralight
  _RT_SelectSpriteLights(lightnum)

  mfloorclip = screenheightarray
  mceilingclip = negonearray

  count = NUMPSPRITES
  if typeof(count) != "int" or count <= 0 then count = len(player.psprites) end if
  if count > len(player.psprites) then count = len(player.psprites) end if

  i = 0
  while i < count
    psp = player.psprites[i]
    if psp is not void and psp.state is not void then
      R_DrawPSprite(player, psp)
    end if
    i = i + 1
  end while
end function

/// Retains the classic clipping hook; drawseg silhouette clipping is integrated into R_DrawSprite.
/// @param vis Vis value supplied to `R_ClipVisSprite`.
/// @param xl Xl value supplied to `R_ClipVisSprite`.
/// @param xh Xh value supplied to `R_ClipVisSprite`.
function R_ClipVisSprite(vis, xl, xh)
  vis = vis
  xl = xl
  xh = xh

end function

/// Draws sorted world sprites, remaining masked wall ranges, and first-person sprites in final masked-pass
/// order.
function R_DrawMasked()
  R_DrawSprites()

  i = ds_p - 1
  if _RT_IsSeq(drawsegs) and len(drawsegs) > 0 and i >= len(drawsegs) then
    i = len(drawsegs) - 1
  end if
  while i >= 0 and _RT_IsSeq(drawsegs) and i < len(drawsegs)
    ds = drawsegs[i]
    if ds is not void then
      if ds.maskedtexturecol is not void then
        R_RenderMaskedSegRange(ds, ds.x1, ds.x2)
      end if
    end if
    i = i - 1
  end while

  if typeof(viewangleoffset) != "int" or viewangleoffset == 0 then
    R_AddPSprites()
  end if
end function



