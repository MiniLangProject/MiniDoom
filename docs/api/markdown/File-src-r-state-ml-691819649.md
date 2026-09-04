# `src/r_state.ml`

[Home](README.md) · [Files](Files.md)

Owns mutable texture/sprite metrics, view geometry, clipping, lighting, and camera state shared by renderer passes.

Package: [`(global)`](Package-global-1952375359.md)

Reachable from entry: **yes**

## Imports

- `d_player.ml` → [src/d_player.ml](File-src-d-player-ml-1944166105.md)
- `r_data.ml` → [src/r_data.ml](File-src-r-data-ml-1686270288.md)

## Declarations

<a id="global-global-ceilingplane-ceilingplane-src-r-state-ml-1629148882"></a>
### ceilingplane

```ml
ceilingplane
```

Holds the optional ceilingplane resource used by the r state subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_state.ml#L128)

<a id="global-global-clipangle-clipangle-src-r-state-ml-1906572032"></a>
### clipangle

```ml
clipangle
```

Tracks the mutable clipangle value used by the r state subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_state.ml#L108)

<a id="global-global-colormaps-colormaps-src-r-state-ml-1485404932"></a>
### colormaps

```ml
colormaps
```

Holds the optional colormaps resource used by the r state subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_state.ml#L33)

<a id="global-global-firstflat-firstflat-src-r-state-ml-810260056"></a>
### firstflat

```ml
firstflat
```

Tracks the mutable firstflat value used by the r state subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_state.ml#L43)

<a id="global-global-firstspritelump-firstspritelump-src-r-state-ml-38506696"></a>
### firstspritelump

```ml
firstspritelump
```

Tracks the mutable firstspritelump value used by the r state subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_state.ml#L50)

<a id="global-global-flattranslation-flattranslation-src-r-state-ml-454122944"></a>
### flattranslation

```ml
flattranslation
```

Holds the optional flattranslation resource used by the r state subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_state.ml#L45)

<a id="global-global-floorplane-floorplane-src-r-state-ml-1206368528"></a>
### floorplane

```ml
floorplane
```

Holds the optional floorplane resource used by the r state subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_state.ml#L126)

<a id="global-global-lastspritelump-lastspritelump-src-r-state-ml-1867668542"></a>
### lastspritelump

```ml
lastspritelump
```

Tracks the mutable lastspritelump value used by the r state subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_state.ml#L52)

<a id="global-global-lines-lines-src-r-state-ml-53409532"></a>
### lines

```ml
lines
```

Holds the optional lines resource used by the r state subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_state.ml#L89)

<a id="global-global-nodes-nodes-src-r-state-ml-1617164320"></a>
### nodes

```ml
nodes
```

Holds the optional nodes resource used by the r state subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_state.ml#L84)

<a id="global-global-numlines-numlines-src-r-state-ml-491551662"></a>
### numlines

```ml
numlines
```

Tracks the mutable numlines value used by the r state subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_state.ml#L87)

<a id="global-global-numnodes-numnodes-src-r-state-ml-358570278"></a>
### numnodes

```ml
numnodes
```

Tracks the mutable numnodes value used by the r state subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_state.ml#L82)

<a id="global-global-numsectors-numsectors-src-r-state-ml-320184654"></a>
### numsectors

```ml
numsectors
```

Tracks the mutable numsectors value used by the r state subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_state.ml#L72)

<a id="global-global-numsegs-numsegs-src-r-state-ml-618315824"></a>
### numsegs

```ml
numsegs
```

Tracks the mutable numsegs value used by the r state subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_state.ml#L67)

<a id="global-global-numsides-numsides-src-r-state-ml-1387665648"></a>
### numsides

```ml
numsides
```

Tracks the mutable numsides value used by the r state subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_state.ml#L92)

<a id="global-global-numspritelumps-numspritelumps-src-r-state-ml-1764990244"></a>
### numspritelumps

```ml
numspritelumps
```

Tracks the mutable numspritelumps value used by the r state subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_state.ml#L54)

<a id="global-global-numsprites-numsprites-src-r-state-ml-765835576"></a>
### numsprites

```ml
numsprites
```

Tracks the mutable numsprites value used by the r state subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_state.ml#L57)

<a id="global-global-numsubsectors-numsubsectors-src-r-state-ml-1650305396"></a>
### numsubsectors

```ml
numsubsectors
```

Tracks the mutable numsubsectors value used by the r state subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_state.ml#L77)

<a id="global-global-numvertexes-numvertexes-src-r-state-ml-353711704"></a>
### numvertexes

```ml
numvertexes
```

Tracks the mutable numvertexes value used by the r state subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_state.ml#L62)

<a id="global-global-rw-angle1-rw-angle1-src-r-state-ml-246568528"></a>
### rw_angle1

```ml
rw_angle1
```

Tracks the mutable rw angle1 value used by the r state subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_state.ml#L121)

<a id="global-global-rw-distance-rw-distance-src-r-state-ml-1371975088"></a>
### rw_distance

```ml
rw_distance
```

Tracks the mutable rw distance value used by the r state subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_state.ml#L117)

<a id="global-global-rw-normalangle-rw-normalangle-src-r-state-ml-917352720"></a>
### rw_normalangle

```ml
rw_normalangle
```

Tracks the mutable rw normalangle value used by the r state subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_state.ml#L119)

<a id="global-global-scaledviewwidth-scaledviewwidth-src-r-state-ml-1988263828"></a>
### scaledviewwidth

```ml
scaledviewwidth
```

Tracks the mutable scaledviewwidth value used by the r state subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_state.ml#L38)

<a id="global-global-sectors-sectors-src-r-state-ml-1233559400"></a>
### sectors

```ml
sectors
```

Holds the optional sectors resource used by the r state subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_state.ml#L74)

<a id="global-global-segs-segs-src-r-state-ml-1099739888"></a>
### segs

```ml
segs
```

Holds the optional segs resource used by the r state subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_state.ml#L69)

<a id="global-global-sides-sides-src-r-state-ml-1051954360"></a>
### sides

```ml
sides
```

Holds the optional sides resource used by the r state subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_state.ml#L94)

<a id="global-global-spriteoffset-spriteoffset-src-r-state-ml-1538200696"></a>
### spriteoffset

```ml
spriteoffset
```

Holds the optional spriteoffset resource used by the r state subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_state.ml#L29)

<a id="global-global-sprites-sprites-src-r-state-ml-1159247080"></a>
### sprites

```ml
sprites
```

Holds the optional sprites resource used by the r state subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_state.ml#L59)

<a id="global-global-spritetopoffset-spritetopoffset-src-r-state-ml-1682046360"></a>
### spritetopoffset

```ml
spritetopoffset
```

Holds the optional spritetopoffset resource used by the r state subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_state.ml#L31)

<a id="global-global-spritewidth-spritewidth-src-r-state-ml-1840443260"></a>
### spritewidth

```ml
spritewidth
```

Holds the optional spritewidth resource used by the r state subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_state.ml#L27)

<a id="global-global-sscount-sscount-src-r-state-ml-488203096"></a>
### sscount

```ml
sscount
```

Tracks the mutable sscount value used by the r state subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_state.ml#L124)

<a id="global-global-subsectors-subsectors-src-r-state-ml-1652596330"></a>
### subsectors

```ml
subsectors
```

Holds the optional subsectors resource used by the r state subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_state.ml#L79)

<a id="global-global-textureheight-textureheight-src-r-state-ml-765505488"></a>
### textureheight

```ml
textureheight
```

Holds the optional textureheight resource used by the r state subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_state.ml#L25)

<a id="global-global-texturetranslation-texturetranslation-src-r-state-ml-1029542416"></a>
### texturetranslation

```ml
texturetranslation
```

Holds the optional texturetranslation resource used by the r state subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_state.ml#L47)

<a id="global-global-vertexes-vertexes-src-r-state-ml-312450968"></a>
### vertexes

```ml
vertexes
```

Holds the optional vertexes resource used by the r state subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_state.ml#L64)

<a id="global-global-viewangle-viewangle-src-r-state-ml-1766745952"></a>
### viewangle

```ml
viewangle
```

Tracks the mutable viewangle value used by the r state subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_state.ml#L103)

<a id="global-global-viewangletox-viewangletox-src-r-state-ml-1359107182"></a>
### viewangletox

```ml
viewangletox
```

Holds the optional viewangletox resource used by the r state subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_state.ml#L111)

<a id="global-global-viewheight-viewheight-src-r-state-ml-1359768448"></a>
### viewheight

```ml
viewheight
```

Tracks the mutable viewheight value used by the r state subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_state.ml#L40)

<a id="global-global-viewplayer-viewplayer-src-r-state-ml-536529008"></a>
### viewplayer

```ml
viewplayer
```

Holds the optional viewplayer resource used by the r state subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_state.ml#L105)

<a id="global-global-viewwidth-viewwidth-src-r-state-ml-742129288"></a>
### viewwidth

```ml
viewwidth
```

Tracks the mutable viewwidth value used by the r state subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_state.ml#L36)

<a id="global-global-viewx-viewx-src-r-state-ml-250210032"></a>
### viewx

```ml
viewx
```

Tracks the mutable viewx value used by the r state subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_state.ml#L97)

<a id="global-global-viewy-viewy-src-r-state-ml-547360432"></a>
### viewy

```ml
viewy
```

Tracks the mutable viewy value used by the r state subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_state.ml#L99)

<a id="global-global-viewz-viewz-src-r-state-ml-305330088"></a>
### viewz

```ml
viewz
```

Tracks the mutable viewz value used by the r state subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_state.ml#L101)

<a id="global-global-xtoviewangle-xtoviewangle-src-r-state-ml-2045613598"></a>
### xtoviewangle

```ml
xtoviewangle
```

Holds the optional xtoviewangle resource used by the r state subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_state.ml#L114)
