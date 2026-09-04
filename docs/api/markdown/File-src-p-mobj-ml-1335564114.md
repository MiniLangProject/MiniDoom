# `src/p_mobj.ml`

[Home](README.md) · [Files](Files.md)

Defines actor state, spawn/removal ownership, missile and player creation, movement, and item respawn.

Package: [`(global)`](Package-global-1952375359.md)

Reachable from entry: **yes**

## Imports

- `d_player.ml` → [src/d_player.ml](File-src-d-player-ml-1944166105.md)
- `d_think.ml` → [src/d_think.ml](File-src-d-think-ml-737524740.md)
- `doomdata.ml` → [src/doomdata.ml](File-src-doomdata-ml-887192154.md)
- `doomdef.ml` → [src/doomdef.ml](File-src-doomdef-ml-460406769.md)
- `doomstat.ml` → [src/doomstat.ml](File-src-doomstat-ml-1652708088.md)
- `hu_stuff.ml` → [src/hu_stuff.ml](File-src-hu-stuff-ml-1965779679.md)
- `i_system.ml` → [src/i_system.ml](File-src-i-system-ml-1632920966.md)
- `info.ml` → [src/info.ml](File-src-info-ml-1415270573.md)
- `m_fixed.ml` → [src/m_fixed.ml](File-src-m-fixed-ml-2129187227.md)
- `m_random.ml` → [src/m_random.ml](File-src-m-random-ml-1659574948.md)
- `p_local.ml` → [src/p_local.ml](File-src-p-local-ml-1043095437.md)
- `p_map.ml` → [src/p_map.ml](File-src-p-map-ml-882556686.md)
- `p_maputl.ml` → [src/p_maputl.ml](File-src-p-maputl-ml-227665141.md)
- `p_pspr.ml` → [src/p_pspr.ml](File-src-p-pspr-ml-844718747.md)
- `r_main.ml` → [src/r_main.ml](File-src-r-main-ml-1902335243.md)
- `s_sound.ml` → [src/s_sound.ml](File-src-s-sound-ml-1485495390.md)
- `sounds.ml` → [src/sounds.ml](File-src-sounds-ml-1875364049.md)
- `st_stuff.ml` → [src/st_stuff.ml](File-src-st-stuff-ml-811030939.md)
- `std/math.ml` → `../MiniLangCompilerOptimization/MiniLangCompilerPy/std/math.ml` — external dependency
- `tables.ml` → [src/tables.ml](File-src-tables-ml-1959718242.md)
- `z_zone.ml` → [src/z_zone.ml](File-src-z-zone-ml-1788911354.md)

## Declarations

<a id="function-function-inititemrespawnqueue-inline-function-inititemrespawnqueue-src-p-mobj-ml-2053385418"></a>
### _InitItemRespawnQueue

```ml
inline function _InitItemRespawnQueue()
```

Allocates the bounded dropped-item mapthing/timestamp ring on first respawn-queue use.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_mobj.ml#L221)

<a id="function-function-mobj-default-function-mobj-default-src-p-mobj-ml-986177093"></a>
### _Mobj_Default

```ml
function _Mobj_Default()
```

Constructs an unlinked inert actor whose fields satisfy mobj_t's runtime invariants.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_mobj.ml#L397)

<a id="function-function-pm-allocnetuid-inline-function-pm-allocnetuid-src-p-mobj-ml-2031785198"></a>
### _PM_AllocNetUid

```ml
inline function _PM_AllocNetUid()
```

Allocates a positive per-mobj uid used by multiplayer replication.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_mobj.ml#L386)

<a id="function-function-pm-ensureplayerslots-function-pm-ensureplayerslots-src-p-mobj-ml-1267695689"></a>
### _PM_EnsurePlayerSlots

```ml
function _PM_EnsurePlayerSlots()
```

Extends player and in-game arrays to MAXPLAYERS before mapthing-driven spawn access.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_mobj.ml#L771)

<a id="function-function-pm-idiv-inline-function-pm-idiv-a-b-src-p-mobj-ml-659972091"></a>
### _PM_IDiv

```ml
inline function _PM_IDiv(a, b)
```

Truncates actor movement quotients toward zero, returning zero for invalid operands.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `a` | `dynamic` | — | First input operand. |
| `b` | `dynamic` | — | Second input operand. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_mobj.ml#L326)

<a id="function-function-pm-mobjtypeindex-function-pm-mobjtypeindex-v-src-p-mobj-ml-1639907493"></a>
### _PM_MobjTypeIndex

```ml
function _PM_MobjTypeIndex(v)
```

Converts a checked mobj type enum/value to an in-range mobjinfo table index.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `v` | `dynamic` | — | Value consumed by the operation. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_mobj.ml#L355)

<a id="global-global-pm-next-netuid-pm-next-netuid-src-p-mobj-ml-1393028533"></a>
### _pm_next_netuid

```ml
_pm_next_netuid
```

Tracks the mutable pm next netuid value used by the p mobj subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_mobj.ml#L217)

<a id="global-global-pm-next-thinker-id-pm-next-thinker-id-src-p-mobj-ml-1476624873"></a>
### _pm_next_thinker_id

```ml
_pm_next_thinker_id
```

Tracks the mutable pm next thinker id value used by the p mobj subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_mobj.ml#L214)

<a id="function-function-pm-registerthinker-inline-function-pm-registerthinker-node-owner-src-p-mobj-ml-1632776455"></a>
### _PM_RegisterThinker

```ml
inline function _PM_RegisterThinker(node, owner)
```

Records the stable thinker-node-to-mobj association used when callbacks receive only a node.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `node` | `dynamic` | — | Node value supplied to `_PM_RegisterThinker`. |
| `owner` | `dynamic` | — | Owner value supplied to `_PM_RegisterThinker`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_mobj.ml#L239)

<a id="function-function-pm-resolvethinkerid-inline-function-pm-resolvethinkerid-node-src-p-mobj-ml-1967113310"></a>
### _PM_ResolveThinkerId

```ml
inline function _PM_ResolveThinkerId(node)
```

Returns stable thinker registration id used for multiplayer actor mapping.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `node` | `dynamic` | — | Node value supplied to `_PM_ResolveThinkerId`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_mobj.ml#L289)

<a id="function-function-pm-resolvethinkerowner-inline-function-pm-resolvethinkerowner-node-src-p-mobj-ml-1191935754"></a>
### _PM_ResolveThinkerOwner

```ml
inline function _PM_ResolveThinkerOwner(node)
```

Resolves either a direct mobj or its registered thinker node to the current actor owner.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `node` | `dynamic` | — | Node value supplied to `_PM_ResolveThinkerOwner`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_mobj.ml#L273)

<a id="function-function-pm-statespriteindex-inline-function-pm-statespriteindex-spr-src-p-mobj-ml-944309971"></a>
### _PM_StateSpriteIndex

```ml
inline function _PM_StateSpriteIndex(spr)
```

Converts a state sprite enum/value to a valid sprite table index or the null sprite.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `spr` | `dynamic` | — | Spr value supplied to `_PM_StateSpriteIndex`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_mobj.ml#L425)

<a id="global-global-pm-thinker-ids-pm-thinker-ids-src-p-mobj-ml-734791713"></a>
### _pm_thinker_ids

```ml
_pm_thinker_ids
```

Stores the pm thinker ids collection used by the p mobj subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_mobj.ml#L211)

<a id="global-global-pm-thinker-nodes-pm-thinker-nodes-src-p-mobj-ml-476030037"></a>
### _pm_thinker_nodes

```ml
_pm_thinker_nodes
```

Stores the pm thinker nodes collection used by the p mobj subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_mobj.ml#L205)

<a id="global-global-pm-thinker-owners-pm-thinker-owners-src-p-mobj-ml-1346250763"></a>
### _pm_thinker_owners

```ml
_pm_thinker_owners
```

Stores the pm thinker owners collection used by the p mobj subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_mobj.ml#L208)

<a id="function-function-pm-toint-inline-function-pm-toint-v-fallback-src-p-mobj-ml-1910346478"></a>
### _PM_ToInt

```ml
inline function _PM_ToInt(v, fallback)
```

Normalizes enum/numeric actor fields to truncating integers with a supplied fallback.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `v` | `dynamic` | — | Value consumed by the operation. |
| `fallback` | `dynamic` | — | Value returned when the requested conversion or lookup is unavailable. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_mobj.ml#L337)

<a id="function-function-pm-unregisterthinker-inline-function-pm-unregisterthinker-node-src-p-mobj-ml-257279822"></a>
### _PM_UnregisterThinker

```ml
inline function _PM_UnregisterThinker(node)
```

Removes a thinker-node ownership entry when its mobj leaves the world.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `node` | `dynamic` | — | Node value supplied to `_PM_UnregisterThinker`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_mobj.ml#L306)

<a id="constant-constant-friction-const-friction-59392-src-p-mobj-ml-1901985168"></a>
### FRICTION

```ml
const FRICTION = 59392
```

Defines friction for the p mobj subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_mobj.ml#L1017)

<a id="global-global-iquehead-iquehead-src-p-mobj-ml-1511227785"></a>
### iquehead

```ml
iquehead
```

Tracks the mutable iquehead value used by the p mobj subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_mobj.ml#L200)

<a id="global-global-iquetail-iquetail-src-p-mobj-ml-1269294137"></a>
### iquetail

```ml
iquetail
```

Tracks the mutable iquetail value used by the p mobj subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_mobj.ml#L202)

<a id="constant-constant-itemquesize-const-itemquesize-128-src-p-mobj-ml-1042722315"></a>
### ITEMQUESIZE

```ml
const ITEMQUESIZE = 128
```

Defines itemquesize for the p mobj subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_mobj.ml#L194)

<a id="global-global-itemrespawnque-itemrespawnque-src-p-mobj-ml-44707913"></a>
### itemrespawnque

```ml
itemrespawnque
```

Stores the itemrespawnque collection used by the p mobj subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_mobj.ml#L196)

<a id="global-global-itemrespawntime-itemrespawntime-src-p-mobj-ml-1333128737"></a>
### itemrespawntime

```ml
itemrespawntime
```

Stores the itemrespawntime collection used by the p mobj subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_mobj.ml#L198)

- [mobj_t](Type-mobj-t-841342086.md) — struct
- [mobjflag_t](Type-mobjflag-t-268313164.md) — enum
<a id="function-function-p-checkmissilespawn-function-p-checkmissilespawn-th-src-p-mobj-ml-1378406047"></a>
### P_CheckMissileSpawn

```ml
function P_CheckMissileSpawn(th)
```

Advances a new missile half a tic and explodes it immediately if its initial position is blocked.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `th` | `dynamic` | — | Th value supplied to `P_CheckMissileSpawn`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_mobj.ml#L639)

<a id="function-function-p-explodemissile-function-p-explodemissile-mo-src-p-mobj-ml-384873899"></a>
### P_ExplodeMissile

```ml
function P_ExplodeMissile(mo)
```

Stops missile momentum, enters its death state, removes missile solidity, and plays its death cue.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `mo` | `dynamic` | — | Map object affected by the operation. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_mobj.ml#L617)

<a id="function-function-p-mobjthinker-function-p-mobjthinker-mo-src-p-mobj-ml-410146987"></a>
### P_MobjThinker

```ml
function P_MobjThinker(mo)
```

Advances one actor's movement/state timer and triggers nightmare respawn when eligible.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `mo` | `dynamic` | — | Map object affected by the operation. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_mobj.ml#L1285)

<a id="function-function-p-nightmarerespawn-function-p-nightmarerespawn-mobj-src-p-mobj-ml-834896243"></a>
### P_NightmareRespawn

```ml
function P_NightmareRespawn(mobj)
```

Recreates a killed monster at its original spawn point with teleport fog and reaction delay.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `mobj` | `dynamic` | — | Map object affected by the operation. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_mobj.ml#L1197)

<a id="function-function-p-removemobj-function-p-removemobj-th-src-p-mobj-ml-883373499"></a>
### P_RemoveMobj

```ml
function P_RemoveMobj(th)
```

Queues eligible specials for respawn, unlinks the actor, and unregisters its thinker safely.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `th` | `dynamic` | — | Th value supplied to `P_RemoveMobj`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_mobj.ml#L986)

<a id="function-function-p-respawnspecials-function-p-respawnspecials-src-p-mobj-ml-1492768585"></a>
### P_RespawnSpecials

```ml
function P_RespawnSpecials()
```

Respawns one queued pickup after its delay when the destination is unoccupied.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_mobj.ml#L1345)

<a id="function-function-p-setmobjstate-function-p-setmobjstate-mobj-state-src-p-mobj-ml-256522030"></a>
### P_SetMobjState

```ml
function P_SetMobjState(mobj, state)
```

Enters a state, runs its action, and follows zero-tic transitions until a timed or null state.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `mobj` | `dynamic` | — | Map object affected by the operation. |
| `state` | `dynamic` | — | Subsystem state read or updated by the operation. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_mobj.ml#L444)

<a id="function-function-p-spawnblood-function-p-spawnblood-x-y-z-damage-src-p-mobj-ml-639092283"></a>
### P_SpawnBlood

```ml
function P_SpawnBlood(x, y, z, damage)
```

Spawns a randomized blood spray and selects its damage-scaled animation state.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `x` | `dynamic` | — | Horizontal map- or screen-space coordinate. |
| `y` | `dynamic` | — | Vertical map- or screen-space coordinate. |
| `z` | `dynamic` | — | Vertical world-space coordinate. |
| `damage` | `dynamic` | — | Damage value supplied to `P_SpawnBlood`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_mobj.ml#L1266)

<a id="function-function-p-spawnmapthing-function-p-spawnmapthing-mthing-src-p-mobj-ml-474331152"></a>
### P_SpawnMapThing

```ml
function P_SpawnMapThing(mthing)
```

Filters a mapthing by player/skill/type rules, then spawns its actor and map-derived flags.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `mthing` | `dynamic` | — | Mthing value supplied to `P_SpawnMapThing`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_mobj.ml#L887)

<a id="function-function-p-spawnmissile-function-p-spawnmissile-source-dest-type-src-p-mobj-ml-1682134020"></a>
### P_SpawnMissile

```ml
function P_SpawnMissile(source, dest, type)
```

Aims a projectile from source to destination, sets owner/momentum, and validates its first step.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `source` | `dynamic` | — | Source value or buffer. |
| `dest` | `dynamic` | — | Dest value supplied to `P_SpawnMissile`. |
| `type` | `dynamic` | — | Type value supplied to `P_SpawnMissile`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_mobj.ml#L661)

<a id="function-function-p-spawnmobj-function-p-spawnmobj-x-y-z-type-src-p-mobj-ml-151319488"></a>
### P_SpawnMobj

```ml
function P_SpawnMobj(x, y, z, type)
```

Instantiates an actor from mobjinfo, links it spatially, and registers its thinker ownership.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `x` | `dynamic` | — | Horizontal map- or screen-space coordinate. |
| `y` | `dynamic` | — | Vertical map- or screen-space coordinate. |
| `z` | `dynamic` | — | Vertical world-space coordinate. |
| `type` | `dynamic` | — | Type value supplied to `P_SpawnMobj`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_mobj.ml#L533)

<a id="function-function-p-spawnplayer-function-p-spawnplayer-mthing-src-p-mobj-ml-1901578954"></a>
### P_SpawnPlayer

```ml
function P_SpawnPlayer(mthing)
```

Converts a player start mapthing into a live pawn and attaches view, health, and reborn state.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `mthing` | `dynamic` | — | Mthing value supplied to `P_SpawnPlayer`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_mobj.ml#L802)

<a id="function-function-p-spawnplayermissile-function-p-spawnplayermissile-source-type-src-p-mobj-ml-1384187652"></a>
### P_SpawnPlayerMissile

```ml
function P_SpawnPlayerMissile(source, type)
```

Auto-aims a player projectile across fallback angles before spawning and validating it.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `source` | `dynamic` | — | Source value or buffer. |
| `type` | `dynamic` | — | Type value supplied to `P_SpawnPlayerMissile`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_mobj.ml#L711)

<a id="function-function-p-spawnpuff-function-p-spawnpuff-x-y-z-src-p-mobj-ml-732981978"></a>
### P_SpawnPuff

```ml
function P_SpawnPuff(x, y, z)
```

Spawns a randomized-height bullet puff and selects its melee-safe animation variant.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `x` | `dynamic` | — | Horizontal map- or screen-space coordinate. |
| `y` | `dynamic` | — | Vertical map- or screen-space coordinate. |
| `z` | `dynamic` | — | Vertical world-space coordinate. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_mobj.ml#L1246)

<a id="function-function-p-xymovement-function-p-xymovement-mo-src-p-mobj-ml-1310792247"></a>
### P_XYMovement

```ml
function P_XYMovement(mo)
```

Applies bounded XY momentum through collision/slide logic, then friction for grounded actors.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `mo` | `dynamic` | — | Map object affected by the operation. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_mobj.ml#L1021)

<a id="function-function-p-zmovement-function-p-zmovement-mo-src-p-mobj-ml-806994795"></a>
### P_ZMovement

```ml
function P_ZMovement(mo)
```

Integrates vertical momentum, gravity, floor/ceiling impacts, bouncing skulls, and missile explosions.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `mo` | `dynamic` | — | Map object affected by the operation. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_mobj.ml#L1130)

<a id="constant-constant-stopspeed-const-stopspeed-4096-src-p-mobj-ml-1573702599"></a>
### STOPSPEED

```ml
const STOPSPEED = 4096
```

Defines stopspeed for the p mobj subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_mobj.ml#L1015)
