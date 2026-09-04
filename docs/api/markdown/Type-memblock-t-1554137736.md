# `memblock_t`

[Home](README.md) · [Source file](File-src-z-zone-ml-1788911354.md)

<a id="struct-struct-memblock-t-struct-memblock-t-src-z-zone-ml-1704581284"></a>
## memblock_t

```ml
struct memblock_t
```

Describes one contiguous zone range with owner reference, purge tag, integrity marker, and indices in the address-ordered block list.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/z_zone.ml#L43)

## Members

<a id="field-field-memblock-t-id-id-src-z-zone-ml-2128230679"></a>
### id

```ml
id
```

Stores id for `memblock_t`


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/z_zone.ml#L53)

<a id="field-field-memblock-t-next-next-src-z-zone-ml-1659219683"></a>
### next

```ml
next
```

Next linked record in traversal order stored by `memblock_t`


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/z_zone.ml#L55)

<a id="field-field-memblock-t-prev-prev-src-z-zone-ml-855356359"></a>
### prev

```ml
prev
```

Previous linked record in traversal order stored by `memblock_t`


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/z_zone.ml#L57)

<a id="field-field-memblock-t-size-size-src-z-zone-ml-505046903"></a>
### size

```ml
size
```

Stores size for `memblock_t`


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/z_zone.ml#L47)

<a id="field-field-memblock-t-start-start-src-z-zone-ml-696841805"></a>
### start

```ml
start
```

Stores start for `memblock_t`


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/z_zone.ml#L45)

<a id="field-field-memblock-t-tag-tag-src-z-zone-ml-1020203889"></a>
### tag

```ml
tag
```

Stores tag for `memblock_t`


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/z_zone.ml#L51)

<a id="field-field-memblock-t-user-user-src-z-zone-ml-1108046575"></a>
### user

```ml
user
```

Stores user for `memblock_t`


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/z_zone.ml#L49)
