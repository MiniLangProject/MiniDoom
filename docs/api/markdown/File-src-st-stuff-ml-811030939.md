# `src/st_stuff.ml`

[Home](README.md) · [Files](Files.md)

Drives the classic status bar's player values, face state machine, palette flashes, cheats, resources, and widgets.

Package: [`(global)`](Package-global-1952375359.md)

Reachable from entry: **yes**

## Imports

- `am_map.ml` → [src/am_map.ml](File-src-am-map-ml-1409794280.md)
- `d_event.ml` → [src/d_event.ml](File-src-d-event-ml-1995118760.md)
- `d_items.ml` → [src/d_items.ml](File-src-d-items-ml-1350618780.md)
- `doomdef.ml` → [src/doomdef.ml](File-src-doomdef-ml-460406769.md)
- `doomstat.ml` → [src/doomstat.ml](File-src-doomstat-ml-1652708088.md)
- `doomtype.ml` → [src/doomtype.ml](File-src-doomtype-ml-372549946.md)
- `dstrings.ml` → [src/dstrings.ml](File-src-dstrings-ml-567491523.md)
- `g_game.ml` → [src/g_game.ml](File-src-g-game-ml-257299317.md)
- `i_gl.ml` → [src/i_gl.ml](File-src-i-gl-ml-2113703076.md)
- `i_system.ml` → [src/i_system.ml](File-src-i-system-ml-1632920966.md)
- `i_video.ml` → [src/i_video.ml](File-src-i-video-ml-140536292.md)
- `m_cheat.ml` → [src/m_cheat.ml](File-src-m-cheat-ml-440987496.md)
- `m_random.ml` → [src/m_random.ml](File-src-m-random-ml-1659574948.md)
- `p_inter.ml` → [src/p_inter.ml](File-src-p-inter-ml-1430401638.md)
- `p_local.ml` → [src/p_local.ml](File-src-p-local-ml-1043095437.md)
- `r_local.ml` → [src/r_local.ml](File-src-r-local-ml-797040731.md)
- `r_main.ml` → [src/r_main.ml](File-src-r-main-ml-1902335243.md)
- `r_renderer.ml` → [src/r_renderer.ml](File-src-r-renderer-ml-72894217.md)
- `s_sound.ml` → [src/s_sound.ml](File-src-s-sound-ml-1485495390.md)
- `sounds.ml` → [src/sounds.ml](File-src-sounds-ml-1875364049.md)
- `st_lib.ml` → [src/st_lib.ml](File-src-st-lib-ml-1845497584.md)
- `v_video.ml` → [src/v_video.ml](File-src-v-video-ml-592999939.md)
- `w_wad.ml` → [src/w_wad.ml](File-src-w-wad-ml-893006035.md)
- `z_zone.ml` → [src/z_zone.ml](File-src-z-zone-ml-1788911354.md)

## Declarations

<a id="function-function-st-arrayappend-function-st-arrayappend-arr-item-src-st-stuff-ml-1734783620"></a>
### _ST_ArrayAppend

```ml
function _ST_ArrayAppend(arr, item)
```

Returns a copy of an array with one appended item without using concatenation.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `arr` | `dynamic` | — | Arr value supplied to `_ST_ArrayAppend`. |
| `item` | `dynamic` | — | Item value supplied to `_ST_ArrayAppend`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/st_stuff.ml#L501)

<a id="function-function-st-cheatparam-inline-function-st-cheatparam-cheat-src-st-stuff-ml-127806838"></a>
### _ST_CheatParam

```ml
inline function _ST_CheatParam(cheat)
```

Extracts the decoded parameter bytes accumulated by a parameterized cheat sequence.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `cheat` | `dynamic` | — | Cheat value supplied to `_ST_CheatParam`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/st_stuff.ml#L526)

<a id="function-function-st-digitfromparam-inline-function-st-digitfromparam-param-idx-src-st-stuff-ml-174909379"></a>
### _ST_DigitFromParam

```ml
inline function _ST_DigitFromParam(param, idx)
```

Parses one checked decimal digit from a cheat-code parameter string, returning minus one on invalid input.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `param` | `dynamic` | — | Param value supplied to `_ST_DigitFromParam`. |
| `idx` | `dynamic` | — | Zero-based element or table index. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/st_stuff.ml#L471)

<a id="function-function-st-digitstring-inline-function-st-digitstring-v-src-st-stuff-ml-181747753"></a>
### _ST_DigitString

```ml
inline function _ST_DigitString(v)
```

Formats one numeric status-bar lump suffix without implicit string conversion.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `v` | `dynamic` | — | Value consumed by the operation. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/st_stuff.ml#L484)

<a id="function-function-st-enumindex-function-st-enumindex-v-limit-src-st-stuff-ml-1203358057"></a>
### _ST_EnumIndex

```ml
function _ST_EnumIndex(v, limit)
```

Converts integer/enum values to a checked table index below the requested limit.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `v` | `dynamic` | — | Value consumed by the operation. |
| `limit` | `dynamic` | — | Limit value supplied to `_ST_EnumIndex`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/st_stuff.ml#L429)

<a id="function-function-st-facebackname-inline-function-st-facebackname-src-st-stuff-ml-1677797813"></a>
### _ST_FacebackName

```ml
inline function _ST_FacebackName()
```

Returns the fixed status-bar face background lump for the local player.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/st_stuff.ml#L516)

<a id="function-function-st-getammo-inline-function-st-getammo-player-idx-src-st-stuff-ml-1779943155"></a>
### _ST_GetAmmo

```ml
inline function _ST_GetAmmo(player, idx)
```

Returns one checked player ammunition count as an integer.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `player` | `dynamic` | — | Player state affected by the operation. |
| `idx` | `dynamic` | — | Zero-based element or table index. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/st_stuff.ml#L616)

<a id="function-function-st-getcard-inline-function-st-getcard-player-idx-src-st-stuff-ml-206523255"></a>
### _ST_GetCard

```ml
inline function _ST_GetCard(player, idx)
```

Returns one checked player key/card ownership flag.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `player` | `dynamic` | — | Player state affected by the operation. |
| `idx` | `dynamic` | — | Zero-based element or table index. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/st_stuff.ml#L592)

<a id="function-function-st-getmaxammo-inline-function-st-getmaxammo-player-idx-src-st-stuff-ml-1661056635"></a>
### _ST_GetMaxAmmo

```ml
inline function _ST_GetMaxAmmo(player, idx)
```

Returns one checked player ammunition-capacity value as an integer.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `player` | `dynamic` | — | Player state affected by the operation. |
| `idx` | `dynamic` | — | Zero-based element or table index. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/st_stuff.ml#L628)

<a id="function-function-st-getpower-inline-function-st-getpower-player-idx-src-st-stuff-ml-2001258365"></a>
### _ST_GetPower

```ml
inline function _ST_GetPower(player, idx)
```

Returns one checked player power timer or zero for absent/incomplete records.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `player` | `dynamic` | — | Player state affected by the operation. |
| `idx` | `dynamic` | — | Zero-based element or table index. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/st_stuff.ml#L579)

<a id="function-function-st-getref-inline-function-st-getref-refv-fallback-src-st-stuff-ml-49433732"></a>
### _ST_GetRef

```ml
inline function _ST_GetRef(refv, fallback)
```

Dereferences the status widget's single-element mutable-reference convention with a fallback.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `refv` | `dynamic` | — | Refv value supplied to `_ST_GetRef`. |
| `fallback` | `dynamic` | — | Value returned when the requested conversion or lookup is unavailable. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/st_stuff.ml#L536)

<a id="function-function-st-getweaponowned-inline-function-st-getweaponowned-player-idx-src-st-stuff-ml-687293677"></a>
### _ST_GetWeaponOwned

```ml
inline function _ST_GetWeaponOwned(player, idx)
```

Returns one checked player weapon-ownership flag.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `player` | `dynamic` | — | Player state affected by the operation. |
| `idx` | `dynamic` | — | Zero-based element or table index. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/st_stuff.ml#L604)

<a id="function-function-st-idiv-inline-function-st-idiv-a-b-src-st-stuff-ml-2043021018"></a>
### _ST_IDiv

```ml
inline function _ST_IDiv(a, b)
```

Divides status calculations with truncation toward zero and returns zero for a zero divisor.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `a` | `dynamic` | — | First input operand. |
| `b` | `dynamic` | — | Second input operand. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/st_stuff.ml#L450)

<a id="function-function-st-loadpatchmaybe-inline-function-st-loadpatchmaybe-name-src-st-stuff-ml-1305356206"></a>
### _ST_LoadPatchMaybe

```ml
inline function _ST_LoadPatchMaybe(name)
```

Caches an optional status-bar patch only when its lump exists.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `name` | `dynamic` | — | Resource or object name to resolve. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/st_stuff.ml#L557)

<a id="function-function-st-loadpatchrequired-inline-function-st-loadpatchrequired-name-src-st-stuff-ml-1123791290"></a>
### _ST_LoadPatchRequired

```ml
inline function _ST_LoadPatchRequired(name)
```

Caches a required status-bar patch and registers its lump name for HD overlay lookup.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `name` | `dynamic` | — | Resource or object name to resolve. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/st_stuff.ml#L566)

<a id="function-function-st-player-inline-function-st-player-src-st-stuff-ml-1057442077"></a>
### _ST_Player

```ml
inline function _ST_Player()
```

Returns the checked console-player record consumed by status widgets and cheats.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/st_stuff.ml#L399)

<a id="function-function-st-setmessage-inline-function-st-setmessage-msg-src-st-stuff-ml-2015913326"></a>
### _ST_SetMessage

```ml
inline function _ST_SetMessage(msg)
```

Writes a cheat/status notification into the active console player's HUD message slot.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `msg` | `dynamic` | — | Msg value supplied to `_ST_SetMessage`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/st_stuff.ml#L462)

<a id="function-function-st-setref-inline-function-st-setref-refv-v-src-st-stuff-ml-650025146"></a>
### _ST_SetRef

```ml
inline function _ST_SetRef(refv, v)
```

Writes through a non-empty single-element status-widget reference.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `refv` | `dynamic` | — | Refv value supplied to `_ST_SetRef`. |
| `v` | `dynamic` | — | Value consumed by the operation. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/st_stuff.ml#L548)

<a id="function-function-st-toint-function-st-toint-v-fallback-src-st-stuff-ml-488441562"></a>
### _ST_ToInt

```ml
function _ST_ToInt(v, fallback)
```

Converts numeric or numeric-string widget values by truncating toward zero, otherwise returning a fallback.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `v` | `dynamic` | — | Value consumed by the operation. |
| `fallback` | `dynamic` | — | Value returned when the requested conversion or lookup is unavailable. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/st_stuff.ml#L410)

<a id="function-function-st-weaponammotype-inline-function-st-weaponammotype-weapon-src-st-stuff-ml-1652279747"></a>
### _ST_WeaponAmmoType

```ml
inline function _ST_WeaponAmmoType(weapon)
```

Resolves a checked ready-weapon index to its ammo pool or the no-ammo sentinel.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `weapon` | `dynamic` | — | Weapon value supplied to `_ST_WeaponAmmoType`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/st_stuff.ml#L639)

<a id="global-global-cheat-ammo-cheat-ammo-src-st-stuff-ml-1229896824"></a>
### cheat_ammo

```ml
cheat_ammo
```

Tracks the mutable cheat ammo value used by the st stuff subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/st_stuff.ml#L375)

<a id="global-global-cheat-ammonokey-cheat-ammonokey-src-st-stuff-ml-1276947928"></a>
### cheat_ammonokey

```ml
cheat_ammonokey
```

Tracks the mutable cheat ammonokey value used by the st stuff subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/st_stuff.ml#L377)

<a id="global-global-cheat-choppers-cheat-choppers-src-st-stuff-ml-1046957508"></a>
### cheat_choppers

```ml
cheat_choppers
```

Tracks the mutable cheat choppers value used by the st stuff subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/st_stuff.ml#L371)

<a id="global-global-cheat-clev-cheat-clev-src-st-stuff-ml-1593188020"></a>
### cheat_clev

```ml
cheat_clev
```

Tracks the mutable cheat clev value used by the st stuff subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/st_stuff.ml#L393)

<a id="global-global-cheat-commercial-noclip-cheat-commercial-noclip-src-st-stuff-ml-960270648"></a>
### cheat_commercial_noclip

```ml
cheat_commercial_noclip
```

Tracks the mutable cheat commercial noclip value used by the st stuff subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/st_stuff.ml#L381)

<a id="global-global-cheat-god-cheat-god-src-st-stuff-ml-591058416"></a>
### cheat_god

```ml
cheat_god
```

Tracks the mutable cheat god value used by the st stuff subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/st_stuff.ml#L373)

<a id="global-global-cheat-mus-cheat-mus-src-st-stuff-ml-198048536"></a>
### cheat_mus

```ml
cheat_mus
```

Tracks the mutable cheat mus value used by the st stuff subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/st_stuff.ml#L369)

<a id="global-global-cheat-mypos-cheat-mypos-src-st-stuff-ml-1428648248"></a>
### cheat_mypos

```ml
cheat_mypos
```

Tracks the mutable cheat mypos value used by the st stuff subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/st_stuff.ml#L395)

<a id="global-global-cheat-noclip-cheat-noclip-src-st-stuff-ml-959410550"></a>
### cheat_noclip

```ml
cheat_noclip
```

Tracks the mutable cheat noclip value used by the st stuff subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/st_stuff.ml#L379)

<a id="global-global-cheat-powerup-cheat-powerup-src-st-stuff-ml-133996556"></a>
### cheat_powerup

```ml
cheat_powerup
```

Stores the cheat powerup collection used by the st stuff subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/st_stuff.ml#L383)

<a id="global-global-lu-palette-lu-palette-src-st-stuff-ml-1923646538"></a>
### lu_palette

```ml
lu_palette
```

Tracks the mutable lu palette value used by the st stuff subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/st_stuff.ml#L238)

<a id="constant-constant-numbonuspals-const-numbonuspals-4-src-st-stuff-ml-220810211"></a>
### NUMBONUSPALS

```ml
const NUMBONUSPALS = 4
```

Defines the numbonuspals count used by the st stuff subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/st_stuff.ml#L60)

<a id="constant-constant-numredpals-const-numredpals-8-src-st-stuff-ml-128342827"></a>
### NUMREDPALS

```ml
const NUMREDPALS = 8
```

Defines the numredpals count used by the st stuff subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/st_stuff.ml#L58)

<a id="constant-constant-radiationpal-const-radiationpal-13-src-st-stuff-ml-762296407"></a>
### RADIATIONPAL

```ml
const RADIATIONPAL = 13
```

Defines radiationpal for the st stuff subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/st_stuff.ml#L62)

<a id="constant-constant-st-ammo0width-const-st-ammo0width-3-src-st-stuff-ml-521792786"></a>
### ST_AMMO0WIDTH

```ml
const ST_AMMO0WIDTH = 3
```

Defines st ammo0 width for the st stuff subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/st_stuff.ml#L165)

<a id="constant-constant-st-ammo0x-const-st-ammo0x-288-src-st-stuff-ml-353139661"></a>
### ST_AMMO0X

```ml
const ST_AMMO0X = 288
```

Defines st ammo0 x for the st stuff subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/st_stuff.ml#L167)

<a id="constant-constant-st-ammo0y-const-st-ammo0y-173-src-st-stuff-ml-1696386050"></a>
### ST_AMMO0Y

```ml
const ST_AMMO0Y = 173
```

Defines st ammo0 y for the st stuff subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/st_stuff.ml#L169)

<a id="constant-constant-st-ammo1width-const-st-ammo1width-st-ammo0width-src-st-stuff-ml-2008859769"></a>
### ST_AMMO1WIDTH

```ml
const ST_AMMO1WIDTH = ST_AMMO0WIDTH
```

Defines st ammo1 width for the st stuff subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/st_stuff.ml#L171)

<a id="constant-constant-st-ammo1x-const-st-ammo1x-288-src-st-stuff-ml-781690965"></a>
### ST_AMMO1X

```ml
const ST_AMMO1X = 288
```

Defines st ammo1 x for the st stuff subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/st_stuff.ml#L173)

<a id="constant-constant-st-ammo1y-const-st-ammo1y-179-src-st-stuff-ml-624932552"></a>
### ST_AMMO1Y

```ml
const ST_AMMO1Y = 179
```

Defines st ammo1 y for the st stuff subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/st_stuff.ml#L175)

<a id="constant-constant-st-ammo2width-const-st-ammo2width-st-ammo0width-src-st-stuff-ml-556546577"></a>
### ST_AMMO2WIDTH

```ml
const ST_AMMO2WIDTH = ST_AMMO0WIDTH
```

Defines st ammo2 width for the st stuff subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/st_stuff.ml#L177)

<a id="constant-constant-st-ammo2x-const-st-ammo2x-288-src-st-stuff-ml-1513461145"></a>
### ST_AMMO2X

```ml
const ST_AMMO2X = 288
```

Defines st ammo2 x for the st stuff subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/st_stuff.ml#L179)

<a id="constant-constant-st-ammo2y-const-st-ammo2y-191-src-st-stuff-ml-1001678830"></a>
### ST_AMMO2Y

```ml
const ST_AMMO2Y = 191
```

Defines st ammo2 y for the st stuff subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/st_stuff.ml#L181)

<a id="constant-constant-st-ammo3width-const-st-ammo3width-st-ammo0width-src-st-stuff-ml-197981185"></a>
### ST_AMMO3WIDTH

```ml
const ST_AMMO3WIDTH = ST_AMMO0WIDTH
```

Defines st ammo3 width for the st stuff subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/st_stuff.ml#L183)

<a id="constant-constant-st-ammo3x-const-st-ammo3x-288-src-st-stuff-ml-874502337"></a>
### ST_AMMO3X

```ml
const ST_AMMO3X = 288
```

Defines st ammo3 x for the st stuff subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/st_stuff.ml#L185)

<a id="constant-constant-st-ammo3y-const-st-ammo3y-185-src-st-stuff-ml-1715061531"></a>
### ST_AMMO3Y

```ml
const ST_AMMO3Y = 185
```

Defines st ammo3 y for the st stuff subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/st_stuff.ml#L187)

<a id="global-global-st-ammo-refs-st-ammo-refs-src-st-stuff-ml-1471961734"></a>
### st_ammo_refs

```ml
st_ammo_refs
```

Stores the st ammo refs collection used by the st stuff subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/st_stuff.ml#L303)

<a id="constant-constant-st-ammowidth-const-st-ammowidth-3-src-st-stuff-ml-637067836"></a>
### ST_AMMOWIDTH

```ml
const ST_AMMOWIDTH = 3
```

Defines st ammowidth for the st stuff subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/st_stuff.ml#L111)

<a id="constant-constant-st-ammox-const-st-ammox-44-src-st-stuff-ml-1262649663"></a>
### ST_AMMOX

```ml
const ST_AMMOX = 44
```

Defines st ammox for the st stuff subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/st_stuff.ml#L113)

<a id="constant-constant-st-ammoy-const-st-ammoy-171-src-st-stuff-ml-1795348116"></a>
### ST_AMMOY

```ml
const ST_AMMOY = 171
```

Defines st ammoy for the st stuff subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/st_stuff.ml#L115)

<a id="global-global-st-armor-ref-st-armor-ref-src-st-stuff-ml-2024878334"></a>
### st_armor_ref

```ml
st_armor_ref
```

Stores the st armor ref collection used by the st stuff subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/st_stuff.ml#L293)

<a id="constant-constant-st-armorwidth-const-st-armorwidth-3-src-st-stuff-ml-465124634"></a>
### ST_ARMORWIDTH

```ml
const ST_ARMORWIDTH = 3
```

Defines st armorwidth for the st stuff subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/st_stuff.ml#L145)

<a id="constant-constant-st-armorx-const-st-armorx-221-src-st-stuff-ml-23704612"></a>
### ST_ARMORX

```ml
const ST_ARMORX = 221
```

Defines st armorx for the st stuff subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/st_stuff.ml#L147)

<a id="constant-constant-st-armory-const-st-armory-171-src-st-stuff-ml-260378580"></a>
### ST_ARMORY

```ml
const ST_ARMORY = 171
```

Defines st armory for the st stuff subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/st_stuff.ml#L149)

<a id="global-global-st-arms-patches-st-arms-patches-src-st-stuff-ml-1545519960"></a>
### st_arms_patches

```ml
st_arms_patches
```

Stores the st arms patches collection used by the st stuff subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/st_stuff.ml#L286)

<a id="global-global-st-armsbg-patch-st-armsbg-patch-src-st-stuff-ml-2068450276"></a>
### st_armsbg_patch

```ml
st_armsbg_patch
```

Holds the optional st armsbg patch resource used by the st stuff subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/st_stuff.ml#L274)

<a id="constant-constant-st-armsbgx-const-st-armsbgx-104-src-st-stuff-ml-148743806"></a>
### ST_ARMSBGX

```ml
const ST_ARMSBGX = 104
```

Defines st armsbgx for the st stuff subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/st_stuff.ml#L129)

<a id="constant-constant-st-armsbgy-const-st-armsbgy-168-src-st-stuff-ml-1058086234"></a>
### ST_ARMSBGY

```ml
const ST_ARMSBGY = 168
```

Defines st armsbgy for the st stuff subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/st_stuff.ml#L131)

<a id="global-global-st-armson-ref-st-armson-ref-src-st-stuff-ml-234849428"></a>
### st_armson_ref

```ml
st_armson_ref
```

Stores the st armson ref collection used by the st stuff subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/st_stuff.ml#L255)

<a id="constant-constant-st-armsx-const-st-armsx-111-src-st-stuff-ml-1733316330"></a>
### ST_ARMSX

```ml
const ST_ARMSX = 111
```

Defines st armsx for the st stuff subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/st_stuff.ml#L125)

<a id="constant-constant-st-armsxspace-const-st-armsxspace-12-src-st-stuff-ml-315415718"></a>
### ST_ARMSXSPACE

```ml
const ST_ARMSXSPACE = 12
```

Defines st armsxspace for the st stuff subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/st_stuff.ml#L133)

<a id="constant-constant-st-armsy-const-st-armsy-172-src-st-stuff-ml-1939416435"></a>
### ST_ARMSY

```ml
const ST_ARMSY = 172
```

Defines st armsy for the st stuff subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/st_stuff.ml#L127)

<a id="constant-constant-st-armsyspace-const-st-armsyspace-10-src-st-stuff-ml-983129728"></a>
### ST_ARMSYSPACE

```ml
const ST_ARMSYSPACE = 10
```

Defines st armsyspace for the st stuff subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/st_stuff.ml#L135)

<a id="global-global-st-calc-oldhealth-st-calc-oldhealth-src-st-stuff-ml-614134376"></a>
### st_calc_oldhealth

```ml
st_calc_oldhealth
```

Tracks the mutable st calc oldhealth value used by the st stuff subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/st_stuff.ml#L366)

<a id="function-function-st-calcpainoffset-function-st-calcpainoffset-src-st-stuff-ml-77405746"></a>
### ST_calcPainOffset

```ml
function ST_calcPainOffset()
```

Maps clamped health to the cached five-tier face-patch row offset.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/st_stuff.ml#L652)

<a id="global-global-st-chat-st-chat-src-st-stuff-ml-2059079528"></a>
### st_chat

```ml
st_chat
```

Tracks whether st chat is active in the st stuff subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/st_stuff.ml#L260)

<a id="global-global-st-chatstate-st-chatstate-src-st-stuff-ml-853906450"></a>
### st_chatstate

```ml
st_chatstate
```

Exposes `st_chatstateenum_t.StartChatState` through the legacy `st_chatstate` alias.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/st_stuff.ml#L244)

- [st_chatstateenum_t](Type-st-chatstateenum-t-43006936.md) — enum
<a id="global-global-st-clock-st-clock-src-st-stuff-ml-730529608"></a>
### st_clock

```ml
st_clock
```

Tracks the mutable st clock value used by the st stuff subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/st_stuff.ml#L240)

<a id="function-function-st-createwidgets-function-st-createwidgets-src-st-stuff-ml-1644037126"></a>
### ST_createWidgets

```ml
function ST_createWidgets()
```

Binds every status-bar widget to its screen coordinates, patch set, value reference, and visibility reference.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/st_stuff.ml#L1172)

<a id="global-global-st-cursoron-st-cursoron-src-st-stuff-ml-539986340"></a>
### st_cursoron

```ml
st_cursoron
```

Tracks whether st cursoron is active in the st stuff subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/st_stuff.ml#L264)

<a id="constant-constant-st-deadface-const-st-deadface-st-godface-1-src-st-stuff-ml-222625044"></a>
### ST_DEADFACE

```ml
const ST_DEADFACE = ST_GODFACE + 1
```

Defines st deadface for the st stuff subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/st_stuff.ml#L94)

<a id="function-function-st-diffdraw-function-st-diffdraw-src-st-stuff-ml-938534284"></a>
### ST_diffDraw

```ml
function ST_diffDraw()
```

Redraws only widgets whose referenced values changed since the previous frame.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/st_stuff.ml#L1001)

<a id="function-function-st-dopalettestuff-function-st-dopalettestuff-src-st-stuff-ml-1488779158"></a>
### ST_doPaletteStuff

```ml
function ST_doPaletteStuff()
```

Selects damage, bonus, or radiation palette feedback and routes OpenGL flashes separately from indexed palettes.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/st_stuff.ml#L888)

<a id="function-function-st-dorefresh-function-st-dorefresh-src-st-stuff-ml-432325286"></a>
### ST_doRefresh

```ml
function ST_doRefresh()
```

Clears the first-frame flag, restores the static background, and forces every dynamic widget to redraw.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/st_stuff.ml#L993)

<a id="function-function-st-drawer-function-st-drawer-fullscreen-refresh-src-st-stuff-ml-68389006"></a>
### ST_Drawer

```ml
function ST_Drawer(fullscreen, refresh)
```

Chooses full or differential status redraw, synchronizes fullscreen/automap visibility, and applies palette feedback.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `fullscreen` | `dynamic` | — | Fullscreen value supplied to `ST_Drawer`. |
| `refresh` | `dynamic` | — | Refresh value supplied to `ST_Drawer`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/st_stuff.ml#L1429)

<a id="function-function-st-drawwidgets-function-st-drawwidgets-refresh-src-st-stuff-ml-307986157"></a>
### ST_drawWidgets

```ml
function ST_drawWidgets(refresh)
```

Draws enabled ammo, health, armor, arms/frags, face, and key widgets in dependency-safe order.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `refresh` | `dynamic` | — | Refresh value supplied to `ST_drawWidgets`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/st_stuff.ml#L956)

<a id="constant-constant-st-evilgrincount-const-st-evilgrincount-2-ticrate-src-st-stuff-ml-113859645"></a>
### ST_EVILGRINCOUNT

```ml
const ST_EVILGRINCOUNT = 2 * TICRATE
```

Defines st evilgrincount for the st stuff subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/st_stuff.ml#L100)

<a id="constant-constant-st-evilgrinoffset-const-st-evilgrinoffset-st-ouchoffset-1-src-st-stuff-ml-1687188009"></a>
### ST_EVILGRINOFFSET

```ml
const ST_EVILGRINOFFSET = ST_OUCHOFFSET + 1
```

Defines st evilgrinoffset for the st stuff subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/st_stuff.ml#L88)

<a id="global-global-st-face-ref-st-face-ref-src-st-stuff-ml-2117732968"></a>
### st_face_ref

```ml
st_face_ref
```

Stores the st face ref collection used by the st stuff subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/st_stuff.ml#L297)

<a id="global-global-st-faceback-st-faceback-src-st-stuff-ml-417185840"></a>
### st_faceback

```ml
st_faceback
```

Holds the optional st faceback resource used by the st stuff subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/st_stuff.ml#L272)

<a id="global-global-st-facecount-st-facecount-src-st-stuff-ml-843985000"></a>
### st_facecount

```ml
st_facecount
```

Tracks the mutable st facecount value used by the st stuff subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/st_stuff.ml#L350)

<a id="global-global-st-faceindex-st-faceindex-src-st-stuff-ml-1270751554"></a>
### st_faceindex

```ml
st_faceindex
```

Tracks the mutable st faceindex value used by the st stuff subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/st_stuff.ml#L352)

<a id="global-global-st-facepriority-st-facepriority-src-st-stuff-ml-256270016"></a>
### st_facepriority

```ml
st_facepriority
```

Tracks the mutable st facepriority value used by the st stuff subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/st_stuff.ml#L354)

<a id="global-global-st-faces-st-faces-src-st-stuff-ml-1768029752"></a>
### st_faces

```ml
st_faces
```

Stores the st faces collection used by the st stuff subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/st_stuff.ml#L284)

<a id="constant-constant-st-facestride-const-st-facestride-st-numstraightfaces-st-numturnfaces-st-numspecialfaces-src-st-stuff-ml-942561123"></a>
### ST_FACESTRIDE

```ml
const ST_FACESTRIDE = ST_NUMSTRAIGHTFACES + ST_NUMTURNFACES + ST_NUMSPECIALFACES
```

Defines st facestride for the st stuff subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/st_stuff.ml#L78)

<a id="constant-constant-st-facesx-const-st-facesx-143-src-st-stuff-ml-278125757"></a>
### ST_FACESX

```ml
const ST_FACESX = 143
```

Defines st facesx for the st stuff subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/st_stuff.ml#L96)

<a id="constant-constant-st-facesy-const-st-facesy-168-src-st-stuff-ml-1368936962"></a>
### ST_FACESY

```ml
const ST_FACESY = 168
```

Defines st facesy for the st stuff subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/st_stuff.ml#L98)

<a id="global-global-st-firsttime-st-firsttime-src-st-stuff-ml-395317618"></a>
### st_firsttime

```ml
st_firsttime
```

Tracks whether st firsttime is active in the st stuff subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/st_stuff.ml#L233)

<a id="function-function-st-forcerefresh-function-st-forcerefresh-src-st-stuff-ml-201583414"></a>
### ST_ForceRefresh

```ml
function ST_ForceRefresh()
```

Forces the next status bar draw to rebuild all static and dynamic widgets.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/st_stuff.ml#L1419)

<a id="global-global-st-frags-ref-st-frags-ref-src-st-stuff-ml-1814656514"></a>
### st_frags_ref

```ml
st_frags_ref
```

Stores the st frags ref collection used by the st stuff subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/st_stuff.ml#L295)

<a id="global-global-st-fragson-ref-st-fragson-ref-src-st-stuff-ml-1276917624"></a>
### st_fragson_ref

```ml
st_fragson_ref
```

Stores the st fragson ref collection used by the st stuff subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/st_stuff.ml#L257)

<a id="constant-constant-st-fragswidth-const-st-fragswidth-2-src-st-stuff-ml-1478364109"></a>
### ST_FRAGSWIDTH

```ml
const ST_FRAGSWIDTH = 2
```

Defines st fragswidth for the st stuff subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/st_stuff.ml#L142)

<a id="constant-constant-st-fragsx-const-st-fragsx-138-src-st-stuff-ml-2013412479"></a>
### ST_FRAGSX

```ml
const ST_FRAGSX = 138
```

Defines st fragsx for the st stuff subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/st_stuff.ml#L138)

<a id="constant-constant-st-fragsy-const-st-fragsy-171-src-st-stuff-ml-1419719048"></a>
### ST_FRAGSY

```ml
const ST_FRAGSY = 171
```

Defines st fragsy for the st stuff subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/st_stuff.ml#L140)

<a id="constant-constant-st-fx-const-st-fx-143-src-st-stuff-ml-1685864621"></a>
### ST_FX

```ml
const ST_FX = 143
```

Defines st fx for the st stuff subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/st_stuff.ml#L65)

<a id="constant-constant-st-fy-const-st-fy-169-src-st-stuff-ml-1453851737"></a>
### ST_FY

```ml
const ST_FY = 169
```

Defines st fy for the st stuff subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/st_stuff.ml#L67)

<a id="constant-constant-st-godface-const-st-godface-st-numpainfaces-st-facestride-src-st-stuff-ml-512289519"></a>
### ST_GODFACE

```ml
const ST_GODFACE = ST_NUMPAINFACES * ST_FACESTRIDE
```

Defines st godface for the st stuff subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/st_stuff.ml#L92)

<a id="global-global-st-health-ref-st-health-ref-src-st-stuff-ml-601387404"></a>
### st_health_ref

```ml
st_health_ref
```

Stores the st health ref collection used by the st stuff subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/st_stuff.ml#L291)

<a id="constant-constant-st-healthwidth-const-st-healthwidth-3-src-st-stuff-ml-987195204"></a>
### ST_HEALTHWIDTH

```ml
const ST_HEALTHWIDTH = 3
```

Defines st healthwidth for the st stuff subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/st_stuff.ml#L118)

<a id="constant-constant-st-healthx-const-st-healthx-90-src-st-stuff-ml-1879832534"></a>
### ST_HEALTHX

```ml
const ST_HEALTHX = 90
```

Defines st healthx for the st stuff subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/st_stuff.ml#L120)

<a id="constant-constant-st-healthy-const-st-healthy-171-src-st-stuff-ml-1312166888"></a>
### ST_HEALTHY

```ml
const ST_HEALTHY = 171
```

Defines st healthy for the st stuff subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/st_stuff.ml#L122)

<a id="constant-constant-st-height-const-st-height-32-src-st-stuff-ml-818543896"></a>
### ST_HEIGHT

```ml
const ST_HEIGHT = 32
```

Defines st height for the st stuff subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/st_stuff.ml#L47)

<a id="function-function-st-init-function-st-init-src-st-stuff-ml-2053265042"></a>
### ST_Init

```ml
function ST_Init()
```

Loads status resources, allocates the dedicated 320x32 background screen, and requests an initial full draw.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/st_stuff.ml#L1451)

<a id="function-function-st-initdata-function-st-initdata-src-st-stuff-ml-91352570"></a>
### ST_initData

```ml
function ST_initData()
```

Resets status/chat/face/palette history and snapshots initial player weapon ownership for a new level.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/st_stuff.ml#L1114)

<a id="constant-constant-st-key0x-const-st-key0x-239-src-st-stuff-ml-1778284305"></a>
### ST_KEY0X

```ml
const ST_KEY0X = 239
```

Defines st key0 x for the st stuff subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/st_stuff.ml#L152)

<a id="constant-constant-st-key0y-const-st-key0y-171-src-st-stuff-ml-1609450018"></a>
### ST_KEY0Y

```ml
const ST_KEY0Y = 171
```

Defines st key0 y for the st stuff subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/st_stuff.ml#L154)

<a id="constant-constant-st-key1x-const-st-key1x-239-src-st-stuff-ml-894267287"></a>
### ST_KEY1X

```ml
const ST_KEY1X = 239
```

Defines st key1 x for the st stuff subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/st_stuff.ml#L156)

<a id="constant-constant-st-key1y-const-st-key1y-181-src-st-stuff-ml-1659874019"></a>
### ST_KEY1Y

```ml
const ST_KEY1Y = 181
```

Defines st key1 y for the st stuff subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/st_stuff.ml#L158)

<a id="constant-constant-st-key2x-const-st-key2x-239-src-st-stuff-ml-1885087517"></a>
### ST_KEY2X

```ml
const ST_KEY2X = 239
```

Defines st key2 x for the st stuff subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/st_stuff.ml#L160)

<a id="constant-constant-st-key2y-const-st-key2y-191-src-st-stuff-ml-1632359340"></a>
### ST_KEY2Y

```ml
const ST_KEY2Y = 191
```

Defines st key2 y for the st stuff subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/st_stuff.ml#L162)

<a id="global-global-st-keyrefs-st-keyrefs-src-st-stuff-ml-1901860154"></a>
### st_keyrefs

```ml
st_keyrefs
```

Stores the st keyrefs collection used by the st stuff subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/st_stuff.ml#L299)

<a id="global-global-st-keys-st-keys-src-st-stuff-ml-677057504"></a>
### st_keys

```ml
st_keys
```

Stores the st keys collection used by the st stuff subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/st_stuff.ml#L282)

<a id="global-global-st-lastattackdown-st-lastattackdown-src-st-stuff-ml-1852946424"></a>
### st_lastattackdown

```ml
st_lastattackdown
```

Tracks the mutable st lastattackdown value used by the st stuff subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/st_stuff.ml#L360)

<a id="global-global-st-lastcalc-st-lastcalc-src-st-stuff-ml-881164060"></a>
### st_lastcalc

```ml
st_lastcalc
```

Tracks the mutable st lastcalc value used by the st stuff subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/st_stuff.ml#L364)

<a id="function-function-st-loaddata-function-st-loaddata-src-st-stuff-ml-1753217774"></a>
### ST_loadData

```ml
function ST_loadData()
```

Resolves the PLAYPAL lump and loads the complete status-bar patch set.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/st_stuff.ml#L1073)

<a id="function-function-st-loadgraphics-function-st-loadgraphics-src-st-stuff-ml-112509780"></a>
### ST_loadGraphics

```ml
function ST_loadGraphics()
```

Caches and names all number, key, arms, face, faceback, and background patches used by status widgets.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/st_stuff.ml#L1006)

<a id="constant-constant-st-maxammo0width-const-st-maxammo0width-3-src-st-stuff-ml-2089672200"></a>
### ST_MAXAMMO0WIDTH

```ml
const ST_MAXAMMO0WIDTH = 3
```

Defines the maximum st maxammo0 width accepted by the st stuff subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/st_stuff.ml#L190)

<a id="constant-constant-st-maxammo0x-const-st-maxammo0x-314-src-st-stuff-ml-712021805"></a>
### ST_MAXAMMO0X

```ml
const ST_MAXAMMO0X = 314
```

Defines the maximum st maxammo0 x accepted by the st stuff subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/st_stuff.ml#L192)

<a id="constant-constant-st-maxammo0y-const-st-maxammo0y-173-src-st-stuff-ml-1569736706"></a>
### ST_MAXAMMO0Y

```ml
const ST_MAXAMMO0Y = 173
```

Defines the maximum st maxammo0 y accepted by the st stuff subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/st_stuff.ml#L194)

<a id="constant-constant-st-maxammo1width-const-st-maxammo1width-st-maxammo0width-src-st-stuff-ml-1059038321"></a>
### ST_MAXAMMO1WIDTH

```ml
const ST_MAXAMMO1WIDTH = ST_MAXAMMO0WIDTH
```

Defines the maximum st maxammo1 width accepted by the st stuff subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/st_stuff.ml#L196)

<a id="constant-constant-st-maxammo1x-const-st-maxammo1x-314-src-st-stuff-ml-176044511"></a>
### ST_MAXAMMO1X

```ml
const ST_MAXAMMO1X = 314
```

Defines the maximum st maxammo1 x accepted by the st stuff subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/st_stuff.ml#L198)

<a id="constant-constant-st-maxammo1y-const-st-maxammo1y-179-src-st-stuff-ml-932125830"></a>
### ST_MAXAMMO1Y

```ml
const ST_MAXAMMO1Y = 179
```

Defines the maximum st maxammo1 y accepted by the st stuff subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/st_stuff.ml#L200)

<a id="constant-constant-st-maxammo2width-const-st-maxammo2width-st-maxammo0width-src-st-stuff-ml-1255004547"></a>
### ST_MAXAMMO2WIDTH

```ml
const ST_MAXAMMO2WIDTH = ST_MAXAMMO0WIDTH
```

Defines the maximum st maxammo2 width accepted by the st stuff subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/st_stuff.ml#L202)

<a id="constant-constant-st-maxammo2x-const-st-maxammo2x-314-src-st-stuff-ml-1164265449"></a>
### ST_MAXAMMO2X

```ml
const ST_MAXAMMO2X = 314
```

Defines the maximum st maxammo2 x accepted by the st stuff subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/st_stuff.ml#L204)

<a id="constant-constant-st-maxammo2y-const-st-maxammo2y-191-src-st-stuff-ml-1986637066"></a>
### ST_MAXAMMO2Y

```ml
const ST_MAXAMMO2Y = 191
```

Defines the maximum st maxammo2 y accepted by the st stuff subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/st_stuff.ml#L206)

<a id="constant-constant-st-maxammo3width-const-st-maxammo3width-st-maxammo0width-src-st-stuff-ml-1520310165"></a>
### ST_MAXAMMO3WIDTH

```ml
const ST_MAXAMMO3WIDTH = ST_MAXAMMO0WIDTH
```

Defines the maximum st maxammo3 width accepted by the st stuff subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/st_stuff.ml#L208)

<a id="constant-constant-st-maxammo3x-const-st-maxammo3x-314-src-st-stuff-ml-1659487359"></a>
### ST_MAXAMMO3X

```ml
const ST_MAXAMMO3X = 314
```

Defines the maximum st maxammo3 x accepted by the st stuff subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/st_stuff.ml#L210)

<a id="constant-constant-st-maxammo3y-const-st-maxammo3y-185-src-st-stuff-ml-1143615861"></a>
### ST_MAXAMMO3Y

```ml
const ST_MAXAMMO3Y = 185
```

Defines the maximum st maxammo3 y accepted by the st stuff subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/st_stuff.ml#L212)

<a id="global-global-st-maxammo-refs-st-maxammo-refs-src-st-stuff-ml-2063403168"></a>
### st_maxammo_refs

```ml
st_maxammo_refs
```

Stores the st maxammo refs collection used by the st stuff subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/st_stuff.ml#L305)

<a id="global-global-st-msgcounter-st-msgcounter-src-st-stuff-ml-772645488"></a>
### st_msgcounter

```ml
st_msgcounter
```

Tracks the mutable st msgcounter value used by the st stuff subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/st_stuff.ml#L242)

<a id="constant-constant-st-muchpain-const-st-muchpain-20-src-st-stuff-ml-1009448083"></a>
### ST_MUCHPAIN

```ml
const ST_MUCHPAIN = 20
```

Defines st muchpain for the st stuff subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/st_stuff.ml#L108)

<a id="global-global-st-notdeathmatch-ref-st-notdeathmatch-ref-src-st-stuff-ml-209882020"></a>
### st_notdeathmatch_ref

```ml
st_notdeathmatch_ref
```

Stores the st notdeathmatch ref collection used by the st stuff subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/st_stuff.ml#L253)

<a id="constant-constant-st-numextrafaces-const-st-numextrafaces-2-src-st-stuff-ml-604319975"></a>
### ST_NUMEXTRAFACES

```ml
const ST_NUMEXTRAFACES = 2
```

Defines the st numextrafaces count used by the st stuff subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/st_stuff.ml#L80)

<a id="constant-constant-st-numfaces-const-st-numfaces-st-facestride-st-numpainfaces-st-numextrafaces-src-st-stuff-ml-433775462"></a>
### ST_NUMFACES

```ml
const ST_NUMFACES = ST_FACESTRIDE * ST_NUMPAINFACES + ST_NUMEXTRAFACES
```

Defines the st numfaces count used by the st stuff subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/st_stuff.ml#L82)

<a id="constant-constant-st-numpainfaces-const-st-numpainfaces-5-src-st-stuff-ml-1919509956"></a>
### ST_NUMPAINFACES

```ml
const ST_NUMPAINFACES = 5
```

Defines the st numpainfaces count used by the st stuff subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/st_stuff.ml#L70)

<a id="constant-constant-st-numspecialfaces-const-st-numspecialfaces-3-src-st-stuff-ml-642410018"></a>
### ST_NUMSPECIALFACES

```ml
const ST_NUMSPECIALFACES = 3
```

Defines the st numspecialfaces count used by the st stuff subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/st_stuff.ml#L76)

<a id="constant-constant-st-numstraightfaces-const-st-numstraightfaces-3-src-st-stuff-ml-1027074990"></a>
### ST_NUMSTRAIGHTFACES

```ml
const ST_NUMSTRAIGHTFACES = 3
```

Defines the st numstraightfaces count used by the st stuff subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/st_stuff.ml#L72)

<a id="constant-constant-st-numturnfaces-const-st-numturnfaces-2-src-st-stuff-ml-1741361609"></a>
### ST_NUMTURNFACES

```ml
const ST_NUMTURNFACES = 2
```

Defines the st numturnfaces count used by the st stuff subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/st_stuff.ml#L74)

<a id="global-global-st-oldchat-st-oldchat-src-st-stuff-ml-114560878"></a>
### st_oldchat

```ml
st_oldchat
```

Tracks whether st oldchat is active in the st stuff subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/st_stuff.ml#L262)

<a id="global-global-st-oldhealth-st-oldhealth-src-st-stuff-ml-1950574278"></a>
### st_oldhealth

```ml
st_oldhealth
```

Tracks the mutable st oldhealth value used by the st stuff subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/st_stuff.ml#L356)

<a id="global-global-st-oldweaponsowned-st-oldweaponsowned-src-st-stuff-ml-1952540010"></a>
### st_oldweaponsowned

```ml
st_oldweaponsowned
```

Stores the st oldweaponsowned collection used by the st stuff subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/st_stuff.ml#L358)

<a id="constant-constant-st-ouchoffset-const-st-ouchoffset-st-turnoffset-st-numturnfaces-src-st-stuff-ml-1896754425"></a>
### ST_OUCHOFFSET

```ml
const ST_OUCHOFFSET = ST_TURNOFFSET + ST_NUMTURNFACES
```

Defines st ouchoffset for the st stuff subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/st_stuff.ml#L86)

<a id="global-global-st-palette-st-palette-src-st-stuff-ml-39565858"></a>
### st_palette

```ml
st_palette
```

Tracks the mutable st palette value used by the st stuff subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/st_stuff.ml#L248)

<a id="global-global-st-plyr-st-plyr-src-st-stuff-ml-1975442004"></a>
### st_plyr

```ml
st_plyr
```

Holds the optional st plyr resource used by the st stuff subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/st_stuff.ml#L267)

<a id="constant-constant-st-rampagedelay-const-st-rampagedelay-2-ticrate-src-st-stuff-ml-1123857481"></a>
### ST_RAMPAGEDELAY

```ml
const ST_RAMPAGEDELAY = 2 * TICRATE
```

Defines st rampagedelay for the st stuff subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/st_stuff.ml#L106)

<a id="constant-constant-st-rampageoffset-const-st-rampageoffset-st-evilgrinoffset-1-src-st-stuff-ml-1350906352"></a>
### ST_RAMPAGEOFFSET

```ml
const ST_RAMPAGEOFFSET = ST_EVILGRINOFFSET + 1
```

Defines st rampageoffset for the st stuff subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/st_stuff.ml#L90)

<a id="global-global-st-randomnumber-st-randomnumber-src-st-stuff-ml-403493328"></a>
### st_randomnumber

```ml
st_randomnumber
```

Tracks the mutable st randomnumber value used by the st stuff subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/st_stuff.ml#L362)

<a id="global-global-st-ready-ref-st-ready-ref-src-st-stuff-ml-258547862"></a>
### st_ready_ref

```ml
st_ready_ref
```

Stores the st ready ref collection used by the st stuff subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/st_stuff.ml#L289)

<a id="function-function-st-refreshbackground-function-st-refreshbackground-src-st-stuff-ml-628960942"></a>
### ST_refreshBackground

```ml
function ST_refreshBackground()
```

Rebuilds the static classic status-bar background, multiplayer faceback, and optional HD overlays.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/st_stuff.ml#L935)

<a id="function-function-st-responder-function-st-responder-ev-src-st-stuff-ml-960601707"></a>
### ST_Responder

```ml
function ST_Responder(ev)
```

Consumes automap enter/exit messages and recognized cheat sequences, including map-warp validation.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `ev` | `dynamic` | — | Input event to process. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/st_stuff.ml#L1251)

<a id="global-global-st-shortnum-st-shortnum-src-st-stuff-ml-1864927224"></a>
### st_shortnum

```ml
st_shortnum
```

Stores the st shortnum collection used by the st stuff subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/st_stuff.ml#L280)

<a id="function-function-st-start-function-st-start-src-st-stuff-ml-255929498"></a>
### ST_Start

```ml
function ST_Start()
```

Ensures graphics are loaded, resets per-level state, creates widgets, and activates status rendering.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/st_stuff.ml#L1216)

<a id="global-global-st-started-st-started-src-st-stuff-ml-1841888430"></a>
### st_started

```ml
st_started
```

Tracks whether st started is active in the st stuff subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/st_stuff.ml#L235)

<a id="global-global-st-state-st-state-src-st-stuff-ml-2053597866"></a>
### st_state

```ml
st_state
```

Exposes `st_stateenum_t.FirstPersonState` through the legacy `st_state` alias.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/st_stuff.ml#L246)

- [st_stateenum_t](Type-st-stateenum-t-304238318.md) — enum
<a id="global-global-st-statusbaron-ref-st-statusbaron-ref-src-st-stuff-ml-880055424"></a>
### st_statusbaron_ref

```ml
st_statusbaron_ref
```

Stores the st statusbaron ref collection used by the st stuff subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/st_stuff.ml#L251)

<a id="global-global-st-stbar-st-stbar-src-st-stuff-ml-1990006408"></a>
### st_stbar

```ml
st_stbar
```

Holds the optional st stbar resource used by the st stuff subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/st_stuff.ml#L270)

<a id="function-function-st-stop-function-st-stop-src-st-stuff-ml-2126394670"></a>
### ST_Stop

```ml
function ST_Stop()
```

Restores the base PLAYPAL palette and deactivates status-bar rendering.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/st_stuff.ml#L1233)

<a id="constant-constant-st-straightfacecount-const-st-straightfacecount-ticrate-1-src-st-stuff-ml-1552453530"></a>
### ST_STRAIGHTFACECOUNT

```ml
const ST_STRAIGHTFACECOUNT = TICRATE >> 1
```

Defines st straightfacecount for the st stuff subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/st_stuff.ml#L102)

<a id="global-global-st-tallnum-st-tallnum-src-st-stuff-ml-216265954"></a>
### st_tallnum

```ml
st_tallnum
```

Stores the st tallnum collection used by the st stuff subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/st_stuff.ml#L276)

<a id="global-global-st-tallpercent-st-tallpercent-src-st-stuff-ml-680790648"></a>
### st_tallpercent

```ml
st_tallpercent
```

Holds the optional st tallpercent resource used by the st stuff subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/st_stuff.ml#L278)

<a id="function-function-st-ticker-function-st-ticker-src-st-stuff-ml-1986405426"></a>
### ST_Ticker

```ml
function ST_Ticker()
```

Samples a new random face value, refreshes widget references, and records health once per game tic.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/st_stuff.ml#L874)

<a id="constant-constant-st-turncount-const-st-turncount-ticrate-src-st-stuff-ml-1823152799"></a>
### ST_TURNCOUNT

```ml
const ST_TURNCOUNT = TICRATE
```

Defines st turncount for the st stuff subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/st_stuff.ml#L104)

<a id="constant-constant-st-turnoffset-const-st-turnoffset-st-numstraightfaces-src-st-stuff-ml-478151823"></a>
### ST_TURNOFFSET

```ml
const ST_TURNOFFSET = ST_NUMSTRAIGHTFACES
```

Defines st turnoffset for the st stuff subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/st_stuff.ml#L84)

<a id="function-function-st-unloaddata-function-st-unloaddata-src-st-stuff-ml-1461794516"></a>
### ST_unloadData

```ml
function ST_unloadData()
```

Releases status-bar graphics through the module's data-teardown entry point.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/st_stuff.ml#L1109)

<a id="function-function-st-unloadgraphics-function-st-unloadgraphics-src-st-stuff-ml-622582606"></a>
### ST_unloadGraphics

```ml
function ST_unloadGraphics()
```

Drops all status-bar patch references and clears compound arms icon slots.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/st_stuff.ml#L1084)

<a id="function-function-st-updatefacewidget-function-st-updatefacewidget-src-st-stuff-ml-475121390"></a>
### ST_updateFaceWidget

```ml
function ST_updateFaceWidget()
```

Runs the prioritized death, grin, damage-direction, rampage, god, and idle face state machine.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/st_stuff.ml#L670)

<a id="function-function-st-updatewidgets-function-st-updatewidgets-src-st-stuff-ml-542107790"></a>
### ST_updateWidgets

```ml
function ST_updateWidgets()
```

Copies current player health/armor/ammo/keys/weapons/frags into widget references and advances face/message state.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/st_stuff.ml#L798)

<a id="global-global-st-weaponowned-refs-st-weaponowned-refs-src-st-stuff-ml-460253088"></a>
### st_weaponowned_refs

```ml
st_weaponowned_refs
```

Stores the st weaponowned refs collection used by the st stuff subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/st_stuff.ml#L301)

<a id="constant-constant-st-width-const-st-width-320-src-st-stuff-ml-847983290"></a>
### ST_WIDTH

```ml
const ST_WIDTH = 320
```

Defines st width for the st stuff subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/st_stuff.ml#L49)

<a id="constant-constant-st-y-const-st-y-168-src-st-stuff-ml-1967215082"></a>
### ST_Y

```ml
const ST_Y = 168
```

Defines st y for the st stuff subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/st_stuff.ml#L51)

<a id="constant-constant-startbonuspals-const-startbonuspals-9-src-st-stuff-ml-1298430228"></a>
### STARTBONUSPALS

```ml
const STARTBONUSPALS = 9
```

Defines startbonuspals for the st stuff subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/st_stuff.ml#L56)

<a id="constant-constant-startredpals-const-startredpals-1-src-st-stuff-ml-1893752400"></a>
### STARTREDPALS

```ml
const STARTREDPALS = 1
```

Defines startredpals for the st stuff subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/st_stuff.ml#L54)

<a id="global-global-w-ammo-w-ammo-src-st-stuff-ml-1521982136"></a>
### w_ammo

```ml
w_ammo
```

Stores the w ammo collection used by the st stuff subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/st_stuff.ml#L335)

<a id="global-global-w-armor-w-armor-src-st-stuff-ml-1064316952"></a>
### w_armor

```ml
w_armor
```

Tracks the mutable w armor value used by the st stuff subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/st_stuff.ml#L318)

<a id="global-global-w-arms-w-arms-src-st-stuff-ml-251010966"></a>
### w_arms

```ml
w_arms
```

Stores the w arms collection used by the st stuff subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/st_stuff.ml#L320)

<a id="global-global-w-armsbg-w-armsbg-src-st-stuff-ml-1527759192"></a>
### w_armsbg

```ml
w_armsbg
```

Tracks the mutable w armsbg value used by the st stuff subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/st_stuff.ml#L314)

<a id="global-global-w-faces-w-faces-src-st-stuff-ml-328254948"></a>
### w_faces

```ml
w_faces
```

Tracks the mutable w faces value used by the st stuff subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/st_stuff.ml#L316)

<a id="global-global-w-frags-w-frags-src-st-stuff-ml-856421064"></a>
### w_frags

```ml
w_frags
```

Tracks the mutable w frags value used by the st stuff subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/st_stuff.ml#L310)

<a id="global-global-w-health-w-health-src-st-stuff-ml-939081332"></a>
### w_health

```ml
w_health
```

Tracks the mutable w health value used by the st stuff subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/st_stuff.ml#L312)

<a id="global-global-w-keyboxes-w-keyboxes-src-st-stuff-ml-792693688"></a>
### w_keyboxes

```ml
w_keyboxes
```

Stores the w keyboxes collection used by the st stuff subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/st_stuff.ml#L329)

<a id="global-global-w-maxammo-w-maxammo-src-st-stuff-ml-804205280"></a>
### w_maxammo

```ml
w_maxammo
```

Stores the w maxammo collection used by the st stuff subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/st_stuff.ml#L342)

<a id="global-global-w-ready-w-ready-src-st-stuff-ml-1079890128"></a>
### w_ready

```ml
w_ready
```

Tracks the mutable w ready value used by the st stuff subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/st_stuff.ml#L308)
