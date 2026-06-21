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
import std.math

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

/*
 * Function: ChoosePixelFormat
 *
 * Purpose: Maps the external ChoosePixelFormat binding used for OpenGL rendering.
 */

extern function ChoosePixelFormat(hdc as ptr, pfd as bytes) from "gdi32.dll" symbol "ChoosePixelFormat" returns int
/*
 * Function: SetPixelFormat
 *
 * Purpose: Maps the external SetPixelFormat binding used for OpenGL rendering.
 */

extern function SetPixelFormat(hdc as ptr, format as int, pfd as bytes) from "gdi32.dll" symbol "SetPixelFormat" returns bool
/*
 * Function: SwapBuffers
 *
 * Purpose: Maps the external SwapBuffers binding used for OpenGL rendering.
 */

extern function SwapBuffers(hdc as ptr) from "gdi32.dll" symbol "SwapBuffers" returns bool

/*
 * Function: wglCreateContext
 *
 * Purpose: Maps the external wglCreateContext binding used for OpenGL rendering.
 */

extern function wglCreateContext(hdc as ptr) from "opengl32.dll" symbol "wglCreateContext" returns ptr
/*
 * Function: wglMakeCurrent
 *
 * Purpose: Maps the external wglMakeCurrent binding used for OpenGL rendering.
 */

extern function wglMakeCurrent(hdc as ptr, hglrc as ptr) from "opengl32.dll" symbol "wglMakeCurrent" returns bool
/*
 * Function: wglDeleteContext
 *
 * Purpose: Maps the external wglDeleteContext binding used for OpenGL rendering.
 */

extern function wglDeleteContext(hglrc as ptr) from "opengl32.dll" symbol "wglDeleteContext" returns bool

/*
 * Function: glViewport
 *
 * Purpose: Maps the external glViewport binding used for OpenGL rendering.
 */

extern function glViewport(x as int, y as int, width as int, height as int) from "opengl32.dll" symbol "glViewport" returns void
/*
 * Function: glClear
 *
 * Purpose: Maps the external glClear binding used for OpenGL rendering.
 */

extern function glClear(mask as u32) from "opengl32.dll" symbol "glClear" returns void
/*
 * Function: glClearDepth
 *
 * Purpose: Maps the external glClearDepth binding used for OpenGL rendering.
 */

extern function glClearDepth(depth as double) from "opengl32.dll" symbol "glClearDepth" returns void
/*
 * Function: glEnable
 *
 * Purpose: Maps the external glEnable binding used for OpenGL rendering.
 */

extern function glEnable(cap as u32) from "opengl32.dll" symbol "glEnable" returns void
/*
 * Function: glDisable
 *
 * Purpose: Maps the external glDisable binding used for OpenGL rendering.
 */

extern function glDisable(cap as u32) from "opengl32.dll" symbol "glDisable" returns void
/*
 * Function: glDepthMask
 *
 * Purpose: Maps the external glDepthMask binding used for OpenGL rendering.
 */

extern function glDepthMask(flag as bool) from "opengl32.dll" symbol "glDepthMask" returns void
/*
 * Function: glColorMask
 *
 * Purpose: Maps the external glColorMask binding used for OpenGL rendering.
 */

extern function glColorMask(red as bool, green as bool, blue as bool, alpha as bool) from "opengl32.dll" symbol "glColorMask" returns void
/*
 * Function: glDepthFunc
 *
 * Purpose: Maps the external glDepthFunc binding used for OpenGL rendering.
 */

extern function glDepthFunc(func as u32) from "opengl32.dll" symbol "glDepthFunc" returns void
/*
 * Function: glMatrixMode
 *
 * Purpose: Maps the external glMatrixMode binding used for OpenGL rendering.
 */

extern function glMatrixMode(mode as u32) from "opengl32.dll" symbol "glMatrixMode" returns void
/*
 * Function: glLoadIdentity
 *
 * Purpose: Maps the external glLoadIdentity binding used for OpenGL rendering.
 */

extern function glLoadIdentity() from "opengl32.dll" symbol "glLoadIdentity" returns void
/*
 * Function: glFrustum
 *
 * Purpose: Maps the external glFrustum binding used for OpenGL rendering.
 */

extern function glFrustum(left as double, right as double, bottom as double, top as double, zNear as double, zFar as double) from "opengl32.dll" symbol "glFrustum" returns void
/*
 * Function: glRotated
 *
 * Purpose: Maps the external glRotated binding used for OpenGL rendering.
 */

extern function glRotated(angle as double, x as double, y as double, z as double) from "opengl32.dll" symbol "glRotated" returns void
/*
 * Function: glTranslated
 *
 * Purpose: Maps the external glTranslated binding used for OpenGL rendering.
 */

extern function glTranslated(x as double, y as double, z as double) from "opengl32.dll" symbol "glTranslated" returns void
/*
 * Function: glScaled
 *
 * Purpose: Maps the external glScaled binding used for scaled OpenGL client-array rendering.
 */

extern function glScaled(x as double, y as double, z as double) from "opengl32.dll" symbol "glScaled" returns void
/*
 * Function: glPushMatrix
 *
 * Purpose: Maps the external glPushMatrix binding used for temporary OpenGL matrix transforms.
 */

extern function glPushMatrix() from "opengl32.dll" symbol "glPushMatrix" returns void
/*
 * Function: glPopMatrix
 *
 * Purpose: Maps the external glPopMatrix binding used for temporary OpenGL matrix transforms.
 */

extern function glPopMatrix() from "opengl32.dll" symbol "glPopMatrix" returns void
/*
 * Function: glBegin
 *
 * Purpose: Maps the external glBegin binding used for OpenGL rendering.
 */

extern function glBegin(mode as u32) from "opengl32.dll" symbol "glBegin" returns void
/*
 * Function: glEnd
 *
 * Purpose: Maps the external glEnd binding used for OpenGL rendering.
 */

extern function glEnd() from "opengl32.dll" symbol "glEnd" returns void
/*
 * Function: glGenLists
 *
 * Purpose: Maps the external glGenLists binding used for OpenGL display-list rendering.
 */

extern function glGenLists(range as int) from "opengl32.dll" symbol "glGenLists" returns u32
/*
 * Function: glNewList
 *
 * Purpose: Maps the external glNewList binding used for OpenGL display-list rendering.
 */

extern function glNewList(list as u32, mode as u32) from "opengl32.dll" symbol "glNewList" returns void
/*
 * Function: glEndList
 *
 * Purpose: Maps the external glEndList binding used for OpenGL display-list rendering.
 */

extern function glEndList() from "opengl32.dll" symbol "glEndList" returns void
/*
 * Function: glCallList
 *
 * Purpose: Maps the external glCallList binding used for OpenGL display-list rendering.
 */

extern function glCallList(list as u32) from "opengl32.dll" symbol "glCallList" returns void
/*
 * Function: glDeleteLists
 *
 * Purpose: Maps the external glDeleteLists binding used for OpenGL display-list rendering.
 */

extern function glDeleteLists(list as u32, range as int) from "opengl32.dll" symbol "glDeleteLists" returns void
/*
 * Function: glEnableClientState
 *
 * Purpose: Maps the external glEnableClientState binding used for OpenGL client-array rendering.
 */

extern function glEnableClientState(array as u32) from "opengl32.dll" symbol "glEnableClientState" returns void
/*
 * Function: glDisableClientState
 *
 * Purpose: Maps the external glDisableClientState binding used for OpenGL client-array rendering.
 */

extern function glDisableClientState(array as u32) from "opengl32.dll" symbol "glDisableClientState" returns void
/*
 * Function: glVertexPointer
 *
 * Purpose: Maps the external glVertexPointer binding used for OpenGL client-array rendering.
 */

extern function glVertexPointer(size as int, typ as u32, stride as int, pointer as bytes) from "opengl32.dll" symbol "glVertexPointer" returns void
/*
 * Function: glTexCoordPointer
 *
 * Purpose: Maps the external glTexCoordPointer binding used for OpenGL client-array rendering.
 */

extern function glTexCoordPointer(size as int, typ as u32, stride as int, pointer as bytes) from "opengl32.dll" symbol "glTexCoordPointer" returns void
/*
 * Function: glColorPointer
 *
 * Purpose: Maps the external glColorPointer binding used for OpenGL client-array rendering.
 */

extern function glColorPointer(size as int, typ as u32, stride as int, pointer as bytes) from "opengl32.dll" symbol "glColorPointer" returns void
/*
 * Function: glDrawArrays
 *
 * Purpose: Maps the external glDrawArrays binding used for OpenGL client-array rendering.
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
 * Function: glVertex3d
 *
 * Purpose: Maps the external glVertex3d binding used for OpenGL rendering.
 */

extern function glVertex3d(x as double, y as double, z as double) from "opengl32.dll" symbol "glVertex3d" returns void
/*
 * Function: glTexCoord2d
 *
 * Purpose: Maps the external glTexCoord2d binding used for OpenGL rendering.
 */

extern function glTexCoord2d(s as double, t as double) from "opengl32.dll" symbol "glTexCoord2d" returns void
/*
 * Function: glColor3ub
 *
 * Purpose: Maps the external glColor3ub binding used for OpenGL rendering.
 */

extern function glColor3ub(r as int, g as int, b as int) from "opengl32.dll" symbol "glColor3ub" returns void
/*
 * Function: glColor4ub
 *
 * Purpose: Maps the external glColor4ub binding used for OpenGL rendering.
 */

extern function glColor4ub(r as int, g as int, b as int, a as int) from "opengl32.dll" symbol "glColor4ub" returns void
/*
 * Function: glBlendFunc
 *
 * Purpose: Maps the external glBlendFunc binding used for OpenGL rendering.
 */

extern function glBlendFunc(sfactor as u32, dfactor as u32) from "opengl32.dll" symbol "glBlendFunc" returns void
/*
 * Function: glAlphaFunc
 *
 * Purpose: Maps the external glAlphaFunc binding used for OpenGL rendering.
 */

extern function glAlphaFunc(func as u32, ref as double) from "opengl32.dll" symbol "glAlphaFunc" returns void
/*
 * Function: glGenTextures
 *
 * Purpose: Maps the external glGenTextures binding used for OpenGL rendering.
 */

extern function glGenTextures(n as int, textures as bytes) from "opengl32.dll" symbol "glGenTextures" returns void
/*
 * Function: glBindTexture
 *
 * Purpose: Maps the external glBindTexture binding used for OpenGL rendering.
 */

extern function glBindTexture(target as u32, texture as u32) from "opengl32.dll" symbol "glBindTexture" returns void
/*
 * Function: glTexParameteri
 *
 * Purpose: Maps the external glTexParameteri binding used for OpenGL rendering.
 */

extern function glTexParameteri(target as u32, pname as u32, param as int) from "opengl32.dll" symbol "glTexParameteri" returns void
/*
 * Function: glTexImage2D
 *
 * Purpose: Maps the external glTexImage2D binding used for OpenGL rendering.
 */

extern function glTexImage2D(target as u32, level as int, internalFormat as int, width as int, height as int, border as int, format as u32, typ as u32, pixels as bytes) from "opengl32.dll" symbol "glTexImage2D" returns void
/*
 * Function: glPixelStorei
 *
 * Purpose: Maps the external glPixelStorei binding used for OpenGL rendering.
 */

extern function glPixelStorei(pname as u32, param as int) from "opengl32.dll" symbol "glPixelStorei" returns void
/*
 * Function: glReadPixels
 *
 * Purpose: Maps the external glReadPixels binding used for OpenGL rendering.
 */

extern function glReadPixels(x as int, y as int, width as int, height as int, format as u32, typ as u32, pixels as bytes) from "opengl32.dll" symbol "glReadPixels" returns void
/*
 * Function: glReadBuffer
 *
 * Purpose: Maps the external glReadBuffer binding used for OpenGL rendering.
 */

extern function glReadBuffer(mode as u32) from "opengl32.dll" symbol "glReadBuffer" returns void

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

/*
* Function: IGL_WriteU16
* Purpose: Writes U16 data for the OpenGL backend.
*/
function inline IGL_WriteU16(buf, off, value)
  v = value & 0xffff
  buf[off] = v & 255
  buf[off + 1] =(v >> 8) & 255
end function

/*
* Function: IGL_WriteU32
* Purpose: Writes U32 data for the OpenGL backend.
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
* Purpose: Reads U32 data for the OpenGL backend.
*/
function inline IGL_ReadU32(buf, off)
  return buf[off] +(buf[off + 1] << 8) +(buf[off + 2] << 16) +(buf[off + 3] << 24)
end function

/*
* Function: IGL_WantsOpenGL
* Purpose: Checks open OpenGL conditions for the OpenGL backend.
*/
function IGL_WantsOpenGL()
  if typeof(M_CheckParm) != "function" then return false end if
  return M_CheckParm("-opengl") != 0 or M_CheckParm("--opengl") != 0 or M_CheckParm("-gl") != 0 or M_CheckParm("--gl") != 0
end function

/*
* Function: IGL_IsActive
* Purpose: Returns true when the OpenGL renderer is the active drawing path.
*/
function IGL_IsActive()
  return igl_active and igl_renderer_enabled
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
    return false
  end if

  igl_renderer_enabled = false
  if typeof(v) == "bool" and v then igl_renderer_enabled = true end if
  igl_frame_ready = false
  if igl_renderer_enabled then
    print "Renderer: OpenGL"
  else
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
  MGL_SetSwapInterval(0)
  print "OpenGL: WGL backend enabled (" + igl_width + "x" + igl_height + ")"
  return true
end function

/*
* Function: IGL_Resize
* Purpose: Provides resize helper behavior for the OpenGL backend.
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
* Purpose: Provides begin3 d helper behavior for the OpenGL backend.
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
* Purpose: Reads mark Frame Ready data from the OpenGL backend data stream.
*/
function IGL_MarkFrameReady()
  global igl_frame_ready
  if igl_active then igl_frame_ready = true end if
end function

/*
* Function: IGL_HasFrameReady
* Purpose: Reads has Frame Ready data from the OpenGL backend data stream.
*/
function IGL_HasFrameReady()
  return IGL_IsActive() and igl_frame_ready
end function

/*
* Function: IGL_Swap
* Purpose: Provides swap helper behavior for the OpenGL backend.
*/
function IGL_Swap()
  global igl_frame_ready

  if not igl_active then return false end if
  if not igl_frame_ready then return false end if
  if not IGL_MakeCurrent() then return false end if
  ok = SwapBuffers(igl_hdc)
  if ok then igl_frame_ready = false end if
  return ok
end function

/*
* Function: IGL_SetPalette
* Purpose: Updates palette state for the OpenGL backend.
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
* Purpose: Updates palette flash state for the OpenGL backend.
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
* Purpose: Provides nearest palette index helper behavior for the OpenGL backend.
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
* Purpose: Reads logical indexed data for the OpenGL backend.
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
* Purpose: Reads RGBA data for the OpenGL backend.
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
* Purpose: Provides ensure overlay texture helper behavior for the OpenGL backend.
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
* Purpose: Provides ensure frame texture helper behavior for the OpenGL backend.
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
* Purpose: Provides begin2 d helper behavior for the OpenGL backend.
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
* Purpose: Draws texture rect output for the OpenGL backend.
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
* Purpose: Draws indexed frame output for the OpenGL backend.
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
* Purpose: Draws RGBA frame output for the OpenGL backend.
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
* Purpose: Draws palette flash output for the OpenGL backend.
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
* Purpose: Draws indexed overlay output for the OpenGL backend.
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
* Function: IGL_Shutdown
* Purpose: Shuts down shutdown resources owned by the OpenGL backend system.
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
  igl_hrc = void
  igl_hdc = void
end function
