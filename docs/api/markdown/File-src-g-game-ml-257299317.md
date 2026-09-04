# `src/g_game.ml`

[Home](README.md) · [Files](Files.md)

Implements high-level game loop control, transitions, and session state.

Package: [`(global)`](Package-global-1952375359.md)

Reachable from entry: **yes**

## Imports

- `am_map.ml` → [src/am_map.ml](File-src-am-map-ml-1409794280.md)
- `d_event.ml` → [src/d_event.ml](File-src-d-event-ml-1995118760.md)
- `d_main.ml` → [src/d_main.ml](File-src-d-main-ml-105344057.md)
- `doomdef.ml` → [src/doomdef.ml](File-src-doomdef-ml-460406769.md)
- `doomdef.ml` → [src/doomdef.ml](File-src-doomdef-ml-460406769.md)
- `doomstat.ml` → [src/doomstat.ml](File-src-doomstat-ml-1652708088.md)
- `dstrings.ml` → [src/dstrings.ml](File-src-dstrings-ml-567491523.md)
- `f_finale.ml` → [src/f_finale.ml](File-src-f-finale-ml-635076109.md)
- `g_game.ml` → [src/g_game.ml](File-src-g-game-ml-257299317.md)
- `hu_stuff.ml` → [src/hu_stuff.ml](File-src-hu-stuff-ml-1965779679.md)
- `i_system.ml` → [src/i_system.ml](File-src-i-system-ml-1632920966.md)
- `i_video.ml` → [src/i_video.ml](File-src-i-video-ml-140536292.md)
- `m_argv.ml` → [src/m_argv.ml](File-src-m-argv-ml-728984635.md)
- `m_menu.ml` → [src/m_menu.ml](File-src-m-menu-ml-331716860.md)
- `m_misc.ml` → [src/m_misc.ml](File-src-m-misc-ml-906836777.md)
- `m_random.ml` → [src/m_random.ml](File-src-m-random-ml-1659574948.md)
- `mp_platform.ml` → [src/mp_platform.ml](File-src-mp-platform-ml-1361006310.md)
- `p_local.ml` → [src/p_local.ml](File-src-p-local-ml-1043095437.md)
- `p_saveg.ml` → [src/p_saveg.ml](File-src-p-saveg-ml-1704891910.md)
- `p_setup.ml` → [src/p_setup.ml](File-src-p-setup-ml-2057900615.md)
- `p_tick.ml` → [src/p_tick.ml](File-src-p-tick-ml-887781845.md)
- `r_data.ml` → [src/r_data.ml](File-src-r-data-ml-1686270288.md)
- `r_renderer.ml` → [src/r_renderer.ml](File-src-r-renderer-ml-72894217.md)
- `r_sky.ml` → [src/r_sky.ml](File-src-r-sky-ml-918225537.md)
- `s_sound.ml` → [src/s_sound.ml](File-src-s-sound-ml-1485495390.md)
- `sounds.ml` → [src/sounds.ml](File-src-sounds-ml-1875364049.md)
- `st_stuff.ml` → [src/st_stuff.ml](File-src-st-stuff-ml-811030939.md)
- `std/fs.ml` as `fs` → `../MiniLangCompilerOptimization/MiniLangCompilerPy/std/fs.ml` — external dependency
- `std/math.ml` → `../MiniLangCompilerOptimization/MiniLangCompilerPy/std/math.ml` — external dependency
- `v_video.ml` → [src/v_video.ml](File-src-v-video-ml-592999939.md)
- `w_wad.ml` → [src/w_wad.ml](File-src-w-wad-ml-893006035.md)
- `wi_stuff.ml` → [src/wi_stuff.ml](File-src-wi-stuff-ml-450049266.md)
- `z_zone.ml` → [src/z_zone.ml](File-src-z-zone-ml-1788911354.md)

## Declarations

<a id="function-function-g-buttonisdown-inline-function-g-buttonisdown-arr-idx-src-g-game-ml-1460040395"></a>
### _G_ButtonIsDown

```ml
inline function _G_ButtonIsDown(arr, idx)
```

Reads one checked mouse/joystick button from an arbitrary button sequence.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `arr` | `dynamic` | — | Arr value supplied to `_G_ButtonIsDown`. |
| `idx` | `dynamic` | — | Zero-based element or table index. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/g_game.ml#L1351)

<a id="function-function-g-copyfrags-function-g-copyfrags-fr-src-g-game-ml-2080609660"></a>
### _G_CopyFrags

```ml
function _G_CopyFrags(fr)
```

Copies a frag row into a fixed MAXPLAYERS array without retaining the caller's storage.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `fr` | `dynamic` | — | Fr value supplied to `_G_CopyFrags`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/g_game.ml#L269)

<a id="global-global-g-cpars-g-cpars-src-g-game-ml-398382342"></a>
### _G_cpars

```ml
_G_cpars
```

Stores the g cpars collection used by the g game subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/g_game.ml#L234)

<a id="global-global-g-dclicks-g-dclicks-src-g-game-ml-286026098"></a>
### _G_dclicks

```ml
_G_dclicks
```

Tracks the mutable g dclicks value used by the g game subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/g_game.ml#L1799)

<a id="global-global-g-defdemo-g-defdemo-src-g-game-ml-1120746380"></a>
### _G_defDemo

```ml
_G_defDemo
```

Stores the mutable g def demo text used by the g game subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/g_game.ml#L1665)

<a id="global-global-g-defepisode-g-defepisode-src-g-game-ml-1366512802"></a>
### _G_defEpisode

```ml
_G_defEpisode
```

Tracks the mutable g def episode value used by the g game subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/g_game.ml#L1659)

<a id="global-global-g-defmap-g-defmap-src-g-game-ml-1213275754"></a>
### _G_defMap

```ml
_G_defMap
```

Tracks the mutable g def map value used by the g game subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/g_game.ml#L1662)

<a id="global-global-g-defskill-g-defskill-src-g-game-ml-635313274"></a>
### _G_defSkill

```ml
_G_defSkill
```

Exposes `skill_t.sk_medium` through the legacy `_G_defSkill` alias.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/g_game.ml#L1656)

<a id="global-global-g-demo-p-g-demo-p-src-g-game-ml-1000289382"></a>
### _G_demo_p

```ml
_G_demo_p
```

Tracks the mutable g demo p value used by the g game subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/g_game.ml#L1677)

<a id="global-global-g-demoend-g-demoend-src-g-game-ml-40657852"></a>
### _G_demoend

```ml
_G_demoend
```

Tracks the mutable g demoend value used by the g game subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/g_game.ml#L1680)

<a id="function-function-g-demoreadu8-inline-function-g-demoreadu8-src-g-game-ml-1324525721"></a>
### _G_DemoReadU8

```ml
inline function _G_DemoReadU8()
```

Consumes one unsigned demo byte, returning zero past the buffer while keeping the cursor monotonic.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/g_game.ml#L1011)

<a id="function-function-g-demowriteu8-inline-function-g-demowriteu8-v-src-g-game-ml-705867589"></a>
### _G_DemoWriteU8

```ml
inline function _G_DemoWriteU8(v)
```

Appends one masked byte to the bounded demo recording buffer and advances its cursor.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `v` | `dynamic` | — | Value consumed by the operation. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/g_game.ml#L1025)

<a id="global-global-g-devautofire-g-devautofire-src-g-game-ml-1983252988"></a>
### _G_devAutoFire

```ml
_G_devAutoFire
```

Tracks whether g dev auto fire is active in the g game subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/g_game.ml#L1787)

<a id="global-global-g-devautoforward-g-devautoforward-src-g-game-ml-1985919482"></a>
### _G_devAutoForward

```ml
_G_devAutoForward
```

Tracks whether g dev auto forward is active in the g game subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/g_game.ml#L1781)

<a id="global-global-g-devautoturn-g-devautoturn-src-g-game-ml-776674202"></a>
### _G_devAutoTurn

```ml
_G_devAutoTurn
```

Tracks whether g dev auto turn is active in the g game subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/g_game.ml#L1784)

<a id="global-global-g-devautouse-g-devautouse-src-g-game-ml-1986513698"></a>
### _G_devAutoUse

```ml
_G_devAutoUse
```

Tracks whether g dev auto use is active in the g game subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/g_game.ml#L1790)

<a id="global-global-g-devautouseticker-g-devautouseticker-src-g-game-ml-1056386154"></a>
### _G_devAutoUseTicker

```ml
_G_devAutoUseTicker
```

Tracks the mutable g dev auto use ticker value used by the g game subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/g_game.ml#L1793)

<a id="global-global-g-devinputinit-g-devinputinit-src-g-game-ml-1791259498"></a>
### _G_devInputInit

```ml
_G_devInputInit
```

Tracks whether g dev input init is active in the g game subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/g_game.ml#L1778)

<a id="global-global-g-devprintticker-g-devprintticker-src-g-game-ml-686649290"></a>
### _G_devPrintTicker

```ml
_G_devPrintTicker
```

Tracks the mutable g dev print ticker value used by the g game subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/g_game.ml#L1796)

<a id="function-function-g-ensuredir-function-g-ensuredir-path-src-g-game-ml-1022131921"></a>
### _G_EnsureDir

```ml
function _G_EnsureDir(path)
```

Creates a directory if it is missing.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `path` | `dynamic` | — | Filesystem path to process. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/g_game.ml#L329)

<a id="function-function-g-ensureinputstate-function-g-ensureinputstate-src-g-game-ml-1527451400"></a>
### _G_EnsureInputState

```ml
function _G_EnsureInputState()
```

Guarantees fixed keyboard, mouse, and joystick state buffers before responder or ticcmd access.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/g_game.ml#L1299)

<a id="function-function-g-envstring-function-g-envstring-name-src-g-game-ml-237525493"></a>
### _G_EnvString

```ml
function _G_EnvString(name)
```

Reads a Windows environment variable as a MiniLang string.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `name` | `dynamic` | — | Resource or object name to resolve. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/g_game.ml#L283)

<a id="function-function-g-idiv-inline-function-g-idiv-a-b-src-g-game-ml-343808028"></a>
### _G_IDiv

```ml
inline function _G_IDiv(a, b)
```

Truncates movement/input quotients toward zero and returns zero for invalid divisors.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `a` | `dynamic` | — | First input operand. |
| `b` | `dynamic` | — | Second input operand. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/g_game.ml#L1321)

<a id="function-function-g-initdevinputtweaks-function-g-initdevinputtweaks-src-g-game-ml-1876036374"></a>
### _G_InitDevInputTweaks

```ml
function _G_InitDevInputTweaks()
```

Parses developer auto-input flags once and seeds their persistent movement/fire toggles.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/g_game.ml#L1382)

<a id="global-global-g-joybuttons-g-joybuttons-src-g-game-ml-1094516678"></a>
### _G_joybuttons

```ml
_G_joybuttons
```

Stores the g joybuttons collection used by the g game subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/g_game.ml#L1769)

<a id="global-global-g-joyxmove-g-joyxmove-src-g-game-ml-336720862"></a>
### _G_joyxmove

```ml
_G_joyxmove
```

Tracks the mutable g joyxmove value used by the g game subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/g_game.ml#L1772)

<a id="global-global-g-joyymove-g-joyymove-src-g-game-ml-1341654546"></a>
### _G_joyymove

```ml
_G_joyymove
```

Tracks the mutable g joyymove value used by the g game subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/g_game.ml#L1775)

<a id="global-global-g-keydown-g-keydown-src-g-game-ml-1558570618"></a>
### _G_keydown

```ml
_G_keydown
```

Tracks the mutable g keydown value used by the g game subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/g_game.ml#L1754)

<a id="function-function-g-keyindex-inline-function-g-keyindex-k-src-g-game-ml-82910566"></a>
### _G_KeyIndex

```ml
inline function _G_KeyIndex(k)
```

Rejects key codes outside the fixed input-state byte table.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `k` | `dynamic` | — | K value supplied to `_G_KeyIndex`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/g_game.ml#L1331)

<a id="function-function-g-keyisdown-inline-function-g-keyisdown-k-src-g-game-ml-40266776"></a>
### _G_KeyIsDown

```ml
inline function _G_KeyIsDown(k)
```

Reads one checked keyboard state bit from the current input snapshot.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `k` | `dynamic` | — | K value supplied to `_G_KeyIsDown`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/g_game.ml#L1340)

<a id="global-global-g-loadname-g-loadname-src-g-game-ml-1077018214"></a>
### _G_loadName

```ml
_G_loadName
```

Stores the mutable g load name text used by the g game subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/g_game.ml#L1668)

<a id="global-global-g-mousebuttons-g-mousebuttons-src-g-game-ml-785861070"></a>
### _G_mousebuttons

```ml
_G_mousebuttons
```

Stores the g mousebuttons collection used by the g game subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/g_game.ml#L1760)

<a id="global-global-g-mousex-g-mousex-src-g-game-ml-321035690"></a>
### _G_mousex

```ml
_G_mousex
```

Tracks the mutable g mousex value used by the g game subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/g_game.ml#L1763)

<a id="global-global-g-mousey-g-mousey-src-g-game-ml-477279090"></a>
### _G_mousey

```ml
_G_mousey
```

Tracks the mutable g mousey value used by the g game subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/g_game.ml#L1766)

<a id="global-global-g-pars-g-pars-src-g-game-ml-378912174"></a>
### _G_pars

```ml
_G_pars
```

Stores the g pars collection used by the g game subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/g_game.ml#L225)

<a id="function-function-g-partimetics-function-g-partimetics-episode-map-src-g-game-ml-850773547"></a>
### _G_ParTimeTics

```ml
function _G_ParTimeTics(episode, map)
```

Looks up the vanilla par time for the active episode and map in game tics.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `episode` | `dynamic` | — | Episode value supplied to `_G_ParTimeTics`. |
| `map` | `dynamic` | — | Map value supplied to `_G_ParTimeTics`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/g_game.ml#L245)

<a id="function-function-g-pathbasename-function-g-pathbasename-path-src-g-game-ml-643191681"></a>
### _G_PathBaseName

```ml
function _G_PathBaseName(path)
```

Extracts the final filename component from a WAD path.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `path` | `dynamic` | — | Filesystem path to process. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/g_game.ml#L294)

<a id="function-function-g-sanitizesavedirname-function-g-sanitizesavedirname-name-src-g-game-ml-702120345"></a>
### _G_SanitizeSaveDirName

```ml
function _G_SanitizeSaveDirName(name)
```

Converts a WAD filename into a safe directory name.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `name` | `dynamic` | — | Resource or object name to resolve. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/g_game.ml#L310)

<a id="global-global-g-savedesc-g-savedesc-src-g-game-ml-231964750"></a>
### _G_saveDesc

```ml
_G_saveDesc
```

Stores the mutable g save desc text used by the g game subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/g_game.ml#L1674)

<a id="function-function-g-savedir-function-g-savedir-src-g-game-ml-1402859284"></a>
### _G_SaveDir

```ml
function _G_SaveDir()
```

Resolves and creates the per-WAD savegame directory.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/g_game.ml#L339)

<a id="function-function-g-savefilename-function-g-savefilename-slot-src-g-game-ml-499797334"></a>
### _G_SaveFileName

```ml
function _G_SaveFileName(slot)
```

Builds the per-WAD savegame path under %APPDATA%\MiniDoom.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `slot` | `dynamic` | — | Slot value supplied to `_G_SaveFileName`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/g_game.ml#L370)

<a id="global-global-g-saveslot-g-saveslot-src-g-game-ml-1064472186"></a>
### _G_saveSlot

```ml
_G_saveSlot
```

Tracks the mutable g save slot value used by the g game subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/g_game.ml#L1671)

<a id="function-function-g-showloadingframe-function-g-showloadingframe-text-src-g-game-ml-1499010683"></a>
### _G_ShowLoadingFrame

```ml
function _G_ShowLoadingFrame(text)
```

Presents a loading label and forces one renderer/event pulse during synchronous map setup.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `text` | `dynamic` | — | Text to process. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/g_game.ml#L654)

<a id="global-global-g-turnheld-g-turnheld-src-g-game-ml-715166590"></a>
### _G_turnheld

```ml
_G_turnheld
```

Tracks the mutable g turnheld value used by the g game subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/g_game.ml#L1757)

<a id="global-global-angleturn-angleturn-src-g-game-ml-223222562"></a>
### angleturn

```ml
angleturn
```

Stores the angleturn collection used by the g game subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/g_game.ml#L1706)

<a id="global-global-demobuffer-demobuffer-src-g-game-ml-447335068"></a>
### demobuffer

```ml
demobuffer
```

Holds the optional demobuffer resource used by the g game subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/g_game.ml#L1684)

<a id="constant-constant-demomarker-const-demomarker-128-src-g-game-ml-1017163172"></a>
### DEMOMARKER

```ml
const DEMOMARKER = 128
```

Defines demomarker for the g game subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/g_game.ml#L1699)

<a id="global-global-demoname-demoname-src-g-game-ml-571449254"></a>
### demoname

```ml
demoname
```

Stores the mutable demoname text used by the g game subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/g_game.ml#L1682)

<a id="global-global-forwardmove-forwardmove-src-g-game-ml-1588386542"></a>
### forwardmove

```ml
forwardmove
```

Stores the forwardmove collection used by the g game subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/g_game.ml#L1702)

<a id="function-function-g-beginrecording-function-g-beginrecording-src-g-game-ml-1388602672"></a>
### G_BeginRecording

```ml
function G_BeginRecording()
```

Writes the deterministic demo header and arms command recording for subsequent tics.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/g_game.ml#L1117)

<a id="function-function-g-buildticcmd-function-g-buildticcmd-cmd-src-g-game-ml-571766794"></a>
### G_BuildTiccmd

```ml
function G_BuildTiccmd(cmd)
```

Samples current controls into a bounded Doom ticcmd, including pause/save special commands.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `cmd` | `dynamic` | — | Cmd value supplied to `G_BuildTiccmd`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/g_game.ml#L1509)

<a id="function-function-g-checkdemostatus-function-g-checkdemostatus-src-g-game-ml-2114324282"></a>
### G_CheckDemoStatus

```ml
function G_CheckDemoStatus()
```

Ends active demo recording/playback flags and reports that the transition was handled.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/g_game.ml#L1174)

<a id="function-function-g-checkspot-function-g-checkspot-playernum-mthing-src-g-game-ml-22785680"></a>
### G_CheckSpot

```ml
function G_CheckSpot(playernum, mthing)
```

Rejects occupied multiplayer spawn points using the current player mobj as collision probe.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `playernum` | `dynamic` | — | Index identifying player. |
| `mthing` | `dynamic` | — | Mthing value supplied to `G_CheckSpot`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/g_game.ml#L603)

<a id="function-function-g-clearinputstate-function-g-clearinputstate-src-g-game-ml-134955208"></a>
### G_ClearInputState

```ml
function G_ClearInputState()
```

Releases every latched gameplay control when an exclusive UI captures input.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/g_game.ml#L1359)

<a id="function-function-g-cmdchecksum-function-g-cmdchecksum-cmd-src-g-game-ml-217711408"></a>
### G_CmdChecksum

```ml
function G_CmdChecksum(cmd)
```

Folds all serialized ticcmd fields into the consistency checksum used by demo/network checks.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `cmd` | `dynamic` | — | Cmd value supplied to `G_CmdChecksum`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/g_game.ml#L447)

<a id="extern_function-extern-function-g-createdirectoryw-extern-function-g-createdirectoryw-path-as-wstr-security-as-ptr-from-kernel32-dll-symbol-createdirectoryw-returns-bool-src-g-game-ml-1940871061"></a>
### G_CreateDirectoryW

```ml
extern function G_CreateDirectoryW(path as wstr, security as ptr) from "kernel32.dll" symbol "CreateDirectoryW" returns bool
```

Creates a directory for per-WAD savegame storage.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `path` | `wstr` | — | Filesystem path to process. |
| `security` | `ptr` | — | Optional native security-attributes pointer. |


**Returns:** The resulting directory for per-WAD savegame storage.

[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/g_game.ml#L62)

<a id="function-function-g-deathmatchspawnplayer-function-g-deathmatchspawnplayer-playernum-src-g-game-ml-835215021"></a>
### G_DeathMatchSpawnPlayer

```ml
function G_DeathMatchSpawnPlayer(playernum)
```

Tries random unoccupied deathmatch starts before falling back to the player's cooperative start.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `playernum` | `dynamic` | — | Index identifying player. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/g_game.ml#L74)

<a id="function-function-g-deferedinitnew-function-g-deferedinitnew-skill-episode-map-src-g-game-ml-2113490110"></a>
### G_DeferedInitNew

```ml
function G_DeferedInitNew(skill, episode, map)
```

Stores a requested skill/episode/map triple for execution at the next game-action boundary.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `skill` | `dynamic` | — | Skill value supplied to `G_DeferedInitNew`. |
| `episode` | `dynamic` | — | Episode value supplied to `G_DeferedInitNew`. |
| `map` | `dynamic` | — | Map value supplied to `G_DeferedInitNew`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/g_game.ml#L188)

<a id="function-function-g-deferedplaydemo-function-g-deferedplaydemo-demo-src-g-game-ml-729185157"></a>
### G_DeferedPlayDemo

```ml
function G_DeferedPlayDemo(demo)
```

Queues a named demo lump for playback on the next game-action pass.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `demo` | `dynamic` | — | Demo value supplied to `G_DeferedPlayDemo`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/g_game.ml#L202)

<a id="function-function-g-docompleted-function-g-docompleted-src-g-game-ml-1051435032"></a>
### G_DoCompleted

```ml
function G_DoCompleted()
```

Finalizes player totals, resolves the next map, builds wminfo, and enters intermission.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/g_game.ml#L713)

<a id="function-function-g-doloadgame-function-g-doloadgame-src-g-game-ml-157512896"></a>
### G_DoLoadGame

```ml
function G_DoLoadGame()
```

Validates a save header, rebuilds the map, and restores archived players, world, thinkers, and specials.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/g_game.ml#L380)

<a id="function-function-g-doloadlevel-function-g-doloadlevel-src-g-game-ml-2077927002"></a>
### G_DoLoadLevel

```ml
function G_DoLoadLevel()
```

Clears per-level player state, runs map setup, and starts the status bar, HUD, and renderer view.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/g_game.ml#L636)

<a id="function-function-g-donewgame-function-g-donewgame-src-g-game-ml-637656350"></a>
### G_DoNewGame

```ml
function G_DoNewGame()
```

Consumes the deferred new-game parameters and clears the pending game action.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/g_game.ml#L917)

<a id="function-function-g-doplaydemo-function-g-doplaydemo-src-g-game-ml-869619344"></a>
### G_DoPlayDemo

```ml
function G_DoPlayDemo()
```

Parses a demo header, configures recorded game flags/players, and starts playback on its map.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/g_game.ml#L924)

<a id="function-function-g-doreborn-function-g-doreborn-playernum-src-g-game-ml-759480255"></a>
### G_DoReborn

```ml
function G_DoReborn(playernum)
```

Respawns a dead player at a valid deathmatch or cooperative start while preserving netgame rules.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `playernum` | `dynamic` | — | Index identifying player. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/g_game.ml#L668)

<a id="function-function-g-dosavegame-function-g-dosavegame-src-g-game-ml-785828524"></a>
### G_DoSaveGame

```ml
function G_DoSaveGame()
```

Saves do Save Game state for the gameplay system.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/g_game.ml#L864)

<a id="function-function-g-doworlddone-function-g-doworlddone-src-g-game-ml-207052154"></a>
### G_DoWorldDone

```ml
function G_DoWorldDone()
```

Applies the intermission's next-map result and synchronously loads the destination level.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/g_game.ml#L843)

<a id="function-function-g-exitlevel-function-g-exitlevel-src-g-game-ml-709776872"></a>
### G_ExitLevel

```ml
function G_ExitLevel()
```

Queues normal map completion while clearing any previously selected secret-exit route.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/g_game.ml#L1184)

<a id="extern_function-extern-function-g-getenvironmentvariablew-extern-function-g-getenvironmentvariablew-name-as-wstr-buffer-as-bytes-size-as-int-from-kernel32-dll-symbol-getenvironmentvariablew-returns-int-src-g-game-ml-1575367591"></a>
### G_GetEnvironmentVariableW

```ml
extern function G_GetEnvironmentVariableW(name as wstr, buffer as bytes, size as int) from "kernel32.dll" symbol "GetEnvironmentVariableW" returns int
```

Reads Windows environment variables for user-specific savegame storage.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `name` | `wstr` | — | Resource or object name to resolve. |
| `buffer` | `bytes` | — | Buffer that supplies or receives data. |
| `size` | `int` | — | Requested size in bytes or elements. |


**Returns:** The requested Windows environment variables for user-specific savegame storage.

[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/g_game.ml#L69)

<a id="function-function-g-initnew-function-g-initnew-skill-episode-map-src-g-game-ml-1535045346"></a>
### G_InitNew

```ml
function G_InitNew(skill, episode, map)
```

Commits skill/map selection, resets player run state, and queues the selected level for loading.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `skill` | `dynamic` | — | Skill value supplied to `G_InitNew`. |
| `episode` | `dynamic` | — | Episode value supplied to `G_InitNew`. |
| `map` | `dynamic` | — | Map value supplied to `G_InitNew`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/g_game.ml#L124)

<a id="function-function-g-initplayer-function-g-initplayer-playernum-src-g-game-ml-279662107"></a>
### G_InitPlayer

```ml
function G_InitPlayer(playernum)
```

Resets one player's counters, view state, inventory defaults, and transient powers for a new run.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `playernum` | `dynamic` | — | Index identifying player. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/g_game.ml#L459)

<a id="function-function-g-loadgame-function-g-loadgame-name-src-g-game-ml-681417797"></a>
### G_LoadGame

```ml
function G_LoadGame(name)
```

Records a save path and defers deserialization to the central game-action dispatcher.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `name` | `dynamic` | — | Resource or object name to resolve. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/g_game.ml#L212)

<a id="function-function-g-playdemo-function-g-playdemo-name-src-g-game-ml-737594289"></a>
### G_PlayDemo

```ml
function G_PlayDemo(name)
```

Stores the requested demo lump and defers playback setup through the game-action dispatcher.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `name` | `dynamic` | — | Resource or object name to resolve. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/g_game.ml#L1145)

<a id="function-function-g-playerfinishlevel-function-g-playerfinishlevel-playernum-src-g-game-ml-2138977871"></a>
### G_PlayerFinishLevel

```ml
function G_PlayerFinishLevel(playernum)
```

Controls player Finish Level transitions in the gameplay system.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `playernum` | `dynamic` | — | Index identifying player. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/g_game.ml#L472)

<a id="function-function-g-playerreborn-function-g-playerreborn-playernum-src-g-game-ml-1384052151"></a>
### G_PlayerReborn

```ml
function G_PlayerReborn(playernum)
```

Reinitializes a dead player loadout while preserving accumulated level/frags statistics.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `playernum` | `dynamic` | — | Index identifying player. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/g_game.ml#L507)

<a id="function-function-g-processgameactiononly-function-g-processgameactiononly-src-g-game-ml-1148964690"></a>
### G_ProcessGameActionOnly

```ml
function G_ProcessGameActionOnly()
```

Processes deferred game actions while skipping gameplay tick simulation.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/g_game.ml#L1260)

<a id="function-function-g-processpendinggameaction-function-g-processpendinggameaction-src-g-game-ml-1102488064"></a>
### G_ProcessPendingGameAction

```ml
function G_ProcessPendingGameAction()
```

Executes deferred game actions without advancing world simulation.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/g_game.ml#L1227)

<a id="function-function-g-readdemoticcmd-function-g-readdemoticcmd-cmd-src-g-game-ml-1869050758"></a>
### G_ReadDemoTiccmd

```ml
function G_ReadDemoTiccmd(cmd)
```

Decodes one four-byte Doom demo command or terminates playback at the marker/end of buffer.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `cmd` | `dynamic` | — | Cmd value supplied to `G_ReadDemoTiccmd`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/g_game.ml#L1040)

<a id="function-function-g-recorddemo-function-g-recorddemo-name-src-g-game-ml-898777841"></a>
### G_RecordDemo

```ml
function G_RecordDemo(name)
```

Allocates a recording buffer, writes the Doom demo header, and marks play as non-user recording.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `name` | `dynamic` | — | Resource or object name to resolve. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/g_game.ml#L1088)

<a id="function-function-g-responder-function-g-responder-ev-src-g-game-ml-1836286565"></a>
### G_Responder

```ml
function G_Responder(ev)
```

Applies keyboard/mouse/joystick events and handles screenshot, pause, and spy controls.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `ev` | `dynamic` | — | Input event to process. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/g_game.ml#L1419)

<a id="function-function-g-savegame-function-g-savegame-slot-description-src-g-game-ml-1617746172"></a>
### G_SaveGame

```ml
function G_SaveGame(slot, description)
```

Stores a slot/description pair and defers serialization to the central game-action dispatcher.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `slot` | `dynamic` | — | Slot value supplied to `G_SaveGame`. |
| `description` | `dynamic` | — | Description value supplied to `G_SaveGame`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/g_game.ml#L999)

<a id="function-function-g-screenshot-function-g-screenshot-src-g-game-ml-2062966032"></a>
### G_ScreenShot

```ml
function G_ScreenShot()
```

Queues a uniquely named PCX screenshot through the deferred action system.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/g_game.ml#L1501)

<a id="function-function-g-secretexitlevel-function-g-secretexitlevel-src-g-game-ml-569091152"></a>
### G_SecretExitLevel

```ml
function G_SecretExitLevel()
```

Queues normal map completion and clears any pending secret-exit route.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/g_game.ml#L1193)

<a id="function-function-g-ticker-function-g-ticker-src-g-game-ml-1573207808"></a>
### G_Ticker

```ml
function G_Ticker()
```

Dispatches pending actions, net respawns, and exactly one subsystem ticker for the current gamestate.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/g_game.ml#L1265)

<a id="function-function-g-timedemo-function-g-timedemo-name-src-g-game-ml-1837173681"></a>
### G_TimeDemo

```ml
function G_TimeDemo(name)
```

Starts timed demo playback with rendering/tic counters reset for benchmark reporting.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `name` | `dynamic` | — | Resource or object name to resolve. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/g_game.ml#L1157)

<a id="function-function-g-worlddone-function-g-worlddone-src-g-game-ml-963713764"></a>
### G_WorldDone

```ml
function G_WorldDone()
```

Advances from intermission to the next level or commercial finale route.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/g_game.ml#L1206)

<a id="function-function-g-writedemoticcmd-function-g-writedemoticcmd-cmd-src-g-game-ml-1012412346"></a>
### G_WriteDemoTiccmd

```ml
function G_WriteDemoTiccmd(cmd)
```

Encodes one ticcmd into the four-byte Doom demo format or stops cleanly near buffer capacity.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `cmd` | `dynamic` | — | Cmd value supplied to `G_WriteDemoTiccmd`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/g_game.ml#L1066)

<a id="global-global-gameaction-gameaction-src-g-game-ml-1126905070"></a>
### gameaction

```ml
gameaction
```

Exposes `gameaction_t.ga_nothing` through the legacy `gameaction` alias.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/g_game.ml#L1650)

<a id="global-global-joybfire-joybfire-src-g-game-ml-1540191490"></a>
### joybfire

```ml
joybfire
```

Tracks the mutable joybfire value used by the g game subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/g_game.ml#L1739)

<a id="global-global-joybspeed-joybspeed-src-g-game-ml-499045214"></a>
### joybspeed

```ml
joybspeed
```

Tracks the mutable joybspeed value used by the g game subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/g_game.ml#L1745)

<a id="global-global-joybstrafe-joybstrafe-src-g-game-ml-277271300"></a>
### joybstrafe

```ml
joybstrafe
```

Tracks the mutable joybstrafe value used by the g game subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/g_game.ml#L1741)

<a id="global-global-joybuse-joybuse-src-g-game-ml-698870762"></a>
### joybuse

```ml
joybuse
```

Tracks the mutable joybuse value used by the g game subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/g_game.ml#L1743)

<a id="global-global-key-down-key-down-src-g-game-ml-1897893674"></a>
### key_down

```ml
key_down
```

Tracks the mutable key down value used by the g game subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/g_game.ml#L1717)

<a id="global-global-key-fire-key-fire-src-g-game-ml-1113399766"></a>
### key_fire

```ml
key_fire
```

Tracks the mutable key fire value used by the g game subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/g_game.ml#L1723)

<a id="global-global-key-left-key-left-src-g-game-ml-1785251996"></a>
### key_left

```ml
key_left
```

Tracks the mutable key left value used by the g game subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/g_game.ml#L1713)

<a id="global-global-key-right-key-right-src-g-game-ml-1358889642"></a>
### key_right

```ml
key_right
```

Tracks the mutable key right value used by the g game subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/g_game.ml#L1711)

<a id="global-global-key-speed-key-speed-src-g-game-ml-151728554"></a>
### key_speed

```ml
key_speed
```

Tracks the mutable key speed value used by the g game subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/g_game.ml#L1729)

<a id="global-global-key-strafe-key-strafe-src-g-game-ml-1683022464"></a>
### key_strafe

```ml
key_strafe
```

Tracks the mutable key strafe value used by the g game subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/g_game.ml#L1727)

<a id="global-global-key-strafeleft-key-strafeleft-src-g-game-ml-806048250"></a>
### key_strafeleft

```ml
key_strafeleft
```

Tracks the mutable key strafeleft value used by the g game subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/g_game.ml#L1719)

<a id="global-global-key-straferight-key-straferight-src-g-game-ml-175857922"></a>
### key_straferight

```ml
key_straferight
```

Tracks the mutable key straferight value used by the g game subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/g_game.ml#L1721)

<a id="global-global-key-up-key-up-src-g-game-ml-1760166048"></a>
### key_up

```ml
key_up
```

Tracks the mutable key up value used by the g game subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/g_game.ml#L1715)

<a id="global-global-key-use-key-use-src-g-game-ml-718989558"></a>
### key_use

```ml
key_use
```

Tracks the mutable key use value used by the g game subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/g_game.ml#L1725)

<a id="global-global-maxplmove-maxplmove-src-g-game-ml-1830133026"></a>
### MAXPLMOVE

```ml
MAXPLMOVE
```

Tracks the mutable maxplmove value used by the g game subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/g_game.ml#L1708)

<a id="global-global-mousebfire-mousebfire-src-g-game-ml-1712029640"></a>
### mousebfire

```ml
mousebfire
```

Tracks the mutable mousebfire value used by the g game subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/g_game.ml#L1732)

<a id="global-global-mousebforward-mousebforward-src-g-game-ml-1992062026"></a>
### mousebforward

```ml
mousebforward
```

Tracks the mutable mousebforward value used by the g game subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/g_game.ml#L1736)

<a id="global-global-mousebstrafe-mousebstrafe-src-g-game-ml-441133422"></a>
### mousebstrafe

```ml
mousebstrafe
```

Tracks the mutable mousebstrafe value used by the g game subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/g_game.ml#L1734)

<a id="global-global-netdemo-netdemo-src-g-game-ml-1928535650"></a>
### netdemo

```ml
netdemo
```

Tracks whether netdemo is active in the g game subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/g_game.ml#L1686)

<a id="constant-constant-numkeys-const-numkeys-256-src-g-game-ml-1539140296"></a>
### NUMKEYS

```ml
const NUMKEYS = 256
```

Defines the numkeys count used by the g game subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/g_game.ml#L1693)

<a id="global-global-secretexit-secretexit-src-g-game-ml-1297283370"></a>
### secretexit

```ml
secretexit
```

Tracks whether secretexit is active in the g game subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/g_game.ml#L1652)

<a id="global-global-sendpause-sendpause-src-g-game-ml-1022112046"></a>
### sendpause

```ml
sendpause
```

Tracks whether sendpause is active in the g game subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/g_game.ml#L1748)

<a id="global-global-sendsave-sendsave-src-g-game-ml-1132862868"></a>
### sendsave

```ml
sendsave
```

Tracks whether sendsave is active in the g game subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/g_game.ml#L1750)

<a id="global-global-sidemove-sidemove-src-g-game-ml-1374665338"></a>
### sidemove

```ml
sidemove
```

Stores the sidemove collection used by the g game subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/g_game.ml#L1704)

<a id="constant-constant-slowturntics-const-slowturntics-6-src-g-game-ml-932527759"></a>
### SLOWTURNTICS

```ml
const SLOWTURNTICS = 6
```

Defines slowturntics for the g game subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/g_game.ml#L1695)

<a id="global-global-starttime-starttime-src-g-game-ml-1716355686"></a>
### starttime

```ml
starttime
```

Tracks the mutable starttime value used by the g game subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/g_game.ml#L1690)

<a id="global-global-timingdemo-timingdemo-src-g-game-ml-2089475456"></a>
### timingdemo

```ml
timingdemo
```

Tracks whether timingdemo is active in the g game subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/g_game.ml#L1688)

<a id="constant-constant-turbothreshold-const-turbothreshold-50-src-g-game-ml-1488624782"></a>
### TURBOTHRESHOLD

```ml
const TURBOTHRESHOLD = 50
```

Defines turbothreshold for the g game subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/g_game.ml#L1697)

<a id="constant-constant-versionsize-const-versionsize-16-src-g-game-ml-1829816700"></a>
### VERSIONSIZE

```ml
const VERSIONSIZE = 16
```

Defines versionsize for the g game subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/g_game.ml#L221)
