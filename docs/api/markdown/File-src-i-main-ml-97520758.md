# `src/i_main.ml`

[Home](README.md) · [Files](Files.md)

Normalizes process arguments, starts Doom, and reports uncaught startup failures through the active platform UI.

Package: [`(global)`](Package-global-1952375359.md)

Reachable from entry: **yes**

## Imports

- `d_main.ml` → [src/d_main.ml](File-src-d-main-ml-105344057.md)
- `doomdef.ml` → [src/doomdef.ml](File-src-doomdef-ml-460406769.md)
- `m_argv.ml` → [src/m_argv.ml](File-src-m-argv-ml-728984635.md)
- `std/fs.ml` as `fs` → `../MiniLangCompilerOptimization/MiniLangCompilerPy/std/fs.ml` — external dependency
- `std/math.ml` → `../MiniLangCompilerOptimization/MiniLangCompilerPy/std/math.ml` — external dependency

## Declarations

<a id="function-function-imain-inttostring-function-imain-inttostring-v-src-i-main-ml-1020691259"></a>
### _IMain_IntToString

```ml
function _IMain_IntToString(v)
```

Formats a signed integer without relying on runtime-specific numeric string conversion.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `v` | `dynamic` | — | Value consumed by the operation. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_main.ml#L51)

<a id="constant-constant-imain-mb-iconerror-const-imain-mb-iconerror-16-src-i-main-ml-694546391"></a>
### _IMAIN_MB_ICONERROR

```ml
const _IMAIN_MB_ICONERROR = 16
```

Defines imain mb iconerror for the i main subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_main.ml#L46)

<a id="constant-constant-imain-mb-ok-const-imain-mb-ok-0-src-i-main-ml-1476045956"></a>
### _IMAIN_MB_OK

```ml
const _IMAIN_MB_OK = 0
```

Defines imain mb ok for the i main subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_main.ml#L43)

<a id="function-function-imain-showfatalerror-inline-function-imain-showfatalerror-msg-src-i-main-ml-1517378773"></a>
### _IMain_ShowFatalError

```ml
inline function _IMain_ShowFatalError(msg)
```

Shows a fatal startup/runtime error in a GUI message box for windows-subsystem builds.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `msg` | `dynamic` | — | Msg value supplied to `_IMain_ShowFatalError`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_main.ml#L84)

<a id="function-function-main-function-main-args-src-i-main-ml-1861481220"></a>
### main

```ml
function main(args)
```

Converts process arguments into Doom's argv representation, enters D_DoomMain, and reports an uncaught startup failure through the platform error path.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `args` | `dynamic` | — | Args value supplied to `main`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_main.ml#L100)

<a id="extern_function-extern-function-messageboxw-extern-function-messageboxw-hwnd-as-ptr-text-as-wstr-caption-as-wstr-flags-as-u32-from-user32-dll-symbol-messageboxw-returns-int-src-i-main-ml-648921020"></a>
### MessageBoxW

```ml
extern function MessageBoxW(hwnd as ptr, text as wstr, caption as wstr, flags as u32) from "user32.dll" symbol "MessageBoxW" returns int
```

Displays the UTF-16 fatal-error dialog used when startup cannot reach the in-game console.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `hwnd` | `ptr` | — | `ptr` value supplied as hwnd to `MessageBoxW`. |
| `text` | `wstr` | — | Text to process. |
| `caption` | `wstr` | — | `wstr` value supplied as caption to `MessageBoxW`. |
| `flags` | `u32` | — | Bit flags that control the operation. |


**Returns:** Result returned by the native `MessageBoxW` binding as `int`.

[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_main.ml#L38)
