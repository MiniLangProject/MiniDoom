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

//! Implements sector fire-flicker, flash, strobe, glow, and tagged lighting effects as thinkers.

import z_zone
import m_random
import doomdef
import p_local
import r_state

/// Constructs an unlinked thinker node whose primary callback drives a sector lighting effect.
/// @param acp1 Acp1 value supplied to `_P_MakeThinker`.
/// @internal
function inline _P_MakeThinker(acp1)

  return thinker_t(void, void, actionf_t(acp1, void, void), void)
end function

/// Registers a lighting thinker when the full thinker list API is present, allowing reduced test harnesses to
/// omit it.
/// @param th Th value supplied to `_P_AddThinkerIfPossible`.
/// @internal
function inline _P_AddThinkerIfPossible(th)
  if typeof(P_AddThinker) == "function" then
    P_AddThinker(th)
  end if
end function

/// Every four tics chooses a randomized fire brightness no darker than the sector's neighboring minimum.
/// @param flick Flick value supplied to `T_FireFlicker`.
function T_FireFlicker(flick)
  if flick is void or flick.sector is void then return end if

  if flick.count > 0 then
    flick.count = flick.count - 1
    return
  end if

  amount = 16
  if typeof(P_Random) == "function" then
    amount =(P_Random() & 3) * 16
  end if

  newlight = flick.maxlight - amount
  if newlight < flick.minlight then newlight = flick.minlight end if
  flick.sector.lightlevel = newlight

  flick.count = 4
end function

/// Attaches a fire-flicker thinker using the sector's current light as maximum and its darkest neighbor as
/// minimum.
/// @param sector Map sector affected by the operation.
function P_SpawnFireFlicker(sector)
  if sector is void then return end if

  t = fireflicker_t(_P_MakeThinker(T_FireFlicker), sector, 4, sector.lightlevel, 0)
  t.minlight = P_FindMinSurroundingLight(sector, sector.lightlevel)
  t.maxlight = sector.lightlevel
  if typeof(P_RegisterThinkerOwner) == "function" then P_RegisterThinkerOwner(t.thinker, t) end if

  _P_AddThinkerIfPossible(t.thinker)
end function

/// Alternates a sector between its bright and dark levels using randomized flash durations.
/// @param flash Flash value supplied to `T_LightFlash`.
function T_LightFlash(flash)
  if flash is void or flash.sector is void then return end if

  if flash.count > 0 then
    flash.count = flash.count - 1
    return
  end if

  if flash.sector.lightlevel == flash.maxlight then
    flash.sector.lightlevel = flash.minlight

    flash.count = flash.mintime
    if typeof(P_Random) == "function" then flash.count =(P_Random() & flash.mintime) + 1 end if
  else
    flash.sector.lightlevel = flash.maxlight
    flash.count = flash.maxtime
    if typeof(P_Random) == "function" then flash.count =(P_Random() & flash.maxtime) + 1 end if
  end if
end function

/// Attaches a randomized two-level flash thinker bounded by the sector's original and darkest neighboring
/// light.
/// @param sector Map sector affected by the operation.
function P_SpawnLightFlash(sector)
  if sector is void then return end if

  f = lightflash_t(_P_MakeThinker(T_LightFlash), sector, 0, sector.lightlevel, 0, 64, 7)
  f.minlight = P_FindMinSurroundingLight(sector, sector.lightlevel)
  f.maxlight = sector.lightlevel

  f.count = 1
  if typeof(P_Random) == "function" then f.count =(P_Random() & f.maxtime) + 1 end if
  if typeof(P_RegisterThinkerOwner) == "function" then P_RegisterThinkerOwner(f.thinker, f) end if

  _P_AddThinkerIfPossible(f.thinker)
end function

/// Advances a sector strobe between minimum and maximum light levels with independent bright and dark
/// intervals.
/// @param flash Flash value supplied to `T_StrobeFlash`.
function T_StrobeFlash(flash)
  if flash is void or flash.sector is void then return end if

  if flash.count > 0 then
    flash.count = flash.count - 1
    return
  end if

  if flash.sector.lightlevel == flash.minlight then
    flash.sector.lightlevel = flash.maxlight
    flash.count = flash.brighttime
  else
    flash.sector.lightlevel = flash.minlight
    flash.count = flash.darktime
  end if
end function

/// Attaches a fast or slow strobe thinker, optionally synchronizing its initial countdown with peer sectors.
/// @param sector Map sector affected by the operation.
/// @param fastOrSlow Fast or slow value supplied to `P_SpawnStrobeFlash`.
/// @param inSync In sync value supplied to `P_SpawnStrobeFlash`.
function P_SpawnStrobeFlash(sector, fastOrSlow, inSync)
  if sector is void then return end if

  st = strobe_t(_P_MakeThinker(T_StrobeFlash), sector, 0, 0, sector.lightlevel, 0, 0)
  st.minlight = P_FindMinSurroundingLight(sector, sector.lightlevel)
  st.maxlight = sector.lightlevel

  if st.minlight == st.maxlight then st.minlight = 0 end if

  if fastOrSlow != 0 then
    st.darktime = FASTDARK
    st.brighttime = STROBEBRIGHT
  else
    st.darktime = SLOWDARK
    st.brighttime = STROBEBRIGHT
  end if

  if inSync != 0 then
    st.count = 1
  else
    st.count = 1
    if typeof(P_Random) == "function" then st.count =(P_Random() & 7) + 1 end if
  end if

  sector.lightlevel = st.maxlight
  if typeof(P_RegisterThinkerOwner) == "function" then P_RegisterThinkerOwner(st.thinker, st) end if
  _P_AddThinkerIfPossible(st.thinker)
end function

/// Adds unsynchronized slow strobe thinkers to every sector carrying the trigger line's tag.
/// @param line Map line or text line affected by the operation.
function EV_StartLightStrobing(line)

  if line is void then return end if

  secnum = -1
  loop
    secnum = P_FindSectorFromLineTag(line, secnum)
    if secnum < 0 then break end if
    P_SpawnStrobeFlash(sectors[secnum], 0, 0)
    while true
    end loop
  end function

  /// Sets every tagged sector to the darkest light level found in its neighboring sectors.
  /// @param line Map line or text line affected by the operation.
  function EV_TurnTagLightsOff(line)
    if line is void then return end if
    secnum = -1
    loop
      secnum = P_FindSectorFromLineTag(line, secnum)
      if secnum < 0 then break end if
      s = sectors[secnum]
      if s is void then continue end if
      s.lightlevel = P_FindMinSurroundingLight(s, s.lightlevel)
      while true
      end loop
    end function

    /// Sets tagged sectors to an explicit brightness or, when zero is requested, their brightest neighboring
    /// level.
    /// @param line Map line or text line affected by the operation.
    /// @param bright Bright value supplied to `EV_LightTurnOn`.
    function EV_LightTurnOn(line, bright)
      if line is void then return end if

      secnum = -1
      loop
        secnum = P_FindSectorFromLineTag(line, secnum)
        if secnum < 0 then break end if
        s = sectors[secnum]
        if s is void then continue end if
        if bright == 0 then
          s.lightlevel = s.lightlevel
        else
          s.lightlevel = bright
        end if
        while true
        end loop
      end function

      /// Smoothly oscillates a sector's light level between neighboring minimum and maximum bounds.
      /// @param g G value supplied to `T_Glow`.
      function T_Glow(g)
        if g is void or g.sector is void then return end if

        if g.direction > 0 then
          g.sector.lightlevel = g.sector.lightlevel + GLOWSPEED
          if g.sector.lightlevel >= g.maxlight then
            g.sector.lightlevel = g.maxlight
            g.direction = -1
          end if
        else
          g.sector.lightlevel = g.sector.lightlevel - GLOWSPEED
          if g.sector.lightlevel <= g.minlight then
            g.sector.lightlevel = g.minlight
            g.direction = 1
          end if
        end if
      end function

      /// Attaches a glow thinker that begins dimming from the sector's current light toward its darkest
      /// neighbor.
      /// @param sector Map sector affected by the operation.
      function P_SpawnGlowingLight(sector)
        if sector is void then return end if

        g = glow_t(_P_MakeThinker(T_Glow), sector, 0, sector.lightlevel, 1)
        g.minlight = P_FindMinSurroundingLight(sector, sector.lightlevel)
        g.maxlight = sector.lightlevel
        g.direction = -1
        if typeof(P_RegisterThinkerOwner) == "function" then P_RegisterThinkerOwner(g.thinker, g) end if

        _P_AddThinkerIfPossible(g.thinker)
      end function



