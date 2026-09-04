# `src/r_sky.ml`

[Home](README.md) · [Files](Files.md)

Resolves the level sky flat and texture identifiers plus the vertical mapping origin used by sky columns.

Package: [`(global)`](Package-global-1952375359.md)

Reachable from entry: **yes**

## Imports

- `m_fixed.ml` → [src/m_fixed.ml](File-src-m-fixed-ml-2129187227.md)
- `r_data.ml` → [src/r_data.ml](File-src-r-data-ml-1686270288.md)

## Declarations

<a id="constant-constant-angletoskyshift-const-angletoskyshift-22-src-r-sky-ml-420106207"></a>
### ANGLETOSKYSHIFT

```ml
const ANGLETOSKYSHIFT = 22
```

Defines angletoskyshift for the r sky subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_sky.ml#L24)

<a id="function-function-r-initskymap-function-r-initskymap-src-r-sky-ml-1095954206"></a>
### R_InitSkyMap

```ml
function R_InitSkyMap()
```

Resolves the sky flat and SKY1 texture indices and places the sky cylinder at the vanilla vertical midpoint.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_sky.ml#L36)

<a id="constant-constant-skyflatname-const-skyflatname-f-sky1-src-r-sky-ml-1343868616"></a>
### SKYFLATNAME

```ml
const SKYFLATNAME = "F_SKY1"
```

Defines the skyflatname text used by the r sky subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_sky.ml#L22)

<a id="global-global-skyflatnum-skyflatnum-src-r-sky-ml-610312648"></a>
### skyflatnum

```ml
skyflatnum
```

Tracks the mutable skyflatnum value used by the r sky subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_sky.ml#L29)

<a id="global-global-skytexture-skytexture-src-r-sky-ml-1915854272"></a>
### skytexture

```ml
skytexture
```

Tracks the mutable skytexture value used by the r sky subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_sky.ml#L31)

<a id="global-global-skytexturemid-skytexturemid-src-r-sky-ml-1312059992"></a>
### skytexturemid

```ml
skytexturemid
```

Tracks the mutable skytexturemid value used by the r sky subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_sky.ml#L33)
