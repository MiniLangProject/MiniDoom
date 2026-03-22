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

extern function MessageBoxW(hwnd as ptr, text as wstr, caption as wstr, flags as u32) from "user32.dll" symbol "MessageBoxW" returns int

const _IMAIN_MB_OK = 0x00000000
const _IMAIN_MB_ICONERROR = 0x00000010

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
* Purpose: Implements the main routine for the engine module behavior.
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
        errMsg = errMsg + "\n\nError code: " + runResult.code
      end if
      _IMain_ShowFatalError(errMsg)
      return 1
    end if
  end if

  return 0
end function



