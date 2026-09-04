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

//! Implements intermission flow, counters, and transition screens.

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

/// Identifies scoreboard counting, next-map display, and terminal intermission hold phases.
enum stateenum_t
  /// Represents no state in `stateenum_t`
  NoState = 0 - 1
  /// Represents stat count in `stateenum_t`
  StatCount = 0
  /// Represents show next loc in `stateenum_t`
  ShowNextLoc = 1
end enum

/// Selects looping, randomized-delay, or level-triggered background animation scheduling.
enum animenum_t
  /// Represents anim always in `animenum_t`
  ANIM_ALWAYS
  /// Represents anim random in `animenum_t`
  ANIM_RANDOM
  /// Represents anim level in `animenum_t`
  ANIM_LEVEL
end enum

/// Describes point geometry or asset data used by the intermission system.
struct point_t
  /// Horizontal map- or screen-space coordinate stored by `point_t`
  x
  /// Vertical map- or screen-space coordinate stored by `point_t`
  y
end struct

/// Tracks one intermission background animation's timing, frames, map trigger, and origin.
struct anim_t
  /// Kind discriminator for this record stored by `anim_t`
  type
  /// Stores period for `anim_t`
  period
  /// Stores nanims for `anim_t`
  nanims
  /// Stores loc for `anim_t`
  loc
  /// Stores data1 for `anim_t`
  data1
  /// Stores data2 for `anim_t`
  data2
  /// Stores p for `anim_t`
  p
  /// Stores nexttic for `anim_t`
  nexttic
  /// Stores lastdrawn for `anim_t`
  lastdrawn
  /// Stores ctr for `anim_t`
  ctr
  /// Current state-machine value stored by `anim_t`
  state
end struct

/// Constructs an immutable two-coordinate map-node position.
/// @param x Horizontal map- or screen-space coordinate.
/// @param y Vertical map- or screen-space coordinate.
/// @internal
function inline _WI_Point(x, y)
  return point_t(x, y)
end function

/// Creates an inert animation record used to preallocate episode animation tables.
/// @internal
function inline _WI_AnimDefault()
  return anim_t(animenum_t.ANIM_ALWAYS, _WI_IDiv(TICRATE, 3), 1, _WI_Point(0, 0), 0, 0,[void, void, void], 0, -1, 0, 0)
end function

/// Returns a signed integer magnitude for counter animation and layout math.
/// @param v Value consumed by the operation.
/// @internal
function inline _WI_Abs(v)
  if v < 0 then return - v end if
  return v
end function

/// Normalizes values to int for intermission math and counters.
/// @param v Value consumed by the operation.
/// @param fallback Value returned when the requested conversion or lookup is unavailable.
/// @internal
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

/// Truncates intermission percentage/time quotients toward zero and returns zero on invalid input.
/// @param a First input operand.
/// @param b Second input operand.
/// @internal
function inline _WI_IDiv(a, b)
  ai = _WI_ToInt(a, 0)
  bi = _WI_ToInt(b, 0)
  if bi == 0 then return 0 end if
  q = ai / bi
  if q >= 0 then return std.math.floor(q) end if
  return std.math.ceil(q)
end function

/// Bounds animated counters between their scoreboard-specific minimum and target value.
/// @param v Value consumed by the operation.
/// @param lo Inclusive lower bound.
/// @param hi Inclusive upper bound.
/// @internal
function inline _WI_Clamp(v, lo, hi)
  if v < lo then return lo end if
  if v > hi then return hi end if
  return v
end function

/// Reads a patch width safely for intermission alignment calculations.
/// @param p Object or data record consumed by the operation.
/// @internal
function inline _WI_PatchW(p)
  if p is void then return 8 end if
  if typeof(Patch_Width) == "function" then return Patch_Width(p) end if
  return 8
end function

/// Reads a patch height safely for intermission alignment calculations.
/// @param p Object or data record consumed by the operation.
/// @internal
function inline _WI_PatchH(p)
  if p is void then return 8 end if
  if typeof(Patch_Height) == "function" then return Patch_Height(p) end if
  return 8
end function

/// Draws a patch only when its decoded resource and destination coordinates are valid.
/// @param x Horizontal map- or screen-space coordinate.
/// @param y Vertical map- or screen-space coordinate.
/// @param patch Patch value supplied to `_WI_SafeDrawPatch`.
/// @internal
function inline _WI_SafeDrawPatch(x, y, patch)
  if patch is void then return end if
  if typeof(V_DrawPatch) == "function" then
    V_DrawPatch(x, y, 0, patch)
  end if
end function

/// Draws an intermission patch and its OpenGL high-resolution package image.
/// @param x Horizontal map- or screen-space coordinate.
/// @param y Vertical map- or screen-space coordinate.
/// @param patch Patch value supplied to `_WI_SafeDrawNamedPatch`.
/// @param name Resource or object name to resolve.
/// @internal
function inline _WI_SafeDrawNamedPatch(x, y, patch, name)
  _WI_SafeDrawPatch(x, y, patch)
  if typeof(name) == "string" and name != "" and typeof(V_DrawNamedUpscaledPatchOverlay) == "function" then
    left = 0
    top = 0
    if typeof(patch) == "bytes" then
      if typeof(Patch_LeftOffset) == "function" then left = Patch_LeftOffset(patch) end if
      if typeof(Patch_TopOffset) == "function" then top = Patch_TopOffset(patch) end if
    end if
    V_DrawNamedUpscaledPatchOverlay(x - left, y - top, name, false)
  end if
end function

/// Plays an intermission cue only when the sound backend is available.
/// @param origin Origin value supplied to `_WI_SafeStartSound`.
/// @param sfx Sound-effect descriptor to process.
/// @internal
function inline _WI_SafeStartSound(origin, sfx)
  if typeof(S_StartSound) == "function" then
    S_StartSound(origin, sfx)
  end if
end function

/// Looks up an optional patch lump and caches it with the requested zone tag.
/// @param name Resource or object name to resolve.
/// @param tag Zone-memory or resource-lifetime tag.
/// @internal
function inline _WI_CacheOrVoid(name, tag)
  if typeof(W_CheckNumForName) == "function" then
    ln = W_CheckNumForName(name)
    if ln < 0 then return void end if
    return W_CacheLumpNum(ln, tag)
  end if
  return W_CacheLumpName(name, tag)
end function

/// Defines the numepisodes count used by the wi stuff subsystem.
const NUMEPISODES = 4
/// Defines the nummaps count used by the wi stuff subsystem.
const NUMMAPS = 9

/// Defines wi titley for the wi stuff subsystem.
const WI_TITLEY = 2
/// Defines wi spacingy for the wi stuff subsystem.
const WI_SPACINGY = 33

/// Defines sp statsx for the wi stuff subsystem.
const SP_STATSX = 50
/// Defines sp statsy for the wi stuff subsystem.
const SP_STATSY = 50
/// Defines sp timex for the wi stuff subsystem.
const SP_TIMEX = 16
/// Defines sp timey for the wi stuff subsystem.
const SP_TIMEY =(SCREENHEIGHT - 32)

/// Defines ng statsy for the wi stuff subsystem.
const NG_STATSY = 50
/// Defines ng statsx for the wi stuff subsystem.
const NG_STATSX = 32
/// Defines ng spacingx for the wi stuff subsystem.
const NG_SPACINGX = 64
/// Defines ng namex for the wi stuff subsystem.
const NG_NAMEX = 6
/// Defines ng nameyoff for the wi stuff subsystem.
const NG_NAMEYOFF = 10

/// Defines dm matrixx for the wi stuff subsystem.
const DM_MATRIXX = 42
/// Defines dm matrixy for the wi stuff subsystem.
const DM_MATRIXY = 68
/// Defines dm spacingx for the wi stuff subsystem.
const DM_SPACINGX = 40
/// Defines dm totalsx for the wi stuff subsystem.
const DM_TOTALSX = 269
/// Defines dm killersx for the wi stuff subsystem.
const DM_KILLERSX = 10
/// Defines dm killersy for the wi stuff subsystem.
const DM_KILLERSY = 100
/// Defines dm victimsx for the wi stuff subsystem.
const DM_VICTIMSX = 5
/// Defines dm victimsy for the wi stuff subsystem.
const DM_VICTIMSY = 50

/// Defines shownextlocdelay for the wi stuff subsystem.
const SHOWNEXTLOCDELAY = 4
/// Defines wi fb for the wi stuff subsystem.
const WI_FB = 0

/// Defines sp kills for the wi stuff subsystem.
const SP_KILLS = 0
/// Defines sp items for the wi stuff subsystem.
const SP_ITEMS = 2
/// Defines sp secret for the wi stuff subsystem.
const SP_SECRET = 4
/// Defines sp frags for the wi stuff subsystem.
const SP_FRAGS = 6
/// Defines sp time for the wi stuff subsystem.
const SP_TIME = 8
/// Defines sp par for the wi stuff subsystem.
const SP_PAR = 8
/// Defines sp pause for the wi stuff subsystem.
const SP_PAUSE = 1

/// Tracks the mutable acceleratestage value used by the wi stuff subsystem.
acceleratestage = 0
/// Tracks the mutable me value used by the wi stuff subsystem.
me = 0
/// Exposes `stateenum_t.NoState` through the legacy `state` alias.
state = stateenum_t.NoState
/// Holds the optional wbs resource used by the wi stuff subsystem.
wbs = void
/// Stores the plrs collection used by the wi stuff subsystem.
plrs =[]
/// Tracks the mutable cnt value used by the wi stuff subsystem.
cnt = 0
/// Tracks the mutable bcnt value used by the wi stuff subsystem.
bcnt = 0
/// Tracks the mutable firstrefresh value used by the wi stuff subsystem.
firstrefresh = 1
/// Tracks the mutable sp state value used by the wi stuff subsystem.
sp_state = 0
/// Tracks the mutable ng state value used by the wi stuff subsystem.
ng_state = 0
/// Tracks the mutable dm state value used by the wi stuff subsystem.
dm_state = 0

/// Stores the cnt kills collection used by the wi stuff subsystem.
cnt_kills =[0, 0, 0, 0]
/// Stores the cnt items collection used by the wi stuff subsystem.
cnt_items =[0, 0, 0, 0]
/// Stores the cnt secret collection used by the wi stuff subsystem.
cnt_secret =[0, 0, 0, 0]
/// Stores the cnt frags collection used by the wi stuff subsystem.
cnt_frags =[0, 0, 0, 0]
/// Stores the dm totals collection used by the wi stuff subsystem.
dm_totals =[0, 0, 0, 0]
/// Stores the dm frags collection used by the wi stuff subsystem.
dm_frags =[
[0, 0, 0, 0],
[0, 0, 0, 0],
[0, 0, 0, 0],
[0, 0, 0, 0]
]
/// Tracks whether dofrags is active in the wi stuff subsystem.
dofrags = false
/// Tracks the mutable cnt time value used by the wi stuff subsystem.
cnt_time = 0
/// Tracks the mutable cnt par value used by the wi stuff subsystem.
cnt_par = 0
/// Tracks the mutable cnt pause value used by the wi stuff subsystem.
cnt_pause = 0

/// Tracks the mutable numcmaps value used by the wi stuff subsystem.
NUMCMAPS = 32

/// Holds the optional bg resource used by the wi stuff subsystem.
bg = void
/// Stores the mutable bg name text used by the wi stuff subsystem.
bg_name = ""
/// Stores the yah collection used by the wi stuff subsystem.
yah =[void, void]
/// Stores the yah names collection used by the wi stuff subsystem.
yah_names =["", ""]
/// Holds the optional splat resource used by the wi stuff subsystem.
splat = void
/// Stores the mutable splat name text used by the wi stuff subsystem.
splat_name = ""
/// Holds the optional percent resource used by the wi stuff subsystem.
percent = void
/// Stores the mutable percent name text used by the wi stuff subsystem.
percent_name = ""
/// Holds the optional colon resource used by the wi stuff subsystem.
colon = void
/// Stores the mutable colon name text used by the wi stuff subsystem.
colon_name = ""
/// Stores the num collection used by the wi stuff subsystem.
num =[void, void, void, void, void, void, void, void, void, void]
/// Stores the num names collection used by the wi stuff subsystem.
num_names =["WINUM0", "WINUM1", "WINUM2", "WINUM3", "WINUM4", "WINUM5", "WINUM6", "WINUM7", "WINUM8", "WINUM9"]
/// Holds the optional wiminus resource used by the wi stuff subsystem.
wiminus = void
/// Stores the mutable wiminus name text used by the wi stuff subsystem.
wiminus_name = ""
/// Holds the optional finished resource used by the wi stuff subsystem.
finished = void
/// Stores the mutable finished name text used by the wi stuff subsystem.
finished_name = ""
/// Holds the optional entering resource used by the wi stuff subsystem.
entering = void
/// Stores the mutable entering name text used by the wi stuff subsystem.
entering_name = ""
/// Holds the optional sp secret resource used by the wi stuff subsystem.
sp_secret = void
/// Stores the mutable sp secret name text used by the wi stuff subsystem.
sp_secret_name = ""
/// Holds the optional kills resource used by the wi stuff subsystem.
kills = void
/// Stores the mutable kills name text used by the wi stuff subsystem.
kills_name = ""
/// Holds the optional secret resource used by the wi stuff subsystem.
secret = void
/// Stores the mutable secret name text used by the wi stuff subsystem.
secret_name = ""
/// Holds the optional items resource used by the wi stuff subsystem.
items = void
/// Stores the mutable items name text used by the wi stuff subsystem.
items_name = ""
/// Holds the optional frags resource used by the wi stuff subsystem.
frags = void
/// Stores the mutable frags name text used by the wi stuff subsystem.
frags_name = ""
/// Holds the optional timepatch resource used by the wi stuff subsystem.
timepatch = void
/// Stores the mutable timepatch name text used by the wi stuff subsystem.
timepatch_name = ""
/// Holds the optional par resource used by the wi stuff subsystem.
par = void
/// Stores the mutable par name text used by the wi stuff subsystem.
par_name = ""
/// Holds the optional sucks resource used by the wi stuff subsystem.
sucks = void
/// Stores the mutable sucks name text used by the wi stuff subsystem.
sucks_name = ""
/// Holds the optional killers resource used by the wi stuff subsystem.
killers = void
/// Stores the mutable killers name text used by the wi stuff subsystem.
killers_name = ""
/// Holds the optional victims resource used by the wi stuff subsystem.
victims = void
/// Stores the mutable victims name text used by the wi stuff subsystem.
victims_name = ""
/// Holds the optional total resource used by the wi stuff subsystem.
total = void
/// Stores the mutable total name text used by the wi stuff subsystem.
total_name = ""
/// Holds the optional star resource used by the wi stuff subsystem.
star = void
/// Stores the mutable star name text used by the wi stuff subsystem.
star_name = ""
/// Holds the optional bstar resource used by the wi stuff subsystem.
bstar = void
/// Stores the mutable bstar name text used by the wi stuff subsystem.
bstar_name = ""
/// Stores the wi p collection used by the wi stuff subsystem.
wi_p =[void, void, void, void]
/// Stores the wi p names collection used by the wi stuff subsystem.
wi_p_names =["STPB0", "STPB1", "STPB2", "STPB3"]
/// Stores the wi bp collection used by the wi stuff subsystem.
wi_bp =[void, void, void, void]
/// Stores the wi bp names collection used by the wi stuff subsystem.
wi_bp_names =["WIBP1", "WIBP2", "WIBP3", "WIBP4"]
/// Stores the lnames collection used by the wi stuff subsystem.
lnames =[]

/// Stores the lnodes collection used by the wi stuff subsystem.
lnodes =[
[_WI_Point(185, 164), _WI_Point(148, 143), _WI_Point(69, 122), _WI_Point(209, 102), _WI_Point(116, 89), _WI_Point(166, 55), _WI_Point(71, 56), _WI_Point(135, 29), _WI_Point(71, 24)],
[_WI_Point(254, 25), _WI_Point(97, 50), _WI_Point(188, 64), _WI_Point(128, 78), _WI_Point(214, 92), _WI_Point(133, 130), _WI_Point(208, 136), _WI_Point(148, 140), _WI_Point(235, 158)],
[_WI_Point(156, 168), _WI_Point(48, 154), _WI_Point(174, 95), _WI_Point(265, 75), _WI_Point(130, 48), _WI_Point(279, 23), _WI_Point(198, 48), _WI_Point(140, 25), _WI_Point(281, 136)],
[_WI_Point(0, 0), _WI_Point(0, 0), _WI_Point(0, 0), _WI_Point(0, 0), _WI_Point(0, 0), _WI_Point(0, 0), _WI_Point(0, 0), _WI_Point(0, 0), _WI_Point(0, 0)]
]

/// Stores the anims collection used by the wi stuff subsystem.
anims =[[],[],[],[]]

/// Tracks whether wi started is active in the wi stuff subsystem.
wi_started = false
/// Holds the optional wi wbstart resource used by the wi stuff subsystem.
wi_wbstart = void

/// Returns a checked wminfo player row, falling back to an empty scoreboard record.
/// @param index Zero-based element or table index.
/// @internal
function inline _WI_GetPlr(index)
  if typeof(plrs) != "array" then return void end if
  if index < 0 or index >= len(plrs) then return void end if
  return plrs[index]
end function

/// Returns whether a player slot is active for intermission tables.
/// @param index Zero-based element or table index.
/// @internal
function inline _WI_PlayerIngame(index)
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

/// Reads one frag-matrix entry from wb player stats safely.
/// @param playernum Index identifying player.
/// @param target Target value supplied to `_WI_GetPlrFrag`.
/// @internal
function inline _WI_GetPlrFrag(playernum, target)
  p = _WI_GetPlr(playernum)
  if typeof(p) != "struct" or typeof(p.frags) != "array" then return 0 end if
  if target < 0 or target >= len(p.frags) then return 0 end if
  return _WI_ToInt(p.frags[target], 0)
end function

/// Computes the bounded final kill percentage for the local single-player row.
/// @param index Zero-based element or table index.
/// @internal
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

/// Computes the bounded final item percentage for the local single-player row.
/// @param index Zero-based element or table index.
/// @internal
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

/// Computes the bounded final secret percentage for the local single-player row.
/// @param index Zero-based element or table index.
/// @internal
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

/// Converts the player's completion time from tics to scoreboard seconds.
/// @param index Zero-based element or table index.
/// @internal
function inline _WI_TargetTime(index)
  p = _WI_GetPlr(index)
  if p is not void and typeof(p.stime) == "int" then return _WI_IDiv(p.stime, TICRATE) end if
  if typeof(players) == "array" and index >= 0 and index < len(players) and typeof(players[index]) == "struct" then
    return _WI_IDiv(leveltime, TICRATE)
  end if
  return 0
end function

/// Converts the map par time from tics to scoreboard seconds.
/// @internal
function inline _WI_TargetPar()
  if wbs is not void and typeof(wbs.partime) == "int" then return _WI_IDiv(wbs.partime, TICRATE) end if
  return 0
end function

/// Copies the cached intermission background into the active framebuffer.
function WI_slamBackground()
  if bg is not void then
    _WI_SafeDrawNamedPatch(0, 0, bg, bg_name)
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

/// Records attack/use acceleration requests from every active player during intermission.
/// @param ev Input event to process.
function WI_Responder(ev)
  if ev is void then return false end if
  if ev.type == evtype_t.ev_keydown then
    global acceleratestage
    acceleratestage = 1
    return true
  end if
  return false
end function

/// Draws the localized finished-map heading and current map name.
function WI_drawLF()
  if finished is not void then
    _WI_SafeDrawNamedPatch(10, WI_TITLEY, finished, finished_name)
  end if
end function

/// Draws the localized entering-map heading and next map name.
function WI_drawEL()
  if entering is not void then
    _WI_SafeDrawNamedPatch(10, WI_TITLEY, entering, entering_name)
  end if
end function

/// Places one map marker on a node while keeping its patch inside screen bounds.
/// @param n Number of values to process.
/// @param c C value supplied to `WI_drawOnLnode`.
function WI_drawOnLnode(n, c)
  c = c
  if wbs is void then return end if
  ep = _WI_Clamp(wbs.epsd, 0, NUMEPISODES - 1)
  if ep >= len(lnodes) then return end if
  if n < 0 or n >= len(lnodes[ep]) then return end if
  p = lnodes[ep][n]
  if p is void then return end if
  if splat is not void then
    _WI_SafeDrawNamedPatch(p.x, p.y, splat, splat_name)
  else
    if typeof(screens) == "array" and WI_FB < len(screens) and typeof(screens[WI_FB]) == "bytes" then
      idx = p.y * SCREENWIDTH + p.x
      if idx >= 0 and idx < len(screens[WI_FB]) then screens[WI_FB][idx] = 255 end if
    end if
  end if
end function

/// Resets per-animation frame indices and schedules their first episode-specific background tick.
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

/// Advances looping, one-shot, and level-gated background animations at their configured cadence.
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

/// Draws each active episode-map background animation frame.
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

/// Draws a signed decimal counter using WI digit/minus patches and right alignment.
/// @param x Horizontal map- or screen-space coordinate.
/// @param y Vertical map- or screen-space coordinate.
/// @param n Number of values to process.
/// @param digits Digits value supplied to `WI_drawNum`.
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
    _WI_SafeDrawNamedPatch(x, y, wiminus, wiminus_name)
    x = x + _WI_PatchW(wiminus)
  end if

  b = bytes(txt)
  i = 0
  while i < len(b)
    d = b[i] - 48
    if d >= 0 and d <= 9 and d < len(num) then
      p = num[d]
      nm = ""
      if d >= 0 and d < len(num_names) then nm = num_names[d] end if
      _WI_SafeDrawNamedPatch(x, y, p, nm)
      x = x + _WI_PatchW(p)
    end if
    i = i + 1
  end while
  return x
end function

/// Computes rendered pixel width for one WI number, matching WI_drawNum semantics.
/// @param n Number of values to process.
/// @param digits Digits value supplied to `_WI_NumPixelWidth`.
/// @internal
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

/// Draws number right-aligned to xRight.
/// @param xRight X right value supplied to `WI_drawNumRight`.
/// @param y Vertical map- or screen-space coordinate.
/// @param n Number of values to process.
/// @param digits Digits value supplied to `WI_drawNumRight`.
function WI_drawNumRight(xRight, y, n, digits)
  w = _WI_NumPixelWidth(n, digits)
  return WI_drawNum(xRight - w, y, n, digits)
end function

/// Draws a percentage value followed by the percent patch at the requested anchor.
/// @param x Horizontal map- or screen-space coordinate.
/// @param y Vertical map- or screen-space coordinate.
/// @param p Object or data record consumed by the operation.
function WI_drawPercent(x, y, p)
  n = _WI_ToInt(p, 0)
  if n < 0 then n = -n end if
  digits = 1
  if n >= 100 then
    digits = 3
  else if n >= 10 then
    digits = 2
  end if

  // Keep numbers clear of the percent glyph: shift left by digit count (1/2/3).
  WI_drawNumRight(x - digits, y, p, 0)
  if percent is not void then
    _WI_SafeDrawNamedPatch(x, y, percent, percent_name)
  end if
  return x
end function

/// Draws percent with numeric part right-aligned before the percent sign.
/// @param x Horizontal map- or screen-space coordinate.
/// @param y Vertical map- or screen-space coordinate.
/// @param p Object or data record consumed by the operation.
function WI_drawPercentAligned(x, y, p)
  WI_drawNumRight(x, y, p, 0)
  if percent is not void then
    _WI_SafeDrawNamedPatch(x, y, percent, percent_name)
  end if
end function

/// Returns at most n bytes from the beginning of s.
/// @param s S value supplied to `_WI_Substr`.
/// @param n Number of values to process.
/// @internal
function inline _WI_Substr(s, n)
  if typeof(s) != "string" then return "" end if
  if typeof(n) != "int" or n <= 0 then return "" end if
  b = bytes(s)
  if n >= len(b) then return s end if
  return decode(slice(b, 0, n))
end function

/// Resolves readable player name for intermission net rows.
/// @param slot Slot value supplied to `_WI_PlayerRowName`.
/// @internal
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

/// Draws one player name at netgame row start.
/// @param slot Slot value supplied to `_WI_DrawRowName`.
/// @param x Horizontal map- or screen-space coordinate.
/// @param y Vertical map- or screen-space coordinate.
/// @internal
function inline _WI_DrawRowName(slot, x, y)
  nm = _WI_PlayerRowName(slot)
  if nm == "" then return end if
  if typeof(M_DrawText) == "function" then
    M_DrawText(x, y, false, nm)
    return
  end if
end function

/// Draws mm:ss completion/par time or the overflow label for very long runs.
/// @param x Horizontal map- or screen-space coordinate.
/// @param y Vertical map- or screen-space coordinate.
/// @param t T value supplied to `WI_drawTime`.
function WI_drawTime(x, y, t)
  if t < 0 then
    if sucks is not void then
      _WI_SafeDrawNamedPatch(x, y, sucks, sucks_name)
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
      _WI_SafeDrawNamedPatch(xx, y, colon, colon_name)
      xx = xx + _WI_PatchW(colon)
    end if
  end if
  xx = WI_drawNum(xx, y, m, 2)
  if colon is not void then
    _WI_SafeDrawNamedPatch(xx, y, colon, colon_name)
    xx = xx + _WI_PatchW(colon)
  end if
  WI_drawNum(xx, y, s, 2)
end function

/// Controls end transitions in the intermission system.
function WI_End()
  WI_unloadData()
  global wi_started
  wi_started = false
end function

/// Enters the final ten-tic intermission hold before handing control back to world progression.
function WI_initNoState()
  global state
  state = stateenum_t.NoState
  global cnt
  cnt = 10
end function

/// Counts down the terminal hold and invokes G_WorldDone exactly when it expires.
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

/// Enters the next-location map screen with its fixed delay and pointer blink state reset.
function WI_initShowNextLoc()
  global state
  state = stateenum_t.ShowNextLoc
  global acceleratestage
  acceleratestage = 0
  global cnt
  cnt = SHOWNEXTLOCDELAY * TICRATE
end function

/// Animates the map pointer and transitions to the terminal hold after the location delay.
function WI_updateShowNextLoc()
  if cnt > 0 then
    global cnt
    cnt = cnt - 1
  end if
  if cnt == 0 or acceleratestage != 0 then
    WI_initNoState()
  end if
end function

/// Draws the world map, completed splats, blinking pointer, and entering heading.
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

/// Draws the final static world-map frame before leaving intermission.
function WI_drawNoState()
  WI_drawShowNextLoc()
end function

/// Sums one player's net frags with Doom self-frag subtraction semantics.
/// @param playernum Index identifying player.
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

/// Seeds the deathmatch frag matrix counters and opens the first staged scoreboard pause.
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

/// Animates each frag cell and total toward authoritative values, honoring accelerate-to-finish.
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

/// Draws the deathmatch frag matrix, totals, and host-synchronized player names.
function WI_drawDeathmatchStats()
  WI_slamBackground()
  WI_drawAnimatedBack()
  WI_drawLF()

  if total is not void then
    _WI_SafeDrawNamedPatch(DM_TOTALSX - _WI_IDiv(_WI_PatchW(total), 2), DM_MATRIXY - WI_SPACINGY + 10, total, total_name)
  end if
  if killers is not void then _WI_SafeDrawNamedPatch(DM_KILLERSX, DM_KILLERSY, killers, killers_name) end if
  if victims is not void then _WI_SafeDrawNamedPatch(DM_VICTIMSX, DM_VICTIMSY, victims, victims_name) end if

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

/// Clears cooperative kill/item/secret counters and starts their staged count-up sequence.
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

/// Animates cooperative percentages for all active players and advances through pause stages.
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

/// Draws cooperative kill/item/secret/frag columns for every active slot.
function WI_drawNetgameStats()
  WI_slamBackground()
  WI_drawAnimatedBack()
  WI_drawLF()

  pwidth = _WI_PatchW(percent)
  ngx = NG_STATSX + _WI_IDiv(_WI_PatchW(star), 2)
  if not dofrags then ngx = ngx + 32 end if

  if kills is not void then _WI_SafeDrawNamedPatch(ngx + NG_SPACINGX - _WI_PatchW(kills), NG_STATSY, kills, kills_name) end if
  if items is not void then _WI_SafeDrawNamedPatch(ngx + 2 * NG_SPACINGX - _WI_PatchW(items), NG_STATSY, items, items_name) end if
  if secret is not void then _WI_SafeDrawNamedPatch(ngx + 3 * NG_SPACINGX - _WI_PatchW(secret), NG_STATSY, secret, secret_name) end if
  if dofrags and frags is not void then _WI_SafeDrawNamedPatch(ngx + 4 * NG_SPACINGX - _WI_PatchW(frags), NG_STATSY, frags, frags_name) end if

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

/// Clears single-player counters and begins the kill/item/secret/time tally sequence.
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

/// Animates single-player percentages and times, with attack/use acceleration and stage sounds.
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

/// Draws the animated single-player completion counters and their labels.
function WI_drawStats()
  WI_slamBackground()
  WI_drawAnimatedBack()
  WI_drawLF()

  x = SP_STATSX
  y = SP_STATSY

  if kills is not void then
    _WI_SafeDrawNamedPatch(x, y + _WI_IDiv(WI_SPACINGY * SP_KILLS, 2), kills, kills_name)
  end if
  if items is not void then
    _WI_SafeDrawNamedPatch(x, y + _WI_IDiv(WI_SPACINGY * SP_ITEMS, 2), items, items_name)
  end if
  if sp_secret is not void then
    _WI_SafeDrawNamedPatch(x, y + _WI_IDiv(WI_SPACINGY * SP_SECRET, 2), sp_secret, sp_secret_name)
  else if secret is not void then
    _WI_SafeDrawNamedPatch(x, y + _WI_IDiv(WI_SPACINGY * SP_SECRET, 2), secret, secret_name)
  end if

  WI_drawPercent(SP_STATSX + 180, y + _WI_IDiv(WI_SPACINGY * SP_KILLS, 2), _WI_Clamp(cnt_kills[me], 0, 100))
  WI_drawPercent(SP_STATSX + 180, y + _WI_IDiv(WI_SPACINGY * SP_ITEMS, 2), _WI_Clamp(cnt_items[me], 0, 100))
  WI_drawPercent(SP_STATSX + 180, y + _WI_IDiv(WI_SPACINGY * SP_SECRET, 2), _WI_Clamp(cnt_secret[me], 0, 100))

  if timepatch is not void then _WI_SafeDrawNamedPatch(SP_TIMEX, SP_TIMEY, timepatch, timepatch_name) end if
  WI_drawTime(SP_TIMEX + 60, SP_TIMEY, cnt_time)
  if par is not void then _WI_SafeDrawNamedPatch(SP_TIMEX + 150, SP_TIMEY, par, par_name) end if
  WI_drawTime(SP_TIMEX + 190, SP_TIMEY, cnt_par)
end function

/// Latches rising attack/use buttons from any active player into the shared accelerate flag.
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

/// Caches scoreboard digits, labels, map patches, player markers, and episode animation frames.
function WI_loadData()
  global bg
  global bg_name
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
  bg_name = bgname
  bg = _WI_CacheOrVoid(bgname, PU_CACHE)

  global yah
  global yah_names
  if gamemode != commercial then

    yah =[_WI_CacheOrVoid("WIURH0", PU_CACHE), _WI_CacheOrVoid("WIURH1", PU_CACHE)]
    yah_names =["WIURH0", "WIURH1"]
  else

    yah =[void, void]
    yah_names =["", ""]
  end if
  global splat
  global splat_name
  if gamemode != commercial then
    splat = _WI_CacheOrVoid("WISPLAT", PU_CACHE)
    splat_name = "WISPLAT"
  else
    splat = void
    splat_name = ""
  end if
  global percent
  global percent_name
  percent = _WI_CacheOrVoid("WIPCNT", PU_CACHE)
  percent_name = "WIPCNT"
  global colon
  global colon_name
  colon = _WI_CacheOrVoid("WICOLON", PU_CACHE)
  colon_name = "WICOLON"
  global wiminus
  global wiminus_name
  wiminus = _WI_CacheOrVoid("WIMINUS", PU_CACHE)
  wiminus_name = "WIMINUS"
  global finished
  global finished_name
  finished = _WI_CacheOrVoid("WIF", PU_CACHE)
  finished_name = "WIF"
  global entering
  global entering_name
  entering = _WI_CacheOrVoid("WIENTER", PU_CACHE)
  entering_name = "WIENTER"

  global num
  global num_names
  num =[]
  num_names =[]
  i = 0
  while i < 10
    nm = "WINUM" + i
    num = num +[_WI_CacheOrVoid(nm, PU_CACHE)]
    num_names = num_names +[nm]
    i = i + 1
  end while

  global kills
  global kills_name
  kills = _WI_CacheOrVoid("WIOSTK", PU_CACHE)
  kills_name = "WIOSTK"
  global items
  global items_name
  items = _WI_CacheOrVoid("WIOSTI", PU_CACHE)
  items_name = "WIOSTI"
  global sp_secret
  global sp_secret_name
  sp_secret = _WI_CacheOrVoid("WISCRT2", PU_CACHE)
  sp_secret_name = "WISCRT2"
  global secret
  global secret_name
  secret = _WI_CacheOrVoid("WIOSTS", PU_CACHE)
  secret_name = "WIOSTS"
  global frags
  global frags_name
  frags = _WI_CacheOrVoid("WIFRGS", PU_CACHE)
  frags_name = "WIFRGS"
  global timepatch
  global timepatch_name
  timepatch = _WI_CacheOrVoid("WITIME", PU_CACHE)
  timepatch_name = "WITIME"
  global par
  global par_name
  par = _WI_CacheOrVoid("WIPAR", PU_CACHE)
  par_name = "WIPAR"
  global sucks
  global sucks_name
  sucks = _WI_CacheOrVoid("WISUCKS", PU_CACHE)
  sucks_name = "WISUCKS"
  global killers
  global killers_name
  killers = _WI_CacheOrVoid("WIKILRS", PU_CACHE)
  killers_name = "WIKILRS"
  global victims
  global victims_name
  victims = _WI_CacheOrVoid("WIVCTMS", PU_CACHE)
  victims_name = "WIVCTMS"
  global total
  global total_name
  total = _WI_CacheOrVoid("WIMSTT", PU_CACHE)
  total_name = "WIMSTT"
  global star
  global star_name
  star = _WI_CacheOrVoid("STFST01", PU_CACHE)
  star_name = "STFST01"
  global bstar
  global bstar_name
  bstar = _WI_CacheOrVoid("STFDEAD0", PU_CACHE)
  bstar_name = "STFDEAD0"
  global wi_p
  wi_p =[]
  global wi_p_names
  wi_p_names =[]
  global wi_bp
  wi_bp =[]
  global wi_bp_names
  wi_bp_names =[]
  pnames = ["STPB0", "STPB1", "STPB2", "STPB3"]
  bpnames = ["WIBP1", "WIBP2", "WIBP3", "WIBP4"]
  i = 0
  while i < MAXPLAYERS
    pname = "STPB0"
    bpname = "WIBP1"
    if i >= 0 and i < len(pnames) then pname = pnames[i] end if
    if i >= 0 and i < len(bpnames) then bpname = bpnames[i] end if
    pp = _WI_CacheOrVoid(pname, PU_CACHE)
    if pp is void then
      pname = "STPB0"
      pp = _WI_CacheOrVoid(pname, PU_CACHE)
    end if
    wi_p = wi_p +[pp]
    wi_p_names = wi_p_names +[pname]
    bp = _WI_CacheOrVoid(bpname, PU_CACHE)
    if bp is void then
      bpname = "WIBP1"
      bp = _WI_CacheOrVoid(bpname, PU_CACHE)
    end if
    wi_bp = wi_bp +[bp]
    wi_bp_names = wi_bp_names +[bpname]
    i = i + 1
  end while

  WI_initAnimatedBack()
end function

/// Releases intermission patch references so zone-cached graphics can be reclaimed after exit.
function WI_unloadData()
  global bg
  bg = void
  global bg_name
  bg_name = ""
  global num
  num =[]
  global num_names
  num_names =[]
  i = 0
  while i < 10
    num = num +[void]
    num_names = num_names +["WINUM" + i]
    i = i + 1
  end while
  global yah
  yah =[void, void]
  global yah_names
  yah_names =["", ""]
  global splat
  splat = void
  global splat_name
  splat_name = ""
  global percent
  percent = void
  global percent_name
  percent_name = ""
  global colon
  colon = void
  global colon_name
  colon_name = ""
  global wiminus
  wiminus = void
  global wiminus_name
  wiminus_name = ""
  global finished
  finished = void
  global finished_name
  finished_name = ""
  global entering
  entering = void
  global entering_name
  entering_name = ""
  global wi_p
  wi_p =[void, void, void, void]
  global wi_p_names
  wi_p_names =["STPB0", "STPB1", "STPB2", "STPB3"]
  global wi_bp
  wi_bp =[void, void, void, void]
  global wi_bp_names
  wi_bp_names =["WIBP1", "WIBP2", "WIBP3", "WIBP4"]
  global sp_secret
  sp_secret = void
  global sp_secret_name
  sp_secret_name = ""
  global kills
  kills = void
  global kills_name
  kills_name = ""
  global secret
  secret = void
  global secret_name
  secret_name = ""
  global items
  items = void
  global items_name
  items_name = ""
  global frags
  frags = void
  global frags_name
  frags_name = ""
  global timepatch
  timepatch = void
  global timepatch_name
  timepatch_name = ""
  global par
  par = void
  global par_name
  par_name = ""
  global sucks
  sucks = void
  global sucks_name
  sucks_name = ""
  global killers
  killers = void
  global killers_name
  killers_name = ""
  global victims
  victims = void
  global victims_name
  victims_name = ""
  global total
  total = void
  global total_name
  total_name = ""
  global star
  star = void
  global star_name
  star_name = ""
  global bstar
  bstar = void
  global bstar_name
  bstar_name = ""
end function

/// Validates wminfo, selects the local scoreboard row, and resets clocks/accelerate flags.
/// @param wbstartstruct Wbstartstruct value supplied to `WI_initVariables`.
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

/// Loads shared artwork and selects deathmatch, cooperative, or solo scoreboard state.
/// @param wbstartstruct Wbstartstruct value supplied to `WI_Start`.
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

/// Samples acceleration, advances background animation, and ticks the active scoreboard state machine.
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

/// Selects and draws the current deathmatch, coop, solo, or map-transition intermission screen.
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



