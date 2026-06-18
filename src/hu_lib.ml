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
  Purpose: Implements in-game HUD text and messaging behaviors.
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
* Purpose: Stores stext data used by the heads-up display system.
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
* Purpose: Stores itext data used by the heads-up display system.
*/
struct hu_itext_t
  l
  lm
  on
  laston
end struct

/*
* Function: HUlib_init
* Purpose: Initializes state and dependencies for the engine module behavior.
*/
function HUlib_init()

end function

/*
* Function: _HUlib_toByte
* Purpose: Provides ulib to byte helper behavior for the heads-up display.
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
* Purpose: Provides ulib ref boolean helper behavior for the heads-up display.
*/
function inline _HUlib_refBool(v)
  if typeof(v) == "array" and len(v) > 0 then v = v[0] end if
  if typeof(v) == "bool" then return v end if
  if typeof(v) == "int" or typeof(v) == "float" then return v != 0 end if
  return v is not void
end function

/*
* Function: _HUlib_patchWidth
* Purpose: Provides ulib patch width helper behavior for the heads-up display.
*/
function inline _HUlib_patchWidth(p)
  if typeof(p) != "bytes" then return 0 end if
  return RDefs_I16LE(p, 0)
end function

/*
* Function: _HUlib_patchHeight
* Purpose: Provides ulib patch height helper behavior for the heads-up display.
*/
function inline _HUlib_patchHeight(p)
  if typeof(p) != "bytes" then return 0 end if
  return RDefs_I16LE(p, 2)
end function

/*
* Function: _HUlib_patchAt
* Purpose: Provides ulib patch at helper behavior for the heads-up display.
*/
function inline _HUlib_patchAt(font, idx)
  if typeof(font) != "array" then return void end if
  if idx < 0 or idx >= len(font) then return void end if
  return font[idx]
end function

/*
* Function: _HUlib_upper
* Purpose: Provides ulib upper helper behavior for the heads-up display.
*/
function inline _HUlib_upper(c)
  if c >= 97 and c <= 122 then return c - 32 end if
  return c
end function

/*
* Function: _HUlib_needsVal
* Purpose: Provides ulib needs val helper behavior for the heads-up display.
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
* Purpose: Initializes state and dependencies for the engine module behavior.
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
* Purpose: Provides ulib add char to text line helper behavior for the heads-up display.
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
* Purpose: Provides ulib del char from text line helper behavior for the heads-up display.
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
* Purpose: Draws hUlib draw Text Line output for the heads-up display renderer.
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
* Purpose: Provides ulib erase text line helper behavior for the heads-up display.
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
* Purpose: Initializes state and dependencies for the engine module behavior.
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
* Purpose: Provides ulib add line to s text helper behavior for the heads-up display.
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
* Purpose: Controls hUlib append Bytes transitions in the heads-up display system.
*/
function _HUlib_appendBytes(tl, b)
  if tl == 0 or b == 0 then return end if
  for i = 0 to len(b) - 1
    HUlib_addCharToTextLine(tl, b[i])
  end for
end function

/*
* Function: HUlib_addMessageToSText
* Purpose: Provides ulib add message to s text helper behavior for the heads-up display.
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
* Purpose: Draws hUlib draw SText output for the heads-up display renderer.
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
* Purpose: Provides ulib erase s text helper behavior for the heads-up display.
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
* Purpose: Initializes state and dependencies for the engine module behavior.
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
* Purpose: Provides ulib del char from i text helper behavior for the heads-up display.
*/
function HUlib_delCharFromIText(it)
  if it == 0 then return false end if
  if it.l.len <= it.lm then return false end if
  return HUlib_delCharFromTextLine(it.l)
end function

/*
* Function: HUlib_eraseLineFromIText
* Purpose: Provides ulib erase line from i text helper behavior for the heads-up display.
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
* Purpose: Provides ulib add prefix to i text helper behavior for the heads-up display.
*/
function HUlib_addPrefixToIText(it, str)
  if it == 0 then return end if
  if str == 0 then return end if
  _HUlib_appendBytes(it.l, bytes(str))
  it.lm = it.l.len
end function

/*
* Function: HUlib_keyInIText
* Purpose: Initializes state and dependencies for the engine module behavior.
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
* Purpose: Draws hUlib draw IText output for the heads-up display renderer.
*/
function HUlib_drawIText(it)
  if it == 0 then return end if
  if not _HUlib_refBool(it.on) then return end if
  HUlib_drawTextLine(it.l, true)
end function

/*
* Function: HUlib_eraseIText
* Purpose: Provides ulib erase i text helper behavior for the heads-up display.
*/
function HUlib_eraseIText(it)
  if it == 0 then return end if
  if it.laston and(not _HUlib_refBool(it.on)) then
    it.l.needsupdate = 4
  end if
  HUlib_eraseTextLine(it.l)
  it.laston = _HUlib_refBool(it.on)
end function



