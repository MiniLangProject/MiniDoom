# MiniDoom
<img src="./icons/MiniDoom.png" width="125" align="left"/>

MiniDoom is a full MiniLang port of the original DOOM engine codebase, focused on gameplay parity, classic behavior, and native Windows/Linux x64 execution.

This project keeps the original DOOM architecture and module split concept, but translates the implementation to MiniLang (`.ml`) with platform-specific runtime bindings where needed (video, audio, input, window handling).
<br clear="right" />

## Level Gallery

All 59 levels available in the locally tested registered **DOOM** IWAD (27) and **DOOM II** (32) are captured from the same player start in both renderers. Classic is shown on the left, OpenGL on the right. The IWAD files are not part of this repository.

<p align="center">
  <img src="./docs/gallery/doom2/map01-classic.png" width="49%" alt="DOOM II MAP01 with the Classic renderer">
  <img src="./docs/gallery/doom2/map01-opengl.png" width="49%" alt="DOOM II MAP01 with the OpenGL renderer">
</p>
<p align="center"><sub>DOOM II MAP01 — Classic (left) and OpenGL (right)</sub></p>

<details>
<summary><strong>DOOM — Episode 1 (E1M1–E1M9)</strong></summary>

<table>
<tr><th>Level</th><th>Classic</th><th>OpenGL</th></tr>
<tr><td><strong>E1M1</strong></td><td><img src="./docs/gallery/doom1/e1m1-classic.png" width="320" alt="E1M1 Classic renderer"></td><td><img src="./docs/gallery/doom1/e1m1-opengl.png" width="320" alt="E1M1 OpenGL renderer"></td></tr>
<tr><td><strong>E1M2</strong></td><td><img src="./docs/gallery/doom1/e1m2-classic.png" width="320" alt="E1M2 Classic renderer"></td><td><img src="./docs/gallery/doom1/e1m2-opengl.png" width="320" alt="E1M2 OpenGL renderer"></td></tr>
<tr><td><strong>E1M3</strong></td><td><img src="./docs/gallery/doom1/e1m3-classic.png" width="320" alt="E1M3 Classic renderer"></td><td><img src="./docs/gallery/doom1/e1m3-opengl.png" width="320" alt="E1M3 OpenGL renderer"></td></tr>
<tr><td><strong>E1M4</strong></td><td><img src="./docs/gallery/doom1/e1m4-classic.png" width="320" alt="E1M4 Classic renderer"></td><td><img src="./docs/gallery/doom1/e1m4-opengl.png" width="320" alt="E1M4 OpenGL renderer"></td></tr>
<tr><td><strong>E1M5</strong></td><td><img src="./docs/gallery/doom1/e1m5-classic.png" width="320" alt="E1M5 Classic renderer"></td><td><img src="./docs/gallery/doom1/e1m5-opengl.png" width="320" alt="E1M5 OpenGL renderer"></td></tr>
<tr><td><strong>E1M6</strong></td><td><img src="./docs/gallery/doom1/e1m6-classic.png" width="320" alt="E1M6 Classic renderer"></td><td><img src="./docs/gallery/doom1/e1m6-opengl.png" width="320" alt="E1M6 OpenGL renderer"></td></tr>
<tr><td><strong>E1M7</strong></td><td><img src="./docs/gallery/doom1/e1m7-classic.png" width="320" alt="E1M7 Classic renderer"></td><td><img src="./docs/gallery/doom1/e1m7-opengl.png" width="320" alt="E1M7 OpenGL renderer"></td></tr>
<tr><td><strong>E1M8</strong></td><td><img src="./docs/gallery/doom1/e1m8-classic.png" width="320" alt="E1M8 Classic renderer"></td><td><img src="./docs/gallery/doom1/e1m8-opengl.png" width="320" alt="E1M8 OpenGL renderer"></td></tr>
<tr><td><strong>E1M9</strong></td><td><img src="./docs/gallery/doom1/e1m9-classic.png" width="320" alt="E1M9 Classic renderer"></td><td><img src="./docs/gallery/doom1/e1m9-opengl.png" width="320" alt="E1M9 OpenGL renderer"></td></tr>
</table>

</details>

<details>
<summary><strong>DOOM — Episode 2 (E2M1–E2M9)</strong></summary>

<table>
<tr><th>Level</th><th>Classic</th><th>OpenGL</th></tr>
<tr><td><strong>E2M1</strong></td><td><img src="./docs/gallery/doom1/e2m1-classic.png" width="320" alt="E2M1 Classic renderer"></td><td><img src="./docs/gallery/doom1/e2m1-opengl.png" width="320" alt="E2M1 OpenGL renderer"></td></tr>
<tr><td><strong>E2M2</strong></td><td><img src="./docs/gallery/doom1/e2m2-classic.png" width="320" alt="E2M2 Classic renderer"></td><td><img src="./docs/gallery/doom1/e2m2-opengl.png" width="320" alt="E2M2 OpenGL renderer"></td></tr>
<tr><td><strong>E2M3</strong></td><td><img src="./docs/gallery/doom1/e2m3-classic.png" width="320" alt="E2M3 Classic renderer"></td><td><img src="./docs/gallery/doom1/e2m3-opengl.png" width="320" alt="E2M3 OpenGL renderer"></td></tr>
<tr><td><strong>E2M4</strong></td><td><img src="./docs/gallery/doom1/e2m4-classic.png" width="320" alt="E2M4 Classic renderer"></td><td><img src="./docs/gallery/doom1/e2m4-opengl.png" width="320" alt="E2M4 OpenGL renderer"></td></tr>
<tr><td><strong>E2M5</strong></td><td><img src="./docs/gallery/doom1/e2m5-classic.png" width="320" alt="E2M5 Classic renderer"></td><td><img src="./docs/gallery/doom1/e2m5-opengl.png" width="320" alt="E2M5 OpenGL renderer"></td></tr>
<tr><td><strong>E2M6</strong></td><td><img src="./docs/gallery/doom1/e2m6-classic.png" width="320" alt="E2M6 Classic renderer"></td><td><img src="./docs/gallery/doom1/e2m6-opengl.png" width="320" alt="E2M6 OpenGL renderer"></td></tr>
<tr><td><strong>E2M7</strong></td><td><img src="./docs/gallery/doom1/e2m7-classic.png" width="320" alt="E2M7 Classic renderer"></td><td><img src="./docs/gallery/doom1/e2m7-opengl.png" width="320" alt="E2M7 OpenGL renderer"></td></tr>
<tr><td><strong>E2M8</strong></td><td><img src="./docs/gallery/doom1/e2m8-classic.png" width="320" alt="E2M8 Classic renderer"></td><td><img src="./docs/gallery/doom1/e2m8-opengl.png" width="320" alt="E2M8 OpenGL renderer"></td></tr>
<tr><td><strong>E2M9</strong></td><td><img src="./docs/gallery/doom1/e2m9-classic.png" width="320" alt="E2M9 Classic renderer"></td><td><img src="./docs/gallery/doom1/e2m9-opengl.png" width="320" alt="E2M9 OpenGL renderer"></td></tr>
</table>

</details>

<details>
<summary><strong>DOOM — Episode 3 (E3M1–E3M9)</strong></summary>

<table>
<tr><th>Level</th><th>Classic</th><th>OpenGL</th></tr>
<tr><td><strong>E3M1</strong></td><td><img src="./docs/gallery/doom1/e3m1-classic.png" width="320" alt="E3M1 Classic renderer"></td><td><img src="./docs/gallery/doom1/e3m1-opengl.png" width="320" alt="E3M1 OpenGL renderer"></td></tr>
<tr><td><strong>E3M2</strong></td><td><img src="./docs/gallery/doom1/e3m2-classic.png" width="320" alt="E3M2 Classic renderer"></td><td><img src="./docs/gallery/doom1/e3m2-opengl.png" width="320" alt="E3M2 OpenGL renderer"></td></tr>
<tr><td><strong>E3M3</strong></td><td><img src="./docs/gallery/doom1/e3m3-classic.png" width="320" alt="E3M3 Classic renderer"></td><td><img src="./docs/gallery/doom1/e3m3-opengl.png" width="320" alt="E3M3 OpenGL renderer"></td></tr>
<tr><td><strong>E3M4</strong></td><td><img src="./docs/gallery/doom1/e3m4-classic.png" width="320" alt="E3M4 Classic renderer"></td><td><img src="./docs/gallery/doom1/e3m4-opengl.png" width="320" alt="E3M4 OpenGL renderer"></td></tr>
<tr><td><strong>E3M5</strong></td><td><img src="./docs/gallery/doom1/e3m5-classic.png" width="320" alt="E3M5 Classic renderer"></td><td><img src="./docs/gallery/doom1/e3m5-opengl.png" width="320" alt="E3M5 OpenGL renderer"></td></tr>
<tr><td><strong>E3M6</strong></td><td><img src="./docs/gallery/doom1/e3m6-classic.png" width="320" alt="E3M6 Classic renderer"></td><td><img src="./docs/gallery/doom1/e3m6-opengl.png" width="320" alt="E3M6 OpenGL renderer"></td></tr>
<tr><td><strong>E3M7</strong></td><td><img src="./docs/gallery/doom1/e3m7-classic.png" width="320" alt="E3M7 Classic renderer"></td><td><img src="./docs/gallery/doom1/e3m7-opengl.png" width="320" alt="E3M7 OpenGL renderer"></td></tr>
<tr><td><strong>E3M8</strong></td><td><img src="./docs/gallery/doom1/e3m8-classic.png" width="320" alt="E3M8 Classic renderer"></td><td><img src="./docs/gallery/doom1/e3m8-opengl.png" width="320" alt="E3M8 OpenGL renderer"></td></tr>
<tr><td><strong>E3M9</strong></td><td><img src="./docs/gallery/doom1/e3m9-classic.png" width="320" alt="E3M9 Classic renderer"></td><td><img src="./docs/gallery/doom1/e3m9-opengl.png" width="320" alt="E3M9 OpenGL renderer"></td></tr>
</table>

</details>

<details>
<summary><strong>DOOM II — MAP01–MAP11</strong></summary>

<table>
<tr><th>Level</th><th>Classic</th><th>OpenGL</th></tr>
<tr><td><strong>MAP01</strong></td><td><img src="./docs/gallery/doom2/map01-classic.png" width="320" alt="MAP01 Classic renderer"></td><td><img src="./docs/gallery/doom2/map01-opengl.png" width="320" alt="MAP01 OpenGL renderer"></td></tr>
<tr><td><strong>MAP02</strong></td><td><img src="./docs/gallery/doom2/map02-classic.png" width="320" alt="MAP02 Classic renderer"></td><td><img src="./docs/gallery/doom2/map02-opengl.png" width="320" alt="MAP02 OpenGL renderer"></td></tr>
<tr><td><strong>MAP03</strong></td><td><img src="./docs/gallery/doom2/map03-classic.png" width="320" alt="MAP03 Classic renderer"></td><td><img src="./docs/gallery/doom2/map03-opengl.png" width="320" alt="MAP03 OpenGL renderer"></td></tr>
<tr><td><strong>MAP04</strong></td><td><img src="./docs/gallery/doom2/map04-classic.png" width="320" alt="MAP04 Classic renderer"></td><td><img src="./docs/gallery/doom2/map04-opengl.png" width="320" alt="MAP04 OpenGL renderer"></td></tr>
<tr><td><strong>MAP05</strong></td><td><img src="./docs/gallery/doom2/map05-classic.png" width="320" alt="MAP05 Classic renderer"></td><td><img src="./docs/gallery/doom2/map05-opengl.png" width="320" alt="MAP05 OpenGL renderer"></td></tr>
<tr><td><strong>MAP06</strong></td><td><img src="./docs/gallery/doom2/map06-classic.png" width="320" alt="MAP06 Classic renderer"></td><td><img src="./docs/gallery/doom2/map06-opengl.png" width="320" alt="MAP06 OpenGL renderer"></td></tr>
<tr><td><strong>MAP07</strong></td><td><img src="./docs/gallery/doom2/map07-classic.png" width="320" alt="MAP07 Classic renderer"></td><td><img src="./docs/gallery/doom2/map07-opengl.png" width="320" alt="MAP07 OpenGL renderer"></td></tr>
<tr><td><strong>MAP08</strong></td><td><img src="./docs/gallery/doom2/map08-classic.png" width="320" alt="MAP08 Classic renderer"></td><td><img src="./docs/gallery/doom2/map08-opengl.png" width="320" alt="MAP08 OpenGL renderer"></td></tr>
<tr><td><strong>MAP09</strong></td><td><img src="./docs/gallery/doom2/map09-classic.png" width="320" alt="MAP09 Classic renderer"></td><td><img src="./docs/gallery/doom2/map09-opengl.png" width="320" alt="MAP09 OpenGL renderer"></td></tr>
<tr><td><strong>MAP10</strong></td><td><img src="./docs/gallery/doom2/map10-classic.png" width="320" alt="MAP10 Classic renderer"></td><td><img src="./docs/gallery/doom2/map10-opengl.png" width="320" alt="MAP10 OpenGL renderer"></td></tr>
<tr><td><strong>MAP11</strong></td><td><img src="./docs/gallery/doom2/map11-classic.png" width="320" alt="MAP11 Classic renderer"></td><td><img src="./docs/gallery/doom2/map11-opengl.png" width="320" alt="MAP11 OpenGL renderer"></td></tr>
</table>

</details>

<details>
<summary><strong>DOOM II — MAP12–MAP20</strong></summary>

<table>
<tr><th>Level</th><th>Classic</th><th>OpenGL</th></tr>
<tr><td><strong>MAP12</strong></td><td><img src="./docs/gallery/doom2/map12-classic.png" width="320" alt="MAP12 Classic renderer"></td><td><img src="./docs/gallery/doom2/map12-opengl.png" width="320" alt="MAP12 OpenGL renderer"></td></tr>
<tr><td><strong>MAP13</strong></td><td><img src="./docs/gallery/doom2/map13-classic.png" width="320" alt="MAP13 Classic renderer"></td><td><img src="./docs/gallery/doom2/map13-opengl.png" width="320" alt="MAP13 OpenGL renderer"></td></tr>
<tr><td><strong>MAP14</strong></td><td><img src="./docs/gallery/doom2/map14-classic.png" width="320" alt="MAP14 Classic renderer"></td><td><img src="./docs/gallery/doom2/map14-opengl.png" width="320" alt="MAP14 OpenGL renderer"></td></tr>
<tr><td><strong>MAP15</strong></td><td><img src="./docs/gallery/doom2/map15-classic.png" width="320" alt="MAP15 Classic renderer"></td><td><img src="./docs/gallery/doom2/map15-opengl.png" width="320" alt="MAP15 OpenGL renderer"></td></tr>
<tr><td><strong>MAP16</strong></td><td><img src="./docs/gallery/doom2/map16-classic.png" width="320" alt="MAP16 Classic renderer"></td><td><img src="./docs/gallery/doom2/map16-opengl.png" width="320" alt="MAP16 OpenGL renderer"></td></tr>
<tr><td><strong>MAP17</strong></td><td><img src="./docs/gallery/doom2/map17-classic.png" width="320" alt="MAP17 Classic renderer"></td><td><img src="./docs/gallery/doom2/map17-opengl.png" width="320" alt="MAP17 OpenGL renderer"></td></tr>
<tr><td><strong>MAP18</strong></td><td><img src="./docs/gallery/doom2/map18-classic.png" width="320" alt="MAP18 Classic renderer"></td><td><img src="./docs/gallery/doom2/map18-opengl.png" width="320" alt="MAP18 OpenGL renderer"></td></tr>
<tr><td><strong>MAP19</strong></td><td><img src="./docs/gallery/doom2/map19-classic.png" width="320" alt="MAP19 Classic renderer"></td><td><img src="./docs/gallery/doom2/map19-opengl.png" width="320" alt="MAP19 OpenGL renderer"></td></tr>
<tr><td><strong>MAP20</strong></td><td><img src="./docs/gallery/doom2/map20-classic.png" width="320" alt="MAP20 Classic renderer"></td><td><img src="./docs/gallery/doom2/map20-opengl.png" width="320" alt="MAP20 OpenGL renderer"></td></tr>
</table>

</details>

<details>
<summary><strong>DOOM II — MAP21–MAP32</strong></summary>

<table>
<tr><th>Level</th><th>Classic</th><th>OpenGL</th></tr>
<tr><td><strong>MAP21</strong></td><td><img src="./docs/gallery/doom2/map21-classic.png" width="320" alt="MAP21 Classic renderer"></td><td><img src="./docs/gallery/doom2/map21-opengl.png" width="320" alt="MAP21 OpenGL renderer"></td></tr>
<tr><td><strong>MAP22</strong></td><td><img src="./docs/gallery/doom2/map22-classic.png" width="320" alt="MAP22 Classic renderer"></td><td><img src="./docs/gallery/doom2/map22-opengl.png" width="320" alt="MAP22 OpenGL renderer"></td></tr>
<tr><td><strong>MAP23</strong></td><td><img src="./docs/gallery/doom2/map23-classic.png" width="320" alt="MAP23 Classic renderer"></td><td><img src="./docs/gallery/doom2/map23-opengl.png" width="320" alt="MAP23 OpenGL renderer"></td></tr>
<tr><td><strong>MAP24</strong></td><td><img src="./docs/gallery/doom2/map24-classic.png" width="320" alt="MAP24 Classic renderer"></td><td><img src="./docs/gallery/doom2/map24-opengl.png" width="320" alt="MAP24 OpenGL renderer"></td></tr>
<tr><td><strong>MAP25</strong></td><td><img src="./docs/gallery/doom2/map25-classic.png" width="320" alt="MAP25 Classic renderer"></td><td><img src="./docs/gallery/doom2/map25-opengl.png" width="320" alt="MAP25 OpenGL renderer"></td></tr>
<tr><td><strong>MAP26</strong></td><td><img src="./docs/gallery/doom2/map26-classic.png" width="320" alt="MAP26 Classic renderer"></td><td><img src="./docs/gallery/doom2/map26-opengl.png" width="320" alt="MAP26 OpenGL renderer"></td></tr>
<tr><td><strong>MAP27</strong></td><td><img src="./docs/gallery/doom2/map27-classic.png" width="320" alt="MAP27 Classic renderer"></td><td><img src="./docs/gallery/doom2/map27-opengl.png" width="320" alt="MAP27 OpenGL renderer"></td></tr>
<tr><td><strong>MAP28</strong></td><td><img src="./docs/gallery/doom2/map28-classic.png" width="320" alt="MAP28 Classic renderer"></td><td><img src="./docs/gallery/doom2/map28-opengl.png" width="320" alt="MAP28 OpenGL renderer"></td></tr>
<tr><td><strong>MAP29</strong></td><td><img src="./docs/gallery/doom2/map29-classic.png" width="320" alt="MAP29 Classic renderer"></td><td><img src="./docs/gallery/doom2/map29-opengl.png" width="320" alt="MAP29 OpenGL renderer"></td></tr>
<tr><td><strong>MAP30</strong></td><td><img src="./docs/gallery/doom2/map30-classic.png" width="320" alt="MAP30 Classic renderer"></td><td><img src="./docs/gallery/doom2/map30-opengl.png" width="320" alt="MAP30 OpenGL renderer"></td></tr>
<tr><td><strong>MAP31</strong></td><td><img src="./docs/gallery/doom2/map31-classic.png" width="320" alt="MAP31 Classic renderer"></td><td><img src="./docs/gallery/doom2/map31-opengl.png" width="320" alt="MAP31 OpenGL renderer"></td></tr>
<tr><td><strong>MAP32</strong></td><td><img src="./docs/gallery/doom2/map32-classic.png" width="320" alt="MAP32 Classic renderer"></td><td><img src="./docs/gallery/doom2/map32-opengl.png" width="320" alt="MAP32 OpenGL renderer"></td></tr>
</table>

</details>

Regenerate the gallery from local IWADs with:

```powershell
.\tools\capture_readme_gallery.ps1
```


## Project Goals

- Port original DOOM engine logic to MiniLang as faithfully as possible.
- Preserve classic gameplay behavior (movement, combat, AI, doors/switches/triggers, HUD/menu flow).
- Keep rendering semantics close to the original pipeline (BSP, walls, visplanes, sprites, clipping).
- Run as a native Windows x64 executable or Linux x64 ELF built with the MiniLang compiler.

## How This Port Was Built

- The original C/H codebase was mapped module-by-module to MiniLang.
- In most cases, one gameplay/render/system C module is represented by one MiniLang file.
- Data structures (`struct`, enums, tables, globals) were ported explicitly.
- Platform services use Win32 on Windows and a compact SDL2/OpenGL bridge on Linux.
- The Python build flow selects the correct native helpers and handles Windows EXE icon injection.

## Repository Structure

```text
MiniDoom/
  src/                       # MiniLang game/engine source files
  docs/gallery/              # Classic/OpenGL level comparison screenshots
  icons/                     # PNG + ICO assets for EXE icon resources
  tools/
    capture_readme_gallery.ps1 # Regenerates the README screenshot gallery
    exe_icon_injector.ml     # MiniLang tool: injects .ico into Windows .exe resources
    minidoom_gl_helper.c     # Cross-platform accelerated rendering helper
    minidoom_linux_platform.c # Linux SDL2 window/input/audio bridge
  build.py                   # Windows/Linux native build orchestrator
  LICENSE
  README.md
```

## Prerequisites

- Windows x64 or Linux x64
- Python 3.10+ (recommended: 3.11+)
- MiniLang compiler (Python implementation):  
  [MiniLangCompilerPy](https://github.com/MiniLangProject/MiniLangCompilerPy)
- Compiler version 1.1.0 or newer with `--target linux-x64` support for Linux builds
- Linux builds: GCC, the SDL2 runtime (`libSDL2-2.0.so.0`), and OpenGL (`libGL.so.1`)
- A DOOM IWAD file (for example `DOOM.WAD`, `DOOM1.WAD`, `DOOM2.WAD`) for runtime testing

Note: IWAD files are not shipped with this repository.

## Build MiniDoom (Recommended)

Use `build.py` from this repository root.

### Windows x64

```powershell
python .\build.py `
  --compiler "C:\path\to\MiniLangCompilerPy\mlc_win64.py" `
  --std "C:\path\to\MiniLangCompilerPy\std" `
  --target windows-x64
```

What this does:

1. Builds `MiniDoomGL.dll`
2. Compiles `tools/exe_icon_injector.ml`
3. Compiles `src/i_main.ml` to `build/MiniDoom.exe`
4. Injects `icons/MiniDoom.ico` into the executable

Final output:

```text
build/MiniDoom.exe
build/MiniDoomGL.dll
```

### Linux x64

On Linux, install GCC plus the SDL2 and OpenGL runtime libraries, then run:

```bash
sudo apt install gcc libsdl2-2.0-0 libgl1
```

```bash
python3 ./build.py \
  --compiler /path/to/MiniLangCompilerPy/mlc_win64.py \
  --std /path/to/MiniLangCompilerPy/std \
  --target linux-x64 \
  --clean
```

The same Linux build can be cross-built from Windows when WSL with GCC is
available:

```powershell
python .\build.py `
  --compiler "C:\path\to\MiniLangCompilerPy\mlc_win64.py" `
  --std "C:\path\to\MiniLangCompilerPy\std" `
  --target linux-x64 `
  --clean
```

Linux output is placed in `build/linux/`:

```text
build/linux/MiniDoom
build/linux/run-minidoom
build/linux/libMiniDoomPlatform.so
build/linux/libMiniDoomGL.so
```

Use `run-minidoom`; it sets the local shared-library search path before
starting the ELF. Both the classic and OpenGL renderers, keyboard/mouse input,
SDL2 sound effects, screenshots, saves, and UDP multiplayer use native Linux
services. The Linux bridge currently has no built-in MIDI synthesizer, so MUS
sequencing is silent unless a Linux music provider is added later.

### Useful Build Options

- `--output-dir <path>`: change output directory
- `--target windows-x64|linux-x64`: choose PE or ELF output
- `--skip-icon`: build without icon injection
- `--clean`: remove output directory before build
- `--icon <path.ico>`: use a custom icon file
- `--icon-group <id>` / `--icon-lang <id>`: resource ids for icon injection
- `--skip-gl-helper`: reuse an existing Windows `MiniDoomGL.dll` without rebuilding it (Linux always builds its helpers)

## Build MiniDoom Manually (Without build.py)

Compile directly via MiniLang compiler:

```powershell
python C:\path\to\mlc_win64.py `
  .\src\i_main.ml `
  .\MiniDoom.exe `
  -I .\src `
  -I C:\path\to\MiniLangCompilerPy `
  --target windows-x64 `
  --subsystem windows
```

If you want the EXE icon embedded, build and run the icon injector:

```powershell
python C:\path\to\mlc_win64.py `
  .\tools\exe_icon_injector.ml `
  .\exe_icon_injector.exe `
  -I .\src `
  -I C:\path\to\MiniLangCompilerPy `
  --target windows-x64 `
  --subsystem console

.\exe_icon_injector.exe .\MiniDoom.exe .\icons\MiniDoom.ico
```

## Running MiniDoom

Example run:

```powershell
.\build\MiniDoom.exe -iwad "C:\Games\DOOM\DOOM2.WAD"
```

Linux:

```bash
./build/linux/run-minidoom -iwad "$HOME/games/doom/DOOM2.WAD"
```

If no `-iwad` is provided, the engine uses its internal IWAD search order and loads the first matching file it finds.

### OpenGL Renderer and Frame Pacing

The classic renderer remains the default. Start the accelerated 3D renderer with:

```powershell
.\build\MiniDoom.exe -iwad "C:\Games\DOOM\DOOM2.WAD" -opengl
```

OpenGL uses VSync by default to avoid tearing and uneven presentation. Runtime options:

- `-novsync`: disable VSync (useful for profiling)
- `-vsync`: explicitly enable VSync
- `-maxfps <0..1000>`: apply an additional frame-rate cap; `0` disables that cap
- `-profile-render`: write per-second frame percentiles and renderer-stage timings to `minidoom_profile.log`

If the graphics driver does not expose swap-interval control, MiniDoom falls back to a 60 FPS high-resolution limiter.

### Drop-Down Console and Classic Cheats

Open or close the in-game console with `~`, `Ö`, or `^` (depending on the active keyboard layout; German `AltGr`+`+` is also supported). The console slides over the upper third of the screen, pauses the current single-player game, and captures all movement and fire input while it is open. HUD notices, multiplayer chat, errors, and command results are mirrored into its scrollback.

![MiniDoom drop-down console showing the built-in help](docs/console.png)

Console controls:

- `Enter`: execute the current command.
- `Up` / `Down`: navigate command history.
- `Page Up` / `Page Down`: scroll the log.
- `Escape`: close the console.

Available commands:

| Command | Effect |
| --- | --- |
| `help` | Show console controls and utility commands. |
| `cheats` | List all gameplay cheats. |
| `iddqd` | Toggle god mode. |
| `idkfa` | Give all weapons, full ammo, armor, and all keys. |
| `idfa` | Give all weapons, full ammo, and armor without keys. |
| `idclip` | Toggle wall collision. |
| `idclev <NN>` | Warp to `MAPNN`, or to episode/map `ExMy` for episodic DOOM. |
| `invisible` | Toggle persistent notarget mode; monsters do not react to the player. |
| `freeze` | Freeze monsters, animations, and world specials while leaving player movement active. |
| `kill monsters` | Kill all active monsters in the current level. |
| `name [Player Name]` | Show or change the local player name. Active multiplayer sessions receive the change immediately. |
| `fps` | Toggle the on-screen FPS display. |
| `clear` | Clear console scrollback. |
| `quit` | Exit MiniDoom. |

Gameplay-changing cheats are single-player only to prevent multiplayer desynchronization. The original quick-warp form also works without opening the console: type `idclev12` during normal play for DOOM II `MAP12`, or `idclev23` for DOOM `E2M3`. These typed cheat keys do not block ordinary movement controls.

## Optional Upscaled Graphics

MiniDoom can load an optional sidecar graphics package next to the original WAD:

```text
DOOM2.WAD
DOOM2.WAD.UPSCALED
```

Generate the package with palette-aware xBRZ scaling:

```powershell
.\build\tools\wad_upscale.exe "C:\Games\DOOM\DOOM2.WAD" "C:\Games\DOOM\DOOM2.WAD.UPSCALED" 2
```

Run with a physical presentation scale and the package:

```powershell
.\build\MiniDoom.exe -iwad "C:\Games\DOOM\DOOM2.WAD" -renderscale 2 -upscaled "C:\Games\DOOM\DOOM2.WAD.UPSCALED"
```

If `-upscaled` is omitted, MiniDoom automatically tries `<iwad>.UPSCALED`. Missing upscaled graphics fall back to the original WAD.

The upscaled package stores prepared wall textures, flats, sprites, HUD/menu patches, fonts, and full-screen patch graphics. During normal high-resolution gameplay, MiniDoom consumes those prepared images directly; the xBRZ-style scaler belongs to the offline `wad_upscale` tool rather than the frame loop.

## Multiplayer Mode

MiniDoom includes an in-game UDP multiplayer mode with host-authoritative simulation.

### Current Capabilities

- Up to 4 players total (slots 0..3).
- Modes: `Coop` and `Deathmatch`.
- Host-configurable map, skill, max players, frag limit, and time limit.
- Player names (max 25 characters), including host-authoritative runtime renaming through `name <Player Name>` in the console.
- HUD join/leave/kill messages and chat relay.
- Intermission/state synchronization between peers.

### Start Multiplayer From the Main Menu

1. Open `Multiplayer` from the main menu.
2. Choose one of:
   - `Host Game`
   - `Join Game`
   - `Player Name`

### Host Game

In `Host Game`, configure:

- `Mode` (`COOP` / `DEATHMATCH`)
- `Map`
- `Skill`
- `Max Players`
- `Frag Limit` (`0` = unlimited)
- `Time Limit` (`0` = unlimited)
- `Port` (default: `2342`)

Then select `Start Host`.

### Join Game

In `Join Game`, set:

- `Host` (numeric IPv4 address, for example `127.0.0.1`)
- `Port` (must match host)

Then select `Join`.

### Start Multiplayer From the Command Line

The command-line path uses the same host/join handshake and game bootstrap as the menus. Start a host with:

```powershell
.\build\MiniDoom.exe -iwad "C:\Games\DOOM\DOOM2.WAD" -mp-host 2342 -mp-mode coop -mp-map MAP01 -mp-skill 2 -mp-maxplayers 4 -mp-fraglimit 0 -mp-timelimit 0 -mp-name Host
```

Join it from another process or machine with:

```powershell
.\build\MiniDoom.exe -iwad "C:\Games\DOOM\DOOM2.WAD" -mp-join 127.0.0.1 2342 -mp-name Marine
```

Available options:

- `-mp-host <port>`: host a session on UDP port `1..65535`.
- `-mp-join <numeric-ipv4> <port>`: join a host; DNS hostnames are not currently accepted.
- `-mp-mode <coop|deathmatch>`: select the host game mode.
- `-mp-map <MAP01|E1M1>`: select a map present in the loaded WAD set.
- `-mp-skill <0..4>`: select the host skill from baby through nightmare.
- `-mp-maxplayers <2..4>`: cap total active slots, including the host.
- `-mp-fraglimit <0..999>` and `-mp-timelimit <0..180>`: configure deathmatch limits; zero disables a limit.
- `-mp-name <name>`: set the local sanitized player name (up to 25 characters).
- `-mp-log <path>`: write machine-readable connection, slot, map, and disconnect status lines to a per-process log. Runtime continues on stdout if the file cannot be opened.

### WAD Compatibility Check

On host and client startup for multiplayer, MiniDoom computes a load-order-sensitive fingerprint (`FNV-1a`) over the IWAD and all gameplay PWADs. Optional generated `.hdwad` rendering caches are excluded.
Join is rejected if fingerprints do not match.

Practical recommendation: all players should use the same IWAD/PWAD files in the same load order.

### Chat

- Press `T` in-game to open chat input.
- Send with `Enter`.
- Messages are relayed host-authoritatively and shown as:
  - `<PlayerName>: <message>`
- Use `name <Player Name>` in the drop-down console to rename yourself while connected. The host validates the sender slot and distributes the refreshed name table to every client, including late joiners.

Player names accept ASCII letters, digits, spaces, hyphens, and underscores. Leading/trailing spaces are removed and names are limited to 25 characters.

### Networking Model (High Level)

- Transport: UDP.
- Server-authoritative world state.
- Clients send inputs; host simulates the world and sends snapshots/events.

### Multiplayer Troubleshooting

- `Host did not respond (timeout)`: verify host address/port and firewall/NAT rules.
- `WAD fingerprint mismatch`: ensure all peers use the same IWAD.
- `Server full`: lower active players or increase max players (up to 4).

## Notes vs Original DOOM

- Core engine behavior targets original DOOM parity while using MiniLang runtime semantics.
- Platform services are adapted to native Win32 and Linux SDL2/OpenGL execution.
- Build and tooling are modernized (single Python build script + MiniLang resource tool).

## License

See [LICENSE](./LICENSE).
