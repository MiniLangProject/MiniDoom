# `src/p_inter.ml`

[Home](README.md) · [Files](Files.md)

Applies pickups, armor and damage, resolves deaths, and maintains player frag attribution.

Package: [`(global)`](Package-global-1952375359.md)

Reachable from entry: **yes**

## Imports

- `am_map.ml` → [src/am_map.ml](File-src-am-map-ml-1409794280.md)
- `d_player.ml` → [src/d_player.ml](File-src-d-player-ml-1944166105.md)
- `doomdef.ml` → [src/doomdef.ml](File-src-doomdef-ml-460406769.md)
- `doomstat.ml` → [src/doomstat.ml](File-src-doomstat-ml-1652708088.md)
- `dstrings.ml` → [src/dstrings.ml](File-src-dstrings-ml-567491523.md)
- `i_system.ml` → [src/i_system.ml](File-src-i-system-ml-1632920966.md)
- `info.ml` → [src/info.ml](File-src-info-ml-1415270573.md)
- `m_argv.ml` → [src/m_argv.ml](File-src-m-argv-ml-728984635.md)
- `m_random.ml` → [src/m_random.ml](File-src-m-random-ml-1659574948.md)
- `p_local.ml` → [src/p_local.ml](File-src-p-local-ml-1043095437.md)
- `p_mobj.ml` → [src/p_mobj.ml](File-src-p-mobj-ml-1335564114.md)
- `p_pspr.ml` → [src/p_pspr.ml](File-src-p-pspr-ml-844718747.md)
- `r_main.ml` → [src/r_main.ml](File-src-r-main-ml-1902335243.md)
- `s_sound.ml` → [src/s_sound.ml](File-src-s-sound-ml-1485495390.md)
- `sounds.ml` → [src/sounds.ml](File-src-sounds-ml-1875364049.md)
- `tables.ml` → [src/tables.ml](File-src-tables-ml-1959718242.md)

## Declarations

<a id="function-function-pi-ammoindex-inline-function-pi-ammoindex-a-src-p-inter-ml-1956067429"></a>
### _PI_AmmoIndex

```ml
inline function _PI_AmmoIndex(a)
```

Converts an ammo enum/value into a checked inventory index.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `a` | `dynamic` | — | First input operand. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_inter.ml#L145)

<a id="function-function-pi-cardindex-function-pi-cardindex-card-src-p-inter-ml-769988169"></a>
### _PI_CardIndex

```ml
function _PI_CardIndex(card)
```

Converts a key/card enum/value into a checked cards-array index.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `card` | `dynamic` | — | Card value supplied to `_PI_CardIndex`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_inter.ml#L202)

<a id="function-function-pi-committouchedplayer-inline-function-pi-committouchedplayer-toucher-player-pidx-src-p-inter-ml-79010260"></a>
### _PI_CommitTouchedPlayer

```ml
inline function _PI_CommitTouchedPlayer(toucher, player, pidx)
```

Writes pickup-mutated player state back to global slot and touching mobj.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `toucher` | `dynamic` | — | Toucher value supplied to `_PI_CommitTouchedPlayer`. |
| `player` | `dynamic` | — | Player state affected by the operation. |
| `pidx` | `dynamic` | — | Pidx value supplied to `_PI_CommitTouchedPlayer`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_inter.ml#L332)

<a id="function-function-pi-diaghitenabled-function-pi-diaghitenabled-src-p-inter-ml-850063649"></a>
### _PI_DiagHitEnabled

```ml
function _PI_DiagHitEnabled()
```

Enables bounded hit diagnostics only for explicit developer runs.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_inter.ml#L113)

<a id="function-function-pi-diaghitlog-inline-function-pi-diaghitlog-msg-src-p-inter-ml-1791149711"></a>
### _PI_DiagHitLog

```ml
inline function _PI_DiagHitLog(msg)
```

Emits rate-limited damage diagnostics without flooding normal gameplay output.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `msg` | `dynamic` | — | Msg value supplied to `_PI_DiagHitLog`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_inter.ml#L133)

<a id="function-function-pi-hascard-inline-function-pi-hascard-player-card-src-p-inter-ml-306351473"></a>
### _PI_HasCard

```ml
inline function _PI_HasCard(player, card)
```

Tests whether a player already owns a checked key/card inventory entry.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `player` | `dynamic` | — | Player state affected by the operation. |
| `card` | `dynamic` | — | Card value supplied to `_PI_HasCard`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_inter.ml#L231)

<a id="function-function-pi-hasweapon-inline-function-pi-hasweapon-player-weapon-src-p-inter-ml-965541659"></a>
### _PI_HasWeapon

```ml
inline function _PI_HasWeapon(player, weapon)
```

Tests a checked weapon ownership bit on a possibly incomplete player record.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `player` | `dynamic` | — | Player state affected by the operation. |
| `weapon` | `dynamic` | — | Weapon value supplied to `_PI_HasWeapon`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_inter.ml#L265)

<a id="function-function-pi-idiv-inline-function-pi-idiv-a-b-src-p-inter-ml-1369898529"></a>
### _PI_IDiv

```ml
inline function _PI_IDiv(a, b)
```

Truncates damage and ammo scaling quotients toward zero, returning zero for invalid divisors.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `a` | `dynamic` | — | First input operand. |
| `b` | `dynamic` | — | Second input operand. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_inter.ml#L243)

<a id="function-function-pi-isnotargetplayermobj-inline-function-pi-isnotargetplayermobj-mo-src-p-inter-ml-414517660"></a>
### _PI_IsNoTargetPlayerMobj

```ml
inline function _PI_IsNoTargetPlayerMobj(mo)
```

Reports whether a damage source is a player whose persistent notarget cheat forbids monster retaliation.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `mo` | `dynamic` | — | Map object affected by the operation. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_inter.ml#L40)

<a id="function-function-pi-playerindex-function-pi-playerindex-player-src-p-inter-ml-269232360"></a>
### _PI_PlayerIndex

```ml
function _PI_PlayerIndex(player)
```

Resolves a player struct to its authoritative slot for frag/pickup commits.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `player` | `dynamic` | — | Player state affected by the operation. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_inter.ml#L277)

<a id="function-function-pi-playerindexforthing-function-pi-playerindexforthing-player-thing-src-p-inter-ml-111769594"></a>
### _PI_PlayerIndexForThing

```ml
function _PI_PlayerIndexForThing(player, thing)
```

Resolves player slot by player struct first, then by owning mobj.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `player` | `dynamic` | — | Player state affected by the operation. |
| `thing` | `dynamic` | — | World object affected by the operation. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_inter.ml#L301)

<a id="function-function-pi-powerindex-function-pi-powerindex-pw-src-p-inter-ml-260356228"></a>
### _PI_PowerIndex

```ml
function _PI_PowerIndex(pw)
```

Converts a power enum/value into a checked powers-array index.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `pw` | `dynamic` | — | Pw value supplied to `_PI_PowerIndex`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_inter.ml#L180)

<a id="function-function-pi-weaponindex-function-pi-weaponindex-w-src-p-inter-ml-2132387580"></a>
### _PI_WeaponIndex

```ml
function _PI_WeaponIndex(w)
```

Converts a weapon enum/value into a checked ownership-table index.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `w` | `dynamic` | — | W value supplied to `_PI_WeaponIndex`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_inter.ml#L160)

<a id="function-function-pi-weaponinfo-inline-function-pi-weaponinfo-weapon-src-p-inter-ml-658160330"></a>
### _PI_WeaponInfo

```ml
inline function _PI_WeaponInfo(weapon)
```

Resolves immutable weapon metadata after validating the weapon index.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `weapon` | `dynamic` | — | Weapon value supplied to `_PI_WeaponInfo`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_inter.ml#L253)

<a id="global-global-pidiaghit-pidiaghit-src-p-inter-ml-847593575"></a>
### _piDiagHit

```ml
_piDiagHit
```

Tracks whether pi diag hit is active in the p inter subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_inter.ml#L106)

<a id="global-global-pidiaghitcount-pidiaghitcount-src-p-inter-ml-2107606611"></a>
### _piDiagHitCount

```ml
_piDiagHitCount
```

Tracks the mutable pi diag hit count value used by the p inter subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_inter.ml#L109)

<a id="global-global-pidiaghitinit-pidiaghitinit-src-p-inter-ml-565456847"></a>
### _piDiagHitInit

```ml
_piDiagHitInit
```

Tracks whether pi diag hit init is active in the p inter subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_inter.ml#L103)

<a id="constant-constant-bonusadd-const-bonusadd-6-src-p-inter-ml-543472410"></a>
### BONUSADD

```ml
const BONUSADD = 6
```

Defines bonusadd for the p inter subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_inter.ml#L95)

<a id="global-global-clipammo-clipammo-src-p-inter-ml-1960303627"></a>
### clipammo

```ml
clipammo
```

Stores the clipammo collection used by the p inter subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_inter.ml#L100)

<a id="global-global-maxammo-maxammo-src-p-inter-ml-656450267"></a>
### maxammo

```ml
maxammo
```

Stores the maxammo collection used by the p inter subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_inter.ml#L98)

<a id="function-function-p-damagemobj-function-p-damagemobj-target-inflictor-source-damage-src-p-inter-ml-686570734"></a>
### P_DamageMobj

```ml
function P_DamageMobj(target, inflictor, source, damage)
```

Applies armor, thrust, pain, death, and attacker attribution for one damage event.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `target` | `dynamic` | — | Target value supplied to `P_DamageMobj`. |
| `inflictor` | `dynamic` | — | Inflictor value supplied to `P_DamageMobj`. |
| `source` | `dynamic` | — | Source value or buffer. |
| `damage` | `dynamic` | — | Damage value supplied to `P_DamageMobj`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_inter.ml#L835)

<a id="function-function-p-giveammo-function-p-giveammo-player-ammo-num-src-p-inter-ml-243094258"></a>
### P_GiveAmmo

```ml
function P_GiveAmmo(player, ammo, num)
```

Adds clip-scaled ammunition, clamps capacity, and selects a newly usable weapon.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `player` | `dynamic` | — | Player state affected by the operation. |
| `ammo` | `dynamic` | — | Ammo value supplied to `P_GiveAmmo`. |
| `num` | `dynamic` | — | Index identifying the requested item. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_inter.ml#L346)

<a id="function-function-p-givearmor-function-p-givearmor-player-armortype-src-p-inter-ml-346479533"></a>
### P_GiveArmor

```ml
function P_GiveArmor(player, armortype)
```

Replaces armor only when the requested class provides more effective points.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `player` | `dynamic` | — | Player state affected by the operation. |
| `armortype` | `dynamic` | — | Armortype value supplied to `P_GiveArmor`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_inter.ml#L476)

<a id="function-function-p-givebody-function-p-givebody-player-num-src-p-inter-ml-1356383164"></a>
### P_GiveBody

```ml
function P_GiveBody(player, num)
```

Heals a player and mirrors the clamped health into the owned mobj.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `player` | `dynamic` | — | Player state affected by the operation. |
| `num` | `dynamic` | — | Index identifying the requested item. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_inter.ml#L464)

<a id="function-function-p-givecard-function-p-givecard-player-card-src-p-inter-ml-487903254"></a>
### P_GiveCard

```ml
function P_GiveCard(player, card)
```

Grants a key/card once and triggers the pickup flash.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `player` | `dynamic` | — | Player state affected by the operation. |
| `card` | `dynamic` | — | Card value supplied to `P_GiveCard`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_inter.ml#L488)

<a id="function-function-p-givepower-function-p-givepower-player-power-src-p-inter-ml-1870988451"></a>
### P_GivePower

```ml
function P_GivePower(player, power)
```

Grants or refreshes a player powerup while respecting permanent berserk strength.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `player` | `dynamic` | — | Player state affected by the operation. |
| `power` | `dynamic` | — | Power value supplied to `P_GivePower`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_inter.ml#L48)

<a id="function-function-p-giveweapon-function-p-giveweapon-player-weapon-dropped-src-p-inter-ml-145348842"></a>
### P_GiveWeapon

```ml
function P_GiveWeapon(player, weapon, dropped)
```

Applies Doom coop/deathmatch weapon-stay and ammo pickup rules.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `player` | `dynamic` | — | Player state affected by the operation. |
| `weapon` | `dynamic` | — | Weapon value supplied to `P_GiveWeapon`. |
| `dropped` | `dynamic` | — | Dropped value supplied to `P_GiveWeapon`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_inter.ml#L412)

<a id="function-function-p-killmobj-function-p-killmobj-source-target-src-p-inter-ml-1790364609"></a>
### P_KillMobj

```ml
function P_KillMobj(source, target)
```

Finalizes an actor death, including Doom frag semantics, corpse state, drops, and player rebirth state.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `source` | `dynamic` | — | Source value or buffer. |
| `target` | `dynamic` | — | Target value supplied to `P_KillMobj`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_inter.ml#L744)

<a id="function-function-p-touchspecialthing-function-p-touchspecialthing-special-toucher-src-p-inter-ml-1177249818"></a>
### P_TouchSpecialThing

```ml
function P_TouchSpecialThing(special, toucher)
```

Resolves one pickup collision, mutates authoritative inventory, and removes consumable actors.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `special` | `dynamic` | — | Special value supplied to `P_TouchSpecialThing`. |
| `toucher` | `dynamic` | — | Toucher value supplied to `P_TouchSpecialThing`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_inter.ml#L502)
