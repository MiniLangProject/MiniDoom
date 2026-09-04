# `src/p_telept.ml`

[Home](README.md) · [Files](Files.md)

Executes tagged line teleports, destination lookup, fog effects, and player view/momentum reset.

Package: [`(global)`](Package-global-1952375359.md)

Reachable from entry: **yes**

## Imports

- `doomdef.ml` → [src/doomdef.ml](File-src-doomdef-ml-460406769.md)
- `p_local.ml` → [src/p_local.ml](File-src-p-local-ml-1043095437.md)
- `p_mobj.ml` → [src/p_mobj.ml](File-src-p-mobj-ml-1335564114.md)
- `p_tick.ml` → [src/p_tick.ml](File-src-p-tick-ml-887781845.md)
- `r_state.ml` → [src/r_state.ml](File-src-r-state-ml-691819649.md)
- `s_sound.ml` → [src/s_sound.ml](File-src-s-sound-ml-1485495390.md)
- `sounds.ml` → [src/sounds.ml](File-src-sounds-ml-1875364049.md)
- `tables.ml` → [src/tables.ml](File-src-tables-ml-1959718242.md)

## Declarations

<a id="function-function-ptp-resolvethinkermobj-function-ptp-resolvethinkermobj-th-src-p-telept-ml-561066941"></a>
### _PTP_ResolveThinkerMobj

```ml
function _PTP_ResolveThinkerMobj(th)
```

Resolves a thinker node to its owning mobj across direct-owner and legacy thinker layouts.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `th` | `dynamic` | — | Th value supplied to `_PTP_ResolveThinkerMobj`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_telept.ml#L32)

<a id="function-function-ev-teleport-function-ev-teleport-line-side-thing-src-p-telept-ml-109397786"></a>
### EV_Teleport

```ml
function EV_Teleport(line, side, thing)
```

Finds a destination marker with the trigger tag, relocates the activator, spawns fog effects, and resets player view and momentum.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `line` | `dynamic` | — | Map line or text line affected by the operation. |
| `side` | `dynamic` | — | Map side affected by the operation. |
| `thing` | `dynamic` | — | World object affected by the operation. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_telept.ml#L54)
