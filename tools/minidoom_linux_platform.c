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
#include <limits.h>
#include <math.h>
#include <stdint.h>
#include <stdatomic.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/socket.h>
#include <sys/stat.h>
#include <time.h>
#include <unistd.h>

#define MDL_EXPORT __attribute__((visibility("default")))
#define MDL_MIDI_RATE 48000
#define MDL_MIDI_CHANNELS 16
#define MDL_MIDI_VOICES 48
#define MDL_MIDI_SINE_SIZE 2048

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
  void (*callback)(void *, uint8_t *, int);
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
static SDL_AudioDeviceID g_midi_audio;
static void *g_fluid_library;
static void *g_fluid_settings;
static void *g_fluid_synth;
static uint8_t g_keys[256];
static uint8_t g_pressed[256];
static int g_mouse_x;
static int g_mouse_y;
static int g_mouse_buttons;
static int g_has_focus = 1;
static uint8_t *g_rgba;
static size_t g_rgba_capacity;

/* Per-channel controller state consumed by the built-in General MIDI synth. */
typedef struct MDL_MidiChannel {
  uint8_t program;
  uint8_t volume;
  uint8_t expression;
  uint8_t pan;
  uint16_t pitch_bend;
} MDL_MidiChannel;

/* One active oscillator including its envelope, stereo placement, and age. */
typedef struct MDL_MidiVoice {
  int active;
  int releasing;
  uint8_t channel;
  uint8_t note;
  uint8_t velocity;
  uint8_t waveform;
  float phase;
  float phase_step;
  float envelope;
  float attack_step;
  float decay;
  float release_decay;
  float filter_state;
  uint32_t noise;
  uint64_t age;
} MDL_MidiVoice;

static MDL_MidiChannel g_midi_channels[MDL_MIDI_CHANNELS];
static MDL_MidiVoice g_midi_voices[MDL_MIDI_VOICES];
static float g_midi_sine[MDL_MIDI_SINE_SIZE];
static float g_midi_master = 1.0f;
static uint64_t g_midi_age;
static int g_midi_tables_ready;
static int g_midi_started_logged;
static float g_midi_output_left;
static float g_midi_output_right;
static _Atomic uint32_t g_midi_debug_peak;

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
static void (*pSDL_LockAudioDevice)(SDL_AudioDeviceID);
static void (*pSDL_UnlockAudioDevice)(SDL_AudioDeviceID);

static void *(*pnew_fluid_settings)(void);
static void (*pdelete_fluid_settings)(void *);
static int (*pfluid_settings_setnum)(void *, const char *, double);
static int (*pfluid_settings_setint)(void *, const char *, int);
static void *(*pnew_fluid_synth)(void *);
static void (*pdelete_fluid_synth)(void *);
static int (*pfluid_synth_sfload)(void *, const char *, int);
static int (*pfluid_synth_noteon)(void *, int, int, int);
static int (*pfluid_synth_noteoff)(void *, int, int);
static int (*pfluid_synth_cc)(void *, int, int, int);
static int (*pfluid_synth_program_change)(void *, int, int);
static int (*pfluid_synth_pitch_bend)(void *, int, int);
static int (*pfluid_synth_system_reset)(void *);
static void (*pfluid_synth_set_gain)(void *, float);
static int (*pfluid_synth_write_s16)(void *, int, void *, int, int, void *, int, int);

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
  LOAD_SDL(SDL_LockAudioDevice);
  LOAD_SDL(SDL_UnlockAudioDevice);

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

/* Loads the FluidSynth ABI dynamically so Linux packages can carry the shared library beside MiniDoom. */
static int mdl_fluid_load_library(void) {
  if (g_fluid_library) return 1;
  g_fluid_library = dlopen("libfluidsynth.so.3", RTLD_NOW | RTLD_LOCAL);
  if (!g_fluid_library) g_fluid_library = dlopen("libfluidsynth.so", RTLD_NOW | RTLD_LOCAL);
  if (!g_fluid_library) return 0;
#define LOAD_FLUID(name) do { *(void **)(&p##name) = dlsym(g_fluid_library, #name); } while (0)
  LOAD_FLUID(new_fluid_settings);
  LOAD_FLUID(delete_fluid_settings);
  LOAD_FLUID(fluid_settings_setnum);
  LOAD_FLUID(fluid_settings_setint);
  LOAD_FLUID(new_fluid_synth);
  LOAD_FLUID(delete_fluid_synth);
  LOAD_FLUID(fluid_synth_sfload);
  LOAD_FLUID(fluid_synth_noteon);
  LOAD_FLUID(fluid_synth_noteoff);
  LOAD_FLUID(fluid_synth_cc);
  LOAD_FLUID(fluid_synth_program_change);
  LOAD_FLUID(fluid_synth_pitch_bend);
  LOAD_FLUID(fluid_synth_system_reset);
  LOAD_FLUID(fluid_synth_set_gain);
  LOAD_FLUID(fluid_synth_write_s16);
#undef LOAD_FLUID
  if (!pnew_fluid_settings || !pdelete_fluid_settings || !pfluid_settings_setnum ||
      !pfluid_settings_setint || !pnew_fluid_synth || !pdelete_fluid_synth ||
      !pfluid_synth_sfload || !pfluid_synth_noteon || !pfluid_synth_noteoff ||
      !pfluid_synth_cc || !pfluid_synth_program_change || !pfluid_synth_pitch_bend ||
      !pfluid_synth_system_reset || !pfluid_synth_set_gain || !pfluid_synth_write_s16) {
    dlclose(g_fluid_library);
    g_fluid_library = NULL;
    return 0;
  }
  return 1;
}

/* Finds an explicit, bundled, or distribution-provided General MIDI SoundFont. */
static const char *mdl_fluid_find_soundfont(char *path, size_t capacity) {
  const char *environment = getenv("MINIDOOM_SOUNDFONT");
  const char *local_candidates[] = {"MiniDoom.sf3", "MiniDoom.sf2", "TimGM6mb.sf2"};
  const char *system_candidates[] = {
    "/usr/share/sounds/sf3/MuseScore_General_Lite.sf3",
    "/usr/share/sounds/sf2/TimGM6mb.sf2",
    "/usr/share/soundfonts/TimGM6mb.sf2",
    "/usr/share/soundfonts/default.sf2"
  };
  char executable[PATH_MAX];
  ssize_t length;
  size_t i;
  if (environment && environment[0] && access(environment, R_OK) == 0) return environment;
  length = readlink("/proc/self/exe", executable, sizeof(executable) - 1);
  if (length > 0) {
    char *slash;
    executable[length] = '\0';
    slash = strrchr(executable, '/');
    if (slash) {
      size_t directory_length;
      *slash = '\0';
      directory_length = strlen(executable);
      for (i = 0; i < sizeof(local_candidates) / sizeof(local_candidates[0]); ++i) {
        size_t filename_length = strlen(local_candidates[i]);
        if (directory_length + filename_length + 2 > capacity) continue;
        memcpy(path, executable, directory_length);
        path[directory_length] = '/';
        memcpy(path + directory_length + 1, local_candidates[i], filename_length + 1);
        if (access(path, R_OK) == 0) return path;
      }
    }
  }
  for (i = 0; i < sizeof(system_candidates) / sizeof(system_candidates[0]); ++i) {
    if (access(system_candidates[i], R_OK) == 0) return system_candidates[i];
  }
  return NULL;
}

/* Releases every object owned by the dynamically loaded FluidSynth backend. */
static void mdl_fluid_shutdown(void) {
  if (g_fluid_synth && pdelete_fluid_synth) pdelete_fluid_synth(g_fluid_synth);
  if (g_fluid_settings && pdelete_fluid_settings) pdelete_fluid_settings(g_fluid_settings);
  g_fluid_synth = NULL;
  g_fluid_settings = NULL;
  if (g_fluid_library) dlclose(g_fluid_library);
  g_fluid_library = NULL;
}

/* Creates a deterministic headless FluidSynth instance and loads the selected GM bank. */
static int mdl_fluid_initialize(void) {
  char soundfont_path[PATH_MAX];
  const char *soundfont;
  if (g_fluid_synth) return 1;
  if (!mdl_fluid_load_library()) {
    fprintf(stderr, "MiniDoom Linux: FluidSynth library not found\n");
    return 0;
  }
  soundfont = mdl_fluid_find_soundfont(soundfont_path, sizeof(soundfont_path));
  if (!soundfont) {
    fprintf(stderr, "MiniDoom Linux: no GM SoundFont found (set MINIDOOM_SOUNDFONT)\n");
    mdl_fluid_shutdown();
    return 0;
  }
  g_fluid_settings = pnew_fluid_settings();
  if (!g_fluid_settings) {
    mdl_fluid_shutdown();
    return 0;
  }
  pfluid_settings_setnum(g_fluid_settings, "synth.sample-rate", (double)MDL_MIDI_RATE);
  pfluid_settings_setint(g_fluid_settings, "synth.polyphony", 64);
  pfluid_settings_setint(g_fluid_settings, "synth.reverb.active", 1);
  pfluid_settings_setint(g_fluid_settings, "synth.chorus.active", 0);
  g_fluid_synth = pnew_fluid_synth(g_fluid_settings);
  if (!g_fluid_synth || pfluid_synth_sfload(g_fluid_synth, soundfont, 1) < 0) {
    fprintf(stderr, "MiniDoom Linux: FluidSynth could not load %s\n", soundfont);
    mdl_fluid_shutdown();
    return 0;
  }
  pfluid_synth_set_gain(g_fluid_synth, 0.20f * g_midi_master);
  fprintf(stderr, "MiniDoom Linux: FluidSynth GM music enabled (%s)\n", soundfont);
  return 1;
}

/* Initializes the oscillator lookup table and General MIDI controller defaults. */
static void mdl_midi_initialize_tables(void) {
  int i;
  if (!g_midi_tables_ready) {
    for (i = 0; i < MDL_MIDI_SINE_SIZE; ++i) {
      g_midi_sine[i] = sinf((float)i * 6.2831853071795864769f / (float)MDL_MIDI_SINE_SIZE);
    }
    g_midi_tables_ready = 1;
  }
  for (i = 0; i < MDL_MIDI_CHANNELS; ++i) {
    g_midi_channels[i].program = 0;
    g_midi_channels[i].volume = 100;
    g_midi_channels[i].expression = 127;
    g_midi_channels[i].pan = 64;
    g_midi_channels[i].pitch_bend = 8192;
  }
}

/* Converts a MIDI note and channel bend into cycles per output sample. */
static float mdl_midi_phase_step(int note, uint16_t pitch_bend) {
  float bend = ((float)pitch_bend - 8192.0f) * (2.0f / 8192.0f);
  float semitones = (float)note - 69.0f + bend;
  float frequency = 440.0f * powf(2.0f, semitones / 12.0f);
  return frequency / (float)MDL_MIDI_RATE;
}

/* Chooses a compact oscillator family from a General MIDI program number. */
static uint8_t mdl_midi_program_waveform(uint8_t program) {
  if (program < 8) return 0;    /* pianos */
  if (program < 16) return 1;   /* chromatic percussion */
  if (program < 24) return 2;   /* organs */
  if (program < 32) return 1;   /* guitars */
  if (program < 40) return 6;   /* basses */
  if (program < 56) return 3;   /* strings and ensembles */
  if (program < 72) return 3;   /* brass and reeds */
  if (program < 80) return 0;   /* pipes */
  if (program < 88) return 2;   /* synth leads */
  if (program < 104) return 1;  /* pads and effects */
  if (program >= 112) return 7; /* tuned percussion and effects */
  return 3;
}

/* Configures attack and natural decay so instrument families remain distinct. */
static void mdl_midi_envelope(uint8_t program, float *attack, float *decay) {
  if (program >= 112) {
    *attack = 1.0f;
    *decay = 0.99935f;
  } else if (program < 8) {
    *attack = 1.0f;
    *decay = 0.99992f;
  } else if (program < 16) {
    *attack = 1.0f;
    *decay = 0.99972f;
  } else if (program < 24) {
    *attack = 0.02f;
    *decay = 0.999998f;
  } else if (program < 32) {
    *attack = 1.0f;
    *decay = 0.99988f;
  } else if (program < 40) {
    *attack = 0.08f;
    *decay = 0.99995f;
  } else if (program >= 40 && program < 56) {
    *attack = 0.0025f;
    *decay = 0.999998f;
  } else if (program >= 88 && program < 104) {
    *attack = 0.0015f;
    *decay = 0.999999f;
  } else {
    *attack = 0.015f;
    *decay = 0.999999f;
  }
}

/* Returns an unused voice or steals the quietest/oldest voice under saturation. */
static MDL_MidiVoice *mdl_midi_allocate_voice(void) {
  MDL_MidiVoice *best = &g_midi_voices[0];
  int i;
  for (i = 0; i < MDL_MIDI_VOICES; ++i) {
    MDL_MidiVoice *voice = &g_midi_voices[i];
    if (!voice->active) return voice;
    if ((voice->releasing && !best->releasing) ||
        (voice->releasing == best->releasing && voice->envelope < best->envelope) ||
        (voice->releasing == best->releasing && voice->envelope == best->envelope && voice->age < best->age)) {
      best = voice;
    }
  }
  return best;
}

/* Starts one melodic oscillator or a short percussion/noise voice. */
static void mdl_midi_note_on(int channel, int note, int velocity) {
  MDL_MidiChannel *state;
  MDL_MidiVoice *voice;
  float attack;
  float decay;
  if (channel < 0 || channel >= MDL_MIDI_CHANNELS || note < 0 || note > 127 || velocity <= 0) return;
  state = &g_midi_channels[channel];
  voice = mdl_midi_allocate_voice();
  memset(voice, 0, sizeof(*voice));
  voice->active = 1;
  voice->channel = (uint8_t)channel;
  voice->note = (uint8_t)note;
  voice->velocity = (uint8_t)velocity;
  voice->phase_step = mdl_midi_phase_step(note, state->pitch_bend);
  voice->release_decay = 0.99945f;
  voice->noise = 0x9E3779B9u ^ ((uint32_t)note << 16) ^ (uint32_t)++g_midi_age;
  voice->age = g_midi_age;
  if (channel == 9) {
    if (note == 35 || note == 36) {
      voice->waveform = 5;
      voice->phase_step = mdl_midi_phase_step(note == 35 ? 41 : 43, 8192);
      voice->decay = 0.99930f;
    } else if (note == 38 || note == 40) {
      voice->waveform = 4;
      voice->phase_step = mdl_midi_phase_step(note == 38 ? 50 : 53, 8192);
      voice->decay = 0.99915f;
    } else if (note == 41 || note == 43 || note == 45 || note == 47 || note == 48 || note == 50) {
      voice->waveform = 9;
      voice->phase_step = mdl_midi_phase_step(note + 7, 8192);
      voice->decay = 0.99935f;
    } else if (note == 42 || note == 44 || note == 46 || note == 49 || note == 51 ||
               note == 53 || note == 57 || note == 59) {
      voice->waveform = 8;
      voice->phase_step = mdl_midi_phase_step(note + 36, 8192);
      voice->decay = (note == 42 || note == 44) ? 0.9965f :
                     (note == 46 ? 0.99940f : 0.99965f);
    } else {
      voice->waveform = 4;
      voice->phase_step = mdl_midi_phase_step(55, 8192);
      voice->decay = 0.9988f;
    }
    voice->envelope = 1.0f;
    voice->attack_step = 1.0f;
    voice->release_decay = voice->decay;
    return;
  }
  voice->waveform = mdl_midi_program_waveform(state->program);
  mdl_midi_envelope(state->program, &attack, &decay);
  voice->attack_step = attack;
  voice->decay = decay;
  voice->envelope = attack >= 1.0f ? 1.0f : 0.0f;
}

/* Releases every matching note while preserving a short click-free tail. */
static void mdl_midi_note_off(int channel, int note) {
  int i;
  for (i = 0; i < MDL_MIDI_VOICES; ++i) {
    MDL_MidiVoice *voice = &g_midi_voices[i];
    if (voice->active && voice->channel == channel && voice->note == note) voice->releasing = 1;
  }
}

/* Stops all channel voices either immediately or through their release envelope. */
static void mdl_midi_all_notes(int channel, int immediate) {
  int i;
  for (i = 0; i < MDL_MIDI_VOICES; ++i) {
    MDL_MidiVoice *voice = &g_midi_voices[i];
    if (!voice->active || (channel >= 0 && voice->channel != channel)) continue;
    if (immediate) voice->active = 0;
    else voice->releasing = 1;
  }
}

/* Resets voices and controllers while retaining the current master volume. */
static void mdl_midi_reset_unlocked(void) {
  memset(g_midi_voices, 0, sizeof(g_midi_voices));
  mdl_midi_initialize_tables();
  g_midi_age = 0;
  g_midi_output_left = 0.0f;
  g_midi_output_right = 0.0f;
}

/* Reads the periodic sine table for an arbitrary wrapped oscillator phase. */
static float mdl_midi_sine_at(float phase) {
  int index = (int)(phase * (float)MDL_MIDI_SINE_SIZE) & (MDL_MIDI_SINE_SIZE - 1);
  return g_midi_sine[index];
}

/* Adds one harmonic only while it remains comfortably below Nyquist. */
static float mdl_midi_harmonic(const MDL_MidiVoice *voice, int multiple) {
  if (voice->phase_step * (float)multiple >= 0.45f) return 0.0f;
  return mdl_midi_sine_at(voice->phase * (float)multiple);
}

/* Evaluates one oscillator using smooth harmonics and filtered percussion noise. */
static float mdl_midi_voice_sample(MDL_MidiVoice *voice) {
  float sine;
  float sample;
  voice->phase += voice->phase_step;
  if (voice->phase >= 1.0f) voice->phase -= (float)(int)voice->phase;
  sine = mdl_midi_sine_at(voice->phase);
  switch (voice->waveform) {
    case 1:
      sample = sine * 0.78f + mdl_midi_harmonic(voice, 2) * 0.16f +
               mdl_midi_harmonic(voice, 3) * 0.06f;
      break;
    case 2:
      sample = sine * 0.70f + mdl_midi_harmonic(voice, 2) * 0.20f +
               mdl_midi_harmonic(voice, 3) * 0.10f;
      break;
    case 3:
      sample = sine * 0.82f + mdl_midi_harmonic(voice, 2) * 0.12f +
               mdl_midi_harmonic(voice, 4) * 0.06f;
      break;
    case 4: {
      float low;
      voice->noise = voice->noise * 1664525u + 1013904223u;
      sample = ((float)((voice->noise >> 8) & 0xFFFFu) / 32767.5f) - 1.0f;
      voice->filter_state += (sample - voice->filter_state) * 0.24f;
      low = voice->filter_state;
      sample = (sample - low) * 0.48f + low * 0.22f + sine * 0.30f;
      break;
    }
    case 5:
      sample = sine;
      voice->phase_step *= 0.99992f;
      break;
    case 6:
      sample = sine * 0.88f + mdl_midi_harmonic(voice, 2) * 0.12f;
      break;
    case 7:
      sample = sine * 0.76f + mdl_midi_harmonic(voice, 2) * 0.18f +
               mdl_midi_harmonic(voice, 3) * 0.06f;
      voice->phase_step *= 0.999995f;
      break;
    case 8: {
      float low;
      voice->noise = voice->noise * 1664525u + 1013904223u;
      sample = ((float)((voice->noise >> 8) & 0xFFFFu) / 32767.5f) - 1.0f;
      voice->filter_state += (sample - voice->filter_state) * 0.10f;
      low = voice->filter_state;
      sample = (sample - low) * 0.74f + sine * 0.16f + mdl_midi_harmonic(voice, 3) * 0.10f;
      break;
    }
    case 9:
      voice->noise = voice->noise * 1664525u + 1013904223u;
      sample = ((float)((voice->noise >> 8) & 0xFFFFu) / 32767.5f) - 1.0f;
      voice->filter_state += (sample - voice->filter_state) * 0.16f;
      sample = sine * 0.82f + voice->filter_state * 0.18f;
      voice->phase_step *= 0.99998f;
      break;
    default:
      sample = sine;
      break;
  }
  return sample;
}

/* Renders interleaved signed-16 stereo music for SDL's audio callback thread. */
static void mdl_midi_audio_callback(void *userdata, uint8_t *stream, int length) {
  int16_t *output = (int16_t *)stream;
  int frames = length / 4;
  int frame;
  (void)userdata;
  memset(stream, 0, (size_t)length);
  if (g_fluid_synth && pfluid_synth_write_s16) {
    uint32_t peak = 0;
    int sample_count = length / 2;
    int sample_index;
    pfluid_synth_write_s16(g_fluid_synth, frames, output, 0, 2, output, 1, 2);
    for (sample_index = 0; sample_index < sample_count; ++sample_index) {
      int value = output[sample_index];
      uint32_t magnitude = (uint32_t)(value < 0 ? -value : value);
      if (magnitude > peak) peak = magnitude;
    }
    {
      uint32_t old = atomic_load_explicit(&g_midi_debug_peak, memory_order_relaxed);
      while (peak > old && !atomic_compare_exchange_weak_explicit(
               &g_midi_debug_peak, &old, peak, memory_order_relaxed, memory_order_relaxed)) {}
    }
    return;
  }
  for (frame = 0; frame < frames; ++frame) {
    float left = 0.0f;
    float right = 0.0f;
    int i;
    for (i = 0; i < MDL_MIDI_VOICES; ++i) {
      MDL_MidiVoice *voice = &g_midi_voices[i];
      MDL_MidiChannel *channel;
      float sample;
      float gain;
      float voice_gain;
      float pan;
      if (!voice->active) continue;
      channel = &g_midi_channels[voice->channel];
      if (voice->envelope < 1.0f) {
        voice->envelope += voice->attack_step;
        if (voice->envelope > 1.0f) voice->envelope = 1.0f;
      }
      voice->envelope *= voice->releasing ? voice->release_decay : voice->decay;
      if (voice->envelope < 0.0005f) {
        voice->active = 0;
        continue;
      }
      sample = mdl_midi_voice_sample(voice);
      if (voice->channel == 9) {
        voice_gain = voice->waveform == 5 ? 0.24f :
                     (voice->waveform == 4 ? 0.16f :
                     (voice->waveform == 9 ? 0.18f : 0.11f));
      } else if (channel->program >= 32 && channel->program < 40) {
        voice_gain = 0.22f;
      } else if (channel->program >= 112) {
        voice_gain = 0.18f;
      } else if (channel->program >= 16 && channel->program < 24) {
        voice_gain = 0.13f;
      } else {
        voice_gain = 0.14f;
      }
      gain = voice->envelope * ((float)voice->velocity / 127.0f) *
             ((float)channel->volume / 127.0f) * ((float)channel->expression / 127.0f) *
             g_midi_master * voice_gain;
      pan = (float)channel->pan / 127.0f;
      left += sample * gain * (1.0f - pan);
      right += sample * gain * pan;
    }
    g_midi_output_left += (left - g_midi_output_left) * 0.72f;
    g_midi_output_right += (right - g_midi_output_right) * 0.72f;
    left = g_midi_output_left;
    right = g_midi_output_right;
    if (left > 1.0f) left = 1.0f;
    if (left < -1.0f) left = -1.0f;
    if (right > 1.0f) right = 1.0f;
    if (right < -1.0f) right = -1.0f;
    output[frame * 2] = (int16_t)(left * 32767.0f);
    output[frame * 2 + 1] = (int16_t)(right * 32767.0f);
    {
      uint32_t peak = (uint32_t)(fabsf(left) > fabsf(right) ? fabsf(left) * 32767.0f : fabsf(right) * 32767.0f);
      uint32_t old = atomic_load_explicit(&g_midi_debug_peak, memory_order_relaxed);
      while (peak > old && !atomic_compare_exchange_weak_explicit(
               &g_midi_debug_peak, &old, peak, memory_order_relaxed, memory_order_relaxed)) {}
    }
  }
}

/* Applies a packed MIDI message to the software-synth channel and voice state. */
static void mdl_midi_dispatch(uint32_t message) {
  int status = message & 0xFF;
  int command = status & 0xF0;
  int channel = status & 0x0F;
  int data1 = (message >> 8) & 0x7F;
  int data2 = (message >> 16) & 0x7F;
  MDL_MidiChannel *state = &g_midi_channels[channel];
  int i;
  if (g_fluid_synth) {
    if (command == 0x80 || (command == 0x90 && data2 == 0)) {
      pfluid_synth_noteoff(g_fluid_synth, channel, data1);
    } else if (command == 0x90) {
      if (!g_midi_started_logged) {
        fprintf(stderr, "MiniDoom Linux: MUS playback started\n");
        g_midi_started_logged = 1;
      }
      pfluid_synth_noteon(g_fluid_synth, channel, data1, data2);
    } else if (command == 0xB0) {
      pfluid_synth_cc(g_fluid_synth, channel, data1, data2);
    } else if (command == 0xC0) {
      pfluid_synth_program_change(g_fluid_synth, channel, data1);
    } else if (command == 0xE0) {
      pfluid_synth_pitch_bend(g_fluid_synth, channel, data1 | (data2 << 7));
    }
    return;
  }
  if (command == 0x80 || (command == 0x90 && data2 == 0)) {
    mdl_midi_note_off(channel, data1);
  } else if (command == 0x90) {
    if (!g_midi_started_logged) {
      fprintf(stderr, "MiniDoom Linux: MUS playback started\n");
      g_midi_started_logged = 1;
    }
    mdl_midi_note_on(channel, data1, data2);
  } else if (command == 0xB0) {
    if (data1 == 7) state->volume = (uint8_t)data2;
    else if (data1 == 10) state->pan = (uint8_t)data2;
    else if (data1 == 11) state->expression = (uint8_t)data2;
    else if (data1 == 120) mdl_midi_all_notes(channel, 1);
    else if (data1 == 123) mdl_midi_all_notes(channel, 0);
    else if (data1 == 121) {
      state->volume = 100;
      state->expression = 127;
      state->pan = 64;
      state->pitch_bend = 8192;
    }
  } else if (command == 0xC0) {
    state->program = (uint8_t)data1;
  } else if (command == 0xE0) {
    state->pitch_bend = (uint16_t)(data1 | (data2 << 7));
    for (i = 0; i < MDL_MIDI_VOICES; ++i) {
      MDL_MidiVoice *voice = &g_midi_voices[i];
      if (voice->active && voice->channel == channel && channel != 9) {
        voice->phase_step = mdl_midi_phase_step(voice->note, state->pitch_bend);
      }
    }
  }
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
  if (g_midi_audio && pSDL_CloseAudioDevice) pSDL_CloseAudioDevice(g_midi_audio);
  g_midi_audio = 0;
  mdl_fluid_shutdown();
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

/* Allocates zero-filled storage using GlobalAlloc's flags-plus-size calling convention. */
MDL_EXPORT void *MDL_GlobalAlloc(uint32_t flags, uint32_t size) {
  (void)flags;
  return calloc(1, size > 0 ? (size_t)size : 1u);
}

/* Frees GlobalAlloc-compatible storage and mirrors GlobalFree's null success value. */
MDL_EXPORT void *MDL_GlobalFree(void *memory) {
  free(memory);
  return NULL;
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
  if (pSDL_Init(SDL_INIT_TIMER | SDL_INIT_AUDIO) != 0) {
    fprintf(stderr, "MiniDoom Linux: SDL sound-effects audio init failed: %s\n",
            pSDL_GetError ? pSDL_GetError() : "unknown");
    return 1;
  }
  memset(&wanted, 0, sizeof(wanted));
  wanted.freq = format ? mdl_read_i32(format, 4) : 11025;
  wanted.format = AUDIO_S16LSB;
  wanted.channels = format ? format[2] : 2;
  wanted.samples = 512;
  g_audio = pSDL_OpenAudioDevice(NULL, 0, &wanted, NULL, 0);
  if (!g_audio) {
    fprintf(stderr, "MiniDoom Linux: SDL sound-effects device failed: %s\n",
            pSDL_GetError ? pSDL_GetError() : "unknown");
    return 1;
  }
  pSDL_PauseAudioDevice(g_audio, 0);
  memset(handle_output, 0, 8);
  mdl_write_u64(handle_output, 0, g_audio);
  g_pending_count = 0;
  g_audio_submitted = 0;
  fprintf(stderr, "MiniDoom Linux: SDL sound-effects mixer enabled (%d Hz, %d channels)\n",
          wanted.freq, wanted.channels);
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

/* Opens the built-in SDL software synthesizer used by Doom's MUS sequencer. */
MDL_EXPORT uint32_t MDL_midiOutOpen(void *handle_output, uint32_t device, void *callback, void *instance, uint32_t flags) {
  SDL_AudioSpec wanted;
  (void)device; (void)callback; (void)instance; (void)flags;
  if (!handle_output || !mdl_load_libraries() || !pSDL_OpenAudioDevice ||
      !pSDL_PauseAudioDevice || !pSDL_LockAudioDevice || !pSDL_UnlockAudioDevice) return 1;
  if (g_midi_audio) {
    mdl_write_u64(handle_output, 0, g_midi_audio);
    return 0;
  }
  if (pSDL_Init(SDL_INIT_TIMER | SDL_INIT_AUDIO) != 0) {
    fprintf(stderr, "MiniDoom Linux: SDL MIDI audio init failed: %s\n",
            pSDL_GetError ? pSDL_GetError() : "unknown");
    return 1;
  }
  memset(&wanted, 0, sizeof(wanted));
  wanted.freq = MDL_MIDI_RATE;
  wanted.format = AUDIO_S16LSB;
  wanted.channels = 2;
  wanted.samples = 2048;
  wanted.callback = mdl_midi_audio_callback;
  if (!mdl_fluid_initialize()) return 1;
  mdl_midi_initialize_tables();
  mdl_midi_reset_unlocked();
  g_midi_started_logged = 0;
  atomic_store_explicit(&g_midi_debug_peak, 0, memory_order_relaxed);
  g_midi_audio = pSDL_OpenAudioDevice(NULL, 0, &wanted, NULL, 0);
  if (!g_midi_audio) {
    fprintf(stderr, "MiniDoom Linux: SDL software MIDI synth failed: %s\n",
            pSDL_GetError ? pSDL_GetError() : "unknown");
    mdl_fluid_shutdown();
    return 1;
  }
  mdl_write_u64(handle_output, 0, g_midi_audio);
  pSDL_PauseAudioDevice(g_midi_audio, 0);
  fprintf(stderr, "MiniDoom Linux: SDL FluidSynth output enabled\n");
  return 0;
}

/* Applies one packed General MIDI message while the SDL callback is locked. */
MDL_EXPORT uint32_t MDL_midiOutShortMsg(void *handle, uint32_t message) {
  (void)handle;
  if (!g_midi_audio) return 1;
  pSDL_LockAudioDevice(g_midi_audio);
  mdl_midi_dispatch(message);
  pSDL_UnlockAudioDevice(g_midi_audio);
  return 0;
}

/* Silences every voice and restores General MIDI controller defaults. */
MDL_EXPORT uint32_t MDL_midiOutReset(void *handle) {
  (void)handle;
  if (!g_midi_audio) return 0;
  pSDL_LockAudioDevice(g_midi_audio);
  if (g_fluid_synth) pfluid_synth_system_reset(g_fluid_synth);
  else mdl_midi_reset_unlocked();
  pSDL_UnlockAudioDevice(g_midi_audio);
  return 0;
}

/* Stops and closes the SDL music device owned by the software synthesizer. */
MDL_EXPORT uint32_t MDL_midiOutClose(void *handle) {
  (void)handle;
  if (!g_midi_audio) return 0;
  pSDL_PauseAudioDevice(g_midi_audio, 1);
  pSDL_CloseAudioDevice(g_midi_audio);
  g_midi_audio = 0;
  memset(g_midi_voices, 0, sizeof(g_midi_voices));
  mdl_fluid_shutdown();
  return 0;
}

/* Converts WinMM's packed stereo volume into the software synth master gain. */
MDL_EXPORT uint32_t MDL_midiOutSetVolume(void *handle, uint32_t volume) {
  uint32_t left = volume & 0xFFFFu;
  uint32_t right = (volume >> 16) & 0xFFFFu;
  (void)handle;
  if (!g_midi_audio) return 0;
  pSDL_LockAudioDevice(g_midi_audio);
  g_midi_master = ((float)left + (float)right) / 131070.0f;
  if (g_fluid_synth) pfluid_synth_set_gain(g_fluid_synth, 0.20f * g_midi_master);
  pSDL_UnlockAudioDevice(g_midi_audio);
  return 0;
}

/* Returns the largest synthesized sample magnitude for native regression tests. */
MDL_EXPORT uint32_t MDL_MidiDebugPeak(void) {
  return atomic_load_explicit(&g_midi_debug_peak, memory_order_relaxed);
}
