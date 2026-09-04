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

//! Defines and updates sector/line specials, animated surfaces, buttons, movers, environmental damage, and tag
//! searches.

import doomdef
import doomstat
import i_system
import z_zone
import m_argv
import m_random
import m_fixed
import w_wad
import r_local
import p_local
import g_game
import d_player
import s_sound
import r_state
import info
import sounds
import p_telept
import std.math

/// Tracks whether level timer is active in the p spec subsystem.
levelTimer = false
/// Tracks the mutable level time count value used by the p spec subsystem.
levelTimeCount = 0
/// Tracks the mutable p picanim revision value used by the p spec subsystem.
p_picanim_revision = 0

/// Defines mo teleportman for the p spec subsystem.
const MO_TELEPORTMAN = 14

/// Couples a thinker and sector with countdown and min/max light levels for randomized fire flicker.
struct fireflicker_t
  /// Stores thinker for `fireflicker_t`
  thinker
  /// Stores sector for `fireflicker_t`
  sector
  /// Number of associated items stored by `fireflicker_t`
  count
  /// Stores maxlight for `fireflicker_t`
  maxlight
  /// Stores minlight for `fireflicker_t`
  minlight
end struct

/// Tracks randomized bright/dark sector flashes, including current delay and each phase's maximum duration.
struct lightflash_t
  /// Stores thinker for `lightflash_t`
  thinker
  /// Stores sector for `lightflash_t`
  sector
  /// Number of associated items stored by `lightflash_t`
  count
  /// Stores maxlight for `lightflash_t`
  maxlight
  /// Stores minlight for `lightflash_t`
  minlight
  /// Stores maxtime for `lightflash_t`
  maxtime
  /// Stores mintime for `lightflash_t`
  mintime
end struct

/// Tracks a sector's alternating bright/dark levels and independent phase durations.
struct strobe_t
  /// Stores thinker for `strobe_t`
  thinker
  /// Stores sector for `strobe_t`
  sector
  /// Number of associated items stored by `strobe_t`
  count
  /// Stores minlight for `strobe_t`
  minlight
  /// Stores maxlight for `strobe_t`
  maxlight
  /// Stores darktime for `strobe_t`
  darktime
  /// Stores brighttime for `strobe_t`
  brighttime
end struct

/// Tracks a sector's smooth light oscillation between min/max levels and its current direction.
struct glow_t
  /// Stores thinker for `glow_t`
  thinker
  /// Stores sector for `glow_t`
  sector
  /// Stores minlight for `glow_t`
  minlight
  /// Stores maxlight for `glow_t`
  maxlight
  /// Stores direction for `glow_t`
  direction
end struct

/// Defines glowspeed for the p spec subsystem.
const GLOWSPEED = 8
/// Defines strobebright for the p spec subsystem.
const STROBEBRIGHT = 5
/// Defines fastdark for the p spec subsystem.
const FASTDARK = 15
/// Defines slowdark for the p spec subsystem.
const SLOWDARK = 35

/// Pairs the two texture names that toggle when a wall switch is activated.
struct switchlist_t
  /// Stores name1 for `switchlist_t`
  name1
  /// Stores name2 for `switchlist_t`
  name2
  /// Stores episode for `switchlist_t`
  episode
end struct

/// Identifies which top, middle, or bottom sidedef texture a timed button temporarily replaces.
enum bwhere_e
  /// Represents top in `bwhere_e`
  top
  /// Represents middle in `bwhere_e`
  middle
  /// Represents bottom in `bwhere_e`
  bottom
end enum

/// Records a pressed switch's line, texture slot/original texture, reset timer, and sound origin.
struct button_t
  /// Stores line for `button_t`
  line
  /// Stores where for `button_t`
  where
  /// Stores btexture for `button_t`
  btexture
  /// Stores btimer for `button_t`
  btimer
  /// Stores soundorg for `button_t`
  soundorg
end struct

/// Defines the maximum maxswitches accepted by the p spec subsystem.
const MAXSWITCHES = 50
/// Defines the maximum maxbuttons accepted by the p spec subsystem.
const MAXBUTTONS = 16
/// Defines buttontime for the p spec subsystem.
const BUTTONTIME = 35

/// Names the moving, waiting, and suspended phases of a platform thinker.
enum plat_e
  /// Represents up in `plat_e`
  up
  /// Represents down in `plat_e`
  down
  /// Represents waiting in `plat_e`
  waiting
  /// Represents in stasis in `plat_e`
  in_stasis
end enum

/// Selects the platform motion program used for perpetual, one-shot, blaze, raise, or lower actions.
enum plattype_e
  /// Represents perpetual raise in `plattype_e`
  perpetualRaise
  /// Represents down wait up stay in `plattype_e`
  downWaitUpStay
  /// Represents raise and change in `plattype_e`
  raiseAndChange
  /// Represents raise to nearest and change in `plattype_e`
  raiseToNearestAndChange
  /// Represents blaze dwus in `plattype_e`
  blazeDWUS
end enum

/// Holds a platform thinker's sector, bounds, speed, wait/count state, crush policy, tag, and motion program.
struct plat_t
  /// Stores thinker for `plat_t`
  thinker
  /// Stores sector for `plat_t`
  sector
  /// Stores speed for `plat_t`
  speed
  /// Stores low for `plat_t`
  low
  /// Stores high for `plat_t`
  high
  /// Stores wait for `plat_t`
  wait
  /// Number of associated items stored by `plat_t`
  count
  /// Stores status for `plat_t`
  status
  /// Stores oldstatus for `plat_t`
  oldstatus
  /// Stores crush for `plat_t`
  crush
  /// Stores tag for `plat_t`
  tag
  /// Kind discriminator for this record stored by `plat_t`
  type
end struct

/// Defines platwait for the p spec subsystem.
const PLATWAIT = 3
/// Defines platspeed for the p spec subsystem.
const PLATSPEED = 65536
/// Defines the maximum maxplats accepted by the p spec subsystem.
const MAXPLATS = 30

/// Selects a vertical door program such as normal open/wait/close, delayed close/open, or fast variants.
enum vldoor_e
  /// Represents normal in `vldoor_e`
  normal
  /// Represents close30 then open in `vldoor_e`
  close30ThenOpen
  /// Represents close in `vldoor_e`
  close
  /// Represents open in `vldoor_e`
  open
  /// Represents raise in5 mins in `vldoor_e`
  raiseIn5Mins
  /// Represents blaze raise in `vldoor_e`
  blazeRaise
  /// Represents blaze open in `vldoor_e`
  blazeOpen
  /// Represents blaze close in `vldoor_e`
  blazeClose
end enum

/// Holds a vertical door's sector, target height, speed, direction, wait counters, and selected motion program.
struct vldoor_t
  /// Stores thinker for `vldoor_t`
  thinker
  /// Kind discriminator for this record stored by `vldoor_t`
  type
  /// Stores sector for `vldoor_t`
  sector
  /// Stores topheight for `vldoor_t`
  topheight
  /// Stores speed for `vldoor_t`
  speed
  /// Stores direction for `vldoor_t`
  direction
  /// Stores topwait for `vldoor_t`
  topwait
  /// Stores topcountdown for `vldoor_t`
  topcountdown
end struct

/// Defines vdoorspeed for the p spec subsystem.
const VDOORSPEED = 131072
/// Defines vdoorwait for the p spec subsystem.
const VDOORWAIT = 150

/// Selects crushing, lowering, raising, or silent ceiling movement behavior.
enum ceiling_e
  /// Represents lower to floor in `ceiling_e`
  lowerToFloor
  /// Represents raise to highest in `ceiling_e`
  raiseToHighest
  /// Represents lower and crush in `ceiling_e`
  lowerAndCrush
  /// Represents crush and raise in `ceiling_e`
  crushAndRaise
  /// Represents fast crush and raise in `ceiling_e`
  fastCrushAndRaise
  /// Represents silent crush and raise in `ceiling_e`
  silentCrushAndRaise
end enum

/// Holds an active ceiling's sector, movement bounds/speed/direction, crush policy, tag, and suspended
/// direction.
struct ceiling_t
  /// Stores thinker for `ceiling_t`
  thinker
  /// Kind discriminator for this record stored by `ceiling_t`
  type
  /// Stores sector for `ceiling_t`
  sector
  /// Stores bottomheight for `ceiling_t`
  bottomheight
  /// Stores topheight for `ceiling_t`
  topheight
  /// Stores speed for `ceiling_t`
  speed
  /// Stores crush for `ceiling_t`
  crush
  /// Stores direction for `ceiling_t`
  direction
  /// Stores tag for `ceiling_t`
  tag
  /// Stores olddirection for `ceiling_t`
  olddirection
end struct

/// Defines ceilspeed for the p spec subsystem.
const CEILSPEED = 65536
/// Defines ceilwait for the p spec subsystem.
const CEILWAIT = 150
/// Defines the maximum maxceilings accepted by the p spec subsystem.
const MAXCEILINGS = 30

/// Selects a floor motion target and any texture/special transfer performed on arrival.
enum floor_e
  /// Represents lower floor in `floor_e`
  lowerFloor
  /// Represents lower floor to lowest in `floor_e`
  lowerFloorToLowest
  /// Represents turbo lower in `floor_e`
  turboLower
  /// Represents raise floor in `floor_e`
  raiseFloor
  /// Represents raise floor to nearest in `floor_e`
  raiseFloorToNearest
  /// Represents raise to texture in `floor_e`
  raiseToTexture
  /// Represents lower and change in `floor_e`
  lowerAndChange
  /// Represents raise floor24 in `floor_e`
  raiseFloor24
  /// Represents raise floor24 and change in `floor_e`
  raiseFloor24AndChange
  /// Represents raise floor crush in `floor_e`
  raiseFloorCrush
  /// Represents raise floor turbo in `floor_e`
  raiseFloorTurbo
  /// Represents donut raise in `floor_e`
  donutRaise
  /// Represents raise floor512 in `floor_e`
  raiseFloor512
end enum

/// Selects the standard 8-unit or turbo 16-unit staircase build profile.
enum stair_e
  /// Represents build8 in `stair_e`
  build8
  /// Represents turbo16 in `stair_e`
  turbo16
end enum

/// Holds a floor thinker's sector, direction, destination, speed, crush flag, and post-move texture/special
/// values.
struct floormove_t
  /// Stores thinker for `floormove_t`
  thinker
  /// Kind discriminator for this record stored by `floormove_t`
  type
  /// Stores crush for `floormove_t`
  crush
  /// Stores sector for `floormove_t`
  sector
  /// Stores direction for `floormove_t`
  direction
  /// Stores newspecial for `floormove_t`
  newspecial
  /// Stores texture for `floormove_t`
  texture
  /// Stores floordestheight for `floormove_t`
  floordestheight
  /// Stores speed for `floormove_t`
  speed
end struct

/// Defines floorspeed for the p spec subsystem.
const FLOORSPEED = 65536

/// Reports whether a plane movement completed, continues normally, or encountered a crushing obstruction.
enum result_e
  /// Represents ok in `result_e`
  ok
  /// Represents crushed in `result_e`
  crushed
  /// Represents pastdest in `result_e`
  pastdest
end enum

/// Stores a resolved flat/texture animation's base index, frame count, and tic speed.
struct ps_anim_t
  /// Stores istexture for `ps_anim_t`
  istexture
  /// Stores picnum for `ps_anim_t`
  picnum
  /// Stores basepic for `ps_anim_t`
  basepic
  /// Stores numpics for `ps_anim_t`
  numpics
  /// Stores speed for `ps_anim_t`
  speed
end struct

/// Describes an animation by surface kind, first/last lump names, and tics per frame before WAD resolution.
struct ps_animdef_t
  /// Stores istexture for `ps_animdef_t`
  istexture
  /// Stores endname for `ps_animdef_t`
  endname
  /// Stores startname for `ps_animdef_t`
  startname
  /// Stores speed for `ps_animdef_t`
  speed
end struct

/// Defines the maximum maxanims accepted by the p spec subsystem.
const MAXANIMS = 32
/// Stores the anims collection used by the p spec subsystem.
anims =[]
/// Tracks the mutable lastanim value used by the p spec subsystem.
lastanim = 0

/// Defines the maximum maxlineanims accepted by the p spec subsystem.
const MAXLINEANIMS = 64
/// Tracks the mutable numlinespecials value used by the p spec subsystem.
numlinespecials = 0
/// Stores the linespeciallist collection used by the p spec subsystem.
linespeciallist =[]

/// Stores the ps animdefs collection used by the p spec subsystem.
/// @internal
_PS_animdefs =[
ps_animdef_t(false, "NUKAGE3", "NUKAGE1", 8),
ps_animdef_t(false, "FWATER4", "FWATER1", 8),
ps_animdef_t(false, "SWATER4", "SWATER1", 8),
ps_animdef_t(false, "LAVA4", "LAVA1", 8),
ps_animdef_t(false, "BLOOD3", "BLOOD1", 8),
ps_animdef_t(false, "RROCK08", "RROCK05", 8),
ps_animdef_t(false, "SLIME04", "SLIME01", 8),
ps_animdef_t(false, "SLIME08", "SLIME05", 8),
ps_animdef_t(false, "SLIME12", "SLIME09", 8),
ps_animdef_t(true, "BLODGR4", "BLODGR1", 8),
ps_animdef_t(true, "SLADRIP3", "SLADRIP1", 8),
ps_animdef_t(true, "BLODRIP4", "BLODRIP1", 8),
ps_animdef_t(true, "FIREWALL", "FIREWALA", 8),
ps_animdef_t(true, "GSTFONT3", "GSTFONT1", 8),
ps_animdef_t(true, "FIRELAVA", "FIRELAV3", 8),
ps_animdef_t(true, "FIREMAG3", "FIREMAG1", 8),
ps_animdef_t(true, "FIREBLU2", "FIREBLU1", 8),
ps_animdef_t(true, "ROCKRED3", "ROCKRED1", 8),
ps_animdef_t(true, "BFALL4", "BFALL1", 8),
ps_animdef_t(true, "SFALL4", "SFALL1", 8),
ps_animdef_t(true, "WFALL4", "WFALL1", 8),
ps_animdef_t(true, "DBRAIN4", "DBRAIN1", 8),
ps_animdef_t(-1, "", "", 0)
]

/// Parses an integer or numeric string with truncation toward zero, returning void when conversion fails.
/// @param v Value consumed by the operation.
/// @internal
function _PS_ParseInt(v)
  if typeof(v) == "int" then return v end if
  if typeof(v) == "float" then
    if v >= 0 then return std.math.floor(v) end if
    return std.math.ceil(v)
  end if
  if typeof(v) == "string" then
    n = toNumber(v)
    if typeof(n) == "int" then
      return n
    end if
    if typeof(n) == "float" then
      if n >= 0 then return std.math.floor(n) end if
      return std.math.ceil(n)
    end if
  end if
  return 0
end function

/// Returns a signed quotient truncated toward zero, or zero for invalid operands and a zero divisor in
/// `_PS_IDiv`
/// @param a First input operand.
/// @param b Second input operand.
/// @internal
function inline _PS_IDiv(a, b)
  if typeof(a) != "int" or typeof(b) != "int" or b == 0 then return 0 end if
  q = a / b
  if q >= 0 then return std.math.floor(q) end if
  return std.math.ceil(q)
end function

/// Recognizes array and list containers used by level geometry and animation tables.
/// @param v Value consumed by the operation.
/// @internal
function inline _PS_IsSeq(v)
  t = typeof(v)
  return t == "array" or t == "list"
end function

/// Identifies player and monster missile types allowed to trigger projectile-sensitive line specials.
/// @param t T value supplied to `_PS_IsProjectileType`.
/// @internal
function inline _PS_IsProjectileType(t)
  return t == mobjtype_t.MT_ROCKET or t == mobjtype_t.MT_PLASMA or t == mobjtype_t.MT_BFG or
  t == mobjtype_t.MT_TROOPSHOT or t == mobjtype_t.MT_HEADSHOT or t == mobjtype_t.MT_BRUISERSHOT
end function

/// Reinitializes the fixed timed-button registry or clears existing entries when the helper is unavailable.
/// @internal
function _PS_ResetButtons()
  if typeof(_InitButtonList) == "function" then
    _InitButtonList()
  end if
  if typeof(buttonlist) == "array" then
    i = 0
    while i < len(buttonlist) and i < MAXBUTTONS
      buttonlist[i] = button_t(void, bwhere_e.middle, 0, 0, void)
      i = i + 1
    end while
  end if
end function

/// Resolves built-in flat/texture animation name ranges, validates contiguity, and records runtime frame
/// cycles.
function P_InitPicAnims()
  global anims
  global lastanim

  anims =[]
  lastanim = 0

  i = 0
  while i < len(_PS_animdefs)
    d = _PS_animdefs[i]
    if d.istexture == -1 then break end if

    picnum = 0
    basepic = 0
    if d.istexture then
      if R_CheckTextureNumForName(d.startname) == -1 then
        i = i + 1
        continue
      end if
      picnum = R_TextureNumForName(d.endname)
      basepic = R_TextureNumForName(d.startname)
    else
      if W_CheckNumForName(d.startname) == -1 then
        i = i + 1
        continue
      end if
      picnum = R_FlatNumForName(d.endname)
      basepic = R_FlatNumForName(d.startname)
    end if

    numpics = picnum - basepic + 1
    if numpics < 2 then
      I_Error("P_InitPicAnims: bad cycle from " + d.startname + " to " + d.endname)
      i = i + 1
      continue
    end if

    if len(anims) < MAXANIMS then
      anims = anims +[ps_anim_t(d.istexture, picnum, basepic, numpics, d.speed)]
      lastanim = len(anims)
    end if
    i = i + 1
  end while
end function

/// Parses the level timer, spawns sector lighting/door effects, collects scrolling lines, and resets active
/// movers/buttons.
function P_SpawnSpecials()
  global levelTimer
  global levelTimeCount
  global numlinespecials
  global linespeciallist
  global totalsecret

  levelTimer = false

  parm = M_CheckParm("-avg")
  if parm != 0 and deathmatch then
    levelTimer = true
    levelTimeCount = 20 * 60 * 35
  end if

  parm = M_CheckParm("-timer")
  if parm != 0 and deathmatch then
    mins = 0
    if typeof(myargv) == "array" and parm + 1 < len(myargv) then
      mins = _PS_ParseInt(myargv[parm + 1])
    end if
    if mins > 0 then
      levelTimer = true
      levelTimeCount = mins * 60 * 35
    end if
  end if

  i = 0
  while i < _P_NumSectors()
    sec = sectors[i]
    if sec is not void and sec.special != 0 then
      switch sec.special
        case 1
          P_SpawnLightFlash(sec)
        end case
        case 2
          P_SpawnStrobeFlash(sec, FASTDARK, 0)
        end case
        case 3
          P_SpawnStrobeFlash(sec, SLOWDARK, 0)
        end case
        case 4
          P_SpawnStrobeFlash(sec, FASTDARK, 0)
          sec.special = 4
        end case
        case 8
          P_SpawnGlowingLight(sec)
        end case
        case 9
          totalsecret = totalsecret + 1
        end case
        case 10
          P_SpawnDoorCloseIn30(sec)
        end case
        case 12
          P_SpawnStrobeFlash(sec, SLOWDARK, 1)
        end case
        case 13
          P_SpawnStrobeFlash(sec, FASTDARK, 1)
        end case
        case 14
          P_SpawnDoorRaiseIn5Mins(sec, i)
        end case
        case 17
          P_SpawnFireFlicker(sec)
        end case
      end switch
    end if
    i = i + 1
  end while

  numlinespecials = 0
  linespeciallist =[]
  i = 0
  while i < _P_NumLines()
    li = lines[i]
    if li is not void and li.special == 48 and numlinespecials < MAXLINEANIMS then
      linespeciallist = linespeciallist +[li]
      numlinespecials = numlinespecials + 1
    end if
    i = i + 1
  end while

  if typeof(activeceilings) == "array" then
    n = len(activeceilings)
    if n > MAXCEILINGS then n = MAXCEILINGS end if
    cleared =[]
    i = 0
    while i < n
      cleared = cleared +[void]
      i = i + 1
    end while
    activeceilings = cleared
  end if

  if typeof(activeplats) == "array" then
    n = len(activeplats)
    if n > MAXPLATS then n = MAXPLATS end if
    cleared =[]
    i = 0
    while i < n
      cleared = cleared +[void]
      i = i + 1
    end while
    activeplats = cleared
  end if

  _PS_ResetButtons()
end function

/// Advances level timeout, surface animation translations, scrolling walls, and timed button restoration each
/// tic.
function P_UpdateSpecials()
  global levelTimer
  global levelTimeCount
  global p_picanim_revision

  if levelTimer then
    levelTimeCount = levelTimeCount - 1
    if levelTimeCount <= 0 then
      G_ExitLevel()
    end if
  end if

  picAnimChanged = false
  if _PS_IsSeq(anims) then
    ai = 0
    while ai < len(anims)
      anim = anims[ai]
      if anim is void then
        ai = ai + 1
        continue
      end if
      p = anim.basepic
      while p < anim.basepic + anim.numpics
        pic = p
        if anim.speed > 0 and anim.numpics > 0 then
          pic = anim.basepic +((_PS_IDiv(leveltime, anim.speed) + p) % anim.numpics)
        end if
        if anim.istexture then
          if _PS_IsSeq(texturetranslation) and p >= 0 and p < len(texturetranslation) then
            if texturetranslation[p] != pic then picAnimChanged = true end if
            texturetranslation[p] = pic
          end if
        else
          if _PS_IsSeq(flattranslation) and p >= 0 and p < len(flattranslation) then
            if flattranslation[p] != pic then picAnimChanged = true end if
            flattranslation[p] = pic
          end if
        end if
        p = p + 1
      end while
      ai = ai + 1
    end while
  end if
  if picAnimChanged then p_picanim_revision = p_picanim_revision + 1 end if

  if _PS_IsSeq(linespeciallist) then
    i = 0
    while i < numlinespecials and i < len(linespeciallist)
      line = linespeciallist[i]
      if line is not void and line.special == 48 and typeof(line.sidenum) == "array" and len(line.sidenum) > 0 then
        sn = line.sidenum[0]
        if typeof(sides) == "array" and sn >= 0 and sn < len(sides) then
          sides[sn].textureoffset = sides[sn].textureoffset + FRACUNIT
        end if
      end if
      i = i + 1
    end while
  end if

  if typeof(P_UpdateButtons) == "function" then
    P_UpdateButtons()
  end if
end function

/// Dispatches gun-triggered line types to floor, door, or switch actions while enforcing monster restrictions.
/// @param thing World object affected by the operation.
/// @param line Map line or text line affected by the operation.
function P_ShootSpecialLine(thing, line)
  if thing is void or line is void then return end if

  if thing.player is void then
    ok = 0
    if line.special == 46 then ok = 1 end if
    if ok == 0 then return end if
  end if

  switch line.special
    case 24
      EV_DoFloor(line, floor_e.raiseFloor)
      if typeof(P_ChangeSwitchTexture) == "function" then P_ChangeSwitchTexture(line, 0) end if
    end case
    case 46
      EV_DoDoor(line, vldoor_e.open)
      if typeof(P_ChangeSwitchTexture) == "function" then P_ChangeSwitchTexture(line, 1) end if
    end case
    case 47
      EV_DoPlat(line, plattype_e.raiseToNearestAndChange, 0)
      if typeof(P_ChangeSwitchTexture) == "function" then P_ChangeSwitchTexture(line, 0) end if
    end case
  end switch
end function

/// Dispatches one-shot and repeatable walkover specials after validating line index, side, actor, and
/// projectile rules.
/// @param linenum Index identifying line.
/// @param side Map side affected by the operation.
/// @param thing World object affected by the operation.
function P_CrossSpecialLine(linenum, side, thing)
  if thing is void then return end if
  if typeof(lines) != "array" then return end if
  if linenum < 0 or linenum >= len(lines) then return end if
  line = lines[linenum]
  if line is void then return end if

  if thing.player is void then
    if _PS_IsProjectileType(thing.type) then return end if

    ok = 0
    switch line.special
      case 39, 97, 125, 126, 4, 10, 88
        ok = 1
      end case
    end switch
    if ok == 0 then return end if
  end if

  switch line.special
    case 2
      EV_DoDoor(line, vldoor_e.open)
      line.special = 0
    end case
    case 3
      EV_DoDoor(line, vldoor_e.close)
      line.special = 0
    end case
    case 4
      EV_DoDoor(line, vldoor_e.normal)
      line.special = 0
    end case
    case 5
      EV_DoFloor(line, floor_e.raiseFloor)
      line.special = 0
    end case
    case 6
      EV_DoCeiling(line, ceiling_e.fastCrushAndRaise)
      line.special = 0
    end case
    case 8
      EV_BuildStairs(line, stair_e.build8)
      line.special = 0
    end case
    case 10
      EV_DoPlat(line, plattype_e.downWaitUpStay, 0)
      line.special = 0
    end case
    case 12
      EV_LightTurnOn(line, 0)
      line.special = 0
    end case
    case 13
      EV_LightTurnOn(line, 255)
      line.special = 0
    end case
    case 16
      EV_DoDoor(line, vldoor_e.close30ThenOpen)
      line.special = 0
    end case
    case 17
      EV_StartLightStrobing(line)
      line.special = 0
    end case
    case 19
      EV_DoFloor(line, floor_e.lowerFloor)
      line.special = 0
    end case
    case 22
      EV_DoPlat(line, plattype_e.raiseToNearestAndChange, 0)
      line.special = 0
    end case
    case 25
      EV_DoCeiling(line, ceiling_e.crushAndRaise)
      line.special = 0
    end case
    case 30
      EV_DoFloor(line, floor_e.raiseToTexture)
      line.special = 0
    end case
    case 35
      EV_LightTurnOn(line, 35)
      line.special = 0
    end case
    case 36
      EV_DoFloor(line, floor_e.turboLower)
      line.special = 0
    end case
    case 37
      EV_DoFloor(line, floor_e.lowerAndChange)
      line.special = 0
    end case
    case 38
      EV_DoFloor(line, floor_e.lowerFloorToLowest)
      line.special = 0
    end case
    case 39
      EV_Teleport(line, side, thing)
      line.special = 0
    end case
    case 40
      EV_DoCeiling(line, ceiling_e.raiseToHighest)
      EV_DoFloor(line, floor_e.lowerFloorToLowest)
      line.special = 0
    end case
    case 44
      EV_DoCeiling(line, ceiling_e.lowerAndCrush)
      line.special = 0
    end case
    case 52
      G_ExitLevel()
    end case
    case 53
      EV_DoPlat(line, plattype_e.perpetualRaise, 0)
      line.special = 0
    end case
    case 54
      EV_StopPlat(line)
      line.special = 0
    end case
    case 56
      EV_DoFloor(line, floor_e.raiseFloorCrush)
      line.special = 0
    end case
    case 57
      EV_CeilingCrushStop(line)
      line.special = 0
    end case
    case 58
      EV_DoFloor(line, floor_e.raiseFloor24)
      line.special = 0
    end case
    case 59
      EV_DoFloor(line, floor_e.raiseFloor24AndChange)
      line.special = 0
    end case
    case 100
      EV_BuildStairs(line, stair_e.turbo16)
      line.special = 0
    end case
    case 104
      EV_TurnTagLightsOff(line)
      line.special = 0
    end case
    case 108
      EV_DoDoor(line, vldoor_e.blazeRaise)
      line.special = 0
    end case
    case 109
      EV_DoDoor(line, vldoor_e.blazeOpen)
      line.special = 0
    end case
    case 110
      EV_DoDoor(line, vldoor_e.blazeClose)
      line.special = 0
    end case
    case 119
      EV_DoFloor(line, floor_e.raiseFloorToNearest)
      line.special = 0
    end case
    case 121
      EV_DoPlat(line, plattype_e.blazeDWUS, 0)
      line.special = 0
    end case
    case 124
      G_SecretExitLevel()
    end case
    case 125
      if thing.player is void then
        EV_Teleport(line, side, thing)
        line.special = 0
      end if
    end case
    case 130
      EV_DoFloor(line, floor_e.raiseFloorTurbo)
      line.special = 0
    end case
    case 141
      EV_DoCeiling(line, ceiling_e.silentCrushAndRaise)
      line.special = 0
    end case
    case 72
      EV_DoCeiling(line, ceiling_e.lowerAndCrush)
    end case
    case 73
      EV_DoCeiling(line, ceiling_e.crushAndRaise)
    end case
    case 74
      EV_CeilingCrushStop(line)
    end case
    case 75
      EV_DoDoor(line, vldoor_e.close)
    end case
    case 76
      EV_DoDoor(line, vldoor_e.close30ThenOpen)
    end case
    case 77
      EV_DoCeiling(line, ceiling_e.fastCrushAndRaise)
    end case
    case 79
      EV_LightTurnOn(line, 35)
    end case
    case 80
      EV_LightTurnOn(line, 0)
    end case
    case 81
      EV_LightTurnOn(line, 255)
    end case
    case 82
      EV_DoFloor(line, floor_e.lowerFloorToLowest)
    end case
    case 83
      EV_DoFloor(line, floor_e.lowerFloor)
    end case
    case 84
      EV_DoFloor(line, floor_e.lowerAndChange)
    end case
    case 86
      EV_DoDoor(line, vldoor_e.open)
    end case
    case 87
      EV_DoPlat(line, plattype_e.perpetualRaise, 0)
    end case
    case 88
      EV_DoPlat(line, plattype_e.downWaitUpStay, 0)
    end case
    case 89
      EV_StopPlat(line)
    end case
    case 90
      EV_DoDoor(line, vldoor_e.normal)
    end case
    case 91
      EV_DoFloor(line, floor_e.raiseFloor)
    end case
    case 92
      EV_DoFloor(line, floor_e.raiseFloor24)
    end case
    case 93
      EV_DoFloor(line, floor_e.raiseFloor24AndChange)
    end case
    case 94
      EV_DoFloor(line, floor_e.raiseFloorCrush)
    end case
    case 95
      EV_DoPlat(line, plattype_e.raiseToNearestAndChange, 0)
    end case
    case 96
      EV_DoFloor(line, floor_e.raiseToTexture)
    end case
    case 97
      EV_Teleport(line, side, thing)
    end case
    case 98
      EV_DoFloor(line, floor_e.turboLower)
    end case
    case 105
      EV_DoDoor(line, vldoor_e.blazeRaise)
    end case
    case 106
      EV_DoDoor(line, vldoor_e.blazeOpen)
    end case
    case 107
      EV_DoDoor(line, vldoor_e.blazeClose)
    end case
    case 120
      EV_DoPlat(line, plattype_e.blazeDWUS, 0)
    end case
    case 126
      if thing.player is void then
        EV_Teleport(line, side, thing)
      end if
    end case
    case 128
      EV_DoFloor(line, floor_e.raiseFloorToNearest)
    end case
    case 129
      EV_DoFloor(line, floor_e.raiseFloorTurbo)
    end case
  end switch
end function

/// Maps a supported player-power enum or integer to its powers-array slot.
/// @param pw Pw value supplied to `_PSpec_PowerIndex`.
/// @internal
function _PSpec_PowerIndex(pw)
  if typeof(pw) == "int" then
    if pw >= 0 and pw < NUMPOWERS then return pw end if
    return -1
  end if
  n = toNumber(pw)
  if typeof(n) == "int" then
    if n >= 0 and n < NUMPOWERS then return n end if
    return -1
  end if
  if pw == pw_invulnerability then return 0 end if
  if pw == pw_strength then return 1 end if
  if pw == pw_invisibility then return 2 end if
  if pw == pw_ironfeet then return 3 end if
  if pw == pw_allmap then return 4 end if
  if pw == pw_infrared then return 5 end if
  return -1
end function

/// Reads a validated player power duration/value, treating legacy booleans as zero or one.
/// @param player Player state affected by the operation.
/// @param pw Pw value supplied to `_PSpec_GetPower`.
/// @internal
function _PSpec_GetPower(player, pw)
  if player is void then return 0 end if
  idx = _PSpec_PowerIndex(pw)
  if idx < 0 then return 0 end if
  if typeof(idx) != "int" then
    idxn = toNumber(idx)
    if typeof(idxn) != "int" then return 0 end if
    idx = idxn
  end if
  if typeof(player.powers) != "array" and typeof(player.powers) != "list" then return 0 end if
  if idx >= len(player.powers) then return 0 end if
  v = player.powers[idx]
  if typeof(v) != "int" then return 0 end if
  return v
end function

/// Applies floor-contact damage, secret discovery, and exit effects for the player's current sector special.
/// @param player Player state affected by the operation.
function P_PlayerInSpecialSector(player)
  if player is void or player.mo is void then return end if
  if player.mo.subsector is void or player.mo.subsector.sector is void then return end if

  sector = player.mo.subsector.sector
  if player.mo.z != sector.floorheight then return end if

  switch sector.special
    case 1, 2, 3, 8, 10, 12, 13, 14, 17

    end case
    case 5
      if _PSpec_GetPower(player, pw_ironfeet) == 0 and(leveltime & 0x1f) == 0 then
        P_DamageMobj(player.mo, void, void, 10)
      end if
    end case
    case 7
      if _PSpec_GetPower(player, pw_ironfeet) == 0 and(leveltime & 0x1f) == 0 then
        P_DamageMobj(player.mo, void, void, 5)
      end if
    end case
    case 16, 4
      if _PSpec_GetPower(player, pw_ironfeet) == 0 or P_Random() < 5 then
        if (leveltime & 0x1f) == 0 then
          P_DamageMobj(player.mo, void, void, 20)
        end if
      end if
    end case
    case 9
      player.secretcount = player.secretcount + 1
      sector.special = 0
    end case
    case 11
      player.cheats = player.cheats & ~cheat_t.CF_GODMODE
      if (leveltime & 0x1f) == 0 then
        P_DamageMobj(player.mo, void, void, 20)
      end if
      if player.health <= 10 then
        G_ExitLevel()
      end if
    end case
    case default

    end case
  end switch
end function

/// Returns the loaded sector count for either supported sequence representation.
/// @internal
function inline _P_NumSectors()
  if typeof(sectors) == "array" then return len(sectors) end if
  if typeof(sectors) == "list" then return len(sectors) end if
  if typeof(numsectors) == "int" then return numsectors end if
  return 0
end function

/// Returns the loaded linedef count for either supported sequence representation.
/// @internal
function inline _P_NumLines()
  if typeof(lines) == "array" then return len(lines) end if
  if typeof(lines) == "list" then return len(lines) end if
  if typeof(numlines) == "int" then return numlines end if
  return 0
end function

/// Finds a sector by object identity in the loaded sector table, returning -1 when absent.
/// @param sec Sec value supplied to `_PS_SectorIndex`.
/// @internal
function _PS_SectorIndex(sec)
  if sec is void then return -1 end if
  if not _PS_IsSeq(sectors) then return -1 end if
  i = 0
  while i < len(sectors)
    if sectors[i] == sec then return i end if
    i = i + 1
  end while
  return -1
end function

/// Resolves a line's requested side to its front/back sector through direct references or sidedef indices.
/// @param line Map line or text line affected by the operation.
/// @param side Map side affected by the operation.
/// @internal
function _PS_LineSideSector(line, side)
  if line is void then return void end if
  if side < 0 or side > 1 then return void end if
  if not _PS_IsSeq(line.sidenum) then return void end if
  if side >= len(line.sidenum) then return void end if
  if not _PS_IsSeq(sides) then return void end if

  sidx = line.sidenum[side]
  if typeof(sidx) != "int" or sidx < 0 or sidx >= len(sides) then
    return void
  end if

  sd = sides[sidx]
  if sd is void then return void end if
  return sd.sector
end function

/// Tests whether a sector-owned line index references a valid ML_TWOSIDED linedef.
/// @param sectorIndex Index identifying sector.
/// @param lineIndex Index identifying line.
function twoSided(sectorIndex, lineIndex)
  if not _PS_IsSeq(sectors) then return 0 end if
  if sectorIndex < 0 or sectorIndex >= len(sectors) then return 0 end if
  sec = sectors[sectorIndex]
  if sec is void then return 0 end if
  if not _PS_IsSeq(sec.lines) then return 0 end if
  if lineIndex < 0 or lineIndex >= sec.linecount then return 0 end if
  l = sec.lines[lineIndex]
  if l is void then return 0 end if
  return (l.flags & ML_TWOSIDED) != 0
end function

/// Resolves a sector-local line and side number to the corresponding sidedef with index validation.
/// @param currentSector Current sector value supplied to `getSide`.
/// @param lineIndex Index identifying line.
/// @param side Map side affected by the operation.
function getSide(currentSector, lineIndex, side)
  if not _PS_IsSeq(sectors) then return void end if
  if currentSector < 0 or currentSector >= len(sectors) then return void end if
  sec = sectors[currentSector]
  if sec is void then return void end if
  if not _PS_IsSeq(sec.lines) then return void end if
  if lineIndex < 0 or lineIndex >= sec.linecount then return void end if
  l = sec.lines[lineIndex]
  if l is void then return void end if

  if not _PS_IsSeq(sides) then return void end if
  if side < 0 or side > 1 then return void end if
  if not _PS_IsSeq(l.sidenum) or side >= len(l.sidenum) then return void end if
  sn = l.sidenum[side]
  if sn is void then return void end if
  if sn < 0 then return void end if
  if sn >= len(sides) then return void end if
  return sides[sn]
end function

/// Returns the sector referenced by a resolved sidedef, or void when the side is missing.
/// @param currentSector Current sector value supplied to `getSector`.
/// @param lineIndex Index identifying line.
/// @param side Map side affected by the operation.
function getSector(currentSector, lineIndex, side)
  sd = getSide(currentSector, lineIndex, side)
  if sd is void then return void end if
  return sd.sector
end function

/// Given one sector on a two-sided line, returns the opposite adjacent sector.
/// @param line Map line or text line affected by the operation.
/// @param sec Sec value supplied to `getNextSector`.
function getNextSector(line, sec)
  if line is void or sec is void then return void end if
  if (line.flags & ML_TWOSIDED) == 0 then return void end if

  front = line.frontsector
  back = line.backsector
  if front is void then front = _PS_LineSideSector(line, 0) end if
  if back is void then back = _PS_LineSideSector(line, 1) end if

  if line.frontsector is void and front is not void then line.frontsector = front end if
  if line.backsector is void and back is not void then line.backsector = back end if

  if front == sec then
    return back
  else if back == sec then
    return front
  end if

  secIdx = _PS_SectorIndex(sec)
  if secIdx >= 0 then
    frontIdx = _PS_SectorIndex(front)
    backIdx = _PS_SectorIndex(back)
    if frontIdx == secIdx then return back end if
    if backIdx == secIdx then return front end if
  end if
  return void
end function

/// Returns the minimum floor height among all valid sectors adjacent to the supplied sector.
/// @param sec Sec value supplied to `P_FindLowestFloorSurrounding`.
function P_FindLowestFloorSurrounding(sec)
  if sec is void then return 0 end if
  best = sec.floorheight

  if typeof(sec.lines) != "array" and typeof(sec.lines) != "list" then
    return best
  end if

  i = 0
  while i < sec.linecount
    l = sec.lines[i]
    other = getNextSector(l, sec)
    if other is not void then
      if other.floorheight < best then best = other.floorheight end if
    end if
    i = i + 1
  end while

  return best
end function

/// Returns the maximum floor height among all valid sectors adjacent to the supplied sector.
/// @param sec Sec value supplied to `P_FindHighestFloorSurrounding`.
function P_FindHighestFloorSurrounding(sec)
  if sec is void then return 0 end if
  best = -500 * FRACUNIT

  if typeof(sec.lines) != "array" and typeof(sec.lines) != "list" then
    return best
  end if

  i = 0
  while i < sec.linecount
    l = sec.lines[i]
    other = getNextSector(l, sec)
    if other is not void then
      if other.floorheight > best then best = other.floorheight end if
    end if
    i = i + 1
  end while

  return best
end function

/// Returns the lowest adjacent floor strictly above currentheight, or currentheight when none exists.
/// @param sec Sec value supplied to `P_FindNextHighestFloor`.
/// @param currentheight Height of current in pixels or map units.
function P_FindNextHighestFloor(sec, currentheight)
  if sec is void then return currentheight end if
  next = MAXINT

  if typeof(sec.lines) != "array" and typeof(sec.lines) != "list" then
    return next
  end if

  i = 0
  while i < sec.linecount
    l = sec.lines[i]
    other = getNextSector(l, sec)
    if other is not void then
      h = other.floorheight
      if h > currentheight and h < next then
        next = h
      end if
    end if
    i = i + 1
  end while

  if next == MAXINT then return currentheight end if
  return next
end function

/// Returns the minimum ceiling height among all valid sectors adjacent to the supplied sector.
/// @param sec Sec value supplied to `P_FindLowestCeilingSurrounding`.
function P_FindLowestCeilingSurrounding(sec)
  if sec is void then return 0 end if
  best = MAXINT

  if typeof(sec.lines) != "array" and typeof(sec.lines) != "list" then
    return best
  end if

  i = 0
  while i < sec.linecount
    l = sec.lines[i]
    other = getNextSector(l, sec)
    if other is not void then
      if other.ceilingheight < best then best = other.ceilingheight end if
    end if
    i = i + 1
  end while

  return best
end function

/// Returns the maximum ceiling height among all valid sectors adjacent to the supplied sector.
/// @param sec Sec value supplied to `P_FindHighestCeilingSurrounding`.
function P_FindHighestCeilingSurrounding(sec)
  if sec is void then return 0 end if
  best = 0

  if typeof(sec.lines) != "array" and typeof(sec.lines) != "list" then
    return best
  end if

  i = 0
  while i < sec.linecount
    l = sec.lines[i]
    other = getNextSector(l, sec)
    if other is not void then
      if other.ceilingheight > best then best = other.ceilingheight end if
    end if
    i = i + 1
  end while

  return best
end function

/// Continues a linear search after start for the next sector whose tag matches the triggering line.
/// @param line Map line or text line affected by the operation.
/// @param start Start value supplied to `P_FindSectorFromLineTag`.
function P_FindSectorFromLineTag(line, start)
  if line is void then return -1 end if
  n = _P_NumSectors()
  i = start + 1
  while i < n
    s = sectors[i]
    if s is not void and s.tag == line.tag then
      return i
    end if
    i = i + 1
  end while
  return -1
end function

/// Finds the lowest adjacent sector light level without exceeding the caller-provided starting maximum.
/// @param sector Map sector affected by the operation.
/// @param max Maximum permitted value.
function P_FindMinSurroundingLight(sector, max)
  if sector is void then return 0 end if
  minl = max

  if typeof(sector.lines) != "array" and typeof(sector.lines) != "list" then
    return minl
  end if

  i = 0
  while i < sector.linecount
    l = sector.lines[i]
    other = getNextSector(l, sector)
    if other is not void then
      if other.lightlevel < minl then minl = other.lightlevel end if
    end if
    i = i + 1
  end while

  return minl
end function

/// Starts the coupled donut action: lower the tagged pillar while raising its surrounding ring to the outer
/// sector.
/// @param line Map line or text line affected by the operation.
function EV_DoDonut(line)
  if line is void then return 0 end if

  secnum = -1
  rtn = 0

  loop
    secnum = P_FindSectorFromLineTag(line, secnum)
    if secnum < 0 then break end if
    if typeof(sectors) != "array" or secnum >= len(sectors) then continue end if

    s1 = sectors[secnum]
    if s1 is void then continue end if
    if s1.specialdata is not void then continue end if
    if typeof(s1.lines) != "array" or s1.linecount <= 0 then continue end if

    s2 = getNextSector(s1.lines[0], s1)
    if s2 is void or typeof(s2.lines) != "array" then continue end if

    i = 0
    while i < s2.linecount
      li = s2.lines[i]
      if li is void then
        i = i + 1
        continue
      end if

      if (li.flags & ML_TWOSIDED) == 0 or li.backsector == s1 then
        i = i + 1
        continue
      end if

      s3 = li.backsector
      if s3 is void then
        i = i + 1
        continue
      end if

      rtn = 1

      floor = floormove_t(thinker_t(void, void, actionf_t(T_MoveFloor, void, void), void), floor_e.donutRaise, false, s2, 1, 0, s3.floorpic, s3.floorheight, FLOORSPEED >> 1)
      if typeof(P_RegisterThinkerOwner) == "function" then P_RegisterThinkerOwner(floor.thinker, floor) end if
      if typeof(P_AddThinker) == "function" then P_AddThinker(floor.thinker) end if
      s2.specialdata = floor

      floor2 = floormove_t(thinker_t(void, void, actionf_t(T_MoveFloor, void, void), void), floor_e.lowerFloor, false, s1, -1, 0, 0, s3.floorheight, FLOORSPEED >> 1)
      if typeof(P_RegisterThinkerOwner) == "function" then P_RegisterThinkerOwner(floor2.thinker, floor2) end if
      if typeof(P_AddThinker) == "function" then P_AddThinker(floor2.thinker) end if
      s1.specialdata = floor2
      break
    end while
    while true
    end loop

    return rtn
  end function



