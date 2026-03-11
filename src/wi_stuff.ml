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
* Function: _WI_IDiv
* Purpose: Implements the _WI_IDiv routine for the internal module support.
*/
function _WI_IDiv(a, b)
  if typeof(a) != "int" or typeof(b) != "int" or b == 0 then return 0 end if
  q = a / b
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

const DM_MATRIXX = 42
const DM_MATRIXY = 68
const DM_SPACINGX = 40
const DM_TOTALSX = 269

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

cnt_kills =[0, 0, 0, 0]
cnt_items =[0, 0, 0, 0]
cnt_secret =[0, 0, 0, 0]
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
* Function: _WI_TargetKills
* Purpose: Reads or updates state used by the internal module support.
*/
function _WI_TargetKills(index)
  p = _WI_GetPlr(index)
  if p is not void and wbs is not void and wbs.maxkills > 0 then
    return _WI_IDiv(p.skills * 100, wbs.maxkills)
  end if
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
    return _WI_IDiv(p.sitems * 100, wbs.maxitems)
  end if
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
    return _WI_IDiv(p.ssecret * 100, wbs.maxsecret)
  end if
  if typeof(players) == "array" and index >= 0 and index < len(players) then
    pp = players[index]
    if pp is not void and totalsecret > 0 then
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
  if typeof(players) == "array" and index >= 0 and index < len(players) and players[index] is not void then
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
function WI_fragSum(fragsArray)
  if typeof(fragsArray) != "array" then return 0 end if
  sum = 0
  i = 0
  while i < len(fragsArray)
    if i != me then sum = sum + fragsArray[i] end if
    i = i + 1
  end while
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
  global firstrefresh
  firstrefresh = 1
  global cnt
  cnt = TICRATE
end function

/*
* Function: WI_updateDeathmatchStats
* Purpose: Advances per-tick logic for the intermission subsystem.
*/
function WI_updateDeathmatchStats()
  WI_updateStats()
end function

/*
* Function: WI_drawDeathmatchStats
* Purpose: Draws or renders output for the intermission subsystem.
*/
function WI_drawDeathmatchStats()
  WI_slamBackground()
  WI_drawLF()
  WI_drawStats()
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
  global firstrefresh
  firstrefresh = 1
  global cnt
  cnt = TICRATE
end function

/*
* Function: WI_updateNetgameStats
* Purpose: Advances per-tick logic for the intermission subsystem.
*/
function WI_updateNetgameStats()
  WI_updateStats()
end function

/*
* Function: WI_drawNetgameStats
* Purpose: Draws or renders output for the intermission subsystem.
*/
function WI_drawNetgameStats()
  WI_slamBackground()
  WI_drawLF()
  WI_drawStats()
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

    if typeof(players) != "array" or i >= len(players) or players[i] is void then
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
end function

/*
* Function: WI_initVariables
* Purpose: Initializes state and dependencies for the intermission subsystem.
*/
function WI_initVariables(wbstartstruct)
  if wbstartstruct is void then
    pnum = 0
    if typeof(consoleplayer) == "int" then pnum = consoleplayer end if
    wbstartstruct = wbstartstruct_t(gameepisode - 1, false, gamemap - 1, gamemap, totalkills, totalitems, totalsecret, 0, 0, pnum,[])
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



