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

  Script: i_video.ml
  Purpose: Implements platform integration for input, timing, video, audio, and OS services.
*/
import doomtype
import doomstat
import i_system
import v_video
import m_argv
import d_main
import doomdef

import std.time
import std.fs as fs
import std.math

const _I_BI_RGB = 0
const _I_DIB_RGB_COLORS = 0
const _I_SRCCOPY = 0x00CC0020
const _I_COLORONCOLOR = 3
const _I_VK_LBUTTON = 0x01
const _I_VK_RBUTTON = 0x02
const _I_VK_MBUTTON = 0x04
const _I_PM_REMOVE = 1
const _I_WM_QUIT = 0x0012
const _I_WM_CLOSE = 0x0010
const _I_WM_DESTROY = 0x0002
const _I_WM_NCDESTROY = 0x0082
const _I_WS_OVERLAPPEDWINDOW = 0x00CF0000
const _I_WS_POPUP = -2147483648
const _I_WS_VISIBLE = 0x10000000
const _I_SW_SHOW = 5
const _I_SW_MAXIMIZE = 3
const _I_WINDOW_SCALE = 2
const _I_BMP_HEADER_SIZE = 54
const _I_SCREENSHOT_INTERVAL_MS = 1000
const _I_SM_CXSCREEN = 0
const _I_SM_CYSCREEN = 1
const _I_SWP_FRAMECHANGED = 0x0020
const _I_SWP_SHOWWINDOW = 0x0040
const _I_GWL_STYLE = -16

/*
* Function: CreateWindowExW
* Purpose: Creates and initializes runtime objects for the engine module behavior.
*/
extern function CreateWindowExW(exStyle as u32, className as wstr, windowName as wstr, style as u32, x as int, y as int, width as int, height as int, parent as ptr, menu as ptr, instance as ptr, param as ptr) from "user32.dll" symbol "CreateWindowExW" returns ptr

/*
* Function: AdjustWindowRect
* Purpose: Implements the AdjustWindowRect routine for the engine module behavior.
*/
extern function AdjustWindowRect(rect as bytes, style as u32, hasMenu as bool) from "user32.dll" symbol "AdjustWindowRect" returns bool

/*
* Function: ShowWindow
* Purpose: Implements the ShowWindow routine for the engine module behavior.
*/
extern function ShowWindow(hwnd as ptr, cmdShow as int) from "user32.dll" symbol "ShowWindow" returns bool

/*
* Function: UpdateWindow
* Purpose: Advances per-tick logic for the engine module behavior.
*/
extern function UpdateWindow(hwnd as ptr) from "user32.dll" symbol "UpdateWindow" returns bool

/*
* Function: DestroyWindow
* Purpose: Implements the DestroyWindow routine for the engine module behavior.
*/
extern function DestroyWindow(hwnd as ptr) from "user32.dll" symbol "DestroyWindow" returns bool

/*
* Function: GetDC
* Purpose: Reads or updates state used by the engine module behavior.
*/
extern function GetDC(hwnd as ptr) from "user32.dll" symbol "GetDC" returns ptr

/*
* Function: ReleaseDC
* Purpose: Implements the ReleaseDC routine for the engine module behavior.
*/
extern function ReleaseDC(hwnd as ptr, hdc as ptr) from "user32.dll" symbol "ReleaseDC" returns int

/*
* Function: GetClientRect
* Purpose: Reads or updates state used by the engine module behavior.
*/
extern function GetClientRect(hwnd as ptr, rect as bytes) from "user32.dll" symbol "GetClientRect" returns bool

/*
* Function: PeekMessageW
* Purpose: Implements the PeekMessageW routine for the engine module behavior.
*/
extern function PeekMessageW(msg as bytes, hwnd as ptr, minMsg as u32, maxMsg as u32, removeMsg as u32) from "user32.dll" symbol "PeekMessageW" returns bool

/*
* Function: TranslateMessage
* Purpose: Implements the TranslateMessage routine for the engine module behavior.
*/
extern function TranslateMessage(msg as bytes) from "user32.dll" symbol "TranslateMessage" returns bool

/*
* Function: DispatchMessageW
* Purpose: Implements the DispatchMessageW routine for the engine module behavior.
*/
extern function DispatchMessageW(msg as bytes) from "user32.dll" symbol "DispatchMessageW" returns ptr

/*
* Function: GetAsyncKeyState
* Purpose: Reads or updates state used by the engine module behavior.
*/
extern function GetAsyncKeyState(vkey as int) from "user32.dll" symbol "GetAsyncKeyState" returns int

/*
* Function: SetWindowTextW
* Purpose: Reads or updates state used by the engine module behavior.
*/
extern function SetWindowTextW(hwnd as ptr, text as wstr) from "user32.dll" symbol "SetWindowTextW" returns bool

/*
* Function: GetCursorPos
* Purpose: Reads or updates state used by the engine module behavior.
*/
extern function GetCursorPos(point as bytes) from "user32.dll" symbol "GetCursorPos" returns bool

/*
* Function: GetForegroundWindow
* Purpose: Reads or updates state used by the engine module behavior.
*/
extern function GetForegroundWindow() from "user32.dll" symbol "GetForegroundWindow" returns ptr

/*
* Function: ShowCursor
* Purpose: Shows or hides the system cursor.
*/
extern function ShowCursor(show as bool) from "user32.dll" symbol "ShowCursor" returns int

/*
* Function: GetSystemMetrics
* Purpose: Reads or updates state used by the engine module behavior.
*/
extern function GetSystemMetrics(index as int) from "user32.dll" symbol "GetSystemMetrics" returns int

/*
* Function: SetWindowPos
* Purpose: Reads or updates state used by the engine module behavior.
*/
extern function SetWindowPos(hwnd as ptr, insertAfter as ptr, x as int, y as int, width as int, height as int, flags as u32) from "user32.dll" symbol "SetWindowPos" returns bool

/*
* Function: GetWindowLongPtrW
* Purpose: Reads or updates state used by the engine module behavior.
*/
extern function GetWindowLongPtrW(hwnd as ptr, index as int) from "user32.dll" symbol "GetWindowLongPtrW" returns ptr

/*
* Function: SetWindowLongPtrW
* Purpose: Reads or updates state used by the engine module behavior.
*/
extern function SetWindowLongPtrW(hwnd as ptr, index as int, newLong as ptr) from "user32.dll" symbol "SetWindowLongPtrW" returns ptr

/*
* Function: SetForegroundWindow
* Purpose: Reads or updates state used by the engine module behavior.
*/
extern function SetForegroundWindow(hwnd as ptr) from "user32.dll" symbol "SetForegroundWindow" returns bool

/*
* Function: BringWindowToTop
* Purpose: Implements the BringWindowToTop routine for the engine module behavior.
*/
extern function BringWindowToTop(hwnd as ptr) from "user32.dll" symbol "BringWindowToTop" returns bool

/*
* Function: SetActiveWindow
* Purpose: Reads or updates state used by the engine module behavior.
*/
extern function SetActiveWindow(hwnd as ptr) from "user32.dll" symbol "SetActiveWindow" returns ptr

/*
* Function: IsWindow
* Purpose: Reads or updates state used by the engine module behavior.
*/
extern function IsWindow(hwnd as ptr) from "user32.dll" symbol "IsWindow" returns bool

/*
* Function: StretchDIBits
* Purpose: Implements the StretchDIBits routine for the engine module behavior.
*/
extern function StretchDIBits(hdc as ptr, xDest as int, yDest as int, destWidth as int, destHeight as int, xSrc as int, ySrc as int, srcWidth as int, srcHeight as int, bits as bytes, bmi as bytes, usage as u32, rop as u32) from "gdi32.dll" symbol "StretchDIBits" returns int

/*
* Function: SetStretchBltMode
* Purpose: Reads or updates state used by the engine module behavior.
*/
extern function SetStretchBltMode(hdc as ptr, mode as int) from "gdi32.dll" symbol "SetStretchBltMode" returns int

/*
* Function: CreateDirectoryW
* Purpose: Creates and initializes runtime objects for the engine module behavior.
*/
extern function CreateDirectoryW(path as wstr, security as ptr) from "kernel32.dll" symbol "CreateDirectoryW" returns bool

/*
* Function: GetConsoleWindow
* Purpose: Reads or updates state used by the engine module behavior.
*/
extern function GetConsoleWindow() from "kernel32.dll" symbol "GetConsoleWindow" returns ptr

_i_inited = false
_i_hwnd = void
_i_hdc = void
_i_ownsWindow = false
_i_paletteRgb = 0
_i_bmi = 0
_i_msg = 0
_i_rect = 0
_i_windowFailed = false
_i_keyVk =[]
_i_keyDoom =[]
_i_keyPrev =[]
_i_screenshotEnabled = false
_i_screenshotDir = "render_output"
_i_screenshotDirReady = false
_i_screenshotNextTick = 0
_i_screenshotIndex = 0
_i_screenshotWriteError = false
_i_titleBase = "Doom Minilang Port"
_i_titleLast = ""
_i_fpsWindowStart = 0
_i_fpsFrameCount = 0
_i_fpsValue = 0
_i_mousePoint = 0
_i_mouseInited = false
_i_mousePrevX = 0
_i_mousePrevY = 0
_i_mousePrevButtons = 0
_i_fullscreen = false
_i_cursorHidden = false
_i_loadingStatusText = ""
_i_loadingAnimPhase = 0

/*
* Function: _I_ToIntOr
* Purpose: Implements the _I_ToIntOr routine for the internal module support.
*/
function _I_ToIntOr(v, fallback)
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
* Function: _I_IDiv
* Purpose: Implements the _I_IDiv routine for the internal module support.
*/
function inline _I_IDiv(a, b)
  a = _I_ToIntOr(a, 0)
  b = _I_ToIntOr(b, 0)
  if b == 0 then return 0 end if
  q = a / b
  if q >= 0 then return std.math.floor(q) end if
  return std.math.ceil(q)
end function

/*
* Function: _I_SetWindowTitle
* Purpose: Reads or updates state used by the internal module support.
*/
function inline _I_SetWindowTitle(title)
  global _i_titleLast

  if _i_hwnd is void then return end if
  if typeof(title) != "string" then return end if
  if title == _i_titleLast then return end if
  SetWindowTextW(_i_hwnd, title)
  _i_titleLast = title
end function

/*
* Function: _I_UpdateWindowTitle
* Purpose: Advances per-tick logic for the internal module support.
*/
function _I_UpdateWindowTitle()
  global _i_fpsWindowStart
  global _i_fpsFrameCount
  global _i_fpsValue

  if _i_hwnd is void then return end if

  if typeof(_i_loadingStatusText) == "string" and len(_i_loadingStatusText) > 0 then
    _I_SetWindowTitle(_i_titleBase + " | " + _i_loadingStatusText)
    return
  end if

  now = std.time.ticks()
  if typeof(now) != "int" then return end if

  if _i_fpsWindowStart == 0 then
    _i_fpsWindowStart = now
    _i_fpsFrameCount = 0
    _I_SetWindowTitle(_i_titleBase + " | FPS: " + _i_fpsValue)
    return
  end if

  _i_fpsFrameCount = _i_fpsFrameCount + 1
  elapsed = now - _i_fpsWindowStart
  if elapsed < 1000 then return end if

  fps = 0
  if elapsed > 0 then
    fps = _I_IDiv(_i_fpsFrameCount * 1000, elapsed)
  end if
  if fps < 0 then fps = 0 end if
  _i_fpsValue = fps
  _I_SetWindowTitle(_i_titleBase + " | FPS: " + _i_fpsValue)

  _i_fpsWindowStart = now
  _i_fpsFrameCount = 0
end function

/*
* Function: _I_DrawLoadingIndicator
* Purpose: Renders a small animated loading marker in the lower-right corner of the software framebuffer.
*/
function _I_DrawLoadingIndicator()
  global _i_loadingAnimPhase
  if not _i_inited then return end if
  if typeof(screens) != "array" or len(screens) <= 0 then return end if
  fb = screens[0]
  if typeof(fb) != "bytes" then return end if
  if len(fb) < SCREENWIDTH * SCREENHEIGHT then return end if

  size = 14
  x0 = SCREENWIDTH - size - 6
  y0 = SCREENHEIGHT - size - 6
  if x0 < 0 or y0 < 0 then return end if

  y = 0
  while y < size
    base = (y0 + y) * SCREENWIDTH + x0
    x = 0
    while x < size
      fb[base + x] = 0
      x = x + 1
    end while
    y = y + 1
  end while

  phase = _I_ToIntOr(_i_loadingAnimPhase, 0) & 3
  dotx = [2, size - 5, size - 5, 2]
  doty = [2, 2, size - 5, size - 5]
  i = 0
  while i < 4
    c = 96
    if i == phase then c = 248 end if
    px = x0 + dotx[i]
    py = y0 + doty[i]
    yy = 0
    while yy < 3
      row = (py + yy) * SCREENWIDTH + px
      xx = 0
      while xx < 3
        fb[row + xx] = c
        xx = xx + 1
      end while
      yy = yy + 1
    end while
    i = i + 1
  end while
  _i_loadingAnimPhase = _i_loadingAnimPhase + 1
end function

/*
* Function: _I_SetCursorVisible
* Purpose: Keeps cursor visibility in sync while game window is active.
*/
function _I_SetCursorVisible(visible)
  global _i_cursorHidden

  if typeof(visible) != "bool" then return end if

  if visible then
    if not _i_cursorHidden then return end if
    tries = 0
    while tries < 8
      count = ShowCursor(true)
      if count >= 0 then
        _i_cursorHidden = false
        return
      end if
      tries = tries + 1
    end while
    return
  end if

  if _i_cursorHidden then return end if
  tries = 0
  while tries < 8
    count = ShowCursor(false)
    if count < 0 then
      _i_cursorHidden = true
      return
    end if
    tries = tries + 1
  end while
  _i_cursorHidden = true
end function

/*
* Function: _I_AddKeyMap
* Purpose: Implements the _I_AddKeyMap routine for the internal module support.
*/
function inline _I_AddKeyMap(vk, doomKey)
  global _i_keyVk
  global _i_keyDoom
  global _i_keyPrev

  _i_keyVk = _i_keyVk +[vk]
  _i_keyDoom = _i_keyDoom +[doomKey]
  _i_keyPrev = _i_keyPrev +[0]
end function

/*
* Function: _I_InitKeyMap
* Purpose: Initializes state and dependencies for the internal module support.
*/
function _I_InitKeyMap()
  global _i_keyVk
  global _i_keyDoom
  global _i_keyPrev

  if typeof(_i_keyVk) == "array" and len(_i_keyVk) > 0 then return end if

  _i_keyVk =[]
  _i_keyDoom =[]
  _i_keyPrev =[]

  _I_AddKeyMap(0x25, KEY_LEFTARROW)
  _I_AddKeyMap(0x26, KEY_UPARROW)
  _I_AddKeyMap(0x27, KEY_RIGHTARROW)
  _I_AddKeyMap(0x28, KEY_DOWNARROW)
  _I_AddKeyMap(0x1B, KEY_ESCAPE)
  _I_AddKeyMap(0x0D, KEY_ENTER)
  _I_AddKeyMap(0x09, KEY_TAB)
  _I_AddKeyMap(0x08, KEY_BACKSPACE)
  _I_AddKeyMap(0x13, KEY_PAUSE)
  _I_AddKeyMap(0x10, KEY_RSHIFT)
  _I_AddKeyMap(0x11, KEY_RCTRL)
  _I_AddKeyMap(0x12, KEY_RALT)
  _I_AddKeyMap(0x20, 32)
  _I_AddKeyMap(0xBD, KEY_MINUS)
  _I_AddKeyMap(0xBB, KEY_EQUALS)
  _I_AddKeyMap(0xBC, 44)
  _I_AddKeyMap(0xBE, 46)

  _I_AddKeyMap(0x70, KEY_F1)
  _I_AddKeyMap(0x71, KEY_F2)
  _I_AddKeyMap(0x72, KEY_F3)
  _I_AddKeyMap(0x73, KEY_F4)
  _I_AddKeyMap(0x74, KEY_F5)
  _I_AddKeyMap(0x75, KEY_F6)
  _I_AddKeyMap(0x76, KEY_F7)
  _I_AddKeyMap(0x77, KEY_F8)
  _I_AddKeyMap(0x78, KEY_F9)
  _I_AddKeyMap(0x79, KEY_F10)
  _I_AddKeyMap(0x7A, KEY_F11)
  _I_AddKeyMap(0x7B, KEY_F12)

  // Top-row digits.
  _I_AddKeyMap(0x30, 48)
  _I_AddKeyMap(0x31, 49)
  _I_AddKeyMap(0x32, 50)
  _I_AddKeyMap(0x33, 51)
  _I_AddKeyMap(0x34, 52)
  _I_AddKeyMap(0x35, 53)
  _I_AddKeyMap(0x36, 54)
  _I_AddKeyMap(0x37, 55)
  _I_AddKeyMap(0x38, 56)
  _I_AddKeyMap(0x39, 57)

  // Numpad digits and decimal point.
  _I_AddKeyMap(0x60, 48)
  _I_AddKeyMap(0x61, 49)
  _I_AddKeyMap(0x62, 50)
  _I_AddKeyMap(0x63, 51)
  _I_AddKeyMap(0x64, 52)
  _I_AddKeyMap(0x65, 53)
  _I_AddKeyMap(0x66, 54)
  _I_AddKeyMap(0x67, 55)
  _I_AddKeyMap(0x68, 56)
  _I_AddKeyMap(0x69, 57)
  _I_AddKeyMap(0x6E, 46)

  _I_AddKeyMap(0x41, 97)
  _I_AddKeyMap(0x42, 98)
  _I_AddKeyMap(0x43, 99)
  _I_AddKeyMap(0x44, 100)
  _I_AddKeyMap(0x45, 101)
  _I_AddKeyMap(0x46, 102)
  _I_AddKeyMap(0x47, 103)
  _I_AddKeyMap(0x48, 104)
  _I_AddKeyMap(0x49, 105)
  _I_AddKeyMap(0x4A, 106)
  _I_AddKeyMap(0x4B, 107)
  _I_AddKeyMap(0x4C, 108)
  _I_AddKeyMap(0x4D, 109)
  _I_AddKeyMap(0x4E, 110)
  _I_AddKeyMap(0x4F, 111)
  _I_AddKeyMap(0x50, 112)
  _I_AddKeyMap(0x51, 113)
  _I_AddKeyMap(0x52, 114)
  _I_AddKeyMap(0x53, 115)
  _I_AddKeyMap(0x54, 116)
  _I_AddKeyMap(0x55, 117)
  _I_AddKeyMap(0x56, 118)
  _I_AddKeyMap(0x57, 119)
  _I_AddKeyMap(0x58, 120)
  _I_AddKeyMap(0x59, 121)
  _I_AddKeyMap(0x5A, 122)
end function

/*
* Function: _I_WriteU16
* Purpose: Implements the _I_WriteU16 routine for the internal module support.
*/
function inline _I_WriteU16(buf, off, value)
  if value < 0 then value = value + 65536 end if
  buf[off] = value & 255
  buf[off + 1] =(value >> 8) & 255
end function

/*
* Function: _I_WriteU32
* Purpose: Implements the _I_WriteU32 routine for the internal module support.
*/
function inline _I_WriteU32(buf, off, value)
  if value < 0 then value = value + 4294967296 end if
  buf[off] = value & 255
  buf[off + 1] =(value >> 8) & 255
  buf[off + 2] =(value >> 16) & 255
  buf[off + 3] =(value >> 24) & 255
end function

/*
* Function: _I_ReadU32
* Purpose: Implements the _I_ReadU32 routine for the internal module support.
*/
function inline _I_ReadU32(buf, off)
  return buf[off] +(buf[off + 1] << 8) +(buf[off + 2] << 16) +(buf[off + 3] << 24)
end function

/*
* Function: _I_ReadS32
* Purpose: Implements the _I_ReadS32 routine for the internal module support.
*/
function inline _I_ReadS32(buf, off)
  v = _I_ReadU32(buf, off)
  if v >= 2147483648 then v = v - 4294967296 end if
  return v
end function

/*
* Function: _I_InitDefaultPalette
* Purpose: Initializes state and dependencies for the internal module support.
*/
function _I_InitDefaultPalette()
  if typeof(_i_paletteRgb) != "bytes" then return end if
  for i = 0 to 255
    o = i * 3
    _i_paletteRgb[o] = i
    _i_paletteRgb[o + 1] = i
    _i_paletteRgb[o + 2] = i
  end for
end function

/*
* Function: _I_UpdateBitmapColorTable
* Purpose: Advances per-tick logic for the internal module support.
*/
function _I_UpdateBitmapColorTable()
  if typeof(_i_paletteRgb) != "bytes" then return end if
  if typeof(_i_bmi) != "bytes" then return end if
  for i = 0 to 255
    src = i * 3
    dst = 40 + i * 4
    _i_bmi[dst] = _i_paletteRgb[src + 2]
    _i_bmi[dst + 1] = _i_paletteRgb[src + 1]
    _i_bmi[dst + 2] = _i_paletteRgb[src]
    _i_bmi[dst + 3] = 0
  end for
end function

/*
* Function: _I_InitBitmapInfo
* Purpose: Initializes state and dependencies for the internal module support.
*/
function _I_InitBitmapInfo()
  if typeof(_i_bmi) != "bytes" then return end if

  _I_WriteU32(_i_bmi, 0, 40)
  _I_WriteU32(_i_bmi, 4, SCREENWIDTH)
  _I_WriteU32(_i_bmi, 8, - SCREENHEIGHT)
  _I_WriteU16(_i_bmi, 12, 1)
  _I_WriteU16(_i_bmi, 14, 8)
  _I_WriteU32(_i_bmi, 16, _I_BI_RGB)
  _I_WriteU32(_i_bmi, 20, SCREENWIDTH * SCREENHEIGHT)
  _I_WriteU32(_i_bmi, 24, 0)
  _I_WriteU32(_i_bmi, 28, 0)
  _I_WriteU32(_i_bmi, 32, 256)
  _I_WriteU32(_i_bmi, 36, 0)

  _I_UpdateBitmapColorTable()
end function

/*
* Function: _I_CreateWindow
* Purpose: Creates and initializes runtime objects for the internal module support.
*/
function _I_CreateWindow()
  global _i_hwnd
  global _i_hdc
  global _i_windowFailed
  global _i_ownsWindow

  if not(_i_hwnd is void) then return true end if
  if _i_windowFailed then return false end if

  clientW = SCREENWIDTH * _I_WINDOW_SCALE
  clientH = SCREENHEIGHT * _I_WINDOW_SCALE
  sw = GetSystemMetrics(_I_SM_CXSCREEN)
  sh = GetSystemMetrics(_I_SM_CYSCREEN)
  if sw <= 0 then sw = clientW end if
  if sh <= 0 then sh = clientH end if

  style = _I_WS_OVERLAPPEDWINDOW | _I_WS_VISIBLE
  winX = 100
  winY = 100
  winW = clientW
  winH = clientH
  if _i_fullscreen then
    style = _I_WS_POPUP | _I_WS_VISIBLE
    winX = 0
    winY = 0
    winW = sw
    winH = sh
  else
    _I_WriteU32(_i_rect, 0, 0)
    _I_WriteU32(_i_rect, 4, 0)
    _I_WriteU32(_i_rect, 8, clientW)
    _I_WriteU32(_i_rect, 12, clientH)
    AdjustWindowRect(_i_rect, style, false)
    winW = _I_ReadS32(_i_rect, 8) - _I_ReadS32(_i_rect, 0)
    winH = _I_ReadS32(_i_rect, 12) - _I_ReadS32(_i_rect, 4)
  end if

  hwnd = CreateWindowExW(0, "STATIC", "Doom Minilang Port", style, winX, winY, winW, winH, void, void, void, void)
  if hwnd is void then
    _i_windowFailed = true
    print "I_InitGraphics: CreateWindowExW failed"
    return false
  end if

  _i_hwnd = hwnd
  _i_ownsWindow = true
  _i_hdc = GetDC(_i_hwnd)
  if not(_i_hdc is void) then SetStretchBltMode(_i_hdc, _I_COLORONCOLOR) end if
  if _i_fullscreen then
    _ = SetWindowLongPtrW(_i_hwnd, _I_GWL_STYLE, _I_WS_POPUP | _I_WS_VISIBLE)
    SetWindowPos(_i_hwnd, void, 0, 0, sw, sh, _I_SWP_FRAMECHANGED | _I_SWP_SHOWWINDOW)
    BringWindowToTop(_i_hwnd)
    SetForegroundWindow(_i_hwnd)
    _ = SetActiveWindow(_i_hwnd)
  else
    BringWindowToTop(_i_hwnd)
    SetForegroundWindow(_i_hwnd)
    _ = SetActiveWindow(_i_hwnd)
  end if
  ShowWindow(_i_hwnd, _I_SW_SHOW)
  UpdateWindow(_i_hwnd)
  return true
end function

/*
* Function: _I_PumpMessages
* Purpose: Implements the _I_PumpMessages routine for the internal module support.
*/
function _I_PumpMessages()
  if _i_hwnd is not void and not IsWindow(_i_hwnd) then
    if typeof(I_Quit) == "function" then I_Quit() end if
    return
  end if

  while PeekMessageW(_i_msg, void, 0, 0, _I_PM_REMOVE)
    msg = _I_ReadU32(_i_msg, 8)
    if msg == _I_WM_CLOSE or msg == _I_WM_DESTROY or msg == _I_WM_NCDESTROY or msg == _I_WM_QUIT then
      if typeof(I_Quit) == "function" then I_Quit() end if
      return
    end if
    TranslateMessage(_i_msg)
    DispatchMessageW(_i_msg)
  end while
end function

/*
* Function: _I_EnsureScreenshotDir
* Purpose: Implements the _I_EnsureScreenshotDir routine for the internal module support.
*/
function _I_EnsureScreenshotDir()
  global _i_screenshotDirReady

  if _i_screenshotDirReady then return true end if

  if fs.exists(_i_screenshotDir) then
    _i_screenshotDirReady = true
    return true
  end if

  ok = CreateDirectoryW(_i_screenshotDir, void)
  if ok or fs.exists(_i_screenshotDir) then
    _i_screenshotDirReady = true
    return true
  end if

  return false
end function

/*
* Function: _I_BuildBmpFromFrame
* Purpose: Implements the _I_BuildBmpFromFrame routine for the internal module support.
*/
function _I_BuildBmpFromFrame()
  src = screens[0]
  if typeof(src) != "bytes" then return end if
  if len(src) <(SCREENWIDTH * SCREENHEIGHT) then return end if
  if typeof(_i_paletteRgb) != "bytes" or len(_i_paletteRgb) < 768 then return end if

  palBytes = 256 * 4
  pixelBytes = SCREENWIDTH * SCREENHEIGHT
  fileSize = _I_BMP_HEADER_SIZE + palBytes + pixelBytes
  bmp = bytes(fileSize, 0)

  bmp[0] = 66
  bmp[1] = 77
  _I_WriteU32(bmp, 2, fileSize)
  _I_WriteU32(bmp, 10, _I_BMP_HEADER_SIZE + palBytes)

  _I_WriteU32(bmp, 14, 40)
  _I_WriteU32(bmp, 18, SCREENWIDTH)
  _I_WriteU32(bmp, 22, - SCREENHEIGHT)
  _I_WriteU16(bmp, 26, 1)
  _I_WriteU16(bmp, 28, 8)
  _I_WriteU32(bmp, 30, _I_BI_RGB)
  _I_WriteU32(bmp, 34, pixelBytes)
  _I_WriteU32(bmp, 38, 2835)
  _I_WriteU32(bmp, 42, 2835)
  _I_WriteU32(bmp, 46, 256)
  _I_WriteU32(bmp, 50, 0)

  pi = 0
  while pi < 256
    so = pi * 3
    po = _I_BMP_HEADER_SIZE + pi * 4
    bmp[po] = _i_paletteRgb[so + 2]
    bmp[po + 1] = _i_paletteRgb[so + 1]
    bmp[po + 2] = _i_paletteRgb[so]
    bmp[po + 3] = 0
    pi = pi + 1
  end while

  si = 0
  di = _I_BMP_HEADER_SIZE + palBytes
  while si < pixelBytes
    bmp[di] = src[si]
    di = di + 1
    si = si + 1
  end while

  return bmp
end function

/*
* Function: _I_WriteAutoScreenshot
* Purpose: Implements the _I_WriteAutoScreenshot routine for the internal module support.
*/
function _I_WriteAutoScreenshot()
  global _i_screenshotIndex
  global _i_screenshotWriteError

  if not _I_EnsureScreenshotDir() then return end if

  bmp = _I_BuildBmpFromFrame()
  if typeof(bmp) != "bytes" then return end if

  name = "frame_" + _i_screenshotIndex + ".bmp"
  _i_screenshotIndex = _i_screenshotIndex + 1
  path = fs.joinPath(_i_screenshotDir, name)
  wr = fs.writeAllBytes(path, bmp)
  if typeof(wr) == "error" and not _i_screenshotWriteError then
    _i_screenshotWriteError = true
    print "I_Video: auto screenshot write failed: " + wr.message
  end if
end function

/*
* Function: _I_MaybeAutoScreenshot
* Purpose: Implements the _I_MaybeAutoScreenshot routine for the internal module support.
*/
function _I_MaybeAutoScreenshot()
  global _i_screenshotNextTick

  if not _i_screenshotEnabled then return end if

  now = std.time.ticks()
  if typeof(now) != "int" then return end if

  if _i_screenshotNextTick == 0 then
    _i_screenshotNextTick = now + _I_SCREENSHOT_INTERVAL_MS
    return
  end if

  if now < _i_screenshotNextTick then return end if

  _I_WriteAutoScreenshot()

  while _i_screenshotNextTick <= now
    _i_screenshotNextTick = _i_screenshotNextTick + _I_SCREENSHOT_INTERVAL_MS
  end while
end function

/*
* Function: _I_ReleaseKeyboard
* Purpose: Implements the _I_ReleaseKeyboard routine for the internal module support.
*/
function _I_ReleaseKeyboard(postEvents)
  _I_InitKeyMap()

  if typeof(_i_keyPrev) != "array" then return end if
  if typeof(_i_keyDoom) != "array" then return end if

  n = len(_i_keyPrev)
  i = 0
  while i < n
    if _i_keyPrev[i] != 0 then
      _i_keyPrev[i] = 0
      if postEvents and i < len(_i_keyDoom) and typeof(D_PostEvent) == "function" then
        D_PostEvent(event_t(evtype_t.ev_keyup, _i_keyDoom[i], 0, 0))
      end if
    end if
    i = i + 1
  end while
end function

/*
* Function: _I_PollKeyboard
* Purpose: Implements the _I_PollKeyboard routine for the internal module support.
*/
function _I_PollKeyboard()
  _I_InitKeyMap()

  if typeof(_i_keyVk) != "array" then return end if
  if typeof(_i_keyDoom) != "array" then return end if
  if typeof(_i_keyPrev) != "array" then return end if
  if _i_hwnd is void then
    _I_ReleaseKeyboard(true)
    return
  end if

  fg = GetForegroundWindow()
  if fg != _i_hwnd then

    _I_ReleaseKeyboard(true)
    return
  end if

  n = len(_i_keyVk)
  i = 0
  while i < n
    vk = _i_keyVk[i]
    doomKey = _i_keyDoom[i]
    st = GetAsyncKeyState(vk)
    down =((st & 32768) != 0)
    prev =(_i_keyPrev[i] != 0)

    if down != prev then
      if down then
        _i_keyPrev[i] = 1
        if typeof(D_PostEvent) == "function" then
          D_PostEvent(event_t(evtype_t.ev_keydown, doomKey, 0, 0))
        end if
      else
        _i_keyPrev[i] = 0
        if typeof(D_PostEvent) == "function" then
          D_PostEvent(event_t(evtype_t.ev_keyup, doomKey, 0, 0))
        end if
      end if
    end if

    i = i + 1
  end while
end function

/*
* Function: _I_MouseButtonsNow
* Purpose: Implements the _I_MouseButtonsNow routine for the internal module support.
*/
function inline _I_MouseButtonsNow()
  b = 0
  if (GetAsyncKeyState(_I_VK_LBUTTON) & 32768) != 0 then b = b | 1 end if
  if (GetAsyncKeyState(_I_VK_RBUTTON) & 32768) != 0 then b = b | 2 end if
  if (GetAsyncKeyState(_I_VK_MBUTTON) & 32768) != 0 then b = b | 4 end if
  return b
end function

/*
* Function: _I_PollMouse
* Purpose: Implements the _I_PollMouse routine for the internal module support.
*/
function _I_PollMouse()
  global _i_mouseInited
  global _i_mousePrevX
  global _i_mousePrevY
  global _i_mousePrevButtons
  global _i_fullscreen

  if typeof(usemouse) == "int" and usemouse == 0 then return end if
  if _i_hwnd is void then return end if
  if typeof(_i_mousePoint) != "bytes" then return end if

  fg = GetForegroundWindow()
  if fg != _i_hwnd then
    _I_SetCursorVisible(true)
    _i_mouseInited = false
    return
  end if
  _I_SetCursorVisible(false)

  if not GetCursorPos(_i_mousePoint) then return end if

  x = _I_ReadS32(_i_mousePoint, 0)
  y = _I_ReadS32(_i_mousePoint, 4)
  buttons = _I_MouseButtonsNow()

  if not _i_mouseInited then
    _i_mousePrevX = x
    _i_mousePrevY = y
    _i_mousePrevButtons = buttons
    _i_mouseInited = true
    return
  end if

  dx =(x - _i_mousePrevX) << 2
  dy =(_i_mousePrevY - y) << 2

  if dx != 0 or dy != 0 or buttons != _i_mousePrevButtons then
    if typeof(D_PostEvent) == "function" then
      D_PostEvent(event_t(evtype_t.ev_mouse, buttons, dx, dy))
    end if
  end if

  _i_mousePrevX = x
  _i_mousePrevY = y
  _i_mousePrevButtons = buttons
end function

/*
* Function: I_InitGraphics
* Purpose: Initializes state and dependencies for the platform layer.
*/
function I_InitGraphics()
  global _i_inited
  global _i_paletteRgb
  global _i_bmi
  global _i_msg
  global _i_rect
  global _i_screenshotEnabled
  global _i_screenshotDirReady
  global _i_screenshotNextTick
  global _i_screenshotIndex
  global _i_screenshotWriteError
  global _i_fpsWindowStart
  global _i_fpsFrameCount
  global _i_fpsValue
  global _i_titleLast
  global _i_mousePoint
  global _i_mouseInited
  global _i_mousePrevX
  global _i_mousePrevY
  global _i_mousePrevButtons
  global _i_fullscreen

  if _i_inited then return end if

  if screens[0] == 0 then
    V_Init()
  end if

  _i_paletteRgb = bytes(768, 0)
  _i_bmi = bytes(40 + 256 * 4, 0)
  _i_msg = bytes(56, 0)
  _i_rect = bytes(16, 0)
  _i_mousePoint = bytes(8, 0)

  _I_InitDefaultPalette()
  _I_InitBitmapInfo()
  _I_InitKeyMap()

  _i_fullscreen = true
  if typeof(M_CheckParm) == "function" then
    if M_CheckParm("-fullscreen") != 0 or M_CheckParm("--fullscreen") != 0 then
      _i_fullscreen = true
    end if
    if M_CheckParm("-windowed") != 0 or M_CheckParm("--windowed") != 0 then
      _i_fullscreen = false
    end if
  end if

  _I_CreateWindow()

  _i_screenshotEnabled = false
  if typeof(M_CheckParm) == "function" then
    if M_CheckParm("-shots") != 0 or M_CheckParm("--shots") != 0 or M_CheckParm("-autoshots") != 0 or M_CheckParm("--autoshots") != 0 or M_CheckParm("-autoscreenshots") != 0 or M_CheckParm("--autoscreenshots") != 0 then
      _i_screenshotEnabled = true
    end if
    if M_CheckParm("-noshots") != 0 or M_CheckParm("--noshots") != 0 then
      _i_screenshotEnabled = false
    end if
  end if
  _i_screenshotDirReady = false
  _i_screenshotNextTick = 0
  _i_screenshotIndex = 0
  _i_screenshotWriteError = false
  _i_fpsWindowStart = 0
  _i_fpsFrameCount = 0
  _i_fpsValue = 0
  _i_titleLast = ""
  _i_mouseInited = false
  _i_mousePrevX = 0
  _i_mousePrevY = 0
  _i_mousePrevButtons = 0
  _i_cursorHidden = false
  _I_SetWindowTitle(_i_titleBase + " | FPS: 0")
  _I_SetCursorVisible(false)
  if _i_fullscreen then
    sw = GetSystemMetrics(_I_SM_CXSCREEN)
    sh = GetSystemMetrics(_I_SM_CYSCREEN)
    print "I_InitGraphics: fullscreen mode enabled (" + sw + "x" + sh + ")"
  else
    print "I_InitGraphics: windowed mode enabled"
  end if
  if _i_screenshotEnabled then
    print "I_InitGraphics: auto screenshots every 1s -> " + _i_screenshotDir
  else
    print "I_InitGraphics: auto screenshots disabled (enable with -shots)"
  end if

  _i_inited = true
end function

/*
* Function: I_ShutdownGraphics
* Purpose: Implements the I_ShutdownGraphics routine for the platform layer.
*/
function I_ShutdownGraphics()
  global _i_inited
  global _i_hwnd
  global _i_hdc
  global _i_ownsWindow

  _I_SetCursorVisible(true)

  if not(_i_hwnd is void) then
    if not(_i_hdc is void) then
      ReleaseDC(_i_hwnd, _i_hdc)
      _i_hdc = void
    end if
    if _i_ownsWindow then
      DestroyWindow(_i_hwnd)
    end if
    _i_hwnd = void
    _i_ownsWindow = false
  end if

  _i_inited = false
end function

/*
* Function: I_SetPalette
* Purpose: Reads or updates state used by the platform layer.
*/
function I_SetPalette(palette)
  if typeof(_i_paletteRgb) != "bytes" then return end if
  if typeof(palette) != "bytes" then return end if
  if len(palette) < 768 then return end if

  gamma = usegamma
  if typeof(gamma) != "int" then gamma = 0 end if
  if gamma < 0 then gamma = 0 end if
  if gamma >= len(gammatable) then gamma = len(gammatable) - 1 end if

  gtab = 0
  hasGamma = false
  if gamma >= 0 and gamma < len(gammatable) then
    gtab = gammatable[gamma]
    if typeof(gtab) == "array" and len(gtab) >= 256 then
      hasGamma = true
    end if
  end if

  for i = 0 to 767
    v = palette[i]
    if hasGamma then v = gtab[v] end if
    _i_paletteRgb[i] = v
  end for

  _I_UpdateBitmapColorTable()
end function

/*
* Function: I_UpdateNoBlit
* Purpose: Advances per-tick logic for the platform layer.
*/
function I_UpdateNoBlit()
  _I_PumpMessages()
end function

/*
* Function: I_SetLoadingStatus
* Purpose: Loads and prepares data required by the platform layer.
*/
function I_SetLoadingStatus(text)
  global _i_loadingStatusText
  global _i_loadingAnimPhase
  if not _i_inited then return end if

  if typeof(text) != "string" then text = "" end if
  _i_loadingStatusText = text
  if len(text) == 0 then
    _i_loadingAnimPhase = 0
    _I_SetWindowTitle(_i_titleBase + " | FPS: " + _i_fpsValue)
  else
    _I_SetWindowTitle(_i_titleBase + " | " + text)
  end if
  _I_PumpMessages()
end function

/*
* Function: I_LoadingPulse
* Purpose: Pumps window/audio updates and draws an animated loading marker while heavy loading code runs.
*/
function I_LoadingPulse()
  if not _i_inited then return end if
  _I_PumpMessages()
  _I_DrawLoadingIndicator()
  if typeof(I_FinishUpdate) == "function" then I_FinishUpdate() end if
  if typeof(I_UpdateSound) == "function" then I_UpdateSound() end if
  if typeof(I_SubmitSound) == "function" then I_SubmitSound() end if
end function

/*
* Function: I_PollInput
* Purpose: Implements the I_PollInput routine for the platform layer.
*/
function I_PollInput()
  _I_PumpMessages()
  _I_PollKeyboard()
  _I_PollMouse()
end function

/*
* Function: I_FinishUpdate
* Purpose: Advances per-tick logic for the platform layer.
*/
function I_FinishUpdate()
  if not _i_inited then return end if

  _I_PumpMessages()

  if _i_hwnd is void then
    if not _I_CreateWindow() then return end if
  end if

  src = screens[0]
  if typeof(src) != "bytes" then return end if

  _I_MaybeAutoScreenshot()
  _I_UpdateWindowTitle()

  hdc = _i_hdc
  if hdc is void then
    hdc = GetDC(_i_hwnd)
    global _i_hdc
    _i_hdc = hdc
    if hdc is void then return end if
    SetStretchBltMode(hdc, _I_COLORONCOLOR)
  end if

  destW = SCREENWIDTH
  destH = SCREENHEIGHT
  if GetClientRect(_i_hwnd, _i_rect) then
    cw = _I_ReadS32(_i_rect, 8) - _I_ReadS32(_i_rect, 0)
    ch = _I_ReadS32(_i_rect, 12) - _I_ReadS32(_i_rect, 4)
    if cw > 0 then destW = cw end if
    if ch > 0 then destH = ch end if
  end if

  StretchDIBits(
  hdc,
  0, 0, destW, destH,
  0, 0, SCREENWIDTH, SCREENHEIGHT,
  src,
  _i_bmi,
  _I_DIB_RGB_COLORS,
  _I_SRCCOPY
)
end function

/*
* Function: I_ReadScreen
* Purpose: Implements the I_ReadScreen routine for the platform layer.
*/
function I_ReadScreen(scr)
  if typeof(scr) != "bytes" then return end if
  src = screens[0]
  for i = 0 to(SCREENWIDTH * SCREENHEIGHT) - 1
    scr[i] = src[i]
  end for
end function

/*
* Function: createnullcursor
* Purpose: Creates and initializes runtime objects for the engine module behavior.
*/
function createnullcursor()

end function

/*
* Function: grabsharedmemory
* Purpose: Implements the grabsharedmemory routine for the engine module behavior.
*/
function grabsharedmemory(size)
  size = size
  return void
end function

/*
* Function: InitExpand
* Purpose: Initializes state and dependencies for the engine module behavior.
*/
function InitExpand()
end function

/*
* Function: InitExpand2
* Purpose: Initializes state and dependencies for the engine module behavior.
*/
function InitExpand2()
end function

/*
* Function: Expand4
* Purpose: Implements the Expand4 routine for the engine module behavior.
*/
function Expand4(src, dst, count)
  if typeof(src) != "bytes" or typeof(dst) != "bytes" then return end if
  i = 0
  while i < count and i < len(src) and i < len(dst)
    dst[i] = src[i]
    i = i + 1
  end while
end function

/*
* Function: UploadNewPalette
* Purpose: Loads and prepares data required by the engine module behavior.
*/
function UploadNewPalette(pal)
  I_SetPalette(pal)
end function

/*
* Function: xlatekey
* Purpose: Implements the xlatekey routine for the engine module behavior.
*/
function xlatekey(vk)
  _I_InitKeyMap()
  if typeof(vk) != "int" then return 0 end if

  i = 0
  while i < len(_i_keyVk)
    if _i_keyVk[i] == vk then
      return _i_keyDoom[i]
    end if
    i = i + 1
  end while

  if vk >= 0x30 and vk <= 0x39 then return vk end if
  if vk >= 0x41 and vk <= 0x5A then return vk + 32 end if
  return 0
end function

/*
* Function: I_GetEvent
* Purpose: Reads or updates state used by the platform layer.
*/
function I_GetEvent()
  _I_PumpMessages()
  _I_PollKeyboard()
  _I_PollMouse()
end function

/*
* Function: I_StartFrame
* Purpose: Starts runtime behavior in the platform layer.
*/
function I_StartFrame()
  _I_PumpMessages()
end function

/*
* Function: I_StartTic
* Purpose: Starts runtime behavior in the platform layer.
*/
function I_StartTic()
  I_GetEvent()
end function



