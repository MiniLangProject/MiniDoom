#!/usr/bin/env python3
"""
MiniDoom build script.

Build flow:
1) Compile tools/exe_icon_injector.ml -> build/tools/exe_icon_injector.exe
2) Compile src/i_main.ml             -> build/MiniDoom.exe
3) Inject icons/MiniDoom.ico into build/MiniDoom.exe (optional)
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
) -> list[str]:
    comp = compiler_path.resolve()
    inp = input_file.resolve()
    out = output_file.resolve()

    if comp.suffix.lower() == ".py":
        cmd = [str(python_exe.resolve()), str(comp), str(inp), str(out)]
    else:
        cmd = [str(comp), str(inp), str(out)]

    for inc in include_dirs:
        cmd += ["-I", str(inc.resolve())]
    cmd += ["--subsystem", subsystem]
    return cmd


def _run(cmd: list[str], cwd: Path) -> None:
    print(">", " ".join(cmd))
    subprocess.run(cmd, cwd=str(cwd), check=True)


def _find_first_existing(paths: list[Path]) -> Path | None:
    for path in paths:
        if path.exists():
            return path
    return None


def _latest_child_dir(path: Path) -> Path | None:
    if not path.is_dir():
        return None
    dirs = [p for p in path.iterdir() if p.is_dir()]
    if not dirs:
        return None
    return sorted(dirs, key=lambda p: p.name, reverse=True)[0]


def _find_cl_exe() -> Path | None:
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


def _build_icon_tool(
    compiler_path: Path,
    python_exe: Path,
    std_import_root: Path,
    out_exe: Path,
    icon_tool_src: Path,
) -> None:
    out_exe.parent.mkdir(parents=True, exist_ok=True)
    cmd = _compiler_cmd(
        compiler_path=compiler_path,
        python_exe=python_exe,
        input_file=icon_tool_src,
        output_file=out_exe,
        include_dirs=[PROJECT_ROOT / "src", std_import_root],
        subsystem="console",
    )
    _run(cmd, PROJECT_ROOT)


def _build_game(
    compiler_path: Path,
    python_exe: Path,
    std_import_root: Path,
    out_exe: Path,
    game_entry: Path,
) -> None:
    out_exe.parent.mkdir(parents=True, exist_ok=True)
    cmd = _compiler_cmd(
        compiler_path=compiler_path,
        python_exe=python_exe,
        input_file=game_entry,
        output_file=out_exe,
        include_dirs=[PROJECT_ROOT / "src", std_import_root],
        subsystem="windows",
    )
    _run(cmd, PROJECT_ROOT)


def _inject_icon(
    icon_tool_exe: Path,
    target_exe: Path,
    icon_path: Path,
    group_id: int,
    lang_id: int,
) -> None:
    cmd = [
        str(icon_tool_exe.resolve()),
        str(target_exe.resolve()),
        str(icon_path.resolve()),
        str(group_id),
        str(lang_id),
    ]
    _run(cmd, PROJECT_ROOT)


def main() -> int:
    parser = argparse.ArgumentParser(description="Build MiniDoom with optional icon injection.")
    parser.add_argument(
        "--compiler",
        required=True,
        help="Path to MiniLang compiler entrypoint (e.g. mlc_win64.py or compiler exe).",
    )
    parser.add_argument(
        "--std",
        required=True,
        help="Path to std folder OR the parent folder that contains std/.",
    )
    parser.add_argument(
        "--python",
        default=sys.executable,
        help="Python executable used when --compiler points to a .py file (default: current Python).",
    )
    parser.add_argument(
        "--output-dir",
        default=str(PROJECT_ROOT / "build"),
        help="Output directory (default: ./build).",
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
        help="Build MiniDoom.exe without the optional OpenGL VBO helper DLL.",
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

    output_dir = Path(args.output_dir).resolve()
    if args.clean and output_dir.exists():
        shutil.rmtree(output_dir)
    output_dir.mkdir(parents=True, exist_ok=True)

    game_entry = Path(args.entry).resolve()
    if not game_entry.is_file():
        raise FileNotFoundError(f"Game entry not found: {game_entry}")

    icon_tool_src = Path(args.icon_tool_src).resolve()
    if not icon_tool_src.is_file():
        raise FileNotFoundError(f"Icon tool source not found: {icon_tool_src}")

    icon_path = Path(args.icon).resolve()
    if not args.skip_icon and not icon_path.is_file():
        raise FileNotFoundError(f"Icon file not found: {icon_path}")

    icon_tool_exe = output_dir / "tools" / "exe_icon_injector.exe"
    game_exe = output_dir / "MiniDoom.exe"
    gl_helper_dll = output_dir / "MiniDoomGL.dll"

    if args.skip_gl_helper:
        print("Skipping MiniDoomGL.dll (--skip-gl-helper).")
    else:
        gl_helper_src = DEFAULT_GL_HELPER_SRC.resolve()
        if gl_helper_src.is_file():
            print("Building MiniDoomGL.dll...")
            _build_gl_helper(gl_helper_src, gl_helper_dll)
        else:
            print(f"Skipping MiniDoomGL.dll: source not found: {gl_helper_src}")

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
    )

    if args.skip_icon:
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
    print(f"Output EXE: {game_exe}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
