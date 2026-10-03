# MiniDoom 2.0.5 (Windows x64)

This release rebuilds MiniDoom with MiniLang Compiler 1.2.16. It renames a
local BSP sight-tracing variable because `div` became a compiler keyword. The
change does not alter the sight-tracing logic.

The Windows EXE and native OpenGL DLL were rebuilt from this source. The EXE
includes the application icon. An OpenGL E1M1 startup and FPS smoke test passed
with the DOOM shareware IWAD.

The archive contains the engine, license, and documentation. Supply your own
DOOM or DOOM II IWAD. The Linux x64 package remains available from v2.0.4.
