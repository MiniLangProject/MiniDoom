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

  Script: s_sound.ml
  Purpose: Implements sound and music orchestration on top of the platform audio layer.
*/
import i_system
import i_sound
import sounds
import z_zone
import m_random
import w_wad
import doomdef
import m_fixed
import p_local
import doomstat
import r_main
import mp_platform
import std.math

const S_MAX_VOLUME = 127
const S_FRACBITS = 16
const S_FRACUNIT = 65536
const _S_NETMSG_SOUND = 201

s_clipping_dist = 1200 * S_FRACUNIT
s_close_dist = 160 * S_FRACUNIT
s_attenuator =(s_clipping_dist - s_close_dist) >> S_FRACBITS

const NORM_PITCH = 128
const NORM_PRIORITY = 64
const NORM_SEP = 128
s_stereo_swing = 96 * S_FRACUNIT

snd_SfxVolume = 15
snd_MusicVolume = 15

mus_paused = false
mus_playing = void
s_currentMusic = 0
s_musicZonePtrs =[]

numChannels = 8
nextcleanup = 15
_s_debugMusicOnce = false
_s_debugSfxOnce = false
_s_sfxPrecached = false

/*
* Struct: channel_t
* Purpose: Stores runtime data for channel type.
*/
struct channel_t
  sfxinfo
  origin
  handle
end struct

/*
* Struct: _s_net_origin_t
* Purpose: Carries positional sound source coordinates decoded from multiplayer sound events.
*/
struct _s_net_origin_t
  x
  y
  z
  angle
end struct

channels =[]

/*
* Function: _S_IsSeq
* Purpose: Implements the _S_IsSeq routine for the internal module support.
*/
function inline _S_IsSeq(v)
  t = typeof(v)
  return t == "array" or t == "list"
end function

/*
* Function: _S_ToInt
* Purpose: Implements the _S_ToInt routine for the internal module support.
*/
function inline _S_ToInt(v, fallback)
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
* Function: _S_EnumIndex
* Purpose: Implements the _S_EnumIndex routine for the internal module support.
*/
function inline _S_EnumIndex(v, limit)
  if typeof(v) == "int" then return v end if

  n = toNumber(v)
  if typeof(n) == "int" then return n end if

  if typeof(v) != "enum" then return -1 end if

  lim = _S_ToInt(limit, 0)
  if lim <= 0 then return -1 end if

  i = 0
  while i < lim
    if v == i then return i end if
    i = i + 1
  end while
  return -1
end function

/*
* Function: _S_LoadPulse
* Purpose: Pumps window/audio updates periodically while expensive audio precache loops run.
*/
function inline _S_LoadPulse(iter)
  if typeof(iter) != "int" then return end if
  if (iter & 15) != 0 then return end if

  if typeof(I_LoadingPulse) == "function" then
    I_LoadingPulse()
  else
    if typeof(I_UpdateNoBlit) == "function" then I_UpdateNoBlit() end if
    if typeof(I_UpdateSound) == "function" then I_UpdateSound() end if
    if typeof(I_SubmitSound) == "function" then I_SubmitSound() end if
  end if
end function

/*
* Function: _S_SfxId
* Purpose: Implements the _S_SfxId routine for the internal module support.
*/
function inline _S_SfxId(v)
  lim = 0
  if _S_IsSeq(S_sfx) then lim = len(S_sfx) end if
  emax = _S_EnumIndex(sfxenum_t.NUMSFX, lim)
  if emax > 0 and(lim == 0 or emax < lim) then lim = emax end if
  if lim <= 0 then lim = 512 end if

  id = _S_EnumIndex(v, lim)
  if id < 0 then id = _S_ToInt(v, -1) end if
  return id
end function

/*
* Function: _S_MusicId
* Purpose: Implements the _S_MusicId routine for the internal module support.
*/
function inline _S_MusicId(v)
  lim = 0
  if _S_IsSeq(S_music) then lim = len(S_music) end if
  emax = _S_EnumIndex(musicenum_t.NUMMUSIC, lim)
  if emax > 0 and(lim == 0 or emax < lim) then lim = emax end if
  if lim <= 0 then lim = 256 end if

  id = _S_EnumIndex(v, lim)
  if id < 0 then id = _S_ToInt(v, -1) end if
  return id
end function

/*
* Function: _S_IDiv
* Purpose: Implements the _S_IDiv routine for the internal module support.
*/
function inline _S_IDiv(a, b)
  if typeof(a) != "int" or typeof(b) != "int" or b == 0 then return 0 end if
  q = a / b
  if q >= 0 then return std.math.floor(q) end if
  return std.math.ceil(q)
end function

/*
* Function: _S_Clamp
* Purpose: Implements the _S_Clamp routine for the internal module support.
*/
function inline _S_Clamp(v, lo, hi)
  if v < lo then return lo end if
  if v > hi then return hi end if
  return v
end function

/*
* Function: _S_Min
* Purpose: Implements the _S_Min routine for the internal module support.
*/
function inline _S_Min(a, b)
  if a < b then return a end if
  return b
end function

/*
* Function: _S_Abs
* Purpose: Implements the _S_Abs routine for the internal module support.
*/
function inline _S_Abs(v)
  if typeof(v) != "int" then return 0 end if
  if v < 0 then return - v end if
  return v
end function

/*
* Function: _S_AngNorm
* Purpose: Implements the _S_AngNorm routine for the internal module support.
*/
function inline _S_AngNorm(a)
  if typeof(a) != "int" then return 0 end if
  return a & 0xFFFFFFFF
end function

/*
* Function: _S_FineSineAt
* Purpose: Implements the _S_FineSineAt routine for the internal module support.
*/
function inline _S_FineSineAt(idx)
  if not _S_IsSeq(finesine) or len(finesine) == 0 then return 0 end if
  i = _S_ToInt(idx, 0)
  if i < 0 then
    i = i % len(finesine)
    if i < 0 then i = i + len(finesine) end if
  end if
  if i >= len(finesine) then i = i % len(finesine) end if
  return finesine[i]
end function

/*
* Function: _S_EnsureChannels
* Purpose: Implements the _S_EnsureChannels routine for the internal module support.
*/
function inline _S_EnsureChannels()
  global channels
  global numChannels

  n = _S_ToInt(numChannels, 8)
  if n < 1 then n = 8 end if
  numChannels = n

  if _S_IsSeq(channels) and len(channels) == n then return end if

  channels =[]
  i = 0
  while i < n
    channels = channels +[channel_t(void, void, -1)]
    i = i + 1
  end while
end function

/*
* Function: _S_EffectiveConsoleSlot
* Purpose: Resolves the effective local player slot, preferring multiplayer platform slot in client mode.
*/
function inline _S_EffectiveConsoleSlot()
  cp = _S_ToInt(consoleplayer, 0)
  if typeof(MP_PlatformIsClientConnected) == "function" and MP_PlatformIsClientConnected() then
    if typeof(MP_PlatformGetLocalPlayerSlot) == "function" then
      cp = _S_ToInt(MP_PlatformGetLocalPlayerSlot(), cp)
    end if
  end if
  return cp
end function

/*
* Function: _S_GetListener
* Purpose: Reads or updates state used by the internal module support.
*/
function inline _S_GetListener()
  if not _S_IsSeq(players) then return void end if
  cp = _S_EffectiveConsoleSlot()
  if cp < 0 or cp >= len(players) then return void end if
  p = players[cp]
  if p is void then return void end if
  return p.mo
end function

/*
* Function: _S_GetSfxById
* Purpose: Reads or updates state used by the internal module support.
*/
function inline _S_GetSfxById(sound_id)
  sid = _S_SfxId(sound_id)
  if sid < 1 then return void end if
  if not _S_IsSeq(S_sfx) or sid >= len(S_sfx) then return void end if
  return S_sfx[sid]
end function

/*
* Function: _S_LinkOf
* Purpose: Implements the _S_LinkOf routine for the internal module support.
*/
function inline _S_LinkOf(sfx)
  if sfx is void then return void end if

  if typeof(sfx.link) == "struct" then
    return sfx.link
  end if

  lid = _S_ToInt(sfx.link, -1)
  if lid > 0 and _S_IsSeq(S_sfx) and lid < len(S_sfx) then
    return S_sfx[lid]
  end if

  return void
end function

/*
* Function: _S_SfxPriority
* Purpose: Implements the _S_SfxPriority routine for the internal module support.
*/
function inline _S_SfxPriority(sfx)
  if sfx is void then return NORM_PRIORITY end if
  return _S_ToInt(sfx.priority, NORM_PRIORITY)
end function

/*
* Function: _S_DegradeUsefulness
* Purpose: Implements the _S_DegradeUsefulness routine for the internal module support.
*/
function inline _S_DegradeUsefulness(sfx)
  if sfx is void then return end if
  if not _S_IsSeq(S_sfx) then return end if
  if typeof(sfx.name) != "string" then return end if

  i = 1
  while i < len(S_sfx)
    cur = S_sfx[i]
    if cur is not void and typeof(cur.name) == "string" and cur.name == sfx.name then
      cur.usefulness = _S_ToInt(cur.usefulness, 0) - 1
      S_sfx[i] = cur
      return
    end if
    i = i + 1
  end while
end function

/*
* Function: _S_SetSfxUsefulnessAndLump
* Purpose: Reads or updates state used by the internal module support.
*/
function inline _S_SetSfxUsefulnessAndLump(sid, sfx)
  if not _S_IsSeq(S_sfx) then return end if
  if sid < 1 or sid >= len(S_sfx) then return end if
  S_sfx[sid] = sfx
end function

/*
* Function: _S_SameXY
* Purpose: Implements the _S_SameXY routine for the internal module support.
*/
function inline _S_SameXY(a, b)
  pa = _S_PosRef(a)
  pb = _S_PosRef(b)
  if pa is void or pb is void then return false end if
  return _S_ToInt(pa.x, 0) == _S_ToInt(pb.x, 1) and _S_ToInt(pa.y, 0) == _S_ToInt(pb.y, 1)
end function

/*
* Function: _S_PosRef
* Purpose: Implements the _S_PosRef routine for the internal module support.
*/
function inline _S_PosRef(v)
  if v is void then return void end if
  if typeof(v) == "struct" then
    if typeof(v.x) == "int" and typeof(v.y) == "int" then
      return v
    end if
    if typeof(v.mo) == "struct" and typeof(v.mo.x) == "int" and typeof(v.mo.y) == "int" then
      return v.mo
    end if
  end if
  return void
end function

/*
* Function: _S_AngRef
* Purpose: Implements the _S_AngRef routine for the internal module support.
*/
function inline _S_AngRef(v)
  if v is void then return 0 end if
  if typeof(v) == "struct" then
    if typeof(v.angle) == "int" then return v.angle end if
    if typeof(v.mo) == "struct" and typeof(v.mo.angle) == "int" then return v.mo.angle end if
  end if
  return 0
end function

/*
* Function: _S_WriteI32
* Purpose: Writes one signed 32-bit integer into bytes for multiplayer sound event payloads.
*/
function inline _S_WriteI32(buf, off, v)
  x = _S_ToInt(v, 0)
  if x < 0 then x = x + 4294967296 end if
  buf[off] = x & 255
  buf[off + 1] =(x >> 8) & 255
  buf[off + 2] =(x >> 16) & 255
  buf[off + 3] =(x >> 24) & 255
end function

/*
* Function: _S_ReadI32
* Purpose: Reads one signed 32-bit integer from multiplayer sound event payload bytes.
*/
function inline _S_ReadI32(buf, off)
  b0 = buf[off] & 255
  b1 = buf[off + 1] & 255
  b2 = buf[off + 2] & 255
  b3 = buf[off + 3] & 255
  x = b0 | (b1 << 8) | (b2 << 16) | (b3 << 24)
  if x >= 2147483648 then x = x - 4294967296 end if
  return x
end function

/*
* Function: _S_MPSendSoundEvent
* Purpose: Sends one positional/non-positional sound event from host (broadcast or target slot).
*/
function _S_MPSendSoundEvent(origin_p, sid, volume, targetSlot)
  if not(typeof(MP_PlatformIsHosting) == "function" and MP_PlatformIsHosting()) then return end if
  if typeof(MP_PlatformNetSend) != "function" then return end if
  if typeof(MP_PlatformGetActiveSlots) != "function" then return end if
  sawidl = _S_SfxId(sfxenum_t.sfx_sawidl)
  if sid == sawidl then
    // Chainsaw idle is a rapid local loop; relaying each tick creates noisy MP spam.
    return
  end if

  src = _S_PosRef(origin_p)
  flags = 0
  sx = 0
  sy = 0
  sz = 0
  sang = 0
  if typeof(src) == "struct" then
    flags = flags | 1
    sx = _S_ToInt(src.x, 0)
    sy = _S_ToInt(src.y, 0)
  end if

  ts = _S_ToInt(targetSlot, -1)
  // Do not broadcast non-positional local/player-only sounds (e.g. weapon idle).
  if ts < 0 and flags == 0 then return end if

  payload = bytes(21, 0)
  payload[0] = _S_NETMSG_SOUND
  payload[1] = sid & 255
  payload[2] = (sid >> 8) & 255
  payload[3] = _S_Clamp(_S_ToInt(volume, snd_SfxVolume), 0, 255) & 255
  payload[4] = flags & 255
  _S_WriteI32(payload, 5, sx)
  _S_WriteI32(payload, 9, sy)
  _S_WriteI32(payload, 13, sz)
  _S_WriteI32(payload, 17, sang)

  if ts >= 0 and ts < MAXPLAYERS then
    MP_PlatformNetSend(ts, payload)
    return
  end if

  active = MP_PlatformGetActiveSlots()
  if not _S_IsSeq(active) then return end if
  i = 0
  while i < len(active)
    slot = _S_ToInt(active[i], -1)
    if slot >= 1 and slot < MAXPLAYERS then
      MP_PlatformNetSend(slot, payload)
    end if
    i = i + 1
  end while
end function

/*
* Function: S_MPSendPickupSoundToPlayer
* Purpose: Sends one pickup sound to the owning player in host-authoritative multiplayer.
*/
function S_MPSendPickupSoundToPlayer(playerSlot, sound_id)
  if not(typeof(MP_PlatformIsHosting) == "function" and MP_PlatformIsHosting()) then return end if
  sid = _S_SfxId(sound_id)
  if sid < 1 then return end if
  ts = _S_ToInt(playerSlot, -1)
  if ts < 0 or ts >= MAXPLAYERS then ts = -1 end if
  _S_MPSendSoundEvent(void, sid, snd_SfxVolume, ts)
end function

/*
* Function: S_NetRecvPacket
* Purpose: Applies one multiplayer sound packet on clients so attenuation uses local listener position.
*/
function S_NetRecvPacket(payload)
  if not(typeof(MP_PlatformIsClientConnected) == "function" and MP_PlatformIsClientConnected()) then return end if
  if typeof(payload) != "bytes" or len(payload) < 5 then return end if
  if (payload[0] & 255) != _S_NETMSG_SOUND then return end if

  sid = (payload[1] & 255) | ((payload[2] & 255) << 8)
  vol = payload[3] & 255
  flags = payload[4] & 255

  origin = void
  if (flags & 1) != 0 and len(payload) >= 21 then
    ox = _S_ReadI32(payload, 5)
    oy = _S_ReadI32(payload, 9)
    oz = _S_ReadI32(payload, 13)
    oa = _S_ReadI32(payload, 17)
    origin = _s_net_origin_t(ox, oy, oz, oa)
  end if

  S_StartSoundAtVolume(origin, sid, vol)
end function

/*
* Function: S_Init
* Purpose: Initializes state and dependencies for the sound system.
*/
function S_Init(sfxVolume, musicVolume)
  global snd_SfxVolume
  global snd_MusicVolume
  global mus_paused
  global mus_playing
  global s_currentMusic
  global s_musicZonePtrs

  if typeof(I_SetChannels) == "function" then I_SetChannels() end if

  _S_EnsureChannels()

  S_SetSfxVolume(sfxVolume)
  S_SetMusicVolume(musicVolume)

  mus_paused = false
  mus_playing = void
  s_currentMusic = 0
  s_musicZonePtrs =[]
  if _S_IsSeq(S_music) then
    i = 0
    while i < len(S_music)
      s_musicZonePtrs = s_musicZonePtrs +[-1]
      i = i + 1
    end while
  end if

  if _S_IsSeq(S_sfx) then
    i = 1
    max = len(S_sfx)
    numSfx = _S_SfxId(sfxenum_t.NUMSFX)
    if numSfx > 0 and numSfx < max then max = numSfx end if
    while i < max
      sfx = S_sfx[i]
      if sfx is not void then
        sfx.lumpnum = -1
        sfx.usefulness = -1
        S_sfx[i] = sfx
      end if
      i = i + 1
    end while
  end if

  snd_SfxVolume = _S_Clamp(_S_ToInt(sfxVolume, snd_SfxVolume), 0, S_MAX_VOLUME)
  snd_MusicVolume = _S_Clamp(_S_ToInt(musicVolume, snd_MusicVolume), 0, S_MAX_VOLUME)
end function

/*
* Function: S_Start
* Purpose: Starts runtime behavior in the sound system.
*/
function S_Start()
  global mus_paused
  global nextcleanup
  global _s_debugMusicOnce

  _S_EnsureChannels()

  cnum = 0
  while cnum < len(channels)
    c = channels[cnum]
    if c is not void and c.sfxinfo is not void then
      S_StopChannel(cnum)
    end if
    cnum = cnum + 1
  end while

  mus_paused = false

  mnum = _S_MusicId(musicenum_t.mus_e1m1)
  if mnum < 1 then mnum = 1 end if
  if gamemode == commercial then
    runnin = _S_MusicId(musicenum_t.mus_runnin)
    if runnin < 1 then runnin = mnum end if
    mnum = runnin + _S_ToInt(gamemap, 1) - 1
  else
    spmus =[
    _S_MusicId(musicenum_t.mus_e3m4),
    _S_MusicId(musicenum_t.mus_e3m2),
    _S_MusicId(musicenum_t.mus_e3m3),
    _S_MusicId(musicenum_t.mus_e1m5),
    _S_MusicId(musicenum_t.mus_e2m7),
    _S_MusicId(musicenum_t.mus_e2m4),
    _S_MusicId(musicenum_t.mus_e2m6),
    _S_MusicId(musicenum_t.mus_e2m5),
    _S_MusicId(musicenum_t.mus_e1m9)
]

    ge = _S_ToInt(gameepisode, 1)
    gm = _S_ToInt(gamemap, 1)
    if ge < 4 then
      mnum = _S_MusicId(musicenum_t.mus_e1m1) +(ge - 1) * 9 + gm - 1
    else
      idx = gm - 1
      idx = _S_Clamp(idx, 0, len(spmus) - 1)
      mnum = spmus[idx]
    end if
  end if

  if typeof(devparm) != "void" and devparm and not _s_debugMusicOnce then
    print "S_Start: level music id=" + mnum
    _s_debugMusicOnce = true
  end if

  S_ChangeMusic(mnum, true)
  nextcleanup = 15
end function

/*
* Function: S_PrecacheLevelAudio
* Purpose: Retrieves and caches data for the sound system.
*/
function S_PrecacheLevelAudio()
  global _s_sfxPrecached

  if _s_sfxPrecached then return end if
  if not _S_IsSeq(S_sfx) then
    _s_sfxPrecached = true
    return
  end if

  max = len(S_sfx)
  numSfx = _S_SfxId(sfxenum_t.NUMSFX)
  if numSfx > 0 and numSfx < max then max = numSfx end if

  i = 1
  while i < max
    sfx = S_sfx[i]
    if sfx is not void and typeof(sfx.name) == "string" and len(sfx.name) > 0 then
      if _S_ToInt(sfx.lumpnum, -1) < 0 and typeof(I_GetSfxLumpNum) == "function" then
        sfx.lumpnum = I_GetSfxLumpNum(sfx)
      end if

      if typeof(I_PrecacheSfx) == "function" then
        _ = I_PrecacheSfx(i)
      else if typeof(W_CacheLumpNum) == "function" and _S_ToInt(sfx.lumpnum, -1) >= 0 then
        _ = W_CacheLumpNum(_S_ToInt(sfx.lumpnum, -1), PU_CACHE)
      end if

      if _S_ToInt(sfx.usefulness, -1) < 1 then sfx.usefulness = 1 end if
      S_sfx[i] = sfx
    end if
    _S_LoadPulse(i)
    i = i + 1
  end while

  _s_sfxPrecached = true
end function

/*
* Function: S_StartSound
* Purpose: Starts runtime behavior in the sound system.
*/
function S_StartSound(origin, sound_id)
  S_StartSoundAtVolume(origin, sound_id, snd_SfxVolume)
end function

/*
* Function: S_StartSoundAtVolume
* Purpose: Starts runtime behavior in the sound system.
*/
function S_StartSoundAtVolume(origin_p, sfx_id, volume)
  global _s_debugSfxOnce
  _S_EnsureChannels()

  /*
  * Treat legacy NULL-style origin (0) as non-positional source.
  */
  if origin_p == 0 then origin_p = void end if

  sid = _S_SfxId(sfx_id)
  if sid < 1 then return end if
  if not _S_IsSeq(S_sfx) or sid >= len(S_sfx) then return end if

  _S_MPSendSoundEvent(origin_p, sid, volume, -1)

  sfx = S_sfx[sid]
  if sfx is void then return end if

  vol = _S_ToInt(volume, snd_SfxVolume)
  sep = NORM_SEP
  pitch = NORM_PITCH
  priority = NORM_PRIORITY

  link = _S_LinkOf(sfx)
  if link is not void then
    pitch = _S_ToInt(sfx.pitch, NORM_PITCH)
    priority = _S_ToInt(sfx.priority, NORM_PRIORITY)
    vol = vol + _S_ToInt(sfx.volume, 0)

    if vol < 1 then return end if
    if vol > snd_SfxVolume then vol = snd_SfxVolume end if
  else
    pitch = NORM_PITCH
    priority = NORM_PRIORITY
  end if

  listener = _S_GetListener()
  if origin_p is not void and listener is not void and origin_p != listener then
    vr =[vol]
    sr =[sep]
    pr =[pitch]

    rc = S_AdjustSoundParams(listener, origin_p, vr, sr, pr)
    vol = _S_ToInt(vr[0], vol)
    sep = _S_ToInt(sr[0], sep)
    pitch = _S_ToInt(pr[0], pitch)

    if _S_SameXY(origin_p, listener) then
      sep = NORM_SEP
    end if

    if not rc then return end if
  else
    sep = NORM_SEP
  end if

  sawup = _S_SfxId(sfxenum_t.sfx_sawup)
  sawhit = _S_SfxId(sfxenum_t.sfx_sawhit)
  itemup = _S_SfxId(sfxenum_t.sfx_itemup)
  tink = _S_SfxId(sfxenum_t.sfx_tink)

  if sid >= sawup and sid <= sawhit then
    pitch = pitch + 8 -(M_Random() & 15)
  else if sid != itemup and sid != tink then
    pitch = pitch + 16 -(M_Random() & 31)
  end if
  pitch = _S_Clamp(pitch, 0, 255)

  S_StopSound(origin_p)

  cnum = S_getChannel(origin_p, sfx)
  if cnum < 0 then return end if

  if _S_ToInt(sfx.lumpnum, -1) < 0 and typeof(I_GetSfxLumpNum) == "function" then
    sfx.lumpnum = I_GetSfxLumpNum(sfx)
  end if

  u = _S_ToInt(sfx.usefulness, -1) + 1
  if u < 1 then u = 1 end if
  sfx.usefulness = u
  _S_SetSfxUsefulnessAndLump(sid, sfx)

  if typeof(I_StartSound) == "function" then
    if typeof(devparm) != "void" and devparm and not _s_debugSfxOnce then
      print "S_StartSoundAtVolume: sid=" + sid + " vol=" + vol + " sep=" + sep + " pitch=" + pitch
      _s_debugSfxOnce = true
    end if
    h = I_StartSound(sid, vol, sep, pitch, priority)
    if cnum >= 0 and cnum < len(channels) then
      c = channels[cnum]
      c.handle = _S_ToInt(h, -1)
      channels[cnum] = c
    end if
  end if
end function

/*
* Function: S_StopSound
* Purpose: Stops or tears down runtime behavior in the sound system.
*/
function S_StopSound(origin)
  _S_EnsureChannels()

  cnum = 0
  while cnum < len(channels)
    c = channels[cnum]
    if c is not void and c.sfxinfo is not void and c.origin == origin then
      S_StopChannel(cnum)
      break
    end if
    cnum = cnum + 1
  end while
end function

/*
* Function: S_StopChannel
* Purpose: Stops or tears down runtime behavior in the sound system.
*/
function S_StopChannel(cnum)
  _S_EnsureChannels()
  if cnum < 0 or cnum >= len(channels) then return end if

  c = channels[cnum]
  if c is void then
    channels[cnum] = channel_t(void, void, -1)
    return
  end if

  if c.sfxinfo is not void then
    h = _S_ToInt(c.handle, -1)
    if h >= 0 and typeof(I_SoundIsPlaying) == "function" and I_SoundIsPlaying(h) and typeof(I_StopSound) == "function" then
      I_StopSound(h)
    end if

    _S_DegradeUsefulness(c.sfxinfo)
  end if

  channels[cnum] = channel_t(void, void, -1)
end function

/*
* Function: S_AdjustSoundParams
* Purpose: Implements the S_AdjustSoundParams routine for the sound system.
*/
function S_AdjustSoundParams(listener, source, vol, sep, pitch)
  lp = _S_PosRef(listener)
  sp = _S_PosRef(source)
  if lp is void or sp is void then return 0 end if
  if typeof(lp) != "struct" or typeof(sp) != "struct" then return 0 end if
  if typeof(lp.x) != "int" or typeof(lp.y) != "int" then return 0 end if
  if typeof(sp.x) != "int" or typeof(sp.y) != "int" then return 0 end if

  v = snd_SfxVolume
  s = NORM_SEP
  p = NORM_PITCH
  if typeof(pitch) == "array" and len(pitch) > 0 then
    p = _S_ToInt(pitch[0], NORM_PITCH)
  end if

  lx = lp.x
  ly = lp.y
  sx = sp.x
  sy = sp.y

  adx = _S_Abs(lx - sx)
  ady = _S_Abs(ly - sy)
  approx_dist = adx + ady -(_S_Min(adx, ady) >> 1)

  if _S_ToInt(gamemap, 1) != 8 and approx_dist > s_clipping_dist then
    return 0
  end if

  angle = R_PointToAngle2(lx, ly, sx, sy)
  lang = _S_AngRef(listener)
  if angle > lang then
    angle = angle - lang
  else
    angle = angle +(0xFFFFFFFF - lang)
  end if
  angle =(_S_AngNorm(angle) >> ANGLETOFINESHIFT)

  s = NORM_SEP -(FixedMul(s_stereo_swing, _S_FineSineAt(angle)) >> S_FRACBITS)

  if approx_dist < s_close_dist then
    v = snd_SfxVolume
  else if _S_ToInt(gamemap, 1) == 8 then
    if approx_dist > s_clipping_dist then approx_dist = s_clipping_dist end if
    if s_attenuator <= 0 then
      v = snd_SfxVolume
    else
      v = 15 + _S_IDiv((snd_SfxVolume - 15) *((s_clipping_dist - approx_dist) >> S_FRACBITS), s_attenuator)
    end if
  else
    if s_attenuator <= 0 then
      v = snd_SfxVolume
    else
      v = _S_IDiv(snd_SfxVolume *((s_clipping_dist - approx_dist) >> S_FRACBITS), s_attenuator)
    end if
  end if

  if typeof(vol) == "array" and len(vol) > 0 then vol[0] = v end if
  if typeof(sep) == "array" and len(sep) > 0 then sep[0] = _S_Clamp(s, 0, 255) end if
  if typeof(pitch) == "array" and len(pitch) > 0 then pitch[0] = _S_Clamp(p, 0, 255) end if

  return v > 0
end function

/*
* Function: S_getChannel
* Purpose: Reads or updates state used by the sound system.
*/
function S_getChannel(origin, sfxinfo)
  _S_EnsureChannels()

  cnum = 0
  while cnum < numChannels
    c = channels[cnum]
    if c is void or c.sfxinfo is void then
      channels[cnum] = channel_t(sfxinfo, origin, -1)
      return cnum
    else if origin is not void and c.origin == origin then
      S_StopChannel(cnum)
      channels[cnum] = channel_t(sfxinfo, origin, -1)
      return cnum
    end if
    cnum = cnum + 1
  end while

  cnum = 0
  inprio = _S_SfxPriority(sfxinfo)
  while cnum < numChannels
    c = channels[cnum]
    if c is not void and c.sfxinfo is not void then
      if _S_SfxPriority(c.sfxinfo) >= inprio then
        break
      end if
    end if
    cnum = cnum + 1
  end while

  if cnum == numChannels then
    return -1
  end if

  S_StopChannel(cnum)
  channels[cnum] = channel_t(sfxinfo, origin, -1)
  return cnum
end function

/*
* Function: S_StartMusic
* Purpose: Starts runtime behavior in the sound system.
*/
function S_StartMusic(music_id)
  S_ChangeMusic(music_id, false)
end function

/*
* Function: S_ChangeMusic
* Purpose: Implements the S_ChangeMusic routine for the sound system.
*/
function S_ChangeMusic(music_id, looping)
  global mus_playing
  global mus_paused
  global s_currentMusic
  global s_musicZonePtrs

  musNone = _S_MusicId(musicenum_t.mus_None)
  if musNone < 0 then musNone = 0 end if
  mid = _S_MusicId(music_id)
  if mid < 0 then mid = musNone end if
  if mid <= musNone then return end if
  numMusic = _S_MusicId(musicenum_t.NUMMUSIC)
  if numMusic > 0 and mid >= numMusic then return end if
  if not _S_IsSeq(S_music) or mid >= len(S_music) then return end if

  if mus_playing is not void and s_currentMusic == mid then return end if

  S_StopMusic()

  music = S_music[mid]
  if music is void then return end if

  lump = _S_ToInt(music.lumpnum, 0)
  if lump <= 0 then
    if typeof(music.name) != "string" or len(music.name) == 0 then return end if
    namebuf = "d_" + music.name
    if typeof(W_CheckNumForName) == "function" and W_CheckNumForName(namebuf) == -1 then return end if
    lump = W_GetNumForName(namebuf)
    music.lumpnum = lump
  end if

  if typeof(W_CacheLumpNum) != "function" then return end if
  music.data = W_CacheLumpNum(lump, PU_MUSIC)
  ptr = -1
  if typeof(W_GetCachedLumpPtr) == "function" then
    ptr = _S_ToInt(W_GetCachedLumpPtr(lump), -1)
  end if
  if _S_IsSeq(s_musicZonePtrs) and mid >= 0 and mid < len(s_musicZonePtrs) then
    s_musicZonePtrs[mid] = ptr
  end if

  if typeof(I_RegisterSong) == "function" then
    music.handle = I_RegisterSong(music.data)
  else
    music.handle = 0
  end if

  if typeof(I_PlaySong) == "function" then
    I_PlaySong(music.handle, looping)
  end if

  S_music[mid] = music
  mus_playing = music
  mus_paused = false
  s_currentMusic = mid
end function

/*
* Function: S_StopMusic
* Purpose: Stops or tears down runtime behavior in the sound system.
*/
function S_StopMusic()
  global mus_playing
  global mus_paused
  global s_currentMusic
  global s_musicZonePtrs

  if mus_playing is void then return end if

  h = _S_ToInt(mus_playing.handle, 0)
  if mus_paused and typeof(I_ResumeSong) == "function" then
    I_ResumeSong(h)
  end if

  if typeof(I_StopSong) == "function" then I_StopSong(h) end if
  if typeof(I_UnRegisterSong) == "function" then I_UnRegisterSong(h) end if

  mid = _S_ToInt(s_currentMusic, 0)
  ptr = -1
  if _S_IsSeq(s_musicZonePtrs) and mid >= 0 and mid < len(s_musicZonePtrs) then
    ptr = _S_ToInt(s_musicZonePtrs[mid], -1)
    s_musicZonePtrs[mid] = -1
  else if mus_playing is not void and typeof(mus_playing.lumpnum) != "void" and typeof(W_GetCachedLumpPtr) == "function" then
    ptr = _S_ToInt(W_GetCachedLumpPtr(mus_playing.lumpnum), -1)
  end if
  if ptr >= 0 and typeof(Z_ChangeTag) == "function" then
    Z_ChangeTag(ptr, PU_CACHE)
  end if

  if _S_IsSeq(S_music) and mid > 0 and mid < len(S_music) then
    m = S_music[mid]
    if m is not void then
      m.data = void
      m.handle = 0
      S_music[mid] = m
    end if
  end if

  mus_playing = void
  mus_paused = false
  s_currentMusic = 0
end function

/*
* Function: S_PauseSound
* Purpose: Implements the S_PauseSound routine for the sound system.
*/
function S_PauseSound()
  global mus_paused

  if mus_playing is not void and not mus_paused and typeof(I_PauseSong) == "function" then
    I_PauseSong(_S_ToInt(mus_playing.handle, 0))
    mus_paused = true
  end if
end function

/*
* Function: S_ResumeSound
* Purpose: Implements the S_ResumeSound routine for the sound system.
*/
function S_ResumeSound()
  global mus_paused

  if mus_playing is not void and mus_paused and typeof(I_ResumeSong) == "function" then
    I_ResumeSong(_S_ToInt(mus_playing.handle, 0))
    mus_paused = false
  end if
end function

/*
* Function: S_UpdateSounds
* Purpose: Advances per-tick logic for the sound system.
*/
function S_UpdateSounds(listener_p)
  _S_EnsureChannels()
  effListener = listener_p
  if effListener is void or(typeof(MP_PlatformIsClientConnected) == "function" and MP_PlatformIsClientConnected()) then
    l2 = _S_GetListener()
    if l2 is not void then effListener = l2 end if
  end if

  cnum = 0
  while cnum < numChannels and cnum < len(channels)
    c = channels[cnum]
    if c is not void and c.sfxinfo is not void then
      h = _S_ToInt(c.handle, -1)
      playing = false
      if h >= 0 and typeof(I_SoundIsPlaying) == "function" then
        playing = I_SoundIsPlaying(h)
      end if

      if playing then
        volume = snd_SfxVolume
        pitch = NORM_PITCH
        sep = NORM_SEP

        sfx = c.sfxinfo
        link = _S_LinkOf(sfx)
        if link is not void then
          pitch = _S_ToInt(sfx.pitch, NORM_PITCH)
          volume = volume + _S_ToInt(sfx.volume, 0)
          if volume < 1 then
            S_StopChannel(cnum)
            cnum = cnum + 1
            continue
          else if volume > snd_SfxVolume then
            volume = snd_SfxVolume
          end if
        end if

        if c.origin is not void and effListener is not void and effListener != c.origin then
          vr =[volume]
          sr =[sep]
          pr =[pitch]
          audible = S_AdjustSoundParams(effListener, c.origin, vr, sr, pr)
          volume = _S_ToInt(vr[0], volume)
          sep = _S_ToInt(sr[0], sep)
          pitch = _S_ToInt(pr[0], pitch)

          if not audible then
            S_StopChannel(cnum)
          else if typeof(I_UpdateSoundParams) == "function" then
            I_UpdateSoundParams(h, volume, sep, pitch)
          end if
        end if
      else
        S_StopChannel(cnum)
      end if
    end if

    cnum = cnum + 1
  end while
end function

/*
* Function: S_SetMusicVolume
* Purpose: Reads or updates state used by the sound system.
*/
function S_SetMusicVolume(volume)
  global snd_MusicVolume

  v = _S_Clamp(_S_ToInt(volume, snd_MusicVolume), 0, S_MAX_VOLUME)
  snd_MusicVolume = v

  if typeof(I_SetMusicVolume) == "function" then
    I_SetMusicVolume(S_MAX_VOLUME)
    I_SetMusicVolume(v)
  end if
end function

/*
* Function: S_SetSfxVolume
* Purpose: Reads or updates state used by the sound system.
*/
function S_SetSfxVolume(volume)
  global snd_SfxVolume

  v = _S_Clamp(_S_ToInt(volume, snd_SfxVolume), 0, S_MAX_VOLUME)
  snd_SfxVolume = v

  if typeof(I_SetSfxVolume) == "function" then
    I_SetSfxVolume(v)
  end if
end function



