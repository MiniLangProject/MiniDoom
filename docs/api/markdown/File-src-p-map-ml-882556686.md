# `src/p_map.ml`

[Home](README.md) · [Files](Files.md)

Resolves mobj/line collision, movement and sliding, use traces, hitscan attacks, and sector crushing.

Package: [`(global)`](Package-global-1952375359.md)

Reachable from entry: **yes**

## Imports

- `doomdef.ml` → [src/doomdef.ml](File-src-doomdef-ml-460406769.md)
- `doomstat.ml` → [src/doomstat.ml](File-src-doomstat-ml-1652708088.md)
- `i_system.ml` → [src/i_system.ml](File-src-i-system-ml-1632920966.md)
- `info.ml` → [src/info.ml](File-src-info-ml-1415270573.md)
- `m_argv.ml` → [src/m_argv.ml](File-src-m-argv-ml-728984635.md)
- `m_bbox.ml` → [src/m_bbox.ml](File-src-m-bbox-ml-1176525784.md)
- `m_fixed.ml` → [src/m_fixed.ml](File-src-m-fixed-ml-2129187227.md)
- `m_random.ml` → [src/m_random.ml](File-src-m-random-ml-1659574948.md)
- `p_inter.ml` → [src/p_inter.ml](File-src-p-inter-ml-1430401638.md)
- `p_local.ml` → [src/p_local.ml](File-src-p-local-ml-1043095437.md)
- `p_maputl.ml` → [src/p_maputl.ml](File-src-p-maputl-ml-227665141.md)
- `p_mobj.ml` → [src/p_mobj.ml](File-src-p-mobj-ml-1335564114.md)
- `p_sight.ml` → [src/p_sight.ml](File-src-p-sight-ml-269759795.md)
- `p_spec.ml` → [src/p_spec.ml](File-src-p-spec-ml-402508231.md)
- `p_switch.ml` → [src/p_switch.ml](File-src-p-switch-ml-925070734.md)
- `r_main.ml` → [src/r_main.ml](File-src-r-main-ml-1902335243.md)
- `r_sky.ml` → [src/r_sky.ml](File-src-r-sky-ml-918225537.md)
- `r_state.ml` → [src/r_state.ml](File-src-r-state-ml-691819649.md)
- `s_sound.ml` → [src/s_sound.ml](File-src-s-sound-ml-1485495390.md)
- `sounds.ml` → [src/sounds.ml](File-src-sounds-ml-1875364049.md)
- `tables.ml` → [src/tables.ml](File-src-tables-ml-1959718242.md)

## Declarations

<a id="function-function-lineindex-function-lineindex-ld-src-p-map-ml-351072229"></a>
### _LineIndex

```ml
function _LineIndex(ld)
```

Resolves a line reference to its stable map-line index for validcount de-duplication.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `ld` | `dynamic` | — | Ld value supplied to `_LineIndex`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_map.ml#L107)

<a id="function-function-mapabs-inline-function-mapabs-x-src-p-map-ml-1045468126"></a>
### _MapAbs

```ml
inline function _MapAbs(x)
```

Returns an integer magnitude for fixed-point distance and intercept comparisons.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `x` | `dynamic` | — | Horizontal map- or screen-space coordinate. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_map.ml#L66)

<a id="function-function-pm-diagmoveprint-inline-function-pm-diagmoveprint-msg-src-p-map-ml-43323167"></a>
### _PM_DiagMovePrint

```ml
inline function _PM_DiagMovePrint(msg)
```

Emits a try-move trace only when the cached diagnostic flag permits it.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `msg` | `dynamic` | — | Msg value supplied to `_PM_DiagMovePrint`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_map.ml#L203)

<a id="function-function-pm-trymovediagenabled-inline-function-pm-trymovediagenabled-src-p-map-ml-2127547906"></a>
### _PM_TryMoveDiagEnabled

```ml
inline function _PM_TryMoveDiagEnabled()
```

Caches whether command-line try-move diagnostics are enabled for this process.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_map.ml#L183)

<a id="function-function-pm-usediagenabled-inline-function-pm-usediagenabled-src-p-map-ml-334061992"></a>
### _PM_UseDiagEnabled

```ml
inline function _PM_UseDiagEnabled()
```

Caches whether command-line use-line traversal diagnostics are enabled.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_map.ml#L211)

<a id="function-function-pm-usediaglog-inline-function-pm-usediaglog-msg-src-p-map-ml-348721383"></a>
### _PM_UseDiagLog

```ml
inline function _PM_UseDiagLog(msg)
```

Emits a use-line trace only under the explicit diagnostic flag.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `msg` | `dynamic` | — | Msg value supplied to `_PM_UseDiagLog`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_map.ml#L231)

<a id="function-function-pmap-idiv-inline-function-pmap-idiv-a-b-src-p-map-ml-43107763"></a>
### _PMAP_IDiv

```ml
inline function _PMAP_IDiv(a, b)
```

Truncates fixed-point geometry quotients toward zero and maps invalid divisors to zero.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `a` | `dynamic` | — | First input operand. |
| `b` | `dynamic` | — | Second input operand. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_map.ml#L75)

<a id="function-function-pmap-s32-inline-function-pmap-s32-v-src-p-map-ml-2120541908"></a>
### _PMAP_S32

```ml
inline function _PMAP_S32(v)
```

Reinterprets an arithmetic result with signed 32-bit wrap semantics used by blockmap math.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `v` | `dynamic` | — | Value consumed by the operation. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_map.ml#L85)

<a id="global-global-pmdiagfailcount-pmdiagfailcount-src-p-map-ml-726019375"></a>
### _pmDiagFailCount

```ml
_pmDiagFailCount
```

Tracks the mutable pm diag fail count value used by the p map subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_map.ml#L152)

<a id="global-global-pmdiaglinecandcur-pmdiaglinecandcur-src-p-map-ml-28356649"></a>
### _pmDiagLineCandCur

```ml
_pmDiagLineCandCur
```

Tracks the mutable pm diag line cand cur value used by the p map subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_map.ml#L167)

<a id="global-global-pmdiaglinecandlast-pmdiaglinecandlast-src-p-map-ml-1884349603"></a>
### _pmDiagLineCandLast

```ml
_pmDiagLineCandLast
```

Tracks the mutable pm diag line cand last value used by the p map subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_map.ml#L170)

<a id="global-global-pmdiaglinecheckscur-pmdiaglinecheckscur-src-p-map-ml-313754083"></a>
### _pmDiagLineChecksCur

```ml
_pmDiagLineChecksCur
```

Tracks the mutable pm diag line checks cur value used by the p map subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_map.ml#L161)

<a id="global-global-pmdiaglinecheckslast-pmdiaglinecheckslast-src-p-map-ml-465897363"></a>
### _pmDiagLineChecksLast

```ml
_pmDiagLineChecksLast
```

Tracks the mutable pm diag line checks last value used by the p map subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_map.ml#L164)

<a id="global-global-pmdiagmove-pmdiagmove-src-p-map-ml-572476219"></a>
### _pmDiagMove

```ml
_pmDiagMove
```

Tracks whether pm diag move is active in the p map subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_map.ml#L146)

<a id="global-global-pmdiagmoveinit-pmdiagmoveinit-src-p-map-ml-1619578427"></a>
### _pmDiagMoveInit

```ml
_pmDiagMoveInit
```

Tracks whether pm diag move init is active in the p map subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_map.ml#L143)

<a id="global-global-pmdiagplayerfail-pmdiagplayerfail-src-p-map-ml-371342387"></a>
### _pmDiagPlayerFail

```ml
_pmDiagPlayerFail
```

Tracks the mutable pm diag player fail value used by the p map subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_map.ml#L158)

<a id="global-global-pmdiagplayertry-pmdiagplayertry-src-p-map-ml-4629705"></a>
### _pmDiagPlayerTry

```ml
_pmDiagPlayerTry
```

Tracks the mutable pm diag player try value used by the p map subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_map.ml#L155)

<a id="global-global-pmdiagtrycount-pmdiagtrycount-src-p-map-ml-694881419"></a>
### _pmDiagTryCount

```ml
_pmDiagTryCount
```

Tracks the mutable pm diag try count value used by the p map subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_map.ml#L149)

<a id="global-global-pmdiaguse-pmdiaguse-src-p-map-ml-550079659"></a>
### _pmDiagUse

```ml
_pmDiagUse
```

Tracks whether pm diag use is active in the p map subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_map.ml#L176)

<a id="global-global-pmdiagusecount-pmdiagusecount-src-p-map-ml-304792015"></a>
### _pmDiagUseCount

```ml
_pmDiagUseCount
```

Tracks the mutable pm diag use count value used by the p map subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_map.ml#L179)

<a id="global-global-pmdiaguseinit-pmdiaguseinit-src-p-map-ml-40495115"></a>
### _pmDiagUseInit

```ml
_pmDiagUseInit
```

Tracks whether pm diag use init is active in the p map subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_map.ml#L173)

<a id="function-function-settmbox-inline-function-settmbox-x-y-radius-src-p-map-ml-1363201131"></a>
### _SetTMBox

```ml
inline function _SetTMBox(x, y, radius)
```

Fills the shared candidate bounding box from a center and collision radius.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `x` | `dynamic` | — | Horizontal map- or screen-space coordinate. |
| `y` | `dynamic` | — | Vertical map- or screen-space coordinate. |
| `radius` | `dynamic` | — | Radius value supplied to `_SetTMBox`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_map.ml#L97)

<a id="global-global-aimslope-aimslope-src-p-map-ml-1364516095"></a>
### aimslope

```ml
aimslope
```

Tracks the mutable aimslope value used by the p map subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_map.ml#L1045)

<a id="global-global-attackrange-attackrange-src-p-map-ml-568679711"></a>
### attackrange

```ml
attackrange
```

Tracks the mutable attackrange value used by the p map subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_map.ml#L1043)

<a id="global-global-bestslidefrac-bestslidefrac-src-p-map-ml-2088081499"></a>
### bestslidefrac

```ml
bestslidefrac
```

Tracks the mutable bestslidefrac value used by the p map subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_map.ml#L119)

<a id="global-global-bestslideline-bestslideline-src-p-map-ml-1495415671"></a>
### bestslideline

```ml
bestslideline
```

Holds the optional bestslideline resource used by the p map subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_map.ml#L123)

<a id="global-global-bombdamage-bombdamage-src-p-map-ml-1815421377"></a>
### bombdamage

```ml
bombdamage
```

Tracks the mutable bombdamage value used by the p map subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_map.ml#L982)

<a id="global-global-bombsource-bombsource-src-p-map-ml-154629893"></a>
### bombsource

```ml
bombsource
```

Holds the optional bombsource resource used by the p map subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_map.ml#L978)

<a id="global-global-bombspot-bombspot-src-p-map-ml-788310779"></a>
### bombspot

```ml
bombspot
```

Holds the optional bombspot resource used by the p map subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_map.ml#L980)

<a id="global-global-bottomslope-bottomslope-src-p-map-ml-52084363"></a>
### bottomslope

```ml
bottomslope
```

Tracks the mutable bottomslope value used by the p map subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_map.ml#L1049)

<a id="global-global-crushchange-crushchange-src-p-map-ml-682639263"></a>
### crushchange

```ml
crushchange
```

Tracks whether crushchange is active in the p map subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_map.ml#L137)

<a id="global-global-la-damage-la-damage-src-p-map-ml-817559439"></a>
### la_damage

```ml
la_damage
```

Tracks the mutable la damage value used by the p map subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_map.ml#L1041)

<a id="constant-constant-maxspecialcross-const-maxspecialcross-8-src-p-map-ml-819169218"></a>
### MAXSPECIALCROSS

```ml
const MAXSPECIALCROSS = 8
```

Defines the maximum maxspecialcross accepted by the p map subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_map.ml#L57)

<a id="global-global-nofit-nofit-src-p-map-ml-1024462323"></a>
### nofit

```ml
nofit
```

Tracks whether nofit is active in the p map subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_map.ml#L139)

<a id="global-global-numspechit-numspechit-src-p-map-ml-1328160339"></a>
### numspechit

```ml
numspechit
```

Tracks the mutable numspechit value used by the p map subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_map.ml#L61)

<a id="function-function-p-aimlineattack-function-p-aimlineattack-t1-angle-distance-src-p-map-ml-1749368286"></a>
### P_AimLineAttack

```ml
function P_AimLineAttack(t1, angle, distance)
```

Computes line attack values for the map collision.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `t1` | `dynamic` | — | T1 value supplied to `P_AimLineAttack`. |
| `angle` | `dynamic` | — | Doom binary-angle measurement. |
| `distance` | `dynamic` | — | Distance value supplied to `P_AimLineAttack`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_map.ml#L1225)

<a id="function-function-p-changesector-function-p-changesector-sector-crunch-src-p-map-ml-1979810850"></a>
### P_ChangeSector

```ml
function P_ChangeSector(sector, crunch)
```

Visits all blockmap things touching a moving sector and reports whether any were crushed.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `sector` | `dynamic` | — | Map sector affected by the operation. |
| `crunch` | `dynamic` | — | Crunch value supplied to `P_ChangeSector`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_map.ml#L958)

<a id="function-function-p-checkposition-function-p-checkposition-thing-x-y-src-p-map-ml-1352106668"></a>
### P_CheckPosition

```ml
function P_CheckPosition(thing, x, y)
```

Probes a candidate origin, populating shared opening globals without committing the mobj position.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `thing` | `dynamic` | — | World object affected by the operation. |
| `x` | `dynamic` | — | Horizontal map- or screen-space coordinate. |
| `y` | `dynamic` | — | Vertical map- or screen-space coordinate. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_map.ml#L397)

<a id="function-function-p-hitslideline-function-p-hitslideline-ld-src-p-map-ml-1078275089"></a>
### P_HitSlideLine

```ml
function P_HitSlideLine(ld)
```

Projects the pending slide vector along the wall axis or clears it on horizontal/vertical walls.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `ld` | `dynamic` | — | Ld value supplied to `P_HitSlideLine`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_map.ml#L667)

<a id="function-function-p-lineattack-function-p-lineattack-t1-angle-distance-slope-damage-src-p-map-ml-642473316"></a>
### P_LineAttack

```ml
function P_LineAttack(t1, angle, distance, slope, damage)
```

Configures a hitscan ray and traverses intercepts to apply damage at the supplied slope.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `t1` | `dynamic` | — | T1 value supplied to `P_LineAttack`. |
| `angle` | `dynamic` | — | Doom binary-angle measurement. |
| `distance` | `dynamic` | — | Distance value supplied to `P_LineAttack`. |
| `slope` | `dynamic` | — | Slope value supplied to `P_LineAttack`. |
| `damage` | `dynamic` | — | Damage value supplied to `P_LineAttack`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_map.ml#L1263)

<a id="function-function-p-radiusattack-function-p-radiusattack-spot-source-damage-src-p-map-ml-463123941"></a>
### P_RadiusAttack

```ml
function P_RadiusAttack(spot, source, damage)
```

Walks blast-radius blockmap cells and damages visible shootable occupants around an explosion.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `spot` | `dynamic` | — | Spot value supplied to `P_RadiusAttack`. |
| `source` | `dynamic` | — | Source value or buffer. |
| `damage` | `dynamic` | — | Damage value supplied to `P_RadiusAttack`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_map.ml#L1013)

<a id="function-function-p-slidemove-function-p-slidemove-mo-src-p-map-ml-2080095611"></a>
### P_SlideMove

```ml
function P_SlideMove(mo)
```

Traces leading corners, clips momentum at the nearest wall, and retries up to three slide bumps.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `mo` | `dynamic` | — | Map object affected by the operation. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_map.ml#L801)

<a id="function-function-p-teleportmove-function-p-teleportmove-thing-x-y-src-p-map-ml-822617392"></a>
### P_TeleportMove

```ml
function P_TeleportMove(thing, x, y)
```

Telefrags destination occupants and relocates the mobj without ordinary wall/step restrictions.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `thing` | `dynamic` | — | World object affected by the operation. |
| `x` | `dynamic` | — | Horizontal map- or screen-space coordinate. |
| `y` | `dynamic` | — | Vertical map- or screen-space coordinate. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_map.ml#L592)

<a id="function-function-p-thingheightclip-function-p-thingheightclip-thing-src-p-map-ml-1413609655"></a>
### P_ThingHeightClip

```ml
function P_ThingHeightClip(thing)
```

Recomputes floor/ceiling bounds after sector motion and clamps a grounded mobj to its new floor.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `thing` | `dynamic` | — | World object affected by the operation. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_map.ml#L644)

<a id="function-function-p-trymove-function-p-trymove-thing-x-y-src-p-map-ml-986644990"></a>
### P_TryMove

```ml
function P_TryMove(thing, x, y)
```

Validates step/dropoff/ceiling constraints and commits a legal XY move with sector relinking.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `thing` | `dynamic` | — | World object affected by the operation. |
| `x` | `dynamic` | — | Horizontal map- or screen-space coordinate. |
| `y` | `dynamic` | — | Vertical map- or screen-space coordinate. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_map.ml#L485)

<a id="function-function-p-uselines-function-p-uselines-player-src-p-map-ml-1960710740"></a>
### P_UseLines

```ml
function P_UseLines(player)
```

Casts the player's short use ray and activates the first eligible crossed line.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `player` | `dynamic` | — | Player state affected by the operation. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_map.ml#L893)

<a id="function-function-pit-changesector-function-pit-changesector-thing-src-p-map-ml-1424281071"></a>
### PIT_ChangeSector

```ml
function PIT_ChangeSector(thing)
```

Reclips one resident mobj after sector motion and applies crush damage when it no longer fits.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `thing` | `dynamic` | — | World object affected by the operation. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_map.ml#L911)

<a id="function-function-pit-checkline-function-pit-checkline-ld-src-p-map-ml-1399994421"></a>
### PIT_CheckLine

```ml
function PIT_CheckLine(ld)
```

Rejects blocking crossed lines and narrows candidate floor, ceiling, and dropoff openings.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `ld` | `dynamic` | — | Ld value supplied to `PIT_CheckLine`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_map.ml#L264)

<a id="function-function-pit-checkthing-function-pit-checkthing-thing-src-p-map-ml-1910314675"></a>
### PIT_CheckThing

```ml
function PIT_CheckThing(thing)
```

Resolves mobj overlap as blocking, missile impact, skull charge, or player pickup contact.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `thing` | `dynamic` | — | World object affected by the operation. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_map.ml#L325)

<a id="function-function-pit-radiusattack-function-pit-radiusattack-thing-src-p-map-ml-1849818043"></a>
### PIT_RadiusAttack

```ml
function PIT_RadiusAttack(thing)
```

Applies distance-falloff splash damage to one shootable thing with line-of-sight to the blast.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `thing` | `dynamic` | — | World object affected by the operation. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_map.ml#L986)

<a id="function-function-pit-stompthing-function-pit-stompthing-thing-src-p-map-ml-378332423"></a>
### PIT_StompThing

```ml
function PIT_StompThing(thing)
```

Telefrags shootable occupants overlapping the teleport destination, excluding the mover itself.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `thing` | `dynamic` | — | World object affected by the operation. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_map.ml#L243)

<a id="function-function-ptr-aimtraverse-function-ptr-aimtraverse-inter-src-p-map-ml-306114329"></a>
### PTR_AimTraverse

```ml
function PTR_AimTraverse(inter)
```

Narrows the vertical aiming window through lines and locks onto the first shootable intercept.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `inter` | `dynamic` | — | Inter value supplied to `PTR_AimTraverse`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_map.ml#L1053)

<a id="function-function-ptr-shoottraverse-function-ptr-shoottraverse-inter-src-p-map-ml-1007303361"></a>
### PTR_ShootTraverse

```ml
function PTR_ShootTraverse(inter)
```

Activates shoot specials and spawns wall puffs or target blood at the first hitscan impact.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `inter` | `dynamic` | — | Inter value supplied to `PTR_ShootTraverse`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_map.ml#L1122)

<a id="function-function-ptr-slidetraverse-function-ptr-slidetraverse-inter-src-p-map-ml-1686116781"></a>
### PTR_SlideTraverse

```ml
function PTR_SlideTraverse(inter)
```

Records the nearest blocking line intercept for the current slide trace.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `inter` | `dynamic` | — | Inter value supplied to `PTR_SlideTraverse`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_map.ml#L717)

<a id="function-function-ptr-usetraverse-function-ptr-usetraverse-inter-src-p-map-ml-1685721921"></a>
### PTR_UseTraverse

```ml
function PTR_UseTraverse(inter)
```

Activates the first usable special line on a use trace or stops at a closed non-special line.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `inter` | `dynamic` | — | Inter value supplied to `PTR_UseTraverse`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_map.ml#L762)

<a id="global-global-secondslidefrac-secondslidefrac-src-p-map-ml-616976475"></a>
### secondslidefrac

```ml
secondslidefrac
```

Tracks the mutable secondslidefrac value used by the p map subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_map.ml#L121)

<a id="global-global-secondslideline-secondslideline-src-p-map-ml-1278719623"></a>
### secondslideline

```ml
secondslideline
```

Holds the optional secondslideline resource used by the p map subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_map.ml#L125)

<a id="global-global-shootthing-shootthing-src-p-map-ml-1272998973"></a>
### shootthing

```ml
shootthing
```

Holds the optional shootthing resource used by the p map subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_map.ml#L1037)

<a id="global-global-shootz-shootz-src-p-map-ml-671993785"></a>
### shootz

```ml
shootz
```

Tracks the mutable shootz value used by the p map subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_map.ml#L1039)

<a id="global-global-slidemo-slidemo-src-p-map-ml-1219226947"></a>
### slidemo

```ml
slidemo
```

Holds the optional slidemo resource used by the p map subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_map.ml#L127)

<a id="global-global-spechit-spechit-src-p-map-ml-1485561451"></a>
### spechit

```ml
spechit
```

Stores the spechit collection used by the p map subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_map.ml#L59)

<a id="global-global-tmbbox-tmbbox-src-p-map-ml-1566569907"></a>
### tmbbox

```ml
tmbbox
```

Stores the tmbbox collection used by the p map subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_map.ml#L43)

<a id="global-global-tmdropoffz-tmdropoffz-src-p-map-ml-1344504317"></a>
### tmdropoffz

```ml
tmdropoffz
```

Tracks the mutable tmdropoffz value used by the p map subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_map.ml#L54)

<a id="global-global-tmflags-tmflags-src-p-map-ml-1368974107"></a>
### tmflags

```ml
tmflags
```

Tracks the mutable tmflags value used by the p map subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_map.ml#L47)

<a id="global-global-tmthing-tmthing-src-p-map-ml-2136692815"></a>
### tmthing

```ml
tmthing
```

Holds the optional tmthing resource used by the p map subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_map.ml#L45)

<a id="global-global-tmx-tmx-src-p-map-ml-917555947"></a>
### tmx

```ml
tmx
```

Tracks the mutable tmx value used by the p map subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_map.ml#L49)

<a id="global-global-tmxmove-tmxmove-src-p-map-ml-457311435"></a>
### tmxmove

```ml
tmxmove
```

Tracks the mutable tmxmove value used by the p map subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_map.ml#L129)

<a id="global-global-tmy-tmy-src-p-map-ml-1663467859"></a>
### tmy

```ml
tmy
```

Tracks the mutable tmy value used by the p map subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_map.ml#L51)

<a id="global-global-tmymove-tmymove-src-p-map-ml-582955707"></a>
### tmymove

```ml
tmymove
```

Tracks the mutable tmymove value used by the p map subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_map.ml#L131)

<a id="global-global-topslope-topslope-src-p-map-ml-1405900571"></a>
### topslope

```ml
topslope
```

Tracks the mutable topslope value used by the p map subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_map.ml#L1047)

<a id="global-global-usething-usething-src-p-map-ml-386429029"></a>
### usething

```ml
usething
```

Holds the optional usething resource used by the p map subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_map.ml#L134)
