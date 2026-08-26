/*
 * Copyright 2026 Nils Kopal
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 *
 * Purpose: Small Linux x64 bridge for MiniDoom. SDL2 is resolved at runtime
 * so building the project only requires GCC and the ordinary SDL2 runtime.
 */

#define _GNU_SOURCE
#include <dlfcn.h>
#include <errno.h>
#include <fcntl.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/socket.h>
#include <sys/stat.h>
#include <time.h>
#include <unistd.h>

#define MDL_EXPORT __attribute__((visibility("default")))

/* Opaque SDL window type used without requiring development headers. */
typedef struct SDL_Window SDL_Window;
typedef void *SDL_GLContext;
typedef uint32_t SDL_AudioDeviceID;

/* ABI-compatible subset of SDL_AudioSpec needed for queued stereo PCM. */
typedef struct SDL_AudioSpec {
  int freq;
  uint16_t format;
  uint8_t channels;
  uint8_t silence;
  uint16_t samples;
  uint16_t padding;
  uint32_t size;
  void *callback;
  void *userdata;
} SDL_AudioSpec;

/* SDL's fixed-size event storage; individual fields are read by ABI offset. */
typedef union SDL_Event {
  uint32_t type;
  uint8_t padding[56];
} SDL_Event;

/* ABI-compatible display-mode fields used to discover desktop dimensions. */
typedef struct SDL_DisplayMode {
  uint32_t format;
  int w;
  int h;
  int refresh_rate;
  void *driverdata;
} SDL_DisplayMode;

enum {
  SDL_INIT_TIMER = 0x00000001,
  SDL_INIT_AUDIO = 0x00000010,
  SDL_INIT_VIDEO = 0x00000020,
  SDL_INIT_EVENTS = 0x00004000,
  SDL_WINDOW_FULLSCREEN = 0x00000001,
  SDL_WINDOW_OPENGL = 0x00000002,
  SDL_WINDOW_SHOWN = 0x00000004,
  SDL_WINDOW_RESIZABLE = 0x00000020,
  SDL_WINDOW_INPUT_FOCUS = 0x00000200,
  SDL_WINDOW_FULLSCREEN_DESKTOP = SDL_WINDOW_FULLSCREEN | 0x00001000,
  SDL_WINDOWPOS_CENTERED = 0x2FFF0000,
  SDL_QUIT = 0x100,
  SDL_WINDOWEVENT = 0x200,
  SDL_KEYDOWN = 0x300,
  SDL_KEYUP = 0x301,
  SDL_MOUSEMOTION = 0x400,
  SDL_MOUSEBUTTONDOWN = 0x401,
  SDL_MOUSEBUTTONUP = 0x402,
  SDL_WINDOWEVENT_FOCUS_GAINED = 12,
  SDL_WINDOWEVENT_FOCUS_LOST = 13,
  SDL_WINDOWEVENT_CLOSE = 14,
  SDL_GL_RED_SIZE = 0,
  SDL_GL_GREEN_SIZE = 1,
  SDL_GL_BLUE_SIZE = 2,
  SDL_GL_ALPHA_SIZE = 3,
  SDL_GL_DOUBLEBUFFER = 5,
  SDL_GL_DEPTH_SIZE = 6,
  SDL_GL_CONTEXT_MAJOR_VERSION = 17,
  SDL_GL_CONTEXT_MINOR_VERSION = 18,
  SDL_GL_CONTEXT_PROFILE_MASK = 21,
  SDL_GL_CONTEXT_PROFILE_COMPATIBILITY = 0x0002,
  AUDIO_S16LSB = 0x8010
};

enum {
  WM_DESTROY = 0x0002,
  WM_CLOSE = 0x0010,
  WM_QUIT = 0x0012,
  WM_KEYDOWN = 0x0100,
  WM_KEYUP = 0x0101
};

enum {
  GL_COLOR_BUFFER_BIT = 0x00004000,
  GL_DEPTH_TEST = 0x0B71,
  GL_BLEND = 0x0BE2,
  GL_TEXTURE_2D = 0x0DE1,
  GL_PROJECTION = 0x1701,
  GL_MODELVIEW = 0x1700,
  GL_RGBA = 0x1908,
  GL_UNSIGNED_BYTE = 0x1401,
  GL_UNPACK_ALIGNMENT = 0x0CF5
};

static void *g_sdl;
static void *g_gl;
static SDL_Window *g_window;
static SDL_GLContext g_context;
static SDL_AudioDeviceID g_audio;
static uint8_t g_keys[256];
static uint8_t g_pressed[256];
static int g_mouse_x;
static int g_mouse_y;
static int g_mouse_buttons;
static int g_has_focus = 1;
static uint8_t *g_rgba;
static size_t g_rgba_capacity;

/* Marks queued wave headers complete according to SDL's remaining byte count. */
static void mdl_audio_refresh(void);

static int (*pSDL_Init)(uint32_t);
static void (*pSDL_Quit)(void);
static const char *(*pSDL_GetError)(void);
static int (*pSDL_GL_SetAttribute)(int, int);
static SDL_Window *(*pSDL_CreateWindow)(const char *, int, int, int, int, uint32_t);
static void (*pSDL_DestroyWindow)(SDL_Window *);
static SDL_GLContext (*pSDL_GL_CreateContext)(SDL_Window *);
static int (*pSDL_GL_MakeCurrent)(SDL_Window *, SDL_GLContext);
static void (*pSDL_GL_DeleteContext)(SDL_GLContext);
static void (*pSDL_GL_SwapWindow)(SDL_Window *);
static int (*pSDL_GL_SetSwapInterval)(int);
static void (*pSDL_GL_GetDrawableSize)(SDL_Window *, int *, int *);
static int (*pSDL_PollEvent)(SDL_Event *);
static void (*pSDL_SetWindowTitle)(SDL_Window *, const char *);
static void (*pSDL_GetWindowSize)(SDL_Window *, int *, int *);
static void (*pSDL_SetWindowSize)(SDL_Window *, int, int);
static void (*pSDL_SetWindowPosition)(SDL_Window *, int, int);
static int (*pSDL_SetWindowFullscreen)(SDL_Window *, uint32_t);
static uint32_t (*pSDL_GetWindowFlags)(SDL_Window *);
static void (*pSDL_RaiseWindow)(SDL_Window *);
static int (*pSDL_ShowCursor)(int);
static int (*pSDL_SetRelativeMouseMode)(int);
static int (*pSDL_GetCurrentDisplayMode)(int, SDL_DisplayMode *);
static SDL_AudioDeviceID (*pSDL_OpenAudioDevice)(const char *, int, const SDL_AudioSpec *, SDL_AudioSpec *, int);
static void (*pSDL_CloseAudioDevice)(SDL_AudioDeviceID);
static void (*pSDL_PauseAudioDevice)(SDL_AudioDeviceID, int);
static int (*pSDL_QueueAudio)(SDL_AudioDeviceID, const void *, uint32_t);
static uint32_t (*pSDL_GetQueuedAudioSize)(SDL_AudioDeviceID);
static void (*pSDL_ClearQueuedAudio)(SDL_AudioDeviceID);

static void (*pglViewport)(int, int, int, int);
static void (*pglDisable)(uint32_t);
static void (*pglMatrixMode)(uint32_t);
static void (*pglLoadIdentity)(void);
static void (*pglRasterPos2f)(float, float);
static void (*pglPixelZoom)(float, float);
static void (*pglDrawPixels)(int, int, uint32_t, uint32_t, const void *);
static void (*pglPixelStorei)(uint32_t, int);
static void (*pglClear)(uint32_t);

/* Resolves one required runtime symbol and emits a precise missing-symbol error. */
static void *mdl_symbol(void *library, const char *name) {
  void *symbol = library ? dlsym(library, name) : NULL;
  if (!symbol) fprintf(stderr, "MiniDoom Linux: missing native symbol %s\n", name);
  return symbol;
}

#define LOAD_SDL(name) p##name = (void *)mdl_symbol(g_sdl, #name)
#define LOAD_GL(name) p##name = (void *)mdl_symbol(g_gl, #name)

/* Loads the SDL2/OpenGL runtimes and every entry point used by the bridge. */
static int mdl_load_libraries(void) {
  if (g_sdl && g_gl) return 1;
  g_sdl = dlopen("libSDL2-2.0.so.0", RTLD_NOW | RTLD_LOCAL);
  if (!g_sdl) {
    fprintf(stderr, "MiniDoom Linux: cannot load libSDL2-2.0.so.0: %s\n", dlerror());
    return 0;
  }
  g_gl = dlopen("libGL.so.1", RTLD_NOW | RTLD_GLOBAL);
  if (!g_gl) {
    fprintf(stderr, "MiniDoom Linux: cannot load libGL.so.1: %s\n", dlerror());
    return 0;
  }

  LOAD_SDL(SDL_Init);
  LOAD_SDL(SDL_Quit);
  LOAD_SDL(SDL_GetError);
  LOAD_SDL(SDL_GL_SetAttribute);
  LOAD_SDL(SDL_CreateWindow);
  LOAD_SDL(SDL_DestroyWindow);
  LOAD_SDL(SDL_GL_CreateContext);
  LOAD_SDL(SDL_GL_MakeCurrent);
  LOAD_SDL(SDL_GL_DeleteContext);
  LOAD_SDL(SDL_GL_SwapWindow);
  LOAD_SDL(SDL_GL_SetSwapInterval);
  LOAD_SDL(SDL_GL_GetDrawableSize);
  LOAD_SDL(SDL_PollEvent);
  LOAD_SDL(SDL_SetWindowTitle);
  LOAD_SDL(SDL_GetWindowSize);
  LOAD_SDL(SDL_SetWindowSize);
  LOAD_SDL(SDL_SetWindowPosition);
  LOAD_SDL(SDL_SetWindowFullscreen);
  LOAD_SDL(SDL_GetWindowFlags);
  LOAD_SDL(SDL_RaiseWindow);
  LOAD_SDL(SDL_ShowCursor);
  LOAD_SDL(SDL_SetRelativeMouseMode);
  LOAD_SDL(SDL_GetCurrentDisplayMode);
  LOAD_SDL(SDL_OpenAudioDevice);
  LOAD_SDL(SDL_CloseAudioDevice);
  LOAD_SDL(SDL_PauseAudioDevice);
  LOAD_SDL(SDL_QueueAudio);
  LOAD_SDL(SDL_GetQueuedAudioSize);
  LOAD_SDL(SDL_ClearQueuedAudio);

  LOAD_GL(glViewport);
  LOAD_GL(glDisable);
  LOAD_GL(glMatrixMode);
  LOAD_GL(glLoadIdentity);
  LOAD_GL(glRasterPos2f);
  LOAD_GL(glPixelZoom);
  LOAD_GL(glDrawPixels);
  LOAD_GL(glPixelStorei);
  LOAD_GL(glClear);

  return pSDL_Init && pSDL_CreateWindow && pSDL_GL_CreateContext &&
         pSDL_GL_MakeCurrent && pSDL_GL_SwapWindow && pSDL_PollEvent &&
         pglViewport && pglDrawPixels;
}

/* Writes a native little-endian signed field into a MiniLang record buffer. */
static void mdl_write_i32(void *buffer, size_t offset, int32_t value) {
  if (buffer) memcpy((uint8_t *)buffer + offset, &value, sizeof(value));
}

/* Writes a native little-endian pointer-sized field into a record buffer. */
static void mdl_write_u64(void *buffer, size_t offset, uint64_t value) {
  if (buffer) memcpy((uint8_t *)buffer + offset, &value, sizeof(value));
}

/* Reads a signed 32-bit field without assuming caller-buffer alignment. */
static int32_t mdl_read_i32(const void *buffer, size_t offset) {
  int32_t value = 0;
  if (buffer) memcpy(&value, (const uint8_t *)buffer + offset, sizeof(value));
  return value;
}

/* Reads a 64-bit pointer or counter without assuming caller-buffer alignment. */
static uint64_t mdl_read_u64(const void *buffer, size_t offset) {
  uint64_t value = 0;
  if (buffer) memcpy(&value, (const uint8_t *)buffer + offset, sizeof(value));
  return value;
}

/* Converts Linux environment text into the UTF-16 buffer expected by save code. */
static int mdl_utf8_to_utf16(const char *input, uint16_t *output, int capacity) {
  int used = 0;
  const unsigned char *p = (const unsigned char *)input;
  if (!output || capacity <= 0) return 0;
  while (p && *p && used + 1 < capacity) {
    uint32_t cp;
    if (*p < 0x80) {
      cp = *p++;
    } else if ((*p & 0xE0) == 0xC0 && p[1]) {
      cp = ((p[0] & 0x1F) << 6) | (p[1] & 0x3F);
      p += 2;
    } else if ((*p & 0xF0) == 0xE0 && p[1] && p[2]) {
      cp = ((p[0] & 0x0F) << 12) | ((p[1] & 0x3F) << 6) | (p[2] & 0x3F);
      p += 3;
    } else {
      ++p;
      cp = '?';
    }
    if (cp <= 0xFFFF) output[used++] = (uint16_t)cp;
  }
  output[used] = 0;
  return used;
}

/* Maps SDL keycodes/scancodes to the Win32 virtual keys used by shared input code. */
static int mdl_keycode_to_vk(int32_t keycode) {
  const int32_t mask = 1 << 30;
  int scancode = keycode & ~mask;
  if (keycode >= 'a' && keycode <= 'z') return keycode - 'a' + 'A';
  if (keycode >= 'A' && keycode <= 'Z') return keycode;
  if (keycode >= '0' && keycode <= '9') return keycode;
  switch (keycode) {
    case 8: return 0x08;
    case 9: return 0x09;
    case 13: return 0x0D;
    case 27: return 0x1B;
    case 32: return 0x20;
    case '-': return 0xBD;
    case '=': case '+': return 0xBB;
    case ',': return 0xBC;
    case '.': return 0xBE;
    case '`': case '~': return 0xC0;
    case ';': case 0xF6: case 0xD6: return 0xBA;
    case '\\': case '^': return 0xDC;
    default: break;
  }
  if ((keycode & mask) == 0) return 0;
  switch (scancode) {
    case 79: return 0x27;
    case 80: return 0x25;
    case 81: return 0x28;
    case 82: return 0x26;
    case 75: return 0x21;
    case 78: return 0x22;
    case 72: return 0x13;
    case 224: case 228: return 0x11;
    case 225: case 229: return 0x10;
    case 226: case 230: return 0x12;
    case 99: return 0x6E;
    default: break;
  }
  if (scancode >= 58 && scancode <= 69) return 0x70 + scancode - 58;
  if (scancode >= 89 && scancode <= 97) return 0x61 + scancode - 89;
  if (scancode == 98) return 0x60;
  return 0;
}

/* Updates held-key state and remembers a single press edge for async polling. */
static void mdl_set_key(int vk, int down) {
  if (vk <= 0 || vk >= 256) return;
  if (down && !g_keys[vk]) g_pressed[vk] = 1;
  g_keys[vk] = down ? 1 : 0;
}

/* Applies one SDL event and optionally emits a Win32-shaped engine message. */
static int mdl_event_message(SDL_Event *event, void *msg) {
  uint32_t type = event->type;
  uint32_t out_type = 0;
  uint64_t wparam = 0;
  if (type == SDL_QUIT) {
    out_type = WM_QUIT;
  } else if (type == SDL_WINDOWEVENT) {
    uint8_t subtype = event->padding[12];
    if (subtype == SDL_WINDOWEVENT_CLOSE) out_type = WM_CLOSE;
    if (subtype == SDL_WINDOWEVENT_FOCUS_GAINED) g_has_focus = 1;
    if (subtype == SDL_WINDOWEVENT_FOCUS_LOST) {
      g_has_focus = 0;
      memset(g_keys, 0, sizeof(g_keys));
    }
  } else if (type == SDL_KEYDOWN || type == SDL_KEYUP) {
    int32_t keycode = mdl_read_i32(event->padding, 20);
    int vk = mdl_keycode_to_vk(keycode);
    mdl_set_key(vk, type == SDL_KEYDOWN);
    if (vk) {
      out_type = type == SDL_KEYDOWN ? WM_KEYDOWN : WM_KEYUP;
      wparam = (uint64_t)vk;
    }
  } else if (type == SDL_MOUSEMOTION) {
    g_mouse_x += mdl_read_i32(event->padding, 28);
    g_mouse_y += mdl_read_i32(event->padding, 32);
  } else if (type == SDL_MOUSEBUTTONDOWN || type == SDL_MOUSEBUTTONUP) {
    int button = event->padding[13];
    int bit = button == 1 ? 1 : (button == 3 ? 2 : (button == 2 ? 4 : 0));
    if (type == SDL_MOUSEBUTTONDOWN) g_mouse_buttons |= bit;
    else g_mouse_buttons &= ~bit;
  }
  if (!out_type || !msg) return 0;
  memset(msg, 0, 56);
  mdl_write_i32(msg, 8, (int32_t)out_type);
  mdl_write_u64(msg, 16, wparam);
  return 1;
}

/* Writes a GUI-style fatal diagnostic to stderr on Linux. */
MDL_EXPORT int MDL_MessageBoxW(void *hwnd, const char *text, const char *caption, uint32_t flags) {
  (void)hwnd; (void)flags;
  fprintf(stderr, "%s: %s\n", caption && caption[0] ? caption : "MiniDoom", text ? text : "");
  return 1;
}

/* Creates MiniDoom's SDL window and OpenGL 2.1 compatibility context. */
MDL_EXPORT void *MDL_CreateWindowExW(uint32_t ex_style, const char *class_name,
                                     const char *window_name, uint32_t style,
                                     int x, int y, int width, int height,
                                     void *parent, void *menu, void *instance, void *param) {
  char title[512];
  uint32_t flags = SDL_WINDOW_OPENGL | SDL_WINDOW_SHOWN | SDL_WINDOW_RESIZABLE;
  (void)ex_style; (void)class_name; (void)parent; (void)menu; (void)instance; (void)param;
  if (!mdl_load_libraries()) return NULL;
  if (pSDL_Init(SDL_INIT_TIMER | SDL_INIT_AUDIO | SDL_INIT_VIDEO | SDL_INIT_EVENTS) != 0) {
    fprintf(stderr, "MiniDoom Linux: SDL_Init failed: %s\n", pSDL_GetError ? pSDL_GetError() : "unknown");
    return NULL;
  }
  pSDL_GL_SetAttribute(SDL_GL_RED_SIZE, 8);
  pSDL_GL_SetAttribute(SDL_GL_GREEN_SIZE, 8);
  pSDL_GL_SetAttribute(SDL_GL_BLUE_SIZE, 8);
  pSDL_GL_SetAttribute(SDL_GL_ALPHA_SIZE, 8);
  pSDL_GL_SetAttribute(SDL_GL_DEPTH_SIZE, 24);
  pSDL_GL_SetAttribute(SDL_GL_DOUBLEBUFFER, 1);
  pSDL_GL_SetAttribute(SDL_GL_CONTEXT_MAJOR_VERSION, 2);
  pSDL_GL_SetAttribute(SDL_GL_CONTEXT_MINOR_VERSION, 1);
  pSDL_GL_SetAttribute(SDL_GL_CONTEXT_PROFILE_MASK, SDL_GL_CONTEXT_PROFILE_COMPATIBILITY);
  snprintf(title, sizeof(title), "%s", window_name ? window_name : "");
  if (!title[0]) strcpy(title, "MiniDoom");
  if ((int32_t)style < 0) flags |= SDL_WINDOW_FULLSCREEN_DESKTOP;
  if (width <= 0) width = 640;
  if (height <= 0) height = 400;
  if (x < 0) x = SDL_WINDOWPOS_CENTERED;
  if (y < 0) y = SDL_WINDOWPOS_CENTERED;
  g_window = pSDL_CreateWindow(title, x, y, width, height, flags);
  if (!g_window) {
    fprintf(stderr, "MiniDoom Linux: SDL_CreateWindow failed: %s\n", pSDL_GetError());
    return NULL;
  }
  g_context = pSDL_GL_CreateContext(g_window);
  if (!g_context || pSDL_GL_MakeCurrent(g_window, g_context) != 0) {
    fprintf(stderr, "MiniDoom Linux: SDL OpenGL context failed: %s\n", pSDL_GetError());
    pSDL_DestroyWindow(g_window);
    g_window = NULL;
    return NULL;
  }
  g_has_focus = 1;
  return g_window;
}

/* Accepts client sizing unchanged because SDL works in client dimensions. */
MDL_EXPORT int MDL_AdjustWindowRect(void *rect, uint32_t style, int has_menu) {
  (void)rect; (void)style; (void)has_menu;
  return 1;
}
/* Confirms the SDL-created window is already visible. */
MDL_EXPORT int MDL_ShowWindow(void *hwnd, int cmd) { (void)hwnd; (void)cmd; return 1; }
/* Confirms no separate native repaint request is required. */
MDL_EXPORT int MDL_UpdateWindow(void *hwnd) { (void)hwnd; return 1; }
/* Completes the shared repaint contract without a Linux invalid region. */
MDL_EXPORT int MDL_ValidateRect(void *hwnd, void *rect) { (void)hwnd; (void)rect; return 1; }

/* Releases every SDL, OpenGL, audio, and conversion resource owned by the window. */
MDL_EXPORT int MDL_DestroyWindow(void *hwnd) {
  (void)hwnd;
  if (g_audio && pSDL_CloseAudioDevice) pSDL_CloseAudioDevice(g_audio);
  g_audio = 0;
  if (g_context && pSDL_GL_DeleteContext) pSDL_GL_DeleteContext(g_context);
  g_context = NULL;
  if (g_window && pSDL_DestroyWindow) pSDL_DestroyWindow(g_window);
  g_window = NULL;
  if (pSDL_Quit) pSDL_Quit();
  free(g_rgba);
  g_rgba = NULL;
  g_rgba_capacity = 0;
  return 1;
}

/* Returns the SDL window token used as a compatibility device context. */
MDL_EXPORT void *MDL_GetDC(void *hwnd) { return hwnd == g_window ? g_window : NULL; }
/* Finishes a borrowed compatibility device-context lifetime. */
MDL_EXPORT int MDL_ReleaseDC(void *hwnd, void *hdc) { (void)hwnd; (void)hdc; return 1; }

/* Writes current drawable dimensions into the shared RECT layout. */
MDL_EXPORT int MDL_GetClientRect(void *hwnd, void *rect) {
  int width = 0, height = 0;
  if (!g_window || hwnd != g_window || !rect) return 0;
  if (pSDL_GL_GetDrawableSize) pSDL_GL_GetDrawableSize(g_window, &width, &height);
  if ((width <= 0 || height <= 0) && pSDL_GetWindowSize) pSDL_GetWindowSize(g_window, &width, &height);
  mdl_write_i32(rect, 0, 0);
  mdl_write_i32(rect, 4, 0);
  mdl_write_i32(rect, 8, width);
  mdl_write_i32(rect, 12, height);
  return width > 0 && height > 0;
}

/* Pumps SDL events until one produces a message consumed by the engine loop. */
MDL_EXPORT int MDL_PeekMessageW(void *msg, void *hwnd, uint32_t min_msg, uint32_t max_msg, uint32_t remove_msg) {
  SDL_Event event;
  (void)hwnd; (void)min_msg; (void)max_msg; (void)remove_msg;
  if (!pSDL_PollEvent) return 0;
  while (pSDL_PollEvent(&event)) {
    if (mdl_event_message(&event, msg)) return 1;
  }
  return 0;
}

/* Retains the translation phase of the platform-neutral message loop. */
MDL_EXPORT int MDL_TranslateMessage(void *msg) { (void)msg; return 1; }
/* Completes dispatch after SDL state has already been updated during polling. */
MDL_EXPORT void *MDL_DispatchMessageW(void *msg) { (void)msg; return NULL; }

/* Returns held and press-edge state for a virtual keyboard or mouse key. */
MDL_EXPORT int MDL_GetAsyncKeyState(int vkey) {
  int result = 0;
  if (vkey == 1) return g_mouse_buttons & 1 ? 0x8000 : 0;
  if (vkey == 2) return g_mouse_buttons & 2 ? 0x8000 : 0;
  if (vkey == 4) return g_mouse_buttons & 4 ? 0x8000 : 0;
  if (vkey < 0 || vkey >= 256) return 0;
  if (g_keys[vkey]) result |= 0x8000;
  if (g_pressed[vkey]) result |= 1;
  g_pressed[vkey] = 0;
  return result;
}

/* Applies the engine's UTF-8 status title to the SDL window. */
MDL_EXPORT int MDL_SetWindowTextW(void *hwnd, const char *text) {
  char title[512];
  if (!g_window || hwnd != g_window || !pSDL_SetWindowTitle) return 0;
  snprintf(title, sizeof(title), "%s", text ? text : "");
  pSDL_SetWindowTitle(g_window, title);
  return 1;
}

/* Reports accumulated relative mouse motion through the shared point record. */
MDL_EXPORT int MDL_GetCursorPos(void *point) {
  if (!point) return 0;
  mdl_write_i32(point, 0, g_mouse_x);
  mdl_write_i32(point, 4, g_mouse_y);
  return 1;
}

/* Returns the game token only while SDL reports input focus. */
MDL_EXPORT void *MDL_GetForegroundWindow(void) {
  if (!g_window) return NULL;
  if (pSDL_GetWindowFlags) g_has_focus = (pSDL_GetWindowFlags(g_window) & SDL_WINDOW_INPUT_FOCUS) != 0;
  return g_has_focus ? g_window : NULL;
}

/* Synchronizes cursor visibility with SDL relative-mouse capture. */
MDL_EXPORT int MDL_ShowCursor(int show) {
  if (pSDL_ShowCursor) pSDL_ShowCursor(show ? 1 : 0);
  if (pSDL_SetRelativeMouseMode) pSDL_SetRelativeMouseMode(show ? 0 : 1);
  return show ? 1 : 0;
}

/* Returns current display width or height for fullscreen layout. */
MDL_EXPORT int MDL_GetSystemMetrics(int index) {
  SDL_DisplayMode mode;
  memset(&mode, 0, sizeof(mode));
  if (pSDL_GetCurrentDisplayMode && pSDL_GetCurrentDisplayMode(0, &mode) == 0) return index == 0 ? mode.w : mode.h;
  return index == 0 ? 640 : 480;
}

/* Applies requested SDL window placement and client size. */
MDL_EXPORT int MDL_SetWindowPos(void *hwnd, void *insert_after, int x, int y, int width, int height, uint32_t flags) {
  (void)insert_after; (void)flags;
  if (!g_window || hwnd != g_window) return 0;
  if (pSDL_SetWindowPosition) pSDL_SetWindowPosition(g_window, x, y);
  if (pSDL_SetWindowSize && width > 0 && height > 0) pSDL_SetWindowSize(g_window, width, height);
  return 1;
}
/* Supplies a neutral legacy style because SDL owns window decorations. */
MDL_EXPORT void *MDL_GetWindowLongPtrW(void *hwnd, int index) { (void)hwnd; (void)index; return NULL; }
/* Acknowledges a legacy style update applied through separate SDL calls. */
MDL_EXPORT void *MDL_SetWindowLongPtrW(void *hwnd, int index, void *value) { (void)hwnd; (void)index; return value; }
/* Raises a valid SDL game window to the foreground. */
MDL_EXPORT int MDL_SetForegroundWindow(void *hwnd) { if (g_window && hwnd == g_window && pSDL_RaiseWindow) pSDL_RaiseWindow(g_window); return hwnd == g_window; }
/* Reuses the SDL raise operation for Win32-compatible z-order requests. */
MDL_EXPORT int MDL_BringWindowToTop(void *hwnd) { return MDL_SetForegroundWindow(hwnd); }
/* Activates and returns the SDL compatibility window token. */
MDL_EXPORT void *MDL_SetActiveWindow(void *hwnd) { MDL_SetForegroundWindow(hwnd); return hwnd; }
/* Checks whether the supplied token names the live SDL game window. */
MDL_EXPORT int MDL_IsWindow(void *hwnd) { return g_window && hwnd == g_window; }

/* Grows the reusable indexed-to-RGBA software presentation buffer. */
static int mdl_ensure_rgba(size_t required) {
  uint8_t *next;
  if (required <= g_rgba_capacity) return 1;
  next = (uint8_t *)realloc(g_rgba, required);
  if (!next) return 0;
  g_rgba = next;
  g_rgba_capacity = required;
  return 1;
}

/* Expands and scales an indexed software frame into the SDL OpenGL back buffer. */
MDL_EXPORT int MDL_StretchDIBits(void *hdc, int x_dest, int y_dest, int dest_width, int dest_height,
                                 int x_src, int y_src, int src_width, int src_height,
                                 const uint8_t *bits, const uint8_t *bmi, uint32_t usage, uint32_t rop) {
  size_t pixels;
  size_t i;
  const uint8_t *palette;
  (void)hdc; (void)x_dest; (void)y_dest; (void)x_src; (void)y_src; (void)usage; (void)rop;
  if (!g_window || !g_context || !bits || !bmi || src_width <= 0 || src_height <= 0) return 0;
  pixels = (size_t)src_width * (size_t)src_height;
  if (pixels > SIZE_MAX / 4 || !mdl_ensure_rgba(pixels * 4)) return 0;
  palette = bmi + 40;
  for (i = 0; i < pixels; ++i) {
    unsigned index = bits[i];
    g_rgba[i * 4 + 0] = palette[index * 4 + 2];
    g_rgba[i * 4 + 1] = palette[index * 4 + 1];
    g_rgba[i * 4 + 2] = palette[index * 4 + 0];
    g_rgba[i * 4 + 3] = 255;
  }
  if (dest_width <= 0 || dest_height <= 0) {
    if (pSDL_GL_GetDrawableSize) pSDL_GL_GetDrawableSize(g_window, &dest_width, &dest_height);
  }
  pSDL_GL_MakeCurrent(g_window, g_context);
  pglViewport(0, 0, dest_width, dest_height);
  pglDisable(GL_DEPTH_TEST);
  pglDisable(GL_BLEND);
  pglDisable(GL_TEXTURE_2D);
  pglMatrixMode(GL_PROJECTION);
  pglLoadIdentity();
  pglMatrixMode(GL_MODELVIEW);
  pglLoadIdentity();
  pglClear(GL_COLOR_BUFFER_BIT);
  pglPixelStorei(GL_UNPACK_ALIGNMENT, 1);
  pglRasterPos2f(-1.0f, 1.0f);
  pglPixelZoom((float)dest_width / (float)src_width, -(float)dest_height / (float)src_height);
  pglDrawPixels(src_width, src_height, GL_RGBA, GL_UNSIGNED_BYTE, g_rgba);
  pSDL_GL_SwapWindow(g_window);
  return src_height;
}

/* Preserves the nearest-neighbor stretch mode selected by the software renderer. */
MDL_EXPORT int MDL_SetStretchBltMode(void *hdc, int mode) { (void)hdc; return mode; }

/* Creates a Linux directory and treats an existing path as success. */
MDL_EXPORT int MDL_CreateDirectoryW(const char *path, void *security) {
  (void)security;
  if (!path || !path[0]) return 0;
  return mkdir(path, 0755) == 0 || errno == EEXIST;
}

/* Reads a UTF-8 environment value into the save system's UTF-16 buffer. */
MDL_EXPORT int MDL_GetEnvironmentVariableW(const char *name, uint16_t *output, int capacity) {
  const char *value;
  value = name ? getenv(name) : NULL;
  if (!value) return 0;
  return mdl_utf8_to_utf16(value, output, capacity);
}

/* Reports the absence of a separate Win32 console-window handle on Linux. */
MDL_EXPORT void *MDL_GetConsoleWindow(void) { return NULL; }

/* Returns wrapping monotonic milliseconds for Doom's platform clock. */
MDL_EXPORT uint32_t MDL_GetTickCount(void) {
  struct timespec now;
  clock_gettime(CLOCK_MONOTONIC, &now);
  return (uint32_t)((uint64_t)now.tv_sec * 1000u + (uint64_t)now.tv_nsec / 1000000u);
}

/* Sleeps the current thread while transparently resuming after signals. */
MDL_EXPORT int MDL_Sleep(int milliseconds) {
  struct timespec requested;
  if (milliseconds < 0) milliseconds = 0;
  requested.tv_sec = milliseconds / 1000;
  requested.tv_nsec = (long)(milliseconds % 1000) * 1000000L;
  while (nanosleep(&requested, &requested) != 0 && errno == EINTR) {}
  return 0;
}

/* Terminates immediately with the engine-supplied process status. */
MDL_EXPORT int MDL_ExitProcess(int code) { _exit(code); }

/* Applies the engine's nonblocking UDP request through POSIX fcntl. */
MDL_EXPORT int MDL_ioctlsocket(void *socket_value, int32_t command, const uint8_t *argument) {
  int fd = (int)(intptr_t)socket_value;
  int flags;
  int enabled = argument && argument[0] != 0;
  (void)command;
  flags = fcntl(fd, F_GETFL, 0);
  if (flags < 0) return -1;
  if (enabled) flags |= O_NONBLOCK;
  else flags &= ~O_NONBLOCK;
  return fcntl(fd, F_SETFL, flags);
}

/* Translates WinSock timeout constants before calling POSIX setsockopt. */
MDL_EXPORT int MDL_setsockopt(void *socket_value, int level, int option, const uint8_t *value, int length) {
  int fd = (int)(intptr_t)socket_value;
  if (option == 0x1006 && value && length >= 4) {
    int milliseconds = mdl_read_i32(value, 0);
    struct timeval timeout;
    timeout.tv_sec = milliseconds / 1000;
    timeout.tv_usec = (milliseconds % 1000) * 1000;
    return setsockopt(fd, SOL_SOCKET, SO_RCVTIMEO, &timeout, sizeof(timeout));
  }
  if (level == 0xFFFF) level = SOL_SOCKET;
  return setsockopt(fd, level, option, value, (socklen_t)length);
}

/* Confirms SDL already selected the requested framebuffer format. */
MDL_EXPORT int MDL_ChoosePixelFormat(void *hdc, void *pfd) { (void)hdc; (void)pfd; return 1; }
/* Accepts SDL's immutable framebuffer format during shared renderer setup. */
MDL_EXPORT int MDL_SetPixelFormat(void *hdc, int format, void *pfd) { (void)hdc; (void)format; (void)pfd; return 1; }
/* Returns the compatibility-profile context created with the SDL window. */
MDL_EXPORT void *MDL_GLCreateContext(void *hdc) { (void)hdc; return g_context; }
/* Makes or clears the SDL OpenGL context for the calling thread. */
MDL_EXPORT int MDL_GLMakeCurrent(void *hdc, void *context) {
  if (!g_window || !pSDL_GL_MakeCurrent) return 0;
  if (!context) return pSDL_GL_MakeCurrent(g_window, NULL) == 0;
  (void)hdc;
  return pSDL_GL_MakeCurrent(g_window, context) == 0;
}
/* Deletes the SDL-owned context when the engine tears down OpenGL. */
MDL_EXPORT int MDL_GLDeleteContext(void *context) {
  if (context && context == g_context && pSDL_GL_DeleteContext) {
    pSDL_GL_DeleteContext(g_context);
    g_context = NULL;
  }
  return 1;
}
/* Presents the completed SDL OpenGL back buffer. */
MDL_EXPORT int MDL_SwapBuffers(void *hdc) { (void)hdc; if (!g_window || !pSDL_GL_SwapWindow) return 0; pSDL_GL_SwapWindow(g_window); return 1; }
/* Applies the requested SDL vertical-sync interval. */
MDL_EXPORT int MDL_GLSetSwapInterval(int interval) { return pSDL_GL_SetSwapInterval && pSDL_GL_SetSwapInterval(interval) == 0; }

/* Associates an unmanaged wave header with its cumulative SDL queue offset. */
typedef struct MDL_PendingAudio {
  uint8_t *header;
  uint64_t end_offset;
} MDL_PendingAudio;

static MDL_PendingAudio g_pending_audio[64];
static int g_pending_count;
static uint64_t g_audio_submitted;

/* Marks and removes wave headers whose queued SDL bytes have been consumed. */
static void mdl_audio_refresh(void) {
  uint64_t played;
  uint32_t queued;
  int remove = 0;
  if (!g_audio || !pSDL_GetQueuedAudioSize) return;
  queued = pSDL_GetQueuedAudioSize(g_audio);
  played = g_audio_submitted >= queued ? g_audio_submitted - queued : 0;
  while (remove < g_pending_count && g_pending_audio[remove].end_offset <= played) {
    uint32_t flags = 1;
    memcpy(g_pending_audio[remove].header + 24, &flags, sizeof(flags));
    ++remove;
  }
  if (remove > 0) {
    memmove(g_pending_audio, g_pending_audio + remove, (size_t)(g_pending_count - remove) * sizeof(g_pending_audio[0]));
    g_pending_count -= remove;
  }
}

MDL_EXPORT void MDL_RtlMoveMemoryFromPtr(void *destination, const void *source, uint32_t length) {
  /* WinMM updates WAVEHDR flags asynchronously. Refresh the SDL queue-backed
     emulation immediately before MiniLang reads a header snapshot. */
  mdl_audio_refresh();
  if (destination && source && length) memmove(destination, source, length);
}

/* Opens an SDL queued-audio device from MiniDoom's PCM format record. */
MDL_EXPORT uint32_t MDL_waveOutOpen(void *handle_output, uint32_t device, const uint8_t *format,
                                    void *callback, void *instance, uint32_t flags) {
  SDL_AudioSpec wanted;
  (void)device; (void)callback; (void)instance; (void)flags;
  if (!mdl_load_libraries() || !pSDL_OpenAudioDevice || !handle_output) return 1;
  memset(&wanted, 0, sizeof(wanted));
  wanted.freq = format ? mdl_read_i32(format, 4) : 11025;
  wanted.format = AUDIO_S16LSB;
  wanted.channels = format ? format[2] : 2;
  wanted.samples = 512;
  g_audio = pSDL_OpenAudioDevice(NULL, 0, &wanted, NULL, 0);
  if (!g_audio) return 1;
  pSDL_PauseAudioDevice(g_audio, 0);
  memset(handle_output, 0, 8);
  mdl_write_u64(handle_output, 0, g_audio);
  g_pending_count = 0;
  g_audio_submitted = 0;
  return 0;
}

/* Accepts a wave header before queued playback begins. */
MDL_EXPORT uint32_t MDL_waveOutPrepareHeader(void *handle, void *header, uint32_t size) {
  (void)handle; (void)header; (void)size; return 0;
}

/* Queues a mixed PCM buffer and tracks its eventual completion flag. */
MDL_EXPORT uint32_t MDL_waveOutWrite(void *handle, uint8_t *header, uint32_t size) {
  uint8_t *data;
  uint32_t length;
  uint32_t clear = 0;
  (void)handle; (void)size;
  if (!g_audio || !header || !pSDL_QueueAudio) return 1;
  mdl_audio_refresh();
  data = (uint8_t *)(uintptr_t)mdl_read_u64(header, 0);
  length = (uint32_t)mdl_read_i32(header, 8);
  if (!data || !length || pSDL_QueueAudio(g_audio, data, length) != 0) return 1;
  memcpy(header + 24, &clear, sizeof(clear));
  g_audio_submitted += length;
  if (g_pending_count < (int)(sizeof(g_pending_audio) / sizeof(g_pending_audio[0]))) {
    g_pending_audio[g_pending_count].header = header;
    g_pending_audio[g_pending_count].end_offset = g_audio_submitted;
    ++g_pending_count;
  } else {
    uint32_t done = 1;
    memcpy(header + 24, &done, sizeof(done));
  }
  return 0;
}

/* Completes the WinMM-style wave-header lifecycle after SDL playback. */
MDL_EXPORT uint32_t MDL_waveOutUnprepareHeader(void *handle, void *header, uint32_t size) {
  (void)handle; (void)header; (void)size; return 0;
}

/* Clears queued samples and marks every pending header complete. */
MDL_EXPORT uint32_t MDL_waveOutReset(void *handle) {
  int i;
  (void)handle;
  if (g_audio && pSDL_ClearQueuedAudio) pSDL_ClearQueuedAudio(g_audio);
  for (i = 0; i < g_pending_count; ++i) {
    uint32_t done = 1;
    memcpy(g_pending_audio[i].header + 24, &done, sizeof(done));
  }
  g_pending_count = 0;
  g_audio_submitted = 0;
  return 0;
}

/* Resets and closes the SDL queued-audio device. */
MDL_EXPORT uint32_t MDL_waveOutClose(void *handle) {
  (void)handle;
  MDL_waveOutReset(handle);
  if (g_audio && pSDL_CloseAudioDevice) pSDL_CloseAudioDevice(g_audio);
  g_audio = 0;
  return 0;
}

/* Doom's MUS sequencer remains active, but this first Linux backend has no
   system-wide MIDI synthesizer dependency. Calls intentionally succeed. */
/* Opens a successful but silent MIDI endpoint until a synthesizer is provided. */
MDL_EXPORT uint32_t MDL_midiOutOpen(void *handle_output, uint32_t device, void *callback, void *instance, uint32_t flags) {
  (void)device; (void)callback; (void)instance; (void)flags;
  if (handle_output) mdl_write_u64(handle_output, 0, 1);
  return 0;
}
/* Accepts one sequencer message without requiring a system MIDI service. */
MDL_EXPORT uint32_t MDL_midiOutShortMsg(void *handle, uint32_t message) { (void)handle; (void)message; return 0; }
/* Resets the silent MIDI compatibility endpoint. */
MDL_EXPORT uint32_t MDL_midiOutReset(void *handle) { (void)handle; return 0; }
/* Closes the silent MIDI compatibility endpoint. */
MDL_EXPORT uint32_t MDL_midiOutClose(void *handle) { (void)handle; return 0; }
/* Records a successful music-volume update for the silent endpoint. */
MDL_EXPORT uint32_t MDL_midiOutSetVolume(void *handle, uint32_t volume) { (void)handle; (void)volume; return 0; }
