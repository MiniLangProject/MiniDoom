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

  Script: p_switch.ml
  Purpose: Implements core gameplay simulation: map logic, physics, AI, and world interaction.
*/
import i_system
import doomdef
import p_local
import g_game
import s_sound
import sounds
import doomstat
import r_state
import p_doors
import p_floor
import p_plats
import p_ceilng
import p_lights
import p_spec
import m_argv
import std.math

switchlist =[]
numswitches = 0
buttonlist =[]
_pswDiagUseInit = false
_pswDiagUse = false
_pswDiagUseCount = 0

_alphSwitchList =[
switchlist_t("SW1BRCOM", "SW2BRCOM", 1),
switchlist_t("SW1BRN1", "SW2BRN1", 1),
switchlist_t("SW1BRN2", "SW2BRN2", 1),
switchlist_t("SW1BRNGN", "SW2BRNGN", 1),
switchlist_t("SW1BROWN", "SW2BROWN", 1),
switchlist_t("SW1COMM", "SW2COMM", 1),
switchlist_t("SW1COMP", "SW2COMP", 1),
switchlist_t("SW1DIRT", "SW2DIRT", 1),
switchlist_t("SW1EXIT", "SW2EXIT", 1),
switchlist_t("SW1GRAY", "SW2GRAY", 1),
switchlist_t("SW1GRAY1", "SW2GRAY1", 1),
switchlist_t("SW1METAL", "SW2METAL", 1),
switchlist_t("SW1PIPE", "SW2PIPE", 1),
switchlist_t("SW1SLAD", "SW2SLAD", 1),
switchlist_t("SW1STARG", "SW2STARG", 1),
switchlist_t("SW1STON1", "SW2STON1", 1),
switchlist_t("SW1STON2", "SW2STON2", 1),
switchlist_t("SW1STONE", "SW2STONE", 1),
switchlist_t("SW1STRTN", "SW2STRTN", 1),

switchlist_t("SW1BLUE", "SW2BLUE", 2),
switchlist_t("SW1CMT", "SW2CMT", 2),
switchlist_t("SW1GARG", "SW2GARG", 2),
switchlist_t("SW1GSTON", "SW2GSTON", 2),
switchlist_t("SW1HOT", "SW2HOT", 2),
switchlist_t("SW1LION", "SW2LION", 2),
switchlist_t("SW1SATYR", "SW2SATYR", 2),
switchlist_t("SW1SKIN", "SW2SKIN", 2),
switchlist_t("SW1VINE", "SW2VINE", 2),
switchlist_t("SW1WOOD", "SW2WOOD", 2),

switchlist_t("SW1PANEL", "SW2PANEL", 3),
switchlist_t("SW1ROCK", "SW2ROCK", 3),
switchlist_t("SW1MET2", "SW2MET2", 3),
switchlist_t("SW1WDMET", "SW2WDMET", 3),
switchlist_t("SW1BRIK", "SW2BRIK", 3),
switchlist_t("SW1MOD1", "SW2MOD1", 3),
switchlist_t("SW1ZIM", "SW2ZIM", 3),
switchlist_t("SW1STON6", "SW2STON6", 3),
switchlist_t("SW1TEK", "SW2TEK", 3),
switchlist_t("SW1MARB", "SW2MARB", 3),
switchlist_t("SW1SKULL", "SW2SKULL", 3),

switchlist_t("", "", 0)
]

/*
* Function: _PSW_IsSeq
* Purpose: Implements the _PSW_IsSeq routine for the internal module support.
*/
function inline _PSW_IsSeq(v)
  t = typeof(v)
  return t == "array" or t == "list"
end function

/*
* Function: _InitButtonList
* Purpose: Initializes state and dependencies for the internal module support.
*/
function _InitButtonList()
  global buttonlist

  if len(buttonlist) == MAXBUTTONS then return end if
  buttonlist =[]
  i = 0
  while i < MAXBUTTONS
    buttonlist = buttonlist +[button_t(void, bwhere_e.middle, 0, 0, void)]
    i = i + 1
  end while
end function

/*
* Function: _PSW_Side0
* Purpose: Implements the _PSW_Side0 routine for the internal module support.
*/
function inline _PSW_Side0(line)
  if line is void then return void end if
  if not _PSW_IsSeq(line.sidenum) or len(line.sidenum) <= 0 then return void end if
  sn = line.sidenum[0]
  if typeof(sn) != "int" or sn < 0 then return void end if
  if not _PSW_IsSeq(sides) or sn >= len(sides) then return void end if
  return sides[sn]
end function

/*
* Function: _PSW_StartSound
* Purpose: Starts runtime behavior in the internal module support.
*/
function inline _PSW_StartSound(origin, sound)
  if origin is void then return end if
  if typeof(S_StartSound) == "function" then
    S_StartSound(origin, sound)
  end if
end function

/*
* Function: _PSW_DiagUseEnabled
* Purpose: Implements the _PSW_DiagUseEnabled routine for the internal module support.
*/
function _PSW_DiagUseEnabled()
  global _pswDiagUseInit
  global _pswDiagUse
  if _pswDiagUseInit then return _pswDiagUse end if
  _pswDiagUseInit = true
  _pswDiagUse = false
  if typeof(M_CheckParm) == "function" then
    if M_CheckParm("-diaguse") or M_CheckParm("--diaguse") then
      _pswDiagUse = true
    end if
  end if
  if _pswDiagUse then
    print "P_Switch: -diaguse enabled"
  end if
  return _pswDiagUse
end function

/*
* Function: _PSW_DiagUseLog
* Purpose: Implements the _PSW_DiagUseLog routine for the internal module support.
*/
function inline _PSW_DiagUseLog(msg)
  global _pswDiagUseCount
  if not _PSW_DiagUseEnabled() then return end if
  _pswDiagUseCount = _pswDiagUseCount + 1
  if _pswDiagUseCount <= 40 or(_pswDiagUseCount & 63) == 0 then
    print "P_UseSpecialLine: " + msg
  end if
end function

/*
* Function: P_InitSwitchList
* Purpose: Initializes state and dependencies for the gameplay and world simulation.
*/
function P_InitSwitchList()
  global switchlist
  global numswitches

  _InitButtonList()
  switchlist =[]
  numswitches = 0

  episode = 1
  if gamemode == GameMode_t.registered or gamemode == GameMode_t.retail then
    episode = 2
  else if gamemode == GameMode_t.commercial then
    episode = 3
  end if

  i = 0
  while i < len(_alphSwitchList)
    sw = _alphSwitchList[i]
    if sw.episode == 0 then
      numswitches = _PSW_Idiv(len(switchlist), 2)
      switchlist = switchlist +[-1]
      return
    end if

    if sw.episode <= episode then
      switchlist = switchlist +[R_TextureNumForName(sw.name1)]
      switchlist = switchlist +[R_TextureNumForName(sw.name2)]
    end if

    i = i + 1
  end while

  numswitches = _PSW_Idiv(len(switchlist), 2)
  switchlist = switchlist +[-1]
end function

/*
* Function: _PSW_Idiv
* Purpose: Implements the _PSW_Idiv routine for the internal module support.
*/
function inline _PSW_Idiv(a, b)
  if b == 0 then return 0 end if
  q = a / b
  if q >= 0 then return std.math.floor(q) end if
  return std.math.ceil(q)
end function

/*
* Function: P_StartButton
* Purpose: Starts runtime behavior in the gameplay and world simulation.
*/
function P_StartButton(line, w, texture, time)
  _InitButtonList()

  i = 0
  while i < MAXBUTTONS
    if buttonlist[i].btimer != 0 and buttonlist[i].line == line then
      return
    end if
    i = i + 1
  end while

  i = 0
  while i < MAXBUTTONS
    if buttonlist[i].btimer == 0 then
      buttonlist[i].line = line
      buttonlist[i].where = w
      buttonlist[i].btexture = texture
      buttonlist[i].btimer = time
      if line is not void and line.frontsector is not void then
        buttonlist[i].soundorg = line.frontsector.soundorg
      else
        buttonlist[i].soundorg = void
      end if
      return
    end if
    i = i + 1
  end while

  I_Error("P_StartButton: no button slots left!")
end function

/*
* Function: P_ChangeSwitchTexture
* Purpose: Implements the P_ChangeSwitchTexture routine for the gameplay and world simulation.
*/
function P_ChangeSwitchTexture(line, useAgain)
  if line is void then return end if

  if useAgain == 0 then
    line.special = 0
  end if

  sd = _PSW_Side0(line)
  if sd is void then return end if

  texTop = sd.toptexture
  texMid = sd.midtexture
  texBot = sd.bottomtexture

  sound = sfxenum_t.sfx_swtchn
  if line.special == 11 then
    sound = sfxenum_t.sfx_swtchx
  end if

  i = 0
  while i < numswitches * 2
    if switchlist[i] == texTop then
      org = void
      if sd.sector is not void then org = sd.sector.soundorg end if
      _PSW_StartSound(org, sound)
      sd.toptexture = switchlist[i ^ 1]
      if useAgain != 0 then
        P_StartButton(line, bwhere_e.top, switchlist[i], BUTTONTIME)
      end if
      return
    end if

    if switchlist[i] == texMid then
      org = void
      if sd.sector is not void then org = sd.sector.soundorg end if
      _PSW_StartSound(org, sound)
      sd.midtexture = switchlist[i ^ 1]
      if useAgain != 0 then
        P_StartButton(line, bwhere_e.middle, switchlist[i], BUTTONTIME)
      end if
      return
    end if

    if switchlist[i] == texBot then
      org = void
      if sd.sector is not void then org = sd.sector.soundorg end if
      _PSW_StartSound(org, sound)
      sd.bottomtexture = switchlist[i ^ 1]
      if useAgain != 0 then
        P_StartButton(line, bwhere_e.bottom, switchlist[i], BUTTONTIME)
      end if
      return
    end if

    i = i + 1
  end while
end function

/*
* Function: P_UpdateButtons
* Purpose: Advances per-tick logic for the gameplay and world simulation.
*/
function P_UpdateButtons()
  _InitButtonList()

  i = 0
  while i < MAXBUTTONS
    b = buttonlist[i]
    if b.btimer > 0 then
      b.btimer = b.btimer - 1

      if b.btimer == 0 then
        sd = _PSW_Side0(b.line)
        if sd is not void then
          if b.where == bwhere_e.top then
            sd.toptexture = b.btexture
          else if b.where == bwhere_e.middle then
            sd.midtexture = b.btexture
          else if b.where == bwhere_e.bottom then
            sd.bottomtexture = b.btexture
          end if
        end if

        _PSW_StartSound(b.soundorg, sfxenum_t.sfx_swtchn)

        b.line = void
        b.soundorg = void
      end if
    end if
    buttonlist[i] = b
    i = i + 1
  end while
end function

/*
* Function: P_UseSpecialLine
* Purpose: Implements the P_UseSpecialLine routine for the gameplay and world simulation.
*/
function P_UseSpecialLine(thing, line, side)
  if line is void then return false end if

  tplayer = 0
  if thing is not void and thing.player is not void then tplayer = 1 end if
  _PSW_DiagUseLog("special=" + line.special + " side=" + side + " player=" + tplayer)

  if side != 0 then
    if line.special == 124 then
      return true
    end if
    return false
  end if

  if thing is not void and thing.player is void then
    if (line.flags & ML_SECRET) != 0 then
      return false
    end if

    if line.special != 1 and line.special != 32 and line.special != 33 and line.special != 34 then
      return false
    end if
  end if

  s = line.special

  switch s
    case 1
      EV_VerticalDoor(line, thing)
      return true
    end case
    case 26
      EV_VerticalDoor(line, thing)
      return true
    end case
    case 27
      EV_VerticalDoor(line, thing)
      return true
    end case
    case 28
      EV_VerticalDoor(line, thing)
      return true
    end case
    case 31
      EV_VerticalDoor(line, thing)
      return true
    end case
    case 32
      EV_VerticalDoor(line, thing)
      return true
    end case
    case 33
      EV_VerticalDoor(line, thing)
      return true
    end case
    case 34
      EV_VerticalDoor(line, thing)
      return true
    end case
    case 117
      EV_VerticalDoor(line, thing)
      return true
    end case
    case 118
      EV_VerticalDoor(line, thing)
      return true
    end case

    case 7
      if EV_BuildStairs(line, stair_e.build8) then P_ChangeSwitchTexture(line, 0) end if
      return true
    end case
    case 9
      if EV_DoDonut(line) then P_ChangeSwitchTexture(line, 0) end if
      return true
    end case
    case 11
      P_ChangeSwitchTexture(line, 0)
      G_ExitLevel()
      return true
    end case
    case 14
      if EV_DoPlat(line, plattype_e.raiseAndChange, 32) then P_ChangeSwitchTexture(line, 0) end if
      return true
    end case
    case 15
      if EV_DoPlat(line, plattype_e.raiseAndChange, 24) then P_ChangeSwitchTexture(line, 0) end if
      return true
    end case
    case 18
      if EV_DoFloor(line, floor_e.raiseFloorToNearest) then P_ChangeSwitchTexture(line, 0) end if
      return true
    end case
    case 20
      if EV_DoPlat(line, plattype_e.raiseToNearestAndChange, 0) then P_ChangeSwitchTexture(line, 0) end if
      return true
    end case
    case 21
      if EV_DoPlat(line, plattype_e.downWaitUpStay, 0) then P_ChangeSwitchTexture(line, 0) end if
      return true
    end case
    case 23
      if EV_DoFloor(line, floor_e.lowerFloorToLowest) then P_ChangeSwitchTexture(line, 0) end if
      return true
    end case
    case 29
      if EV_DoDoor(line, vldoor_e.normal) then P_ChangeSwitchTexture(line, 0) end if
      return true
    end case
    case 41
      if EV_DoCeiling(line, ceiling_e.lowerToFloor) then P_ChangeSwitchTexture(line, 0) end if
      return true
    end case
    case 49
      if EV_DoCeiling(line, ceiling_e.crushAndRaise) then P_ChangeSwitchTexture(line, 0) end if
      return true
    end case
    case 50
      if EV_DoDoor(line, vldoor_e.close) then P_ChangeSwitchTexture(line, 0) end if
      return true
    end case
    case 51
      P_ChangeSwitchTexture(line, 0)
      G_SecretExitLevel()
      return true
    end case
    case 55
      if EV_DoFloor(line, floor_e.raiseFloorCrush) then P_ChangeSwitchTexture(line, 0) end if
      return true
    end case
    case 71
      if EV_DoFloor(line, floor_e.turboLower) then P_ChangeSwitchTexture(line, 0) end if
      return true
    end case
    case 101
      if EV_DoFloor(line, floor_e.raiseFloor) then P_ChangeSwitchTexture(line, 0) end if
      return true
    end case
    case 102
      if EV_DoFloor(line, floor_e.lowerFloor) then P_ChangeSwitchTexture(line, 0) end if
      return true
    end case
    case 103
      if EV_DoDoor(line, vldoor_e.open) then P_ChangeSwitchTexture(line, 0) end if
      return true
    end case
    case 111
      if EV_DoDoor(line, vldoor_e.blazeRaise) then P_ChangeSwitchTexture(line, 0) end if
      return true
    end case
    case 112
      if EV_DoDoor(line, vldoor_e.blazeOpen) then P_ChangeSwitchTexture(line, 0) end if
      return true
    end case
    case 113
      if EV_DoDoor(line, vldoor_e.blazeClose) then P_ChangeSwitchTexture(line, 0) end if
      return true
    end case
    case 122
      if EV_DoPlat(line, plattype_e.blazeDWUS, 0) then P_ChangeSwitchTexture(line, 0) end if
      return true
    end case
    case 127
      if EV_BuildStairs(line, stair_e.turbo16) then P_ChangeSwitchTexture(line, 0) end if
      return true
    end case
    case 131
      if EV_DoFloor(line, floor_e.raiseFloorTurbo) then P_ChangeSwitchTexture(line, 0) end if
      return true
    end case
    case 133
      if EV_DoLockedDoor(line, vldoor_e.blazeOpen, thing) then P_ChangeSwitchTexture(line, 0) end if
      return true
    end case
    case 135
      if EV_DoLockedDoor(line, vldoor_e.blazeOpen, thing) then P_ChangeSwitchTexture(line, 0) end if
      return true
    end case
    case 137
      if EV_DoLockedDoor(line, vldoor_e.blazeOpen, thing) then P_ChangeSwitchTexture(line, 0) end if
      return true
    end case
    case 140
      if EV_DoFloor(line, floor_e.raiseFloor512) then P_ChangeSwitchTexture(line, 0) end if
      return true
    end case

    case 42
      if EV_DoDoor(line, vldoor_e.close) then P_ChangeSwitchTexture(line, 1) end if
      return true
    end case
    case 43
      if EV_DoCeiling(line, ceiling_e.lowerToFloor) then P_ChangeSwitchTexture(line, 1) end if
      return true
    end case
    case 45
      if EV_DoFloor(line, floor_e.lowerFloor) then P_ChangeSwitchTexture(line, 1) end if
      return true
    end case
    case 60
      if EV_DoFloor(line, floor_e.lowerFloorToLowest) then P_ChangeSwitchTexture(line, 1) end if
      return true
    end case
    case 61
      if EV_DoDoor(line, vldoor_e.open) then P_ChangeSwitchTexture(line, 1) end if
      return true
    end case
    case 62
      if EV_DoPlat(line, plattype_e.downWaitUpStay, 1) then P_ChangeSwitchTexture(line, 1) end if
      return true
    end case
    case 63
      if EV_DoDoor(line, vldoor_e.normal) then P_ChangeSwitchTexture(line, 1) end if
      return true
    end case
    case 64
      if EV_DoFloor(line, floor_e.raiseFloor) then P_ChangeSwitchTexture(line, 1) end if
      return true
    end case
    case 65
      if EV_DoFloor(line, floor_e.raiseFloorCrush) then P_ChangeSwitchTexture(line, 1) end if
      return true
    end case
    case 66
      if EV_DoPlat(line, plattype_e.raiseAndChange, 24) then P_ChangeSwitchTexture(line, 1) end if
      return true
    end case
    case 67
      if EV_DoPlat(line, plattype_e.raiseAndChange, 32) then P_ChangeSwitchTexture(line, 1) end if
      return true
    end case
    case 68
      if EV_DoPlat(line, plattype_e.raiseToNearestAndChange, 0) then P_ChangeSwitchTexture(line, 1) end if
      return true
    end case
    case 69
      if EV_DoFloor(line, floor_e.raiseFloorToNearest) then P_ChangeSwitchTexture(line, 1) end if
      return true
    end case
    case 70
      if EV_DoFloor(line, floor_e.turboLower) then P_ChangeSwitchTexture(line, 1) end if
      return true
    end case
    case 114
      if EV_DoDoor(line, vldoor_e.blazeRaise) then P_ChangeSwitchTexture(line, 1) end if
      return true
    end case
    case 115
      if EV_DoDoor(line, vldoor_e.blazeOpen) then P_ChangeSwitchTexture(line, 1) end if
      return true
    end case
    case 116
      if EV_DoDoor(line, vldoor_e.blazeClose) then P_ChangeSwitchTexture(line, 1) end if
      return true
    end case
    case 123
      if EV_DoPlat(line, plattype_e.blazeDWUS, 0) then P_ChangeSwitchTexture(line, 1) end if
      return true
    end case
    case 132
      if EV_DoFloor(line, floor_e.raiseFloorTurbo) then P_ChangeSwitchTexture(line, 1) end if
      return true
    end case
    case 99
      if EV_DoLockedDoor(line, vldoor_e.blazeOpen, thing) then P_ChangeSwitchTexture(line, 1) end if
      return true
    end case
    case 134
      if EV_DoLockedDoor(line, vldoor_e.blazeOpen, thing) then P_ChangeSwitchTexture(line, 1) end if
      return true
    end case
    case 136
      if EV_DoLockedDoor(line, vldoor_e.blazeOpen, thing) then P_ChangeSwitchTexture(line, 1) end if
      return true
    end case
    case 138
      EV_LightTurnOn(line, 255)
      P_ChangeSwitchTexture(line, 1)
      return true
    end case
    case 139
      EV_LightTurnOn(line, 35)
      P_ChangeSwitchTexture(line, 1)
      return true
    end case
  end switch

  return true
end function



