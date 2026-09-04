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

//! Implements automap input, state, and drawing logic.

import z_zone
import doomdef
import st_stuff
import p_local
import w_wad
import m_cheat
import i_system
import v_video
import doomstat
import r_state
import dstrings
import m_fixed

/// Defines am msgheader for the am map subsystem.
const AM_MSGHEADER =((97 << 24) +(109 << 16))
/// Defines am msgentered for the am map subsystem.
const AM_MSGENTERED =(AM_MSGHEADER |(101 << 8))
/// Defines am msgexited for the am map subsystem.
const AM_MSGEXITED =(AM_MSGHEADER |(120 << 8))

/// Defines the Doom palette selection for reds.
const REDS =(256 - 5 * 16)
/// Defines redrange for the am map subsystem.
const REDRANGE = 16
/// Defines the Doom palette selection for greens.
const GREENS =(7 * 16)
/// Defines greenrange for the am map subsystem.
const GREENRANGE = 16
/// Defines the Doom palette selection for grays.
const GRAYS =(6 * 16)
/// Defines graysrange for the am map subsystem.
const GRAYSRANGE = 16
/// Defines the Doom palette selection for browns.
const BROWNS =(4 * 16)
/// Defines brownrange for the am map subsystem.
const BROWNRANGE = 16
/// Defines the Doom palette selection for yellows.
const YELLOWS =(256 - 32 + 7)
/// Defines yellowrange for the am map subsystem.
const YELLOWRANGE = 1
/// Defines the Doom palette selection for black.
const BLACK = 0
/// Defines the Doom palette selection for white.
const WHITE =(256 - 47)

/// Defines background for the am map subsystem.
const BACKGROUND = BLACK
/// Defines the Doom palette selection for yourcolors.
const YOURCOLORS = WHITE
/// Defines the Doom palette selection for wallcolors.
const WALLCOLORS = REDS
/// Defines the Doom palette selection for tswallcolors.
const TSWALLCOLORS = GRAYS
/// Defines the Doom palette selection for fdwallcolors.
const FDWALLCOLORS = BROWNS
/// Defines the Doom palette selection for cdwallcolors.
const CDWALLCOLORS = YELLOWS
/// Defines the Doom palette selection for thingcolors.
const THINGCOLORS = GREENS
/// Defines the Doom palette selection for gridcolors.
const GRIDCOLORS =(GRAYS +(GRAYSRANGE >> 1))
/// Defines the Doom palette selection for xhaircolors.
const XHAIRCOLORS = GRAYS

/// Defines fb for the am map subsystem.
const FB = 0

/// Defines the input key code for am pandownkey.
const AM_PANDOWNKEY = KEY_DOWNARROW
/// Defines the input key code for am panupkey.
const AM_PANUPKEY = KEY_UPARROW
/// Defines the input key code for am panrightkey.
const AM_PANRIGHTKEY = KEY_RIGHTARROW
/// Defines the input key code for am panleftkey.
const AM_PANLEFTKEY = KEY_LEFTARROW
/// Defines the input key code for am zoominkey.
const AM_ZOOMINKEY = 61
/// Defines the input key code for am zoomoutkey.
const AM_ZOOMOUTKEY = 45
/// Defines the input key code for am startkey.
const AM_STARTKEY = KEY_TAB
/// Defines the input key code for am endkey.
const AM_ENDKEY = KEY_TAB
/// Defines the input key code for am gobigkey.
const AM_GOBIGKEY = 48
/// Defines the input key code for am followkey.
const AM_FOLLOWKEY = 102
/// Defines the input key code for am gridkey.
const AM_GRIDKEY = 103
/// Defines the input key code for am markkey.
const AM_MARKKEY = 109
/// Defines the input key code for am clearmarkkey.
const AM_CLEARMARKKEY = 99

/// Defines the am nummarkpoints count used by the am map subsystem.
const AM_NUMMARKPOINTS = 10

/// Defines initscalemtof for the am map subsystem.
const INITSCALEMTOF = 13107
/// Defines am fracunit for the am map subsystem.
const AM_FRACUNIT = 65536
/// Defines f paninc for the am map subsystem.
const F_PANINC = 4
/// Defines m zoomin for the am map subsystem.
const M_ZOOMIN = 66846
/// Defines m zoomout for the am map subsystem.
const M_ZOOMOUT = 64250
/// Defines the maximum am maxint accepted by the am map subsystem.
const AM_MAXINT = 2147483647

/// Describes fpoint geometry or asset data used by the automap system.
struct fpoint_t
  /// Horizontal map- or screen-space coordinate stored by `fpoint_t`
  x
  /// Vertical map- or screen-space coordinate stored by `fpoint_t`
  y
end struct

/// Describes fline geometry or asset data used by the automap system.
struct fline_t
  /// Stores a for `fline_t`
  a
  /// Stores b for `fline_t`
  b
end struct

/// Describes mpoint geometry or asset data used by the automap system.
struct mpoint_t
  /// Horizontal map- or screen-space coordinate stored by `mpoint_t`
  x
  /// Vertical map- or screen-space coordinate stored by `mpoint_t`
  y
end struct

/// Describes mline geometry or asset data used by the automap system.
struct mline_t
  /// Stores a for `mline_t`
  a
  /// Stores b for `mline_t`
  b
end struct

/// Holds the per-edge slope steps used when clipping map lines to the automap window.
struct islope_t
  /// Stores slp for `islope_t`
  slp
  /// Stores islp for `islope_t`
  islp
end struct

/// Constructs a point in map-space fixed-point coordinates.
/// @param x Horizontal map- or screen-space coordinate.
/// @param y Vertical map- or screen-space coordinate.
/// @internal
function inline _AM_MPoint(x, y)
  return mpoint_t(x, y)
end function

/// Constructs a point in automap framebuffer pixel coordinates.
/// @param x Horizontal map- or screen-space coordinate.
/// @param y Vertical map- or screen-space coordinate.
/// @internal
function inline _AM_FPoint(x, y)
  return fpoint_t(x, y)
end function

/// Constructs a map-space line from two fixed-point endpoints.
/// @param x1 Horizontal coordinate of the first endpoint.
/// @param y1 Vertical coordinate of the first endpoint.
/// @param x2 Horizontal coordinate of the second endpoint.
/// @param y2 Vertical coordinate of the second endpoint.
/// @internal
function inline _AM_MLine(x1, y1, x2, y2)
  return mline_t(_AM_MPoint(x1, y1), _AM_MPoint(x2, y2))
end function

/// Constructs a framebuffer-space line used by the clipping and rasterization stages.
/// @param x1 Horizontal coordinate of the first endpoint.
/// @param y1 Vertical coordinate of the first endpoint.
/// @param x2 Horizontal coordinate of the second endpoint.
/// @param y2 Vertical coordinate of the second endpoint.
/// @internal
function inline _AM_FLine(x1, y1, x2, y2)
  return fline_t(_AM_FPoint(x1, y1), _AM_FPoint(x2, y2))
end function

/// Returns the magnitude of an integer without altering its fixed-point scale.
/// @param v Value consumed by the operation.
/// @internal
function inline _AM_Abs(v)
  if v < 0 then return - v end if
  return v
end function

/// Restricts a zoom or coordinate value to the caller's inclusive lower and upper bounds.
/// @param v Value consumed by the operation.
/// @param lo Inclusive lower bound.
/// @param hi Inclusive upper bound.
/// @internal
function inline _AM_Clamp(v, lo, hi)
  if v < lo then return lo end if
  if v > hi then return hi end if
  return v
end function

/// Computes a non-negative remainder for grid alignment, returning zero for a zero divisor.
/// @param n Number of values to process.
/// @param d Divisor or direction value used by the operation.
/// @internal
function inline _AM_Mod(n, d)
  if d == 0 then return 0 end if
  r = n % d
  if r < 0 then r = r + d end if
  return r
end function

/// Returns a signed quotient truncated toward zero, or zero for invalid operands and a zero divisor in
/// `_AM_IDiv`
/// @param a First input operand.
/// @param b Second input operand.
/// @internal
function inline _AM_IDiv(a, b)
  if typeof(a) != "int" or typeof(b) != "int" or b == 0 then return 0 end if
  q = a / b
  if q >= 0 then return std.math.floor(q) end if
  return std.math.ceil(q)
end function

/// Folds one uppercase ASCII byte to lowercase while leaving all other bytes unchanged.
/// @param c C value supplied to `_AM_ToLowerAscii`.
/// @internal
function inline _AM_ToLowerAscii(c)
  if c >= 65 and c <= 90 then return c + 32 end if
  return c
end function

/// Normalizes an input key to lowercase ASCII for case-insensitive automap bindings.
/// @param k K value supplied to `_AM_CaseKey`.
/// @internal
function inline _AM_CaseKey(k)
  if typeof(k) != "int" then return -1 end if
  return _AM_ToLowerAscii(k)
end function

/// Resolves an optional automap patch lump and returns its tagged cache entry, or void when the name is absent.
/// @param name Resource or object name to resolve.
/// @param tag Zone-memory or resource-lifetime tag.
/// @internal
function inline _AM_CacheOrVoid(name, tag)
  if typeof(W_CheckNumForName) == "function" then
    ln = W_CheckNumForName(name)
    if ln < 0 then return void end if
    return W_CacheLumpNum(ln, tag)
  end if
  return W_CacheLumpName(name, tag)
end function

/// Converts a framebuffer pixel distance to map-space fixed-point units using the current zoom scale.
/// @param x Horizontal map- or screen-space coordinate.
/// @internal
function inline _AM_FTOM(x)
  return FixedMul(x << 16, scale_ftom)
end function

/// Converts a map-space fixed-point distance to framebuffer pixels using the current zoom scale.
/// @param x Horizontal map- or screen-space coordinate.
/// @internal
function inline _AM_MTOF(x)
  return FixedMul(x, scale_mtof) >> 16
end function

/// Projects a map-space x coordinate into the automap window relative to its current origin.
/// @param x Horizontal map- or screen-space coordinate.
/// @internal
function inline _AM_CXMTOF(x)
  return f_x + _AM_MTOF(x - m_x)
end function

/// Projects a map-space y coordinate into the vertically inverted automap framebuffer.
/// @param y Vertical map- or screen-space coordinate.
/// @internal
function inline _AM_CYMTOF(y)
  return f_y +(f_h - _AM_MTOF(y - m_y))
end function

/// Tracks the mutable cheating value used by the am map subsystem.
cheating = 0
/// Tracks the mutable grid value used by the am map subsystem.
grid = 0
/// Tracks the mutable leveljuststarted value used by the am map subsystem.
leveljuststarted = 1

/// Tracks whether automapactive is active in the am map subsystem.
automapactive = false
/// Tracks the mutable finit width value used by the am map subsystem.
finit_width = SCREENWIDTH
/// Tracks the mutable finit height value used by the am map subsystem.
finit_height = SCREENHEIGHT - 32

/// Tracks the mutable f x value used by the am map subsystem.
f_x = 0
/// Tracks the mutable f y value used by the am map subsystem.
f_y = 0
/// Tracks the mutable f w value used by the am map subsystem.
f_w = 0
/// Tracks the mutable f h value used by the am map subsystem.
f_h = 0

/// Tracks the mutable lightlev value used by the am map subsystem.
lightlev = 0
/// Holds the optional fb resource used by the am map subsystem.
fb = void
/// Tracks the mutable amclock value used by the am map subsystem.
amclock = 0

/// Tracks the mutable m paninc value used by the am map subsystem.
m_paninc = _AM_MPoint(0, 0)
/// Tracks the mutable mtof zoommul value used by the am map subsystem.
mtof_zoommul = AM_FRACUNIT
/// Tracks the mutable ftom zoommul value used by the am map subsystem.
ftom_zoommul = AM_FRACUNIT

/// Tracks the mutable m x value used by the am map subsystem.
m_x = 0
/// Tracks the mutable m y value used by the am map subsystem.
m_y = 0
/// Tracks the mutable m x2 value used by the am map subsystem.
m_x2 = 0
/// Tracks the mutable m y2 value used by the am map subsystem.
m_y2 = 0
/// Tracks the mutable m w value used by the am map subsystem.
m_w = 0
/// Tracks the mutable m h value used by the am map subsystem.
m_h = 0

/// Tracks the mutable min x value used by the am map subsystem.
min_x = 0
/// Tracks the mutable min y value used by the am map subsystem.
min_y = 0
/// Tracks the mutable max x value used by the am map subsystem.
max_x = 0
/// Tracks the mutable max y value used by the am map subsystem.
max_y = 0
/// Tracks the mutable max w value used by the am map subsystem.
max_w = 0
/// Tracks the mutable max h value used by the am map subsystem.
max_h = 0
/// Tracks the mutable min w value used by the am map subsystem.
min_w = 0
/// Tracks the mutable min h value used by the am map subsystem.
min_h = 0

/// Tracks the mutable min scale mtof value used by the am map subsystem.
min_scale_mtof = AM_FRACUNIT
/// Tracks the mutable max scale mtof value used by the am map subsystem.
max_scale_mtof = AM_FRACUNIT

/// Tracks the mutable old m w value used by the am map subsystem.
old_m_w = 0
/// Tracks the mutable old m h value used by the am map subsystem.
old_m_h = 0
/// Tracks the mutable old m x value used by the am map subsystem.
old_m_x = 0
/// Tracks the mutable old m y value used by the am map subsystem.
old_m_y = 0
/// Tracks the mutable f oldloc value used by the am map subsystem.
f_oldloc = _AM_MPoint(AM_MAXINT, AM_MAXINT)

/// Tracks the mutable scale mtof value used by the am map subsystem.
scale_mtof = INITSCALEMTOF
/// Tracks the mutable scale ftom value used by the am map subsystem.
scale_ftom = AM_FRACUNIT

/// Holds the optional plr resource used by the am map subsystem.
plr = void

/// Stores the marknums collection used by the am map subsystem.
marknums =[]
/// Stores the markpoints collection used by the am map subsystem.
markpoints =[]
/// Tracks the mutable markpointnum value used by the am map subsystem.
markpointnum = 0
/// Tracks the mutable followplayer value used by the am map subsystem.
followplayer = 1

/// Tracks the mutable cheat amap seq value used by the am map subsystem.
cheat_amap_seq = bytes([0xb2, 0x26, 0x26, 0x2e, 0xff])
/// Tracks the mutable cheat amap value used by the am map subsystem.
cheat_amap = cheatseq_t(cheat_amap_seq, 0)

/// Tracks whether stopped is active in the am map subsystem.
stopped = true

/// Computes both dy/dx and dx/dy for a map line, using signed sentinels for vertical and horizontal cases.
/// @param ml Ml value supplied to `AM_getIslope`.
/// @param sl Sl value supplied to `AM_getIslope`.
function AM_getIslope(ml, sl)
  if ml is void or sl is void then return end if
  dy = ml.a.y - ml.b.y
  dx = ml.b.x - ml.a.x
  if dy == 0 then
    if dx < 0 then sl.islp = -AM_MAXINT else sl.islp = AM_MAXINT end if
  else
    sl.islp = FixedDiv(dx, dy)
  end if
  if dx == 0 then
    if dy < 0 then sl.slp = -AM_MAXINT else sl.slp = AM_MAXINT end if
  else
    sl.slp = FixedDiv(dy, dx)
  end if
end function

/// Recomputes the map-space viewport for the current zoom while preserving its center point.
function AM_activateNewScale()
  global m_x
  m_x = m_x + _AM_IDiv(m_w, 2)
  global m_y
  m_y = m_y + _AM_IDiv(m_h, 2)
  global m_w
  m_w = _AM_FTOM(f_w)
  global m_h
  m_h = _AM_FTOM(f_h)
  m_x = m_x - _AM_IDiv(m_w, 2)
  m_y = m_y - _AM_IDiv(m_h, 2)
  global m_x2
  m_x2 = m_x + m_w
  global m_y2
  m_y2 = m_y + m_h
end function

/// Snapshots the current map viewport so big-map mode can later restore the prior zoom and location.
function AM_saveScaleAndLoc()
  global old_m_x
  old_m_x = m_x
  global old_m_y
  old_m_y = m_y
  global old_m_w
  old_m_w = m_w
  global old_m_h
  old_m_h = m_h
end function

/// Restores the saved viewport, repairs invalid dimensions from the active zoom, and refreshes its far edges.
function AM_restoreScaleAndLoc()
  global m_x
  m_x = old_m_x
  global m_y
  m_y = old_m_y
  global m_w
  m_w = old_m_w
  global m_h
  m_h = old_m_h
  if m_w <= 0 or m_h <= 0 then
    AM_activateNewScale()
  end if
  global m_x2
  m_x2 = m_x + m_w
  global m_y2
  m_y2 = m_y + m_h
end function

/// Adds mark entries to the automap.
function AM_addMark()
  if len(markpoints) != AM_NUMMARKPOINTS then
    global markpoints
    markpoints =[]
    i = 0
    while i < AM_NUMMARKPOINTS
      markpoints = markpoints +[_AM_MPoint(-1, -1)]
      i = i + 1
    end while
  end if

  mx = m_x + _AM_IDiv(m_w, 2)
  my = m_y + _AM_IDiv(m_h, 2)
  markpoints[markpointnum] = _AM_MPoint(mx, my)
  global markpointnum
  markpointnum = _AM_Mod(markpointnum + 1, AM_NUMMARKPOINTS)
end function

/// Computes minimum maximum boundaries values for the automap.
function AM_findMinMaxBoundaries()
  if typeof(vertexes) != "array" or len(vertexes) == 0 then
    global min_x
    min_x = 0
    global min_y
    min_y = 0
    global max_x
    max_x = SCREENWIDTH << FRACBITS
    global max_y
    max_y = SCREENHEIGHT << FRACBITS
  else
    min_x = vertexes[0].x
    min_y = vertexes[0].y
    max_x = vertexes[0].x
    max_y = vertexes[0].y

    for each v in vertexes
      if v.x < min_x then min_x = v.x end if
      if v.x > max_x then max_x = v.x end if
      if v.y < min_y then min_y = v.y end if
      if v.y > max_y then max_y = v.y end if
    end for
  end if

  global max_w
  max_w = max_x - min_x
  global max_h
  max_h = max_y - min_y
  if max_w <= 0 then max_w = SCREENWIDTH << FRACBITS end if
  if max_h <= 0 then max_h = SCREENHEIGHT << FRACBITS end if

  global min_w
  min_w = 2 * PLAYERRADIUS
  global min_h
  min_h = 2 * PLAYERRADIUS

  a = FixedDiv(f_w << FRACBITS, max_w)
  b = FixedDiv(f_h << FRACBITS, max_h)
  if a < b then min_scale_mtof = a else min_scale_mtof = b end if
  if min_scale_mtof <= 0 then min_scale_mtof = 1 end if

  a = FixedDiv(f_w << FRACBITS, min_w)
  b = FixedDiv(f_h << FRACBITS, min_h)
  if a > b then max_scale_mtof = a else max_scale_mtof = b end if
  if max_scale_mtof < min_scale_mtof then max_scale_mtof = min_scale_mtof end if
end function

/// Applies manual pan increments when follow mode is off and clamps the viewport to level bounds.
function AM_changeWindowLoc()
  if followplayer != 0 and plr is not void and plr.mo is not void then
    return
  end if

  global m_x
  m_x = m_x + m_paninc.x
  global m_y
  m_y = m_y + m_paninc.y

  if m_x < min_x then m_x = min_x end if
  if m_y < min_y then m_y = min_y end if
  if m_x + m_w > max_x then m_x = max_x - m_w end if
  if m_y + m_h > max_y then m_y = max_y - m_h end if

  global m_x2
  m_x2 = m_x + m_w
  global m_y2
  m_y2 = m_y + m_h
end function

/// Activates the automap, resets frame-local counters and pan state, selects the console player, and centers
/// the viewport.
function AM_initVariables()
  global automapactive
  automapactive = true
  global amclock
  amclock = 0
  global lightlev
  lightlev = 0

  global f_x
  f_x = 0
  global f_y
  f_y = 0
  global f_w
  f_w = finit_width
  global f_h
  f_h = finit_height

  if typeof(players) == "array" and consoleplayer >= 0 and consoleplayer < len(players) then
    global plr
    plr = players[consoleplayer]
  else
    plr = void
  end if

  if plr is not void and plr.mo is not void then
    global m_x
    m_x = plr.mo.x - _AM_FTOM(_AM_IDiv(f_w, 2))
    global m_y
    m_y = plr.mo.y - _AM_FTOM(_AM_IDiv(f_h, 2))
    f_oldloc.x = plr.mo.x
    f_oldloc.y = plr.mo.y
  else
    m_x = min_x
    m_y = min_y
    f_oldloc.x = AM_MAXINT
    f_oldloc.y = AM_MAXINT
  end if

  global m_w
  m_w = _AM_FTOM(f_w)
  global m_h
  m_h = _AM_FTOM(f_h)
  global m_x2
  m_x2 = m_x + m_w
  global m_y2
  m_y2 = m_y + m_h

  global m_paninc
  m_paninc = _AM_MPoint(0, 0)
  global mtof_zoommul
  mtof_zoommul = AM_FRACUNIT
  global ftom_zoommul
  ftom_zoommul = AM_FRACUNIT
  global cheating
  cheating = 0
end function

/// Resolves and pins the ten AMMNUM digit patches used to label player map marks.
function AM_loadPics()
  global marknums
  marknums =[]
  i = 0
  while i < 10
    if typeof(W_CacheLumpName) == "function" or typeof(W_CheckNumForName) == "function" then
      marknums = marknums +[_AM_CacheOrVoid("AMMNUM" + i, PU_STATIC)]
    else
      marknums = marknums +[void]
    end if
    i = i + 1
  end while
end function

/// Drops automap mark-patch references when leaving the map display.
function AM_unloadPics()
  global marknums
  marknums =[]
end function

/// Replaces every mark slot with the unused sentinel and restarts insertion at slot zero.
function AM_clearMarks()
  global markpoints
  markpoints =[]
  i = 0
  while i < AM_NUMMARKPOINTS
    markpoints = markpoints +[_AM_MPoint(-1, -1)]
    i = i + 1
  end while
  global markpointnum
  markpointnum = 0
end function

/// Resets the framebuffer viewport and initial zoom, derives level map bounds, and clears the level-start flag.
function AM_LevelInit()
  global f_x
  f_x = 0
  global f_y
  f_y = 0
  global f_w
  f_w = finit_width
  global f_h
  f_h = finit_height

  global scale_mtof
  scale_mtof = INITSCALEMTOF
  global scale_ftom
  scale_ftom = FixedDiv(AM_FRACUNIT, scale_mtof)

  AM_findMinMaxBoundaries()
  global leveljuststarted
  leveljuststarted = 0
end function

/// Activates the automap once, prepares level/view state and mark graphics, then notifies the status bar.
function AM_Start()
  if automapactive then return end if
  if leveljuststarted != 0 then
    AM_LevelInit()
  end if

  AM_initVariables()
  AM_loadPics()
  AM_clearMarks()
  global stopped
  stopped = false
  if typeof(ST_Responder) == "function" then
    ST_Responder(event_t(evtype_t.ev_keyup, AM_MSGENTERED, 0, 0))
  end if
end function

/// Clamps zoom-out at the scale where the complete level bounding box fits in the automap window.
function AM_minOutWindowScale()
  global scale_mtof
  scale_mtof = min_scale_mtof
  if scale_mtof <= 0 then scale_mtof = 1 end if
  global scale_ftom
  scale_ftom = FixedDiv(AM_FRACUNIT, scale_mtof)
  AM_activateNewScale()
end function

/// Clamps zoom-in to the configured maximum map-to-frame scale.
function AM_maxOutWindowScale()
  global scale_mtof
  scale_mtof = max_scale_mtof
  if scale_mtof <= 0 then scale_mtof = 1 end if
  global scale_ftom
  scale_ftom = FixedDiv(AM_FRACUNIT, scale_mtof)
  AM_activateNewScale()
end function

/// Applies the pending zoom multiplier, clamps it to level limits, derives its inverse, and recenters the
/// viewport.
function AM_changeWindowScale()
  global scale_mtof
  scale_mtof = FixedMul(scale_mtof, mtof_zoommul)
  scale_mtof = _AM_Clamp(scale_mtof, min_scale_mtof, max_scale_mtof)
  if scale_mtof <= 0 then scale_mtof = 1 end if
  global scale_ftom
  scale_ftom = FixedDiv(AM_FRACUNIT, scale_mtof)
  AM_activateNewScale()
end function

/// Recenters the map only when the tracked player position changes and remembers that position for the next
/// frame.
function AM_doFollowPlayer()
  if plr is void or plr.mo is void then return end if
  if f_oldloc.x != plr.mo.x or f_oldloc.y != plr.mo.y then
    global m_x
    m_x = plr.mo.x - _AM_IDiv(m_w, 2)
    global m_y
    m_y = plr.mo.y - _AM_IDiv(m_h, 2)
    global m_x2
    m_x2 = m_x + m_w
    global m_y2
    m_y2 = m_y + m_h
    f_oldloc.x = plr.mo.x
    f_oldloc.y = plr.mo.y
  end if
end function

/// Increments the automap pulse counter used to vary wall brightness over successive frames.
function AM_updateLightLev()
  global lightlev
  lightlev = lightlev + 1
end function

/// Writes one clipped color index into the logical automap framebuffer.
/// @param x Horizontal map- or screen-space coordinate.
/// @param y Vertical map- or screen-space coordinate.
/// @param color Doom palette index used for drawing.
/// @internal
function inline _AM_PutPixel(x, y, color)
  if x < f_x or x >= f_x + f_w or y < f_y or y >= f_y + f_h then return end if
  if x < 0 or x >= SCREENWIDTH or y < 0 or y >= SCREENHEIGHT then return end if
  if typeof(screens) != "array" or FB < 0 or FB >= len(screens) then return end if
  buf = screens[FB]
  if typeof(buf) != "bytes" then return end if
  idx = y * SCREENWIDTH + x
  if idx < 0 or idx >= len(buf) then return end if
  buf[idx] = color & 255
end function

/// Fills the clipped automap viewport in the logical framebuffer with its background palette index.
function AM_clearFB()
  if typeof(screens) != "array" or FB < 0 or FB >= len(screens) then return end if
  buf = screens[FB]
  if typeof(buf) != "bytes" then return end if

  y = f_y
  while y < f_y + f_h and y < SCREENHEIGHT
    x = f_x
    row = y * SCREENWIDTH
    while x < f_x + f_w and x < SCREENWIDTH
      idx = row + x
      if idx >= 0 and idx < len(buf) then buf[idx] = BACKGROUND end if
      x = x + 1
    end while
    y = y + 1
  end while
end function

/// Computes mline values for the automap.
/// @param ml Ml value supplied to `AM_clipMline`.
/// @param fl Fl value supplied to `AM_clipMline`.
function AM_clipMline(ml, fl)
  if ml is void or fl is void then return false end if

  x1 = _AM_CXMTOF(ml.a.x)
  y1 = _AM_CYMTOF(ml.a.y)
  x2 = _AM_CXMTOF(ml.b.x)
  y2 = _AM_CYMTOF(ml.b.y)

  if (x1 < f_x and x2 < f_x) or(x1 >= f_x + f_w and x2 >= f_x + f_w) then return false end if
  if (y1 < f_y and y2 < f_y) or(y1 >= f_y + f_h and y2 >= f_y + f_h) then return false end if

  fl.a.x = x1
  fl.a.y = y1
  fl.b.x = x2
  fl.b.y = y2
  return true
end function

/// Clips and rasterizes a framebuffer-space line with integer stepping.
/// @param fl Fl value supplied to `AM_drawFline`.
/// @param color Doom palette index used for drawing.
function AM_drawFline(fl, color)
  if fl is void then return end if

  x0 = fl.a.x
  y0 = fl.a.y
  x1 = fl.b.x
  y1 = fl.b.y

  dx = _AM_Abs(x1 - x0)
  sx = -1
  if x0 < x1 then sx = 1 end if
  dy = -_AM_Abs(y1 - y0)
  sy = -1
  if y0 < y1 then sy = 1 end if
  err = dx + dy

  while true
    _AM_PutPixel(x0, y0, color)
    if x0 == x1 and y0 == y1 then break end if
    e2 = err << 1
    if e2 >= dy then
      err = err + dy
      x0 = x0 + sx
    end if
    if e2 <= dx then
      err = err + dx
      y0 = y0 + sy
    end if
  end while
end function

/// Projects a map-space line into the automap window and rasterizes the visible segment.
/// @param ml Ml value supplied to `AM_drawMline`.
/// @param color Doom palette index used for drawing.
function AM_drawMline(ml, color)
  fl = _AM_FLine(0, 0, 0, 0)
  if AM_clipMline(ml, fl) then
    AM_drawFline(fl, color)
  end if
end function

/// Draws map-aligned grid lines across the visible automap extent when the grid option is enabled.
/// @param color Doom palette index used for drawing.
function AM_drawGrid(color)
  if not grid then return end if

  step = 128 << FRACBITS
  if step <= 0 then return end if

  startx = _AM_IDiv(m_x, step) * step
  x = startx
  while x <= m_x + m_w
    AM_drawMline(_AM_MLine(x, m_y, x, m_y + m_h), color)
    x = x + step
  end while

  starty = _AM_IDiv(m_y, step) * step
  y = starty
  while y <= m_y + m_h
    AM_drawMline(_AM_MLine(m_x, y, m_x + m_w, y), color)
    y = y + step
  end while
end function

/// Classifies discovered map lines by geometry and special type, then draws them with the corresponding automap
/// colors.
function AM_drawWalls()
  if typeof(lines) != "array" then return end if

  for each li in lines
    if li is void or li.v1 is void or li.v2 is void then
      continue
    end if

    color = WALLCOLORS
    if (li.flags & ML_DONTDRAW) != 0 and cheating == 0 then
      continue
    end if
    if li.backsector is void then
      color = WALLCOLORS
    else if li.special == 39 then
      color = CDWALLCOLORS
    else if li.special == 97 then
      color = FDWALLCOLORS
    else if li.flags & ML_SECRET then
      color = WALLCOLORS
    else
      color = TSWALLCOLORS
    end if

    ml = _AM_MLine(li.v1.x, li.v1.y, li.v2.x, li.v2.y)
    AM_drawMline(ml, color)
  end for
end function

/// Rotates a map-space vector by a Doom binary angle using the fine sine/cosine tables.
/// @param x Horizontal map- or screen-space coordinate.
/// @param y Vertical map- or screen-space coordinate.
/// @param a First input operand.
function AM_rotate(x, y, a)
  if typeof(finecosine) != "array" or typeof(finesine) != "array" then
    return _AM_MPoint(x, y)
  end if
  ai =(a >> ANGLETOFINESHIFT) & FINEMASK
  tx = FixedMul(x, finecosine[ai]) - FixedMul(y, finesine[ai])
  ty = FixedMul(x, finesine[ai]) + FixedMul(y, finecosine[ai])
  return _AM_MPoint(tx, ty)
end function

/// Transforms and draws a vector glyph at a map position, applying scale and rotation to each source segment.
/// @param lineset Lineset value supplied to `AM_drawLineCharacter`.
/// @param count Number of elements or iterations to process.
/// @param scale Scale value supplied to `AM_drawLineCharacter`.
/// @param angle Doom binary-angle measurement.
/// @param color Doom palette index used for drawing.
/// @param x Horizontal map- or screen-space coordinate.
/// @param y Vertical map- or screen-space coordinate.
function AM_drawLineCharacter(lineset, count, scale, angle, color, x, y)
  if typeof(lineset) != "array" then return end if
  i = 0
  while i < count and i < len(lineset)
    l = lineset[i]
    if l is not void then
      a = _AM_MPoint(FixedMul(l.a.x, scale), FixedMul(l.a.y, scale))
      b = _AM_MPoint(FixedMul(l.b.x, scale), FixedMul(l.b.y, scale))
      ra = AM_rotate(a.x, a.y, angle)
      rb = AM_rotate(b.x, b.y, angle)
      ml = _AM_MLine(x + ra.x, y + ra.y, x + rb.x, y + rb.y)
      AM_drawMline(ml, color)
    end if
    i = i + 1
  end while
end function

/// Draws the local or network player arrow glyphs at their interpolated positions and facing angles.
function AM_drawPlayers()
  if plr is void or plr.mo is void then return end if

  px = plr.mo.x
  py = plr.mo.y
  ang = plr.mo.angle
  r = _AM_IDiv(8 * PLAYERRADIUS, 7)

  tip = AM_rotate(r, 0, ang)
  left = AM_rotate(_AM_IDiv(-r, 2), _AM_IDiv(r, 3), ang)
  right = AM_rotate(_AM_IDiv(-r, 2), _AM_IDiv(-r, 3), ang)

  AM_drawMline(_AM_MLine(px + left.x, py + left.y, px + tip.x, py + tip.y), YOURCOLORS)
  AM_drawMline(_AM_MLine(px + tip.x, py + tip.y, px + right.x, py + right.y), YOURCOLORS)
  AM_drawMline(_AM_MLine(px + right.x, py + right.y, px + left.x, py + left.y), YOURCOLORS)
end function

/// Draws cheat-visible map objects as scaled vector triangles around their world positions.
/// @param color Doom palette index used for drawing.
/// @param radius Radius value supplied to `AM_drawThings`.
function AM_drawThings(color, radius)
  color = color
  radius = radius

end function

/// Projects user mark positions and labels them with numbered patch glyphs.
function AM_drawMarks()
  if len(markpoints) == 0 then return end if
  for each p in markpoints
    if p.x < 0 or p.y < 0 then continue end if
    x = _AM_CXMTOF(p.x)
    y = _AM_CYMTOF(p.y)
    _AM_PutPixel(x, y, WHITE)
    _AM_PutPixel(x - 1, y, WHITE)
    _AM_PutPixel(x + 1, y, WHITE)
    _AM_PutPixel(x, y - 1, WHITE)
    _AM_PutPixel(x, y + 1, WHITE)
  end for
end function

/// Draws the single-pixel cursor at the center of the automap window.
/// @param color Doom palette index used for drawing.
function AM_drawCrosshair(color)
  cx = f_x + _AM_IDiv(f_w, 2)
  cy = f_y + _AM_IDiv(f_h, 2)
  _AM_PutPixel(cx, cy, color)
  _AM_PutPixel(cx - 1, cy, color)
  _AM_PutPixel(cx + 1, cy, color)
  _AM_PutPixel(cx, cy - 1, color)
  _AM_PutPixel(cx, cy + 1, color)
end function

/// Consumes automap key events, toggling modes and updating pan, zoom, follow, grid, and mark state.
/// @param ev Input event to process.
function AM_Responder(ev)
  if ev is void then return false end if

  if not automapactive then
    if ev.type == evtype_t.ev_keydown and ev.data1 == AM_STARTKEY and not deathmatch then
      AM_Start()
      viewactive = false
      return true
    end if
    return false
  end if

  if ev.type != evtype_t.ev_keydown and ev.type != evtype_t.ev_keyup then return false end if
  key = _AM_CaseKey(ev.data1)

  if ev.type == evtype_t.ev_keydown then
    if key == AM_ENDKEY then
      AM_Stop()
      return true
    end if
    if key == AM_PANUPKEY then m_paninc.y = F_PANINC << FRACBITS; return true end if
    if key == AM_PANDOWNKEY then m_paninc.y = -(F_PANINC << FRACBITS); return true end if
    if key == AM_PANLEFTKEY then m_paninc.x = -(F_PANINC << FRACBITS); return true end if
    if key == AM_PANRIGHTKEY then m_paninc.x = F_PANINC << FRACBITS; return true end if
    if key == AM_ZOOMINKEY then mtof_zoommul = M_ZOOMIN; ftom_zoommul = M_ZOOMOUT; return true end if
    if key == AM_ZOOMOUTKEY then mtof_zoommul = M_ZOOMOUT; ftom_zoommul = M_ZOOMIN; return true end if

    if key == AM_GOBIGKEY then
      if old_m_w == 0 then
        AM_saveScaleAndLoc()
        AM_minOutWindowScale()
      else
        AM_restoreScaleAndLoc()
        global old_m_w
        old_m_w = 0
      end if
      return true
    end if

    if key == AM_FOLLOWKEY then
      global followplayer
      followplayer = 1 - followplayer
      f_oldloc.x = AM_MAXINT
      f_oldloc.y = AM_MAXINT
      return true
    end if

    if key == AM_GRIDKEY then
      if grid then grid = 0 else grid = 1 end if
      return true
    end if

    if key == AM_MARKKEY then
      AM_addMark()
      return true
    end if

    if key == AM_CLEARMARKKEY then
      AM_clearMarks()
      return true
    end if

    if cht_CheckCheat(cheat_amap, key) != 0 then
      global cheating
      cheating = cheating + 1
      if cheating > 2 then cheating = 0 end if
      return true
    end if
  else
    if key == AM_PANUPKEY or key == AM_PANDOWNKEY then m_paninc.y = 0; return true end if
    if key == AM_PANLEFTKEY or key == AM_PANRIGHTKEY then m_paninc.x = 0; return true end if
    if key == AM_ZOOMINKEY or key == AM_ZOOMOUTKEY then
      global mtof_zoommul
      mtof_zoommul = AM_FRACUNIT
      global ftom_zoommul
      ftom_zoommul = AM_FRACUNIT
      return true
    end if
  end if

  return false
end function

/// Applies held pan and zoom increments once per game tic while the automap is active.
function AM_Ticker()
  if not automapactive then return end if

  global amclock
  amclock = amclock + 1
  if followplayer != 0 then
    AM_doFollowPlayer()
  end if
  if mtof_zoommul != AM_FRACUNIT then
    AM_changeWindowScale()
  end if
  if m_paninc.x != 0 or m_paninc.y != 0 then
    AM_changeWindowLoc()
  end if
  AM_updateLightLev()
end function

/// Renders one complete automap frame in layer order, including geometry, actors, marks, and cursor.
function AM_Drawer()
  if not automapactive then return end if

  AM_clearFB()
  AM_drawGrid(GRIDCOLORS)
  AM_drawWalls()
  AM_drawPlayers()
  AM_drawThings(THINGCOLORS, 16 << FRACBITS)
  AM_drawMarks()
  AM_drawCrosshair(XHAIRCOLORS)
  V_MarkRect(f_x, f_y, f_w, f_h)
end function

/// Releases mark graphics, restores normal view rendering, and notifies the status bar that the automap closed.
function AM_Stop()
  if not automapactive then return end if
  AM_unloadPics()
  global automapactive
  automapactive = false
  global stopped
  stopped = true
  viewactive = true
  if typeof(ST_Responder) == "function" then
    ST_Responder(event_t(evtype_t.ev_keyup, AM_MSGEXITED, 0, 0))
  end if
end function



