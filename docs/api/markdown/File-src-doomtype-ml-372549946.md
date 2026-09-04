# `src/doomtype.ml`

[Home](README.md) · [Files](Files.md)

Defines primitive numeric limits, byte masks, booleans, and legacy aliases used by translated Doom code.

Package: [`(global)`](Package-global-1952375359.md)

Reachable from entry: **yes**

## Declarations

<a id="function-function-asbyte-inline-function-asbyte-x-src-doomtype-ml-1417310256"></a>
### asByte

```ml
inline function asByte(x)
```

Converts byte values for the engine.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `x` | `dynamic` | — | Horizontal map- or screen-space coordinate. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/doomtype.ml#L46)

<a id="constant-constant-byte-mask-const-byte-mask-255-src-doomtype-ml-324532766"></a>
### BYTE_MASK

```ml
const BYTE_MASK = 255
```

Defines byte mask for the doomtype subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/doomtype.ml#L24)

<a id="constant-constant-byte-max-const-byte-max-255-src-doomtype-ml-1148736470"></a>
### BYTE_MAX

```ml
const BYTE_MAX = 255
```

Defines the maximum byte max accepted by the doomtype subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/doomtype.ml#L22)

<a id="constant-constant-maxchar-const-maxchar-127-src-doomtype-ml-1771660550"></a>
### MAXCHAR

```ml
const MAXCHAR = 127
```

Defines the maximum maxchar accepted by the doomtype subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/doomtype.ml#L27)

<a id="constant-constant-maxint-const-maxint-2147483647-src-doomtype-ml-738769668"></a>
### MAXINT

```ml
const MAXINT = 2147483647
```

Defines the maximum maxint accepted by the doomtype subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/doomtype.ml#L31)

<a id="constant-constant-maxlong-const-maxlong-2147483647-src-doomtype-ml-1930986964"></a>
### MAXLONG

```ml
const MAXLONG = 2147483647
```

Defines the maximum maxlong accepted by the doomtype subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/doomtype.ml#L33)

<a id="constant-constant-maxshort-const-maxshort-32767-src-doomtype-ml-1974848901"></a>
### MAXSHORT

```ml
const MAXSHORT = 32767
```

Defines the maximum maxshort accepted by the doomtype subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/doomtype.ml#L29)

<a id="constant-constant-minchar-const-minchar-128-src-doomtype-ml-375326043"></a>
### MINCHAR

```ml
const MINCHAR = 128
```

Defines the minimum minchar accepted by the doomtype subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/doomtype.ml#L36)

<a id="constant-constant-minint-const-minint-2147483648-src-doomtype-ml-1306124709"></a>
### MININT

```ml
const MININT = 2147483648
```

Defines the minimum minint accepted by the doomtype subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/doomtype.ml#L40)

<a id="constant-constant-minlong-const-minlong-2147483648-src-doomtype-ml-685146269"></a>
### MINLONG

```ml
const MINLONG = 2147483648
```

Defines the minimum minlong accepted by the doomtype subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/doomtype.ml#L42)

<a id="constant-constant-minshort-const-minshort-32768-src-doomtype-ml-1415988780"></a>
### MINSHORT

```ml
const MINSHORT = 32768
```

Defines the minimum minshort accepted by the doomtype subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/doomtype.ml#L38)
