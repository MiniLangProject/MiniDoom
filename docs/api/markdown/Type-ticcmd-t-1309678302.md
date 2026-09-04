# `ticcmd_t`

[Home](README.md) · [Source file](File-src-d-ticcmd-ml-1143326682.md)

<a id="struct-struct-ticcmd-t-struct-ticcmd-t-src-d-ticcmd-ml-1380220524"></a>
## ticcmd_t

```ml
struct ticcmd_t
```

Stores movement, view, consistency, chat, and button state for exactly one simulation tic. Invariant: All six fields are serialized as signed 32-bit values by i_net and must remain in this wire order.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/d_ticcmd.ml#L24)

## Members

<a id="field-field-ticcmd-t-angleturn-angleturn-src-d-ticcmd-ml-1439992903"></a>
### angleturn

```ml
angleturn
```

Signed view-angle delta.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/d_ticcmd.ml#L30)

<a id="field-field-ticcmd-t-buttons-buttons-src-d-ticcmd-ml-2056327171"></a>
### buttons

```ml
buttons
```

Bit field of attack/use/weapon actions.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/d_ticcmd.ml#L36)

<a id="field-field-ticcmd-t-chatchar-chatchar-src-d-ticcmd-ml-2126077015"></a>
### chatchar

```ml
chatchar
```

One queued chat character, or zero.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/d_ticcmd.ml#L34)

<a id="field-field-ticcmd-t-consistancy-consistancy-src-d-ticcmd-ml-130689747"></a>
### consistancy

```ml
consistancy
```

Determinism check value for the originating tic.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/d_ticcmd.ml#L32)

<a id="field-field-ticcmd-t-forwardmove-forwardmove-src-d-ticcmd-ml-452244819"></a>
### forwardmove

```ml
forwardmove
```

Signed forward/back movement impulse.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/d_ticcmd.ml#L26)

<a id="field-field-ticcmd-t-sidemove-sidemove-src-d-ticcmd-ml-405570063"></a>
### sidemove

```ml
sidemove
```

Signed strafe movement impulse.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/d_ticcmd.ml#L28)
