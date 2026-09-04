# `src/doomdef.ml`

[Home](README.md) · [Files](Files.md)

Defines engine-wide version, game-mode, skill, state, input, and fixed-point constants shared across subsystems.

Package: [`(global)`](Package-global-1952375359.md)

Reachable from entry: **yes**

## Declarations

<a id="global-global-am-cell-am-cell-src-doomdef-ml-1781139192"></a>
### am_cell

```ml
am_cell
```

Exposes `ammotype_t.am_cell` through the legacy `am_cell` alias.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/doomdef.ml#L293)

<a id="global-global-am-clip-am-clip-src-doomdef-ml-80472748"></a>
### am_clip

```ml
am_clip
```

Exposes `ammotype_t.am_clip` through the legacy `am_clip` alias.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/doomdef.ml#L289)

<a id="global-global-am-misl-am-misl-src-doomdef-ml-1093763808"></a>
### am_misl

```ml
am_misl
```

Exposes `ammotype_t.am_misl` through the legacy `am_misl` alias.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/doomdef.ml#L295)

<a id="global-global-am-noammo-am-noammo-src-doomdef-ml-1081087968"></a>
### am_noammo

```ml
am_noammo
```

Exposes `ammotype_t.am_noammo` through the legacy `am_noammo` alias.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/doomdef.ml#L299)

<a id="global-global-am-shell-am-shell-src-doomdef-ml-834255762"></a>
### am_shell

```ml
am_shell
```

Exposes `ammotype_t.am_shell` through the legacy `am_shell` alias.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/doomdef.ml#L291)

- [ammotype_t](Type-ammotype-t-1506671044.md) — enum
<a id="constant-constant-base-width-const-base-width-320-src-doomdef-ml-158524418"></a>
### BASE_WIDTH

```ml
const BASE_WIDTH = 320
```

Defines base width for the doomdef subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/doomdef.ml#L72)

- [card_t](Type-card-t-1049507740.md) — enum
<a id="global-global-commercial-commercial-src-doomdef-ml-195504144"></a>
### commercial

```ml
commercial
```

Exposes `GameMode_t.commercial` through the legacy `commercial` alias.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/doomdef.ml#L223)

- [GameMission_t](Type-gamemission-t-1307719476.md) — enum
- [GameMode_t](Type-gamemode-t-1148030235.md) — enum
- [gamestate_t](Type-gamestate-t-1577744147.md) — enum
<a id="global-global-gs-demoscreen-gs-demoscreen-src-doomdef-ml-18785224"></a>
### GS_DEMOSCREEN

```ml
GS_DEMOSCREEN
```

Exposes `gamestate_t.GS_DEMOSCREEN` through the legacy `GS_DEMOSCREEN` alias.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/doomdef.ml#L236)

<a id="global-global-gs-finale-gs-finale-src-doomdef-ml-504057796"></a>
### GS_FINALE

```ml
GS_FINALE
```

Exposes `gamestate_t.GS_FINALE` through the legacy `GS_FINALE` alias.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/doomdef.ml#L234)

<a id="global-global-gs-intermission-gs-intermission-src-doomdef-ml-864748100"></a>
### GS_INTERMISSION

```ml
GS_INTERMISSION
```

Exposes `gamestate_t.GS_INTERMISSION` through the legacy `GS_INTERMISSION` alias.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/doomdef.ml#L232)

<a id="global-global-gs-level-gs-level-src-doomdef-ml-1109459134"></a>
### GS_LEVEL

```ml
GS_LEVEL
```

Exposes `gamestate_t.GS_LEVEL` through the legacy `GS_LEVEL` alias.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/doomdef.ml#L230)

<a id="global-global-indetermined-indetermined-src-doomdef-ml-2136556936"></a>
### indetermined

```ml
indetermined
```

Exposes `GameMode_t.indetermined` through the legacy `indetermined` alias.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/doomdef.ml#L227)

<a id="global-global-infratics-infratics-src-doomdef-ml-432610384"></a>
### INFRATICS

```ml
INFRATICS
```

Tracks the mutable infratics value used by the doomdef subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/doomdef.ml#L321)

<a id="constant-constant-inv-aspect-ratio-const-inv-aspect-ratio-0-625-src-doomdef-ml-109189736"></a>
### INV_ASPECT_RATIO

```ml
const INV_ASPECT_RATIO = 0.625
```

Defines inv aspect ratio for the doomdef subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/doomdef.ml#L76)

<a id="global-global-invistics-invistics-src-doomdef-ml-1343333792"></a>
### INVISTICS

```ml
INVISTICS
```

Tracks the mutable invistics value used by the doomdef subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/doomdef.ml#L319)

<a id="global-global-invulntics-invulntics-src-doomdef-ml-1488724942"></a>
### INVULNTICS

```ml
INVULNTICS
```

Tracks the mutable invulntics value used by the doomdef subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/doomdef.ml#L317)

<a id="global-global-irontics-irontics-src-doomdef-ml-733159330"></a>
### IRONTICS

```ml
IRONTICS
```

Tracks the mutable irontics value used by the doomdef subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/doomdef.ml#L323)

<a id="global-global-it-bluecard-it-bluecard-src-doomdef-ml-1170276536"></a>
### it_bluecard

```ml
it_bluecard
```

Exposes `card_t.it_bluecard` through the legacy `it_bluecard` alias.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/doomdef.ml#L250)

<a id="global-global-it-blueskull-it-blueskull-src-doomdef-ml-169167582"></a>
### it_blueskull

```ml
it_blueskull
```

Exposes `card_t.it_blueskull` through the legacy `it_blueskull` alias.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/doomdef.ml#L256)

<a id="global-global-it-redcard-it-redcard-src-doomdef-ml-1284377890"></a>
### it_redcard

```ml
it_redcard
```

Exposes `card_t.it_redcard` through the legacy `it_redcard` alias.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/doomdef.ml#L254)

<a id="global-global-it-redskull-it-redskull-src-doomdef-ml-594537168"></a>
### it_redskull

```ml
it_redskull
```

Exposes `card_t.it_redskull` through the legacy `it_redskull` alias.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/doomdef.ml#L260)

<a id="global-global-it-yellowcard-it-yellowcard-src-doomdef-ml-1885409804"></a>
### it_yellowcard

```ml
it_yellowcard
```

Exposes `card_t.it_yellowcard` through the legacy `it_yellowcard` alias.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/doomdef.ml#L252)

<a id="global-global-it-yellowskull-it-yellowskull-src-doomdef-ml-502766670"></a>
### it_yellowskull

```ml
it_yellowskull
```

Exposes `card_t.it_yellowskull` through the legacy `it_yellowskull` alias.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/doomdef.ml#L258)

<a id="constant-constant-key-backspace-const-key-backspace-127-src-doomdef-ml-1050986709"></a>
### KEY_BACKSPACE

```ml
const KEY_BACKSPACE = 127
```

Defines the input key code for key backspace.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/doomdef.ml#L367)

<a id="constant-constant-key-console-const-key-console-256-src-doomdef-ml-1233883306"></a>
### KEY_CONSOLE

```ml
const KEY_CONSOLE = 256
```

Private UI key codes live above the legacy 8-bit gameplay-key table. Defines the input key code for key console.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/doomdef.ml#L373)

<a id="constant-constant-key-downarrow-const-key-downarrow-175-src-doomdef-ml-1429028424"></a>
### KEY_DOWNARROW

```ml
const KEY_DOWNARROW = 175
```

Defines the input key code for key downarrow.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/doomdef.ml#L332)

<a id="constant-constant-key-enter-const-key-enter-13-src-doomdef-ml-434278295"></a>
### KEY_ENTER

```ml
const KEY_ENTER = 13
```

Defines the input key code for key enter.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/doomdef.ml#L337)

<a id="constant-constant-key-equals-const-key-equals-61-src-doomdef-ml-1556886496"></a>
### KEY_EQUALS

```ml
const KEY_EQUALS = 61
```

Defines the input key code for key equals.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/doomdef.ml#L380)

<a id="constant-constant-key-escape-const-key-escape-27-src-doomdef-ml-61092818"></a>
### KEY_ESCAPE

```ml
const KEY_ESCAPE = 27
```

Defines the input key code for key escape.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/doomdef.ml#L335)

<a id="constant-constant-key-f1-const-key-f1-128-59-src-doomdef-ml-220286893"></a>
### KEY_F1

```ml
const KEY_F1 = 128 + 59
```

Defines the input key code for key f1.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/doomdef.ml#L342)

<a id="constant-constant-key-f10-const-key-f10-128-68-src-doomdef-ml-529449725"></a>
### KEY_F10

```ml
const KEY_F10 = 128 + 68
```

Defines the input key code for key f10.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/doomdef.ml#L360)

<a id="constant-constant-key-f11-const-key-f11-128-87-src-doomdef-ml-180743356"></a>
### KEY_F11

```ml
const KEY_F11 = 128 + 87
```

Defines the input key code for key f11.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/doomdef.ml#L362)

<a id="constant-constant-key-f12-const-key-f12-128-88-src-doomdef-ml-1732301079"></a>
### KEY_F12

```ml
const KEY_F12 = 128 + 88
```

Defines the input key code for key f12.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/doomdef.ml#L364)

<a id="constant-constant-key-f2-const-key-f2-128-60-src-doomdef-ml-1544195383"></a>
### KEY_F2

```ml
const KEY_F2 = 128 + 60
```

Defines the input key code for key f2.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/doomdef.ml#L344)

<a id="constant-constant-key-f3-const-key-f3-128-61-src-doomdef-ml-1039774796"></a>
### KEY_F3

```ml
const KEY_F3 = 128 + 61
```

Defines the input key code for key f3.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/doomdef.ml#L346)

<a id="constant-constant-key-f4-const-key-f4-128-62-src-doomdef-ml-804557265"></a>
### KEY_F4

```ml
const KEY_F4 = 128 + 62
```

Defines the input key code for key f4.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/doomdef.ml#L348)

<a id="constant-constant-key-f5-const-key-f5-128-63-src-doomdef-ml-541147766"></a>
### KEY_F5

```ml
const KEY_F5 = 128 + 63
```

Defines the input key code for key f5.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/doomdef.ml#L350)

<a id="constant-constant-key-f6-const-key-f6-128-64-src-doomdef-ml-1435880827"></a>
### KEY_F6

```ml
const KEY_F6 = 128 + 64
```

Defines the input key code for key f6.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/doomdef.ml#L352)

<a id="constant-constant-key-f7-const-key-f7-128-65-src-doomdef-ml-1776692368"></a>
### KEY_F7

```ml
const KEY_F7 = 128 + 65
```

Defines the input key code for key f7.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/doomdef.ml#L354)

<a id="constant-constant-key-f8-const-key-f8-128-66-src-doomdef-ml-998918613"></a>
### KEY_F8

```ml
const KEY_F8 = 128 + 66
```

Defines the input key code for key f8.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/doomdef.ml#L356)

<a id="constant-constant-key-f9-const-key-f9-128-67-src-doomdef-ml-1927834474"></a>
### KEY_F9

```ml
const KEY_F9 = 128 + 67
```

Defines the input key code for key f9.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/doomdef.ml#L358)

<a id="constant-constant-key-lalt-const-key-lalt-key-ralt-src-doomdef-ml-1465144200"></a>
### KEY_LALT

```ml
const KEY_LALT = KEY_RALT
```

Defines the input key code for key lalt.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/doomdef.ml#L392)

<a id="constant-constant-key-leftarrow-const-key-leftarrow-172-src-doomdef-ml-236103331"></a>
### KEY_LEFTARROW

```ml
const KEY_LEFTARROW = 172
```

Defines the input key code for key leftarrow.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/doomdef.ml#L328)

<a id="constant-constant-key-minus-const-key-minus-45-src-doomdef-ml-611117582"></a>
### KEY_MINUS

```ml
const KEY_MINUS = 45
```

Defines the minimum key minus accepted by the doomdef subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/doomdef.ml#L382)

<a id="constant-constant-key-pagedown-const-key-pagedown-258-src-doomdef-ml-526784244"></a>
### KEY_PAGEDOWN

```ml
const KEY_PAGEDOWN = 258
```

Defines the input key code for key pagedown.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/doomdef.ml#L377)

<a id="constant-constant-key-pageup-const-key-pageup-257-src-doomdef-ml-2083479673"></a>
### KEY_PAGEUP

```ml
const KEY_PAGEUP = 257
```

Defines the input key code for key pageup.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/doomdef.ml#L375)

<a id="constant-constant-key-pause-const-key-pause-255-src-doomdef-ml-881504697"></a>
### KEY_PAUSE

```ml
const KEY_PAUSE = 255
```

Defines the input key code for key pause.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/doomdef.ml#L369)

<a id="constant-constant-key-ralt-const-key-ralt-128-56-src-doomdef-ml-1095168886"></a>
### KEY_RALT

```ml
const KEY_RALT = 128 + 56
```

Defines the input key code for key ralt.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/doomdef.ml#L389)

<a id="constant-constant-key-rctrl-const-key-rctrl-128-29-src-doomdef-ml-2078536580"></a>
### KEY_RCTRL

```ml
const KEY_RCTRL = 128 + 29
```

Defines the input key code for key rctrl.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/doomdef.ml#L387)

<a id="constant-constant-key-rightarrow-const-key-rightarrow-174-src-doomdef-ml-1686840693"></a>
### KEY_RIGHTARROW

```ml
const KEY_RIGHTARROW = 174
```

Defines the input key code for key rightarrow.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/doomdef.ml#L326)

<a id="constant-constant-key-rshift-const-key-rshift-128-54-src-doomdef-ml-1405533318"></a>
### KEY_RSHIFT

```ml
const KEY_RSHIFT = 128 + 54
```

Defines the input key code for key rshift.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/doomdef.ml#L385)

<a id="constant-constant-key-tab-const-key-tab-9-src-doomdef-ml-165099272"></a>
### KEY_TAB

```ml
const KEY_TAB = 9
```

Defines the input key code for key tab.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/doomdef.ml#L339)

<a id="constant-constant-key-uparrow-const-key-uparrow-173-src-doomdef-ml-771016490"></a>
### KEY_UPARROW

```ml
const KEY_UPARROW = 173
```

Defines the input key code for key uparrow.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/doomdef.ml#L330)

- [Language_t](Type-language-t-1271477608.md) — enum
<a id="constant-constant-maxplayers-const-maxplayers-4-src-doomdef-ml-458075047"></a>
### MAXPLAYERS

```ml
const MAXPLAYERS = 4
```

Defines the maximum maxplayers accepted by the doomdef subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/doomdef.ml#L84)

<a id="constant-constant-mtf-ambush-const-mtf-ambush-8-src-doomdef-ml-1388169187"></a>
### MTF_AMBUSH

```ml
const MTF_AMBUSH = 8
```

Defines mtf ambush for the doomdef subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/doomdef.ml#L108)

<a id="constant-constant-mtf-easy-const-mtf-easy-1-src-doomdef-ml-455697890"></a>
### MTF_EASY

```ml
const MTF_EASY = 1
```

Defines mtf easy for the doomdef subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/doomdef.ml#L102)

<a id="constant-constant-mtf-hard-const-mtf-hard-4-src-doomdef-ml-189748373"></a>
### MTF_HARD

```ml
const MTF_HARD = 4
```

Defines mtf hard for the doomdef subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/doomdef.ml#L106)

<a id="constant-constant-mtf-normal-const-mtf-normal-2-src-doomdef-ml-146250115"></a>
### MTF_NORMAL

```ml
const MTF_NORMAL = 2
```

Defines mtf normal for the doomdef subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/doomdef.ml#L104)

<a id="global-global-numammo-numammo-src-doomdef-ml-108825176"></a>
### NUMAMMO

```ml
NUMAMMO
```

Tracks the mutable numammo value used by the doomdef subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/doomdef.ml#L297)

<a id="global-global-numcards-numcards-src-doomdef-ml-1051185746"></a>
### NUMCARDS

```ml
NUMCARDS
```

Tracks the mutable numcards value used by the doomdef subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/doomdef.ml#L263)

<a id="global-global-numpowers-numpowers-src-doomdef-ml-1116917592"></a>
### NUMPOWERS

```ml
NUMPOWERS
```

Tracks the mutable numpowers value used by the doomdef subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/doomdef.ml#L314)

<a id="global-global-numweapons-numweapons-src-doomdef-ml-1398131910"></a>
### NUMWEAPONS

```ml
NUMWEAPONS
```

Tracks the mutable numweapons value used by the doomdef subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/doomdef.ml#L284)

- [powerduration_t](Type-powerduration-t-1294996801.md) — enum
- [powertype_t](Type-powertype-t-699993773.md) — enum
<a id="global-global-pw-allmap-pw-allmap-src-doomdef-ml-1447835412"></a>
### pw_allmap

```ml
pw_allmap
```

Exposes `powertype_t.pw_allmap` through the legacy `pw_allmap` alias.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/doomdef.ml#L310)

<a id="global-global-pw-infrared-pw-infrared-src-doomdef-ml-1096606132"></a>
### pw_infrared

```ml
pw_infrared
```

Exposes `powertype_t.pw_infrared` through the legacy `pw_infrared` alias.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/doomdef.ml#L312)

<a id="global-global-pw-invisibility-pw-invisibility-src-doomdef-ml-584669584"></a>
### pw_invisibility

```ml
pw_invisibility
```

Exposes `powertype_t.pw_invisibility` through the legacy `pw_invisibility` alias.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/doomdef.ml#L306)

<a id="global-global-pw-invulnerability-pw-invulnerability-src-doomdef-ml-1950788474"></a>
### pw_invulnerability

```ml
pw_invulnerability
```

Exposes `powertype_t.pw_invulnerability` through the legacy `pw_invulnerability` alias.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/doomdef.ml#L302)

<a id="global-global-pw-ironfeet-pw-ironfeet-src-doomdef-ml-722482968"></a>
### pw_ironfeet

```ml
pw_ironfeet
```

Exposes `powertype_t.pw_ironfeet` through the legacy `pw_ironfeet` alias.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/doomdef.ml#L308)

<a id="global-global-pw-strength-pw-strength-src-doomdef-ml-1439218164"></a>
### pw_strength

```ml
pw_strength
```

Exposes `powertype_t.pw_strength` through the legacy `pw_strength` alias.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/doomdef.ml#L304)

<a id="constant-constant-rangecheck-const-rangecheck-true-src-doomdef-ml-446943215"></a>
### RANGECHECK

```ml
const RANGECHECK = true
```

Defines rangecheck for the doomdef subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/doomdef.ml#L66)

<a id="global-global-registered-registered-src-doomdef-ml-1020849676"></a>
### registered

```ml
registered
```

Exposes `GameMode_t.registered` through the legacy `registered` alias.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/doomdef.ml#L221)

<a id="global-global-retail-retail-src-doomdef-ml-945420814"></a>
### retail

```ml
retail
```

Exposes `GameMode_t.retail` through the legacy `retail` alias.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/doomdef.ml#L225)

<a id="constant-constant-screen-mul-const-screen-mul-1-src-doomdef-ml-997932228"></a>
### SCREEN_MUL

```ml
const SCREEN_MUL = 1
```

Defines screen mul for the doomdef subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/doomdef.ml#L74)

<a id="constant-constant-screenheight-const-screenheight-200-src-doomdef-ml-275461427"></a>
### SCREENHEIGHT

```ml
const SCREENHEIGHT = 200
```

Defines screenheight for the doomdef subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/doomdef.ml#L81)

<a id="constant-constant-screenwidth-const-screenwidth-320-src-doomdef-ml-613211452"></a>
### SCREENWIDTH

```ml
const SCREENWIDTH = 320
```

Defines screenwidth for the doomdef subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/doomdef.ml#L79)

<a id="global-global-shareware-shareware-src-doomdef-ml-1464985520"></a>
### shareware

```ml
shareware
```

Exposes `GameMode_t.shareware` through the legacy `shareware` alias.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/doomdef.ml#L219)

<a id="global-global-sk-baby-sk-baby-src-doomdef-ml-2015170320"></a>
### sk_baby

```ml
sk_baby
```

Exposes `skill_t.sk_baby` through the legacy `sk_baby` alias.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/doomdef.ml#L239)

<a id="global-global-sk-easy-sk-easy-src-doomdef-ml-710233360"></a>
### sk_easy

```ml
sk_easy
```

Exposes `skill_t.sk_easy` through the legacy `sk_easy` alias.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/doomdef.ml#L241)

<a id="global-global-sk-hard-sk-hard-src-doomdef-ml-2092570344"></a>
### sk_hard

```ml
sk_hard
```

Exposes `skill_t.sk_hard` through the legacy `sk_hard` alias.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/doomdef.ml#L245)

<a id="global-global-sk-medium-sk-medium-src-doomdef-ml-992938260"></a>
### sk_medium

```ml
sk_medium
```

Exposes `skill_t.sk_medium` through the legacy `sk_medium` alias.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/doomdef.ml#L243)

<a id="global-global-sk-nightmare-sk-nightmare-src-doomdef-ml-247504740"></a>
### sk_nightmare

```ml
sk_nightmare
```

Exposes `skill_t.sk_nightmare` through the legacy `sk_nightmare` alias.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/doomdef.ml#L247)

- [skill_t](Type-skill-t-1930850861.md) — enum
<a id="constant-constant-sndserv-const-sndserv-1-src-doomdef-ml-1269108240"></a>
### SNDSERV

```ml
const SNDSERV = 1
```

Defines sndserv for the doomdef subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/doomdef.ml#L69)

<a id="constant-constant-ticrate-const-ticrate-35-src-doomdef-ml-20225387"></a>
### TICRATE

```ml
const TICRATE = 35
```

Defines ticrate for the doomdef subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/doomdef.ml#L87)

<a id="constant-constant-version-const-version-110-src-doomdef-ml-932559235"></a>
### VERSION

```ml
const VERSION = 110
```

Defines version for the doomdef subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/doomdef.ml#L23)

- [weapontype_t](Type-weapontype-t-1326961442.md) — enum
<a id="global-global-wp-bfg-wp-bfg-src-doomdef-ml-174031658"></a>
### wp_bfg

```ml
wp_bfg
```

Exposes `weapontype_t.wp_bfg` through the legacy `wp_bfg` alias.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/doomdef.ml#L278)

<a id="global-global-wp-chaingun-wp-chaingun-src-doomdef-ml-950350280"></a>
### wp_chaingun

```ml
wp_chaingun
```

Exposes `weapontype_t.wp_chaingun` through the legacy `wp_chaingun` alias.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/doomdef.ml#L272)

<a id="global-global-wp-chainsaw-wp-chainsaw-src-doomdef-ml-1063682056"></a>
### wp_chainsaw

```ml
wp_chainsaw
```

Exposes `weapontype_t.wp_chainsaw` through the legacy `wp_chainsaw` alias.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/doomdef.ml#L280)

<a id="global-global-wp-fist-wp-fist-src-doomdef-ml-1949750776"></a>
### wp_fist

```ml
wp_fist
```

Exposes `weapontype_t.wp_fist` through the legacy `wp_fist` alias.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/doomdef.ml#L266)

<a id="global-global-wp-missile-wp-missile-src-doomdef-ml-245746484"></a>
### wp_missile

```ml
wp_missile
```

Exposes `weapontype_t.wp_missile` through the legacy `wp_missile` alias.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/doomdef.ml#L274)

<a id="global-global-wp-nochange-wp-nochange-src-doomdef-ml-1366464840"></a>
### wp_nochange

```ml
wp_nochange
```

Exposes `weapontype_t.wp_nochange` through the legacy `wp_nochange` alias.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/doomdef.ml#L286)

<a id="global-global-wp-pistol-wp-pistol-src-doomdef-ml-448157508"></a>
### wp_pistol

```ml
wp_pistol
```

Exposes `weapontype_t.wp_pistol` through the legacy `wp_pistol` alias.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/doomdef.ml#L268)

<a id="global-global-wp-plasma-wp-plasma-src-doomdef-ml-1560475736"></a>
### wp_plasma

```ml
wp_plasma
```

Exposes `weapontype_t.wp_plasma` through the legacy `wp_plasma` alias.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/doomdef.ml#L276)

<a id="global-global-wp-shotgun-wp-shotgun-src-doomdef-ml-1171545680"></a>
### wp_shotgun

```ml
wp_shotgun
```

Exposes `weapontype_t.wp_shotgun` through the legacy `wp_shotgun` alias.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/doomdef.ml#L270)

<a id="global-global-wp-supershotgun-wp-supershotgun-src-doomdef-ml-85623196"></a>
### wp_supershotgun

```ml
wp_supershotgun
```

Exposes `weapontype_t.wp_supershotgun` through the legacy `wp_supershotgun` alias.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/doomdef.ml#L282)
