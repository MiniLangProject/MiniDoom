# `src/doomdata.ml`

[Home](README.md) · [Files](Files.md)

Defines on-disk WAD map record layouts and lump-order constants used while decoding Doom levels.

Package: [`(global)`](Package-global-1952375359.md)

Reachable from entry: **yes**

## Imports

- `doomdef.ml` → [src/doomdef.ml](File-src-doomdef-ml-460406769.md)
- `doomtype.ml` → [src/doomtype.ml](File-src-doomtype-ml-372549946.md)

## Declarations

- [maplinedef_t](Type-maplinedef-t-92147873.md) — struct
- [mapnode_t](Type-mapnode-t-776550002.md) — struct
- [mapsector_t](Type-mapsector-t-400020624.md) — struct
- [mapseg_t](Type-mapseg-t-9593617.md) — struct
- [mapsidedef_t](Type-mapsidedef-t-723873530.md) — struct
- [mapsubsector_t](Type-mapsubsector-t-1290039280.md) — struct
- [mapthing_t](Type-mapthing-t-1823380664.md) — struct
- [mapvertex_t](Type-mapvertex-t-1657523728.md) — struct
<a id="constant-constant-ml-blocking-const-ml-blocking-1-src-doomdata-ml-518959405"></a>
### ML_BLOCKING

```ml
const ML_BLOCKING = 1
```

Defines ml blocking for the doomdata subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/doomdata.ml#L87)

<a id="constant-constant-ml-blockmap-const-ml-blockmap-10-src-doomdata-ml-1691717901"></a>
### ML_BLOCKMAP

```ml
const ML_BLOCKMAP = 10
```

Defines ml blockmap for the doomdata subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/doomdata.ml#L44)

<a id="constant-constant-ml-blockmonsters-const-ml-blockmonsters-2-src-doomdata-ml-1763440438"></a>
### ML_BLOCKMONSTERS

```ml
const ML_BLOCKMONSTERS = 2
```

Defines ml blockmonsters for the doomdata subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/doomdata.ml#L89)

<a id="constant-constant-ml-dontdraw-const-ml-dontdraw-128-src-doomdata-ml-1044936223"></a>
### ML_DONTDRAW

```ml
const ML_DONTDRAW = 128
```

Defines ml dontdraw for the doomdata subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/doomdata.ml#L101)

<a id="constant-constant-ml-dontpegbottom-const-ml-dontpegbottom-16-src-doomdata-ml-124234293"></a>
### ML_DONTPEGBOTTOM

```ml
const ML_DONTPEGBOTTOM = 16
```

Defines ml dontpegbottom for the doomdata subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/doomdata.ml#L95)

<a id="constant-constant-ml-dontpegtop-const-ml-dontpegtop-8-src-doomdata-ml-663918042"></a>
### ML_DONTPEGTOP

```ml
const ML_DONTPEGTOP = 8
```

Defines ml dontpegtop for the doomdata subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/doomdata.ml#L93)

<a id="constant-constant-ml-label-const-ml-label-0-src-doomdata-ml-1893722076"></a>
### ML_LABEL

```ml
const ML_LABEL = 0
```

Defines ml label for the doomdata subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/doomdata.ml#L24)

<a id="constant-constant-ml-linedefs-const-ml-linedefs-2-src-doomdata-ml-1144996424"></a>
### ML_LINEDEFS

```ml
const ML_LINEDEFS = 2
```

Defines ml linedefs for the doomdata subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/doomdata.ml#L28)

<a id="constant-constant-ml-mapped-const-ml-mapped-256-src-doomdata-ml-1626283267"></a>
### ML_MAPPED

```ml
const ML_MAPPED = 256
```

Defines ml mapped for the doomdata subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/doomdata.ml#L103)

<a id="constant-constant-ml-nodes-const-ml-nodes-7-src-doomdata-ml-1257489259"></a>
### ML_NODES

```ml
const ML_NODES = 7
```

Defines ml nodes for the doomdata subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/doomdata.ml#L38)

<a id="constant-constant-ml-reject-const-ml-reject-9-src-doomdata-ml-756722781"></a>
### ML_REJECT

```ml
const ML_REJECT = 9
```

Defines ml reject for the doomdata subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/doomdata.ml#L42)

<a id="constant-constant-ml-secret-const-ml-secret-32-src-doomdata-ml-460173445"></a>
### ML_SECRET

```ml
const ML_SECRET = 32
```

Defines ml secret for the doomdata subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/doomdata.ml#L97)

<a id="constant-constant-ml-sectors-const-ml-sectors-8-src-doomdata-ml-1563070630"></a>
### ML_SECTORS

```ml
const ML_SECTORS = 8
```

Defines ml sectors for the doomdata subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/doomdata.ml#L40)

<a id="constant-constant-ml-segs-const-ml-segs-5-src-doomdata-ml-601595637"></a>
### ML_SEGS

```ml
const ML_SEGS = 5
```

Defines ml segs for the doomdata subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/doomdata.ml#L34)

<a id="constant-constant-ml-sidedefs-const-ml-sidedefs-3-src-doomdata-ml-852478231"></a>
### ML_SIDEDEFS

```ml
const ML_SIDEDEFS = 3
```

Defines ml sidedefs for the doomdata subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/doomdata.ml#L30)

<a id="constant-constant-ml-soundblock-const-ml-soundblock-64-src-doomdata-ml-1926405530"></a>
### ML_SOUNDBLOCK

```ml
const ML_SOUNDBLOCK = 64
```

Defines ml soundblock for the doomdata subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/doomdata.ml#L99)

<a id="constant-constant-ml-ssectors-const-ml-ssectors-6-src-doomdata-ml-279608892"></a>
### ML_SSECTORS

```ml
const ML_SSECTORS = 6
```

Defines ml ssectors for the doomdata subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/doomdata.ml#L36)

<a id="constant-constant-ml-things-const-ml-things-1-src-doomdata-ml-1424780789"></a>
### ML_THINGS

```ml
const ML_THINGS = 1
```

Defines ml things for the doomdata subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/doomdata.ml#L26)

<a id="constant-constant-ml-twosided-const-ml-twosided-4-src-doomdata-ml-1041283246"></a>
### ML_TWOSIDED

```ml
const ML_TWOSIDED = 4
```

Defines ml twosided for the doomdata subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/doomdata.ml#L91)

<a id="constant-constant-ml-vertexes-const-ml-vertexes-4-src-doomdata-ml-1004135634"></a>
### ML_VERTEXES

```ml
const ML_VERTEXES = 4
```

Defines ml vertexes for the doomdata subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/doomdata.ml#L32)

<a id="constant-constant-nf-subsector-const-nf-subsector-32768-src-doomdata-ml-1923141270"></a>
### NF_SUBSECTOR

```ml
const NF_SUBSECTOR = 32768
```

Defines nf subsector for the doomdata subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/doomdata.ml#L148)
