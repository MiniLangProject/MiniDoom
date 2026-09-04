# `src/p_maputl.ml`

[Home](README.md) · [Files](Files.md)

Supplies fixed-point geometry tests, blockmap linking, opening calculations, and ordered path traversal.

Package: [`(global)`](Package-global-1952375359.md)

Reachable from entry: **yes**

## Imports

- `doomdef.ml` → [src/doomdef.ml](File-src-doomdef-ml-460406769.md)
- `m_argv.ml` → [src/m_argv.ml](File-src-m-argv-ml-728984635.md)
- `m_bbox.ml` → [src/m_bbox.ml](File-src-m-bbox-ml-1176525784.md)
- `p_local.ml` → [src/p_local.ml](File-src-p-local-ml-1043095437.md)
- `r_main.ml` → [src/r_main.ml](File-src-r-main-ml-1902335243.md)
- `r_state.ml` → [src/r_state.ml](File-src-r-state-ml-691819649.md)

## Declarations

<a id="function-function-abs-inline-function-abs-x-src-p-maputl-ml-1657338949"></a>
### _abs

```ml
inline function _abs(x)
```

Returns an integer magnitude for distance and side-of-line calculations.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `x` | `dynamic` | — | Horizontal map- or screen-space coordinate. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_maputl.ml#L30)

<a id="function-function-ensureintercepts-inline-function-ensureintercepts-src-p-maputl-ml-1279046185"></a>
### _EnsureIntercepts

```ml
inline function _EnsureIntercepts()
```

Lazily allocates the reusable baseline intercept records required before path traversal begins.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_maputl.ml#L478)

<a id="function-function-pmu-diaguseenabled-inline-function-pmu-diaguseenabled-src-p-maputl-ml-297974505"></a>
### _PMU_DiagUseEnabled

```ml
inline function _PMU_DiagUseEnabled()
```

Caches whether path/use diagnostic output was requested on the command line.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_maputl.ml#L70)

<a id="function-function-pmu-diaguselog-inline-function-pmu-diaguselog-msg-src-p-maputl-ml-1252893942"></a>
### _PMU_DiagUseLog

```ml
inline function _PMU_DiagUseLog(msg)
```

Emits a map-use diagnostic only when the cached diagnostic option is active.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `msg` | `dynamic` | — | Msg value supplied to `_PMU_DiagUseLog`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_maputl.ml#L90)

<a id="function-function-pmu-hassignbit-inline-function-pmu-hassignbit-v-src-p-maputl-ml-2124986427"></a>
### _PMU_HasSignBit

```ml
inline function _PMU_HasSignBit(v)
```

Tests bit 31 of a value after unsigned 32-bit normalization.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `v` | `dynamic` | — | Value consumed by the operation. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_maputl.ml#L46)

<a id="function-function-pmu-isseq-inline-function-pmu-isseq-v-src-p-maputl-ml-545167715"></a>
### _PMU_IsSeq

```ml
inline function _PMU_IsSeq(v)
```

Accepts arrays and byte buffers as the indexable sequence forms used by compatibility helpers.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `v` | `dynamic` | — | Value consumed by the operation. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_maputl.ml#L53)

<a id="function-function-pmu-u32-inline-function-pmu-u32-v-src-p-maputl-ml-1445805573"></a>
### _PMU_U32

```ml
inline function _PMU_U32(v)
```

Normalizes an integer to unsigned 32-bit form for sign-bit tests that emulate Doom C arithmetic.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `v` | `dynamic` | — | Value consumed by the operation. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_maputl.ml#L38)

<a id="global-global-pmudiaguse-pmudiaguse-src-p-maputl-ml-657436406"></a>
### _pmuDiagUse

```ml
_pmuDiagUse
```

Tracks whether pmu diag use is active in the p maputl subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_maputl.ml#L63)

<a id="global-global-pmudiagusecount-pmudiagusecount-src-p-maputl-ml-2015248134"></a>
### _pmuDiagUseCount

```ml
_pmuDiagUseCount
```

Tracks the mutable pmu diag use count value used by the p maputl subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_maputl.ml#L66)

<a id="global-global-pmudiaguseinit-pmudiaguseinit-src-p-maputl-ml-1825555838"></a>
### _pmuDiagUseInit

```ml
_pmuDiagUseInit
```

Tracks whether pmu diag use init is active in the p maputl subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_maputl.ml#L60)

<a id="function-function-pt-addlineintercept-function-pt-addlineintercept-ld-src-p-maputl-ml-272220968"></a>
### _PT_AddLineIntercept

```ml
function _PT_AddLineIntercept(ld)
```

Tests one line against the active trace and appends its in-range fractional crossing to the intercept buffer.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `ld` | `dynamic` | — | Ld value supplied to `_PT_AddLineIntercept`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_maputl.ml#L523)

<a id="function-function-pt-addthingintercept-function-pt-addthingintercept-thing-src-p-maputl-ml-1257789788"></a>
### _PT_AddThingIntercept

```ml
function _PT_AddThingIntercept(thing)
```

Approximates a thing as a trace-facing diagonal and appends an in-range crossing intercept.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `thing` | `dynamic` | — | World object affected by the operation. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_maputl.ml#L565)

<a id="function-function-pt-ensureinterceptcapacity-function-pt-ensureinterceptcapacity-need-src-p-maputl-ml-1890684112"></a>
### _PT_EnsureInterceptCapacity

```ml
function _PT_EnsureInterceptCapacity(need)
```

Lazily allocates and geometrically grows the reusable intercept array required by path traversal.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `need` | `dynamic` | — | Need value supplied to `_PT_EnsureInterceptCapacity`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_maputl.ml#L492)

<a id="global-global-earlyout-earlyout-src-p-maputl-ml-1344871104"></a>
### earlyout

```ml
earlyout
```

Tracks whether earlyout is active in the p maputl subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_maputl.ml#L472)

<a id="function-function-p-aproxdistance-inline-function-p-aproxdistance-dx-dy-src-p-maputl-ml-1670041828"></a>
### P_AproxDistance

```ml
inline function P_AproxDistance(dx, dy)
```

Computes Doom's inexpensive fixed-point distance approximation from horizontal and vertical deltas.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `dx` | `dynamic` | — | Horizontal coordinate or vector component represented by dx. |
| `dy` | `dynamic` | — | Vertical coordinate or vector component represented by dy. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_maputl.ml#L102)

<a id="function-function-p-blocklinesiterator-function-p-blocklinesiterator-x-y-func-src-p-maputl-ml-1166463331"></a>
### P_BlockLinesIterator

```ml
function P_BlockLinesIterator(x, y, func)
```

Visits each valid line in one blockmap cell once per traversal and stops immediately when the callback rejects it.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `x` | `dynamic` | — | Horizontal map- or screen-space coordinate. |
| `y` | `dynamic` | — | Vertical map- or screen-space coordinate. |
| `func` | `dynamic` | — | Func value supplied to `P_BlockLinesIterator`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_maputl.ml#L393)

<a id="function-function-p-blockthingsiterator-function-p-blockthingsiterator-x-y-func-src-p-maputl-ml-1049498313"></a>
### P_BlockThingsIterator

```ml
function P_BlockThingsIterator(x, y, func)
```

Walks the mobj chain for one blockmap cell and stops when the callback returns false.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `x` | `dynamic` | — | Horizontal map- or screen-space coordinate. |
| `y` | `dynamic` | — | Vertical map- or screen-space coordinate. |
| `func` | `dynamic` | — | Func value supplied to `P_BlockThingsIterator`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_maputl.ml#L443)

<a id="function-function-p-boxonlineside-inline-function-p-boxonlineside-tmbox-ld-src-p-maputl-ml-1842173681"></a>
### P_BoxOnLineSide

```ml
inline function P_BoxOnLineSide(tmbox, ld)
```

Classifies an axis-aligned bounding box against a line, returning -1 when the box straddles both sides.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `tmbox` | `dynamic` | — | Temporary movement bounding box to read or update. |
| `ld` | `dynamic` | — | Ld value supplied to `P_BoxOnLineSide`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_maputl.ml#L146)

<a id="function-function-p-interceptvector-inline-function-p-interceptvector-v2-v1-src-p-maputl-ml-1041643710"></a>
### P_InterceptVector

```ml
inline function P_InterceptVector(v2, v1)
```

Computes the fixed-point fraction where one divline intersects another, returning zero for parallel traces.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `v2` | `dynamic` | — | V2 value supplied to `P_InterceptVector`. |
| `v1` | `dynamic` | — | V1 value supplied to `P_InterceptVector`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_maputl.ml#L231)

<a id="function-function-p-lineopening-function-p-lineopening-linedef-src-p-maputl-ml-1220007195"></a>
### P_LineOpening

```ml
function P_LineOpening(linedef)
```

Computes the vertical opening, top, bottom, and low-floor values across a two-sided line into shared trace globals.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `linedef` | `dynamic` | — | Linedef value supplied to `P_LineOpening`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_maputl.ml#L244)

<a id="function-function-p-makedivline-inline-function-p-makedivline-li-dl-src-p-maputl-ml-1476904192"></a>
### P_MakeDivline

```ml
inline function P_MakeDivline(li, dl)
```

Copies a linedef's first vertex and direction into the lightweight divline form used by trace calculations.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `li` | `dynamic` | — | Li value supplied to `P_MakeDivline`. |
| `dl` | `dynamic` | — | Dl value supplied to `P_MakeDivline`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_maputl.ml#L220)

<a id="function-function-p-pathtraverse-function-p-pathtraverse-x1-y1-x2-y2-flags-trav-src-p-maputl-ml-2050099288"></a>
### P_PathTraverse

```ml
function P_PathTraverse(x1, y1, x2, y2, flags, trav)
```

Steps a trace through blockmap cells, collects requested line and thing crossings, sorts them by fraction, and invokes the traverser in order.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `x1` | `dynamic` | — | Horizontal coordinate of the first endpoint. |
| `y1` | `dynamic` | — | Vertical coordinate of the first endpoint. |
| `x2` | `dynamic` | — | Horizontal coordinate of the second endpoint. |
| `y2` | `dynamic` | — | Vertical coordinate of the second endpoint. |
| `flags` | `dynamic` | — | Bit flags that control the operation. |
| `trav` | `dynamic` | — | Trav value supplied to `P_PathTraverse`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_maputl.ml#L668)

<a id="function-function-p-pointondivlineside-inline-function-p-pointondivlineside-x-y-line-src-p-maputl-ml-1466543704"></a>
### P_PointOnDivlineSide

```ml
inline function P_PointOnDivlineSide(x, y, line)
```

Classifies a fixed-point point against an infinite divline using overflow-safe sign tests and scaled cross products.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `x` | `dynamic` | — | Horizontal map- or screen-space coordinate. |
| `y` | `dynamic` | — | Vertical map- or screen-space coordinate. |
| `line` | `dynamic` | — | Map line or text line affected by the operation. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_maputl.ml#L183)

<a id="function-function-p-pointonlineside-inline-function-p-pointonlineside-x-y-line-src-p-maputl-ml-457779622"></a>
### P_PointOnLineSide

```ml
inline function P_PointOnLineSide(x, y, line)
```

Classifies a fixed-point point against a partition line while preserving Doom's vertical, horizontal, and sign-bit shortcuts.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `x` | `dynamic` | — | Horizontal map- or screen-space coordinate. |
| `y` | `dynamic` | — | Vertical map- or screen-space coordinate. |
| `line` | `dynamic` | — | Map line or text line affected by the operation. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_maputl.ml#L116)

<a id="function-function-p-setthingposition-function-p-setthingposition-thing-src-p-maputl-ml-1951673242"></a>
### P_SetThingPosition

```ml
function P_SetThingPosition(thing)
```

Finds a thing's subsector and links it into sector and blockmap lists unless its flags suppress either index.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `thing` | `dynamic` | — | World object affected by the operation. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_maputl.ml#L343)

<a id="function-function-p-traverseintercepts-function-p-traverseintercepts-func-maxfrac-src-p-maputl-ml-1021342438"></a>
### P_TraverseIntercepts

```ml
function P_TraverseIntercepts(func, maxfrac)
```

Computes intercepts values for the map utility.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `func` | `dynamic` | — | Func value supplied to `P_TraverseIntercepts`. |
| `maxfrac` | `dynamic` | — | Maxfrac value supplied to `P_TraverseIntercepts`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_maputl.ml#L626)

<a id="function-function-p-unsetthingposition-function-p-unsetthingposition-thing-src-p-maputl-ml-1842751442"></a>
### P_UnsetThingPosition

```ml
function P_UnsetThingPosition(thing)
```

Unlinks a mobj from sector and blockmap chains before movement, honoring no-sector and no-blockmap flags.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `thing` | `dynamic` | — | World object affected by the operation. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_maputl.ml#L296)

<a id="function-function-pit-addlineintercepts-function-pit-addlineintercepts-ld-src-p-maputl-ml-2016716080"></a>
### PIT_AddLineIntercepts

```ml
function PIT_AddLineIntercepts(ld)
```

Adapts blockmap line iteration to the current path-traversal intercept collector.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `ld` | `dynamic` | — | Ld value supplied to `PIT_AddLineIntercepts`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_maputl.ml#L613)

<a id="function-function-pit-addthingintercepts-function-pit-addthingintercepts-thing-src-p-maputl-ml-1668637938"></a>
### PIT_AddThingIntercepts

```ml
function PIT_AddThingIntercepts(thing)
```

Adapts blockmap thing iteration to the current path-traversal intercept collector.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `thing` | `dynamic` | — | World object affected by the operation. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_maputl.ml#L619)

<a id="constant-constant-pt-addlines-const-pt-addlines-1-src-p-maputl-ml-49677682"></a>
### PT_ADDLINES

```ml
const PT_ADDLINES = 1
```

Defines pt addlines for the p maputl subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_maputl.ml#L465)

<a id="constant-constant-pt-addthings-const-pt-addthings-2-src-p-maputl-ml-786826263"></a>
### PT_ADDTHINGS

```ml
const PT_ADDTHINGS = 2
```

Defines pt addthings for the p maputl subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_maputl.ml#L467)

<a id="constant-constant-pt-earlyout-const-pt-earlyout-4-src-p-maputl-ml-348972225"></a>
### PT_EARLYOUT

```ml
const PT_EARLYOUT = 4
```

Defines pt earlyout for the p maputl subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_maputl.ml#L469)

<a id="global-global-ptflags-ptflags-src-p-maputl-ml-399459714"></a>
### ptflags

```ml
ptflags
```

Tracks the mutable ptflags value used by the p maputl subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_maputl.ml#L474)
