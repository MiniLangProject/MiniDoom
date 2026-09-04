# `src/r_upscaled.ml`

[Home](README.md) · [Files](Files.md)

Loads optional MiniDoom upscaled graphics packages and shared render-scale settings.

Package: [`(global)`](Package-global-1952375359.md)

Reachable from entry: **yes**

## Imports

- `m_argv.ml` → [src/m_argv.ml](File-src-m-argv-ml-728984635.md)
- `r_renderer.ml` → [src/r_renderer.ml](File-src-r-renderer-ml-72894217.md)
- `std/fs.ml` as `fs` → `../MiniLangCompilerOptimization/MiniLangCompilerPy/std/fs.ml` — external dependency
- `std/math.ml` → `../MiniLangCompilerOptimization/MiniLangCompilerPy/std/math.ml` — external dependency

## Declarations

<a id="constant-constant-rh-magic2-const-rh-magic2-72-src-r-upscaled-ml-955979390"></a>
### RH_MAGIC2

```ml
const RH_MAGIC2 = 72
```

Defines rh magic2 for the r upscaled subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_upscaled.ml#L34)

<a id="constant-constant-rh-magic3-const-rh-magic3-68-src-r-upscaled-ml-426900997"></a>
### RH_MAGIC3

```ml
const RH_MAGIC3 = 68
```

Defines rh magic3 for the r upscaled subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_upscaled.ml#L36)

<a id="function-function-ru-argvalue-function-ru-argvalue-flag-src-r-upscaled-ml-1999963472"></a>
### RU_ArgValue

```ml
function RU_ArgValue(flag)
```

Reads the value after a command-line flag.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `flag` | `dynamic` | — | Flag value supplied to `RU_ArgValue`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_upscaled.ml#L159)

<a id="function-function-ru-clampscale-inline-function-ru-clampscale-v-src-r-upscaled-ml-627193647"></a>
### RU_ClampScale

```ml
inline function RU_ClampScale(v)
```

Keeps renderer scale inside the supported range.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `v` | `dynamic` | — | Value consumed by the operation. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_upscaled.ml#L116)

<a id="global-global-ru-enabled-ru-enabled-src-r-upscaled-ml-684569312"></a>
### ru_enabled

```ml
ru_enabled
```

Tracks whether ru enabled is active in the r upscaled subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_upscaled.ml#L70)

<a id="global-global-ru-entries-ru-entries-src-r-upscaled-ml-1336487986"></a>
### ru_entries

```ml
ru_entries
```

Stores the ru entries collection used by the r upscaled subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_upscaled.ml#L78)

- [ru_entry_t](Type-ru-entry-t-1123078744.md) — struct
<a id="function-function-ru-findentry-function-ru-findentry-kind-name-src-r-upscaled-ml-545799495"></a>
### RU_FindEntry

```ml
function RU_FindEntry(kind, name)
```

Finds an entry by kind and Doom name.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `kind` | `dynamic` | — | Kind value supplied to `RU_FindEntry`. |
| `name` | `dynamic` | — | Resource or object name to resolve. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_upscaled.ml#L330)

<a id="function-function-ru-findpackagepath-function-ru-findpackagepath-iwadpath-src-r-upscaled-ml-1233288558"></a>
### RU_FindPackagePath

```ml
function RU_FindPackagePath(iwadPath)
```

Resolves explicit or automatic upscaled package path.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `iwadPath` | `dynamic` | — | Iwad path value supplied to `RU_FindPackagePath`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_upscaled.ml#L182)

<a id="function-function-ru-getflat-inline-function-ru-getflat-name-src-r-upscaled-ml-1266854740"></a>
### RU_GetFlat

```ml
inline function RU_GetFlat(name)
```

Returns an upscaled flat image entry or void.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `name` | `dynamic` | — | Resource or object name to resolve. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_upscaled.ml#L344)

<a id="function-function-ru-getpatch-inline-function-ru-getpatch-name-src-r-upscaled-ml-1844364192"></a>
### RU_GetPatch

```ml
inline function RU_GetPatch(name)
```

Returns an upscaled patch image entry or void.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `name` | `dynamic` | — | Resource or object name to resolve. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_upscaled.ml#L356)

<a id="function-function-ru-getsprite-inline-function-ru-getsprite-name-src-r-upscaled-ml-1909785828"></a>
### RU_GetSprite

```ml
inline function RU_GetSprite(name)
```

Returns an upscaled sprite image entry or void.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `name` | `dynamic` | — | Resource or object name to resolve. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_upscaled.ml#L362)

<a id="function-function-ru-gettexture-inline-function-ru-gettexture-name-src-r-upscaled-ml-488835972"></a>
### RU_GetTexture

```ml
inline function RU_GetTexture(name)
```

Returns an upscaled wall texture image entry or void.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `name` | `dynamic` | — | Resource or object name to resolve. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_upscaled.ml#L350)

<a id="function-function-ru-init-function-ru-init-iwadpath-src-r-upscaled-ml-89798750"></a>
### RU_Init

```ml
function RU_Init(iwadPath)
```

Initializes optional upscaled graphics support.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `iwadPath` | `dynamic` | — | Iwad path value supplied to `RU_Init`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_upscaled.ml#L302)

<a id="function-function-ru-isenabled-inline-function-ru-isenabled-src-r-upscaled-ml-721439529"></a>
### RU_IsEnabled

```ml
inline function RU_IsEnabled()
```

Returns true when a package is active.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_upscaled.ml#L323)

<a id="global-global-ru-loaded-ru-loaded-src-r-upscaled-ml-2021842014"></a>
### ru_loaded

```ml
ru_loaded
```

Tracks whether ru loaded is active in the r upscaled subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_upscaled.ml#L72)

<a id="function-function-ru-loadpackage-function-ru-loadpackage-path-src-r-upscaled-ml-1494735865"></a>
### RU_LoadPackage

```ml
function RU_LoadPackage(path)
```

Loads an upscaled package from disk.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `path` | `dynamic` | — | Filesystem path to process. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_upscaled.ml#L270)

<a id="constant-constant-ru-magic0-const-ru-magic0-77-src-r-upscaled-ml-373505589"></a>
### RU_MAGIC0

```ml
const RU_MAGIC0 = 77
```

Defines ru magic0 for the r upscaled subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_upscaled.ml#L26)

<a id="constant-constant-ru-magic1-const-ru-magic1-68-src-r-upscaled-ml-1254321557"></a>
### RU_MAGIC1

```ml
const RU_MAGIC1 = 68
```

Defines ru magic1 for the r upscaled subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_upscaled.ml#L28)

<a id="constant-constant-ru-magic2-const-ru-magic2-85-src-r-upscaled-ml-1211980836"></a>
### RU_MAGIC2

```ml
const RU_MAGIC2 = 85
```

Defines ru magic2 for the r upscaled subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_upscaled.ml#L30)

<a id="constant-constant-ru-magic3-const-ru-magic3-80-src-r-upscaled-ml-1825058459"></a>
### RU_MAGIC3

```ml
const RU_MAGIC3 = 80
```

Defines ru magic3 for the r upscaled subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_upscaled.ml#L32)

<a id="function-function-ru-name8-function-ru-name8-name-src-r-upscaled-ml-1101300453"></a>
### RU_Name8

```ml
function RU_Name8(name)
```

Normalizes names to Doom's 8-character lump namespace.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `name` | `dynamic` | — | Resource or object name to resolve. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_upscaled.ml#L139)

<a id="function-function-ru-parsepackage-function-ru-parsepackage-data-src-r-upscaled-ml-1772490218"></a>
### RU_ParsePackage

```ml
function RU_ParsePackage(data)
```

Parses MiniDoom upscaled package bytes.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `data` | `dynamic` | — | Binary or structured data to process. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_upscaled.ml#L210)

<a id="function-function-ru-parsescalefromargs-function-ru-parsescalefromargs-src-r-upscaled-ml-664832604"></a>
### RU_ParseScaleFromArgs

```ml
function RU_ParseScaleFromArgs()
```

Initializes the requested physical render scale.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_upscaled.ml#L169)

<a id="global-global-ru-path-ru-path-src-r-upscaled-ml-1531531730"></a>
### ru_path

```ml
ru_path
```

Stores the mutable ru path text used by the r upscaled subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_upscaled.ml#L74)

<a id="function-function-ru-reads32-inline-function-ru-reads32-b-off-src-r-upscaled-ml-104177550"></a>
### RU_ReadS32

```ml
inline function RU_ReadS32(b, off)
```

Reads a little-endian s32 from package bytes.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `b` | `dynamic` | — | Second input operand. |
| `off` | `dynamic` | — | Zero-based byte or element offset. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_upscaled.ml#L90)

<a id="function-function-ru-readu32-inline-function-ru-readu32-b-off-src-r-upscaled-ml-76711962"></a>
### RU_ReadU32

```ml
inline function RU_ReadU32(b, off)
```

Reads a little-endian u32 from package bytes.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `b` | `dynamic` | — | Second input operand. |
| `off` | `dynamic` | — | Zero-based byte or element offset. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_upscaled.ml#L83)

<a id="function-function-ru-rendererallowshd-inline-function-ru-rendererallowshd-src-r-upscaled-ml-40788577"></a>
### RU_RendererAllowsHD

```ml
inline function RU_RendererAllowsHD()
```

Returns true when the active renderer may consume HDWAD assets.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_upscaled.ml#L318)

<a id="function-function-ru-renderscale-inline-function-ru-renderscale-src-r-upscaled-ml-628220563"></a>
### RU_RenderScale

```ml
inline function RU_RenderScale()
```

Returns the physical render scale requested for this run.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_upscaled.ml#L313)

<a id="global-global-ru-scale-ru-scale-src-r-upscaled-ml-1962595366"></a>
### ru_scale

```ml
ru_scale
```

Tracks the mutable ru scale value used by the r upscaled subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_upscaled.ml#L76)

<a id="function-function-ru-tointor-function-ru-tointor-v-fallback-src-r-upscaled-ml-1535545758"></a>
### RU_ToIntOr

```ml
function RU_ToIntOr(v, fallback)
```

Converts a MiniLang value to int with fallback.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `v` | `dynamic` | — | Value consumed by the operation. |
| `fallback` | `dynamic` | — | Value returned when the requested conversion or lookup is unavailable. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_upscaled.ml#L99)

<a id="function-function-ru-toupperascii-function-ru-toupperascii-s-src-r-upscaled-ml-1440674053"></a>
### RU_ToUpperAscii

```ml
function RU_ToUpperAscii(s)
```

Converts a string to uppercase ASCII for WAD-style names.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `s` | `dynamic` | — | S value supplied to `RU_ToUpperAscii`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_upscaled.ml#L125)

<a id="constant-constant-ru-type-flat-const-ru-type-flat-2-src-r-upscaled-ml-1270141605"></a>
### RU_TYPE_FLAT

```ml
const RU_TYPE_FLAT = 2
```

Defines ru type flat for the r upscaled subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_upscaled.ml#L43)

<a id="constant-constant-ru-type-patch-const-ru-type-patch-1-src-r-upscaled-ml-407756430"></a>
### RU_TYPE_PATCH

```ml
const RU_TYPE_PATCH = 1
```

Defines ru type patch for the r upscaled subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_upscaled.ml#L41)

<a id="constant-constant-ru-type-sprite-const-ru-type-sprite-4-src-r-upscaled-ml-1476007219"></a>
### RU_TYPE_SPRITE

```ml
const RU_TYPE_SPRITE = 4
```

Defines ru type sprite for the r upscaled subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_upscaled.ml#L47)

<a id="constant-constant-ru-type-texture-const-ru-type-texture-3-src-r-upscaled-ml-1440542032"></a>
### RU_TYPE_TEXTURE

```ml
const RU_TYPE_TEXTURE = 3
```

Defines ru type texture for the r upscaled subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_upscaled.ml#L45)

<a id="constant-constant-ru-version-const-ru-version-6-src-r-upscaled-ml-1148818353"></a>
### RU_VERSION

```ml
const RU_VERSION = 6
```

Defines ru version for the r upscaled subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_upscaled.ml#L38)
