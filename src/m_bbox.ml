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

  Script: m_bbox.ml
  Purpose: Provides shared math, utility, and low-level helper routines.
*/
import m_fixed
import m_bbox

const BBOX_MININT = -2147483648
const BBOX_MAXINT = 2147483647

const BOXTOP = 0
const BOXBOTTOM = 1
const BOXLEFT = 2
const BOXRIGHT = 3

/*
* Function: M_ClearBox
* Purpose: Implements the M_ClearBox routine for the utility/math layer.
*/
function M_ClearBox(box)

  if box is void then return end if
  if len(box) < 4 then return end if

  box[BOXTOP] = BBOX_MININT
  box[BOXRIGHT] = BBOX_MININT
  box[BOXBOTTOM] = BBOX_MAXINT
  box[BOXLEFT] = BBOX_MAXINT
end function

/*
* Function: M_AddToBox
* Purpose: Implements the M_AddToBox routine for the utility/math layer.
*/
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



