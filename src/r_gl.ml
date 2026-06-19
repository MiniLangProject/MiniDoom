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

  Script: r_gl.ml
  Purpose: Optional OpenGL level renderer prototype using real 3D wall geometry.
*/
import doomdef
import doomdata
import doomstat
import m_fixed
import tables
import r_state
import r_data
import r_sky
import r_upscaled
import w_wad
import info
import p_mobj
import i_gl
import std.math

const RGL_ANGLE_FULL = 4294967296.0
const RGL_FF_FRAMEMASK = 0x7fff
const RGL_WORLD_SPRITE_FOOT_LIFT = 4.0
const RGL_BASEYCENTER = 100
const RGL_DYNAMIC_SETTLE_FRAMES = 3
const RGL_GEOM_FIX_SCALE = 65536.0
const RGL_GEOM_VERSION = 4
const RGL_CAMERA_BACK_OFFSET = 0.0

rgl_tex_keys =[]
rgl_tex_ids =[]
rgl_texnum_tex_ids =[]
rgl_texnum_trans_tex_ids =[]
rgl_flat_tex_ids =[]
rgl_sprite_tex_ids =[]
rgl_palette_revision_seen = -1
rgl_view_x = 0.0
rgl_view_y = 0.0
rgl_view_yaw = 0.0
rgl_building_cache = false
rgl_flat_volatile_only = false
rgl_cache_target = 0
rgl_current_light = 255
rgl_force_software = false
rgl_geom_ready = false
rgl_geom_sig_map = -1
rgl_geom_sig_segs = -1
rgl_geom_sig_lines = -1
rgl_geom_sig_nodes = -1
rgl_geom_sig_subsectors = -1
rgl_geom_sig_sector_motion = -1
rgl_geom_sig_sides = -1
rgl_pending_sig_sector_motion = -1
rgl_pending_sig_sides = -1
rgl_pending_stable_frames = 0
rgl_volatile_sig_map = -1
rgl_volatile_sectors =[]
rgl_volatile_subsectors =[]
rgl_volatile_segs =[]
rgl_volatile_lines =[]
rgl_boundary_quads =[]
rgl_wall_quads =[]
rgl_masked_quads =[]
rgl_flat_tris =[]
rgl_depth_tris =[]
rgl_depth_quads =[]
rgl_dyn_light_x =[]
rgl_dyn_light_y =[]
rgl_dyn_light_z =[]
rgl_dyn_light_r =[]
rgl_dyn_light_g =[]
rgl_dyn_light_b =[]
rgl_dyn_light_radius =[]
rgl_dyn_light_strength =[]
const RGL_MAX_DYNAMIC_LIGHTS = 32

const RGL_CACHE_BOUNDARY = 1
const RGL_CACHE_WALL = 2
const RGL_CACHE_MASKED = 3

/*
* Struct: rgl_quad_t
* Purpose: Describes quad geometry or asset data used by the OpenGL renderer system.
*/
struct rgl_quad_t
  texnum
  transparent
  light
  x0
  y0
  z0
  s0
  t0
  x1
  y1
  z1
  s1
  t1
  x2
  y2
  z2
  s2
  t2
  x3
  y3
  z3
  s3
  t3
end struct

/*
* Struct: rgl_flat_tri_t
* Purpose: Describes flat tri geometry or asset data used by the OpenGL renderer system.
*/
struct rgl_flat_tri_t
  flatnum
  light
  x0
  y0
  z0
  s0
  t0
  x1
  y1
  z1
  s1
  t1
  x2
  y2
  z2
  s2
  t2
end struct

/*
* Struct: rgl_depth_tri_t
* Purpose: Describes depth tri geometry or asset data used by the OpenGL renderer system.
*/
struct rgl_depth_tri_t
  x0
  y0
  z0
  x1
  y1
  z1
  x2
  y2
  z2
end struct

/*
* Struct: rgl_depth_quad_t
* Purpose: Describes depth quad geometry or asset data used by the OpenGL renderer system.
*/
struct rgl_depth_quad_t
  x0
  y0
  z0
  x1
  y1
  z1
  x2
  y2
  z2
  x3
  y3
  z3
end struct

/*
* Function: RGL_SetForceSoftware
* Purpose: Updates force software state for the OpenGL renderer.
*/
function RGL_SetForceSoftware(v)
  global rgl_force_software

  rgl_force_software = false
  if typeof(v) == "bool" and v then rgl_force_software = true end if
end function

/*
* Function: RGL_IsSeq
* Purpose: Checks sequence conditions for the OpenGL renderer.
*/
function inline RGL_IsSeq(v)
  return typeof(v) == "array" or typeof(v) == "list"
end function

/*
* Function: RGL_SeqLen
* Purpose: Provides len helper behavior for the OpenGL renderer.
*/
function inline RGL_SeqLen(v)
  if RGL_IsSeq(v) then return len(v) end if
  return -1
end function

/*
* Function: RGL_WriteU32
* Purpose: Writes U32 data for the OpenGL renderer.
*/
function inline RGL_WriteU32(buf, off, value)
  v = value
  if v < 0 then v = v + 4294967296 end if
  buf[off] = v & 255
  buf[off + 1] =(v >> 8) & 255
  buf[off + 2] =(v >> 16) & 255
  buf[off + 3] =(v >> 24) & 255
end function

/*
* Function: RGL_WriteS32
* Purpose: Writes s32 data for the OpenGL renderer.
*/
function inline RGL_WriteS32(buf, off, value)
  RGL_WriteU32(buf, off, value)
end function

/*
* Function: RGL_ReadU32
* Purpose: Reads U32 data for the OpenGL renderer.
*/
function inline RGL_ReadU32(buf, off)
  return buf[off] +(buf[off + 1] << 8) +(buf[off + 2] << 16) +(buf[off + 3] << 24)
end function

/*
* Function: RGL_ReadS32
* Purpose: Reads s32 data for the OpenGL renderer.
*/
function inline RGL_ReadS32(buf, off)
  v = RGL_ReadU32(buf, off)
  if v >= 2147483648 then v = v - 4294967296 end if
  return v
end function

/*
* Function: RGL_FloatToGeom
* Purpose: Converts float to geometry values for the OpenGL renderer.
*/
function inline RGL_FloatToGeom(v)
  if typeof(v) != "float" and typeof(v) != "int" then v = 0.0 end if
  if v >= 0 then return std.math.floor(v * RGL_GEOM_FIX_SCALE + 0.5) end if
  return std.math.ceil(v * RGL_GEOM_FIX_SCALE - 0.5)
end function

/*
* Function: RGL_GeomToFloat
* Purpose: Converts geometry to float values for the OpenGL renderer.
*/
function inline RGL_GeomToFloat(v)
  return v / RGL_GEOM_FIX_SCALE
end function

/*
* Function: RGL_MapGeomLumpName
* Purpose: Provides geom lump name helper behavior for the OpenGL renderer.
*/
function RGL_MapGeomLumpName()
  if gamemode == GameMode_t.commercial then
    m = gamemap
    if typeof(m) != "int" then m = 1 end if
    if m < 0 then m = 0 end if
    tens = m / 10
    if tens >= 0 then tens = std.math.floor(tens) else tens = std.math.ceil(tens) end if
    ones = m - tens * 10
    return "MAP" + tens + ones + "GL"
  end if
  e = gameepisode
  m = gamemap
  if typeof(e) != "int" then e = 1 end if
  if typeof(m) != "int" then m = 1 end if
  return "E" + e + "M" + m + "GL"
end function

/*
* Function: RGL_SectorMotionSignature
* Purpose: Provides motion signature helper behavior for the OpenGL renderer.
*/
function RGL_SectorMotionSignature()
  if not RGL_IsSeq(sectors) then return -1 end if
  h = len(sectors) * 65537
  i = 0
  while i < len(sectors)
    sec = sectors[i]
    if sec is not void then
      if typeof(sec.floorheight) == "int" then h = h +(i + 1) * sec.floorheight end if
      if typeof(sec.ceilingheight) == "int" then h = h +(i + 3) * sec.ceilingheight end if
      // Sector light changes do not change mesh geometry; including them here makes flicker sectors thrash the cache.
    end if
    i = i + 1
  end while
  return h
end function

/*
* Function: RGL_SideTextureSignature
* Purpose: Provides texture signature helper behavior for the OpenGL renderer.
*/
function RGL_SideTextureSignature()
  if not RGL_IsSeq(sides) then return -1 end if
  h = len(sides) * 131071
  i = 0
  while i < len(sides)
    sd = sides[i]
    if sd is not void then
      if typeof(sd.toptexture) == "int" then h = h +(i + 1) * sd.toptexture end if
      if typeof(sd.midtexture) == "int" then h = h +(i + 3) * sd.midtexture end if
      if typeof(sd.bottomtexture) == "int" then h = h +(i + 5) * sd.bottomtexture end if
      if typeof(sd.textureoffset) == "int" then h = h +(i + 7) * sd.textureoffset end if
      if typeof(sd.rowoffset) == "int" then h = h +(i + 11) * sd.rowoffset end if
    end if
    i = i + 1
  end while
  return h
end function

/*
* Function: RGL_SectorIndex
* Purpose: Finds the current map index for a sector reference.
*/
function RGL_SectorIndex(sec)
  if sec is void or not RGL_IsSeq(sectors) then return -1 end if
  i = 0
  while i < len(sectors)
    if sectors[i] == sec then return i end if
    i = i + 1
  end while
  return -1
end function

/*
* Function: RGL_MarkVolatileSectorIndex
* Purpose: Marks a sector as dynamic so it is drawn outside the static GL cache.
*/
function RGL_MarkVolatileSectorIndex(idx)
  global rgl_volatile_sectors

  if idx < 0 or idx >= len(rgl_volatile_sectors) then return end if
  rgl_volatile_sectors[idx] = true
end function

/*
* Function: RGL_MarkVolatileSector
* Purpose: Marks a sector reference as dynamic for the OpenGL renderer.
*/
function RGL_MarkVolatileSector(sec)
  idx = RGL_SectorIndex(sec)
  if idx >= 0 then RGL_MarkVolatileSectorIndex(idx) end if
end function

/*
* Function: RGL_IsVolatileSector
* Purpose: Returns true for sectors that may move or need uncached wall/flat updates.
*/
function RGL_IsVolatileSector(sec)
  if sec is void then return false end if
  if sec.specialdata is not void then return true end if
  idx = RGL_SectorIndex(sec)
  if idx < 0 or idx >= len(rgl_volatile_sectors) then return false end if
  return rgl_volatile_sectors[idx]
end function

/*
* Function: RGL_IsVolatileSubsectorIndex
* Purpose: Checks whether a subsector belongs to dynamic sector geometry.
*/
function RGL_IsVolatileSubsectorIndex(idx)
  if idx < 0 or not RGL_IsSeq(subsectors) or idx >= len(subsectors) then return false end if
  ss = subsectors[idx]
  if ss is void then return false end if
  return RGL_IsVolatileSector(ss.sector)
end function

/*
* Function: RGL_IsVolatileSegIndex
* Purpose: Checks whether a seg touches dynamic sector geometry.
*/
function RGL_IsVolatileSegIndex(idx)
  if idx < 0 or not RGL_IsSeq(segs) or idx >= len(segs) then return false end if
  sg = segs[idx]
  if sg is void then return false end if
  if RGL_IsVolatileSector(sg.frontsector) then return true end if
  if RGL_IsVolatileSector(sg.backsector) then return true end if
  return false
end function

/*
* Function: RGL_IsVolatileLineIndex
* Purpose: Checks whether a line touches dynamic sector geometry.
*/
function RGL_IsVolatileLineIndex(idx)
  if idx < 0 or not RGL_IsSeq(lines) or idx >= len(lines) then return false end if
  li = lines[idx]
  if li is void then return false end if
  if RGL_IsVolatileSector(li.frontsector) then return true end if
  if RGL_IsVolatileSector(li.backsector) then return true end if
  return false
end function

/*
* Function: RGL_BuildVolatileSectorMap
* Purpose: Precomputes sectors and draw lists that should remain dynamic.
*/
function RGL_BuildVolatileSectorMap(sigMap)
  global rgl_volatile_sig_map
  global rgl_volatile_sectors
  global rgl_volatile_subsectors
  global rgl_volatile_segs
  global rgl_volatile_lines

  rgl_volatile_sig_map = sigMap
  rgl_volatile_sectors =[]
  rgl_volatile_subsectors =[]
  rgl_volatile_segs =[]
  rgl_volatile_lines =[]
  if not RGL_IsSeq(sectors) then return end if

  rgl_volatile_sectors = array(len(sectors), false)
  i = 0
  while i < len(sectors)
    sec = sectors[i]
    if sec is not void then
      if sec.specialdata is not void then rgl_volatile_sectors[i] = true end if
      if typeof(sec.special) == "int" and sec.special != 0 then rgl_volatile_sectors[i] = true end if
    end if
    i = i + 1
  end while

  if RGL_IsSeq(lines) then
    i = 0
    while i < len(lines)
      li = lines[i]
      if li is not void then
        activeLine = false
        if typeof(li.special) == "int" and li.special != 0 then activeLine = true end if
        if li.specialdata is not void then activeLine = true end if
        if activeLine then
          RGL_MarkVolatileSector(li.frontsector)
          RGL_MarkVolatileSector(li.backsector)
          if typeof(li.tag) == "int" and li.tag != 0 then
            si = 0
            while si < len(sectors)
              sec = sectors[si]
              if sec is not void and typeof(sec.tag) == "int" and sec.tag == li.tag then
                RGL_MarkVolatileSectorIndex(si)
              end if
              si = si + 1
            end while
          end if
        end if
      end if
      i = i + 1
    end while
  end if

  if RGL_IsSeq(subsectors) then
    i = 0
    while i < len(subsectors)
      if RGL_IsVolatileSubsectorIndex(i) then rgl_volatile_subsectors = rgl_volatile_subsectors +[i] end if
      i = i + 1
    end while
  end if

  if RGL_IsSeq(segs) then
    i = 0
    while i < len(segs)
      if RGL_IsVolatileSegIndex(i) then rgl_volatile_segs = rgl_volatile_segs +[i] end if
      i = i + 1
    end while
  end if

  if RGL_IsSeq(lines) then
    i = 0
    while i < len(lines)
      if RGL_IsVolatileLineIndex(i) then rgl_volatile_lines = rgl_volatile_lines +[i] end if
      i = i + 1
    end while
  end if
end function

/*
* Function: RGL_EnsureVolatileSectorMap
* Purpose: Keeps the dynamic sector draw lists aligned with the loaded map.
*/
function RGL_EnsureVolatileSectorMap(sigMap)
  if rgl_volatile_sig_map != sigMap then
    RGL_BuildVolatileSectorMap(sigMap)
    return
  end if
  if RGL_IsSeq(sectors) and len(rgl_volatile_sectors) != len(sectors) then
    RGL_BuildVolatileSectorMap(sigMap)
  end if
end function

/*
* Function: RGL_GeometryCacheByteSize
* Purpose: Manages cached geometry Cache Byte Size data for the OpenGL renderer system.
*/
function RGL_GeometryCacheByteSize()
  bc = RGL_SeqLen(rgl_boundary_quads)
  wc = RGL_SeqLen(rgl_wall_quads)
  mc = RGL_SeqLen(rgl_masked_quads)
  fc = RGL_SeqLen(rgl_flat_tris)
  dtc = RGL_SeqLen(rgl_depth_tris)
  dqc = RGL_SeqLen(rgl_depth_quads)
  if bc < 0 then bc = 0 end if
  if wc < 0 then wc = 0 end if
  if mc < 0 then mc = 0 end if
  if fc < 0 then fc = 0 end if
  if dtc < 0 then dtc = 0 end if
  if dqc < 0 then dqc = 0 end if
  return 60 + bc * 92 + wc * 92 + mc * 92 + fc * 68 + dtc * 36 + dqc * 48
end function

/*
* Function: RGL_WriteGeomFixed
* Purpose: Writes geom fixed data for the OpenGL renderer.
*/
function RGL_WriteGeomFixed(buf, off, v)
  RGL_WriteS32(buf, off, RGL_FloatToGeom(v))
  return off + 4
end function

/*
* Function: RGL_WriteGeomQuad
* Purpose: Writes geom quad data for the OpenGL renderer.
*/
function RGL_WriteGeomQuad(buf, off, q)
  RGL_WriteS32(buf, off, q.texnum)
  off = off + 4
  if q.transparent then
    RGL_WriteS32(buf, off, 1)
  else
    RGL_WriteS32(buf, off, 0)
  end if
  off = off + 4
  RGL_WriteS32(buf, off, q.light)
  off = off + 4
  off = RGL_WriteGeomFixed(buf, off, q.x0)
  off = RGL_WriteGeomFixed(buf, off, q.y0)
  off = RGL_WriteGeomFixed(buf, off, q.z0)
  off = RGL_WriteGeomFixed(buf, off, q.s0)
  off = RGL_WriteGeomFixed(buf, off, q.t0)
  off = RGL_WriteGeomFixed(buf, off, q.x1)
  off = RGL_WriteGeomFixed(buf, off, q.y1)
  off = RGL_WriteGeomFixed(buf, off, q.z1)
  off = RGL_WriteGeomFixed(buf, off, q.s1)
  off = RGL_WriteGeomFixed(buf, off, q.t1)
  off = RGL_WriteGeomFixed(buf, off, q.x2)
  off = RGL_WriteGeomFixed(buf, off, q.y2)
  off = RGL_WriteGeomFixed(buf, off, q.z2)
  off = RGL_WriteGeomFixed(buf, off, q.s2)
  off = RGL_WriteGeomFixed(buf, off, q.t2)
  off = RGL_WriteGeomFixed(buf, off, q.x3)
  off = RGL_WriteGeomFixed(buf, off, q.y3)
  off = RGL_WriteGeomFixed(buf, off, q.z3)
  off = RGL_WriteGeomFixed(buf, off, q.s3)
  off = RGL_WriteGeomFixed(buf, off, q.t3)
  return off
end function

/*
* Function: RGL_ReadGeomQuad
* Purpose: Reads geom quad data for the OpenGL renderer.
*/
function RGL_ReadGeomQuad(buf, off)
  texnum = RGL_ReadS32(buf, off)
  off = off + 4
  transparent = RGL_ReadS32(buf, off) != 0
  off = off + 4
  light = RGL_ReadS32(buf, off)
  off = off + 4
  x0 = RGL_GeomToFloat(RGL_ReadS32(buf, off))
  off = off + 4
  y0 = RGL_GeomToFloat(RGL_ReadS32(buf, off))
  off = off + 4
  z0 = RGL_GeomToFloat(RGL_ReadS32(buf, off))
  off = off + 4
  s0 = RGL_GeomToFloat(RGL_ReadS32(buf, off))
  off = off + 4
  t0 = RGL_GeomToFloat(RGL_ReadS32(buf, off))
  off = off + 4
  x1 = RGL_GeomToFloat(RGL_ReadS32(buf, off))
  off = off + 4
  y1 = RGL_GeomToFloat(RGL_ReadS32(buf, off))
  off = off + 4
  z1 = RGL_GeomToFloat(RGL_ReadS32(buf, off))
  off = off + 4
  s1 = RGL_GeomToFloat(RGL_ReadS32(buf, off))
  off = off + 4
  t1 = RGL_GeomToFloat(RGL_ReadS32(buf, off))
  off = off + 4
  x2 = RGL_GeomToFloat(RGL_ReadS32(buf, off))
  off = off + 4
  y2 = RGL_GeomToFloat(RGL_ReadS32(buf, off))
  off = off + 4
  z2 = RGL_GeomToFloat(RGL_ReadS32(buf, off))
  off = off + 4
  s2 = RGL_GeomToFloat(RGL_ReadS32(buf, off))
  off = off + 4
  t2 = RGL_GeomToFloat(RGL_ReadS32(buf, off))
  off = off + 4
  x3 = RGL_GeomToFloat(RGL_ReadS32(buf, off))
  off = off + 4
  y3 = RGL_GeomToFloat(RGL_ReadS32(buf, off))
  off = off + 4
  z3 = RGL_GeomToFloat(RGL_ReadS32(buf, off))
  off = off + 4
  s3 = RGL_GeomToFloat(RGL_ReadS32(buf, off))
  off = off + 4
  t3 = RGL_GeomToFloat(RGL_ReadS32(buf, off))
  off = off + 4
  return [rgl_quad_t(texnum, transparent, light, x0, y0, z0, s0, t0, x1, y1, z1, s1, t1, x2, y2, z2, s2, t2, x3, y3, z3, s3, t3), off]
end function

/*
* Function: RGL_WriteGeomFlatTri
* Purpose: Writes geom flat triangle data for the OpenGL renderer.
*/
function RGL_WriteGeomFlatTri(buf, off, t)
  RGL_WriteS32(buf, off, t.flatnum)
  off = off + 4
  RGL_WriteS32(buf, off, t.light)
  off = off + 4
  off = RGL_WriteGeomFixed(buf, off, t.x0)
  off = RGL_WriteGeomFixed(buf, off, t.y0)
  off = RGL_WriteGeomFixed(buf, off, t.z0)
  off = RGL_WriteGeomFixed(buf, off, t.s0)
  off = RGL_WriteGeomFixed(buf, off, t.t0)
  off = RGL_WriteGeomFixed(buf, off, t.x1)
  off = RGL_WriteGeomFixed(buf, off, t.y1)
  off = RGL_WriteGeomFixed(buf, off, t.z1)
  off = RGL_WriteGeomFixed(buf, off, t.s1)
  off = RGL_WriteGeomFixed(buf, off, t.t1)
  off = RGL_WriteGeomFixed(buf, off, t.x2)
  off = RGL_WriteGeomFixed(buf, off, t.y2)
  off = RGL_WriteGeomFixed(buf, off, t.z2)
  off = RGL_WriteGeomFixed(buf, off, t.s2)
  off = RGL_WriteGeomFixed(buf, off, t.t2)
  return off
end function

/*
* Function: RGL_ReadGeomFlatTri
* Purpose: Reads geom flat triangle data for the OpenGL renderer.
*/
function RGL_ReadGeomFlatTri(buf, off)
  flatnum = RGL_ReadS32(buf, off)
  off = off + 4
  light = RGL_ReadS32(buf, off)
  off = off + 4
  x0 = RGL_GeomToFloat(RGL_ReadS32(buf, off))
  off = off + 4
  y0 = RGL_GeomToFloat(RGL_ReadS32(buf, off))
  off = off + 4
  z0 = RGL_GeomToFloat(RGL_ReadS32(buf, off))
  off = off + 4
  s0 = RGL_GeomToFloat(RGL_ReadS32(buf, off))
  off = off + 4
  t0 = RGL_GeomToFloat(RGL_ReadS32(buf, off))
  off = off + 4
  x1 = RGL_GeomToFloat(RGL_ReadS32(buf, off))
  off = off + 4
  y1 = RGL_GeomToFloat(RGL_ReadS32(buf, off))
  off = off + 4
  z1 = RGL_GeomToFloat(RGL_ReadS32(buf, off))
  off = off + 4
  s1 = RGL_GeomToFloat(RGL_ReadS32(buf, off))
  off = off + 4
  t1 = RGL_GeomToFloat(RGL_ReadS32(buf, off))
  off = off + 4
  x2 = RGL_GeomToFloat(RGL_ReadS32(buf, off))
  off = off + 4
  y2 = RGL_GeomToFloat(RGL_ReadS32(buf, off))
  off = off + 4
  z2 = RGL_GeomToFloat(RGL_ReadS32(buf, off))
  off = off + 4
  s2 = RGL_GeomToFloat(RGL_ReadS32(buf, off))
  off = off + 4
  t2 = RGL_GeomToFloat(RGL_ReadS32(buf, off))
  off = off + 4
  return [rgl_flat_tri_t(flatnum, light, x0, y0, z0, s0, t0, x1, y1, z1, s1, t1, x2, y2, z2, s2, t2), off]
end function

/*
* Function: RGL_WriteGeomDepthTri
* Purpose: Writes geom depth triangle data for the OpenGL renderer.
*/
function RGL_WriteGeomDepthTri(buf, off, t)
  off = RGL_WriteGeomFixed(buf, off, t.x0)
  off = RGL_WriteGeomFixed(buf, off, t.y0)
  off = RGL_WriteGeomFixed(buf, off, t.z0)
  off = RGL_WriteGeomFixed(buf, off, t.x1)
  off = RGL_WriteGeomFixed(buf, off, t.y1)
  off = RGL_WriteGeomFixed(buf, off, t.z1)
  off = RGL_WriteGeomFixed(buf, off, t.x2)
  off = RGL_WriteGeomFixed(buf, off, t.y2)
  off = RGL_WriteGeomFixed(buf, off, t.z2)
  return off
end function

/*
* Function: RGL_ReadGeomDepthTri
* Purpose: Reads geom depth triangle data for the OpenGL renderer.
*/
function RGL_ReadGeomDepthTri(buf, off)
  x0 = RGL_GeomToFloat(RGL_ReadS32(buf, off))
  off = off + 4
  y0 = RGL_GeomToFloat(RGL_ReadS32(buf, off))
  off = off + 4
  z0 = RGL_GeomToFloat(RGL_ReadS32(buf, off))
  off = off + 4
  x1 = RGL_GeomToFloat(RGL_ReadS32(buf, off))
  off = off + 4
  y1 = RGL_GeomToFloat(RGL_ReadS32(buf, off))
  off = off + 4
  z1 = RGL_GeomToFloat(RGL_ReadS32(buf, off))
  off = off + 4
  x2 = RGL_GeomToFloat(RGL_ReadS32(buf, off))
  off = off + 4
  y2 = RGL_GeomToFloat(RGL_ReadS32(buf, off))
  off = off + 4
  z2 = RGL_GeomToFloat(RGL_ReadS32(buf, off))
  off = off + 4
  return [rgl_depth_tri_t(x0, y0, z0, x1, y1, z1, x2, y2, z2), off]
end function

/*
* Function: RGL_WriteGeomDepthQuad
* Purpose: Writes geom depth quad data for the OpenGL renderer.
*/
function RGL_WriteGeomDepthQuad(buf, off, q)
  off = RGL_WriteGeomFixed(buf, off, q.x0)
  off = RGL_WriteGeomFixed(buf, off, q.y0)
  off = RGL_WriteGeomFixed(buf, off, q.z0)
  off = RGL_WriteGeomFixed(buf, off, q.x1)
  off = RGL_WriteGeomFixed(buf, off, q.y1)
  off = RGL_WriteGeomFixed(buf, off, q.z1)
  off = RGL_WriteGeomFixed(buf, off, q.x2)
  off = RGL_WriteGeomFixed(buf, off, q.y2)
  off = RGL_WriteGeomFixed(buf, off, q.z2)
  off = RGL_WriteGeomFixed(buf, off, q.x3)
  off = RGL_WriteGeomFixed(buf, off, q.y3)
  off = RGL_WriteGeomFixed(buf, off, q.z3)
  return off
end function

/*
* Function: RGL_ReadGeomDepthQuad
* Purpose: Reads geom depth quad data for the OpenGL renderer.
*/
function RGL_ReadGeomDepthQuad(buf, off)
  x0 = RGL_GeomToFloat(RGL_ReadS32(buf, off))
  off = off + 4
  y0 = RGL_GeomToFloat(RGL_ReadS32(buf, off))
  off = off + 4
  z0 = RGL_GeomToFloat(RGL_ReadS32(buf, off))
  off = off + 4
  x1 = RGL_GeomToFloat(RGL_ReadS32(buf, off))
  off = off + 4
  y1 = RGL_GeomToFloat(RGL_ReadS32(buf, off))
  off = off + 4
  z1 = RGL_GeomToFloat(RGL_ReadS32(buf, off))
  off = off + 4
  x2 = RGL_GeomToFloat(RGL_ReadS32(buf, off))
  off = off + 4
  y2 = RGL_GeomToFloat(RGL_ReadS32(buf, off))
  off = off + 4
  z2 = RGL_GeomToFloat(RGL_ReadS32(buf, off))
  off = off + 4
  x3 = RGL_GeomToFloat(RGL_ReadS32(buf, off))
  off = off + 4
  y3 = RGL_GeomToFloat(RGL_ReadS32(buf, off))
  off = off + 4
  z3 = RGL_GeomToFloat(RGL_ReadS32(buf, off))
  off = off + 4
  return [rgl_depth_quad_t(x0, y0, z0, x1, y1, z1, x2, y2, z2, x3, y3, z3), off]
end function

/*
* Function: RGL_SerializeGeometryCache
* Purpose: Manages cached serialize Geometry Cache data for the OpenGL renderer system.
*/
function RGL_SerializeGeometryCache(sigMap, sigSegs, sigLines, sigNodes, sigSubsectors, sigSectorMotion, sigSides)
  bc = RGL_SeqLen(rgl_boundary_quads)
  wc = RGL_SeqLen(rgl_wall_quads)
  mc = RGL_SeqLen(rgl_masked_quads)
  fc = RGL_SeqLen(rgl_flat_tris)
  dtc = RGL_SeqLen(rgl_depth_tris)
  dqc = RGL_SeqLen(rgl_depth_quads)
  if bc < 0 then bc = 0 end if
  if wc < 0 then wc = 0 end if
  if mc < 0 then mc = 0 end if
  if fc < 0 then fc = 0 end if
  if dtc < 0 then dtc = 0 end if
  if dqc < 0 then dqc = 0 end if

  buf = bytes(RGL_GeometryCacheByteSize(), 0)
  buf[0] = 77
  buf[1] = 71
  buf[2] = 76
  buf[3] = 49
  RGL_WriteS32(buf, 4, RGL_GEOM_VERSION)
  RGL_WriteS32(buf, 8, sigMap)
  RGL_WriteS32(buf, 12, sigSegs)
  RGL_WriteS32(buf, 16, sigLines)
  RGL_WriteS32(buf, 20, sigNodes)
  RGL_WriteS32(buf, 24, sigSubsectors)
  RGL_WriteS32(buf, 28, sigSectorMotion)
  RGL_WriteS32(buf, 32, sigSides)
  RGL_WriteS32(buf, 36, bc)
  RGL_WriteS32(buf, 40, wc)
  RGL_WriteS32(buf, 44, mc)
  RGL_WriteS32(buf, 48, fc)
  RGL_WriteS32(buf, 52, dtc)
  RGL_WriteS32(buf, 56, dqc)

  off = 60
  i = 0
  while i < bc
    off = RGL_WriteGeomQuad(buf, off, rgl_boundary_quads[i])
    i = i + 1
  end while
  i = 0
  while i < wc
    off = RGL_WriteGeomQuad(buf, off, rgl_wall_quads[i])
    i = i + 1
  end while
  i = 0
  while i < mc
    off = RGL_WriteGeomQuad(buf, off, rgl_masked_quads[i])
    i = i + 1
  end while
  i = 0
  while i < fc
    off = RGL_WriteGeomFlatTri(buf, off, rgl_flat_tris[i])
    i = i + 1
  end while
  i = 0
  while i < dtc
    off = RGL_WriteGeomDepthTri(buf, off, rgl_depth_tris[i])
    i = i + 1
  end while
  i = 0
  while i < dqc
    off = RGL_WriteGeomDepthQuad(buf, off, rgl_depth_quads[i])
    i = i + 1
  end while

  return buf
end function

/*
* Function: RGL_TryLoadGeometryCache
* Purpose: Loads try Load Geometry Cache resources used by the OpenGL renderer system.
*/
function RGL_TryLoadGeometryCache(sigMap, sigSegs, sigLines, sigNodes, sigSubsectors, sigSectorMotion, sigSides)
  global rgl_geom_ready
  global rgl_geom_sig_map
  global rgl_geom_sig_segs
  global rgl_geom_sig_lines
  global rgl_geom_sig_nodes
  global rgl_geom_sig_subsectors
  global rgl_geom_sig_sector_motion
  global rgl_geom_sig_sides
  global rgl_pending_sig_sector_motion
  global rgl_pending_sig_sides
  global rgl_pending_stable_frames
  global rgl_boundary_quads
  global rgl_wall_quads
  global rgl_masked_quads
  global rgl_flat_tris
  global rgl_depth_tris
  global rgl_depth_quads

  lump = W_CheckNumForName(RGL_MapGeomLumpName())
  if lump < 0 then return false end if
  data = W_CacheLumpNum(lump, 0)
  if typeof(data) != "bytes" or len(data) < 60 then return false end if
  if data[0] != 77 or data[1] != 71 or data[2] != 76 or data[3] != 49 then return false end if
  if RGL_ReadS32(data, 4) != RGL_GEOM_VERSION then return false end if
  if RGL_ReadS32(data, 8) != sigMap then return false end if
  if RGL_ReadS32(data, 12) != sigSegs then return false end if
  if RGL_ReadS32(data, 16) != sigLines then return false end if
  if RGL_ReadS32(data, 20) != sigNodes then return false end if
  if RGL_ReadS32(data, 24) != sigSubsectors then return false end if
  if RGL_ReadS32(data, 28) != sigSectorMotion then return false end if
  if RGL_ReadS32(data, 32) != sigSides then return false end if

  bc = RGL_ReadS32(data, 36)
  wc = RGL_ReadS32(data, 40)
  mc = RGL_ReadS32(data, 44)
  fc = RGL_ReadS32(data, 48)
  dtc = RGL_ReadS32(data, 52)
  dqc = RGL_ReadS32(data, 56)
  if bc < 0 or wc < 0 or mc < 0 or fc < 0 or dtc < 0 or dqc < 0 then return false end if
  need = 60 + bc * 92 + wc * 92 + mc * 92 + fc * 68 + dtc * 36 + dqc * 48
  if need > len(data) then return false end if

  newBoundary =[]
  newWalls =[]
  newMasked =[]
  newFlats =[]
  newDepthTris =[]
  newDepthQuads =[]
  off = 60
  i = 0
  while i < bc
    r = RGL_ReadGeomQuad(data, off)
    newBoundary = newBoundary +[r[0]]
    off = r[1]
    i = i + 1
  end while
  i = 0
  while i < wc
    r = RGL_ReadGeomQuad(data, off)
    newWalls = newWalls +[r[0]]
    off = r[1]
    i = i + 1
  end while
  i = 0
  while i < mc
    r = RGL_ReadGeomQuad(data, off)
    newMasked = newMasked +[r[0]]
    off = r[1]
    i = i + 1
  end while
  i = 0
  while i < fc
    r = RGL_ReadGeomFlatTri(data, off)
    newFlats = newFlats +[r[0]]
    off = r[1]
    i = i + 1
  end while
  i = 0
  while i < dtc
    r = RGL_ReadGeomDepthTri(data, off)
    newDepthTris = newDepthTris +[r[0]]
    off = r[1]
    i = i + 1
  end while
  i = 0
  while i < dqc
    r = RGL_ReadGeomDepthQuad(data, off)
    newDepthQuads = newDepthQuads +[r[0]]
    off = r[1]
    i = i + 1
  end while

  rgl_boundary_quads = newBoundary
  rgl_wall_quads = newWalls
  rgl_masked_quads = newMasked
  rgl_flat_tris = newFlats
  rgl_depth_tris = newDepthTris
  rgl_depth_quads = newDepthQuads
  rgl_geom_sig_map = sigMap
  rgl_geom_sig_segs = sigSegs
  rgl_geom_sig_lines = sigLines
  rgl_geom_sig_nodes = sigNodes
  rgl_geom_sig_subsectors = sigSubsectors
  rgl_geom_sig_sector_motion = sigSectorMotion
  rgl_geom_sig_sides = sigSides
  rgl_pending_sig_sector_motion = sigSectorMotion
  rgl_pending_sig_sides = sigSides
  rgl_pending_stable_frames = 0
  rgl_geom_ready = true
  print "RGL: loaded cached map geometry " + RGL_MapGeomLumpName()
  return true
end function

/*
* Function: RGL_BuildCurrentMapGeometryLump
* Purpose: Builds current map geometry lump data for the OpenGL renderer.
*/
function RGL_BuildCurrentMapGeometryLump()
  sigMap = -1
  if typeof(gamemap) == "int" then sigMap = gamemap end if
  sigSegs = RGL_SeqLen(segs)
  sigLines = RGL_SeqLen(lines)
  sigNodes = RGL_SeqLen(nodes)
  sigSubsectors = RGL_SeqLen(subsectors)
  sigSectorMotion = RGL_SectorMotionSignature()
  sigSides = RGL_SideTextureSignature()
  RGL_BuildGeometryCache(sigMap, sigSegs, sigLines, sigNodes, sigSubsectors, sigSectorMotion, sigSides)
  blob = RGL_SerializeGeometryCache(sigMap, sigSegs, sigLines, sigNodes, sigSubsectors, sigSectorMotion, sigSides)
  return [RGL_MapGeomLumpName(), blob]
end function

/*
* Function: RGL_FixedToFloat
* Purpose: Converts fixed to float values for the OpenGL renderer.
*/
function inline RGL_FixedToFloat(v)
  return v / FRACUNIT
end function

/*
* Function: RGL_AngleToDegrees
* Purpose: Converts angle to degrees values for the OpenGL renderer.
*/
function inline RGL_AngleToDegrees(a)
  u = a
  if u < 0 then u = u + 4294967296 end if
  return(u / RGL_ANGLE_FULL) * 360.0
end function

/*
* Function: RGL_NormalizeDegrees
* Purpose: Updates degrees state for the OpenGL renderer.
*/
function RGL_NormalizeDegrees(d)
  while d < 0.0
    d = d + 360.0
  end while
  while d >= 360.0
    d = d - 360.0
  end while
  return d
end function

/*
* Function: RGL_EnumIndex
* Purpose: Provides index helper behavior for the OpenGL renderer.
*/
function inline RGL_EnumIndex(v, limit)
  i = 0
  while i < limit
    if v == i then return i end if
    i = i + 1
  end while
  return -1
end function

/*
* Function: RGL_SpriteIndex
* Purpose: Provides index helper behavior for the OpenGL renderer.
*/
function inline RGL_SpriteIndex(v)
  max = 0
  if RGL_IsSeq(sprites) then
    max = len(sprites)
  else if typeof(numsprites) == "int" then
    max = numsprites
  end if
  return RGL_EnumIndex(v, max)
end function

/*
* Function: RGL_LightByte
* Purpose: Provides byte helper behavior for the OpenGL renderer.
*/
function inline RGL_LightByte(sec)
  if sec is void or typeof(sec.lightlevel) != "int" then return 128 end if
  v = sec.lightlevel
  v = 8.0 +(v * 0.68)
  if v < 12 then v = 12 end if
  if v > 198 then v = 198 end if
  return std.math.floor(v)
end function

/*
* Function: RGL_HasActiveSectorMotion
* Purpose: Checks whether a sector thinker is currently moving world geometry.
*/
function RGL_HasActiveSectorMotion()
  if not RGL_IsSeq(sectors) then return false end if
  i = 0
  while i < len(sectors)
    sec = sectors[i]
    if sec is not void and sec.specialdata is not void then return true end if
    i = i + 1
  end while
  return false
end function

/*
* Function: RGL_SectorNearFixedPoint
* Purpose: Checks whether a sector is near a fixed-point map coordinate.
*/
function RGL_SectorNearFixedPoint(sec, x, y, radius)
  if sec is void or sec.specialdata is void then return false end if
  if not RGL_IsSeq(sec.lines) or typeof(sec.linecount) != "int" then return true end if
  r2 = radius * radius
  i = 0
  while i < sec.linecount and i < len(sec.lines)
    li = sec.lines[i]
    if li is not void then
      if li.v1 is not void then
        dx = li.v1.x - x
        dy = li.v1.y - y
        if dx * dx + dy * dy <= r2 then return true end if
      end if
      if li.v2 is not void then
        dx = li.v2.x - x
        dy = li.v2.y - y
        if dx * dx + dy * dy <= r2 then return true end if
      end if
    end if
    i = i + 1
  end while
  return false
end function

/*
* Function: RGL_PlayerNearActiveSectorMotion
* Purpose: Uses the accurate direct renderer when the player is near moving sectors.
*/
function RGL_PlayerNearActiveSectorMotion(player)
  if player is void or player.mo is void or not RGL_IsSeq(sectors) then return false end if
  playerSector = void
  if player.mo.subsector is not void then playerSector = player.mo.subsector.sector end if
  if playerSector is not void and playerSector.specialdata is not void then return true end if
  radius = 768 * FRACUNIT
  i = 0
  while i < len(sectors)
    if RGL_SectorNearFixedPoint(sectors[i], player.mo.x, player.mo.y, radius) then return true end if
    i = i + 1
  end while
  return false
end function

/*
* Function: RGL_ClampByte
* Purpose: Clamps clamp Byte values to the supported OpenGL renderer range.
*/
function inline RGL_ClampByte(v)
  if v < 0 then return 0 end if
  if v > 255 then return 255 end if
  if v >= 0 then return std.math.floor(v) end if
  return std.math.ceil(v)
end function

/*
* Function: RGL_AddDynamicLight
* Purpose: Adds dynamic light entries to the OpenGL renderer.
*/
function RGL_AddDynamicLight(x, y, z, r, g, b, radius, strength)
  global rgl_dyn_light_x
  global rgl_dyn_light_y
  global rgl_dyn_light_z
  global rgl_dyn_light_r
  global rgl_dyn_light_g
  global rgl_dyn_light_b
  global rgl_dyn_light_radius
  global rgl_dyn_light_strength

  if len(rgl_dyn_light_x) >= RGL_MAX_DYNAMIC_LIGHTS then return end if
  if typeof(radius) != "float" and typeof(radius) != "int" then return end if
  if typeof(strength) != "float" and typeof(strength) != "int" then return end if
  if radius <= 0 or strength <= 0 then return end if
  dxView = x - rgl_view_x
  dzView = z + rgl_view_y
  maxDist = 2800.0 + radius
  if dxView * dxView + dzView * dzView > maxDist * maxDist then return end if
  rgl_dyn_light_x = rgl_dyn_light_x +[x]
  rgl_dyn_light_y = rgl_dyn_light_y +[y]
  rgl_dyn_light_z = rgl_dyn_light_z +[z]
  rgl_dyn_light_r = rgl_dyn_light_r +[r]
  rgl_dyn_light_g = rgl_dyn_light_g +[g]
  rgl_dyn_light_b = rgl_dyn_light_b +[b]
  rgl_dyn_light_radius = rgl_dyn_light_radius +[radius]
  rgl_dyn_light_strength = rgl_dyn_light_strength +[strength]
end function

/*
* Function: RGL_StringStartsWith
* Purpose: Tests a short ASCII prefix without relying on optional string helpers.
*/
function RGL_StringStartsWith(s, prefix)
  if typeof(s) != "string" or typeof(prefix) != "string" then return false end if
  if len(prefix) > len(s) then return false end if
  sb = bytes(s)
  pb = bytes(prefix)
  i = 0
  while i < len(pb)
    if sb[i] != pb[i] then return false end if
    i = i + 1
  end while
  return true
end function

/*
* Function: RGL_FlatNameForNum
* Purpose: Resolves the currently translated flat name for liquid light classification.
*/
function RGL_FlatNameForNum(flatnum)
  if typeof(flatnum) != "int" or flatnum < 0 then return "" end if
  n = flatnum
  if RGL_IsSeq(flattranslation) and n >= 0 and n < len(flattranslation) then n = flattranslation[n] end if
  lump = firstflat + n
  return RGL_LumpNameAt(lump)
end function

/*
* Function: RGL_LiquidLightKind
* Purpose: Classifies animated liquid flats that should emit subtle GL ambience.
*/
function RGL_LiquidLightKind(flatnum)
  name = RGL_FlatNameForNum(flatnum)
  if name == "" then return 0 end if
  if RGL_StringStartsWith(name, "LAVA") or RGL_StringStartsWith(name, "FIRELAV") then return 1 end if
  if RGL_StringStartsWith(name, "NUKAGE") or RGL_StringStartsWith(name, "SLIME") then return 2 end if
  if RGL_StringStartsWith(name, "BLOOD") then return 3 end if
  if RGL_StringStartsWith(name, "FWATER") then return 4 end if
  return 0
end function

/*
* Function: RGL_AddSectorLiquidLight
* Purpose: Adds one restrained colored light above a nearby liquid sector.
*/
function RGL_AddSectorLiquidLight(sec, kind, player, pulse)
  if sec is void or player is void or player.mo is void then return false end if
  if not RGL_IsSeq(sec.lines) or typeof(sec.linecount) != "int" or sec.linecount <= 0 then return false end if

  sx = 0.0
  sy = 0.0
  points = 0
  i = 0
  while i < sec.linecount and i < len(sec.lines)
    li = sec.lines[i]
    if li is not void then
      if li.v1 is not void then
        sx = sx + RGL_FixedToFloat(li.v1.x)
        sy = sy + RGL_FixedToFloat(li.v1.y)
        points = points + 1
      end if
      if li.v2 is not void then
        sx = sx + RGL_FixedToFloat(li.v2.x)
        sy = sy + RGL_FixedToFloat(li.v2.y)
        points = points + 1
      end if
    end if
    i = i + 1
  end while
  if points <= 0 then return false end if

  sx = sx / points
  sy = sy / points
  px = RGL_FixedToFloat(player.mo.x)
  py = RGL_FixedToFloat(player.mo.y)
  dx = sx - px
  dy = sy - py
  near = 1800.0
  if dx * dx + dy * dy > near * near then return false end if

  z = RGL_FixedToFloat(sec.floorheight) + 10.0
  rr = 180
  gg = 90
  bb = 24
  radius = 460.0
  strength = 24.0 + pulse * 8.0
  if kind == 2 then
    rr = 80
    gg = 190
    bb = 82
    radius = 410.0
    strength = 18.0 + pulse * 6.0
  else if kind == 3 then
    rr = 180
    gg = 24
    bb = 20
    radius = 360.0
    strength = 14.0 + pulse * 5.0
  else if kind == 4 then
    rr = 56
    gg = 105
    bb = 150
    radius = 300.0
    strength = 10.0 + pulse * 4.0
  end if

  RGL_AddDynamicLight(sx, z, -sy, rr, gg, bb, radius, strength)
  return true
end function

/*
* Function: RGL_AddLiquidSectorLights
* Purpose: Adds a small budget of ambient lights for nearby liquid sectors.
*/
function RGL_AddLiquidSectorLights(player)
  if player is void or player.mo is void or not RGL_IsSeq(sectors) then return end if
  pulse = 0.5
  if typeof(gametic) == "int" then pulse = 0.5 + std.math.sin(gametic * 0.18) * 0.5 end if
  added = 0
  i = 0
  while i < len(sectors) and added < 6
    sec = sectors[i]
    kind = 0
    if sec is not void then kind = RGL_LiquidLightKind(sec.floorpic) end if
    if kind != 0 then
      if RGL_AddSectorLiquidLight(sec, kind, player, pulse) then added = added + 1 end if
    end if
    i = i + 1
  end while
end function

/*
* Function: RGL_MobjLight
* Purpose: Provides light helper behavior for the OpenGL renderer.
*/
function RGL_MobjLight(mo)
  if mo is void or typeof(mo.type) != "int" then return false end if
  x = RGL_FixedToFloat(mo.x)
  y = RGL_FixedToFloat(mo.z)
  if typeof(mo.height) == "int" then y = y + RGL_FixedToFloat(mo.height) * 0.45 end if
  z = -RGL_FixedToFloat(mo.y)
  t = mo.type

  if t == mobjtype_t.MT_ROCKET then
    RGL_AddDynamicLight(x, y, z, 255, 116, 34, 520.0, 118.0)
    return true
  end if
  if t == mobjtype_t.MT_PLASMA then
    RGL_AddDynamicLight(x, y, z, 72, 170, 255, 430.0, 104.0)
    return true
  end if
  if t == mobjtype_t.MT_ARACHPLAZ then
    RGL_AddDynamicLight(x, y, z, 255, 232, 78, 430.0, 104.0)
    return true
  end if
  if t == mobjtype_t.MT_BFG then
    RGL_AddDynamicLight(x, y, z, 86, 255, 106, 860.0, 180.0)
    return true
  end if
  if t == mobjtype_t.MT_HEADSHOT then
    RGL_AddDynamicLight(x, y, z, 205, 82, 255, 430.0, 98.0)
    return true
  end if
  if t == mobjtype_t.MT_BRUISERSHOT then
    RGL_AddDynamicLight(x, y, z, 92, 235, 86, 430.0, 98.0)
    return true
  end if
  if t == mobjtype_t.MT_TROOPSHOT or t == mobjtype_t.MT_FATSHOT then
    RGL_AddDynamicLight(x, y, z, 255, 128, 40, 390.0, 88.0)
    return true
  end if
  if t == mobjtype_t.MT_TRACER then
    RGL_AddDynamicLight(x, y, z, 170, 220, 255, 420.0, 90.0)
    return true
  end if

  if typeof(mo.flags) == "int" and (mo.flags & mobjflag_t.MF_JUSTATTACKED) != 0 then
    if t == mobjtype_t.MT_SPIDER or t == mobjtype_t.MT_POSSESSED or t == mobjtype_t.MT_SHOTGUY or t == mobjtype_t.MT_CHAINGUY or t == mobjtype_t.MT_WOLFSS then
      RGL_AddDynamicLight(x, y, z, 255, 205, 110, 360.0, 78.0)
    else if t == mobjtype_t.MT_BABY then
      RGL_AddDynamicLight(x, y, z, 255, 232, 78, 390.0, 82.0)
    else if t == mobjtype_t.MT_HEAD then
      RGL_AddDynamicLight(x, y, z, 205, 82, 255, 390.0, 78.0)
    else if t == mobjtype_t.MT_BRUISER or t == mobjtype_t.MT_KNIGHT then
      RGL_AddDynamicLight(x, y, z, 92, 235, 86, 390.0, 78.0)
    else if t == mobjtype_t.MT_CYBORG then
      RGL_AddDynamicLight(x, y, z, 255, 116, 34, 460.0, 96.0)
    else
      RGL_AddDynamicLight(x, y, z, 255, 155, 76, 340.0, 66.0)
    end if
    return true
  end if
  return false
end function

/*
* Function: RGL_BuildDynamicLights
* Purpose: Builds dynamic lights data for the OpenGL renderer.
*/
function RGL_BuildDynamicLights(player)
  global rgl_dyn_light_x
  global rgl_dyn_light_y
  global rgl_dyn_light_z
  global rgl_dyn_light_r
  global rgl_dyn_light_g
  global rgl_dyn_light_b
  global rgl_dyn_light_radius
  global rgl_dyn_light_strength

  rgl_dyn_light_x =[]
  rgl_dyn_light_y =[]
  rgl_dyn_light_z =[]
  rgl_dyn_light_r =[]
  rgl_dyn_light_g =[]
  rgl_dyn_light_b =[]
  rgl_dyn_light_radius =[]
  rgl_dyn_light_strength =[]

  if player is not void and player.mo is not void then
    px = RGL_FixedToFloat(player.mo.x)
    py = -RGL_FixedToFloat(player.mo.y)
    pz = RGL_FixedToFloat(player.viewz)
    if typeof(player.extralight) == "int" and player.extralight > 0 then
      yaw = RGL_AngleToDegrees(player.mo.angle)
      rad = (yaw / 360.0) * 6.283185314
      lx = px + std.math.cos(rad) * 72.0
      lz = py + std.math.sin(rad) * 72.0
      lr = 255
      lg = 188
      lb = 104
      if player.readyweapon == wp_plasma then
        lr = 80
        lg = 150
        lb = 255
      else if player.readyweapon == wp_bfg then
        lr = 90
        lg = 255
        lb = 90
      end if
      RGL_AddDynamicLight(lx, pz, lz, lr, lg, lb, 520.0, 48.0 + player.extralight * 46.0)
    end if
  end if

  RGL_AddLiquidSectorLights(player)

  if not RGL_IsSeq(sectors) then return end if
  si = 0
  while si < len(sectors)
    mo = sectors[si].thinglist
    guard = 0
    while mo is not void and guard < 4096
      RGL_MobjLight(mo)
      mo = mo.snext
      guard = guard + 1
    end while
    si = si + 1
  end while
end function

/*
* Function: RGL_SetVertexLight
* Purpose: Updates vertex light state for the OpenGL renderer.
*/
function RGL_SetVertexLight(base, x, y, z)
  r = base
  g = base
  b = base

  dx = x - rgl_view_x
  dz = z + rgl_view_y
  d2 = dx * dx + dz * dz

  nearR = 640.0
  near2 = nearR * nearR
  if d2 < near2 then
    boost = (1.0 -(d2 / near2)) * 54.0
    r = r + boost
    g = g + boost
    b = b + boost
  end if

  fadeStart = 280.0 * 280.0
  fadeEnd = 1650.0 * 1650.0
  if d2 > fadeStart then
    fade = ((d2 - fadeStart) / (fadeEnd - fadeStart)) * 190.0
    if fade > 190.0 then fade = 190.0 end if
    r = r - fade
    g = g - fade
    b = b - fade
  end if

  i = 0
  while i < len(rgl_dyn_light_x)
    ldx = x - rgl_dyn_light_x[i]
    ldy = y - rgl_dyn_light_y[i]
    ldz = z - rgl_dyn_light_z[i]
    ld2 = ldx * ldx + ldy * ldy + ldz * ldz
    rad = rgl_dyn_light_radius[i]
    rad2 = rad * rad
    if ld2 < rad2 then
      amt = (1.0 -(ld2 / rad2)) * rgl_dyn_light_strength[i]
      r = r + amt * (rgl_dyn_light_r[i] / 255.0)
      g = g + amt * (rgl_dyn_light_g[i] / 255.0)
      b = b + amt * (rgl_dyn_light_b[i] / 255.0)
    end if
    i = i + 1
  end while

  glColor4ub(RGL_ClampByte(r), RGL_ClampByte(g), RGL_ClampByte(b), 255)
end function

/*
* Function: RGL_VertexLit
* Purpose: Provides lit helper behavior for the OpenGL renderer.
*/
function RGL_VertexLit(base, x, y, z)
  RGL_SetVertexLight(base, x, y, z)
  glVertex3d(x, y, z)
end function

/*
* Function: RGL_Vertex
* Purpose: Provides vertex helper behavior for the OpenGL renderer.
*/
function inline RGL_Vertex(v, z)
  if v is void then return end if
  x = RGL_FixedToFloat(v.x)
  y = RGL_FixedToFloat(z)
  zz = -RGL_FixedToFloat(v.y)
  RGL_VertexLit(rgl_current_light, x, y, zz)
end function

/*
* Function: RGL_LumpNameAt
* Purpose: Provides name at helper behavior for the OpenGL renderer.
*/
function RGL_LumpNameAt(lumpnum)
  if not RGL_IsSeq(lumpinfo) then return "" end if
  if lumpnum < 0 or lumpnum >= len(lumpinfo) then return "" end if
  li = lumpinfo[lumpnum]
  if li is void or typeof(li.name) != "bytes" then return "" end if
  return decodeZ(li.name)
end function

/*
* Function: RGL_CachedTexture
* Purpose: Manages cached cached Texture data for the OpenGL renderer system.
*/
function RGL_CachedTexture(key, entry, transparent, repeatWrap)
  global rgl_tex_keys
  global rgl_tex_ids

  if entry is void or typeof(entry.data) != "bytes" then return 0 end if
  if typeof(entry.width) != "int" or typeof(entry.height) != "int" then return 0 end if
  i = 0
  while i < len(rgl_tex_keys) and i < len(rgl_tex_ids)
    if rgl_tex_keys[i] == key then return rgl_tex_ids[i] end if
    i = i + 1
  end while
  texid = 0
  if typeof(IGL_CreateIndexedTextureEx) == "function" then
    texid = IGL_CreateIndexedTextureEx(entry.data, entry.width, entry.height, transparent, repeatWrap)
  else
    texid = IGL_CreateIndexedTexture(entry.data, entry.width, entry.height, transparent)
  end if
  if texid > 0 then
    rgl_tex_keys = rgl_tex_keys +[key]
    rgl_tex_ids = rgl_tex_ids +[texid]
  end if
  return texid
end function

/*
* Function: RGL_SyncPaletteRevision
* Purpose: Updates palette revision state for the OpenGL renderer.
*/
function RGL_SyncPaletteRevision()
  global rgl_tex_keys
  global rgl_tex_ids
  global rgl_texnum_tex_ids
  global rgl_texnum_trans_tex_ids
  global rgl_flat_tex_ids
  global rgl_sprite_tex_ids
  global rgl_palette_revision_seen
  global rgl_geom_ready

  rev = -1
  if typeof(igl_palette_revision) == "int" then rev = igl_palette_revision end if
  if rev == rgl_palette_revision_seen then return end if
  rgl_tex_keys =[]
  rgl_tex_ids =[]
  rgl_texnum_tex_ids =[]
  rgl_texnum_trans_tex_ids =[]
  rgl_flat_tex_ids =[]
  rgl_sprite_tex_ids =[]
  rgl_palette_revision_seen = rev
  rgl_geom_ready = false
end function

/*
* Function: RGL_TextureName
* Purpose: Provides name helper behavior for the OpenGL renderer.
*/
function RGL_TextureName(texnum)
  if not RGL_IsSeq(textures) then return "" end if
  if typeof(texnum) != "int" or texnum < 0 or texnum >= len(textures) then return "" end if
  t = textures[texnum]
  if t is void or typeof(t.name) != "string" then return "" end if
  return t.name
end function

/*
* Function: RGL_TextureWidth
* Purpose: Provides width helper behavior for the OpenGL renderer.
*/
function RGL_TextureWidth(texnum)
  if not RGL_IsSeq(textures) or texnum < 0 or texnum >= len(textures) then return 64 end if
  t = textures[texnum]
  if t is void or typeof(t.width) != "int" or t.width <= 0 then return 64 end if
  return t.width
end function

/*
* Function: RGL_TextureHeight
* Purpose: Provides height helper behavior for the OpenGL renderer.
*/
function RGL_TextureHeight(texnum)
  if not RGL_IsSeq(textures) or texnum < 0 or texnum >= len(textures) then return 64 end if
  t = textures[texnum]
  if t is void or typeof(t.height) != "int" or t.height <= 0 then return 64 end if
  return t.height
end function

/*
* Function: RGL_TextureIdForTexnum
* Purpose: Provides id for texture number helper behavior for the OpenGL renderer.
*/
function RGL_TextureIdForTexnum(texnum)
  global rgl_texnum_tex_ids
  if typeof(texnum) != "int" or texnum < 0 then return 0 end if
  while len(rgl_texnum_tex_ids) <= texnum
    rgl_texnum_tex_ids = rgl_texnum_tex_ids +[-1]
  end while
  cached = rgl_texnum_tex_ids[texnum]
  if typeof(cached) == "int" and cached >= 0 then return cached end if
  name = RGL_TextureName(texnum)
  if name == "" then
    rgl_texnum_tex_ids[texnum] = 0
    return 0
  end if
  entry = RU_GetTexture(name)
  texid = RGL_CachedTexture("T:" + name, entry, false, true)
  rgl_texnum_tex_ids[texnum] = texid
  return texid
end function

/*
* Function: RGL_TextureIdForTexnumTransparent
* Purpose: Provides id for texture number transparent helper behavior for the OpenGL renderer.
*/
function RGL_TextureIdForTexnumTransparent(texnum)
  global rgl_texnum_trans_tex_ids
  if typeof(texnum) != "int" or texnum < 0 then return 0 end if
  while len(rgl_texnum_trans_tex_ids) <= texnum
    rgl_texnum_trans_tex_ids = rgl_texnum_trans_tex_ids +[-1]
  end while
  cached = rgl_texnum_trans_tex_ids[texnum]
  if typeof(cached) == "int" and cached >= 0 then return cached end if
  name = RGL_TextureName(texnum)
  if name == "" then
    rgl_texnum_trans_tex_ids[texnum] = 0
    return 0
  end if
  entry = RU_GetTexture(name)
  texid = RGL_CachedTexture("TM:" + name, entry, true, true)
  rgl_texnum_trans_tex_ids[texnum] = texid
  return texid
end function

/*
* Function: RGL_TextureIdForFlatnum
* Purpose: Provides id for flatnum helper behavior for the OpenGL renderer.
*/
function RGL_TextureIdForFlatnum(flatnum)
  global rgl_flat_tex_ids
  if typeof(flatnum) != "int" or flatnum < 0 then return 0 end if
  while len(rgl_flat_tex_ids) <= flatnum
    rgl_flat_tex_ids = rgl_flat_tex_ids +[-1]
  end while
  cached = rgl_flat_tex_ids[flatnum]
  if typeof(cached) == "int" and cached >= 0 then return cached end if
  lump = firstflat + flatnum
  name = RGL_LumpNameAt(lump)
  if name == "" then
    rgl_flat_tex_ids[flatnum] = 0
    return 0
  end if
  entry = RU_GetFlat(name)
  texid = RGL_CachedTexture("F:" + name, entry, false, true)
  rgl_flat_tex_ids[flatnum] = texid
  return texid
end function

/*
* Function: RGL_TextureIdForSpriteLump
* Purpose: Provides id for sprite lump helper behavior for the OpenGL renderer.
*/
function RGL_TextureIdForSpriteLump(lump)
  global rgl_sprite_tex_ids
  if typeof(lump) != "int" or lump < 0 then return 0 end if
  while len(rgl_sprite_tex_ids) <= lump
    rgl_sprite_tex_ids = rgl_sprite_tex_ids +[-1]
  end while
  cached = rgl_sprite_tex_ids[lump]
  if typeof(cached) == "int" and cached >= 0 then return cached end if
  name = RGL_LumpNameAt(firstspritelump + lump)
  if name == "" then
    rgl_sprite_tex_ids[lump] = 0
    return 0
  end if
  entry = RU_GetSprite(name)
  if entry is void then entry = RU_GetPatch(name) end if
  texid = RGL_CachedTexture("S:" + name, entry, true, false)
  rgl_sprite_tex_ids[lump] = texid
  return texid
end function

/*
* Function: RGL_SpriteEntryForLump
* Purpose: Provides entry for lump helper behavior for the OpenGL renderer.
*/
function RGL_SpriteEntryForLump(lump)
  name = RGL_LumpNameAt(firstspritelump + lump)
  if name == "" then return void end if
  entry = RU_GetSprite(name)
  if entry is void then entry = RU_GetPatch(name) end if
  return entry
end function

/*
* Function: RGL_BindOrColor
* Purpose: Runs or color lifecycle logic for the OpenGL renderer.
*/
function RGL_BindOrColor(texid)
  if texid > 0 then
    glEnable(GL_TEXTURE_2D)
    glBindTexture(GL_TEXTURE_2D, texid)
    return true
  end if
  glDisable(GL_TEXTURE_2D)
  return false
end function

/*
* Function: RGL_EnableCutoutAlpha
* Purpose: Provides cutout alpha helper behavior for the OpenGL renderer.
*/
function RGL_EnableCutoutAlpha()
  glEnable(GL_ALPHA_TEST)
  glAlphaFunc(GL_GREATER, 0.5)
end function

/*
* Function: RGL_DisableCutoutAlpha
* Purpose: Provides cutout alpha helper behavior for the OpenGL renderer.
*/
function RGL_DisableCutoutAlpha()
  glDisable(GL_ALPHA_TEST)
end function

/*
* Function: RGL_SideRowOffset
* Purpose: Provides row offset helper behavior for the OpenGL renderer.
*/
function inline RGL_SideRowOffset(side)
  if side is not void and typeof(side.rowoffset) == "int" then return side.rowoffset end if
  return 0
end function

/*
* Function: RGL_TextureHeightFixed
* Purpose: Provides height fixed helper behavior for the OpenGL renderer.
*/
function RGL_TextureHeightFixed(texnum)
  if RGL_IsSeq(textureheight) and texnum >= 0 and texnum < len(textureheight) then return textureheight[texnum] end if
  return RGL_TextureHeight(texnum) * FRACUNIT
end function

/*
* Function: RGL_UpperTextureMid
* Purpose: Converts texture mid values for the OpenGL renderer.
*/
function RGL_UpperTextureMid(linedef, texnum, side, front, back)
  yoff = RGL_SideRowOffset(side)
  if linedef is not void and typeof(linedef.flags) == "int" and(linedef.flags & ML_DONTPEGTOP) != 0 then
    return front.ceilingheight + yoff
  end if
  if back is not void then return back.ceilingheight + RGL_TextureHeightFixed(texnum) + yoff end if
  return front.ceilingheight + yoff
end function

/*
* Function: RGL_LowerTextureMid
* Purpose: Converts texture mid values for the OpenGL renderer.
*/
function RGL_LowerTextureMid(linedef, texnum, side, front, back)
  yoff = RGL_SideRowOffset(side)
  if linedef is not void and typeof(linedef.flags) == "int" and(linedef.flags & ML_DONTPEGBOTTOM) != 0 then
    return front.ceilingheight + yoff
  end if
  if back is not void then return back.floorheight + yoff end if
  return front.floorheight + RGL_TextureHeightFixed(texnum) + yoff
end function

/*
* Function: RGL_MidTextureMid
* Purpose: Provides texture mid helper behavior for the OpenGL renderer.
*/
function RGL_MidTextureMid(linedef, texnum, side, front, back)
  yoff = RGL_SideRowOffset(side)
  if back is not void then
    if linedef is not void and typeof(linedef.flags) == "int" and(linedef.flags & ML_DONTPEGBOTTOM) != 0 then
      bottom = front.floorheight
      if back.floorheight > bottom then bottom = back.floorheight end if
      return bottom + RGL_TextureHeightFixed(texnum) + yoff
    end if
    top = front.ceilingheight
    if back.ceilingheight < top then top = back.ceilingheight end if
    return top + yoff
  end if

  if linedef is not void and typeof(linedef.flags) == "int" and(linedef.flags & ML_DONTPEGBOTTOM) != 0 then
    return front.floorheight + RGL_TextureHeightFixed(texnum) + yoff
  end if
  return front.ceilingheight + yoff
end function

/*
* Function: RGL_DefaultTextureMid
* Purpose: Provides texture mid helper behavior for the OpenGL renderer.
*/
function RGL_DefaultTextureMid(z1, side)
  return z1 + RGL_SideRowOffset(side)
end function

/*
* Function: RGL_AddCachedWallQuad
* Purpose: Manages cached add Cached Wall Quad data for the OpenGL renderer system.
*/
function RGL_AddCachedWallQuad(v1, v2, z0, z1, texnum, side, transparent, texturemid)
  global rgl_boundary_quads
  global rgl_wall_quads
  global rgl_masked_quads

  tw = RGL_TextureWidth(texnum)
  th = RGL_TextureHeight(texnum)
  x1 = RGL_FixedToFloat(v1.x)
  y1 = RGL_FixedToFloat(v1.y)
  x2 = RGL_FixedToFloat(v2.x)
  y2 = RGL_FixedToFloat(v2.y)
  dx = x2 - x1
  dy = y2 - y1
  dist = std.math.sqrt(dx * dx + dy * dy)
  xoff = 0.0
  if side is not void then
    if typeof(side.textureoffset) == "int" then xoff = RGL_FixedToFloat(side.textureoffset) end if
  end if
  s0 = xoff / tw
  s1 =(xoff + dist) / tw
  t0 =(RGL_FixedToFloat(texturemid) - RGL_FixedToFloat(z1)) / th
  t1 =(RGL_FixedToFloat(texturemid) - RGL_FixedToFloat(z0)) / th
  q = rgl_quad_t(texnum, transparent, rgl_current_light,
    x1, RGL_FixedToFloat(z0), -y1, s0, t1,
    x2, RGL_FixedToFloat(z0), -y2, s1, t1,
    x2, RGL_FixedToFloat(z1), -y2, s1, t0,
    x1, RGL_FixedToFloat(z1), -y1, s0, t0)
  if rgl_cache_target == RGL_CACHE_MASKED then
    rgl_masked_quads = rgl_masked_quads +[q]
  else if rgl_cache_target == RGL_CACHE_BOUNDARY then
    rgl_boundary_quads = rgl_boundary_quads +[q]
  else
    rgl_wall_quads = rgl_wall_quads +[q]
  end if
end function

/*
* Function: RGL_DrawCachedTexturedQuads
* Purpose: Draws cached textured quads output for the OpenGL renderer.
*/
function RGL_DrawCachedTexturedQuads(quads)
  if not RGL_IsSeq(quads) then return end if
  i = 0
  while i < len(quads)
    q = quads[i]
    if q is not void then
      texid = RGL_TextureIdForTexnum(q.texnum)
      if q.transparent then texid = RGL_TextureIdForTexnumTransparent(q.texnum) end if
      textured = RGL_BindOrColor(texid)
      if q.transparent then
        RGL_EnableCutoutAlpha()
      else
        RGL_DisableCutoutAlpha()
      end if
      glBegin(GL_QUADS)
      if textured then glTexCoord2d(q.s0, q.t0) end if
      RGL_VertexLit(q.light, q.x0, q.y0, q.z0)
      if textured then glTexCoord2d(q.s1, q.t1) end if
      RGL_VertexLit(q.light, q.x1, q.y1, q.z1)
      if textured then glTexCoord2d(q.s2, q.t2) end if
      RGL_VertexLit(q.light, q.x2, q.y2, q.z2)
      if textured then glTexCoord2d(q.s3, q.t3) end if
      RGL_VertexLit(q.light, q.x3, q.y3, q.z3)
      glEnd()
    end if
    i = i + 1
  end while
  RGL_DisableCutoutAlpha()
end function

/*
* Function: RGL_DrawWallQuadTexMid
* Purpose: Draws wall quad texture mid output for the OpenGL renderer.
*/
function RGL_DrawWallQuadTexMid(v1, v2, z0, z1, texnum, side, transparent, texturemid)
  if v1 is void or v2 is void then return end if
  if z1 <= z0 then return end if
  if typeof(texnum) != "int" or texnum == 0 then return end if
  if rgl_building_cache then
    RGL_AddCachedWallQuad(v1, v2, z0, z1, texnum, side, transparent, texturemid)
    return
  end if
  texid = RGL_TextureIdForTexnum(texnum)
  if transparent then texid = RGL_TextureIdForTexnumTransparent(texnum) end if
  textured = RGL_BindOrColor(texid)
  if transparent then RGL_EnableCutoutAlpha() else RGL_DisableCutoutAlpha() end if
  tw = RGL_TextureWidth(texnum)
  th = RGL_TextureHeight(texnum)
  x1 = RGL_FixedToFloat(v1.x)
  y1 = RGL_FixedToFloat(v1.y)
  x2 = RGL_FixedToFloat(v2.x)
  y2 = RGL_FixedToFloat(v2.y)
  dx = x2 - x1
  dy = y2 - y1
  dist = std.math.sqrt(dx * dx + dy * dy)
  xoff = 0.0
  if side is not void then
    if typeof(side.textureoffset) == "int" then xoff = RGL_FixedToFloat(side.textureoffset) end if
  end if
  s0 = xoff / tw
  s1 =(xoff + dist) / tw
  t0 =(RGL_FixedToFloat(texturemid) - RGL_FixedToFloat(z1)) / th
  t1 =(RGL_FixedToFloat(texturemid) - RGL_FixedToFloat(z0)) / th
  glBegin(GL_QUADS)
  if textured then glTexCoord2d(s0, t1) end if
  RGL_Vertex(v1, z0)
  if textured then glTexCoord2d(s1, t1) end if
  RGL_Vertex(v2, z0)
  if textured then glTexCoord2d(s1, t0) end if
  RGL_Vertex(v2, z1)
  if textured then glTexCoord2d(s0, t0) end if
  RGL_Vertex(v1, z1)
  glEnd()
end function

/*
* Function: RGL_DrawWallQuadEx
* Purpose: Draws wall quad ex output for the OpenGL renderer.
*/
function RGL_DrawWallQuadEx(v1, v2, z0, z1, texnum, side, transparent)
  RGL_DrawWallQuadTexMid(v1, v2, z0, z1, texnum, side, transparent, RGL_DefaultTextureMid(z1, side))
end function

/*
* Function: RGL_DrawWallQuad
* Purpose: Draws wall quad output for the OpenGL renderer.
*/
function RGL_DrawWallQuad(v1, v2, z0, z1, texnum, side)
  RGL_DrawWallQuadEx(v1, v2, z0, z1, texnum, side, false)
end function

/*
* Function: RGL_DrawMaskedMidtexture
* Purpose: Draws masked midtexture output for the OpenGL renderer.
*/
function RGL_DrawMaskedMidtexture(v1, v2, linedef, side, front, back)
  if v1 is void or v2 is void or side is void or front is void or back is void then return end if
  if typeof(side.midtexture) != "int" or side.midtexture == 0 then return end if

  texnum = side.midtexture
  texh = RGL_TextureHeightFixed(texnum)
  top = RGL_MidTextureMid(linedef, texnum, side, front, back)
  bottom = top - texh
  RGL_DrawWallQuadTexMid(v1, v2, bottom, top, texnum, side, true, top)
end function

/*
* Function: RGL_OppositeSide
* Purpose: Provides side helper behavior for the OpenGL renderer.
*/
function RGL_OppositeSide(linedef, side)
  if linedef is void or not RGL_IsSeq(linedef.sidenum) or not RGL_IsSeq(sides) then return void end if
  if len(linedef.sidenum) < 2 then return void end if
  s0 = linedef.sidenum[0]
  s1 = linedef.sidenum[1]
  if typeof(s0) != "int" or typeof(s1) != "int" then return void end if
  if s0 < 0 or s1 < 0 or s0 >= len(sides) or s1 >= len(sides) then return void end if
  if side == sides[s0] then return sides[s1] end if
  if side == sides[s1] then return sides[s0] end if
  return sides[s1]
end function

/*
* Function: RGL_SideOrFallback
* Purpose: Provides or fallback helper behavior for the OpenGL renderer.
*/
function inline RGL_SideOrFallback(side, fallback)
  if side is not void then return side end if
  return fallback
end function

/*
* Function: RGL_TopTextureOrZero
* Purpose: Provides texture or zero helper behavior for the OpenGL renderer.
*/
function inline RGL_TopTextureOrZero(side)
  if side is not void and typeof(side.toptexture) == "int" then return side.toptexture end if
  return 0
end function

/*
* Function: RGL_BottomTextureOrZero
* Purpose: Provides texture or zero helper behavior for the OpenGL renderer.
*/
function inline RGL_BottomTextureOrZero(side)
  if side is not void and typeof(side.bottomtexture) == "int" then return side.bottomtexture end if
  return 0
end function

/*
* Function: RGL_MidTextureOrZero
* Purpose: Provides texture or zero helper behavior for the OpenGL renderer.
*/
function inline RGL_MidTextureOrZero(side)
  if side is not void and typeof(side.midtexture) == "int" then return side.midtexture end if
  return 0
end function

/*
* Function: RGL_FallbackStepTexture
* Purpose: Provides step texture helper behavior for the OpenGL renderer.
*/
function RGL_FallbackStepTexture(tex, side, otherSide)
  if typeof(tex) == "int" and tex != 0 then return tex end if
  tex = RGL_BottomTextureOrZero(otherSide)
  if tex != 0 then return tex end if
  tex = RGL_TopTextureOrZero(otherSide)
  if tex != 0 then return tex end if
  tex = RGL_MidTextureOrZero(side)
  if tex != 0 then return tex end if
  return RGL_MidTextureOrZero(otherSide)
end function

/*
* Function: RGL_DrawWallPiece
* Purpose: Draws wall piece output for the OpenGL renderer.
*/
function RGL_DrawWallPiece(v1, v2, linedef, side, front, back)
  global rgl_current_light

  if v1 is void or v2 is void then return end if
  if front is void then return end if

  c = RGL_LightByte(front)
  rgl_current_light = c
  glColor3ub(c, c, c)

  if back is void then
    tex = 0
    if side is not void and typeof(side.midtexture) == "int" then tex = side.midtexture end if
    RGL_DrawWallQuadTexMid(v1, v2, front.floorheight, front.ceilingheight, tex, side, false, RGL_MidTextureMid(linedef, tex, side, front, void))
    return
  end if

  otherSide = RGL_OppositeSide(linedef, side)

  skyCeilingPortal = false
  if front.ceilingpic == skyflatnum and back.ceilingpic == skyflatnum then skyCeilingPortal = true end if

  if (not skyCeilingPortal) and back.ceilingheight < front.ceilingheight then
    tex = RGL_FallbackStepTexture(RGL_TopTextureOrZero(side), side, otherSide)
    RGL_DrawWallQuadTexMid(v1, v2, back.ceilingheight, front.ceilingheight, tex, side, false, RGL_UpperTextureMid(linedef, tex, side, front, back))
  end if
  if back.floorheight > front.floorheight then
    tex = RGL_FallbackStepTexture(RGL_BottomTextureOrZero(side), side, otherSide)
    RGL_DrawWallQuadTexMid(v1, v2, front.floorheight, back.floorheight, tex, side, false, RGL_LowerTextureMid(linedef, tex, side, front, back))
  end if
end function

/*
* Function: RGL_DrawLine
* Purpose: Draws line output for the OpenGL renderer.
*/
function RGL_DrawLine(li)
  if li is void then return end if
  if rgl_building_cache then
    if RGL_IsVolatileSector(li.frontsector) or RGL_IsVolatileSector(li.backsector) then return end if
  end if
  side = void
  if RGL_IsSeq(sides) and RGL_IsSeq(li.sidenum) and len(li.sidenum) > 0 then
    sid = li.sidenum[0]
    if typeof(sid) == "int" and sid >= 0 and sid < len(sides) then side = sides[sid] end if
  end if
  RGL_DrawWallPiece(li.v1, li.v2, li, side, li.frontsector, li.backsector)
end function

/*
* Function: RGL_DrawSeg
* Purpose: Draws seg output for the OpenGL renderer.
*/
function RGL_DrawSeg(sg)
  if sg is void then return end if
  if rgl_building_cache then
    if RGL_IsVolatileSector(sg.frontsector) or RGL_IsVolatileSector(sg.backsector) then return end if
  end if
  RGL_DrawWallPiece(sg.v1, sg.v2, sg.linedef, sg.sidedef, sg.frontsector, sg.backsector)
end function

/*
* Function: RGL_DrawAllWalls
* Purpose: Draws all walls output for the OpenGL renderer.
*/
function RGL_DrawAllWalls()
  if RGL_IsSeq(segs) then
    i = 0
    while i < len(segs)
      RGL_DrawSeg(segs[i])
      i = i + 1
    end while
    return
  end if
  if not RGL_IsSeq(lines) then return end if
  i = 0
  while i < len(lines)
    RGL_DrawLine(lines[i])
    i = i + 1
  end while
end function

/*
* Function: RGL_DrawMaskedSeg
* Purpose: Draws masked seg output for the OpenGL renderer.
*/
function RGL_DrawMaskedSeg(sg)
  global rgl_current_light

  if sg is void then return end if
  if rgl_building_cache then
    if RGL_IsVolatileSector(sg.frontsector) or RGL_IsVolatileSector(sg.backsector) then return end if
  end if
  hasMid = false
  if sg.sidedef is not void and typeof(sg.sidedef.midtexture) == "int" and sg.sidedef.midtexture != 0 then hasMid = true end if
  oside = void
  if sg.backsector is not void then oside = RGL_OppositeSide(sg.linedef, sg.sidedef) end if
  if oside is not void and typeof(oside.midtexture) == "int" and oside.midtexture != 0 then hasMid = true end if
  if not hasMid then return end if

  c = 192
  if sg.frontsector is not void then c = RGL_LightByte(sg.frontsector) end if
  rgl_current_light = c
  glColor4ub(c, c, c, 255)
  RGL_DrawMaskedMidtexture(sg.v1, sg.v2, sg.linedef, sg.sidedef, sg.frontsector, sg.backsector)
  if sg.backsector is not void then
    if oside is not void then
      c = RGL_LightByte(sg.backsector)
      rgl_current_light = c
      glColor4ub(c, c, c, 255)
      RGL_DrawMaskedMidtexture(sg.v2, sg.v1, sg.linedef, oside, sg.backsector, sg.frontsector)
    end if
  end if
end function

/*
* Function: RGL_DrawAllMaskedWalls
* Purpose: Draws all masked walls output for the OpenGL renderer.
*/
function RGL_DrawAllMaskedWalls()
  if not RGL_IsSeq(segs) then return end if
  glEnable(GL_TEXTURE_2D)
  glColor4ub(255, 255, 255, 255)
  i = 0
  while i < len(segs)
    RGL_DrawMaskedSeg(segs[i])
    i = i + 1
  end while
end function

/*
* Function: RGL_DrawLineSideMidtexture
* Purpose: Draws line side midtexture output for the OpenGL renderer.
*/
function RGL_DrawLineSideMidtexture(li, sideIndex)
  global rgl_current_light

  if li is void or li.v1 is void or li.v2 is void then return end if
  if li.frontsector is void or li.backsector is void then return end if
  if not RGL_IsSeq(li.sidenum) or not RGL_IsSeq(sides) then return end if
  if sideIndex < 0 or sideIndex >= len(li.sidenum) then return end if
  sid = li.sidenum[sideIndex]
  if typeof(sid) != "int" or sid < 0 or sid >= len(sides) then return end if
  side = sides[sid]
  if side is void or typeof(side.midtexture) != "int" or side.midtexture == 0 then return end if

  front = side.sector
  back = void
  if sideIndex == 0 then
    back = li.backsector
  else
    back = li.frontsector
  end if
  if front is void or back is void then return end if

  c = RGL_LightByte(front)
  rgl_current_light = c
  glColor4ub(c, c, c, 255)
  if sideIndex == 0 then
    RGL_DrawMaskedMidtexture(li.v1, li.v2, li, side, front, back)
  else
    RGL_DrawMaskedMidtexture(li.v2, li.v1, li, side, front, back)
  end if
end function

/*
* Function: RGL_DrawAllLineMidtextures
* Purpose: Draws all line midtextures output for the OpenGL renderer.
*/
function RGL_DrawAllLineMidtextures()
  if RGL_IsSeq(segs) and len(segs) > 0 then return end if
  if not RGL_IsSeq(lines) then return end if
  glEnable(GL_TEXTURE_2D)
  i = 0
  while i < len(lines)
    li = lines[i]
    if li is not void and li.frontsector is not void and li.backsector is not void then
      RGL_DrawLineSideMidtexture(li, 0)
      RGL_DrawLineSideMidtexture(li, 1)
    end if
    i = i + 1
  end while
end function

/*
* Function: RGL_DrawSkyInteriorBoundarySeg
* Purpose: Draws sky interior boundary seg output for the OpenGL renderer.
*/
function RGL_DrawSkyInteriorBoundarySeg(sg)
  global rgl_current_light

  if sg is void or sg.v1 is void or sg.v2 is void then return end if
  if sg.frontsector is void or sg.backsector is void then return end if
  frontSky = sg.frontsector.ceilingpic == skyflatnum
  backSky = sg.backsector.ceilingpic == skyflatnum
  if frontSky == backSky then return end if

  otherSide = RGL_OppositeSide(sg.linedef, sg.sidedef)

  tex = RGL_TopTextureOrZero(sg.sidedef)
  tex = RGL_FallbackStepTexture(tex, sg.sidedef, otherSide)
  if tex == 0 then return end if

  z0 = sg.frontsector.ceilingheight
  z1 = sg.backsector.ceilingheight
  if z1 < z0 then
    t = z0
    z0 = z1
    z1 = t
  end if
  if z1 <= z0 then return end if

  c = RGL_LightByte(sg.frontsector)
  rgl_current_light = c
  glColor3ub(c, c, c)
  RGL_DrawWallQuad(sg.v1, sg.v2, z0, z1, tex, sg.sidedef)

  if otherSide is not void then
    tex = RGL_TopTextureOrZero(otherSide)
    tex = RGL_FallbackStepTexture(tex, otherSide, sg.sidedef)
    if tex != 0 then
      c = RGL_LightByte(sg.backsector)
      rgl_current_light = c
      glColor3ub(c, c, c)
      RGL_DrawWallQuad(sg.v2, sg.v1, z0, z1, tex, otherSide)
    end if
  end if
end function

/*
* Function: RGL_DrawSkyInteriorBoundaries
* Purpose: Draws sky interior boundaries output for the OpenGL renderer.
*/
function RGL_DrawSkyInteriorBoundaries()
  if not RGL_IsSeq(segs) then return end if
  i = 0
  while i < len(segs)
    sg = segs[i]
    if sg is not void and sg.frontsector is not void and sg.backsector is not void then
      if (sg.frontsector.ceilingpic == skyflatnum) !=(sg.backsector.ceilingpic == skyflatnum) then
        RGL_DrawSkyInteriorBoundarySeg(sg)
      end if
    end if
    i = i + 1
  end while
end function

/*
* Function: RGL_DrawSkyInteriorBoundaryLine
* Purpose: Draws sky interior boundary line output for the OpenGL renderer.
*/
function RGL_DrawSkyInteriorBoundaryLine(li)
  global rgl_current_light

  if li is void or li.v1 is void or li.v2 is void then return end if
  if li.frontsector is void or li.backsector is void then return end if
  frontSky = li.frontsector.ceilingpic == skyflatnum
  backSky = li.backsector.ceilingpic == skyflatnum
  if frontSky == backSky then return end if
  if not RGL_IsSeq(li.sidenum) or not RGL_IsSeq(sides) then return end if

  side0 = void
  side1 = void
  if len(li.sidenum) > 0 then
    sid = li.sidenum[0]
    if typeof(sid) == "int" and sid >= 0 and sid < len(sides) then side0 = sides[sid] end if
  end if
  if len(li.sidenum) > 1 then
    sid = li.sidenum[1]
    if typeof(sid) == "int" and sid >= 0 and sid < len(sides) then side1 = sides[sid] end if
  end if

  z0 = li.frontsector.ceilingheight
  z1 = li.backsector.ceilingheight
  if z1 < z0 then
    t = z0
    z0 = z1
    z1 = t
  end if
  if z1 <= z0 then return end if

  tex = RGL_TopTextureOrZero(side0)
  tex = RGL_FallbackStepTexture(tex, side0, side1)
  if tex != 0 then
    c = RGL_LightByte(li.frontsector)
    rgl_current_light = c
    glColor3ub(c, c, c)
    RGL_DrawWallQuad(li.v1, li.v2, z0, z1, tex, side0)
  end if

  tex = RGL_TopTextureOrZero(side1)
  tex = RGL_FallbackStepTexture(tex, side1, side0)
  if tex != 0 then
    c = RGL_LightByte(li.backsector)
    rgl_current_light = c
    glColor3ub(c, c, c)
    RGL_DrawWallQuad(li.v2, li.v1, z0, z1, tex, side1)
  end if
end function

/*
* Function: RGL_DrawSkyInteriorBoundaryLines
* Purpose: Draws sky interior boundary lines output for the OpenGL renderer.
*/
function RGL_DrawSkyInteriorBoundaryLines()
  if not RGL_IsSeq(lines) then return end if
  i = 0
  while i < len(lines)
    li = lines[i]
    if li is not void and li.frontsector is not void and li.backsector is not void then
      if (li.frontsector.ceilingpic == skyflatnum) !=(li.backsector.ceilingpic == skyflatnum) then
        RGL_DrawSkyInteriorBoundaryLine(li)
      end if
    end if
    i = i + 1
  end while
end function

/*
* Function: RGL_DrawSkyPortalSeg
* Purpose: Draws sky portal seg output for the OpenGL renderer.
*/
function RGL_DrawSkyPortalSeg(sg)
  if sg is void or sg.v1 is void or sg.v2 is void then return end if
  if sg.frontsector is void then return end if
  front = sg.frontsector
  back = sg.backsector
  if front.ceilingpic != skyflatnum and(back is void or back.ceilingpic != skyflatnum) then return end if

  bottom = front.ceilingheight
  if back is not void and back.ceilingheight < bottom then bottom = back.ceilingheight end if
  top = bottom +(1536 * FRACUNIT)

  if rgl_building_cache then
    x1c = RGL_FixedToFloat(sg.v1.x)
    y1c = RGL_FixedToFloat(sg.v1.y)
    x2c = RGL_FixedToFloat(sg.v2.x)
    y2c = RGL_FixedToFloat(sg.v2.y)
    z0c = RGL_FixedToFloat(bottom)
    z1c = RGL_FixedToFloat(top)
    RGL_AddCachedDepthQuad(x1c, z0c, -y1c, x2c, z0c, -y2c, x2c, z1c, -y2c, x1c, z1c, -y1c)
    return
  end if

  glDisable(GL_TEXTURE_2D)
  glColorMask(false, false, false, false)

  x1 = RGL_FixedToFloat(sg.v1.x)
  y1 = RGL_FixedToFloat(sg.v1.y)
  x2 = RGL_FixedToFloat(sg.v2.x)
  y2 = RGL_FixedToFloat(sg.v2.y)
  s0 = RGL_SkySForPoint(x1, y1)
  s1 = RGL_SkySForPoint(x2, y2)
  while s1 < s0 - 0.5
    s1 = s1 + 1.0
  end while
  while s1 > s0 + 0.5
    s1 = s1 - 1.0
  end while
  z0 = RGL_FixedToFloat(bottom)
  z1 = RGL_FixedToFloat(top)

  glBegin(GL_QUADS)
  glVertex3d(x1, z0, -y1)
  glVertex3d(x2, z0, -y2)
  glVertex3d(x2, z1, -y2)
  glVertex3d(x1, z1, -y1)
  glEnd()
  glColorMask(true, true, true, true)
  glEnable(GL_TEXTURE_2D)
end function

/*
* Function: RGL_DrawSkyPortals
* Purpose: Draws sky portals output for the OpenGL renderer.
*/
function RGL_DrawSkyPortals()
  if not RGL_IsSeq(segs) then return end if
  glDepthMask(true)
  i = 0
  while i < len(segs)
    RGL_DrawSkyPortalSeg(segs[i])
    i = i + 1
  end while
  glDepthMask(true)
end function

/*
* Function: RGL_CrossFixed
* Purpose: Provides fixed helper behavior for the OpenGL renderer.
*/
function inline RGL_CrossFixed(ax, ay, bx, by, cx, cy)
  return(RGL_FixedToFloat(bx) - RGL_FixedToFloat(ax)) *(RGL_FixedToFloat(cy) - RGL_FixedToFloat(ay)) -(RGL_FixedToFloat(by) - RGL_FixedToFloat(ay)) *(RGL_FixedToFloat(cx) - RGL_FixedToFloat(ax))
end function

/*
* Function: RGL_PointInTriangle
* Purpose: Provides in triangle helper behavior for the OpenGL renderer.
*/
function RGL_PointInTriangle(px, py, ax, ay, bx, by, cx, cy)
  c1 = RGL_CrossFixed(px, py, ax, ay, bx, by)
  c2 = RGL_CrossFixed(px, py, bx, by, cx, cy)
  c3 = RGL_CrossFixed(px, py, cx, cy, ax, ay)
  hasNeg = c1 < -0.00001 or c2 < -0.00001 or c3 < -0.00001
  hasPos = c1 > 0.00001 or c2 > 0.00001 or c3 > 0.00001
  return not(hasNeg and hasPos)
end function

/*
* Function: RGL_DrawFlatTriangle
* Purpose: Draws flat triangle output for the OpenGL renderer.
*/
function RGL_DrawFlatTriangle(pxs, pys, a, b, c, zz, textured)
  ax = RGL_FixedToFloat(pxs[a])
  ay = RGL_FixedToFloat(pys[a])
  bx = RGL_FixedToFloat(pxs[b])
  by = RGL_FixedToFloat(pys[b])
  cx = RGL_FixedToFloat(pxs[c])
  cy = RGL_FixedToFloat(pys[c])
  if textured then glTexCoord2d(ax / 64.0, ay / 64.0) end if
  RGL_VertexLit(rgl_current_light, ax, zz, -ay)
  if textured then glTexCoord2d(bx / 64.0, by / 64.0) end if
  RGL_VertexLit(rgl_current_light, bx, zz, -by)
  if textured then glTexCoord2d(cx / 64.0, cy / 64.0) end if
  RGL_VertexLit(rgl_current_light, cx, zz, -cy)
end function

/*
* Function: RGL_DrawFlatPolygonEarClipped
* Purpose: Draws flat polygon ear clipped output for the OpenGL renderer.
*/
function RGL_DrawFlatPolygonEarClipped(pxs, pys, count, zz, textured)
  if count < 3 then return false end if

  area = 0.0
  i = 0
  while i < count
    j = i + 1
    if j >= count then j = 0 end if
    area = area + RGL_FixedToFloat(pxs[i]) * RGL_FixedToFloat(pys[j]) - RGL_FixedToFloat(pxs[j]) * RGL_FixedToFloat(pys[i])
    i = i + 1
  end while
  if area > -0.00001 and area < 0.00001 then return false end if
  ccw = area > 0.0

  workx = array(count, 0)
  worky = array(count, 0)
  i = 0
  while i < count
    workx[i] = pxs[i]
    worky[i] = pys[i]
    i = i + 1
  end while

  remaining = count
  emitted = 0
  guard = 0
  glBegin(GL_TRIANGLES)
  while remaining > 3 and guard < count * count
    earFound = false
    i = 0
    while i < remaining and not earFound
      pi = i - 1
      if pi < 0 then pi = remaining - 1 end if
      ni = i + 1
      if ni >= remaining then ni = 0 end if

      cr = RGL_CrossFixed(workx[pi], worky[pi], workx[i], worky[i], workx[ni], worky[ni])
      convex = false
      if ccw and cr > 0.00001 then convex = true end if
      if not ccw and cr < -0.00001 then convex = true end if

      if convex then
        contains = false
        k = 0
        while k < remaining and not contains
          if k != pi and k != i and k != ni then
            if RGL_PointInTriangle(workx[k], worky[k], workx[pi], worky[pi], workx[i], worky[i], workx[ni], worky[ni]) then contains = true end if
          end if
          k = k + 1
        end while

        if not contains then
          RGL_DrawFlatTriangle(workx, worky, pi, i, ni, zz, textured)
          emitted = emitted + 1
          k = i
          while k < remaining - 1
            workx[k] = workx[k + 1]
            worky[k] = worky[k + 1]
            k = k + 1
          end while
          remaining = remaining - 1
          earFound = true
        end if
      end if
      i = i + 1
    end while
    if not earFound then break end if
    guard = guard + 1
  end while

  if remaining == 3 then
    RGL_DrawFlatTriangle(workx, worky, 0, 1, 2, zz, textured)
    emitted = emitted + 1
  end if
  glEnd()

  return emitted > 0
end function

/*
* Function: RGL_DrawSubsectorFlat
* Purpose: Draws subsector flat output for the OpenGL renderer.
*/
function RGL_DrawSubsectorFlat(ss, z, flatnum)
  if ss is void or typeof(ss.numlines) != "int" or typeof(ss.firstline) != "int" then return end if
  texid = RGL_TextureIdForFlatnum(flatnum)
  textured = RGL_BindOrColor(texid)
  maxSegs = ss.numlines
  if maxSegs < 3 then return end if
  sx1 = array(maxSegs, 0)
  sy1 = array(maxSegs, 0)
  sx2 = array(maxSegs, 0)
  sy2 = array(maxSegs, 0)
  used = array(maxSegs, false)
  pointCap = maxSegs * 2 + 1
  pxs = array(pointCap, 0)
  pys = array(pointCap, 0)
  segCount = 0

  i = 0
  while i < ss.numlines
    segi = ss.firstline + i
    if RGL_IsSeq(segs) and segi >= 0 and segi < len(segs) then
      sg = segs[segi]
      if sg is not void and sg.v1 is not void and sg.v2 is not void then
        sx1[segCount] = sg.v1.x
        sy1[segCount] = sg.v1.y
        sx2[segCount] = sg.v2.x
        sy2[segCount] = sg.v2.y
        segCount = segCount + 1
      end if
    end if
    i = i + 1
  end while

  if segCount < 3 then return end if
  pxs[0] = sx1[0]
  pys[0] = sy1[0]
  pxs[1] = sx2[0]
  pys[1] = sy2[0]
  used[0] = true
  count = 2
  lastx = pxs[1]
  lasty = pys[1]

  steps = 0
  while count < segCount + 1 and steps < segCount * 2
    found = false
    i = 1
    while i < segCount and not found
      if not used[i] then
        if sx1[i] == lastx and sy1[i] == lasty then
          pxs[count] = sx2[i]
          pys[count] = sy2[i]
          lastx = sx2[i]
          lasty = sy2[i]
          used[i] = true
          count = count + 1
          found = true
        else if sx2[i] == lastx and sy2[i] == lasty then
          pxs[count] = sx1[i]
          pys[count] = sy1[i]
          lastx = sx1[i]
          lasty = sy1[i]
          used[i] = true
          count = count + 1
          found = true
        end if
      end if
      i = i + 1
    end while
    if not found then break end if
    steps = steps + 1
  end while

  chainOk = false
  if count > 3 and pxs[count - 1] == pxs[0] and pys[count - 1] == pys[0] then
    count = count - 1
    chainOk = true
  else if count >= segCount then
    chainOk = true
  end if

  // Doom subsector segs are not always a clean drawable vertex chain here.
  // Use the unique endpoints sorted around their center; subsectors are convex
  // BSP leaves, so this is more reliable than trusting traversal order.
  chainOk = false

  if not chainOk then
    count = 0
    cx = 0.0
    cy = 0.0
    i = 0
    while i < segCount
      exists = false
      j = 0
      while j < count
        if pxs[j] == sx1[i] and pys[j] == sy1[i] then exists = true end if
        j = j + 1
      end while
      if not exists and count < pointCap then
        pxs[count] = sx1[i]
        pys[count] = sy1[i]
        cx = cx + RGL_FixedToFloat(sx1[i])
        cy = cy + RGL_FixedToFloat(sy1[i])
        count = count + 1
      end if

      exists = false
      j = 0
      while j < count
        if pxs[j] == sx2[i] and pys[j] == sy2[i] then exists = true end if
        j = j + 1
      end while
      if not exists and count < pointCap then
        pxs[count] = sx2[i]
        pys[count] = sy2[i]
        cx = cx + RGL_FixedToFloat(sx2[i])
        cy = cy + RGL_FixedToFloat(sy2[i])
        count = count + 1
      end if
      i = i + 1
    end while
    if count < 3 then return end if
    cx = cx / count
    cy = cy / count

    angles = array(pointCap, 0.0)
    i = 0
    while i < count
      angles[i] = std.math.atan2(RGL_FixedToFloat(pys[i]) - cy, RGL_FixedToFloat(pxs[i]) - cx)
      i = i + 1
    end while

    i = 1
    while i < count
      ax = pxs[i]
      ay = pys[i]
      aa = angles[i]
      j = i - 1
      while j >= 0 and angles[j] > aa
        pxs[j + 1] = pxs[j]
        pys[j + 1] = pys[j]
        angles[j + 1] = angles[j]
        j = j - 1
      end while
      pxs[j + 1] = ax
      pys[j + 1] = ay
      angles[j + 1] = aa
      i = i + 1
    end while
  end if
  if count < 3 then return end if

  zz = RGL_FixedToFloat(z)
  if RGL_DrawFlatPolygonEarClipped(pxs, pys, count, zz, textured) then return end if

  glBegin(GL_TRIANGLES)
  baseX = RGL_FixedToFloat(pxs[0])
  baseY = RGL_FixedToFloat(pys[0])
  i = 1
  while i < count - 1
    x1 = RGL_FixedToFloat(pxs[i])
    y1 = RGL_FixedToFloat(pys[i])
    x2 = RGL_FixedToFloat(pxs[i + 1])
    y2 = RGL_FixedToFloat(pys[i + 1])
    if textured then glTexCoord2d(baseX / 64.0, baseY / 64.0) end if
    glVertex3d(baseX, zz, -baseY)
    if textured then glTexCoord2d(x1 / 64.0, y1 / 64.0) end if
    glVertex3d(x1, zz, -y1)
    if textured then glTexCoord2d(x2 / 64.0, y2 / 64.0) end if
    glVertex3d(x2, zz, -y2)
    i = i + 1
  end while
  glEnd()
end function

/*
* Function: RGL_DrawAllFlats
* Purpose: Draws all flats output for the OpenGL renderer.
*/
function RGL_DrawAllFlats()
  global rgl_current_light

  if not RGL_IsSeq(subsectors) then return end if
  i = 0
  while i < len(subsectors)
    ss = subsectors[i]
    if ss is not void and ss.sector is not void then
      c = RGL_LightByte(ss.sector)
      rgl_current_light = c
      glColor3ub(c, c, c)
      RGL_DrawSubsectorFlat(ss, ss.sector.floorheight, ss.sector.floorpic)
      RGL_DrawSubsectorFlat(ss, ss.sector.ceilingheight, ss.sector.ceilingpic)
    end if
    i = i + 1
  end while
end function

/*
* Function: RGL_AddCachedFlatConvexFloat
* Purpose: Manages cached add Cached Flat Convex Float data for the OpenGL renderer system.
*/
function RGL_AddCachedFlatConvexFloat(xs, ys, count, z, flatnum)
  global rgl_flat_tris

  zz = RGL_FixedToFloat(z)
  baseX = xs[0]
  baseY = ys[0]
  i = 1
  while i < count - 1
    x1 = xs[i]
    y1 = ys[i]
    x2 = xs[i + 1]
    y2 = ys[i + 1]
    rgl_flat_tris = rgl_flat_tris +[rgl_flat_tri_t(flatnum, rgl_current_light,
      baseX, zz, -baseY, baseX / 64.0, baseY / 64.0,
      x1, zz, -y1, x1 / 64.0, y1 / 64.0,
      x2, zz, -y2, x2 / 64.0, y2 / 64.0)]
    i = i + 1
  end while
end function

/*
* Function: RGL_DrawCachedFlatTris
* Purpose: Draws cached flat triangles output for the OpenGL renderer.
*/
function RGL_DrawCachedFlatTris()
  if not RGL_IsSeq(rgl_flat_tris) then return end if
  i = 0
  while i < len(rgl_flat_tris)
    t = rgl_flat_tris[i]
    if t is not void then
      textured = RGL_BindOrColor(RGL_TextureIdForFlatnum(t.flatnum))
      glBegin(GL_TRIANGLES)
      if textured then glTexCoord2d(t.s0, t.t0) end if
      RGL_VertexLit(t.light, t.x0, t.y0, t.z0)
      if textured then glTexCoord2d(t.s1, t.t1) end if
      RGL_VertexLit(t.light, t.x1, t.y1, t.z1)
      if textured then glTexCoord2d(t.s2, t.t2) end if
      RGL_VertexLit(t.light, t.x2, t.y2, t.z2)
      glEnd()
    end if
    i = i + 1
  end while
end function

/*
* Function: RGL_DrawFlatConvexFloat
* Purpose: Draws flat convex float output for the OpenGL renderer.
*/
function RGL_DrawFlatConvexFloat(xs, ys, count, z, flatnum)
  if count < 3 then return end if
  if rgl_building_cache then
    RGL_AddCachedFlatConvexFloat(xs, ys, count, z, flatnum)
    return
  end if
  texid = RGL_TextureIdForFlatnum(flatnum)
  textured = RGL_BindOrColor(texid)
  zz = RGL_FixedToFloat(z)

  glBegin(GL_TRIANGLES)
  baseX = xs[0]
  baseY = ys[0]
  i = 1
  while i < count - 1
    x1 = xs[i]
    y1 = ys[i]
    x2 = xs[i + 1]
    y2 = ys[i + 1]
    if textured then glTexCoord2d(baseX / 64.0, baseY / 64.0) end if
    RGL_VertexLit(rgl_current_light, baseX, zz, -baseY)
    if textured then glTexCoord2d(x1 / 64.0, y1 / 64.0) end if
    RGL_VertexLit(rgl_current_light, x1, zz, -y1)
    if textured then glTexCoord2d(x2 / 64.0, y2 / 64.0) end if
    RGL_VertexLit(rgl_current_light, x2, zz, -y2)
    i = i + 1
  end while
  glEnd()
end function

/*
* Function: RGL_SkySForPoint
* Purpose: Provides s for point helper behavior for the OpenGL renderer.
*/
function RGL_SkySForPoint(x, y)
  dx = x - rgl_view_x
  dy = y - rgl_view_y
  a = std.math.atan2(dy, dx) / 6.283185314
  yaw = RGL_NormalizeDegrees(rgl_view_yaw) / 360.0
  return a - yaw
end function

/*
* Function: RGL_DrawSkyVertex
* Purpose: Draws sky vertex output for the OpenGL renderer.
*/
function RGL_DrawSkyVertex(x, y, z)
  s = RGL_SkySForPoint(x, y)
  glTexCoord2d(s, 0.5)
  glVertex3d(x, z, -y)
end function

/*
* Function: RGL_DrawSkyConvexFloat
* Purpose: Draws sky convex float output for the OpenGL renderer.
*/
function RGL_DrawSkyConvexFloat(xs, ys, count, z)
  if count < 3 then return end if
  if typeof(skytexture) != "int" then return end if
  texid = RGL_TextureIdForTexnum(skytexture)
  if texid <= 0 then return end if

  glEnable(GL_TEXTURE_2D)
  glBindTexture(GL_TEXTURE_2D, texid)
  glColor3ub(255, 255, 255)
  zz = RGL_FixedToFloat(z)

  glBegin(GL_TRIANGLES)
  baseX = xs[0]
  baseY = ys[0]
  i = 1
  while i < count - 1
    RGL_DrawSkyVertex(baseX, baseY, zz)
    RGL_DrawSkyVertex(xs[i], ys[i], zz)
    RGL_DrawSkyVertex(xs[i + 1], ys[i + 1], zz)
    i = i + 1
  end while
  glEnd()
end function

/*
* Function: RGL_AddCachedDepthConvexFloat
* Purpose: Manages cached add Cached Depth Convex Float data for the OpenGL renderer system.
*/
function RGL_AddCachedDepthConvexFloat(xs, ys, count, z)
  global rgl_depth_tris

  zz = RGL_FixedToFloat(z)
  baseX = xs[0]
  baseY = ys[0]
  i = 1
  while i < count - 1
    rgl_depth_tris = rgl_depth_tris +[rgl_depth_tri_t(
      baseX, zz, -baseY,
      xs[i], zz, -ys[i],
      xs[i + 1], zz, -ys[i + 1])]
    i = i + 1
  end while
end function

/*
* Function: RGL_AddCachedDepthQuad
* Purpose: Manages cached add Cached Depth Quad data for the OpenGL renderer system.
*/
function RGL_AddCachedDepthQuad(x0, y0, z0, x1, y1, z1, x2, y2, z2, x3, y3, z3)
  global rgl_depth_quads

  rgl_depth_quads = rgl_depth_quads +[rgl_depth_quad_t(x0, y0, z0, x1, y1, z1, x2, y2, z2, x3, y3, z3)]
end function

/*
* Function: RGL_DrawCachedDepthGeometry
* Purpose: Draws cached depth geometry output for the OpenGL renderer.
*/
function RGL_DrawCachedDepthGeometry()
  glDisable(GL_TEXTURE_2D)
  glColorMask(false, false, false, false)
  glDepthMask(true)

  if RGL_IsSeq(rgl_depth_tris) then
    i = 0
    while i < len(rgl_depth_tris)
      t = rgl_depth_tris[i]
      if t is not void then
        glBegin(GL_TRIANGLES)
        glVertex3d(t.x0, t.y0, t.z0)
        glVertex3d(t.x1, t.y1, t.z1)
        glVertex3d(t.x2, t.y2, t.z2)
        glEnd()
      end if
      i = i + 1
    end while
  end if

  if RGL_IsSeq(rgl_depth_quads) then
    i = 0
    while i < len(rgl_depth_quads)
      q = rgl_depth_quads[i]
      if q is not void then
        glBegin(GL_QUADS)
        glVertex3d(q.x0, q.y0, q.z0)
        glVertex3d(q.x1, q.y1, q.z1)
        glVertex3d(q.x2, q.y2, q.z2)
        glVertex3d(q.x3, q.y3, q.z3)
        glEnd()
      end if
      i = i + 1
    end while
  end if

  glColorMask(true, true, true, true)
  glEnable(GL_TEXTURE_2D)
end function

/*
* Function: RGL_DrawSkyDepthConvexFloat
* Purpose: Draws sky depth convex float output for the OpenGL renderer.
*/
function RGL_DrawSkyDepthConvexFloat(xs, ys, count, z)
  if count < 3 then return end if
  if rgl_building_cache then
    RGL_AddCachedDepthConvexFloat(xs, ys, count, z)
    return
  end if
  glDisable(GL_TEXTURE_2D)
  glColorMask(false, false, false, false)
  glDepthMask(true)
  zz = RGL_FixedToFloat(z)

  glBegin(GL_TRIANGLES)
  baseX = xs[0]
  baseY = ys[0]
  i = 1
  while i < count - 1
    glVertex3d(baseX, zz, -baseY)
    glVertex3d(xs[i], zz, -ys[i])
    glVertex3d(xs[i + 1], zz, -ys[i + 1])
    i = i + 1
  end while
  glEnd()

  glColorMask(true, true, true, true)
  glEnable(GL_TEXTURE_2D)
end function

/*
* Function: RGL_SectorTouchesSkyCeiling
* Purpose: Provides touches sky ceiling helper behavior for the OpenGL renderer.
*/
function RGL_SectorTouchesSkyCeiling(sec)
  if sec is void or not RGL_IsSeq(sec.lines) or typeof(sec.linecount) != "int" then return false end if
  i = 0
  while i < sec.linecount and i < len(sec.lines)
    li = sec.lines[i]
    other = void
    if li is not void then
      if li.frontsector == sec then
        other = li.backsector
      else if li.backsector == sec then
        other = li.frontsector
      end if
    end if
    if other is not void and other.ceilingpic == skyflatnum then return true end if
    i = i + 1
  end while
  return false
end function

/*
* Function: RGL_BspSideValueFloat
* Purpose: Provides side value float helper behavior for the OpenGL renderer.
*/
function RGL_BspSideValueFloat(x, y, node)
  nx = RGL_FixedToFloat(node.x)
  ny = RGL_FixedToFloat(node.y)
  ndx = RGL_FixedToFloat(node.dx)
  ndy = RGL_FixedToFloat(node.dy)
  return(x - nx) * ndy -(y - ny) * ndx
end function

/*
* Function: RGL_ClipPolyToNodeSide
* Purpose: Computes poly to node side values for the OpenGL renderer.
*/
function RGL_ClipPolyToNodeSide(xs, ys, count, node, side, outx, outy)
  if count < 3 or node is void then return 0 end if
  outCount = 0
  eps = 0.001

  prev = count - 1
  prevX = xs[prev]
  prevY = ys[prev]
  prevV = RGL_BspSideValueFloat(prevX, prevY, node)
  prevIn = false
  if side == 0 then
    prevIn = prevV >= -eps
  else
    prevIn = prevV <= eps
  end if

  i = 0
  while i < count
    curX = xs[i]
    curY = ys[i]
    curV = RGL_BspSideValueFloat(curX, curY, node)
    curIn = false
    if side == 0 then
      curIn = curV >= -eps
    else
      curIn = curV <= eps
    end if

    if curIn != prevIn then
      denom = prevV - curV
      if denom > 0.000001 or denom < -0.000001 then
        t = prevV / denom
        if outCount < len(outx) then
          outx[outCount] = prevX +(curX - prevX) * t
          outy[outCount] = prevY +(curY - prevY) * t
          outCount = outCount + 1
        end if
      end if
    end if

    if curIn then
      if outCount < len(outx) then
        outx[outCount] = curX
        outy[outCount] = curY
        outCount = outCount + 1
      end if
    end if

    prevX = curX
    prevY = curY
    prevV = curV
    prevIn = curIn
    i = i + 1
  end while

  return outCount
end function

/*
* Function: RGL_DrawBspLeafFlat
* Purpose: Draws BSP leaf flat output for the OpenGL renderer.
*/
function RGL_DrawBspLeafFlat(sidx, xs, ys, count)
  global rgl_current_light
  global rgl_flat_volatile_only

  if sidx < 0 or not RGL_IsSeq(subsectors) or sidx >= len(subsectors) then return end if
  if rgl_flat_volatile_only and not RGL_IsVolatileSubsectorIndex(sidx) then return end if
  if rgl_building_cache and RGL_IsVolatileSubsectorIndex(sidx) then return end if
  ss = subsectors[sidx]
  if ss is void or ss.sector is void then return end if
  sec = ss.sector
  c = RGL_LightByte(sec)
  rgl_current_light = c
  glColor3ub(c, c, c)
  RGL_DrawFlatConvexFloat(xs, ys, count, sec.floorheight, sec.floorpic)
  if sec.ceilingpic != skyflatnum then
    RGL_DrawFlatConvexFloat(xs, ys, count, sec.ceilingheight, sec.ceilingpic)
  else
    RGL_DrawSkyDepthConvexFloat(xs, ys, count, sec.ceilingheight)
  end if
end function

/*
* Function: RGL_Restore3DProjection
* Purpose: Provides d projection helper behavior for the OpenGL renderer.
*/
function RGL_Restore3DProjection()
  aspect = 1.6
  if typeof(igl_width) == "int" and typeof(igl_height) == "int" and igl_height > 0 then
    aspect = igl_width / igl_height
  end if
  if aspect <= 0 then aspect = 1.6 end if
  nearz = 4.0
  farz = 4096.0
  top = 2.505
  yshift = -0.401
  right = top * aspect

  glMatrixMode(GL_PROJECTION)
  glLoadIdentity()
  glFrustum(-right, right, -top + yshift, top + yshift, nearz, farz)
  glMatrixMode(GL_MODELVIEW)
  glLoadIdentity()
end function

/*
* Function: RGL_DrawSky
* Purpose: Draws sky output for the OpenGL renderer.
*/
function RGL_DrawSky(yaw)
  if typeof(skytexture) != "int" then return end if
  texid = RGL_TextureIdForTexnum(skytexture)
  if texid <= 0 then return end if

  glDisable(GL_DEPTH_TEST)
  glEnable(GL_TEXTURE_2D)
  glBindTexture(GL_TEXTURE_2D, texid)
  glColor3ub(255, 255, 255)

  glMatrixMode(GL_PROJECTION)
  glLoadIdentity()
  glMatrixMode(GL_MODELVIEW)
  glLoadIdentity()

  s0 = 0.0
  s1 = s0 + 1.0
  glBegin(GL_QUADS)
  glTexCoord2d(s0, 0.0)
  glVertex3d(-1.0, 1.0, 0.0)
  glTexCoord2d(s1, 0.0)
  glVertex3d(1.0, 1.0, 0.0)
  glTexCoord2d(s1, 1.0)
  glVertex3d(1.0, -1.0, 0.0)
  glTexCoord2d(s0, 1.0)
  glVertex3d(-1.0, -1.0, 0.0)
  glEnd()

  glEnable(GL_DEPTH_TEST)
  RGL_Restore3DProjection()
end function

/*
* Function: RGL_DrawBspFlatNode
* Purpose: Draws BSP flat node output for the OpenGL renderer.
*/
function RGL_DrawBspFlatNode(bspnum, xs, ys, count)
  if count < 3 then return end if

  if (bspnum & NF_SUBSECTOR) != 0 then
    sidx = 0
    if bspnum != -1 then sidx = bspnum &(~NF_SUBSECTOR) end if
    RGL_DrawBspLeafFlat(sidx, xs, ys, count)
    return
  end if

  if not RGL_IsSeq(nodes) or bspnum < 0 or bspnum >= len(nodes) then return end if
  node = nodes[bspnum]
  if node is void or not RGL_IsSeq(node.children) then return end if

  cap = len(xs) + 2
  if cap < 16 then cap = 16 end if
  if cap > 256 then cap = 256 end if
  xs0 = array(cap, 0.0)
  ys0 = array(cap, 0.0)
  xs1 = array(cap, 0.0)
  ys1 = array(cap, 0.0)

  c0 = RGL_ClipPolyToNodeSide(xs, ys, count, node, 0, xs0, ys0)
  c1 = RGL_ClipPolyToNodeSide(xs, ys, count, node, 1, xs1, ys1)

  if c0 >= 3 and len(node.children) > 0 then RGL_DrawBspFlatNode(node.children[0], xs0, ys0, c0) end if
  if c1 >= 3 and len(node.children) > 1 then RGL_DrawBspFlatNode(node.children[1], xs1, ys1, c1) end if
end function

/*
* Function: RGL_DrawAllBspFlats
* Purpose: Draws all BSP flats output for the OpenGL renderer.
*/
function RGL_DrawAllBspFlats()
  if not RGL_IsSeq(nodes) or typeof(numnodes) != "int" or numnodes <= 0 then
    RGL_DrawAllFlats()
    return
  end if
  if not RGL_IsSeq(lines) or len(lines) <= 0 then return end if

  left = 2147483647
  right = -2147483648
  bottom = 2147483647
  top = -2147483648
  i = 0
  while i < len(lines)
    li = lines[i]
    if li is not void and li.v1 is not void and li.v2 is not void then
      if li.v1.x < left then left = li.v1.x end if
      if li.v2.x < left then left = li.v2.x end if
      if li.v1.x > right then right = li.v1.x end if
      if li.v2.x > right then right = li.v2.x end if
      if li.v1.y < bottom then bottom = li.v1.y end if
      if li.v2.y < bottom then bottom = li.v2.y end if
      if li.v1.y > top then top = li.v1.y end if
      if li.v2.y > top then top = li.v2.y end if
    end if
    i = i + 1
  end while

  if left >= right or bottom >= top then
    RGL_DrawAllFlats()
    return
  end if

  margin = 1024.0
  x0 = RGL_FixedToFloat(left) - margin
  x1 = RGL_FixedToFloat(right) + margin
  y0 = RGL_FixedToFloat(bottom) - margin
  y1 = RGL_FixedToFloat(top) + margin

  xs = array(256, 0.0)
  ys = array(256, 0.0)
  xs[0] = x0
  ys[0] = y0
  xs[1] = x1
  ys[1] = y0
  xs[2] = x1
  ys[2] = y1
  xs[3] = x0
  ys[3] = y1
  RGL_DrawBspFlatNode(numnodes - 1, xs, ys, 4)
end function

/*
* Function: RGL_SelectSpriteLump
* Purpose: Computes sprite lump values for the OpenGL renderer.
*/
function RGL_SelectSpriteLump(thing, player)
  if thing is void or not RGL_IsSeq(sprites) then return [-1, 0] end if
  spriteIdx = RGL_SpriteIndex(thing.sprite)
  if spriteIdx < 0 or spriteIdx >= len(sprites) then return [-1, 0] end if
  sprdef = sprites[spriteIdx]
  if sprdef is void or typeof(sprdef.numframes) != "int" or sprdef.numframes <= 0 then return [-1, 0] end if
  frameIdx = thing.frame & RGL_FF_FRAMEMASK
  if frameIdx < 0 or frameIdx >= sprdef.numframes then return [-1, 0] end if
  sprframe = sprdef.spriteframes[frameIdx]
  if sprframe is void then return [-1, 0] end if
  if sprframe.rotate != 1 then return [sprframe.lump[0], sprframe.flip[0]] end if

  dx = RGL_FixedToFloat(thing.x - player.mo.x)
  dy = RGL_FixedToFloat(thing.y - player.mo.y)
  angleToView = std.math.atan2(dy, dx) * 57.295779513
  thingAngle = RGL_AngleToDegrees(thing.angle)
  delta = RGL_NormalizeDegrees(angleToView - thingAngle + 202.5)
  rot = std.math.floor(delta / 45.0) & 7
  return [sprframe.lump[rot], sprframe.flip[rot]]
end function

/*
* Function: RGL_DrawOneSpriteBillboard
* Purpose: Draws one sprite billboard output for the OpenGL renderer.
*/
function RGL_DrawOneSpriteBillboard(mo, lump, flip, rx, rz)
  entry = RGL_SpriteEntryForLump(lump)
  texid = RGL_TextureIdForSpriteLump(lump)
  if texid <= 0 or entry is void then return end if

  c = 192
  if mo.subsector is not void and mo.subsector.sector is not void then c = RGL_LightByte(mo.subsector.sector) end if
  scale = 1
  if typeof(ru_scale) == "int" and ru_scale > 0 then scale = ru_scale end if
  origW = entry.width / scale
  origH = entry.height / scale
  topOff = entry.yoffset / scale
  x = RGL_FixedToFloat(mo.x)
  y = -RGL_FixedToFloat(mo.y)
  z1 = RGL_FixedToFloat(mo.z) + topOff + RGL_WORLD_SPRITE_FOOT_LIFT
  z0 = z1 - origH
  RGL_SetVertexLight(c, x, (z0 + z1) / 2.0, y)
  halfw = origW / 2.0
  if halfw < 2.0 then halfw = 2.0 end if
  x0 = x - rx * halfw
  y0 = y - rz * halfw
  x1 = x + rx * halfw
  y1 = y + rz * halfw
  glBindTexture(GL_TEXTURE_2D, texid)
  glBegin(GL_QUADS)
  if flip != 0 then
    glTexCoord2d(1.0, 1.0)
    glVertex3d(x0, z0, y0)
    glTexCoord2d(0.0, 1.0)
    glVertex3d(x1, z0, y1)
    glTexCoord2d(0.0, 0.0)
    glVertex3d(x1, z1, y1)
    glTexCoord2d(1.0, 0.0)
    glVertex3d(x0, z1, y0)
  else
    glTexCoord2d(0.0, 1.0)
    glVertex3d(x0, z0, y0)
    glTexCoord2d(1.0, 1.0)
    glVertex3d(x1, z0, y1)
    glTexCoord2d(1.0, 0.0)
    glVertex3d(x1, z1, y1)
    glTexCoord2d(0.0, 0.0)
    glVertex3d(x0, z1, y0)
  end if
  glEnd()
end function

/*
* Function: RGL_DrawSpriteBillboards
* Purpose: Draws sprite billboards output for the OpenGL renderer.
*/
function RGL_DrawSpriteBillboards(player, yaw)
  if not RGL_IsSeq(sectors) then return end if
  glEnable(GL_TEXTURE_2D)
  RGL_EnableCutoutAlpha()
  glColor4ub(255, 255, 255, 255)

  yawRad = (yaw / 360.0) * 6.283185314
  fwdX = std.math.cos(yawRad)
  fwdY = std.math.sin(yawRad)
  rad =((90.0 - yaw) / 360.0) * 6.283185314
  rx = std.math.cos(rad)
  rz = std.math.sin(rad)
  farDist = 4096.0 * 4096.0
  si = 0
  while si < len(sectors)
    mo = sectors[si].thinglist
    guard = 0
    while mo is not void and guard < 512
      dx = RGL_FixedToFloat(mo.x - player.mo.x)
      dy = RGL_FixedToFloat(mo.y - player.mo.y)
      dist = dx * dx + dy * dy
      forward = dx * fwdX + dy * fwdY
      side = dx *(-fwdY) + dy * fwdX
      if side < 0.0 then side = -side end if
      visibleEnough = false
      if dist <= farDist and forward > -64.0 then
        if forward < 1.0 then
          if side < 128.0 then visibleEnough = true end if
        else if side <= forward * 1.8 + 160.0 then
          visibleEnough = true
        end if
      end if
      if visibleEnough then
        sel = RGL_SelectSpriteLump(mo, player)
        lump = sel[0]
        flip = sel[1]
        if typeof(lump) == "int" and lump >= 0 then
          RGL_DrawOneSpriteBillboard(mo, lump, flip, rx, rz)
        end if
      end if
      mo = mo.snext
      guard = guard + 1
    end while
    si = si + 1
  end while
  RGL_DisableCutoutAlpha()
end function

/*
* Function: RGL_DrawPlayerWeapon2D
* Purpose: Draws player weapon2 d output for the OpenGL renderer.
*/
function RGL_DrawPlayerWeapon2D(player)
  if player is void or not RGL_IsSeq(player.psprites) or not RGL_IsSeq(sprites) then return end if

  logicalCenterY = RGL_BASEYCENTER
  if typeof(centery) == "int" then logicalCenterY = centery end if
  renderScale = 1
  if typeof(ru_scale) == "int" and ru_scale > 0 then renderScale = ru_scale end if
  if renderScale > 1 and logicalCenterY > SCREENHEIGHT then logicalCenterY = logicalCenterY / renderScale end if
  weaponViewYOffset = logicalCenterY - RGL_BASEYCENTER

  i = 0
  while i < len(player.psprites)
    psp = player.psprites[i]
    if psp is not void and psp.state is not void then
      st = psp.state
      spriteIdx = RGL_SpriteIndex(st.sprite)
      if spriteIdx >= 0 and spriteIdx < len(sprites) then
        sprdef = sprites[spriteIdx]
        if sprdef is not void and typeof(sprdef.numframes) == "int" and sprdef.numframes > 0 then
          frameIdx = st.frame & RGL_FF_FRAMEMASK
          if frameIdx >= 0 and frameIdx < sprdef.numframes then
            sprframe = sprdef.spriteframes[frameIdx]
            if sprframe is not void then
              lump = sprframe.lump[0]
              flip = sprframe.flip[0]
              if typeof(lump) == "int" and lump >= 0 then
                entry = RGL_SpriteEntryForLump(lump)
                texid = RGL_TextureIdForSpriteLump(lump)
                if texid > 0 and entry is not void then
                  scale = 1
                  if typeof(ru_scale) == "int" and ru_scale > 0 then scale = ru_scale end if
                  w = entry.width / scale
                  h = entry.height / scale
                  x = RGL_FixedToFloat(psp.sx) - entry.xoffset / scale
                  y = RGL_FixedToFloat(psp.sy) - entry.yoffset / scale + weaponViewYOffset
                  IGL_DrawTextureRect(texid, x, y, w, h, flip != 0)
                end if
              end if
            end if
          end if
        end if
      end if
    end if
    i = i + 1
  end while
end function

/*
* Function: RGL_BuildGeometryCache
* Purpose: Builds geometry cache data for the OpenGL renderer.
*/
function RGL_BuildGeometryCache(sigMap, sigSegs, sigLines, sigNodes, sigSubsectors, sigSectorMotion, sigSides)
  global rgl_building_cache
  global rgl_cache_target
  global rgl_current_light
  global rgl_geom_ready
  global rgl_geom_sig_map
  global rgl_geom_sig_segs
  global rgl_geom_sig_lines
  global rgl_geom_sig_nodes
  global rgl_geom_sig_subsectors
  global rgl_geom_sig_sector_motion
  global rgl_geom_sig_sides
  global rgl_pending_sig_sector_motion
  global rgl_pending_sig_sides
  global rgl_pending_stable_frames
  global rgl_boundary_quads
  global rgl_wall_quads
  global rgl_masked_quads
  global rgl_flat_tris
  global rgl_depth_tris
  global rgl_depth_quads

  RGL_EnsureVolatileSectorMap(sigMap)

  rgl_boundary_quads =[]
  rgl_wall_quads =[]
  rgl_masked_quads =[]
  rgl_flat_tris =[]
  rgl_depth_tris =[]
  rgl_depth_quads =[]
  rgl_current_light = 255

  rgl_building_cache = true

  rgl_cache_target = RGL_CACHE_BOUNDARY
  RGL_DrawSkyInteriorBoundaries()
  RGL_DrawSkyInteriorBoundaryLines()

  RGL_DrawSkyPortals()
  RGL_DrawAllBspFlats()

  rgl_cache_target = RGL_CACHE_WALL
  RGL_DrawAllWalls()

  rgl_cache_target = RGL_CACHE_MASKED
  RGL_DrawAllMaskedWalls()
  RGL_DrawAllLineMidtextures()

  rgl_cache_target = 0
  rgl_building_cache = false
  rgl_geom_sig_map = sigMap
  rgl_geom_sig_segs = sigSegs
  rgl_geom_sig_lines = sigLines
  rgl_geom_sig_nodes = sigNodes
  rgl_geom_sig_subsectors = sigSubsectors
  rgl_geom_sig_sector_motion = sigSectorMotion
  rgl_geom_sig_sides = sigSides
  rgl_pending_sig_sector_motion = sigSectorMotion
  rgl_pending_sig_sides = sigSides
  rgl_pending_stable_frames = 0
  rgl_geom_ready = true
end function

/*
* Function: RGL_EnsureGeometryCache
* Purpose: Manages cached ensure Geometry Cache data for the OpenGL renderer system.
*/
function RGL_EnsureGeometryCache()
  global rgl_pending_sig_sector_motion
  global rgl_pending_sig_sides
  global rgl_pending_stable_frames

  sigMap = -1
  if typeof(gamemap) == "int" then sigMap = gamemap end if
  sigSegs = RGL_SeqLen(segs)
  sigLines = RGL_SeqLen(lines)
  sigNodes = RGL_SeqLen(nodes)
  sigSubsectors = RGL_SeqLen(subsectors)
  topologySame = rgl_geom_ready and rgl_geom_sig_map == sigMap and rgl_geom_sig_segs == sigSegs and rgl_geom_sig_lines == sigLines and rgl_geom_sig_nodes == sigNodes and rgl_geom_sig_subsectors == sigSubsectors
  sigSectorMotion = RGL_SectorMotionSignature()
  sigSides = RGL_SideTextureSignature()
  if topologySame then
    if rgl_geom_sig_sector_motion == sigSectorMotion and rgl_geom_sig_sides == sigSides then return true end if
    if RGL_HasActiveSectorMotion() then return true end if
  end if

  if not rgl_geom_ready then
    if RGL_TryLoadGeometryCache(sigMap, sigSegs, sigLines, sigNodes, sigSubsectors, sigSectorMotion, sigSides) then return true end if
  end if
  RGL_BuildGeometryCache(sigMap, sigSegs, sigLines, sigNodes, sigSubsectors, sigSectorMotion, sigSides)
  return true
end function

/*
* Function: RGL_DrawCachedWorld
* Purpose: Draws cached world output for the OpenGL renderer.
*/
function RGL_DrawCachedWorld(player, yaw)
  RGL_DrawCachedTexturedQuads(rgl_boundary_quads)
  RGL_DrawCachedDepthGeometry()
  RGL_DrawCachedFlatTris()
  RGL_DrawCachedTexturedQuads(rgl_wall_quads)
  RGL_DrawSpriteBillboards(player, yaw)
  RGL_DrawCachedTexturedQuads(rgl_masked_quads)
end function

/*
* Function: RGL_DrawDirectWorld
* Purpose: Draws direct world output for the OpenGL renderer.
*/
function RGL_DrawDirectWorld(player, yaw)
  RGL_DrawSkyInteriorBoundaries()
  RGL_DrawSkyInteriorBoundaryLines()
  RGL_DrawSkyPortals()
  RGL_DrawAllBspFlats()
  RGL_DrawAllWalls()
  RGL_DrawSpriteBillboards(player, yaw)
  RGL_DrawAllMaskedWalls()
  RGL_DrawAllLineMidtextures()
end function

/*
* Function: RGL_DrawVolatileFlats
* Purpose: Draws only flats that belong to dynamic sector geometry.
*/
function RGL_DrawVolatileFlats()
  global rgl_current_light
  global rgl_flat_volatile_only

  if RGL_IsSeq(nodes) and typeof(numnodes) == "int" and numnodes > 0 then
    oldFilter = rgl_flat_volatile_only
    rgl_flat_volatile_only = true
    RGL_DrawAllBspFlats()
    rgl_flat_volatile_only = oldFilter
    return
  end if

  if not RGL_IsSeq(rgl_volatile_subsectors) or not RGL_IsSeq(subsectors) then return end if
  i = 0
  while i < len(rgl_volatile_subsectors)
    idx = rgl_volatile_subsectors[i]
    if typeof(idx) == "int" and idx >= 0 and idx < len(subsectors) then
      ss = subsectors[idx]
      if ss is not void and ss.sector is not void then
        c = RGL_LightByte(ss.sector)
        rgl_current_light = c
        glColor3ub(c, c, c)
        RGL_DrawSubsectorFlat(ss, ss.sector.floorheight, ss.sector.floorpic)
        RGL_DrawSubsectorFlat(ss, ss.sector.ceilingheight, ss.sector.ceilingpic)
      end if
    end if
    i = i + 1
  end while
end function

/*
* Function: RGL_DrawVolatileWalls
* Purpose: Draws only opaque wall pieces that touch dynamic sector geometry.
*/
function RGL_DrawVolatileWalls()
  if not RGL_IsSeq(rgl_volatile_segs) or not RGL_IsSeq(segs) then return end if
  i = 0
  while i < len(rgl_volatile_segs)
    idx = rgl_volatile_segs[i]
    if typeof(idx) == "int" and idx >= 0 and idx < len(segs) then RGL_DrawSeg(segs[idx]) end if
    i = i + 1
  end while
end function

/*
* Function: RGL_DrawVolatileMaskedWalls
* Purpose: Draws only masked wall pieces that touch dynamic sector geometry.
*/
function RGL_DrawVolatileMaskedWalls()
  if not RGL_IsSeq(rgl_volatile_segs) or not RGL_IsSeq(segs) then return end if
  glEnable(GL_TEXTURE_2D)
  glColor4ub(255, 255, 255, 255)
  i = 0
  while i < len(rgl_volatile_segs)
    idx = rgl_volatile_segs[i]
    if typeof(idx) == "int" and idx >= 0 and idx < len(segs) then RGL_DrawMaskedSeg(segs[idx]) end if
    i = i + 1
  end while
end function

/*
* Function: RGL_DrawVolatileLineMidtextures
* Purpose: Draws dynamic line midtextures when no seg list is available.
*/
function RGL_DrawVolatileLineMidtextures()
  if RGL_IsSeq(segs) and len(segs) > 0 then return end if
  if not RGL_IsSeq(rgl_volatile_lines) or not RGL_IsSeq(lines) then return end if
  glEnable(GL_TEXTURE_2D)
  i = 0
  while i < len(rgl_volatile_lines)
    idx = rgl_volatile_lines[i]
    if typeof(idx) == "int" and idx >= 0 and idx < len(lines) then
      li = lines[idx]
      if li is not void and li.frontsector is not void and li.backsector is not void then
        RGL_DrawLineSideMidtexture(li, 0)
        RGL_DrawLineSideMidtexture(li, 1)
      end if
    end if
    i = i + 1
  end while
end function

/*
* Function: RGL_DrawVolatileOpaqueWorld
* Purpose: Updates dynamic sector flats and opaque walls on top of the static cache.
*/
function RGL_DrawVolatileOpaqueWorld()
  RGL_DrawVolatileFlats()
  RGL_DrawVolatileWalls()
end function

/*
* Function: RGL_DrawVolatileMaskedWorld
* Purpose: Updates dynamic masked geometry on top of the static cache.
*/
function RGL_DrawVolatileMaskedWorld()
  RGL_DrawVolatileMaskedWalls()
  RGL_DrawVolatileLineMidtextures()
end function

/*
* Function: RGL_ProfileStart
* Purpose: Returns a timestamp for fine-grained renderer profiling.
*/
function inline RGL_ProfileStart()
  if typeof(_D_TimeMs) == "function" then return _D_TimeMs() end if
  return 0
end function

/*
* Function: RGL_ProfileEnd
* Purpose: Adds elapsed time to one fine-grained renderer profiling slot.
*/
function inline RGL_ProfileEnd(slot, start)
  if typeof(_D_ProfileGLAdd) == "function" and typeof(_D_TimeMs) == "function" then
    _D_ProfileGLAdd(slot, _D_TimeMs() - start)
  end if
end function

/*
* Function: RGL_RenderPlayerView
* Purpose: Draws render Player View output for the OpenGL renderer renderer.
*/
function RGL_RenderPlayerView(player)
  global rgl_view_x
  global rgl_view_y
  global rgl_view_yaw
  global viewx
  global viewy
  global viewz
  global viewangle

  if rgl_force_software then return false end if
  if not IGL_IsActive() then return false end if
  if player is void or player.mo is void then return false end if
  if not IGL_Begin3D() then return false end if
  RGL_SyncPaletteRevision()

  px = RGL_FixedToFloat(player.mo.x)
  py = -RGL_FixedToFloat(player.mo.y)
  pz = RGL_FixedToFloat(player.viewz)
  yaw = RGL_AngleToDegrees(player.mo.angle)
  if typeof(viewx) == "int" then px = RGL_FixedToFloat(viewx) end if
  if typeof(viewy) == "int" then py = -RGL_FixedToFloat(viewy) end if
  if typeof(viewz) == "int" then pz = RGL_FixedToFloat(viewz) end if
  if typeof(viewangle) == "int" then yaw = RGL_AngleToDegrees(viewangle) end if
  if RGL_CAMERA_BACK_OFFSET != 0.0 then
    yawRad = (yaw / 360.0) * 6.283185314
    px = px - std.math.cos(yawRad) * RGL_CAMERA_BACK_OFFSET
    py = py - std.math.sin(yawRad) * RGL_CAMERA_BACK_OFFSET
  end if
  rgl_view_x = px
  rgl_view_y = -py
  rgl_view_yaw = yaw
  pt = RGL_ProfileStart()
  RGL_BuildDynamicLights(player)
  RGL_ProfileEnd(0, pt)

  pt = RGL_ProfileStart()
  useCache = RGL_EnsureGeometryCache()
  RGL_ProfileEnd(1, pt)
  pt = RGL_ProfileStart()
  RGL_DrawSky(yaw)
  RGL_ProfileEnd(2, pt)
  glColorMask(true, true, true, true)
  glDepthMask(true)
  RGL_DisableCutoutAlpha()
  glColor4ub(255, 255, 255, 255)
  glRotated(90.0 - yaw, 0.0, 1.0, 0.0)
  glTranslated(-px, -pz, -py)

  if useCache then
    pt = RGL_ProfileStart()
    RGL_DrawCachedTexturedQuads(rgl_boundary_quads)
    RGL_ProfileEnd(3, pt)
    pt = RGL_ProfileStart()
    RGL_DrawCachedDepthGeometry()
    RGL_ProfileEnd(4, pt)
    pt = RGL_ProfileStart()
    RGL_DrawCachedFlatTris()
    RGL_DrawVolatileFlats()
    RGL_ProfileEnd(5, pt)
    pt = RGL_ProfileStart()
    RGL_DrawCachedTexturedQuads(rgl_wall_quads)
    RGL_DrawVolatileWalls()
    RGL_ProfileEnd(6, pt)
    pt = RGL_ProfileStart()
    RGL_DrawSpriteBillboards(player, yaw)
    RGL_ProfileEnd(7, pt)
    pt = RGL_ProfileStart()
    RGL_DrawCachedTexturedQuads(rgl_masked_quads)
    RGL_DrawVolatileMaskedWorld()
    RGL_ProfileEnd(8, pt)
  else
    pt = RGL_ProfileStart()
    RGL_DrawSkyInteriorBoundaries()
    RGL_DrawSkyInteriorBoundaryLines()
    RGL_DrawSkyPortals()
    RGL_ProfileEnd(3, pt)
    pt = RGL_ProfileStart()
    RGL_DrawAllBspFlats()
    RGL_ProfileEnd(5, pt)
    pt = RGL_ProfileStart()
    RGL_DrawAllWalls()
    RGL_ProfileEnd(6, pt)
    pt = RGL_ProfileStart()
    RGL_DrawSpriteBillboards(player, yaw)
    RGL_ProfileEnd(7, pt)
    pt = RGL_ProfileStart()
    RGL_DrawAllMaskedWalls()
    RGL_DrawAllLineMidtextures()
    RGL_ProfileEnd(8, pt)
  end if
  pt = RGL_ProfileStart()
  RGL_DrawPlayerWeapon2D(player)
  RGL_ProfileEnd(9, pt)
  if typeof(IGL_MarkFrameReady) == "function" then IGL_MarkFrameReady() end if
  return true
end function
