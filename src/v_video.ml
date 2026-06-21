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

  Script: v_video.ml
  Purpose: Provides video buffer and palette helper routines used by renderer and UI.
*/
import doomtype
import doomdef
import r_data
import i_system
import r_local
import doomdef
import doomdata
import m_bbox
import m_swap
import w_wad
import r_upscaled
import r_renderer
import i_gl

screens =[0, 0, 0, 0, 0]

dirtybox =[-2147483648, 2147483647, 2147483647, -2147483648]
v_overlaymask = void
v_overlay_minx = SCREENWIDTH
v_overlay_miny = SCREENHEIGHT
v_overlay_maxx = -1
v_overlay_maxy = -1
v_overlay_active = false
v_hioverlay = void
v_hioverlaymask = void
v_hioverlay_scale = 1
v_hioverlay_minx = 0
v_hioverlay_miny = 0
v_hioverlay_maxx = -1
v_hioverlay_maxy = -1
v_hioverlay_cached_name = ""
v_hioverlay_cached_x = 0
v_hioverlay_cached_y = 0
v_hioverlay_cached_flipped = false
v_hioverlay_cached_scale = 0
v_hioverlay_cached_valid = false

gammatable =[
[
1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16,
17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32,
33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48,
49, 50, 51, 52, 53, 54, 55, 56, 57, 58, 59, 60, 61, 62, 63, 64,
65, 66, 67, 68, 69, 70, 71, 72, 73, 74, 75, 76, 77, 78, 79, 80,
81, 82, 83, 84, 85, 86, 87, 88, 89, 90, 91, 92, 93, 94, 95, 96,
97, 98, 99, 100, 101, 102, 103, 104, 105, 106, 107, 108, 109, 110, 111, 112,
113, 114, 115, 116, 117, 118, 119, 120, 121, 122, 123, 124, 125, 126, 127, 128,
128, 129, 130, 131, 132, 133, 134, 135, 136, 137, 138, 139, 140, 141, 142, 143,
144, 145, 146, 147, 148, 149, 150, 151, 152, 153, 154, 155, 156, 157, 158, 159,
160, 161, 162, 163, 164, 165, 166, 167, 168, 169, 170, 171, 172, 173, 174, 175,
176, 177, 178, 179, 180, 181, 182, 183, 184, 185, 186, 187, 188, 189, 190, 191,
192, 193, 194, 195, 196, 197, 198, 199, 200, 201, 202, 203, 204, 205, 206, 207,
208, 209, 210, 211, 212, 213, 214, 215, 216, 217, 218, 219, 220, 221, 222, 223,
224, 225, 226, 227, 228, 229, 230, 231, 232, 233, 234, 235, 236, 237, 238, 239,
240, 241, 242, 243, 244, 245, 246, 247, 248, 249, 250, 251, 252, 253, 254, 255
],
[
2, 4, 5, 7, 8, 10, 11, 12, 14, 15, 16, 18, 19, 20, 21, 23,
24, 25, 26, 27, 29, 30, 31, 32, 33, 34, 36, 37, 38, 39, 40, 41,
42, 44, 45, 46, 47, 48, 49, 50, 51, 52, 54, 55, 56, 57, 58, 59,
60, 61, 62, 63, 64, 65, 66, 67, 69, 70, 71, 72, 73, 74, 75, 76,
77, 78, 79, 80, 81, 82, 83, 84, 85, 86, 87, 88, 89, 90, 91, 92,
93, 94, 95, 96, 97, 98, 99, 100, 101, 102, 103, 104, 105, 106, 107, 108,
109, 110, 111, 112, 113, 114, 115, 116, 117, 118, 119, 120, 121, 122, 123, 124,
125, 126, 127, 128, 129, 129, 130, 131, 132, 133, 134, 135, 136, 137, 138, 139,
140, 141, 142, 143, 144, 145, 146, 147, 148, 148, 149, 150, 151, 152, 153, 154,
155, 156, 157, 158, 159, 160, 161, 162, 163, 163, 164, 165, 166, 167, 168, 169,
170, 171, 172, 173, 174, 175, 175, 176, 177, 178, 179, 180, 181, 182, 183, 184,
185, 186, 186, 187, 188, 189, 190, 191, 192, 193, 194, 195, 196, 196, 197, 198,
199, 200, 201, 202, 203, 204, 205, 205, 206, 207, 208, 209, 210, 211, 212, 213,
214, 214, 215, 216, 217, 218, 219, 220, 221, 222, 222, 223, 224, 225, 226, 227,
228, 229, 230, 230, 231, 232, 233, 234, 235, 236, 237, 237, 238, 239, 240, 241,
242, 243, 244, 245, 245, 246, 247, 248, 249, 250, 251, 252, 252, 253, 254, 255
],
[
4, 7, 9, 11, 13, 15, 17, 19, 21, 22, 24, 26, 27, 29, 30, 32,
33, 35, 36, 38, 39, 40, 42, 43, 45, 46, 47, 48, 50, 51, 52, 54,
55, 56, 57, 59, 60, 61, 62, 63, 65, 66, 67, 68, 69, 70, 72, 73,
74, 75, 76, 77, 78, 79, 80, 82, 83, 84, 85, 86, 87, 88, 89, 90,
91, 92, 93, 94, 95, 96, 97, 98, 100, 101, 102, 103, 104, 105, 106, 107,
108, 109, 110, 111, 112, 113, 114, 114, 115, 116, 117, 118, 119, 120, 121, 122,
123, 124, 125, 126, 127, 128, 129, 130, 131, 132, 133, 133, 134, 135, 136, 137,
138, 139, 140, 141, 142, 143, 144, 144, 145, 146, 147, 148, 149, 150, 151, 152,
153, 153, 154, 155, 156, 157, 158, 159, 160, 160, 161, 162, 163, 164, 165, 166,
166, 167, 168, 169, 170, 171, 172, 172, 173, 174, 175, 176, 177, 178, 178, 179,
180, 181, 182, 183, 183, 184, 185, 186, 187, 188, 188, 189, 190, 191, 192, 193,
193, 194, 195, 196, 197, 197, 198, 199, 200, 201, 201, 202, 203, 204, 205, 206,
206, 207, 208, 209, 210, 210, 211, 212, 213, 213, 214, 215, 216, 217, 217, 218,
219, 220, 221, 221, 222, 223, 224, 224, 225, 226, 227, 228, 228, 229, 230, 231,
231, 232, 233, 234, 235, 235, 236, 237, 238, 238, 239, 240, 241, 241, 242, 243,
244, 244, 245, 246, 247, 247, 248, 249, 250, 251, 251, 252, 253, 254, 254, 255
],
[
8, 12, 16, 19, 22, 24, 27, 29, 31, 34, 36, 38, 40, 41, 43, 45,
47, 49, 50, 52, 53, 55, 57, 58, 60, 61, 63, 64, 65, 67, 68, 70,
71, 72, 74, 75, 76, 77, 79, 80, 81, 82, 84, 85, 86, 87, 88, 90,
91, 92, 93, 94, 95, 96, 98, 99, 100, 101, 102, 103, 104, 105, 106, 107,
108, 109, 110, 111, 112, 113, 114, 115, 116, 117, 118, 119, 120, 121, 122, 123,
124, 125, 126, 127, 128, 129, 130, 131, 132, 133, 134, 135, 135, 136, 137, 138,
139, 140, 141, 142, 143, 143, 144, 145, 146, 147, 148, 149, 150, 150, 151, 152,
153, 154, 155, 155, 156, 157, 158, 159, 160, 160, 161, 162, 163, 164, 165, 165,
166, 167, 168, 169, 169, 170, 171, 172, 173, 173, 174, 175, 176, 176, 177, 178,
179, 180, 180, 181, 182, 183, 183, 184, 185, 186, 186, 187, 188, 189, 189, 190,
191, 192, 192, 193, 194, 195, 195, 196, 197, 197, 198, 199, 200, 200, 201, 202,
202, 203, 204, 205, 205, 206, 207, 207, 208, 209, 210, 210, 211, 212, 212, 213,
214, 214, 215, 216, 216, 217, 218, 219, 219, 220, 221, 221, 222, 223, 223, 224,
225, 225, 226, 227, 227, 228, 229, 229, 230, 231, 231, 232, 233, 233, 234, 235,
235, 236, 237, 237, 238, 238, 239, 240, 240, 241, 242, 242, 243, 244, 244, 245,
246, 246, 247, 247, 248, 249, 249, 250, 251, 251, 252, 253, 253, 254, 254, 255
],
[
16, 23, 28, 32, 36, 39, 42, 45, 48, 50, 53, 55, 57, 60, 62, 64,
66, 68, 69, 71, 73, 75, 76, 78, 80, 81, 83, 84, 86, 87, 89, 90,
92, 93, 94, 96, 97, 98, 100, 101, 102, 103, 105, 106, 107, 108, 109, 110,
112, 113, 114, 115, 116, 117, 118, 119, 120, 121, 122, 123, 124, 125, 126, 128,
128, 129, 130, 131, 132, 133, 134, 135, 136, 137, 138, 139, 140, 141, 142, 143,
143, 144, 145, 146, 147, 148, 149, 150, 150, 151, 152, 153, 154, 155, 155, 156,
157, 158, 159, 159, 160, 161, 162, 163, 163, 164, 165, 166, 166, 167, 168, 169,
169, 170, 171, 172, 172, 173, 174, 175, 175, 176, 177, 177, 178, 179, 180, 180,
181, 182, 182, 183, 184, 184, 185, 186, 187, 187, 188, 189, 189, 190, 191, 191,
192, 193, 193, 194, 195, 195, 196, 196, 197, 198, 198, 199, 200, 200, 201, 202,
202, 203, 203, 204, 205, 205, 206, 207, 207, 208, 208, 209, 210, 210, 211, 211,
212, 213, 213, 214, 214, 215, 216, 216, 217, 217, 218, 219, 219, 220, 220, 221,
221, 222, 223, 223, 224, 224, 225, 225, 226, 227, 227, 228, 228, 229, 229, 230,
230, 231, 232, 232, 233, 233, 234, 234, 235, 235, 236, 236, 237, 237, 238, 239,
239, 240, 240, 241, 241, 242, 242, 243, 243, 244, 244, 245, 245, 246, 246, 247,
247, 248, 248, 249, 249, 250, 250, 251, 251, 252, 252, 253, 254, 254, 255, 255
]
]
usegamma = 0

/*
* Function: _u16le
* Purpose: Provides u16le helper behavior for the video buffer.
*/
function inline _u16le(b, off)
  return b[off] +(b[off + 1] << 8)
end function

/*
* Function: _s16le
* Purpose: Provides s16le helper behavior for the video buffer.
*/
function inline _s16le(b, off)
  v = _u16le(b, off)
  if v >= 32768 then v = v - 65536 end if
  return v
end function

/*
* Function: _u32le
* Purpose: Provides u32le helper behavior for the video buffer.
*/
function inline _u32le(b, off)
  return b[off] +(b[off + 1] << 8) +(b[off + 2] << 16) +(b[off + 3] << 24)
end function

/*
* Function: _clampInt
* Purpose: Clamps clamp Int values to the supported video buffer range.
*/
function inline _clampInt(x, lo, hi)
  if x < lo then return lo end if
  if x > hi then return hi end if
  return x
end function

/*
* Function: V_Init
* Purpose: Initializes state and dependencies for the engine module behavior.
*/
function V_Init()
  global screens
  global dirtybox
  global v_overlaymask
  global v_overlay_minx
  global v_overlay_miny
  global v_overlay_maxx
  global v_overlay_maxy
  global v_overlay_active

  n = SCREENWIDTH * SCREENHEIGHT
  tmp =[]
  for i = 0 to 4
    tmp = tmp +[bytes(n, 0)]
  end for
  screens = tmp

  dirtybox =[-2147483648, 2147483647, 2147483647, -2147483648]
  v_overlaymask = bytes(n, 0)
  v_overlay_minx = SCREENWIDTH
  v_overlay_miny = SCREENHEIGHT
  v_overlay_maxx = -1
  v_overlay_maxy = -1
  v_overlay_active = false
end function

/*
* Function: V_ClearOverlayMask
* Purpose: Clears the per-frame mask of logical pixels drawn by late UI patches.
*/
function V_ClearOverlayMask()
  global v_overlay_minx
  global v_overlay_miny
  global v_overlay_maxx
  global v_overlay_maxy
  global v_overlay_active

  if typeof(v_overlaymask) == "bytes" then
    if v_overlay_maxx >= v_overlay_minx and v_overlay_maxy >= v_overlay_miny then
      y = v_overlay_miny
      while y <= v_overlay_maxy
        off = y * SCREENWIDTH + v_overlay_minx
        fillBytes(v_overlaymask, off, v_overlay_maxx - v_overlay_minx + 1, 0)
        y = y + 1
      end while
    else
      fillBytes(v_overlaymask, 0, len(v_overlaymask), 0)
    end if
  end if
  v_overlay_minx = SCREENWIDTH
  v_overlay_miny = SCREENHEIGHT
  v_overlay_maxx = -1
  v_overlay_maxy = -1
  v_overlay_active = true
end function

/*
* Function: V_EndOverlayMask
* Purpose: Stops recording late UI overlay pixels while keeping the recorded mask for presentation.
*/
function V_EndOverlayMask()
  global v_overlay_active
  v_overlay_active = false
end function

/*
* Function: V_EnsureHighresOverlay
* Purpose: Lazily allocates high-resolution patch overlay buffers.
*/
function V_EnsureHighresOverlay()
  global v_hioverlay
  global v_hioverlaymask
  global v_hioverlay_scale

  if not R_RendererUsesHDAssets() then return false end if
  s = 1
  if typeof(RU_RenderScale) == "function" then s = RU_RenderScale() end if
  if typeof(s) != "int" or s < 1 then s = 1 end if
  if s > 4 then s = 4 end if
  if s <= 1 then return false end if
  need = SCREENWIDTH * s * SCREENHEIGHT * s
  if typeof(v_hioverlay) != "bytes" or len(v_hioverlay) < need or v_hioverlay_scale != s then
    v_hioverlay = bytes(need, 0)
    v_hioverlaymask = bytes(need, 0)
    v_hioverlay_scale = s
  end if
  return true
end function

/*
* Function: V_ClearHighresOverlay
* Purpose: Clears high-resolution prepared patch overlay pixels from the previous frame.
*/
function V_ClearHighresOverlay()
  global v_hioverlay_minx
  global v_hioverlay_miny
  global v_hioverlay_maxx
  global v_hioverlay_maxy
  global v_hioverlay_cached_valid
  global v_hioverlay_cached_name

  if typeof(v_hioverlaymask) == "bytes" then
    w = SCREENWIDTH * v_hioverlay_scale
    if v_hioverlay_maxx >= v_hioverlay_minx and v_hioverlay_maxy >= v_hioverlay_miny then
      y = v_hioverlay_miny
      while y <= v_hioverlay_maxy
        off = y * w + v_hioverlay_minx
        fillBytes(v_hioverlaymask, off, v_hioverlay_maxx - v_hioverlay_minx + 1, 0)
        y = y + 1
      end while
    else
      fillBytes(v_hioverlaymask, 0, len(v_hioverlaymask), 0)
    end if
  end if
  v_hioverlay_minx = 0
  v_hioverlay_miny = 0
  v_hioverlay_maxx = -1
  v_hioverlay_maxy = -1
  v_hioverlay_cached_valid = false
  v_hioverlay_cached_name = ""
end function

/*
* Function: V_HighresOverlayCanReuse
* Purpose: Reports whether the previous high-resolution page overlay is still intact.
*/
function V_HighresOverlayCanReuse()
  if not v_hioverlay_cached_valid then return false end if
  if typeof(v_hioverlaymask) != "bytes" then return false end if
  if v_hioverlay_maxx < v_hioverlay_minx or v_hioverlay_maxy < v_hioverlay_miny then return false end if
  return true
end function

/*
* Function: V_ClearHighresOverlayKeepLogicalY
* Purpose: Clears high-resolution overlay pixels above a logical Y coordinate while preserving the lower persistent area.
*/
function V_ClearHighresOverlayKeepLogicalY(logicalY)
  global v_hioverlay_minx
  global v_hioverlay_miny
  global v_hioverlay_maxx
  global v_hioverlay_maxy
  global v_hioverlay_cached_valid
  global v_hioverlay_cached_name

  if typeof(logicalY) != "int" or logicalY <= 0 then
    V_ClearHighresOverlay()
    return
  end if
  if not V_EnsureHighresOverlay() or typeof(v_hioverlaymask) != "bytes" then
    V_ClearHighresOverlay()
    return
  end if

  w = SCREENWIDTH * v_hioverlay_scale
  h = SCREENHEIGHT * v_hioverlay_scale
  keepY = logicalY * v_hioverlay_scale
  if keepY <= 0 then
    V_ClearHighresOverlay()
    return
  end if
  if keepY > h then keepY = h end if

  if keepY > 0 then
    y = 0
    while y < keepY
      fillBytes(v_hioverlaymask, y * w, w, 0)
      y = y + 1
    end while
  end if

  if keepY < h then
    v_hioverlay_minx = 0
    v_hioverlay_miny = keepY
    v_hioverlay_maxx = w - 1
    v_hioverlay_maxy = h - 1
  else
    v_hioverlay_minx = 0
    v_hioverlay_miny = 0
    v_hioverlay_maxx = -1
    v_hioverlay_maxy = -1
  end if
  v_hioverlay_cached_valid = false
  v_hioverlay_cached_name = ""
end function

/*
* Function: V_ClearHighresOverlayRect
* Purpose: Clears one logical rectangle from the high-resolution overlay mask.
*/
function V_ClearHighresOverlayRect(x, y, width, height)
  global v_hioverlay_cached_valid
  global v_hioverlay_cached_name

  if width <= 0 or height <= 0 then return end if
  if typeof(v_hioverlaymask) != "bytes" or not V_EnsureHighresOverlay() then return end if
  v_hioverlay_cached_valid = false
  v_hioverlay_cached_name = ""
  s = v_hioverlay_scale
  w = SCREENWIDTH * s
  h = SCREENHEIGHT * s
  x0 = x * s
  y0 = y * s
  x1 = (x + width) * s - 1
  y1 = (y + height) * s - 1
  if x0 < 0 then x0 = 0 end if
  if y0 < 0 then y0 = 0 end if
  if x1 >= w then x1 = w - 1 end if
  if y1 >= h then y1 = h - 1 end if
  if x1 < x0 or y1 < y0 then return end if
  yy = y0
  while yy <= y1
    fillBytes(v_hioverlaymask, yy * w + x0, x1 - x0 + 1, 0)
    yy = yy + 1
  end while
end function

/*
* Function: V_MarkHighresOverlayPixel
* Purpose: Marks one prepared high-resolution overlay pixel as valid.
*/
function inline V_MarkHighresOverlayPixel(idx, x, y)
  global v_hioverlay_minx
  global v_hioverlay_miny
  global v_hioverlay_maxx
  global v_hioverlay_maxy

  if typeof(v_hioverlaymask) != "bytes" or idx < 0 or idx >= len(v_hioverlaymask) then return end if
  v_hioverlaymask[idx] = 1
  if v_hioverlay_maxx < v_hioverlay_minx then
    v_hioverlay_minx = x
    v_hioverlay_miny = y
    v_hioverlay_maxx = x
    v_hioverlay_maxy = y
    return
  end if
  if x < v_hioverlay_minx then v_hioverlay_minx = x end if
  if y < v_hioverlay_miny then v_hioverlay_miny = y end if
  if x > v_hioverlay_maxx then v_hioverlay_maxx = x end if
  if y > v_hioverlay_maxy then v_hioverlay_maxy = y end if
end function

/*
* Function: V_DrawUpscaledFlatOverlay
* Purpose: Draws a prepared upscaled flat image into the high-resolution overlay.
*/
function V_DrawUpscaledFlatOverlay(name)
  global v_hioverlay_cached_valid
  global v_hioverlay_cached_name

  if typeof(name) != "string" or name == "" or not V_EnsureHighresOverlay() then return false end if
  if typeof(RU_GetFlat) != "function" then return false end if
  entry = RU_GetFlat(name)
  if entry is void or typeof(entry.data) != "bytes" then return false end if
  if entry.width <= 0 or entry.height <= 0 or len(entry.data) < entry.width * entry.height then return false end if

  v_hioverlay_cached_valid = false
  v_hioverlay_cached_name = ""
  s = v_hioverlay_scale
  dw = SCREENWIDTH * s
  dh = SCREENHEIGHT * s
  y = 0
  while y < dh
    sy = y % entry.height
    row = y * dw
    x = 0
    while x < dw
      sx = x % entry.width
      idx = row + x
      v_hioverlay[idx] = entry.data[sy * entry.width + sx]
      V_MarkHighresOverlayPixel(idx, x, y)
      x = x + 1
    end while
    y = y + 1
  end while
  return true
end function

/*
* Function: V_DrawNamedUpscaledPatchOverlay
* Purpose: Draws a prepared upscaled patch image into the high-resolution overlay.
*/
function V_DrawNamedUpscaledPatchOverlay(x, y, name, flipped)
  global v_hioverlay_cached_name
  global v_hioverlay_cached_x
  global v_hioverlay_cached_y
  global v_hioverlay_cached_flipped
  global v_hioverlay_cached_scale
  global v_hioverlay_cached_valid

  if typeof(name) != "string" or name == "" or not V_EnsureHighresOverlay() then return false end if
  if V_HighresOverlayCanReuse() and name == v_hioverlay_cached_name and x == v_hioverlay_cached_x and y == v_hioverlay_cached_y and flipped == v_hioverlay_cached_flipped and v_hioverlay_scale == v_hioverlay_cached_scale then
    return true
  end if
  if typeof(RU_GetPatch) != "function" then return false end if
  entry = RU_GetPatch(name)
  if entry is void and typeof(RU_GetSprite) == "function" then entry = RU_GetSprite(name) end if
  if entry is void or typeof(entry.data) != "bytes" then return false end if
  if entry.width <= 0 or entry.height <= 0 or len(entry.data) < entry.width * entry.height then return false end if

  s = v_hioverlay_scale
  dw = SCREENWIDTH * s
  dh = SCREENHEIGHT * s
  baseX = x * s
  baseY = y * s
  yy = 0
  while yy < entry.height
    dy = baseY + yy
    if dy >= 0 and dy < dh then
      xx = 0
      while xx < entry.width
        sx = xx
        if flipped then sx = entry.width - 1 - xx end if
        dx = baseX + xx
        if dx >= 0 and dx < dw then
          c = entry.data[yy * entry.width + sx]
          if c != 255 then
            di = dy * dw + dx
            v_hioverlay[di] = c
            V_MarkHighresOverlayPixel(di, dx, dy)
          end if
        end if
        xx = xx + 1
      end while
    end if
    yy = yy + 1
  end while
  v_hioverlay_cached_name = name
  v_hioverlay_cached_x = x
  v_hioverlay_cached_y = y
  v_hioverlay_cached_flipped = flipped
  v_hioverlay_cached_scale = v_hioverlay_scale
  v_hioverlay_cached_valid = true
  return true
end function

/*
* Function: V_DrawNamedUpscaledPatchOverlayLogicalScale
* Purpose: Draws a prepared HDWAD patch at a Doom-layout scale without running any scaler.
*/
function V_DrawNamedUpscaledPatchOverlayLogicalScale(x, y, name, flipped, logicalScale)
  if typeof(name) != "string" or name == "" or not V_EnsureHighresOverlay() then return false end if
  if typeof(logicalScale) != "int" or logicalScale < 1 then logicalScale = 1 end if
  if typeof(RU_GetPatch) != "function" then return false end if
  entry = RU_GetPatch(name)
  if entry is void and typeof(RU_GetSprite) == "function" then entry = RU_GetSprite(name) end if
  if entry is void or typeof(entry.data) != "bytes" then return false end if
  if entry.width <= 0 or entry.height <= 0 or len(entry.data) < entry.width * entry.height then return false end if

  s = v_hioverlay_scale
  dw = SCREENWIDTH * s
  dh = SCREENHEIGHT * s
  baseX = x * s - entry.xoffset * logicalScale
  baseY = y * s - entry.yoffset * logicalScale
  yy = 0
  while yy < entry.height
    xx = 0
    while xx < entry.width
      sx = xx
      if flipped then sx = entry.width - 1 - xx end if
      c = entry.data[yy * entry.width + sx]
      if c != 255 then
        by = baseY + yy * logicalScale
        ly = 0
        while ly < logicalScale
          dy = by + ly
          if dy >= 0 and dy < dh then
            bx = baseX + xx * logicalScale
            lx = 0
            while lx < logicalScale
              dx = bx + lx
              if dx >= 0 and dx < dw then
                di = dy * dw + dx
                v_hioverlay[di] = c
                V_MarkHighresOverlayPixel(di, dx, dy)
              end if
              lx = lx + 1
            end while
          end if
          ly = ly + 1
        end while
      end if
      xx = xx + 1
    end while
    yy = yy + 1
  end while
  return true
end function

/*
* Function: V_DrawUpscaledPatchOverlay
* Purpose: Draws upscaled patch overlay output for the video buffer.
*/
function V_DrawUpscaledPatchOverlay(x, y, patch, flipped)
  if typeof(patch) != "bytes" or not V_EnsureHighresOverlay() then return false end if
  if typeof(W_NameForCachedData) != "function" or typeof(RU_GetPatch) != "function" then return false end if
  name = W_NameForCachedData(patch)
  if name == "" then return false end if
  return V_DrawNamedUpscaledPatchOverlay(x, y, name, flipped)
end function

/*
* Function: V_MarkOverlayPixel
* Purpose: Marks one logical pixel as part of the late UI overlay.
*/
function inline V_MarkOverlayPixel(idx, x, y)
  global v_overlay_minx
  global v_overlay_miny
  global v_overlay_maxx
  global v_overlay_maxy

  if not v_overlay_active then return end if
  if typeof(v_overlaymask) != "bytes" or idx < 0 or idx >= len(v_overlaymask) then return end if
  v_overlaymask[idx] = 1
  if x < v_overlay_minx then v_overlay_minx = x end if
  if y < v_overlay_miny then v_overlay_miny = y end if
  if x > v_overlay_maxx then v_overlay_maxx = x end if
  if y > v_overlay_maxy then v_overlay_maxy = y end if
end function

/*
* Function: V_MarkRect
* Purpose: Provides rect helper behavior for the video buffer.
*/
function V_MarkRect(x, y, width, height)

  x2 = x + width - 1
  y2 = y + height - 1

  if x < dirtybox[2] then dirtybox[2] = x end if
  if x > dirtybox[3] then dirtybox[3] = x end if
  if y < dirtybox[1] then dirtybox[1] = y end if
  if y > dirtybox[0] then dirtybox[0] = y end if

  if x2 < dirtybox[2] then dirtybox[2] = x2 end if
  if x2 > dirtybox[3] then dirtybox[3] = x2 end if
  if y2 < dirtybox[1] then dirtybox[1] = y2 end if
  if y2 > dirtybox[0] then dirtybox[0] = y2 end if
end function

/*
* Function: V_CopyRect
* Purpose: Updates rect state for the video buffer.
*/
function V_CopyRect(srcx, srcy, srcscrn, width, height, destx, desty, destscrn)
  src = screens[srcscrn]
  dest = screens[destscrn]
  srcRow = srcy * SCREENWIDTH + srcx
  destRow = desty * SCREENWIDTH + destx
  for row = 0 to height - 1
    copyBytes(dest, destRow, src, srcRow, width)
    srcRow = srcRow + SCREENWIDTH
    destRow = destRow + SCREENWIDTH
  end for

  if destscrn == 0 then
    V_MarkRect(destx, desty, width, height)
    V_ClearHighresOverlayRect(destx, desty, width, height)
  end if
end function

/*
* Function: V_DrawPatch
* Purpose: Draws patch output for the video buffer.
*/
function V_DrawPatch(x, y, scrn, patch)
  if typeof(patch) != "bytes" then

    return
  end if

  topoffset = _s16le(patch, 6)
  leftoffset = _s16le(patch, 4)
  width = _s16le(patch, 0)
  height = _s16le(patch, 2)

  y = y - topoffset
  x = x - leftoffset

  if scrn == 0 then
    V_MarkRect(x, y, width, height)
    V_DrawUpscaledPatchOverlay(x, y, patch, false)
  end if

  destscreen = screens[scrn]

  for col = 0 to width - 1
    colofs = _u32le(patch, 8 + col * 4)
    p = colofs

    while true
      topdelta = patch[p]
      if topdelta == 255 then
        break
      end if
      length = patch[p + 1]

      src = p + 3

      dy = y + topdelta
      dx = x + col

      if dx < 0 or dx >= SCREENWIDTH then

      else
        for i = 0 to length - 1
          yy = dy + i
          if yy >= 0 and yy < SCREENHEIGHT then
            idx = yy * SCREENWIDTH + dx
            destscreen[idx] = patch[src + i]
            if scrn == 0 then V_MarkOverlayPixel(idx, dx, yy) end if
          end if
        end for
      end if

      p = p + length + 4
    end while
  end for
end function

/*
* Function: V_DrawPatchDirect
* Purpose: Draws patch direct output for the video buffer.
*/
function V_DrawPatchDirect(x, y, scrn, patch)
  V_DrawPatch(x, y, scrn, patch)
end function

/*
* Function: V_DrawBlock
* Purpose: Draws block output for the video buffer.
*/
function V_DrawBlock(x, y, scrn, width, height, src)
  if typeof(src) != "bytes" then return end if
  dest = screens[scrn]
  si = 0
  di = y * SCREENWIDTH + x
  for row = 0 to height - 1
    copyBytes(dest, di, src, si, width)
    if scrn == 0 and typeof(v_overlaymask) == "bytes" then
      mx = 0
      while mx < width
        idx = di + mx
        if idx >= 0 and idx < len(v_overlaymask) then V_MarkOverlayPixel(idx, x + mx, y + row) end if
        mx = mx + 1
      end while
    end if
    si = si + width
    di = di + SCREENWIDTH
  end for

  if scrn == 0 then
    V_MarkRect(x, y, width, height)
  end if
end function

/*
* Function: V_GetBlock
* Purpose: Reads block data for the video buffer.
*/
function V_GetBlock(x, y, scrn, width, height, destBuf)
  if typeof(destBuf) != "bytes" then return end if
  src = screens[scrn]
  di = 0
  si = y * SCREENWIDTH + x
  for row = 0 to height - 1
    copyBytes(destBuf, di, src, si, width)
    di = di + width
    si = si + SCREENWIDTH
  end for
end function

/*
* Function: V_DrawPatchFlipped
* Purpose: Draws patch flipped output for the video buffer.
*/
function V_DrawPatchFlipped(x, y, scrn, patch)
  if typeof(patch) != "bytes" then return end if

  topoffset = _s16le(patch, 6)
  leftoffset = _s16le(patch, 4)
  width = _s16le(patch, 0)
  height = _s16le(patch, 2)

  y = y - topoffset
  x = x - leftoffset

  if scrn == 0 then
    V_MarkRect(x, y, width, height)
    V_DrawUpscaledPatchOverlay(x, y, patch, true)
  end if

  destscreen = screens[scrn]

  for col = 0 to width - 1

    col2 =(width - 1) - col
    colofs = _u32le(patch, 8 + col2 * 4)
    p = colofs

    while true
      topdelta = patch[p]
      if topdelta == 255 then break end if
      length = patch[p + 1]
      src = p + 3
      dy = y + topdelta
      dx = x + col

      if dx >= 0 and dx < SCREENWIDTH then
        for i = 0 to length - 1
          yy = dy + i
          if yy >= 0 and yy < SCREENHEIGHT then
            idx = yy * SCREENWIDTH + dx
            destscreen[idx] = patch[src + i]
            if scrn == 0 then V_MarkOverlayPixel(idx, dx, yy) end if
          end if
        end for
      end if

      p = p + length + 4
    end while
  end for
end function



