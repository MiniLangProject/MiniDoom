# `src/p_sight.ml`

[Home](README.md) · [Files](Files.md)

Tests monster line of sight through reject tables, BSP crossings, and vertical portal slopes.

Package: [`(global)`](Package-global-1952375359.md)

Reachable from entry: **yes**

## Imports

- `doomdata.ml` → [src/doomdata.ml](File-src-doomdata-ml-887192154.md)
- `doomdef.ml` → [src/doomdef.ml](File-src-doomdef-ml-460406769.md)
- `i_system.ml` → [src/i_system.ml](File-src-i-system-ml-1632920966.md)
- `m_fixed.ml` → [src/m_fixed.ml](File-src-m-fixed-ml-2129187227.md)
- `p_local.ml` → [src/p_local.ml](File-src-p-local-ml-1043095437.md)
- `p_maputl.ml` → [src/p_maputl.ml](File-src-p-maputl-ml-227665141.md)
- `r_state.ml` → [src/r_state.ml](File-src-r-state-ml-691819649.md)

## Declarations

<a id="function-function-psi-getrejectbyte-function-psi-getrejectbyte-idx-src-p-sight-ml-672608293"></a>
### _PSI_GetRejectByte

```ml
function _PSI_GetRejectByte(idx)
```

Reads one REJECT lump byte safely, supporting both direct byte storage and wrapped lump data.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `idx` | `dynamic` | — | Zero-based element or table index. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_sight.ml#L62)

<a id="function-function-psi-sectorindex-function-psi-sectorindex-sec-src-p-sight-ml-1436670683"></a>
### _PSI_SectorIndex

```ml
function _PSI_SectorIndex(sec)
```

Resolves a sector object to its map index for REJECT-table visibility lookup.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `sec` | `dynamic` | — | Sec value supplied to `_PSI_SectorIndex`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_sight.ml#L48)

<a id="global-global-bottomslope-bottomslope-src-p-sight-ml-643827910"></a>
### bottomslope

```ml
bottomslope
```

Tracks the mutable bottomslope value used by the p sight subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_sight.ml#L33)

<a id="function-function-p-checksight-function-p-checksight-t1-t2-src-p-sight-ml-595559849"></a>
### P_CheckSight

```ml
function P_CheckSight(t1, t2)
```

Rejects impossible sector pairs early, then traces BSP portals and vertical slopes to decide whether two mobjs see each other.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `t1` | `dynamic` | — | T1 value supplied to `P_CheckSight`. |
| `t2` | `dynamic` | — | T2 value supplied to `P_CheckSight`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_sight.ml#L232)

<a id="function-function-p-crossbspnode-function-p-crossbspnode-bspnum-src-p-sight-ml-2053063059"></a>
### P_CrossBSPNode

```ml
function P_CrossBSPNode(bspnum)
```

Traverses the BSP front-to-back along the sight trace, stopping as soon as either child proves occlusion.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `bspnum` | `dynamic` | — | Index identifying bsp. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_sight.ml#L197)

<a id="function-function-p-crosssubsector-function-p-crosssubsector-num-src-p-sight-ml-1605293382"></a>
### P_CrossSubsector

```ml
function P_CrossSubsector(num)
```

Clips the sight slope window against every blocking seg in a subsector and rejects fully occluded traces.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `num` | `dynamic` | — | Index identifying the requested item. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_sight.ml#L130)

<a id="function-function-p-divlineside-inline-function-p-divlineside-x-y-node-src-p-sight-ml-1698165132"></a>
### P_DivlineSide

```ml
inline function P_DivlineSide(x, y, node)
```

Classifies a point against a divline, returning two for an exact collinear hit and using scaled products to avoid overflow.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `x` | `dynamic` | — | Horizontal map- or screen-space coordinate. |
| `y` | `dynamic` | — | Vertical map- or screen-space coordinate. |
| `node` | `dynamic` | — | Node value supplied to `P_DivlineSide`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_sight.ml#L84)

<a id="function-function-p-interceptvector2-inline-function-p-interceptvector2-v2-v1-src-p-sight-ml-1488472292"></a>
### P_InterceptVector2

```ml
inline function P_InterceptVector2(v2, v1)
```

Computes where the current sight trace intersects a partition line as a fixed-point fraction.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `v2` | `dynamic` | — | V2 value supplied to `P_InterceptVector2`. |
| `v1` | `dynamic` | — | V1 value supplied to `P_InterceptVector2`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_sight.ml#L119)

<a id="global-global-sightcounts-sightcounts-src-p-sight-ml-206598178"></a>
### sightcounts

```ml
sightcounts
```

Stores the sightcounts collection used by the p sight subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_sight.ml#L43)

<a id="global-global-sightzstart-sightzstart-src-p-sight-ml-1638502202"></a>
### sightzstart

```ml
sightzstart
```

Tracks the mutable sightzstart value used by the p sight subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_sight.ml#L29)

<a id="global-global-strace-strace-src-p-sight-ml-1170438502"></a>
### strace

```ml
strace
```

Tracks the mutable strace value used by the p sight subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_sight.ml#L36)

<a id="global-global-t2x-t2x-src-p-sight-ml-847740598"></a>
### t2x

```ml
t2x
```

Tracks the mutable t2x value used by the p sight subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_sight.ml#L38)

<a id="global-global-t2y-t2y-src-p-sight-ml-78332014"></a>
### t2y

```ml
t2y
```

Tracks the mutable t2y value used by the p sight subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_sight.ml#L40)

<a id="global-global-topslope-topslope-src-p-sight-ml-1745847158"></a>
### topslope

```ml
topslope
```

Tracks the mutable topslope value used by the p sight subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_sight.ml#L31)
