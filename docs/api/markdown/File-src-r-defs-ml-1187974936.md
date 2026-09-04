# `src/r_defs.ml`

[Home](README.md) · [Files](Files.md)

Defines map/render geometry records and decodes Doom patch headers consumed by software rasterization.

Package: [`(global)`](Package-global-1952375359.md)

Reachable from entry: **yes**

## Imports

- `d_think.ml` → [src/d_think.ml](File-src-d-think-ml-737524740.md)
- `doomdef.ml` → [src/doomdef.ml](File-src-doomdef-ml-460406769.md)
- `m_fixed.ml` → [src/m_fixed.ml](File-src-m-fixed-ml-2129187227.md)
- `p_mobj.ml` → [src/p_mobj.ml](File-src-p-mobj-ml-1335564114.md)

## Declarations

- [degenmobj_t](Type-degenmobj-t-1051705399.md) — struct
- [drawseg_t](Type-drawseg-t-1478639923.md) — struct
- [line_t](Type-line-t-1652617108.md) — struct
<a id="constant-constant-maxdrawsegs-const-maxdrawsegs-256-src-r-defs-ml-1767096109"></a>
### MAXDRAWSEGS

```ml
const MAXDRAWSEGS = 256
```

Defines the maximum maxdrawsegs accepted by the r defs subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_defs.ml#L35)

- [node_t](Type-node-t-474000198.md) — struct
<a id="function-function-patch-columnoffset-inline-function-patch-columnoffset-patchbytes-colindex-src-r-defs-ml-976267147"></a>
### Patch_ColumnOffset

```ml
inline function Patch_ColumnOffset(patchBytes, colIndex)
```

Decodes the file-relative byte offset of one column stream from a Doom patch directory.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `patchBytes` | `dynamic` | — | Patch bytes value supplied to `Patch_ColumnOffset`. |
| `colIndex` | `dynamic` | — | Index identifying col. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_defs.ml#L96)

<a id="function-function-patch-height-function-patch-height-patchbytes-src-r-defs-ml-1030383874"></a>
### Patch_Height

```ml
function Patch_Height(patchBytes)
```

Returns the signed pixel height stored in a Doom patch header.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `patchBytes` | `dynamic` | — | Patch bytes value supplied to `Patch_Height`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_defs.ml#L77)

<a id="function-function-patch-leftoffset-inline-function-patch-leftoffset-patchbytes-src-r-defs-ml-1868314291"></a>
### Patch_LeftOffset

```ml
inline function Patch_LeftOffset(patchBytes)
```

Returns the signed horizontal origin offset used to place a Doom patch.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `patchBytes` | `dynamic` | — | Patch bytes value supplied to `Patch_LeftOffset`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_defs.ml#L83)

- [patch_t](Type-patch-t-1522116610.md) — struct
<a id="function-function-patch-topoffset-inline-function-patch-topoffset-patchbytes-src-r-defs-ml-1638680039"></a>
### Patch_TopOffset

```ml
inline function Patch_TopOffset(patchBytes)
```

Returns the signed vertical origin offset used to place a Doom patch.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `patchBytes` | `dynamic` | — | Patch bytes value supplied to `Patch_TopOffset`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_defs.ml#L89)

<a id="function-function-patch-width-function-patch-width-patchbytes-src-r-defs-ml-890337776"></a>
### Patch_Width

```ml
function Patch_Width(patchBytes)
```

Returns the signed pixel width stored at the start of a Doom patch header.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `patchBytes` | `dynamic` | — | Patch bytes value supplied to `Patch_Width`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_defs.ml#L71)

- [post_t](Type-post-t-361033972.md) — struct
<a id="function-function-rdefs-i16le-inline-function-rdefs-i16le-b-off-src-r-defs-ml-1531618801"></a>
### RDefs_I16LE

```ml
inline function RDefs_I16LE(b, off)
```

Decodes a two-byte little-endian field with signed 16-bit interpretation.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `b` | `dynamic` | — | Second input operand. |
| `off` | `dynamic` | — | Zero-based byte or element offset. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_defs.ml#L47)

<a id="function-function-rdefs-i32le-inline-function-rdefs-i32le-b-off-src-r-defs-ml-1822406009"></a>
### RDefs_I32LE

```ml
inline function RDefs_I32LE(b, off)
```

Decodes a four-byte little-endian field with signed 32-bit interpretation.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `b` | `dynamic` | — | Second input operand. |
| `off` | `dynamic` | — | Zero-based byte or element offset. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_defs.ml#L63)

<a id="function-function-rdefs-u16le-inline-function-rdefs-u16le-b-off-src-r-defs-ml-224073225"></a>
### RDefs_U16LE

```ml
inline function RDefs_U16LE(b, off)
```

Decodes an unsigned 16-bit little-endian field from renderer resource bytes.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `b` | `dynamic` | — | Second input operand. |
| `off` | `dynamic` | — | Zero-based byte or element offset. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_defs.ml#L40)

<a id="function-function-rdefs-u32le-inline-function-rdefs-u32le-b-off-src-r-defs-ml-346134009"></a>
### RDefs_U32LE

```ml
inline function RDefs_U32LE(b, off)
```

Decodes an unsigned 32-bit little-endian field from renderer resource bytes.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `b` | `dynamic` | — | Second input operand. |
| `off` | `dynamic` | — | Zero-based byte or element offset. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_defs.ml#L56)

- [sector_t](Type-sector-t-1630188620.md) — struct
- [seg_t](Type-seg-t-359360477.md) — struct
- [side_t](Type-side-t-1111461029.md) — struct
<a id="constant-constant-sil-both-const-sil-both-3-src-r-defs-ml-904334599"></a>
### SIL_BOTH

```ml
const SIL_BOTH = 3
```

Defines sil both for the r defs subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_defs.ml#L32)

<a id="constant-constant-sil-bottom-const-sil-bottom-1-src-r-defs-ml-204700041"></a>
### SIL_BOTTOM

```ml
const SIL_BOTTOM = 1
```

Defines sil bottom for the r defs subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_defs.ml#L28)

<a id="constant-constant-sil-none-const-sil-none-0-src-r-defs-ml-299126624"></a>
### SIL_NONE

```ml
const SIL_NONE = 0
```

Defines sil none for the r defs subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_defs.ml#L26)

<a id="constant-constant-sil-top-const-sil-top-2-src-r-defs-ml-2030488942"></a>
### SIL_TOP

```ml
const SIL_TOP = 2
```

Defines sil top for the r defs subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_defs.ml#L30)

- [slopetype_t](Type-slopetype-t-494524059.md) — enum
- [spritedef_t](Type-spritedef-t-775201312.md) — struct
- [spriteframe_t](Type-spriteframe-t-1693783794.md) — struct
- [subsector_t](Type-subsector-t-331044028.md) — struct
- [vertex_t](Type-vertex-t-1773231380.md) — struct
- [visplane_t](Type-visplane-t-2051513410.md) — struct
- [vissprite_t](Type-vissprite-t-1997916523.md) — struct
