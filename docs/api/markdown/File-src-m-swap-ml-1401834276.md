# `src/m_swap.ml`

[Home](README.md) · [Files](Files.md)

Normalizes signed 16-bit values and byte-swaps 16- and 32-bit integers across host endianness.

Package: [`(global)`](Package-global-1952375359.md)

Reachable from entry: **yes**

## Declarations

<a id="constant-constant-big-endian-const-big-endian-false-src-m-swap-ml-111253457"></a>
### __BIG_ENDIAN__

```ml
const __BIG_ENDIAN__ = false
```

Defines big endian for the m swap subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/m_swap.ml#L23)

<a id="function-function-long-function-long-x-src-m-swap-ml-300045343"></a>
### LONG

```ml
function LONG(x)
```

Reverses all four bytes of a 32-bit value and returns the signed result.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `x` | `dynamic` | — | Horizontal map- or screen-space coordinate. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/m_swap.ml#L51)

<a id="function-function-short-function-short-x-src-m-swap-ml-1513256323"></a>
### SHORT

```ml
function SHORT(x)
```

Byte-swaps the low 16 bits and returns the result with signed 16-bit interpretation.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `x` | `dynamic` | — | Horizontal map- or screen-space coordinate. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/m_swap.ml#L44)

<a id="function-function-swaplong-function-swaplong-x-src-m-swap-ml-913315623"></a>
### SwapLONG

```ml
function SwapLONG(x)
```

Reverses all four bytes of an integer's low 32-bit representation.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `x` | `dynamic` | — | Horizontal map- or screen-space coordinate. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/m_swap.ml#L34)

<a id="function-function-swapshort-function-swapshort-x-src-m-swap-ml-598909929"></a>
### SwapSHORT

```ml
function SwapSHORT(x)
```

Reverses the two bytes in the low 16 bits of an integer.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `x` | `dynamic` | — | Horizontal map- or screen-space coordinate. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/m_swap.ml#L27)
