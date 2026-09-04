# `src/mp_platform.ml`

[Home](README.md) · [Files](Files.md)

Implements UDP multiplayer host/join handshake and runtime packet pump.

Package: [`(global)`](Package-global-1952375359.md)

Reachable from entry: **yes**

## Imports

- `doomstat.ml` → [src/doomstat.ml](File-src-doomstat-ml-1652708088.md)
- `mp_state.ml` → [src/mp_state.ml](File-src-mp-state-ml-130741680.md)
- `std/fs.ml` as `fs` → `../MiniLangCompilerOptimization/MiniLangCompilerPy/std/fs.ml` — external dependency
- `std/math.ml` → `../MiniLangCompilerOptimization/MiniLangCompilerPy/std/math.ml` — external dependency
- `std/net.ml` as `net` → `../MiniLangCompilerOptimization/MiniLangCompilerPy/std/net.ml` — external dependency
- `std/string.ml` as `str` → `../MiniLangCompilerOptimization/MiniLangCompilerPy/std/string.ml` — external dependency
- `std/time.ml` as `time` → `../MiniLangCompilerOptimization/MiniLangCompilerPy/std/time.ml` — external dependency

## Declarations

<a id="global-global-mp-client-game-in-mp-client-game-in-src-mp-platform-ml-619642125"></a>
### _mp_client_game_in

```ml
_mp_client_game_in
```

Tracks the mutable mp client game in value used by the mp platform subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/mp_platform.ml#L300)

<a id="global-global-mp-client-game-out-mp-client-game-out-src-mp-platform-ml-37633603"></a>
### _mp_client_game_out

```ml
_mp_client_game_out
```

Tracks the mutable mp client game out value used by the mp platform subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/mp_platform.ml#L303)

<a id="global-global-mp-client-host-mp-client-host-src-mp-platform-ml-655360831"></a>
### _mp_client_host

```ml
_mp_client_host
```

Stores the mutable mp client host text used by the mp platform subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/mp_platform.ml#L261)

<a id="global-global-mp-client-host-name-mp-client-host-name-src-mp-platform-ml-2024030653"></a>
### _mp_client_host_name

```ml
_mp_client_host_name
```

Stores the mutable mp client host name text used by the mp platform subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/mp_platform.ml#L264)

<a id="global-global-mp-client-last-ping-ms-mp-client-last-ping-ms-src-mp-platform-ml-1049212663"></a>
### _mp_client_last_ping_ms

```ml
_mp_client_last_ping_ms
```

Tracks the mutable mp client last ping ms value used by the mp platform subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/mp_platform.ml#L276)

<a id="global-global-mp-client-last-ping-tx-ms-mp-client-last-ping-tx-ms-src-mp-platform-ml-1071914139"></a>
### _mp_client_last_ping_tx_ms

```ml
_mp_client_last_ping_tx_ms
```

Tracks the mutable mp client last ping tx ms value used by the mp platform subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/mp_platform.ml#L282)

<a id="global-global-mp-client-last-pong-ms-mp-client-last-pong-ms-src-mp-platform-ml-740485115"></a>
### _mp_client_last_pong_ms

```ml
_mp_client_last_pong_ms
```

Tracks the mutable mp client last pong ms value used by the mp platform subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/mp_platform.ml#L285)

<a id="global-global-mp-client-last-seen-ms-mp-client-last-seen-ms-src-mp-platform-ml-743342567"></a>
### _mp_client_last_seen_ms

```ml
_mp_client_last_seen_ms
```

Tracks the mutable mp client last seen ms value used by the mp platform subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/mp_platform.ml#L288)

<a id="global-global-mp-client-peer-id-mp-client-peer-id-src-mp-platform-ml-848105353"></a>
### _mp_client_peer_id

```ml
_mp_client_peer_id
```

Tracks the mutable mp client peer id value used by the mp platform subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/mp_platform.ml#L270)

<a id="global-global-mp-client-ping-sent-mp-client-ping-sent-src-mp-platform-ml-690446867"></a>
### _mp_client_ping_sent

```ml
_mp_client_ping_sent
```

Tracks the mutable mp client ping sent value used by the mp platform subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/mp_platform.ml#L294)

<a id="global-global-mp-client-ping-seq-mp-client-ping-seq-src-mp-platform-ml-668988851"></a>
### _mp_client_ping_seq

```ml
_mp_client_ping_seq
```

Tracks the mutable mp client ping seq value used by the mp platform subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/mp_platform.ml#L279)

<a id="global-global-mp-client-pong-recv-mp-client-pong-recv-src-mp-platform-ml-2004699443"></a>
### _mp_client_pong_recv

```ml
_mp_client_pong_recv
```

Tracks the mutable mp client pong recv value used by the mp platform subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/mp_platform.ml#L297)

<a id="global-global-mp-client-port-mp-client-port-src-mp-platform-ml-768615071"></a>
### _mp_client_port

```ml
_mp_client_port
```

Tracks the mutable mp client port value used by the mp platform subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/mp_platform.ml#L267)

<a id="global-global-mp-client-rtt-ms-mp-client-rtt-ms-src-mp-platform-ml-14022675"></a>
### _mp_client_rtt_ms

```ml
_mp_client_rtt_ms
```

Tracks the mutable mp client rtt ms value used by the mp platform subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/mp_platform.ml#L291)

<a id="global-global-mp-client-slot-mp-client-slot-src-mp-platform-ml-254939219"></a>
### _mp_client_slot

```ml
_mp_client_slot
```

Tracks the mutable mp client slot value used by the mp platform subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/mp_platform.ml#L273)

<a id="global-global-mp-client-slot-names-mp-client-slot-names-src-mp-platform-ml-1910015707"></a>
### _mp_client_slot_names

```ml
_mp_client_slot_names
```

Stores the mp client slot names collection used by the mp platform subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/mp_platform.ml#L306)

<a id="global-global-mp-debug-send-attempt-mp-debug-send-attempt-src-mp-platform-ml-1389086829"></a>
### _mp_debug_send_attempt

```ml
_mp_debug_send_attempt
```

Tracks the mutable mp debug send attempt value used by the mp platform subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/mp_platform.ml#L309)

<a id="global-global-mp-debug-send-err-mp-debug-send-err-src-mp-platform-ml-797873921"></a>
### _mp_debug_send_err

```ml
_mp_debug_send_err
```

Tracks the mutable mp debug send err value used by the mp platform subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/mp_platform.ml#L318)

<a id="global-global-mp-debug-send-idxfail-mp-debug-send-idxfail-src-mp-platform-ml-1166164109"></a>
### _mp_debug_send_idxfail

```ml
_mp_debug_send_idxfail
```

Tracks the mutable mp debug send idxfail value used by the mp platform subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/mp_platform.ml#L315)

<a id="global-global-mp-debug-send-ok-mp-debug-send-ok-src-mp-platform-ml-675397027"></a>
### _mp_debug_send_ok

```ml
_mp_debug_send_ok
```

Tracks the mutable mp debug send ok value used by the mp platform subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/mp_platform.ml#L312)

<a id="global-global-mp-game-queue-dropped-mp-game-queue-dropped-src-mp-platform-ml-1289916291"></a>
### _mp_game_queue_dropped

```ml
_mp_game_queue_dropped
```

Tracks the mutable mp game queue dropped value used by the mp platform subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/mp_platform.ml#L333)

<a id="global-global-mp-game-queue-head-mp-game-queue-head-src-mp-platform-ml-616518387"></a>
### _mp_game_queue_head

```ml
_mp_game_queue_head
```

Tracks the mutable mp game queue head value used by the mp platform subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/mp_platform.ml#L327)

<a id="global-global-mp-game-queue-nodes-mp-game-queue-nodes-src-mp-platform-ml-1109996009"></a>
### _mp_game_queue_nodes

```ml
_mp_game_queue_nodes
```

Stores the mp game queue nodes collection used by the mp platform subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/mp_platform.ml#L321)

<a id="global-global-mp-game-queue-payloads-mp-game-queue-payloads-src-mp-platform-ml-1823559359"></a>
### _mp_game_queue_payloads

```ml
_mp_game_queue_payloads
```

Stores the mp game queue payloads collection used by the mp platform subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/mp_platform.ml#L324)

<a id="global-global-mp-game-queue-tail-mp-game-queue-tail-src-mp-platform-ml-1204709987"></a>
### _mp_game_queue_tail

```ml
_mp_game_queue_tail
```

Tracks the mutable mp game queue tail value used by the mp platform subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/mp_platform.ml#L330)

<a id="global-global-mp-host-frag-limit-cfg-mp-host-frag-limit-cfg-src-mp-platform-ml-1031902935"></a>
### _mp_host_frag_limit_cfg

```ml
_mp_host_frag_limit_cfg
```

Tracks the mutable mp host frag limit cfg value used by the mp platform subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/mp_platform.ml#L248)

<a id="global-global-mp-host-map-cfg-mp-host-map-cfg-src-mp-platform-ml-571828213"></a>
### _mp_host_map_cfg

```ml
_mp_host_map_cfg
```

Stores the mutable mp host map cfg text used by the mp platform subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/mp_platform.ml#L239)

<a id="global-global-mp-host-max-players-cfg-mp-host-max-players-cfg-src-mp-platform-ml-1878100659"></a>
### _mp_host_max_players_cfg

```ml
_mp_host_max_players_cfg
```

Tracks the mutable mp host max players cfg value used by the mp platform subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/mp_platform.ml#L245)

<a id="global-global-mp-host-mode-cfg-mp-host-mode-cfg-src-mp-platform-ml-87821731"></a>
### _mp_host_mode_cfg

```ml
_mp_host_mode_cfg
```

Tracks the mutable mp host mode cfg value used by the mp platform subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/mp_platform.ml#L236)

<a id="global-global-mp-host-next-peer-id-mp-host-next-peer-id-src-mp-platform-ml-597917795"></a>
### _mp_host_next_peer_id

```ml
_mp_host_next_peer_id
```

Tracks the mutable mp host next peer id value used by the mp platform subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/mp_platform.ml#L254)

<a id="global-global-mp-host-peers-mp-host-peers-src-mp-platform-ml-1501059589"></a>
### _mp_host_peers

```ml
_mp_host_peers
```

Stores the mp host peers collection used by the mp platform subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/mp_platform.ml#L257)

<a id="global-global-mp-host-skill-cfg-mp-host-skill-cfg-src-mp-platform-ml-37835875"></a>
### _mp_host_skill_cfg

```ml
_mp_host_skill_cfg
```

Tracks the mutable mp host skill cfg value used by the mp platform subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/mp_platform.ml#L242)

<a id="global-global-mp-host-time-limit-cfg-mp-host-time-limit-cfg-src-mp-platform-ml-611965115"></a>
### _mp_host_time_limit_cfg

```ml
_mp_host_time_limit_cfg
```

Tracks the mutable mp host time limit cfg value used by the mp platform subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/mp_platform.ml#L251)

- [_mp_peer_t](Type-mp-peer-t-697772715.md) — struct
<a id="global-global-mp-platform-event-log-path-mp-platform-event-log-path-src-mp-platform-ml-789923315"></a>
### _mp_platform_event_log_path

```ml
_mp_platform_event_log_path
```

Stores the mutable mp platform event log path text used by the mp platform subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/mp_platform.ml#L40)

<a id="global-global-mp-platform-last-error-mp-platform-last-error-src-mp-platform-ml-877516539"></a>
### _mp_platform_last_error

```ml
_mp_platform_last_error
```

Stores the mutable mp platform last error text used by the mp platform subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/mp_platform.ml#L34)

<a id="global-global-mp-platform-last-status-mp-platform-last-status-src-mp-platform-ml-691759523"></a>
### _mp_platform_last_status

```ml
_mp_platform_last_status
```

Stores the mutable mp platform last status text used by the mp platform subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/mp_platform.ml#L37)

<a id="global-global-mp-role-mp-role-src-mp-platform-ml-11606757"></a>
### _mp_role

```ml
_mp_role
```

Tracks the mutable mp role value used by the mp platform subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/mp_platform.ml#L229)

<a id="global-global-mp-sock-mp-sock-src-mp-platform-ml-29812785"></a>
### _mp_sock

```ml
_mp_sock
```

Holds the optional mp sock resource used by the mp platform subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/mp_platform.ml#L232)

<a id="constant-constant-mpplat-acc-const-mpplat-acc-acc-src-mp-platform-ml-552635763"></a>
### _MPPLAT_ACC

```ml
const _MPPLAT_ACC = "ACC"
```

Defines the mpplat acc text used by the mp platform subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/mp_platform.ml#L60)

<a id="constant-constant-mpplat-client-host-timeout-ms-const-mpplat-client-host-timeout-ms-10000-src-mp-platform-ml-23162063"></a>
### _MPPLAT_CLIENT_HOST_TIMEOUT_MS

```ml
const _MPPLAT_CLIENT_HOST_TIMEOUT_MS = 10000
```

Defines mpplat client host timeout ms for the mp platform subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/mp_platform.ml#L118)

<a id="constant-constant-mpplat-client-ping-interval-ms-const-mpplat-client-ping-interval-ms-1000-src-mp-platform-ml-1274767399"></a>
### _MPPLAT_CLIENT_PING_INTERVAL_MS

```ml
const _MPPLAT_CLIENT_PING_INTERVAL_MS = 1000
```

Defines mpplat client ping interval ms for the mp platform subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/mp_platform.ml#L121)

<a id="constant-constant-mpplat-control-max-const-mpplat-control-max-512-src-mp-platform-ml-760014278"></a>
### _MPPLAT_CONTROL_MAX

```ml
const _MPPLAT_CONTROL_MAX = 512
```

Defines the maximum mpplat control max accepted by the mp platform subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/mp_platform.ml#L94)

<a id="constant-constant-mpplat-den-const-mpplat-den-den-src-mp-platform-ml-933396981"></a>
### _MPPLAT_DEN

```ml
const _MPPLAT_DEN = "DEN"
```

Defines the mpplat den text used by the mp platform subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/mp_platform.ml#L63)

<a id="constant-constant-mpplat-fionbio-const-mpplat-fionbio-2147772030-src-mp-platform-ml-1864082849"></a>
### _MPPLAT_FIONBIO

```ml
const _MPPLAT_FIONBIO = 2147772030
```

Defines mpplat fionbio for the mp platform subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/mp_platform.ml#L127)

<a id="constant-constant-mpplat-game-magic0-const-mpplat-game-magic0-77-src-mp-platform-ml-864982222"></a>
### _MPPLAT_GAME_MAGIC0

```ml
const _MPPLAT_GAME_MAGIC0 = 77
```

Defines mpplat game magic0 for the mp platform subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/mp_platform.ml#L75)

<a id="constant-constant-mpplat-game-magic1-const-mpplat-game-magic1-68-src-mp-platform-ml-1426989594"></a>
### _MPPLAT_GAME_MAGIC1

```ml
const _MPPLAT_GAME_MAGIC1 = 68
```

Defines mpplat game magic1 for the mp platform subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/mp_platform.ml#L78)

<a id="constant-constant-mpplat-game-magic2-const-mpplat-game-magic2-71-src-mp-platform-ml-2010014920"></a>
### _MPPLAT_GAME_MAGIC2

```ml
const _MPPLAT_GAME_MAGIC2 = 71
```

Defines mpplat game magic2 for the mp platform subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/mp_platform.ml#L81)

<a id="constant-constant-mpplat-game-magic3-const-mpplat-game-magic3-49-src-mp-platform-ml-1573063729"></a>
### _MPPLAT_GAME_MAGIC3

```ml
const _MPPLAT_GAME_MAGIC3 = 49
```

Defines mpplat game magic3 for the mp platform subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/mp_platform.ml#L84)

<a id="constant-constant-mpplat-game-payload-max-const-mpplat-game-payload-max-1391-src-mp-platform-ml-859070368"></a>
### _MPPLAT_GAME_PAYLOAD_MAX

```ml
const _MPPLAT_GAME_PAYLOAD_MAX = 1391
```

Defines the maximum mpplat game payload max accepted by the mp platform subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/mp_platform.ml#L91)

<a id="constant-constant-mpplat-game-queue-chunk-const-mpplat-game-queue-chunk-256-src-mp-platform-ml-1280078679"></a>
### _MPPLAT_GAME_QUEUE_CHUNK

```ml
const _MPPLAT_GAME_QUEUE_CHUNK = 256
```

Defines mpplat game queue chunk for the mp platform subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/mp_platform.ml#L136)

<a id="constant-constant-mpplat-game-queue-max-const-mpplat-game-queue-max-2048-src-mp-platform-ml-214280570"></a>
### _MPPLAT_GAME_QUEUE_MAX

```ml
const _MPPLAT_GAME_QUEUE_MAX = 2048
```

Defines the maximum mpplat game queue max accepted by the mp platform subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/mp_platform.ml#L139)

<a id="constant-constant-mpplat-host-peer-timeout-ms-const-mpplat-host-peer-timeout-ms-30000-src-mp-platform-ml-921177631"></a>
### _MPPLAT_HOST_PEER_TIMEOUT_MS

```ml
const _MPPLAT_HOST_PEER_TIMEOUT_MS = 30000
```

Defines mpplat host peer timeout ms for the mp platform subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/mp_platform.ml#L115)

<a id="constant-constant-mpplat-host-ping-interval-ms-const-mpplat-host-ping-interval-ms-1000-src-mp-platform-ml-1259088583"></a>
### _MPPLAT_HOST_PING_INTERVAL_MS

```ml
const _MPPLAT_HOST_PING_INTERVAL_MS = 1000
```

Defines mpplat host ping interval ms for the mp platform subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/mp_platform.ml#L124)

<a id="constant-constant-mpplat-leave-const-mpplat-leave-leave-src-mp-platform-ml-337819881"></a>
### _MPPLAT_LEAVE

```ml
const _MPPLAT_LEAVE = "LEAVE"
```

Defines the mpplat leave text used by the mp platform subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/mp_platform.ml#L72)

<a id="constant-constant-mpplat-max-players-const-mpplat-max-players-4-src-mp-platform-ml-1844126898"></a>
### _MPPLAT_MAX_PLAYERS

```ml
const _MPPLAT_MAX_PLAYERS = 4
```

Defines the maximum mpplat max players accepted by the mp platform subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/mp_platform.ml#L130)

<a id="constant-constant-mpplat-ping-const-mpplat-ping-ping-src-mp-platform-ml-1927131958"></a>
### _MPPLAT_PING

```ml
const _MPPLAT_PING = "PING"
```

Defines the mpplat ping text used by the mp platform subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/mp_platform.ml#L66)

<a id="constant-constant-mpplat-pong-const-mpplat-pong-pong-src-mp-platform-ml-910748616"></a>
### _MPPLAT_PONG

```ml
const _MPPLAT_PONG = "PONG"
```

Defines the mpplat pong text used by the mp platform subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/mp_platform.ml#L69)

<a id="constant-constant-mpplat-proto-const-mpplat-proto-mdmp1-src-mp-platform-ml-1096132761"></a>
### _MPPLAT_PROTO

```ml
const _MPPLAT_PROTO = "MDMP1"
```

Defines the mpplat proto text used by the mp platform subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/mp_platform.ml#L54)

<a id="constant-constant-mpplat-pump-budget-ms-const-mpplat-pump-budget-ms-4-src-mp-platform-ml-2135348010"></a>
### _MPPLAT_PUMP_BUDGET_MS

```ml
const _MPPLAT_PUMP_BUDGET_MS = 4
```

Defines mpplat pump budget ms for the mp platform subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/mp_platform.ml#L148)

<a id="constant-constant-mpplat-pump-max-packets-const-mpplat-pump-max-packets-192-src-mp-platform-ml-547631802"></a>
### _MPPLAT_PUMP_MAX_PACKETS

```ml
const _MPPLAT_PUMP_MAX_PACKETS = 192
```

Defines the maximum mpplat pump max packets accepted by the mp platform subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/mp_platform.ml#L142)

<a id="constant-constant-mpplat-pump-min-packets-const-mpplat-pump-min-packets-48-src-mp-platform-ml-316590900"></a>
### _MPPLAT_PUMP_MIN_PACKETS

```ml
const _MPPLAT_PUMP_MIN_PACKETS = 48
```

Defines the minimum mpplat pump min packets accepted by the mp platform subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/mp_platform.ml#L145)

<a id="constant-constant-mpplat-recv-max-const-mpplat-recv-max-1400-src-mp-platform-ml-562550847"></a>
### _MPPLAT_RECV_MAX

```ml
const _MPPLAT_RECV_MAX = 1400
```

Defines the maximum mpplat recv max accepted by the mp platform subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/mp_platform.ml#L88)

<a id="constant-constant-mpplat-req-const-mpplat-req-req-src-mp-platform-ml-1412831654"></a>
### _MPPLAT_REQ

```ml
const _MPPLAT_REQ = "REQ"
```

Defines the mpplat req text used by the mp platform subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/mp_platform.ml#L57)

<a id="constant-constant-mpplat-role-client-const-mpplat-role-client-2-src-mp-platform-ml-523503888"></a>
### _MPPLAT_ROLE_CLIENT

```ml
const _MPPLAT_ROLE_CLIENT = 2
```

Defines mpplat role client for the mp platform subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/mp_platform.ml#L50)

<a id="constant-constant-mpplat-role-host-const-mpplat-role-host-1-src-mp-platform-ml-197733567"></a>
### _MPPLAT_ROLE_HOST

```ml
const _MPPLAT_ROLE_HOST = 1
```

Defines mpplat role host for the mp platform subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/mp_platform.ml#L47)

<a id="constant-constant-mpplat-role-none-const-mpplat-role-none-0-src-mp-platform-ml-218135830"></a>
### _MPPLAT_ROLE_NONE

```ml
const _MPPLAT_ROLE_NONE = 0
```

Defines mpplat role none for the mp platform subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/mp_platform.ml#L44)

<a id="constant-constant-mpplat-so-rcvtimeo-const-mpplat-so-rcvtimeo-4102-src-mp-platform-ml-1782834279"></a>
### _MPPLAT_SO_RCVTIMEO

```ml
const _MPPLAT_SO_RCVTIMEO = 4102
```

Defines mpplat so rcvtimeo for the mp platform subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/mp_platform.ml#L133)

<a id="constant-constant-mpplat-timedout-const-mpplat-timedout-10060-src-mp-platform-ml-201638949"></a>
### _MPPLAT_TIMEDOUT

```ml
const _MPPLAT_TIMEDOUT = 10060
```

Defines mpplat timedout for the mp platform subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/mp_platform.ml#L104)

<a id="constant-constant-mpplat-timeout-ms-const-mpplat-timeout-ms-2500-src-mp-platform-ml-1930915321"></a>
### _MPPLAT_TIMEOUT_MS

```ml
const _MPPLAT_TIMEOUT_MS = 2500
```

Defines mpplat timeout ms for the mp platform subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/mp_platform.ml#L97)

<a id="constant-constant-mpplat-wouldblock-const-mpplat-wouldblock-10035-src-mp-platform-ml-1310075289"></a>
### _MPPLAT_WOULDBLOCK

```ml
const _MPPLAT_WOULDBLOCK = 10035
```

Defines mpplat wouldblock for the mp platform subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/mp_platform.ml#L101)

<a id="function-function-mpplatform-allochostpeerid-function-mpplatform-allochostpeerid-src-mp-platform-ml-1625463265"></a>
### _MPPlatform_AllocHostPeerId

```ml
function _MPPlatform_AllocHostPeerId()
```

Allocates next available host-side peer id for a joining client.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/mp_platform.ml#L1250)

<a id="function-function-mpplatform-allochostslot-inline-function-mpplatform-allochostslot-src-mp-platform-ml-689460722"></a>
### _MPPlatform_AllocHostSlot

```ml
inline function _MPPlatform_AllocHostSlot()
```

Allocates a free player slot [1..MAXPLAYERS-1] for a joining client.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/mp_platform.ml#L956)

<a id="function-function-mpplatform-clienthandlepacket-function-mpplatform-clienthandlepacket-payload-peerip-peerport-src-mp-platform-ml-619432863"></a>
### _MPPlatform_ClientHandlePacket

```ml
function _MPPlatform_ClientHandlePacket(payload, peerIp, peerPort)
```

Processes runtime client-side maintenance packets after join.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `payload` | `dynamic` | — | Payload value supplied to `_MPPlatform_ClientHandlePacket`. |
| `peerIp` | `dynamic` | — | Peer ip value supplied to `_MPPlatform_ClientHandlePacket`. |
| `peerPort` | `dynamic` | — | Peer port value supplied to `_MPPlatform_ClientHandlePacket`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/mp_platform.ml#L1486)

<a id="function-function-mpplatform-closesocketonly-inline-function-mpplatform-closesocketonly-src-mp-platform-ml-2027985830"></a>
### _MPPlatform_CloseSocketOnly

```ml
inline function _MPPlatform_CloseSocketOnly()
```

Closes active UDP socket if currently open.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/mp_platform.ml#L804)

<a id="function-function-mpplatform-ensurepeertelemetry-inline-function-mpplatform-ensurepeertelemetry-p-src-mp-platform-ml-1491768638"></a>
### _MPPlatform_EnsurePeerTelemetry

```ml
inline function _MPPlatform_EnsurePeerTelemetry(p)
```

Ensures host peer struct has telemetry fields initialized.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `p` | `dynamic` | — | Object or data record consumed by the operation. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/mp_platform.ml#L417)

<a id="function-function-mpplatform-expirehostpeers-function-mpplatform-expirehostpeers-src-mp-platform-ml-401773489"></a>
### _MPPlatform_ExpireHostPeers

```ml
function _MPPlatform_ExpireHostPeers()
```

Removes host peers that timed out and emits status updates.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/mp_platform.ml#L1547)

<a id="function-function-mpplatform-findhostpeerbyslot-inline-function-mpplatform-findhostpeerbyslot-slot-src-mp-platform-ml-1037496932"></a>
### _MPPlatform_FindHostPeerBySlot

```ml
inline function _MPPlatform_FindHostPeerBySlot(slot)
```

Returns host peer index for a given slot, or -1 if not found.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `slot` | `dynamic` | — | Slot value supplied to `_MPPlatform_FindHostPeerBySlot`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/mp_platform.ml#L968)

<a id="function-function-mpplatform-findhostpeerindex-inline-function-mpplatform-findhostpeerindex-ip-port-src-mp-platform-ml-173892600"></a>
### _MPPlatform_FindHostPeerIndex

```ml
inline function _MPPlatform_FindHostPeerIndex(ip, port)
```

Finds existing host peer entry by ip/port tuple.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `ip` | `dynamic` | — | Ip value supplied to `_MPPlatform_FindHostPeerIndex`. |
| `port` | `dynamic` | — | Port value supplied to `_MPPlatform_FindHostPeerIndex`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/mp_platform.ml#L913)

<a id="function-function-mpplatform-gamechecksum16-inline-function-mpplatform-gamechecksum16-payload-n-src-mp-platform-ml-93569600"></a>
### _MPPlatform_GameChecksum16

```ml
inline function _MPPlatform_GameChecksum16(payload, n)
```

Computes a lightweight 16-bit checksum across gameplay payload bytes.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `payload` | `dynamic` | — | Payload value supplied to `_MPPlatform_GameChecksum16`. |
| `n` | `dynamic` | — | Number of values to process. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/mp_platform.ml#L1184)

<a id="function-function-mpplatform-hosthandlepacket-function-mpplatform-hosthandlepacket-payload-peerip-peerport-src-mp-platform-ml-1800989103"></a>
### _MPPlatform_HostHandlePacket

```ml
function _MPPlatform_HostHandlePacket(payload, peerIp, peerPort)
```

Processes host-side incoming UDP packet for join/ping flow.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `payload` | `dynamic` | — | Payload value supplied to `_MPPlatform_HostHandlePacket`. |
| `peerIp` | `dynamic` | — | Peer ip value supplied to `_MPPlatform_HostHandlePacket`. |
| `peerPort` | `dynamic` | — | Peer port value supplied to `_MPPlatform_HostHandlePacket`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/mp_platform.ml#L1384)

<a id="function-function-mpplatform-hostsendaccept-function-mpplatform-hostsendaccept-ip-port-slot-peerid-src-mp-platform-ml-1235214134"></a>
### _MPPlatform_HostSendAccept

```ml
function _MPPlatform_HostSendAccept(ip, port, slot, peerId)
```

Sends an accept packet with server-authoritative lobby settings.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `ip` | `dynamic` | — | Ip value supplied to `_MPPlatform_HostSendAccept`. |
| `port` | `dynamic` | — | Port value supplied to `_MPPlatform_HostSendAccept`. |
| `slot` | `dynamic` | — | Slot value supplied to `_MPPlatform_HostSendAccept`. |
| `peerId` | `dynamic` | — | Peer id value supplied to `_MPPlatform_HostSendAccept`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/mp_platform.ml#L1360)

<a id="function-function-mpplatform-hostsenddeny-inline-function-mpplatform-hostsenddeny-ip-port-reasoncode-reasontext-includehash-src-mp-platform-ml-1227839112"></a>
### _MPPlatform_HostSendDeny

```ml
inline function _MPPlatform_HostSendDeny(ip, port, reasonCode, reasonText, includeHash)
```

Sends a host-side join denial packet with optional server hash context.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `ip` | `dynamic` | — | Ip value supplied to `_MPPlatform_HostSendDeny`. |
| `port` | `dynamic` | — | Port value supplied to `_MPPlatform_HostSendDeny`. |
| `reasonCode` | `dynamic` | — | Reason code value supplied to `_MPPlatform_HostSendDeny`. |
| `reasonText` | `dynamic` | — | Reason text value supplied to `_MPPlatform_HostSendDeny`. |
| `includeHash` | `dynamic` | — | Include hash value supplied to `_MPPlatform_HostSendDeny`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/mp_platform.ml#L1348)

<a id="function-function-mpplatform-initclientslotnames-function-mpplatform-initclientslotnames-localname-src-mp-platform-ml-1112044133"></a>
### _MPPlatform_InitClientSlotNames

```ml
function _MPPlatform_InitClientSlotNames(localName)
```

Initializes deterministic client-side slot name cache.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `localName` | `dynamic` | — | Local name value supplied to `_MPPlatform_InitClientSlotNames`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/mp_platform.ml#L565)

<a id="function-function-mpplatform-isgamepacket-inline-function-mpplatform-isgamepacket-payload-src-mp-platform-ml-254231958"></a>
### _MPPlatform_IsGamePacket

```ml
inline function _MPPlatform_IsGamePacket(payload)
```

Checks whether payload uses MiniDoom gameplay UDP frame format.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `payload` | `dynamic` | — | Payload value supplied to `_MPPlatform_IsGamePacket`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/mp_platform.ml#L1174)

<a id="function-function-mpplatform-ispeeridused-inline-function-mpplatform-ispeeridused-pid-src-mp-platform-ml-120553493"></a>
### _MPPlatform_IsPeerIdUsed

```ml
inline function _MPPlatform_IsPeerIdUsed(pid)
```

Checks whether a host peer id is already occupied.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `pid` | `dynamic` | — | Pid value supplied to `_MPPlatform_IsPeerIdUsed`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/mp_platform.ml#L929)

<a id="function-function-mpplatform-isslotused-inline-function-mpplatform-isslotused-slot-src-mp-platform-ml-2065359466"></a>
### _MPPlatform_IsSlotUsed

```ml
inline function _MPPlatform_IsSlotUsed(slot)
```

Checks whether a host player slot index is already used by a peer.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `slot` | `dynamic` | — | Slot value supplied to `_MPPlatform_IsSlotUsed`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/mp_platform.ml#L943)

<a id="function-function-mpplatform-iswouldblockerror-inline-function-mpplatform-iswouldblockerror-v-src-mp-platform-ml-1165526184"></a>
### _MPPlatform_IsWouldBlockError

```ml
inline function _MPPlatform_IsWouldBlockError(v)
```

Checks whether a net error maps to WSAEWOULDBLOCK.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `v` | `dynamic` | — | Value consumed by the operation. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/mp_platform.ml#L843)

<a id="function-function-mpplatform-logevent-function-mpplatform-logevent-line-src-mp-platform-ml-472513635"></a>
### _MPPlatform_LogEvent

```ml
function _MPPlatform_LogEvent(line)
```

Emits one machine-readable transport event to stdout and the configured process-local log.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `line` | `dynamic` | — | Map line or text line affected by the operation. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/mp_platform.ml#L199)

<a id="function-function-mpplatform-normalizeipv4-function-mpplatform-normalizeipv4-value-src-mp-platform-ml-313055694"></a>
### _MPPlatform_NormalizeIPv4

```ml
function _MPPlatform_NormalizeIPv4(value)
```

Validates dotted-decimal IPv4 input and returns the canonical form used by udpRecvFrom endpoints.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `value` | `dynamic` | — | Value consumed by the operation. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/mp_platform.ml#L881)

<a id="function-function-mpplatform-peeringame-inline-function-mpplatform-peeringame-p-src-mp-platform-ml-1100446582"></a>
### _MPPlatform_PeerIngame

```ml
inline function _MPPlatform_PeerIngame(p)
```

Returns true when peer ingame marker is truthy (bool true or non-zero int).

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `p` | `dynamic` | — | Object or data record consumed by the operation. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/mp_platform.ml#L406)

<a id="function-function-mpplatform-popgamepacket-function-mpplatform-popgamepacket-src-mp-platform-ml-1385292127"></a>
### _MPPlatform_PopGamePacket

```ml
function _MPPlatform_PopGamePacket()
```

Dequeues one gameplay packet as [node,payload], or void when empty.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/mp_platform.ml#L1116)

<a id="function-function-mpplatform-pushconsolemessage-inline-function-mpplatform-pushconsolemessage-msg-src-mp-platform-ml-1236327033"></a>
### _MPPlatform_PushConsoleMessage

```ml
inline function _MPPlatform_PushConsoleMessage(msg)
```

Sends a short HUD message to the local console player when available.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `msg` | `dynamic` | — | Msg value supplied to `_MPPlatform_PushConsoleMessage`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/mp_platform.ml#L459)

<a id="function-function-mpplatform-queuedepth-inline-function-mpplatform-queuedepth-src-mp-platform-ml-1788212296"></a>
### _MPPlatform_QueueDepth

```ml
inline function _MPPlatform_QueueDepth()
```

Returns queued gameplay packet count waiting for d_net consumption.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/mp_platform.ml#L432)

<a id="function-function-mpplatform-queueensurecapacity-function-mpplatform-queueensurecapacity-required-src-mp-platform-ml-230080746"></a>
### _MPPlatform_QueueEnsureCapacity

```ml
function _MPPlatform_QueueEnsureCapacity(required)
```

Grows game packet queue storage in chunks so enqueue stays O(1) in steady state.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `required` | `dynamic` | — | Required value supplied to `_MPPlatform_QueueEnsureCapacity`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/mp_platform.ml#L981)

<a id="function-function-mpplatform-queuegamepacket-function-mpplatform-queuegamepacket-node-payload-src-mp-platform-ml-1599016619"></a>
### _MPPlatform_QueueGamePacket

```ml
function _MPPlatform_QueueGamePacket(node, payload)
```

Enqueues gameplay packet payload for d_net/i_net processing.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `node` | `dynamic` | — | Node value supplied to `_MPPlatform_QueueGamePacket`. |
| `payload` | `dynamic` | — | Payload value supplied to `_MPPlatform_QueueGamePacket`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/mp_platform.ml#L1014)

<a id="function-function-mpplatform-removehostpeerbyindex-function-mpplatform-removehostpeerbyindex-idx-withmessage-src-mp-platform-ml-821021945"></a>
### _MPPlatform_RemoveHostPeerByIndex

```ml
function _MPPlatform_RemoveHostPeerByIndex(idx, withMessage)
```

Removes host peer entry and emits leave status if requested.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `idx` | `dynamic` | — | Zero-based element or table index. |
| `withMessage` | `dynamic` | — | With message value supplied to `_MPPlatform_RemoveHostPeerByIndex`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/mp_platform.ml#L1307)

<a id="function-function-mpplatform-sanitizefield-inline-function-mpplatform-sanitizefield-s0-src-mp-platform-ml-627939849"></a>
### _MPPlatform_SanitizeField

```ml
inline function _MPPlatform_SanitizeField(s0)
```

Removes wire-delimiter/control bytes from textual packet fields.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `s0` | `dynamic` | — | S0 value supplied to `_MPPlatform_SanitizeField`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/mp_platform.ml#L794)

<a id="function-function-mpplatform-sendfields-inline-function-mpplatform-sendfields-sock-ip-port-fields-src-mp-platform-ml-1919123749"></a>
### _MPPlatform_SendFields

```ml
inline function _MPPlatform_SendFields(sock, ip, port, fields)
```

Encodes and sends a textual UDP packet with field separators.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `sock` | `dynamic` | — | Sock value supplied to `_MPPlatform_SendFields`. |
| `ip` | `dynamic` | — | Ip value supplied to `_MPPlatform_SendFields`. |
| `port` | `dynamic` | — | Port value supplied to `_MPPlatform_SendFields`. |
| `fields` | `dynamic` | — | Fields value supplied to `_MPPlatform_SendFields`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/mp_platform.ml#L855)

<a id="function-function-mpplatform-seterror-inline-function-mpplatform-seterror-msg-src-mp-platform-ml-2118061025"></a>
### _MPPlatform_SetError

```ml
inline function _MPPlatform_SetError(msg)
```

Stores user-facing error text for multiplayer host/join operations.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `msg` | `dynamic` | — | Msg value supplied to `_MPPlatform_SetError`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/mp_platform.ml#L1868)

<a id="function-function-mpplatform-setnonblocking-inline-function-mpplatform-setnonblocking-sock-enabled-src-mp-platform-ml-1934402101"></a>
### _MPPlatform_SetNonBlocking

```ml
inline function _MPPlatform_SetNonBlocking(sock, enabled)
```

Configures UDP socket to non-blocking mode.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `sock` | `dynamic` | — | Sock value supplied to `_MPPlatform_SetNonBlocking`. |
| `enabled` | `dynamic` | — | Whether the requested feature should be enabled. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/mp_platform.ml#L816)

<a id="function-function-mpplatform-setrecvtimeout-inline-function-mpplatform-setrecvtimeout-sock-timeoutms-src-mp-platform-ml-2114262669"></a>
### _MPPlatform_SetRecvTimeout

```ml
inline function _MPPlatform_SetRecvTimeout(sock, timeoutMs)
```

Configures socket receive timeout in milliseconds.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `sock` | `dynamic` | — | Sock value supplied to `_MPPlatform_SetRecvTimeout`. |
| `timeoutMs` | `dynamic` | — | Timeout ms value supplied to `_MPPlatform_SetRecvTimeout`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/mp_platform.ml#L827)

<a id="function-function-mpplatform-setstatus-inline-function-mpplatform-setstatus-msg-src-mp-platform-ml-926219131"></a>
### _MPPlatform_SetStatus

```ml
inline function _MPPlatform_SetStatus(msg)
```

Stores latest status string for menu/UI display.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `msg` | `dynamic` | — | Msg value supplied to `_MPPlatform_SetStatus`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/mp_platform.ml#L446)

<a id="function-function-mpplatform-tobytescopy-inline-function-mpplatform-tobytescopy-v-src-mp-platform-ml-22597820"></a>
### _MPPlatform_ToBytesCopy

```ml
inline function _MPPlatform_ToBytesCopy(v)
```

Normalizes bytes/array payload values to bytes (fast-path avoids copy for bytes).

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `v` | `dynamic` | — | Value consumed by the operation. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/mp_platform.ml#L386)

<a id="function-function-mpplatform-toint-inline-function-mpplatform-toint-v-fallback-src-mp-platform-ml-1762823210"></a>
### _MPPlatform_ToInt

```ml
inline function _MPPlatform_ToInt(v, fallback)
```

Converts mixed numeric values to stable integer values.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `v` | `dynamic` | — | Value consumed by the operation. |
| `fallback` | `dynamic` | — | Value returned when the requested conversion or lookup is unavailable. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/mp_platform.ml#L356)

<a id="function-function-mpplatform-unwrapgamepayload-function-mpplatform-unwrapgamepayload-packet-src-mp-platform-ml-328914251"></a>
### _MPPlatform_UnwrapGamePayload

```ml
function _MPPlatform_UnwrapGamePayload(packet)
```

Decodes gameplay frame and returns payload bytes.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `packet` | `dynamic` | — | Packet value supplied to `_MPPlatform_UnwrapGamePayload`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/mp_platform.ml#L1203)

<a id="function-function-mpplatform-upserthostpeer-function-mpplatform-upserthostpeer-ip-port-name-src-mp-platform-ml-1875797152"></a>
### _MPPlatform_UpsertHostPeer

```ml
function _MPPlatform_UpsertHostPeer(ip, port, name)
```

Creates or refreshes a host peer entry and returns its assigned player slot (1..3).

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `ip` | `dynamic` | — | Ip value supplied to `_MPPlatform_UpsertHostPeer`. |
| `port` | `dynamic` | — | Port value supplied to `_MPPlatform_UpsertHostPeer`. |
| `name` | `dynamic` | — | Resource or object name to resolve. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/mp_platform.ml#L1274)

<a id="function-function-mpplatform-waitpulse-inline-function-mpplatform-waitpulse-src-mp-platform-ml-2058951914"></a>
### _MPPlatform_WaitPulse

```ml
inline function _MPPlatform_WaitPulse()
```

Keeps GUI/audio responsive while host/join control flow waits on network I/O.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/mp_platform.ml#L373)

<a id="function-function-mpplatform-wrapgamepayload-function-mpplatform-wrapgamepayload-localslot-payload-src-mp-platform-ml-595602410"></a>
### _MPPlatform_WrapGamePayload

```ml
function _MPPlatform_WrapGamePayload(localSlot, payload)
```

Encodes gameplay payload in MiniDoom gameplay UDP frame format.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `localSlot` | `dynamic` | — | Local slot value supplied to `_MPPlatform_WrapGamePayload`. |
| `payload` | `dynamic` | — | Payload value supplied to `_MPPlatform_WrapGamePayload`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/mp_platform.ml#L1225)

<a id="extern_function-extern-function-ioctlsocket-extern-function-ioctlsocket-s-as-ptr-cmd-as-i32-argp-as-bytes-from-ws2-32-dll-returns-int-src-mp-platform-ml-714314828"></a>
### ioctlsocket

```ml
extern function ioctlsocket(s as ptr, cmd as i32, argp as bytes) from "ws2_32.dll" returns int
```

Toggles socket mode (blocking/non-blocking) for UDP polling.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `s` | `ptr` | — | `ptr` value supplied as s to `ioctlsocket`. |
| `cmd` | `i32` | — | `i32` value supplied as cmd to `ioctlsocket`. |
| `argp` | `bytes` | — | `bytes` value supplied as argp to `ioctlsocket`. |


**Returns:** Result returned by the native `ioctlsocket` binding as `int`.

[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/mp_platform.ml#L341)

<a id="function-function-mp-platformgetactiveslots-function-mp-platformgetactiveslots-src-mp-platform-ml-783997369"></a>
### MP_PlatformGetActiveSlots

```ml
function MP_PlatformGetActiveSlots()
```

Returns array of currently active player slots (always includes host slot 0).


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/mp_platform.ml#L720)

<a id="function-function-mp-platformgetdebugoverlaytext-function-mp-platformgetdebugoverlaytext-src-mp-platform-ml-1562157397"></a>
### MP_PlatformGetDebugOverlayText

```ml
function MP_PlatformGetDebugOverlayText()
```

Returns multiplayer debug text for in-game overlay rendering.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/mp_platform.ml#L491)

<a id="function-function-mp-platformgetlasterror-function-mp-platformgetlasterror-src-mp-platform-ml-1268604315"></a>
### MP_PlatformGetLastError

```ml
function MP_PlatformGetLastError()
```

Returns the last multiplayer platform error message.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/mp_platform.ml#L1878)

<a id="function-function-mp-platformgetlaststatus-function-mp-platformgetlaststatus-src-mp-platform-ml-663646093"></a>
### MP_PlatformGetLastStatus

```ml
function MP_PlatformGetLastStatus()
```

Returns latest multiplayer runtime status string.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/mp_platform.ml#L471)

<a id="function-function-mp-platformgetlocalplayerslot-inline-function-mp-platformgetlocalplayerslot-src-mp-platform-ml-1525395998"></a>
### MP_PlatformGetLocalPlayerSlot

```ml
inline function MP_PlatformGetLocalPlayerSlot()
```

Returns local player slot index used by Doom net layer.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/mp_platform.ml#L552)

<a id="function-function-mp-platformgetnodecount-function-mp-platformgetnodecount-src-mp-platform-ml-470579337"></a>
### MP_PlatformGetNodeCount

```ml
function MP_PlatformGetNodeCount()
```

Returns active doom net node count for local multiplayer role.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/mp_platform.ml#L663)

<a id="function-function-mp-platformgetnumplayers-function-mp-platformgetnumplayers-src-mp-platform-ml-1256615133"></a>
### MP_PlatformGetNumPlayers

```ml
function MP_PlatformGetNumPlayers()
```

Returns known active player count for local multiplayer role.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/mp_platform.ml#L687)

<a id="function-function-mp-platformgetplayernamebyslot-function-mp-platformgetplayernamebyslot-slot-src-mp-platform-ml-1537780601"></a>
### MP_PlatformGetPlayerNameBySlot

```ml
function MP_PlatformGetPlayerNameBySlot(slot)
```

Resolves player display name for a given Doom slot index.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `slot` | `dynamic` | — | Slot value supplied to `MP_PlatformGetPlayerNameBySlot`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/mp_platform.ml#L626)

<a id="function-function-mp-platformgetsessionmap-function-mp-platformgetsessionmap-src-mp-platform-ml-735798217"></a>
### MP_PlatformGetSessionMap

```ml
function MP_PlatformGetSessionMap()
```

Returns server-confirmed map token for active session.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/mp_platform.ml#L486)

<a id="function-function-mp-platformgetsessionmode-function-mp-platformgetsessionmode-src-mp-platform-ml-465812277"></a>
### MP_PlatformGetSessionMode

```ml
function MP_PlatformGetSessionMode()
```

Returns server-confirmed multiplayer mode for active session.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/mp_platform.ml#L476)

<a id="function-function-mp-platformgetsessionskill-function-mp-platformgetsessionskill-src-mp-platform-ml-1712229953"></a>
### MP_PlatformGetSessionSkill

```ml
function MP_PlatformGetSessionSkill()
```

Returns server-confirmed multiplayer skill for active session.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/mp_platform.ml#L481)

<a id="function-function-mp-platformhostgame-function-mp-platformhostgame-port-mode-skill-mapname-maxplayers-fraglimit-timelimit-src-mp-platform-ml-90697228"></a>
### MP_PlatformHostGame

```ml
function MP_PlatformHostGame(port, mode, skill, mapname, maxPlayers, fragLimit, timeLimit)
```

Starts a non-blocking UDP host endpoint for join handshakes.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `port` | `dynamic` | — | Port value supplied to `MP_PlatformHostGame`. |
| `mode` | `dynamic` | — | Mode value supplied to `MP_PlatformHostGame`. |
| `skill` | `dynamic` | — | Skill value supplied to `MP_PlatformHostGame`. |
| `mapname` | `dynamic` | — | Mapname value supplied to `MP_PlatformHostGame`. |
| `maxPlayers` | `dynamic` | — | Max players value supplied to `MP_PlatformHostGame`. |
| `fragLimit` | `dynamic` | — | Frag limit value supplied to `MP_PlatformHostGame`. |
| `timeLimit` | `dynamic` | — | Time limit value supplied to `MP_PlatformHostGame`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/mp_platform.ml#L1890)

<a id="function-function-mp-platformisclientconnected-inline-function-mp-platformisclientconnected-src-mp-platform-ml-840466586"></a>
### MP_PlatformIsClientConnected

```ml
inline function MP_PlatformIsClientConnected()
```

Returns true when local runtime has an active client connection.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/mp_platform.ml#L547)

<a id="function-function-mp-platformishosting-inline-function-mp-platformishosting-src-mp-platform-ml-1563938382"></a>
### MP_PlatformIsHosting

```ml
inline function MP_PlatformIsHosting()
```

Reports whether local runtime is currently acting as UDP host.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/mp_platform.ml#L1800)

<a id="function-function-mp-platformjoingame-function-mp-platformjoingame-host-port-playername-src-mp-platform-ml-931882000"></a>
### MP_PlatformJoinGame

```ml
function MP_PlatformJoinGame(host, port, playerName)
```

Sends UDP join request and waits with timeout for host response.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `host` | `dynamic` | — | Host value supplied to `MP_PlatformJoinGame`. |
| `port` | `dynamic` | — | Port value supplied to `MP_PlatformJoinGame`. |
| `playerName` | `dynamic` | — | Player name value supplied to `MP_PlatformJoinGame`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/mp_platform.ml#L2018)

<a id="function-function-mp-platformnetrecv-inline-function-mp-platformnetrecv-src-mp-platform-ml-84520328"></a>
### MP_PlatformNetRecv

```ml
inline function MP_PlatformNetRecv()
```

Pops one queued gameplay packet as [node,payload], or void if none.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/mp_platform.ml#L1860)

<a id="function-function-mp-platformnetsend-function-mp-platformnetsend-node-payload-src-mp-platform-ml-1843513141"></a>
### MP_PlatformNetSend

```ml
function MP_PlatformNetSend(node, payload)
```

Sends a gameplay packet payload to a Doom remote node.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `node` | `dynamic` | — | Node value supplied to `MP_PlatformNetSend`. |
| `payload` | `dynamic` | — | Payload value supplied to `MP_PlatformNetSend`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/mp_platform.ml#L1807)

<a id="function-function-mp-platformpump-function-mp-platformpump-src-mp-platform-ml-2100981655"></a>
### MP_PlatformPump

```ml
function MP_PlatformPump()
```

Processes non-blocking UDP packets for host/client maintenance.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/mp_platform.ml#L1593)

<a id="function-function-mp-platformseteventlogpath-function-mp-platformseteventlogpath-path-src-mp-platform-ml-358749746"></a>
### MP_PlatformSetEventLogPath

```ml
function MP_PlatformSetEventLogPath(path)
```

Selects an optional per-process diagnostics file used by CLI loopback tests and support logs.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `path` | `dynamic` | — | Filesystem path to process. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/mp_platform.ml#L187)

<a id="function-function-mp-platformsetplayernamebyslot-function-mp-platformsetplayernamebyslot-slot-name-src-mp-platform-ml-1714090174"></a>
### MP_PlatformSetPlayerNameBySlot

```ml
function MP_PlatformSetPlayerNameBySlot(slot, name)
```

Updates one checked slot name in the host peer table or client-side authoritative cache.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `slot` | `dynamic` | — | Slot value supplied to `MP_PlatformSetPlayerNameBySlot`. |
| `name` | `dynamic` | — | Resource or object name to resolve. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/mp_platform.ml#L592)

<a id="function-function-mp-platformshutdown-function-mp-platformshutdown-src-mp-platform-ml-731477999"></a>
### MP_PlatformShutdown

```ml
function MP_PlatformShutdown()
```

Shuts down multiplayer UDP runtime state and closes sockets.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/mp_platform.ml#L1725)

<a id="extern_function-extern-function-setsockopt-extern-function-setsockopt-s-as-ptr-level-as-int-optname-as-int-optval-as-bytes-optlen-as-int-from-ws2-32-dll-symbol-setsockopt-returns-int-src-mp-platform-ml-1990829352"></a>
### setsockopt

```ml
extern function setsockopt(s as ptr, level as int, optname as int, optval as bytes, optlen as int) from "ws2_32.dll" symbol "setsockopt" returns int
```

Configures the receive timeout on the owned WinSock UDP handle.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `s` | `ptr` | — | `ptr` value supplied as s to `setsockopt`. |
| `level` | `int` | — | `int` value supplied as level to `setsockopt`. |
| `optname` | `int` | — | `int` value supplied as optname to `setsockopt`. |
| `optval` | `bytes` | — | `bytes` value supplied as optval to `setsockopt`. |
| `optlen` | `int` | — | `int` value supplied as optlen to `setsockopt`. |


**Returns:** Result returned by the native `setsockopt` binding as `int`.

[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/mp_platform.ml#L350)
