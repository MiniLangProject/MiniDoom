/*
  Copyright 2026 Nils Kopal

  Licensed under the Apache License, Version 2.0 (the "License");
  you may not use this file except in compliance with the License.

  Script: platform_linux.ml
  Purpose: Declares the Linux SDL2/OpenGL compatibility bridge used by the
           otherwise platform-neutral MiniDoom engine modules.
*/

#if TARGET_OS != "linux"
#error "platform_linux.ml may only be compiled for the linux target"
#endif

// Window, input, software presentation, audio, process, and POSIX helpers.
// Prints a fatal-error dialog equivalent to the Linux process error stream.
extern function MessageBoxW(hwnd as ptr, text as cstr, caption as cstr, flags as u32) from "libMiniDoomPlatform.so" symbol "MDL_MessageBoxW" returns int
// Creates the SDL2 window and its compatibility-profile OpenGL context.
extern function CreateWindowExW(exStyle as u32, className as cstr, windowName as cstr, style as u32, x as int, y as int, width as int, height as int, parent as ptr, menu as ptr, instance as ptr, param as ptr) from "libMiniDoomPlatform.so" symbol "MDL_CreateWindowExW" returns ptr
// Accepts Win32-style client sizing because SDL2 receives client dimensions directly.
extern function AdjustWindowRect(rect as bytes, style as u32, hasMenu as bool) from "libMiniDoomPlatform.so" symbol "MDL_AdjustWindowRect" returns bool
// Preserves the engine's show-window lifecycle after SDL has displayed the window.
extern function ShowWindow(hwnd as ptr, cmdShow as int) from "libMiniDoomPlatform.so" symbol "MDL_ShowWindow" returns bool
// Confirms the SDL window is ready for its first presented frame.
extern function UpdateWindow(hwnd as ptr) from "libMiniDoomPlatform.so" symbol "MDL_UpdateWindow" returns bool
// Completes the compatibility repaint contract without a native invalid region.
extern function ValidateRect(hwnd as ptr, rect as ptr) from "libMiniDoomPlatform.so" symbol "MDL_ValidateRect" returns bool
// Releases the SDL audio device, GL context, window, and conversion buffer.
extern function DestroyWindow(hwnd as ptr) from "libMiniDoomPlatform.so" symbol "MDL_DestroyWindow" returns bool
// Returns the SDL window token used as MiniDoom's device-context handle.
extern function GetDC(hwnd as ptr) from "libMiniDoomPlatform.so" symbol "MDL_GetDC" returns ptr
// Completes a borrowed SDL window-token lifetime without destroying it.
extern function ReleaseDC(hwnd as ptr, hdc as ptr) from "libMiniDoomPlatform.so" symbol "MDL_ReleaseDC" returns int
// Writes the current SDL drawable dimensions into a Win32-compatible rectangle.
extern function GetClientRect(hwnd as ptr, rect as bytes) from "libMiniDoomPlatform.so" symbol "MDL_GetClientRect" returns bool
// Pumps SDL events and translates relevant ones into MiniDoom's message record.
extern function PeekMessageW(msg as bytes, hwnd as ptr, minMsg as u32, maxMsg as u32, removeMsg as u32) from "libMiniDoomPlatform.so" symbol "MDL_PeekMessageW" returns bool
// Retains the Win32 message-pump phase expected by the shared video loop.
extern function TranslateMessage(msg as bytes) from "libMiniDoomPlatform.so" symbol "MDL_TranslateMessage" returns bool
// Finishes dispatch of an SDL-derived compatibility message.
extern function DispatchMessageW(msg as bytes) from "libMiniDoomPlatform.so" symbol "MDL_DispatchMessageW" returns ptr
// Returns held and edge-triggered keyboard or mouse-button state in Win32 form.
extern function GetAsyncKeyState(vkey as int) from "libMiniDoomPlatform.so" symbol "MDL_GetAsyncKeyState" returns int
// Updates the SDL window title from the engine's UTF-8 Linux string.
extern function SetWindowTextW(hwnd as ptr, text as cstr) from "libMiniDoomPlatform.so" symbol "MDL_SetWindowTextW" returns bool
// Reports accumulated relative SDL mouse motion through the existing point buffer.
extern function GetCursorPos(point as bytes) from "libMiniDoomPlatform.so" symbol "MDL_GetCursorPos" returns bool
// Returns the game-window token only while SDL reports keyboard input focus.
extern function GetForegroundWindow() from "libMiniDoomPlatform.so" symbol "MDL_GetForegroundWindow" returns ptr
// Synchronizes SDL cursor visibility and relative-mouse capture.
extern function ShowCursor(show as bool) from "libMiniDoomPlatform.so" symbol "MDL_ShowCursor" returns int
// Reads the current SDL display width or height for fullscreen sizing.
extern function GetSystemMetrics(index as int) from "libMiniDoomPlatform.so" symbol "MDL_GetSystemMetrics" returns int
// Applies engine-requested SDL window position and client dimensions.
extern function SetWindowPos(hwnd as ptr, insertAfter as ptr, x as int, y as int, width as int, height as int, flags as u32) from "libMiniDoomPlatform.so" symbol "MDL_SetWindowPos" returns bool
// Supplies a neutral legacy style value because SDL owns window decoration state.
extern function GetWindowLongPtrW(hwnd as ptr, index as int) from "libMiniDoomPlatform.so" symbol "MDL_GetWindowLongPtrW" returns ptr
// Acknowledges a legacy style update while SDL applies size and position separately.
extern function SetWindowLongPtrW(hwnd as ptr, index as int, newLong as ptr) from "libMiniDoomPlatform.so" symbol "MDL_SetWindowLongPtrW" returns ptr
// Raises the SDL window and reports whether the supplied token is valid.
extern function SetForegroundWindow(hwnd as ptr) from "libMiniDoomPlatform.so" symbol "MDL_SetForegroundWindow" returns bool
// Raises the SDL game window to emulate the Win32 z-order request.
extern function BringWindowToTop(hwnd as ptr) from "libMiniDoomPlatform.so" symbol "MDL_BringWindowToTop" returns bool
// Activates and returns the SDL game-window compatibility token.
extern function SetActiveWindow(hwnd as ptr) from "libMiniDoomPlatform.so" symbol "MDL_SetActiveWindow" returns ptr
// Validates that a compatibility window token still refers to the live SDL window.
extern function IsWindow(hwnd as ptr) from "libMiniDoomPlatform.so" symbol "MDL_IsWindow" returns bool
// Expands an indexed software frame through its palette and presents it with OpenGL.
extern function StretchDIBits(hdc as ptr, xDest as int, yDest as int, destWidth as int, destHeight as int, xSrc as int, ySrc as int, srcWidth as int, srcHeight as int, bits as bytes, bmi as bytes, usage as u32, rop as u32) from "libMiniDoomPlatform.so" symbol "MDL_StretchDIBits" returns int
// Preserves the software renderer's requested nearest-neighbor stretch mode.
extern function SetStretchBltMode(hdc as ptr, mode as int) from "libMiniDoomPlatform.so" symbol "MDL_SetStretchBltMode" returns int
// Creates a Linux directory with user-readable and user-writable permissions.
extern function CreateDirectoryW(path as cstr, security as ptr) from "libMiniDoomPlatform.so" symbol "MDL_CreateDirectoryW" returns bool
// Reports that Linux runs without a separate Win32 console-window handle.
extern function GetConsoleWindow() from "libMiniDoomPlatform.so" symbol "MDL_GetConsoleWindow" returns ptr
// Exposes Linux directory creation under the save-system-specific binding name.
extern function G_CreateDirectoryW(path as cstr, security as ptr) from "libMiniDoomPlatform.so" symbol "MDL_CreateDirectoryW" returns bool
// Reads a UTF-8 environment value and writes the UTF-16 buffer expected by save code.
extern function G_GetEnvironmentVariableW(name as cstr, buffer as bytes, size as int) from "libMiniDoomPlatform.so" symbol "MDL_GetEnvironmentVariableW" returns int

// Returns wrapping monotonic milliseconds for Doom's platform tick clock.
extern function GetTickCount() from "libMiniDoomPlatform.so" symbol "MDL_GetTickCount" returns u32
// Suspends the current Linux thread for the requested millisecond duration.
extern function Sleep(ms as int) from "libMiniDoomPlatform.so" symbol "MDL_Sleep" returns int
// Terminates MiniDoom immediately with the supplied process exit code.
extern function ExitProcess(code as int) from "libMiniDoomPlatform.so" symbol "MDL_ExitProcess" returns int
// Converts the engine's nonblocking-socket request into POSIX fcntl flags.
extern function ioctlsocket(s as ptr, cmd as i32, argp as bytes) from "libMiniDoomPlatform.so" symbol "MDL_ioctlsocket" returns int
// Translates WinSock timeout constants before applying the POSIX socket option.
extern function setsockopt(s as ptr, level as int, optname as int, optval as bytes, optlen as int) from "libMiniDoomPlatform.so" symbol "MDL_setsockopt" returns int

// Opens an SDL queued-audio device from MiniDoom's PCM format record.
extern function waveOutOpen(phwo as bytes, dev as u32, pwfx as bytes, cb as ptr, inst as ptr, flags as u32) from "libMiniDoomPlatform.so" symbol "MDL_waveOutOpen" returns u32
// Accepts a wave buffer for compatibility with the WinMM preparation phase.
extern function waveOutPrepareHeader(hwo as ptr, pwh as ptr, cbwh as u32) from "libMiniDoomPlatform.so" symbol "MDL_waveOutPrepareHeader" returns u32
// Queues one mixed PCM buffer on SDL and tracks its eventual completion flag.
extern function waveOutWrite(hwo as ptr, pwh as ptr, cbwh as u32) from "libMiniDoomPlatform.so" symbol "MDL_waveOutWrite" returns u32
// Completes the WinMM-style buffer lifecycle after SDL has consumed its samples.
extern function waveOutUnprepareHeader(hwo as ptr, pwh as ptr, cbwh as u32) from "libMiniDoomPlatform.so" symbol "MDL_waveOutUnprepareHeader" returns u32
// Clears queued SDL samples and marks every pending wave buffer complete.
extern function waveOutReset(hwo as ptr) from "libMiniDoomPlatform.so" symbol "MDL_waveOutReset" returns u32
// Resets and closes MiniDoom's SDL queued-audio device.
extern function waveOutClose(hwo as ptr) from "libMiniDoomPlatform.so" symbol "MDL_waveOutClose" returns u32
// Opens the intentionally silent Linux MIDI compatibility endpoint.
extern function midiOutOpen(phmo as bytes, dev as u32, cb as ptr, inst as ptr, flags as u32) from "libMiniDoomPlatform.so" symbol "MDL_midiOutOpen" returns u32
// Accepts a sequencer MIDI message while no Linux synthesizer is configured.
extern function midiOutShortMsg(hmo as ptr, msg as u32) from "libMiniDoomPlatform.so" symbol "MDL_midiOutShortMsg" returns u32
// Resets the silent Linux MIDI compatibility endpoint.
extern function midiOutReset(hmo as ptr) from "libMiniDoomPlatform.so" symbol "MDL_midiOutReset" returns u32
// Closes the silent Linux MIDI compatibility endpoint.
extern function midiOutClose(hmo as ptr) from "libMiniDoomPlatform.so" symbol "MDL_midiOutClose" returns u32
// Records a music-volume update without requiring a system MIDI service.
extern function midiOutSetVolume(hmo as ptr, vol as u32) from "libMiniDoomPlatform.so" symbol "MDL_midiOutSetVolume" returns u32
// Allocates unmanaged storage for the queued-audio buffers and headers.
extern function GlobalAlloc(flags as u32, size as u32) from "libc.so.6" symbol "malloc" returns ptr
// Releases unmanaged queued-audio storage through the C runtime allocator.
extern function GlobalFree(mem as ptr) from "libc.so.6" symbol "free" returns ptr
// Copies MiniLang-managed audio bytes into an unmanaged buffer.
extern function RtlMoveMemoryToPtr(dst as ptr, src as bytes, len as u32) from "libc.so.6" symbol "memmove" returns void
// Refreshes SDL completion flags before copying an unmanaged wave header back.
extern function RtlMoveMemoryFromPtr(dst as bytes, src as ptr, len as u32) from "libMiniDoomPlatform.so" symbol "MDL_RtlMoveMemoryFromPtr" returns void

// SDL owns the GL context; these compatibility calls retain the renderer API.
// Confirms the SDL-created framebuffer format is available to the renderer.
extern function ChoosePixelFormat(hdc as ptr, pfd as bytes) from "libMiniDoomPlatform.so" symbol "MDL_ChoosePixelFormat" returns int
// Accepts the already-fixed SDL framebuffer format for shared WGL-style setup.
extern function SetPixelFormat(hdc as ptr, format as int, pfd as bytes) from "libMiniDoomPlatform.so" symbol "MDL_SetPixelFormat" returns bool
// Presents the current back buffer through SDL_GL_SwapWindow.
extern function SwapBuffers(hdc as ptr) from "libMiniDoomPlatform.so" symbol "MDL_SwapBuffers" returns bool
// Returns the OpenGL context created together with the SDL game window.
extern function wglCreateContext(hdc as ptr) from "libMiniDoomPlatform.so" symbol "MDL_GLCreateContext" returns ptr
// Makes or clears SDL's current OpenGL context for the calling thread.
extern function wglMakeCurrent(hdc as ptr, hglrc as ptr) from "libMiniDoomPlatform.so" symbol "MDL_GLMakeCurrent" returns bool
// Deletes the SDL-owned compatibility-profile OpenGL context.
extern function wglDeleteContext(hglrc as ptr) from "libMiniDoomPlatform.so" symbol "MDL_GLDeleteContext" returns bool

// Legacy OpenGL 2.1 entry points used by MiniDoom's compatibility renderer.
// Selects the drawable rectangle used for the current MiniDoom frame.
extern function glViewport(x as int, y as int, width as int, height as int) from "libGL.so.1" returns void
// Clears the selected OpenGL color or depth buffers.
extern function glClear(mask as u32) from "libGL.so.1" returns void
// Sets the depth value written by depth-buffer clear operations.
extern function glClearDepth(depth as double) from "libGL.so.1" returns void
// Enables a legacy OpenGL render capability.
extern function glEnable(cap as u32) from "libGL.so.1" returns void
// Disables a legacy OpenGL render capability.
extern function glDisable(cap as u32) from "libGL.so.1" returns void
// Controls whether rendered fragments update the depth buffer.
extern function glDepthMask(flag as bool) from "libGL.so.1" returns void
// Selects the framebuffer color channels writable by subsequent draws.
extern function glColorMask(red as bool, green as bool, blue as bool, alpha as bool) from "libGL.so.1" returns void
// Chooses the depth comparison used for world geometry.
extern function glDepthFunc(func as u32) from "libGL.so.1" returns void
// Selects the projection or model-view matrix stack.
extern function glMatrixMode(mode as u32) from "libGL.so.1" returns void
// Resets the selected legacy matrix to identity.
extern function glLoadIdentity() from "libGL.so.1" returns void
// Builds MiniDoom's perspective projection frustum.
extern function glFrustum(left as double, right as double, bottom as double, top as double, zNear as double, zFar as double) from "libGL.so.1" returns void
// Applies a double-precision rotation to the selected matrix.
extern function glRotated(angle as double, x as double, y as double, z as double) from "libGL.so.1" returns void
// Applies a double-precision translation to the selected matrix.
extern function glTranslated(x as double, y as double, z as double) from "libGL.so.1" returns void
// Applies a double-precision scale to the selected matrix.
extern function glScaled(x as double, y as double, z as double) from "libGL.so.1" returns void
// Saves the current matrix before a localized world transform.
extern function glPushMatrix() from "libGL.so.1" returns void
// Restores the matrix saved for a localized world transform.
extern function glPopMatrix() from "libGL.so.1" returns void
// Begins immediate-mode emission for the requested primitive kind.
extern function glBegin(mode as u32) from "libGL.so.1" returns void
// Completes the current immediate-mode primitive sequence.
extern function glEnd() from "libGL.so.1" returns void
// Allocates consecutive display-list identifiers for static map geometry.
extern function glGenLists(range as int) from "libGL.so.1" returns u32
// Starts compiling one static-geometry display list.
extern function glNewList(list as u32, mode as u32) from "libGL.so.1" returns void
// Finishes compilation of the active display list.
extern function glEndList() from "libGL.so.1" returns void
// Replays a compiled display list for static geometry.
extern function glCallList(list as u32) from "libGL.so.1" returns void
// Releases a range of static-geometry display lists.
extern function glDeleteLists(list as u32, range as int) from "libGL.so.1" returns void
// Enables one legacy vertex-array attribute stream.
extern function glEnableClientState(array as u32) from "libGL.so.1" returns void
// Disables one legacy vertex-array attribute stream.
extern function glDisableClientState(array as u32) from "libGL.so.1" returns void
// Describes the packed position stream for an array draw.
extern function glVertexPointer(size as int, typ as u32, stride as int, pointer as bytes) from "libGL.so.1" returns void
// Describes the packed texture-coordinate stream for an array draw.
extern function glTexCoordPointer(size as int, typ as u32, stride as int, pointer as bytes) from "libGL.so.1" returns void
// Describes the packed light-color stream for an array draw.
extern function glColorPointer(size as int, typ as u32, stride as int, pointer as bytes) from "libGL.so.1" returns void
// Draws consecutive vertices from the configured client arrays.
extern function glDrawArrays(mode as u32, first as int, count as int) from "libGL.so.1" returns void
// Emits one double-precision immediate-mode world position.
extern function glVertex3d(x as double, y as double, z as double) from "libGL.so.1" returns void
// Emits one double-precision immediate-mode texture coordinate.
extern function glTexCoord2d(s as double, t as double) from "libGL.so.1" returns void
// Sets an opaque unsigned-byte vertex color for sector lighting.
extern function glColor3ub(r as int, g as int, b as int) from "libGL.so.1" returns void
// Sets an unsigned-byte vertex color including sprite or overlay alpha.
extern function glColor4ub(r as int, g as int, b as int, a as int) from "libGL.so.1" returns void
// Selects source and destination factors for translucent surfaces.
extern function glBlendFunc(sfactor as u32, dfactor as u32) from "libGL.so.1" returns void
// Sets the cutout threshold applied to masked Doom texels.
extern function glAlphaFunc(func as u32, ref as double) from "libGL.so.1" returns void
// Allocates texture identifiers for palette-expanded Doom images.
extern function glGenTextures(n as int, textures as bytes) from "libGL.so.1" returns void
// Selects the texture consumed by subsequent world or sprite draws.
extern function glBindTexture(target as u32, texture as u32) from "libGL.so.1" returns void
// Configures filtering and wrapping for the selected texture.
extern function glTexParameteri(target as u32, pname as u32, param as int) from "libGL.so.1" returns void
// Uploads a palette-expanded RGBA image into the selected texture.
extern function glTexImage2D(target as u32, level as int, internalFormat as int, width as int, height as int, border as int, format as u32, typ as u32, pixels as bytes) from "libGL.so.1" returns void
// Configures byte alignment for texture uploads or framebuffer reads.
extern function glPixelStorei(pname as u32, param as int) from "libGL.so.1" returns void
// Copies the rendered framebuffer into MiniLang-managed screenshot bytes.
extern function glReadPixels(x as int, y as int, width as int, height as int, format as u32, typ as u32, pixels as bytes) from "libGL.so.1" returns void
// Selects the front or back framebuffer used by a screenshot read.
extern function glReadBuffer(mode as u32) from "libGL.so.1" returns void

// Performance helper compiled from tools/minidoom_gl_helper.c for Linux.
// Resolves buffer-object functions for the active Linux OpenGL context.
extern function MGL_InitVBO() from "libMiniDoomGL.so" returns bool
// Applies SDL's vertical-sync interval to the active game window.
extern function MGL_SetSwapInterval(interval as int) from "libMiniDoomPlatform.so" symbol "MDL_GLSetSwapInterval" returns bool
// Returns a monotonic microsecond timestamp for renderer profiling.
extern function MGL_TimeMicroseconds() from "libMiniDoomGL.so" returns i64
// Sleeps and yields until the next configured frame deadline.
extern function MGL_FramePace(targetFps as int, leadUs as int) from "libMiniDoomGL.so" returns void
// Advances the native frame-pacing deadline after a successful swap.
extern function MGL_FramePaceMark() from "libMiniDoomGL.so" returns void
// Rasterizes one software column with native bounds and palette checks.
extern function MGL_RasterColumn8(dest as bytes, destBytes as int, destIndex as int, destStride as int, count as int, source as bytes, sourceBytes as int, sourceOffset as int, sourceLength as int, colormap as bytes, colormapLength as int, frac as int, fracStep as int, sourceClamp as int) from "libMiniDoomGL.so" returns bool
// Rasterizes one software span with native texture wrapping and colormapping.
extern function MGL_RasterSpan8(dest as bytes, destBytes as int, destIndex as int, count as int, source as bytes, sourceBytes as int, colormap as bytes, colormapLength as int, sourceWidth as int, sourceHeight as int, xFrac as int, yFrac as int, xStep as int, yStep as int) from "libMiniDoomGL.so" returns bool
// Expands indexed pixels to RGBA for fast overlay texture uploads.
extern function MGL_ExpandIndexed8(source as bytes, sourceBytes as int, dest as bytes, destBytes as int, palette as bytes, paletteBytes as int, pixels as int) from "libMiniDoomGL.so" returns bool
// Uploads one raw vertex attribute stream into an OpenGL array buffer.
extern function MGL_CreateArrayBuffer(data as bytes, size as int) from "libMiniDoomGL.so" returns u32
// Uploads packed position, UV, and light data into one geometry buffer.
extern function MGL_CreateInterleavedGeomBuffer(data as bytes, size as int) from "libMiniDoomGL.so" returns u32
// Releases a native OpenGL array-buffer identifier.
extern function MGL_DeleteArrayBuffer(id as u32) from "libMiniDoomGL.so" returns void
// Draws a batch backed by separate position, UV, and color buffers.
extern function MGL_DrawArrayBatch(mode as u32, vertexBuffer as u32, texcoordBuffer as u32, colorBuffer as u32, count as int) from "libMiniDoomGL.so" returns void
// Draws one batch from MiniDoom's packed static-geometry buffer.
extern function MGL_DrawInterleavedBatch(mode as u32, buffer as u32, count as int) from "libMiniDoomGL.so" returns void
// Frustum-culls and draws visible packed map-geometry batch records.
extern function MGL_DrawVisibleGeomBatches(mode as u32, records as bytes, recordCount as int, viewX as double, viewY as double, viewYaw as double) from "libMiniDoomGL.so" returns bool
// Accumulates dynamic-light contributions across packed map surfaces.
extern function MGL_DrawDynamicLightSurfaces(geomData as bytes, geomSize as int, lightData as bytes, lightCount as int) from "libMiniDoomGL.so" returns bool
// Initializes native sprite batching with camera and dynamic-light state.
extern function MGL_BeginSpriteBatch(lightData as bytes, lightCount as int, viewX as double, viewY as double, rightX as double, rightZ as double, worldScale as double, footLift as double) from "libMiniDoomGL.so" returns bool
// Appends one world sprite to the active native batch.
extern function MGL_SubmitSprite(texid as u32, flags as int, baseLight as int, fixedX as int, fixedY as int, fixedZ as int, width as int, height as int, yOffset as int) from "libMiniDoomGL.so" returns void
// Decodes and draws packed sprite records in one native call.
extern function MGL_DrawSpriteRecords(records as bytes, recordsSize as int, recordCount as int) from "libMiniDoomGL.so" returns bool
// Flushes queued native sprites in texture-compatible groups.
extern function MGL_EndSpriteBatch() from "libMiniDoomGL.so" returns void
// Reports the number of geometry batches drawn by the latest culling pass.
extern function MGL_GetLastDrawnBatches() from "libMiniDoomGL.so" returns int
// Reports the number of vertices drawn by the latest culling pass.
extern function MGL_GetLastDrawnVertices() from "libMiniDoomGL.so" returns int
// Draws a full indexed HUD or console overlay with optional transparency mask.
extern function MGL_DrawIndexedOverlay(texid as u32, data as bytes, mask as bytes, palette as bytes, width as int, height as int) from "libMiniDoomGL.so" returns bool
// Updates and draws the dirty logical overlay region at the active render scale.
extern function MGL_DrawIndexedLogicalOverlay(texid as u32, data as bytes, dataSize as int, mask as bytes, maskSize as int, palette as bytes, logicalW as int, logicalH as int, scale as int, statusY as int, minX as int, minY as int, maxX as int, maxY as int) from "libMiniDoomGL.so" returns bool
// Updates and draws a bounded physical overlay rectangle.
extern function MGL_DrawIndexedOverlayRect(texid as u32, data as bytes, dataSize as int, mask as bytes, maskSize as int, palette as bytes, width as int, height as int, minX as int, minY as int, maxX as int, maxY as int) from "libMiniDoomGL.so" returns bool
