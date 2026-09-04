# `src/info.ml`

[Home](README.md) · [Files](Files.md)

Defines static gameplay tables for states, things, and weapon metadata.

Package: [`(global)`](Package-global-1952375359.md)

Reachable from entry: **yes**

## Imports

- `d_think.ml` → [src/d_think.ml](File-src-d-think-ml-737524740.md)
- `m_fixed.ml` → [src/m_fixed.ml](File-src-m-fixed-ml-2129187227.md)
- `p_mobj.ml` → [src/p_mobj.ml](File-src-p-mobj-ml-1335564114.md)
- `sounds.ml` → [src/sounds.ml](File-src-sounds-ml-1875364049.md)

## Declarations

<a id="function-function-info-stateat-function-info-stateat-s-src-info-ml-1130611297"></a>
### Info_StateAt

```ml
function Info_StateAt(s)
```

Returns the canonical state object for a valid index and safely falls back to the null state for invalid input.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `s` | `dynamic` | — | S value supplied to `Info_StateAt`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/info.ml#L6643)

<a id="function-function-info-stateindex-function-info-stateindex-s-src-info-ml-2114878573"></a>
### Info_StateIndex

```ml
function Info_StateIndex(s)
```

Resolves a state object back to its canonical index, returning the null state when the value is absent or unknown.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `s` | `dynamic` | — | S value supplied to `Info_StateIndex`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/info.ml#L3728)

<a id="global-global-mobjinfo-mobjinfo-src-info-ml-1493875818"></a>
### mobjinfo

```ml
mobjinfo
```

Stores the mobjinfo collection used by the info subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/info.ml#L3585)

- [mobjinfo_t](Type-mobjinfo-t-1442380598.md) — struct
- [mobjtype_t](Type-mobjtype-t-2039484526.md) — enum
- [spritenum_t](Type-spritenum-t-1361310167.md) — enum
<a id="global-global-sprnames-sprnames-src-info-ml-232398112"></a>
### sprnames

```ml
sprnames
```

Stores the sprnames collection used by the info subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/info.ml#L3236)

- [state_t](Type-state-t-765790189.md) — struct
- [statenum_t](Type-statenum-t-705977893.md) — enum
<a id="global-global-states-states-src-info-ml-1061551470"></a>
### states

```ml
states
```

Stores the states collection used by the info subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/info.ml#L2266)
