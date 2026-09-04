# `src/p_pspr.ml`

[Home](README.md) · [Files](Files.md)

Drives first-person weapon sprites, ammo/state transitions, hitscan attacks, and player-fired projectiles.

Package: [`(global)`](Package-global-1952375359.md)

Reachable from entry: **yes**

## Imports

- `d_event.ml` → [src/d_event.ml](File-src-d-event-ml-1995118760.md)
- `doomdef.ml` → [src/doomdef.ml](File-src-doomdef-ml-460406769.md)
- `doomstat.ml` → [src/doomstat.ml](File-src-doomstat-ml-1652708088.md)
- `info.ml` → [src/info.ml](File-src-info-ml-1415270573.md)
- `m_argv.ml` → [src/m_argv.ml](File-src-m-argv-ml-728984635.md)
- `m_fixed.ml` → [src/m_fixed.ml](File-src-m-fixed-ml-2129187227.md)
- `m_random.ml` → [src/m_random.ml](File-src-m-random-ml-1659574948.md)
- `p_enemy.ml` → [src/p_enemy.ml](File-src-p-enemy-ml-1875479956.md)
- `p_inter.ml` → [src/p_inter.ml](File-src-p-inter-ml-1430401638.md)
- `p_local.ml` → [src/p_local.ml](File-src-p-local-ml-1043095437.md)
- `p_map.ml` → [src/p_map.ml](File-src-p-map-ml-882556686.md)
- `p_mobj.ml` → [src/p_mobj.ml](File-src-p-mobj-ml-1335564114.md)
- `p_pspr.ml` → [src/p_pspr.ml](File-src-p-pspr-ml-844718747.md)
- `r_main.ml` → [src/r_main.ml](File-src-r-main-ml-1902335243.md)
- `s_sound.ml` → [src/s_sound.ml](File-src-s-sound-ml-1485495390.md)
- `sounds.ml` → [src/sounds.ml](File-src-sounds-ml-1875364049.md)
- `tables.ml` → [src/tables.ml](File-src-tables-ml-1959718242.md)

## Declarations

<a id="function-function-ensurepsprites-function-ensurepsprites-player-src-p-pspr-ml-1714897315"></a>
### _ensurePsprites

```ml
function _ensurePsprites(player)
```

Ensures every player owns initialized weapon and flash sprite slots without replacing existing state.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `player` | `dynamic` | — | Player state affected by the operation. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_pspr.ml#L310)

<a id="function-function-ps-ammoindex-inline-function-ps-ammoindex-a-src-p-pspr-ml-1571193666"></a>
### _PS_AmmoIndex

```ml
inline function _PS_AmmoIndex(a)
```

Maps clip, shell, cell, or missile ammo identifiers to the player's four ammo slots.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `a` | `dynamic` | — | First input operand. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_pspr.ml#L173)

<a id="constant-constant-ps-ang90-div20-const-ps-ang90-div20-53687091-src-p-pspr-ml-1527821002"></a>
### _PS_ANG90_DIV20

```ml
const _PS_ANG90_DIV20 = 53687091
```

Defines ps ang90 div20 for the p pspr subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_pspr.ml#L92)

<a id="constant-constant-ps-ang90-div21-const-ps-ang90-div21-51130563-src-p-pspr-ml-1888106743"></a>
### _PS_ANG90_DIV21

```ml
const _PS_ANG90_DIV21 = 51130563
```

Defines ps ang90 div21 for the p pspr subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_pspr.ml#L95)

<a id="constant-constant-ps-ang90-div40-const-ps-ang90-div40-26843545-src-p-pspr-ml-1715244034"></a>
### _PS_ANG90_DIV40

```ml
const _PS_ANG90_DIV40 = 26843545
```

Defines ps ang90 div40 for the p pspr subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_pspr.ml#L98)

<a id="function-function-ps-diagfireenabled-function-ps-diagfireenabled-src-p-pspr-ml-891650688"></a>
### _PS_DiagFireEnabled

```ml
function _PS_DiagFireEnabled()
```

Lazily parses the -diagfire option once and announces whether throttled weapon-fire tracing is enabled.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_pspr.ml#L120)

<a id="function-function-ps-diagfirelog-inline-function-ps-diagfirelog-msg-src-p-pspr-ml-459771176"></a>
### _PS_DiagFireLog

```ml
inline function _PS_DiagFireLog(msg)
```

Emits bounded diagnostic fire messages for the first 120 events and every 256th event thereafter.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `msg` | `dynamic` | — | Msg value supplied to `_PS_DiagFireLog`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_pspr.ml#L140)

<a id="function-function-ps-getammocount-inline-function-ps-getammocount-player-ammotype-src-p-pspr-ml-1139952068"></a>
### _PS_GetAmmoCount

```ml
inline function _PS_GetAmmoCount(player, ammoType)
```

Reads a player's validated ammo slot as an integer count, accepting legacy boolean entries.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `player` | `dynamic` | — | Player state affected by the operation. |
| `ammoType` | `dynamic` | — | Ammo type value supplied to `_PS_GetAmmoCount`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_pspr.ml#L217)

<a id="constant-constant-ps-half-fineangles-const-ps-half-fineangles-4096-src-p-pspr-ml-1265413114"></a>
### _PS_HALF_FINEANGLES

```ml
const _PS_HALF_FINEANGLES = 4096
```

Defines ps half fineangles for the p pspr subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_pspr.ml#L89)

<a id="function-function-ps-hasweapon-inline-function-ps-hasweapon-player-weapontype-src-p-pspr-ml-331169760"></a>
### _PS_HasWeapon

```ml
inline function _PS_HasWeapon(player, weaponType)
```

Tests a validated weapon-owned slot without assuming the ownership table is present or complete.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `player` | `dynamic` | — | Player state affected by the operation. |
| `weaponType` | `dynamic` | — | Weapon type value supplied to `_PS_HasWeapon`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_pspr.ml#L249)

<a id="function-function-ps-mobjinstate-inline-function-ps-mobjinstate-mo-stnum-src-p-pspr-ml-295297352"></a>
### _PS_MobjInState

```ml
inline function _PS_MobjInState(mo, stnum)
```

Tests whether an mobj currently references the resolved state for a state identifier.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `mo` | `dynamic` | — | Map object affected by the operation. |
| `stnum` | `dynamic` | — | Index identifying st. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_pspr.ml#L289)

<a id="function-function-ps-playsound-inline-function-ps-playsound-origin-sfx-src-p-pspr-ml-1245918704"></a>
### _PS_PlaySound

```ml
inline function _PS_PlaySound(origin, sfx)
```

Starts a weapon sound when the audio subsystem is linked, otherwise leaves weapon logic unaffected.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `origin` | `dynamic` | — | Origin value supplied to `_PS_PlaySound`. |
| `sfx` | `dynamic` | — | Sound-effect descriptor to process. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_pspr.ml#L301)

<a id="function-function-ps-powerindex-function-ps-powerindex-pw-src-p-pspr-ml-52179729"></a>
### _PS_PowerIndex

```ml
function _PS_PowerIndex(pw)
```

Maps a player power enum or validated integer to its six-entry powers array slot.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `pw` | `dynamic` | — | Pw value supplied to `_PS_PowerIndex`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_pspr.ml#L188)

<a id="function-function-ps-pspriteinstate-inline-function-ps-pspriteinstate-psp-stnum-src-p-pspr-ml-668201937"></a>
### _PS_PSpriteInState

```ml
inline function _PS_PSpriteInState(psp, stnum)
```

Tests whether a player-sprite currently references the resolved state for a state identifier.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `psp` | `dynamic` | — | Psp value supplied to `_PS_PSpriteInState`. |
| `stnum` | `dynamic` | — | Index identifying st. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_pspr.ml#L277)

<a id="function-function-ps-setammocount-inline-function-ps-setammocount-player-ammotype-value-src-p-pspr-ml-1922981961"></a>
### _PS_SetAmmoCount

```ml
inline function _PS_SetAmmoCount(player, ammoType, value)
```

Stores a non-negative integer in a validated player ammo slot.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `player` | `dynamic` | — | Player state affected by the operation. |
| `ammoType` | `dynamic` | — | Ammo type value supplied to `_PS_SetAmmoCount`. |
| `value` | `dynamic` | — | Value consumed by the operation. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_pspr.ml#L234)

<a id="function-function-ps-stateobjectindex-function-ps-stateobjectindex-stobj-src-p-pspr-ml-1123285516"></a>
### _PS_StateObjectIndex

```ml
function _PS_StateObjectIndex(stobj)
```

Finds a state object's identity-based index in the global states table, returning -1 if absent.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `stobj` | `dynamic` | — | Stobj value supplied to `_PS_StateObjectIndex`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_pspr.ml#L262)

<a id="constant-constant-ps-swingstep-const-ps-swingstep-117-src-p-pspr-ml-918148296"></a>
### _PS_SWINGSTEP

```ml
const _PS_SWINGSTEP = 117
```

Defines ps swingstep for the p pspr subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_pspr.ml#L86)

<a id="function-function-ps-weaponindex-function-ps-weaponindex-w-src-p-pspr-ml-486422089"></a>
### _PS_WeaponIndex

```ml
function _PS_WeaponIndex(w)
```

Maps either a weapon enum or validated integer to the nine-entry weapon table, returning -1 on failure.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `w` | `dynamic` | — | W value supplied to `_PS_WeaponIndex`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_pspr.ml#L153)

<a id="function-function-ps-weaponinfo-inline-function-ps-weaponinfo-w-src-p-pspr-ml-202512540"></a>
### _PS_WeaponInfo

```ml
inline function _PS_WeaponInfo(w)
```

Resolves a validated weapon identifier to its weaponinfo entry.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `w` | `dynamic` | — | W value supplied to `_PS_WeaponInfo`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_pspr.ml#L205)

<a id="global-global-psdiagfire-psdiagfire-src-p-pspr-ml-1138279064"></a>
### _psDiagFire

```ml
_psDiagFire
```

Tracks whether ps diag fire is active in the p pspr subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_pspr.ml#L113)

<a id="global-global-psdiagfirecount-psdiagfirecount-src-p-pspr-ml-1715408108"></a>
### _psDiagFireCount

```ml
_psDiagFireCount
```

Tracks the mutable ps diag fire count value used by the p pspr subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_pspr.ml#L116)

<a id="global-global-psdiagfireinit-psdiagfireinit-src-p-pspr-ml-1293529572"></a>
### _psDiagFireInit

```ml
_psDiagFireInit
```

Tracks whether ps diag fire init is active in the p pspr subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_pspr.ml#L110)

<a id="function-function-a-bfgsound-function-a-bfgsound-player-psp-src-p-pspr-ml-1414761340"></a>
### A_BFGsound

```ml
function A_BFGsound(player, psp)
```

Starts the BFG firing sound at the player's mobj during the weapon animation.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `player` | `dynamic` | — | Player state affected by the operation. |
| `psp` | `dynamic` | — | Psp value supplied to `A_BFGsound`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_pspr.ml#L934)

<a id="function-function-a-bfgspray-function-a-bfgspray-mo-src-p-pspr-ml-1061472450"></a>
### A_BFGSpray

```ml
function A_BFGSpray(mo)
```

Traces forty rays across a 90-degree arc, spawning impact effects and applying fifteen-die damage to each target.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `mo` | `dynamic` | — | Map object affected by the operation. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_pspr.ml#L943)

<a id="function-function-a-checkreload-function-a-checkreload-player-psp-src-p-pspr-ml-2053285582"></a>
### A_CheckReload

```ml
function A_CheckReload(player, psp)
```

Rechecks the current weapon's ammo at a reload state and initiates fallback selection when empty.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `player` | `dynamic` | — | Player state affected by the operation. |
| `psp` | `dynamic` | — | Psp value supplied to `A_CheckReload`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_pspr.ml#L634)

<a id="function-function-a-firebfg-function-a-firebfg-player-psp-src-p-pspr-ml-498932770"></a>
### A_FireBFG

```ml
function A_FireBFG(player, psp)
```

Consumes BFGCELLS cells and spawns the BFG projectile from the player mobj.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `player` | `dynamic` | — | Player state affected by the operation. |
| `psp` | `dynamic` | — | Psp value supplied to `A_FireBFG`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_pspr.ml#L920)

<a id="function-function-a-firecgun-function-a-firecgun-player-psp-src-p-pspr-ml-1107191108"></a>
### A_FireCGun

```ml
function A_FireCGun(player, psp)
```

Consumes one bullet, selects the alternating chaingun flash, and fires one refire-sensitive hitscan.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `player` | `dynamic` | — | Player state affected by the operation. |
| `psp` | `dynamic` | — | Psp value supplied to `A_FireCGun`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_pspr.ml#L854)

<a id="function-function-a-firemissile-function-a-firemissile-player-psp-src-p-pspr-ml-598510132"></a>
### A_FireMissile

```ml
function A_FireMissile(player, psp)
```

Consumes one rocket and spawns a player-owned rocket projectile.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `player` | `dynamic` | — | Player state affected by the operation. |
| `psp` | `dynamic` | — | Psp value supplied to `A_FireMissile`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_pspr.ml#L888)

<a id="function-function-a-firepistol-function-a-firepistol-player-psp-src-p-pspr-ml-1609164352"></a>
### A_FirePistol

```ml
function A_FirePistol(player, psp)
```

Consumes one bullet, plays the pistol/flash animations, computes auto-aim, and fires one refire-sensitive hitscan.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `player` | `dynamic` | — | Player state affected by the operation. |
| `psp` | `dynamic` | — | Psp value supplied to `A_FirePistol`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_pspr.ml#L775)

<a id="function-function-a-fireplasma-function-a-fireplasma-player-psp-src-p-pspr-ml-614841636"></a>
### A_FirePlasma

```ml
function A_FirePlasma(player, psp)
```

Consumes one cell, randomly selects one of two flash states, and spawns a plasma projectile.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `player` | `dynamic` | — | Player state affected by the operation. |
| `psp` | `dynamic` | — | Psp value supplied to `A_FirePlasma`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_pspr.ml#L902)

<a id="function-function-a-fireshotgun-function-a-fireshotgun-player-psp-src-p-pspr-ml-1277193936"></a>
### A_FireShotgun

```ml
function A_FireShotgun(player, psp)
```

Consumes one shell and fires seven spread hitscans after starting the shotgun sound and flash.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `player` | `dynamic` | — | Player state affected by the operation. |
| `psp` | `dynamic` | — | Psp value supplied to `A_FireShotgun`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_pspr.ml#L798)

<a id="function-function-a-fireshotgun2-function-a-fireshotgun2-player-psp-src-p-pspr-ml-401862336"></a>
### A_FireShotgun2

```ml
function A_FireShotgun2(player, psp)
```

Consumes two shells and fires twenty independently randomized damage, angle, and slope pellets.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `player` | `dynamic` | — | Player state affected by the operation. |
| `psp` | `dynamic` | — | Psp value supplied to `A_FireShotgun2`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_pspr.ml#L825)

<a id="function-function-a-gunflash-function-a-gunflash-player-psp-src-p-pspr-ml-1125230964"></a>
### A_GunFlash

```ml
function A_GunFlash(player, psp)
```

Switches the player mobj to its flash attack pose and starts the ready weapon's muzzle-flash sprite.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `player` | `dynamic` | — | Player state affected by the operation. |
| `psp` | `dynamic` | — | Psp value supplied to `A_GunFlash`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_pspr.ml#L685)

<a id="function-function-a-light0-function-a-light0-player-psp-src-p-pspr-ml-924287496"></a>
### A_Light0

```ml
function A_Light0(player, psp)
```

Restores the player's weapon-flash extra light to zero.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `player` | `dynamic` | — | Player state affected by the operation. |
| `psp` | `dynamic` | — | Psp value supplied to `A_Light0`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_pspr.ml#L980)

<a id="function-function-a-light1-function-a-light1-player-psp-src-p-pspr-ml-563439452"></a>
### A_Light1

```ml
function A_Light1(player, psp)
```

Sets the player's weapon-flash extra light to level one.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `player` | `dynamic` | — | Player state affected by the operation. |
| `psp` | `dynamic` | — | Psp value supplied to `A_Light1`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_pspr.ml#L989)

<a id="function-function-a-light2-function-a-light2-player-psp-src-p-pspr-ml-171472604"></a>
### A_Light2

```ml
function A_Light2(player, psp)
```

Sets the player's weapon-flash extra light to level two.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `player` | `dynamic` | — | Player state affected by the operation. |
| `psp` | `dynamic` | — | Psp value supplied to `A_Light2`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_pspr.ml#L998)

<a id="function-function-a-lower-function-a-lower-player-psp-src-p-pspr-ml-1774162906"></a>
### A_Lower

```ml
function A_Lower(player, psp)
```

Moves the weapon toward the screen bottom, then removes it on death or commits and raises the pending weapon.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `player` | `dynamic` | — | Player state affected by the operation. |
| `psp` | `dynamic` | — | Psp value supplied to `A_Lower`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_pspr.ml#L644)

<a id="function-function-a-punch-function-a-punch-player-psp-src-p-pspr-ml-72189828"></a>
### A_Punch

```ml
function A_Punch(player, psp)
```

Performs a randomized melee hitscan, applies berserk damage scaling, and turns toward a struck target.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `player` | `dynamic` | — | Player state affected by the operation. |
| `psp` | `dynamic` | — | Psp value supplied to `A_Punch`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_pspr.ml#L699)

<a id="function-function-a-raise-function-a-raise-player-psp-src-p-pspr-ml-589110452"></a>
### A_Raise

```ml
function A_Raise(player, psp)
```

Moves the weapon toward WEAPONTOP and enters its ready state when fully raised.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `player` | `dynamic` | — | Player state affected by the operation. |
| `psp` | `dynamic` | — | Psp value supplied to `A_Raise`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_pspr.ml#L671)

<a id="function-function-a-refire-function-a-refire-player-psp-src-p-pspr-ml-1243259212"></a>
### A_ReFire

```ml
function A_ReFire(player, psp)
```

Continues held-trigger fire while alive and not switching, otherwise resets refire spread and rechecks ammo.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `player` | `dynamic` | — | Player state affected by the operation. |
| `psp` | `dynamic` | — | Psp value supplied to `A_ReFire`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_pspr.ml#L613)

<a id="function-function-a-saw-function-a-saw-player-psp-src-p-pspr-ml-866454506"></a>
### A_Saw

```ml
function A_Saw(player, psp)
```

Performs the chainsaw melee trace, selects idle/hit audio, steers toward a target, and sets the just-attacked flag.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `player` | `dynamic` | — | Player state affected by the operation. |
| `psp` | `dynamic` | — | Psp value supplied to `A_Saw`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_pspr.ml#L729)

<a id="function-function-a-weaponready-function-a-weaponready-player-psp-src-p-pspr-ml-1879350942"></a>
### A_WeaponReady

```ml
function A_WeaponReady(player, psp)
```

Restores the player idle state, handles attack/switch input, and applies the ready weapon's bobbing offsets.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `player` | `dynamic` | — | Player state affected by the operation. |
| `psp` | `dynamic` | — | Psp value supplied to `A_WeaponReady`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_pspr.ml#L560)

<a id="constant-constant-bfgcells-const-bfgcells-40-src-p-pspr-ml-733153455"></a>
### BFGCELLS

```ml
const BFGCELLS = 40
```

Defines bfgcells for the p pspr subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_pspr.ml#L83)

<a id="global-global-bulletslope-bulletslope-src-p-pspr-ml-881291096"></a>
### bulletslope

```ml
bulletslope
```

Tracks the mutable bulletslope value used by the p pspr subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_pspr.ml#L106)

<a id="constant-constant-ff-framemask-const-ff-framemask-32767-src-p-pspr-ml-938514208"></a>
### FF_FRAMEMASK

```ml
const FF_FRAMEMASK = 32767
```

Defines ff framemask for the p pspr subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_pspr.ml#L41)

<a id="constant-constant-ff-fullbright-const-ff-fullbright-32768-src-p-pspr-ml-1369030071"></a>
### FF_FULLBRIGHT

```ml
const FF_FULLBRIGHT = 32768
```

Defines ff fullbright for the p pspr subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_pspr.ml#L39)

<a id="constant-constant-lowerspeed-const-lowerspeed-393216-src-p-pspr-ml-1696193257"></a>
### LOWERSPEED

```ml
const LOWERSPEED = 393216
```

Defines lowerspeed for the p pspr subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_pspr.ml#L73)

<a id="global-global-numpsprites-numpsprites-src-p-pspr-ml-156317124"></a>
### NUMPSPRITES

```ml
NUMPSPRITES
```

Tracks the mutable numpsprites value used by the p pspr subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_pspr.ml#L58)

<a id="function-function-p-bringupweapon-function-p-bringupweapon-player-src-p-pspr-ml-2143986817"></a>
### P_BringUpWeapon

```ml
function P_BringUpWeapon(player)
```

Commits the pending weapon, lowers its sprite origin to WEAPONBOTTOM, clears flash state, and enters its raise state.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `player` | `dynamic` | — | Player state affected by the operation. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_pspr.ml#L413)

<a id="function-function-p-bulletslope-function-p-bulletslope-mo-src-p-pspr-ml-1709011234"></a>
### P_BulletSlope

```ml
function P_BulletSlope(mo)
```

Computes the shared hitscan auto-aim slope, retrying slightly right and left when the forward trace finds no target.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `mo` | `dynamic` | — | Map object affected by the operation. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_pspr.ml#L1007)

<a id="function-function-p-calcswing-function-p-calcswing-player-src-p-pspr-ml-862186885"></a>
### P_CalcSwing

```ml
function P_CalcSwing(player)
```

Computes fixed-point weapon sway from player bob amplitude and level-time sine phases.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `player` | `dynamic` | — | Player state affected by the operation. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_pspr.ml#L387)

<a id="function-function-p-checkammo-function-p-checkammo-player-src-p-pspr-ml-1378821395"></a>
### P_CheckAmmo

```ml
function P_CheckAmmo(player)
```

Verifies the ready weapon's per-shot ammo cost or selects a usable fallback and starts lowering the empty weapon.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `player` | `dynamic` | — | Player state affected by the operation. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_pspr.ml#L440)

<a id="function-function-p-dropweapon-function-p-dropweapon-player-src-p-pspr-ml-363606733"></a>
### P_DropWeapon

```ml
function P_DropWeapon(player)
```

Starts the ready weapon's lowering state, typically during death or an explicit switch.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `player` | `dynamic` | — | Player state affected by the operation. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_pspr.ml#L506)

<a id="function-function-p-fireweapon-function-p-fireweapon-player-src-p-pspr-ml-697822901"></a>
### P_FireWeapon

```ml
function P_FireWeapon(player)
```

After an ammo check, enters attack states and alerts nearby monsters unless persistent notarget is active.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `player` | `dynamic` | — | Player state affected by the operation. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_pspr.ml#L486)

<a id="function-function-p-gunshot-function-p-gunshot-mo-accurate-src-p-pspr-ml-1920535122"></a>
### P_GunShot

```ml
function P_GunShot(mo, accurate)
```

Fires one randomized-damage hitscan at the cached bullet slope, adding horizontal spread unless accurate is true.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `mo` | `dynamic` | — | Map object affected by the operation. |
| `accurate` | `dynamic` | — | Accurate value supplied to `P_GunShot`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_pspr.ml#L1033)

<a id="function-function-p-movepsprites-function-p-movepsprites-player-src-p-pspr-ml-2111210489"></a>
### P_MovePsprites

```ml
function P_MovePsprites(player)
```

Advances weapon/flash state tics and keeps the flash layer aligned to the weapon sprite.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `player` | `dynamic` | — | Player state affected by the operation. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_pspr.ml#L531)

<a id="function-function-p-setpsprite-function-p-setpsprite-player-position-stnum-src-p-pspr-ml-1010680289"></a>
### P_SetPsprite

```ml
function P_SetPsprite(player, position, stnum)
```

Enters a player-sprite state, applies offsets and actions, and immediately follows zero-tic transitions until stable or null.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `player` | `dynamic` | — | Player state affected by the operation. |
| `position` | `dynamic` | — | Position value supplied to `P_SetPsprite`. |
| `stnum` | `dynamic` | — | Index identifying st. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_pspr.ml#L328)

<a id="function-function-p-setuppsprites-function-p-setuppsprites-player-src-p-pspr-ml-506929065"></a>
### P_SetupPsprites

```ml
function P_SetupPsprites(player)
```

Clears both player-sprite layers and initializes the ready weapon through the normal bring-up transition.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `player` | `dynamic` | — | Player state affected by the operation. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_pspr.ml#L515)

<a id="global-global-ps-flash-ps-flash-src-p-pspr-ml-1145043576"></a>
### ps_flash

```ml
ps_flash
```

Tracks the mutable ps flash value used by the p pspr subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_pspr.ml#L56)

<a id="global-global-ps-weapon-ps-weapon-src-p-pspr-ml-668167780"></a>
### ps_weapon

```ml
ps_weapon
```

Tracks the mutable ps weapon value used by the p pspr subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_pspr.ml#L54)

- [pspdef_t](Type-pspdef-t-1009385872.md) — struct
- [psprnum_t](Type-psprnum-t-1640991897.md) — enum
<a id="constant-constant-raisespeed-const-raisespeed-393216-src-p-pspr-ml-522320579"></a>
### RAISESPEED

```ml
const RAISESPEED = 393216
```

Defines raisespeed for the p pspr subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_pspr.ml#L75)

<a id="global-global-swingx-swingx-src-p-pspr-ml-1367279716"></a>
### swingx

```ml
swingx
```

Tracks the mutable swingx value used by the p pspr subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_pspr.ml#L101)

<a id="global-global-swingy-swingy-src-p-pspr-ml-130989614"></a>
### swingy

```ml
swingy
```

Tracks the mutable swingy value used by the p pspr subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_pspr.ml#L103)

<a id="constant-constant-weaponbottom-const-weaponbottom-8388608-src-p-pspr-ml-684855246"></a>
### WEAPONBOTTOM

```ml
const WEAPONBOTTOM = 8388608
```

Defines weaponbottom for the p pspr subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_pspr.ml#L78)

<a id="constant-constant-weapontop-const-weapontop-2097152-src-p-pspr-ml-296799945"></a>
### WEAPONTOP

```ml
const WEAPONTOP = 2097152
```

Defines weapontop for the p pspr subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_pspr.ml#L80)
