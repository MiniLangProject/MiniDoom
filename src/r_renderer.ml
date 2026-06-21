/*
  Copyright 2026 Nils Kopal

  Licensed under the Apache License, Version 2.0 (the "License");
  you may not use this file except in compliance with the License.
  You may obtain a copy of the License at

  http://www.apache.org/licenses/LICENSE-2.0

  Unless required by applicable law or agreed to in writing, software
  distributed under the License is distributed on an "AS IS" BASIS,
  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
  See the License for the specific language governing permissions and
  limitations under the License.

  Script: r_renderer.ml
  Purpose: Tracks the selected renderer and whether high-resolution assets may be used.
*/

const RENDERER_CLASSIC = 0
const RENDERER_OPENGL = 1

r_renderer_requested = RENDERER_CLASSIC
r_renderer_active = RENDERER_CLASSIC
r_renderer_hd_assets = false

/*
* Function: R_RendererNormalize
* Purpose: Converts unknown renderer values to a supported renderer mode.
*/
function R_RendererNormalize(mode)
  if mode == RENDERER_OPENGL then return RENDERER_OPENGL end if
  return RENDERER_CLASSIC
end function

/*
* Function: R_RendererRequest
* Purpose: Records the renderer mode requested by startup flags or hotkeys.
*/
function R_RendererRequest(mode)
  global r_renderer_requested

  r_renderer_requested = R_RendererNormalize(mode)
  return r_renderer_requested
end function

/*
* Function: R_RendererRequested
* Purpose: Returns the renderer mode requested by startup flags or hotkeys.
*/
function R_RendererRequested()
  return r_renderer_requested
end function

/*
* Function: R_RendererRequestedOpenGL
* Purpose: Returns true when the user requested the OpenGL renderer.
*/
function R_RendererRequestedOpenGL()
  return r_renderer_requested == RENDERER_OPENGL
end function

/*
* Function: R_RendererSetActive
* Purpose: Selects the renderer that will draw the next frames.
*/
function R_RendererSetActive(mode)
  global r_renderer_active
  global r_renderer_hd_assets

  r_renderer_active = R_RendererNormalize(mode)
  r_renderer_hd_assets = r_renderer_active == RENDERER_OPENGL
  return r_renderer_active
end function

/*
* Function: R_RendererActive
* Purpose: Returns the renderer that is currently drawing frames.
*/
function R_RendererActive()
  return r_renderer_active
end function

/*
* Function: R_RendererIsOpenGL
* Purpose: Returns true when OpenGL is the active renderer.
*/
function R_RendererIsOpenGL()
  return r_renderer_active == RENDERER_OPENGL
end function

/*
* Function: R_RendererUsesHDAssets
* Purpose: Returns true when high-resolution assets may be used for rendering.
*/
function R_RendererUsesHDAssets()
  return r_renderer_hd_assets
end function

/*
* Function: R_RendererSetHDAssetsEnabled
* Purpose: Overrides HD asset usage for transitional renderer setup and teardown.
*/
function R_RendererSetHDAssetsEnabled(enabled)
  global r_renderer_hd_assets

  r_renderer_hd_assets = false
  if typeof(enabled) == "bool" and enabled then r_renderer_hd_assets = true end if
  return r_renderer_hd_assets
end function

/*
* Function: R_RendererName
* Purpose: Returns a user-readable renderer name.
*/
function R_RendererName(mode)
  if R_RendererNormalize(mode) == RENDERER_OPENGL then return "OpenGL" end if
  return "classic"
end function
