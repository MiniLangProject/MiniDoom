# `src/wi_stuff.ml`

[Home](README.md) · [Files](Files.md)

Implements intermission flow, counters, and transition screens.

Package: [`(global)`](Package-global-1952375359.md)

Reachable from entry: **yes**

## Imports

- `d_player.ml` → [src/d_player.ml](File-src-d-player-ml-1944166105.md)
- `doomdef.ml` → [src/doomdef.ml](File-src-doomdef-ml-460406769.md)
- `doomstat.ml` → [src/doomstat.ml](File-src-doomstat-ml-1652708088.md)
- `g_game.ml` → [src/g_game.ml](File-src-g-game-ml-257299317.md)
- `i_system.ml` → [src/i_system.ml](File-src-i-system-ml-1632920966.md)
- `m_random.ml` → [src/m_random.ml](File-src-m-random-ml-1659574948.md)
- `m_swap.ml` → [src/m_swap.ml](File-src-m-swap-ml-1401834276.md)
- `r_defs.ml` → [src/r_defs.ml](File-src-r-defs-ml-1187974936.md)
- `r_local.ml` → [src/r_local.ml](File-src-r-local-ml-797040731.md)
- `s_sound.ml` → [src/s_sound.ml](File-src-s-sound-ml-1485495390.md)
- `sounds.ml` → [src/sounds.ml](File-src-sounds-ml-1875364049.md)
- `v_video.ml` → [src/v_video.ml](File-src-v-video-ml-592999939.md)
- `w_wad.ml` → [src/w_wad.ml](File-src-w-wad-ml-893006035.md)
- `z_zone.ml` → [src/z_zone.ml](File-src-z-zone-ml-1788911354.md)

## Declarations

<a id="function-function-wi-abs-inline-function-wi-abs-v-src-wi-stuff-ml-2118089972"></a>
### _WI_Abs

```ml
inline function _WI_Abs(v)
```

Returns a signed integer magnitude for counter animation and layout math.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `v` | `dynamic` | — | Value consumed by the operation. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/wi_stuff.ml#L106)

<a id="function-function-wi-animdefault-inline-function-wi-animdefault-src-wi-stuff-ml-1723076950"></a>
### _WI_AnimDefault

```ml
inline function _WI_AnimDefault()
```

Creates an inert animation record used to preallocate episode animation tables.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/wi_stuff.ml#L99)

<a id="function-function-wi-cacheorvoid-inline-function-wi-cacheorvoid-name-tag-src-wi-stuff-ml-108992609"></a>
### _WI_CacheOrVoid

```ml
inline function _WI_CacheOrVoid(name, tag)
```

Looks up an optional patch lump and caches it with the requested zone tag.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `name` | `dynamic` | — | Resource or object name to resolve. |
| `tag` | `dynamic` | — | Zone-memory or resource-lifetime tag. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/wi_stuff.ml#L217)

<a id="function-function-wi-clamp-inline-function-wi-clamp-v-lo-hi-src-wi-stuff-ml-1284802694"></a>
### _WI_Clamp

```ml
inline function _WI_Clamp(v, lo, hi)
```

Bounds animated counters between their scoreboard-specific minimum and target value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `v` | `dynamic` | — | Value consumed by the operation. |
| `lo` | `dynamic` | — | Inclusive lower bound. |
| `hi` | `dynamic` | — | Inclusive upper bound. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/wi_stuff.ml#L148)

<a id="function-function-wi-drawrowname-inline-function-wi-drawrowname-slot-x-y-src-wi-stuff-ml-376799871"></a>
### _WI_DrawRowName

```ml
inline function _WI_DrawRowName(slot, x, y)
```

Draws one player name at netgame row start.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `slot` | `dynamic` | — | Slot value supplied to `_WI_DrawRowName`. |
| `x` | `dynamic` | — | Horizontal map- or screen-space coordinate. |
| `y` | `dynamic` | — | Vertical map- or screen-space coordinate. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/wi_stuff.ml#L841)

<a id="function-function-wi-getplr-inline-function-wi-getplr-index-src-wi-stuff-ml-817295472"></a>
### _WI_GetPlr

```ml
inline function _WI_GetPlr(index)
```

Returns a checked wminfo player row, falling back to an empty scoreboard record.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `index` | `dynamic` | — | Zero-based element or table index. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/wi_stuff.ml#L463)

<a id="function-function-wi-getplrfrag-inline-function-wi-getplrfrag-playernum-target-src-wi-stuff-ml-1022640426"></a>
### _WI_GetPlrFrag

```ml
inline function _WI_GetPlrFrag(playernum, target)
```

Reads one frag-matrix entry from wb player stats safely.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `playernum` | `dynamic` | — | Index identifying player. |
| `target` | `dynamic` | — | Target value supplied to `_WI_GetPlrFrag`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/wi_stuff.ml#L488)

<a id="function-function-wi-idiv-inline-function-wi-idiv-a-b-src-wi-stuff-ml-127578497"></a>
### _WI_IDiv

```ml
inline function _WI_IDiv(a, b)
```

Truncates intermission percentage/time quotients toward zero and returns zero on invalid input.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `a` | `dynamic` | — | First input operand. |
| `b` | `dynamic` | — | Second input operand. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/wi_stuff.ml#L134)

<a id="function-function-wi-numpixelwidth-function-wi-numpixelwidth-n-digits-src-wi-stuff-ml-1822355229"></a>
### _WI_NumPixelWidth

```ml
function _WI_NumPixelWidth(n, digits)
```

Computes rendered pixel width for one WI number, matching WI_drawNum semantics.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `n` | `dynamic` | — | Number of values to process. |
| `digits` | `dynamic` | — | Digits value supplied to `_WI_NumPixelWidth`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/wi_stuff.ml#L727)

<a id="function-function-wi-patchh-inline-function-wi-patchh-p-src-wi-stuff-ml-1217550520"></a>
### _WI_PatchH

```ml
inline function _WI_PatchH(p)
```

Reads a patch height safely for intermission alignment calculations.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `p` | `dynamic` | — | Object or data record consumed by the operation. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/wi_stuff.ml#L166)

<a id="function-function-wi-patchw-inline-function-wi-patchw-p-src-wi-stuff-ml-695726214"></a>
### _WI_PatchW

```ml
inline function _WI_PatchW(p)
```

Reads a patch width safely for intermission alignment calculations.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `p` | `dynamic` | — | Object or data record consumed by the operation. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/wi_stuff.ml#L157)

<a id="function-function-wi-playeringame-inline-function-wi-playeringame-index-src-wi-stuff-ml-1303973828"></a>
### _WI_PlayerIngame

```ml
inline function _WI_PlayerIngame(index)
```

Returns whether a player slot is active for intermission tables.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `index` | `dynamic` | — | Zero-based element or table index. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/wi_stuff.ml#L472)

<a id="function-function-wi-playerrowname-function-wi-playerrowname-slot-src-wi-stuff-ml-1713287707"></a>
### _WI_PlayerRowName

```ml
function _WI_PlayerRowName(slot)
```

Resolves readable player name for intermission net rows.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `slot` | `dynamic` | — | Slot value supplied to `_WI_PlayerRowName`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/wi_stuff.ml#L820)

<a id="function-function-wi-point-inline-function-wi-point-x-y-src-wi-stuff-ml-1883774227"></a>
### _WI_Point

```ml
inline function _WI_Point(x, y)
```

Constructs an immutable two-coordinate map-node position.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `x` | `dynamic` | — | Horizontal map- or screen-space coordinate. |
| `y` | `dynamic` | — | Vertical map- or screen-space coordinate. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/wi_stuff.ml#L93)

<a id="function-function-wi-safedrawnamedpatch-inline-function-wi-safedrawnamedpatch-x-y-patch-name-src-wi-stuff-ml-1779676888"></a>
### _WI_SafeDrawNamedPatch

```ml
inline function _WI_SafeDrawNamedPatch(x, y, patch, name)
```

Draws an intermission patch and its OpenGL high-resolution package image.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `x` | `dynamic` | — | Horizontal map- or screen-space coordinate. |
| `y` | `dynamic` | — | Vertical map- or screen-space coordinate. |
| `patch` | `dynamic` | — | Patch value supplied to `_WI_SafeDrawNamedPatch`. |
| `name` | `dynamic` | — | Resource or object name to resolve. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/wi_stuff.ml#L190)

<a id="function-function-wi-safedrawpatch-inline-function-wi-safedrawpatch-x-y-patch-src-wi-stuff-ml-1026425151"></a>
### _WI_SafeDrawPatch

```ml
inline function _WI_SafeDrawPatch(x, y, patch)
```

Draws a patch only when its decoded resource and destination coordinates are valid.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `x` | `dynamic` | — | Horizontal map- or screen-space coordinate. |
| `y` | `dynamic` | — | Vertical map- or screen-space coordinate. |
| `patch` | `dynamic` | — | Patch value supplied to `_WI_SafeDrawPatch`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/wi_stuff.ml#L177)

<a id="function-function-wi-safestartsound-inline-function-wi-safestartsound-origin-sfx-src-wi-stuff-ml-522615223"></a>
### _WI_SafeStartSound

```ml
inline function _WI_SafeStartSound(origin, sfx)
```

Plays an intermission cue only when the sound backend is available.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `origin` | `dynamic` | — | Origin value supplied to `_WI_SafeStartSound`. |
| `sfx` | `dynamic` | — | Sound-effect descriptor to process. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/wi_stuff.ml#L207)

<a id="function-function-wi-substr-inline-function-wi-substr-s-n-src-wi-stuff-ml-1012277625"></a>
### _WI_Substr

```ml
inline function _WI_Substr(s, n)
```

Returns at most n bytes from the beginning of s.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `s` | `dynamic` | — | S value supplied to `_WI_Substr`. |
| `n` | `dynamic` | — | Number of values to process. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/wi_stuff.ml#L809)

<a id="function-function-wi-targetitems-function-wi-targetitems-index-src-wi-stuff-ml-357332675"></a>
### _WI_TargetItems

```ml
function _WI_TargetItems(index)
```

Computes the bounded final item percentage for the local single-player row.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `index` | `dynamic` | — | Zero-based element or table index. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/wi_stuff.ml#L516)

<a id="function-function-wi-targetkills-function-wi-targetkills-index-src-wi-stuff-ml-1506411389"></a>
### _WI_TargetKills

```ml
function _WI_TargetKills(index)
```

Computes the bounded final kill percentage for the local single-player row.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `index` | `dynamic` | — | Zero-based element or table index. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/wi_stuff.ml#L498)

<a id="function-function-wi-targetpar-inline-function-wi-targetpar-src-wi-stuff-ml-1776544438"></a>
### _WI_TargetPar

```ml
inline function _WI_TargetPar()
```

Converts the map par time from tics to scoreboard seconds.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/wi_stuff.ml#L563)

<a id="function-function-wi-targetsecrets-function-wi-targetsecrets-index-src-wi-stuff-ml-1168188885"></a>
### _WI_TargetSecrets

```ml
function _WI_TargetSecrets(index)
```

Computes the bounded final secret percentage for the local single-player row.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `index` | `dynamic` | — | Zero-based element or table index. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/wi_stuff.ml#L534)

<a id="function-function-wi-targettime-inline-function-wi-targettime-index-src-wi-stuff-ml-153431048"></a>
### _WI_TargetTime

```ml
inline function _WI_TargetTime(index)
```

Converts the player's completion time from tics to scoreboard seconds.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `index` | `dynamic` | — | Zero-based element or table index. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/wi_stuff.ml#L552)

<a id="function-function-wi-toint-function-wi-toint-v-fallback-src-wi-stuff-ml-283881325"></a>
### _WI_ToInt

```ml
function _WI_ToInt(v, fallback)
```

Normalizes values to int for intermission math and counters.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `v` | `dynamic` | — | Value consumed by the operation. |
| `fallback` | `dynamic` | — | Value returned when the requested conversion or lookup is unavailable. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/wi_stuff.ml#L115)

<a id="global-global-acceleratestage-acceleratestage-src-wi-stuff-ml-849111645"></a>
### acceleratestage

```ml
acceleratestage
```

Tracks the mutable acceleratestage value used by the wi stuff subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/wi_stuff.ml#L294)

- [anim_t](Type-anim-t-1441059019.md) — struct
- [animenum_t](Type-animenum-t-95495142.md) — enum
<a id="global-global-anims-anims-src-wi-stuff-ml-749052113"></a>
### anims

```ml
anims
```

Stores the anims collection used by the wi stuff subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/wi_stuff.ml#L453)

<a id="global-global-bcnt-bcnt-src-wi-stuff-ml-1297178715"></a>
### bcnt

```ml
bcnt
```

Tracks the mutable bcnt value used by the wi stuff subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/wi_stuff.ml#L306)

<a id="global-global-bg-bg-src-wi-stuff-ml-229648471"></a>
### bg

```ml
bg
```

Holds the optional bg resource used by the wi stuff subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/wi_stuff.ml#L346)

<a id="global-global-bg-name-bg-name-src-wi-stuff-ml-752647013"></a>
### bg_name

```ml
bg_name
```

Stores the mutable bg name text used by the wi stuff subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/wi_stuff.ml#L348)

<a id="global-global-bstar-bstar-src-wi-stuff-ml-1042248673"></a>
### bstar

```ml
bstar
```

Holds the optional bstar resource used by the wi stuff subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/wi_stuff.ml#L430)

<a id="global-global-bstar-name-bstar-name-src-wi-stuff-ml-517843385"></a>
### bstar_name

```ml
bstar_name
```

Stores the mutable bstar name text used by the wi stuff subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/wi_stuff.ml#L432)

<a id="global-global-cnt-cnt-src-wi-stuff-ml-1902236361"></a>
### cnt

```ml
cnt
```

Tracks the mutable cnt value used by the wi stuff subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/wi_stuff.ml#L304)

<a id="global-global-cnt-frags-cnt-frags-src-wi-stuff-ml-1612914325"></a>
### cnt_frags

```ml
cnt_frags
```

Stores the cnt frags collection used by the wi stuff subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/wi_stuff.ml#L323)

<a id="global-global-cnt-items-cnt-items-src-wi-stuff-ml-78540929"></a>
### cnt_items

```ml
cnt_items
```

Stores the cnt items collection used by the wi stuff subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/wi_stuff.ml#L319)

<a id="global-global-cnt-kills-cnt-kills-src-wi-stuff-ml-1176826869"></a>
### cnt_kills

```ml
cnt_kills
```

Stores the cnt kills collection used by the wi stuff subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/wi_stuff.ml#L317)

<a id="global-global-cnt-par-cnt-par-src-wi-stuff-ml-34293957"></a>
### cnt_par

```ml
cnt_par
```

Tracks the mutable cnt par value used by the wi stuff subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/wi_stuff.ml#L338)

<a id="global-global-cnt-pause-cnt-pause-src-wi-stuff-ml-672179137"></a>
### cnt_pause

```ml
cnt_pause
```

Tracks the mutable cnt pause value used by the wi stuff subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/wi_stuff.ml#L340)

<a id="global-global-cnt-secret-cnt-secret-src-wi-stuff-ml-1451346989"></a>
### cnt_secret

```ml
cnt_secret
```

Stores the cnt secret collection used by the wi stuff subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/wi_stuff.ml#L321)

<a id="global-global-cnt-time-cnt-time-src-wi-stuff-ml-721491575"></a>
### cnt_time

```ml
cnt_time
```

Tracks the mutable cnt time value used by the wi stuff subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/wi_stuff.ml#L336)

<a id="global-global-colon-colon-src-wi-stuff-ml-1635298717"></a>
### colon

```ml
colon
```

Holds the optional colon resource used by the wi stuff subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/wi_stuff.ml#L362)

<a id="global-global-colon-name-colon-name-src-wi-stuff-ml-309016951"></a>
### colon_name

```ml
colon_name
```

Stores the mutable colon name text used by the wi stuff subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/wi_stuff.ml#L364)

<a id="global-global-dm-frags-dm-frags-src-wi-stuff-ml-1116323879"></a>
### dm_frags

```ml
dm_frags
```

Stores the dm frags collection used by the wi stuff subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/wi_stuff.ml#L327)

<a id="constant-constant-dm-killersx-const-dm-killersx-10-src-wi-stuff-ml-1360656493"></a>
### DM_KILLERSX

```ml
const DM_KILLERSX = 10
```

Defines dm killersx for the wi stuff subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/wi_stuff.ml#L265)

<a id="constant-constant-dm-killersy-const-dm-killersy-100-src-wi-stuff-ml-1522677925"></a>
### DM_KILLERSY

```ml
const DM_KILLERSY = 100
```

Defines dm killersy for the wi stuff subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/wi_stuff.ml#L267)

<a id="constant-constant-dm-matrixx-const-dm-matrixx-42-src-wi-stuff-ml-944985598"></a>
### DM_MATRIXX

```ml
const DM_MATRIXX = 42
```

Defines dm matrixx for the wi stuff subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/wi_stuff.ml#L257)

<a id="constant-constant-dm-matrixy-const-dm-matrixy-68-src-wi-stuff-ml-158194120"></a>
### DM_MATRIXY

```ml
const DM_MATRIXY = 68
```

Defines dm matrixy for the wi stuff subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/wi_stuff.ml#L259)

<a id="constant-constant-dm-spacingx-const-dm-spacingx-40-src-wi-stuff-ml-422226504"></a>
### DM_SPACINGX

```ml
const DM_SPACINGX = 40
```

Defines dm spacingx for the wi stuff subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/wi_stuff.ml#L261)

<a id="global-global-dm-state-dm-state-src-wi-stuff-ml-1672373303"></a>
### dm_state

```ml
dm_state
```

Tracks the mutable dm state value used by the wi stuff subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/wi_stuff.ml#L314)

<a id="global-global-dm-totals-dm-totals-src-wi-stuff-ml-1614241677"></a>
### dm_totals

```ml
dm_totals
```

Stores the dm totals collection used by the wi stuff subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/wi_stuff.ml#L325)

<a id="constant-constant-dm-totalsx-const-dm-totalsx-269-src-wi-stuff-ml-631174265"></a>
### DM_TOTALSX

```ml
const DM_TOTALSX = 269
```

Defines dm totalsx for the wi stuff subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/wi_stuff.ml#L263)

<a id="constant-constant-dm-victimsx-const-dm-victimsx-5-src-wi-stuff-ml-845851177"></a>
### DM_VICTIMSX

```ml
const DM_VICTIMSX = 5
```

Defines dm victimsx for the wi stuff subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/wi_stuff.ml#L269)

<a id="constant-constant-dm-victimsy-const-dm-victimsy-50-src-wi-stuff-ml-1343825565"></a>
### DM_VICTIMSY

```ml
const DM_VICTIMSY = 50
```

Defines dm victimsy for the wi stuff subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/wi_stuff.ml#L271)

<a id="global-global-dofrags-dofrags-src-wi-stuff-ml-179583161"></a>
### dofrags

```ml
dofrags
```

Tracks whether dofrags is active in the wi stuff subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/wi_stuff.ml#L334)

<a id="global-global-entering-entering-src-wi-stuff-ml-1679557633"></a>
### entering

```ml
entering
```

Holds the optional entering resource used by the wi stuff subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/wi_stuff.ml#L378)

<a id="global-global-entering-name-entering-name-src-wi-stuff-ml-643585873"></a>
### entering_name

```ml
entering_name
```

Stores the mutable entering name text used by the wi stuff subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/wi_stuff.ml#L380)

<a id="global-global-finished-finished-src-wi-stuff-ml-2047988849"></a>
### finished

```ml
finished
```

Holds the optional finished resource used by the wi stuff subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/wi_stuff.ml#L374)

<a id="global-global-finished-name-finished-name-src-wi-stuff-ml-66638829"></a>
### finished_name

```ml
finished_name
```

Stores the mutable finished name text used by the wi stuff subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/wi_stuff.ml#L376)

<a id="global-global-firstrefresh-firstrefresh-src-wi-stuff-ml-1448875755"></a>
### firstrefresh

```ml
firstrefresh
```

Tracks the mutable firstrefresh value used by the wi stuff subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/wi_stuff.ml#L308)

<a id="global-global-frags-frags-src-wi-stuff-ml-255126665"></a>
### frags

```ml
frags
```

Holds the optional frags resource used by the wi stuff subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/wi_stuff.ml#L398)

<a id="global-global-frags-name-frags-name-src-wi-stuff-ml-594677375"></a>
### frags_name

```ml
frags_name
```

Stores the mutable frags name text used by the wi stuff subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/wi_stuff.ml#L400)

<a id="global-global-items-items-src-wi-stuff-ml-1916690877"></a>
### items

```ml
items
```

Holds the optional items resource used by the wi stuff subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/wi_stuff.ml#L394)

<a id="global-global-items-name-items-name-src-wi-stuff-ml-909323073"></a>
### items_name

```ml
items_name
```

Stores the mutable items name text used by the wi stuff subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/wi_stuff.ml#L396)

<a id="global-global-killers-killers-src-wi-stuff-ml-163967757"></a>
### killers

```ml
killers
```

Holds the optional killers resource used by the wi stuff subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/wi_stuff.ml#L414)

<a id="global-global-killers-name-killers-name-src-wi-stuff-ml-1216248481"></a>
### killers_name

```ml
killers_name
```

Stores the mutable killers name text used by the wi stuff subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/wi_stuff.ml#L416)

<a id="global-global-kills-kills-src-wi-stuff-ml-1644539489"></a>
### kills

```ml
kills
```

Holds the optional kills resource used by the wi stuff subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/wi_stuff.ml#L386)

<a id="global-global-kills-name-kills-name-src-wi-stuff-ml-1216331647"></a>
### kills_name

```ml
kills_name
```

Stores the mutable kills name text used by the wi stuff subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/wi_stuff.ml#L388)

<a id="global-global-lnames-lnames-src-wi-stuff-ml-410276853"></a>
### lnames

```ml
lnames
```

Stores the lnames collection used by the wi stuff subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/wi_stuff.ml#L442)

<a id="global-global-lnodes-lnodes-src-wi-stuff-ml-1019515143"></a>
### lnodes

```ml
lnodes
```

Stores the lnodes collection used by the wi stuff subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/wi_stuff.ml#L445)

<a id="global-global-me-me-src-wi-stuff-ml-2074521649"></a>
### me

```ml
me
```

Tracks the mutable me value used by the wi stuff subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/wi_stuff.ml#L296)

<a id="constant-constant-ng-namex-const-ng-namex-6-src-wi-stuff-ml-1005724432"></a>
### NG_NAMEX

```ml
const NG_NAMEX = 6
```

Defines ng namex for the wi stuff subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/wi_stuff.ml#L252)

<a id="constant-constant-ng-nameyoff-const-ng-nameyoff-10-src-wi-stuff-ml-208460501"></a>
### NG_NAMEYOFF

```ml
const NG_NAMEYOFF = 10
```

Defines ng nameyoff for the wi stuff subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/wi_stuff.ml#L254)

<a id="constant-constant-ng-spacingx-const-ng-spacingx-64-src-wi-stuff-ml-1295549462"></a>
### NG_SPACINGX

```ml
const NG_SPACINGX = 64
```

Defines ng spacingx for the wi stuff subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/wi_stuff.ml#L250)

<a id="global-global-ng-state-ng-state-src-wi-stuff-ml-1156593243"></a>
### ng_state

```ml
ng_state
```

Tracks the mutable ng state value used by the wi stuff subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/wi_stuff.ml#L312)

<a id="constant-constant-ng-statsx-const-ng-statsx-32-src-wi-stuff-ml-786683365"></a>
### NG_STATSX

```ml
const NG_STATSX = 32
```

Defines ng statsx for the wi stuff subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/wi_stuff.ml#L248)

<a id="constant-constant-ng-statsy-const-ng-statsy-50-src-wi-stuff-ml-66918309"></a>
### NG_STATSY

```ml
const NG_STATSY = 50
```

Defines ng statsy for the wi stuff subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/wi_stuff.ml#L246)

<a id="global-global-num-num-src-wi-stuff-ml-1511304477"></a>
### num

```ml
num
```

Stores the num collection used by the wi stuff subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/wi_stuff.ml#L366)

<a id="global-global-num-names-num-names-src-wi-stuff-ml-967207041"></a>
### num_names

```ml
num_names
```

Stores the num names collection used by the wi stuff subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/wi_stuff.ml#L368)

<a id="global-global-numcmaps-numcmaps-src-wi-stuff-ml-1666527105"></a>
### NUMCMAPS

```ml
NUMCMAPS
```

Tracks the mutable numcmaps value used by the wi stuff subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/wi_stuff.ml#L343)

<a id="constant-constant-numepisodes-const-numepisodes-4-src-wi-stuff-ml-1981578138"></a>
### NUMEPISODES

```ml
const NUMEPISODES = 4
```

Defines the numepisodes count used by the wi stuff subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/wi_stuff.ml#L227)

<a id="constant-constant-nummaps-const-nummaps-9-src-wi-stuff-ml-2026222461"></a>
### NUMMAPS

```ml
const NUMMAPS = 9
```

Defines the nummaps count used by the wi stuff subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/wi_stuff.ml#L229)

<a id="global-global-par-par-src-wi-stuff-ml-1122482589"></a>
### par

```ml
par
```

Holds the optional par resource used by the wi stuff subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/wi_stuff.ml#L406)

<a id="global-global-par-name-par-name-src-wi-stuff-ml-546806679"></a>
### par_name

```ml
par_name
```

Stores the mutable par name text used by the wi stuff subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/wi_stuff.ml#L408)

<a id="global-global-percent-percent-src-wi-stuff-ml-1188059253"></a>
### percent

```ml
percent
```

Holds the optional percent resource used by the wi stuff subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/wi_stuff.ml#L358)

<a id="global-global-percent-name-percent-name-src-wi-stuff-ml-102185963"></a>
### percent_name

```ml
percent_name
```

Stores the mutable percent name text used by the wi stuff subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/wi_stuff.ml#L360)

<a id="global-global-plrs-plrs-src-wi-stuff-ml-1512842087"></a>
### plrs

```ml
plrs
```

Stores the plrs collection used by the wi stuff subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/wi_stuff.ml#L302)

- [point_t](Type-point-t-553695642.md) — struct
<a id="global-global-secret-secret-src-wi-stuff-ml-2097837353"></a>
### secret

```ml
secret
```

Holds the optional secret resource used by the wi stuff subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/wi_stuff.ml#L390)

<a id="global-global-secret-name-secret-name-src-wi-stuff-ml-1784912833"></a>
### secret_name

```ml
secret_name
```

Stores the mutable secret name text used by the wi stuff subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/wi_stuff.ml#L392)

<a id="constant-constant-shownextlocdelay-const-shownextlocdelay-4-src-wi-stuff-ml-1690495938"></a>
### SHOWNEXTLOCDELAY

```ml
const SHOWNEXTLOCDELAY = 4
```

Defines shownextlocdelay for the wi stuff subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/wi_stuff.ml#L274)

<a id="constant-constant-sp-frags-const-sp-frags-6-src-wi-stuff-ml-988148256"></a>
### SP_FRAGS

```ml
const SP_FRAGS = 6
```

Defines sp frags for the wi stuff subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/wi_stuff.ml#L285)

<a id="constant-constant-sp-items-const-sp-items-2-src-wi-stuff-ml-1418868214"></a>
### SP_ITEMS

```ml
const SP_ITEMS = 2
```

Defines sp items for the wi stuff subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/wi_stuff.ml#L281)

<a id="constant-constant-sp-kills-const-sp-kills-0-src-wi-stuff-ml-601394742"></a>
### SP_KILLS

```ml
const SP_KILLS = 0
```

Defines sp kills for the wi stuff subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/wi_stuff.ml#L279)

<a id="constant-constant-sp-par-const-sp-par-8-src-wi-stuff-ml-1766276666"></a>
### SP_PAR

```ml
const SP_PAR = 8
```

Defines sp par for the wi stuff subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/wi_stuff.ml#L289)

<a id="constant-constant-sp-pause-const-sp-pause-1-src-wi-stuff-ml-1650472495"></a>
### SP_PAUSE

```ml
const SP_PAUSE = 1
```

Defines sp pause for the wi stuff subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/wi_stuff.ml#L291)

<a id="constant-constant-sp-secret-const-sp-secret-4-src-wi-stuff-ml-180820010"></a>
### SP_SECRET

```ml
const SP_SECRET = 4
```

Defines sp secret for the wi stuff subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/wi_stuff.ml#L283)

<a id="global-global-sp-secret-sp-secret-src-wi-stuff-ml-1097265901"></a>
### sp_secret

```ml
sp_secret
```

Holds the optional sp secret resource used by the wi stuff subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/wi_stuff.ml#L382)

<a id="global-global-sp-secret-name-sp-secret-name-src-wi-stuff-ml-1438573937"></a>
### sp_secret_name

```ml
sp_secret_name
```

Stores the mutable sp secret name text used by the wi stuff subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/wi_stuff.ml#L384)

<a id="global-global-sp-state-sp-state-src-wi-stuff-ml-1843117963"></a>
### sp_state

```ml
sp_state
```

Tracks the mutable sp state value used by the wi stuff subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/wi_stuff.ml#L310)

<a id="constant-constant-sp-statsx-const-sp-statsx-50-src-wi-stuff-ml-269773205"></a>
### SP_STATSX

```ml
const SP_STATSX = 50
```

Defines sp statsx for the wi stuff subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/wi_stuff.ml#L237)

<a id="constant-constant-sp-statsy-const-sp-statsy-50-src-wi-stuff-ml-1853229277"></a>
### SP_STATSY

```ml
const SP_STATSY = 50
```

Defines sp statsy for the wi stuff subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/wi_stuff.ml#L239)

<a id="constant-constant-sp-time-const-sp-time-8-src-wi-stuff-ml-1794703242"></a>
### SP_TIME

```ml
const SP_TIME = 8
```

Defines sp time for the wi stuff subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/wi_stuff.ml#L287)

<a id="constant-constant-sp-timex-const-sp-timex-16-src-wi-stuff-ml-1115788163"></a>
### SP_TIMEX

```ml
const SP_TIMEX = 16
```

Defines sp timex for the wi stuff subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/wi_stuff.ml#L241)

<a id="constant-constant-sp-timey-const-sp-timey-screenheight-32-src-wi-stuff-ml-1710913745"></a>
### SP_TIMEY

```ml
const SP_TIMEY = SCREENHEIGHT - 32
```

Defines sp timey for the wi stuff subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/wi_stuff.ml#L243)

<a id="global-global-splat-splat-src-wi-stuff-ml-780975229"></a>
### splat

```ml
splat
```

Holds the optional splat resource used by the wi stuff subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/wi_stuff.ml#L354)

<a id="global-global-splat-name-splat-name-src-wi-stuff-ml-1772981425"></a>
### splat_name

```ml
splat_name
```

Stores the mutable splat name text used by the wi stuff subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/wi_stuff.ml#L356)

<a id="global-global-star-star-src-wi-stuff-ml-1632190965"></a>
### star

```ml
star
```

Holds the optional star resource used by the wi stuff subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/wi_stuff.ml#L426)

<a id="global-global-star-name-star-name-src-wi-stuff-ml-854900289"></a>
### star_name

```ml
star_name
```

Stores the mutable star name text used by the wi stuff subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/wi_stuff.ml#L428)

<a id="global-global-state-state-src-wi-stuff-ml-1185729029"></a>
### state

```ml
state
```

Exposes `stateenum_t.NoState` through the legacy `state` alias.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/wi_stuff.ml#L298)

- [stateenum_t](Type-stateenum-t-613682356.md) — enum
<a id="global-global-sucks-sucks-src-wi-stuff-ml-1076888145"></a>
### sucks

```ml
sucks
```

Holds the optional sucks resource used by the wi stuff subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/wi_stuff.ml#L410)

<a id="global-global-sucks-name-sucks-name-src-wi-stuff-ml-1747334347"></a>
### sucks_name

```ml
sucks_name
```

Stores the mutable sucks name text used by the wi stuff subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/wi_stuff.ml#L412)

<a id="global-global-timepatch-timepatch-src-wi-stuff-ml-1554226969"></a>
### timepatch

```ml
timepatch
```

Holds the optional timepatch resource used by the wi stuff subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/wi_stuff.ml#L402)

<a id="global-global-timepatch-name-timepatch-name-src-wi-stuff-ml-65121615"></a>
### timepatch_name

```ml
timepatch_name
```

Stores the mutable timepatch name text used by the wi stuff subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/wi_stuff.ml#L404)

<a id="global-global-total-total-src-wi-stuff-ml-382751105"></a>
### total

```ml
total
```

Holds the optional total resource used by the wi stuff subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/wi_stuff.ml#L422)

<a id="global-global-total-name-total-name-src-wi-stuff-ml-1912219241"></a>
### total_name

```ml
total_name
```

Stores the mutable total name text used by the wi stuff subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/wi_stuff.ml#L424)

<a id="global-global-victims-victims-src-wi-stuff-ml-2035796893"></a>
### victims

```ml
victims
```

Holds the optional victims resource used by the wi stuff subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/wi_stuff.ml#L418)

<a id="global-global-victims-name-victims-name-src-wi-stuff-ml-1647166163"></a>
### victims_name

```ml
victims_name
```

Stores the mutable victims name text used by the wi stuff subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/wi_stuff.ml#L420)

<a id="global-global-wbs-wbs-src-wi-stuff-ml-411246209"></a>
### wbs

```ml
wbs
```

Holds the optional wbs resource used by the wi stuff subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/wi_stuff.ml#L300)

<a id="global-global-wi-bp-wi-bp-src-wi-stuff-ml-1305547481"></a>
### wi_bp

```ml
wi_bp
```

Stores the wi bp collection used by the wi stuff subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/wi_stuff.ml#L438)

<a id="global-global-wi-bp-names-wi-bp-names-src-wi-stuff-ml-627089289"></a>
### wi_bp_names

```ml
wi_bp_names
```

Stores the wi bp names collection used by the wi stuff subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/wi_stuff.ml#L440)

<a id="function-function-wi-checkforaccelerate-function-wi-checkforaccelerate-src-wi-stuff-ml-350505585"></a>
### WI_checkForAccelerate

```ml
function WI_checkForAccelerate()
```

Latches rising attack/use buttons from any active player into the shared accelerate flag.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/wi_stuff.ml#L1440)

<a id="function-function-wi-drawanimatedback-function-wi-drawanimatedback-src-wi-stuff-ml-1957830177"></a>
### WI_drawAnimatedBack

```ml
function WI_drawAnimatedBack()
```

Draws each active episode-map background animation frame.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/wi_stuff.ml#L667)

<a id="function-function-wi-drawdeathmatchstats-function-wi-drawdeathmatchstats-src-wi-stuff-ml-785657035"></a>
### WI_drawDeathmatchStats

```ml
function WI_drawDeathmatchStats()
```

Draws the deathmatch frag matrix, totals, and host-synchronized player names.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/wi_stuff.ml#L1071)

<a id="function-function-wi-drawel-function-wi-drawel-src-wi-stuff-ml-544351519"></a>
### WI_drawEL

```ml
function WI_drawEL()
```

Draws the localized entering-map heading and next map name.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/wi_stuff.ml#L607)

<a id="function-function-wi-drawer-function-wi-drawer-src-wi-stuff-ml-2080171103"></a>
### WI_Drawer

```ml
function WI_Drawer()
```

Selects and draws the current deathmatch, coop, solo, or map-transition intermission screen.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/wi_stuff.ml#L1869)

<a id="function-function-wi-drawlf-function-wi-drawlf-src-wi-stuff-ml-2102595941"></a>
### WI_drawLF

```ml
function WI_drawLF()
```

Draws the localized finished-map heading and current map name.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/wi_stuff.ml#L600)

<a id="function-function-wi-drawnetgamestats-function-wi-drawnetgamestats-src-wi-stuff-ml-1901995497"></a>
### WI_drawNetgameStats

```ml
function WI_drawNetgameStats()
```

Draws cooperative kill/item/secret/frag columns for every active slot.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/wi_stuff.ml#L1265)

<a id="function-function-wi-drawnostate-function-wi-drawnostate-src-wi-stuff-ml-1500972931"></a>
### WI_drawNoState

```ml
function WI_drawNoState()
```

Draws the final static world-map frame before leaving intermission.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/wi_stuff.ml#L950)

<a id="function-function-wi-drawnum-function-wi-drawnum-x-y-n-digits-src-wi-stuff-ml-1247002802"></a>
### WI_drawNum

```ml
function WI_drawNum(x, y, n, digits)
```

Draws a signed decimal counter using WI digit/minus patches and right alignment.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `x` | `dynamic` | — | Horizontal map- or screen-space coordinate. |
| `y` | `dynamic` | — | Vertical map- or screen-space coordinate. |
| `n` | `dynamic` | — | Number of values to process. |
| `digits` | `dynamic` | — | Digits value supplied to `WI_drawNum`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/wi_stuff.ml#L686)

<a id="function-function-wi-drawnumright-function-wi-drawnumright-xright-y-n-digits-src-wi-stuff-ml-1086244236"></a>
### WI_drawNumRight

```ml
function WI_drawNumRight(xRight, y, n, digits)
```

Draws number right-aligned to xRight.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `xRight` | `dynamic` | — | X right value supplied to `WI_drawNumRight`. |
| `y` | `dynamic` | — | Vertical map- or screen-space coordinate. |
| `n` | `dynamic` | — | Number of values to process. |
| `digits` | `dynamic` | — | Digits value supplied to `WI_drawNumRight`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/wi_stuff.ml#L767)

<a id="function-function-wi-drawonlnode-function-wi-drawonlnode-n-c-src-wi-stuff-ml-731902946"></a>
### WI_drawOnLnode

```ml
function WI_drawOnLnode(n, c)
```

Places one map marker on a node while keeping its patch inside screen bounds.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `n` | `dynamic` | — | Number of values to process. |
| `c` | `dynamic` | — | C value supplied to `WI_drawOnLnode`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/wi_stuff.ml#L616)

<a id="function-function-wi-drawpercent-function-wi-drawpercent-x-y-p-src-wi-stuff-ml-1179087454"></a>
### WI_drawPercent

```ml
function WI_drawPercent(x, y, p)
```

Draws a percentage value followed by the percent patch at the requested anchor.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `x` | `dynamic` | — | Horizontal map- or screen-space coordinate. |
| `y` | `dynamic` | — | Vertical map- or screen-space coordinate. |
| `p` | `dynamic` | — | Object or data record consumed by the operation. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/wi_stuff.ml#L776)

<a id="function-function-wi-drawpercentaligned-function-wi-drawpercentaligned-x-y-p-src-wi-stuff-ml-949988334"></a>
### WI_drawPercentAligned

```ml
function WI_drawPercentAligned(x, y, p)
```

Draws percent with numeric part right-aligned before the percent sign.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `x` | `dynamic` | — | Horizontal map- or screen-space coordinate. |
| `y` | `dynamic` | — | Vertical map- or screen-space coordinate. |
| `p` | `dynamic` | — | Object or data record consumed by the operation. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/wi_stuff.ml#L798)

<a id="function-function-wi-drawshownextloc-function-wi-drawshownextloc-src-wi-stuff-ml-1019147339"></a>
### WI_drawShowNextLoc

```ml
function WI_drawShowNextLoc()
```

Draws the world map, completed splats, blinking pointer, and entering heading.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/wi_stuff.ml#L935)

<a id="function-function-wi-drawstats-function-wi-drawstats-src-wi-stuff-ml-1224185511"></a>
### WI_drawStats

```ml
function WI_drawStats()
```

Draws the animated single-player completion counters and their labels.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/wi_stuff.ml#L1409)

<a id="function-function-wi-drawtime-function-wi-drawtime-x-y-t-src-wi-stuff-ml-104433762"></a>
### WI_drawTime

```ml
function WI_drawTime(x, y, t)
```

Draws mm:ss completion/par time or the overflow label for very long runs.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `x` | `dynamic` | — | Horizontal map- or screen-space coordinate. |
| `y` | `dynamic` | — | Vertical map- or screen-space coordinate. |
| `t` | `dynamic` | — | T value supplied to `WI_drawTime`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/wi_stuff.ml#L854)

<a id="function-function-wi-end-function-wi-end-src-wi-stuff-ml-800469535"></a>
### WI_End

```ml
function WI_End()
```

Controls end transitions in the intermission system.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/wi_stuff.ml#L885)

<a id="constant-constant-wi-fb-const-wi-fb-0-src-wi-stuff-ml-1101469186"></a>
### WI_FB

```ml
const WI_FB = 0
```

Defines wi fb for the wi stuff subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/wi_stuff.ml#L276)

<a id="function-function-wi-fragsum-function-wi-fragsum-playernum-src-wi-stuff-ml-1155397324"></a>
### WI_fragSum

```ml
function WI_fragSum(playernum)
```

Sums one player's net frags with Doom self-frag subtraction semantics.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `playernum` | `dynamic` | — | Index identifying player. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/wi_stuff.ml#L956)

<a id="function-function-wi-initanimatedback-function-wi-initanimatedback-src-wi-stuff-ml-846774261"></a>
### WI_initAnimatedBack

```ml
function WI_initAnimatedBack()
```

Resets per-animation frame indices and schedules their first episode-specific background tick.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/wi_stuff.ml#L635)

<a id="function-function-wi-initdeathmatchstats-function-wi-initdeathmatchstats-src-wi-stuff-ml-807544767"></a>
### WI_initDeathmatchStats

```ml
function WI_initDeathmatchStats()
```

Seeds the deathmatch frag matrix counters and opens the first staged scoreboard pause.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/wi_stuff.ml#L970)

<a id="function-function-wi-initnetgamestats-function-wi-initnetgamestats-src-wi-stuff-ml-63652297"></a>
### WI_initNetgameStats

```ml
function WI_initNetgameStats()
```

Clears cooperative kill/item/secret counters and starts their staged count-up sequence.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/wi_stuff.ml#L1114)

<a id="function-function-wi-initnostate-function-wi-initnostate-src-wi-stuff-ml-2134794099"></a>
### WI_initNoState

```ml
function WI_initNoState()
```

Enters the final ten-tic intermission hold before handing control back to world progression.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/wi_stuff.ml#L892)

<a id="function-function-wi-initshownextloc-function-wi-initshownextloc-src-wi-stuff-ml-761244015"></a>
### WI_initShowNextLoc

```ml
function WI_initShowNextLoc()
```

Enters the next-location map screen with its fixed delay and pointer blink state reset.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/wi_stuff.ml#L914)

<a id="function-function-wi-initstats-function-wi-initstats-src-wi-stuff-ml-1027401791"></a>
### WI_initStats

```ml
function WI_initStats()
```

Clears single-player counters and begins the kill/item/secret/time tally sequence.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/wi_stuff.ml#L1300)

<a id="function-function-wi-initvariables-function-wi-initvariables-wbstartstruct-src-wi-stuff-ml-1744773083"></a>
### WI_initVariables

```ml
function WI_initVariables(wbstartstruct)
```

Validates wminfo, selects the local scoreboard row, and resets clocks/accelerate flags.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `wbstartstruct` | `dynamic` | — | Wbstartstruct value supplied to `WI_initVariables`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/wi_stuff.ml#L1750)

<a id="function-function-wi-loaddata-function-wi-loaddata-src-wi-stuff-ml-1236972573"></a>
### WI_loadData

```ml
function WI_loadData()
```

Caches scoreboard digits, labels, map patches, player markers, and episode animation frames.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/wi_stuff.ml#L1482)

<a id="global-global-wi-p-wi-p-src-wi-stuff-ml-2131684651"></a>
### wi_p

```ml
wi_p
```

Stores the wi p collection used by the wi stuff subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/wi_stuff.ml#L434)

<a id="global-global-wi-p-names-wi-p-names-src-wi-stuff-ml-1025399017"></a>
### wi_p_names

```ml
wi_p_names
```

Stores the wi p names collection used by the wi stuff subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/wi_stuff.ml#L436)

<a id="function-function-wi-responder-function-wi-responder-ev-src-wi-stuff-ml-134542222"></a>
### WI_Responder

```ml
function WI_Responder(ev)
```

Records attack/use acceleration requests from every active player during intermission.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `ev` | `dynamic` | — | Input event to process. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/wi_stuff.ml#L589)

<a id="function-function-wi-slambackground-function-wi-slambackground-src-wi-stuff-ml-1420277367"></a>
### WI_slamBackground

```ml
function WI_slamBackground()
```

Copies the cached intermission background into the active framebuffer.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/wi_stuff.ml#L569)

<a id="constant-constant-wi-spacingy-const-wi-spacingy-33-src-wi-stuff-ml-1940985994"></a>
### WI_SPACINGY

```ml
const WI_SPACINGY = 33
```

Defines wi spacingy for the wi stuff subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/wi_stuff.ml#L234)

<a id="function-function-wi-start-function-wi-start-wbstartstruct-src-wi-stuff-ml-1304490643"></a>
### WI_Start

```ml
function WI_Start(wbstartstruct)
```

Loads shared artwork and selects deathmatch, cooperative, or solo scoreboard state.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `wbstartstruct` | `dynamic` | — | Wbstartstruct value supplied to `WI_Start`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/wi_stuff.ml#L1822)

<a id="global-global-wi-started-wi-started-src-wi-stuff-ml-92377025"></a>
### wi_started

```ml
wi_started
```

Tracks whether wi started is active in the wi stuff subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/wi_stuff.ml#L456)

<a id="function-function-wi-ticker-function-wi-ticker-src-wi-stuff-ml-314708073"></a>
### WI_Ticker

```ml
function WI_Ticker()
```

Samples acceleration, advances background animation, and ticks the active scoreboard state machine.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/wi_stuff.ml#L1838)

<a id="constant-constant-wi-titley-const-wi-titley-2-src-wi-stuff-ml-490157820"></a>
### WI_TITLEY

```ml
const WI_TITLEY = 2
```

Defines wi titley for the wi stuff subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/wi_stuff.ml#L232)

<a id="function-function-wi-unloaddata-function-wi-unloaddata-src-wi-stuff-ml-1483912327"></a>
### WI_unloadData

```ml
function WI_unloadData()
```

Releases intermission patch references so zone-cached graphics can be reclaimed after exit.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/wi_stuff.ml#L1643)

<a id="function-function-wi-updateanimatedback-function-wi-updateanimatedback-src-wi-stuff-ml-292327135"></a>
### WI_updateAnimatedBack

```ml
function WI_updateAnimatedBack()
```

Advances looping, one-shot, and level-gated background animations at their configured cadence.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/wi_stuff.ml#L650)

<a id="function-function-wi-updatedeathmatchstats-function-wi-updatedeathmatchstats-src-wi-stuff-ml-847163807"></a>
### WI_updateDeathmatchStats

```ml
function WI_updateDeathmatchStats()
```

Animates each frag cell and total toward authoritative values, honoring accelerate-to-finish.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/wi_stuff.ml#L997)

<a id="function-function-wi-updatenetgamestats-function-wi-updatenetgamestats-src-wi-stuff-ml-1059719567"></a>
### WI_updateNetgameStats

```ml
function WI_updateNetgameStats()
```

Animates cooperative percentages for all active players and advances through pause stages.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/wi_stuff.ml#L1140)

<a id="function-function-wi-updatenostate-function-wi-updatenostate-src-wi-stuff-ml-390045391"></a>
### WI_updateNoState

```ml
function WI_updateNoState()
```

Counts down the terminal hold and invokes G_WorldDone exactly when it expires.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/wi_stuff.ml#L900)

<a id="function-function-wi-updateshownextloc-function-wi-updateshownextloc-src-wi-stuff-ml-1190632367"></a>
### WI_updateShowNextLoc

```ml
function WI_updateShowNextLoc()
```

Animates the map pointer and transitions to the terminal hold after the location delay.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/wi_stuff.ml#L924)

<a id="function-function-wi-updatestats-function-wi-updatestats-src-wi-stuff-ml-1580289979"></a>
### WI_updateStats

```ml
function WI_updateStats()
```

Animates single-player percentages and times, with attack/use acceleration and stage sounds.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/wi_stuff.ml#L1326)

<a id="global-global-wi-wbstart-wi-wbstart-src-wi-stuff-ml-1870938621"></a>
### wi_wbstart

```ml
wi_wbstart
```

Holds the optional wi wbstart resource used by the wi stuff subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/wi_stuff.ml#L458)

<a id="global-global-wiminus-wiminus-src-wi-stuff-ml-1286932693"></a>
### wiminus

```ml
wiminus
```

Holds the optional wiminus resource used by the wi stuff subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/wi_stuff.ml#L370)

<a id="global-global-wiminus-name-wiminus-name-src-wi-stuff-ml-784759457"></a>
### wiminus_name

```ml
wiminus_name
```

Stores the mutable wiminus name text used by the wi stuff subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/wi_stuff.ml#L372)

<a id="global-global-yah-yah-src-wi-stuff-ml-646507777"></a>
### yah

```ml
yah
```

Stores the yah collection used by the wi stuff subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/wi_stuff.ml#L350)

<a id="global-global-yah-names-yah-names-src-wi-stuff-ml-506201625"></a>
### yah_names

```ml
yah_names
```

Stores the yah names collection used by the wi stuff subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/wi_stuff.ml#L352)
