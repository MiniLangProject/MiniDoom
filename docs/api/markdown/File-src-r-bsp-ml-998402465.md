# `src/r_bsp.ml`

[Home](README.md) · [Files](Files.md)

Traverses front-to-back BSP nodes, culls occluded child bounds, and clips wall segments against solid screen ranges.

Package: [`(global)`](Package-global-1952375359.md)

Reachable from entry: **yes**

## Imports

- `doomdef.ml` → [src/doomdef.ml](File-src-doomdef-ml-460406769.md)
- `doomstat.ml` → [src/doomstat.ml](File-src-doomstat-ml-1652708088.md)
- `i_system.ml` → [src/i_system.ml](File-src-i-system-ml-1632920966.md)
- `m_bbox.ml` → [src/m_bbox.ml](File-src-m-bbox-ml-1176525784.md)
- `r_main.ml` → [src/r_main.ml](File-src-r-main-ml-1902335243.md)
- `r_plane.ml` → [src/r_plane.ml](File-src-r-plane-ml-1848108848.md)
- `r_state.ml` → [src/r_state.ml](File-src-r-state-ml-691819649.md)
- `r_things.ml` → [src/r_things.ml](File-src-r-things-ml-545677447.md)
- `std/math.ml` → `../MiniLangCompilerOptimization/MiniLangCompilerPy/std/math.ml` — external dependency
- `std/time.ml` → `../MiniLangCompilerOptimization/MiniLangCompilerPy/std/time.ml` — external dependency

## Declarations

<a id="function-function-makeclip-inline-function-makeclip-first-last-src-r-bsp-ml-655213319"></a>
### _makeClip

```ml
inline function _makeClip(first, last)
```

Constructs one inclusive solid-column interval for the occlusion list.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `first` | `dynamic` | — | First value supplied to `_makeClip`. |
| `last` | `dynamic` | — | Last value supplied to `_makeClip`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_bsp.ml#L221)

<a id="function-function-makedrawseg-inline-function-makedrawseg-src-r-bsp-ml-1260812187"></a>
### _makeDrawseg

```ml
inline function _makeDrawseg()
```

Constructs an empty draw-segment record used to preallocate the reusable masked-sprite clipping table.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_bsp.ml#L212)

<a id="function-function-r-clipget-inline-function-r-clipget-i-src-r-bsp-ml-1370608928"></a>
### _R_ClipGet

```ml
inline function _R_ClipGet(i)
```

Returns a solid clip interval by index, substituting an empty sentinel for invalid access.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `i` | `dynamic` | — | Zero-based iteration index. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_bsp.ml#L228)

<a id="function-function-r-clipset-inline-function-r-clipset-i-c-src-r-bsp-ml-1865036895"></a>
### _R_ClipSet

```ml
inline function _R_ClipSet(i, c)
```

Replaces or appends a solid clip interval, growing intermediate slots with empty sentinels.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `i` | `dynamic` | — | Zero-based iteration index. |
| `c` | `dynamic` | — | C value supplied to `_R_ClipSet`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_bsp.ml#L237)

<a id="function-function-r-viewangletox-inline-function-r-viewangletox-aidx-src-r-bsp-ml-1001607503"></a>
### _R_ViewAngleToX

```ml
inline function _R_ViewAngleToX(aidx)
```

Clamps a fine view-angle index and maps it to a projected screen column, falling back to view center when unavailable.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `aidx` | `dynamic` | — | Aidx value supplied to `_R_ViewAngleToX`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_bsp.ml#L282)

<a id="global-global-rb-prof-addline-calls-rb-prof-addline-calls-src-r-bsp-ml-1262490714"></a>
### _rb_prof_addline_calls

```ml
_rb_prof_addline_calls
```

Tracks the mutable rb prof addline calls value used by the r bsp subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_bsp.ml#L104)

<a id="global-global-rb-prof-addline-ms-rb-prof-addline-ms-src-r-bsp-ml-849960796"></a>
### _rb_prof_addline_ms

```ml
_rb_prof_addline_ms
```

Tracks the mutable rb prof addline ms value used by the r bsp subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_bsp.ml#L101)

<a id="global-global-rb-prof-bbox-calls-rb-prof-bbox-calls-src-r-bsp-ml-1874768152"></a>
### _rb_prof_bbox_calls

```ml
_rb_prof_bbox_calls
```

Tracks the mutable rb prof bbox calls value used by the r bsp subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_bsp.ml#L122)

<a id="global-global-rb-prof-bbox-ms-rb-prof-bbox-ms-src-r-bsp-ml-256652936"></a>
### _rb_prof_bbox_ms

```ml
_rb_prof_bbox_ms
```

Tracks the mutable rb prof bbox ms value used by the r bsp subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_bsp.ml#L119)

<a id="global-global-rb-prof-enabled-rb-prof-enabled-src-r-bsp-ml-426821010"></a>
### _rb_prof_enabled

```ml
_rb_prof_enabled
```

Tracks whether rb prof enabled is active in the r bsp subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_bsp.ml#L140)

<a id="global-global-rb-prof-newend-max-rb-prof-newend-max-src-r-bsp-ml-92990704"></a>
### _rb_prof_newend_max

```ml
_rb_prof_newend_max
```

Tracks the mutable rb prof newend max value used by the r bsp subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_bsp.ml#L134)

<a id="global-global-rb-prof-node-calls-rb-prof-node-calls-src-r-bsp-ml-546063396"></a>
### _rb_prof_node_calls

```ml
_rb_prof_node_calls
```

Tracks the mutable rb prof node calls value used by the r bsp subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_bsp.ml#L131)

<a id="global-global-rb-prof-pointonside-calls-rb-prof-pointonside-calls-src-r-bsp-ml-1948256308"></a>
### _rb_prof_pointonside_calls

```ml
_rb_prof_pointonside_calls
```

Tracks the mutable rb prof pointonside calls value used by the r bsp subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_bsp.ml#L128)

<a id="global-global-rb-prof-pointonside-ms-rb-prof-pointonside-ms-src-r-bsp-ml-595368248"></a>
### _rb_prof_pointonside_ms

```ml
_rb_prof_pointonside_ms
```

Tracks the mutable rb prof pointonside ms value used by the r bsp subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_bsp.ml#L125)

<a id="global-global-rb-prof-revspans-rb-prof-revspans-src-r-bsp-ml-1174692492"></a>
### _rb_prof_revspans

```ml
_rb_prof_revspans
```

Tracks the mutable rb prof revspans value used by the r bsp subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_bsp.ml#L137)

<a id="global-global-rb-prof-segloop-ms-rb-prof-segloop-ms-src-r-bsp-ml-876706672"></a>
### _rb_prof_segloop_ms

```ml
_rb_prof_segloop_ms
```

Tracks the mutable rb prof segloop ms value used by the r bsp subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_bsp.ml#L113)

<a id="global-global-rb-prof-store-calls-rb-prof-store-calls-src-r-bsp-ml-351426546"></a>
### _rb_prof_store_calls

```ml
_rb_prof_store_calls
```

Tracks the mutable rb prof store calls value used by the r bsp subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_bsp.ml#L110)

<a id="global-global-rb-prof-store-ms-rb-prof-store-ms-src-r-bsp-ml-38593684"></a>
### _rb_prof_store_ms

```ml
_rb_prof_store_ms
```

Tracks the mutable rb prof store ms value used by the r bsp subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_bsp.ml#L107)

<a id="global-global-rb-prof-subsector-calls-rb-prof-subsector-calls-src-r-bsp-ml-2041369208"></a>
### _rb_prof_subsector_calls

```ml
_rb_prof_subsector_calls
```

Tracks the mutable rb prof subsector calls value used by the r bsp subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_bsp.ml#L116)

<a id="function-function-rbsp-angnorm-inline-function-rbsp-angnorm-a-src-r-bsp-ml-1096893810"></a>
### _RBSP_AngNorm

```ml
inline function _RBSP_AngNorm(a)
```

Normalizes a coerced angle to Doom's unsigned 32-bit binary-angle domain.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `a` | `dynamic` | — | First input operand. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_bsp.ml#L293)

<a id="function-function-rbsp-angsub-inline-function-rbsp-angsub-a-b-src-r-bsp-ml-1421870718"></a>
### _RBSP_AngSub

```ml
inline function _RBSP_AngSub(a, b)
```

Subtracts two binary angles with explicit unsigned 32-bit wraparound.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `a` | `dynamic` | — | First input operand. |
| `b` | `dynamic` | — | Second input operand. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_bsp.ml#L302)

<a id="global-global-rbsp-disable-bbox-cull-rbsp-disable-bbox-cull-src-r-bsp-ml-635157928"></a>
### _rbsp_disable_bbox_cull

```ml
_rbsp_disable_bbox_cull
```

Tracks whether rbsp disable bbox cull is active in the r bsp subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_bsp.ml#L143)

<a id="function-function-rbsp-isseq-inline-function-rbsp-isseq-v-src-r-bsp-ml-1035484735"></a>
### _RBSP_IsSeq

```ml
inline function _RBSP_IsSeq(v)
```

Recognizes both array and list containers accepted by BSP geometry and lookup tables.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `v` | `dynamic` | — | Value consumed by the operation. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_bsp.ml#L253)

<a id="function-function-rbsp-storewallrange-inline-function-rbsp-storewallrange-first-last-src-r-bsp-ml-217397319"></a>
### _RBSP_StoreWallRange

```ml
inline function _RBSP_StoreWallRange(first, last)
```

Delegates a visible wall-column range and, when profiling is active, accumulates its storage time and call count.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `first` | `dynamic` | — | First value supplied to `_RBSP_StoreWallRange`. |
| `last` | `dynamic` | — | Last value supplied to `_RBSP_StoreWallRange`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_bsp.ml#L195)

<a id="function-function-rbsp-timems-inline-function-rbsp-timems-src-r-bsp-ml-1422692815"></a>
### _RBSP_TimeMs

```ml
inline function _RBSP_TimeMs()
```

Returns the runtime tick clock as a truncation-toward-zero integer for BSP profiling deltas.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_bsp.ml#L185)

<a id="function-function-rbsp-toint-inline-function-rbsp-toint-v-fallback-src-r-bsp-ml-2076386329"></a>
### _RBSP_ToInt

```ml
inline function _RBSP_ToInt(v, fallback)
```

Coerces numeric values to truncation-toward-zero integers and returns a caller fallback on conversion failure.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `v` | `dynamic` | — | Value consumed by the operation. |
| `fallback` | `dynamic` | — | Value returned when the requested conversion or lookup is unavailable. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_bsp.ml#L263)

<a id="global-global-backsector-backsector-src-r-bsp-ml-122788382"></a>
### backsector

```ml
backsector
```

Holds the optional backsector resource used by the r bsp subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_bsp.ml#L41)

<a id="global-global-checkcoord-checkcoord-src-r-bsp-ml-878626450"></a>
### checkcoord

```ml
checkcoord
```

Stores the checkcoord collection used by the r bsp subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_bsp.ml#L84)

- [cliprange_t](Type-cliprange-t-1741307755.md) — struct
<a id="global-global-curline-curline-src-r-bsp-ml-73851084"></a>
### curline

```ml
curline
```

Holds the optional curline resource used by the r bsp subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_bsp.ml#L33)

<a id="global-global-drawsegs-drawsegs-src-r-bsp-ml-835326032"></a>
### drawsegs

```ml
drawsegs
```

Stores the drawsegs collection used by the r bsp subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_bsp.ml#L58)

<a id="global-global-ds-p-ds-p-src-r-bsp-ml-1450752584"></a>
### ds_p

```ml
ds_p
```

Tracks the mutable ds p value used by the r bsp subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_bsp.ml#L60)

<a id="global-global-dscalelight-dscalelight-src-r-bsp-ml-1171334856"></a>
### dscalelight

```ml
dscalelight
```

Holds the optional dscalelight resource used by the r bsp subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_bsp.ml#L67)

<a id="global-global-frontsector-frontsector-src-r-bsp-ml-710670540"></a>
### frontsector

```ml
frontsector
```

Holds the optional frontsector resource used by the r bsp subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_bsp.ml#L39)

<a id="global-global-hscalelight-hscalelight-src-r-bsp-ml-1330789816"></a>
### hscalelight

```ml
hscalelight
```

Holds the optional hscalelight resource used by the r bsp subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_bsp.ml#L63)

<a id="global-global-linedef-linedef-src-r-bsp-ml-125473896"></a>
### linedef

```ml
linedef
```

Holds the optional linedef resource used by the r bsp subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_bsp.ml#L37)

<a id="global-global-markceiling-markceiling-src-r-bsp-ml-1670117684"></a>
### markceiling

```ml
markceiling
```

Tracks whether markceiling is active in the r bsp subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_bsp.ml#L53)

<a id="global-global-markfloor-markfloor-src-r-bsp-ml-490269072"></a>
### markfloor

```ml
markfloor
```

Tracks whether markfloor is active in the r bsp subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_bsp.ml#L51)

<a id="constant-constant-maxsegs-const-maxsegs-32-src-r-bsp-ml-1918227096"></a>
### MAXSEGS

```ml
const MAXSEGS = 32
```

Defines the maximum maxsegs accepted by the r bsp subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_bsp.ml#L78)

<a id="global-global-newend-newend-src-r-bsp-ml-28140114"></a>
### newend

```ml
newend
```

Tracks the mutable newend value used by the r bsp subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_bsp.ml#L82)

<a id="function-function-r-addline-function-r-addline-line-src-r-bsp-ml-312334856"></a>
### R_AddLine

```ml
function R_AddLine(line)
```

Adds line entries to the renderer.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `line` | `dynamic` | — | Map line or text line affected by the operation. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_bsp.ml#L448)

<a id="function-function-r-bspprofilereset-function-r-bspprofilereset-src-r-bsp-ml-361444462"></a>
### R_BspProfileReset

```ml
function R_BspProfileReset()
```

Zeros every BSP timing, call-count, span, and peak-clip statistic before a new measurement window.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_bsp.ml#L153)

<a id="function-function-r-bspprofilesetenabled-function-r-bspprofilesetenabled-on-src-r-bsp-ml-697677803"></a>
### R_BspProfileSetEnabled

```ml
function R_BspProfileSetEnabled(on)
```

Enables or disables collection of BSP traversal, clipping, and wall-storage timing counters.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `on` | `dynamic` | — | On value supplied to `R_BspProfileSetEnabled`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_bsp.ml#L147)

<a id="function-function-r-checkbbox-function-r-checkbbox-bspcoord-src-r-bsp-ml-1452739868"></a>
### R_CheckBBox

```ml
function R_CheckBBox(bspcoord)
```

Projects the visible corners of a BSP child bound and rejects it only when its complete screen span is already occluded.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `bspcoord` | `dynamic` | — | Bspcoord value supplied to `R_CheckBBox`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_bsp.ml#L531)

<a id="function-function-r-clearclipsegs-function-r-clearclipsegs-src-r-bsp-ml-1495323198"></a>
### R_ClearClipSegs

```ml
function R_ClearClipSegs()
```

Resets solid-wall occlusion to left and right offscreen sentinels and records the baseline peak when profiling.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_bsp.ml#L324)

<a id="function-function-r-cleardrawsegs-function-r-cleardrawsegs-src-r-bsp-ml-1814161838"></a>
### R_ClearDrawSegs

```ml
function R_ClearDrawSegs()
```

Rewinds draw-segment allocation for a frame and lazily seeds the reusable table to its baseline capacity.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_bsp.ml#L307)

<a id="function-function-r-clippasswallsegment-function-r-clippasswallsegment-first-last-src-r-bsp-ml-1252318656"></a>
### R_ClipPassWallSegment

```ml
function R_ClipPassWallSegment(first, last)
```

Computes pass wall segment values for the renderer.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `first` | `dynamic` | — | First value supplied to `R_ClipPassWallSegment`. |
| `last` | `dynamic` | — | Last value supplied to `R_ClipPassWallSegment`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_bsp.ml#L414)

<a id="function-function-r-clipsolidwallsegment-function-r-clipsolidwallsegment-first-last-src-r-bsp-ml-1731342786"></a>
### R_ClipSolidWallSegment

```ml
function R_ClipSolidWallSegment(first, last)
```

Emits visible portions of a solid wall range, then merges that range into the ordered screen-space occlusion intervals.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `first` | `dynamic` | — | First value supplied to `R_ClipSolidWallSegment`. |
| `last` | `dynamic` | — | Last value supplied to `R_ClipSolidWallSegment`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_bsp.ml#L338)

<a id="function-function-r-renderbspnode-function-r-renderbspnode-bspnum-src-r-bsp-ml-623454997"></a>
### R_RenderBSPNode

```ml
function R_RenderBSPNode(bspnum)
```

Recurses front-to-back through a BSP node, always renders the near child, and visits the far child only if its bound remains visible.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `bspnum` | `dynamic` | — | Index identifying bsp. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_bsp.ml#L665)

<a id="function-function-r-subsector-function-r-subsector-num-src-r-bsp-ml-1480965190"></a>
### R_Subsector

```ml
function R_Subsector(num)
```

Selects visible floor/ceiling planes, queues sector sprites, and submits every seg belonging to one BSP leaf.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `num` | `dynamic` | — | Index identifying the requested item. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_bsp.ml#L606)

<a id="global-global-rw-stopx-rw-stopx-src-r-bsp-ml-809133496"></a>
### rw_stopx

```ml
rw_stopx
```

Tracks the mutable rw stopx value used by the r bsp subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_bsp.ml#L46)

<a id="global-global-rw-x-rw-x-src-r-bsp-ml-778260296"></a>
### rw_x

```ml
rw_x
```

Tracks the mutable rw x value used by the r bsp subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_bsp.ml#L44)

<a id="global-global-segtextured-segtextured-src-r-bsp-ml-760220116"></a>
### segtextured

```ml
segtextured
```

Tracks whether segtextured is active in the r bsp subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_bsp.ml#L49)

<a id="global-global-sidedef-sidedef-src-r-bsp-ml-698707160"></a>
### sidedef

```ml
sidedef
```

Holds the optional sidedef resource used by the r bsp subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_bsp.ml#L35)

<a id="global-global-skymap-skymap-src-r-bsp-ml-2020280798"></a>
### skymap

```ml
skymap
```

Tracks whether skymap is active in the r bsp subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_bsp.ml#L55)

<a id="global-global-solidsegs-solidsegs-src-r-bsp-ml-1770119528"></a>
### solidsegs

```ml
solidsegs
```

Stores the solidsegs collection used by the r bsp subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_bsp.ml#L80)

<a id="global-global-vscalelight-vscalelight-src-r-bsp-ml-615570376"></a>
### vscalelight

```ml
vscalelight
```

Holds the optional vscalelight resource used by the r bsp subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_bsp.ml#L65)
