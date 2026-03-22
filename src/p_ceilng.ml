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

  Script: p_ceilng.ml
  Purpose: Implements core gameplay simulation: map logic, physics, AI, and world interaction.
*/
import z_zone
import doomdef
import p_local
import s_sound
import doomstat
import r_state
import sounds

activeceilings =[]

/*
* Function: _InitActiveCeilings
* Purpose: Initializes state and dependencies for the internal module support.
*/
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

/*
* Function: _CeilingMakeThinker
* Purpose: Advances per-tick logic for the internal module support.
*/
function inline _CeilingMakeThinker(fn)
  return thinker_t(void, void, actionf_t(fn, void, void), void)
end function

/*
* Function: _CeilingSetSlot
* Purpose: Reads or updates state used by the internal module support.
*/
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

/*
* Function: P_AddActiveCeiling
* Purpose: Implements the P_AddActiveCeiling routine for the gameplay and world simulation.
*/
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

/*
* Function: P_RemoveActiveCeiling
* Purpose: Computes movement/collision behavior in the gameplay and world simulation.
*/
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

/*
* Function: P_ActivateInStasisCeiling
* Purpose: Implements the P_ActivateInStasisCeiling routine for the gameplay and world simulation.
*/
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

/*
* Function: EV_CeilingCrushStop
* Purpose: Stops or tears down runtime behavior in the engine module behavior.
*/
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

/*
* Function: T_MoveCeiling
* Purpose: Computes movement/collision behavior in the engine module behavior.
*/
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

/*
* Function: EV_DoCeiling
* Purpose: Implements the EV_DoCeiling routine for the engine module behavior.
*/
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



