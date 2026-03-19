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

  Script: st_stuff.ml
  Purpose: Implements status bar and HUD presentation logic.
*/
import doomtype
import d_event
import i_system
import i_video
import z_zone
import m_random
import w_wad
import doomdef
import g_game
import st_lib
import r_local
import r_main
import p_local
import p_inter
import am_map
import m_cheat
import s_sound
import v_video
import doomstat
import dstrings
import sounds
import d_items

const ST_HEIGHT = 32
const ST_WIDTH = 320
const ST_Y = 168

const STARTREDPALS = 1
const STARTBONUSPALS = 9
const NUMREDPALS = 8
const NUMBONUSPALS = 4
const RADIATIONPAL = 13

const ST_FX = 143
const ST_FY = 169

const ST_NUMPAINFACES = 5
const ST_NUMSTRAIGHTFACES = 3
const ST_NUMTURNFACES = 2
const ST_NUMSPECIALFACES = 3
const ST_FACESTRIDE = ST_NUMSTRAIGHTFACES + ST_NUMTURNFACES + ST_NUMSPECIALFACES
const ST_NUMEXTRAFACES = 2
const ST_NUMFACES = ST_FACESTRIDE * ST_NUMPAINFACES + ST_NUMEXTRAFACES
const ST_TURNOFFSET = ST_NUMSTRAIGHTFACES
const ST_OUCHOFFSET = ST_TURNOFFSET + ST_NUMTURNFACES
const ST_EVILGRINOFFSET = ST_OUCHOFFSET + 1
const ST_RAMPAGEOFFSET = ST_EVILGRINOFFSET + 1
const ST_GODFACE = ST_NUMPAINFACES * ST_FACESTRIDE
const ST_DEADFACE = ST_GODFACE + 1
const ST_FACESX = 143
const ST_FACESY = 168
const ST_EVILGRINCOUNT = 2 * TICRATE
const ST_STRAIGHTFACECOUNT = TICRATE >> 1
const ST_TURNCOUNT = TICRATE
const ST_RAMPAGEDELAY = 2 * TICRATE
const ST_MUCHPAIN = 20

const ST_AMMOWIDTH = 3
const ST_AMMOX = 44
const ST_AMMOY = 171

const ST_HEALTHWIDTH = 3
const ST_HEALTHX = 90
const ST_HEALTHY = 171

const ST_ARMSX = 111
const ST_ARMSY = 172
const ST_ARMSBGX = 104
const ST_ARMSBGY = 168
const ST_ARMSXSPACE = 12
const ST_ARMSYSPACE = 10

const ST_FRAGSX = 138
const ST_FRAGSY = 171
const ST_FRAGSWIDTH = 2

const ST_ARMORWIDTH = 3
const ST_ARMORX = 221
const ST_ARMORY = 171

const ST_KEY0X = 239
const ST_KEY0Y = 171
const ST_KEY1X = 239
const ST_KEY1Y = 181
const ST_KEY2X = 239
const ST_KEY2Y = 191

const ST_AMMO0WIDTH = 3
const ST_AMMO0X = 288
const ST_AMMO0Y = 173
const ST_AMMO1WIDTH = ST_AMMO0WIDTH
const ST_AMMO1X = 288
const ST_AMMO1Y = 179
const ST_AMMO2WIDTH = ST_AMMO0WIDTH
const ST_AMMO2X = 288
const ST_AMMO2Y = 191
const ST_AMMO3WIDTH = ST_AMMO0WIDTH
const ST_AMMO3X = 288
const ST_AMMO3Y = 185

const ST_MAXAMMO0WIDTH = 3
const ST_MAXAMMO0X = 314
const ST_MAXAMMO0Y = 173
const ST_MAXAMMO1WIDTH = ST_MAXAMMO0WIDTH
const ST_MAXAMMO1X = 314
const ST_MAXAMMO1Y = 179
const ST_MAXAMMO2WIDTH = ST_MAXAMMO0WIDTH
const ST_MAXAMMO2X = 314
const ST_MAXAMMO2Y = 191
const ST_MAXAMMO3WIDTH = ST_MAXAMMO0WIDTH
const ST_MAXAMMO3X = 314
const ST_MAXAMMO3Y = 185

/*
* Enum: st_stateenum_t
* Purpose: Defines named constants for st stateenum type.
*/
enum st_stateenum_t
  AutomapState = 0
  FirstPersonState = 1
end enum

/*
* Enum: st_chatstateenum_t
* Purpose: Defines named constants for st chatstateenum type.
*/
enum st_chatstateenum_t
  StartChatState = 0
  WaitDestState = 1
  GetChatState = 2
end enum

st_firsttime = true
st_started = false

lu_palette = -1
st_clock = 0
st_msgcounter = 0
st_chatstate = st_chatstateenum_t.StartChatState
st_state = st_stateenum_t.FirstPersonState
st_palette = 0

st_statusbaron_ref =[true]
st_notdeathmatch_ref =[true]
st_armson_ref =[true]
st_fragson_ref =[false]

st_chat = false
st_oldchat = false
st_cursoron = false

st_plyr = void

st_stbar = void
st_faceback = void
st_armsbg_patch = void
st_tallnum =[]
st_tallpercent = void
st_shortnum =[]
st_keys =[]
st_faces =[]
st_arms_patches =[[void, void],[void, void],[void, void],[void, void],[void, void],[void, void]]

st_ready_ref =[1994]
st_health_ref =[100]
st_armor_ref =[0]
st_frags_ref =[0]
st_face_ref =[0]
st_keyrefs =[[-1],[-1],[-1]]
st_weaponowned_refs =[[0],[0],[0],[0],[0],[0]]
st_ammo_refs =[[0],[0],[0],[0]]
st_maxammo_refs =[[0],[0],[0],[0]]

w_ready = st_number_t(0, 0, 0, 0, st_ready_ref, st_statusbaron_ref, st_tallnum, 0)
w_frags = st_number_t(0, 0, 0, 0, st_frags_ref, st_fragson_ref, st_tallnum, 0)
w_health = st_percent_t(st_number_t(0, 0, 0, 0, st_health_ref, st_statusbaron_ref, st_tallnum, 0), st_tallpercent)
w_armsbg = st_binicon_t(0, 0, false, st_notdeathmatch_ref, st_statusbaron_ref, st_armsbg_patch, 0)
w_faces = st_multicon_t(0, 0, -1, st_face_ref, st_statusbaron_ref, st_faces, 0)
w_armor = st_percent_t(st_number_t(0, 0, 0, 0, st_armor_ref, st_statusbaron_ref, st_tallnum, 0), st_tallpercent)
w_arms =[
st_multicon_t(0, 0, -1, st_weaponowned_refs[0], st_armson_ref, st_arms_patches[0], 0),
st_multicon_t(0, 0, -1, st_weaponowned_refs[1], st_armson_ref, st_arms_patches[1], 0),
st_multicon_t(0, 0, -1, st_weaponowned_refs[2], st_armson_ref, st_arms_patches[2], 0),
st_multicon_t(0, 0, -1, st_weaponowned_refs[3], st_armson_ref, st_arms_patches[3], 0),
st_multicon_t(0, 0, -1, st_weaponowned_refs[4], st_armson_ref, st_arms_patches[4], 0),
st_multicon_t(0, 0, -1, st_weaponowned_refs[5], st_armson_ref, st_arms_patches[5], 0)
]
w_keyboxes =[
st_multicon_t(0, 0, -1, st_keyrefs[0], st_statusbaron_ref, st_keys, 0),
st_multicon_t(0, 0, -1, st_keyrefs[1], st_statusbaron_ref, st_keys, 0),
st_multicon_t(0, 0, -1, st_keyrefs[2], st_statusbaron_ref, st_keys, 0)
]
w_ammo =[
st_number_t(0, 0, 0, 0, st_ammo_refs[0], st_statusbaron_ref, st_shortnum, 0),
st_number_t(0, 0, 0, 0, st_ammo_refs[1], st_statusbaron_ref, st_shortnum, 0),
st_number_t(0, 0, 0, 0, st_ammo_refs[2], st_statusbaron_ref, st_shortnum, 0),
st_number_t(0, 0, 0, 0, st_ammo_refs[3], st_statusbaron_ref, st_shortnum, 0)
]
w_maxammo =[
st_number_t(0, 0, 0, 0, st_maxammo_refs[0], st_statusbaron_ref, st_shortnum, 0),
st_number_t(0, 0, 0, 0, st_maxammo_refs[1], st_statusbaron_ref, st_shortnum, 0),
st_number_t(0, 0, 0, 0, st_maxammo_refs[2], st_statusbaron_ref, st_shortnum, 0),
st_number_t(0, 0, 0, 0, st_maxammo_refs[3], st_statusbaron_ref, st_shortnum, 0)
]

st_facecount = 0
st_faceindex = 0
st_facepriority = 0
st_oldhealth = -1
st_oldweaponsowned =[]
st_lastattackdown = -1
st_randomnumber = 0
st_lastcalc = 0
st_calc_oldhealth = -1

cheat_mus = cheatseq_t(bytes([0xb2, 0x26, 0xb6, 0xae, 0xea, 1, 0, 0, 0xff]), 0)
cheat_choppers = cheatseq_t(bytes([0xb2, 0x26, 0xe2, 0x32, 0xf6, 0x2a, 0x2a, 0xa6, 0x6a, 0xea, 0xff]), 0)
cheat_god = cheatseq_t(bytes([0xb2, 0x26, 0x26, 0xaa, 0x26, 0xff]), 0)
cheat_ammo = cheatseq_t(bytes([0xb2, 0x26, 0xf2, 0x66, 0xa2, 0xff]), 0)
cheat_ammonokey = cheatseq_t(bytes([0xb2, 0x26, 0x66, 0xa2, 0xff]), 0)
cheat_noclip = cheatseq_t(bytes([0xb2, 0x26, 0xea, 0x2a, 0xb2, 0xea, 0x2a, 0xf6, 0x2a, 0x26, 0xff]), 0)
cheat_commercial_noclip = cheatseq_t(bytes([0xb2, 0x26, 0xe2, 0x36, 0xb2, 0x2a, 0xff]), 0)
cheat_powerup =[
cheatseq_t(bytes([0xb2, 0x26, 0x62, 0xa6, 0x32, 0xf6, 0x36, 0x26, 0x6e, 0xff]), 0),
cheatseq_t(bytes([0xb2, 0x26, 0x62, 0xa6, 0x32, 0xf6, 0x36, 0x26, 0xea, 0xff]), 0),
cheatseq_t(bytes([0xb2, 0x26, 0x62, 0xa6, 0x32, 0xf6, 0x36, 0x26, 0xb2, 0xff]), 0),
cheatseq_t(bytes([0xb2, 0x26, 0x62, 0xa6, 0x32, 0xf6, 0x36, 0x26, 0x6a, 0xff]), 0),
cheatseq_t(bytes([0xb2, 0x26, 0x62, 0xa6, 0x32, 0xf6, 0x36, 0x26, 0xa2, 0xff]), 0),
cheatseq_t(bytes([0xb2, 0x26, 0x62, 0xa6, 0x32, 0xf6, 0x36, 0x26, 0x36, 0xff]), 0),
cheatseq_t(bytes([0xb2, 0x26, 0x62, 0xa6, 0x32, 0xf6, 0x36, 0x26, 0xff]), 0)
]
cheat_clev = cheatseq_t(bytes([0xb2, 0x26, 0xe2, 0x36, 0xa6, 0x6e, 1, 0, 0, 0xff]), 0)
cheat_mypos = cheatseq_t(bytes([0xb2, 0x26, 0xb6, 0xba, 0x2a, 0xf6, 0xea, 0xff]), 0)

/*
* Function: _ST_Player
* Purpose: Implements the _ST_Player routine for the internal module support.
*/
function _ST_Player()
  if typeof(players) != "array" then return void end if
  if typeof(consoleplayer) != "int" then return void end if
  if consoleplayer < 0 or consoleplayer >= len(players) then return void end if
  return players[consoleplayer]
end function

/*
* Function: _ST_ToInt
* Purpose: Implements the _ST_ToInt routine for the internal module support.
*/
function _ST_ToInt(v, fallback)
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
* Function: _ST_EnumIndex
* Purpose: Implements the _ST_EnumIndex routine for the internal module support.
*/
function _ST_EnumIndex(v, limit)
  vi = _ST_ToInt(v, -1)
  if vi >= 0 then
    if typeof(limit) == "int" and limit > 0 and vi >= limit then return -1 end if
    return vi
  end if
  if typeof(v) != "enum" then return -1 end if
  if typeof(limit) != "int" or limit <= 0 then return -1 end if

  i = 0
  while i < limit
    if v == i then return i end if
    i = i + 1
  end while
  return -1
end function

/*
* Function: _ST_IDiv
* Purpose: Implements the _ST_IDiv routine for the internal module support.
*/
function _ST_IDiv(a, b)
  a = _ST_ToInt(a, 0)
  b = _ST_ToInt(b, 0)
  if b == 0 then return 0 end if
  q = a / b
  if q >= 0 then return std.math.floor(q) end if
  return std.math.ceil(q)
end function

/*
* Function: _ST_SetMessage
* Purpose: Reads or updates state used by the internal module support.
*/
function _ST_SetMessage(msg)
  if st_plyr is void then return end if
  st_plyr.message = msg
end function

/*
* Function: _ST_DigitFromParam
* Purpose: Implements the _ST_DigitFromParam routine for the internal module support.
*/
function _ST_DigitFromParam(param, idx)
  if typeof(param) != "string" then return -1 end if
  bb = bytes(param)
  i = _ST_ToInt(idx, -1)
  if i < 0 or i >= len(bb) then return -1 end if
  d = bb[i] - 48
  if d < 0 or d > 9 then return -1 end if
  return d
end function

/*
* Function: _ST_CheatParam
* Purpose: Implements the _ST_CheatParam routine for the internal module support.
*/
function _ST_CheatParam(cheat)

  tmp = bytes(8, 0)
  return cht_GetParam(cheat, tmp)
end function

/*
* Function: _ST_GetRef
* Purpose: Reads or updates state used by the internal module support.
*/
function _ST_GetRef(refv, fallback)
  if typeof(refv) == "array" and len(refv) > 0 then
    return refv[0]
  end if
  if refv is void then return fallback end if
  return refv
end function

/*
* Function: _ST_SetRef
* Purpose: Reads or updates state used by the internal module support.
*/
function _ST_SetRef(refv, v)
  if typeof(refv) == "array" and len(refv) > 0 then
    refv[0] = v
  end if
end function

/*
* Function: _ST_LoadPatchMaybe
* Purpose: Loads and prepares data required by the internal module support.
*/
function _ST_LoadPatchMaybe(name)
  if typeof(W_CheckNumForName) != "function" then return void end if
  if W_CheckNumForName(name) == -1 then return void end if
  return W_CacheLumpName(name, PU_STATIC)
end function

/*
* Function: _ST_LoadPatchRequired
* Purpose: Loads and prepares data required by the internal module support.
*/
function _ST_LoadPatchRequired(name)
  if typeof(W_CacheLumpName) != "function" then return void end if
  return W_CacheLumpName(name, PU_STATIC)
end function

/*
* Function: _ST_GetPower
* Purpose: Reads or updates state used by the internal module support.
*/
function _ST_GetPower(player, idx)
  idx = _ST_ToInt(idx, -1)
  if idx < 0 then return 0 end if
  if player is void then return 0 end if
  if typeof(player.powers) != "array" then return 0 end if
  if idx < 0 or idx >= len(player.powers) then return 0 end if
  return _ST_ToInt(player.powers[idx], 0)
end function

/*
* Function: _ST_GetCard
* Purpose: Reads or updates state used by the internal module support.
*/
function _ST_GetCard(player, idx)
  idx = _ST_ToInt(idx, -1)
  if player is void then return false end if
  if typeof(player.cards) != "array" then return false end if
  if idx < 0 or idx >= len(player.cards) then return false end if
  return player.cards[idx]
end function

/*
* Function: _ST_GetWeaponOwned
* Purpose: Reads or updates state used by the internal module support.
*/
function _ST_GetWeaponOwned(player, idx)
  idx = _ST_ToInt(idx, -1)
  if player is void then return false end if
  if typeof(player.weaponowned) != "array" then return false end if
  if idx < 0 or idx >= len(player.weaponowned) then return false end if
  return player.weaponowned[idx]
end function

/*
* Function: _ST_GetAmmo
* Purpose: Reads or updates state used by the internal module support.
*/
function _ST_GetAmmo(player, idx)
  idx = _ST_ToInt(idx, -1)
  if player is void then return 0 end if
  if typeof(player.ammo) != "array" then return 0 end if
  if idx < 0 or idx >= len(player.ammo) then return 0 end if
  return _ST_ToInt(player.ammo[idx], 0)
end function

/*
* Function: _ST_GetMaxAmmo
* Purpose: Reads or updates state used by the internal module support.
*/
function _ST_GetMaxAmmo(player, idx)
  idx = _ST_ToInt(idx, -1)
  if player is void then return 0 end if
  if typeof(player.maxammo) != "array" then return 0 end if
  if idx < 0 or idx >= len(player.maxammo) then return 0 end if
  return _ST_ToInt(player.maxammo[idx], 0)
end function

/*
* Function: _ST_WeaponAmmoType
* Purpose: Implements the _ST_WeaponAmmoType routine for the internal module support.
*/
function _ST_WeaponAmmoType(weapon)
  wi = _ST_EnumIndex(weapon, NUMWEAPONS)
  if wi < 0 then return am_noammo end if
  if typeof(weaponinfo) != "array" then return am_noammo end if
  if wi >= len(weaponinfo) then return am_noammo end if
  info = weaponinfo[wi]
  if info is void then return am_noammo end if
  ai = _ST_EnumIndex(info.ammo, NUMAMMO + 1)
  if ai >= 0 then return ai end if
  return am_noammo
end function

/*
* Function: ST_calcPainOffset
* Purpose: Reads or updates state used by the status bar subsystem.
*/
function ST_calcPainOffset()
  global st_lastcalc
  global st_calc_oldhealth
  if st_plyr is void then return 0 end if

  health = _ST_ToInt(st_plyr.health, 0)
  if health > 100 then health = 100 end if
  if health < 0 then health = 0 end if

  if health != st_calc_oldhealth then
    st_lastcalc = ST_FACESTRIDE * _ST_IDiv((100 - health) * ST_NUMPAINFACES, 101)
    st_calc_oldhealth = health
  end if

  return st_lastcalc
end function

/*
* Function: ST_updateFaceWidget
* Purpose: Advances per-tick logic for the status bar subsystem.
*/
function ST_updateFaceWidget()
  global st_facepriority
  global st_facecount
  global st_faceindex
  global st_lastattackdown
  global st_oldweaponsowned

  if st_plyr is void then return end if

  if st_facepriority < 10 then
    if _ST_ToInt(st_plyr.health, 0) <= 0 then
      st_facepriority = 9
      st_faceindex = ST_DEADFACE
      st_facecount = 1
    end if
  end if

  if st_facepriority < 9 then
    if _ST_ToInt(st_plyr.bonuscount, 0) > 0 then
      doevilgrin = false
      i = 0
      while i < NUMWEAPONS
        owned = _ST_GetWeaponOwned(st_plyr, i)
        if i >= len(st_oldweaponsowned) then
          st_oldweaponsowned = st_oldweaponsowned +[owned]
        end if
        oldOwned = owned
        if i < len(st_oldweaponsowned) then oldOwned = st_oldweaponsowned[i] end if
        if oldOwned != owned then
          doevilgrin = true
          st_oldweaponsowned[i] = owned
        end if
        i = i + 1
      end while
      if doevilgrin then
        st_facepriority = 8
        st_facecount = ST_EVILGRINCOUNT
        st_faceindex = ST_calcPainOffset() + ST_EVILGRINOFFSET
      end if
    end if
  end if

  if st_facepriority < 8 then
    if _ST_ToInt(st_plyr.damagecount, 0) > 0 and st_plyr.attacker is not void and st_plyr.attacker != st_plyr.mo then
      st_facepriority = 7

      if _ST_ToInt(st_plyr.health, 0) - st_oldhealth > ST_MUCHPAIN then
        st_facecount = ST_TURNCOUNT
        st_faceindex = ST_calcPainOffset() + ST_OUCHOFFSET
      else
        badguyangle = R_PointToAngle2(st_plyr.mo.x, st_plyr.mo.y, st_plyr.attacker.x, st_plyr.attacker.y)
        diffang = 0
        turnright = false

        if badguyangle > st_plyr.mo.angle then
          diffang = badguyangle - st_plyr.mo.angle
          turnright = diffang > ANG180
        else
          diffang = st_plyr.mo.angle - badguyangle
          turnright = diffang <= ANG180
        end if

        st_facecount = ST_TURNCOUNT
        st_faceindex = ST_calcPainOffset()

        if diffang < ANG45 then
          st_faceindex = st_faceindex + ST_RAMPAGEOFFSET
        else if turnright then
          st_faceindex = st_faceindex + ST_TURNOFFSET
        else
          st_faceindex = st_faceindex + ST_TURNOFFSET + 1
        end if
      end if
    end if
  end if

  if st_facepriority < 7 then
    if _ST_ToInt(st_plyr.damagecount, 0) > 0 then
      if _ST_ToInt(st_plyr.health, 0) - st_oldhealth > ST_MUCHPAIN then
        st_facepriority = 7
        st_facecount = ST_TURNCOUNT
        st_faceindex = ST_calcPainOffset() + ST_OUCHOFFSET
      else
        st_facepriority = 6
        st_facecount = ST_TURNCOUNT
        st_faceindex = ST_calcPainOffset() + ST_RAMPAGEOFFSET
      end if
    end if
  end if

  if st_facepriority < 6 then
    if st_plyr.attackdown then
      if st_lastattackdown == -1 then
        st_lastattackdown = ST_RAMPAGEDELAY
      else
        st_lastattackdown = st_lastattackdown - 1
        if st_lastattackdown <= 0 then
          st_facepriority = 5
          st_faceindex = ST_calcPainOffset() + ST_RAMPAGEOFFSET
          st_facecount = 1
          st_lastattackdown = 1
        end if
      end if
    else
      st_lastattackdown = -1
    end if
  end if

  if st_facepriority < 5 then
    if (st_plyr.cheats & cheat_t.CF_GODMODE) != 0 or _ST_GetPower(st_plyr, pw_invulnerability) > 0 then
      st_facepriority = 4
      st_faceindex = ST_GODFACE
      st_facecount = 1
    end if
  end if

  if st_facecount <= 0 then
    st_faceindex = ST_calcPainOffset() +(st_randomnumber % 3)
    st_facecount = ST_STRAIGHTFACECOUNT
    st_facepriority = 0
  end if

  st_facecount = st_facecount - 1
  st_face_ref[0] = st_faceindex
end function

/*
* Function: ST_updateWidgets
* Purpose: Advances per-tick logic for the status bar subsystem.
*/
function ST_updateWidgets()
  global st_plyr
  st_plyr = _ST_Player()
  if st_plyr is void then return end if

  ammoType = _ST_WeaponAmmoType(st_plyr.readyweapon)
  if ammoType == am_noammo then
    st_ready_ref[0] = 1994
  else
    st_ready_ref[0] = _ST_GetAmmo(st_plyr, ammoType)
  end if
  w_ready.data = st_plyr.readyweapon

  st_health_ref[0] = _ST_ToInt(st_plyr.health, 0)
  st_armor_ref[0] = _ST_ToInt(st_plyr.armorpoints, 0)

  i = 0
  while i < 3
    k = -1
    if _ST_GetCard(st_plyr, i) then k = i end if
    if _ST_GetCard(st_plyr, i + 3) then k = i + 3 end if
    st_keyrefs[i][0] = k
    i = i + 1
  end while

  i = 0
  while i < 6
    owned = _ST_GetWeaponOwned(st_plyr, i + 1)
    // Doom II: weapon slot 3 must light up for shotgun OR super shotgun.
    if i == 1 and not owned and _ST_GetWeaponOwned(st_plyr, wp_supershotgun) then
      owned = true
    end if
    if owned then
      st_weaponowned_refs[i][0] = 1
    else
      st_weaponowned_refs[i][0] = 0
    end if
    i = i + 1
  end while

  i = 0
  while i < 4
    st_ammo_refs[i][0] = _ST_GetAmmo(st_plyr, i)
    st_maxammo_refs[i][0] = _ST_GetMaxAmmo(st_plyr, i)
    i = i + 1
  end while

  st_notdeathmatch_ref[0] = not deathmatch
  st_armson_ref[0] = _ST_GetRef(st_statusbaron_ref, false) and not deathmatch
  st_fragson_ref[0] = deathmatch and _ST_GetRef(st_statusbaron_ref, false)

  frags = 0
  if typeof(st_plyr.frags) == "array" then
    i = 0
    while i < MAXPLAYERS and i < len(st_plyr.frags)
      fv = _ST_ToInt(st_plyr.frags[i], 0)
      if i != consoleplayer then
        frags = frags + fv
      else
        frags = frags - fv
      end if
      i = i + 1
    end while
  end if
  st_frags_ref[0] = frags

  ST_updateFaceWidget()

  if st_msgcounter > 0 then
    global st_msgcounter
    st_msgcounter = st_msgcounter - 1
    if st_msgcounter == 0 then st_chat = st_oldchat end if
  end if
end function

/*
* Function: ST_Ticker
* Purpose: Advances per-tick logic for the status bar subsystem.
*/
function ST_Ticker()
  global st_clock
  global st_randomnumber
  global st_oldhealth
  if not st_started then return end if

  st_clock = st_clock + 1
  st_randomnumber = M_Random()
  ST_updateWidgets()
  if st_plyr is not void then st_oldhealth = _ST_ToInt(st_plyr.health, 0) end if
end function

/*
* Function: ST_doPaletteStuff
* Purpose: Evaluates conditions and returns a decision for the status bar subsystem.
*/
function ST_doPaletteStuff()
  global st_palette
  p = _ST_Player()
  if p is void then return end if

  cnt = _ST_ToInt(p.damagecount, 0)
  palette = 0
  if _ST_GetPower(p, pw_strength) > 0 then
    bzc = 12 -(_ST_GetPower(p, pw_strength) >> 6)
    if bzc > cnt then cnt = bzc end if
  end if

  if cnt > 0 then
    palette =(cnt + 7) >> 3
    if palette >= NUMREDPALS then palette = NUMREDPALS - 1 end if
    palette = palette + STARTREDPALS
  else if _ST_ToInt(p.bonuscount, 0) > 0 then
    palette =(_ST_ToInt(p.bonuscount, 0) + 7) >> 3
    if palette >= NUMBONUSPALS then palette = NUMBONUSPALS - 1 end if
    palette = palette + STARTBONUSPALS
  else if _ST_GetPower(p, pw_ironfeet) >(4 * 32) or(_ST_GetPower(p, pw_ironfeet) & 8) != 0 then
    palette = RADIATIONPAL
  else
    palette = 0
  end if

  if palette != st_palette then
    st_palette = palette

    if lu_palette >= 0 then
      playpal = W_CacheLumpNum(lu_palette, PU_CACHE)
      if typeof(playpal) == "bytes" then
        off = palette * 768
        if off >= 0 and off + 768 <= len(playpal) then
          I_SetPalette(slice(playpal, off, 768))
        end if
      end if
    end if
  end if
end function

/*
* Function: ST_refreshBackground
* Purpose: Implements the ST_refreshBackground routine for the status bar subsystem.
*/
function ST_refreshBackground()
  if not _ST_GetRef(st_statusbaron_ref, false) then return end if
  if st_stbar is void then return end if

  V_DrawPatch(0, 0, 4, st_stbar)
  if netgame and st_faceback is not void then
    V_DrawPatch(ST_FX, 0, 4, st_faceback)
  end if
  V_CopyRect(0, 0, 4, ST_WIDTH, ST_HEIGHT, 0, ST_Y, 0)
end function

/*
* Function: ST_drawWidgets
* Purpose: Draws or renders output for the status bar subsystem.
*/
function ST_drawWidgets(refresh)
  st_armson_ref[0] = _ST_GetRef(st_statusbaron_ref, false) and not deathmatch
  st_fragson_ref[0] = deathmatch and _ST_GetRef(st_statusbaron_ref, false)

  STlib_updateNum(w_ready, refresh)

  i = 0
  while i < 4
    STlib_updateNum(w_ammo[i], refresh)
    STlib_updateNum(w_maxammo[i], refresh)
    i = i + 1
  end while

  STlib_updatePercent(w_health, refresh)
  STlib_updatePercent(w_armor, refresh)
  STlib_updateBinIcon(w_armsbg, refresh)

  i = 0
  while i < 6
    STlib_updateMultIcon(w_arms[i], refresh)
    i = i + 1
  end while

  STlib_updateMultIcon(w_faces, refresh)

  i = 0
  while i < 3
    STlib_updateMultIcon(w_keyboxes[i], refresh)
    i = i + 1
  end while

  STlib_updateNum(w_frags, refresh)
end function

/*
* Function: ST_doRefresh
* Purpose: Implements the ST_doRefresh routine for the status bar subsystem.
*/
function ST_doRefresh()
  global st_firsttime
  st_firsttime = false
  ST_refreshBackground()
  ST_drawWidgets(true)
end function

/*
* Function: ST_diffDraw
* Purpose: Draws or renders output for the status bar subsystem.
*/
function ST_diffDraw()
  ST_drawWidgets(false)
end function

/*
* Function: ST_loadGraphics
* Purpose: Loads and prepares data required by the status bar subsystem.
*/
function ST_loadGraphics()
  global st_stbar
  global st_faceback
  global st_armsbg_patch
  global st_tallnum
  global st_tallpercent
  global st_shortnum
  global st_keys
  global st_faces

  st_tallnum =[]
  st_shortnum =[]
  i = 0
  while i < 10
    st_tallnum = st_tallnum +[_ST_LoadPatchRequired("STTNUM" + i)]
    st_shortnum = st_shortnum +[_ST_LoadPatchRequired("STYSNUM" + i)]
    i = i + 1
  end while

  st_tallpercent = _ST_LoadPatchRequired("STTPRCNT")

  st_keys =[]
  i = 0
  while i < NUMCARDS
    st_keys = st_keys +[_ST_LoadPatchRequired("STKEYS" + i)]
    i = i + 1
  end while

  st_armsbg_patch = _ST_LoadPatchRequired("STARMS")

  i = 0
  while i < 6
    p0 = _ST_LoadPatchRequired("STGNUM" +(i + 2))
    p1 = void
    if i + 2 < len(st_shortnum) then
      p1 = st_shortnum[i + 2]
    end if
    st_arms_patches[i] =[p0, p1]
    i = i + 1
  end while

  st_faceback = _ST_LoadPatchRequired("STFB" + consoleplayer)
  st_stbar = _ST_LoadPatchRequired("STBAR")

  st_faces =[]
  i = 0
  while i < ST_NUMPAINFACES
    j = 0
    while j < ST_NUMSTRAIGHTFACES
      st_faces = st_faces +[_ST_LoadPatchRequired("STFST" + i + j)]
      j = j + 1
    end while
    st_faces = st_faces +[_ST_LoadPatchRequired("STFTR" + i + "0")]
    st_faces = st_faces +[_ST_LoadPatchRequired("STFTL" + i + "0")]
    st_faces = st_faces +[_ST_LoadPatchRequired("STFOUCH" + i)]
    st_faces = st_faces +[_ST_LoadPatchRequired("STFEVL" + i)]
    st_faces = st_faces +[_ST_LoadPatchRequired("STFKILL" + i)]
    i = i + 1
  end while
  st_faces = st_faces +[_ST_LoadPatchRequired("STFGOD0")]
  st_faces = st_faces +[_ST_LoadPatchRequired("STFDEAD0")]
end function

/*
* Function: ST_loadData
* Purpose: Loads and prepares data required by the status bar subsystem.
*/
function ST_loadData()
  global lu_palette
  if typeof(W_GetNumForName) == "function" then
    lu_palette = W_GetNumForName("PLAYPAL")
  else
    lu_palette = -1
  end if
  ST_loadGraphics()
end function

/*
* Function: ST_unloadGraphics
* Purpose: Loads and prepares data required by the status bar subsystem.
*/
function ST_unloadGraphics()
  global st_stbar
  st_stbar = void
  global st_faceback
  st_faceback = void
  global st_armsbg_patch
  st_armsbg_patch = void
  global st_tallnum
  st_tallnum =[]
  global st_tallpercent
  st_tallpercent = void
  global st_shortnum
  st_shortnum =[]
  global st_keys
  st_keys =[]
  global st_faces
  st_faces =[]
  i = 0
  while i < 6
    st_arms_patches[i] =[void, void]
    i = i + 1
  end while
end function

/*
* Function: ST_unloadData
* Purpose: Loads and prepares data required by the status bar subsystem.
*/
function ST_unloadData()
  ST_unloadGraphics()
end function

/*
* Function: ST_initData
* Purpose: Initializes state and dependencies for the status bar subsystem.
*/
function ST_initData()
  global st_firsttime
  global st_plyr
  global st_clock
  global st_chatstate
  global st_state
  global st_chat
  global st_oldchat
  global st_cursoron
  global st_faceindex
  global st_facepriority
  global st_facecount
  global st_palette
  global st_oldhealth
  global st_lastattackdown
  global st_calc_oldhealth
  global st_lastcalc
  global st_oldweaponsowned
  st_firsttime = true
  st_plyr = _ST_Player()

  st_clock = 0
  st_chatstate = st_chatstateenum_t.StartChatState
  st_state = st_stateenum_t.FirstPersonState

  st_statusbaron_ref[0] = true
  st_oldchat = false
  st_chat = false
  st_cursoron = false

  st_faceindex = 0
  st_face_ref[0] = 0
  st_facepriority = 0
  st_facecount = 0
  st_palette = -1
  st_oldhealth = -1
  st_lastattackdown = -1
  st_calc_oldhealth = -1
  st_lastcalc = 0

  st_oldweaponsowned =[]
  i = 0
  while i < NUMWEAPONS
    st_oldweaponsowned = st_oldweaponsowned +[_ST_GetWeaponOwned(st_plyr, i)]
    i = i + 1
  end while

  i = 0
  while i < 3
    st_keyrefs[i][0] = -1
    i = i + 1
  end while

  STlib_init()
end function

/*
* Function: ST_createWidgets
* Purpose: Creates and initializes runtime objects for the status bar subsystem.
*/
function ST_createWidgets()
  STlib_initNum(w_ready, ST_AMMOX, ST_AMMOY, st_tallnum, st_ready_ref, st_statusbaron_ref, ST_AMMOWIDTH)
  w_ready.data = 0

  STlib_initPercent(w_health, ST_HEALTHX, ST_HEALTHY, st_tallnum, st_health_ref, st_statusbaron_ref, st_tallpercent)

  STlib_initBinIcon(w_armsbg, ST_ARMSBGX, ST_ARMSBGY, st_armsbg_patch, st_notdeathmatch_ref, st_statusbaron_ref)

  i = 0
  while i < 6
    row = 0
    if i < 3 then
      row = 0
    else
      row = 1
    end if
    x = ST_ARMSX +(i % 3) * ST_ARMSXSPACE
    y = ST_ARMSY + row * ST_ARMSYSPACE
    STlib_initMultIcon(w_arms[i], x, y, st_arms_patches[i], st_weaponowned_refs[i], st_armson_ref)
    i = i + 1
  end while

  STlib_initNum(w_frags, ST_FRAGSX, ST_FRAGSY, st_tallnum, st_frags_ref, st_fragson_ref, ST_FRAGSWIDTH)

  STlib_initMultIcon(w_faces, ST_FACESX, ST_FACESY, st_faces, st_face_ref, st_statusbaron_ref)

  STlib_initPercent(w_armor, ST_ARMORX, ST_ARMORY, st_tallnum, st_armor_ref, st_statusbaron_ref, st_tallpercent)

  STlib_initMultIcon(w_keyboxes[0], ST_KEY0X, ST_KEY0Y, st_keys, st_keyrefs[0], st_statusbaron_ref)
  STlib_initMultIcon(w_keyboxes[1], ST_KEY1X, ST_KEY1Y, st_keys, st_keyrefs[1], st_statusbaron_ref)
  STlib_initMultIcon(w_keyboxes[2], ST_KEY2X, ST_KEY2Y, st_keys, st_keyrefs[2], st_statusbaron_ref)

  STlib_initNum(w_ammo[0], ST_AMMO0X, ST_AMMO0Y, st_shortnum, st_ammo_refs[0], st_statusbaron_ref, ST_AMMO0WIDTH)
  STlib_initNum(w_ammo[1], ST_AMMO1X, ST_AMMO1Y, st_shortnum, st_ammo_refs[1], st_statusbaron_ref, ST_AMMO1WIDTH)
  STlib_initNum(w_ammo[2], ST_AMMO2X, ST_AMMO2Y, st_shortnum, st_ammo_refs[2], st_statusbaron_ref, ST_AMMO2WIDTH)
  STlib_initNum(w_ammo[3], ST_AMMO3X, ST_AMMO3Y, st_shortnum, st_ammo_refs[3], st_statusbaron_ref, ST_AMMO3WIDTH)

  STlib_initNum(w_maxammo[0], ST_MAXAMMO0X, ST_MAXAMMO0Y, st_shortnum, st_maxammo_refs[0], st_statusbaron_ref, ST_MAXAMMO0WIDTH)
  STlib_initNum(w_maxammo[1], ST_MAXAMMO1X, ST_MAXAMMO1Y, st_shortnum, st_maxammo_refs[1], st_statusbaron_ref, ST_MAXAMMO1WIDTH)
  STlib_initNum(w_maxammo[2], ST_MAXAMMO2X, ST_MAXAMMO2Y, st_shortnum, st_maxammo_refs[2], st_statusbaron_ref, ST_MAXAMMO2WIDTH)
  STlib_initNum(w_maxammo[3], ST_MAXAMMO3X, ST_MAXAMMO3Y, st_shortnum, st_maxammo_refs[3], st_statusbaron_ref, ST_MAXAMMO3WIDTH)
end function

/*
* Function: ST_Start
* Purpose: Starts runtime behavior in the status bar subsystem.
*/
function ST_Start()
  global st_started
  global statusbaractive
  if st_started then ST_Stop() end if

  if st_stbar is void then
    ST_loadData()
  end if

  ST_initData()
  ST_createWidgets()

  st_started = true
  statusbaractive = true
end function

/*
* Function: ST_Stop
* Purpose: Stops or tears down runtime behavior in the status bar subsystem.
*/
function ST_Stop()
  global st_started
  global statusbaractive
  if not st_started then return end if

  if lu_palette >= 0 then
    pal = W_CacheLumpNum(lu_palette, PU_CACHE)
    if typeof(pal) == "bytes" and len(pal) >= 768 then
      I_SetPalette(slice(pal, 0, 768))
    end if
  end if

  st_started = false
  statusbaractive = false
end function

/*
* Function: ST_Responder
* Purpose: Implements the ST_Responder routine for the status bar subsystem.
*/
function ST_Responder(ev)
  global st_plyr
  global st_state
  global st_firsttime

  if ev == 0 or ev is void then return false end if

  if ev.type == evtype_t.ev_keyup and((ev.data1 & 0xffff0000) == AM_MSGHEADER) then
    if ev.data1 == AM_MSGENTERED then
      st_state = st_stateenum_t.AutomapState
      st_firsttime = true
    else if ev.data1 == AM_MSGEXITED then
      st_state = st_stateenum_t.FirstPersonState
    end if
    return false
  end if

  if ev.type == evtype_t.ev_keydown then
    st_plyr = _ST_Player()
    if st_plyr is void then return false end if

    if not netgame then
      if cht_CheckCheat(cheat_god, ev.data1) != 0 then
        st_plyr.cheats = st_plyr.cheats ^ cheat_t.CF_GODMODE
        if (st_plyr.cheats & cheat_t.CF_GODMODE) != 0 then
          if st_plyr.mo is not void then st_plyr.mo.health = 100 end if
          st_plyr.health = 100
          _ST_SetMessage(STSTR_DQDON)
        else
          _ST_SetMessage(STSTR_DQDOFF)
        end if

      else if cht_CheckCheat(cheat_ammonokey, ev.data1) != 0 then
        st_plyr.armorpoints = 200
        st_plyr.armortype = 2
        i = 0
        while i < NUMWEAPONS
          if i < len(st_plyr.weaponowned) then st_plyr.weaponowned[i] = true end if
          i = i + 1
        end while
        i = 0
        while i < NUMAMMO
          if i < len(st_plyr.ammo) and i < len(st_plyr.maxammo) then
            st_plyr.ammo[i] = st_plyr.maxammo[i]
          end if
          i = i + 1
        end while
        _ST_SetMessage(STSTR_FAADDED)

      else if cht_CheckCheat(cheat_ammo, ev.data1) != 0 then
        st_plyr.armorpoints = 200
        st_plyr.armortype = 2
        i = 0
        while i < NUMWEAPONS
          if i < len(st_plyr.weaponowned) then st_plyr.weaponowned[i] = true end if
          i = i + 1
        end while
        i = 0
        while i < NUMAMMO
          if i < len(st_plyr.ammo) and i < len(st_plyr.maxammo) then
            st_plyr.ammo[i] = st_plyr.maxammo[i]
          end if
          i = i + 1
        end while
        i = 0
        while i < NUMCARDS
          if i < len(st_plyr.cards) then st_plyr.cards[i] = true end if
          i = i + 1
        end while
        _ST_SetMessage(STSTR_KFAADDED)

      else if cht_CheckCheat(cheat_mus, ev.data1) != 0 then
        _ST_SetMessage(STSTR_MUS)
        param = _ST_CheatParam(cheat_mus)
        d0 = _ST_DigitFromParam(param, 0)
        d1 = _ST_DigitFromParam(param, 1)
        if d0 < 0 or d1 < 0 then
          _ST_SetMessage(STSTR_NOMUS)
        else if gamemode == commercial then
          sel = d0 * 10 + d1
          musnum = musicenum_t.mus_runnin + sel - 1
          if sel > 35 then
            _ST_SetMessage(STSTR_NOMUS)
          else
            S_ChangeMusic(musnum, true)
          end if
        else
          musnum = musicenum_t.mus_e1m1 +(d0 - 1) * 9 +(d1 - 1)
          if ((d0 - 1) * 9 +(d1 - 1)) > 31 then
            _ST_SetMessage(STSTR_NOMUS)
          else
            S_ChangeMusic(musnum, true)
          end if
        end if

      else
        clipcheat =(cht_CheckCheat(cheat_noclip, ev.data1) != 0)
        if not clipcheat then
          clipcheat =(cht_CheckCheat(cheat_commercial_noclip, ev.data1) != 0)
        end if
        if clipcheat then
          st_plyr.cheats = st_plyr.cheats ^ cheat_t.CF_NOCLIP
          if (st_plyr.cheats & cheat_t.CF_NOCLIP) != 0 then
            _ST_SetMessage(STSTR_NCON)
          else
            _ST_SetMessage(STSTR_NCOFF)
          end if
        end if
      end if

      i = 0
      while i < 6
        if cht_CheckCheat(cheat_powerup[i], ev.data1) != 0 then
          if _ST_GetPower(st_plyr, i) == 0 then
            P_GivePower(st_plyr, i)
          else if i != pw_strength then
            if i < len(st_plyr.powers) then st_plyr.powers[i] = 1 end if
          else
            if i < len(st_plyr.powers) then st_plyr.powers[i] = 0 end if
          end if
          _ST_SetMessage(STSTR_BEHOLDX)
        end if
        i = i + 1
      end while

      if cht_CheckCheat(cheat_powerup[6], ev.data1) != 0 then
        _ST_SetMessage(STSTR_BEHOLD)
      else if cht_CheckCheat(cheat_choppers, ev.data1) != 0 then
        wi = _ST_EnumIndex(weapontype_t.wp_chainsaw, NUMWEAPONS)
        if wi >= 0 and wi < len(st_plyr.weaponowned) then st_plyr.weaponowned[wi] = true end if
        pi = _ST_EnumIndex(pw_invulnerability, NUMPOWERS)
        if pi >= 0 and pi < len(st_plyr.powers) then st_plyr.powers[pi] = 1 end if
        _ST_SetMessage(STSTR_CHOPPERS)
      else if cht_CheckCheat(cheat_mypos, ev.data1) != 0 then
        if st_plyr.mo is not void then
          _ST_SetMessage("ang=" + st_plyr.mo.angle + ";x,y=(" + st_plyr.mo.x + "," + st_plyr.mo.y + ")")
        end if
      end if
    end if

    if cht_CheckCheat(cheat_clev, ev.data1) != 0 then
      param = _ST_CheatParam(cheat_clev)
      d0 = _ST_DigitFromParam(param, 0)
      d1 = _ST_DigitFromParam(param, 1)
      if d0 < 0 or d1 < 0 then return false end if

      epsd = d0
      map = d1
      if gamemode == commercial then
        epsd = 0
        map = d0 * 10 + d1
      end if

      if epsd < 1 or map < 1 then return false end if
      if gamemode == retail and(epsd > 4 or map > 9) then return false end if
      if gamemode == registered and(epsd > 3 or map > 9) then return false end if
      if gamemode == shareware and(epsd > 1 or map > 9) then return false end if
      if gamemode == commercial and(epsd > 1 or map > 34) then return false end if

      _ST_SetMessage(STSTR_CLEV)
      G_DeferedInitNew(gameskill, epsd, map)
    end if
  end if

  return false
end function

/*
* Function: ST_Drawer
* Purpose: Draws or renders output for the status bar subsystem.
*/
function ST_Drawer(fullscreen, refresh)
  global st_firsttime
  if not st_started then return end if

  st_statusbaron_ref[0] =(not fullscreen) or automapactive
  st_firsttime = st_firsttime or refresh

  ST_doPaletteStuff()

  if st_firsttime then
    ST_doRefresh()
  else
    ST_diffDraw()
  end if
end function

/*
* Function: ST_Init
* Purpose: Initializes state and dependencies for the status bar subsystem.
*/
function ST_Init()
  global st_firsttime
  ST_loadData()

  if typeof(screens) == "array" and len(screens) > 4 then
    if typeof(screens[4]) != "bytes" then
      screens[4] = bytes(ST_WIDTH * ST_HEIGHT, 0)
    end if
  end if

  st_firsttime = true
end function



