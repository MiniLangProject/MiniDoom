# `src/p_local.ml`

[Home](README.md) · [Files](Files.md)

Defines shared play-simulation constants, traversal records, blockmap state, and collision result globals.

Package: [`(global)`](Package-global-1952375359.md)

Reachable from entry: **yes**

## Imports

- `p_spec.ml` → [src/p_spec.ml](File-src-p-spec-ml-402508231.md)
- `r_local.ml` → [src/r_local.ml](File-src-r-local-ml-797040731.md)

## Declarations

<a id="constant-constant-basethreshold-const-basethreshold-100-src-p-local-ml-1050659040"></a>
### BASETHRESHOLD

```ml
const BASETHRESHOLD = 100
```

Defines basethreshold for the p local subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_local.ml#L60)

<a id="global-global-blocklinks-blocklinks-src-p-local-ml-258970944"></a>
### blocklinks

```ml
blocklinks
```

Holds the optional blocklinks resource used by the p local subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_local.ml#L136)

<a id="global-global-blockmap-blockmap-src-p-local-ml-195483986"></a>
### blockmap

```ml
blockmap
```

Holds the optional blockmap resource used by the p local subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_local.ml#L126)

<a id="global-global-blockmaplump-blockmaplump-src-p-local-ml-1500315738"></a>
### blockmaplump

```ml
blockmaplump
```

Holds the optional blockmaplump resource used by the p local subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_local.ml#L124)

<a id="global-global-bmapheight-bmapheight-src-p-local-ml-1106743058"></a>
### bmapheight

```ml
bmapheight
```

Tracks the mutable bmapheight value used by the p local subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_local.ml#L130)

<a id="global-global-bmaporgx-bmaporgx-src-p-local-ml-1452246912"></a>
### bmaporgx

```ml
bmaporgx
```

Tracks the mutable bmaporgx value used by the p local subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_local.ml#L132)

<a id="global-global-bmaporgy-bmaporgy-src-p-local-ml-262894202"></a>
### bmaporgy

```ml
bmaporgy
```

Tracks the mutable bmaporgy value used by the p local subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_local.ml#L134)

<a id="global-global-bmapwidth-bmapwidth-src-p-local-ml-694272968"></a>
### bmapwidth

```ml
bmapwidth
```

Tracks the mutable bmapwidth value used by the p local subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_local.ml#L128)

<a id="global-global-ceilingline-ceilingline-src-p-local-ml-1280421520"></a>
### ceilingline

```ml
ceilingline
```

Holds the optional ceilingline resource used by the p local subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_local.ml#L117)

- [divline_t](Type-divline-t-1528034585.md) — struct
<a id="global-global-floatok-floatok-src-p-local-ml-348025224"></a>
### floatok

```ml
floatok
```

Tracks whether floatok is active in the p local subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_local.ml#L111)

<a id="constant-constant-floatspeed-const-floatspeed-262144-src-p-local-ml-774358104"></a>
### FLOATSPEED

```ml
const FLOATSPEED = 262144
```

Defines floatspeed for the p local subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_local.ml#L24)

<a id="constant-constant-gravity-const-gravity-65536-src-p-local-ml-1778763594"></a>
### GRAVITY

```ml
const GRAVITY = 65536
```

Defines gravity for the p local subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_local.ml#L48)

<a id="global-global-intercept-p-intercept-p-src-p-local-ml-21558900"></a>
### intercept_p

```ml
intercept_p
```

Tracks the mutable intercept p value used by the p local subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_local.ml#L97)

- [intercept_t](Type-intercept-t-347408094.md) — struct
<a id="global-global-intercepts-intercepts-src-p-local-ml-366050098"></a>
### intercepts

```ml
intercepts
```

Stores the intercepts collection used by the p local subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_local.ml#L95)

<a id="global-global-linetarget-linetarget-src-p-local-ml-1384775826"></a>
### linetarget

```ml
linetarget
```

Holds the optional linetarget resource used by the p local subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_local.ml#L119)

<a id="global-global-lowfloor-lowfloor-src-p-local-ml-1108896284"></a>
### lowfloor

```ml
lowfloor
```

Tracks the mutable lowfloor value used by the p local subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_local.ml#L108)

<a id="constant-constant-mapblockshift-const-mapblockshift-23-src-p-local-ml-959066790"></a>
### MAPBLOCKSHIFT

```ml
const MAPBLOCKSHIFT = 23
```

Defines mapblockshift for the p local subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_local.ml#L36)

<a id="constant-constant-mapblocksize-const-mapblocksize-8388608-src-p-local-ml-226030544"></a>
### MAPBLOCKSIZE

```ml
const MAPBLOCKSIZE = 8388608
```

Defines mapblocksize for the p local subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_local.ml#L34)

<a id="constant-constant-mapblockunits-const-mapblockunits-128-src-p-local-ml-1392852674"></a>
### MAPBLOCKUNITS

```ml
const MAPBLOCKUNITS = 128
```

Defines mapblockunits for the p local subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_local.ml#L32)

<a id="constant-constant-mapbmask-const-mapbmask-8388607-src-p-local-ml-1748810903"></a>
### MAPBMASK

```ml
const MAPBMASK = 8388607
```

Defines mapbmask for the p local subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_local.ml#L38)

<a id="constant-constant-mapbtofrac-const-mapbtofrac-7-src-p-local-ml-1785163218"></a>
### MAPBTOFRAC

```ml
const MAPBTOFRAC = 7
```

Defines mapbtofrac for the p local subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_local.ml#L40)

<a id="constant-constant-maxhealth-const-maxhealth-100-src-p-local-ml-1067123512"></a>
### MAXHEALTH

```ml
const MAXHEALTH = 100
```

Defines the maximum maxhealth accepted by the p local subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_local.ml#L27)

<a id="constant-constant-maxintercepts-const-maxintercepts-128-src-p-local-ml-454851554"></a>
### MAXINTERCEPTS

```ml
const MAXINTERCEPTS = 128
```

Defines the maximum maxintercepts accepted by the p local subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_local.ml#L92)

<a id="constant-constant-maxmove-const-maxmove-1966080-src-p-local-ml-1169987059"></a>
### MAXMOVE

```ml
const MAXMOVE = 1966080
```

Defines the maximum maxmove accepted by the p local subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_local.ml#L50)

<a id="constant-constant-maxradius-const-maxradius-2097152-src-p-local-ml-1379700415"></a>
### MAXRADIUS

```ml
const MAXRADIUS = 2097152
```

Defines the maximum maxradius accepted by the p local subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_local.ml#L45)

<a id="constant-constant-meleerange-const-meleerange-4194304-src-p-local-ml-993522040"></a>
### MELEERANGE

```ml
const MELEERANGE = 4194304
```

Defines meleerange for the p local subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_local.ml#L55)

<a id="constant-constant-missilerange-const-missilerange-134217728-src-p-local-ml-1532370754"></a>
### MISSILERANGE

```ml
const MISSILERANGE = 134217728
```

Defines missilerange for the p local subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_local.ml#L57)

<a id="constant-constant-onceilingz-const-onceilingz-2147483647-src-p-local-ml-1333504433"></a>
### ONCEILINGZ

```ml
const ONCEILINGZ = 2147483647
```

Defines onceilingz for the p local subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_local.ml#L65)

<a id="constant-constant-onfloorz-const-onfloorz-2147483648-src-p-local-ml-1375028927"></a>
### ONFLOORZ

```ml
const ONFLOORZ = -2147483648
```

Defines onfloorz for the p local subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_local.ml#L63)

<a id="global-global-openbottom-openbottom-src-p-local-ml-1118992254"></a>
### openbottom

```ml
openbottom
```

Tracks the mutable openbottom value used by the p local subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_local.ml#L104)

<a id="global-global-openrange-openrange-src-p-local-ml-67088868"></a>
### openrange

```ml
openrange
```

Tracks the mutable openrange value used by the p local subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_local.ml#L106)

<a id="global-global-opentop-opentop-src-p-local-ml-1394772772"></a>
### opentop

```ml
opentop
```

Tracks the mutable opentop value used by the p local subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_local.ml#L102)

<a id="constant-constant-playerradius-const-playerradius-1048576-src-p-local-ml-37847170"></a>
### PLAYERRADIUS

```ml
const PLAYERRADIUS = 1048576
```

Defines playerradius for the p local subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_local.ml#L43)

<a id="global-global-rejectmatrix-rejectmatrix-src-p-local-ml-1867125960"></a>
### rejectmatrix

```ml
rejectmatrix
```

Holds the optional rejectmatrix resource used by the p local subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_local.ml#L122)

<a id="global-global-tmceilingz-tmceilingz-src-p-local-ml-1545109724"></a>
### tmceilingz

```ml
tmceilingz
```

Tracks the mutable tmceilingz value used by the p local subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_local.ml#L115)

<a id="global-global-tmfloorz-tmfloorz-src-p-local-ml-410741926"></a>
### tmfloorz

```ml
tmfloorz
```

Tracks the mutable tmfloorz value used by the p local subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_local.ml#L113)

<a id="global-global-trace-trace-src-p-local-ml-132187392"></a>
### trace

```ml
trace
```

Tracks the mutable trace value used by the p local subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_local.ml#L99)

<a id="constant-constant-userange-const-userange-4194304-src-p-local-ml-264224374"></a>
### USERANGE

```ml
const USERANGE = 4194304
```

Defines userange for the p local subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_local.ml#L53)

<a id="constant-constant-viewheight-const-viewheight-2686976-src-p-local-ml-473293127"></a>
### VIEWHEIGHT

```ml
const VIEWHEIGHT = 2686976
```

Defines viewheight for the p local subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_local.ml#L29)
