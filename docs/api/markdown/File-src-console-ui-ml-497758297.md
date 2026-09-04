# `src/console_ui.ml`

[Home](README.md) · [Files](Files.md)

Owns console animation, history, input capture, scrolling, and drawing while delegating command execution.

Package: [`(global)`](Package-global-1952375359.md)

Reachable from entry: **yes**

## Imports

- `console_cmd.ml` → [src/console_cmd.ml](File-src-console-cmd-ml-361086087.md)
- `d_event.ml` → [src/d_event.ml](File-src-d-event-ml-1995118760.md)
- `doomdef.ml` → [src/doomdef.ml](File-src-doomdef-ml-460406769.md)
- `doomstat.ml` → [src/doomstat.ml](File-src-doomstat-ml-1652708088.md)
- `hu_lib.ml` → [src/hu_lib.ml](File-src-hu-lib-ml-937975676.md)
- `std/math.ml` → `../MiniLangCompilerOptimization/MiniLangCompilerPy/std/math.ml` — external dependency
- `std/string.ml` as `str` → `../MiniLangCompilerOptimization/MiniLangCompilerPy/std/string.ml` — external dependency
- `std/time.ml` → `../MiniLangCompilerOptimization/MiniLangCompilerPy/std/time.ml` — external dependency
- `v_video.ml` → [src/v_video.ml](File-src-v-video-ml-592999939.md)

## Declarations

<a id="function-function-cui-abs-inline-function-cui-abs-v-src-console-ui-ml-1883246339"></a>
### _CUI_Abs

```ml
inline function _CUI_Abs(v)
```

Returns a non-negative animation distance.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `v` | `dynamic` | — | Value consumed by the operation. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/console_ui.ml#L121)

<a id="global-global-cui-anim-duration-cui-anim-duration-src-console-ui-ml-1948243460"></a>
### _cui_anim_duration

```ml
_cui_anim_duration
```

Tracks the mutable cui anim duration value used by the console ui subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/console_ui.ml#L90)

<a id="global-global-cui-anim-start-height-cui-anim-start-height-src-console-ui-ml-796008444"></a>
### _cui_anim_start_height

```ml
_cui_anim_start_height
```

Tracks the mutable cui anim start height value used by the console ui subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/console_ui.ml#L81)

<a id="global-global-cui-anim-started-cui-anim-started-src-console-ui-ml-796281698"></a>
### _cui_anim_started

```ml
_cui_anim_started
```

Tracks the mutable cui anim started value used by the console ui subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/console_ui.ml#L87)

<a id="global-global-cui-anim-target-height-cui-anim-target-height-src-console-ui-ml-1254158298"></a>
### _cui_anim_target_height

```ml
_cui_anim_target_height
```

Tracks the mutable cui anim target height value used by the console ui subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/console_ui.ml#L84)

<a id="function-function-cui-drawfps-function-cui-drawfps-y-src-console-ui-ml-783082191"></a>
### _CUI_DrawFPS

```ml
function _CUI_DrawFPS(y)
```

Reuses one text widget until the sampled FPS changes, keeping the closed-console overlay inexpensive.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `y` | `dynamic` | — | Vertical map- or screen-space coordinate. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/console_ui.ml#L425)

<a id="function-function-cui-drawtext-function-cui-drawtext-x-y-text-cursor-src-console-ui-ml-103097450"></a>
### _CUI_DrawText

```ml
function _CUI_DrawText(x, y, text, cursor)
```

Draws one clipped STCFN text line at logical coordinates with an optional underscore cursor.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `x` | `dynamic` | — | Horizontal map- or screen-space coordinate. |
| `y` | `dynamic` | — | Vertical map- or screen-space coordinate. |
| `text` | `dynamic` | — | Text to process. |
| `cursor` | `dynamic` | — | Cursor value supplied to `_CUI_DrawText`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/console_ui.ml#L407)

<a id="global-global-cui-font-cui-font-src-console-ui-ml-1118865458"></a>
### _cui_font

```ml
_cui_font
```

Stores the cui font collection used by the console ui subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/console_ui.ml#L54)

<a id="global-global-cui-font-start-cui-font-start-src-console-ui-ml-1216717930"></a>
### _cui_font_start

```ml
_cui_font_start
```

Tracks the mutable cui font start value used by the console ui subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/console_ui.ml#L57)

<a id="global-global-cui-fps-line-cui-fps-line-src-console-ui-ml-637891110"></a>
### _cui_fps_line

```ml
_cui_fps_line
```

Holds the optional cui fps line resource used by the console ui subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/console_ui.ml#L99)

<a id="global-global-cui-fps-value-cui-fps-value-src-console-ui-ml-563929354"></a>
### _cui_fps_value

```ml
_cui_fps_value
```

Tracks the mutable cui fps value value used by the console ui subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/console_ui.ml#L102)

<a id="global-global-cui-height-cui-height-src-console-ui-ml-822339786"></a>
### _cui_height

```ml
_cui_height
```

Tracks the mutable cui height value used by the console ui subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/console_ui.ml#L78)

<a id="global-global-cui-history-cui-history-src-console-ui-ml-1460748060"></a>
### _cui_history

```ml
_cui_history
```

Stores the cui history collection used by the console ui subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/console_ui.ml#L63)

<a id="global-global-cui-history-pos-cui-history-pos-src-console-ui-ml-1745611210"></a>
### _cui_history_pos

```ml
_cui_history_pos
```

Tracks the mutable cui history pos value used by the console ui subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/console_ui.ml#L69)

<a id="function-function-cui-historydown-function-cui-historydown-src-console-ui-ml-829440016"></a>
### _CUI_HistoryDown

```ml
function _CUI_HistoryDown()
```

Loads the following submitted command or returns to a blank newest entry.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/console_ui.ml#L345)

<a id="function-function-cui-historyup-function-cui-historyup-src-console-ui-ml-2018724084"></a>
### _CUI_HistoryUp

```ml
function _CUI_HistoryUp()
```

Loads the preceding submitted command into the editable line.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/console_ui.ml#L336)

<a id="function-function-cui-idiv-inline-function-cui-idiv-a-b-src-console-ui-ml-1969479540"></a>
### _CUI_IDiv

```ml
inline function _CUI_IDiv(a, b)
```

Divides animation integers with truncation toward zero and a safe zero-divisor fallback.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `a` | `dynamic` | — | First input operand. |
| `b` | `dynamic` | — | Second input operand. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/console_ui.ml#L111)

<a id="global-global-cui-initialized-cui-initialized-src-console-ui-ml-1507803460"></a>
### _cui_initialized

```ml
_cui_initialized
```

Tracks whether cui initialized is active in the console ui subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/console_ui.ml#L51)

<a id="global-global-cui-input-cui-input-src-console-ui-ml-229549404"></a>
### _cui_input

```ml
_cui_input
```

Stores the mutable cui input text used by the console ui subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/console_ui.ml#L66)

<a id="global-global-cui-log-cui-log-src-console-ui-ml-836128948"></a>
### _cui_log

```ml
_cui_log
```

Stores the cui log collection used by the console ui subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/console_ui.ml#L60)

<a id="function-function-cui-maxscroll-inline-function-cui-maxscroll-src-console-ui-ml-1948165335"></a>
### _CUI_MaxScroll

```ml
inline function _CUI_MaxScroll()
```

Computes the oldest valid viewport offset for the fixed visible line count.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/console_ui.ml#L189)

<a id="global-global-cui-pause-owned-cui-pause-owned-src-console-ui-ml-675741620"></a>
### _cui_pause_owned

```ml
_cui_pause_owned
```

Tracks whether cui pause owned is active in the console ui subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/console_ui.ml#L93)

<a id="global-global-cui-pause-restore-cui-pause-restore-src-console-ui-ml-6743002"></a>
### _cui_pause_restore

```ml
_cui_pause_restore
```

Tracks whether cui pause restore is active in the console ui subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/console_ui.ml#L96)

<a id="function-function-cui-recordhistory-function-cui-recordhistory-command-src-console-ui-ml-556637949"></a>
### _CUI_RecordHistory

```ml
function _CUI_RecordHistory(command)
```

Adds one submitted command to bounded navigation history, avoiding adjacent duplicates.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `command` | `dynamic` | — | Command value supplied to `_CUI_RecordHistory`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/console_ui.ml#L299)

<a id="function-function-cui-releasepause-function-cui-releasepause-src-console-ui-ml-315117964"></a>
### _CUI_ReleasePause

```ml
function _CUI_ReleasePause()
```

Restores the pause state that existed before the console began capturing input.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/console_ui.ml#L213)

<a id="global-global-cui-scroll-cui-scroll-src-console-ui-ml-491038030"></a>
### _cui_scroll

```ml
_cui_scroll
```

Tracks the mutable cui scroll value used by the console ui subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/console_ui.ml#L72)

<a id="function-function-cui-setinput-function-cui-setinput-text-src-console-ui-ml-1104276507"></a>
### _CUI_SetInput

```ml
function _CUI_SetInput(text)
```

Replaces the editable command text with a bounded history entry.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `text` | `dynamic` | — | Text to process. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/console_ui.ml#L198)

<a id="global-global-cui-shift-down-cui-shift-down-src-console-ui-ml-1401363166"></a>
### _cui_shift_down

```ml
_cui_shift_down
```

Tracks whether cui shift down is active in the console ui subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/console_ui.ml#L105)

<a id="function-function-cui-submit-function-cui-submit-src-console-ui-ml-717145354"></a>
### _CUI_Submit

```ml
function _CUI_Submit()
```

Sends the current line across the parser boundary and applies only the returned UI requests.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/console_ui.ml#L315)

<a id="function-function-cui-updateanimation-function-cui-updateanimation-src-console-ui-ml-904492828"></a>
### _CUI_UpdateAnimation

```ml
function _CUI_UpdateAnimation()
```

Advances the time-based slide and releases the owned pause only after the closing panel fully exits.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/console_ui.ml#L224)

<a id="global-global-cui-wanted-open-cui-wanted-open-src-console-ui-ml-124517780"></a>
### _cui_wanted_open

```ml
_cui_wanted_open
```

Tracks whether cui wanted open is active in the console ui subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/console_ui.ml#L75)

<a id="constant-constant-cui-animation-ms-const-cui-animation-ms-200-src-console-ui-ml-2066575739"></a>
### CUI_ANIMATION_MS

```ml
const CUI_ANIMATION_MS = 200
```

Defines cui animation ms for the console ui subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/console_ui.ml#L33)

<a id="constant-constant-cui-background-color-const-cui-background-color-0-src-console-ui-ml-1700442531"></a>
### CUI_BACKGROUND_COLOR

```ml
const CUI_BACKGROUND_COLOR = 0
```

Defines the Doom palette selection for cui background color.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/console_ui.ml#L45)

<a id="constant-constant-cui-border-color-const-cui-border-color-176-src-console-ui-ml-623419769"></a>
### CUI_BORDER_COLOR

```ml
const CUI_BORDER_COLOR = 176
```

Defines the Doom palette selection for cui border color.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/console_ui.ml#L47)

<a id="function-function-cui-clearlog-function-cui-clearlog-src-console-ui-ml-77916864"></a>
### CUI_ClearLog

```ml
function CUI_ClearLog()
```

Clears console scrollback without altering command history or current input.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/console_ui.ml#L180)

<a id="function-function-cui-drawer-function-cui-drawer-src-console-ui-ml-198107576"></a>
### CUI_Drawer

```ml
function CUI_Drawer()
```

Renders the animated translucent panel, scrollback, separator, input line, and optional FPS counter.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/console_ui.ml#L449)

<a id="function-function-cui-init-function-cui-init-src-console-ui-ml-1631764492"></a>
### CUI_Init

```ml
function CUI_Init()
```

Initializes bounded console collections and seeds the first informational log line exactly once.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/console_ui.ml#L127)

<a id="function-function-cui-iscapturing-function-cui-iscapturing-src-console-ui-ml-487224982"></a>
### CUI_IsCapturing

```ml
function CUI_IsCapturing()
```

Reports whether visible or animating console UI must consume all gameplay input.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/console_ui.ml#L291)

<a id="constant-constant-cui-line-step-const-cui-line-step-9-src-console-ui-ml-2085635486"></a>
### CUI_LINE_STEP

```ml
const CUI_LINE_STEP = 9
```

Defines cui line step for the console ui subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/console_ui.ml#L43)

<a id="function-function-cui-log-function-cui-log-message-src-console-ui-ml-1718517383"></a>
### CUI_Log

```ml
function CUI_Log(message)
```

Splits and appends chronological system, error, chat, or command text to bounded scrollback.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `message` | `dynamic` | — | Message text or payload to process. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/console_ui.ml#L158)

<a id="constant-constant-cui-max-history-const-cui-max-history-32-src-console-ui-ml-558048558"></a>
### CUI_MAX_HISTORY

```ml
const CUI_MAX_HISTORY = 32
```

Defines the maximum cui max history accepted by the console ui subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/console_ui.ml#L37)

<a id="constant-constant-cui-max-input-const-cui-max-input-60-src-console-ui-ml-1200508093"></a>
### CUI_MAX_INPUT

```ml
const CUI_MAX_INPUT = 60
```

Defines the maximum cui max input accepted by the console ui subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/console_ui.ml#L39)

<a id="constant-constant-cui-max-log-lines-const-cui-max-log-lines-256-src-console-ui-ml-967416556"></a>
### CUI_MAX_LOG_LINES

```ml
const CUI_MAX_LOG_LINES = 256
```

Defines the maximum cui max log lines accepted by the console ui subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/console_ui.ml#L35)

<a id="constant-constant-cui-panel-height-const-cui-panel-height-68-src-console-ui-ml-328432219"></a>
### CUI_PANEL_HEIGHT

```ml
const CUI_PANEL_HEIGHT = 68
```

Defines cui panel height for the console ui subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/console_ui.ml#L31)

<a id="function-function-cui-responder-function-cui-responder-ev-src-console-ui-ml-35117197"></a>
### CUI_Responder

```ml
function CUI_Responder(ev)
```

Toggles on tilde/O-umlaut, edits commands, scrolls output, and consumes every event while captured.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `ev` | `dynamic` | — | Input event to process. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/console_ui.ml#L359)

<a id="function-function-cui-setfont-function-cui-setfont-font-startchar-src-console-ui-ml-1652528233"></a>
### CUI_SetFont

```ml
function CUI_SetFont(font, startchar)
```

Receives the already cached STCFN HUD font so console text exactly matches one-line game messages.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `font` | `dynamic` | — | Font value supplied to `CUI_SetFont`. |
| `startchar` | `dynamic` | — | Startchar value supplied to `CUI_SetFont`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/console_ui.ml#L143)

<a id="function-function-cui-setopen-function-cui-setopen-openconsole-src-console-ui-ml-759482309"></a>
### CUI_SetOpen

```ml
function CUI_SetOpen(openConsole)
```

Starts a reversible constant-speed slide and acquires or eventually restores the gameplay pause.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `openConsole` | `dynamic` | — | Open console value supplied to `CUI_SetOpen`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/console_ui.ml#L251)

<a id="function-function-cui-toggle-function-cui-toggle-src-console-ui-ml-467478780"></a>
### CUI_Toggle

```ml
function CUI_Toggle()
```

Reverses the current console target while preserving in-flight animation continuity.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/console_ui.ml#L286)

<a id="constant-constant-cui-visible-lines-const-cui-visible-lines-5-src-console-ui-ml-1206492594"></a>
### CUI_VISIBLE_LINES

```ml
const CUI_VISIBLE_LINES = 5
```

Defines cui visible lines for the console ui subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/console_ui.ml#L41)
