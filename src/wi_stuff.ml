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

  Script: wi_stuff.ml
  Purpose: Implements intermission flow, counters, and transition screens.
*/
import doomdef
import z_zone
import m_random
import m_swap
import i_system
import w_wad
import g_game
import r_local
import s_sound
import doomstat
import sounds
import v_video
import d_player
import r_defs

/*
* Enum: stateenum_t
* Purpose: Defines named constants for stateenum type.
*/
enum stateenum_t
  NoState = -1
  StatCount = 0
  ShowNextLoc = 1
end enum

/*
* Enum: animenum_t
* Purpose: Defines named constants for animenum type.
*/
enum animenum_t
  ANIM_ALWAYS
  ANIM_RANDOM
  ANIM_LEVEL
end enum

/*
* Struct: point_t
* Purpose: Stores runtime data for point type.
*/
struct point_t
  x
  y
end struct

/*
* Struct: anim_t
* Purpose: Stores runtime data for anim type.
*/
struct anim_t
  type
  period
  nanims
  loc
  data1
  data2
  p
  nexttic
  lastdrawn
  ctr
  state
end struct

/*
* Function: _WI_Point
* Purpose: Implements the _WI_Point routine for the internal module support.
*/
function _WI_Point(x, y)
  return point_t(x, y)
end function

/*
* Function: _WI_AnimDefault
* Purpose: Implements the _WI_AnimDefault routine for the internal module support.
*/
function _WI_AnimDefault()
  return anim_t(animenum_t.ANIM_ALWAYS, _WI_IDiv(TICRATE, 3), 1, _WI_Point(0, 0), 0, 0,[void, void, void], 0, -1, 0, 0)
end function

/*
* Function: _WI_Abs
* Purpose: Implements the _WI_Abs routine for the internal module support.
*/
function _WI_Abs(v)
  if v < 0 then return - v end if
  return v
end function

/*
* Function: _WI_ToInt
* Purpose: Normalizes values to int for intermission math and counters.
*/
function _WI_ToInt(v, fallback)
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
* Function: _WI_IDiv
* Purpose: Implements the _WI_IDiv routine for the internal module support.
*/
function _WI_IDiv(a, b)
  ai = _WI_ToInt(a, 0)
  bi = _WI_ToInt(b, 0)
  if bi == 0 then return 0 end if
  q = ai / bi
  if q >= 0 then return std.math.floor(q) end if
  return std.math.ceil(q)
end function

/*
* Function: _WI_Clamp
* Purpose: Implements the _WI_Clamp routine for the internal module support.
*/
function _WI_Clamp(v, lo, hi)
  if v < lo then return lo end if
  if v > hi then return hi end if
  return v
end function

/*
* Function: _WI_PatchW
* Purpose: Implements the _WI_PatchW routine for the internal module support.
*/
function _WI_PatchW(p)
  if p is void then return 8 end if
  if typeof(Patch_Width) == "function" then return Patch_Width(p) end if
  return 8
end function

/*
* Function: _WI_PatchH
* Purpose: Implements the _WI_PatchH routine for the internal module support.
*/
function _WI_PatchH(p)
  if p is void then return 8 end if
  if typeof(Patch_Height) == "function" then return Patch_Height(p) end if
  return 8
end function

/*
* Function: _WI_SafeDrawPatch
* Purpose: Draws or renders output for the internal module support.
*/
function _WI_SafeDrawPatch(x, y, patch)
  if patch is void then return end if
  if typeof(V_DrawPatch) == "function" then
    V_DrawPatch(x, y, 0, patch)
  end if
end function

/*
* Function: _WI_SafeStartSound
* Purpose: Starts runtime behavior in the internal module support.
*/
function _WI_SafeStartSound(origin, sfx)
  if typeof(S_StartSound) == "function" then
    S_StartSound(origin, sfx)
  end if
end function

/*
* Function: _WI_CacheOrVoid
* Purpose: Retrieves and caches data for the internal module support.
*/
function _WI_CacheOrVoid(name, tag)
  if typeof(W_CheckNumForName) == "function" then
    ln = W_CheckNumForName(name)
    if ln < 0 then return void end if
    return W_CacheLumpNum(ln, tag)
  end if
  return W_CacheLumpName(name, tag)
end function

const NUMEPISODES = 4
const NUMMAPS = 9

const WI_TITLEY = 2
const WI_SPACINGY = 33

const SP_STATSX = 50
const SP_STATSY = 50
const SP_TIMEX = 16
const SP_TIMEY =(SCREENHEIGHT - 32)

const NG_STATSY = 50
const NG_STATSX = 32
const NG_SPACINGX = 64
const NG_NAMEX = 6
const NG_NAMEYOFF = 10

const DM_MATRIXX = 42
const DM_MATRIXY = 68
const DM_SPACINGX = 40
const DM_TOTALSX = 269
const DM_KILLERSX = 10
const DM_KILLERSY = 100
const DM_VICTIMSX = 5
const DM_VICTIMSY = 50

const SHOWNEXTLOCDELAY = 4
const WI_FB = 0

const SP_KILLS = 0
const SP_ITEMS = 2
const SP_SECRET = 4
const SP_FRAGS = 6
const SP_TIME = 8
const SP_PAR = 8
const SP_PAUSE = 1

acceleratestage = 0
me = 0
state = stateenum_t.NoState
wbs = void
plrs =[]
cnt = 0
bcnt = 0
firstrefresh = 1
sp_state = 0
ng_state = 0
dm_state = 0

cnt_kills =[0, 0, 0, 0]
cnt_items =[0, 0, 0, 0]
cnt_secret =[0, 0, 0, 0]
cnt_frags =[0, 0, 0, 0]
dm_totals =[0, 0, 0, 0]
dm_frags =[
[0, 0, 0, 0],
[0, 0, 0, 0],
[0, 0, 0, 0],
[0, 0, 0, 0]
]
dofrags = false
cnt_time = 0
cnt_par = 0
cnt_pause = 0

NUMCMAPS = 32

bg = void
yah =[void, void]
splat = void
percent = void
colon = void
num =[void, void, void, void, void, void, void, void, void, void]
wiminus = void
finished = void
entering = void
sp_secret = void
kills = void
secret = void
items = void
frags = void
timepatch = void
par = void
sucks = void
killers = void
victims = void
total = void
star = void
bstar = void
wi_p =[void, void, void, void]
wi_bp =[void, void, void, void]
lnames =[]

lnodes =[
[_WI_Point(185, 164), _WI_Point(148, 143), _WI_Point(69, 122), _WI_Point(209, 102), _WI_Point(116, 89), _WI_Point(166, 55), _WI_Point(71, 56), _WI_Point(135, 29), _WI_Point(71, 24)],
[_WI_Point(254, 25), _WI_Point(97, 50), _WI_Point(188, 64), _WI_Point(128, 78), _WI_Point(214, 92), _WI_Point(133, 130), _WI_Point(208, 136), _WI_Point(148, 140), _WI_Point(235, 158)],
[_WI_Point(156, 168), _WI_Point(48, 154), _WI_Point(174, 95), _WI_Point(265, 75), _WI_Point(130, 48), _WI_Point(279, 23), _WI_Point(198, 48), _WI_Point(140, 25), _WI_Point(281, 136)],
[_WI_Point(0, 0), _WI_Point(0, 0), _WI_Point(0, 0), _WI_Point(0, 0), _WI_Point(0, 0), _WI_Point(0, 0), _WI_Point(0, 0), _WI_Point(0, 0), _WI_Point(0, 0)]
]

anims =[[],[],[],[]]

wi_started = false
wi_wbstart = void

/*
* Function: _WI_GetPlr
* Purpose: Reads or updates state used by the internal module support.
*/
function _WI_GetPlr(index)
  if typeof(plrs) != "array" then return void end if
  if index < 0 or index >= len(plrs) then return void end if
  return plrs[index]
end function

/*
* Function: _WI_PlayerIngame
* Purpose: Returns whether a player slot is active for intermission tables.
*/
function _WI_PlayerIngame(index)
  if typeof(plrs) == "array" and index >= 0 and index < len(plrs) and typeof(plrs[index]) == "struct" then
    iv = plrs[index].inum
    if typeof(iv) == "bool" then return iv end if
    if typeof(iv) == "int" then return iv != 0 end if
    if iv then return true end if
  end if
  if typeof(playeringame) != "array" then return false end if
  if index < 0 or index >= len(playeringame) then return false end if
  return playeringame[index]
end function

/*
* Function: _WI_GetPlrFrag
* Purpose: Reads one frag-matrix entry from wb player stats safely.
*/
function _WI_GetPlrFrag(playernum, target)
  p = _WI_GetPlr(playernum)
  if typeof(p) != "struct" or typeof(p.frags) != "array" then return 0 end if
  if target < 0 or target >= len(p.frags) then return 0 end if
  return _WI_ToInt(p.frags[target], 0)
end function

/*
* Function: _WI_TargetKills
* Purpose: Reads or updates state used by the internal module support.
*/
function _WI_TargetKills(index)
  p = _WI_GetPlr(index)
  if p is not void and wbs is not void and wbs.maxkills > 0 then
    return _WI_IDiv(_WI_ToInt(p.skills, 0) * 100, _WI_ToInt(wbs.maxkills, 1))
  end if
  if netgame then return 0 end if
  if typeof(players) == "array" and index >= 0 and index < len(players) then
    pp = players[index]
    if pp is not void and totalkills > 0 then
      return _WI_IDiv(pp.killcount * 100, totalkills)
    end if
  end if
  return 0
end function

/*
* Function: _WI_TargetItems
* Purpose: Reads or updates state used by the internal module support.
*/
function _WI_TargetItems(index)
  p = _WI_GetPlr(index)
  if p is not void and wbs is not void and wbs.maxitems > 0 then
    return _WI_IDiv(_WI_ToInt(p.sitems, 0) * 100, _WI_ToInt(wbs.maxitems, 1))
  end if
  if netgame then return 0 end if
  if typeof(players) == "array" and index >= 0 and index < len(players) then
    pp = players[index]
    if pp is not void and totalitems > 0 then
      return _WI_IDiv(pp.itemcount * 100, totalitems)
    end if
  end if
  return 0
end function

/*
* Function: _WI_TargetSecrets
* Purpose: Reads or updates state used by the internal module support.
*/
function _WI_TargetSecrets(index)
  p = _WI_GetPlr(index)
  if p is not void and wbs is not void and wbs.maxsecret > 0 then
    return _WI_IDiv(_WI_ToInt(p.ssecret, 0) * 100, _WI_ToInt(wbs.maxsecret, 1))
  end if
  if netgame then return 0 end if
  if typeof(players) == "array" and index >= 0 and index < len(players) then
    pp = players[index]
    if typeof(pp) == "struct" and totalsecret > 0 then
      return _WI_IDiv(pp.secretcount * 100, totalsecret)
    end if
  end if
  return 0
end function

/*
* Function: _WI_TargetTime
* Purpose: Reads or updates state used by the internal module support.
*/
function _WI_TargetTime(index)
  p = _WI_GetPlr(index)
  if p is not void and typeof(p.stime) == "int" then return _WI_IDiv(p.stime, TICRATE) end if
  if typeof(players) == "array" and index >= 0 and index < len(players) and typeof(players[index]) == "struct" then
    return _WI_IDiv(leveltime, TICRATE)
  end if
  return 0
end function

/*
* Function: _WI_TargetPar
* Purpose: Reads or updates state used by the internal module support.
*/
function _WI_TargetPar()
  if wbs is not void and typeof(wbs.partime) == "int" then return _WI_IDiv(wbs.partime, TICRATE) end if
  return 0
end function

/*
* Function: WI_slamBackground
* Purpose: Implements the WI_slamBackground routine for the intermission subsystem.
*/
function WI_slamBackground()
  if bg is not void then
    _WI_SafeDrawPatch(0, 0, bg)
  else
    if typeof(screens) == "array" and WI_FB < len(screens) and typeof(screens[WI_FB]) == "bytes" then
      buf = screens[WI_FB]
      i = 0
      while i < len(buf)
        buf[i] = 0
        i = i + 1
      end while
    end if
  end if
  if typeof(V_MarkRect) == "function" then
    V_MarkRect(0, 0, SCREENWIDTH, SCREENHEIGHT)
  end if
end function

/*
* Function: WI_Responder
* Purpose: Implements the WI_Responder routine for the intermission subsystem.
*/
function WI_Responder(ev)
  if ev is void then return false end if
  if ev.type == evtype_t.ev_keydown then
    global acceleratestage
    acceleratestage = 1
    return true
  end if
  return false
end function

/*
* Function: WI_drawLF
* Purpose: Draws or renders output for the intermission subsystem.
*/
function WI_drawLF()
  if finished is not void then
    _WI_SafeDrawPatch(10, WI_TITLEY, finished)
  end if
end function

/*
* Function: WI_drawEL
* Purpose: Draws or renders output for the intermission subsystem.
*/
function WI_drawEL()
  if entering is not void then
    _WI_SafeDrawPatch(10, WI_TITLEY, entering)
  end if
end function

/*
* Function: WI_drawOnLnode
* Purpose: Draws or renders output for the intermission subsystem.
*/
function WI_drawOnLnode(n, c)
  c = c
  if wbs is void then return end if
  ep = _WI_Clamp(wbs.epsd, 0, NUMEPISODES - 1)
  if ep >= len(lnodes) then return end if
  if n < 0 or n >= len(lnodes[ep]) then return end if
  p = lnodes[ep][n]
  if p is void then return end if
  if splat is not void then
    _WI_SafeDrawPatch(p.x, p.y, splat)
  else
    if typeof(screens) == "array" and WI_FB < len(screens) and typeof(screens[WI_FB]) == "bytes" then
      idx = p.y * SCREENWIDTH + p.x
      if idx >= 0 and idx < len(screens[WI_FB]) then screens[WI_FB][idx] = 255 end if
    end if
  end if
end function

/*
* Function: WI_initAnimatedBack
* Purpose: Initializes state and dependencies for the intermission subsystem.
*/
function WI_initAnimatedBack()
  if wbs is void then return end if
  ep = _WI_Clamp(wbs.epsd, 0, NUMEPISODES - 1)
  if ep < 0 or ep >= len(anims) then return end if
  i = 0
  while i < len(anims[ep])
    a = anims[ep][i]
    a.ctr = 0
    a.nexttic = bcnt + a.period
    a.lastdrawn = -1
    i = i + 1
  end while
end function

/*
* Function: WI_updateAnimatedBack
* Purpose: Advances per-tick logic for the intermission subsystem.
*/
function WI_updateAnimatedBack()
  if wbs is void then return end if
  ep = _WI_Clamp(wbs.epsd, 0, NUMEPISODES - 1)
  if ep < 0 or ep >= len(anims) then return end if
  i = 0
  while i < len(anims[ep])
    a = anims[ep][i]
    if bcnt >= a.nexttic then
      a.ctr = a.ctr + 1
      if a.nanims > 0 then a.ctr = a.ctr % a.nanims end if
      a.nexttic = bcnt + a.period
    end if
    i = i + 1
  end while
end function

/*
* Function: WI_drawAnimatedBack
* Purpose: Draws or renders output for the intermission subsystem.
*/
function WI_drawAnimatedBack()
  if wbs is void then return end if
  ep = _WI_Clamp(wbs.epsd, 0, NUMEPISODES - 1)
  if ep < 0 or ep >= len(anims) then return end if
  i = 0
  while i < len(anims[ep])
    a = anims[ep][i]
    if a.p is not void and a.ctr >= 0 and a.ctr < len(a.p) then
      _WI_SafeDrawPatch(a.loc.x, a.loc.y, a.p[a.ctr])
    end if
    i = i + 1
  end while
end function

/*
* Function: WI_drawNum
* Purpose: Draws or renders output for the intermission subsystem.
*/
function WI_drawNum(x, y, n, digits)
  if digits < 0 then digits = 0 end if

  neg = false
  if n < 0 then
    neg = true
    n = -n
  end if

  txt = "" + n
  if digits > 0 then
    while len(bytes(txt)) < digits
      txt = "0" + txt
    end while
  end if

  if neg and wiminus is not void then
    _WI_SafeDrawPatch(x, y, wiminus)
    x = x + _WI_PatchW(wiminus)
  end if

  b = bytes(txt)
  i = 0
  while i < len(b)
    d = b[i] - 48
    if d >= 0 and d <= 9 and d < len(num) then
      p = num[d]
      _WI_SafeDrawPatch(x, y, p)
      x = x + _WI_PatchW(p)
    end if
    i = i + 1
  end while
  return x
end function

/*
* Function: _WI_NumPixelWidth
* Purpose: Computes rendered pixel width for one WI number, matching WI_drawNum semantics.
*/
function _WI_NumPixelWidth(n, digits)
  if typeof(n) != "int" then n = _WI_ToInt(n, 0) end if
  if typeof(digits) != "int" then digits = _WI_ToInt(digits, 0) end if
  if digits < 0 then digits = 0 end if

  neg = false
  if n < 0 then
    neg = true
    n = -n
  end if

  txt = "" + n
  if digits > 0 then
    while len(bytes(txt)) < digits
      txt = "0" + txt
    end while
  end if

  w = 0
  if neg and wiminus is not void then
    w = w + _WI_PatchW(wiminus)
  end if

  b = bytes(txt)
  i = 0
  while i < len(b)
    d = b[i] - 48
    if d >= 0 and d <= 9 and d < len(num) then
      w = w + _WI_PatchW(num[d])
    end if
    i = i + 1
  end while
  return w
end function

/*
* Function: WI_drawNumRight
* Purpose: Draws number right-aligned to xRight.
*/
function WI_drawNumRight(xRight, y, n, digits)
  w = _WI_NumPixelWidth(n, digits)
  return WI_drawNum(xRight - w, y, n, digits)
end function

/*
* Function: WI_drawPercent
* Purpose: Draws or renders output for the intermission subsystem.
*/
function WI_drawPercent(x, y, p)
  xx = x
  if percent is not void then
    _WI_SafeDrawPatch(xx, y, percent)
    xx = xx - _WI_PatchW(percent)
  end if
  return WI_drawNum(xx, y, p, 0)
end function

/*
* Function: WI_drawPercentAligned
* Purpose: Draws percent with numeric part right-aligned before the percent sign.
*/
function WI_drawPercentAligned(x, y, p)
  WI_drawNumRight(x, y, p, 0)
  if percent is not void then
    _WI_SafeDrawPatch(x, y, percent)
  end if
end function

/*
* Function: _WI_Substr
* Purpose: Returns at most n bytes from the beginning of s.
*/
function _WI_Substr(s, n)
  if typeof(s) != "string" then return "" end if
  if typeof(n) != "int" or n <= 0 then return "" end if
  b = bytes(s)
  if n >= len(b) then return s end if
  return decode(slice(b, 0, n))
end function

/*
* Function: _WI_PlayerRowName
* Purpose: Resolves readable player name for intermission net rows.
*/
function _WI_PlayerRowName(slot)
  s = _WI_ToInt(slot, -1)
  if s < 0 then return "P?" end if

  nm = ""
  if typeof(MP_PlatformGetPlayerNameBySlot) == "function" then
    n0 = MP_PlatformGetPlayerNameBySlot(s)
    if typeof(n0) == "string" then nm = n0 end if
  end if
  if nm == "" then
    nm = "P" + (s + 1)
  end if
  // Keep enough room so names do not collide with KILLS column.
  return _WI_Substr(nm, 12)
end function

/*
* Function: _WI_DrawRowName
* Purpose: Draws one player name at netgame row start.
*/
function _WI_DrawRowName(slot, x, y)
  nm = _WI_PlayerRowName(slot)
  if nm == "" then return end if
  if typeof(M_DrawText) == "function" then
    M_DrawText(x, y, false, nm)
    return
  end if
end function

/*
* Function: WI_drawTime
* Purpose: Draws or renders output for the intermission subsystem.
*/
function WI_drawTime(x, y, t)
  if t < 0 then
    if sucks is not void then
      _WI_SafeDrawPatch(x, y, sucks)
    end if
    return
  end if

  sec = t
  h = _WI_IDiv(sec, 3600)
  sec = sec % 3600
  m = _WI_IDiv(sec, 60)
  s = sec % 60

  xx = x
  if h > 0 then
    xx = WI_drawNum(xx, y, h, 0)
    if colon is not void then
      _WI_SafeDrawPatch(xx, y, colon)
      xx = xx + _WI_PatchW(colon)
    end if
  end if
  xx = WI_drawNum(xx, y, m, 2)
  if colon is not void then
    _WI_SafeDrawPatch(xx, y, colon)
    xx = xx + _WI_PatchW(colon)
  end if
  WI_drawNum(xx, y, s, 2)
end function

/*
* Function: WI_End
* Purpose: Implements the WI_End routine for the intermission subsystem.
*/
function WI_End()
  WI_unloadData()
  global wi_started
  wi_started = false
end function

/*
* Function: WI_initNoState
* Purpose: Initializes state and dependencies for the intermission subsystem.
*/
function WI_initNoState()
  global state
  state = stateenum_t.NoState
  global cnt
  cnt = 10
end function

/*
* Function: WI_updateNoState
* Purpose: Advances per-tick logic for the intermission subsystem.
*/
function WI_updateNoState()
  if cnt > 0 then
    global cnt
    cnt = cnt - 1
  else
    if typeof(G_WorldDone) == "function" then
      G_WorldDone()
    else
      gameaction = gameaction_t.ga_worlddone
    end if
  end if
end function

/*
* Function: WI_initShowNextLoc
* Purpose: Initializes state and dependencies for the intermission subsystem.
*/
function WI_initShowNextLoc()
  global state
  state = stateenum_t.ShowNextLoc
  global acceleratestage
  acceleratestage = 0
  global cnt
  cnt = SHOWNEXTLOCDELAY * TICRATE
end function

/*
* Function: WI_updateShowNextLoc
* Purpose: Advances per-tick logic for the intermission subsystem.
*/
function WI_updateShowNextLoc()
  if cnt > 0 then
    global cnt
    cnt = cnt - 1
  end if
  if cnt == 0 or acceleratestage != 0 then
    WI_initNoState()
  end if
end function

/*
* Function: WI_drawShowNextLoc
* Purpose: Draws or renders output for the intermission subsystem.
*/
function WI_drawShowNextLoc()
  WI_slamBackground()
  WI_drawAnimatedBack()

  if wbs is not void then
    last = _WI_Clamp(wbs.last, 0, NUMMAPS - 1)
    next = _WI_Clamp(wbs.next, 0, NUMMAPS - 1)
    WI_drawOnLnode(last, 0)
    WI_drawOnLnode(next, 1)
  end if

  WI_drawEL()
end function

/*
* Function: WI_drawNoState
* Purpose: Draws or renders output for the intermission subsystem.
*/
function WI_drawNoState()
  WI_drawShowNextLoc()
end function

/*
* Function: WI_fragSum
* Purpose: Implements the WI_fragSum routine for the intermission subsystem.
*/
function WI_fragSum(playernum)
  sum = 0
  i = 0
  while i < MAXPLAYERS
    if _WI_PlayerIngame(i) and i != playernum then
      sum = sum + _WI_GetPlrFrag(playernum, i)
    end if
    i = i + 1
  end while
  sum = sum - _WI_GetPlrFrag(playernum, playernum)
  return sum
end function

/*
* Function: WI_initDeathmatchStats
* Purpose: Initializes state and dependencies for the intermission subsystem.
*/
function WI_initDeathmatchStats()
  global state
  state = stateenum_t.StatCount
  global acceleratestage
  acceleratestage = 0
  global dm_state
  dm_state = 1
  global cnt_pause
  cnt_pause = TICRATE

  i = 0
  while i < MAXPLAYERS
    if _WI_PlayerIngame(i) then
      j = 0
      while j < MAXPLAYERS
        if _WI_PlayerIngame(j) then
          dm_frags[i][j] = 0
        end if
        j = j + 1
      end while
      dm_totals[i] = 0
    end if
    i = i + 1
  end while
end function

/*
* Function: WI_updateDeathmatchStats
* Purpose: Advances per-tick logic for the intermission subsystem.
*/
function WI_updateDeathmatchStats()
  global acceleratestage
  global dm_state
  global cnt_pause

  if acceleratestage != 0 and dm_state != 4 then
    acceleratestage = 0
    i = 0
    while i < MAXPLAYERS
      if _WI_PlayerIngame(i) then
        j = 0
        while j < MAXPLAYERS
          if _WI_PlayerIngame(j) then
            dm_frags[i][j] = _WI_Clamp(_WI_GetPlrFrag(i, j), -99, 99)
          end if
          j = j + 1
        end while
        dm_totals[i] = _WI_Clamp(WI_fragSum(i), -99, 99)
      end if
      i = i + 1
    end while
    _WI_SafeStartSound(void, sfxenum_t.sfx_barexp)
    dm_state = 4
  end if

  if dm_state == 2 then
    if (bcnt & 3) == 0 then _WI_SafeStartSound(void, sfxenum_t.sfx_pistol) end if
    stillticking = false
    i = 0
    while i < MAXPLAYERS
      if _WI_PlayerIngame(i) then
        j = 0
        while j < MAXPLAYERS
          if _WI_PlayerIngame(j) then
            target = _WI_GetPlrFrag(i, j)
            if dm_frags[i][j] != target then
              if target < 0 then
                dm_frags[i][j] = dm_frags[i][j] - 1
              else
                dm_frags[i][j] = dm_frags[i][j] + 1
              end if
              dm_frags[i][j] = _WI_Clamp(dm_frags[i][j], -99, 99)
              stillticking = true
            end if
          end if
          j = j + 1
        end while
        dm_totals[i] = _WI_Clamp(WI_fragSum(i), -99, 99)
      end if
      i = i + 1
    end while
    if not stillticking then
      _WI_SafeStartSound(void, sfxenum_t.sfx_barexp)
      dm_state = dm_state + 1
    end if
  else if dm_state == 4 then
    if acceleratestage != 0 then
      _WI_SafeStartSound(void, sfxenum_t.sfx_sgcock)
      if gamemode == GameMode_t.commercial then
        WI_initNoState()
      else
        WI_initShowNextLoc()
      end if
    end if
  else if (dm_state & 1) != 0 then
    cnt_pause = cnt_pause - 1
    if cnt_pause <= 0 then
      dm_state = dm_state + 1
      cnt_pause = TICRATE
    end if
  end if
end function

/*
* Function: WI_drawDeathmatchStats
* Purpose: Draws or renders output for the intermission subsystem.
*/
function WI_drawDeathmatchStats()
  WI_slamBackground()
  WI_drawAnimatedBack()
  WI_drawLF()

  if total is not void then
    _WI_SafeDrawPatch(DM_TOTALSX - _WI_IDiv(_WI_PatchW(total), 2), DM_MATRIXY - WI_SPACINGY + 10, total)
  end if
  if killers is not void then _WI_SafeDrawPatch(DM_KILLERSX, DM_KILLERSY, killers) end if
  if victims is not void then _WI_SafeDrawPatch(DM_VICTIMSX, DM_VICTIMSY, victims) end if

  x = DM_MATRIXX + DM_SPACINGX
  y = DM_MATRIXY
  i = 0
  while i < MAXPLAYERS
    x = x + DM_SPACINGX
    y = y + WI_SPACINGY
    i = i + 1
  end while

  y = DM_MATRIXY + 10
  w = 8
  if num is not void and len(num) > 0 then w = _WI_PatchW(num[0]) end if
  i = 0
  while i < MAXPLAYERS
    x = DM_MATRIXX + DM_SPACINGX
    if _WI_PlayerIngame(i) then
      j = 0
      while j < MAXPLAYERS
        if _WI_PlayerIngame(j) then
          WI_drawNum(x + w, y, dm_frags[i][j], 2)
        end if
        x = x + DM_SPACINGX
        j = j + 1
      end while
      WI_drawNum(DM_TOTALSX + w, y, dm_totals[i], 2)
    end if
    y = y + WI_SPACINGY
    i = i + 1
  end while
end function

/*
* Function: WI_initNetgameStats
* Purpose: Initializes state and dependencies for the intermission subsystem.
*/
function WI_initNetgameStats()
  global state
  state = stateenum_t.StatCount
  global acceleratestage
  acceleratestage = 0
  global ng_state
  ng_state = 1
  global cnt_pause
  cnt_pause = TICRATE
  global dofrags
  dofrags = true

  i = 0
  while i < MAXPLAYERS
    if _WI_PlayerIngame(i) then
      cnt_kills[i] = 0
      cnt_items[i] = 0
      cnt_secret[i] = 0
      cnt_frags[i] = 0
      if WI_fragSum(i) != 0 then dofrags = true end if
    end if
    i = i + 1
  end while
end function

/*
* Function: WI_updateNetgameStats
* Purpose: Advances per-tick logic for the intermission subsystem.
*/
function WI_updateNetgameStats()
  global acceleratestage
  global ng_state
  global cnt_pause
  global dofrags

  if acceleratestage != 0 and ng_state != 10 then
    acceleratestage = 0
    i = 0
    while i < MAXPLAYERS
      if _WI_PlayerIngame(i) then
        cnt_kills[i] = _WI_TargetKills(i)
        cnt_items[i] = _WI_TargetItems(i)
        cnt_secret[i] = _WI_TargetSecrets(i)
        if dofrags then cnt_frags[i] = WI_fragSum(i) end if
      end if
      i = i + 1
    end while
    _WI_SafeStartSound(void, sfxenum_t.sfx_barexp)
    ng_state = 10
  end if

  if ng_state == 2 then
    if (bcnt & 3) == 0 then _WI_SafeStartSound(void, sfxenum_t.sfx_pistol) end if
    stillticking = false
    i = 0
    while i < MAXPLAYERS
      if _WI_PlayerIngame(i) then
        cnt_kills[i] = cnt_kills[i] + 2
        tk = _WI_TargetKills(i)
        if cnt_kills[i] >= tk then
          cnt_kills[i] = tk
        else
          stillticking = true
        end if
      end if
      i = i + 1
    end while
    if not stillticking then
      _WI_SafeStartSound(void, sfxenum_t.sfx_barexp)
      ng_state = ng_state + 1
    end if
  else if ng_state == 4 then
    if (bcnt & 3) == 0 then _WI_SafeStartSound(void, sfxenum_t.sfx_pistol) end if
    stillticking = false
    i = 0
    while i < MAXPLAYERS
      if _WI_PlayerIngame(i) then
        cnt_items[i] = cnt_items[i] + 2
        ti = _WI_TargetItems(i)
        if cnt_items[i] >= ti then
          cnt_items[i] = ti
        else
          stillticking = true
        end if
      end if
      i = i + 1
    end while
    if not stillticking then
      _WI_SafeStartSound(void, sfxenum_t.sfx_barexp)
      ng_state = ng_state + 1
    end if
  else if ng_state == 6 then
    if (bcnt & 3) == 0 then _WI_SafeStartSound(void, sfxenum_t.sfx_pistol) end if
    stillticking = false
    i = 0
    while i < MAXPLAYERS
      if _WI_PlayerIngame(i) then
        cnt_secret[i] = cnt_secret[i] + 2
        ts = _WI_TargetSecrets(i)
        if cnt_secret[i] >= ts then
          cnt_secret[i] = ts
        else
          stillticking = true
        end if
      end if
      i = i + 1
    end while
    if not stillticking then
      _WI_SafeStartSound(void, sfxenum_t.sfx_barexp)
      if dofrags then
        ng_state = ng_state + 1
      else
        ng_state = ng_state + 3
      end if
    end if
  else if ng_state == 8 then
    if (bcnt & 3) == 0 then _WI_SafeStartSound(void, sfxenum_t.sfx_pistol) end if
    stillticking = false
    i = 0
    while i < MAXPLAYERS
      if _WI_PlayerIngame(i) then
        cnt_frags[i] = cnt_frags[i] + 1
        tf = WI_fragSum(i)
        if cnt_frags[i] >= tf then
          cnt_frags[i] = tf
        else
          stillticking = true
        end if
      end if
      i = i + 1
    end while
    if not stillticking then
      _WI_SafeStartSound(void, sfxenum_t.sfx_pldeth)
      ng_state = ng_state + 1
    end if
  else if ng_state == 10 then
    if acceleratestage != 0 then
      _WI_SafeStartSound(void, sfxenum_t.sfx_sgcock)
      if gamemode == GameMode_t.commercial then
        WI_initNoState()
      else
        WI_initShowNextLoc()
      end if
    end if
  else if (ng_state & 1) != 0 then
    cnt_pause = cnt_pause - 1
    if cnt_pause <= 0 then
      ng_state = ng_state + 1
      cnt_pause = TICRATE
    end if
  end if
end function

/*
* Function: WI_drawNetgameStats
* Purpose: Draws or renders output for the intermission subsystem.
*/
function WI_drawNetgameStats()
  WI_slamBackground()
  WI_drawAnimatedBack()
  WI_drawLF()

  pwidth = _WI_PatchW(percent)
  ngx = NG_STATSX + _WI_IDiv(_WI_PatchW(star), 2)
  if not dofrags then ngx = ngx + 32 end if

  if kills is not void then _WI_SafeDrawPatch(ngx + NG_SPACINGX - _WI_PatchW(kills), NG_STATSY, kills) end if
  if items is not void then _WI_SafeDrawPatch(ngx + 2 * NG_SPACINGX - _WI_PatchW(items), NG_STATSY, items) end if
  if secret is not void then _WI_SafeDrawPatch(ngx + 3 * NG_SPACINGX - _WI_PatchW(secret), NG_STATSY, secret) end if
  if dofrags and frags is not void then _WI_SafeDrawPatch(ngx + 4 * NG_SPACINGX - _WI_PatchW(frags), NG_STATSY, frags) end if

  y = NG_STATSY + _WI_PatchH(kills)
  i = 0
  while i < MAXPLAYERS
    if _WI_PlayerIngame(i) then
      _WI_DrawRowName(i, NG_NAMEX, y + NG_NAMEYOFF)
      x = ngx
      x = x + NG_SPACINGX
      WI_drawPercentAligned(x, y + 10, cnt_kills[i])
      x = x + NG_SPACINGX
      WI_drawPercentAligned(x, y + 10, cnt_items[i])
      x = x + NG_SPACINGX
      WI_drawPercentAligned(x, y + 10, cnt_secret[i])
      x = x + NG_SPACINGX
      if dofrags then WI_drawNumRight(x, y + 10, cnt_frags[i], -1) end if
      y = y + WI_SPACINGY
    end if
    i = i + 1
  end while
end function

/*
* Function: WI_initStats
* Purpose: Initializes state and dependencies for the intermission subsystem.
*/
function WI_initStats()
  global state
  state = stateenum_t.StatCount
  global acceleratestage
  acceleratestage = 0
  global sp_state
  sp_state = 1
  global firstrefresh
  firstrefresh = 1
  global cnt_pause
  cnt_pause = TICRATE

  i = 0
  while i < MAXPLAYERS
    cnt_kills[i] = -1
    cnt_items[i] = -1
    cnt_secret[i] = -1
    i = i + 1
  end while
  global cnt_time
  cnt_time = -1
  global cnt_par
  cnt_par = -1
end function

/*
* Function: WI_updateStats
* Purpose: Advances per-tick logic for the intermission subsystem.
*/
function WI_updateStats()
  global acceleratestage
  global sp_state
  global cnt_time
  global cnt_par
  global cnt_pause
  if me < 0 or me >= MAXPLAYERS then
    global me
    me = 0
  end if

  tk = _WI_TargetKills(me)
  ti = _WI_TargetItems(me)
  ts = _WI_TargetSecrets(me)
  tt = _WI_TargetTime(me)
  tp = _WI_TargetPar()

  if acceleratestage != 0 and sp_state != 10 then
    acceleratestage = 0
    cnt_kills[me] = tk
    cnt_items[me] = ti
    cnt_secret[me] = ts
    cnt_time = tt
    cnt_par = tp
    _WI_SafeStartSound(void, sfxenum_t.sfx_barexp)
    sp_state = 10
  end if

  if sp_state == 2 then
    cnt_kills[me] = cnt_kills[me] + 2
    if (bcnt & 3) == 0 then _WI_SafeStartSound(void, sfxenum_t.sfx_pistol) end if
    if cnt_kills[me] >= tk then
      cnt_kills[me] = tk
      _WI_SafeStartSound(void, sfxenum_t.sfx_barexp)
      sp_state = sp_state + 1
    end if
  else if sp_state == 4 then
    cnt_items[me] = cnt_items[me] + 2
    if (bcnt & 3) == 0 then _WI_SafeStartSound(void, sfxenum_t.sfx_pistol) end if
    if cnt_items[me] >= ti then
      cnt_items[me] = ti
      _WI_SafeStartSound(void, sfxenum_t.sfx_barexp)
      sp_state = sp_state + 1
    end if
  else if sp_state == 6 then
    cnt_secret[me] = cnt_secret[me] + 2
    if (bcnt & 3) == 0 then _WI_SafeStartSound(void, sfxenum_t.sfx_pistol) end if
    if cnt_secret[me] >= ts then
      cnt_secret[me] = ts
      _WI_SafeStartSound(void, sfxenum_t.sfx_barexp)
      sp_state = sp_state + 1
    end if
  else if sp_state == 8 then
    if (bcnt & 3) == 0 then _WI_SafeStartSound(void, sfxenum_t.sfx_pistol) end if
    cnt_time = cnt_time + 3
    if cnt_time >= tt then cnt_time = tt end if
    cnt_par = cnt_par + 3
    if cnt_par >= tp then
      cnt_par = tp
      if cnt_time >= tt then
        _WI_SafeStartSound(void, sfxenum_t.sfx_barexp)
        sp_state = sp_state + 1
      end if
    end if
  else if sp_state == 10 then
    if acceleratestage != 0 then
      _WI_SafeStartSound(void, sfxenum_t.sfx_sgcock)
      if gamemode == GameMode_t.commercial then
        WI_initNoState()
      else
        WI_initShowNextLoc()
      end if
    end if
  else if (sp_state & 1) != 0 then
    cnt_pause = cnt_pause - 1
    if cnt_pause <= 0 then
      sp_state = sp_state + 1
      cnt_pause = TICRATE
    end if
  end if
end function

/*
* Function: WI_drawStats
* Purpose: Draws or renders output for the intermission subsystem.
*/
function WI_drawStats()
  WI_slamBackground()
  WI_drawAnimatedBack()
  WI_drawLF()

  x = SP_STATSX
  y = SP_STATSY

  if kills is not void then
    _WI_SafeDrawPatch(x, y + _WI_IDiv(WI_SPACINGY * SP_KILLS, 2), kills)
  end if
  if items is not void then
    _WI_SafeDrawPatch(x, y + _WI_IDiv(WI_SPACINGY * SP_ITEMS, 2), items)
  end if
  if sp_secret is not void then
    _WI_SafeDrawPatch(x, y + _WI_IDiv(WI_SPACINGY * SP_SECRET, 2), sp_secret)
  else if secret is not void then
    _WI_SafeDrawPatch(x, y + _WI_IDiv(WI_SPACINGY * SP_SECRET, 2), secret)
  end if

  WI_drawPercent(SP_STATSX + 180, y + _WI_IDiv(WI_SPACINGY * SP_KILLS, 2), _WI_Clamp(cnt_kills[me], 0, 100))
  WI_drawPercent(SP_STATSX + 180, y + _WI_IDiv(WI_SPACINGY * SP_ITEMS, 2), _WI_Clamp(cnt_items[me], 0, 100))
  WI_drawPercent(SP_STATSX + 180, y + _WI_IDiv(WI_SPACINGY * SP_SECRET, 2), _WI_Clamp(cnt_secret[me], 0, 100))

  if timepatch is not void then _WI_SafeDrawPatch(SP_TIMEX, SP_TIMEY, timepatch) end if
  WI_drawTime(SP_TIMEX + 60, SP_TIMEY, cnt_time)
  if par is not void then _WI_SafeDrawPatch(SP_TIMEX + 150, SP_TIMEY, par) end if
  WI_drawTime(SP_TIMEX + 190, SP_TIMEY, cnt_par)
end function

/*
* Function: WI_checkForAccelerate
* Purpose: Evaluates conditions and returns a decision for the intermission subsystem.
*/
function WI_checkForAccelerate()
  global acceleratestage
  i = 0
  while i < MAXPLAYERS
    ingame = false
    if typeof(playeringame) == "array" and i < len(playeringame) then ingame = playeringame[i] end if
    if not ingame then
      i = i + 1
      continue
    end if

    if typeof(players) != "array" or i >= len(players) or typeof(players[i]) != "struct" then
      i = i + 1
      continue
    end if

    p = players[i]
    buttons = 0
    if p.cmd is not void and typeof(p.cmd.buttons) == "int" then
      buttons = p.cmd.buttons
    end if

    if (buttons & buttoncode_t.BT_ATTACK) != 0 then
      if not p.attackdown then acceleratestage = 1 end if
      p.attackdown = true
    else
      p.attackdown = false
    end if

    if (buttons & buttoncode_t.BT_USE) != 0 then
      if not p.usedown then acceleratestage = 1 end if
      p.usedown = true
    else
      p.usedown = false
    end if

    players[i] = p
    i = i + 1
  end while
end function

/*
* Function: WI_loadData
* Purpose: Loads and prepares data required by the intermission subsystem.
*/
function WI_loadData()
  global bg
  bgname = "WIMAP0"
  if gamemode == commercial then

    bgname = "INTERPIC"
  else
    ep = 0
    if wbs is not void and typeof(wbs.epsd) == "int" then ep = wbs.epsd end if
    bgname = "WIMAP" + ep

    if gamemode == GameMode_t.retail and ep == 3 then
      bgname = "INTERPIC"
    end if
  end if
  bg = _WI_CacheOrVoid(bgname, PU_CACHE)

  global yah
  if gamemode != commercial then

    yah =[_WI_CacheOrVoid("WIURH0", PU_CACHE), _WI_CacheOrVoid("WIURH1", PU_CACHE)]
  else

    yah =[void, void]
  end if
  global splat
  if gamemode != commercial then
    splat = _WI_CacheOrVoid("WISPLAT", PU_CACHE)
  else
    splat = void
  end if
  global percent
  percent = _WI_CacheOrVoid("WIPCNT", PU_CACHE)
  global colon
  colon = _WI_CacheOrVoid("WICOLON", PU_CACHE)
  global wiminus
  wiminus = _WI_CacheOrVoid("WIMINUS", PU_CACHE)
  global finished
  finished = _WI_CacheOrVoid("WIF", PU_CACHE)
  global entering
  entering = _WI_CacheOrVoid("WIENTER", PU_CACHE)

  global num
  num =[]
  i = 0
  while i < 10
    num = num +[_WI_CacheOrVoid("WINUM" + i, PU_CACHE)]
    i = i + 1
  end while

  global kills
  kills = _WI_CacheOrVoid("WIOSTK", PU_CACHE)
  global items
  items = _WI_CacheOrVoid("WIOSTI", PU_CACHE)
  global sp_secret
  sp_secret = _WI_CacheOrVoid("WISCRT2", PU_CACHE)
  global secret
  secret = _WI_CacheOrVoid("WIOSTS", PU_CACHE)
  global frags
  frags = _WI_CacheOrVoid("WIFRGS", PU_CACHE)
  global timepatch
  timepatch = _WI_CacheOrVoid("WITIME", PU_CACHE)
  global par
  par = _WI_CacheOrVoid("WIPAR", PU_CACHE)
  global sucks
  sucks = _WI_CacheOrVoid("WISUCKS", PU_CACHE)
  global killers
  killers = _WI_CacheOrVoid("WIKILRS", PU_CACHE)
  global victims
  victims = _WI_CacheOrVoid("WIVCTMS", PU_CACHE)
  global total
  total = _WI_CacheOrVoid("WIMSTT", PU_CACHE)
  global star
  star = _WI_CacheOrVoid("STFST01", PU_CACHE)
  global bstar
  bstar = _WI_CacheOrVoid("STFDEAD0", PU_CACHE)
  global wi_p
  wi_p =[]
  global wi_bp
  wi_bp =[]
  pnames = ["STPB0", "STPB1", "STPB2", "STPB3"]
  bpnames = ["WIBP1", "WIBP2", "WIBP3", "WIBP4"]
  i = 0
  while i < MAXPLAYERS
    pname = "STPB0"
    bpname = "WIBP1"
    if i >= 0 and i < len(pnames) then pname = pnames[i] end if
    if i >= 0 and i < len(bpnames) then bpname = bpnames[i] end if
    pp = _WI_CacheOrVoid(pname, PU_CACHE)
    if pp is void then pp = _WI_CacheOrVoid("STPB0", PU_CACHE) end if
    wi_p = wi_p +[pp]
    bp = _WI_CacheOrVoid(bpname, PU_CACHE)
    if bp is void then bp = _WI_CacheOrVoid("WIBP1", PU_CACHE) end if
    wi_bp = wi_bp +[bp]
    i = i + 1
  end while

  WI_initAnimatedBack()
end function

/*
* Function: WI_unloadData
* Purpose: Loads and prepares data required by the intermission subsystem.
*/
function WI_unloadData()
  global bg
  bg = void
  global num
  num =[]
  i = 0
  while i < 10
    num = num +[void]
    i = i + 1
  end while
  global yah
  yah =[void, void]
  global splat
  splat = void
  global percent
  percent = void
  global colon
  colon = void
  global wiminus
  wiminus = void
  global finished
  finished = void
  global entering
  entering = void
  global wi_p
  wi_p =[void, void, void, void]
  global wi_bp
  wi_bp =[void, void, void, void]
end function

/*
* Function: WI_initVariables
* Purpose: Initializes state and dependencies for the intermission subsystem.
*/
function WI_initVariables(wbstartstruct)
  if wbstartstruct is void then
    pnum = 0
    if typeof(consoleplayer) == "int" then pnum = consoleplayer end if
    plyr =[]
    i = 0
    while i < MAXPLAYERS
      ingame = _WI_PlayerIngame(i)
      skills = 0
      sitems = 0
      ssecret = 0
      stime = _WI_ToInt(leveltime, 0)
      fr =[0, 0, 0, 0]
      if typeof(players) == "array" and i < len(players) and typeof(players[i]) == "struct" then
        pp = players[i]
        skills = _WI_ToInt(pp.killcount, 0)
        sitems = _WI_ToInt(pp.itemcount, 0)
        ssecret = _WI_ToInt(pp.secretcount, 0)
        if typeof(pp.frags) == "array" then
          j = 0
          while j < MAXPLAYERS and j < len(pp.frags)
            fr[j] = _WI_ToInt(pp.frags[j], 0)
            j = j + 1
          end while
        end if
      end if
      plyr = plyr +[wbplayerstruct_t(ingame, skills, sitems, ssecret, stime, fr, 0)]
      i = i + 1
    end while
    wbstartstruct = wbstartstruct_t(gameepisode - 1, false, gamemap - 1, gamemap, _WI_ToInt(totalkills, 1), _WI_ToInt(totalitems, 1), _WI_ToInt(totalsecret, 1), 0, 0, pnum, plyr)
  end if

  global wbs
  wbs = wbstartstruct
  global wi_wbstart
  wi_wbstart = wbstartstruct
  if wbs.pnum < 0 or wbs.pnum >= MAXPLAYERS then
    global me
    me = 0
  else
    me = wbs.pnum
  end if
  if netgame and typeof(consoleplayer) == "int" and consoleplayer >= 0 and consoleplayer < MAXPLAYERS then
    me = consoleplayer
  end if

  if typeof(wbs.plyr) == "array" then
    global plrs
    plrs = wbs.plyr
  else
    plrs =[]
  end if

  if typeof(wbs.maxkills) != "int" or wbs.maxkills <= 0 then wbs.maxkills = 1 end if
  if typeof(wbs.maxitems) != "int" or wbs.maxitems <= 0 then wbs.maxitems = 1 end if
  if typeof(wbs.maxsecret) != "int" or wbs.maxsecret <= 0 then wbs.maxsecret = 1 end if
  if gamemode != GameMode_t.retail and typeof(wbs.epsd) == "int" and wbs.epsd > 2 then
    wbs.epsd = wbs.epsd - 3
  end if

  global acceleratestage
  acceleratestage = 0
  global cnt
  cnt = 0
  global bcnt
  bcnt = 0
  global firstrefresh
  firstrefresh = 1
end function

/*
* Function: WI_Start
* Purpose: Starts runtime behavior in the intermission subsystem.
*/
function WI_Start(wbstartstruct)
  global wi_started
  wi_started = true
  WI_initVariables(wbstartstruct)
  WI_loadData()

  if deathmatch then
    WI_initDeathmatchStats()
  else if netgame then
    WI_initNetgameStats()
  else
    WI_initStats()
  end if
end function

/*
* Function: WI_Ticker
* Purpose: Advances per-tick logic for the intermission subsystem.
*/
function WI_Ticker()
  if not wi_started then return end if

  global bcnt
  bcnt = bcnt + 1
  if bcnt == 1 then
    if gamemode == GameMode_t.commercial then
      S_ChangeMusic(musicenum_t.mus_dm2int, true)
    else
      S_ChangeMusic(musicenum_t.mus_inter, true)
    end if
  end if
  WI_checkForAccelerate()
  WI_updateAnimatedBack()

  if state == stateenum_t.StatCount then
    if deathmatch then
      WI_updateDeathmatchStats()
    else if netgame then
      WI_updateNetgameStats()
    else
      WI_updateStats()
    end if
  else if state == stateenum_t.ShowNextLoc then
    WI_updateShowNextLoc()
  else
    WI_updateNoState()
  end if
end function

/*
* Function: WI_Drawer
* Purpose: Draws or renders output for the intermission subsystem.
*/
function WI_Drawer()
  if not wi_started then return end if

  if state == stateenum_t.StatCount then
    if deathmatch then
      WI_drawDeathmatchStats()
    else if netgame then
      WI_drawNetgameStats()
    else
      WI_drawStats()
    end if
  else if state == stateenum_t.ShowNextLoc then
    WI_drawShowNextLoc()
  else
    WI_drawNoState()
  end if
end function



