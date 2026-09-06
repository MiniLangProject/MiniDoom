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

*/

//! Mixes Doom sound effects into platform PCM buffers and translates MUS music events to the active MIDI
//! backend.

import doomdef
import doomstat
import sounds
import z_zone
import i_system
import i_sound
import m_argv
import m_misc
import w_wad
import doomdef
import std.math
#if TARGET_OS == "linux"
import platform_linux
#endif

#if TARGET_OS == "windows"
/// Opens the WinMM waveform mapper with the supplied PCM format and writes the device handle to caller storage.
/// @param phwo `bytes` value supplied as phwo to `waveOutOpen`.
/// @param dev `u32` value supplied as dev to `waveOutOpen`.
/// @param pwfx Native wave-format descriptor.
/// @param cb `ptr` value supplied as cb to `waveOutOpen`.
/// @param inst `ptr` value supplied as inst to `waveOutOpen`.
/// @param flags Bit flags that control the operation.
/// @returns Result returned by the native `waveOutOpen` binding as `u32`.

extern function waveOutOpen(phwo as bytes, dev as u32, pwfx as bytes, cb as ptr, inst as ptr, flags as u32) from "winmm.dll" symbol "waveOutOpen" returns u32

/// Registers one unmanaged WAVEHDR with an open waveform device before queued playback.
/// @param hwo `ptr` value supplied as hwo to `waveOutPrepareHeader`.
/// @param pwh `ptr` value supplied as pwh to `waveOutPrepareHeader`.
/// @param cbwh `u32` value supplied as cbwh to `waveOutPrepareHeader`.
/// @returns Result returned by the native `waveOutPrepareHeader` binding as `u32`.

extern function waveOutPrepareHeader(hwo as ptr, pwh as ptr, cbwh as u32) from "winmm.dll" symbol "waveOutPrepareHeader" returns u32

/// Queues a prepared WAVEHDR buffer for asynchronous playback on the waveform device.
/// @param hwo `ptr` value supplied as hwo to `waveOutWrite`.
/// @param pwh `ptr` value supplied as pwh to `waveOutWrite`.
/// @param cbwh `u32` value supplied as cbwh to `waveOutWrite`.
/// @returns Result returned by the native `waveOutWrite` binding as `u32`.

extern function waveOutWrite(hwo as ptr, pwh as ptr, cbwh as u32) from "winmm.dll" symbol "waveOutWrite" returns u32

/// Releases WinMM ownership of a completed WAVEHDR before its unmanaged memory is freed.
/// @param hwo `ptr` value supplied as hwo to `waveOutUnprepareHeader`.
/// @param pwh `ptr` value supplied as pwh to `waveOutUnprepareHeader`.
/// @param cbwh `u32` value supplied as cbwh to `waveOutUnprepareHeader`.
/// @returns Result returned by the native `waveOutUnprepareHeader` binding as `u32`.

extern function waveOutUnprepareHeader(hwo as ptr, pwh as ptr, cbwh as u32) from "winmm.dll" symbol "waveOutUnprepareHeader" returns u32

/// Stops waveform playback and returns all queued buffers to the application.
/// @param hwo `ptr` value supplied as hwo to `waveOutReset`.
/// @returns Result returned by the native `waveOutReset` binding as `u32`.

extern function waveOutReset(hwo as ptr) from "winmm.dll" symbol "waveOutReset" returns u32

/// Closes a reset waveform output handle after all headers have been unprepared.
/// @param hwo `ptr` value supplied as hwo to `waveOutClose`.
/// @returns Result returned by the native `waveOutClose` binding as `u32`.

extern function waveOutClose(hwo as ptr) from "winmm.dll" symbol "waveOutClose" returns u32

/// Opens the Windows MIDI mapper and writes its output handle to caller-owned storage.
/// @param phmo `bytes` value supplied as phmo to `midiOutOpen`.
/// @param dev `u32` value supplied as dev to `midiOutOpen`.
/// @param cb `ptr` value supplied as cb to `midiOutOpen`.
/// @param inst `ptr` value supplied as inst to `midiOutOpen`.
/// @param flags Bit flags that control the operation.
/// @returns Result returned by the native `midiOutOpen` binding as `u32`.

extern function midiOutOpen(phmo as bytes, dev as u32, cb as ptr, inst as ptr, flags as u32) from "winmm.dll" symbol "midiOutOpen" returns u32

/// Sends one packed channel/system MIDI message to the active output device.
/// @param hmo `ptr` value supplied as hmo to `midiOutShortMsg`.
/// @param msg `u32` value supplied as msg to `midiOutShortMsg`.
/// @returns Result returned by the native `midiOutShortMsg` binding as `u32`.

extern function midiOutShortMsg(hmo as ptr, msg as u32) from "winmm.dll" symbol "midiOutShortMsg" returns u32

/// Silences and resets every channel on the active Windows MIDI output device.
/// @param hmo `ptr` value supplied as hmo to `midiOutReset`.
/// @returns Result returned by the native `midiOutReset` binding as `u32`.

extern function midiOutReset(hmo as ptr) from "winmm.dll" symbol "midiOutReset" returns u32

/// Closes the Windows MIDI output handle after playback has stopped.
/// @param hmo `ptr` value supplied as hmo to `midiOutClose`.
/// @returns Result returned by the native `midiOutClose` binding as `u32`.

extern function midiOutClose(hmo as ptr) from "winmm.dll" symbol "midiOutClose" returns u32

/// Applies a packed left/right 16-bit master volume to the MIDI output device.
/// @param hmo `ptr` value supplied as hmo to `midiOutSetVolume`.
/// @param vol `u32` value supplied as vol to `midiOutSetVolume`.
/// @returns Result returned by the native `midiOutSetVolume` binding as `u32`.

extern function midiOutSetVolume(hmo as ptr, vol as u32) from "winmm.dll" symbol "midiOutSetVolume" returns u32

/// Allocates fixed-address unmanaged storage for WinMM sample buffers and WAVEHDR records.
/// @param flags Bit flags that control the operation.
/// @param size Requested size in bytes or elements.
/// @returns The resulting fixed-address unmanaged storage for WinMM sample buffers and WAVEHDR records.

extern function GlobalAlloc(flags as u32, size as u32) from "kernel32.dll" symbol "GlobalAlloc" returns ptr

/// Releases unmanaged WinMM buffer/header storage and returns null on success.
/// @param mem `ptr` value supplied as mem to `GlobalFree`.
/// @returns Result returned by the native `GlobalFree` binding as `ptr`.

extern function GlobalFree(mem as ptr) from "kernel32.dll" symbol "GlobalFree" returns ptr

/// Copies a managed byte buffer into fixed unmanaged WinMM storage.
/// @param dst `ptr` value supplied as dst to `RtlMoveMemoryToPtr`.
/// @param src `bytes` value supplied as src to `RtlMoveMemoryToPtr`.
/// @param len `u32` value supplied as len to `RtlMoveMemoryToPtr`.
extern function RtlMoveMemoryToPtr(dst as ptr, src as bytes, len as u32) from "kernel32.dll" symbol "RtlMoveMemory" returns void

/// Copies an unmanaged WAVEHDR record into managed bytes for flag inspection.
/// @param dst `bytes` value supplied as dst to `RtlMoveMemoryFromPtr`.
/// @param src `ptr` value supplied as src to `RtlMoveMemoryFromPtr`.
/// @param len `u32` value supplied as len to `RtlMoveMemoryFromPtr`.
extern function RtlMoveMemoryFromPtr(dst as bytes, src as ptr, len as u32) from "kernel32.dll" symbol "RtlMoveMemory" returns void
#endif

/// Defines is mix rate for the i sound subsystem.
/// @internal
const _IS_MIX_RATE = 11025
/// Defines is mix samples for the i sound subsystem.
/// @internal
const _IS_MIX_SAMPLES = 512
/// Defines is mix buf bytes for the i sound subsystem.
/// @internal
const _IS_MIX_BUF_BYTES = _IS_MIX_SAMPLES * 4
/// Defines the is num mix channels count used by the i sound subsystem.
/// @internal
const _IS_NUM_MIX_CHANNELS = 8
/// Defines the is num wave bufs count used by the i sound subsystem.
/// @internal
const _IS_NUM_WAVE_BUFS = 4
/// Defines is wavehdr size for the i sound subsystem.
/// @internal
const _IS_WAVEHDR_SIZE = 48
/// Defines is whdr done for the i sound subsystem.
/// @internal
const _IS_WHDR_DONE = 0x00000001
/// Defines is wave mapper for the i sound subsystem.
/// @internal
const _IS_WAVE_MAPPER = 0xFFFFFFFF
/// Defines is midi mapper for the i sound subsystem.
/// @internal
const _IS_MIDI_MAPPER = 0xFFFFFFFF
/// Defines is gmem fixed for the i sound subsystem.
/// @internal
const _IS_GMEM_FIXED = 0x0000

/// Owns one unmanaged PCM data block and WAVEHDR plus its in-flight submission flag.
/// @internal
struct _I_wavebuf_t
  /// Stores data ptr for `_I_wavebuf_t`
  dataPtr
  /// Stores hdr ptr for `_I_wavebuf_t`
  hdrPtr
  /// Stores submitted for `_I_wavebuf_t`
  submitted
end struct

/// Tracks the mutable i next handle value used by the i sound subsystem.
/// @internal
_I_nextHandle = 1
/// Tracks the mutable i sfx volume value used by the i sound subsystem.
/// @internal
_I_sfxVolume = 127
/// Stores the lengths collection used by the i sound subsystem.
lengths =[]

/// Stores the i step table collection used by the i sound subsystem.
/// @internal
_I_stepTable =[]
/// Stores the i mix scale table collection used by the i sound subsystem.
/// @internal
_I_mixScaleTable =[]
/// Stores the i sfx rates collection used by the i sound subsystem.
/// @internal
_I_sfxRates =[]
/// Stores the i sfx samples collection used by the i sound subsystem.
/// @internal
_I_sfxSamples =[]

/// Stores the i ch active collection used by the i sound subsystem.
/// @internal
_I_chActive =[]
/// Stores the i ch handle collection used by the i sound subsystem.
/// @internal
_I_chHandle =[]
/// Stores the i ch id collection used by the i sound subsystem.
/// @internal
_I_chId =[]
/// Stores the i ch data collection used by the i sound subsystem.
/// @internal
_I_chData =[]
/// Stores the i ch len collection used by the i sound subsystem.
/// @internal
_I_chLen =[]
/// Stores the i ch pos collection used by the i sound subsystem.
/// @internal
_I_chPos =[]
/// Stores the i ch frac collection used by the i sound subsystem.
/// @internal
_I_chFrac =[]
/// Stores the i ch step collection used by the i sound subsystem.
/// @internal
_I_chStep =[]
/// Stores the i ch start collection used by the i sound subsystem.
/// @internal
_I_chStart =[]
/// Stores the i ch left vol collection used by the i sound subsystem.
/// @internal
_I_chLeftVol =[]
/// Stores the i ch right vol collection used by the i sound subsystem.
/// @internal
_I_chRightVol =[]

/// Stores the i wave buffers collection used by the i sound subsystem.
/// @internal
_I_waveBuffers =[]
/// Tracks the mutable i wave handle value used by the i sound subsystem.
/// @internal
_I_waveHandle = 0
/// Tracks whether i wave ready is active in the i sound subsystem.
/// @internal
_I_waveReady = false

/// Tracks the mutable i mix scratch value used by the i sound subsystem.
/// @internal
_I_mixScratch = bytes(_IS_MIX_BUF_BYTES, 0)

/// Tracks the mutable i music volume value used by the i sound subsystem.
/// @internal
_I_musicVolume = 127
/// Tracks the mutable i next song handle value used by the i sound subsystem.
/// @internal
_I_nextSongHandle = 1000
/// Stores the i song data collection used by the i sound subsystem.
/// @internal
_I_songData =[]
/// Tracks the mutable i current song handle value used by the i sound subsystem.
/// @internal
_I_currentSongHandle = -1

/// Tracks the mutable i midi handle value used by the i sound subsystem.
/// @internal
_I_midiHandle = 0
/// Holds the optional i music data resource used by the i sound subsystem.
/// @internal
_I_musicData = void
/// Tracks whether i music playing is active in the i sound subsystem.
/// @internal
_I_musicPlaying = false
/// Tracks whether i music paused is active in the i sound subsystem.
/// @internal
_I_musicPaused = false
/// Tracks whether i music looping is active in the i sound subsystem.
/// @internal
_I_musicLooping = false
/// Tracks the mutable i music score start value used by the i sound subsystem.
/// @internal
_I_musicScoreStart = 0
/// Tracks the mutable i music score end value used by the i sound subsystem.
/// @internal
_I_musicScoreEnd = 0
/// Tracks the mutable i music pos value used by the i sound subsystem.
/// @internal
_I_musicPos = 0
/// Tracks the mutable i music delay value used by the i sound subsystem.
/// @internal
_I_musicDelay = 0
/// Tracks the mutable i music last ms value used by the i sound subsystem.
/// @internal
_I_musicLastMs = 0
/// Tracks the mutable i music ms frac value used by the i sound subsystem.
/// @internal
_I_musicMsFrac = 0

/// Stores the i music chan vel collection used by the i sound subsystem.
/// @internal
_I_musicChanVel =[]
/// Stores the i music chan map collection used by the i sound subsystem.
/// @internal
_I_musicChanMap =[]
/// Stores the i music used midi collection used by the i sound subsystem.
/// @internal
_I_musicUsedMidi =[]
/// Tracks whether i midi dbg printed is active in the i sound subsystem.
/// @internal
_I_midiDbgPrinted = false

/// Tracks whether i sound timer enabled is active in the i sound subsystem.
/// @internal
_I_soundTimerEnabled = false

/// Accepts either array or list storage used by translated audio tables.
/// @param v Value consumed by the operation.
/// @internal
function inline _IS_IsSeq(v)
  t = typeof(v)
  return t == "array" or t == "list"
end function

/// Converts numeric or numeric-string values by truncating toward zero, otherwise returning the supplied
/// fallback.
/// @param v Value consumed by the operation.
/// @param fallback Value returned when the requested conversion or lookup is unavailable.
/// @internal
function inline _IS_ToInt(v, fallback)
  if typeof(v) == "int" then return v end if
  if typeof(v) == "float" then
    if v >= 0 then return std.math.floor(v) end if
    return std.math.ceil(v)
  end if

  n = toNumber(v)
  if typeof(n) == "int" then return n end if
  if typeof(n) == "float" then
    if n >= 0 then return std.math.floor(n) end if
    return std.math.ceil(n)
  end if

  return fallback
end function

/// Divides mixer integers with truncation toward zero and returns zero for a zero divisor.
/// @param a First input operand.
/// @param b Second input operand.
/// @internal
function inline _ISnd_IDiv(a, b)
  ai = _IS_ToInt(a, 0)
  bi = _IS_ToInt(b, 0)
  if bi == 0 then return 0 end if
  q = ai / bi
  if q >= 0 then return std.math.floor(q) end if
  return std.math.ceil(q)
end function

/// Converts and clamps a scalar to an inclusive mixer/MIDI range.
/// @param v Value consumed by the operation.
/// @param lo Inclusive lower bound.
/// @param hi Inclusive upper bound.
/// @internal
function inline _IS_Clamp(v, lo, hi)
  n = _IS_ToInt(v, lo)
  if n < lo then n = lo end if
  if n > hi then n = hi end if
  return n
end function

/// Converts legacy 0..15 Doom volume values to 0..127 while accepting already normalized MIDI-scale values.
/// @param v Value consumed by the operation.
/// @internal
function inline _IS_NormalizeVolume127(v)
  n = _IS_Clamp(v, 0, 127)
  if n <= 15 then
    return _ISnd_IDiv(n * 127, 15)
  end if
  return n
end function

/// Applies Doom's quadratic separation curve and returns clamped left/right 0..127 channel gains.
/// @param vol127 Vol127 value supplied to `_IS_CalcStereoVolumes`.
/// @param sep Sep value supplied to `_IS_CalcStereoVolumes`.
/// @internal
function inline _IS_CalcStereoVolumes(vol127, sep)
  v = _IS_Clamp(vol127, 0, 127)
  s = _IS_Clamp(sep, 0, 255) + 1

  left = v -((v * s * s) >> 16)
  s2 = s - 257
  right = v -((v * s2 * s2) >> 16)

  left = _IS_Clamp(left, 0, 127)
  right = _IS_Clamp(right, 0, 127)
  return [left, right]
end function

/// Writes one non-negative unsigned 16-bit value in little-endian order to a WinMM structure buffer.
/// @param buf Buf value supplied to `_IS_WriteU16`.
/// @param off Zero-based byte or element offset.
/// @param value Value consumed by the operation.
/// @internal
function inline _IS_WriteU16(buf, off, value)
  if typeof(buf) != "bytes" then return end if
  v = _IS_ToInt(value, 0)
  if v < 0 then v = 0 end if
  buf[off] = v & 255
  buf[off + 1] =(v >> 8) & 255
end function

/// Writes one non-negative unsigned 32-bit value in little-endian order to a WinMM structure buffer.
/// @param buf Buf value supplied to `_IS_WriteU32`.
/// @param off Zero-based byte or element offset.
/// @param value Value consumed by the operation.
/// @internal
function inline _IS_WriteU32(buf, off, value)
  if typeof(buf) != "bytes" then return end if
  v = _IS_ToInt(value, 0)
  if v < 0 then v = 0 end if
  buf[off] = v & 255
  buf[off + 1] =(v >> 8) & 255
  buf[off + 2] =(v >> 16) & 255
  buf[off + 3] =(v >> 24) & 255
end function

/// Writes a pointer-sized 64-bit value as two little-endian words in a WinMM structure buffer.
/// @param buf Buf value supplied to `_IS_WriteU64`.
/// @param off Zero-based byte or element offset.
/// @param value Value consumed by the operation.
/// @internal
function inline _IS_WriteU64(buf, off, value)
  if typeof(buf) != "bytes" then return end if
  v = _IS_ToInt(value, 0)
  lo = v & 0xFFFFFFFF
  hi =(v >> 32) & 0xFFFFFFFF
  _IS_WriteU32(buf, off, lo)
  _IS_WriteU32(buf, off + 4, hi)
end function

/// Reads a checked unsigned little-endian 16-bit field, returning zero outside the buffer.
/// @param buf Buf value supplied to `_IS_ReadU16`.
/// @param off Zero-based byte or element offset.
/// @internal
function inline _IS_ReadU16(buf, off)
  if typeof(buf) != "bytes" then return 0 end if
  if typeof(off) != "int" then return 0 end if
  if off < 0 or(off + 1) >= len(buf) then return 0 end if
  return buf[off] +(buf[off + 1] << 8)
end function

/// Reads a checked unsigned little-endian 32-bit field, returning zero outside the buffer.
/// @param buf Buf value supplied to `_IS_ReadU32`.
/// @param off Zero-based byte or element offset.
/// @internal
function inline _IS_ReadU32(buf, off)
  if typeof(buf) != "bytes" then return 0 end if
  if typeof(off) != "int" then return 0 end if
  if off < 0 or(off + 3) >= len(buf) then return 0 end if
  return buf[off] +(buf[off + 1] << 8) +(buf[off + 2] << 16) +(buf[off + 3] << 24)
end function

/// Reconstructs a pointer-sized little-endian value from two checked 32-bit words.
/// @param buf Buf value supplied to `_IS_ReadU64`.
/// @param off Zero-based byte or element offset.
/// @internal
function inline _IS_ReadU64(buf, off)
  lo = _IS_ReadU32(buf, off)
  hi = _IS_ReadU32(buf, off + 4)
  return lo +(hi << 32)
end function

/// Converts enum-compatible integer values without accepting fractional numbers.
/// @param v Value consumed by the operation.
/// @param fallback Value returned when the requested conversion or lookup is unavailable.
/// @internal
function inline _IS_EnumIndex(v, fallback)
  if typeof(v) == "int" then return v end if
  n = toNumber(v)
  if typeof(n) == "int" then return n end if
  return fallback
end function

/// Returns the platform millisecond clock used to schedule MUS playback.
/// @internal
function inline _IS_TickMs()
  if typeof(_I_GetTickCount) == "function" then
    return _IS_ToInt(_I_GetTickCount(), 0)
  end if
  return 0
end function

/// Resizes per-SFX rate/sample/length caches to the metadata table while preserving existing entries.
/// @internal
function _IS_EnsureSfxCacheSize()
  global _I_sfxRates
  global _I_sfxSamples
  global lengths

  target = 1
  if _IS_IsSeq(S_sfx) and len(S_sfx) > 0 then target = len(S_sfx) end if

  if _IS_IsSeq(_I_sfxRates) and _IS_IsSeq(_I_sfxSamples) and _IS_IsSeq(lengths) and len(_I_sfxRates) == target and len(_I_sfxSamples) == target and len(lengths) == target then
    return
  end if

  oldRates = _I_sfxRates
  oldSamples = _I_sfxSamples
  oldLengths = lengths

  _I_sfxRates = array(target, _IS_MIX_RATE)
  _I_sfxSamples = array(target)
  lengths = array(target, 0)

  i = 0
  while i < target
    if _IS_IsSeq(oldRates) and i < len(oldRates) then
      _I_sfxRates[i] = _IS_ToInt(oldRates[i], _IS_MIX_RATE)
    end if

    if _IS_IsSeq(oldSamples) and i < len(oldSamples) then
      _I_sfxSamples[i] = oldSamples[i]
    end if

    if _IS_IsSeq(oldLengths) and i < len(oldLengths) then
      lengths[i] = _IS_ToInt(oldLengths[i], 0)
    end if
    i = i + 1
  end while
end function

/// Precomputes 16.16 pitch steps for every signed Doom pitch offset.
/// @internal
function inline _IS_InitStepTable()
  global _I_stepTable

  if _IS_IsSeq(_I_stepTable) and len(_I_stepTable) == 256 then return end if

  _I_stepTable = array(256, 0)
  i = 0
  while i < 256
    expn =(i - 128) / 64.0
    stepf = std.math.pow(2.0, expn) * 65536.0
    step = _IS_ToInt(stepf, 65536)
    if step < 1 then step = 1 end if
    _I_stepTable[i] = step
    i = i + 1
  end while
end function

/// Precomputes exact 8-bit sample scaling so the mixer can avoid per-sample division.
/// @internal
function inline _IS_InitMixScaleTable()
  global _I_mixScaleTable

  if _IS_IsSeq(_I_mixScaleTable) and len(_I_mixScaleTable) == 128 * 256 then return end if

  _I_mixScaleTable = array(128 * 256, 0)
  v = 0
  while v < 128
    base = v << 8
    s = 0
    while s < 256
      _I_mixScaleTable[base + s] = _ISnd_IDiv(v * (s - 128) * 256, 127)
      s = s + 1
    end while
    v = v + 1
  end while
end function

/// Reinitializes every software mixing channel to an inactive, centered, empty state.
/// @internal
function _IS_ResetChannels()
  global _I_chActive
  global _I_chHandle
  global _I_chId
  global _I_chData
  global _I_chLen
  global _I_chPos
  global _I_chFrac
  global _I_chStep
  global _I_chStart
  global _I_chLeftVol
  global _I_chRightVol

  _I_chActive = array(_IS_NUM_MIX_CHANNELS, 0)
  _I_chHandle = array(_IS_NUM_MIX_CHANNELS, -1)
  _I_chId = array(_IS_NUM_MIX_CHANNELS, -1)
  _I_chData = array(_IS_NUM_MIX_CHANNELS)
  _I_chLen = array(_IS_NUM_MIX_CHANNELS, 0)
  _I_chPos = array(_IS_NUM_MIX_CHANNELS, 0)
  _I_chFrac = array(_IS_NUM_MIX_CHANNELS, 0)
  _I_chStep = array(_IS_NUM_MIX_CHANNELS, 65536)
  _I_chStart = array(_IS_NUM_MIX_CHANNELS, 0)
  _I_chLeftVol = array(_IS_NUM_MIX_CHANNELS, 0)
  _I_chRightVol = array(_IS_NUM_MIX_CHANNELS, 0)
end function

/// Stores Doom's separation-adjusted left/right gains for one checked software mixing channel.
/// @param slot Slot value supplied to `_IS_SetChannelVolumes`.
/// @param vol Vol value supplied to `_IS_SetChannelVolumes`.
/// @param sep Sep value supplied to `_IS_SetChannelVolumes`.
/// @internal
function inline _IS_SetChannelVolumes(slot, vol, sep)
  if slot < 0 or slot >= _IS_NUM_MIX_CHANNELS then return end if

  v = _IS_Clamp(vol, 0, 127)
  s = _IS_Clamp(sep, 0, 255) + 1

  left = v -((v * s * s) >> 16)
  s2 = s - 257
  right = v -((v * s2 * s2) >> 16)

  _I_chLeftVol[slot] = _IS_Clamp(left, 0, 127)
  _I_chRightVol[slot] = _IS_Clamp(right, 0, 127)
end function

/// Decodes and caches a DMX sound lump's sample rate and unsigned 8-bit PCM payload by SFX id.
/// @param sid Sid value supplied to `_IS_LoadSfxData`.
/// @internal
function _IS_LoadSfxData(sid)
  _IS_EnsureSfxCacheSize()

  id = _IS_ToInt(sid, -1)
  if id < 0 or id >= len(_I_sfxSamples) then return false end if

  cached = _I_sfxSamples[id]
  if typeof(cached) == "bytes" and len(cached) > 0 then
    return true
  end if

  if not _IS_IsSeq(S_sfx) or id >= len(S_sfx) then return false end if

  lump = I_GetSfxLumpNum(S_sfx[id])
  raw = W_CacheLumpNum(lump, PU_CACHE)
  if typeof(raw) != "bytes" or len(raw) <= 8 then return false end if

  rate = _IS_ReadU16(raw, 2)
  if rate < 4000 or rate > 48000 then rate = _IS_MIX_RATE end if

  samples = len(raw) - 8
  declared = _IS_ReadU32(raw, 4)
  if declared > 0 and declared < samples then samples = declared end if
  if samples <= 0 then return false end if

  sdata = slice(raw, 8, samples)
  if typeof(sdata) != "bytes" or len(sdata) != samples then
    sdata = bytes(samples, 128)
    copyBytes(sdata, 0, raw, 8, samples)
  end if

  _I_sfxRates[id] = rate
  _I_sfxSamples[id] = sdata
  lengths[id] = samples
  return true
end function

/// Identifies chainsaw, platform-move, and pistol effects that replace an existing identical channel.
/// @param sid Sid value supplied to `_IS_ShouldSingleInstance`.
/// @internal
function inline _IS_ShouldSingleInstance(sid)
  sawup = _IS_EnumIndex(sfxenum_t.sfx_sawup, -1000)
  sawidl = _IS_EnumIndex(sfxenum_t.sfx_sawidl, -1000)
  sawful = _IS_EnumIndex(sfxenum_t.sfx_sawful, -1000)
  sawhit = _IS_EnumIndex(sfxenum_t.sfx_sawhit, -1000)
  stnmov = _IS_EnumIndex(sfxenum_t.sfx_stnmov, -1000)
  pistol = _IS_EnumIndex(sfxenum_t.sfx_pistol, -1000)

  return sid == sawup or sid == sawidl or sid == sawful or sid == sawhit or sid == stnmov or sid == pistol
end function

/// Reuses a free mixing channel, otherwise evicting the oldest after enforcing single-instance effects.
/// @param sid Sid value supplied to `_IS_FindChannelForNewSound`.
/// @internal
function _IS_FindChannelForNewSound(sid)

  if _IS_ShouldSingleInstance(sid) then
    i = 0
    while i < _IS_NUM_MIX_CHANNELS
      if _IS_ToInt(_I_chActive[i], 0) != 0 and _IS_ToInt(_I_chId[i], -1) == sid then
        _I_chActive[i] = 0
      end if
      i = i + 1
    end while
  end if

  oldestTic = _IS_ToInt(gametic, 0)
  oldestSlot = 0

  i = 0
  while i < _IS_NUM_MIX_CHANNELS
    if _IS_ToInt(_I_chActive[i], 0) == 0 then
      return i
    end if

    st = _IS_ToInt(_I_chStart[i], 0)
    if st < oldestTic then
      oldestTic = st
      oldestSlot = i
    end if

    i = i + 1
  end while

  return oldestSlot
end function

/// Combines Doom pitch and source sample rate into a positive 16.16 mixer cursor step.
/// @param pitch Pitch value supplied to `_IS_PitchToStep`.
/// @param rate Rate value supplied to `_IS_PitchToStep`.
/// @internal
function inline _IS_PitchToStep(pitch, rate)
  _IS_InitStepTable()

  p = _IS_Clamp(pitch, 0, 255)
  step = _IS_ToInt(_I_stepTable[p], 65536)

  r = _IS_ToInt(rate, _IS_MIX_RATE)
  if r < 1000 then r = _IS_MIX_RATE end if

  adj = _ISnd_IDiv(step * r, _IS_MIX_RATE)
  if adj < 1 then adj = 1 end if
  return adj
end function

/// Resolves a public sound handle to its active software channel index, or minus one when stale.
/// @param handle Handle value supplied to `_IS_FindChannelByHandle`.
/// @internal
function inline _IS_FindChannelByHandle(handle)
  h = _IS_ToInt(handle, -1)
  if h < 0 then return -1 end if

  i = 0
  while i < _IS_NUM_MIX_CHANNELS
    if _IS_ToInt(_I_chActive[i], 0) != 0 and _IS_ToInt(_I_chHandle[i], -1) == h then
      return i
    end if
    i = i + 1
  end while

  return -1
end function

/// Marks every software SFX channel inactive without disturbing music playback.
/// @internal
function inline _IS_StopAllSfx()
  if not _IS_IsSeq(_I_chActive) or len(_I_chActive) < _IS_NUM_MIX_CHANNELS then return end if
  i = 0
  while i < _IS_NUM_MIX_CHANNELS
    _I_chActive[i] = 0
    i = i + 1
  end while
end function

/// Builds the PCM WAVEFORMATEX for 11,025-Hz stereo signed 16-bit mixer output.
/// @internal
function inline _IS_WaveFormat()
  wfx = bytes(18, 0)
  _IS_WriteU16(wfx, 0, 1)
  _IS_WriteU16(wfx, 2, 2)
  _IS_WriteU32(wfx, 4, _IS_MIX_RATE)
  _IS_WriteU32(wfx, 8, _IS_MIX_RATE * 4)
  _IS_WriteU16(wfx, 12, 4)
  _IS_WriteU16(wfx, 14, 16)
  _IS_WriteU16(wfx, 16, 0)
  return wfx
end function

/// Opens WinMM waveform output and allocates/prepares the fixed ring of unmanaged PCM buffers.
/// @internal
function _IS_WaveInit()
  global _I_waveBuffers
  global _I_waveHandle
  global _I_waveReady

  _I_waveReady = false
  _I_waveHandle = 0
  _I_waveBuffers = array(_IS_NUM_WAVE_BUFS)

  hbuf = bytes(8, 0)
  rc = waveOutOpen(hbuf, _IS_WAVE_MAPPER, _IS_WaveFormat(), void, void, 0)
  if rc != 0 then
    return
  end if

  _I_waveHandle = _IS_ReadU64(hbuf, 0)
  if _I_waveHandle == 0 then
    _I_waveHandle = _IS_ReadU32(hbuf, 0)
  end if

  i = 0
  while i < _IS_NUM_WAVE_BUFS
    dptr = GlobalAlloc(_IS_GMEM_FIXED, _IS_MIX_BUF_BYTES)
    hptr = GlobalAlloc(_IS_GMEM_FIXED, _IS_WAVEHDR_SIZE)

    if dptr == 0 or hptr == 0 then
      if dptr != 0 then _ = GlobalFree(dptr) end if
      if hptr != 0 then _ = GlobalFree(hptr) end if
      _IS_WaveShutdown()
      return
    end if

    hdr = bytes(_IS_WAVEHDR_SIZE, 0)
    _IS_WriteU64(hdr, 0, dptr)
    _IS_WriteU32(hdr, 8, _IS_MIX_BUF_BYTES)
    _IS_WriteU32(hdr, 24, _IS_WHDR_DONE)
    RtlMoveMemoryToPtr(hptr, hdr, _IS_WAVEHDR_SIZE)

    prc = waveOutPrepareHeader(_I_waveHandle, hptr, _IS_WAVEHDR_SIZE)
    if prc != 0 then
      _ = GlobalFree(hptr)
      _ = GlobalFree(dptr)
      _IS_WaveShutdown()
      return
    end if

    _I_waveBuffers[i] = _I_wavebuf_t(dptr, hptr, false)
    i = i + 1
  end while

  _I_waveReady = true
end function

/// Resets waveform output, unprepares every header, frees unmanaged buffers, and closes the device.
/// @internal
function _IS_WaveShutdown()
  global _I_waveBuffers
  global _I_waveReady
  global _I_waveHandle

  if _I_waveHandle != 0 then
    _ = waveOutReset(_I_waveHandle)
  end if

  if _IS_IsSeq(_I_waveBuffers) then
    i = 0
    while i < len(_I_waveBuffers)
      wb = _I_waveBuffers[i]
      if wb is not void then
        if _I_waveHandle != 0 and _IS_ToInt(wb.hdrPtr, 0) != 0 then
          _ = waveOutUnprepareHeader(_I_waveHandle, wb.hdrPtr, _IS_WAVEHDR_SIZE)
        end if

        if _IS_ToInt(wb.hdrPtr, 0) != 0 then _ = GlobalFree(wb.hdrPtr) end if
        if _IS_ToInt(wb.dataPtr, 0) != 0 then _ = GlobalFree(wb.dataPtr) end if
      end if
      i = i + 1
    end while
  end if

  if _I_waveHandle != 0 then
    _ = waveOutClose(_I_waveHandle)
  end if

  _I_waveBuffers =[]
  _I_waveHandle = 0
  _I_waveReady = false
end function

/// Reads a submitted WAVEHDR's WHDR_DONE flag, treating never-submitted buffers as immediately reusable.
/// @param wb Wb value supplied to `_IS_WaveIsDone`.
/// @internal
function inline _IS_WaveIsDone(wb)
  if wb is void then return false end if
  if not wb.submitted then return true end if

  if _IS_ToInt(wb.hdrPtr, 0) == 0 then return true end if

  hdr = bytes(_IS_WAVEHDR_SIZE, 0)
  RtlMoveMemoryFromPtr(hdr, wb.hdrPtr, _IS_WAVEHDR_SIZE)
  flags = _IS_ReadU32(hdr, 24)
  return (flags & _IS_WHDR_DONE) != 0
end function

/// Marks submitted ring buffers reusable after WinMM reports their headers complete.
/// @internal
function inline _IS_WaveRefresh()
  if not _IS_IsSeq(_I_waveBuffers) then return end if

  i = 0
  while i < len(_I_waveBuffers)
    wb = _I_waveBuffers[i]
    if wb is not void and wb.submitted and _IS_WaveIsDone(wb) then
      wb.submitted = false
      _I_waveBuffers[i] = wb
    end if
    i = i + 1
  end while
end function

/// Returns the first waveform ring slot not currently owned by WinMM, or minus one when saturated.
/// @internal
function inline _IS_WaveFindFreeBuffer()
  if not _IS_IsSeq(_I_waveBuffers) then return -1 end if

  i = 0
  while i < len(_I_waveBuffers)
    wb = _I_waveBuffers[i]
    if wb is not void and not wb.submitted then
      return i
    end if
    i = i + 1
  end while

  return -1
end function

/// Saturates a mixed accumulator to the signed 16-bit PCM sample range.
/// @param v Value consumed by the operation.
/// @internal
function inline _IS_ClampS16(v)
  n = _IS_ToInt(v, 0)
  if n > 0x7FFF then return 0x7FFF end if
  if n < -0x8000 then return -0x8000 end if
  return n
end function

/// Mixes active unsigned 8-bit SFX channels into an interleaved signed 16-bit stereo PCM block.
/// @param outb Outb value supplied to `_IS_MixToBytes`.
/// @internal
function _IS_MixToBytes(outb)
  if typeof(outb) != "bytes" then return end if
  if len(outb) < _IS_MIX_BUF_BYTES then return end if
  mixTab = _I_mixScaleTable
  if not _IS_IsSeq(mixTab) or len(mixTab) != 128 * 256 then
    _IS_InitMixScaleTable()
    mixTab = _I_mixScaleTable
  end if

  s = 0
  while s < _IS_MIX_SAMPLES
    dl = 0
    dr = 0

    ch = 0
    while ch < _IS_NUM_MIX_CHANNELS
      if _IS_ToInt(_I_chActive[ch], 0) != 0 then
        data = _I_chData[ch]
        dlen = _IS_ToInt(_I_chLen[ch], 0)
        pos = _IS_ToInt(_I_chPos[ch], 0)

        if typeof(data) != "bytes" or dlen <= 0 or pos >= dlen then
          _I_chActive[ch] = 0
        else
          sample = data[pos]

          lv = _IS_ToInt(_I_chLeftVol[ch], 0)
          rv = _IS_ToInt(_I_chRightVol[ch], 0)

          dl = dl + mixTab[(lv << 8) + sample]
          dr = dr + mixTab[(rv << 8) + sample]

          frac = _IS_ToInt(_I_chFrac[ch], 0) + _IS_ToInt(_I_chStep[ch], 65536)
          adv = frac >> 16
          _I_chFrac[ch] = frac & 0xFFFF
          _I_chPos[ch] = pos + adv

          if _IS_ToInt(_I_chPos[ch], 0) >= dlen then
            _I_chActive[ch] = 0
          end if
        end if
      end if
      ch = ch + 1
    end while

    l16 = _IS_ClampS16(dl)
    r16 = _IS_ClampS16(dr)

    if l16 < 0 then l16 = 65536 + l16 end if
    if r16 < 0 then r16 = 65536 + r16 end if

    off = s * 4
    outb[off] = l16 & 255
    outb[off + 1] =(l16 >> 8) & 255
    outb[off + 2] = r16 & 255
    outb[off + 3] =(r16 >> 8) & 255

    s = s + 1
  end while
end function

/// Fills one free unmanaged waveform buffer with a mixed block and queues its prepared header to WinMM.
/// @internal
function _IS_WaveSubmitMixedBuffer()
  if not _I_waveReady then return end if
  if _I_waveHandle == 0 then return end if

  _IS_WaveRefresh()
  slot = _IS_WaveFindFreeBuffer()
  if slot < 0 then return end if

  wb = _I_waveBuffers[slot]
  if wb is void then return end if
  if _IS_ToInt(wb.dataPtr, 0) == 0 or _IS_ToInt(wb.hdrPtr, 0) == 0 then return end if

  _IS_MixToBytes(_I_mixScratch)
  RtlMoveMemoryToPtr(wb.dataPtr, _I_mixScratch, _IS_MIX_BUF_BYTES)

  rc = waveOutWrite(_I_waveHandle, wb.hdrPtr, _IS_WAVEHDR_SIZE)
  if rc == 0 then
    wb.submitted = true
    _I_waveBuffers[slot] = wb
  end if
end function

/// Opens the platform MIDI backend once and stores its pointer-sized output handle.
/// @internal
function inline _IS_MidiInit()
  global _I_midiHandle

  if _I_midiHandle != 0 then return end if

  hbuf = bytes(8, 0)
  rc = midiOutOpen(hbuf, _IS_MIDI_MAPPER, void, void, 0)
  if rc != 0 then
    _I_midiHandle = 0
    return
  end if

  _I_midiHandle = _IS_ReadU64(hbuf, 0)
  if _I_midiHandle == 0 then
    _I_midiHandle = _IS_ReadU32(hbuf, 0)
  end if
end function

/// Resets all MIDI voices, closes the mapper handle, and clears local ownership.
/// @internal
function inline _IS_MidiShutdown()
  global _I_midiHandle

  if _I_midiHandle == 0 then return end if

  _ = midiOutReset(_I_midiHandle)
  _ = midiOutClose(_I_midiHandle)
  _I_midiHandle = 0
end function

/// Packs and sends a two-byte MIDI message, reporting only the first failure in developer mode.
/// @param status Status value supplied to `_IS_MidiMsg2`.
/// @param data1 Data1 value supplied to `_IS_MidiMsg2`.
/// @internal
function inline _IS_MidiMsg2(status, data1)
  global _I_midiDbgPrinted
  if _I_midiHandle == 0 then return end if
  st = _IS_Clamp(status, 0, 255)
  d1 = _IS_Clamp(data1, 0, 127)
  msg = st |(d1 << 8)
  rc = midiOutShortMsg(_I_midiHandle, msg)
  if rc != 0 and(not _I_midiDbgPrinted) then
    if typeof(devparm) != "void" and devparm then
      print "midiOutShortMsg2 rc=" + rc + " st=" + st + " d1=" + d1
    end if
    _I_midiDbgPrinted = true
  end if
end function

/// Packs and sends a three-byte MIDI message, reporting only the first failure in developer mode.
/// @param status Status value supplied to `_IS_MidiMsg3`.
/// @param data1 Data1 value supplied to `_IS_MidiMsg3`.
/// @param data2 Data2 value supplied to `_IS_MidiMsg3`.
/// @internal
function inline _IS_MidiMsg3(status, data1, data2)
  global _I_midiDbgPrinted
  if _I_midiHandle == 0 then return end if
  st = _IS_Clamp(status, 0, 255)
  d1 = _IS_Clamp(data1, 0, 127)
  d2 = _IS_Clamp(data2, 0, 127)
  msg = st |(d1 << 8) |(d2 << 16)
  rc = midiOutShortMsg(_I_midiHandle, msg)
  if rc != 0 and(not _I_midiDbgPrinted) then
    if typeof(devparm) != "void" and devparm then
      print "midiOutShortMsg3 rc=" + rc + " st=" + st + " d1=" + d1 + " d2=" + d2
    end if
    _I_midiDbgPrinted = true
  end if
end function

/// Sends both all-notes-off and all-sound-off controllers on every MIDI channel.
/// @internal
function inline _IS_MidiAllNotesOff()
  if _I_midiHandle == 0 then return end if

  ch = 0
  while ch < 16
    _IS_MidiMsg3(0xB0 | ch, 123, 0)
    _IS_MidiMsg3(0xB0 | ch, 120, 0)
    ch = ch + 1
  end while
end function

/// Resets MUS channel velocities/mappings, reserves MIDI percussion channel 10, and clears timing fractions.
/// @internal
function _IS_MusicResetRuntime()
  global _I_musicChanVel
  global _I_musicChanMap
  global _I_musicUsedMidi
  global _I_musicDelay
  global _I_musicMsFrac

  _I_musicChanVel = array(16, 127)
  _I_musicChanMap = array(16, -1)
  _I_musicUsedMidi = array(16, 0)

  _I_musicUsedMidi[9] = 1
  _I_musicDelay = 0
  _I_musicMsFrac = 0
end function

/// Maps Doom MUS controller numbers to their General MIDI controller equivalents.
/// @param ctrl Ctrl value supplied to `_IS_MusCtrlToMidi`.
/// @internal
function inline _IS_MusCtrlToMidi(ctrl)
  c = _IS_ToInt(ctrl, -1)
  if c == 0 then return 0 end if
  if c == 1 then return 32 end if
  if c == 2 then return 1 end if
  if c == 3 then return 7 end if
  if c == 4 then return 10 end if
  if c == 5 then return 11 end if
  if c == 6 then return 91 end if
  if c == 7 then return 93 end if
  if c == 8 then return 64 end if
  if c == 9 then return 67 end if
  if c == 10 then return 120 end if
  if c == 11 then return 123 end if
  if c == 12 then return 126 end if
  if c == 13 then return 127 end if
  if c == 14 then return 121 end if
  return 0
end function

/// Assigns a stable non-percussion MIDI channel to a MUS channel, with MUS channel 15 mapped to percussion.
/// @param mchan Mchan value supplied to `_IS_MapMusChannel`.
/// @internal
function _IS_MapMusChannel(mchan)
  mc = _IS_Clamp(mchan, 0, 15)

  if mc == 15 then return 9 end if

  mapped = _IS_ToInt(_I_musicChanMap[mc], -1)
  if mapped >= 0 then return mapped end if

  m = 0
  while m < 16
    if m != 9 and _IS_ToInt(_I_musicUsedMidi[m], 0) == 0 then
      _I_musicUsedMidi[m] = 1
      _I_musicChanMap[mc] = m

      _IS_MidiMsg3(0xB0 | m, 123, 0)
      return m
    end if
    m = m + 1
  end while

  _I_musicChanMap[mc] = 0
  return 0
end function

/// Applies sequencer-side master gain on Windows MIDI devices that may ignore midiOutSetVolume; Linux delegates
/// gain to FluidSynth.
/// @param v Value consumed by the operation.
/// @internal
function inline _IS_MusicScale7(v)
  x = _IS_Clamp(v, 0, 127)
#if TARGET_OS == "windows"
  return _IS_Clamp(_ISnd_IDiv(x * _I_musicVolume, 127), 0, 127)
#else
  return x
#endif
end function

/// Decodes a bounded MUS base-128 variable-length delay and advances the caller's byte cursor.
/// @param data Binary or structured data to process.
/// @param posref Posref value supplied to `_IS_ReadMusVarLen`.
/// @internal
function inline _IS_ReadMusVarLen(data, posref)
  if typeof(data) != "bytes" then return 0 end if
  if not _IS_IsSeq(posref) or len(posref) == 0 then return 0 end if

  value = 0
  guard = 0
  while guard < 8 and posref[0] < len(data)
    b = data[posref[0]]
    posref[0] = posref[0] + 1
    value =(value << 7) |(b & 0x7F)
    if (b & 0x80) == 0 then break end if
    guard = guard + 1
  end while

  return value
end function

/// Resolves a registered song handle to its metadata slot, or minus one when unregistered.
/// @param handle Handle value supplied to `_IS_MusicFindSlotIndex`.
/// @internal
function inline _IS_MusicFindSlotIndex(handle)
  if not _IS_IsSeq(_I_songData) then return -1 end if

  h = _IS_ToInt(handle, -1)
  i = 0
  while i < len(_I_songData)
    slot = _I_songData[i]
    if _IS_IsSeq(slot) and len(slot) >= 4 and _IS_ToInt(slot[0], -2) == h then
      return i
    end if
    i = i + 1
  end while

  return -1
end function

/// Updates the looping and playing flags stored with a registered song handle.
/// @param handle Handle value supplied to `_IS_MusicSetSlotPlaying`.
/// @param playing Playing value supplied to `_IS_MusicSetSlotPlaying`.
/// @param looping Looping value supplied to `_IS_MusicSetSlotPlaying`.
/// @internal
function inline _IS_MusicSetSlotPlaying(handle, playing, looping)
  idx = _IS_MusicFindSlotIndex(handle)
  if idx < 0 then return end if

  slot = _I_songData[idx]
  slot[2] = looping
  slot[3] = playing
  _I_songData[idx] = slot
end function

/// Silences MIDI, clears the active MUS decoder/timing state, and optionally marks its song slot stopped.
/// @param updateSlot Update slot value supplied to `_IS_MusicStopInternal`.
/// @internal
function _IS_MusicStopInternal(updateSlot)
  global _I_musicPlaying
  global _I_musicPaused
  global _I_musicLooping
  global _I_currentSongHandle
  global _I_musicData
  global _I_musicPos
  global _I_musicScoreStart
  global _I_musicScoreEnd
  global _I_musicDelay
  global _I_musicLastMs

  oldHandle = _I_currentSongHandle

  if _I_midiHandle != 0 then
    _IS_MidiAllNotesOff()
    _ = midiOutReset(_I_midiHandle)
  end if

  _I_musicPlaying = false
  _I_musicPaused = false
  _I_musicLooping = false
  _I_currentSongHandle = -1
  _I_musicData = void
  _I_musicPos = 0
  _I_musicScoreStart = 0
  _I_musicScoreEnd = 0
  _I_musicDelay = 0
  _I_musicLastMs = 0

  _IS_MusicResetRuntime()

  if updateSlot and oldHandle >= 0 then
    _IS_MusicSetSlotPlaying(oldHandle, false, false)
  end if
end function

/// Validates a MUS score header/range and initializes decoder, timing, loop, and registration state for
/// playback.
/// @param handle Handle value supplied to `_IS_MusicStartInternal`.
/// @param data Binary or structured data to process.
/// @param looping Looping value supplied to `_IS_MusicStartInternal`.
/// @internal
function _IS_MusicStartInternal(handle, data, looping)
  global _I_currentSongHandle
  global _I_musicData
  global _I_musicScoreStart
  global _I_musicScoreEnd
  global _I_musicPos
  global _I_musicDelay
  global _I_musicPlaying
  global _I_musicPaused
  global _I_musicLooping
  global _I_musicLastMs

  if typeof(data) != "bytes" or len(data) < 16 then return false end if

  if not(data[0] == 0x4D and data[1] == 0x55 and data[2] == 0x53 and data[3] == 0x1A) then
    return false
  end if

  scoreLen = _IS_ReadU16(data, 4)
  scoreStart = _IS_ReadU16(data, 6)
  if scoreStart < 0 then scoreStart = 0 end if
  if scoreStart >= len(data) then return false end if

  scoreEnd = scoreStart + scoreLen
  if scoreEnd < scoreStart or scoreEnd > len(data) then scoreEnd = len(data) end if
  if scoreEnd <= scoreStart then return false end if

  _IS_MusicStopInternal(false)

  _I_currentSongHandle = _IS_ToInt(handle, -1)
  _I_musicData = data
  _I_musicScoreStart = scoreStart
  _I_musicScoreEnd = scoreEnd
  _I_musicPos = scoreStart
  _I_musicDelay = 0
  _I_musicPlaying = true
  _I_musicPaused = false
  _I_musicLooping = looping
  _I_musicLastMs = _IS_TickMs()

  _IS_MusicResetRuntime()
  _IS_MusicSetSlotPlaying(_I_currentSongHandle, true, looping)
  return true
end function

/// Translates MUS events into MIDI messages until a timed slice boundary or score end is reached.
/// @internal
function _IS_MusicProcessSlice()
  global _I_musicPos
  global _I_musicDelay
  if not _I_musicPlaying then return false end if
  if typeof(_I_musicData) != "bytes" then return false end if

  data = _I_musicData
  pos = _IS_ToInt(_I_musicPos, 0)
  limit = _IS_ToInt(_I_musicScoreEnd, len(data))

  guard = 0
  while pos < limit and guard < 4096
    guard = guard + 1

    ev = data[pos]
    pos = pos + 1

    etype =(ev >> 4) & 0x07
    mchan = ev & 0x0F
    last =(ev & 0x80) != 0
    midiCh = _IS_MapMusChannel(mchan)

    if etype == 0 then
      if pos >= limit then
        _I_musicPos = pos
        return false
      end if
      note = data[pos] & 0x7F
      pos = pos + 1
      _IS_MidiMsg3(0x80 | midiCh, note, 0)

    else if etype == 1 then
      if pos >= limit then
        _I_musicPos = pos
        return false
      end if

      b = data[pos]
      pos = pos + 1

      note = b & 0x7F
      vel = _IS_ToInt(_I_musicChanVel[mchan], 64)
      if (b & 0x80) != 0 then
        if pos >= limit then
          _I_musicPos = pos
          return false
        end if
        vel = data[pos] & 0x7F
        pos = pos + 1
        _I_musicChanVel[mchan] = vel
      end if

      svel = _IS_MusicScale7(vel)
      _IS_MidiMsg3(0x90 | midiCh, note, svel)

    else if etype == 2 then
      if pos >= limit then
        _I_musicPos = pos
        return false
      end if

      pw = _IS_Clamp(_IS_ToInt(data[pos], 128) * 64, 0, 16383)
      pos = pos + 1
      _IS_MidiMsg3(0xE0 | midiCh, pw & 0x7F,(pw >> 7) & 0x7F)

    else if etype == 3 then
      if pos >= limit then
        _I_musicPos = pos
        return false
      end if

      se = data[pos] & 0x7F
      pos = pos + 1
      if se >= 10 and se <= 14 then
        ctrl = _IS_MusCtrlToMidi(se)
        _IS_MidiMsg3(0xB0 | midiCh, ctrl & 0x7F, 0)
      end if

    else if etype == 4 then
      if (pos + 1) > limit then
        _I_musicPos = pos
        return false
      end if

      ctl = data[pos] & 0x7F
      pos = pos + 1
      val = data[pos] & 0x7F
      pos = pos + 1

      if ctl == 0 then
        _IS_MidiMsg2(0xC0 | midiCh, val)
      else
        if ctl >= 1 and ctl <= 9 then
          cc = _IS_MusCtrlToMidi(ctl)
          vv = val
          if cc == 7 then
            vv = _IS_MusicScale7(vv)
          end if
          _IS_MidiMsg3(0xB0 | midiCh, cc & 0x7F, vv)
        end if
      end if

    else if etype == 6 then
      _I_musicPos = pos
      return false

    else

    end if

    if last then
      pr =[pos]
      d = _IS_ReadMusVarLen(data, pr)
      pos = pr[0]
      _I_musicPos = pos
      _I_musicDelay = _I_musicDelay + d
      return true
    end if
  end while

  _I_musicPos = pos
  return false
end function

/// Silences current notes and rewinds a looping MUS score to its first event with fresh channel mappings.
/// @internal
function inline _IS_MusicRestart()
  global _I_musicPos
  global _I_musicDelay
  global _I_musicLastMs
  _IS_MidiAllNotesOff()
  _I_musicPos = _I_musicScoreStart
  _I_musicDelay = 0
  _I_musicLastMs = _IS_TickMs()
  _IS_MusicResetRuntime()
end function

/// Consumes a bounded number of 140-Hz MUS ticks, honoring delays, looping, pause, and malformed-score guards.
/// @param ticks Ticks value supplied to `_IS_MusicRunTicks`.
/// @internal
function _IS_MusicRunTicks(ticks)
  global _I_musicDelay
  if not _I_musicPlaying then return end if
  if _I_musicPaused then return end if

  remain = _IS_ToInt(ticks, 0)
  if remain <= 0 then return end if

  iter = 0
  while remain > 0 and _I_musicPlaying and not _I_musicPaused and iter < 4096
    iter = iter + 1
    d = _IS_ToInt(_I_musicDelay, 0)
    if d < 0 then
      d = 0
      _I_musicDelay = 0
    end if

    if d > remain then
      _I_musicDelay = d - remain
      remain = 0
      break
    end if

    remain = remain - d
    _I_musicDelay = 0

    posBefore = _IS_ToInt(_I_musicPos, 0)
    ok = _IS_MusicProcessSlice()
    posAfter = _IS_ToInt(_I_musicPos, 0)
    if _IS_ToInt(_I_musicDelay, 0) < 0 then _I_musicDelay = 0 end if

    if not ok then
      if _I_musicLooping then
        _IS_MusicRestart()

        remain = remain - 1
      else
        _IS_MusicStopInternal(true)
        break
      end if
    else if _IS_ToInt(_I_musicDelay, 0) == 0 and posAfter == posBefore then

      remain = remain - 1
    end if
  end while

  if iter >= 4096 then

    _IS_MusicStopInternal(true)
  end if
end function

/// Converts elapsed milliseconds to fractional 140-Hz MUS ticks and advances active playback with stall
/// clamping.
/// @internal
function _IS_MusicTicker()
  global _I_musicLastMs
  global _I_musicMsFrac
  if not _I_musicPlaying then return end if
  if _I_musicPaused then return end if

  now = _IS_TickMs()
  if _I_musicLastMs <= 0 then
    _I_musicLastMs = now
    return
  end if

  dt = now - _I_musicLastMs
  if dt < 0 then dt = 0 end if
  if dt > 250 then dt = 250 end if
  _I_musicLastMs = now

  acc = _I_musicMsFrac +(dt * 140)
  ticks = _ISnd_IDiv(acc, 1000)
  _I_musicMsFrac = acc -(ticks * 1000)

  if ticks > 0 then
    _IS_MusicRunTicks(ticks)
  end if
end function

/// Initializes SFX caches/tables/channels, opens waveform output, and starts the MIDI music backend.
function I_InitSound()
  global _I_nextHandle

  _IS_EnsureSfxCacheSize()
  _IS_InitStepTable()
  _IS_InitMixScaleTable()
  _IS_ResetChannels()
  _IS_WaveInit()

  _I_nextHandle = 1
  I_InitMusic()
end function

/// Advances wall-clock-driven MUS/MIDI playback during the engine sound update.
function I_UpdateSound()
  _IS_MusicTicker()
end function

/// Fills every currently free WinMM ring slot with a freshly mixed PCM block.
function I_SubmitSound()

  n = 0
  while n < _IS_NUM_WAVE_BUFS
    _IS_WaveSubmitMixedBuffer()
    n = n + 1
  end while
end function

/// Stops SFX, releases waveform buffers/device state, and shuts down registered MIDI music.
function I_ShutdownSound()
  _IS_StopAllSfx()
  _IS_WaveShutdown()
  I_ShutdownMusic()
end function

/// Rebuilds the pitch table if needed and resets all software mixing channels.
function I_SetChannels()
  _IS_InitStepTable()
  _IS_ResetChannels()
end function

/// Resolves an SFX metadata name to its `DS*` lump, falling back to the pistol sound when absent.
/// @param sfxinfo Sfxinfo value supplied to `I_GetSfxLumpNum`.
function I_GetSfxLumpNum(sfxinfo)
  if sfxinfo is void or sfxinfo.name is void then
    return W_GetNumForName("dspistol")
  end if

  name = "ds" + sfxinfo.name
  if W_CheckNumForName(name) == -1 then
    return W_GetNumForName("dspistol")
  end if
  return W_GetNumForName(name)
end function

/// Decodes one SFX id into the rate/sample cache before first playback.
/// @param id Id value supplied to `I_PrecacheSfx`.
function I_PrecacheSfx(id)
  sid = _IS_ToInt(id, -1)
  if sid < 0 then return false end if
  return _IS_LoadSfxData(sid)
end function

/// Loads an SFX, derives its pitch step, assigns a mixing channel, and returns a public playback handle.
/// @param id Id value supplied to `I_StartSound`.
/// @param vol Vol value supplied to `I_StartSound`.
/// @param sep Sep value supplied to `I_StartSound`.
/// @param pitch Pitch value supplied to `I_StartSound`.
/// @param priority Playback or task priority used by the operation.
function I_StartSound(id, vol, sep, pitch, priority)
  priority = priority

  sid = _IS_ToInt(id, -1)
  if sid < 0 then return -1 end if

  if not _IS_LoadSfxData(sid) then return -1 end if

  rate = _IS_MIX_RATE
  if sid >= 0 and sid < len(_I_sfxRates) then rate = _IS_ToInt(_I_sfxRates[sid], _IS_MIX_RATE) end if
  step = _IS_PitchToStep(pitch, rate)

  mixVol = _IS_NormalizeVolume127(vol)
  return addsfx(sid, mixVol, step, _IS_ToInt(sep, 128))
end function

/// Deactivates the software mixing channel associated with a public sound handle.
/// @param handle Handle value supplied to `I_StopSound`.
function I_StopSound(handle)
  slot = _IS_FindChannelByHandle(handle)
  if slot < 0 then return end if
  _I_chActive[slot] = 0
end function

/// Reports whether a sound handle still owns an active channel with unread PCM samples.
/// @param handle Handle value supplied to `I_SoundIsPlaying`.
function I_SoundIsPlaying(handle)
  slot = _IS_FindChannelByHandle(handle)
  if slot < 0 then return 0 end if

  if _IS_ToInt(_I_chActive[slot], 0) == 0 then return 0 end if

  if _IS_ToInt(_I_chPos[slot], 0) >= _IS_ToInt(_I_chLen[slot], 0) then
    _I_chActive[slot] = 0
    return 0
  end if

  return 1
end function

/// Recomputes pitch step and stereo gains for an active sound handle.
/// @param handle Handle value supplied to `I_UpdateSoundParams`.
/// @param vol Vol value supplied to `I_UpdateSoundParams`.
/// @param sep Sep value supplied to `I_UpdateSoundParams`.
/// @param pitch Pitch value supplied to `I_UpdateSoundParams`.
function I_UpdateSoundParams(handle, vol, sep, pitch)
  slot = _IS_FindChannelByHandle(handle)
  if slot < 0 then return end if

  sid = _IS_ToInt(_I_chId[slot], -1)
  rate = _IS_MIX_RATE
  if sid >= 0 and sid < len(_I_sfxRates) then rate = _IS_ToInt(_I_sfxRates[sid], _IS_MIX_RATE) end if

  _I_chStep[slot] = _IS_PitchToStep(pitch, rate)
  // Position updates receive the same Doom volume scale as I_StartSound.
  _IS_SetChannelVolumes(slot, _IS_NormalizeVolume127(vol), _IS_ToInt(sep, 128))
end function

/// Clears song registration/playback state, opens MIDI output, and applies the default master volume.
function I_InitMusic()
  global _I_musicVolume
  global _I_songData
  global _I_nextSongHandle

  _I_musicVolume = 127
  _I_songData =[]
  _I_nextSongHandle = 1000

  _IS_MusicStopInternal(false)
  _IS_MidiInit()
  I_SetMusicVolume(_I_musicVolume)
end function

/// Stops the active MUS score and resets/closes the platform MIDI backend.
function I_ShutdownMusic()
  _IS_MusicStopInternal(false)
  _IS_MidiShutdown()
end function

/// Normalizes Doom music volume and applies it to both WinMM MIDI output channels.
/// @param volume Volume value supplied to `I_SetMusicVolume`.
function I_SetMusicVolume(volume)
  global _I_musicVolume

  _I_musicVolume = _IS_NormalizeVolume127(volume)

  if _I_midiHandle != 0 then
    v16 = _IS_Clamp(_ISnd_IDiv(_I_musicVolume * 65535, 127), 0, 65535)
    vv = v16 |(v16 << 16)
    _ = midiOutSetVolume(_I_midiHandle, vv)
  end if
end function

/// Normalizes and stores the master SFX gain used when starting/mixing effects.
/// @param volume Volume value supplied to `I_SetSfxVolume`.
function I_SetSfxVolume(volume)
  global _I_sfxVolume
  _I_sfxVolume = _IS_NormalizeVolume127(volume)
end function

/// Pauses the active registered song, resets sounding MIDI notes, and updates its slot flags.
/// @param handle Handle value supplied to `I_PauseSong`.
function I_PauseSong(handle)
  global _I_musicPaused
  h = _IS_ToInt(handle, -1)
  if h < 0 or h != _I_currentSongHandle then return end if
  if not _I_musicPlaying or _I_musicPaused then return end if

  _I_musicPaused = true
  if _I_midiHandle != 0 then _ = midiOutReset(_I_midiHandle) end if
  _IS_MusicSetSlotPlaying(h, false, _I_musicLooping)
end function

/// Resumes the active paused song from its MUS cursor with a rebased wall-clock timestamp.
/// @param handle Handle value supplied to `I_ResumeSong`.
function I_ResumeSong(handle)
  global _I_musicPaused
  global _I_musicLastMs
  h = _IS_ToInt(handle, -1)
  if h < 0 or h != _I_currentSongHandle then return end if
  if not _I_musicPlaying or not _I_musicPaused then return end if

  _I_musicPaused = false
  _I_musicLastMs = _IS_TickMs()
  _IS_MusicSetSlotPlaying(h, true, _I_musicLooping)
end function

/// Stores immutable MUS bytes under a new handle with initial stopped/non-looping metadata.
/// @param data Binary or structured data to process.
function I_RegisterSong(data)
  global _I_nextSongHandle
  global _I_songData

  h = _I_nextSongHandle
  _I_nextSongHandle = _I_nextSongHandle + 1

  _I_songData = _I_songData +[[h, data, false, false]]
  return h
end function

/// Resolves a registered song, validates/starts its MUS stream, and records requested looping state.
/// @param handle Handle value supplied to `I_PlaySong`.
/// @param looping Looping value supplied to `I_PlaySong`.
function I_PlaySong(handle, looping)
  h = _IS_ToInt(handle, -1)
  if h < 0 then return end if

  idx = _IS_MusicFindSlotIndex(h)
  if idx < 0 then return end if

  slot = _I_songData[idx]
  data = slot[1]

  ok = _IS_MusicStartInternal(h, data, looping)
  slot[2] = looping
  slot[3] = ok
  _I_songData[idx] = slot
end function

/// Stops the active song decoder or clears only the metadata flags of a different registered handle.
/// @param handle Handle value supplied to `I_StopSong`.
function I_StopSong(handle)
  h = _IS_ToInt(handle, -1)
  if h >= 0 and h != _I_currentSongHandle then
    _IS_MusicSetSlotPlaying(h, false, false)
    return
  end if

  _IS_MusicStopInternal(true)
end function

/// Stops a matching active song and removes its handle/data record from the registration table.
/// @param handle Handle value supplied to `I_UnRegisterSong`.
function I_UnRegisterSong(handle)
  global _I_songData

  h = _IS_ToInt(handle, -1)

  if h == _I_currentSongHandle then
    _IS_MusicStopInternal(true)
  end if

  if not _IS_IsSeq(_I_songData) then return end if

  kept =[]
  i = 0
  while i < len(_I_songData)
    slot = _I_songData[i]
    if _IS_IsSeq(slot) and len(slot) >= 1 and _IS_ToInt(slot[0], -2) != h then
      kept = kept +[slot]
    end if
    i = i + 1
  end while
  _I_songData = kept
end function

/// Reports whether the requested handle is the active, unpaused MUS song.
/// @param handle Handle value supplied to `I_QrySongPlaying`.
function I_QrySongPlaying(handle)
  h = _IS_ToInt(handle, -1)
  if h < 0 then return false end if
  return _I_musicPlaying and(not _I_musicPaused) and h == _I_currentSongHandle
end function

/// Retains the legacy Unix audio-control entry point as a deterministic no-op on WinMM.
/// @param fd Fd value supplied to `myioctl`.
/// @param req Req value supplied to `myioctl`.
/// @param arg Arg value supplied to `myioctl`.
function myioctl(fd, req, arg)
  fd = fd
  req = req
  arg = arg
  return 0
end function

/// Loads a named `DS*` sound lump and writes its byte length through the legacy output reference.
/// @param name Resource or object name to resolve.
/// @param lenOut Len out value supplied to `getsfx`.
function getsfx(name, lenOut)
  if typeof(name) != "string" then
    if _IS_IsSeq(lenOut) and len(lenOut) > 0 then lenOut[0] = 0 end if
    return bytes(0, 0)
  end if

  lump = "ds" + name
  if typeof(W_CheckNumForName) == "function" and W_CheckNumForName(lump) != -1 then
    b = W_CacheLumpName(lump, PU_CACHE)
    if _IS_IsSeq(lenOut) and len(lenOut) > 0 then lenOut[0] = len(b) end if
    return b
  end if

  if _IS_IsSeq(lenOut) and len(lenOut) > 0 then lenOut[0] = 0 end if
  return bytes(0, 0)
end function

/// Assigns cached PCM to a mixing channel, initializes cursor/gains, and returns a unique playback handle.
/// @param sfxid Sfxid value supplied to `addsfx`.
/// @param volume Volume value supplied to `addsfx`.
/// @param step Step value supplied to `addsfx`.
/// @param seperation Seperation value supplied to `addsfx`.
function addsfx(sfxid, volume, step, seperation)
  global _I_nextHandle
  sid = _IS_ToInt(sfxid, -1)
  if sid < 0 then return -1 end if

  if not _IS_LoadSfxData(sid) then return -1 end if

  data = _I_sfxSamples[sid]
  if typeof(data) != "bytes" then return -1 end if

  slot = _IS_FindChannelForNewSound(sid)

  h = _I_nextHandle
  _I_nextHandle = _I_nextHandle + 1

  _I_chActive[slot] = 1
  _I_chHandle[slot] = h
  _I_chId[slot] = sid
  _I_chData[slot] = data
  _I_chLen[slot] = len(data)
  _I_chPos[slot] = 0
  _I_chFrac[slot] = 0
  _I_chStep[slot] = _IS_ToInt(step, 65536)
  if _I_chStep[slot] < 1 then _I_chStep[slot] = 1 end if
  _I_chStart[slot] = _IS_ToInt(gametic, 0)

  mixVol = _IS_Clamp(_IS_ToInt(volume, 127), 0, 127)
  _IS_SetChannelVolumes(slot, mixVol, _IS_ToInt(seperation, 128))

  return h
end function

/// Preserves the legacy timer callback hook; WinMM/MUS advancement is driven by the main update loop.
function I_HandleSoundTimer()

end function

/// Marks the legacy sound timer enabled while ignoring its obsolete tick-period argument.
/// @param ticks Ticks value supplied to `I_SoundSetTimer`.
function I_SoundSetTimer(ticks)
  ticks = ticks
  global _I_soundTimerEnabled
  _I_soundTimerEnabled = true
end function

/// Clears the legacy sound-timer enabled flag during backend teardown.
function I_SoundDelTimer()
  global _I_soundTimerEnabled
  _I_soundTimerEnabled = false
end function



