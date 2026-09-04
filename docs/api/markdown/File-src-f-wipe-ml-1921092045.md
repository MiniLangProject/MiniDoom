# `src/f_wipe.ml`

[Home](README.md) · [Files](Files.md)

Captures transition screens and incrementally blends or melts the old image into the new one.

Package: [`(global)`](Package-global-1952375359.md)

Reachable from entry: **yes**

## Imports

- `doomdef.ml` → [src/doomdef.ml](File-src-doomdef-ml-460406769.md)
- `i_video.ml` → [src/i_video.ml](File-src-i-video-ml-140536292.md)
- `m_random.ml` → [src/m_random.ml](File-src-m-random-ml-1659574948.md)
- `v_video.ml` → [src/v_video.ml](File-src-v-video-ml-592999939.md)
- `z_zone.ml` → [src/z_zone.ml](File-src-z-zone-ml-1788911354.md)

## Declarations

<a id="function-function-fw-bytecopy-function-fw-bytecopy-dst-src-count-src-f-wipe-ml-198788964"></a>
### _FW_ByteCopy

```ml
function _FW_ByteCopy(dst, src, count)
```

Copies the common bounded prefix of two byte buffers without overrunning either allocation.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `dst` | `dynamic` | — | Dst value supplied to `_FW_ByteCopy`. |
| `src` | `dynamic` | — | Src value supplied to `_FW_ByteCopy`. |
| `count` | `dynamic` | — | Number of elements or iterations to process. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/f_wipe.ml#L83)

<a id="function-function-fw-readu16le-inline-function-fw-readu16le-buf-wordindex-src-f-wipe-ml-93044764"></a>
### _FW_ReadU16LE

```ml
inline function _FW_ReadU16LE(buf, wordIndex)
```

Reads one bounds-checked little-endian 16-bit pixel pair from a byte buffer.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `buf` | `dynamic` | — | Buf value supplied to `_FW_ReadU16LE`. |
| `wordIndex` | `dynamic` | — | Index identifying word. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/f_wipe.ml#L57)

<a id="function-function-fw-writeu16le-inline-function-fw-writeu16le-buf-wordindex-v-src-f-wipe-ml-1259196044"></a>
### _FW_WriteU16LE

```ml
inline function _FW_WriteU16LE(buf, wordIndex, v)
```

Writes one bounds-checked little-endian 16-bit pixel pair into a byte buffer.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `buf` | `dynamic` | — | Buf value supplied to `_FW_WriteU16LE`. |
| `wordIndex` | `dynamic` | — | Index identifying word. |
| `v` | `dynamic` | — | Value consumed by the operation. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/f_wipe.ml#L69)

<a id="function-function-wiperand-inline-function-wiperand-src-f-wipe-ml-1026589449"></a>
### _wipeRand

```ml
inline function _wipeRand()
```

Produces deterministic 15-bit fallback randomness for melt-column delays when the game RNG is unavailable.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/f_wipe.ml#L46)

<a id="constant-constant-wipe-colorxform-const-wipe-colorxform-0-src-f-wipe-ml-510615537"></a>
### wipe_ColorXForm

```ml
const wipe_ColorXForm = 0
```

Defines the Doom palette selection for wipe color xform.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/f_wipe.ml#L27)

<a id="function-function-wipe-docolorxform-function-wipe-docolorxform-width-height-ticks-src-f-wipe-ml-29165677"></a>
### wipe_doColorXForm

```ml
function wipe_doColorXForm(width, height, ticks)
```

Moves every live palette index toward its target by at most ticks and reports when no differing pixels remain.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `width` | `dynamic` | — | Width of the target in pixels or map units. |
| `height` | `dynamic` | — | Height of the target in pixels or map units. |
| `ticks` | `dynamic` | — | Ticks value supplied to `wipe_doColorXForm`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/f_wipe.ml#L146)

<a id="function-function-wipe-domelt-function-wipe-domelt-width-height-ticks-src-f-wipe-ml-9724751"></a>
### wipe_doMelt

```ml
function wipe_doMelt(width, height, ticks)
```

Advances each delayed two-pixel melt column, exposing target pixels above and retaining source pixels below its frontier.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `width` | `dynamic` | — | Width of the target in pixels or map units. |
| `height` | `dynamic` | — | Height of the target in pixels or map units. |
| `ticks` | `dynamic` | — | Ticks value supplied to `wipe_doMelt`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/f_wipe.ml#L237)

<a id="function-function-wipe-endscreen-function-wipe-endscreen-x-y-width-height-src-f-wipe-ml-1294817912"></a>
### wipe_EndScreen

```ml
function wipe_EndScreen(x, y, width, height)
```

Captures the newly drawn display as the target snapshot, then restores the start image before animation begins.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `x` | `dynamic` | — | Horizontal map- or screen-space coordinate. |
| `y` | `dynamic` | — | Vertical map- or screen-space coordinate. |
| `width` | `dynamic` | — | Width of the target in pixels or map units. |
| `height` | `dynamic` | — | Height of the target in pixels or map units. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/f_wipe.ml#L340)

<a id="function-function-wipe-endscreenfrombuffer-function-wipe-endscreenfrombuffer-x-y-width-height-buf-src-f-wipe-ml-1800279853"></a>
### wipe_EndScreenFromBuffer

```ml
function wipe_EndScreenFromBuffer(x, y, width, height, buf)
```

Uses a supplied target snapshot and restores the captured start image, avoiding a display readback.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `x` | `dynamic` | — | Horizontal map- or screen-space coordinate. |
| `y` | `dynamic` | — | Vertical map- or screen-space coordinate. |
| `width` | `dynamic` | — | Width of the target in pixels or map units. |
| `height` | `dynamic` | — | Height of the target in pixels or map units. |
| `buf` | `dynamic` | — | Buf value supplied to `wipe_EndScreenFromBuffer`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/f_wipe.ml#L359)

<a id="function-function-wipe-exitcolorxform-function-wipe-exitcolorxform-width-height-ticks-src-f-wipe-ml-1273337487"></a>
### wipe_exitColorXForm

```ml
function wipe_exitColorXForm(width, height, ticks)
```

Completes the color-wipe lifecycle; this mode owns no temporary state requiring release.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `width` | `dynamic` | — | Width of the target in pixels or map units. |
| `height` | `dynamic` | — | Height of the target in pixels or map units. |
| `ticks` | `dynamic` | — | Ticks value supplied to `wipe_exitColorXForm`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/f_wipe.ml#L187)

<a id="function-function-wipe-exitmelt-function-wipe-exitmelt-width-height-ticks-src-f-wipe-ml-768414165"></a>
### wipe_exitMelt

```ml
function wipe_exitMelt(width, height, ticks)
```

Releases the per-column melt-frontier array after the transition reaches the bottom of the screen.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `width` | `dynamic` | — | Width of the target in pixels or map units. |
| `height` | `dynamic` | — | Height of the target in pixels or map units. |
| `ticks` | `dynamic` | — | Ticks value supplied to `wipe_exitMelt`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/f_wipe.ml#L301)

<a id="global-global-wipe-go-wipe-go-src-f-wipe-ml-598282906"></a>
### wipe_go

```ml
wipe_go
```

Tracks whether wipe go is active in the f wipe subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/f_wipe.ml#L32)

<a id="function-function-wipe-initcolorxform-function-wipe-initcolorxform-width-height-ticks-src-f-wipe-ml-2107596587"></a>
### wipe_initColorXForm

```ml
function wipe_initColorXForm(width, height, ticks)
```

Seeds the live framebuffer from the captured start image before a palette-index crossfade.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `width` | `dynamic` | — | Width of the target in pixels or map units. |
| `height` | `dynamic` | — | Height of the target in pixels or map units. |
| `ticks` | `dynamic` | — | Ticks value supplied to `wipe_initColorXForm`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/f_wipe.ml#L134)

<a id="function-function-wipe-initmelt-function-wipe-initmelt-width-height-ticks-src-f-wipe-ml-1766921797"></a>
### wipe_initMelt

```ml
function wipe_initMelt(width, height, ticks)
```

Copies the start image, converts snapshots to column-major pairs, and assigns correlated random delays to melt columns.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `width` | `dynamic` | — | Width of the target in pixels or map units. |
| `height` | `dynamic` | — | Height of the target in pixels or map units. |
| `ticks` | `dynamic` | — | Ticks value supplied to `wipe_initMelt`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/f_wipe.ml#L199)

<a id="constant-constant-wipe-melt-const-wipe-melt-1-src-f-wipe-ml-445685222"></a>
### wipe_Melt

```ml
const wipe_Melt = 1
```

Defines wipe melt for the f wipe subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/f_wipe.ml#L29)

<a id="global-global-wipe-scr-wipe-scr-src-f-wipe-ml-275398066"></a>
### wipe_scr

```ml
wipe_scr
```

Holds the optional wipe scr resource used by the f wipe subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/f_wipe.ml#L34)

<a id="global-global-wipe-scr-end-wipe-scr-end-src-f-wipe-ml-534587274"></a>
### wipe_scr_end

```ml
wipe_scr_end
```

Holds the optional wipe scr end resource used by the f wipe subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/f_wipe.ml#L38)

<a id="global-global-wipe-scr-start-wipe-scr-start-src-f-wipe-ml-1749820352"></a>
### wipe_scr_start

```ml
wipe_scr_start
```

Holds the optional wipe scr start resource used by the f wipe subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/f_wipe.ml#L36)

<a id="function-function-wipe-screenwipe-function-wipe-screenwipe-wipeno-x-y-width-height-ticks-src-f-wipe-ml-561049934"></a>
### wipe_ScreenWipe

```ml
function wipe_ScreenWipe(wipeno, x, y, width, height, ticks)
```

Initializes, advances, and finalizes the selected wipe mode; returns true only after the transition completes.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `wipeno` | `dynamic` | — | Wipeno value supplied to `wipe_ScreenWipe`. |
| `x` | `dynamic` | — | Horizontal map- or screen-space coordinate. |
| `y` | `dynamic` | — | Vertical map- or screen-space coordinate. |
| `width` | `dynamic` | — | Width of the target in pixels or map units. |
| `height` | `dynamic` | — | Height of the target in pixels or map units. |
| `ticks` | `dynamic` | — | Ticks value supplied to `wipe_ScreenWipe`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/f_wipe.ml#L380)

<a id="global-global-wipe-seed-wipe-seed-src-f-wipe-ml-553707618"></a>
### wipe_seed

```ml
wipe_seed
```

Tracks the mutable wipe seed value used by the f wipe subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/f_wipe.ml#L42)

<a id="function-function-wipe-shittycolmajorxform-function-wipe-shittycolmajorxform-array16-width-height-src-f-wipe-ml-860301543"></a>
### wipe_shittyColMajorXform

```ml
function wipe_shittyColMajorXform(array16, width, height)
```

Transposes packed two-pixel words in place from row-major to column-major order for independent melt columns.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `array16` | `dynamic` | — | Array16 value supplied to `wipe_shittyColMajorXform`. |
| `width` | `dynamic` | — | Width of the target in pixels or map units. |
| `height` | `dynamic` | — | Height of the target in pixels or map units. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/f_wipe.ml#L100)

<a id="function-function-wipe-startscreen-function-wipe-startscreen-x-y-width-height-src-f-wipe-ml-1129275984"></a>
### wipe_StartScreen

```ml
function wipe_StartScreen(x, y, width, height)
```

Captures the current display into the start snapshot and selects screen zero as the transition output buffer.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `x` | `dynamic` | — | Horizontal map- or screen-space coordinate. |
| `y` | `dynamic` | — | Vertical map- or screen-space coordinate. |
| `width` | `dynamic` | — | Width of the target in pixels or map units. |
| `height` | `dynamic` | — | Height of the target in pixels or map units. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/f_wipe.ml#L317)

<a id="global-global-wipe-y-wipe-y-src-f-wipe-ml-1411868820"></a>
### wipe_y

```ml
wipe_y
```

Holds the optional wipe y resource used by the f wipe subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/f_wipe.ml#L40)
