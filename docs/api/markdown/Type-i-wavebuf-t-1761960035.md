# `_I_wavebuf_t`

[Home](README.md) · [Source file](File-src-i-sound-ml-33806980.md)

<a id="struct-struct-i-wavebuf-t-struct-i-wavebuf-t-src-i-sound-ml-294997018"></a>
## _I_wavebuf_t

```ml
struct _I_wavebuf_t
```

Owns one unmanaged PCM data block and WAVEHDR plus its in-flight submission flag.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_sound.ml#L179)

## Members

<a id="field-field-i-wavebuf-t-dataptr-dataptr-src-i-sound-ml-300671788"></a>
### dataPtr

```ml
dataPtr
```

Stores data ptr for `_I_wavebuf_t`


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_sound.ml#L181)

<a id="field-field-i-wavebuf-t-hdrptr-hdrptr-src-i-sound-ml-1159100188"></a>
### hdrPtr

```ml
hdrPtr
```

Stores hdr ptr for `_I_wavebuf_t`


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_sound.ml#L183)

<a id="field-field-i-wavebuf-t-submitted-submitted-src-i-sound-ml-37897644"></a>
### submitted

```ml
submitted
```

Stores submitted for `_I_wavebuf_t`


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_sound.ml#L185)
