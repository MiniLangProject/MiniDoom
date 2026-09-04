# `src/mp_state.ml`

[Home](README.md) · [Files](Files.md)

Stores multiplayer runtime/config state and utility helpers for map lists and WAD checks.

Package: [`(global)`](Package-global-1952375359.md)

Reachable from entry: **yes**

## Imports

- `doomdef.ml` → [src/doomdef.ml](File-src-doomdef-ml-460406769.md)
- `m_argv.ml` → [src/m_argv.ml](File-src-m-argv-ml-728984635.md)
- `mp_fnv1a.ml` → [src/mp_fnv1a.ml](File-src-mp-fnv1a-ml-1881283455.md)
- `std/fs.ml` as `fs` → `../MiniLangCompilerOptimization/MiniLangCompilerPy/std/fs.ml` — external dependency
- `std/math.ml` → `../MiniLangCompilerOptimization/MiniLangCompilerPy/std/math.ml` — external dependency

## Declarations

<a id="function-function-mp-clamp-function-mp-clamp-v-lo-hi-src-mp-state-ml-1981874647"></a>
### _MP_Clamp

```ml
function _MP_Clamp(v, lo, hi)
```

Clamps integer values.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `v` | `dynamic` | — | Value consumed by the operation. |
| `lo` | `dynamic` | — | Inclusive lower bound. |
| `hi` | `dynamic` | — | Inclusive upper bound. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/mp_state.ml#L101)

<a id="function-function-mp-isallowednamebyte-inline-function-mp-isallowednamebyte-c-src-mp-state-ml-704203991"></a>
### _MP_IsAllowedNameByte

```ml
inline function _MP_IsAllowedNameByte(c)
```

Validates player-name ASCII bytes.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `c` | `dynamic` | — | C value supplied to `_MP_IsAllowedNameByte`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/mp_state.ml#L159)

<a id="function-function-mp-strcontains-function-mp-strcontains-haystack-needle-src-mp-state-ml-1169203444"></a>
### _MP_StrContains

```ml
function _MP_StrContains(haystack, needle)
```

Checks if haystack contains needle.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `haystack` | `dynamic` | — | Haystack value supplied to `_MP_StrContains`. |
| `needle` | `dynamic` | — | Needle value supplied to `_MP_StrContains`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/mp_state.ml#L133)

<a id="function-function-mp-toint-function-mp-toint-v-fallback-src-mp-state-ml-1726606425"></a>
### _MP_ToInt

```ml
function _MP_ToInt(v, fallback)
```

Converts values to int with safe fallback.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `v` | `dynamic` | — | Value consumed by the operation. |
| `fallback` | `dynamic` | — | Value returned when the requested conversion or lookup is unavailable. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/mp_state.ml#L81)

<a id="function-function-mp-toupperascii-function-mp-toupperascii-s-src-mp-state-ml-1810119656"></a>
### _MP_ToUpperAscii

```ml
function _MP_ToUpperAscii(s)
```

Converts ASCII letters to uppercase.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `s` | `dynamic` | — | S value supplied to `_MP_ToUpperAscii`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/mp_state.ml#L118)

<a id="function-function-mp-twodigits-inline-function-mp-twodigits-v-src-mp-state-ml-1844174734"></a>
### _MP_TwoDigits

```ml
inline function _MP_TwoDigits(v)
```

Formats a number as two ASCII digits.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `v` | `dynamic` | — | Value consumed by the operation. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/mp_state.ml#L211)

<a id="function-function-mp-clampsettings-function-mp-clampsettings-src-mp-state-ml-1508968585"></a>
### MP_ClampSettings

```ml
function MP_ClampSettings()
```

Normalizes multiplayer configuration ranges.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/mp_state.ml#L422)

<a id="constant-constant-mp-default-port-const-mp-default-port-2342-src-mp-state-ml-674523687"></a>
### MP_DEFAULT_PORT

```ml
const MP_DEFAULT_PORT = 2342
```

Defines mp default port for the mp state subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/mp_state.ml#L34)

<a id="global-global-mp-dm-frag-limit-mp-dm-frag-limit-src-mp-state-ml-1111820851"></a>
### mp_dm_frag_limit

```ml
mp_dm_frag_limit
```

Tracks the mutable mp dm frag limit value used by the mp state subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/mp_state.ml#L61)

<a id="global-global-mp-dm-time-limit-mp-dm-time-limit-src-mp-state-ml-1863583317"></a>
### mp_dm_time_limit

```ml
mp_dm_time_limit
```

Tracks the mutable mp dm time limit value used by the mp state subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/mp_state.ml#L63)

<a id="function-function-mp-getiwadpath-function-mp-getiwadpath-src-mp-state-ml-1189385693"></a>
### MP_GetIwadPath

```ml
function MP_GetIwadPath()
```

Returns selected IWAD file path if available.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/mp_state.ml#L329)

<a id="function-function-mp-getplayername-function-mp-getplayername-src-mp-state-ml-969161865"></a>
### MP_GetPlayerName

```ml
function MP_GetPlayerName()
```

Returns current multiplayer player name.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/mp_state.ml#L203)

<a id="function-function-mp-getselectedmap-function-mp-getselectedmap-src-mp-state-ml-2089951411"></a>
### MP_GetSelectedMap

```ml
function MP_GetSelectedMap()
```

Returns currently selected host map name.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/mp_state.ml#L269)

<a id="global-global-mp-host-max-players-mp-host-max-players-src-mp-state-ml-643210831"></a>
### mp_host_max_players

```ml
mp_host_max_players
```

Tracks the mutable mp host max players value used by the mp state subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/mp_state.ml#L59)

<a id="global-global-mp-host-mode-mp-host-mode-src-mp-state-ml-532146483"></a>
### mp_host_mode

```ml
mp_host_mode
```

Tracks the mutable mp host mode value used by the mp state subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/mp_state.ml#L55)

<a id="global-global-mp-host-port-mp-host-port-src-mp-state-ml-1545444411"></a>
### mp_host_port

```ml
mp_host_port
```

Tracks the mutable mp host port value used by the mp state subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/mp_state.ml#L53)

<a id="global-global-mp-host-skill-mp-host-skill-src-mp-state-ml-1528973843"></a>
### mp_host_skill

```ml
mp_host_skill
```

Tracks the mutable mp host skill value used by the mp state subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/mp_state.ml#L57)

<a id="global-global-mp-iwad-fnv1a-hex-mp-iwad-fnv1a-hex-src-mp-state-ml-1525758195"></a>
### mp_iwad_fnv1a_hex

```ml
mp_iwad_fnv1a_hex
```

Stores the mutable mp iwad fnv1a hex text used by the mp state subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/mp_state.ml#L75)

<a id="global-global-mp-iwad-path-mp-iwad-path-src-mp-state-ml-2030192765"></a>
### mp_iwad_path

```ml
mp_iwad_path
```

Stores the mutable mp iwad path text used by the mp state subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/mp_state.ml#L73)

<a id="global-global-mp-join-host-mp-join-host-src-mp-state-ml-2094631457"></a>
### mp_join_host

```ml
mp_join_host
```

Stores the mutable mp join host text used by the mp state subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/mp_state.ml#L49)

<a id="global-global-mp-join-port-mp-join-port-src-mp-state-ml-826135867"></a>
### mp_join_port

```ml
mp_join_port
```

Tracks the mutable mp join port value used by the mp state subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/mp_state.ml#L51)

<a id="global-global-mp-map-index-mp-map-index-src-mp-state-ml-1015830809"></a>
### mp_map_index

```ml
mp_map_index
```

Tracks the mutable mp map index value used by the mp state subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/mp_state.ml#L68)

<a id="global-global-mp-map-list-mp-map-list-src-mp-state-ml-2009084627"></a>
### mp_map_list

```ml
mp_map_list
```

Stores the mp map list collection used by the mp state subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/mp_state.ml#L66)

<a id="constant-constant-mp-max-name-len-const-mp-max-name-len-25-src-mp-state-ml-1945032159"></a>
### MP_MAX_NAME_LEN

```ml
const MP_MAX_NAME_LEN = 25
```

Defines the maximum mp max name len accepted by the mp state subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/mp_state.ml#L32)

<a id="constant-constant-mp-mode-coop-const-mp-mode-coop-0-src-mp-state-ml-2004914080"></a>
### MP_MODE_COOP

```ml
const MP_MODE_COOP = 0
```

Defines mp mode coop for the mp state subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/mp_state.ml#L28)

<a id="constant-constant-mp-mode-deathmatch-const-mp-mode-deathmatch-1-src-mp-state-ml-1793043411"></a>
### MP_MODE_DEATHMATCH

```ml
const MP_MODE_DEATHMATCH = 1
```

Defines mp mode deathmatch for the mp state subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/mp_state.ml#L30)

<a id="global-global-mp-player-name-mp-player-name-src-mp-state-ml-162964613"></a>
### mp_player_name

```ml
mp_player_name
```

Stores the mutable mp player name text used by the mp state subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/mp_state.ml#L47)

<a id="global-global-mp-preferred-map-name-mp-preferred-map-name-src-mp-state-ml-590983227"></a>
### mp_preferred_map_name

```ml
mp_preferred_map_name
```

Stores the mutable mp preferred map name text used by the mp state subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/mp_state.ml#L70)

<a id="function-function-mp-rebuildmaplist-function-mp-rebuildmaplist-src-mp-state-ml-1004685543"></a>
### MP_RebuildMapList

```ml
function MP_RebuildMapList()
```

Rebuilds host-map selection list based on IWAD filename family.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/mp_state.ml#L223)

<a id="function-function-mp-sanitizename-function-mp-sanitizename-name-src-mp-state-ml-1426310704"></a>
### MP_SanitizeName

```ml
function MP_SanitizeName(name)
```

Sanitizes and trims player names to protocol constraints.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `name` | `dynamic` | — | Resource or object name to resolve. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/mp_state.ml#L169)

<a id="function-function-mp-setmode-function-mp-setmode-mode-src-mp-state-ml-101889452"></a>
### MP_SetMode

```ml
function MP_SetMode(mode)
```

Sets multiplayer host mode.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `mode` | `dynamic` | — | Mode value supplied to `MP_SetMode`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/mp_state.ml#L321)

<a id="function-function-mp-setplayername-function-mp-setplayername-name-src-mp-state-ml-1679646824"></a>
### MP_SetPlayerName

```ml
function MP_SetPlayerName(name)
```

Stores sanitized multiplayer player name.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `name` | `dynamic` | — | Resource or object name to resolve. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/mp_state.ml#L197)

<a id="function-function-mp-setselectedmapbyname-function-mp-setselectedmapbyname-name-src-mp-state-ml-236960506"></a>
### MP_SetSelectedMapByName

```ml
function MP_SetSelectedMapByName(name)
```

Selects map by name if present and stores it as preferred map.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `name` | `dynamic` | — | Resource or object name to resolve. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/mp_state.ml#L301)

<a id="constant-constant-mp-skill-baby-const-mp-skill-baby-0-src-mp-state-ml-1869550920"></a>
### MP_SKILL_BABY

```ml
const MP_SKILL_BABY = 0
```

Defines mp skill baby for the mp state subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/mp_state.ml#L36)

<a id="constant-constant-mp-skill-easy-const-mp-skill-easy-1-src-mp-state-ml-1518837875"></a>
### MP_SKILL_EASY

```ml
const MP_SKILL_EASY = 1
```

Defines mp skill easy for the mp state subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/mp_state.ml#L38)

<a id="constant-constant-mp-skill-hard-const-mp-skill-hard-3-src-mp-state-ml-1708034553"></a>
### MP_SKILL_HARD

```ml
const MP_SKILL_HARD = 3
```

Defines mp skill hard for the mp state subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/mp_state.ml#L42)

<a id="constant-constant-mp-skill-medium-const-mp-skill-medium-2-src-mp-state-ml-1152697202"></a>
### MP_SKILL_MEDIUM

```ml
const MP_SKILL_MEDIUM = 2
```

Defines mp skill medium for the mp state subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/mp_state.ml#L40)

<a id="constant-constant-mp-skill-nightmare-const-mp-skill-nightmare-4-src-mp-state-ml-2036951540"></a>
### MP_SKILL_NIGHTMARE

```ml
const MP_SKILL_NIGHTMARE = 4
```

Defines mp skill nightmare for the mp state subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/mp_state.ml#L44)

<a id="function-function-mp-stepmap-function-mp-stepmap-delta-src-mp-state-ml-637040561"></a>
### MP_StepMap

```ml
function MP_StepMap(delta)
```

Moves selected map index by delta with wraparound.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `delta` | `dynamic` | — | Delta value supplied to `MP_StepMap`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/mp_state.ml#L282)

<a id="function-function-mp-updateiwadfingerprint-function-mp-updateiwadfingerprint-src-mp-state-ml-1578752677"></a>
### MP_UpdateIwadFingerprint

```ml
function MP_UpdateIwadFingerprint()
```

Fingerprints every gameplay WAD in load order so host/client PWAD mismatches are rejected too.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/mp_state.ml#L358)
