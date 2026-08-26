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

  Script: i_gl.ml
  Purpose: Optional Win32/WGL OpenGL backend helpers.
*/
import m_argv
import doomdef
import r_renderer
import std.math
#if TARGET_OS == "linux"
import platform_linux
#endif

const IGL_PFD_DRAW_TO_WINDOW = 0x00000004
const IGL_PFD_SUPPORT_OPENGL = 0x00000020
const IGL_PFD_DOUBLEBUFFER = 0x00000001
const IGL_PFD_TYPE_RGBA = 0
const IGL_PFD_MAIN_PLANE = 0

const GL_DEPTH_BUFFER_BIT = 0x00000100
const GL_COLOR_BUFFER_BIT = 0x00004000
const GL_FRONT = 0x0404
const GL_BACK = 0x0405
const GL_LINES = 0x0001
const GL_TRIANGLES = 0x0004
const GL_QUADS = 0x0007
const GL_POLYGON = 0x0009
const GL_DEPTH_TEST = 0x0B71
const GL_CULL_FACE = 0x0B44
const GL_TEXTURE_2D = 0x0DE1
const GL_BLEND = 0x0BE2
const GL_ALPHA_TEST = 0x0BC0
const GL_ONE = 0x0001
const GL_LESS = 0x0201
const GL_LEQUAL = 0x0203
const GL_SRC_ALPHA = 0x0302
const GL_ONE_MINUS_SRC_ALPHA = 0x0303
const GL_GREATER = 0x0204
const GL_PROJECTION = 0x1701
const GL_MODELVIEW = 0x1700
const GL_TEXTURE = 0x1702
const GL_COMPILE = 0x1300
const GL_RGBA = 0x1908
const GL_RGB = 0x1907
const GL_INT = 0x1404
const GL_UNSIGNED_BYTE = 0x1401
const GL_VERTEX_ARRAY = 0x8074
const GL_COLOR_ARRAY = 0x8076
const GL_TEXTURE_COORD_ARRAY = 0x8078
const GL_TEXTURE_MAG_FILTER = 0x2800
const GL_TEXTURE_MIN_FILTER = 0x2801
const GL_TEXTURE_WRAP_S = 0x2802
const GL_TEXTURE_WRAP_T = 0x2803
const GL_NEAREST = 0x2600
const GL_LINEAR = 0x2601
const GL_CLAMP = 0x2900
const GL_REPEAT = 0x2901
const GL_UNPACK_ALIGNMENT = 0x0CF5
const GL_PACK_ALIGNMENT = 0x0D05

#if TARGET_OS == "windows"
/*
 * Function: ChoosePixelFormat
 *
 * Purpose: Asks GDI for the closest window pixel format matching the requested OpenGL framebuffer descriptor.
 */

extern function ChoosePixelFormat(hdc as ptr, pfd as bytes) from "gdi32.dll" symbol "ChoosePixelFormat" returns int
/*
 * Function: SetPixelFormat
 *
 * Purpose: Installs the selected immutable pixel format on the window device context before WGL context creation.
 */

extern function SetPixelFormat(hdc as ptr, format as int, pfd as bytes) from "gdi32.dll" symbol "SetPixelFormat" returns bool
/*
 * Function: SwapBuffers
 *
 * Purpose: Presents the device context's back buffer to the window after a rendered frame.
 */

extern function SwapBuffers(hdc as ptr) from "gdi32.dll" symbol "SwapBuffers" returns bool

/*
 * Function: wglCreateContext
 *
 * Purpose: Creates a legacy WGL rendering context for the configured window device context.
 */

extern function wglCreateContext(hdc as ptr) from "opengl32.dll" symbol "wglCreateContext" returns ptr
/*
 * Function: wglMakeCurrent
 *
 * Purpose: Associates a WGL context with the calling thread and its window device context.
 */

extern function wglMakeCurrent(hdc as ptr, hglrc as ptr) from "opengl32.dll" symbol "wglMakeCurrent" returns bool
/*
 * Function: wglDeleteContext
 *
 * Purpose: Releases a WGL rendering context after it has been detached from the calling thread.
 */

extern function wglDeleteContext(hglrc as ptr) from "opengl32.dll" symbol "wglDeleteContext" returns bool

/*
 * Function: glViewport
 *
 * Purpose: Maps normalized device coordinates into the requested framebuffer rectangle.
 */

extern function glViewport(x as int, y as int, width as int, height as int) from "opengl32.dll" symbol "glViewport" returns void
/*
 * Function: glClear
 *
 * Purpose: Clears the framebuffer attachments selected by the caller's OpenGL mask.
 */

extern function glClear(mask as u32) from "opengl32.dll" symbol "glClear" returns void
/*
 * Function: glClearDepth
 *
 * Purpose: Selects the depth value subsequently written by depth-buffer clears.
 */

extern function glClearDepth(depth as double) from "opengl32.dll" symbol "glClearDepth" returns void
/*
 * Function: glEnable
 *
 * Purpose: Enables one fixed-function OpenGL capability for subsequent draw calls.
 */

extern function glEnable(cap as u32) from "opengl32.dll" symbol "glEnable" returns void
/*
 * Function: glDisable
 *
 * Purpose: Disables one fixed-function OpenGL capability for subsequent draw calls.
 */

extern function glDisable(cap as u32) from "opengl32.dll" symbol "glDisable" returns void
/*
 * Function: glDepthMask
 *
 * Purpose: Controls whether rasterized fragments may write to the depth buffer.
 */

extern function glDepthMask(flag as bool) from "opengl32.dll" symbol "glDepthMask" returns void
/*
 * Function: glColorMask
 *
 * Purpose: Controls framebuffer writes independently for red, green, blue, and alpha channels.
 */

extern function glColorMask(red as bool, green as bool, blue as bool, alpha as bool) from "opengl32.dll" symbol "glColorMask" returns void
/*
 * Function: glDepthFunc
 *
 * Purpose: Selects the comparison applied between fragment depth and stored depth.
 */

extern function glDepthFunc(func as u32) from "opengl32.dll" symbol "glDepthFunc" returns void
/*
 * Function: glMatrixMode
 *
 * Purpose: Selects the fixed-function matrix stack modified by following matrix operations.
 */

extern function glMatrixMode(mode as u32) from "opengl32.dll" symbol "glMatrixMode" returns void
/*
 * Function: glLoadIdentity
 *
 * Purpose: Replaces the current fixed-function matrix with the identity transform.
 */

extern function glLoadIdentity() from "opengl32.dll" symbol "glLoadIdentity" returns void
/*
 * Function: glFrustum
 *
 * Purpose: Multiplies the current matrix by an asymmetric perspective projection frustum.
 */

extern function glFrustum(left as double, right as double, bottom as double, top as double, zNear as double, zFar as double) from "opengl32.dll" symbol "glFrustum" returns void
/*
 * Function: glRotated
 *
 * Purpose: Multiplies the current matrix by a double-precision axis-angle rotation.
 */

extern function glRotated(angle as double, x as double, y as double, z as double) from "opengl32.dll" symbol "glRotated" returns void
/*
 * Function: glTranslated
 *
 * Purpose: Multiplies the current matrix by a double-precision translation.
 */

extern function glTranslated(x as double, y as double, z as double) from "opengl32.dll" symbol "glTranslated" returns void
/*
 * Function: glScaled
 *
 * Purpose: Multiplies the current matrix by independent double-precision axis scales.
 */

extern function glScaled(x as double, y as double, z as double) from "opengl32.dll" symbol "glScaled" returns void
/*
 * Function: glPushMatrix
 *
 * Purpose: Saves the current transform on the active fixed-function matrix stack.
 */

extern function glPushMatrix() from "opengl32.dll" symbol "glPushMatrix" returns void
/*
 * Function: glPopMatrix
 *
 * Purpose: Restores the previous transform from the active fixed-function matrix stack.
 */

extern function glPopMatrix() from "opengl32.dll" symbol "glPopMatrix" returns void
/*
 * Function: glBegin
 *
 * Purpose: Opens an immediate-mode primitive stream with the requested topology.
 */

extern function glBegin(mode as u32) from "opengl32.dll" symbol "glBegin" returns void
/*
 * Function: glEnd
 *
 * Purpose: Closes the active immediate-mode primitive stream and submits its vertices.
 */

extern function glEnd() from "opengl32.dll" symbol "glEnd" returns void
/*
 * Function: glGenLists
 *
 * Purpose: Reserves a contiguous range of OpenGL display-list identifiers.
 */

extern function glGenLists(range as int) from "opengl32.dll" symbol "glGenLists" returns u32
/*
 * Function: glNewList
 *
 * Purpose: Begins compiling commands into a selected OpenGL display list.
 */

extern function glNewList(list as u32, mode as u32) from "opengl32.dll" symbol "glNewList" returns void
/*
 * Function: glEndList
 *
 * Purpose: Finishes compilation of the currently open OpenGL display list.
 */

extern function glEndList() from "opengl32.dll" symbol "glEndList" returns void
/*
 * Function: glCallList
 *
 * Purpose: Executes the commands compiled under one OpenGL display-list identifier.
 */

extern function glCallList(list as u32) from "opengl32.dll" symbol "glCallList" returns void
/*
 * Function: glDeleteLists
 *
 * Purpose: Releases a contiguous range of compiled OpenGL display lists.
 */

extern function glDeleteLists(list as u32, range as int) from "opengl32.dll" symbol "glDeleteLists" returns void
/*
 * Function: glEnableClientState
 *
 * Purpose: Enables one legacy vertex-array attribute source for subsequent array draws.
 */

extern function glEnableClientState(array as u32) from "opengl32.dll" symbol "glEnableClientState" returns void
/*
 * Function: glDisableClientState
 *
 * Purpose: Disables one legacy vertex-array attribute source after array drawing.
 */

extern function glDisableClientState(array as u32) from "opengl32.dll" symbol "glDisableClientState" returns void
/*
 * Function: glVertexPointer
 *
 * Purpose: Describes the component layout and storage of the active position array.
 */

extern function glVertexPointer(size as int, typ as u32, stride as int, pointer as bytes) from "opengl32.dll" symbol "glVertexPointer" returns void
/*
 * Function: glTexCoordPointer
 *
 * Purpose: Describes the component layout and storage of the active texture-coordinate array.
 */

extern function glTexCoordPointer(size as int, typ as u32, stride as int, pointer as bytes) from "opengl32.dll" symbol "glTexCoordPointer" returns void
/*
 * Function: glColorPointer
 *
 * Purpose: Describes the component layout and storage of the active per-vertex color array.
 */

extern function glColorPointer(size as int, typ as u32, stride as int, pointer as bytes) from "opengl32.dll" symbol "glColorPointer" returns void
/*
 * Function: glDrawArrays
 *
 * Purpose: Emits a primitive range from the currently enabled legacy client arrays.
 */

extern function glDrawArrays(mode as u32, first as int, count as int) from "opengl32.dll" symbol "glDrawArrays" returns void
/*
 * Function: MGL_InitVBO
 *
 * Purpose: Initializes optional MiniDoom OpenGL VBO helper functions for static geometry batches.
 */

extern function MGL_InitVBO() from "MiniDoomGL.dll" symbol "MGL_InitVBO" returns bool
/*
 * Function: MGL_SetSwapInterval
 *
 * Purpose: Sets the WGL swap interval when the driver exposes wglSwapIntervalEXT.
 */

extern function MGL_SetSwapInterval(interval as int) from "MiniDoomGL.dll" symbol "MGL_SetSwapInterval" returns bool
/*
 * Function: MGL_TimeMicroseconds
 *
 * Purpose: Reads the native high-resolution monotonic timer used by profiling and frame pacing.
 */

extern function MGL_TimeMicroseconds() from "MiniDoomGL.dll" symbol "MGL_TimeMicroseconds" returns i64
/*
 * Function: MGL_FramePace
 *
 * Purpose: Applies a native high-resolution fallback frame limit when VSync is unavailable or disabled.
 */

extern function MGL_FramePace(targetFps as int, leadUs as int) from "MiniDoomGL.dll" symbol "MGL_FramePace" returns void
/*
 * Function: MGL_FramePaceMark
 *
 * Purpose: Marks the actual completion time of a successful presentation as the anchor for the next native pacing deadline.
 */
extern function MGL_FramePaceMark() from "MiniDoomGL.dll" symbol "MGL_FramePaceMark" returns void
/*
 * Function: MGL_RasterColumn8
 *
 * Purpose: Rasterizes one clipped 8-bit software column in native code and rejects malformed buffer ranges.
 */

extern function MGL_RasterColumn8(dest as bytes, destBytes as int, destIndex as int, destStride as int, count as int, source as bytes, sourceBytes as int, sourceOffset as int, sourceLength as int, colormap as bytes, colormapLength as int, frac as int, fracStep as int, sourceClamp as int) from "MiniDoomGL.dll" symbol "MGL_RasterColumn8" returns bool
/*
 * Function: MGL_RasterSpan8
 *
 * Purpose: Rasterizes one clipped 8-bit software floor or ceiling span in native code and rejects malformed buffer ranges.
 */

extern function MGL_RasterSpan8(dest as bytes, destBytes as int, destIndex as int, count as int, source as bytes, sourceBytes as int, colormap as bytes, colormapLength as int, sourceWidth as int, sourceHeight as int, xFrac as int, yFrac as int, xStep as int, yStep as int) from "MiniDoomGL.dll" symbol "MGL_RasterSpan8" returns bool
/*
 * Function: MGL_ExpandIndexed8
 *
 * Purpose: Expands an indexed software frame through its RGB palette into opaque RGBA bytes in native code.
 */

extern function MGL_ExpandIndexed8(source as bytes, sourceBytes as int, dest as bytes, destBytes as int, palette as bytes, paletteBytes as int, pixels as int) from "MiniDoomGL.dll" symbol "MGL_ExpandIndexed8" returns bool
/*
 * Function: MGL_CreateArrayBuffer
 *
 * Purpose: Uploads raw bytes to an OpenGL array buffer through the MiniDoom GL helper.
 */

extern function MGL_CreateArrayBuffer(data as bytes, size as int) from "MiniDoomGL.dll" symbol "MGL_CreateArrayBuffer" returns u32
/*
 * Function: MGL_CreateInterleavedGeomBuffer
 *
 * Purpose: Uploads MiniDoom fixed-point interleaved geometry as a float OpenGL VBO.
 */

extern function MGL_CreateInterleavedGeomBuffer(data as bytes, size as int) from "MiniDoomGL.dll" symbol "MGL_CreateInterleavedGeomBuffer" returns u32
/*
 * Function: MGL_DeleteArrayBuffer
 *
 * Purpose: Deletes one OpenGL array buffer created through the MiniDoom GL helper.
 */

extern function MGL_DeleteArrayBuffer(id as u32) from "MiniDoomGL.dll" symbol "MGL_DeleteArrayBuffer" returns void
/*
 * Function: MGL_DrawArrayBatch
 *
 * Purpose: Draws one VBO-backed vertex/texture/color array batch through the MiniDoom GL helper.
 */

extern function MGL_DrawArrayBatch(mode as u32, vertexBuffer as u32, texcoordBuffer as u32, colorBuffer as u32, count as int) from "MiniDoomGL.dll" symbol "MGL_DrawArrayBatch" returns void
/*
 * Function: MGL_DrawInterleavedBatch
 *
 * Purpose: Draws one VBO-backed interleaved vertex/texture/color batch through the MiniDoom GL helper.
 */

extern function MGL_DrawInterleavedBatch(mode as u32, buffer as u32, count as int) from "MiniDoomGL.dll" symbol "MGL_DrawInterleavedBatch" returns void
/*
 * Function: MGL_DrawVisibleGeomBatches
 *
 * Purpose: Draws and culls a native batch-record buffer in the MiniDoom GL helper.
 */

extern function MGL_DrawVisibleGeomBatches(mode as u32, records as bytes, recordCount as int, viewX as double, viewY as double, viewYaw as double) from "MiniDoomGL.dll" symbol "MGL_DrawVisibleGeomBatches" returns bool
/*
 * Function: MGL_DrawDynamicLightSurfaces
 *
 * Purpose: Draws additive dynamic light contribution on cached map geometry.
 */

extern function MGL_DrawDynamicLightSurfaces(geomData as bytes, geomSize as int, lightData as bytes, lightCount as int) from "MiniDoomGL.dll" symbol "MGL_DrawDynamicLightSurfaces" returns bool
/*
 * Function: MGL_BeginSpriteBatch
 *
 * Purpose: Opens a native world-sprite stream and copies its frame-local lighting state.
 */

extern function MGL_BeginSpriteBatch(lightData as bytes, lightCount as int, viewX as double, viewY as double, rightX as double, rightZ as double, worldScale as double, footLift as double) from "MiniDoomGL.dll" symbol "MGL_BeginSpriteBatch" returns bool
/*
 * Function: MGL_SubmitSprite
 *
 * Purpose: Streams one packed world sprite into the active native batch, including lighting, flip, and fuzz-shadow flags.
 */
extern function MGL_SubmitSprite(texid as u32, flags as int, baseLight as int, fixedX as int, fixedY as int, fixedZ as int, width as int, height as int, yOffset as int) from "MiniDoomGL.dll" symbol "MGL_SubmitSprite" returns void
/*
 * Function: MGL_DrawSpriteRecords
 *
 * Purpose: Validates and renders a complete packed sprite-record buffer through one native call.
 */
extern function MGL_DrawSpriteRecords(records as bytes, recordsSize as int, recordCount as int) from "MiniDoomGL.dll" symbol "MGL_DrawSpriteRecords" returns bool
/*
 * Function: MGL_EndSpriteBatch
 *
 * Purpose: Closes the native sprite stream and restores fixed-function state for subsequent renderer passes.
 */
extern function MGL_EndSpriteBatch() from "MiniDoomGL.dll" symbol "MGL_EndSpriteBatch" returns void
/*
 * Function: MGL_GetLastDrawnBatches
 *
 * Purpose: Returns the number of batches drawn by the last native batch-record draw.
 */

extern function MGL_GetLastDrawnBatches() from "MiniDoomGL.dll" symbol "MGL_GetLastDrawnBatches" returns int
/*
 * Function: MGL_GetLastDrawnVertices
 *
 * Purpose: Returns the number of vertices drawn by the last native batch-record draw.
 */

extern function MGL_GetLastDrawnVertices() from "MiniDoomGL.dll" symbol "MGL_GetLastDrawnVertices" returns int
/*
 * Function: MGL_DrawIndexedOverlay
 *
 * Purpose: Converts and draws an indexed overlay with transparency mask in native code.
 */

extern function MGL_DrawIndexedOverlay(texid as u32, data as bytes, mask as bytes, palette as bytes, width as int, height as int) from "MiniDoomGL.dll" symbol "MGL_DrawIndexedOverlay" returns bool
/*
 * Function: MGL_DrawIndexedLogicalOverlay
 *
 * Purpose: Converts the scaled status area plus dirty logical-mask bounds to one minimal native RGBA overlay draw.
 */
extern function MGL_DrawIndexedLogicalOverlay(texid as u32, data as bytes, dataSize as int, mask as bytes, maskSize as int, palette as bytes, logicalW as int, logicalH as int, scale as int, statusY as int, minX as int, minY as int, maxX as int, maxY as int) from "MiniDoomGL.dll" symbol "MGL_DrawIndexedLogicalOverlay" returns bool
/*
 * Function: MGL_DrawIndexedOverlayRect
 *
 * Purpose: Converts and draws only the caller-specified dirty rectangle of a masked indexed overlay.
 */
extern function MGL_DrawIndexedOverlayRect(texid as u32, data as bytes, dataSize as int, mask as bytes, maskSize as int, palette as bytes, width as int, height as int, minX as int, minY as int, maxX as int, maxY as int) from "MiniDoomGL.dll" symbol "MGL_DrawIndexedOverlayRect" returns bool
/*
 * Function: glVertex3d
 *
 * Purpose: Appends one double-precision position to the active immediate-mode primitive.
 */

extern function glVertex3d(x as double, y as double, z as double) from "opengl32.dll" symbol "glVertex3d" returns void
/*
 * Function: glTexCoord2d
 *
 * Purpose: Sets the texture coordinate attached to following immediate-mode vertices.
 */

extern function glTexCoord2d(s as double, t as double) from "opengl32.dll" symbol "glTexCoord2d" returns void
/*
 * Function: glColor3ub
 *
 * Purpose: Sets the opaque byte RGB color attached to following vertices.
 */

extern function glColor3ub(r as int, g as int, b as int) from "opengl32.dll" symbol "glColor3ub" returns void
/*
 * Function: glColor4ub
 *
 * Purpose: Sets the byte RGBA color attached to following vertices.
 */

extern function glColor4ub(r as int, g as int, b as int, a as int) from "opengl32.dll" symbol "glColor4ub" returns void
/*
 * Function: glBlendFunc
 *
 * Purpose: Selects source and destination factors for fixed-function color blending.
 */

extern function glBlendFunc(sfactor as u32, dfactor as u32) from "opengl32.dll" symbol "glBlendFunc" returns void
/*
 * Function: glAlphaFunc
 *
 * Purpose: Selects the comparison and threshold used by fixed-function alpha testing.
 */

extern function glAlphaFunc(func as u32, ref as double) from "opengl32.dll" symbol "glAlphaFunc" returns void
/*
 * Function: glGenTextures
 *
 * Purpose: Allocates caller-requested OpenGL texture object identifiers.
 */

extern function glGenTextures(n as int, textures as bytes) from "opengl32.dll" symbol "glGenTextures" returns void
/*
 * Function: glBindTexture
 *
 * Purpose: Makes a texture object current for operations on the selected texture target.
 */

extern function glBindTexture(target as u32, texture as u32) from "opengl32.dll" symbol "glBindTexture" returns void
/*
 * Function: glTexParameteri
 *
 * Purpose: Sets an integer sampling or wrapping parameter on the current texture target.
 */

extern function glTexParameteri(target as u32, pname as u32, param as int) from "opengl32.dll" symbol "glTexParameteri" returns void
/*
 * Function: glTexImage2D
 *
 * Purpose: Defines one two-dimensional texture image from caller-supplied pixel storage.
 */

extern function glTexImage2D(target as u32, level as int, internalFormat as int, width as int, height as int, border as int, format as u32, typ as u32, pixels as bytes) from "opengl32.dll" symbol "glTexImage2D" returns void
/*
 * Function: glPixelStorei
 *
 * Purpose: Configures byte-row alignment for texture uploads or framebuffer readback.
 */

extern function glPixelStorei(pname as u32, param as int) from "opengl32.dll" symbol "glPixelStorei" returns void
/*
 * Function: glReadPixels
 *
 * Purpose: Copies a framebuffer rectangle into caller-provided pixel storage with format conversion.
 */

extern function glReadPixels(x as int, y as int, width as int, height as int, format as u32, typ as u32, pixels as bytes) from "opengl32.dll" symbol "glReadPixels" returns void
/*
 * Function: glReadBuffer
 *
 * Purpose: Selects the color buffer used by subsequent framebuffer readback.
 */

extern function glReadBuffer(mode as u32) from "opengl32.dll" symbol "glReadBuffer" returns void
#endif

igl_enabled = false
igl_active = false
igl_renderer_enabled = false
igl_frame_ready = false
igl_hdc = void
igl_hrc = void
igl_width = 320
igl_height = 200
igl_palette = void
igl_base_palette = void
igl_texture_palette = void
igl_palette_revision = 0
igl_overlay_tex = 0
igl_overlay_rgba = void
igl_frame_tex = 0
igl_frame_rgba = void
igl_flash_r = 255
igl_flash_g = 255
igl_flash_b = 255
igl_flash_a = 0
igl_capture_rgba = void
igl_nearest_cache =[]
igl_vsync_requested = true
igl_vsync_active = false
igl_frame_limit = 0

/*
* Function: IGL_WriteU16
* Purpose: Encodes the low 16 bits of a value at a byte-buffer offset in little-endian order.
*/
function inline IGL_WriteU16(buf, off, value)
  v = value & 0xffff
  buf[off] = v & 255
  buf[off + 1] =(v >> 8) & 255
end function

/*
* Function: IGL_WriteU32
* Purpose: Encodes the low 32 bits of a value at a byte-buffer offset in little-endian order.
*/
function inline IGL_WriteU32(buf, off, value)
  v = value
  buf[off] = v & 255
  buf[off + 1] =(v >> 8) & 255
  buf[off + 2] =(v >> 16) & 255
  buf[off + 3] =(v >> 24) & 255
end function

/*
* Function: IGL_ReadU32
* Purpose: Decodes one unsigned 32-bit little-endian value from a byte buffer offset.
*/
function inline IGL_ReadU32(buf, off)
  return buf[off] +(buf[off + 1] << 8) +(buf[off + 2] << 16) +(buf[off + 3] << 24)
end function

/*
* Function: IGL_WantsOpenGL
* Purpose: Detects OpenGL command-line aliases, records the corresponding renderer request, and reports the selection.
*/
function IGL_WantsOpenGL()
  if typeof(M_CheckParm) != "function" then return false end if
  want = M_CheckParm("-opengl") != 0 or M_CheckParm("--opengl") != 0 or M_CheckParm("-gl") != 0 or M_CheckParm("--gl") != 0
  if want then
    R_RendererRequest(RENDERER_OPENGL)
  else
    R_RendererRequest(RENDERER_CLASSIC)
  end if
  return want
end function

/*
* Function: IGL_ConfigureFramePacing
* Purpose: Enables VSync by default and installs a deterministic fallback limiter when needed.
*/
function IGL_ConfigureFramePacing()
  global igl_vsync_requested
  global igl_vsync_active
  global igl_frame_limit

  igl_vsync_requested = true
  if M_CheckParm("-novsync") != 0 or M_CheckParm("--novsync") != 0 then igl_vsync_requested = false end if
  if M_CheckParm("-vsync") != 0 or M_CheckParm("--vsync") != 0 then igl_vsync_requested = true end if

  igl_frame_limit = 0
  p = M_CheckParm("-maxfps")
  if p == 0 then p = M_CheckParm("--maxfps") end if
  if p != 0 and typeof(myargc) == "int" and p < myargc - 1 and typeof(myargv) == "array" then
    v = toNumber(myargv[p + 1])
    if typeof(v) == "int" then
      if v < 0 then v = 0 end if
      if v > 1000 then v = 1000 end if
      igl_frame_limit = v
    end if
  end if

  igl_vsync_active = false
  if igl_vsync_requested then
    igl_vsync_active = MGL_SetSwapInterval(1)
    if not igl_vsync_active and igl_frame_limit <= 0 then igl_frame_limit = 60 end if
  else
    MGL_SetSwapInterval(0)
  end if
end function

/*
* Function: IGL_IsActive
* Purpose: Returns true when the OpenGL renderer is the active drawing path.
*/
function IGL_IsActive()
  return igl_active and igl_renderer_enabled and R_RendererIsOpenGL()
end function

/*
* Function: IGL_IsAvailable
* Purpose: Returns true when an OpenGL context exists for optional rendering.
*/
function IGL_IsAvailable()
  return igl_active
end function

/*
* Function: IGL_MakeCurrent
* Purpose: Ensures the WGL context is current before issuing OpenGL commands.
*/
function IGL_MakeCurrent()
  if not igl_active then return false end if
  if igl_hdc is void or igl_hrc is void then return false end if
  return wglMakeCurrent(igl_hdc, igl_hrc)
end function

/*
* Function: IGL_SetRendererEnabled
* Purpose: Selects whether the OpenGL renderer or the classic CPU renderer is active.
*/
function IGL_SetRendererEnabled(v)
  global igl_renderer_enabled
  global igl_frame_ready

  if not igl_active then
    igl_renderer_enabled = false
    igl_frame_ready = false
    R_RendererRequest(RENDERER_CLASSIC)
    R_RendererSetActive(RENDERER_CLASSIC)
    return false
  end if

  igl_renderer_enabled = false
  if typeof(v) == "bool" and v then igl_renderer_enabled = true end if
  igl_frame_ready = false
  if igl_renderer_enabled then
    R_RendererRequest(RENDERER_OPENGL)
    R_RendererSetActive(RENDERER_OPENGL)
    print "Renderer: OpenGL"
  else
    R_RendererRequest(RENDERER_CLASSIC)
    R_RendererSetActive(RENDERER_CLASSIC)
    print "Renderer: classic"
  end if
  return igl_renderer_enabled
end function

/*
* Function: IGL_ToggleRenderer
* Purpose: Toggles between the OpenGL and classic renderers when OpenGL is available.
*/
function IGL_ToggleRenderer()
  if not igl_active then return false end if
  return IGL_SetRendererEnabled(not igl_renderer_enabled)
end function

/*
* Function: IGL_Init
* Purpose: Initializes init state for the OpenGL backend system.
*/
function IGL_Init(hwnd, hdc, width, height)
  global igl_enabled
  global igl_active
  global igl_renderer_enabled
  global igl_hdc
  global igl_hrc
  global igl_width
  global igl_height

  igl_enabled = IGL_WantsOpenGL()
  if not igl_enabled then return false end if
  if hdc is void then return false end if

  pfd = bytes(40, 0)
  IGL_WriteU16(pfd, 0, 40)
  IGL_WriteU16(pfd, 2, 1)
  IGL_WriteU32(pfd, 4, IGL_PFD_DRAW_TO_WINDOW | IGL_PFD_SUPPORT_OPENGL | IGL_PFD_DOUBLEBUFFER)
  pfd[8] = IGL_PFD_TYPE_RGBA
  pfd[9] = 32
  pfd[23] = 24
  pfd[25] = IGL_PFD_MAIN_PLANE

  fmt = ChoosePixelFormat(hdc, pfd)
  if fmt <= 0 then
    print "OpenGL: ChoosePixelFormat failed"
    return false
  end if
  if not SetPixelFormat(hdc, fmt, pfd) then
    print "OpenGL: SetPixelFormat failed"
    return false
  end if

  hrc = wglCreateContext(hdc)
  if hrc is void then
    print "OpenGL: wglCreateContext failed"
    return false
  end if
  if not wglMakeCurrent(hdc, hrc) then
    wglDeleteContext(hrc)
    print "OpenGL: wglMakeCurrent failed"
    return false
  end if

  igl_hdc = hdc
  igl_hrc = hrc
  igl_active = true
  igl_renderer_enabled = true
  R_RendererRequest(RENDERER_OPENGL)
  R_RendererSetActive(RENDERER_OPENGL)
  igl_width = width
  igl_height = height
  if igl_width <= 0 then igl_width = 320 end if
  if igl_height <= 0 then igl_height = 200 end if

  glViewport(0, 0, igl_width, igl_height)
  glClearDepth(1.0)
  glEnable(GL_DEPTH_TEST)
  glEnable(GL_TEXTURE_2D)
  glEnable(GL_BLEND)
  glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA)
  glDisable(GL_CULL_FACE)
  glPixelStorei(GL_UNPACK_ALIGNMENT, 1)
  IGL_ConfigureFramePacing()
#if TARGET_OS == "linux"
  print "OpenGL: SDL2 backend enabled (" + igl_width + "x" + igl_height + ")"
#else
  print "OpenGL: WGL backend enabled (" + igl_width + "x" + igl_height + ")"
#endif
  return true
end function

/*
* Function: IGL_Resize
* Purpose: Updates cached drawable dimensions and the OpenGL viewport, ignoring invalid or unchanged sizes.
*/
function IGL_Resize(width, height)
  global igl_width
  global igl_height
  if not igl_active then return end if
  if width <= 0 or height <= 0 then return end if
  if width == igl_width and height == igl_height then return end if
  igl_width = width
  igl_height = height
  glViewport(0, 0, igl_width, igl_height)
end function

/*
* Function: IGL_Begin3D
* Purpose: Makes the context current, clears the frame, and installs the perspective projection and depth state for world rendering.
*/
function IGL_Begin3D()
  global igl_frame_ready

  if not IGL_IsActive() then return false end if
  igl_frame_ready = false
  glEnable(GL_DEPTH_TEST)
  glEnable(GL_BLEND)
  glEnable(GL_TEXTURE_2D)
  aspect = igl_width / igl_height
  if aspect <= 0 then aspect = 1.6 end if
  nearz = 4.0
  farz = 4096.0
  top = 2.4
  right = top * aspect

  glViewport(0, 0, igl_width, igl_height)
  glMatrixMode(GL_PROJECTION)
  glLoadIdentity()
  glFrustum(-right, right, -top, top, nearz, farz)
  glMatrixMode(GL_MODELVIEW)
  glLoadIdentity()
  glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT)
  return true
end function

/*
* Function: IGL_MarkFrameReady
* Purpose: Records that the active renderer completed a frame eligible for presentation.
*/
function IGL_MarkFrameReady()
  global igl_frame_ready
  if igl_active then igl_frame_ready = true end if
end function

/*
* Function: IGL_HasFrameReady
* Purpose: Reports whether an active OpenGL context currently has an unpresented completed frame.
*/
function IGL_HasFrameReady()
  return IGL_IsActive() and igl_frame_ready
end function

/*
* Function: IGL_Swap
* Purpose: Paces a ready frame, presents it through SwapBuffers, marks the real presentation time, and clears readiness only on success.
*/
function IGL_Swap()
  global igl_frame_ready

  if not igl_active then return false end if
  if not igl_frame_ready then return false end if
  if not IGL_MakeCurrent() then return false end if
  if igl_frame_limit > 0 then
    leadUs = 0
    if igl_vsync_active then leadUs = 1000 end if
    MGL_FramePace(igl_frame_limit, leadUs)
  end if
  ok = SwapBuffers(igl_hdc)
  if ok then
    if igl_frame_limit > 0 then MGL_FramePaceMark() end if
    igl_frame_ready = false
  end if
  return ok
end function

/*
* Function: IGL_SetPalette
* Purpose: Copies a 256-color palette into render and conversion tables, invalidates nearest-color lookup, and bumps its revision.
*/
function IGL_SetPalette(palette)
  global igl_palette
  global igl_base_palette
  global igl_texture_palette
  global igl_palette_revision
  global igl_nearest_cache

  if typeof(palette) != "bytes" or len(palette) < 768 then return end if
  igl_palette = slice(palette, 0, 768)
  igl_base_palette = slice(palette, 0, 768)
  igl_texture_palette = slice(palette, 0, 768)
  igl_nearest_cache =[]
  igl_palette_revision = igl_palette_revision + 1
end function

/*
* Function: IGL_SetPaletteFlash
* Purpose: Converts Doom damage, bonus, and radiation palette indices into an RGBA fullscreen tint.
*/
function IGL_SetPaletteFlash(paletteIndex)
  global igl_flash_r
  global igl_flash_g
  global igl_flash_b
  global igl_flash_a

  if typeof(paletteIndex) != "int" or paletteIndex <= 0 then
    igl_flash_a = 0
    return
  end if

  if paletteIndex >= 1 and paletteIndex <= 8 then
    igl_flash_r = 255
    igl_flash_g = 40
    igl_flash_b = 24
    igl_flash_a = 14 + paletteIndex * 4
  else if paletteIndex >= 9 and paletteIndex <= 12 then
    strength = paletteIndex - 8
    igl_flash_r = 255
    igl_flash_g = 238
    igl_flash_b = 190
    igl_flash_a = 8 + strength * 3
  else if paletteIndex == 13 then
    igl_flash_r = 80
    igl_flash_g = 255
    igl_flash_b = 80
    igl_flash_a = 20
  else
    igl_flash_a = 0
  end if

  if igl_flash_a > 48 then igl_flash_a = 48 end if
end function

/*
* Function: IGL_NearestPaletteIndex
* Purpose: Finds the closest RGB entry in the active 256-color palette and caches the result by quantized source color.
*/
function IGL_NearestPaletteIndex(r, g, b)
  global igl_nearest_cache

  pal = igl_texture_palette
  if typeof(pal) != "bytes" or len(pal) < 768 then pal = igl_palette end if
  if typeof(pal) != "bytes" or len(pal) < 768 then return 0 end if

  key =((r >> 4) << 8) |((g >> 4) << 4) |(b >> 4)
  if typeof(igl_nearest_cache) != "array" or len(igl_nearest_cache) < 4096 then
    igl_nearest_cache = array(4096, -1)
  end if
  if key >= 0 and key < len(igl_nearest_cache) and igl_nearest_cache[key] >= 0 then
    return igl_nearest_cache[key]
  end if

  best = 0
  bestDist = 2147483647
  i = 0
  while i < 256
    po = i * 3
    dr = r - pal[po]
    dg = g - pal[po + 1]
    db = b - pal[po + 2]
    dist = dr * dr * 3 + dg * dg * 4 + db * db * 2
    if dist < bestDist then
      bestDist = dist
      best = i
      if dist == 0 then break end if
    end if
    i = i + 1
  end while

  if key >= 0 and key < len(igl_nearest_cache) then igl_nearest_cache[key] = best end if
  return best
end function

/*
* Function: IGL_CaptureLogicalIndexed
* Purpose: Reads back the GL framebuffer, downsamples it to logical dimensions, and quantizes each pixel to the nearest base-palette index.
*/
function IGL_CaptureLogicalIndexed(dest, logicalW, logicalH)
  global igl_capture_rgba

  if not igl_active then return false end if
  if typeof(dest) != "bytes" then return false end if
  if typeof(logicalW) != "int" or typeof(logicalH) != "int" then return false end if
  if logicalW <= 0 or logicalH <= 0 then return false end if
  if len(dest) < logicalW * logicalH then return false end if
  if igl_width <= 0 or igl_height <= 0 then return false end if

  pixels = igl_width * igl_height
  if typeof(igl_capture_rgba) != "bytes" or len(igl_capture_rgba) < pixels * 4 then
    igl_capture_rgba = bytes(pixels * 4, 0)
  end if

  glReadBuffer(GL_BACK)
  glPixelStorei(GL_PACK_ALIGNMENT, 1)
  glReadPixels(0, 0, igl_width, igl_height, GL_RGBA, GL_UNSIGNED_BYTE, igl_capture_rgba)

  y = 0
  while y < logicalH
    srcY = std.math.floor(((logicalH - 1 - y) * igl_height) / logicalH)
    if srcY < 0 then srcY = 0 end if
    if srcY >= igl_height then srcY = igl_height - 1 end if
    x = 0
    while x < logicalW
      srcX = std.math.floor((x * igl_width) / logicalW)
      if srcX < 0 then srcX = 0 end if
      if srcX >= igl_width then srcX = igl_width - 1 end if
      ro = (srcY * igl_width + srcX) * 4
      dest[y * logicalW + x] = IGL_NearestPaletteIndex(igl_capture_rgba[ro], igl_capture_rgba[ro + 1], igl_capture_rgba[ro + 2])
      x = x + 1
    end while
    y = y + 1
  end while
  return true
end function

/*
* Function: IGL_CaptureRGBA
* Purpose: Reads the selected GL color buffer, flips its bottom-up rows, and nearest-neighbor resizes RGBA pixels into the destination.
*/
function IGL_CaptureRGBA(dest, outW, outH, front)
  global igl_capture_rgba

  if not igl_active then return false end if
  if typeof(dest) != "bytes" then return false end if
  if typeof(outW) != "int" or typeof(outH) != "int" then return false end if
  if outW <= 0 or outH <= 0 then return false end if
  if len(dest) < outW * outH * 4 then return false end if
  if igl_width <= 0 or igl_height <= 0 then return false end if

  pixels = igl_width * igl_height
  if typeof(igl_capture_rgba) != "bytes" or len(igl_capture_rgba) < pixels * 4 then
    igl_capture_rgba = bytes(pixels * 4, 0)
  end if

  if typeof(front) == "bool" and front then
    glReadBuffer(GL_FRONT)
  else
    glReadBuffer(GL_BACK)
  end if
  glPixelStorei(GL_PACK_ALIGNMENT, 1)
  glReadPixels(0, 0, igl_width, igl_height, GL_RGBA, GL_UNSIGNED_BYTE, igl_capture_rgba)

  y = 0
  while y < outH
    srcY = std.math.floor(((outH - 1 - y) * igl_height) / outH)
    if srcY < 0 then srcY = 0 end if
    if srcY >= igl_height then srcY = igl_height - 1 end if
    x = 0
    while x < outW
      srcX = std.math.floor((x * igl_width) / outW)
      if srcX < 0 then srcX = 0 end if
      if srcX >= igl_width then srcX = igl_width - 1 end if
      so = (srcY * igl_width + srcX) * 4
      doff = (y * outW + x) * 4
      dest[doff] = igl_capture_rgba[so]
      dest[doff + 1] = igl_capture_rgba[so + 1]
      dest[doff + 2] = igl_capture_rgba[so + 2]
      dest[doff + 3] = 255
      x = x + 1
    end while
    y = y + 1
  end while
  return true
end function

/*
* Function: IGL_CreateIndexedTextureEx
* Purpose: Creates an indexed OpenGL texture with explicit alpha and wrap handling.
*/
function IGL_CreateIndexedTextureEx(data, width, height, transparent, repeatWrap)
  if not igl_active then return 0 end if
  if typeof(data) != "bytes" then return 0 end if
  texpal = igl_texture_palette
  if typeof(texpal) != "bytes" or len(texpal) < 768 then texpal = igl_palette end if
  if typeof(texpal) != "bytes" or len(texpal) < 768 then return 0 end if
  if typeof(width) != "int" or typeof(height) != "int" then return 0 end if
  if width <= 0 or height <= 0 then return 0 end if
  if len(data) < width * height then return 0 end if

  rgba = bytes(width * height * 4, 0)
  i = 0
  while i < width * height
    c = data[i]
    po = c * 3
    ro = i * 4
    rgba[ro] = texpal[po]
    rgba[ro + 1] = texpal[po + 1]
    rgba[ro + 2] = texpal[po + 2]
    alpha = 255
    if transparent and c == 255 then alpha = 0 end if
    rgba[ro + 3] = alpha
    i = i + 1
  end while

  idbuf = bytes(4, 0)
  glGenTextures(1, idbuf)
  texid = IGL_ReadU32(idbuf, 0)
  if texid <= 0 then return 0 end if
  glBindTexture(GL_TEXTURE_2D, texid)
  glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR)
  glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR)
  if repeatWrap then
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_REPEAT)
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_REPEAT)
  else
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP)
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP)
  end if
  glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, width, height, 0, GL_RGBA, GL_UNSIGNED_BYTE, rgba)
  return texid
end function

/*
* Function: IGL_CreateFuzzMaskTexture
* Purpose: Creates a neutral alpha mask texture for Doom's shadow/fuzz sprites.
*/
function IGL_CreateFuzzMaskTexture(data, width, height, transparent)
  if not igl_active then return 0 end if
  if typeof(data) != "bytes" then return 0 end if
  if typeof(width) != "int" or typeof(height) != "int" then return 0 end if
  if width <= 0 or height <= 0 then return 0 end if
  if len(data) < width * height then return 0 end if

  rgba = bytes(width * height * 4, 0)
  y = 0
  while y < height
    x = 0
    while x < width
      idx = y * width + x
      c = data[idx]
      ro = idx * 4
      if transparent and c == 255 then
        rgba[ro] = 0
        rgba[ro + 1] = 0
        rgba[ro + 2] = 0
        rgba[ro + 3] = 0
      else
        bx = x - (x % 5)
        by = y - (y % 5)
        shade = 148 +(((bx * 23 + by * 17) % 64) - 32)
        if shade < 82 then shade = 82 end if
        if shade > 190 then shade = 190 end if
        rgba[ro] = shade
        rgba[ro + 1] = shade
        rgba[ro + 2] = shade
        rgba[ro + 3] = 125
      end if
      x = x + 1
    end while
    y = y + 1
  end while

  idbuf = bytes(4, 0)
  glGenTextures(1, idbuf)
  texid = IGL_ReadU32(idbuf, 0)
  if texid <= 0 then return 0 end if
  glBindTexture(GL_TEXTURE_2D, texid)
  glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_NEAREST)
  glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_NEAREST)
  glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP)
  glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP)
  glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, width, height, 0, GL_RGBA, GL_UNSIGNED_BYTE, rgba)
  return texid
end function

/*
* Function: IGL_CreateIndexedTexture
* Purpose: Creates an indexed OpenGL texture using default Doom wall/sprite wrapping.
*/
function IGL_CreateIndexedTexture(data, width, height, transparent)
  return IGL_CreateIndexedTextureEx(data, width, height, transparent, not transparent)
end function

/*
* Function: IGL_EnsureOverlayTexture
* Purpose: Lazily allocates the reusable overlay texture and configures nearest filtering plus edge clamping.
*/
function IGL_EnsureOverlayTexture()
  global igl_overlay_tex

  if igl_overlay_tex > 0 then return igl_overlay_tex end if
  idbuf = bytes(4, 0)
  glGenTextures(1, idbuf)
  igl_overlay_tex = IGL_ReadU32(idbuf, 0)
  if igl_overlay_tex <= 0 then return 0 end if
  glBindTexture(GL_TEXTURE_2D, igl_overlay_tex)
  glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR)
  glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR)
  glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP)
  glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP)
  return igl_overlay_tex
end function

/*
* Function: IGL_EnsureFrameTexture
* Purpose: Lazily allocates the reusable full-frame texture and configures pixel-exact sampling for software-frame presentation.
*/
function IGL_EnsureFrameTexture()
  global igl_frame_tex

  if igl_frame_tex > 0 then return igl_frame_tex end if
  idbuf = bytes(4, 0)
  glGenTextures(1, idbuf)
  igl_frame_tex = IGL_ReadU32(idbuf, 0)
  if igl_frame_tex <= 0 then return 0 end if
  glBindTexture(GL_TEXTURE_2D, igl_frame_tex)
  glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_NEAREST)
  glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_NEAREST)
  glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP)
  glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP)
  return igl_frame_tex
end function

/*
* Function: IGL_Begin2D
* Purpose: Replaces the world matrices with identity clip-space transforms and disables depth testing for screen-aligned overlays.
*/
function IGL_Begin2D()
  if not igl_active then return false end if
  glDisable(GL_DEPTH_TEST)
  glEnable(GL_TEXTURE_2D)
  glEnable(GL_BLEND)
  glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA)
  glMatrixMode(GL_PROJECTION)
  glLoadIdentity()
  glMatrixMode(GL_MODELVIEW)
  glLoadIdentity()
  glColor4ub(255, 255, 255, 255)
  return true
end function

/*
* Function: IGL_DrawTextureRect
* Purpose: Draws a textured clip-space quad with caller-supplied bounds and resets the vertex color afterward.
*/
function IGL_DrawTextureRect(texid, x, y, width, height, flipped)
  if texid <= 0 or not IGL_Begin2D() then return false end if
  if width <= 0 or height <= 0 then return false end if

  x0 =((x / SCREENWIDTH) * 2.0) - 1.0
  x1 =(((x + width) / SCREENWIDTH) * 2.0) - 1.0
  y0 = 1.0 -((y / SCREENHEIGHT) * 2.0)
  y1 = 1.0 -(((y + height) / SCREENHEIGHT) * 2.0)
  s0 = 0.0
  s1 = 1.0
  if flipped then
    s0 = 1.0
    s1 = 0.0
  end if

  glBindTexture(GL_TEXTURE_2D, texid)
  glBegin(GL_QUADS)
  glTexCoord2d(s0, 0.0)
  glVertex3d(x0, y0, 0.0)
  glTexCoord2d(s1, 0.0)
  glVertex3d(x1, y0, 0.0)
  glTexCoord2d(s1, 1.0)
  glVertex3d(x1, y1, 0.0)
  glTexCoord2d(s0, 1.0)
  glVertex3d(x0, y1, 0.0)
  glEnd()
  return true
end function

/*
* Function: IGL_DrawIndexedFrame
* Purpose: Expands a palette-indexed software frame to RGBA, uploads it to the frame texture, and covers the complete output surface.
*/
function IGL_DrawIndexedFrame(data, width, height)
  global igl_frame_rgba

  if not igl_active then return false end if
  if not IGL_MakeCurrent() then return false end if
  if typeof(data) != "bytes" then return false end if
  framepal = igl_texture_palette
  if typeof(framepal) != "bytes" or len(framepal) < 768 then framepal = igl_palette end if
  if typeof(framepal) != "bytes" or len(framepal) < 768 then return false end if
  if typeof(width) != "int" or typeof(height) != "int" then return false end if
  if width <= 0 or height <= 0 then return false end if
  pixels = width * height
  if len(data) < pixels then return false end if

  texid = IGL_EnsureFrameTexture()
  if texid <= 0 then return false end if
  if typeof(igl_frame_rgba) != "bytes" or len(igl_frame_rgba) < pixels * 4 then
    igl_frame_rgba = bytes(pixels * 4, 0)
  end if

  i = 0
  while i < pixels
    c = data[i]
    po = c * 3
    ro = i * 4
    igl_frame_rgba[ro] = framepal[po]
    igl_frame_rgba[ro + 1] = framepal[po + 1]
    igl_frame_rgba[ro + 2] = framepal[po + 2]
    igl_frame_rgba[ro + 3] = 255
    i = i + 1
  end while

  glDisable(GL_DEPTH_TEST)
  glEnable(GL_TEXTURE_2D)
  glDisable(GL_BLEND)
  glMatrixMode(GL_PROJECTION)
  glLoadIdentity()
  glMatrixMode(GL_MODELVIEW)
  glLoadIdentity()
  glViewport(0, 0, igl_width, igl_height)
  glClear(GL_COLOR_BUFFER_BIT)
  glColor4ub(255, 255, 255, 255)
  glBindTexture(GL_TEXTURE_2D, texid)
  glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, width, height, 0, GL_RGBA, GL_UNSIGNED_BYTE, igl_frame_rgba)
  glBegin(GL_QUADS)
  glTexCoord2d(0.0, 0.0)
  glVertex3d(-1.0, 1.0, 0.0)
  glTexCoord2d(1.0, 0.0)
  glVertex3d(1.0, 1.0, 0.0)
  glTexCoord2d(1.0, 1.0)
  glVertex3d(1.0, -1.0, 0.0)
  glTexCoord2d(0.0, 1.0)
  glVertex3d(-1.0, -1.0, 0.0)
  glEnd()
  glEnable(GL_BLEND)
  return true
end function

/*
* Function: IGL_DrawRGBAFrame
* Purpose: Uploads a validated RGBA frame directly to the reusable frame texture and presents it as a full-screen quad.
*/
function IGL_DrawRGBAFrame(data, width, height)
  if not igl_active then return false end if
  if not IGL_MakeCurrent() then return false end if
  if typeof(data) != "bytes" then return false end if
  if typeof(width) != "int" or typeof(height) != "int" then return false end if
  if width <= 0 or height <= 0 then return false end if
  if len(data) < width * height * 4 then return false end if

  texid = IGL_EnsureFrameTexture()
  if texid <= 0 then return false end if

  glDisable(GL_DEPTH_TEST)
  glEnable(GL_TEXTURE_2D)
  glDisable(GL_BLEND)
  glMatrixMode(GL_PROJECTION)
  glLoadIdentity()
  glMatrixMode(GL_MODELVIEW)
  glLoadIdentity()
  glViewport(0, 0, igl_width, igl_height)
  glClear(GL_COLOR_BUFFER_BIT)
  glColor4ub(255, 255, 255, 255)
  glBindTexture(GL_TEXTURE_2D, texid)
  glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, width, height, 0, GL_RGBA, GL_UNSIGNED_BYTE, data)
  glBegin(GL_QUADS)
  glTexCoord2d(0.0, 0.0)
  glVertex3d(-1.0, 1.0, 0.0)
  glTexCoord2d(1.0, 0.0)
  glVertex3d(1.0, 1.0, 0.0)
  glTexCoord2d(1.0, 1.0)
  glVertex3d(1.0, -1.0, 0.0)
  glTexCoord2d(0.0, 1.0)
  glVertex3d(-1.0, -1.0, 0.0)
  glEnd()
  glEnable(GL_BLEND)
  return true
end function

/*
* Function: IGL_DrawPaletteFlash
* Purpose: Blends the active damage, bonus, or radiation palette tint over the finished frame without affecting depth.
*/
function IGL_DrawPaletteFlash()
  if not igl_active then return false end if
  if igl_flash_a <= 0 then return false end if
  if not IGL_Begin2D() then return false end if

  glDisable(GL_TEXTURE_2D)
  glColor4ub(igl_flash_r, igl_flash_g, igl_flash_b, igl_flash_a)
  glBegin(GL_QUADS)
  glVertex3d(-1.0, 1.0, 0.0)
  glVertex3d(1.0, 1.0, 0.0)
  glVertex3d(1.0, -1.0, 0.0)
  glVertex3d(-1.0, -1.0, 0.0)
  glEnd()
  glColor4ub(255, 255, 255, 255)
  glEnable(GL_TEXTURE_2D)
  return true
end function

/*
* Function: IGL_DrawIndexedOverlay
* Purpose: Converts and draws masked indexed HUD pixels through the native dirty-rectangle path, falling back safely when no pixels are visible.
*/
function IGL_DrawIndexedOverlay(data, mask, width, height)
  if not igl_active then return false end if
  if typeof(data) != "bytes" or typeof(mask) != "bytes" then return false end if
  overlaypal = igl_texture_palette
  if typeof(overlaypal) != "bytes" or len(overlaypal) < 768 then overlaypal = igl_palette end if
  if typeof(overlaypal) != "bytes" or len(overlaypal) < 768 then return false end if
  if width <= 0 or height <= 0 then return false end if
  pixels = width * height
  if len(data) < pixels or len(mask) < pixels then return false end if
  texid = IGL_EnsureOverlayTexture()
  if texid <= 0 then return false end if

  IGL_Begin2D()
  return MGL_DrawIndexedOverlay(texid, data, mask, overlaypal, width, height)
end function

/*
* Function: IGL_DrawIndexedOverlayLayers
* Purpose: Converts logical HUD pixels and prepared high-resolution patches in native code.
*/
function IGL_DrawIndexedOverlayLayers(logical, logicalMask, logicalMinX, logicalMinY, logicalMaxX, logicalMaxY, highres, highresMask, highresMinX, highresMinY, highresMaxX, highresMaxY, width, height, statusY)
  if not igl_active then return false end if
  if typeof(logical) != "bytes" or typeof(logicalMask) != "bytes" then return false end if
  if len(logical) < SCREENWIDTH * SCREENHEIGHT or len(logicalMask) < SCREENWIDTH * SCREENHEIGHT then return false end if
  overlaypal = igl_texture_palette
  if typeof(overlaypal) != "bytes" or len(overlaypal) < 768 then overlaypal = igl_palette end if
  if typeof(overlaypal) != "bytes" or len(overlaypal) < 768 then return false end if
  scale = 1
  if width == SCREENWIDTH * 2 then scale = 2 end if
  if width == SCREENWIDTH * 3 then scale = 3 end if
  if width == SCREENWIDTH * 4 then scale = 4 end if
  texid = IGL_EnsureOverlayTexture()
  if texid <= 0 then return false end if
  if not IGL_Begin2D() then return false end if

  drawn = MGL_DrawIndexedLogicalOverlay(texid, logical, len(logical), logicalMask, len(logicalMask), overlaypal, SCREENWIDTH, SCREENHEIGHT, scale, statusY, logicalMinX, logicalMinY, logicalMaxX, logicalMaxY)
  if typeof(highres) == "bytes" and typeof(highresMask) == "bytes" and highresMaxX >= highresMinX and highresMaxY >= highresMinY then
    if len(highres) >= width * height and len(highresMask) >= width * height then
      if MGL_DrawIndexedOverlayRect(texid, highres, len(highres), highresMask, len(highresMask), overlaypal, width, height, highresMinX, highresMinY, highresMaxX, highresMaxY) then drawn = true end if
    end if
  end if
  return drawn
end function

/*
* Function: IGL_Shutdown
* Purpose: Detaches and destroys the WGL context, clears backend handles, and returns renderer selection to classic software mode.
*/
function IGL_Shutdown()
  global igl_active
  global igl_renderer_enabled
  global igl_hrc
  global igl_hdc

  if igl_active then
    wglMakeCurrent(void, void)
    if not(igl_hrc is void) then wglDeleteContext(igl_hrc) end if
  end if
  igl_active = false
  igl_renderer_enabled = false
  R_RendererRequest(RENDERER_CLASSIC)
  R_RendererSetActive(RENDERER_CLASSIC)
  igl_hrc = void
  igl_hdc = void
end function
