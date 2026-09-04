# `src/console_cmd.ml`

[Home](README.md) · [Files](Files.md)

Parses console command text and performs gameplay or utility actions without owning any UI state.

Package: [`(global)`](Package-global-1952375359.md)

Reachable from entry: **yes**

## Imports

- `doomdef.ml` → [src/doomdef.ml](File-src-doomdef-ml-460406769.md)
- `doomstat.ml` → [src/doomstat.ml](File-src-doomstat-ml-1652708088.md)
- `g_game.ml` → [src/g_game.ml](File-src-g-game-ml-257299317.md)
- `i_system.ml` → [src/i_system.ml](File-src-i-system-ml-1632920966.md)
- `mp_state.ml` → [src/mp_state.ml](File-src-mp-state-ml-130741680.md)
- `p_enemy.ml` → [src/p_enemy.ml](File-src-p-enemy-ml-1875479956.md)
- `p_inter.ml` → [src/p_inter.ml](File-src-p-inter-ml-1430401638.md)
- `p_mobj.ml` → [src/p_mobj.ml](File-src-p-mobj-ml-1335564114.md)
- `p_tick.ml` → [src/p_tick.ml](File-src-p-tick-ml-887781845.md)
- `std/math.ml` → `../MiniLangCompilerOptimization/MiniLangCompilerPy/std/math.ml` — external dependency
- `std/string.ml` as `str` → `../MiniLangCompilerOptimization/MiniLangCompilerPy/std/string.ml` — external dependency

## Declarations

<a id="function-function-ccmd-ammo-function-ccmd-ammo-includekeys-src-console-cmd-ml-1938584826"></a>
### _CCMD_Ammo

```ml
function _CCMD_Ammo(includeKeys)
```

Implements IDFA and IDKFA with their original distinction over key ownership.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `includeKeys` | `dynamic` | — | Include keys value supplied to `_CCMD_Ammo`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/console_cmd.ml#L141)

<a id="function-function-ccmd-cheats-function-ccmd-cheats-src-console-cmd-ml-138875740"></a>
### _CCMD_Cheats

```ml
function _CCMD_Cheats()
```

Lists every supported single-player gameplay cheat with concise usage text.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/console_cmd.ml#L322)

<a id="function-function-ccmd-currentplayer-inline-function-ccmd-currentplayer-src-console-cmd-ml-695993155"></a>
### _CCMD_CurrentPlayer

```ml
inline function _CCMD_CurrentPlayer()
```

Resolves the checked local player record used by single-player cheat commands.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/console_cmd.ml#L61)

<a id="global-global-ccmd-direct-cheat-buffer-ccmd-direct-cheat-buffer-src-console-cmd-ml-615109058"></a>
### _ccmd_direct_cheat_buffer

```ml
_ccmd_direct_cheat_buffer
```

Rolling gameplay-key suffix used for classic, console-free IDCLEV entry. Stores the mutable ccmd direct cheat buffer text used by the console cmd subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/console_cmd.ml#L47)

<a id="function-function-ccmd-fps-function-ccmd-fps-src-console-cmd-ml-1890509428"></a>
### _CCMD_Fps

```ml
function _CCMD_Fps()
```

Toggles the in-game presentation-rate overlay independently of the window title.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/console_cmd.ml#L277)

<a id="function-function-ccmd-freeze-function-ccmd-freeze-src-console-cmd-ml-1128913844"></a>
### _CCMD_Freeze

```ml
function _CCMD_Freeze()
```

Toggles suspension of non-player thinkers and world specials.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/console_cmd.ml#L232)

<a id="function-function-ccmd-god-function-ccmd-god-src-console-cmd-ml-130539386"></a>
### _CCMD_God

```ml
function _CCMD_God()
```

Toggles canonical Doom god mode and restores a viable health value when enabling it.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/console_cmd.ml#L124)

<a id="function-function-ccmd-grantarsenal-function-ccmd-grantarsenal-player-includekeys-src-console-cmd-ml-2119057401"></a>
### _CCMD_GrantArsenal

```ml
function _CCMD_GrantArsenal(player, includeKeys)
```

Gives armor, every weapon, full carried ammunition, and optionally every key to the local player.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `player` | `dynamic` | — | Player state affected by the operation. |
| `includeKeys` | `dynamic` | — | Include keys value supplied to `_CCMD_GrantArsenal`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/console_cmd.ml#L93)

<a id="function-function-ccmd-help-function-ccmd-help-src-console-cmd-ml-151046288"></a>
### _CCMD_Help

```ml
function _CCMD_Help()
```

Describes console activation, navigation, logging, pause behavior, and utility commands.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/console_cmd.ml#L306)

<a id="function-function-ccmd-idclev-function-ccmd-idclev-argument-src-console-cmd-ml-1575269499"></a>
### _CCMD_IdClev

```ml
function _CCMD_IdClev(argument)
```

Validates a Doom II map number or Doom episode/map pair and queues the normal level transition.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `argument` | `dynamic` | — | Argument value supplied to `_CCMD_IdClev`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/console_cmd.ml#L186)

<a id="function-function-ccmd-invisible-function-ccmd-invisible-src-console-cmd-ml-1906055948"></a>
### _CCMD_Invisible

```ml
function _CCMD_Invisible()
```

Toggles persistent monster notarget behavior and immediately cancels existing locks and attacks when enabled.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/console_cmd.ml#L217)

<a id="function-function-ccmd-killmonsters-function-ccmd-killmonsters-src-console-cmd-ml-803689928"></a>
### _CCMD_KillMonsters

```ml
function _CCMD_KillMonsters()
```

Applies lethal damage to every living counted monster, lost soul, and Icon of Sin brain in the level.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/console_cmd.ml#L252)

<a id="function-function-ccmd-name-function-ccmd-name-argument-setname-src-console-cmd-ml-696852544"></a>
### _CCMD_Name

```ml
function _CCMD_Name(argument, setName)
```

Shows or changes the persistent local player name and announces it to an active multiplayer session.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `argument` | `dynamic` | — | Argument value supplied to `_CCMD_Name`. |
| `setName` | `dynamic` | — | Set name value supplied to `_CCMD_Name`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/console_cmd.ml#L287)

<a id="function-function-ccmd-noclip-function-ccmd-noclip-src-console-cmd-ml-557567636"></a>
### _CCMD_NoClip

```ml
function _CCMD_NoClip()
```

Toggles the player's collision-bypass cheat flag.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/console_cmd.ml#L154)

<a id="function-function-ccmd-onoff-inline-function-ccmd-onoff-enabled-src-console-cmd-ml-1446062606"></a>
### _CCMD_OnOff

```ml
inline function _CCMD_OnOff(enabled)
```

Formats a stable enabled/disabled suffix shared by toggle command responses.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `enabled` | `dynamic` | — | Whether the requested feature should be enabled. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/console_cmd.ml#L84)

<a id="function-function-ccmd-parsepositiveint-function-ccmd-parsepositiveint-text-src-console-cmd-ml-1640560571"></a>
### _CCMD_ParsePositiveInt

```ml
function _CCMD_ParsePositiveInt(text)
```

Parses one whitespace-trimmed positive decimal integer and rejects every non-digit byte.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `text` | `dynamic` | — | Text to process. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/console_cmd.ml#L167)

<a id="function-function-ccmd-requiregameplaycheat-inline-function-ccmd-requiregameplaycheat-requireplayer-src-console-cmd-ml-952942861"></a>
### _CCMD_RequireGameplayCheat

```ml
inline function _CCMD_RequireGameplayCheat(requirePlayer)
```

Rejects world-mutating commands outside a live single-player level to avoid network desynchronization.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `requirePlayer` | `dynamic` | — | Require player value supplied to `_CCMD_RequireGameplayCheat`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/console_cmd.ml#L71)

<a id="function-function-ccmd-resolvemobj-inline-function-ccmd-resolvemobj-node-src-console-cmd-ml-412015767"></a>
### _CCMD_ResolveMobj

```ml
inline function _CCMD_ResolveMobj(node)
```

Resolves one thinker node to its registered mobj owner for world command scans.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `node` | `dynamic` | — | Node value supplied to `_CCMD_ResolveMobj`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/console_cmd.ml#L244)

<a id="function-function-ccmd-result-inline-function-ccmd-result-handled-message-clearlog-closeconsole-src-console-cmd-ml-2050725376"></a>
### _CCMD_Result

```ml
inline function _CCMD_Result(handled, message, clearLog, closeConsole)
```

Constructs one normalized command result for the console UI boundary.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `handled` | `dynamic` | — | Handled value supplied to `_CCMD_Result`. |
| `message` | `dynamic` | — | Message text or payload to process. |
| `clearLog` | `dynamic` | — | Clear log value supplied to `_CCMD_Result`. |
| `closeConsole` | `dynamic` | — | Close console value supplied to `_CCMD_Result`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/console_cmd.ml#L55)

<a id="function-function-ccmd-directcheatresponder-function-ccmd-directcheatresponder-ev-src-console-cmd-ml-385065507"></a>
### CCMD_DirectCheatResponder

```ml
function CCMD_DirectCheatResponder(ev)
```

Detects classic IDCLEV plus two digits in ordinary gameplay without consuming movement keys.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `ev` | `dynamic` | — | Input event to process. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/console_cmd.ml#L371)

<a id="function-function-ccmd-execute-function-ccmd-execute-line-src-console-cmd-ml-1143111138"></a>
### CCMD_Execute

```ml
function CCMD_Execute(line)
```

Normalizes one input line and dispatches it to isolated command implementations.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `line` | `dynamic` | — | Map line or text line affected by the operation. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/console_cmd.ml#L337)

- [console_command_result_t](Type-console-command-result-t-1971412595.md) — struct
