#!/usr/bin/env python3
"""
MiniDoom build script.

Build flow:
1) Build the target-specific native OpenGL/platform helpers.
2) Compile src/i_main.ml to a Windows PE or Linux ELF image.
3) On Windows, optionally compile the icon tool and inject MiniDoom.ico.
4) On Linux, emit a launcher that provides the local shared-library path.
"""

from __future__ import annotations

import argparse
import shutil
import subprocess
import sys
from pathlib import Path


PROJECT_ROOT = Path(__file__).resolve().parent
DEFAULT_GAME_ENTRY = PROJECT_ROOT / "src" / "i_main.ml"
DEFAULT_ICON_TOOL_SRC = PROJECT_ROOT / "tools" / "exe_icon_injector.ml"
DEFAULT_ICON = PROJECT_ROOT / "icons" / "MiniDoom.ico"
DEFAULT_GL_HELPER_SRC = PROJECT_ROOT / "tools" / "minidoom_gl_helper.c"
DEFAULT_LINUX_PLATFORM_SRC = PROJECT_ROOT / "tools" / "minidoom_linux_platform.c"
LINUX_MUSIC_RUNTIME_FILES = (
    "libfluidsynth.so.3",
    "libinstpatch-1.0.so.2",
    "MiniDoom.sf3",
)


def _resolve_std_import_root(std_path: Path) -> Path:
    """
    Resolve the import root expected by the MiniLang compiler.

    Valid inputs:
    - path that contains a 'std' directory
    - path that is the 'std' directory itself
    """
    p = std_path.resolve()
    if (p / "std").is_dir():
        return p
    if p.name.lower() == "std" and (p / "core.ml").is_file():
        return p.parent
    raise FileNotFoundError(
        f"Could not resolve std import root from '{std_path}'. "
        "Pass either the folder that contains 'std/' or the 'std/' folder itself."
    )


def _compiler_cmd(
    compiler_path: Path,
    python_exe: Path,
    input_file: Path,
    output_file: Path,
    include_dirs: list[Path],
    subsystem: str,
    target: str,
) -> list[str]:
    """Build a MiniLang compiler argv for script or native compiler frontends.

    Include directories retain caller order, and ``subsystem`` selects whether
    the generated executable owns a console or a Windows GUI entry point.
    """
    comp = compiler_path.resolve()
    inp = input_file.resolve()
    out = output_file.resolve()

    if comp.suffix.lower() == ".py":
        cmd = [str(python_exe.resolve()), str(comp), str(inp), str(out)]
    else:
        cmd = [str(comp), str(inp), str(out)]

    for inc in include_dirs:
        cmd += ["-I", str(inc.resolve())]
    cmd += ["--target", target]
    if target == "windows-x64":
        cmd += ["--subsystem", subsystem]
    return cmd


def _run(cmd: list[str], cwd: Path) -> None:
    """Print and execute one build command, propagating a non-zero exit code."""
    print(">", " ".join(cmd))
    subprocess.run(cmd, cwd=str(cwd), check=True)


def _find_first_existing(paths: list[Path]) -> Path | None:
    """Return the first existing candidate without changing caller priority."""
    for path in paths:
        if path.exists():
            return path
    return None


def _latest_child_dir(path: Path) -> Path | None:
    """Select the lexically newest direct child directory, or ``None``."""
    if not path.is_dir():
        return None
    dirs = [p for p in path.iterdir() if p.is_dir()]
    if not dirs:
        return None
    return sorted(dirs, key=lambda p: p.name, reverse=True)[0]


def _find_cl_exe() -> Path | None:
    """Locate an x64 MSVC compiler from PATH or installed Visual Studio trees."""
    found = shutil.which("cl")
    if found:
        return Path(found)
    roots = [
        Path(r"C:\Program Files\Microsoft Visual Studio"),
        Path(r"C:\Program Files (x86)\Microsoft Visual Studio"),
    ]
    candidates: list[Path] = []
    for root in roots:
        if root.is_dir():
            candidates.extend(root.glob(r"*\*\VC\Tools\MSVC\*\bin\Hostx64\x64\cl.exe"))
    if not candidates:
        return None
    return sorted(candidates, key=lambda p: str(p), reverse=True)[0]


def _build_gl_helper(gl_helper_src: Path, out_dll: Path) -> bool:
    """Compile the optional native OpenGL helper against the newest Windows SDK.

    Missing toolchain components are treated as an optional-feature skip;
    compiler or linker failures after discovery still abort the build.
    """
    cl = _find_cl_exe()
    if cl is None:
        print("Skipping MiniDoomGL.dll: cl.exe not found.")
        return False

    msvc_root = cl.parents[3]
    vc_include = msvc_root / "include"
    vc_lib = msvc_root / "lib" / "x64"
    kit_root = Path(r"C:\Program Files (x86)\Windows Kits\10")
    kit_ver_dir = _latest_child_dir(kit_root / "Include")
    kit_lib_ver_dir = _latest_child_dir(kit_root / "Lib")
    if kit_ver_dir is None or kit_lib_ver_dir is None:
        print("Skipping MiniDoomGL.dll: Windows SDK not found.")
        return False

    includes = [
        vc_include,
        kit_ver_dir / "um",
        kit_ver_dir / "shared",
        kit_ver_dir / "ucrt",
    ]
    libpaths = [
        vc_lib,
        kit_lib_ver_dir / "um" / "x64",
        kit_lib_ver_dir / "ucrt" / "x64",
    ]
    if any(not p.exists() for p in includes + libpaths):
        print("Skipping MiniDoomGL.dll: incomplete MSVC/SDK include or lib paths.")
        return False

    out_dll.parent.mkdir(parents=True, exist_ok=True)
    cmd = [
        str(cl),
        "/nologo",
        "/LD",
        "/O2",
        "/EHsc",
        str(gl_helper_src.resolve()),
        "/Fe:" + str(out_dll.resolve()),
    ]
    for inc in includes:
        cmd.append("/I" + str(inc.resolve()))
    cmd.extend(["/link", "/NOLOGO"])
    for lib in libpaths:
        cmd.append("/LIBPATH:" + str(lib.resolve()))
    cmd.extend(["opengl32.lib", "gdi32.lib", "user32.lib"])
    _run(cmd, PROJECT_ROOT)
    return True


def _wsl_path(path: Path) -> str:
    """Translate an absolute Windows path for commands executed inside WSL."""
    result = subprocess.run(
        ["wsl.exe", "wslpath", "-a", str(path.resolve()).replace("\\", "/")],
        check=True,
        capture_output=True,
        text=True,
    )
    translated = result.stdout.strip()
    if not translated:
        raise RuntimeError(f"WSL could not translate path: {path}")
    return translated


def _linux_native_cmd(arguments: list[str | Path]) -> list[str]:
    """Create a native Linux command, using WSL when the build host is Windows."""
    if sys.platform.startswith("linux"):
        return [str(value.resolve()) if isinstance(value, Path) else str(value) for value in arguments]
    if sys.platform == "win32" and shutil.which("wsl.exe"):
        converted = [_wsl_path(value) if isinstance(value, Path) else str(value) for value in arguments]
        return ["wsl.exe", *converted]
    raise RuntimeError(
        "Linux helper builds require GCC on Linux, or WSL with GCC when build.py runs on Windows."
    )


def _build_linux_helpers(platform_src: Path, gl_helper_src: Path, output_dir: Path) -> tuple[Path, Path]:
    """Build SDL2 platform and optimized OpenGL helpers as Linux x64 shared objects."""
    if not platform_src.is_file():
        raise FileNotFoundError(f"Linux platform helper source not found: {platform_src}")
    if not gl_helper_src.is_file():
        raise FileNotFoundError(f"OpenGL helper source not found: {gl_helper_src}")

    platform_so = output_dir / "libMiniDoomPlatform.so"
    gl_so = output_dir / "libMiniDoomGL.so"
    platform_so.parent.mkdir(parents=True, exist_ok=True)
    # A just-terminated WSL process can briefly retain a deleted NTFS working
    # directory after --clean.  Recreate the destination from Linux as well so
    # GCC never observes the stale, removed mount entry.
    if sys.platform == "win32":
        _run(_linux_native_cmd(["mkdir", "-p", output_dir]), PROJECT_ROOT)

    platform_cmd = _linux_native_cmd(
        [
            "gcc",
            "-shared",
            "-fPIC",
            "-O3",
            "-Wall",
            "-Wextra",
            platform_src,
            "-o",
            platform_so,
            "-ldl",
            "-lm",
            "-pthread",
        ]
    )
    gl_cmd = _linux_native_cmd(
        [
            "gcc",
            "-shared",
            "-fPIC",
            "-O3",
            "-Wall",
            "-Wextra",
            gl_helper_src,
            "-o",
            gl_so,
            "-Wl,-l:libGL.so.1",
            "-ldl",
            "-lm",
            "-pthread",
        ]
    )
    _run(platform_cmd, PROJECT_ROOT)
    _run(gl_cmd, PROJECT_ROOT)
    return platform_so, gl_so


def _make_linux_launcher(output_dir: Path, game_binary: Path) -> Path:
    """Write a relocatable launcher that resolves MiniDoom's adjacent .so files."""
    # Keep a distinct name on case-insensitive Windows filesystems; otherwise
    # "minidoom" would overwrite the adjacent "MiniDoom" ELF during a WSL
    # cross-build.
    launcher = output_dir / "run-minidoom"
    launcher.write_text(
        "#!/usr/bin/env sh\n"
        "set -eu\n"
        "MINIDOOM_DIR=$(CDPATH= cd -- \"$(dirname -- \"$0\")\" && pwd)\n"
        "export LD_LIBRARY_PATH=\"$MINIDOOM_DIR${LD_LIBRARY_PATH:+:$LD_LIBRARY_PATH}\"\n"
        "exec \"$MINIDOOM_DIR/MiniDoom\" \"$@\"\n",
        encoding="utf-8",
        newline="\n",
    )
    if sys.platform.startswith("linux"):
        game_binary.chmod(0o755)
        launcher.chmod(0o755)
    else:
        _run(_linux_native_cmd(["chmod", "+x", game_binary, launcher]), PROJECT_ROOT)
    return launcher


def _copy_linux_music_runtime(runtime_dir: Path, output_dir: Path) -> None:
    """Copy the optional relocatable FluidSynth runtime into a Linux build.

    Release builds use this hook to bundle the shared libraries and General
    MIDI SoundFont expected by the SDL audio bridge.  Source builds may omit
    it and use compatible system libraries plus ``MINIDOOM_SOUNDFONT``.
    """
    source_dir = runtime_dir.resolve()
    if not source_dir.is_dir():
        raise FileNotFoundError(f"Linux music runtime directory not found: {source_dir}")

    missing = [name for name in LINUX_MUSIC_RUNTIME_FILES if not (source_dir / name).is_file()]
    if missing:
        raise FileNotFoundError(
            "Linux music runtime is incomplete; missing: " + ", ".join(missing)
        )

    for name in LINUX_MUSIC_RUNTIME_FILES:
        shutil.copy2(source_dir / name, output_dir / name)


def _build_icon_tool(
    compiler_path: Path,
    python_exe: Path,
    std_import_root: Path,
    out_exe: Path,
    icon_tool_src: Path,
) -> None:
    """Compile the console resource injector used by the final icon step."""
    out_exe.parent.mkdir(parents=True, exist_ok=True)
    cmd = _compiler_cmd(
        compiler_path=compiler_path,
        python_exe=python_exe,
        input_file=icon_tool_src,
        output_file=out_exe,
        include_dirs=[PROJECT_ROOT / "src", std_import_root],
        subsystem="console",
        target="windows-x64",
    )
    _run(cmd, PROJECT_ROOT)


def _build_game(
    compiler_path: Path,
    python_exe: Path,
    std_import_root: Path,
    out_exe: Path,
    game_entry: Path,
    target: str,
) -> None:
    """Compile the selected MiniDoom entry module for the requested native target."""
    out_exe.parent.mkdir(parents=True, exist_ok=True)
    cmd = _compiler_cmd(
        compiler_path=compiler_path,
        python_exe=python_exe,
        input_file=game_entry,
        output_file=out_exe,
        include_dirs=[PROJECT_ROOT / "src", std_import_root],
        subsystem="windows",
        target=target,
    )
    _run(cmd, PROJECT_ROOT)


def _inject_icon(
    icon_tool_exe: Path,
    target_exe: Path,
    icon_path: Path,
    group_id: int,
    lang_id: int,
) -> None:
    """Replace the executable's icon group through the compiled resource tool."""
    cmd = [
        str(icon_tool_exe.resolve()),
        str(target_exe.resolve()),
        str(icon_path.resolve()),
        str(group_id),
        str(lang_id),
    ]
    _run(cmd, PROJECT_ROOT)


def main() -> int:
    """Parse build options and orchestrate native helper, game, and icon stages."""
    parser = argparse.ArgumentParser(description="Build MiniDoom for Windows x64 or Linux x64.")
    parser.add_argument(
        "--compiler",
        required=True,
        help="Path to the current MiniLang compiler entrypoint (Python script or compiler executable).",
    )
    parser.add_argument(
        "--std",
        required=True,
        help="Path to std folder OR the parent folder that contains std/.",
    )
    parser.add_argument(
        "--target",
        choices=("windows-x64", "linux-x64"),
        default="windows-x64",
        help="Native output target (default: windows-x64).",
    )
    parser.add_argument(
        "--python",
        default=sys.executable,
        help="Python executable used when --compiler points to a .py file (default: current Python).",
    )
    parser.add_argument(
        "--output-dir",
        default="",
        help="Output directory (default: ./build for Windows, ./build/linux for Linux).",
    )
    parser.add_argument(
        "--entry",
        default=str(DEFAULT_GAME_ENTRY),
        help="MiniDoom entry source file (default: src/i_main.ml).",
    )
    parser.add_argument(
        "--icon-tool-src",
        default=str(DEFAULT_ICON_TOOL_SRC),
        help="Icon injector source file (default: tools/exe_icon_injector.ml).",
    )
    parser.add_argument(
        "--icon",
        default=str(DEFAULT_ICON),
        help="ICO file to inject (default: icons/MiniDoom.ico).",
    )
    parser.add_argument(
        "--icon-group",
        type=int,
        default=1,
        help="RT_GROUP_ICON resource id (default: 1).",
    )
    parser.add_argument(
        "--icon-lang",
        type=int,
        default=1033,
        help="Resource language id (default: 1033).",
    )
    parser.add_argument(
        "--skip-icon",
        action="store_true",
        help="Build MiniDoom.exe without icon injection.",
    )
    parser.add_argument(
        "--skip-gl-helper",
        action="store_true",
        help="Reuse an existing Windows MiniDoomGL.dll instead of rebuilding it.",
    )
    parser.add_argument(
        "--linux-music-runtime",
        default="",
        help=(
            "Optional directory containing libfluidsynth.so.3, "
            "libinstpatch-1.0.so.2, and MiniDoom.sf3 to bundle in a Linux build."
        ),
    )
    parser.add_argument(
        "--clean",
        action="store_true",
        help="Delete output directory before building.",
    )

    args = parser.parse_args()

    compiler_path = Path(args.compiler)
    if not compiler_path.is_file():
        raise FileNotFoundError(f"Compiler not found: {compiler_path}")

    python_exe = Path(args.python)
    if compiler_path.suffix.lower() == ".py" and not python_exe.is_file():
        raise FileNotFoundError(f"Python executable not found: {python_exe}")

    std_import_root = _resolve_std_import_root(Path(args.std))

    default_output_dir = PROJECT_ROOT / "build"
    if args.target == "linux-x64":
        default_output_dir = default_output_dir / "linux"
    output_dir = Path(args.output_dir).resolve() if args.output_dir else default_output_dir.resolve()
    if args.clean and output_dir.exists():
        shutil.rmtree(output_dir)
    output_dir.mkdir(parents=True, exist_ok=True)

    game_entry = Path(args.entry).resolve()
    if not game_entry.is_file():
        raise FileNotFoundError(f"Game entry not found: {game_entry}")

    is_linux = args.target == "linux-x64"
    icon_tool_src = Path(args.icon_tool_src).resolve()
    icon_path = Path(args.icon).resolve()
    icon_tool_exe = output_dir / "tools" / "exe_icon_injector.exe"
    game_exe = output_dir / ("MiniDoom" if is_linux else "MiniDoom.exe")

    if is_linux:
        if args.skip_gl_helper:
            raise ValueError("--skip-gl-helper is not supported for Linux; the renderer depends on its native helpers.")
        print("Building Linux SDL2/OpenGL helpers...")
        _build_linux_helpers(
            DEFAULT_LINUX_PLATFORM_SRC.resolve(),
            DEFAULT_GL_HELPER_SRC.resolve(),
            output_dir,
        )
    else:
        gl_helper_dll = output_dir / "MiniDoomGL.dll"
        if args.skip_gl_helper:
            if not gl_helper_dll.is_file():
                raise FileNotFoundError(
                    "--skip-gl-helper requires an existing MiniDoomGL.dll in the output directory."
                )
            print("Reusing existing MiniDoomGL.dll (--skip-gl-helper).")
        else:
            gl_helper_src = DEFAULT_GL_HELPER_SRC.resolve()
            if gl_helper_src.is_file():
                print("Building MiniDoomGL.dll...")
                _build_gl_helper(gl_helper_src, gl_helper_dll)
            else:
                print(f"Skipping MiniDoomGL.dll: source not found: {gl_helper_src}")

        if not icon_tool_src.is_file():
            raise FileNotFoundError(f"Icon tool source not found: {icon_tool_src}")
        if not args.skip_icon and not icon_path.is_file():
            raise FileNotFoundError(f"Icon file not found: {icon_path}")
        print("Building icon tool...")
        _build_icon_tool(
            compiler_path=compiler_path,
            python_exe=python_exe,
            std_import_root=std_import_root,
            out_exe=icon_tool_exe,
            icon_tool_src=icon_tool_src,
        )

    print("Building MiniDoom...")
    _build_game(
        compiler_path=compiler_path,
        python_exe=python_exe,
        std_import_root=std_import_root,
        out_exe=game_exe,
        game_entry=game_entry,
        target=args.target,
    )

    if is_linux:
        launcher = _make_linux_launcher(output_dir, game_exe)
        if args.linux_music_runtime:
            _copy_linux_music_runtime(Path(args.linux_music_runtime), output_dir)
            print("Bundled FluidSynth music runtime and SoundFont.")
        else:
            print(
                "Music runtime not bundled; install libfluidsynth.so.3 and provide "
                "MiniDoom.sf3 or set MINIDOOM_SOUNDFONT."
            )
        print("Skipping Windows icon injection for Linux target.")
    elif args.skip_icon:
        print("Skipping icon injection (--skip-icon).")
    else:
        print("Injecting icon...")
        _inject_icon(
            icon_tool_exe=icon_tool_exe,
            target_exe=game_exe,
            icon_path=icon_path,
            group_id=args.icon_group,
            lang_id=args.icon_lang,
        )

    print("")
    print("Build complete.")
    print(f"Output {'ELF' if is_linux else 'EXE'}: {game_exe}")
    if is_linux:
        print(f"Launcher: {launcher}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
