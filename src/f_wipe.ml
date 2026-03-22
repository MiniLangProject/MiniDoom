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

  Script: f_wipe.ml
  Purpose: Implements finale sequencing, text pages, and ending presentation.
*/
import z_zone
import i_video
import v_video
import m_random
import doomdef

const wipe_ColorXForm = 0
const wipe_Melt = 1

wipe_go = false
wipe_scr = void
wipe_scr_start = void
wipe_scr_end = void
wipe_y = void
wipe_seed = 1234567

/*
* Function: _wipeRand
* Purpose: Implements the _wipeRand routine for the internal module support.
*/
function inline _wipeRand()
  global wipe_seed

  wipe_seed =(wipe_seed * 1103515245 + 12345) & 0x7fffffff
  return (wipe_seed >> 16) & 32767
end function

/*
* Function: _FW_ReadU16LE
* Purpose: Implements the _FW_ReadU16LE routine for the internal module support.
*/
function inline _FW_ReadU16LE(buf, wordIndex)
  bi = wordIndex * 2
  if typeof(buf) != "bytes" then return 0 end if
  if bi < 0 or(bi + 1) >= len(buf) then return 0 end if
  return buf[bi] +(buf[bi + 1] << 8)
end function

/*
* Function: _FW_WriteU16LE
* Purpose: Implements the _FW_WriteU16LE routine for the internal module support.
*/
function inline _FW_WriteU16LE(buf, wordIndex, v)
  bi = wordIndex * 2
  if typeof(buf) != "bytes" then return end if
  if bi < 0 or(bi + 1) >= len(buf) then return end if
  if typeof(v) != "int" then v = 0 end if
  buf[bi] = v & 255
  buf[bi + 1] =(v >> 8) & 255
end function

/*
* Function: _FW_ByteCopy
* Purpose: Implements the _FW_ByteCopy routine for the internal module support.
*/
function _FW_ByteCopy(dst, src, count)
  if typeof(dst) != "bytes" or typeof(src) != "bytes" then return end if
  if typeof(count) != "int" or count <= 0 then return end if
  if count > len(dst) then count = len(dst) end if
  if count > len(src) then count = len(src) end if
  i = 0
  while i < count
    dst[i] = src[i]
    i = i + 1
  end while
end function

/*
* Function: wipe_shittyColMajorXform
* Purpose: Implements the wipe_shittyColMajorXform routine for the engine module behavior.
*/
function wipe_shittyColMajorXform(array16, width, height)

  if typeof(array16) != "bytes" then return end if
  if typeof(width) != "int" or typeof(height) != "int" then return end if
  if width <= 0 or height <= 0 then return end if

  words = width * height
  need = words * 2
  if words <= 0 or len(array16) < need then return end if

  dest = bytes(need, 0)
  y = 0
  while y < height
    x = 0
    while x < width
      srci = y * width + x
      dsti = x * height + y
      _FW_WriteU16LE(dest, dsti, _FW_ReadU16LE(array16, srci))
      x = x + 1
    end while
    y = y + 1
  end while

  i = 0
  while i < need
    array16[i] = dest[i]
    i = i + 1
  end while
end function

/*
* Function: wipe_initColorXForm
* Purpose: Initializes state and dependencies for the engine module behavior.
*/
function wipe_initColorXForm(width, height, ticks)
  ticks = ticks
  if typeof(wipe_scr) != "bytes" or typeof(wipe_scr_start) != "bytes" then return 0 end if
  _FW_ByteCopy(wipe_scr, wipe_scr_start, width * height)
  return 0
end function

/*
* Function: wipe_doColorXForm
* Purpose: Implements the wipe_doColorXForm routine for the engine module behavior.
*/
function wipe_doColorXForm(width, height, ticks)
  if typeof(wipe_scr) != "bytes" or typeof(wipe_scr_end) != "bytes" then return 1 end if
  if typeof(ticks) != "int" or ticks < 0 then ticks = 0 end if

  changed = false
  limit = width * height
  if limit > len(wipe_scr) then limit = len(wipe_scr) end if
  if limit > len(wipe_scr_end) then limit = len(wipe_scr_end) end if

  i = 0
  while i < limit
    w = wipe_scr[i]
    e = wipe_scr_end[i]
    if w != e then
      if w > e then
        nv = w - ticks
        if nv < e then
          wipe_scr[i] = e
        else
          wipe_scr[i] = nv
        end if
      else
        nv = w + ticks
        if nv > e then
          wipe_scr[i] = e
        else
          wipe_scr[i] = nv
        end if
      end if
      changed = true
    end if
    i = i + 1
  end while

  return not changed
end function

/*
* Function: wipe_exitColorXForm
* Purpose: Implements the wipe_exitColorXForm routine for the engine module behavior.
*/
function wipe_exitColorXForm(width, height, ticks)
  width = width
  height = height
  ticks = ticks
  return 0
end function

/*
* Function: wipe_initMelt
* Purpose: Initializes state and dependencies for the engine module behavior.
*/
function wipe_initMelt(width, height, ticks)
  global wipe_y

  ticks = ticks

  if typeof(wipe_scr) != "bytes" or typeof(wipe_scr_start) != "bytes" then return 0 end if
  _FW_ByteCopy(wipe_scr, wipe_scr_start, width * height)

  width2 = width >> 1
  if width2 > 0 then
    wipe_shittyColMajorXform(wipe_scr_start, width2, height)
    wipe_shittyColMajorXform(wipe_scr_end, width2, height)
  end if

  wipe_y =[]
  r0 = _wipeRand()
  if typeof(M_Random) == "function" then r0 = M_Random() end if
  wipe_y = wipe_y +[-(r0 % 16)]
  i = 1
  while i < width2
    rv = _wipeRand()
    if typeof(M_Random) == "function" then rv = M_Random() end if
    r =(rv % 3) - 1
    yy = wipe_y[i - 1] + r
    if yy > 0 then yy = 0 end if
    if yy == -16 then yy = -15 end if
    wipe_y = wipe_y +[yy]
    i = i + 1
  end while

  return 0
end function

/*
* Function: wipe_doMelt
* Purpose: Implements the wipe_doMelt routine for the engine module behavior.
*/
function wipe_doMelt(width, height, ticks)
  if typeof(wipe_scr) != "bytes" or typeof(wipe_scr_start) != "bytes" or typeof(wipe_scr_end) != "bytes" then
    return 1
  end if
  if typeof(wipe_y) != "array" and typeof(wipe_y) != "list" then
    return 1
  end if

  width2 = width >> 1
  if width2 <= 0 then return 1 end if

  done = true
  while ticks > 0
    ticks = ticks - 1

    x = 0
    while x < width2
      yy = wipe_y[x]
      if yy < 0 then
        wipe_y[x] = yy + 1
        done = false
      else if yy < height then

        dy = 6
        if yy < 16 then dy = yy + 1 end if
        if yy + dy >= height then dy = height - yy end if

        s = x * height + yy
        d = yy * width2 + x
        j = 0
        while j < dy
          _FW_WriteU16LE(wipe_scr, d, _FW_ReadU16LE(wipe_scr_end, s))
          s = s + 1
          d = d + width2
          j = j + 1
        end while

        yy2 = yy + dy
        wipe_y[x] = yy2

        s = x * height
        d = yy2 * width2 + x
        remain = height - yy2
        j = 0
        while j < remain
          _FW_WriteU16LE(wipe_scr, d, _FW_ReadU16LE(wipe_scr_start, s))
          s = s + 1
          d = d + width2
          j = j + 1
        end while

        done = false
      end if
      x = x + 1
    end while
  end while

  return done
end function

/*
* Function: wipe_exitMelt
* Purpose: Implements the wipe_exitMelt routine for the engine module behavior.
*/
function wipe_exitMelt(width, height, ticks)
  global wipe_y

  width = width
  height = height
  ticks = ticks
  wipe_y = void
  return 0
end function

/*
* Function: wipe_StartScreen
* Purpose: Starts runtime behavior in the engine module behavior.
*/
function wipe_StartScreen(x, y, width, height)
  global wipe_scr
  global wipe_scr_start

  x = x
  y = y
  width = width
  height = height

  wipe_scr = screens[0]
  wipe_scr_start = screens[2]
  if typeof(I_ReadScreen) == "function" and typeof(wipe_scr_start) == "bytes" then
    I_ReadScreen(wipe_scr_start)
  end if
  return 0
end function

/*
* Function: wipe_EndScreen
* Purpose: Implements the wipe_EndScreen routine for the engine module behavior.
*/
function wipe_EndScreen(x, y, width, height)
  global wipe_scr_end

  wipe_scr_end = screens[3]
  if typeof(I_ReadScreen) == "function" and typeof(wipe_scr_end) == "bytes" then
    I_ReadScreen(wipe_scr_end)
  end if
  if typeof(V_DrawBlock) == "function" and typeof(wipe_scr_start) == "bytes" then
    V_DrawBlock(x, y, 0, width, height, wipe_scr_start)
  end if
  return 0
end function

/*
* Function: wipe_ScreenWipe
* Purpose: Implements the wipe_ScreenWipe routine for the engine module behavior.
*/
function wipe_ScreenWipe(wipeno, x, y, width, height, ticks)
  global wipe_go
  global wipe_scr

  x = x
  y = y

  if typeof(ticks) != "int" or ticks < 0 then ticks = 0 end if

  if not wipe_go then
    wipe_go = true
    wipe_scr = screens[0]
    if wipeno == wipe_ColorXForm then
      wipe_initColorXForm(width, height, ticks)
    else
      wipe_initMelt(width, height, ticks)
    end if
  end if

  if typeof(V_MarkRect) == "function" then
    V_MarkRect(0, 0, width, height)
  end if

  rc = 1
  if wipeno == wipe_ColorXForm then
    rc = wipe_doColorXForm(width, height, ticks)
  else
    rc = wipe_doMelt(width, height, ticks)
  end if

  if rc then
    wipe_go = false
    if wipeno == wipe_ColorXForm then
      wipe_exitColorXForm(width, height, ticks)
    else
      wipe_exitMelt(width, height, ticks)
    end if
  end if

  return not wipe_go
end function



