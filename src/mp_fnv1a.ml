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

//! Provides fast, non-cryptographic WAD fingerprint helpers for multiplayer compatibility checks.


/// Tracks the mutable mp hash hex table value used by the mp fnv1a subsystem.
/// @internal
_mp_hash_hex_table = bytes("0123456789abcdef")

/// Normalizes integer arithmetic to 32-bit unsigned space.
/// @param v Value consumed by the operation.
/// @internal
function inline _MP_HASH_U32(v)
  if typeof(v) != "int" then return 0 end if
  return v & 0xFFFFFFFF
end function

/// Formats one 32-bit value as eight lowercase hexadecimal characters.
/// @param v Value consumed by the operation.
/// @internal
function _MP_HASH_ToHex8(v)
  x = _MP_HASH_U32(v)
  hexout = bytes(8, 0)
  i = 7
  while i >= 0
    hexout[i] = _mp_hash_hex_table[x & 15]
    x = x >> 4
    i = i - 1
  end while
  return decode(hexout)
end function

/// Returns `<fnv32><length32>` as 16 lowercase hex digits for deterministic IWAD compatibility checks.
/// Security: This detects accidental content mismatches; it is not an authentication or tamper-proof hash.
/// @param data Binary or structured data to process.
function MP_FNV1A_Hex(data)
  if typeof(data) != "bytes" then return "" end if

  // FNV-1a 32-bit core (fast, deterministic).
  h = 2166136261
  i = 0
  while i < len(data)
    h = h ^ (data[i] & 255)
    // Multiply by FNV prime 16777619 in 32-bit space.
    h = _MP_HASH_U32(h * 16777619)
    i = i + 1
  end while

  // Include byte length in fingerprint string to lower practical collision risk for WAD matching.
  n = _MP_HASH_U32(len(data))
  return _MP_HASH_ToHex8(h) + _MP_HASH_ToHex8(n)
end function
