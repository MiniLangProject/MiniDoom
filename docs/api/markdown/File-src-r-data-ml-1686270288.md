# `src/r_data.ml`

[Home](README.md) · [Files](Files.md)

Parses texture definitions and exposes cached flat, wall-column, sprite, colormap, and level-precache data to renderers.

Package: [`(global)`](Package-global-1952375359.md)

Reachable from entry: **yes**

## Imports

- `doomdef.ml` → [src/doomdef.ml](File-src-doomdef-ml-460406769.md)
- `doomstat.ml` → [src/doomstat.ml](File-src-doomstat-ml-1652708088.md)
- `i_system.ml` → [src/i_system.ml](File-src-i-system-ml-1632920966.md)
- `m_swap.ml` → [src/m_swap.ml](File-src-m-swap-ml-1401834276.md)
- `p_local.ml` → [src/p_local.ml](File-src-p-local-ml-1043095437.md)
- `r_defs.ml` → [src/r_defs.ml](File-src-r-defs-ml-1187974936.md)
- `r_local.ml` → [src/r_local.ml](File-src-r-local-ml-797040731.md)
- `r_sky.ml` → [src/r_sky.ml](File-src-r-sky-ml-918225537.md)
- `r_state.ml` → [src/r_state.ml](File-src-r-state-ml-691819649.md)
- `r_upscaled.ml` → [src/r_upscaled.ml](File-src-r-upscaled-ml-1801241933.md)
- `w_wad.ml` → [src/w_wad.ml](File-src-w-wad-ml-893006035.md)
- `z_zone.ml` → [src/z_zone.ml](File-src-z-zone-ml-1788911354.md)

## Declarations

<a id="function-function-allocintarray-inline-function-allocintarray-n-fill-src-r-data-ml-1791096903"></a>
### _allocIntArray

```ml
inline function _allocIntArray(n, fill)
```

Allocates a filled array after normalizing invalid or negative requested lengths to zero.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `n` | `dynamic` | — | Number of values to process. |
| `fill` | `dynamic` | — | Fill value supplied to `_allocIntArray`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_data.ml#L130)

<a id="function-function-nameto8-inline-function-nameto8-name-src-r-data-ml-1531125689"></a>
### _nameTo8

```ml
inline function _nameTo8(name)
```

Truncates a resource name to Doom's eight-character lookup limit while leaving shorter names unchanged.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `name` | `dynamic` | — | Resource or object name to resolve. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_data.ml#L191)

<a id="global-global-r-allspritesprecached-r-allspritesprecached-src-r-data-ml-443900267"></a>
### _r_allSpritesPrecached

```ml
_r_allSpritesPrecached
```

Tracks whether r all sprites precached is active in the r data subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_data.ml#L102)

<a id="function-function-rd-clamp-inline-function-rd-clamp-v-lo-hi-src-r-data-ml-1316150864"></a>
### _rd_clamp

```ml
inline function _rd_clamp(v, lo, hi)
```

Restricts a texture dimension, index, or allocation size to caller-supplied inclusive bounds.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `v` | `dynamic` | — | Value consumed by the operation. |
| `lo` | `dynamic` | — | Inclusive lower bound. |
| `hi` | `dynamic` | — | Inclusive upper bound. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_data.ml#L150)

<a id="function-function-rd-drawcolumnincacheat-function-rd-drawcolumnincacheat-patchbytes-coloff-cache-cacheoff-originy-cacheheight-src-r-data-ml-2021901064"></a>
### _rd_drawColumnInCacheAt

```ml
function _rd_drawColumnInCacheAt(patchBytes, colOff, cache, cacheOff, originy, cacheheight)
```

Decodes a patch column from an explicit lump offset into a selected vertical region of a shared composite buffer.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `patchBytes` | `dynamic` | — | Patch bytes value supplied to `_rd_drawColumnInCacheAt`. |
| `colOff` | `dynamic` | — | Col off value supplied to `_rd_drawColumnInCacheAt`. |
| `cache` | `dynamic` | — | Cache value supplied to `_rd_drawColumnInCacheAt`. |
| `cacheOff` | `dynamic` | — | Cache off value supplied to `_rd_drawColumnInCacheAt`. |
| `originy` | `dynamic` | — | Vertical coordinate or vector component represented by originy. |
| `cacheheight` | `dynamic` | — | Height of cache in pixels or map units. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_data.ml#L493)

<a id="function-function-rd-drawpatchcolumntocanvas-function-rd-drawpatchcolumntocanvas-patchbytes-coloff-canvas-texw-texh-dstx-originy-src-r-data-ml-309526928"></a>
### _rd_drawPatchColumnToCanvas

```ml
function _rd_drawPatchColumnToCanvas(patchBytes, colOff, canvas, texW, texH, dstX, originY)
```

Decodes a patch column's transparent posts into one clipped x position of a row-major composite canvas.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `patchBytes` | `dynamic` | — | Patch bytes value supplied to `_rd_drawPatchColumnToCanvas`. |
| `colOff` | `dynamic` | — | Col off value supplied to `_rd_drawPatchColumnToCanvas`. |
| `canvas` | `dynamic` | — | Canvas value supplied to `_rd_drawPatchColumnToCanvas`. |
| `texW` | `dynamic` | — | Tex w value supplied to `_rd_drawPatchColumnToCanvas`. |
| `texH` | `dynamic` | — | Tex h value supplied to `_rd_drawPatchColumnToCanvas`. |
| `dstX` | `dynamic` | — | Horizontal coordinate or vector component represented by dst x. |
| `originY` | `dynamic` | — | Vertical coordinate or vector component represented by origin y. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_data.ml#L361)

<a id="function-function-rd-ensurecolumncache-inline-function-rd-ensurecolumncache-tex-width-src-r-data-ml-309228381"></a>
### _rd_ensureColumnCache

```ml
inline function _rd_ensureColumnCache(tex, width)
```

Returns a texture's correctly sized lazy column-cache array, replacing malformed storage when necessary.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `tex` | `dynamic` | — | Texture identifier or texture data to process. |
| `width` | `dynamic` | — | Width of the target in pixels or map units. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_data.ml#L869)

<a id="function-function-rd-enumindex-inline-function-rd-enumindex-v-limit-src-r-data-ml-572440819"></a>
### _rd_enumIndex

```ml
inline function _rd_enumIndex(v, limit)
```

Converts integer-like or enum metadata to a validated zero-based index below a caller limit.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `v` | `dynamic` | — | Value consumed by the operation. |
| `limit` | `dynamic` | — | Limit value supplied to `_rd_enumIndex`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_data.ml#L259)

<a id="function-function-rd-generatetexturecomposite-function-rd-generatetexturecomposite-texnum-src-r-data-ml-1550425460"></a>
### _rd_generateTextureComposite

```ml
function _rd_generateTextureComposite(texnum)
```

Overlays every placed patch into a row-major wall canvas and caches independent vertical columns for fallback sampling.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `texnum` | `dynamic` | — | Index identifying tex. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_data.ml#L387)

<a id="function-function-rd-getupscaledtexturecolumn-function-rd-getupscaledtexturecolumn-tex-col-src-r-data-ml-1742938958"></a>
### _rd_getUpscaledTextureColumn

```ml
function _rd_getUpscaledTextureColumn(tex, col)
```

Returns a column from an upscaled composited wall texture, if available.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `tex` | `dynamic` | — | Texture identifier or texture data to process. |
| `col` | `dynamic` | — | Col value supplied to `_rd_getUpscaledTextureColumn`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_data.ml#L888)

<a id="function-function-rd-i16-inline-function-rd-i16-b-off-src-r-data-ml-1340043857"></a>
### _rd_i16

```ml
inline function _rd_i16(b, off)
```

Delegates signed 16-bit little-endian decoding for texture directory fields.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `b` | `dynamic` | — | Second input operand. |
| `off` | `dynamic` | — | Zero-based byte or element offset. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_data.ml#L232)

<a id="function-function-rd-i32-inline-function-rd-i32-b-off-src-r-data-ml-296002481"></a>
### _rd_i32

```ml
inline function _rd_i32(b, off)
```

Delegates signed 32-bit little-endian decoding for texture counts and offsets.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `b` | `dynamic` | — | Second input operand. |
| `off` | `dynamic` | — | Zero-based byte or element offset. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_data.ml#L240)

<a id="function-function-rd-idiv-inline-function-rd-idiv-a-b-src-r-data-ml-788735663"></a>
### _rd_idiv

```ml
inline function _rd_idiv(a, b)
```

Performs integer division with truncation toward zero.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `a` | `dynamic` | — | First input operand. |
| `b` | `dynamic` | — | Second input operand. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_data.ml#L160)

<a id="function-function-rd-isseq-inline-function-rd-isseq-v-src-r-data-ml-284176874"></a>
### _rd_isSeq

```ml
inline function _rd_isSeq(v)
```

Recognizes both array and list containers accepted by renderer resource tables.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `v` | `dynamic` | — | Value consumed by the operation. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_data.ml#L140)

<a id="function-function-rd-loadpulse-inline-function-rd-loadpulse-iter-src-r-data-ml-431569554"></a>
### _rd_loadPulse

```ml
inline function _rd_loadPulse(iter)
```

Pumps window/audio updates periodically while expensive renderer precache loops run.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `iter` | `dynamic` | — | Iter value supplied to `_rd_loadPulse`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_data.ml#L282)

<a id="function-function-rd-markpresent-inline-function-rd-markpresent-arr-idx-src-r-data-ml-1258030290"></a>
### _rd_markPresent

```ml
inline function _rd_markPresent(arr, idx)
```

Sets one validated resource-usage bitmap entry without risking malformed map indices.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `arr` | `dynamic` | — | Arr value supplied to `_rd_markPresent`. |
| `idx` | `dynamic` | — | Zero-based element or table index. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_data.ml#L248)

<a id="function-function-rd-parsetexturelump-function-rd-parsetexturelump-lumpname-patchlookup-src-r-data-ml-978070398"></a>
### _rd_parseTextureLump

```ml
function _rd_parseTextureLump(lumpname, patchlookup)
```

Decodes one optional TEXTURE directory into normalized definitions and resolves each PNAMES patch reference to a lump.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `lumpname` | `dynamic` | — | Lumpname value supplied to `_rd_parseTextureLump`. |
| `patchlookup` | `dynamic` | — | Patchlookup value supplied to `_rd_parseTextureLump`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_data.ml#L299)

<a id="function-function-rd-uppername8-function-rd-uppername8-v-src-r-data-ml-1815038761"></a>
### _rd_upperName8

```ml
function _rd_upperName8(v)
```

Normalizes string or byte resource names to uppercase, zero-terminated, at-most-eight-character text.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `v` | `dynamic` | — | Value consumed by the operation. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_data.ml#L206)

<a id="function-function-rd-wrapcolumn-inline-function-rd-wrapcolumn-col-mask-width-src-r-data-ml-2057426568"></a>
### _rd_wrapColumn

```ml
inline function _rd_wrapColumn(col, mask, width)
```

Wraps a requested wall column through its width mask and corrects non-power-of-two or negative results.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `col` | `dynamic` | — | Col value supplied to `_rd_wrapColumn`. |
| `mask` | `dynamic` | — | Mask value supplied to `_rd_wrapColumn`. |
| `width` | `dynamic` | — | Width of the target in pixels or map units. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_data.ml#L172)

<a id="global-global-colormaps-colormaps-src-r-data-ml-970007311"></a>
### colormaps

```ml
colormaps
```

Holds the optional colormaps resource used by the r data subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_data.ml#L92)

<a id="global-global-firstflat-firstflat-src-r-data-ml-1537080211"></a>
### firstflat

```ml
firstflat
```

Tracks the mutable firstflat value used by the r data subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_data.ml#L35)

<a id="global-global-firstpatch-firstpatch-src-r-data-ml-1462214039"></a>
### firstpatch

```ml
firstpatch
```

Tracks the mutable firstpatch value used by the r data subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_data.ml#L42)

<a id="global-global-firstspritelump-firstspritelump-src-r-data-ml-405197987"></a>
### firstspritelump

```ml
firstspritelump
```

Tracks the mutable firstspritelump value used by the r data subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_data.ml#L49)

<a id="global-global-flatmemory-flatmemory-src-r-data-ml-1653788171"></a>
### flatmemory

```ml
flatmemory
```

Tracks the mutable flatmemory value used by the r data subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_data.ml#L95)

<a id="global-global-flattranslation-flattranslation-src-r-data-ml-1349780491"></a>
### flattranslation

```ml
flattranslation
```

Holds the optional flattranslation resource used by the r data subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_data.ml#L76)

<a id="global-global-lastflat-lastflat-src-r-data-ml-2012275897"></a>
### lastflat

```ml
lastflat
```

Tracks the mutable lastflat value used by the r data subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_data.ml#L37)

<a id="global-global-lastpatch-lastpatch-src-r-data-ml-917786667"></a>
### lastpatch

```ml
lastpatch
```

Tracks the mutable lastpatch value used by the r data subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_data.ml#L44)

<a id="global-global-lastspritelump-lastspritelump-src-r-data-ml-1197594713"></a>
### lastspritelump

```ml
lastspritelump
```

Tracks the mutable lastspritelump value used by the r data subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_data.ml#L51)

<a id="global-global-numflats-numflats-src-r-data-ml-475395075"></a>
### numflats

```ml
numflats
```

Tracks the mutable numflats value used by the r data subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_data.ml#L39)

<a id="global-global-numpatches-numpatches-src-r-data-ml-1935691427"></a>
### numpatches

```ml
numpatches
```

Tracks the mutable numpatches value used by the r data subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_data.ml#L46)

<a id="global-global-numspritelumps-numspritelumps-src-r-data-ml-646173487"></a>
### numspritelumps

```ml
numspritelumps
```

Tracks the mutable numspritelumps value used by the r data subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_data.ml#L53)

<a id="global-global-numtextures-numtextures-src-r-data-ml-337017599"></a>
### numtextures

```ml
numtextures
```

Tracks the mutable numtextures value used by the r data subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_data.ml#L56)

<a id="function-function-r-checktexturenumforname-function-r-checktexturenumforname-name-src-r-data-ml-779540780"></a>
### R_CheckTextureNumForName

```ml
function R_CheckTextureNumForName(name)
```

Resolves a normalized wall-texture name without failure, treating Doom's '-' no-texture marker as index zero.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `name` | `dynamic` | — | Resource or object name to resolve. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_data.ml#L1052)

<a id="function-function-r-drawcolumnincache-function-r-drawcolumnincache-patch-cache-originy-cacheheight-src-r-data-ml-2009713495"></a>
### R_DrawColumnInCache

```ml
function R_DrawColumnInCache(patch, cache, originy, cacheheight)
```

Decodes a patch-column post stream into a clipped vertical cache at the requested texture y origin.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `patch` | `dynamic` | — | Patch value supplied to `R_DrawColumnInCache`. |
| `cache` | `dynamic` | — | Cache value supplied to `R_DrawColumnInCache`. |
| `originy` | `dynamic` | — | Vertical coordinate or vector component represented by originy. |
| `cacheheight` | `dynamic` | — | Height of cache in pixels or map units. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_data.ml#L452)

<a id="function-function-r-flatnumforname-function-r-flatnumforname-name-src-r-data-ml-340882992"></a>
### R_FlatNumForName

```ml
function R_FlatNumForName(name)
```

Resolves an eight-character flat name to its range-relative index and treats missing required flats as fatal.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `name` | `dynamic` | — | Resource or object name to resolve. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_data.ml#L696)

<a id="function-function-r-generatecomposite-function-r-generatecomposite-texnum-src-r-data-ml-374801974"></a>
### R_GenerateComposite

```ml
function R_GenerateComposite(texnum)
```

Materializes only columns requiring multiple patch overlays into the packed composite layout computed by the lookup pass.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `texnum` | `dynamic` | — | Index identifying tex. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_data.ml#L530)

<a id="function-function-r-generatelookup-function-r-generatelookup-texnum-src-r-data-ml-1845411340"></a>
### R_GenerateLookup

```ml
function R_GenerateLookup(texnum)
```

Classifies each texture column as direct single-patch data or composite storage and assigns its lump and byte offset.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `texnum` | `dynamic` | — | Index identifying tex. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_data.ml#L589)

<a id="function-function-r-getcolumn-function-r-getcolumn-tex-col-src-r-data-ml-1532254948"></a>
### R_GetColumn

```ml
function R_GetColumn(tex, col)
```

Returns a wrapped wall column from HD data, the lazy cache, a direct patch post, or a generated composite in that order.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `tex` | `dynamic` | — | Texture identifier or texture data to process. |
| `col` | `dynamic` | — | Col value supplied to `R_GetColumn`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_data.ml#L944)

<a id="function-function-r-getflat-function-r-getflat-flatnum-src-r-data-ml-951115176"></a>
### R_GetFlat

```ml
function R_GetFlat(flatnum)
```

Applies flat animation translation, validates the resulting range, and returns the cached lump bytes.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `flatnum` | `dynamic` | — | Index identifying flat. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_data.ml#L710)

<a id="function-function-r-getmaskedcolumnraw-function-r-getmaskedcolumnraw-tex-col-src-r-data-ml-978831622"></a>
### R_GetMaskedColumnRaw

```ml
function R_GetMaskedColumnRaw(tex, col)
```

Returns the source patch bytes and post-stream offset for a wrapped direct masked column, rejecting composite columns.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `tex` | `dynamic` | — | Texture identifier or texture data to process. |
| `col` | `dynamic` | — | Col value supplied to `R_GetMaskedColumnRaw`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_data.ml#L1017)

<a id="function-function-r-initcolormaps-function-r-initcolormaps-src-r-data-ml-403085999"></a>
### R_InitColormaps

```ml
function R_InitColormaps()
```

Pins the COLORMAP lump as the renderer's static light-remapping table.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_data.ml#L754)

<a id="function-function-r-initdata-function-r-initdata-src-r-data-ml-1980897465"></a>
### R_InitData

```ml
function R_InitData()
```

Initializes wall textures, flats, sprite metrics, colormaps, and sky identifiers in dependency-safe order.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_data.ml#L1286)

<a id="function-function-r-initflats-function-r-initflats-src-r-data-ml-1811720223"></a>
### R_InitFlats

```ml
function R_InitFlats()
```

Resolves the F_START/F_END flat range and seeds an identity animation-translation table.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_data.ml#L675)

<a id="function-function-r-initspritelumps-function-r-initspritelumps-src-r-data-ml-1665630727"></a>
### R_InitSpriteLumps

```ml
function R_InitSpriteLumps()
```

Resolves the sprite lump range and precomputes fixed-point width, left offset, and top offset for every patch.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_data.ml#L722)

<a id="function-function-r-inittextures-function-r-inittextures-src-r-data-ml-2134412345"></a>
### R_InitTextures

```ml
function R_InitTextures()
```

Resolves PNAMES and texture directories, allocates animation/column caches, and classifies every wall-texture column.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_data.ml#L764)

<a id="function-function-r-precachelevel-function-r-precachelevel-src-r-data-ml-1678477413"></a>
### R_PrecacheLevel

```ml
function R_PrecacheLevel()
```

Marks flats, textures, patches, and sprite frames referenced by the current level, caches them, and totals their memory use.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_data.ml#L1086)

<a id="function-function-r-texturenumforname-function-r-texturenumforname-name-src-r-data-ml-915454452"></a>
### R_TextureNumForName

```ml
function R_TextureNumForName(name)
```

Resolves a required wall texture and falls back to index zero while optionally logging missing names in developer mode.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `name` | `dynamic` | — | Resource or object name to resolve. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_data.ml#L1073)

<a id="global-global-rd-column-source-scale-rd-column-source-scale-src-r-data-ml-295662171"></a>
### rd_column_source_scale

```ml
rd_column_source_scale
```

Tracks the mutable rd column source scale value used by the r data subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_data.ml#L82)

- [rd_texpatch_t](Type-rd-texpatch-t-790542914.md) — struct
- [rd_texture_t](Type-rd-texture-t-1886167628.md) — struct
<a id="global-global-rd-upscaledtexturecolumncache-rd-upscaledtexturecolumncache-src-r-data-ml-1819765455"></a>
### rd_upscaledtexturecolumncache

```ml
rd_upscaledtexturecolumncache
```

Holds the optional rd upscaledtexturecolumncache resource used by the r data subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_data.ml#L80)

<a id="global-global-spritememory-spritememory-src-r-data-ml-1240245563"></a>
### spritememory

```ml
spritememory
```

Tracks the mutable spritememory value used by the r data subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_data.ml#L99)

<a id="global-global-spriteoffset-spriteoffset-src-r-data-ml-907836723"></a>
### spriteoffset

```ml
spriteoffset
```

Holds the optional spriteoffset resource used by the r data subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_data.ml#L87)

<a id="global-global-spritetopoffset-spritetopoffset-src-r-data-ml-950049747"></a>
### spritetopoffset

```ml
spritetopoffset
```

Holds the optional spritetopoffset resource used by the r data subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_data.ml#L89)

<a id="global-global-spritewidth-spritewidth-src-r-data-ml-659779703"></a>
### spritewidth

```ml
spritewidth
```

Holds the optional spritewidth resource used by the r data subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_data.ml#L85)

<a id="global-global-texturecolumncache-texturecolumncache-src-r-data-ml-2098834361"></a>
### texturecolumncache

```ml
texturecolumncache
```

Holds the optional texturecolumncache resource used by the r data subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_data.ml#L73)

<a id="global-global-texturecolumnlump-texturecolumnlump-src-r-data-ml-1198454591"></a>
### texturecolumnlump

```ml
texturecolumnlump
```

Holds the optional texturecolumnlump resource used by the r data subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_data.ml#L67)

<a id="global-global-texturecolumnofs-texturecolumnofs-src-r-data-ml-1764899789"></a>
### texturecolumnofs

```ml
texturecolumnofs
```

Holds the optional texturecolumnofs resource used by the r data subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_data.ml#L69)

<a id="global-global-texturecomposite-texturecomposite-src-r-data-ml-2108373963"></a>
### texturecomposite

```ml
texturecomposite
```

Holds the optional texturecomposite resource used by the r data subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_data.ml#L71)

<a id="global-global-texturecompositesize-texturecompositesize-src-r-data-ml-2081277013"></a>
### texturecompositesize

```ml
texturecompositesize
```

Holds the optional texturecompositesize resource used by the r data subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_data.ml#L65)

<a id="global-global-textureheight-textureheight-src-r-data-ml-618115003"></a>
### textureheight

```ml
textureheight
```

Holds the optional textureheight resource used by the r data subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_data.ml#L63)

<a id="global-global-texturememory-texturememory-src-r-data-ml-178597903"></a>
### texturememory

```ml
texturememory
```

Tracks the mutable texturememory value used by the r data subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_data.ml#L97)

<a id="global-global-textures-textures-src-r-data-ml-2025659175"></a>
### textures

```ml
textures
```

Holds the optional textures resource used by the r data subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_data.ml#L58)

<a id="global-global-texturetranslation-texturetranslation-src-r-data-ml-1768665339"></a>
### texturetranslation

```ml
texturetranslation
```

Holds the optional texturetranslation resource used by the r data subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_data.ml#L78)

<a id="global-global-texturewidthmask-texturewidthmask-src-r-data-ml-859590261"></a>
### texturewidthmask

```ml
texturewidthmask
```

Holds the optional texturewidthmask resource used by the r data subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_data.ml#L61)
