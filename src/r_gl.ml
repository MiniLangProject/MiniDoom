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

//! Renders Doom maps as cached OpenGL wall/flat geometry with dynamic sectors, masked surfaces, sprites, skies,
//! and lights.

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
import std.time

/// Defines rgl angle full for the r gl subsystem.
const RGL_ANGLE_FULL = 4294967296.0
/// Defines rgl ff framemask for the r gl subsystem.
const RGL_FF_FRAMEMASK = 0x7fff
/// Defines rgl world sprite foot lift for the r gl subsystem.
const RGL_WORLD_SPRITE_FOOT_LIFT = 4.0
// Keeps MAP32's roughly 7000-unit sightlines inside both the GL frustum and sprite culler with safe margin.
/// Defines rgl world view distance for the r gl subsystem.
const RGL_WORLD_VIEW_DISTANCE = 12288.0
/// Defines rgl baseycenter for the r gl subsystem.
const RGL_BASEYCENTER = 100
/// Defines rgl dynamic settle frames for the r gl subsystem.
const RGL_DYNAMIC_SETTLE_FRAMES = 3
/// Defines rgl geom fix scale for the r gl subsystem.
const RGL_GEOM_FIX_SCALE = 65536.0
/// Defines rgl geom version for the r gl subsystem.
const RGL_GEOM_VERSION = 9
/// Defines rgl camera back offset for the r gl subsystem.
const RGL_CAMERA_BACK_OFFSET = 0.0

/// Stores the rgl tex keys collection used by the r gl subsystem.
rgl_tex_keys =[]
/// Stores the rgl tex ids collection used by the r gl subsystem.
rgl_tex_ids =[]
/// Stores the rgl texnum tex ids collection used by the r gl subsystem.
rgl_texnum_tex_ids =[]
/// Stores the rgl texnum trans tex ids collection used by the r gl subsystem.
rgl_texnum_trans_tex_ids =[]
/// Stores the rgl flat tex ids collection used by the r gl subsystem.
rgl_flat_tex_ids =[]
/// Stores the rgl sprite tex ids collection used by the r gl subsystem.
rgl_sprite_tex_ids =[]
/// Stores the rgl sprite fuzz tex ids collection used by the r gl subsystem.
rgl_sprite_fuzz_tex_ids =[]
/// Tracks the mutable rgl palette revision seen value used by the r gl subsystem.
rgl_palette_revision_seen = -1
/// Tracks the mutable rgl view x value used by the r gl subsystem.
rgl_view_x = 0.0
/// Tracks the mutable rgl view y value used by the r gl subsystem.
rgl_view_y = 0.0
/// Tracks the mutable rgl view yaw value used by the r gl subsystem.
rgl_view_yaw = 0.0
/// Tracks whether rgl building cache is active in the r gl subsystem.
rgl_building_cache = false
/// Tracks whether rgl collecting volatile geometry is active in the r gl subsystem.
rgl_collecting_volatile_geometry = false
/// Tracks whether rgl flat volatile only is active in the r gl subsystem.
rgl_flat_volatile_only = false
/// Tracks the mutable rgl cache target value used by the r gl subsystem.
rgl_cache_target = 0
/// Tracks the mutable rgl current light value used by the r gl subsystem.
rgl_current_light = 255
/// Tracks whether rgl force software is active in the r gl subsystem.
rgl_force_software = false
/// Tracks whether rgl geom ready is active in the r gl subsystem.
rgl_geom_ready = false
/// Tracks the mutable rgl geom sig map value used by the r gl subsystem.
rgl_geom_sig_map = -1
/// Tracks the mutable rgl geom sig segs value used by the r gl subsystem.
rgl_geom_sig_segs = -1
/// Tracks the mutable rgl geom sig lines value used by the r gl subsystem.
rgl_geom_sig_lines = -1
/// Tracks the mutable rgl geom sig nodes value used by the r gl subsystem.
rgl_geom_sig_nodes = -1
/// Tracks the mutable rgl geom sig subsectors value used by the r gl subsystem.
rgl_geom_sig_subsectors = -1
/// Tracks the mutable rgl geom sig sector motion value used by the r gl subsystem.
rgl_geom_sig_sector_motion = -1
/// Tracks the mutable rgl geom sig sides value used by the r gl subsystem.
rgl_geom_sig_sides = -1
/// Tracks the mutable rgl pending sig sector motion value used by the r gl subsystem.
rgl_pending_sig_sector_motion = -1
/// Tracks the mutable rgl pending sig sides value used by the r gl subsystem.
rgl_pending_sig_sides = -1
/// Tracks the mutable rgl pending stable frames value used by the r gl subsystem.
rgl_pending_stable_frames = 0
/// Tracks the mutable rgl side sig map value used by the r gl subsystem.
rgl_side_sig_map = -1
/// Tracks the mutable rgl side sig gametic value used by the r gl subsystem.
rgl_side_sig_gametic = -1
/// Tracks the mutable rgl side sig leveltime value used by the r gl subsystem.
rgl_side_sig_leveltime = -1
/// Tracks the mutable rgl side sig value value used by the r gl subsystem.
rgl_side_sig_value = -1
/// Tracks the mutable rgl volatile sig map value used by the r gl subsystem.
rgl_volatile_sig_map = -1
/// Stores the rgl volatile sectors collection used by the r gl subsystem.
rgl_volatile_sectors =[]
/// Stores the rgl volatile subsectors collection used by the r gl subsystem.
rgl_volatile_subsectors =[]
/// Stores the rgl volatile segs collection used by the r gl subsystem.
rgl_volatile_segs =[]
/// Stores the rgl volatile lines collection used by the r gl subsystem.
rgl_volatile_lines =[]
/// Stores the rgl scrolling segs collection used by the r gl subsystem.
rgl_scrolling_segs =[]
/// Stores the rgl scrolling lines collection used by the r gl subsystem.
rgl_scrolling_lines =[]
/// Stores the rgl scrolling sides collection used by the r gl subsystem.
rgl_scrolling_sides =[]
/// Tracks whether rgl collecting scrolling geometry is active in the r gl subsystem.
rgl_collecting_scrolling_geometry = false
/// Stores the rgl scrolling wall array batches collection used by the r gl subsystem.
rgl_scrolling_wall_array_batches =[]
/// Stores the rgl scrolling masked array batches collection used by the r gl subsystem.
rgl_scrolling_masked_array_batches =[]
/// Tracks the mutable rgl scrolling wall native records value used by the r gl subsystem.
rgl_scrolling_wall_native_records = bytes(0, 0)
/// Tracks the mutable rgl scrolling masked native records value used by the r gl subsystem.
rgl_scrolling_masked_native_records = bytes(0, 0)
/// Tracks the mutable rgl scrolling wall native record count value used by the r gl subsystem.
rgl_scrolling_wall_native_record_count = 0
/// Tracks the mutable rgl scrolling masked native record count value used by the r gl subsystem.
rgl_scrolling_masked_native_record_count = 0
/// Tracks the mutable rgl scrolling wall texture revision value used by the r gl subsystem.
rgl_scrolling_wall_texture_revision = -1
/// Tracks the mutable rgl scrolling masked texture revision value used by the r gl subsystem.
rgl_scrolling_masked_texture_revision = -1
/// Tracks the mutable rgl scrolling geometry last gametic value used by the r gl subsystem.
rgl_scrolling_geometry_last_gametic = -1
/// Tracks the mutable rgl scrolling geometry last map value used by the r gl subsystem.
rgl_scrolling_geometry_last_map = -1
/// Tracks the mutable rgl scrolling geometry last leveltime value used by the r gl subsystem.
rgl_scrolling_geometry_last_leveltime = -1
/// Tracks whether rgl scrolling array batches ready is active in the r gl subsystem.
rgl_scrolling_array_batches_ready = false
/// Stores the rgl volatile flat templates collection used by the r gl subsystem.
rgl_volatile_flat_templates =[]
/// Tracks whether rgl collecting volatile flats is active in the r gl subsystem.
rgl_collecting_volatile_flats = false
/// Stores the rgl boundary quads collection used by the r gl subsystem.
rgl_boundary_quads =[]
/// Stores the rgl wall quads collection used by the r gl subsystem.
rgl_wall_quads =[]
/// Stores the rgl masked quads collection used by the r gl subsystem.
rgl_masked_quads =[]
/// Stores the rgl flat tris collection used by the r gl subsystem.
rgl_flat_tris =[]
/// Stores the rgl depth tris collection used by the r gl subsystem.
rgl_depth_tris =[]
/// Stores the rgl depth quads collection used by the r gl subsystem.
rgl_depth_quads =[]
/// Stores the rgl wall display list texnums collection used by the r gl subsystem.
rgl_wall_display_list_texnums =[]
/// Stores the rgl wall display list transparents collection used by the r gl subsystem.
rgl_wall_display_list_transparents =[]
/// Stores the rgl wall display list ids collection used by the r gl subsystem.
rgl_wall_display_list_ids =[]
/// Stores the rgl flat display list flatnums collection used by the r gl subsystem.
rgl_flat_display_list_flatnums =[]
/// Stores the rgl flat display list ids collection used by the r gl subsystem.
rgl_flat_display_list_ids =[]
/// Tracks the mutable rgl boundary display list id value used by the r gl subsystem.
rgl_boundary_display_list_id = 0
/// Tracks the mutable rgl masked display list id value used by the r gl subsystem.
rgl_masked_display_list_id = 0
/// Tracks the mutable rgl static world display list id value used by the r gl subsystem.
rgl_static_world_display_list_id = 0
/// Tracks whether rgl static display lists ready is active in the r gl subsystem.
rgl_static_display_lists_ready = false
/// Stores the rgl wall array batches collection used by the r gl subsystem.
rgl_wall_array_batches =[]
/// Stores the rgl flat array batches collection used by the r gl subsystem.
rgl_flat_array_batches =[]
/// Stores the rgl masked array batches collection used by the r gl subsystem.
rgl_masked_array_batches =[]
/// Tracks whether rgl static array batches ready is active in the r gl subsystem.
rgl_static_array_batches_ready = false
/// Stores the rgl volatile wall array batches collection used by the r gl subsystem.
rgl_volatile_wall_array_batches =[]
/// Stores the rgl volatile flat array batches collection used by the r gl subsystem.
rgl_volatile_flat_array_batches =[]
/// Stores the rgl volatile masked array batches collection used by the r gl subsystem.
rgl_volatile_masked_array_batches =[]
/// Tracks the mutable rgl volatile wall native records value used by the r gl subsystem.
rgl_volatile_wall_native_records = bytes(0, 0)
/// Tracks the mutable rgl volatile flat native records value used by the r gl subsystem.
rgl_volatile_flat_native_records = bytes(0, 0)
/// Tracks the mutable rgl volatile masked native records value used by the r gl subsystem.
rgl_volatile_masked_native_records = bytes(0, 0)
/// Tracks the mutable rgl volatile wall native record count value used by the r gl subsystem.
rgl_volatile_wall_native_record_count = 0
/// Tracks the mutable rgl volatile flat native record count value used by the r gl subsystem.
rgl_volatile_flat_native_record_count = 0
/// Tracks the mutable rgl volatile masked native record count value used by the r gl subsystem.
rgl_volatile_masked_native_record_count = 0
/// Tracks the mutable rgl volatile wall texture revision value used by the r gl subsystem.
rgl_volatile_wall_texture_revision = -1
/// Tracks the mutable rgl volatile flat texture revision value used by the r gl subsystem.
rgl_volatile_flat_texture_revision = -1
/// Tracks the mutable rgl volatile masked texture revision value used by the r gl subsystem.
rgl_volatile_masked_texture_revision = -1
/// Tracks whether rgl volatile array batches ready is active in the r gl subsystem.
rgl_volatile_array_batches_ready = false
/// Tracks the mutable rgl volatile geometry signature value used by the r gl subsystem.
rgl_volatile_geometry_signature = -1
/// Tracks the mutable rgl volatile geometry last gametic value used by the r gl subsystem.
rgl_volatile_geometry_last_gametic = -1
/// Tracks the mutable rgl volatile geometry last leveltime value used by the r gl subsystem.
rgl_volatile_geometry_last_leveltime = -1
/// Tracks the mutable rgl volatile pending signature value used by the r gl subsystem.
rgl_volatile_pending_signature = -1
/// Tracks the mutable rgl volatile pending stable tics value used by the r gl subsystem.
rgl_volatile_pending_stable_tics = 0
/// Tracks whether rgl volatile immediate active is active in the r gl subsystem.
rgl_volatile_immediate_active = false
/// Tracks the mutable rgl wall native records value used by the r gl subsystem.
rgl_wall_native_records = bytes(0, 0)
/// Tracks the mutable rgl flat native records value used by the r gl subsystem.
rgl_flat_native_records = bytes(0, 0)
/// Tracks the mutable rgl masked native records value used by the r gl subsystem.
rgl_masked_native_records = bytes(0, 0)
/// Tracks the mutable rgl wall native record count value used by the r gl subsystem.
rgl_wall_native_record_count = 0
/// Tracks the mutable rgl flat native record count value used by the r gl subsystem.
rgl_flat_native_record_count = 0
/// Tracks the mutable rgl masked native record count value used by the r gl subsystem.
rgl_masked_native_record_count = 0
/// Tracks the mutable rgl wall native texture revision value used by the r gl subsystem.
rgl_wall_native_texture_revision = -1
/// Tracks the mutable rgl flat native texture revision value used by the r gl subsystem.
rgl_flat_native_texture_revision = -1
/// Tracks the mutable rgl masked native texture revision value used by the r gl subsystem.
rgl_masked_native_texture_revision = -1
/// Tracks the mutable rgl light geom blob value used by the r gl subsystem.
rgl_light_geom_blob = bytes(0, 0)
/// Stores the rgl dyn light x collection used by the r gl subsystem.
rgl_dyn_light_x =[]
/// Stores the rgl dyn light y collection used by the r gl subsystem.
rgl_dyn_light_y =[]
/// Stores the rgl dyn light z collection used by the r gl subsystem.
rgl_dyn_light_z =[]
/// Stores the rgl dyn light r collection used by the r gl subsystem.
rgl_dyn_light_r =[]
/// Stores the rgl dyn light g collection used by the r gl subsystem.
rgl_dyn_light_g =[]
/// Stores the rgl dyn light b collection used by the r gl subsystem.
rgl_dyn_light_b =[]
/// Stores the rgl dyn light radius collection used by the r gl subsystem.
rgl_dyn_light_radius =[]
/// Stores the rgl dyn light strength collection used by the r gl subsystem.
rgl_dyn_light_strength =[]
/// Tracks the mutable rgl dyn light count value used by the r gl subsystem.
rgl_dyn_light_count = 0
/// Tracks the mutable rgl dyn light last gametic value used by the r gl subsystem.
rgl_dyn_light_last_gametic = -1
/// Tracks the mutable rgl dyn light last map value used by the r gl subsystem.
rgl_dyn_light_last_map = -1
/// Tracks the mutable rgl dyn light last leveltime value used by the r gl subsystem.
rgl_dyn_light_last_leveltime = -1
/// Tracks the mutable rgl dyn light revision value used by the r gl subsystem.
rgl_dyn_light_revision = 0
/// Stores the rgl frame mobjs collection used by the r gl subsystem.
rgl_frame_mobjs =[]
/// Tracks the mutable rgl frame mobj count value used by the r gl subsystem.
rgl_frame_mobj_count = 0
/// Tracks the mutable rgl sprite light records value used by the r gl subsystem.
rgl_sprite_light_records = bytes(0, 0)
/// Tracks the mutable rgl sprite light revision value used by the r gl subsystem.
rgl_sprite_light_revision = -1
/// Stores the rgl sprite width cache collection used by the r gl subsystem.
rgl_sprite_width_cache =[]
/// Stores the rgl sprite height cache collection used by the r gl subsystem.
rgl_sprite_height_cache =[]
/// Stores the rgl sprite yoffset cache collection used by the r gl subsystem.
rgl_sprite_yoffset_cache =[]
/// Tracks the mutable rgl sprite native records value used by the r gl subsystem.
rgl_sprite_native_records = bytes(0, 0)
/// Defines the maximum rgl max dynamic lights accepted by the r gl subsystem.
const RGL_MAX_DYNAMIC_LIGHTS = 48

/// Defines rgl cache boundary for the r gl subsystem.
const RGL_CACHE_BOUNDARY = 1
/// Defines rgl cache wall for the r gl subsystem.
const RGL_CACHE_WALL = 2
/// Defines rgl cache masked for the r gl subsystem.
const RGL_CACHE_MASKED = 3
/// Defines rgl wall array batch quads for the r gl subsystem.
const RGL_WALL_ARRAY_BATCH_QUADS = 4096
/// Defines rgl flat array batch tris for the r gl subsystem.
const RGL_FLAT_ARRAY_BATCH_TRIS = 8192
/// Defines rgl spatial batch cell for the r gl subsystem.
const RGL_SPATIAL_BATCH_CELL = 1024.0
/// Defines rgl flat spatial batch cell for the r gl subsystem.
const RGL_FLAT_SPATIAL_BATCH_CELL = 4096.0
/// Defines rgl spatial batch origin for the r gl subsystem.
const RGL_SPATIAL_BATCH_ORIGIN = 32768.0
/// Defines rgl spatial batch stride for the r gl subsystem.
const RGL_SPATIAL_BATCH_STRIDE = 128
/// Defines rgl native batch record size for the r gl subsystem.
const RGL_NATIVE_BATCH_RECORD_SIZE = 28
/// Defines rgl light record size for the r gl subsystem.
const RGL_LIGHT_RECORD_SIZE = 32
/// Defines rgl sprite record size for the r gl subsystem.
const RGL_SPRITE_RECORD_SIZE = 36
/// Defines the maximum rgl max surface lights accepted by the r gl subsystem.
const RGL_MAX_SURFACE_LIGHTS = 24

/// Stores one textured wall/boundary quad with texture mode, static light, positions, and UVs for four
/// vertices.
struct rgl_quad_t
  /// Stores texnum for `rgl_quad_t`
  texnum
  /// Stores transparent for `rgl_quad_t`
  transparent
  /// Stores light for `rgl_quad_t`
  light
  /// Stores x0 for `rgl_quad_t`
  x0
  /// Stores y0 for `rgl_quad_t`
  y0
  /// Stores z0 for `rgl_quad_t`
  z0
  /// Stores s0 for `rgl_quad_t`
  s0
  /// Stores t0 for `rgl_quad_t`
  t0
  /// Stores x1 for `rgl_quad_t`
  x1
  /// Stores y1 for `rgl_quad_t`
  y1
  /// Stores z1 for `rgl_quad_t`
  z1
  /// Stores s1 for `rgl_quad_t`
  s1
  /// Stores t1 for `rgl_quad_t`
  t1
  /// Stores x2 for `rgl_quad_t`
  x2
  /// Stores y2 for `rgl_quad_t`
  y2
  /// Stores z2 for `rgl_quad_t`
  z2
  /// Stores s2 for `rgl_quad_t`
  s2
  /// Stores t2 for `rgl_quad_t`
  t2
  /// Stores x3 for `rgl_quad_t`
  x3
  /// Stores y3 for `rgl_quad_t`
  y3
  /// Stores z3 for `rgl_quad_t`
  z3
  /// Stores s3 for `rgl_quad_t`
  s3
  /// Stores t3 for `rgl_quad_t`
  t3
end struct

/// Stores one floor/ceiling triangle with its flat id, sector light, positions, and UVs.
struct rgl_flat_tri_t
  /// Stores flatnum for `rgl_flat_tri_t`
  flatnum
  /// Stores light for `rgl_flat_tri_t`
  light
  /// Stores x0 for `rgl_flat_tri_t`
  x0
  /// Stores y0 for `rgl_flat_tri_t`
  y0
  /// Stores z0 for `rgl_flat_tri_t`
  z0
  /// Stores s0 for `rgl_flat_tri_t`
  s0
  /// Stores t0 for `rgl_flat_tri_t`
  t0
  /// Stores x1 for `rgl_flat_tri_t`
  x1
  /// Stores y1 for `rgl_flat_tri_t`
  y1
  /// Stores z1 for `rgl_flat_tri_t`
  z1
  /// Stores s1 for `rgl_flat_tri_t`
  s1
  /// Stores t1 for `rgl_flat_tri_t`
  t1
  /// Stores x2 for `rgl_flat_tri_t`
  x2
  /// Stores y2 for `rgl_flat_tri_t`
  y2
  /// Stores z2 for `rgl_flat_tri_t`
  z2
  /// Stores s2 for `rgl_flat_tri_t`
  s2
  /// Stores t2 for `rgl_flat_tri_t`
  t2
end struct

/// Stores a preclipped BSP leaf polygon for dynamic-sector flats.
struct rgl_volatile_flat_template_t
  /// Stores subsector for `rgl_volatile_flat_template_t`
  subsector
  /// Number of associated items stored by `rgl_volatile_flat_template_t`
  count
  /// Stores xs for `rgl_volatile_flat_template_t`
  xs
  /// Stores ys for `rgl_volatile_flat_template_t`
  ys
end struct

/// Stores prepacked OpenGL client-array data for one static texture batch.
struct rgl_array_batch_t
  /// Stores texnum for `rgl_array_batch_t`
  texnum
  /// Stores transparent for `rgl_array_batch_t`
  transparent
  /// Stores vertex count for `rgl_array_batch_t`
  vertex_count
  /// Stores vertices for `rgl_array_batch_t`
  vertices
  /// Stores texcoords for `rgl_array_batch_t`
  texcoords
  /// Stores colors for `rgl_array_batch_t`
  colors
  /// Stores cx for `rgl_array_batch_t`
  cx
  /// Stores cz for `rgl_array_batch_t`
  cz
  /// Stores radius for `rgl_array_batch_t`
  radius
  /// Stores vertex vbo for `rgl_array_batch_t`
  vertex_vbo
  /// Stores texcoord vbo for `rgl_array_batch_t`
  texcoord_vbo
  /// Stores color vbo for `rgl_array_batch_t`
  color_vbo
  /// Stores interleaved for `rgl_array_batch_t`
  interleaved
  /// Stores interleaved vbo for `rgl_array_batch_t`
  interleaved_vbo
end struct

/// Stores an untextured triangle written only to the depth buffer for sky-portal occlusion.
struct rgl_depth_tri_t
  /// Stores x0 for `rgl_depth_tri_t`
  x0
  /// Stores y0 for `rgl_depth_tri_t`
  y0
  /// Stores z0 for `rgl_depth_tri_t`
  z0
  /// Stores x1 for `rgl_depth_tri_t`
  x1
  /// Stores y1 for `rgl_depth_tri_t`
  y1
  /// Stores z1 for `rgl_depth_tri_t`
  z1
  /// Stores x2 for `rgl_depth_tri_t`
  x2
  /// Stores y2 for `rgl_depth_tri_t`
  y2
  /// Stores z2 for `rgl_depth_tri_t`
  z2
end struct

/// Stores an untextured quad written only to the depth buffer for sky-portal occlusion.
struct rgl_depth_quad_t
  /// Stores x0 for `rgl_depth_quad_t`
  x0
  /// Stores y0 for `rgl_depth_quad_t`
  y0
  /// Stores z0 for `rgl_depth_quad_t`
  z0
  /// Stores x1 for `rgl_depth_quad_t`
  x1
  /// Stores y1 for `rgl_depth_quad_t`
  y1
  /// Stores z1 for `rgl_depth_quad_t`
  z1
  /// Stores x2 for `rgl_depth_quad_t`
  x2
  /// Stores y2 for `rgl_depth_quad_t`
  y2
  /// Stores z2 for `rgl_depth_quad_t`
  z2
  /// Stores x3 for `rgl_depth_quad_t`
  x3
  /// Stores y3 for `rgl_depth_quad_t`
  y3
  /// Stores z3 for `rgl_depth_quad_t`
  z3
end struct

/// Enables or clears the explicit software-renderer override from a validated boolean input.
/// @param v Value consumed by the operation.
function RGL_SetForceSoftware(v)
  global rgl_force_software

  rgl_force_software = false
  if typeof(v) == "bool" and v then rgl_force_software = true end if
end function

/// Recognizes the array and list containers accepted by renderer geometry and map tables.
/// @param v Value consumed by the operation.
function inline RGL_IsSeq(v)
  return typeof(v) == "array" or typeof(v) == "list"
end function

/// Checks numeric values before packing cached OpenGL geometry.
/// @param v Value consumed by the operation.
function inline RGL_IsNumber(v)
  return typeof(v) == "int" or typeof(v) == "float"
end function

/// Rejects malformed cached flat triangles before array batching.
/// @param t T value supplied to `RGL_IsValidFlatTri`.
function inline RGL_IsValidFlatTri(t)
  if t is void then return false end if
  if typeof(t.flatnum) != "int" then return false end if
  if not RGL_IsNumber(t.light) then return false end if
  if not RGL_IsNumber(t.x0) or not RGL_IsNumber(t.y0) or not RGL_IsNumber(t.z0) then return false end if
  if not RGL_IsNumber(t.s0) or not RGL_IsNumber(t.t0) then return false end if
  if not RGL_IsNumber(t.x1) or not RGL_IsNumber(t.y1) or not RGL_IsNumber(t.z1) then return false end if
  if not RGL_IsNumber(t.s1) or not RGL_IsNumber(t.t1) then return false end if
  if not RGL_IsNumber(t.x2) or not RGL_IsNumber(t.y2) or not RGL_IsNumber(t.z2) then return false end if
  if not RGL_IsNumber(t.s2) or not RGL_IsNumber(t.t2) then return false end if
  return true
end function

/// Returns a supported sequence length or -1 so cache signatures can distinguish absent data.
/// @param v Value consumed by the operation.
function inline RGL_SeqLen(v)
  if RGL_IsSeq(v) then return len(v) end if
  return -1
end function

/// Maps a world-space point to a coarse static-geometry batch cell.
/// @param x Horizontal map- or screen-space coordinate.
/// @param z Vertical world-space coordinate.
function RGL_SpatialBatchCellKey(x, z)
  cx = std.math.floor((x + RGL_SPATIAL_BATCH_ORIGIN) / RGL_SPATIAL_BATCH_CELL)
  cz = std.math.floor((z + RGL_SPATIAL_BATCH_ORIGIN) / RGL_SPATIAL_BATCH_CELL)
  if cx < 0 then cx = 0 end if
  if cz < 0 then cz = 0 end if
  if cx >= RGL_SPATIAL_BATCH_STRIDE then cx = RGL_SPATIAL_BATCH_STRIDE - 1 end if
  if cz >= RGL_SPATIAL_BATCH_STRIDE then cz = RGL_SPATIAL_BATCH_STRIDE - 1 end if
  return cz * RGL_SPATIAL_BATCH_STRIDE + cx
end function

/// Maps flat geometry to coarser cells because flat rendering is draw-call bound.
/// @param x Horizontal map- or screen-space coordinate.
/// @param z Vertical world-space coordinate.
function RGL_FlatSpatialBatchCellKey(x, z)
  cx = std.math.floor((x + RGL_SPATIAL_BATCH_ORIGIN) / RGL_FLAT_SPATIAL_BATCH_CELL)
  cz = std.math.floor((z + RGL_SPATIAL_BATCH_ORIGIN) / RGL_FLAT_SPATIAL_BATCH_CELL)
  if cx < 0 then cx = 0 end if
  if cz < 0 then cz = 0 end if
  if cx >= RGL_SPATIAL_BATCH_STRIDE then cx = RGL_SPATIAL_BATCH_STRIDE - 1 end if
  if cz >= RGL_SPATIAL_BATCH_STRIDE then cz = RGL_SPATIAL_BATCH_STRIDE - 1 end if
  return cz * RGL_SPATIAL_BATCH_STRIDE + cx
end function

/// Builds a combined texture and spatial key for static wall batching.
/// @param q Q value supplied to `RGL_WallArrayBatchKey`.
function RGL_WallArrayBatchKey(q)
  cx = (q.x0 + q.x1 + q.x2 + q.x3) * 0.25
  cz = (q.z0 + q.z1 + q.z2 + q.z3) * 0.25
  texKey = q.texnum
  if q.transparent then texKey = texKey + 16384 end if
  return texKey * 20000 + RGL_SpatialBatchCellKey(cx, cz)
end function

/// Builds a combined texture and spatial key for static flat batching.
/// @param t T value supplied to `RGL_FlatArrayBatchKey`.
function RGL_FlatArrayBatchKey(t)
  cx = (t.x0 + t.x1 + t.x2) / 3.0
  cz = (t.z0 + t.z1 + t.z2) / 3.0
  return t.flatnum * 20000 + RGL_FlatSpatialBatchCellKey(cx, cz)
end function

/// Orders static batch groups by numeric key so texture binds stay clustered.
/// @param keys Keys value supplied to `RGL_SortBatchGroupsByKey`.
/// @param groups Groups value supplied to `RGL_SortBatchGroupsByKey`.
function RGL_SortBatchGroupsByKey(keys, groups)
  if not RGL_IsSeq(keys) or not RGL_IsSeq(groups) then return groups end if
  if len(keys) != len(groups) then return groups end if
  used = []
  i = 0
  while i < len(keys)
    used = used + [false]
    i = i + 1
  end while
  sorted = []
  outCount = 0
  while outCount < len(keys)
    best = -1
    bestKey = 2147483647
    i = 0
    while i < len(keys)
      if not used[i] and keys[i] < bestKey then
        best = i
        bestKey = keys[i]
      end if
      i = i + 1
    end while
    if best < 0 then break end if
    used[best] = true
    sorted = sorted + [groups[best]]
    outCount = outCount + 1
  end while
  return sorted
end function

/// Groups cached wall quads by texture and coarse spatial cell for fewer visible draw calls.
/// @param quads Quads value supplied to `RGL_GroupWallQuadsForArrayBatches`.
function RGL_GroupWallQuadsForArrayBatches(quads)
  if not RGL_IsSeq(quads) then return [] end if
  keys = []
  groups = []
  i = 0
  while i < len(quads)
    q = quads[i]
    if q is not void then
      key = RGL_WallArrayBatchKey(q)
      idx = -1
      j = 0
      while j < len(keys) and idx < 0
        if keys[j] == key then idx = j end if
        j = j + 1
      end while
      if idx < 0 then
        keys = keys + [key]
        groups = groups + [[q]]
      else
        groups[idx] = groups[idx] + [q]
      end if
    end if
    i = i + 1
  end while
  return RGL_SortBatchGroupsByKey(keys, groups)
end function

/// Groups cached flat triangles by texture and coarse spatial cell for fewer visible draw calls.
/// @param tris Tris value supplied to `RGL_GroupFlatTrisForArrayBatches`.
function RGL_GroupFlatTrisForArrayBatches(tris)
  if not RGL_IsSeq(tris) then return [] end if
  keys = []
  groups = []
  i = 0
  while i < len(tris)
    t = tris[i]
    if t is not void then
      key = RGL_FlatArrayBatchKey(t)
      idx = -1
      j = 0
      while j < len(keys) and idx < 0
        if keys[j] == key then idx = j end if
        j = j + 1
      end while
      if idx < 0 then
        keys = keys + [key]
        groups = groups + [[t]]
      else
        groups[idx] = groups[idx] + [t]
      end if
    end if
    i = i + 1
  end while
  return RGL_SortBatchGroupsByKey(keys, groups)
end function

/// Groups opaque cached quads by texture once so immediate-mode batches are larger.
/// @param quads Quads value supplied to `RGL_GroupCachedQuadsByTexture`.
function RGL_GroupCachedQuadsByTexture(quads)
  if not RGL_IsSeq(quads) or len(quads) < 2 then return quads end if
  keys =[]
  groups =[]
  i = 0
  while i < len(quads)
    q = quads[i]
    if q is not void then
      key = q.texnum
      if q.transparent then key = key + 1000000 end if
      idx = -1
      j = 0
      while j < len(keys) and idx < 0
        if keys[j] == key then idx = j end if
        j = j + 1
      end while
      if idx < 0 then
        keys = keys +[key]
        groups = groups +[[q]]
      else
        groups[idx] = groups[idx] +[q]
      end if
    end if
    i = i + 1
  end while

  grouped =[]
  i = 0
  while i < len(groups)
    g = groups[i]
    j = 0
    while j < len(g)
      grouped = grouped +[g[j]]
      j = j + 1
    end while
    i = i + 1
  end while
  return grouped
end function

/// Groups cached flat triangles by flat texture once so immediate-mode batches are larger.
/// @param tris Tris value supplied to `RGL_GroupCachedFlatTrisByTexture`.
function RGL_GroupCachedFlatTrisByTexture(tris)
  if not RGL_IsSeq(tris) or len(tris) < 2 then return tris end if
  keys =[]
  groups =[]
  i = 0
  while i < len(tris)
    t = tris[i]
    if t is not void then
      key = t.flatnum
      idx = -1
      j = 0
      while j < len(keys) and idx < 0
        if keys[j] == key then idx = j end if
        j = j + 1
      end while
      if idx < 0 then
        keys = keys +[key]
        groups = groups +[[t]]
      else
        groups[idx] = groups[idx] +[t]
      end if
    end if
    i = i + 1
  end while

  grouped =[]
  i = 0
  while i < len(groups)
    g = groups[i]
    j = 0
    while j < len(g)
      grouped = grouped +[g[j]]
      j = j + 1
    end while
    i = i + 1
  end while
  return grouped
end function

/// Prepares static opaque world lists for larger OpenGL immediate-mode batches.
function RGL_GroupOpaqueGeometryForBatches()
  global rgl_wall_quads
  global rgl_flat_tris

  rgl_wall_quads = RGL_GroupCachedQuadsByTexture(rgl_wall_quads)
  rgl_flat_tris = RGL_GroupCachedFlatTrisByTexture(rgl_flat_tris)
end function

/// Releases compiled OpenGL display lists for static wall and flat batches.
function RGL_DeleteStaticDisplayLists()
  global rgl_wall_display_list_texnums
  global rgl_wall_display_list_transparents
  global rgl_wall_display_list_ids
  global rgl_flat_display_list_flatnums
  global rgl_flat_display_list_ids
  global rgl_boundary_display_list_id
  global rgl_masked_display_list_id
  global rgl_static_world_display_list_id
  global rgl_static_display_lists_ready

  i = 0
  while i < len(rgl_wall_display_list_ids)
    id = rgl_wall_display_list_ids[i]
    if id != 0 then glDeleteLists(id, 1) end if
    i = i + 1
  end while
  i = 0
  while i < len(rgl_flat_display_list_ids)
    id = rgl_flat_display_list_ids[i]
    if id != 0 then glDeleteLists(id, 1) end if
    i = i + 1
  end while
  if rgl_boundary_display_list_id != 0 then glDeleteLists(rgl_boundary_display_list_id, 1) end if
  if rgl_masked_display_list_id != 0 then glDeleteLists(rgl_masked_display_list_id, 1) end if
  if rgl_static_world_display_list_id != 0 then glDeleteLists(rgl_static_world_display_list_id, 1) end if

  rgl_wall_display_list_texnums =[]
  rgl_wall_display_list_transparents =[]
  rgl_wall_display_list_ids =[]
  rgl_flat_display_list_flatnums =[]
  rgl_flat_display_list_ids =[]
  rgl_boundary_display_list_id = 0
  rgl_masked_display_list_id = 0
  rgl_static_world_display_list_id = 0
  rgl_static_display_lists_ready = false
end function

/// Invalidates compiled static geometry after map geometry changes.
function RGL_ResetStaticDisplayLists()
  RGL_DeleteStaticDisplayLists()
end function

/// Releases every VBO owned by an array-batch collection.
/// @param batches Batches value supplied to `RGL_DeleteArrayBatchBuffers`.
function RGL_DeleteArrayBatchBuffers(batches)
  if not RGL_IsSeq(batches) then return end if
  i = 0
  while i < len(batches)
    b = batches[i]
    if b is not void then
      if b.vertex_vbo != 0 then MGL_DeleteArrayBuffer(b.vertex_vbo) end if
      if b.texcoord_vbo != 0 then MGL_DeleteArrayBuffer(b.texcoord_vbo) end if
      if b.color_vbo != 0 then MGL_DeleteArrayBuffer(b.color_vbo) end if
      if b.interleaved_vbo != 0 then MGL_DeleteArrayBuffer(b.interleaved_vbo) end if
    end if
    i = i + 1
  end while
end function

/// Invalidates VBO batches generated from potentially moving sector geometry.
function RGL_ResetVolatileArrayBatches()
  global rgl_volatile_wall_array_batches
  global rgl_volatile_flat_array_batches
  global rgl_volatile_masked_array_batches
  global rgl_volatile_wall_native_records
  global rgl_volatile_flat_native_records
  global rgl_volatile_masked_native_records
  global rgl_volatile_wall_native_record_count
  global rgl_volatile_flat_native_record_count
  global rgl_volatile_masked_native_record_count
  global rgl_volatile_wall_texture_revision
  global rgl_volatile_flat_texture_revision
  global rgl_volatile_masked_texture_revision
  global rgl_volatile_array_batches_ready
  global rgl_volatile_geometry_signature
  global rgl_volatile_geometry_last_gametic
  global rgl_volatile_geometry_last_leveltime
  global rgl_volatile_pending_signature
  global rgl_volatile_pending_stable_tics
  global rgl_volatile_immediate_active

  RGL_DeleteArrayBatchBuffers(rgl_volatile_wall_array_batches)
  RGL_DeleteArrayBatchBuffers(rgl_volatile_flat_array_batches)
  RGL_DeleteArrayBatchBuffers(rgl_volatile_masked_array_batches)
  rgl_volatile_wall_array_batches =[]
  rgl_volatile_flat_array_batches =[]
  rgl_volatile_masked_array_batches =[]
  rgl_volatile_wall_native_records = bytes(0, 0)
  rgl_volatile_flat_native_records = bytes(0, 0)
  rgl_volatile_masked_native_records = bytes(0, 0)
  rgl_volatile_wall_native_record_count = 0
  rgl_volatile_flat_native_record_count = 0
  rgl_volatile_masked_native_record_count = 0
  rgl_volatile_wall_texture_revision = -1
  rgl_volatile_flat_texture_revision = -1
  rgl_volatile_masked_texture_revision = -1
  rgl_volatile_array_batches_ready = false
  rgl_volatile_geometry_signature = -1
  rgl_volatile_geometry_last_gametic = -1
  rgl_volatile_geometry_last_leveltime = -1
  rgl_volatile_pending_signature = -1
  rgl_volatile_pending_stable_tics = 0
  rgl_volatile_immediate_active = false
end function

/// Releases cached geometry for continuously scrolling walls.
function RGL_ResetScrollingArrayBatches()
  global rgl_scrolling_wall_array_batches
  global rgl_scrolling_masked_array_batches
  global rgl_scrolling_wall_native_records
  global rgl_scrolling_masked_native_records
  global rgl_scrolling_wall_native_record_count
  global rgl_scrolling_masked_native_record_count
  global rgl_scrolling_wall_texture_revision
  global rgl_scrolling_masked_texture_revision
  global rgl_scrolling_geometry_last_gametic
  global rgl_scrolling_geometry_last_map
  global rgl_scrolling_geometry_last_leveltime
  global rgl_scrolling_array_batches_ready

  RGL_DeleteArrayBatchBuffers(rgl_scrolling_wall_array_batches)
  RGL_DeleteArrayBatchBuffers(rgl_scrolling_masked_array_batches)
  rgl_scrolling_wall_array_batches =[]
  rgl_scrolling_masked_array_batches =[]
  rgl_scrolling_wall_native_records = bytes(0, 0)
  rgl_scrolling_masked_native_records = bytes(0, 0)
  rgl_scrolling_wall_native_record_count = 0
  rgl_scrolling_masked_native_record_count = 0
  rgl_scrolling_wall_texture_revision = -1
  rgl_scrolling_masked_texture_revision = -1
  rgl_scrolling_geometry_last_gametic = -1
  rgl_scrolling_geometry_last_map = -1
  rgl_scrolling_geometry_last_leveltime = -1
  rgl_scrolling_array_batches_ready = false
end function

/// Invalidates prepacked OpenGL client-array batches after geometry changes.
function RGL_ResetStaticArrayBatches()
  global rgl_wall_array_batches
  global rgl_flat_array_batches
  global rgl_masked_array_batches
  global rgl_static_array_batches_ready
  global rgl_wall_native_records
  global rgl_flat_native_records
  global rgl_masked_native_records
  global rgl_wall_native_record_count
  global rgl_flat_native_record_count
  global rgl_masked_native_record_count
  global rgl_wall_native_texture_revision
  global rgl_flat_native_texture_revision
  global rgl_masked_native_texture_revision

  if RGL_IsSeq(rgl_wall_array_batches) then
    i = 0
    while i < len(rgl_wall_array_batches)
      b = rgl_wall_array_batches[i]
      if b is not void then
        if b.vertex_vbo != 0 then MGL_DeleteArrayBuffer(b.vertex_vbo) end if
        if b.texcoord_vbo != 0 then MGL_DeleteArrayBuffer(b.texcoord_vbo) end if
        if b.color_vbo != 0 then MGL_DeleteArrayBuffer(b.color_vbo) end if
        if b.interleaved_vbo != 0 then MGL_DeleteArrayBuffer(b.interleaved_vbo) end if
      end if
      i = i + 1
    end while
  end if
  if RGL_IsSeq(rgl_flat_array_batches) then
    i = 0
    while i < len(rgl_flat_array_batches)
      b = rgl_flat_array_batches[i]
      if b is not void then
        if b.vertex_vbo != 0 then MGL_DeleteArrayBuffer(b.vertex_vbo) end if
        if b.texcoord_vbo != 0 then MGL_DeleteArrayBuffer(b.texcoord_vbo) end if
        if b.color_vbo != 0 then MGL_DeleteArrayBuffer(b.color_vbo) end if
        if b.interleaved_vbo != 0 then MGL_DeleteArrayBuffer(b.interleaved_vbo) end if
      end if
      i = i + 1
    end while
  end if
  if RGL_IsSeq(rgl_masked_array_batches) then
    RGL_DeleteArrayBatchBuffers(rgl_masked_array_batches)
  end if

  rgl_wall_array_batches =[]
  rgl_flat_array_batches =[]
  rgl_masked_array_batches =[]
  rgl_wall_native_records = bytes(0, 0)
  rgl_flat_native_records = bytes(0, 0)
  rgl_masked_native_records = bytes(0, 0)
  rgl_wall_native_record_count = 0
  rgl_flat_native_record_count = 0
  rgl_masked_native_record_count = 0
  rgl_wall_native_texture_revision = -1
  rgl_flat_native_texture_revision = -1
  rgl_masked_native_texture_revision = -1
  rgl_static_array_batches_ready = false
end function

/// Uploads static geometry bytes to a VBO when the helper and driver support it.
/// @param data Binary or structured data to process.
function RGL_CreateArrayBufferOrZero(data)
  if typeof(data) != "bytes" or len(data) <= 0 then return 0 end if
  if not MGL_InitVBO() then return 0 end if
  return MGL_CreateArrayBuffer(data, len(data))
end function

/// Uploads fixed-point interleaved geometry as a float VBO through the GL helper.
/// @param data Binary or structured data to process.
function RGL_CreateInterleavedGeomBufferOrZero(data)
  if typeof(data) != "bytes" or len(data) <= 0 then return 0 end if
  if not MGL_InitVBO() then return 0 end if
  return MGL_CreateInterleavedGeomBuffer(data, len(data))
end function

/// Writes one native helper draw record for a prepacked static geometry batch.
/// @param records Records value supplied to `RGL_WriteNativeBatchRecord`.
/// @param index Zero-based element or table index.
/// @param texid Texid value supplied to `RGL_WriteNativeBatchRecord`.
/// @param batch Batch value supplied to `RGL_WriteNativeBatchRecord`.
/// @param flags Bit flags that control the operation.
function RGL_WriteNativeBatchRecord(records, index, texid, batch, flags)
  off = index * RGL_NATIVE_BATCH_RECORD_SIZE
  RGL_WriteU32(records, off, texid)
  RGL_WriteU32(records, off + 4, batch.interleaved_vbo)
  RGL_WriteS32(records, off + 8, batch.vertex_count)
  RGL_WriteS32(records, off + 12, flags)
  RGL_WriteS32(records, off + 16, RGL_FloatToGeom(batch.cx))
  RGL_WriteS32(records, off + 20, RGL_FloatToGeom(batch.cz))
  RGL_WriteS32(records, off + 24, RGL_FloatToGeom(batch.radius))
end function

/// Refreshes wall native draw-record texture ids for animated texture translation.
function RGL_UpdateWallNativeRecordTextures()
  global rgl_wall_native_records
  global rgl_wall_native_texture_revision

  if typeof(rgl_wall_native_records) != "bytes" then return false end if
  if rgl_wall_native_record_count != len(rgl_wall_array_batches) then return false end if
  if len(rgl_wall_native_records) < len(rgl_wall_array_batches) * RGL_NATIVE_BATCH_RECORD_SIZE then return false end if
  revision = 0
  if typeof(p_picanim_revision) == "int" then revision = p_picanim_revision end if
  if rgl_wall_native_texture_revision == revision then return true end if
  i = 0
  while i < len(rgl_wall_array_batches)
    batch = rgl_wall_array_batches[i]
    texid = RGL_TextureIdForTexnum(batch.texnum)
    if batch.transparent then texid = RGL_TextureIdForTexnumTransparent(batch.texnum) end if
    RGL_WriteU32(rgl_wall_native_records, i * RGL_NATIVE_BATCH_RECORD_SIZE, texid)
    i = i + 1
  end while
  rgl_wall_native_texture_revision = revision
  return true
end function

/// Refreshes masked-wall texture ids while retaining spatially culled VBO records.
function RGL_UpdateMaskedNativeRecordTextures()
  global rgl_masked_native_records
  global rgl_masked_native_texture_revision

  if typeof(rgl_masked_native_records) != "bytes" then return false end if
  if rgl_masked_native_record_count != len(rgl_masked_array_batches) then return false end if
  if len(rgl_masked_native_records) < len(rgl_masked_array_batches) * RGL_NATIVE_BATCH_RECORD_SIZE then return false end if
  revision = 0
  if typeof(p_picanim_revision) == "int" then revision = p_picanim_revision end if
  if rgl_masked_native_texture_revision == revision then return true end if
  i = 0
  while i < len(rgl_masked_array_batches)
    batch = rgl_masked_array_batches[i]
    RGL_WriteU32(rgl_masked_native_records, i * RGL_NATIVE_BATCH_RECORD_SIZE, RGL_TextureIdForTexnumTransparent(batch.texnum))
    i = i + 1
  end while
  rgl_masked_native_texture_revision = revision
  return true
end function

/// Refreshes flat native draw-record texture ids for animated flat translation.
function RGL_UpdateFlatNativeRecordTextures()
  global rgl_flat_native_records
  global rgl_flat_native_texture_revision

  if typeof(rgl_flat_native_records) != "bytes" then return false end if
  if rgl_flat_native_record_count != len(rgl_flat_array_batches) then return false end if
  if len(rgl_flat_native_records) < len(rgl_flat_array_batches) * RGL_NATIVE_BATCH_RECORD_SIZE then return false end if
  revision = 0
  if typeof(p_picanim_revision) == "int" then revision = p_picanim_revision end if
  if rgl_flat_native_texture_revision == revision then return true end if
  i = 0
  while i < len(rgl_flat_array_batches)
    batch = rgl_flat_array_batches[i]
    texid = RGL_TextureIdForFlatnum(batch.texnum)
    RGL_WriteU32(rgl_flat_native_records, i * RGL_NATIVE_BATCH_RECORD_SIZE, texid)
    i = i + 1
  end while
  rgl_flat_native_texture_revision = revision
  return true
end function

/// Builds native helper draw-record buffers for VBO-backed static geometry batches.
function RGL_RebuildNativeArrayBatchRecords()
  global rgl_wall_native_records
  global rgl_flat_native_records
  global rgl_masked_native_records
  global rgl_wall_native_record_count
  global rgl_flat_native_record_count
  global rgl_masked_native_record_count
  global rgl_wall_native_texture_revision
  global rgl_flat_native_texture_revision
  global rgl_masked_native_texture_revision

  wallCount = 0
  i = 0
  while i < len(rgl_wall_array_batches)
    batch = rgl_wall_array_batches[i]
    if batch is not void and batch.interleaved_vbo != 0 then wallCount = wallCount + 1 end if
    i = i + 1
  end while
  rgl_wall_native_record_count = wallCount
  rgl_wall_native_records = bytes(wallCount * RGL_NATIVE_BATCH_RECORD_SIZE, 0)
  outIndex = 0
  i = 0
  while i < len(rgl_wall_array_batches)
    batch = rgl_wall_array_batches[i]
    if batch is not void and batch.interleaved_vbo != 0 then
      flags = 0
      if batch.transparent then flags = 1 end if
      texid = RGL_TextureIdForTexnum(batch.texnum)
      if batch.transparent then texid = RGL_TextureIdForTexnumTransparent(batch.texnum) end if
      RGL_WriteNativeBatchRecord(rgl_wall_native_records, outIndex, texid, batch, flags)
      outIndex = outIndex + 1
    end if
    i = i + 1
  end while

  flatCount = 0
  i = 0
  while i < len(rgl_flat_array_batches)
    batch = rgl_flat_array_batches[i]
    if batch is not void and batch.interleaved_vbo != 0 then flatCount = flatCount + 1 end if
    i = i + 1
  end while
  rgl_flat_native_record_count = flatCount
  rgl_flat_native_records = bytes(flatCount * RGL_NATIVE_BATCH_RECORD_SIZE, 0)
  outIndex = 0
  i = 0
  while i < len(rgl_flat_array_batches)
    batch = rgl_flat_array_batches[i]
    if batch is not void and batch.interleaved_vbo != 0 then
      RGL_WriteNativeBatchRecord(rgl_flat_native_records, outIndex, RGL_TextureIdForFlatnum(batch.texnum), batch, 0)
      outIndex = outIndex + 1
    end if
    i = i + 1
  end while

  maskedCount = 0
  i = 0
  while i < len(rgl_masked_array_batches)
    batch = rgl_masked_array_batches[i]
    if batch is not void and batch.interleaved_vbo != 0 then maskedCount = maskedCount + 1 end if
    i = i + 1
  end while
  rgl_masked_native_record_count = maskedCount
  rgl_masked_native_records = bytes(maskedCount * RGL_NATIVE_BATCH_RECORD_SIZE, 0)
  outIndex = 0
  i = 0
  while i < len(rgl_masked_array_batches)
    batch = rgl_masked_array_batches[i]
    if batch is not void and batch.interleaved_vbo != 0 then
      RGL_WriteNativeBatchRecord(rgl_masked_native_records, outIndex, RGL_TextureIdForTexnumTransparent(batch.texnum), batch, 1)
      outIndex = outIndex + 1
    end if
    i = i + 1
  end while
  rgl_wall_native_texture_revision = -1
  rgl_flat_native_texture_revision = -1
  rgl_masked_native_texture_revision = -1
end function

/// Appends one scaled vertex, texture coordinate, and static color to client-array buffers.
/// @param vertices Vertices value supplied to `RGL_WriteGeomArrayVertex`.
/// @param voff Voff value supplied to `RGL_WriteGeomArrayVertex`.
/// @param texcoords Texcoords value supplied to `RGL_WriteGeomArrayVertex`.
/// @param toff Toff value supplied to `RGL_WriteGeomArrayVertex`.
/// @param colors Colors value supplied to `RGL_WriteGeomArrayVertex`.
/// @param coff Coff value supplied to `RGL_WriteGeomArrayVertex`.
/// @param x Horizontal map- or screen-space coordinate.
/// @param y Vertical map- or screen-space coordinate.
/// @param z Vertical world-space coordinate.
/// @param s S value supplied to `RGL_WriteGeomArrayVertex`.
/// @param t T value supplied to `RGL_WriteGeomArrayVertex`.
/// @param light Light value supplied to `RGL_WriteGeomArrayVertex`.
function RGL_WriteGeomArrayVertex(vertices, voff, texcoords, toff, colors, coff, x, y, z, s, t, light)
  RGL_WriteS32(vertices, voff, RGL_FloatToGeom(x))
  RGL_WriteS32(vertices, voff + 4, RGL_FloatToGeom(y))
  RGL_WriteS32(vertices, voff + 8, RGL_FloatToGeom(z))
  RGL_WriteS32(texcoords, toff, RGL_FloatToGeom(s))
  RGL_WriteS32(texcoords, toff + 4, RGL_FloatToGeom(t))
  c = RGL_ClampByte(light)
  colors[coff] = c
  colors[coff + 1] = c
  colors[coff + 2] = c
  colors[coff + 3] = 255
end function

/// Appends one scaled vertex, texture coordinate, and static color to an interleaved VBO buffer.
/// @param buf Buf value supplied to `RGL_WriteGeomInterleavedVertex`.
/// @param off Zero-based byte or element offset.
/// @param x Horizontal map- or screen-space coordinate.
/// @param y Vertical map- or screen-space coordinate.
/// @param z Vertical world-space coordinate.
/// @param s S value supplied to `RGL_WriteGeomInterleavedVertex`.
/// @param t T value supplied to `RGL_WriteGeomInterleavedVertex`.
/// @param light Light value supplied to `RGL_WriteGeomInterleavedVertex`.
function RGL_WriteGeomInterleavedVertex(buf, off, x, y, z, s, t, light)
  RGL_WriteS32(buf, off, RGL_FloatToGeom(x))
  RGL_WriteS32(buf, off + 4, RGL_FloatToGeom(y))
  RGL_WriteS32(buf, off + 8, RGL_FloatToGeom(z))
  RGL_WriteS32(buf, off + 12, RGL_FloatToGeom(s))
  RGL_WriteS32(buf, off + 16, RGL_FloatToGeom(t))
  c = RGL_ClampByte(light)
  buf[off + 20] = c
  buf[off + 21] = c
  buf[off + 22] = c
  buf[off + 23] = 255
end function

/// Packs one contiguous cached wall quad range into OpenGL client arrays.
/// @param startIndex Index identifying start.
/// @param endIndex Index identifying end.
function RGL_BuildWallArrayBatchRange(startIndex, endIndex)
  qcount = endIndex - startIndex
  if qcount <= 0 then return end if
  vertexCount = qcount * 4
  vertices = bytes(vertexCount * 12, 0)
  texcoords = bytes(vertexCount * 8, 0)
  colors = bytes(vertexCount * 4, 0)
  interleaved = bytes(vertexCount * 24, 0)
  minx = 99999999.0
  maxx = -99999999.0
  minz = 99999999.0
  maxz = -99999999.0
  voff = 0
  toff = 0
  coff = 0
  ioff = 0
  i = startIndex
  while i < endIndex
    q = rgl_wall_quads[i]
    if q is not void then
      if q.x0 < minx then minx = q.x0 end if
      if q.x1 < minx then minx = q.x1 end if
      if q.x2 < minx then minx = q.x2 end if
      if q.x3 < minx then minx = q.x3 end if
      if q.x0 > maxx then maxx = q.x0 end if
      if q.x1 > maxx then maxx = q.x1 end if
      if q.x2 > maxx then maxx = q.x2 end if
      if q.x3 > maxx then maxx = q.x3 end if
      if q.z0 < minz then minz = q.z0 end if
      if q.z1 < minz then minz = q.z1 end if
      if q.z2 < minz then minz = q.z2 end if
      if q.z3 < minz then minz = q.z3 end if
      if q.z0 > maxz then maxz = q.z0 end if
      if q.z1 > maxz then maxz = q.z1 end if
      if q.z2 > maxz then maxz = q.z2 end if
      if q.z3 > maxz then maxz = q.z3 end if
      RGL_WriteGeomArrayVertex(vertices, voff, texcoords, toff, colors, coff, q.x0, q.y0, q.z0, q.s0, q.t0, q.light)
      RGL_WriteGeomInterleavedVertex(interleaved, ioff, q.x0, q.y0, q.z0, q.s0, q.t0, q.light)
      voff = voff + 12
      toff = toff + 8
      coff = coff + 4
      ioff = ioff + 24
      RGL_WriteGeomArrayVertex(vertices, voff, texcoords, toff, colors, coff, q.x1, q.y1, q.z1, q.s1, q.t1, q.light)
      RGL_WriteGeomInterleavedVertex(interleaved, ioff, q.x1, q.y1, q.z1, q.s1, q.t1, q.light)
      voff = voff + 12
      toff = toff + 8
      coff = coff + 4
      ioff = ioff + 24
      RGL_WriteGeomArrayVertex(vertices, voff, texcoords, toff, colors, coff, q.x2, q.y2, q.z2, q.s2, q.t2, q.light)
      RGL_WriteGeomInterleavedVertex(interleaved, ioff, q.x2, q.y2, q.z2, q.s2, q.t2, q.light)
      voff = voff + 12
      toff = toff + 8
      coff = coff + 4
      ioff = ioff + 24
      RGL_WriteGeomArrayVertex(vertices, voff, texcoords, toff, colors, coff, q.x3, q.y3, q.z3, q.s3, q.t3, q.light)
      RGL_WriteGeomInterleavedVertex(interleaved, ioff, q.x3, q.y3, q.z3, q.s3, q.t3, q.light)
      voff = voff + 12
      toff = toff + 8
      coff = coff + 4
      ioff = ioff + 24
    end if
    i = i + 1
  end while
  q = rgl_wall_quads[startIndex]
  cx = (minx + maxx) * 0.5
  cz = (minz + maxz) * 0.5
  dx = maxx - cx
  dz = maxz - cz
  radius = std.math.sqrt(dx * dx + dz * dz) + 128.0
  vertexVbo = 0
  texcoordVbo = 0
  colorVbo = 0
  interleavedVbo = RGL_CreateInterleavedGeomBufferOrZero(interleaved)
  return rgl_array_batch_t(q.texnum, q.transparent, vertexCount, vertices, texcoords, colors, cx, cz, radius, vertexVbo, texcoordVbo, colorVbo, interleaved, interleavedVbo)
end function

/// Packs one contiguous cached flat triangle range into OpenGL client arrays.
/// @param startIndex Index identifying start.
/// @param endIndex Index identifying end.
function RGL_BuildFlatArrayBatchRange(startIndex, endIndex)
  tcount = endIndex - startIndex
  if tcount <= 0 then return end if
  validCount = 0
  i = startIndex
  while i < endIndex
    if RGL_IsValidFlatTri(rgl_flat_tris[i]) then validCount = validCount + 1 end if
    i = i + 1
  end while
  if validCount <= 0 then return end if
  vertexCount = validCount * 3
  vertices = bytes(vertexCount * 12, 0)
  texcoords = bytes(vertexCount * 8, 0)
  colors = bytes(vertexCount * 4, 0)
  interleaved = bytes(vertexCount * 24, 0)
  minx = 99999999.0
  maxx = -99999999.0
  minz = 99999999.0
  maxz = -99999999.0
  voff = 0
  toff = 0
  coff = 0
  ioff = 0
  i = startIndex
  while i < endIndex
    t = rgl_flat_tris[i]
    if RGL_IsValidFlatTri(t) then
      if t.x0 < minx then minx = t.x0 end if
      if t.x1 < minx then minx = t.x1 end if
      if t.x2 < minx then minx = t.x2 end if
      if t.x0 > maxx then maxx = t.x0 end if
      if t.x1 > maxx then maxx = t.x1 end if
      if t.x2 > maxx then maxx = t.x2 end if
      if t.z0 < minz then minz = t.z0 end if
      if t.z1 < minz then minz = t.z1 end if
      if t.z2 < minz then minz = t.z2 end if
      if t.z0 > maxz then maxz = t.z0 end if
      if t.z1 > maxz then maxz = t.z1 end if
      if t.z2 > maxz then maxz = t.z2 end if
      RGL_WriteGeomArrayVertex(vertices, voff, texcoords, toff, colors, coff, t.x0, t.y0, t.z0, t.s0, t.t0, t.light)
      RGL_WriteGeomInterleavedVertex(interleaved, ioff, t.x0, t.y0, t.z0, t.s0, t.t0, t.light)
      voff = voff + 12
      toff = toff + 8
      coff = coff + 4
      ioff = ioff + 24
      RGL_WriteGeomArrayVertex(vertices, voff, texcoords, toff, colors, coff, t.x1, t.y1, t.z1, t.s1, t.t1, t.light)
      RGL_WriteGeomInterleavedVertex(interleaved, ioff, t.x1, t.y1, t.z1, t.s1, t.t1, t.light)
      voff = voff + 12
      toff = toff + 8
      coff = coff + 4
      ioff = ioff + 24
      RGL_WriteGeomArrayVertex(vertices, voff, texcoords, toff, colors, coff, t.x2, t.y2, t.z2, t.s2, t.t2, t.light)
      RGL_WriteGeomInterleavedVertex(interleaved, ioff, t.x2, t.y2, t.z2, t.s2, t.t2, t.light)
      voff = voff + 12
      toff = toff + 8
      coff = coff + 4
      ioff = ioff + 24
    end if
    i = i + 1
  end while
  t = void
  i = startIndex
  while i < endIndex and t is void
    if RGL_IsValidFlatTri(rgl_flat_tris[i]) then t = rgl_flat_tris[i] end if
    i = i + 1
  end while
  if t is void then return end if
  cx = (minx + maxx) * 0.5
  cz = (minz + maxz) * 0.5
  dx = maxx - cx
  dz = maxz - cz
  radius = std.math.sqrt(dx * dx + dz * dz) + 192.0
  vertexVbo = 0
  texcoordVbo = 0
  colorVbo = 0
  interleavedVbo = RGL_CreateInterleavedGeomBufferOrZero(interleaved)
  return rgl_array_batch_t(t.flatnum, false, vertexCount, vertices, texcoords, colors, cx, cz, radius, vertexVbo, texcoordVbo, colorVbo, interleaved, interleavedVbo)
end function

/// Creates prepacked OpenGL client-array batches for static opaque world geometry.
function RGL_BuildStaticArrayBatches()
  global rgl_wall_quads
  global rgl_flat_tris
  global rgl_wall_array_batches
  global rgl_flat_array_batches
  global rgl_masked_array_batches
  global rgl_static_array_batches_ready

  if rgl_static_array_batches_ready then return true end if
  RGL_ResetStaticArrayBatches()

  if RGL_IsSeq(rgl_wall_quads) then
    savedWallQuads = rgl_wall_quads
    wallGroups = RGL_GroupWallQuadsForArrayBatches(savedWallQuads)
    gi = 0
    while gi < len(wallGroups)
      rgl_wall_quads = wallGroups[gi]
      chunkStart = 0
      while chunkStart < len(rgl_wall_quads)
        chunkEnd = chunkStart + RGL_WALL_ARRAY_BATCH_QUADS
        if chunkEnd > len(rgl_wall_quads) then chunkEnd = len(rgl_wall_quads) end if
        batch = RGL_BuildWallArrayBatchRange(chunkStart, chunkEnd)
        if batch is not void then rgl_wall_array_batches = rgl_wall_array_batches + [batch] end if
        chunkStart = chunkEnd
      end while
      gi = gi + 1
    end while
    rgl_wall_quads = savedWallQuads
  end if

  if RGL_IsSeq(rgl_flat_tris) then
    savedFlatTris = rgl_flat_tris
    flatGroups = RGL_GroupFlatTrisForArrayBatches(savedFlatTris)
    gi = 0
    while gi < len(flatGroups)
      rgl_flat_tris = flatGroups[gi]
      chunkStart = 0
      while chunkStart < len(rgl_flat_tris)
        chunkEnd = chunkStart + RGL_FLAT_ARRAY_BATCH_TRIS
        if chunkEnd > len(rgl_flat_tris) then chunkEnd = len(rgl_flat_tris) end if
        batch = RGL_BuildFlatArrayBatchRange(chunkStart, chunkEnd)
        if batch is not void then rgl_flat_array_batches = rgl_flat_array_batches + [batch] end if
        chunkStart = chunkEnd
      end while
      gi = gi + 1
    end while
    rgl_flat_tris = savedFlatTris
  end if

  if RGL_IsSeq(rgl_masked_quads) then
    savedWallQuads = rgl_wall_quads
    wallGroups = RGL_GroupWallQuadsForArrayBatches(rgl_masked_quads)
    gi = 0
    while gi < len(wallGroups)
      rgl_wall_quads = wallGroups[gi]
      chunkStart = 0
      while chunkStart < len(rgl_wall_quads)
        chunkEnd = chunkStart + RGL_WALL_ARRAY_BATCH_QUADS
        if chunkEnd > len(rgl_wall_quads) then chunkEnd = len(rgl_wall_quads) end if
        batch = RGL_BuildWallArrayBatchRange(chunkStart, chunkEnd)
        if batch is not void then rgl_masked_array_batches = rgl_masked_array_batches + [batch] end if
        chunkStart = chunkEnd
      end while
      gi = gi + 1
    end while
    rgl_wall_quads = savedWallQuads
  end if

  RGL_RebuildNativeArrayBatchRecords()
  rgl_static_array_batches_ready = true
  return true
end function

/// Encodes the low 32 bits of a value in little-endian cache/native-record format.
/// @param buf Buf value supplied to `RGL_WriteU32`.
/// @param off Zero-based byte or element offset.
/// @param value Value consumed by the operation.
function inline RGL_WriteU32(buf, off, value)
  v = value
  if v < 0 then v = v + 4294967296 end if
  buf[off] = v & 255
  buf[off + 1] =(v >> 8) & 255
  buf[off + 2] =(v >> 16) & 255
  buf[off + 3] =(v >> 24) & 255
end function

/// Encodes a signed integer through the shared little-endian 32-bit writer.
/// @param buf Buf value supplied to `RGL_WriteS32`.
/// @param off Zero-based byte or element offset.
/// @param value Value consumed by the operation.
function inline RGL_WriteS32(buf, off, value)
  RGL_WriteU32(buf, off, value)
end function

/// Decodes an unsigned little-endian 32-bit value from serialized geometry bytes.
/// @param buf Buf value supplied to `RGL_ReadU32`.
/// @param off Zero-based byte or element offset.
function inline RGL_ReadU32(buf, off)
  return buf[off] +(buf[off + 1] << 8) +(buf[off + 2] << 16) +(buf[off + 3] << 24)
end function

/// Decodes a little-endian 32-bit value and restores its signed interpretation.
/// @param buf Buf value supplied to `RGL_ReadS32`.
/// @param off Zero-based byte or element offset.
function inline RGL_ReadS32(buf, off)
  v = RGL_ReadU32(buf, off)
  if v >= 2147483648 then v = v - 4294967296 end if
  return v
end function

/// Quantizes a numeric coordinate to the signed fixed-scale representation used in cached geometry.
/// @param v Value consumed by the operation.
function inline RGL_FloatToGeom(v)
  if typeof(v) != "float" and typeof(v) != "int" then v = 0.0 end if
  if v >= 0 then return std.math.floor(v * RGL_GEOM_FIX_SCALE + 0.5) end if
  return std.math.ceil(v * RGL_GEOM_FIX_SCALE - 0.5)
end function

/// Restores a serialized fixed-scale geometry component to floating-point world units.
/// @param v Value consumed by the operation.
function inline RGL_GeomToFloat(v)
  return v / RGL_GEOM_FIX_SCALE
end function

/// Formats the current map's derived geometry-cache lump name as MAPxxGL or ExMxGL.
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

/// Distinguishes episode maps that share the same map number while preserving commercial map IDs.
function inline RGL_CurrentMapIdentity()
  m = -1
  if typeof(gamemap) == "int" then m = gamemap end if
  if gamemode == GameMode_t.commercial then return m end if
  e = -1
  if typeof(gameepisode) == "int" then e = gameepisode end if
  return e * 100 + m
end function

/// Hashes sector floor/ceiling heights for geometry invalidation while deliberately excluding light flicker.
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

/// Computes a once-per-tic hash of sidedef textures and non-scrolling offsets for cache invalidation.
function RGL_SideTextureSignature()
  global rgl_side_sig_map
  global rgl_side_sig_gametic
  global rgl_side_sig_leveltime
  global rgl_side_sig_value

  currentMap = RGL_CurrentMapIdentity()
  currentTic = -1
  if typeof(gametic) == "int" then currentTic = gametic end if
  currentLevelTime = -1
  if typeof(leveltime) == "int" then currentLevelTime = leveltime end if
  if rgl_side_sig_map == currentMap and rgl_side_sig_gametic == currentTic and rgl_side_sig_leveltime == currentLevelTime then return rgl_side_sig_value end if
  if not RGL_IsSeq(sides) then
    rgl_side_sig_map = currentMap
    rgl_side_sig_gametic = currentTic
    rgl_side_sig_leveltime = currentLevelTime
    rgl_side_sig_value = -1
    return -1
  end if
  h = len(sides) * 131071
  i = 0
  while i < len(sides)
    sd = sides[i]
    if sd is not void then
      if typeof(sd.toptexture) == "int" then h = h +(i + 1) * sd.toptexture end if
      if typeof(sd.midtexture) == "int" then h = h +(i + 3) * sd.midtexture end if
      if typeof(sd.bottomtexture) == "int" then h = h +(i + 5) * sd.bottomtexture end if
      scrolling = i < len(rgl_scrolling_sides) and rgl_scrolling_sides[i]
      // Special 48 changes its front-side offset every tic and is drawn outside the static cache.
      // Other offsets must remain part of the signature because savegames restore them verbatim.
      if not scrolling then
        if typeof(sd.textureoffset) == "int" then h = h +(i + 7) * sd.textureoffset end if
        if typeof(sd.rowoffset) == "int" then h = h +(i + 11) * sd.rowoffset end if
      end if
    end if
    i = i + 1
  end while
  rgl_side_sig_map = currentMap
  rgl_side_sig_gametic = currentTic
  rgl_side_sig_leveltime = currentLevelTime
  rgl_side_sig_value = h
  return h
end function

/// Finds the current map index for a sector reference.
/// @param sec Sec value supplied to `RGL_SectorIndex`.
function RGL_SectorIndex(sec)
  if sec is void or not RGL_IsSeq(sectors) then return -1 end if
  i = 0
  while i < len(sectors)
    if sectors[i] == sec then return i end if
    i = i + 1
  end while
  return -1
end function

/// Marks a sector as dynamic so it is drawn outside the static GL cache.
/// @param idx Zero-based element or table index.
function RGL_MarkVolatileSectorIndex(idx)
  global rgl_volatile_sectors

  if idx < 0 or idx >= len(rgl_volatile_sectors) then return end if
  rgl_volatile_sectors[idx] = true
end function

/// Resolves a sector reference by identity and marks its index for dynamic rendering outside the static cache.
/// @param sec Sec value supplied to `RGL_MarkVolatileSector`.
function RGL_MarkVolatileSector(sec)
  idx = RGL_SectorIndex(sec)
  if idx >= 0 then RGL_MarkVolatileSectorIndex(idx) end if
end function

/// Returns true for Doom line specials that start, resume, or stop moving floors, ceilings, doors, or
/// platforms.
/// @param li Li value supplied to `RGL_LineMayMoveGeometry`.
function RGL_LineMayMoveGeometry(li)
  if li is void or typeof(li.special) != "int" then return false end if
  switch li.special
    // Include manual, walk-over, gun, repeatable, and stop-controller variants.
    // A sector must be excluded from the static cache before its mover starts.
    case 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 14, 15, 16, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30
      return true
    end case
    case 31, 32, 33, 34, 36, 37, 38, 40, 41, 42, 43, 44, 45, 46, 47, 49, 50, 53, 54, 55, 56, 57, 58, 59
      return true
    end case
    case 60, 61, 62, 63, 64, 65, 66, 67, 68, 69, 70, 71, 72, 73, 74, 75, 76, 77, 82, 83, 84, 86, 87, 88, 89
      return true
    end case
    case 90, 91, 92, 93, 94, 95, 96, 98, 99, 100, 101, 102, 103, 105, 106, 107, 108, 109, 110, 111, 112, 113
      return true
    end case
    case 114, 115, 116, 117, 118, 119, 120, 121, 122, 123, 127, 128, 129, 130, 131, 132, 133, 134, 135, 136, 137, 140, 141
      return true
    end case
  end switch
  return false
end function

/// Identifies Doom's continuously scrolling wall special so it can bypass static UV caches.
/// @param li Li value supplied to `RGL_LineScrollsTexture`.
function inline RGL_LineScrollsTexture(li)
  return li is not void and typeof(li.special) == "int" and li.special == 48
end function

/// Returns true for sectors that may move or need uncached wall/flat updates.
/// @param sec Sec value supplied to `RGL_IsVolatileSector`.
function RGL_IsVolatileSector(sec)
  if sec is void then return false end if
  if sec.specialdata is not void then return true end if
  idx = RGL_SectorIndex(sec)
  if idx < 0 or idx >= len(rgl_volatile_sectors) then return false end if
  return rgl_volatile_sectors[idx]
end function

/// Checks whether a subsector belongs to dynamic sector geometry.
/// @param idx Zero-based element or table index.
function RGL_IsVolatileSubsectorIndex(idx)
  if idx < 0 or not RGL_IsSeq(subsectors) or idx >= len(subsectors) then return false end if
  ss = subsectors[idx]
  if ss is void then return false end if
  return RGL_IsVolatileSector(ss.sector)
end function

/// Checks whether a seg touches dynamic sector geometry.
/// @param idx Zero-based element or table index.
function RGL_IsVolatileSegIndex(idx)
  if idx < 0 or not RGL_IsSeq(segs) or idx >= len(segs) then return false end if
  sg = segs[idx]
  if sg is void then return false end if
  if RGL_IsVolatileSector(sg.frontsector) then return true end if
  if RGL_IsVolatileSector(sg.backsector) then return true end if
  return false
end function

/// Checks whether a line touches dynamic sector geometry.
/// @param idx Zero-based element or table index.
function RGL_IsVolatileLineIndex(idx)
  if idx < 0 or not RGL_IsSeq(lines) or idx >= len(lines) then return false end if
  li = lines[idx]
  if li is void then return false end if
  if RGL_IsVolatileSector(li.frontsector) then return true end if
  if RGL_IsVolatileSector(li.backsector) then return true end if
  return false
end function

/// Precomputes sectors and draw lists that should remain dynamic.
/// @param sigMap Sig map value supplied to `RGL_BuildVolatileSectorMap`.
function RGL_BuildVolatileSectorMap(sigMap)
  global rgl_volatile_sig_map
  global rgl_volatile_sectors
  global rgl_volatile_subsectors
  global rgl_volatile_segs
  global rgl_volatile_lines
  global rgl_scrolling_segs
  global rgl_scrolling_lines
  global rgl_scrolling_sides

  RGL_ResetVolatileArrayBatches()
  RGL_ResetScrollingArrayBatches()
  rgl_volatile_sig_map = sigMap
  rgl_volatile_sectors =[]
  rgl_volatile_subsectors =[]
  rgl_volatile_segs =[]
  rgl_volatile_lines =[]
  rgl_scrolling_segs =[]
  rgl_scrolling_lines =[]
  rgl_scrolling_sides =[]
  if not RGL_IsSeq(sectors) then return end if

  if RGL_IsSeq(sides) then rgl_scrolling_sides = array(len(sides), false) end if

  rgl_volatile_sectors = array(len(sectors), false)
  i = 0
  while i < len(sectors)
    sec = sectors[i]
    if sec is not void then
      if sec.specialdata is not void then rgl_volatile_sectors[i] = true end if
      // Boss-death actions synthesize a tagged line at runtime, so no map linedef identifies these movers.
      if typeof(sec.tag) == "int" and (sec.tag == 666 or sec.tag == 667) then rgl_volatile_sectors[i] = true end if
    end if
    i = i + 1
  end while

  if RGL_IsSeq(lines) then
    i = 0
    while i < len(lines)
      li = lines[i]
      if li is not void then
        if RGL_LineScrollsTexture(li) and RGL_IsSeq(li.sidenum) and len(li.sidenum) > 0 then
          scrollingSide = li.sidenum[0]
          if typeof(scrollingSide) == "int" and scrollingSide >= 0 and scrollingSide < len(rgl_scrolling_sides) then
            rgl_scrolling_sides[scrollingSide] = true
          end if
        end if
        activeLine = false
        if li.specialdata is not void then activeLine = true end if
        if RGL_LineMayMoveGeometry(li) then activeLine = true end if
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
      sg = segs[i]
      if sg is not void and RGL_LineScrollsTexture(sg.linedef) then
        rgl_scrolling_segs = rgl_scrolling_segs +[i]
      else if RGL_IsVolatileSegIndex(i) then
        rgl_volatile_segs = rgl_volatile_segs +[i]
      end if
      i = i + 1
    end while
  end if

  if RGL_IsSeq(lines) then
    i = 0
    while i < len(lines)
      li = lines[i]
      if RGL_LineScrollsTexture(li) then
        rgl_scrolling_lines = rgl_scrolling_lines +[i]
      else if RGL_IsVolatileLineIndex(i) then
        rgl_volatile_lines = rgl_volatile_lines +[i]
      end if
      i = i + 1
    end while
  end if
end function

/// Keeps the dynamic sector draw lists aligned with the loaded map.
/// @param sigMap Sig map value supplied to `RGL_EnsureVolatileSectorMap`.
function RGL_EnsureVolatileSectorMap(sigMap)
  if rgl_volatile_sig_map != sigMap then
    RGL_BuildVolatileSectorMap(sigMap)
    return
  end if
  if RGL_IsSeq(sectors) and len(rgl_volatile_sectors) != len(sectors) then
    RGL_BuildVolatileSectorMap(sigMap)
  end if
end function

/// Computes the exact serialized byte count for the cache header and all quad/triangle record collections.
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

/// Quantizes and appends one floating geometry component, returning the next byte offset.
/// @param buf Buf value supplied to `RGL_WriteGeomFixed`.
/// @param off Zero-based byte or element offset.
/// @param v Value consumed by the operation.
function RGL_WriteGeomFixed(buf, off, v)
  RGL_WriteS32(buf, off, RGL_FloatToGeom(v))
  return off + 4
end function

/// Serializes a textured quad's metadata, four positions, and four UV pairs and returns the next offset.
/// @param buf Buf value supplied to `RGL_WriteGeomQuad`.
/// @param off Zero-based byte or element offset.
/// @param q Q value supplied to `RGL_WriteGeomQuad`.
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

/// Deserializes one textured quad and returns it together with the next unread byte offset.
/// @param buf Buf value supplied to `RGL_ReadGeomQuad`.
/// @param off Zero-based byte or element offset.
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

/// Serializes a flat triangle's texture/light metadata, positions, and UVs and returns the next offset.
/// @param buf Buf value supplied to `RGL_WriteGeomFlatTri`.
/// @param off Zero-based byte or element offset.
/// @param t T value supplied to `RGL_WriteGeomFlatTri`.
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

/// Deserializes one flat triangle and returns it together with the next unread byte offset.
/// @param buf Buf value supplied to `RGL_ReadGeomFlatTri`.
/// @param off Zero-based byte or element offset.
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

/// Serializes the three positions of a depth-only sky-occlusion triangle.
/// @param buf Buf value supplied to `RGL_WriteGeomDepthTri`.
/// @param off Zero-based byte or element offset.
/// @param t T value supplied to `RGL_WriteGeomDepthTri`.
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

/// Deserializes one depth-only triangle and returns it with the next unread offset.
/// @param buf Buf value supplied to `RGL_ReadGeomDepthTri`.
/// @param off Zero-based byte or element offset.
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

/// Serializes the four positions of a depth-only sky-occlusion quad.
/// @param buf Buf value supplied to `RGL_WriteGeomDepthQuad`.
/// @param off Zero-based byte or element offset.
/// @param q Q value supplied to `RGL_WriteGeomDepthQuad`.
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

/// Deserializes one depth-only quad and returns it with the next unread offset.
/// @param buf Buf value supplied to `RGL_ReadGeomDepthQuad`.
/// @param off Zero-based byte or element offset.
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

/// Writes signatures, collection counts, and every cached geometry record into the versioned MGL1 blob.
/// @param sigMap Sig map value supplied to `RGL_SerializeGeometryCache`.
/// @param sigSegs Sig segs value supplied to `RGL_SerializeGeometryCache`.
/// @param sigLines Sig lines value supplied to `RGL_SerializeGeometryCache`.
/// @param sigNodes Sig nodes value supplied to `RGL_SerializeGeometryCache`.
/// @param sigSubsectors Sig subsectors value supplied to `RGL_SerializeGeometryCache`.
/// @param sigSectorMotion Sig sector motion value supplied to `RGL_SerializeGeometryCache`.
/// @param sigSides Sig sides value supplied to `RGL_SerializeGeometryCache`.
function RGL_SerializeGeometryCache(sigMap, sigSegs, sigLines, sigNodes, sigSubsectors, sigSectorMotion, sigSides)
  global rgl_light_geom_blob
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

  rgl_light_geom_blob = buf
  return buf
end function

/// Validates a versioned map geometry lump against current signatures, restores its lists, and rebuilds runtime
/// batches.
/// @param sigMap Sig map value supplied to `RGL_TryLoadGeometryCache`.
/// @param sigSegs Sig segs value supplied to `RGL_TryLoadGeometryCache`.
/// @param sigLines Sig lines value supplied to `RGL_TryLoadGeometryCache`.
/// @param sigNodes Sig nodes value supplied to `RGL_TryLoadGeometryCache`.
/// @param sigSubsectors Sig subsectors value supplied to `RGL_TryLoadGeometryCache`.
/// @param sigSectorMotion Sig sector motion value supplied to `RGL_TryLoadGeometryCache`.
/// @param sigSides Sig sides value supplied to `RGL_TryLoadGeometryCache`.
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
  global rgl_light_geom_blob

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
  rgl_light_geom_blob = data
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
  RGL_BuildVolatileFlatTemplates()
  RGL_ResetStaticDisplayLists()
  RGL_ResetStaticArrayBatches()
  print "RGL: loaded cached map geometry " + RGL_MapGeomLumpName()
  return true
end function

/// Rebuilds the current static cache and returns its derived WAD lump name plus serialized geometry blob.
function RGL_BuildCurrentMapGeometryLump()
  sigMap = RGL_CurrentMapIdentity()
  RGL_EnsureVolatileSectorMap(sigMap)
  sigSegs = RGL_SeqLen(segs)
  sigLines = RGL_SeqLen(lines)
  sigNodes = RGL_SeqLen(nodes)
  sigSubsectors = RGL_SeqLen(subsectors)
  sigSectorMotion = 0
  sigSides = RGL_SideTextureSignature()
  RGL_BuildGeometryCache(sigMap, sigSegs, sigLines, sigNodes, sigSubsectors, sigSectorMotion, sigSides)
  blob = RGL_SerializeGeometryCache(sigMap, sigSegs, sigLines, sigNodes, sigSubsectors, sigSectorMotion, sigSides)
  return [RGL_MapGeomLumpName(), blob]
end function

/// Converts a Doom FRACUNIT-scaled coordinate to floating-point world units.
/// @param v Value consumed by the operation.
function inline RGL_FixedToFloat(v)
  return v / FRACUNIT
end function

/// Converts Doom's unsigned full-turn binary angle to degrees in [0,360).
/// @param a First input operand.
function inline RGL_AngleToDegrees(a)
  u = a
  if u < 0 then u = u + 4294967296 end if
  return(u / RGL_ANGLE_FULL) * 360.0
end function

/// Wraps an arbitrary degree value into the half-open [0,360) interval.
/// @param d Divisor or direction value used by the operation.
function RGL_NormalizeDegrees(d)
  while d < 0.0
    d = d + 360.0
  end while
  while d >= 360.0
    d = d - 360.0
  end while
  return d
end function

/// Resolves an enum-like value to a bounded numeric table index, returning -1 when absent.
/// @param v Value consumed by the operation.
/// @param limit Limit value supplied to `RGL_EnumIndex`.
function inline RGL_EnumIndex(v, limit)
  i = 0
  while i < limit
    if v == i then return i end if
    i = i + 1
  end while
  return -1
end function

/// Resolves a sprite identifier against the currently loaded sprite definition count.
/// @param v Value consumed by the operation.
function inline RGL_SpriteIndex(v)
  max = 0
  if RGL_IsSeq(sprites) then
    max = len(sprites)
  else if typeof(numsprites) == "int" then
    max = numsprites
  end if
  return RGL_EnumIndex(v, max)
end function

/// Maps a sector light level into the renderer's restrained 12-through-198 static brightness range.
/// @param sec Sec value supplied to `RGL_LightByte`.
function inline RGL_LightByte(sec)
  if sec is void or typeof(sec.lightlevel) != "int" then return 128 end if
  v = sec.lightlevel
  v = 8.0 +(v * 0.68)
  if v < 12 then v = 12 end if
  if v > 198 then v = 198 end if
  return std.math.floor(v)
end function

/// Checks whether a sector thinker is currently moving world geometry.
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

/// Checks whether a sector is near a fixed-point map coordinate.
/// @param sec Sec value supplied to `RGL_SectorNearFixedPoint`.
/// @param x Horizontal map- or screen-space coordinate.
/// @param y Vertical map- or screen-space coordinate.
/// @param radius Radius value supplied to `RGL_SectorNearFixedPoint`.
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

/// Uses the accurate direct renderer when the player is near moving sectors.
/// @param player Player state affected by the operation.
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

/// Clamps a numeric color component to an integer byte accepted by OpenGL color calls.
/// @param v Value consumed by the operation.
function inline RGL_ClampByte(v)
  if v < 0 then return 0 end if
  if v > 255 then return 255 end if
  if v >= 0 then return std.math.floor(v) end if
  return std.math.ceil(v)
end function

/// Appends an in-range, positive dynamic light to the bounded per-frame arrays when near the current view.
/// @param x Horizontal map- or screen-space coordinate.
/// @param y Vertical map- or screen-space coordinate.
/// @param z Vertical world-space coordinate.
/// @param r R value supplied to `RGL_AddDynamicLight`.
/// @param g G value supplied to `RGL_AddDynamicLight`.
/// @param b Second input operand.
/// @param radius Radius value supplied to `RGL_AddDynamicLight`.
/// @param strength Strength value supplied to `RGL_AddDynamicLight`.
function RGL_AddDynamicLight(x, y, z, r, g, b, radius, strength)
  global rgl_dyn_light_count
  global rgl_dyn_light_x
  global rgl_dyn_light_y
  global rgl_dyn_light_z
  global rgl_dyn_light_r
  global rgl_dyn_light_g
  global rgl_dyn_light_b
  global rgl_dyn_light_radius
  global rgl_dyn_light_strength

  if rgl_dyn_light_count >= RGL_MAX_DYNAMIC_LIGHTS then return end if
  if typeof(radius) != "float" and typeof(radius) != "int" then return end if
  if typeof(strength) != "float" and typeof(strength) != "int" then return end if
  if radius <= 0 or strength <= 0 then return end if
  dxView = x - rgl_view_x
  dzView = z + rgl_view_y
  maxDist = 2800.0 + radius
  if dxView * dxView + dzView * dzView > maxDist * maxDist then return end if
  idx = rgl_dyn_light_count
  rgl_dyn_light_x[idx] = x
  rgl_dyn_light_y[idx] = y
  rgl_dyn_light_z[idx] = z
  rgl_dyn_light_r[idx] = r
  rgl_dyn_light_g[idx] = g
  rgl_dyn_light_b[idx] = b
  rgl_dyn_light_radius[idx] = radius
  rgl_dyn_light_strength[idx] = strength
  rgl_dyn_light_count = idx + 1
end function

/// Tests a short ASCII prefix without relying on optional string helpers.
/// @param s S value supplied to `RGL_StringStartsWith`.
/// @param prefix Prefix value supplied to `RGL_StringStartsWith`.
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

/// Resolves the currently translated flat name for liquid light classification.
/// @param flatnum Index identifying flat.
function RGL_FlatNameForNum(flatnum)
  if typeof(flatnum) != "int" or flatnum < 0 then return "" end if
  n = flatnum
  if RGL_IsSeq(flattranslation) and n >= 0 and n < len(flattranslation) then n = flattranslation[n] end if
  lump = firstflat + n
  return RGL_LumpNameAt(lump)
end function

/// Classifies animated liquid flats that should emit subtle GL ambience.
/// @param flatnum Index identifying flat.
function RGL_LiquidLightKind(flatnum)
  name = RGL_FlatNameForNum(flatnum)
  if name == "" then return 0 end if
  if RGL_StringStartsWith(name, "LAVA") or RGL_StringStartsWith(name, "FIRELAV") then return 1 end if
  if RGL_StringStartsWith(name, "NUKAGE") or RGL_StringStartsWith(name, "SLIME") then return 2 end if
  if RGL_StringStartsWith(name, "BLOOD") then return 3 end if
  if RGL_StringStartsWith(name, "FWATER") then return 4 end if
  return 0
end function

/// Adds one restrained colored light above a nearby liquid sector.
/// @param sec Sec value supplied to `RGL_AddSectorLiquidLight`.
/// @param kind Kind value supplied to `RGL_AddSectorLiquidLight`.
/// @param player Player state affected by the operation.
/// @param pulse Pulse value supplied to `RGL_AddSectorLiquidLight`.
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

/// Adds a small budget of ambient lights for nearby liquid sectors.
/// @param player Player state affected by the operation.
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

/// Adds subtle OpenGL light from decorative light-emitting map objects.
/// @param mo Map object affected by the operation.
/// @param x Horizontal map- or screen-space coordinate.
/// @param z Vertical world-space coordinate.
function RGL_MobjDecorLight(mo, x, z)
  if mo is void or typeof(mo.sprite) != "int" then return false end if
  sp = mo.sprite
  y = RGL_FixedToFloat(mo.z) + 28.0
  if typeof(mo.height) == "int" then
    h = RGL_FixedToFloat(mo.height)
    if h > 0.0 then y = RGL_FixedToFloat(mo.z) + h * 0.65 end if
  end if

  pulse = 1.0
  if typeof(gametic) == "int" then
    pulse = 0.88 + std.math.sin(gametic * 0.23 + x * 0.011 + z * 0.013) * 0.12
  end if

  if sp == spritenum_t.SPR_TBLU then
    RGL_AddDynamicLight(x, y + 18.0, z, 76, 150, 255, 360.0, 38.0 * pulse)
    return true
  end if
  if sp == spritenum_t.SPR_TGRN then
    RGL_AddDynamicLight(x, y + 18.0, z, 76, 230, 92, 360.0, 36.0 * pulse)
    return true
  end if
  if sp == spritenum_t.SPR_TRED then
    RGL_AddDynamicLight(x, y + 18.0, z, 255, 80, 46, 360.0, 38.0 * pulse)
    return true
  end if
  if sp == spritenum_t.SPR_SMBT then
    RGL_AddDynamicLight(x, y + 10.0, z, 76, 145, 255, 285.0, 29.0 * pulse)
    return true
  end if
  if sp == spritenum_t.SPR_SMGT then
    RGL_AddDynamicLight(x, y + 10.0, z, 72, 220, 88, 285.0, 28.0 * pulse)
    return true
  end if
  if sp == spritenum_t.SPR_SMRT then
    RGL_AddDynamicLight(x, y + 10.0, z, 255, 78, 42, 285.0, 29.0 * pulse)
    return true
  end if
  if sp == spritenum_t.SPR_CAND then
    RGL_AddDynamicLight(x, y + 6.0, z, 255, 170, 82, 205.0, 18.0 * pulse)
    return true
  end if
  if sp == spritenum_t.SPR_CBRA or sp == spritenum_t.SPR_POL3 then
    RGL_AddDynamicLight(x, y + 12.0, z, 255, 166, 74, 295.0, 30.0 * pulse)
    return true
  end if
  if sp == spritenum_t.SPR_TLMP then
    RGL_AddDynamicLight(x, y + 14.0, z, 188, 235, 255, 345.0, 35.0 * pulse)
    return true
  end if
  if sp == spritenum_t.SPR_TLP2 then
    RGL_AddDynamicLight(x, y + 14.0, z, 170, 225, 255, 300.0, 28.0 * pulse)
    return true
  end if
  if sp == spritenum_t.SPR_FCAN then
    RGL_AddDynamicLight(x, y + 16.0, z, 255, 118, 38, 315.0, 34.0 * pulse)
    return true
  end if
  if sp == spritenum_t.SPR_CEYE then
    RGL_AddDynamicLight(x, y + 16.0, z, 130, 255, 82, 300.0, 26.0 * pulse)
    return true
  end if
  if sp == spritenum_t.SPR_FSKU then
    RGL_AddDynamicLight(x, y + 12.0, z, 255, 112, 58, 255.0, 22.0 * pulse)
    return true
  end if
  return false
end function

/// Adds short, bright OpenGL lights for explosion animation states.
/// @param mo Map object affected by the operation.
/// @param x Horizontal map- or screen-space coordinate.
/// @param y Vertical map- or screen-space coordinate.
/// @param z Vertical world-space coordinate.
function RGL_MobjExplosionLight(mo, x, y, z)
  if mo is void or mo.state is void or typeof(mo.state) != "struct" then return false end if
  st = Info_StateIndex(mo.state)
  if typeof(st) != "int" then return false end if

  if st == statenum_t.S_EXPLODE1 then
    RGL_AddDynamicLight(x, y, z, 255, 132, 36, 780.0, 190.0)
    return true
  end if
  if st == statenum_t.S_EXPLODE2 then
    RGL_AddDynamicLight(x, y, z, 255, 166, 62, 690.0, 145.0)
    return true
  end if
  if st == statenum_t.S_EXPLODE3 then
    RGL_AddDynamicLight(x, y, z, 255, 92, 28, 540.0, 82.0)
    return true
  end if

  if st == statenum_t.S_BEXP then
    RGL_AddDynamicLight(x, y + 18.0, z, 255, 118, 28, 820.0, 205.0)
    return true
  end if
  if st == statenum_t.S_BEXP2 then
    RGL_AddDynamicLight(x, y + 18.0, z, 255, 158, 48, 760.0, 170.0)
    return true
  end if
  if st == statenum_t.S_BEXP3 then
    RGL_AddDynamicLight(x, y + 14.0, z, 255, 126, 36, 650.0, 125.0)
    return true
  end if
  if st == statenum_t.S_BEXP4 then
    RGL_AddDynamicLight(x, y + 10.0, z, 255, 82, 24, 520.0, 78.0)
    return true
  end if
  if st == statenum_t.S_BEXP5 then
    RGL_AddDynamicLight(x, y + 6.0, z, 190, 64, 20, 360.0, 38.0)
    return true
  end if

  return false
end function

/// Classifies a mobj's type/state and emits the matching projectile, explosion, muzzle, or decorative dynamic
/// light.
/// @param mo Map object affected by the operation.
function RGL_MobjLight(mo)
  if mo is void or typeof(mo.type) != "int" then return false end if
  x = RGL_FixedToFloat(mo.x)
  y = RGL_FixedToFloat(mo.z)
  if typeof(mo.height) == "int" then y = y + RGL_FixedToFloat(mo.height) * 0.45 end if
  z = -RGL_FixedToFloat(mo.y)
  t = mo.type

  if RGL_MobjExplosionLight(mo, x, y, z) then return true end if

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
  if RGL_MobjDecorLight(mo, x, z) then return true end if
  return false
end function

/// Traverses sector thing lists once so lighting and sprite passes share the same frame-local object set.
function RGL_CollectFrameMobjs()
  global rgl_frame_mobjs
  global rgl_frame_mobj_count

  previousCount = rgl_frame_mobj_count
  rgl_frame_mobj_count = 0
  if not RGL_IsSeq(sectors) then
    i = 0
    while i < previousCount and i < len(rgl_frame_mobjs)
      rgl_frame_mobjs[i] = 0
      i = i + 1
    end while
    return
  end if
  if typeof(rgl_frame_mobjs) != "array" or len(rgl_frame_mobjs) < 1024 then
    rgl_frame_mobjs = array(1024, 0)
  end if

  si = 0
  while si < len(sectors)
    mo = sectors[si].thinglist
    guard = 0
    while mo is not void and guard < 4096
      if rgl_frame_mobj_count >= len(rgl_frame_mobjs) then
        rgl_frame_mobjs = rgl_frame_mobjs + array(len(rgl_frame_mobjs), 0)
      end if
      rgl_frame_mobjs[rgl_frame_mobj_count] = mo
      rgl_frame_mobj_count = rgl_frame_mobj_count + 1
      mo = mo.snext
      guard = guard + 1
    end while
    si = si + 1
  end while
  i = rgl_frame_mobj_count
  while i < previousCount and i < len(rgl_frame_mobjs)
    rgl_frame_mobjs[i] = 0
    i = i + 1
  end while
end function

/// Once per simulation state, collects frame mobjs and rebuilds bounded weapon, liquid, projectile, decor, and
/// explosion lights.
/// @param player Player state affected by the operation.
function RGL_BuildDynamicLights(player)
  global rgl_dyn_light_count
  global rgl_dyn_light_x
  global rgl_dyn_light_y
  global rgl_dyn_light_z
  global rgl_dyn_light_r
  global rgl_dyn_light_g
  global rgl_dyn_light_b
  global rgl_dyn_light_radius
  global rgl_dyn_light_strength
  global rgl_dyn_light_last_gametic
  global rgl_dyn_light_last_map
  global rgl_dyn_light_last_leveltime
  global rgl_dyn_light_revision

  currentTic = -1
  if typeof(gametic) == "int" then currentTic = gametic end if
  currentMap = RGL_CurrentMapIdentity()
  currentLevelTime = -1
  if typeof(leveltime) == "int" then currentLevelTime = leveltime end if
  if currentTic >= 0 and currentTic == rgl_dyn_light_last_gametic and currentMap == rgl_dyn_light_last_map and currentLevelTime == rgl_dyn_light_last_leveltime then return end if

  if len(rgl_dyn_light_x) != RGL_MAX_DYNAMIC_LIGHTS then
    rgl_dyn_light_x = array(RGL_MAX_DYNAMIC_LIGHTS, 0.0)
    rgl_dyn_light_y = array(RGL_MAX_DYNAMIC_LIGHTS, 0.0)
    rgl_dyn_light_z = array(RGL_MAX_DYNAMIC_LIGHTS, 0.0)
    rgl_dyn_light_r = array(RGL_MAX_DYNAMIC_LIGHTS, 0)
    rgl_dyn_light_g = array(RGL_MAX_DYNAMIC_LIGHTS, 0)
    rgl_dyn_light_b = array(RGL_MAX_DYNAMIC_LIGHTS, 0)
    rgl_dyn_light_radius = array(RGL_MAX_DYNAMIC_LIGHTS, 0.0)
    rgl_dyn_light_strength = array(RGL_MAX_DYNAMIC_LIGHTS, 0.0)
  end if
  rgl_dyn_light_count = 0
  RGL_CollectFrameMobjs()

  lightCullReady = false
  lightCullX = 0.0
  lightCullZ = 0.0
  if player is not void and player.mo is not void then
    px = RGL_FixedToFloat(player.mo.x)
    py = -RGL_FixedToFloat(player.mo.y)
    pz = RGL_FixedToFloat(player.viewz)
    lightCullReady = true
    lightCullX = px
    lightCullZ = py
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

  i = 0
  while i < rgl_frame_mobj_count
    mo = rgl_frame_mobjs[i]
    nearEnough = true
    if lightCullReady and typeof(mo.x) == "int" and typeof(mo.y) == "int" then
      mdx = RGL_FixedToFloat(mo.x) - lightCullX
      mdz = -RGL_FixedToFloat(mo.y) - lightCullZ
      nearEnough = (mdx * mdx + mdz * mdz) < 9437184.0
    end if
    if nearEnough then RGL_MobjLight(mo) end if
    i = i + 1
  end while
  rgl_dyn_light_last_gametic = currentTic
  rgl_dyn_light_last_map = currentMap
  rgl_dyn_light_last_leveltime = currentLevelTime
  rgl_dyn_light_revision = rgl_dyn_light_revision + 1
end function

/// Evaluates view fade and nearby dynamic lights at a world vertex, then sets an opaque OpenGL color.
/// @param base Base value supplied to `RGL_SetVertexLight`.
/// @param x Horizontal map- or screen-space coordinate.
/// @param y Vertical map- or screen-space coordinate.
/// @param z Vertical world-space coordinate.
function RGL_SetVertexLight(base, x, y, z)
  RGL_SetVertexLightAlpha(base, x, y, z, 255)
end function

/// Evaluates view fade and nearby dynamic lights at a world point, then sets the resulting OpenGL color with
/// caller alpha.
/// @param base Base value supplied to `RGL_SetVertexLightAlpha`.
/// @param x Horizontal map- or screen-space coordinate.
/// @param y Vertical map- or screen-space coordinate.
/// @param z Vertical world-space coordinate.
/// @param alpha Alpha value supplied to `RGL_SetVertexLightAlpha`.
function RGL_SetVertexLightAlpha(base, x, y, z, alpha)
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
  while i < rgl_dyn_light_count
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

  glColor4ub(RGL_ClampByte(r), RGL_ClampByte(g), RGL_ClampByte(b), RGL_ClampByte(alpha))
end function

/// Applies static plus nearby dynamic lighting at a world point and emits that OpenGL vertex.
/// @param base Base value supplied to `RGL_VertexLit`.
/// @param x Horizontal map- or screen-space coordinate.
/// @param y Vertical map- or screen-space coordinate.
/// @param z Vertical world-space coordinate.
function RGL_VertexLit(base, x, y, z)
  RGL_SetVertexLight(base, x, y, z)
  glVertex3d(x, y, z)
end function

/// Packs dynamic lights for the native additive surface-light pass.
function RGL_BuildDynamicLightSurfaceRecords()
  if rgl_dyn_light_count <= 0 then return [bytes(0, 0), 0] end if
  count = rgl_dyn_light_count
  if count > RGL_MAX_SURFACE_LIGHTS then count = RGL_MAX_SURFACE_LIGHTS end if
  buf = bytes(count * RGL_LIGHT_RECORD_SIZE, 0)
  i = 0
  while i < count
    off = i * RGL_LIGHT_RECORD_SIZE
    surfaceRadius = rgl_dyn_light_radius[i] * 0.42
    if surfaceRadius > 280.0 then surfaceRadius = 280.0 end if
    if surfaceRadius < 72.0 then surfaceRadius = 72.0 end if
    surfaceStrength = rgl_dyn_light_strength[i] * 0.62
    if surfaceStrength > 92.0 then surfaceStrength = 92.0 end if
    RGL_WriteS32(buf, off, RGL_FloatToGeom(rgl_dyn_light_x[i]))
    RGL_WriteS32(buf, off + 4, RGL_FloatToGeom(rgl_dyn_light_y[i]))
    RGL_WriteS32(buf, off + 8, RGL_FloatToGeom(rgl_dyn_light_z[i]))
    RGL_WriteS32(buf, off + 12, RGL_FloatToGeom(surfaceRadius))
    RGL_WriteS32(buf, off + 16, RGL_FloatToGeom(surfaceStrength))
    RGL_WriteS32(buf, off + 20, rgl_dyn_light_r[i])
    RGL_WriteS32(buf, off + 24, rgl_dyn_light_g[i])
    RGL_WriteS32(buf, off + 28, rgl_dyn_light_b[i])
    i = i + 1
  end while
  return [buf, count]
end function

/// Adds dynamic light back onto real floor, ceiling, and wall geometry.
/// @param yaw Yaw value supplied to `RGL_DrawDynamicLightGlows`.
function RGL_DrawDynamicLightGlows(yaw)
  if rgl_dyn_light_count <= 0 then return end if
  if typeof(rgl_light_geom_blob) != "bytes" or len(rgl_light_geom_blob) < 60 then return end if
  rec = RGL_BuildDynamicLightSurfaceRecords()
  if rec[1] <= 0 then return end if
  MGL_DrawDynamicLightSurfaces(rgl_light_geom_blob, len(rgl_light_geom_blob), rec[0], rec[1])
end function

/// Emits static sector lighting for compiled OpenGL geometry batches.
/// @param base Base value supplied to `RGL_StaticVertexLit`.
/// @param x Horizontal map- or screen-space coordinate.
/// @param y Vertical map- or screen-space coordinate.
/// @param z Vertical world-space coordinate.
function RGL_StaticVertexLit(base, x, y, z)
  b = RGL_ClampByte(base)
  glColor4ub(b, b, b, 255)
  glVertex3d(x, y, z)
end function

/// Converts a Doom map vertex and fixed height to OpenGL axes and emits it with current-sector lighting.
/// @param v Value consumed by the operation.
/// @param z Vertical world-space coordinate.
function inline RGL_Vertex(v, z)
  if v is void then return end if
  x = RGL_FixedToFloat(v.x)
  y = RGL_FixedToFloat(z)
  zz = -RGL_FixedToFloat(v.y)
  RGL_VertexLit(rgl_current_light, x, y, zz)
end function

/// Decodes the zero-terminated name of a validated lump directory entry.
/// @param lumpnum Index identifying lump.
function RGL_LumpNameAt(lumpnum)
  if not RGL_IsSeq(lumpinfo) then return "" end if
  if lumpnum < 0 or lumpnum >= len(lumpinfo) then return "" end if
  li = lumpinfo[lumpnum]
  if li is void or typeof(li.name) != "bytes" then return "" end if
  return decodeZ(li.name)
end function

/// Returns a keyed GL texture or uploads indexed asset pixels once with requested alpha and wrap modes.
/// @param key Input key code to process.
/// @param entry Entry value supplied to `RGL_CachedTexture`.
/// @param transparent Transparent value supplied to `RGL_CachedTexture`.
/// @param repeatWrap Repeat wrap value supplied to `RGL_CachedTexture`.
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

/// Invalidates every palette-derived GL texture and dependent static/dynamic batch when the indexed palette
/// changes.
function RGL_SyncPaletteRevision()
  global rgl_tex_keys
  global rgl_tex_ids
  global rgl_texnum_tex_ids
  global rgl_texnum_trans_tex_ids
  global rgl_flat_tex_ids
  global rgl_sprite_tex_ids
  global rgl_sprite_fuzz_tex_ids
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
  rgl_sprite_fuzz_tex_ids =[]
  rgl_palette_revision_seen = rev
  rgl_geom_ready = false
  RGL_ResetStaticDisplayLists()
  RGL_ResetStaticArrayBatches()
  RGL_ResetVolatileArrayBatches()
  RGL_ResetScrollingArrayBatches()
end function

/// Resolves Doom texture animation translation for OpenGL texture binding.
/// @param texnum Index identifying tex.
function inline RGL_ResolveTextureNum(texnum)
  if typeof(texnum) != "int" or texnum < 0 then return -1 end if
  n = texnum
  if RGL_IsSeq(texturetranslation) and n >= 0 and n < len(texturetranslation) then
    tn = texturetranslation[n]
    if typeof(tn) == "int" and tn >= 0 then n = tn end if
  end if
  return n
end function

/// Resolves Doom flat animation translation for OpenGL flat binding.
/// @param flatnum Index identifying flat.
function inline RGL_ResolveFlatNum(flatnum)
  if typeof(flatnum) != "int" or flatnum < 0 then return -1 end if
  n = flatnum
  if RGL_IsSeq(flattranslation) and n >= 0 and n < len(flattranslation) then
    fn = flattranslation[n]
    if typeof(fn) == "int" and fn >= 0 then n = fn end if
  end if
  return n
end function

/// Returns the name of the currently animation-translated texture, or an empty string when invalid.
/// @param texnum Index identifying tex.
function RGL_TextureName(texnum)
  if not RGL_IsSeq(textures) then return "" end if
  texnum = RGL_ResolveTextureNum(texnum)
  if texnum < 0 or texnum >= len(textures) then return "" end if
  t = textures[texnum]
  if t is void or typeof(t.name) != "string" then return "" end if
  return t.name
end function

/// Returns the translated texture's positive pixel width, with a 64-pixel fallback.
/// @param texnum Index identifying tex.
function RGL_TextureWidth(texnum)
  texnum = RGL_ResolveTextureNum(texnum)
  if not RGL_IsSeq(textures) or texnum < 0 or texnum >= len(textures) then return 64 end if
  t = textures[texnum]
  if t is void or typeof(t.width) != "int" or t.width <= 0 then return 64 end if
  return t.width
end function

/// Returns the translated texture's positive pixel height, with a 64-pixel fallback.
/// @param texnum Index identifying tex.
function RGL_TextureHeight(texnum)
  texnum = RGL_ResolveTextureNum(texnum)
  if not RGL_IsSeq(textures) or texnum < 0 or texnum >= len(textures) then return 64 end if
  t = textures[texnum]
  if t is void or typeof(t.height) != "int" or t.height <= 0 then return 64 end if
  return t.height
end function

/// Resolves animation, uploads a repeat-wrapped opaque wall texture once, and caches its GL id by texture
/// number.
/// @param texnum Index identifying tex.
function RGL_TextureIdForTexnum(texnum)
  global rgl_texnum_tex_ids
  if typeof(texnum) != "int" or texnum < 0 then return 0 end if
  texnum = RGL_ResolveTextureNum(texnum)
  if texnum < 0 then return 0 end if
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

/// Resolves animation, uploads a repeat-wrapped cutout wall texture once, and caches its GL id separately.
/// @param texnum Index identifying tex.
function RGL_TextureIdForTexnumTransparent(texnum)
  global rgl_texnum_trans_tex_ids
  if typeof(texnum) != "int" or texnum < 0 then return 0 end if
  texnum = RGL_ResolveTextureNum(texnum)
  if texnum < 0 then return 0 end if
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

/// Resolves flat animation, uploads the named repeat-wrapped flat once, and caches its GL texture id.
/// @param flatnum Index identifying flat.
function RGL_TextureIdForFlatnum(flatnum)
  global rgl_flat_tex_ids
  if typeof(flatnum) != "int" or flatnum < 0 then return 0 end if
  flatnum = RGL_ResolveFlatNum(flatnum)
  if flatnum < 0 then return 0 end if
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

/// Loads a sprite/patch lump as a clamped cutout texture and caches its GL id by relative sprite lump.
/// @param lump Lump value supplied to `RGL_TextureIdForSpriteLump`.
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

/// Returns a neutral alpha-mask texture for shadow/fuzz sprite billboards.
/// @param lump Lump value supplied to `RGL_TextureIdForSpriteFuzzLump`.
function RGL_TextureIdForSpriteFuzzLump(lump)
  global rgl_sprite_fuzz_tex_ids
  if typeof(lump) != "int" or lump < 0 then return 0 end if
  while len(rgl_sprite_fuzz_tex_ids) <= lump
    rgl_sprite_fuzz_tex_ids = rgl_sprite_fuzz_tex_ids +[-1]
  end while
  cached = rgl_sprite_fuzz_tex_ids[lump]
  if typeof(cached) == "int" and cached >= 0 then return cached end if
  name = RGL_LumpNameAt(firstspritelump + lump)
  if name == "" then
    rgl_sprite_fuzz_tex_ids[lump] = 0
    return 0
  end if
  entry = RU_GetSprite(name)
  if entry is void then entry = RU_GetPatch(name) end if
  if entry is void or typeof(entry.data) != "bytes" then
    rgl_sprite_fuzz_tex_ids[lump] = 0
    return 0
  end if
  texid = 0
  if typeof(IGL_CreateFuzzMaskTexture) == "function" then
    texid = IGL_CreateFuzzMaskTexture(entry.data, entry.width, entry.height, true)
  end if
  rgl_sprite_fuzz_tex_ids[lump] = texid
  return texid
end function

/// Resolves a relative sprite lump to its upscaled sprite asset, falling back to the generic patch cache.
/// @param lump Lump value supplied to `RGL_SpriteEntryForLump`.
function RGL_SpriteEntryForLump(lump)
  name = RGL_LumpNameAt(firstspritelump + lump)
  if name == "" then return void end if
  entry = RU_GetSprite(name)
  if entry is void then entry = RU_GetPatch(name) end if
  return entry
end function

/// Binds and enables a valid texture id, otherwise disables texturing so caller colors remain visible.
/// @param texid Texid value supplied to `RGL_BindOrColor`.
function RGL_BindOrColor(texid)
  if texid > 0 then
    glEnable(GL_TEXTURE_2D)
    glBindTexture(GL_TEXTURE_2D, texid)
    return true
  end if
  glDisable(GL_TEXTURE_2D)
  return false
end function

/// Enables alpha testing and rejects texels whose alpha does not exceed the 0.5 cutout threshold.
function RGL_EnableCutoutAlpha()
  glEnable(GL_ALPHA_TEST)
  glAlphaFunc(GL_GREATER, 0.5)
end function

/// Disables alpha testing after masked wall or sprite rendering.
function RGL_DisableCutoutAlpha()
  glDisable(GL_ALPHA_TEST)
end function

/// Reads a sidedef's fixed vertical texture offset, defaulting to zero.
/// @param side Map side affected by the operation.
function inline RGL_SideRowOffset(side)
  if side is not void and typeof(side.rowoffset) == "int" then return side.rowoffset end if
  return 0
end function

/// Returns a texture height in Doom fixed-point units from textureheight or pixel metadata fallback.
/// @param texnum Index identifying tex.
function RGL_TextureHeightFixed(texnum)
  if RGL_IsSeq(textureheight) and texnum >= 0 and texnum < len(textureheight) then return textureheight[texnum] end if
  return RGL_TextureHeight(texnum) * FRACUNIT
end function

/// Computes the upper wall texture origin from pegging flags, adjacent ceilings, texture height, and row
/// offset.
/// @param linedef Linedef value supplied to `RGL_UpperTextureMid`.
/// @param texnum Index identifying tex.
/// @param side Map side affected by the operation.
/// @param front Front value supplied to `RGL_UpperTextureMid`.
/// @param back Back value supplied to `RGL_UpperTextureMid`.
function RGL_UpperTextureMid(linedef, texnum, side, front, back)
  yoff = RGL_SideRowOffset(side)
  if linedef is not void and typeof(linedef.flags) == "int" and(linedef.flags & ML_DONTPEGTOP) != 0 then
    return front.ceilingheight + yoff
  end if
  if back is not void then return back.ceilingheight + RGL_TextureHeightFixed(texnum) + yoff end if
  return front.ceilingheight + yoff
end function

/// Computes the lower wall texture origin from pegging flags, adjacent floors/ceiling, texture height, and row
/// offset.
/// @param linedef Linedef value supplied to `RGL_LowerTextureMid`.
/// @param texnum Index identifying tex.
/// @param side Map side affected by the operation.
/// @param front Front value supplied to `RGL_LowerTextureMid`.
/// @param back Back value supplied to `RGL_LowerTextureMid`.
function RGL_LowerTextureMid(linedef, texnum, side, front, back)
  yoff = RGL_SideRowOffset(side)
  if linedef is not void and typeof(linedef.flags) == "int" and(linedef.flags & ML_DONTPEGBOTTOM) != 0 then
    return front.ceilingheight + yoff
  end if
  if back is not void then return back.floorheight + yoff end if
  return front.floorheight + RGL_TextureHeightFixed(texnum) + yoff
end function

/// Computes one- or two-sided middle-texture origin according to bottom pegging and the visible opening bounds.
/// @param linedef Linedef value supplied to `RGL_MidTextureMid`.
/// @param texnum Index identifying tex.
/// @param side Map side affected by the operation.
/// @param front Front value supplied to `RGL_MidTextureMid`.
/// @param back Back value supplied to `RGL_MidTextureMid`.
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

/// Uses a wall span's top plus sidedef row offset as the default vertical texture origin.
/// @param z1 Z1 value supplied to `RGL_DefaultTextureMid`.
/// @param side Map side affected by the operation.
function RGL_DefaultTextureMid(z1, side)
  return z1 + RGL_SideRowOffset(side)
end function

/// Converts a wall span to a lit textured quad, preserving its BSP-seg texture origin, and appends it to the
/// active wall, masked, or sky-boundary cache.
/// @param v1 V1 value supplied to `RGL_AddCachedWallQuad`.
/// @param v2 V2 value supplied to `RGL_AddCachedWallQuad`.
/// @param z0 Z0 value supplied to `RGL_AddCachedWallQuad`.
/// @param z1 Z1 value supplied to `RGL_AddCachedWallQuad`.
/// @param texnum Index identifying tex.
/// @param side Map side affected by the operation.
/// @param transparent Transparent value supplied to `RGL_AddCachedWallQuad`.
/// @param texturemid Texturemid value supplied to `RGL_AddCachedWallQuad`.
/// @param wallOffset Wall offset value supplied to `RGL_AddCachedWallQuad`.
function RGL_AddCachedWallQuad(v1, v2, z0, z1, texnum, side, transparent, texturemid, wallOffset)
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
  if typeof(wallOffset) == "float" or typeof(wallOffset) == "int" then xoff = xoff + wallOffset end if
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

/// Draws cached quads in texture/alpha groups, minimizing binds and glBegin/glEnd boundaries.
/// @param quads Quads value supplied to `RGL_DrawCachedTexturedQuads`.
function RGL_DrawCachedTexturedQuads(quads)
  if not RGL_IsSeq(quads) then return end if
  active = false
  lastTex = -2147483648
  lastTransparent = false
  textured = false
  i = 0
  while i < len(quads)
    q = quads[i]
    if q is not void then
      if (not active) or q.texnum != lastTex or q.transparent != lastTransparent then
        if active then glEnd() end if
        texid = RGL_TextureIdForTexnum(q.texnum)
        if q.transparent then texid = RGL_TextureIdForTexnumTransparent(q.texnum) end if
        textured = RGL_BindOrColor(texid)
        if q.transparent then
          RGL_EnableCutoutAlpha()
        else
          RGL_DisableCutoutAlpha()
        end if
        glBegin(GL_QUADS)
        active = true
        lastTex = q.texnum
        lastTransparent = q.transparent
      end if
      if textured then glTexCoord2d(q.s0, q.t0) end if
      RGL_StaticVertexLit(q.light, q.x0, q.y0, q.z0)
      if textured then glTexCoord2d(q.s1, q.t1) end if
      RGL_StaticVertexLit(q.light, q.x1, q.y1, q.z1)
      if textured then glTexCoord2d(q.s2, q.t2) end if
      RGL_StaticVertexLit(q.light, q.x2, q.y2, q.z2)
      if textured then glTexCoord2d(q.s3, q.t3) end if
      RGL_StaticVertexLit(q.light, q.x3, q.y3, q.z3)
    end if
    i = i + 1
  end while
  if active then glEnd() end if
  RGL_DisableCutoutAlpha()
end function

/// Compiles static textured quad lists that still use the immediate-mode fallback path.
/// @param quads Quads value supplied to `RGL_CompileTexturedQuadDisplayList`.
function RGL_CompileTexturedQuadDisplayList(quads)
  if not RGL_IsSeq(quads) or len(quads) <= 0 then return 0 end if
  id = glGenLists(1)
  if id == 0 then return 0 end if
  glNewList(id, GL_COMPILE)
  RGL_DrawCachedTexturedQuads(quads)
  glEndList()
  return id
end function

/// Draws cached sky boundary quads through a compiled OpenGL display list.
function RGL_DrawBoundaryQuads()
  global rgl_boundary_display_list_id

  if rgl_boundary_display_list_id == 0 then
    rgl_boundary_display_list_id = RGL_CompileTexturedQuadDisplayList(rgl_boundary_quads)
  end if
  if rgl_boundary_display_list_id != 0 then
    glCallList(rgl_boundary_display_list_id)
  else
    RGL_DrawCachedTexturedQuads(rgl_boundary_quads)
  end if
end function

/// Draws cached masked midtexture quads through a compiled OpenGL display list.
function RGL_DrawMaskedQuads()
  global rgl_masked_display_list_id

  if rgl_masked_display_list_id == 0 then
    rgl_masked_display_list_id = RGL_CompileTexturedQuadDisplayList(rgl_masked_quads)
  end if
  if rgl_masked_display_list_id != 0 then
    glCallList(rgl_masked_display_list_id)
  else
    RGL_DrawCachedTexturedQuads(rgl_masked_quads)
  end if
end function

/// Caches or immediately draws a wall span with its sidedef-plus-seg horizontal origin and an explicit vertical
/// texture origin.
/// @param v1 V1 value supplied to `RGL_DrawWallQuadTexMid`.
/// @param v2 V2 value supplied to `RGL_DrawWallQuadTexMid`.
/// @param z0 Z0 value supplied to `RGL_DrawWallQuadTexMid`.
/// @param z1 Z1 value supplied to `RGL_DrawWallQuadTexMid`.
/// @param texnum Index identifying tex.
/// @param side Map side affected by the operation.
/// @param transparent Transparent value supplied to `RGL_DrawWallQuadTexMid`.
/// @param texturemid Texturemid value supplied to `RGL_DrawWallQuadTexMid`.
/// @param wallOffset Wall offset value supplied to `RGL_DrawWallQuadTexMid`.
function RGL_DrawWallQuadTexMid(v1, v2, z0, z1, texnum, side, transparent, texturemid, wallOffset)
  if v1 is void or v2 is void then return end if
  if z1 <= z0 then return end if
  if typeof(texnum) != "int" or texnum == 0 then return end if
  if rgl_building_cache then
    RGL_AddCachedWallQuad(v1, v2, z0, z1, texnum, side, transparent, texturemid, wallOffset)
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
  if typeof(wallOffset) == "float" or typeof(wallOffset) == "int" then xoff = xoff + wallOffset end if
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

/// Draws an opaque or cutout wall span using the default top-plus-row-offset texture origin.
/// @param v1 V1 value supplied to `RGL_DrawWallQuadEx`.
/// @param v2 V2 value supplied to `RGL_DrawWallQuadEx`.
/// @param z0 Z0 value supplied to `RGL_DrawWallQuadEx`.
/// @param z1 Z1 value supplied to `RGL_DrawWallQuadEx`.
/// @param texnum Index identifying tex.
/// @param side Map side affected by the operation.
/// @param transparent Transparent value supplied to `RGL_DrawWallQuadEx`.
function RGL_DrawWallQuadEx(v1, v2, z0, z1, texnum, side, transparent)
  RGL_DrawWallQuadTexMid(v1, v2, z0, z1, texnum, side, transparent, RGL_DefaultTextureMid(z1, side), 0.0)
end function

/// Draws a generic wall quad while adding an oriented BSP-seg distance to the sidedef texture offset.
/// @param v1 V1 value supplied to `RGL_DrawWallQuadOffset`.
/// @param v2 V2 value supplied to `RGL_DrawWallQuadOffset`.
/// @param z0 Z0 value supplied to `RGL_DrawWallQuadOffset`.
/// @param z1 Z1 value supplied to `RGL_DrawWallQuadOffset`.
/// @param texnum Index identifying tex.
/// @param side Map side affected by the operation.
/// @param wallOffset Wall offset value supplied to `RGL_DrawWallQuadOffset`.
function RGL_DrawWallQuadOffset(v1, v2, z0, z1, texnum, side, wallOffset)
  RGL_DrawWallQuadTexMid(v1, v2, z0, z1, texnum, side, false, RGL_DefaultTextureMid(z1, side), wallOffset)
end function

/// Draws an opaque wall span through the common quad path.
/// @param v1 V1 value supplied to `RGL_DrawWallQuad`.
/// @param v2 V2 value supplied to `RGL_DrawWallQuad`.
/// @param z0 Z0 value supplied to `RGL_DrawWallQuad`.
/// @param z1 Z1 value supplied to `RGL_DrawWallQuad`.
/// @param texnum Index identifying tex.
/// @param side Map side affected by the operation.
function RGL_DrawWallQuad(v1, v2, z0, z1, texnum, side)
  RGL_DrawWallQuadEx(v1, v2, z0, z1, texnum, side, false)
end function

/// Computes a two-sided middle texture's pegged bounds and draws it as an offset-preserving cutout quad.
/// @param v1 V1 value supplied to `RGL_DrawMaskedMidtexture`.
/// @param v2 V2 value supplied to `RGL_DrawMaskedMidtexture`.
/// @param linedef Linedef value supplied to `RGL_DrawMaskedMidtexture`.
/// @param side Map side affected by the operation.
/// @param front Front value supplied to `RGL_DrawMaskedMidtexture`.
/// @param back Back value supplied to `RGL_DrawMaskedMidtexture`.
/// @param wallOffset Wall offset value supplied to `RGL_DrawMaskedMidtexture`.
function RGL_DrawMaskedMidtexture(v1, v2, linedef, side, front, back, wallOffset)
  if v1 is void or v2 is void or side is void or front is void or back is void then return end if
  if typeof(side.midtexture) != "int" or side.midtexture == 0 then return end if

  texnum = side.midtexture
  texh = RGL_TextureHeightFixed(texnum)
  top = RGL_MidTextureMid(linedef, texnum, side, front, back)
  bottom = top - texh
  RGL_DrawWallQuadTexMid(v1, v2, bottom, top, texnum, side, true, top, wallOffset)
end function

/// Returns a seg's map-authored texture distance, or the complementary distance when drawing the opposite
/// orientation.
/// @param sg Sg value supplied to `RGL_SegTextureOffset`.
/// @param opposite Opposite value supplied to `RGL_SegTextureOffset`.
function RGL_SegTextureOffset(sg, opposite)
  if sg is void then return 0.0 end if
  offset = 0.0
  if typeof(sg.offset) == "int" then offset = RGL_FixedToFloat(sg.offset) end if
  if not opposite then return offset end if
  if sg.linedef is void or sg.linedef.v1 is void or sg.linedef.v2 is void or sg.v1 is void or sg.v2 is void then return 0.0 end if

  ldx = RGL_FixedToFloat(sg.linedef.v2.x - sg.linedef.v1.x)
  ldy = RGL_FixedToFloat(sg.linedef.v2.y - sg.linedef.v1.y)
  sdx = RGL_FixedToFloat(sg.v2.x - sg.v1.x)
  sdy = RGL_FixedToFloat(sg.v2.y - sg.v1.y)
  remaining = std.math.sqrt(ldx * ldx + ldy * ldy) - offset - std.math.sqrt(sdx * sdx + sdy * sdy)
  if remaining < 0.0 then return 0.0 end if
  return remaining
end function

/// Resolves the sidedef opposite a known line side, with validation of both sidenum entries.
/// @param linedef Linedef value supplied to `RGL_OppositeSide`.
/// @param side Map side affected by the operation.
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

/// Returns a preferred sidedef when present, otherwise the caller-supplied fallback.
/// @param side Map side affected by the operation.
/// @param fallback Value returned when the requested conversion or lookup is unavailable.
function inline RGL_SideOrFallback(side, fallback)
  if side is not void then return side end if
  return fallback
end function

/// Reads a sidedef's upper texture number, returning zero for missing data.
/// @param side Map side affected by the operation.
function inline RGL_TopTextureOrZero(side)
  if side is not void and typeof(side.toptexture) == "int" then return side.toptexture end if
  return 0
end function

/// Reads a sidedef's lower texture number, returning zero for missing data.
/// @param side Map side affected by the operation.
function inline RGL_BottomTextureOrZero(side)
  if side is not void and typeof(side.bottomtexture) == "int" then return side.bottomtexture end if
  return 0
end function

/// Reads a sidedef's middle texture number, returning zero for missing data.
/// @param side Map side affected by the operation.
function inline RGL_MidTextureOrZero(side)
  if side is not void and typeof(side.midtexture) == "int" then return side.midtexture end if
  return 0
end function

/// Chooses a nonzero step texture from the requested slot, opposite side tiers, then either middle texture.
/// @param tex Texture identifier or texture data to process.
/// @param side Map side affected by the operation.
/// @param otherSide Other side value supplied to `RGL_FallbackStepTexture`.
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

/// Draws a one-sided middle wall or adjacent-sector steps with pegging, light, and the parent linedef's
/// continuous horizontal UV origin.
/// @param v1 V1 value supplied to `RGL_DrawWallPiece`.
/// @param v2 V2 value supplied to `RGL_DrawWallPiece`.
/// @param linedef Linedef value supplied to `RGL_DrawWallPiece`.
/// @param side Map side affected by the operation.
/// @param front Front value supplied to `RGL_DrawWallPiece`.
/// @param back Back value supplied to `RGL_DrawWallPiece`.
/// @param wallOffset Wall offset value supplied to `RGL_DrawWallPiece`.
function RGL_DrawWallPiece(v1, v2, linedef, side, front, back, wallOffset)
  global rgl_current_light

  if v1 is void or v2 is void then return end if
  if front is void then return end if

  c = RGL_LightByte(front)
  rgl_current_light = c
  glColor3ub(c, c, c)

  if back is void then
    tex = 0
    if side is not void and typeof(side.midtexture) == "int" then tex = side.midtexture end if
    RGL_DrawWallQuadTexMid(v1, v2, front.floorheight, front.ceilingheight, tex, side, false, RGL_MidTextureMid(linedef, tex, side, front, void), wallOffset)
    return
  end if

  otherSide = RGL_OppositeSide(linedef, side)

  skyCeilingPortal = false
  if front.ceilingpic == skyflatnum and back.ceilingpic == skyflatnum then skyCeilingPortal = true end if

  if (not skyCeilingPortal) and back.ceilingheight < front.ceilingheight then
    tex = RGL_FallbackStepTexture(RGL_TopTextureOrZero(side), side, otherSide)
    RGL_DrawWallQuadTexMid(v1, v2, back.ceilingheight, front.ceilingheight, tex, side, false, RGL_UpperTextureMid(linedef, tex, side, front, back), wallOffset)
  end if
  if back.floorheight > front.floorheight then
    tex = RGL_FallbackStepTexture(RGL_BottomTextureOrZero(side), side, otherSide)
    RGL_DrawWallQuadTexMid(v1, v2, front.floorheight, back.floorheight, tex, side, false, RGL_LowerTextureMid(linedef, tex, side, front, back), wallOffset)
  end if
end function

/// Resolves a linedef's front side and draws its opaque spans unless assigned to scrolling or volatile caches.
/// @param li Li value supplied to `RGL_DrawLine`.
function RGL_DrawLine(li)
  if li is void then return end if
  if rgl_building_cache and not rgl_collecting_scrolling_geometry and RGL_LineScrollsTexture(li) then return end if
  if rgl_building_cache and not rgl_collecting_volatile_geometry and not rgl_collecting_scrolling_geometry then
    if RGL_IsVolatileSector(li.frontsector) or RGL_IsVolatileSector(li.backsector) then return end if
  end if
  side = void
  if RGL_IsSeq(sides) and RGL_IsSeq(li.sidenum) and len(li.sidenum) > 0 then
    sid = li.sidenum[0]
    if typeof(sid) == "int" and sid >= 0 and sid < len(sides) then side = sides[sid] end if
  end if
  RGL_DrawWallPiece(li.v1, li.v2, li, side, li.frontsector, li.backsector, 0.0)
end function

/// Draws an oriented BSP seg's opaque spans unless the seg belongs to scrolling or volatile geometry.
/// @param sg Sg value supplied to `RGL_DrawSeg`.
function RGL_DrawSeg(sg)
  if sg is void then return end if
  if rgl_building_cache and not rgl_collecting_scrolling_geometry and RGL_LineScrollsTexture(sg.linedef) then return end if
  if rgl_building_cache and not rgl_collecting_volatile_geometry and not rgl_collecting_scrolling_geometry then
    if RGL_IsVolatileSector(sg.frontsector) or RGL_IsVolatileSector(sg.backsector) then return end if
  end if
  RGL_DrawWallPiece(sg.v1, sg.v2, sg.linedef, sg.sidedef, sg.frontsector, sg.backsector, RGL_SegTextureOffset(sg, false))
end function

/// Draws every BSP seg, falling back to linedefs when a seg table is unavailable.
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

/// Draws cutout middle textures on each populated side of a two-sided seg using that side's sector light.
/// @param sg Sg value supplied to `RGL_DrawMaskedSeg`.
function RGL_DrawMaskedSeg(sg)
  global rgl_current_light

  if sg is void then return end if
  if rgl_building_cache and not rgl_collecting_scrolling_geometry and RGL_LineScrollsTexture(sg.linedef) then return end if
  if rgl_building_cache and not rgl_collecting_volatile_geometry and not rgl_collecting_scrolling_geometry then
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
  RGL_DrawMaskedMidtexture(sg.v1, sg.v2, sg.linedef, sg.sidedef, sg.frontsector, sg.backsector, RGL_SegTextureOffset(sg, false))
  if sg.backsector is not void then
    if oside is not void then
      c = RGL_LightByte(sg.backsector)
      rgl_current_light = c
      glColor4ub(c, c, c, 255)
      RGL_DrawMaskedMidtexture(sg.v2, sg.v1, sg.linedef, oside, sg.backsector, sg.frontsector, RGL_SegTextureOffset(sg, true))
    end if
  end if
end function

/// Traverses every seg and draws its eligible cutout middle-texture surfaces.
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

/// Resolves and draws one oriented side of a two-sided linedef's cutout middle texture.
/// @param li Li value supplied to `RGL_DrawLineSideMidtexture`.
/// @param sideIndex Index identifying side.
function RGL_DrawLineSideMidtexture(li, sideIndex)
  global rgl_current_light

  if li is void or li.v1 is void or li.v2 is void then return end if
  if rgl_building_cache and not rgl_collecting_scrolling_geometry and RGL_LineScrollsTexture(li) then return end if
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
    RGL_DrawMaskedMidtexture(li.v1, li.v2, li, side, front, back, 0.0)
  else
    RGL_DrawMaskedMidtexture(li.v2, li.v1, li, side, front, back, 0.0)
  end if
end function

/// For maps without segs, emits both eligible middle-texture sides of every two-sided linedef.
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

/// Fills the ceiling-height step where a seg crosses between sky and non-sky sectors, drawing both orientations
/// if textured.
/// @param sg Sg value supplied to `RGL_DrawSkyInteriorBoundarySeg`.
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
  RGL_DrawWallQuadOffset(sg.v1, sg.v2, z0, z1, tex, sg.sidedef, RGL_SegTextureOffset(sg, false))

  if otherSide is not void then
    tex = RGL_TopTextureOrZero(otherSide)
    tex = RGL_FallbackStepTexture(tex, otherSide, sg.sidedef)
    if tex != 0 then
      c = RGL_LightByte(sg.backsector)
      rgl_current_light = c
      glColor3ub(c, c, c)
      RGL_DrawWallQuadOffset(sg.v2, sg.v1, z0, z1, tex, otherSide, RGL_SegTextureOffset(sg, true))
    end if
  end if
end function

/// Finds segs whose adjacent sectors disagree on sky ceiling and draws their textured interior height steps.
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

/// No-seg fallback that draws both oriented textured ceiling steps across a sky/non-sky linedef.
/// @param li Li value supplied to `RGL_DrawSkyInteriorBoundaryLine`.
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

/// Traverses linedefs and draws sky/non-sky ceiling steps when BSP seg boundaries are unavailable.
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

/// Adds or draws a tall depth-only quad above a sky-ceiling seg so later sky pixels respect world occlusion.
/// @param sg Sg value supplied to `RGL_DrawSkyPortalSeg`.
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

/// Writes depth-only portal quads for every sky-adjacent BSP seg while preserving depth writes.
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

/// Computes the signed 2D cross product of three fixed-point map coordinates in float space.
/// @param ax Horizontal coordinate or vector component represented by ax.
/// @param ay Vertical coordinate or vector component represented by ay.
/// @param bx Horizontal coordinate or vector component represented by bx.
/// @param by Vertical coordinate or vector component represented by by.
/// @param cx Horizontal coordinate or vector component represented by cx.
/// @param cy Vertical coordinate or vector component represented by cy.
function inline RGL_CrossFixed(ax, ay, bx, by, cx, cy)
  return(RGL_FixedToFloat(bx) - RGL_FixedToFloat(ax)) *(RGL_FixedToFloat(cy) - RGL_FixedToFloat(ay)) -(RGL_FixedToFloat(by) - RGL_FixedToFloat(ay)) *(RGL_FixedToFloat(cx) - RGL_FixedToFloat(ax))
end function

/// Tests whether a fixed-point point lies inside or on a triangle using sign-consistent edge cross products.
/// @param px Horizontal coordinate or vector component represented by px.
/// @param py Vertical coordinate or vector component represented by py.
/// @param ax Horizontal coordinate or vector component represented by ax.
/// @param ay Vertical coordinate or vector component represented by ay.
/// @param bx Horizontal coordinate or vector component represented by bx.
/// @param by Vertical coordinate or vector component represented by by.
/// @param cx Horizontal coordinate or vector component represented by cx.
/// @param cy Vertical coordinate or vector component represented by cy.
function RGL_PointInTriangle(px, py, ax, ay, bx, by, cx, cy)
  c1 = RGL_CrossFixed(px, py, ax, ay, bx, by)
  c2 = RGL_CrossFixed(px, py, bx, by, cx, cy)
  c3 = RGL_CrossFixed(px, py, cx, cy, ax, ay)
  hasNeg = c1 < -0.00001 or c2 < -0.00001 or c3 < -0.00001
  hasPos = c1 > 0.00001 or c2 > 0.00001 or c3 > 0.00001
  return not(hasNeg and hasPos)
end function

/// Emits one lit flat triangle with 64-unit repeating UV coordinates when texturing is active.
/// @param pxs Pxs value supplied to `RGL_DrawFlatTriangle`.
/// @param pys Pys value supplied to `RGL_DrawFlatTriangle`.
/// @param a First input operand.
/// @param b Second input operand.
/// @param c C value supplied to `RGL_DrawFlatTriangle`.
/// @param zz Zz value supplied to `RGL_DrawFlatTriangle`.
/// @param textured Textured value supplied to `RGL_DrawFlatTriangle`.
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

/// Triangulates and draws a simple fixed-point polygon by orientation-aware ear clipping, returning whether any
/// ear emitted.
/// @param pxs Pxs value supplied to `RGL_DrawFlatPolygonEarClipped`.
/// @param pys Pys value supplied to `RGL_DrawFlatPolygonEarClipped`.
/// @param count Number of elements or iterations to process.
/// @param zz Zz value supplied to `RGL_DrawFlatPolygonEarClipped`.
/// @param textured Textured value supplied to `RGL_DrawFlatPolygonEarClipped`.
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

/// Reconstructs a subsector polygon from unique seg endpoints, angle-sorts it, and draws an ear-clipped or fan
/// flat.
/// @param ss Ss value supplied to `RGL_DrawSubsectorFlat`.
/// @param z Vertical world-space coordinate.
/// @param flatnum Index identifying flat.
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

/// Draws floor and ceiling polygons for every subsector using the owning sector's flat ids and static light.
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

/// Fan-triangulates a validated convex polygon and appends lit, textured floor/ceiling triangles to the flat
/// cache.
/// @param xs Xs value supplied to `RGL_AddCachedFlatConvexFloat`.
/// @param ys Ys value supplied to `RGL_AddCachedFlatConvexFloat`.
/// @param count Number of elements or iterations to process.
/// @param z Vertical world-space coordinate.
/// @param flatnum Index identifying flat.
function RGL_AddCachedFlatConvexFloat(xs, ys, count, z, flatnum)
  global rgl_flat_tris

  if typeof(flatnum) != "int" then return end if
  if not RGL_IsNumber(z) then return end if
  if not RGL_IsSeq(xs) or not RGL_IsSeq(ys) then return end if
  if count < 3 or len(xs) < count or len(ys) < count then return end if
  zz = RGL_FixedToFloat(z)
  baseX = xs[0]
  baseY = ys[0]
  if not RGL_IsNumber(baseX) or not RGL_IsNumber(baseY) then return end if
  i = 1
  while i < count - 1
    x1 = xs[i]
    y1 = ys[i]
    x2 = xs[i + 1]
    y2 = ys[i + 1]
    if RGL_IsNumber(x1) and RGL_IsNumber(y1) and RGL_IsNumber(x2) and RGL_IsNumber(y2) then
      rgl_flat_tris = rgl_flat_tris +[rgl_flat_tri_t(flatnum, rgl_current_light,
        baseX, zz, -baseY, baseX / 64.0, baseY / 64.0,
        x1, zz, -y1, x1 / 64.0, y1 / 64.0,
        x2, zz, -y2, x2 / 64.0, y2 / 64.0)]
    end if
    i = i + 1
  end while
end function

/// Draws cached floor/ceiling triangles grouped by flat id to reduce texture binds and immediate-mode
/// boundaries.
function RGL_DrawCachedFlatTris()
  if not RGL_IsSeq(rgl_flat_tris) then return end if
  active = false
  lastFlat = -2147483648
  textured = false
  i = 0
  while i < len(rgl_flat_tris)
    t = rgl_flat_tris[i]
    if t is not void then
      if (not active) or t.flatnum != lastFlat then
        if active then glEnd() end if
        textured = RGL_BindOrColor(RGL_TextureIdForFlatnum(t.flatnum))
        glBegin(GL_TRIANGLES)
        active = true
        lastFlat = t.flatnum
      end if
      if textured then glTexCoord2d(t.s0, t.t0) end if
      RGL_VertexLit(t.light, t.x0, t.y0, t.z0)
      if textured then glTexCoord2d(t.s1, t.t1) end if
      RGL_VertexLit(t.light, t.x1, t.y1, t.z1)
      if textured then glTexCoord2d(t.s2, t.t2) end if
      RGL_VertexLit(t.light, t.x2, t.y2, t.z2)
    end if
    i = i + 1
  end while
  if active then glEnd() end if
end function

/// Compiles a contiguous wall-quad texture group into one OpenGL display list.
/// @param startIndex Index identifying start.
/// @param endIndex Index identifying end.
function RGL_CompileWallDisplayListRange(startIndex, endIndex)
  id = glGenLists(1)
  if id == 0 then return 0 end if
  glNewList(id, GL_COMPILE)
  glBegin(GL_QUADS)
  i = startIndex
  while i < endIndex
    q = rgl_wall_quads[i]
    if q is not void then
      glTexCoord2d(q.s0, q.t0)
      RGL_StaticVertexLit(q.light, q.x0, q.y0, q.z0)
      glTexCoord2d(q.s1, q.t1)
      RGL_StaticVertexLit(q.light, q.x1, q.y1, q.z1)
      glTexCoord2d(q.s2, q.t2)
      RGL_StaticVertexLit(q.light, q.x2, q.y2, q.z2)
      glTexCoord2d(q.s3, q.t3)
      RGL_StaticVertexLit(q.light, q.x3, q.y3, q.z3)
    end if
    i = i + 1
  end while
  glEnd()
  glEndList()
  return id
end function

/// Compiles a contiguous flat-triangle texture group into one OpenGL display list.
/// @param startIndex Index identifying start.
/// @param endIndex Index identifying end.
function RGL_CompileFlatDisplayListRange(startIndex, endIndex)
  id = glGenLists(1)
  if id == 0 then return 0 end if
  glNewList(id, GL_COMPILE)
  glBegin(GL_TRIANGLES)
  i = startIndex
  while i < endIndex
    t = rgl_flat_tris[i]
    if t is not void then
      glTexCoord2d(t.s0, t.t0)
      RGL_StaticVertexLit(t.light, t.x0, t.y0, t.z0)
      glTexCoord2d(t.s1, t.t1)
      RGL_StaticVertexLit(t.light, t.x1, t.y1, t.z1)
      glTexCoord2d(t.s2, t.t2)
      RGL_StaticVertexLit(t.light, t.x2, t.y2, t.z2)
    end if
    i = i + 1
  end while
  glEnd()
  glEndList()
  return id
end function

/// Builds per-texture OpenGL display lists for static opaque world geometry.
function RGL_BuildStaticDisplayLists()
  global rgl_wall_display_list_texnums
  global rgl_wall_display_list_transparents
  global rgl_wall_display_list_ids
  global rgl_flat_display_list_flatnums
  global rgl_flat_display_list_ids
  global rgl_static_display_lists_ready

  if rgl_static_display_lists_ready then return true end if
  RGL_DeleteStaticDisplayLists()

  if RGL_IsSeq(rgl_wall_quads) then
    i = 0
    while i < len(rgl_wall_quads)
      q = rgl_wall_quads[i]
      if q is void then
        i = i + 1
      else
        texnum = q.texnum
        transparent = q.transparent
        startIndex = i
        i = i + 1
        while i < len(rgl_wall_quads)
          n = rgl_wall_quads[i]
          if n is void or n.texnum != texnum or n.transparent != transparent then
            break
          end if
          i = i + 1
        end while
        id = RGL_CompileWallDisplayListRange(startIndex, i)
        if id != 0 then
          rgl_wall_display_list_texnums = rgl_wall_display_list_texnums +[texnum]
          rgl_wall_display_list_transparents = rgl_wall_display_list_transparents +[transparent]
          rgl_wall_display_list_ids = rgl_wall_display_list_ids +[id]
        end if
      end if
    end while
  end if

  if RGL_IsSeq(rgl_flat_tris) then
    i = 0
    while i < len(rgl_flat_tris)
      t = rgl_flat_tris[i]
      if t is void then
        i = i + 1
      else
        flatnum = t.flatnum
        startIndex = i
        i = i + 1
        while i < len(rgl_flat_tris)
          n = rgl_flat_tris[i]
          if n is void or n.flatnum != flatnum then
            break
          end if
          i = i + 1
        end while
        id = RGL_CompileFlatDisplayListRange(startIndex, i)
        if id != 0 then
          rgl_flat_display_list_flatnums = rgl_flat_display_list_flatnums +[flatnum]
          rgl_flat_display_list_ids = rgl_flat_display_list_ids +[id]
        end if
      end if
    end while
  end if

  rgl_static_display_lists_ready = true
  return true
end function

/// Draws static wall display-list batches with current animated texture bindings.
function RGL_DrawWallDisplayLists()
  if not RGL_BuildStaticDisplayLists() then
    RGL_DrawCachedTexturedQuads(rgl_wall_quads)
    return
  end if

  i = 0
  while i < len(rgl_wall_display_list_ids)
    texnum = rgl_wall_display_list_texnums[i]
    transparent = rgl_wall_display_list_transparents[i]
    texid = RGL_TextureIdForTexnum(texnum)
    if transparent then texid = RGL_TextureIdForTexnumTransparent(texnum) end if
    RGL_BindOrColor(texid)
    if transparent then RGL_EnableCutoutAlpha() else RGL_DisableCutoutAlpha() end if
    glCallList(rgl_wall_display_list_ids[i])
    i = i + 1
  end while
  RGL_DisableCutoutAlpha()
end function

/// Draws static flat display-list batches with current animated flat bindings.
function RGL_DrawFlatDisplayLists()
  if not RGL_BuildStaticDisplayLists() then
    RGL_DrawCachedFlatTris()
    return
  end if

  i = 0
  while i < len(rgl_flat_display_list_ids)
    flatnum = rgl_flat_display_list_flatnums[i]
    RGL_BindOrColor(RGL_TextureIdForFlatnum(flatnum))
    glCallList(rgl_flat_display_list_ids[i])
    i = i + 1
  end while
end function

/// Enables OpenGL client-array state for prepacked world geometry batches.
function RGL_BeginArrayBatchDraw()
  glEnableClientState(GL_VERTEX_ARRAY)
  glEnableClientState(GL_TEXTURE_COORD_ARRAY)
  glEnableClientState(GL_COLOR_ARRAY)
end function

/// Restores OpenGL client-array state after array batch rendering.
function RGL_EndArrayBatchDraw()
  glDisableClientState(GL_COLOR_ARRAY)
  glDisableClientState(GL_TEXTURE_COORD_ARRAY)
  glDisableClientState(GL_VERTEX_ARRAY)
  glColor4ub(255, 255, 255, 255)
end function

/// Applies fixed-point scaling for non-VBO client-array fallbacks.
function RGL_BeginFixedArrayScale()
  inv = 1.0 / RGL_GEOM_FIX_SCALE
  glMatrixMode(GL_MODELVIEW)
  glPushMatrix()
  glScaled(inv, inv, inv)
  glMatrixMode(GL_TEXTURE)
  glPushMatrix()
  glScaled(inv, inv, 1.0)
  glMatrixMode(GL_MODELVIEW)
end function

/// Restores matrices after non-VBO fixed-point fallback drawing.
function RGL_EndFixedArrayScale()
  glMatrixMode(GL_TEXTURE)
  glPopMatrix()
  glMatrixMode(GL_MODELVIEW)
  glPopMatrix()
end function

/// Draws one prepacked OpenGL client-array geometry batch.
/// @param batch Batch value supplied to `RGL_DrawStaticArrayBatch`.
/// @param mode Mode value supplied to `RGL_DrawStaticArrayBatch`.
function RGL_DrawStaticArrayBatch(batch, mode)
  if batch is void or batch.vertex_count <= 0 then return end if
  if batch.interleaved_vbo != 0 then
    MGL_DrawInterleavedBatch(mode, batch.interleaved_vbo, batch.vertex_count)
    return
  end if
  if batch.vertex_vbo != 0 and batch.texcoord_vbo != 0 and batch.color_vbo != 0 then
    RGL_BeginFixedArrayScale()
    MGL_DrawArrayBatch(mode, batch.vertex_vbo, batch.texcoord_vbo, batch.color_vbo, batch.vertex_count)
    RGL_EndFixedArrayScale()
    return
  end if
  RGL_BeginFixedArrayScale()
  glVertexPointer(3, GL_INT, 0, batch.vertices)
  glTexCoordPointer(2, GL_INT, 0, batch.texcoords)
  glColorPointer(4, GL_UNSIGNED_BYTE, 0, batch.colors)
  glDrawArrays(mode, 0, batch.vertex_count)
  RGL_EndFixedArrayScale()
end function

/// Conservatively rejects static geometry chunks outside the player view cone.
/// @param batch Batch value supplied to `RGL_ArrayBatchVisible`.
function RGL_ArrayBatchVisible(batch)
  if batch is void then return false end if
  yawRad = (rgl_view_yaw / 360.0) * 6.283185314
  fwdX = std.math.cos(yawRad)
  fwdY = std.math.sin(yawRad)
  dx = batch.cx - rgl_view_x
  dy = -batch.cz - rgl_view_y
  forward = dx * fwdX + dy * fwdY
  side = dx *(-fwdY) + dy * fwdX
  if side < 0.0 then side = -side end if
  r = batch.radius
  if forward + r < -128.0 then return false end if
  if forward > 64.0 then
    if side - r > forward * 1.25 + 384.0 then return false end if
  else
    if side - r > 640.0 then return false end if
  end if
  return true
end function

/// Draws static wall geometry using OpenGL client arrays.
function RGL_DrawWallArrayBatches()
  if not RGL_BuildStaticArrayBatches() or len(rgl_wall_array_batches) == 0 then
    RGL_DrawWallDisplayLists()
    return
  end if

  total = len(rgl_wall_array_batches)
  if rgl_wall_native_record_count == total and RGL_UpdateWallNativeRecordTextures() then
    RGL_BeginArrayBatchDraw()
    if MGL_DrawVisibleGeomBatches(GL_QUADS, rgl_wall_native_records, rgl_wall_native_record_count, rgl_view_x, rgl_view_y, rgl_view_yaw) then
      RGL_EndArrayBatchDraw()
      RGL_DisableCutoutAlpha()
      if typeof(_D_ProfileGLBatches) == "function" then _D_ProfileGLBatches(1, total, MGL_GetLastDrawnBatches(), MGL_GetLastDrawnVertices()) end if
      return
    end if
    RGL_EndArrayBatchDraw()
    RGL_DisableCutoutAlpha()
  end if

  RGL_BeginArrayBatchDraw()
  drawn = 0
  vertices = 0
  i = 0
  while i < len(rgl_wall_array_batches)
    batch = rgl_wall_array_batches[i]
    if RGL_ArrayBatchVisible(batch) then
      drawn = drawn + 1
      vertices = vertices + batch.vertex_count
      texid = RGL_TextureIdForTexnum(batch.texnum)
      if batch.transparent then texid = RGL_TextureIdForTexnumTransparent(batch.texnum) end if
      RGL_BindOrColor(texid)
      if batch.transparent then RGL_EnableCutoutAlpha() else RGL_DisableCutoutAlpha() end if
      RGL_DrawStaticArrayBatch(batch, GL_QUADS)
    end if
    i = i + 1
  end while
  RGL_EndArrayBatchDraw()
  RGL_DisableCutoutAlpha()
  if typeof(_D_ProfileGLBatches) == "function" then _D_ProfileGLBatches(1, total, drawn, vertices) end if
end function

/// Draws static floor and ceiling geometry using OpenGL client arrays.
function RGL_DrawFlatArrayBatches()
  if not RGL_BuildStaticArrayBatches() or len(rgl_flat_array_batches) == 0 then
    RGL_DrawFlatDisplayLists()
    return
  end if

  total = len(rgl_flat_array_batches)
  if rgl_flat_native_record_count == total and RGL_UpdateFlatNativeRecordTextures() then
    RGL_BeginArrayBatchDraw()
    if MGL_DrawVisibleGeomBatches(GL_TRIANGLES, rgl_flat_native_records, rgl_flat_native_record_count, rgl_view_x, rgl_view_y, rgl_view_yaw) then
      RGL_EndArrayBatchDraw()
      if typeof(_D_ProfileGLBatches) == "function" then _D_ProfileGLBatches(0, total, MGL_GetLastDrawnBatches(), MGL_GetLastDrawnVertices()) end if
      return
    end if
    RGL_EndArrayBatchDraw()
  end if

  RGL_BeginArrayBatchDraw()
  drawn = 0
  vertices = 0
  i = 0
  while i < len(rgl_flat_array_batches)
    batch = rgl_flat_array_batches[i]
    if RGL_ArrayBatchVisible(batch) then
      drawn = drawn + 1
      vertices = vertices + batch.vertex_count
      RGL_BindOrColor(RGL_TextureIdForFlatnum(batch.texnum))
      RGL_DisableCutoutAlpha()
      RGL_DrawStaticArrayBatch(batch, GL_TRIANGLES)
    end if
    i = i + 1
  end while
  RGL_EndArrayBatchDraw()
  if typeof(_D_ProfileGLBatches) == "function" then _D_ProfileGLBatches(0, total, drawn, vertices) end if
end function

/// Draws static cutout walls through spatially culled VBO batches.
function RGL_DrawMaskedArrayBatches()
  if not RGL_BuildStaticArrayBatches() or len(rgl_masked_array_batches) == 0 then
    RGL_DrawMaskedQuads()
    return
  end if

  total = len(rgl_masked_array_batches)
  if rgl_masked_native_record_count == total and RGL_UpdateMaskedNativeRecordTextures() then
    RGL_BeginArrayBatchDraw()
    if MGL_DrawVisibleGeomBatches(GL_QUADS, rgl_masked_native_records, rgl_masked_native_record_count, rgl_view_x, rgl_view_y, rgl_view_yaw) then
      RGL_EndArrayBatchDraw()
      RGL_DisableCutoutAlpha()
      return
    end if
    RGL_EndArrayBatchDraw()
    RGL_DisableCutoutAlpha()
  end if

  RGL_BeginArrayBatchDraw()
  i = 0
  while i < total
    batch = rgl_masked_array_batches[i]
    if RGL_ArrayBatchVisible(batch) then
      RGL_BindOrColor(RGL_TextureIdForTexnumTransparent(batch.texnum))
      RGL_EnableCutoutAlpha()
      RGL_DrawStaticArrayBatch(batch, GL_QUADS)
    end if
    i = i + 1
  end while
  RGL_EndArrayBatchDraw()
  RGL_DisableCutoutAlpha()
end function

/// Draws all static opaque wall and flat geometry through one parent OpenGL display list.
function RGL_DrawStaticWorldDisplayList()
  global rgl_static_world_display_list_id

  if rgl_static_world_display_list_id == 0 then
    if not RGL_BuildStaticDisplayLists() then return false end if
    id = glGenLists(1)
    if id == 0 then return false end if
    glNewList(id, GL_COMPILE)
    RGL_DrawFlatDisplayLists()
    RGL_DrawWallDisplayLists()
    glEndList()
    rgl_static_world_display_list_id = id
  end if
  glCallList(rgl_static_world_display_list_id)
  return true
end function

/// Caches or fan-draws a convex floor/ceiling polygon with repeating flat UVs and current lighting.
/// @param xs Xs value supplied to `RGL_DrawFlatConvexFloat`.
/// @param ys Ys value supplied to `RGL_DrawFlatConvexFloat`.
/// @param count Number of elements or iterations to process.
/// @param z Vertical world-space coordinate.
/// @param flatnum Index identifying flat.
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

/// Computes view-yaw-relative horizontal sky texture coordinates from a world-space point.
/// @param x Horizontal map- or screen-space coordinate.
/// @param y Vertical map- or screen-space coordinate.
function RGL_SkySForPoint(x, y)
  dx = x - rgl_view_x
  dy = y - rgl_view_y
  a = std.math.atan2(dy, dx) / 6.283185314
  yaw = RGL_NormalizeDegrees(rgl_view_yaw) / 360.0
  return a - yaw
end function

/// Emits a world-space sky vertex with angular horizontal UV and centered vertical UV.
/// @param x Horizontal map- or screen-space coordinate.
/// @param y Vertical map- or screen-space coordinate.
/// @param z Vertical world-space coordinate.
function RGL_DrawSkyVertex(x, y, z)
  s = RGL_SkySForPoint(x, y)
  glTexCoord2d(s, 0.5)
  glVertex3d(x, z, -y)
end function

/// Fan-draws a convex polygon with the full-bright sky texture mapped by view-relative angle.
/// @param xs Xs value supplied to `RGL_DrawSkyConvexFloat`.
/// @param ys Ys value supplied to `RGL_DrawSkyConvexFloat`.
/// @param count Number of elements or iterations to process.
/// @param z Vertical world-space coordinate.
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

/// Fan-triangulates a convex portal polygon into the depth-only cache.
/// @param xs Xs value supplied to `RGL_AddCachedDepthConvexFloat`.
/// @param ys Ys value supplied to `RGL_AddCachedDepthConvexFloat`.
/// @param count Number of elements or iterations to process.
/// @param z Vertical world-space coordinate.
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

/// Appends one four-vertex sky-occlusion surface to the depth-only cache.
/// @param x0 X0 value supplied to `RGL_AddCachedDepthQuad`.
/// @param y0 Y0 value supplied to `RGL_AddCachedDepthQuad`.
/// @param z0 Z0 value supplied to `RGL_AddCachedDepthQuad`.
/// @param x1 Horizontal coordinate of the first endpoint.
/// @param y1 Vertical coordinate of the first endpoint.
/// @param z1 Z1 value supplied to `RGL_AddCachedDepthQuad`.
/// @param x2 Horizontal coordinate of the second endpoint.
/// @param y2 Vertical coordinate of the second endpoint.
/// @param z2 Z2 value supplied to `RGL_AddCachedDepthQuad`.
/// @param x3 X3 value supplied to `RGL_AddCachedDepthQuad`.
/// @param y3 Y3 value supplied to `RGL_AddCachedDepthQuad`.
/// @param z3 Z3 value supplied to `RGL_AddCachedDepthQuad`.
function RGL_AddCachedDepthQuad(x0, y0, z0, x1, y1, z1, x2, y2, z2, x3, y3, z3)
  global rgl_depth_quads

  rgl_depth_quads = rgl_depth_quads +[rgl_depth_quad_t(x0, y0, z0, x1, y1, z1, x2, y2, z2, x3, y3, z3)]
end function

/// Writes cached sky-occlusion triangles and quads to depth only, restoring color and texture state afterward.
function RGL_DrawCachedDepthGeometry()
  glDisable(GL_TEXTURE_2D)
  glColorMask(false, false, false, false)
  glDepthMask(true)

  if RGL_IsSeq(rgl_depth_tris) then
    active = false
    i = 0
    while i < len(rgl_depth_tris)
      t = rgl_depth_tris[i]
      if t is not void then
        if not active then
          glBegin(GL_TRIANGLES)
          active = true
        end if
        glVertex3d(t.x0, t.y0, t.z0)
        glVertex3d(t.x1, t.y1, t.z1)
        glVertex3d(t.x2, t.y2, t.z2)
      end if
      i = i + 1
    end while
    if active then glEnd() end if
  end if

  if RGL_IsSeq(rgl_depth_quads) then
    active = false
    i = 0
    while i < len(rgl_depth_quads)
      q = rgl_depth_quads[i]
      if q is not void then
        if not active then
          glBegin(GL_QUADS)
          active = true
        end if
        glVertex3d(q.x0, q.y0, q.z0)
        glVertex3d(q.x1, q.y1, q.z1)
        glVertex3d(q.x2, q.y2, q.z2)
        glVertex3d(q.x3, q.y3, q.z3)
      end if
      i = i + 1
    end while
    if active then glEnd() end if
  end if

  glColorMask(true, true, true, true)
  glEnable(GL_TEXTURE_2D)
end function

/// Caches or immediately fan-draws a convex sky-ceiling polygon with color writes disabled.
/// @param xs Xs value supplied to `RGL_DrawSkyDepthConvexFloat`.
/// @param ys Ys value supplied to `RGL_DrawSkyDepthConvexFloat`.
/// @param count Number of elements or iterations to process.
/// @param z Vertical world-space coordinate.
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

/// Reports whether any sector-adjacent line leads to another sector whose ceiling uses the sky flat.
/// @param sec Sec value supplied to `RGL_SectorTouchesSkyCeiling`.
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

/// Computes the signed float-space half-plane value of a point against a BSP partition.
/// @param x Horizontal map- or screen-space coordinate.
/// @param y Vertical map- or screen-space coordinate.
/// @param node Node value supplied to `RGL_BspSideValueFloat`.
function RGL_BspSideValueFloat(x, y, node)
  nx = RGL_FixedToFloat(node.x)
  ny = RGL_FixedToFloat(node.y)
  ndx = RGL_FixedToFloat(node.dx)
  ndy = RGL_FixedToFloat(node.dy)
  return(x - nx) * ndy -(y - ny) * ndx
end function

/// Sutherland-Hodgman clips a convex polygon to one BSP-node half-plane and returns the output vertex count.
/// @param xs Xs value supplied to `RGL_ClipPolyToNodeSide`.
/// @param ys Ys value supplied to `RGL_ClipPolyToNodeSide`.
/// @param count Number of elements or iterations to process.
/// @param node Node value supplied to `RGL_ClipPolyToNodeSide`.
/// @param side Map side affected by the operation.
/// @param outx Outx value supplied to `RGL_ClipPolyToNodeSide`.
/// @param outy Outy value supplied to `RGL_ClipPolyToNodeSide`.
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

/// Clips a convex flat polygon to the playable front side of one boundary seg.
/// @param xs Xs value supplied to `RGL_ClipPolyToSegFront`.
/// @param ys Ys value supplied to `RGL_ClipPolyToSegFront`.
/// @param count Number of elements or iterations to process.
/// @param sg Sg value supplied to `RGL_ClipPolyToSegFront`.
/// @param outx Outx value supplied to `RGL_ClipPolyToSegFront`.
/// @param outy Outy value supplied to `RGL_ClipPolyToSegFront`.
function RGL_ClipPolyToSegFront(xs, ys, count, sg, outx, outy)
  if count < 3 or sg is void or sg.v1 is void or sg.v2 is void then return 0 end if
  outCount = 0
  eps = 0.001
  x0 = RGL_FixedToFloat(sg.v1.x)
  y0 = RGL_FixedToFloat(sg.v1.y)
  dx = RGL_FixedToFloat(sg.v2.x - sg.v1.x)
  dy = RGL_FixedToFloat(sg.v2.y - sg.v1.y)

  prev = count - 1
  prevX = xs[prev]
  prevY = ys[prev]
  prevV =(prevX - x0) * dy -(prevY - y0) * dx
  prevIn = prevV >= -eps

  i = 0
  while i < count
    curX = xs[i]
    curY = ys[i]
    curV =(curX - x0) * dy -(curY - y0) * dx
    curIn = curV >= -eps

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

/// Trims BSP flat leaves against one-sided subsector walls so outside void space is not cached.
/// @param ss Ss value supplied to `RGL_ClipBspFlatToBoundarySegs`.
/// @param xs Xs value supplied to `RGL_ClipBspFlatToBoundarySegs`.
/// @param ys Ys value supplied to `RGL_ClipBspFlatToBoundarySegs`.
/// @param count Number of elements or iterations to process.
/// @param outx Outx value supplied to `RGL_ClipBspFlatToBoundarySegs`.
/// @param outy Outy value supplied to `RGL_ClipBspFlatToBoundarySegs`.
function RGL_ClipBspFlatToBoundarySegs(ss, xs, ys, count, outx, outy)
  if ss is void or count < 3 then return count end if
  if typeof(ss.numlines) != "int" or typeof(ss.firstline) != "int" or not RGL_IsSeq(segs) then return count end if

  cap = len(outx)
  ax = array(cap, 0.0)
  ay = array(cap, 0.0)
  bx = array(cap, 0.0)
  by = array(cap, 0.0)

  i = 0
  while i < count and i < cap
    ax[i] = xs[i]
    ay[i] = ys[i]
    i = i + 1
  end while
  curCount = count

  li = 0
  while li < ss.numlines and curCount >= 3
    segi = ss.firstline + li
    if segi >= 0 and segi < len(segs) then
      sg = segs[segi]
      if sg is not void and sg.backsector is void then
        nextCount = RGL_ClipPolyToSegFront(ax, ay, curCount, sg, bx, by)
        if nextCount >= 3 then
          j = 0
          while j < nextCount and j < cap
            ax[j] = bx[j]
            ay[j] = by[j]
            j = j + 1
          end while
          curCount = nextCount
        end if
      end if
    end if
    li = li + 1
  end while

  i = 0
  while i < curCount and i < cap
    outx[i] = ax[i]
    outy[i] = ay[i]
    i = i + 1
  end while
  return curCount
end function

/// Saves one already clipped volatile flat leaf for fast per-frame drawing.
/// @param sidx Sidx value supplied to `RGL_AddVolatileFlatTemplate`.
/// @param xs Xs value supplied to `RGL_AddVolatileFlatTemplate`.
/// @param ys Ys value supplied to `RGL_AddVolatileFlatTemplate`.
/// @param count Number of elements or iterations to process.
function RGL_AddVolatileFlatTemplate(sidx, xs, ys, count)
  global rgl_volatile_flat_templates

  if count < 3 then return end if
  copyX = array(count, 0.0)
  copyY = array(count, 0.0)
  i = 0
  while i < count
    copyX[i] = xs[i]
    copyY[i] = ys[i]
    i = i + 1
  end while
  rgl_volatile_flat_templates = rgl_volatile_flat_templates +[rgl_volatile_flat_template_t(sidx, count, copyX, copyY)]
end function

/// Clips one BSP leaf to solid boundary segs, records volatile templates when requested, then draws floor and
/// ceiling/sky depth.
/// @param sidx Sidx value supplied to `RGL_DrawBspLeafFlat`.
/// @param xs Xs value supplied to `RGL_DrawBspLeafFlat`.
/// @param ys Ys value supplied to `RGL_DrawBspLeafFlat`.
/// @param count Number of elements or iterations to process.
function RGL_DrawBspLeafFlat(sidx, xs, ys, count)
  global rgl_current_light
  global rgl_flat_volatile_only
  global rgl_collecting_volatile_flats

  if sidx < 0 or not RGL_IsSeq(subsectors) or sidx >= len(subsectors) then return end if
  if rgl_collecting_volatile_flats and not RGL_IsVolatileSubsectorIndex(sidx) then return end if
  if rgl_flat_volatile_only and not RGL_IsVolatileSubsectorIndex(sidx) then return end if
  if rgl_building_cache and not rgl_collecting_volatile_geometry and RGL_IsVolatileSubsectorIndex(sidx) then return end if
  ss = subsectors[sidx]
  if ss is void or ss.sector is void then return end if
  sec = ss.sector
  clippedX = array(512, 0.0)
  clippedY = array(512, 0.0)
  clippedCount = RGL_ClipBspFlatToBoundarySegs(ss, xs, ys, count, clippedX, clippedY)
  if clippedCount >= 3 then
    xs = clippedX
    ys = clippedY
    count = clippedCount
  end if
  if rgl_collecting_volatile_flats then
    RGL_AddVolatileFlatTemplate(sidx, xs, ys, count)
    return
  end if
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

/// Rebuilds the perspective frustum and identity model-view matrix after screen-space sky or weapon drawing.
function RGL_Restore3DProjection()
  aspect = 1.6
  if typeof(igl_width) == "int" and typeof(igl_height) == "int" and igl_height > 0 then
    aspect = igl_width / igl_height
  end if
  if aspect <= 0 then aspect = 1.6 end if
  nearz = 4.0
  farz = RGL_WORLD_VIEW_DISTANCE
  top = 2.505
  yshift = -0.401
  right = top * aspect

  glMatrixMode(GL_PROJECTION)
  glLoadIdentity()
  glFrustum(-right, right, -top + yshift, top + yshift, nearz, farz)
  glMatrixMode(GL_MODELVIEW)
  glLoadIdentity()
end function

/// Draws the classic yaw-anchored full-screen sky texture, then restores the 3D projection and depth testing.
/// @param yaw Yaw value supplied to `RGL_DrawSky`.
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

  // Vanilla maps one 256-column sky repeat across a 90-degree view. Adding yaw keeps
  // the panorama fixed in world space; reversing the screen span matches xtoviewangle.
  skyCenter = RGL_NormalizeDegrees(yaw) / 90.0
  s0 = skyCenter + 0.5
  s1 = skyCenter - 0.5
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

/// Recursively clips the map-bounds polygon through BSP half-planes and sends each leaf polygon to flat
/// rendering.
/// @param bspnum Index identifying bsp.
/// @param xs Xs value supplied to `RGL_DrawBspFlatNode`.
/// @param ys Ys value supplied to `RGL_DrawBspFlatNode`.
/// @param count Number of elements or iterations to process.
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

/// Builds a padded map-bounds rectangle and partitions it through the BSP to produce gap-free leaf flat
/// polygons.
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

/// Resolves an mobj frame and view-relative rotation to its relative sprite lump and horizontal flip flag.
/// @param thing World object affected by the operation.
/// @param player Player state affected by the operation.
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

/// Draws one billboard quad using Doom sprite texture orientation.
/// @param x0 X0 value supplied to `RGL_DrawSpriteQuad`.
/// @param y0 Y0 value supplied to `RGL_DrawSpriteQuad`.
/// @param x1 Horizontal coordinate of the first endpoint.
/// @param y1 Vertical coordinate of the first endpoint.
/// @param z0 Z0 value supplied to `RGL_DrawSpriteQuad`.
/// @param z1 Z1 value supplied to `RGL_DrawSpriteQuad`.
/// @param flip Flip value supplied to `RGL_DrawSpriteQuad`.
function RGL_DrawSpriteQuad(x0, y0, x1, y1, z0, z1, flip)
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

/// Builds one camera-facing world sprite quad, applying sector/dynamic light or a multi-pass translucent shadow
/// treatment.
/// @param mo Map object affected by the operation.
/// @param lump Lump value supplied to `RGL_DrawOneSpriteBillboard`.
/// @param flip Flip value supplied to `RGL_DrawOneSpriteBillboard`.
/// @param rx Rx value supplied to `RGL_DrawOneSpriteBillboard`.
/// @param rz Rz value supplied to `RGL_DrawOneSpriteBillboard`.
function RGL_DrawOneSpriteBillboard(mo, lump, flip, rx, rz)
  entry = RGL_SpriteEntryForLump(lump)
  if entry is void then return end if

  shadow = false
  if mo is not void and typeof(mo.flags) == "int" and (mo.flags & mobjflag_t.MF_SHADOW) != 0 then shadow = true end if
  texid = 0
  if shadow then
    texid = RGL_TextureIdForSpriteFuzzLump(lump)
  else
    texid = RGL_TextureIdForSpriteLump(lump)
  end if
  if texid <= 0 then return end if
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
  if not shadow then
    RGL_SetVertexLight(c, x, (z0 + z1) / 2.0, y)
  end if
  halfw = origW / 2.0
  if halfw < 2.0 then halfw = 2.0 end if
  x0 = x - rx * halfw
  y0 = y - rz * halfw
  x1 = x + rx * halfw
  y1 = y + rz * halfw
  glBindTexture(GL_TEXTURE_2D, texid)
  if shadow then
    RGL_DisableCutoutAlpha()
    glDepthMask(false)
    shade = c
    if shade > 126 then shade = 126 end if
    if shade < 58 then shade = 58 end if
    pass = 0
    while pass < 5
      side = 0.0
      lift = 0.0
      alpha = 22
      if pass == 0 then
        side = -2.8
        alpha = 28
      else if pass == 1 then
        side = 2.8
        alpha = 28
      else if pass == 2 then
        lift = 2.0
      else if pass == 3 then
        lift = -1.8
      else
        alpha = 34
      end if
      ox = rx * side
      oy = rz * side
      glColor4ub(shade, shade, shade, alpha)
      RGL_DrawSpriteQuad(x0 + ox, y0 + oy, x1 + ox, y1 + oy, z0 + lift, z1 + lift, flip)
      pass = pass + 1
    end while
    glDepthMask(true)
    RGL_EnableCutoutAlpha()
    glColor4ub(255, 255, 255, 255)
  else
    RGL_DrawSpriteQuad(x0, y0, x1, y1, z0, z1, flip)
  end if
end function

/// Packs the full dynamic-light list once for native sprite color evaluation.
function RGL_BuildSpriteLightRecords()
  global rgl_sprite_light_records
  global rgl_sprite_light_revision
  requiredBytes = RGL_MAX_DYNAMIC_LIGHTS * RGL_LIGHT_RECORD_SIZE
  if typeof(rgl_sprite_light_records) != "bytes" or len(rgl_sprite_light_records) != requiredBytes then
    rgl_sprite_light_records = bytes(requiredBytes, 0)
  end if
  if rgl_sprite_light_revision == rgl_dyn_light_revision then return rgl_sprite_light_records end if
  i = 0
  while i < rgl_dyn_light_count
    off = i * RGL_LIGHT_RECORD_SIZE
    RGL_WriteS32(rgl_sprite_light_records, off, RGL_FloatToGeom(rgl_dyn_light_x[i]))
    RGL_WriteS32(rgl_sprite_light_records, off + 4, RGL_FloatToGeom(rgl_dyn_light_y[i]))
    RGL_WriteS32(rgl_sprite_light_records, off + 8, RGL_FloatToGeom(rgl_dyn_light_z[i]))
    RGL_WriteS32(rgl_sprite_light_records, off + 12, RGL_FloatToGeom(rgl_dyn_light_radius[i]))
    RGL_WriteS32(rgl_sprite_light_records, off + 16, RGL_FloatToGeom(rgl_dyn_light_strength[i]))
    RGL_WriteS32(rgl_sprite_light_records, off + 20, rgl_dyn_light_r[i])
    RGL_WriteS32(rgl_sprite_light_records, off + 24, rgl_dyn_light_g[i])
    RGL_WriteS32(rgl_sprite_light_records, off + 28, rgl_dyn_light_b[i])
    i = i + 1
  end while
  rgl_sprite_light_revision = rgl_dyn_light_revision
  return rgl_sprite_light_records
end function

/// Resolves and packs one visible mobj while caching immutable patch metrics.
/// @param mo Map object affected by the operation.
/// @param lump Lump value supplied to `RGL_PackNativeSprite`.
/// @param flip Flip value supplied to `RGL_PackNativeSprite`.
/// @param records Records value supplied to `RGL_PackNativeSprite`.
/// @param recordIndex Index identifying record.
function inline RGL_PackNativeSprite(mo, lump, flip, records, recordIndex)
  global rgl_sprite_width_cache
  global rgl_sprite_height_cache
  global rgl_sprite_yoffset_cache

  while len(rgl_sprite_width_cache) <= lump
    rgl_sprite_width_cache = rgl_sprite_width_cache +[-1]
    rgl_sprite_height_cache = rgl_sprite_height_cache +[0]
    rgl_sprite_yoffset_cache = rgl_sprite_yoffset_cache +[0]
  end while
  width = rgl_sprite_width_cache[lump]
  if width < 0 then
    entry = RGL_SpriteEntryForLump(lump)
    if entry is void then
      rgl_sprite_width_cache[lump] = 0
      return false
    end if
    width = entry.width
    rgl_sprite_width_cache[lump] = width
    rgl_sprite_height_cache[lump] = entry.height
    rgl_sprite_yoffset_cache[lump] = entry.yoffset
  end if
  if width <= 0 then return false end if

  shadow = false
  if mo is not void and typeof(mo.flags) == "int" and (mo.flags & mobjflag_t.MF_SHADOW) != 0 then shadow = true end if
  texid = RGL_TextureIdForSpriteLump(lump)
  if shadow then texid = RGL_TextureIdForSpriteFuzzLump(lump) end if
  if texid <= 0 then return false end if

  c = 192
  if mo.subsector is not void and mo.subsector.sector is not void then c = RGL_LightByte(mo.subsector.sector) end if
  flags = 0
  if flip != 0 then flags = flags | 1 end if
  if shadow then flags = flags | 2 end if
  off = recordIndex * RGL_SPRITE_RECORD_SIZE
  RGL_WriteS32(records, off, texid)
  RGL_WriteS32(records, off + 4, flags)
  RGL_WriteS32(records, off + 8, c)
  RGL_WriteS32(records, off + 12, mo.x)
  RGL_WriteS32(records, off + 16, mo.y)
  RGL_WriteS32(records, off + 20, mo.z)
  RGL_WriteS32(records, off + 24, width)
  RGL_WriteS32(records, off + 28, rgl_sprite_height_cache[lump])
  RGL_WriteS32(records, off + 32, rgl_sprite_yoffset_cache[lump])
  return true
end function

/// Culls and packs visible sprites before handing the complete frame list to the native GL helper.
/// @param player Player state affected by the operation.
/// @param yaw Yaw value supplied to `RGL_DrawSpriteBillboardsNative`.
function RGL_DrawSpriteBillboardsNative(player, yaw)
  global rgl_sprite_native_records
  if typeof(rgl_frame_mobjs) != "array" or rgl_frame_mobj_count <= 0 then return true end if

  yawRad = (yaw / 360.0) * 6.283185314
  fwdX = std.math.cos(yawRad)
  fwdY = std.math.sin(yawRad)
  rad =((90.0 - yaw) / 360.0) * 6.283185314
  rx = std.math.cos(rad)
  rz = std.math.sin(rad)
  farDist = RGL_WORLD_VIEW_DISTANCE * RGL_WORLD_VIEW_DISTANCE
  scale = 1
  if typeof(ru_scale) == "int" and ru_scale > 0 then scale = ru_scale end if
  requiredBytes = rgl_frame_mobj_count * RGL_SPRITE_RECORD_SIZE
  if typeof(rgl_sprite_native_records) != "bytes" or len(rgl_sprite_native_records) < requiredBytes then
    rgl_sprite_native_records = bytes(requiredBytes, 0)
  end if

  recordCount = 0
  i = 0
  while i < rgl_frame_mobj_count
    mo = rgl_frame_mobjs[i]
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
        if RGL_PackNativeSprite(mo, lump, flip, rgl_sprite_native_records, recordCount) then recordCount = recordCount + 1 end if
      end if
    end if
    i = i + 1
  end while

  if recordCount <= 0 then return true end if
  lightRecords = RGL_BuildSpriteLightRecords()
  if not MGL_BeginSpriteBatch(lightRecords, rgl_dyn_light_count, rgl_view_x, rgl_view_y, rx, rz, scale, RGL_WORLD_SPRITE_FOOT_LIFT) then return false end if
  ok = MGL_DrawSpriteRecords(rgl_sprite_native_records, len(rgl_sprite_native_records), recordCount)
  MGL_EndSpriteBatch()
  return ok
end function

/// Preserves the original per-sprite immediate renderer as a compatibility fallback.
/// @param player Player state affected by the operation.
/// @param yaw Yaw value supplied to `RGL_DrawSpriteBillboardsImmediate`.
function RGL_DrawSpriteBillboardsImmediate(player, yaw)
  if typeof(rgl_frame_mobjs) != "array" or rgl_frame_mobj_count <= 0 then return end if
  glEnable(GL_TEXTURE_2D)
  RGL_EnableCutoutAlpha()
  glColor4ub(255, 255, 255, 255)

  yawRad = (yaw / 360.0) * 6.283185314
  fwdX = std.math.cos(yawRad)
  fwdY = std.math.sin(yawRad)
  rad =((90.0 - yaw) / 360.0) * 6.283185314
  rx = std.math.cos(rad)
  rz = std.math.sin(rad)
  farDist = RGL_WORLD_VIEW_DISTANCE * RGL_WORLD_VIEW_DISTANCE
  i = 0
  while i < rgl_frame_mobj_count
    mo = rgl_frame_mobjs[i]
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
    i = i + 1
  end while
  RGL_DisableCutoutAlpha()
end function

/// Draws world sprites through the native batch path with an immediate-mode fallback.
/// @param player Player state affected by the operation.
/// @param yaw Yaw value supplied to `RGL_DrawSpriteBillboards`.
function RGL_DrawSpriteBillboards(player, yaw)
  if RGL_DrawSpriteBillboardsNative(player, yaw) then return end if
  RGL_DrawSpriteBillboardsImmediate(player, yaw)
end function

/// Resolves each active weapon/flash player sprite and submits its upscaled patch as a screen-space GL
/// rectangle.
/// @param player Player state affected by the operation.
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

/// Collects static boundary, depth, flat, opaque-wall, and masked geometry plus signatures for the loaded map.
/// @param sigMap Sig map value supplied to `RGL_BuildGeometryCache`.
/// @param sigSegs Sig segs value supplied to `RGL_BuildGeometryCache`.
/// @param sigLines Sig lines value supplied to `RGL_BuildGeometryCache`.
/// @param sigNodes Sig nodes value supplied to `RGL_BuildGeometryCache`.
/// @param sigSubsectors Sig subsectors value supplied to `RGL_BuildGeometryCache`.
/// @param sigSectorMotion Sig sector motion value supplied to `RGL_BuildGeometryCache`.
/// @param sigSides Sig sides value supplied to `RGL_BuildGeometryCache`.
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

  RGL_BuildVolatileSectorMap(sigMap)

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
  RGL_BuildVolatileFlatTemplates()
  RGL_ResetStaticDisplayLists()
  RGL_ResetStaticArrayBatches()
end function

/// Reuses matching geometry, tries the map lump on first use, or rebuilds and serializes when topology/sidedefs
/// differ.
function RGL_EnsureGeometryCache()
  global rgl_pending_sig_sector_motion
  global rgl_pending_sig_sides
  global rgl_pending_stable_frames

  sigMap = RGL_CurrentMapIdentity()
  RGL_EnsureVolatileSectorMap(sigMap)
  sigSegs = RGL_SeqLen(segs)
  sigLines = RGL_SeqLen(lines)
  sigNodes = RGL_SeqLen(nodes)
  sigSubsectors = RGL_SeqLen(subsectors)
  topologySame = rgl_geom_ready and rgl_geom_sig_map == sigMap and rgl_geom_sig_segs == sigSegs and rgl_geom_sig_lines == sigLines and rgl_geom_sig_nodes == sigNodes and rgl_geom_sig_subsectors == sigSubsectors
  sigSectorMotion = 0
  sigSides = RGL_SideTextureSignature()
  if topologySame then
    if rgl_geom_sig_sector_motion == sigSectorMotion and rgl_geom_sig_sides == sigSides then return true end if
  end if

  if not rgl_geom_ready then
    if RGL_TryLoadGeometryCache(sigMap, sigSegs, sigLines, sigNodes, sigSubsectors, sigSectorMotion, sigSides) then return true end if
  end if
  RGL_BuildGeometryCache(sigMap, sigSegs, sigLines, sigNodes, sigSubsectors, sigSectorMotion, sigSides)
  RGL_SerializeGeometryCache(sigMap, sigSegs, sigLines, sigNodes, sigSubsectors, sigSectorMotion, sigSides)
  return true
end function

/// Draws cached boundary/depth/flats/walls, then sprites and masked batches in depth-correct world order.
/// @param player Player state affected by the operation.
/// @param yaw Yaw value supplied to `RGL_DrawCachedWorld`.
function RGL_DrawCachedWorld(player, yaw)
  RGL_DrawBoundaryQuads()
  RGL_DrawCachedDepthGeometry()
  RGL_DrawFlatArrayBatches()
  RGL_DrawWallArrayBatches()
  RGL_DrawSpriteBillboards(player, yaw)
  RGL_DrawMaskedArrayBatches()
end function

/// Recomputes and draws all sky boundaries, BSP flats, walls, sprites, and cutout surfaces without geometry
/// caches.
/// @param player Player state affected by the operation.
/// @param yaw Yaw value supplied to `RGL_DrawDirectWorld`.
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

/// Precomputes clipped BSP leaf polygons for dynamic-sector flats.
function RGL_BuildVolatileFlatTemplates()
  global rgl_volatile_flat_templates
  global rgl_collecting_volatile_flats

  rgl_volatile_flat_templates =[]
  if not RGL_IsSeq(rgl_volatile_subsectors) or len(rgl_volatile_subsectors) <= 0 then return end if

  if RGL_IsSeq(nodes) and typeof(numnodes) == "int" and numnodes > 0 then
    oldCollect = rgl_collecting_volatile_flats
    rgl_collecting_volatile_flats = true
    RGL_DrawAllBspFlats()
    rgl_collecting_volatile_flats = oldCollect
    return
  end if

  i = 0
  while i < len(rgl_volatile_subsectors)
    idx = rgl_volatile_subsectors[i]
    if typeof(idx) == "int" and idx >= 0 and RGL_IsSeq(subsectors) and idx < len(subsectors) then
      ss = subsectors[idx]
      if ss is not void and typeof(ss.numlines) == "int" and ss.numlines >= 3 and typeof(ss.firstline) == "int" and RGL_IsSeq(segs) then
        xs = array(ss.numlines, 0.0)
        ys = array(ss.numlines, 0.0)
        j = 0
        count = 0
        while j < ss.numlines
          segi = ss.firstline + j
          if segi >= 0 and segi < len(segs) then
            sg = segs[segi]
            if sg is not void and sg.v1 is not void and count < len(xs) then
              xs[count] = RGL_FixedToFloat(sg.v1.x)
              ys[count] = RGL_FixedToFloat(sg.v1.y)
              count = count + 1
            end if
          end if
          j = j + 1
        end while
        if count >= 3 then RGL_AddVolatileFlatTemplate(idx, xs, ys, count) end if
      end if
    end if
    i = i + 1
  end while
end function

/// Draws one cached dynamic-sector floor and ceiling polygon at current heights.
/// @param t T value supplied to `RGL_DrawVolatileFlatTemplate`.
function RGL_DrawVolatileFlatTemplate(t)
  global rgl_current_light

  if t is void or not RGL_IsSeq(subsectors) then return end if
  idx = t.subsector
  if typeof(idx) != "int" or idx < 0 or idx >= len(subsectors) then return end if
  ss = subsectors[idx]
  if ss is void or ss.sector is void then return end if
  sec = ss.sector
  if not RGL_IsSeq(t.xs) or not RGL_IsSeq(t.ys) or t.count < 3 then return end if

  c = RGL_LightByte(sec)
  rgl_current_light = c
  glColor3ub(c, c, c)
  RGL_DrawFlatConvexFloat(t.xs, t.ys, t.count, sec.floorheight, sec.floorpic)
  if sec.ceilingpic != skyflatnum then
    RGL_DrawFlatConvexFloat(t.xs, t.ys, t.count, sec.ceilingheight, sec.ceilingpic)
  else
    RGL_DrawSkyDepthConvexFloat(t.xs, t.ys, t.count, sec.ceilingheight)
  end if
end function

/// Draws only flats that belong to dynamic sector geometry.
function RGL_DrawVolatileFlats()
  global rgl_current_light
  global rgl_flat_volatile_only

  if RGL_IsSeq(rgl_volatile_flat_templates) and len(rgl_volatile_flat_templates) > 0 then
    i = 0
    while i < len(rgl_volatile_flat_templates)
      RGL_DrawVolatileFlatTemplate(rgl_volatile_flat_templates[i])
      i = i + 1
    end while
    return
  end if

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

/// Draws only opaque wall pieces that touch dynamic sector geometry.
function RGL_DrawVolatileWalls()
  if not RGL_IsSeq(rgl_volatile_segs) or not RGL_IsSeq(segs) then return end if
  i = 0
  while i < len(rgl_volatile_segs)
    idx = rgl_volatile_segs[i]
    if typeof(idx) == "int" and idx >= 0 and idx < len(segs) then RGL_DrawSeg(segs[idx]) end if
    i = i + 1
  end while
end function

/// Draws only masked wall pieces that touch dynamic sector geometry.
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

/// Draws dynamic line midtextures when no seg list is available.
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

/// Draws only continuously scrolling wall pieces with their current texture offsets.
function RGL_DrawScrollingWalls()
  if RGL_IsSeq(segs) and len(segs) > 0 then
    i = 0
    while i < len(rgl_scrolling_segs)
      idx = rgl_scrolling_segs[i]
      if idx >= 0 and idx < len(segs) then RGL_DrawSeg(segs[idx]) end if
      i = i + 1
    end while
    return
  end if
  if not RGL_IsSeq(lines) then return end if
  i = 0
  while i < len(rgl_scrolling_lines)
    idx = rgl_scrolling_lines[i]
    if idx >= 0 and idx < len(lines) then RGL_DrawLine(lines[idx]) end if
    i = i + 1
  end while
end function

/// Draws masked portions of continuously scrolling walls outside the static cache.
function RGL_DrawScrollingMaskedWalls()
  glEnable(GL_TEXTURE_2D)
  glColor4ub(255, 255, 255, 255)
  if RGL_IsSeq(segs) and len(segs) > 0 then
    i = 0
    while i < len(rgl_scrolling_segs)
      idx = rgl_scrolling_segs[i]
      if idx >= 0 and idx < len(segs) then RGL_DrawMaskedSeg(segs[idx]) end if
      i = i + 1
    end while
    return
  end if
  if not RGL_IsSeq(lines) then return end if
  i = 0
  while i < len(rgl_scrolling_lines)
    idx = rgl_scrolling_lines[i]
    if idx >= 0 and idx < len(lines) then
      RGL_DrawLineSideMidtexture(lines[idx], 0)
      RGL_DrawLineSideMidtexture(lines[idx], 1)
    end if
    i = i + 1
  end while
end function

/// Resolves the current scroller texture offsets into frame-reusable quad records.
function RGL_CollectScrollingGeometry()
  global rgl_building_cache
  global rgl_collecting_scrolling_geometry
  global rgl_cache_target
  global rgl_wall_quads
  global rgl_flat_tris
  global rgl_masked_quads

  savedBuilding = rgl_building_cache
  savedCollecting = rgl_collecting_scrolling_geometry
  savedTarget = rgl_cache_target
  savedWalls = rgl_wall_quads
  savedFlats = rgl_flat_tris
  savedMasked = rgl_masked_quads

  rgl_wall_quads =[]
  rgl_flat_tris =[]
  rgl_masked_quads =[]
  rgl_building_cache = true
  rgl_collecting_scrolling_geometry = true
  rgl_cache_target = RGL_CACHE_WALL
  RGL_DrawScrollingWalls()
  rgl_cache_target = RGL_CACHE_MASKED
  RGL_DrawScrollingMaskedWalls()
  collectedWalls = rgl_wall_quads
  collectedMasked = rgl_masked_quads

  rgl_wall_quads = savedWalls
  rgl_flat_tris = savedFlats
  rgl_masked_quads = savedMasked
  rgl_cache_target = savedTarget
  rgl_collecting_scrolling_geometry = savedCollecting
  rgl_building_cache = savedBuilding
  return [collectedWalls, collectedMasked]
end function

/// Uploads one game tic's scrolling wall geometry while preserving static caches.
/// @param currentTic Current tic value supplied to `RGL_RebuildScrollingArrayBatches`.
/// @param currentMap Current map value supplied to `RGL_RebuildScrollingArrayBatches`.
/// @param currentLevelTime Current level time value supplied to `RGL_RebuildScrollingArrayBatches`.
function RGL_RebuildScrollingArrayBatches(currentTic, currentMap, currentLevelTime)
  global rgl_wall_quads
  global rgl_flat_tris
  global rgl_masked_quads
  global rgl_wall_array_batches
  global rgl_flat_array_batches
  global rgl_masked_array_batches
  global rgl_static_array_batches_ready
  global rgl_wall_native_records
  global rgl_flat_native_records
  global rgl_masked_native_records
  global rgl_wall_native_record_count
  global rgl_flat_native_record_count
  global rgl_masked_native_record_count
  global rgl_wall_native_texture_revision
  global rgl_flat_native_texture_revision
  global rgl_masked_native_texture_revision
  global rgl_scrolling_wall_array_batches
  global rgl_scrolling_masked_array_batches
  global rgl_scrolling_wall_native_records
  global rgl_scrolling_masked_native_records
  global rgl_scrolling_wall_native_record_count
  global rgl_scrolling_masked_native_record_count
  global rgl_scrolling_wall_texture_revision
  global rgl_scrolling_masked_texture_revision
  global rgl_scrolling_geometry_last_gametic
  global rgl_scrolling_geometry_last_map
  global rgl_scrolling_geometry_last_leveltime
  global rgl_scrolling_array_batches_ready

  RGL_ResetScrollingArrayBatches()
  collected = RGL_CollectScrollingGeometry()

  savedWalls = rgl_wall_quads
  savedFlats = rgl_flat_tris
  savedMasked = rgl_masked_quads
  savedWallBatches = rgl_wall_array_batches
  savedFlatBatches = rgl_flat_array_batches
  savedMaskedBatches = rgl_masked_array_batches
  savedReady = rgl_static_array_batches_ready
  savedWallRecords = rgl_wall_native_records
  savedFlatRecords = rgl_flat_native_records
  savedMaskedRecords = rgl_masked_native_records
  savedWallRecordCount = rgl_wall_native_record_count
  savedFlatRecordCount = rgl_flat_native_record_count
  savedMaskedRecordCount = rgl_masked_native_record_count
  savedWallTextureRevision = rgl_wall_native_texture_revision
  savedFlatTextureRevision = rgl_flat_native_texture_revision
  savedMaskedTextureRevision = rgl_masked_native_texture_revision

  rgl_wall_quads = collected[0]
  rgl_flat_tris =[]
  rgl_masked_quads = collected[1]
  rgl_wall_array_batches =[]
  rgl_flat_array_batches =[]
  rgl_masked_array_batches =[]
  rgl_static_array_batches_ready = false
  rgl_wall_native_records = bytes(0, 0)
  rgl_flat_native_records = bytes(0, 0)
  rgl_masked_native_records = bytes(0, 0)
  rgl_wall_native_record_count = 0
  rgl_flat_native_record_count = 0
  rgl_masked_native_record_count = 0
  rgl_wall_native_texture_revision = -1
  rgl_flat_native_texture_revision = -1
  rgl_masked_native_texture_revision = -1
  RGL_BuildStaticArrayBatches()

  rgl_scrolling_wall_array_batches = rgl_wall_array_batches
  rgl_scrolling_masked_array_batches = rgl_masked_array_batches
  rgl_scrolling_wall_native_records = rgl_wall_native_records
  rgl_scrolling_masked_native_records = rgl_masked_native_records
  rgl_scrolling_wall_native_record_count = rgl_wall_native_record_count
  rgl_scrolling_masked_native_record_count = rgl_masked_native_record_count
  rgl_scrolling_wall_texture_revision = rgl_wall_native_texture_revision
  rgl_scrolling_masked_texture_revision = rgl_masked_native_texture_revision

  rgl_wall_quads = savedWalls
  rgl_flat_tris = savedFlats
  rgl_masked_quads = savedMasked
  rgl_wall_array_batches = savedWallBatches
  rgl_flat_array_batches = savedFlatBatches
  rgl_masked_array_batches = savedMaskedBatches
  rgl_static_array_batches_ready = savedReady
  rgl_wall_native_records = savedWallRecords
  rgl_flat_native_records = savedFlatRecords
  rgl_masked_native_records = savedMaskedRecords
  rgl_wall_native_record_count = savedWallRecordCount
  rgl_flat_native_record_count = savedFlatRecordCount
  rgl_masked_native_record_count = savedMaskedRecordCount
  rgl_wall_native_texture_revision = savedWallTextureRevision
  rgl_flat_native_texture_revision = savedFlatTextureRevision
  rgl_masked_native_texture_revision = savedMaskedTextureRevision

  rgl_scrolling_geometry_last_gametic = currentTic
  rgl_scrolling_geometry_last_map = currentMap
  rgl_scrolling_geometry_last_leveltime = currentLevelTime
  rgl_scrolling_array_batches_ready = true
  return true
end function

/// Refreshes scrolling UV geometry once per game tic, not once per rendered frame.
function RGL_EnsureScrollingArrayBatches()
  if len(rgl_scrolling_segs) <= 0 and len(rgl_scrolling_lines) <= 0 then return true end if
  currentTic = 0
  if typeof(gametic) == "int" then currentTic = gametic end if
  currentMap = RGL_CurrentMapIdentity()
  currentLevelTime = -1
  if typeof(leveltime) == "int" then currentLevelTime = leveltime end if
  if rgl_scrolling_array_batches_ready and currentTic == rgl_scrolling_geometry_last_gametic and currentMap == rgl_scrolling_geometry_last_map and currentLevelTime == rgl_scrolling_geometry_last_leveltime then return true end if
  return RGL_RebuildScrollingArrayBatches(currentTic, currentMap, currentLevelTime)
end function

/// Updates dynamic sector flats and opaque walls on top of the static cache.
function RGL_DrawVolatileOpaqueWorld()
  RGL_DrawVolatileFlats()
  RGL_DrawVolatileWalls()
end function

/// Updates dynamic masked geometry on top of the static cache.
function RGL_DrawVolatileMaskedWorld()
  if not RGL_DrawVolatileMaskedArrayBatches() then RGL_DrawVolatileMaskedWalls() end if
  RGL_DrawVolatileLineMidtextures()
end function

/// Tracks only state that can change the precomputed volatile-sector meshes.
function RGL_VolatileGeometrySignature()
  h = len(rgl_volatile_sectors) * 65537 + len(rgl_volatile_segs) * 131071
  i = 0
  while i < len(rgl_volatile_sectors)
    if rgl_volatile_sectors[i] and i < len(sectors) then
      sec = sectors[i]
      if sec is not void then
        h = h +(i + 1) * sec.floorheight
        h = h +(i + 3) * sec.ceilingheight
      end if
    end if
    i = i + 1
  end while
  i = 0
  while i < len(rgl_volatile_segs)
    idx = rgl_volatile_segs[i]
    if idx >= 0 and idx < len(segs) then
      sg = segs[idx]
      if sg is not void and sg.sidedef is not void then
        sd = sg.sidedef
        h = h +(i + 13) * sd.toptexture
        h = h +(i + 17) * sd.midtexture
        h = h +(i + 19) * sd.bottomtexture
      end if
    end if
    i = i + 1
  end while
  return h
end function

/// Resolves current volatile sector heights into cached quad and triangle records without drawing them.
function RGL_CollectVolatileGeometry()
  global rgl_building_cache
  global rgl_collecting_volatile_geometry
  global rgl_cache_target
  global rgl_wall_quads
  global rgl_flat_tris
  global rgl_masked_quads

  savedBuilding = rgl_building_cache
  savedCollecting = rgl_collecting_volatile_geometry
  savedTarget = rgl_cache_target
  savedWalls = rgl_wall_quads
  savedFlats = rgl_flat_tris
  savedMasked = rgl_masked_quads

  rgl_wall_quads =[]
  rgl_flat_tris =[]
  rgl_masked_quads =[]
  rgl_building_cache = true
  rgl_collecting_volatile_geometry = true
  rgl_cache_target = RGL_CACHE_WALL
  RGL_DrawVolatileFlats()
  RGL_DrawVolatileWalls()
  rgl_cache_target = RGL_CACHE_MASKED
  RGL_DrawVolatileMaskedWalls()
  collectedWalls = rgl_wall_quads
  collectedFlats = rgl_flat_tris
  collectedMasked = rgl_masked_quads

  rgl_wall_quads = savedWalls
  rgl_flat_tris = savedFlats
  rgl_masked_quads = savedMasked
  rgl_cache_target = savedTarget
  rgl_collecting_volatile_geometry = savedCollecting
  rgl_building_cache = savedBuilding
  return [collectedWalls, collectedFlats, collectedMasked]
end function

/// Uploads the current volatile meshes to VBOs while preserving the static cache state.
/// @param signature Signature value supplied to `RGL_RebuildVolatileArrayBatches`.
function RGL_RebuildVolatileArrayBatches(signature)
  global rgl_wall_quads
  global rgl_flat_tris
  global rgl_masked_quads
  global rgl_wall_array_batches
  global rgl_flat_array_batches
  global rgl_masked_array_batches
  global rgl_static_array_batches_ready
  global rgl_wall_native_records
  global rgl_flat_native_records
  global rgl_masked_native_records
  global rgl_wall_native_record_count
  global rgl_flat_native_record_count
  global rgl_masked_native_record_count
  global rgl_wall_native_texture_revision
  global rgl_flat_native_texture_revision
  global rgl_masked_native_texture_revision
  global rgl_volatile_wall_array_batches
  global rgl_volatile_flat_array_batches
  global rgl_volatile_masked_array_batches
  global rgl_volatile_wall_native_records
  global rgl_volatile_flat_native_records
  global rgl_volatile_masked_native_records
  global rgl_volatile_wall_native_record_count
  global rgl_volatile_flat_native_record_count
  global rgl_volatile_masked_native_record_count
  global rgl_volatile_wall_texture_revision
  global rgl_volatile_flat_texture_revision
  global rgl_volatile_masked_texture_revision
  global rgl_volatile_array_batches_ready
  global rgl_volatile_geometry_signature
  global rgl_volatile_geometry_last_gametic
  global rgl_volatile_geometry_last_leveltime

  RGL_ResetVolatileArrayBatches()
  collected = RGL_CollectVolatileGeometry()

  savedWalls = rgl_wall_quads
  savedFlats = rgl_flat_tris
  savedMasked = rgl_masked_quads
  savedWallBatches = rgl_wall_array_batches
  savedFlatBatches = rgl_flat_array_batches
  savedMaskedBatches = rgl_masked_array_batches
  savedReady = rgl_static_array_batches_ready
  savedWallRecords = rgl_wall_native_records
  savedFlatRecords = rgl_flat_native_records
  savedMaskedRecords = rgl_masked_native_records
  savedWallRecordCount = rgl_wall_native_record_count
  savedFlatRecordCount = rgl_flat_native_record_count
  savedMaskedRecordCount = rgl_masked_native_record_count
  savedWallTextureRevision = rgl_wall_native_texture_revision
  savedFlatTextureRevision = rgl_flat_native_texture_revision
  savedMaskedTextureRevision = rgl_masked_native_texture_revision

  rgl_wall_quads = collected[0]
  rgl_flat_tris = collected[1]
  rgl_masked_quads = collected[2]
  rgl_wall_array_batches =[]
  rgl_flat_array_batches =[]
  rgl_masked_array_batches =[]
  rgl_static_array_batches_ready = false
  rgl_wall_native_records = bytes(0, 0)
  rgl_flat_native_records = bytes(0, 0)
  rgl_masked_native_records = bytes(0, 0)
  rgl_wall_native_record_count = 0
  rgl_flat_native_record_count = 0
  rgl_masked_native_record_count = 0
  rgl_wall_native_texture_revision = -1
  rgl_flat_native_texture_revision = -1
  rgl_masked_native_texture_revision = -1
  RGL_BuildStaticArrayBatches()

  rgl_volatile_wall_array_batches = rgl_wall_array_batches
  rgl_volatile_flat_array_batches = rgl_flat_array_batches
  rgl_volatile_masked_array_batches = rgl_masked_array_batches
  rgl_volatile_wall_native_records = rgl_wall_native_records
  rgl_volatile_flat_native_records = rgl_flat_native_records
  rgl_volatile_masked_native_records = rgl_masked_native_records
  rgl_volatile_wall_native_record_count = rgl_wall_native_record_count
  rgl_volatile_flat_native_record_count = rgl_flat_native_record_count
  rgl_volatile_masked_native_record_count = rgl_masked_native_record_count
  rgl_volatile_wall_texture_revision = rgl_wall_native_texture_revision
  rgl_volatile_flat_texture_revision = rgl_flat_native_texture_revision
  rgl_volatile_masked_texture_revision = rgl_masked_native_texture_revision

  rgl_wall_quads = savedWalls
  rgl_flat_tris = savedFlats
  rgl_masked_quads = savedMasked
  rgl_wall_array_batches = savedWallBatches
  rgl_flat_array_batches = savedFlatBatches
  rgl_masked_array_batches = savedMaskedBatches
  rgl_static_array_batches_ready = savedReady
  rgl_wall_native_records = savedWallRecords
  rgl_flat_native_records = savedFlatRecords
  rgl_masked_native_records = savedMaskedRecords
  rgl_wall_native_record_count = savedWallRecordCount
  rgl_flat_native_record_count = savedFlatRecordCount
  rgl_masked_native_record_count = savedMaskedRecordCount
  rgl_wall_native_texture_revision = savedWallTextureRevision
  rgl_flat_native_texture_revision = savedFlatTextureRevision
  rgl_masked_native_texture_revision = savedMaskedTextureRevision

  rgl_volatile_geometry_signature = signature
  rgl_volatile_geometry_last_gametic = -1
  if typeof(gametic) == "int" then rgl_volatile_geometry_last_gametic = gametic end if
  rgl_volatile_geometry_last_leveltime = -1
  if typeof(leveltime) == "int" then rgl_volatile_geometry_last_leveltime = leveltime end if
  rgl_volatile_array_batches_ready = true
  return true
end function

/// Rebuilds volatile meshes at most once per game tic and only when their state changed.
function RGL_EnsureVolatileArrayBatches()
  global rgl_volatile_geometry_last_gametic
  global rgl_volatile_geometry_last_leveltime
  global rgl_volatile_pending_signature
  global rgl_volatile_pending_stable_tics
  global rgl_volatile_immediate_active
  currentTic = gametic
  if typeof(currentTic) != "int" then currentTic = 0 end if
  currentLevelTime = -1
  if typeof(leveltime) == "int" then currentLevelTime = leveltime end if
  if rgl_volatile_array_batches_ready and rgl_volatile_geometry_last_gametic == currentTic and rgl_volatile_geometry_last_leveltime == currentLevelTime then return true end if
  rgl_volatile_geometry_last_gametic = currentTic
  rgl_volatile_geometry_last_leveltime = currentLevelTime
  signature = RGL_VolatileGeometrySignature()
  if not rgl_volatile_array_batches_ready then
    rgl_volatile_immediate_active = false
    return RGL_RebuildVolatileArrayBatches(signature)
  end if
  if signature == rgl_volatile_geometry_signature then
    rgl_volatile_pending_signature = -1
    rgl_volatile_pending_stable_tics = 0
    rgl_volatile_immediate_active = false
    return true
  end if

  // Moving geometry is cheaper and smoother through the direct path. Upload it once it has settled.
  rgl_volatile_immediate_active = true
  if signature == rgl_volatile_pending_signature then
    rgl_volatile_pending_stable_tics = rgl_volatile_pending_stable_tics + 1
  else
    rgl_volatile_pending_signature = signature
    rgl_volatile_pending_stable_tics = 1
  end if
  if rgl_volatile_pending_stable_tics < RGL_DYNAMIC_SETTLE_FRAMES then return false end if
  rgl_volatile_immediate_active = false
  return RGL_RebuildVolatileArrayBatches(signature)
end function

/// Refreshes moving-wall native record texture ids only when the animation revision changes.
function RGL_UpdateVolatileWallRecordTextures()
  global rgl_volatile_wall_native_records
  global rgl_volatile_wall_texture_revision
  if typeof(rgl_volatile_wall_native_records) != "bytes" then return false end if
  if rgl_volatile_wall_native_record_count != len(rgl_volatile_wall_array_batches) then return false end if
  revision = 0
  if typeof(p_picanim_revision) == "int" then revision = p_picanim_revision end if
  if rgl_volatile_wall_texture_revision == revision then return true end if
  i = 0
  while i < len(rgl_volatile_wall_array_batches)
    batch = rgl_volatile_wall_array_batches[i]
    texid = RGL_TextureIdForTexnum(batch.texnum)
    RGL_WriteU32(rgl_volatile_wall_native_records, i * RGL_NATIVE_BATCH_RECORD_SIZE, texid)
    i = i + 1
  end while
  rgl_volatile_wall_texture_revision = revision
  return true
end function

/// Refreshes moving-floor/ceiling native record texture ids only when the flat-animation revision changes.
function RGL_UpdateVolatileFlatRecordTextures()
  global rgl_volatile_flat_native_records
  global rgl_volatile_flat_texture_revision
  if typeof(rgl_volatile_flat_native_records) != "bytes" then return false end if
  if rgl_volatile_flat_native_record_count != len(rgl_volatile_flat_array_batches) then return false end if
  revision = 0
  if typeof(p_picanim_revision) == "int" then revision = p_picanim_revision end if
  if rgl_volatile_flat_texture_revision == revision then return true end if
  i = 0
  while i < len(rgl_volatile_flat_array_batches)
    batch = rgl_volatile_flat_array_batches[i]
    RGL_WriteU32(rgl_volatile_flat_native_records, i * RGL_NATIVE_BATCH_RECORD_SIZE, RGL_TextureIdForFlatnum(batch.texnum))
    i = i + 1
  end while
  rgl_volatile_flat_texture_revision = revision
  return true
end function

/// Refreshes moving cutout-wall native record texture ids only when the animation revision changes.
function RGL_UpdateVolatileMaskedRecordTextures()
  global rgl_volatile_masked_native_records
  global rgl_volatile_masked_texture_revision
  if typeof(rgl_volatile_masked_native_records) != "bytes" then return false end if
  if rgl_volatile_masked_native_record_count != len(rgl_volatile_masked_array_batches) then return false end if
  revision = 0
  if typeof(p_picanim_revision) == "int" then revision = p_picanim_revision end if
  if rgl_volatile_masked_texture_revision == revision then return true end if
  i = 0
  while i < len(rgl_volatile_masked_array_batches)
    batch = rgl_volatile_masked_array_batches[i]
    RGL_WriteU32(rgl_volatile_masked_native_records, i * RGL_NATIVE_BATCH_RECORD_SIZE, RGL_TextureIdForTexnumTransparent(batch.texnum))
    i = i + 1
  end while
  rgl_volatile_masked_texture_revision = revision
  return true
end function

/// Draws moving-sector walls through native culled VBO batches.
function RGL_DrawVolatileWallArrayBatches()
  if rgl_volatile_immediate_active then return false end if
  if not rgl_volatile_array_batches_ready then return false end if
  total = len(rgl_volatile_wall_array_batches)
  if total <= 0 then return true end if
  if rgl_volatile_wall_native_record_count == total and RGL_UpdateVolatileWallRecordTextures() then
    RGL_BeginArrayBatchDraw()
    ok = MGL_DrawVisibleGeomBatches(GL_QUADS, rgl_volatile_wall_native_records, rgl_volatile_wall_native_record_count, rgl_view_x, rgl_view_y, rgl_view_yaw)
    RGL_EndArrayBatchDraw()
    RGL_DisableCutoutAlpha()
    if ok then
      if typeof(_D_ProfileGLBatches) == "function" then _D_ProfileGLBatches(1, total, MGL_GetLastDrawnBatches(), MGL_GetLastDrawnVertices()) end if
      return true
    end if
  end if
  RGL_BeginArrayBatchDraw()
  drawn = 0
  vertices = 0
  i = 0
  while i < total
    batch = rgl_volatile_wall_array_batches[i]
    if RGL_ArrayBatchVisible(batch) then
      drawn = drawn + 1
      vertices = vertices + batch.vertex_count
      RGL_BindOrColor(RGL_TextureIdForTexnum(batch.texnum))
      RGL_DrawStaticArrayBatch(batch, GL_QUADS)
    end if
    i = i + 1
  end while
  RGL_EndArrayBatchDraw()
  if typeof(_D_ProfileGLBatches) == "function" then _D_ProfileGLBatches(1, total, drawn, vertices) end if
  return true
end function

/// Draws moving-sector floors and ceilings through native culled VBO batches.
function RGL_DrawVolatileFlatArrayBatches()
  if rgl_volatile_immediate_active then return false end if
  if not rgl_volatile_array_batches_ready then return false end if
  total = len(rgl_volatile_flat_array_batches)
  if total <= 0 then return true end if
  if rgl_volatile_flat_native_record_count == total and RGL_UpdateVolatileFlatRecordTextures() then
    RGL_BeginArrayBatchDraw()
    ok = MGL_DrawVisibleGeomBatches(GL_TRIANGLES, rgl_volatile_flat_native_records, rgl_volatile_flat_native_record_count, rgl_view_x, rgl_view_y, rgl_view_yaw)
    RGL_EndArrayBatchDraw()
    if ok then
      if typeof(_D_ProfileGLBatches) == "function" then _D_ProfileGLBatches(0, total, MGL_GetLastDrawnBatches(), MGL_GetLastDrawnVertices()) end if
      return true
    end if
  end if
  RGL_BeginArrayBatchDraw()
  drawn = 0
  vertices = 0
  i = 0
  while i < total
    batch = rgl_volatile_flat_array_batches[i]
    if RGL_ArrayBatchVisible(batch) then
      drawn = drawn + 1
      vertices = vertices + batch.vertex_count
      RGL_BindOrColor(RGL_TextureIdForFlatnum(batch.texnum))
      RGL_DrawStaticArrayBatch(batch, GL_TRIANGLES)
    end if
    i = i + 1
  end while
  RGL_EndArrayBatchDraw()
  if typeof(_D_ProfileGLBatches) == "function" then _D_ProfileGLBatches(0, total, drawn, vertices) end if
  return true
end function

/// Draws settled moving-sector cutout walls from their cached VBOs.
function RGL_DrawVolatileMaskedArrayBatches()
  if rgl_volatile_immediate_active then return false end if
  if not rgl_volatile_array_batches_ready then return false end if
  total = len(rgl_volatile_masked_array_batches)
  if total <= 0 then return true end if
  if rgl_volatile_masked_native_record_count == total and RGL_UpdateVolatileMaskedRecordTextures() then
    RGL_BeginArrayBatchDraw()
    ok = MGL_DrawVisibleGeomBatches(GL_QUADS, rgl_volatile_masked_native_records, rgl_volatile_masked_native_record_count, rgl_view_x, rgl_view_y, rgl_view_yaw)
    RGL_EndArrayBatchDraw()
    RGL_DisableCutoutAlpha()
    if ok then return true end if
  end if
  RGL_BeginArrayBatchDraw()
  i = 0
  while i < total
    batch = rgl_volatile_masked_array_batches[i]
    if RGL_ArrayBatchVisible(batch) then
      RGL_BindOrColor(RGL_TextureIdForTexnumTransparent(batch.texnum))
      RGL_EnableCutoutAlpha()
      RGL_DrawStaticArrayBatch(batch, GL_QUADS)
    end if
    i = i + 1
  end while
  RGL_EndArrayBatchDraw()
  RGL_DisableCutoutAlpha()
  return true
end function

/// Refreshes opaque scroller native record texture ids while preserving current UV geometry and VBOs.
function RGL_UpdateScrollingWallRecordTextures()
  global rgl_scrolling_wall_native_records
  global rgl_scrolling_wall_texture_revision
  if typeof(rgl_scrolling_wall_native_records) != "bytes" then return false end if
  if rgl_scrolling_wall_native_record_count != len(rgl_scrolling_wall_array_batches) then return false end if
  revision = 0
  if typeof(p_picanim_revision) == "int" then revision = p_picanim_revision end if
  if rgl_scrolling_wall_texture_revision == revision then return true end if
  i = 0
  while i < len(rgl_scrolling_wall_array_batches)
    batch = rgl_scrolling_wall_array_batches[i]
    RGL_WriteU32(rgl_scrolling_wall_native_records, i * RGL_NATIVE_BATCH_RECORD_SIZE, RGL_TextureIdForTexnum(batch.texnum))
    i = i + 1
  end while
  rgl_scrolling_wall_texture_revision = revision
  return true
end function

/// Refreshes cutout scroller native record texture ids while preserving current UV geometry and VBOs.
function RGL_UpdateScrollingMaskedRecordTextures()
  global rgl_scrolling_masked_native_records
  global rgl_scrolling_masked_texture_revision
  if typeof(rgl_scrolling_masked_native_records) != "bytes" then return false end if
  if rgl_scrolling_masked_native_record_count != len(rgl_scrolling_masked_array_batches) then return false end if
  revision = 0
  if typeof(p_picanim_revision) == "int" then revision = p_picanim_revision end if
  if rgl_scrolling_masked_texture_revision == revision then return true end if
  i = 0
  while i < len(rgl_scrolling_masked_array_batches)
    batch = rgl_scrolling_masked_array_batches[i]
    RGL_WriteU32(rgl_scrolling_masked_native_records, i * RGL_NATIVE_BATCH_RECORD_SIZE, RGL_TextureIdForTexnumTransparent(batch.texnum))
    i = i + 1
  end while
  rgl_scrolling_masked_texture_revision = revision
  return true
end function

/// Draws opaque scrolling-wall VBOs through native culling with a per-batch client-array fallback.
function RGL_DrawScrollingWallArrayBatches()
  if not rgl_scrolling_array_batches_ready then return false end if
  total = len(rgl_scrolling_wall_array_batches)
  if total <= 0 then return true end if
  if rgl_scrolling_wall_native_record_count == total and RGL_UpdateScrollingWallRecordTextures() then
    RGL_BeginArrayBatchDraw()
    ok = MGL_DrawVisibleGeomBatches(GL_QUADS, rgl_scrolling_wall_native_records, rgl_scrolling_wall_native_record_count, rgl_view_x, rgl_view_y, rgl_view_yaw)
    RGL_EndArrayBatchDraw()
    RGL_DisableCutoutAlpha()
    if ok then return true end if
  end if
  RGL_BeginArrayBatchDraw()
  i = 0
  while i < total
    batch = rgl_scrolling_wall_array_batches[i]
    if RGL_ArrayBatchVisible(batch) then
      RGL_BindOrColor(RGL_TextureIdForTexnum(batch.texnum))
      RGL_DisableCutoutAlpha()
      RGL_DrawStaticArrayBatch(batch, GL_QUADS)
    end if
    i = i + 1
  end while
  RGL_EndArrayBatchDraw()
  RGL_DisableCutoutAlpha()
  return true
end function

/// Draws cutout scrolling-wall VBOs through native culling with an alpha-tested per-batch fallback.
function RGL_DrawScrollingMaskedArrayBatches()
  if not rgl_scrolling_array_batches_ready then return false end if
  total = len(rgl_scrolling_masked_array_batches)
  if total <= 0 then return true end if
  if rgl_scrolling_masked_native_record_count == total and RGL_UpdateScrollingMaskedRecordTextures() then
    RGL_BeginArrayBatchDraw()
    ok = MGL_DrawVisibleGeomBatches(GL_QUADS, rgl_scrolling_masked_native_records, rgl_scrolling_masked_native_record_count, rgl_view_x, rgl_view_y, rgl_view_yaw)
    RGL_EndArrayBatchDraw()
    RGL_DisableCutoutAlpha()
    if ok then return true end if
  end if
  RGL_BeginArrayBatchDraw()
  i = 0
  while i < total
    batch = rgl_scrolling_masked_array_batches[i]
    if RGL_ArrayBatchVisible(batch) then
      RGL_BindOrColor(RGL_TextureIdForTexnumTransparent(batch.texnum))
      RGL_EnableCutoutAlpha()
      RGL_DrawStaticArrayBatch(batch, GL_QUADS)
    end if
    i = i + 1
  end while
  RGL_EndArrayBatchDraw()
  RGL_DisableCutoutAlpha()
  return true
end function

/// Returns a timestamp for fine-grained renderer profiling.
function inline RGL_ProfileStart()
  if typeof(_d_profile_render) != "bool" or not _d_profile_render then return 0 end if
  if typeof(_D_ProfileTimeUs) == "function" then return _D_ProfileTimeUs() end if
  t = std.time.ticks() * 1000
  if typeof(t) != "int" then return 0 end if
  return t
end function

/// Adds elapsed time to one fine-grained renderer profiling slot.
/// @param slot Slot value supplied to `RGL_ProfileEnd`.
/// @param start Start value supplied to `RGL_ProfileEnd`.
function inline RGL_ProfileEnd(slot, start)
  if typeof(_d_profile_render) != "bool" or not _d_profile_render then return end if
  if typeof(start) != "int" or start <= 0 then return end if
  t = std.time.ticks() * 1000
  if typeof(_D_ProfileTimeUs) == "function" then t = _D_ProfileTimeUs() end if
  if typeof(t) != "int" then return end if
  if typeof(_D_ProfileGLAdd) == "function" then _D_ProfileGLAdd(slot, t - start) end if
end function

/// Sets the interpolated camera, updates caches/lights, executes ordered opaque/sprite/masked passes, and
/// presents one GL view.
/// @param player Player state affected by the operation.
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
  if useCache then
    RGL_EnsureVolatileArrayBatches()
    RGL_EnsureScrollingArrayBatches()
  end if
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
    RGL_DrawBoundaryQuads()
    RGL_ProfileEnd(3, pt)
    pt = RGL_ProfileStart()
    RGL_DrawCachedDepthGeometry()
    RGL_ProfileEnd(4, pt)
    pt = RGL_ProfileStart()
    RGL_DrawFlatArrayBatches()
    if not RGL_DrawVolatileFlatArrayBatches() then RGL_DrawVolatileFlats() end if
    RGL_ProfileEnd(5, pt)
    pt = RGL_ProfileStart()
    RGL_DrawWallArrayBatches()
    if not RGL_DrawVolatileWallArrayBatches() then RGL_DrawVolatileWalls() end if
    if not RGL_DrawScrollingWallArrayBatches() then RGL_DrawScrollingWalls() end if
    RGL_ProfileEnd(6, pt)
    pt = RGL_ProfileStart()
    RGL_DrawDynamicLightGlows(yaw)
    RGL_ProfileEnd(10, pt)
    pt = RGL_ProfileStart()
    RGL_DrawSpriteBillboards(player, yaw)
    RGL_ProfileEnd(7, pt)
    pt = RGL_ProfileStart()
    RGL_DrawMaskedArrayBatches()
    RGL_DrawVolatileMaskedWorld()
    if not RGL_DrawScrollingMaskedArrayBatches() then RGL_DrawScrollingMaskedWalls() end if
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
    RGL_DrawDynamicLightGlows(yaw)
    RGL_ProfileEnd(10, pt)
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
