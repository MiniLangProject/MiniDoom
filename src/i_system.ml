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

  Script: i_system.ml
  Purpose: Supplies Win32 timing, sleep, shutdown, fatal-error, low-memory allocation, and base command services to the engine.
*/
import d_ticcmd
import d_event
import doomdef
import m_misc
import i_video
import i_sound
import d_net
import g_game
import i_system
import mp_platform
import std.math

const _ISYS_MB_OK = 0x00000000
const _ISYS_MB_ICONERROR = 0x00000010

/*
* Function: _IS_IDiv
* Purpose: Returns a signed quotient truncated toward zero, or zero for invalid operands and a zero divisor.
*/
function inline _IS_IDiv(a, b)
  if typeof(a) != "int" or typeof(b) != "int" or b == 0 then return 0 end if
  q = a / b
  if q >= 0 then return std.math.floor(q) end if
  return std.math.ceil(q)
end function

/*
* Function: _I_ToLowerAscii
* Purpose: Converts a string to lowercase ASCII for robust message classification.
*/
function inline _I_ToLowerAscii(s)
  if typeof(s) != "string" then return "" end if
  b = bytes(s)
  i = 0
  while i < len(b)
    if b[i] >= 65 and b[i] <= 90 then b[i] = b[i] + 32 end if
    i = i + 1
  end while
  return decode(b)
end function

/*
* Function: _I_StrContains
* Purpose: Checks whether one string contains another.
*/
function inline _I_StrContains(haystack, needle)
  if typeof(haystack) != "string" or typeof(needle) != "string" then return false end if
  hb = bytes(haystack)
  nb = bytes(needle)
  if len(nb) == 0 then return true end if
  if len(nb) > len(hb) then return false end if

  i = 0
  while i <= len(hb) - len(nb)
    ok = true
    j = 0
    while j < len(nb)
      if hb[i + j] != nb[j] then
        ok = false
        break
      end if
      j = j + 1
    end while
    if ok then return true end if
    i = i + 1
  end while
  return false
end function

/*
* Function: _I_ShowFatalErrorBox
* Purpose: Shows a fatal error message in a GUI dialog for windows-subsystem builds.
*/
function inline _I_ShowFatalErrorBox(text)
  if typeof(text) != "string" or text == "" then return end if
  if typeof(MessageBoxW) != "function" then return end if
  _ = MessageBoxW(0, text, "MiniDoom - Fatal Error", _ISYS_MB_OK | _ISYS_MB_ICONERROR)
end function

/*
* Function: I_Init
* Purpose: Brings up the platform audio backend after core engine globals are available.
*/
function I_Init()

  if typeof(I_InitSound) == "function" then I_InitSound() end if

end function

/*
* Function: I_ZoneBase
* Purpose: Allocates the requested zone heap, reports its actual size through the reference argument, and retains the buffer for engine-wide lifetime.
*/
function I_ZoneBase(sizeOut)
  size = I_GetHeapSize()
  if typeof(sizeOut) == "array" and len(sizeOut) > 0 then
    sizeOut[0] = size
  end if

  return bytes(size)
end function

/*
* Function: I_GetTime
* Purpose: Converts elapsed Win32 milliseconds since the first call into whole 35 Hz game tics.
*/
function I_GetTime()
  global _I_basetime

  t = _I_GetTickCount()
  if _I_basetime == 0 then _I_basetime = t end if

  dt = t - _I_basetime
  if dt < 0 then dt = 0 end if
  return _IS_IDiv(dt * TICRATE, 1000)
end function

/*
* Function: I_GetTimeFrac
* Purpose: Returns the clamped fractional progress through the current 35 Hz tic for uncapped interpolation.
*/
function I_GetTimeFrac()
  global _I_basetime

  t = _I_GetTickCount()
  if _I_basetime == 0 then _I_basetime = t end if

  dt = t - _I_basetime
  if dt < 0 then dt = 0 end if

  scaled = dt * TICRATE
  fracnum = scaled % 1000
  if fracnum < 0 then fracnum = fracnum + 1000 end if
  f = fracnum / 1000
  if f < 0 then f = 0 end if
  if f > 1 then f = 1 end if
  return f
end function

/*
* Function: I_BaseTiccmd
* Purpose: Returns a reusable zeroed tic-command record that platform input code may populate for the current game tic.
*/
function I_BaseTiccmd()
  global _I_emptycmd

  if typeof(_I_emptycmd) == "void" then
    _I_emptycmd = ticcmd_t(0, 0, 0, 0, 0, 0)
  end if
  return _I_emptycmd
end function

/*
* Function: I_Quit
* Purpose: Leaves the netgame, closes platform, audio, and graphics services, saves defaults, then exits successfully.
*/
function I_Quit()

  if typeof(D_QuitNetGame) == "function" then D_QuitNetGame() end if
  if typeof(MP_PlatformShutdown) == "function" then MP_PlatformShutdown() end if
  if typeof(I_ShutdownSound) == "function" then I_ShutdownSound() end if
  if typeof(I_ShutdownMusic) == "function" then I_ShutdownMusic() end if
  if typeof(M_SaveDefaults) == "function" then M_SaveDefaults() end if
  if typeof(I_ShutdownGraphics) == "function" then I_ShutdownGraphics() end if

  _I_ExitProcess(0)
end function

/*
* Function: I_AllocLow
* Purpose: Allocates a zeroed byte buffer for legacy callers that expect low-memory storage.
*/
function I_AllocLow(length)

  return bytes(length)
end function

/*
* Function: I_Tactile
* Purpose: Accepts legacy force-feedback parameters; this backend deliberately performs no tactile output.
*/
function I_Tactile(on, off, total)

  on = 0
  off = 0
  total = 0
end function

/*
* Function: I_Error
* Purpose: Performs one-shot fatal shutdown, prints the diagnostic, releases subsystems, and terminates with a nonzero exit code.
*/
function I_Error(msg)
  shown = ""
  if typeof(msg) == "string" and msg != "" then
    shown = msg
  else
    shown = "<non-string error>"
  end if

  if typeof(msg) == "string" then
    print "Error: " + msg
  else
    print "Error: <non-string message, type=" + typeof(msg) + ">"
  end if

  low = _I_ToLowerAscii(shown)
  if _I_StrContains(low, "w_initfiles: no files found") or _I_StrContains(low, "no files found") then
    _I_ShowFatalErrorBox("No WAD file found." + "\n\n" + "Place Doom1.wad or Doom2.wad next to MiniDoom.exe" + "\n" + "or start with -iwad <path-to-wad>.")
  else
    _I_ShowFatalErrorBox(shown)
  end if

  if typeof(demorecording) != "void" and demorecording then
    if typeof(G_CheckDemoStatus) == "function" then
      G_CheckDemoStatus()
    end if
  end if

  if typeof(D_QuitNetGame) == "function" then D_QuitNetGame() end if
  if typeof(MP_PlatformShutdown) == "function" then MP_PlatformShutdown() end if
  if typeof(I_ShutdownGraphics) == "function" then I_ShutdownGraphics() end if

  _I_ExitProcess(1)
end function

mb_used = 6

/*
* Function: I_GetHeapSize
* Purpose: Converts the configured zone-heap size from mebibytes to bytes.
*/
function I_GetHeapSize()
  return mb_used * 1024 * 1024
end function

/*
* Function: I_WaitVBL
* Purpose: Sleeps for the requested number of 70 Hz vertical-blank intervals using millisecond platform timing.
*/
function I_WaitVBL(count)

  ms = count * 14
  _I_Sleep(ms)
end function

/*
* Function: I_BeginRead
* Purpose: Preserves the legacy disk-read activity hook; this backend requires no begin notification.
*/
function I_BeginRead()
end function

/*
* Function: I_EndRead
* Purpose: Preserves the legacy disk-read activity hook; this backend requires no end notification.
*/
function I_EndRead()
end function

/*
 * Function: GetTickCount
 *
 * Purpose: Returns Win32's millisecond count since system startup for Doom tic timing.
 */

extern function GetTickCount() from "kernel32.dll" returns u32

/*
 * Function: Sleep
 *
 * Purpose: Suspends the calling thread for at least the requested Win32 millisecond interval.
 */

extern function Sleep(ms as int) from "kernel32.dll" returns int

/*
 * Function: ExitProcess
 *
 * Purpose: Terminates the process immediately with the supplied operating-system exit code.
 */

extern function ExitProcess(code as int) from "kernel32.dll" returns int

_I_basetime = 0
_I_emptycmd = void

/*
* Function: _I_GetTickCount
* Purpose: Isolates the Win32 millisecond clock behind the engine's internal timing wrapper.
*/
function inline _I_GetTickCount()
  return GetTickCount()
end function

/*
* Function: _I_Sleep
* Purpose: Suspends the current thread for a non-negative millisecond duration through the Win32 scheduler.
*/
function inline _I_Sleep(ms)
  if typeof(ms) != "int" then return end if
  if ms < 0 then ms = 0 end if
  Sleep(ms)
end function

/*
* Function: _I_ExitProcess
* Purpose: Normalizes a non-integer exit status to failure and terminates through Win32.
*/
function inline _I_ExitProcess(code)
  if typeof(code) != "int" then code = 1 end if
  ExitProcess(code)
end function



