# `src/m_menu.ml`

[Home](README.md) · [Files](Files.md)

Implements Doom menus plus shared interactive/CLI multiplayer session startup.

Package: [`(global)`](Package-global-1952375359.md)

Reachable from entry: **yes**

## Imports

- `d_event.ml` → [src/d_event.ml](File-src-d-event-ml-1995118760.md)
- `d_main.ml` → [src/d_main.ml](File-src-d-main-ml-105344057.md)
- `doomdef.ml` → [src/doomdef.ml](File-src-doomdef-ml-460406769.md)
- `doomstat.ml` → [src/doomstat.ml](File-src-doomstat-ml-1652708088.md)
- `dstrings.ml` → [src/dstrings.ml](File-src-dstrings-ml-567491523.md)
- `g_game.ml` → [src/g_game.ml](File-src-g-game-ml-257299317.md)
- `hu_stuff.ml` → [src/hu_stuff.ml](File-src-hu-stuff-ml-1965779679.md)
- `i_system.ml` → [src/i_system.ml](File-src-i-system-ml-1632920966.md)
- `i_video.ml` → [src/i_video.ml](File-src-i-video-ml-140536292.md)
- `m_argv.ml` → [src/m_argv.ml](File-src-m-argv-ml-728984635.md)
- `m_swap.ml` → [src/m_swap.ml](File-src-m-swap-ml-1401834276.md)
- `mp_platform.ml` → [src/mp_platform.ml](File-src-mp-platform-ml-1361006310.md)
- `mp_state.ml` → [src/mp_state.ml](File-src-mp-state-ml-130741680.md)
- `r_local.ml` → [src/r_local.ml](File-src-r-local-ml-797040731.md)
- `r_renderer.ml` → [src/r_renderer.ml](File-src-r-renderer-ml-72894217.md)
- `s_sound.ml` → [src/s_sound.ml](File-src-s-sound-ml-1485495390.md)
- `sounds.ml` → [src/sounds.ml](File-src-sounds-ml-1875364049.md)
- `std/fs.ml` as `fs` → `../MiniLangCompilerOptimization/MiniLangCompilerPy/std/fs.ml` — external dependency
- `v_video.ml` → [src/v_video.ml](File-src-v-video-ml-592999939.md)
- `w_wad.ml` → [src/w_wad.ml](File-src-w-wad-ml-893006035.md)
- `z_zone.ml` → [src/z_zone.ml](File-src-z-zone-ml-1788911354.md)

## Declarations

<a id="function-function-buildmenus-function-buildmenus-src-m-menu-ml-809581667"></a>
### _BuildMenus

```ml
function _BuildMenus()
```

Constructs every static menu definition and wires its items to draw and activation callbacks.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/m_menu.ml#L713)

<a id="function-function-bytesof-inline-function-bytesof-x-src-m-menu-ml-1836315840"></a>
### _bytesOf

```ml
inline function _bytesOf(x)
```

Normalizes patch/text inputs to a byte sequence for legacy menu helpers.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `x` | `dynamic` | — | Horizontal map- or screen-space coordinate. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/m_menu.ml#L79)

<a id="function-function-cstrclear-function-cstrclear-buf-src-m-menu-ml-1304511364"></a>
### _cstrClear

```ml
function _cstrClear(buf)
```

Clears cstr Clear state before the next menu update.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `buf` | `dynamic` | — | Buf value supplied to `_cstrClear`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/m_menu.ml#L175)

<a id="function-function-cstrcopy-function-cstrcopy-dst-src-src-m-menu-ml-289189592"></a>
### _cstrCopy

```ml
function _cstrCopy(dst, src)
```

Copies one bounded zero-terminated edit buffer without leaking stale suffix bytes.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `dst` | `dynamic` | — | Dst value supplied to `_cstrCopy`. |
| `src` | `dynamic` | — | Src value supplied to `_cstrCopy`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/m_menu.ml#L213)

<a id="function-function-cstreqstring-inline-function-cstreqstring-buf-s-src-m-menu-ml-2073444738"></a>
### _cstrEqString

```ml
inline function _cstrEqString(buf, s)
```

Compares a zero-terminated menu buffer with an immutable string value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `buf` | `dynamic` | — | Buf value supplied to `_cstrEqString`. |
| `s` | `dynamic` | — | S value supplied to `_cstrEqString`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/m_menu.ml#L227)

<a id="function-function-cstrfromstring-function-cstrfromstring-buf-s-src-m-menu-ml-647135047"></a>
### _cstrFromString

```ml
function _cstrFromString(buf, s)
```

Copies a MiniLang string into a bounded zero-terminated menu edit buffer.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `buf` | `dynamic` | — | Buf value supplied to `_cstrFromString`. |
| `s` | `dynamic` | — | S value supplied to `_cstrFromString`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/m_menu.ml#L198)

<a id="function-function-cstrlen-function-cstrlen-buf-src-m-menu-ml-343553044"></a>
### _cstrLen

```ml
function _cstrLen(buf)
```

Counts bytes up to the first terminator in a fixed-size editable C string.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `buf` | `dynamic` | — | Buf value supplied to `_cstrLen`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/m_menu.ml#L185)

<a id="function-function-fmt1-function-fmt1-fmt-arg-src-m-menu-ml-1120862256"></a>
### _fmt1

```ml
function _fmt1(fmt, arg)
```

Formats one integer as a single printable decimal character for save/menu labels.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `fmt` | `dynamic` | — | Fmt value supplied to `_fmt1`. |
| `arg` | `dynamic` | — | Arg value supplied to `_fmt1`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/m_menu.ml#L236)

<a id="global-global-joywait-joywait-src-m-menu-ml-6519171"></a>
### _joywait

```ml
_joywait
```

Tracks the mutable joywait value used by the m menu subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/m_menu.ml#L2432)

<a id="global-global-lastx-lastx-src-m-menu-ml-1584033633"></a>
### _lastx

```ml
_lastx
```

Tracks the mutable lastx value used by the m menu subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/m_menu.ml#L2447)

<a id="global-global-lasty-lasty-src-m-menu-ml-1609574243"></a>
### _lasty

```ml
_lasty
```

Tracks the mutable lasty value used by the m menu subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/m_menu.ml#L2441)

<a id="function-function-menu-inline-function-menu-numitems-prevmenu-menuitems-routine-x-y-laston-src-m-menu-ml-1005320209"></a>
### _Menu

```ml
inline function _Menu(numitems, prevMenu, menuitems, routine, x, y, lastOn)
```

Constructs one menu_t and records its initial cursor position.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `numitems` | `dynamic` | — | Numitems value supplied to `_Menu`. |
| `prevMenu` | `dynamic` | — | Prev menu value supplied to `_Menu`. |
| `menuitems` | `dynamic` | — | Menuitems value supplied to `_Menu`. |
| `routine` | `dynamic` | — | Routine value supplied to `_Menu`. |
| `x` | `dynamic` | — | Horizontal map- or screen-space coordinate. |
| `y` | `dynamic` | — | Vertical map- or screen-space coordinate. |
| `lastOn` | `dynamic` | — | Last on value supplied to `_Menu`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/m_menu.ml#L328)

<a id="function-function-mi-inline-function-mi-status-name-routine-alphakey-src-m-menu-ml-570326876"></a>
### _MI

```ml
inline function _MI(status, name, routine, alphaKey)
```

Constructs one menuitem_t while keeping table declarations concise.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `status` | `dynamic` | — | Status value supplied to `_MI`. |
| `name` | `dynamic` | — | Resource or object name to resolve. |
| `routine` | `dynamic` | — | Routine value supplied to `_MI`. |
| `alphaKey` | `dynamic` | — | Alpha key value supplied to `_MI`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/m_menu.ml#L315)

<a id="function-function-min-inline-function-min-a-b-src-m-menu-ml-358407869"></a>
### _min

```ml
inline function _min(a, b)
```

Returns the lower of two menu-layout coordinates.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `a` | `dynamic` | — | First input operand. |
| `b` | `dynamic` | — | Second input operand. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/m_menu.ml#L62)

<a id="function-function-mmenu-argvalue-inline-function-mmenu-argvalue-flag-src-m-menu-ml-1611760198"></a>
### _MMENU_ArgValue

```ml
inline function _MMENU_ArgValue(flag)
```

Returns the argument following a named CLI flag, or an empty string when absent/incomplete.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `flag` | `dynamic` | — | Flag value supplied to `_MMENU_ArgValue`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/m_menu.ml#L616)

<a id="function-function-mmenu-buildmainmenu-inline-function-mmenu-buildmainmenu-src-m-menu-ml-103862462"></a>
### _MMENU_BuildMainMenu

```ml
inline function _MMENU_BuildMainMenu()
```

Creates the main menu item array including multiplayer entry.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/m_menu.ml#L655)

<a id="function-function-mmenu-buildmphostmenu-inline-function-mmenu-buildmphostmenu-src-m-menu-ml-1633640382"></a>
### _MMENU_BuildMPHostMenu

```ml
inline function _MMENU_BuildMPHostMenu()
```

Creates host setup menu item array.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/m_menu.ml#L679)

<a id="function-function-mmenu-buildmpjoinmenu-inline-function-mmenu-buildmpjoinmenu-src-m-menu-ml-1301529418"></a>
### _MMENU_BuildMPJoinMenu

```ml
inline function _MMENU_BuildMPJoinMenu()
```

Creates join setup menu item array.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/m_menu.ml#L694)

<a id="function-function-mmenu-buildmpnamemenu-inline-function-mmenu-buildmpnamemenu-src-m-menu-ml-758348128"></a>
### _MMENU_BuildMPNameMenu

```ml
inline function _MMENU_BuildMPNameMenu()
```

Creates player-name editor menu item array.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/m_menu.ml#L704)

<a id="function-function-mmenu-buildmultiplayermenu-inline-function-mmenu-buildmultiplayermenu-src-m-menu-ml-171654532"></a>
### _MMENU_BuildMultiplayerMenu

```ml
inline function _MMENU_BuildMultiplayerMenu()
```

Creates the multiplayer root menu item array.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/m_menu.ml#L669)

<a id="function-function-mmenu-clampcursor-function-mmenu-clampcursor-src-m-menu-ml-274006721"></a>
### _MMENU_ClampCursor

```ml
function _MMENU_ClampCursor()
```

Keeps the selected row inside the current menu and advances past disabled entries.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/m_menu.ml#L133)

<a id="function-function-mmenu-clampint-function-mmenu-clampint-v-lo-hi-src-m-menu-ml-1570737203"></a>
### _MMENU_ClampInt

```ml
function _MMENU_ClampInt(v, lo, hi)
```

Clamps integer values for multiplayer setup fields.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `v` | `dynamic` | — | Value consumed by the operation. |
| `lo` | `dynamic` | — | Inclusive lower bound. |
| `hi` | `dynamic` | — | Inclusive upper bound. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/m_menu.ml#L1118)

<a id="function-function-mmenu-drawpatchscale2-function-mmenu-drawpatchscale2-x-y-scrn-patch-src-m-menu-ml-113698428"></a>
### _MMENU_DrawPatchScale2

```ml
function _MMENU_DrawPatchScale2(x, y, scrn, patch)
```

Draws a Doom patch scaled to 2x into the destination screen.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `x` | `dynamic` | — | Horizontal map- or screen-space coordinate. |
| `y` | `dynamic` | — | Vertical map- or screen-space coordinate. |
| `scrn` | `dynamic` | — | Scrn value supplied to `_MMENU_DrawPatchScale2`. |
| `patch` | `dynamic` | — | Patch value supplied to `_MMENU_DrawPatchScale2`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/m_menu.ml#L2266)

<a id="function-function-mmenu-fontlumpname-function-mmenu-fontlumpname-code-src-m-menu-ml-1914178570"></a>
### _MMENU_FontLumpName

```ml
function _MMENU_FontLumpName(code)
```

Builds the STCFN lump name for one HUD/menu font character.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `code` | `dynamic` | — | Code value supplied to `_MMENU_FontLumpName`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/m_menu.ml#L2354)

<a id="function-function-mmenu-handlempjoinhosteditkey-function-mmenu-handlempjoinhosteditkey-ch-src-m-menu-ml-1114582660"></a>
### _MMENU_HandleMPJoinHostEditKey

```ml
function _MMENU_HandleMPJoinHostEditKey(ch)
```

Handles key input while multiplayer join-host editor is active.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `ch` | `dynamic` | — | Ch value supplied to `_MMENU_HandleMPJoinHostEditKey`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/m_menu.ml#L2490)

<a id="function-function-mmenu-handlempnameeditkey-function-mmenu-handlempnameeditkey-ch-src-m-menu-ml-667069920"></a>
### _MMENU_HandleMPNameEditKey

```ml
function _MMENU_HandleMPNameEditKey(ch)
```

Handles key input while multiplayer player-name editor is active.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `ch` | `dynamic` | — | Ch value supplied to `_MMENU_HandleMPNameEditKey`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/m_menu.ml#L2452)

<a id="function-function-mmenu-idiv-inline-function-mmenu-idiv-a-b-src-m-menu-ml-606884753"></a>
### _MMENU_IDiv

```ml
inline function _MMENU_IDiv(a, b)
```

Truncates menu layout quotients toward zero and safely maps a zero divisor to zero.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `a` | `dynamic` | — | First input operand. |
| `b` | `dynamic` | — | Second input operand. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/m_menu.ml#L90)

<a id="function-function-mmenu-itemcount-inline-function-mmenu-itemcount-menu-src-m-menu-ml-189103027"></a>
### _MMENU_ItemCount

```ml
inline function _MMENU_ItemCount(menu)
```

Reads a non-negative item count from a possibly uninitialized menu definition.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `menu` | `dynamic` | — | Menu value supplied to `_MMENU_ItemCount`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/m_menu.ml#L119)

<a id="global-global-mmenu-mp-log-path-mmenu-mp-log-path-src-m-menu-ml-366926567"></a>
### _mmenu_mp_log_path

```ml
_mmenu_mp_log_path
```

Stores the mutable mmenu mp log path text used by the m menu subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/m_menu.ml#L611)

<a id="function-function-mmenu-mpcliint-function-mmenu-mpcliint-flag-fallback-lo-hi-src-m-menu-ml-1708011663"></a>
### _MMENU_MPCLIInt

```ml
function _MMENU_MPCLIInt(flag, fallback, lo, hi)
```

Parses one bounded numeric multiplayer option and returns [valid,value].

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `flag` | `dynamic` | — | Flag value supplied to `_MMENU_MPCLIInt`. |
| `fallback` | `dynamic` | — | Value returned when the requested conversion or lookup is unavailable. |
| `lo` | `dynamic` | — | Inclusive lower bound. |
| `hi` | `dynamic` | — | Inclusive upper bound. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/m_menu.ml#L1656)

<a id="function-function-mmenu-mpclireportfailure-function-mmenu-mpclireportfailure-role-reason-src-m-menu-ml-621008915"></a>
### _MMENU_MPCLIReportFailure

```ml
function _MMENU_MPCLIReportFailure(role, reason)
```

Emits a machine-readable startup failure while retaining the human-readable platform reason.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `role` | `dynamic` | — | Role value supplied to `_MMENU_MPCLIReportFailure`. |
| `reason` | `dynamic` | — | Reason value supplied to `_MMENU_MPCLIReportFailure`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/m_menu.ml#L1703)

<a id="function-function-mmenu-mpfailurecode-function-mmenu-mpfailurecode-reason-src-m-menu-ml-1520400221"></a>
### _MMENU_MPFailureCode

```ml
function _MMENU_MPFailureCode(reason)
```

Maps platform error text to compact failure categories used by CLI orchestration.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `reason` | `dynamic` | — | Reason value supplied to `_MMENU_MPFailureCode`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/m_menu.ml#L644)

<a id="function-function-mmenu-mpisnumericipv4-function-mmenu-mpisnumericipv4-host-src-m-menu-ml-1883711495"></a>
### _MMENU_MPIsNumericIPv4

```ml
function _MMENU_MPIsNumericIPv4(host)
```

Validates the numerical dotted-quad form supported by the WinSock transport parser.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `host` | `dynamic` | — | Host value supplied to `_MMENU_MPIsNumericIPv4`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/m_menu.ml#L1668)

<a id="function-function-mmenu-mplimittext-inline-function-mmenu-mplimittext-v-src-m-menu-ml-375606862"></a>
### _MMENU_MPLimitText

```ml
inline function _MMENU_MPLimitText(v)
```

Formats deathmatch limits, including unlimited mode.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `v` | `dynamic` | — | Value consumed by the operation. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/m_menu.ml#L1156)

<a id="function-function-mmenu-mpmodename-inline-function-mmenu-mpmodename-mode-src-m-menu-ml-2113524257"></a>
### _MMENU_MPModeName

```ml
inline function _MMENU_MPModeName(mode)
```

Returns localized text for multiplayer mode value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `mode` | `dynamic` | — | Mode value supplied to `_MMENU_MPModeName`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/m_menu.ml#L1135)

<a id="function-function-mmenu-mpskillname-inline-function-mmenu-mpskillname-skill-src-m-menu-ml-2050386415"></a>
### _MMENU_MPSkillName

```ml
inline function _MMENU_MPSkillName(skill)
```

Returns UI text for host-selected skill level.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `skill` | `dynamic` | — | Skill value supplied to `_MMENU_MPSkillName`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/m_menu.ml#L1143)

<a id="function-function-mmenu-mpstarthostconfigured-function-mmenu-mpstarthostconfigured-interactive-src-m-menu-ml-1516290055"></a>
### _MMENU_MPStartHostConfigured

```ml
function _MMENU_MPStartHostConfigured(interactive)
```

Starts a host from normalized shared settings and reports either menu or CLI diagnostics.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `interactive` | `dynamic` | — | Interactive value supplied to `_MMENU_MPStartHostConfigured`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/m_menu.ml#L1520)

<a id="function-function-mmenu-mpstartjoinconfigured-function-mmenu-mpstartjoinconfigured-interactive-src-m-menu-ml-1110635315"></a>
### _MMENU_MPStartJoinConfigured

```ml
function _MMENU_MPStartJoinConfigured(interactive)
```

Joins the configured endpoint and boots the server-confirmed map/slot on success.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `interactive` | `dynamic` | — | Interactive value supplied to `_MMENU_MPStartJoinConfigured`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/m_menu.ml#L1595)

<a id="function-function-mmenu-mpstatus-function-mmenu-mpstatus-line-src-m-menu-ml-916149265"></a>
### _MMENU_MPStatus

```ml
function _MMENU_MPStatus(line)
```

Emits one stable automation status line to stdout and an optional per-process log file.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `line` | `dynamic` | — | Map line or text line affected by the operation. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/m_menu.ml#L627)

<a id="function-function-mmenu-parsemaptoken-function-mmenu-parsemaptoken-maptoken-src-m-menu-ml-1318664868"></a>
### _MMENU_ParseMapToken

```ml
function _MMENU_ParseMapToken(mapToken)
```

Parses MAPxx or ExMy map token and returns [episode,map].

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `mapToken` | `dynamic` | — | Map token value supplied to `_MMENU_ParseMapToken`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/m_menu.ml#L1201)

<a id="function-function-mmenu-parseunsignedtail-function-mmenu-parseunsignedtail-s0-startidx-src-m-menu-ml-636341473"></a>
### _MMENU_ParseUnsignedTail

```ml
function _MMENU_ParseUnsignedTail(s0, startIdx)
```

Parses a positive integer from a string tail, returning -1 on failure.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `s0` | `dynamic` | — | S0 value supplied to `_MMENU_ParseUnsignedTail`. |
| `startIdx` | `dynamic` | — | Start idx value supplied to `_MMENU_ParseUnsignedTail`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/m_menu.ml#L1180)

<a id="function-function-mmenu-requeststatusbarrefresh-inline-function-mmenu-requeststatusbarrefresh-src-m-menu-ml-317677160"></a>
### _MMENU_RequestStatusBarRefresh

```ml
inline function _MMENU_RequestStatusBarRefresh()
```

Forces one full status bar redraw after menu overlays are closed.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/m_menu.ml#L2171)

<a id="function-function-mmenu-reveallogicalmenutext-function-mmenu-reveallogicalmenutext-x-y-string-src-m-menu-ml-1032447971"></a>
### _MMENU_RevealLogicalMenuText

```ml
function _MMENU_RevealLogicalMenuText(x, y, string)
```

Keeps startup/title-screen high-res patch overlays from covering generated menu text.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `x` | `dynamic` | — | Horizontal map- or screen-space coordinate. |
| `y` | `dynamic` | — | Vertical map- or screen-space coordinate. |
| `string` | `dynamic` | — | String value supplied to `_MMENU_RevealLogicalMenuText`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/m_menu.ml#L2407)

<a id="function-function-mmenu-startmultiplayergame-function-mmenu-startmultiplayergame-mode-skill-maptoken-localslot-src-m-menu-ml-1977011423"></a>
### _MMENU_StartMultiplayerGame

```ml
function _MMENU_StartMultiplayerGame(mode, skill, mapToken, localSlot)
```

Starts local game session immediately using current MP session settings.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `mode` | `dynamic` | — | Mode value supplied to `_MMENU_StartMultiplayerGame`. |
| `skill` | `dynamic` | — | Skill value supplied to `_MMENU_StartMultiplayerGame`. |
| `mapToken` | `dynamic` | — | Map token value supplied to `_MMENU_StartMultiplayerGame`. |
| `localSlot` | `dynamic` | — | Local slot value supplied to `_MMENU_StartMultiplayerGame`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/m_menu.ml#L1225)

<a id="function-function-mmenu-stringwidthmenusized-function-mmenu-stringwidthmenusized-string-src-m-menu-ml-1636142688"></a>
### _MMENU_StringWidthMenuSized

```ml
function _MMENU_StringWidthMenuSized(string)
```

Returns text width in pixels for 2x multiplayer menu font rendering.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `string` | `dynamic` | — | String value supplied to `_MMENU_StringWidthMenuSized`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/m_menu.ml#L2332)

<a id="function-function-mmenu-syncmpbuffers-function-mmenu-syncmpbuffers-src-m-menu-ml-145668449"></a>
### _MMENU_SyncMPBuffers

```ml
function _MMENU_SyncMPBuffers()
```

Synchronizes editable menu buffers with multiplayer settings.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/m_menu.ml#L1298)

<a id="function-function-mmenu-toint-function-mmenu-toint-v-fallback-src-m-menu-ml-155298819"></a>
### _MMENU_ToInt

```ml
function _MMENU_ToInt(v, fallback)
```

Converts values to integers with fallback handling.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `v` | `dynamic` | — | Value consumed by the operation. |
| `fallback` | `dynamic` | — | Value returned when the requested conversion or lookup is unavailable. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/m_menu.ml#L101)

<a id="function-function-mmenu-toupperasciistring-function-mmenu-toupperasciistring-s0-src-m-menu-ml-553282274"></a>
### _MMENU_ToUpperAsciiString

```ml
function _MMENU_ToUpperAsciiString(s0)
```

Converts a string to uppercase for ASCII letters.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `s0` | `dynamic` | — | S0 value supplied to `_MMENU_ToUpperAsciiString`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/m_menu.ml#L1165)

<a id="function-function-mmenu-writemenusizedortext-function-mmenu-writemenusizedortext-x-y-string-src-m-menu-ml-1802088113"></a>
### _MMENU_WriteMenuSizedOrText

```ml
function _MMENU_WriteMenuSizedOrText(x, y, string)
```

Draws custom menu labels and falls back to the normal menu font if needed.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `x` | `dynamic` | — | Horizontal map- or screen-space coordinate. |
| `y` | `dynamic` | — | Vertical map- or screen-space coordinate. |
| `string` | `dynamic` | — | String value supplied to `_MMENU_WriteMenuSizedOrText`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/m_menu.ml#L2422)

<a id="function-function-mmenu-writetextmenusized-function-mmenu-writetextmenusized-x-y-string-src-m-menu-ml-1517109187"></a>
### _MMENU_WriteTextMenuSized

```ml
function _MMENU_WriteTextMenuSized(x, y, string)
```

Draws highlighted menu text for multiplayer entries with menu-like visual weight.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `x` | `dynamic` | — | Horizontal map- or screen-space coordinate. |
| `y` | `dynamic` | — | Vertical map- or screen-space coordinate. |
| `string` | `dynamic` | — | String value supplied to `_MMENU_WriteTextMenuSized`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/m_menu.ml#L2366)

<a id="global-global-mousewait-mousewait-src-m-menu-ml-681414045"></a>
### _mousewait

```ml
_mousewait
```

Tracks the mutable mousewait value used by the m menu subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/m_menu.ml#L2435)

<a id="global-global-mousex-acc-mousex-acc-src-m-menu-ml-354030175"></a>
### _mousex_acc

```ml
_mousex_acc
```

Tracks the mutable mousex acc value used by the m menu subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/m_menu.ml#L2444)

<a id="global-global-mousey-acc-mousey-acc-src-m-menu-ml-1679548791"></a>
### _mousey_acc

```ml
_mousey_acc
```

Tracks the mutable mousey acc value used by the m menu subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/m_menu.ml#L2438)

<a id="function-function-patchheight-inline-function-patchheight-patch-src-m-menu-ml-1642623044"></a>
### _patchHeight

```ml
inline function _patchHeight(patch)
```

Reads a cached patch height without assuming the resource decoded successfully.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `patch` | `dynamic` | — | Patch value supplied to `_patchHeight`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/m_menu.ml#L165)

<a id="function-function-patchwidth-inline-function-patchwidth-patch-src-m-menu-ml-388748754"></a>
### _patchWidth

```ml
inline function _patchWidth(patch)
```

Reads a cached patch width without assuming the resource decoded successfully.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `patch` | `dynamic` | — | Patch value supplied to `_patchWidth`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/m_menu.ml#L155)

<a id="function-function-toupperbyte-inline-function-toupperbyte-c-src-m-menu-ml-1910171505"></a>
### _toupperByte

```ml
inline function _toupperByte(c)
```

Converts toupper Byte text to the required case for menu lookups.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `c` | `dynamic` | — | C value supplied to `_toupperByte`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/m_menu.ml#L70)

<a id="constant-constant-brightness-const-brightness-5-src-m-menu-ml-952552127"></a>
### brightness

```ml
const brightness = 5
```

Defines brightness for the m menu subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/m_menu.ml#L566)

<a id="constant-constant-ch-n-const-ch-n-110-src-m-menu-ml-1351224492"></a>
### CH_N

```ml
const CH_N = 110
```

Defines ch n for the m menu subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/m_menu.ml#L54)

<a id="constant-constant-ch-space-const-ch-space-32-src-m-menu-ml-1792730017"></a>
### CH_SPACE

```ml
const CH_SPACE = 32
```

Defines ch space for the m menu subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/m_menu.ml#L52)

<a id="constant-constant-ch-y-const-ch-y-121-src-m-menu-ml-923487074"></a>
### CH_Y

```ml
const CH_Y = 121
```

Defines ch y for the m menu subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/m_menu.ml#L56)

<a id="global-global-currentmenu-currentmenu-src-m-menu-ml-729168583"></a>
### currentMenu

```ml
currentMenu
```

Tracks the mutable current menu value used by the m menu subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/m_menu.ml#L390)

<a id="constant-constant-detail-const-detail-2-src-m-menu-ml-1397912706"></a>
### detail

```ml
const detail = 2
```

Defines detail for the m menu subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/m_menu.ml#L560)

<a id="global-global-detaillevel-detaillevel-src-m-menu-ml-1414978139"></a>
### detailLevel

```ml
detailLevel
```

Tracks the mutable detail level value used by the m menu subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/m_menu.ml#L338)

<a id="global-global-detailnames-detailnames-src-m-menu-ml-997916235"></a>
### detailNames

```ml
detailNames
```

Stores the detail names collection used by the m menu subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/m_menu.ml#L434)

<a id="constant-constant-endgame-const-endgame-0-src-m-menu-ml-1388273380"></a>
### endgame

```ml
const endgame = 0
```

Defines endgame for the m menu subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/m_menu.ml#L556)

<a id="global-global-endstring-endstring-src-m-menu-ml-2092951379"></a>
### endstring

```ml
endstring
```

Stores the mutable endstring text used by the m menu subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/m_menu.ml#L393)

<a id="constant-constant-ep1-const-ep1-0-src-m-menu-ml-1055953624"></a>
### ep1

```ml
const ep1 = 0
```

Defines ep1 for the m menu subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/m_menu.ml#L532)

<a id="constant-constant-ep2-const-ep2-1-src-m-menu-ml-1537150067"></a>
### ep2

```ml
const ep2 = 1
```

Defines ep2 for the m menu subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/m_menu.ml#L534)

<a id="constant-constant-ep3-const-ep3-2-src-m-menu-ml-1685266690"></a>
### ep3

```ml
const ep3 = 2
```

Defines ep3 for the m menu subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/m_menu.ml#L536)

<a id="constant-constant-ep4-const-ep4-3-src-m-menu-ml-1140305557"></a>
### ep4

```ml
const ep4 = 3
```

Defines ep4 for the m menu subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/m_menu.ml#L538)

<a id="constant-constant-ep-end-const-ep-end-4-src-m-menu-ml-1034793152"></a>
### ep_end

```ml
const ep_end = 4
```

Defines ep end for the m menu subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/m_menu.ml#L540)

<a id="global-global-epi-epi-src-m-menu-ml-1390445535"></a>
### epi

```ml
epi
```

Tracks the mutable epi value used by the m menu subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/m_menu.ml#L463)

<a id="global-global-epidef-epidef-src-m-menu-ml-902035801"></a>
### EpiDef

```ml
EpiDef
```

Tracks the mutable epi def value used by the m menu subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/m_menu.ml#L421)

<a id="global-global-episodemenu-episodemenu-src-m-menu-ml-181114319"></a>
### EpisodeMenu

```ml
EpisodeMenu
```

Tracks the mutable episode menu value used by the m menu subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/m_menu.ml#L419)

<a id="global-global-gammamsg-gammamsg-src-m-menu-ml-981870015"></a>
### gammamsg

```ml
gammamsg
```

Stores the gammamsg collection used by the m menu subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/m_menu.ml#L362)

<a id="constant-constant-hurtme-const-hurtme-2-src-m-menu-ml-1757176654"></a>
### hurtme

```ml
const hurtme = 2
```

Defines hurtme for the m menu subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/m_menu.ml#L547)

<a id="global-global-inhelpscreens-inhelpscreens-src-m-menu-ml-487360659"></a>
### inhelpscreens

```ml
inhelpscreens
```

Tracks whether inhelpscreens is active in the m menu subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/m_menu.ml#L376)

<a id="global-global-itemon-itemon-src-m-menu-ml-1762443975"></a>
### itemOn

```ml
itemOn
```

Tracks the mutable item on value used by the m menu subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/m_menu.ml#L381)

<a id="constant-constant-killthings-const-killthings-0-src-m-menu-ml-1271984680"></a>
### killthings

```ml
const killthings = 0
```

Defines killthings for the m menu subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/m_menu.ml#L543)

<a id="constant-constant-lineheight-const-lineheight-16-src-m-menu-ml-1601517249"></a>
### LINEHEIGHT

```ml
const LINEHEIGHT = 16
```

Defines lineheight for the m menu subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/m_menu.ml#L49)

<a id="constant-constant-load-end-const-load-end-6-src-m-menu-ml-1500627008"></a>
### load_end

```ml
const load_end = 6
```

Defines load end for the m menu subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/m_menu.ml#L591)

<a id="global-global-loaddef-loaddef-src-m-menu-ml-1938050887"></a>
### LoadDef

```ml
LoadDef
```

Tracks the mutable load def value used by the m menu subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/m_menu.ml#L455)

<a id="global-global-loadmenu-loadmenu-src-m-menu-ml-1900285801"></a>
### LoadMenu

```ml
LoadMenu
```

Tracks the mutable load menu value used by the m menu subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/m_menu.ml#L453)

<a id="function-function-m-changebrightness-function-m-changebrightness-choice-src-m-menu-ml-2124363704"></a>
### M_ChangeBrightness

```ml
function M_ChangeBrightness(choice)
```

Adjusts gamma-based brightness level from options menu.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `choice` | `dynamic` | — | Choice value supplied to `M_ChangeBrightness`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/m_menu.ml#L2061)

<a id="function-function-m-changedetail-function-m-changedetail-choice-src-m-menu-ml-398936580"></a>
### M_ChangeDetail

```ml
function M_ChangeDetail(choice)
```

Selects the supported high-detail renderer mode and posts its localized HUD message.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `choice` | `dynamic` | — | Choice value supplied to `M_ChangeDetail`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/m_menu.ml#L2041)

<a id="function-function-m-changemessages-function-m-changemessages-choice-src-m-menu-ml-437667500"></a>
### M_ChangeMessages

```ml
function M_ChangeMessages(choice)
```

Toggles gameplay messages, posts the localized result, and protects it from immediate replacement.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `choice` | `dynamic` | — | Choice value supplied to `M_ChangeMessages`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/m_menu.ml#L1931)

<a id="function-function-m-changesensitivity-function-m-changesensitivity-choice-src-m-menu-ml-1272134622"></a>
### M_ChangeSensitivity

```ml
function M_ChangeSensitivity(choice)
```

Adjusts mouse sensitivity by one step within the persisted 0..9 range.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `choice` | `dynamic` | — | Choice value supplied to `M_ChangeSensitivity`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/m_menu.ml#L2030)

<a id="function-function-m-chooseskill-function-m-chooseskill-choice-src-m-menu-ml-744107012"></a>
### M_ChooseSkill

```ml
function M_ChooseSkill(choice)
```

Requests nightmare confirmation or queues a new game at the chosen difficulty.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `choice` | `dynamic` | — | Choice value supplied to `M_ChooseSkill`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/m_menu.ml#L1877)

<a id="function-function-m-clearmenus-function-m-clearmenus-src-m-menu-ml-1187377101"></a>
### M_ClearMenus

```ml
function M_ClearMenus()
```

Closes menu and multiplayer text editors, requesting a status-bar refresh when needed.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/m_menu.ml#L2947)

<a id="function-function-m-dosave-function-m-dosave-slot-src-m-menu-ml-873000857"></a>
### M_DoSave

```ml
function M_DoSave(slot)
```

Saves do Save state for the menu system.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `slot` | `dynamic` | — | Slot value supplied to `M_DoSave`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/m_menu.ml#L944)

<a id="function-function-m-drawemptycell-function-m-drawemptycell-menu-item-src-m-menu-ml-525479159"></a>
### M_DrawEmptyCell

```ml
function M_DrawEmptyCell(menu, item)
```

Draws the left/right save-slot border for an unselected cell.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `menu` | `dynamic` | — | Menu value supplied to `M_DrawEmptyCell`. |
| `item` | `dynamic` | — | Item value supplied to `M_DrawEmptyCell`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/m_menu.ml#L2124)

<a id="function-function-m-drawepisode-function-m-drawepisode-src-m-menu-ml-1089180251"></a>
### M_DrawEpisode

```ml
function M_DrawEpisode()
```

Draws the episode-selection title above the available IWAD episodes.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/m_menu.ml#L1863)

<a id="function-function-m-drawer-function-m-drawer-src-m-menu-ml-1228950853"></a>
### M_Drawer

```ml
function M_Drawer()
```

Draws the active menu page, modal message, and animated selection skull.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/m_menu.ml#L2887)

<a id="function-function-m-drawload-function-m-drawload-src-m-menu-ml-181506249"></a>
### M_DrawLoad

```ml
function M_DrawLoad()
```

Renders the load-game heading, slot borders, and cached descriptions for every save row.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/m_menu.ml#L887)

<a id="function-function-m-drawmainmenu-function-m-drawmainmenu-src-m-menu-ml-950761865"></a>
### M_DrawMainMenu

```ml
function M_DrawMainMenu()
```

Draws the title patch and custom multiplayer row for the root menu.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/m_menu.ml#L1107)

<a id="function-function-m-drawmphostmenu-function-m-drawmphostmenu-src-m-menu-ml-1471969465"></a>
### M_DrawMPHostMenu

```ml
function M_DrawMPHostMenu()
```

Draws host setup values for multiplayer dedicated server start.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/m_menu.ml#L1366)

<a id="function-function-m-drawmpjoinmenu-function-m-drawmpjoinmenu-src-m-menu-ml-349421697"></a>
### M_DrawMPJoinMenu

```ml
function M_DrawMPJoinMenu()
```

Draws join setup values and live host/name text editors.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/m_menu.ml#L1396)

<a id="function-function-m-drawmpnamemenu-function-m-drawmpnamemenu-src-m-menu-ml-1429309861"></a>
### M_DrawMPNameMenu

```ml
function M_DrawMPNameMenu()
```

Draws player name editor with caret during text entry.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/m_menu.ml#L1415)

<a id="function-function-m-drawmultiplayermenu-function-m-drawmultiplayermenu-src-m-menu-ml-1796855187"></a>
### M_DrawMultiplayerMenu

```ml
function M_DrawMultiplayerMenu()
```

Draws the multiplayer root menu.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/m_menu.ml#L1328)

<a id="function-function-m-drawnewgame-function-m-drawnewgame-src-m-menu-ml-2125858121"></a>
### M_DrawNewGame

```ml
function M_DrawNewGame()
```

Draws the skill-selection menu title and vanilla skill rows.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/m_menu.ml#L1841)

<a id="function-function-m-drawoptions-function-m-drawoptions-src-m-menu-ml-756874409"></a>
### M_DrawOptions

```ml
function M_DrawOptions()
```

Draws the options page plus sensitivity and screen-size thermometers.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/m_menu.ml#L1907)

<a id="function-function-m-drawreadthis1-function-m-drawreadthis1-src-m-menu-ml-1023348683"></a>
### M_DrawReadThis1

```ml
function M_DrawReadThis1()
```

Draws the first help page selected for commercial versus episodic game data.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/m_menu.ml#L1047)

<a id="function-function-m-drawreadthis2-function-m-drawreadthis2-src-m-menu-ml-2023572297"></a>
### M_DrawReadThis2

```ml
function M_DrawReadThis2()
```

Draws the credit or second help page appropriate to the active game edition.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/m_menu.ml#L1058)

<a id="function-function-m-drawsave-function-m-drawsave-src-m-menu-ml-1946530965"></a>
### M_DrawSave

```ml
function M_DrawSave()
```

Saves draw Save state for the menu system.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/m_menu.ml#L929)

<a id="function-function-m-drawsaveloadborder-function-m-drawsaveloadborder-x-y-src-m-menu-ml-434722100"></a>
### M_DrawSaveLoadBorder

```ml
function M_DrawSaveLoadBorder(x, y)
```

Tiles the left, center, and right patches forming one 24-character save-slot frame.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `x` | `dynamic` | — | Horizontal map- or screen-space coordinate. |
| `y` | `dynamic` | — | Vertical map- or screen-space coordinate. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/m_menu.ml#L898)

<a id="function-function-m-drawselcell-function-m-drawselcell-menu-item-src-m-menu-ml-411363629"></a>
### M_DrawSelCell

```ml
function M_DrawSelCell(menu, item)
```

Draws the selected save-slot border variant at a menu row.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `menu` | `dynamic` | — | Menu value supplied to `M_DrawSelCell`. |
| `item` | `dynamic` | — | Item value supplied to `M_DrawSelCell`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/m_menu.ml#L2132)

<a id="function-function-m-drawsound-function-m-drawsound-src-m-menu-ml-898928195"></a>
### M_DrawSound

```ml
function M_DrawSound()
```

Draws the sound-options patch and both volume thermometers.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/m_menu.ml#L1069)

<a id="function-function-m-drawthermo-function-m-drawthermo-x-y-thermwidth-thermdot-src-m-menu-ml-1846282897"></a>
### M_DrawThermo

```ml
function M_DrawThermo(x, y, thermWidth, thermDot)
```

Draws a patch-based horizontal slider with a checked marker position.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `x` | `dynamic` | — | Horizontal map- or screen-space coordinate. |
| `y` | `dynamic` | — | Vertical map- or screen-space coordinate. |
| `thermWidth` | `dynamic` | — | Width of therm width in pixels or map units. |
| `thermDot` | `dynamic` | — | Therm dot value supplied to `M_DrawThermo`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/m_menu.ml#L2108)

<a id="function-function-m-endgame-function-m-endgame-choice-src-m-menu-ml-318353922"></a>
### M_EndGame

```ml
function M_EndGame(choice)
```

Controls end Game transitions in the menu system.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `choice` | `dynamic` | — | Choice value supplied to `M_EndGame`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/m_menu.ml#L1959)

<a id="function-function-m-endgameresponse-function-m-endgameresponse-ch-src-m-menu-ml-666204736"></a>
### M_EndGameResponse

```ml
function M_EndGameResponse(ch)
```

Controls end Game Response transitions in the menu system.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `ch` | `dynamic` | — | Ch value supplied to `M_EndGameResponse`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/m_menu.ml#L1950)

<a id="function-function-m-episode-function-m-episode-choice-src-m-menu-ml-273551598"></a>
### M_Episode

```ml
function M_Episode(choice)
```

Validates shareware episode access and opens the skill selector for the chosen episode.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `choice` | `dynamic` | — | Choice value supplied to `M_Episode`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/m_menu.ml#L1889)

<a id="function-function-m-finishreadthis-function-m-finishreadthis-choice-src-m-menu-ml-430302588"></a>
### M_FinishReadThis

```ml
function M_FinishReadThis(choice)
```

Returns from the last help page to the main menu.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `choice` | `dynamic` | — | Choice value supplied to `M_FinishReadThis`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/m_menu.ml#L1990)

<a id="function-function-m-init-function-m-init-src-m-menu-ml-2060382161"></a>
### M_Init

```ml
function M_Init()
```

Constructs menu definitions and edit buffers, restores defaults, and seeds cursor/animation state.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/m_menu.ml#L2991)

<a id="function-function-m-loadgame-function-m-loadgame-choice-src-m-menu-ml-663514720"></a>
### M_LoadGame

```ml
function M_LoadGame(choice)
```

Rejects loads during netgames or opens the refreshed load-slot menu in offline play.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `choice` | `dynamic` | — | Choice value supplied to `M_LoadGame`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/m_menu.ml#L917)

<a id="function-function-m-loadselect-function-m-loadselect-choice-src-m-menu-ml-801573676"></a>
### M_LoadSelect

```ml
function M_LoadSelect(choice)
```

Queues the selected slot's per-WAD save file for loading and closes the menu.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `choice` | `dynamic` | — | Choice value supplied to `M_LoadSelect`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/m_menu.ml#L909)

<a id="function-function-m-mphostfraglimit-function-m-mphostfraglimit-choice-src-m-menu-ml-1910511720"></a>
### M_MPHostFragLimit

```ml
function M_MPHostFragLimit(choice)
```

Adjusts deathmatch frag limit (0 means unlimited).

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `choice` | `dynamic` | — | Choice value supplied to `M_MPHostFragLimit`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/m_menu.ml#L1479)

<a id="function-function-m-mphostmap-function-m-mphostmap-choice-src-m-menu-ml-2098823054"></a>
### M_MPHostMap

```ml
function M_MPHostMap(choice)
```

Cycles host-selected map through detected WAD map list.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `choice` | `dynamic` | — | Choice value supplied to `M_MPHostMap`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/m_menu.ml#L1445)

<a id="function-function-m-mphostmenuopen-function-m-mphostmenuopen-choice-src-m-menu-ml-423651020"></a>
### M_MPHostMenuOpen

```ml
function M_MPHostMenuOpen(choice)
```

Opens host setup menu and refreshes map/options state.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `choice` | `dynamic` | — | Choice value supplied to `M_MPHostMenuOpen`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/m_menu.ml#L1340)

<a id="function-function-m-mphostmode-function-m-mphostmode-choice-src-m-menu-ml-1718503636"></a>
### M_MPHostMode

```ml
function M_MPHostMode(choice)
```

Toggles host game mode between cooperative and deathmatch.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `choice` | `dynamic` | — | Choice value supplied to `M_MPHostMode`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/m_menu.ml#L1433)

<a id="function-function-m-mphostplayers-function-m-mphostplayers-choice-src-m-menu-ml-259340962"></a>
### M_MPHostPlayers

```ml
function M_MPHostPlayers(choice)
```

Adjusts host maximum players within protocol bounds.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `choice` | `dynamic` | — | Choice value supplied to `M_MPHostPlayers`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/m_menu.ml#L1467)

<a id="function-function-m-mphostport-function-m-mphostport-choice-src-m-menu-ml-1674743224"></a>
### M_MPHostPort

```ml
function M_MPHostPort(choice)
```

Adjusts dedicated server listen port.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `choice` | `dynamic` | — | Choice value supplied to `M_MPHostPort`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/m_menu.ml#L1507)

<a id="function-function-m-mphostskill-function-m-mphostskill-choice-src-m-menu-ml-28381184"></a>
### M_MPHostSkill

```ml
function M_MPHostSkill(choice)
```

Adjusts host-selected skill level.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `choice` | `dynamic` | — | Choice value supplied to `M_MPHostSkill`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/m_menu.ml#L1455)

<a id="function-function-m-mphoststart-function-m-mphoststart-choice-src-m-menu-ml-27557498"></a>
### M_MPHostStart

```ml
function M_MPHostStart(choice)
```

Starts the menu-configured host and keeps startup errors inside the menu flow.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `choice` | `dynamic` | — | Choice value supplied to `M_MPHostStart`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/m_menu.ml#L1563)

<a id="function-function-m-mphosttimelimit-function-m-mphosttimelimit-choice-src-m-menu-ml-684199302"></a>
### M_MPHostTimeLimit

```ml
function M_MPHostTimeLimit(choice)
```

Adjusts deathmatch time limit in minutes (0 means unlimited).

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `choice` | `dynamic` | — | Choice value supplied to `M_MPHostTimeLimit`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/m_menu.ml#L1493)

<a id="function-function-m-mpjoinedithost-function-m-mpjoinedithost-choice-src-m-menu-ml-775020076"></a>
### M_MPJoinEditHost

```ml
function M_MPJoinEditHost(choice)
```

Enters text edit mode for join target host string.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `choice` | `dynamic` | — | Choice value supplied to `M_MPJoinEditHost`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/m_menu.ml#L1570)

<a id="function-function-m-mpjoinmenuopen-function-m-mpjoinmenuopen-choice-src-m-menu-ml-1068280160"></a>
### M_MPJoinMenuOpen

```ml
function M_MPJoinMenuOpen(choice)
```

Opens join setup menu and refreshes editable host values.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `choice` | `dynamic` | — | Choice value supplied to `M_MPJoinMenuOpen`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/m_menu.ml#L1350)

<a id="function-function-m-mpjoinport-function-m-mpjoinport-choice-src-m-menu-ml-951348120"></a>
### M_MPJoinPort

```ml
function M_MPJoinPort(choice)
```

Adjusts join target UDP port.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `choice` | `dynamic` | — | Choice value supplied to `M_MPJoinPort`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/m_menu.ml#L1582)

<a id="function-function-m-mpjoinstart-function-m-mpjoinstart-choice-src-m-menu-ml-1665563238"></a>
### M_MPJoinStart

```ml
function M_MPJoinStart(choice)
```

Starts the menu-configured join handshake and surfaces rejection details interactively.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `choice` | `dynamic` | — | Choice value supplied to `M_MPJoinStart`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/m_menu.ml#L1645)

<a id="function-function-m-mpnamedone-function-m-mpnamedone-choice-src-m-menu-ml-1634682072"></a>
### M_MPNameDone

```ml
function M_MPNameDone(choice)
```

Applies name changes and closes player-name editor menu.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `choice` | `dynamic` | — | Choice value supplied to `M_MPNameDone`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/m_menu.ml#L1829)

<a id="function-function-m-mpnameedit-function-m-mpnameedit-choice-src-m-menu-ml-565035416"></a>
### M_MPNameEdit

```ml
function M_MPNameEdit(choice)
```

Enters text edit mode for multiplayer player name.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `choice` | `dynamic` | — | Choice value supplied to `M_MPNameEdit`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/m_menu.ml#L1817)

<a id="function-function-m-mpnamemenuopen-function-m-mpnamemenuopen-choice-src-m-menu-ml-1470875060"></a>
### M_MPNameMenuOpen

```ml
function M_MPNameMenuOpen(choice)
```

Opens player-name editor menu.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `choice` | `dynamic` | — | Choice value supplied to `M_MPNameMenuOpen`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/m_menu.ml#L1359)

<a id="function-function-m-mpstartfromcommandline-function-m-mpstartfromcommandline-src-m-menu-ml-1946413497"></a>
### M_MPStartFromCommandLine

```ml
function M_MPStartFromCommandLine()
```

Applies documented host/join CLI options and invokes the same production startup used by menus. Returns: 0 when no MP role was requested, 1 after success, -1 after a requested startup failed.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/m_menu.ml#L1710)

<a id="function-function-m-multiplayer-function-m-multiplayer-choice-src-m-menu-ml-1309081912"></a>
### M_Multiplayer

```ml
function M_Multiplayer(choice)
```

Opens the multiplayer root menu.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `choice` | `dynamic` | — | Choice value supplied to `M_Multiplayer`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/m_menu.ml#L1319)

<a id="function-function-m-musicvol-function-m-musicvol-choice-src-m-menu-ml-1623692320"></a>
### M_MusicVol

```ml
function M_MusicVol(choice)
```

Adjusts the music mixer volume and applies it immediately.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `choice` | `dynamic` | — | Choice value supplied to `M_MusicVol`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/m_menu.ml#L1096)

<a id="function-function-m-newgame-function-m-newgame-choice-src-m-menu-ml-1323498888"></a>
### M_NewGame

```ml
function M_NewGame(choice)
```

Rejects active netgames or routes new-game selection to episode/skill menus for this IWAD.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `choice` | `dynamic` | — | Choice value supplied to `M_NewGame`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/m_menu.ml#L1848)

<a id="function-function-m-options-function-m-options-choice-src-m-menu-ml-874359868"></a>
### M_Options

```ml
function M_Options(choice)
```

Opens the options submenu at its remembered selection.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `choice` | `dynamic` | — | Choice value supplied to `M_Options`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/m_menu.ml#L1924)

<a id="function-function-m-quickload-function-m-quickload-src-m-menu-ml-1910442787"></a>
### M_QuickLoad

```ml
function M_QuickLoad()
```

Validates quick-load availability and opens the confirmation prompt for its remembered slot.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/m_menu.ml#L1030)

<a id="function-function-m-quickloadresponse-function-m-quickloadresponse-ch-src-m-menu-ml-896288624"></a>
### M_QuickLoadResponse

```ml
function M_QuickLoadResponse(ch)
```

Executes the remembered quick-load slot only after an affirmative confirmation key.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `ch` | `dynamic` | — | Ch value supplied to `M_QuickLoadResponse`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/m_menu.ml#L1022)

<a id="function-function-m-quicksave-function-m-quicksave-src-m-menu-ml-879944437"></a>
### M_QuickSave

```ml
function M_QuickSave()
```

Saves quick Save state for the menu system.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/m_menu.ml#L998)

<a id="function-function-m-quicksaveresponse-function-m-quicksaveresponse-ch-src-m-menu-ml-1765081650"></a>
### M_QuickSaveResponse

```ml
function M_QuickSaveResponse(ch)
```

Saves quick Save Response state for the menu system.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `ch` | `dynamic` | — | Ch value supplied to `M_QuickSaveResponse`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/m_menu.ml#L990)

<a id="function-function-m-quitdoom-function-m-quitdoom-choice-src-m-menu-ml-1070593840"></a>
### M_QuitDOOM

```ml
function M_QuitDOOM(choice)
```

Selects a localized randomized quit message and opens its confirmation prompt.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `choice` | `dynamic` | — | Choice value supplied to `M_QuitDOOM`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/m_menu.ml#L2014)

<a id="function-function-m-quitresponse-function-m-quitresponse-ch-src-m-menu-ml-203115748"></a>
### M_QuitResponse

```ml
function M_QuitResponse(ch)
```

Accepts the quit confirmation, plays the edition-specific exit cue, and terminates the process.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `ch` | `dynamic` | — | Ch value supplied to `M_QuitResponse`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/m_menu.ml#L1997)

<a id="function-function-m-readsavestrings-function-m-readsavestrings-src-m-menu-ml-797741771"></a>
### M_ReadSaveStrings

```ml
function M_ReadSaveStrings()
```

Scans each per-WAD save slot, copies its fixed title, and enables only readable load-menu rows.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/m_menu.ml#L847)

<a id="function-function-m-readthis-function-m-readthis-choice-src-m-menu-ml-128723792"></a>
### M_ReadThis

```ml
function M_ReadThis(choice)
```

Opens the first help/read-this menu page.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `choice` | `dynamic` | — | Choice value supplied to `M_ReadThis`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/m_menu.ml#L1976)

<a id="function-function-m-readthis2-function-m-readthis2-choice-src-m-menu-ml-817030160"></a>
### M_ReadThis2

```ml
function M_ReadThis2(choice)
```

Advances from the first help page to the second page.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `choice` | `dynamic` | — | Choice value supplied to `M_ReadThis2`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/m_menu.ml#L1983)

<a id="function-function-m-responder-function-m-responder-ev-src-m-menu-ml-361536964"></a>
### M_Responder

```ml
function M_Responder(ev)
```

Routes modal/editor/navigation keys and invokes the selected menu item's callback.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `ev` | `dynamic` | — | Input event to process. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/m_menu.ml#L2529)

<a id="function-function-m-savegame-function-m-savegame-choice-src-m-menu-ml-1687464208"></a>
### M_SaveGame

```ml
function M_SaveGame(choice)
```

Rejects invalid save contexts or opens the refreshed save-slot menu for a live level.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `choice` | `dynamic` | — | Choice value supplied to `M_SaveGame`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/m_menu.ml#L972)

<a id="function-function-m-saveselect-function-m-saveselect-choice-src-m-menu-ml-1662414856"></a>
### M_SaveSelect

```ml
function M_SaveSelect(choice)
```

Opens text editing for the selected save row while preserving its prior description for cancel.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `choice` | `dynamic` | — | Choice value supplied to `M_SaveSelect`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/m_menu.ml#L956)

<a id="function-function-m-setupnextmenu-function-m-setupnextmenu-menudef-src-m-menu-ml-309778951"></a>
### M_SetupNextMenu

```ml
function M_SetupNextMenu(menudef)
```

Switches menu definition, restores its remembered cursor, and exits active text editors.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `menudef` | `dynamic` | — | Menudef value supplied to `M_SetupNextMenu`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/m_menu.ml#L2963)

<a id="function-function-m-sfxvol-function-m-sfxvol-choice-src-m-menu-ml-132310464"></a>
### M_SfxVol

```ml
function M_SfxVol(choice)
```

Adjusts the effects mixer volume and applies it immediately.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `choice` | `dynamic` | — | Choice value supplied to `M_SfxVol`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/m_menu.ml#L1084)

<a id="function-function-m-sizedisplay-function-m-sizedisplay-choice-src-m-menu-ml-1788157774"></a>
### M_SizeDisplay

```ml
function M_SizeDisplay(choice)
```

Changes screen-block size within renderer bounds and schedules a view resize.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `choice` | `dynamic` | — | Choice value supplied to `M_SizeDisplay`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/m_menu.ml#L2085)

<a id="function-function-m-sound-function-m-sound-choice-src-m-menu-ml-42794090"></a>
### M_Sound

```ml
function M_Sound(choice)
```

Opens the sound submenu at its previously selected row.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `choice` | `dynamic` | — | Choice value supplied to `M_Sound`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/m_menu.ml#L1077)

<a id="function-function-m-startcontrolpanel-function-m-startcontrolpanel-src-m-menu-ml-1364772623"></a>
### M_StartControlPanel

```ml
function M_StartControlPanel()
```

Opens the main menu at its remembered row and clamps the cursor to enabled items.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/m_menu.ml#L2875)

<a id="function-function-m-startmessage-function-m-startmessage-string-routine-input-src-m-menu-ml-1940333698"></a>
### M_StartMessage

```ml
function M_StartMessage(string, routine, input)
```

Replaces the current menu with a modal prompt while remembering whether a menu was already open.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `string` | `dynamic` | — | String value supplied to `M_StartMessage`. |
| `routine` | `dynamic` | — | Routine value supplied to `M_StartMessage`. |
| `input` | `dynamic` | — | Input value supplied to `M_StartMessage`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/m_menu.ml#L2141)

<a id="function-function-m-stopmessage-function-m-stopmessage-src-m-menu-ml-1792237255"></a>
### M_StopMessage

```ml
function M_StopMessage()
```

Dismisses the modal prompt and restores the menu-active state captured when it opened.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/m_menu.ml#L2157)

<a id="function-function-m-stringheight-function-m-stringheight-string-src-m-menu-ml-1121515542"></a>
### M_StringHeight

```ml
function M_StringHeight(string)
```

Measures multiline menu text height using the active HU font metrics.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `string` | `dynamic` | — | String value supplied to `M_StringHeight`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/m_menu.ml#L2206)

<a id="function-function-m-stringwidth-function-m-stringwidth-string-src-m-menu-ml-92621696"></a>
### M_StringWidth

```ml
function M_StringWidth(string)
```

Measures proportional menu text width using loaded HU font patches.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `string` | `dynamic` | — | String value supplied to `M_StringWidth`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/m_menu.ml#L2180)

<a id="function-function-m-ticker-function-m-ticker-src-m-menu-ml-1987620625"></a>
### M_Ticker

```ml
function M_Ticker()
```

Pumps multiplayer handshakes and flips the selection skull every eight menu tics.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/m_menu.ml#L2977)

<a id="function-function-m-verifynightmare-function-m-verifynightmare-ch-src-m-menu-ml-1704315716"></a>
### M_VerifyNightmare

```ml
function M_VerifyNightmare(ch)
```

Confirms or cancels nightmare difficulty before starting a new game.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `ch` | `dynamic` | — | Ch value supplied to `M_VerifyNightmare`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/m_menu.ml#L1869)

<a id="function-function-m-writetext-function-m-writetext-x-y-string-src-m-menu-ml-224234963"></a>
### M_WriteText

```ml
function M_WriteText(x, y, string)
```

Draws patch-font glyphs with newline handling, unsupported-character spacing, and screen clipping.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `x` | `dynamic` | — | Horizontal map- or screen-space coordinate. |
| `y` | `dynamic` | — | Vertical map- or screen-space coordinate. |
| `string` | `dynamic` | — | String value supplied to `M_WriteText`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/m_menu.ml#L2224)

<a id="constant-constant-main-end-const-main-end-7-src-m-menu-ml-861190377"></a>
### main_end

```ml
const main_end = 7
```

Defines main end for the m menu subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/m_menu.ml#L485)

<a id="constant-constant-main-loadgame-const-main-loadgame-3-src-m-menu-ml-757649873"></a>
### main_loadgame

```ml
const main_loadgame = 3
```

Defines main loadgame for the m menu subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/m_menu.ml#L477)

<a id="constant-constant-main-multiplayer-const-main-multiplayer-1-src-m-menu-ml-1215512449"></a>
### main_multiplayer

```ml
const main_multiplayer = 1
```

Defines main multiplayer for the m menu subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/m_menu.ml#L473)

<a id="constant-constant-main-newgame-const-main-newgame-0-src-m-menu-ml-1261273790"></a>
### main_newgame

```ml
const main_newgame = 0
```

Defines main newgame for the m menu subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/m_menu.ml#L471)

<a id="constant-constant-main-options-const-main-options-2-src-m-menu-ml-1570518520"></a>
### main_options

```ml
const main_options = 2
```

Defines main options for the m menu subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/m_menu.ml#L475)

<a id="constant-constant-main-quitdoom-const-main-quitdoom-6-src-m-menu-ml-1163808190"></a>
### main_quitdoom

```ml
const main_quitdoom = 6
```

Defines main quitdoom for the m menu subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/m_menu.ml#L483)

<a id="constant-constant-main-readthis-const-main-readthis-5-src-m-menu-ml-229774935"></a>
### main_readthis

```ml
const main_readthis = 5
```

Defines main readthis for the m menu subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/m_menu.ml#L481)

<a id="constant-constant-main-savegame-const-main-savegame-4-src-m-menu-ml-1822079856"></a>
### main_savegame

```ml
const main_savegame = 4
```

Defines main savegame for the m menu subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/m_menu.ml#L479)

<a id="global-global-maindef-maindef-src-m-menu-ml-291134287"></a>
### MainDef

```ml
MainDef
```

Tracks the mutable main def value used by the m menu subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/m_menu.ml#L400)

<a id="global-global-mainmenu-mainmenu-src-m-menu-ml-2018705031"></a>
### MainMenu

```ml
MainMenu
```

Tracks the mutable main menu value used by the m menu subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/m_menu.ml#L398)

- [menu_t](Type-menu-t-1965701585.md) — struct
<a id="global-global-menuactive-menuactive-src-m-menu-ml-908874869"></a>
### menuactive

```ml
menuactive
```

Tracks whether menuactive is active in the m menu subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/m_menu.ml#L378)

- [menuitem_t](Type-menuitem-t-69865114.md) — struct
<a id="global-global-messagelastmenuactive-messagelastmenuactive-src-m-menu-ml-1985752007"></a>
### messageLastMenuActive

```ml
messageLastMenuActive
```

Tracks whether message last menu active is active in the m menu subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/m_menu.ml#L355)

<a id="global-global-messageneedsinput-messageneedsinput-src-m-menu-ml-669521143"></a>
### messageNeedsInput

```ml
messageNeedsInput
```

Tracks whether message needs input is active in the m menu subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/m_menu.ml#L357)

<a id="global-global-messageroutine-messageroutine-src-m-menu-ml-25813913"></a>
### messageRoutine

```ml
messageRoutine
```

Tracks the mutable message routine value used by the m menu subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/m_menu.ml#L359)

<a id="constant-constant-messages-const-messages-1-src-m-menu-ml-227740365"></a>
### messages

```ml
const messages = 1
```

Defines messages for the m menu subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/m_menu.ml#L558)

<a id="global-global-messagestring-messagestring-src-m-menu-ml-2058433575"></a>
### messageString

```ml
messageString
```

Stores the mutable message string text used by the m menu subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/m_menu.ml#L349)

<a id="global-global-messagetoprint-messagetoprint-src-m-menu-ml-1140344789"></a>
### messageToPrint

```ml
messageToPrint
```

Tracks the mutable message to print value used by the m menu subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/m_menu.ml#L347)

<a id="global-global-messx-messx-src-m-menu-ml-1576394735"></a>
### messx

```ml
messx
```

Tracks the mutable messx value used by the m menu subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/m_menu.ml#L351)

<a id="global-global-messy-messy-src-m-menu-ml-141352063"></a>
### messy

```ml
messy
```

Tracks the mutable messy value used by the m menu subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/m_menu.ml#L353)

<a id="constant-constant-mousesens-const-mousesens-7-src-m-menu-ml-20193125"></a>
### mousesens

```ml
const mousesens = 7
```

Defines mousesens for the m menu subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/m_menu.ml#L570)

<a id="global-global-mousesensitivity-mousesensitivity-src-m-menu-ml-821476303"></a>
### mouseSensitivity

```ml
mouseSensitivity
```

Tracks the mutable mouse sensitivity value used by the m menu subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/m_menu.ml#L333)

<a id="constant-constant-mp-host-end-const-mp-host-end-8-src-m-menu-ml-1664017076"></a>
### mp_host_end

```ml
const mp_host_end = 8
```

Defines mp host end for the m menu subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/m_menu.ml#L513)

<a id="constant-constant-mp-host-fraglimit-const-mp-host-fraglimit-4-src-m-menu-ml-501426836"></a>
### mp_host_fraglimit

```ml
const mp_host_fraglimit = 4
```

Defines mp host fraglimit for the m menu subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/m_menu.ml#L505)

<a id="constant-constant-mp-host-map-const-mp-host-map-1-src-m-menu-ml-702650163"></a>
### mp_host_map

```ml
const mp_host_map = 1
```

Defines mp host map for the m menu subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/m_menu.ml#L499)

<a id="constant-constant-mp-host-mode-item-const-mp-host-mode-item-0-src-m-menu-ml-1850593972"></a>
### mp_host_mode_item

```ml
const mp_host_mode_item = 0
```

Defines mp host mode item for the m menu subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/m_menu.ml#L497)

<a id="constant-constant-mp-host-players-const-mp-host-players-3-src-m-menu-ml-2027717397"></a>
### mp_host_players

```ml
const mp_host_players = 3
```

Defines mp host players for the m menu subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/m_menu.ml#L503)

<a id="constant-constant-mp-host-port-item-const-mp-host-port-item-6-src-m-menu-ml-449816962"></a>
### mp_host_port_item

```ml
const mp_host_port_item = 6
```

Defines mp host port item for the m menu subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/m_menu.ml#L509)

<a id="constant-constant-mp-host-skill-item-const-mp-host-skill-item-2-src-m-menu-ml-1626781204"></a>
### mp_host_skill_item

```ml
const mp_host_skill_item = 2
```

Defines mp host skill item for the m menu subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/m_menu.ml#L501)

<a id="constant-constant-mp-host-start-const-mp-host-start-7-src-m-menu-ml-1691553417"></a>
### mp_host_start

```ml
const mp_host_start = 7
```

Defines mp host start for the m menu subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/m_menu.ml#L511)

<a id="constant-constant-mp-host-timelimit-const-mp-host-timelimit-5-src-m-menu-ml-1740478655"></a>
### mp_host_timelimit

```ml
const mp_host_timelimit = 5
```

Defines mp host timelimit for the m menu subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/m_menu.ml#L507)

<a id="constant-constant-mp-join-end-const-mp-join-end-3-src-m-menu-ml-1071258949"></a>
### mp_join_end

```ml
const mp_join_end = 3
```

Defines mp join end for the m menu subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/m_menu.ml#L522)

<a id="constant-constant-mp-join-host-item-const-mp-join-host-item-0-src-m-menu-ml-598712452"></a>
### mp_join_host_item

```ml
const mp_join_host_item = 0
```

Defines mp join host item for the m menu subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/m_menu.ml#L516)

<a id="constant-constant-mp-join-port-item-const-mp-join-port-item-1-src-m-menu-ml-817652783"></a>
### mp_join_port_item

```ml
const mp_join_port_item = 1
```

Defines mp join port item for the m menu subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/m_menu.ml#L518)

<a id="constant-constant-mp-join-start-const-mp-join-start-2-src-m-menu-ml-1657537206"></a>
### mp_join_start

```ml
const mp_join_start = 2
```

Defines mp join start for the m menu subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/m_menu.ml#L520)

<a id="constant-constant-mp-main-end-const-mp-main-end-3-src-m-menu-ml-1352077405"></a>
### mp_main_end

```ml
const mp_main_end = 3
```

Defines mp main end for the m menu subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/m_menu.ml#L494)

<a id="constant-constant-mp-main-host-const-mp-main-host-0-src-m-menu-ml-1695821202"></a>
### mp_main_host

```ml
const mp_main_host = 0
```

Defines mp main host for the m menu subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/m_menu.ml#L488)

<a id="constant-constant-mp-main-join-const-mp-main-join-1-src-m-menu-ml-1570102429"></a>
### mp_main_join

```ml
const mp_main_join = 1
```

Defines mp main join for the m menu subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/m_menu.ml#L490)

<a id="constant-constant-mp-main-name-const-mp-main-name-2-src-m-menu-ml-177224126"></a>
### mp_main_name

```ml
const mp_main_name = 2
```

Defines mp main name for the m menu subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/m_menu.ml#L492)

<a id="constant-constant-mp-name-done-const-mp-name-done-1-src-m-menu-ml-215113357"></a>
### mp_name_done

```ml
const mp_name_done = 1
```

Defines mp name done for the m menu subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/m_menu.ml#L527)

<a id="constant-constant-mp-name-edit-const-mp-name-edit-0-src-m-menu-ml-990164346"></a>
### mp_name_edit

```ml
const mp_name_edit = 0
```

Defines mp name edit for the m menu subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/m_menu.ml#L525)

<a id="constant-constant-mp-name-end-const-mp-name-end-2-src-m-menu-ml-127242822"></a>
### mp_name_end

```ml
const mp_name_end = 2
```

Defines mp name end for the m menu subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/m_menu.ml#L529)

<a id="global-global-mphostdef-mphostdef-src-m-menu-ml-478468175"></a>
### MPHostDef

```ml
MPHostDef
```

Tracks the mutable mphost def value used by the m menu subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/m_menu.ml#L408)

<a id="global-global-mphostmenu-mphostmenu-src-m-menu-ml-501862663"></a>
### MPHostMenu

```ml
MPHostMenu
```

Tracks the mutable mphost menu value used by the m menu subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/m_menu.ml#L406)

<a id="global-global-mpjoindef-mpjoindef-src-m-menu-ml-623353591"></a>
### MPJoinDef

```ml
MPJoinDef
```

Tracks the mutable mpjoin def value used by the m menu subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/m_menu.ml#L412)

<a id="global-global-mpjoinhostbuf-mpjoinhostbuf-src-m-menu-ml-550655555"></a>
### mpJoinHostBuf

```ml
mpJoinHostBuf
```

Tracks the mutable mp join host buf value used by the m menu subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/m_menu.ml#L606)

<a id="global-global-mpjoinhostcharindex-mpjoinhostcharindex-src-m-menu-ml-1176400467"></a>
### mpJoinHostCharIndex

```ml
mpJoinHostCharIndex
```

Tracks the mutable mp join host char index value used by the m menu subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/m_menu.ml#L604)

<a id="global-global-mpjoinhostenter-mpjoinhostenter-src-m-menu-ml-1417713187"></a>
### mpJoinHostEnter

```ml
mpJoinHostEnter
```

Tracks the mutable mp join host enter value used by the m menu subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/m_menu.ml#L602)

<a id="global-global-mpjoinhostold-mpjoinhostold-src-m-menu-ml-1241659543"></a>
### mpJoinHostOld

```ml
mpJoinHostOld
```

Tracks the mutable mp join host old value used by the m menu subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/m_menu.ml#L608)

<a id="global-global-mpjoinmenu-mpjoinmenu-src-m-menu-ml-171568783"></a>
### MPJoinMenu

```ml
MPJoinMenu
```

Tracks the mutable mpjoin menu value used by the m menu subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/m_menu.ml#L410)

<a id="global-global-mpnamebuf-mpnamebuf-src-m-menu-ml-2037020051"></a>
### mpNameBuf

```ml
mpNameBuf
```

Tracks the mutable mp name buf value used by the m menu subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/m_menu.ml#L598)

<a id="global-global-mpnamecharindex-mpnamecharindex-src-m-menu-ml-390040535"></a>
### mpNameCharIndex

```ml
mpNameCharIndex
```

Tracks the mutable mp name char index value used by the m menu subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/m_menu.ml#L596)

<a id="global-global-mpnamedef-mpnamedef-src-m-menu-ml-733022375"></a>
### MPNameDef

```ml
MPNameDef
```

Tracks the mutable mpname def value used by the m menu subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/m_menu.ml#L416)

<a id="global-global-mpnameenter-mpnameenter-src-m-menu-ml-1006309251"></a>
### mpNameEnter

```ml
mpNameEnter
```

Tracks the mutable mp name enter value used by the m menu subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/m_menu.ml#L594)

<a id="global-global-mpnamemenu-mpnamemenu-src-m-menu-ml-1141495069"></a>
### MPNameMenu

```ml
MPNameMenu
```

Tracks the mutable mpname menu value used by the m menu subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/m_menu.ml#L414)

<a id="global-global-mpnameold-mpnameold-src-m-menu-ml-1131459203"></a>
### mpNameOld

```ml
mpNameOld
```

Tracks the mutable mp name old value used by the m menu subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/m_menu.ml#L600)

<a id="global-global-msgnames-msgnames-src-m-menu-ml-1514371953"></a>
### msgNames

```ml
msgNames
```

Stores the msg names collection used by the m menu subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/m_menu.ml#L436)

<a id="global-global-multiplayerdef-multiplayerdef-src-m-menu-ml-68022297"></a>
### MultiplayerDef

```ml
MultiplayerDef
```

Tracks the mutable multiplayer def value used by the m menu subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/m_menu.ml#L404)

<a id="global-global-multiplayermenu-multiplayermenu-src-m-menu-ml-288702247"></a>
### MultiplayerMenu

```ml
MultiplayerMenu
```

Tracks the mutable multiplayer menu value used by the m menu subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/m_menu.ml#L402)

<a id="constant-constant-music-vol-const-music-vol-2-src-m-menu-ml-351052542"></a>
### music_vol

```ml
const music_vol = 2
```

Defines music vol for the m menu subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/m_menu.ml#L586)

<a id="global-global-newdef-newdef-src-m-menu-ml-1360561645"></a>
### NewDef

```ml
NewDef
```

Tracks the mutable new def value used by the m menu subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/m_menu.ml#L426)

<a id="constant-constant-newg-end-const-newg-end-5-src-m-menu-ml-1437541231"></a>
### newg_end

```ml
const newg_end = 5
```

Defines newg end for the m menu subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/m_menu.ml#L553)

<a id="global-global-newgamemenu-newgamemenu-src-m-menu-ml-1980648323"></a>
### NewGameMenu

```ml
NewGameMenu
```

Tracks the mutable new game menu value used by the m menu subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/m_menu.ml#L424)

<a id="constant-constant-nightmare-const-nightmare-4-src-m-menu-ml-1731053376"></a>
### nightmare

```ml
const nightmare = 4
```

Defines nightmare for the m menu subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/m_menu.ml#L551)

<a id="constant-constant-opt-end-const-opt-end-10-src-m-menu-ml-1916552467"></a>
### opt_end

```ml
const opt_end = 10
```

Defines opt end for the m menu subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/m_menu.ml#L576)

<a id="constant-constant-option-empty1-const-option-empty1-4-src-m-menu-ml-1553901036"></a>
### option_empty1

```ml
const option_empty1 = 4
```

Defines option empty1 for the m menu subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/m_menu.ml#L564)

<a id="constant-constant-option-empty1b-const-option-empty1b-6-src-m-menu-ml-1723788536"></a>
### option_empty1b

```ml
const option_empty1b = 6
```

Defines option empty1b for the m menu subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/m_menu.ml#L568)

<a id="constant-constant-option-empty2-const-option-empty2-8-src-m-menu-ml-293969304"></a>
### option_empty2

```ml
const option_empty2 = 8
```

Defines option empty2 for the m menu subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/m_menu.ml#L572)

<a id="global-global-optionsdef-optionsdef-src-m-menu-ml-350448369"></a>
### OptionsDef

```ml
OptionsDef
```

Tracks the mutable options def value used by the m menu subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/m_menu.ml#L431)

<a id="global-global-optionsmenu-optionsmenu-src-m-menu-ml-1763911835"></a>
### OptionsMenu

```ml
OptionsMenu
```

Tracks the mutable options menu value used by the m menu subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/m_menu.ml#L429)

<a id="global-global-quicksaveslot-quicksaveslot-src-m-menu-ml-2053210847"></a>
### quickSaveSlot

```ml
quickSaveSlot
```

Tracks the mutable quick save slot value used by the m menu subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/m_menu.ml#L344)

<a id="global-global-quitsounds-quitsounds-src-m-menu-ml-96685529"></a>
### quitsounds

```ml
quitsounds
```

Tracks the mutable quitsounds value used by the m menu subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/m_menu.ml#L466)

<a id="global-global-quitsounds2-quitsounds2-src-m-menu-ml-2121152719"></a>
### quitsounds2

```ml
quitsounds2
```

Tracks the mutable quitsounds2 value used by the m menu subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/m_menu.ml#L468)

<a id="constant-constant-read1-end-const-read1-end-1-src-m-menu-ml-246275699"></a>
### read1_end

```ml
const read1_end = 1
```

Defines read1 end for the m menu subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/m_menu.ml#L579)

<a id="constant-constant-read2-end-const-read2-end-1-src-m-menu-ml-638533047"></a>
### read2_end

```ml
const read2_end = 1
```

Defines read2 end for the m menu subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/m_menu.ml#L581)

<a id="global-global-readdef1-readdef1-src-m-menu-ml-931938559"></a>
### ReadDef1

```ml
ReadDef1
```

Tracks the mutable read def1 value used by the m menu subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/m_menu.ml#L441)

<a id="global-global-readdef2-readdef2-src-m-menu-ml-721366025"></a>
### ReadDef2

```ml
ReadDef2
```

Tracks the mutable read def2 value used by the m menu subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/m_menu.ml#L445)

<a id="global-global-readmenu1-readmenu1-src-m-menu-ml-1529424063"></a>
### ReadMenu1

```ml
ReadMenu1
```

Tracks the mutable read menu1 value used by the m menu subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/m_menu.ml#L439)

<a id="global-global-readmenu2-readmenu2-src-m-menu-ml-883579547"></a>
### ReadMenu2

```ml
ReadMenu2
```

Tracks the mutable read menu2 value used by the m menu subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/m_menu.ml#L443)

<a id="global-global-savecharindex-savecharindex-src-m-menu-ml-1652832787"></a>
### saveCharIndex

```ml
saveCharIndex
```

Tracks the mutable save char index value used by the m menu subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/m_menu.ml#L369)

<a id="global-global-savedef-savedef-src-m-menu-ml-724121827"></a>
### SaveDef

```ml
SaveDef
```

Tracks the mutable save def value used by the m menu subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/m_menu.ml#L460)

<a id="global-global-savegamestrings-savegamestrings-src-m-menu-ml-2126488175"></a>
### savegamestrings

```ml
savegamestrings
```

Tracks the mutable savegamestrings value used by the m menu subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/m_menu.ml#L373)

<a id="global-global-savemenu-savemenu-src-m-menu-ml-1226019015"></a>
### SaveMenu

```ml
SaveMenu
```

Tracks the mutable save menu value used by the m menu subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/m_menu.ml#L458)

<a id="global-global-saveoldstring-saveoldstring-src-m-menu-ml-1818742287"></a>
### saveOldString

```ml
saveOldString
```

Tracks the mutable save old string value used by the m menu subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/m_menu.ml#L371)

<a id="global-global-saveslot-saveslot-src-m-menu-ml-1282312493"></a>
### saveSlot

```ml
saveSlot
```

Tracks the mutable save slot value used by the m menu subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/m_menu.ml#L367)

<a id="global-global-savestringenter-savestringenter-src-m-menu-ml-2051140487"></a>
### saveStringEnter

```ml
saveStringEnter
```

Tracks the mutable save string enter value used by the m menu subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/m_menu.ml#L365)

<a id="constant-constant-savestringsize-const-savestringsize-24-src-m-menu-ml-1783894156"></a>
### SAVESTRINGSIZE

```ml
const SAVESTRINGSIZE = 24
```

Defines savestringsize for the m menu subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/m_menu.ml#L44)

<a id="global-global-screenblocks-screenblocks-src-m-menu-ml-1850877639"></a>
### screenblocks

```ml
screenblocks
```

Tracks the mutable screenblocks value used by the m menu subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/m_menu.ml#L340)

<a id="global-global-screensize-screensize-src-m-menu-ml-67249981"></a>
### screenSize

```ml
screenSize
```

Tracks the mutable screen size value used by the m menu subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/m_menu.ml#L342)

<a id="constant-constant-scrnsize-const-scrnsize-3-src-m-menu-ml-915319917"></a>
### scrnsize

```ml
const scrnsize = 3
```

Defines scrnsize for the m menu subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/m_menu.ml#L562)

<a id="constant-constant-sfx-vol-const-sfx-vol-0-src-m-menu-ml-1346207244"></a>
### sfx_vol

```ml
const sfx_vol = 0
```

Defines sfx vol for the m menu subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/m_menu.ml#L584)

<a id="global-global-showmessages-showmessages-src-m-menu-ml-105605865"></a>
### showMessages

```ml
showMessages
```

Tracks the mutable show messages value used by the m menu subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/m_menu.ml#L335)

<a id="global-global-skullanimcounter-skullanimcounter-src-m-menu-ml-154844287"></a>
### skullAnimCounter

```ml
skullAnimCounter
```

Tracks the mutable skull anim counter value used by the m menu subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/m_menu.ml#L383)

<a id="global-global-skullname-skullname-src-m-menu-ml-374124151"></a>
### skullName

```ml
skullName
```

Stores the skull name collection used by the m menu subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/m_menu.ml#L387)

<a id="constant-constant-skullxoff-const-skullxoff-32-src-m-menu-ml-1828091098"></a>
### SKULLXOFF

```ml
const SKULLXOFF = -32
```

Defines skullxoff for the m menu subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/m_menu.ml#L47)

<a id="constant-constant-sound-end-const-sound-end-4-src-m-menu-ml-209171584"></a>
### sound_end

```ml
const sound_end = 4
```

Defines sound end for the m menu subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/m_menu.ml#L588)

<a id="global-global-sounddef-sounddef-src-m-menu-ml-1533294383"></a>
### SoundDef

```ml
SoundDef
```

Tracks the mutable sound def value used by the m menu subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/m_menu.ml#L450)

<a id="global-global-soundmenu-soundmenu-src-m-menu-ml-1803514719"></a>
### SoundMenu

```ml
SoundMenu
```

Tracks the mutable sound menu value used by the m menu subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/m_menu.ml#L448)

<a id="constant-constant-soundvol-const-soundvol-9-src-m-menu-ml-1609776169"></a>
### soundvol

```ml
const soundvol = 9
```

Defines soundvol for the m menu subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/m_menu.ml#L574)

<a id="global-global-tempstring-tempstring-src-m-menu-ml-1436353001"></a>
### tempstring

```ml
tempstring
```

Stores the mutable tempstring text used by the m menu subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/m_menu.ml#L395)

<a id="constant-constant-toorough-const-toorough-1-src-m-menu-ml-419399435"></a>
### toorough

```ml
const toorough = 1
```

Defines toorough for the m menu subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/m_menu.ml#L545)

<a id="constant-constant-violence-const-violence-3-src-m-menu-ml-694346905"></a>
### violence

```ml
const violence = 3
```

Defines violence for the m menu subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/m_menu.ml#L549)

<a id="global-global-whichskull-whichskull-src-m-menu-ml-2108738567"></a>
### whichSkull

```ml
whichSkull
```

Tracks the mutable which skull value used by the m menu subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/m_menu.ml#L385)
