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

//! Maintains fixed-point top, bottom, left, and right bounds for renderer and map geometry.

import m_fixed
import m_bbox

/// Defines the minimum bbox minint accepted by the m bbox subsystem.
const BBOX_MININT = -2147483648
/// Defines the maximum bbox maxint accepted by the m bbox subsystem.
const BBOX_MAXINT = 2147483647

/// Defines boxtop for the m bbox subsystem.
const BOXTOP = 0
/// Defines boxbottom for the m bbox subsystem.
const BOXBOTTOM = 1
/// Defines boxleft for the m bbox subsystem.
const BOXLEFT = 2
/// Defines boxright for the m bbox subsystem.
const BOXRIGHT = 3

/// Resets a four-entry bounding box to inverted extremes so the next point establishes every edge.
/// @param box Bounding-box array to read or update.
function M_ClearBox(box)

  if box is void then return end if
  if len(box) < 4 then return end if

  box[BOXTOP] = BBOX_MININT
  box[BOXRIGHT] = BBOX_MININT
  box[BOXBOTTOM] = BBOX_MAXINT
  box[BOXLEFT] = BBOX_MAXINT
end function

/// Expands a four-entry bounding box in place to include one fixed-point coordinate.
/// @param box Bounding-box array to read or update.
/// @param x Horizontal map- or screen-space coordinate.
/// @param y Vertical map- or screen-space coordinate.
function M_AddToBox(box, x, y)
  if box is void then return end if
  if len(box) < 4 then return end if

  if x < box[BOXLEFT] then
    box[BOXLEFT] = x
  else if x > box[BOXRIGHT] then
    box[BOXRIGHT] = x
  end if

  if y < box[BOXBOTTOM] then
    box[BOXBOTTOM] = y
  else if y > box[BOXTOP] then
    box[BOXTOP] = y
  end if
end function



