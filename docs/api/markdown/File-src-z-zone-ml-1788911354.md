# `src/z_zone.ml`

[Home](README.md) · [Files](Files.md)

Implements zone-style memory tagging and allocation lifecycle helpers.

Package: [`(global)`](Package-global-1952375359.md)

Reachable from entry: **yes**

## Imports

- `doomdef.ml` → [src/doomdef.ml](File-src-doomdef-ml-460406769.md)
- `i_system.ml` → [src/i_system.ml](File-src-i-system-ml-1632920966.md)

## Declarations

<a id="function-function-z-align4-inline-function-z-align4-n-src-z-zone-ml-17595920"></a>
### _Z_Align4

```ml
inline function _Z_Align4(n)
```

Rounds an allocation size upward to the allocator's four-byte boundary.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `n` | `dynamic` | — | Number of values to process. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/z_zone.ml#L136)

<a id="function-function-z-assignuser-inline-function-z-assignuser-user-ptr-src-z-zone-ml-1340041787"></a>
### _Z_AssignUser

```ml
inline function _Z_AssignUser(user, ptr)
```

Writes an allocated payload offset through Doom's single-element owner-reference convention.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `user` | `dynamic` | — | User value supplied to `_Z_AssignUser`. |
| `ptr` | `dynamic` | — | Ptr value supplied to `_Z_AssignUser`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/z_zone.ml#L206)

<a id="global-global-z-blocklist-z-blocklist-src-z-zone-ml-1081087171"></a>
### _Z_blocklist

```ml
_Z_blocklist
```

Tracks the mutable z blocklist value used by the z zone subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/z_zone.ml#L84)

<a id="global-global-z-blocks-z-blocks-src-z-zone-ml-303259321"></a>
### _Z_blocks

```ml
_Z_blocks
```

Holds the optional z blocks resource used by the z zone subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/z_zone.ml#L81)

<a id="global-global-z-buf-z-buf-src-z-zone-ml-1769503775"></a>
### _Z_buf

```ml
_Z_buf
```

Holds the optional z buf resource used by the z zone subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/z_zone.ml#L74)

<a id="function-function-z-findblockbyptr-inline-function-z-findblockbyptr-ptr-src-z-zone-ml-2048263456"></a>
### _Z_FindBlockByPtr

```ml
inline function _Z_FindBlockByPtr(ptr)
```

Finds the allocated block whose payload begins at a zone-buffer offset, returning the sentinel index when absent.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `ptr` | `dynamic` | — | Ptr value supplied to `_Z_FindBlockByPtr`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/z_zone.ml#L189)

<a id="function-function-z-get-inline-function-z-get-i-src-z-zone-ml-1213111117"></a>
### _Z_Get

```ml
inline function _Z_Get(i)
```

Lazily initializes the zone and safely resolves an internal block-table index.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `i` | `dynamic` | — | Zero-based iteration index. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/z_zone.ml#L92)

<a id="constant-constant-z-hdr-const-z-hdr-0-src-z-zone-ml-566952524"></a>
### _Z_HDR

```ml
const _Z_HDR = 0
```

Defines z hdr for the z zone subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/z_zone.ml#L70)

<a id="function-function-z-isfree-inline-function-z-isfree-i-src-z-zone-ml-2050730483"></a>
### _Z_IsFree

```ml
inline function _Z_IsFree(i)
```

Treats a block as free exactly when it has no owner marker.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `i` | `dynamic` | — | Zero-based iteration index. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/z_zone.ml#L115)

<a id="function-function-z-linkafter-inline-function-z-linkafter-aidx-bidx-src-z-zone-ml-583217041"></a>
### _Z_LinkAfter

```ml
inline function _Z_LinkAfter(aIdx, bIdx)
```

Inserts one block after another and updates all four neighboring list links atomically.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `aIdx` | `dynamic` | — | A idx value supplied to `_Z_LinkAfter`. |
| `bIdx` | `dynamic` | — | B idx value supplied to `_Z_LinkAfter`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/z_zone.ml#L144)

<a id="function-function-z-newblock-inline-function-z-newblock-start-size-user-tag-id-next-prev-src-z-zone-ml-160527891"></a>
### _Z_NewBlock

```ml
inline function _Z_NewBlock(start, size, user, tag, id, next, prev)
```

Constructs a block descriptor without linking it into the zone list.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `start` | `dynamic` | — | Start value supplied to `_Z_NewBlock`. |
| `size` | `dynamic` | — | Requested size in bytes or elements. |
| `user` | `dynamic` | — | User value supplied to `_Z_NewBlock`. |
| `tag` | `dynamic` | — | Zone-memory or resource-lifetime tag. |
| `id` | `dynamic` | — | Id value supplied to `_Z_NewBlock`. |
| `next` | `dynamic` | — | Next value supplied to `_Z_NewBlock`. |
| `prev` | `dynamic` | — | Prev value supplied to `_Z_NewBlock`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/z_zone.ml#L129)

<a id="constant-constant-z-null-owner-ptr-const-z-null-owner-ptr-1-src-z-zone-ml-914196322"></a>
### _Z_NULL_OWNER_PTR

```ml
const _Z_NULL_OWNER_PTR = -1
```

Defines z null owner ptr for the z zone subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/z_zone.ml#L66)

<a id="global-global-z-rover-z-rover-src-z-zone-ml-864334273"></a>
### _Z_rover

```ml
_Z_rover
```

Tracks the mutable z rover value used by the z zone subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/z_zone.ml#L87)

<a id="function-function-z-set-inline-function-z-set-i-b-src-z-zone-ml-883917049"></a>
### _Z_Set

```ml
inline function _Z_Set(i, b)
```

Updates a zone allocation block in the zone memory table.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `i` | `dynamic` | — | Zero-based iteration index. |
| `b` | `dynamic` | — | Second input operand. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/z_zone.ml#L105)

<a id="global-global-z-size-z-size-src-z-zone-ml-1864750961"></a>
### _Z_size

```ml
_Z_size
```

Tracks the mutable z size value used by the z zone subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/z_zone.ml#L77)

<a id="function-function-z-unlink-inline-function-z-unlink-i-src-z-zone-ml-133492951"></a>
### _Z_Unlink

```ml
inline function _Z_Unlink(i)
```

Removes a block descriptor from the doubly linked address list and clears its own links.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `i` | `dynamic` | — | Zero-based iteration index. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/z_zone.ml#L166)

- [memblock_t](Type-memblock-t-1554137736.md) — struct
<a id="constant-constant-minfragment-const-minfragment-64-src-z-zone-ml-1222370998"></a>
### MINFRAGMENT

```ml
const MINFRAGMENT = 64
```

Defines the minimum minfragment accepted by the z zone subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/z_zone.ml#L63)

<a id="constant-constant-pu-cache-const-pu-cache-101-src-z-zone-ml-1136531244"></a>
### PU_CACHE

```ml
const PU_CACHE = 101
```

Defines pu cache for the z zone subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/z_zone.ml#L39)

<a id="constant-constant-pu-dave-const-pu-dave-4-src-z-zone-ml-462870554"></a>
### PU_DAVE

```ml
const PU_DAVE = 4
```

Defines pu dave for the z zone subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/z_zone.ml#L30)

<a id="constant-constant-pu-level-const-pu-level-50-src-z-zone-ml-745391271"></a>
### PU_LEVEL

```ml
const PU_LEVEL = 50
```

Defines pu level for the z zone subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/z_zone.ml#L32)

<a id="constant-constant-pu-levspec-const-pu-levspec-51-src-z-zone-ml-1621673528"></a>
### PU_LEVSPEC

```ml
const PU_LEVSPEC = 51
```

Defines pu levspec for the z zone subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/z_zone.ml#L34)

<a id="constant-constant-pu-music-const-pu-music-3-src-z-zone-ml-1955858675"></a>
### PU_MUSIC

```ml
const PU_MUSIC = 3
```

Defines pu music for the z zone subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/z_zone.ml#L28)

<a id="constant-constant-pu-purgelevel-const-pu-purgelevel-100-src-z-zone-ml-1046269133"></a>
### PU_PURGELEVEL

```ml
const PU_PURGELEVEL = 100
```

Defines pu purgelevel for the z zone subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/z_zone.ml#L37)

<a id="constant-constant-pu-sound-const-pu-sound-2-src-z-zone-ml-1068252096"></a>
### PU_SOUND

```ml
const PU_SOUND = 2
```

Defines pu sound for the z zone subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/z_zone.ml#L26)

<a id="constant-constant-pu-static-const-pu-static-1-src-z-zone-ml-1791442893"></a>
### PU_STATIC

```ml
const PU_STATIC = 1
```

Defines pu static for the z zone subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/z_zone.ml#L24)

<a id="function-function-z-bytesat-function-z-bytesat-ptr-length-src-z-zone-ml-862921553"></a>
### Z_BytesAt

```ml
function Z_BytesAt(ptr, length)
```

Returns a byte slice copied from an absolute zone-buffer range.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `ptr` | `dynamic` | — | Ptr value supplied to `Z_BytesAt`. |
| `length` | `dynamic` | — | Number of bytes or elements in the associated value. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/z_zone.ml#L578)

<a id="function-function-z-changetag-function-z-changetag-ptr-tag-src-z-zone-ml-2008670863"></a>
### Z_ChangeTag

```ml
function Z_ChangeTag(ptr, tag)
```

Exposes the validated retagging operation under the original zone API name.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `ptr` | `dynamic` | — | Ptr value supplied to `Z_ChangeTag`. |
| `tag` | `dynamic` | — | Zone-memory or resource-lifetime tag. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/z_zone.ml#L516)

<a id="function-function-z-changetag2-function-z-changetag2-ptr-tag-src-z-zone-ml-1574777485"></a>
### Z_ChangeTag2

```ml
function Z_ChangeTag2(ptr, tag)
```

Retags a validated allocation while forbidding purgeable tags on blocks without an owner reference.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `ptr` | `dynamic` | — | Ptr value supplied to `Z_ChangeTag2`. |
| `tag` | `dynamic` | — | Zone-memory or resource-lifetime tag. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/z_zone.ml#L490)

<a id="function-function-z-checkheap-function-z-checkheap-src-z-zone-ml-1543129093"></a>
### Z_CheckHeap

```ml
function Z_CheckHeap()
```

Verifies bidirectional links, contiguous address coverage, absence of adjacent free blocks, and the final zone extent.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/z_zone.ml#L451)

<a id="function-function-z-clearzone-function-z-clearzone-zone-src-z-zone-ml-343254549"></a>
### Z_ClearZone

```ml
function Z_ClearZone(zone)
```

Replaces all allocator metadata with a sentinel and one free block covering the complete zone buffer.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `zone` | `dynamic` | — | Zone value supplied to `Z_ClearZone`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/z_zone.ml#L215)

<a id="function-function-z-dumpheap-function-z-dumpheap-lowtag-hightag-src-z-zone-ml-1396088823"></a>
### Z_DumpHeap

```ml
function Z_DumpHeap(lowtag, hightag)
```

Prints allocator size and metadata for blocks in a selected tag range for diagnostics.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `lowtag` | `dynamic` | — | Lowtag value supplied to `Z_DumpHeap`. |
| `hightag` | `dynamic` | — | Hightag value supplied to `Z_DumpHeap`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/z_zone.ml#L427)

<a id="function-function-z-filedumpheap-function-z-filedumpheap-f-src-z-zone-ml-1501817411"></a>
### Z_FileDumpHeap

```ml
function Z_FileDumpHeap(f)
```

Preserves the legacy file-dump entry point by emitting the complete heap through the active diagnostic output.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `f` | `dynamic` | — | F value supplied to `Z_FileDumpHeap`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/z_zone.ml#L444)

<a id="function-function-z-free-function-z-free-ptr-src-z-zone-ml-369724887"></a>
### Z_Free

```ml
function Z_Free(ptr)
```

Validates and releases an allocation, invalidates its owner reference, and coalesces adjacent free blocks while repairing the rover.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `ptr` | `dynamic` | — | Ptr value supplied to `Z_Free`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/z_zone.ml#L256)

<a id="function-function-z-freememory-function-z-freememory-src-z-zone-ml-874771983"></a>
### Z_FreeMemory

```ml
function Z_FreeMemory()
```

Totals immediately free and purgeable bytes to estimate memory available for a future allocation.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/z_zone.ml#L521)

<a id="function-function-z-freetags-function-z-freetags-lowtag-hightag-src-z-zone-ml-1403564475"></a>
### Z_FreeTags

```ml
function Z_FreeTags(lowtag, hightag)
```

Frees every allocated block whose purge tag lies in the inclusive requested range while preserving traversal across coalescing.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `lowtag` | `dynamic` | — | Lowtag value supplied to `Z_FreeTags`. |
| `hightag` | `dynamic` | — | Hightag value supplied to `Z_FreeTags`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/z_zone.ml#L400)

<a id="function-function-z-getzonebuffer-function-z-getzonebuffer-src-z-zone-ml-732731997"></a>
### Z_GetZoneBuffer

```ml
function Z_GetZoneBuffer()
```

Returns the backing byte buffer addressed by all zone payload offsets.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/z_zone.ml#L535)

<a id="function-function-z-init-function-z-init-src-z-zone-ml-1369944715"></a>
### Z_Init

```ml
function Z_Init()
```

Obtains the platform zone buffer and initializes allocator metadata over its reported capacity.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/z_zone.ml#L240)

<a id="function-function-z-malloc-function-z-malloc-size-tag-user-src-z-zone-ml-1609689549"></a>
### Z_Malloc

```ml
function Z_Malloc(size, tag, user)
```

Performs rover-based first-fit allocation, purges eligible tagged blocks, splits large remainders, and enforces owners for purgeable memory.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `size` | `dynamic` | — | Requested size in bytes or elements. |
| `tag` | `dynamic` | — | Zone-memory or resource-lifetime tag. |
| `user` | `dynamic` | — | User value supplied to `Z_Malloc`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/z_zone.ml#L313)

<a id="function-function-z-peekbyte-function-z-peekbyte-ptr-src-z-zone-ml-366875643"></a>
### Z_PeekByte

```ml
function Z_PeekByte(ptr)
```

Reads one byte at an absolute zone-buffer offset.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `ptr` | `dynamic` | — | Ptr value supplied to `Z_PeekByte`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/z_zone.ml#L541)

<a id="function-function-z-pokebyte-function-z-pokebyte-ptr-v-src-z-zone-ml-2027031891"></a>
### Z_PokeByte

```ml
function Z_PokeByte(ptr, v)
```

Writes the low eight bits of a value at an absolute zone-buffer offset.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `ptr` | `dynamic` | — | Ptr value supplied to `Z_PokeByte`. |
| `v` | `dynamic` | — | Value consumed by the operation. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/z_zone.ml#L548)

<a id="function-function-z-pokebytes-function-z-pokebytes-dstptr-srcbytes-srcoff-length-src-z-zone-ml-655049782"></a>
### Z_PokeBytes

```ml
function Z_PokeBytes(dstPtr, srcBytes, srcOff, length)
```

Copies a validated source byte range into the zone buffer at an absolute payload offset.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `dstPtr` | `dynamic` | — | Dst ptr value supplied to `Z_PokeBytes`. |
| `srcBytes` | `dynamic` | — | Src bytes value supplied to `Z_PokeBytes`. |
| `srcOff` | `dynamic` | — | Src off value supplied to `Z_PokeBytes`. |
| `length` | `dynamic` | — | Number of bytes or elements in the associated value. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/z_zone.ml#L557)

<a id="constant-constant-zoneid-const-zoneid-1919505-src-z-zone-ml-602983038"></a>
### ZONEID

```ml
const ZONEID = 1919505
```

Defines zoneid for the z zone subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/z_zone.ml#L61)
