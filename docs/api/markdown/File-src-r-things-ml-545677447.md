# `src/r_things.ml`

[Home](README.md) · [Files](Files.md)

Builds sprite definitions, projects world/player sprites, clips them against drawsegs, and renders masked content.

Package: [`(global)`](Package-global-1952375359.md)

Reachable from entry: **yes**

## Imports

- `doomdef.ml` → [src/doomdef.ml](File-src-doomdef-ml-460406769.md)
- `doomstat.ml` → [src/doomstat.ml](File-src-doomstat-ml-1652708088.md)
- `i_system.ml` → [src/i_system.ml](File-src-i-system-ml-1632920966.md)
- `m_swap.ml` → [src/m_swap.ml](File-src-m-swap-ml-1401834276.md)
- `r_hires.ml` → [src/r_hires.ml](File-src-r-hires-ml-694005807.md)
- `r_local.ml` → [src/r_local.ml](File-src-r-local-ml-797040731.md)
- `r_upscaled.ml` → [src/r_upscaled.ml](File-src-r-upscaled-ml-1801241933.md)
- `std/math.ml` → `../MiniLangCompilerOptimization/MiniLangCompilerPy/std/math.ml` — external dependency
- `v_video.ml` → [src/v_video.ml](File-src-v-video-ml-592999939.md)
- `w_wad.ml` → [src/w_wad.ml](File-src-w-wad-ml-893006035.md)
- `z_zone.ml` → [src/z_zone.ml](File-src-z-zone-ml-1788911354.md)

## Declarations

<a id="function-function-makevissprite-inline-function-makevissprite-src-r-things-ml-1444950729"></a>
### _makeVisSprite

```ml
inline function _makeVisSprite()
```

Allocates a zeroed visible-sprite record with no linked-list neighbors or colormap.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_things.ml#L213)

<a id="function-function-rt-abs-inline-function-rt-abs-v-src-r-things-ml-1550979053"></a>
### _RT_Abs

```ml
inline function _RT_Abs(v)
```

Coerces a numeric value and returns its non-negative integer magnitude.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `v` | `dynamic` | — | Value consumed by the operation. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_things.ml#L241)

<a id="function-function-rt-angnorm-inline-function-rt-angnorm-a-src-r-things-ml-611631638"></a>
### _RT_AngNorm

```ml
inline function _RT_AngNorm(a)
```

Normalizes a numeric value to Doom's unsigned 32-bit binary-angle domain.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `a` | `dynamic` | — | First input operand. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_things.ml#L290)

<a id="function-function-rt-buildspritedef-function-rt-buildspritedef-sprname-src-r-things-ml-1648405728"></a>
### _RT_BuildSpriteDef

```ml
function _RT_BuildSpriteDef(sprname)
```

Scans the sprite lump namespace for a four-letter prefix, installs primary/flip pairs, and validates every frame rotation.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `sprname` | `dynamic` | — | Sprname value supplied to `_RT_BuildSpriteDef`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_things.ml#L465)

<a id="function-function-rt-clamp-inline-function-rt-clamp-v-lo-hi-src-r-things-ml-1825509095"></a>
### _RT_Clamp

```ml
inline function _RT_Clamp(v, lo, hi)
```

Constrains a sprite-rendering scalar to the supplied inclusive bounds.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `v` | `dynamic` | — | Value consumed by the operation. |
| `lo` | `dynamic` | — | Inclusive lower bound. |
| `hi` | `dynamic` | — | Inclusive upper bound. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_things.ml#L252)

<a id="global-global-rt-clipbot-work-rt-clipbot-work-src-r-things-ml-1661393366"></a>
### _rt_clipbot_work

```ml
_rt_clipbot_work
```

Stores the rt clipbot work collection used by the r things subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_things.ml#L90)

<a id="global-global-rt-cliptop-work-rt-cliptop-work-src-r-things-ml-23848914"></a>
### _rt_cliptop_work

```ml
_rt_cliptop_work
```

Stores the rt cliptop work collection used by the r things subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_things.ml#L93)

<a id="global-global-rt-colormap-cache-rt-colormap-cache-src-r-things-ml-1649403360"></a>
### _rt_colormap_cache

```ml
_rt_colormap_cache
```

Stores the rt colormap cache collection used by the r things subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_things.ml#L81)

<a id="global-global-rt-colormap-cache-len-rt-colormap-cache-len-src-r-things-ml-594126392"></a>
### _rt_colormap_cache_len

```ml
_rt_colormap_cache_len
```

Tracks the mutable rt colormap cache len value used by the r things subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_things.ml#L84)

<a id="function-function-rt-colormapat-inline-function-rt-colormapat-idx-src-r-things-ml-1108471472"></a>
### _RT_ColormapAt

```ml
inline function _RT_ColormapAt(idx)
```

Returns a clamped cached 256-entry COLORMAP slice and rebuilds the cache when its source length changes.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `idx` | `dynamic` | — | Zero-based element or table index. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_things.ml#L649)

<a id="global-global-rt-debug-disable-sprites-rt-debug-disable-sprites-src-r-things-ml-1235956128"></a>
### _rt_debug_disable_sprites

```ml
_rt_debug_disable_sprites
```

Tracks the mutable rt debug disable sprites value used by the r things subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_things.ml#L147)

<a id="function-function-rt-drawmaskedpatchcolumn-function-rt-drawmaskedpatchcolumn-patch-coloff-src-r-things-ml-1477215761"></a>
### _RT_DrawMaskedPatchColumn

```ml
function _RT_DrawMaskedPatchColumn(patch, coloff)
```

Decodes and clips every post in one patch column, dispatches the active column drawer, and restores shared source state.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `patch` | `dynamic` | — | Patch value supplied to `_RT_DrawMaskedPatchColumn`. |
| `coloff` | `dynamic` | — | Coloff value supplied to `_RT_DrawMaskedPatchColumn`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_things.ml#L697)

<a id="global-global-rt-drawtranslation-rt-drawtranslation-src-r-things-ml-495246052"></a>
### _rt_drawTranslation

```ml
_rt_drawTranslation
```

Holds the optional rt draw translation resource used by the r things subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_things.ml#L87)

<a id="function-function-rt-drawupscaledlinearsprite-function-rt-drawupscaledlinearsprite-vis-entry-origw-x1-x2-src-r-things-ml-930646455"></a>
### _RT_DrawUpscaledLinearSprite

```ml
function _RT_DrawUpscaledLinearSprite(vis, entry, origW, x1, x2)
```

Draws an upscaled transparent sprite image directly into the active framebuffer.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `vis` | `dynamic` | — | Vis value supplied to `_RT_DrawUpscaledLinearSprite`. |
| `entry` | `dynamic` | — | Entry value supplied to `_RT_DrawUpscaledLinearSprite`. |
| `origW` | `dynamic` | — | Orig w value supplied to `_RT_DrawUpscaledLinearSprite`. |
| `x1` | `dynamic` | — | Horizontal coordinate of the first endpoint. |
| `x2` | `dynamic` | — | Horizontal coordinate of the second endpoint. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_things.ml#L800)

<a id="function-function-rt-enumindex-inline-function-rt-enumindex-v-limit-src-r-things-ml-448765984"></a>
### _RT_EnumIndex

```ml
inline function _RT_EnumIndex(v, limit)
```

Resolves integer, numeric, or enum values to a bounded sprite-table index, returning -1 when invalid.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `v` | `dynamic` | — | Value consumed by the operation. |
| `limit` | `dynamic` | — | Limit value supplied to `_RT_EnumIndex`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_things.ml#L325)

<a id="function-function-rt-getclipvalue-inline-function-rt-getclipvalue-clipref-x-fallback-src-r-things-ml-718424062"></a>
### _RT_GetClipValue

```ml
inline function _RT_GetClipValue(clipref, x, fallback)
```

Reads a column clip from a direct sequence or x-biased openings-arena reference.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `clipref` | `dynamic` | — | Clipref value supplied to `_RT_GetClipValue`. |
| `x` | `dynamic` | — | Horizontal map- or screen-space coordinate. |
| `fallback` | `dynamic` | — | Value returned when the requested conversion or lookup is unavailable. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_things.ml#L308)

<a id="function-function-rt-idiv-inline-function-rt-idiv-a-b-src-r-things-ml-321727572"></a>
### _RT_IDiv

```ml
inline function _RT_IDiv(a, b)
```

Returns a signed quotient truncated toward zero, or zero for invalid operands and a zero divisor in `_RT_IDiv`

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `a` | `dynamic` | — | First input operand. |
| `b` | `dynamic` | — | Second input operand. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_things.ml#L231)

<a id="function-function-rt-installspritelump-function-rt-installspritelump-frames-frame-rotation-lump-flipped-sprname-maxframe-src-r-things-ml-717438544"></a>
### _RT_InstallSpriteLump

```ml
function _RT_InstallSpriteLump(frames, frame, rotation, lump, flipped, sprname, maxframe)
```

Installs one rot=0 or directional lump into a frame table while rejecting mixed, duplicate, or invalid rotations.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `frames` | `dynamic` | — | Frames value supplied to `_RT_InstallSpriteLump`. |
| `frame` | `dynamic` | — | Frame value supplied to `_RT_InstallSpriteLump`. |
| `rotation` | `dynamic` | — | Rotation value supplied to `_RT_InstallSpriteLump`. |
| `lump` | `dynamic` | — | Lump value supplied to `_RT_InstallSpriteLump`. |
| `flipped` | `dynamic` | — | Flipped value supplied to `_RT_InstallSpriteLump`. |
| `sprname` | `dynamic` | — | Sprname value supplied to `_RT_InstallSpriteLump`. |
| `maxframe` | `dynamic` | — | Maxframe value supplied to `_RT_InstallSpriteLump`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_things.ml#L412)

<a id="function-function-rt-isseq-inline-function-rt-isseq-v-src-r-things-ml-1770601213"></a>
### _RT_IsSeq

```ml
inline function _RT_IsSeq(v)
```

Recognizes the array and list containers used for sprite definitions, clips, and renderer tables.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `v` | `dynamic` | — | Value consumed by the operation. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_things.ml#L298)

<a id="function-function-rt-lumpnameat-inline-function-rt-lumpnameat-lumpnum-src-r-things-ml-1534659095"></a>
### _RT_LumpNameAt

```ml
inline function _RT_LumpNameAt(lumpnum)
```

Decodes a validated lump directory entry's zero-terminated eight-byte name.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `lumpnum` | `dynamic` | — | Index identifying lump. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_things.ml#L380)

<a id="function-function-rt-makeemptyframe-inline-function-rt-makeemptyframe-src-r-things-ml-396971181"></a>
### _RT_MakeEmptyFrame

```ml
inline function _RT_MakeEmptyFrame()
```

Creates an unresolved sprite frame with eight missing rotation lumps and unflipped defaults.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_things.ml#L220)

<a id="function-function-rt-name4-inline-function-rt-name4-s-src-r-things-ml-1651458208"></a>
### _RT_Name4

```ml
inline function _RT_Name4(s)
```

Returns the uppercase four-byte sprite prefix from a name, or an empty string when too short.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `s` | `dynamic` | — | S value supplied to `_RT_Name4`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_things.ml#L364)

<a id="global-global-rt-prof-enabled-rt-prof-enabled-src-r-things-ml-1695109118"></a>
### _rt_prof_enabled

```ml
_rt_prof_enabled
```

Tracks whether rt prof enabled is active in the r things subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_things.ml#L96)

<a id="function-function-rt-profdrawn-inline-function-rt-profdrawn-src-r-things-ml-1623117371"></a>
### _RT_ProfDrawn

```ml
inline function _RT_ProfDrawn()
```

Tracks drawn sprites for renderer profiling.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_things.ml#L172)

<a id="global-global-rt-profdrawn-rt-profdrawn-src-r-things-ml-1722052820"></a>
### _rt_profDrawn

```ml
_rt_profDrawn
```

Tracks the mutable rt prof drawn value used by the r things subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_things.ml#L108)

<a id="function-function-rt-profprojected-inline-function-rt-profprojected-src-r-things-ml-1233339811"></a>
### _RT_ProfProjected

```ml
inline function _RT_ProfProjected()
```

Tracks successful sprite projections for renderer profiling.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_things.ml#L165)

<a id="global-global-rt-profprojected-rt-profprojected-src-r-things-ml-1559487556"></a>
### _rt_profProjected

```ml
_rt_profProjected
```

Tracks the mutable rt prof projected value used by the r things subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_things.ml#L102)

<a id="function-function-rt-profreject-inline-function-rt-profreject-kind-src-r-things-ml-2067364263"></a>
### _RT_ProfReject

```ml
inline function _RT_ProfReject(kind)
```

Tracks sprite reject categories for renderer profiling.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `kind` | `dynamic` | — | Kind value supplied to `_RT_ProfReject`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_things.ml#L180)

<a id="global-global-rt-profrejected-rt-profrejected-src-r-things-ml-1506293518"></a>
### _rt_profRejected

```ml
_rt_profRejected
```

Tracks the mutable rt prof rejected value used by the r things subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_things.ml#L105)

<a id="global-global-rt-profthings-rt-profthings-src-r-things-ml-910514872"></a>
### _rt_profThings

```ml
_rt_profThings
```

Tracks the mutable rt prof things value used by the r things subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_things.ml#L99)

<a id="function-function-rt-profthingseen-inline-function-rt-profthingseen-src-r-things-ml-609996239"></a>
### _RT_ProfThingSeen

```ml
inline function _RT_ProfThingSeen()
```

Tracks visited things for renderer profiling when profiling is active.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_things.ml#L158)

<a id="function-function-rt-rebuildcolormapcache-function-rt-rebuildcolormapcache-src-r-things-ml-1447473950"></a>
### _RT_RebuildColormapCache

```ml
function _RT_RebuildColormapCache()
```

Builds reusable colormap slices to avoid per-sprite slice allocations.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_things.ml#L619)

<a id="global-global-rt-rejbaddef-rt-rejbaddef-src-r-things-ml-908146736"></a>
### _rt_rejBadDef

```ml
_rt_rejBadDef
```

Tracks the mutable rt rej bad def value used by the r things subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_things.ml#L126)

<a id="global-global-rt-rejbadframe-rt-rejbadframe-src-r-things-ml-1584215232"></a>
### _rt_rejBadFrame

```ml
_rt_rejBadFrame
```

Tracks the mutable rt rej bad frame value used by the r things subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_things.ml#L129)

<a id="global-global-rt-rejbadlump-rt-rejbadlump-src-r-things-ml-835898312"></a>
### _rt_rejBadLump

```ml
_rt_rejBadLump
```

Tracks the mutable rt rej bad lump value used by the r things subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_things.ml#L135)

<a id="global-global-rt-rejbadsprite-rt-rejbadsprite-src-r-things-ml-1362084750"></a>
### _rt_rejBadSprite

```ml
_rt_rejBadSprite
```

Tracks the mutable rt rej bad sprite value used by the r things subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_things.ml#L117)

<a id="global-global-rt-rejbehind-rt-rejbehind-src-r-things-ml-1095885068"></a>
### _rt_rejBehind

```ml
_rt_rejBehind
```

Tracks the mutable rt rej behind value used by the r things subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_things.ml#L120)

<a id="global-global-rt-rejnoframe-rt-rejnoframe-src-r-things-ml-152602250"></a>
### _rt_rejNoFrame

```ml
_rt_rejNoFrame
```

Tracks the mutable rt rej no frame value used by the r things subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_things.ml#L132)

<a id="global-global-rt-rejnosprites-rt-rejnosprites-src-r-things-ml-1708180100"></a>
### _rt_rejNoSprites

```ml
_rt_rejNoSprites
```

Tracks the mutable rt rej no sprites value used by the r things subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_things.ml#L114)

<a id="global-global-rt-rejnothing-rt-rejnothing-src-r-things-ml-462196888"></a>
### _rt_rejNoThing

```ml
_rt_rejNoThing
```

Tracks the mutable rt rej no thing value used by the r things subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_things.ml#L111)

<a id="global-global-rt-rejnovis-rt-rejnovis-src-r-things-ml-1063083296"></a>
### _rt_rejNoVis

```ml
_rt_rejNoVis
```

Tracks the mutable rt rej no vis value used by the r things subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_things.ml#L144)

<a id="global-global-rt-rejoffleft-rt-rejoffleft-src-r-things-ml-1534340562"></a>
### _rt_rejOffLeft

```ml
_rt_rejOffLeft
```

Tracks the mutable rt rej off left value used by the r things subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_things.ml#L141)

<a id="global-global-rt-rejoffright-rt-rejoffright-src-r-things-ml-1537246096"></a>
### _rt_rejOffRight

```ml
_rt_rejOffRight
```

Tracks the mutable rt rej off right value used by the r things subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_things.ml#L138)

<a id="global-global-rt-rejside-rt-rejside-src-r-things-ml-1064403072"></a>
### _rt_rejSide

```ml
_rt_rejSide
```

Tracks the mutable rt rej side value used by the r things subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_things.ml#L123)

<a id="function-function-rt-s32-inline-function-rt-s32-v-src-r-things-ml-1038021317"></a>
### _RT_S32

```ml
inline function _RT_S32(v)
```

Reinterprets the low 32 bits of a coerced numeric value as a signed coordinate.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `v` | `dynamic` | — | Value consumed by the operation. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_things.ml#L280)

<a id="function-function-rt-selectspritelights-inline-function-rt-selectspritelights-lightnum-src-r-things-ml-758246765"></a>
### _RT_SelectSpriteLights

```ml
inline function _RT_SelectSpriteLights(lightnum)
```

Selects and clamps the scale-light row used to shade sprites in the current sector.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `lightnum` | `dynamic` | — | Index identifying light. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_things.ml#L677)

<a id="function-function-rt-shadowcolormap-inline-function-rt-shadowcolormap-src-r-things-ml-1851385251"></a>
### _RT_ShadowColormap

```ml
inline function _RT_ShadowColormap()
```

Lazily caches the dark level-24 colormap used when fuzz rendering is unavailable.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_things.ml#L664)

<a id="global-global-rt-shadowmap-rt-shadowmap-src-r-things-ml-1844485080"></a>
### _rt_shadowMap

```ml
_rt_shadowMap
```

Holds the optional rt shadow map resource used by the r things subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_things.ml#L78)

<a id="global-global-rt-sorted-rt-sorted-src-r-things-ml-706072342"></a>
### _rt_sorted

```ml
_rt_sorted
```

Stores the rt sorted collection used by the r things subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_things.ml#L72)

<a id="global-global-rt-sorted-count-rt-sorted-count-src-r-things-ml-1691836506"></a>
### _rt_sorted_count

```ml
_rt_sorted_count
```

Tracks the mutable rt sorted count value used by the r things subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_things.ml#L75)

<a id="function-function-rt-sourcescalefromentry-inline-function-rt-sourcescalefromentry-entry-origw-src-r-things-ml-1399845501"></a>
### _RT_SourceScaleFromEntry

```ml
inline function _RT_SourceScaleFromEntry(entry, origW)
```

Resolves the high-resolution source scale for an upscaled sprite entry.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `entry` | `dynamic` | — | Entry value supplied to `_RT_SourceScaleFromEntry`. |
| `origW` | `dynamic` | — | Orig w value supplied to `_RT_SourceScaleFromEntry`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_things.ml#L785)

<a id="function-function-rt-spriteindex-inline-function-rt-spriteindex-v-src-r-things-ml-1218471113"></a>
### _RT_SpriteIndex

```ml
inline function _RT_SpriteIndex(v)
```

Resolves a sprite identifier against the loaded definition count.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `v` | `dynamic` | — | Value consumed by the operation. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_things.ml#L343)

<a id="function-function-rt-targetbuffer-inline-function-rt-targetbuffer-src-r-things-ml-1524515139"></a>
### _RT_TargetBuffer

```ml
inline function _RT_TargetBuffer()
```

Returns the active sprite render target.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_things.ml#L775)

<a id="function-function-rt-toint-inline-function-rt-toint-v-fallback-src-r-things-ml-1716101863"></a>
### _RT_ToInt

```ml
inline function _RT_ToInt(v, fallback)
```

Coerces numeric values to truncation-toward-zero integers and returns fallback on failure in `_RT_ToInt`

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `v` | `dynamic` | — | Value consumed by the operation. |
| `fallback` | `dynamic` | — | Value returned when the requested conversion or lookup is unavailable. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_things.ml#L262)

<a id="function-function-rt-upperascii-inline-function-rt-upperascii-c-src-r-things-ml-259601176"></a>
### _RT_UpperAscii

```ml
inline function _RT_UpperAscii(c)
```

Normalizes lowercase ASCII bytes before comparing case-insensitive WAD sprite names.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `c` | `dynamic` | — | C value supplied to `_RT_UpperAscii`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_things.ml#L356)

<a id="constant-constant-baseycenter-const-baseycenter-100-src-r-things-ml-2028234596"></a>
### BASEYCENTER

```ml
const BASEYCENTER = 100
```

Defines baseycenter for the r things subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_things.ml#L38)

<a id="constant-constant-maxvissprites-const-maxvissprites-128-src-r-things-ml-1844980386"></a>
### MAXVISSPRITES

```ml
const MAXVISSPRITES = 128
```

Defines the maximum maxvissprites accepted by the r things subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_things.ml#L34)

<a id="global-global-mceilingclip-mceilingclip-src-r-things-ml-1054438916"></a>
### mceilingclip

```ml
mceilingclip
```

Holds the optional mceilingclip resource used by the r things subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_things.ml#L57)

<a id="global-global-mfloorclip-mfloorclip-src-r-things-ml-1824304402"></a>
### mfloorclip

```ml
mfloorclip
```

Holds the optional mfloorclip resource used by the r things subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_things.ml#L55)

<a id="constant-constant-minz-const-minz-262144-src-r-things-ml-1316210862"></a>
### MINZ

```ml
const MINZ = 262144
```

Defines the minimum minz accepted by the r things subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_things.ml#L36)

<a id="global-global-negonearray-negonearray-src-r-things-ml-1735059532"></a>
### negonearray

```ml
negonearray
```

Stores the negonearray collection used by the r things subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_things.ml#L50)

<a id="global-global-pspriteiscale-pspriteiscale-src-r-things-ml-2045670152"></a>
### pspriteiscale

```ml
pspriteiscale
```

Tracks the mutable pspriteiscale value used by the r things subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_things.ml#L66)

<a id="global-global-pspritescale-pspritescale-src-r-things-ml-1492358542"></a>
### pspritescale

```ml
pspritescale
```

Tracks the mutable pspritescale value used by the r things subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_things.ml#L64)

<a id="function-function-r-addpsprites-function-r-addpsprites-src-r-things-ml-131247462"></a>
### R_AddPSprites

```ml
function R_AddPSprites()
```

Draws the display player's first-person weapon/flash layers after validating player ownership.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_things.ml#L1161)

<a id="function-function-r-addsprites-function-r-addsprites-sec-src-r-things-ml-583186175"></a>
### R_AddSprites

```ml
function R_AddSprites(sec)
```

Projects each non-viewplayer thing in a sector once per validcount using that sector's light row.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `sec` | `dynamic` | — | Sec value supplied to `R_AddSprites`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_things.ml#L1133)

<a id="function-function-r-clearsprites-function-r-clearsprites-src-r-things-ml-1116153862"></a>
### R_ClearSprites

```ml
function R_ClearSprites()
```

Resets the visible-sprite pool, sorting/clipping workspaces, profiler counters, and sentinel list for a new frame.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_things.ml#L527)

<a id="function-function-r-clipvissprite-function-r-clipvissprite-vis-xl-xh-src-r-things-ml-917264814"></a>
### R_ClipVisSprite

```ml
function R_ClipVisSprite(vis, xl, xh)
```

Retains the classic clipping hook; drawseg silhouette clipping is integrated into R_DrawSprite.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `vis` | `dynamic` | — | Vis value supplied to `R_ClipVisSprite`. |
| `xl` | `dynamic` | — | Xl value supplied to `R_ClipVisSprite`. |
| `xh` | `dynamic` | — | Xh value supplied to `R_ClipVisSprite`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_things.ml#L1500)

<a id="function-function-r-drawmasked-function-r-drawmasked-src-r-things-ml-1867631602"></a>
### R_DrawMasked

```ml
function R_DrawMasked()
```

Draws sorted world sprites, remaining masked wall ranges, and first-person sprites in final masked-pass order.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_things.ml#L1509)

<a id="function-function-r-drawmaskedcolumn-function-r-drawmaskedcolumn-column-src-r-things-ml-957953800"></a>
### R_DrawMaskedColumn

```ml
function R_DrawMaskedColumn(column)
```

Retains the classic public hook; patch-column decoding is handled by _RT_DrawMaskedPatchColumn with explicit bytes and offsets.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `column` | `dynamic` | — | Column value supplied to `R_DrawMaskedColumn`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_things.ml#L768)

<a id="function-function-r-drawplayersprites-function-r-drawplayersprites-player-src-r-things-ml-1026172293"></a>
### R_DrawPlayerSprites

```ml
function R_DrawPlayerSprites(player)
```

Selects the player's sector lighting, disables world clipping, and draws each active first-person sprite layer.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `player` | `dynamic` | — | Player state affected by the operation. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_things.ml#L1469)

<a id="function-function-r-drawpsprite-function-r-drawpsprite-player-psp-src-r-things-ml-1969520816"></a>
### R_DrawPSprite

```ml
function R_DrawPSprite(player, psp)
```

Projects one weapon/flash state in screen space, selects invisibility or lighting colormap, and draws its patch.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `player` | `dynamic` | — | Player state affected by the operation. |
| `psp` | `dynamic` | — | Psp value supplied to `R_DrawPSprite`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_things.ml#L1390)

<a id="function-function-r-drawsprite-function-r-drawsprite-spr-src-r-things-ml-1106248085"></a>
### R_DrawSprite

```ml
function R_DrawSprite(spr)
```

Builds per-column top/bottom clips from overlapping drawseg silhouettes, draws nearer masked walls, then renders the sprite.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `spr` | `dynamic` | — | Spr value supplied to `R_DrawSprite`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_things.ml#L1203)

<a id="function-function-r-drawsprites-function-r-drawsprites-src-r-things-ml-1862688800"></a>
### R_DrawSprites

```ml
function R_DrawSprites()
```

Sorts and renders all projected world sprites unless the sprite debug-disable flag is set.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_things.ml#L1322)

<a id="function-function-r-drawvissprite-function-r-drawvissprite-vis-x1-x2-src-r-things-ml-2004940949"></a>
### R_DrawVisSprite

```ml
function R_DrawVisSprite(vis, x1, x2)
```

Selects fuzz/translation/base drawing, maps screen columns to patch columns, and renders a clipped visible sprite.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `vis` | `dynamic` | — | Vis value supplied to `R_DrawVisSprite`. |
| `x1` | `dynamic` | — | Horizontal coordinate of the first endpoint. |
| `x2` | `dynamic` | — | Horizontal coordinate of the second endpoint. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_things.ml#L886)

<a id="function-function-r-initspritedefs-function-r-initspritedefs-namelist-src-r-things-ml-3851591"></a>
### R_InitSpriteDefs

```ml
function R_InitSpriteDefs(namelist)
```

Compatibility entry point that rebuilds sprite definitions and clip arrays from a name list.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `namelist` | `dynamic` | — | Namelist value supplied to `R_InitSpriteDefs`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_things.ml#L1382)

<a id="function-function-r-initsprites-function-r-initsprites-namelist-src-r-things-ml-1855192337"></a>
### R_InitSprites

```ml
function R_InitSprites(namelist)
```

Sizes sprite clip sentinels and builds every named sprite definition from the WAD sprite-lump range.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `namelist` | `dynamic` | — | Namelist value supplied to `R_InitSprites`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_things.ml#L1338)

<a id="function-function-r-installspritelump-function-r-installspritelump-lump-frame-rotation-flipped-src-r-things-ml-2000652329"></a>
### R_InstallSpriteLump

```ml
function R_InstallSpriteLump(lump, frame, rotation, flipped)
```

Retains the classic public hook; sprite-lump installation is performed on explicit frame arrays by the internal builder.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `lump` | `dynamic` | — | Lump value supplied to `R_InstallSpriteLump`. |
| `frame` | `dynamic` | — | Frame value supplied to `R_InstallSpriteLump`. |
| `rotation` | `dynamic` | — | Rotation value supplied to `R_InstallSpriteLump`. |
| `flipped` | `dynamic` | — | Flipped value supplied to `R_InstallSpriteLump`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_things.ml#L394)

<a id="function-function-r-newvissprite-function-r-newvissprite-src-r-things-ml-1508072646"></a>
### R_NewVisSprite

```ml
function R_NewVisSprite()
```

Reserves the next preallocated visible-sprite record, returning void when MAXVISSPRITES is exhausted.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_things.ml#L608)

<a id="function-function-r-projectsprite-function-r-projectsprite-thing-src-r-things-ml-755758406"></a>
### R_ProjectSprite

```ml
function R_ProjectSprite(thing)
```

Transforms a world mobj into screen bounds, selects rotation/flip/light, and appends a visible sprite when in view.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `thing` | `dynamic` | — | World object affected by the operation. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_things.ml#L973)

<a id="function-function-r-sortvissprites-function-r-sortvissprites-src-r-things-ml-884051462"></a>
### R_SortVisSprites

```ml
function R_SortVisSprites()
```

Copies active visible sprites into reusable storage and insertion-sorts them back-to-front by projection scale.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_things.ml#L1171)

<a id="function-function-r-thingsprofilesetenabled-function-r-thingsprofilesetenabled-on-src-r-things-ml-974293169"></a>
### R_ThingsProfileSetEnabled

```ml
function R_ThingsProfileSetEnabled(on)
```

Enables or disables sprite/render profiling counters in hot paths.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `on` | `dynamic` | — | On value supplied to `R_ThingsProfileSetEnabled`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_things.ml#L151)

<a id="constant-constant-rt-transparent-index-const-rt-transparent-index-255-src-r-things-ml-1719175001"></a>
### RT_TRANSPARENT_INDEX

```ml
const RT_TRANSPARENT_INDEX = 255
```

Defines rt transparent index for the r things subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_things.ml#L40)

<a id="global-global-screenheightarray-screenheightarray-src-r-things-ml-733710140"></a>
### screenheightarray

```ml
screenheightarray
```

Stores the screenheightarray collection used by the r things subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_things.ml#L52)

<a id="global-global-spritelights-spritelights-src-r-things-ml-784418588"></a>
### spritelights

```ml
spritelights
```

Holds the optional spritelights resource used by the r things subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_things.ml#L68)

<a id="global-global-sprtopscreen-sprtopscreen-src-r-things-ml-1423846736"></a>
### sprtopscreen

```ml
sprtopscreen
```

Tracks the mutable sprtopscreen value used by the r things subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_things.ml#L61)

<a id="global-global-spryscale-spryscale-src-r-things-ml-130694176"></a>
### spryscale

```ml
spryscale
```

Tracks the mutable spryscale value used by the r things subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_things.ml#L59)

<a id="global-global-vissprite-p-vissprite-p-src-r-things-ml-386921084"></a>
### vissprite_p

```ml
vissprite_p
```

Tracks the mutable vissprite p value used by the r things subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_things.ml#L45)

<a id="global-global-vissprites-vissprites-src-r-things-ml-1399307624"></a>
### vissprites

```ml
vissprites
```

Stores the vissprites collection used by the r things subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_things.ml#L43)

<a id="global-global-vsprsortedhead-vsprsortedhead-src-r-things-ml-1101749904"></a>
### vsprsortedhead

```ml
vsprsortedhead
```

Holds the optional vsprsortedhead resource used by the r things subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_things.ml#L47)
