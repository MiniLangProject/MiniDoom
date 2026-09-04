# `thinker_t`

[Home](README.md) · [Source file](File-src-d-think-ml-737524740.md)

<a id="struct-struct-thinker-t-struct-thinker-t-src-d-think-ml-957258016"></a>
## thinker_t

```ml
struct thinker_t
```

Forms one node of the doubly linked thinker list and associates it with a callback and optional owning object.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/d_think.ml#L33)

## Members

<a id="field-field-thinker-t-func-func-src-d-think-ml-1617710420"></a>
### func

```ml
func
```

Stores func for `thinker_t`


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/d_think.ml#L39)

<a id="field-field-thinker-t-next-next-src-d-think-ml-495552530"></a>
### next

```ml
next
```

Next linked record in traversal order stored by `thinker_t`


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/d_think.ml#L37)

<a id="field-field-thinker-t-owner-owner-src-d-think-ml-1888395508"></a>
### owner

```ml
owner
```

Stores owner for `thinker_t`


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/d_think.ml#L41)

<a id="field-field-thinker-t-prev-prev-src-d-think-ml-1599794218"></a>
### prev

```ml
prev
```

Previous linked record in traversal order stored by `thinker_t`


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/d_think.ml#L35)
