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

//! Drives the classic status bar's player values, face state machine, palette flashes, cheats, resources, and
//! widgets.

import doomtype
import d_event
import i_system
import i_video
import i_gl
import z_zone
import m_random
import w_wad
import doomdef
import g_game
import st_lib
import r_local
import r_main
import r_renderer
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

/// Defines st height for the st stuff subsystem.
const ST_HEIGHT = 32
/// Defines st width for the st stuff subsystem.
const ST_WIDTH = 320
/// Defines st y for the st stuff subsystem.
const ST_Y = 168

/// Defines startredpals for the st stuff subsystem.
const STARTREDPALS = 1
/// Defines startbonuspals for the st stuff subsystem.
const STARTBONUSPALS = 9
/// Defines the numredpals count used by the st stuff subsystem.
const NUMREDPALS = 8
/// Defines the numbonuspals count used by the st stuff subsystem.
const NUMBONUSPALS = 4
/// Defines radiationpal for the st stuff subsystem.
const RADIATIONPAL = 13

/// Defines st fx for the st stuff subsystem.
const ST_FX = 143
/// Defines st fy for the st stuff subsystem.
const ST_FY = 169

/// Defines the st numpainfaces count used by the st stuff subsystem.
const ST_NUMPAINFACES = 5
/// Defines the st numstraightfaces count used by the st stuff subsystem.
const ST_NUMSTRAIGHTFACES = 3
/// Defines the st numturnfaces count used by the st stuff subsystem.
const ST_NUMTURNFACES = 2
/// Defines the st numspecialfaces count used by the st stuff subsystem.
const ST_NUMSPECIALFACES = 3
/// Defines st facestride for the st stuff subsystem.
const ST_FACESTRIDE = ST_NUMSTRAIGHTFACES + ST_NUMTURNFACES + ST_NUMSPECIALFACES
/// Defines the st numextrafaces count used by the st stuff subsystem.
const ST_NUMEXTRAFACES = 2
/// Defines the st numfaces count used by the st stuff subsystem.
const ST_NUMFACES = ST_FACESTRIDE * ST_NUMPAINFACES + ST_NUMEXTRAFACES
/// Defines st turnoffset for the st stuff subsystem.
const ST_TURNOFFSET = ST_NUMSTRAIGHTFACES
/// Defines st ouchoffset for the st stuff subsystem.
const ST_OUCHOFFSET = ST_TURNOFFSET + ST_NUMTURNFACES
/// Defines st evilgrinoffset for the st stuff subsystem.
const ST_EVILGRINOFFSET = ST_OUCHOFFSET + 1
/// Defines st rampageoffset for the st stuff subsystem.
const ST_RAMPAGEOFFSET = ST_EVILGRINOFFSET + 1
/// Defines st godface for the st stuff subsystem.
const ST_GODFACE = ST_NUMPAINFACES * ST_FACESTRIDE
/// Defines st deadface for the st stuff subsystem.
const ST_DEADFACE = ST_GODFACE + 1
/// Defines st facesx for the st stuff subsystem.
const ST_FACESX = 143
/// Defines st facesy for the st stuff subsystem.
const ST_FACESY = 168
/// Defines st evilgrincount for the st stuff subsystem.
const ST_EVILGRINCOUNT = 2 * TICRATE
/// Defines st straightfacecount for the st stuff subsystem.
const ST_STRAIGHTFACECOUNT = TICRATE >> 1
/// Defines st turncount for the st stuff subsystem.
const ST_TURNCOUNT = TICRATE
/// Defines st rampagedelay for the st stuff subsystem.
const ST_RAMPAGEDELAY = 2 * TICRATE
/// Defines st muchpain for the st stuff subsystem.
const ST_MUCHPAIN = 20

/// Defines st ammowidth for the st stuff subsystem.
const ST_AMMOWIDTH = 3
/// Defines st ammox for the st stuff subsystem.
const ST_AMMOX = 44
/// Defines st ammoy for the st stuff subsystem.
const ST_AMMOY = 171

/// Defines st healthwidth for the st stuff subsystem.
const ST_HEALTHWIDTH = 3
/// Defines st healthx for the st stuff subsystem.
const ST_HEALTHX = 90
/// Defines st healthy for the st stuff subsystem.
const ST_HEALTHY = 171

/// Defines st armsx for the st stuff subsystem.
const ST_ARMSX = 111
/// Defines st armsy for the st stuff subsystem.
const ST_ARMSY = 172
/// Defines st armsbgx for the st stuff subsystem.
const ST_ARMSBGX = 104
/// Defines st armsbgy for the st stuff subsystem.
const ST_ARMSBGY = 168
/// Defines st armsxspace for the st stuff subsystem.
const ST_ARMSXSPACE = 12
/// Defines st armsyspace for the st stuff subsystem.
const ST_ARMSYSPACE = 10

/// Defines st fragsx for the st stuff subsystem.
const ST_FRAGSX = 138
/// Defines st fragsy for the st stuff subsystem.
const ST_FRAGSY = 171
/// Defines st fragswidth for the st stuff subsystem.
const ST_FRAGSWIDTH = 2

/// Defines st armorwidth for the st stuff subsystem.
const ST_ARMORWIDTH = 3
/// Defines st armorx for the st stuff subsystem.
const ST_ARMORX = 221
/// Defines st armory for the st stuff subsystem.
const ST_ARMORY = 171

/// Defines st key0 x for the st stuff subsystem.
const ST_KEY0X = 239
/// Defines st key0 y for the st stuff subsystem.
const ST_KEY0Y = 171
/// Defines st key1 x for the st stuff subsystem.
const ST_KEY1X = 239
/// Defines st key1 y for the st stuff subsystem.
const ST_KEY1Y = 181
/// Defines st key2 x for the st stuff subsystem.
const ST_KEY2X = 239
/// Defines st key2 y for the st stuff subsystem.
const ST_KEY2Y = 191

/// Defines st ammo0 width for the st stuff subsystem.
const ST_AMMO0WIDTH = 3
/// Defines st ammo0 x for the st stuff subsystem.
const ST_AMMO0X = 288
/// Defines st ammo0 y for the st stuff subsystem.
const ST_AMMO0Y = 173
/// Defines st ammo1 width for the st stuff subsystem.
const ST_AMMO1WIDTH = ST_AMMO0WIDTH
/// Defines st ammo1 x for the st stuff subsystem.
const ST_AMMO1X = 288
/// Defines st ammo1 y for the st stuff subsystem.
const ST_AMMO1Y = 179
/// Defines st ammo2 width for the st stuff subsystem.
const ST_AMMO2WIDTH = ST_AMMO0WIDTH
/// Defines st ammo2 x for the st stuff subsystem.
const ST_AMMO2X = 288
/// Defines st ammo2 y for the st stuff subsystem.
const ST_AMMO2Y = 191
/// Defines st ammo3 width for the st stuff subsystem.
const ST_AMMO3WIDTH = ST_AMMO0WIDTH
/// Defines st ammo3 x for the st stuff subsystem.
const ST_AMMO3X = 288
/// Defines st ammo3 y for the st stuff subsystem.
const ST_AMMO3Y = 185

/// Defines the maximum st maxammo0 width accepted by the st stuff subsystem.
const ST_MAXAMMO0WIDTH = 3
/// Defines the maximum st maxammo0 x accepted by the st stuff subsystem.
const ST_MAXAMMO0X = 314
/// Defines the maximum st maxammo0 y accepted by the st stuff subsystem.
const ST_MAXAMMO0Y = 173
/// Defines the maximum st maxammo1 width accepted by the st stuff subsystem.
const ST_MAXAMMO1WIDTH = ST_MAXAMMO0WIDTH
/// Defines the maximum st maxammo1 x accepted by the st stuff subsystem.
const ST_MAXAMMO1X = 314
/// Defines the maximum st maxammo1 y accepted by the st stuff subsystem.
const ST_MAXAMMO1Y = 179
/// Defines the maximum st maxammo2 width accepted by the st stuff subsystem.
const ST_MAXAMMO2WIDTH = ST_MAXAMMO0WIDTH
/// Defines the maximum st maxammo2 x accepted by the st stuff subsystem.
const ST_MAXAMMO2X = 314
/// Defines the maximum st maxammo2 y accepted by the st stuff subsystem.
const ST_MAXAMMO2Y = 191
/// Defines the maximum st maxammo3 width accepted by the st stuff subsystem.
const ST_MAXAMMO3WIDTH = ST_MAXAMMO0WIDTH
/// Defines the maximum st maxammo3 x accepted by the st stuff subsystem.
const ST_MAXAMMO3X = 314
/// Defines the maximum st maxammo3 y accepted by the st stuff subsystem.
const ST_MAXAMMO3Y = 185

/// Distinguishes automap and first-person status-bar presentation state.
enum st_stateenum_t
  /// Represents automap state in `st_stateenum_t`
  AutomapState = 0
  /// Represents first person state in `st_stateenum_t`
  FirstPersonState = 1
end enum

/// Tracks the legacy status-bar chat input phases retained for compatibility.
enum st_chatstateenum_t
  /// Represents start chat state in `st_chatstateenum_t`
  StartChatState = 0
  /// Represents wait dest state in `st_chatstateenum_t`
  WaitDestState = 1
  /// Represents get chat state in `st_chatstateenum_t`
  GetChatState = 2
end enum

/// Tracks whether st firsttime is active in the st stuff subsystem.
st_firsttime = true
/// Tracks whether st started is active in the st stuff subsystem.
st_started = false

/// Tracks the mutable lu palette value used by the st stuff subsystem.
lu_palette = -1
/// Tracks the mutable st clock value used by the st stuff subsystem.
st_clock = 0
/// Tracks the mutable st msgcounter value used by the st stuff subsystem.
st_msgcounter = 0
/// Exposes `st_chatstateenum_t.StartChatState` through the legacy `st_chatstate` alias.
st_chatstate = st_chatstateenum_t.StartChatState
/// Exposes `st_stateenum_t.FirstPersonState` through the legacy `st_state` alias.
st_state = st_stateenum_t.FirstPersonState
/// Tracks the mutable st palette value used by the st stuff subsystem.
st_palette = 0

/// Stores the st statusbaron ref collection used by the st stuff subsystem.
st_statusbaron_ref =[true]
/// Stores the st notdeathmatch ref collection used by the st stuff subsystem.
st_notdeathmatch_ref =[true]
/// Stores the st armson ref collection used by the st stuff subsystem.
st_armson_ref =[true]
/// Stores the st fragson ref collection used by the st stuff subsystem.
st_fragson_ref =[false]

/// Tracks whether st chat is active in the st stuff subsystem.
st_chat = false
/// Tracks whether st oldchat is active in the st stuff subsystem.
st_oldchat = false
/// Tracks whether st cursoron is active in the st stuff subsystem.
st_cursoron = false

/// Holds the optional st plyr resource used by the st stuff subsystem.
st_plyr = void

/// Holds the optional st stbar resource used by the st stuff subsystem.
st_stbar = void
/// Holds the optional st faceback resource used by the st stuff subsystem.
st_faceback = void
/// Holds the optional st armsbg patch resource used by the st stuff subsystem.
st_armsbg_patch = void
/// Stores the st tallnum collection used by the st stuff subsystem.
st_tallnum =[]
/// Holds the optional st tallpercent resource used by the st stuff subsystem.
st_tallpercent = void
/// Stores the st shortnum collection used by the st stuff subsystem.
st_shortnum =[]
/// Stores the st keys collection used by the st stuff subsystem.
st_keys =[]
/// Stores the st faces collection used by the st stuff subsystem.
st_faces =[]
/// Stores the st arms patches collection used by the st stuff subsystem.
st_arms_patches =[[void, void],[void, void],[void, void],[void, void],[void, void],[void, void]]

/// Stores the st ready ref collection used by the st stuff subsystem.
st_ready_ref =[1994]
/// Stores the st health ref collection used by the st stuff subsystem.
st_health_ref =[100]
/// Stores the st armor ref collection used by the st stuff subsystem.
st_armor_ref =[0]
/// Stores the st frags ref collection used by the st stuff subsystem.
st_frags_ref =[0]
/// Stores the st face ref collection used by the st stuff subsystem.
st_face_ref =[0]
/// Stores the st keyrefs collection used by the st stuff subsystem.
st_keyrefs =[[-1],[-1],[-1]]
/// Stores the st weaponowned refs collection used by the st stuff subsystem.
st_weaponowned_refs =[[0],[0],[0],[0],[0],[0]]
/// Stores the st ammo refs collection used by the st stuff subsystem.
st_ammo_refs =[[0],[0],[0],[0]]
/// Stores the st maxammo refs collection used by the st stuff subsystem.
st_maxammo_refs =[[0],[0],[0],[0]]

/// Tracks the mutable w ready value used by the st stuff subsystem.
w_ready = st_number_t(0, 0, 0, 0, st_ready_ref, st_statusbaron_ref, st_tallnum, 0)
/// Tracks the mutable w frags value used by the st stuff subsystem.
w_frags = st_number_t(0, 0, 0, 0, st_frags_ref, st_fragson_ref, st_tallnum, 0)
/// Tracks the mutable w health value used by the st stuff subsystem.
w_health = st_percent_t(st_number_t(0, 0, 0, 0, st_health_ref, st_statusbaron_ref, st_tallnum, 0), st_tallpercent)
/// Tracks the mutable w armsbg value used by the st stuff subsystem.
w_armsbg = st_binicon_t(0, 0, false, st_notdeathmatch_ref, st_statusbaron_ref, st_armsbg_patch, 0)
/// Tracks the mutable w faces value used by the st stuff subsystem.
w_faces = st_multicon_t(0, 0, -1, st_face_ref, st_statusbaron_ref, st_faces, 0)
/// Tracks the mutable w armor value used by the st stuff subsystem.
w_armor = st_percent_t(st_number_t(0, 0, 0, 0, st_armor_ref, st_statusbaron_ref, st_tallnum, 0), st_tallpercent)
/// Stores the w arms collection used by the st stuff subsystem.
w_arms =[
st_multicon_t(0, 0, -1, st_weaponowned_refs[0], st_armson_ref, st_arms_patches[0], 0),
st_multicon_t(0, 0, -1, st_weaponowned_refs[1], st_armson_ref, st_arms_patches[1], 0),
st_multicon_t(0, 0, -1, st_weaponowned_refs[2], st_armson_ref, st_arms_patches[2], 0),
st_multicon_t(0, 0, -1, st_weaponowned_refs[3], st_armson_ref, st_arms_patches[3], 0),
st_multicon_t(0, 0, -1, st_weaponowned_refs[4], st_armson_ref, st_arms_patches[4], 0),
st_multicon_t(0, 0, -1, st_weaponowned_refs[5], st_armson_ref, st_arms_patches[5], 0)
]
/// Stores the w keyboxes collection used by the st stuff subsystem.
w_keyboxes =[
st_multicon_t(0, 0, -1, st_keyrefs[0], st_statusbaron_ref, st_keys, 0),
st_multicon_t(0, 0, -1, st_keyrefs[1], st_statusbaron_ref, st_keys, 0),
st_multicon_t(0, 0, -1, st_keyrefs[2], st_statusbaron_ref, st_keys, 0)
]
/// Stores the w ammo collection used by the st stuff subsystem.
w_ammo =[
st_number_t(0, 0, 0, 0, st_ammo_refs[0], st_statusbaron_ref, st_shortnum, 0),
st_number_t(0, 0, 0, 0, st_ammo_refs[1], st_statusbaron_ref, st_shortnum, 0),
st_number_t(0, 0, 0, 0, st_ammo_refs[2], st_statusbaron_ref, st_shortnum, 0),
st_number_t(0, 0, 0, 0, st_ammo_refs[3], st_statusbaron_ref, st_shortnum, 0)
]
/// Stores the w maxammo collection used by the st stuff subsystem.
w_maxammo =[
st_number_t(0, 0, 0, 0, st_maxammo_refs[0], st_statusbaron_ref, st_shortnum, 0),
st_number_t(0, 0, 0, 0, st_maxammo_refs[1], st_statusbaron_ref, st_shortnum, 0),
st_number_t(0, 0, 0, 0, st_maxammo_refs[2], st_statusbaron_ref, st_shortnum, 0),
st_number_t(0, 0, 0, 0, st_maxammo_refs[3], st_statusbaron_ref, st_shortnum, 0)
]

/// Tracks the mutable st facecount value used by the st stuff subsystem.
st_facecount = 0
/// Tracks the mutable st faceindex value used by the st stuff subsystem.
st_faceindex = 0
/// Tracks the mutable st facepriority value used by the st stuff subsystem.
st_facepriority = 0
/// Tracks the mutable st oldhealth value used by the st stuff subsystem.
st_oldhealth = -1
/// Stores the st oldweaponsowned collection used by the st stuff subsystem.
st_oldweaponsowned =[]
/// Tracks the mutable st lastattackdown value used by the st stuff subsystem.
st_lastattackdown = -1
/// Tracks the mutable st randomnumber value used by the st stuff subsystem.
st_randomnumber = 0
/// Tracks the mutable st lastcalc value used by the st stuff subsystem.
st_lastcalc = 0
/// Tracks the mutable st calc oldhealth value used by the st stuff subsystem.
st_calc_oldhealth = -1

/// Tracks the mutable cheat mus value used by the st stuff subsystem.
cheat_mus = cheatseq_t(bytes([0xb2, 0x26, 0xb6, 0xae, 0xea, 1, 0, 0, 0xff]), 0)
/// Tracks the mutable cheat choppers value used by the st stuff subsystem.
cheat_choppers = cheatseq_t(bytes([0xb2, 0x26, 0xe2, 0x32, 0xf6, 0x2a, 0x2a, 0xa6, 0x6a, 0xea, 0xff]), 0)
/// Tracks the mutable cheat god value used by the st stuff subsystem.
cheat_god = cheatseq_t(bytes([0xb2, 0x26, 0x26, 0xaa, 0x26, 0xff]), 0)
/// Tracks the mutable cheat ammo value used by the st stuff subsystem.
cheat_ammo = cheatseq_t(bytes([0xb2, 0x26, 0xf2, 0x66, 0xa2, 0xff]), 0)
/// Tracks the mutable cheat ammonokey value used by the st stuff subsystem.
cheat_ammonokey = cheatseq_t(bytes([0xb2, 0x26, 0x66, 0xa2, 0xff]), 0)
/// Tracks the mutable cheat noclip value used by the st stuff subsystem.
cheat_noclip = cheatseq_t(bytes([0xb2, 0x26, 0xea, 0x2a, 0xb2, 0xea, 0x2a, 0xf6, 0x2a, 0x26, 0xff]), 0)
/// Tracks the mutable cheat commercial noclip value used by the st stuff subsystem.
cheat_commercial_noclip = cheatseq_t(bytes([0xb2, 0x26, 0xe2, 0x36, 0xb2, 0x2a, 0xff]), 0)
/// Stores the cheat powerup collection used by the st stuff subsystem.
cheat_powerup =[
cheatseq_t(bytes([0xb2, 0x26, 0x62, 0xa6, 0x32, 0xf6, 0x36, 0x26, 0x6e, 0xff]), 0),
cheatseq_t(bytes([0xb2, 0x26, 0x62, 0xa6, 0x32, 0xf6, 0x36, 0x26, 0xea, 0xff]), 0),
cheatseq_t(bytes([0xb2, 0x26, 0x62, 0xa6, 0x32, 0xf6, 0x36, 0x26, 0xb2, 0xff]), 0),
cheatseq_t(bytes([0xb2, 0x26, 0x62, 0xa6, 0x32, 0xf6, 0x36, 0x26, 0x6a, 0xff]), 0),
cheatseq_t(bytes([0xb2, 0x26, 0x62, 0xa6, 0x32, 0xf6, 0x36, 0x26, 0xa2, 0xff]), 0),
cheatseq_t(bytes([0xb2, 0x26, 0x62, 0xa6, 0x32, 0xf6, 0x36, 0x26, 0x36, 0xff]), 0),
cheatseq_t(bytes([0xb2, 0x26, 0x62, 0xa6, 0x32, 0xf6, 0x36, 0x26, 0xff]), 0)
]
/// Tracks the mutable cheat clev value used by the st stuff subsystem.
cheat_clev = cheatseq_t(bytes([0xb2, 0x26, 0xe2, 0x36, 0xa6, 0x6e, 1, 0, 0, 0xff]), 0)
/// Tracks the mutable cheat mypos value used by the st stuff subsystem.
cheat_mypos = cheatseq_t(bytes([0xb2, 0x26, 0xb6, 0xba, 0x2a, 0xf6, 0xea, 0xff]), 0)

/// Returns the checked console-player record consumed by status widgets and cheats.
/// @internal
function inline _ST_Player()
  if typeof(players) != "array" then return void end if
  if typeof(consoleplayer) != "int" then return void end if
  if consoleplayer < 0 or consoleplayer >= len(players) then return void end if
  return players[consoleplayer]
end function

/// Converts numeric or numeric-string widget values by truncating toward zero, otherwise returning a fallback.
/// @param v Value consumed by the operation.
/// @param fallback Value returned when the requested conversion or lookup is unavailable.
/// @internal
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

/// Converts integer/enum values to a checked table index below the requested limit.
/// @param v Value consumed by the operation.
/// @param limit Limit value supplied to `_ST_EnumIndex`.
/// @internal
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

/// Divides status calculations with truncation toward zero and returns zero for a zero divisor.
/// @param a First input operand.
/// @param b Second input operand.
/// @internal
function inline _ST_IDiv(a, b)
  a = _ST_ToInt(a, 0)
  b = _ST_ToInt(b, 0)
  if b == 0 then return 0 end if
  q = a / b
  if q >= 0 then return std.math.floor(q) end if
  return std.math.ceil(q)
end function

/// Writes a cheat/status notification into the active console player's HUD message slot.
/// @param msg Msg value supplied to `_ST_SetMessage`.
/// @internal
function inline _ST_SetMessage(msg)
  if st_plyr is void then return end if
  st_plyr.message = msg
end function

/// Parses one checked decimal digit from a cheat-code parameter string, returning minus one on invalid input.
/// @param param Param value supplied to `_ST_DigitFromParam`.
/// @param idx Zero-based element or table index.
/// @internal
function inline _ST_DigitFromParam(param, idx)
  if typeof(param) != "string" then return -1 end if
  bb = bytes(param)
  i = _ST_ToInt(idx, -1)
  if i < 0 or i >= len(bb) then return -1 end if
  d = bb[i] - 48
  if d < 0 or d > 9 then return -1 end if
  return d
end function

/// Formats one numeric status-bar lump suffix without implicit string conversion.
/// @param v Value consumed by the operation.
/// @internal
function inline _ST_DigitString(v)
  if v == 1 then return "1" end if
  if v == 2 then return "2" end if
  if v == 3 then return "3" end if
  if v == 4 then return "4" end if
  if v == 5 then return "5" end if
  if v == 6 then return "6" end if
  if v == 7 then return "7" end if
  if v == 8 then return "8" end if
  if v == 9 then return "9" end if
  return "0"
end function

/// Returns a copy of an array with one appended item without using concatenation.
/// @param arr Arr value supplied to `_ST_ArrayAppend`.
/// @param item Item value supplied to `_ST_ArrayAppend`.
/// @internal
function _ST_ArrayAppend(arr, item)
  n = 0
  if typeof(arr) == "array" then n = len(arr) end if
  result = array(n + 1)
  i = 0
  while i < n
    result[i] = arr[i]
    i = i + 1
  end while
  result[n] = item
  return result
end function

/// Returns the fixed status-bar face background lump for the local player.
/// @internal
function inline _ST_FacebackName()
  if consoleplayer == 1 then return "STFB1" end if
  if consoleplayer == 2 then return "STFB2" end if
  if consoleplayer == 3 then return "STFB3" end if
  return "STFB0"
end function

/// Extracts the decoded parameter bytes accumulated by a parameterized cheat sequence.
/// @param cheat Cheat value supplied to `_ST_CheatParam`.
/// @internal
function inline _ST_CheatParam(cheat)

  tmp = bytes(8, 0)
  return cht_GetParam(cheat, tmp)
end function

/// Dereferences the status widget's single-element mutable-reference convention with a fallback.
/// @param refv Refv value supplied to `_ST_GetRef`.
/// @param fallback Value returned when the requested conversion or lookup is unavailable.
/// @internal
function inline _ST_GetRef(refv, fallback)
  if typeof(refv) == "array" and len(refv) > 0 then
    return refv[0]
  end if
  if refv is void then return fallback end if
  return refv
end function

/// Writes through a non-empty single-element status-widget reference.
/// @param refv Refv value supplied to `_ST_SetRef`.
/// @param v Value consumed by the operation.
/// @internal
function inline _ST_SetRef(refv, v)
  if typeof(refv) == "array" and len(refv) > 0 then
    refv[0] = v
  end if
end function

/// Caches an optional status-bar patch only when its lump exists.
/// @param name Resource or object name to resolve.
/// @internal
function inline _ST_LoadPatchMaybe(name)
  if typeof(W_CheckNumForName) != "function" then return void end if
  if W_CheckNumForName(name) == -1 then return void end if
  return W_CacheLumpName(name, PU_STATIC)
end function

/// Caches a required status-bar patch and registers its lump name for HD overlay lookup.
/// @param name Resource or object name to resolve.
/// @internal
function inline _ST_LoadPatchRequired(name)
  if typeof(W_CacheLumpName) != "function" then return void end if
  p = W_CacheLumpName(name, PU_STATIC)
  if typeof(STlib_RegisterPatchName) == "function" then
    STlib_RegisterPatchName(p, name)
  end if
  return p
end function

/// Returns one checked player power timer or zero for absent/incomplete records.
/// @param player Player state affected by the operation.
/// @param idx Zero-based element or table index.
/// @internal
function inline _ST_GetPower(player, idx)
  idx = _ST_ToInt(idx, -1)
  if idx < 0 then return 0 end if
  if player is void then return 0 end if
  if typeof(player.powers) != "array" then return 0 end if
  if idx < 0 or idx >= len(player.powers) then return 0 end if
  return _ST_ToInt(player.powers[idx], 0)
end function

/// Returns one checked player key/card ownership flag.
/// @param player Player state affected by the operation.
/// @param idx Zero-based element or table index.
/// @internal
function inline _ST_GetCard(player, idx)
  idx = _ST_ToInt(idx, -1)
  if player is void then return false end if
  if typeof(player.cards) != "array" then return false end if
  if idx < 0 or idx >= len(player.cards) then return false end if
  return player.cards[idx]
end function

/// Returns one checked player weapon-ownership flag.
/// @param player Player state affected by the operation.
/// @param idx Zero-based element or table index.
/// @internal
function inline _ST_GetWeaponOwned(player, idx)
  idx = _ST_ToInt(idx, -1)
  if player is void then return false end if
  if typeof(player.weaponowned) != "array" then return false end if
  if idx < 0 or idx >= len(player.weaponowned) then return false end if
  return player.weaponowned[idx]
end function

/// Returns one checked player ammunition count as an integer.
/// @param player Player state affected by the operation.
/// @param idx Zero-based element or table index.
/// @internal
function inline _ST_GetAmmo(player, idx)
  idx = _ST_ToInt(idx, -1)
  if player is void then return 0 end if
  if typeof(player.ammo) != "array" then return 0 end if
  if idx < 0 or idx >= len(player.ammo) then return 0 end if
  return _ST_ToInt(player.ammo[idx], 0)
end function

/// Returns one checked player ammunition-capacity value as an integer.
/// @param player Player state affected by the operation.
/// @param idx Zero-based element or table index.
/// @internal
function inline _ST_GetMaxAmmo(player, idx)
  idx = _ST_ToInt(idx, -1)
  if player is void then return 0 end if
  if typeof(player.maxammo) != "array" then return 0 end if
  if idx < 0 or idx >= len(player.maxammo) then return 0 end if
  return _ST_ToInt(player.maxammo[idx], 0)
end function

/// Resolves a checked ready-weapon index to its ammo pool or the no-ammo sentinel.
/// @param weapon Weapon value supplied to `_ST_WeaponAmmoType`.
/// @internal
function inline _ST_WeaponAmmoType(weapon)
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

/// Maps clamped health to the cached five-tier face-patch row offset.
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

/// Runs the prioritized death, grin, damage-direction, rampage, god, and idle face state machine.
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
    if _ST_ToInt(st_plyr.damagecount, 0) > 0 and st_plyr.mo is not void and st_plyr.attacker is not void and st_plyr.attacker != st_plyr.mo and typeof(st_plyr.attacker.x) == "int" and typeof(st_plyr.attacker.y) == "int" then
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

/// Copies current player health/armor/ammo/keys/weapons/frags into widget references and advances face/message
/// state.
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

/// Samples a new random face value, refreshes widget references, and records health once per game tic.
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

/// Selects damage, bonus, or radiation palette feedback and routes OpenGL flashes separately from indexed
/// palettes.
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

  if R_RendererIsOpenGL() then
    if typeof(IGL_SetPaletteFlash) == "function" then IGL_SetPaletteFlash(palette) end if
    if palette != 0 then palette = 0 end if
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

/// Rebuilds the static classic status-bar background, multiplayer faceback, and optional HD overlays.
function ST_refreshBackground()
  if not _ST_GetRef(st_statusbaron_ref, false) then return end if
  if st_stbar is void then return end if

  V_DrawPatch(0, 0, 4, st_stbar)
  if netgame and st_faceback is not void then
    V_DrawPatch(ST_FX, 0, 4, st_faceback)
  end if
  V_CopyRect(0, 0, 4, ST_WIDTH, ST_HEIGHT, 0, ST_Y, 0)
  if typeof(V_DrawNamedUpscaledPatchOverlay) == "function" then
    V_DrawNamedUpscaledPatchOverlay(0, ST_Y, "STBAR", false)
    if netgame and st_faceback is not void then
      V_DrawNamedUpscaledPatchOverlay(ST_FX, ST_Y, _ST_FacebackName(), false)
    end if
  else if typeof(V_DrawUpscaledPatchOverlay) == "function" then
    V_DrawUpscaledPatchOverlay(0, ST_Y, st_stbar, false)
  end if
end function

/// Draws enabled ammo, health, armor, arms/frags, face, and key widgets in dependency-safe order.
/// @param refresh Refresh value supplied to `ST_drawWidgets`.
function ST_drawWidgets(refresh)
  if not _ST_GetRef(st_statusbaron_ref, false) then return end if

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

/// Clears the first-frame flag, restores the static background, and forces every dynamic widget to redraw.
function ST_doRefresh()
  global st_firsttime
  st_firsttime = false
  ST_refreshBackground()
  ST_drawWidgets(true)
end function

/// Redraws only widgets whose referenced values changed since the previous frame.
function ST_diffDraw()
  ST_drawWidgets(false)
end function

/// Caches and names all number, key, arms, face, faceback, and background patches used by status widgets.
function ST_loadGraphics()
  global st_stbar
  global st_faceback
  global st_armsbg_patch
  global st_tallnum
  global st_tallpercent
  global st_shortnum
  global st_keys
  global st_faces

  tallNames =["STTNUM0", "STTNUM1", "STTNUM2", "STTNUM3", "STTNUM4", "STTNUM5", "STTNUM6", "STTNUM7", "STTNUM8", "STTNUM9"]
  shortNames =["STYSNUM0", "STYSNUM1", "STYSNUM2", "STYSNUM3", "STYSNUM4", "STYSNUM5", "STYSNUM6", "STYSNUM7", "STYSNUM8", "STYSNUM9"]
  keyNames =["STKEYS0", "STKEYS1", "STKEYS2", "STKEYS3", "STKEYS4", "STKEYS5"]
  gunNames =["STGNUM2", "STGNUM3", "STGNUM4", "STGNUM5", "STGNUM6", "STGNUM7"]
  faceNames =[
    "STFST00", "STFST01", "STFST02", "STFTR00", "STFTL00", "STFOUCH0", "STFEVL0", "STFKILL0",
    "STFST10", "STFST11", "STFST12", "STFTR10", "STFTL10", "STFOUCH1", "STFEVL1", "STFKILL1",
    "STFST20", "STFST21", "STFST22", "STFTR20", "STFTL20", "STFOUCH2", "STFEVL2", "STFKILL2",
    "STFST30", "STFST31", "STFST32", "STFTR30", "STFTL30", "STFOUCH3", "STFEVL3", "STFKILL3",
    "STFST40", "STFST41", "STFST42", "STFTR40", "STFTL40", "STFOUCH4", "STFEVL4", "STFKILL4",
    "STFGOD0", "STFDEAD0"
  ]

  st_tallnum =[]
  st_shortnum =[]
  i = 0
  while i < len(tallNames) and i < len(shortNames)
    st_tallnum = _ST_ArrayAppend(st_tallnum, _ST_LoadPatchRequired(tallNames[i]))
    st_shortnum = _ST_ArrayAppend(st_shortnum, _ST_LoadPatchRequired(shortNames[i]))
    i = i + 1
  end while

  st_tallpercent = _ST_LoadPatchRequired("STTPRCNT")

  st_keys =[]
  i = 0
  while i < NUMCARDS and i < len(keyNames)
    st_keys = _ST_ArrayAppend(st_keys, _ST_LoadPatchRequired(keyNames[i]))
    i = i + 1
  end while

  st_armsbg_patch = _ST_LoadPatchRequired("STARMS")

  i = 0
  while i < 6 and i < len(gunNames)
    p0 = _ST_LoadPatchRequired(gunNames[i])
    p1 = void
    if i + 2 < len(st_shortnum) then
      p1 = st_shortnum[i + 2]
    end if
    st_arms_patches[i] =[p0, p1]
    i = i + 1
  end while

  st_faceback = _ST_LoadPatchRequired(_ST_FacebackName())
  st_stbar = _ST_LoadPatchRequired("STBAR")

  st_faces =[]
  i = 0
  while i < len(faceNames)
    facePatch = _ST_LoadPatchRequired(faceNames[i])
    st_faces = _ST_ArrayAppend(st_faces, facePatch)
    i = i + 1
  end while
end function

/// Resolves the PLAYPAL lump and loads the complete status-bar patch set.
function ST_loadData()
  global lu_palette
  if typeof(W_GetNumForName) == "function" then
    lu_palette = W_GetNumForName("PLAYPAL")
  else
    lu_palette = -1
  end if
  ST_loadGraphics()
end function

/// Drops all status-bar patch references and clears compound arms icon slots.
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

/// Releases status-bar graphics through the module's data-teardown entry point.
function ST_unloadData()
  ST_unloadGraphics()
end function

/// Resets status/chat/face/palette history and snapshots initial player weapon ownership for a new level.
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

/// Binds every status-bar widget to its screen coordinates, patch set, value reference, and visibility
/// reference.
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

/// Ensures graphics are loaded, resets per-level state, creates widgets, and activates status rendering.
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

/// Restores the base PLAYPAL palette and deactivates status-bar rendering.
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

/// Consumes automap enter/exit messages and recognized cheat sequences, including map-warp validation.
/// @param ev Input event to process.
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

/// Forces the next status bar draw to rebuild all static and dynamic widgets.
function ST_ForceRefresh()
  global st_firsttime

  st_firsttime = true
end function

/// Chooses full or differential status redraw, synchronizes fullscreen/automap visibility, and applies palette
/// feedback.
/// @param fullscreen Fullscreen value supplied to `ST_Drawer`.
/// @param refresh Refresh value supplied to `ST_Drawer`.
function ST_Drawer(fullscreen, refresh)
  global st_firsttime
  if not st_started then return end if

  nextStatusBarOn = (not fullscreen) or automapactive
  prevStatusBarOn = _ST_GetRef(st_statusbaron_ref, false)
  if prevStatusBarOn != nextStatusBarOn then
    st_firsttime = true
  end if
  st_statusbaron_ref[0] = nextStatusBarOn
  st_firsttime = st_firsttime or refresh

  ST_doPaletteStuff()

  if st_firsttime then
    ST_doRefresh()
  else
    ST_diffDraw()
  end if
end function

/// Loads status resources, allocates the dedicated 320x32 background screen, and requests an initial full draw.
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



