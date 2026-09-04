# `src/p_setup.ml`

[Home](README.md) · [Files](Files.md)

Decodes map lumps into runtime geometry, links sector topology, spawns things/specials, and prepares a playable level.

Package: [`(global)`](Package-global-1952375359.md)

Reachable from entry: **yes**

## Imports

- `d_player.ml` → [src/d_player.ml](File-src-d-player-ml-1944166105.md)
- `doomdata.ml` → [src/doomdata.ml](File-src-doomdata-ml-887192154.md)
- `doomdef.ml` → [src/doomdef.ml](File-src-doomdef-ml-460406769.md)
- `doomstat.ml` → [src/doomstat.ml](File-src-doomstat-ml-1652708088.md)
- `g_game.ml` → [src/g_game.ml](File-src-g-game-ml-257299317.md)
- `i_system.ml` → [src/i_system.ml](File-src-i-system-ml-1632920966.md)
- `info.ml` → [src/info.ml](File-src-info-ml-1415270573.md)
- `m_bbox.ml` → [src/m_bbox.ml](File-src-m-bbox-ml-1176525784.md)
- `m_fixed.ml` → [src/m_fixed.ml](File-src-m-fixed-ml-2129187227.md)
- `m_swap.ml` → [src/m_swap.ml](File-src-m-swap-ml-1401834276.md)
- `p_local.ml` → [src/p_local.ml](File-src-p-local-ml-1043095437.md)
- `p_mobj.ml` → [src/p_mobj.ml](File-src-p-mobj-ml-1335564114.md)
- `p_spec.ml` → [src/p_spec.ml](File-src-p-spec-ml-402508231.md)
- `p_switch.ml` → [src/p_switch.ml](File-src-p-switch-ml-925070734.md)
- `p_tick.ml` → [src/p_tick.ml](File-src-p-tick-ml-887781845.md)
- `r_data.ml` → [src/r_data.ml](File-src-r-data-ml-1686270288.md)
- `r_defs.ml` → [src/r_defs.ml](File-src-r-defs-ml-1187974936.md)
- `r_state.ml` → [src/r_state.ml](File-src-r-state-ml-691819649.md)
- `r_things.ml` → [src/r_things.ml](File-src-r-things-ml-545677447.md)
- `s_sound.ml` → [src/s_sound.ml](File-src-s-sound-ml-1485495390.md)
- `w_wad.ml` → [src/w_wad.ml](File-src-w-wad-ml-893006035.md)
- `z_zone.ml` → [src/z_zone.ml](File-src-z-zone-ml-1788911354.md)

## Declarations

<a id="function-function-ps-ensureruntimearrays-function-ps-ensureruntimearrays-src-p-setup-ml-1823432558"></a>
### _PS_EnsureRuntimeArrays

```ml
function _PS_EnsureRuntimeArrays()
```

Ensures player and spawn tables have canonical capacities and rewinds deathmatch-start insertion for the new level.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_setup.ml#L211)

<a id="function-function-ps-i16le-inline-function-ps-i16le-b-off-src-p-setup-ml-1902709660"></a>
### _PS_I16LE

```ml
inline function _PS_I16LE(b, off)
```

Decodes a two-byte map-lump field with signed 16-bit interpretation.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `b` | `dynamic` | — | Second input operand. |
| `off` | `dynamic` | — | Zero-based byte or element offset. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_setup.ml#L56)

<a id="function-function-ps-mapname-inline-function-ps-mapname-episode-map-src-p-setup-ml-248175738"></a>
### _PS_MapName

```ml
inline function _PS_MapName(episode, map)
```

Maps episode/map numbers to canonical ExMy or MAPnn lump names, with edition-appropriate first-map fallback.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `episode` | `dynamic` | — | Episode value supplied to `_PS_MapName`. |
| `map` | `dynamic` | — | Map value supplied to `_PS_MapName`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_setup.ml#L133)

<a id="function-function-ps-name8-inline-function-ps-name8-data-off-src-p-setup-ml-1187962102"></a>
### _PS_Name8

```ml
inline function _PS_Name8(data, off)
```

Extracts an eight-byte texture or flat name field from a map record without decoding it prematurely.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `data` | `dynamic` | — | Binary or structured data to process. |
| `off` | `dynamic` | — | Zero-based byte or element offset. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_setup.ml#L80)

<a id="function-function-ps-readlumpbytes-inline-function-ps-readlumpbytes-lump-src-p-setup-ml-145557809"></a>
### _PS_ReadLumpBytes

```ml
inline function _PS_ReadLumpBytes(lump)
```

Allocates an exact-size buffer and copies a map lump into it, returning an empty buffer for zero-length lumps.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `lump` | `dynamic` | — | Lump value supplied to `_PS_ReadLumpBytes`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_setup.ml#L66)

<a id="function-function-ps-u16le-inline-function-ps-u16le-b-off-src-p-setup-ml-27770148"></a>
### _PS_U16LE

```ml
inline function _PS_U16LE(b, off)
```

Decodes an unsigned 16-bit little-endian field from a map lump.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `b` | `dynamic` | — | Second input operand. |
| `off` | `dynamic` | — | Zero-based byte or element offset. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_setup.ml#L48)

<a id="function-function-ps-vertexorzero-inline-function-ps-vertexorzero-idx-src-p-setup-ml-871805350"></a>
### _PS_VertexOrZero

```ml
inline function _PS_VertexOrZero(idx)
```

Resolves a map vertex index and substitutes an origin vertex for malformed references.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `idx` | `dynamic` | — | Zero-based element or table index. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_setup.ml#L122)

<a id="function-function-pset-idiv-inline-function-pset-idiv-a-b-src-p-setup-ml-1125777514"></a>
### _PSET_IDiv

```ml
inline function _PSET_IDiv(a, b)
```

Returns a signed quotient truncated toward zero, or zero for invalid operands and a zero divisor in `_PSET_IDiv`

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `a` | `dynamic` | — | First input operand. |
| `b` | `dynamic` | — | Second input operand. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_setup.ml#L89)

<a id="function-function-pset-isseq-inline-function-pset-isseq-v-src-p-setup-ml-295772741"></a>
### _PSET_IsSeq

```ml
inline function _PSET_IsSeq(v)
```

Recognizes both array and list containers accepted by map geometry and runtime tables.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `v` | `dynamic` | — | Value consumed by the operation. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_setup.ml#L99)

<a id="function-function-pset-loadpulse-inline-function-pset-loadpulse-text-src-p-setup-ml-286314812"></a>
### _PSET_LoadPulse

```ml
inline function _PSET_LoadPulse(text)
```

Keeps the window responsive and updates loading UI during expensive level setup phases.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `text` | `dynamic` | — | Text to process. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_setup.ml#L107)

<a id="function-function-p-grouplines-function-p-grouplines-src-p-setup-ml-337393416"></a>
### P_GroupLines

```ml
function P_GroupLines()
```

Assigns subsector sectors and builds each sector's line list, fixed bounds, blockmap bounds, and centered sound origin.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_setup.ml#L625)

<a id="function-function-p-init-function-p-init-src-p-setup-ml-480363136"></a>
### P_Init

```ml
function P_Init()
```

Prepares switch pairs, animated flats/textures, and sprite definitions shared by all subsequently loaded levels.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_setup.ml#L726)

<a id="function-function-p-loadblockmap-function-p-loadblockmap-lump-src-p-setup-ml-1988813850"></a>
### P_LoadBlockMap

```ml
function P_LoadBlockMap(lump)
```

Decodes BLOCKMAP words, promotes its origin, normalizes cell offsets, and allocates empty per-cell thing chains.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `lump` | `dynamic` | — | Lump value supplied to `P_LoadBlockMap`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_setup.ml#L524)

<a id="function-function-p-loadlinedefs-function-p-loadlinedefs-lump-src-p-setup-ml-1163422658"></a>
### P_LoadLineDefs

```ml
function P_LoadLineDefs(lump)
```

Decodes LINEDEFS, resolves vertices and sectors, and precomputes direction, slope class, and bounding boxes.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `lump` | `dynamic` | — | Lump value supplied to `P_LoadLineDefs`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_setup.ml#L340)

<a id="function-function-p-loadnodes-function-p-loadnodes-lump-src-p-setup-ml-316950794"></a>
### P_LoadNodes

```ml
function P_LoadNodes(lump)
```

Decodes BSP partition origins, directions, child bounds, and node-or-subsector child identifiers.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `lump` | `dynamic` | — | Lump value supplied to `P_LoadNodes`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_setup.ml#L426)

<a id="function-function-p-loadsectors-function-p-loadsectors-lump-src-p-setup-ml-388173582"></a>
### P_LoadSectors

```ml
function P_LoadSectors(lump)
```

Decodes SECTORS records, resolves flat names, and initializes mutable sound, thing, line, and special ownership fields.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `lump` | `dynamic` | — | Lump value supplied to `P_LoadSectors`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_setup.ml#L264)

<a id="function-function-p-loadsegs-function-p-loadsegs-lump-src-p-setup-ml-1312730618"></a>
### P_LoadSegs

```ml
function P_LoadSegs(lump)
```

Decodes SEGS geometry and resolves its linedef, sidedef, front sector, and optional opposite sector links.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `lump` | `dynamic` | — | Lump value supplied to `P_LoadSegs`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_setup.ml#L468)

<a id="function-function-p-loadsidedefs-function-p-loadsidedefs-lump-src-p-setup-ml-673161662"></a>
### P_LoadSideDefs

```ml
function P_LoadSideDefs(lump)
```

Decodes SIDEDEFS offsets and texture names, then resolves each record's owning sector reference.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `lump` | `dynamic` | — | Lump value supplied to `P_LoadSideDefs`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_setup.ml#L309)

<a id="function-function-p-loadsubsectors-function-p-loadsubsectors-lump-src-p-setup-ml-2137060094"></a>
### P_LoadSubsectors

```ml
function P_LoadSubsectors(lump)
```

Decodes SSECTORS seg ranges while leaving sector ownership for the later line-grouping pass.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `lump` | `dynamic` | — | Lump value supplied to `P_LoadSubsectors`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_setup.ml#L406)

<a id="function-function-p-loadthings-function-p-loadthings-lump-src-p-setup-ml-1997992390"></a>
### P_LoadThings

```ml
function P_LoadThings(lump)
```

Decodes THINGS records and spawns edition-compatible map objects, stopping at unsupported commercial actors in noncommercial games.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `lump` | `dynamic` | — | Lump value supplied to `P_LoadThings`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_setup.ml#L585)

<a id="function-function-p-loadvertexes-function-p-loadvertexes-lump-src-p-setup-ml-285503282"></a>
### P_LoadVertexes

```ml
function P_LoadVertexes(lump)
```

Decodes four-byte VERTEXES records and promotes map-unit coordinates to fixed-point runtime vertices.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `lump` | `dynamic` | — | Lump value supplied to `P_LoadVertexes`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_setup.ml#L243)

<a id="function-function-p-setuplevel-function-p-setuplevel-episode-map-playermask-skill-src-p-setup-ml-743283847"></a>
### P_SetupLevel

```ml
function P_SetupLevel(episode, map, playermask, skill)
```

Tears down prior level state, loads map lumps in dependency order, links geometry, spawns actors/specials, precaches assets, and enters GS_LEVEL.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `episode` | `dynamic` | — | Episode value supplied to `P_SetupLevel`. |
| `map` | `dynamic` | — | Map value supplied to `P_SetupLevel`. |
| `playermask` | `dynamic` | — | Playermask value supplied to `P_SetupLevel`. |
| `skill` | `dynamic` | — | Skill value supplied to `P_SetupLevel`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_setup.ml#L740)
