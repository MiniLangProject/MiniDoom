# `src/i_video.ml`

[Home](README.md) · [Files](Files.md)

Owns the Win32 game window, keyboard/mouse polling, indexed-frame presentation, HD overlays, wipes, and screenshots.

Package: [`(global)`](Package-global-1952375359.md)

Reachable from entry: **yes**

## Imports

- `d_main.ml` → [src/d_main.ml](File-src-d-main-ml-105344057.md)
- `doomdef.ml` → [src/doomdef.ml](File-src-doomdef-ml-460406769.md)
- `doomstat.ml` → [src/doomstat.ml](File-src-doomstat-ml-1652708088.md)
- `doomtype.ml` → [src/doomtype.ml](File-src-doomtype-ml-372549946.md)
- `i_gl.ml` → [src/i_gl.ml](File-src-i-gl-ml-2113703076.md)
- `i_system.ml` → [src/i_system.ml](File-src-i-system-ml-1632920966.md)
- `m_argv.ml` → [src/m_argv.ml](File-src-m-argv-ml-728984635.md)
- `r_hires.ml` → [src/r_hires.ml](File-src-r-hires-ml-694005807.md)
- `r_upscaled.ml` → [src/r_upscaled.ml](File-src-r-upscaled-ml-1801241933.md)
- `std/fs.ml` as `fs` → `../MiniLangCompilerOptimization/MiniLangCompilerPy/std/fs.ml` — external dependency
- `std/math.ml` → `../MiniLangCompilerOptimization/MiniLangCompilerPy/std/math.ml` — external dependency
- `std/time.ml` → `../MiniLangCompilerOptimization/MiniLangCompilerPy/std/time.ml` — external dependency
- `v_video.ml` → [src/v_video.ml](File-src-v-video-ml-592999939.md)

## Declarations

<a id="function-function-i-addkeymap-inline-function-i-addkeymap-vk-doomkey-src-i-video-ml-1072998313"></a>
### _I_AddKeyMap

```ml
inline function _I_AddKeyMap(vk, doomKey)
```

Appends a Win32 virtual-key to Doom-key mapping with an initially released edge-tracking cell.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `vk` | `dynamic` | — | Vk value supplied to `_I_AddKeyMap`. |
| `doomKey` | `dynamic` | — | Doom input-key code to process. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_video.ml#L1036)

<a id="global-global-i-altgprev-i-altgprev-src-i-video-ml-1528472801"></a>
### _i_altGPrev

```ml
_i_altGPrev
```

Tracks whether i alt gprev is active in the i video subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_video.ml#L389)

<a id="constant-constant-i-bi-rgb-const-i-bi-rgb-0-src-i-video-ml-1712756172"></a>
### _I_BI_RGB

```ml
const _I_BI_RGB = 0
```

Defines i bi rgb for the i video subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_video.ml#L41)

<a id="global-global-i-bmi-i-bmi-src-i-video-ml-590572983"></a>
### _i_bmi

```ml
_i_bmi
```

Tracks the mutable i bmi value used by the i video subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_video.ml#L368)

<a id="constant-constant-i-bmp-header-size-const-i-bmp-header-size-54-src-i-video-ml-635771271"></a>
### _I_BMP_HEADER_SIZE

```ml
const _I_BMP_HEADER_SIZE = 54
```

Defines i bmp header size for the i video subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_video.ml#L116)

<a id="function-function-i-buildbmpfromframe-function-i-buildbmpfromframe-src-i-video-ml-1823323607"></a>
### _I_BuildBmpFromFrame

```ml
function _I_BuildBmpFromFrame()
```

Encodes the currently selected presentation framebuffer as an 8-bit BMP.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_video.ml#L2012)

<a id="function-function-i-buildbmpfromindexedframe-function-i-buildbmpfromindexedframe-src-width-height-src-i-video-ml-293874954"></a>
### _I_BuildBmpFromIndexedFrame

```ml
function _I_BuildBmpFromIndexedFrame(src, width, height)
```

Builds an 8-bit BMP from a prepared indexed frame.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `src` | `dynamic` | — | Src value supplied to `_I_BuildBmpFromIndexedFrame`. |
| `width` | `dynamic` | — | Width of the target in pixels or map units. |
| `height` | `dynamic` | — | Height of the target in pixels or map units. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_video.ml#L1963)

<a id="function-function-i-buildhighresgameframe-function-i-buildhighresgameframe-src-i-video-ml-415135431"></a>
### _I_BuildHighresGameFrame

```ml
function _I_BuildHighresGameFrame()
```

Presents the native high-resolution world buffer plus scaled logical UI/overlay areas.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_video.ml#L1911)

<a id="function-function-i-buildnearestlogicalframe-function-i-buildnearestlogicalframe-src-src-i-video-ml-1641656909"></a>
### _I_BuildNearestLogicalFrame

```ml
function _I_BuildNearestLogicalFrame(src)
```

Builds a cheap nearest-scaled logical frame used as fallback behind prepared assets.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `src` | `dynamic` | — | Src value supplied to `_I_BuildNearestLogicalFrame`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_video.ml#L1896)

<a id="function-function-i-buildpresentframe-function-i-buildpresentframe-src-i-video-ml-216973927"></a>
### _I_BuildPresentFrame

```ml
function _I_BuildPresentFrame()
```

Returns the framebuffer that should be presented to the window.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_video.ml#L1946)

<a id="function-function-i-clamppresentscale-inline-function-i-clamppresentscale-scale-src-i-video-ml-583868346"></a>
### _I_ClampPresentScale

```ml
inline function _I_ClampPresentScale(scale)
```

Keeps the physical presentation scale inside the supported range.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `scale` | `dynamic` | — | Scale value supplied to `_I_ClampPresentScale`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_video.ml#L2020)

<a id="constant-constant-i-coloroncolor-const-i-coloroncolor-3-src-i-video-ml-2024317275"></a>
### _I_COLORONCOLOR

```ml
const _I_COLORONCOLOR = 3
```

Defines the Doom palette selection for i coloroncolor.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_video.ml#L50)

<a id="function-function-i-composehdwipeframe-function-i-composehdwipeframe-src-i-video-ml-1717040629"></a>
### _I_ComposeHDWipeFrame

```ml
function _I_ComposeHDWipeFrame()
```

Composes one RGBA melt frame from the start/end captures and each column group's vertical frontier.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_video.ml#L773)

<a id="global-global-i-consoletildeprev-i-consoletildeprev-src-i-video-ml-2087118005"></a>
### _i_consoleTildePrev

```ml
_i_consoleTildePrev
```

Tracks whether i console tilde prev is active in the i video subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_video.ml#L392)

<a id="function-function-i-createwindow-function-i-createwindow-src-i-video-ml-1788295197"></a>
### _I_CreateWindow

```ml
function _I_CreateWindow()
```

Creates, sizes, activates, and acquires a device context for the fullscreen or windowed native game window.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_video.ml#L1243)

<a id="global-global-i-cursorhidden-i-cursorhidden-src-i-video-ml-1841260205"></a>
### _i_cursorHidden

```ml
_i_cursorHidden
```

Tracks whether i cursor hidden is active in the i video subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_video.ml#L446)

<a id="constant-constant-i-dib-rgb-colors-const-i-dib-rgb-colors-0-src-i-video-ml-1470313804"></a>
### _I_DIB_RGB_COLORS

```ml
const _I_DIB_RGB_COLORS = 0
```

Defines the Doom palette selection for i dib rgb colors.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_video.ml#L44)

<a id="function-function-i-drawgloverlayframe-function-i-drawgloverlayframe-src-i-video-ml-1222743985"></a>
### _I_DrawGLOverlayFrame

```ml
function _I_DrawGLOverlayFrame()
```

Composes a visible status bar, marked logical UI, and prepared HD patches, then submits the masked overlay to OpenGL.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_video.ml#L1846)

<a id="function-function-i-drawloadingindicator-function-i-drawloadingindicator-src-i-video-ml-771998867"></a>
### _I_DrawLoadingIndicator

```ml
function _I_DrawLoadingIndicator()
```

Renders a small animated loading marker in the lower-right corner of the software framebuffer.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_video.ml#L953)

<a id="function-function-i-ensureglooverlay-function-i-ensureglooverlay-src-i-video-ml-2129603369"></a>
### _I_EnsureGLOOverlay

```ml
function _I_EnsureGLOOverlay()
```

Ensures the OpenGL UI overlay color and alpha-mask buffers match the physical presentation dimensions.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_video.ml#L1683)

<a id="function-function-i-ensurescreenshotdir-function-i-ensurescreenshotdir-src-i-video-ml-682815855"></a>
### _I_EnsureScreenshotDir

```ml
function _I_EnsureScreenshotDir()
```

Creates the screenshot directory once and caches success so periodic captures avoid repeated filesystem work.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_video.ml#L1346)

<a id="global-global-i-forcesoftwarepresent-i-forcesoftwarepresent-src-i-video-ml-1923089805"></a>
### _i_forceSoftwarePresent

```ml
_i_forceSoftwarePresent
```

Tracks whether i force software present is active in the i video subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_video.ml#L503)

<a id="global-global-i-fpsframecount-i-fpsframecount-src-i-video-ml-2061218637"></a>
### _i_fpsFrameCount

```ml
_i_fpsFrameCount
```

Tracks the mutable i fps frame count value used by the i video subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_video.ml#L422)

<a id="function-function-i-fpstitle-inline-function-i-fpstitle-src-i-video-ml-2017868188"></a>
### _I_FpsTitle

```ml
inline function _I_FpsTitle()
```

Formats the base window caption with the most recently measured non-negative FPS value.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_video.ml#L900)

<a id="global-global-i-fpsvalue-i-fpsvalue-src-i-video-ml-1065838057"></a>
### _i_fpsValue

```ml
_i_fpsValue
```

Tracks the mutable i fps value value used by the i video subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_video.ml#L425)

<a id="global-global-i-fpswindowstart-i-fpswindowstart-src-i-video-ml-936384213"></a>
### _i_fpsWindowStart

```ml
_i_fpsWindowStart
```

Tracks the mutable i fps window start value used by the i video subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_video.ml#L419)

<a id="global-global-i-fullscreen-i-fullscreen-src-i-video-ml-1540141777"></a>
### _i_fullscreen

```ml
_i_fullscreen
```

Tracks whether i fullscreen is active in the i video subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_video.ml#L443)

<a id="global-global-i-gloverlaybuffer-i-gloverlaybuffer-src-i-video-ml-916043265"></a>
### _i_glOverlayBuffer

```ml
_i_glOverlayBuffer
```

Holds the optional i gl overlay buffer resource used by the i video subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_video.ml#L473)

<a id="function-function-i-gloverlayhighrespatches-function-i-gloverlayhighrespatches-src-i-video-ml-1547344655"></a>
### _I_GLOverlayHighresPatches

```ml
function _I_GLOverlayHighresPatches()
```

Merges prepared native-resolution patch pixels and their mask into the OpenGL overlay buffers.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_video.ml#L1796)

<a id="function-function-i-gloverlaylogicalmask-function-i-gloverlaylogicalmask-src-mask-src-i-video-ml-363202421"></a>
### _I_GLOverlayLogicalMask

```ml
function _I_GLOverlayLogicalMask(src, mask)
```

Expands only mask-selected logical indexed pixels into the OpenGL overlay buffers.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `src` | `dynamic` | — | Src value supplied to `_I_GLOverlayLogicalMask`. |
| `mask` | `dynamic` | — | Mask value supplied to `_I_GLOverlayLogicalMask`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_video.ml#L1762)

<a id="function-function-i-gloverlaylogicalpixel-function-i-gloverlaylogicalpixel-src-sx-sy-src-i-video-ml-1033436836"></a>
### _I_GLOverlayLogicalPixel

```ml
function _I_GLOverlayLogicalPixel(src, sx, sy)
```

Expands one logical indexed pixel into its physical-scale overlay block and marks those destination pixels opaque.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `src` | `dynamic` | — | Src value supplied to `_I_GLOverlayLogicalPixel`. |
| `sx` | `dynamic` | — | Horizontal coordinate or vector component represented by sx. |
| `sy` | `dynamic` | — | Vertical coordinate or vector component represented by sy. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_video.ml#L1706)

<a id="function-function-i-gloverlaylogicalrect-function-i-gloverlaylogicalrect-src-x-y-w-h-src-i-video-ml-2080504189"></a>
### _I_GLOverlayLogicalRect

```ml
function _I_GLOverlayLogicalRect(src, x, y, w, h)
```

Clips and expands a logical indexed rectangle into the OpenGL overlay buffers.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `src` | `dynamic` | — | Src value supplied to `_I_GLOverlayLogicalRect`. |
| `x` | `dynamic` | — | Horizontal map- or screen-space coordinate. |
| `y` | `dynamic` | — | Vertical map- or screen-space coordinate. |
| `w` | `dynamic` | — | W value supplied to `_I_GLOverlayLogicalRect`. |
| `h` | `dynamic` | — | H value supplied to `_I_GLOverlayLogicalRect`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_video.ml#L1732)

<a id="global-global-i-gloverlaymask-i-gloverlaymask-src-i-video-ml-1663236877"></a>
### _i_glOverlayMask

```ml
_i_glOverlayMask
```

Holds the optional i gl overlay mask resource used by the i video subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_video.ml#L476)

<a id="constant-constant-i-gwl-style-const-i-gwl-style-16-src-i-video-ml-52871680"></a>
### _I_GWL_STYLE

```ml
const _I_GWL_STYLE = -16
```

Defines i gwl style for the i video subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_video.ml#L134)

<a id="function-function-i-handlerendererhotkeymessage-function-i-handlerendererhotkeymessage-msg-wparam-lparam-src-i-video-ml-1830323407"></a>
### _I_HandleRendererHotkeyMessage

```ml
function _I_HandleRendererHotkeyMessage(msg, wparam, lparam)
```

Handles Alt+G from the Win32 message stream, independent of foreground polling.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `msg` | `dynamic` | — | Msg value supplied to `_I_HandleRendererHotkeyMessage`. |
| `wparam` | `dynamic` | — | Wparam value supplied to `_I_HandleRendererHotkeyMessage`. |
| `lparam` | `dynamic` | — | Lparam value supplied to `_I_HandleRendererHotkeyMessage`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_video.ml#L584)

<a id="global-global-i-hdc-i-hdc-src-i-video-ml-78328413"></a>
### _i_hdc

```ml
_i_hdc
```

Holds the optional i hdc resource used by the i video subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_video.ml#L359)

<a id="function-function-i-hdwipe-rand-inline-function-i-hdwipe-rand-src-i-video-ml-2010857498"></a>
### _I_HDWIPE_Rand

```ml
inline function _I_HDWIPE_Rand()
```

Produces deterministic 15-bit randomness for high-resolution melt-column delays.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_video.ml#L675)

<a id="global-global-i-hdwipeactive-i-hdwipeactive-src-i-video-ml-1162941081"></a>
### _i_hdWipeActive

```ml
_i_hdWipeActive
```

Tracks whether i hd wipe active is active in the i video subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_video.ml#L497)

<a id="global-global-i-hdwipeend-i-hdwipeend-src-i-video-ml-303254535"></a>
### _i_hdWipeEnd

```ml
_i_hdWipeEnd
```

Holds the optional i hd wipe end resource used by the i video subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_video.ml#L488)

<a id="global-global-i-hdwipeframe-i-hdwipeframe-src-i-video-ml-2000422507"></a>
### _i_hdWipeFrame

```ml
_i_hdWipeFrame
```

Holds the optional i hd wipe frame resource used by the i video subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_video.ml#L491)

<a id="global-global-i-hdwipeseed-i-hdwipeseed-src-i-video-ml-1265700321"></a>
### _i_hdWipeSeed

```ml
_i_hdWipeSeed
```

Tracks the mutable i hd wipe seed value used by the i video subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_video.ml#L500)

<a id="global-global-i-hdwipestart-i-hdwipestart-src-i-video-ml-757438213"></a>
### _i_hdWipeStart

```ml
_i_hdWipeStart
```

Holds the optional i hd wipe start resource used by the i video subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_video.ml#L485)

<a id="global-global-i-hdwipey-i-hdwipey-src-i-video-ml-774778043"></a>
### _i_hdWipeY

```ml
_i_hdWipeY
```

Stores the i hd wipe y collection used by the i video subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_video.ml#L494)

<a id="global-global-i-hwnd-i-hwnd-src-i-video-ml-1569039437"></a>
### _i_hwnd

```ml
_i_hwnd
```

Holds the optional i hwnd resource used by the i video subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_video.ml#L356)

<a id="function-function-i-idiv-inline-function-i-idiv-a-b-src-i-video-ml-1144211123"></a>
### _I_IDiv

```ml
inline function _I_IDiv(a, b)
```

Coerces numeric operands and returns their signed quotient truncated toward zero, using zero for a zero divisor.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `a` | `dynamic` | — | First input operand. |
| `b` | `dynamic` | — | Second input operand. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_video.ml#L532)

<a id="function-function-i-indexedtorgba-function-i-indexedtorgba-src-dst-width-height-src-i-video-ml-1411806957"></a>
### _I_IndexedToRGBA

```ml
function _I_IndexedToRGBA(src, dst, width, height)
```

Expands validated indexed pixels through the active RGB palette into opaque RGBA output.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `src` | `dynamic` | — | Src value supplied to `_I_IndexedToRGBA`. |
| `dst` | `dynamic` | — | Dst value supplied to `_I_IndexedToRGBA`. |
| `width` | `dynamic` | — | Width of the target in pixels or map units. |
| `height` | `dynamic` | — | Height of the target in pixels or map units. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_video.ml#L649)

<a id="function-function-i-initbitmapinfo-function-i-initbitmapinfo-src-i-video-ml-156193295"></a>
### _I_InitBitmapInfo

```ml
function _I_InitBitmapInfo()
```

Builds a top-down 8-bit BITMAPINFO for the physical presentation size and forwards its initial palette to OpenGL.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_video.ml#L1222)

<a id="function-function-i-initdefaultpalette-function-i-initdefaultpalette-src-i-video-ml-923549957"></a>
### _I_InitDefaultPalette

```ml
function _I_InitDefaultPalette()
```

Seeds the 256-entry RGB palette with a grayscale ramp before PLAYPAL is applied.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_video.ml#L1194)

<a id="global-global-i-inited-i-inited-src-i-video-ml-1698553781"></a>
### _i_inited

```ml
_i_inited
```

Tracks whether i inited is active in the i video subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_video.ml#L353)

<a id="function-function-i-initkeymap-function-i-initkeymap-src-i-video-ml-289741735"></a>
### _I_InitKeyMap

```ml
function _I_InitKeyMap()
```

Lazily builds the complete navigation, function, digit, numpad, punctuation, and lowercase-letter key map.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_video.ml#L1048)

<a id="function-function-i-initpresentmetrics-function-i-initpresentmetrics-src-i-video-ml-1806358673"></a>
### _I_InitPresentMetrics

```ml
function _I_InitPresentMetrics()
```

Initializes physical framebuffer dimensions used by GDI presentation.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_video.ml#L2029)

<a id="function-function-i-inttostring-function-i-inttostring-v-src-i-video-ml-2045155491"></a>
### _I_IntToString

```ml
function _I_IntToString(v)
```

Formats an integer as decimal text without relying on platform string conversion.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `v` | `dynamic` | — | Value consumed by the operation. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_video.ml#L869)

<a id="global-global-i-keydoom-i-keydoom-src-i-video-ml-1197351103"></a>
### _i_keyDoom

```ml
_i_keyDoom
```

Stores the i key doom collection used by the i video subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_video.ml#L383)

<a id="global-global-i-keyprev-i-keyprev-src-i-video-ml-437587803"></a>
### _i_keyPrev

```ml
_i_keyPrev
```

Stores the i key prev collection used by the i video subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_video.ml#L386)

<a id="global-global-i-keyvk-i-keyvk-src-i-video-ml-209014275"></a>
### _i_keyVk

```ml
_i_keyVk
```

Stores the i key vk collection used by the i video subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_video.ml#L380)

<a id="global-global-i-lastpresentframe-i-lastpresentframe-src-i-video-ml-733672605"></a>
### _i_lastPresentFrame

```ml
_i_lastPresentFrame
```

Holds the optional i last present frame resource used by the i video subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_video.ml#L479)

<a id="global-global-i-lastpresentrgba-i-lastpresentrgba-src-i-video-ml-1115530701"></a>
### _i_lastPresentRGBA

```ml
_i_lastPresentRGBA
```

Holds the optional i last present rgba resource used by the i video subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_video.ml#L482)

<a id="global-global-i-loadinganimphase-i-loadinganimphase-src-i-video-ml-520048373"></a>
### _i_loadingAnimPhase

```ml
_i_loadingAnimPhase
```

Tracks the mutable i loading anim phase value used by the i video subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_video.ml#L452)

<a id="global-global-i-loadingstatustext-i-loadingstatustext-src-i-video-ml-905903013"></a>
### _i_loadingStatusText

```ml
_i_loadingStatusText
```

Stores the mutable i loading status text text used by the i video subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_video.ml#L449)

<a id="function-function-i-maybeautoscreenshot-function-i-maybeautoscreenshot-src-i-video-ml-895218267"></a>
### _I_MaybeAutoScreenshot

```ml
function _I_MaybeAutoScreenshot()
```

Writes the current presentation frame only when the one-second automatic capture deadline has elapsed.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_video.ml#L2110)

<a id="function-function-i-maybeautoscreenshotfromframe-function-i-maybeautoscreenshotfromframe-src-width-height-src-i-video-ml-1933191236"></a>
### _I_MaybeAutoScreenshotFromFrame

```ml
function _I_MaybeAutoScreenshotFromFrame(src, width, height)
```

Writes a prepared frame when the auto screenshot interval has elapsed.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `src` | `dynamic` | — | Src value supplied to `_I_MaybeAutoScreenshotFromFrame`. |
| `width` | `dynamic` | — | Width of the target in pixels or map units. |
| `height` | `dynamic` | — | Height of the target in pixels or map units. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_video.ml#L2119)

<a id="function-function-i-mousebuttonsnow-inline-function-i-mousebuttonsnow-src-i-video-ml-1016051664"></a>
### _I_MouseButtonsNow

```ml
inline function _I_MouseButtonsNow()
```

Packs the current left, right, and middle Win32 button states into Doom's three-bit mouse mask.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_video.ml#L2232)

<a id="global-global-i-mouseinited-i-mouseinited-src-i-video-ml-258385559"></a>
### _i_mouseInited

```ml
_i_mouseInited
```

Tracks whether i mouse inited is active in the i video subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_video.ml#L431)

<a id="global-global-i-mousepoint-i-mousepoint-src-i-video-ml-1839561949"></a>
### _i_mousePoint

```ml
_i_mousePoint
```

Tracks the mutable i mouse point value used by the i video subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_video.ml#L428)

<a id="global-global-i-mouseprevbuttons-i-mouseprevbuttons-src-i-video-ml-1421318461"></a>
### _i_mousePrevButtons

```ml
_i_mousePrevButtons
```

Tracks the mutable i mouse prev buttons value used by the i video subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_video.ml#L440)

<a id="global-global-i-mouseprevx-i-mouseprevx-src-i-video-ml-1953772073"></a>
### _i_mousePrevX

```ml
_i_mousePrevX
```

Tracks the mutable i mouse prev x value used by the i video subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_video.ml#L434)

<a id="global-global-i-mouseprevy-i-mouseprevy-src-i-video-ml-1527727237"></a>
### _i_mousePrevY

```ml
_i_mousePrevY
```

Tracks the mutable i mouse prev y value used by the i video subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_video.ml#L437)

<a id="global-global-i-msg-i-msg-src-i-video-ml-1687162813"></a>
### _i_msg

```ml
_i_msg
```

Tracks the mutable i msg value used by the i video subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_video.ml#L371)

<a id="global-global-i-overlaybase-i-overlaybase-src-i-video-ml-864974173"></a>
### _i_overlayBase

```ml
_i_overlayBase
```

Holds the optional i overlay base resource used by the i video subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_video.ml#L467)

<a id="function-function-i-overlaychangedlogicalpixels-function-i-overlaychangedlogicalpixels-scaled-cur-base-src-i-video-ml-271621440"></a>
### _I_OverlayChangedLogicalPixels

```ml
function _I_OverlayChangedLogicalPixels(scaled, cur, base)
```

Copies only logical pixels changed after the world pass, preserving high-res world rendering.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `scaled` | `dynamic` | — | Scaled value supplied to `_I_OverlayChangedLogicalPixels`. |
| `cur` | `dynamic` | — | Cur value supplied to `_I_OverlayChangedLogicalPixels`. |
| `base` | `dynamic` | — | Base value supplied to `_I_OverlayChangedLogicalPixels`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_video.ml#L1484)

<a id="function-function-i-overlaychangedlogicalpixelsnearest-function-i-overlaychangedlogicalpixelsnearest-cur-base-src-i-video-ml-1506352428"></a>
### _I_OverlayChangedLogicalPixelsNearest

```ml
function _I_OverlayChangedLogicalPixelsNearest(cur, base)
```

Copies changed logical pixels directly into the high-resolution frame.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `cur` | `dynamic` | — | Cur value supplied to `_I_OverlayChangedLogicalPixelsNearest`. |
| `base` | `dynamic` | — | Base value supplied to `_I_OverlayChangedLogicalPixelsNearest`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_video.ml#L1517)

<a id="function-function-i-overlaylogicalrectnearest-function-i-overlaylogicalrectnearest-src-x-y-w-h-src-i-video-ml-929297707"></a>
### _I_OverlayLogicalRectNearest

```ml
function _I_OverlayLogicalRectNearest(src, x, y, w, h)
```

Copies a logical-screen rectangle into the high-resolution frame with cheap nearest scaling.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `src` | `dynamic` | — | Src value supplied to `_I_OverlayLogicalRectNearest`. |
| `x` | `dynamic` | — | Horizontal map- or screen-space coordinate. |
| `y` | `dynamic` | — | Vertical map- or screen-space coordinate. |
| `w` | `dynamic` | — | W value supplied to `_I_OverlayLogicalRectNearest`. |
| `h` | `dynamic` | — | H value supplied to `_I_OverlayLogicalRectNearest`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_video.ml#L1410)

<a id="function-function-i-overlaymarkedlogicalpixels-function-i-overlaymarkedlogicalpixels-scaled-mask-src-i-video-ml-299470083"></a>
### _I_OverlayMarkedLogicalPixels

```ml
function _I_OverlayMarkedLogicalPixels(scaled, mask)
```

Copies logical pixels marked by V_DrawPatch/V_DrawBlock into the high-resolution frame.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `scaled` | `dynamic` | — | Scaled value supplied to `_I_OverlayMarkedLogicalPixels`. |
| `mask` | `dynamic` | — | Mask value supplied to `_I_OverlayMarkedLogicalPixels`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_video.ml#L1554)

<a id="function-function-i-overlaymarkedlogicalpixelsnearest-function-i-overlaymarkedlogicalpixelsnearest-src-mask-src-i-video-ml-507402271"></a>
### _I_OverlayMarkedLogicalPixelsNearest

```ml
function _I_OverlayMarkedLogicalPixelsNearest(src, mask)
```

Copies UI-marked logical pixels directly into the high-resolution frame.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `src` | `dynamic` | — | Src value supplied to `_I_OverlayMarkedLogicalPixelsNearest`. |
| `mask` | `dynamic` | — | Mask value supplied to `_I_OverlayMarkedLogicalPixelsNearest`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_video.ml#L1589)

<a id="function-function-i-overlaypreparedhighrespatches-function-i-overlaypreparedhighrespatches-src-i-video-ml-1574348935"></a>
### _I_OverlayPreparedHighresPatches

```ml
function _I_OverlayPreparedHighresPatches()
```

Copies pre-upscaled patch pixels prepared by V_DrawPatch into the presentation frame.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_video.ml#L1645)

<a id="global-global-i-overlayrowbuffer-i-overlayrowbuffer-src-i-video-ml-40518001"></a>
### _i_overlayRowBuffer

```ml
_i_overlayRowBuffer
```

Holds the optional i overlay row buffer resource used by the i video subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_video.ml#L470)

<a id="function-function-i-overlayscaledrect-function-i-overlayscaledrect-scaled-x-y-w-h-src-i-video-ml-77246257"></a>
### _I_OverlayScaledRect

```ml
function _I_OverlayScaledRect(scaled, x, y, w, h)
```

Copies a scaled logical-screen rectangle into the high-resolution frame.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `scaled` | `dynamic` | — | Scaled value supplied to `_I_OverlayScaledRect`. |
| `x` | `dynamic` | — | Horizontal map- or screen-space coordinate. |
| `y` | `dynamic` | — | Vertical map- or screen-space coordinate. |
| `w` | `dynamic` | — | W value supplied to `_I_OverlayScaledRect`. |
| `h` | `dynamic` | — | H value supplied to `_I_OverlayScaledRect`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_video.ml#L1372)

<a id="global-global-i-ownswindow-i-ownswindow-src-i-video-ml-399292861"></a>
### _i_ownsWindow

```ml
_i_ownsWindow
```

Tracks whether i owns window is active in the i video subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_video.ml#L362)

<a id="global-global-i-palettergb-i-palettergb-src-i-video-ml-988151453"></a>
### _i_paletteRgb

```ml
_i_paletteRgb
```

Tracks the mutable i palette rgb value used by the i video subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_video.ml#L365)

<a id="constant-constant-i-pm-remove-const-i-pm-remove-1-src-i-video-ml-1452098153"></a>
### _I_PM_REMOVE

```ml
const _I_PM_REMOVE = 1
```

Defines i pm remove for the i video subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_video.ml#L62)

<a id="function-function-i-pollkeyboard-function-i-pollkeyboard-src-i-video-ml-1860744661"></a>
### _I_PollKeyboard

```ml
function _I_PollKeyboard()
```

Polls mapped virtual keys while focused, posts edge-triggered Doom events, and handles the Alt+G renderer toggle.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_video.ml#L2154)

<a id="function-function-i-pollmouse-function-i-pollmouse-src-i-video-ml-1112899695"></a>
### _I_PollMouse

```ml
function _I_PollMouse()
```

Converts focused cursor deltas and button changes into Doom mouse events while synchronizing cursor visibility.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_video.ml#L2243)

<a id="global-global-i-presentbuffer-i-presentbuffer-src-i-video-ml-1918187981"></a>
### _i_presentBuffer

```ml
_i_presentBuffer
```

Holds the optional i present buffer resource used by the i video subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_video.ml#L464)

<a id="global-global-i-presentheight-i-presentheight-src-i-video-ml-1390562367"></a>
### _i_presentHeight

```ml
_i_presentHeight
```

Tracks the mutable i present height value used by the i video subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_video.ml#L461)

<a id="function-function-i-presentindexedframegl-function-i-presentindexedframegl-src-src-i-video-ml-277668719"></a>
### _I_PresentIndexedFrameGL

```ml
function _I_PresentIndexedFrameGL(src)
```

Presents an indexed frame whose dimensions match the physical presentation buffer.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `src` | `dynamic` | — | Src value supplied to `_I_PresentIndexedFrameGL`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_video.ml#L2506)

<a id="function-function-i-presentindexedframeglsized-function-i-presentindexedframeglsized-src-srcw-srch-src-i-video-ml-1127998178"></a>
### _I_PresentIndexedFrameGLSized

```ml
function _I_PresentIndexedFrameGLSized(src, srcW, srcH)
```

Palette-expands an arbitrary indexed frame, resizes the GL viewport, submits it as RGBA, and swaps buffers.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `src` | `dynamic` | — | Src value supplied to `_I_PresentIndexedFrameGLSized`. |
| `srcW` | `dynamic` | — | Src w value supplied to `_I_PresentIndexedFrameGLSized`. |
| `srcH` | `dynamic` | — | Src h value supplied to `_I_PresentIndexedFrameGLSized`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_video.ml#L2481)

<a id="global-global-i-presentscale-i-presentscale-src-i-video-ml-318105421"></a>
### _i_presentScale

```ml
_i_presentScale
```

Tracks the mutable i present scale value used by the i video subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_video.ml#L455)

<a id="global-global-i-presentwidth-i-presentwidth-src-i-video-ml-1171254413"></a>
### _i_presentWidth

```ml
_i_presentWidth
```

Tracks the mutable i present width value used by the i video subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_video.ml#L458)

<a id="function-function-i-pumpmessages-function-i-pumpmessages-src-i-video-ml-872914261"></a>
### _I_PumpMessages

```ml
function _I_PumpMessages()
```

Drains queued Win32 messages, handles Alt+G directly, and quits if the stored game window was destroyed.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_video.ml#L1314)

<a id="function-function-i-reads32-inline-function-i-reads32-buf-off-src-i-video-ml-782921126"></a>
### _I_ReadS32

```ml
inline function _I_ReadS32(buf, off)
```

Decodes a signed 32-bit little-endian field from a Win32 structure buffer.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `buf` | `dynamic` | — | Buf value supplied to `_I_ReadS32`. |
| `off` | `dynamic` | — | Zero-based byte or element offset. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_video.ml#L1186)

<a id="function-function-i-readu32-inline-function-i-readu32-buf-off-src-i-video-ml-1302537186"></a>
### _I_ReadU32

```ml
inline function _I_ReadU32(buf, off)
```

Decodes an unsigned 32-bit little-endian field from a Win32 structure buffer.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `buf` | `dynamic` | — | Buf value supplied to `_I_ReadU32`. |
| `off` | `dynamic` | — | Zero-based byte or element offset. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_video.ml#L1178)

<a id="global-global-i-rect-i-rect-src-i-video-ml-193095497"></a>
### _i_rect

```ml
_i_rect
```

Tracks the mutable i rect value used by the i video subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_video.ml#L374)

<a id="function-function-i-releasekeyboard-function-i-releasekeyboard-postevents-src-i-video-ml-79065016"></a>
### _I_ReleaseKeyboard

```ml
function _I_ReleaseKeyboard(postEvents)
```

Clears all remembered key-down edges and optionally posts matching Doom key-up events on focus loss.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `postEvents` | `dynamic` | — | Post events value supplied to `_I_ReleaseKeyboard`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_video.ml#L2126)

<a id="function-function-i-savelastpresentframe-function-i-savelastpresentframe-src-src-i-video-ml-2042906851"></a>
### _I_SaveLastPresentFrame

```ml
function _I_SaveLastPresentFrame(src)
```

Caches the latest full-size indexed frame and its palette-expanded RGBA copy for capture and wipe fallback.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `src` | `dynamic` | — | Src value supplied to `_I_SaveLastPresentFrame`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_video.ml#L609)

<a id="function-function-i-savelastrgbaframesized-function-i-savelastrgbaframesized-src-width-height-src-i-video-ml-359675466"></a>
### _I_SaveLastRGBAFrameSized

```ml
function _I_SaveLastRGBAFrameSized(src, width, height)
```

Converts an indexed frame of arbitrary dimensions for OpenGL presentation.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `src` | `dynamic` | — | Src value supplied to `_I_SaveLastRGBAFrameSized`. |
| `width` | `dynamic` | — | Width of the target in pixels or map units. |
| `height` | `dynamic` | — | Height of the target in pixels or map units. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_video.ml#L630)

<a id="constant-constant-i-screenshot-interval-ms-const-i-screenshot-interval-ms-1000-src-i-video-ml-310308989"></a>
### _I_SCREENSHOT_INTERVAL_MS

```ml
const _I_SCREENSHOT_INTERVAL_MS = 1000
```

Defines i screenshot interval ms for the i video subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_video.ml#L119)

<a id="global-global-i-screenshotdir-i-screenshotdir-src-i-video-ml-1407893349"></a>
### _i_screenshotDir

```ml
_i_screenshotDir
```

Stores the mutable i screenshot dir text used by the i video subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_video.ml#L398)

<a id="global-global-i-screenshotdirready-i-screenshotdirready-src-i-video-ml-701246013"></a>
### _i_screenshotDirReady

```ml
_i_screenshotDirReady
```

Tracks whether i screenshot dir ready is active in the i video subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_video.ml#L401)

<a id="global-global-i-screenshotenabled-i-screenshotenabled-src-i-video-ml-33454365"></a>
### _i_screenshotEnabled

```ml
_i_screenshotEnabled
```

Tracks whether i screenshot enabled is active in the i video subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_video.ml#L395)

<a id="global-global-i-screenshotindex-i-screenshotindex-src-i-video-ml-2008197131"></a>
### _i_screenshotIndex

```ml
_i_screenshotIndex
```

Tracks the mutable i screenshot index value used by the i video subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_video.ml#L407)

<a id="global-global-i-screenshotnexttick-i-screenshotnexttick-src-i-video-ml-1615894281"></a>
### _i_screenshotNextTick

```ml
_i_screenshotNextTick
```

Tracks the mutable i screenshot next tick value used by the i video subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_video.ml#L404)

<a id="global-global-i-screenshotwriteerror-i-screenshotwriteerror-src-i-video-ml-1980696013"></a>
### _i_screenshotWriteError

```ml
_i_screenshotWriteError
```

Tracks whether i screenshot write error is active in the i video subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_video.ml#L410)

<a id="function-function-i-setcursorvisible-function-i-setcursorvisible-visible-src-i-video-ml-977480897"></a>
### _I_SetCursorVisible

```ml
function _I_SetCursorVisible(visible)
```

Keeps cursor visibility in sync while game window is active.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `visible` | `dynamic` | — | Visible value supplied to `_I_SetCursorVisible`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_video.ml#L1000)

<a id="function-function-i-setwindowtitle-inline-function-i-setwindowtitle-title-src-i-video-ml-1520351526"></a>
### _I_SetWindowTitle

```ml
inline function _I_SetWindowTitle(title)
```

Applies a changed caption once and clears STATIC-class repaint requests caused by title updates.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `title` | `dynamic` | — | Title value supplied to `_I_SetWindowTitle`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_video.ml#L544)

<a id="function-function-i-shouldautoscreenshot-function-i-shouldautoscreenshot-src-i-video-ml-1895743425"></a>
### _I_ShouldAutoScreenshot

```ml
function _I_ShouldAutoScreenshot()
```

Returns true when the next auto screenshot interval has elapsed.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_video.ml#L2087)

<a id="constant-constant-i-sm-cxscreen-const-i-sm-cxscreen-0-src-i-video-ml-1709770268"></a>
### _I_SM_CXSCREEN

```ml
const _I_SM_CXSCREEN = 0
```

Defines i sm cxscreen for the i video subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_video.ml#L122)

<a id="constant-constant-i-sm-cyscreen-const-i-sm-cyscreen-1-src-i-video-ml-678828775"></a>
### _I_SM_CYSCREEN

```ml
const _I_SM_CYSCREEN = 1
```

Defines i sm cyscreen for the i video subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_video.ml#L125)

<a id="constant-constant-i-srccopy-const-i-srccopy-13369376-src-i-video-ml-1448697736"></a>
### _I_SRCCOPY

```ml
const _I_SRCCOPY = 13369376
```

Defines i srccopy for the i video subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_video.ml#L47)

<a id="constant-constant-i-ss-ownerdraw-const-i-ss-ownerdraw-13-src-i-video-ml-1809375362"></a>
### _I_SS_OWNERDRAW

```ml
const _I_SS_OWNERDRAW = 13
```

Defines i ss ownerdraw for the i video subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_video.ml#L104)

<a id="constant-constant-i-statusbar-height-const-i-statusbar-height-32-src-i-video-ml-1461254597"></a>
### _I_STATUSBAR_HEIGHT

```ml
const _I_STATUSBAR_HEIGHT = 32
```

Defines i statusbar height for the i video subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_video.ml#L506)

<a id="function-function-i-statusoverlayy-inline-function-i-statusoverlayy-src-i-video-ml-1727106364"></a>
### _I_StatusOverlayY

```ml
inline function _I_StatusOverlayY()
```

Returns the logical start row of a visible status bar, or screen height when fullscreen rendering must remain unobscured.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_video.ml#L1834)

<a id="constant-constant-i-sw-maximize-const-i-sw-maximize-3-src-i-video-ml-498521093"></a>
### _I_SW_MAXIMIZE

```ml
const _I_SW_MAXIMIZE = 3
```

Defines the maximum i sw maximize accepted by the i video subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_video.ml#L110)

<a id="constant-constant-i-sw-show-const-i-sw-show-5-src-i-video-ml-495712801"></a>
### _I_SW_SHOW

```ml
const _I_SW_SHOW = 5
```

Defines i sw show for the i video subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_video.ml#L107)

<a id="constant-constant-i-swp-framechanged-const-i-swp-framechanged-32-src-i-video-ml-25121049"></a>
### _I_SWP_FRAMECHANGED

```ml
const _I_SWP_FRAMECHANGED = 32
```

Defines i swp framechanged for the i video subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_video.ml#L128)

<a id="constant-constant-i-swp-showwindow-const-i-swp-showwindow-64-src-i-video-ml-781170980"></a>
### _I_SWP_SHOWWINDOW

```ml
const _I_SWP_SHOWWINDOW = 64
```

Defines i swp showwindow for the i video subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_video.ml#L131)

<a id="global-global-i-titlebase-i-titlebase-src-i-video-ml-856136697"></a>
### _i_titleBase

```ml
_i_titleBase
```

Stores the mutable i title base text used by the i video subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_video.ml#L413)

<a id="global-global-i-titlelast-i-titlelast-src-i-video-ml-965423687"></a>
### _i_titleLast

```ml
_i_titleLast
```

Stores the mutable i title last text used by the i video subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_video.ml#L416)

<a id="function-function-i-togglerendererhotkey-function-i-togglerendererhotkey-src-i-video-ml-637168247"></a>
### _I_ToggleRendererHotkey

```ml
function _I_ToggleRendererHotkey()
```

Switches renderer state and invalidates cached high-resolution overlays.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_video.ml#L567)

<a id="function-function-i-tointor-function-i-tointor-v-fallback-src-i-video-ml-640711141"></a>
### _I_ToIntOr

```ml
function _I_ToIntOr(v, fallback)
```

Coerces numeric values to truncation-toward-zero integers and returns fallback on failure in `_I_ToIntOr`

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `v` | `dynamic` | — | Value consumed by the operation. |
| `fallback` | `dynamic` | — | Value returned when the requested conversion or lookup is unavailable. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_video.ml#L512)

<a id="function-function-i-updatebitmapcolortable-function-i-updatebitmapcolortable-src-i-video-ml-1211744935"></a>
### _I_UpdateBitmapColorTable

```ml
function _I_UpdateBitmapColorTable()
```

Converts the active RGB palette into the BGR0 color table embedded in the 8-bit BITMAPINFO.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_video.ml#L1206)

<a id="function-function-i-updatewindowtitle-function-i-updatewindowtitle-src-i-video-ml-1047198775"></a>
### _I_UpdateWindowTitle

```ml
function _I_UpdateWindowTitle()
```

Counts presented frames over one-second windows and updates the caption unless a loading status owns it.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_video.ml#L913)

<a id="constant-constant-i-vk-lbutton-const-i-vk-lbutton-1-src-i-video-ml-761357209"></a>
### _I_VK_LBUTTON

```ml
const _I_VK_LBUTTON = 1
```

Defines i vk lbutton for the i video subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_video.ml#L53)

<a id="constant-constant-i-vk-mbutton-const-i-vk-mbutton-4-src-i-video-ml-448175848"></a>
### _I_VK_MBUTTON

```ml
const _I_VK_MBUTTON = 4
```

Defines i vk mbutton for the i video subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_video.ml#L59)

<a id="constant-constant-i-vk-rbutton-const-i-vk-rbutton-2-src-i-video-ml-1768532610"></a>
### _I_VK_RBUTTON

```ml
const _I_VK_RBUTTON = 2
```

Defines i vk rbutton for the i video subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_video.ml#L56)

<a id="constant-constant-i-window-scale-const-i-window-scale-2-src-i-video-ml-1369027246"></a>
### _I_WINDOW_SCALE

```ml
const _I_WINDOW_SCALE = 2
```

Defines i window scale for the i video subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_video.ml#L113)

<a id="global-global-i-windowfailed-i-windowfailed-src-i-video-ml-1858441297"></a>
### _i_windowFailed

```ml
_i_windowFailed
```

Tracks whether i window failed is active in the i video subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_video.ml#L377)

<a id="constant-constant-i-wm-close-const-i-wm-close-16-src-i-video-ml-819895171"></a>
### _I_WM_CLOSE

```ml
const _I_WM_CLOSE = 16
```

Defines i wm close for the i video subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_video.ml#L68)

<a id="constant-constant-i-wm-destroy-const-i-wm-destroy-2-src-i-video-ml-539810638"></a>
### _I_WM_DESTROY

```ml
const _I_WM_DESTROY = 2
```

Defines i wm destroy for the i video subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_video.ml#L71)

<a id="constant-constant-i-wm-erasebkgnd-const-i-wm-erasebkgnd-20-src-i-video-ml-1224395458"></a>
### _I_WM_ERASEBKGND

```ml
const _I_WM_ERASEBKGND = 20
```

Defines i wm erasebkgnd for the i video subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_video.ml#L80)

<a id="constant-constant-i-wm-keydown-const-i-wm-keydown-256-src-i-video-ml-26179031"></a>
### _I_WM_KEYDOWN

```ml
const _I_WM_KEYDOWN = 256
```

Defines i wm keydown for the i video subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_video.ml#L83)

<a id="constant-constant-i-wm-keyup-const-i-wm-keyup-257-src-i-video-ml-1405591838"></a>
### _I_WM_KEYUP

```ml
const _I_WM_KEYUP = 257
```

Defines i wm keyup for the i video subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_video.ml#L86)

<a id="constant-constant-i-wm-ncdestroy-const-i-wm-ncdestroy-130-src-i-video-ml-742863848"></a>
### _I_WM_NCDESTROY

```ml
const _I_WM_NCDESTROY = 130
```

Defines i wm ncdestroy for the i video subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_video.ml#L74)

<a id="constant-constant-i-wm-paint-const-i-wm-paint-15-src-i-video-ml-983372852"></a>
### _I_WM_PAINT

```ml
const _I_WM_PAINT = 15
```

Defines i wm paint for the i video subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_video.ml#L77)

<a id="constant-constant-i-wm-quit-const-i-wm-quit-18-src-i-video-ml-525796929"></a>
### _I_WM_QUIT

```ml
const _I_WM_QUIT = 18
```

Defines i wm quit for the i video subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_video.ml#L65)

<a id="constant-constant-i-wm-syskeydown-const-i-wm-syskeydown-260-src-i-video-ml-1313442810"></a>
### _I_WM_SYSKEYDOWN

```ml
const _I_WM_SYSKEYDOWN = 260
```

Defines i wm syskeydown for the i video subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_video.ml#L89)

<a id="constant-constant-i-wm-syskeyup-const-i-wm-syskeyup-261-src-i-video-ml-2117850421"></a>
### _I_WM_SYSKEYUP

```ml
const _I_WM_SYSKEYUP = 261
```

Defines i wm syskeyup for the i video subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_video.ml#L92)

<a id="function-function-i-writeautoscreenshot-function-i-writeautoscreenshot-src-i-video-ml-1265666455"></a>
### _I_WriteAutoScreenshot

```ml
function _I_WriteAutoScreenshot()
```

Captures the current presentation selection and delegates indexed BMP creation and numbered file output.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_video.ml#L2057)

<a id="function-function-i-writeautoscreenshotfromframe-function-i-writeautoscreenshotfromframe-src-width-height-src-i-video-ml-1676714690"></a>
### _I_WriteAutoScreenshotFromFrame

```ml
function _I_WriteAutoScreenshotFromFrame(src, width, height)
```

Writes an auto screenshot from a prepared indexed frame.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `src` | `dynamic` | — | Src value supplied to `_I_WriteAutoScreenshotFromFrame`. |
| `width` | `dynamic` | — | Width of the target in pixels or map units. |
| `height` | `dynamic` | — | Height of the target in pixels or map units. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_video.ml#L2066)

<a id="function-function-i-writeu16-inline-function-i-writeu16-buf-off-value-src-i-video-ml-686588047"></a>
### _I_WriteU16

```ml
inline function _I_WriteU16(buf, off, value)
```

Encodes the low 16 bits of a value into a little-endian Win32 structure buffer.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `buf` | `dynamic` | — | Buf value supplied to `_I_WriteU16`. |
| `off` | `dynamic` | — | Zero-based byte or element offset. |
| `value` | `dynamic` | — | Value consumed by the operation. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_video.ml#L1155)

<a id="function-function-i-writeu32-inline-function-i-writeu32-buf-off-value-src-i-video-ml-432394011"></a>
### _I_WriteU32

```ml
inline function _I_WriteU32(buf, off, value)
```

Encodes the low 32 bits of a value into a little-endian Win32 structure buffer.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `buf` | `dynamic` | — | Buf value supplied to `_I_WriteU32`. |
| `off` | `dynamic` | — | Zero-based byte or element offset. |
| `value` | `dynamic` | — | Value consumed by the operation. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_video.ml#L1166)

<a id="constant-constant-i-ws-overlappedwindow-const-i-ws-overlappedwindow-13565952-src-i-video-ml-248526370"></a>
### _I_WS_OVERLAPPEDWINDOW

```ml
const _I_WS_OVERLAPPEDWINDOW = 13565952
```

Defines i ws overlappedwindow for the i video subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_video.ml#L95)

<a id="constant-constant-i-ws-popup-const-i-ws-popup-2147483648-src-i-video-ml-981856682"></a>
### _I_WS_POPUP

```ml
const _I_WS_POPUP = -2147483648
```

Defines i ws popup for the i video subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_video.ml#L98)

<a id="constant-constant-i-ws-visible-const-i-ws-visible-268435456-src-i-video-ml-345860889"></a>
### _I_WS_VISIBLE

```ml
const _I_WS_VISIBLE = 268435456
```

Defines i ws visible for the i video subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_video.ml#L101)

<a id="extern_function-extern-function-adjustwindowrect-extern-function-adjustwindowrect-rect-as-bytes-style-as-u32-hasmenu-as-bool-from-user32-dll-symbol-adjustwindowrect-returns-bool-src-i-video-ml-934612357"></a>
### AdjustWindowRect

```ml
extern function AdjustWindowRect(rect as bytes, style as u32, hasMenu as bool) from "user32.dll" symbol "AdjustWindowRect" returns bool
```

Expands a desired client rectangle to include the selected non-client window borders.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `rect` | `bytes` | — | `bytes` value supplied as rect to `AdjustWindowRect`. |
| `style` | `u32` | — | `u32` value supplied as style to `AdjustWindowRect`. |
| `hasMenu` | `bool` | — | Whether has menu holds. |


**Returns:** Result returned by the native `AdjustWindowRect` binding as `bool`.

[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_video.ml#L159)

<a id="extern_function-extern-function-bringwindowtotop-extern-function-bringwindowtotop-hwnd-as-ptr-from-user32-dll-symbol-bringwindowtotop-returns-bool-src-i-video-ml-2025988236"></a>
### BringWindowToTop

```ml
extern function BringWindowToTop(hwnd as ptr) from "user32.dll" symbol "BringWindowToTop" returns bool
```

Raises the game window above other top-level windows during activation.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `hwnd` | `ptr` | — | `ptr` value supplied as hwnd to `BringWindowToTop`. |


**Returns:** Result returned by the native `BringWindowToTop` binding as `bool`.

[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_video.ml#L300)

<a id="extern_function-extern-function-createdirectoryw-extern-function-createdirectoryw-path-as-wstr-security-as-ptr-from-kernel32-dll-symbol-createdirectoryw-returns-bool-src-i-video-ml-331775168"></a>
### CreateDirectoryW

```ml
extern function CreateDirectoryW(path as wstr, security as ptr) from "kernel32.dll" symbol "CreateDirectoryW" returns bool
```

Creates the auto-screenshot output directory when it does not yet exist.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `path` | `wstr` | — | Filesystem path to process. |
| `security` | `ptr` | — | Optional native security-attributes pointer. |


**Returns:** The resulting auto-screenshot output directory when it does not yet exist.

[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_video.ml#L343)

<a id="function-function-createnullcursor-function-createnullcursor-src-i-video-ml-1567951135"></a>
### createnullcursor

```ml
function createnullcursor()
```

Preserves the legacy cursor-construction hook; cursor hiding is handled through ShowCursor instead.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_video.ml#L2668)

<a id="extern_function-extern-function-createwindowexw-extern-function-createwindowexw-exstyle-as-u32-classname-as-wstr-windowname-as-wstr-style-as-u32-x-as-int-y-as-int-width-as-int-height-as-int-parent-as-ptr-menu-as-ptr-instance-as-ptr-param-as-ptr-from-user32-dll-symbol-createwindowexw-returns-ptr-src-i-video-ml-946630219"></a>
### CreateWindowExW

```ml
extern function CreateWindowExW(exStyle as u32, className as wstr, windowName as wstr, style as u32, x as int, y as int, width as int, height as int, parent as ptr, menu as ptr, instance as ptr, param as ptr) from "user32.dll" symbol "CreateWindowExW" returns ptr
```

Creates the native game window with the requested client style, placement, and dimensions.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `exStyle` | `u32` | — | `u32` value supplied as ex style to `CreateWindowExW`. |
| `className` | `wstr` | — | `wstr` value supplied as class name to `CreateWindowExW`. |
| `windowName` | `wstr` | — | `wstr` value supplied as window name to `CreateWindowExW`. |
| `style` | `u32` | — | `u32` value supplied as style to `CreateWindowExW`. |
| `x` | `int` | — | Horizontal map- or screen-space coordinate. |
| `y` | `int` | — | Vertical map- or screen-space coordinate. |
| `width` | `int` | — | Width of the target in pixels or map units. |
| `height` | `int` | — | Height of the target in pixels or map units. |
| `parent` | `ptr` | — | `ptr` value supplied as parent to `CreateWindowExW`. |
| `menu` | `ptr` | — | `ptr` value supplied as menu to `CreateWindowExW`. |
| `instance` | `ptr` | — | `ptr` value supplied as instance to `CreateWindowExW`. |
| `param` | `ptr` | — | `ptr` value supplied as param to `CreateWindowExW`. |


**Returns:** The resulting native game window with the requested client style, placement, and dimensions.

[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_video.ml#L151)

<a id="extern_function-extern-function-destroywindow-extern-function-destroywindow-hwnd-as-ptr-from-user32-dll-symbol-destroywindow-returns-bool-src-i-video-ml-1959545130"></a>
### DestroyWindow

```ml
extern function DestroyWindow(hwnd as ptr) from "user32.dll" symbol "DestroyWindow" returns bool
```

Destroys a game window owned by this video backend.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `hwnd` | `ptr` | — | `ptr` value supplied as hwnd to `DestroyWindow`. |


**Returns:** Result returned by the native `DestroyWindow` binding as `bool`.

[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_video.ml#L184)

<a id="extern_function-extern-function-dispatchmessagew-extern-function-dispatchmessagew-msg-as-bytes-from-user32-dll-symbol-dispatchmessagew-returns-ptr-src-i-video-ml-1452847901"></a>
### DispatchMessageW

```ml
extern function DispatchMessageW(msg as bytes) from "user32.dll" symbol "DispatchMessageW" returns ptr
```

Dispatches a retrieved Win32 message to the target window procedure.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `msg` | `bytes` | — | `bytes` value supplied as msg to `DispatchMessageW`. |


**Returns:** Result returned by the native `DispatchMessageW` binding as `ptr`.

[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_video.ml#L226)

<a id="function-function-expand4-function-expand4-src-dst-count-src-i-video-ml-2140160445"></a>
### Expand4

```ml
function Expand4(src, dst, count)
```

Retains the legacy expansion entry point as a bounded raw byte copy into the destination buffer.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `src` | `dynamic` | — | Src value supplied to `Expand4`. |
| `dst` | `dynamic` | — | Dst value supplied to `Expand4`. |
| `count` | `dynamic` | — | Number of elements or iterations to process. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_video.ml#L2693)

<a id="extern_function-extern-function-getasynckeystate-extern-function-getasynckeystate-vkey-as-int-from-user32-dll-symbol-getasynckeystate-returns-int-src-i-video-ml-476647716"></a>
### GetAsyncKeyState

```ml
extern function GetAsyncKeyState(vkey as int) from "user32.dll" symbol "GetAsyncKeyState" returns int
```

Polls a virtual key's current high-bit down state for edge-based Doom input events.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `vkey` | `int` | — | Native virtual-key code to translate. |


**Returns:** Result returned by the native `GetAsyncKeyState` binding as `int`.

[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_video.ml#L232)

<a id="extern_function-extern-function-getclientrect-extern-function-getclientrect-hwnd-as-ptr-rect-as-bytes-from-user32-dll-symbol-getclientrect-returns-bool-src-i-video-ml-938374276"></a>
### GetClientRect

```ml
extern function GetClientRect(hwnd as ptr, rect as bytes) from "user32.dll" symbol "GetClientRect" returns bool
```

Reads the current drawable client dimensions for OpenGL resize or GDI scaling.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `hwnd` | `ptr` | — | `ptr` value supplied as hwnd to `GetClientRect`. |
| `rect` | `bytes` | — | `bytes` value supplied as rect to `GetClientRect`. |


**Returns:** The requested the current drawable client dimensions for OpenGL resize or GDI scaling.

[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_video.ml#L204)

<a id="extern_function-extern-function-getconsolewindow-extern-function-getconsolewindow-from-kernel32-dll-symbol-getconsolewindow-returns-ptr-src-i-video-ml-1751455446"></a>
### GetConsoleWindow

```ml
extern function GetConsoleWindow() from "kernel32.dll" symbol "GetConsoleWindow" returns ptr
```

Retrieves the process console window so startup can reuse or coordinate native window state.


**Returns:** Result returned by the native `GetConsoleWindow` binding as `ptr`.

[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_video.ml#L348)

<a id="extern_function-extern-function-getcursorpos-extern-function-getcursorpos-point-as-bytes-from-user32-dll-symbol-getcursorpos-returns-bool-src-i-video-ml-164391470"></a>
### GetCursorPos

```ml
extern function GetCursorPos(point as bytes) from "user32.dll" symbol "GetCursorPos" returns bool
```

Reads screen-space cursor coordinates used to derive relative mouse movement.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `point` | `bytes` | — | `bytes` value supplied as point to `GetCursorPos`. |


**Returns:** The requested screen-space cursor coordinates used to derive relative mouse movement.

[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_video.ml#L245)

<a id="extern_function-extern-function-getdc-extern-function-getdc-hwnd-as-ptr-from-user32-dll-symbol-getdc-returns-ptr-src-i-video-ml-1659126817"></a>
### GetDC

```ml
extern function GetDC(hwnd as ptr) from "user32.dll" symbol "GetDC" returns ptr
```

Acquires the client device context used for software StretchDIBits presentation.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `hwnd` | `ptr` | — | `ptr` value supplied as hwnd to `GetDC`. |


**Returns:** Result returned by the native `GetDC` binding as `ptr`.

[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_video.ml#L190)

<a id="extern_function-extern-function-getforegroundwindow-extern-function-getforegroundwindow-from-user32-dll-symbol-getforegroundwindow-returns-ptr-src-i-video-ml-1683204828"></a>
### GetForegroundWindow

```ml
extern function GetForegroundWindow() from "user32.dll" symbol "GetForegroundWindow" returns ptr
```

Identifies the foreground window so input is released when the game loses focus.


**Returns:** Result returned by the native `GetForegroundWindow` binding as `ptr`.

[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_video.ml#L250)

<a id="extern_function-extern-function-getsystemmetrics-extern-function-getsystemmetrics-index-as-int-from-user32-dll-symbol-getsystemmetrics-returns-int-src-i-video-ml-647850781"></a>
### GetSystemMetrics

```ml
extern function GetSystemMetrics(index as int) from "user32.dll" symbol "GetSystemMetrics" returns int
```

Reads desktop dimensions used to size the borderless fullscreen window.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `index` | `int` | — | Zero-based element or table index. |


**Returns:** The requested desktop dimensions used to size the borderless fullscreen window.

[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_video.ml#L261)

<a id="extern_function-extern-function-getwindowlongptrw-extern-function-getwindowlongptrw-hwnd-as-ptr-index-as-int-from-user32-dll-symbol-getwindowlongptrw-returns-ptr-src-i-video-ml-627304302"></a>
### GetWindowLongPtrW

```ml
extern function GetWindowLongPtrW(hwnd as ptr, index as int) from "user32.dll" symbol "GetWindowLongPtrW" returns ptr
```

Reads native window style data needed when updating presentation mode.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `hwnd` | `ptr` | — | `ptr` value supplied as hwnd to `GetWindowLongPtrW`. |
| `index` | `int` | — | Zero-based element or table index. |


**Returns:** The requested native window style data needed when updating presentation mode.

[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_video.ml#L280)

<a id="function-function-grabsharedmemory-function-grabsharedmemory-size-src-i-video-ml-303888106"></a>
### grabsharedmemory

```ml
function grabsharedmemory(size)
```

Preserves the legacy shared-framebuffer allocation hook; this backend owns byte buffers directly and returns void.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `size` | `dynamic` | — | Requested size in bytes or elements. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_video.ml#L2675)

<a id="function-function-i-beginhdwipe-function-i-beginhdwipe-src-i-video-ml-560126483"></a>
### I_BeginHDWipe

```ml
function I_BeginHDWipe()
```

Captures the current high-resolution start frame from OpenGL, the last RGBA frame, or a nearest logical fallback.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_video.ml#L684)

<a id="function-function-i-captureglframetoscreen-function-i-captureglframetoscreen-src-i-video-ml-598646243"></a>
### I_CaptureGLFrameToScreen

```ml
function I_CaptureGLFrameToScreen()
```

Composes the current OpenGL world and UI, then reads a logical indexed capture into screen zero.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_video.ml#L2454)

<a id="function-function-i-capturelogicaloverlaybase-function-i-capturelogicaloverlaybase-src-i-video-ml-951043003"></a>
### I_CaptureLogicalOverlayBase

```ml
function I_CaptureLogicalOverlayBase()
```

Captures the logical framebuffer before late menu/message drawing.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_video.ml#L2511)

<a id="function-function-i-finishupdate-function-i-finishupdate-src-i-video-ml-1689348567"></a>
### I_FinishUpdate

```ml
function I_FinishUpdate()
```

Presents one completed frame through native OpenGL, indexed GL fallback, or GDI and performs FPS/screenshot bookkeeping.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_video.ml#L2565)

<a id="function-function-i-getevent-function-i-getevent-src-i-video-ml-1469405115"></a>
### I_GetEvent

```ml
function I_GetEvent()
```

Pumps native messages and posts all currently observed keyboard and mouse input changes.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_video.ml#L2724)

<a id="function-function-i-getfps-function-i-getfps-src-i-video-ml-1710521951"></a>
### I_GetFPS

```ml
function I_GetFPS()
```

Exposes the last completed one-second presentation sample to in-game UI overlays.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_video.ml#L907)

<a id="function-function-i-hdscreenwipe-function-i-hdscreenwipe-tics-src-i-video-ml-1505333242"></a>
### I_HDScreenWipe

```ml
function I_HDScreenWipe(tics)
```

Advances, draws, and swaps the high-resolution melt transition, returning true after every column reaches the bottom.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `tics` | `dynamic` | — | Duration measured in Doom game tics. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_video.ml#L820)

<a id="function-function-i-initgraphics-function-i-initgraphics-src-i-video-ml-1175045107"></a>
### I_InitGraphics

```ml
function I_InitGraphics()
```

Allocates video/input buffers, parses display and screenshot options, creates the window, and initializes presentation state.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_video.ml#L2292)

<a id="function-function-i-loadingpulse-function-i-loadingpulse-src-i-video-ml-1839338687"></a>
### I_LoadingPulse

```ml
function I_LoadingPulse()
```

Pumps window/audio updates and draws an animated loading marker while heavy loading code runs.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_video.ml#L2542)

<a id="function-function-i-pollinput-function-i-pollinput-src-i-video-ml-1448869485"></a>
### I_PollInput

```ml
function I_PollInput()
```

Pumps native messages and posts current keyboard and mouse edge/motion events to Doom.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_video.ml#L2557)

<a id="function-function-i-preparehdwipeend-function-i-preparehdwipeend-src-i-video-ml-1620471307"></a>
### I_PrepareHDWipeEnd

```ml
function I_PrepareHDWipeEnd()
```

Captures the destination frame and initializes correlated delayed melt positions for two-logical-pixel column groups.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_video.ml#L715)

<a id="function-function-i-readscreen-function-i-readscreen-scr-src-i-video-ml-741646909"></a>
### I_ReadScreen

```ml
function I_ReadScreen(scr)
```

Copies the complete 320x200 logical framebuffer from screen zero into a caller-provided capture buffer.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `scr` | `dynamic` | — | Scr value supplied to `I_ReadScreen`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_video.ml#L2661)

<a id="function-function-i-setforcesoftwarepresent-function-i-setforcesoftwarepresent-v-src-i-video-ml-734667613"></a>
### I_SetForceSoftwarePresent

```ml
function I_SetForceSoftwarePresent(v)
```

Forces the next presentation path to use a nearest-scaled logical framebuffer instead of native OpenGL world output.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `v` | `dynamic` | — | Value consumed by the operation. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_video.ml#L558)

<a id="function-function-i-setloadingstatus-function-i-setloadingstatus-text-src-i-video-ml-60940544"></a>
### I_SetLoadingStatus

```ml
function I_SetLoadingStatus(text)
```

Sets or clears loading text in the window caption, resets animation when cleared, and pumps messages immediately.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `text` | `dynamic` | — | Text to process. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_video.ml#L2525)

<a id="function-function-i-setpalette-function-i-setpalette-palette-src-i-video-ml-729637086"></a>
### I_SetPalette

```ml
function I_SetPalette(palette)
```

Applies the selected gamma table to a 256-color palette and updates both GDI and OpenGL palette consumers.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `palette` | `dynamic` | — | Palette value supplied to `I_SetPalette`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_video.ml#L2419)

<a id="function-function-i-shutdowngraphics-function-i-shutdowngraphics-src-i-video-ml-876306099"></a>
### I_ShutdownGraphics

```ml
function I_ShutdownGraphics()
```

Restores the cursor, shuts down OpenGL, releases the device context, and destroys the owned native window.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_video.ml#L2392)

<a id="function-function-i-startframe-function-i-startframe-src-i-video-ml-2021092591"></a>
### I_StartFrame

```ml
function I_StartFrame()
```

Services native window messages at the start of a rendered frame.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_video.ml#L2731)

<a id="function-function-i-starttic-function-i-starttic-src-i-video-ml-1348154195"></a>
### I_StartTic

```ml
function I_StartTic()
```

Polls and posts platform input events at the start of a simulation tic.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_video.ml#L2736)

<a id="function-function-i-updatenoblit-function-i-updatenoblit-src-i-video-ml-1030797555"></a>
### I_UpdateNoBlit

```ml
function I_UpdateNoBlit()
```

Services the Win32 message queue without presenting or modifying a framebuffer.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_video.ml#L2449)

<a id="function-function-initexpand-function-initexpand-src-i-video-ml-1416737831"></a>
### InitExpand

```ml
function InitExpand()
```

Preserves the legacy indexed expansion initializer; physical scaling is performed by current presentation paths.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_video.ml#L2682)

<a id="function-function-initexpand2-function-initexpand2-src-i-video-ml-492636399"></a>
### InitExpand2

```ml
function InitExpand2()
```

Preserves the second legacy expansion initializer; no precomputed expansion tables are required.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_video.ml#L2686)

<a id="extern_function-extern-function-iswindow-extern-function-iswindow-hwnd-as-ptr-from-user32-dll-symbol-iswindow-returns-bool-src-i-video-ml-387756356"></a>
### IsWindow

```ml
extern function IsWindow(hwnd as ptr) from "user32.dll" symbol "IsWindow" returns bool
```

Validates that the stored native handle still names a live window.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `hwnd` | `ptr` | — | `ptr` value supplied as hwnd to `IsWindow`. |


**Returns:** Result returned by the native `IsWindow` binding as `bool`.

[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_video.ml#L312)

<a id="extern_function-extern-function-peekmessagew-extern-function-peekmessagew-msg-as-bytes-hwnd-as-ptr-minmsg-as-u32-maxmsg-as-u32-removemsg-as-u32-from-user32-dll-symbol-peekmessagew-returns-bool-src-i-video-ml-1573070924"></a>
### PeekMessageW

```ml
extern function PeekMessageW(msg as bytes, hwnd as ptr, minMsg as u32, maxMsg as u32, removeMsg as u32) from "user32.dll" symbol "PeekMessageW" returns bool
```

Retrieves and optionally removes queued Win32 messages without blocking the game loop.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `msg` | `bytes` | — | `bytes` value supplied as msg to `PeekMessageW`. |
| `hwnd` | `ptr` | — | `ptr` value supplied as hwnd to `PeekMessageW`. |
| `minMsg` | `u32` | — | `u32` value supplied as min msg to `PeekMessageW`. |
| `maxMsg` | `u32` | — | `u32` value supplied as max msg to `PeekMessageW`. |
| `removeMsg` | `u32` | — | `u32` value supplied as remove msg to `PeekMessageW`. |


**Returns:** Result returned by the native `PeekMessageW` binding as `bool`.

[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_video.ml#L214)

<a id="extern_function-extern-function-releasedc-extern-function-releasedc-hwnd-as-ptr-hdc-as-ptr-from-user32-dll-symbol-releasedc-returns-int-src-i-video-ml-816091938"></a>
### ReleaseDC

```ml
extern function ReleaseDC(hwnd as ptr, hdc as ptr) from "user32.dll" symbol "ReleaseDC" returns int
```

Releases a client device context previously acquired for software presentation.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `hwnd` | `ptr` | — | `ptr` value supplied as hwnd to `ReleaseDC`. |
| `hdc` | `ptr` | — | `ptr` value supplied as hdc to `ReleaseDC`. |


**Returns:** Result returned by the native `ReleaseDC` binding as `int`.

[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_video.ml#L197)

<a id="extern_function-extern-function-setactivewindow-extern-function-setactivewindow-hwnd-as-ptr-from-user32-dll-symbol-setactivewindow-returns-ptr-src-i-video-ml-237475242"></a>
### SetActiveWindow

```ml
extern function SetActiveWindow(hwnd as ptr) from "user32.dll" symbol "SetActiveWindow" returns ptr
```

Activates the game window within the current input thread.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `hwnd` | `ptr` | — | `ptr` value supplied as hwnd to `SetActiveWindow`. |


**Returns:** Result returned by the native `SetActiveWindow` binding as `ptr`.

[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_video.ml#L306)

<a id="extern_function-extern-function-setforegroundwindow-extern-function-setforegroundwindow-hwnd-as-ptr-from-user32-dll-symbol-setforegroundwindow-returns-bool-src-i-video-ml-1912458791"></a>
### SetForegroundWindow

```ml
extern function SetForegroundWindow(hwnd as ptr) from "user32.dll" symbol "SetForegroundWindow" returns bool
```

Requests foreground keyboard focus for the newly created game window.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `hwnd` | `ptr` | — | `ptr` value supplied as hwnd to `SetForegroundWindow`. |


**Returns:** Result returned by the native `SetForegroundWindow` binding as `bool`.

[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_video.ml#L294)

<a id="extern_function-extern-function-setstretchbltmode-extern-function-setstretchbltmode-hdc-as-ptr-mode-as-int-from-gdi32-dll-symbol-setstretchbltmode-returns-int-src-i-video-ml-1047276012"></a>
### SetStretchBltMode

```ml
extern function SetStretchBltMode(hdc as ptr, mode as int) from "gdi32.dll" symbol "SetStretchBltMode" returns int
```

Selects COLORONCOLOR scaling for crisp software framebuffer presentation.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `hdc` | `ptr` | — | `ptr` value supplied as hdc to `SetStretchBltMode`. |
| `mode` | `int` | — | `int` value supplied as mode to `SetStretchBltMode`. |


**Returns:** Result returned by the native `SetStretchBltMode` binding as `int`.

[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_video.ml#L337)

<a id="extern_function-extern-function-setwindowlongptrw-extern-function-setwindowlongptrw-hwnd-as-ptr-index-as-int-newlong-as-ptr-from-user32-dll-symbol-setwindowlongptrw-returns-ptr-src-i-video-ml-983985048"></a>
### SetWindowLongPtrW

```ml
extern function SetWindowLongPtrW(hwnd as ptr, index as int, newLong as ptr) from "user32.dll" symbol "SetWindowLongPtrW" returns ptr
```

Replaces native window style data when updating presentation mode.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `hwnd` | `ptr` | — | `ptr` value supplied as hwnd to `SetWindowLongPtrW`. |
| `index` | `int` | — | Zero-based element or table index. |
| `newLong` | `ptr` | — | `ptr` value supplied as new long to `SetWindowLongPtrW`. |


**Returns:** Result returned by the native `SetWindowLongPtrW` binding as `ptr`.

[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_video.ml#L288)

<a id="extern_function-extern-function-setwindowpos-extern-function-setwindowpos-hwnd-as-ptr-insertafter-as-ptr-x-as-int-y-as-int-width-as-int-height-as-int-flags-as-u32-from-user32-dll-symbol-setwindowpos-returns-bool-src-i-video-ml-1432164412"></a>
### SetWindowPos

```ml
extern function SetWindowPos(hwnd as ptr, insertAfter as ptr, x as int, y as int, width as int, height as int, flags as u32) from "user32.dll" symbol "SetWindowPos" returns bool
```

Repositions or resizes the game window while changing fullscreen/windowed presentation.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `hwnd` | `ptr` | — | `ptr` value supplied as hwnd to `SetWindowPos`. |
| `insertAfter` | `ptr` | — | `ptr` value supplied as insert after to `SetWindowPos`. |
| `x` | `int` | — | Horizontal map- or screen-space coordinate. |
| `y` | `int` | — | Vertical map- or screen-space coordinate. |
| `width` | `int` | — | Width of the target in pixels or map units. |
| `height` | `int` | — | Height of the target in pixels or map units. |
| `flags` | `u32` | — | Bit flags that control the operation. |


**Returns:** Result returned by the native `SetWindowPos` binding as `bool`.

[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_video.ml#L273)

<a id="extern_function-extern-function-setwindowtextw-extern-function-setwindowtextw-hwnd-as-ptr-text-as-wstr-from-user32-dll-symbol-setwindowtextw-returns-bool-src-i-video-ml-1870337857"></a>
### SetWindowTextW

```ml
extern function SetWindowTextW(hwnd as ptr, text as wstr) from "user32.dll" symbol "SetWindowTextW" returns bool
```

Updates the game window caption with loading or FPS status.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `hwnd` | `ptr` | — | `ptr` value supplied as hwnd to `SetWindowTextW`. |
| `text` | `wstr` | — | Text to process. |


**Returns:** Result returned by the native `SetWindowTextW` binding as `bool`.

[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_video.ml#L239)

<a id="extern_function-extern-function-showcursor-extern-function-showcursor-show-as-bool-from-user32-dll-symbol-showcursor-returns-int-src-i-video-ml-1484650958"></a>
### ShowCursor

```ml
extern function ShowCursor(show as bool) from "user32.dll" symbol "ShowCursor" returns int
```

Shows or hides the system cursor.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `show` | `bool` | — | `bool` value supplied as show to `ShowCursor`. |


**Returns:** Result returned by the native `ShowCursor` binding as `int`.

[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_video.ml#L255)

<a id="extern_function-extern-function-showwindow-extern-function-showwindow-hwnd-as-ptr-cmdshow-as-int-from-user32-dll-symbol-showwindow-returns-bool-src-i-video-ml-1846991083"></a>
### ShowWindow

```ml
extern function ShowWindow(hwnd as ptr, cmdShow as int) from "user32.dll" symbol "ShowWindow" returns bool
```

Applies the requested visibility state to the native game window.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `hwnd` | `ptr` | — | `ptr` value supplied as hwnd to `ShowWindow`. |
| `cmdShow` | `int` | — | `int` value supplied as cmd show to `ShowWindow`. |


**Returns:** Result returned by the native `ShowWindow` binding as `bool`.

[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_video.ml#L166)

<a id="extern_function-extern-function-stretchdibits-extern-function-stretchdibits-hdc-as-ptr-xdest-as-int-ydest-as-int-destwidth-as-int-destheight-as-int-xsrc-as-int-ysrc-as-int-srcwidth-as-int-srcheight-as-int-bits-as-bytes-bmi-as-bytes-usage-as-u32-rop-as-u32-from-gdi32-dll-symbol-stretchdibits-returns-int-src-i-video-ml-425254948"></a>
### StretchDIBits

```ml
extern function StretchDIBits(hdc as ptr, xDest as int, yDest as int, destWidth as int, destHeight as int, xSrc as int, ySrc as int, srcWidth as int, srcHeight as int, bits as bytes, bmi as bytes, usage as u32, rop as u32) from "gdi32.dll" symbol "StretchDIBits" returns int
```

Scales and copies the indexed DIB presentation buffer into the window client area.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `hdc` | `ptr` | — | `ptr` value supplied as hdc to `StretchDIBits`. |
| `xDest` | `int` | — | `int` value supplied as x dest to `StretchDIBits`. |
| `yDest` | `int` | — | `int` value supplied as y dest to `StretchDIBits`. |
| `destWidth` | `int` | — | Width of dest width in pixels or map units. |
| `destHeight` | `int` | — | Height of dest height in pixels or map units. |
| `xSrc` | `int` | — | `int` value supplied as x src to `StretchDIBits`. |
| `ySrc` | `int` | — | `int` value supplied as y src to `StretchDIBits`. |
| `srcWidth` | `int` | — | Width of src width in pixels or map units. |
| `srcHeight` | `int` | — | Height of src height in pixels or map units. |
| `bits` | `bytes` | — | `bytes` value supplied as bits to `StretchDIBits`. |
| `bmi` | `bytes` | — | `bytes` value supplied as bmi to `StretchDIBits`. |
| `usage` | `u32` | — | `u32` value supplied as usage to `StretchDIBits`. |
| `rop` | `u32` | — | `u32` value supplied as rop to `StretchDIBits`. |


**Returns:** Result returned by the native `StretchDIBits` binding as `int`.

[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_video.ml#L330)

<a id="extern_function-extern-function-translatemessage-extern-function-translatemessage-msg-as-bytes-from-user32-dll-symbol-translatemessage-returns-bool-src-i-video-ml-500796440"></a>
### TranslateMessage

```ml
extern function TranslateMessage(msg as bytes) from "user32.dll" symbol "TranslateMessage" returns bool
```

Generates character messages from a retrieved keyboard message before dispatch.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `msg` | `bytes` | — | `bytes` value supplied as msg to `TranslateMessage`. |


**Returns:** Result returned by the native `TranslateMessage` binding as `bool`.

[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_video.ml#L220)

<a id="extern_function-extern-function-updatewindow-extern-function-updatewindow-hwnd-as-ptr-from-user32-dll-symbol-updatewindow-returns-bool-src-i-video-ml-1735859569"></a>
### UpdateWindow

```ml
extern function UpdateWindow(hwnd as ptr) from "user32.dll" symbol "UpdateWindow" returns bool
```

Forces pending client-area painting for a shown native window.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `hwnd` | `ptr` | — | `ptr` value supplied as hwnd to `UpdateWindow`. |


**Returns:** Result returned by the native `UpdateWindow` binding as `bool`.

[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_video.ml#L172)

<a id="function-function-uploadnewpalette-function-uploadnewpalette-pal-src-i-video-ml-1924735708"></a>
### UploadNewPalette

```ml
function UploadNewPalette(pal)
```

Compatibility entry point that applies a newly selected Doom palette through the active gamma-aware path.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `pal` | `dynamic` | — | Pal value supplied to `UploadNewPalette`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_video.ml#L2700)

<a id="extern_function-extern-function-validaterect-extern-function-validaterect-hwnd-as-ptr-rect-as-ptr-from-user32-dll-symbol-validaterect-returns-bool-src-i-video-ml-360093850"></a>
### ValidateRect

```ml
extern function ValidateRect(hwnd as ptr, rect as ptr) from "user32.dll" symbol "ValidateRect" returns bool
```

Clears pending client repaint requests after title updates on the built-in STATIC window class.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `hwnd` | `ptr` | — | `ptr` value supplied as hwnd to `ValidateRect`. |
| `rect` | `ptr` | — | `ptr` value supplied as rect to `ValidateRect`. |


**Returns:** Result returned by the native `ValidateRect` binding as `bool`.

[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_video.ml#L178)

<a id="function-function-xlatekey-function-xlatekey-vk-src-i-video-ml-1934464348"></a>
### xlatekey

```ml
function xlatekey(vk)
```

Translates a Win32 virtual key to its Doom code, with direct digit and lowercase-letter fallbacks.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `vk` | `dynamic` | — | Vk value supplied to `xlatekey`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_video.ml#L2706)
