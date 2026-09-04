# `src/p_floor.ml`

[Home](README.md) · [Files](Files.md)

Moves sector planes with collision handling and drives tagged floor-change thinkers.

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

<a id="function-function-flooraddthinkerifpossible-inline-function-flooraddthinkerifpossible-th-src-p-floor-ml-1440013050"></a>
### _FloorAddThinkerIfPossible

```ml
inline function _FloorAddThinkerIfPossible(th)
```

Registers a floor thinker only when the thinker API is available, preserving compatibility with reduced test harnesses.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `th` | `dynamic` | — | Th value supplied to `_FloorAddThinkerIfPossible`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_floor.ml#L39)

<a id="function-function-floormakethinker-inline-function-floormakethinker-fn-src-p-floor-ml-1601910674"></a>
### _FloorMakeThinker

```ml
inline function _FloorMakeThinker(fn)
```

Creates a floor-mover thinker with canonical links, callback, direction, speed, and destination defaults.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `fn` | `dynamic` | — | Fn value supplied to `_FloorMakeThinker`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_floor.ml#L31)

<a id="function-function-floorsectorindex-function-floorsectorindex-sec-src-p-floor-ml-786876744"></a>
### _FloorSectorIndex

```ml
function _FloorSectorIndex(sec)
```

Resolves a sector object to its map-array index for neighbor and tag traversal.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `sec` | `dynamic` | — | Sec value supplied to `_FloorSectorIndex`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_floor.ml#L64)

<a id="function-function-floorsoundorg-inline-function-floorsoundorg-sec-src-p-floor-ml-859500321"></a>
### _FloorSoundOrg

```ml
inline function _FloorSoundOrg(sec)
```

Returns a sector sound origin when present, otherwise uses the sector itself as the positional sound source.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `sec` | `dynamic` | — | Sec value supplied to `_FloorSoundOrg`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_floor.ml#L56)

<a id="function-function-floorstartsound-inline-function-floorstartsound-origin-snd-src-p-floor-ml-880687481"></a>
### _FloorStartSound

```ml
inline function _FloorStartSound(origin, snd)
```

Emits a positional floor-movement sound only when the sound subsystem is available.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `origin` | `dynamic` | — | Origin value supplied to `_FloorStartSound`. |
| `snd` | `dynamic` | — | Snd value supplied to `_FloorStartSound`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_floor.ml#L47)

<a id="function-function-floortextureheight-inline-function-floortextureheight-tex-src-p-floor-ml-1036300135"></a>
### _FloorTextureHeight

```ml
inline function _FloorTextureHeight(tex)
```

Looks up a floor texture's pixel height and converts it to fixed-point movement units, with a 64-unit fallback.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `tex` | `dynamic` | — | Texture identifier or texture data to process. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_floor.ml#L79)

<a id="function-function-ev-buildstairs-function-ev-buildstairs-line-type-src-p-floor-ml-1572296407"></a>
### EV_BuildStairs

```ml
function EV_BuildStairs(line, type)
```

Chains adjacent sectors with the same floor texture into progressively offset stair movers.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `line` | `dynamic` | — | Map line or text line affected by the operation. |
| `type` | `dynamic` | — | Type value supplied to `EV_BuildStairs`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_floor.ml#L418)

<a id="function-function-ev-dofloor-function-ev-dofloor-line-floortype-src-p-floor-ml-1214231375"></a>
### EV_DoFloor

```ml
function EV_DoFloor(line, floortype)
```

Configures and starts the selected floor movement for all sectors matching a trigger tag.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `line` | `dynamic` | — | Map line or text line affected by the operation. |
| `floortype` | `dynamic` | — | Floortype value supplied to `EV_DoFloor`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_floor.ml#L246)

<a id="function-function-t-movefloor-function-t-movefloor-floor-src-p-floor-ml-1183940481"></a>
### T_MoveFloor

```ml
function T_MoveFloor(floor)
```

Advances one floor thinker, applies endpoint texture/special changes, emits movement sounds, and removes it at the destination.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `floor` | `dynamic` | — | Floor value supplied to `T_MoveFloor`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_floor.ml#L203)

<a id="function-function-t-moveplane-function-t-moveplane-sector-speed-dest-crush-floororceiling-direction-src-p-floor-ml-945033760"></a>
### T_MovePlane

```ml
function T_MovePlane(sector, speed, dest, crush, floorOrCeiling, direction)
```

Steps a floor or ceiling toward a destination, rolls back blocked non-crushing moves, and reports progress, arrival, or crushing.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `sector` | `dynamic` | — | Map sector affected by the operation. |
| `speed` | `dynamic` | — | Speed value supplied to `T_MovePlane`. |
| `dest` | `dynamic` | — | Dest value supplied to `T_MovePlane`. |
| `crush` | `dynamic` | — | Crush value supplied to `T_MovePlane`. |
| `floorOrCeiling` | `dynamic` | — | Floor or ceiling value supplied to `T_MovePlane`. |
| `direction` | `dynamic` | — | Direction value supplied to `T_MovePlane`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_floor.ml#L93)
