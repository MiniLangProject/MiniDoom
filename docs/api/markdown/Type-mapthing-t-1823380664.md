# `mapthing_t`

[Home](README.md) · [Source file](File-src-doomdata-ml-887192154.md)

<a id="struct-struct-mapthing-t-struct-mapthing-t-src-doomdata-ml-1078700784"></a>
## mapthing_t

```ml
struct mapthing_t
```

Mirrors one THINGS lump record: map position, facing angle, type number, and spawn-option flags.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/doomdata.ml#L168)

## Members

<a id="field-field-mapthing-t-angle-angle-src-doomdata-ml-316573333"></a>
### angle

```ml
angle
```

Doom binary-angle orientation stored by `mapthing_t`


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/doomdata.ml#L174)

<a id="field-field-mapthing-t-options-options-src-doomdata-ml-600542989"></a>
### options

```ml
options
```

Stores options for `mapthing_t`


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/doomdata.ml#L178)

<a id="field-field-mapthing-t-type-type-src-doomdata-ml-640707217"></a>
### type

```ml
type
```

Kind discriminator for this record stored by `mapthing_t`


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/doomdata.ml#L176)

<a id="field-field-mapthing-t-x-x-src-doomdata-ml-2088572261"></a>
### x

```ml
x
```

Horizontal map- or screen-space coordinate stored by `mapthing_t`


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/doomdata.ml#L170)

<a id="field-field-mapthing-t-y-y-src-doomdata-ml-1143647529"></a>
### y

```ml
y
```

Vertical map- or screen-space coordinate stored by `mapthing_t`


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/doomdata.ml#L172)
