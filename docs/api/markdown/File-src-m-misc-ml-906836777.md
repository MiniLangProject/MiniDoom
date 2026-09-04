# `src/m_misc.ml`

[Home](README.md) · [Files](Files.md)

Handles configuration defaults, screenshots, file buffers, and Doom patch-backed utility output.

Package: [`(global)`](Package-global-1952375359.md)

Reachable from entry: **yes**

## Imports

- `doomdef.ml` → [src/doomdef.ml](File-src-doomdef-ml-460406769.md)
- `doomstat.ml` → [src/doomstat.ml](File-src-doomstat-ml-1652708088.md)
- `doomtype.ml` → [src/doomtype.ml](File-src-doomtype-ml-372549946.md)
- `dstrings.ml` → [src/dstrings.ml](File-src-dstrings-ml-567491523.md)
- `hu_stuff.ml` → [src/hu_stuff.ml](File-src-hu-stuff-ml-1965779679.md)
- `i_system.ml` → [src/i_system.ml](File-src-i-system-ml-1632920966.md)
- `i_video.ml` → [src/i_video.ml](File-src-i-video-ml-140536292.md)
- `m_argv.ml` → [src/m_argv.ml](File-src-m-argv-ml-728984635.md)
- `m_menu.ml` → [src/m_menu.ml](File-src-m-menu-ml-331716860.md)
- `m_misc.ml` → [src/m_misc.ml](File-src-m-misc-ml-906836777.md)
- `m_swap.ml` → [src/m_swap.ml](File-src-m-swap-ml-1401834276.md)
- `mp_state.ml` → [src/mp_state.ml](File-src-mp-state-ml-130741680.md)
- `std/fs.ml` as `fs` → `../MiniLangCompilerOptimization/MiniLangCompilerPy/std/fs.ml` — external dependency
- `v_video.ml` → [src/v_video.ml](File-src-v-video-ml-592999939.md)
- `w_wad.ml` → [src/w_wad.ml](File-src-w-wad-ml-893006035.md)
- `z_zone.ml` → [src/z_zone.ml](File-src-z-zone-ml-1788911354.md)

## Declarations

<a id="function-function-m-applydefaultkv-function-m-applydefaultkv-key-val-src-m-misc-ml-1975610468"></a>
### _M_ApplyDefaultKV

```ml
function _M_ApplyDefaultKV(key, val)
```

Parses one configuration key/value pair and assigns the converted value to the matching registered default.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `key` | `dynamic` | — | Input key code to process. |
| `val` | `dynamic` | — | Val value supplied to `_M_ApplyDefaultKV`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/m_misc.ml#L271)

<a id="function-function-m-getdefaultfilepath-function-m-getdefaultfilepath-src-m-misc-ml-738690622"></a>
### _M_GetDefaultFilePath

```ml
function _M_GetDefaultFilePath()
```

Chooses the configuration path from -config, the -cdrom legacy location, an existing base override, or default.cfg.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/m_misc.ml#L381)

<a id="function-function-m-isspacebyte-inline-function-m-isspacebyte-c-src-m-misc-ml-739644970"></a>
### _M_IsSpaceByte

```ml
inline function _M_IsSpaceByte(c)
```

Recognizes the space and horizontal-tab delimiters accepted in configuration lines.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `c` | `dynamic` | — | C value supplied to `_M_IsSpaceByte`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/m_misc.ml#L169)

<a id="function-function-m-makeshotname-inline-function-m-makeshotname-i-src-m-misc-ml-1590530684"></a>
### _M_MakeShotName

```ml
inline function _M_MakeShotName(i)
```

Formats a two-digit screenshot slot as the classic DOOMnn.pcx filename.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `i` | `dynamic` | — | Zero-based iteration index. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/m_misc.ml#L87)

<a id="function-function-m-parentdirexists-function-m-parentdirexists-path-src-m-misc-ml-2098313141"></a>
### _M_ParentDirExists

```ml
function _M_ParentDirExists(path)
```

Determines whether a target path can be written by verifying that its parent directory exists.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `path` | `dynamic` | — | Filesystem path to process. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/m_misc.ml#L427)

<a id="function-function-m-parsedefaultline-function-m-parsedefaultline-line-src-m-misc-ml-860847524"></a>
### _M_ParseDefaultLine

```ml
function _M_ParseDefaultLine(line)
```

Parses parse Default Line input into utility runtime data.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `line` | `dynamic` | — | Map line or text line affected by the operation. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/m_misc.ml#L400)

<a id="function-function-m-parseint-function-m-parseint-s0-src-m-misc-ml-2064530559"></a>
### _M_ParseInt

```ml
function _M_ParseInt(s0)
```

Parses parse Int input into utility runtime data.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `s0` | `dynamic` | — | S0 value supplied to `_M_ParseInt`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/m_misc.ml#L198)

<a id="function-function-m-parsetext-inline-function-m-parsetext-s0-src-m-misc-ml-1253081344"></a>
### _M_ParseText

```ml
inline function _M_ParseText(s0)
```

Parses optional quoted text value from config lines.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `s0` | `dynamic` | — | S0 value supplied to `_M_ParseText`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/m_misc.ml#L239)

<a id="function-function-m-patchwidth-inline-function-m-patchwidth-patch-src-m-misc-ml-806404199"></a>
### _M_patchWidth

```ml
inline function _M_patchWidth(patch)
```

Reads a Doom patch's little-endian width field, returning zero for malformed data.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `patch` | `dynamic` | — | Patch value supplied to `_M_patchWidth`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/m_misc.ml#L48)

<a id="function-function-m-quotetext-function-m-quotetext-s0-src-m-misc-ml-621705853"></a>
### _M_QuoteText

```ml
function _M_QuoteText(s0)
```

Wraps text in quotes for config persistence.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `s0` | `dynamic` | — | S0 value supplied to `_M_QuoteText`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/m_misc.ml#L253)

<a id="function-function-m-trim-function-m-trim-s0-src-m-misc-ml-1192847775"></a>
### _M_Trim

```ml
function _M_Trim(s0)
```

Removes leading and trailing configuration whitespace without altering embedded spaces.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `s0` | `dynamic` | — | S0 value supplied to `_M_Trim`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/m_misc.ml#L176)

<a id="function-function-m-u16le-inline-function-m-u16le-b-off-src-m-misc-ml-2125663046"></a>
### _M_u16le

```ml
inline function _M_u16le(b, off)
```

Decodes one unsigned little-endian 16-bit value from a byte buffer with bounds checks.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `b` | `dynamic` | — | Second input operand. |
| `off` | `dynamic` | — | Zero-based byte or element offset. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/m_misc.ml#L41)

<a id="function-function-m-upperascii-inline-function-m-upperascii-c-src-m-misc-ml-1035694538"></a>
### _M_UpperAscii

```ml
inline function _M_UpperAscii(c)
```

Folds one lowercase ASCII byte to uppercase while leaving all other bytes unchanged.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `c` | `dynamic` | — | C value supplied to `_M_UpperAscii`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/m_misc.ml#L56)

<a id="function-function-m-writepcxfile-function-m-writepcxfile-filename-data-width-height-palette-src-m-misc-ml-1243487923"></a>
### _M_WritePCXfile

```ml
function _M_WritePCXfile(filename, data, width, height, palette)
```

Validates indexed pixels and palette, RLE-encodes a complete 8-bit PCX image, and saves it to disk.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `filename` | `dynamic` | — | Filesystem name of the target resource. |
| `data` | `dynamic` | — | Binary or structured data to process. |
| `width` | `dynamic` | — | Width of the target in pixels or map units. |
| `height` | `dynamic` | — | Height of the target in pixels or map units. |
| `palette` | `dynamic` | — | Palette value supplied to `_M_WritePCXfile`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/m_misc.ml#L101)

<a id="function-function-m-writeu16le-inline-function-m-writeu16le-buf-off-value-src-m-misc-ml-325152432"></a>
### _M_WriteU16LE

```ml
inline function _M_WriteU16LE(buf, off, value)
```

Encodes the low 16 bits of a value at a byte-buffer offset in little-endian order.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `buf` | `dynamic` | — | Buf value supplied to `_M_WriteU16LE`. |
| `off` | `dynamic` | — | Zero-based byte or element offset. |
| `value` | `dynamic` | — | Value consumed by the operation. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/m_misc.ml#L78)

<a id="function-function-mmisc-idiv-inline-function-mmisc-idiv-a-b-src-m-misc-ml-817267228"></a>
### _MMISC_IDiv

```ml
inline function _MMISC_IDiv(a, b)
```

Returns a signed quotient truncated toward zero, or zero for invalid operands and a zero divisor in `_MMISC_IDiv`

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `a` | `dynamic` | — | First input operand. |
| `b` | `dynamic` | — | Second input operand. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/m_misc.ml#L66)

- [default_t](Type-default-t-1576437285.md) — struct
<a id="global-global-defaultfile-defaultfile-src-m-misc-ml-2040813226"></a>
### defaultfile

```ml
defaultfile
```

Holds the optional defaultfile resource used by the m misc subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/m_misc.ml#L697)

<a id="global-global-defaults-defaults-src-m-misc-ml-1299402610"></a>
### defaults

```ml
defaults
```

Stores the defaults collection used by the m misc subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/m_misc.ml#L714)

<a id="function-function-m-drawtext-function-m-drawtext-x-y-direct-string-src-m-misc-ml-1205478345"></a>
### M_DrawText

```ml
function M_DrawText(x, y, direct, string)
```

Draws an uppercase patch-font string at logical screen coordinates and returns the x position after the final glyph.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `x` | `dynamic` | — | Horizontal map- or screen-space coordinate. |
| `y` | `dynamic` | — | Vertical map- or screen-space coordinate. |
| `direct` | `dynamic` | — | Direct value supplied to `M_DrawText`. |
| `string` | `dynamic` | — | String value supplied to `M_DrawText`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/m_misc.ml#L644)

<a id="function-function-m-loaddefaults-function-m-loaddefaults-src-m-misc-ml-1321362704"></a>
### M_LoadDefaults

```ml
function M_LoadDefaults()
```

Restores built-in settings, parses recognized configuration keys, applies CLI multiplayer overrides, and clamps the result.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/m_misc.ml#L544)

<a id="function-function-m-readfile-function-m-readfile-name-bufferout-src-m-misc-ml-299560807"></a>
### M_ReadFile

```ml
function M_ReadFile(name, bufferOut)
```

Loads an entire file into an output reference, returning its byte count and routing failures through I_Error.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `name` | `dynamic` | — | Resource or object name to resolve. |
| `bufferOut` | `dynamic` | — | Buffer out value supplied to `M_ReadFile`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/m_misc.ml#L474)

<a id="function-function-m-savedefaults-function-m-savedefaults-src-m-misc-ml-166341536"></a>
### M_SaveDefaults

```ml
function M_SaveDefaults()
```

Serializes current input, audio, message, and multiplayer settings to the selected configuration file.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/m_misc.ml#L598)

<a id="function-function-m-screenshot-function-m-screenshot-src-m-misc-ml-1062459216"></a>
### M_ScreenShot

```ml
function M_ScreenShot()
```

Chooses the next unused DOOMxx screenshot name and writes the current framebuffer as a PCX image.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/m_misc.ml#L498)

<a id="function-function-m-writefile-function-m-writefile-name-source-length-src-m-misc-ml-1246450968"></a>
### M_WriteFile

```ml
function M_WriteFile(name, source, length)
```

Persists exactly the requested byte prefix and returns false when validation or filesystem output fails.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `name` | `dynamic` | — | Resource or object name to resolve. |
| `source` | `dynamic` | — | Source value or buffer. |
| `length` | `dynamic` | — | Number of bytes or elements in the associated value. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/m_misc.ml#L451)

<a id="global-global-numdefaults-numdefaults-src-m-misc-ml-493744994"></a>
### numdefaults

```ml
numdefaults
```

Tracks the mutable numdefaults value used by the m misc subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/m_misc.ml#L695)

<a id="global-global-usejoystick-usejoystick-src-m-misc-ml-1596557526"></a>
### usejoystick

```ml
usejoystick
```

Tracks the mutable usejoystick value used by the m misc subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/m_misc.ml#L692)

<a id="global-global-usemouse-usemouse-src-m-misc-ml-2003138754"></a>
### usemouse

```ml
usemouse
```

Tracks the mutable usemouse value used by the m misc subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/m_misc.ml#L690)

<a id="function-function-writepcxfile-function-writepcxfile-filename-data-width-height-palette-src-m-misc-ml-1872144825"></a>
### WritePCXfile

```ml
function WritePCXfile(filename, data, width, height, palette)
```

Exposes the validated 8-bit PCX encoder through Doom's public screenshot-writing entry point.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `filename` | `dynamic` | — | Filesystem name of the target resource. |
| `data` | `dynamic` | — | Binary or structured data to process. |
| `width` | `dynamic` | — | Width of the target in pixels or map units. |
| `height` | `dynamic` | — | Height of the target in pixels or map units. |
| `palette` | `dynamic` | — | Palette value supplied to `WritePCXfile`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/m_misc.ml#L162)
