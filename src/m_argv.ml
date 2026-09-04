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

//! Owns the process argument vector and implements Doom-style case-insensitive option lookup.


/// Tracks the mutable myargc value used by the m argv subsystem.
myargc = 0
/// Holds the optional myargv resource used by the m argv subsystem.
myargv = void

/// Rebuilds Doom's global argv with the executable name at index zero and records the resulting count.
/// @param progName Prog name value supplied to `M_SetArgv`.
/// @param args Args value supplied to `M_SetArgv`.
function M_SetArgv(progName, args)
  global myargv
  global myargc

  if typeof(args) != "array" then
    myargv =[progName]
    myargc = 1
    return
  end if

  myargv =[progName] + args
  myargc = len(myargv)
end function

/// Returns the first case-insensitive option index after argv[0], reserving zero to mean absent.
/// @param check Check value supplied to `M_CheckParm`.
function M_CheckParm(check)
  i = 1
  while i < myargc
    if _M_StrCaseEq(check, myargv[i]) then
      return i
    end if
    i = i + 1
  end while
  return 0
end function

/// Folds one uppercase ASCII byte to lowercase while leaving all other bytes unchanged.
/// @param c C value supplied to `_M_ToLowerAscii`.
/// @internal
function inline _M_ToLowerAscii(c)
  if c >= 65 and c <= 90 then return c + 32 end if
  return c
end function

/// Compares two ASCII strings case-insensitively without allocating normalized copies.
/// @param a First input operand.
/// @param b Second input operand.
/// @internal
function _M_StrCaseEq(a, b)
  if typeof(a) != "string" or typeof(b) != "string" then return false end if
  ba = bytes(a)
  bb = bytes(b)
  if len(ba) != len(bb) then return false end if

  i = 0
  while i < len(ba)
    ca = _M_ToLowerAscii(ba[i])
    cb = _M_ToLowerAscii(bb[i])
    if ca != cb then
      return false
    end if
    i = i + 1
  end while

  return true
end function



