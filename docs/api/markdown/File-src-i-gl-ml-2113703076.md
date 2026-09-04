# `src/i_gl.ml`

[Home](README.md) · [Files](Files.md)

Optional Win32/WGL OpenGL backend helpers.

Package: [`(global)`](Package-global-1952375359.md)

Reachable from entry: **yes**

## Imports

- `doomdef.ml` → [src/doomdef.ml](File-src-doomdef-ml-460406769.md)
- `m_argv.ml` → [src/m_argv.ml](File-src-m-argv-ml-728984635.md)
- `r_renderer.ml` → [src/r_renderer.ml](File-src-r-renderer-ml-72894217.md)
- `std/math.ml` → `../MiniLangCompilerOptimization/MiniLangCompilerPy/std/math.ml` — external dependency

## Declarations

<a id="extern_function-extern-function-choosepixelformat-extern-function-choosepixelformat-hdc-as-ptr-pfd-as-bytes-from-gdi32-dll-symbol-choosepixelformat-returns-int-src-i-gl-ml-1620797551"></a>
### ChoosePixelFormat

```ml
extern function ChoosePixelFormat(hdc as ptr, pfd as bytes) from "gdi32.dll" symbol "ChoosePixelFormat" returns int
```

Asks GDI for the closest window pixel format matching the requested OpenGL framebuffer descriptor.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `hdc` | `ptr` | — | `ptr` value supplied as hdc to `ChoosePixelFormat`. |
| `pfd` | `bytes` | — | `bytes` value supplied as pfd to `ChoosePixelFormat`. |


**Returns:** Result returned by the native `ChoosePixelFormat` binding as `int`.

[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_gl.ml#L126)

<a id="constant-constant-gl-alpha-test-const-gl-alpha-test-3008-src-i-gl-ml-636043453"></a>
### GL_ALPHA_TEST

```ml
const GL_ALPHA_TEST = 3008
```

Defines gl alpha test for the i gl subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_gl.ml#L64)

<a id="constant-constant-gl-back-const-gl-back-1029-src-i-gl-ml-1219782114"></a>
### GL_BACK

```ml
const GL_BACK = 1029
```

Defines gl back for the i gl subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_gl.ml#L46)

<a id="constant-constant-gl-blend-const-gl-blend-3042-src-i-gl-ml-529353103"></a>
### GL_BLEND

```ml
const GL_BLEND = 3042
```

Defines gl blend for the i gl subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_gl.ml#L62)

<a id="constant-constant-gl-clamp-const-gl-clamp-10496-src-i-gl-ml-219531384"></a>
### GL_CLAMP

```ml
const GL_CLAMP = 10496
```

Defines gl clamp for the i gl subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_gl.ml#L112)

<a id="constant-constant-gl-color-array-const-gl-color-array-32886-src-i-gl-ml-396556877"></a>
### GL_COLOR_ARRAY

```ml
const GL_COLOR_ARRAY = 32886
```

Defines the Doom palette selection for gl color array.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_gl.ml#L96)

<a id="constant-constant-gl-color-buffer-bit-const-gl-color-buffer-bit-16384-src-i-gl-ml-1473804464"></a>
### GL_COLOR_BUFFER_BIT

```ml
const GL_COLOR_BUFFER_BIT = 16384
```

Defines the Doom palette selection for gl color buffer bit.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_gl.ml#L42)

<a id="constant-constant-gl-compile-const-gl-compile-4864-src-i-gl-ml-1410872412"></a>
### GL_COMPILE

```ml
const GL_COMPILE = 4864
```

Defines gl compile for the i gl subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_gl.ml#L84)

<a id="constant-constant-gl-cull-face-const-gl-cull-face-2884-src-i-gl-ml-1566076742"></a>
### GL_CULL_FACE

```ml
const GL_CULL_FACE = 2884
```

Defines gl cull face for the i gl subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_gl.ml#L58)

<a id="constant-constant-gl-depth-buffer-bit-const-gl-depth-buffer-bit-256-src-i-gl-ml-1281621657"></a>
### GL_DEPTH_BUFFER_BIT

```ml
const GL_DEPTH_BUFFER_BIT = 256
```

Defines gl depth buffer bit for the i gl subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_gl.ml#L40)

<a id="constant-constant-gl-depth-test-const-gl-depth-test-2929-src-i-gl-ml-1839926750"></a>
### GL_DEPTH_TEST

```ml
const GL_DEPTH_TEST = 2929
```

Defines gl depth test for the i gl subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_gl.ml#L56)

<a id="constant-constant-gl-front-const-gl-front-1028-src-i-gl-ml-2088654861"></a>
### GL_FRONT

```ml
const GL_FRONT = 1028
```

Defines gl front for the i gl subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_gl.ml#L44)

<a id="constant-constant-gl-greater-const-gl-greater-516-src-i-gl-ml-251171690"></a>
### GL_GREATER

```ml
const GL_GREATER = 516
```

Defines gl greater for the i gl subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_gl.ml#L76)

<a id="constant-constant-gl-int-const-gl-int-5124-src-i-gl-ml-1416643794"></a>
### GL_INT

```ml
const GL_INT = 5124
```

Defines gl int for the i gl subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_gl.ml#L90)

<a id="constant-constant-gl-lequal-const-gl-lequal-515-src-i-gl-ml-1143554437"></a>
### GL_LEQUAL

```ml
const GL_LEQUAL = 515
```

Defines gl lequal for the i gl subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_gl.ml#L70)

<a id="constant-constant-gl-less-const-gl-less-513-src-i-gl-ml-1963264979"></a>
### GL_LESS

```ml
const GL_LESS = 513
```

Defines gl less for the i gl subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_gl.ml#L68)

<a id="constant-constant-gl-linear-const-gl-linear-9729-src-i-gl-ml-670845859"></a>
### GL_LINEAR

```ml
const GL_LINEAR = 9729
```

Defines gl linear for the i gl subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_gl.ml#L110)

<a id="constant-constant-gl-lines-const-gl-lines-1-src-i-gl-ml-1099490547"></a>
### GL_LINES

```ml
const GL_LINES = 1
```

Defines gl lines for the i gl subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_gl.ml#L48)

<a id="constant-constant-gl-modelview-const-gl-modelview-5888-src-i-gl-ml-623309221"></a>
### GL_MODELVIEW

```ml
const GL_MODELVIEW = 5888
```

Defines gl modelview for the i gl subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_gl.ml#L80)

<a id="constant-constant-gl-nearest-const-gl-nearest-9728-src-i-gl-ml-606645634"></a>
### GL_NEAREST

```ml
const GL_NEAREST = 9728
```

Defines gl nearest for the i gl subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_gl.ml#L108)

<a id="constant-constant-gl-one-const-gl-one-1-src-i-gl-ml-1677722413"></a>
### GL_ONE

```ml
const GL_ONE = 1
```

Defines gl one for the i gl subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_gl.ml#L66)

<a id="constant-constant-gl-one-minus-src-alpha-const-gl-one-minus-src-alpha-771-src-i-gl-ml-1122049489"></a>
### GL_ONE_MINUS_SRC_ALPHA

```ml
const GL_ONE_MINUS_SRC_ALPHA = 771
```

Defines the minimum gl one minus src alpha accepted by the i gl subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_gl.ml#L74)

<a id="constant-constant-gl-pack-alignment-const-gl-pack-alignment-3333-src-i-gl-ml-1741296546"></a>
### GL_PACK_ALIGNMENT

```ml
const GL_PACK_ALIGNMENT = 3333
```

Defines gl pack alignment for the i gl subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_gl.ml#L118)

<a id="constant-constant-gl-polygon-const-gl-polygon-9-src-i-gl-ml-1606109993"></a>
### GL_POLYGON

```ml
const GL_POLYGON = 9
```

Defines gl polygon for the i gl subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_gl.ml#L54)

<a id="constant-constant-gl-projection-const-gl-projection-5889-src-i-gl-ml-1375813372"></a>
### GL_PROJECTION

```ml
const GL_PROJECTION = 5889
```

Defines gl projection for the i gl subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_gl.ml#L78)

<a id="constant-constant-gl-quads-const-gl-quads-7-src-i-gl-ml-312359763"></a>
### GL_QUADS

```ml
const GL_QUADS = 7
```

Defines gl quads for the i gl subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_gl.ml#L52)

<a id="constant-constant-gl-repeat-const-gl-repeat-10497-src-i-gl-ml-1111121459"></a>
### GL_REPEAT

```ml
const GL_REPEAT = 10497
```

Defines gl repeat for the i gl subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_gl.ml#L114)

<a id="constant-constant-gl-rgb-const-gl-rgb-6407-src-i-gl-ml-1910541593"></a>
### GL_RGB

```ml
const GL_RGB = 6407
```

Defines gl rgb for the i gl subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_gl.ml#L88)

<a id="constant-constant-gl-rgba-const-gl-rgba-6408-src-i-gl-ml-1437478096"></a>
### GL_RGBA

```ml
const GL_RGBA = 6408
```

Defines gl rgba for the i gl subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_gl.ml#L86)

<a id="constant-constant-gl-src-alpha-const-gl-src-alpha-770-src-i-gl-ml-185235242"></a>
### GL_SRC_ALPHA

```ml
const GL_SRC_ALPHA = 770
```

Defines gl src alpha for the i gl subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_gl.ml#L72)

<a id="constant-constant-gl-texture-const-gl-texture-5890-src-i-gl-ml-973535642"></a>
### GL_TEXTURE

```ml
const GL_TEXTURE = 5890
```

Defines gl texture for the i gl subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_gl.ml#L82)

<a id="constant-constant-gl-texture-2d-const-gl-texture-2d-3553-src-i-gl-ml-874120618"></a>
### GL_TEXTURE_2D

```ml
const GL_TEXTURE_2D = 3553
```

Defines gl texture 2 d for the i gl subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_gl.ml#L60)

<a id="constant-constant-gl-texture-coord-array-const-gl-texture-coord-array-32888-src-i-gl-ml-78855775"></a>
### GL_TEXTURE_COORD_ARRAY

```ml
const GL_TEXTURE_COORD_ARRAY = 32888
```

Defines gl texture coord array for the i gl subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_gl.ml#L98)

<a id="constant-constant-gl-texture-mag-filter-const-gl-texture-mag-filter-10240-src-i-gl-ml-205575449"></a>
### GL_TEXTURE_MAG_FILTER

```ml
const GL_TEXTURE_MAG_FILTER = 10240
```

Defines gl texture mag filter for the i gl subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_gl.ml#L100)

<a id="constant-constant-gl-texture-min-filter-const-gl-texture-min-filter-10241-src-i-gl-ml-598508242"></a>
### GL_TEXTURE_MIN_FILTER

```ml
const GL_TEXTURE_MIN_FILTER = 10241
```

Defines the minimum gl texture min filter accepted by the i gl subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_gl.ml#L102)

<a id="constant-constant-gl-texture-wrap-s-const-gl-texture-wrap-s-10242-src-i-gl-ml-1502941303"></a>
### GL_TEXTURE_WRAP_S

```ml
const GL_TEXTURE_WRAP_S = 10242
```

Defines gl texture wrap s for the i gl subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_gl.ml#L104)

<a id="constant-constant-gl-texture-wrap-t-const-gl-texture-wrap-t-10243-src-i-gl-ml-185449916"></a>
### GL_TEXTURE_WRAP_T

```ml
const GL_TEXTURE_WRAP_T = 10243
```

Defines gl texture wrap t for the i gl subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_gl.ml#L106)

<a id="constant-constant-gl-triangles-const-gl-triangles-4-src-i-gl-ml-521329068"></a>
### GL_TRIANGLES

```ml
const GL_TRIANGLES = 4
```

Defines gl triangles for the i gl subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_gl.ml#L50)

<a id="constant-constant-gl-unpack-alignment-const-gl-unpack-alignment-3317-src-i-gl-ml-1890832892"></a>
### GL_UNPACK_ALIGNMENT

```ml
const GL_UNPACK_ALIGNMENT = 3317
```

Defines gl unpack alignment for the i gl subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_gl.ml#L116)

<a id="constant-constant-gl-unsigned-byte-const-gl-unsigned-byte-5121-src-i-gl-ml-2005552911"></a>
### GL_UNSIGNED_BYTE

```ml
const GL_UNSIGNED_BYTE = 5121
```

Defines gl unsigned byte for the i gl subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_gl.ml#L92)

<a id="constant-constant-gl-vertex-array-const-gl-vertex-array-32884-src-i-gl-ml-584308855"></a>
### GL_VERTEX_ARRAY

```ml
const GL_VERTEX_ARRAY = 32884
```

Defines gl vertex array for the i gl subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_gl.ml#L94)

<a id="extern_function-extern-function-glalphafunc-extern-function-glalphafunc-func-as-u32-ref-as-double-from-opengl32-dll-symbol-glalphafunc-returns-void-src-i-gl-ml-525120208"></a>
### glAlphaFunc

```ml
extern function glAlphaFunc(func as u32, ref as double) from "opengl32.dll" symbol "glAlphaFunc" returns void
```

Selects the comparison and threshold used by fixed-function alpha testing.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `func` | `u32` | — | `u32` value supplied as func to `glAlphaFunc`. |
| `ref` | `double` | — | `double` value supplied as ref to `glAlphaFunc`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_gl.ml#L532)

<a id="extern_function-extern-function-glbegin-extern-function-glbegin-mode-as-u32-from-opengl32-dll-symbol-glbegin-returns-void-src-i-gl-ml-1530497474"></a>
### glBegin

```ml
extern function glBegin(mode as u32) from "opengl32.dll" symbol "glBegin" returns void
```

Opens an immediate-mode primitive stream with the requested topology.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `mode` | `u32` | — | `u32` value supplied as mode to `glBegin`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_gl.ml#L239)

<a id="extern_function-extern-function-glbindtexture-extern-function-glbindtexture-target-as-u32-texture-as-u32-from-opengl32-dll-symbol-glbindtexture-returns-void-src-i-gl-ml-1707488542"></a>
### glBindTexture

```ml
extern function glBindTexture(target as u32, texture as u32) from "opengl32.dll" symbol "glBindTexture" returns void
```

Makes a texture object current for operations on the selected texture target.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `target` | `u32` | — | `u32` value supplied as target to `glBindTexture`. |
| `texture` | `u32` | — | `u32` value supplied as texture to `glBindTexture`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_gl.ml#L542)

<a id="extern_function-extern-function-glblendfunc-extern-function-glblendfunc-sfactor-as-u32-dfactor-as-u32-from-opengl32-dll-symbol-glblendfunc-returns-void-src-i-gl-ml-140939702"></a>
### glBlendFunc

```ml
extern function glBlendFunc(sfactor as u32, dfactor as u32) from "opengl32.dll" symbol "glBlendFunc" returns void
```

Selects source and destination factors for fixed-function color blending.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `sfactor` | `u32` | — | `u32` value supplied as sfactor to `glBlendFunc`. |
| `dfactor` | `u32` | — | `u32` value supplied as dfactor to `glBlendFunc`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_gl.ml#L527)

<a id="extern_function-extern-function-glcalllist-extern-function-glcalllist-list-as-u32-from-opengl32-dll-symbol-glcalllist-returns-void-src-i-gl-ml-842196886"></a>
### glCallList

```ml
extern function glCallList(list as u32) from "opengl32.dll" symbol "glCallList" returns void
```

Executes the commands compiled under one OpenGL display-list identifier.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `list` | `u32` | — | `u32` value supplied as list to `glCallList`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_gl.ml#L259)

<a id="extern_function-extern-function-glclear-extern-function-glclear-mask-as-u32-from-opengl32-dll-symbol-glclear-returns-void-src-i-gl-ml-1316321273"></a>
### glClear

```ml
extern function glClear(mask as u32) from "opengl32.dll" symbol "glClear" returns void
```

Clears the framebuffer attachments selected by the caller's OpenGL mask.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `mask` | `u32` | — | `u32` value supplied as mask to `glClear`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_gl.ml#L167)

<a id="extern_function-extern-function-glcleardepth-extern-function-glcleardepth-depth-as-double-from-opengl32-dll-symbol-glcleardepth-returns-void-src-i-gl-ml-663796578"></a>
### glClearDepth

```ml
extern function glClearDepth(depth as double) from "opengl32.dll" symbol "glClearDepth" returns void
```

Selects the depth value subsequently written by depth-buffer clears.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `depth` | `double` | — | `double` value supplied as depth to `glClearDepth`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_gl.ml#L171)

<a id="extern_function-extern-function-glcolor3ub-extern-function-glcolor3ub-r-as-int-g-as-int-b-as-int-from-opengl32-dll-symbol-glcolor3ub-returns-void-src-i-gl-ml-137097287"></a>
### glColor3ub

```ml
extern function glColor3ub(r as int, g as int, b as int) from "opengl32.dll" symbol "glColor3ub" returns void
```

Sets the opaque byte RGB color attached to following vertices.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `r` | `int` | — | `int` value supplied as r to `glColor3ub`. |
| `g` | `int` | — | `int` value supplied as g to `glColor3ub`. |
| `b` | `int` | — | Second input operand. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_gl.ml#L515)

<a id="extern_function-extern-function-glcolor4ub-extern-function-glcolor4ub-r-as-int-g-as-int-b-as-int-a-as-int-from-opengl32-dll-symbol-glcolor4ub-returns-void-src-i-gl-ml-1055684836"></a>
### glColor4ub

```ml
extern function glColor4ub(r as int, g as int, b as int, a as int) from "opengl32.dll" symbol "glColor4ub" returns void
```

Sets the byte RGBA color attached to following vertices.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `r` | `int` | — | `int` value supplied as r to `glColor4ub`. |
| `g` | `int` | — | `int` value supplied as g to `glColor4ub`. |
| `b` | `int` | — | Second input operand. |
| `a` | `int` | — | First input operand. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_gl.ml#L522)

<a id="extern_function-extern-function-glcolormask-extern-function-glcolormask-red-as-bool-green-as-bool-blue-as-bool-alpha-as-bool-from-opengl32-dll-symbol-glcolormask-returns-void-src-i-gl-ml-329153127"></a>
### glColorMask

```ml
extern function glColorMask(red as bool, green as bool, blue as bool, alpha as bool) from "opengl32.dll" symbol "glColorMask" returns void
```

Controls framebuffer writes independently for red, green, blue, and alpha channels.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `red` | `bool` | — | `bool` value supplied as red to `glColorMask`. |
| `green` | `bool` | — | `bool` value supplied as green to `glColorMask`. |
| `blue` | `bool` | — | `bool` value supplied as blue to `glColorMask`. |
| `alpha` | `bool` | — | `bool` value supplied as alpha to `glColorMask`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_gl.ml#L190)

<a id="extern_function-extern-function-glcolorpointer-extern-function-glcolorpointer-size-as-int-typ-as-u32-stride-as-int-pointer-as-bytes-from-opengl32-dll-symbol-glcolorpointer-returns-void-src-i-gl-ml-1964451419"></a>
### glColorPointer

```ml
extern function glColorPointer(size as int, typ as u32, stride as int, pointer as bytes) from "opengl32.dll" symbol "glColorPointer" returns void
```

Describes the component layout and storage of the active per-vertex color array.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `size` | `int` | — | Requested size in bytes or elements. |
| `typ` | `u32` | — | `u32` value supplied as typ to `glColorPointer`. |
| `stride` | `int` | — | `int` value supplied as stride to `glColorPointer`. |
| `pointer` | `bytes` | — | `bytes` value supplied as pointer to `glColorPointer`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_gl.ml#L293)

<a id="extern_function-extern-function-gldeletelists-extern-function-gldeletelists-list-as-u32-range-as-int-from-opengl32-dll-symbol-gldeletelists-returns-void-src-i-gl-ml-1367390910"></a>
### glDeleteLists

```ml
extern function glDeleteLists(list as u32, range as int) from "opengl32.dll" symbol "glDeleteLists" returns void
```

Releases a contiguous range of compiled OpenGL display lists.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `list` | `u32` | — | `u32` value supplied as list to `glDeleteLists`. |
| `range` | `int` | — | `int` value supplied as range to `glDeleteLists`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_gl.ml#L264)

<a id="extern_function-extern-function-gldepthfunc-extern-function-gldepthfunc-func-as-u32-from-opengl32-dll-symbol-gldepthfunc-returns-void-src-i-gl-ml-1452311737"></a>
### glDepthFunc

```ml
extern function glDepthFunc(func as u32) from "opengl32.dll" symbol "glDepthFunc" returns void
```

Selects the comparison applied between fragment depth and stored depth.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `func` | `u32` | — | `u32` value supplied as func to `glDepthFunc`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_gl.ml#L194)

<a id="extern_function-extern-function-gldepthmask-extern-function-gldepthmask-flag-as-bool-from-opengl32-dll-symbol-gldepthmask-returns-void-src-i-gl-ml-1564553685"></a>
### glDepthMask

```ml
extern function glDepthMask(flag as bool) from "opengl32.dll" symbol "glDepthMask" returns void
```

Controls whether rasterized fragments may write to the depth buffer.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `flag` | `bool` | — | `bool` value supplied as flag to `glDepthMask`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_gl.ml#L183)

<a id="extern_function-extern-function-gldisable-extern-function-gldisable-cap-as-u32-from-opengl32-dll-symbol-gldisable-returns-void-src-i-gl-ml-1412546248"></a>
### glDisable

```ml
extern function glDisable(cap as u32) from "opengl32.dll" symbol "glDisable" returns void
```

Disables one fixed-function OpenGL capability for subsequent draw calls.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `cap` | `u32` | — | `u32` value supplied as cap to `glDisable`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_gl.ml#L179)

<a id="extern_function-extern-function-gldisableclientstate-extern-function-gldisableclientstate-array-as-u32-from-opengl32-dll-symbol-gldisableclientstate-returns-void-src-i-gl-ml-944534917"></a>
### glDisableClientState

```ml
extern function glDisableClientState(array as u32) from "opengl32.dll" symbol "glDisableClientState" returns void
```

Disables one legacy vertex-array attribute source after array drawing.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `array` | `u32` | — | Array that supplies or receives the operation's values. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_gl.ml#L272)

<a id="extern_function-extern-function-gldrawarrays-extern-function-gldrawarrays-mode-as-u32-first-as-int-count-as-int-from-opengl32-dll-symbol-gldrawarrays-returns-void-src-i-gl-ml-88733060"></a>
### glDrawArrays

```ml
extern function glDrawArrays(mode as u32, first as int, count as int) from "opengl32.dll" symbol "glDrawArrays" returns void
```

Emits a primitive range from the currently enabled legacy client arrays.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `mode` | `u32` | — | `u32` value supplied as mode to `glDrawArrays`. |
| `first` | `int` | — | `int` value supplied as first to `glDrawArrays`. |
| `count` | `int` | — | Number of elements or iterations to process. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_gl.ml#L299)

<a id="extern_function-extern-function-glenable-extern-function-glenable-cap-as-u32-from-opengl32-dll-symbol-glenable-returns-void-src-i-gl-ml-998035575"></a>
### glEnable

```ml
extern function glEnable(cap as u32) from "opengl32.dll" symbol "glEnable" returns void
```

Enables one fixed-function OpenGL capability for subsequent draw calls.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `cap` | `u32` | — | `u32` value supplied as cap to `glEnable`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_gl.ml#L175)

<a id="extern_function-extern-function-glenableclientstate-extern-function-glenableclientstate-array-as-u32-from-opengl32-dll-symbol-glenableclientstate-returns-void-src-i-gl-ml-954177472"></a>
### glEnableClientState

```ml
extern function glEnableClientState(array as u32) from "opengl32.dll" symbol "glEnableClientState" returns void
```

Enables one legacy vertex-array attribute source for subsequent array draws.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `array` | `u32` | — | Array that supplies or receives the operation's values. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_gl.ml#L268)

<a id="extern_function-extern-function-glend-extern-function-glend-from-opengl32-dll-symbol-glend-returns-void-src-i-gl-ml-233472035"></a>
### glEnd

```ml
extern function glEnd() from "opengl32.dll" symbol "glEnd" returns void
```

Closes the active immediate-mode primitive stream and submits its vertices.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_gl.ml#L242)

<a id="extern_function-extern-function-glendlist-extern-function-glendlist-from-opengl32-dll-symbol-glendlist-returns-void-src-i-gl-ml-1290328187"></a>
### glEndList

```ml
extern function glEndList() from "opengl32.dll" symbol "glEndList" returns void
```

Finishes compilation of the currently open OpenGL display list.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_gl.ml#L255)

<a id="extern_function-extern-function-glfrustum-extern-function-glfrustum-left-as-double-right-as-double-bottom-as-double-top-as-double-znear-as-double-zfar-as-double-from-opengl32-dll-symbol-glfrustum-returns-void-src-i-gl-ml-2059130668"></a>
### glFrustum

```ml
extern function glFrustum(left as double, right as double, bottom as double, top as double, zNear as double, zFar as double) from "opengl32.dll" symbol "glFrustum" returns void
```

Multiplies the current matrix by an asymmetric perspective projection frustum.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `left` | `double` | — | `double` value supplied as left to `glFrustum`. |
| `right` | `double` | — | `double` value supplied as right to `glFrustum`. |
| `bottom` | `double` | — | `double` value supplied as bottom to `glFrustum`. |
| `top` | `double` | — | `double` value supplied as top to `glFrustum`. |
| `zNear` | `double` | — | `double` value supplied as z near to `glFrustum`. |
| `zFar` | `double` | — | `double` value supplied as z far to `glFrustum`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_gl.ml#L210)

<a id="extern_function-extern-function-glgenlists-extern-function-glgenlists-range-as-int-from-opengl32-dll-symbol-glgenlists-returns-u32-src-i-gl-ml-529223443"></a>
### glGenLists

```ml
extern function glGenLists(range as int) from "opengl32.dll" symbol "glGenLists" returns u32
```

Reserves a contiguous range of OpenGL display-list identifiers.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `range` | `int` | — | `int` value supplied as range to `glGenLists`. |


**Returns:** Result returned by the native `glGenLists` binding as `u32`.

[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_gl.ml#L247)

<a id="extern_function-extern-function-glgentextures-extern-function-glgentextures-n-as-int-textures-as-bytes-from-opengl32-dll-symbol-glgentextures-returns-void-src-i-gl-ml-421010534"></a>
### glGenTextures

```ml
extern function glGenTextures(n as int, textures as bytes) from "opengl32.dll" symbol "glGenTextures" returns void
```

Allocates caller-requested OpenGL texture object identifiers.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `n` | `int` | — | Number of values to process. |
| `textures` | `bytes` | — | `bytes` value supplied as textures to `glGenTextures`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_gl.ml#L537)

<a id="extern_function-extern-function-glloadidentity-extern-function-glloadidentity-from-opengl32-dll-symbol-glloadidentity-returns-void-src-i-gl-ml-110993714"></a>
### glLoadIdentity

```ml
extern function glLoadIdentity() from "opengl32.dll" symbol "glLoadIdentity" returns void
```

Replaces the current fixed-function matrix with the identity transform.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_gl.ml#L201)

<a id="extern_function-extern-function-glmatrixmode-extern-function-glmatrixmode-mode-as-u32-from-opengl32-dll-symbol-glmatrixmode-returns-void-src-i-gl-ml-2138727913"></a>
### glMatrixMode

```ml
extern function glMatrixMode(mode as u32) from "opengl32.dll" symbol "glMatrixMode" returns void
```

Selects the fixed-function matrix stack modified by following matrix operations.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `mode` | `u32` | — | `u32` value supplied as mode to `glMatrixMode`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_gl.ml#L198)

<a id="extern_function-extern-function-glnewlist-extern-function-glnewlist-list-as-u32-mode-as-u32-from-opengl32-dll-symbol-glnewlist-returns-void-src-i-gl-ml-1864465739"></a>
### glNewList

```ml
extern function glNewList(list as u32, mode as u32) from "opengl32.dll" symbol "glNewList" returns void
```

Begins compiling commands into a selected OpenGL display list.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `list` | `u32` | — | `u32` value supplied as list to `glNewList`. |
| `mode` | `u32` | — | `u32` value supplied as mode to `glNewList`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_gl.ml#L252)

<a id="extern_function-extern-function-glpixelstorei-extern-function-glpixelstorei-pname-as-u32-param-as-int-from-opengl32-dll-symbol-glpixelstorei-returns-void-src-i-gl-ml-1402900693"></a>
### glPixelStorei

```ml
extern function glPixelStorei(pname as u32, param as int) from "opengl32.dll" symbol "glPixelStorei" returns void
```

Configures byte-row alignment for texture uploads or framebuffer readback.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `pname` | `u32` | — | `u32` value supplied as pname to `glPixelStorei`. |
| `param` | `int` | — | `int` value supplied as param to `glPixelStorei`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_gl.ml#L565)

<a id="extern_function-extern-function-glpopmatrix-extern-function-glpopmatrix-from-opengl32-dll-symbol-glpopmatrix-returns-void-src-i-gl-ml-883787656"></a>
### glPopMatrix

```ml
extern function glPopMatrix() from "opengl32.dll" symbol "glPopMatrix" returns void
```

Restores the previous transform from the active fixed-function matrix stack.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_gl.ml#L235)

<a id="extern_function-extern-function-glpushmatrix-extern-function-glpushmatrix-from-opengl32-dll-symbol-glpushmatrix-returns-void-src-i-gl-ml-1725887247"></a>
### glPushMatrix

```ml
extern function glPushMatrix() from "opengl32.dll" symbol "glPushMatrix" returns void
```

Saves the current transform on the active fixed-function matrix stack.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_gl.ml#L232)

<a id="extern_function-extern-function-glreadbuffer-extern-function-glreadbuffer-mode-as-u32-from-opengl32-dll-symbol-glreadbuffer-returns-void-src-i-gl-ml-1355545065"></a>
### glReadBuffer

```ml
extern function glReadBuffer(mode as u32) from "opengl32.dll" symbol "glReadBuffer" returns void
```

Selects the color buffer used by subsequent framebuffer readback.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `mode` | `u32` | — | `u32` value supplied as mode to `glReadBuffer`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_gl.ml#L579)

<a id="extern_function-extern-function-glreadpixels-extern-function-glreadpixels-x-as-int-y-as-int-width-as-int-height-as-int-format-as-u32-typ-as-u32-pixels-as-bytes-from-opengl32-dll-symbol-glreadpixels-returns-void-src-i-gl-ml-492741849"></a>
### glReadPixels

```ml
extern function glReadPixels(x as int, y as int, width as int, height as int, format as u32, typ as u32, pixels as bytes) from "opengl32.dll" symbol "glReadPixels" returns void
```

Copies a framebuffer rectangle into caller-provided pixel storage with format conversion.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `x` | `int` | — | Horizontal map- or screen-space coordinate. |
| `y` | `int` | — | Vertical map- or screen-space coordinate. |
| `width` | `int` | — | Width of the target in pixels or map units. |
| `height` | `int` | — | Height of the target in pixels or map units. |
| `format` | `u32` | — | `u32` value supplied as format to `glReadPixels`. |
| `typ` | `u32` | — | `u32` value supplied as typ to `glReadPixels`. |
| `pixels` | `bytes` | — | `bytes` value supplied as pixels to `glReadPixels`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_gl.ml#L575)

<a id="extern_function-extern-function-glrotated-extern-function-glrotated-angle-as-double-x-as-double-y-as-double-z-as-double-from-opengl32-dll-symbol-glrotated-returns-void-src-i-gl-ml-1250150141"></a>
### glRotated

```ml
extern function glRotated(angle as double, x as double, y as double, z as double) from "opengl32.dll" symbol "glRotated" returns void
```

Multiplies the current matrix by a double-precision axis-angle rotation.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `angle` | `double` | — | Doom binary-angle measurement. |
| `x` | `double` | — | Horizontal map- or screen-space coordinate. |
| `y` | `double` | — | Vertical map- or screen-space coordinate. |
| `z` | `double` | — | Vertical world-space coordinate. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_gl.ml#L217)

<a id="extern_function-extern-function-glscaled-extern-function-glscaled-x-as-double-y-as-double-z-as-double-from-opengl32-dll-symbol-glscaled-returns-void-src-i-gl-ml-1619400882"></a>
### glScaled

```ml
extern function glScaled(x as double, y as double, z as double) from "opengl32.dll" symbol "glScaled" returns void
```

Multiplies the current matrix by independent double-precision axis scales.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `x` | `double` | — | Horizontal map- or screen-space coordinate. |
| `y` | `double` | — | Vertical map- or screen-space coordinate. |
| `z` | `double` | — | Vertical world-space coordinate. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_gl.ml#L229)

<a id="extern_function-extern-function-gltexcoord2d-extern-function-gltexcoord2d-s-as-double-t-as-double-from-opengl32-dll-symbol-gltexcoord2d-returns-void-src-i-gl-ml-661103277"></a>
### glTexCoord2d

```ml
extern function glTexCoord2d(s as double, t as double) from "opengl32.dll" symbol "glTexCoord2d" returns void
```

Sets the texture coordinate attached to following immediate-mode vertices.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `s` | `double` | — | `double` value supplied as s to `glTexCoord2d`. |
| `t` | `double` | — | `double` value supplied as t to `glTexCoord2d`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_gl.ml#L509)

<a id="extern_function-extern-function-gltexcoordpointer-extern-function-gltexcoordpointer-size-as-int-typ-as-u32-stride-as-int-pointer-as-bytes-from-opengl32-dll-symbol-gltexcoordpointer-returns-void-src-i-gl-ml-744331020"></a>
### glTexCoordPointer

```ml
extern function glTexCoordPointer(size as int, typ as u32, stride as int, pointer as bytes) from "opengl32.dll" symbol "glTexCoordPointer" returns void
```

Describes the component layout and storage of the active texture-coordinate array.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `size` | `int` | — | Requested size in bytes or elements. |
| `typ` | `u32` | — | `u32` value supplied as typ to `glTexCoordPointer`. |
| `stride` | `int` | — | `int` value supplied as stride to `glTexCoordPointer`. |
| `pointer` | `bytes` | — | `bytes` value supplied as pointer to `glTexCoordPointer`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_gl.ml#L286)

<a id="extern_function-extern-function-glteximage2d-extern-function-glteximage2d-target-as-u32-level-as-int-internalformat-as-int-width-as-int-height-as-int-border-as-int-format-as-u32-typ-as-u32-pixels-as-bytes-from-opengl32-dll-symbol-glteximage2d-returns-void-src-i-gl-ml-1562669725"></a>
### glTexImage2D

```ml
extern function glTexImage2D(target as u32, level as int, internalFormat as int, width as int, height as int, border as int, format as u32, typ as u32, pixels as bytes) from "opengl32.dll" symbol "glTexImage2D" returns void
```

Defines one two-dimensional texture image from caller-supplied pixel storage.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `target` | `u32` | — | `u32` value supplied as target to `glTexImage2D`. |
| `level` | `int` | — | `int` value supplied as level to `glTexImage2D`. |
| `internalFormat` | `int` | — | `int` value supplied as internal format to `glTexImage2D`. |
| `width` | `int` | — | Width of the target in pixels or map units. |
| `height` | `int` | — | Height of the target in pixels or map units. |
| `border` | `int` | — | `int` value supplied as border to `glTexImage2D`. |
| `format` | `u32` | — | `u32` value supplied as format to `glTexImage2D`. |
| `typ` | `u32` | — | `u32` value supplied as typ to `glTexImage2D`. |
| `pixels` | `bytes` | — | `bytes` value supplied as pixels to `glTexImage2D`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_gl.ml#L560)

<a id="extern_function-extern-function-gltexparameteri-extern-function-gltexparameteri-target-as-u32-pname-as-u32-param-as-int-from-opengl32-dll-symbol-gltexparameteri-returns-void-src-i-gl-ml-1103544453"></a>
### glTexParameteri

```ml
extern function glTexParameteri(target as u32, pname as u32, param as int) from "opengl32.dll" symbol "glTexParameteri" returns void
```

Sets an integer sampling or wrapping parameter on the current texture target.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `target` | `u32` | — | `u32` value supplied as target to `glTexParameteri`. |
| `pname` | `u32` | — | `u32` value supplied as pname to `glTexParameteri`. |
| `param` | `int` | — | `int` value supplied as param to `glTexParameteri`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_gl.ml#L548)

<a id="extern_function-extern-function-gltranslated-extern-function-gltranslated-x-as-double-y-as-double-z-as-double-from-opengl32-dll-symbol-gltranslated-returns-void-src-i-gl-ml-1770790130"></a>
### glTranslated

```ml
extern function glTranslated(x as double, y as double, z as double) from "opengl32.dll" symbol "glTranslated" returns void
```

Multiplies the current matrix by a double-precision translation.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `x` | `double` | — | Horizontal map- or screen-space coordinate. |
| `y` | `double` | — | Vertical map- or screen-space coordinate. |
| `z` | `double` | — | Vertical world-space coordinate. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_gl.ml#L223)

<a id="extern_function-extern-function-glvertex3d-extern-function-glvertex3d-x-as-double-y-as-double-z-as-double-from-opengl32-dll-symbol-glvertex3d-returns-void-src-i-gl-ml-1946175951"></a>
### glVertex3d

```ml
extern function glVertex3d(x as double, y as double, z as double) from "opengl32.dll" symbol "glVertex3d" returns void
```

Appends one double-precision position to the active immediate-mode primitive.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `x` | `double` | — | Horizontal map- or screen-space coordinate. |
| `y` | `double` | — | Vertical map- or screen-space coordinate. |
| `z` | `double` | — | Vertical world-space coordinate. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_gl.ml#L504)

<a id="extern_function-extern-function-glvertexpointer-extern-function-glvertexpointer-size-as-int-typ-as-u32-stride-as-int-pointer-as-bytes-from-opengl32-dll-symbol-glvertexpointer-returns-void-src-i-gl-ml-777689152"></a>
### glVertexPointer

```ml
extern function glVertexPointer(size as int, typ as u32, stride as int, pointer as bytes) from "opengl32.dll" symbol "glVertexPointer" returns void
```

Describes the component layout and storage of the active position array.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `size` | `int` | — | Requested size in bytes or elements. |
| `typ` | `u32` | — | `u32` value supplied as typ to `glVertexPointer`. |
| `stride` | `int` | — | `int` value supplied as stride to `glVertexPointer`. |
| `pointer` | `bytes` | — | `bytes` value supplied as pointer to `glVertexPointer`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_gl.ml#L279)

<a id="extern_function-extern-function-glviewport-extern-function-glviewport-x-as-int-y-as-int-width-as-int-height-as-int-from-opengl32-dll-symbol-glviewport-returns-void-src-i-gl-ml-1675326874"></a>
### glViewport

```ml
extern function glViewport(x as int, y as int, width as int, height as int) from "opengl32.dll" symbol "glViewport" returns void
```

Maps normalized device coordinates into the requested framebuffer rectangle.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `x` | `int` | — | Horizontal map- or screen-space coordinate. |
| `y` | `int` | — | Vertical map- or screen-space coordinate. |
| `width` | `int` | — | Width of the target in pixels or map units. |
| `height` | `int` | — | Height of the target in pixels or map units. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_gl.ml#L163)

<a id="global-global-igl-active-igl-active-src-i-gl-ml-1235937961"></a>
### igl_active

```ml
igl_active
```

Tracks whether igl active is active in the i gl subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_gl.ml#L585)

<a id="global-global-igl-base-palette-igl-base-palette-src-i-gl-ml-1108581231"></a>
### igl_base_palette

```ml
igl_base_palette
```

Holds the optional igl base palette resource used by the i gl subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_gl.ml#L601)

<a id="function-function-igl-begin2d-function-igl-begin2d-src-i-gl-ml-166738217"></a>
### IGL_Begin2D

```ml
function IGL_Begin2D()
```

Replaces the world matrices with identity clip-space transforms and disables depth testing for screen-aligned overlays.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_gl.ml#L1244)

<a id="function-function-igl-begin3d-function-igl-begin3d-src-i-gl-ml-1335136043"></a>
### IGL_Begin3D

```ml
function IGL_Begin3D()
```

Makes the context current, clears the frame, and installs the perspective projection and depth state for world rendering.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_gl.ml#L849)

<a id="global-global-igl-capture-rgba-igl-capture-rgba-src-i-gl-ml-2008763859"></a>
### igl_capture_rgba

```ml
igl_capture_rgba
```

Holds the optional igl capture rgba resource used by the i gl subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_gl.ml#L623)

<a id="function-function-igl-capturelogicalindexed-function-igl-capturelogicalindexed-dest-logicalw-logicalh-src-i-gl-ml-881340740"></a>
### IGL_CaptureLogicalIndexed

```ml
function IGL_CaptureLogicalIndexed(dest, logicalW, logicalH)
```

Reads back the GL framebuffer, downsamples it to logical dimensions, and quantizes each pixel to the nearest base-palette index.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `dest` | `dynamic` | — | Dest value supplied to `IGL_CaptureLogicalIndexed`. |
| `logicalW` | `dynamic` | — | Logical w value supplied to `IGL_CaptureLogicalIndexed`. |
| `logicalH` | `dynamic` | — | Logical h value supplied to `IGL_CaptureLogicalIndexed`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_gl.ml#L1005)

<a id="function-function-igl-capturergba-function-igl-capturergba-dest-outw-outh-front-src-i-gl-ml-1871880969"></a>
### IGL_CaptureRGBA

```ml
function IGL_CaptureRGBA(dest, outW, outH, front)
```

Reads the selected GL color buffer, flips its bottom-up rows, and nearest-neighbor resizes RGBA pixels into the destination.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `dest` | `dynamic` | — | Dest value supplied to `IGL_CaptureRGBA`. |
| `outW` | `dynamic` | — | Out w value supplied to `IGL_CaptureRGBA`. |
| `outH` | `dynamic` | — | Out h value supplied to `IGL_CaptureRGBA`. |
| `front` | `dynamic` | — | Front value supplied to `IGL_CaptureRGBA`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_gl.ml#L1049)

<a id="function-function-igl-configureframepacing-function-igl-configureframepacing-src-i-gl-ml-1246744489"></a>
### IGL_ConfigureFramePacing

```ml
function IGL_ConfigureFramePacing()
```

Enables VSync by default and installs a deterministic fallback limiter when needed.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_gl.ml#L675)

<a id="function-function-igl-createfuzzmasktexture-function-igl-createfuzzmasktexture-data-width-height-transparent-src-i-gl-ml-1676390126"></a>
### IGL_CreateFuzzMaskTexture

```ml
function IGL_CreateFuzzMaskTexture(data, width, height, transparent)
```

Creates a neutral alpha mask texture for Doom's shadow/fuzz sprites.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `data` | `dynamic` | — | Binary or structured data to process. |
| `width` | `dynamic` | — | Width of the target in pixels or map units. |
| `height` | `dynamic` | — | Height of the target in pixels or map units. |
| `transparent` | `dynamic` | — | Transparent value supplied to `IGL_CreateFuzzMaskTexture`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_gl.ml#L1149)

<a id="function-function-igl-createindexedtexture-function-igl-createindexedtexture-data-width-height-transparent-src-i-gl-ml-1809621044"></a>
### IGL_CreateIndexedTexture

```ml
function IGL_CreateIndexedTexture(data, width, height, transparent)
```

Creates an indexed OpenGL texture using default Doom wall/sprite wrapping.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `data` | `dynamic` | — | Binary or structured data to process. |
| `width` | `dynamic` | — | Width of the target in pixels or map units. |
| `height` | `dynamic` | — | Height of the target in pixels or map units. |
| `transparent` | `dynamic` | — | Transparent value supplied to `IGL_CreateIndexedTexture`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_gl.ml#L1203)

<a id="function-function-igl-createindexedtextureex-function-igl-createindexedtextureex-data-width-height-transparent-repeatwrap-src-i-gl-ml-1493595861"></a>
### IGL_CreateIndexedTextureEx

```ml
function IGL_CreateIndexedTextureEx(data, width, height, transparent, repeatWrap)
```

Creates an indexed OpenGL texture with explicit alpha and wrap handling.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `data` | `dynamic` | — | Binary or structured data to process. |
| `width` | `dynamic` | — | Width of the target in pixels or map units. |
| `height` | `dynamic` | — | Height of the target in pixels or map units. |
| `transparent` | `dynamic` | — | Transparent value supplied to `IGL_CreateIndexedTextureEx`. |
| `repeatWrap` | `dynamic` | — | Repeat wrap value supplied to `IGL_CreateIndexedTextureEx`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_gl.ml#L1101)

<a id="function-function-igl-drawindexedframe-function-igl-drawindexedframe-data-width-height-src-i-gl-ml-1616895490"></a>
### IGL_DrawIndexedFrame

```ml
function IGL_DrawIndexedFrame(data, width, height)
```

Expands a palette-indexed software frame to RGBA, uploads it to the frame texture, and covers the complete output surface.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `data` | `dynamic` | — | Binary or structured data to process. |
| `width` | `dynamic` | — | Width of the target in pixels or map units. |
| `height` | `dynamic` | — | Height of the target in pixels or map units. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_gl.ml#L1299)

<a id="function-function-igl-drawindexedoverlay-function-igl-drawindexedoverlay-data-mask-width-height-src-i-gl-ml-1507091410"></a>
### IGL_DrawIndexedOverlay

```ml
function IGL_DrawIndexedOverlay(data, mask, width, height)
```

Converts and draws masked indexed HUD pixels through the native dirty-rectangle path, falling back safely when no pixels are visible.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `data` | `dynamic` | — | Binary or structured data to process. |
| `mask` | `dynamic` | — | Mask value supplied to `IGL_DrawIndexedOverlay`. |
| `width` | `dynamic` | — | Width of the target in pixels or map units. |
| `height` | `dynamic` | — | Height of the target in pixels or map units. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_gl.ml#L1423)

<a id="function-function-igl-drawindexedoverlaylayers-function-igl-drawindexedoverlaylayers-logical-logicalmask-logicalminx-logicalminy-logicalmaxx-logicalmaxy-highres-highresmask-highresminx-highresminy-highresmaxx-highresmaxy-width-height-statusy-src-i-gl-ml-867658311"></a>
### IGL_DrawIndexedOverlayLayers

```ml
function IGL_DrawIndexedOverlayLayers(logical, logicalMask, logicalMinX, logicalMinY, logicalMaxX, logicalMaxY, highres, highresMask, highresMinX, highresMinY, highresMaxX, highresMaxY, width, height, statusY)
```

Converts logical HUD pixels and prepared high-resolution patches in native code.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `logical` | `dynamic` | — | Logical value supplied to `IGL_DrawIndexedOverlayLayers`. |
| `logicalMask` | `dynamic` | — | Logical mask value supplied to `IGL_DrawIndexedOverlayLayers`. |
| `logicalMinX` | `dynamic` | — | Horizontal coordinate or vector component represented by logical min x. |
| `logicalMinY` | `dynamic` | — | Vertical coordinate or vector component represented by logical min y. |
| `logicalMaxX` | `dynamic` | — | Horizontal coordinate or vector component represented by logical max x. |
| `logicalMaxY` | `dynamic` | — | Vertical coordinate or vector component represented by logical max y. |
| `highres` | `dynamic` | — | Highres value supplied to `IGL_DrawIndexedOverlayLayers`. |
| `highresMask` | `dynamic` | — | Highres mask value supplied to `IGL_DrawIndexedOverlayLayers`. |
| `highresMinX` | `dynamic` | — | Horizontal coordinate or vector component represented by highres min x. |
| `highresMinY` | `dynamic` | — | Vertical coordinate or vector component represented by highres min y. |
| `highresMaxX` | `dynamic` | — | Horizontal coordinate or vector component represented by highres max x. |
| `highresMaxY` | `dynamic` | — | Vertical coordinate or vector component represented by highres max y. |
| `width` | `dynamic` | — | Width of the target in pixels or map units. |
| `height` | `dynamic` | — | Height of the target in pixels or map units. |
| `statusY` | `dynamic` | — | Vertical coordinate or vector component represented by status y. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_gl.ml#L1455)

<a id="function-function-igl-drawpaletteflash-function-igl-drawpaletteflash-src-i-gl-ml-1541982853"></a>
### IGL_DrawPaletteFlash

```ml
function IGL_DrawPaletteFlash()
```

Blends the active damage, bonus, or radiation palette tint over the finished frame without affecting depth.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_gl.ml#L1399)

<a id="function-function-igl-drawrgbaframe-function-igl-drawrgbaframe-data-width-height-src-i-gl-ml-2039715250"></a>
### IGL_DrawRGBAFrame

```ml
function IGL_DrawRGBAFrame(data, width, height)
```

Uploads a validated RGBA frame directly to the reusable frame texture and presents it as a full-screen quad.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `data` | `dynamic` | — | Binary or structured data to process. |
| `width` | `dynamic` | — | Width of the target in pixels or map units. |
| `height` | `dynamic` | — | Height of the target in pixels or map units. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_gl.ml#L1361)

<a id="function-function-igl-drawtexturerect-function-igl-drawtexturerect-texid-x-y-width-height-flipped-src-i-gl-ml-1416428869"></a>
### IGL_DrawTextureRect

```ml
function IGL_DrawTextureRect(texid, x, y, width, height, flipped)
```

Draws a textured clip-space quad with caller-supplied bounds and resets the vertex color afterward.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `texid` | `dynamic` | — | Texid value supplied to `IGL_DrawTextureRect`. |
| `x` | `dynamic` | — | Horizontal map- or screen-space coordinate. |
| `y` | `dynamic` | — | Vertical map- or screen-space coordinate. |
| `width` | `dynamic` | — | Width of the target in pixels or map units. |
| `height` | `dynamic` | — | Height of the target in pixels or map units. |
| `flipped` | `dynamic` | — | Flipped value supplied to `IGL_DrawTextureRect`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_gl.ml#L1265)

<a id="global-global-igl-enabled-igl-enabled-src-i-gl-ml-162604023"></a>
### igl_enabled

```ml
igl_enabled
```

Tracks whether igl enabled is active in the i gl subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_gl.ml#L583)

<a id="function-function-igl-ensureframetexture-function-igl-ensureframetexture-src-i-gl-ml-1142756917"></a>
### IGL_EnsureFrameTexture

```ml
function IGL_EnsureFrameTexture()
```

Lazily allocates the reusable full-frame texture and configures pixel-exact sampling for software-frame presentation.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_gl.ml#L1226)

<a id="function-function-igl-ensureoverlaytexture-function-igl-ensureoverlaytexture-src-i-gl-ml-41255577"></a>
### IGL_EnsureOverlayTexture

```ml
function IGL_EnsureOverlayTexture()
```

Lazily allocates the reusable overlay texture and configures nearest filtering plus edge clamping.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_gl.ml#L1208)

<a id="global-global-igl-flash-a-igl-flash-a-src-i-gl-ml-488830675"></a>
### igl_flash_a

```ml
igl_flash_a
```

Tracks the mutable igl flash a value used by the i gl subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_gl.ml#L621)

<a id="global-global-igl-flash-b-igl-flash-b-src-i-gl-ml-1742978783"></a>
### igl_flash_b

```ml
igl_flash_b
```

Tracks the mutable igl flash b value used by the i gl subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_gl.ml#L619)

<a id="global-global-igl-flash-g-igl-flash-g-src-i-gl-ml-1457891443"></a>
### igl_flash_g

```ml
igl_flash_g
```

Tracks the mutable igl flash g value used by the i gl subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_gl.ml#L617)

<a id="global-global-igl-flash-r-igl-flash-r-src-i-gl-ml-56376383"></a>
### igl_flash_r

```ml
igl_flash_r
```

Tracks the mutable igl flash r value used by the i gl subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_gl.ml#L615)

<a id="global-global-igl-frame-limit-igl-frame-limit-src-i-gl-ml-2090510823"></a>
### igl_frame_limit

```ml
igl_frame_limit
```

Tracks the mutable igl frame limit value used by the i gl subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_gl.ml#L631)

<a id="global-global-igl-frame-ready-igl-frame-ready-src-i-gl-ml-63822095"></a>
### igl_frame_ready

```ml
igl_frame_ready
```

Tracks whether igl frame ready is active in the i gl subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_gl.ml#L589)

<a id="global-global-igl-frame-rgba-igl-frame-rgba-src-i-gl-ml-1100197377"></a>
### igl_frame_rgba

```ml
igl_frame_rgba
```

Holds the optional igl frame rgba resource used by the i gl subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_gl.ml#L613)

<a id="global-global-igl-frame-tex-igl-frame-tex-src-i-gl-ml-528127915"></a>
### igl_frame_tex

```ml
igl_frame_tex
```

Tracks the mutable igl frame tex value used by the i gl subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_gl.ml#L611)

<a id="function-function-igl-hasframeready-function-igl-hasframeready-src-i-gl-ml-924953487"></a>
### IGL_HasFrameReady

```ml
function IGL_HasFrameReady()
```

Reports whether an active OpenGL context currently has an unpresented completed frame.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_gl.ml#L881)

<a id="global-global-igl-hdc-igl-hdc-src-i-gl-ml-787111591"></a>
### igl_hdc

```ml
igl_hdc
```

Holds the optional igl hdc resource used by the i gl subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_gl.ml#L591)

<a id="global-global-igl-height-igl-height-src-i-gl-ml-2034894319"></a>
### igl_height

```ml
igl_height
```

Tracks the mutable igl height value used by the i gl subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_gl.ml#L597)

<a id="global-global-igl-hrc-igl-hrc-src-i-gl-ml-351481087"></a>
### igl_hrc

```ml
igl_hrc
```

Holds the optional igl hrc resource used by the i gl subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_gl.ml#L593)

<a id="function-function-igl-init-function-igl-init-hwnd-hdc-width-height-src-i-gl-ml-201721240"></a>
### IGL_Init

```ml
function IGL_Init(hwnd, hdc, width, height)
```

Initializes init state for the OpenGL backend system.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `hwnd` | `dynamic` | — | Hwnd value supplied to `IGL_Init`. |
| `hdc` | `dynamic` | — | Hdc value supplied to `IGL_Init`. |
| `width` | `dynamic` | — | Width of the target in pixels or map units. |
| `height` | `dynamic` | — | Height of the target in pixels or map units. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_gl.ml#L762)

<a id="function-function-igl-isactive-function-igl-isactive-src-i-gl-ml-2095981625"></a>
### IGL_IsActive

```ml
function IGL_IsActive()
```

Returns true when the OpenGL renderer is the active drawing path.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_gl.ml#L706)

<a id="function-function-igl-isavailable-function-igl-isavailable-src-i-gl-ml-855297625"></a>
### IGL_IsAvailable

```ml
function IGL_IsAvailable()
```

Returns true when an OpenGL context exists for optional rendering.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_gl.ml#L711)

<a id="function-function-igl-makecurrent-function-igl-makecurrent-src-i-gl-ml-537290857"></a>
### IGL_MakeCurrent

```ml
function IGL_MakeCurrent()
```

Ensures the WGL context is current before issuing OpenGL commands.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_gl.ml#L716)

<a id="function-function-igl-markframeready-function-igl-markframeready-src-i-gl-ml-1591438137"></a>
### IGL_MarkFrameReady

```ml
function IGL_MarkFrameReady()
```

Records that the active renderer completed a frame eligible for presentation.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_gl.ml#L875)

<a id="global-global-igl-nearest-cache-igl-nearest-cache-src-i-gl-ml-1363501591"></a>
### igl_nearest_cache

```ml
igl_nearest_cache
```

Stores the igl nearest cache collection used by the i gl subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_gl.ml#L625)

<a id="function-function-igl-nearestpaletteindex-function-igl-nearestpaletteindex-r-g-b-src-i-gl-ml-1698771178"></a>
### IGL_NearestPaletteIndex

```ml
function IGL_NearestPaletteIndex(r, g, b)
```

Finds the closest RGB entry in the active 256-color palette and caches the result by quantized source color.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `r` | `dynamic` | — | R value supplied to `IGL_NearestPaletteIndex`. |
| `g` | `dynamic` | — | G value supplied to `IGL_NearestPaletteIndex`. |
| `b` | `dynamic` | — | Second input operand. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_gl.ml#L964)

<a id="global-global-igl-overlay-rgba-igl-overlay-rgba-src-i-gl-ml-213899119"></a>
### igl_overlay_rgba

```ml
igl_overlay_rgba
```

Holds the optional igl overlay rgba resource used by the i gl subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_gl.ml#L609)

<a id="global-global-igl-overlay-tex-igl-overlay-tex-src-i-gl-ml-1515830731"></a>
### igl_overlay_tex

```ml
igl_overlay_tex
```

Tracks the mutable igl overlay tex value used by the i gl subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_gl.ml#L607)

<a id="global-global-igl-palette-igl-palette-src-i-gl-ml-124274479"></a>
### igl_palette

```ml
igl_palette
```

Holds the optional igl palette resource used by the i gl subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_gl.ml#L599)

<a id="global-global-igl-palette-revision-igl-palette-revision-src-i-gl-ml-122807995"></a>
### igl_palette_revision

```ml
igl_palette_revision
```

Tracks the mutable igl palette revision value used by the i gl subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_gl.ml#L605)

<a id="constant-constant-igl-pfd-doublebuffer-const-igl-pfd-doublebuffer-1-src-i-gl-ml-965558231"></a>
### IGL_PFD_DOUBLEBUFFER

```ml
const IGL_PFD_DOUBLEBUFFER = 1
```

Defines igl pfd doublebuffer for the i gl subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_gl.ml#L33)

<a id="constant-constant-igl-pfd-draw-to-window-const-igl-pfd-draw-to-window-4-src-i-gl-ml-351878744"></a>
### IGL_PFD_DRAW_TO_WINDOW

```ml
const IGL_PFD_DRAW_TO_WINDOW = 4
```

Defines igl pfd draw to window for the i gl subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_gl.ml#L29)

<a id="constant-constant-igl-pfd-main-plane-const-igl-pfd-main-plane-0-src-i-gl-ml-700745462"></a>
### IGL_PFD_MAIN_PLANE

```ml
const IGL_PFD_MAIN_PLANE = 0
```

Defines igl pfd main plane for the i gl subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_gl.ml#L37)

<a id="constant-constant-igl-pfd-support-opengl-const-igl-pfd-support-opengl-32-src-i-gl-ml-1025743707"></a>
### IGL_PFD_SUPPORT_OPENGL

```ml
const IGL_PFD_SUPPORT_OPENGL = 32
```

Defines igl pfd support opengl for the i gl subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_gl.ml#L31)

<a id="constant-constant-igl-pfd-type-rgba-const-igl-pfd-type-rgba-0-src-i-gl-ml-1731638196"></a>
### IGL_PFD_TYPE_RGBA

```ml
const IGL_PFD_TYPE_RGBA = 0
```

Defines igl pfd type rgba for the i gl subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_gl.ml#L35)

<a id="function-function-igl-readu32-inline-function-igl-readu32-buf-off-src-i-gl-ml-419493286"></a>
### IGL_ReadU32

```ml
inline function IGL_ReadU32(buf, off)
```

Decodes one unsigned 32-bit little-endian value from a byte buffer offset.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `buf` | `dynamic` | — | Buf value supplied to `IGL_ReadU32`. |
| `off` | `dynamic` | — | Zero-based byte or element offset. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_gl.ml#L658)

<a id="global-global-igl-renderer-enabled-igl-renderer-enabled-src-i-gl-ml-1801777663"></a>
### igl_renderer_enabled

```ml
igl_renderer_enabled
```

Tracks whether igl renderer enabled is active in the i gl subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_gl.ml#L587)

<a id="function-function-igl-resize-function-igl-resize-width-height-src-i-gl-ml-891394846"></a>
### IGL_Resize

```ml
function IGL_Resize(width, height)
```

Updates cached drawable dimensions and the OpenGL viewport, ignoring invalid or unchanged sizes.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `width` | `dynamic` | — | Width of the target in pixels or map units. |
| `height` | `dynamic` | — | Height of the target in pixels or map units. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_gl.ml#L836)

<a id="function-function-igl-setpalette-function-igl-setpalette-palette-src-i-gl-ml-1072310958"></a>
### IGL_SetPalette

```ml
function IGL_SetPalette(palette)
```

Copies a 256-color palette into render and conversion tables, invalidates nearest-color lookup, and bumps its revision.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `palette` | `dynamic` | — | Palette value supplied to `IGL_SetPalette`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_gl.ml#L909)

<a id="function-function-igl-setpaletteflash-function-igl-setpaletteflash-paletteindex-src-i-gl-ml-43342346"></a>
### IGL_SetPaletteFlash

```ml
function IGL_SetPaletteFlash(paletteIndex)
```

Converts Doom damage, bonus, and radiation palette indices into an RGBA fullscreen tint.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `paletteIndex` | `dynamic` | — | Index identifying palette. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_gl.ml#L926)

<a id="function-function-igl-setrendererenabled-function-igl-setrendererenabled-v-src-i-gl-ml-1211173921"></a>
### IGL_SetRendererEnabled

```ml
function IGL_SetRendererEnabled(v)
```

Selects whether the OpenGL renderer or the classic CPU renderer is active.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `v` | `dynamic` | — | Value consumed by the operation. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_gl.ml#L724)

<a id="function-function-igl-shutdown-function-igl-shutdown-src-i-gl-ml-1510068453"></a>
### IGL_Shutdown

```ml
function IGL_Shutdown()
```

Detaches and destroys the WGL context, clears backend handles, and returns renderer selection to classic software mode.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_gl.ml#L1481)

<a id="function-function-igl-swap-function-igl-swap-src-i-gl-ml-1133720761"></a>
### IGL_Swap

```ml
function IGL_Swap()
```

Paces a ready frame, presents it through SwapBuffers, marks the real presentation time, and clears readiness only on success.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_gl.ml#L887)

<a id="global-global-igl-texture-palette-igl-texture-palette-src-i-gl-ml-486420815"></a>
### igl_texture_palette

```ml
igl_texture_palette
```

Holds the optional igl texture palette resource used by the i gl subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_gl.ml#L603)

<a id="function-function-igl-togglerenderer-function-igl-togglerenderer-src-i-gl-ml-1253250857"></a>
### IGL_ToggleRenderer

```ml
function IGL_ToggleRenderer()
```

Toggles between the OpenGL and classic renderers when OpenGL is available.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_gl.ml#L752)

<a id="global-global-igl-vsync-active-igl-vsync-active-src-i-gl-ml-1663646897"></a>
### igl_vsync_active

```ml
igl_vsync_active
```

Tracks whether igl vsync active is active in the i gl subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_gl.ml#L629)

<a id="global-global-igl-vsync-requested-igl-vsync-requested-src-i-gl-ml-963375331"></a>
### igl_vsync_requested

```ml
igl_vsync_requested
```

Tracks whether igl vsync requested is active in the i gl subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_gl.ml#L627)

<a id="function-function-igl-wantsopengl-function-igl-wantsopengl-src-i-gl-ml-215185475"></a>
### IGL_WantsOpenGL

```ml
function IGL_WantsOpenGL()
```

Detects OpenGL command-line aliases, records the corresponding renderer request, and reports the selection.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_gl.ml#L663)

<a id="global-global-igl-width-igl-width-src-i-gl-ml-895438139"></a>
### igl_width

```ml
igl_width
```

Tracks the mutable igl width value used by the i gl subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_gl.ml#L595)

<a id="function-function-igl-writeu16-inline-function-igl-writeu16-buf-off-value-src-i-gl-ml-1426558611"></a>
### IGL_WriteU16

```ml
inline function IGL_WriteU16(buf, off, value)
```

Encodes the low 16 bits of a value at a byte-buffer offset in little-endian order.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `buf` | `dynamic` | — | Buf value supplied to `IGL_WriteU16`. |
| `off` | `dynamic` | — | Zero-based byte or element offset. |
| `value` | `dynamic` | — | Value consumed by the operation. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_gl.ml#L637)

<a id="function-function-igl-writeu32-inline-function-igl-writeu32-buf-off-value-src-i-gl-ml-1516734675"></a>
### IGL_WriteU32

```ml
inline function IGL_WriteU32(buf, off, value)
```

Encodes the low 32 bits of a value at a byte-buffer offset in little-endian order.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `buf` | `dynamic` | — | Buf value supplied to `IGL_WriteU32`. |
| `off` | `dynamic` | — | Zero-based byte or element offset. |
| `value` | `dynamic` | — | Value consumed by the operation. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_gl.ml#L647)

<a id="extern_function-extern-function-mgl-beginspritebatch-extern-function-mgl-beginspritebatch-lightdata-as-bytes-lightcount-as-int-viewx-as-double-viewy-as-double-rightx-as-double-rightz-as-double-worldscale-as-double-footlift-as-double-from-minidoomgl-dll-symbol-mgl-beginspritebatch-returns-bool-src-i-gl-ml-1518845440"></a>
### MGL_BeginSpriteBatch

```ml
extern function MGL_BeginSpriteBatch(lightData as bytes, lightCount as int, viewX as double, viewY as double, rightX as double, rightZ as double, worldScale as double, footLift as double) from "MiniDoomGL.dll" symbol "MGL_BeginSpriteBatch" returns bool
```

Opens a native world-sprite stream and copies its frame-local lighting state.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `lightData` | `bytes` | — | `bytes` value supplied as light data to `MGL_BeginSpriteBatch`. |
| `lightCount` | `int` | — | Number of light to process. |
| `viewX` | `double` | — | Horizontal coordinate or vector component represented by view x. |
| `viewY` | `double` | — | Vertical coordinate or vector component represented by view y. |
| `rightX` | `double` | — | Horizontal coordinate or vector component represented by right x. |
| `rightZ` | `double` | — | `double` value supplied as right z to `MGL_BeginSpriteBatch`. |
| `worldScale` | `double` | — | `double` value supplied as world scale to `MGL_BeginSpriteBatch`. |
| `footLift` | `double` | — | `double` value supplied as foot lift to `MGL_BeginSpriteBatch`. |


**Returns:** Result returned by the native `MGL_BeginSpriteBatch` binding as `bool`.

[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_gl.ml#L428)

<a id="extern_function-extern-function-mgl-createarraybuffer-extern-function-mgl-createarraybuffer-data-as-bytes-size-as-int-from-minidoomgl-dll-symbol-mgl-createarraybuffer-returns-u32-src-i-gl-ml-1693885291"></a>
### MGL_CreateArrayBuffer

```ml
extern function MGL_CreateArrayBuffer(data as bytes, size as int) from "MiniDoomGL.dll" symbol "MGL_CreateArrayBuffer" returns u32
```

Uploads raw bytes to an OpenGL array buffer through the MiniDoom GL helper.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `data` | `bytes` | — | Binary or structured data to process. |
| `size` | `int` | — | Requested size in bytes or elements. |


**Returns:** Result returned by the native `MGL_CreateArrayBuffer` binding as `u32`.

[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_gl.ml#L374)

<a id="extern_function-extern-function-mgl-createinterleavedgeombuffer-extern-function-mgl-createinterleavedgeombuffer-data-as-bytes-size-as-int-from-minidoomgl-dll-symbol-mgl-createinterleavedgeombuffer-returns-u32-src-i-gl-ml-1096736733"></a>
### MGL_CreateInterleavedGeomBuffer

```ml
extern function MGL_CreateInterleavedGeomBuffer(data as bytes, size as int) from "MiniDoomGL.dll" symbol "MGL_CreateInterleavedGeomBuffer" returns u32
```

Uploads MiniDoom fixed-point interleaved geometry as a float OpenGL VBO.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `data` | `bytes` | — | Binary or structured data to process. |
| `size` | `int` | — | Requested size in bytes or elements. |


**Returns:** Result returned by the native `MGL_CreateInterleavedGeomBuffer` binding as `u32`.

[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_gl.ml#L380)

<a id="extern_function-extern-function-mgl-deletearraybuffer-extern-function-mgl-deletearraybuffer-id-as-u32-from-minidoomgl-dll-symbol-mgl-deletearraybuffer-returns-void-src-i-gl-ml-1674654488"></a>
### MGL_DeleteArrayBuffer

```ml
extern function MGL_DeleteArrayBuffer(id as u32) from "MiniDoomGL.dll" symbol "MGL_DeleteArrayBuffer" returns void
```

Deletes one OpenGL array buffer created through the MiniDoom GL helper.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `id` | `u32` | — | `u32` value supplied as id to `MGL_DeleteArrayBuffer`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_gl.ml#L384)

<a id="extern_function-extern-function-mgl-drawarraybatch-extern-function-mgl-drawarraybatch-mode-as-u32-vertexbuffer-as-u32-texcoordbuffer-as-u32-colorbuffer-as-u32-count-as-int-from-minidoomgl-dll-symbol-mgl-drawarraybatch-returns-void-src-i-gl-ml-931224472"></a>
### MGL_DrawArrayBatch

```ml
extern function MGL_DrawArrayBatch(mode as u32, vertexBuffer as u32, texcoordBuffer as u32, colorBuffer as u32, count as int) from "MiniDoomGL.dll" symbol "MGL_DrawArrayBatch" returns void
```

Draws one VBO-backed vertex/texture/color array batch through the MiniDoom GL helper.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `mode` | `u32` | — | `u32` value supplied as mode to `MGL_DrawArrayBatch`. |
| `vertexBuffer` | `u32` | — | `u32` value supplied as vertex buffer to `MGL_DrawArrayBatch`. |
| `texcoordBuffer` | `u32` | — | `u32` value supplied as texcoord buffer to `MGL_DrawArrayBatch`. |
| `colorBuffer` | `u32` | — | `u32` value supplied as color buffer to `MGL_DrawArrayBatch`. |
| `count` | `int` | — | Number of elements or iterations to process. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_gl.ml#L392)

<a id="extern_function-extern-function-mgl-drawdynamiclightsurfaces-extern-function-mgl-drawdynamiclightsurfaces-geomdata-as-bytes-geomsize-as-int-lightdata-as-bytes-lightcount-as-int-from-minidoomgl-dll-symbol-mgl-drawdynamiclightsurfaces-returns-bool-src-i-gl-ml-1800692360"></a>
### MGL_DrawDynamicLightSurfaces

```ml
extern function MGL_DrawDynamicLightSurfaces(geomData as bytes, geomSize as int, lightData as bytes, lightCount as int) from "MiniDoomGL.dll" symbol "MGL_DrawDynamicLightSurfaces" returns bool
```

Draws additive dynamic light contribution on cached map geometry.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `geomData` | `bytes` | — | `bytes` value supplied as geom data to `MGL_DrawDynamicLightSurfaces`. |
| `geomSize` | `int` | — | `int` value supplied as geom size to `MGL_DrawDynamicLightSurfaces`. |
| `lightData` | `bytes` | — | `bytes` value supplied as light data to `MGL_DrawDynamicLightSurfaces`. |
| `lightCount` | `int` | — | Number of light to process. |


**Returns:** Result returned by the native `MGL_DrawDynamicLightSurfaces` binding as `bool`.

[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_gl.ml#L416)

<a id="extern_function-extern-function-mgl-drawindexedlogicaloverlay-extern-function-mgl-drawindexedlogicaloverlay-texid-as-u32-data-as-bytes-datasize-as-int-mask-as-bytes-masksize-as-int-palette-as-bytes-logicalw-as-int-logicalh-as-int-scale-as-int-statusy-as-int-minx-as-int-miny-as-int-maxx-as-int-maxy-as-int-from-minidoomgl-dll-symbol-mgl-drawindexedlogicaloverlay-returns-bool-src-i-gl-ml-146246077"></a>
### MGL_DrawIndexedLogicalOverlay

```ml
extern function MGL_DrawIndexedLogicalOverlay(texid as u32, data as bytes, dataSize as int, mask as bytes, maskSize as int, palette as bytes, logicalW as int, logicalH as int, scale as int, statusY as int, minX as int, minY as int, maxX as int, maxY as int) from "MiniDoomGL.dll" symbol "MGL_DrawIndexedLogicalOverlay" returns bool
```

Converts the scaled status area plus dirty logical-mask bounds to one minimal native RGBA overlay draw.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `texid` | `u32` | — | `u32` value supplied as texid to `MGL_DrawIndexedLogicalOverlay`. |
| `data` | `bytes` | — | Binary or structured data to process. |
| `dataSize` | `int` | — | `int` value supplied as data size to `MGL_DrawIndexedLogicalOverlay`. |
| `mask` | `bytes` | — | `bytes` value supplied as mask to `MGL_DrawIndexedLogicalOverlay`. |
| `maskSize` | `int` | — | `int` value supplied as mask size to `MGL_DrawIndexedLogicalOverlay`. |
| `palette` | `bytes` | — | `bytes` value supplied as palette to `MGL_DrawIndexedLogicalOverlay`. |
| `logicalW` | `int` | — | `int` value supplied as logical w to `MGL_DrawIndexedLogicalOverlay`. |
| `logicalH` | `int` | — | `int` value supplied as logical h to `MGL_DrawIndexedLogicalOverlay`. |
| `scale` | `int` | — | `int` value supplied as scale to `MGL_DrawIndexedLogicalOverlay`. |
| `statusY` | `int` | — | Vertical coordinate or vector component represented by status y. |
| `minX` | `int` | — | Horizontal coordinate or vector component represented by min x. |
| `minY` | `int` | — | Vertical coordinate or vector component represented by min y. |
| `maxX` | `int` | — | Horizontal coordinate or vector component represented by max x. |
| `maxY` | `int` | — | Vertical coordinate or vector component represented by max y. |


**Returns:** The converted the scaled status area plus dirty logical-mask bounds to one minimal native RGBA overlay draw.

[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_gl.ml#L483)

<a id="extern_function-extern-function-mgl-drawindexedoverlay-extern-function-mgl-drawindexedoverlay-texid-as-u32-data-as-bytes-mask-as-bytes-palette-as-bytes-width-as-int-height-as-int-from-minidoomgl-dll-symbol-mgl-drawindexedoverlay-returns-bool-src-i-gl-ml-1554565285"></a>
### MGL_DrawIndexedOverlay

```ml
extern function MGL_DrawIndexedOverlay(texid as u32, data as bytes, mask as bytes, palette as bytes, width as int, height as int) from "MiniDoomGL.dll" symbol "MGL_DrawIndexedOverlay" returns bool
```

Converts and draws an indexed overlay with transparency mask in native code.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `texid` | `u32` | — | `u32` value supplied as texid to `MGL_DrawIndexedOverlay`. |
| `data` | `bytes` | — | Binary or structured data to process. |
| `mask` | `bytes` | — | `bytes` value supplied as mask to `MGL_DrawIndexedOverlay`. |
| `palette` | `bytes` | — | `bytes` value supplied as palette to `MGL_DrawIndexedOverlay`. |
| `width` | `int` | — | Width of the target in pixels or map units. |
| `height` | `int` | — | Height of the target in pixels or map units. |


**Returns:** The converted and draws an indexed overlay with transparency mask in native code.

[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_gl.ml#L466)

<a id="extern_function-extern-function-mgl-drawindexedoverlayrect-extern-function-mgl-drawindexedoverlayrect-texid-as-u32-data-as-bytes-datasize-as-int-mask-as-bytes-masksize-as-int-palette-as-bytes-width-as-int-height-as-int-minx-as-int-miny-as-int-maxx-as-int-maxy-as-int-from-minidoomgl-dll-symbol-mgl-drawindexedoverlayrect-returns-bool-src-i-gl-ml-1601216785"></a>
### MGL_DrawIndexedOverlayRect

```ml
extern function MGL_DrawIndexedOverlayRect(texid as u32, data as bytes, dataSize as int, mask as bytes, maskSize as int, palette as bytes, width as int, height as int, minX as int, minY as int, maxX as int, maxY as int) from "MiniDoomGL.dll" symbol "MGL_DrawIndexedOverlayRect" returns bool
```

Converts and draws only the caller-specified dirty rectangle of a masked indexed overlay.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `texid` | `u32` | — | `u32` value supplied as texid to `MGL_DrawIndexedOverlayRect`. |
| `data` | `bytes` | — | Binary or structured data to process. |
| `dataSize` | `int` | — | `int` value supplied as data size to `MGL_DrawIndexedOverlayRect`. |
| `mask` | `bytes` | — | `bytes` value supplied as mask to `MGL_DrawIndexedOverlayRect`. |
| `maskSize` | `int` | — | `int` value supplied as mask size to `MGL_DrawIndexedOverlayRect`. |
| `palette` | `bytes` | — | `bytes` value supplied as palette to `MGL_DrawIndexedOverlayRect`. |
| `width` | `int` | — | Width of the target in pixels or map units. |
| `height` | `int` | — | Height of the target in pixels or map units. |
| `minX` | `int` | — | Horizontal coordinate or vector component represented by min x. |
| `minY` | `int` | — | Vertical coordinate or vector component represented by min y. |
| `maxX` | `int` | — | Horizontal coordinate or vector component represented by max x. |
| `maxY` | `int` | — | Vertical coordinate or vector component represented by max y. |


**Returns:** The converted and draws only the caller-specified dirty rectangle of a masked indexed overlay.

[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_gl.ml#L498)

<a id="extern_function-extern-function-mgl-drawinterleavedbatch-extern-function-mgl-drawinterleavedbatch-mode-as-u32-buffer-as-u32-count-as-int-from-minidoomgl-dll-symbol-mgl-drawinterleavedbatch-returns-void-src-i-gl-ml-1503109473"></a>
### MGL_DrawInterleavedBatch

```ml
extern function MGL_DrawInterleavedBatch(mode as u32, buffer as u32, count as int) from "MiniDoomGL.dll" symbol "MGL_DrawInterleavedBatch" returns void
```

Draws one VBO-backed interleaved vertex/texture/color batch through the MiniDoom GL helper.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `mode` | `u32` | — | `u32` value supplied as mode to `MGL_DrawInterleavedBatch`. |
| `buffer` | `u32` | — | Buffer that supplies or receives data. |
| `count` | `int` | — | Number of elements or iterations to process. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_gl.ml#L398)

<a id="extern_function-extern-function-mgl-drawspriterecords-extern-function-mgl-drawspriterecords-records-as-bytes-recordssize-as-int-recordcount-as-int-from-minidoomgl-dll-symbol-mgl-drawspriterecords-returns-bool-src-i-gl-ml-72428976"></a>
### MGL_DrawSpriteRecords

```ml
extern function MGL_DrawSpriteRecords(records as bytes, recordsSize as int, recordCount as int) from "MiniDoomGL.dll" symbol "MGL_DrawSpriteRecords" returns bool
```

Validates and renders a complete packed sprite-record buffer through one native call.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `records` | `bytes` | — | `bytes` value supplied as records to `MGL_DrawSpriteRecords`. |
| `recordsSize` | `int` | — | `int` value supplied as records size to `MGL_DrawSpriteRecords`. |
| `recordCount` | `int` | — | Number of record to process. |


**Returns:** Result returned by the native `MGL_DrawSpriteRecords` binding as `bool`.

[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_gl.ml#L446)

<a id="extern_function-extern-function-mgl-drawvisiblegeombatches-extern-function-mgl-drawvisiblegeombatches-mode-as-u32-records-as-bytes-recordcount-as-int-viewx-as-double-viewy-as-double-viewyaw-as-double-from-minidoomgl-dll-symbol-mgl-drawvisiblegeombatches-returns-bool-src-i-gl-ml-1853566622"></a>
### MGL_DrawVisibleGeomBatches

```ml
extern function MGL_DrawVisibleGeomBatches(mode as u32, records as bytes, recordCount as int, viewX as double, viewY as double, viewYaw as double) from "MiniDoomGL.dll" symbol "MGL_DrawVisibleGeomBatches" returns bool
```

Draws and culls a native batch-record buffer in the MiniDoom GL helper.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `mode` | `u32` | — | `u32` value supplied as mode to `MGL_DrawVisibleGeomBatches`. |
| `records` | `bytes` | — | `bytes` value supplied as records to `MGL_DrawVisibleGeomBatches`. |
| `recordCount` | `int` | — | Number of record to process. |
| `viewX` | `double` | — | Horizontal coordinate or vector component represented by view x. |
| `viewY` | `double` | — | Vertical coordinate or vector component represented by view y. |
| `viewYaw` | `double` | — | `double` value supplied as view yaw to `MGL_DrawVisibleGeomBatches`. |


**Returns:** Result returned by the native `MGL_DrawVisibleGeomBatches` binding as `bool`.

[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_gl.ml#L408)

<a id="extern_function-extern-function-mgl-endspritebatch-extern-function-mgl-endspritebatch-from-minidoomgl-dll-symbol-mgl-endspritebatch-returns-void-src-i-gl-ml-1266384537"></a>
### MGL_EndSpriteBatch

```ml
extern function MGL_EndSpriteBatch() from "MiniDoomGL.dll" symbol "MGL_EndSpriteBatch" returns void
```

Closes the native sprite stream and restores fixed-function state for subsequent renderer passes.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_gl.ml#L448)

<a id="extern_function-extern-function-mgl-expandindexed8-extern-function-mgl-expandindexed8-source-as-bytes-sourcebytes-as-int-dest-as-bytes-destbytes-as-int-palette-as-bytes-palettebytes-as-int-pixels-as-int-from-minidoomgl-dll-symbol-mgl-expandindexed8-returns-bool-src-i-gl-ml-956223495"></a>
### MGL_ExpandIndexed8

```ml
extern function MGL_ExpandIndexed8(source as bytes, sourceBytes as int, dest as bytes, destBytes as int, palette as bytes, paletteBytes as int, pixels as int) from "MiniDoomGL.dll" symbol "MGL_ExpandIndexed8" returns bool
```

Expands an indexed software frame through its RGB palette into opaque RGBA bytes in native code.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `source` | `bytes` | — | Source value or buffer. |
| `sourceBytes` | `int` | — | `int` value supplied as source bytes to `MGL_ExpandIndexed8`. |
| `dest` | `bytes` | — | `bytes` value supplied as dest to `MGL_ExpandIndexed8`. |
| `destBytes` | `int` | — | `int` value supplied as dest bytes to `MGL_ExpandIndexed8`. |
| `palette` | `bytes` | — | `bytes` value supplied as palette to `MGL_ExpandIndexed8`. |
| `paletteBytes` | `int` | — | `int` value supplied as palette bytes to `MGL_ExpandIndexed8`. |
| `pixels` | `int` | — | `int` value supplied as pixels to `MGL_ExpandIndexed8`. |


**Returns:** Result returned by the native `MGL_ExpandIndexed8` binding as `bool`.

[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_gl.ml#L368)

<a id="extern_function-extern-function-mgl-framepace-extern-function-mgl-framepace-targetfps-as-int-leadus-as-int-from-minidoomgl-dll-symbol-mgl-framepace-returns-void-src-i-gl-ml-1989174047"></a>
### MGL_FramePace

```ml
extern function MGL_FramePace(targetFps as int, leadUs as int) from "MiniDoomGL.dll" symbol "MGL_FramePace" returns void
```

Applies a native high-resolution fallback frame limit when VSync is unavailable or disabled.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `targetFps` | `int` | — | `int` value supplied as target fps to `MGL_FramePace`. |
| `leadUs` | `int` | — | `int` value supplied as lead us to `MGL_FramePace`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_gl.ml#L317)

<a id="extern_function-extern-function-mgl-framepacemark-extern-function-mgl-framepacemark-from-minidoomgl-dll-symbol-mgl-framepacemark-returns-void-src-i-gl-ml-1697800774"></a>
### MGL_FramePaceMark

```ml
extern function MGL_FramePaceMark() from "MiniDoomGL.dll" symbol "MGL_FramePaceMark" returns void
```

Marks the actual completion time of a successful presentation as the anchor for the next native pacing deadline.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_gl.ml#L320)

<a id="extern_function-extern-function-mgl-getlastdrawnbatches-extern-function-mgl-getlastdrawnbatches-from-minidoomgl-dll-symbol-mgl-getlastdrawnbatches-returns-int-src-i-gl-ml-1093581402"></a>
### MGL_GetLastDrawnBatches

```ml
extern function MGL_GetLastDrawnBatches() from "MiniDoomGL.dll" symbol "MGL_GetLastDrawnBatches" returns int
```

Returns the number of batches drawn by the last native batch-record draw.


**Returns:** The number of batches drawn by the last native batch-record draw.

[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_gl.ml#L452)

<a id="extern_function-extern-function-mgl-getlastdrawnvertices-extern-function-mgl-getlastdrawnvertices-from-minidoomgl-dll-symbol-mgl-getlastdrawnvertices-returns-int-src-i-gl-ml-1123428929"></a>
### MGL_GetLastDrawnVertices

```ml
extern function MGL_GetLastDrawnVertices() from "MiniDoomGL.dll" symbol "MGL_GetLastDrawnVertices" returns int
```

Returns the number of vertices drawn by the last native batch-record draw.


**Returns:** The number of vertices drawn by the last native batch-record draw.

[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_gl.ml#L456)

<a id="extern_function-extern-function-mgl-initvbo-extern-function-mgl-initvbo-from-minidoomgl-dll-symbol-mgl-initvbo-returns-bool-src-i-gl-ml-1048494860"></a>
### MGL_InitVBO

```ml
extern function MGL_InitVBO() from "MiniDoomGL.dll" symbol "MGL_InitVBO" returns bool
```

Initializes optional MiniDoom OpenGL VBO helper functions for static geometry batches.


**Returns:** Result returned by the native `MGL_InitVBO` binding as `bool`.

[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_gl.ml#L303)

<a id="extern_function-extern-function-mgl-rastercolumn8-extern-function-mgl-rastercolumn8-dest-as-bytes-destbytes-as-int-destindex-as-int-deststride-as-int-count-as-int-source-as-bytes-sourcebytes-as-int-sourceoffset-as-int-sourcelength-as-int-colormap-as-bytes-colormaplength-as-int-frac-as-int-fracstep-as-int-sourceclamp-as-int-from-minidoomgl-dll-symbol-mgl-rastercolumn8-returns-bool-src-i-gl-ml-1563224753"></a>
### MGL_RasterColumn8

```ml
extern function MGL_RasterColumn8(dest as bytes, destBytes as int, destIndex as int, destStride as int, count as int, source as bytes, sourceBytes as int, sourceOffset as int, sourceLength as int, colormap as bytes, colormapLength as int, frac as int, fracStep as int, sourceClamp as int) from "MiniDoomGL.dll" symbol "MGL_RasterColumn8" returns bool
```

Rasterizes one clipped 8-bit software column in native code and rejects malformed buffer ranges.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `dest` | `bytes` | — | `bytes` value supplied as dest to `MGL_RasterColumn8`. |
| `destBytes` | `int` | — | `int` value supplied as dest bytes to `MGL_RasterColumn8`. |
| `destIndex` | `int` | — | Index identifying dest. |
| `destStride` | `int` | — | `int` value supplied as dest stride to `MGL_RasterColumn8`. |
| `count` | `int` | — | Number of elements or iterations to process. |
| `source` | `bytes` | — | Source value or buffer. |
| `sourceBytes` | `int` | — | `int` value supplied as source bytes to `MGL_RasterColumn8`. |
| `sourceOffset` | `int` | — | `int` value supplied as source offset to `MGL_RasterColumn8`. |
| `sourceLength` | `int` | — | `int` value supplied as source length to `MGL_RasterColumn8`. |
| `colormap` | `bytes` | — | `bytes` value supplied as colormap to `MGL_RasterColumn8`. |
| `colormapLength` | `int` | — | `int` value supplied as colormap length to `MGL_RasterColumn8`. |
| `frac` | `int` | — | `int` value supplied as frac to `MGL_RasterColumn8`. |
| `fracStep` | `int` | — | `int` value supplied as frac step to `MGL_RasterColumn8`. |
| `sourceClamp` | `int` | — | `int` value supplied as source clamp to `MGL_RasterColumn8`. |


**Returns:** Result returned by the native `MGL_RasterColumn8` binding as `bool`.

[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_gl.ml#L338)

<a id="extern_function-extern-function-mgl-rasterspan8-extern-function-mgl-rasterspan8-dest-as-bytes-destbytes-as-int-destindex-as-int-count-as-int-source-as-bytes-sourcebytes-as-int-colormap-as-bytes-colormaplength-as-int-sourcewidth-as-int-sourceheight-as-int-xfrac-as-int-yfrac-as-int-xstep-as-int-ystep-as-int-from-minidoomgl-dll-symbol-mgl-rasterspan8-returns-bool-src-i-gl-ml-141635052"></a>
### MGL_RasterSpan8

```ml
extern function MGL_RasterSpan8(dest as bytes, destBytes as int, destIndex as int, count as int, source as bytes, sourceBytes as int, colormap as bytes, colormapLength as int, sourceWidth as int, sourceHeight as int, xFrac as int, yFrac as int, xStep as int, yStep as int) from "MiniDoomGL.dll" symbol "MGL_RasterSpan8" returns bool
```

Rasterizes one clipped 8-bit software floor or ceiling span in native code and rejects malformed buffer ranges.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `dest` | `bytes` | — | `bytes` value supplied as dest to `MGL_RasterSpan8`. |
| `destBytes` | `int` | — | `int` value supplied as dest bytes to `MGL_RasterSpan8`. |
| `destIndex` | `int` | — | Index identifying dest. |
| `count` | `int` | — | Number of elements or iterations to process. |
| `source` | `bytes` | — | Source value or buffer. |
| `sourceBytes` | `int` | — | `int` value supplied as source bytes to `MGL_RasterSpan8`. |
| `colormap` | `bytes` | — | `bytes` value supplied as colormap to `MGL_RasterSpan8`. |
| `colormapLength` | `int` | — | `int` value supplied as colormap length to `MGL_RasterSpan8`. |
| `sourceWidth` | `int` | — | Width of source width in pixels or map units. |
| `sourceHeight` | `int` | — | Height of source height in pixels or map units. |
| `xFrac` | `int` | — | `int` value supplied as x frac to `MGL_RasterSpan8`. |
| `yFrac` | `int` | — | `int` value supplied as y frac to `MGL_RasterSpan8`. |
| `xStep` | `int` | — | `int` value supplied as x step to `MGL_RasterSpan8`. |
| `yStep` | `int` | — | `int` value supplied as y step to `MGL_RasterSpan8`. |


**Returns:** Result returned by the native `MGL_RasterSpan8` binding as `bool`.

[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_gl.ml#L357)

<a id="extern_function-extern-function-mgl-setswapinterval-extern-function-mgl-setswapinterval-interval-as-int-from-minidoomgl-dll-symbol-mgl-setswapinterval-returns-bool-src-i-gl-ml-590116603"></a>
### MGL_SetSwapInterval

```ml
extern function MGL_SetSwapInterval(interval as int) from "MiniDoomGL.dll" symbol "MGL_SetSwapInterval" returns bool
```

Sets the WGL swap interval when the driver exposes wglSwapIntervalEXT.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `interval` | `int` | — | `int` value supplied as interval to `MGL_SetSwapInterval`. |


**Returns:** Result returned by the native `MGL_SetSwapInterval` binding as `bool`.

[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_gl.ml#L308)

<a id="extern_function-extern-function-mgl-submitsprite-extern-function-mgl-submitsprite-texid-as-u32-flags-as-int-baselight-as-int-fixedx-as-int-fixedy-as-int-fixedz-as-int-width-as-int-height-as-int-yoffset-as-int-from-minidoomgl-dll-symbol-mgl-submitsprite-returns-void-src-i-gl-ml-923199778"></a>
### MGL_SubmitSprite

```ml
extern function MGL_SubmitSprite(texid as u32, flags as int, baseLight as int, fixedX as int, fixedY as int, fixedZ as int, width as int, height as int, yOffset as int) from "MiniDoomGL.dll" symbol "MGL_SubmitSprite" returns void
```

Streams one packed world sprite into the active native batch, including lighting, flip, and fuzz-shadow flags.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `texid` | `u32` | — | `u32` value supplied as texid to `MGL_SubmitSprite`. |
| `flags` | `int` | — | Bit flags that control the operation. |
| `baseLight` | `int` | — | `int` value supplied as base light to `MGL_SubmitSprite`. |
| `fixedX` | `int` | — | Horizontal coordinate or vector component represented by fixed x. |
| `fixedY` | `int` | — | Vertical coordinate or vector component represented by fixed y. |
| `fixedZ` | `int` | — | `int` value supplied as fixed z to `MGL_SubmitSprite`. |
| `width` | `int` | — | Width of the target in pixels or map units. |
| `height` | `int` | — | Height of the target in pixels or map units. |
| `yOffset` | `int` | — | `int` value supplied as y offset to `MGL_SubmitSprite`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_gl.ml#L440)

<a id="extern_function-extern-function-mgl-timemicroseconds-extern-function-mgl-timemicroseconds-from-minidoomgl-dll-symbol-mgl-timemicroseconds-returns-i64-src-i-gl-ml-1232580602"></a>
### MGL_TimeMicroseconds

```ml
extern function MGL_TimeMicroseconds() from "MiniDoomGL.dll" symbol "MGL_TimeMicroseconds" returns i64
```

Reads the native high-resolution monotonic timer used by profiling and frame pacing.


**Returns:** The requested the native high-resolution monotonic timer used by profiling and frame pacing.

[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_gl.ml#L312)

<a id="extern_function-extern-function-setpixelformat-extern-function-setpixelformat-hdc-as-ptr-format-as-int-pfd-as-bytes-from-gdi32-dll-symbol-setpixelformat-returns-bool-src-i-gl-ml-865383219"></a>
### SetPixelFormat

```ml
extern function SetPixelFormat(hdc as ptr, format as int, pfd as bytes) from "gdi32.dll" symbol "SetPixelFormat" returns bool
```

Installs the selected immutable pixel format on the window device context before WGL context creation.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `hdc` | `ptr` | — | `ptr` value supplied as hdc to `SetPixelFormat`. |
| `format` | `int` | — | `int` value supplied as format to `SetPixelFormat`. |
| `pfd` | `bytes` | — | `bytes` value supplied as pfd to `SetPixelFormat`. |


**Returns:** Result returned by the native `SetPixelFormat` binding as `bool`.

[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_gl.ml#L133)

<a id="extern_function-extern-function-swapbuffers-extern-function-swapbuffers-hdc-as-ptr-from-gdi32-dll-symbol-swapbuffers-returns-bool-src-i-gl-ml-482956499"></a>
### SwapBuffers

```ml
extern function SwapBuffers(hdc as ptr) from "gdi32.dll" symbol "SwapBuffers" returns bool
```

Presents the device context's back buffer to the window after a rendered frame.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `hdc` | `ptr` | — | `ptr` value supplied as hdc to `SwapBuffers`. |


**Returns:** Result returned by the native `SwapBuffers` binding as `bool`.

[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_gl.ml#L138)

<a id="extern_function-extern-function-wglcreatecontext-extern-function-wglcreatecontext-hdc-as-ptr-from-opengl32-dll-symbol-wglcreatecontext-returns-ptr-src-i-gl-ml-813960023"></a>
### wglCreateContext

```ml
extern function wglCreateContext(hdc as ptr) from "opengl32.dll" symbol "wglCreateContext" returns ptr
```

Creates a legacy WGL rendering context for the configured window device context.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `hdc` | `ptr` | — | `ptr` value supplied as hdc to `wglCreateContext`. |


**Returns:** The resulting legacy WGL rendering context for the configured window device context.

[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_gl.ml#L144)

<a id="extern_function-extern-function-wgldeletecontext-extern-function-wgldeletecontext-hglrc-as-ptr-from-opengl32-dll-symbol-wgldeletecontext-returns-bool-src-i-gl-ml-737491873"></a>
### wglDeleteContext

```ml
extern function wglDeleteContext(hglrc as ptr) from "opengl32.dll" symbol "wglDeleteContext" returns bool
```

Releases a WGL rendering context after it has been detached from the calling thread.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `hglrc` | `ptr` | — | `ptr` value supplied as hglrc to `wglDeleteContext`. |


**Returns:** Result returned by the native `wglDeleteContext` binding as `bool`.

[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_gl.ml#L155)

<a id="extern_function-extern-function-wglmakecurrent-extern-function-wglmakecurrent-hdc-as-ptr-hglrc-as-ptr-from-opengl32-dll-symbol-wglmakecurrent-returns-bool-src-i-gl-ml-1915843983"></a>
### wglMakeCurrent

```ml
extern function wglMakeCurrent(hdc as ptr, hglrc as ptr) from "opengl32.dll" symbol "wglMakeCurrent" returns bool
```

Associates a WGL context with the calling thread and its window device context.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `hdc` | `ptr` | — | `ptr` value supplied as hdc to `wglMakeCurrent`. |
| `hglrc` | `ptr` | — | `ptr` value supplied as hglrc to `wglMakeCurrent`. |


**Returns:** Result returned by the native `wglMakeCurrent` binding as `bool`.

[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_gl.ml#L150)
