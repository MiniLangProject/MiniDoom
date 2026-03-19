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

  Script: mp_sha1.ml
  Purpose: Implements SHA-1 helpers used by MiniDoom multiplayer WAD compatibility checks.
*/

import std.math

_mp_sha1_hex_table = bytes("0123456789abcdef")

/*
* Function: _MP_SHA1_U32
* Purpose: Normalizes integer arithmetic to 32-bit unsigned space.
*/
function _MP_SHA1_U32(v)
  if typeof(v) != "int" then return 0 end if
  return v & 0xFFFFFFFF
end function

/*
* Function: _MP_SHA1_Rol
* Purpose: Computes 32-bit rotate-left.
*/
function _MP_SHA1_Rol(v, n)
  v = _MP_SHA1_U32(v)
  n = n & 31
  if n == 0 then return v end if
  a = v << n
  b = v >> (32 - n)
  return _MP_SHA1_U32(a | b)
end function

/*
* Function: _MP_SHA1_WriteU32BE
* Purpose: Writes a 32-bit value to a bytes buffer in big-endian order.
*/
function _MP_SHA1_WriteU32BE(buf, off, v)
  v = _MP_SHA1_U32(v)
  buf[off] = (v >> 24) & 255
  buf[off + 1] = (v >> 16) & 255
  buf[off + 2] = (v >> 8) & 255
  buf[off + 3] = v & 255
end function

/*
* Function: _MP_SHA1_ReadU32BE
* Purpose: Reads a 32-bit big-endian value from a bytes buffer.
*/
function _MP_SHA1_ReadU32BE(buf, off)
  b0 = buf[off] << 24
  b1 = buf[off + 1] << 16
  b2 = buf[off + 2] << 8
  b3 = buf[off + 3]
  return _MP_SHA1_U32(b0 | b1 | b2 | b3)
end function

/*
* Function: MP_SHA1_Digest
* Purpose: Computes SHA-1 digest bytes for input data.
*/
function MP_SHA1_Digest(data)
  if typeof(data) != "bytes" then return bytes(20, 0) end if

  n = len(data)
  bitlen = n * 8

  padLen = 64 - ((n + 9) % 64)
  if padLen == 64 then padLen = 0 end if
  total = n + 1 + padLen + 8

  msg = bytes(total, 0)
  i = 0
  while i < n
    msg[i] = data[i]
    i = i + 1
  end while
  msg[n] = 0x80

  hi = _MP_SHA1_U32(std.math.floor(bitlen / 4294967296))
  lo = _MP_SHA1_U32(bitlen)
  _MP_SHA1_WriteU32BE(msg, total - 8, hi)
  _MP_SHA1_WriteU32BE(msg, total - 4, lo)

  h0 = 0x67452301
  h1 = 0xEFCDAB89
  h2 = 0x98BADCFE
  h3 = 0x10325476
  h4 = 0xC3D2E1F0

  w = bytes(80 * 4, 0)

  base = 0
  while base < total
    t = 0
    while t < 16
      _MP_SHA1_WriteU32BE(w, t * 4, _MP_SHA1_ReadU32BE(msg, base + t * 4))
      t = t + 1
    end while

    while t < 80
      a0 = _MP_SHA1_ReadU32BE(w, (t - 3) * 4)
      a1 = _MP_SHA1_ReadU32BE(w, (t - 8) * 4)
      a2 = _MP_SHA1_ReadU32BE(w, (t - 14) * 4)
      a3 = _MP_SHA1_ReadU32BE(w, (t - 16) * 4)
      x = a0 ^ a1
      x = x ^ a2
      x = x ^ a3
      _MP_SHA1_WriteU32BE(w, t * 4, _MP_SHA1_Rol(x, 1))
      t = t + 1
    end while

    a = h0
    b = h1
    c = h2
    d = h3
    e = h4

    t = 0
    while t < 80
      f = 0
      k = 0
      if t < 20 then
        f = (b & c) | ((_MP_SHA1_U32(~b)) & d)
        k = 0x5A827999
      else if t < 40 then
        f = b ^ c ^ d
        k = 0x6ED9EBA1
      else if t < 60 then
        f = (b & c) | (b & d) | (c & d)
        k = 0x8F1BBCDC
      else
        f = b ^ c ^ d
        k = 0xCA62C1D6
      end if

      tt = _MP_SHA1_Rol(a, 5)
      tt = tt + f
      tt = tt + e
      tt = tt + k
      tt = tt + _MP_SHA1_ReadU32BE(w, t * 4)
      temp = _MP_SHA1_U32(tt)

      e = d
      d = c
      c = _MP_SHA1_Rol(b, 30)
      b = a
      a = temp
      t = t + 1
    end while

    h0 = _MP_SHA1_U32(h0 + a)
    h1 = _MP_SHA1_U32(h1 + b)
    h2 = _MP_SHA1_U32(h2 + c)
    h3 = _MP_SHA1_U32(h3 + d)
    h4 = _MP_SHA1_U32(h4 + e)

    base = base + 64
  end while

  digest = bytes(20, 0)
  _MP_SHA1_WriteU32BE(digest, 0, h0)
  _MP_SHA1_WriteU32BE(digest, 4, h1)
  _MP_SHA1_WriteU32BE(digest, 8, h2)
  _MP_SHA1_WriteU32BE(digest, 12, h3)
  _MP_SHA1_WriteU32BE(digest, 16, h4)
  return digest
end function

/*
* Function: MP_SHA1_Hex
* Purpose: Returns lowercase hexadecimal SHA-1 digest string for input bytes.
*/
function MP_SHA1_Hex(data)
  d = MP_SHA1_Digest(data)
  if typeof(d) != "bytes" then return "" end if

  hexbuf = bytes(len(d) * 2, 0)
  i = 0
  oi = 0
  while i < len(d)
    v = d[i]
    hexbuf[oi] = _mp_sha1_hex_table[(v >> 4) & 15]
    hexbuf[oi + 1] = _mp_sha1_hex_table[v & 15]
    oi = oi + 2
    i = i + 1
  end while
  return decode(hexbuf)
end function

