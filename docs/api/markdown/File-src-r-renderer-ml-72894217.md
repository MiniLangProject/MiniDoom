# `src/r_renderer.ml`

[Home](README.md) · [Files](Files.md)

Tracks the selected renderer and whether high-resolution assets may be used.

Package: [`(global)`](Package-global-1952375359.md)

Reachable from entry: **yes**

## Declarations

<a id="global-global-r-renderer-active-r-renderer-active-src-r-renderer-ml-206469910"></a>
### r_renderer_active

```ml
r_renderer_active
```

Tracks the mutable r renderer active value used by the r renderer subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_renderer.ml#L29)

<a id="global-global-r-renderer-hd-assets-r-renderer-hd-assets-src-r-renderer-ml-1523124496"></a>
### r_renderer_hd_assets

```ml
r_renderer_hd_assets
```

Tracks whether r renderer hd assets is active in the r renderer subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_renderer.ml#L31)

<a id="global-global-r-renderer-requested-r-renderer-requested-src-r-renderer-ml-1403660264"></a>
### r_renderer_requested

```ml
r_renderer_requested
```

Tracks the mutable r renderer requested value used by the r renderer subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_renderer.ml#L27)

<a id="function-function-r-rendereractive-function-r-rendereractive-src-r-renderer-ml-1627223828"></a>
### R_RendererActive

```ml
function R_RendererActive()
```

Returns the renderer that is currently drawing frames.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_renderer.ml#L71)

<a id="function-function-r-rendererisopengl-function-r-rendererisopengl-src-r-renderer-ml-611886164"></a>
### R_RendererIsOpenGL

```ml
function R_RendererIsOpenGL()
```

Returns true when OpenGL is the active renderer.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_renderer.ml#L76)

<a id="function-function-r-renderername-function-r-renderername-mode-src-r-renderer-ml-594316909"></a>
### R_RendererName

```ml
function R_RendererName(mode)
```

Returns a user-readable renderer name.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `mode` | `dynamic` | — | Mode value supplied to `R_RendererName`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_renderer.ml#L97)

<a id="function-function-r-renderernormalize-function-r-renderernormalize-mode-src-r-renderer-ml-1842468971"></a>
### R_RendererNormalize

```ml
function R_RendererNormalize(mode)
```

Converts unknown renderer values to a supported renderer mode.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `mode` | `dynamic` | — | Mode value supplied to `R_RendererNormalize`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_renderer.ml#L35)

<a id="function-function-r-rendererrequest-function-r-rendererrequest-mode-src-r-renderer-ml-812270171"></a>
### R_RendererRequest

```ml
function R_RendererRequest(mode)
```

Records the renderer mode requested by startup flags or hotkeys.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `mode` | `dynamic` | — | Mode value supplied to `R_RendererRequest`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_renderer.ml#L42)

<a id="function-function-r-rendererrequested-function-r-rendererrequested-src-r-renderer-ml-1003406996"></a>
### R_RendererRequested

```ml
function R_RendererRequested()
```

Returns the renderer mode requested by startup flags or hotkeys.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_renderer.ml#L50)

<a id="function-function-r-rendererrequestedopengl-function-r-rendererrequestedopengl-src-r-renderer-ml-249912758"></a>
### R_RendererRequestedOpenGL

```ml
function R_RendererRequestedOpenGL()
```

Returns true when the user requested the OpenGL renderer.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_renderer.ml#L55)

<a id="function-function-r-renderersetactive-function-r-renderersetactive-mode-src-r-renderer-ml-1923231373"></a>
### R_RendererSetActive

```ml
function R_RendererSetActive(mode)
```

Selects the renderer that will draw the next frames.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `mode` | `dynamic` | — | Mode value supplied to `R_RendererSetActive`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_renderer.ml#L61)

<a id="function-function-r-renderersethdassetsenabled-function-r-renderersethdassetsenabled-enabled-src-r-renderer-ml-884527413"></a>
### R_RendererSetHDAssetsEnabled

```ml
function R_RendererSetHDAssetsEnabled(enabled)
```

Overrides HD asset usage for transitional renderer setup and teardown.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `enabled` | `dynamic` | — | Whether the requested feature should be enabled. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_renderer.ml#L87)

<a id="function-function-r-rendereruseshdassets-function-r-rendereruseshdassets-src-r-renderer-ml-28442820"></a>
### R_RendererUsesHDAssets

```ml
function R_RendererUsesHDAssets()
```

Returns true when high-resolution assets may be used for rendering.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_renderer.ml#L81)

<a id="constant-constant-renderer-classic-const-renderer-classic-0-src-r-renderer-ml-1721472119"></a>
### RENDERER_CLASSIC

```ml
const RENDERER_CLASSIC = 0
```

Defines renderer classic for the r renderer subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_renderer.ml#L22)

<a id="constant-constant-renderer-opengl-const-renderer-opengl-1-src-r-renderer-ml-1332727982"></a>
### RENDERER_OPENGL

```ml
const RENDERER_OPENGL = 1
```

Defines renderer opengl for the r renderer subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/r_renderer.ml#L24)
