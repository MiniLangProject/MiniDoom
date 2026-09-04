# `src/v_video.ml`

[Home](README.md) · [Files](Files.md)

Provides video buffer and palette helper routines used by renderer and UI.

Package: [`(global)`](Package-global-1952375359.md)

Reachable from entry: **yes**

## Imports

- `doomdata.ml` → [src/doomdata.ml](File-src-doomdata-ml-887192154.md)
- `doomdef.ml` → [src/doomdef.ml](File-src-doomdef-ml-460406769.md)
- `doomdef.ml` → [src/doomdef.ml](File-src-doomdef-ml-460406769.md)
- `doomtype.ml` → [src/doomtype.ml](File-src-doomtype-ml-372549946.md)
- `i_gl.ml` → [src/i_gl.ml](File-src-i-gl-ml-2113703076.md)
- `i_system.ml` → [src/i_system.ml](File-src-i-system-ml-1632920966.md)
- `m_bbox.ml` → [src/m_bbox.ml](File-src-m-bbox-ml-1176525784.md)
- `m_swap.ml` → [src/m_swap.ml](File-src-m-swap-ml-1401834276.md)
- `r_data.ml` → [src/r_data.ml](File-src-r-data-ml-1686270288.md)
- `r_local.ml` → [src/r_local.ml](File-src-r-local-ml-797040731.md)
- `r_renderer.ml` → [src/r_renderer.ml](File-src-r-renderer-ml-72894217.md)
- `r_upscaled.ml` → [src/r_upscaled.ml](File-src-r-upscaled-ml-1801241933.md)
- `w_wad.ml` → [src/w_wad.ml](File-src-w-wad-ml-893006035.md)

## Declarations

<a id="function-function-clampint-inline-function-clampint-x-lo-hi-src-v-video-ml-1341042677"></a>
### _clampInt

```ml
inline function _clampInt(x, lo, hi)
```

Restricts a pixel coordinate or extent to caller-supplied inclusive bounds.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `x` | `dynamic` | — | Horizontal map- or screen-space coordinate. |
| `lo` | `dynamic` | — | Inclusive lower bound. |
| `hi` | `dynamic` | — | Inclusive upper bound. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/v_video.ml#L207)

<a id="function-function-s16le-inline-function-s16le-b-off-src-v-video-ml-426326194"></a>
### _s16le

```ml
inline function _s16le(b, off)
```

Decodes a two-byte little-endian patch field with signed 16-bit interpretation.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `b` | `dynamic` | — | Second input operand. |
| `off` | `dynamic` | — | Zero-based byte or element offset. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/v_video.ml#L188)

<a id="function-function-u16le-inline-function-u16le-b-off-src-v-video-ml-405757178"></a>
### _u16le

```ml
inline function _u16le(b, off)
```

Decodes an unsigned 16-bit little-endian field from Doom patch bytes.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `b` | `dynamic` | — | Second input operand. |
| `off` | `dynamic` | — | Zero-based byte or element offset. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/v_video.ml#L180)

<a id="function-function-u32le-inline-function-u32le-b-off-src-v-video-ml-999244766"></a>
### _u32le

```ml
inline function _u32le(b, off)
```

Decodes an unsigned 32-bit little-endian patch-column offset.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `b` | `dynamic` | — | Second input operand. |
| `off` | `dynamic` | — | Zero-based byte or element offset. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/v_video.ml#L198)

<a id="global-global-dirtybox-dirtybox-src-v-video-ml-975869396"></a>
### dirtybox

```ml
dirtybox
```

Stores the dirtybox collection used by the v video subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/v_video.ml#L38)

<a id="global-global-gammatable-gammatable-src-v-video-ml-1871321360"></a>
### gammatable

```ml
gammatable
```

Stores the gammatable collection used by the v video subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/v_video.ml#L81)

<a id="global-global-screens-screens-src-v-video-ml-763784342"></a>
### screens

```ml
screens
```

Stores the screens collection used by the v video subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/v_video.ml#L35)

<a id="global-global-usegamma-usegamma-src-v-video-ml-1728012318"></a>
### usegamma

```ml
usegamma
```

Tracks the mutable usegamma value used by the v video subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/v_video.ml#L174)

<a id="function-function-v-clearhighresoverlay-function-v-clearhighresoverlay-src-v-video-ml-989087744"></a>
### V_ClearHighresOverlay

```ml
function V_ClearHighresOverlay()
```

Clears high-resolution prepared patch overlay pixels from the previous frame.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/v_video.ml#L296)

<a id="function-function-v-clearhighresoverlaykeeplogicaly-function-v-clearhighresoverlaykeeplogicaly-logicaly-src-v-video-ml-1708880780"></a>
### V_ClearHighresOverlayKeepLogicalY

```ml
function V_ClearHighresOverlayKeepLogicalY(logicalY)
```

Clears high-resolution overlay pixels above a logical Y coordinate while preserving the lower persistent area.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `logicalY` | `dynamic` | — | Vertical coordinate or vector component represented by logical y. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/v_video.ml#L336)

<a id="function-function-v-clearhighresoverlayrect-function-v-clearhighresoverlayrect-x-y-width-height-src-v-video-ml-839420380"></a>
### V_ClearHighresOverlayRect

```ml
function V_ClearHighresOverlayRect(x, y, width, height)
```

Clears one logical rectangle from the high-resolution overlay mask.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `x` | `dynamic` | — | Horizontal map- or screen-space coordinate. |
| `y` | `dynamic` | — | Vertical map- or screen-space coordinate. |
| `width` | `dynamic` | — | Width of the target in pixels or map units. |
| `height` | `dynamic` | — | Height of the target in pixels or map units. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/v_video.ml#L390)

<a id="function-function-v-clearoverlaymask-function-v-clearoverlaymask-src-v-video-ml-668063000"></a>
### V_ClearOverlayMask

```ml
function V_ClearOverlayMask()
```

Clears the per-frame mask of logical pixels drawn by late UI patches.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/v_video.ml#L242)

<a id="function-function-v-copyrect-function-v-copyrect-srcx-srcy-srcscrn-width-height-destx-desty-destscrn-src-v-video-ml-639122665"></a>
### V_CopyRect

```ml
function V_CopyRect(srcx, srcy, srcscrn, width, height, destx, desty, destscrn)
```

Copies an indexed rectangle between logical screens and invalidates overlapping HD overlay content on the visible screen.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `srcx` | `dynamic` | — | Srcx value supplied to `V_CopyRect`. |
| `srcy` | `dynamic` | — | Srcy value supplied to `V_CopyRect`. |
| `srcscrn` | `dynamic` | — | Srcscrn value supplied to `V_CopyRect`. |
| `width` | `dynamic` | — | Width of the target in pixels or map units. |
| `height` | `dynamic` | — | Height of the target in pixels or map units. |
| `destx` | `dynamic` | — | Destx value supplied to `V_CopyRect`. |
| `desty` | `dynamic` | — | Desty value supplied to `V_CopyRect`. |
| `destscrn` | `dynamic` | — | Destscrn value supplied to `V_CopyRect`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/v_video.ml#L661)

<a id="function-function-v-drawblock-function-v-drawblock-x-y-scrn-width-height-src-src-v-video-ml-1297284562"></a>
### V_DrawBlock

```ml
function V_DrawBlock(x, y, scrn, width, height, src)
```

Copies a tightly packed indexed block into a logical screen and marks visible pixels for dirty and late-overlay composition.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `x` | `dynamic` | — | Horizontal map- or screen-space coordinate. |
| `y` | `dynamic` | — | Vertical map- or screen-space coordinate. |
| `scrn` | `dynamic` | — | Scrn value supplied to `V_DrawBlock`. |
| `width` | `dynamic` | — | Width of the target in pixels or map units. |
| `height` | `dynamic` | — | Height of the target in pixels or map units. |
| `src` | `dynamic` | — | Src value supplied to `V_DrawBlock`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/v_video.ml#L756)

<a id="function-function-v-drawditheredoverlayrect-function-v-drawditheredoverlayrect-x-y-width-height-color-src-v-video-ml-2061040161"></a>
### V_DrawDitheredOverlayRect

```ml
function V_DrawDitheredOverlayRect(x, y, width, height, color)
```

Draws a clipped checkerboard shade whose unmarked pixels preserve the world as palette-safe transparency.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `x` | `dynamic` | — | Horizontal map- or screen-space coordinate. |
| `y` | `dynamic` | — | Vertical map- or screen-space coordinate. |
| `width` | `dynamic` | — | Width of the target in pixels or map units. |
| `height` | `dynamic` | — | Height of the target in pixels or map units. |
| `color` | `dynamic` | — | Doom palette index used for drawing. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/v_video.ml#L786)

<a id="function-function-v-drawnamedupscaledpatchoverlay-function-v-drawnamedupscaledpatchoverlay-x-y-name-flipped-src-v-video-ml-1904143480"></a>
### V_DrawNamedUpscaledPatchOverlay

```ml
function V_DrawNamedUpscaledPatchOverlay(x, y, name, flipped)
```

Draws a prepared upscaled patch image into the high-resolution overlay.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `x` | `dynamic` | — | Horizontal map- or screen-space coordinate. |
| `y` | `dynamic` | — | Vertical map- or screen-space coordinate. |
| `name` | `dynamic` | — | Resource or object name to resolve. |
| `flipped` | `dynamic` | — | Flipped value supplied to `V_DrawNamedUpscaledPatchOverlay`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/v_video.ml#L489)

<a id="function-function-v-drawnamedupscaledpatchoverlaylogicalscale-function-v-drawnamedupscaledpatchoverlaylogicalscale-x-y-name-flipped-logicalscale-src-v-video-ml-1260809501"></a>
### V_DrawNamedUpscaledPatchOverlayLogicalScale

```ml
function V_DrawNamedUpscaledPatchOverlayLogicalScale(x, y, name, flipped, logicalScale)
```

Draws a prepared HDWAD patch at a Doom-layout scale without running any scaler.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `x` | `dynamic` | — | Horizontal map- or screen-space coordinate. |
| `y` | `dynamic` | — | Vertical map- or screen-space coordinate. |
| `name` | `dynamic` | — | Resource or object name to resolve. |
| `flipped` | `dynamic` | — | Flipped value supplied to `V_DrawNamedUpscaledPatchOverlayLogicalScale`. |
| `logicalScale` | `dynamic` | — | Logical scale value supplied to `V_DrawNamedUpscaledPatchOverlayLogicalScale`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/v_video.ml#L549)

<a id="function-function-v-drawpatch-function-v-drawpatch-x-y-scrn-patch-src-v-video-ml-1832591713"></a>
### V_DrawPatch

```ml
function V_DrawPatch(x, y, scrn, patch)
```

Decodes clipped Doom patch-column posts into an indexed screen while tracking visible dirty and HD-overlay regions.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `x` | `dynamic` | — | Horizontal map- or screen-space coordinate. |
| `y` | `dynamic` | — | Vertical map- or screen-space coordinate. |
| `scrn` | `dynamic` | — | Scrn value supplied to `V_DrawPatch`. |
| `patch` | `dynamic` | — | Patch value supplied to `V_DrawPatch`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/v_video.ml#L684)

<a id="function-function-v-drawpatchdirect-function-v-drawpatchdirect-x-y-scrn-patch-src-v-video-ml-643554339"></a>
### V_DrawPatchDirect

```ml
function V_DrawPatchDirect(x, y, scrn, patch)
```

Preserves the legacy direct-patch entry point by forwarding to the normal clipped patch renderer.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `x` | `dynamic` | — | Horizontal map- or screen-space coordinate. |
| `y` | `dynamic` | — | Vertical map- or screen-space coordinate. |
| `scrn` | `dynamic` | — | Scrn value supplied to `V_DrawPatchDirect`. |
| `patch` | `dynamic` | — | Patch value supplied to `V_DrawPatchDirect`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/v_video.ml#L744)

<a id="function-function-v-drawpatchflipped-function-v-drawpatchflipped-x-y-scrn-patch-src-v-video-ml-925846691"></a>
### V_DrawPatchFlipped

```ml
function V_DrawPatchFlipped(x, y, scrn, patch)
```

Decodes a Doom patch with reversed source-column order while retaining normal placement, clipping, and overlay tracking.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `x` | `dynamic` | — | Horizontal map- or screen-space coordinate. |
| `y` | `dynamic` | — | Vertical map- or screen-space coordinate. |
| `scrn` | `dynamic` | — | Scrn value supplied to `V_DrawPatchFlipped`. |
| `patch` | `dynamic` | — | Patch value supplied to `V_DrawPatchFlipped`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/v_video.ml#L900)

<a id="function-function-v-drawsolidoverlayrect-function-v-drawsolidoverlayrect-x-y-width-height-color-src-v-video-ml-1154554545"></a>
### V_DrawSolidOverlayRect

```ml
function V_DrawSolidOverlayRect(x, y, width, height, color)
```

Fills and marks a clipped opaque late-overlay rectangle, primarily for UI borders and separators.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `x` | `dynamic` | — | Horizontal map- or screen-space coordinate. |
| `y` | `dynamic` | — | Vertical map- or screen-space coordinate. |
| `width` | `dynamic` | — | Width of the target in pixels or map units. |
| `height` | `dynamic` | — | Height of the target in pixels or map units. |
| `color` | `dynamic` | — | Doom palette index used for drawing. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/v_video.ml#L835)

<a id="function-function-v-drawupscaledflatoverlay-function-v-drawupscaledflatoverlay-name-src-v-video-ml-1611025961"></a>
### V_DrawUpscaledFlatOverlay

```ml
function V_DrawUpscaledFlatOverlay(name)
```

Draws a prepared upscaled flat image into the high-resolution overlay.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `name` | `dynamic` | — | Resource or object name to resolve. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/v_video.ml#L452)

<a id="function-function-v-drawupscaledpatchoverlay-function-v-drawupscaledpatchoverlay-x-y-patch-flipped-src-v-video-ml-2114183601"></a>
### V_DrawUpscaledPatchOverlay

```ml
function V_DrawUpscaledPatchOverlay(x, y, patch, flipped)
```

Resolves a cached patch's lump name and delegates its optional HD replacement into the late UI overlay.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `x` | `dynamic` | — | Horizontal map- or screen-space coordinate. |
| `y` | `dynamic` | — | Vertical map- or screen-space coordinate. |
| `patch` | `dynamic` | — | Patch value supplied to `V_DrawUpscaledPatchOverlay`. |
| `flipped` | `dynamic` | — | Flipped value supplied to `V_DrawUpscaledPatchOverlay`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/v_video.ml#L603)

<a id="function-function-v-endoverlaymask-function-v-endoverlaymask-src-v-video-ml-1282421212"></a>
### V_EndOverlayMask

```ml
function V_EndOverlayMask()
```

Stops recording late UI overlay pixels while keeping the recorded mask for presentation.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/v_video.ml#L269)

<a id="function-function-v-ensurehighresoverlay-function-v-ensurehighresoverlay-src-v-video-ml-1808382164"></a>
### V_EnsureHighresOverlay

```ml
function V_EnsureHighresOverlay()
```

Lazily allocates high-resolution patch overlay buffers.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/v_video.ml#L275)

<a id="function-function-v-getblock-function-v-getblock-x-y-scrn-width-height-destbuf-src-v-video-ml-278197209"></a>
### V_GetBlock

```ml
function V_GetBlock(x, y, scrn, width, height, destBuf)
```

Copies a logical-screen rectangle into a tightly packed caller-provided byte buffer.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `x` | `dynamic` | — | Horizontal map- or screen-space coordinate. |
| `y` | `dynamic` | — | Vertical map- or screen-space coordinate. |
| `scrn` | `dynamic` | — | Scrn value supplied to `V_GetBlock`. |
| `width` | `dynamic` | — | Width of the target in pixels or map units. |
| `height` | `dynamic` | — | Height of the target in pixels or map units. |
| `destBuf` | `dynamic` | — | Dest buf value supplied to `V_GetBlock`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/v_video.ml#L882)

<a id="global-global-v-highres-patch-overlay-enabled-v-highres-patch-overlay-enabled-src-v-video-ml-1863752114"></a>
### v_highres_patch_overlay_enabled

```ml
v_highres_patch_overlay_enabled
```

Tracks whether v highres patch overlay enabled is active in the v video subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/v_video.ml#L78)

<a id="function-function-v-highresoverlaycanreuse-function-v-highresoverlaycanreuse-src-v-video-ml-1658496904"></a>
### V_HighresOverlayCanReuse

```ml
function V_HighresOverlayCanReuse()
```

Reports whether the previous high-resolution page overlay is still intact.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/v_video.ml#L326)

<a id="global-global-v-hioverlay-v-hioverlay-src-v-video-ml-207057462"></a>
### v_hioverlay

```ml
v_hioverlay
```

Holds the optional v hioverlay resource used by the v video subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/v_video.ml#L52)

<a id="global-global-v-hioverlay-cached-flipped-v-hioverlay-cached-flipped-src-v-video-ml-1051789670"></a>
### v_hioverlay_cached_flipped

```ml
v_hioverlay_cached_flipped
```

Tracks whether v hioverlay cached flipped is active in the v video subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/v_video.ml#L72)

<a id="global-global-v-hioverlay-cached-name-v-hioverlay-cached-name-src-v-video-ml-294529810"></a>
### v_hioverlay_cached_name

```ml
v_hioverlay_cached_name
```

Stores the mutable v hioverlay cached name text used by the v video subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/v_video.ml#L66)

<a id="global-global-v-hioverlay-cached-scale-v-hioverlay-cached-scale-src-v-video-ml-604513514"></a>
### v_hioverlay_cached_scale

```ml
v_hioverlay_cached_scale
```

Tracks the mutable v hioverlay cached scale value used by the v video subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/v_video.ml#L74)

<a id="global-global-v-hioverlay-cached-valid-v-hioverlay-cached-valid-src-v-video-ml-309258890"></a>
### v_hioverlay_cached_valid

```ml
v_hioverlay_cached_valid
```

Tracks whether v hioverlay cached valid is active in the v video subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/v_video.ml#L76)

<a id="global-global-v-hioverlay-cached-x-v-hioverlay-cached-x-src-v-video-ml-472491498"></a>
### v_hioverlay_cached_x

```ml
v_hioverlay_cached_x
```

Tracks the mutable v hioverlay cached x value used by the v video subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/v_video.ml#L68)

<a id="global-global-v-hioverlay-cached-y-v-hioverlay-cached-y-src-v-video-ml-997695300"></a>
### v_hioverlay_cached_y

```ml
v_hioverlay_cached_y
```

Tracks the mutable v hioverlay cached y value used by the v video subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/v_video.ml#L70)

<a id="global-global-v-hioverlay-maxx-v-hioverlay-maxx-src-v-video-ml-658871772"></a>
### v_hioverlay_maxx

```ml
v_hioverlay_maxx
```

Tracks the mutable v hioverlay maxx value used by the v video subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/v_video.ml#L62)

<a id="global-global-v-hioverlay-maxy-v-hioverlay-maxy-src-v-video-ml-257057870"></a>
### v_hioverlay_maxy

```ml
v_hioverlay_maxy
```

Tracks the mutable v hioverlay maxy value used by the v video subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/v_video.ml#L64)

<a id="global-global-v-hioverlay-minx-v-hioverlay-minx-src-v-video-ml-932247616"></a>
### v_hioverlay_minx

```ml
v_hioverlay_minx
```

Tracks the mutable v hioverlay minx value used by the v video subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/v_video.ml#L58)

<a id="global-global-v-hioverlay-miny-v-hioverlay-miny-src-v-video-ml-283475410"></a>
### v_hioverlay_miny

```ml
v_hioverlay_miny
```

Tracks the mutable v hioverlay miny value used by the v video subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/v_video.ml#L60)

<a id="global-global-v-hioverlay-scale-v-hioverlay-scale-src-v-video-ml-568620238"></a>
### v_hioverlay_scale

```ml
v_hioverlay_scale
```

Tracks the mutable v hioverlay scale value used by the v video subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/v_video.ml#L56)

<a id="global-global-v-hioverlaymask-v-hioverlaymask-src-v-video-ml-1737248006"></a>
### v_hioverlaymask

```ml
v_hioverlaymask
```

Holds the optional v hioverlaymask resource used by the v video subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/v_video.ml#L54)

<a id="function-function-v-init-function-v-init-src-v-video-ml-2019431812"></a>
### V_Init

```ml
function V_Init()
```

Allocates five logical indexed screens and resets dirty-rectangle plus late-overlay tracking for a fresh video session.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/v_video.ml#L215)

<a id="function-function-v-markhighresoverlaypixel-inline-function-v-markhighresoverlaypixel-idx-x-y-src-v-video-ml-2015538719"></a>
### V_MarkHighresOverlayPixel

```ml
inline function V_MarkHighresOverlayPixel(idx, x, y)
```

Marks one prepared high-resolution overlay pixel as valid.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `idx` | `dynamic` | — | Zero-based element or table index. |
| `x` | `dynamic` | — | Horizontal map- or screen-space coordinate. |
| `y` | `dynamic` | — | Vertical map- or screen-space coordinate. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/v_video.ml#L429)

<a id="function-function-v-markoverlaypixel-inline-function-v-markoverlaypixel-idx-x-y-src-v-video-ml-1231538525"></a>
### V_MarkOverlayPixel

```ml
inline function V_MarkOverlayPixel(idx, x, y)
```

Marks one logical pixel as part of the late UI overlay.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `idx` | `dynamic` | — | Zero-based element or table index. |
| `x` | `dynamic` | — | Horizontal map- or screen-space coordinate. |
| `y` | `dynamic` | — | Vertical map- or screen-space coordinate. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/v_video.ml#L615)

<a id="function-function-v-markrect-function-v-markrect-x-y-width-height-src-v-video-ml-1648572392"></a>
### V_MarkRect

```ml
function V_MarkRect(x, y, width, height)
```

Expands the global dirty bounds to cover both corners of a modified logical-screen rectangle.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `x` | `dynamic` | — | Horizontal map- or screen-space coordinate. |
| `y` | `dynamic` | — | Vertical map- or screen-space coordinate. |
| `width` | `dynamic` | — | Width of the target in pixels or map units. |
| `height` | `dynamic` | — | Height of the target in pixels or map units. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/v_video.ml#L635)

<a id="global-global-v-overlay-active-v-overlay-active-src-v-video-ml-1675395502"></a>
### v_overlay_active

```ml
v_overlay_active
```

Tracks whether v overlay active is active in the v video subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/v_video.ml#L50)

<a id="global-global-v-overlay-maxx-v-overlay-maxx-src-v-video-ml-1872837894"></a>
### v_overlay_maxx

```ml
v_overlay_maxx
```

Tracks the mutable v overlay maxx value used by the v video subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/v_video.ml#L46)

<a id="global-global-v-overlay-maxy-v-overlay-maxy-src-v-video-ml-652151404"></a>
### v_overlay_maxy

```ml
v_overlay_maxy
```

Tracks the mutable v overlay maxy value used by the v video subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/v_video.ml#L48)

<a id="global-global-v-overlay-minx-v-overlay-minx-src-v-video-ml-2121542402"></a>
### v_overlay_minx

```ml
v_overlay_minx
```

Tracks the mutable v overlay minx value used by the v video subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/v_video.ml#L42)

<a id="global-global-v-overlay-miny-v-overlay-miny-src-v-video-ml-1777829968"></a>
### v_overlay_miny

```ml
v_overlay_miny
```

Tracks the mutable v overlay miny value used by the v video subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/v_video.ml#L44)

<a id="global-global-v-overlaymask-v-overlaymask-src-v-video-ml-1661386014"></a>
### v_overlaymask

```ml
v_overlaymask
```

Holds the optional v overlaymask resource used by the v video subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/v_video.ml#L40)

<a id="function-function-v-sethighrespatchoverlayenabled-function-v-sethighrespatchoverlayenabled-enabled-src-v-video-ml-441611519"></a>
### V_SetHighresPatchOverlayEnabled

```ml
function V_SetHighresPatchOverlayEnabled(enabled)
```

Lets dense logical UI batches skip redundant per-glyph HD preparation while preserving normal HUD assets by default.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `enabled` | `dynamic` | — | Whether the requested feature should be enabled. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/v_video.ml#L420)
