/*
  Copyright 2026 Nils Kopal

  Licensed under the Apache License, Version 2.0 (the "License");
  you may not use this file except in compliance with the License.
  You may obtain a copy of the License at

  http://www.apache.org/licenses/LICENSE-2.0

  Unless required by applicable law or agreed to in writing, software
  distributed under the License is distributed on an "AS IS" BASIS,
  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
  See the License for the specific language governing permissions and
  limitations under the License.

  Script: minidoom_gl_helper.c
  Purpose: Provides tiny WGL-loaded OpenGL VBO helpers for MiniLang.
*/

#define WIN32_LEAN_AND_MEAN
#include <windows.h>
#include <GL/gl.h>
#include <limits.h>
#include <stddef.h>
#include <stdint.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>

#ifndef GL_ARRAY_BUFFER
#define GL_ARRAY_BUFFER 0x8892
#endif

#ifndef GL_STATIC_DRAW
#define GL_STATIC_DRAW 0x88E4
#endif

#ifndef GL_ALPHA_TEST
#define GL_ALPHA_TEST 0x0BC0
#endif

#ifndef GL_GREATER
#define GL_GREATER 0x0204
#endif

#ifndef GL_TEXTURE_2D
#define GL_TEXTURE_2D 0x0DE1
#endif

#ifndef CREATE_WAITABLE_TIMER_HIGH_RESOLUTION
#define CREATE_WAITABLE_TIMER_HIGH_RESOLUTION 0x00000002
#endif

#define MGL_MAX_DYNAMIC_LIGHTS 48

typedef ptrdiff_t GLsizeiptr;
typedef void (APIENTRY *PFNGLGENBUFFERSPROC)(GLsizei n, GLuint *buffers);
typedef void (APIENTRY *PFNGLBINDBUFFERPROC)(GLenum target, GLuint buffer);
typedef void (APIENTRY *PFNGLBUFFERDATAPROC)(GLenum target, GLsizeiptr size, const void *data, GLenum usage);
typedef void (APIENTRY *PFNGLDELETEBUFFERSPROC)(GLsizei n, const GLuint *buffers);
typedef BOOL (WINAPI *PFNWGLSWAPINTERVALEXTPROC)(int interval);

static PFNGLGENBUFFERSPROC pglGenBuffers = NULL;
static PFNGLBINDBUFFERPROC pglBindBuffer = NULL;
static PFNGLBUFFERDATAPROC pglBufferData = NULL;
static PFNGLDELETEBUFFERSPROC pglDeleteBuffers = NULL;
static int g_vboInitTried = 0;
static int g_vboAvailable = 0;
static int g_lastDrawnBatches = 0;
static int g_lastDrawnVertices = 0;
static unsigned char *g_overlayRgba = NULL;
static int g_overlayRgbaBytes = 0;
static LARGE_INTEGER g_qpcFrequency;
static int g_qpcReady = 0;
static int64_t g_framePaceLastUs = 0;
/* Kept for the DLL lifetime to avoid creating a kernel object every frame. */
static HANDLE g_framePaceTimer = NULL;

static int64_t mgl_time_microseconds(void) {
  LARGE_INTEGER now;
  if (!g_qpcReady) {
    if (!QueryPerformanceFrequency(&g_qpcFrequency) || g_qpcFrequency.QuadPart <= 0) {
      return (int64_t)GetTickCount64() * 1000;
    }
    g_qpcReady = 1;
  }
  QueryPerformanceCounter(&now);
  /* Split the conversion so long system uptimes cannot overflow int64_t. */
  return (int64_t)((now.QuadPart / g_qpcFrequency.QuadPart) * 1000000 +
                   ((now.QuadPart % g_qpcFrequency.QuadPart) * 1000000) /
                       g_qpcFrequency.QuadPart);
}

__declspec(dllexport) int64_t __stdcall MGL_TimeMicroseconds(void) {
  return mgl_time_microseconds();
}

__declspec(dllexport) void __stdcall MGL_FramePace(int targetFps, int leadUs) {
  int64_t frameUs;
  int64_t now;
  int64_t due;
  int64_t remaining;

  if (targetFps <= 0 || targetFps > 1000) {
    g_framePaceLastUs = 0;
    return;
  }
  frameUs = 1000000 / targetFps;
  if (leadUs < 0) {
    leadUs = 0;
  }
  if (leadUs > frameUs / 2) {
    leadUs = (int)(frameUs / 2);
  }
  now = mgl_time_microseconds();
  if (g_framePaceLastUs <= 0 || now < g_framePaceLastUs ||
      now - g_framePaceLastUs > frameUs * 4) {
    return;
  }

  /* When VSync is active the caller supplies a small lead so SwapBuffers can
     enter the driver before the target VBlank instead of just after it. */
  due = g_framePaceLastUs + frameUs - leadUs;
  remaining = due - now;
  if (remaining > 2000) {
    LARGE_INTEGER waitDue;
    int64_t waitUs = remaining - 500;
    if (g_framePaceTimer == NULL) {
      g_framePaceTimer = CreateWaitableTimerExW(
          NULL, NULL, CREATE_WAITABLE_TIMER_HIGH_RESOLUTION, TIMER_ALL_ACCESS);
      if (g_framePaceTimer == NULL) {
        g_framePaceTimer = CreateWaitableTimerW(NULL, FALSE, NULL);
      }
    }
    waitDue.QuadPart = -waitUs * 10;
    if (g_framePaceTimer == NULL ||
        !SetWaitableTimer(g_framePaceTimer, &waitDue, 0, NULL, NULL, FALSE) ||
        WaitForSingleObject(g_framePaceTimer, INFINITE) != WAIT_OBJECT_0) {
      /* Last-resort path for systems without a usable waitable timer. */
      Sleep((DWORD)((remaining - 1000) / 1000));
    }
  }
  do {
    now = mgl_time_microseconds();
    if (now < due) {
      SwitchToThread();
    }
  } while (now < due);

}

__declspec(dllexport) void __stdcall MGL_FramePaceMark(void) {
  /* Called immediately after a successful presentation.  Anchoring at the
     real completion time prevents late frames from shortening the next one. */
  g_framePaceLastUs = mgl_time_microseconds();
}

static PROC mgl_load_proc(const char *name) {
  PROC p = wglGetProcAddress(name);
  if (p == NULL || p == (PROC)1 || p == (PROC)2 || p == (PROC)3 || p == (PROC)-1) {
    HMODULE ogl = GetModuleHandleA("opengl32.dll");
    if (ogl != NULL) {
      p = GetProcAddress(ogl, name);
    }
  }
  return p;
}

__declspec(dllexport) BOOL __stdcall MGL_InitVBO(void) {
  if (g_vboInitTried) {
    return g_vboAvailable ? TRUE : FALSE;
  }

  g_vboInitTried = 1;
  pglGenBuffers = (PFNGLGENBUFFERSPROC)mgl_load_proc("glGenBuffers");
  pglBindBuffer = (PFNGLBINDBUFFERPROC)mgl_load_proc("glBindBuffer");
  pglBufferData = (PFNGLBUFFERDATAPROC)mgl_load_proc("glBufferData");
  pglDeleteBuffers = (PFNGLDELETEBUFFERSPROC)mgl_load_proc("glDeleteBuffers");

  g_vboAvailable = pglGenBuffers && pglBindBuffer && pglBufferData && pglDeleteBuffers;
  return g_vboAvailable ? TRUE : FALSE;
}

__declspec(dllexport) BOOL __stdcall MGL_SetSwapInterval(int interval) {
  PFNWGLSWAPINTERVALEXTPROC pSwapInterval =
      (PFNWGLSWAPINTERVALEXTPROC)mgl_load_proc("wglSwapIntervalEXT");
  if (pSwapInterval == NULL) {
    return FALSE;
  }
  return pSwapInterval(interval);
}

__declspec(dllexport) GLuint __stdcall MGL_CreateArrayBuffer(const void *data, int size) {
  GLuint id = 0;
  if (data == NULL || size <= 0) {
    return 0;
  }
  if (!MGL_InitVBO()) {
    return 0;
  }
  pglGenBuffers(1, &id);
  if (id == 0) {
    return 0;
  }
  pglBindBuffer(GL_ARRAY_BUFFER, id);
  pglBufferData(GL_ARRAY_BUFFER, (GLsizeiptr)size, data, GL_STATIC_DRAW);
  pglBindBuffer(GL_ARRAY_BUFFER, 0);
  return id;
}

__declspec(dllexport) GLuint __stdcall MGL_CreateInterleavedGeomBuffer(const void *data, int size) {
  const int inStride = 24;
  const int outStride = 24;
  const float fixScale = 1.0f / 65536.0f;
  const unsigned char *src = (const unsigned char *)data;
  unsigned char *converted = NULL;
  GLuint id = 0;
  int count = 0;
  int i = 0;

  if (data == NULL || size <= 0 || (size % inStride) != 0) {
    return 0;
  }
  if (!MGL_InitVBO()) {
    return 0;
  }

  count = size / inStride;
  converted = (unsigned char *)malloc((size_t)count * (size_t)outStride);
  if (converted == NULL) {
    return 0;
  }

  for (i = 0; i < count; ++i) {
    const unsigned char *s = src + i * inStride;
    unsigned char *d = converted + i * outStride;
    const int32_t *si = (const int32_t *)s;
    float *df = (float *)d;
    df[0] = (float)si[0] * fixScale;
    df[1] = (float)si[1] * fixScale;
    df[2] = (float)si[2] * fixScale;
    df[3] = (float)si[3] * fixScale;
    df[4] = (float)si[4] * fixScale;
    d[20] = s[20];
    d[21] = s[21];
    d[22] = s[22];
    d[23] = s[23];
  }

  pglGenBuffers(1, &id);
  if (id != 0) {
    pglBindBuffer(GL_ARRAY_BUFFER, id);
    pglBufferData(GL_ARRAY_BUFFER, (GLsizeiptr)((size_t)count * (size_t)outStride), converted, GL_STATIC_DRAW);
    pglBindBuffer(GL_ARRAY_BUFFER, 0);
  }
  free(converted);
  return id;
}

__declspec(dllexport) void __stdcall MGL_DeleteArrayBuffer(GLuint id) {
  if (id == 0 || !MGL_InitVBO()) {
    return;
  }
  pglDeleteBuffers(1, &id);
}

__declspec(dllexport) void __stdcall MGL_DrawArrayBatch(GLenum mode, GLuint vertexBuffer, GLuint texcoordBuffer, GLuint colorBuffer, int count) {
  if (count <= 0 || vertexBuffer == 0 || texcoordBuffer == 0 || colorBuffer == 0 || !MGL_InitVBO()) {
    return;
  }

  pglBindBuffer(GL_ARRAY_BUFFER, vertexBuffer);
  glVertexPointer(3, GL_INT, 0, (const void *)0);

  pglBindBuffer(GL_ARRAY_BUFFER, texcoordBuffer);
  glTexCoordPointer(2, GL_INT, 0, (const void *)0);

  pglBindBuffer(GL_ARRAY_BUFFER, colorBuffer);
  glColorPointer(4, GL_UNSIGNED_BYTE, 0, (const void *)0);

  glDrawArrays(mode, 0, count);

  pglBindBuffer(GL_ARRAY_BUFFER, 0);
}

__declspec(dllexport) void __stdcall MGL_DrawInterleavedBatch(GLenum mode, GLuint buffer, int count) {
  const int stride = 24;
  if (count <= 0 || buffer == 0 || !MGL_InitVBO()) {
    return;
  }

  pglBindBuffer(GL_ARRAY_BUFFER, buffer);
  glVertexPointer(3, GL_FLOAT, stride, (const void *)0);
  glTexCoordPointer(2, GL_FLOAT, stride, (const void *)12);
  glColorPointer(4, GL_UNSIGNED_BYTE, stride, (const void *)20);
  glDrawArrays(mode, 0, count);
  pglBindBuffer(GL_ARRAY_BUFFER, 0);
}

__declspec(dllexport) int __stdcall MGL_GetLastDrawnBatches(void) {
  return g_lastDrawnBatches;
}

__declspec(dllexport) int __stdcall MGL_GetLastDrawnVertices(void) {
  return g_lastDrawnVertices;
}

__declspec(dllexport) BOOL __stdcall MGL_DrawVisibleGeomBatches(
    GLenum mode,
    const void *records,
    int recordCount,
    double viewX,
    double viewY,
    double viewYaw) {
  const int stride = 28;
  const double fixScale = 1.0 / 65536.0;
  const unsigned char *ptr = (const unsigned char *)records;
  double yawRad;
  double fwdX;
  double fwdY;
  GLuint boundTex = 0xffffffffu;
  int alphaEnabled = -1;
  int i;

  g_lastDrawnBatches = 0;
  g_lastDrawnVertices = 0;
  if (records == NULL || recordCount <= 0 || !MGL_InitVBO()) {
    return FALSE;
  }

  yawRad = (viewYaw / 360.0) * 6.283185314;
  fwdX = cos(yawRad);
  fwdY = sin(yawRad);

  for (i = 0; i < recordCount; ++i) {
    const unsigned char *r = ptr + i * stride;
    GLuint texid = *(const uint32_t *)(r + 0);
    GLuint vbo = *(const uint32_t *)(r + 4);
    int count = *(const int32_t *)(r + 8);
    int flags = *(const int32_t *)(r + 12);
    double cx = (double)(*(const int32_t *)(r + 16)) * fixScale;
    double cz = (double)(*(const int32_t *)(r + 20)) * fixScale;
    double radius = (double)(*(const int32_t *)(r + 24)) * fixScale;
    double dx;
    double dy;
    double forward;
    double side;

    if (vbo == 0 || count <= 0) {
      continue;
    }

    dx = cx - viewX;
    dy = -cz - viewY;
    forward = dx * fwdX + dy * fwdY;
    side = dx * (-fwdY) + dy * fwdX;
    if (side < 0.0) {
      side = -side;
    }
    if (forward + radius < -128.0) {
      continue;
    }
    if (forward > 64.0) {
      if (side - radius > forward * 1.25 + 384.0) {
        continue;
      }
    } else {
      if (side - radius > 640.0) {
        continue;
      }
    }

    if (texid != boundTex) {
      if (texid > 0) {
        glEnable(GL_TEXTURE_2D);
        glBindTexture(GL_TEXTURE_2D, texid);
      } else {
        glDisable(GL_TEXTURE_2D);
      }
      boundTex = texid;
    }

    if ((flags & 1) != alphaEnabled) {
      alphaEnabled = flags & 1;
      if (alphaEnabled) {
        glEnable(GL_ALPHA_TEST);
        glAlphaFunc(GL_GREATER, 0.5f);
      } else {
        glDisable(GL_ALPHA_TEST);
      }
    }

    pglBindBuffer(GL_ARRAY_BUFFER, vbo);
    glVertexPointer(3, GL_FLOAT, 24, (const void *)0);
    glTexCoordPointer(2, GL_FLOAT, 24, (const void *)12);
    glColorPointer(4, GL_UNSIGNED_BYTE, 24, (const void *)20);
    glDrawArrays(mode, 0, count);
    g_lastDrawnBatches += 1;
    g_lastDrawnVertices += count;
  }

  pglBindBuffer(GL_ARRAY_BUFFER, 0);
  glDisable(GL_ALPHA_TEST);
  return TRUE;
}

static int32_t mgl_read_i32(const unsigned char *p) {
  return (int32_t)((uint32_t)p[0] |
                   ((uint32_t)p[1] << 8) |
                   ((uint32_t)p[2] << 16) |
                   ((uint32_t)p[3] << 24));
}

static double mgl_read_geom(const unsigned char *p) {
  return (double)mgl_read_i32(p) / 65536.0;
}

static GLubyte mgl_clamp_color(double value) {
  if (value <= 0.0) {
    return 0;
  }
  if (value >= 255.0) {
    return 255;
  }
  return (GLubyte)value;
}

static void mgl_emit_sprite_quad(
    double x0,
    double y0,
    double x1,
    double y1,
    double z0,
    double z1,
    int flip) {
  if (flip) {
    glTexCoord2d(1.0, 1.0);
    glVertex3d(x0, z0, y0);
    glTexCoord2d(0.0, 1.0);
    glVertex3d(x1, z0, y1);
    glTexCoord2d(0.0, 0.0);
    glVertex3d(x1, z1, y1);
    glTexCoord2d(1.0, 0.0);
    glVertex3d(x0, z1, y0);
  } else {
    glTexCoord2d(0.0, 1.0);
    glVertex3d(x0, z0, y0);
    glTexCoord2d(1.0, 1.0);
    glVertex3d(x1, z0, y1);
    glTexCoord2d(1.0, 0.0);
    glVertex3d(x1, z1, y1);
    glTexCoord2d(0.0, 0.0);
    glVertex3d(x0, z1, y0);
  }
}

static void mgl_sprite_color(
    int base,
    double x,
    double y,
    double z,
    const unsigned char *lightData,
    int lightCount,
    double viewX,
    double viewY) {
  double r = (double)base;
  double g = (double)base;
  double b = (double)base;
  double dx = x - viewX;
  double dz = z + viewY;
  double d2 = dx * dx + dz * dz;
  const double nearRadius2 = 640.0 * 640.0;
  const double fadeStart = 280.0 * 280.0;
  const double fadeEnd = 1650.0 * 1650.0;
  int i;

  if (d2 < nearRadius2) {
    double boost = (1.0 - d2 / nearRadius2) * 54.0;
    r += boost;
    g += boost;
    b += boost;
  }
  if (d2 > fadeStart) {
    double fade = ((d2 - fadeStart) / (fadeEnd - fadeStart)) * 190.0;
    if (fade > 190.0) {
      fade = 190.0;
    }
    r -= fade;
    g -= fade;
    b -= fade;
  }

  for (i = 0; i < lightCount; ++i) {
    const unsigned char *lp = lightData + i * 32;
    double lx = mgl_read_geom(lp + 0);
    double ly = mgl_read_geom(lp + 4);
    double lz = mgl_read_geom(lp + 8);
    double radius = mgl_read_geom(lp + 12);
    double strength = mgl_read_geom(lp + 16);
    double ldx = x - lx;
    double ldy = y - ly;
    double ldz = z - lz;
    double ld2 = ldx * ldx + ldy * ldy + ldz * ldz;
    double radius2 = radius * radius;
    if (radius > 0.0 && ld2 < radius2) {
      double amount = (1.0 - ld2 / radius2) * strength;
      r += amount * ((double)mgl_read_i32(lp + 20) / 255.0);
      g += amount * ((double)mgl_read_i32(lp + 24) / 255.0);
      b += amount * ((double)mgl_read_i32(lp + 28) / 255.0);
    }
  }
  glColor4ub(mgl_clamp_color(r), mgl_clamp_color(g), mgl_clamp_color(b), 255);
}

typedef struct mgl_sprite_batch_state_s {
  int active;
  int quadOpen;
  GLuint boundTex;
  int lightCount;
  unsigned char lightData[MGL_MAX_DYNAMIC_LIGHTS * 32];
  double viewX;
  double viewY;
  double rightX;
  double rightZ;
  double worldScale;
  double footLift;
} mgl_sprite_batch_state_t;

static mgl_sprite_batch_state_t g_mgl_sprite_batch;

static void mgl_finish_sprite_batch(void) {
  if (!g_mgl_sprite_batch.active) {
    return;
  }
  if (g_mgl_sprite_batch.quadOpen) {
    glEnd();
  }
  glDepthMask(TRUE);
  glDisable(GL_ALPHA_TEST);
  glColor4ub(255, 255, 255, 255);
  g_mgl_sprite_batch.active = 0;
  g_mgl_sprite_batch.quadOpen = 0;
}

__declspec(dllexport) BOOL __stdcall MGL_BeginSpriteBatch(
    const unsigned char *lightData,
    int lightCount,
    double viewX,
    double viewY,
    double rightX,
    double rightZ,
    double worldScale,
    double footLift) {
  if (g_mgl_sprite_batch.active || lightCount < 0 ||
      lightCount > MGL_MAX_DYNAMIC_LIGHTS || worldScale <= 0.0) {
    return FALSE;
  }
  if (lightCount > 0 && lightData == NULL) {
    return FALSE;
  }

  g_mgl_sprite_batch.active = 1;
  g_mgl_sprite_batch.quadOpen = 0;
  g_mgl_sprite_batch.boundTex = 0xffffffffu;
  g_mgl_sprite_batch.lightCount = lightCount;
  if (lightCount > 0) {
    memcpy(g_mgl_sprite_batch.lightData, lightData, (size_t)lightCount * 32u);
  }
  g_mgl_sprite_batch.viewX = viewX;
  g_mgl_sprite_batch.viewY = viewY;
  g_mgl_sprite_batch.rightX = rightX;
  g_mgl_sprite_batch.rightZ = rightZ;
  g_mgl_sprite_batch.worldScale = worldScale;
  g_mgl_sprite_batch.footLift = footLift;

  glEnable(GL_TEXTURE_2D);
  glEnable(GL_ALPHA_TEST);
  glAlphaFunc(GL_GREATER, 0.5f);
  glDepthMask(TRUE);
  return TRUE;
}

__declspec(dllexport) void __stdcall MGL_SubmitSprite(
    GLuint texid,
    int flags,
    int base,
    int fixedX,
    int fixedY,
    int fixedZ,
    int width,
    int height,
    int yOffset) {
  const double fix = 1.0 / 65536.0;
  double x;
  double y;
  double z1;
  double z0;
  double halfw;
  double x0;
  double y0;
  double x1;
  double y1;
  int flip;
  int shadow;

  if (!g_mgl_sprite_batch.active || texid == 0 || width <= 0 || height <= 0) {
    return;
  }

  x = (double)fixedX * fix;
  y = -(double)fixedY * fix;
  z1 = (double)fixedZ * fix + (double)yOffset / g_mgl_sprite_batch.worldScale + g_mgl_sprite_batch.footLift;
  z0 = z1 - (double)height / g_mgl_sprite_batch.worldScale;
  halfw = ((double)width / g_mgl_sprite_batch.worldScale) * 0.5;
  if (halfw < 2.0) {
    halfw = 2.0;
  }
  x0 = x - g_mgl_sprite_batch.rightX * halfw;
  y0 = y - g_mgl_sprite_batch.rightZ * halfw;
  x1 = x + g_mgl_sprite_batch.rightX * halfw;
  y1 = y + g_mgl_sprite_batch.rightZ * halfw;
  flip = flags & 1;
  shadow = flags & 2;

  if (shadow) {
    int pass;
    int shade;
    if (g_mgl_sprite_batch.quadOpen) {
      glEnd();
      g_mgl_sprite_batch.quadOpen = 0;
    }
    if (texid != g_mgl_sprite_batch.boundTex) {
      glBindTexture(GL_TEXTURE_2D, texid);
      g_mgl_sprite_batch.boundTex = texid;
    }
    glDisable(GL_ALPHA_TEST);
    glDepthMask(FALSE);
    shade = base;
    if (shade > 126) shade = 126;
    if (shade < 58) shade = 58;
    glBegin(GL_QUADS);
    for (pass = 0; pass < 5; ++pass) {
      double side = 0.0;
      double lift = 0.0;
      GLubyte alpha = 22;
      if (pass == 0) {
        side = -2.8;
        alpha = 28;
      } else if (pass == 1) {
        side = 2.8;
        alpha = 28;
      } else if (pass == 2) {
        lift = 2.0;
      } else if (pass == 3) {
        lift = -1.8;
      } else {
        alpha = 34;
      }
      glColor4ub((GLubyte)shade, (GLubyte)shade, (GLubyte)shade, alpha);
      mgl_emit_sprite_quad(
          x0 + g_mgl_sprite_batch.rightX * side,
          y0 + g_mgl_sprite_batch.rightZ * side,
          x1 + g_mgl_sprite_batch.rightX * side,
          y1 + g_mgl_sprite_batch.rightZ * side,
          z0 + lift,
          z1 + lift,
          flip);
    }
    glEnd();
    glDepthMask(TRUE);
    glEnable(GL_ALPHA_TEST);
    glAlphaFunc(GL_GREATER, 0.5f);
    return;
  }

  if (texid != g_mgl_sprite_batch.boundTex) {
    glBindTexture(GL_TEXTURE_2D, texid);
    g_mgl_sprite_batch.boundTex = texid;
  }
  /* Never carry glBegin/glEnd state across the DLL ABI boundary.  MiniLang
     may resolve and upload the next sprite texture between submit calls;
     texture creation is illegal while an immediate-mode primitive is open. */
  glBegin(GL_QUADS);
  mgl_sprite_color(
      base,
      x,
      (z0 + z1) * 0.5,
      y,
      g_mgl_sprite_batch.lightData,
      g_mgl_sprite_batch.lightCount,
      g_mgl_sprite_batch.viewX,
      g_mgl_sprite_batch.viewY);
  mgl_emit_sprite_quad(x0, y0, x1, y1, z0, z1, flip);
  glEnd();
}

__declspec(dllexport) BOOL __stdcall MGL_DrawSpriteRecords(
    const unsigned char *records,
    int recordsSize,
    int recordCount) {
  const int recordSize = 36;
  const double fix = 1.0 / 65536.0;
  int i;

  if (!g_mgl_sprite_batch.active || recordCount < 0 ||
      recordCount > INT_MAX / recordSize ||
      recordsSize < recordCount * recordSize ||
      (recordCount > 0 && records == NULL)) {
    return FALSE;
  }

  for (i = 0; i < recordCount; ++i) {
    const unsigned char *record = records + i * recordSize;
    GLuint texid = (GLuint)mgl_read_i32(record + 0);
    int flags = mgl_read_i32(record + 4);
    int base = mgl_read_i32(record + 8);
    int fixedX = mgl_read_i32(record + 12);
    int fixedY = mgl_read_i32(record + 16);
    int fixedZ = mgl_read_i32(record + 20);
    int width = mgl_read_i32(record + 24);
    int height = mgl_read_i32(record + 28);
    int yOffset = mgl_read_i32(record + 32);
    double x;
    double y;
    double z1;
    double z0;
    double halfw;
    double x0;
    double y0;
    double x1;
    double y1;
    int flip;

    if (texid == 0 || width <= 0 || height <= 0) {
      continue;
    }
    if ((flags & 2) != 0) {
      MGL_SubmitSprite(
          texid,
          flags,
          base,
          fixedX,
          fixedY,
          fixedZ,
          width,
          height,
          yOffset);
      continue;
    }

    x = (double)fixedX * fix;
    y = -(double)fixedY * fix;
    z1 = (double)fixedZ * fix +
         (double)yOffset / g_mgl_sprite_batch.worldScale +
         g_mgl_sprite_batch.footLift;
    z0 = z1 - (double)height / g_mgl_sprite_batch.worldScale;
    halfw = ((double)width / g_mgl_sprite_batch.worldScale) * 0.5;
    if (halfw < 2.0) {
      halfw = 2.0;
    }
    x0 = x - g_mgl_sprite_batch.rightX * halfw;
    y0 = y - g_mgl_sprite_batch.rightZ * halfw;
    x1 = x + g_mgl_sprite_batch.rightX * halfw;
    y1 = y + g_mgl_sprite_batch.rightZ * halfw;
    flip = flags & 1;

    if (texid != g_mgl_sprite_batch.boundTex) {
      if (g_mgl_sprite_batch.quadOpen) {
        glEnd();
        g_mgl_sprite_batch.quadOpen = 0;
      }
      glBindTexture(GL_TEXTURE_2D, texid);
      g_mgl_sprite_batch.boundTex = texid;
    }
    if (!g_mgl_sprite_batch.quadOpen) {
      glBegin(GL_QUADS);
      g_mgl_sprite_batch.quadOpen = 1;
    }
    mgl_sprite_color(
        base,
        x,
        (z0 + z1) * 0.5,
        y,
        g_mgl_sprite_batch.lightData,
        g_mgl_sprite_batch.lightCount,
        g_mgl_sprite_batch.viewX,
        g_mgl_sprite_batch.viewY);
    mgl_emit_sprite_quad(x0, y0, x1, y1, z0, z1, flip);
  }
  return TRUE;
}

__declspec(dllexport) void __stdcall MGL_EndSpriteBatch(void) {
  mgl_finish_sprite_batch();
}

static unsigned char mgl_light_alpha(
    const int32_t *light,
    double x,
    double y,
    double z) {
  const double fix = 1.0 / 65536.0;
  double lx = (double)light[0] * fix;
  double ly = (double)light[1] * fix;
  double lz = (double)light[2] * fix;
  double radius = (double)light[3] * fix;
  double strength = (double)light[4] * fix;
  double dx = x - lx;
  double dy = y - ly;
  double dz = z - lz;
  double dist2 = dx * dx + dy * dy + dz * dz;
  double radius2;
  double falloff;
  double alpha;

  if (radius <= 0.0 || strength <= 0.0) {
    return 0;
  }
  radius2 = radius * radius;
  if (dist2 >= radius2) {
    return 0;
  }
  falloff = 1.0 - (dist2 / radius2);
  alpha = falloff * falloff * strength * 0.95;
  if (alpha < 4.0) {
    return 0;
  }
  if (alpha > 145.0) {
    alpha = 145.0;
  }
  return (unsigned char)alpha;
}

static int mgl_light_intersects_bounds(
    const int32_t *light,
    double minX,
    double minY,
    double minZ,
    double maxX,
    double maxY,
    double maxZ) {
  const double fix = 1.0 / 65536.0;
  double lx = (double)light[0] * fix;
  double ly = (double)light[1] * fix;
  double lz = (double)light[2] * fix;
  double radius = (double)light[3] * fix;
  double dx = 0.0;
  double dy = 0.0;
  double dz = 0.0;

  if (radius <= 0.0) {
    return 0;
  }
  if (lx < minX) dx = minX - lx;
  else if (lx > maxX) dx = lx - maxX;
  if (ly < minY) dy = minY - ly;
  else if (ly > maxY) dy = ly - maxY;
  if (lz < minZ) dz = minZ - lz;
  else if (lz > maxZ) dz = lz - maxZ;
  return dx * dx + dy * dy + dz * dz < radius * radius;
}

static void mgl_light_vertex_alpha(
    const int32_t *light,
    double x,
    double y,
    double z,
    unsigned char a) {
  glColor4ub(
      (GLubyte)(light[5] < 0 ? 0 : (light[5] > 255 ? 255 : light[5])),
      (GLubyte)(light[6] < 0 ? 0 : (light[6] > 255 ? 255 : light[6])),
      (GLubyte)(light[7] < 0 ? 0 : (light[7] > 255 ? 255 : light[7])),
      a);
  glVertex3d(x, y, z);
}

__declspec(dllexport) BOOL __stdcall MGL_DrawDynamicLightSurfaces(
    const unsigned char *geomData,
    int geomSize,
    const unsigned char *lightData,
    int lightCount) {
  const int headerSize = 60;
  const int quadSize = 92;
  const int triSize = 68;
  int bc;
  int wc;
  int mc;
  int fc;
  size_t geomBytes;
  size_t wallOff;
  size_t flatOff;
  size_t offset;
  int li;

  if (geomData == NULL || lightData == NULL || geomSize < headerSize ||
      lightCount <= 0 || lightCount > MGL_MAX_DYNAMIC_LIGHTS) {
    return FALSE;
  }
  if (geomData[0] != 77 || geomData[1] != 71 || geomData[2] != 76 || geomData[3] != 49) {
    return FALSE;
  }

  bc = mgl_read_i32(geomData + 36);
  wc = mgl_read_i32(geomData + 40);
  mc = mgl_read_i32(geomData + 44);
  fc = mgl_read_i32(geomData + 48);
  if (bc < 0 || wc < 0 || mc < 0 || fc < 0) {
    return FALSE;
  }

  /* Validate each section before doing offset arithmetic.  The counts live in
     a cache blob and therefore must not be allowed to wrap signed int math. */
  geomBytes = (size_t)geomSize;
  offset = (size_t)headerSize;
  if ((size_t)bc > (geomBytes - offset) / (size_t)quadSize) {
    return FALSE;
  }
  offset += (size_t)bc * (size_t)quadSize;
  wallOff = offset;
  if ((size_t)wc > (geomBytes - offset) / (size_t)quadSize) {
    return FALSE;
  }
  offset += (size_t)wc * (size_t)quadSize;
  if ((size_t)mc > (geomBytes - offset) / (size_t)quadSize) {
    return FALSE;
  }
  offset += (size_t)mc * (size_t)quadSize;
  flatOff = offset;
  if ((size_t)fc > (geomBytes - offset) / (size_t)triSize) {
    return FALSE;
  }

  glDisable(GL_TEXTURE_2D);
  glDisable(GL_ALPHA_TEST);
  glDepthMask(FALSE);
  glDepthFunc(GL_LEQUAL);
  glBlendFunc(GL_SRC_ALPHA, GL_ONE);

  /* Geometry is the larger data set. Decode each primitive once, then test the
     small light list, instead of reparsing the whole map for every light. */
  glBegin(GL_QUADS);
  {
    int i;
    for (i = 0; i < wc; ++i) {
      const unsigned char *q =
          geomData + wallOff + (size_t)i * (size_t)quadSize;
      int transparent = mgl_read_i32(q + 4) != 0;
      double x0;
      double y0;
      double z0;
      double x1;
      double y1;
      double z1;
      double x2;
      double y2;
      double z2;
      double x3;
      double y3;
      double z3;
      double minX;
      double minY;
      double minZ;
      double maxX;
      double maxY;
      double maxZ;
      if (transparent) {
        continue;
      }
      x0 = mgl_read_geom(q + 12);
      y0 = mgl_read_geom(q + 16);
      z0 = mgl_read_geom(q + 20);
      x1 = mgl_read_geom(q + 32);
      y1 = mgl_read_geom(q + 36);
      z1 = mgl_read_geom(q + 40);
      x2 = mgl_read_geom(q + 52);
      y2 = mgl_read_geom(q + 56);
      z2 = mgl_read_geom(q + 60);
      x3 = mgl_read_geom(q + 72);
      y3 = mgl_read_geom(q + 76);
      z3 = mgl_read_geom(q + 80);
      minX = fmin(fmin(x0, x1), fmin(x2, x3));
      minY = fmin(fmin(y0, y1), fmin(y2, y3));
      minZ = fmin(fmin(z0, z1), fmin(z2, z3));
      maxX = fmax(fmax(x0, x1), fmax(x2, x3));
      maxY = fmax(fmax(y0, y1), fmax(y2, y3));
      maxZ = fmax(fmax(z0, z1), fmax(z2, z3));
      for (li = 0; li < lightCount; ++li) {
        const int32_t *light = (const int32_t *)(lightData + li * 32);
        unsigned char a0;
        unsigned char a1;
        unsigned char a2;
        unsigned char a3;
        if (!mgl_light_intersects_bounds(light, minX, minY, minZ, maxX, maxY, maxZ)) {
          continue;
        }
        a0 = mgl_light_alpha(light, x0, y0, z0);
        a1 = mgl_light_alpha(light, x1, y1, z1);
        a2 = mgl_light_alpha(light, x2, y2, z2);
        a3 = mgl_light_alpha(light, x3, y3, z3);
        if (a0 == 0 && a1 == 0 && a2 == 0 && a3 == 0) {
          continue;
        }
        mgl_light_vertex_alpha(light, x0, y0, z0, a0);
        mgl_light_vertex_alpha(light, x1, y1, z1, a1);
        mgl_light_vertex_alpha(light, x2, y2, z2, a2);
        mgl_light_vertex_alpha(light, x3, y3, z3, a3);
      }
    }
  }
  glEnd();

  glBegin(GL_TRIANGLES);
  {
    int i;
    for (i = 0; i < fc; ++i) {
      const unsigned char *t =
          geomData + flatOff + (size_t)i * (size_t)triSize;
      double x0 = mgl_read_geom(t + 8);
      double y0 = mgl_read_geom(t + 12);
      double z0 = mgl_read_geom(t + 16);
      double x1 = mgl_read_geom(t + 28);
      double y1 = mgl_read_geom(t + 32);
      double z1 = mgl_read_geom(t + 36);
      double x2 = mgl_read_geom(t + 48);
      double y2 = mgl_read_geom(t + 52);
      double z2 = mgl_read_geom(t + 56);
      double minX = fmin(x0, fmin(x1, x2));
      double minY = fmin(y0, fmin(y1, y2));
      double minZ = fmin(z0, fmin(z1, z2));
      double maxX = fmax(x0, fmax(x1, x2));
      double maxY = fmax(y0, fmax(y1, y2));
      double maxZ = fmax(z0, fmax(z1, z2));
      for (li = 0; li < lightCount; ++li) {
        const int32_t *light = (const int32_t *)(lightData + li * 32);
        unsigned char a0;
        unsigned char a1;
        unsigned char a2;
        if (!mgl_light_intersects_bounds(light, minX, minY, minZ, maxX, maxY, maxZ)) {
          continue;
        }
        a0 = mgl_light_alpha(light, x0, y0, z0);
        a1 = mgl_light_alpha(light, x1, y1, z1);
        a2 = mgl_light_alpha(light, x2, y2, z2);
        if (a0 == 0 && a1 == 0 && a2 == 0) {
          continue;
        }
        mgl_light_vertex_alpha(light, x0, y0, z0, a0);
        mgl_light_vertex_alpha(light, x1, y1, z1, a1);
        mgl_light_vertex_alpha(light, x2, y2, z2, a2);
      }
    }
  }
  glEnd();

  glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
  glDepthFunc(GL_LESS);
  glDepthMask(TRUE);
  glEnable(GL_TEXTURE_2D);
  glColor4ub(255, 255, 255, 255);
  return TRUE;
}

static BOOL mgl_ensure_overlay_rgba(int boxW, int boxH) {
  int bytesNeeded;
  unsigned char *newBuf;

  if (boxW <= 0 || boxH <= 0 || boxW > INT_MAX / boxH ||
      boxW * boxH > INT_MAX / 4) {
    return FALSE;
  }
  bytesNeeded = boxW * boxH * 4;
  if (g_overlayRgbaBytes >= bytesNeeded) {
    return TRUE;
  }
  newBuf = (unsigned char *)realloc(g_overlayRgba, (size_t)bytesNeeded);
  if (newBuf == NULL) {
    return FALSE;
  }
  g_overlayRgba = newBuf;
  g_overlayRgbaBytes = bytesNeeded;
  return TRUE;
}

static BOOL mgl_draw_overlay_box(
    GLuint texid,
    int outputW,
    int outputH,
    int minX,
    int minY,
    int maxX,
    int maxY) {
  int boxW = maxX - minX + 1;
  int boxH = maxY - minY + 1;

  if (texid == 0 || outputW <= 0 || outputH <= 0 || boxW <= 0 || boxH <= 0) {
    return FALSE;
  }
  glBindTexture(GL_TEXTURE_2D, texid);
  glTexImage2D(
      GL_TEXTURE_2D,
      0,
      GL_RGBA,
      boxW,
      boxH,
      0,
      GL_RGBA,
      GL_UNSIGNED_BYTE,
      g_overlayRgba);
  glBegin(GL_QUADS);
  glTexCoord2d(0.0, 0.0);
  glVertex3d(
      ((double)minX / (double)outputW) * 2.0 - 1.0,
      1.0 - ((double)minY / (double)outputH) * 2.0,
      0.0);
  glTexCoord2d(1.0, 0.0);
  glVertex3d(
      ((double)(maxX + 1) / (double)outputW) * 2.0 - 1.0,
      1.0 - ((double)minY / (double)outputH) * 2.0,
      0.0);
  glTexCoord2d(1.0, 1.0);
  glVertex3d(
      ((double)(maxX + 1) / (double)outputW) * 2.0 - 1.0,
      1.0 - ((double)(maxY + 1) / (double)outputH) * 2.0,
      0.0);
  glTexCoord2d(0.0, 1.0);
  glVertex3d(
      ((double)minX / (double)outputW) * 2.0 - 1.0,
      1.0 - ((double)(maxY + 1) / (double)outputH) * 2.0,
      0.0);
  glEnd();
  return TRUE;
}

static __inline void mgl_write_scaled_overlay_pixel(
    const unsigned char *palette,
    unsigned char color,
    int sx,
    int sy,
    int scale,
    int minX,
    int minY,
    int boxW) {
  int baseX = sx * scale - minX;
  int baseY = sy * scale - minY;
  int c = (int)color * 3;
  int yy;

  for (yy = 0; yy < scale; ++yy) {
    int row = (baseY + yy) * boxW + baseX;
    int xx;
    for (xx = 0; xx < scale; ++xx) {
      int ro = (row + xx) * 4;
      g_overlayRgba[ro + 0] = palette[c + 0];
      g_overlayRgba[ro + 1] = palette[c + 1];
      g_overlayRgba[ro + 2] = palette[c + 2];
      g_overlayRgba[ro + 3] = 255;
    }
  }
}

__declspec(dllexport) BOOL __stdcall MGL_DrawIndexedLogicalOverlay(
    GLuint texid,
    const unsigned char *data,
    int dataSize,
    const unsigned char *mask,
    int maskSize,
    const unsigned char *palette,
    int logicalW,
    int logicalH,
    int scale,
    int statusY,
    int maskMinX,
    int maskMinY,
    int maskMaxX,
    int maskMaxY) {
  int logicalPixels;
  int outputW;
  int outputH;
  int minX;
  int minY;
  int maxX;
  int maxY;
  int boxW;
  int boxH;
  int sx;
  int sy;
  int hasMaskBounds;

  if (texid == 0 || data == NULL || mask == NULL || palette == NULL ||
      logicalW <= 0 || logicalH <= 0 || scale <= 0 ||
      logicalW > INT_MAX / logicalH || logicalW > INT_MAX / scale ||
      logicalH > INT_MAX / scale) {
    return FALSE;
  }
  logicalPixels = logicalW * logicalH;
  if (dataSize < logicalPixels || maskSize < logicalPixels) {
    return FALSE;
  }
  outputW = logicalW * scale;
  outputH = logicalH * scale;
  if (statusY < 0) {
    statusY = 0;
  }
  if (statusY > logicalH) {
    statusY = logicalH;
  }

  hasMaskBounds = maskMaxX >= maskMinX && maskMaxY >= maskMinY;
  if (hasMaskBounds) {
    if (maskMinX < 0) maskMinX = 0;
    if (maskMinY < 0) maskMinY = 0;
    if (maskMaxX >= logicalW) maskMaxX = logicalW - 1;
    if (maskMaxY >= logicalH) maskMaxY = logicalH - 1;
    hasMaskBounds = maskMaxX >= maskMinX && maskMaxY >= maskMinY;
  }

  if (statusY < logicalH) {
    minX = 0;
    minY = statusY * scale;
    maxX = outputW - 1;
    maxY = outputH - 1;
  } else if (hasMaskBounds) {
    minX = maskMinX * scale;
    minY = maskMinY * scale;
    maxX = (maskMaxX + 1) * scale - 1;
    maxY = (maskMaxY + 1) * scale - 1;
  } else {
    return FALSE;
  }
  if (hasMaskBounds) {
    int scaledMinX = maskMinX * scale;
    int scaledMinY = maskMinY * scale;
    int scaledMaxX = (maskMaxX + 1) * scale - 1;
    int scaledMaxY = (maskMaxY + 1) * scale - 1;
    if (scaledMinX < minX) minX = scaledMinX;
    if (scaledMinY < minY) minY = scaledMinY;
    if (scaledMaxX > maxX) maxX = scaledMaxX;
    if (scaledMaxY > maxY) maxY = scaledMaxY;
  }

  boxW = maxX - minX + 1;
  boxH = maxY - minY + 1;
  if (!mgl_ensure_overlay_rgba(boxW, boxH)) {
    return FALSE;
  }
  memset(g_overlayRgba, 0, (size_t)boxW * (size_t)boxH * 4u);

  for (sy = statusY; sy < logicalH; ++sy) {
    int row = sy * logicalW;
    for (sx = 0; sx < logicalW; ++sx) {
      mgl_write_scaled_overlay_pixel(
          palette, data[row + sx], sx, sy, scale, minX, minY, boxW);
    }
  }
  if (hasMaskBounds) {
    for (sy = maskMinY; sy <= maskMaxY; ++sy) {
      int row = sy * logicalW;
      for (sx = maskMinX; sx <= maskMaxX; ++sx) {
        int index = row + sx;
        if (mask[index] != 0) {
          mgl_write_scaled_overlay_pixel(
              palette, data[index], sx, sy, scale, minX, minY, boxW);
        }
      }
    }
  }
  return mgl_draw_overlay_box(texid, outputW, outputH, minX, minY, maxX, maxY);
}

__declspec(dllexport) BOOL __stdcall MGL_DrawIndexedOverlayRect(
    GLuint texid,
    const unsigned char *data,
    int dataSize,
    const unsigned char *mask,
    int maskSize,
    const unsigned char *palette,
    int width,
    int height,
    int minX,
    int minY,
    int maxX,
    int maxY) {
  int pixels;
  int boxW;
  int boxH;
  int x;
  int y;

  if (texid == 0 || data == NULL || mask == NULL || palette == NULL ||
      width <= 0 || height <= 0 || width > INT_MAX / height) {
    return FALSE;
  }
  pixels = width * height;
  if (dataSize < pixels || maskSize < pixels) {
    return FALSE;
  }
  if (minX < 0) minX = 0;
  if (minY < 0) minY = 0;
  if (maxX >= width) maxX = width - 1;
  if (maxY >= height) maxY = height - 1;
  if (maxX < minX || maxY < minY) {
    return FALSE;
  }
  boxW = maxX - minX + 1;
  boxH = maxY - minY + 1;
  if (!mgl_ensure_overlay_rgba(boxW, boxH)) {
    return FALSE;
  }

  for (y = 0; y < boxH; ++y) {
    int srcRow = (minY + y) * width + minX;
    int dstRow = y * boxW;
    for (x = 0; x < boxW; ++x) {
      int src = srcRow + x;
      int ro = (dstRow + x) * 4;
      if (mask[src] != 0) {
        int c = (int)data[src] * 3;
        g_overlayRgba[ro + 0] = palette[c + 0];
        g_overlayRgba[ro + 1] = palette[c + 1];
        g_overlayRgba[ro + 2] = palette[c + 2];
        g_overlayRgba[ro + 3] = 255;
      } else {
        g_overlayRgba[ro + 0] = 0;
        g_overlayRgba[ro + 1] = 0;
        g_overlayRgba[ro + 2] = 0;
        g_overlayRgba[ro + 3] = 0;
      }
    }
  }
  return mgl_draw_overlay_box(texid, width, height, minX, minY, maxX, maxY);
}

__declspec(dllexport) BOOL __stdcall MGL_DrawIndexedOverlay(
    GLuint texid,
    const unsigned char *data,
    const unsigned char *mask,
    const unsigned char *palette,
    int width,
    int height) {
  int pixels;
  int bytesNeeded;
  int minX;
  int minY;
  int maxX;
  int maxY;
  int boxW;
  int boxH;
  int i;
  int y;

  if (texid == 0 || data == NULL || mask == NULL || palette == NULL || width <= 0 || height <= 0) {
    return FALSE;
  }

  if (width > INT_MAX / height) {
    return FALSE;
  }
  pixels = width * height;
  minX = width;
  minY = height;
  maxX = -1;
  maxY = -1;
  for (i = 0; i < pixels; ++i) {
    if (mask[i] != 0) {
      int x = i % width;
      int y0 = i / width;
      if (x < minX) {
        minX = x;
      }
      if (x > maxX) {
        maxX = x;
      }
      if (y0 < minY) {
        minY = y0;
      }
      if (y0 > maxY) {
        maxY = y0;
      }
    }
  }
  if (maxX < minX || maxY < minY) {
    return FALSE;
  }

  boxW = maxX - minX + 1;
  boxH = maxY - minY + 1;
  if (boxW > INT_MAX / boxH || boxW * boxH > INT_MAX / 4) {
    return FALSE;
  }
  bytesNeeded = boxW * boxH * 4;
  if (g_overlayRgbaBytes < bytesNeeded) {
    unsigned char *newBuf = (unsigned char *)realloc(g_overlayRgba, (size_t)bytesNeeded);
    if (newBuf == NULL) {
      return FALSE;
    }
    g_overlayRgba = newBuf;
    g_overlayRgbaBytes = bytesNeeded;
  }

  for (y = 0; y < boxH; ++y) {
    int srcRow = (minY + y) * width + minX;
    int dstRow = y * boxW;
    int x;
    for (x = 0; x < boxW; ++x) {
      int src = srcRow + x;
      int ro = (dstRow + x) * 4;
      if (mask[src] != 0) {
        int c = data[src] * 3;
        g_overlayRgba[ro + 0] = palette[c + 0];
        g_overlayRgba[ro + 1] = palette[c + 1];
        g_overlayRgba[ro + 2] = palette[c + 2];
        g_overlayRgba[ro + 3] = 255;
      } else {
        g_overlayRgba[ro + 0] = 0;
        g_overlayRgba[ro + 1] = 0;
        g_overlayRgba[ro + 2] = 0;
        g_overlayRgba[ro + 3] = 0;
      }
    }
  }

  glBindTexture(GL_TEXTURE_2D, texid);
  glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, boxW, boxH, 0, GL_RGBA, GL_UNSIGNED_BYTE, g_overlayRgba);
  glBegin(GL_QUADS);
  glTexCoord2d(0.0, 0.0);
  glVertex3d(((double)minX / (double)width) * 2.0 - 1.0, 1.0 - ((double)minY / (double)height) * 2.0, 0.0);
  glTexCoord2d(1.0, 0.0);
  glVertex3d(((double)(maxX + 1) / (double)width) * 2.0 - 1.0, 1.0 - ((double)minY / (double)height) * 2.0, 0.0);
  glTexCoord2d(1.0, 1.0);
  glVertex3d(((double)(maxX + 1) / (double)width) * 2.0 - 1.0, 1.0 - ((double)(maxY + 1) / (double)height) * 2.0, 0.0);
  glTexCoord2d(0.0, 1.0);
  glVertex3d(((double)minX / (double)width) * 2.0 - 1.0, 1.0 - ((double)(maxY + 1) / (double)height) * 2.0, 0.0);
  glEnd();
  return TRUE;
}
