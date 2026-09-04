# `src/m_argv.ml`

[Home](README.md) · [Files](Files.md)

Owns the process argument vector and implements Doom-style case-insensitive option lookup.

Package: [`(global)`](Package-global-1952375359.md)

Reachable from entry: **yes**

## Declarations

<a id="function-function-m-strcaseeq-function-m-strcaseeq-a-b-src-m-argv-ml-874642975"></a>
### _M_StrCaseEq

```ml
function _M_StrCaseEq(a, b)
```

Compares two ASCII strings case-insensitively without allocating normalized copies.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `a` | `dynamic` | — | First input operand. |
| `b` | `dynamic` | — | Second input operand. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/m_argv.ml#L68)

<a id="function-function-m-tolowerascii-inline-function-m-tolowerascii-c-src-m-argv-ml-1007597400"></a>
### _M_ToLowerAscii

```ml
inline function _M_ToLowerAscii(c)
```

Folds one uppercase ASCII byte to lowercase while leaving all other bytes unchanged.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `c` | `dynamic` | — | C value supplied to `_M_ToLowerAscii`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/m_argv.ml#L59)

<a id="function-function-m-checkparm-function-m-checkparm-check-src-m-argv-ml-541263268"></a>
### M_CheckParm

```ml
function M_CheckParm(check)
```

Returns the first case-insensitive option index after argv[0], reserving zero to mean absent.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `check` | `dynamic` | — | Check value supplied to `M_CheckParm`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/m_argv.ml#L45)

<a id="function-function-m-setargv-function-m-setargv-progname-args-src-m-argv-ml-567743064"></a>
### M_SetArgv

```ml
function M_SetArgv(progName, args)
```

Rebuilds Doom's global argv with the executable name at index zero and records the resulting count.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `progName` | `dynamic` | — | Prog name value supplied to `M_SetArgv`. |
| `args` | `dynamic` | — | Args value supplied to `M_SetArgv`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/m_argv.ml#L29)

<a id="global-global-myargc-myargc-src-m-argv-ml-1262183374"></a>
### myargc

```ml
myargc
```

Tracks the mutable myargc value used by the m argv subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/m_argv.ml#L22)

<a id="global-global-myargv-myargv-src-m-argv-ml-237748728"></a>
### myargv

```ml
myargv
```

Holds the optional myargv resource used by the m argv subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/m_argv.ml#L24)
