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

  Script: p_lights.ml
  Purpose: Implements core gameplay simulation: map logic, physics, AI, and world interaction.
*/
import z_zone
import m_random
import doomdef
import p_local
import r_state

/*
* Function: _P_MakeThinker
* Purpose: Advances per-tick logic for the internal module support.
*/
function _P_MakeThinker(acp1)

  return thinker_t(void, void, actionf_t(acp1, void, void), void)
end function

/*
* Function: _P_AddThinkerIfPossible
* Purpose: Advances per-tick logic for the internal module support.
*/
function _P_AddThinkerIfPossible(th)
  if typeof(P_AddThinker) == "function" then
    P_AddThinker(th)
  end if
end function

/*
* Function: T_FireFlicker
* Purpose: Implements the T_FireFlicker routine for the engine module behavior.
*/
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

/*
* Function: P_SpawnFireFlicker
* Purpose: Creates and initializes runtime objects for the gameplay and world simulation.
*/
function P_SpawnFireFlicker(sector)
  if sector is void then return end if

  t = fireflicker_t(_P_MakeThinker(T_FireFlicker), sector, 4, sector.lightlevel, 0)
  t.minlight = P_FindMinSurroundingLight(sector, sector.lightlevel)
  t.maxlight = sector.lightlevel
  if typeof(P_RegisterThinkerOwner) == "function" then P_RegisterThinkerOwner(t.thinker, t) end if

  _P_AddThinkerIfPossible(t.thinker)
end function

/*
* Function: T_LightFlash
* Purpose: Implements the T_LightFlash routine for the engine module behavior.
*/
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

/*
* Function: P_SpawnLightFlash
* Purpose: Creates and initializes runtime objects for the gameplay and world simulation.
*/
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

/*
* Function: T_StrobeFlash
* Purpose: Implements the T_StrobeFlash routine for the engine module behavior.
*/
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

/*
* Function: P_SpawnStrobeFlash
* Purpose: Creates and initializes runtime objects for the gameplay and world simulation.
*/
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

/*
* Function: EV_StartLightStrobing
* Purpose: Starts runtime behavior in the engine module behavior.
*/
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

  /*
  * Function: EV_TurnTagLightsOff
  * Purpose: Implements the EV_TurnTagLightsOff routine for the engine module behavior.
  */
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

    /*
    * Function: EV_LightTurnOn
    * Purpose: Implements the EV_LightTurnOn routine for the engine module behavior.
    */
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

      /*
      * Function: T_Glow
      * Purpose: Implements the T_Glow routine for the engine module behavior.
      */
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

      /*
      * Function: P_SpawnGlowingLight
      * Purpose: Creates and initializes runtime objects for the gameplay and world simulation.
      */
      function P_SpawnGlowingLight(sector)
        if sector is void then return end if

        g = glow_t(_P_MakeThinker(T_Glow), sector, 0, sector.lightlevel, 1)
        g.minlight = P_FindMinSurroundingLight(sector, sector.lightlevel)
        g.maxlight = sector.lightlevel
        g.direction = -1
        if typeof(P_RegisterThinkerOwner) == "function" then P_RegisterThinkerOwner(g.thinker, g) end if

        _P_AddThinkerIfPossible(g.thinker)
      end function



