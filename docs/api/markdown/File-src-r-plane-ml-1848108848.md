# `src/r_plane.ml`

[Home](README.md) · [Files](Files.md)

Aggregates visible floor, ceiling, and sky regions into visplanes and rasterizes their horizontal spans or sky columns.

Package: [`(global)`](Package-global-1952375359.md)

Reachable from entry: **yes**

## Imports

- `doomdef.ml` → [src/doomdef.ml](File-src-doomdef-ml-460406769.md)
- `doomstat.ml` → [src/doomstat.ml](File-src-doomstat-ml-1652708088.md)
- `i_system.ml` → [src/i_system.ml](File-src-i-system-ml-1632920966.md)
- `r_data.ml` → [src/r_data.ml](File-src-r-data-ml-1686270288.md)
- `r_hires.ml` → [src/r_hires.ml](File-src-r-hires-ml-694005807.md)
- `r_local.ml` → [src/r_local.ml](File-src-r-local-ml-797040731.md)
- `r_main.ml` → [src/r_main.ml](File-src-r-main-ml-1902335243.md)
- `r_sky.ml` → [src/r_sky.ml](File-src-r-sky-ml-918225537.md)
- `r_upscaled.ml` → [src/r_upscaled.ml](File-src-r-upscaled-ml-1801241933.md)
- `std/math.ml` → `../MiniLangCompilerOptimization/MiniLangCompilerPy/std/math.ml` — external dependency
- `w_wad.ml` → [src/w_wad.ml](File-src-w-wad-ml-893006035.md)
- `z_zone.ml` → [src/z_zone.ml](File-src-z-zone-ml-1788911354.md)

## Declarations

<a id="function-function-rp-abs-inline-function-rp-abs-v-src-r-plane-ml-108911242"></a>
### _RP_Abs

```ml
inline function _RP_Abs(v)
```

Returns the non-negative integer magnitude of a possibly non-integer plane value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `v` | `dynamic` | — | Value consumed by the operation. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_plane.ml#L145)

<a id="function-function-rp-angnorm-inline-function-rp-angnorm-a-src-r-plane-ml-419188575"></a>
### _RP_AngNorm

```ml
inline function _RP_AngNorm(a)
```

Normalizes a coerced angle to Doom's unsigned 32-bit binary-angle domain.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `a` | `dynamic` | — | First input operand. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_plane.ml#L162)

<a id="global-global-rp-default-colormap-rp-default-colormap-src-r-plane-ml-1464623427"></a>
### _rp_default_colormap

```ml
_rp_default_colormap
```

Holds the optional rp default colormap resource used by the r plane subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_plane.ml#L69)

<a id="function-function-rp-defaultcolormap-inline-function-rp-defaultcolormap-src-r-plane-ml-1249687728"></a>
### _RP_DefaultColorMap

```ml
inline function _RP_DefaultColorMap()
```

Caches the first 256-byte colormap for unlit sky columns, falling back to a zeroed map when assets are absent.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_plane.ml#L185)

<a id="function-function-rp-drawvisplanes-function-rp-drawvisplanes-src-r-plane-ml-98651865"></a>
### _RP_DrawVisplanes

```ml
function _RP_DrawVisplanes()
```

Rasterizes queued sky visplanes as vertical texture columns and ordinary flats as lit horizontal spans, updating profile counts.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_plane.ml#L554)

<a id="function-function-rp-ensureplanecapacity-function-rp-ensureplanecapacity-needindex-src-r-plane-ml-742454977"></a>
### _RP_EnsurePlaneCapacity

```ml
function _RP_EnsurePlaneCapacity(needIndex)
```

Geometrically grows reusable visplane storage up to a hard safety limit and initializes every new slot.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `needIndex` | `dynamic` | — | Index identifying need. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_plane.ml#L228)

<a id="function-function-rp-fineat-inline-function-rp-fineat-tab-idx-src-r-plane-ml-810100658"></a>
### _RP_FineAt

```ml
inline function _RP_FineAt(tab, idx)
```

Samples a fine-angle lookup table with wraparound and returns zero when the table is unavailable.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `tab` | `dynamic` | — | Tab value supplied to `_RP_FineAt`. |
| `idx` | `dynamic` | — | Zero-based element or table index. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_plane.ml#L171)

<a id="function-function-rp-i-inline-function-rp-i-v-fallback-src-r-plane-ml-412511704"></a>
### _RP_I

```ml
inline function _RP_I(v, fallback)
```

Coerces numeric values to truncation-toward-zero integers and returns a caller fallback on conversion failure.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `v` | `dynamic` | — | Value consumed by the operation. |
| `fallback` | `dynamic` | — | Value returned when the requested conversion or lookup is unavailable. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_plane.ml#L127)

<a id="function-function-rp-idiv-inline-function-rp-idiv-a-b-src-r-plane-ml-317990625"></a>
### _RP_IDiv

```ml
inline function _RP_IDiv(a, b)
```

Returns a signed quotient truncated toward zero, or zero for invalid operands and a zero divisor in `_RP_IDiv`

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `a` | `dynamic` | — | First input operand. |
| `b` | `dynamic` | — | Second input operand. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_plane.ml#L115)

<a id="function-function-rp-isseq-inline-function-rp-isseq-v-src-r-plane-ml-1094817874"></a>
### _RP_IsSeq

```ml
inline function _RP_IsSeq(v)
```

Recognizes both array and list containers accepted by plane tables and geometry records.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `v` | `dynamic` | — | Value consumed by the operation. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_plane.ml#L154)

<a id="function-function-rp-newplane-inline-function-rp-newplane-height-picnum-lightlevel-src-r-plane-ml-1744632695"></a>
### _RP_NewPlane

```ml
inline function _RP_NewPlane(height, picnum, lightlevel)
```

Constructs an unused visplane with target-width top/bottom arrays and sentinel horizontal bounds.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `height` | `dynamic` | — | Height of the target in pixels or map units. |
| `picnum` | `dynamic` | — | Index identifying pic. |
| `lightlevel` | `dynamic` | — | Lightlevel value supplied to `_RP_NewPlane`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_plane.ml#L220)

<a id="global-global-rp-prof-mapplane-calls-rp-prof-mapplane-calls-src-r-plane-ml-8056757"></a>
### _rp_prof_mapplane_calls

```ml
_rp_prof_mapplane_calls
```

Tracks the mutable rp prof mapplane calls value used by the r plane subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_plane.ml#L108)

<a id="global-global-rp-prof-visplanes-flat-rp-prof-visplanes-flat-src-r-plane-ml-549841533"></a>
### _rp_prof_visplanes_flat

```ml
_rp_prof_visplanes_flat
```

Tracks the mutable rp prof visplanes flat value used by the r plane subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_plane.ml#L105)

<a id="global-global-rp-prof-visplanes-sky-rp-prof-visplanes-sky-src-r-plane-ml-28990959"></a>
### _rp_prof_visplanes_sky

```ml
_rp_prof_visplanes_sky
```

Tracks the mutable rp prof visplanes sky value used by the r plane subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_plane.ml#L102)

<a id="global-global-rp-prof-visplanes-total-rp-prof-visplanes-total-src-r-plane-ml-1617964333"></a>
### _rp_prof_visplanes_total

```ml
_rp_prof_visplanes_total
```

Tracks the mutable rp prof visplanes total value used by the r plane subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_plane.ml#L99)

<a id="function-function-rp-recomputeslopetables-function-rp-recomputeslopetables-src-r-plane-ml-1380175339"></a>
### _RP_RecomputeSlopeTables

```ml
function _RP_RecomputeSlopeTables()
```

Rebuilds row distance slopes and per-column perspective correction factors for the active view geometry.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_plane.ml#L298)

<a id="function-function-rp-resetplane-function-rp-resetplane-pl-height-picnum-lightlevel-minx-maxx-src-r-plane-ml-954733404"></a>
### _RP_ResetPlane

```ml
function _RP_ResetPlane(pl, height, picnum, lightlevel, minx, maxx)
```

Recycles a visplane for new height, texture, and light keys while clearing every covered-column marker.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `pl` | `dynamic` | — | Pl value supplied to `_RP_ResetPlane`. |
| `height` | `dynamic` | — | Height of the target in pixels or map units. |
| `picnum` | `dynamic` | — | Index identifying pic. |
| `lightlevel` | `dynamic` | — | Lightlevel value supplied to `_RP_ResetPlane`. |
| `minx` | `dynamic` | — | Minx value supplied to `_RP_ResetPlane`. |
| `maxx` | `dynamic` | — | Maxx value supplied to `_RP_ResetPlane`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_plane.ml#L265)

<a id="function-function-rp-targetheight-inline-function-rp-targetheight-src-r-plane-ml-1359538410"></a>
### _RP_TargetHeight

```ml
inline function _RP_TargetHeight()
```

Returns active world render height.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_plane.ml#L210)

<a id="function-function-rp-targetwidth-inline-function-rp-targetwidth-src-r-plane-ml-208005712"></a>
### _RP_TargetWidth

```ml
inline function _RP_TargetWidth()
```

Returns active world render width.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_plane.ml#L203)

<a id="global-global-basexscale-basexscale-src-r-plane-ml-1795587111"></a>
### basexscale

```ml
basexscale
```

Tracks the mutable basexscale value used by the r plane subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_plane.ml#L76)

<a id="global-global-baseyscale-baseyscale-src-r-plane-ml-2095104773"></a>
### baseyscale

```ml
baseyscale
```

Tracks the mutable baseyscale value used by the r plane subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_plane.ml#L78)

<a id="global-global-cacheddistance-cacheddistance-src-r-plane-ml-1530722595"></a>
### cacheddistance

```ml
cacheddistance
```

Stores the cacheddistance collection used by the r plane subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_plane.ml#L92)

<a id="global-global-cachedheight-cachedheight-src-r-plane-ml-1503355251"></a>
### cachedheight

```ml
cachedheight
```

Stores the cachedheight collection used by the r plane subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_plane.ml#L90)

<a id="global-global-cachedxstep-cachedxstep-src-r-plane-ml-66216865"></a>
### cachedxstep

```ml
cachedxstep
```

Stores the cachedxstep collection used by the r plane subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_plane.ml#L94)

<a id="global-global-cachedystep-cachedystep-src-r-plane-ml-312627581"></a>
### cachedystep

```ml
cachedystep
```

Stores the cachedystep collection used by the r plane subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_plane.ml#L96)

<a id="global-global-ceilingclip-ceilingclip-src-r-plane-ml-70474317"></a>
### ceilingclip

```ml
ceilingclip
```

Stores the ceilingclip collection used by the r plane subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_plane.ml#L45)

<a id="global-global-ceilingfunc-t-ceilingfunc-t-src-r-plane-ml-2067122477"></a>
### ceilingfunc_t

```ml
ceilingfunc_t
```

Holds the optional ceilingfunc t resource used by the r plane subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_plane.ml#L40)

<a id="global-global-ceilingplane-ceilingplane-src-r-plane-ml-856556535"></a>
### ceilingplane

```ml
ceilingplane
```

Holds the optional ceilingplane resource used by the r plane subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_plane.ml#L83)

<a id="global-global-distscale-distscale-src-r-plane-ml-1917928797"></a>
### distscale

```ml
distscale
```

Stores the distscale collection used by the r plane subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_plane.ml#L50)

<a id="global-global-floorclip-floorclip-src-r-plane-ml-1704267121"></a>
### floorclip

```ml
floorclip
```

Stores the floorclip collection used by the r plane subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_plane.ml#L43)

<a id="global-global-floorfunc-floorfunc-src-r-plane-ml-499444977"></a>
### floorfunc

```ml
floorfunc
```

Holds the optional floorfunc resource used by the r plane subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_plane.ml#L38)

<a id="global-global-floorplane-floorplane-src-r-plane-ml-1913937917"></a>
### floorplane

```ml
floorplane
```

Holds the optional floorplane resource used by the r plane subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_plane.ml#L81)

<a id="global-global-lastopening-lastopening-src-r-plane-ml-1119193249"></a>
### lastopening

```ml
lastopening
```

Holds the optional lastopening resource used by the r plane subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_plane.ml#L35)

<a id="constant-constant-maxopenings-const-maxopenings-screenwidth-64-src-r-plane-ml-1316818374"></a>
### MAXOPENINGS

```ml
const MAXOPENINGS = SCREENWIDTH * 64
```

Defines the maximum maxopenings accepted by the r plane subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_plane.ml#L55)

<a id="constant-constant-maxvisplanes-const-maxvisplanes-128-src-r-plane-ml-1724338655"></a>
### MAXVISPLANES

```ml
const MAXVISPLANES = 128
```

Defines the maximum maxvisplanes accepted by the r plane subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_plane.ml#L53)

<a id="global-global-openings-openings-src-r-plane-ml-536964067"></a>
### openings

```ml
openings
```

Stores the openings collection used by the r plane subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_plane.ml#L62)

<a id="global-global-planeheight-planeheight-src-r-plane-ml-167644177"></a>
### planeheight

```ml
planeheight
```

Tracks the mutable planeheight value used by the r plane subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_plane.ml#L74)

<a id="global-global-planezlight-planezlight-src-r-plane-ml-1270531625"></a>
### planezlight

```ml
planezlight
```

Holds the optional planezlight resource used by the r plane subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_plane.ml#L72)

<a id="function-function-r-checkplane-function-r-checkplane-pl-start-stop-src-r-plane-ml-153523453"></a>
### R_CheckPlane

```ml
function R_CheckPlane(pl, start, stop)
```

Extends a visplane across unused columns or splits it into a duplicate when the requested range overlaps existing spans.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `pl` | `dynamic` | — | Pl value supplied to `R_CheckPlane`. |
| `start` | `dynamic` | — | Start value supplied to `R_CheckPlane`. |
| `stop` | `dynamic` | — | Stop value supplied to `R_CheckPlane`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_plane.ml#L732)

<a id="function-function-r-clearplanes-function-r-clearplanes-src-r-plane-ml-1641946997"></a>
### R_ClearPlanes

```ml
function R_ClearPlanes()
```

Resets per-column floor/ceiling clips and visplane allocation, invalidates row caches, and derives view-relative texture scales.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_plane.ml#L390)

<a id="function-function-r-drawplanes-function-r-drawplanes-src-r-plane-ml-579493703"></a>
### R_DrawPlanes

```ml
function R_DrawPlanes()
```

Executes the queued visplane rasterization pass after wall clipping has finalized visible column bounds.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_plane.ml#L689)

<a id="function-function-r-findplane-function-r-findplane-height-picnum-lightlevel-src-r-plane-ml-917624394"></a>
### R_FindPlane

```ml
function R_FindPlane(height, picnum, lightlevel)
```

Reuses a visplane with matching height, texture, and light keys or allocates a cleared entry for a new region.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `height` | `dynamic` | — | Height of the target in pixels or map units. |
| `picnum` | `dynamic` | — | Index identifying pic. |
| `lightlevel` | `dynamic` | — | Lightlevel value supplied to `R_FindPlane`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_plane.ml#L698)

<a id="function-function-r-initplanes-function-r-initplanes-src-r-plane-ml-610144495"></a>
### R_InitPlanes

```ml
function R_InitPlanes()
```

Sizes clipping, slope, span, opening, cache, and visplane workspaces for the active logical or HD render target.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_plane.ml#L334)

<a id="function-function-r-makespans-function-r-makespans-x-t1-b1-t2-b2-src-r-plane-ml-308509433"></a>
### R_MakeSpans

```ml
function R_MakeSpans(x, t1, b1, t2, b2)
```

Compares adjacent visplane column bounds, closes rows that ended, and records starting columns for newly opened rows.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `x` | `dynamic` | — | Horizontal map- or screen-space coordinate. |
| `t1` | `dynamic` | — | T1 value supplied to `R_MakeSpans`. |
| `b1` | `dynamic` | — | B1 value supplied to `R_MakeSpans`. |
| `t2` | `dynamic` | — | T2 value supplied to `R_MakeSpans`. |
| `b2` | `dynamic` | — | B2 value supplied to `R_MakeSpans`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_plane.ml#L525)

<a id="function-function-r-mapplane-function-r-mapplane-y-x1-x2-src-r-plane-ml-488171667"></a>
### R_MapPlane

```ml
function R_MapPlane(y, x1, x2)
```

Derives perspective distance, texture stepping, origin, and lighting for one horizontal plane span before rasterization.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `y` | `dynamic` | — | Vertical map- or screen-space coordinate. |
| `x1` | `dynamic` | — | Horizontal coordinate of the first endpoint. |
| `x2` | `dynamic` | — | Horizontal coordinate of the second endpoint. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_plane.ml#L439)

<a id="constant-constant-rp-maxvisplanes-hard-const-rp-maxvisplanes-hard-4096-src-r-plane-ml-603685105"></a>
### RP_MAXVISPLANES_HARD

```ml
const RP_MAXVISPLANES_HARD = 4096
```

Defines the maximum rp maxvisplanes hard accepted by the r plane subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_plane.ml#L57)

<a id="constant-constant-rp-span-sentinel-const-rp-span-sentinel-2147483647-src-r-plane-ml-1164180780"></a>
### RP_SPAN_SENTINEL

```ml
const RP_SPAN_SENTINEL = 2147483647
```

Defines rp span sentinel for the r plane subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_plane.ml#L59)

<a id="global-global-spanstart-spanstart-src-r-plane-ml-716270893"></a>
### spanstart

```ml
spanstart
```

Stores the spanstart collection used by the r plane subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_plane.ml#L86)

<a id="global-global-spanstop-spanstop-src-r-plane-ml-433708609"></a>
### spanstop

```ml
spanstop
```

Stores the spanstop collection used by the r plane subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_plane.ml#L88)

<a id="global-global-visplanes-visplanes-src-r-plane-ml-358857813"></a>
### visplanes

```ml
visplanes
```

Stores the visplanes collection used by the r plane subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_plane.ml#L64)

<a id="global-global-visplanes-last-visplanes-last-src-r-plane-ml-546473637"></a>
### visplanes_last

```ml
visplanes_last
```

Tracks the mutable visplanes last value used by the r plane subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_plane.ml#L66)

<a id="global-global-yslope-yslope-src-r-plane-ml-645464061"></a>
### yslope

```ml
yslope
```

Stores the yslope collection used by the r plane subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_plane.ml#L48)
