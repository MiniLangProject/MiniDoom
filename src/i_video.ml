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

//! Owns the Win32 game window, keyboard/mouse polling, indexed-frame presentation, HD overlays, wipes, and
//! screenshots.

import doomtype
import doomstat
import i_system
import v_video
import m_argv
import d_main
import doomdef
import r_upscaled
import r_hires
import i_gl

import std.time
import std.fs as fs
import std.math
#if TARGET_OS == "linux"
import platform_linux
#endif

/// Defines i bi rgb for the i video subsystem.
/// @internal
const _I_BI_RGB = 0
/// Defines the Doom palette selection for i dib rgb colors.
/// @internal
const _I_DIB_RGB_COLORS = 0
/// Defines i srccopy for the i video subsystem.
/// @internal
const _I_SRCCOPY = 0x00CC0020
/// Defines the Doom palette selection for i coloroncolor.
/// @internal
const _I_COLORONCOLOR = 3
/// Defines i vk lbutton for the i video subsystem.
/// @internal
const _I_VK_LBUTTON = 0x01
/// Defines i vk rbutton for the i video subsystem.
/// @internal
const _I_VK_RBUTTON = 0x02
/// Defines i vk mbutton for the i video subsystem.
/// @internal
const _I_VK_MBUTTON = 0x04
/// Defines i pm remove for the i video subsystem.
/// @internal
const _I_PM_REMOVE = 1
/// Defines i wm quit for the i video subsystem.
/// @internal
const _I_WM_QUIT = 0x0012
/// Defines i wm close for the i video subsystem.
/// @internal
const _I_WM_CLOSE = 0x0010
/// Defines i wm destroy for the i video subsystem.
/// @internal
const _I_WM_DESTROY = 0x0002
/// Defines i wm ncdestroy for the i video subsystem.
/// @internal
const _I_WM_NCDESTROY = 0x0082
/// Defines i wm paint for the i video subsystem.
/// @internal
const _I_WM_PAINT = 0x000F
/// Defines i wm erasebkgnd for the i video subsystem.
/// @internal
const _I_WM_ERASEBKGND = 0x0014
/// Defines i wm keydown for the i video subsystem.
/// @internal
const _I_WM_KEYDOWN = 0x0100
/// Defines i wm keyup for the i video subsystem.
/// @internal
const _I_WM_KEYUP = 0x0101
/// Defines i wm syskeydown for the i video subsystem.
/// @internal
const _I_WM_SYSKEYDOWN = 0x0104
/// Defines i wm syskeyup for the i video subsystem.
/// @internal
const _I_WM_SYSKEYUP = 0x0105
/// Defines i ws overlappedwindow for the i video subsystem.
/// @internal
const _I_WS_OVERLAPPEDWINDOW = 0x00CF0000
/// Defines i ws popup for the i video subsystem.
/// @internal
const _I_WS_POPUP = -2147483648
/// Defines i ws visible for the i video subsystem.
/// @internal
const _I_WS_VISIBLE = 0x10000000
/// Defines i ss ownerdraw for the i video subsystem.
/// @internal
const _I_SS_OWNERDRAW = 0x0000000D
/// Defines i sw show for the i video subsystem.
/// @internal
const _I_SW_SHOW = 5
/// Defines the maximum i sw maximize accepted by the i video subsystem.
/// @internal
const _I_SW_MAXIMIZE = 3
/// Defines i window scale for the i video subsystem.
/// @internal
const _I_WINDOW_SCALE = 2
/// Defines i bmp header size for the i video subsystem.
/// @internal
const _I_BMP_HEADER_SIZE = 54
/// Defines i screenshot interval ms for the i video subsystem.
/// @internal
const _I_SCREENSHOT_INTERVAL_MS = 1000
/// Defines i sm cxscreen for the i video subsystem.
/// @internal
const _I_SM_CXSCREEN = 0
/// Defines i sm cyscreen for the i video subsystem.
/// @internal
const _I_SM_CYSCREEN = 1
/// Defines i swp framechanged for the i video subsystem.
/// @internal
const _I_SWP_FRAMECHANGED = 0x0020
/// Defines i swp showwindow for the i video subsystem.
/// @internal
const _I_SWP_SHOWWINDOW = 0x0040
/// Defines i gwl style for the i video subsystem.
/// @internal
const _I_GWL_STYLE = -16

#if TARGET_OS == "windows"
/// Creates the native game window with the requested client style, placement, and dimensions.
/// @param exStyle `u32` value supplied as ex style to `CreateWindowExW`.
/// @param className `wstr` value supplied as class name to `CreateWindowExW`.
/// @param windowName `wstr` value supplied as window name to `CreateWindowExW`.
/// @param style `u32` value supplied as style to `CreateWindowExW`.
/// @param x Horizontal map- or screen-space coordinate.
/// @param y Vertical map- or screen-space coordinate.
/// @param width Width of the target in pixels or map units.
/// @param height Height of the target in pixels or map units.
/// @param parent `ptr` value supplied as parent to `CreateWindowExW`.
/// @param menu `ptr` value supplied as menu to `CreateWindowExW`.
/// @param instance `ptr` value supplied as instance to `CreateWindowExW`.
/// @param param `ptr` value supplied as param to `CreateWindowExW`.
/// @returns The resulting native game window with the requested client style, placement, and dimensions.
extern function CreateWindowExW(exStyle as u32, className as wstr, windowName as wstr, style as u32, x as int, y as int, width as int, height as int, parent as ptr, menu as ptr, instance as ptr, param as ptr) from "user32.dll" symbol "CreateWindowExW" returns ptr

/// Expands a desired client rectangle to include the selected non-client window borders.
/// @param rect `bytes` value supplied as rect to `AdjustWindowRect`.
/// @param style `u32` value supplied as style to `AdjustWindowRect`.
/// @param hasMenu Whether has menu holds.
/// @returns Result returned by the native `AdjustWindowRect` binding as `bool`.

extern function AdjustWindowRect(rect as bytes, style as u32, hasMenu as bool) from "user32.dll" symbol "AdjustWindowRect" returns bool

/// Applies the requested visibility state to the native game window.
/// @param hwnd `ptr` value supplied as hwnd to `ShowWindow`.
/// @param cmdShow `int` value supplied as cmd show to `ShowWindow`.
/// @returns Result returned by the native `ShowWindow` binding as `bool`.

extern function ShowWindow(hwnd as ptr, cmdShow as int) from "user32.dll" symbol "ShowWindow" returns bool

/// Forces pending client-area painting for a shown native window.
/// @param hwnd `ptr` value supplied as hwnd to `UpdateWindow`.
/// @returns Result returned by the native `UpdateWindow` binding as `bool`.

extern function UpdateWindow(hwnd as ptr) from "user32.dll" symbol "UpdateWindow" returns bool

/// Clears pending client repaint requests after title updates on the built-in STATIC window class.
/// @param hwnd `ptr` value supplied as hwnd to `ValidateRect`.
/// @param rect `ptr` value supplied as rect to `ValidateRect`.
/// @returns Result returned by the native `ValidateRect` binding as `bool`.
extern function ValidateRect(hwnd as ptr, rect as ptr) from "user32.dll" symbol "ValidateRect" returns bool

/// Destroys a game window owned by this video backend.
/// @param hwnd `ptr` value supplied as hwnd to `DestroyWindow`.
/// @returns Result returned by the native `DestroyWindow` binding as `bool`.

extern function DestroyWindow(hwnd as ptr) from "user32.dll" symbol "DestroyWindow" returns bool

/// Acquires the client device context used for software StretchDIBits presentation.
/// @param hwnd `ptr` value supplied as hwnd to `GetDC`.
/// @returns Result returned by the native `GetDC` binding as `ptr`.

extern function GetDC(hwnd as ptr) from "user32.dll" symbol "GetDC" returns ptr

/// Releases a client device context previously acquired for software presentation.
/// @param hwnd `ptr` value supplied as hwnd to `ReleaseDC`.
/// @param hdc `ptr` value supplied as hdc to `ReleaseDC`.
/// @returns Result returned by the native `ReleaseDC` binding as `int`.

extern function ReleaseDC(hwnd as ptr, hdc as ptr) from "user32.dll" symbol "ReleaseDC" returns int

/// Reads the current drawable client dimensions for OpenGL resize or GDI scaling.
/// @param hwnd `ptr` value supplied as hwnd to `GetClientRect`.
/// @param rect `bytes` value supplied as rect to `GetClientRect`.
/// @returns The requested the current drawable client dimensions for OpenGL resize or GDI scaling.

extern function GetClientRect(hwnd as ptr, rect as bytes) from "user32.dll" symbol "GetClientRect" returns bool

/// Retrieves and optionally removes queued Win32 messages without blocking the game loop.
/// @param msg `bytes` value supplied as msg to `PeekMessageW`.
/// @param hwnd `ptr` value supplied as hwnd to `PeekMessageW`.
/// @param minMsg `u32` value supplied as min msg to `PeekMessageW`.
/// @param maxMsg `u32` value supplied as max msg to `PeekMessageW`.
/// @param removeMsg `u32` value supplied as remove msg to `PeekMessageW`.
/// @returns Result returned by the native `PeekMessageW` binding as `bool`.

extern function PeekMessageW(msg as bytes, hwnd as ptr, minMsg as u32, maxMsg as u32, removeMsg as u32) from "user32.dll" symbol "PeekMessageW" returns bool

/// Generates character messages from a retrieved keyboard message before dispatch.
/// @param msg `bytes` value supplied as msg to `TranslateMessage`.
/// @returns Result returned by the native `TranslateMessage` binding as `bool`.

extern function TranslateMessage(msg as bytes) from "user32.dll" symbol "TranslateMessage" returns bool

/// Dispatches a retrieved Win32 message to the target window procedure.
/// @param msg `bytes` value supplied as msg to `DispatchMessageW`.
/// @returns Result returned by the native `DispatchMessageW` binding as `ptr`.

extern function DispatchMessageW(msg as bytes) from "user32.dll" symbol "DispatchMessageW" returns ptr

/// Polls a virtual key's current high-bit down state for edge-based Doom input events.
/// @param vkey Native virtual-key code to translate.
/// @returns Result returned by the native `GetAsyncKeyState` binding as `int`.

extern function GetAsyncKeyState(vkey as int) from "user32.dll" symbol "GetAsyncKeyState" returns int

/// Updates the game window caption with loading or FPS status.
/// @param hwnd `ptr` value supplied as hwnd to `SetWindowTextW`.
/// @param text Text to process.
/// @returns Result returned by the native `SetWindowTextW` binding as `bool`.

extern function SetWindowTextW(hwnd as ptr, text as wstr) from "user32.dll" symbol "SetWindowTextW" returns bool

/// Reads screen-space cursor coordinates used to derive relative mouse movement.
/// @param point `bytes` value supplied as point to `GetCursorPos`.
/// @returns The requested screen-space cursor coordinates used to derive relative mouse movement.

extern function GetCursorPos(point as bytes) from "user32.dll" symbol "GetCursorPos" returns bool

/// Identifies the foreground window so input is released when the game loses focus.
/// @returns Result returned by the native `GetForegroundWindow` binding as `ptr`.

extern function GetForegroundWindow() from "user32.dll" symbol "GetForegroundWindow" returns ptr

/// Shows or hides the system cursor.
/// @param show `bool` value supplied as show to `ShowCursor`.
/// @returns Result returned by the native `ShowCursor` binding as `int`.
extern function ShowCursor(show as bool) from "user32.dll" symbol "ShowCursor" returns int

/// Reads desktop dimensions used to size the borderless fullscreen window.
/// @param index Zero-based element or table index.
/// @returns The requested desktop dimensions used to size the borderless fullscreen window.

extern function GetSystemMetrics(index as int) from "user32.dll" symbol "GetSystemMetrics" returns int

/// Repositions or resizes the game window while changing fullscreen/windowed presentation.
/// @param hwnd `ptr` value supplied as hwnd to `SetWindowPos`.
/// @param insertAfter `ptr` value supplied as insert after to `SetWindowPos`.
/// @param x Horizontal map- or screen-space coordinate.
/// @param y Vertical map- or screen-space coordinate.
/// @param width Width of the target in pixels or map units.
/// @param height Height of the target in pixels or map units.
/// @param flags Bit flags that control the operation.
/// @returns Result returned by the native `SetWindowPos` binding as `bool`.

extern function SetWindowPos(hwnd as ptr, insertAfter as ptr, x as int, y as int, width as int, height as int, flags as u32) from "user32.dll" symbol "SetWindowPos" returns bool

/// Reads native window style data needed when updating presentation mode.
/// @param hwnd `ptr` value supplied as hwnd to `GetWindowLongPtrW`.
/// @param index Zero-based element or table index.
/// @returns The requested native window style data needed when updating presentation mode.

extern function GetWindowLongPtrW(hwnd as ptr, index as int) from "user32.dll" symbol "GetWindowLongPtrW" returns ptr

/// Replaces native window style data when updating presentation mode.
/// @param hwnd `ptr` value supplied as hwnd to `SetWindowLongPtrW`.
/// @param index Zero-based element or table index.
/// @param newLong `ptr` value supplied as new long to `SetWindowLongPtrW`.
/// @returns Result returned by the native `SetWindowLongPtrW` binding as `ptr`.

extern function SetWindowLongPtrW(hwnd as ptr, index as int, newLong as ptr) from "user32.dll" symbol "SetWindowLongPtrW" returns ptr

/// Requests foreground keyboard focus for the newly created game window.
/// @param hwnd `ptr` value supplied as hwnd to `SetForegroundWindow`.
/// @returns Result returned by the native `SetForegroundWindow` binding as `bool`.

extern function SetForegroundWindow(hwnd as ptr) from "user32.dll" symbol "SetForegroundWindow" returns bool

/// Raises the game window above other top-level windows during activation.
/// @param hwnd `ptr` value supplied as hwnd to `BringWindowToTop`.
/// @returns Result returned by the native `BringWindowToTop` binding as `bool`.

extern function BringWindowToTop(hwnd as ptr) from "user32.dll" symbol "BringWindowToTop" returns bool

/// Activates the game window within the current input thread.
/// @param hwnd `ptr` value supplied as hwnd to `SetActiveWindow`.
/// @returns Result returned by the native `SetActiveWindow` binding as `ptr`.

extern function SetActiveWindow(hwnd as ptr) from "user32.dll" symbol "SetActiveWindow" returns ptr

/// Validates that the stored native handle still names a live window.
/// @param hwnd `ptr` value supplied as hwnd to `IsWindow`.
/// @returns Result returned by the native `IsWindow` binding as `bool`.

extern function IsWindow(hwnd as ptr) from "user32.dll" symbol "IsWindow" returns bool

/// Scales and copies the indexed DIB presentation buffer into the window client area.
/// @param hdc `ptr` value supplied as hdc to `StretchDIBits`.
/// @param xDest `int` value supplied as x dest to `StretchDIBits`.
/// @param yDest `int` value supplied as y dest to `StretchDIBits`.
/// @param destWidth Width of dest width in pixels or map units.
/// @param destHeight Height of dest height in pixels or map units.
/// @param xSrc `int` value supplied as x src to `StretchDIBits`.
/// @param ySrc `int` value supplied as y src to `StretchDIBits`.
/// @param srcWidth Width of src width in pixels or map units.
/// @param srcHeight Height of src height in pixels or map units.
/// @param bits `bytes` value supplied as bits to `StretchDIBits`.
/// @param bmi `bytes` value supplied as bmi to `StretchDIBits`.
/// @param usage `u32` value supplied as usage to `StretchDIBits`.
/// @param rop `u32` value supplied as rop to `StretchDIBits`.
/// @returns Result returned by the native `StretchDIBits` binding as `int`.

extern function StretchDIBits(hdc as ptr, xDest as int, yDest as int, destWidth as int, destHeight as int, xSrc as int, ySrc as int, srcWidth as int, srcHeight as int, bits as bytes, bmi as bytes, usage as u32, rop as u32) from "gdi32.dll" symbol "StretchDIBits" returns int

/// Selects COLORONCOLOR scaling for crisp software framebuffer presentation.
/// @param hdc `ptr` value supplied as hdc to `SetStretchBltMode`.
/// @param mode `int` value supplied as mode to `SetStretchBltMode`.
/// @returns Result returned by the native `SetStretchBltMode` binding as `int`.

extern function SetStretchBltMode(hdc as ptr, mode as int) from "gdi32.dll" symbol "SetStretchBltMode" returns int

/// Creates the auto-screenshot output directory when it does not yet exist.
/// @param path Filesystem path to process.
/// @param security Optional native security-attributes pointer.
/// @returns The resulting auto-screenshot output directory when it does not yet exist.
extern function CreateDirectoryW(path as wstr, security as ptr) from "kernel32.dll" symbol "CreateDirectoryW" returns bool

/// Retrieves the process console window so startup can reuse or coordinate native window state.
/// @returns Result returned by the native `GetConsoleWindow` binding as `ptr`.

extern function GetConsoleWindow() from "kernel32.dll" symbol "GetConsoleWindow" returns ptr
#endif

/// Tracks whether i inited is active in the i video subsystem.
/// @internal
_i_inited = false
/// Holds the optional i hwnd resource used by the i video subsystem.
/// @internal
_i_hwnd = void
/// Holds the optional i hdc resource used by the i video subsystem.
/// @internal
_i_hdc = void
/// Tracks whether i owns window is active in the i video subsystem.
/// @internal
_i_ownsWindow = false
/// Tracks the mutable i palette rgb value used by the i video subsystem.
/// @internal
_i_paletteRgb = 0
/// Tracks the mutable i bmi value used by the i video subsystem.
/// @internal
_i_bmi = 0
/// Tracks the mutable i msg value used by the i video subsystem.
/// @internal
_i_msg = 0
/// Tracks the mutable i rect value used by the i video subsystem.
/// @internal
_i_rect = 0
/// Tracks whether i window failed is active in the i video subsystem.
/// @internal
_i_windowFailed = false
/// Stores the i key vk collection used by the i video subsystem.
/// @internal
_i_keyVk =[]
/// Stores the i key doom collection used by the i video subsystem.
/// @internal
_i_keyDoom =[]
/// Stores the i key prev collection used by the i video subsystem.
/// @internal
_i_keyPrev =[]
/// Tracks whether i alt gprev is active in the i video subsystem.
/// @internal
_i_altGPrev = false
/// Tracks whether i console tilde prev is active in the i video subsystem.
/// @internal
_i_consoleTildePrev = false
/// Tracks whether i screenshot enabled is active in the i video subsystem.
/// @internal
_i_screenshotEnabled = false
/// Stores the mutable i screenshot dir text used by the i video subsystem.
/// @internal
_i_screenshotDir = "render_output"
/// Tracks whether i screenshot dir ready is active in the i video subsystem.
/// @internal
_i_screenshotDirReady = false
/// Tracks the mutable i screenshot next tick value used by the i video subsystem.
/// @internal
_i_screenshotNextTick = 0
/// Tracks the mutable i screenshot index value used by the i video subsystem.
/// @internal
_i_screenshotIndex = 0
/// Tracks whether i screenshot write error is active in the i video subsystem.
/// @internal
_i_screenshotWriteError = false
/// Stores the mutable i title base text used by the i video subsystem.
/// @internal
_i_titleBase = "Doom Minilang Port"
/// Stores the mutable i title last text used by the i video subsystem.
/// @internal
_i_titleLast = ""
/// Tracks the mutable i fps window start value used by the i video subsystem.
/// @internal
_i_fpsWindowStart = 0
/// Tracks the mutable i fps frame count value used by the i video subsystem.
/// @internal
_i_fpsFrameCount = 0
/// Tracks the mutable i fps value value used by the i video subsystem.
/// @internal
_i_fpsValue = 0
/// Tracks the mutable i mouse point value used by the i video subsystem.
/// @internal
_i_mousePoint = 0
/// Tracks whether i mouse inited is active in the i video subsystem.
/// @internal
_i_mouseInited = false
/// Tracks the mutable i mouse prev x value used by the i video subsystem.
/// @internal
_i_mousePrevX = 0
/// Tracks the mutable i mouse prev y value used by the i video subsystem.
/// @internal
_i_mousePrevY = 0
/// Tracks the mutable i mouse prev buttons value used by the i video subsystem.
/// @internal
_i_mousePrevButtons = 0
/// Tracks whether i fullscreen is active in the i video subsystem.
/// @internal
_i_fullscreen = false
/// Tracks whether i cursor hidden is active in the i video subsystem.
/// @internal
_i_cursorHidden = false
/// Stores the mutable i loading status text text used by the i video subsystem.
/// @internal
_i_loadingStatusText = ""
/// Tracks the mutable i loading anim phase value used by the i video subsystem.
/// @internal
_i_loadingAnimPhase = 0
/// Tracks the mutable i present scale value used by the i video subsystem.
/// @internal
_i_presentScale = 1
/// Tracks the mutable i present width value used by the i video subsystem.
/// @internal
_i_presentWidth = SCREENWIDTH
/// Tracks the mutable i present height value used by the i video subsystem.
/// @internal
_i_presentHeight = SCREENHEIGHT
/// Holds the optional i present buffer resource used by the i video subsystem.
/// @internal
_i_presentBuffer = void
/// Holds the optional i overlay base resource used by the i video subsystem.
/// @internal
_i_overlayBase = void
/// Holds the optional i overlay row buffer resource used by the i video subsystem.
/// @internal
_i_overlayRowBuffer = void
/// Holds the optional i gl overlay buffer resource used by the i video subsystem.
/// @internal
_i_glOverlayBuffer = void
/// Holds the optional i gl overlay mask resource used by the i video subsystem.
/// @internal
_i_glOverlayMask = void
/// Holds the optional i last present frame resource used by the i video subsystem.
/// @internal
_i_lastPresentFrame = void
/// Holds the optional i last present rgba resource used by the i video subsystem.
/// @internal
_i_lastPresentRGBA = void
/// Holds the optional i hd wipe start resource used by the i video subsystem.
/// @internal
_i_hdWipeStart = void
/// Holds the optional i hd wipe end resource used by the i video subsystem.
/// @internal
_i_hdWipeEnd = void
/// Holds the optional i hd wipe frame resource used by the i video subsystem.
/// @internal
_i_hdWipeFrame = void
/// Stores the i hd wipe y collection used by the i video subsystem.
/// @internal
_i_hdWipeY =[]
/// Tracks whether i hd wipe active is active in the i video subsystem.
/// @internal
_i_hdWipeActive = false
/// Tracks the mutable i hd wipe seed value used by the i video subsystem.
/// @internal
_i_hdWipeSeed = 1234567
/// Tracks whether i force software present is active in the i video subsystem.
/// @internal
_i_forceSoftwarePresent = false
/// Defines i statusbar height for the i video subsystem.
/// @internal
const _I_STATUSBAR_HEIGHT = 32

/// Coerces numeric values to truncation-toward-zero integers and returns fallback on failure in `_I_ToIntOr`
/// @param v Value consumed by the operation.
/// @param fallback Value returned when the requested conversion or lookup is unavailable.
/// @internal
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

/// Coerces numeric operands and returns their signed quotient truncated toward zero, using zero for a zero
/// divisor.
/// @param a First input operand.
/// @param b Second input operand.
/// @internal
function inline _I_IDiv(a, b)
  a = _I_ToIntOr(a, 0)
  b = _I_ToIntOr(b, 0)
  if b == 0 then return 0 end if
  q = a / b
  if q >= 0 then return std.math.floor(q) end if
  return std.math.ceil(q)
end function

/// Applies a changed caption once and clears STATIC-class repaint requests caused by title updates.
/// @param title Title value supplied to `_I_SetWindowTitle`.
/// @internal
function inline _I_SetWindowTitle(title)
  global _i_titleLast

  if _i_hwnd is void then return end if
  if typeof(title) != "string" then return end if
  if title == _i_titleLast then return end if
  SetWindowTextW(_i_hwnd, title)
  ValidateRect(_i_hwnd, void)
  _i_titleLast = title
end function

/// Forces the next presentation path to use a nearest-scaled logical framebuffer instead of native OpenGL world
/// output.
/// @param v Value consumed by the operation.
function I_SetForceSoftwarePresent(v)
  global _i_forceSoftwarePresent

  _i_forceSoftwarePresent = false
  if typeof(v) == "bool" and v then _i_forceSoftwarePresent = true end if
end function

/// Switches renderer state and invalidates cached high-resolution overlays.
/// @internal
function _I_ToggleRendererHotkey()
  if typeof(IGL_ToggleRenderer) == "function" then
    IGL_ToggleRenderer()
  end if
  if typeof(V_ClearHighresOverlay) == "function" then
    V_ClearHighresOverlay()
  end if
  if typeof(ST_ForceRefresh) == "function" then
    ST_ForceRefresh()
  end if
end function

/// Handles Alt+G from the Win32 message stream, independent of foreground polling.
/// @param msg Msg value supplied to `_I_HandleRendererHotkeyMessage`.
/// @param wparam Wparam value supplied to `_I_HandleRendererHotkeyMessage`.
/// @param lparam Lparam value supplied to `_I_HandleRendererHotkeyMessage`.
/// @internal
function _I_HandleRendererHotkeyMessage(msg, wparam, lparam)
  global _i_altGPrev

  if msg == _I_WM_KEYUP or msg == _I_WM_SYSKEYUP then
    if wparam == 0x47 then _i_altGPrev = false end if
    return false
  end if

  if msg != _I_WM_KEYDOWN and msg != _I_WM_SYSKEYDOWN then return false end if
  if wparam != 0x47 then return false end if

  altContext = msg == _I_WM_SYSKEYDOWN
  if typeof(lparam) == "int" and((lparam & 0x20000000) != 0) then altContext = true end if
  if not altContext then return false end if

  if not _i_altGPrev then
    _I_ToggleRendererHotkey()
    _i_altGPrev = true
  end if
  return true
end function

/// Caches the latest full-size indexed frame and its palette-expanded RGBA copy for capture and wipe fallback.
/// @param src Src value supplied to `_I_SaveLastPresentFrame`.
/// @internal
function _I_SaveLastPresentFrame(src)
  global _i_lastPresentFrame
  global _i_lastPresentRGBA

  expected = _i_presentWidth * _i_presentHeight
  if typeof(src) != "bytes" or expected <= 0 or len(src) < expected then return end if
  if typeof(_i_lastPresentFrame) != "bytes" or len(_i_lastPresentFrame) < expected then
    _i_lastPresentFrame = bytes(expected, 0)
  end if
  copyBytes(_i_lastPresentFrame, 0, src, 0, expected)
  if typeof(_i_lastPresentRGBA) != "bytes" or len(_i_lastPresentRGBA) < expected * 4 then
    _i_lastPresentRGBA = bytes(expected * 4, 0)
  end if
  _I_IndexedToRGBA(src, _i_lastPresentRGBA, _i_presentWidth, _i_presentHeight)
end function

/// Converts an indexed frame of arbitrary dimensions for OpenGL presentation.
/// @param src Src value supplied to `_I_SaveLastRGBAFrameSized`.
/// @param width Width of the target in pixels or map units.
/// @param height Height of the target in pixels or map units.
/// @internal
function _I_SaveLastRGBAFrameSized(src, width, height)
  global _i_lastPresentRGBA

  if typeof(src) != "bytes" then return false end if
  if typeof(width) != "int" or typeof(height) != "int" then return false end if
  expected = width * height
  if expected <= 0 or len(src) < expected then return false end if
  if typeof(_i_lastPresentRGBA) != "bytes" or len(_i_lastPresentRGBA) < expected * 4 then
    _i_lastPresentRGBA = bytes(expected * 4, 0)
  end if
  return _I_IndexedToRGBA(src, _i_lastPresentRGBA, width, height)
end function

/// Expands validated indexed pixels through the active RGB palette into opaque RGBA output.
/// @param src Src value supplied to `_I_IndexedToRGBA`.
/// @param dst Dst value supplied to `_I_IndexedToRGBA`.
/// @param width Width of the target in pixels or map units.
/// @param height Height of the target in pixels or map units.
/// @internal
function _I_IndexedToRGBA(src, dst, width, height)
  if typeof(src) != "bytes" or typeof(dst) != "bytes" then return false end if
  if typeof(width) != "int" or typeof(height) != "int" then return false end if
  pixels = width * height
  if pixels <= 0 or len(src) < pixels or len(dst) < pixels * 4 then return false end if
  pal = _i_paletteRgb
  if typeof(pal) != "bytes" or len(pal) < 768 then return false end if
  if typeof(IGL_IsAvailable) == "function" and IGL_IsAvailable() then
    if MGL_ExpandIndexed8(src, len(src), dst, len(dst), pal, len(pal), pixels) then return true end if
  end if
  i = 0
  while i < pixels
    c = src[i]
    po = c * 3
    ro = i * 4
    dst[ro] = pal[po]
    dst[ro + 1] = pal[po + 1]
    dst[ro + 2] = pal[po + 2]
    dst[ro + 3] = 255
    i = i + 1
  end while
  return true
end function

/// Produces deterministic 15-bit randomness for high-resolution melt-column delays.
/// @internal
function inline _I_HDWIPE_Rand()
  global _i_hdWipeSeed

  _i_hdWipeSeed =(_i_hdWipeSeed * 1103515245 + 12345) & 0x7fffffff
  return (_i_hdWipeSeed >> 16) & 32767
end function

/// Captures the current high-resolution start frame from OpenGL, the last RGBA frame, or a nearest logical
/// fallback.
function I_BeginHDWipe()
  global _i_hdWipeStart
  global _i_hdWipeActive

  _i_hdWipeActive = false
  if _i_presentScale <= 1 then return false end if
  if typeof(IGL_IsActive) != "function" or not IGL_IsActive() then return false end if

  expected = _i_presentWidth * _i_presentHeight
  if expected <= 0 then return false end if
  if typeof(_i_hdWipeStart) != "bytes" or len(_i_hdWipeStart) < expected * 4 then
    _i_hdWipeStart = bytes(expected * 4, 0)
  end if

  if typeof(IGL_CaptureRGBA) == "function" and IGL_CaptureRGBA(_i_hdWipeStart, _i_presentWidth, _i_presentHeight, true) then
    return true
  end if

  if typeof(_i_lastPresentRGBA) == "bytes" and len(_i_lastPresentRGBA) >= expected * 4 then
    copyBytes(_i_hdWipeStart, 0, _i_lastPresentRGBA, 0, expected * 4)
    return true
  end if

  if typeof(screens) != "array" or len(screens) == 0 or typeof(screens[0]) != "bytes" then return false end if
  src = _I_BuildNearestLogicalFrame(screens[0])
  if typeof(src) != "bytes" or len(src) < expected then return false end if
  return _I_IndexedToRGBA(src, _i_hdWipeStart, _i_presentWidth, _i_presentHeight)
end function

/// Captures the destination frame and initializes correlated delayed melt positions for two-logical-pixel
/// column groups.
function I_PrepareHDWipeEnd()
  global _i_hdWipeEnd
  global _i_hdWipeFrame
  global _i_hdWipeY
  global _i_hdWipeActive

  if _i_presentScale <= 1 then return false end if
  if typeof(IGL_IsActive) != "function" or not IGL_IsActive() then return false end if
  expected = _i_presentWidth * _i_presentHeight
  if expected <= 0 then return false end if
  if typeof(_i_hdWipeStart) != "bytes" or len(_i_hdWipeStart) < expected * 4 then return false end if
  if typeof(_i_hdWipeEnd) != "bytes" or len(_i_hdWipeEnd) < expected * 4 then _i_hdWipeEnd = bytes(expected * 4, 0) end if
  if typeof(_i_hdWipeFrame) != "bytes" or len(_i_hdWipeFrame) < expected * 4 then _i_hdWipeFrame = bytes(expected * 4, 0) end if

  captured = false
  if typeof(IGL_HasFrameReady) == "function" and IGL_HasFrameReady() and typeof(IGL_CaptureRGBA) == "function" then
    destW = _i_presentWidth
    destH = _i_presentHeight
    if _i_hwnd is not void and GetClientRect(_i_hwnd, _i_rect) then
      cw = _I_ReadS32(_i_rect, 8) - _I_ReadS32(_i_rect, 0)
      ch = _I_ReadS32(_i_rect, 12) - _I_ReadS32(_i_rect, 4)
      if cw > 0 then destW = cw end if
      if ch > 0 then destH = ch end if
    end if
    if typeof(IGL_Resize) == "function" then IGL_Resize(destW, destH) end if
    _I_DrawGLOverlayFrame()
    if typeof(IGL_DrawPaletteFlash) == "function" then IGL_DrawPaletteFlash() end if
    captured = IGL_CaptureRGBA(_i_hdWipeEnd, _i_presentWidth, _i_presentHeight, false)
  end if
  if not captured then
    if typeof(screens) != "array" or len(screens) == 0 or typeof(screens[0]) != "bytes" then return false end if
    src = _I_BuildPresentFrame()
    if typeof(src) != "bytes" or len(src) < expected then return false end if
    if not _I_IndexedToRGBA(src, _i_hdWipeEnd, _i_presentWidth, _i_presentHeight) then return false end if
  end if

  colwBase = _i_presentScale * 2
  if colwBase < 2 then colwBase = 2 end if
  groups = _I_IDiv(_i_presentWidth + colwBase - 1, colwBase)
  _i_hdWipeY =[]
  if groups <= 0 then return false end if
  first = -((_I_HDWIPE_Rand() % 16) + 1) * _i_presentScale
  _i_hdWipeY = _i_hdWipeY +[first]
  i = 1
  while i < groups
    r =(_I_HDWIPE_Rand() % 3) - 1
    yy = _i_hdWipeY[i - 1] + r * _i_presentScale
    if yy > 0 then yy = 0 end if
    if yy == -(16 * _i_presentScale) then yy = -(15 * _i_presentScale) end if
    _i_hdWipeY = _i_hdWipeY +[yy]
    i = i + 1
  end while
  _i_hdWipeActive = true
  return true
end function

/// Composes one RGBA melt frame from the start/end captures and each column group's vertical frontier.
/// @internal
function _I_ComposeHDWipeFrame()
  if typeof(_i_hdWipeStart) != "bytes" or typeof(_i_hdWipeEnd) != "bytes" or typeof(_i_hdWipeFrame) != "bytes" then return false end if
  w = _i_presentWidth
  h = _i_presentHeight
  expected = w * h
  if len(_i_hdWipeStart) < expected * 4 or len(_i_hdWipeEnd) < expected * 4 or len(_i_hdWipeFrame) < expected * 4 then return false end if
  colwBase = _i_presentScale * 2
  if colwBase < 2 then colwBase = 2 end if
  groups = _I_IDiv(w + colwBase - 1, colwBase)
  if groups <= 0 then return false end if

  gx = 0
  while gx < groups
    offset = _i_hdWipeY[gx]
    x = gx * colwBase
    colw = colwBase
    if x + colw > w then colw = w - x end if
    y = 0
    while y < h
      di = (y * w + x) * 4
      bytesToCopy = colw * 4
      if offset < 0 then
        si = di
        copyBytes(_i_hdWipeFrame, di, _i_hdWipeStart, si, bytesToCopy)
      else if y < offset or offset >= h then
        si = di
        copyBytes(_i_hdWipeFrame, di, _i_hdWipeEnd, si, bytesToCopy)
      else
        sy = y - offset
        if sy >= 0 and sy < h then
          si = (sy * w + x) * 4
          copyBytes(_i_hdWipeFrame, di, _i_hdWipeStart, si, bytesToCopy)
        else
          si = di
          copyBytes(_i_hdWipeFrame, di, _i_hdWipeEnd, si, bytesToCopy)
        end if
      end if
      y = y + 1
    end while
    gx = gx + 1
  end while
  return true
end function

/// Advances, draws, and swaps the high-resolution melt transition, returning true after every column reaches
/// the bottom.
/// @param tics Duration measured in Doom game tics.
function I_HDScreenWipe(tics)
  if not _i_hdWipeActive then return true end if
  if typeof(IGL_IsActive) != "function" or not IGL_IsActive() then return true end if
  if typeof(IGL_DrawRGBAFrame) != "function" or typeof(IGL_MarkFrameReady) != "function" or typeof(IGL_Swap) != "function" then return true end if
  if typeof(tics) != "int" or tics <= 0 then tics = 1 end if

  s = _i_presentScale
  if s < 1 then s = 1 end if
  h = _i_presentHeight
  colwBase = s * 2
  if colwBase < 2 then colwBase = 2 end if
  groups = _I_IDiv(_i_presentWidth + colwBase - 1, colwBase)
  done = true
  while tics > 0
    tics = tics - 1
    done = true
    gx = 0
    while gx < groups
      yy = _i_hdWipeY[gx]
      if yy < 0 then
        yy = yy + s
        _i_hdWipeY[gx] = yy
        done = false
      else if yy < h then
        dy = 6 * s
        if yy < 16 * s then dy = yy + s end if
        if yy + dy > h then dy = h - yy end if
        yy = yy + dy
        _i_hdWipeY[gx] = yy
        done = false
      end if
      gx = gx + 1
    end while
  end while

  if not _I_ComposeHDWipeFrame() then return true end if
  if not IGL_DrawRGBAFrame(_i_hdWipeFrame, _i_presentWidth, _i_presentHeight) then return true end if
  IGL_MarkFrameReady()
  IGL_Swap()
  if done then
    global _i_hdWipeActive
    _i_hdWipeActive = false
  end if
  return done
end function

/// Formats an integer as decimal text without relying on platform string conversion.
/// @param v Value consumed by the operation.
/// @internal
function _I_IntToString(v)
  n = _I_ToIntOr(v, 0)
  if n == 0 then return "0" end if
  neg = false
  if n < 0 then
    neg = true
    n = -n
  end if
  txt = ""
  while n > 0
    d = n % 10
    ch = "0"
    if d == 1 then ch = "1"
    else if d == 2 then ch = "2"
    else if d == 3 then ch = "3"
    else if d == 4 then ch = "4"
    else if d == 5 then ch = "5"
    else if d == 6 then ch = "6"
    else if d == 7 then ch = "7"
    else if d == 8 then ch = "8"
    else if d == 9 then ch = "9"
    end if
    txt = ch + txt
    n = _I_IDiv(n, 10)
  end while
  if neg then txt = "-" + txt end if
  return txt
end function

/// Formats the base window caption with the most recently measured non-negative FPS value.
/// @internal
function inline _I_FpsTitle()
  v = _I_ToIntOr(_i_fpsValue, 0)
  if v < 0 then v = 0 end if
  return _i_titleBase + " | FPS: " + _I_IntToString(v)
end function

/// Exposes the last completed one-second presentation sample to in-game UI overlays.
function I_GetFPS()
  return _I_ToIntOr(_i_fpsValue, 0)
end function

/// Counts presented frames over one-second windows and updates the caption unless a loading status owns it.
/// @internal
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
    _I_SetWindowTitle(_I_FpsTitle())
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
  _I_SetWindowTitle(_I_FpsTitle())

  _i_fpsWindowStart = now
  _i_fpsFrameCount = 0
end function

/// Renders a small animated loading marker in the lower-right corner of the software framebuffer.
/// @internal
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
    fillBytes(fb, base, size, 0)
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

/// Keeps cursor visibility in sync while game window is active.
/// @param visible Visible value supplied to `_I_SetCursorVisible`.
/// @internal
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

/// Appends a Win32 virtual-key to Doom-key mapping with an initially released edge-tracking cell.
/// @param vk Vk value supplied to `_I_AddKeyMap`.
/// @param doomKey Doom input-key code to process.
/// @internal
function inline _I_AddKeyMap(vk, doomKey)
  global _i_keyVk
  global _i_keyDoom
  global _i_keyPrev

  _i_keyVk = _i_keyVk +[vk]
  _i_keyDoom = _i_keyDoom +[doomKey]
  _i_keyPrev = _i_keyPrev +[0]
end function

/// Lazily builds the complete navigation, function, digit, numpad, punctuation, and lowercase-letter key map.
/// @internal
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
  // VK_OEM_3 carries tilde on US layouts and O-umlaut on the active German layout.
  // VK_OEM_1 is an O-umlaut fallback; VK_OEM_5 is the German caret/dead-key left of 1.
  _I_AddKeyMap(0xC0, KEY_CONSOLE)
  _I_AddKeyMap(0xBA, KEY_CONSOLE)
  _I_AddKeyMap(0xDC, KEY_CONSOLE)
  _I_AddKeyMap(0x21, KEY_PAGEUP)
  _I_AddKeyMap(0x22, KEY_PAGEDOWN)
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

/// Encodes the low 16 bits of a value into a little-endian Win32 structure buffer.
/// @param buf Buf value supplied to `_I_WriteU16`.
/// @param off Zero-based byte or element offset.
/// @param value Value consumed by the operation.
/// @internal
function inline _I_WriteU16(buf, off, value)
  if value < 0 then value = value + 65536 end if
  buf[off] = value & 255
  buf[off + 1] =(value >> 8) & 255
end function

/// Encodes the low 32 bits of a value into a little-endian Win32 structure buffer.
/// @param buf Buf value supplied to `_I_WriteU32`.
/// @param off Zero-based byte or element offset.
/// @param value Value consumed by the operation.
/// @internal
function inline _I_WriteU32(buf, off, value)
  if value < 0 then value = value + 4294967296 end if
  buf[off] = value & 255
  buf[off + 1] =(value >> 8) & 255
  buf[off + 2] =(value >> 16) & 255
  buf[off + 3] =(value >> 24) & 255
end function

/// Decodes an unsigned 32-bit little-endian field from a Win32 structure buffer.
/// @param buf Buf value supplied to `_I_ReadU32`.
/// @param off Zero-based byte or element offset.
/// @internal
function inline _I_ReadU32(buf, off)
  return buf[off] +(buf[off + 1] << 8) +(buf[off + 2] << 16) +(buf[off + 3] << 24)
end function

/// Decodes a signed 32-bit little-endian field from a Win32 structure buffer.
/// @param buf Buf value supplied to `_I_ReadS32`.
/// @param off Zero-based byte or element offset.
/// @internal
function inline _I_ReadS32(buf, off)
  v = _I_ReadU32(buf, off)
  if v >= 2147483648 then v = v - 4294967296 end if
  return v
end function

/// Seeds the 256-entry RGB palette with a grayscale ramp before PLAYPAL is applied.
/// @internal
function _I_InitDefaultPalette()
  if typeof(_i_paletteRgb) != "bytes" then return end if
  for i = 0 to 255
    o = i * 3
    _i_paletteRgb[o] = i
    _i_paletteRgb[o + 1] = i
    _i_paletteRgb[o + 2] = i
  end for
end function

/// Converts the active RGB palette into the BGR0 color table embedded in the 8-bit BITMAPINFO.
/// @internal
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

/// Builds a top-down 8-bit BITMAPINFO for the physical presentation size and forwards its initial palette to
/// OpenGL.
/// @internal
function _I_InitBitmapInfo()
  if typeof(_i_bmi) != "bytes" then return end if

  _I_WriteU32(_i_bmi, 0, 40)
  _I_WriteU32(_i_bmi, 4, _i_presentWidth)
  _I_WriteU32(_i_bmi, 8, - _i_presentHeight)
  _I_WriteU16(_i_bmi, 12, 1)
  _I_WriteU16(_i_bmi, 14, 8)
  _I_WriteU32(_i_bmi, 16, _I_BI_RGB)
  _I_WriteU32(_i_bmi, 20, _i_presentWidth * _i_presentHeight)
  _I_WriteU32(_i_bmi, 24, 0)
  _I_WriteU32(_i_bmi, 28, 0)
  _I_WriteU32(_i_bmi, 32, 256)
  _I_WriteU32(_i_bmi, 36, 0)

  _I_UpdateBitmapColorTable()
  if typeof(IGL_SetPalette) == "function" then IGL_SetPalette(_i_paletteRgb) end if
end function

/// Creates, sizes, activates, and acquires a device context for the fullscreen or windowed native game window.
/// @internal
function _I_CreateWindow()
  global _i_hwnd
  global _i_hdc
  global _i_windowFailed
  global _i_ownsWindow

  if not(_i_hwnd is void) then return true end if
  if _i_windowFailed then return false end if

  windowScale = _I_WINDOW_SCALE
  if _i_presentScale > 1 then windowScale = 1 end if
  clientW = _i_presentWidth * windowScale
  clientH = _i_presentHeight * windowScale
  sw = GetSystemMetrics(_I_SM_CXSCREEN)
  sh = GetSystemMetrics(_I_SM_CYSCREEN)
  if sw <= 0 then sw = clientW end if
  if sh <= 0 then sh = clientH end if

  style = _I_WS_OVERLAPPEDWINDOW | _I_WS_VISIBLE | _I_SS_OWNERDRAW
  winX = 100
  winY = 100
  winW = clientW
  winH = clientH
  if _i_fullscreen then
    style = _I_WS_POPUP | _I_WS_VISIBLE | _I_SS_OWNERDRAW
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
  if not(_i_hdc is void) and typeof(IGL_Init) == "function" then
    IGL_Init(_i_hwnd, _i_hdc, _i_presentWidth, _i_presentHeight)
  end if
  if _i_fullscreen then
    _ = SetWindowLongPtrW(_i_hwnd, _I_GWL_STYLE, _I_WS_POPUP | _I_WS_VISIBLE | _I_SS_OWNERDRAW)
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

/// Drains queued Win32 messages, handles Alt+G directly, and quits if the stored game window was destroyed.
/// @internal
function _I_PumpMessages()
  if _i_hwnd is not void and not IsWindow(_i_hwnd) then
    if typeof(I_Quit) == "function" then I_Quit() end if
    return
  end if

  while PeekMessageW(_i_msg, void, 0, 0, _I_PM_REMOVE)
    msg = _I_ReadU32(_i_msg, 8)
    wparam = _I_ReadU32(_i_msg, 16)
    lparam = _I_ReadU32(_i_msg, 24)
    if msg == _I_WM_CLOSE or msg == _I_WM_DESTROY or msg == _I_WM_NCDESTROY or msg == _I_WM_QUIT then
      if typeof(I_Quit) == "function" then I_Quit() end if
      return
    end if
    if _I_HandleRendererHotkeyMessage(msg, wparam, lparam) then
      continue
    end if
    if msg == _I_WM_PAINT or msg == _I_WM_ERASEBKGND then
      // The built-in STATIC class can repaint its text into the client area.
      // MiniDoom owns presentation, so swallowing this avoids a white frame
      // with the FPS title drawn over the game view.
      if _i_hwnd is not void then ValidateRect(_i_hwnd, void) end if
    else
      TranslateMessage(_i_msg)
      DispatchMessageW(_i_msg)
    end if
  end while
end function

/// Creates the screenshot directory once and caches success so periodic captures avoid repeated filesystem
/// work.
/// @internal
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

/// Copies a scaled logical-screen rectangle into the high-resolution frame.
/// @param scaled Scaled value supplied to `_I_OverlayScaledRect`.
/// @param x Horizontal map- or screen-space coordinate.
/// @param y Vertical map- or screen-space coordinate.
/// @param w W value supplied to `_I_OverlayScaledRect`.
/// @param h H value supplied to `_I_OverlayScaledRect`.
/// @internal
function _I_OverlayScaledRect(scaled, x, y, w, h)
  if typeof(scaled) != "bytes" or len(scaled) < _i_presentWidth * _i_presentHeight then return end if
  if typeof(_i_presentBuffer) != "bytes" then return end if
  s = _i_presentScale
  if s <= 1 then return end if

  if x < 0 then
    w = w + x
    x = 0
  end if
  if y < 0 then
    h = h + y
    y = 0
  end if
  if x + w > SCREENWIDTH then w = SCREENWIDTH - x end if
  if y + h > SCREENHEIGHT then h = SCREENHEIGHT - y end if
  if w <= 0 or h <= 0 then return end if

  srcX = x * s
  srcY = y * s
  copyW = w * s
  copyH = h * s
  row = 0
  while row < copyH
    si = (srcY + row) * _i_presentWidth + srcX
    di = si
    copyBytes(_i_presentBuffer, di, scaled, si, copyW)
    row = row + 1
  end while
end function

/// Copies a logical-screen rectangle into the high-resolution frame with cheap nearest scaling.
/// @param src Src value supplied to `_I_OverlayLogicalRectNearest`.
/// @param x Horizontal map- or screen-space coordinate.
/// @param y Vertical map- or screen-space coordinate.
/// @param w W value supplied to `_I_OverlayLogicalRectNearest`.
/// @param h H value supplied to `_I_OverlayLogicalRectNearest`.
/// @internal
function _I_OverlayLogicalRectNearest(src, x, y, w, h)
  global _i_overlayRowBuffer

  if typeof(src) != "bytes" or len(src) < SCREENWIDTH * SCREENHEIGHT then return end if
  if typeof(_i_presentBuffer) != "bytes" then return end if
  s = _i_presentScale
  if s <= 1 then return end if

  if x < 0 then
    w = w + x
    x = 0
  end if
  if y < 0 then
    h = h + y
    y = 0
  end if
  if x + w > SCREENWIDTH then w = SCREENWIDTH - x end if
  if y + h > SCREENHEIGHT then h = SCREENHEIGHT - y end if
  if w <= 0 or h <= 0 then return end if

  if s == 3 and x == 0 and w == SCREENWIDTH then
    if typeof(_i_overlayRowBuffer) != "bytes" or len(_i_overlayRowBuffer) < _i_presentWidth then
      _i_overlayRowBuffer = bytes(_i_presentWidth, 0)
    end if
    sy = y
    while sy < y + h
      si = sy * SCREENWIDTH
      sx = 0
      while sx < SCREENWIDTH
        c = src[si + sx]
        di = sx * 3
        _i_overlayRowBuffer[di] = c
        _i_overlayRowBuffer[di + 1] = c
        _i_overlayRowBuffer[di + 2] = c
        sx = sx + 1
      end while
      blockY = sy * 3
      row = blockY * _i_presentWidth
      copyBytes(_i_presentBuffer, row, _i_overlayRowBuffer, 0, _i_presentWidth)
      copyBytes(_i_presentBuffer, row + _i_presentWidth, _i_overlayRowBuffer, 0, _i_presentWidth)
      copyBytes(_i_presentBuffer, row + _i_presentWidth * 2, _i_overlayRowBuffer, 0, _i_presentWidth)
      sy = sy + 1
    end while
    return
  end if

  sy = y
  while sy < y + h
    sx = x
    while sx < x + w
      c = src[sy * SCREENWIDTH + sx]
      blockX = sx * s
      blockY = sy * s
      yy = 0
      while yy < s
        di = (blockY + yy) * _i_presentWidth + blockX
        xx = 0
        while xx < s
          _i_presentBuffer[di + xx] = c
          xx = xx + 1
        end while
        yy = yy + 1
      end while
      sx = sx + 1
    end while
    sy = sy + 1
  end while
end function

/// Copies only logical pixels changed after the world pass, preserving high-res world rendering.
/// @param scaled Scaled value supplied to `_I_OverlayChangedLogicalPixels`.
/// @param cur Cur value supplied to `_I_OverlayChangedLogicalPixels`.
/// @param base Base value supplied to `_I_OverlayChangedLogicalPixels`.
/// @internal
function _I_OverlayChangedLogicalPixels(scaled, cur, base)
  if typeof(scaled) != "bytes" or len(scaled) < _i_presentWidth * _i_presentHeight then return end if
  if typeof(cur) != "bytes" or len(cur) < SCREENWIDTH * SCREENHEIGHT then return end if
  if typeof(base) != "bytes" or len(base) < SCREENWIDTH * SCREENHEIGHT then return end if
  if typeof(_i_presentBuffer) != "bytes" then return end if
  s = _i_presentScale
  if s <= 1 then return end if

  sy = 0
  while sy < SCREENHEIGHT
    sx = 0
    while sx < SCREENWIDTH
      idx = sy * SCREENWIDTH + sx
      if cur[idx] != base[idx] then
        blockX = sx * s
        blockY = sy * s
        yy = 0
        while yy < s
          si = (blockY + yy) * _i_presentWidth + blockX
          copyBytes(_i_presentBuffer, si, scaled, si, s)
          yy = yy + 1
        end while
      end if
      sx = sx + 1
    end while
    sy = sy + 1
  end while
end function

/// Copies changed logical pixels directly into the high-resolution frame.
/// @param cur Cur value supplied to `_I_OverlayChangedLogicalPixelsNearest`.
/// @param base Base value supplied to `_I_OverlayChangedLogicalPixelsNearest`.
/// @internal
function _I_OverlayChangedLogicalPixelsNearest(cur, base)
  if typeof(cur) != "bytes" or len(cur) < SCREENWIDTH * SCREENHEIGHT then return end if
  if typeof(base) != "bytes" or len(base) < SCREENWIDTH * SCREENHEIGHT then return end if
  if typeof(_i_presentBuffer) != "bytes" then return end if
  s = _i_presentScale
  if s <= 1 then return end if

  sy = 0
  while sy < SCREENHEIGHT
    sx = 0
    while sx < SCREENWIDTH
      idx = sy * SCREENWIDTH + sx
      if cur[idx] != base[idx] then
        c = cur[idx]
        blockX = sx * s
        blockY = sy * s
        yy = 0
        while yy < s
          di = (blockY + yy) * _i_presentWidth + blockX
          xx = 0
          while xx < s
            _i_presentBuffer[di + xx] = c
            xx = xx + 1
          end while
          yy = yy + 1
        end while
      end if
      sx = sx + 1
    end while
    sy = sy + 1
  end while
end function

/// Copies logical pixels marked by V_DrawPatch/V_DrawBlock into the high-resolution frame.
/// @param scaled Scaled value supplied to `_I_OverlayMarkedLogicalPixels`.
/// @param mask Mask value supplied to `_I_OverlayMarkedLogicalPixels`.
/// @internal
function _I_OverlayMarkedLogicalPixels(scaled, mask)
  if typeof(scaled) != "bytes" or len(scaled) < _i_presentWidth * _i_presentHeight then return false end if
  if typeof(mask) != "bytes" or len(mask) < SCREENWIDTH * SCREENHEIGHT then return false end if
  if typeof(_i_presentBuffer) != "bytes" then return false end if
  s = _i_presentScale
  if s <= 1 then return false end if

  any = false
  sy = 0
  while sy < SCREENHEIGHT
    sx = 0
    while sx < SCREENWIDTH
      idx = sy * SCREENWIDTH + sx
      if mask[idx] != 0 then
        any = true
        blockX = sx * s
        blockY = sy * s
        yy = 0
        while yy < s
          si = (blockY + yy) * _i_presentWidth + blockX
          copyBytes(_i_presentBuffer, si, scaled, si, s)
          yy = yy + 1
        end while
      end if
      sx = sx + 1
    end while
    sy = sy + 1
  end while
  return any
end function

/// Copies UI-marked logical pixels directly into the high-resolution frame.
/// @param src Src value supplied to `_I_OverlayMarkedLogicalPixelsNearest`.
/// @param mask Mask value supplied to `_I_OverlayMarkedLogicalPixelsNearest`.
/// @internal
function _I_OverlayMarkedLogicalPixelsNearest(src, mask)
  if typeof(src) != "bytes" or len(src) < SCREENWIDTH * SCREENHEIGHT then return false end if
  if typeof(mask) != "bytes" or len(mask) < SCREENWIDTH * SCREENHEIGHT then return false end if
  if typeof(_i_presentBuffer) != "bytes" then return false end if
  s = _i_presentScale
  if s <= 1 then return false end if

  any = false
  minx = 0
  miny = 0
  maxx = SCREENWIDTH - 1
  maxy = SCREENHEIGHT - 1
  if typeof(v_overlay_minx) == "int" and typeof(v_overlay_maxx) == "int" and v_overlay_maxx >= v_overlay_minx then
    minx = v_overlay_minx
    maxx = v_overlay_maxx
  end if
  if typeof(v_overlay_miny) == "int" and typeof(v_overlay_maxy) == "int" and v_overlay_maxy >= v_overlay_miny then
    miny = v_overlay_miny
    maxy = v_overlay_maxy
  end if
  if minx < 0 then minx = 0 end if
  if miny < 0 then miny = 0 end if
  if maxx >= SCREENWIDTH then maxx = SCREENWIDTH - 1 end if
  if maxy >= SCREENHEIGHT then maxy = SCREENHEIGHT - 1 end if
  if maxx < minx or maxy < miny then return false end if

  sy = miny
  while sy <= maxy
    sx = minx
    while sx <= maxx
      idx = sy * SCREENWIDTH + sx
      if mask[idx] != 0 then
        any = true
        c = src[idx]
        blockX = sx * s
        blockY = sy * s
        yy = 0
        while yy < s
          di = (blockY + yy) * _i_presentWidth + blockX
          xx = 0
          while xx < s
            _i_presentBuffer[di + xx] = c
            xx = xx + 1
          end while
          yy = yy + 1
        end while
      end if
      sx = sx + 1
    end while
    sy = sy + 1
  end while
  return any
end function

/// Copies pre-upscaled patch pixels prepared by V_DrawPatch into the presentation frame.
/// @internal
function _I_OverlayPreparedHighresPatches()
  if typeof(IGL_IsActive) != "function" or not IGL_IsActive() then return false end if
  if typeof(v_hioverlay) != "bytes" or typeof(v_hioverlaymask) != "bytes" then return false end if
  if typeof(_i_presentBuffer) != "bytes" then return false end if
  if len(v_hioverlay) < _i_presentWidth * _i_presentHeight then return false end if
  if len(v_hioverlaymask) < _i_presentWidth * _i_presentHeight then return false end if
  if typeof(v_hioverlay_maxx) != "int" or v_hioverlay_maxx < v_hioverlay_minx then return false end if

  minx = v_hioverlay_minx
  miny = v_hioverlay_miny
  maxx = v_hioverlay_maxx
  maxy = v_hioverlay_maxy
  if minx < 0 then minx = 0 end if
  if miny < 0 then miny = 0 end if
  if maxx >= _i_presentWidth then maxx = _i_presentWidth - 1 end if
  if maxy >= _i_presentHeight then maxy = _i_presentHeight - 1 end if
  if maxx < minx or maxy < miny then return false end if

  any = false
  y = miny
  while y <= maxy
    x = minx
    row = y * _i_presentWidth
    while x <= maxx
      idx = row + x
      if v_hioverlaymask[idx] != 0 then
        any = true
        _i_presentBuffer[idx] = v_hioverlay[idx]
      end if
      x = x + 1
    end while
    y = y + 1
  end while
  return any
end function

/// Ensures the OpenGL UI overlay color and alpha-mask buffers match the physical presentation dimensions.
/// @internal
function _I_EnsureGLOOverlay()
  global _i_glOverlayBuffer
  global _i_glOverlayMask

  expected = _i_presentWidth * _i_presentHeight
  if expected <= 0 then return false end if
  if typeof(_i_glOverlayBuffer) != "bytes" or len(_i_glOverlayBuffer) < expected then
    _i_glOverlayBuffer = bytes(expected, 0)
  end if
  if typeof(_i_glOverlayMask) != "bytes" or len(_i_glOverlayMask) < expected then
    _i_glOverlayMask = bytes(expected, 0)
  end if
  fillBytes(_i_glOverlayBuffer, 0, expected, 0)
  fillBytes(_i_glOverlayMask, 0, expected, 0)
  return true
end function

/// Expands one logical indexed pixel into its physical-scale overlay block and marks those destination pixels
/// opaque.
/// @param src Src value supplied to `_I_GLOverlayLogicalPixel`.
/// @param sx Horizontal coordinate or vector component represented by sx.
/// @param sy Vertical coordinate or vector component represented by sy.
/// @internal
function _I_GLOverlayLogicalPixel(src, sx, sy)
  s = _i_presentScale
  if s <= 0 then return end if
  c = src[sy * SCREENWIDTH + sx]
  blockX = sx * s
  blockY = sy * s
  yy = 0
  while yy < s
    di = (blockY + yy) * _i_presentWidth + blockX
    xx = 0
    while xx < s
      _i_glOverlayBuffer[di + xx] = c
      _i_glOverlayMask[di + xx] = 1
      xx = xx + 1
    end while
    yy = yy + 1
  end while
end function

/// Clips and expands a logical indexed rectangle into the OpenGL overlay buffers.
/// @param src Src value supplied to `_I_GLOverlayLogicalRect`.
/// @param x Horizontal map- or screen-space coordinate.
/// @param y Vertical map- or screen-space coordinate.
/// @param w W value supplied to `_I_GLOverlayLogicalRect`.
/// @param h H value supplied to `_I_GLOverlayLogicalRect`.
/// @internal
function _I_GLOverlayLogicalRect(src, x, y, w, h)
  if typeof(src) != "bytes" or len(src) < SCREENWIDTH * SCREENHEIGHT then return false end if
  if x < 0 then
    w = w + x
    x = 0
  end if
  if y < 0 then
    h = h + y
    y = 0
  end if
  if x + w > SCREENWIDTH then w = SCREENWIDTH - x end if
  if y + h > SCREENHEIGHT then h = SCREENHEIGHT - y end if
  if w <= 0 or h <= 0 then return false end if

  sy = y
  while sy < y + h
    sx = x
    while sx < x + w
      _I_GLOverlayLogicalPixel(src, sx, sy)
      sx = sx + 1
    end while
    sy = sy + 1
  end while
  return true
end function

/// Expands only mask-selected logical indexed pixels into the OpenGL overlay buffers.
/// @param src Src value supplied to `_I_GLOverlayLogicalMask`.
/// @param mask Mask value supplied to `_I_GLOverlayLogicalMask`.
/// @internal
function _I_GLOverlayLogicalMask(src, mask)
  if typeof(src) != "bytes" or len(src) < SCREENWIDTH * SCREENHEIGHT then return false end if
  if typeof(mask) != "bytes" or len(mask) < SCREENWIDTH * SCREENHEIGHT then return false end if
  if typeof(v_overlay_maxx) != "int" or v_overlay_maxx < v_overlay_minx then return false end if

  minx = v_overlay_minx
  miny = v_overlay_miny
  maxx = v_overlay_maxx
  maxy = v_overlay_maxy
  if minx < 0 then minx = 0 end if
  if miny < 0 then miny = 0 end if
  if maxx >= SCREENWIDTH then maxx = SCREENWIDTH - 1 end if
  if maxy >= SCREENHEIGHT then maxy = SCREENHEIGHT - 1 end if
  if maxx < minx or maxy < miny then return false end if

  any = false
  sy = miny
  while sy <= maxy
    sx = minx
    while sx <= maxx
      idx = sy * SCREENWIDTH + sx
      if mask[idx] != 0 then
        any = true
        _I_GLOverlayLogicalPixel(src, sx, sy)
      end if
      sx = sx + 1
    end while
    sy = sy + 1
  end while
  return any
end function

/// Merges prepared native-resolution patch pixels and their mask into the OpenGL overlay buffers.
/// @internal
function _I_GLOverlayHighresPatches()
  if typeof(v_hioverlay) != "bytes" or typeof(v_hioverlaymask) != "bytes" then return false end if
  expected = _i_presentWidth * _i_presentHeight
  if len(v_hioverlay) < expected or len(v_hioverlaymask) < expected then return false end if
  if typeof(v_hioverlay_maxx) != "int" or v_hioverlay_maxx < v_hioverlay_minx then return false end if

  minx = v_hioverlay_minx
  miny = v_hioverlay_miny
  maxx = v_hioverlay_maxx
  maxy = v_hioverlay_maxy
  if minx < 0 then minx = 0 end if
  if miny < 0 then miny = 0 end if
  if maxx >= _i_presentWidth then maxx = _i_presentWidth - 1 end if
  if maxy >= _i_presentHeight then maxy = _i_presentHeight - 1 end if
  if maxx < minx or maxy < miny then return false end if

  any = false
  y = miny
  while y <= maxy
    x = minx
    row = y * _i_presentWidth
    while x <= maxx
      idx = row + x
      if v_hioverlaymask[idx] != 0 then
        any = true
        _i_glOverlayBuffer[idx] = v_hioverlay[idx]
        _i_glOverlayMask[idx] = 1
      end if
      x = x + 1
    end while
    y = y + 1
  end while
  return any
end function

/// Returns the logical start row of a visible status bar, or screen height when fullscreen rendering must
/// remain unobscured.
/// @internal
function inline _I_StatusOverlayY()
  if typeof(_D_StatusBarVisible) == "function" and _D_StatusBarVisible() then
    y = SCREENHEIGHT - _I_STATUSBAR_HEIGHT
    if y < 0 then return 0 end if
    return y
  end if
  return SCREENHEIGHT
end function

/// Composes a visible status bar, marked logical UI, and prepared HD patches, then submits the masked overlay
/// to OpenGL.
/// @internal
function _I_DrawGLOverlayFrame()
  if typeof(screens) != "array" or len(screens) == 0 or typeof(screens[0]) != "bytes" then return false end if

  logical = screens[0]
  statusY = _I_StatusOverlayY()

  if typeof(IGL_DrawIndexedOverlayLayers) == "function" and typeof(v_overlaymask) == "bytes" then
    logicalMinX = SCREENWIDTH
    logicalMinY = SCREENHEIGHT
    logicalMaxX = -1
    logicalMaxY = -1
    if typeof(v_overlay_minx) == "int" then logicalMinX = v_overlay_minx end if
    if typeof(v_overlay_miny) == "int" then logicalMinY = v_overlay_miny end if
    if typeof(v_overlay_maxx) == "int" then logicalMaxX = v_overlay_maxx end if
    if typeof(v_overlay_maxy) == "int" then logicalMaxY = v_overlay_maxy end if

    highres = void
    highresMask = void
    highresMinX = _i_presentWidth
    highresMinY = _i_presentHeight
    highresMaxX = -1
    highresMaxY = -1
    if typeof(v_hioverlay) == "bytes" and typeof(v_hioverlaymask) == "bytes" then
      highres = v_hioverlay
      highresMask = v_hioverlaymask
      if typeof(v_hioverlay_minx) == "int" then highresMinX = v_hioverlay_minx end if
      if typeof(v_hioverlay_miny) == "int" then highresMinY = v_hioverlay_miny end if
      if typeof(v_hioverlay_maxx) == "int" then highresMaxX = v_hioverlay_maxx end if
      if typeof(v_hioverlay_maxy) == "int" then highresMaxY = v_hioverlay_maxy end if
    end if

    if IGL_DrawIndexedOverlayLayers(logical, v_overlaymask, logicalMinX, logicalMinY, logicalMaxX, logicalMaxY, highres, highresMask, highresMinX, highresMinY, highresMaxX, highresMaxY, _i_presentWidth, _i_presentHeight, statusY) then return true end if
  end if

  if not _I_EnsureGLOOverlay() then return false end if
  any = false
  if _I_GLOverlayLogicalRect(logical, 0, statusY, SCREENWIDTH, SCREENHEIGHT - statusY) then any = true end if
  if typeof(v_overlaymask) == "bytes" then
    if _I_GLOverlayLogicalMask(logical, v_overlaymask) then
      any = true
    end if
  end if
  if _I_GLOverlayHighresPatches() then any = true end if
  if not any then return false end if
  return IGL_DrawIndexedOverlay(_i_glOverlayBuffer, _i_glOverlayMask, _i_presentWidth, _i_presentHeight)
end function

/// Builds a cheap nearest-scaled logical frame used as fallback behind prepared assets.
/// @param src Src value supplied to `_I_BuildNearestLogicalFrame`.
/// @internal
function _I_BuildNearestLogicalFrame(src)
  global _i_presentBuffer

  if typeof(src) != "bytes" then return src end if
  if _i_presentScale <= 1 then return src end if
  if typeof(_i_presentBuffer) != "bytes" or len(_i_presentBuffer) < _i_presentWidth * _i_presentHeight then
    _i_presentBuffer = bytes(_i_presentWidth * _i_presentHeight, 0)
  end if
  _I_OverlayLogicalRectNearest(src, 0, 0, SCREENWIDTH, SCREENHEIGHT)
  _I_OverlayPreparedHighresPatches()
  return _i_presentBuffer
end function

/// Presents the native high-resolution world buffer plus scaled logical UI/overlay areas.
/// @internal
function _I_BuildHighresGameFrame()
  global _i_presentBuffer

  if typeof(screens) != "array" or len(screens) == 0 or typeof(screens[0]) != "bytes" then
    return RH_Buffer()
  end if
  logical = screens[0]

  if gamestate != gamestate_t.GS_LEVEL or automapactive then
    return _I_BuildNearestLogicalFrame(logical)
  end if

  hi = RH_Buffer()
  if typeof(hi) != "bytes" then return hi end if
  expected = _i_presentWidth * _i_presentHeight
  if len(hi) < expected then return hi end if
  if typeof(_i_presentBuffer) != "bytes" or len(_i_presentBuffer) < expected then
    _i_presentBuffer = bytes(expected, 0)
  end if

  copyBytes(_i_presentBuffer, 0, hi, 0, expected)
  statusY = _I_StatusOverlayY()
  _I_OverlayLogicalRectNearest(logical, 0, statusY, SCREENWIDTH, SCREENHEIGHT - statusY)
  usedMask = false
  if typeof(v_overlaymask) == "bytes" then
    usedMask = _I_OverlayMarkedLogicalPixelsNearest(logical, v_overlaymask)
  else
    _I_OverlayChangedLogicalPixelsNearest(logical, _i_overlayBase)
  end if
  _I_OverlayPreparedHighresPatches()
  return _i_presentBuffer
end function

/// Returns the framebuffer that should be presented to the window.
/// @internal
function _I_BuildPresentFrame()
  if typeof(RH_IsActive) == "function" and RH_IsActive() then
    return _I_BuildHighresGameFrame()
  end if

  if typeof(screens) != "array" or len(screens) == 0 then return void end if
  if typeof(IGL_IsActive) == "function" and IGL_IsActive() and gamestate != gamestate_t.GS_LEVEL then
    return _I_BuildNearestLogicalFrame(screens[0])
  end if
  return _I_BuildNearestLogicalFrame(screens[0])
end function

/// Builds an 8-bit BMP from a prepared indexed frame.
/// @param src Src value supplied to `_I_BuildBmpFromIndexedFrame`.
/// @param width Width of the target in pixels or map units.
/// @param height Height of the target in pixels or map units.
/// @internal
function _I_BuildBmpFromIndexedFrame(src, width, height)
  if typeof(src) != "bytes" then return end if
  if typeof(width) != "int" or typeof(height) != "int" then return end if
  if width <= 0 or height <= 0 then return end if
  if len(src) <(width * height) then return end if
  if typeof(_i_paletteRgb) != "bytes" or len(_i_paletteRgb) < 768 then return end if

  palBytes = 256 * 4
  pixelBytes = width * height
  fileSize = _I_BMP_HEADER_SIZE + palBytes + pixelBytes
  bmp = bytes(fileSize, 0)

  bmp[0] = 66
  bmp[1] = 77
  _I_WriteU32(bmp, 2, fileSize)
  _I_WriteU32(bmp, 10, _I_BMP_HEADER_SIZE + palBytes)

  _I_WriteU32(bmp, 14, 40)
  _I_WriteU32(bmp, 18, width)
  _I_WriteU32(bmp, 22, - height)
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
  copyBytes(bmp, di, src, si, pixelBytes)

  return bmp
end function

/// Encodes the currently selected presentation framebuffer as an 8-bit BMP.
/// @internal
function _I_BuildBmpFromFrame()
  src = _I_BuildPresentFrame()
  return _I_BuildBmpFromIndexedFrame(src, _i_presentWidth, _i_presentHeight)
end function

/// Keeps the physical presentation scale inside the supported range.
/// @param scale Scale value supplied to `_I_ClampPresentScale`.
/// @internal
function inline _I_ClampPresentScale(scale)
  s = _I_ToIntOr(scale, 1)
  if s < 1 then s = 1 end if
  if s > 4 then s = 4 end if
  return s
end function

/// Initializes physical framebuffer dimensions used by GDI presentation.
/// @internal
function _I_InitPresentMetrics()
  global _i_presentScale
  global _i_presentWidth
  global _i_presentHeight
  global _i_presentBuffer
  global _i_overlayRowBuffer
  global _i_overlayBase
  global _i_glOverlayBuffer
  global _i_glOverlayMask

  s = 1
  if typeof(RU_RenderScale) == "function" then
    s = RU_RenderScale()
  end if
  s = _I_ClampPresentScale(s)

  _i_presentScale = s
  _i_presentWidth = SCREENWIDTH * s
  _i_presentHeight = SCREENHEIGHT * s
  _i_presentBuffer = bytes(_i_presentWidth * _i_presentHeight, 0)
  _i_overlayRowBuffer = bytes(_i_presentWidth, 0)
  _i_overlayBase = bytes(SCREENWIDTH * SCREENHEIGHT, 0)
  _i_glOverlayBuffer = bytes(_i_presentWidth * _i_presentHeight, 0)
  _i_glOverlayMask = bytes(_i_presentWidth * _i_presentHeight, 0)
end function

/// Captures the current presentation selection and delegates indexed BMP creation and numbered file output.
/// @internal
function _I_WriteAutoScreenshot()
  _I_WriteAutoScreenshotFromFrame(_I_BuildPresentFrame(), _i_presentWidth, _i_presentHeight)
end function

/// Writes an auto screenshot from a prepared indexed frame.
/// @param src Src value supplied to `_I_WriteAutoScreenshotFromFrame`.
/// @param width Width of the target in pixels or map units.
/// @param height Height of the target in pixels or map units.
/// @internal
function _I_WriteAutoScreenshotFromFrame(src, width, height)
  global _i_screenshotIndex
  global _i_screenshotWriteError

  if not _I_EnsureScreenshotDir() then return end if

  bmp = _I_BuildBmpFromIndexedFrame(src, width, height)
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

/// Returns true when the next auto screenshot interval has elapsed.
/// @internal
function _I_ShouldAutoScreenshot()
  global _i_screenshotNextTick

  if not _i_screenshotEnabled then return false end if

  now = std.time.ticks()
  if typeof(now) != "int" then return false end if

  if _i_screenshotNextTick == 0 then
    _i_screenshotNextTick = now + _I_SCREENSHOT_INTERVAL_MS
    return false
  end if

  if now < _i_screenshotNextTick then return false end if

  while _i_screenshotNextTick <= now
    _i_screenshotNextTick = _i_screenshotNextTick + _I_SCREENSHOT_INTERVAL_MS
  end while
  return true
end function

/// Writes the current presentation frame only when the one-second automatic capture deadline has elapsed.
/// @internal
function _I_MaybeAutoScreenshot()
  if _I_ShouldAutoScreenshot() then _I_WriteAutoScreenshot() end if
end function

/// Writes a prepared frame when the auto screenshot interval has elapsed.
/// @param src Src value supplied to `_I_MaybeAutoScreenshotFromFrame`.
/// @param width Width of the target in pixels or map units.
/// @param height Height of the target in pixels or map units.
/// @internal
function _I_MaybeAutoScreenshotFromFrame(src, width, height)
  if _I_ShouldAutoScreenshot() then _I_WriteAutoScreenshotFromFrame(src, width, height) end if
end function

/// Clears all remembered key-down edges and optionally posts matching Doom key-up events on focus loss.
/// @param postEvents Post events value supplied to `_I_ReleaseKeyboard`.
/// @internal
function _I_ReleaseKeyboard(postEvents)
  global _i_altGPrev
  global _i_consoleTildePrev

  _I_InitKeyMap()

  if typeof(_i_keyPrev) != "array" then return end if
  if typeof(_i_keyDoom) != "array" then return end if

  _i_altGPrev = false
  _i_consoleTildePrev = false

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

/// Polls mapped virtual keys while focused, posts edge-triggered Doom events, and handles the Alt+G renderer
/// toggle.
/// @internal
function _I_PollKeyboard()
  global _i_altGPrev
  global _i_consoleTildePrev

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

  altDown =((GetAsyncKeyState(0x12) & 32768) != 0)
  gDown =((GetAsyncKeyState(0x47) & 32768) != 0)
  altGDown = altDown and gDown
  if altGDown and not _i_altGPrev then
    _I_ToggleRendererHotkey()
  end if
  _i_altGPrev = altGDown

  // On German keyboards the printed tilde is AltGr+Plus, represented by
  // simultaneous Ctrl, Alt, and VK_OEM_PLUS states rather than VK_OEM_3.
  ctrlDown =((GetAsyncKeyState(0x11) & 32768) != 0)
  plusDown =((GetAsyncKeyState(0xBB) & 32768) != 0)
  consoleTildeDown = ctrlDown and altDown and plusDown
  if consoleTildeDown and not _i_consoleTildePrev then
    if typeof(D_PostEvent) == "function" then
      D_PostEvent(event_t(evtype_t.ev_keydown, KEY_CONSOLE, 0, 0))
      D_PostEvent(event_t(evtype_t.ev_keyup, KEY_CONSOLE, 0, 0))
    end if
  end if
  _i_consoleTildePrev = consoleTildeDown

  n = len(_i_keyVk)
  i = 0
  while i < n
    vk = _i_keyVk[i]
    doomKey = _i_keyDoom[i]
    st = GetAsyncKeyState(vk)
    down =((st & 32768) != 0)
    pressedSincePoll =((st & 1) != 0)
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
    else if pressedSincePoll and(not down) and(not prev) then
      // Preserve taps shorter than one 35 Hz input poll by emitting their complete edge pair.
      if typeof(D_PostEvent) == "function" then
        D_PostEvent(event_t(evtype_t.ev_keydown, doomKey, 0, 0))
        D_PostEvent(event_t(evtype_t.ev_keyup, doomKey, 0, 0))
      end if
    end if

    i = i + 1
  end while
end function

/// Packs the current left, right, and middle Win32 button states into Doom's three-bit mouse mask.
/// @internal
function inline _I_MouseButtonsNow()
  b = 0
  if (GetAsyncKeyState(_I_VK_LBUTTON) & 32768) != 0 then b = b | 1 end if
  if (GetAsyncKeyState(_I_VK_RBUTTON) & 32768) != 0 then b = b | 2 end if
  if (GetAsyncKeyState(_I_VK_MBUTTON) & 32768) != 0 then b = b | 4 end if
  return b
end function

/// Converts focused cursor deltas and button changes into Doom mouse events while synchronizing cursor
/// visibility.
/// @internal
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

/// Allocates video/input buffers, parses display and screenshot options, creates the window, and initializes
/// presentation state.
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
  global _i_presentScale
  global _i_presentWidth
  global _i_presentHeight
  global _i_presentBuffer

  if _i_inited then return end if

  if screens[0] == 0 then
    V_Init()
  end if

  _I_InitPresentMetrics()

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
  if _i_presentScale > 1 then
    print "I_InitGraphics: present scale " + _i_presentScale + "x (" + _i_presentWidth + "x" + _i_presentHeight + ")"
  end if
  if _i_screenshotEnabled then
    print "I_InitGraphics: auto screenshots every 1s -> " + _i_screenshotDir
  else
    print "I_InitGraphics: auto screenshots disabled (enable with -shots)"
  end if

  _i_inited = true
end function

/// Restores the cursor, shuts down OpenGL, releases the device context, and destroys the owned native window.
function I_ShutdownGraphics()
  global _i_inited
  global _i_hwnd
  global _i_hdc
  global _i_ownsWindow

  _I_SetCursorVisible(true)

  if typeof(IGL_Shutdown) == "function" then IGL_Shutdown() end if

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

/// Applies the selected gamma table to a 256-color palette and updates both GDI and OpenGL palette consumers.
/// @param palette Palette value supplied to `I_SetPalette`.
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
  if typeof(IGL_SetPalette) == "function" then IGL_SetPalette(_i_paletteRgb) end if
end function

/// Services the Win32 message queue without presenting or modifying a framebuffer.
function I_UpdateNoBlit()
  _I_PumpMessages()
end function

/// Composes the current OpenGL world and UI, then reads a logical indexed capture into screen zero.
function I_CaptureGLFrameToScreen()
  if not _i_inited then return false end if
  if typeof(IGL_IsActive) != "function" or not IGL_IsActive() then return false end if
  if typeof(IGL_HasFrameReady) == "function" and not IGL_HasFrameReady() then return false end if
  if typeof(screens) != "array" or len(screens) == 0 or typeof(screens[0]) != "bytes" then return false end if
  if _i_hwnd is void then return false end if

  destW = _i_presentWidth
  destH = _i_presentHeight
  if GetClientRect(_i_hwnd, _i_rect) then
    cw = _I_ReadS32(_i_rect, 8) - _I_ReadS32(_i_rect, 0)
    ch = _I_ReadS32(_i_rect, 12) - _I_ReadS32(_i_rect, 4)
    if cw > 0 then destW = cw end if
    if ch > 0 then destH = ch end if
  end if
  if typeof(IGL_Resize) == "function" then IGL_Resize(destW, destH) end if
  _I_DrawGLOverlayFrame()
  if typeof(IGL_DrawPaletteFlash) == "function" then IGL_DrawPaletteFlash() end if
  if typeof(IGL_CaptureLogicalIndexed) != "function" then return false end if
  return IGL_CaptureLogicalIndexed(screens[0], SCREENWIDTH, SCREENHEIGHT)
end function

/// Palette-expands an arbitrary indexed frame, resizes the GL viewport, submits it as RGBA, and swaps buffers.
/// @param src Src value supplied to `_I_PresentIndexedFrameGLSized`.
/// @param srcW Src w value supplied to `_I_PresentIndexedFrameGLSized`.
/// @param srcH Src h value supplied to `_I_PresentIndexedFrameGLSized`.
/// @internal
function _I_PresentIndexedFrameGLSized(src, srcW, srcH)
  if typeof(src) != "bytes" then return false end if
  if typeof(srcW) != "int" or typeof(srcH) != "int" then return false end if
  if srcW <= 0 or srcH <= 0 then return false end if
  if typeof(IGL_DrawRGBAFrame) != "function" then return false end if
  if not _I_SaveLastRGBAFrameSized(src, srcW, srcH) then return false end if
  if typeof(_i_lastPresentRGBA) != "bytes" then return false end if

  destW = _i_presentWidth
  destH = _i_presentHeight
  if GetClientRect(_i_hwnd, _i_rect) then
    cw = _I_ReadS32(_i_rect, 8) - _I_ReadS32(_i_rect, 0)
    ch = _I_ReadS32(_i_rect, 12) - _I_ReadS32(_i_rect, 4)
    if cw > 0 then destW = cw end if
    if ch > 0 then destH = ch end if
  end if
  if typeof(IGL_Resize) == "function" then IGL_Resize(destW, destH) end if
  if not IGL_DrawRGBAFrame(_i_lastPresentRGBA, srcW, srcH) then return false end if
  if typeof(IGL_MarkFrameReady) == "function" then IGL_MarkFrameReady() end if
  return IGL_Swap()
end function

/// Presents an indexed frame whose dimensions match the physical presentation buffer.
/// @param src Src value supplied to `_I_PresentIndexedFrameGL`.
/// @internal
function _I_PresentIndexedFrameGL(src)
  return _I_PresentIndexedFrameGLSized(src, _i_presentWidth, _i_presentHeight)
end function

/// Captures the logical framebuffer before late menu/message drawing.
function I_CaptureLogicalOverlayBase()
  global _i_overlayBase

  if _i_presentScale <= 1 then return end if
  if typeof(screens) != "array" or len(screens) == 0 or typeof(screens[0]) != "bytes" then return end if
  if typeof(_i_overlayBase) != "bytes" or len(_i_overlayBase) < SCREENWIDTH * SCREENHEIGHT then
    _i_overlayBase = bytes(SCREENWIDTH * SCREENHEIGHT, 0)
  end if
  copyBytes(_i_overlayBase, 0, screens[0], 0, SCREENWIDTH * SCREENHEIGHT)
end function

/// Sets or clears loading text in the window caption, resets animation when cleared, and pumps messages
/// immediately.
/// @param text Text to process.
function I_SetLoadingStatus(text)
  global _i_loadingStatusText
  global _i_loadingAnimPhase
  if not _i_inited then return end if

  if typeof(text) != "string" then text = "" end if
  _i_loadingStatusText = text
  if len(text) == 0 then
    _i_loadingAnimPhase = 0
    _I_SetWindowTitle(_I_FpsTitle())
  else
    _I_SetWindowTitle(_i_titleBase + " | " + text)
  end if
  _I_PumpMessages()
end function

/// Pumps window/audio updates and draws an animated loading marker while heavy loading code runs.
function I_LoadingPulse()
  if not _i_inited then return end if
  _I_PumpMessages()
  if _i_presentScale > 1 then
    if typeof(I_UpdateSound) == "function" then I_UpdateSound() end if
    if typeof(I_SubmitSound) == "function" then I_SubmitSound() end if
    return
  end if
  _I_DrawLoadingIndicator()
  if typeof(I_FinishUpdate) == "function" then I_FinishUpdate() end if
  if typeof(I_UpdateSound) == "function" then I_UpdateSound() end if
  if typeof(I_SubmitSound) == "function" then I_SubmitSound() end if
end function

/// Pumps native messages and posts current keyboard and mouse edge/motion events to Doom.
function I_PollInput()
  _I_PumpMessages()
  _I_PollKeyboard()
  _I_PollMouse()
end function

/// Presents one completed frame through native OpenGL, indexed GL fallback, or GDI and performs FPS/screenshot
/// bookkeeping.
function I_FinishUpdate()
  if not _i_inited then return end if

  _I_PumpMessages()

  if _i_hwnd is void then
    if not _I_CreateWindow() then return end if
  end if

  if (not _i_forceSoftwarePresent) and typeof(IGL_IsActive) == "function" and IGL_IsActive() and gamestate == gamestate_t.GS_LEVEL and not automapactive then
    _I_UpdateWindowTitle()
    if typeof(IGL_HasFrameReady) == "function" and not IGL_HasFrameReady() then return end if
    destW = _i_presentWidth
    destH = _i_presentHeight
    if GetClientRect(_i_hwnd, _i_rect) then
      cw = _I_ReadS32(_i_rect, 8) - _I_ReadS32(_i_rect, 0)
      ch = _I_ReadS32(_i_rect, 12) - _I_ReadS32(_i_rect, 4)
      if cw > 0 then destW = cw end if
      if ch > 0 then destH = ch end if
    end if
    if typeof(IGL_Resize) == "function" then IGL_Resize(destW, destH) end if
    _I_DrawGLOverlayFrame()
    if typeof(IGL_DrawPaletteFlash) == "function" then IGL_DrawPaletteFlash() end if
    if _i_screenshotEnabled and typeof(IGL_CaptureLogicalIndexed) == "function" then
      if typeof(_i_presentBuffer) != "bytes" or len(_i_presentBuffer) < _i_presentWidth * _i_presentHeight then
        _i_presentBuffer = bytes(_i_presentWidth * _i_presentHeight, 0)
      end if
      if IGL_CaptureLogicalIndexed(_i_presentBuffer, _i_presentWidth, _i_presentHeight) then
        _I_MaybeAutoScreenshotFromFrame(_i_presentBuffer, _i_presentWidth, _i_presentHeight)
      else
        _I_MaybeAutoScreenshot()
      end if
    end if
    IGL_Swap()
    return
  end if

  // Classic, menu, and automap frames already contain the complete 320x200 image.
  // Let GL_NEAREST scale that small texture instead of expanding and palette-
  // converting the physical 3x buffer on the CPU before every presentation.
  if (not _i_forceSoftwarePresent) and typeof(IGL_IsAvailable) == "function" and IGL_IsAvailable() and(typeof(IGL_IsActive) != "function" or not IGL_IsActive()) then
    if typeof(screens) == "array" and len(screens) > 0 and typeof(screens[0]) == "bytes" then
      _I_MaybeAutoScreenshot()
      _I_UpdateWindowTitle()
      if _I_PresentIndexedFrameGLSized(screens[0], SCREENWIDTH, SCREENHEIGHT) then return end if
    end if
  end if

  src = void
  if _i_forceSoftwarePresent then
    if typeof(screens) != "array" or len(screens) == 0 then return end if
    src = _I_BuildNearestLogicalFrame(screens[0])
  else
    src = _I_BuildPresentFrame()
  end if
  if typeof(src) != "bytes" then return end if

  _I_MaybeAutoScreenshot()
  _I_UpdateWindowTitle()

  if typeof(IGL_IsAvailable) == "function" and IGL_IsAvailable() then
    if _I_PresentIndexedFrameGL(src) then return end if
  end if

  hdc = _i_hdc
  if hdc is void then
    hdc = GetDC(_i_hwnd)
    global _i_hdc
    _i_hdc = hdc
    if hdc is void then return end if
    SetStretchBltMode(hdc, _I_COLORONCOLOR)
  end if

  destW = _i_presentWidth
  destH = _i_presentHeight
  if GetClientRect(_i_hwnd, _i_rect) then
    cw = _I_ReadS32(_i_rect, 8) - _I_ReadS32(_i_rect, 0)
    ch = _I_ReadS32(_i_rect, 12) - _I_ReadS32(_i_rect, 4)
    if cw > 0 then destW = cw end if
    if ch > 0 then destH = ch end if
  end if

  StretchDIBits(
  hdc,
  0, 0, destW, destH,
  0, 0, _i_presentWidth, _i_presentHeight,
  src,
  _i_bmi,
  _I_DIB_RGB_COLORS,
  _I_SRCCOPY
)
  _I_SaveLastPresentFrame(src)
end function

/// Copies the complete 320x200 logical framebuffer from screen zero into a caller-provided capture buffer.
/// @param scr Scr value supplied to `I_ReadScreen`.
function I_ReadScreen(scr)
  if typeof(scr) != "bytes" then return end if
  src = screens[0]
  copyBytes(scr, 0, src, 0, SCREENWIDTH * SCREENHEIGHT)
end function

/// Preserves the legacy cursor-construction hook; cursor hiding is handled through ShowCursor instead.
function createnullcursor()

end function

/// Preserves the legacy shared-framebuffer allocation hook; this backend owns byte buffers directly and returns
/// void.
/// @param size Requested size in bytes or elements.
function grabsharedmemory(size)
  size = size
  return void
end function

/// Preserves the legacy indexed expansion initializer; physical scaling is performed by current presentation
/// paths.
function InitExpand()
end function

/// Preserves the second legacy expansion initializer; no precomputed expansion tables are required.
function InitExpand2()
end function

/// Retains the legacy expansion entry point as a bounded raw byte copy into the destination buffer.
/// @param src Src value supplied to `Expand4`.
/// @param dst Dst value supplied to `Expand4`.
/// @param count Number of elements or iterations to process.
function Expand4(src, dst, count)
  if typeof(src) != "bytes" or typeof(dst) != "bytes" then return end if
  copyBytes(dst, 0, src, 0, count)
end function

/// Compatibility entry point that applies a newly selected Doom palette through the active gamma-aware path.
/// @param pal Pal value supplied to `UploadNewPalette`.
function UploadNewPalette(pal)
  I_SetPalette(pal)
end function

/// Translates a Win32 virtual key to its Doom code, with direct digit and lowercase-letter fallbacks.
/// @param vk Vk value supplied to `xlatekey`.
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

/// Pumps native messages and posts all currently observed keyboard and mouse input changes.
function I_GetEvent()
  _I_PumpMessages()
  _I_PollKeyboard()
  _I_PollMouse()
end function

/// Services native window messages at the start of a rendered frame.
function I_StartFrame()
  _I_PumpMessages()
end function

/// Polls and posts platform input events at the start of a simulation tic.
function I_StartTic()
  I_GetEvent()
end function



