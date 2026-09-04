# `src/r_segs.ml`

[Home](README.md) · [Files](Files.md)

Projects BSP wall segments into columns, maintains clip openings, and defers masked middle textures.

Package: [`(global)`](Package-global-1952375359.md)

Reachable from entry: **yes**

## Imports

- `doomdef.ml` → [src/doomdef.ml](File-src-doomdef-ml-460406769.md)
- `doomstat.ml` → [src/doomstat.ml](File-src-doomstat-ml-1652708088.md)
- `i_system.ml` → [src/i_system.ml](File-src-i-system-ml-1632920966.md)
- `r_local.ml` → [src/r_local.ml](File-src-r-local-ml-797040731.md)
- `r_sky.ml` → [src/r_sky.ml](File-src-r-sky-ml-918225537.md)
- `std/math.ml` → `../MiniLangCompilerOptimization/MiniLangCompilerPy/std/math.ml` — external dependency

## Declarations

<a id="function-function-rs-abs-inline-function-rs-abs-v-src-r-segs-ml-764261568"></a>
### _RS_Abs

```ml
inline function _RS_Abs(v)
```

Returns the non-negative integer magnitude of a numeric wall-renderer input.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `v` | `dynamic` | — | Value consumed by the operation. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_segs.ml#L139)

<a id="function-function-rs-allocintlist-inline-function-rs-allocintlist-n-fill-src-r-segs-ml-1052167343"></a>
### _RS_AllocIntList

```ml
inline function _RS_AllocIntList(n, fill)
```

Allocates an integer list of a requested length initialized to one sentinel value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `n` | `dynamic` | — | Number of values to process. |
| `fill` | `dynamic` | — | Fill value supplied to `_RS_AllocIntList`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_segs.ml#L184)

<a id="function-function-rs-allocmaskedcols-function-rs-allocmaskedcols-start-stop-src-r-segs-ml-1062654977"></a>
### _RS_AllocMaskedCols

```ml
function _RS_AllocMaskedCols(start, stop)
```

Reserves an inclusive masked-column range in openings, initializes MAXSHORT sentinels, and returns an x-biased reference.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `start` | `dynamic` | — | Start value supplied to `_RS_AllocMaskedCols`. |
| `stop` | `dynamic` | — | Stop value supplied to `_RS_AllocMaskedCols`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_segs.ml#L373)

<a id="function-function-rs-angnorm-inline-function-rs-angnorm-a-src-r-segs-ml-1287694807"></a>
### _RS_AngNorm

```ml
inline function _RS_AngNorm(a)
```

Normalizes a numeric value to Doom's unsigned 32-bit binary-angle domain.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `a` | `dynamic` | — | First input operand. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_segs.ml#L235)

<a id="function-function-rs-angsub-inline-function-rs-angsub-a-b-src-r-segs-ml-1874460203"></a>
### _RS_AngSub

```ml
inline function _RS_AngSub(a, b)
```

Subtracts two binary angles with unsigned 32-bit wraparound.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `a` | `dynamic` | — | First input operand. |
| `b` | `dynamic` | — | Second input operand. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_segs.ml#L244)

<a id="function-function-rs-clamp-inline-function-rs-clamp-v-lo-hi-src-r-segs-ml-45824942"></a>
### _RS_Clamp

```ml
inline function _RS_Clamp(v, lo, hi)
```

Constrains a wall-rendering scalar to the supplied inclusive bounds.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `v` | `dynamic` | — | Value consumed by the operation. |
| `lo` | `dynamic` | — | Inclusive lower bound. |
| `hi` | `dynamic` | — | Inclusive upper bound. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_segs.ml#L130)

<a id="function-function-rs-clampindex-inline-function-rs-clampindex-i-n-src-r-segs-ml-1097890701"></a>
### _RS_ClampIndex

```ml
inline function _RS_ClampIndex(i, n)
```

Clamps an index to the first or last entry of a non-empty lookup table.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `i` | `dynamic` | — | Zero-based iteration index. |
| `n` | `dynamic` | — | Number of values to process. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_segs.ml#L164)

<a id="function-function-rs-copycliptoopenings-function-rs-copycliptoopenings-src-start-stop-fallback-src-r-segs-ml-1464668399"></a>
### _RS_CopyClipToOpenings

```ml
function _RS_CopyClipToOpenings(src, start, stop, fallback)
```

Copies an inclusive screen-column clip range into the openings arena and returns an x-biased reference.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `src` | `dynamic` | — | Src value supplied to `_RS_CopyClipToOpenings`. |
| `start` | `dynamic` | — | Start value supplied to `_RS_CopyClipToOpenings`. |
| `stop` | `dynamic` | — | Stop value supplied to `_RS_CopyClipToOpenings`. |
| `fallback` | `dynamic` | — | Value returned when the requested conversion or lookup is unavailable. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_segs.ml#L343)

<a id="function-function-rs-drawmaskedtexturecolumn-function-rs-drawmaskedtexturecolumn-x-texnum-texturecolumn-texturemid-yscale-topclip-bottomclip-src-r-segs-ml-1629864199"></a>
### _RS_DrawMaskedTextureColumn

```ml
function _RS_DrawMaskedTextureColumn(x, texnum, texturecolumn, texturemid, yscale, topclip, bottomclip)
```

Decodes patch posts for one masked wall column, clips each post, draws with depth state, and restores shared column inputs.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `x` | `dynamic` | — | Horizontal map- or screen-space coordinate. |
| `texnum` | `dynamic` | — | Index identifying tex. |
| `texturecolumn` | `dynamic` | — | Texturecolumn value supplied to `_RS_DrawMaskedTextureColumn`. |
| `texturemid` | `dynamic` | — | Texturemid value supplied to `_RS_DrawMaskedTextureColumn`. |
| `yscale` | `dynamic` | — | Yscale value supplied to `_RS_DrawMaskedTextureColumn`. |
| `topclip` | `dynamic` | — | Topclip value supplied to `_RS_DrawMaskedTextureColumn`. |
| `bottomclip` | `dynamic` | — | Bottomclip value supplied to `_RS_DrawMaskedTextureColumn`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_segs.ml#L471)

<a id="function-function-rs-drawtexturedrange-function-rs-drawtexturedrange-fb-x-y1-y2-texnum-texcol-cmap-src-r-segs-ml-183170629"></a>
### _RS_DrawTexturedRange

```ml
function _RS_DrawTexturedRange(fb, x, y1, y2, texnum, texCol, cmap)
```

Scales one opaque texture column across a bounded vertical framebuffer range using a lighting colormap.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `fb` | `dynamic` | — | Fb value supplied to `_RS_DrawTexturedRange`. |
| `x` | `dynamic` | — | Horizontal map- or screen-space coordinate. |
| `y1` | `dynamic` | — | Vertical coordinate of the first endpoint. |
| `y2` | `dynamic` | — | Vertical coordinate of the second endpoint. |
| `texnum` | `dynamic` | — | Index identifying tex. |
| `texCol` | `dynamic` | — | Tex col value supplied to `_RS_DrawTexturedRange`. |
| `cmap` | `dynamic` | — | Cmap value supplied to `_RS_DrawTexturedRange`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_segs.ml#L438)

<a id="function-function-rs-ensureopeningscapacity-function-rs-ensureopeningscapacity-needed-src-r-segs-ml-2081519344"></a>
### _RS_EnsureOpeningsCapacity

```ml
function _RS_EnsureOpeningsCapacity(needed)
```

Grows the shared openings arena geometrically so a requested exclusive end offset is addressable.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `needed` | `dynamic` | — | Needed value supplied to `_RS_EnsureOpeningsCapacity`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_segs.ml#L197)

<a id="function-function-rs-getclipvalue-inline-function-rs-getclipvalue-clipref-x-fallback-src-r-segs-ml-445048381"></a>
### _RS_GetClipValue

```ml
inline function _RS_GetClipValue(clipref, x, fallback)
```

Reads a screen-column clip from either a direct sequence or a biased offset into the openings arena.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `clipref` | `dynamic` | — | Clipref value supplied to `_RS_GetClipValue`. |
| `x` | `dynamic` | — | Horizontal map- or screen-space coordinate. |
| `fallback` | `dynamic` | — | Value returned when the requested conversion or lookup is unavailable. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_segs.ml#L307)

<a id="function-function-rs-idiv-inline-function-rs-idiv-a-b-src-r-segs-ml-1984995287"></a>
### _RS_IDiv

```ml
inline function _RS_IDiv(a, b)
```

Returns a signed quotient truncated toward zero, or zero for invalid operands and a zero divisor in `_RS_IDiv`

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `a` | `dynamic` | — | First input operand. |
| `b` | `dynamic` | — | Second input operand. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_segs.ml#L99)

<a id="function-function-rs-isseq-inline-function-rs-isseq-v-src-r-segs-ml-385991552"></a>
### _RS_IsSeq

```ml
inline function _RS_IsSeq(v)
```

Recognizes the array and list containers used for column clips and renderer tables.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `v` | `dynamic` | — | Value consumed by the operation. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_segs.ml#L175)

<a id="function-function-rs-readmaskedcol-inline-function-rs-readmaskedcol-maskref-x-src-r-segs-ml-554069583"></a>
### _RS_ReadMaskedCol

```ml
inline function _RS_ReadMaskedCol(maskref, x)
```

Reads a deferred masked texture column through direct or openings-backed storage, defaulting to MAXSHORT.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `maskref` | `dynamic` | — | Maskref value supplied to `_RS_ReadMaskedCol`. |
| `x` | `dynamic` | — | Horizontal map- or screen-space coordinate. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_segs.ml#L399)

<a id="function-function-rs-resolvetexture-inline-function-rs-resolvetexture-texid-src-r-segs-ml-425988308"></a>
### _RS_ResolveTexture

```ml
inline function _RS_ResolveTexture(texId)
```

Applies animation translation to a positive texture id and rejects invalid or out-of-table results.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `texId` | `dynamic` | — | Tex id value supplied to `_RS_ResolveTexture`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_segs.ml#L251)

<a id="function-function-rs-selectwalllights-function-rs-selectwalllights-line-sec-src-r-segs-ml-1046142236"></a>
### _RS_SelectWallLights

```ml
function _RS_SelectWallLights(line, sec)
```

Selects the scale-light row for a sector, including horizontal/vertical wall bias and fixed-colormap override.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `line` | `dynamic` | — | Map line or text line affected by the operation. |
| `sec` | `dynamic` | — | Sec value supplied to `_RS_SelectWallLights`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_segs.ml#L267)

<a id="function-function-rs-setclipvalue-inline-function-rs-setclipvalue-clipref-x-value-src-r-segs-ml-1302772842"></a>
### _RS_SetClipValue

```ml
inline function _RS_SetClipValue(clipref, x, value)
```

Writes a screen-column clip through either a direct sequence or a biased openings-arena reference.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `clipref` | `dynamic` | — | Clipref value supplied to `_RS_SetClipValue`. |
| `x` | `dynamic` | — | Horizontal map- or screen-space coordinate. |
| `value` | `dynamic` | — | Value consumed by the operation. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_segs.ml#L325)

<a id="function-function-rs-toint-inline-function-rs-toint-v-fallback-src-r-segs-ml-551203270"></a>
### _RS_ToInt

```ml
inline function _RS_ToInt(v, fallback)
```

Coerces numeric values to truncation-toward-zero integers and returns fallback on failure in `_RS_ToInt`

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `v` | `dynamic` | — | Value consumed by the operation. |
| `fallback` | `dynamic` | — | Value returned when the requested conversion or lookup is unavailable. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_segs.ml#L110)

<a id="function-function-rs-wrapindex-inline-function-rs-wrapindex-i-n-src-r-segs-ml-718341927"></a>
### _RS_WrapIndex

```ml
inline function _RS_WrapIndex(i, n)
```

Wraps a possibly negative index into a non-empty cyclic lookup table.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `i` | `dynamic` | — | Zero-based iteration index. |
| `n` | `dynamic` | — | Number of values to process. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_segs.ml#L149)

<a id="function-function-rs-writemaskedcol-inline-function-rs-writemaskedcol-maskref-x-value-src-r-segs-ml-1118192978"></a>
### _RS_WriteMaskedCol

```ml
inline function _RS_WriteMaskedCol(maskref, x, value)
```

Writes a deferred masked texture column through direct or openings-backed storage.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `maskref` | `dynamic` | — | Maskref value supplied to `_RS_WriteMaskedCol`. |
| `x` | `dynamic` | — | Horizontal map- or screen-space coordinate. |
| `value` | `dynamic` | — | Value consumed by the operation. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_segs.ml#L417)

<a id="global-global-bottomfrac-bottomfrac-src-r-segs-ml-641903119"></a>
### bottomfrac

```ml
bottomfrac
```

Tracks the mutable bottomfrac value used by the r segs subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_segs.ml#L80)

<a id="global-global-bottomstep-bottomstep-src-r-segs-ml-1297931391"></a>
### bottomstep

```ml
bottomstep
```

Tracks the mutable bottomstep value used by the r segs subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_segs.ml#L82)

<a id="global-global-bottomtexture-bottomtexture-src-r-segs-ml-1521139225"></a>
### bottomtexture

```ml
bottomtexture
```

Tracks the mutable bottomtexture value used by the r segs subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_segs.ml#L38)

<a id="constant-constant-heightbits-const-heightbits-12-src-r-segs-ml-194976671"></a>
### HEIGHTBITS

```ml
const HEIGHTBITS = 12
```

Defines heightbits for the r segs subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_segs.ml#L85)

<a id="constant-constant-heightunit-const-heightunit-1-heightbits-src-r-segs-ml-1862980862"></a>
### HEIGHTUNIT

```ml
const HEIGHTUNIT = 1 << HEIGHTBITS
```

Defines heightunit for the r segs subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_segs.ml#L87)

<a id="global-global-maskedtexture-maskedtexture-src-r-segs-ml-1543133549"></a>
### maskedtexture

```ml
maskedtexture
```

Tracks whether maskedtexture is active in the r segs subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_segs.ml#L34)

<a id="global-global-maskedtexturecol-maskedtexturecol-src-r-segs-ml-244445049"></a>
### maskedtexturecol

```ml
maskedtexturecol
```

Holds the optional maskedtexturecol resource used by the r segs subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_segs.ml#L31)

<a id="global-global-midtexture-midtexture-src-r-segs-ml-525157511"></a>
### midtexture

```ml
midtexture
```

Tracks the mutable midtexture value used by the r segs subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_segs.ml#L40)

<a id="global-global-pixhigh-pixhigh-src-r-segs-ml-962918001"></a>
### pixhigh

```ml
pixhigh
```

Tracks the mutable pixhigh value used by the r segs subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_segs.ml#L67)

<a id="global-global-pixhighstep-pixhighstep-src-r-segs-ml-1659394197"></a>
### pixhighstep

```ml
pixhighstep
```

Tracks the mutable pixhighstep value used by the r segs subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_segs.ml#L71)

<a id="global-global-pixlow-pixlow-src-r-segs-ml-1702327119"></a>
### pixlow

```ml
pixlow
```

Tracks the mutable pixlow value used by the r segs subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_segs.ml#L69)

<a id="global-global-pixlowstep-pixlowstep-src-r-segs-ml-1883865615"></a>
### pixlowstep

```ml
pixlowstep
```

Tracks the mutable pixlowstep value used by the r segs subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_segs.ml#L73)

<a id="function-function-r-clearsolidclipscales-function-r-clearsolidclipscales-src-r-segs-ml-1155629663"></a>
### R_ClearSolidClipScales

```ml
function R_ClearSolidClipScales()
```

Retains the classic renderer hook; solid clip scales need no separate reset in this implementation.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_segs.ml#L228)

<a id="function-function-r-rendermaskedsegrange-function-r-rendermaskedsegrange-ds-x1-x2-src-r-segs-ml-1127673351"></a>
### R_RenderMaskedSegRange

```ml
function R_RenderMaskedSegRange(ds, x1, x2)
```

Renders an inclusive deferred middle-texture range with pegging, scale lighting, and saved sprite clip arrays.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `ds` | `dynamic` | — | Ds value supplied to `R_RenderMaskedSegRange`. |
| `x1` | `dynamic` | — | Horizontal coordinate of the first endpoint. |
| `x2` | `dynamic` | — | Horizontal coordinate of the second endpoint. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_segs.ml#L578)

<a id="function-function-r-rendersegloop-function-r-rendersegloop-src-r-segs-ml-1681211195"></a>
### R_RenderSegLoop

```ml
function R_RenderSegLoop()
```

Projects a prepared wall range column by column, draws its wall tiers, updates plane spans, clips, and records masked columns.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_segs.ml#L659)

<a id="function-function-r-storewallrange-function-r-storewallrange-start-stop-src-r-segs-ml-1433765533"></a>
### R_StoreWallRange

```ml
function R_StoreWallRange(start, stop)
```

Builds a drawseg for a visible wall range, derives textures/pegging/silhouettes, renders opaque tiers, and saves sprite clips.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `start` | `dynamic` | — | Start value supplied to `R_StoreWallRange`. |
| `stop` | `dynamic` | — | Stop value supplied to `R_StoreWallRange`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_segs.ml#L809)

<a id="constant-constant-rs-inv-scale-num-const-rs-inv-scale-num-4294967295-src-r-segs-ml-631524079"></a>
### RS_INV_SCALE_NUM

```ml
const RS_INV_SCALE_NUM = 4294967295
```

Defines the rs inv scale num count used by the r segs subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_segs.ml#L89)

<a id="global-global-rw-bottomtexturemid-rw-bottomtexturemid-src-r-segs-ml-1911337069"></a>
### rw_bottomtexturemid

```ml
rw_bottomtexturemid
```

Tracks the mutable rw bottomtexturemid value used by the r segs subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_segs.ml#L55)

<a id="global-global-rw-centerangle-rw-centerangle-src-r-segs-ml-1092149141"></a>
### rw_centerangle

```ml
rw_centerangle
```

Tracks the mutable rw centerangle value used by the r segs subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_segs.ml#L43)

<a id="global-global-rw-midtexturemid-rw-midtexturemid-src-r-segs-ml-316199579"></a>
### rw_midtexturemid

```ml
rw_midtexturemid
```

Tracks the mutable rw midtexturemid value used by the r segs subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_segs.ml#L51)

<a id="global-global-rw-offset-rw-offset-src-r-segs-ml-433182177"></a>
### rw_offset

```ml
rw_offset
```

Tracks the mutable rw offset value used by the r segs subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_segs.ml#L45)

<a id="global-global-rw-scale-rw-scale-src-r-segs-ml-373803289"></a>
### rw_scale

```ml
rw_scale
```

Tracks the mutable rw scale value used by the r segs subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_segs.ml#L47)

<a id="global-global-rw-scalestep-rw-scalestep-src-r-segs-ml-1354922165"></a>
### rw_scalestep

```ml
rw_scalestep
```

Tracks the mutable rw scalestep value used by the r segs subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_segs.ml#L49)

<a id="global-global-rw-solidwall-rw-solidwall-src-r-segs-ml-1254306499"></a>
### rw_solidwall

```ml
rw_solidwall
```

Tracks whether rw solidwall is active in the r segs subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_segs.ml#L92)

<a id="global-global-rw-toptexturemid-rw-toptexturemid-src-r-segs-ml-1490150681"></a>
### rw_toptexturemid

```ml
rw_toptexturemid
```

Tracks the mutable rw toptexturemid value used by the r segs subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_segs.ml#L53)

<a id="global-global-topfrac-topfrac-src-r-segs-ml-574447365"></a>
### topfrac

```ml
topfrac
```

Tracks the mutable topfrac value used by the r segs subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_segs.ml#L76)

<a id="global-global-topstep-topstep-src-r-segs-ml-265917513"></a>
### topstep

```ml
topstep
```

Tracks the mutable topstep value used by the r segs subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_segs.ml#L78)

<a id="global-global-toptexture-toptexture-src-r-segs-ml-1367395833"></a>
### toptexture

```ml
toptexture
```

Tracks the mutable toptexture value used by the r segs subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_segs.ml#L36)

<a id="global-global-walllights-walllights-src-r-segs-ml-1054378907"></a>
### walllights

```ml
walllights
```

Holds the optional walllights resource used by the r segs subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_segs.ml#L28)

<a id="global-global-worldbottom-worldbottom-src-r-segs-ml-382091201"></a>
### worldbottom

```ml
worldbottom
```

Tracks the mutable worldbottom value used by the r segs subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_segs.ml#L60)

<a id="global-global-worldhigh-worldhigh-src-r-segs-ml-1743370433"></a>
### worldhigh

```ml
worldhigh
```

Tracks the mutable worldhigh value used by the r segs subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_segs.ml#L62)

<a id="global-global-worldlow-worldlow-src-r-segs-ml-1622821697"></a>
### worldlow

```ml
worldlow
```

Tracks the mutable worldlow value used by the r segs subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_segs.ml#L64)

<a id="global-global-worldtop-worldtop-src-r-segs-ml-297957311"></a>
### worldtop

```ml
worldtop
```

Tracks the mutable worldtop value used by the r segs subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_segs.ml#L58)
