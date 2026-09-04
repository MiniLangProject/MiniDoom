# `src/r_hires.ml`

[Home](README.md) · [Files](Files.md)

Owns the optional high-resolution world-render target.

Package: [`(global)`](Package-global-1952375359.md)

Reachable from entry: **yes**

## Imports

- `doomdef.ml` → [src/doomdef.ml](File-src-doomdef-ml-460406769.md)
- `r_renderer.ml` → [src/r_renderer.ml](File-src-r-renderer-ml-72894217.md)
- `r_upscaled.ml` → [src/r_upscaled.ml](File-src-r-upscaled-ml-1801241933.md)

## Declarations

<a id="function-function-rh-buffer-inline-function-rh-buffer-src-r-hires-ml-2056561155"></a>
### RH_Buffer

```ml
inline function RH_Buffer()
```

Returns the high-resolution target buffer.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_hires.ml#L99)

<a id="global-global-rh-buffer-rh-buffer-src-r-hires-ml-1685598862"></a>
### rh_buffer

```ml
rh_buffer
```

Holds the optional rh buffer resource used by the r hires subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_hires.ml#L33)

<a id="function-function-rh-clear-function-rh-clear-color-src-r-hires-ml-1697743521"></a>
### RH_Clear

```ml
function RH_Clear(color)
```

Clears the high-resolution world target.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `color` | `dynamic` | — | Doom palette index used for drawing. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_hires.ml#L64)

<a id="global-global-rh-enabled-rh-enabled-src-r-hires-ml-1557938866"></a>
### rh_enabled

```ml
rh_enabled
```

Tracks whether rh enabled is active in the r hires subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_hires.ml#L25)

<a id="global-global-rh-force-logical-rh-force-logical-src-r-hires-ml-814878822"></a>
### rh_force_logical

```ml
rh_force_logical
```

Tracks whether rh force logical is active in the r hires subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_hires.ml#L35)

<a id="function-function-rh-height-inline-function-rh-height-src-r-hires-ml-2077857159"></a>
### RH_Height

```ml
inline function RH_Height()
```

Returns the active world target height.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_hires.ml#L93)

<a id="global-global-rh-height-rh-height-src-r-hires-ml-117567218"></a>
### rh_height

```ml
rh_height
```

Tracks the mutable rh height value used by the r hires subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_hires.ml#L31)

<a id="function-function-rh-init-function-rh-init-src-r-hires-ml-885702466"></a>
### RH_Init

```ml
function RH_Init()
```

Initializes the high-resolution world target from RU render scale.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_hires.ml#L38)

<a id="function-function-rh-isactive-inline-function-rh-isactive-src-r-hires-ml-1064611939"></a>
### RH_IsActive

```ml
inline function RH_IsActive()
```

Returns true when world rendering should use the high-resolution target.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_hires.ml#L81)

<a id="global-global-rh-scale-rh-scale-src-r-hires-ml-576181524"></a>
### rh_scale

```ml
rh_scale
```

Tracks the mutable rh scale value used by the r hires subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_hires.ml#L27)

<a id="function-function-rh-setforcelogical-function-rh-setforcelogical-v-src-r-hires-ml-391453872"></a>
### RH_SetForceLogical

```ml
function RH_SetForceLogical(v)
```

Applies a validated override that keeps world rendering on the logical-resolution target even when HD assets are available.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `v` | `dynamic` | — | Value consumed by the operation. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_hires.ml#L73)

<a id="function-function-rh-width-inline-function-rh-width-src-r-hires-ml-1000581903"></a>
### RH_Width

```ml
inline function RH_Width()
```

Returns the active world target width.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_hires.ml#L87)

<a id="global-global-rh-width-rh-width-src-r-hires-ml-821165352"></a>
### rh_width

```ml
rh_width
```

Tracks the mutable rh width value used by the r hires subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_hires.ml#L29)
