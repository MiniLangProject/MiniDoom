# `src/d_event.ml`

[Home](README.md) · [Files](Files.md)

Defines normalized input events, queued game actions, and button-bit constants shared by responders and the game loop.

Package: [`(global)`](Package-global-1952375359.md)

Reachable from entry: **yes**

## Imports

- `doomtype.ml` → [src/doomtype.ml](File-src-doomtype-ml-372549946.md)

## Declarations

- [buttoncode_t](Type-buttoncode-t-273054467.md) — enum
- [event_t](Type-event-t-453053404.md) — struct
- [evtype_t](Type-evtype-t-1813278105.md) — enum
- [gameaction_t](Type-gameaction-t-333514326.md) — enum
<a id="constant-constant-maxevents-const-maxevents-64-src-d-event-ml-260931412"></a>
### MAXEVENTS

```ml
const MAXEVENTS = 64
```

Defines the maximum maxevents accepted by the d event subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/d_event.ml#L104)
