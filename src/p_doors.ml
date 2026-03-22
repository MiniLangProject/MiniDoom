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

  Script: p_doors.ml
  Purpose: Implements core gameplay simulation: map logic, physics, AI, and world interaction.
*/
import z_zone
import doomdef
import p_local
import s_sound
import doomstat
import r_state
import dstrings
import sounds

/*
* Function: _DoorsMakeThinker
* Purpose: Advances per-tick logic for the internal module support.
*/
function inline _DoorsMakeThinker(fn)
  return thinker_t(void, void, actionf_t(fn, void, void), void)
end function

/*
* Function: _DoorsAddThinkerIfPossible
* Purpose: Advances per-tick logic for the internal module support.
*/
function inline _DoorsAddThinkerIfPossible(th)
  if typeof(P_AddThinker) == "function" then P_AddThinker(th) end if
end function

/*
* Function: _DoorsStartSound
* Purpose: Starts runtime behavior in the internal module support.
*/
function inline _DoorsStartSound(origin, snd)
  if typeof(S_StartSound) == "function" then
    S_StartSound(origin, snd)
  end if
end function

/*
* Function: _DoorsSoundOrg
* Purpose: Implements the _DoorsSoundOrg routine for the internal module support.
*/
function inline _DoorsSoundOrg(sec)
  if sec is void then return void end if
  return sec.soundorg
end function

/*
* Function: _DoorsIsSeq
* Purpose: Implements the _DoorsIsSeq routine for the internal module support.
*/
function inline _DoorsIsSeq(v)
  t = typeof(v)
  return t == "array" or t == "list"
end function

/*
* Function: _DoorsHasCard
* Purpose: Implements the _DoorsHasCard routine for the internal module support.
*/
function _DoorsHasCard(player, card)
  if player is void then return false end if
  if not _DoorsIsSeq(player.cards) then return false end if

  idx = -1
  if typeof(card) == "int" then
    idx = card
  else
    n = toNumber(card)
    if typeof(n) == "int" then
      idx = n
    else if typeof(card) == "enum" then
      i = 0
      while i < len(player.cards)
        if card == i then
          idx = i
          break
        end if
        i = i + 1
      end while
    end if
  end if

  if idx < 0 or idx >= len(player.cards) then return false end if

  v = player.cards[idx]
  if typeof(v) == "int" then return v != 0 end if
  if typeof(v) == "float" then return v != 0 end if
  if typeof(v) == "bool" then return v end if
  if v then return true end if
  return false
end function

/*
* Function: _DoorsBackSector
* Purpose: Implements the _DoorsBackSector routine for the internal module support.
*/
function inline _DoorsBackSector(line)
  if line is void then return void end if
  if line.backsector is not void then return line.backsector end if
  if not _DoorsIsSeq(line.sidenum) then return void end if
  if len(line.sidenum) < 2 then return void end if

  backsn = line.sidenum[1]
  if typeof(backsn) != "int" or backsn < 0 then return void end if
  if not _DoorsIsSeq(sides) or backsn >= len(sides) then return void end if
  if sides[backsn] is void then return void end if
  return sides[backsn].sector
end function

/*
* Function: T_VerticalDoor
* Purpose: Implements the T_VerticalDoor routine for the engine module behavior.
*/
function T_VerticalDoor(door)
  if door is void or door.sector is void then return end if

  switch door.direction
    case 0

      door.topcountdown = door.topcountdown - 1
      if door.topcountdown == 0 then
        switch door.type
          case vldoor_e.blazeRaise
            door.direction = -1
            _DoorsStartSound(_DoorsSoundOrg(door.sector), sfxenum_t.sfx_bdcls)
          end case

          case vldoor_e.normal
            door.direction = -1
            _DoorsStartSound(_DoorsSoundOrg(door.sector), sfxenum_t.sfx_dorcls)
          end case

          case vldoor_e.close30ThenOpen
            door.direction = 1
            _DoorsStartSound(_DoorsSoundOrg(door.sector), sfxenum_t.sfx_doropn)
          end case
        end switch
      end if
      return
    end case

    case 2

      door.topcountdown = door.topcountdown - 1
      if door.topcountdown == 0 then
        if door.type == vldoor_e.raiseIn5Mins then
          door.direction = 1
          door.type = vldoor_e.normal
          _DoorsStartSound(_DoorsSoundOrg(door.sector), sfxenum_t.sfx_doropn)
        end if
      end if
      return
    end case

    case -1

      res = T_MovePlane(door.sector, door.speed, door.sector.floorheight, false, 1, door.direction)
      if res == result_e.pastdest then
        switch door.type
          case vldoor_e.blazeRaise, vldoor_e.blazeClose
            door.sector.specialdata = void
            if typeof(P_RemoveThinker) == "function" then P_RemoveThinker(door.thinker) end if
            _DoorsStartSound(_DoorsSoundOrg(door.sector), sfxenum_t.sfx_bdcls)
          end case

          case vldoor_e.normal, vldoor_e.close
            door.sector.specialdata = void
            if typeof(P_RemoveThinker) == "function" then P_RemoveThinker(door.thinker) end if
          end case

          case vldoor_e.close30ThenOpen
            door.direction = 0
            door.topcountdown = 35 * 30
          end case
        end switch
      else if res == result_e.crushed then
        switch door.type
          case vldoor_e.blazeClose, vldoor_e.close

          end case

          case default
            door.direction = 1
            _DoorsStartSound(_DoorsSoundOrg(door.sector), sfxenum_t.sfx_doropn)
          end case
        end switch
      end if
      return
    end case

    case 1

      res = T_MovePlane(door.sector, door.speed, door.topheight, false, 1, door.direction)
      if res == result_e.pastdest then
        switch door.type
          case vldoor_e.blazeRaise, vldoor_e.normal
            door.direction = 0
            door.topcountdown = door.topwait
          end case

          case vldoor_e.close30ThenOpen, vldoor_e.blazeOpen, vldoor_e.open
            door.sector.specialdata = void
            if typeof(P_RemoveThinker) == "function" then P_RemoveThinker(door.thinker) end if
          end case
        end switch
      end if
      return
    end case
  end switch
end function

/*
* Function: EV_DoLockedDoor
* Purpose: Implements the EV_DoLockedDoor routine for the engine module behavior.
*/
function EV_DoLockedDoor(line, type, thing)
  if line is void or thing is void then return 0 end if

  p = thing.player
  if p is void then return 0 end if

  switch line.special
    case 99, 133
      if (not _DoorsHasCard(p, it_bluecard)) and(not _DoorsHasCard(p, it_blueskull)) then
        p.message = PD_BLUEO
        _DoorsStartSound(void, sfxenum_t.sfx_oof)
        return 0
      end if
    end case

    case 134, 135
      if (not _DoorsHasCard(p, it_redcard)) and(not _DoorsHasCard(p, it_redskull)) then
        p.message = PD_REDO
        _DoorsStartSound(void, sfxenum_t.sfx_oof)
        return 0
      end if
    end case

    case 136, 137
      if (not _DoorsHasCard(p, it_yellowcard)) and(not _DoorsHasCard(p, it_yellowskull)) then
        p.message = PD_YELLOWO
        _DoorsStartSound(void, sfxenum_t.sfx_oof)
        return 0
      end if
    end case
  end switch

  return EV_DoDoor(line, type)
end function

/*
* Function: EV_DoDoor
* Purpose: Implements the EV_DoDoor routine for the engine module behavior.
*/
function EV_DoDoor(line, type)
  if line is void then return 0 end if

  secnum = -1
  rtn = 0

  loop
    secnum = P_FindSectorFromLineTag(line, secnum)
    if secnum < 0 then break end if

    sec = sectors[secnum]
    if sec is void then continue end if
    if sec.specialdata is not void then continue end if

    rtn = 1
    door = vldoor_t(_DoorsMakeThinker(T_VerticalDoor), type, sec, 0, VDOORSPEED, 0, VDOORWAIT, 0)
    sec.specialdata = door
    if typeof(P_RegisterThinkerOwner) == "function" then P_RegisterThinkerOwner(door.thinker, door) end if
    _DoorsAddThinkerIfPossible(door.thinker)

    door.topwait = VDOORWAIT
    door.speed = VDOORSPEED

    switch type
      case vldoor_e.blazeClose
        door.topheight = P_FindLowestCeilingSurrounding(sec) - 4 * FRACUNIT
        door.direction = -1
        door.speed = VDOORSPEED * 4
        _DoorsStartSound(_DoorsSoundOrg(door.sector), sfxenum_t.sfx_bdcls)
      end case

      case vldoor_e.close
        door.topheight = P_FindLowestCeilingSurrounding(sec) - 4 * FRACUNIT
        door.direction = -1
        _DoorsStartSound(_DoorsSoundOrg(door.sector), sfxenum_t.sfx_dorcls)
      end case

      case vldoor_e.close30ThenOpen
        door.topheight = sec.ceilingheight
        door.direction = -1
        _DoorsStartSound(_DoorsSoundOrg(door.sector), sfxenum_t.sfx_dorcls)
      end case

      case vldoor_e.blazeRaise, vldoor_e.blazeOpen
        door.direction = 1
        door.topheight = P_FindLowestCeilingSurrounding(sec) - 4 * FRACUNIT
        door.speed = VDOORSPEED * 4
        if door.topheight != sec.ceilingheight then
          _DoorsStartSound(_DoorsSoundOrg(door.sector), sfxenum_t.sfx_bdopn)
        end if
      end case

      case vldoor_e.normal, vldoor_e.open
        door.direction = 1
        door.topheight = P_FindLowestCeilingSurrounding(sec) - 4 * FRACUNIT
        if door.topheight != sec.ceilingheight then
          _DoorsStartSound(_DoorsSoundOrg(door.sector), sfxenum_t.sfx_doropn)
        end if
      end case
    end switch
    while true
    end loop

    return rtn
  end function

  /*
  * Function: EV_VerticalDoor
  * Purpose: Implements the EV_VerticalDoor routine for the engine module behavior.
  */
  function EV_VerticalDoor(line, thing)
    if line is void then return end if

    player = void
    if thing is not void then player = thing.player end if

    switch line.special
      case 26, 32
        if player is void then return end if
        if (not _DoorsHasCard(player, it_bluecard)) and(not _DoorsHasCard(player, it_blueskull)) then
          player.message = PD_BLUEK
          _DoorsStartSound(void, sfxenum_t.sfx_oof)
          return
        end if
      end case

      case 27, 34
        if player is void then return end if
        if (not _DoorsHasCard(player, it_yellowcard)) and(not _DoorsHasCard(player, it_yellowskull)) then
          player.message = PD_YELLOWK
          _DoorsStartSound(void, sfxenum_t.sfx_oof)
          return
        end if
      end case

      case 28, 33
        if player is void then return end if
        if (not _DoorsHasCard(player, it_redcard)) and(not _DoorsHasCard(player, it_redskull)) then
          player.message = PD_REDK
          _DoorsStartSound(void, sfxenum_t.sfx_oof)
          return
        end if
      end case
    end switch

    sec = _DoorsBackSector(line)
    if sec is void then return end if

    if sec.specialdata is not void then
      door = sec.specialdata
      switch line.special
        case 1, 26, 27, 28, 117
          if door.direction == -1 then
            door.direction = 1
          else
            if thing is void or thing.player is void then return end if
            door.direction = -1
          end if
          return
        end case
      end switch
    end if

    switch line.special
      case 117, 118
        _DoorsStartSound(_DoorsSoundOrg(sec), sfxenum_t.sfx_bdopn)
      end case

      case 1, 31
        _DoorsStartSound(_DoorsSoundOrg(sec), sfxenum_t.sfx_doropn)
      end case

      case default
        _DoorsStartSound(_DoorsSoundOrg(sec), sfxenum_t.sfx_doropn)
      end case
    end switch

    door = vldoor_t(_DoorsMakeThinker(T_VerticalDoor), vldoor_e.normal, sec, 0, VDOORSPEED, 1, VDOORWAIT, 0)
    sec.specialdata = door
    if typeof(P_RegisterThinkerOwner) == "function" then P_RegisterThinkerOwner(door.thinker, door) end if
    _DoorsAddThinkerIfPossible(door.thinker)

    switch line.special
      case 1, 26, 27, 28
        door.type = vldoor_e.normal
      end case

      case 31, 32, 33, 34
        door.type = vldoor_e.open
        line.special = 0
      end case

      case 117
        door.type = vldoor_e.blazeRaise
        door.speed = VDOORSPEED * 4
      end case

      case 118
        door.type = vldoor_e.blazeOpen
        line.special = 0
        door.speed = VDOORSPEED * 4
      end case
    end switch

    door.topheight = P_FindLowestCeilingSurrounding(sec) -(4 * FRACUNIT)
  end function

  /*
  * Function: P_SpawnDoorCloseIn30
  * Purpose: Creates and initializes runtime objects for the gameplay and world simulation.
  */
  function P_SpawnDoorCloseIn30(sec)
    if sec is void then return end if

    door = vldoor_t(_DoorsMakeThinker(T_VerticalDoor), vldoor_e.normal, sec, 0, VDOORSPEED, 0, VDOORWAIT, 30 * TICRATE)
    sec.specialdata = door
    sec.special = 0
    if typeof(P_RegisterThinkerOwner) == "function" then P_RegisterThinkerOwner(door.thinker, door) end if
    _DoorsAddThinkerIfPossible(door.thinker)

    door.direction = 0
    door.type = vldoor_e.normal
    door.speed = VDOORSPEED
    door.topcountdown = 30 * 35
  end function

  /*
  * Function: P_SpawnDoorRaiseIn5Mins
  * Purpose: Creates and initializes runtime objects for the gameplay and world simulation.
  */
  function P_SpawnDoorRaiseIn5Mins(sec, secnum)
    secnum = secnum
    if sec is void then return end if

    door = vldoor_t(_DoorsMakeThinker(T_VerticalDoor), vldoor_e.raiseIn5Mins, sec, 0, VDOORSPEED, 2, VDOORWAIT, 5 * 60 * TICRATE)
    sec.specialdata = door
    sec.special = 0
    if typeof(P_RegisterThinkerOwner) == "function" then P_RegisterThinkerOwner(door.thinker, door) end if
    _DoorsAddThinkerIfPossible(door.thinker)

    door.direction = 2
    door.type = vldoor_e.raiseIn5Mins
    door.speed = VDOORSPEED
    door.topheight = P_FindLowestCeilingSurrounding(sec) -(4 * FRACUNIT)
    door.topwait = VDOORWAIT
    door.topcountdown = 5 * 60 * 35
  end function

  /*
  * Function: P_InitSlidingDoorFrames
  * Purpose: Initializes state and dependencies for the gameplay and world simulation.
  */
  function P_InitSlidingDoorFrames()

  end function

  /*
  * Function: P_FindSlidingDoorType
  * Purpose: Implements the P_FindSlidingDoorType routine for the gameplay and world simulation.
  */
  function P_FindSlidingDoorType(line)
    line = line
    return -1
  end function

  /*
  * Function: T_SlidingDoor
  * Purpose: Implements the T_SlidingDoor routine for the engine module behavior.
  */
  function T_SlidingDoor(door)
    door = door
  end function

  /*
  * Function: EV_SlidingDoor
  * Purpose: Implements the EV_SlidingDoor routine for the engine module behavior.
  */
  function EV_SlidingDoor(line, thing)
    line = line
    thing = thing
    return 0
  end function



