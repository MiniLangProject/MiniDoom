# `src/p_lights.ml`

[Home](README.md) · [Files](Files.md)

Implements sector fire-flicker, flash, strobe, glow, and tagged lighting effects as thinkers.

Package: [`(global)`](Package-global-1952375359.md)

Reachable from entry: **yes**

## Imports

- `doomdef.ml` → [src/doomdef.ml](File-src-doomdef-ml-460406769.md)
- `m_random.ml` → [src/m_random.ml](File-src-m-random-ml-1659574948.md)
- `p_local.ml` → [src/p_local.ml](File-src-p-local-ml-1043095437.md)
- `r_state.ml` → [src/r_state.ml](File-src-r-state-ml-691819649.md)
- `z_zone.ml` → [src/z_zone.ml](File-src-z-zone-ml-1788911354.md)

## Declarations

<a id="function-function-p-addthinkerifpossible-inline-function-p-addthinkerifpossible-th-src-p-lights-ml-604158161"></a>
### _P_AddThinkerIfPossible

```ml
inline function _P_AddThinkerIfPossible(th)
```

Registers a lighting thinker when the full thinker list API is present, allowing reduced test harnesses to omit it.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `th` | `dynamic` | — | Th value supplied to `_P_AddThinkerIfPossible`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_lights.ml#L38)

<a id="function-function-p-makethinker-inline-function-p-makethinker-acp1-src-p-lights-ml-1189809076"></a>
### _P_MakeThinker

```ml
inline function _P_MakeThinker(acp1)
```

Constructs an unlinked thinker node whose primary callback drives a sector lighting effect.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `acp1` | `dynamic` | — | Acp1 value supplied to `_P_MakeThinker`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_lights.ml#L29)

<a id="function-function-ev-lightturnon-function-ev-lightturnon-line-bright-src-p-lights-ml-482609686"></a>
### EV_LightTurnOn

```ml
function EV_LightTurnOn(line, bright)
```

Sets tagged sectors to an explicit brightness or, when zero is requested, their brightest neighboring level.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `line` | `dynamic` | — | Map line or text line affected by the operation. |
| `bright` | `dynamic` | — | Bright value supplied to `EV_LightTurnOn`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_lights.ml#L206)

<a id="function-function-ev-startlightstrobing-function-ev-startlightstrobing-line-src-p-lights-ml-1034264194"></a>
### EV_StartLightStrobing

```ml
function EV_StartLightStrobing(line)
```

Adds unsynchronized slow strobe thinkers to every sector carrying the trigger line's tag.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `line` | `dynamic` | — | Map line or text line affected by the operation. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_lights.ml#L174)

<a id="function-function-ev-turntaglightsoff-function-ev-turntaglightsoff-line-src-p-lights-ml-1684255512"></a>
### EV_TurnTagLightsOff

```ml
function EV_TurnTagLightsOff(line)
```

Sets every tagged sector to the darkest light level found in its neighboring sectors.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `line` | `dynamic` | — | Map line or text line affected by the operation. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_lights.ml#L189)

<a id="function-function-p-spawnfireflicker-function-p-spawnfireflicker-sector-src-p-lights-ml-2047846770"></a>
### P_SpawnFireFlicker

```ml
function P_SpawnFireFlicker(sector)
```

Attaches a fire-flicker thinker using the sector's current light as maximum and its darkest neighbor as minimum.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `sector` | `dynamic` | — | Map sector affected by the operation. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_lights.ml#L69)

<a id="function-function-p-spawnglowinglight-function-p-spawnglowinglight-sector-src-p-lights-ml-621564260"></a>
### P_SpawnGlowingLight

```ml
function P_SpawnGlowingLight(sector)
```

Attaches a glow thinker that begins dimming from the sector's current light toward its darkest neighbor.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `sector` | `dynamic` | — | Map sector affected by the operation. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_lights.ml#L247)

<a id="function-function-p-spawnlightflash-function-p-spawnlightflash-sector-src-p-lights-ml-1214687330"></a>
### P_SpawnLightFlash

```ml
function P_SpawnLightFlash(sector)
```

Attaches a randomized two-level flash thinker bounded by the sector's original and darkest neighboring light.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `sector` | `dynamic` | — | Map sector affected by the operation. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_lights.ml#L105)

<a id="function-function-p-spawnstrobeflash-function-p-spawnstrobeflash-sector-fastorslow-insync-src-p-lights-ml-1885627840"></a>
### P_SpawnStrobeFlash

```ml
function P_SpawnStrobeFlash(sector, fastOrSlow, inSync)
```

Attaches a fast or slow strobe thinker, optionally synchronizing its initial countdown with peer sectors.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `sector` | `dynamic` | — | Map sector affected by the operation. |
| `fastOrSlow` | `dynamic` | — | Fast or slow value supplied to `P_SpawnStrobeFlash`. |
| `inSync` | `dynamic` | — | In sync value supplied to `P_SpawnStrobeFlash`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_lights.ml#L143)

<a id="function-function-t-fireflicker-function-t-fireflicker-flick-src-p-lights-ml-1836652873"></a>
### T_FireFlicker

```ml
function T_FireFlicker(flick)
```

Every four tics chooses a randomized fire brightness no darker than the sector's neighboring minimum.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `flick` | `dynamic` | — | Flick value supplied to `T_FireFlicker`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_lights.ml#L46)

<a id="function-function-t-glow-function-t-glow-g-src-p-lights-ml-1167778181"></a>
### T_Glow

```ml
function T_Glow(g)
```

Smoothly oscillates a sector's light level between neighboring minimum and maximum bounds.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `g` | `dynamic` | — | G value supplied to `T_Glow`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_lights.ml#L226)

<a id="function-function-t-lightflash-function-t-lightflash-flash-src-p-lights-ml-1339578852"></a>
### T_LightFlash

```ml
function T_LightFlash(flash)
```

Alternates a sector between its bright and dark levels using randomized flash durations.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `flash` | `dynamic` | — | Flash value supplied to `T_LightFlash`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_lights.ml#L82)

<a id="function-function-t-strobeflash-function-t-strobeflash-flash-src-p-lights-ml-2067931284"></a>
### T_StrobeFlash

```ml
function T_StrobeFlash(flash)
```

Advances a sector strobe between minimum and maximum light levels with independent bright and dark intervals.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `flash` | `dynamic` | — | Flash value supplied to `T_StrobeFlash`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_lights.ml#L122)
