# `src/r_gl.ml`

[Home](README.md) · [Files](Files.md)

Renders Doom maps as cached OpenGL wall/flat geometry with dynamic sectors, masked surfaces, sprites, skies, and lights.

Package: [`(global)`](Package-global-1952375359.md)

Reachable from entry: **yes**

## Imports

- `doomdata.ml` → [src/doomdata.ml](File-src-doomdata-ml-887192154.md)
- `doomdef.ml` → [src/doomdef.ml](File-src-doomdef-ml-460406769.md)
- `doomstat.ml` → [src/doomstat.ml](File-src-doomstat-ml-1652708088.md)
- `i_gl.ml` → [src/i_gl.ml](File-src-i-gl-ml-2113703076.md)
- `info.ml` → [src/info.ml](File-src-info-ml-1415270573.md)
- `m_fixed.ml` → [src/m_fixed.ml](File-src-m-fixed-ml-2129187227.md)
- `p_mobj.ml` → [src/p_mobj.ml](File-src-p-mobj-ml-1335564114.md)
- `r_data.ml` → [src/r_data.ml](File-src-r-data-ml-1686270288.md)
- `r_sky.ml` → [src/r_sky.ml](File-src-r-sky-ml-918225537.md)
- `r_state.ml` → [src/r_state.ml](File-src-r-state-ml-691819649.md)
- `r_upscaled.ml` → [src/r_upscaled.ml](File-src-r-upscaled-ml-1801241933.md)
- `std/math.ml` → `../MiniLangCompilerOptimization/MiniLangCompilerPy/std/math.ml` — external dependency
- `std/time.ml` → `../MiniLangCompilerOptimization/MiniLangCompilerPy/std/time.ml` — external dependency
- `tables.ml` → [src/tables.ml](File-src-tables-ml-1959718242.md)
- `w_wad.ml` → [src/w_wad.ml](File-src-w-wad-ml-893006035.md)

## Declarations

<a id="function-function-rgl-addcacheddepthconvexfloat-function-rgl-addcacheddepthconvexfloat-xs-ys-count-z-src-r-gl-ml-470173012"></a>
### RGL_AddCachedDepthConvexFloat

```ml
function RGL_AddCachedDepthConvexFloat(xs, ys, count, z)
```

Fan-triangulates a convex portal polygon into the depth-only cache.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `xs` | `dynamic` | — | Xs value supplied to `RGL_AddCachedDepthConvexFloat`. |
| `ys` | `dynamic` | — | Ys value supplied to `RGL_AddCachedDepthConvexFloat`. |
| `count` | `dynamic` | — | Number of elements or iterations to process. |
| `z` | `dynamic` | — | Vertical world-space coordinate. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_gl.ml#L4960)

<a id="function-function-rgl-addcacheddepthquad-function-rgl-addcacheddepthquad-x0-y0-z0-x1-y1-z1-x2-y2-z2-x3-y3-z3-src-r-gl-ml-198407764"></a>
### RGL_AddCachedDepthQuad

```ml
function RGL_AddCachedDepthQuad(x0, y0, z0, x1, y1, z1, x2, y2, z2, x3, y3, z3)
```

Appends one four-vertex sky-occlusion surface to the depth-only cache.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `x0` | `dynamic` | — | X0 value supplied to `RGL_AddCachedDepthQuad`. |
| `y0` | `dynamic` | — | Y0 value supplied to `RGL_AddCachedDepthQuad`. |
| `z0` | `dynamic` | — | Z0 value supplied to `RGL_AddCachedDepthQuad`. |
| `x1` | `dynamic` | — | Horizontal coordinate of the first endpoint. |
| `y1` | `dynamic` | — | Vertical coordinate of the first endpoint. |
| `z1` | `dynamic` | — | Z1 value supplied to `RGL_AddCachedDepthQuad`. |
| `x2` | `dynamic` | — | Horizontal coordinate of the second endpoint. |
| `y2` | `dynamic` | — | Vertical coordinate of the second endpoint. |
| `z2` | `dynamic` | — | Z2 value supplied to `RGL_AddCachedDepthQuad`. |
| `x3` | `dynamic` | — | X3 value supplied to `RGL_AddCachedDepthQuad`. |
| `y3` | `dynamic` | — | Y3 value supplied to `RGL_AddCachedDepthQuad`. |
| `z3` | `dynamic` | — | Z3 value supplied to `RGL_AddCachedDepthQuad`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_gl.ml#L4989)

<a id="function-function-rgl-addcachedflatconvexfloat-function-rgl-addcachedflatconvexfloat-xs-ys-count-z-flatnum-src-r-gl-ml-548990115"></a>
### RGL_AddCachedFlatConvexFloat

```ml
function RGL_AddCachedFlatConvexFloat(xs, ys, count, z, flatnum)
```

Fan-triangulates a validated convex polygon and appends lit, textured floor/ceiling triangles to the flat cache.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `xs` | `dynamic` | — | Xs value supplied to `RGL_AddCachedFlatConvexFloat`. |
| `ys` | `dynamic` | — | Ys value supplied to `RGL_AddCachedFlatConvexFloat`. |
| `count` | `dynamic` | — | Number of elements or iterations to process. |
| `z` | `dynamic` | — | Vertical world-space coordinate. |
| `flatnum` | `dynamic` | — | Index identifying flat. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_gl.ml#L4440)

<a id="function-function-rgl-addcachedwallquad-function-rgl-addcachedwallquad-v1-v2-z0-z1-texnum-side-transparent-texturemid-walloffset-src-r-gl-ml-1685486898"></a>
### RGL_AddCachedWallQuad

```ml
function RGL_AddCachedWallQuad(v1, v2, z0, z1, texnum, side, transparent, texturemid, wallOffset)
```

Converts a wall span to a lit textured quad, preserving its BSP-seg texture origin, and appends it to the active wall, masked, or sky-boundary cache.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `v1` | `dynamic` | — | V1 value supplied to `RGL_AddCachedWallQuad`. |
| `v2` | `dynamic` | — | V2 value supplied to `RGL_AddCachedWallQuad`. |
| `z0` | `dynamic` | — | Z0 value supplied to `RGL_AddCachedWallQuad`. |
| `z1` | `dynamic` | — | Z1 value supplied to `RGL_AddCachedWallQuad`. |
| `texnum` | `dynamic` | — | Index identifying tex. |
| `side` | `dynamic` | — | Map side affected by the operation. |
| `transparent` | `dynamic` | — | Transparent value supplied to `RGL_AddCachedWallQuad`. |
| `texturemid` | `dynamic` | — | Texturemid value supplied to `RGL_AddCachedWallQuad`. |
| `wallOffset` | `dynamic` | — | Wall offset value supplied to `RGL_AddCachedWallQuad`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_gl.ml#L3422)

<a id="function-function-rgl-adddynamiclight-function-rgl-adddynamiclight-x-y-z-r-g-b-radius-strength-src-r-gl-ml-1065129223"></a>
### RGL_AddDynamicLight

```ml
function RGL_AddDynamicLight(x, y, z, r, g, b, radius, strength)
```

Appends an in-range, positive dynamic light to the bounded per-frame arrays when near the current view.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `x` | `dynamic` | — | Horizontal map- or screen-space coordinate. |
| `y` | `dynamic` | — | Vertical map- or screen-space coordinate. |
| `z` | `dynamic` | — | Vertical world-space coordinate. |
| `r` | `dynamic` | — | R value supplied to `RGL_AddDynamicLight`. |
| `g` | `dynamic` | — | G value supplied to `RGL_AddDynamicLight`. |
| `b` | `dynamic` | — | Second input operand. |
| `radius` | `dynamic` | — | Radius value supplied to `RGL_AddDynamicLight`. |
| `strength` | `dynamic` | — | Strength value supplied to `RGL_AddDynamicLight`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_gl.ml#L2446)

<a id="function-function-rgl-addliquidsectorlights-function-rgl-addliquidsectorlights-player-src-r-gl-ml-585086667"></a>
### RGL_AddLiquidSectorLights

```ml
function RGL_AddLiquidSectorLights(player)
```

Adds a small budget of ambient lights for nearby liquid sectors.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `player` | `dynamic` | — | Player state affected by the operation. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_gl.ml#L2587)

<a id="function-function-rgl-addsectorliquidlight-function-rgl-addsectorliquidlight-sec-kind-player-pulse-src-r-gl-ml-402641313"></a>
### RGL_AddSectorLiquidLight

```ml
function RGL_AddSectorLiquidLight(sec, kind, player, pulse)
```

Adds one restrained colored light above a nearby liquid sector.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `sec` | `dynamic` | — | Sec value supplied to `RGL_AddSectorLiquidLight`. |
| `kind` | `dynamic` | — | Kind value supplied to `RGL_AddSectorLiquidLight`. |
| `player` | `dynamic` | — | Player state affected by the operation. |
| `pulse` | `dynamic` | — | Pulse value supplied to `RGL_AddSectorLiquidLight`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_gl.ml#L2520)

<a id="function-function-rgl-addvolatileflattemplate-function-rgl-addvolatileflattemplate-sidx-xs-ys-count-src-r-gl-ml-18352574"></a>
### RGL_AddVolatileFlatTemplate

```ml
function RGL_AddVolatileFlatTemplate(sidx, xs, ys, count)
```

Saves one already clipped volatile flat leaf for fast per-frame drawing.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `sidx` | `dynamic` | — | Sidx value supplied to `RGL_AddVolatileFlatTemplate`. |
| `xs` | `dynamic` | — | Xs value supplied to `RGL_AddVolatileFlatTemplate`. |
| `ys` | `dynamic` | — | Ys value supplied to `RGL_AddVolatileFlatTemplate`. |
| `count` | `dynamic` | — | Number of elements or iterations to process. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_gl.ml#L5294)

<a id="constant-constant-rgl-angle-full-const-rgl-angle-full-4294967296-src-r-gl-ml-1245714333"></a>
### RGL_ANGLE_FULL

```ml
const RGL_ANGLE_FULL = 4294967296.
```

Defines rgl angle full for the r gl subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_gl.ml#L38)

<a id="function-function-rgl-angletodegrees-inline-function-rgl-angletodegrees-a-src-r-gl-ml-1872754608"></a>
### RGL_AngleToDegrees

```ml
inline function RGL_AngleToDegrees(a)
```

Converts Doom's unsigned full-turn binary angle to degrees in [0,360).

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `a` | `dynamic` | — | First input operand. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_gl.ml#L2318)

- [rgl_array_batch_t](Type-rgl-array-batch-t-590549000.md) — struct
<a id="function-function-rgl-arraybatchvisible-function-rgl-arraybatchvisible-batch-src-r-gl-ml-1611708832"></a>
### RGL_ArrayBatchVisible

```ml
function RGL_ArrayBatchVisible(batch)
```

Conservatively rejects static geometry chunks outside the player view cone.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `batch` | `dynamic` | — | Batch value supplied to `RGL_ArrayBatchVisible`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_gl.ml#L4718)

<a id="constant-constant-rgl-baseycenter-const-rgl-baseycenter-100-src-r-gl-ml-2118523938"></a>
### RGL_BASEYCENTER

```ml
const RGL_BASEYCENTER = 100
```

Defines rgl baseycenter for the r gl subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_gl.ml#L47)

<a id="function-function-rgl-beginarraybatchdraw-function-rgl-beginarraybatchdraw-src-r-gl-ml-444210796"></a>
### RGL_BeginArrayBatchDraw

```ml
function RGL_BeginArrayBatchDraw()
```

Enables OpenGL client-array state for prepacked world geometry batches.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_gl.ml#L4659)

<a id="function-function-rgl-beginfixedarrayscale-function-rgl-beginfixedarrayscale-src-r-gl-ml-117763436"></a>
### RGL_BeginFixedArrayScale

```ml
function RGL_BeginFixedArrayScale()
```

Applies fixed-point scaling for non-VBO client-array fallbacks.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_gl.ml#L4674)

<a id="function-function-rgl-bindorcolor-function-rgl-bindorcolor-texid-src-r-gl-ml-1714112880"></a>
### RGL_BindOrColor

```ml
function RGL_BindOrColor(texid)
```

Binds and enables a valid texture id, otherwise disables texturing so caller colors remain visible.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `texid` | `dynamic` | — | Texid value supplied to `RGL_BindOrColor`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_gl.ml#L3312)

<a id="function-function-rgl-bottomtextureorzero-inline-function-rgl-bottomtextureorzero-side-src-r-gl-ml-682012336"></a>
### RGL_BottomTextureOrZero

```ml
inline function RGL_BottomTextureOrZero(side)
```

Reads a sidedef's lower texture number, returning zero for missing data.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `side` | `dynamic` | — | Map side affected by the operation. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_gl.ml#L3700)

<a id="global-global-rgl-boundary-display-list-id-rgl-boundary-display-list-id-src-r-gl-ml-659431070"></a>
### rgl_boundary_display_list_id

```ml
rgl_boundary_display_list_id
```

Tracks the mutable rgl boundary display list id value used by the r gl subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_gl.ml#L190)

<a id="global-global-rgl-boundary-quads-rgl-boundary-quads-src-r-gl-ml-1280121492"></a>
### rgl_boundary_quads

```ml
rgl_boundary_quads
```

Stores the rgl boundary quads collection used by the r gl subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_gl.ml#L168)

<a id="function-function-rgl-bspsidevaluefloat-function-rgl-bspsidevaluefloat-x-y-node-src-r-gl-ml-1759723639"></a>
### RGL_BspSideValueFloat

```ml
function RGL_BspSideValueFloat(x, y, node)
```

Computes the signed float-space half-plane value of a point against a BSP partition.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `x` | `dynamic` | — | Horizontal map- or screen-space coordinate. |
| `y` | `dynamic` | — | Vertical map- or screen-space coordinate. |
| `node` | `dynamic` | — | Node value supplied to `RGL_BspSideValueFloat`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_gl.ml#L5101)

<a id="function-function-rgl-buildcurrentmapgeometrylump-function-rgl-buildcurrentmapgeometrylump-src-r-gl-ml-1993680822"></a>
### RGL_BuildCurrentMapGeometryLump

```ml
function RGL_BuildCurrentMapGeometryLump()
```

Rebuilds the current static cache and returns its derived WAD lump name plus serialized geometry blob.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_gl.ml#L2296)

<a id="function-function-rgl-builddynamiclights-function-rgl-builddynamiclights-player-src-r-gl-ml-478081879"></a>
### RGL_BuildDynamicLights

```ml
function RGL_BuildDynamicLights(player)
```

Once per simulation state, collects frame mobjs and rebuilds bounded weapon, liquid, projectile, decor, and explosion lights.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `player` | `dynamic` | — | Player state affected by the operation. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_gl.ml#L2834)

<a id="function-function-rgl-builddynamiclightsurfacerecords-function-rgl-builddynamiclightsurfacerecords-src-r-gl-ml-1524875900"></a>
### RGL_BuildDynamicLightSurfaceRecords

```ml
function RGL_BuildDynamicLightSurfaceRecords()
```

Packs dynamic lights for the native additive surface-light pass.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_gl.ml#L2995)

<a id="function-function-rgl-buildflatarraybatchrange-function-rgl-buildflatarraybatchrange-startindex-endindex-src-r-gl-ml-1611781177"></a>
### RGL_BuildFlatArrayBatchRange

```ml
function RGL_BuildFlatArrayBatchRange(startIndex, endIndex)
```

Packs one contiguous cached flat triangle range into OpenGL client arrays.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `startIndex` | `dynamic` | — | Index identifying start. |
| `endIndex` | `dynamic` | — | Index identifying end. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_gl.ml#L1296)

<a id="function-function-rgl-buildgeometrycache-function-rgl-buildgeometrycache-sigmap-sigsegs-siglines-signodes-sigsubsectors-sigsectormotion-sigsides-src-r-gl-ml-2002145290"></a>
### RGL_BuildGeometryCache

```ml
function RGL_BuildGeometryCache(sigMap, sigSegs, sigLines, sigNodes, sigSubsectors, sigSectorMotion, sigSides)
```

Collects static boundary, depth, flat, opaque-wall, and masked geometry plus signatures for the loaded map.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `sigMap` | `dynamic` | — | Sig map value supplied to `RGL_BuildGeometryCache`. |
| `sigSegs` | `dynamic` | — | Sig segs value supplied to `RGL_BuildGeometryCache`. |
| `sigLines` | `dynamic` | — | Sig lines value supplied to `RGL_BuildGeometryCache`. |
| `sigNodes` | `dynamic` | — | Sig nodes value supplied to `RGL_BuildGeometryCache`. |
| `sigSubsectors` | `dynamic` | — | Sig subsectors value supplied to `RGL_BuildGeometryCache`. |
| `sigSectorMotion` | `dynamic` | — | Sig sector motion value supplied to `RGL_BuildGeometryCache`. |
| `sigSides` | `dynamic` | — | Sig sides value supplied to `RGL_BuildGeometryCache`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_gl.ml#L5880)

<a id="global-global-rgl-building-cache-rgl-building-cache-src-r-gl-ml-117819396"></a>
### rgl_building_cache

```ml
rgl_building_cache
```

Tracks whether rgl building cache is active in the r gl subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_gl.ml#L80)

<a id="function-function-rgl-buildspritelightrecords-function-rgl-buildspritelightrecords-src-r-gl-ml-1134783598"></a>
### RGL_BuildSpriteLightRecords

```ml
function RGL_BuildSpriteLightRecords()
```

Packs the full dynamic-light list once for native sprite color evaluation.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_gl.ml#L5631)

<a id="function-function-rgl-buildstaticarraybatches-function-rgl-buildstaticarraybatches-src-r-gl-ml-206026902"></a>
### RGL_BuildStaticArrayBatches

```ml
function RGL_BuildStaticArrayBatches()
```

Creates prepacked OpenGL client-array batches for static opaque world geometry.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_gl.ml#L1376)

<a id="function-function-rgl-buildstaticdisplaylists-function-rgl-buildstaticdisplaylists-src-r-gl-ml-2073294442"></a>
### RGL_BuildStaticDisplayLists

```ml
function RGL_BuildStaticDisplayLists()
```

Builds per-texture OpenGL display lists for static opaque world geometry.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_gl.ml#L4552)

<a id="function-function-rgl-buildvolatileflattemplates-function-rgl-buildvolatileflattemplates-src-r-gl-ml-3226416"></a>
### RGL_BuildVolatileFlatTemplates

```ml
function RGL_BuildVolatileFlatTemplates()
```

Precomputes clipped BSP leaf polygons for dynamic-sector flats.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_gl.ml#L6002)

<a id="function-function-rgl-buildvolatilesectormap-function-rgl-buildvolatilesectormap-sigmap-src-r-gl-ml-2017248987"></a>
### RGL_BuildVolatileSectorMap

```ml
function RGL_BuildVolatileSectorMap(sigMap)
```

Precomputes sectors and draw lists that should remain dynamic.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `sigMap` | `dynamic` | — | Sig map value supplied to `RGL_BuildVolatileSectorMap`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_gl.ml#L1694)

<a id="function-function-rgl-buildwallarraybatchrange-function-rgl-buildwallarraybatchrange-startindex-endindex-src-r-gl-ml-324899809"></a>
### RGL_BuildWallArrayBatchRange

```ml
function RGL_BuildWallArrayBatchRange(startIndex, endIndex)
```

Packs one contiguous cached wall quad range into OpenGL client arrays.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `startIndex` | `dynamic` | — | Index identifying start. |
| `endIndex` | `dynamic` | — | Index identifying end. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_gl.ml#L1217)

<a id="constant-constant-rgl-cache-boundary-const-rgl-cache-boundary-1-src-r-gl-ml-995252282"></a>
### RGL_CACHE_BOUNDARY

```ml
const RGL_CACHE_BOUNDARY = 1
```

Defines rgl cache boundary for the r gl subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_gl.ml#L309)

<a id="constant-constant-rgl-cache-masked-const-rgl-cache-masked-3-src-r-gl-ml-2090941918"></a>
### RGL_CACHE_MASKED

```ml
const RGL_CACHE_MASKED = 3
```

Defines rgl cache masked for the r gl subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_gl.ml#L313)

<a id="global-global-rgl-cache-target-rgl-cache-target-src-r-gl-ml-1938861994"></a>
### rgl_cache_target

```ml
rgl_cache_target
```

Tracks the mutable rgl cache target value used by the r gl subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_gl.ml#L86)

<a id="constant-constant-rgl-cache-wall-const-rgl-cache-wall-2-src-r-gl-ml-2124344943"></a>
### RGL_CACHE_WALL

```ml
const RGL_CACHE_WALL = 2
```

Defines rgl cache wall for the r gl subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_gl.ml#L311)

<a id="function-function-rgl-cachedtexture-function-rgl-cachedtexture-key-entry-transparent-repeatwrap-src-r-gl-ml-564411882"></a>
### RGL_CachedTexture

```ml
function RGL_CachedTexture(key, entry, transparent, repeatWrap)
```

Returns a keyed GL texture or uploads indexed asset pixels once with requested alpha and wrap modes.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `key` | `dynamic` | — | Input key code to process. |
| `entry` | `dynamic` | — | Entry value supplied to `RGL_CachedTexture`. |
| `transparent` | `dynamic` | — | Transparent value supplied to `RGL_CachedTexture`. |
| `repeatWrap` | `dynamic` | — | Repeat wrap value supplied to `RGL_CachedTexture`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_gl.ml#L3068)

<a id="constant-constant-rgl-camera-back-offset-const-rgl-camera-back-offset-0-src-r-gl-ml-1452417777"></a>
### RGL_CAMERA_BACK_OFFSET

```ml
const RGL_CAMERA_BACK_OFFSET = 0.
```

Defines rgl camera back offset for the r gl subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_gl.ml#L55)

<a id="function-function-rgl-clampbyte-inline-function-rgl-clampbyte-v-src-r-gl-ml-365661855"></a>
### RGL_ClampByte

```ml
inline function RGL_ClampByte(v)
```

Clamps a numeric color component to an integer byte accepted by OpenGL color calls.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `v` | `dynamic` | — | Value consumed by the operation. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_gl.ml#L2430)

<a id="function-function-rgl-clipbspflattoboundarysegs-function-rgl-clipbspflattoboundarysegs-ss-xs-ys-count-outx-outy-src-r-gl-ml-1152965151"></a>
### RGL_ClipBspFlatToBoundarySegs

```ml
function RGL_ClipBspFlatToBoundarySegs(ss, xs, ys, count, outx, outy)
```

Trims BSP flat leaves against one-sided subsector walls so outside void space is not cached.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `ss` | `dynamic` | — | Ss value supplied to `RGL_ClipBspFlatToBoundarySegs`. |
| `xs` | `dynamic` | — | Xs value supplied to `RGL_ClipBspFlatToBoundarySegs`. |
| `ys` | `dynamic` | — | Ys value supplied to `RGL_ClipBspFlatToBoundarySegs`. |
| `count` | `dynamic` | — | Number of elements or iterations to process. |
| `outx` | `dynamic` | — | Outx value supplied to `RGL_ClipBspFlatToBoundarySegs`. |
| `outy` | `dynamic` | — | Outy value supplied to `RGL_ClipBspFlatToBoundarySegs`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_gl.ml#L5241)

<a id="function-function-rgl-clippolytonodeside-function-rgl-clippolytonodeside-xs-ys-count-node-side-outx-outy-src-r-gl-ml-2020237394"></a>
### RGL_ClipPolyToNodeSide

```ml
function RGL_ClipPolyToNodeSide(xs, ys, count, node, side, outx, outy)
```

Sutherland-Hodgman clips a convex polygon to one BSP-node half-plane and returns the output vertex count.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `xs` | `dynamic` | — | Xs value supplied to `RGL_ClipPolyToNodeSide`. |
| `ys` | `dynamic` | — | Ys value supplied to `RGL_ClipPolyToNodeSide`. |
| `count` | `dynamic` | — | Number of elements or iterations to process. |
| `node` | `dynamic` | — | Node value supplied to `RGL_ClipPolyToNodeSide`. |
| `side` | `dynamic` | — | Map side affected by the operation. |
| `outx` | `dynamic` | — | Outx value supplied to `RGL_ClipPolyToNodeSide`. |
| `outy` | `dynamic` | — | Outy value supplied to `RGL_ClipPolyToNodeSide`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_gl.ml#L5117)

<a id="function-function-rgl-clippolytosegfront-function-rgl-clippolytosegfront-xs-ys-count-sg-outx-outy-src-r-gl-ml-749815369"></a>
### RGL_ClipPolyToSegFront

```ml
function RGL_ClipPolyToSegFront(xs, ys, count, sg, outx, outy)
```

Clips a convex flat polygon to the playable front side of one boundary seg.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `xs` | `dynamic` | — | Xs value supplied to `RGL_ClipPolyToSegFront`. |
| `ys` | `dynamic` | — | Ys value supplied to `RGL_ClipPolyToSegFront`. |
| `count` | `dynamic` | — | Number of elements or iterations to process. |
| `sg` | `dynamic` | — | Sg value supplied to `RGL_ClipPolyToSegFront`. |
| `outx` | `dynamic` | — | Outx value supplied to `RGL_ClipPolyToSegFront`. |
| `outy` | `dynamic` | — | Outy value supplied to `RGL_ClipPolyToSegFront`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_gl.ml#L5182)

<a id="function-function-rgl-collectframemobjs-function-rgl-collectframemobjs-src-r-gl-ml-1152482820"></a>
### RGL_CollectFrameMobjs

```ml
function RGL_CollectFrameMobjs()
```

Traverses sector thing lists once so lighting and sprite passes share the same frame-local object set.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_gl.ml#L2791)

<a id="global-global-rgl-collecting-scrolling-geometry-rgl-collecting-scrolling-geometry-src-r-gl-ml-1036220214"></a>
### rgl_collecting_scrolling_geometry

```ml
rgl_collecting_scrolling_geometry
```

Tracks whether rgl collecting scrolling geometry is active in the r gl subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_gl.ml#L138)

<a id="global-global-rgl-collecting-volatile-flats-rgl-collecting-volatile-flats-src-r-gl-ml-2005752518"></a>
### rgl_collecting_volatile_flats

```ml
rgl_collecting_volatile_flats
```

Tracks whether rgl collecting volatile flats is active in the r gl subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_gl.ml#L166)

<a id="global-global-rgl-collecting-volatile-geometry-rgl-collecting-volatile-geometry-src-r-gl-ml-540378342"></a>
### rgl_collecting_volatile_geometry

```ml
rgl_collecting_volatile_geometry
```

Tracks whether rgl collecting volatile geometry is active in the r gl subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_gl.ml#L82)

<a id="function-function-rgl-collectscrollinggeometry-function-rgl-collectscrollinggeometry-src-r-gl-ml-1227417544"></a>
### RGL_CollectScrollingGeometry

```ml
function RGL_CollectScrollingGeometry()
```

Resolves the current scroller texture offsets into frame-reusable quad records.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_gl.ml#L6199)

<a id="function-function-rgl-collectvolatilegeometry-function-rgl-collectvolatilegeometry-src-r-gl-ml-874496844"></a>
### RGL_CollectVolatileGeometry

```ml
function RGL_CollectVolatileGeometry()
```

Resolves current volatile sector heights into cached quad and triangle records without drawing them.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_gl.ml#L6396)

<a id="function-function-rgl-compileflatdisplaylistrange-function-rgl-compileflatdisplaylistrange-startindex-endindex-src-r-gl-ml-430350891"></a>
### RGL_CompileFlatDisplayListRange

```ml
function RGL_CompileFlatDisplayListRange(startIndex, endIndex)
```

Compiles a contiguous flat-triangle texture group into one OpenGL display list.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `startIndex` | `dynamic` | — | Index identifying start. |
| `endIndex` | `dynamic` | — | Index identifying end. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_gl.ml#L4528)

<a id="function-function-rgl-compiletexturedquaddisplaylist-function-rgl-compiletexturedquaddisplaylist-quads-src-r-gl-ml-429694082"></a>
### RGL_CompileTexturedQuadDisplayList

```ml
function RGL_CompileTexturedQuadDisplayList(quads)
```

Compiles static textured quad lists that still use the immediate-mode fallback path.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `quads` | `dynamic` | — | Quads value supplied to `RGL_CompileTexturedQuadDisplayList`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_gl.ml#L3503)

<a id="function-function-rgl-compilewalldisplaylistrange-function-rgl-compilewalldisplaylistrange-startindex-endindex-src-r-gl-ml-879625945"></a>
### RGL_CompileWallDisplayListRange

```ml
function RGL_CompileWallDisplayListRange(startIndex, endIndex)
```

Compiles a contiguous wall-quad texture group into one OpenGL display list.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `startIndex` | `dynamic` | — | Index identifying start. |
| `endIndex` | `dynamic` | — | Index identifying end. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_gl.ml#L4500)

<a id="function-function-rgl-createarraybufferorzero-function-rgl-createarraybufferorzero-data-src-r-gl-ml-1508640476"></a>
### RGL_CreateArrayBufferOrZero

```ml
function RGL_CreateArrayBufferOrZero(data)
```

Uploads static geometry bytes to a VBO when the helper and driver support it.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `data` | `dynamic` | — | Binary or structured data to process. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_gl.ml#L989)

<a id="function-function-rgl-createinterleavedgeombufferorzero-function-rgl-createinterleavedgeombufferorzero-data-src-r-gl-ml-472528884"></a>
### RGL_CreateInterleavedGeomBufferOrZero

```ml
function RGL_CreateInterleavedGeomBufferOrZero(data)
```

Uploads fixed-point interleaved geometry as a float VBO through the GL helper.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `data` | `dynamic` | — | Binary or structured data to process. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_gl.ml#L997)

<a id="function-function-rgl-crossfixed-inline-function-rgl-crossfixed-ax-ay-bx-by-cx-cy-src-r-gl-ml-1482457826"></a>
### RGL_CrossFixed

```ml
inline function RGL_CrossFixed(ax, ay, bx, by, cx, cy)
```

Computes the signed 2D cross product of three fixed-point map coordinates in float space.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `ax` | `dynamic` | — | Horizontal coordinate or vector component represented by ax. |
| `ay` | `dynamic` | — | Vertical coordinate or vector component represented by ay. |
| `bx` | `dynamic` | — | Horizontal coordinate or vector component represented by bx. |
| `by` | `dynamic` | — | Vertical coordinate or vector component represented by by. |
| `cx` | `dynamic` | — | Horizontal coordinate or vector component represented by cx. |
| `cy` | `dynamic` | — | Vertical coordinate or vector component represented by cy. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_gl.ml#L4104)

<a id="global-global-rgl-current-light-rgl-current-light-src-r-gl-ml-2046920690"></a>
### rgl_current_light

```ml
rgl_current_light
```

Tracks the mutable rgl current light value used by the r gl subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_gl.ml#L88)

<a id="function-function-rgl-currentmapidentity-inline-function-rgl-currentmapidentity-src-r-gl-ml-1495498101"></a>
### RGL_CurrentMapIdentity

```ml
inline function RGL_CurrentMapIdentity()
```

Distinguishes episode maps that share the same map number while preserving commercial map IDs.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_gl.ml#L1519)

<a id="function-function-rgl-defaulttexturemid-function-rgl-defaulttexturemid-z1-side-src-r-gl-ml-1007975330"></a>
### RGL_DefaultTextureMid

```ml
function RGL_DefaultTextureMid(z1, side)
```

Uses a wall span's top plus sidedef row offset as the default vertical texture origin.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `z1` | `dynamic` | — | Z1 value supplied to `RGL_DefaultTextureMid`. |
| `side` | `dynamic` | — | Map side affected by the operation. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_gl.ml#L3407)

<a id="function-function-rgl-deletearraybatchbuffers-function-rgl-deletearraybatchbuffers-batches-src-r-gl-ml-312090868"></a>
### RGL_DeleteArrayBatchBuffers

```ml
function RGL_DeleteArrayBatchBuffers(batches)
```

Releases every VBO owned by an array-batch collection.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `batches` | `dynamic` | — | Batches value supplied to `RGL_DeleteArrayBatchBuffers`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_gl.ml#L834)

<a id="function-function-rgl-deletestaticdisplaylists-function-rgl-deletestaticdisplaylists-src-r-gl-ml-569672704"></a>
### RGL_DeleteStaticDisplayLists

```ml
function RGL_DeleteStaticDisplayLists()
```

Releases compiled OpenGL display lists for static wall and flat batches.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_gl.ml#L789)

- [rgl_depth_quad_t](Type-rgl-depth-quad-t-908503369.md) — struct
<a id="global-global-rgl-depth-quads-rgl-depth-quads-src-r-gl-ml-2059343778"></a>
### rgl_depth_quads

```ml
rgl_depth_quads
```

Stores the rgl depth quads collection used by the r gl subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_gl.ml#L178)

- [rgl_depth_tri_t](Type-rgl-depth-tri-t-1737784409.md) — struct
<a id="global-global-rgl-depth-tris-rgl-depth-tris-src-r-gl-ml-2074068934"></a>
### rgl_depth_tris

```ml
rgl_depth_tris
```

Stores the rgl depth tris collection used by the r gl subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_gl.ml#L176)

<a id="function-function-rgl-disablecutoutalpha-function-rgl-disablecutoutalpha-src-r-gl-ml-500531412"></a>
### RGL_DisableCutoutAlpha

```ml
function RGL_DisableCutoutAlpha()
```

Disables alpha testing after masked wall or sprite rendering.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_gl.ml#L3329)

<a id="function-function-rgl-drawallbspflats-function-rgl-drawallbspflats-src-r-gl-ml-1163948924"></a>
### RGL_DrawAllBspFlats

```ml
function RGL_DrawAllBspFlats()
```

Builds a padded map-bounds rectangle and partitions it through the BSP to produce gap-free leaf flat polygons.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_gl.ml#L5444)

<a id="function-function-rgl-drawallflats-function-rgl-drawallflats-src-r-gl-ml-746346704"></a>
### RGL_DrawAllFlats

```ml
function RGL_DrawAllFlats()
```

Draws floor and ceiling polygons for every subsector using the owning sector's flat ids and static light.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_gl.ml#L4415)

<a id="function-function-rgl-drawalllinemidtextures-function-rgl-drawalllinemidtextures-src-r-gl-ml-1035390124"></a>
### RGL_DrawAllLineMidtextures

```ml
function RGL_DrawAllLineMidtextures()
```

For maps without segs, emits both eligible middle-texture sides of every two-sided linedef.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_gl.ml#L3893)

<a id="function-function-rgl-drawallmaskedwalls-function-rgl-drawallmaskedwalls-src-r-gl-ml-276944944"></a>
### RGL_DrawAllMaskedWalls

```ml
function RGL_DrawAllMaskedWalls()
```

Traverses every seg and draws its eligible cutout middle-texture surfaces.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_gl.ml#L3846)

<a id="function-function-rgl-drawallwalls-function-rgl-drawallwalls-src-r-gl-ml-1397371572"></a>
### RGL_DrawAllWalls

```ml
function RGL_DrawAllWalls()
```

Draws every BSP seg, falling back to linedefs when a seg table is unavailable.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_gl.ml#L3796)

<a id="function-function-rgl-drawboundaryquads-function-rgl-drawboundaryquads-src-r-gl-ml-747814676"></a>
### RGL_DrawBoundaryQuads

```ml
function RGL_DrawBoundaryQuads()
```

Draws cached sky boundary quads through a compiled OpenGL display list.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_gl.ml#L3514)

<a id="function-function-rgl-drawbspflatnode-function-rgl-drawbspflatnode-bspnum-xs-ys-count-src-r-gl-ml-903855201"></a>
### RGL_DrawBspFlatNode

```ml
function RGL_DrawBspFlatNode(bspnum, xs, ys, count)
```

Recursively clips the map-bounds polygon through BSP half-planes and sends each leaf polygon to flat rendering.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `bspnum` | `dynamic` | — | Index identifying bsp. |
| `xs` | `dynamic` | — | Xs value supplied to `RGL_DrawBspFlatNode`. |
| `ys` | `dynamic` | — | Ys value supplied to `RGL_DrawBspFlatNode`. |
| `count` | `dynamic` | — | Number of elements or iterations to process. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_gl.ml#L5413)

<a id="function-function-rgl-drawbspleafflat-function-rgl-drawbspleafflat-sidx-xs-ys-count-src-r-gl-ml-1907004210"></a>
### RGL_DrawBspLeafFlat

```ml
function RGL_DrawBspLeafFlat(sidx, xs, ys, count)
```

Clips one BSP leaf to solid boundary segs, records volatile templates when requested, then draws floor and ceiling/sky depth.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `sidx` | `dynamic` | — | Sidx value supplied to `RGL_DrawBspLeafFlat`. |
| `xs` | `dynamic` | — | Xs value supplied to `RGL_DrawBspLeafFlat`. |
| `ys` | `dynamic` | — | Ys value supplied to `RGL_DrawBspLeafFlat`. |
| `count` | `dynamic` | — | Number of elements or iterations to process. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_gl.ml#L5315)

<a id="function-function-rgl-drawcacheddepthgeometry-function-rgl-drawcacheddepthgeometry-src-r-gl-ml-1284808686"></a>
### RGL_DrawCachedDepthGeometry

```ml
function RGL_DrawCachedDepthGeometry()
```

Writes cached sky-occlusion triangles and quads to depth only, restoring color and texture state afterward.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_gl.ml#L4996)

<a id="function-function-rgl-drawcachedflattris-function-rgl-drawcachedflattris-src-r-gl-ml-1653402296"></a>
### RGL_DrawCachedFlatTris

```ml
function RGL_DrawCachedFlatTris()
```

Draws cached floor/ceiling triangles grouped by flat id to reduce texture binds and immediate-mode boundaries.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_gl.ml#L4469)

<a id="function-function-rgl-drawcachedtexturedquads-function-rgl-drawcachedtexturedquads-quads-src-r-gl-ml-1101920040"></a>
### RGL_DrawCachedTexturedQuads

```ml
function RGL_DrawCachedTexturedQuads(quads)
```

Draws cached quads in texture/alpha groups, minimizing binds and glBegin/glEnd boundaries.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `quads` | `dynamic` | — | Quads value supplied to `RGL_DrawCachedTexturedQuads`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_gl.ml#L3461)

<a id="function-function-rgl-drawcachedworld-function-rgl-drawcachedworld-player-yaw-src-r-gl-ml-1828053566"></a>
### RGL_DrawCachedWorld

```ml
function RGL_DrawCachedWorld(player, yaw)
```

Draws cached boundary/depth/flats/walls, then sprites and masked batches in depth-correct world order.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `player` | `dynamic` | — | Player state affected by the operation. |
| `yaw` | `dynamic` | — | Yaw value supplied to `RGL_DrawCachedWorld`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_gl.ml#L5977)

<a id="function-function-rgl-drawdirectworld-function-rgl-drawdirectworld-player-yaw-src-r-gl-ml-1339202860"></a>
### RGL_DrawDirectWorld

```ml
function RGL_DrawDirectWorld(player, yaw)
```

Recomputes and draws all sky boundaries, BSP flats, walls, sprites, and cutout surfaces without geometry caches.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `player` | `dynamic` | — | Player state affected by the operation. |
| `yaw` | `dynamic` | — | Yaw value supplied to `RGL_DrawDirectWorld`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_gl.ml#L5990)

<a id="function-function-rgl-drawdynamiclightglows-function-rgl-drawdynamiclightglows-yaw-src-r-gl-ml-1798163245"></a>
### RGL_DrawDynamicLightGlows

```ml
function RGL_DrawDynamicLightGlows(yaw)
```

Adds dynamic light back onto real floor, ceiling, and wall geometry.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `yaw` | `dynamic` | — | Yaw value supplied to `RGL_DrawDynamicLightGlows`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_gl.ml#L3023)

<a id="function-function-rgl-drawflatarraybatches-function-rgl-drawflatarraybatches-src-r-gl-ml-1573584500"></a>
### RGL_DrawFlatArrayBatches

```ml
function RGL_DrawFlatArrayBatches()
```

Draws static floor and ceiling geometry using OpenGL client arrays.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_gl.ml#L4781)

<a id="function-function-rgl-drawflatconvexfloat-function-rgl-drawflatconvexfloat-xs-ys-count-z-flatnum-src-r-gl-ml-1494969443"></a>
### RGL_DrawFlatConvexFloat

```ml
function RGL_DrawFlatConvexFloat(xs, ys, count, z, flatnum)
```

Caches or fan-draws a convex floor/ceiling polygon with repeating flat UVs and current lighting.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `xs` | `dynamic` | — | Xs value supplied to `RGL_DrawFlatConvexFloat`. |
| `ys` | `dynamic` | — | Ys value supplied to `RGL_DrawFlatConvexFloat`. |
| `count` | `dynamic` | — | Number of elements or iterations to process. |
| `z` | `dynamic` | — | Vertical world-space coordinate. |
| `flatnum` | `dynamic` | — | Index identifying flat. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_gl.ml#L4875)

<a id="function-function-rgl-drawflatdisplaylists-function-rgl-drawflatdisplaylists-src-r-gl-ml-401093900"></a>
### RGL_DrawFlatDisplayLists

```ml
function RGL_DrawFlatDisplayLists()
```

Draws static flat display-list batches with current animated flat bindings.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_gl.ml#L4643)

<a id="function-function-rgl-drawflatpolygonearclipped-function-rgl-drawflatpolygonearclipped-pxs-pys-count-zz-textured-src-r-gl-ml-391985259"></a>
### RGL_DrawFlatPolygonEarClipped

```ml
function RGL_DrawFlatPolygonEarClipped(pxs, pys, count, zz, textured)
```

Triangulates and draws a simple fixed-point polygon by orientation-aware ear clipping, returning whether any ear emitted.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `pxs` | `dynamic` | — | Pxs value supplied to `RGL_DrawFlatPolygonEarClipped`. |
| `pys` | `dynamic` | — | Pys value supplied to `RGL_DrawFlatPolygonEarClipped`. |
| `count` | `dynamic` | — | Number of elements or iterations to process. |
| `zz` | `dynamic` | — | Zz value supplied to `RGL_DrawFlatPolygonEarClipped`. |
| `textured` | `dynamic` | — | Textured value supplied to `RGL_DrawFlatPolygonEarClipped`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_gl.ml#L4156)

<a id="function-function-rgl-drawflattriangle-function-rgl-drawflattriangle-pxs-pys-a-b-c-zz-textured-src-r-gl-ml-1027386010"></a>
### RGL_DrawFlatTriangle

```ml
function RGL_DrawFlatTriangle(pxs, pys, a, b, c, zz, textured)
```

Emits one lit flat triangle with 64-unit repeating UV coordinates when texturing is active.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `pxs` | `dynamic` | — | Pxs value supplied to `RGL_DrawFlatTriangle`. |
| `pys` | `dynamic` | — | Pys value supplied to `RGL_DrawFlatTriangle`. |
| `a` | `dynamic` | — | First input operand. |
| `b` | `dynamic` | — | Second input operand. |
| `c` | `dynamic` | — | C value supplied to `RGL_DrawFlatTriangle`. |
| `zz` | `dynamic` | — | Zz value supplied to `RGL_DrawFlatTriangle`. |
| `textured` | `dynamic` | — | Textured value supplied to `RGL_DrawFlatTriangle`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_gl.ml#L4134)

<a id="function-function-rgl-drawline-function-rgl-drawline-li-src-r-gl-ml-1053938221"></a>
### RGL_DrawLine

```ml
function RGL_DrawLine(li)
```

Resolves a linedef's front side and draws its opaque spans unless assigned to scrolling or volatile caches.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `li` | `dynamic` | — | Li value supplied to `RGL_DrawLine`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_gl.ml#L3770)

<a id="function-function-rgl-drawlinesidemidtexture-function-rgl-drawlinesidemidtexture-li-sideindex-src-r-gl-ml-1445908602"></a>
### RGL_DrawLineSideMidtexture

```ml
function RGL_DrawLineSideMidtexture(li, sideIndex)
```

Resolves and draws one oriented side of a two-sided linedef's cutout middle texture.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `li` | `dynamic` | — | Li value supplied to `RGL_DrawLineSideMidtexture`. |
| `sideIndex` | `dynamic` | — | Index identifying side. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_gl.ml#L3860)

<a id="function-function-rgl-drawmaskedarraybatches-function-rgl-drawmaskedarraybatches-src-r-gl-ml-769463628"></a>
### RGL_DrawMaskedArrayBatches

```ml
function RGL_DrawMaskedArrayBatches()
```

Draws static cutout walls through spatially culled VBO batches.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_gl.ml#L4818)

<a id="function-function-rgl-drawmaskedmidtexture-function-rgl-drawmaskedmidtexture-v1-v2-linedef-side-front-back-walloffset-src-r-gl-ml-1181058232"></a>
### RGL_DrawMaskedMidtexture

```ml
function RGL_DrawMaskedMidtexture(v1, v2, linedef, side, front, back, wallOffset)
```

Computes a two-sided middle texture's pegged bounds and draws it as an offset-preserving cutout quad.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `v1` | `dynamic` | — | V1 value supplied to `RGL_DrawMaskedMidtexture`. |
| `v2` | `dynamic` | — | V2 value supplied to `RGL_DrawMaskedMidtexture`. |
| `linedef` | `dynamic` | — | Linedef value supplied to `RGL_DrawMaskedMidtexture`. |
| `side` | `dynamic` | — | Map side affected by the operation. |
| `front` | `dynamic` | — | Front value supplied to `RGL_DrawMaskedMidtexture`. |
| `back` | `dynamic` | — | Back value supplied to `RGL_DrawMaskedMidtexture`. |
| `wallOffset` | `dynamic` | — | Wall offset value supplied to `RGL_DrawMaskedMidtexture`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_gl.ml#L3637)

<a id="function-function-rgl-drawmaskedquads-function-rgl-drawmaskedquads-src-r-gl-ml-1253191374"></a>
### RGL_DrawMaskedQuads

```ml
function RGL_DrawMaskedQuads()
```

Draws cached masked midtexture quads through a compiled OpenGL display list.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_gl.ml#L3528)

<a id="function-function-rgl-drawmaskedseg-function-rgl-drawmaskedseg-sg-src-r-gl-ml-1942098794"></a>
### RGL_DrawMaskedSeg

```ml
function RGL_DrawMaskedSeg(sg)
```

Draws cutout middle textures on each populated side of a two-sided seg using that side's sector light.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `sg` | `dynamic` | — | Sg value supplied to `RGL_DrawMaskedSeg`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_gl.ml#L3815)

<a id="function-function-rgl-drawonespritebillboard-function-rgl-drawonespritebillboard-mo-lump-flip-rx-rz-src-r-gl-ml-325179473"></a>
### RGL_DrawOneSpriteBillboard

```ml
function RGL_DrawOneSpriteBillboard(mo, lump, flip, rx, rz)
```

Builds one camera-facing world sprite quad, applying sector/dynamic light or a multi-pass translucent shadow treatment.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `mo` | `dynamic` | — | Map object affected by the operation. |
| `lump` | `dynamic` | — | Lump value supplied to `RGL_DrawOneSpriteBillboard`. |
| `flip` | `dynamic` | — | Flip value supplied to `RGL_DrawOneSpriteBillboard`. |
| `rx` | `dynamic` | — | Rx value supplied to `RGL_DrawOneSpriteBillboard`. |
| `rz` | `dynamic` | — | Rz value supplied to `RGL_DrawOneSpriteBillboard`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_gl.ml#L5558)

<a id="function-function-rgl-drawplayerweapon2d-function-rgl-drawplayerweapon2d-player-src-r-gl-ml-988102003"></a>
### RGL_DrawPlayerWeapon2D

```ml
function RGL_DrawPlayerWeapon2D(player)
```

Resolves each active weapon/flash player sprite and submits its upscaled patch as a screen-space GL rectangle.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `player` | `dynamic` | — | Player state affected by the operation. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_gl.ml#L5825)

<a id="function-function-rgl-drawscrollingmaskedarraybatches-function-rgl-drawscrollingmaskedarraybatches-src-r-gl-ml-542269598"></a>
### RGL_DrawScrollingMaskedArrayBatches

```ml
function RGL_DrawScrollingMaskedArrayBatches()
```

Draws cutout scrolling-wall VBOs through native culling with an alpha-tested per-batch fallback.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_gl.ml#L6809)

<a id="function-function-rgl-drawscrollingmaskedwalls-function-rgl-drawscrollingmaskedwalls-src-r-gl-ml-479006004"></a>
### RGL_DrawScrollingMaskedWalls

```ml
function RGL_DrawScrollingMaskedWalls()
```

Draws masked portions of continuously scrolling walls outside the static cache.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_gl.ml#L6174)

<a id="function-function-rgl-drawscrollingwallarraybatches-function-rgl-drawscrollingwallarraybatches-src-r-gl-ml-178329868"></a>
### RGL_DrawScrollingWallArrayBatches

```ml
function RGL_DrawScrollingWallArrayBatches()
```

Draws opaque scrolling-wall VBOs through native culling with a per-batch client-array fallback.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_gl.ml#L6781)

<a id="function-function-rgl-drawscrollingwalls-function-rgl-drawscrollingwalls-src-r-gl-ml-46892660"></a>
### RGL_DrawScrollingWalls

```ml
function RGL_DrawScrollingWalls()
```

Draws only continuously scrolling wall pieces with their current texture offsets.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_gl.ml#L6154)

<a id="function-function-rgl-drawseg-function-rgl-drawseg-sg-src-r-gl-ml-701020964"></a>
### RGL_DrawSeg

```ml
function RGL_DrawSeg(sg)
```

Draws an oriented BSP seg's opaque spans unless the seg belongs to scrolling or volatile geometry.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `sg` | `dynamic` | — | Sg value supplied to `RGL_DrawSeg`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_gl.ml#L3786)

<a id="function-function-rgl-drawsky-function-rgl-drawsky-yaw-src-r-gl-ml-1831395729"></a>
### RGL_DrawSky

```ml
function RGL_DrawSky(yaw)
```

Draws the classic yaw-anchored full-screen sky texture, then restores the 3D projection and depth testing.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `yaw` | `dynamic` | — | Yaw value supplied to `RGL_DrawSky`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_gl.ml#L5372)

<a id="function-function-rgl-drawskyconvexfloat-function-rgl-drawskyconvexfloat-xs-ys-count-z-src-r-gl-ml-690982302"></a>
### RGL_DrawSkyConvexFloat

```ml
function RGL_DrawSkyConvexFloat(xs, ys, count, z)
```

Fan-draws a convex polygon with the full-bright sky texture mapped by view-relative angle.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `xs` | `dynamic` | — | Xs value supplied to `RGL_DrawSkyConvexFloat`. |
| `ys` | `dynamic` | — | Ys value supplied to `RGL_DrawSkyConvexFloat`. |
| `count` | `dynamic` | — | Number of elements or iterations to process. |
| `z` | `dynamic` | — | Vertical world-space coordinate. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_gl.ml#L4931)

<a id="function-function-rgl-drawskydepthconvexfloat-function-rgl-drawskydepthconvexfloat-xs-ys-count-z-src-r-gl-ml-621574760"></a>
### RGL_DrawSkyDepthConvexFloat

```ml
function RGL_DrawSkyDepthConvexFloat(xs, ys, count, z)
```

Caches or immediately fan-draws a convex sky-ceiling polygon with color writes disabled.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `xs` | `dynamic` | — | Xs value supplied to `RGL_DrawSkyDepthConvexFloat`. |
| `ys` | `dynamic` | — | Ys value supplied to `RGL_DrawSkyDepthConvexFloat`. |
| `count` | `dynamic` | — | Number of elements or iterations to process. |
| `z` | `dynamic` | — | Vertical world-space coordinate. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_gl.ml#L5049)

<a id="function-function-rgl-drawskyinteriorboundaries-function-rgl-drawskyinteriorboundaries-src-r-gl-ml-1212401014"></a>
### RGL_DrawSkyInteriorBoundaries

```ml
function RGL_DrawSkyInteriorBoundaries()
```

Finds segs whose adjacent sectors disagree on sky ceiling and draws their textured interior height steps.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_gl.ml#L3953)

<a id="function-function-rgl-drawskyinteriorboundaryline-function-rgl-drawskyinteriorboundaryline-li-src-r-gl-ml-264292839"></a>
### RGL_DrawSkyInteriorBoundaryLine

```ml
function RGL_DrawSkyInteriorBoundaryLine(li)
```

No-seg fallback that draws both oriented textured ceiling steps across a sky/non-sky linedef.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `li` | `dynamic` | — | Li value supplied to `RGL_DrawSkyInteriorBoundaryLine`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_gl.ml#L3969)

<a id="function-function-rgl-drawskyinteriorboundarylines-function-rgl-drawskyinteriorboundarylines-src-r-gl-ml-1370051924"></a>
### RGL_DrawSkyInteriorBoundaryLines

```ml
function RGL_DrawSkyInteriorBoundaryLines()
```

Traverses linedefs and draws sky/non-sky ceiling steps when BSP seg boundaries are unavailable.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_gl.ml#L4019)

<a id="function-function-rgl-drawskyinteriorboundaryseg-function-rgl-drawskyinteriorboundaryseg-sg-src-r-gl-ml-1459749470"></a>
### RGL_DrawSkyInteriorBoundarySeg

```ml
function RGL_DrawSkyInteriorBoundarySeg(sg)
```

Fills the ceiling-height step where a seg crosses between sky and non-sky sectors, drawing both orientations if textured.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `sg` | `dynamic` | — | Sg value supplied to `RGL_DrawSkyInteriorBoundarySeg`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_gl.ml#L3911)

<a id="function-function-rgl-drawskyportals-function-rgl-drawskyportals-src-r-gl-ml-345313520"></a>
### RGL_DrawSkyPortals

```ml
function RGL_DrawSkyPortals()
```

Writes depth-only portal quads for every sky-adjacent BSP seg while preserving depth writes.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_gl.ml#L4086)

<a id="function-function-rgl-drawskyportalseg-function-rgl-drawskyportalseg-sg-src-r-gl-ml-2100016774"></a>
### RGL_DrawSkyPortalSeg

```ml
function RGL_DrawSkyPortalSeg(sg)
```

Adds or draws a tall depth-only quad above a sky-ceiling seg so later sky pixels respect world occlusion.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `sg` | `dynamic` | — | Sg value supplied to `RGL_DrawSkyPortalSeg`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_gl.ml#L4035)

<a id="function-function-rgl-drawskyvertex-function-rgl-drawskyvertex-x-y-z-src-r-gl-ml-1094092681"></a>
### RGL_DrawSkyVertex

```ml
function RGL_DrawSkyVertex(x, y, z)
```

Emits a world-space sky vertex with angular horizontal UV and centered vertical UV.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `x` | `dynamic` | — | Horizontal map- or screen-space coordinate. |
| `y` | `dynamic` | — | Vertical map- or screen-space coordinate. |
| `z` | `dynamic` | — | Vertical world-space coordinate. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_gl.ml#L4920)

<a id="function-function-rgl-drawspritebillboards-function-rgl-drawspritebillboards-player-yaw-src-r-gl-ml-325254606"></a>
### RGL_DrawSpriteBillboards

```ml
function RGL_DrawSpriteBillboards(player, yaw)
```

Draws world sprites through the native batch path with an immediate-mode fallback.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `player` | `dynamic` | — | Player state affected by the operation. |
| `yaw` | `dynamic` | — | Yaw value supplied to `RGL_DrawSpriteBillboards`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_gl.ml#L5817)

<a id="function-function-rgl-drawspritebillboardsimmediate-function-rgl-drawspritebillboardsimmediate-player-yaw-src-r-gl-ml-1428267494"></a>
### RGL_DrawSpriteBillboardsImmediate

```ml
function RGL_DrawSpriteBillboardsImmediate(player, yaw)
```

Preserves the original per-sprite immediate renderer as a compatibility fallback.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `player` | `dynamic` | — | Player state affected by the operation. |
| `yaw` | `dynamic` | — | Yaw value supplied to `RGL_DrawSpriteBillboardsImmediate`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_gl.ml#L5771)

<a id="function-function-rgl-drawspritebillboardsnative-function-rgl-drawspritebillboardsnative-player-yaw-src-r-gl-ml-2051068390"></a>
### RGL_DrawSpriteBillboardsNative

```ml
function RGL_DrawSpriteBillboardsNative(player, yaw)
```

Culls and packs visible sprites before handing the complete frame list to the native GL helper.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `player` | `dynamic` | — | Player state affected by the operation. |
| `yaw` | `dynamic` | — | Yaw value supplied to `RGL_DrawSpriteBillboardsNative`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_gl.ml#L5713)

<a id="function-function-rgl-drawspritequad-function-rgl-drawspritequad-x0-y0-x1-y1-z0-z1-flip-src-r-gl-ml-1433168612"></a>
### RGL_DrawSpriteQuad

```ml
function RGL_DrawSpriteQuad(x0, y0, x1, y1, z0, z1, flip)
```

Draws one billboard quad using Doom sprite texture orientation.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `x0` | `dynamic` | — | X0 value supplied to `RGL_DrawSpriteQuad`. |
| `y0` | `dynamic` | — | Y0 value supplied to `RGL_DrawSpriteQuad`. |
| `x1` | `dynamic` | — | Horizontal coordinate of the first endpoint. |
| `y1` | `dynamic` | — | Vertical coordinate of the first endpoint. |
| `z0` | `dynamic` | — | Z0 value supplied to `RGL_DrawSpriteQuad`. |
| `z1` | `dynamic` | — | Z1 value supplied to `RGL_DrawSpriteQuad`. |
| `flip` | `dynamic` | — | Flip value supplied to `RGL_DrawSpriteQuad`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_gl.ml#L5527)

<a id="function-function-rgl-drawstaticarraybatch-function-rgl-drawstaticarraybatch-batch-mode-src-r-gl-ml-706290087"></a>
### RGL_DrawStaticArrayBatch

```ml
function RGL_DrawStaticArrayBatch(batch, mode)
```

Draws one prepacked OpenGL client-array geometry batch.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `batch` | `dynamic` | — | Batch value supplied to `RGL_DrawStaticArrayBatch`. |
| `mode` | `dynamic` | — | Mode value supplied to `RGL_DrawStaticArrayBatch`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_gl.ml#L4696)

<a id="function-function-rgl-drawstaticworlddisplaylist-function-rgl-drawstaticworlddisplaylist-src-r-gl-ml-1039614776"></a>
### RGL_DrawStaticWorldDisplayList

```ml
function RGL_DrawStaticWorldDisplayList()
```

Draws all static opaque wall and flat geometry through one parent OpenGL display list.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_gl.ml#L4852)

<a id="function-function-rgl-drawsubsectorflat-function-rgl-drawsubsectorflat-ss-z-flatnum-src-r-gl-ml-1816668069"></a>
### RGL_DrawSubsectorFlat

```ml
function RGL_DrawSubsectorFlat(ss, z, flatnum)
```

Reconstructs a subsector polygon from unique seg endpoints, angle-sorts it, and draws an ear-clipped or fan flat.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `ss` | `dynamic` | — | Ss value supplied to `RGL_DrawSubsectorFlat`. |
| `z` | `dynamic` | — | Vertical world-space coordinate. |
| `flatnum` | `dynamic` | — | Index identifying flat. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_gl.ml#L4240)

<a id="function-function-rgl-drawvolatileflatarraybatches-function-rgl-drawvolatileflatarraybatches-src-r-gl-ml-1568016068"></a>
### RGL_DrawVolatileFlatArrayBatches

```ml
function RGL_DrawVolatileFlatArrayBatches()
```

Draws moving-sector floors and ceilings through native culled VBO batches.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_gl.ml#L6680)

<a id="function-function-rgl-drawvolatileflats-function-rgl-drawvolatileflats-src-r-gl-ml-1712159404"></a>
### RGL_DrawVolatileFlats

```ml
function RGL_DrawVolatileFlats()
```

Draws only flats that belong to dynamic sector geometry.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_gl.ml#L6071)

<a id="function-function-rgl-drawvolatileflattemplate-function-rgl-drawvolatileflattemplate-t-src-r-gl-ml-1473995090"></a>
### RGL_DrawVolatileFlatTemplate

```ml
function RGL_DrawVolatileFlatTemplate(t)
```

Draws one cached dynamic-sector floor and ceiling polygon at current heights.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `t` | `dynamic` | — | T value supplied to `RGL_DrawVolatileFlatTemplate`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_gl.ml#L6048)

<a id="function-function-rgl-drawvolatilelinemidtextures-function-rgl-drawvolatilelinemidtextures-src-r-gl-ml-353567260"></a>
### RGL_DrawVolatileLineMidtextures

```ml
function RGL_DrawVolatileLineMidtextures()
```

Draws dynamic line midtextures when no seg list is available.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_gl.ml#L6135)

<a id="function-function-rgl-drawvolatilemaskedarraybatches-function-rgl-drawvolatilemaskedarraybatches-src-r-gl-ml-569355500"></a>
### RGL_DrawVolatileMaskedArrayBatches

```ml
function RGL_DrawVolatileMaskedArrayBatches()
```

Draws settled moving-sector cutout walls from their cached VBOs.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_gl.ml#L6714)

<a id="function-function-rgl-drawvolatilemaskedwalls-function-rgl-drawvolatilemaskedwalls-src-r-gl-ml-549080760"></a>
### RGL_DrawVolatileMaskedWalls

```ml
function RGL_DrawVolatileMaskedWalls()
```

Draws only masked wall pieces that touch dynamic sector geometry.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_gl.ml#L6122)

<a id="function-function-rgl-drawvolatilemaskedworld-function-rgl-drawvolatilemaskedworld-src-r-gl-ml-284833182"></a>
### RGL_DrawVolatileMaskedWorld

```ml
function RGL_DrawVolatileMaskedWorld()
```

Updates dynamic masked geometry on top of the static cache.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_gl.ml#L6359)

<a id="function-function-rgl-drawvolatileopaqueworld-function-rgl-drawvolatileopaqueworld-src-r-gl-ml-1458664690"></a>
### RGL_DrawVolatileOpaqueWorld

```ml
function RGL_DrawVolatileOpaqueWorld()
```

Updates dynamic sector flats and opaque walls on top of the static cache.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_gl.ml#L6353)

<a id="function-function-rgl-drawvolatilewallarraybatches-function-rgl-drawvolatilewallarraybatches-src-r-gl-ml-1983986532"></a>
### RGL_DrawVolatileWallArrayBatches

```ml
function RGL_DrawVolatileWallArrayBatches()
```

Draws moving-sector walls through native culled VBO batches.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_gl.ml#L6645)

<a id="function-function-rgl-drawvolatilewalls-function-rgl-drawvolatilewalls-src-r-gl-ml-1289483382"></a>
### RGL_DrawVolatileWalls

```ml
function RGL_DrawVolatileWalls()
```

Draws only opaque wall pieces that touch dynamic sector geometry.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_gl.ml#L6111)

<a id="function-function-rgl-drawwallarraybatches-function-rgl-drawwallarraybatches-src-r-gl-ml-1760035816"></a>
### RGL_DrawWallArrayBatches

```ml
function RGL_DrawWallArrayBatches()
```

Draws static wall geometry using OpenGL client arrays.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_gl.ml#L4739)

<a id="function-function-rgl-drawwalldisplaylists-function-rgl-drawwalldisplaylists-src-r-gl-ml-1281824012"></a>
### RGL_DrawWallDisplayLists

```ml
function RGL_DrawWallDisplayLists()
```

Draws static wall display-list batches with current animated texture bindings.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_gl.ml#L4622)

<a id="function-function-rgl-drawwallpiece-function-rgl-drawwallpiece-v1-v2-linedef-side-front-back-walloffset-src-r-gl-ml-1330420880"></a>
### RGL_DrawWallPiece

```ml
function RGL_DrawWallPiece(v1, v2, linedef, side, front, back, wallOffset)
```

Draws a one-sided middle wall or adjacent-sector steps with pegging, light, and the parent linedef's continuous horizontal UV origin.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `v1` | `dynamic` | — | V1 value supplied to `RGL_DrawWallPiece`. |
| `v2` | `dynamic` | — | V2 value supplied to `RGL_DrawWallPiece`. |
| `linedef` | `dynamic` | — | Linedef value supplied to `RGL_DrawWallPiece`. |
| `side` | `dynamic` | — | Map side affected by the operation. |
| `front` | `dynamic` | — | Front value supplied to `RGL_DrawWallPiece`. |
| `back` | `dynamic` | — | Back value supplied to `RGL_DrawWallPiece`. |
| `wallOffset` | `dynamic` | — | Wall offset value supplied to `RGL_DrawWallPiece`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_gl.ml#L3736)

<a id="function-function-rgl-drawwallquad-function-rgl-drawwallquad-v1-v2-z0-z1-texnum-side-src-r-gl-ml-850309242"></a>
### RGL_DrawWallQuad

```ml
function RGL_DrawWallQuad(v1, v2, z0, z1, texnum, side)
```

Draws an opaque wall span through the common quad path.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `v1` | `dynamic` | — | V1 value supplied to `RGL_DrawWallQuad`. |
| `v2` | `dynamic` | — | V2 value supplied to `RGL_DrawWallQuad`. |
| `z0` | `dynamic` | — | Z0 value supplied to `RGL_DrawWallQuad`. |
| `z1` | `dynamic` | — | Z1 value supplied to `RGL_DrawWallQuad`. |
| `texnum` | `dynamic` | — | Index identifying tex. |
| `side` | `dynamic` | — | Map side affected by the operation. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_gl.ml#L3625)

<a id="function-function-rgl-drawwallquadex-function-rgl-drawwallquadex-v1-v2-z0-z1-texnum-side-transparent-src-r-gl-ml-2009942782"></a>
### RGL_DrawWallQuadEx

```ml
function RGL_DrawWallQuadEx(v1, v2, z0, z1, texnum, side, transparent)
```

Draws an opaque or cutout wall span using the default top-plus-row-offset texture origin.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `v1` | `dynamic` | — | V1 value supplied to `RGL_DrawWallQuadEx`. |
| `v2` | `dynamic` | — | V2 value supplied to `RGL_DrawWallQuadEx`. |
| `z0` | `dynamic` | — | Z0 value supplied to `RGL_DrawWallQuadEx`. |
| `z1` | `dynamic` | — | Z1 value supplied to `RGL_DrawWallQuadEx`. |
| `texnum` | `dynamic` | — | Index identifying tex. |
| `side` | `dynamic` | — | Map side affected by the operation. |
| `transparent` | `dynamic` | — | Transparent value supplied to `RGL_DrawWallQuadEx`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_gl.ml#L3602)

<a id="function-function-rgl-drawwallquadoffset-function-rgl-drawwallquadoffset-v1-v2-z0-z1-texnum-side-walloffset-src-r-gl-ml-2095134599"></a>
### RGL_DrawWallQuadOffset

```ml
function RGL_DrawWallQuadOffset(v1, v2, z0, z1, texnum, side, wallOffset)
```

Draws a generic wall quad while adding an oriented BSP-seg distance to the sidedef texture offset.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `v1` | `dynamic` | — | V1 value supplied to `RGL_DrawWallQuadOffset`. |
| `v2` | `dynamic` | — | V2 value supplied to `RGL_DrawWallQuadOffset`. |
| `z0` | `dynamic` | — | Z0 value supplied to `RGL_DrawWallQuadOffset`. |
| `z1` | `dynamic` | — | Z1 value supplied to `RGL_DrawWallQuadOffset`. |
| `texnum` | `dynamic` | — | Index identifying tex. |
| `side` | `dynamic` | — | Map side affected by the operation. |
| `wallOffset` | `dynamic` | — | Wall offset value supplied to `RGL_DrawWallQuadOffset`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_gl.ml#L3614)

<a id="function-function-rgl-drawwallquadtexmid-function-rgl-drawwallquadtexmid-v1-v2-z0-z1-texnum-side-transparent-texturemid-walloffset-src-r-gl-ml-1981819514"></a>
### RGL_DrawWallQuadTexMid

```ml
function RGL_DrawWallQuadTexMid(v1, v2, z0, z1, texnum, side, transparent, texturemid, wallOffset)
```

Caches or immediately draws a wall span with its sidedef-plus-seg horizontal origin and an explicit vertical texture origin.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `v1` | `dynamic` | — | V1 value supplied to `RGL_DrawWallQuadTexMid`. |
| `v2` | `dynamic` | — | V2 value supplied to `RGL_DrawWallQuadTexMid`. |
| `z0` | `dynamic` | — | Z0 value supplied to `RGL_DrawWallQuadTexMid`. |
| `z1` | `dynamic` | — | Z1 value supplied to `RGL_DrawWallQuadTexMid`. |
| `texnum` | `dynamic` | — | Index identifying tex. |
| `side` | `dynamic` | — | Map side affected by the operation. |
| `transparent` | `dynamic` | — | Transparent value supplied to `RGL_DrawWallQuadTexMid`. |
| `texturemid` | `dynamic` | — | Texturemid value supplied to `RGL_DrawWallQuadTexMid`. |
| `wallOffset` | `dynamic` | — | Wall offset value supplied to `RGL_DrawWallQuadTexMid`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_gl.ml#L3552)

<a id="global-global-rgl-dyn-light-b-rgl-dyn-light-b-src-r-gl-ml-1562026010"></a>
### rgl_dyn_light_b

```ml
rgl_dyn_light_b
```

Stores the rgl dyn light b collection used by the r gl subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_gl.ml#L274)

<a id="global-global-rgl-dyn-light-count-rgl-dyn-light-count-src-r-gl-ml-1825873926"></a>
### rgl_dyn_light_count

```ml
rgl_dyn_light_count
```

Tracks the mutable rgl dyn light count value used by the r gl subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_gl.ml#L280)

<a id="global-global-rgl-dyn-light-g-rgl-dyn-light-g-src-r-gl-ml-2142560062"></a>
### rgl_dyn_light_g

```ml
rgl_dyn_light_g
```

Stores the rgl dyn light g collection used by the r gl subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_gl.ml#L272)

<a id="global-global-rgl-dyn-light-last-gametic-rgl-dyn-light-last-gametic-src-r-gl-ml-1945718630"></a>
### rgl_dyn_light_last_gametic

```ml
rgl_dyn_light_last_gametic
```

Tracks the mutable rgl dyn light last gametic value used by the r gl subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_gl.ml#L282)

<a id="global-global-rgl-dyn-light-last-leveltime-rgl-dyn-light-last-leveltime-src-r-gl-ml-345266780"></a>
### rgl_dyn_light_last_leveltime

```ml
rgl_dyn_light_last_leveltime
```

Tracks the mutable rgl dyn light last leveltime value used by the r gl subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_gl.ml#L286)

<a id="global-global-rgl-dyn-light-last-map-rgl-dyn-light-last-map-src-r-gl-ml-2082117638"></a>
### rgl_dyn_light_last_map

```ml
rgl_dyn_light_last_map
```

Tracks the mutable rgl dyn light last map value used by the r gl subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_gl.ml#L284)

<a id="global-global-rgl-dyn-light-r-rgl-dyn-light-r-src-r-gl-ml-384394202"></a>
### rgl_dyn_light_r

```ml
rgl_dyn_light_r
```

Stores the rgl dyn light r collection used by the r gl subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_gl.ml#L270)

<a id="global-global-rgl-dyn-light-radius-rgl-dyn-light-radius-src-r-gl-ml-1226603440"></a>
### rgl_dyn_light_radius

```ml
rgl_dyn_light_radius
```

Stores the rgl dyn light radius collection used by the r gl subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_gl.ml#L276)

<a id="global-global-rgl-dyn-light-revision-rgl-dyn-light-revision-src-r-gl-ml-1601055782"></a>
### rgl_dyn_light_revision

```ml
rgl_dyn_light_revision
```

Tracks the mutable rgl dyn light revision value used by the r gl subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_gl.ml#L288)

<a id="global-global-rgl-dyn-light-strength-rgl-dyn-light-strength-src-r-gl-ml-383046974"></a>
### rgl_dyn_light_strength

```ml
rgl_dyn_light_strength
```

Stores the rgl dyn light strength collection used by the r gl subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_gl.ml#L278)

<a id="global-global-rgl-dyn-light-x-rgl-dyn-light-x-src-r-gl-ml-401852378"></a>
### rgl_dyn_light_x

```ml
rgl_dyn_light_x
```

Stores the rgl dyn light x collection used by the r gl subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_gl.ml#L264)

<a id="global-global-rgl-dyn-light-y-rgl-dyn-light-y-src-r-gl-ml-2065987806"></a>
### rgl_dyn_light_y

```ml
rgl_dyn_light_y
```

Stores the rgl dyn light y collection used by the r gl subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_gl.ml#L266)

<a id="global-global-rgl-dyn-light-z-rgl-dyn-light-z-src-r-gl-ml-1479177546"></a>
### rgl_dyn_light_z

```ml
rgl_dyn_light_z
```

Stores the rgl dyn light z collection used by the r gl subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_gl.ml#L268)

<a id="constant-constant-rgl-dynamic-settle-frames-const-rgl-dynamic-settle-frames-3-src-r-gl-ml-758362188"></a>
### RGL_DYNAMIC_SETTLE_FRAMES

```ml
const RGL_DYNAMIC_SETTLE_FRAMES = 3
```

Defines rgl dynamic settle frames for the r gl subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_gl.ml#L49)

<a id="function-function-rgl-enablecutoutalpha-function-rgl-enablecutoutalpha-src-r-gl-ml-1850385382"></a>
### RGL_EnableCutoutAlpha

```ml
function RGL_EnableCutoutAlpha()
```

Enables alpha testing and rejects texels whose alpha does not exceed the 0.5 cutout threshold.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_gl.ml#L3323)

<a id="function-function-rgl-endarraybatchdraw-function-rgl-endarraybatchdraw-src-r-gl-ml-1382185268"></a>
### RGL_EndArrayBatchDraw

```ml
function RGL_EndArrayBatchDraw()
```

Restores OpenGL client-array state after array batch rendering.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_gl.ml#L4666)

<a id="function-function-rgl-endfixedarrayscale-function-rgl-endfixedarrayscale-src-r-gl-ml-1508322924"></a>
### RGL_EndFixedArrayScale

```ml
function RGL_EndFixedArrayScale()
```

Restores matrices after non-VBO fixed-point fallback drawing.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_gl.ml#L4686)

<a id="function-function-rgl-ensuregeometrycache-function-rgl-ensuregeometrycache-src-r-gl-ml-1055831944"></a>
### RGL_EnsureGeometryCache

```ml
function RGL_EnsureGeometryCache()
```

Reuses matching geometry, tries the map lump on first use, or rebuilds and serializes when topology/sidedefs differ.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_gl.ml#L5948)

<a id="function-function-rgl-ensurescrollingarraybatches-function-rgl-ensurescrollingarraybatches-src-r-gl-ml-439661564"></a>
### RGL_EnsureScrollingArrayBatches

```ml
function RGL_EnsureScrollingArrayBatches()
```

Refreshes scrolling UV geometry once per game tic, not once per rendered frame.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_gl.ml#L6341)

<a id="function-function-rgl-ensurevolatilearraybatches-function-rgl-ensurevolatilearraybatches-src-r-gl-ml-16087272"></a>
### RGL_EnsureVolatileArrayBatches

```ml
function RGL_EnsureVolatileArrayBatches()
```

Rebuilds volatile meshes at most once per game tic and only when their state changed.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_gl.ml#L6548)

<a id="function-function-rgl-ensurevolatilesectormap-function-rgl-ensurevolatilesectormap-sigmap-src-r-gl-ml-1031217067"></a>
### RGL_EnsureVolatileSectorMap

```ml
function RGL_EnsureVolatileSectorMap(sigMap)
```

Keeps the dynamic sector draw lists aligned with the loaded map.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `sigMap` | `dynamic` | — | Sig map value supplied to `RGL_EnsureVolatileSectorMap`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_gl.ml#L1800)

<a id="function-function-rgl-enumindex-inline-function-rgl-enumindex-v-limit-src-r-gl-ml-1103489478"></a>
### RGL_EnumIndex

```ml
inline function RGL_EnumIndex(v, limit)
```

Resolves an enum-like value to a bounded numeric table index, returning -1 when absent.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `v` | `dynamic` | — | Value consumed by the operation. |
| `limit` | `dynamic` | — | Limit value supplied to `RGL_EnumIndex`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_gl.ml#L2339)

<a id="function-function-rgl-fallbacksteptexture-function-rgl-fallbacksteptexture-tex-side-otherside-src-r-gl-ml-1297630379"></a>
### RGL_FallbackStepTexture

```ml
function RGL_FallbackStepTexture(tex, side, otherSide)
```

Chooses a nonzero step texture from the requested slot, opposite side tiers, then either middle texture.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `tex` | `dynamic` | — | Texture identifier or texture data to process. |
| `side` | `dynamic` | — | Map side affected by the operation. |
| `otherSide` | `dynamic` | — | Other side value supplied to `RGL_FallbackStepTexture`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_gl.ml#L3716)

<a id="constant-constant-rgl-ff-framemask-const-rgl-ff-framemask-32767-src-r-gl-ml-1098599282"></a>
### RGL_FF_FRAMEMASK

```ml
const RGL_FF_FRAMEMASK = 32767
```

Defines rgl ff framemask for the r gl subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_gl.ml#L40)

<a id="function-function-rgl-fixedtofloat-inline-function-rgl-fixedtofloat-v-src-r-gl-ml-1792482099"></a>
### RGL_FixedToFloat

```ml
inline function RGL_FixedToFloat(v)
```

Converts a Doom FRACUNIT-scaled coordinate to floating-point world units.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `v` | `dynamic` | — | Value consumed by the operation. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_gl.ml#L2312)

<a id="constant-constant-rgl-flat-array-batch-tris-const-rgl-flat-array-batch-tris-8192-src-r-gl-ml-925080747"></a>
### RGL_FLAT_ARRAY_BATCH_TRIS

```ml
const RGL_FLAT_ARRAY_BATCH_TRIS = 8192
```

Defines rgl flat array batch tris for the r gl subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_gl.ml#L317)

<a id="global-global-rgl-flat-array-batches-rgl-flat-array-batches-src-r-gl-ml-812431566"></a>
### rgl_flat_array_batches

```ml
rgl_flat_array_batches
```

Stores the rgl flat array batches collection used by the r gl subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_gl.ml#L200)

<a id="global-global-rgl-flat-display-list-flatnums-rgl-flat-display-list-flatnums-src-r-gl-ml-309803434"></a>
### rgl_flat_display_list_flatnums

```ml
rgl_flat_display_list_flatnums
```

Stores the rgl flat display list flatnums collection used by the r gl subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_gl.ml#L186)

<a id="global-global-rgl-flat-display-list-ids-rgl-flat-display-list-ids-src-r-gl-ml-1355690438"></a>
### rgl_flat_display_list_ids

```ml
rgl_flat_display_list_ids
```

Stores the rgl flat display list ids collection used by the r gl subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_gl.ml#L188)

<a id="global-global-rgl-flat-native-record-count-rgl-flat-native-record-count-src-r-gl-ml-1191171364"></a>
### rgl_flat_native_record_count

```ml
rgl_flat_native_record_count
```

Tracks the mutable rgl flat native record count value used by the r gl subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_gl.ml#L252)

<a id="global-global-rgl-flat-native-records-rgl-flat-native-records-src-r-gl-ml-1838436138"></a>
### rgl_flat_native_records

```ml
rgl_flat_native_records
```

Tracks the mutable rgl flat native records value used by the r gl subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_gl.ml#L246)

<a id="global-global-rgl-flat-native-texture-revision-rgl-flat-native-texture-revision-src-r-gl-ml-584698032"></a>
### rgl_flat_native_texture_revision

```ml
rgl_flat_native_texture_revision
```

Tracks the mutable rgl flat native texture revision value used by the r gl subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_gl.ml#L258)

<a id="constant-constant-rgl-flat-spatial-batch-cell-const-rgl-flat-spatial-batch-cell-4096-src-r-gl-ml-360468538"></a>
### RGL_FLAT_SPATIAL_BATCH_CELL

```ml
const RGL_FLAT_SPATIAL_BATCH_CELL = 4096.
```

Defines rgl flat spatial batch cell for the r gl subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_gl.ml#L321)

<a id="global-global-rgl-flat-tex-ids-rgl-flat-tex-ids-src-r-gl-ml-1204180742"></a>
### rgl_flat_tex_ids

```ml
rgl_flat_tex_ids
```

Stores the rgl flat tex ids collection used by the r gl subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_gl.ml#L66)

- [rgl_flat_tri_t](Type-rgl-flat-tri-t-1679467841.md) — struct
<a id="global-global-rgl-flat-tris-rgl-flat-tris-src-r-gl-ml-2033145666"></a>
### rgl_flat_tris

```ml
rgl_flat_tris
```

Stores the rgl flat tris collection used by the r gl subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_gl.ml#L174)

<a id="global-global-rgl-flat-volatile-only-rgl-flat-volatile-only-src-r-gl-ml-442114668"></a>
### rgl_flat_volatile_only

```ml
rgl_flat_volatile_only
```

Tracks whether rgl flat volatile only is active in the r gl subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_gl.ml#L84)

<a id="function-function-rgl-flatarraybatchkey-function-rgl-flatarraybatchkey-t-src-r-gl-ml-44332692"></a>
### RGL_FlatArrayBatchKey

```ml
function RGL_FlatArrayBatchKey(t)
```

Builds a combined texture and spatial key for static flat batching.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `t` | `dynamic` | — | T value supplied to `RGL_FlatArrayBatchKey`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_gl.ml#L599)

<a id="function-function-rgl-flatnamefornum-function-rgl-flatnamefornum-flatnum-src-r-gl-ml-1182887281"></a>
### RGL_FlatNameForNum

```ml
function RGL_FlatNameForNum(flatnum)
```

Resolves the currently translated flat name for liquid light classification.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `flatnum` | `dynamic` | — | Index identifying flat. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_gl.ml#L2495)

<a id="function-function-rgl-flatspatialbatchcellkey-function-rgl-flatspatialbatchcellkey-x-z-src-r-gl-ml-906344938"></a>
### RGL_FlatSpatialBatchCellKey

```ml
function RGL_FlatSpatialBatchCellKey(x, z)
```

Maps flat geometry to coarser cells because flat rendering is draw-call bound.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `x` | `dynamic` | — | Horizontal map- or screen-space coordinate. |
| `z` | `dynamic` | — | Vertical world-space coordinate. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_gl.ml#L577)

<a id="function-function-rgl-floattogeom-inline-function-rgl-floattogeom-v-src-r-gl-ml-1071501767"></a>
### RGL_FloatToGeom

```ml
inline function RGL_FloatToGeom(v)
```

Quantizes a numeric coordinate to the signed fixed-scale representation used in cached geometry.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `v` | `dynamic` | — | Value consumed by the operation. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_gl.ml#L1488)

<a id="global-global-rgl-force-software-rgl-force-software-src-r-gl-ml-603335944"></a>
### rgl_force_software

```ml
rgl_force_software
```

Tracks whether rgl force software is active in the r gl subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_gl.ml#L90)

<a id="global-global-rgl-frame-mobj-count-rgl-frame-mobj-count-src-r-gl-ml-952470558"></a>
### rgl_frame_mobj_count

```ml
rgl_frame_mobj_count
```

Tracks the mutable rgl frame mobj count value used by the r gl subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_gl.ml#L292)

<a id="global-global-rgl-frame-mobjs-rgl-frame-mobjs-src-r-gl-ml-88200318"></a>
### rgl_frame_mobjs

```ml
rgl_frame_mobjs
```

Stores the rgl frame mobjs collection used by the r gl subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_gl.ml#L290)

<a id="constant-constant-rgl-geom-fix-scale-const-rgl-geom-fix-scale-65536-src-r-gl-ml-853727598"></a>
### RGL_GEOM_FIX_SCALE

```ml
const RGL_GEOM_FIX_SCALE = 65536.
```

Defines rgl geom fix scale for the r gl subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_gl.ml#L51)

<a id="global-global-rgl-geom-ready-rgl-geom-ready-src-r-gl-ml-917277462"></a>
### rgl_geom_ready

```ml
rgl_geom_ready
```

Tracks whether rgl geom ready is active in the r gl subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_gl.ml#L92)

<a id="global-global-rgl-geom-sig-lines-rgl-geom-sig-lines-src-r-gl-ml-1830721998"></a>
### rgl_geom_sig_lines

```ml
rgl_geom_sig_lines
```

Tracks the mutable rgl geom sig lines value used by the r gl subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_gl.ml#L98)

<a id="global-global-rgl-geom-sig-map-rgl-geom-sig-map-src-r-gl-ml-1941888780"></a>
### rgl_geom_sig_map

```ml
rgl_geom_sig_map
```

Tracks the mutable rgl geom sig map value used by the r gl subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_gl.ml#L94)

<a id="global-global-rgl-geom-sig-nodes-rgl-geom-sig-nodes-src-r-gl-ml-806518726"></a>
### rgl_geom_sig_nodes

```ml
rgl_geom_sig_nodes
```

Tracks the mutable rgl geom sig nodes value used by the r gl subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_gl.ml#L100)

<a id="global-global-rgl-geom-sig-sector-motion-rgl-geom-sig-sector-motion-src-r-gl-ml-1458352254"></a>
### rgl_geom_sig_sector_motion

```ml
rgl_geom_sig_sector_motion
```

Tracks the mutable rgl geom sig sector motion value used by the r gl subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_gl.ml#L104)

<a id="global-global-rgl-geom-sig-segs-rgl-geom-sig-segs-src-r-gl-ml-1940434586"></a>
### rgl_geom_sig_segs

```ml
rgl_geom_sig_segs
```

Tracks the mutable rgl geom sig segs value used by the r gl subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_gl.ml#L96)

<a id="global-global-rgl-geom-sig-sides-rgl-geom-sig-sides-src-r-gl-ml-1896270840"></a>
### rgl_geom_sig_sides

```ml
rgl_geom_sig_sides
```

Tracks the mutable rgl geom sig sides value used by the r gl subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_gl.ml#L106)

<a id="global-global-rgl-geom-sig-subsectors-rgl-geom-sig-subsectors-src-r-gl-ml-739532262"></a>
### rgl_geom_sig_subsectors

```ml
rgl_geom_sig_subsectors
```

Tracks the mutable rgl geom sig subsectors value used by the r gl subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_gl.ml#L102)

<a id="constant-constant-rgl-geom-version-const-rgl-geom-version-9-src-r-gl-ml-1831668562"></a>
### RGL_GEOM_VERSION

```ml
const RGL_GEOM_VERSION = 9
```

Defines rgl geom version for the r gl subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_gl.ml#L53)

<a id="function-function-rgl-geometrycachebytesize-function-rgl-geometrycachebytesize-src-r-gl-ml-1095005710"></a>
### RGL_GeometryCacheByteSize

```ml
function RGL_GeometryCacheByteSize()
```

Computes the exact serialized byte count for the cache header and all quad/triangle record collections.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_gl.ml#L1811)

<a id="function-function-rgl-geomtofloat-inline-function-rgl-geomtofloat-v-src-r-gl-ml-1367197795"></a>
### RGL_GeomToFloat

```ml
inline function RGL_GeomToFloat(v)
```

Restores a serialized fixed-scale geometry component to floating-point world units.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `v` | `dynamic` | — | Value consumed by the operation. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_gl.ml#L1496)

<a id="function-function-rgl-groupcachedflattrisbytexture-function-rgl-groupcachedflattrisbytexture-tris-src-r-gl-ml-1412793798"></a>
### RGL_GroupCachedFlatTrisByTexture

```ml
function RGL_GroupCachedFlatTrisByTexture(tris)
```

Groups cached flat triangles by flat texture once so immediate-mode batches are larger.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `tris` | `dynamic` | — | Tris value supplied to `RGL_GroupCachedFlatTrisByTexture`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_gl.ml#L740)

<a id="function-function-rgl-groupcachedquadsbytexture-function-rgl-groupcachedquadsbytexture-quads-src-r-gl-ml-1518540832"></a>
### RGL_GroupCachedQuadsByTexture

```ml
function RGL_GroupCachedQuadsByTexture(quads)
```

Groups opaque cached quads by texture once so immediate-mode batches are larger.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `quads` | `dynamic` | — | Quads value supplied to `RGL_GroupCachedQuadsByTexture`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_gl.ml#L698)

<a id="function-function-rgl-groupflattrisforarraybatches-function-rgl-groupflattrisforarraybatches-tris-src-r-gl-ml-1761151926"></a>
### RGL_GroupFlatTrisForArrayBatches

```ml
function RGL_GroupFlatTrisForArrayBatches(tris)
```

Groups cached flat triangles by texture and coarse spatial cell for fewer visible draw calls.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `tris` | `dynamic` | — | Tris value supplied to `RGL_GroupFlatTrisForArrayBatches`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_gl.ml#L669)

<a id="function-function-rgl-groupopaquegeometryforbatches-function-rgl-groupopaquegeometryforbatches-src-r-gl-ml-1760736466"></a>
### RGL_GroupOpaqueGeometryForBatches

```ml
function RGL_GroupOpaqueGeometryForBatches()
```

Prepares static opaque world lists for larger OpenGL immediate-mode batches.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_gl.ml#L780)

<a id="function-function-rgl-groupwallquadsforarraybatches-function-rgl-groupwallquadsforarraybatches-quads-src-r-gl-ml-565545984"></a>
### RGL_GroupWallQuadsForArrayBatches

```ml
function RGL_GroupWallQuadsForArrayBatches(quads)
```

Groups cached wall quads by texture and coarse spatial cell for fewer visible draw calls.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `quads` | `dynamic` | — | Quads value supplied to `RGL_GroupWallQuadsForArrayBatches`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_gl.ml#L640)

<a id="function-function-rgl-hasactivesectormotion-function-rgl-hasactivesectormotion-src-r-gl-ml-93025980"></a>
### RGL_HasActiveSectorMotion

```ml
function RGL_HasActiveSectorMotion()
```

Checks whether a sector thinker is currently moving world geometry.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_gl.ml#L2372)

<a id="function-function-rgl-isnumber-inline-function-rgl-isnumber-v-src-r-gl-ml-825151071"></a>
### RGL_IsNumber

```ml
inline function RGL_IsNumber(v)
```

Checks numeric values before packing cached OpenGL geometry.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `v` | `dynamic` | — | Value consumed by the operation. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_gl.ml#L535)

<a id="function-function-rgl-isseq-inline-function-rgl-isseq-v-src-r-gl-ml-513682671"></a>
### RGL_IsSeq

```ml
inline function RGL_IsSeq(v)
```

Recognizes the array and list containers accepted by renderer geometry and map tables.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `v` | `dynamic` | — | Value consumed by the operation. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_gl.ml#L529)

<a id="function-function-rgl-isvalidflattri-inline-function-rgl-isvalidflattri-t-src-r-gl-ml-723324843"></a>
### RGL_IsValidFlatTri

```ml
inline function RGL_IsValidFlatTri(t)
```

Rejects malformed cached flat triangles before array batching.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `t` | `dynamic` | — | T value supplied to `RGL_IsValidFlatTri`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_gl.ml#L541)

<a id="function-function-rgl-isvolatilelineindex-function-rgl-isvolatilelineindex-idx-src-r-gl-ml-1683321463"></a>
### RGL_IsVolatileLineIndex

```ml
function RGL_IsVolatileLineIndex(idx)
```

Checks whether a line touches dynamic sector geometry.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `idx` | `dynamic` | — | Zero-based element or table index. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_gl.ml#L1683)

<a id="function-function-rgl-isvolatilesector-function-rgl-isvolatilesector-sec-src-r-gl-ml-2005993413"></a>
### RGL_IsVolatileSector

```ml
function RGL_IsVolatileSector(sec)
```

Returns true for sectors that may move or need uncached wall/flat updates.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `sec` | `dynamic` | — | Sec value supplied to `RGL_IsVolatileSector`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_gl.ml#L1653)

<a id="function-function-rgl-isvolatilesegindex-function-rgl-isvolatilesegindex-idx-src-r-gl-ml-77709699"></a>
### RGL_IsVolatileSegIndex

```ml
function RGL_IsVolatileSegIndex(idx)
```

Checks whether a seg touches dynamic sector geometry.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `idx` | `dynamic` | — | Zero-based element or table index. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_gl.ml#L1672)

<a id="function-function-rgl-isvolatilesubsectorindex-function-rgl-isvolatilesubsectorindex-idx-src-r-gl-ml-1881339303"></a>
### RGL_IsVolatileSubsectorIndex

```ml
function RGL_IsVolatileSubsectorIndex(idx)
```

Checks whether a subsector belongs to dynamic sector geometry.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `idx` | `dynamic` | — | Zero-based element or table index. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_gl.ml#L1663)

<a id="global-global-rgl-light-geom-blob-rgl-light-geom-blob-src-r-gl-ml-2138729854"></a>
### rgl_light_geom_blob

```ml
rgl_light_geom_blob
```

Tracks the mutable rgl light geom blob value used by the r gl subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_gl.ml#L262)

<a id="constant-constant-rgl-light-record-size-const-rgl-light-record-size-32-src-r-gl-ml-286107498"></a>
### RGL_LIGHT_RECORD_SIZE

```ml
const RGL_LIGHT_RECORD_SIZE = 32
```

Defines rgl light record size for the r gl subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_gl.ml#L329)

<a id="function-function-rgl-lightbyte-inline-function-rgl-lightbyte-sec-src-r-gl-ml-2116814086"></a>
### RGL_LightByte

```ml
inline function RGL_LightByte(sec)
```

Maps a sector light level into the renderer's restrained 12-through-198 static brightness range.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `sec` | `dynamic` | — | Sec value supplied to `RGL_LightByte`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_gl.ml#L2362)

<a id="function-function-rgl-linemaymovegeometry-function-rgl-linemaymovegeometry-li-src-r-gl-ml-1815854389"></a>
### RGL_LineMayMoveGeometry

```ml
function RGL_LineMayMoveGeometry(li)
```

Returns true for Doom line specials that start, resume, or stop moving floors, ceilings, doors, or platforms.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `li` | `dynamic` | — | Li value supplied to `RGL_LineMayMoveGeometry`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_gl.ml#L1621)

<a id="function-function-rgl-linescrollstexture-inline-function-rgl-linescrollstexture-li-src-r-gl-ml-1682041308"></a>
### RGL_LineScrollsTexture

```ml
inline function RGL_LineScrollsTexture(li)
```

Identifies Doom's continuously scrolling wall special so it can bypass static UV caches.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `li` | `dynamic` | — | Li value supplied to `RGL_LineScrollsTexture`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_gl.ml#L1647)

<a id="function-function-rgl-liquidlightkind-function-rgl-liquidlightkind-flatnum-src-r-gl-ml-1708983161"></a>
### RGL_LiquidLightKind

```ml
function RGL_LiquidLightKind(flatnum)
```

Classifies animated liquid flats that should emit subtle GL ambience.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `flatnum` | `dynamic` | — | Index identifying flat. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_gl.ml#L2505)

<a id="function-function-rgl-lowertexturemid-function-rgl-lowertexturemid-linedef-texnum-side-front-back-src-r-gl-ml-1497592649"></a>
### RGL_LowerTextureMid

```ml
function RGL_LowerTextureMid(linedef, texnum, side, front, back)
```

Computes the lower wall texture origin from pegging flags, adjacent floors/ceiling, texture height, and row offset.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `linedef` | `dynamic` | — | Linedef value supplied to `RGL_LowerTextureMid`. |
| `texnum` | `dynamic` | — | Index identifying tex. |
| `side` | `dynamic` | — | Map side affected by the operation. |
| `front` | `dynamic` | — | Front value supplied to `RGL_LowerTextureMid`. |
| `back` | `dynamic` | — | Back value supplied to `RGL_LowerTextureMid`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_gl.ml#L3370)

<a id="function-function-rgl-lumpnameat-function-rgl-lumpnameat-lumpnum-src-r-gl-ml-16873268"></a>
### RGL_LumpNameAt

```ml
function RGL_LumpNameAt(lumpnum)
```

Decodes the zero-terminated name of a validated lump directory entry.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `lumpnum` | `dynamic` | — | Index identifying lump. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_gl.ml#L3055)

<a id="function-function-rgl-mapgeomlumpname-function-rgl-mapgeomlumpname-src-r-gl-ml-1913699386"></a>
### RGL_MapGeomLumpName

```ml
function RGL_MapGeomLumpName()
```

Formats the current map's derived geometry-cache lump name as MAPxxGL or ExMxGL.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_gl.ml#L1501)

<a id="function-function-rgl-markvolatilesector-function-rgl-markvolatilesector-sec-src-r-gl-ml-2137363329"></a>
### RGL_MarkVolatileSector

```ml
function RGL_MarkVolatileSector(sec)
```

Resolves a sector reference by identity and marks its index for dynamic rendering outside the static cache.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `sec` | `dynamic` | — | Sec value supplied to `RGL_MarkVolatileSector`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_gl.ml#L1613)

<a id="function-function-rgl-markvolatilesectorindex-function-rgl-markvolatilesectorindex-idx-src-r-gl-ml-1655000321"></a>
### RGL_MarkVolatileSectorIndex

```ml
function RGL_MarkVolatileSectorIndex(idx)
```

Marks a sector as dynamic so it is drawn outside the static GL cache.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `idx` | `dynamic` | — | Zero-based element or table index. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_gl.ml#L1604)

<a id="global-global-rgl-masked-array-batches-rgl-masked-array-batches-src-r-gl-ml-1208819478"></a>
### rgl_masked_array_batches

```ml
rgl_masked_array_batches
```

Stores the rgl masked array batches collection used by the r gl subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_gl.ml#L202)

<a id="global-global-rgl-masked-display-list-id-rgl-masked-display-list-id-src-r-gl-ml-855766368"></a>
### rgl_masked_display_list_id

```ml
rgl_masked_display_list_id
```

Tracks the mutable rgl masked display list id value used by the r gl subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_gl.ml#L192)

<a id="global-global-rgl-masked-native-record-count-rgl-masked-native-record-count-src-r-gl-ml-20775452"></a>
### rgl_masked_native_record_count

```ml
rgl_masked_native_record_count
```

Tracks the mutable rgl masked native record count value used by the r gl subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_gl.ml#L254)

<a id="global-global-rgl-masked-native-records-rgl-masked-native-records-src-r-gl-ml-1247699910"></a>
### rgl_masked_native_records

```ml
rgl_masked_native_records
```

Tracks the mutable rgl masked native records value used by the r gl subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_gl.ml#L248)

<a id="global-global-rgl-masked-native-texture-revision-rgl-masked-native-texture-revision-src-r-gl-ml-890357484"></a>
### rgl_masked_native_texture_revision

```ml
rgl_masked_native_texture_revision
```

Tracks the mutable rgl masked native texture revision value used by the r gl subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_gl.ml#L260)

<a id="global-global-rgl-masked-quads-rgl-masked-quads-src-r-gl-ml-927094006"></a>
### rgl_masked_quads

```ml
rgl_masked_quads
```

Stores the rgl masked quads collection used by the r gl subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_gl.ml#L172)

<a id="constant-constant-rgl-max-dynamic-lights-const-rgl-max-dynamic-lights-48-src-r-gl-ml-1882365437"></a>
### RGL_MAX_DYNAMIC_LIGHTS

```ml
const RGL_MAX_DYNAMIC_LIGHTS = 48
```

Defines the maximum rgl max dynamic lights accepted by the r gl subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_gl.ml#L306)

<a id="constant-constant-rgl-max-surface-lights-const-rgl-max-surface-lights-24-src-r-gl-ml-1335208911"></a>
### RGL_MAX_SURFACE_LIGHTS

```ml
const RGL_MAX_SURFACE_LIGHTS = 24
```

Defines the maximum rgl max surface lights accepted by the r gl subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_gl.ml#L333)

<a id="function-function-rgl-midtexturemid-function-rgl-midtexturemid-linedef-texnum-side-front-back-src-r-gl-ml-675030083"></a>
### RGL_MidTextureMid

```ml
function RGL_MidTextureMid(linedef, texnum, side, front, back)
```

Computes one- or two-sided middle-texture origin according to bottom pegging and the visible opening bounds.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `linedef` | `dynamic` | — | Linedef value supplied to `RGL_MidTextureMid`. |
| `texnum` | `dynamic` | — | Index identifying tex. |
| `side` | `dynamic` | — | Map side affected by the operation. |
| `front` | `dynamic` | — | Front value supplied to `RGL_MidTextureMid`. |
| `back` | `dynamic` | — | Back value supplied to `RGL_MidTextureMid`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_gl.ml#L3385)

<a id="function-function-rgl-midtextureorzero-inline-function-rgl-midtextureorzero-side-src-r-gl-ml-1896246754"></a>
### RGL_MidTextureOrZero

```ml
inline function RGL_MidTextureOrZero(side)
```

Reads a sidedef's middle texture number, returning zero for missing data.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `side` | `dynamic` | — | Map side affected by the operation. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_gl.ml#L3707)

<a id="function-function-rgl-mobjdecorlight-function-rgl-mobjdecorlight-mo-x-z-src-r-gl-ml-1730875410"></a>
### RGL_MobjDecorLight

```ml
function RGL_MobjDecorLight(mo, x, z)
```

Adds subtle OpenGL light from decorative light-emitting map objects.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `mo` | `dynamic` | — | Map object affected by the operation. |
| `x` | `dynamic` | — | Horizontal map- or screen-space coordinate. |
| `z` | `dynamic` | — | Vertical world-space coordinate. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_gl.ml#L2608)

<a id="function-function-rgl-mobjexplosionlight-function-rgl-mobjexplosionlight-mo-x-y-z-src-r-gl-ml-709488215"></a>
### RGL_MobjExplosionLight

```ml
function RGL_MobjExplosionLight(mo, x, y, z)
```

Adds short, bright OpenGL lights for explosion animation states.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `mo` | `dynamic` | — | Map object affected by the operation. |
| `x` | `dynamic` | — | Horizontal map- or screen-space coordinate. |
| `y` | `dynamic` | — | Vertical map- or screen-space coordinate. |
| `z` | `dynamic` | — | Vertical world-space coordinate. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_gl.ml#L2682)

<a id="function-function-rgl-mobjlight-function-rgl-mobjlight-mo-src-r-gl-ml-265720384"></a>
### RGL_MobjLight

```ml
function RGL_MobjLight(mo)
```

Classifies a mobj's type/state and emits the matching projectile, explosion, muzzle, or decorative dynamic light.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `mo` | `dynamic` | — | Map object affected by the operation. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_gl.ml#L2727)

<a id="constant-constant-rgl-native-batch-record-size-const-rgl-native-batch-record-size-28-src-r-gl-ml-1142054383"></a>
### RGL_NATIVE_BATCH_RECORD_SIZE

```ml
const RGL_NATIVE_BATCH_RECORD_SIZE = 28
```

Defines rgl native batch record size for the r gl subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_gl.ml#L327)

<a id="function-function-rgl-normalizedegrees-function-rgl-normalizedegrees-d-src-r-gl-ml-750737818"></a>
### RGL_NormalizeDegrees

```ml
function RGL_NormalizeDegrees(d)
```

Wraps an arbitrary degree value into the half-open [0,360) interval.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `d` | `dynamic` | — | Divisor or direction value used by the operation. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_gl.ml#L2326)

<a id="function-function-rgl-oppositeside-function-rgl-oppositeside-linedef-side-src-r-gl-ml-537716784"></a>
### RGL_OppositeSide

```ml
function RGL_OppositeSide(linedef, side)
```

Resolves the sidedef opposite a known line side, with validation of both sidenum entries.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `linedef` | `dynamic` | — | Linedef value supplied to `RGL_OppositeSide`. |
| `side` | `dynamic` | — | Map side affected by the operation. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_gl.ml#L3671)

<a id="function-function-rgl-packnativesprite-inline-function-rgl-packnativesprite-mo-lump-flip-records-recordindex-src-r-gl-ml-1659369073"></a>
### RGL_PackNativeSprite

```ml
inline function RGL_PackNativeSprite(mo, lump, flip, records, recordIndex)
```

Resolves and packs one visible mobj while caching immutable patch metrics.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `mo` | `dynamic` | — | Map object affected by the operation. |
| `lump` | `dynamic` | — | Lump value supplied to `RGL_PackNativeSprite`. |
| `flip` | `dynamic` | — | Flip value supplied to `RGL_PackNativeSprite`. |
| `records` | `dynamic` | — | Records value supplied to `RGL_PackNativeSprite`. |
| `recordIndex` | `dynamic` | — | Index identifying record. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_gl.ml#L5662)

<a id="global-global-rgl-palette-revision-seen-rgl-palette-revision-seen-src-r-gl-ml-137565918"></a>
### rgl_palette_revision_seen

```ml
rgl_palette_revision_seen
```

Tracks the mutable rgl palette revision seen value used by the r gl subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_gl.ml#L72)

<a id="global-global-rgl-pending-sig-sector-motion-rgl-pending-sig-sector-motion-src-r-gl-ml-562825458"></a>
### rgl_pending_sig_sector_motion

```ml
rgl_pending_sig_sector_motion
```

Tracks the mutable rgl pending sig sector motion value used by the r gl subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_gl.ml#L108)

<a id="global-global-rgl-pending-sig-sides-rgl-pending-sig-sides-src-r-gl-ml-321414782"></a>
### rgl_pending_sig_sides

```ml
rgl_pending_sig_sides
```

Tracks the mutable rgl pending sig sides value used by the r gl subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_gl.ml#L110)

<a id="global-global-rgl-pending-stable-frames-rgl-pending-stable-frames-src-r-gl-ml-1623054442"></a>
### rgl_pending_stable_frames

```ml
rgl_pending_stable_frames
```

Tracks the mutable rgl pending stable frames value used by the r gl subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_gl.ml#L112)

<a id="function-function-rgl-playernearactivesectormotion-function-rgl-playernearactivesectormotion-player-src-r-gl-ml-41975447"></a>
### RGL_PlayerNearActiveSectorMotion

```ml
function RGL_PlayerNearActiveSectorMotion(player)
```

Uses the accurate direct renderer when the player is near moving sectors.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `player` | `dynamic` | — | Player state affected by the operation. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_gl.ml#L2414)

<a id="function-function-rgl-pointintriangle-function-rgl-pointintriangle-px-py-ax-ay-bx-by-cx-cy-src-r-gl-ml-324802258"></a>
### RGL_PointInTriangle

```ml
function RGL_PointInTriangle(px, py, ax, ay, bx, by, cx, cy)
```

Tests whether a fixed-point point lies inside or on a triangle using sign-consistent edge cross products.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `px` | `dynamic` | — | Horizontal coordinate or vector component represented by px. |
| `py` | `dynamic` | — | Vertical coordinate or vector component represented by py. |
| `ax` | `dynamic` | — | Horizontal coordinate or vector component represented by ax. |
| `ay` | `dynamic` | — | Vertical coordinate or vector component represented by ay. |
| `bx` | `dynamic` | — | Horizontal coordinate or vector component represented by bx. |
| `by` | `dynamic` | — | Vertical coordinate or vector component represented by by. |
| `cx` | `dynamic` | — | Horizontal coordinate or vector component represented by cx. |
| `cy` | `dynamic` | — | Vertical coordinate or vector component represented by cy. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_gl.ml#L4117)

<a id="function-function-rgl-profileend-inline-function-rgl-profileend-slot-start-src-r-gl-ml-2099037123"></a>
### RGL_ProfileEnd

```ml
inline function RGL_ProfileEnd(slot, start)
```

Adds elapsed time to one fine-grained renderer profiling slot.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `slot` | `dynamic` | — | Slot value supplied to `RGL_ProfileEnd`. |
| `start` | `dynamic` | — | Start value supplied to `RGL_ProfileEnd`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_gl.ml#L6848)

<a id="function-function-rgl-profilestart-inline-function-rgl-profilestart-src-r-gl-ml-741110349"></a>
### RGL_ProfileStart

```ml
inline function RGL_ProfileStart()
```

Returns a timestamp for fine-grained renderer profiling.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_gl.ml#L6837)

- [rgl_quad_t](Type-rgl-quad-t-782636751.md) — struct
<a id="function-function-rgl-readgeomdepthquad-function-rgl-readgeomdepthquad-buf-off-src-r-gl-ml-1574698482"></a>
### RGL_ReadGeomDepthQuad

```ml
function RGL_ReadGeomDepthQuad(buf, off)
```

Deserializes one depth-only quad and returns it with the next unread offset.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `buf` | `dynamic` | — | Buf value supplied to `RGL_ReadGeomDepthQuad`. |
| `off` | `dynamic` | — | Zero-based byte or element offset. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_gl.ml#L2060)

<a id="function-function-rgl-readgeomdepthtri-function-rgl-readgeomdepthtri-buf-off-src-r-gl-ml-1079784154"></a>
### RGL_ReadGeomDepthTri

```ml
function RGL_ReadGeomDepthTri(buf, off)
```

Deserializes one depth-only triangle and returns it with the next unread offset.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `buf` | `dynamic` | — | Buf value supplied to `RGL_ReadGeomDepthTri`. |
| `off` | `dynamic` | — | Zero-based byte or element offset. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_gl.ml#L2015)

<a id="function-function-rgl-readgeomflattri-function-rgl-readgeomflattri-buf-off-src-r-gl-ml-1913287410"></a>
### RGL_ReadGeomFlatTri

```ml
function RGL_ReadGeomFlatTri(buf, off)
```

Deserializes one flat triangle and returns it together with the next unread byte offset.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `buf` | `dynamic` | — | Buf value supplied to `RGL_ReadGeomFlatTri`. |
| `off` | `dynamic` | — | Zero-based byte or element offset. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_gl.ml#L1957)

<a id="function-function-rgl-readgeomquad-function-rgl-readgeomquad-buf-off-src-r-gl-ml-1705546974"></a>
### RGL_ReadGeomQuad

```ml
function RGL_ReadGeomQuad(buf, off)
```

Deserializes one textured quad and returns it together with the next unread byte offset.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `buf` | `dynamic` | — | Buf value supplied to `RGL_ReadGeomQuad`. |
| `off` | `dynamic` | — | Zero-based byte or element offset. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_gl.ml#L1877)

<a id="function-function-rgl-reads32-inline-function-rgl-reads32-buf-off-src-r-gl-ml-85703707"></a>
### RGL_ReadS32

```ml
inline function RGL_ReadS32(buf, off)
```

Decodes a little-endian 32-bit value and restores its signed interpretation.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `buf` | `dynamic` | — | Buf value supplied to `RGL_ReadS32`. |
| `off` | `dynamic` | — | Zero-based byte or element offset. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_gl.ml#L1480)

<a id="function-function-rgl-readu32-inline-function-rgl-readu32-buf-off-src-r-gl-ml-789621479"></a>
### RGL_ReadU32

```ml
inline function RGL_ReadU32(buf, off)
```

Decodes an unsigned little-endian 32-bit value from serialized geometry bytes.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `buf` | `dynamic` | — | Buf value supplied to `RGL_ReadU32`. |
| `off` | `dynamic` | — | Zero-based byte or element offset. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_gl.ml#L1473)

<a id="function-function-rgl-rebuildnativearraybatchrecords-function-rgl-rebuildnativearraybatchrecords-src-r-gl-ml-1577331416"></a>
### RGL_RebuildNativeArrayBatchRecords

```ml
function RGL_RebuildNativeArrayBatchRecords()
```

Builds native helper draw-record buffers for VBO-backed static geometry batches.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_gl.ml#L1087)

<a id="function-function-rgl-rebuildscrollingarraybatches-function-rgl-rebuildscrollingarraybatches-currenttic-currentmap-currentleveltime-src-r-gl-ml-83585002"></a>
### RGL_RebuildScrollingArrayBatches

```ml
function RGL_RebuildScrollingArrayBatches(currentTic, currentMap, currentLevelTime)
```

Uploads one game tic's scrolling wall geometry while preserving static caches.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `currentTic` | `dynamic` | — | Current tic value supplied to `RGL_RebuildScrollingArrayBatches`. |
| `currentMap` | `dynamic` | — | Current map value supplied to `RGL_RebuildScrollingArrayBatches`. |
| `currentLevelTime` | `dynamic` | — | Current level time value supplied to `RGL_RebuildScrollingArrayBatches`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_gl.ml#L6239)

<a id="function-function-rgl-rebuildvolatilearraybatches-function-rgl-rebuildvolatilearraybatches-signature-src-r-gl-ml-1123026004"></a>
### RGL_RebuildVolatileArrayBatches

```ml
function RGL_RebuildVolatileArrayBatches(signature)
```

Uploads the current volatile meshes to VBOs while preserving the static cache state.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `signature` | `dynamic` | — | Signature value supplied to `RGL_RebuildVolatileArrayBatches`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_gl.ml#L6436)

<a id="function-function-rgl-renderplayerview-function-rgl-renderplayerview-player-src-r-gl-ml-266226311"></a>
### RGL_RenderPlayerView

```ml
function RGL_RenderPlayerView(player)
```

Sets the interpolated camera, updates caches/lights, executes ordered opaque/sprite/masked passes, and presents one GL view.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `player` | `dynamic` | — | Player state affected by the operation. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_gl.ml#L6860)

<a id="function-function-rgl-resetscrollingarraybatches-function-rgl-resetscrollingarraybatches-src-r-gl-ml-1809248328"></a>
### RGL_ResetScrollingArrayBatches

```ml
function RGL_ResetScrollingArrayBatches()
```

Releases cached geometry for continuously scrolling walls.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_gl.ml#L896)

<a id="function-function-rgl-resetstaticarraybatches-function-rgl-resetstaticarraybatches-src-r-gl-ml-1374214140"></a>
### RGL_ResetStaticArrayBatches

```ml
function RGL_ResetStaticArrayBatches()
```

Invalidates prepacked OpenGL client-array batches after geometry changes.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_gl.ml#L927)

<a id="function-function-rgl-resetstaticdisplaylists-function-rgl-resetstaticdisplaylists-src-r-gl-ml-762068620"></a>
### RGL_ResetStaticDisplayLists

```ml
function RGL_ResetStaticDisplayLists()
```

Invalidates compiled static geometry after map geometry changes.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_gl.ml#L828)

<a id="function-function-rgl-resetvolatilearraybatches-function-rgl-resetvolatilearraybatches-src-r-gl-ml-733126740"></a>
### RGL_ResetVolatileArrayBatches

```ml
function RGL_ResetVolatileArrayBatches()
```

Invalidates VBO batches generated from potentially moving sector geometry.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_gl.ml#L850)

<a id="function-function-rgl-resolveflatnum-inline-function-rgl-resolveflatnum-flatnum-src-r-gl-ml-143244174"></a>
### RGL_ResolveFlatNum

```ml
inline function RGL_ResolveFlatNum(flatnum)
```

Resolves Doom flat animation translation for OpenGL flat binding.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `flatnum` | `dynamic` | — | Index identifying flat. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_gl.ml#L3137)

<a id="function-function-rgl-resolvetexturenum-inline-function-rgl-resolvetexturenum-texnum-src-r-gl-ml-478404120"></a>
### RGL_ResolveTextureNum

```ml
inline function RGL_ResolveTextureNum(texnum)
```

Resolves Doom texture animation translation for OpenGL texture binding.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `texnum` | `dynamic` | — | Index identifying tex. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_gl.ml#L3125)

<a id="function-function-rgl-restore3dprojection-function-rgl-restore3dprojection-src-r-gl-ml-1233739036"></a>
### RGL_Restore3DProjection

```ml
function RGL_Restore3DProjection()
```

Rebuilds the perspective frustum and identity model-view matrix after screen-space sky or weapon drawing.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_gl.ml#L5351)

<a id="global-global-rgl-scrolling-array-batches-ready-rgl-scrolling-array-batches-ready-src-r-gl-ml-1634881878"></a>
### rgl_scrolling_array_batches_ready

```ml
rgl_scrolling_array_batches_ready
```

Tracks whether rgl scrolling array batches ready is active in the r gl subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_gl.ml#L162)

<a id="global-global-rgl-scrolling-geometry-last-gametic-rgl-scrolling-geometry-last-gametic-src-r-gl-ml-1889115910"></a>
### rgl_scrolling_geometry_last_gametic

```ml
rgl_scrolling_geometry_last_gametic
```

Tracks the mutable rgl scrolling geometry last gametic value used by the r gl subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_gl.ml#L156)

<a id="global-global-rgl-scrolling-geometry-last-leveltime-rgl-scrolling-geometry-last-leveltime-src-r-gl-ml-1449659250"></a>
### rgl_scrolling_geometry_last_leveltime

```ml
rgl_scrolling_geometry_last_leveltime
```

Tracks the mutable rgl scrolling geometry last leveltime value used by the r gl subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_gl.ml#L160)

<a id="global-global-rgl-scrolling-geometry-last-map-rgl-scrolling-geometry-last-map-src-r-gl-ml-95904678"></a>
### rgl_scrolling_geometry_last_map

```ml
rgl_scrolling_geometry_last_map
```

Tracks the mutable rgl scrolling geometry last map value used by the r gl subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_gl.ml#L158)

<a id="global-global-rgl-scrolling-lines-rgl-scrolling-lines-src-r-gl-ml-1417445350"></a>
### rgl_scrolling_lines

```ml
rgl_scrolling_lines
```

Stores the rgl scrolling lines collection used by the r gl subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_gl.ml#L134)

<a id="global-global-rgl-scrolling-masked-array-batches-rgl-scrolling-masked-array-batches-src-r-gl-ml-535342134"></a>
### rgl_scrolling_masked_array_batches

```ml
rgl_scrolling_masked_array_batches
```

Stores the rgl scrolling masked array batches collection used by the r gl subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_gl.ml#L142)

<a id="global-global-rgl-scrolling-masked-native-record-count-rgl-scrolling-masked-native-record-count-src-r-gl-ml-1602715520"></a>
### rgl_scrolling_masked_native_record_count

```ml
rgl_scrolling_masked_native_record_count
```

Tracks the mutable rgl scrolling masked native record count value used by the r gl subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_gl.ml#L150)

<a id="global-global-rgl-scrolling-masked-native-records-rgl-scrolling-masked-native-records-src-r-gl-ml-1598505254"></a>
### rgl_scrolling_masked_native_records

```ml
rgl_scrolling_masked_native_records
```

Tracks the mutable rgl scrolling masked native records value used by the r gl subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_gl.ml#L146)

<a id="global-global-rgl-scrolling-masked-texture-revision-rgl-scrolling-masked-texture-revision-src-r-gl-ml-631016834"></a>
### rgl_scrolling_masked_texture_revision

```ml
rgl_scrolling_masked_texture_revision
```

Tracks the mutable rgl scrolling masked texture revision value used by the r gl subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_gl.ml#L154)

<a id="global-global-rgl-scrolling-segs-rgl-scrolling-segs-src-r-gl-ml-1167611030"></a>
### rgl_scrolling_segs

```ml
rgl_scrolling_segs
```

Stores the rgl scrolling segs collection used by the r gl subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_gl.ml#L132)

<a id="global-global-rgl-scrolling-sides-rgl-scrolling-sides-src-r-gl-ml-1816510518"></a>
### rgl_scrolling_sides

```ml
rgl_scrolling_sides
```

Stores the rgl scrolling sides collection used by the r gl subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_gl.ml#L136)

<a id="global-global-rgl-scrolling-wall-array-batches-rgl-scrolling-wall-array-batches-src-r-gl-ml-1292852116"></a>
### rgl_scrolling_wall_array_batches

```ml
rgl_scrolling_wall_array_batches
```

Stores the rgl scrolling wall array batches collection used by the r gl subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_gl.ml#L140)

<a id="global-global-rgl-scrolling-wall-native-record-count-rgl-scrolling-wall-native-record-count-src-r-gl-ml-835573942"></a>
### rgl_scrolling_wall_native_record_count

```ml
rgl_scrolling_wall_native_record_count
```

Tracks the mutable rgl scrolling wall native record count value used by the r gl subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_gl.ml#L148)

<a id="global-global-rgl-scrolling-wall-native-records-rgl-scrolling-wall-native-records-src-r-gl-ml-121324398"></a>
### rgl_scrolling_wall_native_records

```ml
rgl_scrolling_wall_native_records
```

Tracks the mutable rgl scrolling wall native records value used by the r gl subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_gl.ml#L144)

<a id="global-global-rgl-scrolling-wall-texture-revision-rgl-scrolling-wall-texture-revision-src-r-gl-ml-1281179734"></a>
### rgl_scrolling_wall_texture_revision

```ml
rgl_scrolling_wall_texture_revision
```

Tracks the mutable rgl scrolling wall texture revision value used by the r gl subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_gl.ml#L152)

<a id="function-function-rgl-sectorindex-function-rgl-sectorindex-sec-src-r-gl-ml-894431153"></a>
### RGL_SectorIndex

```ml
function RGL_SectorIndex(sec)
```

Finds the current map index for a sector reference.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `sec` | `dynamic` | — | Sec value supplied to `RGL_SectorIndex`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_gl.ml#L1592)

<a id="function-function-rgl-sectormotionsignature-function-rgl-sectormotionsignature-src-r-gl-ml-2062079532"></a>
### RGL_SectorMotionSignature

```ml
function RGL_SectorMotionSignature()
```

Hashes sector floor/ceiling heights for geometry invalidation while deliberately excluding light flicker.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_gl.ml#L1529)

<a id="function-function-rgl-sectornearfixedpoint-function-rgl-sectornearfixedpoint-sec-x-y-radius-src-r-gl-ml-854166790"></a>
### RGL_SectorNearFixedPoint

```ml
function RGL_SectorNearFixedPoint(sec, x, y, radius)
```

Checks whether a sector is near a fixed-point map coordinate.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `sec` | `dynamic` | — | Sec value supplied to `RGL_SectorNearFixedPoint`. |
| `x` | `dynamic` | — | Horizontal map- or screen-space coordinate. |
| `y` | `dynamic` | — | Vertical map- or screen-space coordinate. |
| `radius` | `dynamic` | — | Radius value supplied to `RGL_SectorNearFixedPoint`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_gl.ml#L2388)

<a id="function-function-rgl-sectortouchesskyceiling-function-rgl-sectortouchesskyceiling-sec-src-r-gl-ml-1637146975"></a>
### RGL_SectorTouchesSkyCeiling

```ml
function RGL_SectorTouchesSkyCeiling(sec)
```

Reports whether any sector-adjacent line leads to another sector whose ceiling uses the sky flat.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `sec` | `dynamic` | — | Sec value supplied to `RGL_SectorTouchesSkyCeiling`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_gl.ml#L5078)

<a id="function-function-rgl-segtextureoffset-function-rgl-segtextureoffset-sg-opposite-src-r-gl-ml-135481933"></a>
### RGL_SegTextureOffset

```ml
function RGL_SegTextureOffset(sg, opposite)
```

Returns a seg's map-authored texture distance, or the complementary distance when drawing the opposite orientation.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `sg` | `dynamic` | — | Sg value supplied to `RGL_SegTextureOffset`. |
| `opposite` | `dynamic` | — | Opposite value supplied to `RGL_SegTextureOffset`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_gl.ml#L3652)

<a id="function-function-rgl-selectspritelump-function-rgl-selectspritelump-thing-player-src-r-gl-ml-139702549"></a>
### RGL_SelectSpriteLump

```ml
function RGL_SelectSpriteLump(thing, player)
```

Resolves an mobj frame and view-relative rotation to its relative sprite lump and horizontal flip flag.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `thing` | `dynamic` | — | World object affected by the operation. |
| `player` | `dynamic` | — | Player state affected by the operation. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_gl.ml#L5498)

<a id="function-function-rgl-seqlen-inline-function-rgl-seqlen-v-src-r-gl-ml-638602229"></a>
### RGL_SeqLen

```ml
inline function RGL_SeqLen(v)
```

Returns a supported sequence length or -1 so cache signatures can distinguish absent data.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `v` | `dynamic` | — | Value consumed by the operation. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_gl.ml#L556)

<a id="function-function-rgl-serializegeometrycache-function-rgl-serializegeometrycache-sigmap-sigsegs-siglines-signodes-sigsubsectors-sigsectormotion-sigsides-src-r-gl-ml-1966671242"></a>
### RGL_SerializeGeometryCache

```ml
function RGL_SerializeGeometryCache(sigMap, sigSegs, sigLines, sigNodes, sigSubsectors, sigSectorMotion, sigSides)
```

Writes signatures, collection counts, and every cached geometry record into the versioned MGL1 blob.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `sigMap` | `dynamic` | — | Sig map value supplied to `RGL_SerializeGeometryCache`. |
| `sigSegs` | `dynamic` | — | Sig segs value supplied to `RGL_SerializeGeometryCache`. |
| `sigLines` | `dynamic` | — | Sig lines value supplied to `RGL_SerializeGeometryCache`. |
| `sigNodes` | `dynamic` | — | Sig nodes value supplied to `RGL_SerializeGeometryCache`. |
| `sigSubsectors` | `dynamic` | — | Sig subsectors value supplied to `RGL_SerializeGeometryCache`. |
| `sigSectorMotion` | `dynamic` | — | Sig sector motion value supplied to `RGL_SerializeGeometryCache`. |
| `sigSides` | `dynamic` | — | Sig sides value supplied to `RGL_SerializeGeometryCache`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_gl.ml#L2096)

<a id="function-function-rgl-setforcesoftware-function-rgl-setforcesoftware-v-src-r-gl-ml-997919776"></a>
### RGL_SetForceSoftware

```ml
function RGL_SetForceSoftware(v)
```

Enables or clears the explicit software-renderer override from a validated boolean input.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `v` | `dynamic` | — | Value consumed by the operation. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_gl.ml#L520)

<a id="function-function-rgl-setvertexlight-function-rgl-setvertexlight-base-x-y-z-src-r-gl-ml-461572574"></a>
### RGL_SetVertexLight

```ml
function RGL_SetVertexLight(base, x, y, z)
```

Evaluates view fade and nearby dynamic lights at a world vertex, then sets an opaque OpenGL color.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `base` | `dynamic` | — | Base value supplied to `RGL_SetVertexLight`. |
| `x` | `dynamic` | — | Horizontal map- or screen-space coordinate. |
| `y` | `dynamic` | — | Vertical map- or screen-space coordinate. |
| `z` | `dynamic` | — | Vertical world-space coordinate. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_gl.ml#L2925)

<a id="function-function-rgl-setvertexlightalpha-function-rgl-setvertexlightalpha-base-x-y-z-alpha-src-r-gl-ml-667489492"></a>
### RGL_SetVertexLightAlpha

```ml
function RGL_SetVertexLightAlpha(base, x, y, z, alpha)
```

Evaluates view fade and nearby dynamic lights at a world point, then sets the resulting OpenGL color with caller alpha.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `base` | `dynamic` | — | Base value supplied to `RGL_SetVertexLightAlpha`. |
| `x` | `dynamic` | — | Horizontal map- or screen-space coordinate. |
| `y` | `dynamic` | — | Vertical map- or screen-space coordinate. |
| `z` | `dynamic` | — | Vertical world-space coordinate. |
| `alpha` | `dynamic` | — | Alpha value supplied to `RGL_SetVertexLightAlpha`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_gl.ml#L2936)

<a id="global-global-rgl-side-sig-gametic-rgl-side-sig-gametic-src-r-gl-ml-1243247318"></a>
### rgl_side_sig_gametic

```ml
rgl_side_sig_gametic
```

Tracks the mutable rgl side sig gametic value used by the r gl subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_gl.ml#L116)

<a id="global-global-rgl-side-sig-leveltime-rgl-side-sig-leveltime-src-r-gl-ml-1377487148"></a>
### rgl_side_sig_leveltime

```ml
rgl_side_sig_leveltime
```

Tracks the mutable rgl side sig leveltime value used by the r gl subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_gl.ml#L118)

<a id="global-global-rgl-side-sig-map-rgl-side-sig-map-src-r-gl-ml-2102338894"></a>
### rgl_side_sig_map

```ml
rgl_side_sig_map
```

Tracks the mutable rgl side sig map value used by the r gl subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_gl.ml#L114)

<a id="global-global-rgl-side-sig-value-rgl-side-sig-value-src-r-gl-ml-2043820760"></a>
### rgl_side_sig_value

```ml
rgl_side_sig_value
```

Tracks the mutable rgl side sig value value used by the r gl subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_gl.ml#L120)

<a id="function-function-rgl-sideorfallback-inline-function-rgl-sideorfallback-side-fallback-src-r-gl-ml-1086994988"></a>
### RGL_SideOrFallback

```ml
inline function RGL_SideOrFallback(side, fallback)
```

Returns a preferred sidedef when present, otherwise the caller-supplied fallback.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `side` | `dynamic` | — | Map side affected by the operation. |
| `fallback` | `dynamic` | — | Value returned when the requested conversion or lookup is unavailable. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_gl.ml#L3686)

<a id="function-function-rgl-siderowoffset-inline-function-rgl-siderowoffset-side-src-r-gl-ml-1091845348"></a>
### RGL_SideRowOffset

```ml
inline function RGL_SideRowOffset(side)
```

Reads a sidedef's fixed vertical texture offset, defaulting to zero.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `side` | `dynamic` | — | Map side affected by the operation. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_gl.ml#L3335)

<a id="function-function-rgl-sidetexturesignature-function-rgl-sidetexturesignature-src-r-gl-ml-1441912300"></a>
### RGL_SideTextureSignature

```ml
function RGL_SideTextureSignature()
```

Computes a once-per-tic hash of sidedef textures and non-scrolling offsets for cache invalidation.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_gl.ml#L1546)

<a id="function-function-rgl-skysforpoint-function-rgl-skysforpoint-x-y-src-r-gl-ml-708798433"></a>
### RGL_SkySForPoint

```ml
function RGL_SkySForPoint(x, y)
```

Computes view-yaw-relative horizontal sky texture coordinates from a world-space point.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `x` | `dynamic` | — | Horizontal map- or screen-space coordinate. |
| `y` | `dynamic` | — | Vertical map- or screen-space coordinate. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_gl.ml#L4908)

<a id="function-function-rgl-sortbatchgroupsbykey-function-rgl-sortbatchgroupsbykey-keys-groups-src-r-gl-ml-2038529984"></a>
### RGL_SortBatchGroupsByKey

```ml
function RGL_SortBatchGroupsByKey(keys, groups)
```

Orders static batch groups by numeric key so texture binds stay clustered.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `keys` | `dynamic` | — | Keys value supplied to `RGL_SortBatchGroupsByKey`. |
| `groups` | `dynamic` | — | Groups value supplied to `RGL_SortBatchGroupsByKey`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_gl.ml#L608)

<a id="constant-constant-rgl-spatial-batch-cell-const-rgl-spatial-batch-cell-1024-src-r-gl-ml-1344893320"></a>
### RGL_SPATIAL_BATCH_CELL

```ml
const RGL_SPATIAL_BATCH_CELL = 1024.
```

Defines rgl spatial batch cell for the r gl subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_gl.ml#L319)

<a id="constant-constant-rgl-spatial-batch-origin-const-rgl-spatial-batch-origin-32768-src-r-gl-ml-2137470579"></a>
### RGL_SPATIAL_BATCH_ORIGIN

```ml
const RGL_SPATIAL_BATCH_ORIGIN = 32768.
```

Defines rgl spatial batch origin for the r gl subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_gl.ml#L323)

<a id="constant-constant-rgl-spatial-batch-stride-const-rgl-spatial-batch-stride-128-src-r-gl-ml-1058119916"></a>
### RGL_SPATIAL_BATCH_STRIDE

```ml
const RGL_SPATIAL_BATCH_STRIDE = 128
```

Defines rgl spatial batch stride for the r gl subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_gl.ml#L325)

<a id="function-function-rgl-spatialbatchcellkey-function-rgl-spatialbatchcellkey-x-z-src-r-gl-ml-660588188"></a>
### RGL_SpatialBatchCellKey

```ml
function RGL_SpatialBatchCellKey(x, z)
```

Maps a world-space point to a coarse static-geometry batch cell.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `x` | `dynamic` | — | Horizontal map- or screen-space coordinate. |
| `z` | `dynamic` | — | Vertical world-space coordinate. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_gl.ml#L564)

<a id="global-global-rgl-sprite-fuzz-tex-ids-rgl-sprite-fuzz-tex-ids-src-r-gl-ml-1060978086"></a>
### rgl_sprite_fuzz_tex_ids

```ml
rgl_sprite_fuzz_tex_ids
```

Stores the rgl sprite fuzz tex ids collection used by the r gl subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_gl.ml#L70)

<a id="global-global-rgl-sprite-height-cache-rgl-sprite-height-cache-src-r-gl-ml-1337002454"></a>
### rgl_sprite_height_cache

```ml
rgl_sprite_height_cache
```

Stores the rgl sprite height cache collection used by the r gl subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_gl.ml#L300)

<a id="global-global-rgl-sprite-light-records-rgl-sprite-light-records-src-r-gl-ml-1089730840"></a>
### rgl_sprite_light_records

```ml
rgl_sprite_light_records
```

Tracks the mutable rgl sprite light records value used by the r gl subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_gl.ml#L294)

<a id="global-global-rgl-sprite-light-revision-rgl-sprite-light-revision-src-r-gl-ml-1719696666"></a>
### rgl_sprite_light_revision

```ml
rgl_sprite_light_revision
```

Tracks the mutable rgl sprite light revision value used by the r gl subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_gl.ml#L296)

<a id="global-global-rgl-sprite-native-records-rgl-sprite-native-records-src-r-gl-ml-166761246"></a>
### rgl_sprite_native_records

```ml
rgl_sprite_native_records
```

Tracks the mutable rgl sprite native records value used by the r gl subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_gl.ml#L304)

<a id="constant-constant-rgl-sprite-record-size-const-rgl-sprite-record-size-36-src-r-gl-ml-1738956350"></a>
### RGL_SPRITE_RECORD_SIZE

```ml
const RGL_SPRITE_RECORD_SIZE = 36
```

Defines rgl sprite record size for the r gl subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_gl.ml#L331)

<a id="global-global-rgl-sprite-tex-ids-rgl-sprite-tex-ids-src-r-gl-ml-516156794"></a>
### rgl_sprite_tex_ids

```ml
rgl_sprite_tex_ids
```

Stores the rgl sprite tex ids collection used by the r gl subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_gl.ml#L68)

<a id="global-global-rgl-sprite-width-cache-rgl-sprite-width-cache-src-r-gl-ml-1903579356"></a>
### rgl_sprite_width_cache

```ml
rgl_sprite_width_cache
```

Stores the rgl sprite width cache collection used by the r gl subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_gl.ml#L298)

<a id="global-global-rgl-sprite-yoffset-cache-rgl-sprite-yoffset-cache-src-r-gl-ml-2038405100"></a>
### rgl_sprite_yoffset_cache

```ml
rgl_sprite_yoffset_cache
```

Stores the rgl sprite yoffset cache collection used by the r gl subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_gl.ml#L302)

<a id="function-function-rgl-spriteentryforlump-function-rgl-spriteentryforlump-lump-src-r-gl-ml-291423486"></a>
### RGL_SpriteEntryForLump

```ml
function RGL_SpriteEntryForLump(lump)
```

Resolves a relative sprite lump to its upscaled sprite asset, falling back to the generic patch cache.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `lump` | `dynamic` | — | Lump value supplied to `RGL_SpriteEntryForLump`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_gl.ml#L3302)

<a id="function-function-rgl-spriteindex-inline-function-rgl-spriteindex-v-src-r-gl-ml-1938259567"></a>
### RGL_SpriteIndex

```ml
inline function RGL_SpriteIndex(v)
```

Resolves a sprite identifier against the currently loaded sprite definition count.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `v` | `dynamic` | — | Value consumed by the operation. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_gl.ml#L2350)

<a id="global-global-rgl-static-array-batches-ready-rgl-static-array-batches-ready-src-r-gl-ml-543359900"></a>
### rgl_static_array_batches_ready

```ml
rgl_static_array_batches_ready
```

Tracks whether rgl static array batches ready is active in the r gl subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_gl.ml#L204)

<a id="global-global-rgl-static-display-lists-ready-rgl-static-display-lists-ready-src-r-gl-ml-1107636732"></a>
### rgl_static_display_lists_ready

```ml
rgl_static_display_lists_ready
```

Tracks whether rgl static display lists ready is active in the r gl subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_gl.ml#L196)

<a id="global-global-rgl-static-world-display-list-id-rgl-static-world-display-list-id-src-r-gl-ml-1866735128"></a>
### rgl_static_world_display_list_id

```ml
rgl_static_world_display_list_id
```

Tracks the mutable rgl static world display list id value used by the r gl subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_gl.ml#L194)

<a id="function-function-rgl-staticvertexlit-function-rgl-staticvertexlit-base-x-y-z-src-r-gl-ml-1782373992"></a>
### RGL_StaticVertexLit

```ml
function RGL_StaticVertexLit(base, x, y, z)
```

Emits static sector lighting for compiled OpenGL geometry batches.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `base` | `dynamic` | — | Base value supplied to `RGL_StaticVertexLit`. |
| `x` | `dynamic` | — | Horizontal map- or screen-space coordinate. |
| `y` | `dynamic` | — | Vertical map- or screen-space coordinate. |
| `z` | `dynamic` | — | Vertical world-space coordinate. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_gl.ml#L3036)

<a id="function-function-rgl-stringstartswith-function-rgl-stringstartswith-s-prefix-src-r-gl-ml-140844377"></a>
### RGL_StringStartsWith

```ml
function RGL_StringStartsWith(s, prefix)
```

Tests a short ASCII prefix without relying on optional string helpers.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `s` | `dynamic` | — | S value supplied to `RGL_StringStartsWith`. |
| `prefix` | `dynamic` | — | Prefix value supplied to `RGL_StringStartsWith`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_gl.ml#L2480)

<a id="function-function-rgl-syncpaletterevision-function-rgl-syncpaletterevision-src-r-gl-ml-271718358"></a>
### RGL_SyncPaletteRevision

```ml
function RGL_SyncPaletteRevision()
```

Invalidates every palette-derived GL texture and dependent static/dynamic batch when the indexed palette changes.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_gl.ml#L3094)

<a id="global-global-rgl-tex-ids-rgl-tex-ids-src-r-gl-ml-559959942"></a>
### rgl_tex_ids

```ml
rgl_tex_ids
```

Stores the rgl tex ids collection used by the r gl subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_gl.ml#L60)

<a id="global-global-rgl-tex-keys-rgl-tex-keys-src-r-gl-ml-110983122"></a>
### rgl_tex_keys

```ml
rgl_tex_keys
```

Stores the rgl tex keys collection used by the r gl subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_gl.ml#L58)

<a id="global-global-rgl-texnum-tex-ids-rgl-texnum-tex-ids-src-r-gl-ml-1363024934"></a>
### rgl_texnum_tex_ids

```ml
rgl_texnum_tex_ids
```

Stores the rgl texnum tex ids collection used by the r gl subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_gl.ml#L62)

<a id="global-global-rgl-texnum-trans-tex-ids-rgl-texnum-trans-tex-ids-src-r-gl-ml-846814052"></a>
### rgl_texnum_trans_tex_ids

```ml
rgl_texnum_trans_tex_ids
```

Stores the rgl texnum trans tex ids collection used by the r gl subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_gl.ml#L64)

<a id="function-function-rgl-textureheight-function-rgl-textureheight-texnum-src-r-gl-ml-1666060953"></a>
### RGL_TextureHeight

```ml
function RGL_TextureHeight(texnum)
```

Returns the translated texture's positive pixel height, with a 64-pixel fallback.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `texnum` | `dynamic` | — | Index identifying tex. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_gl.ml#L3170)

<a id="function-function-rgl-textureheightfixed-function-rgl-textureheightfixed-texnum-src-r-gl-ml-438182233"></a>
### RGL_TextureHeightFixed

```ml
function RGL_TextureHeightFixed(texnum)
```

Returns a texture height in Doom fixed-point units from textureheight or pixel metadata fallback.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `texnum` | `dynamic` | — | Index identifying tex. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_gl.ml#L3342)

<a id="function-function-rgl-textureidforflatnum-function-rgl-textureidforflatnum-flatnum-src-r-gl-ml-1433922361"></a>
### RGL_TextureIdForFlatnum

```ml
function RGL_TextureIdForFlatnum(flatnum)
```

Resolves flat animation, uploads the named repeat-wrapped flat once, and caches its GL texture id.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `flatnum` | `dynamic` | — | Index identifying flat. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_gl.ml#L3227)

<a id="function-function-rgl-textureidforspritefuzzlump-function-rgl-textureidforspritefuzzlump-lump-src-r-gl-ml-929928642"></a>
### RGL_TextureIdForSpriteFuzzLump

```ml
function RGL_TextureIdForSpriteFuzzLump(lump)
```

Returns a neutral alpha-mask texture for shadow/fuzz sprite billboards.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `lump` | `dynamic` | — | Lump value supplied to `RGL_TextureIdForSpriteFuzzLump`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_gl.ml#L3273)

<a id="function-function-rgl-textureidforspritelump-function-rgl-textureidforspritelump-lump-src-r-gl-ml-1137998222"></a>
### RGL_TextureIdForSpriteLump

```ml
function RGL_TextureIdForSpriteLump(lump)
```

Loads a sprite/patch lump as a clamped cutout texture and caches its GL id by relative sprite lump.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `lump` | `dynamic` | — | Lump value supplied to `RGL_TextureIdForSpriteLump`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_gl.ml#L3251)

<a id="function-function-rgl-textureidfortexnum-function-rgl-textureidfortexnum-texnum-src-r-gl-ml-1908960937"></a>
### RGL_TextureIdForTexnum

```ml
function RGL_TextureIdForTexnum(texnum)
```

Resolves animation, uploads a repeat-wrapped opaque wall texture once, and caches its GL id by texture number.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `texnum` | `dynamic` | — | Index identifying tex. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_gl.ml#L3181)

<a id="function-function-rgl-textureidfortexnumtransparent-function-rgl-textureidfortexnumtransparent-texnum-src-r-gl-ml-1523274177"></a>
### RGL_TextureIdForTexnumTransparent

```ml
function RGL_TextureIdForTexnumTransparent(texnum)
```

Resolves animation, uploads a repeat-wrapped cutout wall texture once, and caches its GL id separately.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `texnum` | `dynamic` | — | Index identifying tex. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_gl.ml#L3204)

<a id="function-function-rgl-texturename-function-rgl-texturename-texnum-src-r-gl-ml-2090441065"></a>
### RGL_TextureName

```ml
function RGL_TextureName(texnum)
```

Returns the name of the currently animation-translated texture, or an empty string when invalid.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `texnum` | `dynamic` | — | Index identifying tex. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_gl.ml#L3149)

<a id="function-function-rgl-texturewidth-function-rgl-texturewidth-texnum-src-r-gl-ml-60440933"></a>
### RGL_TextureWidth

```ml
function RGL_TextureWidth(texnum)
```

Returns the translated texture's positive pixel width, with a 64-pixel fallback.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `texnum` | `dynamic` | — | Index identifying tex. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_gl.ml#L3160)

<a id="function-function-rgl-toptextureorzero-inline-function-rgl-toptextureorzero-side-src-r-gl-ml-491048116"></a>
### RGL_TopTextureOrZero

```ml
inline function RGL_TopTextureOrZero(side)
```

Reads a sidedef's upper texture number, returning zero for missing data.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `side` | `dynamic` | — | Map side affected by the operation. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_gl.ml#L3693)

<a id="function-function-rgl-tryloadgeometrycache-function-rgl-tryloadgeometrycache-sigmap-sigsegs-siglines-signodes-sigsubsectors-sigsectormotion-sigsides-src-r-gl-ml-1315664590"></a>
### RGL_TryLoadGeometryCache

```ml
function RGL_TryLoadGeometryCache(sigMap, sigSegs, sigLines, sigNodes, sigSubsectors, sigSectorMotion, sigSides)
```

Validates a versioned map geometry lump against current signatures, restores its lists, and rebuilds runtime batches.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `sigMap` | `dynamic` | — | Sig map value supplied to `RGL_TryLoadGeometryCache`. |
| `sigSegs` | `dynamic` | — | Sig segs value supplied to `RGL_TryLoadGeometryCache`. |
| `sigLines` | `dynamic` | — | Sig lines value supplied to `RGL_TryLoadGeometryCache`. |
| `sigNodes` | `dynamic` | — | Sig nodes value supplied to `RGL_TryLoadGeometryCache`. |
| `sigSubsectors` | `dynamic` | — | Sig subsectors value supplied to `RGL_TryLoadGeometryCache`. |
| `sigSectorMotion` | `dynamic` | — | Sig sector motion value supplied to `RGL_TryLoadGeometryCache`. |
| `sigSides` | `dynamic` | — | Sig sides value supplied to `RGL_TryLoadGeometryCache`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_gl.ml#L2176)

<a id="function-function-rgl-updateflatnativerecordtextures-function-rgl-updateflatnativerecordtextures-src-r-gl-ml-1983897548"></a>
### RGL_UpdateFlatNativeRecordTextures

```ml
function RGL_UpdateFlatNativeRecordTextures()
```

Refreshes flat native draw-record texture ids for animated flat translation.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_gl.ml#L1065)

<a id="function-function-rgl-updatemaskednativerecordtextures-function-rgl-updatemaskednativerecordtextures-src-r-gl-ml-1160759516"></a>
### RGL_UpdateMaskedNativeRecordTextures

```ml
function RGL_UpdateMaskedNativeRecordTextures()
```

Refreshes masked-wall texture ids while retaining spatially culled VBO records.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_gl.ml#L1044)

<a id="function-function-rgl-updatescrollingmaskedrecordtextures-function-rgl-updatescrollingmaskedrecordtextures-src-r-gl-ml-1417254384"></a>
### RGL_UpdateScrollingMaskedRecordTextures

```ml
function RGL_UpdateScrollingMaskedRecordTextures()
```

Refreshes cutout scroller native record texture ids while preserving current UV geometry and VBOs.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_gl.ml#L6762)

<a id="function-function-rgl-updatescrollingwallrecordtextures-function-rgl-updatescrollingwallrecordtextures-src-r-gl-ml-427328702"></a>
### RGL_UpdateScrollingWallRecordTextures

```ml
function RGL_UpdateScrollingWallRecordTextures()
```

Refreshes opaque scroller native record texture ids while preserving current UV geometry and VBOs.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_gl.ml#L6743)

<a id="function-function-rgl-updatevolatileflatrecordtextures-function-rgl-updatevolatileflatrecordtextures-src-r-gl-ml-1123781048"></a>
### RGL_UpdateVolatileFlatRecordTextures

```ml
function RGL_UpdateVolatileFlatRecordTextures()
```

Refreshes moving-floor/ceiling native record texture ids only when the flat-animation revision changes.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_gl.ml#L6607)

<a id="function-function-rgl-updatevolatilemaskedrecordtextures-function-rgl-updatevolatilemaskedrecordtextures-src-r-gl-ml-1460939336"></a>
### RGL_UpdateVolatileMaskedRecordTextures

```ml
function RGL_UpdateVolatileMaskedRecordTextures()
```

Refreshes moving cutout-wall native record texture ids only when the animation revision changes.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_gl.ml#L6626)

<a id="function-function-rgl-updatevolatilewallrecordtextures-function-rgl-updatevolatilewallrecordtextures-src-r-gl-ml-1383996996"></a>
### RGL_UpdateVolatileWallRecordTextures

```ml
function RGL_UpdateVolatileWallRecordTextures()
```

Refreshes moving-wall native record texture ids only when the animation revision changes.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_gl.ml#L6587)

<a id="function-function-rgl-updatewallnativerecordtextures-function-rgl-updatewallnativerecordtextures-src-r-gl-ml-572668884"></a>
### RGL_UpdateWallNativeRecordTextures

```ml
function RGL_UpdateWallNativeRecordTextures()
```

Refreshes wall native draw-record texture ids for animated texture translation.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_gl.ml#L1021)

<a id="function-function-rgl-uppertexturemid-function-rgl-uppertexturemid-linedef-texnum-side-front-back-src-r-gl-ml-990365755"></a>
### RGL_UpperTextureMid

```ml
function RGL_UpperTextureMid(linedef, texnum, side, front, back)
```

Computes the upper wall texture origin from pegging flags, adjacent ceilings, texture height, and row offset.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `linedef` | `dynamic` | — | Linedef value supplied to `RGL_UpperTextureMid`. |
| `texnum` | `dynamic` | — | Index identifying tex. |
| `side` | `dynamic` | — | Map side affected by the operation. |
| `front` | `dynamic` | — | Front value supplied to `RGL_UpperTextureMid`. |
| `back` | `dynamic` | — | Back value supplied to `RGL_UpperTextureMid`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_gl.ml#L3354)

<a id="function-function-rgl-vertex-inline-function-rgl-vertex-v-z-src-r-gl-ml-2128096507"></a>
### RGL_Vertex

```ml
inline function RGL_Vertex(v, z)
```

Converts a Doom map vertex and fixed height to OpenGL axes and emits it with current-sector lighting.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `v` | `dynamic` | — | Value consumed by the operation. |
| `z` | `dynamic` | — | Vertical world-space coordinate. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_gl.ml#L3045)

<a id="function-function-rgl-vertexlit-function-rgl-vertexlit-base-x-y-z-src-r-gl-ml-203569652"></a>
### RGL_VertexLit

```ml
function RGL_VertexLit(base, x, y, z)
```

Applies static plus nearby dynamic lighting at a world point and emits that OpenGL vertex.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `base` | `dynamic` | — | Base value supplied to `RGL_VertexLit`. |
| `x` | `dynamic` | — | Horizontal map- or screen-space coordinate. |
| `y` | `dynamic` | — | Vertical map- or screen-space coordinate. |
| `z` | `dynamic` | — | Vertical world-space coordinate. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_gl.ml#L2989)

<a id="global-global-rgl-view-x-rgl-view-x-src-r-gl-ml-94959850"></a>
### rgl_view_x

```ml
rgl_view_x
```

Tracks the mutable rgl view x value used by the r gl subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_gl.ml#L74)

<a id="global-global-rgl-view-y-rgl-view-y-src-r-gl-ml-1861024324"></a>
### rgl_view_y

```ml
rgl_view_y
```

Tracks the mutable rgl view y value used by the r gl subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_gl.ml#L76)

<a id="global-global-rgl-view-yaw-rgl-view-yaw-src-r-gl-ml-2040073568"></a>
### rgl_view_yaw

```ml
rgl_view_yaw
```

Tracks the mutable rgl view yaw value used by the r gl subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_gl.ml#L78)

<a id="global-global-rgl-volatile-array-batches-ready-rgl-volatile-array-batches-ready-src-r-gl-ml-147678684"></a>
### rgl_volatile_array_batches_ready

```ml
rgl_volatile_array_batches_ready
```

Tracks whether rgl volatile array batches ready is active in the r gl subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_gl.ml#L230)

<a id="global-global-rgl-volatile-flat-array-batches-rgl-volatile-flat-array-batches-src-r-gl-ml-481988790"></a>
### rgl_volatile_flat_array_batches

```ml
rgl_volatile_flat_array_batches
```

Stores the rgl volatile flat array batches collection used by the r gl subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_gl.ml#L208)

<a id="global-global-rgl-volatile-flat-native-record-count-rgl-volatile-flat-native-record-count-src-r-gl-ml-171143398"></a>
### rgl_volatile_flat_native_record_count

```ml
rgl_volatile_flat_native_record_count
```

Tracks the mutable rgl volatile flat native record count value used by the r gl subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_gl.ml#L220)

<a id="global-global-rgl-volatile-flat-native-records-rgl-volatile-flat-native-records-src-r-gl-ml-1370865588"></a>
### rgl_volatile_flat_native_records

```ml
rgl_volatile_flat_native_records
```

Tracks the mutable rgl volatile flat native records value used by the r gl subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_gl.ml#L214)

- [rgl_volatile_flat_template_t](Type-rgl-volatile-flat-template-t-11380037.md) — struct
<a id="global-global-rgl-volatile-flat-templates-rgl-volatile-flat-templates-src-r-gl-ml-535650170"></a>
### rgl_volatile_flat_templates

```ml
rgl_volatile_flat_templates
```

Stores the rgl volatile flat templates collection used by the r gl subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_gl.ml#L164)

<a id="global-global-rgl-volatile-flat-texture-revision-rgl-volatile-flat-texture-revision-src-r-gl-ml-1864927190"></a>
### rgl_volatile_flat_texture_revision

```ml
rgl_volatile_flat_texture_revision
```

Tracks the mutable rgl volatile flat texture revision value used by the r gl subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_gl.ml#L226)

<a id="global-global-rgl-volatile-geometry-last-gametic-rgl-volatile-geometry-last-gametic-src-r-gl-ml-912796"></a>
### rgl_volatile_geometry_last_gametic

```ml
rgl_volatile_geometry_last_gametic
```

Tracks the mutable rgl volatile geometry last gametic value used by the r gl subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_gl.ml#L234)

<a id="global-global-rgl-volatile-geometry-last-leveltime-rgl-volatile-geometry-last-leveltime-src-r-gl-ml-1202673078"></a>
### rgl_volatile_geometry_last_leveltime

```ml
rgl_volatile_geometry_last_leveltime
```

Tracks the mutable rgl volatile geometry last leveltime value used by the r gl subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_gl.ml#L236)

<a id="global-global-rgl-volatile-geometry-signature-rgl-volatile-geometry-signature-src-r-gl-ml-1240341254"></a>
### rgl_volatile_geometry_signature

```ml
rgl_volatile_geometry_signature
```

Tracks the mutable rgl volatile geometry signature value used by the r gl subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_gl.ml#L232)

<a id="global-global-rgl-volatile-immediate-active-rgl-volatile-immediate-active-src-r-gl-ml-1011388834"></a>
### rgl_volatile_immediate_active

```ml
rgl_volatile_immediate_active
```

Tracks whether rgl volatile immediate active is active in the r gl subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_gl.ml#L242)

<a id="global-global-rgl-volatile-lines-rgl-volatile-lines-src-r-gl-ml-176491542"></a>
### rgl_volatile_lines

```ml
rgl_volatile_lines
```

Stores the rgl volatile lines collection used by the r gl subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_gl.ml#L130)

<a id="global-global-rgl-volatile-masked-array-batches-rgl-volatile-masked-array-batches-src-r-gl-ml-692408290"></a>
### rgl_volatile_masked_array_batches

```ml
rgl_volatile_masked_array_batches
```

Stores the rgl volatile masked array batches collection used by the r gl subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_gl.ml#L210)

<a id="global-global-rgl-volatile-masked-native-record-count-rgl-volatile-masked-native-record-count-src-r-gl-ml-817506166"></a>
### rgl_volatile_masked_native_record_count

```ml
rgl_volatile_masked_native_record_count
```

Tracks the mutable rgl volatile masked native record count value used by the r gl subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_gl.ml#L222)

<a id="global-global-rgl-volatile-masked-native-records-rgl-volatile-masked-native-records-src-r-gl-ml-610462944"></a>
### rgl_volatile_masked_native_records

```ml
rgl_volatile_masked_native_records
```

Tracks the mutable rgl volatile masked native records value used by the r gl subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_gl.ml#L216)

<a id="global-global-rgl-volatile-masked-texture-revision-rgl-volatile-masked-texture-revision-src-r-gl-ml-1467095382"></a>
### rgl_volatile_masked_texture_revision

```ml
rgl_volatile_masked_texture_revision
```

Tracks the mutable rgl volatile masked texture revision value used by the r gl subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_gl.ml#L228)

<a id="global-global-rgl-volatile-pending-signature-rgl-volatile-pending-signature-src-r-gl-ml-1921391012"></a>
### rgl_volatile_pending_signature

```ml
rgl_volatile_pending_signature
```

Tracks the mutable rgl volatile pending signature value used by the r gl subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_gl.ml#L238)

<a id="global-global-rgl-volatile-pending-stable-tics-rgl-volatile-pending-stable-tics-src-r-gl-ml-2097109006"></a>
### rgl_volatile_pending_stable_tics

```ml
rgl_volatile_pending_stable_tics
```

Tracks the mutable rgl volatile pending stable tics value used by the r gl subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_gl.ml#L240)

<a id="global-global-rgl-volatile-sectors-rgl-volatile-sectors-src-r-gl-ml-1834046606"></a>
### rgl_volatile_sectors

```ml
rgl_volatile_sectors
```

Stores the rgl volatile sectors collection used by the r gl subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_gl.ml#L124)

<a id="global-global-rgl-volatile-segs-rgl-volatile-segs-src-r-gl-ml-1724067838"></a>
### rgl_volatile_segs

```ml
rgl_volatile_segs
```

Stores the rgl volatile segs collection used by the r gl subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_gl.ml#L128)

<a id="global-global-rgl-volatile-sig-map-rgl-volatile-sig-map-src-r-gl-ml-1035220096"></a>
### rgl_volatile_sig_map

```ml
rgl_volatile_sig_map
```

Tracks the mutable rgl volatile sig map value used by the r gl subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_gl.ml#L122)

<a id="global-global-rgl-volatile-subsectors-rgl-volatile-subsectors-src-r-gl-ml-236307334"></a>
### rgl_volatile_subsectors

```ml
rgl_volatile_subsectors
```

Stores the rgl volatile subsectors collection used by the r gl subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_gl.ml#L126)

<a id="global-global-rgl-volatile-wall-array-batches-rgl-volatile-wall-array-batches-src-r-gl-ml-2038899286"></a>
### rgl_volatile_wall_array_batches

```ml
rgl_volatile_wall_array_batches
```

Stores the rgl volatile wall array batches collection used by the r gl subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_gl.ml#L206)

<a id="global-global-rgl-volatile-wall-native-record-count-rgl-volatile-wall-native-record-count-src-r-gl-ml-754057766"></a>
### rgl_volatile_wall_native_record_count

```ml
rgl_volatile_wall_native_record_count
```

Tracks the mutable rgl volatile wall native record count value used by the r gl subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_gl.ml#L218)

<a id="global-global-rgl-volatile-wall-native-records-rgl-volatile-wall-native-records-src-r-gl-ml-257544518"></a>
### rgl_volatile_wall_native_records

```ml
rgl_volatile_wall_native_records
```

Tracks the mutable rgl volatile wall native records value used by the r gl subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_gl.ml#L212)

<a id="global-global-rgl-volatile-wall-texture-revision-rgl-volatile-wall-texture-revision-src-r-gl-ml-1648116844"></a>
### rgl_volatile_wall_texture_revision

```ml
rgl_volatile_wall_texture_revision
```

Tracks the mutable rgl volatile wall texture revision value used by the r gl subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_gl.ml#L224)

<a id="function-function-rgl-volatilegeometrysignature-function-rgl-volatilegeometrysignature-src-r-gl-ml-643476492"></a>
### RGL_VolatileGeometrySignature

```ml
function RGL_VolatileGeometrySignature()
```

Tracks only state that can change the precomputed volatile-sector meshes.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_gl.ml#L6365)

<a id="constant-constant-rgl-wall-array-batch-quads-const-rgl-wall-array-batch-quads-4096-src-r-gl-ml-1221201850"></a>
### RGL_WALL_ARRAY_BATCH_QUADS

```ml
const RGL_WALL_ARRAY_BATCH_QUADS = 4096
```

Defines rgl wall array batch quads for the r gl subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_gl.ml#L315)

<a id="global-global-rgl-wall-array-batches-rgl-wall-array-batches-src-r-gl-ml-639089012"></a>
### rgl_wall_array_batches

```ml
rgl_wall_array_batches
```

Stores the rgl wall array batches collection used by the r gl subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_gl.ml#L198)

<a id="global-global-rgl-wall-display-list-ids-rgl-wall-display-list-ids-src-r-gl-ml-803270842"></a>
### rgl_wall_display_list_ids

```ml
rgl_wall_display_list_ids
```

Stores the rgl wall display list ids collection used by the r gl subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_gl.ml#L184)

<a id="global-global-rgl-wall-display-list-texnums-rgl-wall-display-list-texnums-src-r-gl-ml-1291031050"></a>
### rgl_wall_display_list_texnums

```ml
rgl_wall_display_list_texnums
```

Stores the rgl wall display list texnums collection used by the r gl subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_gl.ml#L180)

<a id="global-global-rgl-wall-display-list-transparents-rgl-wall-display-list-transparents-src-r-gl-ml-508032726"></a>
### rgl_wall_display_list_transparents

```ml
rgl_wall_display_list_transparents
```

Stores the rgl wall display list transparents collection used by the r gl subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_gl.ml#L182)

<a id="global-global-rgl-wall-native-record-count-rgl-wall-native-record-count-src-r-gl-ml-2042089738"></a>
### rgl_wall_native_record_count

```ml
rgl_wall_native_record_count
```

Tracks the mutable rgl wall native record count value used by the r gl subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_gl.ml#L250)

<a id="global-global-rgl-wall-native-records-rgl-wall-native-records-src-r-gl-ml-1005826794"></a>
### rgl_wall_native_records

```ml
rgl_wall_native_records
```

Tracks the mutable rgl wall native records value used by the r gl subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_gl.ml#L244)

<a id="global-global-rgl-wall-native-texture-revision-rgl-wall-native-texture-revision-src-r-gl-ml-712052342"></a>
### rgl_wall_native_texture_revision

```ml
rgl_wall_native_texture_revision
```

Tracks the mutable rgl wall native texture revision value used by the r gl subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_gl.ml#L256)

<a id="global-global-rgl-wall-quads-rgl-wall-quads-src-r-gl-ml-1371373860"></a>
### rgl_wall_quads

```ml
rgl_wall_quads
```

Stores the rgl wall quads collection used by the r gl subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_gl.ml#L170)

<a id="function-function-rgl-wallarraybatchkey-function-rgl-wallarraybatchkey-q-src-r-gl-ml-408571291"></a>
### RGL_WallArrayBatchKey

```ml
function RGL_WallArrayBatchKey(q)
```

Builds a combined texture and spatial key for static wall batching.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `q` | `dynamic` | — | Q value supplied to `RGL_WallArrayBatchKey`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_gl.ml#L589)

<a id="constant-constant-rgl-world-sprite-foot-lift-const-rgl-world-sprite-foot-lift-4-src-r-gl-ml-2120314361"></a>
### RGL_WORLD_SPRITE_FOOT_LIFT

```ml
const RGL_WORLD_SPRITE_FOOT_LIFT = 4.
```

Defines rgl world sprite foot lift for the r gl subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_gl.ml#L42)

<a id="constant-constant-rgl-world-view-distance-const-rgl-world-view-distance-12288-src-r-gl-ml-1417550196"></a>
### RGL_WORLD_VIEW_DISTANCE

```ml
const RGL_WORLD_VIEW_DISTANCE = 12288.
```

Keeps MAP32's roughly 7000-unit sightlines inside both the GL frustum and sprite culler with safe margin. Defines rgl world view distance for the r gl subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_gl.ml#L45)

<a id="function-function-rgl-writegeomarrayvertex-function-rgl-writegeomarrayvertex-vertices-voff-texcoords-toff-colors-coff-x-y-z-s-t-light-src-r-gl-ml-234467082"></a>
### RGL_WriteGeomArrayVertex

```ml
function RGL_WriteGeomArrayVertex(vertices, voff, texcoords, toff, colors, coff, x, y, z, s, t, light)
```

Appends one scaled vertex, texture coordinate, and static color to client-array buffers.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `vertices` | `dynamic` | — | Vertices value supplied to `RGL_WriteGeomArrayVertex`. |
| `voff` | `dynamic` | — | Voff value supplied to `RGL_WriteGeomArrayVertex`. |
| `texcoords` | `dynamic` | — | Texcoords value supplied to `RGL_WriteGeomArrayVertex`. |
| `toff` | `dynamic` | — | Toff value supplied to `RGL_WriteGeomArrayVertex`. |
| `colors` | `dynamic` | — | Colors value supplied to `RGL_WriteGeomArrayVertex`. |
| `coff` | `dynamic` | — | Coff value supplied to `RGL_WriteGeomArrayVertex`. |
| `x` | `dynamic` | — | Horizontal map- or screen-space coordinate. |
| `y` | `dynamic` | — | Vertical map- or screen-space coordinate. |
| `z` | `dynamic` | — | Vertical world-space coordinate. |
| `s` | `dynamic` | — | S value supplied to `RGL_WriteGeomArrayVertex`. |
| `t` | `dynamic` | — | T value supplied to `RGL_WriteGeomArrayVertex`. |
| `light` | `dynamic` | — | Light value supplied to `RGL_WriteGeomArrayVertex`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_gl.ml#L1179)

<a id="function-function-rgl-writegeomdepthquad-function-rgl-writegeomdepthquad-buf-off-q-src-r-gl-ml-1032839545"></a>
### RGL_WriteGeomDepthQuad

```ml
function RGL_WriteGeomDepthQuad(buf, off, q)
```

Serializes the four positions of a depth-only sky-occlusion quad.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `buf` | `dynamic` | — | Buf value supplied to `RGL_WriteGeomDepthQuad`. |
| `off` | `dynamic` | — | Zero-based byte or element offset. |
| `q` | `dynamic` | — | Q value supplied to `RGL_WriteGeomDepthQuad`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_gl.ml#L2041)

<a id="function-function-rgl-writegeomdepthtri-function-rgl-writegeomdepthtri-buf-off-t-src-r-gl-ml-419706222"></a>
### RGL_WriteGeomDepthTri

```ml
function RGL_WriteGeomDepthTri(buf, off, t)
```

Serializes the three positions of a depth-only sky-occlusion triangle.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `buf` | `dynamic` | — | Buf value supplied to `RGL_WriteGeomDepthTri`. |
| `off` | `dynamic` | — | Zero-based byte or element offset. |
| `t` | `dynamic` | — | T value supplied to `RGL_WriteGeomDepthTri`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_gl.ml#L1999)

<a id="function-function-rgl-writegeomfixed-function-rgl-writegeomfixed-buf-off-v-src-r-gl-ml-539627646"></a>
### RGL_WriteGeomFixed

```ml
function RGL_WriteGeomFixed(buf, off, v)
```

Quantizes and appends one floating geometry component, returning the next byte offset.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `buf` | `dynamic` | — | Buf value supplied to `RGL_WriteGeomFixed`. |
| `off` | `dynamic` | — | Zero-based byte or element offset. |
| `v` | `dynamic` | — | Value consumed by the operation. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_gl.ml#L1831)

<a id="function-function-rgl-writegeomflattri-function-rgl-writegeomflattri-buf-off-t-src-r-gl-ml-1101591976"></a>
### RGL_WriteGeomFlatTri

```ml
function RGL_WriteGeomFlatTri(buf, off, t)
```

Serializes a flat triangle's texture/light metadata, positions, and UVs and returns the next offset.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `buf` | `dynamic` | — | Buf value supplied to `RGL_WriteGeomFlatTri`. |
| `off` | `dynamic` | — | Zero-based byte or element offset. |
| `t` | `dynamic` | — | T value supplied to `RGL_WriteGeomFlatTri`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_gl.ml#L1931)

<a id="function-function-rgl-writegeominterleavedvertex-function-rgl-writegeominterleavedvertex-buf-off-x-y-z-s-t-light-src-r-gl-ml-153265930"></a>
### RGL_WriteGeomInterleavedVertex

```ml
function RGL_WriteGeomInterleavedVertex(buf, off, x, y, z, s, t, light)
```

Appends one scaled vertex, texture coordinate, and static color to an interleaved VBO buffer.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `buf` | `dynamic` | — | Buf value supplied to `RGL_WriteGeomInterleavedVertex`. |
| `off` | `dynamic` | — | Zero-based byte or element offset. |
| `x` | `dynamic` | — | Horizontal map- or screen-space coordinate. |
| `y` | `dynamic` | — | Vertical map- or screen-space coordinate. |
| `z` | `dynamic` | — | Vertical world-space coordinate. |
| `s` | `dynamic` | — | S value supplied to `RGL_WriteGeomInterleavedVertex`. |
| `t` | `dynamic` | — | T value supplied to `RGL_WriteGeomInterleavedVertex`. |
| `light` | `dynamic` | — | Light value supplied to `RGL_WriteGeomInterleavedVertex`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_gl.ml#L1201)

<a id="function-function-rgl-writegeomquad-function-rgl-writegeomquad-buf-off-q-src-r-gl-ml-1119557941"></a>
### RGL_WriteGeomQuad

```ml
function RGL_WriteGeomQuad(buf, off, q)
```

Serializes a textured quad's metadata, four positions, and four UV pairs and returns the next offset.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `buf` | `dynamic` | — | Buf value supplied to `RGL_WriteGeomQuad`. |
| `off` | `dynamic` | — | Zero-based byte or element offset. |
| `q` | `dynamic` | — | Q value supplied to `RGL_WriteGeomQuad`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_gl.ml#L1840)

<a id="function-function-rgl-writenativebatchrecord-function-rgl-writenativebatchrecord-records-index-texid-batch-flags-src-r-gl-ml-541804941"></a>
### RGL_WriteNativeBatchRecord

```ml
function RGL_WriteNativeBatchRecord(records, index, texid, batch, flags)
```

Writes one native helper draw record for a prepacked static geometry batch.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `records` | `dynamic` | — | Records value supplied to `RGL_WriteNativeBatchRecord`. |
| `index` | `dynamic` | — | Zero-based element or table index. |
| `texid` | `dynamic` | — | Texid value supplied to `RGL_WriteNativeBatchRecord`. |
| `batch` | `dynamic` | — | Batch value supplied to `RGL_WriteNativeBatchRecord`. |
| `flags` | `dynamic` | — | Bit flags that control the operation. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_gl.ml#L1009)

<a id="function-function-rgl-writes32-inline-function-rgl-writes32-buf-off-value-src-r-gl-ml-243072716"></a>
### RGL_WriteS32

```ml
inline function RGL_WriteS32(buf, off, value)
```

Encodes a signed integer through the shared little-endian 32-bit writer.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `buf` | `dynamic` | — | Buf value supplied to `RGL_WriteS32`. |
| `off` | `dynamic` | — | Zero-based byte or element offset. |
| `value` | `dynamic` | — | Value consumed by the operation. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_gl.ml#L1466)

<a id="function-function-rgl-writeu32-inline-function-rgl-writeu32-buf-off-value-src-r-gl-ml-88615096"></a>
### RGL_WriteU32

```ml
inline function RGL_WriteU32(buf, off, value)
```

Encodes the low 32 bits of a value in little-endian cache/native-record format.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `buf` | `dynamic` | — | Buf value supplied to `RGL_WriteU32`. |
| `off` | `dynamic` | — | Zero-based byte or element offset. |
| `value` | `dynamic` | — | Value consumed by the operation. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_gl.ml#L1453)
