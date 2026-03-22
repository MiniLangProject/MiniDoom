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

  Script: m_cheat.ml
  Purpose: Provides shared math, utility, and low-level helper routines.
*/

/*
* Struct: cheatseq_t
* Purpose: Stores runtime data for cheatseq type.
*/
struct cheatseq_t
  sequence
  p
end struct

firsttime = 1
cheat_xlate_table =[]

/*
* Function: _cht_scramble
* Purpose: Implements the _cht_scramble routine for the internal module support.
*/
function inline _cht_scramble(a)
  a = a & 255
  v =((a & 1) << 7) +((a & 2) << 5) +(a & 4) +((a & 8) << 1) +((a & 16) >> 1) +(a & 32) +((a & 64) >> 5) +((a & 128) >> 7)
  return v & 255
end function

/*
* Function: _cht_ensure_table
* Purpose: Implements the _cht_ensure_table routine for the internal module support.
*/
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

/*
* Function: _cht_key_byte
* Purpose: Implements the _cht_key_byte routine for the internal module support.
*/
function inline _cht_key_byte(key)
  if typeof(key) == "int" then return key & 255 end if
  if typeof(key) == "string" then
    kb = bytes(key)
    if len(kb) > 0 then return kb[0] end if
  end if
  if typeof(key) == "bytes" and len(key) > 0 then return key[0] end if
  return 0
end function

/*
* Function: _cht_seq_len
* Purpose: Implements the _cht_seq_len routine for the internal module support.
*/
function inline _cht_seq_len(seq)
  if typeof(seq) == "bytes" then return len(seq) end if
  if typeof(seq) == "array" then return len(seq) end if
  return 0
end function

/*
* Function: _cht_seq_get
* Purpose: Reads or updates state used by the internal module support.
*/
function inline _cht_seq_get(seq, idx)
  if idx < 0 then return 0 end if
  n = _cht_seq_len(seq)
  if idx >= n then return 0 end if
  return seq[idx]
end function

/*
* Function: _cht_seq_set
* Purpose: Reads or updates state used by the internal module support.
*/
function inline _cht_seq_set(seq, idx, v)
  if idx < 0 then return end if
  n = _cht_seq_len(seq)
  if idx >= n then return end if
  seq[idx] = v & 255
end function

/*
* Function: cht_CheckCheat
* Purpose: Evaluates conditions and returns a decision for the engine module behavior.
*/
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

/*
* Function: _cht_bytes_from_list
* Purpose: Implements the _cht_bytes_from_list routine for the internal module support.
*/
function _cht_bytes_from_list(lst)
  b = bytes(len(lst), 0)
  i = 0
  while i < len(lst)
    b[i] = lst[i] & 255
    i = i + 1
  end while
  return b
end function

/*
* Function: _cht_write_buffer
* Purpose: Implements the _cht_write_buffer routine for the internal module support.
*/
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

/*
* Function: cht_GetParam
* Purpose: Reads or updates state used by the engine module behavior.
*/
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



