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

  Script: m_menu.ml
  Purpose: Provides shared math, utility, and low-level helper routines.
*/
import d_event
import doomdef
import dstrings
import d_main
import i_system
import i_video
import z_zone
import v_video
import w_wad
import r_local
import hu_stuff
import g_game
import m_argv
import m_swap
import s_sound
import doomstat
import sounds
import mp_state
import mp_platform

import std.fs as fs

const SAVESTRINGSIZE = 24

const SKULLXOFF = -32
const LINEHEIGHT = 16

const CH_SPACE = 32
const CH_N = 110
const CH_Y = 121

/*
* Function: _min
* Purpose: Implements the _min routine for the internal module support.
*/
function inline _min(a, b)
  if a < b then return a end if
  return b
end function

/*
* Function: _toupperByte
* Purpose: Implements the _toupperByte routine for the internal module support.
*/
function inline _toupperByte(c)

  if c >= 97 and c <= 122 then return c - 32 end if
  return c
end function

/*
* Function: _bytesOf
* Purpose: Implements the _bytesOf routine for the internal module support.
*/
function inline _bytesOf(x)
  if typeof(x) == "bytes" then return x end if
  if typeof(x) == "string" then return bytes(x) end if

  return bytes("")
end function

/*
* Function: _MMENU_IDiv
* Purpose: Implements the _MMENU_IDiv routine for the internal module support.
*/
function inline _MMENU_IDiv(a, b)
  if typeof(a) != "int" or typeof(b) != "int" or b == 0 then return 0 end if
  q = a / b
  if q >= 0 then return std.math.floor(q) end if
  return std.math.ceil(q)
end function

/*
* Function: _MMENU_ToInt
* Purpose: Converts values to integers with fallback handling.
*/
function _MMENU_ToInt(v, fallback)
  if typeof(v) == "int" then return v end if
  if typeof(v) == "float" then
    if v >= 0 then return std.math.floor(v) end if
    return std.math.ceil(v)
  end if
  n = toNumber(v)
  if typeof(n) == "int" then return n end if
  if typeof(n) == "float" then
    if n >= 0 then return std.math.floor(n) end if
    return std.math.ceil(n)
  end if
  return fallback
end function

/*
* Function: _MMENU_ItemCount
* Purpose: Implements the _MMENU_ItemCount routine for the internal module support.
*/
function inline _MMENU_ItemCount(menu)
  if menu is void or menu == 0 then return 0 end if
  n = 0
  if typeof(menu.numitems) == "int" then n = menu.numitems end if
  if n < 0 then n = 0 end if

  t = typeof(menu.menuitems)
  if t != "array" and t != "list" then return 0 end if
  if n > len(menu.menuitems) then n = len(menu.menuitems) end if
  return n
end function

/*
* Function: _MMENU_ClampCursor
* Purpose: Implements the _MMENU_ClampCursor routine for the internal module support.
*/
function _MMENU_ClampCursor()
  global currentMenu
  global itemOn
  n = _MMENU_ItemCount(currentMenu)
  if n <= 0 then
    itemOn = 0
    return 0
  end if

  if typeof(itemOn) != "int" then itemOn = 0 end if
  if itemOn < 0 or itemOn >= n then
    fallback = 0
    if typeof(currentMenu.lastOn) == "int" then fallback = currentMenu.lastOn end if
    if fallback < 0 or fallback >= n then fallback = 0 end if
    itemOn = fallback
  end if
  return n
end function

/*
* Function: _patchWidth
* Purpose: Implements the _patchWidth routine for the internal module support.
*/
function inline _patchWidth(patch)
  if typeof(patch) != "bytes" then return 0 end if
  v = patch[0] +(patch[1] << 8)
  if v >= 32768 then v = v - 65536 end if
  return v
end function

/*
* Function: _patchHeight
* Purpose: Implements the _patchHeight routine for the internal module support.
*/
function inline _patchHeight(patch)
  if typeof(patch) != "bytes" then return 0 end if
  v = patch[2] +(patch[3] << 8)
  if v >= 32768 then v = v - 65536 end if
  return v
end function

/*
* Function: _cstrClear
* Purpose: Implements the _cstrClear routine for the internal module support.
*/
function _cstrClear(buf)
  if typeof(buf) != "bytes" then return end if
  for i = 0 to len(buf) - 1
    buf[i] = 0
  end for
end function

/*
* Function: _cstrLen
* Purpose: Implements the _cstrLen routine for the internal module support.
*/
function _cstrLen(buf)
  if typeof(buf) != "bytes" then return 0 end if
  i = 0
  while i < len(buf) and buf[i] != 0
    i = i + 1
  end while
  return i
end function

/*
* Function: _cstrFromString
* Purpose: Implements the _cstrFromString routine for the internal module support.
*/
function _cstrFromString(buf, s)
  if typeof(buf) != "bytes" then return end if
  _cstrClear(buf)
  b = bytes(s)
  n = _min(len(b), len(buf) - 1)
  for i = 0 to n - 1
    buf[i] = b[i]
  end for
  if len(buf) > 0 then buf[n] = 0 end if
end function

/*
* Function: _cstrCopy
* Purpose: Implements the _cstrCopy routine for the internal module support.
*/
function _cstrCopy(dst, src)
  if typeof(dst) != "bytes" or typeof(src) != "bytes" then return end if
  _cstrClear(dst)
  n = _min(_cstrLen(src), len(dst) - 1)
  for i = 0 to n - 1
    dst[i] = src[i]
  end for
  if len(dst) > 0 then dst[n] = 0 end if
end function

/*
* Function: _cstrEqString
* Purpose: Implements the _cstrEqString routine for the internal module support.
*/
function inline _cstrEqString(buf, s)
  if typeof(buf) != "bytes" then return false end if
  return decodeZ(buf) == s
end function

/*
* Function: _fmt1
* Purpose: Implements the _fmt1 routine for the internal module support.
*/
function _fmt1(fmt, arg)

  if typeof(fmt) != "string" then return "" end if
  if typeof(arg) != "string" then arg = "" end if

  fb = bytes(fmt)
  ab = bytes(arg)

  p = -1
  for i = 0 to len(fb) - 2
    if fb[i] == 37 and fb[i + 1] == 115 then
      p = i
      break
    end if
  end for

  if p < 0 then
    return fmt
  end if

  outLen =(len(fb) - 2) + len(ab)
  outBytes = bytes(outLen, 0)

  oi = 0

  for i = 0 to p - 1
    outBytes[oi] = fb[i]
    oi = oi + 1
  end for

  for i = 0 to len(ab) - 1
    outBytes[oi] = ab[i]
    oi = oi + 1
  end for

  for i = p + 2 to len(fb) - 1
    outBytes[oi] = fb[i]
    oi = oi + 1
  end for

  return decode(outBytes)
end function

/*
* Struct: menuitem_t
* Purpose: Stores runtime data for menuitem type.
*/
struct menuitem_t
  status
  name
  routine
  alphaKey
end struct

/*
* Struct: menu_t
* Purpose: Stores runtime data for menu type.
*/
struct menu_t
  numitems
  prevMenu
  menuitems
  routine
  x
  y
  lastOn
end struct

/*
* Function: _MI
* Purpose: Implements the _MI routine for the internal module support.
*/
function inline _MI(status, name, routine, alphaKey)
  return menuitem_t(status, name, routine, alphaKey)
end function

/*
* Function: _Menu
* Purpose: Implements the _Menu routine for the internal module support.
*/
function inline _Menu(numitems, prevMenu, menuitems, routine, x, y, lastOn)
  return menu_t(numitems, prevMenu, menuitems, routine, x, y, lastOn)
end function

mouseSensitivity = 5
showMessages = 1

detailLevel = 0
screenblocks = 10
screenSize = 0
quickSaveSlot = -1

messageToPrint = 0
messageString = ""
messx = 0
messy = 0
messageLastMenuActive = false
messageNeedsInput = false
messageRoutine = 0

gammamsg =[GAMMALVL0, GAMMALVL1, GAMMALVL2, GAMMALVL3, GAMMALVL4]

saveStringEnter = 0
saveSlot = 0
saveCharIndex = 0
saveOldString = 0
savegamestrings = 0

inhelpscreens = false
menuactive = false

itemOn = 0
skullAnimCounter = 0
whichSkull = 0
skullName =["M_SKULL1", "M_SKULL2"]

currentMenu = 0

endstring = ""
tempstring = ""

MainMenu = 0
MainDef = 0
MultiplayerMenu = 0
MultiplayerDef = 0
MPHostMenu = 0
MPHostDef = 0
MPJoinMenu = 0
MPJoinDef = 0
MPNameMenu = 0
MPNameDef = 0

EpisodeMenu = 0
EpiDef = 0

NewGameMenu = 0
NewDef = 0

OptionsMenu = 0
OptionsDef = 0

detailNames =["M_GDHIGH", "M_GDLOW"]
msgNames =["M_MSGOFF", "M_MSGON"]

ReadMenu1 = 0
ReadDef1 = 0
ReadMenu2 = 0
ReadDef2 = 0

SoundMenu = 0
SoundDef = 0

LoadMenu = 0
LoadDef = 0

SaveMenu = 0
SaveDef = 0

epi = 0

quitsounds = 0
quitsounds2 = 0

const main_newgame = 0
const main_multiplayer = 1
const main_options = 2
const main_loadgame = 3
const main_savegame = 4
const main_readthis = 5
const main_quitdoom = 6
const main_end = 7

const mp_main_host = 0
const mp_main_join = 1
const mp_main_name = 2
const mp_main_end = 3

const mp_host_mode_item = 0
const mp_host_map = 1
const mp_host_skill_item = 2
const mp_host_players = 3
const mp_host_fraglimit = 4
const mp_host_timelimit = 5
const mp_host_port_item = 6
const mp_host_start = 7
const mp_host_end = 8

const mp_join_host_item = 0
const mp_join_port_item = 1
const mp_join_start = 2
const mp_join_end = 3

const mp_name_edit = 0
const mp_name_done = 1
const mp_name_end = 2

const ep1 = 0
const ep2 = 1
const ep3 = 2
const ep4 = 3
const ep_end = 4

const killthings = 0
const toorough = 1
const hurtme = 2
const violence = 3
const nightmare = 4
const newg_end = 5

const endgame = 0
const messages = 1
const detail = 2
const scrnsize = 3
const option_empty1 = 4
const mousesens = 5
const option_empty2 = 6
const soundvol = 7
const opt_end = 8

const read1_end = 1
const read2_end = 1

const sfx_vol = 0
const music_vol = 2
const sound_end = 4

const load_end = 6

mpNameEnter = 0
mpNameCharIndex = 0
mpNameBuf = 0
mpNameOld = 0
mpJoinHostEnter = 0
mpJoinHostCharIndex = 0
mpJoinHostBuf = 0
mpJoinHostOld = 0

/*
* Function: _MMENU_BuildMainMenu
* Purpose: Creates the main menu item array including multiplayer entry.
*/
function inline _MMENU_BuildMainMenu()
  return [
  _MI(1, "M_NGAME", M_NewGame, 110),
  _MI(1, "", M_Multiplayer, 109),
  _MI(1, "M_OPTION", M_Options, 111),
  _MI(1, "M_LOADG", M_LoadGame, 108),
  _MI(1, "M_SAVEG", M_SaveGame, 115),
  _MI(1, "M_RDTHIS", M_ReadThis, 114),
  _MI(1, "M_QUITG", M_QuitDOOM, 113)
]
end function

/*
* Function: _MMENU_BuildMultiplayerMenu
* Purpose: Creates the multiplayer root menu item array.
*/
function inline _MMENU_BuildMultiplayerMenu()
  return [
  _MI(1, "", M_MPHostMenuOpen, 104),
  _MI(1, "", M_MPJoinMenuOpen, 106),
  _MI(1, "", M_MPNameMenuOpen, 112)
]
end function

/*
* Function: _MMENU_BuildMPHostMenu
* Purpose: Creates host setup menu item array.
*/
function inline _MMENU_BuildMPHostMenu()
  return [
  _MI(2, "", M_MPHostMode, 109),
  _MI(2, "", M_MPHostMap, 97),
  _MI(2, "", M_MPHostSkill, 115),
  _MI(2, "", M_MPHostPlayers, 112),
  _MI(2, "", M_MPHostFragLimit, 102),
  _MI(2, "", M_MPHostTimeLimit, 116),
  _MI(2, "", M_MPHostPort, 111),
  _MI(1, "", M_MPHostStart, 13)
]
end function

/*
* Function: _MMENU_BuildMPJoinMenu
* Purpose: Creates join setup menu item array.
*/
function inline _MMENU_BuildMPJoinMenu()
  return [
  _MI(1, "", M_MPJoinEditHost, 104),
  _MI(2, "", M_MPJoinPort, 112),
  _MI(1, "", M_MPJoinStart, 13)
]
end function

/*
* Function: _MMENU_BuildMPNameMenu
* Purpose: Creates player-name editor menu item array.
*/
function inline _MMENU_BuildMPNameMenu()
  return [
  _MI(1, "", M_MPNameEdit, 110),
  _MI(1, "", M_MPNameDone, 100)
]
end function

/*
* Function: _BuildMenus
* Purpose: Implements the _BuildMenus routine for the internal module support.
*/
function _BuildMenus()
  global MainMenu
  global MainDef
  global MultiplayerMenu
  global MultiplayerDef
  global MPHostMenu
  global MPHostDef
  global MPJoinMenu
  global MPJoinDef
  global MPNameMenu
  global MPNameDef
  global EpisodeMenu
  global EpiDef
  global NewGameMenu
  global NewDef
  global OptionsMenu
  global OptionsDef
  global ReadMenu1
  global ReadDef1
  global ReadMenu2
  global ReadDef2
  global SoundMenu
  global SoundDef
  global LoadMenu
  global LoadDef
  global SaveMenu
  global SaveDef
  global quitsounds
  global quitsounds2

  MainMenu = _MMENU_BuildMainMenu()
  MainDef = _Menu(main_end, 0, MainMenu, M_DrawMainMenu, 97, 64, 0)

  MultiplayerMenu = _MMENU_BuildMultiplayerMenu()
  MultiplayerDef = _Menu(mp_main_end, MainDef, MultiplayerMenu, M_DrawMultiplayerMenu, 72, 74, 0)

  MPHostMenu = _MMENU_BuildMPHostMenu()
  MPHostDef = _Menu(mp_host_end, MultiplayerDef, MPHostMenu, M_DrawMPHostMenu, 36, 44, 0)

  MPJoinMenu = _MMENU_BuildMPJoinMenu()
  MPJoinDef = _Menu(mp_join_end, MultiplayerDef, MPJoinMenu, M_DrawMPJoinMenu, 42, 74, 0)

  MPNameMenu = _MMENU_BuildMPNameMenu()
  MPNameDef = _Menu(mp_name_end, MultiplayerDef, MPNameMenu, M_DrawMPNameMenu, 42, 84, 0)

  EpisodeMenu =[
  _MI(1, "M_EPI1", M_Episode, 107),
  _MI(1, "M_EPI2", M_Episode, 116),
  _MI(1, "M_EPI3", M_Episode, 105),
  _MI(1, "M_EPI4", M_Episode, 116)
]
  EpiDef = _Menu(ep_end, MainDef, EpisodeMenu, M_DrawEpisode, 48, 63, ep1)

  NewGameMenu =[
  _MI(1, "M_JKILL", M_ChooseSkill, 105),
  _MI(1, "M_ROUGH", M_ChooseSkill, 104),
  _MI(1, "M_HURT", M_ChooseSkill, 104),
  _MI(1, "M_ULTRA", M_ChooseSkill, 117),
  _MI(1, "M_NMARE", M_ChooseSkill, 110)
]
  NewDef = _Menu(newg_end, EpiDef, NewGameMenu, M_DrawNewGame, 48, 63, hurtme)

  OptionsMenu =[
  _MI(1, "M_ENDGAM", M_EndGame, 101),
  _MI(1, "M_MESSG", M_ChangeMessages, 109),
  _MI(1, "M_DETAIL", M_ChangeDetail, 103),
  _MI(2, "M_SCRNSZ", M_SizeDisplay, 115),
  _MI(-1, "", 0, 0),
  _MI(2, "M_MSENS", M_ChangeSensitivity, 109),
  _MI(-1, "", 0, 0),
  _MI(1, "M_SVOL", M_Sound, 115)
]
  OptionsDef = _Menu(opt_end, MainDef, OptionsMenu, M_DrawOptions, 60, 37, 0)

  ReadMenu1 =[_MI(1, "", M_ReadThis2, 0)]
  ReadDef1 = _Menu(read1_end, MainDef, ReadMenu1, M_DrawReadThis1, 280, 185, 0)

  ReadMenu2 =[_MI(1, "", M_FinishReadThis, 0)]
  ReadDef2 = _Menu(read2_end, ReadDef1, ReadMenu2, M_DrawReadThis2, 330, 175, 0)

  SoundMenu =[
  _MI(2, "M_SFXVOL", M_SfxVol, 115),
  _MI(-1, "", 0, 0),
  _MI(2, "M_MUSVOL", M_MusicVol, 109),
  _MI(-1, "", 0, 0)
]
  SoundDef = _Menu(sound_end, OptionsDef, SoundMenu, M_DrawSound, 80, 64, 0)

  LoadMenu =[
  _MI(1, "", M_LoadSelect, 49),
  _MI(1, "", M_LoadSelect, 50),
  _MI(1, "", M_LoadSelect, 51),
  _MI(1, "", M_LoadSelect, 52),
  _MI(1, "", M_LoadSelect, 53),
  _MI(1, "", M_LoadSelect, 54)
]
  LoadDef = _Menu(load_end, MainDef, LoadMenu, M_DrawLoad, 80, 54, 0)

  SaveMenu =[
  _MI(1, "", M_SaveSelect, 49),
  _MI(1, "", M_SaveSelect, 50),
  _MI(1, "", M_SaveSelect, 51),
  _MI(1, "", M_SaveSelect, 52),
  _MI(1, "", M_SaveSelect, 53),
  _MI(1, "", M_SaveSelect, 54)
]
  SaveDef = _Menu(load_end, MainDef, SaveMenu, M_DrawSave, 80, 54, 0)

  quitsounds =[
  sfxenum_t.sfx_pldeth,
  sfxenum_t.sfx_dmpain,
  sfxenum_t.sfx_popain,
  sfxenum_t.sfx_slop,
  sfxenum_t.sfx_telept,
  sfxenum_t.sfx_posit1,
  sfxenum_t.sfx_posit3,
  sfxenum_t.sfx_sgtatk
]

  quitsounds2 =[
  sfxenum_t.sfx_vilact,
  sfxenum_t.sfx_getpow,
  sfxenum_t.sfx_boscub,
  sfxenum_t.sfx_slop,
  sfxenum_t.sfx_skeswg,
  sfxenum_t.sfx_kntdth,
  sfxenum_t.sfx_bspact,
  sfxenum_t.sfx_sgtatk
]
end function

/*
* Function: M_ReadSaveStrings
* Purpose: Implements the M_ReadSaveStrings routine for the utility/math layer.
*/
function M_ReadSaveStrings()
  global savegamestrings
  global saveOldString
  if savegamestrings == 0 then
    savegamestrings =[]
    for i = 0 to load_end - 1
      savegamestrings = savegamestrings +[bytes(SAVESTRINGSIZE, 0)]
    end for
  end if
  if saveOldString == 0 then
    saveOldString = bytes(SAVESTRINGSIZE, 0)
  end if

  for i = 0 to load_end - 1
    name = ""
    if M_CheckParm("-cdrom") != 0 then
      name = "c:\\doomdata\\" + SAVEGAMENAME + i + ".dsg"
    else
      name = SAVEGAMENAME + i + ".dsg"
    end if

    data = void
    if fs.exists(name) and fs.isFile(name) then
      dataTry = try(fs.readAllBytes(name))
      if typeof(dataTry) != "error" then
        data = dataTry
      end if
    end if
    if typeof(data) == "bytes" then

      _cstrClear(savegamestrings[i])
      n = _min(SAVESTRINGSIZE, len(data))
      for j = 0 to n - 1
        savegamestrings[i][j] = data[j]
      end for
      if n < SAVESTRINGSIZE then savegamestrings[i][n] = 0 end if
      LoadMenu[i].status = 1
    else
      _cstrFromString(savegamestrings[i], EMPTYSTRING)
      LoadMenu[i].status = 0
    end if
  end for
end function

/*
* Function: M_DrawLoad
* Purpose: Loads and prepares data required by the utility/math layer.
*/
function M_DrawLoad()
  V_DrawPatchDirect(72, 28, 0, W_CacheLumpName("M_LOADG", PU_CACHE))
  for i = 0 to load_end - 1
    M_DrawSaveLoadBorder(LoadDef.x, LoadDef.y + LINEHEIGHT * i)
    M_WriteText(LoadDef.x, LoadDef.y + LINEHEIGHT * i, savegamestrings[i])
  end for
end function

/*
* Function: M_DrawSaveLoadBorder
* Purpose: Loads and prepares data required by the utility/math layer.
*/
function M_DrawSaveLoadBorder(x, y)
  V_DrawPatchDirect(x - 8, y + 7, 0, W_CacheLumpName("M_LSLEFT", PU_CACHE))
  for i = 0 to 23
    V_DrawPatchDirect(x, y + 7, 0, W_CacheLumpName("M_LSCNTR", PU_CACHE))
    x = x + 8
  end for
  V_DrawPatchDirect(x, y + 7, 0, W_CacheLumpName("M_LSRGHT", PU_CACHE))
end function

/*
* Function: M_LoadSelect
* Purpose: Loads and prepares data required by the utility/math layer.
*/
function M_LoadSelect(choice)
  name = ""
  if M_CheckParm("-cdrom") != 0 then
    name = "c:\\doomdata\\" + SAVEGAMENAME + choice + ".dsg"
  else
    name = SAVEGAMENAME + choice + ".dsg"
  end if
  G_LoadGame(name)
  M_ClearMenus()
end function

/*
* Function: M_LoadGame
* Purpose: Loads and prepares data required by the utility/math layer.
*/
function M_LoadGame(choice)
  choice = choice
  if netgame then
    M_StartMessage(LOADNET, 0, false)
    return
  end if

  M_SetupNextMenu(LoadDef)
  M_ReadSaveStrings()
end function

/*
* Function: M_DrawSave
* Purpose: Draws or renders output for the utility/math layer.
*/
function M_DrawSave()
  V_DrawPatchDirect(72, 28, 0, W_CacheLumpName("M_SAVEG", PU_CACHE))
  for i = 0 to load_end - 1
    M_DrawSaveLoadBorder(LoadDef.x, LoadDef.y + LINEHEIGHT * i)
    M_WriteText(LoadDef.x, LoadDef.y + LINEHEIGHT * i, savegamestrings[i])
  end for

  if saveStringEnter != 0 then
    i = M_StringWidth(savegamestrings[saveSlot])
    M_WriteText(LoadDef.x + i, LoadDef.y + LINEHEIGHT * saveSlot, "_")
  end if
end function

/*
* Function: M_DoSave
* Purpose: Implements the M_DoSave routine for the utility/math layer.
*/
function M_DoSave(slot)
  global quickSaveSlot
  G_SaveGame(slot, decodeZ(savegamestrings[slot]))
  M_ClearMenus()

  if quickSaveSlot == -2 then
    quickSaveSlot = slot
  end if
end function

/*
* Function: M_SaveSelect
* Purpose: Implements the M_SaveSelect routine for the utility/math layer.
*/
function M_SaveSelect(choice)
  global saveStringEnter
  global saveSlot
  global saveCharIndex
  saveStringEnter = 1
  saveSlot = choice

  _cstrCopy(saveOldString, savegamestrings[choice])
  if _cstrEqString(savegamestrings[choice], EMPTYSTRING) then
    savegamestrings[choice][0] = 0
  end if
  saveCharIndex = _cstrLen(savegamestrings[choice])
end function

/*
* Function: M_SaveGame
* Purpose: Implements the M_SaveGame routine for the utility/math layer.
*/
function M_SaveGame(choice)
  choice = choice

  if not usergame then
    M_StartMessage(SAVEDEAD, 0, false)
    return
  end if

  if gamestate != gamestate_t.GS_LEVEL then
    return
  end if

  M_SetupNextMenu(SaveDef)
  M_ReadSaveStrings()
end function

/*
* Function: M_QuickSaveResponse
* Purpose: Implements the M_QuickSaveResponse routine for the utility/math layer.
*/
function M_QuickSaveResponse(ch)
  if ch == CH_Y then
    M_DoSave(quickSaveSlot)
    S_StartSound(0, sfxenum_t.sfx_swtchx)
  end if
end function

/*
* Function: M_QuickSave
* Purpose: Implements the M_QuickSave routine for the utility/math layer.
*/
function M_QuickSave()
  global quickSaveSlot
  global tempstring
  if not usergame then
    S_StartSound(0, sfxenum_t.sfx_oof)
    return
  end if

  if gamestate != gamestate_t.GS_LEVEL then return end if

  if quickSaveSlot < 0 then
    M_StartControlPanel()
    M_ReadSaveStrings()
    M_SetupNextMenu(SaveDef)
    quickSaveSlot = -2
    return
  end if

  tempstring = _fmt1(QSPROMPT, decodeZ(savegamestrings[quickSaveSlot]))
  M_StartMessage(tempstring, M_QuickSaveResponse, true)
end function

/*
* Function: M_QuickLoadResponse
* Purpose: Loads and prepares data required by the utility/math layer.
*/
function M_QuickLoadResponse(ch)
  if ch == CH_Y then
    M_LoadSelect(quickSaveSlot)
    S_StartSound(0, sfxenum_t.sfx_swtchx)
  end if
end function

/*
* Function: M_QuickLoad
* Purpose: Loads and prepares data required by the utility/math layer.
*/
function M_QuickLoad()
  global tempstring
  if netgame then
    M_StartMessage(QLOADNET, 0, false)
    return
  end if

  if quickSaveSlot < 0 then
    M_StartMessage(QSAVESPOT, 0, false)
    return
  end if

  tempstring = _fmt1(QLPROMPT, decodeZ(savegamestrings[quickSaveSlot]))
  M_StartMessage(tempstring, M_QuickLoadResponse, true)
end function

/*
* Function: M_DrawReadThis1
* Purpose: Draws or renders output for the utility/math layer.
*/
function M_DrawReadThis1()
  global inhelpscreens
  inhelpscreens = true
  if gamemode == GameMode_t.commercial then
    V_DrawPatchDirect(0, 0, 0, W_CacheLumpName("HELP", PU_CACHE))
  else if gamemode == GameMode_t.shareware or gamemode == GameMode_t.registered or gamemode == GameMode_t.retail then
    V_DrawPatchDirect(0, 0, 0, W_CacheLumpName("HELP1", PU_CACHE))
  end if
end function

/*
* Function: M_DrawReadThis2
* Purpose: Draws or renders output for the utility/math layer.
*/
function M_DrawReadThis2()
  global inhelpscreens
  inhelpscreens = true
  if gamemode == GameMode_t.retail or gamemode == GameMode_t.commercial then
    V_DrawPatchDirect(0, 0, 0, W_CacheLumpName("CREDIT", PU_CACHE))
  else if gamemode == GameMode_t.shareware or gamemode == GameMode_t.registered then
    V_DrawPatchDirect(0, 0, 0, W_CacheLumpName("HELP2", PU_CACHE))
  end if
end function

/*
* Function: M_DrawSound
* Purpose: Draws or renders output for the utility/math layer.
*/
function M_DrawSound()
  V_DrawPatchDirect(60, 38, 0, W_CacheLumpName("M_SVOL", PU_CACHE))
  M_DrawThermo(SoundDef.x, SoundDef.y + LINEHEIGHT *(sfx_vol + 1), 16, snd_SfxVolume)
  M_DrawThermo(SoundDef.x, SoundDef.y + LINEHEIGHT *(music_vol + 1), 16, snd_MusicVolume)
end function

/*
* Function: M_Sound
* Purpose: Implements the M_Sound routine for the utility/math layer.
*/
function M_Sound(choice)
  choice = choice
  M_SetupNextMenu(SoundDef)
end function

/*
* Function: M_SfxVol
* Purpose: Implements the M_SfxVol routine for the utility/math layer.
*/
function M_SfxVol(choice)
  global snd_SfxVolume
  if choice == 0 then
    if snd_SfxVolume > 0 then snd_SfxVolume = snd_SfxVolume - 1 end if
  else if choice == 1 then
    if snd_SfxVolume < 15 then snd_SfxVolume = snd_SfxVolume + 1 end if
  end if
  S_SetSfxVolume(snd_SfxVolume)
end function

/*
* Function: M_MusicVol
* Purpose: Implements the M_MusicVol routine for the utility/math layer.
*/
function M_MusicVol(choice)
  global snd_MusicVolume
  if choice == 0 then
    if snd_MusicVolume > 0 then snd_MusicVolume = snd_MusicVolume - 1 end if
  else if choice == 1 then
    if snd_MusicVolume < 15 then snd_MusicVolume = snd_MusicVolume + 1 end if
  end if
  S_SetMusicVolume(snd_MusicVolume)
end function

/*
* Function: M_DrawMainMenu
* Purpose: Draws or renders output for the utility/math layer.
*/
function M_DrawMainMenu()
  V_DrawPatchDirect(94, 2, 0, W_CacheLumpName("M_DOOM", PU_CACHE))
  y = MainDef.y + LINEHEIGHT * main_multiplayer + 1
  _MMENU_WriteTextMenuSized(MainDef.x, y, "MULTIPLAYER")
end function

/*
* Function: _MMENU_ClampInt
* Purpose: Clamps integer values for multiplayer setup fields.
*/
function _MMENU_ClampInt(v, lo, hi)
  vi = _MMENU_ToInt(v, 0)
  lo_i = _MMENU_ToInt(lo, 0)
  hi_i = _MMENU_ToInt(hi, lo_i)
  if hi_i < lo_i then
    t = lo_i
    lo_i = hi_i
    hi_i = t
  end if
  if vi < lo_i then return lo_i end if
  if vi > hi_i then return hi_i end if
  return vi
end function

/*
* Function: _MMENU_MPModeName
* Purpose: Returns localized text for multiplayer mode value.
*/
function inline _MMENU_MPModeName(mode)
  if mode == MP_MODE_DEATHMATCH then return "DEATHMATCH" end if
  return "COOPERATIVE"
end function

/*
* Function: _MMENU_MPSkillName
* Purpose: Returns UI text for host-selected skill level.
*/
function inline _MMENU_MPSkillName(skill)
  s = _MMENU_ToInt(skill, MP_SKILL_MEDIUM)
  if s <= MP_SKILL_BABY then return "I'M TOO YOUNG TO DIE" end if
  if s == MP_SKILL_EASY then return "HEY, NOT TOO ROUGH" end if
  if s == MP_SKILL_MEDIUM then return "HURT ME PLENTY" end if
  if s == MP_SKILL_HARD then return "ULTRA-VIOLENCE" end if
  if s == MP_SKILL_NIGHTMARE then return "NIGHTMARE!" end if
  return "HURT ME PLENTY"
end function

/*
* Function: _MMENU_MPLimitText
* Purpose: Formats deathmatch limits, including unlimited mode.
*/
function inline _MMENU_MPLimitText(v)
  if typeof(v) != "int" then return "0" end if
  if v <= 0 then return "UNLIMITED" end if
  return v
end function

/*
* Function: _MMENU_ToUpperAsciiString
* Purpose: Converts a string to uppercase for ASCII letters.
*/
function _MMENU_ToUpperAsciiString(s0)
  if typeof(s0) != "string" then return "" end if
  b = bytes(s0)
  i = 0
  while i < len(b)
    if b[i] >= 97 and b[i] <= 122 then b[i] = b[i] - 32 end if
    i = i + 1
  end while
  return decode(b)
end function

/*
* Function: _MMENU_ParseUnsignedTail
* Purpose: Parses a positive integer from a string tail, returning -1 on failure.
*/
function _MMENU_ParseUnsignedTail(s0, startIdx)
  if typeof(s0) != "string" then return -1 end if
  b = bytes(s0)
  if startIdx < 0 or startIdx >= len(b) then return -1 end if
  i = startIdx
  v = 0
  seen = false
  while i < len(b)
    c = b[i]
    if c < 48 or c > 57 then return -1 end if
    seen = true
    v = v * 10 +(c - 48)
    i = i + 1
  end while
  if not seen then return -1 end if
  return v
end function

/*
* Function: _MMENU_ParseMapToken
* Purpose: Parses MAPxx or ExMy map token and returns [episode,map].
*/
function _MMENU_ParseMapToken(mapToken)
  up = _MMENU_ToUpperAsciiString(mapToken)
  b = bytes(up)
  if len(b) >= 5 and b[0] == 77 and b[1] == 65 and b[2] == 80 then
    n = _MMENU_ParseUnsignedTail(up, 3)
    if n > 0 then return [1, n] end if
  end if

  if len(b) >= 4 and b[0] == 69 and b[2] == 77 then
    e = b[1] - 48
    m = b[3] - 48
    if e >= 1 and e <= 9 and m >= 1 and m <= 9 then
      return [e, m]
    end if
  end if
  return [1, 1]
end function

/*
* Function: _MMENU_StartMultiplayerGame
* Purpose: Starts local game session immediately using current MP session settings.
*/
function _MMENU_StartMultiplayerGame(mode, skill, mapToken, localSlot)
  global netgame
  global deathmatch
  global startskill
  global startepisode
  global startmap
  global autostart
  global playeringame
  global consoleplayer
  global displayplayer
  global advancedemo
  global demoplayback
  global usergame
  global paused

  m = _MMENU_ToInt(mode, MP_MODE_COOP)
  if m != MP_MODE_DEATHMATCH then m = MP_MODE_COOP end if
  sk = _MMENU_ClampInt(skill, MP_SKILL_BABY, MP_SKILL_NIGHTMARE)
  slot = _MMENU_ClampInt(_MMENU_ToInt(localSlot, 0), 0, MAXPLAYERS - 1)

  parsed = _MMENU_ParseMapToken(mapToken)
  e = 1
  mp = 1
  if typeof(parsed) == "array" and len(parsed) >= 2 then
    e = _MMENU_ToInt(parsed[0], 1)
    mp = _MMENU_ToInt(parsed[1], 1)
  end if

  if gamemode == GameMode_t.commercial then
    e = 1
    mp = _MMENU_ClampInt(mp, 1, 32)
  else
    maxEpisode = 4
    if gamemode == GameMode_t.shareware then
      maxEpisode = 1
    else if gamemode == GameMode_t.registered then
      maxEpisode = 3
    end if
    e = _MMENU_ClampInt(e, 1, maxEpisode)
    mp = _MMENU_ClampInt(mp, 1, 9)
  end if

  netgame = true
  deathmatch = (m == MP_MODE_DEATHMATCH)
  startskill = sk
  startepisode = e
  startmap = mp
  autostart = true
  advancedemo = false
  demoplayback = false
  usergame = true
  paused = false
  consoleplayer = slot
  displayplayer = slot

  if typeof(playeringame) == "array" then
    i = 0
    while i < len(playeringame)
      playeringame[i] = false
      i = i + 1
    end while
    if 0 < len(playeringame) then playeringame[0] = true end if
    if slot >= 0 and slot < len(playeringame) then playeringame[slot] = true end if
  end if

  if typeof(S_StopMusic) == "function" then
    S_StopMusic()
  end if
  G_DeferedInitNew(sk, e, mp)
end function

/*
* Function: _MMENU_SyncMPBuffers
* Purpose: Synchronizes editable menu buffers with multiplayer settings.
*/
function _MMENU_SyncMPBuffers()
  global mpNameBuf
  global mpNameOld
  global mpNameCharIndex
  global mpJoinHostBuf
  global mpJoinHostOld
  global mpJoinHostCharIndex
  if typeof(mpNameBuf) != "bytes" then mpNameBuf = bytes(MP_MAX_NAME_LEN + 1, 0) end if
  if typeof(mpNameOld) != "bytes" then mpNameOld = bytes(MP_MAX_NAME_LEN + 1, 0) end if
  if typeof(mpJoinHostBuf) != "bytes" then mpJoinHostBuf = bytes(64, 0) end if
  if typeof(mpJoinHostOld) != "bytes" then mpJoinHostOld = bytes(64, 0) end if
  _cstrFromString(mpNameBuf, MP_GetPlayerName())
  _cstrCopy(mpNameOld, mpNameBuf)
  mpNameCharIndex = _cstrLen(mpNameBuf)
  _cstrFromString(mpJoinHostBuf, mp_join_host)
  _cstrCopy(mpJoinHostOld, mpJoinHostBuf)
  mpJoinHostCharIndex = _cstrLen(mpJoinHostBuf)
end function

/*
* Function: M_Multiplayer
* Purpose: Opens the multiplayer root menu.
*/
function M_Multiplayer(choice)
  choice = choice
  MP_ClampSettings()
  MP_RebuildMapList()
  _MMENU_SyncMPBuffers()
  M_SetupNextMenu(MultiplayerDef)
end function

/*
* Function: M_DrawMultiplayerMenu
* Purpose: Draws the multiplayer root menu.
*/
function M_DrawMultiplayerMenu()
  _MMENU_WriteTextMenuSized(96, 20, "MULTIPLAYER")
  y0 = MultiplayerDef.y + LINEHEIGHT * mp_main_host
  y1 = MultiplayerDef.y + LINEHEIGHT * mp_main_join
  y2 = MultiplayerDef.y + LINEHEIGHT * mp_main_name
  _MMENU_WriteTextMenuSized(MultiplayerDef.x, y0, "HOST GAME")
  _MMENU_WriteTextMenuSized(MultiplayerDef.x, y1, "JOIN GAME")
  _MMENU_WriteTextMenuSized(MultiplayerDef.x, y2, "PLAYER NAME")
end function

/*
* Function: M_MPHostMenuOpen
* Purpose: Opens host setup menu and refreshes map/options state.
*/
function M_MPHostMenuOpen(choice)
  choice = choice
  MP_ClampSettings()
  MP_RebuildMapList()
  _MMENU_SyncMPBuffers()
  M_SetupNextMenu(MPHostDef)
end function

/*
* Function: M_MPJoinMenuOpen
* Purpose: Opens join setup menu and refreshes editable host values.
*/
function M_MPJoinMenuOpen(choice)
  choice = choice
  MP_ClampSettings()
  _MMENU_SyncMPBuffers()
  M_SetupNextMenu(MPJoinDef)
end function

/*
* Function: M_MPNameMenuOpen
* Purpose: Opens player-name editor menu.
*/
function M_MPNameMenuOpen(choice)
  choice = choice
  _MMENU_SyncMPBuffers()
  M_SetupNextMenu(MPNameDef)
end function

/*
* Function: M_DrawMPHostMenu
* Purpose: Draws host setup values for multiplayer dedicated server start.
*/
function M_DrawMPHostMenu()
  MP_ClampSettings()
  MP_RebuildMapList()
  _MMENU_WriteTextMenuSized(108, 16, "HOST GAME")
  y = MPHostDef.y
  x = MPHostDef.x
  y0 = y + LINEHEIGHT * mp_host_mode_item
  y1 = y + LINEHEIGHT * mp_host_map
  y2 = y + LINEHEIGHT * mp_host_skill_item
  y3 = y + LINEHEIGHT * mp_host_players
  y4 = y + LINEHEIGHT * mp_host_fraglimit
  y5 = y + LINEHEIGHT * mp_host_timelimit
  y6 = y + LINEHEIGHT * mp_host_port_item
  y7 = y + LINEHEIGHT * mp_host_start
  modeText = _MMENU_MPModeName(mp_host_mode)
  mapText = MP_GetSelectedMap()
  skillText = _MMENU_MPSkillName(mp_host_skill)
  fragText = _MMENU_MPLimitText(mp_dm_frag_limit)
  timeText = _MMENU_MPLimitText(mp_dm_time_limit)
  _MMENU_WriteTextMenuSized(x, y0, "MODE: " + modeText)
  _MMENU_WriteTextMenuSized(x, y1, "MAP: " + mapText)
  _MMENU_WriteTextMenuSized(x, y2, "SKILL: " + skillText)
  _MMENU_WriteTextMenuSized(x, y3, "MAX PLAYERS: " + mp_host_max_players)
  _MMENU_WriteTextMenuSized(x, y4, "FRAG LIMIT: " + fragText)
  _MMENU_WriteTextMenuSized(x, y5, "TIME LIMIT: " + timeText)
  _MMENU_WriteTextMenuSized(x, y6, "PORT: " + mp_host_port)
  _MMENU_WriteTextMenuSized(x, y7, "START HOST")
end function

/*
* Function: M_DrawMPJoinMenu
* Purpose: Draws join setup values and live host/name text editors.
*/
function M_DrawMPJoinMenu()
  _MMENU_WriteTextMenuSized(108, 16, "JOIN GAME")
  y = MPJoinDef.y
  x = MPJoinDef.x
  y0 = y + LINEHEIGHT * mp_join_host_item
  y1 = y + LINEHEIGHT * mp_join_port_item
  y2 = y + LINEHEIGHT * mp_join_start
  hostText = decodeZ(mpJoinHostBuf)
  _MMENU_WriteTextMenuSized(x, y0, "HOST: " + hostText)
  if mpJoinHostEnter != 0 then
    hostLine = "HOST: " + hostText
    tx = x + _MMENU_StringWidthMenuSized(hostLine)
    _MMENU_WriteTextMenuSized(tx, y0, "_")
  end if
  _MMENU_WriteTextMenuSized(x, y1, "PORT: " + mp_join_port)
  _MMENU_WriteTextMenuSized(x, y2, "JOIN")
end function

/*
* Function: M_DrawMPNameMenu
* Purpose: Draws player name editor with caret during text entry.
*/
function M_DrawMPNameMenu()
  _MMENU_WriteTextMenuSized(86, 24, "PLAYER NAME")
  y = MPNameDef.y
  x = MPNameDef.x
  y0 = y + LINEHEIGHT * mp_name_edit
  y1 = y + LINEHEIGHT * mp_name_done
  nameText = decodeZ(mpNameBuf)
  _MMENU_WriteTextMenuSized(x, y0, "NAME: " + nameText)
  if mpNameEnter != 0 then
    nameLine = "NAME: " + nameText
    tx = x + _MMENU_StringWidthMenuSized(nameLine)
    _MMENU_WriteTextMenuSized(tx, y0, "_")
  end if
  _MMENU_WriteTextMenuSized(x, y1, "DONE")
end function

/*
* Function: M_MPHostMode
* Purpose: Toggles host game mode between cooperative and deathmatch.
*/
function M_MPHostMode(choice)
  choice = choice
  if mp_host_mode == MP_MODE_COOP then
    MP_SetMode(MP_MODE_DEATHMATCH)
  else
    MP_SetMode(MP_MODE_COOP)
  end if
  MP_ClampSettings()
end function

/*
* Function: M_MPHostMap
* Purpose: Cycles host-selected map through detected WAD map list.
*/
function M_MPHostMap(choice)
  if choice == 0 then
    MP_StepMap(-1)
  else
    MP_StepMap(1)
  end if
end function

/*
* Function: M_MPHostSkill
* Purpose: Adjusts host-selected skill level.
*/
function M_MPHostSkill(choice)
  global mp_host_skill
  if choice == 0 then
    mp_host_skill = mp_host_skill - 1
  else
    mp_host_skill = mp_host_skill + 1
  end if
  mp_host_skill = _MMENU_ClampInt(mp_host_skill, MP_SKILL_BABY, MP_SKILL_NIGHTMARE)
end function

/*
* Function: M_MPHostPlayers
* Purpose: Adjusts host maximum players within protocol bounds.
*/
function M_MPHostPlayers(choice)
  global mp_host_max_players
  if choice == 0 then
    mp_host_max_players = mp_host_max_players - 1
  else
    mp_host_max_players = mp_host_max_players + 1
  end if
  MP_ClampSettings()
end function

/*
* Function: M_MPHostFragLimit
* Purpose: Adjusts deathmatch frag limit (0 means unlimited).
*/
function M_MPHostFragLimit(choice)
  global mp_dm_frag_limit
  if choice == 0 then
    mp_dm_frag_limit = mp_dm_frag_limit - 5
  else
    mp_dm_frag_limit = mp_dm_frag_limit + 5
  end if
  if mp_dm_frag_limit < 0 then mp_dm_frag_limit = 0 end if
  if mp_dm_frag_limit > 250 then mp_dm_frag_limit = 250 end if
  MP_ClampSettings()
end function

/*
* Function: M_MPHostTimeLimit
* Purpose: Adjusts deathmatch time limit in minutes (0 means unlimited).
*/
function M_MPHostTimeLimit(choice)
  global mp_dm_time_limit
  if choice == 0 then
    mp_dm_time_limit = mp_dm_time_limit - 5
  else
    mp_dm_time_limit = mp_dm_time_limit + 5
  end if
  if mp_dm_time_limit < 0 then mp_dm_time_limit = 0 end if
  if mp_dm_time_limit > 180 then mp_dm_time_limit = 180 end if
  MP_ClampSettings()
end function

/*
* Function: M_MPHostPort
* Purpose: Adjusts dedicated server listen port.
*/
function M_MPHostPort(choice)
  global mp_host_port
  if choice == 0 then
    mp_host_port = mp_host_port - 1
  else
    mp_host_port = mp_host_port + 1
  end if
  MP_ClampSettings()
end function

/*
* Function: M_MPHostStart
* Purpose: Starts dedicated host bootstrap through platform multiplayer hooks.
*/
function M_MPHostStart(choice)
  choice = choice
  MP_ClampSettings()
  MP_RebuildMapList()
  _MMENU_SyncMPBuffers()

  if not MP_UpdateIwadFingerprint() then
    M_StartMessage("MP host failed: unable to hash active IWAD.", 0, false)
    return
  end if

  if typeof(I_SetLoadingStatus) == "function" then I_SetLoadingStatus("Starting multiplayer host...") end if
  if typeof(I_LoadingPulse) == "function" then I_LoadingPulse() end if

  if typeof(MP_PlatformHostGame) == "function" then
    hostPort = mp_host_port
    hostMode = mp_host_mode
    hostSkill = mp_host_skill
    hostMap = MP_GetSelectedMap()
    hostPlayers = mp_host_max_players
    hostFrag = mp_dm_frag_limit
    hostTime = mp_dm_time_limit
    ok = MP_PlatformHostGame(hostPort, hostMode, hostSkill, hostMap, hostPlayers, hostFrag, hostTime)
    if ok then
      _MMENU_StartMultiplayerGame(hostMode, hostSkill, hostMap, 0)
      M_ClearMenus()
      return
    end if
  end if

  if typeof(I_SetLoadingStatus) == "function" then I_SetLoadingStatus("") end if
  reason = "Multiplayer host startup failed."
  if typeof(MP_PlatformGetLastError) == "function" then
    r = MP_PlatformGetLastError()
    if typeof(r) == "string" and r != "" then reason = r end if
  end if
  M_StartMessage(reason, 0, false)
end function

/*
* Function: M_MPJoinEditHost
* Purpose: Enters text edit mode for join target host string.
*/
function M_MPJoinEditHost(choice)
  global mpJoinHostEnter
  global mpJoinHostCharIndex
  choice = choice
  _MMENU_SyncMPBuffers()
  mpJoinHostEnter = 1
  mpJoinHostCharIndex = _cstrLen(mpJoinHostBuf)
  _cstrCopy(mpJoinHostOld, mpJoinHostBuf)
end function

/*
* Function: M_MPJoinPort
* Purpose: Adjusts join target UDP port.
*/
function M_MPJoinPort(choice)
  global mp_join_port
  if choice == 0 then
    mp_join_port = mp_join_port - 1
  else
    mp_join_port = mp_join_port + 1
  end if
  MP_ClampSettings()
end function

/*
* Function: M_MPJoinStart
* Purpose: Starts multiplayer join handshake via platform networking hooks.
*/
function M_MPJoinStart(choice)
  global mp_join_host
  choice = choice
  MP_ClampSettings()
  mp_join_host = decodeZ(mpJoinHostBuf)
  if mp_join_host == "" then
    M_StartMessage("Please enter a host address.", 0, false)
    return
  end if
  if not MP_UpdateIwadFingerprint() then
    M_StartMessage("MP join failed: unable to hash active IWAD.", 0, false)
    return
  end if

  if typeof(I_SetLoadingStatus) == "function" then I_SetLoadingStatus("Joining multiplayer game...") end if
  if typeof(I_LoadingPulse) == "function" then I_LoadingPulse() end if

  if typeof(MP_PlatformJoinGame) == "function" then
    ok = MP_PlatformJoinGame(mp_join_host, mp_join_port, MP_GetPlayerName())
    if ok then
      sessionMode = mp_host_mode
      sessionSkill = mp_host_skill
      sessionMap = MP_GetSelectedMap()
      if typeof(MP_PlatformGetSessionMode) == "function" then sessionMode = MP_PlatformGetSessionMode() end if
      if typeof(MP_PlatformGetSessionSkill) == "function" then sessionSkill = MP_PlatformGetSessionSkill() end if
      if typeof(MP_PlatformGetSessionMap) == "function" then sessionMap = MP_PlatformGetSessionMap() end if
      localSlot = 0
      if typeof(MP_PlatformGetLocalPlayerSlot) == "function" then localSlot = MP_PlatformGetLocalPlayerSlot() end if
      _MMENU_StartMultiplayerGame(sessionMode, sessionSkill, sessionMap, localSlot)
      M_ClearMenus()
      return
    end if
  end if

  if typeof(I_SetLoadingStatus) == "function" then I_SetLoadingStatus("") end if
  reason = "Multiplayer join failed."
  if typeof(MP_PlatformGetLastError) == "function" then
    r = MP_PlatformGetLastError()
    if typeof(r) == "string" and r != "" then reason = r end if
  end if
  M_StartMessage(reason, 0, false)
end function

/*
* Function: M_MPNameEdit
* Purpose: Enters text edit mode for multiplayer player name.
*/
function M_MPNameEdit(choice)
  global mpNameEnter
  global mpNameCharIndex
  choice = choice
  _MMENU_SyncMPBuffers()
  mpNameEnter = 1
  mpNameCharIndex = _cstrLen(mpNameBuf)
  _cstrCopy(mpNameOld, mpNameBuf)
end function

/*
* Function: M_MPNameDone
* Purpose: Applies name changes and closes player-name editor menu.
*/
function M_MPNameDone(choice)
  global mpNameEnter
  choice = choice
  if mpNameEnter != 0 then
    mpNameEnter = 0
  end if
  MP_SetPlayerName(decodeZ(mpNameBuf))
  _MMENU_SyncMPBuffers()
  M_SetupNextMenu(MultiplayerDef)
end function

/*
* Function: M_DrawNewGame
* Purpose: Draws or renders output for the utility/math layer.
*/
function M_DrawNewGame()
  V_DrawPatchDirect(96, 14, 0, W_CacheLumpName("M_NEWG", PU_CACHE))
  V_DrawPatchDirect(54, 38, 0, W_CacheLumpName("M_SKILL", PU_CACHE))
end function

/*
* Function: M_NewGame
* Purpose: Implements the M_NewGame routine for the utility/math layer.
*/
function M_NewGame(choice)
  choice = choice
  if netgame and not demoplayback then
    M_StartMessage(NEWGAME, 0, false)
    return
  end if

  if gamemode == GameMode_t.commercial then
    M_SetupNextMenu(NewDef)
  else
    M_SetupNextMenu(EpiDef)
  end if
end function

/*
* Function: M_DrawEpisode
* Purpose: Draws or renders output for the utility/math layer.
*/
function M_DrawEpisode()
  V_DrawPatchDirect(54, 38, 0, W_CacheLumpName("M_EPISOD", PU_CACHE))
end function

/*
* Function: M_VerifyNightmare
* Purpose: Implements the M_VerifyNightmare routine for the utility/math layer.
*/
function M_VerifyNightmare(ch)
  if ch != CH_Y then return end if
  G_DeferedInitNew(nightmare, epi + 1, 1)
  M_ClearMenus()
end function

/*
* Function: M_ChooseSkill
* Purpose: Implements the M_ChooseSkill routine for the utility/math layer.
*/
function M_ChooseSkill(choice)
  if choice == nightmare then
    M_StartMessage(NIGHTMARE, M_VerifyNightmare, true)
    return
  end if

  G_DeferedInitNew(choice, epi + 1, 1)
  M_ClearMenus()
end function

/*
* Function: M_Episode
* Purpose: Implements the M_Episode routine for the utility/math layer.
*/
function M_Episode(choice)
  global epi
  if gamemode == GameMode_t.shareware and choice != 0 then
    M_StartMessage(SWSTRING, 0, false)
    M_SetupNextMenu(ReadDef1)
    return
  end if

  if gamemode == GameMode_t.registered and choice > 2 then

    choice = 0
  end if

  epi = choice
  M_SetupNextMenu(NewDef)
end function

/*
* Function: M_DrawOptions
* Purpose: Draws or renders output for the utility/math layer.
*/
function M_DrawOptions()
  V_DrawPatchDirect(108, 15, 0, W_CacheLumpName("M_OPTTTL", PU_CACHE))

  V_DrawPatchDirect(OptionsDef.x + 175, OptionsDef.y + LINEHEIGHT * detail, 0,
  W_CacheLumpName(detailNames[detailLevel], PU_CACHE))

  V_DrawPatchDirect(OptionsDef.x + 120, OptionsDef.y + LINEHEIGHT * messages, 0,
  W_CacheLumpName(msgNames[showMessages], PU_CACHE))

  M_DrawThermo(OptionsDef.x, OptionsDef.y + LINEHEIGHT *(mousesens + 1), 10, mouseSensitivity)
  M_DrawThermo(OptionsDef.x, OptionsDef.y + LINEHEIGHT *(scrnsize + 1), 9, screenSize)
end function

/*
* Function: M_Options
* Purpose: Implements the M_Options routine for the utility/math layer.
*/
function M_Options(choice)
  choice = choice
  M_SetupNextMenu(OptionsDef)
end function

/*
* Function: M_ChangeMessages
* Purpose: Implements the M_ChangeMessages routine for the utility/math layer.
*/
function M_ChangeMessages(choice)
  global showMessages
  choice = choice
  showMessages = 1 - showMessages
  if showMessages == 0 then
    if typeof(players) == "array" and typeof(players[consoleplayer]) != "void" then
      players[consoleplayer].message = MSGOFF
    end if
  else
    if typeof(players) == "array" and typeof(players[consoleplayer]) != "void" then
      players[consoleplayer].message = MSGON
    end if
  end if

  message_dontfuckwithme = true
end function

/*
* Function: M_EndGameResponse
* Purpose: Implements the M_EndGameResponse routine for the utility/math layer.
*/
function M_EndGameResponse(ch)
  if ch != CH_Y then return end if
  currentMenu.lastOn = itemOn
  M_ClearMenus()
  D_StartTitle()
end function

/*
* Function: M_EndGame
* Purpose: Implements the M_EndGame routine for the utility/math layer.
*/
function M_EndGame(choice)
  choice = choice
  if not usergame then
    S_StartSound(0, sfxenum_t.sfx_oof)
    return
  end if

  if netgame then
    M_StartMessage(NETEND, 0, false)
    return
  end if

  M_StartMessage(ENDGAME, M_EndGameResponse, true)
end function

/*
* Function: M_ReadThis
* Purpose: Implements the M_ReadThis routine for the utility/math layer.
*/
function M_ReadThis(choice)
  choice = choice
  M_SetupNextMenu(ReadDef1)
end function

/*
* Function: M_ReadThis2
* Purpose: Implements the M_ReadThis2 routine for the utility/math layer.
*/
function M_ReadThis2(choice)
  choice = choice
  M_SetupNextMenu(ReadDef2)
end function

/*
* Function: M_FinishReadThis
* Purpose: Implements the M_FinishReadThis routine for the utility/math layer.
*/
function M_FinishReadThis(choice)
  choice = choice
  M_SetupNextMenu(MainDef)
end function

/*
* Function: M_QuitResponse
* Purpose: Implements the M_QuitResponse routine for the utility/math layer.
*/
function M_QuitResponse(ch)
  if not(ch == CH_Y or ch == KEY_ENTER) then return end if

  if not netgame then
    if gamemode == GameMode_t.commercial then
      S_StartSound(0, quitsounds2[(gametic >> 2) & 7])
    else
      S_StartSound(0, quitsounds[(gametic >> 2) & 7])
    end if
    I_WaitVBL(105)
  end if

  I_Quit()
end function

/*
* Function: M_QuitDOOM
* Purpose: Implements the M_QuitDOOM routine for the utility/math layer.
*/
function M_QuitDOOM(choice)
  global endstring
  choice = choice

  if language != Language_t.english then
    endstring = endmsg[0] + "\n\n" + DOSY
  else
    idx =(gametic %(NUM_QUITMESSAGES - 2)) + 1
    endstring = endmsg[idx] + "\n\n" + DOSY
  end if

  M_StartMessage(endstring, M_QuitResponse, true)
end function

/*
* Function: M_ChangeSensitivity
* Purpose: Implements the M_ChangeSensitivity routine for the utility/math layer.
*/
function M_ChangeSensitivity(choice)
  if choice == 0 then
    if mouseSensitivity > 0 then mouseSensitivity = mouseSensitivity - 1 end if
  else if choice == 1 then
    if mouseSensitivity < 9 then mouseSensitivity = mouseSensitivity + 1 end if
  end if
end function

/*
* Function: M_ChangeDetail
* Purpose: Implements the M_ChangeDetail routine for the utility/math layer.
*/
function M_ChangeDetail(choice)
  global detailLevel
  choice = choice
  detailLevel = 1 - detailLevel

  if typeof(R_SetViewSize) == "function" then
    R_SetViewSize(screenblocks, detailLevel)
  end if

  if typeof(players) == "array" and consoleplayer >= 0 and consoleplayer < len(players) then
    p = players[consoleplayer]
    if p is not void then
      if detailLevel == 0 then
        p.message = DETAILHI
      else
        p.message = DETAILLO
      end if
      players[consoleplayer] = p
    end if
  end if
end function

/*
* Function: M_SizeDisplay
* Purpose: Implements the M_SizeDisplay routine for the utility/math layer.
*/
function M_SizeDisplay(choice)
  global screenblocks
  global screenSize
  if choice == 0 then
    if screenSize > 0 then
      screenblocks = screenblocks - 1
      screenSize = screenSize - 1
    end if
  else if choice == 1 then
    if screenSize < 8 then
      screenblocks = screenblocks + 1
      screenSize = screenSize + 1
    end if
  end if

  R_SetViewSize(screenblocks, detailLevel)
end function

/*
* Function: M_DrawThermo
* Purpose: Draws or renders output for the utility/math layer.
*/
function M_DrawThermo(x, y, thermWidth, thermDot)
  xx = x
  V_DrawPatchDirect(xx, y, 0, W_CacheLumpName("M_THERML", PU_CACHE))
  xx = xx + 8
  for i = 0 to thermWidth - 1
    V_DrawPatchDirect(xx, y, 0, W_CacheLumpName("M_THERMM", PU_CACHE))
    xx = xx + 8
  end for
  V_DrawPatchDirect(xx, y, 0, W_CacheLumpName("M_THERMR", PU_CACHE))

  V_DrawPatchDirect((x + 8) + thermDot * 8, y, 0, W_CacheLumpName("M_THERMO", PU_CACHE))
end function

/*
* Function: M_DrawEmptyCell
* Purpose: Draws or renders output for the utility/math layer.
*/
function M_DrawEmptyCell(menu, item)
  V_DrawPatchDirect(menu.x - 10, menu.y + item * LINEHEIGHT - 1, 0,
  W_CacheLumpName("M_CELL1", PU_CACHE))
end function

/*
* Function: M_DrawSelCell
* Purpose: Draws or renders output for the utility/math layer.
*/
function M_DrawSelCell(menu, item)
  V_DrawPatchDirect(menu.x - 10, menu.y + item * LINEHEIGHT - 1, 0,
  W_CacheLumpName("M_CELL2", PU_CACHE))
end function

/*
* Function: M_StartMessage
* Purpose: Starts runtime behavior in the utility/math layer.
*/
function M_StartMessage(string, routine, input)
  global messageLastMenuActive
  global messageToPrint
  global messageString
  global messageRoutine
  global messageNeedsInput
  global menuactive
  messageLastMenuActive = menuactive
  messageToPrint = 1
  messageString = string
  messageRoutine = routine
  messageNeedsInput = input
  menuactive = true
end function

/*
* Function: M_StopMessage
* Purpose: Stops or tears down runtime behavior in the utility/math layer.
*/
function M_StopMessage()
  global menuactive
  global messageToPrint
  menuactive = messageLastMenuActive
  messageToPrint = 0
end function

/*
* Function: M_StringWidth
* Purpose: Implements the M_StringWidth routine for the utility/math layer.
*/
function M_StringWidth(string)
  b = _bytesOf(string)
  w = 0

  i = 0
  while i < len(b)
    c = b[i]
    if c == 0 or c == 10 then
      break
    end if

    c = _toupperByte(c) - HU_FONTSTART
    if c < 0 or c >= HU_FONTSIZE then
      w = w + 4
    else
      patch = hu_font[c]
      w = w + _patchWidth(patch)
    end if
    i = i + 1
  end while

  return w
end function

/*
* Function: M_StringHeight
* Purpose: Implements the M_StringHeight routine for the utility/math layer.
*/
function M_StringHeight(string)
  b = _bytesOf(string)
  height = _patchHeight(hu_font[0])
  if height <= 0 then height = 8 end if

  h = height
  for i = 0 to len(b) - 1
    if b[i] == 10 then
      h = h + height
    end if
  end for
  return h
end function

/*
* Function: M_WriteText
* Purpose: Implements the M_WriteText routine for the utility/math layer.
*/
function M_WriteText(x, y, string)
  b = _bytesOf(string)

  cx = x
  cy = y

  i = 0
  while i < len(b)
    c = b[i]
    i = i + 1

    if c == 0 then break end if

    if c == 10 then
      cx = x
      cy = cy + 12
      continue
    end if

    c = _toupperByte(c) - HU_FONTSTART
    if c < 0 or c >= HU_FONTSIZE then
      cx = cx + 4
      continue
    end if

    patch = hu_font[c]
    w = _patchWidth(patch)
    if cx + w > SCREENWIDTH then
      break
    end if

    V_DrawPatchDirect(cx, cy, 0, patch)
    cx = cx + w
  end while
end function

/*
* Function: _MMENU_DrawPatchScale2
* Purpose: Draws a Doom patch scaled to 2x into the destination screen.
*/
function _MMENU_DrawPatchScale2(x, y, scrn, patch)
  if typeof(patch) != "bytes" then return end if
  if len(patch) < 8 then return end if
  width = _patchWidth(patch)
  height = _patchHeight(patch)
  if width <= 0 or height <= 0 then return end if

  // decode signed offsets directly (same format used by V_DrawPatch)
  topoffset = patch[6] + (patch[7] << 8)
  if topoffset >= 32768 then topoffset = topoffset - 65536 end if
  leftoffset = patch[4] + (patch[5] << 8)
  if leftoffset >= 32768 then leftoffset = leftoffset - 65536 end if

  dy0 = y - topoffset * 2
  dx0 = x - leftoffset * 2
  if scrn == 0 then
    V_MarkRect(dx0, dy0, width * 2, height * 2)
  end if

  destscreen = screens[scrn]
  for col = 0 to width - 1
    if 8 + col * 4 + 3 >= len(patch) then break end if
    colofs = patch[8 + col * 4] | (patch[9 + col * 4] << 8) | (patch[10 + col * 4] << 16) | (patch[11 + col * 4] << 24)
    p = colofs
    while true
      if p < 0 or p + 1 >= len(patch) then break end if
      topdelta = patch[p]
      if topdelta == 255 then break end if
      length = patch[p + 1]
      src = p + 3
      if src < 0 or src + length - 1 >= len(patch) then break end if
      dx = dx0 + col * 2
      if dx >= 0 and dx < SCREENWIDTH then
        for i = 0 to length - 1
          sy = dy0 + (topdelta + i) * 2
          if sy >= 0 and sy < SCREENHEIGHT then
            c = patch[src + i]
            destscreen[sy * SCREENWIDTH + dx] = c
            if dx + 1 < SCREENWIDTH then destscreen[sy * SCREENWIDTH + dx + 1] = c end if
            if sy + 1 < SCREENHEIGHT then
              destscreen[(sy + 1) * SCREENWIDTH + dx] = c
              if dx + 1 < SCREENWIDTH then destscreen[(sy + 1) * SCREENWIDTH + dx + 1] = c end if
            end if
          end if
        end for
      end if
      p = p + length + 4
    end while
  end for
end function

/*
* Function: _MMENU_StringWidthMenuSized
* Purpose: Returns text width in pixels for 2x multiplayer menu font rendering.
*/
function _MMENU_StringWidthMenuSized(string)
  b = _bytesOf(string)
  w = 0
  i = 0
  while i < len(b)
    c = b[i]
    if c == 0 or c == 10 then break end if
    c = _toupperByte(c) - HU_FONTSTART
    if c < 0 or c >= HU_FONTSIZE then
      w = w + 10
    else
      patch = hu_font[c]
      w = w + _patchWidth(patch) * 2 + 2
    end if
    i = i + 1
  end while
  return w
end function

/*
* Function: _MMENU_WriteTextMenuSized
* Purpose: Draws highlighted menu text for multiplayer entries with menu-like visual weight.
*/
function _MMENU_WriteTextMenuSized(x, y, string)
  b = _bytesOf(string)
  cx = x
  cy = y
  i = 0
  while i < len(b)
    c = b[i]
    i = i + 1
    if c == 0 then break end if
    if c == 10 then
      cx = x
      cy = cy + 14
      continue
    end if

    c = _toupperByte(c) - HU_FONTSTART
    if c < 0 or c >= HU_FONTSIZE then
      cx = cx + 10
      continue
    end if

    patch = hu_font[c]
    w = _patchWidth(patch) * 2
    if cx + w + 2 > SCREENWIDTH then break end if

    _MMENU_DrawPatchScale2(cx, cy, 0, patch)
    cx = cx + w + 2
  end while
end function

_joywait = 0
_mousewait = 0
_mousey_acc = 0
_lasty = 0
_mousex_acc = 0
_lastx = 0

/*
* Function: _MMENU_HandleMPNameEditKey
* Purpose: Handles key input while multiplayer player-name editor is active.
*/
function _MMENU_HandleMPNameEditKey(ch)
  global mpNameEnter
  global mpNameCharIndex
  if mpNameEnter == 0 then return false end if

  if ch == KEY_BACKSPACE then
    if mpNameCharIndex > 0 then
      mpNameCharIndex = mpNameCharIndex - 1
      mpNameBuf[mpNameCharIndex] = 0
    end if
    return true
  end if

  if ch == KEY_ESCAPE then
    mpNameEnter = 0
    _cstrCopy(mpNameBuf, mpNameOld)
    mpNameCharIndex = _cstrLen(mpNameBuf)
    return true
  end if

  if ch == KEY_ENTER then
    mpNameEnter = 0
    MP_SetPlayerName(decodeZ(mpNameBuf))
    _MMENU_SyncMPBuffers()
    return true
  end if

  if ch >= 32 and ch <= 126 and mpNameCharIndex < MP_MAX_NAME_LEN then
    mpNameBuf[mpNameCharIndex] = ch
    mpNameCharIndex = mpNameCharIndex + 1
    mpNameBuf[mpNameCharIndex] = 0
  end if
  return true
end function

/*
* Function: _MMENU_HandleMPJoinHostEditKey
* Purpose: Handles key input while multiplayer join-host editor is active.
*/
function _MMENU_HandleMPJoinHostEditKey(ch)
  global mpJoinHostEnter
  global mpJoinHostCharIndex
  global mp_join_host
  if mpJoinHostEnter == 0 then return false end if

  if ch == KEY_BACKSPACE then
    if mpJoinHostCharIndex > 0 then
      mpJoinHostCharIndex = mpJoinHostCharIndex - 1
      mpJoinHostBuf[mpJoinHostCharIndex] = 0
    end if
    return true
  end if

  if ch == KEY_ESCAPE then
    mpJoinHostEnter = 0
    _cstrCopy(mpJoinHostBuf, mpJoinHostOld)
    mpJoinHostCharIndex = _cstrLen(mpJoinHostBuf)
    return true
  end if

  if ch == KEY_ENTER then
    mpJoinHostEnter = 0
    mp_join_host = decodeZ(mpJoinHostBuf)
    MP_ClampSettings()
    _MMENU_SyncMPBuffers()
    return true
  end if

  if ch >= 32 and ch <= 126 and mpJoinHostCharIndex < len(mpJoinHostBuf) - 1 then
    mpJoinHostBuf[mpJoinHostCharIndex] = ch
    mpJoinHostCharIndex = mpJoinHostCharIndex + 1
    mpJoinHostBuf[mpJoinHostCharIndex] = 0
  end if
  return true
end function

/*
* Function: M_Responder
* Purpose: Implements the M_Responder routine for the utility/math layer.
*/
function M_Responder(ev)
  global _joywait
  global _mousewait
  global _mousey_acc
  global _lasty
  global _mousex_acc
  global _lastx
  global saveCharIndex
  global saveStringEnter
  global messageToPrint
  global menuactive
  global currentMenu
  global itemOn
  global usegamma
  ch = -1

  if ev.type == evtype_t.ev_joystick and _joywait < I_GetTime() then
    if ev.data3 == -1 then
      ch = KEY_UPARROW
      _joywait = I_GetTime() + 5
    else if ev.data3 == 1 then
      ch = KEY_DOWNARROW
      _joywait = I_GetTime() + 5
    end if

    if ev.data2 == -1 then
      ch = KEY_LEFTARROW
      _joywait = I_GetTime() + 2
    else if ev.data2 == 1 then
      ch = KEY_RIGHTARROW
      _joywait = I_GetTime() + 2
    end if

    if (ev.data1 & 1) != 0 then
      ch = KEY_ENTER
      _joywait = I_GetTime() + 5
    end if
    if (ev.data1 & 2) != 0 then
      ch = KEY_BACKSPACE
      _joywait = I_GetTime() + 5
    end if

  else

    if ev.type == evtype_t.ev_mouse and _mousewait < I_GetTime() then
      _mousey_acc = _mousey_acc + ev.data3
      if _mousey_acc < _lasty - 30 then
        ch = KEY_DOWNARROW
        _mousewait = I_GetTime() + 5
        _lasty = _lasty - 30
        _mousey_acc = _lasty
      else if _mousey_acc > _lasty + 30 then
        ch = KEY_UPARROW
        _mousewait = I_GetTime() + 5
        _lasty = _lasty + 30
        _mousey_acc = _lasty
      end if

      _mousex_acc = _mousex_acc + ev.data2
      if _mousex_acc < _lastx - 30 then
        ch = KEY_LEFTARROW
        _mousewait = I_GetTime() + 5
        _lastx = _lastx - 30
        _mousex_acc = _lastx
      else if _mousex_acc > _lastx + 30 then
        ch = KEY_RIGHTARROW
        _mousewait = I_GetTime() + 5
        _lastx = _lastx + 30
        _mousex_acc = _lastx
      end if

      if (ev.data1 & 1) != 0 then
        ch = KEY_ENTER
        _mousewait = I_GetTime() + 15
      end if
      if (ev.data1 & 2) != 0 then
        ch = KEY_BACKSPACE
        _mousewait = I_GetTime() + 15
      end if

    else

      if ev.type == evtype_t.ev_keydown then
        ch = ev.data1
      end if

    end if
  end if

  if ch == -1 then return false end if

  if _MMENU_HandleMPNameEditKey(ch) then
    return true
  end if

  if _MMENU_HandleMPJoinHostEditKey(ch) then
    return true
  end if

  if saveStringEnter != 0 then
    if ch == KEY_BACKSPACE then
      if saveCharIndex > 0 then
        saveCharIndex = saveCharIndex - 1
        savegamestrings[saveSlot][saveCharIndex] = 0
      end if

    else if ch == KEY_ESCAPE then
      saveStringEnter = 0
      _cstrCopy(savegamestrings[saveSlot], saveOldString)

    else if ch == KEY_ENTER then
      saveStringEnter = 0
      if savegamestrings[saveSlot][0] != 0 then
        M_DoSave(saveSlot)
      end if

    else
      ch2 = _toupperByte(ch)
      if ch2 != CH_SPACE then
        idx = ch2 - HU_FONTSTART
        if idx < 0 or idx >= HU_FONTSIZE then
          return true
        end if
      end if

      if ch2 >= 32 and ch2 <= 127 and saveCharIndex < SAVESTRINGSIZE - 1 and
        M_StringWidth(savegamestrings[saveSlot]) <(SAVESTRINGSIZE - 2) * 8 then
        savegamestrings[saveSlot][saveCharIndex] = ch2
        saveCharIndex = saveCharIndex + 1
        savegamestrings[saveSlot][saveCharIndex] = 0
      end if
    end if

    return true
  end if

  if messageToPrint != 0 then
    if messageNeedsInput and not(ch == CH_SPACE or ch == CH_N or ch == CH_Y or ch == KEY_ESCAPE) then
      return false
    end if

    menuactive = messageLastMenuActive
    messageToPrint = 0
    if typeof(messageRoutine) == "function" then
      messageRoutine(ch)
    end if
    S_StartSound(0, sfxenum_t.sfx_swtchx)
    return true
  end if

  if devparm and ch == KEY_F1 then
    G_ScreenShot()
    return true
  end if

  if not menuactive then
    if ch == KEY_MINUS then
      if automapactive or chat_on then return false end if
      M_SizeDisplay(0)
      S_StartSound(0, sfxenum_t.sfx_stnmov)
      return true

    else if ch == KEY_EQUALS then
      if automapactive or chat_on then return false end if
      M_SizeDisplay(1)
      S_StartSound(0, sfxenum_t.sfx_stnmov)
      return true

    else if ch == KEY_F1 then
      M_StartControlPanel()
      if gamemode == GameMode_t.retail then
        currentMenu = ReadDef2
      else
        currentMenu = ReadDef1
      end if
      itemOn = 0
      S_StartSound(0, sfxenum_t.sfx_swtchn)
      return true

    else if ch == KEY_F2 then
      M_StartControlPanel()
      S_StartSound(0, sfxenum_t.sfx_swtchn)
      M_SaveGame(0)
      return true

    else if ch == KEY_F3 then
      M_StartControlPanel()
      S_StartSound(0, sfxenum_t.sfx_swtchn)
      M_LoadGame(0)
      return true

    else if ch == KEY_F4 then
      M_StartControlPanel()
      currentMenu = SoundDef
      itemOn = sfx_vol
      S_StartSound(0, sfxenum_t.sfx_swtchn)
      return true

    else if ch == KEY_F5 then
      M_ChangeDetail(0)
      S_StartSound(0, sfxenum_t.sfx_swtchn)
      return true

    else if ch == KEY_F6 then
      S_StartSound(0, sfxenum_t.sfx_swtchn)
      M_QuickSave()
      return true

    else if ch == KEY_F7 then
      S_StartSound(0, sfxenum_t.sfx_swtchn)
      M_EndGame(0)
      return true

    else if ch == KEY_F8 then
      M_ChangeMessages(0)
      S_StartSound(0, sfxenum_t.sfx_swtchn)
      return true

    else if ch == KEY_F9 then
      S_StartSound(0, sfxenum_t.sfx_swtchn)
      M_QuickLoad()
      return true

    else if ch == KEY_F10 then
      S_StartSound(0, sfxenum_t.sfx_swtchn)
      M_QuitDOOM(0)
      return true

    else if ch == KEY_F11 then
      usegamma = usegamma + 1
      if usegamma > 4 then usegamma = 0 end if
      if typeof(players) == "array" and typeof(players[consoleplayer]) != "void" then
        players[consoleplayer].message = gammamsg[usegamma]
      end if
      I_SetPalette(W_CacheLumpName("PLAYPAL", PU_CACHE))
      return true
    end if
  end if

  if not menuactive then
    if ch == KEY_ESCAPE then
      M_StartControlPanel()
      S_StartSound(0, sfxenum_t.sfx_swtchn)
      return true
    end if
    return false
  end if

  menuCount = _MMENU_ClampCursor()
  if menuCount <= 0 then return true end if

  if ch == KEY_DOWNARROW then
    steps = 0
    loop
      if itemOn + 1 > menuCount - 1 then
        itemOn = 0
      else
        itemOn = itemOn + 1
      end if
      S_StartSound(0, sfxenum_t.sfx_pstop)
      steps = steps + 1
      if steps >= menuCount then break end if
      while currentMenu.menuitems[itemOn].status == -1
      end loop
      return true

    else if ch == KEY_UPARROW then
      steps = 0
      loop
        if itemOn == 0 then
          itemOn = menuCount - 1
        else
          itemOn = itemOn - 1
        end if
        S_StartSound(0, sfxenum_t.sfx_pstop)
        steps = steps + 1
        if steps >= menuCount then break end if
        while currentMenu.menuitems[itemOn].status == -1
        end loop
        return true

      else if ch == KEY_LEFTARROW then
        if currentMenu.menuitems[itemOn].routine != 0 and currentMenu.menuitems[itemOn].status == 2 then
          S_StartSound(0, sfxenum_t.sfx_stnmov)
          currentMenu.menuitems[itemOn].routine(0)
        end if
        return true

      else if ch == KEY_RIGHTARROW then
        if currentMenu.menuitems[itemOn].routine != 0 and currentMenu.menuitems[itemOn].status == 2 then
          S_StartSound(0, sfxenum_t.sfx_stnmov)
          currentMenu.menuitems[itemOn].routine(1)
        end if
        return true

      else if ch == KEY_ENTER then
        if currentMenu.menuitems[itemOn].routine != 0 and currentMenu.menuitems[itemOn].status != 0 then
          currentMenu.lastOn = itemOn
          if currentMenu.menuitems[itemOn].status == 2 then
            currentMenu.menuitems[itemOn].routine(1)
            S_StartSound(0, sfxenum_t.sfx_stnmov)
          else
            currentMenu.menuitems[itemOn].routine(itemOn)
            S_StartSound(0, sfxenum_t.sfx_pistol)
          end if
        end if
        return true

      else if ch == KEY_ESCAPE then
        currentMenu.lastOn = itemOn
        M_ClearMenus()
        S_StartSound(0, sfxenum_t.sfx_swtchx)
        return true

      else if ch == KEY_BACKSPACE then
        currentMenu.lastOn = itemOn
        if currentMenu.prevMenu != 0 then
          currentMenu = currentMenu.prevMenu
          itemOn = currentMenu.lastOn
          _MMENU_ClampCursor()
          S_StartSound(0, sfxenum_t.sfx_swtchn)
        end if
        return true

      else

        for i = itemOn + 1 to menuCount - 1
          if currentMenu.menuitems[i].alphaKey == ch then
            itemOn = i
            S_StartSound(0, sfxenum_t.sfx_pstop)
            return true
          end if
        end for
        for i = 0 to itemOn
          if currentMenu.menuitems[i].alphaKey == ch then
            itemOn = i
            S_StartSound(0, sfxenum_t.sfx_pstop)
            return true
          end if
        end for
      end if

      return false
    end function

    /*
    * Function: M_StartControlPanel
    * Purpose: Starts runtime behavior in the utility/math layer.
    */
    function M_StartControlPanel()
      global menuactive
      global currentMenu
      global itemOn
      if menuactive then return end if
      menuactive = true
      currentMenu = MainDef
      itemOn = currentMenu.lastOn
      _MMENU_ClampCursor()
    end function

    /*
    * Function: M_Drawer
    * Purpose: Draws or renders output for the utility/math layer.
    */
    function M_Drawer()
      global inhelpscreens
      inhelpscreens = false

      if messageToPrint != 0 then

        y = 100 - _MMENU_IDiv(M_StringHeight(messageString), 2)
        b = _bytesOf(messageString)
        start = 0

        while start < len(b)

          i = start
          while i < len(b) and b[i] != 10 and b[i] != 0
            i = i + 1
          end while

          line = slice(b, start, i - start)
          x = 160 - _MMENU_IDiv(M_StringWidth(line), 2)
          M_WriteText(x, y, line)
          y = y + _patchHeight(hu_font[0])

          if i < len(b) and b[i] == 10 then
            start = i + 1
          else
            start = i

            if start >= len(b) then break end if
            if b[start] == 0 then break end if
          end if
        end while

        return
      end if

      if not menuactive then return end if

      if currentMenu.routine != 0 then
        currentMenu.routine()
      end if

      x = currentMenu.x
      y = currentMenu.y
      max = _MMENU_ItemCount(currentMenu)
      if max <= 0 then return end if
      _MMENU_ClampCursor()

      for i = 0 to max - 1
        nm = currentMenu.menuitems[i].name
        if typeof(nm) == "string" and len(nm) > 0 then
          V_DrawPatchDirect(x, y, 0, W_CacheLumpName(nm, PU_CACHE))
        end if
        y = y + LINEHEIGHT
      end for

      V_DrawPatchDirect(x + SKULLXOFF, currentMenu.y - 5 + itemOn * LINEHEIGHT, 0,
      W_CacheLumpName(skullName[whichSkull], PU_CACHE))
    end function

    /*
    * Function: M_ClearMenus
    * Purpose: Implements the M_ClearMenus routine for the utility/math layer.
    */
    function M_ClearMenus()
      global menuactive
      global mpNameEnter
      global mpJoinHostEnter

      menuactive = false
      mpNameEnter = 0
      mpJoinHostEnter = 0
    end function

    /*
    * Function: M_SetupNextMenu
    * Purpose: Reads or updates state used by the utility/math layer.
    */
    function M_SetupNextMenu(menudef)
      global currentMenu
      global itemOn
      global mpNameEnter
      global mpJoinHostEnter

      currentMenu = menudef
      itemOn = currentMenu.lastOn
      mpNameEnter = 0
      mpJoinHostEnter = 0
      _MMENU_ClampCursor()
    end function

    /*
    * Function: M_Ticker
    * Purpose: Advances per-tick logic for the utility/math layer.
    */
function M_Ticker()
  global skullAnimCounter
  global whichSkull

  if typeof(MP_PlatformPump) == "function" then MP_PlatformPump() end if

  skullAnimCounter = skullAnimCounter - 1
  if skullAnimCounter <= 0 then
    whichSkull = whichSkull ^ 1
    skullAnimCounter = 8
      end if
    end function

    /*
    * Function: M_Init
    * Purpose: Initializes state and dependencies for the utility/math layer.
    */
    function M_Init()
      global currentMenu
      global menuactive
      global itemOn
      global whichSkull
      global skullAnimCounter
      global screenSize
      global messageToPrint
      global messageString
      global messageLastMenuActive
      global quickSaveSlot
      global savegamestrings
      global saveOldString
      global mp_host_skill
      global mpNameEnter
      global mpNameCharIndex
      global mpNameBuf
      global mpNameOld
      global mpJoinHostEnter
      global mpJoinHostCharIndex
      global mpJoinHostBuf
      global mpJoinHostOld

      _BuildMenus()
      MP_ClampSettings()
      MP_RebuildMapList()

      currentMenu = MainDef
      menuactive = false
      itemOn = currentMenu.lastOn
      whichSkull = 0
      skullAnimCounter = 10
      screenSize = screenblocks - 3

      messageToPrint = 0
      messageString = ""
      messageLastMenuActive = menuactive

      quickSaveSlot = -1

      savegamestrings =[]
      for i = 0 to load_end - 1
        savegamestrings = savegamestrings +[bytes(SAVESTRINGSIZE, 0)]
      end for
      saveOldString = bytes(SAVESTRINGSIZE, 0)

      if typeof(mp_host_skill) != "int" then
        mp_host_skill = MP_SKILL_MEDIUM
      end if
      mp_host_skill = _MMENU_ClampInt(mp_host_skill, MP_SKILL_BABY, MP_SKILL_NIGHTMARE)
      mpNameEnter = 0
      mpNameCharIndex = 0
      mpNameBuf = bytes(MP_MAX_NAME_LEN + 1, 0)
      mpNameOld = bytes(MP_MAX_NAME_LEN + 1, 0)
      mpJoinHostEnter = 0
      mpJoinHostCharIndex = 0
      mpJoinHostBuf = bytes(64, 0)
      mpJoinHostOld = bytes(64, 0)
      _MMENU_SyncMPBuffers()

      if gamemode == GameMode_t.commercial then

        MainMenu[main_readthis] = MainMenu[main_quitdoom]
        MainDef.numitems = MainDef.numitems - 1
        MainDef.y = MainDef.y + 8
        NewDef.prevMenu = MainDef
        ReadDef1.routine = M_DrawReadThis1
        ReadDef1.x = 330
        ReadDef1.y = 165
        ReadMenu1[0].routine = M_FinishReadThis

      else if gamemode == GameMode_t.shareware or gamemode == GameMode_t.registered then

        EpiDef.numitems = EpiDef.numitems - 1

      else

      end if
    end function



