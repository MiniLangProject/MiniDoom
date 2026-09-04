# `src/hdwad_builder.ml`

[Home](README.md) · [Files](Files.md)

Builds MiniDoom HDWAD cache files inside the game executable.

Package: [`(global)`](Package-global-1952375359.md)

Reachable from entry: **yes**

## Imports

- `std/fs.ml` as `fs` → `../MiniLangCompilerOptimization/MiniLangCompilerPy/std/fs.ml` — external dependency
- `std/math.ml` → `../MiniLangCompilerOptimization/MiniLangCompilerPy/std/math.ml` — external dependency

## Declarations

<a id="constant-constant-hd-magic0-const-hd-magic0-77-src-hdwad-builder-ml-888528209"></a>
### HD_MAGIC0

```ml
const HD_MAGIC0 = 77
```

Defines hd magic0 for the hdwad builder subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/hdwad_builder.ml#L32)

<a id="constant-constant-hd-magic1-const-hd-magic1-68-src-hdwad-builder-ml-759262005"></a>
### HD_MAGIC1

```ml
const HD_MAGIC1 = 68
```

Defines hd magic1 for the hdwad builder subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/hdwad_builder.ml#L34)

<a id="constant-constant-hd-magic2-const-hd-magic2-72-src-hdwad-builder-ml-1812335488"></a>
### HD_MAGIC2

```ml
const HD_MAGIC2 = 72
```

Defines hd magic2 for the hdwad builder subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/hdwad_builder.ml#L36)

<a id="constant-constant-hd-magic3-const-hd-magic3-68-src-hdwad-builder-ml-537014105"></a>
### HD_MAGIC3

```ml
const HD_MAGIC3 = 68
```

Defines hd magic3 for the hdwad builder subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/hdwad_builder.ml#L38)

<a id="function-function-hdb-buildimages-function-hdb-buildimages-waddata-lumps-scale-src-hdwad-builder-ml-316101281"></a>
### HDB_BuildImages

```ml
function HDB_BuildImages(wadData, lumps, scale)
```

Loads the palette and patch namespace, then builds the complete HD image set from wall textures, flats, sprites, and remaining patch lumps.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `wadData` | `dynamic` | — | Wad data value supplied to `HDB_BuildImages`. |
| `lumps` | `dynamic` | — | Lumps value supplied to `HDB_BuildImages`. |
| `scale` | `dynamic` | — | Scale value supplied to `HDB_BuildImages`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/hdwad_builder.ml#L1855)

<a id="function-function-hdb-estimateimageprogressunits-function-hdb-estimateimageprogressunits-waddata-lumps-scale-src-hdwad-builder-ml-1775364895"></a>
### HDB_EstimateImageProgressUnits

```ml
function HDB_EstimateImageProgressUnits(wadData, lumps, scale)
```

Estimates the progress units emitted while HDWAD graphics are built.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `wadData` | `dynamic` | — | Wad data value supplied to `HDB_EstimateImageProgressUnits`. |
| `lumps` | `dynamic` | — | Lumps value supplied to `HDB_EstimateImageProgressUnits`. |
| `scale` | `dynamic` | — | Scale value supplied to `HDB_EstimateImageProgressUnits`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/hdwad_builder.ml#L1608)

<a id="function-function-hdb-legacytoolmain-function-hdb-legacytoolmain-args-src-hdwad-builder-ml-1162084691"></a>
### HDB_LegacyToolMain

```ml
function HDB_LegacyToolMain(args)
```

Legacy helper kept for manual module testing.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `args` | `dynamic` | — | Args value supplied to `HDB_LegacyToolMain`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/hdwad_builder.ml#L1898)

<a id="function-function-hdb-loadwadforbuild-function-hdb-loadwadforbuild-path-src-hdwad-builder-ml-255056417"></a>
### HDB_LoadWadForBuild

```ml
function HDB_LoadWadForBuild(path)
```

Loads and validates the source WAD bytes and directory through the builder's shared WAD parser.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `path` | `dynamic` | — | Filesystem path to process. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/hdwad_builder.ml#L1879)

<a id="function-function-hdb-writehdwad-function-hdb-writehdwad-path-waddata-lumps-images-extranames-extradatas-scale-src-hdwad-builder-ml-1151223375"></a>
### HDB_WriteHDWAD

```ml
function HDB_WriteHDWAD(path, wadData, lumps, images, extraNames, extraDatas, scale)
```

Exposes full HDWAD packaging, including synthetic lumps, through the builder module's stable public entry point.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `path` | `dynamic` | — | Filesystem path to process. |
| `wadData` | `dynamic` | — | Wad data value supplied to `HDB_WriteHDWAD`. |
| `lumps` | `dynamic` | — | Lumps value supplied to `HDB_WriteHDWAD`. |
| `images` | `dynamic` | — | Images value supplied to `HDB_WriteHDWAD`. |
| `extraNames` | `dynamic` | — | Extra names value supplied to `HDB_WriteHDWAD`. |
| `extraDatas` | `dynamic` | — | Extra datas value supplied to `HDB_WriteHDWAD`. |
| `scale` | `dynamic` | — | Scale value supplied to `HDB_WriteHDWAD`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/hdwad_builder.ml#L1892)

<a id="function-function-up-addallpatchlumps-function-up-addallpatchlumps-images-waddata-lumps-scale-pal-src-hdwad-builder-ml-13953682"></a>
### UP_AddAllPatchLumps

```ml
function UP_AddAllPatchLumps(images, wadData, lumps, scale, pal)
```

Extracts all remaining Doom patch-format graphics such as HUD, menu, title, finale and fonts.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `images` | `dynamic` | — | Images value supplied to `UP_AddAllPatchLumps`. |
| `wadData` | `dynamic` | — | Wad data value supplied to `UP_AddAllPatchLumps`. |
| `lumps` | `dynamic` | — | Lumps value supplied to `UP_AddAllPatchLumps`. |
| `scale` | `dynamic` | — | Scale value supplied to `UP_AddAllPatchLumps`. |
| `pal` | `dynamic` | — | Pal value supplied to `UP_AddAllPatchLumps`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/hdwad_builder.ml#L1548)

<a id="function-function-up-addflatrange-function-up-addflatrange-images-waddata-lumps-startname-endname-scale-pal-src-hdwad-builder-ml-393355073"></a>
### UP_AddFlatRange

```ml
function UP_AddFlatRange(images, wadData, lumps, startName, endName, scale, pal)
```

Extracts flat images from a marker range.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `images` | `dynamic` | — | Images value supplied to `UP_AddFlatRange`. |
| `wadData` | `dynamic` | — | Wad data value supplied to `UP_AddFlatRange`. |
| `lumps` | `dynamic` | — | Lumps value supplied to `UP_AddFlatRange`. |
| `startName` | `dynamic` | — | Start name value supplied to `UP_AddFlatRange`. |
| `endName` | `dynamic` | — | End name value supplied to `UP_AddFlatRange`. |
| `scale` | `dynamic` | — | Scale value supplied to `UP_AddFlatRange`. |
| `pal` | `dynamic` | — | Pal value supplied to `UP_AddFlatRange`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/hdwad_builder.ml#L1467)

<a id="function-function-up-addpatchrange-function-up-addpatchrange-images-waddata-lumps-startname-endname-kind-scale-pal-src-hdwad-builder-ml-515779077"></a>
### UP_AddPatchRange

```ml
function UP_AddPatchRange(images, wadData, lumps, startName, endName, kind, scale, pal)
```

Extracts Doom patch images from a marker range.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `images` | `dynamic` | — | Images value supplied to `UP_AddPatchRange`. |
| `wadData` | `dynamic` | — | Wad data value supplied to `UP_AddPatchRange`. |
| `lumps` | `dynamic` | — | Lumps value supplied to `UP_AddPatchRange`. |
| `startName` | `dynamic` | — | Start name value supplied to `UP_AddPatchRange`. |
| `endName` | `dynamic` | — | End name value supplied to `UP_AddPatchRange`. |
| `kind` | `dynamic` | — | Kind value supplied to `UP_AddPatchRange`. |
| `scale` | `dynamic` | — | Scale value supplied to `UP_AddPatchRange`. |
| `pal` | `dynamic` | — | Pal value supplied to `UP_AddPatchRange`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/hdwad_builder.ml#L1495)

<a id="function-function-up-addtexturelump-function-up-addtexturelump-images-waddata-lumps-lumpname-patchlookup-scale-pal-src-hdwad-builder-ml-952750787"></a>
### UP_AddTextureLump

```ml
function UP_AddTextureLump(images, wadData, lumps, lumpName, patchLookup, scale, pal)
```

Adds composited wall textures from TEXTURE1/TEXTURE2.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `images` | `dynamic` | — | Images value supplied to `UP_AddTextureLump`. |
| `wadData` | `dynamic` | — | Wad data value supplied to `UP_AddTextureLump`. |
| `lumps` | `dynamic` | — | Lumps value supplied to `UP_AddTextureLump`. |
| `lumpName` | `dynamic` | — | Lump name value supplied to `UP_AddTextureLump`. |
| `patchLookup` | `dynamic` | — | Patch lookup value supplied to `UP_AddTextureLump`. |
| `scale` | `dynamic` | — | Scale value supplied to `UP_AddTextureLump`. |
| `pal` | `dynamic` | — | Pal value supplied to `UP_AddTextureLump`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/hdwad_builder.ml#L1578)

<a id="function-function-up-bestedgecolor-function-up-bestedgecolor-pal-center-a-b-hasalpha-src-hdwad-builder-ml-1070491787"></a>
### UP_BestEdgeColor

```ml
function UP_BestEdgeColor(pal, center, a, b, hasAlpha)
```

Chooses the closer edge color for a corner blend.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `pal` | `dynamic` | — | Pal value supplied to `UP_BestEdgeColor`. |
| `center` | `dynamic` | — | Center value supplied to `UP_BestEdgeColor`. |
| `a` | `dynamic` | — | First input operand. |
| `b` | `dynamic` | — | Second input operand. |
| `hasAlpha` | `dynamic` | — | Whether has alpha holds. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/hdwad_builder.ml#L1187)

<a id="function-function-up-bestedgecolorcached-function-up-bestedgecolorcached-pal-cache-center-a-b-hasalpha-src-hdwad-builder-ml-1878513317"></a>
### UP_BestEdgeColorCached

```ml
function UP_BestEdgeColorCached(pal, cache, center, a, b, hasAlpha)
```

Chooses the closer edge color using cached palette distances.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `pal` | `dynamic` | — | Pal value supplied to `UP_BestEdgeColorCached`. |
| `cache` | `dynamic` | — | Cache value supplied to `UP_BestEdgeColorCached`. |
| `center` | `dynamic` | — | Center value supplied to `UP_BestEdgeColorCached`. |
| `a` | `dynamic` | — | First input operand. |
| `b` | `dynamic` | — | Second input operand. |
| `hasAlpha` | `dynamic` | — | Whether has alpha holds. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/hdwad_builder.ml#L1201)

<a id="function-function-up-blendcorner-function-up-blendcorner-dst-dw-blockx-blocky-scale-corner-base-edge-pal-cache-hasalpha-src-hdwad-builder-ml-1817017207"></a>
### UP_BlendCorner

```ml
function UP_BlendCorner(dst, dw, blockX, blockY, scale, corner, base, edge, pal, cache, hasAlpha)
```

Applies a triangular xBRZ corner blend inside one scaled block.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `dst` | `dynamic` | — | Dst value supplied to `UP_BlendCorner`. |
| `dw` | `dynamic` | — | Dw value supplied to `UP_BlendCorner`. |
| `blockX` | `dynamic` | — | Horizontal coordinate or vector component represented by block x. |
| `blockY` | `dynamic` | — | Vertical coordinate or vector component represented by block y. |
| `scale` | `dynamic` | — | Scale value supplied to `UP_BlendCorner`. |
| `corner` | `dynamic` | — | Corner value supplied to `UP_BlendCorner`. |
| `base` | `dynamic` | — | Base value supplied to `UP_BlendCorner`. |
| `edge` | `dynamic` | — | Edge value supplied to `UP_BlendCorner`. |
| `pal` | `dynamic` | — | Pal value supplied to `UP_BlendCorner`. |
| `cache` | `dynamic` | — | Cache value supplied to `UP_BlendCorner`. |
| `hasAlpha` | `dynamic` | — | Whether has alpha holds. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/hdwad_builder.ml#L1231)

<a id="function-function-up-blendedgecolumn-function-up-blendedgecolumn-dst-dw-blockx-blocky-scale-col-base-edge-pal-cache-hasalpha-weight-src-hdwad-builder-ml-1183685192"></a>
### UP_BlendEdgeColumn

```ml
function UP_BlendEdgeColumn(dst, dw, blockX, blockY, scale, col, base, edge, pal, cache, hasAlpha, weight)
```

Blends one vertical edge of a scaled block toward a neighboring edge color.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `dst` | `dynamic` | — | Dst value supplied to `UP_BlendEdgeColumn`. |
| `dw` | `dynamic` | — | Dw value supplied to `UP_BlendEdgeColumn`. |
| `blockX` | `dynamic` | — | Horizontal coordinate or vector component represented by block x. |
| `blockY` | `dynamic` | — | Vertical coordinate or vector component represented by block y. |
| `scale` | `dynamic` | — | Scale value supplied to `UP_BlendEdgeColumn`. |
| `col` | `dynamic` | — | Col value supplied to `UP_BlendEdgeColumn`. |
| `base` | `dynamic` | — | Base value supplied to `UP_BlendEdgeColumn`. |
| `edge` | `dynamic` | — | Edge value supplied to `UP_BlendEdgeColumn`. |
| `pal` | `dynamic` | — | Pal value supplied to `UP_BlendEdgeColumn`. |
| `cache` | `dynamic` | — | Cache value supplied to `UP_BlendEdgeColumn`. |
| `hasAlpha` | `dynamic` | — | Whether has alpha holds. |
| `weight` | `dynamic` | — | Weight value supplied to `UP_BlendEdgeColumn`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/hdwad_builder.ml#L1300)

<a id="function-function-up-blendedgerow-function-up-blendedgerow-dst-dw-blockx-blocky-scale-row-base-edge-pal-cache-hasalpha-weight-src-hdwad-builder-ml-438735274"></a>
### UP_BlendEdgeRow

```ml
function UP_BlendEdgeRow(dst, dw, blockX, blockY, scale, row, base, edge, pal, cache, hasAlpha, weight)
```

Blends one horizontal edge of a scaled block toward a neighboring edge color.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `dst` | `dynamic` | — | Dst value supplied to `UP_BlendEdgeRow`. |
| `dw` | `dynamic` | — | Dw value supplied to `UP_BlendEdgeRow`. |
| `blockX` | `dynamic` | — | Horizontal coordinate or vector component represented by block x. |
| `blockY` | `dynamic` | — | Vertical coordinate or vector component represented by block y. |
| `scale` | `dynamic` | — | Scale value supplied to `UP_BlendEdgeRow`. |
| `row` | `dynamic` | — | Row value supplied to `UP_BlendEdgeRow`. |
| `base` | `dynamic` | — | Base value supplied to `UP_BlendEdgeRow`. |
| `edge` | `dynamic` | — | Edge value supplied to `UP_BlendEdgeRow`. |
| `pal` | `dynamic` | — | Pal value supplied to `UP_BlendEdgeRow`. |
| `cache` | `dynamic` | — | Cache value supplied to `UP_BlendEdgeRow`. |
| `hasAlpha` | `dynamic` | — | Whether has alpha holds. |
| `weight` | `dynamic` | — | Weight value supplied to `UP_BlendEdgeRow`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/hdwad_builder.ml#L1276)

<a id="function-function-up-blendindex-function-up-blendindex-pal-cache-base-edge-edgeweight-hasalpha-src-hdwad-builder-ml-1080132460"></a>
### UP_BlendIndex

```ml
function UP_BlendIndex(pal, cache, base, edge, edgeWeight, hasAlpha)
```

Blends two palette indices and quantizes the result.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `pal` | `dynamic` | — | Pal value supplied to `UP_BlendIndex`. |
| `cache` | `dynamic` | — | Cache value supplied to `UP_BlendIndex`. |
| `base` | `dynamic` | — | Base value supplied to `UP_BlendIndex`. |
| `edge` | `dynamic` | — | Edge value supplied to `UP_BlendIndex`. |
| `edgeWeight` | `dynamic` | — | Edge weight value supplied to `UP_BlendIndex`. |
| `hasAlpha` | `dynamic` | — | Whether has alpha holds. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/hdwad_builder.ml#L610)

<a id="function-function-up-blendindexratio-function-up-blendindexratio-pal-cache-base-edge-ratiocode-hasalpha-src-hdwad-builder-ml-585129005"></a>
### UP_BlendIndexRatio

```ml
function UP_BlendIndexRatio(pal, cache, base, edge, ratioCode, hasAlpha)
```

Controls blend Index Ratio transitions in the HDWAD builder system.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `pal` | `dynamic` | — | Pal value supplied to `UP_BlendIndexRatio`. |
| `cache` | `dynamic` | — | Cache value supplied to `UP_BlendIndexRatio`. |
| `base` | `dynamic` | — | Base value supplied to `UP_BlendIndexRatio`. |
| `edge` | `dynamic` | — | Edge value supplied to `UP_BlendIndexRatio`. |
| `ratioCode` | `dynamic` | — | Ratio code value supplied to `UP_BlendIndexRatio`. |
| `hasAlpha` | `dynamic` | — | Whether has alpha holds. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/hdwad_builder.ml#L685)

<a id="function-function-up-buildtextureimage-function-up-buildtextureimage-tex-waddata-lumps-src-hdwad-builder-ml-1884074262"></a>
### UP_BuildTextureImage

```ml
function UP_BuildTextureImage(tex, wadData, lumps)
```

Composites a wall texture from its source patch placements.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `tex` | `dynamic` | — | Texture identifier or texture data to process. |
| `wadData` | `dynamic` | — | Wad data value supplied to `UP_BuildTextureImage`. |
| `lumps` | `dynamic` | — | Lumps value supplied to `UP_BuildTextureImage`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/hdwad_builder.ml#L477)

<a id="function-function-up-clampscale-inline-function-up-clampscale-v-src-hdwad-builder-ml-1878835579"></a>
### UP_ClampScale

```ml
inline function UP_ClampScale(v)
```

Keeps output scale inside the supported package range.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `v` | `dynamic` | — | Value consumed by the operation. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/hdwad_builder.ml#L203)

<a id="function-function-up-colordistance-function-up-colordistance-pal-a-b-hasalpha-src-hdwad-builder-ml-1082153454"></a>
### UP_ColorDistance

```ml
function UP_ColorDistance(pal, a, b, hasAlpha)
```

Computes weighted RGB distance for xBRZ edge decisions.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `pal` | `dynamic` | — | Pal value supplied to `UP_ColorDistance`. |
| `a` | `dynamic` | — | First input operand. |
| `b` | `dynamic` | — | Second input operand. |
| `hasAlpha` | `dynamic` | — | Whether has alpha holds. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/hdwad_builder.ml#L509)

<a id="function-function-up-colordistancecached-function-up-colordistancecached-pal-cache-a-b-hasalpha-src-hdwad-builder-ml-646408364"></a>
### UP_ColorDistanceCached

```ml
function UP_ColorDistanceCached(pal, cache, a, b, hasAlpha)
```

Computes palette distance with a per-image 256x256 cache.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `pal` | `dynamic` | — | Pal value supplied to `UP_ColorDistanceCached`. |
| `cache` | `dynamic` | — | Cache value supplied to `UP_ColorDistanceCached`. |
| `a` | `dynamic` | — | First input operand. |
| `b` | `dynamic` | — | Second input operand. |
| `hasAlpha` | `dynamic` | — | Whether has alpha holds. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/hdwad_builder.ml#L527)

<a id="function-function-up-copybytes-function-up-copybytes-dst-dstoff-src-srcoff-count-src-hdwad-builder-ml-1525350391"></a>
### UP_CopyBytes

```ml
function UP_CopyBytes(dst, dstOff, src, srcOff, count)
```

Copies a byte range.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `dst` | `dynamic` | — | Dst value supplied to `UP_CopyBytes`. |
| `dstOff` | `dynamic` | — | Dst off value supplied to `UP_CopyBytes`. |
| `src` | `dynamic` | — | Src value supplied to `UP_CopyBytes`. |
| `srcOff` | `dynamic` | — | Src off value supplied to `UP_CopyBytes`. |
| `count` | `dynamic` | — | Number of elements or iterations to process. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/hdwad_builder.ml#L235)

<a id="function-function-up-cornerweight-inline-function-up-cornerweight-dist-scale-src-hdwad-builder-ml-600308955"></a>
### UP_CornerWeight

```ml
inline function UP_CornerWeight(dist, scale)
```

Returns the local xBRZ corner blend weight for one block coordinate.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `dist` | `dynamic` | — | Dist value supplied to `UP_CornerWeight`. |
| `scale` | `dynamic` | — | Scale value supplied to `UP_CornerWeight`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/hdwad_builder.ml#L1211)

<a id="function-function-up-countmarkerrange-function-up-countmarkerrange-lumps-startname-endname-src-hdwad-builder-ml-2034395852"></a>
### UP_CountMarkerRange

```ml
function UP_CountMarkerRange(lumps, startName, endName)
```

Counts WAD lumps between two marker names for progress estimation.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `lumps` | `dynamic` | — | Lumps value supplied to `UP_CountMarkerRange`. |
| `startName` | `dynamic` | — | Start name value supplied to `UP_CountMarkerRange`. |
| `endName` | `dynamic` | — | End name value supplied to `UP_CountMarkerRange`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/hdwad_builder.ml#L1597)

<a id="function-function-up-decodepatch-function-up-decodepatch-name-kind-lumpdata-src-hdwad-builder-ml-1988572937"></a>
### UP_DecodePatch

```ml
function UP_DecodePatch(name, kind, lumpData)
```

Converts a Doom patch lump into a palettized rectangular image.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `name` | `dynamic` | — | Resource or object name to resolve. |
| `kind` | `dynamic` | — | Kind value supplied to `UP_DecodePatch`. |
| `lumpData` | `dynamic` | — | Lump data value supplied to `UP_DecodePatch`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/hdwad_builder.ml#L325)

<a id="function-function-up-defaultpalette-function-up-defaultpalette-src-hdwad-builder-ml-567595022"></a>
### UP_DefaultPalette

```ml
function UP_DefaultPalette()
```

Builds a grayscale fallback palette.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/hdwad_builder.ml#L281)

<a id="function-function-up-drawpatchtotexture-function-up-drawpatchtotexture-patch-canvas-texw-texh-originx-originy-src-hdwad-builder-ml-2111693240"></a>
### UP_DrawPatchToTexture

```ml
function UP_DrawPatchToTexture(patch, canvas, texW, texH, originX, originY)
```

Draws a decoded patch image into an indexed texture canvas.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `patch` | `dynamic` | — | Patch value supplied to `UP_DrawPatchToTexture`. |
| `canvas` | `dynamic` | — | Canvas value supplied to `UP_DrawPatchToTexture`. |
| `texW` | `dynamic` | — | Tex w value supplied to `UP_DrawPatchToTexture`. |
| `texH` | `dynamic` | — | Tex h value supplied to `UP_DrawPatchToTexture`. |
| `originX` | `dynamic` | — | Horizontal coordinate or vector component represented by origin x. |
| `originY` | `dynamic` | — | Vertical coordinate or vector component represented by origin y. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/hdwad_builder.ml#L451)

<a id="function-function-up-findlump-function-up-findlump-lumps-name-src-hdwad-builder-ml-146086334"></a>
### UP_FindLump

```ml
function UP_FindLump(lumps, name)
```

Finds a lump by name.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `lumps` | `dynamic` | — | Lumps value supplied to `UP_FindLump`. |
| `name` | `dynamic` | — | Resource or object name to resolve. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/hdwad_builder.ml#L259)

<a id="function-function-up-findmarker-function-up-findmarker-lumps-name-src-hdwad-builder-ml-1401415546"></a>
### UP_FindMarker

```ml
function UP_FindMarker(lumps, name)
```

Finds the first lump marker with the given name.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `lumps` | `dynamic` | — | Lumps value supplied to `UP_FindMarker`. |
| `name` | `dynamic` | — | Resource or object name to resolve. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/hdwad_builder.ml#L246)

<a id="constant-constant-up-flag-transparent-const-up-flag-transparent-1-src-hdwad-builder-ml-2129477084"></a>
### UP_FLAG_TRANSPARENT

```ml
const UP_FLAG_TRANSPARENT = 1
```

Defines up flag transparent for the hdwad builder subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/hdwad_builder.ml#L52)

<a id="function-function-up-hasimage-function-up-hasimage-images-kind-name-src-hdwad-builder-ml-92544639"></a>
### UP_HasImage

```ml
function UP_HasImage(images, kind, name)
```

Checks whether an image with the same kind/name was already emitted.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `images` | `dynamic` | — | Images value supplied to `UP_HasImage`. |
| `kind` | `dynamic` | — | Kind value supplied to `UP_HasImage`. |
| `name` | `dynamic` | — | Resource or object name to resolve. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/hdwad_builder.ml#L1520)

- [up_image_t](Type-up-image-t-2112468313.md) — struct
<a id="function-function-up-islikelypatch-function-up-islikelypatch-data-src-hdwad-builder-ml-1058920954"></a>
### UP_IsLikelyPatch

```ml
function UP_IsLikelyPatch(data)
```

Performs conservative validation for Doom patch data.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `data` | `dynamic` | — | Binary or structured data to process. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/hdwad_builder.ml#L309)

<a id="function-function-up-ismarkername-function-up-ismarkername-name-src-hdwad-builder-ml-388596395"></a>
### UP_IsMarkerName

```ml
function UP_IsMarkerName(name)
```

Avoids trying marker/control lumps as patch images.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `name` | `dynamic` | — | Resource or object name to resolve. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/hdwad_builder.ml#L1533)

<a id="function-function-up-istransparent-inline-function-up-istransparent-idx-hasalpha-src-hdwad-builder-ml-2003587156"></a>
### UP_IsTransparent

```ml
inline function UP_IsTransparent(idx, hasAlpha)
```

Checks whether an indexed pixel is transparent for patch-like images.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `idx` | `dynamic` | — | Zero-based element or table index. |
| `hasAlpha` | `dynamic` | — | Whether has alpha holds. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/hdwad_builder.ml#L500)

<a id="function-function-up-loadingpulse-inline-function-up-loadingpulse-src-hdwad-builder-ml-2029973617"></a>
### UP_LoadingPulse

```ml
inline function UP_LoadingPulse()
```

Pumps the host window while HDWAD generation performs long CPU-bound work.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/hdwad_builder.ml#L73)

<a id="function-function-up-loadpalette-function-up-loadpalette-waddata-lumps-src-hdwad-builder-ml-61373445"></a>
### UP_LoadPalette

```ml
function UP_LoadPalette(wadData, lumps)
```

Extracts the first PLAYPAL palette from the WAD.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `wadData` | `dynamic` | — | Wad data value supplied to `UP_LoadPalette`. |
| `lumps` | `dynamic` | — | Lumps value supplied to `UP_LoadPalette`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/hdwad_builder.ml#L297)

<a id="function-function-up-loadwad-function-up-loadwad-path-src-hdwad-builder-ml-581096753"></a>
### UP_LoadWad

```ml
function UP_LoadWad(path)
```

Reads a WAD and returns [data, lumps].

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `path` | `dynamic` | — | Filesystem path to process. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/hdwad_builder.ml#L1423)

- [up_lump_t](Type-up-lump-t-1367844628.md) — struct
<a id="function-function-up-lumpbytes-function-up-lumpbytes-waddata-lumps-idx-src-hdwad-builder-ml-1858335110"></a>
### UP_LumpBytes

```ml
function UP_LumpBytes(wadData, lumps, idx)
```

Returns a lump payload or void.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `wadData` | `dynamic` | — | Wad data value supplied to `UP_LumpBytes`. |
| `lumps` | `dynamic` | — | Lumps value supplied to `UP_LumpBytes`. |
| `idx` | `dynamic` | — | Zero-based element or table index. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/hdwad_builder.ml#L273)

<a id="constant-constant-up-magic0-const-up-magic0-77-src-hdwad-builder-ml-1450714777"></a>
### UP_MAGIC0

```ml
const UP_MAGIC0 = 77
```

Defines up magic0 for the hdwad builder subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/hdwad_builder.ml#L24)

<a id="constant-constant-up-magic1-const-up-magic1-68-src-hdwad-builder-ml-1447733005"></a>
### UP_MAGIC1

```ml
const UP_MAGIC1 = 68
```

Defines up magic1 for the hdwad builder subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/hdwad_builder.ml#L26)

<a id="constant-constant-up-magic2-const-up-magic2-85-src-hdwad-builder-ml-1682751950"></a>
### UP_MAGIC2

```ml
const UP_MAGIC2 = 85
```

Defines up magic2 for the hdwad builder subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/hdwad_builder.ml#L28)

<a id="constant-constant-up-magic3-const-up-magic3-80-src-hdwad-builder-ml-2041840355"></a>
### UP_MAGIC3

```ml
const UP_MAGIC3 = 80
```

Defines up magic3 for the hdwad builder subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/hdwad_builder.ml#L30)

<a id="function-function-up-name8-function-up-name8-b-src-hdwad-builder-ml-1721344886"></a>
### UP_Name8

```ml
function UP_Name8(b)
```

Decodes a WAD name.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `b` | `dynamic` | — | Second input operand. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/hdwad_builder.ml#L212)

<a id="function-function-up-nearestpaletteindex-function-up-nearestpaletteindex-pal-r-g-b-hasalpha-src-hdwad-builder-ml-1002562574"></a>
### UP_NearestPaletteIndex

```ml
function UP_NearestPaletteIndex(pal, r, g, b, hasAlpha)
```

Quantizes an RGB color back to the Doom palette.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `pal` | `dynamic` | — | Pal value supplied to `UP_NearestPaletteIndex`. |
| `r` | `dynamic` | — | R value supplied to `UP_NearestPaletteIndex`. |
| `g` | `dynamic` | — | G value supplied to `UP_NearestPaletteIndex`. |
| `b` | `dynamic` | — | Second input operand. |
| `hasAlpha` | `dynamic` | — | Whether has alpha holds. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/hdwad_builder.ml#L579)

<a id="constant-constant-up-opaque-255-remap-const-up-opaque-255-remap-254-src-hdwad-builder-ml-1343832888"></a>
### UP_OPAQUE_255_REMAP

```ml
const UP_OPAQUE_255_REMAP = 254
```

Defines up opaque 255 remap for the hdwad builder subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/hdwad_builder.ml#L56)

<a id="function-function-up-parsepnames-function-up-parsepnames-waddata-lumps-src-hdwad-builder-ml-621107689"></a>
### UP_ParsePnames

```ml
function UP_ParsePnames(wadData, lumps)
```

Builds PNAMES patch-name to lump-index mapping.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `wadData` | `dynamic` | — | Wad data value supplied to `UP_ParsePnames`. |
| `lumps` | `dynamic` | — | Lumps value supplied to `UP_ParsePnames`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/hdwad_builder.ml#L367)

<a id="function-function-up-parsetexturelump-function-up-parsetexturelump-waddata-lumps-lumpname-patchlookup-src-hdwad-builder-ml-2117002350"></a>
### UP_ParseTextureLump

```ml
function UP_ParseTextureLump(wadData, lumps, lumpName, patchLookup)
```

Parses TEXTURE1/TEXTURE2 wall texture definitions.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `wadData` | `dynamic` | — | Wad data value supplied to `UP_ParseTextureLump`. |
| `lumps` | `dynamic` | — | Lumps value supplied to `UP_ParseTextureLump`. |
| `lumpName` | `dynamic` | — | Lump name value supplied to `UP_ParseTextureLump`. |
| `patchLookup` | `dynamic` | — | Patch lookup value supplied to `UP_ParseTextureLump`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/hdwad_builder.ml#L391)

<a id="function-function-up-pixelat-inline-function-up-pixelat-src-w-h-x-y-src-hdwad-builder-ml-1326570123"></a>
### UP_PixelAt

```ml
inline function UP_PixelAt(src, w, h, x, y)
```

Reads a clamped source pixel.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `src` | `dynamic` | — | Src value supplied to `UP_PixelAt`. |
| `w` | `dynamic` | — | W value supplied to `UP_PixelAt`. |
| `h` | `dynamic` | — | H value supplied to `UP_PixelAt`. |
| `x` | `dynamic` | — | Horizontal map- or screen-space coordinate. |
| `y` | `dynamic` | — | Vertical map- or screen-space coordinate. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/hdwad_builder.ml#L565)

<a id="function-function-up-reads16-inline-function-up-reads16-b-off-src-hdwad-builder-ml-1575425656"></a>
### UP_ReadS16

```ml
inline function UP_ReadS16(b, off)
```

Reads a little-endian s16.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `b` | `dynamic` | — | Second input operand. |
| `off` | `dynamic` | — | Zero-based byte or element offset. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/hdwad_builder.ml#L149)

<a id="function-function-up-reads32-inline-function-up-reads32-b-off-src-hdwad-builder-ml-468734636"></a>
### UP_ReadS32

```ml
inline function UP_ReadS32(b, off)
```

Reads a little-endian s32.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `b` | `dynamic` | — | Second input operand. |
| `off` | `dynamic` | — | Zero-based byte or element offset. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/hdwad_builder.ml#L165)

<a id="function-function-up-readu16-inline-function-up-readu16-b-off-src-hdwad-builder-ml-553761624"></a>
### UP_ReadU16

```ml
inline function UP_ReadU16(b, off)
```

Reads a little-endian u16.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `b` | `dynamic` | — | Second input operand. |
| `off` | `dynamic` | — | Zero-based byte or element offset. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/hdwad_builder.ml#L142)

<a id="function-function-up-readu32-inline-function-up-readu32-b-off-src-hdwad-builder-ml-875338036"></a>
### UP_ReadU32

```ml
inline function UP_ReadU32(b, off)
```

Reads a little-endian u32.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `b` | `dynamic` | — | Second input operand. |
| `off` | `dynamic` | — | Zero-based byte or element offset. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/hdwad_builder.ml#L158)

<a id="function-function-up-reportprogress-inline-function-up-reportprogress-units-src-hdwad-builder-ml-456387046"></a>
### UP_ReportProgress

```ml
inline function UP_ReportProgress(units)
```

Reports one or more HDWAD generation units to the frontend progress display.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `units` | `dynamic` | — | Units value supplied to `UP_ReportProgress`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/hdwad_builder.ml#L79)

<a id="function-function-up-similarcolor-inline-function-up-similarcolor-pal-a-b-hasalpha-src-hdwad-builder-ml-1132619571"></a>
### UP_SimilarColor

```ml
inline function UP_SimilarColor(pal, a, b, hasAlpha)
```

Evaluates xBRZ-style color equality with a distance threshold.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `pal` | `dynamic` | — | Pal value supplied to `UP_SimilarColor`. |
| `a` | `dynamic` | — | First input operand. |
| `b` | `dynamic` | — | Second input operand. |
| `hasAlpha` | `dynamic` | — | Whether has alpha holds. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/hdwad_builder.ml#L545)

<a id="function-function-up-similarcolorcached-inline-function-up-similarcolorcached-pal-cache-a-b-hasalpha-src-hdwad-builder-ml-2045014575"></a>
### UP_SimilarColorCached

```ml
inline function UP_SimilarColorCached(pal, cache, a, b, hasAlpha)
```

Evaluates xBRZ-style equality using the per-image distance cache.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `pal` | `dynamic` | — | Pal value supplied to `UP_SimilarColorCached`. |
| `cache` | `dynamic` | — | Cache value supplied to `UP_SimilarColorCached`. |
| `a` | `dynamic` | — | First input operand. |
| `b` | `dynamic` | — | Second input operand. |
| `hasAlpha` | `dynamic` | — | Whether has alpha holds. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/hdwad_builder.ml#L555)

<a id="function-function-up-strongedgeweight-inline-function-up-strongedgeweight-pal-base-edge-hasalpha-src-hdwad-builder-ml-1054262796"></a>
### UP_StrongEdgeWeight

```ml
inline function UP_StrongEdgeWeight(pal, base, edge, hasAlpha)
```

Chooses a slightly stronger blend for hard pixel-art edges.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `pal` | `dynamic` | — | Pal value supplied to `UP_StrongEdgeWeight`. |
| `base` | `dynamic` | — | Base value supplied to `UP_StrongEdgeWeight`. |
| `edge` | `dynamic` | — | Edge value supplied to `UP_StrongEdgeWeight`. |
| `hasAlpha` | `dynamic` | — | Whether has alpha holds. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/hdwad_builder.ml#L1316)

<a id="function-function-up-strongedgeweightcached-inline-function-up-strongedgeweightcached-pal-cache-base-edge-hasalpha-src-hdwad-builder-ml-616442488"></a>
### UP_StrongEdgeWeightCached

```ml
inline function UP_StrongEdgeWeightCached(pal, cache, base, edge, hasAlpha)
```

Chooses blend strength using cached palette distances.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `pal` | `dynamic` | — | Pal value supplied to `UP_StrongEdgeWeightCached`. |
| `cache` | `dynamic` | — | Cache value supplied to `UP_StrongEdgeWeightCached`. |
| `base` | `dynamic` | — | Base value supplied to `UP_StrongEdgeWeightCached`. |
| `edge` | `dynamic` | — | Edge value supplied to `UP_StrongEdgeWeightCached`. |
| `hasAlpha` | `dynamic` | — | Whether has alpha holds. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/hdwad_builder.ml#L1328)

- [up_texpatch_t](Type-up-texpatch-t-1141726135.md) — struct
- [up_texture_t](Type-up-texture-t-1531111095.md) — struct
<a id="function-function-up-tointor-function-up-tointor-v-fallback-src-hdwad-builder-ml-963143820"></a>
### UP_ToIntOr

```ml
function UP_ToIntOr(v, fallback)
```

Converts a value to int with fallback.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `v` | `dynamic` | — | Value consumed by the operation. |
| `fallback` | `dynamic` | — | Value returned when the requested conversion or lookup is unavailable. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/hdwad_builder.ml#L186)

<a id="constant-constant-up-transparent-index-const-up-transparent-index-255-src-hdwad-builder-ml-2017858681"></a>
### UP_TRANSPARENT_INDEX

```ml
const UP_TRANSPARENT_INDEX = 255
```

Defines up transparent index for the hdwad builder subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/hdwad_builder.ml#L54)

<a id="constant-constant-up-type-flat-const-up-type-flat-2-src-hdwad-builder-ml-314641449"></a>
### UP_TYPE_FLAT

```ml
const UP_TYPE_FLAT = 2
```

Defines up type flat for the hdwad builder subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/hdwad_builder.ml#L45)

<a id="constant-constant-up-type-patch-const-up-type-patch-1-src-hdwad-builder-ml-1200545344"></a>
### UP_TYPE_PATCH

```ml
const UP_TYPE_PATCH = 1
```

Defines up type patch for the hdwad builder subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/hdwad_builder.ml#L43)

<a id="constant-constant-up-type-sprite-const-up-type-sprite-4-src-hdwad-builder-ml-1262926623"></a>
### UP_TYPE_SPRITE

```ml
const UP_TYPE_SPRITE = 4
```

Defines up type sprite for the hdwad builder subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/hdwad_builder.ml#L49)

<a id="constant-constant-up-type-texture-const-up-type-texture-3-src-hdwad-builder-ml-397870478"></a>
### UP_TYPE_TEXTURE

```ml
const UP_TYPE_TEXTURE = 3
```

Defines up type texture for the hdwad builder subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/hdwad_builder.ml#L47)

<a id="constant-constant-up-version-const-up-version-6-src-hdwad-builder-ml-1064245145"></a>
### UP_VERSION

```ml
const UP_VERSION = 6
```

Defines up version for the hdwad builder subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/hdwad_builder.ml#L40)

<a id="function-function-up-writehdwadpackage-function-up-writehdwadpackage-path-waddata-lumps-images-scale-src-hdwad-builder-ml-1185858904"></a>
### UP_WriteHDWADPackage

```ml
function UP_WriteHDWADPackage(path, wadData, lumps, images, scale)
```

Emits a complete HDWAD containing original lumps and upscaled images by delegating with no synthetic lumps.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `path` | `dynamic` | — | Filesystem path to process. |
| `wadData` | `dynamic` | — | Wad data value supplied to `UP_WriteHDWADPackage`. |
| `lumps` | `dynamic` | — | Lumps value supplied to `UP_WriteHDWADPackage`. |
| `images` | `dynamic` | — | Images value supplied to `UP_WriteHDWADPackage`. |
| `scale` | `dynamic` | — | Scale value supplied to `UP_WriteHDWADPackage`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/hdwad_builder.ml#L1699)

<a id="function-function-up-writehdwadpackagewithextralumps-function-up-writehdwadpackagewithextralumps-path-waddata-lumps-images-extranames-extradatas-scale-src-hdwad-builder-ml-190671691"></a>
### UP_WriteHDWADPackageWithExtraLumps

```ml
function UP_WriteHDWADPackageWithExtraLumps(path, wadData, lumps, images, extraNames, extraDatas, scale)
```

Lays out an HDWAD header, original and synthetic lump payloads, image payloads, and both directories before saving atomically.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `path` | `dynamic` | — | Filesystem path to process. |
| `wadData` | `dynamic` | — | Wad data value supplied to `UP_WriteHDWADPackageWithExtraLumps`. |
| `lumps` | `dynamic` | — | Lumps value supplied to `UP_WriteHDWADPackageWithExtraLumps`. |
| `images` | `dynamic` | — | Images value supplied to `UP_WriteHDWADPackageWithExtraLumps`. |
| `extraNames` | `dynamic` | — | Extra names value supplied to `UP_WriteHDWADPackageWithExtraLumps`. |
| `extraDatas` | `dynamic` | — | Extra datas value supplied to `UP_WriteHDWADPackageWithExtraLumps`. |
| `scale` | `dynamic` | — | Scale value supplied to `UP_WriteHDWADPackageWithExtraLumps`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/hdwad_builder.ml#L1712)

<a id="function-function-up-writepackage-function-up-writepackage-path-images-scale-src-hdwad-builder-ml-27442347"></a>
### UP_WritePackage

```ml
function UP_WritePackage(path, images, scale)
```

Writes extracted images as a MiniDoom upscaled package.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `path` | `dynamic` | — | Filesystem path to process. |
| `images` | `dynamic` | — | Images value supplied to `UP_WritePackage`. |
| `scale` | `dynamic` | — | Scale value supplied to `UP_WritePackage`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/hdwad_builder.ml#L1626)

<a id="function-function-up-writeu32-inline-function-up-writeu32-b-off-value-src-hdwad-builder-ml-436765929"></a>
### UP_WriteU32

```ml
inline function UP_WriteU32(b, off, value)
```

Writes a little-endian u32.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `b` | `dynamic` | — | Second input operand. |
| `off` | `dynamic` | — | Zero-based byte or element offset. |
| `value` | `dynamic` | — | Value consumed by the operation. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/hdwad_builder.ml#L175)

<a id="constant-constant-up-xbrz-blend-dominant-const-up-xbrz-blend-dominant-2-src-hdwad-builder-ml-183971779"></a>
### UP_XBRZ_BLEND_DOMINANT

```ml
const UP_XBRZ_BLEND_DOMINANT = 2
```

Defines up xbrz blend dominant for the hdwad builder subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/hdwad_builder.ml#L64)

<a id="constant-constant-up-xbrz-blend-none-const-up-xbrz-blend-none-0-src-hdwad-builder-ml-1983908485"></a>
### UP_XBRZ_BLEND_NONE

```ml
const UP_XBRZ_BLEND_NONE = 0
```

Defines up xbrz blend none for the hdwad builder subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/hdwad_builder.ml#L60)

<a id="constant-constant-up-xbrz-blend-normal-const-up-xbrz-blend-normal-1-src-hdwad-builder-ml-1760616938"></a>
### UP_XBRZ_BLEND_NORMAL

```ml
const UP_XBRZ_BLEND_NORMAL = 1
```

Defines up xbrz blend normal for the hdwad builder subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/hdwad_builder.ml#L62)

<a id="constant-constant-up-xbrz-dist-limit-const-up-xbrz-dist-limit-4200-src-hdwad-builder-ml-1033001529"></a>
### UP_XBRZ_DIST_LIMIT

```ml
const UP_XBRZ_DIST_LIMIT = 4200
```

Defines up xbrz dist limit for the hdwad builder subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/hdwad_builder.ml#L58)

<a id="constant-constant-up-xbrz-dominant-direction-threshold-const-up-xbrz-dominant-direction-threshold-3-6-src-hdwad-builder-ml-2084003270"></a>
### UP_XBRZ_DOMINANT_DIRECTION_THRESHOLD

```ml
const UP_XBRZ_DOMINANT_DIRECTION_THRESHOLD = 3.6
```

Defines up xbrz dominant direction threshold for the hdwad builder subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/hdwad_builder.ml#L68)

<a id="constant-constant-up-xbrz-equal-color-tolerance-const-up-xbrz-equal-color-tolerance-30-src-hdwad-builder-ml-1951082172"></a>
### UP_XBRZ_EQUAL_COLOR_TOLERANCE

```ml
const UP_XBRZ_EQUAL_COLOR_TOLERANCE = 30.
```

Defines the Doom palette selection for up xbrz equal color tolerance.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/hdwad_builder.ml#L66)

<a id="constant-constant-up-xbrz-steep-direction-threshold-const-up-xbrz-steep-direction-threshold-2-2-src-hdwad-builder-ml-2108714735"></a>
### UP_XBRZ_STEEP_DIRECTION_THRESHOLD

```ml
const UP_XBRZ_STEEP_DIRECTION_THRESHOLD = 2.2
```

Defines up xbrz steep direction threshold for the hdwad builder subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/hdwad_builder.ml#L70)

<a id="function-function-up-xbrzblendcorner3-function-up-xbrzblendcorner3-dst-dw-blockx-blocky-rot-col-pal-blendcache-hasalpha-src-hdwad-builder-ml-1737776994"></a>
### UP_XbrzBlendCorner3

```ml
function UP_XbrzBlendCorner3(dst, dw, blockX, blockY, rot, col, pal, blendCache, hasAlpha)
```

Controls xbrz Blend Corner3 transitions in the HDWAD builder system.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `dst` | `dynamic` | — | Dst value supplied to `UP_XbrzBlendCorner3`. |
| `dw` | `dynamic` | — | Dw value supplied to `UP_XbrzBlendCorner3`. |
| `blockX` | `dynamic` | — | Horizontal coordinate or vector component represented by block x. |
| `blockY` | `dynamic` | — | Vertical coordinate or vector component represented by block y. |
| `rot` | `dynamic` | — | Rot value supplied to `UP_XbrzBlendCorner3`. |
| `col` | `dynamic` | — | Col value supplied to `UP_XbrzBlendCorner3`. |
| `pal` | `dynamic` | — | Pal value supplied to `UP_XbrzBlendCorner3`. |
| `blendCache` | `dynamic` | — | Blend cache value supplied to `UP_XbrzBlendCorner3`. |
| `hasAlpha` | `dynamic` | — | Whether has alpha holds. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/hdwad_builder.ml#L1015)

<a id="function-function-up-xbrzblendlinediagonal3-function-up-xbrzblendlinediagonal3-dst-dw-blockx-blocky-rot-col-pal-blendcache-hasalpha-src-hdwad-builder-ml-1305918334"></a>
### UP_XbrzBlendLineDiagonal3

```ml
function UP_XbrzBlendLineDiagonal3(dst, dw, blockX, blockY, rot, col, pal, blendCache, hasAlpha)
```

Applies the xBRZ 3x diagonal-edge weights to the two adjacent cells and corner cell.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `dst` | `dynamic` | — | Dst value supplied to `UP_XbrzBlendLineDiagonal3`. |
| `dw` | `dynamic` | — | Dw value supplied to `UP_XbrzBlendLineDiagonal3`. |
| `blockX` | `dynamic` | — | Horizontal coordinate or vector component represented by block x. |
| `blockY` | `dynamic` | — | Vertical coordinate or vector component represented by block y. |
| `rot` | `dynamic` | — | Rot value supplied to `UP_XbrzBlendLineDiagonal3`. |
| `col` | `dynamic` | — | Col value supplied to `UP_XbrzBlendLineDiagonal3`. |
| `pal` | `dynamic` | — | Pal value supplied to `UP_XbrzBlendLineDiagonal3`. |
| `blendCache` | `dynamic` | — | Blend cache value supplied to `UP_XbrzBlendLineDiagonal3`. |
| `hasAlpha` | `dynamic` | — | Whether has alpha holds. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/hdwad_builder.ml#L999)

<a id="function-function-up-xbrzblendlineshallow3-function-up-xbrzblendlineshallow3-dst-dw-blockx-blocky-rot-col-pal-blendcache-hasalpha-src-hdwad-builder-ml-535023524"></a>
### UP_XbrzBlendLineShallow3

```ml
function UP_XbrzBlendLineShallow3(dst, dw, blockX, blockY, rot, col, pal, blendCache, hasAlpha)
```

Applies the xBRZ 3x shallow-edge coverage pattern with weighted blends and one fully replaced corner pixel.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `dst` | `dynamic` | — | Dst value supplied to `UP_XbrzBlendLineShallow3`. |
| `dw` | `dynamic` | — | Dw value supplied to `UP_XbrzBlendLineShallow3`. |
| `blockX` | `dynamic` | — | Horizontal coordinate or vector component represented by block x. |
| `blockY` | `dynamic` | — | Vertical coordinate or vector component represented by block y. |
| `rot` | `dynamic` | — | Rot value supplied to `UP_XbrzBlendLineShallow3`. |
| `col` | `dynamic` | — | Col value supplied to `UP_XbrzBlendLineShallow3`. |
| `pal` | `dynamic` | — | Pal value supplied to `UP_XbrzBlendLineShallow3`. |
| `blendCache` | `dynamic` | — | Blend cache value supplied to `UP_XbrzBlendLineShallow3`. |
| `hasAlpha` | `dynamic` | — | Whether has alpha holds. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/hdwad_builder.ml#L947)

<a id="function-function-up-xbrzblendlinesteep3-function-up-xbrzblendlinesteep3-dst-dw-blockx-blocky-rot-col-pal-blendcache-hasalpha-src-hdwad-builder-ml-2082193308"></a>
### UP_XbrzBlendLineSteep3

```ml
function UP_XbrzBlendLineSteep3(dst, dw, blockX, blockY, rot, col, pal, blendCache, hasAlpha)
```

Applies the rotated xBRZ 3x steep-edge coverage pattern to the current destination block.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `dst` | `dynamic` | — | Dst value supplied to `UP_XbrzBlendLineSteep3`. |
| `dw` | `dynamic` | — | Dw value supplied to `UP_XbrzBlendLineSteep3`. |
| `blockX` | `dynamic` | — | Horizontal coordinate or vector component represented by block x. |
| `blockY` | `dynamic` | — | Vertical coordinate or vector component represented by block y. |
| `rot` | `dynamic` | — | Rot value supplied to `UP_XbrzBlendLineSteep3`. |
| `col` | `dynamic` | — | Col value supplied to `UP_XbrzBlendLineSteep3`. |
| `pal` | `dynamic` | — | Pal value supplied to `UP_XbrzBlendLineSteep3`. |
| `blendCache` | `dynamic` | — | Blend cache value supplied to `UP_XbrzBlendLineSteep3`. |
| `hasAlpha` | `dynamic` | — | Whether has alpha holds. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/hdwad_builder.ml#L964)

<a id="function-function-up-xbrzblendlinesteepandshallow3-function-up-xbrzblendlinesteepandshallow3-dst-dw-blockx-blocky-rot-col-pal-blendcache-hasalpha-src-hdwad-builder-ml-1869458228"></a>
### UP_XbrzBlendLineSteepAndShallow3

```ml
function UP_XbrzBlendLineSteepAndShallow3(dst, dw, blockX, blockY, rot, col, pal, blendCache, hasAlpha)
```

Applies the combined xBRZ 3x corner pattern when both steep and shallow edge tests succeed.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `dst` | `dynamic` | — | Dst value supplied to `UP_XbrzBlendLineSteepAndShallow3`. |
| `dw` | `dynamic` | — | Dw value supplied to `UP_XbrzBlendLineSteepAndShallow3`. |
| `blockX` | `dynamic` | — | Horizontal coordinate or vector component represented by block x. |
| `blockY` | `dynamic` | — | Vertical coordinate or vector component represented by block y. |
| `rot` | `dynamic` | — | Rot value supplied to `UP_XbrzBlendLineSteepAndShallow3`. |
| `col` | `dynamic` | — | Col value supplied to `UP_XbrzBlendLineSteepAndShallow3`. |
| `pal` | `dynamic` | — | Pal value supplied to `UP_XbrzBlendLineSteepAndShallow3`. |
| `blendCache` | `dynamic` | — | Blend cache value supplied to `UP_XbrzBlendLineSteepAndShallow3`. |
| `hasAlpha` | `dynamic` | — | Whether has alpha holds. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/hdwad_builder.ml#L981)

<a id="function-function-up-xbrzblendpixel3-function-up-xbrzblendpixel3-dst-dw-blockx-blocky-blendinfo-rot-pal-distcache-blendcache-hasalpha-a0-b0-c0-d0-e0-f0-g0-h0-i0-src-hdwad-builder-ml-1371777590"></a>
### UP_XbrzBlendPixel3

```ml
function UP_XbrzBlendPixel3(dst, dw, blockX, blockY, blendInfo, rot, pal, distCache, blendCache, hasAlpha, a0, b0, c0, d0, e0, f0, g0, h0, i0)
```

Controls xbrz Blend Pixel3 transitions in the HDWAD builder system.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `dst` | `dynamic` | — | Dst value supplied to `UP_XbrzBlendPixel3`. |
| `dw` | `dynamic` | — | Dw value supplied to `UP_XbrzBlendPixel3`. |
| `blockX` | `dynamic` | — | Horizontal coordinate or vector component represented by block x. |
| `blockY` | `dynamic` | — | Vertical coordinate or vector component represented by block y. |
| `blendInfo` | `dynamic` | — | Blend info value supplied to `UP_XbrzBlendPixel3`. |
| `rot` | `dynamic` | — | Rot value supplied to `UP_XbrzBlendPixel3`. |
| `pal` | `dynamic` | — | Pal value supplied to `UP_XbrzBlendPixel3`. |
| `distCache` | `dynamic` | — | Dist cache value supplied to `UP_XbrzBlendPixel3`. |
| `blendCache` | `dynamic` | — | Blend cache value supplied to `UP_XbrzBlendPixel3`. |
| `hasAlpha` | `dynamic` | — | Whether has alpha holds. |
| `a0` | `dynamic` | — | A0 value supplied to `UP_XbrzBlendPixel3`. |
| `b0` | `dynamic` | — | B0 value supplied to `UP_XbrzBlendPixel3`. |
| `c0` | `dynamic` | — | C0 value supplied to `UP_XbrzBlendPixel3`. |
| `d0` | `dynamic` | — | D0 value supplied to `UP_XbrzBlendPixel3`. |
| `e0` | `dynamic` | — | E0 value supplied to `UP_XbrzBlendPixel3`. |
| `f0` | `dynamic` | — | F0 value supplied to `UP_XbrzBlendPixel3`. |
| `g0` | `dynamic` | — | G0 value supplied to `UP_XbrzBlendPixel3`. |
| `h0` | `dynamic` | — | H0 value supplied to `UP_XbrzBlendPixel3`. |
| `i0` | `dynamic` | — | I0 value supplied to `UP_XbrzBlendPixel3`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/hdwad_builder.ml#L1039)

<a id="function-function-up-xbrzblendref3-function-up-xbrzblendref3-dst-dw-blockx-blocky-rot-i-j-col-pal-blendcache-hasalpha-ratiocode-src-hdwad-builder-ml-1368036309"></a>
### UP_XbrzBlendRef3

```ml
function UP_XbrzBlendRef3(dst, dw, blockX, blockY, rot, i, j, col, pal, blendCache, hasAlpha, ratioCode)
```

Controls xbrz Blend Ref3 transitions in the HDWAD builder system.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `dst` | `dynamic` | — | Dst value supplied to `UP_XbrzBlendRef3`. |
| `dw` | `dynamic` | — | Dw value supplied to `UP_XbrzBlendRef3`. |
| `blockX` | `dynamic` | — | Horizontal coordinate or vector component represented by block x. |
| `blockY` | `dynamic` | — | Vertical coordinate or vector component represented by block y. |
| `rot` | `dynamic` | — | Rot value supplied to `UP_XbrzBlendRef3`. |
| `i` | `dynamic` | — | Zero-based iteration index. |
| `j` | `dynamic` | — | Secondary zero-based iteration index. |
| `col` | `dynamic` | — | Col value supplied to `UP_XbrzBlendRef3`. |
| `pal` | `dynamic` | — | Pal value supplied to `UP_XbrzBlendRef3`. |
| `blendCache` | `dynamic` | — | Blend cache value supplied to `UP_XbrzBlendRef3`. |
| `hasAlpha` | `dynamic` | — | Whether has alpha holds. |
| `ratioCode` | `dynamic` | — | Ratio code value supplied to `UP_XbrzBlendRef3`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/hdwad_builder.ml#L919)

<a id="function-function-up-xbrzdistancecached-function-up-xbrzdistancecached-pal-cache-a-b-hasalpha-src-hdwad-builder-ml-1290233994"></a>
### UP_XbrzDistanceCached

```ml
function UP_XbrzDistanceCached(pal, cache, a, b, hasAlpha)
```

Computes the palette distance used by the original xBRZ rules.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `pal` | `dynamic` | — | Pal value supplied to `UP_XbrzDistanceCached`. |
| `cache` | `dynamic` | — | Cache value supplied to `UP_XbrzDistanceCached`. |
| `a` | `dynamic` | — | First input operand. |
| `b` | `dynamic` | — | Second input operand. |
| `hasAlpha` | `dynamic` | — | Whether has alpha holds. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/hdwad_builder.ml#L639)

<a id="function-function-up-xbrzeq-inline-function-up-xbrzeq-pal-cache-a-b-hasalpha-src-hdwad-builder-ml-366195771"></a>
### UP_XbrzEq

```ml
inline function UP_XbrzEq(pal, cache, a, b, hasAlpha)
```

Tests palette equality using xBRZ's perceptual tolerance.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `pal` | `dynamic` | — | Pal value supplied to `UP_XbrzEq`. |
| `cache` | `dynamic` | — | Cache value supplied to `UP_XbrzEq`. |
| `a` | `dynamic` | — | First input operand. |
| `b` | `dynamic` | — | Second input operand. |
| `hasAlpha` | `dynamic` | — | Whether has alpha holds. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/hdwad_builder.ml#L674)

<a id="function-function-up-xbrzgetbottoml-inline-function-up-xbrzgetbottoml-b-src-hdwad-builder-ml-2040124775"></a>
### UP_XbrzGetBottomL

```ml
inline function UP_XbrzGetBottomL(b)
```

Extracts the two-bit bottom-left corner blend classification from a packed xBRZ blend byte.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `b` | `dynamic` | — | Second input operand. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/hdwad_builder.ml#L741)

<a id="function-function-up-xbrzgetbottomr-inline-function-up-xbrzgetbottomr-b-src-hdwad-builder-ml-2135503519"></a>
### UP_XbrzGetBottomR

```ml
inline function UP_XbrzGetBottomR(b)
```

Extracts the two-bit bottom-right corner blend classification from a packed xBRZ blend byte.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `b` | `dynamic` | — | Second input operand. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/hdwad_builder.ml#L735)

<a id="function-function-up-xbrzgettopl-inline-function-up-xbrzgettopl-b-src-hdwad-builder-ml-1821790615"></a>
### UP_XbrzGetTopL

```ml
inline function UP_XbrzGetTopL(b)
```

Extracts the two-bit top-left corner blend classification from a packed xBRZ blend byte.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `b` | `dynamic` | — | Second input operand. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/hdwad_builder.ml#L723)

<a id="function-function-up-xbrzgettopr-inline-function-up-xbrzgettopr-b-src-hdwad-builder-ml-2067592479"></a>
### UP_XbrzGetTopR

```ml
inline function UP_XbrzGetTopR(b)
```

Extracts the two-bit top-right corner blend classification from a packed xBRZ blend byte.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `b` | `dynamic` | — | Second input operand. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/hdwad_builder.ml#L729)

<a id="function-function-up-xbrzpreprocesscorners-function-up-xbrzpreprocesscorners-pal-cache-a-b-c-d-e-f-g-h-ii-j-k-l-m-n-o-p-hasalpha-src-hdwad-builder-ml-1955858572"></a>
### UP_XbrzPreProcessCorners

```ml
function UP_XbrzPreProcessCorners(pal, cache, a, b, c, d, e, f, g, h, ii, j, k, l, m, n, o, p, hasAlpha)
```

Compares color-distance paths through a 4x4 neighborhood and classifies normal or dominant edge blends for the central corners.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `pal` | `dynamic` | — | Pal value supplied to `UP_XbrzPreProcessCorners`. |
| `cache` | `dynamic` | — | Cache value supplied to `UP_XbrzPreProcessCorners`. |
| `a` | `dynamic` | — | First input operand. |
| `b` | `dynamic` | — | Second input operand. |
| `c` | `dynamic` | — | C value supplied to `UP_XbrzPreProcessCorners`. |
| `d` | `dynamic` | — | Divisor or direction value used by the operation. |
| `e` | `dynamic` | — | E value supplied to `UP_XbrzPreProcessCorners`. |
| `f` | `dynamic` | — | F value supplied to `UP_XbrzPreProcessCorners`. |
| `g` | `dynamic` | — | G value supplied to `UP_XbrzPreProcessCorners`. |
| `h` | `dynamic` | — | H value supplied to `UP_XbrzPreProcessCorners`. |
| `ii` | `dynamic` | — | Ii value supplied to `UP_XbrzPreProcessCorners`. |
| `j` | `dynamic` | — | Secondary zero-based iteration index. |
| `k` | `dynamic` | — | K value supplied to `UP_XbrzPreProcessCorners`. |
| `l` | `dynamic` | — | L value supplied to `UP_XbrzPreProcessCorners`. |
| `m` | `dynamic` | — | M value supplied to `UP_XbrzPreProcessCorners`. |
| `n` | `dynamic` | — | Number of values to process. |
| `o` | `dynamic` | — | O value supplied to `UP_XbrzPreProcessCorners`. |
| `p` | `dynamic` | — | Object or data record consumed by the operation. |
| `hasAlpha` | `dynamic` | — | Whether has alpha holds. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/hdwad_builder.ml#L804)

<a id="function-function-up-xbrzrefindex3-function-up-xbrzrefindex3-dw-blockx-blocky-rot-i-j-src-hdwad-builder-ml-863301972"></a>
### UP_XbrzRefIndex3

```ml
function UP_XbrzRefIndex3(dw, blockX, blockY, rot, i, j)
```

Rotates a 3x3 xBRZ neighbor coordinate and returns its linear index in the source image.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `dw` | `dynamic` | — | Dw value supplied to `UP_XbrzRefIndex3`. |
| `blockX` | `dynamic` | — | Horizontal coordinate or vector component represented by block x. |
| `blockY` | `dynamic` | — | Vertical coordinate or vector component represented by block y. |
| `rot` | `dynamic` | — | Rot value supplied to `UP_XbrzRefIndex3`. |
| `i` | `dynamic` | — | Zero-based iteration index. |
| `j` | `dynamic` | — | Secondary zero-based iteration index. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/hdwad_builder.ml#L890)

<a id="function-function-up-xbrzrotateblendinfo-function-up-xbrzrotateblendinfo-b-rot-src-hdwad-builder-ml-334337277"></a>
### UP_XbrzRotateBlendInfo

```ml
function UP_XbrzRotateBlendInfo(b, rot)
```

Controls xbrz Rotate Blend Info transitions in the HDWAD builder system.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `b` | `dynamic` | — | Second input operand. |
| `rot` | `dynamic` | — | Rot value supplied to `UP_XbrzRotateBlendInfo`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/hdwad_builder.ml#L776)

<a id="function-function-up-xbrzrotget-function-up-xbrzrotget-rot-pos-a-b-c-d-e-f-g-h-ii-src-hdwad-builder-ml-1134412171"></a>
### UP_XbrzRotGet

```ml
function UP_XbrzRotGet(rot, pos, a, b, c, d, e, f, g, h, ii)
```

Returns a 3x3 neighborhood sample through a requested quarter-turn so one blend kernel handles all four orientations.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `rot` | `dynamic` | — | Rot value supplied to `UP_XbrzRotGet`. |
| `pos` | `dynamic` | — | Pos value supplied to `UP_XbrzRotGet`. |
| `a` | `dynamic` | — | First input operand. |
| `b` | `dynamic` | — | Second input operand. |
| `c` | `dynamic` | — | C value supplied to `UP_XbrzRotGet`. |
| `d` | `dynamic` | — | Divisor or direction value used by the operation. |
| `e` | `dynamic` | — | E value supplied to `UP_XbrzRotGet`. |
| `f` | `dynamic` | — | F value supplied to `UP_XbrzRotGet`. |
| `g` | `dynamic` | — | G value supplied to `UP_XbrzRotGet`. |
| `h` | `dynamic` | — | H value supplied to `UP_XbrzRotGet`. |
| `ii` | `dynamic` | — | Ii value supplied to `UP_XbrzRotGet`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/hdwad_builder.ml#L839)

<a id="function-function-up-xbrzscaleindexed-function-up-xbrzscaleindexed-img-scale-pal-src-hdwad-builder-ml-1870924866"></a>
### UP_XbrzScaleIndexed

```ml
function UP_XbrzScaleIndexed(img, scale, pal)
```

Scales an indexed image with palette-aware xBRZ-style edge reconstruction.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `img` | `dynamic` | — | Img value supplied to `UP_XbrzScaleIndexed`. |
| `scale` | `dynamic` | — | Scale value supplied to `UP_XbrzScaleIndexed`. |
| `pal` | `dynamic` | — | Pal value supplied to `UP_XbrzScaleIndexed`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/hdwad_builder.ml#L1338)

<a id="function-function-up-xbrzscaleindexed3-function-up-xbrzscaleindexed3-img-pal-src-hdwad-builder-ml-1595064506"></a>
### UP_XbrzScaleIndexed3

```ml
function UP_XbrzScaleIndexed3(img, pal)
```

Upscales one indexed image by exactly 3x using cached palette distances, preclassified corners, and rotation-invariant xBRZ edge blending.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `img` | `dynamic` | — | Img value supplied to `UP_XbrzScaleIndexed3`. |
| `pal` | `dynamic` | — | Pal value supplied to `UP_XbrzScaleIndexed3`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/hdwad_builder.ml#L1092)

<a id="function-function-up-xbrzsetbottoml-inline-function-up-xbrzsetbottoml-b-bt-src-hdwad-builder-ml-385297553"></a>
### UP_XbrzSetBottomL

```ml
inline function UP_XbrzSetBottomL(b, bt)
```

Adds a bottom-left two-bit classification to a packed xBRZ blend byte.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `b` | `dynamic` | — | Second input operand. |
| `bt` | `dynamic` | — | Bt value supplied to `UP_XbrzSetBottomL`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/hdwad_builder.ml#L769)

<a id="function-function-up-xbrzsetbottomr-inline-function-up-xbrzsetbottomr-b-bt-src-hdwad-builder-ml-1303659025"></a>
### UP_XbrzSetBottomR

```ml
inline function UP_XbrzSetBottomR(b, bt)
```

Adds a bottom-right two-bit classification to a packed xBRZ blend byte.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `b` | `dynamic` | — | Second input operand. |
| `bt` | `dynamic` | — | Bt value supplied to `UP_XbrzSetBottomR`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/hdwad_builder.ml#L762)

<a id="function-function-up-xbrzsetref3-inline-function-up-xbrzsetref3-dst-dw-blockx-blocky-rot-i-j-col-src-hdwad-builder-ml-285946570"></a>
### UP_XbrzSetRef3

```ml
inline function UP_XbrzSetRef3(dst, dw, blockX, blockY, rot, i, j, col)
```

Writes one output color to a rotation-relative cell of the current 3x3 destination block.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `dst` | `dynamic` | — | Dst value supplied to `UP_XbrzSetRef3`. |
| `dw` | `dynamic` | — | Dw value supplied to `UP_XbrzSetRef3`. |
| `blockX` | `dynamic` | — | Horizontal coordinate or vector component represented by block x. |
| `blockY` | `dynamic` | — | Vertical coordinate or vector component represented by block y. |
| `rot` | `dynamic` | — | Rot value supplied to `UP_XbrzSetRef3`. |
| `i` | `dynamic` | — | Zero-based iteration index. |
| `j` | `dynamic` | — | Secondary zero-based iteration index. |
| `col` | `dynamic` | — | Col value supplied to `UP_XbrzSetRef3`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/hdwad_builder.ml#L933)

<a id="function-function-up-xbrzsettopl-inline-function-up-xbrzsettopl-b-bt-src-hdwad-builder-ml-542360561"></a>
### UP_XbrzSetTopL

```ml
inline function UP_XbrzSetTopL(b, bt)
```

Adds a top-left two-bit classification to a packed xBRZ blend byte.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `b` | `dynamic` | — | Second input operand. |
| `bt` | `dynamic` | — | Bt value supplied to `UP_XbrzSetTopL`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/hdwad_builder.ml#L748)

<a id="function-function-up-xbrzsettopr-inline-function-up-xbrzsettopr-b-bt-src-hdwad-builder-ml-1219858865"></a>
### UP_XbrzSetTopR

```ml
inline function UP_XbrzSetTopR(b, bt)
```

Adds a top-right two-bit classification to a packed xBRZ blend byte.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `b` | `dynamic` | — | Second input operand. |
| `bt` | `dynamic` | — | Bt value supplied to `UP_XbrzSetTopR`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/hdwad_builder.ml#L755)
