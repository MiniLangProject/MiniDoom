# `src/m_random.ml`

[Home](README.md) · [Files](Files.md)

Supplies Doom's deterministic gameplay and miscellaneous pseudo-random byte streams.

Package: [`(global)`](Package-global-1952375359.md)

Reachable from entry: **yes**

## Imports

- `doomtype.ml` → [src/doomtype.ml](File-src-doomtype-ml-372549946.md)

## Declarations

<a id="function-function-m-clearrandom-function-m-clearrandom-src-m-random-ml-880149801"></a>
### M_ClearRandom

```ml
function M_ClearRandom()
```

Resets both Doom random-table cursors so demos and gameplay restart from the canonical deterministic sequence.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/m_random.ml#L69)

<a id="function-function-m-random-function-m-random-src-m-random-ml-1216352121"></a>
### M_Random

```ml
function M_Random()
```

Advances the independent miscellaneous random-table stream so UI effects cannot perturb gameplay determinism.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/m_random.ml#L60)

<a id="function-function-p-random-function-p-random-src-m-random-ml-328211585"></a>
### P_Random

```ml
function P_Random()
```

Advances and returns the deterministic gameplay random-table stream used by demo-synchronized simulation.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/m_random.ml#L51)

<a id="global-global-prndindex-prndindex-src-m-random-ml-1079333155"></a>
### prndindex

```ml
prndindex
```

Tracks the mutable prndindex value used by the m random subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/m_random.ml#L48)

<a id="global-global-rndindex-rndindex-src-m-random-ml-559518703"></a>
### rndindex

```ml
rndindex
```

Tracks the mutable rndindex value used by the m random subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/m_random.ml#L46)

<a id="global-global-rndtable-rndtable-src-m-random-ml-2107426871"></a>
### rndtable

```ml
rndtable
```

Stores the rndtable collection used by the m random subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/m_random.ml#L23)
