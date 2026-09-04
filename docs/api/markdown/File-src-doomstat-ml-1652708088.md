# `src/doomstat.ml`

[Home](README.md) · [Files](Files.md)

Owns the mutable session, map, player, renderer, demo, and command-line state shared by the Doom runtime.

Package: [`(global)`](Package-global-1952375359.md)

Reachable from entry: **yes**

## Imports

- `d_net.ml` → [src/d_net.ml](File-src-d-net-ml-529296669.md)
- `d_player.ml` → [src/d_player.ml](File-src-d-player-ml-1944166105.md)
- `doomdata.ml` → [src/doomdata.ml](File-src-doomdata-ml-887192154.md)

## Declarations

<a id="global-global-automapactive-automapactive-src-doomstat-ml-1330216315"></a>
### automapactive

```ml
automapactive
```

Tracks whether automapactive is active in the doomstat subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/doomstat.ml#L121)

<a id="global-global-autostart-autostart-src-doomstat-ml-63152099"></a>
### autostart

```ml
autostart
```

Tracks whether autostart is active in the doomstat subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/doomstat.ml#L93)

<a id="global-global-basedefault-basedefault-src-doomstat-ml-1173676295"></a>
### basedefault

```ml
basedefault
```

Stores the mutable basedefault text used by the doomstat subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/doomstat.ml#L137)

<a id="global-global-bodyqueslot-bodyqueslot-src-doomstat-ml-1799153419"></a>
### bodyqueslot

```ml
bodyqueslot
```

Tracks the mutable bodyqueslot value used by the doomstat subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/doomstat.ml#L152)

<a id="global-global-console-show-fps-console-show-fps-src-doomstat-ml-435868329"></a>
### console_show_fps

```ml
console_show_fps
```

Tracks whether console show fps is active in the doomstat subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/doomstat.ml#L61)

<a id="global-global-consolefreeze-consolefreeze-src-doomstat-ml-1220727479"></a>
### consolefreeze

```ml
consolefreeze
```

Console utility toggles are session state rather than renderer or parser state. Tracks whether consolefreeze is active in the doomstat subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/doomstat.ml#L59)

<a id="global-global-consoleplayer-consoleplayer-src-doomstat-ml-1260080479"></a>
### consoleplayer

```ml
consoleplayer
```

Tracks the mutable consoleplayer value used by the doomstat subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/doomstat.ml#L72)

<a id="global-global-deathmatch-deathmatch-src-doomstat-ml-1025376241"></a>
### deathmatch

```ml
deathmatch
```

Tracks whether deathmatch is active in the doomstat subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/doomstat.ml#L51)

<a id="global-global-deathmatch-p-deathmatch-p-src-doomstat-ml-720832795"></a>
### deathmatch_p

```ml
deathmatch_p
```

Holds the optional deathmatch p resource used by the doomstat subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/doomstat.ml#L166)

<a id="global-global-deathmatchstarts-deathmatchstarts-src-doomstat-ml-1190121727"></a>
### deathmatchstarts

```ml
deathmatchstarts
```

Stores the deathmatchstarts collection used by the doomstat subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/doomstat.ml#L164)

<a id="global-global-demoplayback-demoplayback-src-doomstat-ml-2009934295"></a>
### demoplayback

```ml
demoplayback
```

Tracks whether demoplayback is active in the doomstat subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/doomstat.ml#L65)

<a id="global-global-demorecording-demorecording-src-doomstat-ml-619491575"></a>
### demorecording

```ml
demorecording
```

Tracks whether demorecording is active in the doomstat subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/doomstat.ml#L67)

<a id="global-global-devparm-devparm-src-doomstat-ml-404969539"></a>
### devparm

```ml
devparm
```

Tracks whether devparm is active in the doomstat subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/doomstat.ml#L46)

<a id="global-global-displayplayer-displayplayer-src-doomstat-ml-799746267"></a>
### displayplayer

```ml
displayplayer
```

Tracks the mutable displayplayer value used by the doomstat subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/doomstat.ml#L74)

<a id="global-global-fastparm-fastparm-src-doomstat-ml-353614383"></a>
### fastparm

```ml
fastparm
```

Tracks whether fastparm is active in the doomstat subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/doomstat.ml#L44)

<a id="global-global-gameepisode-gameepisode-src-doomstat-ml-43417311"></a>
### gameepisode

```ml
gameepisode
```

Tracks the mutable gameepisode value used by the doomstat subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/doomstat.ml#L98)

<a id="global-global-gamemap-gamemap-src-doomstat-ml-1822732675"></a>
### gamemap

```ml
gamemap
```

Tracks the mutable gamemap value used by the doomstat subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/doomstat.ml#L100)

<a id="global-global-gamemission-gamemission-src-doomstat-ml-1761489635"></a>
### gamemission

```ml
gamemission
```

Exposes `GameMission_t.doom` through the legacy `gamemission` alias.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/doomstat.ml#L31)

<a id="global-global-gamemode-gamemode-src-doomstat-ml-1889835589"></a>
### gamemode

```ml
gamemode
```

Exposes `GameMode_t.indetermined` through the legacy `gamemode` alias.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/doomstat.ml#L28)

<a id="global-global-gameskill-gameskill-src-doomstat-ml-1892312319"></a>
### gameskill

```ml
gameskill
```

Exposes `skill_t.sk_medium` through the legacy `gameskill` alias.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/doomstat.ml#L96)

<a id="global-global-gamestate-gamestate-src-doomstat-ml-1911318091"></a>
### gamestate

```ml
gamestate
```

Exposes `gamestate_t.GS_DEMOSCREEN` through the legacy `gamestate` alias.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/doomstat.ml#L130)

<a id="global-global-gametic-gametic-src-doomstat-ml-301047263"></a>
### gametic

```ml
gametic
```

Tracks the mutable gametic value used by the doomstat subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/doomstat.ml#L132)

<a id="global-global-interp-view-interp-view-src-doomstat-ml-1383476535"></a>
### interp_view

```ml
interp_view
```

Tracks whether interp view is active in the doomstat subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/doomstat.ml#L150)

<a id="global-global-language-language-src-doomstat-ml-202299111"></a>
### language

```ml
language
```

Exposes `Language_t.english` through the legacy `language` alias.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/doomstat.ml#L34)

<a id="constant-constant-max-dm-starts-const-max-dm-starts-10-src-doomstat-ml-1495817147"></a>
### MAX_DM_STARTS

```ml
const MAX_DM_STARTS = 10
```

Defines the maximum max dm starts accepted by the doomstat subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/doomstat.ml#L25)

<a id="global-global-maxammo-maxammo-src-doomstat-ml-1376067475"></a>
### maxammo

```ml
maxammo
```

Stores the maxammo collection used by the doomstat subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/doomstat.ml#L171)

<a id="global-global-menuactive-menuactive-src-doomstat-ml-273318689"></a>
### menuactive

```ml
menuactive
```

Tracks whether menuactive is active in the doomstat subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/doomstat.ml#L54)

<a id="global-global-modifiedgame-modifiedgame-src-doomstat-ml-724328209"></a>
### modifiedgame

```ml
modifiedgame
```

Tracks whether modifiedgame is active in the doomstat subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/doomstat.ml#L37)

<a id="global-global-mousesensitivity-mousesensitivity-src-doomstat-ml-762694447"></a>
### mouseSensitivity

```ml
mouseSensitivity
```

Tracks the mutable mouse sensitivity value used by the doomstat subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/doomstat.ml#L142)

<a id="global-global-netgame-netgame-src-doomstat-ml-1428834499"></a>
### netgame

```ml
netgame
```

Tracks whether netgame is active in the doomstat subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/doomstat.ml#L49)

<a id="global-global-noblit-noblit-src-doomstat-ml-983231191"></a>
### noblit

```ml
noblit
```

Tracks whether noblit is active in the doomstat subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/doomstat.ml#L127)

<a id="global-global-nodrawers-nodrawers-src-doomstat-ml-580521563"></a>
### nodrawers

```ml
nodrawers
```

Tracks whether nodrawers is active in the doomstat subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/doomstat.ml#L125)

<a id="global-global-nomonsters-nomonsters-src-doomstat-ml-1503956119"></a>
### nomonsters

```ml
nomonsters
```

Tracks whether nomonsters is active in the doomstat subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/doomstat.ml#L40)

<a id="global-global-paused-paused-src-doomstat-ml-262678119"></a>
### paused

```ml
paused
```

Tracks whether paused is active in the doomstat subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/doomstat.ml#L56)

<a id="global-global-playeringame-playeringame-src-doomstat-ml-307370111"></a>
### playeringame

```ml
playeringame
```

Stores the playeringame collection used by the doomstat subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/doomstat.ml#L84)

<a id="global-global-players-players-src-doomstat-ml-1772028087"></a>
### players

```ml
players
```

Stores the players collection used by the doomstat subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/doomstat.ml#L77)

<a id="global-global-playerstarts-playerstarts-src-doomstat-ml-2138617507"></a>
### playerstarts

```ml
playerstarts
```

Stores the playerstarts collection used by the doomstat subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/doomstat.ml#L168)

<a id="global-global-precache-precache-src-doomstat-ml-93525361"></a>
### precache

```ml
precache
```

Tracks whether precache is active in the doomstat subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/doomstat.ml#L140)

<a id="global-global-render-lerp-frac-render-lerp-frac-src-doomstat-ml-1090169905"></a>
### render_lerp_frac

```ml
render_lerp_frac
```

Tracks the mutable render lerp frac value used by the doomstat subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/doomstat.ml#L148)

<a id="global-global-respawnmonsters-respawnmonsters-src-doomstat-ml-1902675055"></a>
### respawnmonsters

```ml
respawnmonsters
```

Tracks whether respawnmonsters is active in the doomstat subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/doomstat.ml#L103)

<a id="global-global-respawnparm-respawnparm-src-doomstat-ml-1434746287"></a>
### respawnparm

```ml
respawnparm
```

Tracks whether respawnparm is active in the doomstat subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/doomstat.ml#L42)

<a id="global-global-singledemo-singledemo-src-doomstat-ml-1193672753"></a>
### singledemo

```ml
singledemo
```

Tracks whether singledemo is active in the doomstat subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/doomstat.ml#L69)

<a id="global-global-singletics-singletics-src-doomstat-ml-909343517"></a>
### singletics

```ml
singletics
```

Tracks whether singletics is active in the doomstat subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/doomstat.ml#L144)

<a id="global-global-snd-desiredmusicdevice-snd-desiredmusicdevice-src-doomstat-ml-256134073"></a>
### snd_DesiredMusicDevice

```ml
snd_DesiredMusicDevice
```

Tracks the mutable snd desired music device value used by the doomstat subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/doomstat.ml#L114)

<a id="global-global-snd-desiredsfxdevice-snd-desiredsfxdevice-src-doomstat-ml-531567597"></a>
### snd_DesiredSfxDevice

```ml
snd_DesiredSfxDevice
```

Tracks the mutable snd desired sfx device value used by the doomstat subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/doomstat.ml#L116)

<a id="global-global-snd-musicdevice-snd-musicdevice-src-doomstat-ml-608733771"></a>
### snd_MusicDevice

```ml
snd_MusicDevice
```

Tracks the mutable snd music device value used by the doomstat subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/doomstat.ml#L110)

<a id="global-global-snd-musicvolume-snd-musicvolume-src-doomstat-ml-394281199"></a>
### snd_MusicVolume

```ml
snd_MusicVolume
```

Tracks the mutable snd music volume value used by the doomstat subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/doomstat.ml#L108)

<a id="global-global-snd-sfxdevice-snd-sfxdevice-src-doomstat-ml-204863095"></a>
### snd_SfxDevice

```ml
snd_SfxDevice
```

Tracks the mutable snd sfx device value used by the doomstat subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/doomstat.ml#L112)

<a id="global-global-snd-sfxvolume-snd-sfxvolume-src-doomstat-ml-1075465187"></a>
### snd_SfxVolume

```ml
snd_SfxVolume
```

Tracks the mutable snd sfx volume value used by the doomstat subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/doomstat.ml#L106)

<a id="global-global-startepisode-startepisode-src-doomstat-ml-2130985321"></a>
### startepisode

```ml
startepisode
```

Tracks the mutable startepisode value used by the doomstat subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/doomstat.ml#L89)

<a id="global-global-startmap-startmap-src-doomstat-ml-408425879"></a>
### startmap

```ml
startmap
```

Tracks the mutable startmap value used by the doomstat subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/doomstat.ml#L91)

<a id="global-global-startskill-startskill-src-doomstat-ml-1820343705"></a>
### startskill

```ml
startskill
```

Exposes `skill_t.sk_medium` through the legacy `startskill` alias.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/doomstat.ml#L87)

<a id="global-global-statusbaractive-statusbaractive-src-doomstat-ml-824841799"></a>
### statusbaractive

```ml
statusbaractive
```

Tracks whether statusbaractive is active in the doomstat subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/doomstat.ml#L119)

<a id="global-global-totalitems-totalitems-src-doomstat-ml-1308203791"></a>
### totalitems

```ml
totalitems
```

Tracks the mutable totalitems value used by the doomstat subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/doomstat.ml#L156)

<a id="global-global-totalkills-totalkills-src-doomstat-ml-2059869277"></a>
### totalkills

```ml
totalkills
```

Tracks the mutable totalkills value used by the doomstat subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/doomstat.ml#L154)

<a id="global-global-totalsecret-totalsecret-src-doomstat-ml-1892576215"></a>
### totalsecret

```ml
totalsecret
```

Tracks the mutable totalsecret value used by the doomstat subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/doomstat.ml#L158)

<a id="global-global-uncapped-render-uncapped-render-src-doomstat-ml-623728655"></a>
### uncapped_render

```ml
uncapped_render
```

Tracks whether uncapped render is active in the doomstat subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/doomstat.ml#L146)

<a id="global-global-usergame-usergame-src-doomstat-ml-1855194925"></a>
### usergame

```ml
usergame
```

Tracks whether usergame is active in the doomstat subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/doomstat.ml#L63)

<a id="global-global-viewactive-viewactive-src-doomstat-ml-1551061729"></a>
### viewactive

```ml
viewactive
```

Tracks whether viewactive is active in the doomstat subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/doomstat.ml#L123)

<a id="global-global-wipegamestate-wipegamestate-src-doomstat-ml-832117335"></a>
### wipegamestate

```ml
wipegamestate
```

Exposes `gamestate_t.GS_DEMOSCREEN` through the legacy `wipegamestate` alias.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/doomstat.ml#L134)

<a id="global-global-wminfo-wminfo-src-doomstat-ml-903298539"></a>
### wminfo

```ml
wminfo
```

Holds the optional wminfo resource used by the doomstat subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/doomstat.ml#L161)
