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

//! Matches scrambled cheat-key sequences and captures optional numeric parameters from player input.


/// Holds an encoded cheat key sequence, its current match cursor, and optional parameter bytes collected after
/// the fixed prefix.
struct cheatseq_t
  /// Stores sequence for `cheatseq_t`
  sequence
  /// Stores p for `cheatseq_t`
  p
end struct

/// Tracks the mutable firsttime value used by the m cheat subsystem.
firsttime = 1
/// Stores the cheat xlate table collection used by the m cheat subsystem.
cheat_xlate_table =[]

/// Applies Doom's reversible cheat-key bit permutation to one byte.
/// @param a First input operand.
/// @internal
function inline _cht_scramble(a)
  a = a & 255
  v =((a & 1) << 7) +((a & 2) << 5) +(a & 4) +((a & 8) << 1) +((a & 16) >> 1) +(a & 32) +((a & 64) >> 5) +((a & 128) >> 7)
  return v & 255
end function

/// Lazily builds the 256-entry scrambled-key lookup table once and reuses it for subsequent cheat checks.
/// @internal
function _cht_ensure_table()
  global firsttime
  global cheat_xlate_table

  if firsttime == 0 then return end if
  firsttime = 0
  cheat_xlate_table =[]
  i = 0
  while i < 256
    cheat_xlate_table = cheat_xlate_table +[_cht_scramble(i)]
    i = i + 1
  end while
end function

/// Normalizes an input key to its low byte and converts uppercase ASCII letters to lowercase.
/// @param key Input key code to process.
/// @internal
function inline _cht_key_byte(key)
  if typeof(key) == "int" then return key & 255 end if
  if typeof(key) == "string" then
    kb = bytes(key)
    if len(kb) > 0 then return kb[0] end if
  end if
  if typeof(key) == "bytes" and len(key) > 0 then return key[0] end if
  return 0
end function

/// Locates the encoded terminator and returns the number of fixed cheat-sequence bytes before parameters begin.
/// @param seq Seq value supplied to `_cht_seq_len`.
/// @internal
function inline _cht_seq_len(seq)
  if typeof(seq) == "bytes" then return len(seq) end if
  if typeof(seq) == "array" then return len(seq) end if
  return 0
end function

/// Returns cht seq get information from utility state.
/// @param seq Seq value supplied to `_cht_seq_get`.
/// @param idx Zero-based element or table index.
/// @internal
function inline _cht_seq_get(seq, idx)
  if idx < 0 then return 0 end if
  n = _cht_seq_len(seq)
  if idx >= n then return 0 end if
  return seq[idx]
end function

/// Replaces a cheat definition's encoded byte sequence and resets its matching and parameter cursors.
/// @param seq Seq value supplied to `_cht_seq_set`.
/// @param idx Zero-based element or table index.
/// @param v Value consumed by the operation.
/// @internal
function inline _cht_seq_set(seq, idx, v)
  if idx < 0 then return end if
  n = _cht_seq_len(seq)
  if idx >= n then return end if
  seq[idx] = v & 255
end function

/// Feeds one key through a scrambled cheat sequence, advances or resets its cursor, and reports a completed
/// match.
/// @param cht Cht value supplied to `cht_CheckCheat`.
/// @param key Input key code to process.
function cht_CheckCheat(cht, key)
  _cht_ensure_table()

  if cht is void then return 0 end if
  seq = cht.sequence
  if _cht_seq_len(seq) <= 0 then return 0 end if

  rc = 0
  k = _cht_key_byte(key)

  if typeof(cht.p) != "int" then cht.p = 0 end if
  if cht.p < 0 or cht.p >= _cht_seq_len(seq) then cht.p = 0 end if

  cur = _cht_seq_get(seq, cht.p)
  if cur == 0 then
    _cht_seq_set(seq, cht.p, k)
    cht.p = cht.p + 1
  else if cheat_xlate_table[k] == cur then
    cht.p = cht.p + 1
  else
    cht.p = 0
  end if

  cur = _cht_seq_get(seq, cht.p)
  if cur == 1 then
    cht.p = cht.p + 1
  else if cur == 255 then
    cht.p = 0
    rc = 1
  end if

  return rc
end function

/// Packs integer list entries into a byte buffer, truncating each value to the low eight bits.
/// @param lst Lst value supplied to `_cht_bytes_from_list`.
/// @internal
function _cht_bytes_from_list(lst)
  b = bytes(len(lst), 0)
  i = 0
  while i < len(lst)
    b[i] = lst[i] & 255
    i = i + 1
  end while
  return b
end function

/// Copies a captured cheat parameter into either a byte buffer or legacy string-reference array and terminates
/// it.
/// @param buffer Buffer that supplies or receives data.
/// @param outList Out list value supplied to `_cht_write_buffer`.
/// @internal
function _cht_write_buffer(buffer, outList)
  if typeof(buffer) == "bytes" then
    n = len(outList)
    if n > len(buffer) then n = len(buffer) end if
    i = 0
    while i < n
      buffer[i] = outList[i]
      i = i + 1
    end while
    if n < len(buffer) then
      buffer[n] = 0
    else if len(buffer) > 0 then
      buffer[len(buffer) - 1] = 0
    end if
    return
  end if

  if typeof(buffer) == "array" then
    if len(buffer) > 0 then
      buffer[0] = decodeZ(_cht_bytes_from_list(outList))
    end if
  end if
end function

/// Returns cht Get Param information from utility state.
/// @param cht Cht value supplied to `cht_GetParam`.
/// @param buffer Buffer that supplies or receives data.
function cht_GetParam(cht, buffer)
  if cht is void then return "" end if
  seq = cht.sequence
  n = _cht_seq_len(seq)
  if n <= 0 then return "" end if

  p = 0
  while p < n and _cht_seq_get(seq, p) != 1
    p = p + 1
  end while

  if p >= n then
    _cht_write_buffer(buffer,[])
    return ""
  end if

  p = p + 1
  paramOut =[]
  loop
    if p >= n then break end if
    c = _cht_seq_get(seq, p)
    paramOut = paramOut +[c]
    _cht_seq_set(seq, p, 0)
    p = p + 1

    nextv = 255
    if p < n then nextv = _cht_seq_get(seq, p) end if
    if c == 0 or nextv == 255 then break end if
    while true
    end loop

    _cht_write_buffer(buffer, paramOut)
    return decodeZ(_cht_bytes_from_list(paramOut))
  end function



