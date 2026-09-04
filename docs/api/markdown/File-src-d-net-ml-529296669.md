# `src/d_net.ml`

[Home](README.md) · [Files](Files.md)

Runs legacy lockstep networking and host-authoritative input, snapshot, phase, stats, and chat replication.

Package: [`(global)`](Package-global-1952375359.md)

Reachable from entry: **yes**

## Imports

- `d_player.ml` → [src/d_player.ml](File-src-d-player-ml-1944166105.md)
- `doomdef.ml` → [src/doomdef.ml](File-src-doomdef-ml-460406769.md)
- `doomstat.ml` → [src/doomstat.ml](File-src-doomstat-ml-1652708088.md)
- `g_game.ml` → [src/g_game.ml](File-src-g-game-ml-257299317.md)
- `i_net.ml` → [src/i_net.ml](File-src-i-net-ml-1331775872.md)
- `i_system.ml` → [src/i_system.ml](File-src-i-system-ml-1632920966.md)
- `i_video.ml` → [src/i_video.ml](File-src-i-video-ml-140536292.md)
- `info.ml` → [src/info.ml](File-src-info-ml-1415270573.md)
- `m_menu.ml` → [src/m_menu.ml](File-src-m-menu-ml-331716860.md)
- `mp_platform.ml` → [src/mp_platform.ml](File-src-mp-platform-ml-1361006310.md)
- `p_maputl.ml` → [src/p_maputl.ml](File-src-p-maputl-ml-227665141.md)
- `p_mobj.ml` → [src/p_mobj.ml](File-src-p-mobj-ml-1335564114.md)
- `p_tick.ml` → [src/p_tick.ml](File-src-p-tick-ml-887781845.md)
- `r_state.ml` → [src/r_state.ml](File-src-r-state-ml-691819649.md)
- `s_sound.ml` → [src/s_sound.ml](File-src-s-sound-ml-1485495390.md)
- `sounds.ml` → [src/sounds.ml](File-src-sounds-ml-1875364049.md)
- `std/math.ml` → `../MiniLangCompilerOptimization/MiniLangCompilerPy/std/math.ml` — external dependency

## Declarations

<a id="function-function-dnet-copycmd-inline-function-dnet-copycmd-src-src-d-net-ml-1325907731"></a>
### _DNet_CopyCmd

```ml
inline function _DNet_CopyCmd(src)
```

Copies a tic command by value so ring-buffer reuse cannot mutate queued input.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `src` | `dynamic` | — | Src value supplied to `_DNet_CopyCmd`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/d_net.ml#L766)

<a id="function-function-dnet-copystoretobuffer-function-dnet-copystoretobuffer-src-src-d-net-ml-438357362"></a>
### _DNet_CopyStoreToBuffer

```ml
function _DNet_CopyStoreToBuffer(src)
```

Commits a decoded packet store into netbuffer only after validation succeeds.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `src` | `dynamic` | — | Src value supplied to `_DNet_CopyStoreToBuffer`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/d_net.ml#L6328)

<a id="function-function-dnet-defaultcmds-inline-function-dnet-defaultcmds-src-d-net-ml-1977705497"></a>
### _DNet_DefaultCmds

```ml
inline function _DNet_DefaultCmds()
```

Allocates a full BACKUPTICS command ring initialized to neutral input.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/d_net.ml#L616)

<a id="function-function-dnet-ensurestatearrays-function-dnet-ensurestatearrays-src-d-net-ml-1697579430"></a>
### _DNet_EnsureStateArrays

```ml
function _DNet_EnsureStateArrays()
```

Restores all legacy lockstep rings to protocol sizes before packet/tic access.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/d_net.ml#L727)

<a id="function-function-dnet-enumindex-inline-function-dnet-enumindex-v-limit-src-d-net-ml-414909372"></a>
### _DNet_EnumIndex

```ml
inline function _DNet_EnumIndex(v, limit)
```

Normalizes enum/int values to a bounded integer enum index.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `v` | `dynamic` | — | Value consumed by the operation. |
| `limit` | `dynamic` | — | Limit value supplied to `_DNet_EnumIndex`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/d_net.ml#L657)

<a id="global-global-dnet-exitmsg-dnet-exitmsg-src-d-net-ml-275146300"></a>
### _dnet_exitmsg

```ml
_dnet_exitmsg
```

Stores the mutable dnet exitmsg text used by the d net subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/d_net.ml#L169)

<a id="global-global-dnet-frameon-dnet-frameon-src-d-net-ml-387993112"></a>
### _dnet_frameon

```ml
_dnet_frameon
```

Tracks the mutable dnet frameon value used by the d net subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/d_net.ml#L178)

<a id="global-global-dnet-frameskip-dnet-frameskip-src-d-net-ml-458338440"></a>
### _dnet_frameskip

```ml
_dnet_frameskip
```

Stores the dnet frameskip collection used by the d net subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/d_net.ml#L181)

<a id="function-function-dnet-idiv-inline-function-dnet-idiv-a-b-src-d-net-ml-737104714"></a>
### _DNet_IDiv

```ml
inline function _DNet_IDiv(a, b)
```

Returns a quotient truncated toward zero for tic math, with invalid operands mapped to zero.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `a` | `dynamic` | — | First input operand. |
| `b` | `dynamic` | — | Second input operand. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/d_net.ml#L678)

<a id="function-function-dnet-isseq-inline-function-dnet-isseq-v-src-d-net-ml-296876571"></a>
### _DNet_IsSeq

```ml
inline function _DNet_IsSeq(v)
```

Accepts arrays and lists wherever network codecs require indexed sequence access.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `v` | `dynamic` | — | Value consumed by the operation. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/d_net.ml#L629)

<a id="function-function-dnet-makestorefrombuffer-function-dnet-makestorefrombuffer-src-d-net-ml-1469315966"></a>
### _DNet_MakeStoreFromBuffer

```ml
function _DNet_MakeStoreFromBuffer()
```

Takes an atomic value-copy snapshot of the mutable legacy netbuffer.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/d_net.ml#L6305)

<a id="constant-constant-dnet-mp-actor-candidate-multiplier-const-dnet-mp-actor-candidate-multiplier-6-src-d-net-ml-58576979"></a>
### _DNET_MP_ACTOR_CANDIDATE_MULTIPLIER

```ml
const _DNET_MP_ACTOR_CANDIDATE_MULTIPLIER = 6
```

Defines dnet mp actor candidate multiplier for the d net subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/d_net.ml#L283)

<a id="constant-constant-dnet-mp-actor-pool-per-snapshot-const-dnet-mp-actor-pool-per-snapshot-80-src-d-net-ml-287565029"></a>
### _DNET_MP_ACTOR_POOL_PER_SNAPSHOT

```ml
const _DNET_MP_ACTOR_POOL_PER_SNAPSHOT = 80
```

Defines dnet mp actor pool per snapshot for the d net subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/d_net.ml#L262)

<a id="constant-constant-dnet-mp-chat-broadcast-const-dnet-mp-chat-broadcast-5-src-d-net-ml-87402872"></a>
### _DNET_MP_CHAT_BROADCAST

```ml
const _DNET_MP_CHAT_BROADCAST = 5
```

Defines dnet mp chat broadcast for the d net subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/d_net.ml#L214)

<a id="constant-constant-dnet-mp-chat-cooldown-tics-const-dnet-mp-chat-cooldown-tics-4-src-d-net-ml-2041531081"></a>
### _DNET_MP_CHAT_COOLDOWN_TICS

```ml
const _DNET_MP_CHAT_COOLDOWN_TICS = 4
```

Defines dnet mp chat cooldown tics for the d net subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/d_net.ml#L217)

<a id="global-global-dnet-mp-client-actor-ids-dnet-mp-client-actor-ids-src-d-net-ml-1039112192"></a>
### _dnet_mp_client_actor_ids

```ml
_dnet_mp_client_actor_ids
```

Stores the dnet mp client actor ids collection used by the d net subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/d_net.ml#L450)

<a id="global-global-dnet-mp-client-actor-kind-dnet-mp-client-actor-kind-src-d-net-ml-459932434"></a>
### _dnet_mp_client_actor_kind

```ml
_dnet_mp_client_actor_kind
```

Stores the dnet mp client actor kind collection used by the d net subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/d_net.ml#L483)

<a id="global-global-dnet-mp-client-actor-last-snap-tic-dnet-mp-client-actor-last-snap-tic-src-d-net-ml-2066568416"></a>
### _dnet_mp_client_actor_last_snap_tic

```ml
_dnet_mp_client_actor_last_snap_tic
```

Stores the dnet mp client actor last snap tic collection used by the d net subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/d_net.ml#L480)

<a id="global-global-dnet-mp-client-actor-miss-dnet-mp-client-actor-miss-src-d-net-ml-1598905098"></a>
### _dnet_mp_client_actor_miss

```ml
_dnet_mp_client_actor_miss
```

Stores the dnet mp client actor miss collection used by the d net subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/d_net.ml#L456)

<a id="global-global-dnet-mp-client-actor-refs-dnet-mp-client-actor-refs-src-d-net-ml-466334114"></a>
### _dnet_mp_client_actor_refs

```ml
_dnet_mp_client_actor_refs
```

Stores the dnet mp client actor refs collection used by the d net subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/d_net.ml#L453)

<a id="global-global-dnet-mp-client-actor-tang-dnet-mp-client-actor-tang-src-d-net-ml-544468754"></a>
### _dnet_mp_client_actor_tang

```ml
_dnet_mp_client_actor_tang
```

Stores the dnet mp client actor tang collection used by the d net subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/d_net.ml#L468)

<a id="global-global-dnet-mp-client-actor-tx-dnet-mp-client-actor-tx-src-d-net-ml-1193844414"></a>
### _dnet_mp_client_actor_tx

```ml
_dnet_mp_client_actor_tx
```

Stores the dnet mp client actor tx collection used by the d net subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/d_net.ml#L459)

<a id="global-global-dnet-mp-client-actor-ty-dnet-mp-client-actor-ty-src-d-net-ml-956304952"></a>
### _dnet_mp_client_actor_ty

```ml
_dnet_mp_client_actor_ty
```

Stores the dnet mp client actor ty collection used by the d net subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/d_net.ml#L462)

<a id="global-global-dnet-mp-client-actor-tz-dnet-mp-client-actor-tz-src-d-net-ml-1583757970"></a>
### _dnet_mp_client_actor_tz

```ml
_dnet_mp_client_actor_tz
```

Stores the dnet mp client actor tz collection used by the d net subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/d_net.ml#L465)

<a id="global-global-dnet-mp-client-actor-vx-dnet-mp-client-actor-vx-src-d-net-ml-163446462"></a>
### _dnet_mp_client_actor_vx

```ml
_dnet_mp_client_actor_vx
```

Stores the dnet mp client actor vx collection used by the d net subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/d_net.ml#L471)

<a id="global-global-dnet-mp-client-actor-vy-dnet-mp-client-actor-vy-src-d-net-ml-141660768"></a>
### _dnet_mp_client_actor_vy

```ml
_dnet_mp_client_actor_vy
```

Stores the dnet mp client actor vy collection used by the d net subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/d_net.ml#L474)

<a id="global-global-dnet-mp-client-actor-vz-dnet-mp-client-actor-vz-src-d-net-ml-1646888898"></a>
### _dnet_mp_client_actor_vz

```ml
_dnet_mp_client_actor_vz
```

Stores the dnet mp client actor vz collection used by the d net subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/d_net.ml#L477)

<a id="global-global-dnet-mp-client-cached-wistats-dnet-mp-client-cached-wistats-src-d-net-ml-1204095542"></a>
### _dnet_mp_client_cached_wistats

```ml
_dnet_mp_client_cached_wistats
```

Holds the optional dnet mp client cached wistats resource used by the d net subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/d_net.ml#L543)

<a id="global-global-dnet-mp-client-claimed-actors-dnet-mp-client-claimed-actors-src-d-net-ml-305092302"></a>
### _dnet_mp_client_claimed_actors

```ml
_dnet_mp_client_claimed_actors
```

Tracks the mutable dnet mp client claimed actors value used by the d net subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/d_net.ml#L552)

<a id="constant-constant-dnet-mp-client-extrap-abs-vel-max-missile-const-dnet-mp-client-extrap-abs-vel-max-missile-24-fracunit-src-d-net-ml-549489509"></a>
### _DNET_MP_CLIENT_EXTRAP_ABS_VEL_MAX_MISSILE

```ml
const _DNET_MP_CLIENT_EXTRAP_ABS_VEL_MAX_MISSILE = 24 * FRACUNIT
```

Defines the maximum dnet mp client extrap abs vel max missile accepted by the d net subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/d_net.ml#L332)

<a id="constant-constant-dnet-mp-client-extrap-abs-vel-max-mobile-const-dnet-mp-client-extrap-abs-vel-max-mobile-12-fracunit-src-d-net-ml-480546130"></a>
### _DNET_MP_CLIENT_EXTRAP_ABS_VEL_MAX_MOBILE

```ml
const _DNET_MP_CLIENT_EXTRAP_ABS_VEL_MAX_MOBILE = 12 * FRACUNIT
```

Defines the maximum dnet mp client extrap abs vel max mobile accepted by the d net subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/d_net.ml#L329)

<a id="constant-constant-dnet-mp-client-hard-snap-dist-const-dnet-mp-client-hard-snap-dist-128-fracunit-src-d-net-ml-504181844"></a>
### _DNET_MP_CLIENT_HARD_SNAP_DIST

```ml
const _DNET_MP_CLIENT_HARD_SNAP_DIST = 128 * FRACUNIT
```

Defines dnet mp client hard snap dist for the d net subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/d_net.ml#L320)

<a id="global-global-dnet-mp-client-have-wistats-dnet-mp-client-have-wistats-src-d-net-ml-2122943998"></a>
### _dnet_mp_client_have_wistats

```ml
_dnet_mp_client_have_wistats
```

Tracks whether dnet mp client have wistats is active in the d net subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/d_net.ml#L528)

<a id="constant-constant-dnet-mp-client-interp-den-const-dnet-mp-client-interp-den-3-src-d-net-ml-1920036634"></a>
### _DNET_MP_CLIENT_INTERP_DEN

```ml
const _DNET_MP_CLIENT_INTERP_DEN = 3
```

Defines dnet mp client interp den for the d net subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/d_net.ml#L317)

<a id="constant-constant-dnet-mp-client-interp-num-const-dnet-mp-client-interp-num-1-src-d-net-ml-1658650802"></a>
### _DNET_MP_CLIENT_INTERP_NUM

```ml
const _DNET_MP_CLIENT_INTERP_NUM = 1
```

Defines the dnet mp client interp num count used by the d net subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/d_net.ml#L314)

<a id="global-global-dnet-mp-client-last-phase-tick-dnet-mp-client-last-phase-tick-src-d-net-ml-1814475056"></a>
### _dnet_mp_client_last_phase_tick

```ml
_dnet_mp_client_last_phase_tick
```

Tracks the mutable dnet mp client last phase tick value used by the d net subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/d_net.ml#L375)

<a id="global-global-dnet-mp-client-last-smooth-tic-dnet-mp-client-last-smooth-tic-src-d-net-ml-1647064624"></a>
### _dnet_mp_client_last_smooth_tic

```ml
_dnet_mp_client_last_smooth_tic
```

Tracks the mutable dnet mp client last smooth tic value used by the d net subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/d_net.ml#L510)

<a id="global-global-dnet-mp-client-last-snapshot-tick-dnet-mp-client-last-snapshot-tick-src-d-net-ml-279099288"></a>
### _dnet_mp_client_last_snapshot_tick

```ml
_dnet_mp_client_last_snapshot_tick
```

Tracks the mutable dnet mp client last snapshot tick value used by the d net subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/d_net.ml#L513)

<a id="global-global-dnet-mp-client-local-pickups-armed-dnet-mp-client-local-pickups-armed-src-d-net-ml-271789920"></a>
### _dnet_mp_client_local_pickups_armed

```ml
_dnet_mp_client_local_pickups_armed
```

Tracks whether dnet mp client local pickups armed is active in the d net subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/d_net.ml#L546)

<a id="constant-constant-dnet-mp-client-max-extrap-missile-const-dnet-mp-client-max-extrap-missile-4-src-d-net-ml-503749681"></a>
### _DNET_MP_CLIENT_MAX_EXTRAP_MISSILE

```ml
const _DNET_MP_CLIENT_MAX_EXTRAP_MISSILE = 4
```

Defines the maximum dnet mp client max extrap missile accepted by the d net subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/d_net.ml#L323)

<a id="constant-constant-dnet-mp-client-max-extrap-mobile-const-dnet-mp-client-max-extrap-mobile-2-src-d-net-ml-1362314915"></a>
### _DNET_MP_CLIENT_MAX_EXTRAP_MOBILE

```ml
const _DNET_MP_CLIENT_MAX_EXTRAP_MOBILE = 2
```

Defines the maximum dnet mp client max extrap mobile accepted by the d net subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/d_net.ml#L326)

<a id="global-global-dnet-mp-client-pending-snapshot-dnet-mp-client-pending-snapshot-src-d-net-ml-512602218"></a>
### _dnet_mp_client_pending_snapshot

```ml
_dnet_mp_client_pending_snapshot
```

Holds the optional dnet mp client pending snapshot resource used by the d net subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/d_net.ml#L516)

<a id="global-global-dnet-mp-client-player-last-snap-tic-dnet-mp-client-player-last-snap-tic-src-d-net-ml-1631690986"></a>
### _dnet_mp_client_player_last_snap_tic

```ml
_dnet_mp_client_player_last_snap_tic
```

Stores the dnet mp client player last snap tic collection used by the d net subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/d_net.ml#L507)

<a id="global-global-dnet-mp-client-player-tang-dnet-mp-client-player-tang-src-d-net-ml-1632005012"></a>
### _dnet_mp_client_player_tang

```ml
_dnet_mp_client_player_tang
```

Stores the dnet mp client player tang collection used by the d net subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/d_net.ml#L495)

<a id="global-global-dnet-mp-client-player-tx-dnet-mp-client-player-tx-src-d-net-ml-1780366968"></a>
### _dnet_mp_client_player_tx

```ml
_dnet_mp_client_player_tx
```

Stores the dnet mp client player tx collection used by the d net subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/d_net.ml#L486)

<a id="global-global-dnet-mp-client-player-ty-dnet-mp-client-player-ty-src-d-net-ml-285312992"></a>
### _dnet_mp_client_player_ty

```ml
_dnet_mp_client_player_ty
```

Stores the dnet mp client player ty collection used by the d net subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/d_net.ml#L489)

<a id="global-global-dnet-mp-client-player-tz-dnet-mp-client-player-tz-src-d-net-ml-1375583272"></a>
### _dnet_mp_client_player_tz

```ml
_dnet_mp_client_player_tz
```

Stores the dnet mp client player tz collection used by the d net subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/d_net.ml#L492)

<a id="global-global-dnet-mp-client-player-vx-dnet-mp-client-player-vx-src-d-net-ml-122509372"></a>
### _dnet_mp_client_player_vx

```ml
_dnet_mp_client_player_vx
```

Stores the dnet mp client player vx collection used by the d net subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/d_net.ml#L498)

<a id="global-global-dnet-mp-client-player-vy-dnet-mp-client-player-vy-src-d-net-ml-1450977752"></a>
### _dnet_mp_client_player_vy

```ml
_dnet_mp_client_player_vy
```

Stores the dnet mp client player vy collection used by the d net subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/d_net.ml#L501)

<a id="global-global-dnet-mp-client-player-vz-dnet-mp-client-player-vz-src-d-net-ml-1110507076"></a>
### _dnet_mp_client_player_vz

```ml
_dnet_mp_client_player_vz
```

Stores the dnet mp client player vz collection used by the d net subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/d_net.ml#L504)

<a id="global-global-dnet-mp-client-seen-players-dnet-mp-client-seen-players-src-d-net-ml-1512646578"></a>
### _dnet_mp_client_seen_players

```ml
_dnet_mp_client_seen_players
```

Tracks the mutable dnet mp client seen players value used by the d net subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/d_net.ml#L549)

<a id="constant-constant-dnet-mp-client-stale-grace-sweeps-const-dnet-mp-client-stale-grace-sweeps-2-src-d-net-ml-1651108163"></a>
### _DNET_MP_CLIENT_STALE_GRACE_SWEEPS

```ml
const _DNET_MP_CLIENT_STALE_GRACE_SWEEPS = 2
```

Defines dnet mp client stale grace sweeps for the d net subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/d_net.ml#L277)

<a id="global-global-dnet-mp-client-ui-tic-dnet-mp-client-ui-tic-src-d-net-ml-1715344608"></a>
### _dnet_mp_client_ui_tic

```ml
_dnet_mp_client_ui_tic
```

Tracks the mutable dnet mp client ui tic value used by the d net subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/d_net.ml#L522)

<a id="global-global-dnet-mp-client-wait-wistats-dnet-mp-client-wait-wistats-src-d-net-ml-2034839388"></a>
### _dnet_mp_client_wait_wistats

```ml
_dnet_mp_client_wait_wistats
```

Tracks whether dnet mp client wait wistats is active in the d net subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/d_net.ml#L525)

<a id="global-global-dnet-mp-client-wistats-error-dnet-mp-client-wistats-error-src-d-net-ml-593610160"></a>
### _dnet_mp_client_wistats_error

```ml
_dnet_mp_client_wistats_error
```

Stores the mutable dnet mp client wistats error text used by the d net subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/d_net.ml#L540)

<a id="global-global-dnet-mp-client-wistats-last-tick-dnet-mp-client-wistats-last-tick-src-d-net-ml-910124148"></a>
### _dnet_mp_client_wistats_last_tick

```ml
_dnet_mp_client_wistats_last_tick
```

Tracks the mutable dnet mp client wistats last tick value used by the d net subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/d_net.ml#L531)

<a id="global-global-dnet-mp-client-wistats-next-req-tic-dnet-mp-client-wistats-next-req-tic-src-d-net-ml-181505732"></a>
### _dnet_mp_client_wistats_next_req_tic

```ml
_dnet_mp_client_wistats_next_req_tic
```

Tracks the mutable dnet mp client wistats next req tic value used by the d net subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/d_net.ml#L534)

<a id="global-global-dnet-mp-client-wistats-req-count-dnet-mp-client-wistats-req-count-src-d-net-ml-68408068"></a>
### _dnet_mp_client_wistats_req_count

```ml
_dnet_mp_client_wistats_req_count
```

Tracks the mutable dnet mp client wistats req count value used by the d net subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/d_net.ml#L537)

<a id="global-global-dnet-mp-client-world-bootstrapped-dnet-mp-client-world-bootstrapped-src-d-net-ml-1171387486"></a>
### _dnet_mp_client_world_bootstrapped

```ml
_dnet_mp_client_world_bootstrapped
```

Tracks whether dnet mp client world bootstrapped is active in the d net subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/d_net.ml#L519)

<a id="global-global-dnet-mp-dbg-snap-built-dnet-mp-dbg-snap-built-src-d-net-ml-1772790220"></a>
### _dnet_mp_dbg_snap_built

```ml
_dnet_mp_dbg_snap_built
```

Tracks the mutable dnet mp dbg snap built value used by the d net subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/d_net.ml#L579)

<a id="global-global-dnet-mp-dbg-snap-calls-dnet-mp-dbg-snap-calls-src-d-net-ml-1277501488"></a>
### _dnet_mp_dbg_snap_calls

```ml
_dnet_mp_dbg_snap_calls
```

Tracks the mutable dnet mp dbg snap calls value used by the d net subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/d_net.ml#L564)

<a id="global-global-dnet-mp-dbg-snap-sent-dnet-mp-dbg-snap-sent-src-d-net-ml-856326704"></a>
### _dnet_mp_dbg_snap_sent

```ml
_dnet_mp_dbg_snap_sent
```

Tracks the mutable dnet mp dbg snap sent value used by the d net subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/d_net.ml#L585)

<a id="global-global-dnet-mp-dbg-snap-skip-nosend-dnet-mp-dbg-snap-skip-nosend-src-d-net-ml-140124252"></a>
### _dnet_mp_dbg_snap_skip_nosend

```ml
_dnet_mp_dbg_snap_skip_nosend
```

Tracks the mutable dnet mp dbg snap skip nosend value used by the d net subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/d_net.ml#L573)

<a id="global-global-dnet-mp-dbg-snap-skip-not-host-dnet-mp-dbg-snap-skip-not-host-src-d-net-ml-1087148608"></a>
### _dnet_mp_dbg_snap_skip_not_host

```ml
_dnet_mp_dbg_snap_skip_not_host
```

Tracks the mutable dnet mp dbg snap skip not host value used by the d net subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/d_net.ml#L567)

<a id="global-global-dnet-mp-dbg-snap-skip-not-level-dnet-mp-dbg-snap-skip-not-level-src-d-net-ml-458969016"></a>
### _dnet_mp_dbg_snap_skip_not_level

```ml
_dnet_mp_dbg_snap_skip_not_level
```

Tracks the mutable dnet mp dbg snap skip not level value used by the d net subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/d_net.ml#L570)

<a id="global-global-dnet-mp-dbg-snap-skip-rate-dnet-mp-dbg-snap-skip-rate-src-d-net-ml-868324824"></a>
### _dnet_mp_dbg_snap_skip_rate

```ml
_dnet_mp_dbg_snap_skip_rate
```

Tracks the mutable dnet mp dbg snap skip rate value used by the d net subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/d_net.ml#L576)

<a id="global-global-dnet-mp-dbg-snap-targets-dnet-mp-dbg-snap-targets-src-d-net-ml-1719410032"></a>
### _dnet_mp_dbg_snap_targets

```ml
_dnet_mp_dbg_snap_targets
```

Tracks the mutable dnet mp dbg snap targets value used by the d net subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/d_net.ml#L582)

<a id="global-global-dnet-mp-dbg-unknown-payload-drop-dnet-mp-dbg-unknown-payload-drop-src-d-net-ml-2048402872"></a>
### _dnet_mp_dbg_unknown_payload_drop

```ml
_dnet_mp_dbg_unknown_payload_drop
```

Tracks the mutable dnet mp dbg unknown payload drop value used by the d net subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/d_net.ml#L588)

<a id="constant-constant-dnet-mp-full-snapshot-period-const-dnet-mp-full-snapshot-period-35-src-d-net-ml-1533514351"></a>
### _DNET_MP_FULL_SNAPSHOT_PERIOD

```ml
const _DNET_MP_FULL_SNAPSHOT_PERIOD = 35
```

Defines dnet mp full snapshot period for the d net subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/d_net.ml#L223)

<a id="global-global-dnet-mp-host-actor-active-count-dnet-mp-host-actor-active-count-src-d-net-ml-1174773312"></a>
### _dnet_mp_host_actor_active_count

```ml
_dnet_mp_host_actor_active_count
```

Tracks the mutable dnet mp host actor active count value used by the d net subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/d_net.ml#L402)

<a id="global-global-dnet-mp-host-actor-cursor-dnet-mp-host-actor-cursor-src-d-net-ml-1324517680"></a>
### _dnet_mp_host_actor_cursor

```ml
_dnet_mp_host_actor_cursor
```

Tracks the mutable dnet mp host actor cursor value used by the d net subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/d_net.ml#L411)

<a id="global-global-dnet-mp-host-actor-ids-dnet-mp-host-actor-ids-src-d-net-ml-1475987296"></a>
### _dnet_mp_host_actor_ids

```ml
_dnet_mp_host_actor_ids
```

Stores the dnet mp host actor ids collection used by the d net subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/d_net.ml#L384)

<a id="global-global-dnet-mp-host-actor-miss-dnet-mp-host-actor-miss-src-d-net-ml-1562359376"></a>
### _dnet_mp_host_actor_miss

```ml
_dnet_mp_host_actor_miss
```

Stores the dnet mp host actor miss collection used by the d net subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/d_net.ml#L396)

<a id="global-global-dnet-mp-host-actor-nodes-dnet-mp-host-actor-nodes-src-d-net-ml-955244804"></a>
### _dnet_mp_host_actor_nodes

```ml
_dnet_mp_host_actor_nodes
```

Stores the dnet mp host actor nodes collection used by the d net subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/d_net.ml#L387)

<a id="global-global-dnet-mp-host-actor-refs-dnet-mp-host-actor-refs-src-d-net-ml-720367616"></a>
### _dnet_mp_host_actor_refs

```ml
_dnet_mp_host_actor_refs
```

Stores the dnet mp host actor refs collection used by the d net subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/d_net.ml#L390)

<a id="global-global-dnet-mp-host-actor-seen-dnet-mp-host-actor-seen-src-d-net-ml-1809250310"></a>
### _dnet_mp_host_actor_seen

```ml
_dnet_mp_host_actor_seen
```

Tracks the mutable dnet mp host actor seen value used by the d net subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/d_net.ml#L399)

<a id="global-global-dnet-mp-host-cached-wistats-dnet-mp-host-cached-wistats-src-d-net-ml-668182208"></a>
### _dnet_mp_host_cached_wistats

```ml
_dnet_mp_host_cached_wistats
```

Holds the optional dnet mp host cached wistats resource used by the d net subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/d_net.ml#L447)

<a id="global-global-dnet-mp-host-input-active-logged-dnet-mp-host-input-active-logged-src-d-net-ml-1700712684"></a>
### _dnet_mp_host_input_active_logged

```ml
_dnet_mp_host_input_active_logged
```

Stores the dnet mp host input active logged collection used by the d net subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/d_net.ml#L360)

<a id="global-global-dnet-mp-host-last-actor-sig-dnet-mp-host-last-actor-sig-src-d-net-ml-2060793680"></a>
### _dnet_mp_host_last_actor_sig

```ml
_dnet_mp_host_last_actor_sig
```

Stores the dnet mp host last actor sig collection used by the d net subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/d_net.ml#L393)

<a id="global-global-dnet-mp-host-last-chat-tic-dnet-mp-host-last-chat-tic-src-d-net-ml-242798768"></a>
### _dnet_mp_host_last_chat_tic

```ml
_dnet_mp_host_last_chat_tic
```

Stores the dnet mp host last chat tic collection used by the d net subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/d_net.ml#L381)

<a id="global-global-dnet-mp-host-last-frags-dnet-mp-host-last-frags-src-d-net-ml-962890264"></a>
### _dnet_mp_host_last_frags

```ml
_dnet_mp_host_last_frags
```

Stores the dnet mp host last frags collection used by the d net subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/d_net.ml#L378)

<a id="global-global-dnet-mp-host-last-phase-key-dnet-mp-host-last-phase-key-src-d-net-ml-1871136376"></a>
### _dnet_mp_host_last_phase_key

```ml
_dnet_mp_host_last_phase_key
```

Holds the optional dnet mp host last phase key resource used by the d net subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/d_net.ml#L366)

<a id="global-global-dnet-mp-host-last-player-sig-dnet-mp-host-last-player-sig-src-d-net-ml-1437471036"></a>
### _dnet_mp_host_last_player_sig

```ml
_dnet_mp_host_last_player_sig
```

Stores the dnet mp host last player sig collection used by the d net subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/d_net.ml#L417)

<a id="global-global-dnet-mp-host-last-sector-ceiling-dnet-mp-host-last-sector-ceiling-src-d-net-ml-1965365228"></a>
### _dnet_mp_host_last_sector_ceiling

```ml
_dnet_mp_host_last_sector_ceiling
```

Stores the dnet mp host last sector ceiling collection used by the d net subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/d_net.ml#L423)

<a id="global-global-dnet-mp-host-last-sector-floor-dnet-mp-host-last-sector-floor-src-d-net-ml-2034883256"></a>
### _dnet_mp_host_last_sector_floor

```ml
_dnet_mp_host_last_sector_floor
```

Stores the dnet mp host last sector floor collection used by the d net subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/d_net.ml#L420)

<a id="global-global-dnet-mp-host-last-sector-light-dnet-mp-host-last-sector-light-src-d-net-ml-697753728"></a>
### _dnet_mp_host_last_sector_light

```ml
_dnet_mp_host_last_sector_light
```

Stores the dnet mp host last sector light collection used by the d net subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/d_net.ml#L426)

<a id="global-global-dnet-mp-host-last-sector-special-dnet-mp-host-last-sector-special-src-d-net-ml-1466533656"></a>
### _dnet_mp_host_last_sector_special

```ml
_dnet_mp_host_last_sector_special
```

Stores the dnet mp host last sector special collection used by the d net subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/d_net.ml#L429)

<a id="global-global-dnet-mp-host-last-side-bottom-dnet-mp-host-last-side-bottom-src-d-net-ml-1753108720"></a>
### _dnet_mp_host_last_side_bottom

```ml
_dnet_mp_host_last_side_bottom
```

Stores the dnet mp host last side bottom collection used by the d net subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/d_net.ml#L438)

<a id="global-global-dnet-mp-host-last-side-mid-dnet-mp-host-last-side-mid-src-d-net-ml-498799776"></a>
### _dnet_mp_host_last_side_mid

```ml
_dnet_mp_host_last_side_mid
```

Stores the dnet mp host last side mid collection used by the d net subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/d_net.ml#L441)

<a id="global-global-dnet-mp-host-last-side-top-dnet-mp-host-last-side-top-src-d-net-ml-1930074376"></a>
### _dnet_mp_host_last_side_top

```ml
_dnet_mp_host_last_side_top
```

Stores the dnet mp host last side top collection used by the d net subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/d_net.ml#L435)

<a id="global-global-dnet-mp-host-last-wistats-req-tic-dnet-mp-host-last-wistats-req-tic-src-d-net-ml-1489864216"></a>
### _dnet_mp_host_last_wistats_req_tic

```ml
_dnet_mp_host_last_wistats_req_tic
```

Stores the dnet mp host last wistats req tic collection used by the d net subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/d_net.ml#L372)

<a id="global-global-dnet-mp-host-last-wistats-tic-dnet-mp-host-last-wistats-tic-src-d-net-ml-939817958"></a>
### _dnet_mp_host_last_wistats_tic

```ml
_dnet_mp_host_last_wistats_tic
```

Tracks the mutable dnet mp host last wistats tic value used by the d net subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/d_net.ml#L369)

<a id="global-global-dnet-mp-host-next-actor-id-dnet-mp-host-next-actor-id-src-d-net-ml-1171617196"></a>
### _dnet_mp_host_next_actor_id

```ml
_dnet_mp_host_next_actor_id
```

Tracks the mutable dnet mp host next actor id value used by the d net subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/d_net.ml#L408)

<a id="global-global-dnet-mp-host-removed-ids-dnet-mp-host-removed-ids-src-d-net-ml-1146350280"></a>
### _dnet_mp_host_removed_ids

```ml
_dnet_mp_host_removed_ids
```

Stores the dnet mp host removed ids collection used by the d net subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/d_net.ml#L405)

<a id="global-global-dnet-mp-host-sector-cursor-dnet-mp-host-sector-cursor-src-d-net-ml-419277576"></a>
### _dnet_mp_host_sector_cursor

```ml
_dnet_mp_host_sector_cursor
```

Tracks the mutable dnet mp host sector cursor value used by the d net subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/d_net.ml#L414)

<a id="global-global-dnet-mp-host-side-cursor-dnet-mp-host-side-cursor-src-d-net-ml-611016704"></a>
### _dnet_mp_host_side_cursor

```ml
_dnet_mp_host_side_cursor
```

Tracks the mutable dnet mp host side cursor value used by the d net subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/d_net.ml#L432)

<a id="global-global-dnet-mp-host-slot-fullsync-burst-dnet-mp-host-slot-fullsync-burst-src-d-net-ml-517525928"></a>
### _dnet_mp_host_slot_fullsync_burst

```ml
_dnet_mp_host_slot_fullsync_burst
```

Stores the dnet mp host slot fullsync burst collection used by the d net subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/d_net.ml#L444)

<a id="constant-constant-dnet-mp-input-active-redundant-copies-const-dnet-mp-input-active-redundant-copies-2-src-d-net-ml-73371205"></a>
### _DNET_MP_INPUT_ACTIVE_REDUNDANT_COPIES

```ml
const _DNET_MP_INPUT_ACTIVE_REDUNDANT_COPIES = 2
```

Defines dnet mp input active redundant copies for the d net subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/d_net.ml#L229)

<a id="constant-constant-dnet-mp-input-keepalive-tics-const-dnet-mp-input-keepalive-tics-1-src-d-net-ml-587189756"></a>
### _DNET_MP_INPUT_KEEPALIVE_TICS

```ml
const _DNET_MP_INPUT_KEEPALIVE_TICS = 1
```

Defines dnet mp input keepalive tics for the d net subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/d_net.ml#L226)

<a id="constant-constant-dnet-mp-join-fullsync-burst-tics-const-dnet-mp-join-fullsync-burst-tics-70-src-d-net-ml-508605054"></a>
### _DNET_MP_JOIN_FULLSYNC_BURST_TICS

```ml
const _DNET_MP_JOIN_FULLSYNC_BURST_TICS = 70
```

Defines dnet mp join fullsync burst tics for the d net subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/d_net.ml#L311)

<a id="global-global-dnet-mp-last-input-cmd-dnet-mp-last-input-cmd-src-d-net-ml-1527397328"></a>
### _dnet_mp_last_input_cmd

```ml
_dnet_mp_last_input_cmd
```

Holds the optional dnet mp last input cmd resource used by the d net subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/d_net.ml#L345)

<a id="global-global-dnet-mp-last-input-send-tic-dnet-mp-last-input-send-tic-src-d-net-ml-1495877900"></a>
### _dnet_mp_last_input_send_tic

```ml
_dnet_mp_last_input_send_tic
```

Tracks the mutable dnet mp last input send tic value used by the d net subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/d_net.ml#L342)

<a id="global-global-dnet-mp-last-input-seq-dnet-mp-last-input-seq-src-d-net-ml-835106948"></a>
### _dnet_mp_last_input_seq

```ml
_dnet_mp_last_input_seq
```

Tracks the mutable dnet mp last input seq value used by the d net subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/d_net.ml#L339)

<a id="global-global-dnet-mp-last-phase-tic-dnet-mp-last-phase-tic-src-d-net-ml-1975319500"></a>
### _dnet_mp_last_phase_tic

```ml
_dnet_mp_last_phase_tic
```

Tracks the mutable dnet mp last phase tic value used by the d net subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/d_net.ml#L363)

<a id="global-global-dnet-mp-last-snapshot-tic-dnet-mp-last-snapshot-tic-src-d-net-ml-2026929950"></a>
### _dnet_mp_last_snapshot_tic

```ml
_dnet_mp_last_snapshot_tic
```

Tracks the mutable dnet mp last snapshot tic value used by the d net subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/d_net.ml#L336)

<a id="global-global-dnet-mp-local-name-announced-dnet-mp-local-name-announced-src-d-net-ml-1120830144"></a>
### _dnet_mp_local_name_announced

```ml
_dnet_mp_local_name_announced
```

Tracks whether dnet mp local name announced is active in the d net subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/d_net.ml#L561)

<a id="constant-constant-dnet-mp-max-actors-per-snapshot-const-dnet-mp-max-actors-per-snapshot-20-src-d-net-ml-1859609765"></a>
### _DNET_MP_MAX_ACTORS_PER_SNAPSHOT

```ml
const _DNET_MP_MAX_ACTORS_PER_SNAPSHOT = 20
```

Defines the maximum dnet mp max actors per snapshot accepted by the d net subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/d_net.ml#L259)

<a id="constant-constant-dnet-mp-max-removed-per-snapshot-const-dnet-mp-max-removed-per-snapshot-96-src-d-net-ml-1314964298"></a>
### _DNET_MP_MAX_REMOVED_PER_SNAPSHOT

```ml
const _DNET_MP_MAX_REMOVED_PER_SNAPSHOT = 96
```

Defines the maximum dnet mp max removed per snapshot accepted by the d net subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/d_net.ml#L265)

<a id="constant-constant-dnet-mp-max-sectors-per-snapshot-const-dnet-mp-max-sectors-per-snapshot-8-src-d-net-ml-729167421"></a>
### _DNET_MP_MAX_SECTORS_PER_SNAPSHOT

```ml
const _DNET_MP_MAX_SECTORS_PER_SNAPSHOT = 8
```

Defines the maximum dnet mp max sectors per snapshot accepted by the d net subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/d_net.ml#L268)

<a id="constant-constant-dnet-mp-max-sides-per-snapshot-const-dnet-mp-max-sides-per-snapshot-8-src-d-net-ml-847329845"></a>
### _DNET_MP_MAX_SIDES_PER_SNAPSHOT

```ml
const _DNET_MP_MAX_SIDES_PER_SNAPSHOT = 8
```

Defines the maximum dnet mp max sides per snapshot accepted by the d net subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/d_net.ml#L271)

<a id="constant-constant-dnet-mp-name-bytes-const-dnet-mp-name-bytes-26-src-d-net-ml-414617215"></a>
### _DNET_MP_NAME_BYTES

```ml
const _DNET_MP_NAME_BYTES = 26
```

Defines dnet mp name bytes for the d net subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/d_net.ml#L250)

<a id="constant-constant-dnet-mp-payload-budget-const-dnet-mp-payload-budget-1391-src-d-net-ml-679930005"></a>
### _DNET_MP_PAYLOAD_BUDGET

```ml
const _DNET_MP_PAYLOAD_BUDGET = 1391
```

Keep below transport frame size (_MPPLAT_RECV_MAX=1400, minus 9-byte MP frame header with checksum). Defines dnet mp payload budget for the d net subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/d_net.ml#L308)

<a id="constant-constant-dnet-mp-phase-interval-const-dnet-mp-phase-interval-4-src-d-net-ml-210165413"></a>
### _DNET_MP_PHASE_INTERVAL

```ml
const _DNET_MP_PHASE_INTERVAL = 4
```

Defines dnet mp phase interval for the d net subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/d_net.ml#L235)

<a id="constant-constant-dnet-mp-player-row-bytes-const-dnet-mp-player-row-bytes-88-src-d-net-ml-1405273699"></a>
### _DNET_MP_PLAYER_ROW_BYTES

```ml
const _DNET_MP_PLAYER_ROW_BYTES = 88
```

Defines dnet mp player row bytes for the d net subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/d_net.ml#L274)

<a id="constant-constant-dnet-mp-relevance-distance-const-dnet-mp-relevance-distance-1536-fracunit-src-d-net-ml-7499942"></a>
### _DNET_MP_RELEVANCE_DISTANCE

```ml
const _DNET_MP_RELEVANCE_DISTANCE = 1536 * FRACUNIT
```

Defines dnet mp relevance distance for the d net subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/d_net.ml#L292)

<a id="constant-constant-dnet-mp-relevance-missile-bonus-const-dnet-mp-relevance-missile-bonus-768-fracunit-src-d-net-ml-81884076"></a>
### _DNET_MP_RELEVANCE_MISSILE_BONUS

```ml
const _DNET_MP_RELEVANCE_MISSILE_BONUS = 768 * FRACUNIT
```

Defines dnet mp relevance missile bonus for the d net subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/d_net.ml#L295)

<a id="constant-constant-dnet-mp-relevance-special-bonus-const-dnet-mp-relevance-special-bonus-384-fracunit-src-d-net-ml-448884348"></a>
### _DNET_MP_RELEVANCE_SPECIAL_BONUS

```ml
const _DNET_MP_RELEVANCE_SPECIAL_BONUS = 384 * FRACUNIT
```

Defines dnet mp relevance special bonus for the d net subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/d_net.ml#L298)

<a id="constant-constant-dnet-mp-relevance-view-bonus-const-dnet-mp-relevance-view-bonus-2048-fracunit-src-d-net-ml-1027735199"></a>
### _DNET_MP_RELEVANCE_VIEW_BONUS

```ml
const _DNET_MP_RELEVANCE_VIEW_BONUS = 2048 * FRACUNIT
```

Defines dnet mp relevance view bonus for the d net subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/d_net.ml#L301)

<a id="constant-constant-dnet-mp-relevance-view-halfangle-const-dnet-mp-relevance-view-halfangle-536870912-src-d-net-ml-650437292"></a>
### _DNET_MP_RELEVANCE_VIEW_HALFANGLE

```ml
const _DNET_MP_RELEVANCE_VIEW_HALFANGLE = 536870912
```

Defines dnet mp relevance view halfangle for the d net subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/d_net.ml#L304)

<a id="constant-constant-dnet-mp-remote-cmd-stale-tics-const-dnet-mp-remote-cmd-stale-tics-6-src-d-net-ml-66025"></a>
### _DNET_MP_REMOTE_CMD_STALE_TICS

```ml
const _DNET_MP_REMOTE_CMD_STALE_TICS = 6
```

Defines dnet mp remote cmd stale tics for the d net subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/d_net.ml#L232)

<a id="global-global-dnet-mp-remote-cmd-tic-dnet-mp-remote-cmd-tic-src-d-net-ml-2120358632"></a>
### _dnet_mp_remote_cmd_tic

```ml
_dnet_mp_remote_cmd_tic
```

Stores the dnet mp remote cmd tic collection used by the d net subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/d_net.ml#L354)

<a id="global-global-dnet-mp-remote-cmd-valid-dnet-mp-remote-cmd-valid-src-d-net-ml-881801700"></a>
### _dnet_mp_remote_cmd_valid

```ml
_dnet_mp_remote_cmd_valid
```

Stores the dnet mp remote cmd valid collection used by the d net subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/d_net.ml#L351)

<a id="global-global-dnet-mp-remote-cmds-dnet-mp-remote-cmds-src-d-net-ml-1009226522"></a>
### _dnet_mp_remote_cmds

```ml
_dnet_mp_remote_cmds
```

Stores the dnet mp remote cmds collection used by the d net subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/d_net.ml#L348)

<a id="global-global-dnet-mp-remote-input-last-seq-dnet-mp-remote-input-last-seq-src-d-net-ml-375420114"></a>
### _dnet_mp_remote_input_last_seq

```ml
_dnet_mp_remote_input_last_seq
```

Stores the dnet mp remote input last seq collection used by the d net subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/d_net.ml#L357)

<a id="constant-constant-dnet-mp-remove-resend-count-const-dnet-mp-remove-resend-count-3-src-d-net-ml-1870757362"></a>
### _DNET_MP_REMOVE_RESEND_COUNT

```ml
const _DNET_MP_REMOVE_RESEND_COUNT = 3
```

Defines dnet mp remove resend count for the d net subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/d_net.ml#L280)

<a id="constant-constant-dnet-mp-removed-queue-max-const-dnet-mp-removed-queue-max-4096-src-d-net-ml-1862558696"></a>
### _DNET_MP_REMOVED_QUEUE_MAX

```ml
const _DNET_MP_REMOVED_QUEUE_MAX = 4096
```

Defines the maximum dnet mp removed queue max accepted by the d net subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/d_net.ml#L289)

<a id="global-global-dnet-mp-snap-cache-actor-ids-dnet-mp-snap-cache-actor-ids-src-d-net-ml-2003779592"></a>
### _dnet_mp_snap_cache_actor_ids

```ml
_dnet_mp_snap_cache_actor_ids
```

Stores the dnet mp snap cache actor ids collection used by the d net subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/d_net.ml#L600)

<a id="global-global-dnet-mp-snap-cache-actor-refs-dnet-mp-snap-cache-actor-refs-src-d-net-ml-1941240954"></a>
### _dnet_mp_snap_cache_actor_refs

```ml
_dnet_mp_snap_cache_actor_refs
```

Stores the dnet mp snap cache actor refs collection used by the d net subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/d_net.ml#L603)

<a id="global-global-dnet-mp-snap-cache-force-all-dnet-mp-snap-cache-force-all-src-d-net-ml-919994728"></a>
### _dnet_mp_snap_cache_force_all

```ml
_dnet_mp_snap_cache_force_all
```

Tracks whether dnet mp snap cache force all is active in the d net subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/d_net.ml#L594)

<a id="global-global-dnet-mp-snap-cache-player-rows-dnet-mp-snap-cache-player-rows-src-d-net-ml-1840545200"></a>
### _dnet_mp_snap_cache_player_rows

```ml
_dnet_mp_snap_cache_player_rows
```

Stores the dnet mp snap cache player rows collection used by the d net subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/d_net.ml#L597)

<a id="global-global-dnet-mp-snap-cache-removed-ids-dnet-mp-snap-cache-removed-ids-src-d-net-ml-1519253900"></a>
### _dnet_mp_snap_cache_removed_ids

```ml
_dnet_mp_snap_cache_removed_ids
```

Stores the dnet mp snap cache removed ids collection used by the d net subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/d_net.ml#L606)

<a id="global-global-dnet-mp-snap-cache-sector-rows-dnet-mp-snap-cache-sector-rows-src-d-net-ml-413032952"></a>
### _dnet_mp_snap_cache_sector_rows

```ml
_dnet_mp_snap_cache_sector_rows
```

Stores the dnet mp snap cache sector rows collection used by the d net subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/d_net.ml#L609)

<a id="global-global-dnet-mp-snap-cache-side-rows-dnet-mp-snap-cache-side-rows-src-d-net-ml-1700883464"></a>
### _dnet_mp_snap_cache_side_rows

```ml
_dnet_mp_snap_cache_side_rows
```

Stores the dnet mp snap cache side rows collection used by the d net subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/d_net.ml#L612)

<a id="global-global-dnet-mp-snap-cache-tick-dnet-mp-snap-cache-tick-src-d-net-ml-2101287888"></a>
### _dnet_mp_snap_cache_tick

```ml
_dnet_mp_snap_cache_tick
```

Tracks the mutable dnet mp snap cache tick value used by the d net subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/d_net.ml#L591)

<a id="constant-constant-dnet-mp-snapshot-interval-const-dnet-mp-snapshot-interval-1-src-d-net-ml-928683984"></a>
### _DNET_MP_SNAPSHOT_INTERVAL

```ml
const _DNET_MP_SNAPSHOT_INTERVAL = 1
```

Defines dnet mp snapshot interval for the d net subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/d_net.ml#L220)

<a id="constant-constant-dnet-mp-static-heartbeat-fulls-const-dnet-mp-static-heartbeat-fulls-8-src-d-net-ml-2002267469"></a>
### _DNET_MP_STATIC_HEARTBEAT_FULLS

```ml
const _DNET_MP_STATIC_HEARTBEAT_FULLS = 8
```

Defines dnet mp static heartbeat fulls for the d net subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/d_net.ml#L286)

<a id="global-global-dnet-mp-was-authoritative-dnet-mp-was-authoritative-src-d-net-ml-1046576732"></a>
### _dnet_mp_was_authoritative

```ml
_dnet_mp_was_authoritative
```

Tracks whether dnet mp was authoritative is active in the d net subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/d_net.ml#L555)

<a id="global-global-dnet-mp-was-client-dnet-mp-was-client-src-d-net-ml-873088160"></a>
### _dnet_mp_was_client

```ml
_dnet_mp_was_client
```

Tracks whether dnet mp was client is active in the d net subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/d_net.ml#L558)

<a id="constant-constant-dnet-mp-wistats-base-row-bytes-const-dnet-mp-wistats-base-row-bytes-24-src-d-net-ml-1971449505"></a>
### _DNET_MP_WISTATS_BASE_ROW_BYTES

```ml
const _DNET_MP_WISTATS_BASE_ROW_BYTES = 24
```

Defines dnet mp wistats base row bytes for the d net subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/d_net.ml#L247)

<a id="constant-constant-dnet-mp-wistats-broadcast-interval-const-dnet-mp-wistats-broadcast-interval-18-src-d-net-ml-1207245920"></a>
### _DNET_MP_WISTATS_BROADCAST_INTERVAL

```ml
const _DNET_MP_WISTATS_BROADCAST_INTERVAL = 18
```

Defines dnet mp wistats broadcast interval for the d net subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/d_net.ml#L256)

<a id="constant-constant-dnet-mp-wistats-max-retries-const-dnet-mp-wistats-max-retries-3-src-d-net-ml-11637272"></a>
### _DNET_MP_WISTATS_MAX_RETRIES

```ml
const _DNET_MP_WISTATS_MAX_RETRIES = 3
```

Defines the maximum dnet mp wistats max retries accepted by the d net subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/d_net.ml#L241)

<a id="constant-constant-dnet-mp-wistats-req-cooldown-tics-const-dnet-mp-wistats-req-cooldown-tics-4-src-d-net-ml-748281105"></a>
### _DNET_MP_WISTATS_REQ_COOLDOWN_TICS

```ml
const _DNET_MP_WISTATS_REQ_COOLDOWN_TICS = 4
```

Defines dnet mp wistats req cooldown tics for the d net subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/d_net.ml#L244)

<a id="constant-constant-dnet-mp-wistats-retry-tics-const-dnet-mp-wistats-retry-tics-12-src-d-net-ml-1623264054"></a>
### _DNET_MP_WISTATS_RETRY_TICS

```ml
const _DNET_MP_WISTATS_RETRY_TICS = 12
```

Defines dnet mp wistats retry tics for the d net subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/d_net.ml#L238)

<a id="constant-constant-dnet-mp-wistats-row-bytes-const-dnet-mp-wistats-row-bytes-dnet-mp-wistats-base-row-bytes-dnet-mp-name-bytes-src-d-net-ml-378820801"></a>
### _DNET_MP_WISTATS_ROW_BYTES

```ml
const _DNET_MP_WISTATS_ROW_BYTES = _DNET_MP_WISTATS_BASE_ROW_BYTES + _DNET_MP_NAME_BYTES
```

Defines dnet mp wistats row bytes for the d net subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/d_net.ml#L253)

<a id="function-function-dnet-mpabs32-inline-function-dnet-mpabs32-v-src-d-net-ml-1799194019"></a>
### _DNet_MPAbs32

```ml
inline function _DNet_MPAbs32(v)
```

Returns integer absolute value for authoritative snapshot math.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `v` | `dynamic` | — | Value consumed by the operation. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/d_net.ml#L3835)

<a id="function-function-dnet-mpactiveslots-inline-function-dnet-mpactiveslots-src-d-net-ml-1213473945"></a>
### _DNet_MPActiveSlots

```ml
inline function _DNet_MPActiveSlots()
```

Returns currently active multiplayer slots with host slot always present.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/d_net.ml#L1145)

<a id="function-function-dnet-mpactorisstaticforsync-inline-function-dnet-mpactorisstaticforsync-mo-src-d-net-ml-1686958069"></a>
### _DNet_MPActorIsStaticForSync

```ml
inline function _DNet_MPActorIsStaticForSync(mo)
```

Detects mostly-static actor classes (pickups/corpses/decor) that can be heartbeated less often.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `mo` | `dynamic` | — | Map object affected by the operation. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/d_net.ml#L3926)

<a id="function-function-dnet-mpactorstatekey-inline-function-dnet-mpactorstatekey-mo-src-d-net-ml-1491357537"></a>
### _DNet_MPActorStateKey

```ml
inline function _DNet_MPActorStateKey(mo)
```

Builds compact actor state key used to suppress unchanged actor replication.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `mo` | `dynamic` | — | Map object affected by the operation. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/d_net.ml#L4035)

<a id="function-function-dnet-mpactorusable-inline-function-dnet-mpactorusable-mo-src-d-net-ml-1157409265"></a>
### _DNet_MPActorUsable

```ml
inline function _DNet_MPActorUsable(mo)
```

Checks whether thinker owner is a currently valid non-player mobj for replication.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `mo` | `dynamic` | — | Map object affected by the operation. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/d_net.ml#L2410)

<a id="function-function-dnet-mpangleabsdelta-inline-function-dnet-mpangleabsdelta-a-b-src-d-net-ml-1340856186"></a>
### _DNet_MPAngleAbsDelta

```ml
inline function _DNet_MPAngleAbsDelta(a, b)
```

Returns shortest unsigned absolute angle delta (0..0x80000000).

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `a` | `dynamic` | — | First input operand. |
| `b` | `dynamic` | — | Second input operand. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/d_net.ml#L3863)

<a id="function-function-dnet-mpangledeltasigned-inline-function-dnet-mpangledeltasigned-toang-fromang-src-d-net-ml-1178048032"></a>
### _DNet_MPAngleDeltaSigned

```ml
inline function _DNet_MPAngleDeltaSigned(toAng, fromAng)
```

Returns shortest signed angular delta (to-from) in Doom angle space.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `toAng` | `dynamic` | — | To ang value supplied to `_DNet_MPAngleDeltaSigned`. |
| `fromAng` | `dynamic` | — | From ang value supplied to `_DNet_MPAngleDeltaSigned`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/d_net.ml#L3365)

<a id="function-function-dnet-mpapproxdist2d-inline-function-dnet-mpapproxdist2d-dx-dy-src-d-net-ml-1511403408"></a>
### _DNet_MPApproxDist2D

```ml
inline function _DNet_MPApproxDist2D(dx, dy)
```

Computes Doom-style fast 2D distance approximation for relevance filtering.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `dx` | `dynamic` | — | Horizontal coordinate or vector component represented by dx. |
| `dy` | `dynamic` | — | Vertical coordinate or vector component represented by dy. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/d_net.ml#L3844)

<a id="function-function-dnet-mpbuildchatpacket-function-dnet-mpbuildchatpacket-senderslot-dest-msg-src-d-net-ml-410656134"></a>
### _DNet_MPBuildChatPacket

```ml
function _DNet_MPBuildChatPacket(senderSlot, dest, msg)
```

Builds one authoritative multiplayer chat packet.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `senderSlot` | `dynamic` | — | Sender slot value supplied to `_DNet_MPBuildChatPacket`. |
| `dest` | `dynamic` | — | Dest value supplied to `_DNet_MPBuildChatPacket`. |
| `msg` | `dynamic` | — | Msg value supplied to `_DNet_MPBuildChatPacket`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/d_net.ml#L1870)

<a id="function-function-dnet-mpbuildfeedpacket-inline-function-dnet-mpbuildfeedpacket-code-a-b-src-d-net-ml-67118443"></a>
### _DNet_MPBuildFeedPacket

```ml
inline function _DNet_MPBuildFeedPacket(code, a, b)
```

Builds a small gameplay event packet (kill feed, etc.).

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `code` | `dynamic` | — | Code value supplied to `_DNet_MPBuildFeedPacket`. |
| `a` | `dynamic` | — | First input operand. |
| `b` | `dynamic` | — | Second input operand. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/d_net.ml#L1830)

<a id="function-function-dnet-mpbuildintermissionwb-function-dnet-mpbuildintermissionwb-src-d-net-ml-2105750424"></a>
### _DNet_MPBuildIntermissionWB

```ml
function _DNet_MPBuildIntermissionWB()
```

Builds a complete intermission stats struct from wminfo with runtime fallback.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/d_net.ml#L1320)

<a id="function-function-dnet-mpbuildnamepacket-function-dnet-mpbuildnamepacket-slot-name-src-d-net-ml-563911167"></a>
### _DNet_MPBuildNamePacket

```ml
function _DNet_MPBuildNamePacket(slot, name)
```

Encodes one sanitized player-name update in a compact fixed-protocol packet.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `slot` | `dynamic` | — | Slot value supplied to `_DNet_MPBuildNamePacket`. |
| `name` | `dynamic` | — | Resource or object name to resolve. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/d_net.ml#L2066)

<a id="function-function-dnet-mpbuildphasepacket-function-dnet-mpbuildphasepacket-src-d-net-ml-1006707098"></a>
### _DNet_MPBuildPhasePacket

```ml
function _DNet_MPBuildPhasePacket()
```

Builds a compact host phase packet for client flow synchronization.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/d_net.ml#L2298)

<a id="function-function-dnet-mpbuildsnapshotpacket-function-dnet-mpbuildsnapshotpacket-forceall-snapshottick-src-d-net-ml-1421533285"></a>
### _DNet_MPBuildSnapshotPacket

```ml
function _DNet_MPBuildSnapshotPacket(forceAll, snapshotTick)
```

Builds one server snapshot payload for client replication.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `forceAll` | `dynamic` | — | Force all value supplied to `_DNet_MPBuildSnapshotPacket`. |
| `snapshotTick` | `dynamic` | — | Snapshot tick value supplied to `_DNet_MPBuildSnapshotPacket`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/d_net.ml#L4573)

<a id="function-function-dnet-mpbuildwistatspacket-function-dnet-mpbuildwistatspacket-src-d-net-ml-190965254"></a>
### _DNet_MPBuildWIStatsPacket

```ml
function _DNet_MPBuildWIStatsPacket()
```

Serializes host intermission stats so clients can render exact percentages and icons.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/d_net.ml#L1495)

<a id="function-function-dnet-mpclampabs-inline-function-dnet-mpclampabs-v-limit-src-d-net-ml-1287851144"></a>
### _DNet_MPClampAbs

```ml
inline function _DNet_MPClampAbs(v, limit)
```

Clamps value into [-limit, +limit].

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `v` | `dynamic` | — | Value consumed by the operation. |
| `limit` | `dynamic` | — | Limit value supplied to `_DNet_MPClampAbs`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/d_net.ml#L3376)

<a id="function-function-dnet-mpclientactormisslimit-inline-function-dnet-mpclientactormisslimit-baselimit-mo-src-d-net-ml-2142042409"></a>
### _DNet_MPClientActorMissLimit

```ml
inline function _DNet_MPClientActorMissLimit(baseLimit, mo)
```

Returns per-actor stale miss threshold so short-lived effects are culled quickly.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `baseLimit` | `dynamic` | — | Base limit value supplied to `_DNet_MPClientActorMissLimit`. |
| `mo` | `dynamic` | — | Map object affected by the operation. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/d_net.ml#L3981)

<a id="function-function-dnet-mpclientadvanceactors-function-dnet-mpclientadvanceactors-src-d-net-ml-1782398728"></a>
### _DNet_MPClientAdvanceActors

```ml
function _DNet_MPClientAdvanceActors()
```

Client-side actor smoothing using interpolation with bounded short extrapolation.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/d_net.ml#L3602)

<a id="function-function-dnet-mpclientadvanceplayers-function-dnet-mpclientadvanceplayers-src-d-net-ml-949574054"></a>
### _DNet_MPClientAdvancePlayers

```ml
function _DNet_MPClientAdvancePlayers()
```

Client-side smoothing for remote player movement and turning.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/d_net.ml#L3719)

<a id="function-function-dnet-mpclientapplychat-inline-function-dnet-mpclientapplychat-payload-src-d-net-ml-320147415"></a>
### _DNet_MPClientApplyChat

```ml
inline function _DNet_MPClientApplyChat(payload)
```

Applies one authoritative multiplayer chat message on the local HUD.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `payload` | `dynamic` | — | Payload value supplied to `_DNet_MPClientApplyChat`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/d_net.ml#L1942)

<a id="function-function-dnet-mpclientapplyfeed-function-dnet-mpclientapplyfeed-payload-src-d-net-ml-1750289340"></a>
### _DNet_MPClientApplyFeed

```ml
function _DNet_MPClientApplyFeed(payload)
```

Applies one host kill-feed packet on client HUD.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `payload` | `dynamic` | — | Payload value supplied to `_DNet_MPClientApplyFeed`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/d_net.ml#L5407)

<a id="function-function-dnet-mpclientapplyname-function-dnet-mpclientapplyname-payload-src-d-net-ml-1845363598"></a>
### _DNet_MPClientApplyName

```ml
function _DNet_MPClientApplyName(payload)
```

Applies one authoritative rename and reports changes made by another player.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `payload` | `dynamic` | — | Payload value supplied to `_DNet_MPClientApplyName`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/d_net.ml#L2133)

<a id="function-function-dnet-mpclientapplyphase-function-dnet-mpclientapplyphase-payload-src-d-net-ml-767835662"></a>
### _DNet_MPClientApplyPhase

```ml
function _DNet_MPClientApplyPhase(payload)
```

Applies host phase sync packets (level/intermission/finale) on client.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `payload` | `dynamic` | — | Payload value supplied to `_DNet_MPClientApplyPhase`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/d_net.ml#L5431)

<a id="function-function-dnet-mpclientapplysnapshot-function-dnet-mpclientapplysnapshot-payload-src-d-net-ml-118107484"></a>
### _DNet_MPClientApplySnapshot

```ml
function _DNet_MPClientApplySnapshot(payload)
```

Applies one authoritative world snapshot on client runtime.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `payload` | `dynamic` | — | Payload value supplied to `_DNet_MPClientApplySnapshot`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/d_net.ml#L5619)

<a id="function-function-dnet-mpclientapplywistats-function-dnet-mpclientapplywistats-payload-src-d-net-ml-1228798750"></a>
### _DNet_MPClientApplyWIStats

```ml
function _DNet_MPClientApplyWIStats(payload)
```

Applies host intermission stats packet to client WI runtime state.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `payload` | `dynamic` | — | Payload value supplied to `_DNet_MPClientApplyWIStats`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/d_net.ml#L1676)

<a id="function-function-dnet-mpclientbindactorid-inline-function-dnet-mpclientbindactorid-idx-aid-src-d-net-ml-1604579610"></a>
### _DNet_MPClientBindActorId

```ml
inline function _DNet_MPClientBindActorId(idx, aid)
```

Binds replicated actor id to one proxy slot and clears previous conflicting mapping.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `idx` | `dynamic` | — | Zero-based element or table index. |
| `aid` | `dynamic` | — | Aid value supplied to `_DNet_MPClientBindActorId`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/d_net.ml#L4125)

<a id="function-function-dnet-mpclientbootstrapworld-function-dnet-mpclientbootstrapworld-src-d-net-ml-1311616966"></a>
### _DNet_MPClientBootstrapWorld

```ml
function _DNet_MPClientBootstrapWorld()
```

Clears client-side local non-player thinkers before authoritative actor replication takes over.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/d_net.ml#L4175)

<a id="function-function-dnet-mpclientclassifyactor-inline-function-dnet-mpclientclassifyactor-atype-flags-mo-src-d-net-ml-9833139"></a>
### _DNet_MPClientClassifyActor

```ml
inline function _DNet_MPClientClassifyActor(atype, flags, mo)
```

Classifies actor replication behavior: 0 static, 1 mobile, 2 fast/effect (missile-like).

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `atype` | `dynamic` | — | Atype value supplied to `_DNet_MPClientClassifyActor`. |
| `flags` | `dynamic` | — | Bit flags that control the operation. |
| `mo` | `dynamic` | — | Map object affected by the operation. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/d_net.ml#L3511)

<a id="function-function-dnet-mpclientensureactormotionslot-inline-function-dnet-mpclientensureactormotionslot-idx-src-d-net-ml-1359704682"></a>
### _DNet_MPClientEnsureActorMotionSlot

```ml
inline function _DNet_MPClientEnsureActorMotionSlot(idx)
```

Ensures client-side actor smoothing arrays have capacity for one slot index.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `idx` | `dynamic` | — | Zero-based element or table index. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/d_net.ml#L3389)

<a id="function-function-dnet-mpclientensureplayermotionslots-inline-function-dnet-mpclientensureplayermotionslots-src-d-net-ml-206265"></a>
### _DNet_MPClientEnsurePlayerMotionSlots

```ml
inline function _DNet_MPClientEnsurePlayerMotionSlots()
```

Ensures client-side remote player smoothing arrays are sized for MAXPLAYERS.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/d_net.ml#L3418)

<a id="function-function-dnet-mpclientfindactorbypose-function-dnet-mpclientfindactorbypose-atype-ax-ay-az-claimed-src-d-net-ml-2011604112"></a>
### _DNet_MPClientFindActorByPose

```ml
function _DNet_MPClientFindActorByPose(atype, ax, ay, az, claimed)
```

Finds closest existing client actor proxy by type/position for id-churn recovery.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `atype` | `dynamic` | — | Atype value supplied to `_DNet_MPClientFindActorByPose`. |
| `ax` | `dynamic` | — | Horizontal coordinate or vector component represented by ax. |
| `ay` | `dynamic` | — | Vertical coordinate or vector component represented by ay. |
| `az` | `dynamic` | — | Az value supplied to `_DNet_MPClientFindActorByPose`. |
| `claimed` | `dynamic` | — | Claimed value supplied to `_DNet_MPClientFindActorByPose`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/d_net.ml#L4062)

<a id="function-function-dnet-mpclientfindactorbyuidfield-inline-function-dnet-mpclientfindactorbyuidfield-aid-src-d-net-ml-900818695"></a>
### _DNet_MPClientFindActorByUidField

```ml
inline function _DNet_MPClientFindActorByUidField(aid)
```

Finds a client actor proxy whose local mobj mpuid already matches replicated actor id.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `aid` | `dynamic` | — | Aid value supplied to `_DNet_MPClientFindActorByUidField`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/d_net.ml#L3327)

<a id="function-function-dnet-mpclientfindactorindex-inline-function-dnet-mpclientfindactorindex-idv-src-d-net-ml-1968831100"></a>
### _DNet_MPClientFindActorIndex

```ml
inline function _DNet_MPClientFindActorIndex(idv)
```

Finds client-side actor proxy registry index by replicated id.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `idv` | `dynamic` | — | Idv value supplied to `_DNet_MPClientFindActorIndex`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/d_net.ml#L3315)

<a id="function-function-dnet-mpclientfindclaimedactorexact-function-dnet-mpclientfindclaimedactorexact-atype-ax-ay-az-aang-aspr-afrm-astate-claimed-src-d-net-ml-499989603"></a>
### _DNet_MPClientFindClaimedActorExact

```ml
function _DNet_MPClientFindClaimedActorExact(atype, ax, ay, az, aang, aspr, afrm, astate, claimed)
```

Finds already-claimed actor proxy with exact replicated pose/state to suppress duplicate spawns.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `atype` | `dynamic` | — | Atype value supplied to `_DNet_MPClientFindClaimedActorExact`. |
| `ax` | `dynamic` | — | Horizontal coordinate or vector component represented by ax. |
| `ay` | `dynamic` | — | Vertical coordinate or vector component represented by ay. |
| `az` | `dynamic` | — | Az value supplied to `_DNet_MPClientFindClaimedActorExact`. |
| `aang` | `dynamic` | — | Aang value supplied to `_DNet_MPClientFindClaimedActorExact`. |
| `aspr` | `dynamic` | — | Aspr value supplied to `_DNet_MPClientFindClaimedActorExact`. |
| `afrm` | `dynamic` | — | Afrm value supplied to `_DNet_MPClientFindClaimedActorExact`. |
| `astate` | `dynamic` | — | Astate value supplied to `_DNet_MPClientFindClaimedActorExact`. |
| `claimed` | `dynamic` | — | Claimed value supplied to `_DNet_MPClientFindClaimedActorExact`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/d_net.ml#L4102)

<a id="function-function-dnet-mpclientfindfreeactorslot-inline-function-dnet-mpclientfindfreeactorslot-src-d-net-ml-499823801"></a>
### _DNet_MPClientFindFreeActorSlot

```ml
inline function _DNet_MPClientFindFreeActorSlot()
```

Returns reusable client registry slot whose actor id was cleared.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/d_net.ml#L3341)

<a id="function-function-dnet-mpclientremoveactorat-inline-function-dnet-mpclientremoveactorat-idx-src-d-net-ml-859753826"></a>
### _DNet_MPClientRemoveActorAt

```ml
inline function _DNet_MPClientRemoveActorAt(idx)
```

Removes one client-side replicated actor proxy.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `idx` | `dynamic` | — | Zero-based element or table index. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/d_net.ml#L4139)

<a id="function-function-dnet-mpclientresetplayermotionslot-inline-function-dnet-mpclientresetplayermotionslot-slot-src-d-net-ml-1691437429"></a>
### _DNet_MPClientResetPlayerMotionSlot

```ml
inline function _DNet_MPClientResetPlayerMotionSlot(slot)
```

Clears remote player smoothing state for one slot.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `slot` | `dynamic` | — | Slot value supplied to `_DNet_MPClientResetPlayerMotionSlot`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/d_net.ml#L3444)

<a id="function-function-dnet-mpclientstalemisslimit-function-dnet-mpclientstalemisslimit-src-d-net-ml-1455318298"></a>
### _DNet_MPClientStaleMissLimit

```ml
function _DNet_MPClientStaleMissLimit()
```

Computes how many full-snapshot misses an actor can accumulate before client-side stale removal.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/d_net.ml#L4008)

<a id="function-function-dnet-mpclienttrackactorsnapshot-function-dnet-mpclienttrackactorsnapshot-idx-mo-atype-afl-ax-ay-az-aang-snaptick-spawnednow-src-d-net-ml-1326063569"></a>
### _DNet_MPClientTrackActorSnapshot

```ml
function _DNet_MPClientTrackActorSnapshot(idx, mo, atype, afl, ax, ay, az, aang, snapTick, spawnedNow)
```

Stores target pose and velocity estimate for one replicated actor snapshot.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `idx` | `dynamic` | — | Zero-based element or table index. |
| `mo` | `dynamic` | — | Map object affected by the operation. |
| `atype` | `dynamic` | — | Atype value supplied to `_DNet_MPClientTrackActorSnapshot`. |
| `afl` | `dynamic` | — | Afl value supplied to `_DNet_MPClientTrackActorSnapshot`. |
| `ax` | `dynamic` | — | Horizontal coordinate or vector component represented by ax. |
| `ay` | `dynamic` | — | Vertical coordinate or vector component represented by ay. |
| `az` | `dynamic` | — | Az value supplied to `_DNet_MPClientTrackActorSnapshot`. |
| `aang` | `dynamic` | — | Aang value supplied to `_DNet_MPClientTrackActorSnapshot`. |
| `snapTick` | `dynamic` | — | Snap tick value supplied to `_DNet_MPClientTrackActorSnapshot`. |
| `spawnedNow` | `dynamic` | — | Spawned now value supplied to `_DNet_MPClientTrackActorSnapshot`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/d_net.ml#L3537)

<a id="function-function-dnet-mpclienttrackplayersnapshot-function-dnet-mpclienttrackplayersnapshot-slot-px-py-pz-pang-snaptick-hardsnap-src-d-net-ml-1162120845"></a>
### _DNet_MPClientTrackPlayerSnapshot

```ml
function _DNet_MPClientTrackPlayerSnapshot(slot, px, py, pz, pang, snapTick, hardSnap)
```

Stores remote player target pose and velocity estimate from authoritative snapshots.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `slot` | `dynamic` | — | Slot value supplied to `_DNet_MPClientTrackPlayerSnapshot`. |
| `px` | `dynamic` | — | Horizontal coordinate or vector component represented by px. |
| `py` | `dynamic` | — | Vertical coordinate or vector component represented by py. |
| `pz` | `dynamic` | — | Pz value supplied to `_DNet_MPClientTrackPlayerSnapshot`. |
| `pang` | `dynamic` | — | Pang value supplied to `_DNet_MPClientTrackPlayerSnapshot`. |
| `snapTick` | `dynamic` | — | Snap tick value supplied to `_DNet_MPClientTrackPlayerSnapshot`. |
| `hardSnap` | `dynamic` | — | Hard snap value supplied to `_DNet_MPClientTrackPlayerSnapshot`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/d_net.ml#L3467)

<a id="function-function-dnet-mpclientupdatewistatssync-function-dnet-mpclientupdatewistatssync-src-d-net-ml-1864367782"></a>
### _DNet_MPClientUpdateWIStatsSync

```ml
function _DNet_MPClientUpdateWIStatsSync()
```

Runs bounded request/retry logic until client received host intermission stats.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/d_net.ml#L1793)

<a id="function-function-dnet-mpcmdequals-inline-function-dnet-mpcmdequals-a-b-src-d-net-ml-129934498"></a>
### _DNet_MPCmdEquals

```ml
inline function _DNet_MPCmdEquals(a, b)
```

Returns true when two ticcmd structs carry the same gameplay input values.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `a` | `dynamic` | — | First input operand. |
| `b` | `dynamic` | — | Second input operand. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/d_net.ml#L4246)

<a id="function-function-dnet-mpcopyfrags4-inline-function-dnet-mpcopyfrags4-src-src-d-net-ml-1771428857"></a>
### _DNet_MPCopyFrags4

```ml
inline function _DNet_MPCopyFrags4(src)
```

Returns a fixed-size 4-entry frag row copied from arbitrary source sequence.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `src` | `dynamic` | — | Src value supplied to `_DNet_MPCopyFrags4`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/d_net.ml#L1184)

<a id="function-function-dnet-mpdrainauthoritativepackets-function-dnet-mpdrainauthoritativepackets-src-d-net-ml-1836919678"></a>
### _DNet_MPDrainAuthoritativePackets

```ml
function _DNet_MPDrainAuthoritativePackets()
```

Pumps and routes authoritative multiplayer packets for host/client.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/d_net.ml#L6225)

<a id="function-function-dnet-mpensurehostslotmobj-function-dnet-mpensurehostslotmobj-slot-src-d-net-ml-1948319562"></a>
### _DNet_MPEnsureHostSlotMobj

```ml
function _DNet_MPEnsureHostSlotMobj(slot)
```

Spawns missing remote player mobjs on host when late-joining clients become active.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `slot` | `dynamic` | — | Slot value supplied to `_DNet_MPEnsureHostSlotMobj`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/d_net.ml#L4390)

<a id="function-function-dnet-mpensureplayerstruct-inline-function-dnet-mpensureplayerstruct-slot-src-d-net-ml-1762105183"></a>
### _DNet_MPEnsurePlayerStruct

```ml
inline function _DNet_MPEnsurePlayerStruct(slot)
```

Ensures player slot contains a valid player struct.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `slot` | `dynamic` | — | Slot value supplied to `_DNet_MPEnsurePlayerStruct`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/d_net.ml#L3231)

<a id="function-function-dnet-mphostactorrelevantforslot-inline-function-dnet-mphostactorrelevantforslot-slot-mo-src-d-net-ml-1732957373"></a>
### _DNet_MPHostActorRelevantForSlot

```ml
inline function _DNet_MPHostActorRelevantForSlot(slot, mo)
```

Returns true when an actor is relevant enough for a specific client slot snapshot.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `slot` | `dynamic` | — | Slot value supplied to `_DNet_MPHostActorRelevantForSlot`. |
| `mo` | `dynamic` | — | Map object affected by the operation. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/d_net.ml#L3876)

<a id="function-function-dnet-mphostapplyactiveslots-function-dnet-mphostapplyactiveslots-src-d-net-ml-1335133890"></a>
### _DNet_MPHostApplyActiveSlots

```ml
function _DNet_MPHostApplyActiveSlots()
```

Synchronizes host player slot activity with platform peer list.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/d_net.ml#L4514)

<a id="function-function-dnet-mphostbroadcastallnames-function-dnet-mphostbroadcastallnames-src-d-net-ml-1207325710"></a>
### _DNet_MPHostBroadcastAllNames

```ml
function _DNet_MPHostBroadcastAllNames()
```

Refreshes the complete small slot-name table so newly joined clients learn existing peers immediately.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/d_net.ml#L2116)

<a id="function-function-dnet-mphostbroadcastkillfeed-function-dnet-mphostbroadcastkillfeed-killer-victim-src-d-net-ml-2054318403"></a>
### _DNet_MPHostBroadcastKillFeed

```ml
function _DNet_MPHostBroadcastKillFeed(killer, victim)
```

Broadcasts one host-authoritative kill message to all connected clients.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `killer` | `dynamic` | — | Killer value supplied to `_DNet_MPHostBroadcastKillFeed`. |
| `victim` | `dynamic` | — | Victim value supplied to `_DNet_MPHostBroadcastKillFeed`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/d_net.ml#L1891)

<a id="function-function-dnet-mphostbroadcastname-function-dnet-mphostbroadcastname-slot-name-src-d-net-ml-747329257"></a>
### _DNet_MPHostBroadcastName

```ml
function _DNet_MPHostBroadcastName(slot, name)
```

Broadcasts one host-approved slot name to every connected multiplayer client.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `slot` | `dynamic` | — | Slot value supplied to `_DNet_MPHostBroadcastName`. |
| `name` | `dynamic` | — | Resource or object name to resolve. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/d_net.ml#L2098)

<a id="function-function-dnet-mphostbroadcasttelefragfeed-function-dnet-mphostbroadcasttelefragfeed-killer-victim-src-d-net-ml-835436891"></a>
### _DNet_MPHostBroadcastTelefragFeed

```ml
function _DNet_MPHostBroadcastTelefragFeed(killer, victim)
```

Broadcasts one host-authoritative telefrag message to all connected clients.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `killer` | `dynamic` | — | Killer value supplied to `_DNet_MPHostBroadcastTelefragFeed`. |
| `victim` | `dynamic` | — | Victim value supplied to `_DNet_MPHostBroadcastTelefragFeed`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/d_net.ml#L1917)

<a id="function-function-dnet-mphostbroadcastwistats-function-dnet-mphostbroadcastwistats-src-d-net-ml-2038592958"></a>
### _DNet_MPHostBroadcastWIStats

```ml
function _DNet_MPHostBroadcastWIStats()
```

Broadcasts intermission stats snapshot to all connected clients.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/d_net.ml#L1605)

<a id="function-function-dnet-mphostcheckfragfeed-function-dnet-mphostcheckfragfeed-src-d-net-ml-605267374"></a>
### _DNet_MPHostCheckFragFeed

```ml
function _DNet_MPHostCheckFragFeed()
```

Detects host-side frag matrix increments and emits kill feed events.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/d_net.ml#L2230)

<a id="function-function-dnet-mphostcollectactorchunk-function-dnet-mphostcollectactorchunk-maxcount-forceall-snapshottick-src-d-net-ml-314326704"></a>
### _DNet_MPHostCollectActorChunk

```ml
function _DNet_MPHostCollectActorChunk(maxCount, forceAll, snapshotTick)
```

Returns rotating subset of changed host actors for snapshot payloads.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `maxCount` | `dynamic` | — | Number of max to process. |
| `forceAll` | `dynamic` | — | Force all value supplied to `_DNet_MPHostCollectActorChunk`. |
| `snapshotTick` | `dynamic` | — | Snapshot tick value supplied to `_DNet_MPHostCollectActorChunk`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/d_net.ml#L2706)

<a id="function-function-dnet-mphostcollectsectorchanges-function-dnet-mphostcollectsectorchanges-maxcount-forceall-src-d-net-ml-354029985"></a>
### _DNet_MPHostCollectSectorChanges

```ml
function _DNet_MPHostCollectSectorChanges(maxCount, forceAll)
```

Collects a rotating subset of changed sector dynamics for snapshots.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `maxCount` | `dynamic` | — | Number of max to process. |
| `forceAll` | `dynamic` | — | Force all value supplied to `_DNet_MPHostCollectSectorChanges`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/d_net.ml#L3045)

<a id="function-function-dnet-mphostcollectsidechanges-function-dnet-mphostcollectsidechanges-maxcount-forceall-src-d-net-ml-1321076381"></a>
### _DNet_MPHostCollectSideChanges

```ml
function _DNet_MPHostCollectSideChanges(maxCount, forceAll)
```

Collects changed sidedef textures so clients see switch/button state transitions.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `maxCount` | `dynamic` | — | Number of max to process. |
| `forceAll` | `dynamic` | — | Force all value supplied to `_DNet_MPHostCollectSideChanges`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/d_net.ml#L3158)

<a id="function-function-dnet-mphostensuresectorcache-function-dnet-mphostensuresectorcache-src-d-net-ml-713187302"></a>
### _DNet_MPHostEnsureSectorCache

```ml
function _DNet_MPHostEnsureSectorCache()
```

Initializes host-side sector cache used for delta snapshots.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/d_net.ml#L3003)

<a id="function-function-dnet-mphostensuresidecache-function-dnet-mphostensuresidecache-src-d-net-ml-1129331936"></a>
### _DNet_MPHostEnsureSideCache

```ml
function _DNet_MPHostEnsureSideCache()
```

Initializes host-side sidedef texture cache used for switch and wall texture replication.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/d_net.ml#L3119)

<a id="function-function-dnet-mphostfindactorindex-inline-function-dnet-mphostfindactorindex-nodekey-src-d-net-ml-228544860"></a>
### _DNet_MPHostFindActorIndex

```ml
inline function _DNet_MPHostFindActorIndex(nodeKey)
```

Locates host-side actor registry slot by stable actor key.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `nodeKey` | `dynamic` | — | Stable key identifying the network node. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/d_net.ml#L2438)

<a id="function-function-dnet-mphostfindactorindexbypose-function-dnet-mphostfindactorindexbypose-owner-src-d-net-ml-1181323827"></a>
### _DNet_MPHostFindActorIndexByPose

```ml
function _DNet_MPHostFindActorIndexByPose(owner)
```

Finds an existing host actor slot by tight type/pose match as fallback when thinker key is missing.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `owner` | `dynamic` | — | Owner value supplied to `_DNet_MPHostFindActorIndexByPose`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/d_net.ml#L2462)

<a id="function-function-dnet-mphostfindfreeactorslot-inline-function-dnet-mphostfindfreeactorslot-src-d-net-ml-1239942337"></a>
### _DNet_MPHostFindFreeActorSlot

```ml
inline function _DNet_MPHostFindFreeActorSlot()
```

Returns reusable host registry slot whose actor id was cleared.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/d_net.ml#L2450)

<a id="function-function-dnet-mphosthandlechatpacket-function-dnet-mphosthandlechatpacket-node-payload-src-d-net-ml-1341369538"></a>
### _DNet_MPHostHandleChatPacket

```ml
function _DNet_MPHostHandleChatPacket(node, payload)
```

Validates and relays one client chat packet as authoritative chat event.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `node` | `dynamic` | — | Node value supplied to `_DNet_MPHostHandleChatPacket`. |
| `payload` | `dynamic` | — | Payload value supplied to `_DNet_MPHostHandleChatPacket`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/d_net.ml#L2003)

<a id="function-function-dnet-mphosthandleinputpacket-function-dnet-mphosthandleinputpacket-node-payload-src-d-net-ml-1816039086"></a>
### _DNet_MPHostHandleInputPacket

```ml
function _DNet_MPHostHandleInputPacket(node, payload)
```

Applies one client input payload to host-side remote command cache.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `node` | `dynamic` | — | Node value supplied to `_DNet_MPHostHandleInputPacket`. |
| `payload` | `dynamic` | — | Payload value supplied to `_DNet_MPHostHandleInputPacket`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/d_net.ml#L4317)

<a id="function-function-dnet-mphosthandlenamepacket-function-dnet-mphosthandlenamepacket-node-payload-src-d-net-ml-1084001242"></a>
### _DNet_MPHostHandleNamePacket

```ml
function _DNet_MPHostHandleNamePacket(node, payload)
```

Authenticates a client rename by its transport slot, updates the peer table, and relays it.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `node` | `dynamic` | — | Node value supplied to `_DNet_MPHostHandleNamePacket`. |
| `payload` | `dynamic` | — | Payload value supplied to `_DNet_MPHostHandleNamePacket`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/d_net.ml#L2156)

<a id="function-function-dnet-mphosthandlewistatsrequest-inline-function-dnet-mphosthandlewistatsrequest-node-payload-src-d-net-ml-1317611309"></a>
### _DNet_MPHostHandleWIStatsRequest

```ml
inline function _DNet_MPHostHandleWIStatsRequest(node, payload)
```

Handles one client request for intermission stats retransmission.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `node` | `dynamic` | — | Node value supplied to `_DNet_MPHostHandleWIStatsRequest`. |
| `payload` | `dynamic` | — | Payload value supplied to `_DNet_MPHostHandleWIStatsRequest`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/d_net.ml#L1624)

<a id="function-function-dnet-mphostinvalidateactorsigbyid-inline-function-dnet-mphostinvalidateactorsigbyid-aid-src-d-net-ml-383408763"></a>
### _DNet_MPHostInvalidateActorSigById

```ml
inline function _DNet_MPHostInvalidateActorSigById(aid)
```

Forces one host actor id to be considered dirty for next snapshot selection.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `aid` | `dynamic` | — | Aid value supplied to `_DNet_MPHostInvalidateActorSigById`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/d_net.ml#L2822)

<a id="function-function-dnet-mphostislikelytelefrag-function-dnet-mphostislikelytelefrag-killer-victim-src-d-net-ml-499363637"></a>
### _DNet_MPHostIsLikelyTelefrag

```ml
function _DNet_MPHostIsLikelyTelefrag(killer, victim)
```

Detects teleport-stomp frags so feed can use telefrag wording.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `killer` | `dynamic` | — | Killer value supplied to `_DNet_MPHostIsLikelyTelefrag`. |
| `victim` | `dynamic` | — | Victim value supplied to `_DNet_MPHostIsLikelyTelefrag`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/d_net.ml#L2210)

<a id="function-function-dnet-mphostmarkslotfullsync-inline-function-dnet-mphostmarkslotfullsync-slot-src-d-net-ml-2075551653"></a>
### _DNet_MPHostMarkSlotFullsync

```ml
inline function _DNet_MPHostMarkSlotFullsync(slot)
```

Schedules an immediate full-snapshot burst for a newly active remote slot.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `slot` | `dynamic` | — | Slot value supplied to `_DNet_MPHostMarkSlotFullsync`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/d_net.ml#L3259)

<a id="function-function-dnet-mphostmaybesendphase-function-dnet-mphostmaybesendphase-force-src-d-net-ml-334833743"></a>
### _DNet_MPHostMaybeSendPhase

```ml
function _DNet_MPHostMaybeSendPhase(force)
```

Periodically sends host game phase packets to keep clients flow-synchronized.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `force` | `dynamic` | — | Force value supplied to `_DNet_MPHostMaybeSendPhase`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/d_net.ml#L2319)

<a id="function-function-dnet-mphostmaybesendsnapshot-function-dnet-mphostmaybesendsnapshot-forceall-src-d-net-ml-514344400"></a>
### _DNet_MPHostMaybeSendSnapshot

```ml
function _DNet_MPHostMaybeSendSnapshot(forceAll)
```

Sends periodic world snapshots from authoritative host to all clients.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `forceAll` | `dynamic` | — | Force all value supplied to `_DNet_MPHostMaybeSendSnapshot`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/d_net.ml#L5281)

<a id="function-function-dnet-mphostpopremovedids-function-dnet-mphostpopremovedids-maxcount-src-d-net-ml-417378493"></a>
### _DNet_MPHostPopRemovedIds

```ml
function _DNet_MPHostPopRemovedIds(maxCount)
```

Returns and removes removed actor ids for snapshot notification.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `maxCount` | `dynamic` | — | Number of max to process. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/d_net.ml#L2947)

<a id="function-function-dnet-mphostqueueremovedid-inline-function-dnet-mphostqueueremovedid-idv-src-d-net-ml-1197986382"></a>
### _DNet_MPHostQueueRemovedId

```ml
inline function _DNet_MPHostQueueRemovedId(idv)
```

Queues one removed actor id for multiple snapshots to tolerate UDP packet loss.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `idv` | `dynamic` | — | Idv value supplied to `_DNet_MPHostQueueRemovedId`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/d_net.ml#L2488)

<a id="function-function-dnet-mphostrefreshactorregistry-function-dnet-mphostrefreshactorregistry-src-d-net-ml-494029294"></a>
### _DNet_MPHostRefreshActorRegistry

```ml
function _DNet_MPHostRefreshActorRegistry()
```

Updates host-side actor registry and tracks removed actor ids.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/d_net.ml#L2511)

<a id="function-function-dnet-mphostrelaychat-function-dnet-mphostrelaychat-sender-dest-txt-src-d-net-ml-618409569"></a>
### _DNet_MPHostRelayChat

```ml
function _DNet_MPHostRelayChat(sender, dest, txt)
```

Displays and routes a validated chat line to its sender and optional private recipient.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `sender` | `dynamic` | — | Sender value supplied to `_DNet_MPHostRelayChat`. |
| `dest` | `dynamic` | — | Dest value supplied to `_DNet_MPHostRelayChat`. |
| `txt` | `dynamic` | — | Txt value supplied to `_DNet_MPHostRelayChat`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/d_net.ml#L1967)

<a id="function-function-dnet-mphostrequeuedroppedactorrows-function-dnet-mphostrequeuedroppedactorrows-actorids-startidx-src-d-net-ml-121309424"></a>
### _DNet_MPHostRequeueDroppedActorRows

```ml
function _DNet_MPHostRequeueDroppedActorRows(actorIds, startIdx)
```

Re-queues actor rows trimmed by packet budget so they are retried next snapshots.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `actorIds` | `dynamic` | — | Actor ids value supplied to `_DNet_MPHostRequeueDroppedActorRows`. |
| `startIdx` | `dynamic` | — | Start idx value supplied to `_DNet_MPHostRequeueDroppedActorRows`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/d_net.ml#L2840)

<a id="function-function-dnet-mphostselectactorsforslot-function-dnet-mphostselectactorsforslot-slot-actorids-actorrefs-maxcount-forceall-snapshottick-src-d-net-ml-1133359884"></a>
### _DNet_MPHostSelectActorsForSlot

```ml
function _DNet_MPHostSelectActorsForSlot(slot, actorIds, actorRefs, maxCount, forceAll, snapshotTick)
```

Prioritizes client-relevant actor updates over non-relevant updates for one target slot.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `slot` | `dynamic` | — | Slot value supplied to `_DNet_MPHostSelectActorsForSlot`. |
| `actorIds` | `dynamic` | — | Actor ids value supplied to `_DNet_MPHostSelectActorsForSlot`. |
| `actorRefs` | `dynamic` | — | Actor refs value supplied to `_DNet_MPHostSelectActorsForSlot`. |
| `maxCount` | `dynamic` | — | Number of max to process. |
| `forceAll` | `dynamic` | — | Force all value supplied to `_DNet_MPHostSelectActorsForSlot`. |
| `snapshotTick` | `dynamic` | — | Snapshot tick value supplied to `_DNet_MPHostSelectActorsForSlot`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/d_net.ml#L2860)

<a id="function-function-dnet-mphostsendwistatsto-inline-function-dnet-mphostsendwistatsto-slot-src-d-net-ml-1172046521"></a>
### _DNet_MPHostSendWIStatsTo

```ml
inline function _DNet_MPHostSendWIStatsTo(slot)
```

Sends a full intermission stats packet to one client slot.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `slot` | `dynamic` | — | Slot value supplied to `_DNet_MPHostSendWIStatsTo`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/d_net.ml#L1593)

<a id="function-function-dnet-mphostsnapshotinterval-inline-function-dnet-mphostsnapshotinterval-src-d-net-ml-1885979425"></a>
### _DNet_MPHostSnapshotInterval

```ml
inline function _DNet_MPHostSnapshotInterval()
```

Computes adaptive snapshot cadence based on active replicated actor load.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/d_net.ml#L5247)

<a id="function-function-dnet-mpintermissionnextmap-inline-function-dnet-mpintermissionnextmap-src-d-net-ml-165051741"></a>
### _DNet_MPIntermissionNextMap

```ml
inline function _DNet_MPIntermissionNextMap()
```

Resolves the next map number while host is in intermission.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/d_net.ml#L2286)

<a id="function-function-dnet-mpisauthoritative-inline-function-dnet-mpisauthoritative-src-d-net-ml-1120883385"></a>
### _DNet_MPIsAuthoritative

```ml
inline function _DNet_MPIsAuthoritative()
```

Returns true while host-authoritative multiplayer runtime is active.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/d_net.ml#L794)

<a id="function-function-dnet-mpisclient-inline-function-dnet-mpisclient-src-d-net-ml-985891305"></a>
### _DNet_MPIsClient

```ml
inline function _DNet_MPIsClient()
```

Returns true when multiplayer platform is currently connected as client.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/d_net.ml#L787)

<a id="function-function-dnet-mpishost-inline-function-dnet-mpishost-src-d-net-ml-76636219"></a>
### _DNet_MPIsHost

```ml
inline function _DNet_MPIsHost()
```

Returns true when multiplayer platform is currently hosting.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/d_net.ml#L780)

<a id="function-function-dnet-mplevelready-function-dnet-mplevelready-src-d-net-ml-1706688174"></a>
### _DNet_MPLevelReady

```ml
function _DNet_MPLevelReady()
```

Returns true when level state is initialized enough for authoritative snapshots.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/d_net.ml#L2393)

<a id="function-function-dnet-mpmakewbrowforslot-function-dnet-mpmakewbrowforslot-slot-src-d-net-ml-1649044330"></a>
### _DNet_MPMakeWBRowForSlot

```ml
function _DNet_MPMakeWBRowForSlot(slot)
```

Builds one intermission player row from current authoritative runtime player state.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `slot` | `dynamic` | — | Slot value supplied to `_DNet_MPMakeWBRowForSlot`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/d_net.ml#L1269)

<a id="constant-constant-dnet-mpmsg-chat-const-dnet-mpmsg-chat-7-src-d-net-ml-1128047488"></a>
### _DNET_MPMSG_CHAT

```ml
const _DNET_MPMSG_CHAT = 7
```

Defines dnet mpmsg chat for the d net subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/d_net.ml#L205)

<a id="constant-constant-dnet-mpmsg-feed-const-dnet-mpmsg-feed-4-src-d-net-ml-1517624723"></a>
### _DNET_MPMSG_FEED

```ml
const _DNET_MPMSG_FEED = 4
```

Defines dnet mpmsg feed for the d net subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/d_net.ml#L196)

<a id="constant-constant-dnet-mpmsg-input-const-dnet-mpmsg-input-1-src-d-net-ml-23777408"></a>
### _DNET_MPMSG_INPUT

```ml
const _DNET_MPMSG_INPUT = 1
```

Defines dnet mpmsg input for the d net subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/d_net.ml#L187)

<a id="constant-constant-dnet-mpmsg-name-const-dnet-mpmsg-name-8-src-d-net-ml-479205301"></a>
### _DNET_MPMSG_NAME

```ml
const _DNET_MPMSG_NAME = 8
```

Defines dnet mpmsg name for the d net subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/d_net.ml#L208)

<a id="constant-constant-dnet-mpmsg-phase-const-dnet-mpmsg-phase-3-src-d-net-ml-1680074918"></a>
### _DNET_MPMSG_PHASE

```ml
const _DNET_MPMSG_PHASE = 3
```

Defines dnet mpmsg phase for the d net subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/d_net.ml#L193)

<a id="constant-constant-dnet-mpmsg-snapshot-const-dnet-mpmsg-snapshot-2-src-d-net-ml-229628001"></a>
### _DNET_MPMSG_SNAPSHOT

```ml
const _DNET_MPMSG_SNAPSHOT = 2
```

Defines dnet mpmsg snapshot for the d net subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/d_net.ml#L190)

<a id="constant-constant-dnet-mpmsg-sound-const-dnet-mpmsg-sound-201-src-d-net-ml-1655318510"></a>
### _DNET_MPMSG_SOUND

```ml
const _DNET_MPMSG_SOUND = 201
```

Defines dnet mpmsg sound for the d net subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/d_net.ml#L211)

<a id="constant-constant-dnet-mpmsg-wistats-const-dnet-mpmsg-wistats-5-src-d-net-ml-2120381500"></a>
### _DNET_MPMSG_WISTATS

```ml
const _DNET_MPMSG_WISTATS = 5
```

Defines dnet mpmsg wistats for the d net subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/d_net.ml#L199)

<a id="constant-constant-dnet-mpmsg-wistats-req-const-dnet-mpmsg-wistats-req-6-src-d-net-ml-1391570835"></a>
### _DNET_MPMSG_WISTATS_REQ

```ml
const _DNET_MPMSG_WISTATS_REQ = 6
```

Defines dnet mpmsg wistats req for the d net subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/d_net.ml#L202)

<a id="function-function-dnet-mpnormalizechattext-function-dnet-mpnormalizechattext-msg-src-d-net-ml-2040249925"></a>
### _DNet_MPNormalizeChatText

```ml
function _DNet_MPNormalizeChatText(msg)
```

Normalizes chat text to printable ASCII and trims packet size.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `msg` | `dynamic` | — | Msg value supplied to `_DNet_MPNormalizeChatText`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/d_net.ml#L1842)

<a id="function-function-dnet-mpphasecode-inline-function-dnet-mpphasecode-src-d-net-ml-845364153"></a>
### _DNet_MPPhaseCode

```ml
inline function _DNet_MPPhaseCode()
```

Maps Doom gamestate to compact phase code used by phase sync packets.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/d_net.ml#L2277)

<a id="function-function-dnet-mpplayerhasanyownedweapon-inline-function-dnet-mpplayerhasanyownedweapon-p-src-d-net-ml-31687821"></a>
### _DNet_MPPlayerHasAnyOwnedWeapon

```ml
inline function _DNet_MPPlayerHasAnyOwnedWeapon(p)
```

Returns true if a player struct already carries any weapon ownership flag.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `p` | `dynamic` | — | Object or data record consumed by the operation. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/d_net.ml#L3245)

<a id="function-function-dnet-mpplayername-inline-function-dnet-mpplayername-slot-src-d-net-ml-1015615399"></a>
### _DNet_MPPlayerName

```ml
inline function _DNet_MPPlayerName(slot)
```

Resolves a readable player name for HUD/event messages.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `slot` | `dynamic` | — | Slot value supplied to `_DNet_MPPlayerName`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/d_net.ml#L1170)

<a id="function-function-dnet-mpreadfixedname-function-dnet-mpreadfixedname-payload-off-width-src-d-net-ml-451826231"></a>
### _DNet_MPReadFixedName

```ml
function _DNet_MPReadFixedName(payload, off, width)
```

Reads one fixed-width null-terminated ASCII player name field.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `payload` | `dynamic` | — | Payload value supplied to `_DNet_MPReadFixedName`. |
| `off` | `dynamic` | — | Zero-based byte or element offset. |
| `width` | `dynamic` | — | Width of the target in pixels or map units. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/d_net.ml#L1234)

<a id="function-function-dnet-mpreadi16-inline-function-dnet-mpreadi16-buf-off-src-d-net-ml-1839860647"></a>
### _DNet_MPReadI16

```ml
inline function _DNet_MPReadI16(buf, off)
```

Reads a 16-bit signed integer from byte buffer.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `buf` | `dynamic` | — | Buf value supplied to `_DNet_MPReadI16`. |
| `off` | `dynamic` | — | Zero-based byte or element offset. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/d_net.ml#L868)

<a id="function-function-dnet-mpreadi32-inline-function-dnet-mpreadi32-buf-off-src-d-net-ml-32614367"></a>
### _DNet_MPReadI32

```ml
inline function _DNet_MPReadI32(buf, off)
```

Reads a 32-bit signed integer from byte buffer.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `buf` | `dynamic` | — | Buf value supplied to `_DNet_MPReadI32`. |
| `off` | `dynamic` | — | Zero-based byte or element offset. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/d_net.ml#L892)

<a id="function-function-dnet-mpreadnamepacket-function-dnet-mpreadnamepacket-payload-src-d-net-ml-324417506"></a>
### _DNet_MPReadNamePacket

```ml
function _DNet_MPReadNamePacket(payload)
```

Validates a name packet's declared length and returns its canonical player name.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `payload` | `dynamic` | — | Payload value supplied to `_DNet_MPReadNamePacket`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/d_net.ml#L2086)

<a id="function-function-dnet-mpreadu16-inline-function-dnet-mpreadu16-buf-off-src-d-net-ml-716767983"></a>
### _DNet_MPReadU16

```ml
inline function _DNet_MPReadU16(buf, off)
```

Reads a 16-bit unsigned integer from byte buffer.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `buf` | `dynamic` | — | Buf value supplied to `_DNet_MPReadU16`. |
| `off` | `dynamic` | — | Zero-based byte or element offset. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/d_net.ml#L858)

<a id="function-function-dnet-mpreadu32-inline-function-dnet-mpreadu32-buf-off-src-d-net-ml-1974594903"></a>
### _DNet_MPReadU32

```ml
inline function _DNet_MPReadU32(buf, off)
```

Reads a 32-bit unsigned integer from byte buffer.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `buf` | `dynamic` | — | Buf value supplied to `_DNet_MPReadU32`. |
| `off` | `dynamic` | — | Zero-based byte or element offset. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/d_net.ml#L878)

<a id="function-function-dnet-mpresetruntime-function-dnet-mpresetruntime-src-d-net-ml-363594122"></a>
### _DNet_MPResetRuntime

```ml
function _DNet_MPResetRuntime()
```

Clears host/client authoritative replication caches.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/d_net.ml#L919)

<a id="function-function-dnet-mpreturntooffline-function-dnet-mpreturntooffline-wasclient-src-d-net-ml-1990907642"></a>
### _DNet_MPReturnToOffline

```ml
function _DNet_MPReturnToOffline(wasClient)
```

Collapses stale multiplayer clocks/slots after transport loss and returns to a defined title state.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `wasClient` | `dynamic` | — | Was client value supplied to `_DNet_MPReturnToOffline`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/d_net.ml#L1643)

<a id="function-function-dnet-mpsendinputcmd-function-dnet-mpsendinputcmd-cmd-src-d-net-ml-552648740"></a>
### _DNet_MPSendInputCmd

```ml
function _DNet_MPSendInputCmd(cmd)
```

Sends one client input command to authoritative host.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `cmd` | `dynamic` | — | Cmd value supplied to `_DNet_MPSendInputCmd`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/d_net.ml#L4260)

<a id="function-function-dnet-mpsendwistatsrequest-inline-function-dnet-mpsendwistatsrequest-src-d-net-ml-1785454439"></a>
### _DNet_MPSendWIStatsRequest

```ml
inline function _DNet_MPSendWIStatsRequest()
```

Sends one client-side intermission stats request to the host.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/d_net.ml#L1663)

<a id="function-function-dnet-mpseqisnewer-inline-function-dnet-mpseqisnewer-a-b-src-d-net-ml-480064680"></a>
### _DNet_MPSeqIsNewer

```ml
inline function _DNet_MPSeqIsNewer(a, b)
```

Returns true when input sequence a is newer than b (uint32 wrap-around aware).

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `a` | `dynamic` | — | First input operand. |
| `b` | `dynamic` | — | Second input operand. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/d_net.ml#L906)

<a id="function-function-dnet-mpsetplayerslotactive-function-dnet-mpsetplayerslotactive-slot-active-src-d-net-ml-1778747358"></a>
### _DNet_MPSetPlayerSlotActive

```ml
function _DNet_MPSetPlayerSlotActive(slot, active)
```

Toggles slot active state and removes stale mobjs on deactivate.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `slot` | `dynamic` | — | Slot value supplied to `_DNet_MPSetPlayerSlotActive`. |
| `active` | `dynamic` | — | Whether the requested state should be active. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/d_net.ml#L3273)

<a id="function-function-dnet-mpsign32-inline-function-dnet-mpsign32-v-src-d-net-ml-1998853025"></a>
### _DNet_MPSign32

```ml
inline function _DNet_MPSign32(v)
```

Returns sign of integer value (-1, 0, +1).

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `v` | `dynamic` | — | Value consumed by the operation. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/d_net.ml#L3355)

<a id="function-function-dnet-mpslotactive-inline-function-dnet-mpslotactive-active-slot-src-d-net-ml-1962931165"></a>
### _DNet_MPSlotActive

```ml
inline function _DNet_MPSlotActive(active, slot)
```

Checks if slot is present in active slot list.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `active` | `dynamic` | — | Whether the requested state should be active. |
| `slot` | `dynamic` | — | Slot value supplied to `_DNet_MPSlotActive`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/d_net.ml#L1157)

<a id="function-function-dnet-mpstatekeyequals-inline-function-dnet-mpstatekeyequals-a-b-src-d-net-ml-1487521922"></a>
### _DNet_MPStateKeyEquals

```ml
inline function _DNet_MPStateKeyEquals(a, b)
```

Compares two compact snapshot keys for player/actor delta detection.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `a` | `dynamic` | — | First input operand. |
| `b` | `dynamic` | — | Second input operand. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/d_net.ml#L3966)

<a id="function-function-dnet-mpstaticactorheartbeathit-inline-function-dnet-mpstaticactorheartbeathit-idv-snapshottick-src-d-net-ml-1913851425"></a>
### _DNet_MPStaticActorHeartbeatHit

```ml
inline function _DNet_MPStaticActorHeartbeatHit(idv, snapshotTick)
```

Spreads static actor heartbeat replication across full snapshots.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `idv` | `dynamic` | — | Idv value supplied to `_DNet_MPStaticActorHeartbeatHit`. |
| `snapshotTick` | `dynamic` | — | Snapshot tick value supplied to `_DNet_MPStaticActorHeartbeatHit`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/d_net.ml#L3952)

<a id="function-function-dnet-mpthinkerismobj-inline-function-dnet-mpthinkerismobj-node-src-d-net-ml-999486565"></a>
### _DNet_MPThinkerIsMobj

```ml
inline function _DNet_MPThinkerIsMobj(node)
```

Returns true when thinker node is a mobj thinker callback.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `node` | `dynamic` | — | Node value supplied to `_DNet_MPThinkerIsMobj`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/d_net.ml#L2427)

<a id="function-function-dnet-mpu32-inline-function-dnet-mpu32-v-src-d-net-ml-623133935"></a>
### _DNet_MPU32

```ml
inline function _DNet_MPU32(v)
```

Normalizes signed int values into unsigned 32-bit angle space.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `v` | `dynamic` | — | Value consumed by the operation. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/d_net.ml#L3855)

<a id="function-function-dnet-mpwbrowchanged-inline-function-dnet-mpwbrowchanged-a-b-src-d-net-ml-1851651394"></a>
### _DNet_MPWBRowChanged

```ml
inline function _DNet_MPWBRowChanged(a, b)
```

Compares one intermission row for gameplay-relevant stat changes.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `a` | `dynamic` | — | First input operand. |
| `b` | `dynamic` | — | Second input operand. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/d_net.ml#L1436)

<a id="function-function-dnet-mpwbstatschanged-inline-function-dnet-mpwbstatschanged-oldwb-newwb-src-d-net-ml-2001596236"></a>
### _DNet_MPWBStatsChanged

```ml
inline function _DNet_MPWBStatsChanged(oldwb, newwb)
```

Detects whether a newer WI stats packet requires intermission state refresh.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `oldwb` | `dynamic` | — | Oldwb value supplied to `_DNet_MPWBStatsChanged`. |
| `newwb` | `dynamic` | — | Newwb value supplied to `_DNet_MPWBStatsChanged`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/d_net.ml#L1472)

<a id="function-function-dnet-mpwritefixedname-function-dnet-mpwritefixedname-payload-off-width-name-src-d-net-ml-1735799266"></a>
### _DNet_MPWriteFixedName

```ml
function _DNet_MPWriteFixedName(payload, off, width, name)
```

Writes one fixed-width null-terminated ASCII player name field.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `payload` | `dynamic` | — | Payload value supplied to `_DNet_MPWriteFixedName`. |
| `off` | `dynamic` | — | Zero-based byte or element offset. |
| `width` | `dynamic` | — | Width of the target in pixels or map units. |
| `name` | `dynamic` | — | Resource or object name to resolve. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/d_net.ml#L1201)

<a id="function-function-dnet-mpwritei16-inline-function-dnet-mpwritei16-buf-off-v-src-d-net-ml-383399033"></a>
### _DNet_MPWriteI16

```ml
inline function _DNet_MPWriteI16(buf, off, v)
```

Writes a 16-bit signed integer into byte buffer.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `buf` | `dynamic` | — | Buf value supplied to `_DNet_MPWriteI16`. |
| `off` | `dynamic` | — | Zero-based byte or element offset. |
| `v` | `dynamic` | — | Value consumed by the operation. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/d_net.ml#L818)

<a id="function-function-dnet-mpwritei32-inline-function-dnet-mpwritei32-buf-off-v-src-d-net-ml-1422226517"></a>
### _DNet_MPWriteI32

```ml
inline function _DNet_MPWriteI32(buf, off, v)
```

Writes a 32-bit signed integer into byte buffer.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `buf` | `dynamic` | — | Buf value supplied to `_DNet_MPWriteI32`. |
| `off` | `dynamic` | — | Zero-based byte or element offset. |
| `v` | `dynamic` | — | Value consumed by the operation. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/d_net.ml#L850)

<a id="function-function-dnet-mpwriteu16-inline-function-dnet-mpwriteu16-buf-off-v-src-d-net-ml-581765625"></a>
### _DNet_MPWriteU16

```ml
inline function _DNet_MPWriteU16(buf, off, v)
```

Writes a 16-bit unsigned integer into byte buffer.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `buf` | `dynamic` | — | Buf value supplied to `_DNet_MPWriteU16`. |
| `off` | `dynamic` | — | Zero-based byte or element offset. |
| `v` | `dynamic` | — | Value consumed by the operation. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/d_net.ml#L803)

<a id="function-function-dnet-mpwriteu32-inline-function-dnet-mpwriteu32-buf-off-v-src-d-net-ml-2118689101"></a>
### _DNet_MPWriteU32

```ml
inline function _DNet_MPWriteU32(buf, off, v)
```

Writes a 32-bit unsigned integer into byte buffer.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `buf` | `dynamic` | — | Buf value supplied to `_DNet_MPWriteU32`. |
| `off` | `dynamic` | — | Zero-based byte or element offset. |
| `v` | `dynamic` | — | Value consumed by the operation. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/d_net.ml#L834)

<a id="global-global-dnet-oldentertics-dnet-oldentertics-src-d-net-ml-603831166"></a>
### _dnet_oldentertics

```ml
_dnet_oldentertics
```

Tracks the mutable dnet oldentertics value used by the d net subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/d_net.ml#L172)

<a id="global-global-dnet-oldnettics-dnet-oldnettics-src-d-net-ml-2064998632"></a>
### _dnet_oldnettics

```ml
_dnet_oldnettics
```

Tracks the mutable dnet oldnettics value used by the d net subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/d_net.ml#L175)

<a id="function-function-dnet-rungametics-function-dnet-rungametics-counts-src-d-net-ml-98592648"></a>
### _DNet_RunGameTics

```ml
function _DNet_RunGameTics(counts)
```

Runs a bounded number of host/legacy simulation tics and emits host snapshots after each authoritative tic.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `counts` | `dynamic` | — | Counts value supplied to `_DNet_RunGameTics`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/d_net.ml#L6783)

<a id="function-function-dnet-stateindex-function-dnet-stateindex-s-src-d-net-ml-525156693"></a>
### _DNet_StateIndex

```ml
function _DNet_StateIndex(s)
```

Resolves a runtime state value to its authoritative state index for snapshot serialization.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `s` | `dynamic` | — | S value supplied to `_DNet_StateIndex`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/d_net.ml#L691)

<a id="function-function-dnet-toint-inline-function-dnet-toint-v-fallback-src-d-net-ml-1163889037"></a>
### _DNet_ToInt

```ml
inline function _DNet_ToInt(v, fallback)
```

Converts source to int values for the network game.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `v` | `dynamic` | — | Value consumed by the operation. |
| `fallback` | `dynamic` | — | Value returned when the requested conversion or lookup is unavailable. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/d_net.ml#L638)

<a id="function-function-dnet-tryrunticsuncapped-function-dnet-tryrunticsuncapped-src-d-net-ml-767296054"></a>
### _DNet_TryRunTicsUncapped

```ml
function _DNet_TryRunTicsUncapped()
```

Drains every locally available tic for uncapped single-player rendering while preserving network clocks.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/d_net.ml#L6825)

<a id="constant-constant-backuptics-const-backuptics-12-src-d-net-ml-113105302"></a>
### BACKUPTICS

```ml
const BACKUPTICS = 12
```

Defines backuptics for the d net subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/d_net.ml#L43)

<a id="function-function-checkabort-function-checkabort-src-d-net-ml-1671598574"></a>
### CheckAbort

```ml
function CheckAbort()
```

Pumps input during net-start waits and aborts synchronization when Escape is pressed.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/d_net.ml#L7243)

- [command_t](Type-command-t-221193433.md) — enum
<a id="function-function-d-arbitratenetstart-function-d-arbitratenetstart-src-d-net-ml-909778042"></a>
### D_ArbitrateNetStart

```ml
function D_ArbitrateNetStart()
```

Exchanges legacy startup settings so every node begins with the console node's map and rules.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/d_net.ml#L7263)

<a id="function-function-d-checknetgame-function-d-checknetgame-src-d-net-ml-855586970"></a>
### D_CheckNetGame

```ml
function D_CheckNetGame()
```

Resets legacy/authoritative network clocks and initializes the platform network driver once.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/d_net.ml#L6440)

<a id="function-function-d-netinitsingleplayer-function-d-netinitsingleplayer-src-d-net-ml-227000536"></a>
### D_NetInitSinglePlayer

```ml
function D_NetInitSinglePlayer()
```

Rebuilds Doom networking, slot ownership, and tic queues as one local player after startup or transport loss.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/d_net.ml#L6351)

<a id="function-function-d-netmpdebugoverlaytext-function-d-netmpdebugoverlaytext-src-d-net-ml-1616574152"></a>
### D_NetMPDebugOverlayText

```ml
function D_NetMPDebugOverlayText()
```

Returns authoritative d_net snapshot diagnostics for on-screen overlay.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/d_net.ml#L1117)

<a id="function-function-d-netmpsendchat-function-d-netmpsendchat-dest-msg-src-d-net-ml-2093206039"></a>
### D_NetMPSendChat

```ml
function D_NetMPSendChat(dest, msg)
```

Sends local HUD chat through the authoritative packet channel, preserving private destinations.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `dest` | `dynamic` | — | Dest value supplied to `D_NetMPSendChat`. |
| `msg` | `dynamic` | — | Msg value supplied to `D_NetMPSendChat`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/d_net.ml#L2041)

<a id="function-function-d-netmpsetplayername-function-d-netmpsetplayername-name-src-d-net-ml-974223481"></a>
### D_NetMPSetPlayerName

```ml
function D_NetMPSetPlayerName(name)
```

Changes the local persistent name and propagates it through an active authoritative session.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `name` | `dynamic` | — | Resource or object name to resolve. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/d_net.ml#L2179)

<a id="function-function-d-quitnetgame-function-d-quitnetgame-src-d-net-ml-1253157380"></a>
### D_QuitNetGame

```ml
function D_QuitNetGame()
```

Repeats a legacy exit notification to every active remote node before local shutdown.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/d_net.ml#L6501)

<a id="global-global-d-runtics-last-d-runtics-last-src-d-net-ml-134728296"></a>
### d_runtics_last

```ml
d_runtics_last
```

Tracks the mutable d runtics last value used by the d net subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/d_net.ml#L183)

<a id="global-global-doomcom-doomcom-src-d-net-ml-387728120"></a>
### doomcom

```ml
doomcom
```

Holds the optional doomcom resource used by the d net subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/d_net.ml#L128)

<a id="constant-constant-doomcom-id-const-doomcom-id-305419896-src-d-net-ml-1933052390"></a>
### DOOMCOM_ID

```ml
const DOOMCOM_ID = 305419896
```

Defines doomcom id for the d net subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/d_net.ml#L39)

- [doomcom_t](Type-doomcom-t-149431842.md) — struct
- [doomdata_t](Type-doomdata-t-1737044743.md) — struct
<a id="function-function-expandtics-function-expandtics-low-src-d-net-ml-1718593482"></a>
### ExpandTics

```ml
function ExpandTics(low)
```

Expands an 8-bit wire tic into the closest plausible absolute game tic.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `low` | `dynamic` | — | Low value supplied to `ExpandTics`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/d_net.ml#L7099)

<a id="global-global-gametime-gametime-src-d-net-ml-1316108898"></a>
### gametime

```ml
gametime
```

Tracks the mutable gametime value used by the d net subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/d_net.ml#L160)

<a id="function-function-getpackets-function-getpackets-src-d-net-ml-1826830354"></a>
### GetPackets

```ml
function GetPackets()
```

Drains validated legacy packets, updates resend windows, and copies new remote commands into rings.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/d_net.ml#L7167)

<a id="function-function-hgetpacket-function-hgetpacket-src-d-net-ml-1704939230"></a>
### HGetPacket

```ml
function HGetPacket()
```

Receives one legacy packet, verifies checksum/length, and exposes its source node.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/d_net.ml#L7142)

<a id="function-function-hsendpacket-function-hsendpacket-node-flags-src-d-net-ml-1590865323"></a>
### HSendPacket

```ml
function HSendPacket(node, flags)
```

Controls hSend Packet transitions in the network game system.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `node` | `dynamic` | — | Node value supplied to `HSendPacket`. |
| `flags` | `dynamic` | — | Bit flags that control the operation. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/d_net.ml#L7118)

<a id="global-global-lastnettic-lastnettic-src-d-net-ml-73602114"></a>
### lastnettic

```ml
lastnettic
```

Tracks the mutable lastnettic value used by the d net subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/d_net.ml#L152)

<a id="global-global-localcmds-localcmds-src-d-net-ml-75236416"></a>
### localcmds

```ml
localcmds
```

Stores the localcmds collection used by the d net subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/d_net.ml#L133)

<a id="global-global-maketic-maketic-src-d-net-ml-2129053280"></a>
### maketic

```ml
maketic
```

Tracks the mutable maketic value used by the d net subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/d_net.ml#L150)

<a id="constant-constant-maxnetnodes-const-maxnetnodes-8-src-d-net-ml-1241586941"></a>
### MAXNETNODES

```ml
const MAXNETNODES = 8
```

Defines the maximum maxnetnodes accepted by the d net subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/d_net.ml#L41)

<a id="global-global-maxsend-maxsend-src-d-net-ml-1079897880"></a>
### maxsend

```ml
maxsend
```

Tracks the mutable maxsend value used by the d net subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/d_net.ml#L158)

<a id="constant-constant-ncmd-checksum-const-ncmd-checksum-268435455-src-d-net-ml-767145643"></a>
### NCMD_CHECKSUM

```ml
const NCMD_CHECKSUM = 268435455
```

Defines ncmd checksum for the d net subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/d_net.ml#L58)

<a id="constant-constant-ncmd-exit-const-ncmd-exit-2147483648-src-d-net-ml-734468228"></a>
### NCMD_EXIT

```ml
const NCMD_EXIT = 2147483648
```

Defines ncmd exit for the d net subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/d_net.ml#L50)

<a id="constant-constant-ncmd-kill-const-ncmd-kill-268435456-src-d-net-ml-764136356"></a>
### NCMD_KILL

```ml
const NCMD_KILL = 268435456
```

Defines ncmd kill for the d net subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/d_net.ml#L56)

<a id="constant-constant-ncmd-retransmit-const-ncmd-retransmit-1073741824-src-d-net-ml-895787082"></a>
### NCMD_RETRANSMIT

```ml
const NCMD_RETRANSMIT = 1073741824
```

Defines ncmd retransmit for the d net subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/d_net.ml#L52)

<a id="constant-constant-ncmd-setup-const-ncmd-setup-536870912-src-d-net-ml-537869166"></a>
### NCMD_SETUP

```ml
const NCMD_SETUP = 536870912
```

Defines ncmd setup for the d net subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/d_net.ml#L54)

<a id="global-global-netbuffer-netbuffer-src-d-net-ml-1098840244"></a>
### netbuffer

```ml
netbuffer
```

Holds the optional netbuffer resource used by the d net subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/d_net.ml#L130)

<a id="function-function-netbufferchecksum-function-netbufferchecksum-src-d-net-ml-1545828834"></a>
### NetbufferChecksum

```ml
function NetbufferChecksum()
```

Computes the legacy Doom packet checksum over header fields and the transmitted ticcmd rows.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/d_net.ml#L7071)

<a id="function-function-netbuffersize-inline-function-netbuffersize-src-d-net-ml-205698133"></a>
### NetbufferSize

```ml
inline function NetbufferSize()
```

Computes the encoded byte count for the current bounded legacy packet.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/d_net.ml#L7061)

<a id="global-global-netcmds-netcmds-src-d-net-ml-121142800"></a>
### netcmds

```ml
netcmds
```

Stores the netcmds collection used by the d net subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/d_net.ml#L135)

<a id="global-global-nettics-nettics-src-d-net-ml-1082149968"></a>
### nettics

```ml
nettics
```

Stores the nettics collection used by the d net subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/d_net.ml#L137)

<a id="function-function-netupdate-function-netupdate-src-d-net-ml-79656906"></a>
### NetUpdate

```ml
function NetUpdate()
```

Pumps authoritative packets, samples local input, and fills per-player ticcmd rings without simulating clients.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/d_net.ml#L6530)

<a id="global-global-nodeforplayer-nodeforplayer-src-d-net-ml-1599407520"></a>
### nodeforplayer

```ml
nodeforplayer
```

Stores the nodeforplayer collection used by the d net subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/d_net.ml#L147)

<a id="global-global-nodeingame-nodeingame-src-d-net-ml-817696458"></a>
### nodeingame

```ml
nodeingame
```

Stores the nodeingame collection used by the d net subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/d_net.ml#L139)

<a id="constant-constant-pl-drone-const-pl-drone-128-src-d-net-ml-587262082"></a>
### PL_DRONE

```ml
const PL_DRONE = 128
```

Defines pl drone for the d net subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/d_net.ml#L47)

<a id="global-global-reboundpacket-reboundpacket-src-d-net-ml-988088248"></a>
### reboundpacket

```ml
reboundpacket
```

Tracks whether reboundpacket is active in the d net subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/d_net.ml#L163)

<a id="global-global-reboundstore-reboundstore-src-d-net-ml-1587346696"></a>
### reboundstore

```ml
reboundstore
```

Holds the optional reboundstore resource used by the d net subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/d_net.ml#L165)

<a id="global-global-remoteresend-remoteresend-src-d-net-ml-1642680450"></a>
### remoteresend

```ml
remoteresend
```

Stores the remoteresend collection used by the d net subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/d_net.ml#L141)

<a id="constant-constant-resendcount-const-resendcount-10-src-d-net-ml-135017768"></a>
### RESENDCOUNT

```ml
const RESENDCOUNT = 10
```

Defines resendcount for the d net subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/d_net.ml#L45)

<a id="global-global-resendcount-resendcount-src-d-net-ml-954074544"></a>
### resendcount

```ml
resendcount
```

Stores the resendcount collection used by the d net subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/d_net.ml#L145)

<a id="global-global-resendto-resendto-src-d-net-ml-451085264"></a>
### resendto

```ml
resendto
```

Stores the resendto collection used by the d net subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/d_net.ml#L143)

<a id="global-global-skiptics-skiptics-src-d-net-ml-181699400"></a>
### skiptics

```ml
skiptics
```

Tracks the mutable skiptics value used by the d net subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/d_net.ml#L154)

<a id="global-global-ticdup-ticdup-src-d-net-ml-1632703214"></a>
### ticdup

```ml
ticdup
```

Tracks the mutable ticdup value used by the d net subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/d_net.ml#L156)

<a id="function-function-tryruntics-function-tryruntics-src-d-net-ml-863008846"></a>
### TryRunTics

```ml
function TryRunTics()
```

Schedules host/legacy simulation or client-only UI/interpolation ticks from wall-clock and network availability.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/d_net.ml#L6866)
