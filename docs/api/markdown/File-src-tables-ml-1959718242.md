# `src/tables.ml`

[Home](README.md) · [Files](Files.md)

Provides precomputed lookup tables used by fixed-point math and rendering.

Package: [`(global)`](Package-global-1952375359.md)

Reachable from entry: **yes**

## Imports

- `m_fixed.ml` → [src/m_fixed.ml](File-src-m-fixed-ml-2129187227.md)
- `std/math.ml` → `../MiniLangCompilerOptimization/MiniLangCompilerPy/std/math.ml` — external dependency
- `tables.ml` → [src/tables.ml](File-src-tables-ml-1959718242.md)

## Declarations

<a id="function-function-tb-trunc-inline-function-tb-trunc-v-src-tables-ml-1670933924"></a>
### _TB_Trunc

```ml
inline function _TB_Trunc(v)
```

Truncates a numeric value toward zero for deterministic lookup-table generation.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `v` | `dynamic` | — | Value consumed by the operation. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/tables.ml#L96)

<a id="constant-constant-ang180-const-ang180-2147483648-src-tables-ml-1315214097"></a>
### ANG180

```ml
const ANG180 = 2147483648
```

Defines ang180 for the tables subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/tables.ml#L50)

<a id="constant-constant-ang270-const-ang270-3221225472-src-tables-ml-779489968"></a>
### ANG270

```ml
const ANG270 = 3221225472
```

Defines ang270 for the tables subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/tables.ml#L52)

<a id="constant-constant-ang45-const-ang45-536870912-src-tables-ml-803662253"></a>
### ANG45

```ml
const ANG45 = 536870912
```

Defines ang45 for the tables subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/tables.ml#L46)

<a id="constant-constant-ang90-const-ang90-1073741824-src-tables-ml-1707673159"></a>
### ANG90

```ml
const ANG90 = 1073741824
```

Defines ang90 for the tables subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/tables.ml#L48)

<a id="constant-constant-angletofineshift-const-angletofineshift-19-src-tables-ml-2023513560"></a>
### ANGLETOFINESHIFT

```ml
const ANGLETOFINESHIFT = 19
```

Defines angletofineshift for the tables subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/tables.ml#L33)

<a id="constant-constant-dbits-const-dbits-5-src-tables-ml-883455785"></a>
### DBITS

```ml
const DBITS = 5
```

Defines dbits for the tables subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/tables.ml#L59)

<a id="constant-constant-fineangles-const-fineangles-8192-src-tables-ml-1880486974"></a>
### FINEANGLES

```ml
const FINEANGLES = 8192
```

Defines fineangles for the tables subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/tables.ml#L28)

<a id="global-global-finecosine-finecosine-src-tables-ml-1893464187"></a>
### finecosine

```ml
finecosine
```

Holds the optional finecosine resource used by the tables subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/tables.ml#L38)

<a id="constant-constant-finemask-const-finemask-fineangles-1-src-tables-ml-1056129298"></a>
### FINEMASK

```ml
const FINEMASK = FINEANGLES - 1
```

Defines finemask for the tables subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/tables.ml#L30)

<a id="global-global-finesine-finesine-src-tables-ml-693397399"></a>
### finesine

```ml
finesine
```

Holds the optional finesine resource used by the tables subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/tables.ml#L36)

<a id="global-global-finetangent-finetangent-src-tables-ml-1661403949"></a>
### finetangent

```ml
finetangent
```

Holds the optional finetangent resource used by the tables subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/tables.ml#L40)

<a id="constant-constant-pi-const-pi-3-141592657-src-tables-ml-1778485115"></a>
### PI

```ml
const PI = 3.141592657
```

Defines pi for the tables subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/tables.ml#L25)

<a id="constant-constant-slopebits-const-slopebits-11-src-tables-ml-556183878"></a>
### SLOPEBITS

```ml
const SLOPEBITS = 11
```

Defines slopebits for the tables subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/tables.ml#L57)

<a id="function-function-slopediv-function-slopediv-num-den-src-tables-ml-1863100150"></a>
### SlopeDiv

```ml
function SlopeDiv(num, den)
```

Maps an unsigned rise/run ratio into Doom's bounded slope-table index without overflowing the numerator shift.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `num` | `dynamic` | — | Index identifying the requested item. |
| `den` | `dynamic` | — | Den value supplied to `SlopeDiv`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/tables.ml#L65)

<a id="constant-constant-sloperange-const-sloperange-2048-src-tables-ml-1032167536"></a>
### SLOPERANGE

```ml
const SLOPERANGE = 2048
```

Defines sloperange for the tables subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/tables.ml#L55)

<a id="function-function-tables-init-function-tables-init-src-tables-ml-1545735699"></a>
### Tables_Init

```ml
function Tables_Init()
```

Lazily generates the fixed-point sine, cosine, tangent, and slope-to-angle lookup tables at their canonical Doom sizes.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/tables.ml#L105)

<a id="global-global-tantoangle-tantoangle-src-tables-ml-1849036723"></a>
### tantoangle

```ml
tantoangle
```

Holds the optional tantoangle resource used by the tables subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/tables.ml#L43)
