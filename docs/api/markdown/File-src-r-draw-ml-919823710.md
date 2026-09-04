# `src/r_draw.ml`

[Home](README.md) · [Files](Files.md)

Rasterizes software wall columns, spans, fuzz, translated sprites, and depth-tested pixels into the active view buffer.

Package: [`(global)`](Package-global-1952375359.md)

Reachable from entry: **yes**

## Imports

- `doomdef.ml` → [src/doomdef.ml](File-src-doomdef-ml-460406769.md)
- `doomstat.ml` → [src/doomstat.ml](File-src-doomstat-ml-1652708088.md)
- `i_gl.ml` → [src/i_gl.ml](File-src-i-gl-ml-2113703076.md)
- `i_system.ml` → [src/i_system.ml](File-src-i-system-ml-1632920966.md)
- `r_hires.ml` → [src/r_hires.ml](File-src-r-hires-ml-694005807.md)
- `r_local.ml` → [src/r_local.ml](File-src-r-local-ml-797040731.md)
- `std/math.ml` → `../MiniLangCompilerOptimization/MiniLangCompilerPy/std/math.ml` — external dependency
- `v_video.ml` → [src/v_video.ml](File-src-v-video-ml-592999939.md)
- `w_wad.ml` → [src/w_wad.ml](File-src-w-wad-ml-893006035.md)
- `z_zone.ml` → [src/z_zone.ml](File-src-z-zone-ml-1788911354.md)

## Declarations

<a id="function-function-rd-centery-inline-function-rd-centery-src-r-draw-ml-1708862922"></a>
### _RD_CenterY

```ml
inline function _RD_CenterY()
```

Returns the configured projection center or the logical screen midpoint when view setup has not supplied one.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_draw.ml#L204)

<a id="function-function-rd-depthpass-inline-function-rd-depthpass-di-src-r-draw-ml-1003475191"></a>
### _RD_DepthPass

```ml
inline function _RD_DepthPass(di)
```

Always accepts a pixel because visibility is already resolved by BSP and sprite draw order in the software renderer.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `di` | `dynamic` | — | Di value supplied to `_RD_DepthPass`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_draw.ml#L176)

<a id="function-function-rd-depthstore-inline-function-rd-depthstore-di-src-r-draw-ml-583977341"></a>
### _RD_DepthStore

```ml
inline function _RD_DepthStore(di)
```

Retains the depth-write call site for alternate backends while intentionally storing nothing in the painter-ordered path.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `di` | `dynamic` | — | Di value supplied to `_RD_DepthStore`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_draw.ml#L185)

<a id="function-function-rd-drawpatchifexists-inline-function-rd-drawpatchifexists-x-y-scrn-name-src-r-draw-ml-175559980"></a>
### _RD_DrawPatchIfExists

```ml
inline function _RD_DrawPatchIfExists(x, y, scrn, name)
```

Resolves and draws an optional named border patch without failing when an IWAD omits it.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `x` | `dynamic` | — | Horizontal map- or screen-space coordinate. |
| `y` | `dynamic` | — | Vertical map- or screen-space coordinate. |
| `scrn` | `dynamic` | — | Scrn value supplied to `_RD_DrawPatchIfExists`. |
| `name` | `dynamic` | — | Resource or object name to resolve. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_draw.ml#L274)

<a id="function-function-rd-flatsamplecoord-inline-function-rd-flatsamplecoord-frac-size-src-r-draw-ml-1572625725"></a>
### _RD_FlatSampleCoord

```ml
inline function _RD_FlatSampleCoord(frac, size)
```

Maps Doom's fixed 64x64 flat coordinate into a variable-size source image.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `frac` | `dynamic` | — | Frac value supplied to `_RD_FlatSampleCoord`. |
| `size` | `dynamic` | — | Requested size in bytes or elements. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_draw.ml#L249)

<a id="function-function-rd-idiv-inline-function-rd-idiv-a-b-src-r-draw-ml-3584833"></a>
### _RD_IDiv

```ml
inline function _RD_IDiv(a, b)
```

Returns a signed quotient truncated toward zero, or zero for invalid operands and a zero divisor in `_RD_IDiv`

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `a` | `dynamic` | — | First input operand. |
| `b` | `dynamic` | — | Second input operand. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_draw.ml#L194)

<a id="function-function-rd-ispow2-inline-function-rd-ispow2-n-src-r-draw-ml-863221058"></a>
### _RD_IsPow2

```ml
inline function _RD_IsPow2(n)
```

Tests whether a positive texture dimension permits bit-mask wrapping.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `n` | `dynamic` | — | Number of values to process. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_draw.ml#L263)

<a id="global-global-rd-prof-col-calls-rd-prof-col-calls-src-r-draw-ml-778252769"></a>
### _rd_prof_col_calls

```ml
_rd_prof_col_calls
```

Tracks the mutable rd prof col calls value used by the r draw subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_draw.ml#L110)

<a id="global-global-rd-prof-col-pixels-rd-prof-col-pixels-src-r-draw-ml-1559133149"></a>
### _rd_prof_col_pixels

```ml
_rd_prof_col_pixels
```

Tracks the mutable rd prof col pixels value used by the r draw subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_draw.ml#L113)

<a id="global-global-rd-prof-enabled-rd-prof-enabled-src-r-draw-ml-66807839"></a>
### _rd_prof_enabled

```ml
_rd_prof_enabled
```

Tracks whether rd prof enabled is active in the r draw subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_draw.ml#L122)

<a id="global-global-rd-prof-span-calls-rd-prof-span-calls-src-r-draw-ml-204862477"></a>
### _rd_prof_span_calls

```ml
_rd_prof_span_calls
```

Tracks the mutable rd prof span calls value used by the r draw subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_draw.ml#L116)

<a id="global-global-rd-prof-span-pixels-rd-prof-span-pixels-src-r-draw-ml-926894029"></a>
### _rd_prof_span_pixels

```ml
_rd_prof_span_pixels
```

Tracks the mutable rd prof span pixels value used by the r draw subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_draw.ml#L119)

<a id="function-function-rd-targetbuffer-inline-function-rd-targetbuffer-src-r-draw-ml-180896930"></a>
### _RD_TargetBuffer

```ml
inline function _RD_TargetBuffer()
```

Returns the active render target buffer.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_draw.ml#L225)

<a id="function-function-rd-targetheight-inline-function-rd-targetheight-src-r-draw-ml-546131744"></a>
### _RD_TargetHeight

```ml
inline function _RD_TargetHeight()
```

Returns the active render target height.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_draw.ml#L218)

<a id="function-function-rd-targetwidth-inline-function-rd-targetwidth-src-r-draw-ml-1525366726"></a>
### _RD_TargetWidth

```ml
inline function _RD_TargetWidth()
```

Returns the active render target width.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_draw.ml#L211)

<a id="function-function-rd-wrapindex-inline-function-rd-wrapindex-i-n-src-r-draw-ml-1386260883"></a>
### _RD_WrapIndex

```ml
inline function _RD_WrapIndex(i, n)
```

Wraps positive or negative texture indices into a validated source period.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `i` | `dynamic` | — | Zero-based iteration index. |
| `n` | `dynamic` | — | Number of values to process. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_draw.ml#L235)

<a id="global-global-columnofs-columnofs-src-r-draw-ml-2140662893"></a>
### columnofs

```ml
columnofs
```

Stores the columnofs collection used by the r draw subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_draw.ml#L87)

<a id="global-global-dc-colormap-dc-colormap-src-r-draw-ml-438591689"></a>
### dc_colormap

```ml
dc_colormap
```

Tracks the mutable dc colormap value used by the r draw subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_draw.ml#L33)

<a id="global-global-dc-iscale-dc-iscale-src-r-draw-ml-1577918725"></a>
### dc_iscale

```ml
dc_iscale
```

Tracks the mutable dc iscale value used by the r draw subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_draw.ml#L41)

<a id="global-global-dc-source-dc-source-src-r-draw-ml-794177765"></a>
### dc_source

```ml
dc_source
```

Tracks the mutable dc source value used by the r draw subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_draw.ml#L45)

<a id="global-global-dc-sourcebase-dc-sourcebase-src-r-draw-ml-686198901"></a>
### dc_sourcebase

```ml
dc_sourcebase
```

Holds the optional dc sourcebase resource used by the r draw subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_draw.ml#L48)

<a id="global-global-dc-sourceclamp-dc-sourceclamp-src-r-draw-ml-181741645"></a>
### dc_sourceclamp

```ml
dc_sourceclamp
```

Tracks whether dc sourceclamp is active in the r draw subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_draw.ml#L54)

<a id="global-global-dc-sourcelen-dc-sourcelen-src-r-draw-ml-1784119293"></a>
### dc_sourcelen

```ml
dc_sourcelen
```

Tracks the mutable dc sourcelen value used by the r draw subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_draw.ml#L52)

<a id="global-global-dc-sourceoff-dc-sourceoff-src-r-draw-ml-881961949"></a>
### dc_sourceoff

```ml
dc_sourceoff
```

Tracks the mutable dc sourceoff value used by the r draw subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_draw.ml#L50)

<a id="global-global-dc-texturemid-dc-texturemid-src-r-draw-ml-715057581"></a>
### dc_texturemid

```ml
dc_texturemid
```

Tracks the mutable dc texturemid value used by the r draw subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_draw.ml#L43)

<a id="global-global-dc-translation-dc-translation-src-r-draw-ml-242853739"></a>
### dc_translation

```ml
dc_translation
```

Tracks the mutable dc translation value used by the r draw subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_draw.ml#L82)

<a id="global-global-dc-x-dc-x-src-r-draw-ml-1482305565"></a>
### dc_x

```ml
dc_x
```

Tracks the mutable dc x value used by the r draw subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_draw.ml#L35)

<a id="global-global-dc-yh-dc-yh-src-r-draw-ml-1228792461"></a>
### dc_yh

```ml
dc_yh
```

Tracks the mutable dc yh value used by the r draw subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_draw.ml#L39)

<a id="global-global-dc-yl-dc-yl-src-r-draw-ml-756030301"></a>
### dc_yl

```ml
dc_yl
```

Tracks the mutable dc yl value used by the r draw subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_draw.ml#L37)

<a id="global-global-ds-colormap-ds-colormap-src-r-draw-ml-705523945"></a>
### ds_colormap

```ml
ds_colormap
```

Tracks the mutable ds colormap value used by the r draw subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_draw.ml#L63)

<a id="global-global-ds-source-ds-source-src-r-draw-ml-843399813"></a>
### ds_source

```ml
ds_source
```

Tracks the mutable ds source value used by the r draw subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_draw.ml#L73)

<a id="global-global-ds-source-height-ds-source-height-src-r-draw-ml-129717927"></a>
### ds_source_height

```ml
ds_source_height
```

Tracks the mutable ds source height value used by the r draw subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_draw.ml#L77)

<a id="global-global-ds-source-width-ds-source-width-src-r-draw-ml-1223147645"></a>
### ds_source_width

```ml
ds_source_width
```

Tracks the mutable ds source width value used by the r draw subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_draw.ml#L75)

<a id="global-global-ds-x1-ds-x1-src-r-draw-ml-35221481"></a>
### ds_x1

```ml
ds_x1
```

Tracks the mutable ds x1 value used by the r draw subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_draw.ml#L59)

<a id="global-global-ds-x2-ds-x2-src-r-draw-ml-1837151977"></a>
### ds_x2

```ml
ds_x2
```

Tracks the mutable ds x2 value used by the r draw subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_draw.ml#L61)

<a id="global-global-ds-xfrac-ds-xfrac-src-r-draw-ml-470136597"></a>
### ds_xfrac

```ml
ds_xfrac
```

Tracks the mutable ds xfrac value used by the r draw subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_draw.ml#L65)

<a id="global-global-ds-xstep-ds-xstep-src-r-draw-ml-135346509"></a>
### ds_xstep

```ml
ds_xstep
```

Tracks the mutable ds xstep value used by the r draw subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_draw.ml#L69)

<a id="global-global-ds-y-ds-y-src-r-draw-ml-704668503"></a>
### ds_y

```ml
ds_y
```

Tracks the mutable ds y value used by the r draw subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_draw.ml#L57)

<a id="global-global-ds-yfrac-ds-yfrac-src-r-draw-ml-785397787"></a>
### ds_yfrac

```ml
ds_yfrac
```

Tracks the mutable ds yfrac value used by the r draw subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_draw.ml#L67)

<a id="global-global-ds-ystep-ds-ystep-src-r-draw-ml-1788857895"></a>
### ds_ystep

```ml
ds_ystep
```

Tracks the mutable ds ystep value used by the r draw subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_draw.ml#L71)

<a id="global-global-fuzzoffset-fuzzoffset-src-r-draw-ml-891761933"></a>
### fuzzoffset

```ml
fuzzoffset
```

Stores the fuzzoffset collection used by the r draw subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_draw.ml#L96)

<a id="global-global-fuzzpos-fuzzpos-src-r-draw-ml-1031416857"></a>
### fuzzpos

```ml
fuzzpos
```

Tracks the mutable fuzzpos value used by the r draw subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_draw.ml#L106)

<a id="constant-constant-fuzztable-const-fuzztable-50-src-r-draw-ml-2002634609"></a>
### FUZZTABLE

```ml
const FUZZTABLE = 50
```

Defines fuzztable for the r draw subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_draw.ml#L92)

<a id="function-function-r-depthbeginsprite-function-r-depthbeginsprite-scale-src-r-draw-ml-945061931"></a>
### R_DepthBeginSprite

```ml
function R_DepthBeginSprite(scale)
```

Accepts the projected sprite scale for depth-aware renderer compatibility; painter ordering makes it a no-op here.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `scale` | `dynamic` | — | Scale value supplied to `R_DepthBeginSprite`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_draw.ml#L164)

<a id="function-function-r-depthbeginwall-function-r-depthbeginwall-scale-src-r-draw-ml-1103456663"></a>
### R_DepthBeginWall

```ml
function R_DepthBeginWall(scale)
```

Accepts the projected wall scale for depth-aware renderer compatibility; painter ordering makes it a no-op here.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `scale` | `dynamic` | — | Scale value supplied to `R_DepthBeginWall`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_draw.ml#L153)

<a id="function-function-r-depthclear-function-r-depthclear-src-r-draw-ml-1883098487"></a>
### R_DepthClear

```ml
function R_DepthClear()
```

Preserves the depth-buffer reset hook used by renderer callers; the current painter-ordered software path requires no separate buffer.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_draw.ml#L146)

<a id="function-function-r-depthendsprite-function-r-depthendsprite-src-r-draw-ml-752621639"></a>
### R_DepthEndSprite

```ml
function R_DepthEndSprite()
```

Closes the compatibility scope opened for a sprite column without changing software draw state.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_draw.ml#L169)

<a id="function-function-r-depthendwall-function-r-depthendwall-src-r-draw-ml-1006992463"></a>
### R_DepthEndWall

```ml
function R_DepthEndWall()
```

Closes the compatibility scope opened for a wall column; no state is retained by the painter-ordered path.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_draw.ml#L158)

<a id="function-function-r-drawcolumn-function-r-drawcolumn-src-r-draw-ml-1697602859"></a>
### R_DrawColumn

```ml
function R_DrawColumn()
```

Samples a vertically stepped texture column through the active colormap into one clipped high-detail screen column.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_draw.ml#L342)

<a id="function-function-r-drawcolumnlow-function-r-drawcolumnlow-src-r-draw-ml-1832234905"></a>
### R_DrawColumnLow

```ml
function R_DrawColumnLow()
```

Draws a low-detail texture column by duplicating each logical sample across two horizontal target pixels.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_draw.ml#L447)

<a id="function-function-r-drawfuzzcolumn-function-r-drawfuzzcolumn-src-r-draw-ml-1753582183"></a>
### R_DrawFuzzColumn

```ml
function R_DrawFuzzColumn()
```

Produces the spectre effect by copying neighboring framebuffer samples through the fuzz colormap while advancing the cyclic fuzz offset.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_draw.ml#L565)

<a id="function-function-r-drawfuzzcolumnlow-function-r-drawfuzzcolumnlow-src-r-draw-ml-1503867063"></a>
### R_DrawFuzzColumnLow

```ml
function R_DrawFuzzColumnLow()
```

Applies the fuzz-neighbor effect to a doubled low-detail column.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_draw.ml#L595)

<a id="function-function-r-drawprofilereset-function-r-drawprofilereset-src-r-draw-ml-1711280927"></a>
### R_DrawProfileReset

```ml
function R_DrawProfileReset()
```

Clears draw Profile Reset state before the next software drawing update.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_draw.ml#L125)

<a id="function-function-r-drawprofilesetenabled-function-r-drawprofilesetenabled-on-src-r-draw-ml-707901650"></a>
### R_DrawProfileSetEnabled

```ml
function R_DrawProfileSetEnabled(on)
```

Enables or disables software column/span counters without changing the active draw-function bindings.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `on` | `dynamic` | — | On value supplied to `R_DrawProfileSetEnabled`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_draw.ml#L139)

<a id="function-function-r-drawspan-function-r-drawspan-src-r-draw-ml-1291460371"></a>
### R_DrawSpan

```ml
function R_DrawSpan()
```

Perspective-steps texture coordinates across one horizontal floor/ceiling span and writes colormapped samples to the active target.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_draw.ml#L696)

<a id="function-function-r-drawspanlow-function-r-drawspanlow-src-r-draw-ml-643270273"></a>
### R_DrawSpanLow

```ml
function R_DrawSpanLow()
```

Draws a perspective-correct flat span with horizontally doubled samples for low-detail mode.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_draw.ml#L756)

<a id="function-function-r-drawtranslatedcolumn-function-r-drawtranslatedcolumn-src-r-draw-ml-1752608583"></a>
### R_DrawTranslatedColumn

```ml
function R_DrawTranslatedColumn()
```

Remaps each texture texel through the active player-color translation before applying the lighting colormap.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_draw.ml#L600)

<a id="function-function-r-drawtranslatedcolumnlow-function-r-drawtranslatedcolumnlow-src-r-draw-ml-1428647693"></a>
### R_DrawTranslatedColumnLow

```ml
function R_DrawTranslatedColumnLow()
```

Draws a player-color-translated column with each result duplicated for low-detail mode.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_draw.ml#L690)

<a id="function-function-r-drawviewborder-function-r-drawviewborder-src-r-draw-ml-2079482519"></a>
### R_DrawViewBorder

```ml
function R_DrawViewBorder()
```

Copies only the cached top, bottom, and side border regions around a reduced view into the foreground screen.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_draw.ml#L905)

<a id="function-function-r-fillbackscreen-function-r-fillbackscreen-src-r-draw-ml-557823155"></a>
### R_FillBackScreen

```ml
function R_FillBackScreen()
```

Tiles the game-mode border flat into the background screen and surrounds a reduced view with optional border patches.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_draw.ml#L847)

<a id="function-function-r-initbuffer-function-r-initbuffer-width-height-src-r-draw-ml-61239804"></a>
### R_InitBuffer

```ml
function R_InitBuffer(width, height)
```

Recomputes view-window offsets plus per-row and per-column destination lookup tables for the active render target size.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `width` | `dynamic` | — | Width of the target in pixels or map units. |
| `height` | `dynamic` | — | Height of the target in pixels or map units. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_draw.ml#L285)

<a id="function-function-r-inittranslationtables-function-r-inittranslationtables-src-r-draw-ml-51017837"></a>
### R_InitTranslationTables

```ml
function R_InitTranslationTables()
```

Precomputes the three Doom player-color remaps while leaving every non-green palette index unchanged.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_draw.ml#L823)

<a id="function-function-r-videoerase-function-r-videoerase-ofs-count-src-r-draw-ml-935996752"></a>
### R_VideoErase

```ml
function R_VideoErase(ofs, count)
```

Restores a clipped byte range in the foreground screen from the cached background screen.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `ofs` | `dynamic` | — | Ofs value supplied to `R_VideoErase`. |
| `count` | `dynamic` | — | Number of elements or iterations to process. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_draw.ml#L320)

<a id="constant-constant-rd-flat-period-mask-const-rd-flat-period-mask-4194303-src-r-draw-ml-1006401040"></a>
### RD_FLAT_PERIOD_MASK

```ml
const RD_FLAT_PERIOD_MASK = 4194303
```

Defines rd flat period mask for the r draw subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_draw.ml#L94)

<a id="constant-constant-sbarheight-const-sbarheight-32-src-r-draw-ml-1851186405"></a>
### SBARHEIGHT

```ml
const SBARHEIGHT = 32
```

Defines sbarheight for the r draw subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_draw.ml#L89)

<a id="global-global-translationtables-translationtables-src-r-draw-ml-1372930317"></a>
### translationtables

```ml
translationtables
```

Tracks the mutable translationtables value used by the r draw subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_draw.ml#L80)

<a id="global-global-ylookup-ylookup-src-r-draw-ml-183066661"></a>
### ylookup

```ml
ylookup
```

Stores the ylookup collection used by the r draw subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_draw.ml#L85)
