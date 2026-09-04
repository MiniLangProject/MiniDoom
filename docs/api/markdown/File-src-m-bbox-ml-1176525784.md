# `src/m_bbox.ml`

[Home](README.md) · [Files](Files.md)

Maintains fixed-point top, bottom, left, and right bounds for renderer and map geometry.

Package: [`(global)`](Package-global-1952375359.md)

Reachable from entry: **yes**

## Imports

- `m_bbox.ml` → [src/m_bbox.ml](File-src-m-bbox-ml-1176525784.md)
- `m_fixed.ml` → [src/m_fixed.ml](File-src-m-fixed-ml-2129187227.md)

## Declarations

<a id="constant-constant-bbox-maxint-const-bbox-maxint-2147483647-src-m-bbox-ml-804507582"></a>
### BBOX_MAXINT

```ml
const BBOX_MAXINT = 2147483647
```

Defines the maximum bbox maxint accepted by the m bbox subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/m_bbox.ml#L26)

<a id="constant-constant-bbox-minint-const-bbox-minint-2147483648-src-m-bbox-ml-1432827914"></a>
### BBOX_MININT

```ml
const BBOX_MININT = -2147483648
```

Defines the minimum bbox minint accepted by the m bbox subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/m_bbox.ml#L24)

<a id="constant-constant-boxbottom-const-boxbottom-1-src-m-bbox-ml-1614220683"></a>
### BOXBOTTOM

```ml
const BOXBOTTOM = 1
```

Defines boxbottom for the m bbox subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/m_bbox.ml#L31)

<a id="constant-constant-boxleft-const-boxleft-2-src-m-bbox-ml-687395662"></a>
### BOXLEFT

```ml
const BOXLEFT = 2
```

Defines boxleft for the m bbox subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/m_bbox.ml#L33)

<a id="constant-constant-boxright-const-boxright-3-src-m-bbox-ml-942186961"></a>
### BOXRIGHT

```ml
const BOXRIGHT = 3
```

Defines boxright for the m bbox subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/m_bbox.ml#L35)

<a id="constant-constant-boxtop-const-boxtop-0-src-m-bbox-ml-1952141046"></a>
### BOXTOP

```ml
const BOXTOP = 0
```

Defines boxtop for the m bbox subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/m_bbox.ml#L29)

<a id="function-function-m-addtobox-function-m-addtobox-box-x-y-src-m-bbox-ml-1709159541"></a>
### M_AddToBox

```ml
function M_AddToBox(box, x, y)
```

Expands a four-entry bounding box in place to include one fixed-point coordinate.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `box` | `dynamic` | — | Bounding-box array to read or update. |
| `x` | `dynamic` | — | Horizontal map- or screen-space coordinate. |
| `y` | `dynamic` | — | Vertical map- or screen-space coordinate. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/m_bbox.ml#L54)

<a id="function-function-m-clearbox-function-m-clearbox-box-src-m-bbox-ml-286265496"></a>
### M_ClearBox

```ml
function M_ClearBox(box)
```

Resets a four-entry bounding box to inverted extremes so the next point establishes every edge.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `box` | `dynamic` | — | Bounding-box array to read or update. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/m_bbox.ml#L39)
