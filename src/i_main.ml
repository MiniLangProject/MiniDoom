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

  Script: i_main.ml
  Purpose: Implements platform integration for input, timing, video, audio, and OS services.
*/
import doomdef
import m_argv
import d_main
import std.fs as fs
import std.math

/*
 * Function: MessageBoxW
 *
 * Purpose: Maps the external MessageBoxW binding used for platform integration.
 */

extern function MessageBoxW(hwnd as ptr, text as wstr, caption as wstr, flags as u32) from "user32.dll" symbol "MessageBoxW" returns int

const _IMAIN_MB_OK = 0x00000000
const _IMAIN_MB_ICONERROR = 0x00000010

/*
* Function: _IMain_IntToString
* Purpose: Runs the main platform entry point.
*/
function _IMain_IntToString(v)
  n = 0
  if typeof(v) == "int" then n = v end if
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
    n = std.math.floor(n / 10)
  end while
  if neg then txt = "-" + txt end if
  return txt
end function

/*
* Function: _IMain_ShowFatalError
* Purpose: Shows a fatal startup/runtime error in a GUI message box for windows-subsystem builds.
*/
function inline _IMain_ShowFatalError(msg)
  txt = msg
  if typeof(txt) != "string" or txt == "" then
    txt = "MiniDoom crashed with an unknown error."
  end if

  if typeof(MessageBoxW) == "function" then
    _ = MessageBoxW(0, txt, "MiniDoom - Fatal Error", _IMAIN_MB_OK | _IMAIN_MB_ICONERROR)
  else
    print txt
  end if
end function

/*
* Function: main
* Purpose: Runs the main platform entry point.
*/
function main(args)

  if typeof(M_SetArgv) == "function" then
    M_SetArgv("doom", args)
  else

    myargv =["doom"] + args
    myargc = len(myargv)
  end if

  if typeof(D_DoomMain) == "function" then
    runResult = try(D_DoomMain())
    if typeof(runResult) == "error" then
      errMsg = "MiniDoom crashed."
      if typeof(runResult.message) == "string" and runResult.message != "" then
        errMsg = errMsg + "\n\n" + runResult.message
      end if
      if typeof(runResult.code) == "int" then
        errMsg = errMsg + "\n\nError code: " + _IMain_IntToString(runResult.code)
      end if
      if typeof(runResult.script) == "string" and runResult.script != "" then
        errMsg = errMsg + "\n\nScript: " + runResult.script
      end if
      if typeof(runResult.func) == "string" and runResult.func != "" then
        errMsg = errMsg + "\nFunction: " + runResult.func
      end if
      if typeof(runResult.line) == "int" and runResult.line > 0 then
        errMsg = errMsg + "\nLine: " + _IMain_IntToString(runResult.line)
      end if
      _ = fs.writeAllText("last_crash.txt", errMsg)
      _IMain_ShowFatalError(errMsg)
      return 1
    end if
  end if

  return 0
end function



