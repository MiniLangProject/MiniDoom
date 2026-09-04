# `src/hu_lib.ml`

[Home](README.md) · [Files](Files.md)

Implements HUD scrolling text, editable input lines, font drawing, and dirty-region erasure for classic view borders.

Package: [`(global)`](Package-global-1952375359.md)

Reachable from entry: **yes**

## Imports

- `doomdef.ml` → [src/doomdef.ml](File-src-doomdef-ml-460406769.md)
- `m_swap.ml` → [src/m_swap.ml](File-src-m-swap-ml-1401834276.md)
- `r_defs.ml` → [src/r_defs.ml](File-src-r-defs-ml-1187974936.md)
- `r_draw.ml` → [src/r_draw.ml](File-src-r-draw-ml-919823710.md)
- `r_local.ml` → [src/r_local.ml](File-src-r-local-ml-797040731.md)
- `v_video.ml` → [src/v_video.ml](File-src-v-video-ml-592999939.md)

## Declarations

<a id="function-function-hulib-appendbytes-function-hulib-appendbytes-tl-b-src-hu-lib-ml-657512177"></a>
### _HUlib_appendBytes

```ml
function _HUlib_appendBytes(tl, b)
```

Appends an entire byte sequence through the text-line capacity and dirty-state rules.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `tl` | `dynamic` | — | Tl value supplied to `_HUlib_appendBytes`. |
| `b` | `dynamic` | — | Second input operand. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/hu_lib.ml#L324)

<a id="function-function-hulib-needsval-inline-function-hulib-needsval-v-src-hu-lib-ml-1450210638"></a>
### _HUlib_needsVal

```ml
inline function _HUlib_needsVal(v)
```

Normalizes numeric or boolean dirty-line state to the integer redraw count consumed by erase logic.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `v` | `dynamic` | — | Value consumed by the operation. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/hu_lib.ml#L148)

<a id="function-function-hulib-patchat-inline-function-hulib-patchat-font-idx-src-hu-lib-ml-1136400172"></a>
### _HUlib_patchAt

```ml
inline function _HUlib_patchAt(font, idx)
```

Safely retrieves one glyph patch from a font array without exposing out-of-range indexing.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `font` | `dynamic` | — | Font value supplied to `_HUlib_patchAt`. |
| `idx` | `dynamic` | — | Zero-based element or table index. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/hu_lib.ml#L131)

<a id="function-function-hulib-patchheight-inline-function-hulib-patchheight-p-src-hu-lib-ml-718718788"></a>
### _HUlib_patchHeight

```ml
inline function _HUlib_patchHeight(p)
```

Reads a validated font patch's signed little-endian height, returning zero for absent data.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `p` | `dynamic` | — | Object or data record consumed by the operation. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/hu_lib.ml#L122)

<a id="function-function-hulib-patchwidth-inline-function-hulib-patchwidth-p-src-hu-lib-ml-338476484"></a>
### _HUlib_patchWidth

```ml
inline function _HUlib_patchWidth(p)
```

Reads a validated font patch's signed little-endian width, returning zero for absent data.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `p` | `dynamic` | — | Object or data record consumed by the operation. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/hu_lib.ml#L114)

<a id="function-function-hulib-refbool-inline-function-hulib-refbool-v-src-hu-lib-ml-215390286"></a>
### _HUlib_refBool

```ml
inline function _HUlib_refBool(v)
```

Resolves direct or single-element referenced values to the truth value used by HUD visibility toggles.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `v` | `dynamic` | — | Value consumed by the operation. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/hu_lib.ml#L104)

<a id="function-function-hulib-tobyte-inline-function-hulib-tobyte-ch-src-hu-lib-ml-1710511449"></a>
### _HUlib_toByte

```ml
inline function _HUlib_toByte(ch)
```

Normalizes an integer or one-character string to the byte value stored in HUD text buffers.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `ch` | `dynamic` | — | Ch value supplied to `_HUlib_toByte`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/hu_lib.ml#L90)

<a id="function-function-hulib-upper-inline-function-hulib-upper-c-src-hu-lib-ml-839689773"></a>
### _HUlib_upper

```ml
inline function _HUlib_upper(c)
```

Converts lowercase ASCII glyph codes to the uppercase range used by Doom's HUD font.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `c` | `dynamic` | — | C value supplied to `_HUlib_upper`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/hu_lib.ml#L140)

<a id="constant-constant-hu-charerase-const-hu-charerase-127-src-hu-lib-ml-1615844846"></a>
### HU_CHARERASE

```ml
const HU_CHARERASE = 127
```

Defines hu charerase for the hu lib subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/hu_lib.ml#L29)

- [hu_itext_t](Type-hu-itext-t-1658691086.md) — struct
<a id="constant-constant-hu-maxlinelength-const-hu-maxlinelength-80-src-hu-lib-ml-1918153356"></a>
### HU_MAXLINELENGTH

```ml
const HU_MAXLINELENGTH = 80
```

Defines the maximum hu maxlinelength accepted by the hu lib subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/hu_lib.ml#L33)

<a id="constant-constant-hu-maxlines-const-hu-maxlines-4-src-hu-lib-ml-1344899624"></a>
### HU_MAXLINES

```ml
const HU_MAXLINES = 4
```

Defines the maximum hu maxlines accepted by the hu lib subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/hu_lib.ml#L31)

- [hu_stext_t](Type-hu-stext-t-148439260.md) — struct
- [hu_textline_t](Type-hu-textline-t-287822837.md) — struct
<a id="function-function-hulib-addchartotextline-function-hulib-addchartotextline-t-ch-src-hu-lib-ml-1188376490"></a>
### HUlib_addCharToTextLine

```ml
function HUlib_addCharToTextLine(t, ch)
```

Appends one normalized byte when capacity permits, maintains the zero terminator, and schedules four redraws.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `t` | `dynamic` | — | T value supplied to `HUlib_addCharToTextLine`. |
| `ch` | `dynamic` | — | Ch value supplied to `HUlib_addCharToTextLine`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/hu_lib.ml#L193)

<a id="function-function-hulib-addlinetostext-function-hulib-addlinetostext-s-src-hu-lib-ml-1538269276"></a>
### HUlib_addLineToSText

```ml
function HUlib_addLineToSText(s)
```

Advances the circular message cursor, clears the reused line, and marks every visible stack line dirty.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `s` | `dynamic` | — | S value supplied to `HUlib_addLineToSText`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/hu_lib.ml#L307)

<a id="function-function-hulib-addmessagetostext-function-hulib-addmessagetostext-s-prefix-msg-src-hu-lib-ml-1643916663"></a>
### HUlib_addMessageToSText

```ml
function HUlib_addMessageToSText(s, prefix, msg)
```

Opens a new stack line and concatenates an optional prefix with the message text.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `s` | `dynamic` | — | S value supplied to `HUlib_addMessageToSText`. |
| `prefix` | `dynamic` | — | Prefix value supplied to `HUlib_addMessageToSText`. |
| `msg` | `dynamic` | — | Msg value supplied to `HUlib_addMessageToSText`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/hu_lib.ml#L335)

<a id="function-function-hulib-addprefixtoitext-function-hulib-addprefixtoitext-it-str-src-hu-lib-ml-2138441435"></a>
### HUlib_addPrefixToIText

```ml
function HUlib_addPrefixToIText(it, str)
```

Appends a fixed prompt prefix and advances the deletion boundary to protect it from backspace.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `it` | `dynamic` | — | It value supplied to `HUlib_addPrefixToIText`. |
| `str` | `dynamic` | — | Str value supplied to `HUlib_addPrefixToIText`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/hu_lib.ml#L420)

<a id="function-function-hulib-cleartextline-function-hulib-cleartextline-t-src-hu-lib-ml-1697740921"></a>
### HUlib_clearTextLine

```ml
function HUlib_clearTextLine(t)
```

Clears hUlib clear Text Line state before the next heads-up display update.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `t` | `dynamic` | — | T value supplied to `HUlib_clearTextLine`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/hu_lib.ml#L159)

<a id="function-function-hulib-delcharfromitext-function-hulib-delcharfromitext-it-src-hu-lib-ml-10039910"></a>
### HUlib_delCharFromIText

```ml
function HUlib_delCharFromIText(it)
```

Deletes one input byte only when it lies after the protected prefix boundary.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `it` | `dynamic` | — | It value supplied to `HUlib_delCharFromIText`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/hu_lib.ml#L394)

<a id="function-function-hulib-delcharfromtextline-function-hulib-delcharfromtextline-t-src-hu-lib-ml-1038206113"></a>
### HUlib_delCharFromTextLine

```ml
function HUlib_delCharFromTextLine(t)
```

Removes the final byte from a nonempty HUD line, restores termination, and schedules redraws.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `t` | `dynamic` | — | T value supplied to `HUlib_delCharFromTextLine`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/hu_lib.ml#L206)

<a id="function-function-hulib-drawitext-function-hulib-drawitext-it-src-hu-lib-ml-957077604"></a>
### HUlib_drawIText

```ml
function HUlib_drawIText(it)
```

Draws a visible editable line with the cursor glyph placed after its current text.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `it` | `dynamic` | — | It value supplied to `HUlib_drawIText`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/hu_lib.ml#L448)

<a id="function-function-hulib-drawstext-function-hulib-drawstext-s-src-hu-lib-ml-1531664234"></a>
### HUlib_drawSText

```ml
function HUlib_drawSText(s)
```

Draws visible stack lines newest-first by walking backward through the circular buffer.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `s` | `dynamic` | — | S value supplied to `HUlib_drawSText`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/hu_lib.ml#L345)

<a id="function-function-hulib-drawtextline-function-hulib-drawtextline-l-drawcursor-src-hu-lib-ml-1384136783"></a>
### HUlib_drawTextLine

```ml
function HUlib_drawTextLine(l, drawcursor)
```

Renders a HUD text buffer with patch-font glyph widths, optional cursor, spaces, and right-edge clipping.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `l` | `dynamic` | — | L value supplied to `HUlib_drawTextLine`. |
| `drawcursor` | `dynamic` | — | Drawcursor value supplied to `HUlib_drawTextLine`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/hu_lib.ml#L218)

<a id="function-function-hulib-eraseitext-function-hulib-eraseitext-it-src-hu-lib-ml-669856574"></a>
### HUlib_eraseIText

```ml
function HUlib_eraseIText(it)
```

Erases a dirty input line, forcing redraws when its externally controlled visibility turns off.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `it` | `dynamic` | — | It value supplied to `HUlib_eraseIText`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/hu_lib.ml#L456)

<a id="function-function-hulib-eraselinefromitext-function-hulib-eraselinefromitext-it-src-hu-lib-ml-1646816114"></a>
### HUlib_eraseLineFromIText

```ml
function HUlib_eraseLineFromIText(it)
```

Removes all editable input while retaining the protected prefix bytes.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `it` | `dynamic` | — | It value supplied to `HUlib_eraseLineFromIText`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/hu_lib.ml#L402)

<a id="function-function-hulib-erasestext-function-hulib-erasestext-s-src-hu-lib-ml-1321217732"></a>
### HUlib_eraseSText

```ml
function HUlib_eraseSText(s)
```

Marks lines dirty on visibility transitions, erases every stack line, and remembers the current visibility state.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `s` | `dynamic` | — | S value supplied to `HUlib_eraseSText`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/hu_lib.ml#L361)

<a id="function-function-hulib-erasetextline-function-hulib-erasetextline-l-src-hu-lib-ml-1695318591"></a>
### HUlib_eraseTextLine

```ml
function HUlib_eraseTextLine(l)
```

Restores border regions covered by a dirty HUD line and decrements its multi-frame redraw counter.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `l` | `dynamic` | — | L value supplied to `HUlib_eraseTextLine`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/hu_lib.ml#L250)

<a id="function-function-hulib-init-function-hulib-init-src-hu-lib-ml-424823637"></a>
### HUlib_init

```ml
function HUlib_init()
```

Preserves the original HUD-library initialization hook; this implementation has no module-wide resources to allocate.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/hu_lib.ml#L83)

<a id="function-function-hulib-inititext-function-hulib-inititext-it-x-y-font-startchar-on-src-hu-lib-ml-1168220829"></a>
### HUlib_initIText

```ml
function HUlib_initIText(it, x, y, font, startchar, on)
```

Creates an editable HUD line, clears its protected-prefix boundary, and attaches its visibility reference.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `it` | `dynamic` | — | It value supplied to `HUlib_initIText`. |
| `x` | `dynamic` | — | Horizontal map- or screen-space coordinate. |
| `y` | `dynamic` | — | Vertical map- or screen-space coordinate. |
| `font` | `dynamic` | — | Font value supplied to `HUlib_initIText`. |
| `startchar` | `dynamic` | — | Startchar value supplied to `HUlib_initIText`. |
| `on` | `dynamic` | — | On value supplied to `HUlib_initIText`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/hu_lib.ml#L383)

<a id="function-function-hulib-initstext-function-hulib-initstext-s-x-y-h-font-startchar-on-src-hu-lib-ml-2134593597"></a>
### HUlib_initSText

```ml
function HUlib_initSText(s, x, y, h, font, startchar, on)
```

Builds a fixed-height circular message stack whose lines are vertically spaced from the font height.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `s` | `dynamic` | — | S value supplied to `HUlib_initSText`. |
| `x` | `dynamic` | — | Horizontal map- or screen-space coordinate. |
| `y` | `dynamic` | — | Vertical map- or screen-space coordinate. |
| `h` | `dynamic` | — | H value supplied to `HUlib_initSText`. |
| `font` | `dynamic` | — | Font value supplied to `HUlib_initSText`. |
| `startchar` | `dynamic` | — | Startchar value supplied to `HUlib_initSText`. |
| `on` | `dynamic` | — | On value supplied to `HUlib_initSText`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/hu_lib.ml#L285)

<a id="function-function-hulib-inittextline-function-hulib-inittextline-t-x-y-f-sc-src-hu-lib-ml-981397914"></a>
### HUlib_initTextLine

```ml
function HUlib_initTextLine(t, x, y, f, sc)
```

Assigns position and font metadata, allocates a bounded text buffer, and marks a HUD line dirty.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `t` | `dynamic` | — | T value supplied to `HUlib_initTextLine`. |
| `x` | `dynamic` | — | Horizontal map- or screen-space coordinate. |
| `y` | `dynamic` | — | Vertical map- or screen-space coordinate. |
| `f` | `dynamic` | — | F value supplied to `HUlib_initTextLine`. |
| `sc` | `dynamic` | — | Sc value supplied to `HUlib_initTextLine`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/hu_lib.ml#L178)

<a id="function-function-hulib-keyinitext-function-hulib-keyinitext-it-ch-src-hu-lib-ml-2005175831"></a>
### HUlib_keyInIText

```ml
function HUlib_keyInIText(it, ch)
```

Applies printable, backspace, or enter input to an editable HUD line and reports whether the key was consumed.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `it` | `dynamic` | — | It value supplied to `HUlib_keyInIText`. |
| `ch` | `dynamic` | — | Ch value supplied to `HUlib_keyInIText`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/hu_lib.ml#L431)

<a id="function-function-hulib-resetitext-function-hulib-resetitext-it-src-hu-lib-ml-1757403654"></a>
### HUlib_resetIText

```ml
function HUlib_resetIText(it)
```

Clears hUlib reset IText state before the next heads-up display update.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `it` | `dynamic` | — | It value supplied to `HUlib_resetIText`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/hu_lib.ml#L411)
