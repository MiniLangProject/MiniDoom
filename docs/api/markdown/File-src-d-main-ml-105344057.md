# `src/d_main.ml`

[Home](README.md) · [Files](Files.md)

Bootstraps WADs and engine subsystems, then drives title sequencing, frame dispatch, and profiling.

Package: [`(global)`](Package-global-1952375359.md)

Reachable from entry: **yes**

## Imports

- `am_map.ml` → [src/am_map.ml](File-src-am-map-ml-1409794280.md)
- `console_ui.ml` → [src/console_ui.ml](File-src-console-ui-ml-497758297.md)
- `d_event.ml` → [src/d_event.ml](File-src-d-event-ml-1995118760.md)
- `doomdef.ml` → [src/doomdef.ml](File-src-doomdef-ml-460406769.md)
- `doomstat.ml` → [src/doomstat.ml](File-src-doomstat-ml-1652708088.md)
- `dstrings.ml` → [src/dstrings.ml](File-src-dstrings-ml-567491523.md)
- `f_finale.ml` → [src/f_finale.ml](File-src-f-finale-ml-635076109.md)
- `f_wipe.ml` → [src/f_wipe.ml](File-src-f-wipe-ml-1921092045.md)
- `g_game.ml` → [src/g_game.ml](File-src-g-game-ml-257299317.md)
- `hdwad_builder.ml` → [src/hdwad_builder.ml](File-src-hdwad-builder-ml-980370789.md)
- `hu_stuff.ml` → [src/hu_stuff.ml](File-src-hu-stuff-ml-1965779679.md)
- `i_gl.ml` → [src/i_gl.ml](File-src-i-gl-ml-2113703076.md)
- `i_sound.ml` → [src/i_sound.ml](File-src-i-sound-ml-33806980.md)
- `i_system.ml` → [src/i_system.ml](File-src-i-system-ml-1632920966.md)
- `i_video.ml` → [src/i_video.ml](File-src-i-video-ml-140536292.md)
- `m_argv.ml` → [src/m_argv.ml](File-src-m-argv-ml-728984635.md)
- `m_menu.ml` → [src/m_menu.ml](File-src-m-menu-ml-331716860.md)
- `m_misc.ml` → [src/m_misc.ml](File-src-m-misc-ml-906836777.md)
- `mp_platform.ml` → [src/mp_platform.ml](File-src-mp-platform-ml-1361006310.md)
- `p_setup.ml` → [src/p_setup.ml](File-src-p-setup-ml-2057900615.md)
- `r_gl.ml` → [src/r_gl.ml](File-src-r-gl-ml-2087530889.md)
- `r_hires.ml` → [src/r_hires.ml](File-src-r-hires-ml-694005807.md)
- `r_local.ml` → [src/r_local.ml](File-src-r-local-ml-797040731.md)
- `r_renderer.ml` → [src/r_renderer.ml](File-src-r-renderer-ml-72894217.md)
- `r_upscaled.ml` → [src/r_upscaled.ml](File-src-r-upscaled-ml-1801241933.md)
- `s_sound.ml` → [src/s_sound.ml](File-src-s-sound-ml-1485495390.md)
- `sounds.ml` → [src/sounds.ml](File-src-sounds-ml-1875364049.md)
- `st_stuff.ml` → [src/st_stuff.ml](File-src-st-stuff-ml-811030939.md)
- `std/fs.ml` as `fs` → `../MiniLangCompilerOptimization/MiniLangCompilerPy/std/fs.ml` — external dependency
- `std/math.ml` → `../MiniLangCompilerOptimization/MiniLangCompilerPy/std/math.ml` — external dependency
- `std/time.ml` → `../MiniLangCompilerOptimization/MiniLangCompilerPy/std/time.ml` — external dependency
- `tables.ml` → [src/tables.ml](File-src-tables-ml-1959718242.md)
- `v_video.ml` → [src/v_video.ml](File-src-v-video-ml-592999939.md)
- `w_wad.ml` → [src/w_wad.ml](File-src-w-wad-ml-893006035.md)
- `wi_stuff.ml` → [src/wi_stuff.ml](File-src-wi-stuff-ml-450049266.md)
- `z_zone.ml` → [src/z_zone.ml](File-src-z-zone-ml-1788911354.md)

## Declarations

<a id="function-function-d-adddemolmpfromargs-inline-function-d-adddemolmpfromargs-flag-src-d-main-ml-50079807"></a>
### _D_AddDemoLmpFromArgs

```ml
inline function _D_AddDemoLmpFromArgs(flag)
```

Adds demo lump from args entries to the Doom core.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `flag` | `dynamic` | — | Flag value supplied to `_D_AddDemoLmpFromArgs`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/d_main.ml#L1502)

<a id="function-function-d-argvalue-function-d-argvalue-flag-src-d-main-ml-2067337204"></a>
### _D_ArgValue

```ml
function _D_ArgValue(flag)
```

Returns the string immediately following a command-line flag without consuming later options.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `flag` | `dynamic` | — | Flag value supplied to `_D_ArgValue`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/d_main.ml#L841)

<a id="function-function-d-attachexistingautohdwad-function-d-attachexistingautohdwad-src-d-main-ml-1041324584"></a>
### _D_AttachExistingAutoHDWAD

```ml
function _D_AttachExistingAutoHDWAD()
```

Adds an existing automatic HDWAD to the WAD list before the WAD system starts.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/d_main.ml#L885)

<a id="function-function-d-autohdwadshouldrun-function-d-autohdwadshouldrun-src-d-main-ml-70311158"></a>
### _D_AutoHDWADShouldRun

```ml
function _D_AutoHDWADShouldRun()
```

Checks whether OpenGL should automatically use a generated HDWAD.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/d_main.ml#L876)

<a id="function-function-d-digitat-function-d-digitat-s-idx-src-d-main-ml-1791104708"></a>
### _D_DigitAt

```ml
function _D_DigitAt(s, idx)
```

Decodes one ASCII decimal digit at a checked string offset.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `s` | `dynamic` | — | S value supplied to `_D_DigitAt`. |
| `idx` | `dynamic` | — | Zero-based element or table index. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/d_main.ml#L904)

<a id="function-function-d-drawmpdebugoverlay-function-d-drawmpdebugoverlay-src-d-main-ml-22849900"></a>
### _D_DrawMPDebugOverlay

```ml
function _D_DrawMPDebugOverlay()
```

Renders multiplayer debug telemetry text overlay when MP runtime is active.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/d_main.ml#L459)

<a id="function-function-d-filereadable-inline-function-d-filereadable-path-src-d-main-ml-2024005632"></a>
### _D_FileReadable

```ml
inline function _D_FileReadable(path)
```

Accepts only non-empty paths that currently resolve to regular files.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `path` | `dynamic` | — | Filesystem path to process. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/d_main.ml#L1517)

<a id="function-function-d-generatehdwadcacheafterinit-function-d-generatehdwadcacheafterinit-src-d-main-ml-1961071664"></a>
### _D_GenerateHDWADCacheAfterInit

```ml
function _D_GenerateHDWADCacheAfterInit()
```

Initializes generate HDWADCache After Init state for the Doom core system.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/d_main.ml#L1394)

<a id="function-function-d-geomnameformapname-function-d-geomnameformapname-mapname-src-d-main-ml-1073924187"></a>
### _D_GeomNameForMapName

```ml
function _D_GeomNameForMapName(mapName)
```

Converts a map marker into its deterministic cached-geometry lump name.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `mapName` | `dynamic` | — | Map name value supplied to `_D_GeomNameForMapName`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/d_main.ml#L995)

<a id="global-global-d-hdwad-progress-done-d-hdwad-progress-done-src-d-main-ml-494974996"></a>
### _d_hdwad_progress_done

```ml
_d_hdwad_progress_done
```

Tracks the mutable d hdwad progress done value used by the d main subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/d_main.ml#L229)

<a id="global-global-d-hdwad-progress-last-draw-ms-d-hdwad-progress-last-draw-ms-src-d-main-ml-638889056"></a>
### _d_hdwad_progress_last_draw_ms

```ml
_d_hdwad_progress_last_draw_ms
```

Tracks the mutable d hdwad progress last draw ms value used by the d main subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/d_main.ml#L244)

<a id="global-global-d-hdwad-progress-phase-base-d-hdwad-progress-phase-base-src-d-main-ml-2031343878"></a>
### _d_hdwad_progress_phase_base

```ml
_d_hdwad_progress_phase_base
```

Tracks the mutable d hdwad progress phase base value used by the d main subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/d_main.ml#L232)

<a id="global-global-d-hdwad-progress-phase-done-d-hdwad-progress-phase-done-src-d-main-ml-1787302284"></a>
### _d_hdwad_progress_phase_done

```ml
_d_hdwad_progress_phase_done
```

Tracks the mutable d hdwad progress phase done value used by the d main subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/d_main.ml#L238)

<a id="global-global-d-hdwad-progress-phase-expected-d-hdwad-progress-phase-expected-src-d-main-ml-80643424"></a>
### _d_hdwad_progress_phase_expected

```ml
_d_hdwad_progress_phase_expected
```

Tracks the mutable d hdwad progress phase expected value used by the d main subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/d_main.ml#L241)

<a id="global-global-d-hdwad-progress-phase-span-d-hdwad-progress-phase-span-src-d-main-ml-1796226228"></a>
### _d_hdwad_progress_phase_span

```ml
_d_hdwad_progress_phase_span
```

Tracks the mutable d hdwad progress phase span value used by the d main subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/d_main.ml#L235)

<a id="global-global-d-hdwad-progress-start-ms-d-hdwad-progress-start-ms-src-d-main-ml-176503254"></a>
### _d_hdwad_progress_start_ms

```ml
_d_hdwad_progress_start_ms
```

Tracks the mutable d hdwad progress start ms value used by the d main subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/d_main.ml#L223)

<a id="global-global-d-hdwad-progress-total-d-hdwad-progress-total-src-d-main-ml-346754866"></a>
### _d_hdwad_progress_total

```ml
_d_hdwad_progress_total
```

Tracks the mutable d hdwad progress total value used by the d main subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/d_main.ml#L226)

<a id="global-global-d-hdwad-status-text-d-hdwad-status-text-src-d-main-ml-1284291304"></a>
### _d_hdwad_status_text

```ml
_d_hdwad_status_text
```

Stores the mutable d hdwad status text text used by the d main subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/d_main.ml#L220)

<a id="function-function-d-hdwaddrawloadingscreen-function-d-hdwaddrawloadingscreen-text-src-d-main-ml-823449429"></a>
### _D_HDWADDrawLoadingScreen

```ml
function _D_HDWADDrawLoadingScreen(text)
```

Presents TITLEPIC with centered Doom-font HDWAD progress text.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `text` | `dynamic` | — | Text to process. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/d_main.ml#L1262)

<a id="function-function-d-hdwaddrawtext-function-d-hdwaddrawtext-text-y-src-d-main-ml-959629828"></a>
### _D_HDWADDrawText

```ml
function _D_HDWADDrawText(text, y)
```

Draws centered loading text with Doom STCFN font patches.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `text` | `dynamic` | — | Text to process. |
| `y` | `dynamic` | — | Vertical map- or screen-space coordinate. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/d_main.ml#L1198)

<a id="function-function-d-hdwaddurationtext-function-d-hdwaddurationtext-ms-src-d-main-ml-326478272"></a>
### _D_HDWADDurationText

```ml
function _D_HDWADDurationText(ms)
```

Formats a millisecond duration for the HDWAD loading progress line.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `ms` | `dynamic` | — | Ms value supplied to `_D_HDWADDurationText`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/d_main.ml#L1226)

<a id="function-function-d-hdwadfinishprogressphase-function-d-hdwadfinishprogressphase-src-d-main-ml-1422196558"></a>
### _D_HDWADFinishProgressPhase

```ml
function _D_HDWADFinishProgressPhase()
```

Completes the current weighted HDWAD generation phase.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/d_main.ml#L1333)

<a id="function-function-d-hdwadfontlump-function-d-hdwadfontlump-code-src-d-main-ml-1704901931"></a>
### _D_HDWADFontLump

```ml
function _D_HDWADFontLump(code)
```

Builds the STCFN lump name used for HDWAD loading text.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `code` | `dynamic` | — | Code value supplied to `_D_HDWADFontLump`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/d_main.ml#L1142)

<a id="function-function-d-hdwadlookscomplete-function-d-hdwadlookscomplete-path-src-d-main-ml-1081017943"></a>
### _D_HDWADLooksComplete

```ml
function _D_HDWADLooksComplete(path)
```

Validates that an HDWAD contains metadata and generated geometry required for reuse.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `path` | `dynamic` | — | Filesystem path to process. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/d_main.ml#L1110)

<a id="function-function-d-hdwadpatchwidth-inline-function-d-hdwadpatchwidth-patch-src-d-main-ml-1086702265"></a>
### _D_HDWADPatchWidth

```ml
inline function _D_HDWADPatchWidth(patch)
```

Reads a Doom patch width without depending on renderer init.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `patch` | `dynamic` | — | Patch value supplied to `_D_HDWADPatchWidth`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/d_main.ml#L1160)

<a id="function-function-d-hdwadpathforwad-function-d-hdwadpathforwad-wad-src-d-main-ml-158585034"></a>
### _D_HDWADPathForWad

```ml
function _D_HDWADPathForWad(wad)
```

Derives the automatic HD rendering-cache sidecar path for a gameplay WAD.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `wad` | `dynamic` | — | Wad value supplied to `_D_HDWADPathForWad`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/d_main.ml#L870)

<a id="function-function-d-hdwadprogressline-function-d-hdwadprogressline-src-d-main-ml-796470732"></a>
### _D_HDWADProgressLine

```ml
function _D_HDWADProgressLine()
```

Builds the second HDWAD loading line with percent and remaining time.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/d_main.ml#L1238)

<a id="function-function-d-hdwadprogressreset-function-d-hdwadprogressreset-src-d-main-ml-632285652"></a>
### _D_HDWADProgressReset

```ml
function _D_HDWADProgressReset()
```

Clears HDWAD loading progress state.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/d_main.ml#L1283)

<a id="function-function-d-hdwadscalefromargs-function-d-hdwadscalefromargs-src-d-main-ml-579520774"></a>
### _D_HDWADScaleFromArgs

```ml
function _D_HDWADScaleFromArgs()
```

Parses and clamps the requested offline HDWAD upscale factor.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/d_main.ml#L1135)

<a id="function-function-d-hdwadsetprogressphase-function-d-hdwadsetprogressphase-text-basepct-spanpct-expectedunits-src-d-main-ml-1575591239"></a>
### _D_HDWADSetProgressPhase

```ml
function _D_HDWADSetProgressPhase(text, basePct, spanPct, expectedUnits)
```

Starts a weighted HDWAD generation phase.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `text` | `dynamic` | — | Text to process. |
| `basePct` | `dynamic` | — | Base pct value supplied to `_D_HDWADSetProgressPhase`. |
| `spanPct` | `dynamic` | — | Span pct value supplied to `_D_HDWADSetProgressPhase`. |
| `expectedUnits` | `dynamic` | — | Expected units value supplied to `_D_HDWADSetProgressPhase`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/d_main.ml#L1311)

<a id="function-function-d-hdwadstatus-function-d-hdwadstatus-text-src-d-main-ml-417622277"></a>
### _D_HDWADStatus

```ml
function _D_HDWADStatus(text)
```

Shows the current HDWAD generation phase in the application title.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `text` | `dynamic` | — | Text to process. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/d_main.ml#L1376)

<a id="function-function-d-hdwadtextbyte-inline-function-d-hdwadtextbyte-c-src-d-main-ml-837423998"></a>
### _D_HDWADTextByte

```ml
inline function _D_HDWADTextByte(c)
```

Normalizes one byte for the HDWAD loading font.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `c` | `dynamic` | — | C value supplied to `_D_HDWADTextByte`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/d_main.ml#L1152)

<a id="function-function-d-hdwadtextwidth-function-d-hdwadtextwidth-text-src-d-main-ml-1971104415"></a>
### _D_HDWADTextWidth

```ml
function _D_HDWADTextWidth(text)
```

Measures loading text using Doom STCFN font patches.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `text` | `dynamic` | — | Text to process. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/d_main.ml#L1170)

<a id="function-function-d-idiv-inline-function-d-idiv-a-b-src-d-main-ml-928454260"></a>
### _D_IDiv

```ml
inline function _D_IDiv(a, b)
```

Returns a quotient truncated toward zero, mapping non-integers and division by zero to zero.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `a` | `dynamic` | — | First input operand. |
| `b` | `dynamic` | — | Second input operand. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/d_main.ml#L482)

<a id="function-function-d-initeventqueue-function-d-initeventqueue-src-d-main-ml-235089890"></a>
### _D_InitEventQueue

```ml
function _D_InitEventQueue()
```

Clears the fixed-size input event ring and resets both producer and consumer cursors.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/d_main.ml#L593)

<a id="function-function-d-ismapmarkername-function-d-ismapmarkername-name-src-d-main-ml-590616133"></a>
### _D_IsMapMarkerName

```ml
function _D_IsMapMarkerName(name)
```

Recognizes canonical MAPxx and ExMy lump markers with decimal digit validation.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `name` | `dynamic` | — | Resource or object name to resolve. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/d_main.ml#L1002)

<a id="function-function-d-isresponsetokenbyte-inline-function-d-isresponsetokenbyte-c-src-d-main-ml-7371724"></a>
### _D_IsResponseTokenByte

```ml
inline function _D_IsResponseTokenByte(c)
```

Accepts the non-whitespace printable byte range used while tokenizing response files.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `c` | `dynamic` | — | C value supplied to `_D_IsResponseTokenByte`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/d_main.ml#L1570)

<a id="function-function-d-iswadpath-function-d-iswadpath-path-src-d-main-ml-1746733613"></a>
### _D_IsWadPath

```ml
function _D_IsWadPath(path)
```

Recognizes case-insensitive .wad filenames before deriving an adjacent HDWAD cache path.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `path` | `dynamic` | — | Filesystem path to process. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/d_main.ml#L852)

<a id="function-function-d-mapnamefor-function-d-mapnamefor-episode-map-src-d-main-ml-1238491371"></a>
### _D_MapNameFor

```ml
function _D_MapNameFor(episode, map)
```

Formats an episode/map pair using the active IWAD naming convention.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `episode` | `dynamic` | — | Episode value supplied to `_D_MapNameFor`. |
| `map` | `dynamic` | — | Map value supplied to `_D_MapNameFor`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/d_main.ml#L917)

<a id="function-function-d-mappairsfromlumps-function-d-mappairsfromlumps-lumps-src-d-main-ml-606199023"></a>
### _D_MapPairsFromLumps

```ml
function _D_MapPairsFromLumps(lumps)
```

Discovers playable episode/map pairs from loaded WAD marker lumps.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `lumps` | `dynamic` | — | Lumps value supplied to `_D_MapPairsFromLumps`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/d_main.ml#L1017)

<a id="function-function-d-nameinlist-function-d-nameinlist-names-name-src-d-main-ml-803184755"></a>
### _D_NameInList

```ml
function _D_NameInList(names, name)
```

Tests ASCII map/lump membership without allocating a secondary lookup table.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `names` | `dynamic` | — | Names value supplied to `_D_NameInList`. |
| `name` | `dynamic` | — | Resource or object name to resolve. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/d_main.ml#L1097)

<a id="function-function-d-parseresponseargs-function-d-parseresponseargs-data-src-d-main-ml-1258154820"></a>
### _D_ParseResponseArgs

```ml
function _D_ParseResponseArgs(data)
```

Parses parse Response Args input into Doom core runtime data.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `data` | `dynamic` | — | Binary or structured data to process. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/d_main.ml#L1577)

<a id="function-function-d-parsewadfilesfromargs-function-d-parsewadfilesfromargs-src-d-main-ml-2140936060"></a>
### _D_ParseWadFilesFromArgs

```ml
function _D_ParseWadFilesFromArgs()
```

Parses parse Wad Files From Args input into Doom core runtime data.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/d_main.ml#L812)

<a id="global-global-d-prof-am-ms-d-prof-am-ms-src-d-main-ml-1937316634"></a>
### _d_prof_am_ms

```ml
_d_prof_am_ms
```

Tracks the mutable d prof am ms value used by the d main subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/d_main.ml#L123)

<a id="global-global-d-prof-frame-hist-d-prof-frame-hist-src-d-main-ml-530628070"></a>
### _d_prof_frame_hist

```ml
_d_prof_frame_hist
```

Stores the d prof frame hist collection used by the d main subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/d_main.ml#L204)

<a id="global-global-d-prof-frame-max-us-d-prof-frame-max-us-src-d-main-ml-530578624"></a>
### _d_prof_frame_max_us

```ml
_d_prof_frame_max_us
```

Tracks the mutable d prof frame max us value used by the d main subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/d_main.ml#L210)

<a id="global-global-d-prof-frame-samples-d-prof-frame-samples-src-d-main-ml-1919973202"></a>
### _d_prof_frame_samples

```ml
_d_prof_frame_samples
```

Tracks the mutable d prof frame samples value used by the d main subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/d_main.ml#L207)

<a id="global-global-d-prof-frames-d-prof-frames-src-d-main-ml-1371815742"></a>
### _d_prof_frames

```ml
_d_prof_frames
```

Tracks the mutable d prof frames value used by the d main subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/d_main.ml#L111)

<a id="global-global-d-prof-gl-boundary-ms-d-prof-gl-boundary-ms-src-d-main-ml-335405140"></a>
### _d_prof_gl_boundary_ms

```ml
_d_prof_gl_boundary_ms
```

Tracks the mutable d prof gl boundary ms value used by the d main subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/d_main.ml#L162)

<a id="global-global-d-prof-gl-cache-ms-d-prof-gl-cache-ms-src-d-main-ml-392675362"></a>
### _d_prof_gl_cache_ms

```ml
_d_prof_gl_cache_ms
```

Tracks the mutable d prof gl cache ms value used by the d main subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/d_main.ml#L156)

<a id="global-global-d-prof-gl-depth-ms-d-prof-gl-depth-ms-src-d-main-ml-1804199934"></a>
### _d_prof_gl_depth_ms

```ml
_d_prof_gl_depth_ms
```

Tracks the mutable d prof gl depth ms value used by the d main subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/d_main.ml#L165)

<a id="global-global-d-prof-gl-dyn-ms-d-prof-gl-dyn-ms-src-d-main-ml-1144900874"></a>
### _d_prof_gl_dyn_ms

```ml
_d_prof_gl_dyn_ms
```

Tracks the mutable d prof gl dyn ms value used by the d main subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/d_main.ml#L153)

<a id="global-global-d-prof-gl-flat-batches-d-prof-gl-flat-batches-src-d-main-ml-1030503002"></a>
### _d_prof_gl_flat_batches

```ml
_d_prof_gl_flat_batches
```

Tracks the mutable d prof gl flat batches value used by the d main subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/d_main.ml#L186)

<a id="global-global-d-prof-gl-flat-drawn-d-prof-gl-flat-drawn-src-d-main-ml-121088866"></a>
### _d_prof_gl_flat_drawn

```ml
_d_prof_gl_flat_drawn
```

Tracks the mutable d prof gl flat drawn value used by the d main subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/d_main.ml#L189)

<a id="global-global-d-prof-gl-flat-vertices-d-prof-gl-flat-vertices-src-d-main-ml-1517021028"></a>
### _d_prof_gl_flat_vertices

```ml
_d_prof_gl_flat_vertices
```

Tracks the mutable d prof gl flat vertices value used by the d main subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/d_main.ml#L192)

<a id="global-global-d-prof-gl-flats-ms-d-prof-gl-flats-ms-src-d-main-ml-926843862"></a>
### _d_prof_gl_flats_ms

```ml
_d_prof_gl_flats_ms
```

Tracks the mutable d prof gl flats ms value used by the d main subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/d_main.ml#L168)

<a id="global-global-d-prof-gl-light-ms-d-prof-gl-light-ms-src-d-main-ml-726212318"></a>
### _d_prof_gl_light_ms

```ml
_d_prof_gl_light_ms
```

Tracks the mutable d prof gl light ms value used by the d main subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/d_main.ml#L183)

<a id="global-global-d-prof-gl-masked-ms-d-prof-gl-masked-ms-src-d-main-ml-1912148182"></a>
### _d_prof_gl_masked_ms

```ml
_d_prof_gl_masked_ms
```

Tracks the mutable d prof gl masked ms value used by the d main subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/d_main.ml#L177)

<a id="global-global-d-prof-gl-sky-ms-d-prof-gl-sky-ms-src-d-main-ml-1736688358"></a>
### _d_prof_gl_sky_ms

```ml
_d_prof_gl_sky_ms
```

Tracks the mutable d prof gl sky ms value used by the d main subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/d_main.ml#L159)

<a id="global-global-d-prof-gl-sprites-ms-d-prof-gl-sprites-ms-src-d-main-ml-1511277150"></a>
### _d_prof_gl_sprites_ms

```ml
_d_prof_gl_sprites_ms
```

Tracks the mutable d prof gl sprites ms value used by the d main subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/d_main.ml#L174)

<a id="global-global-d-prof-gl-wall-batches-d-prof-gl-wall-batches-src-d-main-ml-424569470"></a>
### _d_prof_gl_wall_batches

```ml
_d_prof_gl_wall_batches
```

Tracks the mutable d prof gl wall batches value used by the d main subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/d_main.ml#L195)

<a id="global-global-d-prof-gl-wall-drawn-d-prof-gl-wall-drawn-src-d-main-ml-98978170"></a>
### _d_prof_gl_wall_drawn

```ml
_d_prof_gl_wall_drawn
```

Tracks the mutable d prof gl wall drawn value used by the d main subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/d_main.ml#L198)

<a id="global-global-d-prof-gl-wall-vertices-d-prof-gl-wall-vertices-src-d-main-ml-93723878"></a>
### _d_prof_gl_wall_vertices

```ml
_d_prof_gl_wall_vertices
```

Tracks the mutable d prof gl wall vertices value used by the d main subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/d_main.ml#L201)

<a id="global-global-d-prof-gl-walls-ms-d-prof-gl-walls-ms-src-d-main-ml-1355006206"></a>
### _d_prof_gl_walls_ms

```ml
_d_prof_gl_walls_ms
```

Tracks the mutable d prof gl walls ms value used by the d main subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/d_main.ml#L171)

<a id="global-global-d-prof-gl-weapon-ms-d-prof-gl-weapon-ms-src-d-main-ml-21141880"></a>
### _d_prof_gl_weapon_ms

```ml
_d_prof_gl_weapon_ms
```

Tracks the mutable d prof gl weapon ms value used by the d main subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/d_main.ml#L180)

<a id="global-global-d-prof-hu-ms-d-prof-hu-ms-src-d-main-ml-349316902"></a>
### _d_prof_hu_ms

```ml
_d_prof_hu_ms
```

Tracks the mutable d prof hu ms value used by the d main subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/d_main.ml#L120)

<a id="global-global-d-prof-last-frame-us-d-prof-last-frame-us-src-d-main-ml-2019854678"></a>
### _d_prof_last_frame_us

```ml
_d_prof_last_frame_us
```

Tracks the mutable d prof last frame us value used by the d main subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/d_main.ml#L213)

<a id="global-global-d-prof-mobj-thinkers-d-prof-mobj-thinkers-src-d-main-ml-985779814"></a>
### _d_prof_mobj_thinkers

```ml
_d_prof_mobj_thinkers
```

Tracks the mutable d prof mobj thinkers value used by the d main subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/d_main.ml#L150)

<a id="global-global-d-prof-other-ms-d-prof-other-ms-src-d-main-ml-49175492"></a>
### _d_prof_other_ms

```ml
_d_prof_other_ms
```

Tracks the mutable d prof other ms value used by the d main subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/d_main.ml#L126)

<a id="global-global-d-prof-player-ms-d-prof-player-ms-src-d-main-ml-1143508838"></a>
### _d_prof_player_ms

```ml
_d_prof_player_ms
```

Tracks the mutable d prof player ms value used by the d main subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/d_main.ml#L135)

<a id="global-global-d-prof-r-ms-d-prof-r-ms-src-d-main-ml-420052356"></a>
### _d_prof_r_ms

```ml
_d_prof_r_ms
```

Tracks the mutable d prof r ms value used by the d main subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/d_main.ml#L114)

<a id="global-global-d-prof-special-ms-d-prof-special-ms-src-d-main-ml-2066010914"></a>
### _d_prof_special_ms

```ml
_d_prof_special_ms
```

Tracks the mutable d prof special ms value used by the d main subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/d_main.ml#L141)

<a id="global-global-d-prof-st-ms-d-prof-st-ms-src-d-main-ml-979717970"></a>
### _d_prof_st_ms

```ml
_d_prof_st_ms
```

Tracks the mutable d prof st ms value used by the d main subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/d_main.ml#L117)

<a id="global-global-d-prof-t0-d-prof-t0-src-d-main-ml-1799992322"></a>
### _d_prof_t0

```ml
_d_prof_t0
```

Tracks the mutable d prof t0 value used by the d main subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/d_main.ml#L108)

<a id="global-global-d-prof-thinker-ms-d-prof-thinker-ms-src-d-main-ml-1287022942"></a>
### _d_prof_thinker_ms

```ml
_d_prof_thinker_ms
```

Tracks the mutable d prof thinker ms value used by the d main subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/d_main.ml#L138)

<a id="global-global-d-prof-thinkers-d-prof-thinkers-src-d-main-ml-251115978"></a>
### _d_prof_thinkers

```ml
_d_prof_thinkers
```

Tracks the mutable d prof thinkers value used by the d main subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/d_main.ml#L147)

<a id="global-global-d-prof-tick-ms-d-prof-tick-ms-src-d-main-ml-633219270"></a>
### _d_prof_tick_ms

```ml
_d_prof_tick_ms
```

Tracks the mutable d prof tick ms value used by the d main subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/d_main.ml#L132)

<a id="global-global-d-prof-tics-d-prof-tics-src-d-main-ml-1614422152"></a>
### _d_prof_tics

```ml
_d_prof_tics
```

Tracks the mutable d prof tics value used by the d main subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/d_main.ml#L144)

<a id="global-global-d-prof-vid-ms-d-prof-vid-ms-src-d-main-ml-1318001630"></a>
### _d_prof_vid_ms

```ml
_d_prof_vid_ms
```

Tracks the mutable d prof vid ms value used by the d main subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/d_main.ml#L129)

<a id="global-global-d-profile-render-d-profile-render-src-d-main-ml-14689294"></a>
### _d_profile_render

```ml
_d_profile_render
```

Tracks whether d profile render is active in the d main subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/d_main.ml#L105)

<a id="function-function-d-profileadd-function-d-profileadd-slot-delta-src-d-main-ml-353637884"></a>
### _D_ProfileAdd

```ml
function _D_ProfileAdd(slot, delta)
```

Adds one measured duration to its renderer/gameplay profiling bucket when profiling is enabled.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `slot` | `dynamic` | — | Slot value supplied to `_D_ProfileAdd`. |
| `delta` | `dynamic` | — | Delta value supplied to `_D_ProfileAdd`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/d_main.ml#L264)

<a id="function-function-d-profileflushmaybe-function-d-profileflushmaybe-src-d-main-ml-1606119908"></a>
### _D_ProfileFlushMaybe

```ml
function _D_ProfileFlushMaybe()
```

Flushes one-second profiling aggregates and resets their counters after the interval elapsed.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/d_main.ml#L491)

<a id="function-function-d-profileframesample-function-d-profileframesample-deltaus-src-d-main-ml-1578402304"></a>
### _D_ProfileFrameSample

```ml
function _D_ProfileFrameSample(deltaUs)
```

Adds one complete frame duration to a compact millisecond histogram.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `deltaUs` | `dynamic` | — | Delta us value supplied to `_D_ProfileFrameSample`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/d_main.ml#L388)

<a id="function-function-d-profilegametick-function-d-profilegametick-src-d-main-ml-1027590416"></a>
### _D_ProfileGameTick

```ml
function _D_ProfileGameTick()
```

Counts one executed game tic for runtime profiling.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/d_main.ml#L302)

<a id="function-function-d-profilegladd-function-d-profilegladd-slot-delta-src-d-main-ml-976401050"></a>
### _D_ProfileGLAdd

```ml
function _D_ProfileGLAdd(slot, delta)
```

Accumulates fine-grained OpenGL renderer timings for the profile log.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `slot` | `dynamic` | — | Slot value supplied to `_D_ProfileGLAdd`. |
| `delta` | `dynamic` | — | Delta value supplied to `_D_ProfileGLAdd`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/d_main.ml#L333)

<a id="function-function-d-profileglbatches-function-d-profileglbatches-kind-total-drawn-vertices-src-d-main-ml-1901416829"></a>
### _D_ProfileGLBatches

```ml
function _D_ProfileGLBatches(kind, total, drawn, vertices)
```

Accumulates OpenGL batch visibility counts for renderer profiling.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `kind` | `dynamic` | — | Kind value supplied to `_D_ProfileGLBatches`. |
| `total` | `dynamic` | — | Total value supplied to `_D_ProfileGLBatches`. |
| `drawn` | `dynamic` | — | Drawn value supplied to `_D_ProfileGLBatches`. |
| `vertices` | `dynamic` | — | Vertices value supplied to `_D_ProfileGLBatches`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/d_main.ml#L434)

<a id="function-function-d-profilelog-function-d-profilelog-line-src-d-main-ml-986565372"></a>
### _D_ProfileLog

```ml
function _D_ProfileLog(line)
```

Writes profiler output to stdout and to a log file for windows-subsystem builds.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `line` | `dynamic` | — | Map line or text line affected by the operation. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/d_main.ml#L321)

<a id="function-function-d-profilems-inline-function-d-profilems-us-src-d-main-ml-1942349021"></a>
### _D_ProfileMs

```ml
inline function _D_ProfileMs(us)
```

Converts accumulated microseconds to whole milliseconds for compact profile output.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `us` | `dynamic` | — | Us value supplied to `_D_ProfileMs`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/d_main.ml#L424)

<a id="function-function-d-profilepercentilems-function-d-profilepercentilems-percent-src-d-main-ml-699214121"></a>
### _D_ProfilePercentileMs

```ml
function _D_ProfilePercentileMs(percent)
```

Reads a percentile from the current frame histogram.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `percent` | `dynamic` | — | Percent value supplied to `_D_ProfilePercentileMs`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/d_main.ml#L407)

<a id="function-function-d-profilethinker-function-d-profilethinker-ismobj-src-d-main-ml-1505897448"></a>
### _D_ProfileThinker

```ml
function _D_ProfileThinker(isMobj)
```

Counts thinker execution and separates mobj thinkers for gameplay profiling.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `isMobj` | `dynamic` | — | Whether is mobj holds. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/d_main.ml#L310)

<a id="function-function-d-profiletimeus-inline-function-d-profiletimeus-src-d-main-ml-1601460839"></a>
### _D_ProfileTimeUs

```ml
inline function _D_ProfileTimeUs()
```

Reads a high-resolution monotonic timestamp without changing game timing.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/d_main.ml#L377)

<a id="function-function-d-readhdwadimagenames-function-d-readhdwadimagenames-path-src-d-main-ml-1763619289"></a>
### _D_ReadHDWADImageNames

```ml
function _D_ReadHDWADImageNames(path)
```

Reads HDWAD image names from the high-resolution image directory.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `path` | `dynamic` | — | Filesystem path to process. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/d_main.ml#L1070)

<a id="function-function-d-readhdwadlumpnames-function-d-readhdwadlumpnames-path-src-d-main-ml-1487528589"></a>
### _D_ReadHDWADLumpNames

```ml
function _D_ReadHDWADLumpNames(path)
```

Validates an HDWAD v6 directory and extracts its eight-byte lump-name table.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `path` | `dynamic` | — | Filesystem path to process. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/d_main.ml#L1041)

<a id="function-function-d-statusbarvisible-inline-function-d-statusbarvisible-src-d-main-ml-2048695845"></a>
### _D_StatusBarVisible

```ml
inline function _D_StatusBarVisible()
```

Determines classic status-bar visibility without comparing a scaled HD view height to logical screen dimensions.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/d_main.ml#L1932)

<a id="function-function-d-strcontains-function-d-strcontains-haystack-needle-src-d-main-ml-1084280811"></a>
### _D_StrContains

```ml
function _D_StrContains(haystack, needle)
```

Performs a bytewise substring search used while classifying command-line paths.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `haystack` | `dynamic` | — | Haystack value supplied to `_D_StrContains`. |
| `needle` | `dynamic` | — | Needle value supplied to `_D_StrContains`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/d_main.ml#L1543)

<a id="function-function-d-timems-inline-function-d-timems-src-d-main-ml-2126858933"></a>
### _D_TimeMs

```ml
inline function _D_TimeMs()
```

Returns the monotonic runtime clock used by loading and profiling telemetry.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/d_main.ml#L254)

<a id="function-function-d-tolowerascii-function-d-tolowerascii-s-src-d-main-ml-1193596467"></a>
### _D_ToLowerAscii

```ml
function _D_ToLowerAscii(s)
```

Converts lower ASCII values for the Doom core.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `s` | `dynamic` | — | S value supplied to `_D_ToLowerAscii`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/d_main.ml#L1528)

<a id="global-global-advancedemo-advancedemo-src-d-main-ml-1722058690"></a>
### advancedemo

```ml
advancedemo
```

Tracks whether advancedemo is active in the d main subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/d_main.ml#L95)

<a id="function-function-d-addfile-function-d-addfile-file-src-d-main-ml-833552250"></a>
### D_AddFile

```ml
function D_AddFile(file)
```

Adds file entries to the Doom core.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `file` | `dynamic` | — | File value supplied to `D_AddFile`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/d_main.ml#L64)

<a id="function-function-d-advancedemo-function-d-advancedemo-src-d-main-ml-1734225940"></a>
### D_AdvanceDemo

```ml
function D_AdvanceDemo()
```

Defers a title/demo sequence advance until the main loop reaches a safe game-action boundary.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/d_main.ml#L696)

<a id="function-function-d-display-function-d-display-src-d-main-ml-1002071674"></a>
### D_Display

```ml
function D_Display()
```

Composes one frame, including wipes, view/HUD layers, palette updates, and profiling.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/d_main.ml#L1944)

<a id="function-function-d-doadvancedemo-function-d-doadvancedemo-src-d-main-ml-34373146"></a>
### D_DoAdvanceDemo

```ml
function D_DoAdvanceDemo()
```

Rotates through title pages and built-in demos, selecting mission-specific page durations and music.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/d_main.ml#L703)

<a id="function-function-d-doomloop-function-d-doomloop-src-d-main-ml-1406743232"></a>
### D_DoomLoop

```ml
function D_DoomLoop()
```

Runs the permanent event/tic/render loop with capped or interpolated presentation scheduling.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/d_main.ml#L2288)

<a id="function-function-d-doommain-function-d-doommain-src-d-main-ml-1126039512"></a>
### D_DoomMain

```ml
function D_DoomMain()
```

Runs the main Doom core entry point.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/d_main.ml#L1722)

<a id="global-global-d-force-wipe-d-force-wipe-src-d-main-ml-1787221862"></a>
### d_force_wipe

```ml
d_force_wipe
```

Tracks whether d force wipe is active in the d main subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/d_main.ml#L217)

<a id="function-function-d-forcewipe-function-d-forcewipe-src-d-main-ml-2139527162"></a>
### D_ForceWipe

```ml
function D_ForceWipe()
```

Forces the next display pass to run a full screen-wipe transition.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/d_main.ml#L247)

<a id="function-function-d-hdwadprogressstep-function-d-hdwadprogressstep-units-src-d-main-ml-1797080475"></a>
### D_HDWADProgressStep

```ml
function D_HDWADProgressStep(units)
```

Advances the visible HDWAD generation progress from builder callbacks.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `units` | `dynamic` | — | Units value supplied to `D_HDWADProgressStep`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/d_main.ml#L1344)

<a id="function-function-d-pagedrawer-function-d-pagedrawer-src-d-main-ml-1919885984"></a>
### D_PageDrawer

```ml
function D_PageDrawer()
```

Draws the current title/demo page or clears the framebuffer when its lump is unavailable.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/d_main.ml#L674)

<a id="function-function-d-pageticker-function-d-pageticker-src-d-main-ml-749541744"></a>
### D_PageTicker

```ml
function D_PageTicker()
```

Counts down the current title/help page and queues the next demo-sequence entry on expiry.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/d_main.ml#L662)

<a id="function-function-d-postevent-function-d-postevent-ev-src-d-main-ml-1245685575"></a>
### D_PostEvent

```ml
function D_PostEvent(ev)
```

Enqueues one input event in the bounded power-of-two responder ring.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `ev` | `dynamic` | — | Input event to process. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/d_main.ml#L611)

<a id="function-function-d-processevents-function-d-processevents-src-d-main-ml-895840882"></a>
### D_ProcessEvents

```ml
function D_ProcessEvents()
```

Dispatches queued input through menu then gameplay responders in deterministic order.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/d_main.ml#L622)

<a id="constant-constant-d-profile-log-path-const-d-profile-log-path-minidoom-profile-log-src-d-main-ml-1248329195"></a>
### D_PROFILE_LOG_PATH

```ml
const D_PROFILE_LOG_PATH = "minidoom_profile.log"
```

Defines the d profile log path text used by the d main subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/d_main.ml#L215)

<a id="function-function-d-starttitle-function-d-starttitle-src-d-main-ml-766789840"></a>
### D_StartTitle

```ml
function D_StartTitle()
```

Resets game actions to the title demo screen and restarts the attract-mode sequence.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/d_main.ml#L795)

<a id="global-global-demosequence-demosequence-src-d-main-ml-1481170334"></a>
### demosequence

```ml
demosequence
```

Tracks the mutable demosequence value used by the d main subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/d_main.ml#L97)

<a id="global-global-eventhead-eventhead-src-d-main-ml-1726435526"></a>
### eventhead

```ml
eventhead
```

Tracks the mutable eventhead value used by the d main subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/d_main.ml#L90)

<a id="global-global-events-events-src-d-main-ml-1119519196"></a>
### events

```ml
events
```

Holds the optional events resource used by the d main subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/d_main.ml#L88)

<a id="global-global-eventtail-eventtail-src-d-main-ml-1135233878"></a>
### eventtail

```ml
eventtail
```

Tracks the mutable eventtail value used by the d main subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/d_main.ml#L92)

<a id="function-function-findresponsefile-function-findresponsefile-src-d-main-ml-32238248"></a>
### FindResponseFile

```ml
function FindResponseFile()
```

Computes response file values for the Doom core.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/d_main.ml#L1652)

<a id="function-function-identifyversion-function-identifyversion-src-d-main-ml-887866944"></a>
### IdentifyVersion

```ml
function IdentifyVersion()
```

Selects the IWAD, game mode, language, and mission family before resource initialization.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/d_main.ml#L1602)

<a id="constant-constant-maxwadfiles-const-maxwadfiles-20-src-d-main-ml-276364321"></a>
### MAXWADFILES

```ml
const MAXWADFILES = 20
```

Defines the maximum maxwadfiles accepted by the d main subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/d_main.ml#L58)

<a id="global-global-pagename-pagename-src-d-main-ml-1591614642"></a>
### pagename

```ml
pagename
```

Stores the mutable pagename text used by the d main subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/d_main.ml#L101)

<a id="global-global-pagetic-pagetic-src-d-main-ml-1244815542"></a>
### pagetic

```ml
pagetic
```

Tracks the mutable pagetic value used by the d main subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/d_main.ml#L99)

<a id="global-global-wadfiles-wadfiles-src-d-main-ml-1790732452"></a>
### wadfiles

```ml
wadfiles
```

Stores the wadfiles collection used by the d main subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/d_main.ml#L60)
