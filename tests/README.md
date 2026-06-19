# MiniDoom Test Framework

MiniDoom's regression tests are Windows PowerShell end-to-end tests. They build the native MiniLang executable, start it with real IWAD files, capture the game window, and validate renderer behavior from the outside.

## Run All Tests

```powershell
.\tests\run_tests.ps1
```

The runner auto-detects the local MiniLang compiler at:

```text
C:\Users\<you>\Desktop\MiniLangCompilerPy\mlc_win64.py
```

It also auto-detects `Doom2.wad`, `DOOM2.WAD`, `Doom1.wad`, `DOOM1.WAD`, or `DOOM.WAD` in the repo root or `build/`.

## Useful Options

```powershell
.\tests\run_tests.ps1 -SkipBuild
.\tests\run_tests.ps1 -Test smoke
.\tests\run_tests.ps1 -Test renderer_toggle
.\tests\run_tests.ps1 -Iwad "C:\Games\DOOM2.WAD"
.\tests\run_tests.ps1 -Compiler "C:\MiniLangCompilerPy\mlc_win64.py" -Std "C:\MiniLangCompilerPy\std"
```

Equivalent environment variables:

```powershell
$env:MINIDOOM_IWAD = "C:\Games\DOOM2.WAD"
$env:MINIDOOM_COMPILER = "C:\MiniLangCompilerPy\mlc_win64.py"
$env:MINIDOOM_STD = "C:\MiniLangCompilerPy\std"
$env:MINIDOOM_PYTHON = "C:\Python311\python.exe"
```

## Current Test Cases

- `smoke`: starts classic and OpenGL modes, captures screenshots, and rejects blank/fatal-error frames.
- `renderer_toggle`: starts OpenGL, toggles `Alt+G` to classic and back through targeted Win32 messages, verifies the images are drawn and visibly changed.
- `hdwad`: validates the `.hdwad` header and verifies OpenGL can start with the HDWAD path.

Artifacts are written to `test-results/`.
