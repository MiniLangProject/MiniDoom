# `src/m_fixed.ml`

[Home](README.md) · [Files](Files.md)

Implements Doom's signed 16.16 fixed-point multiply and divide with explicit 32-bit wrap, saturation, and zero handling.

Package: [`(global)`](Package-global-1952375359.md)

Reachable from entry: **yes**

## Imports

- `doomtype.ml` → [src/doomtype.ml](File-src-doomtype-ml-372549946.md)
- `i_system.ml` → [src/i_system.ml](File-src-i-system-ml-1632920966.md)
- `std/math.ml` → `../MiniLangCompilerOptimization/MiniLangCompilerPy/std/math.ml` — external dependency
- `stdlib.ml` → [src/stdlib.ml](File-src-stdlib-ml-366721133.md)

## Declarations

<a id="function-function-abss32-inline-function-abss32-x-src-m-fixed-ml-1465749931"></a>
### _absS32

```ml
inline function _absS32(x)
```

Returns a signed 32-bit magnitude while saturating the unrepresentable INT32_MIN case.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `x` | `dynamic` | — | Horizontal map- or screen-space coordinate. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/m_fixed.ml#L98)

<a id="function-function-idivs32-inline-function-idivs32-a-b-src-m-fixed-ml-633276288"></a>
### _idivS32

```ml
inline function _idivS32(a, b)
```

Returns a signed integer quotient truncated toward zero, or zero for invalid operands and a zero divisor.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `a` | `dynamic` | — | First input operand. |
| `b` | `dynamic` | — | Second input operand. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/m_fixed.ml#L108)

<a id="function-function-s32-function-s32-x-src-m-fixed-ml-2061379470"></a>
### _s32

```ml
function _s32(x)
```

Reinterprets the low 32 bits of an integer as a signed two's-complement value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `x` | `dynamic` | — | Horizontal map- or screen-space coordinate. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/m_fixed.ml#L64)

<a id="constant-constant-s32-max-const-s32-max-2147483647-src-m-fixed-ml-606607091"></a>
### _S32_MAX

```ml
const _S32_MAX = 2147483647
```

Defines the maximum s32 max accepted by the m fixed subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/m_fixed.ml#L37)

<a id="constant-constant-s32-min-const-s32-min-2147483648-src-m-fixed-ml-1861532719"></a>
### _S32_MIN

```ml
const _S32_MIN = -2147483648
```

Defines the minimum s32 min accepted by the m fixed subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/m_fixed.ml#L34)

<a id="function-function-u32-inline-function-u32-x-src-m-fixed-ml-1570500655"></a>
### _u32

```ml
inline function _u32(x)
```

Normalizes an integer to its unsigned 32-bit representation.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `x` | `dynamic` | — | Horizontal map- or screen-space coordinate. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/m_fixed.ml#L42)

<a id="function-function-fixeddiv-function-fixeddiv-a-b-src-m-fixed-ml-868742543"></a>
### FixedDiv

```ml
function FixedDiv(a, b)
```

Divides two signed 16.16 values, saturating results whose shifted numerator would overflow signed 32-bit range.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `a` | `dynamic` | — | First input operand. |
| `b` | `dynamic` | — | Second input operand. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/m_fixed.ml#L130)

<a id="function-function-fixeddiv2-inline-function-fixeddiv2-a-b-src-m-fixed-ml-1761712588"></a>
### FixedDiv2

```ml
inline function FixedDiv2(a, b)
```

Scales a signed numerator by FRACUNIT, divides with truncation toward zero, and reports a zero divisor through I_Error.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `a` | `dynamic` | — | First input operand. |
| `b` | `dynamic` | — | Second input operand. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/m_fixed.ml#L148)

<a id="function-function-fixedmul-inline-function-fixedmul-a-b-src-m-fixed-ml-1785882466"></a>
### FixedMul

```ml
inline function FixedMul(a, b)
```

Multiplies two 16.16 fixed-point operands with a 64-bit intermediate and returns a signed 32-bit fixed-point result.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `a` | `dynamic` | — | First input operand. |
| `b` | `dynamic` | — | Second input operand. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/m_fixed.ml#L119)

<a id="constant-constant-fracbits-const-fracbits-16-src-m-fixed-ml-1149457286"></a>
### FRACBITS

```ml
const FRACBITS = 16
```

Defines fracbits for the m fixed subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/m_fixed.ml#L28)

<a id="constant-constant-fracunit-const-fracunit-1-fracbits-src-m-fixed-ml-582918220"></a>
### FRACUNIT

```ml
const FRACUNIT = 1 << FRACBITS
```

Defines fracunit for the m fixed subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/m_fixed.ml#L30)
