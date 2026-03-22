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

  Script: p_plats.ml
  Purpose: Implements core gameplay simulation: map logic, physics, AI, and world interaction.
*/
import i_system
import z_zone
import m_random
import doomdef
import p_local
import s_sound
import doomstat
import r_state
import sounds

activeplats =[]

/*
* Function: _InitActivePlats
* Purpose: Initializes state and dependencies for the internal module support.
*/
function _InitActivePlats()
  global activeplats

  if len(activeplats) == MAXPLATS then return end if
  activeplats =[]
  i = 0
  while i < MAXPLATS
    activeplats = activeplats +[void]
    i = i + 1
  end while
end function

/*
* Function: _PlatMakeThinker
* Purpose: Advances per-tick logic for the internal module support.
*/
function inline _PlatMakeThinker(fn)
  return thinker_t(void, void, actionf_t(fn, void, void), void)
end function

/*
* Function: _PlatStartSound
* Purpose: Starts runtime behavior in the internal module support.
*/
function inline _PlatStartSound(origin, snd)
  if typeof(S_StartSound) == "function" then
    S_StartSound(origin, snd)
  end if
end function

/*
* Function: _PlatSoundOrg
* Purpose: Implements the _PlatSoundOrg routine for the internal module support.
*/
function inline _PlatSoundOrg(sec)
  if sec is void then return void end if
  return sec.soundorg
end function

/*
* Function: _PlatSetSlot
* Purpose: Reads or updates state used by the internal module support.
*/
function _PlatSetSlot(idx, v)
  global activeplats
  t = typeof(activeplats)
  if t != "array" and t != "list" then return end if
  n = len(activeplats)
  if idx < 0 or idx >= n then return end if

  rebuilt =[]
  i = 0
  while i < n
    if i == idx then
      rebuilt = rebuilt +[v]
    else
      rebuilt = rebuilt +[activeplats[i]]
    end if
    i = i + 1
  end while
  activeplats = rebuilt
end function

/*
* Function: _PlatFrontSector
* Purpose: Implements the _PlatFrontSector routine for the internal module support.
*/
function inline _PlatFrontSector(line)
  if line is void then return void end if
  if typeof(line.sidenum) != "array" or len(line.sidenum) == 0 then return void end if
  sn = line.sidenum[0]
  if typeof(sn) != "int" or sn < 0 then return void end if
  if typeof(sides) != "array" or sn >= len(sides) then return void end if
  if sides[sn] is void then return void end if
  return sides[sn].sector
end function

/*
* Function: P_AddActivePlat
* Purpose: Implements the P_AddActivePlat routine for the gameplay and world simulation.
*/
function P_AddActivePlat(plat)
  _InitActivePlats()

  i = 0
  while i < MAXPLATS
    if activeplats[i] is void then
      activeplats[i] = plat
      return
    end if
    i = i + 1
  end while

  I_Error("P_AddActivePlat: no more plats!")
end function

/*
* Function: P_RemoveActivePlat
* Purpose: Computes movement/collision behavior in the gameplay and world simulation.
*/
function P_RemoveActivePlat(plat)
  _InitActivePlats()

  i = 0
  while i < MAXPLATS
    if plat == activeplats[i] then
      if activeplats[i].sector is not void then
        activeplats[i].sector.specialdata = void
      end if
      if typeof(P_RemoveThinker) == "function" then
        P_RemoveThinker(activeplats[i].thinker)
      end if
      _PlatSetSlot(i, void)
      return
    end if
    i = i + 1
  end while

  I_Error("P_RemoveActivePlat: can't find plat!")
end function

/*
* Function: P_ActivateInStasis
* Purpose: Implements the P_ActivateInStasis routine for the gameplay and world simulation.
*/
function P_ActivateInStasis(tag)
  _InitActivePlats()

  i = 0
  while i < MAXPLATS
    p = activeplats[i]
    if p is not void and p.tag == tag and p.status == plat_e.in_stasis then
      p.status = p.oldstatus
      if p.thinker.func is void then
        p.thinker.func = actionf_t(T_PlatRaise, void, void)
      else
        p.thinker.func.acp1 = T_PlatRaise
      end if
    end if
    i = i + 1
  end while
end function

/*
* Function: EV_StopPlat
* Purpose: Stops or tears down runtime behavior in the engine module behavior.
*/
function EV_StopPlat(line)
  if line is void then return end if
  _InitActivePlats()

  j = 0
  while j < MAXPLATS
    p = activeplats[j]
    if p is not void and p.status != plat_e.in_stasis and p.tag == line.tag then
      p.oldstatus = p.status
      p.status = plat_e.in_stasis
      if p.thinker.func is void then
        p.thinker.func = actionf_t(void, void, void)
      else
        p.thinker.func.acp1 = void
      end if
    end if
    j = j + 1
  end while
end function

/*
* Function: T_PlatRaise
* Purpose: Implements the T_PlatRaise routine for the engine module behavior.
*/
function T_PlatRaise(plat)
  if plat is void or plat.sector is void then return end if

  switch plat.status
    case plat_e.up
      res = T_MovePlane(plat.sector, plat.speed, plat.high, plat.crush, 0, 1)

      if plat.type == plattype_e.raiseAndChange or plat.type == plattype_e.raiseToNearestAndChange then
        if (leveltime & 7) == 0 then
          _PlatStartSound(_PlatSoundOrg(plat.sector), sfxenum_t.sfx_stnmov)
        end if
      end if

      if res == result_e.crushed and(not plat.crush) then
        plat.count = plat.wait
        plat.status = plat_e.down
        _PlatStartSound(_PlatSoundOrg(plat.sector), sfxenum_t.sfx_pstart)
      else if res == result_e.pastdest then
        plat.count = plat.wait
        plat.status = plat_e.waiting
        _PlatStartSound(_PlatSoundOrg(plat.sector), sfxenum_t.sfx_pstop)

        switch plat.type
          case plattype_e.blazeDWUS, plattype_e.downWaitUpStay
            P_RemoveActivePlat(plat)
          end case

          case plattype_e.raiseAndChange, plattype_e.raiseToNearestAndChange
            P_RemoveActivePlat(plat)
          end case
        end switch
      end if
    end case

    case plat_e.down
      res = T_MovePlane(plat.sector, plat.speed, plat.low, false, 0, -1)
      if res == result_e.pastdest then
        plat.count = plat.wait
        plat.status = plat_e.waiting
        _PlatStartSound(_PlatSoundOrg(plat.sector), sfxenum_t.sfx_pstop)
      end if
    end case

    case plat_e.waiting
      plat.count = plat.count - 1
      if plat.count == 0 then
        if plat.sector.floorheight == plat.low then
          plat.status = plat_e.up
        else
          plat.status = plat_e.down
        end if
        _PlatStartSound(_PlatSoundOrg(plat.sector), sfxenum_t.sfx_pstart)
      end if
    end case

    case plat_e.in_stasis

    end case
  end switch
end function

/*
* Function: EV_DoPlat
* Purpose: Implements the EV_DoPlat routine for the engine module behavior.
*/
function EV_DoPlat(line, type, amount)
  if line is void then return 0 end if

  secnum = -1
  rtn = 0

  switch type
    case plattype_e.perpetualRaise
      P_ActivateInStasis(line.tag)
    end case
  end switch

  loop
    secnum = P_FindSectorFromLineTag(line, secnum)
    if secnum < 0 then break end if

    sec = sectors[secnum]
    if sec is void then continue end if
    if sec.specialdata is not void then continue end if

    rtn = 1
    plat = plat_t(_PlatMakeThinker(T_PlatRaise), sec, 0, 0, 0, 0, 0, plat_e.up, plat_e.up, false, line.tag, type)
    sec.specialdata = plat
    if typeof(P_RegisterThinkerOwner) == "function" then P_RegisterThinkerOwner(plat.thinker, plat) end if
    if typeof(P_AddThinker) == "function" then P_AddThinker(plat.thinker) end if

    plat.type = type
    plat.sector = sec
    plat.crush = false
    plat.tag = line.tag

    switch type
      case plattype_e.raiseToNearestAndChange
        plat.speed = PLATSPEED >> 1

        fsec = _PlatFrontSector(line)
        if fsec is not void then sec.floorpic = fsec.floorpic end if

        plat.high = P_FindNextHighestFloor(sec, sec.floorheight)
        plat.wait = 0
        plat.status = plat_e.up

        sec.special = 0

        _PlatStartSound(_PlatSoundOrg(sec), sfxenum_t.sfx_stnmov)
      end case

      case plattype_e.raiseAndChange
        plat.speed = PLATSPEED >> 1

        fsec = _PlatFrontSector(line)
        if fsec is not void then sec.floorpic = fsec.floorpic end if

        plat.high = sec.floorheight + amount * FRACUNIT
        plat.wait = 0
        plat.status = plat_e.up

        _PlatStartSound(_PlatSoundOrg(sec), sfxenum_t.sfx_stnmov)
      end case

      case plattype_e.downWaitUpStay
        plat.speed = PLATSPEED * 4
        plat.low = P_FindLowestFloorSurrounding(sec)
        if plat.low > sec.floorheight then
          plat.low = sec.floorheight
        end if

        plat.high = sec.floorheight
        plat.wait = 35 * PLATWAIT
        plat.status = plat_e.down
        _PlatStartSound(_PlatSoundOrg(sec), sfxenum_t.sfx_pstart)
      end case

      case plattype_e.blazeDWUS
        plat.speed = PLATSPEED * 8
        plat.low = P_FindLowestFloorSurrounding(sec)
        if plat.low > sec.floorheight then
          plat.low = sec.floorheight
        end if

        plat.high = sec.floorheight
        plat.wait = 35 * PLATWAIT
        plat.status = plat_e.down
        _PlatStartSound(_PlatSoundOrg(sec), sfxenum_t.sfx_pstart)
      end case

      case plattype_e.perpetualRaise
        plat.speed = PLATSPEED
        plat.low = P_FindLowestFloorSurrounding(sec)
        if plat.low > sec.floorheight then
          plat.low = sec.floorheight
        end if

        plat.high = P_FindHighestFloorSurrounding(sec)
        if plat.high < sec.floorheight then
          plat.high = sec.floorheight
        end if

        plat.wait = 35 * PLATWAIT
        plat.status = P_Random() & 1

        _PlatStartSound(_PlatSoundOrg(sec), sfxenum_t.sfx_pstart)
      end case
    end switch

    P_AddActivePlat(plat)
    while true
    end loop

    return rtn
  end function



