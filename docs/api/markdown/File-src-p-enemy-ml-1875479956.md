# `src/p_enemy.ml`

[Home](README.md) · [Files](Files.md)

Implements monster perception, chase movement, attack actions, resurrection, boss triggers, and Icon of Sin spawning.

Package: [`(global)`](Package-global-1952375359.md)

Reachable from entry: **yes**

## Imports

- `doomdef.ml` → [src/doomdef.ml](File-src-doomdef-ml-460406769.md)
- `doomstat.ml` → [src/doomstat.ml](File-src-doomstat-ml-1652708088.md)
- `g_game.ml` → [src/g_game.ml](File-src-g-game-ml-257299317.md)
- `i_system.ml` → [src/i_system.ml](File-src-i-system-ml-1632920966.md)
- `m_fixed.ml` → [src/m_fixed.ml](File-src-m-fixed-ml-2129187227.md)
- `m_random.ml` → [src/m_random.ml](File-src-m-random-ml-1659574948.md)
- `p_doors.ml` → [src/p_doors.ml](File-src-p-doors-ml-224295587.md)
- `p_floor.ml` → [src/p_floor.ml](File-src-p-floor-ml-1999892698.md)
- `p_inter.ml` → [src/p_inter.ml](File-src-p-inter-ml-1430401638.md)
- `p_local.ml` → [src/p_local.ml](File-src-p-local-ml-1043095437.md)
- `p_map.ml` → [src/p_map.ml](File-src-p-map-ml-882556686.md)
- `p_maputl.ml` → [src/p_maputl.ml](File-src-p-maputl-ml-227665141.md)
- `p_mobj.ml` → [src/p_mobj.ml](File-src-p-mobj-ml-1335564114.md)
- `p_sight.ml` → [src/p_sight.ml](File-src-p-sight-ml-269759795.md)
- `p_switch.ml` → [src/p_switch.ml](File-src-p-switch-ml-925070734.md)
- `r_main.ml` → [src/r_main.ml](File-src-r-main-ml-1902335243.md)
- `r_state.ml` → [src/r_state.ml](File-src-r-state-ml-691819649.md)
- `s_sound.ml` → [src/s_sound.ml](File-src-s-sound-ml-1485495390.md)
- `sounds.ml` → [src/sounds.ml](File-src-sounds-ml-1875364049.md)
- `std/math.ml` → `../MiniLangCompilerOptimization/MiniLangCompilerPy/std/math.ml` — external dependency
- `tables.ml` → [src/tables.ml](File-src-tables-ml-1959718242.md)

## Declarations

<a id="function-function-pe-abs-inline-function-pe-abs-v-src-p-enemy-ml-1514184290"></a>
### _PE_Abs

```ml
inline function _PE_Abs(v)
```

Returns the non-negative magnitude of an enemy movement or distance scalar.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `v` | `dynamic` | — | Value consumed by the operation. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_enemy.ml#L103)

<a id="global-global-pe-brain-easy-pe-brain-easy-src-p-enemy-ml-566094405"></a>
### _PE_brain_easy

```ml
_PE_brain_easy
```

Tracks the mutable pe brain easy value used by the p enemy subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_enemy.ml#L98)

<a id="function-function-pe-drophiddentarget-function-pe-drophiddentarget-actor-src-p-enemy-ml-2076430188"></a>
### _PE_DropHiddenTarget

```ml
function _PE_DropHiddenTarget(actor)
```

Cancels a monster's lock, movement, and queued attack when its player target has persistent notarget enabled.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `actor` | `dynamic` | — | Actor value supplied to `_PE_DropHiddenTarget`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_enemy.ml#L164)

<a id="function-function-pe-hasotheralivetype-function-pe-hasotheralivetype-exceptmo-motype-src-p-enemy-ml-1474425678"></a>
### _PE_HasOtherAliveType

```ml
function _PE_HasOtherAliveType(exceptMo, moType)
```

Scans registered thinkers for another living mobj of the requested type, excluding the supplied actor.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `exceptMo` | `dynamic` | — | Except mo value supplied to `_PE_HasOtherAliveType`. |
| `moType` | `dynamic` | — | Mo type value supplied to `_PE_HasOtherAliveType`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_enemy.ml#L220)

<a id="function-function-pe-idiv-inline-function-pe-idiv-a-b-src-p-enemy-ml-1356503379"></a>
### _PE_IDiv

```ml
inline function _PE_IDiv(a, b)
```

Divides integer AI values with truncation toward zero, returning zero for invalid operands or a zero divisor.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `a` | `dynamic` | — | First input operand. |
| `b` | `dynamic` | — | Second input operand. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_enemy.ml#L113)

<a id="function-function-pe-isnotargetmobj-inline-function-pe-isnotargetmobj-mo-src-p-enemy-ml-2006283620"></a>
### _PE_IsNoTargetMobj

```ml
inline function _PE_IsNoTargetMobj(mo)
```

Reports whether a player actor is hidden from monster sight and sound acquisition.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `mo` | `dynamic` | — | Map object affected by the operation. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_enemy.ml#L155)

<a id="function-function-pe-junklinewithtag-inline-function-pe-junklinewithtag-tag-src-p-enemy-ml-34489016"></a>
### _PE_JunkLineWithTag

```ml
inline function _PE_JunkLineWithTag(tag)
```

Constructs a minimal synthetic linedef carrying a tag for boss-death floor and door event APIs.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `tag` | `dynamic` | — | Zone-memory or resource-lifetime tag. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_enemy.ml#L133)

<a id="function-function-pe-painshootskull-function-pe-painshootskull-actor-angle-src-p-enemy-ml-839800143"></a>
### _PE_PainShootSkull

```ml
function _PE_PainShootSkull(actor, angle)
```

Enforces the Lost Soul population cap, validates a spawn point, creates a soul, and starts its charge at the target.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `actor` | `dynamic` | — | Actor value supplied to `_PE_PainShootSkull`. |
| `angle` | `dynamic` | — | Doom binary-angle measurement. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_enemy.ml#L1216)

<a id="function-function-pe-resolvethinkermobj-inline-function-pe-resolvethinkermobj-cur-src-p-enemy-ml-522950588"></a>
### _PE_ResolveThinkerMobj

```ml
inline function _PE_ResolveThinkerMobj(cur)
```

Resolves a thinker-list node to its registered mobj owner, accepting direct mobj-shaped nodes as fallback.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `cur` | `dynamic` | — | Cur value supplied to `_PE_ResolveThinkerMobj`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_enemy.ml#L140)

<a id="function-function-pe-startsound-inline-function-pe-startsound-origin-sfx-src-p-enemy-ml-1162699243"></a>
### _PE_StartSound

```ml
inline function _PE_StartSound(origin, sfx)
```

Starts an actor sound when the audio subsystem is linked, otherwise leaves AI state unchanged.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `origin` | `dynamic` | — | Origin value supplied to `_PE_StartSound`. |
| `sfx` | `dynamic` | — | Sound-effect descriptor to process. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_enemy.ml#L124)

<a id="function-function-a-babymetal-function-a-babymetal-mo-src-p-enemy-ml-264551041"></a>
### A_BabyMetal

```ml
function A_BabyMetal(mo)
```

Plays the Arachnotron walking sound and continues chase processing.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `mo` | `dynamic` | — | Map object affected by the operation. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_enemy.ml#L1442)

<a id="function-function-a-bossdeath-function-a-bossdeath-mo-src-p-enemy-ml-1366931721"></a>
### A_BossDeath

```ml
function A_BossDeath(mo)
```

After validating map/type, living players, and last-boss status, triggers the canonical tagged floor/door action or exits.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `mo` | `dynamic` | — | Map object affected by the operation. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_enemy.ml#L1325)

<a id="function-function-a-brainawake-function-a-brainawake-mo-src-p-enemy-ml-1277683087"></a>
### A_BrainAwake

```ml
function A_BrainAwake(mo)
```

Collects all boss-target map objects, resets the target cursor, and starts the Icon of Sin wake sound.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `mo` | `dynamic` | — | Map object affected by the operation. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_enemy.ml#L1481)

<a id="function-function-a-braindie-function-a-braindie-mo-src-p-enemy-ml-479458515"></a>
### A_BrainDie

```ml
function A_BrainDie(mo)
```

Completes the Icon of Sin sequence by exiting the level.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `mo` | `dynamic` | — | Map object affected by the operation. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_enemy.ml#L1552)

<a id="function-function-a-brainexplode-function-a-brainexplode-mo-src-p-enemy-ml-544424995"></a>
### A_BrainExplode

```ml
function A_BrainExplode(mo)
```

Spawns one randomized explosion/fireball above the Icon of Sin during its death sequence.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `mo` | `dynamic` | — | Map object affected by the operation. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_enemy.ml#L1537)

<a id="function-function-a-brainpain-function-a-brainpain-mo-src-p-enemy-ml-670665675"></a>
### A_BrainPain

```ml
function A_BrainPain(mo)
```

Plays the Icon of Sin pain sound globally.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `mo` | `dynamic` | — | Map object affected by the operation. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_enemy.ml#L1508)

<a id="function-function-a-brainscream-function-a-brainscream-mo-src-p-enemy-ml-265427341"></a>
### A_BrainScream

```ml
function A_BrainScream(mo)
```

Spawns a row of randomized explosions above the Icon of Sin and starts its death sound.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `mo` | `dynamic` | — | Map object affected by the operation. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_enemy.ml#L1515)

<a id="function-function-a-brainspit-function-a-brainspit-mo-src-p-enemy-ml-891514255"></a>
### A_BrainSpit

```ml
function A_BrainSpit(mo)
```

Cycles boss targets, applies the easy-skill cadence, and launches a spawn cube timed to its destination.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `mo` | `dynamic` | — | Map object affected by the operation. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_enemy.ml#L1559)

<a id="function-function-a-bruisattack-function-a-bruisattack-actor-src-p-enemy-ml-1236799230"></a>
### A_BruisAttack

```ml
function A_BruisAttack(actor)
```

Faces the target, performs a Baron/Hell Knight melee strike, or launches a green plasma projectile.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `actor` | `dynamic` | — | Actor value supplied to `A_BruisAttack`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_enemy.ml#L834)

<a id="function-function-a-bspiattack-function-a-bspiattack-actor-src-p-enemy-ml-1881790900"></a>
### A_BspiAttack

```ml
function A_BspiAttack(actor)
```

Faces the target and launches an arachnotron plasma projectile.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `actor` | `dynamic` | — | Actor value supplied to `A_BspiAttack`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_enemy.ml#L780)

<a id="function-function-a-chase-function-a-chase-actor-src-p-enemy-ml-402784232"></a>
### A_Chase

```ml
function A_Chase(actor)
```

Turns and pursues the target, retargets when needed, selects melee/missile attacks, and chooses new paths when blocked.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `actor` | `dynamic` | — | Actor value supplied to `A_Chase`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_enemy.ml#L629)

<a id="function-function-a-closeshotgun2-function-a-closeshotgun2-player-psp-src-p-enemy-ml-671068709"></a>
### A_CloseShotgun2

```ml
function A_CloseShotgun2(player, psp)
```

Plays the super-shotgun closing sound and immediately re-enters refire logic.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `player` | `dynamic` | — | Player state affected by the operation. |
| `psp` | `dynamic` | — | Psp value supplied to `A_CloseShotgun2`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_enemy.ml#L1470)

<a id="function-function-a-cposattack-function-a-cposattack-actor-src-p-enemy-ml-1155549244"></a>
### A_CPosAttack

```ml
function A_CPosAttack(actor)
```

Faces the target and fires one chaingunner hitscan with pistol audio, spread, and randomized damage.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `actor` | `dynamic` | — | Actor value supplied to `A_CPosAttack`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_enemy.ml#L745)

<a id="function-function-a-cposrefire-function-a-cposrefire-actor-src-p-enemy-ml-2139858900"></a>
### A_CPosRefire

```ml
function A_CPosRefire(actor)
```

Continues chaingunner fire while the random check and target visibility pass, otherwise returns to seestate.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `actor` | `dynamic` | — | Actor value supplied to `A_CPosRefire`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_enemy.ml#L758)

<a id="function-function-a-cyberattack-function-a-cyberattack-actor-src-p-enemy-ml-967729894"></a>
### A_CyberAttack

```ml
function A_CyberAttack(actor)
```

Faces the target and launches one Cyberdemon rocket.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `actor` | `dynamic` | — | Actor value supplied to `A_CyberAttack`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_enemy.ml#L826)

<a id="function-function-a-explode-function-a-explode-thingy-src-p-enemy-ml-516321202"></a>
### A_Explode

```ml
function A_Explode(thingy)
```

Applies the standard 128-damage, 128-radius explosion centered on the actor.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `thingy` | `dynamic` | — | Thingy value supplied to `A_Explode`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_enemy.ml#L1315)

<a id="function-function-a-facetarget-function-a-facetarget-actor-src-p-enemy-ml-1350337244"></a>
### A_FaceTarget

```ml
function A_FaceTarget(actor)
```

Clears ambush, aims exactly at the target, and adds random angular jitter when the target is shadowed.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `actor` | `dynamic` | — | Actor value supplied to `A_FaceTarget`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_enemy.ml#L704)

<a id="function-function-a-fall-function-a-fall-actor-src-p-enemy-ml-1408647940"></a>
### A_Fall

```ml
function A_Fall(actor)
```

Clears MF_SOLID from a dead actor so corpses no longer block movement.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `actor` | `dynamic` | — | Actor value supplied to `A_Fall`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_enemy.ml#L561)

<a id="function-function-a-fatattack1-function-a-fatattack1-actor-src-p-enemy-ml-32663876"></a>
### A_FatAttack1

```ml
function A_FatAttack1(actor)
```

Turns slightly right and launches the first two-projectile Mancubus spread pair.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `actor` | `dynamic` | — | Actor value supplied to `A_FatAttack1`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_enemy.ml#L1127)

<a id="function-function-a-fatattack2-function-a-fatattack2-actor-src-p-enemy-ml-1073575896"></a>
### A_FatAttack2

```ml
function A_FatAttack2(actor)
```

Turns left and launches the second two-projectile Mancubus spread pair.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `actor` | `dynamic` | — | Actor value supplied to `A_FatAttack2`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_enemy.ml#L1146)

<a id="function-function-a-fatattack3-function-a-fatattack3-actor-src-p-enemy-ml-1122802460"></a>
### A_FatAttack3

```ml
function A_FatAttack3(actor)
```

Launches the final Mancubus pair on diverging angles around the target direction.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `actor` | `dynamic` | — | Actor value supplied to `A_FatAttack3`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_enemy.ml#L1165)

<a id="function-function-a-fatraise-function-a-fatraise-actor-src-p-enemy-ml-1156702704"></a>
### A_FatRaise

```ml
function A_FatRaise(actor)
```

Faces the target and plays the Mancubus weapon-raise sound before its volley.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `actor` | `dynamic` | — | Actor value supplied to `A_FatRaise`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_enemy.ml#L1119)

<a id="function-function-a-fire-function-a-fire-actor-src-p-enemy-ml-1003134652"></a>
### A_Fire

```ml
function A_Fire(actor)
```

Keeps an Arch-vile fire actor in front of its traced victim while the owner retains line of sight.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `actor` | `dynamic` | — | Actor value supplied to `A_Fire`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_enemy.ml#L1058)

<a id="function-function-a-firecrackle-function-a-firecrackle-actor-src-p-enemy-ml-2128786222"></a>
### A_FireCrackle

```ml
function A_FireCrackle(actor)
```

Plays the Arch-vile flame crackle and updates the fire actor's attachment to its victim.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `actor` | `dynamic` | — | Actor value supplied to `A_FireCrackle`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_enemy.ml#L1050)

<a id="function-function-a-headattack-function-a-headattack-actor-src-p-enemy-ml-438363492"></a>
### A_HeadAttack

```ml
function A_HeadAttack(actor)
```

Faces the target, bites in melee, or launches a cacodemon projectile at range.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `actor` | `dynamic` | — | Actor value supplied to `A_HeadAttack`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_enemy.ml#L813)

<a id="function-function-a-hoof-function-a-hoof-mo-src-p-enemy-ml-421290175"></a>
### A_Hoof

```ml
function A_Hoof(mo)
```

Plays the Cyberdemon hoofstep and continues chase processing.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `mo` | `dynamic` | — | Map object affected by the operation. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_enemy.ml#L1428)

<a id="function-function-a-keendie-function-a-keendie-mo-src-p-enemy-ml-1327958005"></a>
### A_KeenDie

```ml
function A_KeenDie(mo)
```

Makes a Keen corpse non-solid and opens tagged door 666 only after the last living Keen dies.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `mo` | `dynamic` | — | Map object affected by the operation. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_enemy.ml#L568)

<a id="function-function-a-loadshotgun2-function-a-loadshotgun2-player-psp-src-p-enemy-ml-733555045"></a>
### A_LoadShotgun2

```ml
function A_LoadShotgun2(player, psp)
```

Plays the super-shotgun shell-loading sound during the player's reload animation.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `player` | `dynamic` | — | Player state affected by the operation. |
| `psp` | `dynamic` | — | Psp value supplied to `A_LoadShotgun2`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_enemy.ml#L1460)

<a id="function-function-a-look-function-a-look-actor-src-p-enemy-ml-1943150700"></a>
### A_Look

```ml
function A_Look(actor)
```

Leaves a monster idle until it hears a valid target or sees a player, then plays its wake sound and enters seestate.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `actor` | `dynamic` | — | Actor value supplied to `A_Look`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_enemy.ml#L581)

<a id="function-function-a-metal-function-a-metal-mo-src-p-enemy-ml-1753458177"></a>
### A_Metal

```ml
function A_Metal(mo)
```

Plays the Spider Mastermind metal step and continues chase processing.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `mo` | `dynamic` | — | Map object affected by the operation. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_enemy.ml#L1435)

<a id="function-function-a-openshotgun2-function-a-openshotgun2-player-psp-src-p-enemy-ml-1740103801"></a>
### A_OpenShotgun2

```ml
function A_OpenShotgun2(player, psp)
```

Plays the super-shotgun breech-opening sound during the player's reload animation.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `player` | `dynamic` | — | Player state affected by the operation. |
| `psp` | `dynamic` | — | Psp value supplied to `A_OpenShotgun2`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_enemy.ml#L1450)

<a id="function-function-a-pain-function-a-pain-actor-src-p-enemy-ml-1469000624"></a>
### A_Pain

```ml
function A_Pain(actor)
```

Plays the actor type's configured pain sound.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `actor` | `dynamic` | — | Actor value supplied to `A_Pain`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_enemy.ml#L1306)

<a id="function-function-a-painattack-function-a-painattack-actor-src-p-enemy-ml-974460048"></a>
### A_PainAttack

```ml
function A_PainAttack(actor)
```

Faces the target and emits one Lost Soul straight ahead.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `actor` | `dynamic` | — | Actor value supplied to `A_PainAttack`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_enemy.ml#L1261)

<a id="function-function-a-paindie-function-a-paindie-actor-src-p-enemy-ml-1411442724"></a>
### A_PainDie

```ml
function A_PainDie(actor)
```

Makes the Pain Elemental corpse non-solid and emits three Lost Souls in separated directions.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `actor` | `dynamic` | — | Actor value supplied to `A_PainDie`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_enemy.ml#L1269)

<a id="function-function-a-painshootskull-function-a-painshootskull-actor-angle-src-p-enemy-ml-751248139"></a>
### A_PainShootSkull

```ml
function A_PainShootSkull(actor, angle)
```

Public action wrapper that spawns and launches one Lost Soul at the requested angle.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `actor` | `dynamic` | — | Actor value supplied to `A_PainShootSkull`. |
| `angle` | `dynamic` | — | Doom binary-angle measurement. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_enemy.ml#L1255)

<a id="function-function-a-playerscream-function-a-playerscream-mo-src-p-enemy-ml-2068832627"></a>
### A_PlayerScream

```ml
function A_PlayerScream(mo)
```

Selects the normal or commercial extreme player death scream from the victim's health and plays it at the corpse.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `mo` | `dynamic` | — | Map object affected by the operation. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_enemy.ml#L1663)

<a id="function-function-a-posattack-function-a-posattack-actor-src-p-enemy-ml-623318456"></a>
### A_PosAttack

```ml
function A_PosAttack(actor)
```

Faces the target, plays the pistol sound, and fires one spread hitscan with randomized bullet damage.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `actor` | `dynamic` | — | Actor value supplied to `A_PosAttack`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_enemy.ml#L716)

<a id="function-function-a-sargattack-function-a-sargattack-actor-src-p-enemy-ml-397434868"></a>
### A_SargAttack

```ml
function A_SargAttack(actor)
```

Faces the target and applies the demon's randomized melee bite when in range.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `actor` | `dynamic` | — | Actor value supplied to `A_SargAttack`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_enemy.ml#L802)

<a id="function-function-a-scream-function-a-scream-actor-src-p-enemy-ml-800727680"></a>
### A_Scream

```ml
function A_Scream(actor)
```

Selects variant death audio for certain monster families and plays boss deaths at full-volume origin.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `actor` | `dynamic` | — | Actor value supplied to `A_Scream`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_enemy.ml#L1279)

<a id="function-function-a-skelfist-function-a-skelfist-actor-src-p-enemy-ml-1350978016"></a>
### A_SkelFist

```ml
function A_SkelFist(actor)
```

Faces the target and applies the Revenant's randomized punch damage when still in melee range.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `actor` | `dynamic` | — | Actor value supplied to `A_SkelFist`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_enemy.ml#L929)

<a id="function-function-a-skelmissile-function-a-skelmissile-actor-src-p-enemy-ml-1543460206"></a>
### A_SkelMissile

```ml
function A_SkelMissile(actor)
```

Faces the target, launches a Revenant tracer missile, and advances it outward from the actor before homing begins.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `actor` | `dynamic` | — | Actor value supplied to `A_SkelMissile`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_enemy.ml#L848)

<a id="function-function-a-skelwhoosh-function-a-skelwhoosh-actor-src-p-enemy-ml-1100162812"></a>
### A_SkelWhoosh

```ml
function A_SkelWhoosh(actor)
```

Faces the target and plays the Revenant melee swing sound.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `actor` | `dynamic` | — | Actor value supplied to `A_SkelWhoosh`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_enemy.ml#L921)

<a id="function-function-a-skullattack-function-a-skullattack-actor-src-p-enemy-ml-1949735670"></a>
### A_SkullAttack

```ml
function A_SkullAttack(actor)
```

Faces the target, enters MF_SKULLFLY, plays attack audio, and sets charge momentum toward target center.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `actor` | `dynamic` | — | Actor value supplied to `A_SkullAttack`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_enemy.ml#L1192)

<a id="function-function-a-spawnfly-function-a-spawnfly-mo-src-p-enemy-ml-1524945083"></a>
### A_SpawnFly

```ml
function A_SpawnFly(mo)
```

Advances a spawn cube's countdown, teleports in a weighted-random monster at its target, and removes the cube.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `mo` | `dynamic` | — | Map object affected by the operation. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_enemy.ml#L1599)

<a id="function-function-a-spawnsound-function-a-spawnsound-mo-src-p-enemy-ml-37339459"></a>
### A_SpawnSound

```ml
function A_SpawnSound(mo)
```

Plays the spawn-cube travel sound and advances its spawn countdown/action.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `mo` | `dynamic` | — | Map object affected by the operation. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_enemy.ml#L1655)

<a id="function-function-a-spidrefire-function-a-spidrefire-actor-src-p-enemy-ml-56669504"></a>
### A_SpidRefire

```ml
function A_SpidRefire(actor)
```

Continues Spider Mastermind fire while its randomized stop check and target visibility pass.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `actor` | `dynamic` | — | Actor value supplied to `A_SpidRefire`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_enemy.ml#L769)

<a id="function-function-a-sposattack-function-a-sposattack-actor-src-p-enemy-ml-828407708"></a>
### A_SPosAttack

```ml
function A_SPosAttack(actor)
```

Faces the target, plays the shotgun sound, and fires three independent spread hitscans.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `actor` | `dynamic` | — | Actor value supplied to `A_SPosAttack`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_enemy.ml#L729)

<a id="function-function-a-startfire-function-a-startfire-actor-src-p-enemy-ml-4128964"></a>
### A_StartFire

```ml
function A_StartFire(actor)
```

Starts the Arch-vile flame sound and immediately positions its fire actor relative to the victim.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `actor` | `dynamic` | — | Actor value supplied to `A_StartFire`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_enemy.ml#L1042)

<a id="function-function-a-tracer-function-a-tracer-actor-src-p-enemy-ml-1398278016"></a>
### A_Tracer

```ml
function A_Tracer(actor)
```

Periodically spawns smoke and steers a Revenant missile's angle and vertical momentum toward its live tracer target.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `actor` | `dynamic` | — | Actor value supplied to `A_Tracer`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_enemy.ml#L864)

<a id="function-function-a-troopattack-function-a-troopattack-actor-src-p-enemy-ml-220725572"></a>
### A_TroopAttack

```ml
function A_TroopAttack(actor)
```

Faces the target, performs an imp claw attack in melee, or launches an imp fireball at range.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `actor` | `dynamic` | — | Actor value supplied to `A_TroopAttack`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_enemy.ml#L788)

<a id="function-function-a-vileattack-function-a-vileattack-actor-src-p-enemy-ml-190774116"></a>
### A_VileAttack

```ml
function A_VileAttack(actor)
```

Applies the Arch-vile blast, vertical thrust, radius damage, and final fire placement when sight remains clear.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `actor` | `dynamic` | — | Actor value supplied to `A_VileAttack`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_enemy.ml#L1093)

<a id="function-function-a-vilechase-function-a-vilechase-actor-src-p-enemy-ml-375948540"></a>
### A_VileChase

```ml
function A_VileChase(actor)
```

Searches the next movement block for a raisable corpse, resurrects it when found, otherwise runs normal chase logic.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `actor` | `dynamic` | — | Actor value supplied to `A_VileChase`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_enemy.ml#L981)

<a id="function-function-a-vilestart-function-a-vilestart-actor-src-p-enemy-ml-1552077500"></a>
### A_VileStart

```ml
function A_VileStart(actor)
```

Plays the Arch-vile's attack-start sound.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `actor` | `dynamic` | — | Actor value supplied to `A_VileStart`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_enemy.ml#L1035)

<a id="function-function-a-viletarget-function-a-viletarget-actor-src-p-enemy-ml-930643528"></a>
### A_VileTarget

```ml
function A_VileTarget(actor)
```

Faces the victim, spawns the Arch-vile fire actor, and links owner/victim references used by later fire actions.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `actor` | `dynamic` | — | Actor value supplied to `A_VileTarget`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_enemy.ml#L1077)

<a id="function-function-a-xscream-function-a-xscream-actor-src-p-enemy-ml-1914016882"></a>
### A_XScream

```ml
function A_XScream(actor)
```

Plays the universal gib/slop sound for an extreme death animation.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `actor` | `dynamic` | — | Actor value supplied to `A_XScream`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_enemy.ml#L1300)

<a id="global-global-braintargeton-braintargeton-src-p-enemy-ml-1636512169"></a>
### braintargeton

```ml
braintargeton
```

Tracks the mutable braintargeton value used by the p enemy subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_enemy.ml#L95)

<a id="global-global-braintargets-braintargets-src-p-enemy-ml-836658013"></a>
### braintargets

```ml
braintargets
```

Stores the braintargets collection used by the p enemy subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_enemy.ml#L91)

<a id="global-global-corpsehit-corpsehit-src-p-enemy-ml-1369683817"></a>
### corpsehit

```ml
corpsehit
```

Holds the optional corpsehit resource used by the p enemy subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_enemy.ml#L83)

<a id="constant-constant-di-east-const-di-east-0-src-p-enemy-ml-1726977380"></a>
### DI_EAST

```ml
const DI_EAST = 0
```

Defines di east for the p enemy subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_enemy.ml#L44)

<a id="constant-constant-di-nodir-const-di-nodir-8-src-p-enemy-ml-1375168862"></a>
### DI_NODIR

```ml
const DI_NODIR = 8
```

Defines di nodir for the p enemy subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_enemy.ml#L60)

<a id="constant-constant-di-north-const-di-north-2-src-p-enemy-ml-733528930"></a>
### DI_NORTH

```ml
const DI_NORTH = 2
```

Defines di north for the p enemy subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_enemy.ml#L48)

<a id="constant-constant-di-northeast-const-di-northeast-1-src-p-enemy-ml-762722723"></a>
### DI_NORTHEAST

```ml
const DI_NORTHEAST = 1
```

Defines di northeast for the p enemy subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_enemy.ml#L46)

<a id="constant-constant-di-northwest-const-di-northwest-3-src-p-enemy-ml-400198349"></a>
### DI_NORTHWEST

```ml
const DI_NORTHWEST = 3
```

Defines di northwest for the p enemy subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_enemy.ml#L50)

<a id="constant-constant-di-south-const-di-south-6-src-p-enemy-ml-1960991782"></a>
### DI_SOUTH

```ml
const DI_SOUTH = 6
```

Defines di south for the p enemy subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_enemy.ml#L56)

<a id="constant-constant-di-southeast-const-di-southeast-7-src-p-enemy-ml-156645701"></a>
### DI_SOUTHEAST

```ml
const DI_SOUTHEAST = 7
```

Defines di southeast for the p enemy subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_enemy.ml#L58)

<a id="constant-constant-di-southwest-const-di-southwest-5-src-p-enemy-ml-2014999619"></a>
### DI_SOUTHWEST

```ml
const DI_SOUTHWEST = 5
```

Defines di southwest for the p enemy subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_enemy.ml#L54)

<a id="constant-constant-di-west-const-di-west-4-src-p-enemy-ml-334329556"></a>
### DI_WEST

```ml
const DI_WEST = 4
```

Defines di west for the p enemy subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_enemy.ml#L52)

<a id="global-global-diags-diags-src-p-enemy-ml-1688898085"></a>
### diags

```ml
diags
```

Stores the diags collection used by the p enemy subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_enemy.ml#L67)

<a id="constant-constant-fatspread-const-fatspread-ang90-3-src-p-enemy-ml-2024002384"></a>
### FATSPREAD

```ml
const FATSPREAD = ANG90 >> 3
```

Defines fatspread for the p enemy subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_enemy.ml#L76)

<a id="global-global-numbraintargets-numbraintargets-src-p-enemy-ml-1011164109"></a>
### numbraintargets

```ml
numbraintargets
```

Tracks the mutable numbraintargets value used by the p enemy subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_enemy.ml#L93)

<a id="global-global-opposite-opposite-src-p-enemy-ml-1723171359"></a>
### opposite

```ml
opposite
```

Stores the opposite collection used by the p enemy subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_enemy.ml#L65)

<a id="function-function-p-checkmeleerange-function-p-checkmeleerange-actor-src-p-enemy-ml-10277128"></a>
### P_CheckMeleeRange

```ml
function P_CheckMeleeRange(actor)
```

Requires a live target within radius-adjusted melee distance, modest vertical separation, and line of sight.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `actor` | `dynamic` | — | Actor value supplied to `P_CheckMeleeRange`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_enemy.ml#L299)

<a id="function-function-p-checkmissilerange-function-p-checkmissilerange-actor-src-p-enemy-ml-1024443264"></a>
### P_CheckMissileRange

```ml
function P_CheckMissileRange(actor)
```

Applies sight, reaction, distance, melee-capability, and randomized aggression rules before a monster fires.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `actor` | `dynamic` | — | Actor value supplied to `P_CheckMissileRange`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_enemy.ml#L315)

<a id="function-function-p-forgetplayertarget-function-p-forgetplayertarget-playermo-src-p-enemy-ml-284822990"></a>
### P_ForgetPlayerTarget

```ml
function P_ForgetPlayerTarget(playerMo)
```

Makes active monsters and sector sound emitters immediately forget one newly hidden player.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `playerMo` | `dynamic` | — | Player mo value supplied to `P_ForgetPlayerTarget`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_enemy.ml#L187)

<a id="function-function-p-lookforplayers-function-p-lookforplayers-actor-allaround-src-p-enemy-ml-1969698702"></a>
### P_LookForPlayers

```ml
function P_LookForPlayers(actor, allaround)
```

Cycles active living players, enforcing field-of-view unless allaround, and acquires the first visible target.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `actor` | `dynamic` | — | Actor value supplied to `P_LookForPlayers`. |
| `allaround` | `dynamic` | — | Allaround value supplied to `P_LookForPlayers`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_enemy.ml#L501)

<a id="function-function-p-move-function-p-move-actor-src-p-enemy-ml-1136750292"></a>
### P_Move

```ml
function P_Move(actor)
```

Attempts one movedir step, adjusts floating monsters, and activates crossed special lines when blocked.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `actor` | `dynamic` | — | Actor value supplied to `P_Move`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_enemy.ml#L353)

<a id="function-function-p-newchasedir-function-p-newchasedir-actor-src-p-enemy-ml-1662507220"></a>
### P_NewChaseDir

```ml
function P_NewChaseDir(actor)
```

Chooses diagonal or cardinal movement toward the target while avoiding immediate turnaround and blocked directions.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `actor` | `dynamic` | — | Actor value supplied to `P_NewChaseDir`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_enemy.ml#L411)

<a id="function-function-p-noisealert-function-p-noisealert-target-emmiter-src-p-enemy-ml-1747912413"></a>
### P_NoiseAlert

```ml
function P_NoiseAlert(target, emmiter)
```

Starts a new sound-validity flood from the emitter's sector so monsters acquire target as their sound target.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `target` | `dynamic` | — | Target value supplied to `P_NoiseAlert`. |
| `emmiter` | `dynamic` | — | Emmiter value supplied to `P_NoiseAlert`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_enemy.ml#L284)

<a id="function-function-p-recursivesound-function-p-recursivesound-sec-soundblocks-src-p-enemy-ml-75493233"></a>
### P_RecursiveSound

```ml
function P_RecursiveSound(sec, soundblocks)
```

Floods a noise target through open two-sided sectors, crossing at most one sound-blocking line.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `sec` | `dynamic` | — | Sec value supplied to `P_RecursiveSound`. |
| `soundblocks` | `dynamic` | — | Soundblocks value supplied to `P_RecursiveSound`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_enemy.ml#L235)

<a id="function-function-p-trywalk-function-p-trywalk-actor-src-p-enemy-ml-2059769982"></a>
### P_TryWalk

```ml
function P_TryWalk(actor)
```

Performs one monster move and randomizes the number of tics before its next chase-direction choice.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `actor` | `dynamic` | — | Actor value supplied to `P_TryWalk`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_enemy.ml#L402)

<a id="constant-constant-pe-fracunit-const-pe-fracunit-65536-src-p-enemy-ml-1106928343"></a>
### PE_FRACUNIT

```ml
const PE_FRACUNIT = 65536
```

Defines pe fracunit for the p enemy subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_enemy.ml#L62)

<a id="function-function-pit-vilecheck-function-pit-vilecheck-thing-src-p-enemy-ml-1149051085"></a>
### PIT_VileCheck

```ml
function PIT_VileCheck(thing)
```

Tests whether a nearby corpse is raiseable at the Arch-vile destination and records the first valid resurrection candidate.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `thing` | `dynamic` | — | World object affected by the operation. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_enemy.ml#L942)

<a id="constant-constant-skullspeed-const-skullspeed-20-pe-fracunit-src-p-enemy-ml-536485990"></a>
### SKULLSPEED

```ml
const SKULLSPEED = 20 * PE_FRACUNIT
```

Defines skullspeed for the p enemy subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_enemy.ml#L78)

<a id="global-global-soundtarget-soundtarget-src-p-enemy-ml-1282494221"></a>
### soundtarget

```ml
soundtarget
```

Holds the optional soundtarget resource used by the p enemy subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_enemy.ml#L81)

<a id="constant-constant-traceangle-const-traceangle-201326592-src-p-enemy-ml-650213140"></a>
### TRACEANGLE

```ml
const TRACEANGLE = 201326592
```

Defines traceangle for the p enemy subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_enemy.ml#L74)

<a id="global-global-vileobj-vileobj-src-p-enemy-ml-1996253165"></a>
### vileobj

```ml
vileobj
```

Holds the optional vileobj resource used by the p enemy subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_enemy.ml#L85)

<a id="global-global-viletryx-viletryx-src-p-enemy-ml-1634229603"></a>
### viletryx

```ml
viletryx
```

Tracks the mutable viletryx value used by the p enemy subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_enemy.ml#L87)

<a id="global-global-viletryy-viletryy-src-p-enemy-ml-486709485"></a>
### viletryy

```ml
viletryy
```

Tracks the mutable viletryy value used by the p enemy subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_enemy.ml#L89)

<a id="global-global-xspeed-xspeed-src-p-enemy-ml-622401083"></a>
### xspeed

```ml
xspeed
```

Stores the xspeed collection used by the p enemy subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_enemy.ml#L69)

<a id="global-global-yspeed-yspeed-src-p-enemy-ml-1495589957"></a>
### yspeed

```ml
yspeed
```

Stores the yspeed collection used by the p enemy subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_enemy.ml#L71)
