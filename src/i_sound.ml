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

  Script: i_sound.ml
  Purpose: Implements platform integration for input, timing, video, audio, and OS services.
*/
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

/*
* Function: waveOutOpen
* Purpose: Implements the waveOutOpen routine for the engine module behavior.
*/
extern function waveOutOpen(phwo as bytes, dev as u32, pwfx as bytes, cb as ptr, inst as ptr, flags as u32) from "winmm.dll" symbol "waveOutOpen" returns u32

/*
* Function: waveOutPrepareHeader
* Purpose: Implements the waveOutPrepareHeader routine for the engine module behavior.
*/
extern function waveOutPrepareHeader(hwo as ptr, pwh as ptr, cbwh as u32) from "winmm.dll" symbol "waveOutPrepareHeader" returns u32

/*
* Function: waveOutWrite
* Purpose: Implements the waveOutWrite routine for the engine module behavior.
*/
extern function waveOutWrite(hwo as ptr, pwh as ptr, cbwh as u32) from "winmm.dll" symbol "waveOutWrite" returns u32

/*
* Function: waveOutUnprepareHeader
* Purpose: Implements the waveOutUnprepareHeader routine for the engine module behavior.
*/
extern function waveOutUnprepareHeader(hwo as ptr, pwh as ptr, cbwh as u32) from "winmm.dll" symbol "waveOutUnprepareHeader" returns u32

/*
* Function: waveOutReset
* Purpose: Reads or updates state used by the engine module behavior.
*/
extern function waveOutReset(hwo as ptr) from "winmm.dll" symbol "waveOutReset" returns u32

/*
* Function: waveOutClose
* Purpose: Implements the waveOutClose routine for the engine module behavior.
*/
extern function waveOutClose(hwo as ptr) from "winmm.dll" symbol "waveOutClose" returns u32

/*
* Function: midiOutOpen
* Purpose: Implements the midiOutOpen routine for the engine module behavior.
*/
extern function midiOutOpen(phmo as bytes, dev as u32, cb as ptr, inst as ptr, flags as u32) from "winmm.dll" symbol "midiOutOpen" returns u32

/*
* Function: midiOutShortMsg
* Purpose: Implements the midiOutShortMsg routine for the engine module behavior.
*/
extern function midiOutShortMsg(hmo as ptr, msg as u32) from "winmm.dll" symbol "midiOutShortMsg" returns u32

/*
* Function: midiOutReset
* Purpose: Reads or updates state used by the engine module behavior.
*/
extern function midiOutReset(hmo as ptr) from "winmm.dll" symbol "midiOutReset" returns u32

/*
* Function: midiOutClose
* Purpose: Implements the midiOutClose routine for the engine module behavior.
*/
extern function midiOutClose(hmo as ptr) from "winmm.dll" symbol "midiOutClose" returns u32

/*
* Function: midiOutSetVolume
* Purpose: Reads or updates state used by the engine module behavior.
*/
extern function midiOutSetVolume(hmo as ptr, vol as u32) from "winmm.dll" symbol "midiOutSetVolume" returns u32

/*
* Function: GlobalAlloc
* Purpose: Implements the GlobalAlloc routine for the engine module behavior.
*/
extern function GlobalAlloc(flags as u32, size as u32) from "kernel32.dll" symbol "GlobalAlloc" returns ptr

/*
* Function: GlobalFree
* Purpose: Implements the GlobalFree routine for the engine module behavior.
*/
extern function GlobalFree(mem as ptr) from "kernel32.dll" symbol "GlobalFree" returns ptr

/*
* Function: RtlMoveMemoryToPtr
* Purpose: Computes movement/collision behavior in the engine module behavior.
*/
extern function RtlMoveMemoryToPtr(dst as ptr, src as bytes, len as u32) from "kernel32.dll" symbol "RtlMoveMemory" returns void

/*
* Function: RtlMoveMemoryFromPtr
* Purpose: Computes movement/collision behavior in the engine module behavior.
*/
extern function RtlMoveMemoryFromPtr(dst as bytes, src as ptr, len as u32) from "kernel32.dll" symbol "RtlMoveMemory" returns void

const _IS_MIX_RATE = 11025
const _IS_MIX_SAMPLES = 512
const _IS_MIX_BUF_BYTES = _IS_MIX_SAMPLES * 4
const _IS_NUM_MIX_CHANNELS = 8
const _IS_NUM_WAVE_BUFS = 4
const _IS_WAVEHDR_SIZE = 48
const _IS_WHDR_DONE = 0x00000001
const _IS_WAVE_MAPPER = 0xFFFFFFFF
const _IS_MIDI_MAPPER = 0xFFFFFFFF
const _IS_GMEM_FIXED = 0x0000

/*
* Struct: _I_wavebuf_t
* Purpose: Stores runtime data for I wavebuf type.
*/
struct _I_wavebuf_t
  dataPtr
  hdrPtr
  submitted
end struct

_I_nextHandle = 1
_I_sfxVolume = 127
lengths =[]

_I_stepTable =[]
_I_sfxRates =[]
_I_sfxSamples =[]

_I_chActive =[]
_I_chHandle =[]
_I_chId =[]
_I_chData =[]
_I_chLen =[]
_I_chPos =[]
_I_chFrac =[]
_I_chStep =[]
_I_chStart =[]
_I_chLeftVol =[]
_I_chRightVol =[]

_I_waveBuffers =[]
_I_waveHandle = 0
_I_waveReady = false

_I_mixScratch = bytes(_IS_MIX_BUF_BYTES, 0)

_I_musicVolume = 127
_I_nextSongHandle = 1000
_I_songData =[]
_I_currentSongHandle = -1

_I_midiHandle = 0
_I_musicData = void
_I_musicPlaying = false
_I_musicPaused = false
_I_musicLooping = false
_I_musicScoreStart = 0
_I_musicScoreEnd = 0
_I_musicPos = 0
_I_musicDelay = 0
_I_musicLastMs = 0
_I_musicMsFrac = 0

_I_musicChanVel =[]
_I_musicChanMap =[]
_I_musicUsedMidi =[]
_I_midiDbgPrinted = false

_I_soundTimerEnabled = false

/*
* Function: _IS_IsSeq
* Purpose: Implements the _IS_IsSeq routine for the internal module support.
*/
function inline _IS_IsSeq(v)
  t = typeof(v)
  return t == "array" or t == "list"
end function

/*
* Function: _IS_ToInt
* Purpose: Implements the _IS_ToInt routine for the internal module support.
*/
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

/*
* Function: _ISnd_IDiv
* Purpose: Implements the _ISnd_IDiv routine for the internal module support.
*/
function inline _ISnd_IDiv(a, b)
  ai = _IS_ToInt(a, 0)
  bi = _IS_ToInt(b, 0)
  if bi == 0 then return 0 end if
  q = ai / bi
  if q >= 0 then return std.math.floor(q) end if
  return std.math.ceil(q)
end function

/*
* Function: _IS_Clamp
* Purpose: Implements the _IS_Clamp routine for the internal module support.
*/
function inline _IS_Clamp(v, lo, hi)
  n = _IS_ToInt(v, lo)
  if n < lo then n = lo end if
  if n > hi then n = hi end if
  return n
end function

/*
* Function: _IS_NormalizeVolume127
* Purpose: Implements the _IS_NormalizeVolume127 routine for the internal module support.
*/
function inline _IS_NormalizeVolume127(v)
  n = _IS_Clamp(v, 0, 127)
  if n <= 15 then
    return _ISnd_IDiv(n * 127, 15)
  end if
  return n
end function

/*
* Function: _IS_CalcStereoVolumes
* Purpose: Implements the _IS_CalcStereoVolumes routine for the internal module support.
*/
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

/*
* Function: _IS_WriteU16
* Purpose: Implements the _IS_WriteU16 routine for the internal module support.
*/
function inline _IS_WriteU16(buf, off, value)
  if typeof(buf) != "bytes" then return end if
  v = _IS_ToInt(value, 0)
  if v < 0 then v = 0 end if
  buf[off] = v & 255
  buf[off + 1] =(v >> 8) & 255
end function

/*
* Function: _IS_WriteU32
* Purpose: Implements the _IS_WriteU32 routine for the internal module support.
*/
function inline _IS_WriteU32(buf, off, value)
  if typeof(buf) != "bytes" then return end if
  v = _IS_ToInt(value, 0)
  if v < 0 then v = 0 end if
  buf[off] = v & 255
  buf[off + 1] =(v >> 8) & 255
  buf[off + 2] =(v >> 16) & 255
  buf[off + 3] =(v >> 24) & 255
end function

/*
* Function: _IS_WriteU64
* Purpose: Implements the _IS_WriteU64 routine for the internal module support.
*/
function inline _IS_WriteU64(buf, off, value)
  if typeof(buf) != "bytes" then return end if
  v = _IS_ToInt(value, 0)
  lo = v & 0xFFFFFFFF
  hi =(v >> 32) & 0xFFFFFFFF
  _IS_WriteU32(buf, off, lo)
  _IS_WriteU32(buf, off + 4, hi)
end function

/*
* Function: _IS_ReadU16
* Purpose: Implements the _IS_ReadU16 routine for the internal module support.
*/
function inline _IS_ReadU16(buf, off)
  if typeof(buf) != "bytes" then return 0 end if
  if typeof(off) != "int" then return 0 end if
  if off < 0 or(off + 1) >= len(buf) then return 0 end if
  return buf[off] +(buf[off + 1] << 8)
end function

/*
* Function: _IS_ReadU32
* Purpose: Implements the _IS_ReadU32 routine for the internal module support.
*/
function inline _IS_ReadU32(buf, off)
  if typeof(buf) != "bytes" then return 0 end if
  if typeof(off) != "int" then return 0 end if
  if off < 0 or(off + 3) >= len(buf) then return 0 end if
  return buf[off] +(buf[off + 1] << 8) +(buf[off + 2] << 16) +(buf[off + 3] << 24)
end function

/*
* Function: _IS_ReadU64
* Purpose: Implements the _IS_ReadU64 routine for the internal module support.
*/
function inline _IS_ReadU64(buf, off)
  lo = _IS_ReadU32(buf, off)
  hi = _IS_ReadU32(buf, off + 4)
  return lo +(hi << 32)
end function

/*
* Function: _IS_EnumIndex
* Purpose: Implements the _IS_EnumIndex routine for the internal module support.
*/
function inline _IS_EnumIndex(v, fallback)
  if typeof(v) == "int" then return v end if
  n = toNumber(v)
  if typeof(n) == "int" then return n end if
  return fallback
end function

/*
* Function: _IS_TickMs
* Purpose: Implements the _IS_TickMs routine for the internal module support.
*/
function inline _IS_TickMs()
  if typeof(_I_GetTickCount) == "function" then
    return _IS_ToInt(_I_GetTickCount(), 0)
  end if
  return 0
end function

/*
* Function: _IS_EnsureSfxCacheSize
* Purpose: Retrieves and caches data for the internal module support.
*/
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

/*
* Function: _IS_InitStepTable
* Purpose: Initializes state and dependencies for the internal module support.
*/
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

/*
* Function: _IS_ResetChannels
* Purpose: Reads or updates state used by the internal module support.
*/
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

/*
* Function: _IS_SetChannelVolumes
* Purpose: Reads or updates state used by the internal module support.
*/
function inline _IS_SetChannelVolumes(slot, vol, sep)
  if slot < 0 or slot >= _IS_NUM_MIX_CHANNELS then return end if

  v = _IS_Clamp(vol, 0, 127)
  lr = _IS_CalcStereoVolumes(v, sep)
  _I_chLeftVol[slot] = _IS_ToInt(lr[0], 0)
  _I_chRightVol[slot] = _IS_ToInt(lr[1], 0)
end function

/*
* Function: _IS_LoadSfxData
* Purpose: Loads and prepares data required by the internal module support.
*/
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
    i = 0
    while i < samples and(8 + i) < len(raw)
      sdata[i] = raw[8 + i]
      i = i + 1
    end while
  end if

  _I_sfxRates[id] = rate
  _I_sfxSamples[id] = sdata
  lengths[id] = samples
  return true
end function

/*
* Function: _IS_ShouldSingleInstance
* Purpose: Implements the _IS_ShouldSingleInstance routine for the internal module support.
*/
function inline _IS_ShouldSingleInstance(sid)
  sawup = _IS_EnumIndex(sfxenum_t.sfx_sawup, -1000)
  sawidl = _IS_EnumIndex(sfxenum_t.sfx_sawidl, -1000)
  sawful = _IS_EnumIndex(sfxenum_t.sfx_sawful, -1000)
  sawhit = _IS_EnumIndex(sfxenum_t.sfx_sawhit, -1000)
  stnmov = _IS_EnumIndex(sfxenum_t.sfx_stnmov, -1000)
  pistol = _IS_EnumIndex(sfxenum_t.sfx_pistol, -1000)

  return sid == sawup or sid == sawidl or sid == sawful or sid == sawhit or sid == stnmov or sid == pistol
end function

/*
* Function: _IS_FindChannelForNewSound
* Purpose: Implements the _IS_FindChannelForNewSound routine for the internal module support.
*/
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

/*
* Function: _IS_PitchToStep
* Purpose: Implements the _IS_PitchToStep routine for the internal module support.
*/
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

/*
* Function: _IS_FindChannelByHandle
* Purpose: Implements the _IS_FindChannelByHandle routine for the internal module support.
*/
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

/*
* Function: _IS_StopAllSfx
* Purpose: Stops or tears down runtime behavior in the internal module support.
*/
function inline _IS_StopAllSfx()
  i = 0
  while i < _IS_NUM_MIX_CHANNELS
    _I_chActive[i] = 0
    i = i + 1
  end while
end function

/*
* Function: _IS_WaveFormat
* Purpose: Implements the _IS_WaveFormat routine for the internal module support.
*/
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

/*
* Function: _IS_WaveInit
* Purpose: Initializes state and dependencies for the internal module support.
*/
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

/*
* Function: _IS_WaveShutdown
* Purpose: Implements the _IS_WaveShutdown routine for the internal module support.
*/
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

/*
* Function: _IS_WaveIsDone
* Purpose: Implements the _IS_WaveIsDone routine for the internal module support.
*/
function inline _IS_WaveIsDone(wb)
  if wb is void then return false end if
  if not wb.submitted then return true end if

  if _IS_ToInt(wb.hdrPtr, 0) == 0 then return true end if

  hdr = bytes(_IS_WAVEHDR_SIZE, 0)
  RtlMoveMemoryFromPtr(hdr, wb.hdrPtr, _IS_WAVEHDR_SIZE)
  flags = _IS_ReadU32(hdr, 24)
  return (flags & _IS_WHDR_DONE) != 0
end function

/*
* Function: _IS_WaveRefresh
* Purpose: Implements the _IS_WaveRefresh routine for the internal module support.
*/
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

/*
* Function: _IS_WaveFindFreeBuffer
* Purpose: Implements the _IS_WaveFindFreeBuffer routine for the internal module support.
*/
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

/*
* Function: _IS_ClampS16
* Purpose: Implements the _IS_ClampS16 routine for the internal module support.
*/
function inline _IS_ClampS16(v)
  n = _IS_ToInt(v, 0)
  if n > 0x7FFF then return 0x7FFF end if
  if n < -0x8000 then return -0x8000 end if
  return n
end function

/*
* Function: _IS_MixToBytes
* Purpose: Implements the _IS_MixToBytes routine for the internal module support.
*/
function _IS_MixToBytes(outb)
  if typeof(outb) != "bytes" then return end if
  if len(outb) < _IS_MIX_BUF_BYTES then return end if

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

          dl = dl + _ISnd_IDiv(lv *(sample - 128) * 256, 127)
          dr = dr + _ISnd_IDiv(rv *(sample - 128) * 256, 127)

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

/*
* Function: _IS_WaveSubmitMixedBuffer
* Purpose: Implements the _IS_WaveSubmitMixedBuffer routine for the internal module support.
*/
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

/*
* Function: _IS_MidiInit
* Purpose: Initializes state and dependencies for the internal module support.
*/
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

/*
* Function: _IS_MidiShutdown
* Purpose: Implements the _IS_MidiShutdown routine for the internal module support.
*/
function inline _IS_MidiShutdown()
  global _I_midiHandle

  if _I_midiHandle == 0 then return end if

  _ = midiOutReset(_I_midiHandle)
  _ = midiOutClose(_I_midiHandle)
  _I_midiHandle = 0
end function

/*
* Function: _IS_MidiMsg2
* Purpose: Implements the _IS_MidiMsg2 routine for the internal module support.
*/
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

/*
* Function: _IS_MidiMsg3
* Purpose: Implements the _IS_MidiMsg3 routine for the internal module support.
*/
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

/*
* Function: _IS_MidiAllNotesOff
* Purpose: Implements the _IS_MidiAllNotesOff routine for the internal module support.
*/
function inline _IS_MidiAllNotesOff()
  if _I_midiHandle == 0 then return end if

  ch = 0
  while ch < 16
    _IS_MidiMsg3(0xB0 | ch, 123, 0)
    _IS_MidiMsg3(0xB0 | ch, 120, 0)
    ch = ch + 1
  end while
end function

/*
* Function: _IS_MusicResetRuntime
* Purpose: Reads or updates state used by the internal module support.
*/
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

/*
* Function: _IS_MusCtrlToMidi
* Purpose: Implements the _IS_MusCtrlToMidi routine for the internal module support.
*/
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

/*
* Function: _IS_MapMusChannel
* Purpose: Implements the _IS_MapMusChannel routine for the internal module support.
*/
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

/*
* Function: _IS_MusicScale7
* Purpose: Implements the _IS_MusicScale7 routine for the internal module support.
*/
function inline _IS_MusicScale7(v)
  x = _IS_Clamp(v, 0, 127)
  return _IS_Clamp(_ISnd_IDiv(x * _I_musicVolume, 127), 0, 127)
end function

/*
* Function: _IS_ReadMusVarLen
* Purpose: Implements the _IS_ReadMusVarLen routine for the internal module support.
*/
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

/*
* Function: _IS_MusicFindSlotIndex
* Purpose: Implements the _IS_MusicFindSlotIndex routine for the internal module support.
*/
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

/*
* Function: _IS_MusicSetSlotPlaying
* Purpose: Reads or updates state used by the internal module support.
*/
function inline _IS_MusicSetSlotPlaying(handle, playing, looping)
  idx = _IS_MusicFindSlotIndex(handle)
  if idx < 0 then return end if

  slot = _I_songData[idx]
  slot[2] = looping
  slot[3] = playing
  _I_songData[idx] = slot
end function

/*
* Function: _IS_MusicStopInternal
* Purpose: Stops or tears down runtime behavior in the internal module support.
*/
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

/*
* Function: _IS_MusicStartInternal
* Purpose: Starts runtime behavior in the internal module support.
*/
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

/*
* Function: _IS_MusicProcessSlice
* Purpose: Implements the _IS_MusicProcessSlice routine for the internal module support.
*/
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

/*
* Function: _IS_MusicRestart
* Purpose: Starts runtime behavior in the internal module support.
*/
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

/*
* Function: _IS_MusicRunTicks
* Purpose: Implements the _IS_MusicRunTicks routine for the internal module support.
*/
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

/*
* Function: _IS_MusicTicker
* Purpose: Advances per-tick logic for the internal module support.
*/
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

/*
* Function: I_InitSound
* Purpose: Initializes state and dependencies for the platform layer.
*/
function I_InitSound()
  global _I_nextHandle

  _IS_EnsureSfxCacheSize()
  _IS_InitStepTable()
  _IS_ResetChannels()
  _IS_WaveInit()

  _I_nextHandle = 1
  I_InitMusic()
end function

/*
* Function: I_UpdateSound
* Purpose: Advances per-tick logic for the platform layer.
*/
function I_UpdateSound()
  _IS_MusicTicker()
end function

/*
* Function: I_SubmitSound
* Purpose: Implements the I_SubmitSound routine for the platform layer.
*/
function I_SubmitSound()

  n = 0
  while n < _IS_NUM_WAVE_BUFS
    _IS_WaveSubmitMixedBuffer()
    n = n + 1
  end while
end function

/*
* Function: I_ShutdownSound
* Purpose: Implements the I_ShutdownSound routine for the platform layer.
*/
function I_ShutdownSound()
  _IS_StopAllSfx()
  _IS_WaveShutdown()
  I_ShutdownMusic()
end function

/*
* Function: I_SetChannels
* Purpose: Reads or updates state used by the platform layer.
*/
function I_SetChannels()
  _IS_InitStepTable()
  _IS_ResetChannels()
end function

/*
* Function: I_GetSfxLumpNum
* Purpose: Reads or updates state used by the platform layer.
*/
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

/*
* Function: I_PrecacheSfx
* Purpose: Retrieves and caches data for the platform layer.
*/
function I_PrecacheSfx(id)
  sid = _IS_ToInt(id, -1)
  if sid < 0 then return false end if
  return _IS_LoadSfxData(sid)
end function

/*
* Function: I_StartSound
* Purpose: Starts runtime behavior in the platform layer.
*/
function I_StartSound(id, vol, sep, pitch, priority)
  priority = priority

  sid = _IS_ToInt(id, -1)
  if sid < 0 then return -1 end if

  if not _IS_LoadSfxData(sid) then return -1 end if

  rate = _IS_MIX_RATE
  if sid >= 0 and sid < len(_I_sfxRates) then rate = _IS_ToInt(_I_sfxRates[sid], _IS_MIX_RATE) end if
  step = _IS_PitchToStep(pitch, rate)

  return addsfx(sid, _IS_ToInt(vol, 127), step, _IS_ToInt(sep, 128))
end function

/*
* Function: I_StopSound
* Purpose: Stops or tears down runtime behavior in the platform layer.
*/
function I_StopSound(handle)
  slot = _IS_FindChannelByHandle(handle)
  if slot < 0 then return end if
  _I_chActive[slot] = 0
end function

/*
* Function: I_SoundIsPlaying
* Purpose: Implements the I_SoundIsPlaying routine for the platform layer.
*/
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

/*
* Function: I_UpdateSoundParams
* Purpose: Advances per-tick logic for the platform layer.
*/
function I_UpdateSoundParams(handle, vol, sep, pitch)
  slot = _IS_FindChannelByHandle(handle)
  if slot < 0 then return end if

  sid = _IS_ToInt(_I_chId[slot], -1)
  rate = _IS_MIX_RATE
  if sid >= 0 and sid < len(_I_sfxRates) then rate = _IS_ToInt(_I_sfxRates[sid], _IS_MIX_RATE) end if

  _I_chStep[slot] = _IS_PitchToStep(pitch, rate)
  _IS_SetChannelVolumes(slot, _IS_ToInt(vol, 127), _IS_ToInt(sep, 128))
end function

/*
* Function: I_InitMusic
* Purpose: Initializes state and dependencies for the platform layer.
*/
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

/*
* Function: I_ShutdownMusic
* Purpose: Implements the I_ShutdownMusic routine for the platform layer.
*/
function I_ShutdownMusic()
  _IS_MusicStopInternal(false)
  _IS_MidiShutdown()
end function

/*
* Function: I_SetMusicVolume
* Purpose: Reads or updates state used by the platform layer.
*/
function I_SetMusicVolume(volume)
  global _I_musicVolume

  _I_musicVolume = _IS_NormalizeVolume127(volume)

  if _I_midiHandle != 0 then
    v16 = _IS_Clamp(_ISnd_IDiv(_I_musicVolume * 65535, 127), 0, 65535)
    vv = v16 |(v16 << 16)
    _ = midiOutSetVolume(_I_midiHandle, vv)
  end if
end function

/*
* Function: I_SetSfxVolume
* Purpose: Reads or updates state used by the platform layer.
*/
function I_SetSfxVolume(volume)
  global _I_sfxVolume
  _I_sfxVolume = _IS_NormalizeVolume127(volume)
end function

/*
* Function: I_PauseSong
* Purpose: Implements the I_PauseSong routine for the platform layer.
*/
function I_PauseSong(handle)
  global _I_musicPaused
  h = _IS_ToInt(handle, -1)
  if h < 0 or h != _I_currentSongHandle then return end if
  if not _I_musicPlaying or _I_musicPaused then return end if

  _I_musicPaused = true
  if _I_midiHandle != 0 then _ = midiOutReset(_I_midiHandle) end if
  _IS_MusicSetSlotPlaying(h, false, _I_musicLooping)
end function

/*
* Function: I_ResumeSong
* Purpose: Implements the I_ResumeSong routine for the platform layer.
*/
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

/*
* Function: I_RegisterSong
* Purpose: Implements the I_RegisterSong routine for the platform layer.
*/
function I_RegisterSong(data)
  global _I_nextSongHandle
  global _I_songData

  h = _I_nextSongHandle
  _I_nextSongHandle = _I_nextSongHandle + 1

  _I_songData = _I_songData +[[h, data, false, false]]
  return h
end function

/*
* Function: I_PlaySong
* Purpose: Implements the I_PlaySong routine for the platform layer.
*/
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

/*
* Function: I_StopSong
* Purpose: Stops or tears down runtime behavior in the platform layer.
*/
function I_StopSong(handle)
  h = _IS_ToInt(handle, -1)
  if h >= 0 and h != _I_currentSongHandle then
    _IS_MusicSetSlotPlaying(h, false, false)
    return
  end if

  _IS_MusicStopInternal(true)
end function

/*
* Function: I_UnRegisterSong
* Purpose: Implements the I_UnRegisterSong routine for the platform layer.
*/
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

/*
* Function: I_QrySongPlaying
* Purpose: Implements the I_QrySongPlaying routine for the platform layer.
*/
function I_QrySongPlaying(handle)
  h = _IS_ToInt(handle, -1)
  if h < 0 then return false end if
  return _I_musicPlaying and(not _I_musicPaused) and h == _I_currentSongHandle
end function

/*
* Function: myioctl
* Purpose: Implements the myioctl routine for the engine module behavior.
*/
function myioctl(fd, req, arg)
  fd = fd
  req = req
  arg = arg
  return 0
end function

/*
* Function: getsfx
* Purpose: Reads or updates state used by the engine module behavior.
*/
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

/*
* Function: addsfx
* Purpose: Implements the addsfx routine for the engine module behavior.
*/
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

/*
* Function: I_HandleSoundTimer
* Purpose: Implements the I_HandleSoundTimer routine for the platform layer.
*/
function I_HandleSoundTimer()

end function

/*
* Function: I_SoundSetTimer
* Purpose: Reads or updates state used by the platform layer.
*/
function I_SoundSetTimer(ticks)
  ticks = ticks
  global _I_soundTimerEnabled
  _I_soundTimerEnabled = true
end function

/*
* Function: I_SoundDelTimer
* Purpose: Implements the I_SoundDelTimer routine for the platform layer.
*/
function I_SoundDelTimer()
  global _I_soundTimerEnabled
  _I_soundTimerEnabled = false
end function



