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

  Script: hu_lib.ml
  Purpose: Implements HUD scrolling text, editable input lines, font drawing, and dirty-region erasure for classic view borders.
*/
import r_defs
import doomdef
import v_video
import m_swap
import r_local
import r_draw

const HU_CHARERASE = 127
const HU_MAXLINES = 4
const HU_MAXLINELENGTH = 80

/*
* Struct: hu_textline_t
* Purpose: Describes textline geometry or asset data used by the heads-up display system.
*/
struct hu_textline_t
  x
  y
  f
  sc
  l
  len
  needsupdate
end struct

/*
* Struct: hu_stext_t
* Purpose: Implements a circular stack of HUD text lines with height, current-line index, and externally referenced visibility state.
*/
struct hu_stext_t
  l
  h
  cl
  on
  laston
end struct

/*
* Struct: hu_itext_t
* Purpose: Holds one editable HUD input line, its immutable prefix boundary, and externally referenced visibility state.
*/
struct hu_itext_t
  l
  lm
  on
  laston
end struct

/*
* Function: HUlib_init
* Purpose: Preserves the original HUD-library initialization hook; this implementation has no module-wide resources to allocate.
*/
function HUlib_init()

end function

/*
* Function: _HUlib_toByte
* Purpose: Normalizes an integer or one-character string to the byte value stored in HUD text buffers.
*/
function inline _HUlib_toByte(ch)
  if typeof(ch) == "int" then
    return ch & 255
  end if
  if typeof(ch) == "string" then
    b = bytes(ch)
    if len(b) > 0 then return b[0] end if
  end if
  return 0
end function

/*
* Function: _HUlib_refBool
* Purpose: Resolves direct or single-element referenced values to the truth value used by HUD visibility toggles.
*/
function inline _HUlib_refBool(v)
  if typeof(v) == "array" and len(v) > 0 then v = v[0] end if
  if typeof(v) == "bool" then return v end if
  if typeof(v) == "int" or typeof(v) == "float" then return v != 0 end if
  return v is not void
end function

/*
* Function: _HUlib_patchWidth
* Purpose: Reads a validated font patch's signed little-endian width, returning zero for absent data.
*/
function inline _HUlib_patchWidth(p)
  if typeof(p) != "bytes" then return 0 end if
  return RDefs_I16LE(p, 0)
end function

/*
* Function: _HUlib_patchHeight
* Purpose: Reads a validated font patch's signed little-endian height, returning zero for absent data.
*/
function inline _HUlib_patchHeight(p)
  if typeof(p) != "bytes" then return 0 end if
  return RDefs_I16LE(p, 2)
end function

/*
* Function: _HUlib_patchAt
* Purpose: Safely retrieves one glyph patch from a font array without exposing out-of-range indexing.
*/
function inline _HUlib_patchAt(font, idx)
  if typeof(font) != "array" then return void end if
  if idx < 0 or idx >= len(font) then return void end if
  return font[idx]
end function

/*
* Function: _HUlib_upper
* Purpose: Converts lowercase ASCII glyph codes to the uppercase range used by Doom's HUD font.
*/
function inline _HUlib_upper(c)
  if c >= 97 and c <= 122 then return c - 32 end if
  return c
end function

/*
* Function: _HUlib_needsVal
* Purpose: Normalizes numeric or boolean dirty-line state to the integer redraw count consumed by erase logic.
*/
function inline _HUlib_needsVal(v)
  if typeof(v) == "int" or typeof(v) == "float" then return v end if
  if typeof(v) == "bool" then
    if v then return 1 end if
    return 0
  end if
  return 0
end function

/*
* Function: HUlib_clearTextLine
* Purpose: Clears hUlib clear Text Line state before the next heads-up display update.
*/
function HUlib_clearTextLine(t)
  if t == 0 then return end if
  if t.l == 0 or typeof(t.l) != "bytes" then
    t.l = bytes(HU_MAXLINELENGTH + 1, 0)
  else
    for i = 0 to HU_MAXLINELENGTH
      t.l[i] = 0
    end for
  end if
  t.len = 0
  t.needsupdate = 1
end function

/*
* Function: HUlib_initTextLine
* Purpose: Assigns position and font metadata, allocates a bounded text buffer, and marks a HUD line dirty.
*/
function HUlib_initTextLine(t, x, y, f, sc)
  if t == 0 then return end if
  t.x = x
  t.y = y
  t.f = f
  t.sc = sc
  t.l = bytes(HU_MAXLINELENGTH + 1, 0)
  t.len = 0
  t.needsupdate = 1
end function

/*
* Function: HUlib_addCharToTextLine
* Purpose: Appends one normalized byte when capacity permits, maintains the zero terminator, and schedules four redraws.
*/
function HUlib_addCharToTextLine(t, ch)
  if t == 0 then return false end if
  if t.len >= HU_MAXLINELENGTH then return false end if
  c = _HUlib_toByte(ch)
  t.l[t.len] = c
  t.len = t.len + 1
  t.l[t.len] = 0
  t.needsupdate = 4
  return true
end function

/*
* Function: HUlib_delCharFromTextLine
* Purpose: Removes the final byte from a nonempty HUD line, restores termination, and schedules redraws.
*/
function HUlib_delCharFromTextLine(t)
  if t == 0 then return false end if
  if t.len <= 0 then return false end if
  t.len = t.len - 1
  t.l[t.len] = 0
  t.needsupdate = 4
  return true
end function

/*
* Function: HUlib_drawTextLine
* Purpose: Renders a HUD text buffer with patch-font glyph widths, optional cursor, spaces, and right-edge clipping.
*/
function HUlib_drawTextLine(l, drawcursor)
  if l == 0 then return end if

  x = l.x
  i = 0
  while i < l.len
    c = _HUlib_upper(l.l[i])
    if c != 32 and c >= l.sc and c <= 95 then
      p = _HUlib_patchAt(l.f, c - l.sc)
      w = _HUlib_patchWidth(p)
      if x + w > SCREENWIDTH then break end if
      if p is not void then
        V_DrawPatchDirect(x, l.y, 0, p)
      end if
      x = x + w
    else
      x = x + 4
      if x >= SCREENWIDTH then break end if
    end if
    i = i + 1
  end while

  if drawcursor then
    cp = _HUlib_patchAt(l.f, 95 - l.sc)
    if cp is not void and x + _HUlib_patchWidth(cp) <= SCREENWIDTH then
      V_DrawPatchDirect(x, l.y, 0, cp)
    end if
  end if
end function

/*
* Function: HUlib_eraseTextLine
* Purpose: Restores border regions covered by a dirty HUD line and decrements its multi-frame redraw counter.
*/
function HUlib_eraseTextLine(l)
  if l == 0 then return end if

  needs = _HUlib_needsVal(l.needsupdate)
  if (not automapactive) and viewwindowx != 0 and needs > 0 then
    p0 = _HUlib_patchAt(l.f, 0)
    lh = _HUlib_patchHeight(p0) + 1
    y = l.y
    while y < l.y + lh
      yofs = y * SCREENWIDTH
      if y < viewwindowy or y >= viewwindowy + viewheight then
        R_VideoErase(yofs, SCREENWIDTH)
      else
        R_VideoErase(yofs, viewwindowx)
        R_VideoErase(yofs + viewwindowx + viewwidth, viewwindowx)
      end if
      y = y + 1
    end while
  end if

  if needs > 0 then
    l.needsupdate = needs - 1
  else
    l.needsupdate = 0
  end if
end function

/*
* Function: HUlib_initSText
* Purpose: Builds a fixed-height circular message stack whose lines are vertically spaced from the font height.
*/
function HUlib_initSText(s, x, y, h, font, startchar, on)
  if s == 0 then return end if
  s.h = h
  s.cl = 0
  s.on = on
  s.laston = true
  s.l =[]

  hstep = _HUlib_patchHeight(_HUlib_patchAt(font, 0)) + 1
  if hstep <= 0 then hstep = 8 end if

  i = 0
  while i < h
    tl = hu_textline_t(0, 0, 0, 0, 0, 0, 0)
    HUlib_initTextLine(tl, x, y - i * hstep, font, startchar)
    s.l = s.l +[tl]
    i = i + 1
  end while
end function

/*
* Function: HUlib_addLineToSText
* Purpose: Advances the circular message cursor, clears the reused line, and marks every visible stack line dirty.
*/
function HUlib_addLineToSText(s)
  if s == 0 then return end if
  s.cl = s.cl + 1
  if s.cl == s.h then s.cl = 0 end if
  HUlib_clearTextLine(s.l[s.cl])

  i = 0
  while i < s.h
    s.l[i].needsupdate = 4
    i = i + 1
  end while
end function

/*
* Function: _HUlib_appendBytes
* Purpose: Appends an entire byte sequence through the text-line capacity and dirty-state rules.
*/
function _HUlib_appendBytes(tl, b)
  if tl == 0 or b == 0 then return end if
  for i = 0 to len(b) - 1
    HUlib_addCharToTextLine(tl, b[i])
  end for
end function

/*
* Function: HUlib_addMessageToSText
* Purpose: Opens a new stack line and concatenates an optional prefix with the message text.
*/
function HUlib_addMessageToSText(s, prefix, msg)
  if s == 0 then return end if
  HUlib_addLineToSText(s)
  tl = s.l[s.cl]
  if prefix != 0 then _HUlib_appendBytes(tl, bytes(prefix)) end if
  if msg != 0 then _HUlib_appendBytes(tl, bytes(msg)) end if
end function

/*
* Function: HUlib_drawSText
* Purpose: Draws visible stack lines newest-first by walking backward through the circular buffer.
*/
function HUlib_drawSText(s)
  if s == 0 then return end if
  if not _HUlib_refBool(s.on) then return end if

  i = 0
  while i < s.h
    idx = s.cl - i
    if idx < 0 then idx = idx + s.h end if
    HUlib_drawTextLine(s.l[idx], false)
    i = i + 1
  end while
end function

/*
* Function: HUlib_eraseSText
* Purpose: Marks lines dirty on visibility transitions, erases every stack line, and remembers the current visibility state.
*/
function HUlib_eraseSText(s)
  if s == 0 then return end if

  i = 0
  while i < s.h
    if s.laston and(not _HUlib_refBool(s.on)) then
      s.l[i].needsupdate = 4
    end if
    HUlib_eraseTextLine(s.l[i])
    i = i + 1
  end while

  s.laston = _HUlib_refBool(s.on)
end function

/*
* Function: HUlib_initIText
* Purpose: Creates an editable HUD line, clears its protected-prefix boundary, and attaches its visibility reference.
*/
function HUlib_initIText(it, x, y, font, startchar, on)
  if it == 0 then return end if
  it.l = hu_textline_t(0, 0, 0, 0, 0, 0, 0)
  HUlib_initTextLine(it.l, x, y, font, startchar)
  it.lm = 0
  it.on = on
  it.laston = true
end function

/*
* Function: HUlib_delCharFromIText
* Purpose: Deletes one input byte only when it lies after the protected prefix boundary.
*/
function HUlib_delCharFromIText(it)
  if it == 0 then return false end if
  if it.l.len <= it.lm then return false end if
  return HUlib_delCharFromTextLine(it.l)
end function

/*
* Function: HUlib_eraseLineFromIText
* Purpose: Removes all editable input while retaining the protected prefix bytes.
*/
function HUlib_eraseLineFromIText(it)
  if it == 0 then return end if
  while it.l.len > it.lm
    HUlib_delCharFromTextLine(it.l)
  end while
end function

/*
* Function: HUlib_resetIText
* Purpose: Clears hUlib reset IText state before the next heads-up display update.
*/
function HUlib_resetIText(it)
  if it == 0 then return end if
  it.lm = 0
  HUlib_clearTextLine(it.l)
end function

/*
* Function: HUlib_addPrefixToIText
* Purpose: Appends a fixed prompt prefix and advances the deletion boundary to protect it from backspace.
*/
function HUlib_addPrefixToIText(it, str)
  if it == 0 then return end if
  if str == 0 then return end if
  _HUlib_appendBytes(it.l, bytes(str))
  it.lm = it.l.len
end function

/*
* Function: HUlib_keyInIText
* Purpose: Applies printable, backspace, or enter input to an editable HUD line and reports whether the key was consumed.
*/
function HUlib_keyInIText(it, ch)
  if it == 0 then return false end if
  c = _HUlib_toByte(ch)

  if c >= 32 and c <= 95 then
    HUlib_addCharToTextLine(it.l, c)
  else if c == KEY_BACKSPACE then
    HUlib_delCharFromIText(it)
  else if c != KEY_ENTER then
    return false
  end if

  return true
end function

/*
* Function: HUlib_drawIText
* Purpose: Draws a visible editable line with the cursor glyph placed after its current text.
*/
function HUlib_drawIText(it)
  if it == 0 then return end if
  if not _HUlib_refBool(it.on) then return end if
  HUlib_drawTextLine(it.l, true)
end function

/*
* Function: HUlib_eraseIText
* Purpose: Erases a dirty input line, forcing redraws when its externally controlled visibility turns off.
*/
function HUlib_eraseIText(it)
  if it == 0 then return end if
  if it.laston and(not _HUlib_refBool(it.on)) then
    it.l.needsupdate = 4
  end if
  HUlib_eraseTextLine(it.l)
  it.laston = _HUlib_refBool(it.on)
end function



