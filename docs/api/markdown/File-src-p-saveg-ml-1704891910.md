# `src/p_saveg.ml`

[Home](README.md) · [Files](Files.md)

Serializes and restores players, world state, thinkers, specials, and cross-object savegame references.

Package: [`(global)`](Package-global-1952375359.md)

Reachable from entry: **yes**

## Imports

- `d_player.ml` → [src/d_player.ml](File-src-d-player-ml-1944166105.md)
- `d_ticcmd.ml` → [src/d_ticcmd.ml](File-src-d-ticcmd-ml-1143326682.md)
- `doomstat.ml` → [src/doomstat.ml](File-src-doomstat-ml-1652708088.md)
- `i_system.ml` → [src/i_system.ml](File-src-i-system-ml-1632920966.md)
- `info.ml` → [src/info.ml](File-src-info-ml-1415270573.md)
- `p_ceilng.ml` → [src/p_ceilng.ml](File-src-p-ceilng-ml-226654252.md)
- `p_doors.ml` → [src/p_doors.ml](File-src-p-doors-ml-224295587.md)
- `p_floor.ml` → [src/p_floor.ml](File-src-p-floor-ml-1999892698.md)
- `p_lights.ml` → [src/p_lights.ml](File-src-p-lights-ml-1710096069.md)
- `p_local.ml` → [src/p_local.ml](File-src-p-local-ml-1043095437.md)
- `p_mobj.ml` → [src/p_mobj.ml](File-src-p-mobj-ml-1335564114.md)
- `p_plats.ml` → [src/p_plats.ml](File-src-p-plats-ml-866228534.md)
- `p_switch.ml` → [src/p_switch.ml](File-src-p-switch-ml-925070734.md)
- `p_tick.ml` → [src/p_tick.ml](File-src-p-tick-ml-887781845.md)
- `r_main.ml` → [src/r_main.ml](File-src-r-main-ml-1902335243.md)
- `r_state.ml` → [src/r_state.ml](File-src-r-state-ml-691819649.md)
- `z_zone.ml` → [src/z_zone.ml](File-src-z-zone-ml-1788911354.md)

## Declarations

<a id="function-function-psave-ensurebuffer-inline-function-psave-ensurebuffer-size-src-p-saveg-ml-1276165487"></a>
### _PSave_EnsureBuffer

```ml
inline function _PSave_EnsureBuffer(size)
```

Ensures a byte buffer of at least the requested size exists and rewinds the shared stream cursor to zero.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `size` | `dynamic` | — | Requested size in bytes or elements. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_saveg.ml#L46)

<a id="function-function-psv-archiveplayerv2-function-psv-archiveplayerv2-p-src-p-saveg-ml-2010827783"></a>
### _PSV_ArchivePlayerV2

```ml
function _PSV_ArchivePlayerV2(p)
```

Writes the version-two player record in fixed field order, including commands, view, inventory, powers, weapons, counters, frags, and psprites.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `p` | `dynamic` | — | Object or data record consumed by the operation. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_saveg.ml#L375)

<a id="function-function-psv-checktag-function-psv-checktag-tag-src-p-saveg-ml-1446091901"></a>
### _PSV_CheckTag

```ml
function _PSV_CheckTag(tag)
```

Consumes a four-byte section identifier and reports whether it matches the expected zero-padded tag.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `tag` | `dynamic` | — | Zone-memory or resource-lifetime tag. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_saveg.ml#L189)

<a id="function-function-psv-clearblocklinks-function-psv-clearblocklinks-src-p-saveg-ml-187733669"></a>
### _PSV_ClearBlockLinks

```ml
function _PSV_ClearBlockLinks()
```

Empties every blockmap thing head before restoring mobj spatial links.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_saveg.ml#L362)

<a id="function-function-psv-clearthinglists-function-psv-clearthinglists-src-p-saveg-ml-1291036337"></a>
### _PSV_ClearThingLists

```ml
function _PSV_ClearThingLists()
```

Clears sector thing chains before unarchived mobjs are relinked into the reconstructed world.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_saveg.ml#L346)

<a id="function-function-psv-ensure-function-psv-ensure-extra-src-p-saveg-ml-687050275"></a>
### _PSV_Ensure

```ml
function _PSV_Ensure(extra)
```

Grows the save buffer geometrically so a pending write fits without invalidating the current write offset.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `extra` | `dynamic` | — | Extra value supplied to `_PSV_Ensure`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_saveg.ml#L59)

<a id="function-function-psv-objindex-function-psv-objindex-arr-obj-src-p-saveg-ml-284659665"></a>
### _PSV_ObjIndex

```ml
function _PSV_ObjIndex(arr, obj)
```

Resolves an object reference to its stable array index for serialized cross-references, returning -1 when absent.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `arr` | `dynamic` | — | Arr value supplied to `_PSV_ObjIndex`. |
| `obj` | `dynamic` | — | Obj value supplied to `_PSV_ObjIndex`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_saveg.ml#L221)

<a id="function-function-psv-playerindex-inline-function-psv-playerindex-p-src-p-saveg-ml-23143384"></a>
### _PSV_PlayerIndex

```ml
inline function _PSV_PlayerIndex(p)
```

Resolves a player record to its slot so mobj/player ownership links can be serialized as integers.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `p` | `dynamic` | — | Object or data record consumed by the operation. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_saveg.ml#L235)

<a id="function-function-psv-readbool-inline-function-psv-readbool-src-p-saveg-ml-1105554270"></a>
### _PSV_ReadBool

```ml
inline function _PSV_ReadBool()
```

Consumes one canonical byte and interprets every nonzero value as true.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_saveg.ml#L170)

<a id="function-function-psv-readceiling-inline-function-psv-readceiling-src-p-saveg-ml-1741552740"></a>
### _PSV_ReadCeiling

```ml
inline function _PSV_ReadCeiling()
```

Recreates a ceiling mover, reclaims its sector, registers its thinker, and restores tagged active-ceiling control.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_saveg.ml#L1188)

<a id="function-function-psv-readdoor-inline-function-psv-readdoor-src-p-saveg-ml-1491372622"></a>
### _PSV_ReadDoor

```ml
inline function _PSV_ReadDoor()
```

Recreates a vertical door from stream fields, reclaims its sector, and registers its movement thinker.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_saveg.ml#L1200)

<a id="function-function-psv-readfixedstring-function-psv-readfixedstring-width-src-p-saveg-ml-2041160199"></a>
### _PSV_ReadFixedString

```ml
function _PSV_ReadFixedString(width)
```

Consumes a fixed-width byte field and decodes its zero-terminated text prefix.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `width` | `dynamic` | — | Width of the target in pixels or map units. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_saveg.ml#L206)

<a id="function-function-psv-readflash-inline-function-psv-readflash-src-p-saveg-ml-1498532626"></a>
### _PSV_ReadFlash

```ml
inline function _PSV_ReadFlash()
```

Recreates and registers a randomized two-level sector light-flash thinker from stream fields.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_saveg.ml#L1236)

<a id="function-function-psv-readfloor-inline-function-psv-readfloor-src-p-saveg-ml-2058540634"></a>
### _PSV_ReadFloor

```ml
inline function _PSV_ReadFloor()
```

Recreates a floor mover from stream fields, reclaims its sector, and registers its movement thinker.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_saveg.ml#L1211)

<a id="function-function-psv-readglow-inline-function-psv-readglow-src-p-saveg-ml-15709750"></a>
### _PSV_ReadGlow

```ml
inline function _PSV_ReadGlow()
```

Recreates and registers a sector glow thinker with its saved brightness bounds and direction.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_saveg.ml#L1256)

<a id="function-function-psv-readmapthing-inline-function-psv-readmapthing-src-p-saveg-ml-497450330"></a>
### _PSV_ReadMapthing

```ml
inline function _PSV_ReadMapthing()
```

Consumes five signed fields and reconstructs one map spawn-point record.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_saveg.ml#L293)

<a id="function-function-psv-readmobj-function-psv-readmobj-src-p-saveg-ml-752994799"></a>
### _PSV_ReadMobj

```ml
function _PSV_ReadMobj()
```

Reconstructs an mobj from serialized fields, restores metadata and player ownership, and relinks its thinker and spatial indices.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_saveg.ml#L886)

<a id="function-function-psv-readplat-inline-function-psv-readplat-src-p-saveg-ml-1188583386"></a>
### _PSV_ReadPlat

```ml
inline function _PSV_ReadPlat()
```

Recreates a platform mover, reclaims its sector, registers its thinker, and restores tagged active-platform control.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_saveg.ml#L1223)

<a id="function-function-psv-readpsprite-inline-function-psv-readpsprite-src-p-saveg-ml-32997428"></a>
### _PSV_ReadPsprite

```ml
inline function _PSV_ReadPsprite()
```

Consumes a weapon sprite record and resolves its canonical state index back to a runtime reference.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_saveg.ml#L336)

<a id="function-function-psv-reads32-inline-function-psv-reads32-src-p-saveg-ml-126859058"></a>
### _PSV_ReadS32

```ml
inline function _PSV_ReadS32()
```

Consumes four little-endian bytes and restores their signed 32-bit interpretation.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_saveg.ml#L176)

<a id="function-function-psv-readsectorref-inline-function-psv-readsectorref-src-p-saveg-ml-1003238056"></a>
### _PSV_ReadSectorRef

```ml
inline function _PSV_ReadSectorRef()
```

Consumes a sector index and returns its validated map reference, or void for malformed input.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_saveg.ml#L1178)

<a id="function-function-psv-readstrobe-inline-function-psv-readstrobe-src-p-saveg-ml-1498149678"></a>
### _PSV_ReadStrobe

```ml
inline function _PSV_ReadStrobe()
```

Recreates and registers a sector strobe thinker with its saved countdown and timing bounds.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_saveg.ml#L1246)

<a id="function-function-psv-readticcmd-inline-function-psv-readticcmd-src-p-saveg-ml-752434306"></a>
### _PSV_ReadTiccmd

```ml
inline function _PSV_ReadTiccmd()
```

Consumes six signed fields and reconstructs one player tic command.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_saveg.ml#L315)

<a id="function-function-psv-readu8-inline-function-psv-readu8-src-p-saveg-ml-747825898"></a>
### _PSV_ReadU8

```ml
inline function _PSV_ReadU8()
```

Consumes one byte from the shared stream, returning zero but still advancing when the cursor is out of range.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_saveg.ml#L157)

<a id="function-function-psv-resolvethinkermobj-function-psv-resolvethinkermobj-node-src-p-saveg-ml-1762355821"></a>
### _PSV_ResolveThinkerMobj

```ml
function _PSV_ResolveThinkerMobj(node)
```

Resolves a thinker owner through current and legacy registries, accepting only objects with the core mobj fields.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `node` | `dynamic` | — | Node value supplied to `_PSV_ResolveThinkerMobj`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_saveg.ml#L828)

<a id="constant-constant-psv-sc-ceiling-const-psv-sc-ceiling-1-src-p-saveg-ml-1239217307"></a>
### _PSV_SC_CEILING

```ml
const _PSV_SC_CEILING = 1
```

Defines psv sc ceiling for the p saveg subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_saveg.ml#L804)

<a id="constant-constant-psv-sc-door-const-psv-sc-door-2-src-p-saveg-ml-1671537638"></a>
### _PSV_SC_DOOR

```ml
const _PSV_SC_DOOR = 2
```

Defines psv sc door for the p saveg subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_saveg.ml#L807)

<a id="constant-constant-psv-sc-flash-const-psv-sc-flash-5-src-p-saveg-ml-1955593659"></a>
### _PSV_SC_FLASH

```ml
const _PSV_SC_FLASH = 5
```

Defines psv sc flash for the p saveg subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_saveg.ml#L816)

<a id="constant-constant-psv-sc-floor-const-psv-sc-floor-3-src-p-saveg-ml-1234025285"></a>
### _PSV_SC_FLOOR

```ml
const _PSV_SC_FLOOR = 3
```

Defines psv sc floor for the p saveg subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_saveg.ml#L810)

<a id="constant-constant-psv-sc-glow-const-psv-sc-glow-7-src-p-saveg-ml-2001006701"></a>
### _PSV_SC_GLOW

```ml
const _PSV_SC_GLOW = 7
```

Defines psv sc glow for the p saveg subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_saveg.ml#L822)

<a id="constant-constant-psv-sc-plat-const-psv-sc-plat-4-src-p-saveg-ml-1074108250"></a>
### _PSV_SC_PLAT

```ml
const _PSV_SC_PLAT = 4
```

Defines psv sc plat for the p saveg subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_saveg.ml#L813)

<a id="constant-constant-psv-sc-strobe-const-psv-sc-strobe-6-src-p-saveg-ml-663353304"></a>
### _PSV_SC_STROBE

```ml
const _PSV_SC_STROBE = 6
```

Defines psv sc strobe for the p saveg subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_saveg.ml#L819)

<a id="function-function-psv-sectorindex-inline-function-psv-sectorindex-sec-src-p-saveg-ml-1790716839"></a>
### _PSV_SectorIndex

```ml
inline function _PSV_SectorIndex(sec)
```

Resolves a sector object to its map-array index for thinker and world-state serialization.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `sec` | `dynamic` | — | Sec value supplied to `_PSV_SectorIndex`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_saveg.ml#L243)

<a id="function-function-psv-statefromindex-inline-function-psv-statefromindex-idx-src-p-saveg-ml-1363500157"></a>
### _PSV_StateFromIndex

```ml
inline function _PSV_StateFromIndex(idx)
```

Restores a validated actor-state reference from its serialized canonical index.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `idx` | `dynamic` | — | Zero-based element or table index. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_saveg.ml#L267)

<a id="function-function-psv-statetoindex-function-psv-statetoindex-st-src-p-saveg-ml-1515990960"></a>
### _PSV_StateToIndex

```ml
function _PSV_StateToIndex(st)
```

Converts an actor-state reference to the canonical metadata index written into the save stream.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `st` | `dynamic` | — | St value supplied to `_PSV_StateToIndex`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_saveg.ml#L251)

<a id="constant-constant-psv-tc-mobj-const-psv-tc-mobj-1-src-p-saveg-ml-315514203"></a>
### _PSV_TC_MOBJ

```ml
const _PSV_TC_MOBJ = 1
```

Defines psv tc mobj for the p saveg subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_saveg.ml#L800)

<a id="function-function-psv-tos32-inline-function-psv-tos32-v-src-p-saveg-ml-13872842"></a>
### _PSV_ToS32

```ml
inline function _PSV_ToS32(v)
```

Normalizes nullable savegame values to a stable signed 32-bit integer.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `v` | `dynamic` | — | Value consumed by the operation. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_saveg.ml#L87)

<a id="function-function-psv-unarchiveplayerv1-function-psv-unarchiveplayerv1-p-src-p-saveg-ml-121398479"></a>
### _PSV_UnArchivePlayerV1

```ml
function _PSV_UnArchivePlayerV1(p)
```

Reads the legacy player layout, supplies defaults for fields introduced later, and leaves object links for post-load repair.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `p` | `dynamic` | — | Object or data record consumed by the operation. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_saveg.ml#L455)

<a id="function-function-psv-unarchiveplayerv2-function-psv-unarchiveplayerv2-p-src-p-saveg-ml-1915418215"></a>
### _PSV_UnArchivePlayerV2

```ml
function _PSV_UnArchivePlayerV2(p)
```

Reconstructs a version-two player record in stream order while validating enum indices and fixed-size arrays.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `p` | `dynamic` | — | Object or data record consumed by the operation. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_saveg.ml#L530)

<a id="function-function-psv-writebool-inline-function-psv-writebool-v-src-p-saveg-ml-1512429562"></a>
### _PSV_WriteBool

```ml
inline function _PSV_WriteBool(v)
```

Appends a canonical one-byte boolean, encoding only literal true as one.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `v` | `dynamic` | — | Value consumed by the operation. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_saveg.ml#L110)

<a id="function-function-psv-writeceiling-inline-function-psv-writeceiling-c-src-p-saveg-ml-1984752735"></a>
### _PSV_WriteCeiling

```ml
inline function _PSV_WriteCeiling(c)
```

Appends a ceiling mover's sector index, bounds, speed, crush flag, direction, tag, and saved direction.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `c` | `dynamic` | — | C value supplied to `_PSV_WriteCeiling`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_saveg.ml#L1027)

<a id="function-function-psv-writedoor-inline-function-psv-writedoor-d-src-p-saveg-ml-1761991072"></a>
### _PSV_WriteDoor

```ml
inline function _PSV_WriteDoor(d)
```

Appends a vertical door's sector index, type, destination, speed, direction, wait, and countdown.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `d` | `dynamic` | — | Divisor or direction value used by the operation. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_saveg.ml#L1042)

<a id="function-function-psv-writefixedstring-function-psv-writefixedstring-s-width-src-p-saveg-ml-1862858720"></a>
### _PSV_WriteFixedString

```ml
function _PSV_WriteFixedString(s, width)
```

Appends a fixed-width byte string, truncating excess text and zero-padding unused positions.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `s` | `dynamic` | — | S value supplied to `_PSV_WriteFixedString`. |
| `width` | `dynamic` | — | Width of the target in pixels or map units. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_saveg.ml#L143)

<a id="function-function-psv-writeflash-inline-function-psv-writeflash-f-src-p-saveg-ml-153409412"></a>
### _PSV_WriteFlash

```ml
inline function _PSV_WriteFlash(f)
```

Appends a light flash's sector, countdown, brightness bounds, and randomized interval limits.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `f` | `dynamic` | — | F value supplied to `_PSV_WriteFlash`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_saveg.ml#L1088)

<a id="function-function-psv-writefloor-inline-function-psv-writefloor-f-src-p-saveg-ml-2908500"></a>
### _PSV_WriteFloor

```ml
inline function _PSV_WriteFloor(f)
```

Appends a floor mover's sector index, type, crush and direction flags, endpoint changes, destination, and speed.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `f` | `dynamic` | — | F value supplied to `_PSV_WriteFloor`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_saveg.ml#L1056)

<a id="function-function-psv-writeglow-inline-function-psv-writeglow-g-src-p-saveg-ml-1868291947"></a>
### _PSV_WriteGlow

```ml
inline function _PSV_WriteGlow(g)
```

Appends a glow's sector, brightness bounds, and current oscillation direction.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `g` | `dynamic` | — | G value supplied to `_PSV_WriteGlow`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_saveg.ml#L1112)

<a id="function-function-psv-writemapthing-inline-function-psv-writemapthing-mt-src-p-saveg-ml-1808125025"></a>
### _PSV_WriteMapthing

```ml
inline function _PSV_WriteMapthing(mt)
```

Appends a spawn point's five map fields in fixed order, substituting a zero record for an absent spawn point.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `mt` | `dynamic` | — | Mt value supplied to `_PSV_WriteMapthing`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_saveg.ml#L279)

<a id="function-function-psv-writemobj-function-psv-writemobj-mo-src-p-saveg-ml-41275997"></a>
### _PSV_WriteMobj

```ml
function _PSV_WriteMobj(mo)
```

Appends an mobj's position, physics, state, AI counters, player slot, and spawn point while omitting transient links.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `mo` | `dynamic` | — | Map object affected by the operation. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_saveg.ml#L848)

<a id="function-function-psv-writeplat-function-psv-writeplat-p-src-p-saveg-ml-1850217587"></a>
### _PSV_WritePlat

```ml
function _PSV_WritePlat(p)
```

Appends a platform's sector, travel bounds, timing, current and saved status, crush flag, tag, and behavior type.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `p` | `dynamic` | — | Object or data record consumed by the operation. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_saveg.ml#L1071)

<a id="function-function-psv-writepsprite-inline-function-psv-writepsprite-psp-src-p-saveg-ml-277364781"></a>
### _PSV_WritePsprite

```ml
inline function _PSV_WritePsprite(psp)
```

Appends a weapon sprite's canonical state index, timer, and screen coordinates, with an absent-state sentinel for void.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `psp` | `dynamic` | — | Psp value supplied to `_PSV_WritePsprite`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_saveg.ml#L323)

<a id="function-function-psv-writes32-inline-function-psv-writes32-v-src-p-saveg-ml-1422577328"></a>
### _PSV_WriteS32

```ml
inline function _PSV_WriteS32(v)
```

Appends a normalized signed 32-bit value in stable little-endian byte order.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `v` | `dynamic` | — | Value consumed by the operation. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_saveg.ml#L117)

<a id="function-function-psv-writestrobe-inline-function-psv-writestrobe-s-src-p-saveg-ml-578041519"></a>
### _PSV_WriteStrobe

```ml
inline function _PSV_WriteStrobe(s)
```

Appends a strobe's sector, countdown, brightness bounds, and dark/bright durations.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `s` | `dynamic` | — | S value supplied to `_PSV_WriteStrobe`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_saveg.ml#L1100)

<a id="function-function-psv-writetag-function-psv-writetag-tag-src-p-saveg-ml-749116199"></a>
### _PSV_WriteTag

```ml
function _PSV_WriteTag(tag)
```

Appends exactly four identifier bytes, padding a short save-section tag with zeros.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `tag` | `dynamic` | — | Zone-memory or resource-lifetime tag. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_saveg.ml#L128)

<a id="function-function-psv-writeticcmd-inline-function-psv-writeticcmd-cmd-src-p-saveg-ml-476492240"></a>
### _PSV_WriteTiccmd

```ml
inline function _PSV_WriteTiccmd(cmd)
```

Appends all six command fields in fixed order, substituting a neutral command when no record is supplied.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `cmd` | `dynamic` | — | Cmd value supplied to `_PSV_WriteTiccmd`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_saveg.ml#L300)

<a id="function-function-psv-writeu8-inline-function-psv-writeu8-v-src-p-saveg-ml-1008826060"></a>
### _PSV_WriteU8

```ml
inline function _PSV_WriteU8(v)
```

Appends the low byte of a normalized value, growing the save buffer before advancing the stream cursor.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `v` | `dynamic` | — | Value consumed by the operation. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_saveg.ml#L99)

<a id="function-function-p-archiveplayers-function-p-archiveplayers-src-p-saveg-ml-1280947305"></a>
### P_ArchivePlayers

```ml
function P_ArchivePlayers()
```

Writes the active-player mask followed by one versioned player record for each participating slot.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_saveg.ml#L609)

<a id="function-function-p-archivespecials-function-p-archivespecials-src-p-saveg-ml-1104270211"></a>
### P_ArchiveSpecials

```ml
function P_ArchiveSpecials()
```

Serializes supported active ceiling, door, floor, platform, lighting, and button thinkers with sector references and terminates the list.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_saveg.ml#L1121)

<a id="function-function-p-archivethinkers-function-p-archivethinkers-src-p-saveg-ml-1947368499"></a>
### P_ArchiveThinkers

```ml
function P_ArchiveThinkers()
```

Counts serializable mobj thinkers and emits a versioned typed thinker section containing each validated owner.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_saveg.ml#L961)

<a id="function-function-p-archiveworld-function-p-archiveworld-src-p-saveg-ml-1175521633"></a>
### P_ArchiveWorld

```ml
function P_ArchiveWorld()
```

Serializes mutable sector heights, textures, light, specials, and sidedef texture/offset state in map-array order.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_saveg.ml#L668)

<a id="function-function-p-unarchiveplayers-function-p-unarchiveplayers-src-p-saveg-ml-1642831845"></a>
### P_UnArchivePlayers

```ml
function P_UnArchivePlayers()
```

Reads active player records for the detected save version and resets inactive slots to canonical defaults.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_saveg.ml#L628)

<a id="function-function-p-unarchivespecials-function-p-unarchivespecials-src-p-saveg-ml-1069769677"></a>
### P_UnArchiveSpecials

```ml
function P_UnArchiveSpecials()
```

Recreates serialized special thinkers, reconnects their sector ownership, and rebuilds active ceiling/platform registries.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_saveg.ml#L1266)

<a id="function-function-p-unarchivethinkers-function-p-unarchivethinkers-src-p-saveg-ml-237453381"></a>
### P_UnArchiveThinkers

```ml
function P_UnArchiveThinkers()
```

Clears old thinker and spatial ownership, then recreates every typed mobj in the validated thinker section.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_saveg.ml#L990)

<a id="function-function-p-unarchiveworld-function-p-unarchiveworld-src-p-saveg-ml-2067237545"></a>
### P_UnArchiveWorld

```ml
function P_UnArchiveWorld()
```

Restores mutable sector and sidedef fields in map-array order, validating stream availability before each assignment.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_saveg.ml#L731)

<a id="global-global-save-p-save-p-src-p-saveg-ml-65554135"></a>
### save_p

```ml
save_p
```

Tracks the mutable save p value used by the p saveg subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_saveg.ml#L41)

<a id="global-global-savebuffer-savebuffer-src-p-saveg-ml-1498919537"></a>
### savebuffer

```ml
savebuffer
```

Holds the optional savebuffer resource used by the p saveg subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_saveg.ml#L39)
