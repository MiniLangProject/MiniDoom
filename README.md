# MiniDoom

[![License: Apache-2.0](https://img.shields.io/badge/License-Apache--2.0-blue.svg)](LICENSE)
[![Language: MiniLang](https://img.shields.io/badge/written%20in-MiniLang-5b5bd6.svg)](.)

<img src="./icons/MiniDoom.png" width="125" align="left"/>

MiniDoom is a full MiniLang port of the original DOOM engine codebase, focused on gameplay parity, classic behavior, and native Windows/Linux x64 execution.

This project keeps the original DOOM architecture and module split concept, but translates the implementation to MiniLang (`.ml`) with platform-specific runtime bindings where needed (video, audio, input, window handling).
<br clear="right" />

## Highlights

- Native x64 builds for **Windows** and **Linux** from the same MiniLang source tree.
- Original software renderer plus an accelerated OpenGL renderer, switchable at runtime with `Alt+G`.
- DOOM and DOOM II IWAD/PWAD support, savegames, demos, menus, HUD, sound effects, and MUS music.
- Built-in drop-down console with classic cheats and developer commands.
- Host-authoritative UDP multiplayer for up to four players in cooperative and deathmatch modes.
- Automatic 3× HDWAD rendering cache for OpenGL textures, sprites, UI graphics, and level geometry.

| Feature | Windows x64 | Linux x64 |
| --- | --- | --- |
| Classic software renderer | Win32/GDI presentation | SDL2/OpenGL presentation |
| Accelerated renderer | OpenGL compatibility profile | SDL2/OpenGL compatibility profile |
| Sound effects | WinMM PCM | SDL2 queued audio |
| MUS music | Windows MIDI mapper | FluidSynth + MuseScore General Lite |
| Input and windowing | Win32 | SDL2 |
| Multiplayer | UDP/WinSock | UDP/POSIX sockets |

## Download and Quick Start

Prebuilt Windows and Linux packages are available on the
[GitHub Releases page](https://github.com/MiniLangProject/MiniDoom/releases/latest).
The packages contain the engine only; copyrighted DOOM IWADs are never included.

Windows:

```powershell
.\MiniDoom.exe -iwad "C:\Games\DOOM\DOOM2.WAD" -windowed -opengl
```

Linux (install `libsdl2-2.0-0` and `libgl1` first):

```bash
./run-minidoom -iwad "$HOME/games/doom/DOOM2.WAD" -windowed -opengl
```

The first OpenGL start creates `<IWAD>.hdwad` next to the selected IWAD. This
one-time build can take a while and requires several hundred megabytes of free
space; later starts reuse the validated cache.

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
  src/                       # MiniLang game/engine source files and platform bindings
  docs/gallery/              # Classic/OpenGL level comparison screenshots
  icons/                     # PNG + ICO assets for EXE icon resources
  tests/                     # Smoke, renderer, console, multiplayer, and regression tests
  tools/
    capture_readme_gallery.ps1 # Regenerates the README screenshot gallery
    check_source_comments.ps1 # Audits declaration documentation
    exe_icon_injector.ml     # MiniLang tool: injects .ico into Windows .exe resources
    minidoom_gl_helper.c     # Cross-platform accelerated rendering helper
    minidoom_linux_platform.c # Linux SDL2 window/input/audio bridge
  build.py                   # Windows/Linux native build orchestrator
  THIRD_PARTY_NOTICES.md     # Notices for bundled Linux audio components
  LICENSE
  README.md
```

## Prerequisites

- Windows x64 or Linux x64
- Python 3.10+ (recommended: 3.11+)
- MiniLang compiler (Python implementation):  
  [MiniLangCompilerPy](https://github.com/MiniLangProject/MiniLangCompilerPy)
- Compiler version 1.1.0 or newer with `windows-x64` and `linux-x64` targets
- Windows builds: MSVC x64 build tools and the Windows 10/11 SDK
- Linux builds: GCC, the SDL2 runtime (`libSDL2-2.0.so.0`), OpenGL (`libGL.so.1`), FluidSynth (`libfluidsynth.so.3`), and a GM SoundFont
- A legally obtained DOOM IWAD such as `DOOM.WAD`, `DOOM1.WAD`, or `DOOM2.WAD`

IWAD, PWAD, generated HDWAD, configuration, and save files are not shipped in
the repository or release archives.

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
sudo apt install gcc libsdl2-2.0-0 libgl1 libfluidsynth3 musescore-general-soundfont-small
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
services. Doom's MUS tracks play through FluidSynth. The prebuilt release
includes FluidSynth and the MIT-licensed MuseScore General Lite SoundFont, so
it needs no MIDI daemon or extra SoundFont installation.

For a source build, install `libfluidsynth.so.3` and place a compatible GM
SoundFont beside the executable as `MiniDoom.sf3`/`MiniDoom.sf2`, or select one
with `MINIDOOM_SOUNDFONT=/path/to/soundfont.sf3`. Release builders can copy a
self-contained runtime into the output directory with:

```bash
python3 ./build.py \
  --compiler /path/to/MiniLangCompilerPy/mlc_win64.py \
  --std /path/to/MiniLangCompilerPy/std \
  --target linux-x64 \
  --linux-music-runtime /path/to/runtime \
  --clean
```

The runtime directory must contain `libfluidsynth.so.3`,
`libinstpatch-1.0.so.2`, and `MiniDoom.sf3`. See
[`THIRD_PARTY_NOTICES.md`](./THIRD_PARTY_NOTICES.md) for licenses and
attribution.

### Useful Build Options

- `--output-dir <path>`: change output directory
- `--target windows-x64|linux-x64`: choose PE or ELF output
- `--skip-icon`: build without icon injection
- `--clean`: remove output directory before build
- `--icon <path.ico>`: use a custom icon file
- `--icon-group <id>` / `--icon-lang <id>`: resource ids for icon injection
- `--skip-gl-helper`: reuse an existing Windows `MiniDoomGL.dll` without rebuilding it (Linux always builds its helpers)
- `--linux-music-runtime <path>`: bundle FluidSynth, libinstpatch, and `MiniDoom.sf3` in a Linux build

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
.\build\MiniDoom.exe -iwad "C:\Games\DOOM\DOOM2.WAD" -windowed -opengl
```

```bash
./build/linux/run-minidoom -iwad "$HOME/games/doom/DOOM2.WAD" -windowed -opengl
```

Press `Alt+G` while running to switch between OpenGL and the classic pixel
renderer. OpenGL uses VSync by default to avoid tearing and uneven presentation.
Runtime options:

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

## Automatic HDWAD Cache

The OpenGL renderer uses a generated sidecar cache next to the selected IWAD:

```text
DOOM2.WAD
DOOM2.WAD.hdwad
```

When `-opengl` is requested and no valid sidecar exists, MiniDoom builds it
automatically. The cache contains palette-aware 3× wall textures, flats,
sprites, HUD/menu graphics, fonts, full-screen patches, and precomputed OpenGL
geometry for every discovered map. A loading screen reports the current phase,
percentage, and estimated remaining time.

Useful options:

- `-rebuildhdwad`: regenerate the automatic cache even when a valid one exists.
- `-hdwad <path>`: load an explicitly selected HDWAD instead of auto-generating one.
- `-nohdwad`: disable automatic cache attachment/generation for diagnostics.

The generated file can be several hundred megabytes. It is renderer-only,
excluded from multiplayer WAD fingerprints, and can be deleted safely; the next
OpenGL start will recreate it. Classic rendering does not require an HDWAD.

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

## Tests and Source Audit

The PowerShell test harness covers software/OpenGL rendering, renderer toggling,
sprites, wall offsets, moving geometry, sky behavior, wipes, console commands,
frame pacing, invisibility, HDWAD generation, and multiplayer transport/loopback.

```powershell
pwsh .\tests\run_tests.ps1 `
  -Compiler "C:\path\to\MiniLangCompilerPy\mlc_win64.py" `
  -Std "C:\path\to\MiniLangCompilerPy\std" `
  -Iwad "C:\Games\DOOM\DOOM2.WAD"

pwsh .\tools\check_source_comments.ps1 -Summary
```

## Notes vs Original DOOM

- Core engine behavior targets original DOOM parity while using MiniLang runtime semantics.
- Platform services are adapted to native Win32 and Linux SDL2/OpenGL execution.
- Build and tooling are modernized (single Python build script + MiniLang resource tool).

## License

See [LICENSE](./LICENSE).
