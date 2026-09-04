# `src/p_user.ml`

[Home](README.md) · [Files](Files.md)

Applies player commands to turning, thrust, view height, jumping, weapon use, and power timers.

Package: [`(global)`](Package-global-1952375359.md)

Reachable from entry: **yes**

## Imports

- `d_event.ml` → [src/d_event.ml](File-src-d-event-ml-1995118760.md)
- `d_player.ml` → [src/d_player.ml](File-src-d-player-ml-1944166105.md)
- `doomdef.ml` → [src/doomdef.ml](File-src-doomdef-ml-460406769.md)
- `doomstat.ml` → [src/doomstat.ml](File-src-doomstat-ml-1652708088.md)
- `info.ml` → [src/info.ml](File-src-info-ml-1415270573.md)
- `p_local.ml` → [src/p_local.ml](File-src-p-local-ml-1043095437.md)
- `p_mobj.ml` → [src/p_mobj.ml](File-src-p-mobj-ml-1335564114.md)
- `p_pspr.ml` → [src/p_pspr.ml](File-src-p-pspr-ml-844718747.md)
- `r_main.ml` → [src/r_main.ml](File-src-r-main-ml-1902335243.md)

## Declarations

<a id="constant-constant-p-ang5-const-p-ang5-59652323-src-p-user-ml-615406330"></a>
### _P_ANG5

```ml
const _P_ANG5 = 59652323
```

Defines p ang5 for the p user subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_user.ml#L40)

<a id="constant-constant-p-bobanglestep-const-p-bobanglestep-409-src-p-user-ml-714849472"></a>
### _P_BOBANGLESTEP

```ml
const _P_BOBANGLESTEP = 409
```

Defines p bobanglestep for the p user subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_user.ml#L37)

<a id="function-function-p-fineindexfromangle-inline-function-p-fineindexfromangle-angle-src-p-user-ml-1985083742"></a>
### _P_FineIndexFromAngle

```ml
inline function _P_FineIndexFromAngle(angle)
```

Converts a Doom binary angle to a wrapped fine-angle table index.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `angle` | `dynamic` | — | Doom binary-angle measurement. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_user.ml#L48)

<a id="function-function-pu-getpower-function-pu-getpower-player-pw-src-p-user-ml-971558126"></a>
### _PU_GetPower

```ml
function _PU_GetPower(player, pw)
```

Resolves a power enum safely and returns the player's remaining counter, defaulting to zero for malformed state.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `player` | `dynamic` | — | Player state affected by the operation. |
| `pw` | `dynamic` | — | Pw value supplied to `_PU_GetPower`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_user.ml#L105)

<a id="function-function-pu-hasweapon-inline-function-pu-hasweapon-player-w-src-p-user-ml-1139037741"></a>
### _PU_HasWeapon

```ml
inline function _PU_HasWeapon(player, w)
```

Resolves a weapon enum and reports ownership without indexing malformed player tables.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `player` | `dynamic` | — | Player state affected by the operation. |
| `w` | `dynamic` | — | W value supplied to `_PU_HasWeapon`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_user.ml#L144)

<a id="function-function-pu-powerindex-function-pu-powerindex-pw-src-p-user-ml-1908662029"></a>
### _PU_PowerIndex

```ml
function _PU_PowerIndex(pw)
```

Validates a power-up identifier before indexing the player's power timer array.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `pw` | `dynamic` | — | Pw value supplied to `_PU_PowerIndex`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_user.ml#L81)

<a id="function-function-pu-setpower-function-pu-setpower-player-pw-value-src-p-user-ml-823984723"></a>
### _PU_SetPower

```ml
function _PU_SetPower(player, pw, value)
```

Resolves a power enum safely and replaces its counter only when the player's power table can hold it.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `player` | `dynamic` | — | Player state affected by the operation. |
| `pw` | `dynamic` | — | Pw value supplied to `_PU_SetPower`. |
| `value` | `dynamic` | — | Value consumed by the operation. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_user.ml#L126)

<a id="function-function-pu-weaponindex-function-pu-weaponindex-w-src-p-user-ml-1543777893"></a>
### _PU_WeaponIndex

```ml
function _PU_WeaponIndex(w)
```

Validates and clamps an arbitrary weapon identifier to the player weapon-array range.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `w` | `dynamic` | — | W value supplied to `_PU_WeaponIndex`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_user.ml#L61)

<a id="constant-constant-inversecolormap-const-inversecolormap-32-src-p-user-ml-48430296"></a>
### INVERSECOLORMAP

```ml
const INVERSECOLORMAP = 32
```

Defines the Doom palette selection for inversecolormap.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_user.ml#L31)

<a id="constant-constant-maxbob-const-maxbob-1048576-src-p-user-ml-1154766882"></a>
### MAXBOB

```ml
const MAXBOB = 1048576
```

Defines the maximum maxbob accepted by the p user subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_user.ml#L34)

<a id="global-global-onground-onground-src-p-user-ml-799270588"></a>
### onground

```ml
onground
```

Tracks whether onground is active in the p user subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_user.ml#L43)

<a id="function-function-p-calcheight-function-p-calcheight-player-src-p-user-ml-937965713"></a>
### P_CalcHeight

```ml
function P_CalcHeight(player)
```

Derives weapon bob and eye height from horizontal momentum, stance, airborne state, and ceiling clearance.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `player` | `dynamic` | — | Player state affected by the operation. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_user.ml#L171)

<a id="function-function-p-deaththink-function-p-deaththink-player-src-p-user-ml-408663681"></a>
### P_DeathThink

```ml
function P_DeathThink(player)
```

Lowers the dead player's view, turns toward the attacker, and requests rebirth when use is pressed.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `player` | `dynamic` | — | Player state affected by the operation. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_user.ml#L261)

<a id="function-function-p-moveplayer-function-p-moveplayer-player-src-p-user-ml-739313113"></a>
### P_MovePlayer

```ml
function P_MovePlayer(player)
```

Applies command turning and grounded forward/side thrust, then enters the run animation when movement is requested.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `player` | `dynamic` | — | Player state affected by the operation. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_user.ml#L228)

<a id="function-function-p-playerthink-function-p-playerthink-player-src-p-user-ml-1347832073"></a>
### P_PlayerThink

```ml
function P_PlayerThink(player)
```

Applies one tic command to player movement, view, weapon, use, power timers, and death or live-state transitions.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `player` | `dynamic` | — | Player state affected by the operation. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_user.ml#L303)

<a id="function-function-p-thrust-function-p-thrust-player-angle-move-src-p-user-ml-784374831"></a>
### P_Thrust

```ml
function P_Thrust(player, angle, move)
```

Projects a movement magnitude through fine-angle sine/cosine tables and adds it to player horizontal momentum.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `player` | `dynamic` | — | Player state affected by the operation. |
| `angle` | `dynamic` | — | Doom binary-angle measurement. |
| `move` | `dynamic` | — | Move value supplied to `P_Thrust`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_user.ml#L157)
