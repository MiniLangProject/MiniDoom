# `src/st_lib.ml`

[Home](README.md) · [Files](Files.md)

Implements reusable number, percent, multi-icon, and binary-icon widgets with classic-background restoration.

Package: [`(global)`](Package-global-1952375359.md)

Reachable from entry: **yes**

## Imports

- `doomdef.ml` → [src/doomdef.ml](File-src-doomdef-ml-460406769.md)
- `i_system.ml` → [src/i_system.ml](File-src-i-system-ml-1632920966.md)
- `m_swap.ml` → [src/m_swap.ml](File-src-m-swap-ml-1401834276.md)
- `r_defs.ml` → [src/r_defs.ml](File-src-r-defs-ml-1187974936.md)
- `r_local.ml` → [src/r_local.ml](File-src-r-local-ml-797040731.md)
- `st_stuff.ml` → [src/st_stuff.ml](File-src-st-stuff-ml-811030939.md)
- `v_video.ml` → [src/v_video.ml](File-src-v-video-ml-592999939.md)
- `w_wad.ml` → [src/w_wad.ml](File-src-w-wad-ml-893006035.md)
- `z_zone.ml` → [src/z_zone.ml](File-src-z-zone-ml-1788911354.md)

## Declarations

<a id="function-function-stl-addpatchname-function-stl-addpatchname-patch-name-src-st-lib-ml-1876238914"></a>
### _STL_AddPatchName

```ml
function _STL_AddPatchName(patch, name)
```

Appends one patch/name pair without relying on array concatenation.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `patch` | `dynamic` | — | Patch value supplied to `_STL_AddPatchName`. |
| `name` | `dynamic` | — | Resource or object name to resolve. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/st_lib.ml#L114)

<a id="function-function-stl-asbool-inline-function-stl-asbool-v-src-st-lib-ml-632075038"></a>
### _STL_AsBool

```ml
inline function _STL_AsBool(v)
```

Converts supported scalar values to the widget visibility truth convention.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `v` | `dynamic` | — | Value consumed by the operation. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/st_lib.ml#L212)

<a id="function-function-stl-drawpatchhd-function-stl-drawpatchhd-x-y-scrn-patch-src-st-lib-ml-72261712"></a>
### _STL_DrawPatchHD

```ml
function _STL_DrawPatchHD(x, y, scrn, patch)
```

Draws the classic patch and, on the foreground screen, overlays its registered high-resolution counterpart at offset-corrected coordinates.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `x` | `dynamic` | — | Horizontal map- or screen-space coordinate. |
| `y` | `dynamic` | — | Vertical map- or screen-space coordinate. |
| `scrn` | `dynamic` | — | Scrn value supplied to `_STL_DrawPatchHD`. |
| `patch` | `dynamic` | — | Patch value supplied to `_STL_DrawPatchHD`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/st_lib.ml#L177)

<a id="function-function-stl-getpatch-inline-function-stl-getpatch-patches-idx-src-st-lib-ml-1069829139"></a>
### _STL_GetPatch

```ml
inline function _STL_GetPatch(patches, idx)
```

Safely resolves one patch from an array/list after integer normalization and bounds checks.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `patches` | `dynamic` | — | Patches value supplied to `_STL_GetPatch`. |
| `idx` | `dynamic` | — | Zero-based element or table index. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/st_lib.ml#L304)

<a id="function-function-stl-getrefvalue-inline-function-stl-getrefvalue-refv-fallback-src-st-lib-ml-52715717"></a>
### _STL_GetRefValue

```ml
inline function _STL_GetRefValue(refv, fallback)
```

Dereferences the library's single-element reference convention and returns a fallback for empty or void values.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `refv` | `dynamic` | — | Refv value supplied to `_STL_GetRefValue`. |
| `fallback` | `dynamic` | — | Value returned when the requested conversion or lookup is unavailable. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/st_lib.ml#L190)

<a id="function-function-stl-idiv-inline-function-stl-idiv-a-b-src-st-lib-ml-1842179913"></a>
### _STL_IDiv

```ml
inline function _STL_IDiv(a, b)
```

Divides widget layout integers with truncation toward zero and returns zero for a zero divisor.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `a` | `dynamic` | — | First input operand. |
| `b` | `dynamic` | — | Second input operand. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/st_lib.ml#L250)

<a id="function-function-stl-nameforpatch-function-stl-nameforpatch-patch-src-st-lib-ml-762918611"></a>
### _STL_NameForPatch

```ml
function _STL_NameForPatch(patch)
```

Resolves a registered patch object back to the lump name required by the HD overlay path.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `patch` | `dynamic` | — | Patch value supplied to `_STL_NameForPatch`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/st_lib.ml#L160)

<a id="function-function-stl-patchheight-inline-function-stl-patchheight-p-src-st-lib-ml-364529094"></a>
### _STL_PatchHeight

```ml
inline function _STL_PatchHeight(p)
```

Reads the signed little-endian height from a validated Doom patch header.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `p` | `dynamic` | — | Object or data record consumed by the operation. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/st_lib.ml#L279)

<a id="function-function-stl-patchleft-inline-function-stl-patchleft-p-src-st-lib-ml-1375170434"></a>
### _STL_PatchLeft

```ml
inline function _STL_PatchLeft(p)
```

Reads the patch left offset used to restore its exact background rectangle.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `p` | `dynamic` | — | Object or data record consumed by the operation. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/st_lib.ml#L287)

<a id="function-function-stl-patchtop-inline-function-stl-patchtop-p-src-st-lib-ml-1300275712"></a>
### _STL_PatchTop

```ml
inline function _STL_PatchTop(p)
```

Reads the patch top offset used to restore its exact background rectangle.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `p` | `dynamic` | — | Object or data record consumed by the operation. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/st_lib.ml#L295)

<a id="function-function-stl-patchwidth-inline-function-stl-patchwidth-p-src-st-lib-ml-441552824"></a>
### _STL_PatchWidth

```ml
inline function _STL_PatchWidth(p)
```

Reads the signed little-endian width from a validated Doom patch header.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `p` | `dynamic` | — | Object or data record consumed by the operation. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/st_lib.ml#L271)

<a id="function-function-stl-refbool-inline-function-stl-refbool-refv-src-st-lib-ml-1557369461"></a>
### _STL_RefBool

```ml
inline function _STL_RefBool(refv)
```

Dereferences a widget value and normalizes it to a visibility boolean.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `refv` | `dynamic` | — | Refv value supplied to `_STL_RefBool`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/st_lib.ml#L222)

<a id="function-function-stl-refint-inline-function-stl-refint-refv-fallback-src-st-lib-ml-2025081077"></a>
### _STL_RefInt

```ml
inline function _STL_RefInt(refv, fallback)
```

Dereferences and truncates a widget value to an integer, retaining the supplied fallback on invalid input.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `refv` | `dynamic` | — | Refv value supplied to `_STL_RefInt`. |
| `fallback` | `dynamic` | — | Value returned when the requested conversion or lookup is unavailable. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/st_lib.ml#L263)

<a id="function-function-stl-setrefvalue-inline-function-stl-setrefvalue-refv-v-src-st-lib-ml-1052055715"></a>
### _STL_SetRefValue

```ml
inline function _STL_SetRefValue(refv, v)
```

Writes through the widget library's mutable single-element reference convention when storage is present.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `refv` | `dynamic` | — | Refv value supplied to `_STL_SetRefValue`. |
| `v` | `dynamic` | — | Value consumed by the operation. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/st_lib.ml#L203)

<a id="function-function-stl-toint-function-stl-toint-v-fallback-src-st-lib-ml-555649543"></a>
### _STL_ToInt

```ml
function _STL_ToInt(v, fallback)
```

Converts numeric/string widget values to integers by truncating toward zero, retaining the fallback on failure.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `v` | `dynamic` | — | Value consumed by the operation. |
| `fallback` | `dynamic` | — | Value returned when the requested conversion or lookup is unavailable. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/st_lib.ml#L231)

- [st_binicon_t](Type-st-binicon-t-1612450510.md) — struct
- [st_multicon_t](Type-st-multicon-t-1826441423.md) — struct
- [st_number_t](Type-st-number-t-261958813.md) — struct
- [st_percent_t](Type-st-percent-t-62785687.md) — struct
<a id="constant-constant-stlib-bg-const-stlib-bg-4-src-st-lib-ml-565105090"></a>
### STlib_BG

```ml
const STlib_BG = 4
```

Defines stlib bg for the st lib subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/st_lib.ml#L32)

<a id="function-function-stlib-drawbinicon-function-stlib-drawbinicon-b-refresh-src-st-lib-ml-1194160832"></a>
### STlib_drawBinIcon

```ml
function STlib_drawBinIcon(b, refresh)
```

Draws or erases a boolean icon only when its value changes or a full refresh is requested.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `b` | `dynamic` | — | Second input operand. |
| `refresh` | `dynamic` | — | Refresh value supplied to `STlib_drawBinIcon`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/st_lib.ml#L498)

<a id="function-function-stlib-drawmulticon-function-stlib-drawmulticon-i-refresh-src-st-lib-ml-1228763299"></a>
### STlib_drawMultIcon

```ml
function STlib_drawMultIcon(i, refresh)
```

Erases a changed prior icon from the status background and draws the newly selected patch when visible.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `i` | `dynamic` | — | Zero-based iteration index. |
| `refresh` | `dynamic` | — | Refresh value supplied to `STlib_drawMultIcon`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/st_lib.ml#L449)

<a id="function-function-stlib-drawnum-function-stlib-drawnum-n-refresh-src-st-lib-ml-1411732168"></a>
### STlib_drawNum

```ml
function STlib_drawNum(n, refresh)
```

Restores the old digit area and draws a changed fixed-width signed value right-to-left, honoring Doom's 1994 sentinel.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `n` | `dynamic` | — | Number of values to process. |
| `refresh` | `dynamic` | — | Refresh value supplied to `STlib_drawNum`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/st_lib.ml#L345)

<a id="function-function-stlib-drawpercent-function-stlib-drawpercent-p-refresh-src-st-lib-ml-668209940"></a>
### STlib_drawPercent

```ml
function STlib_drawPercent(p, refresh)
```

Draws the percent sign on refresh when visible, then updates the associated numeric widget.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `p` | `dynamic` | — | Object or data record consumed by the operation. |
| `refresh` | `dynamic` | — | Refresh value supplied to `STlib_drawPercent`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/st_lib.ml#L421)

<a id="constant-constant-stlib-fg-const-stlib-fg-0-src-st-lib-ml-2132236174"></a>
### STlib_FG

```ml
const STlib_FG = 0
```

Defines stlib fg for the st lib subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/st_lib.ml#L34)

<a id="function-function-stlib-init-function-stlib-init-src-st-lib-ml-1340308009"></a>
### STlib_init

```ml
function STlib_init()
```

Caches and registers the optional minus-sign patch used by negative numeric widgets.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/st_lib.ml#L313)

<a id="function-function-stlib-initbinicon-function-stlib-initbinicon-b-x-y-patch-val-on-src-st-lib-ml-149681206"></a>
### STlib_initBinIcon

```ml
function STlib_initBinIcon(b, x, y, patch, val, on)
```

Binds a boolean icon widget to its patch, coordinates, referenced value, and visibility control.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `b` | `dynamic` | — | Second input operand. |
| `x` | `dynamic` | — | Horizontal map- or screen-space coordinate. |
| `y` | `dynamic` | — | Vertical map- or screen-space coordinate. |
| `patch` | `dynamic` | — | Patch value supplied to `STlib_initBinIcon`. |
| `val` | `dynamic` | — | Val value supplied to `STlib_initBinIcon`. |
| `on` | `dynamic` | — | On value supplied to `STlib_initBinIcon`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/st_lib.ml#L486)

<a id="function-function-stlib-initmulticon-function-stlib-initmulticon-i-x-y-il-inum-on-src-st-lib-ml-812863844"></a>
### STlib_initMultIcon

```ml
function STlib_initMultIcon(i, x, y, il, inum, on)
```

Binds an indexed icon widget to its patch array, referenced index/visibility, coordinates, and invalid initial cache.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `i` | `dynamic` | — | Zero-based iteration index. |
| `x` | `dynamic` | — | Horizontal map- or screen-space coordinate. |
| `y` | `dynamic` | — | Vertical map- or screen-space coordinate. |
| `il` | `dynamic` | — | Il value supplied to `STlib_initMultIcon`. |
| `inum` | `dynamic` | — | Index identifying i. |
| `on` | `dynamic` | — | On value supplied to `STlib_initMultIcon`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/st_lib.ml#L437)

<a id="function-function-stlib-initnum-function-stlib-initnum-n-x-y-pl-num-on-width-src-st-lib-ml-1645784195"></a>
### STlib_initNum

```ml
function STlib_initNum(n, x, y, pl, num, on, width)
```

Binds a numeric widget to coordinates, digit patches, referenced value/visibility, and fixed digit width.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `n` | `dynamic` | — | Number of values to process. |
| `x` | `dynamic` | — | Horizontal map- or screen-space coordinate. |
| `y` | `dynamic` | — | Vertical map- or screen-space coordinate. |
| `pl` | `dynamic` | — | Pl value supplied to `STlib_initNum`. |
| `num` | `dynamic` | — | Index identifying the requested item. |
| `on` | `dynamic` | — | On value supplied to `STlib_initNum`. |
| `width` | `dynamic` | — | Width of the target in pixels or map units. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/st_lib.ml#L331)

<a id="function-function-stlib-initpercent-function-stlib-initpercent-p-x-y-pl-num-on-percentpatch-src-st-lib-ml-954277086"></a>
### STlib_initPercent

```ml
function STlib_initPercent(p, x, y, pl, num, on, percentPatch)
```

Initializes a three-digit numeric widget and attaches its percent-sign patch.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `p` | `dynamic` | — | Object or data record consumed by the operation. |
| `x` | `dynamic` | — | Horizontal map- or screen-space coordinate. |
| `y` | `dynamic` | — | Vertical map- or screen-space coordinate. |
| `pl` | `dynamic` | — | Pl value supplied to `STlib_initPercent`. |
| `num` | `dynamic` | — | Index identifying the requested item. |
| `on` | `dynamic` | — | On value supplied to `STlib_initPercent`. |
| `percentPatch` | `dynamic` | — | Percent patch value supplied to `STlib_initPercent`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/st_lib.ml#L412)

<a id="global-global-stlib-patch-name-data-stlib-patch-name-data-src-st-lib-ml-272409779"></a>
### stlib_patch_name_data

```ml
stlib_patch_name_data
```

Stores the stlib patch name data collection used by the st lib subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/st_lib.ml#L106)

<a id="global-global-stlib-patch-name-names-stlib-patch-name-names-src-st-lib-ml-1850035487"></a>
### stlib_patch_name_names

```ml
stlib_patch_name_names
```

Stores the stlib patch name names collection used by the st lib subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/st_lib.ml#L108)

<a id="function-function-stlib-registerpatchname-function-stlib-registerpatchname-patch-name-src-st-lib-ml-1995345510"></a>
### STlib_RegisterPatchName

```ml
function STlib_RegisterPatchName(patch, name)
```

Associates patch bytes with their lump name for optional HD overlays, replacing an existing mapping for the same object.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `patch` | `dynamic` | — | Patch value supplied to `STlib_RegisterPatchName`. |
| `name` | `dynamic` | — | Resource or object name to resolve. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/st_lib.ml#L142)

<a id="function-function-stlib-updatebinicon-function-stlib-updatebinicon-b-refresh-src-st-lib-ml-1747133694"></a>
### STlib_updateBinIcon

```ml
function STlib_updateBinIcon(b, refresh)
```

Shows or erases a binary icon when its referenced boolean changes or the status bar refreshes.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `b` | `dynamic` | — | Second input operand. |
| `refresh` | `dynamic` | — | Refresh value supplied to `STlib_updateBinIcon`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/st_lib.ml#L548)

<a id="function-function-stlib-updatemulticon-function-stlib-updatemulticon-i-refresh-src-st-lib-ml-1931806075"></a>
### STlib_updateMultIcon

```ml
function STlib_updateMultIcon(i, refresh)
```

Replaces a multi-icon widget when its referenced icon index changes or the status bar refreshes.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `i` | `dynamic` | — | Zero-based iteration index. |
| `refresh` | `dynamic` | — | Refresh value supplied to `STlib_updateMultIcon`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/st_lib.ml#L541)

<a id="function-function-stlib-updatenum-function-stlib-updatenum-n-refresh-src-st-lib-ml-1236166050"></a>
### STlib_updateNum

```ml
function STlib_updateNum(n, refresh)
```

Redraws an enabled numeric widget when its value changed or a full refresh was requested.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `n` | `dynamic` | — | Number of values to process. |
| `refresh` | `dynamic` | — | Refresh value supplied to `STlib_updateNum`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/st_lib.ml#L527)

<a id="function-function-stlib-updatepercent-function-stlib-updatepercent-p-refresh-src-st-lib-ml-438824462"></a>
### STlib_updatePercent

```ml
function STlib_updatePercent(p, refresh)
```

Updates a percentage widget, including its percent patch and visibility-controlled numeric value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `p` | `dynamic` | — | Object or data record consumed by the operation. |
| `refresh` | `dynamic` | — | Refresh value supplied to `STlib_updatePercent`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/st_lib.ml#L534)

<a id="global-global-sttminus-sttminus-src-st-lib-ml-599101769"></a>
### sttminus

```ml
sttminus
```

Holds the optional sttminus resource used by the st lib subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/st_lib.ml#L104)
