# `src/p_doors.ml`

[Home](README.md) · [Files](Files.md)

Spawns and ticks keyed, tagged, timed, manual, and sliding sector-door state machines.

Package: [`(global)`](Package-global-1952375359.md)

Reachable from entry: **yes**

## Imports

- `doomdef.ml` → [src/doomdef.ml](File-src-doomdef-ml-460406769.md)
- `doomstat.ml` → [src/doomstat.ml](File-src-doomstat-ml-1652708088.md)
- `dstrings.ml` → [src/dstrings.ml](File-src-dstrings-ml-567491523.md)
- `p_local.ml` → [src/p_local.ml](File-src-p-local-ml-1043095437.md)
- `r_state.ml` → [src/r_state.ml](File-src-r-state-ml-691819649.md)
- `s_sound.ml` → [src/s_sound.ml](File-src-s-sound-ml-1485495390.md)
- `sounds.ml` → [src/sounds.ml](File-src-sounds-ml-1875364049.md)
- `z_zone.ml` → [src/z_zone.ml](File-src-z-zone-ml-1788911354.md)

## Declarations

<a id="function-function-doorsaddthinkerifpossible-inline-function-doorsaddthinkerifpossible-th-src-p-doors-ml-430232801"></a>
### _DoorsAddThinkerIfPossible

```ml
inline function _DoorsAddThinkerIfPossible(th)
```

Registers a door thinker only when both the node and thinker list API are available.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `th` | `dynamic` | — | Th value supplied to `_DoorsAddThinkerIfPossible`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_doors.ml#L39)

<a id="function-function-doorsbacksector-inline-function-doorsbacksector-line-src-p-doors-ml-650965929"></a>
### _DoorsBackSector

```ml
inline function _DoorsBackSector(line)
```

Resolves a two-sided line's back sector through its second side, rejecting invalid indices.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `line` | `dynamic` | — | Map line or text line affected by the operation. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_doors.ml#L109)

<a id="function-function-doorshascard-function-doorshascard-player-card-src-p-doors-ml-1597228475"></a>
### _DoorsHasCard

```ml
function _DoorsHasCard(player, card)
```

Tests a checked player's card slot without trusting malformed inventory containers.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `player` | `dynamic` | — | Player state affected by the operation. |
| `card` | `dynamic` | — | Card value supplied to `_DoorsHasCard`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_doors.ml#L73)

<a id="function-function-doorsisseq-inline-function-doorsisseq-v-src-p-doors-ml-486324013"></a>
### _DoorsIsSeq

```ml
inline function _DoorsIsSeq(v)
```

Accepts array and byte-buffer containers used by sector, line, and card tables.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `v` | `dynamic` | — | Value consumed by the operation. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_doors.ml#L64)

<a id="function-function-doorsmakethinker-inline-function-doorsmakethinker-fn-src-p-doors-ml-1505777603"></a>
### _DoorsMakeThinker

```ml
inline function _DoorsMakeThinker(fn)
```

Creates a thinker node bound to a door callback, preserving the layout expected by P_Ticker.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `fn` | `dynamic` | — | Fn value supplied to `_DoorsMakeThinker`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_doors.ml#L32)

<a id="function-function-doorssoundorg-inline-function-doorssoundorg-sec-src-p-doors-ml-221562458"></a>
### _DoorsSoundOrg

```ml
inline function _DoorsSoundOrg(sec)
```

Returns a sector's positional sound origin, falling back to the sector object itself.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `sec` | `dynamic` | — | Sec value supplied to `_DoorsSoundOrg`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_doors.ml#L56)

<a id="function-function-doorsstartsound-inline-function-doorsstartsound-origin-snd-src-p-doors-ml-1357597958"></a>
### _DoorsStartSound

```ml
inline function _DoorsStartSound(origin, snd)
```

Plays a door cue from a sector sound origin when the sound backend is present.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `origin` | `dynamic` | — | Origin value supplied to `_DoorsStartSound`. |
| `snd` | `dynamic` | — | Snd value supplied to `_DoorsStartSound`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_doors.ml#L47)

<a id="function-function-ev-dodoor-function-ev-dodoor-line-type-src-p-doors-ml-622067172"></a>
### EV_DoDoor

```ml
function EV_DoDoor(line, type)
```

Spawns vertical-door thinkers for every sector carrying the triggering line's tag.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `line` | `dynamic` | — | Map line or text line affected by the operation. |
| `type` | `dynamic` | — | Type value supplied to `EV_DoDoor`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_doors.ml#L264)

<a id="function-function-ev-dolockeddoor-function-ev-dolockeddoor-line-type-thing-src-p-doors-ml-383289614"></a>
### EV_DoLockedDoor

```ml
function EV_DoLockedDoor(line, type, thing)
```

Enforces the line's colored key requirement, posts feedback, then delegates valid activation.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `line` | `dynamic` | — | Map line or text line affected by the operation. |
| `type` | `dynamic` | — | Type value supplied to `EV_DoLockedDoor`. |
| `thing` | `dynamic` | — | World object affected by the operation. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_doors.ml#L226)

<a id="function-function-ev-slidingdoor-function-ev-slidingdoor-line-thing-src-p-doors-ml-1112026500"></a>
### EV_SlidingDoor

```ml
function EV_SlidingDoor(line, thing)
```

Validates and starts a manual sliding door when the line and activator permit it.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `line` | `dynamic` | — | Map line or text line affected by the operation. |
| `thing` | `dynamic` | — | World object affected by the operation. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_doors.ml#L489)

<a id="function-function-ev-verticaldoor-function-ev-verticaldoor-line-thing-src-p-doors-ml-1406394028"></a>
### EV_VerticalDoor

```ml
function EV_VerticalDoor(line, thing)
```

Activates or reverses a manual two-sided door while preventing conflicting sector specials.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `line` | `dynamic` | — | Map line or text line affected by the operation. |
| `thing` | `dynamic` | — | World object affected by the operation. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_doors.ml#L333)

<a id="function-function-p-findslidingdoortype-function-p-findslidingdoortype-line-src-p-doors-ml-1641591790"></a>
### P_FindSlidingDoorType

```ml
function P_FindSlidingDoorType(line)
```

Computes sliding door type values for the play simulation.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `line` | `dynamic` | — | Map line or text line affected by the operation. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_doors.ml#L475)

<a id="function-function-p-initslidingdoorframes-function-p-initslidingdoorframes-src-p-doors-ml-572766382"></a>
### P_InitSlidingDoorFrames

```ml
function P_InitSlidingDoorFrames()
```

Resets the sliding-door frame table before map or renderer-specific frames are registered.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_doors.ml#L469)

<a id="function-function-p-spawndoorclosein30-function-p-spawndoorclosein30-sec-src-p-doors-ml-31683431"></a>
### P_SpawnDoorCloseIn30

```ml
function P_SpawnDoorCloseIn30(sec)
```

Attaches a countdown thinker that closes an initially open sector door after 30 seconds.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `sec` | `dynamic` | — | Sec value supplied to `P_SpawnDoorCloseIn30`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_doors.ml#L432)

<a id="function-function-p-spawndoorraisein5mins-function-p-spawndoorraisein5mins-sec-secnum-src-p-doors-ml-2101713618"></a>
### P_SpawnDoorRaiseIn5Mins

```ml
function P_SpawnDoorRaiseIn5Mins(sec, secnum)
```

Attaches a delayed thinker that opens the sector door once after five minutes.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `sec` | `dynamic` | — | Sec value supplied to `P_SpawnDoorRaiseIn5Mins`. |
| `secnum` | `dynamic` | — | Index identifying sec. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_doors.ml#L450)

<a id="function-function-t-slidingdoor-function-t-slidingdoor-door-src-p-doors-ml-1553671806"></a>
### T_SlidingDoor

```ml
function T_SlidingDoor(door)
```

Advances a sliding-door thinker through its configured frame/wait phases.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `door` | `dynamic` | — | Door value supplied to `T_SlidingDoor`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_doors.ml#L482)

<a id="function-function-t-verticaldoor-function-t-verticaldoor-door-src-p-doors-ml-758044156"></a>
### T_VerticalDoor

```ml
function T_VerticalDoor(door)
```

Moves one door ceiling through opening, waiting, closing, and crush-reversal phases.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `door` | `dynamic` | — | Door value supplied to `T_VerticalDoor`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_doors.ml#L124)
