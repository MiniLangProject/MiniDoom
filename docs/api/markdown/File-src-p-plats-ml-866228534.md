# `src/p_plats.ml`

[Home](README.md) · [Files](Files.md)

Drives lift and perpetual-platform thinkers with active-slot tracking, waits, stasis, and sounds.

Package: [`(global)`](Package-global-1952375359.md)

Reachable from entry: **yes**

## Imports

- `doomdef.ml` → [src/doomdef.ml](File-src-doomdef-ml-460406769.md)
- `doomstat.ml` → [src/doomstat.ml](File-src-doomstat-ml-1652708088.md)
- `i_system.ml` → [src/i_system.ml](File-src-i-system-ml-1632920966.md)
- `m_random.ml` → [src/m_random.ml](File-src-m-random-ml-1659574948.md)
- `p_local.ml` → [src/p_local.ml](File-src-p-local-ml-1043095437.md)
- `r_state.ml` → [src/r_state.ml](File-src-r-state-ml-691819649.md)
- `s_sound.ml` → [src/s_sound.ml](File-src-s-sound-ml-1485495390.md)
- `sounds.ml` → [src/sounds.ml](File-src-sounds-ml-1875364049.md)
- `z_zone.ml` → [src/z_zone.ml](File-src-z-zone-ml-1788911354.md)

## Declarations

<a id="function-function-initactiveplats-function-initactiveplats-src-p-plats-ml-405742737"></a>
### _InitActivePlats

```ml
function _InitActivePlats()
```

Lazily creates the fixed-size active-platform slot table expected by tagged control operations.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_plats.ml#L35)

<a id="function-function-platfrontsector-inline-function-platfrontsector-line-src-p-plats-ml-451480228"></a>
### _PlatFrontSector

```ml
inline function _PlatFrontSector(line)
```

Resolves the sector on a line's front side for platform trigger calculations.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `line` | `dynamic` | — | Map line or text line affected by the operation. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_plats.ml#L99)

<a id="function-function-platmakethinker-inline-function-platmakethinker-fn-src-p-plats-ml-1317720746"></a>
### _PlatMakeThinker

```ml
inline function _PlatMakeThinker(fn)
```

Creates a platform thinker with list links, movement callback, direction, speed, and wait-state defaults.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `fn` | `dynamic` | — | Fn value supplied to `_PlatMakeThinker`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_plats.ml#L50)

<a id="function-function-platsetslot-function-platsetslot-idx-v-src-p-plats-ml-3122846"></a>
### _PlatSetSlot

```ml
function _PlatSetSlot(idx, v)
```

Rebuilds the active-platform sequence with one validated slot replaced, preserving list compatibility.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `idx` | `dynamic` | — | Zero-based element or table index. |
| `v` | `dynamic` | — | Value consumed by the operation. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_plats.ml#L76)

<a id="function-function-platsoundorg-inline-function-platsoundorg-sec-src-p-plats-ml-740712103"></a>
### _PlatSoundOrg

```ml
inline function _PlatSoundOrg(sec)
```

Selects the sector's positional sound origin, falling back to the sector when no dedicated origin exists.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `sec` | `dynamic` | — | Sec value supplied to `_PlatSoundOrg`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_plats.ml#L67)

<a id="function-function-platstartsound-inline-function-platstartsound-origin-snd-src-p-plats-ml-401524451"></a>
### _PlatStartSound

```ml
inline function _PlatStartSound(origin, snd)
```

Emits a positional platform sound only when the sound subsystem is available.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `origin` | `dynamic` | — | Origin value supplied to `_PlatStartSound`. |
| `snd` | `dynamic` | — | Snd value supplied to `_PlatStartSound`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_plats.ml#L58)

<a id="global-global-activeplats-activeplats-src-p-plats-ml-1477432611"></a>
### activeplats

```ml
activeplats
```

Stores the activeplats collection used by the p plats subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_plats.ml#L31)

<a id="function-function-ev-doplat-function-ev-doplat-line-type-amount-src-p-plats-ml-1933495643"></a>
### EV_DoPlat

```ml
function EV_DoPlat(line, type, amount)
```

Starts the requested platform behavior in each tagged inactive sector and records it in the active-platform set.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `line` | `dynamic` | — | Map line or text line affected by the operation. |
| `type` | `dynamic` | — | Type value supplied to `EV_DoPlat`. |
| `amount` | `dynamic` | — | Amount value supplied to `EV_DoPlat`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_plats.ml#L260)

<a id="function-function-ev-stopplat-function-ev-stopplat-line-src-p-plats-ml-1217674417"></a>
### EV_StopPlat

```ml
function EV_StopPlat(line)
```

Puts every moving platform with the trigger tag into stasis while preserving its status for later resume.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `line` | `dynamic` | — | Map line or text line affected by the operation. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_plats.ml#L171)

<a id="function-function-p-activateinstasis-function-p-activateinstasis-tag-src-p-plats-ml-1951141947"></a>
### P_ActivateInStasis

```ml
function P_ActivateInStasis(tag)
```

Resumes tagged platforms in stasis by restoring their previous status and movement callback.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `tag` | `dynamic` | — | Zone-memory or resource-lifetime tag. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_plats.ml#L151)

<a id="function-function-p-addactiveplat-function-p-addactiveplat-plat-src-p-plats-ml-494813094"></a>
### P_AddActivePlat

```ml
function P_AddActivePlat(plat)
```

Places a platform mover in the first free active slot, failing explicitly when the fixed table is exhausted.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `plat` | `dynamic` | — | Plat value supplied to `P_AddActivePlat`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_plats.ml#L111)

<a id="function-function-p-removeactiveplat-function-p-removeactiveplat-plat-src-p-plats-ml-811389848"></a>
### P_RemoveActivePlat

```ml
function P_RemoveActivePlat(plat)
```

Clears a completed platform's sector ownership, removes its thinker, and frees its active slot.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `plat` | `dynamic` | — | Plat value supplied to `P_RemoveActivePlat`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_plats.ml#L128)

<a id="function-function-t-platraise-function-t-platraise-plat-src-p-plats-ml-658963712"></a>
### T_PlatRaise

```ml
function T_PlatRaise(plat)
```

Advances a platform through upward, downward, waiting, and stationary states and emits movement or stop sounds.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `plat` | `dynamic` | — | Plat value supplied to `T_PlatRaise`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_plats.ml#L194)
