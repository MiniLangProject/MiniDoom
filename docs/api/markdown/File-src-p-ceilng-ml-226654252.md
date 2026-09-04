# `src/p_ceilng.ml`

[Home](README.md) · [Files](Files.md)

Runs moving and crushing ceiling thinkers, including active-slot tracking and tagged stasis control.

Package: [`(global)`](Package-global-1952375359.md)

Reachable from entry: **yes**

## Imports

- `doomdef.ml` → [src/doomdef.ml](File-src-doomdef-ml-460406769.md)
- `doomstat.ml` → [src/doomstat.ml](File-src-doomstat-ml-1652708088.md)
- `p_local.ml` → [src/p_local.ml](File-src-p-local-ml-1043095437.md)
- `r_state.ml` → [src/r_state.ml](File-src-r-state-ml-691819649.md)
- `s_sound.ml` → [src/s_sound.ml](File-src-s-sound-ml-1485495390.md)
- `sounds.ml` → [src/sounds.ml](File-src-sounds-ml-1875364049.md)
- `z_zone.ml` → [src/z_zone.ml](File-src-z-zone-ml-1788911354.md)

## Declarations

<a id="function-function-ceilingmakethinker-inline-function-ceilingmakethinker-fn-src-p-ceilng-ml-1774093012"></a>
### _CeilingMakeThinker

```ml
inline function _CeilingMakeThinker(fn)
```

Creates a ceiling-mover thinker with list links, callback, direction, speed, and sector state initialized for activation.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `fn` | `dynamic` | — | Fn value supplied to `_CeilingMakeThinker`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_ceilng.ml#L49)

<a id="function-function-ceilingsetslot-inline-function-ceilingsetslot-idx-v-src-p-ceilng-ml-1897665829"></a>
### _CeilingSetSlot

```ml
inline function _CeilingSetSlot(idx, v)
```

Rebuilds the active-ceiling sequence with one validated slot replaced, preserving list compatibility.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `idx` | `dynamic` | — | Zero-based element or table index. |
| `v` | `dynamic` | — | Value consumed by the operation. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_ceilng.ml#L57)

<a id="function-function-initactiveceilings-function-initactiveceilings-src-p-ceilng-ml-1911881191"></a>
### _InitActiveCeilings

```ml
function _InitActiveCeilings()
```

Lazily creates the fixed-size active-ceiling slot table expected by tag and stasis operations.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_ceilng.ml#L33)

<a id="global-global-activeceilings-activeceilings-src-p-ceilng-ml-386790283"></a>
### activeceilings

```ml
activeceilings
```

Stores the activeceilings collection used by the p ceilng subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_ceilng.ml#L29)

<a id="function-function-ev-ceilingcrushstop-function-ev-ceilingcrushstop-line-src-p-ceilng-ml-164855987"></a>
### EV_CeilingCrushStop

```ml
function EV_CeilingCrushStop(line)
```

Puts every active ceiling with the trigger tag into stasis and reports whether any mover was stopped.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `line` | `dynamic` | — | Map line or text line affected by the operation. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_ceilng.ml#L115)

<a id="function-function-ev-doceiling-function-ev-doceiling-line-type-src-p-ceilng-ml-620422971"></a>
### EV_DoCeiling

```ml
function EV_DoCeiling(line, type)
```

Starts the requested ceiling action in every sector matching a trigger line's tag and reports whether any mover was created.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `line` | `dynamic` | — | Map line or text line affected by the operation. |
| `type` | `dynamic` | — | Type value supplied to `EV_DoCeiling`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_ceilng.ml#L174)

<a id="function-function-p-activateinstasisceiling-function-p-activateinstasisceiling-line-src-p-ceilng-ml-674653233"></a>
### P_ActivateInStasisCeiling

```ml
function P_ActivateInStasisCeiling(line)
```

Resumes every stopped ceiling matching a trigger tag by restoring its saved direction.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `line` | `dynamic` | — | Map line or text line affected by the operation. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_ceilng.ml#L100)

<a id="function-function-p-addactiveceiling-function-p-addactiveceiling-c-src-p-ceilng-ml-1788524832"></a>
### P_AddActiveCeiling

```ml
function P_AddActiveCeiling(c)
```

Places a ceiling mover in the first free active slot so tagged stop and resume events can find it.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `c` | `dynamic` | — | C value supplied to `P_AddActiveCeiling`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_ceilng.ml#L72)

<a id="function-function-p-removeactiveceiling-function-p-removeactiveceiling-c-src-p-ceilng-ml-1531573816"></a>
### P_RemoveActiveCeiling

```ml
function P_RemoveActiveCeiling(c)
```

Clears the slot holding a completed ceiling mover so it no longer participates in tagged control.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `c` | `dynamic` | — | C value supplied to `P_RemoveActiveCeiling`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_ceilng.ml#L86)

<a id="function-function-t-moveceiling-function-t-moveceiling-ceiling-src-p-ceilng-ml-66760340"></a>
### T_MoveCeiling

```ml
function T_MoveCeiling(ceiling)
```

Moves a ceiling toward its current bound, reverses cyclic crushers at endpoints, and removes one-shot movers on completion.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `ceiling` | `dynamic` | — | Ceiling value supplied to `T_MoveCeiling`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_ceilng.ml#L138)
