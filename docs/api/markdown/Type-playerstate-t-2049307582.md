# `playerstate_t`

[Home](README.md) · [Source file](File-src-d-player-ml-1944166105.md)

<a id="enum-enum-playerstate-t-enum-playerstate-t-src-d-player-ml-1051525791"></a>
## playerstate_t

```ml
enum playerstate_t
```

Tracks whether a player is actively playing, awaiting rebirth, or has completed the current level.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/d_player.ml#L27)

## Members

<a id="enum_variant-enum-variant-playerstate-t-pst-dead-pst-dead-1-src-d-player-ml-1171972657"></a>
### PST_DEAD

```ml
PST_DEAD = 1
```

Represents pst dead in `playerstate_t`


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/d_player.ml#L31)

<a id="enum_variant-enum-variant-playerstate-t-pst-live-pst-live-0-src-d-player-ml-900057990"></a>
### PST_LIVE

```ml
PST_LIVE = 0
```

Represents pst live in `playerstate_t`


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/d_player.ml#L29)

<a id="enum_variant-enum-variant-playerstate-t-pst-reborn-pst-reborn-2-src-d-player-ml-134346568"></a>
### PST_REBORN

```ml
PST_REBORN = 2
```

Represents pst reborn in `playerstate_t`


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/d_player.ml#L33)
