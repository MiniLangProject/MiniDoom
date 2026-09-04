# `src/i_system.ml`

[Home](README.md) · [Files](Files.md)

Supplies portable timing, sleep, shutdown, fatal-error, low-memory allocation, and base command services to the engine.

Package: [`(global)`](Package-global-1952375359.md)

Reachable from entry: **yes**

## Imports

- `d_event.ml` → [src/d_event.ml](File-src-d-event-ml-1995118760.md)
- `d_net.ml` → [src/d_net.ml](File-src-d-net-ml-529296669.md)
- `d_ticcmd.ml` → [src/d_ticcmd.ml](File-src-d-ticcmd-ml-1143326682.md)
- `doomdef.ml` → [src/doomdef.ml](File-src-doomdef-ml-460406769.md)
- `g_game.ml` → [src/g_game.ml](File-src-g-game-ml-257299317.md)
- `i_sound.ml` → [src/i_sound.ml](File-src-i-sound-ml-33806980.md)
- `i_system.ml` → [src/i_system.ml](File-src-i-system-ml-1632920966.md)
- `i_video.ml` → [src/i_video.ml](File-src-i-video-ml-140536292.md)
- `m_misc.ml` → [src/m_misc.ml](File-src-m-misc-ml-906836777.md)
- `mp_platform.ml` → [src/mp_platform.ml](File-src-mp-platform-ml-1361006310.md)
- `std/math.ml` → `../MiniLangCompilerOptimization/MiniLangCompilerPy/std/math.ml` — external dependency
- `std/time.ml` → `../MiniLangCompilerOptimization/MiniLangCompilerPy/std/time.ml` — external dependency

## Declarations

<a id="global-global-i-basetime-i-basetime-src-i-system-ml-1395906433"></a>
### _I_basetime

```ml
_I_basetime
```

Tracks the mutable i basetime value used by the i system subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_system.ml#L274)

<a id="global-global-i-emptycmd-i-emptycmd-src-i-system-ml-154596457"></a>
### _I_emptycmd

```ml
_I_emptycmd
```

Holds the optional i emptycmd resource used by the i system subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_system.ml#L277)

<a id="function-function-i-exitprocess-inline-function-i-exitprocess-code-src-i-system-ml-1403665511"></a>
### _I_ExitProcess

```ml
inline function _I_ExitProcess(code)
```

Normalizes a non-integer exit status to failure and terminates through Win32.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `code` | `dynamic` | — | Code value supplied to `_I_ExitProcess`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_system.ml#L297)

<a id="function-function-i-gettickcount-inline-function-i-gettickcount-src-i-system-ml-385322314"></a>
### _I_GetTickCount

```ml
inline function _I_GetTickCount()
```

Isolates the Win32 millisecond clock behind the engine's internal timing wrapper.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_system.ml#L281)

<a id="function-function-i-showfatalerrorbox-inline-function-i-showfatalerrorbox-text-src-i-system-ml-775909207"></a>
### _I_ShowFatalErrorBox

```ml
inline function _I_ShowFatalErrorBox(text)
```

Shows a fatal error message in a GUI dialog for windows-subsystem builds.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `text` | `dynamic` | — | Text to process. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_system.ml#L101)

<a id="function-function-i-sleep-inline-function-i-sleep-ms-src-i-system-ml-1667207988"></a>
### _I_Sleep

```ml
inline function _I_Sleep(ms)
```

Suspends the current thread for a non-negative duration through the platform-neutral standard time API.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `ms` | `dynamic` | — | Ms value supplied to `_I_Sleep`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_system.ml#L288)

<a id="function-function-i-strcontains-inline-function-i-strcontains-haystack-needle-src-i-system-ml-1630063697"></a>
### _I_StrContains

```ml
inline function _I_StrContains(haystack, needle)
```

Checks whether one string contains another.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `haystack` | `dynamic` | — | Haystack value supplied to `_I_StrContains`. |
| `needle` | `dynamic` | — | Needle value supplied to `_I_StrContains`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_system.ml#L74)

<a id="function-function-i-tolowerascii-inline-function-i-tolowerascii-s-src-i-system-ml-1105301289"></a>
### _I_ToLowerAscii

```ml
inline function _I_ToLowerAscii(s)
```

Converts a string to lowercase ASCII for robust message classification.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `s` | `dynamic` | — | S value supplied to `_I_ToLowerAscii`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_system.ml#L59)

<a id="function-function-is-idiv-inline-function-is-idiv-a-b-src-i-system-ml-490967277"></a>
### _IS_IDiv

```ml
inline function _IS_IDiv(a, b)
```

Returns a signed quotient truncated toward zero, or zero for invalid operands and a zero divisor in `_IS_IDiv`

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `a` | `dynamic` | — | First input operand. |
| `b` | `dynamic` | — | Second input operand. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_system.ml#L49)

<a id="constant-constant-isys-mb-iconerror-const-isys-mb-iconerror-16-src-i-system-ml-701281403"></a>
### _ISYS_MB_ICONERROR

```ml
const _ISYS_MB_ICONERROR = 16
```

Defines isys mb iconerror for the i system subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_system.ml#L42)

<a id="constant-constant-isys-mb-ok-const-isys-mb-ok-0-src-i-system-ml-566878854"></a>
### _ISYS_MB_OK

```ml
const _ISYS_MB_OK = 0
```

Defines isys mb ok for the i system subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_system.ml#L39)

<a id="extern_function-extern-function-exitprocess-extern-function-exitprocess-code-as-int-from-kernel32-dll-returns-int-src-i-system-ml-411186276"></a>
### ExitProcess

```ml
extern function ExitProcess(code as int) from "kernel32.dll" returns int
```

Terminates the process immediately with the supplied operating-system exit code.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `code` | `int` | — | `int` value supplied as code to `ExitProcess`. |


**Returns:** Result returned by the native `ExitProcess` binding as `int`.

[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_system.ml#L269)

<a id="extern_function-extern-function-gettickcount-extern-function-gettickcount-from-kernel32-dll-returns-u32-src-i-system-ml-53130777"></a>
### GetTickCount

```ml
extern function GetTickCount() from "kernel32.dll" returns u32
```

Returns Win32's millisecond count since system startup for Doom tic timing.


**Returns:** Win32's millisecond count since system startup for Doom tic timing.

[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_system.ml#L263)

<a id="function-function-i-alloclow-function-i-alloclow-length-src-i-system-ml-1947220855"></a>
### I_AllocLow

```ml
function I_AllocLow(length)
```

Allocates a zeroed byte buffer for legacy callers that expect low-memory storage.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `length` | `dynamic` | — | Number of bytes or elements in the associated value. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_system.ml#L182)

<a id="function-function-i-baseticcmd-function-i-baseticcmd-src-i-system-ml-1959708987"></a>
### I_BaseTiccmd

```ml
function I_BaseTiccmd()
```

Returns a reusable zeroed tic-command record that platform input code may populate for the current game tic.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_system.ml#L158)

<a id="function-function-i-beginread-function-i-beginread-src-i-system-ml-1325459429"></a>
### I_BeginRead

```ml
function I_BeginRead()
```

Preserves the legacy disk-read activity hook; this backend requires no begin notification.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_system.ml#L252)

<a id="function-function-i-endread-function-i-endread-src-i-system-ml-1974117865"></a>
### I_EndRead

```ml
function I_EndRead()
```

Preserves the legacy disk-read activity hook; this backend requires no end notification.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_system.ml#L256)

<a id="function-function-i-error-function-i-error-msg-src-i-system-ml-1013761610"></a>
### I_Error

```ml
function I_Error(msg)
```

Performs one-shot fatal shutdown, prints the diagnostic, releases subsystems, and terminates with a nonzero exit code.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `msg` | `dynamic` | — | Msg value supplied to `I_Error`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_system.ml#L201)

<a id="function-function-i-getheapsize-function-i-getheapsize-src-i-system-ml-894279737"></a>
### I_GetHeapSize

```ml
function I_GetHeapSize()
```

Converts the configured zone-heap size from mebibytes to bytes.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_system.ml#L239)

<a id="function-function-i-gettime-function-i-gettime-src-i-system-ml-611096061"></a>
### I_GetTime

```ml
function I_GetTime()
```

Converts elapsed Win32 milliseconds since the first call into whole 35 Hz game tics.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_system.ml#L127)

<a id="function-function-i-gettimefrac-function-i-gettimefrac-src-i-system-ml-1933898069"></a>
### I_GetTimeFrac

```ml
function I_GetTimeFrac()
```

Returns the clamped fractional progress through the current 35 Hz tic for uncapped interpolation.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_system.ml#L139)

<a id="function-function-i-init-function-i-init-src-i-system-ml-1584407751"></a>
### I_Init

```ml
function I_Init()
```

Brings up the platform audio backend after core engine globals are available.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_system.ml#L108)

<a id="function-function-i-quit-function-i-quit-src-i-system-ml-835643483"></a>
### I_Quit

```ml
function I_Quit()
```

Leaves the netgame, closes platform, audio, and graphics services, saves defaults, then exits successfully.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_system.ml#L168)

<a id="function-function-i-tactile-function-i-tactile-on-off-total-src-i-system-ml-1923541287"></a>
### I_Tactile

```ml
function I_Tactile(on, off, total)
```

Accepts legacy force-feedback parameters; this backend deliberately performs no tactile output.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `on` | `dynamic` | — | On value supplied to `I_Tactile`. |
| `off` | `dynamic` | — | Zero-based byte or element offset. |
| `total` | `dynamic` | — | Total value supplied to `I_Tactile`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_system.ml#L191)

<a id="function-function-i-waitvbl-function-i-waitvbl-count-src-i-system-ml-290254782"></a>
### I_WaitVBL

```ml
function I_WaitVBL(count)
```

Sleeps for the requested number of 70 Hz vertical-blank intervals using millisecond platform timing.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `count` | `dynamic` | — | Number of elements or iterations to process. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_system.ml#L245)

<a id="function-function-i-zonebase-function-i-zonebase-sizeout-src-i-system-ml-1467315904"></a>
### I_ZoneBase

```ml
function I_ZoneBase(sizeOut)
```

Allocates the requested zone heap, reports its actual size through the reference argument, and retains the buffer for engine-wide lifetime.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `sizeOut` | `dynamic` | — | Size out value supplied to `I_ZoneBase`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_system.ml#L117)

<a id="global-global-mb-used-mb-used-src-i-system-ml-1405012441"></a>
### mb_used

```ml
mb_used
```

Tracks the mutable mb used value used by the i system subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_system.ml#L236)
