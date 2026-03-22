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

  Script: p_floor.ml
  Purpose: Implements core gameplay simulation: map logic, physics, AI, and world interaction.
*/
import z_zone
import doomdef
import p_local
import s_sound
import doomstat
import r_state
import sounds

/*
* Function: _FloorMakeThinker
* Purpose: Advances per-tick logic for the internal module support.
*/
function inline _FloorMakeThinker(fn)
  return thinker_t(void, void, actionf_t(fn, void, void), void)
end function

/*
* Function: _FloorAddThinkerIfPossible
* Purpose: Advances per-tick logic for the internal module support.
*/
function inline _FloorAddThinkerIfPossible(th)
  if typeof(P_AddThinker) == "function" then P_AddThinker(th) end if
end function

/*
* Function: _FloorStartSound
* Purpose: Starts runtime behavior in the internal module support.
*/
function inline _FloorStartSound(origin, snd)
  if typeof(S_StartSound) == "function" then
    S_StartSound(origin, snd)
  end if
end function

/*
* Function: _FloorSoundOrg
* Purpose: Implements the _FloorSoundOrg routine for the internal module support.
*/
function inline _FloorSoundOrg(sec)
  if sec is void then return void end if
  return sec.soundorg
end function

/*
* Function: _FloorSectorIndex
* Purpose: Implements the _FloorSectorIndex routine for the internal module support.
*/
function _FloorSectorIndex(sec)
  if sec is void then return -1 end if
  if typeof(sectors) != "array" then return -1 end if
  i = 0
  while i < len(sectors)
    if sectors[i] == sec then return i end if
    i = i + 1
  end while
  return -1
end function

/*
* Function: _FloorTextureHeight
* Purpose: Implements the _FloorTextureHeight routine for the internal module support.
*/
function inline _FloorTextureHeight(tex)
  if typeof(textureheight) != "array" then return 0 end if
  if tex < 0 or tex >= len(textureheight) then return 0 end if
  return textureheight[tex]
end function

/*
* Function: T_MovePlane
* Purpose: Computes movement/collision behavior in the engine module behavior.
*/
function T_MovePlane(sector, speed, dest, crush, floorOrCeiling, direction)
  if sector is void then return result_e.pastdest end if

  switch floorOrCeiling
    case 0

      switch direction
        case -1

          if sector.floorheight - speed < dest then
            lastpos = sector.floorheight
            sector.floorheight = dest
            flag = P_ChangeSector(sector, crush)
            if flag == true then
              sector.floorheight = lastpos
              P_ChangeSector(sector, crush)
            end if
            return result_e.pastdest
          else
            lastpos = sector.floorheight
            sector.floorheight = sector.floorheight - speed
            flag = P_ChangeSector(sector, crush)
            if flag == true then
              sector.floorheight = lastpos
              P_ChangeSector(sector, crush)
              return result_e.crushed
            end if
          end if
        end case

        case 1

          if sector.floorheight + speed > dest then
            lastpos = sector.floorheight
            sector.floorheight = dest
            flag = P_ChangeSector(sector, crush)
            if flag == true then
              sector.floorheight = lastpos
              P_ChangeSector(sector, crush)
            end if
            return result_e.pastdest
          else
            lastpos = sector.floorheight
            sector.floorheight = sector.floorheight + speed
            flag = P_ChangeSector(sector, crush)
            if flag == true then
              if crush == true then return result_e.crushed end if
              sector.floorheight = lastpos
              P_ChangeSector(sector, crush)
              return result_e.crushed
            end if
          end if
        end case
      end switch
    end case

    case 1

      switch direction
        case -1

          if sector.ceilingheight - speed < dest then
            lastpos = sector.ceilingheight
            sector.ceilingheight = dest
            flag = P_ChangeSector(sector, crush)
            if flag == true then
              sector.ceilingheight = lastpos
              P_ChangeSector(sector, crush)
            end if
            return result_e.pastdest
          else
            lastpos = sector.ceilingheight
            sector.ceilingheight = sector.ceilingheight - speed
            flag = P_ChangeSector(sector, crush)
            if flag == true then
              if crush == true then return result_e.crushed end if
              sector.ceilingheight = lastpos
              P_ChangeSector(sector, crush)
              return result_e.crushed
            end if
          end if
        end case

        case 1

          if sector.ceilingheight + speed > dest then
            lastpos = sector.ceilingheight
            sector.ceilingheight = dest
            flag = P_ChangeSector(sector, crush)
            if flag == true then
              sector.ceilingheight = lastpos
              P_ChangeSector(sector, crush)
            end if
            return result_e.pastdest
          else
            lastpos = sector.ceilingheight
            sector.ceilingheight = sector.ceilingheight + speed
            P_ChangeSector(sector, crush)
          end if
        end case
      end switch
    end case
  end switch

  return result_e.ok
end function

/*
* Function: T_MoveFloor
* Purpose: Computes movement/collision behavior in the engine module behavior.
*/
function T_MoveFloor(floor)
  if floor is void or floor.sector is void then return end if

  res = T_MovePlane(
  floor.sector,
  floor.speed,
  floor.floordestheight,
  floor.crush,
  0,
  floor.direction
)

  if (leveltime & 7) == 0 then
    _FloorStartSound(_FloorSoundOrg(floor.sector), sfxenum_t.sfx_stnmov)
  end if

  if res == result_e.pastdest then
    floor.sector.specialdata = void

    if floor.direction == 1 then
      switch floor.type
        case floor_e.donutRaise
          floor.sector.special = floor.newspecial
          floor.sector.floorpic = floor.texture
        end case
      end switch
    else if floor.direction == -1 then
      switch floor.type
        case floor_e.lowerAndChange
          floor.sector.special = floor.newspecial
          floor.sector.floorpic = floor.texture
        end case
      end switch
    end if

    if typeof(P_RemoveThinker) == "function" then P_RemoveThinker(floor.thinker) end if
    _FloorStartSound(_FloorSoundOrg(floor.sector), sfxenum_t.sfx_pstop)
  end if
end function

/*
* Function: EV_DoFloor
* Purpose: Implements the EV_DoFloor routine for the engine module behavior.
*/
function EV_DoFloor(line, floortype)
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
    floor = floormove_t(_FloorMakeThinker(T_MoveFloor), floortype, false, sec, 0, 0, 0, sec.floorheight, FLOORSPEED)
    sec.specialdata = floor
    if typeof(P_RegisterThinkerOwner) == "function" then P_RegisterThinkerOwner(floor.thinker, floor) end if
    _FloorAddThinkerIfPossible(floor.thinker)

    switch floortype
      case floor_e.lowerFloor
        floor.direction = -1
        floor.sector = sec
        floor.speed = FLOORSPEED
        floor.floordestheight = P_FindHighestFloorSurrounding(sec)
      end case

      case floor_e.lowerFloorToLowest
        floor.direction = -1
        floor.sector = sec
        floor.speed = FLOORSPEED
        floor.floordestheight = P_FindLowestFloorSurrounding(sec)
      end case

      case floor_e.turboLower
        floor.direction = -1
        floor.sector = sec
        floor.speed = FLOORSPEED * 4
        floor.floordestheight = P_FindHighestFloorSurrounding(sec)
        if floor.floordestheight != sec.floorheight then
          floor.floordestheight = floor.floordestheight + 8 * FRACUNIT
        end if
      end case

      case floor_e.raiseFloorCrush
        floor.crush = true
        floor.direction = 1
        floor.sector = sec
        floor.speed = FLOORSPEED
        floor.floordestheight = P_FindLowestCeilingSurrounding(sec)
        if floor.floordestheight > sec.ceilingheight then
          floor.floordestheight = sec.ceilingheight
        end if
        floor.floordestheight = floor.floordestheight - 8 * FRACUNIT
      end case

      case floor_e.raiseFloor
        floor.direction = 1
        floor.sector = sec
        floor.speed = FLOORSPEED
        floor.floordestheight = P_FindLowestCeilingSurrounding(sec)
        if floor.floordestheight > sec.ceilingheight then
          floor.floordestheight = sec.ceilingheight
        end if
      end case

      case floor_e.raiseFloorTurbo
        floor.direction = 1
        floor.sector = sec
        floor.speed = FLOORSPEED * 4
        floor.floordestheight = P_FindNextHighestFloor(sec, sec.floorheight)
      end case

      case floor_e.raiseFloorToNearest
        floor.direction = 1
        floor.sector = sec
        floor.speed = FLOORSPEED
        floor.floordestheight = P_FindNextHighestFloor(sec, sec.floorheight)
      end case

      case floor_e.raiseFloor24
        floor.direction = 1
        floor.sector = sec
        floor.speed = FLOORSPEED
        floor.floordestheight = floor.sector.floorheight + 24 * FRACUNIT
      end case

      case floor_e.raiseFloor512
        floor.direction = 1
        floor.sector = sec
        floor.speed = FLOORSPEED
        floor.floordestheight = floor.sector.floorheight + 512 * FRACUNIT
      end case

      case floor_e.raiseFloor24AndChange
        floor.direction = 1
        floor.sector = sec
        floor.speed = FLOORSPEED
        floor.floordestheight = floor.sector.floorheight + 24 * FRACUNIT
        if line.frontsector is not void then
          sec.floorpic = line.frontsector.floorpic
          sec.special = line.frontsector.special
        end if
      end case

      case floor_e.raiseToTexture
        minsize = MAXINT

        i = 0
        while i < sec.linecount
          if twoSided(secnum, i) then
            side = getSide(secnum, i, 0)
            if side is not void and side.bottomtexture >= 0 then
              h = _FloorTextureHeight(side.bottomtexture)
              if h < minsize then minsize = h end if
            end if

            side = getSide(secnum, i, 1)
            if side is not void and side.bottomtexture >= 0 then
              h = _FloorTextureHeight(side.bottomtexture)
              if h < minsize then minsize = h end if
            end if
          end if
          i = i + 1
        end while

        if minsize == MAXINT then minsize = 0 end if

        floor.direction = 1
        floor.sector = sec
        floor.speed = FLOORSPEED
        floor.floordestheight = floor.sector.floorheight + minsize
      end case

      case floor_e.lowerAndChange
        floor.direction = -1
        floor.sector = sec
        floor.speed = FLOORSPEED
        floor.floordestheight = P_FindLowestFloorSurrounding(sec)
        floor.texture = sec.floorpic

        i = 0
        while i < sec.linecount
          if twoSided(secnum, i) then
            tsec = void
            side0 = getSide(secnum, i, 0)
            if side0 is not void and side0.sector == sec then
              tsec = getSector(secnum, i, 1)
            else
              tsec = getSector(secnum, i, 0)
            end if

            if tsec is not void and tsec.floorheight == floor.floordestheight then
              floor.texture = tsec.floorpic
              floor.newspecial = tsec.special
              break
            end if
          end if
          i = i + 1
        end while
      end case
    end switch
    while true
    end loop

    return rtn
  end function

  /*
  * Function: EV_BuildStairs
  * Purpose: Implements the EV_BuildStairs routine for the engine module behavior.
  */
  function EV_BuildStairs(line, type)
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

      speed = FLOORSPEED >> 2
      stairsize = 8 * FRACUNIT
      switch type
        case stair_e.build8
          speed = FLOORSPEED >> 2
          stairsize = 8 * FRACUNIT
        end case

        case stair_e.turbo16
          speed = FLOORSPEED * 4
          stairsize = 16 * FRACUNIT
        end case
      end switch

      floor = floormove_t(_FloorMakeThinker(T_MoveFloor), floor_e.raiseFloor, false, sec, 1, 0, 0, 0, speed)
      sec.specialdata = floor
      if typeof(P_RegisterThinkerOwner) == "function" then P_RegisterThinkerOwner(floor.thinker, floor) end if
      _FloorAddThinkerIfPossible(floor.thinker)

      height = sec.floorheight + stairsize
      floor.floordestheight = height

      texture = sec.floorpic

      ok = 1
      while ok == 1
        ok = 0

        i = 0
        while i < sec.linecount
          li = sec.lines[i]
          if li is void then
            i = i + 1
            continue
          end if

          if (li.flags & ML_TWOSIDED) == 0 then
            i = i + 1
            continue
          end if

          tsec = li.frontsector
          newsecnum = _FloorSectorIndex(tsec)
          if secnum != newsecnum then
            i = i + 1
            continue
          end if

          tsec = li.backsector
          newsecnum = _FloorSectorIndex(tsec)
          if tsec is void then
            i = i + 1
            continue
          end if

          if tsec.floorpic != texture then
            i = i + 1
            continue
          end if

          height = height + stairsize

          if tsec.specialdata is not void then
            i = i + 1
            continue
          end if

          sec = tsec
          secnum = newsecnum

          floor = floormove_t(_FloorMakeThinker(T_MoveFloor), floor_e.raiseFloor, false, sec, 1, 0, 0, height, speed)
          sec.specialdata = floor
          if typeof(P_RegisterThinkerOwner) == "function" then P_RegisterThinkerOwner(floor.thinker, floor) end if
          _FloorAddThinkerIfPossible(floor.thinker)

          ok = 1
          break
        end while
      end while
      while true
      end loop

      return rtn
    end function



