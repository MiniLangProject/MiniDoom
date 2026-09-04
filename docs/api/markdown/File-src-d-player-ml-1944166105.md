# `src/d_player.ml`

[Home](README.md) · [Files](Files.md)

Defines player runtime state, cheats, intermission statistics, and constructors for correctly initialized player records.

Package: [`(global)`](Package-global-1952375359.md)

Reachable from entry: **yes**

## Imports

- `d_items.ml` → [src/d_items.ml](File-src-d-items-ml-1350618780.md)
- `d_ticcmd.ml` → [src/d_ticcmd.ml](File-src-d-ticcmd-ml-1143326682.md)
- `p_mobj.ml` → [src/p_mobj.ml](File-src-p-mobj-ml-1335564114.md)
- `p_pspr.ml` → [src/p_pspr.ml](File-src-p-pspr-ml-844718747.md)

## Declarations

<a id="function-function-dp-boolarray-function-dp-boolarray-n-v-src-d-player-ml-953575162"></a>
### _DP_BoolArray

```ml
function _DP_BoolArray(n, v)
```

Allocates a fixed-length boolean array initialized from a strictly boolean input.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `n` | `dynamic` | — | Number of values to process. |
| `v` | `dynamic` | — | Value consumed by the operation. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/d_player.ml#L204)

<a id="function-function-dp-intarray-function-dp-intarray-n-v-src-d-player-ml-641535692"></a>
### _DP_IntArray

```ml
function _DP_IntArray(n, v)
```

Allocates a fixed-length integer array initialized to the supplied value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `n` | `dynamic` | — | Number of values to process. |
| `v` | `dynamic` | — | Value consumed by the operation. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/d_player.ml#L187)

- [cheat_t](Type-cheat-t-140538151.md) — enum
<a id="function-function-player-makedefault-function-player-makedefault-src-d-player-ml-1838920520"></a>
### Player_MakeDefault

```ml
function Player_MakeDefault()
```

Constructs a player record with correctly sized inventory, weapon, power, frag, and psprite arrays and canonical spawn defaults.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/d_player.ml#L219)

- [player_t](Type-player-t-518722043.md) — struct
- [playerstate_t](Type-playerstate-t-2049307582.md) — enum
- [wbplayerstruct_t](Type-wbplayerstruct-t-1594333471.md) — struct
- [wbstartstruct_t](Type-wbstartstruct-t-613710082.md) — struct
