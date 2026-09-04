# `src/p_spec.ml`

[Home](README.md) · [Files](Files.md)

Defines and updates sector/line specials, animated surfaces, buttons, movers, environmental damage, and tag searches.

Package: [`(global)`](Package-global-1952375359.md)

Reachable from entry: **yes**

## Imports

- `d_player.ml` → [src/d_player.ml](File-src-d-player-ml-1944166105.md)
- `doomdef.ml` → [src/doomdef.ml](File-src-doomdef-ml-460406769.md)
- `doomstat.ml` → [src/doomstat.ml](File-src-doomstat-ml-1652708088.md)
- `g_game.ml` → [src/g_game.ml](File-src-g-game-ml-257299317.md)
- `i_system.ml` → [src/i_system.ml](File-src-i-system-ml-1632920966.md)
- `info.ml` → [src/info.ml](File-src-info-ml-1415270573.md)
- `m_argv.ml` → [src/m_argv.ml](File-src-m-argv-ml-728984635.md)
- `m_fixed.ml` → [src/m_fixed.ml](File-src-m-fixed-ml-2129187227.md)
- `m_random.ml` → [src/m_random.ml](File-src-m-random-ml-1659574948.md)
- `p_local.ml` → [src/p_local.ml](File-src-p-local-ml-1043095437.md)
- `p_telept.ml` → [src/p_telept.ml](File-src-p-telept-ml-266213122.md)
- `r_local.ml` → [src/r_local.ml](File-src-r-local-ml-797040731.md)
- `r_state.ml` → [src/r_state.ml](File-src-r-state-ml-691819649.md)
- `s_sound.ml` → [src/s_sound.ml](File-src-s-sound-ml-1485495390.md)
- `sounds.ml` → [src/sounds.ml](File-src-sounds-ml-1875364049.md)
- `std/math.ml` → `../MiniLangCompilerOptimization/MiniLangCompilerPy/std/math.ml` — external dependency
- `w_wad.ml` → [src/w_wad.ml](File-src-w-wad-ml-893006035.md)
- `z_zone.ml` → [src/z_zone.ml](File-src-z-zone-ml-1788911354.md)

## Declarations

<a id="function-function-p-numlines-inline-function-p-numlines-src-p-spec-ml-1677013619"></a>
### _P_NumLines

```ml
inline function _P_NumLines()
```

Returns the loaded linedef count for either supported sequence representation.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_spec.ml#L1167)

<a id="function-function-p-numsectors-inline-function-p-numsectors-src-p-spec-ml-56787207"></a>
### _P_NumSectors

```ml
inline function _P_NumSectors()
```

Returns the loaded sector count for either supported sequence representation.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_spec.ml#L1158)

<a id="global-global-ps-animdefs-ps-animdefs-src-p-spec-ml-1219373384"></a>
### _PS_animdefs

```ml
_PS_animdefs
```

Stores the ps animdefs collection used by the p spec subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_spec.ml#L434)

<a id="function-function-ps-idiv-inline-function-ps-idiv-a-b-src-p-spec-ml-6169774"></a>
### _PS_IDiv

```ml
inline function _PS_IDiv(a, b)
```

Returns a signed quotient truncated toward zero, or zero for invalid operands and a zero divisor in `_PS_IDiv`

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `a` | `dynamic` | — | First input operand. |
| `b` | `dynamic` | — | Second input operand. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_spec.ml#L487)

<a id="function-function-ps-isprojectiletype-inline-function-ps-isprojectiletype-t-src-p-spec-ml-542082429"></a>
### _PS_IsProjectileType

```ml
inline function _PS_IsProjectileType(t)
```

Identifies player and monster missile types allowed to trigger projectile-sensitive line specials.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `t` | `dynamic` | — | T value supplied to `_PS_IsProjectileType`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_spec.ml#L505)

<a id="function-function-ps-isseq-inline-function-ps-isseq-v-src-p-spec-ml-1115844777"></a>
### _PS_IsSeq

```ml
inline function _PS_IsSeq(v)
```

Recognizes array and list containers used by level geometry and animation tables.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `v` | `dynamic` | — | Value consumed by the operation. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_spec.ml#L497)

<a id="function-function-ps-linesidesector-function-ps-linesidesector-line-side-src-p-spec-ml-2057387437"></a>
### _PS_LineSideSector

```ml
function _PS_LineSideSector(line, side)
```

Resolves a line's requested side to its front/back sector through direct references or sidedef indices.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `line` | `dynamic` | — | Map line or text line affected by the operation. |
| `side` | `dynamic` | — | Map side affected by the operation. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_spec.ml#L1192)

<a id="function-function-ps-parseint-function-ps-parseint-v-src-p-spec-ml-630103978"></a>
### _PS_ParseInt

```ml
function _PS_ParseInt(v)
```

Parses an integer or numeric string with truncation toward zero, returning void when conversion fails.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `v` | `dynamic` | — | Value consumed by the operation. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_spec.ml#L463)

<a id="function-function-ps-resetbuttons-function-ps-resetbuttons-src-p-spec-ml-1110252694"></a>
### _PS_ResetButtons

```ml
function _PS_ResetButtons()
```

Reinitializes the fixed timed-button registry or clears existing entries when the helper is unavailable.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_spec.ml#L512)

<a id="function-function-ps-sectorindex-function-ps-sectorindex-sec-src-p-spec-ml-1101506329"></a>
### _PS_SectorIndex

```ml
function _PS_SectorIndex(sec)
```

Finds a sector by object identity in the loaded sector table, returning -1 when absent.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `sec` | `dynamic` | — | Sec value supplied to `_PS_SectorIndex`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_spec.ml#L1177)

<a id="function-function-pspec-getpower-function-pspec-getpower-player-pw-src-p-spec-ml-1879109406"></a>
### _PSpec_GetPower

```ml
function _PSpec_GetPower(player, pw)
```

Reads a validated player power duration/value, treating legacy booleans as zero or one.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `player` | `dynamic` | — | Player state affected by the operation. |
| `pw` | `dynamic` | — | Pw value supplied to `_PSpec_GetPower`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_spec.ml#L1091)

<a id="function-function-pspec-powerindex-function-pspec-powerindex-pw-src-p-spec-ml-1313460997"></a>
### _PSpec_PowerIndex

```ml
function _PSpec_PowerIndex(pw)
```

Maps a supported player-power enum or integer to its powers-array slot.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `pw` | `dynamic` | — | Pw value supplied to `_PSpec_PowerIndex`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_spec.ml#L1068)

<a id="global-global-anims-anims-src-p-spec-ml-453732948"></a>
### anims

```ml
anims
```

Stores the anims collection used by the p spec subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_spec.ml#L421)

- [button_t](Type-button-t-1072372538.md) — struct
<a id="constant-constant-buttontime-const-buttontime-35-src-p-spec-ml-922127073"></a>
### BUTTONTIME

```ml
const BUTTONTIME = 35
```

Defines buttontime for the p spec subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_spec.ml#L162)

- [bwhere_e](Type-bwhere-e-2048834432.md) — enum
- [ceiling_e](Type-ceiling-e-1355057336.md) — enum
- [ceiling_t](Type-ceiling-t-1640276859.md) — struct
<a id="constant-constant-ceilspeed-const-ceilspeed-65536-src-p-spec-ml-1134757922"></a>
### CEILSPEED

```ml
const CEILSPEED = 65536
```

Defines ceilspeed for the p spec subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_spec.ml#L312)

<a id="constant-constant-ceilwait-const-ceilwait-150-src-p-spec-ml-556485015"></a>
### CEILWAIT

```ml
const CEILWAIT = 150
```

Defines ceilwait for the p spec subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_spec.ml#L314)

<a id="function-function-ev-dodonut-function-ev-dodonut-line-src-p-spec-ml-714629988"></a>
### EV_DoDonut

```ml
function EV_DoDonut(line)
```

Starts the coupled donut action: lower the tagged pillar while raising its surrounding ring to the outer sector.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `line` | `dynamic` | — | Map line or text line affected by the operation. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_spec.ml#L1453)

<a id="constant-constant-fastdark-const-fastdark-15-src-p-spec-ml-272791409"></a>
### FASTDARK

```ml
const FASTDARK = 15
```

Defines fastdark for the p spec subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_spec.ml#L119)

- [fireflicker_t](Type-fireflicker-t-1279347520.md) — struct
- [floor_e](Type-floor-e-1948180281.md) — enum
- [floormove_t](Type-floormove-t-1011946567.md) — struct
<a id="constant-constant-floorspeed-const-floorspeed-65536-src-p-spec-ml-483253614"></a>
### FLOORSPEED

```ml
const FLOORSPEED = 65536
```

Defines floorspeed for the p spec subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_spec.ml#L380)

<a id="function-function-getnextsector-function-getnextsector-line-sec-src-p-spec-ml-66776559"></a>
### getNextSector

```ml
function getNextSector(line, sec)
```

Given one sector on a two-sided line, returns the opposite adjacent sector.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `line` | `dynamic` | — | Map line or text line affected by the operation. |
| `sec` | `dynamic` | — | Sec value supplied to `getNextSector`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_spec.ml#L1261)

<a id="function-function-getsector-function-getsector-currentsector-lineindex-side-src-p-spec-ml-1222409722"></a>
### getSector

```ml
function getSector(currentSector, lineIndex, side)
```

Returns the sector referenced by a resolved sidedef, or void when the side is missing.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `currentSector` | `dynamic` | — | Current sector value supplied to `getSector`. |
| `lineIndex` | `dynamic` | — | Index identifying line. |
| `side` | `dynamic` | — | Map side affected by the operation. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_spec.ml#L1252)

<a id="function-function-getside-function-getside-currentsector-lineindex-side-src-p-spec-ml-801455564"></a>
### getSide

```ml
function getSide(currentSector, lineIndex, side)
```

Resolves a sector-local line and side number to the corresponding sidedef with index validation.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `currentSector` | `dynamic` | — | Current sector value supplied to `getSide`. |
| `lineIndex` | `dynamic` | — | Index identifying line. |
| `side` | `dynamic` | — | Map side affected by the operation. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_spec.ml#L1228)

- [glow_t](Type-glow-t-701514967.md) — struct
<a id="constant-constant-glowspeed-const-glowspeed-8-src-p-spec-ml-972423575"></a>
### GLOWSPEED

```ml
const GLOWSPEED = 8
```

Defines glowspeed for the p spec subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_spec.ml#L115)

<a id="global-global-lastanim-lastanim-src-p-spec-ml-690706762"></a>
### lastanim

```ml
lastanim
```

Tracks the mutable lastanim value used by the p spec subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_spec.ml#L423)

<a id="global-global-leveltimecount-leveltimecount-src-p-spec-ml-1816154212"></a>
### levelTimeCount

```ml
levelTimeCount
```

Tracks the mutable level time count value used by the p spec subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_spec.ml#L43)

<a id="global-global-leveltimer-leveltimer-src-p-spec-ml-556197098"></a>
### levelTimer

```ml
levelTimer
```

Tracks whether level timer is active in the p spec subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_spec.ml#L41)

- [lightflash_t](Type-lightflash-t-1486999356.md) — struct
<a id="global-global-linespeciallist-linespeciallist-src-p-spec-ml-1554026252"></a>
### linespeciallist

```ml
linespeciallist
```

Stores the linespeciallist collection used by the p spec subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_spec.ml#L430)

<a id="constant-constant-maxanims-const-maxanims-32-src-p-spec-ml-2039970970"></a>
### MAXANIMS

```ml
const MAXANIMS = 32
```

Defines the maximum maxanims accepted by the p spec subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_spec.ml#L419)

<a id="constant-constant-maxbuttons-const-maxbuttons-16-src-p-spec-ml-1277339990"></a>
### MAXBUTTONS

```ml
const MAXBUTTONS = 16
```

Defines the maximum maxbuttons accepted by the p spec subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_spec.ml#L160)

<a id="constant-constant-maxceilings-const-maxceilings-30-src-p-spec-ml-795566398"></a>
### MAXCEILINGS

```ml
const MAXCEILINGS = 30
```

Defines the maximum maxceilings accepted by the p spec subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_spec.ml#L316)

<a id="constant-constant-maxlineanims-const-maxlineanims-64-src-p-spec-ml-2008933769"></a>
### MAXLINEANIMS

```ml
const MAXLINEANIMS = 64
```

Defines the maximum maxlineanims accepted by the p spec subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_spec.ml#L426)

<a id="constant-constant-maxplats-const-maxplats-30-src-p-spec-ml-525818384"></a>
### MAXPLATS

```ml
const MAXPLATS = 30
```

Defines the maximum maxplats accepted by the p spec subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_spec.ml#L223)

<a id="constant-constant-maxswitches-const-maxswitches-50-src-p-spec-ml-305292880"></a>
### MAXSWITCHES

```ml
const MAXSWITCHES = 50
```

Defines the maximum maxswitches accepted by the p spec subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_spec.ml#L158)

<a id="constant-constant-mo-teleportman-const-mo-teleportman-14-src-p-spec-ml-1998869338"></a>
### MO_TELEPORTMAN

```ml
const MO_TELEPORTMAN = 14
```

Defines mo teleportman for the p spec subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_spec.ml#L48)

<a id="global-global-numlinespecials-numlinespecials-src-p-spec-ml-1988424588"></a>
### numlinespecials

```ml
numlinespecials
```

Tracks the mutable numlinespecials value used by the p spec subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_spec.ml#L428)

<a id="function-function-p-crossspecialline-function-p-crossspecialline-linenum-side-thing-src-p-spec-ml-101146787"></a>
### P_CrossSpecialLine

```ml
function P_CrossSpecialLine(linenum, side, thing)
```

Dispatches one-shot and repeatable walkover specials after validating line index, side, actor, and projectile rules.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `linenum` | `dynamic` | — | Index identifying line. |
| `side` | `dynamic` | — | Map side affected by the operation. |
| `thing` | `dynamic` | — | World object affected by the operation. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_spec.ml#L783)

<a id="function-function-p-findhighestceilingsurrounding-function-p-findhighestceilingsurrounding-sec-src-p-spec-ml-129033489"></a>
### P_FindHighestCeilingSurrounding

```ml
function P_FindHighestCeilingSurrounding(sec)
```

Returns the maximum ceiling height among all valid sectors adjacent to the supplied sector.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `sec` | `dynamic` | — | Sec value supplied to `P_FindHighestCeilingSurrounding`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_spec.ml#L1388)

<a id="function-function-p-findhighestfloorsurrounding-function-p-findhighestfloorsurrounding-sec-src-p-spec-ml-975368295"></a>
### P_FindHighestFloorSurrounding

```ml
function P_FindHighestFloorSurrounding(sec)
```

Returns the maximum floor height among all valid sectors adjacent to the supplied sector.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `sec` | `dynamic` | — | Sec value supplied to `P_FindHighestFloorSurrounding`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_spec.ml#L1314)

<a id="function-function-p-findlowestceilingsurrounding-function-p-findlowestceilingsurrounding-sec-src-p-spec-ml-1537753587"></a>
### P_FindLowestCeilingSurrounding

```ml
function P_FindLowestCeilingSurrounding(sec)
```

Returns the minimum ceiling height among all valid sectors adjacent to the supplied sector.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `sec` | `dynamic` | — | Sec value supplied to `P_FindLowestCeilingSurrounding`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_spec.ml#L1365)

<a id="function-function-p-findlowestfloorsurrounding-function-p-findlowestfloorsurrounding-sec-src-p-spec-ml-141499463"></a>
### P_FindLowestFloorSurrounding

```ml
function P_FindLowestFloorSurrounding(sec)
```

Returns the minimum floor height among all valid sectors adjacent to the supplied sector.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `sec` | `dynamic` | — | Sec value supplied to `P_FindLowestFloorSurrounding`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_spec.ml#L1291)

<a id="function-function-p-findminsurroundinglight-function-p-findminsurroundinglight-sector-max-src-p-spec-ml-1722222576"></a>
### P_FindMinSurroundingLight

```ml
function P_FindMinSurroundingLight(sector, max)
```

Finds the lowest adjacent sector light level without exceeding the caller-provided starting maximum.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `sector` | `dynamic` | — | Map sector affected by the operation. |
| `max` | `dynamic` | — | Maximum permitted value. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_spec.ml#L1429)

<a id="function-function-p-findnexthighestfloor-function-p-findnexthighestfloor-sec-currentheight-src-p-spec-ml-1152834469"></a>
### P_FindNextHighestFloor

```ml
function P_FindNextHighestFloor(sec, currentheight)
```

Returns the lowest adjacent floor strictly above currentheight, or currentheight when none exists.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `sec` | `dynamic` | — | Sec value supplied to `P_FindNextHighestFloor`. |
| `currentheight` | `dynamic` | — | Height of current in pixels or map units. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_spec.ml#L1338)

<a id="function-function-p-findsectorfromlinetag-function-p-findsectorfromlinetag-line-start-src-p-spec-ml-652342582"></a>
### P_FindSectorFromLineTag

```ml
function P_FindSectorFromLineTag(line, start)
```

Continues a linear search after start for the next sector whose tag matches the triggering line.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `line` | `dynamic` | — | Map line or text line affected by the operation. |
| `start` | `dynamic` | — | Start value supplied to `P_FindSectorFromLineTag`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_spec.ml#L1412)

<a id="function-function-p-initpicanims-function-p-initpicanims-src-p-spec-ml-466094138"></a>
### P_InitPicAnims

```ml
function P_InitPicAnims()
```

Resolves built-in flat/texture animation name ranges, validates contiguity, and records runtime frame cycles.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_spec.ml#L527)

<a id="global-global-p-picanim-revision-p-picanim-revision-src-p-spec-ml-2009416644"></a>
### p_picanim_revision

```ml
p_picanim_revision
```

Tracks the mutable p picanim revision value used by the p spec subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_spec.ml#L45)

<a id="function-function-p-playerinspecialsector-function-p-playerinspecialsector-player-src-p-spec-ml-444795477"></a>
### P_PlayerInSpecialSector

```ml
function P_PlayerInSpecialSector(player)
```

Applies floor-contact damage, secret discovery, and exit effects for the player's current sector special.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `player` | `dynamic` | — | Player state affected by the operation. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_spec.ml#L1109)

<a id="function-function-p-shootspecialline-function-p-shootspecialline-thing-line-src-p-spec-ml-566507318"></a>
### P_ShootSpecialLine

```ml
function P_ShootSpecialLine(thing, line)
```

Dispatches gun-triggered line types to floor, door, or switch actions while enforcing monster restrictions.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `thing` | `dynamic` | — | World object affected by the operation. |
| `line` | `dynamic` | — | Map line or text line affected by the operation. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_spec.ml#L753)

<a id="function-function-p-spawnspecials-function-p-spawnspecials-src-p-spec-ml-1573826186"></a>
### P_SpawnSpecials

```ml
function P_SpawnSpecials()
```

Parses the level timer, spawns sector lighting/door effects, collects scrolling lines, and resets active movers/buttons.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_spec.ml#L574)

<a id="function-function-p-updatespecials-function-p-updatespecials-src-p-spec-ml-554269270"></a>
### P_UpdateSpecials

```ml
function P_UpdateSpecials()
```

Advances level timeout, surface animation translations, scrolling walls, and timed button restoration each tic.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_spec.ml#L686)

- [plat_e](Type-plat-e-1861377276.md) — enum
- [plat_t](Type-plat-t-1609712991.md) — struct
<a id="constant-constant-platspeed-const-platspeed-65536-src-p-spec-ml-1010881810"></a>
### PLATSPEED

```ml
const PLATSPEED = 65536
```

Defines platspeed for the p spec subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_spec.ml#L221)

- [plattype_e](Type-plattype-e-1533476884.md) — enum
<a id="constant-constant-platwait-const-platwait-3-src-p-spec-ml-38196560"></a>
### PLATWAIT

```ml
const PLATWAIT = 3
```

Defines platwait for the p spec subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_spec.ml#L219)

- [ps_anim_t](Type-ps-anim-t-286843655.md) — struct
- [ps_animdef_t](Type-ps-animdef-t-600998160.md) — struct
- [result_e](Type-result-e-1898737036.md) — enum
<a id="constant-constant-slowdark-const-slowdark-35-src-p-spec-ml-1420727577"></a>
### SLOWDARK

```ml
const SLOWDARK = 35
```

Defines slowdark for the p spec subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_spec.ml#L121)

- [stair_e](Type-stair-e-624965850.md) — enum
- [strobe_t](Type-strobe-t-799099699.md) — struct
<a id="constant-constant-strobebright-const-strobebright-5-src-p-spec-ml-94012468"></a>
### STROBEBRIGHT

```ml
const STROBEBRIGHT = 5
```

Defines strobebright for the p spec subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_spec.ml#L117)

- [switchlist_t](Type-switchlist-t-1968373910.md) — struct
<a id="function-function-twosided-function-twosided-sectorindex-lineindex-src-p-spec-ml-1289321126"></a>
### twoSided

```ml
function twoSided(sectorIndex, lineIndex)
```

Tests whether a sector-owned line index references a valid ML_TWOSIDED linedef.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `sectorIndex` | `dynamic` | — | Index identifying sector. |
| `lineIndex` | `dynamic` | — | Index identifying line. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_spec.ml#L1212)

<a id="constant-constant-vdoorspeed-const-vdoorspeed-131072-src-p-spec-ml-471782701"></a>
### VDOORSPEED

```ml
const VDOORSPEED = 131072
```

Defines vdoorspeed for the p spec subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_spec.ml#L266)

<a id="constant-constant-vdoorwait-const-vdoorwait-150-src-p-spec-ml-1361373377"></a>
### VDOORWAIT

```ml
const VDOORWAIT = 150
```

Defines vdoorwait for the p spec subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_spec.ml#L268)

- [vldoor_e](Type-vldoor-e-1237150663.md) — enum
- [vldoor_t](Type-vldoor-t-951931140.md) — struct
