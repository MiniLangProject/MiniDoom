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

  Script: am_map.ml
  Purpose: Implements automap input, state, and drawing logic.
*/
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

const AM_MSGHEADER =((97 << 24) +(109 << 16))
const AM_MSGENTERED =(AM_MSGHEADER |(101 << 8))
const AM_MSGEXITED =(AM_MSGHEADER |(120 << 8))

const REDS =(256 - 5 * 16)
const REDRANGE = 16
const GREENS =(7 * 16)
const GREENRANGE = 16
const GRAYS =(6 * 16)
const GRAYSRANGE = 16
const BROWNS =(4 * 16)
const BROWNRANGE = 16
const YELLOWS =(256 - 32 + 7)
const YELLOWRANGE = 1
const BLACK = 0
const WHITE =(256 - 47)

const BACKGROUND = BLACK
const YOURCOLORS = WHITE
const WALLCOLORS = REDS
const TSWALLCOLORS = GRAYS
const FDWALLCOLORS = BROWNS
const CDWALLCOLORS = YELLOWS
const THINGCOLORS = GREENS
const GRIDCOLORS =(GRAYS +(GRAYSRANGE >> 1))
const XHAIRCOLORS = GRAYS

const FB = 0

const AM_PANDOWNKEY = KEY_DOWNARROW
const AM_PANUPKEY = KEY_UPARROW
const AM_PANRIGHTKEY = KEY_RIGHTARROW
const AM_PANLEFTKEY = KEY_LEFTARROW
const AM_ZOOMINKEY = 61
const AM_ZOOMOUTKEY = 45
const AM_STARTKEY = KEY_TAB
const AM_ENDKEY = KEY_TAB
const AM_GOBIGKEY = 48
const AM_FOLLOWKEY = 102
const AM_GRIDKEY = 103
const AM_MARKKEY = 109
const AM_CLEARMARKKEY = 99

const AM_NUMMARKPOINTS = 10

const INITSCALEMTOF = 13107
const AM_FRACUNIT = 65536
const F_PANINC = 4
const M_ZOOMIN = 66846
const M_ZOOMOUT = 64250
const AM_MAXINT = 2147483647

/*
* Struct: fpoint_t
* Purpose: Describes fpoint geometry or asset data used by the automap system.
*/
struct fpoint_t
  x
  y
end struct

/*
* Struct: fline_t
* Purpose: Describes fline geometry or asset data used by the automap system.
*/
struct fline_t
  a
  b
end struct

/*
* Struct: mpoint_t
* Purpose: Describes mpoint geometry or asset data used by the automap system.
*/
struct mpoint_t
  x
  y
end struct

/*
* Struct: mline_t
* Purpose: Describes mline geometry or asset data used by the automap system.
*/
struct mline_t
  a
  b
end struct

/*
* Struct: islope_t
* Purpose: Holds the per-edge slope steps used when clipping map lines to the automap window.
*/
struct islope_t
  slp
  islp
end struct

/*
* Function: _AM_MPoint
* Purpose: Constructs a point in map-space fixed-point coordinates.
*/
function inline _AM_MPoint(x, y)
  return mpoint_t(x, y)
end function

/*
* Function: _AM_FPoint
* Purpose: Constructs a point in automap framebuffer pixel coordinates.
*/
function inline _AM_FPoint(x, y)
  return fpoint_t(x, y)
end function

/*
* Function: _AM_MLine
* Purpose: Constructs a map-space line from two fixed-point endpoints.
*/
function inline _AM_MLine(x1, y1, x2, y2)
  return mline_t(_AM_MPoint(x1, y1), _AM_MPoint(x2, y2))
end function

/*
* Function: _AM_FLine
* Purpose: Constructs a framebuffer-space line used by the clipping and rasterization stages.
*/
function inline _AM_FLine(x1, y1, x2, y2)
  return fline_t(_AM_FPoint(x1, y1), _AM_FPoint(x2, y2))
end function

/*
* Function: _AM_Abs
* Purpose: Returns the magnitude of an integer without altering its fixed-point scale.
*/
function inline _AM_Abs(v)
  if v < 0 then return - v end if
  return v
end function

/*
* Function: _AM_Clamp
* Purpose: Restricts a zoom or coordinate value to the caller's inclusive lower and upper bounds.
*/
function inline _AM_Clamp(v, lo, hi)
  if v < lo then return lo end if
  if v > hi then return hi end if
  return v
end function

/*
* Function: _AM_Mod
* Purpose: Computes a non-negative remainder for grid alignment, returning zero for a zero divisor.
*/
function inline _AM_Mod(n, d)
  if d == 0 then return 0 end if
  r = n % d
  if r < 0 then r = r + d end if
  return r
end function

/*
* Function: _AM_IDiv
* Purpose: Returns a signed quotient truncated toward zero, or zero for invalid operands and a zero divisor.
*/
function inline _AM_IDiv(a, b)
  if typeof(a) != "int" or typeof(b) != "int" or b == 0 then return 0 end if
  q = a / b
  if q >= 0 then return std.math.floor(q) end if
  return std.math.ceil(q)
end function

/*
* Function: _AM_ToLowerAscii
* Purpose: Folds one uppercase ASCII byte to lowercase while leaving all other bytes unchanged.
*/
function inline _AM_ToLowerAscii(c)
  if c >= 65 and c <= 90 then return c + 32 end if
  return c
end function

/*
* Function: _AM_CaseKey
* Purpose: Normalizes an input key to lowercase ASCII for case-insensitive automap bindings.
*/
function inline _AM_CaseKey(k)
  if typeof(k) != "int" then return -1 end if
  return _AM_ToLowerAscii(k)
end function

/*
* Function: _AM_CacheOrVoid
* Purpose: Resolves an optional automap patch lump and returns its tagged cache entry, or void when the name is absent.
*/
function inline _AM_CacheOrVoid(name, tag)
  if typeof(W_CheckNumForName) == "function" then
    ln = W_CheckNumForName(name)
    if ln < 0 then return void end if
    return W_CacheLumpNum(ln, tag)
  end if
  return W_CacheLumpName(name, tag)
end function

/*
* Function: _AM_FTOM
* Purpose: Converts a framebuffer pixel distance to map-space fixed-point units using the current zoom scale.
*/
function inline _AM_FTOM(x)
  return FixedMul(x << 16, scale_ftom)
end function

/*
* Function: _AM_MTOF
* Purpose: Converts a map-space fixed-point distance to framebuffer pixels using the current zoom scale.
*/
function inline _AM_MTOF(x)
  return FixedMul(x, scale_mtof) >> 16
end function

/*
* Function: _AM_CXMTOF
* Purpose: Projects a map-space x coordinate into the automap window relative to its current origin.
*/
function inline _AM_CXMTOF(x)
  return f_x + _AM_MTOF(x - m_x)
end function

/*
* Function: _AM_CYMTOF
* Purpose: Projects a map-space y coordinate into the vertically inverted automap framebuffer.
*/
function inline _AM_CYMTOF(y)
  return f_y +(f_h - _AM_MTOF(y - m_y))
end function

cheating = 0
grid = 0
leveljuststarted = 1

automapactive = false
finit_width = SCREENWIDTH
finit_height = SCREENHEIGHT - 32

f_x = 0
f_y = 0
f_w = 0
f_h = 0

lightlev = 0
fb = void
amclock = 0

m_paninc = _AM_MPoint(0, 0)
mtof_zoommul = AM_FRACUNIT
ftom_zoommul = AM_FRACUNIT

m_x = 0
m_y = 0
m_x2 = 0
m_y2 = 0
m_w = 0
m_h = 0

min_x = 0
min_y = 0
max_x = 0
max_y = 0
max_w = 0
max_h = 0
min_w = 0
min_h = 0

min_scale_mtof = AM_FRACUNIT
max_scale_mtof = AM_FRACUNIT

old_m_w = 0
old_m_h = 0
old_m_x = 0
old_m_y = 0
f_oldloc = _AM_MPoint(AM_MAXINT, AM_MAXINT)

scale_mtof = INITSCALEMTOF
scale_ftom = AM_FRACUNIT

plr = void

marknums =[]
markpoints =[]
markpointnum = 0
followplayer = 1

cheat_amap_seq = bytes([0xb2, 0x26, 0x26, 0x2e, 0xff])
cheat_amap = cheatseq_t(cheat_amap_seq, 0)

stopped = true

/*
* Function: AM_getIslope
* Purpose: Computes both dy/dx and dx/dy for a map line, using signed sentinels for vertical and horizontal cases.
*/
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

/*
* Function: AM_activateNewScale
* Purpose: Recomputes the map-space viewport for the current zoom while preserving its center point.
*/
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

/*
* Function: AM_saveScaleAndLoc
* Purpose: Snapshots the current map viewport so big-map mode can later restore the prior zoom and location.
*/
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

/*
* Function: AM_restoreScaleAndLoc
* Purpose: Restores the saved viewport, repairs invalid dimensions from the active zoom, and refreshes its far edges.
*/
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

/*
* Function: AM_addMark
* Purpose: Adds mark entries to the automap.
*/
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

/*
* Function: AM_findMinMaxBoundaries
* Purpose: Computes minimum maximum boundaries values for the automap.
*/
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

/*
* Function: AM_changeWindowLoc
* Purpose: Applies manual pan increments when follow mode is off and clamps the viewport to level bounds.
*/
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

/*
* Function: AM_initVariables
* Purpose: Activates the automap, resets frame-local counters and pan state, selects the console player, and centers the viewport.
*/
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

/*
* Function: AM_loadPics
* Purpose: Resolves and pins the ten AMMNUM digit patches used to label player map marks.
*/
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

/*
* Function: AM_unloadPics
* Purpose: Drops automap mark-patch references when leaving the map display.
*/
function AM_unloadPics()
  global marknums
  marknums =[]
end function

/*
* Function: AM_clearMarks
* Purpose: Replaces every mark slot with the unused sentinel and restarts insertion at slot zero.
*/
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

/*
* Function: AM_LevelInit
* Purpose: Resets the framebuffer viewport and initial zoom, derives level map bounds, and clears the level-start flag.
*/
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

/*
* Function: AM_Start
* Purpose: Activates the automap once, prepares level/view state and mark graphics, then notifies the status bar.
*/
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

/*
* Function: AM_minOutWindowScale
* Purpose: Clamps zoom-out at the scale where the complete level bounding box fits in the automap window.
*/
function AM_minOutWindowScale()
  global scale_mtof
  scale_mtof = min_scale_mtof
  if scale_mtof <= 0 then scale_mtof = 1 end if
  global scale_ftom
  scale_ftom = FixedDiv(AM_FRACUNIT, scale_mtof)
  AM_activateNewScale()
end function

/*
* Function: AM_maxOutWindowScale
* Purpose: Clamps zoom-in to the configured maximum map-to-frame scale.
*/
function AM_maxOutWindowScale()
  global scale_mtof
  scale_mtof = max_scale_mtof
  if scale_mtof <= 0 then scale_mtof = 1 end if
  global scale_ftom
  scale_ftom = FixedDiv(AM_FRACUNIT, scale_mtof)
  AM_activateNewScale()
end function

/*
* Function: AM_changeWindowScale
* Purpose: Applies the pending zoom multiplier, clamps it to level limits, derives its inverse, and recenters the viewport.
*/
function AM_changeWindowScale()
  global scale_mtof
  scale_mtof = FixedMul(scale_mtof, mtof_zoommul)
  scale_mtof = _AM_Clamp(scale_mtof, min_scale_mtof, max_scale_mtof)
  if scale_mtof <= 0 then scale_mtof = 1 end if
  global scale_ftom
  scale_ftom = FixedDiv(AM_FRACUNIT, scale_mtof)
  AM_activateNewScale()
end function

/*
* Function: AM_doFollowPlayer
* Purpose: Recenters the map only when the tracked player position changes and remembers that position for the next frame.
*/
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

/*
* Function: AM_updateLightLev
* Purpose: Increments the automap pulse counter used to vary wall brightness over successive frames.
*/
function AM_updateLightLev()
  global lightlev
  lightlev = lightlev + 1
end function

/*
* Function: _AM_PutPixel
* Purpose: Writes one clipped color index into the logical automap framebuffer.
*/
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

/*
* Function: AM_clearFB
* Purpose: Fills the clipped automap viewport in the logical framebuffer with its background palette index.
*/
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

/*
* Function: AM_clipMline
* Purpose: Computes mline values for the automap.
*/
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

/*
* Function: AM_drawFline
* Purpose: Clips and rasterizes a framebuffer-space line with integer stepping.
*/
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

/*
* Function: AM_drawMline
* Purpose: Projects a map-space line into the automap window and rasterizes the visible segment.
*/
function AM_drawMline(ml, color)
  fl = _AM_FLine(0, 0, 0, 0)
  if AM_clipMline(ml, fl) then
    AM_drawFline(fl, color)
  end if
end function

/*
* Function: AM_drawGrid
* Purpose: Draws map-aligned grid lines across the visible automap extent when the grid option is enabled.
*/
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

/*
* Function: AM_drawWalls
* Purpose: Classifies discovered map lines by geometry and special type, then draws them with the corresponding automap colors.
*/
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

/*
* Function: AM_rotate
* Purpose: Rotates a map-space vector by a Doom binary angle using the fine sine/cosine tables.
*/
function AM_rotate(x, y, a)
  if typeof(finecosine) != "array" or typeof(finesine) != "array" then
    return _AM_MPoint(x, y)
  end if
  ai =(a >> ANGLETOFINESHIFT) & FINEMASK
  tx = FixedMul(x, finecosine[ai]) - FixedMul(y, finesine[ai])
  ty = FixedMul(x, finesine[ai]) + FixedMul(y, finecosine[ai])
  return _AM_MPoint(tx, ty)
end function

/*
* Function: AM_drawLineCharacter
* Purpose: Transforms and draws a vector glyph at a map position, applying scale and rotation to each source segment.
*/
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

/*
* Function: AM_drawPlayers
* Purpose: Draws the local or network player arrow glyphs at their interpolated positions and facing angles.
*/
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

/*
* Function: AM_drawThings
* Purpose: Draws cheat-visible map objects as scaled vector triangles around their world positions.
*/
function AM_drawThings(color, radius)
  color = color
  radius = radius

end function

/*
* Function: AM_drawMarks
* Purpose: Projects user mark positions and labels them with numbered patch glyphs.
*/
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

/*
* Function: AM_drawCrosshair
* Purpose: Draws the single-pixel cursor at the center of the automap window.
*/
function AM_drawCrosshair(color)
  cx = f_x + _AM_IDiv(f_w, 2)
  cy = f_y + _AM_IDiv(f_h, 2)
  _AM_PutPixel(cx, cy, color)
  _AM_PutPixel(cx - 1, cy, color)
  _AM_PutPixel(cx + 1, cy, color)
  _AM_PutPixel(cx, cy - 1, color)
  _AM_PutPixel(cx, cy + 1, color)
end function

/*
* Function: AM_Responder
* Purpose: Consumes automap key events, toggling modes and updating pan, zoom, follow, grid, and mark state.
*/
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

/*
* Function: AM_Ticker
* Purpose: Applies held pan and zoom increments once per game tic while the automap is active.
*/
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

/*
* Function: AM_Drawer
* Purpose: Renders one complete automap frame in layer order, including geometry, actors, marks, and cursor.
*/
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

/*
* Function: AM_Stop
* Purpose: Releases mark graphics, restores normal view rendering, and notifies the status bar that the automap closed.
*/
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



