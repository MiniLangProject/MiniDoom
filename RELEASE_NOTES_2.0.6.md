# MiniDoom 2.0.6 (Windows x64)

This release rebuilds MiniDoom with MiniLang Compiler 1.2.22 and introduces a
validated packed-release path. The Windows executable is compiled with the
normal garbage collector, receives its application icon, and is then packed
with UPX 5.2.1. The resulting EXE is 3,262,024 bytes instead of 36,672,000
bytes for the equivalent unpacked image, a reduction of about 91 percent.

`build.py` now supports `--pack` plus `--upx <path>` (or `MINILANG_UPX`) and
the Windows-only experimental `--gc-concurrent` option. Concurrent GC is not
enabled in this release: MiniDoom benchmarks showed lower average FPS from its
write-barrier and synchronization overhead, while packing with the normal
collector was effectively performance-neutral in representative controls.

The packed EXE passed UPX integrity validation and an OpenGL Doom II startup/FPS
smoke test. Audio regression coverage passed 755 cases, and the multiplayer
transport, frame-pacing, HDWAD, renderer-toggle, software-raster, sprite, mover,
view-distance, wall-offset and level-wipe checks passed.

The archive contains the engine, native OpenGL helper, license and
documentation. Supply your own DOOM or DOOM II IWAD; copyrighted IWADs are not
included. The Linux x64 package remains available from v2.0.4.
