# `src/p_switch.ml`

[Home](README.md) · [Files](Files.md)

Resolves switch texture pairs, manages timed buttons, and dispatches player-use line specials.

Package: [`(global)`](Package-global-1952375359.md)

Reachable from entry: **yes**

## Imports

- `doomdef.ml` → [src/doomdef.ml](File-src-doomdef-ml-460406769.md)
- `doomstat.ml` → [src/doomstat.ml](File-src-doomstat-ml-1652708088.md)
- `g_game.ml` → [src/g_game.ml](File-src-g-game-ml-257299317.md)
- `i_system.ml` → [src/i_system.ml](File-src-i-system-ml-1632920966.md)
- `m_argv.ml` → [src/m_argv.ml](File-src-m-argv-ml-728984635.md)
- `p_ceilng.ml` → [src/p_ceilng.ml](File-src-p-ceilng-ml-226654252.md)
- `p_doors.ml` → [src/p_doors.ml](File-src-p-doors-ml-224295587.md)
- `p_floor.ml` → [src/p_floor.ml](File-src-p-floor-ml-1999892698.md)
- `p_lights.ml` → [src/p_lights.ml](File-src-p-lights-ml-1710096069.md)
- `p_local.ml` → [src/p_local.ml](File-src-p-local-ml-1043095437.md)
- `p_plats.ml` → [src/p_plats.ml](File-src-p-plats-ml-866228534.md)
- `p_spec.ml` → [src/p_spec.ml](File-src-p-spec-ml-402508231.md)
- `r_state.ml` → [src/r_state.ml](File-src-r-state-ml-691819649.md)
- `s_sound.ml` → [src/s_sound.ml](File-src-s-sound-ml-1485495390.md)
- `sounds.ml` → [src/sounds.ml](File-src-sounds-ml-1875364049.md)
- `std/math.ml` → `../MiniLangCompilerOptimization/MiniLangCompilerPy/std/math.ml` — external dependency

## Declarations

<a id="global-global-alphswitchlist-alphswitchlist-src-p-switch-ml-53197709"></a>
### _alphSwitchList

```ml
_alphSwitchList
```

Stores the alph switch list collection used by the p switch subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_switch.ml#L55)

<a id="function-function-initbuttonlist-function-initbuttonlist-src-p-switch-ml-1198639841"></a>
### _InitButtonList

```ml
function _InitButtonList()
```

Lazily creates the fixed set of reusable timed-button records with inactive timers.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_switch.ml#L112)

<a id="function-function-psw-diaguseenabled-function-psw-diaguseenabled-src-p-switch-ml-1280183933"></a>
### _PSW_DiagUseEnabled

```ml
function _PSW_DiagUseEnabled()
```

Caches whether switch-use diagnostic logging was enabled on the command line.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_switch.ml#L149)

<a id="function-function-psw-diaguselog-inline-function-psw-diaguselog-msg-src-p-switch-ml-1094728881"></a>
### _PSW_DiagUseLog

```ml
inline function _PSW_DiagUseLog(msg)
```

Emits a switch-use diagnostic only when the cached diagnostic option is active.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `msg` | `dynamic` | — | Msg value supplied to `_PSW_DiagUseLog`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_switch.ml#L169)

<a id="function-function-psw-idiv-inline-function-psw-idiv-a-b-src-p-switch-ml-1143589623"></a>
### _PSW_Idiv

```ml
inline function _PSW_Idiv(a, b)
```

Returns a signed quotient truncated toward zero, using zero when the divisor is zero.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `a` | `dynamic` | — | First input operand. |
| `b` | `dynamic` | — | Second input operand. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_switch.ml#L219)

<a id="function-function-psw-isseq-inline-function-psw-isseq-v-src-p-switch-ml-512562008"></a>
### _PSW_IsSeq

```ml
inline function _PSW_IsSeq(v)
```

Tests whether an arbitrary value is an indexable array or byte sequence.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `v` | `dynamic` | — | Value consumed by the operation. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_switch.ml#L105)

<a id="function-function-psw-side0-inline-function-psw-side0-line-src-p-switch-ml-2104470924"></a>
### _PSW_Side0

```ml
inline function _PSW_Side0(line)
```

Resolves a line's front sidedef while rejecting absent or out-of-range side indices.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `line` | `dynamic` | — | Map line or text line affected by the operation. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_switch.ml#L127)

<a id="function-function-psw-startsound-inline-function-psw-startsound-origin-sound-src-p-switch-ml-576074077"></a>
### _PSW_StartSound

```ml
inline function _PSW_StartSound(origin, sound)
```

Emits a switch sound from a valid positional origin when audio support is available.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `origin` | `dynamic` | — | Origin value supplied to `_PSW_StartSound`. |
| `sound` | `dynamic` | — | Sound value supplied to `_PSW_StartSound`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_switch.ml#L140)

<a id="global-global-pswdiaguse-pswdiaguse-src-p-switch-ml-830093793"></a>
### _pswDiagUse

```ml
_pswDiagUse
```

Tracks whether psw diag use is active in the p switch subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_switch.ml#L48)

<a id="global-global-pswdiagusecount-pswdiagusecount-src-p-switch-ml-869800677"></a>
### _pswDiagUseCount

```ml
_pswDiagUseCount
```

Tracks the mutable psw diag use count value used by the p switch subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_switch.ml#L51)

<a id="global-global-pswdiaguseinit-pswdiaguseinit-src-p-switch-ml-529060417"></a>
### _pswDiagUseInit

```ml
_pswDiagUseInit
```

Tracks whether psw diag use init is active in the p switch subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_switch.ml#L45)

<a id="global-global-buttonlist-buttonlist-src-p-switch-ml-2056804037"></a>
### buttonlist

```ml
buttonlist
```

Stores the buttonlist collection used by the p switch subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_switch.ml#L42)

<a id="global-global-numswitches-numswitches-src-p-switch-ml-1812879517"></a>
### numswitches

```ml
numswitches
```

Tracks the mutable numswitches value used by the p switch subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_switch.ml#L40)

<a id="function-function-p-changeswitchtexture-function-p-changeswitchtexture-line-useagain-src-p-switch-ml-256432222"></a>
### P_ChangeSwitchTexture

```ml
function P_ChangeSwitchTexture(line, useAgain)
```

Finds the activated sidedef texture's paired switch image, plays its sound, and optionally schedules restoration.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `line` | `dynamic` | — | Map line or text line affected by the operation. |
| `useAgain` | `dynamic` | — | Use again value supplied to `P_ChangeSwitchTexture`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_switch.ml#L266)

<a id="function-function-p-initswitchlist-function-p-initswitchlist-src-p-switch-ml-1421212979"></a>
### P_InitSwitchList

```ml
function P_InitSwitchList()
```

Resolves texture pairs allowed by the current game edition and terminates the list with a sentinel.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_switch.ml#L179)

<a id="function-function-p-startbutton-function-p-startbutton-line-w-texture-time-src-p-switch-ml-1250795040"></a>
### P_StartButton

```ml
function P_StartButton(line, w, texture, time)
```

Reserves a timer for a reusable switch texture, avoiding duplicate records for the same linedef.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `line` | `dynamic` | — | Map line or text line affected by the operation. |
| `w` | `dynamic` | — | W value supplied to `P_StartButton`. |
| `texture` | `dynamic` | — | Texture value supplied to `P_StartButton`. |
| `time` | `dynamic` | — | Time value used by the operation. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_switch.ml#L231)

<a id="function-function-p-updatebuttons-function-p-updatebuttons-src-p-switch-ml-747268229"></a>
### P_UpdateButtons

```ml
function P_UpdateButtons()
```

Counts down reusable switches, restores their original sidedef texture at expiry, and frees their timer records.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_switch.ml#L326)

<a id="function-function-p-usespecialline-function-p-usespecialline-thing-line-side-src-p-switch-ml-1943443042"></a>
### P_UseSpecialLine

```ml
function P_UseSpecialLine(thing, line, side)
```

Enforces side and monster-use restrictions, dispatches a linedef's manual special, and changes its switch texture on success.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `thing` | `dynamic` | — | World object affected by the operation. |
| `line` | `dynamic` | — | Map line or text line affected by the operation. |
| `side` | `dynamic` | — | Map side affected by the operation. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_switch.ml#L363)

<a id="global-global-switchlist-switchlist-src-p-switch-ml-217311197"></a>
### switchlist

```ml
switchlist
```

Stores the switchlist collection used by the p switch subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_switch.ml#L38)
