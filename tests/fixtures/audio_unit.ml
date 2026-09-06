/*
  Copyright 2026 Nils Kopal

  Licensed under the Apache License, Version 2.0 (the "License");
  you may not use this file except in compliance with the License.
  You may obtain a copy of the License at

  http://www.apache.org/licenses/LICENSE-2.0
*/

//! Checks production PCM gain, stereo separation and distance attenuation without playing sound.
import s_sound

#if TARGET_OS == "windows"
/// Reports fatal diagnostics to the console instead of opening a GUI error dialog.
function MessageBoxW(hwnd, text, caption, flags)
  print caption + ": " + text
  return 0
end function
#endif

/// Returns the largest absolute signed 16-bit sample in an interleaved PCM buffer.
function Audio_Peak(data)
  peak = 0
  i = 0
  while i + 1 < len(data)
    value = _IS_ReadU16(data, i)
    if value > 32767 then value = value - 65536 end if
    if value < 0 then value = -value end if
    if value > peak then peak = value end if
    i = i + 2
  end while
  return peak
end function

/// Compares the exact output samples, including both stereo channels.
function Audio_Equal(a, b)
  if len(a) != len(b) then return false end if
  i = 0
  while i < len(a)
    if a[i] != b[i] then return false end if
    i = i + 1
  end while
  return true
end function

/// Replays identical source samples before and after a sound-parameter update.
function Audio_RenderStartAndUpdate(sid, volume, separation)
  _IS_ResetChannels()
  handle = I_StartSound(sid, volume, separation, 128, 64)
  if handle < 0 then return false end if
  slot = _IS_FindChannelByHandle(handle)
  before = bytes(_IS_MIX_BUF_BYTES, 0)
  after = bytes(_IS_MIX_BUF_BYTES, 0)
  _IS_MixToBytes(before)
  // Rewind the sample, keeping the live channel and its original gains.
  _I_chActive[slot] = 1
  _I_chPos[slot] = 0
  _I_chFrac[slot] = 0
  I_UpdateSoundParams(handle, volume, separation, 128)
  _IS_MixToBytes(after)
  if not Audio_Equal(before, after) then
    print "FAIL PCM sid=" + sid + " volume=" + volume + " pan=" + separation + " start_peak=" + Audio_Peak(before) + " update_peak=" + Audio_Peak(after)
    return false
  end if
  if volume == 0 and Audio_Peak(after) != 0 then return false end if
  return true
end function

/// Exercises the real mixer and spatial frontend with synthetic and optional local IWAD samples.
function main(args)
  global snd_SfxVolume
  global gamemap
  global channels
  global numChannels
  _IS_EnsureSfxCacheSize()
  _IS_InitStepTable()
  _IS_InitMixScaleTable()
  _IS_ResetChannels()
  signal = bytes(4096, 0)
  i = 0
  while i < len(signal)
    signal[i] = 96 + 64 * (i % 2)
    i = i + 1
  end while
  _I_sfxSamples[1] = signal
  _I_sfxRates[1] = 11025
  lengths[1] = len(signal)
  failures = 0
  cases = 0
  volume = 0
  while volume <= 15
    pans = [0, 32, 128, 224, 255]
    i = 0
    while i < len(pans)
      if not Audio_RenderStartAndUpdate(1, volume, pans[i]) then failures = failures + 1 end if
      cases = cases + 1
      i = i + 1
    end while
    volume = volume + 1
  end while
  // Legacy callers using the full mixer range retain the same start/update gain.
  if not Audio_RenderStartAndUpdate(1, 127, 128) then failures = failures + 1 end if
  cases = cases + 1

  // Exercise the full frontend update for a monster 600 map units away.
  snd_SfxVolume = 8
  gamemap = 1
  listener = _s_net_origin_t(0,0,0,0)
  source = _s_net_origin_t(600*65536,0,0,0)
  vr = [8]
  sr = [128]
  pr = [128]
  S_AdjustSoundParams(listener,source,vr,sr,pr)
  _IS_ResetChannels()
  h = I_StartSound(1,vr[0],sr[0],pr[0],64)
  numChannels = 1
  channels = [channel_t(S_sfx[1],source,h)]
  slot = _IS_FindChannelByHandle(h)
  before = bytes(_IS_MIX_BUF_BYTES,0)
  after = bytes(_IS_MIX_BUF_BYTES,0)
  _IS_MixToBytes(before)
  _I_chPos[slot] = 0
  _I_chFrac[slot] = 0
  S_UpdateSounds(listener)
  _IS_MixToBytes(after)
  if not Audio_Equal(before,after) or Audio_Peak(after) == 0 then
    print "FAIL moving-monster frontend update"
    failures = failures + 1
  end if
  cases = cases + 1

  // Muting a channel that was audible must silence its next PCM buffer.
  _I_chPos[slot] = 0
  _I_chFrac[slot] = 0
  I_UpdateSoundParams(h,0,sr[0],pr[0])
  _IS_MixToBytes(after)
  if Audio_Peak(after) != 0 then
    print "FAIL muting an active channel"
    failures = failures + 1
  end if
  cases = cases + 1

  listener = _s_net_origin_t(0,0,0,0)
  source = _s_net_origin_t(0,0,0,0)
  maps = [1,8]
  m = 0
  while m < len(maps)
    gamemap = maps[m]
    volume = 0
    while volume <= 15
      snd_SfxVolume = volume
      previous = volume
      distance = 0
      while distance <= 1600
        source.x = distance * 65536
        vr = [volume]
        sr = [128]
        pr = [128]
        audible = S_AdjustSoundParams(listener,source,vr,sr,pr)
        actual = 0
        if audible then actual = vr[0] end if
        if actual > previous or actual > volume or actual < 0 then
          print "FAIL attenuation map=" + gamemap + " volume=" + volume + " distance=" + distance + " gain=" + actual
          failures = failures + 1
        end if
        previous = actual
        cases = cases + 1
        distance = distance + 80
      end while
      volume = volume + 1
    end while
    m = m + 1
  end while

  // Optional local data is loaded through the production WAD/DMX decoders.
  if len(args) > 0 then
    _I_sfxSamples[1] = bytes(0,0)
    Z_Init()
    W_InitMultipleFiles([args[0]])
    sid = 1
    original = 0
    while sid < len(S_sfx)
      if S_sfx[sid] is not void and typeof(S_sfx[sid].name) == "string" then
        name = "DS" + S_sfx[sid].name
        if W_CheckNumForName(name) >= 0 then
          _I_sfxSamples[sid] = bytes(0,0)
          if not Audio_RenderStartAndUpdate(sid,8,128) then failures = failures + 1 end if
          original = original + 1
        end if
      end if
      sid = sid + 1
    end while
    print "Original DMX effects checked: " + original
    if original == 0 then failures = failures + 1 end if
  end if

#if TARGET_OS == "windows"
  // Submit silence through a device only when explicitly requested by the runner.
  if len(args) > 1 and args[1] == "--device" then
    _IS_ResetChannels()
    _IS_WaveInit()
    if not _I_waveReady or _I_waveHandle == 0 then
      print "FAIL local PCM output initialization"
      failures = failures + 1
    else
      _IS_WaveSubmitMixedBuffer()
      submitted = false
      i = 0
      while i < len(_I_waveBuffers)
        if _I_waveBuffers[i].submitted then submitted = true end if
        i = i + 1
      end while
      if not submitted then
        print "FAIL local PCM buffer submission"
        failures = failures + 1
      else
        print "WinMM device PASS: prepared and queued a silent stereo PCM buffer"
      end if
    end if
    _IS_WaveShutdown()
    cases = cases + 1
  end if
#endif
  print "Audio regression cases=" + cases + " failures=" + failures
  if failures != 0 then return 1 end if
  print "Audio unit PASS: stable PCM gain, panning, silence and monotonic distance attenuation"
  return 0
end function
