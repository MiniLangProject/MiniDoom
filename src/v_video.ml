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

screens =[0, 0, 0, 0, 0]

dirtybox =[-2147483648, 2147483647, 2147483647, -2147483648]

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
* Purpose: Implements the _u16le routine for the internal module support.
*/
function inline _u16le(b, off)
  return b[off] +(b[off + 1] << 8)
end function

/*
* Function: _s16le
* Purpose: Implements the _s16le routine for the internal module support.
*/
function inline _s16le(b, off)
  v = _u16le(b, off)
  if v >= 32768 then v = v - 65536 end if
  return v
end function

/*
* Function: _u32le
* Purpose: Implements the _u32le routine for the internal module support.
*/
function inline _u32le(b, off)
  return b[off] +(b[off + 1] << 8) +(b[off + 2] << 16) +(b[off + 3] << 24)
end function

/*
* Function: _clampInt
* Purpose: Implements the _clampInt routine for the internal module support.
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

  n = SCREENWIDTH * SCREENHEIGHT
  tmp =[]
  for i = 0 to 4
    tmp = tmp +[bytes(n, 0)]
  end for
  screens = tmp

  dirtybox =[-2147483648, 2147483647, 2147483647, -2147483648]
end function

/*
* Function: V_MarkRect
* Purpose: Implements the V_MarkRect routine for the engine module behavior.
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
* Purpose: Implements the V_CopyRect routine for the engine module behavior.
*/
function V_CopyRect(srcx, srcy, srcscrn, width, height, destx, desty, destscrn)
  src = screens[srcscrn]
  dest = screens[destscrn]
  for row = 0 to height - 1
    sy = srcy + row
    dy = desty + row
    for col = 0 to width - 1
      sx = srcx + col
      dx = destx + col
      dest[dy * SCREENWIDTH + dx] = src[sy * SCREENWIDTH + sx]
    end for
  end for

  if destscrn == 0 then
    V_MarkRect(destx, desty, width, height)
  end if
end function

/*
* Function: V_DrawPatch
* Purpose: Draws or renders output for the engine module behavior.
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
            destscreen[yy * SCREENWIDTH + dx] = patch[src + i]
          end if
        end for
      end if

      p = p + length + 4
    end while
  end for
end function

/*
* Function: V_DrawPatchDirect
* Purpose: Draws or renders output for the engine module behavior.
*/
function V_DrawPatchDirect(x, y, scrn, patch)
  V_DrawPatch(x, y, scrn, patch)
end function

/*
* Function: V_DrawBlock
* Purpose: Draws or renders output for the engine module behavior.
*/
function V_DrawBlock(x, y, scrn, width, height, src)
  if typeof(src) != "bytes" then return end if
  dest = screens[scrn]
  si = 0
  for row = 0 to height - 1
    dy = y + row
    for col = 0 to width - 1
      dx = x + col
      dest[dy * SCREENWIDTH + dx] = src[si]
      si = si + 1
    end for
  end for

  if scrn == 0 then
    V_MarkRect(x, y, width, height)
  end if
end function

/*
* Function: V_GetBlock
* Purpose: Reads or updates state used by the engine module behavior.
*/
function V_GetBlock(x, y, scrn, width, height, destBuf)
  if typeof(destBuf) != "bytes" then return end if
  src = screens[scrn]
  di = 0
  for row = 0 to height - 1
    sy = y + row
    for col = 0 to width - 1
      sx = x + col
      destBuf[di] = src[sy * SCREENWIDTH + sx]
      di = di + 1
    end for
  end for
end function

/*
* Function: V_DrawPatchFlipped
* Purpose: Draws or renders output for the engine module behavior.
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
            destscreen[yy * SCREENWIDTH + dx] = patch[src + i]
          end if
        end for
      end if

      p = p + length + 4
    end while
  end for
end function



