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

//! Runs moving and crushing ceiling thinkers, including active-slot tracking and tagged stasis control.

import z_zone
import doomdef
import p_local
import s_sound
import doomstat
import r_state
import sounds

/// Stores the activeceilings collection used by the p ceilng subsystem.
activeceilings =[]

/// Lazily creates the fixed-size active-ceiling slot table expected by tag and stasis operations.
/// @internal
function _InitActiveCeilings()
  global activeceilings

  if len(activeceilings) == MAXCEILINGS then return end if
  activeceilings =[]
  i = 0
  while i < MAXCEILINGS
    activeceilings = activeceilings +[void]
    i = i + 1
  end while
end function

/// Creates a ceiling-mover thinker with list links, callback, direction, speed, and sector state initialized
/// for activation.
/// @param fn Fn value supplied to `_CeilingMakeThinker`.
/// @internal
function inline _CeilingMakeThinker(fn)
  return thinker_t(void, void, actionf_t(fn, void, void), void)
end function

/// Rebuilds the active-ceiling sequence with one validated slot replaced, preserving list compatibility.
/// @param idx Zero-based element or table index.
/// @param v Value consumed by the operation.
/// @internal
function inline _CeilingSetSlot(idx, v)
  global activeceilings
  if typeof(activeceilings) != "array" then return end if
  if idx < 0 or idx >= len(activeceilings) then return end if
  left =[]
  if idx > 0 then left = slice(activeceilings, 0, idx) end if
  right =[]
  if idx + 1 < len(activeceilings) then
    right = slice(activeceilings, idx + 1, len(activeceilings) - idx - 1)
  end if
  activeceilings = left +[v] + right
end function

/// Places a ceiling mover in the first free active slot so tagged stop and resume events can find it.
/// @param c C value supplied to `P_AddActiveCeiling`.
function P_AddActiveCeiling(c)
  _InitActiveCeilings()
  i = 0
  while i < MAXCEILINGS
    if activeceilings[i] is void then
      activeceilings[i] = c
      return
    end if
    i = i + 1
  end while
end function

/// Clears the slot holding a completed ceiling mover so it no longer participates in tagged control.
/// @param c C value supplied to `P_RemoveActiveCeiling`.
function P_RemoveActiveCeiling(c)
  _InitActiveCeilings()
  i = 0
  while i < MAXCEILINGS
    if activeceilings[i] == c then
      _CeilingSetSlot(i, void)
      return
    end if
    i = i + 1
  end while
end function

/// Resumes every stopped ceiling matching a trigger tag by restoring its saved direction.
/// @param line Map line or text line affected by the operation.
function P_ActivateInStasisCeiling(line)
  if line is void then return end if
  _InitActiveCeilings()
  i = 0
  while i < MAXCEILINGS
    c = activeceilings[i]
    if c is not void and c.tag == line.tag and c.direction == 0 then
      c.direction = c.olddirection
    end if
    i = i + 1
  end while
end function

/// Puts every active ceiling with the trigger tag into stasis and reports whether any mover was stopped.
/// @param line Map line or text line affected by the operation.
function EV_CeilingCrushStop(line)

  if line is void then return 0 end if

  _InitActiveCeilings()
  stopped = 0
  i = 0
  while i < MAXCEILINGS
    c = activeceilings[i]
    if c is not void and c.tag == line.tag then
      c.olddirection = c.direction
      c.direction = 0
      stopped = 1
    end if
    i = i + 1
  end while

  return stopped
end function

/// Moves a ceiling toward its current bound, reverses cyclic crushers at endpoints, and removes one-shot movers
/// on completion.
/// @param ceiling Ceiling value supplied to `T_MoveCeiling`.
function T_MoveCeiling(ceiling)
  if ceiling is void or ceiling.sector is void then return end if

  if ceiling.direction > 0 then
    res = T_MovePlane(ceiling.sector, ceiling.speed, ceiling.topheight, ceiling.crush, 1, 1)
    if res == result_e.pastdest then

      if ceiling.type == ceiling_e.crushAndRaise or ceiling.type == ceiling_e.fastCrushAndRaise or ceiling.type == ceiling_e.silentCrushAndRaise then
        ceiling.direction = -1
      else
        if typeof(P_RemoveThinker) == "function" then P_RemoveThinker(ceiling.thinker) end if
        P_RemoveActiveCeiling(ceiling)
      end if
    end if

  else if ceiling.direction < 0 then
    res = T_MovePlane(ceiling.sector, ceiling.speed, ceiling.bottomheight, ceiling.crush, 1, -1)
    if res == result_e.pastdest then

      if ceiling.type == ceiling_e.crushAndRaise or ceiling.type == ceiling_e.fastCrushAndRaise or ceiling.type == ceiling_e.silentCrushAndRaise then
        ceiling.direction = 1
      else
        if typeof(P_RemoveThinker) == "function" then P_RemoveThinker(ceiling.thinker) end if
        P_RemoveActiveCeiling(ceiling)
      end if
    end if

  else

  end if
end function

/// Starts the requested ceiling action in every sector matching a trigger line's tag and reports whether any
/// mover was created.
/// @param line Map line or text line affected by the operation.
/// @param type Type value supplied to `EV_DoCeiling`.
function EV_DoCeiling(line, type)
  if line is void then return 0 end if

  secnum = -1
  started = 0

  loop
    secnum = P_FindSectorFromLineTag(line, secnum)
    if secnum < 0 then break end if

    sec = sectors[secnum]
    if sec is void then continue end if

    c = ceiling_t(_CeilingMakeThinker(T_MoveCeiling), type, sec, 0, 0, CEILSPEED, false, 0, line.tag, 0)

    if type == ceiling_e.lowerToFloor then
      c.direction = -1
      c.bottomheight = sec.floorheight
      c.speed = CEILSPEED

    else if type == ceiling_e.raiseToHighest then
      c.direction = 1
      c.topheight = P_FindHighestCeilingSurrounding(sec)
      c.speed = CEILSPEED

    else if type == ceiling_e.lowerAndCrush or type == ceiling_e.crushAndRaise or type == ceiling_e.fastCrushAndRaise then
      c.direction = -1
      c.bottomheight = sec.floorheight +(8 * FRACUNIT)
      c.crush = true
      c.speed = CEILSPEED
      if type == ceiling_e.fastCrushAndRaise then c.speed = CEILSPEED * 2 end if

    else

      c.direction = 0
    end if

    if typeof(P_RegisterThinkerOwner) == "function" then P_RegisterThinkerOwner(c.thinker, c) end if
    if typeof(P_AddThinker) == "function" then P_AddThinker(c.thinker) end if
    P_AddActiveCeiling(c)

    started = 1
    while true
    end loop

    return started
  end function



