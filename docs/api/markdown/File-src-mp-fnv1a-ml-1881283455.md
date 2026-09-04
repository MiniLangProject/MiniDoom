# `src/mp_fnv1a.ml`

[Home](README.md) · [Files](Files.md)

Provides fast, non-cryptographic WAD fingerprint helpers for multiplayer compatibility checks.

Package: [`(global)`](Package-global-1952375359.md)

Reachable from entry: **yes**

## Declarations

<a id="global-global-mp-hash-hex-table-mp-hash-hex-table-src-mp-fnv1a-ml-1202815588"></a>
### _mp_hash_hex_table

```ml
_mp_hash_hex_table
```

Tracks the mutable mp hash hex table value used by the mp fnv1a subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/mp_fnv1a.ml#L23)

<a id="function-function-mp-hash-tohex8-function-mp-hash-tohex8-v-src-mp-fnv1a-ml-102400390"></a>
### _MP_HASH_ToHex8

```ml
function _MP_HASH_ToHex8(v)
```

Formats one 32-bit value as eight lowercase hexadecimal characters.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `v` | `dynamic` | — | Value consumed by the operation. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/mp_fnv1a.ml#L36)

<a id="function-function-mp-hash-u32-inline-function-mp-hash-u32-v-src-mp-fnv1a-ml-445265867"></a>
### _MP_HASH_U32

```ml
inline function _MP_HASH_U32(v)
```

Normalizes integer arithmetic to 32-bit unsigned space.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `v` | `dynamic` | — | Value consumed by the operation. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/mp_fnv1a.ml#L28)

<a id="function-function-mp-fnv1a-hex-function-mp-fnv1a-hex-data-src-mp-fnv1a-ml-701199562"></a>
### MP_FNV1A_Hex

```ml
function MP_FNV1A_Hex(data)
```

Returns `<fnv32><length32>` as 16 lowercase hex digits for deterministic IWAD compatibility checks. Security: This detects accidental content mismatches; it is not an authentication or tamper-proof hash.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `data` | `dynamic` | — | Binary or structured data to process. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/mp_fnv1a.ml#L51)
