# `src/f_finale.ml`

[Home](README.md) · [Files](Files.md)

Implements finale sequencing, text pages, and ending presentation.

Package: [`(global)`](Package-global-1952375359.md)

Reachable from entry: **yes**

## Imports

- `d_event.ml` → [src/d_event.ml](File-src-d-event-ml-1995118760.md)
- `doomstat.ml` → [src/doomstat.ml](File-src-doomstat-ml-1652708088.md)
- `doomtype.ml` → [src/doomtype.ml](File-src-doomtype-ml-372549946.md)
- `dstrings.ml` → [src/dstrings.ml](File-src-dstrings-ml-567491523.md)
- `hu_stuff.ml` → [src/hu_stuff.ml](File-src-hu-stuff-ml-1965779679.md)
- `i_system.ml` → [src/i_system.ml](File-src-i-system-ml-1632920966.md)
- `m_misc.ml` → [src/m_misc.ml](File-src-m-misc-ml-906836777.md)
- `m_swap.ml` → [src/m_swap.ml](File-src-m-swap-ml-1401834276.md)
- `r_state.ml` → [src/r_state.ml](File-src-r-state-ml-691819649.md)
- `s_sound.ml` → [src/s_sound.ml](File-src-s-sound-ml-1485495390.md)
- `sounds.ml` → [src/sounds.ml](File-src-sounds-ml-1875364049.md)
- `v_video.ml` → [src/v_video.ml](File-src-v-video-ml-592999939.md)
- `w_wad.ml` → [src/w_wad.ml](File-src-w-wad-ml-893006035.md)
- `z_zone.ml` → [src/z_zone.ml](File-src-z-zone-ml-1788911354.md)

## Declarations

<a id="function-function-f-anyplayerbuttons-function-f-anyplayerbuttons-src-f-finale-ml-624245860"></a>
### _F_AnyPlayerButtons

```ml
function _F_AnyPlayerButtons()
```

Reports whether any valid player command currently carries a button press used to skip a commercial finale.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/f_finale.ml#L118)

<a id="function-function-f-drawtiledflat-function-f-drawtiledflat-name-src-f-finale-ml-1579450145"></a>
### _F_DrawTiledFlat

```ml
function _F_DrawTiledFlat(name)
```

Fills the logical screen with a repeating 64x64 flat, marks it dirty, and submits the matching HD overlay when available.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `name` | `dynamic` | — | Resource or object name to resolve. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/f_finale.ml#L135)

<a id="function-function-f-endpatchname-inline-function-f-endpatchname-stage-src-f-finale-ml-1059232023"></a>
### _F_EndPatchName

```ml
inline function _F_EndPatchName(stage)
```

Maps a clamped bunny-ending animation stage to its END0-through-END6 patch name.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `stage` | `dynamic` | — | Stage value supplied to `_F_EndPatchName`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/f_finale.ml#L178)

<a id="function-function-f-idiv-inline-function-f-idiv-a-b-src-f-finale-ml-1228827124"></a>
### _F_IDiv

```ml
inline function _F_IDiv(a, b)
```

Returns a signed quotient truncated toward zero, or zero for invalid operands and a zero divisor in `_F_IDiv`

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `a` | `dynamic` | — | First input operand. |
| `b` | `dynamic` | — | Second input operand. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/f_finale.ml#L77)

<a id="function-function-f-patchwidth-inline-function-f-patchwidth-patch-src-f-finale-ml-1468789395"></a>
### _F_PatchWidth

```ml
inline function _F_PatchWidth(patch)
```

Reads a Doom patch width, returning zero for missing or truncated patch data.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `patch` | `dynamic` | — | Patch value supplied to `_F_PatchWidth`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/f_finale.ml#L103)

<a id="function-function-f-substr-inline-function-f-substr-s-n-src-f-finale-ml-395405038"></a>
### _F_Substr

```ml
inline function _F_Substr(s, n)
```

Returns at most the first n encoded bytes of a string, clamping n to the available data.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `s` | `dynamic` | — | S value supplied to `_F_Substr`. |
| `n` | `dynamic` | — | Number of values to process. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/f_finale.ml#L64)

<a id="function-function-f-u16le-inline-function-f-u16le-b-off-src-f-finale-ml-642020952"></a>
### _F_u16le

```ml
inline function _F_u16le(b, off)
```

Decodes an unsigned 16-bit little-endian value from a patch header.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `b` | `dynamic` | — | Second input operand. |
| `off` | `dynamic` | — | Zero-based byte or element offset. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/f_finale.ml#L88)

<a id="function-function-f-u32le-inline-function-f-u32le-b-off-src-f-finale-ml-1461881632"></a>
### _F_u32le

```ml
inline function _F_u32le(b, off)
```

Decodes an unsigned 32-bit little-endian value from a patch column table.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `b` | `dynamic` | — | Second input operand. |
| `off` | `dynamic` | — | Zero-based byte or element offset. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/f_finale.ml#L96)

<a id="function-function-f-upperascii-inline-function-f-upperascii-c-src-f-finale-ml-543028862"></a>
### _F_UpperAscii

```ml
inline function _F_UpperAscii(c)
```

Normalizes lowercase ASCII character codes before indexing the uppercase HUD font.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `c` | `dynamic` | — | C value supplied to `_F_UpperAscii`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/f_finale.ml#L111)

<a id="global-global-bunny-laststage-bunny-laststage-src-f-finale-ml-644754166"></a>
### bunny_laststage

```ml
bunny_laststage
```

Tracks the mutable bunny laststage value used by the f finale subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/f_finale.ml#L58)

<a id="global-global-cast-active-cast-active-src-f-finale-ml-282977990"></a>
### cast_active

```ml
cast_active
```

Tracks whether cast active is active in the f finale subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/f_finale.ml#L52)

<a id="global-global-cast-name-cast-name-src-f-finale-ml-1770192838"></a>
### cast_name

```ml
cast_name
```

Stores the mutable cast name text used by the f finale subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/f_finale.ml#L56)

<a id="global-global-cast-tics-cast-tics-src-f-finale-ml-796647798"></a>
### cast_tics

```ml
cast_tics
```

Tracks the mutable cast tics value used by the f finale subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/f_finale.ml#L54)

<a id="function-function-f-bunnyscroll-function-f-bunnyscroll-src-f-finale-ml-1268295952"></a>
### F_BunnyScroll

```ml
function F_BunnyScroll()
```

Composes the episode-three PFUB panorama, then advances and sounds the centered END0-through-END6 animation.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/f_finale.ml#L437)

<a id="function-function-f-castdrawer-function-f-castdrawer-src-f-finale-ml-961639588"></a>
### F_CastDrawer

```ml
function F_CastDrawer()
```

Draws the cast-stage backdrop and centered actor name while cast presentation is active.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/f_finale.ml#L490)

<a id="function-function-f-castprint-function-f-castprint-text-src-f-finale-ml-279572055"></a>
### F_CastPrint

```ml
function F_CastPrint(text)
```

Measures and renders a cast name centered at y=180, falling back to the menu text renderer when the HUD font is unavailable.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `text` | `dynamic` | — | Text to process. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/f_finale.ml#L357)

<a id="function-function-f-castresponder-function-f-castresponder-ev-src-f-finale-ml-110025057"></a>
### F_CastResponder

```ml
function F_CastResponder(ev)
```

Consumes key-down events during the cast stage and advances its input-driven counter.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `ev` | `dynamic` | — | Input event to process. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/f_finale.ml#L344)

<a id="function-function-f-castticker-function-f-castticker-src-f-finale-ml-70992336"></a>
### F_CastTicker

```ml
function F_CastTicker()
```

Advances the cast-stage elapsed-tic counter while that stage is active.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/f_finale.ml#L336)

<a id="function-function-f-drawer-function-f-drawer-src-f-finale-ml-1327430912"></a>
### F_Drawer

```ml
function F_Drawer()
```

Dispatches finale rendering between story text, cast presentation, and the episode-specific ending artwork.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/f_finale.ml#L536)

<a id="function-function-f-drawpatchcol-function-f-drawpatchcol-x-patch-col-src-f-finale-ml-73259202"></a>
### F_DrawPatchCol

```ml
function F_DrawPatchCol(x, patch, col)
```

Decodes one post-compressed Doom patch column into the logical framebuffer with horizontal and vertical bounds checks.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `x` | `dynamic` | — | Horizontal map- or screen-space coordinate. |
| `patch` | `dynamic` | — | Patch value supplied to `F_DrawPatchCol`. |
| `col` | `dynamic` | — | Col value supplied to `F_DrawPatchCol`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/f_finale.ml#L405)

<a id="function-function-f-responder-function-f-responder-ev-src-f-finale-ml-471896075"></a>
### F_Responder

```ml
function F_Responder(ev)
```

Routes input only to the cast stage; text and art stages deliberately leave events unconsumed.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `ev` | `dynamic` | — | Input event to process. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/f_finale.ml#L269)

<a id="function-function-f-startcast-function-f-startcast-src-f-finale-ml-516556096"></a>
### F_StartCast

```ml
function F_StartCast()
```

Switches the finale into its cast stage, initializes its placeholder actor state, and starts the evil music track.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/f_finale.ml#L322)

<a id="function-function-f-startfinale-function-f-startfinale-src-f-finale-ml-1731171528"></a>
### F_StartFinale

```ml
function F_StartFinale()
```

Enters GS_FINALE, selects the episode/map text and background, and starts the appropriate finale music.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/f_finale.ml#L189)

<a id="function-function-f-textwrite-function-f-textwrite-src-f-finale-ml-1883472226"></a>
### F_TextWrite

```ml
function F_TextWrite()
```

Draws the tiled finale background and reveals the selected story text at TEXTSPEED using the HUD font.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/f_finale.ml#L278)

<a id="function-function-f-ticker-function-f-ticker-src-f-finale-ml-421623840"></a>
### F_Ticker

```ml
function F_Ticker()
```

Advances finale time, handles commercial skip/world completion, and transitions non-commercial text into its art stage.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/f_finale.ml#L500)

<a id="global-global-finale-count-finale-count-src-f-finale-ml-1561704056"></a>
### finale_count

```ml
finale_count
```

Tracks the mutable finale count value used by the f finale subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/f_finale.ml#L43)

<a id="global-global-finale-flat-finale-flat-src-f-finale-ml-1378218230"></a>
### finale_flat

```ml
finale_flat
```

Stores the mutable finale flat text used by the f finale subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/f_finale.ml#L49)

<a id="global-global-finale-stage-finale-stage-src-f-finale-ml-29687078"></a>
### finale_stage

```ml
finale_stage
```

Tracks the mutable finale stage value used by the f finale subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/f_finale.ml#L45)

<a id="global-global-finale-started-finale-started-src-f-finale-ml-1410049276"></a>
### finale_started

```ml
finale_started
```

Tracks whether finale started is active in the f finale subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/f_finale.ml#L41)

<a id="global-global-finale-text-finale-text-src-f-finale-ml-1752562818"></a>
### finale_text

```ml
finale_text
```

Stores the mutable finale text text used by the f finale subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/f_finale.ml#L47)

<a id="constant-constant-textspeed-const-textspeed-3-src-f-finale-ml-2117935752"></a>
### TEXTSPEED

```ml
const TEXTSPEED = 3
```

Defines textspeed for the f finale subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/f_finale.ml#L36)

<a id="constant-constant-textwait-const-textwait-250-src-f-finale-ml-1949560204"></a>
### TEXTWAIT

```ml
const TEXTWAIT = 250
```

Defines textwait for the f finale subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/f_finale.ml#L38)
