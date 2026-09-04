# `src/m_cheat.ml`

[Home](README.md) · [Files](Files.md)

Matches scrambled cheat-key sequences and captures optional numeric parameters from player input.

Package: [`(global)`](Package-global-1952375359.md)

Reachable from entry: **yes**

## Declarations

<a id="function-function-cht-bytes-from-list-function-cht-bytes-from-list-lst-src-m-cheat-ml-1327058122"></a>
### _cht_bytes_from_list

```ml
function _cht_bytes_from_list(lst)
```

Packs integer list entries into a byte buffer, truncating each value to the low eight bits.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `lst` | `dynamic` | — | Lst value supplied to `_cht_bytes_from_list`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/m_cheat.ml#L146)

<a id="function-function-cht-ensure-table-function-cht-ensure-table-src-m-cheat-ml-1282062907"></a>
### _cht_ensure_table

```ml
function _cht_ensure_table()
```

Lazily builds the 256-entry scrambled-key lookup table once and reuses it for subsequent cheat checks.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/m_cheat.ml#L46)

<a id="function-function-cht-key-byte-inline-function-cht-key-byte-key-src-m-cheat-ml-1404954707"></a>
### _cht_key_byte

```ml
inline function _cht_key_byte(key)
```

Normalizes an input key to its low byte and converts uppercase ASCII letters to lowercase.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `key` | `dynamic` | — | Input key code to process. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/m_cheat.ml#L63)

<a id="function-function-cht-scramble-inline-function-cht-scramble-a-src-m-cheat-ml-427199099"></a>
### _cht_scramble

```ml
inline function _cht_scramble(a)
```

Applies Doom's reversible cheat-key bit permutation to one byte.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `a` | `dynamic` | — | First input operand. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/m_cheat.ml#L38)

<a id="function-function-cht-seq-get-inline-function-cht-seq-get-seq-idx-src-m-cheat-ml-1834664642"></a>
### _cht_seq_get

```ml
inline function _cht_seq_get(seq, idx)
```

Returns cht seq get information from utility state.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `seq` | `dynamic` | — | Seq value supplied to `_cht_seq_get`. |
| `idx` | `dynamic` | — | Zero-based element or table index. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/m_cheat.ml#L86)

<a id="function-function-cht-seq-len-inline-function-cht-seq-len-seq-src-m-cheat-ml-225195033"></a>
### _cht_seq_len

```ml
inline function _cht_seq_len(seq)
```

Locates the encoded terminator and returns the number of fixed cheat-sequence bytes before parameters begin.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `seq` | `dynamic` | — | Seq value supplied to `_cht_seq_len`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/m_cheat.ml#L76)

<a id="function-function-cht-seq-set-inline-function-cht-seq-set-seq-idx-v-src-m-cheat-ml-874826344"></a>
### _cht_seq_set

```ml
inline function _cht_seq_set(seq, idx, v)
```

Replaces a cheat definition's encoded byte sequence and resets its matching and parameter cursors.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `seq` | `dynamic` | — | Seq value supplied to `_cht_seq_set`. |
| `idx` | `dynamic` | — | Zero-based element or table index. |
| `v` | `dynamic` | — | Value consumed by the operation. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/m_cheat.ml#L98)

<a id="function-function-cht-write-buffer-function-cht-write-buffer-buffer-outlist-src-m-cheat-ml-104556033"></a>
### _cht_write_buffer

```ml
function _cht_write_buffer(buffer, outList)
```

Copies a captured cheat parameter into either a byte buffer or legacy string-reference array and terminates it.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `buffer` | `dynamic` | — | Buffer that supplies or receives data. |
| `outList` | `dynamic` | — | Out list value supplied to `_cht_write_buffer`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/m_cheat.ml#L161)

<a id="global-global-cheat-xlate-table-cheat-xlate-table-src-m-cheat-ml-1459302793"></a>
### cheat_xlate_table

```ml
cheat_xlate_table
```

Stores the cheat xlate table collection used by the m cheat subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/m_cheat.ml#L33)

- [cheatseq_t](Type-cheatseq-t-995176664.md) — struct
<a id="function-function-cht-checkcheat-function-cht-checkcheat-cht-key-src-m-cheat-ml-631019231"></a>
### cht_CheckCheat

```ml
function cht_CheckCheat(cht, key)
```

Feeds one key through a scrambled cheat sequence, advances or resets its cursor, and reports a completed match.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `cht` | `dynamic` | — | Cht value supplied to `cht_CheckCheat`. |
| `key` | `dynamic` | — | Input key code to process. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/m_cheat.ml#L109)

<a id="function-function-cht-getparam-function-cht-getparam-cht-buffer-src-m-cheat-ml-130818006"></a>
### cht_GetParam

```ml
function cht_GetParam(cht, buffer)
```

Returns cht Get Param information from utility state.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `cht` | `dynamic` | — | Cht value supplied to `cht_GetParam`. |
| `buffer` | `dynamic` | — | Buffer that supplies or receives data. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/m_cheat.ml#L188)

<a id="global-global-firsttime-firsttime-src-m-cheat-ml-1739934925"></a>
### firsttime

```ml
firsttime
```

Tracks the mutable firsttime value used by the m cheat subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/m_cheat.ml#L31)
