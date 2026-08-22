/*
  Copyright 2026 Nils Kopal

  Licensed under the Apache License, Version 2.0 (the "License");
  you may not use this file except in compliance with the License.
  You may obtain a copy of the License at

  http://www.apache.org/licenses/LICENSE-2.0

  Script: mp_transport_unit.ml
  Purpose: Verifies multiplayer wire codecs, strict rejection, and bounded queue freshness in a console test.
*/

import i_net
import mp_fnv1a

/*
* Function: MessageBoxW
* Purpose: Supplies the GUI error-hook symbol expected by i_system while keeping this fixture console-only.
*/
function MessageBoxW(hwnd, text, caption, flags)
  hwnd = hwnd
  text = text
  caption = caption
  flags = flags
  return 0
end function

/*
* Function: _MPTest_Fail
* Purpose: Emits one diagnostic and returns the non-zero process status used by the PowerShell test runner.
*/
function _MPTest_Fail(msg)
  print "MP transport unit FAIL: " + msg
  return 1
end function

/*
* Function: _MPTest_BytesEqual
* Purpose: Compares two byte buffers without coercing or decoding binary wire data.
*/
function _MPTest_BytesEqual(a, b)
  if typeof(a) != "bytes" or typeof(b) != "bytes" then return false end if
  if len(a) != len(b) then return false end if
  i = 0
  while i < len(a)
    if (a[i] & 255) != (b[i] & 255) then return false end if
    i = i + 1
  end while
  return true
end function

/*
* Function: _MPTest_CopyWithExtraByte
* Purpose: Builds a malformed copy with one trailing byte for exact-length decoder tests.
*/
function _MPTest_CopyWithExtraByte(src)
  dst = bytes(len(src) + 1, 0)
  i = 0
  while i < len(src)
    dst[i] = src[i]
    i = i + 1
  end while
  dst[len(src)] = 99
  return dst
end function

/*
* Function: main
* Purpose: Runs deterministic codec, corruption, size-limit, mutation-safety, and queue-overload assertions.
*/
function main(args)
  global _mp_game_queue_nodes
  global _mp_game_queue_payloads
  global _mp_game_queue_head
  global _mp_game_queue_tail
  global _mp_game_queue_dropped
  args = args

  if MP_FNV1A_Hex(bytes("hello")) != "4f9f2cab00000005" then
    return _MPTest_Fail("FNV-1a known vector mismatch")
  end if
  if _MPPlatform_NormalizeIPv4("127.000.0.001") != "127.0.0.1" or _MPPlatform_NormalizeIPv4("127.0.0.999") != "" then
    return _MPTest_Fail("IPv4 endpoint canonicalization mismatch")
  end if

  payload = bytes(6, 0)
  i = 0
  while i < len(payload)
    payload[i] = i * 17 + 3
    i = i + 1
  end while
  frame = _MPPlatform_WrapGamePayload(2, payload)
  if typeof(frame) != "bytes" or len(frame) != len(payload) + 9 then
    return _MPTest_Fail("valid gameplay frame was not encoded")
  end if
  decoded = _MPPlatform_UnwrapGamePayload(frame)
  if not _MPTest_BytesEqual(decoded, payload) then
    return _MPTest_Fail("gameplay frame round-trip mismatch")
  end if

  corrupt = slice(frame, 0, len(frame))
  corrupt[len(corrupt) - 1] = corrupt[len(corrupt) - 1] ^ 1
  if _MPPlatform_UnwrapGamePayload(corrupt) is not void then
    return _MPTest_Fail("checksum corruption was accepted")
  end if
  missingChecksum = slice(frame, 0, len(frame) - 2)
  if _MPPlatform_UnwrapGamePayload(missingChecksum) is not void then
    return _MPTest_Fail("checksum-less frame was accepted")
  end if
  trailing = _MPTest_CopyWithExtraByte(frame)
  if _MPPlatform_UnwrapGamePayload(trailing) is not void then
    return _MPTest_Fail("frame with trailing bytes was accepted")
  end if
  if _MPPlatform_WrapGamePayload(1, bytes(_MPPLAT_GAME_PAYLOAD_MAX + 1, 0)) is not void then
    return _MPTest_Fail("oversized gameplay payload was accepted")
  end if

  _mp_game_queue_nodes = []
  _mp_game_queue_payloads = []
  _mp_game_queue_head = 0
  _mp_game_queue_tail = 0
  _mp_game_queue_dropped = 0
  tiny = bytes(1, 0)
  i = 0
  while i < _MPPLAT_GAME_QUEUE_MAX + 37
    tiny = bytes(1, i & 255)
    _MPPlatform_QueueGamePacket(1, tiny)
    i = i + 1
  end while
  if _MPPlatform_QueueDepth() > _MPPLAT_GAME_QUEUE_MAX then
    return _MPTest_Fail("game queue depth escaped hard cap")
  end if
  if _mp_game_queue_dropped != _MPPLAT_GAME_QUEUE_CHUNK then
    return _MPTest_Fail("game queue drop accounting mismatch")
  end if
  if len(_mp_game_queue_nodes) != _MPPLAT_GAME_QUEUE_MAX or len(_mp_game_queue_payloads) != _MPPLAT_GAME_QUEUE_MAX then
    return _MPTest_Fail("game queue allocated beyond hard cap")
  end if
  newest = _mp_game_queue_payloads[_mp_game_queue_tail - 1]
  if typeof(newest) != "bytes" or len(newest) != 1 or newest[0] != ((_MPPLAT_GAME_QUEUE_MAX + 36) & 255) then
    return _MPTest_Fail("freshest packet was lost during overload recovery")
  end if

  D_NetInitSinglePlayer()
  cmds = array(BACKUPTICS)
  i = 0
  while i < BACKUPTICS
    cmds[i] = ticcmd_t(i, -i, i * 100, i * 3, 0, i & 3)
    i = i + 1
  end while
  original = doomdata_t(12345, 7, 11, 2, 3, cmds)
  doomWire = _INet_EncodeDoomData(original)
  if not _INet_DecodeToNetbuffer(doomWire) then
    return _MPTest_Fail("valid Doom packet was rejected")
  end if
  if netbuffer.checksum != 12345 or netbuffer.numtics != 3 or netbuffer.cmds[2].angleturn != 200 then
    return _MPTest_Fail("Doom packet round-trip mismatch")
  end if

  oldChecksum = netbuffer.checksum
  invalidCount = slice(doomWire, 0, len(doomWire))
  _INet_WriteI32LE(invalidCount, 20, BACKUPTICS + 1)
  if _INet_DecodeToNetbuffer(invalidCount) then
    return _MPTest_Fail("out-of-range tic count was accepted")
  end if
  if netbuffer.checksum != oldChecksum then
    return _MPTest_Fail("invalid packet partially mutated netbuffer")
  end if
  if _INet_DecodeToNetbuffer(_MPTest_CopyWithExtraByte(doomWire)) then
    return _MPTest_Fail("Doom packet with trailing bytes was accepted")
  end if

  print "MP transport unit PASS"
  return 0
end function
