/*
  Copyright 2026 Nils Kopal

  Licensed under the Apache License, Version 2.0 (the "License");
  you may not use this file except in compliance with the License.

*/

//! Declares the Linux SDL2/OpenGL compatibility bridge used by the otherwise platform-neutral MiniDoom engine
//! modules.


#if TARGET_OS == "linux"

// Window, input, software presentation, audio, process, and POSIX helpers.
/// Prints a fatal-error dialog equivalent to the Linux process error stream.
/// @param hwnd `ptr` value supplied as hwnd to `MessageBoxW`.
/// @param text Text to process.
/// @param caption `cstr` value supplied as caption to `MessageBoxW`.
/// @param flags Bit flags that control the operation.
/// @returns Result returned by the native `MessageBoxW` binding as `int`.
extern function MessageBoxW(hwnd as ptr, text as cstr, caption as cstr, flags as u32) from "libMiniDoomPlatform.so" symbol "MDL_MessageBoxW" returns int
/// Creates the SDL2 window and its compatibility-profile OpenGL context.
/// @param exStyle `u32` value supplied as ex style to `CreateWindowExW`.
/// @param className `cstr` value supplied as class name to `CreateWindowExW`.
/// @param windowName `cstr` value supplied as window name to `CreateWindowExW`.
/// @param style `u32` value supplied as style to `CreateWindowExW`.
/// @param x Horizontal map- or screen-space coordinate.
/// @param y Vertical map- or screen-space coordinate.
/// @param width Width of the target in pixels or map units.
/// @param height Height of the target in pixels or map units.
/// @param parent `ptr` value supplied as parent to `CreateWindowExW`.
/// @param menu `ptr` value supplied as menu to `CreateWindowExW`.
/// @param instance `ptr` value supplied as instance to `CreateWindowExW`.
/// @param param `ptr` value supplied as param to `CreateWindowExW`.
/// @returns The resulting SDL2 window and its compatibility-profile OpenGL context.
extern function CreateWindowExW(exStyle as u32, className as cstr, windowName as cstr, style as u32, x as int, y as int, width as int, height as int, parent as ptr, menu as ptr, instance as ptr, param as ptr) from "libMiniDoomPlatform.so" symbol "MDL_CreateWindowExW" returns ptr
/// Accepts Win32-style client sizing because SDL2 receives client dimensions directly.
/// @param rect `bytes` value supplied as rect to `AdjustWindowRect`.
/// @param style `u32` value supplied as style to `AdjustWindowRect`.
/// @param hasMenu Whether has menu holds.
/// @returns Result returned by the native `AdjustWindowRect` binding as `bool`.
extern function AdjustWindowRect(rect as bytes, style as u32, hasMenu as bool) from "libMiniDoomPlatform.so" symbol "MDL_AdjustWindowRect" returns bool
/// Preserves the engine's show-window lifecycle after SDL has displayed the window.
/// @param hwnd `ptr` value supplied as hwnd to `ShowWindow`.
/// @param cmdShow `int` value supplied as cmd show to `ShowWindow`.
/// @returns Result returned by the native `ShowWindow` binding as `bool`.
extern function ShowWindow(hwnd as ptr, cmdShow as int) from "libMiniDoomPlatform.so" symbol "MDL_ShowWindow" returns bool
/// Confirms the SDL window is ready for its first presented frame.
/// @param hwnd `ptr` value supplied as hwnd to `UpdateWindow`.
/// @returns Result returned by the native `UpdateWindow` binding as `bool`.
extern function UpdateWindow(hwnd as ptr) from "libMiniDoomPlatform.so" symbol "MDL_UpdateWindow" returns bool
/// Completes the compatibility repaint contract without a native invalid region.
/// @param hwnd `ptr` value supplied as hwnd to `ValidateRect`.
/// @param rect `ptr` value supplied as rect to `ValidateRect`.
/// @returns Result returned by the native `ValidateRect` binding as `bool`.
extern function ValidateRect(hwnd as ptr, rect as ptr) from "libMiniDoomPlatform.so" symbol "MDL_ValidateRect" returns bool
/// Releases the SDL audio device, GL context, window, and conversion buffer.
/// @param hwnd `ptr` value supplied as hwnd to `DestroyWindow`.
/// @returns Result returned by the native `DestroyWindow` binding as `bool`.
extern function DestroyWindow(hwnd as ptr) from "libMiniDoomPlatform.so" symbol "MDL_DestroyWindow" returns bool
/// Returns the SDL window token used as MiniDoom's device-context handle.
/// @param hwnd `ptr` value supplied as hwnd to `GetDC`.
/// @returns The SDL window token used as MiniDoom's device-context handle.
extern function GetDC(hwnd as ptr) from "libMiniDoomPlatform.so" symbol "MDL_GetDC" returns ptr
/// Completes a borrowed SDL window-token lifetime without destroying it.
/// @param hwnd `ptr` value supplied as hwnd to `ReleaseDC`.
/// @param hdc `ptr` value supplied as hdc to `ReleaseDC`.
/// @returns Result returned by the native `ReleaseDC` binding as `int`.
extern function ReleaseDC(hwnd as ptr, hdc as ptr) from "libMiniDoomPlatform.so" symbol "MDL_ReleaseDC" returns int
/// Writes the current SDL drawable dimensions into a Win32-compatible rectangle.
/// @param hwnd `ptr` value supplied as hwnd to `GetClientRect`.
/// @param rect `bytes` value supplied as rect to `GetClientRect`.
/// @returns Result returned by the native `GetClientRect` binding as `bool`.
extern function GetClientRect(hwnd as ptr, rect as bytes) from "libMiniDoomPlatform.so" symbol "MDL_GetClientRect" returns bool
/// Pumps SDL events and translates relevant ones into MiniDoom's message record.
/// @param msg `bytes` value supplied as msg to `PeekMessageW`.
/// @param hwnd `ptr` value supplied as hwnd to `PeekMessageW`.
/// @param minMsg `u32` value supplied as min msg to `PeekMessageW`.
/// @param maxMsg `u32` value supplied as max msg to `PeekMessageW`.
/// @param removeMsg `u32` value supplied as remove msg to `PeekMessageW`.
/// @returns Result returned by the native `PeekMessageW` binding as `bool`.
extern function PeekMessageW(msg as bytes, hwnd as ptr, minMsg as u32, maxMsg as u32, removeMsg as u32) from "libMiniDoomPlatform.so" symbol "MDL_PeekMessageW" returns bool
/// Retains the Win32 message-pump phase expected by the shared video loop.
/// @param msg `bytes` value supplied as msg to `TranslateMessage`.
/// @returns Result returned by the native `TranslateMessage` binding as `bool`.
extern function TranslateMessage(msg as bytes) from "libMiniDoomPlatform.so" symbol "MDL_TranslateMessage" returns bool
/// Finishes dispatch of an SDL-derived compatibility message.
/// @param msg `bytes` value supplied as msg to `DispatchMessageW`.
/// @returns Result returned by the native `DispatchMessageW` binding as `ptr`.
extern function DispatchMessageW(msg as bytes) from "libMiniDoomPlatform.so" symbol "MDL_DispatchMessageW" returns ptr
/// Returns held and edge-triggered keyboard or mouse-button state in Win32 form.
/// @param vkey Native virtual-key code to translate.
/// @returns Held and edge-triggered keyboard or mouse-button state in Win32 form.
extern function GetAsyncKeyState(vkey as int) from "libMiniDoomPlatform.so" symbol "MDL_GetAsyncKeyState" returns int
/// Updates the SDL window title from the engine's UTF-8 Linux string.
/// @param hwnd `ptr` value supplied as hwnd to `SetWindowTextW`.
/// @param text Text to process.
/// @returns Result returned by the native `SetWindowTextW` binding as `bool`.
extern function SetWindowTextW(hwnd as ptr, text as cstr) from "libMiniDoomPlatform.so" symbol "MDL_SetWindowTextW" returns bool
/// Reports accumulated relative SDL mouse motion through the existing point buffer.
/// @param point `bytes` value supplied as point to `GetCursorPos`.
/// @returns Result returned by the native `GetCursorPos` binding as `bool`.
extern function GetCursorPos(point as bytes) from "libMiniDoomPlatform.so" symbol "MDL_GetCursorPos" returns bool
/// Returns the game-window token only while SDL reports keyboard input focus.
/// @returns The game-window token only while SDL reports keyboard input focus.
extern function GetForegroundWindow() from "libMiniDoomPlatform.so" symbol "MDL_GetForegroundWindow" returns ptr
/// Synchronizes SDL cursor visibility and relative-mouse capture.
/// @param show `bool` value supplied as show to `ShowCursor`.
/// @returns Result returned by the native `ShowCursor` binding as `int`.
extern function ShowCursor(show as bool) from "libMiniDoomPlatform.so" symbol "MDL_ShowCursor" returns int
/// Reads the current SDL display width or height for fullscreen sizing.
/// @param index Zero-based element or table index.
/// @returns The requested the current SDL display width or height for fullscreen sizing.
extern function GetSystemMetrics(index as int) from "libMiniDoomPlatform.so" symbol "MDL_GetSystemMetrics" returns int
/// Applies engine-requested SDL window position and client dimensions.
/// @param hwnd `ptr` value supplied as hwnd to `SetWindowPos`.
/// @param insertAfter `ptr` value supplied as insert after to `SetWindowPos`.
/// @param x Horizontal map- or screen-space coordinate.
/// @param y Vertical map- or screen-space coordinate.
/// @param width Width of the target in pixels or map units.
/// @param height Height of the target in pixels or map units.
/// @param flags Bit flags that control the operation.
/// @returns Result returned by the native `SetWindowPos` binding as `bool`.
extern function SetWindowPos(hwnd as ptr, insertAfter as ptr, x as int, y as int, width as int, height as int, flags as u32) from "libMiniDoomPlatform.so" symbol "MDL_SetWindowPos" returns bool
/// Supplies a neutral legacy style value because SDL owns window decoration state.
/// @param hwnd `ptr` value supplied as hwnd to `GetWindowLongPtrW`.
/// @param index Zero-based element or table index.
/// @returns Result returned by the native `GetWindowLongPtrW` binding as `ptr`.
extern function GetWindowLongPtrW(hwnd as ptr, index as int) from "libMiniDoomPlatform.so" symbol "MDL_GetWindowLongPtrW" returns ptr
/// Acknowledges a legacy style update while SDL applies size and position separately.
/// @param hwnd `ptr` value supplied as hwnd to `SetWindowLongPtrW`.
/// @param index Zero-based element or table index.
/// @param newLong `ptr` value supplied as new long to `SetWindowLongPtrW`.
/// @returns Result returned by the native `SetWindowLongPtrW` binding as `ptr`.
extern function SetWindowLongPtrW(hwnd as ptr, index as int, newLong as ptr) from "libMiniDoomPlatform.so" symbol "MDL_SetWindowLongPtrW" returns ptr
/// Raises the SDL window and reports whether the supplied token is valid.
/// @param hwnd `ptr` value supplied as hwnd to `SetForegroundWindow`.
/// @returns Result returned by the native `SetForegroundWindow` binding as `bool`.
extern function SetForegroundWindow(hwnd as ptr) from "libMiniDoomPlatform.so" symbol "MDL_SetForegroundWindow" returns bool
/// Raises the SDL game window to emulate the Win32 z-order request.
/// @param hwnd `ptr` value supplied as hwnd to `BringWindowToTop`.
/// @returns Result returned by the native `BringWindowToTop` binding as `bool`.
extern function BringWindowToTop(hwnd as ptr) from "libMiniDoomPlatform.so" symbol "MDL_BringWindowToTop" returns bool
/// Activates and returns the SDL game-window compatibility token.
/// @param hwnd `ptr` value supplied as hwnd to `SetActiveWindow`.
/// @returns Result returned by the native `SetActiveWindow` binding as `ptr`.
extern function SetActiveWindow(hwnd as ptr) from "libMiniDoomPlatform.so" symbol "MDL_SetActiveWindow" returns ptr
/// Validates that a compatibility window token still refers to the live SDL window.
/// @param hwnd `ptr` value supplied as hwnd to `IsWindow`.
/// @returns Result returned by the native `IsWindow` binding as `bool`.
extern function IsWindow(hwnd as ptr) from "libMiniDoomPlatform.so" symbol "MDL_IsWindow" returns bool
/// Expands an indexed software frame through its palette and presents it with OpenGL.
/// @param hdc `ptr` value supplied as hdc to `StretchDIBits`.
/// @param xDest `int` value supplied as x dest to `StretchDIBits`.
/// @param yDest `int` value supplied as y dest to `StretchDIBits`.
/// @param destWidth Width of dest width in pixels or map units.
/// @param destHeight Height of dest height in pixels or map units.
/// @param xSrc `int` value supplied as x src to `StretchDIBits`.
/// @param ySrc `int` value supplied as y src to `StretchDIBits`.
/// @param srcWidth Width of src width in pixels or map units.
/// @param srcHeight Height of src height in pixels or map units.
/// @param bits `bytes` value supplied as bits to `StretchDIBits`.
/// @param bmi `bytes` value supplied as bmi to `StretchDIBits`.
/// @param usage `u32` value supplied as usage to `StretchDIBits`.
/// @param rop `u32` value supplied as rop to `StretchDIBits`.
/// @returns Result returned by the native `StretchDIBits` binding as `int`.
extern function StretchDIBits(hdc as ptr, xDest as int, yDest as int, destWidth as int, destHeight as int, xSrc as int, ySrc as int, srcWidth as int, srcHeight as int, bits as bytes, bmi as bytes, usage as u32, rop as u32) from "libMiniDoomPlatform.so" symbol "MDL_StretchDIBits" returns int
/// Preserves the software renderer's requested nearest-neighbor stretch mode.
/// @param hdc `ptr` value supplied as hdc to `SetStretchBltMode`.
/// @param mode `int` value supplied as mode to `SetStretchBltMode`.
/// @returns Result returned by the native `SetStretchBltMode` binding as `int`.
extern function SetStretchBltMode(hdc as ptr, mode as int) from "libMiniDoomPlatform.so" symbol "MDL_SetStretchBltMode" returns int
/// Creates a Linux directory with user-readable and user-writable permissions.
/// @param path Filesystem path to process.
/// @param security Optional native security-attributes pointer.
/// @returns The resulting Linux directory with user-readable and user-writable permissions.
extern function CreateDirectoryW(path as cstr, security as ptr) from "libMiniDoomPlatform.so" symbol "MDL_CreateDirectoryW" returns bool
/// Reports that Linux runs without a separate Win32 console-window handle.
/// @returns Result returned by the native `GetConsoleWindow` binding as `ptr`.
extern function GetConsoleWindow() from "libMiniDoomPlatform.so" symbol "MDL_GetConsoleWindow" returns ptr
/// Exposes Linux directory creation under the save-system-specific binding name.
/// @param path Filesystem path to process.
/// @param security Optional native security-attributes pointer.
/// @returns Result returned by the native `G_CreateDirectoryW` binding as `bool`.
extern function G_CreateDirectoryW(path as cstr, security as ptr) from "libMiniDoomPlatform.so" symbol "MDL_CreateDirectoryW" returns bool
/// Reads a UTF-8 environment value and writes the UTF-16 buffer expected by save code.
/// @param name Resource or object name to resolve.
/// @param buffer Buffer that supplies or receives data.
/// @param size Requested size in bytes or elements.
/// @returns The requested a UTF-8 environment value and writes the UTF-16 buffer expected by save code.
extern function G_GetEnvironmentVariableW(name as cstr, buffer as bytes, size as int) from "libMiniDoomPlatform.so" symbol "MDL_GetEnvironmentVariableW" returns int

/// Returns wrapping monotonic milliseconds for Doom's platform tick clock.
/// @returns Wrapping monotonic milliseconds for Doom's platform tick clock.
extern function GetTickCount() from "libMiniDoomPlatform.so" symbol "MDL_GetTickCount" returns u32
/// Suspends the current Linux thread for the requested millisecond duration.
/// @param ms `int` value supplied as ms to `Sleep`.
/// @returns Result returned by the native `Sleep` binding as `int`.
extern function Sleep(ms as int) from "libMiniDoomPlatform.so" symbol "MDL_Sleep" returns int
/// Terminates MiniDoom immediately with the supplied process exit code.
/// @param code `int` value supplied as code to `ExitProcess`.
/// @returns Result returned by the native `ExitProcess` binding as `int`.
extern function ExitProcess(code as int) from "libMiniDoomPlatform.so" symbol "MDL_ExitProcess" returns int
/// Converts the engine's nonblocking-socket request into POSIX fcntl flags.
/// @param s `ptr` value supplied as s to `ioctlsocket`.
/// @param cmd `i32` value supplied as cmd to `ioctlsocket`.
/// @param argp `bytes` value supplied as argp to `ioctlsocket`.
/// @returns The converted the engine's nonblocking-socket request into POSIX fcntl flags.
extern function ioctlsocket(s as ptr, cmd as i32, argp as bytes) from "libMiniDoomPlatform.so" symbol "MDL_ioctlsocket" returns int
/// Translates WinSock timeout constants before applying the POSIX socket option.
/// @param s `ptr` value supplied as s to `setsockopt`.
/// @param level `int` value supplied as level to `setsockopt`.
/// @param optname `int` value supplied as optname to `setsockopt`.
/// @param optval `bytes` value supplied as optval to `setsockopt`.
/// @param optlen `int` value supplied as optlen to `setsockopt`.
/// @returns Result returned by the native `setsockopt` binding as `int`.
extern function setsockopt(s as ptr, level as int, optname as int, optval as bytes, optlen as int) from "libMiniDoomPlatform.so" symbol "MDL_setsockopt" returns int

/// Opens an SDL queued-audio device from MiniDoom's PCM format record.
/// @param phwo `bytes` value supplied as phwo to `waveOutOpen`.
/// @param dev `u32` value supplied as dev to `waveOutOpen`.
/// @param pwfx Native wave-format descriptor.
/// @param cb `ptr` value supplied as cb to `waveOutOpen`.
/// @param inst `ptr` value supplied as inst to `waveOutOpen`.
/// @param flags Bit flags that control the operation.
/// @returns Result returned by the native `waveOutOpen` binding as `u32`.
extern function waveOutOpen(phwo as bytes, dev as u32, pwfx as bytes, cb as ptr, inst as ptr, flags as u32) from "libMiniDoomPlatform.so" symbol "MDL_waveOutOpen" returns u32
/// Accepts a wave buffer for compatibility with the WinMM preparation phase.
/// @param hwo `ptr` value supplied as hwo to `waveOutPrepareHeader`.
/// @param pwh `ptr` value supplied as pwh to `waveOutPrepareHeader`.
/// @param cbwh `u32` value supplied as cbwh to `waveOutPrepareHeader`.
/// @returns Result returned by the native `waveOutPrepareHeader` binding as `u32`.
extern function waveOutPrepareHeader(hwo as ptr, pwh as ptr, cbwh as u32) from "libMiniDoomPlatform.so" symbol "MDL_waveOutPrepareHeader" returns u32
/// Queues one mixed PCM buffer on SDL and tracks its eventual completion flag.
/// @param hwo `ptr` value supplied as hwo to `waveOutWrite`.
/// @param pwh `ptr` value supplied as pwh to `waveOutWrite`.
/// @param cbwh `u32` value supplied as cbwh to `waveOutWrite`.
/// @returns Result returned by the native `waveOutWrite` binding as `u32`.
extern function waveOutWrite(hwo as ptr, pwh as ptr, cbwh as u32) from "libMiniDoomPlatform.so" symbol "MDL_waveOutWrite" returns u32
/// Completes the WinMM-style buffer lifecycle after SDL has consumed its samples.
/// @param hwo `ptr` value supplied as hwo to `waveOutUnprepareHeader`.
/// @param pwh `ptr` value supplied as pwh to `waveOutUnprepareHeader`.
/// @param cbwh `u32` value supplied as cbwh to `waveOutUnprepareHeader`.
/// @returns Result returned by the native `waveOutUnprepareHeader` binding as `u32`.
extern function waveOutUnprepareHeader(hwo as ptr, pwh as ptr, cbwh as u32) from "libMiniDoomPlatform.so" symbol "MDL_waveOutUnprepareHeader" returns u32
/// Clears queued SDL samples and marks every pending wave buffer complete.
/// @param hwo `ptr` value supplied as hwo to `waveOutReset`.
/// @returns Result returned by the native `waveOutReset` binding as `u32`.
extern function waveOutReset(hwo as ptr) from "libMiniDoomPlatform.so" symbol "MDL_waveOutReset" returns u32
/// Resets and closes MiniDoom's SDL queued-audio device.
/// @param hwo `ptr` value supplied as hwo to `waveOutClose`.
/// @returns Result returned by the native `waveOutClose` binding as `u32`.
extern function waveOutClose(hwo as ptr) from "libMiniDoomPlatform.so" symbol "MDL_waveOutClose" returns u32
/// Opens the SDL2 software synthesizer used by the existing MUS sequencer.
/// @param phmo `bytes` value supplied as phmo to `midiOutOpen`.
/// @param dev `u32` value supplied as dev to `midiOutOpen`.
/// @param cb `ptr` value supplied as cb to `midiOutOpen`.
/// @param inst `ptr` value supplied as inst to `midiOutOpen`.
/// @param flags Bit flags that control the operation.
/// @returns Result returned by the native `midiOutOpen` binding as `u32`.
extern function midiOutOpen(phmo as bytes, dev as u32, cb as ptr, inst as ptr, flags as u32) from "libMiniDoomPlatform.so" symbol "MDL_midiOutOpen" returns u32
/// Applies a packed MIDI message to the Linux software-synth voices.
/// @param hmo `ptr` value supplied as hmo to `midiOutShortMsg`.
/// @param msg `u32` value supplied as msg to `midiOutShortMsg`.
/// @returns Result returned by the native `midiOutShortMsg` binding as `u32`.
extern function midiOutShortMsg(hmo as ptr, msg as u32) from "libMiniDoomPlatform.so" symbol "MDL_midiOutShortMsg" returns u32
/// Silences all Linux synth voices and restores channel controller defaults.
/// @param hmo `ptr` value supplied as hmo to `midiOutReset`.
/// @returns Result returned by the native `midiOutReset` binding as `u32`.
extern function midiOutReset(hmo as ptr) from "libMiniDoomPlatform.so" symbol "MDL_midiOutReset" returns u32
/// Stops and closes the SDL2 music device.
/// @param hmo `ptr` value supplied as hmo to `midiOutClose`.
/// @returns Result returned by the native `midiOutClose` binding as `u32`.
extern function midiOutClose(hmo as ptr) from "libMiniDoomPlatform.so" symbol "MDL_midiOutClose" returns u32
/// Applies the packed stereo music volume to the software-synth master gain.
/// @param hmo `ptr` value supplied as hmo to `midiOutSetVolume`.
/// @param vol `u32` value supplied as vol to `midiOutSetVolume`.
/// @returns Result returned by the native `midiOutSetVolume` binding as `u32`.
extern function midiOutSetVolume(hmo as ptr, vol as u32) from "libMiniDoomPlatform.so" symbol "MDL_midiOutSetVolume" returns u32
/// Allocates zeroed unmanaged storage while preserving GlobalAlloc's two-argument ABI.
/// @param flags Bit flags that control the operation.
/// @param size Requested size in bytes or elements.
/// @returns The resulting zeroed unmanaged storage while preserving GlobalAlloc's two-argument ABI.
extern function GlobalAlloc(flags as u32, size as u32) from "libMiniDoomPlatform.so" symbol "MDL_GlobalAlloc" returns ptr
/// Releases unmanaged queued-audio storage and returns a null compatibility pointer.
/// @param mem `ptr` value supplied as mem to `GlobalFree`.
/// @returns Result returned by the native `GlobalFree` binding as `ptr`.
extern function GlobalFree(mem as ptr) from "libMiniDoomPlatform.so" symbol "MDL_GlobalFree" returns ptr
/// Copies MiniLang-managed audio bytes into an unmanaged buffer.
/// @param dst `ptr` value supplied as dst to `RtlMoveMemoryToPtr`.
/// @param src `bytes` value supplied as src to `RtlMoveMemoryToPtr`.
/// @param len `u32` value supplied as len to `RtlMoveMemoryToPtr`.
extern function RtlMoveMemoryToPtr(dst as ptr, src as bytes, len as u32) from "libc.so.6" symbol "memmove" returns void
/// Refreshes SDL completion flags before copying an unmanaged wave header back.
/// @param dst `bytes` value supplied as dst to `RtlMoveMemoryFromPtr`.
/// @param src `ptr` value supplied as src to `RtlMoveMemoryFromPtr`.
/// @param len `u32` value supplied as len to `RtlMoveMemoryFromPtr`.
extern function RtlMoveMemoryFromPtr(dst as bytes, src as ptr, len as u32) from "libMiniDoomPlatform.so" symbol "MDL_RtlMoveMemoryFromPtr" returns void

// SDL owns the GL context; these compatibility calls retain the renderer API.
/// Confirms the SDL-created framebuffer format is available to the renderer.
/// @param hdc `ptr` value supplied as hdc to `ChoosePixelFormat`.
/// @param pfd `bytes` value supplied as pfd to `ChoosePixelFormat`.
/// @returns Result returned by the native `ChoosePixelFormat` binding as `int`.
extern function ChoosePixelFormat(hdc as ptr, pfd as bytes) from "libMiniDoomPlatform.so" symbol "MDL_ChoosePixelFormat" returns int
/// Accepts the already-fixed SDL framebuffer format for shared WGL-style setup.
/// @param hdc `ptr` value supplied as hdc to `SetPixelFormat`.
/// @param format `int` value supplied as format to `SetPixelFormat`.
/// @param pfd `bytes` value supplied as pfd to `SetPixelFormat`.
/// @returns Result returned by the native `SetPixelFormat` binding as `bool`.
extern function SetPixelFormat(hdc as ptr, format as int, pfd as bytes) from "libMiniDoomPlatform.so" symbol "MDL_SetPixelFormat" returns bool
/// Presents the current back buffer through SDL_GL_SwapWindow.
/// @param hdc `ptr` value supplied as hdc to `SwapBuffers`.
/// @returns Result returned by the native `SwapBuffers` binding as `bool`.
extern function SwapBuffers(hdc as ptr) from "libMiniDoomPlatform.so" symbol "MDL_SwapBuffers" returns bool
/// Returns the OpenGL context created together with the SDL game window.
/// @param hdc `ptr` value supplied as hdc to `wglCreateContext`.
/// @returns The OpenGL context created together with the SDL game window.
extern function wglCreateContext(hdc as ptr) from "libMiniDoomPlatform.so" symbol "MDL_GLCreateContext" returns ptr
/// Makes or clears SDL's current OpenGL context for the calling thread.
/// @param hdc `ptr` value supplied as hdc to `wglMakeCurrent`.
/// @param hglrc `ptr` value supplied as hglrc to `wglMakeCurrent`.
/// @returns Result returned by the native `wglMakeCurrent` binding as `bool`.
extern function wglMakeCurrent(hdc as ptr, hglrc as ptr) from "libMiniDoomPlatform.so" symbol "MDL_GLMakeCurrent" returns bool
/// Deletes the SDL-owned compatibility-profile OpenGL context.
/// @param hglrc `ptr` value supplied as hglrc to `wglDeleteContext`.
/// @returns Result returned by the native `wglDeleteContext` binding as `bool`.
extern function wglDeleteContext(hglrc as ptr) from "libMiniDoomPlatform.so" symbol "MDL_GLDeleteContext" returns bool

// Legacy OpenGL 2.1 entry points used by MiniDoom's compatibility renderer.
/// Selects the drawable rectangle used for the current MiniDoom frame.
/// @param x Horizontal map- or screen-space coordinate.
/// @param y Vertical map- or screen-space coordinate.
/// @param width Width of the target in pixels or map units.
/// @param height Height of the target in pixels or map units.
extern function glViewport(x as int, y as int, width as int, height as int) from "libGL.so.1" returns void
/// Clears the selected OpenGL color or depth buffers.
/// @param mask `u32` value supplied as mask to `glClear`.
extern function glClear(mask as u32) from "libGL.so.1" returns void
/// Sets the depth value written by depth-buffer clear operations.
/// @param depth `double` value supplied as depth to `glClearDepth`.
extern function glClearDepth(depth as double) from "libGL.so.1" returns void
/// Enables a legacy OpenGL render capability.
/// @param cap `u32` value supplied as cap to `glEnable`.
extern function glEnable(cap as u32) from "libGL.so.1" returns void
/// Disables a legacy OpenGL render capability.
/// @param cap `u32` value supplied as cap to `glDisable`.
extern function glDisable(cap as u32) from "libGL.so.1" returns void
/// Controls whether rendered fragments update the depth buffer.
/// @param flag `bool` value supplied as flag to `glDepthMask`.
extern function glDepthMask(flag as bool) from "libGL.so.1" returns void
/// Selects the framebuffer color channels writable by subsequent draws.
/// @param red `bool` value supplied as red to `glColorMask`.
/// @param green `bool` value supplied as green to `glColorMask`.
/// @param blue `bool` value supplied as blue to `glColorMask`.
/// @param alpha `bool` value supplied as alpha to `glColorMask`.
extern function glColorMask(red as bool, green as bool, blue as bool, alpha as bool) from "libGL.so.1" returns void
/// Chooses the depth comparison used for world geometry.
/// @param func `u32` value supplied as func to `glDepthFunc`.
extern function glDepthFunc(func as u32) from "libGL.so.1" returns void
/// Selects the projection or model-view matrix stack.
/// @param mode `u32` value supplied as mode to `glMatrixMode`.
extern function glMatrixMode(mode as u32) from "libGL.so.1" returns void
/// Resets the selected legacy matrix to identity.
extern function glLoadIdentity() from "libGL.so.1" returns void
/// Builds MiniDoom's perspective projection frustum.
/// @param left `double` value supplied as left to `glFrustum`.
/// @param right `double` value supplied as right to `glFrustum`.
/// @param bottom `double` value supplied as bottom to `glFrustum`.
/// @param top `double` value supplied as top to `glFrustum`.
/// @param zNear `double` value supplied as z near to `glFrustum`.
/// @param zFar `double` value supplied as z far to `glFrustum`.
extern function glFrustum(left as double, right as double, bottom as double, top as double, zNear as double, zFar as double) from "libGL.so.1" returns void
/// Applies a double-precision rotation to the selected matrix.
/// @param angle Doom binary-angle measurement.
/// @param x Horizontal map- or screen-space coordinate.
/// @param y Vertical map- or screen-space coordinate.
/// @param z Vertical world-space coordinate.
extern function glRotated(angle as double, x as double, y as double, z as double) from "libGL.so.1" returns void
/// Applies a double-precision translation to the selected matrix.
/// @param x Horizontal map- or screen-space coordinate.
/// @param y Vertical map- or screen-space coordinate.
/// @param z Vertical world-space coordinate.
extern function glTranslated(x as double, y as double, z as double) from "libGL.so.1" returns void
/// Applies a double-precision scale to the selected matrix.
/// @param x Horizontal map- or screen-space coordinate.
/// @param y Vertical map- or screen-space coordinate.
/// @param z Vertical world-space coordinate.
extern function glScaled(x as double, y as double, z as double) from "libGL.so.1" returns void
/// Saves the current matrix before a localized world transform.
extern function glPushMatrix() from "libGL.so.1" returns void
/// Restores the matrix saved for a localized world transform.
extern function glPopMatrix() from "libGL.so.1" returns void
/// Begins immediate-mode emission for the requested primitive kind.
/// @param mode `u32` value supplied as mode to `glBegin`.
extern function glBegin(mode as u32) from "libGL.so.1" returns void
/// Completes the current immediate-mode primitive sequence.
extern function glEnd() from "libGL.so.1" returns void
/// Allocates consecutive display-list identifiers for static map geometry.
/// @param range `int` value supplied as range to `glGenLists`.
/// @returns The resulting consecutive display-list identifiers for static map geometry.
extern function glGenLists(range as int) from "libGL.so.1" returns u32
/// Starts compiling one static-geometry display list.
/// @param list `u32` value supplied as list to `glNewList`.
/// @param mode `u32` value supplied as mode to `glNewList`.
extern function glNewList(list as u32, mode as u32) from "libGL.so.1" returns void
/// Finishes compilation of the active display list.
extern function glEndList() from "libGL.so.1" returns void
/// Replays a compiled display list for static geometry.
/// @param list `u32` value supplied as list to `glCallList`.
extern function glCallList(list as u32) from "libGL.so.1" returns void
/// Releases a range of static-geometry display lists.
/// @param list `u32` value supplied as list to `glDeleteLists`.
/// @param range `int` value supplied as range to `glDeleteLists`.
extern function glDeleteLists(list as u32, range as int) from "libGL.so.1" returns void
/// Enables one legacy vertex-array attribute stream.
/// @param array Array that supplies or receives the operation's values.
extern function glEnableClientState(array as u32) from "libGL.so.1" returns void
/// Disables one legacy vertex-array attribute stream.
/// @param array Array that supplies or receives the operation's values.
extern function glDisableClientState(array as u32) from "libGL.so.1" returns void
/// Describes the packed position stream for an array draw.
/// @param size Requested size in bytes or elements.
/// @param typ `u32` value supplied as typ to `glVertexPointer`.
/// @param stride `int` value supplied as stride to `glVertexPointer`.
/// @param pointer `bytes` value supplied as pointer to `glVertexPointer`.
extern function glVertexPointer(size as int, typ as u32, stride as int, pointer as bytes) from "libGL.so.1" returns void
/// Describes the packed texture-coordinate stream for an array draw.
/// @param size Requested size in bytes or elements.
/// @param typ `u32` value supplied as typ to `glTexCoordPointer`.
/// @param stride `int` value supplied as stride to `glTexCoordPointer`.
/// @param pointer `bytes` value supplied as pointer to `glTexCoordPointer`.
extern function glTexCoordPointer(size as int, typ as u32, stride as int, pointer as bytes) from "libGL.so.1" returns void
/// Describes the packed light-color stream for an array draw.
/// @param size Requested size in bytes or elements.
/// @param typ `u32` value supplied as typ to `glColorPointer`.
/// @param stride `int` value supplied as stride to `glColorPointer`.
/// @param pointer `bytes` value supplied as pointer to `glColorPointer`.
extern function glColorPointer(size as int, typ as u32, stride as int, pointer as bytes) from "libGL.so.1" returns void
/// Draws consecutive vertices from the configured client arrays.
/// @param mode `u32` value supplied as mode to `glDrawArrays`.
/// @param first `int` value supplied as first to `glDrawArrays`.
/// @param count Number of elements or iterations to process.
extern function glDrawArrays(mode as u32, first as int, count as int) from "libGL.so.1" returns void
/// Emits one double-precision immediate-mode world position.
/// @param x Horizontal map- or screen-space coordinate.
/// @param y Vertical map- or screen-space coordinate.
/// @param z Vertical world-space coordinate.
extern function glVertex3d(x as double, y as double, z as double) from "libGL.so.1" returns void
/// Emits one double-precision immediate-mode texture coordinate.
/// @param s `double` value supplied as s to `glTexCoord2d`.
/// @param t `double` value supplied as t to `glTexCoord2d`.
extern function glTexCoord2d(s as double, t as double) from "libGL.so.1" returns void
/// Sets an opaque unsigned-byte vertex color for sector lighting.
/// @param r `int` value supplied as r to `glColor3ub`.
/// @param g `int` value supplied as g to `glColor3ub`.
/// @param b Second input operand.
extern function glColor3ub(r as int, g as int, b as int) from "libGL.so.1" returns void
/// Sets an unsigned-byte vertex color including sprite or overlay alpha.
/// @param r `int` value supplied as r to `glColor4ub`.
/// @param g `int` value supplied as g to `glColor4ub`.
/// @param b Second input operand.
/// @param a First input operand.
extern function glColor4ub(r as int, g as int, b as int, a as int) from "libGL.so.1" returns void
/// Selects source and destination factors for translucent surfaces.
/// @param sfactor `u32` value supplied as sfactor to `glBlendFunc`.
/// @param dfactor `u32` value supplied as dfactor to `glBlendFunc`.
extern function glBlendFunc(sfactor as u32, dfactor as u32) from "libGL.so.1" returns void
/// Sets the cutout threshold applied to masked Doom texels.
/// @param func `u32` value supplied as func to `glAlphaFunc`.
/// @param ref `double` value supplied as ref to `glAlphaFunc`.
extern function glAlphaFunc(func as u32, ref as double) from "libGL.so.1" returns void
/// Allocates texture identifiers for palette-expanded Doom images.
/// @param n Number of values to process.
/// @param textures `bytes` value supplied as textures to `glGenTextures`.
extern function glGenTextures(n as int, textures as bytes) from "libGL.so.1" returns void
/// Selects the texture consumed by subsequent world or sprite draws.
/// @param target `u32` value supplied as target to `glBindTexture`.
/// @param texture `u32` value supplied as texture to `glBindTexture`.
extern function glBindTexture(target as u32, texture as u32) from "libGL.so.1" returns void
/// Configures filtering and wrapping for the selected texture.
/// @param target `u32` value supplied as target to `glTexParameteri`.
/// @param pname `u32` value supplied as pname to `glTexParameteri`.
/// @param param `int` value supplied as param to `glTexParameteri`.
extern function glTexParameteri(target as u32, pname as u32, param as int) from "libGL.so.1" returns void
/// Uploads a palette-expanded RGBA image into the selected texture.
/// @param target `u32` value supplied as target to `glTexImage2D`.
/// @param level `int` value supplied as level to `glTexImage2D`.
/// @param internalFormat `int` value supplied as internal format to `glTexImage2D`.
/// @param width Width of the target in pixels or map units.
/// @param height Height of the target in pixels or map units.
/// @param border `int` value supplied as border to `glTexImage2D`.
/// @param format `u32` value supplied as format to `glTexImage2D`.
/// @param typ `u32` value supplied as typ to `glTexImage2D`.
/// @param pixels `bytes` value supplied as pixels to `glTexImage2D`.
extern function glTexImage2D(target as u32, level as int, internalFormat as int, width as int, height as int, border as int, format as u32, typ as u32, pixels as bytes) from "libGL.so.1" returns void
/// Configures byte alignment for texture uploads or framebuffer reads.
/// @param pname `u32` value supplied as pname to `glPixelStorei`.
/// @param param `int` value supplied as param to `glPixelStorei`.
extern function glPixelStorei(pname as u32, param as int) from "libGL.so.1" returns void
/// Copies the rendered framebuffer into MiniLang-managed screenshot bytes.
/// @param x Horizontal map- or screen-space coordinate.
/// @param y Vertical map- or screen-space coordinate.
/// @param width Width of the target in pixels or map units.
/// @param height Height of the target in pixels or map units.
/// @param format `u32` value supplied as format to `glReadPixels`.
/// @param typ `u32` value supplied as typ to `glReadPixels`.
/// @param pixels `bytes` value supplied as pixels to `glReadPixels`.
extern function glReadPixels(x as int, y as int, width as int, height as int, format as u32, typ as u32, pixels as bytes) from "libGL.so.1" returns void
/// Selects the front or back framebuffer used by a screenshot read.
/// @param mode `u32` value supplied as mode to `glReadBuffer`.
extern function glReadBuffer(mode as u32) from "libGL.so.1" returns void

// Performance helper compiled from tools/minidoom_gl_helper.c for Linux.
/// Resolves buffer-object functions for the active Linux OpenGL context.
/// @returns The requested buffer-object functions for the active Linux OpenGL context.
extern function MGL_InitVBO() from "libMiniDoomGL.so" returns bool
/// Applies SDL's vertical-sync interval to the active game window.
/// @param interval `int` value supplied as interval to `MGL_SetSwapInterval`.
/// @returns Result returned by the native `MGL_SetSwapInterval` binding as `bool`.
extern function MGL_SetSwapInterval(interval as int) from "libMiniDoomPlatform.so" symbol "MDL_GLSetSwapInterval" returns bool
/// Returns a monotonic microsecond timestamp for renderer profiling.
/// @returns A monotonic microsecond timestamp for renderer profiling.
extern function MGL_TimeMicroseconds() from "libMiniDoomGL.so" returns i64
/// Sleeps and yields until the next configured frame deadline.
/// @param targetFps `int` value supplied as target fps to `MGL_FramePace`.
/// @param leadUs `int` value supplied as lead us to `MGL_FramePace`.
extern function MGL_FramePace(targetFps as int, leadUs as int) from "libMiniDoomGL.so" returns void
/// Advances the native frame-pacing deadline after a successful swap.
extern function MGL_FramePaceMark() from "libMiniDoomGL.so" returns void
/// Rasterizes one software column with native bounds and palette checks.
/// @param dest `bytes` value supplied as dest to `MGL_RasterColumn8`.
/// @param destBytes `int` value supplied as dest bytes to `MGL_RasterColumn8`.
/// @param destIndex Index identifying dest.
/// @param destStride `int` value supplied as dest stride to `MGL_RasterColumn8`.
/// @param count Number of elements or iterations to process.
/// @param source Source value or buffer.
/// @param sourceBytes `int` value supplied as source bytes to `MGL_RasterColumn8`.
/// @param sourceOffset `int` value supplied as source offset to `MGL_RasterColumn8`.
/// @param sourceLength `int` value supplied as source length to `MGL_RasterColumn8`.
/// @param colormap `bytes` value supplied as colormap to `MGL_RasterColumn8`.
/// @param colormapLength `int` value supplied as colormap length to `MGL_RasterColumn8`.
/// @param frac `int` value supplied as frac to `MGL_RasterColumn8`.
/// @param fracStep `int` value supplied as frac step to `MGL_RasterColumn8`.
/// @param sourceClamp `int` value supplied as source clamp to `MGL_RasterColumn8`.
/// @returns Result returned by the native `MGL_RasterColumn8` binding as `bool`.
extern function MGL_RasterColumn8(dest as bytes, destBytes as int, destIndex as int, destStride as int, count as int, source as bytes, sourceBytes as int, sourceOffset as int, sourceLength as int, colormap as bytes, colormapLength as int, frac as int, fracStep as int, sourceClamp as int) from "libMiniDoomGL.so" returns bool
/// Rasterizes one software span with native texture wrapping and colormapping.
/// @param dest `bytes` value supplied as dest to `MGL_RasterSpan8`.
/// @param destBytes `int` value supplied as dest bytes to `MGL_RasterSpan8`.
/// @param destIndex Index identifying dest.
/// @param count Number of elements or iterations to process.
/// @param source Source value or buffer.
/// @param sourceBytes `int` value supplied as source bytes to `MGL_RasterSpan8`.
/// @param colormap `bytes` value supplied as colormap to `MGL_RasterSpan8`.
/// @param colormapLength `int` value supplied as colormap length to `MGL_RasterSpan8`.
/// @param sourceWidth Width of source width in pixels or map units.
/// @param sourceHeight Height of source height in pixels or map units.
/// @param xFrac `int` value supplied as x frac to `MGL_RasterSpan8`.
/// @param yFrac `int` value supplied as y frac to `MGL_RasterSpan8`.
/// @param xStep `int` value supplied as x step to `MGL_RasterSpan8`.
/// @param yStep `int` value supplied as y step to `MGL_RasterSpan8`.
/// @returns Result returned by the native `MGL_RasterSpan8` binding as `bool`.
extern function MGL_RasterSpan8(dest as bytes, destBytes as int, destIndex as int, count as int, source as bytes, sourceBytes as int, colormap as bytes, colormapLength as int, sourceWidth as int, sourceHeight as int, xFrac as int, yFrac as int, xStep as int, yStep as int) from "libMiniDoomGL.so" returns bool
/// Expands indexed pixels to RGBA for fast overlay texture uploads.
/// @param source Source value or buffer.
/// @param sourceBytes `int` value supplied as source bytes to `MGL_ExpandIndexed8`.
/// @param dest `bytes` value supplied as dest to `MGL_ExpandIndexed8`.
/// @param destBytes `int` value supplied as dest bytes to `MGL_ExpandIndexed8`.
/// @param palette `bytes` value supplied as palette to `MGL_ExpandIndexed8`.
/// @param paletteBytes `int` value supplied as palette bytes to `MGL_ExpandIndexed8`.
/// @param pixels `int` value supplied as pixels to `MGL_ExpandIndexed8`.
/// @returns Result returned by the native `MGL_ExpandIndexed8` binding as `bool`.
extern function MGL_ExpandIndexed8(source as bytes, sourceBytes as int, dest as bytes, destBytes as int, palette as bytes, paletteBytes as int, pixels as int) from "libMiniDoomGL.so" returns bool
/// Uploads one raw vertex attribute stream into an OpenGL array buffer.
/// @param data Binary or structured data to process.
/// @param size Requested size in bytes or elements.
/// @returns Result returned by the native `MGL_CreateArrayBuffer` binding as `u32`.
extern function MGL_CreateArrayBuffer(data as bytes, size as int) from "libMiniDoomGL.so" returns u32
/// Uploads packed position, UV, and light data into one geometry buffer.
/// @param data Binary or structured data to process.
/// @param size Requested size in bytes or elements.
/// @returns Result returned by the native `MGL_CreateInterleavedGeomBuffer` binding as `u32`.
extern function MGL_CreateInterleavedGeomBuffer(data as bytes, size as int) from "libMiniDoomGL.so" returns u32
/// Releases a native OpenGL array-buffer identifier.
/// @param id `u32` value supplied as id to `MGL_DeleteArrayBuffer`.
extern function MGL_DeleteArrayBuffer(id as u32) from "libMiniDoomGL.so" returns void
/// Draws a batch backed by separate position, UV, and color buffers.
/// @param mode `u32` value supplied as mode to `MGL_DrawArrayBatch`.
/// @param vertexBuffer `u32` value supplied as vertex buffer to `MGL_DrawArrayBatch`.
/// @param texcoordBuffer `u32` value supplied as texcoord buffer to `MGL_DrawArrayBatch`.
/// @param colorBuffer `u32` value supplied as color buffer to `MGL_DrawArrayBatch`.
/// @param count Number of elements or iterations to process.
extern function MGL_DrawArrayBatch(mode as u32, vertexBuffer as u32, texcoordBuffer as u32, colorBuffer as u32, count as int) from "libMiniDoomGL.so" returns void
/// Draws one batch from MiniDoom's packed static-geometry buffer.
/// @param mode `u32` value supplied as mode to `MGL_DrawInterleavedBatch`.
/// @param buffer Buffer that supplies or receives data.
/// @param count Number of elements or iterations to process.
extern function MGL_DrawInterleavedBatch(mode as u32, buffer as u32, count as int) from "libMiniDoomGL.so" returns void
/// Frustum-culls and draws visible packed map-geometry batch records.
/// @param mode `u32` value supplied as mode to `MGL_DrawVisibleGeomBatches`.
/// @param records `bytes` value supplied as records to `MGL_DrawVisibleGeomBatches`.
/// @param recordCount Number of record to process.
/// @param viewX Horizontal coordinate or vector component represented by view x.
/// @param viewY Vertical coordinate or vector component represented by view y.
/// @param viewYaw `double` value supplied as view yaw to `MGL_DrawVisibleGeomBatches`.
/// @returns Result returned by the native `MGL_DrawVisibleGeomBatches` binding as `bool`.
extern function MGL_DrawVisibleGeomBatches(mode as u32, records as bytes, recordCount as int, viewX as double, viewY as double, viewYaw as double) from "libMiniDoomGL.so" returns bool
/// Accumulates dynamic-light contributions across packed map surfaces.
/// @param geomData `bytes` value supplied as geom data to `MGL_DrawDynamicLightSurfaces`.
/// @param geomSize `int` value supplied as geom size to `MGL_DrawDynamicLightSurfaces`.
/// @param lightData `bytes` value supplied as light data to `MGL_DrawDynamicLightSurfaces`.
/// @param lightCount Number of light to process.
/// @returns Result returned by the native `MGL_DrawDynamicLightSurfaces` binding as `bool`.
extern function MGL_DrawDynamicLightSurfaces(geomData as bytes, geomSize as int, lightData as bytes, lightCount as int) from "libMiniDoomGL.so" returns bool
/// Initializes native sprite batching with camera and dynamic-light state.
/// @param lightData `bytes` value supplied as light data to `MGL_BeginSpriteBatch`.
/// @param lightCount Number of light to process.
/// @param viewX Horizontal coordinate or vector component represented by view x.
/// @param viewY Vertical coordinate or vector component represented by view y.
/// @param rightX Horizontal coordinate or vector component represented by right x.
/// @param rightZ `double` value supplied as right z to `MGL_BeginSpriteBatch`.
/// @param worldScale `double` value supplied as world scale to `MGL_BeginSpriteBatch`.
/// @param footLift `double` value supplied as foot lift to `MGL_BeginSpriteBatch`.
/// @returns Result returned by the native `MGL_BeginSpriteBatch` binding as `bool`.
extern function MGL_BeginSpriteBatch(lightData as bytes, lightCount as int, viewX as double, viewY as double, rightX as double, rightZ as double, worldScale as double, footLift as double) from "libMiniDoomGL.so" returns bool
/// Appends one world sprite to the active native batch.
/// @param texid `u32` value supplied as texid to `MGL_SubmitSprite`.
/// @param flags Bit flags that control the operation.
/// @param baseLight `int` value supplied as base light to `MGL_SubmitSprite`.
/// @param fixedX Horizontal coordinate or vector component represented by fixed x.
/// @param fixedY Vertical coordinate or vector component represented by fixed y.
/// @param fixedZ `int` value supplied as fixed z to `MGL_SubmitSprite`.
/// @param width Width of the target in pixels or map units.
/// @param height Height of the target in pixels or map units.
/// @param yOffset `int` value supplied as y offset to `MGL_SubmitSprite`.
extern function MGL_SubmitSprite(texid as u32, flags as int, baseLight as int, fixedX as int, fixedY as int, fixedZ as int, width as int, height as int, yOffset as int) from "libMiniDoomGL.so" returns void
/// Decodes and draws packed sprite records in one native call.
/// @param records `bytes` value supplied as records to `MGL_DrawSpriteRecords`.
/// @param recordsSize `int` value supplied as records size to `MGL_DrawSpriteRecords`.
/// @param recordCount Number of record to process.
/// @returns Result returned by the native `MGL_DrawSpriteRecords` binding as `bool`.
extern function MGL_DrawSpriteRecords(records as bytes, recordsSize as int, recordCount as int) from "libMiniDoomGL.so" returns bool
/// Flushes queued native sprites in texture-compatible groups.
extern function MGL_EndSpriteBatch() from "libMiniDoomGL.so" returns void
/// Reports the number of geometry batches drawn by the latest culling pass.
/// @returns Result returned by the native `MGL_GetLastDrawnBatches` binding as `int`.
extern function MGL_GetLastDrawnBatches() from "libMiniDoomGL.so" returns int
/// Reports the number of vertices drawn by the latest culling pass.
/// @returns Result returned by the native `MGL_GetLastDrawnVertices` binding as `int`.
extern function MGL_GetLastDrawnVertices() from "libMiniDoomGL.so" returns int
/// Draws a full indexed HUD or console overlay with optional transparency mask.
/// @param texid `u32` value supplied as texid to `MGL_DrawIndexedOverlay`.
/// @param data Binary or structured data to process.
/// @param mask `bytes` value supplied as mask to `MGL_DrawIndexedOverlay`.
/// @param palette `bytes` value supplied as palette to `MGL_DrawIndexedOverlay`.
/// @param width Width of the target in pixels or map units.
/// @param height Height of the target in pixels or map units.
/// @returns Result returned by the native `MGL_DrawIndexedOverlay` binding as `bool`.
extern function MGL_DrawIndexedOverlay(texid as u32, data as bytes, mask as bytes, palette as bytes, width as int, height as int) from "libMiniDoomGL.so" returns bool
/// Updates and draws the dirty logical overlay region at the active render scale.
/// @param texid `u32` value supplied as texid to `MGL_DrawIndexedLogicalOverlay`.
/// @param data Binary or structured data to process.
/// @param dataSize `int` value supplied as data size to `MGL_DrawIndexedLogicalOverlay`.
/// @param mask `bytes` value supplied as mask to `MGL_DrawIndexedLogicalOverlay`.
/// @param maskSize `int` value supplied as mask size to `MGL_DrawIndexedLogicalOverlay`.
/// @param palette `bytes` value supplied as palette to `MGL_DrawIndexedLogicalOverlay`.
/// @param logicalW `int` value supplied as logical w to `MGL_DrawIndexedLogicalOverlay`.
/// @param logicalH `int` value supplied as logical h to `MGL_DrawIndexedLogicalOverlay`.
/// @param scale `int` value supplied as scale to `MGL_DrawIndexedLogicalOverlay`.
/// @param statusY Vertical coordinate or vector component represented by status y.
/// @param minX Horizontal coordinate or vector component represented by min x.
/// @param minY Vertical coordinate or vector component represented by min y.
/// @param maxX Horizontal coordinate or vector component represented by max x.
/// @param maxY Vertical coordinate or vector component represented by max y.
/// @returns Result returned by the native `MGL_DrawIndexedLogicalOverlay` binding as `bool`.
extern function MGL_DrawIndexedLogicalOverlay(texid as u32, data as bytes, dataSize as int, mask as bytes, maskSize as int, palette as bytes, logicalW as int, logicalH as int, scale as int, statusY as int, minX as int, minY as int, maxX as int, maxY as int) from "libMiniDoomGL.so" returns bool
/// Updates and draws a bounded physical overlay rectangle.
/// @param texid `u32` value supplied as texid to `MGL_DrawIndexedOverlayRect`.
/// @param data Binary or structured data to process.
/// @param dataSize `int` value supplied as data size to `MGL_DrawIndexedOverlayRect`.
/// @param mask `bytes` value supplied as mask to `MGL_DrawIndexedOverlayRect`.
/// @param maskSize `int` value supplied as mask size to `MGL_DrawIndexedOverlayRect`.
/// @param palette `bytes` value supplied as palette to `MGL_DrawIndexedOverlayRect`.
/// @param width Width of the target in pixels or map units.
/// @param height Height of the target in pixels or map units.
/// @param minX Horizontal coordinate or vector component represented by min x.
/// @param minY Vertical coordinate or vector component represented by min y.
/// @param maxX Horizontal coordinate or vector component represented by max x.
/// @param maxY Vertical coordinate or vector component represented by max y.
/// @returns Result returned by the native `MGL_DrawIndexedOverlayRect` binding as `bool`.
extern function MGL_DrawIndexedOverlayRect(texid as u32, data as bytes, dataSize as int, mask as bytes, maskSize as int, palette as bytes, width as int, height as int, minX as int, minY as int, maxX as int, maxY as int) from "libMiniDoomGL.so" returns bool

#endif
