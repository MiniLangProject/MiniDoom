# `src/am_map.ml`

[Home](README.md) · [Files](Files.md)

Implements automap input, state, and drawing logic.

Package: [`(global)`](Package-global-1952375359.md)

Reachable from entry: **yes**

## Imports

- `doomdef.ml` → [src/doomdef.ml](File-src-doomdef-ml-460406769.md)
- `doomstat.ml` → [src/doomstat.ml](File-src-doomstat-ml-1652708088.md)
- `dstrings.ml` → [src/dstrings.ml](File-src-dstrings-ml-567491523.md)
- `i_system.ml` → [src/i_system.ml](File-src-i-system-ml-1632920966.md)
- `m_cheat.ml` → [src/m_cheat.ml](File-src-m-cheat-ml-440987496.md)
- `m_fixed.ml` → [src/m_fixed.ml](File-src-m-fixed-ml-2129187227.md)
- `p_local.ml` → [src/p_local.ml](File-src-p-local-ml-1043095437.md)
- `r_state.ml` → [src/r_state.ml](File-src-r-state-ml-691819649.md)
- `st_stuff.ml` → [src/st_stuff.ml](File-src-st-stuff-ml-811030939.md)
- `v_video.ml` → [src/v_video.ml](File-src-v-video-ml-592999939.md)
- `w_wad.ml` → [src/w_wad.ml](File-src-w-wad-ml-893006035.md)
- `z_zone.ml` → [src/z_zone.ml](File-src-z-zone-ml-1788911354.md)

## Declarations

<a id="function-function-am-abs-inline-function-am-abs-v-src-am-map-ml-849795394"></a>
### _AM_Abs

```ml
inline function _AM_Abs(v)
```

Returns the magnitude of an integer without altering its fixed-point scale.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `v` | `dynamic` | — | Value consumed by the operation. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/am_map.ml#L209)

<a id="function-function-am-cacheorvoid-inline-function-am-cacheorvoid-name-tag-src-am-map-ml-708958987"></a>
### _AM_CacheOrVoid

```ml
inline function _AM_CacheOrVoid(name, tag)
```

Resolves an optional automap patch lump and returns its tagged cache entry, or void when the name is absent.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `name` | `dynamic` | — | Resource or object name to resolve. |
| `tag` | `dynamic` | — | Zone-memory or resource-lifetime tag. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/am_map.ml#L268)

<a id="function-function-am-casekey-inline-function-am-casekey-k-src-am-map-ml-1436408755"></a>
### _AM_CaseKey

```ml
inline function _AM_CaseKey(k)
```

Normalizes an input key to lowercase ASCII for case-insensitive automap bindings.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `k` | `dynamic` | — | K value supplied to `_AM_CaseKey`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/am_map.ml#L259)

<a id="function-function-am-clamp-inline-function-am-clamp-v-lo-hi-src-am-map-ml-723797740"></a>
### _AM_Clamp

```ml
inline function _AM_Clamp(v, lo, hi)
```

Restricts a zoom or coordinate value to the caller's inclusive lower and upper bounds.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `v` | `dynamic` | — | Value consumed by the operation. |
| `lo` | `dynamic` | — | Inclusive lower bound. |
| `hi` | `dynamic` | — | Inclusive upper bound. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/am_map.ml#L219)

<a id="function-function-am-cxmtof-inline-function-am-cxmtof-x-src-am-map-ml-1235620120"></a>
### _AM_CXMTOF

```ml
inline function _AM_CXMTOF(x)
```

Projects a map-space x coordinate into the automap window relative to its current origin.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `x` | `dynamic` | — | Horizontal map- or screen-space coordinate. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/am_map.ml#L294)

<a id="function-function-am-cymtof-inline-function-am-cymtof-y-src-am-map-ml-311430407"></a>
### _AM_CYMTOF

```ml
inline function _AM_CYMTOF(y)
```

Projects a map-space y coordinate into the vertically inverted automap framebuffer.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `y` | `dynamic` | — | Vertical map- or screen-space coordinate. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/am_map.ml#L301)

<a id="function-function-am-fline-inline-function-am-fline-x1-y1-x2-y2-src-am-map-ml-323930756"></a>
### _AM_FLine

```ml
inline function _AM_FLine(x1, y1, x2, y2)
```

Constructs a framebuffer-space line used by the clipping and rasterization stages.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `x1` | `dynamic` | — | Horizontal coordinate of the first endpoint. |
| `y1` | `dynamic` | — | Vertical coordinate of the first endpoint. |
| `x2` | `dynamic` | — | Horizontal coordinate of the second endpoint. |
| `y2` | `dynamic` | — | Vertical coordinate of the second endpoint. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/am_map.ml#L202)

<a id="function-function-am-fpoint-inline-function-am-fpoint-x-y-src-am-map-ml-1587790255"></a>
### _AM_FPoint

```ml
inline function _AM_FPoint(x, y)
```

Constructs a point in automap framebuffer pixel coordinates.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `x` | `dynamic` | — | Horizontal map- or screen-space coordinate. |
| `y` | `dynamic` | — | Vertical map- or screen-space coordinate. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/am_map.ml#L182)

<a id="function-function-am-ftom-inline-function-am-ftom-x-src-am-map-ml-912357714"></a>
### _AM_FTOM

```ml
inline function _AM_FTOM(x)
```

Converts a framebuffer pixel distance to map-space fixed-point units using the current zoom scale.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `x` | `dynamic` | — | Horizontal map- or screen-space coordinate. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/am_map.ml#L280)

<a id="function-function-am-idiv-inline-function-am-idiv-a-b-src-am-map-ml-938453907"></a>
### _AM_IDiv

```ml
inline function _AM_IDiv(a, b)
```

Returns a signed quotient truncated toward zero, or zero for invalid operands and a zero divisor in `_AM_IDiv`

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `a` | `dynamic` | — | First input operand. |
| `b` | `dynamic` | — | Second input operand. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/am_map.ml#L241)

<a id="function-function-am-mline-inline-function-am-mline-x1-y1-x2-y2-src-am-map-ml-396644912"></a>
### _AM_MLine

```ml
inline function _AM_MLine(x1, y1, x2, y2)
```

Constructs a map-space line from two fixed-point endpoints.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `x1` | `dynamic` | — | Horizontal coordinate of the first endpoint. |
| `y1` | `dynamic` | — | Vertical coordinate of the first endpoint. |
| `x2` | `dynamic` | — | Horizontal coordinate of the second endpoint. |
| `y2` | `dynamic` | — | Vertical coordinate of the second endpoint. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/am_map.ml#L192)

<a id="function-function-am-mod-inline-function-am-mod-n-d-src-am-map-ml-1436761690"></a>
### _AM_Mod

```ml
inline function _AM_Mod(n, d)
```

Computes a non-negative remainder for grid alignment, returning zero for a zero divisor.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `n` | `dynamic` | — | Number of values to process. |
| `d` | `dynamic` | — | Divisor or direction value used by the operation. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/am_map.ml#L229)

<a id="function-function-am-mpoint-inline-function-am-mpoint-x-y-src-am-map-ml-1928583769"></a>
### _AM_MPoint

```ml
inline function _AM_MPoint(x, y)
```

Constructs a point in map-space fixed-point coordinates.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `x` | `dynamic` | — | Horizontal map- or screen-space coordinate. |
| `y` | `dynamic` | — | Vertical map- or screen-space coordinate. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/am_map.ml#L174)

<a id="function-function-am-mtof-inline-function-am-mtof-x-src-am-map-ml-926496378"></a>
### _AM_MTOF

```ml
inline function _AM_MTOF(x)
```

Converts a map-space fixed-point distance to framebuffer pixels using the current zoom scale.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `x` | `dynamic` | — | Horizontal map- or screen-space coordinate. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/am_map.ml#L287)

<a id="function-function-am-putpixel-inline-function-am-putpixel-x-y-color-src-am-map-ml-1583495650"></a>
### _AM_PutPixel

```ml
inline function _AM_PutPixel(x, y, color)
```

Writes one clipped color index into the logical automap framebuffer.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `x` | `dynamic` | — | Horizontal map- or screen-space coordinate. |
| `y` | `dynamic` | — | Vertical map- or screen-space coordinate. |
| `color` | `dynamic` | — | Doom palette index used for drawing. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/am_map.ml#L762)

<a id="function-function-am-tolowerascii-inline-function-am-tolowerascii-c-src-am-map-ml-612118995"></a>
### _AM_ToLowerAscii

```ml
inline function _AM_ToLowerAscii(c)
```

Folds one uppercase ASCII byte to lowercase while leaving all other bytes unchanged.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `c` | `dynamic` | — | C value supplied to `_AM_ToLowerAscii`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/am_map.ml#L251)

<a id="function-function-am-activatenewscale-function-am-activatenewscale-src-am-map-ml-1047704837"></a>
### AM_activateNewScale

```ml
function AM_activateNewScale()
```

Recomputes the map-space viewport for the current zoom while preserving its center point.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/am_map.ml#L433)

<a id="function-function-am-addmark-function-am-addmark-src-am-map-ml-1060519389"></a>
### AM_addMark

```ml
function AM_addMark()
```

Adds mark entries to the automap.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/am_map.ml#L482)

<a id="function-function-am-changewindowloc-function-am-changewindowloc-src-am-map-ml-441067149"></a>
### AM_changeWindowLoc

```ml
function AM_changeWindowLoc()
```

Applies manual pan increments when follow mode is off and clamps the viewport to level bounds.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/am_map.ml#L549)

<a id="function-function-am-changewindowscale-function-am-changewindowscale-src-am-map-ml-30037877"></a>
### AM_changeWindowScale

```ml
function AM_changeWindowScale()
```

Applies the pending zoom multiplier, clamps it to level limits, derives its inverse, and recenters the viewport.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/am_map.ml#L723)

<a id="function-function-am-clearfb-function-am-clearfb-src-am-map-ml-237434137"></a>
### AM_clearFB

```ml
function AM_clearFB()
```

Fills the clipped automap viewport in the logical framebuffer with its background palette index.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/am_map.ml#L774)

<a id="constant-constant-am-clearmarkkey-const-am-clearmarkkey-99-src-am-map-ml-1218929644"></a>
### AM_CLEARMARKKEY

```ml
const AM_CLEARMARKKEY = 99
```

Defines the input key code for am clearmarkkey.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/am_map.ml#L112)

<a id="function-function-am-clearmarks-function-am-clearmarks-src-am-map-ml-1593372081"></a>
### AM_clearMarks

```ml
function AM_clearMarks()
```

Replaces every mark slot with the unused sentinel and restarts insertion at slot zero.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/am_map.ml#L651)

<a id="function-function-am-clipmline-function-am-clipmline-ml-fl-src-am-map-ml-1038252760"></a>
### AM_clipMline

```ml
function AM_clipMline(ml, fl)
```

Computes mline values for the automap.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `ml` | `dynamic` | — | Ml value supplied to `AM_clipMline`. |
| `fl` | `dynamic` | — | Fl value supplied to `AM_clipMline`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/am_map.ml#L795)

<a id="function-function-am-dofollowplayer-function-am-dofollowplayer-src-am-map-ml-33969829"></a>
### AM_doFollowPlayer

```ml
function AM_doFollowPlayer()
```

Recenters the map only when the tracked player position changes and remembers that position for the next frame.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/am_map.ml#L735)

<a id="function-function-am-drawcrosshair-function-am-drawcrosshair-color-src-am-map-ml-566215142"></a>
### AM_drawCrosshair

```ml
function AM_drawCrosshair(color)
```

Draws the single-pixel cursor at the center of the automap window.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `color` | `dynamic` | — | Doom palette index used for drawing. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/am_map.ml#L994)

<a id="function-function-am-drawer-function-am-drawer-src-am-map-ml-1458462425"></a>
### AM_Drawer

```ml
function AM_Drawer()
```

Renders one complete automap frame in layer order, including geometry, actors, marks, and cursor.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/am_map.ml#L1108)

<a id="function-function-am-drawfline-function-am-drawfline-fl-color-src-am-map-ml-843340756"></a>
### AM_drawFline

```ml
function AM_drawFline(fl, color)
```

Clips and rasterizes a framebuffer-space line with integer stepping.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `fl` | `dynamic` | — | Fl value supplied to `AM_drawFline`. |
| `color` | `dynamic` | — | Doom palette index used for drawing. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/am_map.ml#L816)

<a id="function-function-am-drawgrid-function-am-drawgrid-color-src-am-map-ml-89985676"></a>
### AM_drawGrid

```ml
function AM_drawGrid(color)
```

Draws map-aligned grid lines across the visible automap extent when the grid option is enabled.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `color` | `dynamic` | — | Doom palette index used for drawing. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/am_map.ml#L859)

<a id="function-function-am-drawlinecharacter-function-am-drawlinecharacter-lineset-count-scale-angle-color-x-y-src-am-map-ml-640930311"></a>
### AM_drawLineCharacter

```ml
function AM_drawLineCharacter(lineset, count, scale, angle, color, x, y)
```

Transforms and draws a vector glyph at a map position, applying scale and rotation to each source segment.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `lineset` | `dynamic` | — | Lineset value supplied to `AM_drawLineCharacter`. |
| `count` | `dynamic` | — | Number of elements or iterations to process. |
| `scale` | `dynamic` | — | Scale value supplied to `AM_drawLineCharacter`. |
| `angle` | `dynamic` | — | Doom binary-angle measurement. |
| `color` | `dynamic` | — | Doom palette index used for drawing. |
| `x` | `dynamic` | — | Horizontal map- or screen-space coordinate. |
| `y` | `dynamic` | — | Vertical map- or screen-space coordinate. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/am_map.ml#L933)

<a id="function-function-am-drawmarks-function-am-drawmarks-src-am-map-ml-618684613"></a>
### AM_drawMarks

```ml
function AM_drawMarks()
```

Projects user mark positions and labels them with numbered patch glyphs.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/am_map.ml#L978)

<a id="function-function-am-drawmline-function-am-drawmline-ml-color-src-am-map-ml-649283323"></a>
### AM_drawMline

```ml
function AM_drawMline(ml, color)
```

Projects a map-space line into the automap window and rasterizes the visible segment.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `ml` | `dynamic` | — | Ml value supplied to `AM_drawMline`. |
| `color` | `dynamic` | — | Doom palette index used for drawing. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/am_map.ml#L850)

<a id="function-function-am-drawplayers-function-am-drawplayers-src-am-map-ml-1340983441"></a>
### AM_drawPlayers

```ml
function AM_drawPlayers()
```

Draws the local or network player arrow glyphs at their interpolated positions and facing angles.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/am_map.ml#L951)

<a id="function-function-am-drawthings-function-am-drawthings-color-radius-src-am-map-ml-1881583208"></a>
### AM_drawThings

```ml
function AM_drawThings(color, radius)
```

Draws cheat-visible map objects as scaled vector triangles around their world positions.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `color` | `dynamic` | — | Doom palette index used for drawing. |
| `radius` | `dynamic` | — | Radius value supplied to `AM_drawThings`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/am_map.ml#L971)

<a id="function-function-am-drawwalls-function-am-drawwalls-src-am-map-ml-959674961"></a>
### AM_drawWalls

```ml
function AM_drawWalls()
```

Classifies discovered map lines by geometry and special type, then draws them with the corresponding automap colors.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/am_map.ml#L882)

<a id="constant-constant-am-endkey-const-am-endkey-key-tab-src-am-map-ml-744379459"></a>
### AM_ENDKEY

```ml
const AM_ENDKEY = KEY_TAB
```

Defines the input key code for am endkey.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/am_map.ml#L102)

<a id="function-function-am-findminmaxboundaries-function-am-findminmaxboundaries-src-am-map-ml-1319293921"></a>
### AM_findMinMaxBoundaries

```ml
function AM_findMinMaxBoundaries()
```

Computes minimum maximum boundaries values for the automap.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/am_map.ml#L501)

<a id="constant-constant-am-followkey-const-am-followkey-102-src-am-map-ml-1612102529"></a>
### AM_FOLLOWKEY

```ml
const AM_FOLLOWKEY = 102
```

Defines the input key code for am followkey.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/am_map.ml#L106)

<a id="constant-constant-am-fracunit-const-am-fracunit-65536-src-am-map-ml-691878621"></a>
### AM_FRACUNIT

```ml
const AM_FRACUNIT = 65536
```

Defines am fracunit for the am map subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/am_map.ml#L120)

<a id="function-function-am-getislope-function-am-getislope-ml-sl-src-am-map-ml-927988067"></a>
### AM_getIslope

```ml
function AM_getIslope(ml, sl)
```

Computes both dy/dx and dx/dy for a map line, using signed sentinels for vertical and horizontal cases.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `ml` | `dynamic` | — | Ml value supplied to `AM_getIslope`. |
| `sl` | `dynamic` | — | Sl value supplied to `AM_getIslope`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/am_map.ml#L416)

<a id="constant-constant-am-gobigkey-const-am-gobigkey-48-src-am-map-ml-1568229370"></a>
### AM_GOBIGKEY

```ml
const AM_GOBIGKEY = 48
```

Defines the input key code for am gobigkey.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/am_map.ml#L104)

<a id="constant-constant-am-gridkey-const-am-gridkey-103-src-am-map-ml-1055027316"></a>
### AM_GRIDKEY

```ml
const AM_GRIDKEY = 103
```

Defines the input key code for am gridkey.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/am_map.ml#L108)

<a id="function-function-am-initvariables-function-am-initvariables-src-am-map-ml-1580855553"></a>
### AM_initVariables

```ml
function AM_initVariables()
```

Activates the automap, resets frame-local counters and pan state, selects the console player, and centers the viewport.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/am_map.ml#L572)

<a id="function-function-am-levelinit-function-am-levelinit-src-am-map-ml-1984030733"></a>
### AM_LevelInit

```ml
function AM_LevelInit()
```

Resets the framebuffer viewport and initial zoom, derives level map bounds, and clears the level-start flag.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/am_map.ml#L664)

<a id="function-function-am-loadpics-function-am-loadpics-src-am-map-ml-2118969033"></a>
### AM_loadPics

```ml
function AM_loadPics()
```

Resolves and pins the ten AMMNUM digit patches used to label player map marks.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/am_map.ml#L630)

<a id="constant-constant-am-markkey-const-am-markkey-109-src-am-map-ml-1773181348"></a>
### AM_MARKKEY

```ml
const AM_MARKKEY = 109
```

Defines the input key code for am markkey.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/am_map.ml#L110)

<a id="constant-constant-am-maxint-const-am-maxint-2147483647-src-am-map-ml-1625561150"></a>
### AM_MAXINT

```ml
const AM_MAXINT = 2147483647
```

Defines the maximum am maxint accepted by the am map subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/am_map.ml#L128)

<a id="function-function-am-maxoutwindowscale-function-am-maxoutwindowscale-src-am-map-ml-160827861"></a>
### AM_maxOutWindowScale

```ml
function AM_maxOutWindowScale()
```

Clamps zoom-in to the configured maximum map-to-frame scale.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/am_map.ml#L712)

<a id="function-function-am-minoutwindowscale-function-am-minoutwindowscale-src-am-map-ml-877490805"></a>
### AM_minOutWindowScale

```ml
function AM_minOutWindowScale()
```

Clamps zoom-out at the scale where the complete level bounding box fits in the automap window.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/am_map.ml#L702)

<a id="constant-constant-am-msgentered-const-am-msgentered-am-msgheader-101-8-src-am-map-ml-828384347"></a>
### AM_MSGENTERED

```ml
const AM_MSGENTERED = AM_MSGHEADER | 101 << 8
```

Defines am msgentered for the am map subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/am_map.ml#L36)

<a id="constant-constant-am-msgexited-const-am-msgexited-am-msgheader-120-8-src-am-map-ml-1328190004"></a>
### AM_MSGEXITED

```ml
const AM_MSGEXITED = AM_MSGHEADER | 120 << 8
```

Defines am msgexited for the am map subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/am_map.ml#L38)

<a id="constant-constant-am-msgheader-const-am-msgheader-97-24-109-16-src-am-map-ml-2074174138"></a>
### AM_MSGHEADER

```ml
const AM_MSGHEADER = 97 << 24 + 109 << 16
```

Defines am msgheader for the am map subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/am_map.ml#L34)

<a id="constant-constant-am-nummarkpoints-const-am-nummarkpoints-10-src-am-map-ml-1881904707"></a>
### AM_NUMMARKPOINTS

```ml
const AM_NUMMARKPOINTS = 10
```

Defines the am nummarkpoints count used by the am map subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/am_map.ml#L115)

<a id="constant-constant-am-pandownkey-const-am-pandownkey-key-downarrow-src-am-map-ml-790619261"></a>
### AM_PANDOWNKEY

```ml
const AM_PANDOWNKEY = KEY_DOWNARROW
```

Defines the input key code for am pandownkey.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/am_map.ml#L88)

<a id="constant-constant-am-panleftkey-const-am-panleftkey-key-leftarrow-src-am-map-ml-1425843778"></a>
### AM_PANLEFTKEY

```ml
const AM_PANLEFTKEY = KEY_LEFTARROW
```

Defines the input key code for am panleftkey.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/am_map.ml#L94)

<a id="constant-constant-am-panrightkey-const-am-panrightkey-key-rightarrow-src-am-map-ml-77579077"></a>
### AM_PANRIGHTKEY

```ml
const AM_PANRIGHTKEY = KEY_RIGHTARROW
```

Defines the input key code for am panrightkey.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/am_map.ml#L92)

<a id="constant-constant-am-panupkey-const-am-panupkey-key-uparrow-src-am-map-ml-7028162"></a>
### AM_PANUPKEY

```ml
const AM_PANUPKEY = KEY_UPARROW
```

Defines the input key code for am panupkey.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/am_map.ml#L90)

<a id="function-function-am-responder-function-am-responder-ev-src-am-map-ml-311245636"></a>
### AM_Responder

```ml
function AM_Responder(ev)
```

Consumes automap key events, toggling modes and updating pan, zoom, follow, grid, and mark state.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `ev` | `dynamic` | — | Input event to process. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/am_map.ml#L1006)

<a id="function-function-am-restorescaleandloc-function-am-restorescaleandloc-src-am-map-ml-1499514873"></a>
### AM_restoreScaleAndLoc

```ml
function AM_restoreScaleAndLoc()
```

Restores the saved viewport, repairs invalid dimensions from the active zoom, and refreshes its far edges.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/am_map.ml#L463)

<a id="function-function-am-rotate-function-am-rotate-x-y-a-src-am-map-ml-601884461"></a>
### AM_rotate

```ml
function AM_rotate(x, y, a)
```

Rotates a map-space vector by a Doom binary angle using the fine sine/cosine tables.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `x` | `dynamic` | — | Horizontal map- or screen-space coordinate. |
| `y` | `dynamic` | — | Vertical map- or screen-space coordinate. |
| `a` | `dynamic` | — | First input operand. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/am_map.ml#L915)

<a id="function-function-am-savescaleandloc-function-am-savescaleandloc-src-am-map-ml-338263233"></a>
### AM_saveScaleAndLoc

```ml
function AM_saveScaleAndLoc()
```

Snapshots the current map viewport so big-map mode can later restore the prior zoom and location.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/am_map.ml#L451)

<a id="function-function-am-start-function-am-start-src-am-map-ml-1671233489"></a>
### AM_Start

```ml
function AM_Start()
```

Activates the automap once, prepares level/view state and mark graphics, then notifies the status bar.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/am_map.ml#L685)

<a id="constant-constant-am-startkey-const-am-startkey-key-tab-src-am-map-ml-1201103071"></a>
### AM_STARTKEY

```ml
const AM_STARTKEY = KEY_TAB
```

Defines the input key code for am startkey.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/am_map.ml#L100)

<a id="function-function-am-stop-function-am-stop-src-am-map-ml-1533456511"></a>
### AM_Stop

```ml
function AM_Stop()
```

Releases mark graphics, restores normal view rendering, and notifies the status bar that the automap closed.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/am_map.ml#L1122)

<a id="function-function-am-ticker-function-am-ticker-src-am-map-ml-116236767"></a>
### AM_Ticker

```ml
function AM_Ticker()
```

Applies held pan and zoom increments once per game tic while the automap is active.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/am_map.ml#L1090)

<a id="function-function-am-unloadpics-function-am-unloadpics-src-am-map-ml-735063475"></a>
### AM_unloadPics

```ml
function AM_unloadPics()
```

Drops automap mark-patch references when leaving the map display.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/am_map.ml#L645)

<a id="function-function-am-updatelightlev-function-am-updatelightlev-src-am-map-ml-563355083"></a>
### AM_updateLightLev

```ml
function AM_updateLightLev()
```

Increments the automap pulse counter used to vary wall brightness over successive frames.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/am_map.ml#L752)

<a id="constant-constant-am-zoominkey-const-am-zoominkey-61-src-am-map-ml-405811745"></a>
### AM_ZOOMINKEY

```ml
const AM_ZOOMINKEY = 61
```

Defines the input key code for am zoominkey.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/am_map.ml#L96)

<a id="constant-constant-am-zoomoutkey-const-am-zoomoutkey-45-src-am-map-ml-141240749"></a>
### AM_ZOOMOUTKEY

```ml
const AM_ZOOMOUTKEY = 45
```

Defines the input key code for am zoomoutkey.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/am_map.ml#L98)

<a id="global-global-amclock-amclock-src-am-map-ml-1522551227"></a>
### amclock

```ml
amclock
```

Tracks the mutable amclock value used by the am map subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/am_map.ml#L333)

<a id="global-global-automapactive-automapactive-src-am-map-ml-414331487"></a>
### automapactive

```ml
automapactive
```

Tracks whether automapactive is active in the am map subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/am_map.ml#L313)

<a id="constant-constant-background-const-background-black-src-am-map-ml-908663549"></a>
### BACKGROUND

```ml
const BACKGROUND = BLACK
```

Defines background for the am map subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/am_map.ml#L66)

<a id="constant-constant-black-const-black-0-src-am-map-ml-159527420"></a>
### BLACK

```ml
const BLACK = 0
```

Defines the Doom palette selection for black.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/am_map.ml#L61)

<a id="constant-constant-brownrange-const-brownrange-16-src-am-map-ml-461072905"></a>
### BROWNRANGE

```ml
const BROWNRANGE = 16
```

Defines brownrange for the am map subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/am_map.ml#L55)

<a id="constant-constant-browns-const-browns-4-16-src-am-map-ml-1417876691"></a>
### BROWNS

```ml
const BROWNS = 4 * 16
```

Defines the Doom palette selection for browns.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/am_map.ml#L53)

<a id="constant-constant-cdwallcolors-const-cdwallcolors-yellows-src-am-map-ml-743184041"></a>
### CDWALLCOLORS

```ml
const CDWALLCOLORS = YELLOWS
```

Defines the Doom palette selection for cdwallcolors.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/am_map.ml#L76)

<a id="global-global-cheat-amap-cheat-amap-src-am-map-ml-65072929"></a>
### cheat_amap

```ml
cheat_amap
```

Tracks the mutable cheat amap value used by the am map subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/am_map.ml#L408)

<a id="global-global-cheat-amap-seq-cheat-amap-seq-src-am-map-ml-1851055661"></a>
### cheat_amap_seq

```ml
cheat_amap_seq
```

Tracks the mutable cheat amap seq value used by the am map subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/am_map.ml#L406)

<a id="global-global-cheating-cheating-src-am-map-ml-195279429"></a>
### cheating

```ml
cheating
```

Tracks the mutable cheating value used by the am map subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/am_map.ml#L306)

<a id="global-global-f-h-f-h-src-am-map-ml-2116252047"></a>
### f_h

```ml
f_h
```

Tracks the mutable f h value used by the am map subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/am_map.ml#L326)

<a id="global-global-f-oldloc-f-oldloc-src-am-map-ml-1424831275"></a>
### f_oldloc

```ml
f_oldloc
```

Tracks the mutable f oldloc value used by the am map subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/am_map.ml#L386)

<a id="constant-constant-f-paninc-const-f-paninc-4-src-am-map-ml-1029704462"></a>
### F_PANINC

```ml
const F_PANINC = 4
```

Defines f paninc for the am map subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/am_map.ml#L122)

<a id="global-global-f-w-f-w-src-am-map-ml-1771181015"></a>
### f_w

```ml
f_w
```

Tracks the mutable f w value used by the am map subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/am_map.ml#L324)

<a id="global-global-f-x-f-x-src-am-map-ml-602610223"></a>
### f_x

```ml
f_x
```

Tracks the mutable f x value used by the am map subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/am_map.ml#L320)

<a id="global-global-f-y-f-y-src-am-map-ml-933594099"></a>
### f_y

```ml
f_y
```

Tracks the mutable f y value used by the am map subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/am_map.ml#L322)

<a id="constant-constant-fb-const-fb-0-src-am-map-ml-1716137782"></a>
### FB

```ml
const FB = 0
```

Defines fb for the am map subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/am_map.ml#L85)

<a id="global-global-fb-fb-src-am-map-ml-1528844943"></a>
### fb

```ml
fb
```

Holds the optional fb resource used by the am map subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/am_map.ml#L331)

<a id="constant-constant-fdwallcolors-const-fdwallcolors-browns-src-am-map-ml-1421423909"></a>
### FDWALLCOLORS

```ml
const FDWALLCOLORS = BROWNS
```

Defines the Doom palette selection for fdwallcolors.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/am_map.ml#L74)

<a id="global-global-finit-height-finit-height-src-am-map-ml-2074324979"></a>
### finit_height

```ml
finit_height
```

Tracks the mutable finit height value used by the am map subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/am_map.ml#L317)

<a id="global-global-finit-width-finit-width-src-am-map-ml-1535642371"></a>
### finit_width

```ml
finit_width
```

Tracks the mutable finit width value used by the am map subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/am_map.ml#L315)

- [fline_t](Type-fline-t-727001536.md) — struct
<a id="global-global-followplayer-followplayer-src-am-map-ml-160534955"></a>
### followplayer

```ml
followplayer
```

Tracks the mutable followplayer value used by the am map subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/am_map.ml#L403)

- [fpoint_t](Type-fpoint-t-823072670.md) — struct
<a id="global-global-ftom-zoommul-ftom-zoommul-src-am-map-ml-100883"></a>
### ftom_zoommul

```ml
ftom_zoommul
```

Tracks the mutable ftom zoommul value used by the am map subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/am_map.ml#L340)

<a id="constant-constant-grays-const-grays-6-16-src-am-map-ml-2126338041"></a>
### GRAYS

```ml
const GRAYS = 6 * 16
```

Defines the Doom palette selection for grays.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/am_map.ml#L49)

<a id="constant-constant-graysrange-const-graysrange-16-src-am-map-ml-1022990593"></a>
### GRAYSRANGE

```ml
const GRAYSRANGE = 16
```

Defines graysrange for the am map subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/am_map.ml#L51)

<a id="constant-constant-greenrange-const-greenrange-16-src-am-map-ml-1353130147"></a>
### GREENRANGE

```ml
const GREENRANGE = 16
```

Defines greenrange for the am map subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/am_map.ml#L47)

<a id="constant-constant-greens-const-greens-7-16-src-am-map-ml-1815512546"></a>
### GREENS

```ml
const GREENS = 7 * 16
```

Defines the Doom palette selection for greens.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/am_map.ml#L45)

<a id="global-global-grid-grid-src-am-map-ml-543841991"></a>
### grid

```ml
grid
```

Tracks the mutable grid value used by the am map subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/am_map.ml#L308)

<a id="constant-constant-gridcolors-const-gridcolors-grays-graysrange-1-src-am-map-ml-777132563"></a>
### GRIDCOLORS

```ml
const GRIDCOLORS = GRAYS + GRAYSRANGE >> 1
```

Defines the Doom palette selection for gridcolors.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/am_map.ml#L80)

<a id="constant-constant-initscalemtof-const-initscalemtof-13107-src-am-map-ml-264827254"></a>
### INITSCALEMTOF

```ml
const INITSCALEMTOF = 13107
```

Defines initscalemtof for the am map subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/am_map.ml#L118)

- [islope_t](Type-islope-t-894109040.md) — struct
<a id="global-global-leveljuststarted-leveljuststarted-src-am-map-ml-224144565"></a>
### leveljuststarted

```ml
leveljuststarted
```

Tracks the mutable leveljuststarted value used by the am map subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/am_map.ml#L310)

<a id="global-global-lightlev-lightlev-src-am-map-ml-1936710377"></a>
### lightlev

```ml
lightlev
```

Tracks the mutable lightlev value used by the am map subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/am_map.ml#L329)

<a id="global-global-m-h-m-h-src-am-map-ml-519198399"></a>
### m_h

```ml
m_h
```

Tracks the mutable m h value used by the am map subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/am_map.ml#L353)

<a id="global-global-m-paninc-m-paninc-src-am-map-ml-189596757"></a>
### m_paninc

```ml
m_paninc
```

Tracks the mutable m paninc value used by the am map subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/am_map.ml#L336)

<a id="global-global-m-w-m-w-src-am-map-ml-500699575"></a>
### m_w

```ml
m_w
```

Tracks the mutable m w value used by the am map subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/am_map.ml#L351)

<a id="global-global-m-x-m-x-src-am-map-ml-817548575"></a>
### m_x

```ml
m_x
```

Tracks the mutable m x value used by the am map subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/am_map.ml#L343)

<a id="global-global-m-x2-m-x2-src-am-map-ml-1750811827"></a>
### m_x2

```ml
m_x2
```

Tracks the mutable m x2 value used by the am map subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/am_map.ml#L347)

<a id="global-global-m-y-m-y-src-am-map-ml-340568019"></a>
### m_y

```ml
m_y
```

Tracks the mutable m y value used by the am map subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/am_map.ml#L345)

<a id="global-global-m-y2-m-y2-src-am-map-ml-287733269"></a>
### m_y2

```ml
m_y2
```

Tracks the mutable m y2 value used by the am map subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/am_map.ml#L349)

<a id="constant-constant-m-zoomin-const-m-zoomin-66846-src-am-map-ml-1755307108"></a>
### M_ZOOMIN

```ml
const M_ZOOMIN = 66846
```

Defines m zoomin for the am map subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/am_map.ml#L124)

<a id="constant-constant-m-zoomout-const-m-zoomout-64250-src-am-map-ml-396490793"></a>
### M_ZOOMOUT

```ml
const M_ZOOMOUT = 64250
```

Defines m zoomout for the am map subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/am_map.ml#L126)

<a id="global-global-marknums-marknums-src-am-map-ml-761822055"></a>
### marknums

```ml
marknums
```

Stores the marknums collection used by the am map subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/am_map.ml#L397)

<a id="global-global-markpointnum-markpointnum-src-am-map-ml-365387285"></a>
### markpointnum

```ml
markpointnum
```

Tracks the mutable markpointnum value used by the am map subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/am_map.ml#L401)

<a id="global-global-markpoints-markpoints-src-am-map-ml-356336403"></a>
### markpoints

```ml
markpoints
```

Stores the markpoints collection used by the am map subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/am_map.ml#L399)

<a id="global-global-max-h-max-h-src-am-map-ml-1949195419"></a>
### max_h

```ml
max_h
```

Tracks the mutable max h value used by the am map subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/am_map.ml#L366)

<a id="global-global-max-scale-mtof-max-scale-mtof-src-am-map-ml-2097808039"></a>
### max_scale_mtof

```ml
max_scale_mtof
```

Tracks the mutable max scale mtof value used by the am map subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/am_map.ml#L375)

<a id="global-global-max-w-max-w-src-am-map-ml-2114049851"></a>
### max_w

```ml
max_w
```

Tracks the mutable max w value used by the am map subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/am_map.ml#L364)

<a id="global-global-max-x-max-x-src-am-map-ml-1798139451"></a>
### max_x

```ml
max_x
```

Tracks the mutable max x value used by the am map subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/am_map.ml#L360)

<a id="global-global-max-y-max-y-src-am-map-ml-1995913915"></a>
### max_y

```ml
max_y
```

Tracks the mutable max y value used by the am map subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/am_map.ml#L362)

<a id="global-global-min-h-min-h-src-am-map-ml-1024920131"></a>
### min_h

```ml
min_h
```

Tracks the mutable min h value used by the am map subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/am_map.ml#L370)

<a id="global-global-min-scale-mtof-min-scale-mtof-src-am-map-ml-43743763"></a>
### min_scale_mtof

```ml
min_scale_mtof
```

Tracks the mutable min scale mtof value used by the am map subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/am_map.ml#L373)

<a id="global-global-min-w-min-w-src-am-map-ml-1231185587"></a>
### min_w

```ml
min_w
```

Tracks the mutable min w value used by the am map subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/am_map.ml#L368)

<a id="global-global-min-x-min-x-src-am-map-ml-1264457763"></a>
### min_x

```ml
min_x
```

Tracks the mutable min x value used by the am map subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/am_map.ml#L356)

<a id="global-global-min-y-min-y-src-am-map-ml-2004295387"></a>
### min_y

```ml
min_y
```

Tracks the mutable min y value used by the am map subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/am_map.ml#L358)

- [mline_t](Type-mline-t-251127433.md) — struct
- [mpoint_t](Type-mpoint-t-842671733.md) — struct
<a id="global-global-mtof-zoommul-mtof-zoommul-src-am-map-ml-74755511"></a>
### mtof_zoommul

```ml
mtof_zoommul
```

Tracks the mutable mtof zoommul value used by the am map subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/am_map.ml#L338)

<a id="global-global-old-m-h-old-m-h-src-am-map-ml-916776715"></a>
### old_m_h

```ml
old_m_h
```

Tracks the mutable old m h value used by the am map subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/am_map.ml#L380)

<a id="global-global-old-m-w-old-m-w-src-am-map-ml-1958549151"></a>
### old_m_w

```ml
old_m_w
```

Tracks the mutable old m w value used by the am map subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/am_map.ml#L378)

<a id="global-global-old-m-x-old-m-x-src-am-map-ml-403334603"></a>
### old_m_x

```ml
old_m_x
```

Tracks the mutable old m x value used by the am map subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/am_map.ml#L382)

<a id="global-global-old-m-y-old-m-y-src-am-map-ml-623370127"></a>
### old_m_y

```ml
old_m_y
```

Tracks the mutable old m y value used by the am map subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/am_map.ml#L384)

<a id="global-global-plr-plr-src-am-map-ml-1984065075"></a>
### plr

```ml
plr
```

Holds the optional plr resource used by the am map subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/am_map.ml#L394)

<a id="constant-constant-redrange-const-redrange-16-src-am-map-ml-1134784695"></a>
### REDRANGE

```ml
const REDRANGE = 16
```

Defines redrange for the am map subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/am_map.ml#L43)

<a id="constant-constant-reds-const-reds-256-5-16-src-am-map-ml-407772346"></a>
### REDS

```ml
const REDS = 256 - 5 * 16
```

Defines the Doom palette selection for reds.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/am_map.ml#L41)

<a id="global-global-scale-ftom-scale-ftom-src-am-map-ml-1933983633"></a>
### scale_ftom

```ml
scale_ftom
```

Tracks the mutable scale ftom value used by the am map subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/am_map.ml#L391)

<a id="global-global-scale-mtof-scale-mtof-src-am-map-ml-1086102945"></a>
### scale_mtof

```ml
scale_mtof
```

Tracks the mutable scale mtof value used by the am map subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/am_map.ml#L389)

<a id="global-global-stopped-stopped-src-am-map-ml-234628787"></a>
### stopped

```ml
stopped
```

Tracks whether stopped is active in the am map subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/am_map.ml#L411)

<a id="constant-constant-thingcolors-const-thingcolors-greens-src-am-map-ml-1983410262"></a>
### THINGCOLORS

```ml
const THINGCOLORS = GREENS
```

Defines the Doom palette selection for thingcolors.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/am_map.ml#L78)

<a id="constant-constant-tswallcolors-const-tswallcolors-grays-src-am-map-ml-1737085016"></a>
### TSWALLCOLORS

```ml
const TSWALLCOLORS = GRAYS
```

Defines the Doom palette selection for tswallcolors.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/am_map.ml#L72)

<a id="constant-constant-wallcolors-const-wallcolors-reds-src-am-map-ml-2075771672"></a>
### WALLCOLORS

```ml
const WALLCOLORS = REDS
```

Defines the Doom palette selection for wallcolors.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/am_map.ml#L70)

<a id="constant-constant-white-const-white-256-47-src-am-map-ml-2039342485"></a>
### WHITE

```ml
const WHITE = 256 - 47
```

Defines the Doom palette selection for white.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/am_map.ml#L63)

<a id="constant-constant-xhaircolors-const-xhaircolors-grays-src-am-map-ml-1452505004"></a>
### XHAIRCOLORS

```ml
const XHAIRCOLORS = GRAYS
```

Defines the Doom palette selection for xhaircolors.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/am_map.ml#L82)

<a id="constant-constant-yellowrange-const-yellowrange-1-src-am-map-ml-1675800807"></a>
### YELLOWRANGE

```ml
const YELLOWRANGE = 1
```

Defines yellowrange for the am map subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/am_map.ml#L59)

<a id="constant-constant-yellows-const-yellows-256-32-7-src-am-map-ml-66815397"></a>
### YELLOWS

```ml
const YELLOWS = 256 - 32 + 7
```

Defines the Doom palette selection for yellows.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/am_map.ml#L57)

<a id="constant-constant-yourcolors-const-yourcolors-white-src-am-map-ml-717080473"></a>
### YOURCOLORS

```ml
const YOURCOLORS = WHITE
```

Defines the Doom palette selection for yourcolors.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/am_map.ml#L68)
