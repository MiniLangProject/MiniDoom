# `src/r_main.ml`

[Home](README.md) · [Files](Files.md)

Builds view/projection tables, derives interpolated camera state, and orchestrates software or OpenGL player-view rendering.

Package: [`(global)`](Package-global-1952375359.md)

Reachable from entry: **yes**

## Imports

- `d_net.ml` → [src/d_net.ml](File-src-d-net-ml-529296669.md)
- `d_player.ml` → [src/d_player.ml](File-src-d-player-ml-1944166105.md)
- `doomdef.ml` → [src/doomdef.ml](File-src-doomdef-ml-460406769.md)
- `doomstat.ml` → [src/doomstat.ml](File-src-doomstat-ml-1652708088.md)
- `m_argv.ml` → [src/m_argv.ml](File-src-m-argv-ml-728984635.md)
- `m_bbox.ml` → [src/m_bbox.ml](File-src-m-bbox-ml-1176525784.md)
- `r_data.ml` → [src/r_data.ml](File-src-r-data-ml-1686270288.md)
- `r_gl.ml` → [src/r_gl.ml](File-src-r-gl-ml-2087530889.md)
- `r_hires.ml` → [src/r_hires.ml](File-src-r-hires-ml-694005807.md)
- `r_local.ml` → [src/r_local.ml](File-src-r-local-ml-797040731.md)
- `r_renderer.ml` → [src/r_renderer.ml](File-src-r-renderer-ml-72894217.md)
- `r_sky.ml` → [src/r_sky.ml](File-src-r-sky-ml-918225537.md)
- `std/math.ml` → `../MiniLangCompilerOptimization/MiniLangCompilerPy/std/math.ml` — external dependency
- `std/time.ml` → `../MiniLangCompilerOptimization/MiniLangCompilerPy/std/time.ml` — external dependency

## Declarations

<a id="function-function-r-abs-inline-function-r-abs-x-src-r-main-ml-232278825"></a>
### _R_Abs

```ml
inline function _R_Abs(x)
```

Converts an arbitrary numeric value to an integer and returns its non-negative magnitude.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `x` | `dynamic` | — | Horizontal map- or screen-space coordinate. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_main.ml#L313)

<a id="function-function-r-angnorm-inline-function-r-angnorm-a-src-r-main-ml-1810144420"></a>
### _R_AngNorm

```ml
inline function _R_AngNorm(a)
```

Normalizes an angle or numeric input to Doom's unsigned 32-bit binary-angle domain.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `a` | `dynamic` | — | First input operand. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_main.ml#L363)

<a id="function-function-r-angsub-inline-function-r-angsub-a-b-src-r-main-ml-799650374"></a>
### _R_AngSub

```ml
inline function _R_AngSub(a, b)
```

Subtracts two binary angles with unsigned 32-bit wraparound.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `a` | `dynamic` | — | First input operand. |
| `b` | `dynamic` | — | Second input operand. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_main.ml#L372)

<a id="function-function-r-colormapat-inline-function-r-colormapat-level-src-r-main-ml-465629565"></a>
### _R_ColorMapAt

```ml
inline function _R_ColorMapAt(level)
```

Returns one clamped 256-entry lighting colormap, or a black fallback when COLORMAP data is missing.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `level` | `dynamic` | — | Level value supplied to `_R_ColorMapAt`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_main.ml#L410)

<a id="function-function-r-finesineat-inline-function-r-finesineat-angle-src-r-main-ml-76048170"></a>
### _R_FineSineAt

```ml
inline function _R_FineSineAt(angle)
```

Samples the wrapped fine-sine table for a binary angle, returning zero if tables are unavailable.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `angle` | `dynamic` | — | Doom binary-angle measurement. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_main.ml#L379)

<a id="function-function-r-hassignbit-inline-function-r-hassignbit-v-src-r-main-ml-1615810353"></a>
### _R_HasSignBit

```ml
inline function _R_HasSignBit(v)
```

Tests the high bit of a normalized binary angle or wrapped 32-bit delta.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `v` | `dynamic` | — | Value consumed by the operation. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_main.ml#L425)

<a id="function-function-r-idiv-inline-function-r-idiv-a-b-src-r-main-ml-1475153906"></a>
### _R_IDiv

```ml
inline function _R_IDiv(a, b)
```

Coerces numeric operands and returns their signed quotient truncated toward zero, using zero for a zero divisor.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `a` | `dynamic` | — | First input operand. |
| `b` | `dynamic` | — | Second input operand. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_main.ml#L324)

<a id="function-function-r-inittexturemapping-function-r-inittexturemapping-src-r-main-ml-1683816812"></a>
### _R_InitTextureMapping

```ml
function _R_InitTextureMapping()
```

Builds inverse screen-column/binary-angle tables from the current projection and establishes the horizontal clip angle.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_main.ml#L1339)

<a id="global-global-r-interp-cur-angle-r-interp-cur-angle-src-r-main-ml-1158157928"></a>
### _r_interp_cur_angle

```ml
_r_interp_cur_angle
```

Tracks the mutable r interp cur angle value used by the r main subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_main.ml#L178)

<a id="global-global-r-interp-cur-x-r-interp-cur-x-src-r-main-ml-1112102384"></a>
### _r_interp_cur_x

```ml
_r_interp_cur_x
```

Tracks the mutable r interp cur x value used by the r main subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_main.ml#L169)

<a id="global-global-r-interp-cur-y-r-interp-cur-y-src-r-main-ml-1765821436"></a>
### _r_interp_cur_y

```ml
_r_interp_cur_y
```

Tracks the mutable r interp cur y value used by the r main subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_main.ml#L172)

<a id="global-global-r-interp-cur-z-r-interp-cur-z-src-r-main-ml-1696613528"></a>
### _r_interp_cur_z

```ml
_r_interp_cur_z
```

Tracks the mutable r interp cur z value used by the r main subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_main.ml#L175)

<a id="global-global-r-interp-last-tic-r-interp-last-tic-src-r-main-ml-1532633512"></a>
### _r_interp_last_tic

```ml
_r_interp_last_tic
```

Tracks the mutable r interp last tic value used by the r main subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_main.ml#L154)

<a id="global-global-r-interp-player-r-interp-player-src-r-main-ml-641765968"></a>
### _r_interp_player

```ml
_r_interp_player
```

Holds the optional r interp player resource used by the r main subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_main.ml#L151)

<a id="global-global-r-interp-prev-angle-r-interp-prev-angle-src-r-main-ml-951932568"></a>
### _r_interp_prev_angle

```ml
_r_interp_prev_angle
```

Tracks the mutable r interp prev angle value used by the r main subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_main.ml#L166)

<a id="global-global-r-interp-prev-x-r-interp-prev-x-src-r-main-ml-774937734"></a>
### _r_interp_prev_x

```ml
_r_interp_prev_x
```

Tracks the mutable r interp prev x value used by the r main subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_main.ml#L157)

<a id="global-global-r-interp-prev-y-r-interp-prev-y-src-r-main-ml-1116526432"></a>
### _r_interp_prev_y

```ml
_r_interp_prev_y
```

Tracks the mutable r interp prev y value used by the r main subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_main.ml#L160)

<a id="global-global-r-interp-prev-z-r-interp-prev-z-src-r-main-ml-1927535770"></a>
### _r_interp_prev_z

```ml
_r_interp_prev_z
```

Tracks the mutable r interp prev z value used by the r main subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_main.ml#L163)

<a id="function-function-r-isseq-inline-function-r-isseq-v-src-r-main-ml-747200205"></a>
### _R_IsSeq

```ml
inline function _R_IsSeq(v)
```

Recognizes the array and list containers accepted by renderer lookup tables.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `v` | `dynamic` | — | Value consumed by the operation. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_main.ml#L355)

<a id="function-function-r-lerpangle-inline-function-r-lerpangle-a-b-frac-src-r-main-ml-1483425416"></a>
### _R_LerpAngle

```ml
inline function _R_LerpAngle(a, b, frac)
```

Interpolates along the shortest wrapped path between two 32-bit binary angles.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `a` | `dynamic` | — | First input operand. |
| `b` | `dynamic` | — | Second input operand. |
| `frac` | `dynamic` | — | Frac value supplied to `_R_LerpAngle`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_main.ml#L505)

<a id="function-function-r-lerps32-inline-function-r-lerps32-a-b-frac-src-r-main-ml-952702094"></a>
### _R_LerpS32

```ml
inline function _R_LerpS32(a, b, frac)
```

Linearly interpolates signed 32-bit coordinates and preserves signed wrap semantics at the result.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `a` | `dynamic` | — | First input operand. |
| `b` | `dynamic` | — | Second input operand. |
| `frac` | `dynamic` | — | Frac value supplied to `_R_LerpS32`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_main.ml#L492)

<a id="global-global-r-prof-bsp-ms-r-prof-bsp-ms-src-r-main-ml-615628568"></a>
### _r_prof_bsp_ms

```ml
_r_prof_bsp_ms
```

Tracks the mutable r prof bsp ms value used by the r main subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_main.ml#L141)

<a id="global-global-r-prof-clear-ms-r-prof-clear-ms-src-r-main-ml-2075123592"></a>
### _r_prof_clear_ms

```ml
_r_prof_clear_ms
```

Tracks the mutable r prof clear ms value used by the r main subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_main.ml#L138)

<a id="global-global-r-prof-enabled-r-prof-enabled-src-r-main-ml-1684185464"></a>
### _r_prof_enabled

```ml
_r_prof_enabled
```

Tracks whether r prof enabled is active in the r main subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_main.ml#L129)

<a id="global-global-r-prof-frames-r-prof-frames-src-r-main-ml-37735788"></a>
### _r_prof_frames

```ml
_r_prof_frames
```

Tracks the mutable r prof frames value used by the r main subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_main.ml#L135)

<a id="global-global-r-prof-masked-ms-r-prof-masked-ms-src-r-main-ml-749748596"></a>
### _r_prof_masked_ms

```ml
_r_prof_masked_ms
```

Tracks the mutable r prof masked ms value used by the r main subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_main.ml#L147)

<a id="global-global-r-prof-planes-ms-r-prof-planes-ms-src-r-main-ml-1722607424"></a>
### _r_prof_planes_ms

```ml
_r_prof_planes_ms
```

Tracks the mutable r prof planes ms value used by the r main subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_main.ml#L144)

<a id="global-global-r-prof-t0-r-prof-t0-src-r-main-ml-1080666376"></a>
### _r_prof_t0

```ml
_r_prof_t0
```

Tracks the mutable r prof t0 value used by the r main subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_main.ml#L132)

<a id="function-function-r-profileflushmaybe-function-r-profileflushmaybe-src-r-main-ml-222973206"></a>
### _R_ProfileFlushMaybe

```ml
function _R_ProfileFlushMaybe()
```

Once per second, prints accumulated pipeline counters and resets renderer, BSP, and draw profiling windows.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_main.ml#L199)

<a id="function-function-r-rebuildscalelight-function-r-rebuildscalelight-src-r-main-ml-762705094"></a>
### _R_RebuildScaleLight

```ml
function _R_RebuildScaleLight()
```

Recomputes scale-indexed wall colormaps for the active view width and detail shift.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_main.ml#L1009)

<a id="function-function-r-renderopenglplayerview-function-r-renderopenglplayerview-player-src-r-main-ml-1428438047"></a>
### _R_RenderOpenGLPlayerView

```ml
function _R_RenderOpenGLPlayerView(player)
```

Attempts to draw the current player view with the active OpenGL renderer.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `player` | `dynamic` | — | Player state affected by the operation. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_main.ml#L1048)

<a id="function-function-r-s32-function-r-s32-v-src-r-main-ml-1040365410"></a>
### _R_S32

```ml
function _R_S32(v)
```

Coerces a numeric value and reinterprets its low 32 bits as a signed integer.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `v` | `dynamic` | — | Value consumed by the operation. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_main.ml#L432)

<a id="function-function-r-setupframe-function-r-setupframe-player-src-r-main-ml-1582975857"></a>
### _R_SetupFrame

```ml
function _R_SetupFrame(player)
```

Derives the camera from player state, interpolates uncapped frames, selects fixed lighting, and advances frame validity counters.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `player` | `dynamic` | — | Player state affected by the operation. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_main.ml#L1194)

<a id="function-function-r-tantoangle-inline-function-r-tantoangle-num-den-src-r-main-ml-1330430034"></a>
### _R_TanToAngle

```ml
inline function _R_TanToAngle(num, den)
```

Converts a non-negative slope ratio into a clamped lookup-table binary angle.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `num` | `dynamic` | — | Index identifying the requested item. |
| `den` | `dynamic` | — | Den value supplied to `_R_TanToAngle`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_main.ml#L394)

<a id="function-function-r-timems-inline-function-r-timems-src-r-main-ml-121105675"></a>
### _R_TimeMs

```ml
inline function _R_TimeMs()
```

Returns the platform tick counter as an integer millisecond timestamp for render profiling.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_main.ml#L192)

<a id="function-function-r-tofrac-inline-function-r-tofrac-v-src-r-main-ml-2132514969"></a>
### _R_ToFrac

```ml
inline function _R_ToFrac(v)
```

Converts the render interpolation control to a scalar clamped to [0,1], defaulting invalid inputs to one.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `v` | `dynamic` | — | Value consumed by the operation. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_main.ml#L464)

<a id="function-function-r-tointor-inline-function-r-tointor-v-fallback-src-r-main-ml-1926071927"></a>
### _R_ToIntOr

```ml
inline function _R_ToIntOr(v, fallback)
```

Coerces numbers and numeric values to a truncation-toward-zero integer, returning fallback on failure.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `v` | `dynamic` | — | Value consumed by the operation. |
| `fallback` | `dynamic` | — | Value returned when the requested conversion or lookup is unavailable. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_main.ml#L337)

<a id="global-global-basecolfunc-basecolfunc-src-r-main-ml-1448268504"></a>
### basecolfunc

```ml
basecolfunc
```

Holds the optional basecolfunc resource used by the r main subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_main.ml#L108)

<a id="global-global-centerx-centerx-src-r-main-ml-869812336"></a>
### centerx

```ml
centerx
```

Tracks the mutable centerx value used by the r main subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_main.ml#L51)

<a id="global-global-centerxfrac-centerxfrac-src-r-main-ml-987155500"></a>
### centerxfrac

```ml
centerxfrac
```

Tracks the mutable centerxfrac value used by the r main subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_main.ml#L55)

<a id="global-global-centery-centery-src-r-main-ml-1253349060"></a>
### centery

```ml
centery
```

Tracks the mutable centery value used by the r main subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_main.ml#L53)

<a id="global-global-centeryfrac-centeryfrac-src-r-main-ml-445165496"></a>
### centeryfrac

```ml
centeryfrac
```

Tracks the mutable centeryfrac value used by the r main subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_main.ml#L57)

<a id="global-global-colfunc-colfunc-src-r-main-ml-1674876484"></a>
### colfunc

```ml
colfunc
```

Holds the optional colfunc resource used by the r main subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_main.ml#L106)

<a id="global-global-detailshift-detailshift-src-r-main-ml-1380400728"></a>
### detailshift

```ml
detailshift
```

Tracks the mutable detailshift value used by the r main subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_main.ml#L97)

<a id="global-global-extralight-extralight-src-r-main-ml-1672165128"></a>
### extralight

```ml
extralight
```

Tracks the mutable extralight value used by the r main subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_main.ml#L92)

<a id="constant-constant-fieldofview-const-fieldofview-2048-src-r-main-ml-1918661619"></a>
### FIELDOFVIEW

```ml
const FIELDOFVIEW = 2048
```

Defines fieldofview for the r main subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_main.ml#L117)

<a id="global-global-fixedcolormap-fixedcolormap-src-r-main-ml-1834408012"></a>
### fixedcolormap

```ml
fixedcolormap
```

Holds the optional fixedcolormap resource used by the r main subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_main.ml#L94)

<a id="global-global-framecount-framecount-src-r-main-ml-1622752912"></a>
### framecount

```ml
framecount
```

Tracks the mutable framecount value used by the r main subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_main.ml#L123)

<a id="global-global-fuzzcolfunc-fuzzcolfunc-src-r-main-ml-520504420"></a>
### fuzzcolfunc

```ml
fuzzcolfunc
```

Holds the optional fuzzcolfunc resource used by the r main subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_main.ml#L110)

<a id="constant-constant-lightlevels-const-lightlevels-16-src-r-main-ml-1973212838"></a>
### LIGHTLEVELS

```ml
const LIGHTLEVELS = 16
```

Defines lightlevels for the r main subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_main.ml#L70)

<a id="constant-constant-lightscaleshift-const-lightscaleshift-12-src-r-main-ml-1955286394"></a>
### LIGHTSCALESHIFT

```ml
const LIGHTSCALESHIFT = 12
```

Defines lightscaleshift for the r main subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_main.ml#L76)

<a id="constant-constant-lightsegshift-const-lightsegshift-4-src-r-main-ml-290080635"></a>
### LIGHTSEGSHIFT

```ml
const LIGHTSEGSHIFT = 4
```

Defines lightsegshift for the r main subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_main.ml#L72)

<a id="constant-constant-lightzshift-const-lightzshift-20-src-r-main-ml-1985661619"></a>
### LIGHTZSHIFT

```ml
const LIGHTZSHIFT = 20
```

Defines lightzshift for the r main subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_main.ml#L80)

<a id="global-global-linecount-linecount-src-r-main-ml-1165452760"></a>
### linecount

```ml
linecount
```

Tracks the mutable linecount value used by the r main subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_main.ml#L65)

<a id="global-global-loopcount-loopcount-src-r-main-ml-428798776"></a>
### loopcount

```ml
loopcount
```

Tracks the mutable loopcount value used by the r main subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_main.ml#L67)

<a id="constant-constant-maxlightscale-const-maxlightscale-48-src-r-main-ml-1964883577"></a>
### MAXLIGHTSCALE

```ml
const MAXLIGHTSCALE = 48
```

Defines the maximum maxlightscale accepted by the r main subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_main.ml#L74)

<a id="constant-constant-maxlightz-const-maxlightz-128-src-r-main-ml-1168325510"></a>
### MAXLIGHTZ

```ml
const MAXLIGHTZ = 128
```

Defines the maximum maxlightz accepted by the r main subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_main.ml#L78)

<a id="constant-constant-numcolormaps-const-numcolormaps-32-src-r-main-ml-2132571622"></a>
### NUMCOLORMAPS

```ml
const NUMCOLORMAPS = 32
```

Defines the numcolormaps count used by the r main subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_main.ml#L82)

<a id="global-global-projection-projection-src-r-main-ml-954937562"></a>
### projection

```ml
projection
```

Tracks the mutable projection value used by the r main subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_main.ml#L59)

<a id="function-function-r-addpointtobox-function-r-addpointtobox-x-y-box-src-r-main-ml-1847282580"></a>
### R_AddPointToBox

```ml
function R_AddPointToBox(x, y, box)
```

Expands a four-entry BOXLEFT/RIGHT/BOTTOM/TOP bounds array to include a point.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `x` | `dynamic` | — | Horizontal map- or screen-space coordinate. |
| `y` | `dynamic` | — | Vertical map- or screen-space coordinate. |
| `box` | `dynamic` | — | Bounding-box array to read or update. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_main.ml#L787)

<a id="function-function-r-executesetviewsize-function-r-executesetviewsize-src-r-main-ml-553064750"></a>
### R_ExecuteSetViewSize

```ml
function R_ExecuteSetViewSize()
```

Applies the deferred block/detail request only when a view-size rebuild is pending.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_main.ml#L956)

<a id="function-function-r-init-function-r-init-src-r-main-ml-761046434"></a>
### R_Init

```ml
function R_Init()
```

Initializes render data, geometry/light tables, view sizing, translations, and optional profiling hooks.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_main.ml#L805)

<a id="function-function-r-initlighttables-function-r-initlighttables-src-r-main-ml-851065574"></a>
### R_InitLightTables

```ml
function R_InitLightTables()
```

Builds distance-indexed, scale-indexed, and fixed-colormap lighting lookup matrices.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_main.ml#L972)

<a id="function-function-r-initpointtoangle-function-r-initpointtoangle-src-r-main-ml-1811893726"></a>
### R_InitPointToAngle

```ml
function R_InitPointToAngle()
```

Ensures the trigonometric tables required by point-to-angle calculations are populated.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_main.ml#L962)

<a id="function-function-r-inittables-function-r-inittables-src-r-main-ml-21188798"></a>
### R_InitTables

```ml
function R_InitTables()
```

Initializes the shared fine-angle, tangent, sine, and slope lookup tables.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_main.ml#L967)

<a id="function-function-r-inittexturemapping-function-r-inittexturemapping-src-r-main-ml-1131780190"></a>
### R_InitTextureMapping

```ml
function R_InitTextureMapping()
```

Rebuilds the public view-column-to-angle and angle-to-column mapping tables.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_main.ml#L1034)

<a id="function-function-r-pointinsubsector-function-r-pointinsubsector-x-y-src-r-main-ml-491971087"></a>
### R_PointInSubsector

```ml
function R_PointInSubsector(x, y)
```

Walks the BSP from its root to locate the leaf subsector containing a world coordinate.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `x` | `dynamic` | — | Horizontal map- or screen-space coordinate. |
| `y` | `dynamic` | — | Vertical map- or screen-space coordinate. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_main.ml#L763)

<a id="function-function-r-pointonsegside-inline-function-r-pointonsegside-x-y-seg-src-r-main-ml-824635593"></a>
### R_PointOnSegSide

```ml
inline function R_PointOnSegSide(x, y, seg)
```

Classifies a fixed-point position against an oriented seg for clipping and sprite-side decisions.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `x` | `dynamic` | — | Horizontal map- or screen-space coordinate. |
| `y` | `dynamic` | — | Vertical map- or screen-space coordinate. |
| `seg` | `dynamic` | — | Seg value supplied to `R_PointOnSegSide`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_main.ml#L563)

<a id="function-function-r-pointonside-inline-function-r-pointonside-x-y-node-src-r-main-ml-593447418"></a>
### R_PointOnSide

```ml
inline function R_PointOnSide(x, y, node)
```

Classifies a fixed-point position against a BSP partition, using axis fast paths and overflow-safe sign tests.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `x` | `dynamic` | — | Horizontal map- or screen-space coordinate. |
| `y` | `dynamic` | — | Vertical map- or screen-space coordinate. |
| `node` | `dynamic` | — | Node value supplied to `R_PointOnSide`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_main.ml#L520)

<a id="function-function-r-pointtoangle-function-r-pointtoangle-x-y-src-r-main-ml-1905448667"></a>
### R_PointToAngle

```ml
function R_PointToAngle(x, y)
```

Computes the wrapped binary angle from the current view origin to a world point via octant slope lookup.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `x` | `dynamic` | — | Horizontal map- or screen-space coordinate. |
| `y` | `dynamic` | — | Vertical map- or screen-space coordinate. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_main.ml#L609)

<a id="function-function-r-pointtoangle2-inline-function-r-pointtoangle2-x1-y1-x2-y2-src-r-main-ml-604360867"></a>
### R_PointToAngle2

```ml
inline function R_PointToAngle2(x1, y1, x2, y2)
```

Computes the binary angle between arbitrary endpoints while restoring the renderer's global view origin afterward.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `x1` | `dynamic` | — | Horizontal coordinate of the first endpoint. |
| `y1` | `dynamic` | — | Vertical coordinate of the first endpoint. |
| `x2` | `dynamic` | — | Horizontal coordinate of the second endpoint. |
| `y2` | `dynamic` | — | Vertical coordinate of the second endpoint. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_main.ml#L662)

<a id="function-function-r-pointtodist-inline-function-r-pointtodist-x-y-src-r-main-ml-1687323770"></a>
### R_PointToDist

```ml
inline function R_PointToDist(x, y)
```

Computes fixed-point planar distance from the view origin using slope and sine lookup tables.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `x` | `dynamic` | — | Horizontal map- or screen-space coordinate. |
| `y` | `dynamic` | — | Vertical map- or screen-space coordinate. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_main.ml#L679)

<a id="function-function-r-renderclassicplayerview-function-r-renderclassicplayerview-player-src-r-main-ml-1669681167"></a>
### R_RenderClassicPlayerView

```ml
function R_RenderClassicPlayerView(player)
```

Draws the current player view with the classic CPU renderer only.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `player` | `dynamic` | — | Player state affected by the operation. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_main.ml#L1080)

<a id="function-function-r-renderplayerview-function-r-renderplayerview-player-src-r-main-ml-1511226413"></a>
### R_RenderPlayerView

```ml
function R_RenderPlayerView(player)
```

Dispatches the player view to exactly one active renderer.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `player` | `dynamic` | — | Player state affected by the operation. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_main.ml#L1182)

<a id="function-function-r-resetviewinterpolation-function-r-resetviewinterpolation-src-r-main-ml-1755598922"></a>
### R_ResetViewInterpolation

```ml
function R_ResetViewInterpolation()
```

Discards the previous camera sample so a spawn or level transition cannot interpolate from stale world coordinates.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_main.ml#L182)

<a id="function-function-r-scalefromglobalangle-function-r-scalefromglobalangle-visangle-src-r-main-ml-2031394109"></a>
### R_ScaleFromGlobalAngle

```ml
function R_ScaleFromGlobalAngle(visangle)
```

Derives the perspective scale for a wall column and clamps it to Doom's supported fixed-point range.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `visangle` | `dynamic` | — | Visangle value supplied to `R_ScaleFromGlobalAngle`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_main.ml#L714)

<a id="function-function-r-setupframe-function-r-setupframe-player-src-r-main-ml-1007900013"></a>
### R_SetupFrame

```ml
function R_SetupFrame(player)
```

Public entry point that derives view position, angle, lighting, and interpolation state for one player frame.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `player` | `dynamic` | — | Player state affected by the operation. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_main.ml#L1041)

<a id="function-function-r-setviewsize-function-r-setviewsize-blocks-detail-src-r-main-ml-2069391353"></a>
### R_SetViewSize

```ml
function R_SetViewSize(blocks, detail)
```

Clamps and applies a view-block request, rebuilding projection, draw callbacks, buffers, sprite scale, and light tables.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `blocks` | `dynamic` | — | Blocks value supplied to `R_SetViewSize`. |
| `detail` | `dynamic` | — | Detail value supplied to `R_SetViewSize`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_main.ml#L847)

<a id="global-global-scalelight-scalelight-src-r-main-ml-494186960"></a>
### scalelight

```ml
scalelight
```

Holds the optional scalelight resource used by the r main subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_main.ml#L85)

<a id="global-global-scalelightfixed-scalelightfixed-src-r-main-ml-1401548168"></a>
### scalelightfixed

```ml
scalelightfixed
```

Holds the optional scalelightfixed resource used by the r main subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_main.ml#L87)

<a id="global-global-setblocks-setblocks-src-r-main-ml-1717224576"></a>
### setblocks

```ml
setblocks
```

Tracks the mutable setblocks value used by the r main subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_main.ml#L101)

<a id="global-global-setdetail-setdetail-src-r-main-ml-1958500924"></a>
### setdetail

```ml
setdetail
```

Tracks the mutable setdetail value used by the r main subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_main.ml#L103)

<a id="global-global-setsizeneeded-setsizeneeded-src-r-main-ml-105526360"></a>
### setsizeneeded

```ml
setsizeneeded
```

Tracks whether setsizeneeded is active in the r main subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_main.ml#L99)

<a id="global-global-spanfunc-spanfunc-src-r-main-ml-1108280328"></a>
### spanfunc

```ml
spanfunc
```

Holds the optional spanfunc resource used by the r main subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_main.ml#L114)

<a id="global-global-sscount-sscount-src-r-main-ml-339816336"></a>
### sscount

```ml
sscount
```

Tracks the mutable sscount value used by the r main subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_main.ml#L125)

<a id="global-global-transcolfunc-transcolfunc-src-r-main-ml-2058734960"></a>
### transcolfunc

```ml
transcolfunc
```

Holds the optional transcolfunc resource used by the r main subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_main.ml#L112)

<a id="global-global-validcount-validcount-src-r-main-ml-2024690390"></a>
### validcount

```ml
validcount
```

Tracks the mutable validcount value used by the r main subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_main.ml#L62)

<a id="global-global-viewangleoffset-viewangleoffset-src-r-main-ml-1440399220"></a>
### viewangleoffset

```ml
viewangleoffset
```

Tracks the mutable viewangleoffset value used by the r main subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_main.ml#L120)

<a id="global-global-viewcos-viewcos-src-r-main-ml-1853940676"></a>
### viewcos

```ml
viewcos
```

Tracks the mutable viewcos value used by the r main subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_main.ml#L37)

<a id="global-global-viewheight-viewheight-src-r-main-ml-251628632"></a>
### viewheight

```ml
viewheight
```

Tracks the mutable viewheight value used by the r main subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_main.ml#L44)

<a id="global-global-viewsin-viewsin-src-r-main-ml-263858596"></a>
### viewsin

```ml
viewsin
```

Tracks the mutable viewsin value used by the r main subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_main.ml#L39)

<a id="global-global-viewwidth-viewwidth-src-r-main-ml-1955127744"></a>
### viewwidth

```ml
viewwidth
```

Tracks the mutable viewwidth value used by the r main subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_main.ml#L42)

<a id="global-global-viewwindowx-viewwindowx-src-r-main-ml-762834316"></a>
### viewwindowx

```ml
viewwindowx
```

Tracks the mutable viewwindowx value used by the r main subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_main.ml#L46)

<a id="global-global-viewwindowy-viewwindowy-src-r-main-ml-492198968"></a>
### viewwindowy

```ml
viewwindowy
```

Tracks the mutable viewwindowy value used by the r main subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_main.ml#L48)

<a id="global-global-zlight-zlight-src-r-main-ml-744588728"></a>
### zlight

```ml
zlight
```

Holds the optional zlight resource used by the r main subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_main.ml#L89)
