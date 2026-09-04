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

*/

//! Owns the optional high-resolution world-render target.

import doomdef
import r_upscaled
import r_renderer

/// Tracks whether rh enabled is active in the r hires subsystem.
rh_enabled = false
/// Tracks the mutable rh scale value used by the r hires subsystem.
rh_scale = 1
/// Tracks the mutable rh width value used by the r hires subsystem.
rh_width = SCREENWIDTH
/// Tracks the mutable rh height value used by the r hires subsystem.
rh_height = SCREENHEIGHT
/// Holds the optional rh buffer resource used by the r hires subsystem.
rh_buffer = void
/// Tracks whether rh force logical is active in the r hires subsystem.
rh_force_logical = false

/// Initializes the high-resolution world target from RU render scale.
function RH_Init()
  global rh_enabled
  global rh_scale
  global rh_width
  global rh_height
  global rh_buffer

  s = 1
  if typeof(RU_RenderScale) == "function" then s = RU_RenderScale() end if
  if typeof(s) != "int" then s = 1 end if
  if s < 1 then s = 1 end if
  if s > 4 then s = 4 end if

  rh_scale = s
  rh_enabled = s > 1
  rh_width = SCREENWIDTH * s
  rh_height = SCREENHEIGHT * s
  if rh_enabled then
    rh_buffer = bytes(rh_width * rh_height, 0)
  else
    rh_buffer = void
  end if
end function

/// Clears the high-resolution world target.
/// @param color Doom palette index used for drawing.
function RH_Clear(color)
  if not rh_enabled then return end if
  if typeof(rh_buffer) != "bytes" then return end if
  fillBytes(rh_buffer, 0, len(rh_buffer), color)
end function

/// Applies a validated override that keeps world rendering on the logical-resolution target even when HD assets
/// are available.
/// @param v Value consumed by the operation.
function RH_SetForceLogical(v)
  global rh_force_logical

  rh_force_logical = false
  if typeof(v) == "bool" and v then rh_force_logical = true end if
end function

/// Returns true when world rendering should use the high-resolution target.
function inline RH_IsActive()
  if not R_RendererUsesHDAssets() then return false end if
  return (not rh_force_logical) and rh_enabled and typeof(rh_buffer) == "bytes"
end function

/// Returns the active world target width.
function inline RH_Width()
  if RH_IsActive() then return rh_width end if
  return SCREENWIDTH
end function

/// Returns the active world target height.
function inline RH_Height()
  if RH_IsActive() then return rh_height end if
  return SCREENHEIGHT
end function

/// Returns the high-resolution target buffer.
function inline RH_Buffer()
  return rh_buffer
end function
