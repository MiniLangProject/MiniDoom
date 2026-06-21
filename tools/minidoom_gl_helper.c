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
#include <stddef.h>
#include <stdint.h>
#include <stdlib.h>
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

static void mgl_light_vertex(const int32_t *light, double x, double y, double z) {
  unsigned char a = mgl_light_alpha(light, x, y, z);
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
  int wallOff;
  int flatOff;
  int li;

  if (geomData == NULL || lightData == NULL || geomSize < headerSize || lightCount <= 0) {
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

  wallOff = headerSize + bc * quadSize;
  flatOff = wallOff + wc * quadSize + mc * quadSize;
  if (wallOff < headerSize || flatOff < wallOff || flatOff + fc * triSize > geomSize) {
    return FALSE;
  }

  glDisable(GL_TEXTURE_2D);
  glDisable(GL_ALPHA_TEST);
  glDepthMask(FALSE);
  glDepthFunc(GL_LEQUAL);
  glBlendFunc(GL_SRC_ALPHA, GL_ONE);

  for (li = 0; li < lightCount; ++li) {
    const int32_t *light = (const int32_t *)(lightData + li * 32);
    int i;

    glBegin(GL_QUADS);
    for (i = 0; i < wc; ++i) {
      const unsigned char *q = geomData + wallOff + i * quadSize;
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
      if (mgl_light_alpha(light, x0, y0, z0) == 0 &&
          mgl_light_alpha(light, x1, y1, z1) == 0 &&
          mgl_light_alpha(light, x2, y2, z2) == 0 &&
          mgl_light_alpha(light, x3, y3, z3) == 0) {
        continue;
      }
      mgl_light_vertex(light, x0, y0, z0);
      mgl_light_vertex(light, x1, y1, z1);
      mgl_light_vertex(light, x2, y2, z2);
      mgl_light_vertex(light, x3, y3, z3);
    }
    glEnd();

    glBegin(GL_TRIANGLES);
    for (i = 0; i < fc; ++i) {
      const unsigned char *t = geomData + flatOff + i * triSize;
      double x0 = mgl_read_geom(t + 8);
      double y0 = mgl_read_geom(t + 12);
      double z0 = mgl_read_geom(t + 16);
      double x1 = mgl_read_geom(t + 28);
      double y1 = mgl_read_geom(t + 32);
      double z1 = mgl_read_geom(t + 36);
      double x2 = mgl_read_geom(t + 48);
      double y2 = mgl_read_geom(t + 52);
      double z2 = mgl_read_geom(t + 56);
      if (mgl_light_alpha(light, x0, y0, z0) == 0 &&
          mgl_light_alpha(light, x1, y1, z1) == 0 &&
          mgl_light_alpha(light, x2, y2, z2) == 0) {
        continue;
      }
      mgl_light_vertex(light, x0, y0, z0);
      mgl_light_vertex(light, x1, y1, z1);
      mgl_light_vertex(light, x2, y2, z2);
    }
    glEnd();
  }

  glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
  glDepthFunc(GL_LESS);
  glDepthMask(TRUE);
  glEnable(GL_TEXTURE_2D);
  glColor4ub(255, 255, 255, 255);
  return TRUE;
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
