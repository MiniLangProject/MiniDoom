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

  Script: f_finale.ml
  Purpose: Implements finale sequencing, text pages, and ending presentation.
*/
import doomtype
import d_event
import i_system
import m_swap
import z_zone
import v_video
import w_wad
import s_sound
import dstrings
import sounds
import doomstat
import r_state
import hu_stuff
import m_misc

const TEXTSPEED = 3
const TEXTWAIT = 250

finale_started = false
finale_count = 0
finale_stage = 0
finale_text = ""
finale_flat = "FLOOR4_8"

cast_active = false
cast_tics = 0
cast_name = ""
bunny_laststage = -1

/*
* Function: _F_Substr
* Purpose: Implements the _F_Substr routine for the internal module support.
*/
function _F_Substr(s, n)
  if typeof(s) != "string" then return "" end if
  if n <= 0 then return "" end if
  b = bytes(s)
  if n > len(b) then n = len(b) end if
  return decode(slice(b, 0, n))
end function

/*
* Function: _F_IDiv
* Purpose: Implements the _F_IDiv routine for the internal module support.
*/
function _F_IDiv(a, b)
  if typeof(a) != "int" or typeof(b) != "int" or b == 0 then return 0 end if
  q = a / b
  if q >= 0 then return std.math.floor(q) end if
  return std.math.ceil(q)
end function

/*
* Function: _F_u16le
* Purpose: Implements the _F_u16le routine for the internal module support.
*/
function _F_u16le(b, off)
  return b[off] +(b[off + 1] << 8)
end function

/*
* Function: _F_u32le
* Purpose: Implements the _F_u32le routine for the internal module support.
*/
function _F_u32le(b, off)
  return b[off] +(b[off + 1] << 8) +(b[off + 2] << 16) +(b[off + 3] << 24)
end function

/*
* Function: _F_PatchWidth
* Purpose: Implements the _F_PatchWidth routine for the internal module support.
*/
function _F_PatchWidth(patch)
  if typeof(patch) != "bytes" or len(patch) < 8 then return 0 end if
  return _F_u16le(patch, 0)
end function

/*
* Function: _F_UpperAscii
* Purpose: Implements the _F_UpperAscii routine for the internal module support.
*/
function _F_UpperAscii(c)
  if c >= 97 and c <= 122 then return c - 32 end if
  return c
end function

/*
* Function: _F_AnyPlayerButtons
* Purpose: Implements the _F_AnyPlayerButtons routine for the internal module support.
*/
function _F_AnyPlayerButtons()
  i = 0
  while i < MAXPLAYERS
    if typeof(players) == "array" and i < len(players) and players[i] is not void then
      if typeof(players[i].cmd) != "void" and typeof(players[i].cmd.buttons) == "int" and players[i].cmd.buttons != 0 then
        return true
      end if
    end if
    i = i + 1
  end while
  return false
end function

/*
* Function: _F_DrawTiledFlat
* Purpose: Draws or renders output for the internal module support.
*/
function _F_DrawTiledFlat(name)
  if typeof(screens) != "array" or len(screens) == 0 then return end if
  dest = screens[0]
  if typeof(dest) != "bytes" then return end if

  src = void
  if typeof(W_CheckNumForName) == "function" and W_CheckNumForName(name) >= 0 then
    src = W_CacheLumpName(name, PU_CACHE)
  end if

  y = 0
  while y < SCREENHEIGHT
    row = y * SCREENWIDTH
    if typeof(src) == "bytes" and len(src) >= 4096 then
      soff =(y & 63) << 6
      x = 0
      while x < SCREENWIDTH
        run = 64
        if x + run > SCREENWIDTH then run = SCREENWIDTH - x end if
        i = 0
        while i < run
          dest[row + x + i] = src[soff + i]
          i = i + 1
        end while
        x = x + run
      end while
    else
      x = 0
      while x < SCREENWIDTH
        dest[row + x] = 0
        x = x + 1
      end while
    end if
    y = y + 1
  end while

  V_MarkRect(0, 0, SCREENWIDTH, SCREENHEIGHT)
end function

/*
* Function: _F_EndPatchName
* Purpose: Implements the _F_EndPatchName routine for the internal module support.
*/
function _F_EndPatchName(stage)
  if stage <= 0 then return "END0" end if
  if stage == 1 then return "END1" end if
  if stage == 2 then return "END2" end if
  if stage == 3 then return "END3" end if
  if stage == 4 then return "END4" end if
  if stage == 5 then return "END5" end if
  return "END6"
end function

/*
* Function: F_StartFinale
* Purpose: Starts runtime behavior in the finale subsystem.
*/
function F_StartFinale()
  global finale_started
  global finale_count
  global finale_stage
  global finale_text
  global finale_flat
  global cast_active
  global bunny_laststage
  global gamestate
  global viewactive
  global automapactive
  global gameaction

  gameaction = gameaction_t.ga_nothing

  finale_started = true
  finale_count = 0
  finale_stage = 0
  cast_active = false
  bunny_laststage = -1

  gamestate = gamestate_t.GS_FINALE
  viewactive = false
  automapactive = false

  if gamemode == GameMode_t.shareware or gamemode == GameMode_t.registered or gamemode == GameMode_t.retail then
    S_ChangeMusic(musicenum_t.mus_victor, true)
    if gameepisode == 1 then
      finale_flat = "FLOOR4_8"
      finale_text = E1TEXT
    else if gameepisode == 2 then
      finale_flat = "SFLR6_1"
      finale_text = E2TEXT
    else if gameepisode == 3 then
      finale_flat = "MFLR8_4"
      finale_text = E3TEXT
    else if gameepisode == 4 then
      finale_flat = "MFLR8_3"
      finale_text = E4TEXT
    else
      finale_flat = "FLOOR4_8"
      finale_text = E1TEXT
    end if
    return
  end if

  if gamemode == GameMode_t.commercial then
    S_ChangeMusic(musicenum_t.mus_read_m, true)
    if gamemap == 6 then
      finale_flat = "SLIME16"
      finale_text = C1TEXT
    else if gamemap == 11 then
      finale_flat = "RROCK14"
      finale_text = C2TEXT
    else if gamemap == 20 then
      finale_flat = "RROCK07"
      finale_text = C3TEXT
    else if gamemap == 30 then
      finale_flat = "RROCK17"
      finale_text = C4TEXT
    else if gamemap == 15 then
      finale_flat = "RROCK13"
      finale_text = C5TEXT
    else if gamemap == 31 then
      finale_flat = "RROCK19"
      finale_text = C6TEXT
    else
      finale_flat = "SLIME16"
      finale_text = C1TEXT
    end if
    return
  end if

  S_ChangeMusic(musicenum_t.mus_read_m, true)
  finale_flat = SKYFLATNAME
  finale_text = C1TEXT
end function

/*
* Function: F_Responder
* Purpose: Implements the F_Responder routine for the finale subsystem.
*/
function F_Responder(ev)
  if ev == 0 then return false end if
  if finale_stage == 2 or cast_active then
    return F_CastResponder(ev)
  end if
  return false
end function

/*
* Function: F_TextWrite
* Purpose: Implements the F_TextWrite routine for the finale subsystem.
*/
function F_TextWrite()
  if not finale_started then return end if
  _F_DrawTiledFlat(finale_flat)

  if typeof(finale_text) != "string" or len(finale_text) == 0 then return end if
  if typeof(hu_font) != "array" then return end if

  count = _F_Substr(finale_text, _F_IDiv(finale_count - 10, TEXTSPEED))
  textb = bytes(count)
  i = 0
  cx = 10
  cy = 10
  while i < len(textb)
    c = textb[i]
    if c == 10 then
      cx = 10
      cy = cy + 11
      i = i + 1
      continue
    end if

    c = _F_UpperAscii(c) - HU_FONTSTART
    if c < 0 or c >= HU_FONTSIZE then
      cx = cx + 4
      i = i + 1
      continue
    end if

    patch = hu_font[c]
    if typeof(patch) != "bytes" then
      cx = cx + 4
      i = i + 1
      continue
    end if
    w = _F_PatchWidth(patch)
    if cx + w > SCREENWIDTH then break end if
    V_DrawPatch(cx, cy, 0, patch)
    cx = cx + w
    i = i + 1
  end while
end function

/*
* Function: F_StartCast
* Purpose: Starts runtime behavior in the finale subsystem.
*/
function F_StartCast()
  global cast_active
  global cast_tics
  global cast_name
  global finale_stage

  cast_active = true
  cast_tics = 0
  cast_name = CC_ZOMBIE
  finale_stage = 2
  S_ChangeMusic(musicenum_t.mus_evil, true)
end function

/*
* Function: F_CastTicker
* Purpose: Advances per-tick logic for the finale subsystem.
*/
function F_CastTicker()
  global cast_tics
  if not cast_active then return end if
  cast_tics = cast_tics + 1
end function

/*
* Function: F_CastResponder
* Purpose: Implements the F_CastResponder routine for the finale subsystem.
*/
function F_CastResponder(ev)
  if ev == 0 then return false end if
  if ev.type == evtype_t.ev_keydown then
    global cast_tics
    cast_tics = cast_tics + 1
    return true
  end if
  return false
end function

/*
* Function: F_CastPrint
* Purpose: Implements the F_CastPrint routine for the finale subsystem.
*/
function F_CastPrint(text)
  if typeof(hu_font) != "array" then
    if typeof(M_DrawText) == "function" then M_DrawText(90, 180, false, text) end if
    return
  end if

  b = bytes(text)
  width = 0
  i = 0
  while i < len(b)
    c = _F_UpperAscii(b[i]) - HU_FONTSTART
    if c < 0 or c >= HU_FONTSIZE then
      width = width + 4
    else
      p = hu_font[c]
      if typeof(p) == "bytes" then
        width = width + _F_PatchWidth(p)
      else
        width = width + 4
      end if
    end if
    i = i + 1
  end while

  cx = 160 - _F_IDiv(width, 2)
  i = 0
  while i < len(b)
    c = _F_UpperAscii(b[i]) - HU_FONTSTART
    if c < 0 or c >= HU_FONTSIZE then
      cx = cx + 4
    else
      p = hu_font[c]
      if typeof(p) == "bytes" then
        V_DrawPatch(cx, 180, 0, p)
        cx = cx + _F_PatchWidth(p)
      else
        cx = cx + 4
      end if
    end if
    i = i + 1
  end while
end function

/*
* Function: F_DrawPatchCol
* Purpose: Draws or renders output for the finale subsystem.
*/
function F_DrawPatchCol(x, patch, col)
  if typeof(screens) != "array" or len(screens) == 0 then return end if
  fb = screens[0]
  if typeof(fb) != "bytes" then return end if
  if typeof(patch) != "bytes" then return end if
  if x < 0 or x >= SCREENWIDTH then return end if

  width = _F_PatchWidth(patch)
  if col < 0 or col >= width then return end if
  colofs = _F_u32le(patch, 8 + col * 4)
  if colofs < 0 or colofs >= len(patch) then return end if

  p = colofs
  while p >= 0 and p < len(patch)
    topdelta = patch[p]
    if topdelta == 255 then break end if
    if p + 3 >= len(patch) then break end if
    run = patch[p + 1]
    src = p + 3
    i = 0
    while i < run and(src + i) < len(patch)
      y = topdelta + i
      if y >= 0 and y < SCREENHEIGHT then
        fb[y * SCREENWIDTH + x] = patch[src + i]
      end if
      i = i + 1
    end while
    p = p + run + 4
  end while
end function

/*
* Function: F_BunnyScroll
* Purpose: Implements the F_BunnyScroll routine for the finale subsystem.
*/
function F_BunnyScroll()
  if W_CheckNumForName("PFUB1") < 0 or W_CheckNumForName("PFUB2") < 0 then
    _F_DrawTiledFlat(finale_flat)
    return
  end if

  p1 = W_CacheLumpName("PFUB2", PU_LEVEL)
  p2 = W_CacheLumpName("PFUB1", PU_LEVEL)
  V_MarkRect(0, 0, SCREENWIDTH, SCREENHEIGHT)

  scrolled = 320 - _F_IDiv(finale_count - 230, 2)
  if scrolled > 320 then scrolled = 320 end if
  if scrolled < 0 then scrolled = 0 end if

  x = 0
  while x < SCREENWIDTH
    if (x + scrolled) < 320 then
      F_DrawPatchCol(x, p1, x + scrolled)
    else
      F_DrawPatchCol(x, p2, x + scrolled - 320)
    end if
    x = x + 1
  end while

  if finale_count < 1130 then return end if

  if finale_count < 1180 then
    if W_CheckNumForName("END0") >= 0 then
      V_DrawPatch(_F_IDiv(SCREENWIDTH - 13 * 8, 2), _F_IDiv(SCREENHEIGHT - 8 * 8, 2), 0, W_CacheLumpName("END0", PU_CACHE))
    end if
    global bunny_laststage
    bunny_laststage = 0
    return
  end if

  stage = _F_IDiv(finale_count - 1180, 5)
  if stage > 6 then stage = 6 end if
  if stage > bunny_laststage then
    S_StartSound(void, sfxenum_t.sfx_pistol)
    bunny_laststage = stage
  end if

  nm = _F_EndPatchName(stage)
  if W_CheckNumForName(nm) >= 0 then
    V_DrawPatch(_F_IDiv(SCREENWIDTH - 13 * 8, 2), _F_IDiv(SCREENHEIGHT - 8 * 8, 2), 0, W_CacheLumpName(nm, PU_CACHE))
  end if
end function

/*
* Function: F_CastDrawer
* Purpose: Draws or renders output for the finale subsystem.
*/
function F_CastDrawer()
  if not cast_active then return end if
  if W_CheckNumForName("BOSSBACK") >= 0 then
    V_DrawPatch(0, 0, 0, W_CacheLumpName("BOSSBACK", PU_CACHE))
  end if
  F_CastPrint(cast_name)
end function

/*
* Function: F_Ticker
* Purpose: Advances per-tick logic for the finale subsystem.
*/
function F_Ticker()
  global finale_count
  global finale_stage
  global wipegamestate
  global gameaction

  if not finale_started then return end if

  if gamemode == GameMode_t.commercial and finale_count > 50 and _F_AnyPlayerButtons() then
    if gamemap == 30 then
      F_StartCast()
    else
      gameaction = gameaction_t.ga_worlddone
    end if
  end if

  finale_count = finale_count + 1

  if finale_stage == 2 or cast_active then
    F_CastTicker()
    return
  end if

  if gamemode == GameMode_t.commercial then return end if

  if finale_stage == 0 and finale_count > len(finale_text) * TEXTSPEED + TEXTWAIT then
    finale_count = 0
    finale_stage = 1
    wipegamestate = -1
    if gameepisode == 3 then
      S_StartMusic(musicenum_t.mus_bunny)
    end if
  end if
end function

/*
* Function: F_Drawer
* Purpose: Draws or renders output for the finale subsystem.
*/
function F_Drawer()
  if not finale_started then return end if

  if finale_stage == 2 or cast_active then
    F_CastDrawer()
    return
  end if

  if finale_stage == 0 then
    F_TextWrite()
    return
  end if

  if gameepisode == 1 then
    if gamemode == GameMode_t.retail then
      if W_CheckNumForName("CREDIT") >= 0 then V_DrawPatch(0, 0, 0, W_CacheLumpName("CREDIT", PU_CACHE)) end if
    else
      if W_CheckNumForName("HELP2") >= 0 then V_DrawPatch(0, 0, 0, W_CacheLumpName("HELP2", PU_CACHE)) end if
    end if
  else if gameepisode == 2 then
    if W_CheckNumForName("VICTORY2") >= 0 then V_DrawPatch(0, 0, 0, W_CacheLumpName("VICTORY2", PU_CACHE)) end if
  else if gameepisode == 3 then
    F_BunnyScroll()
  else if gameepisode == 4 then
    if W_CheckNumForName("ENDPIC") >= 0 then V_DrawPatch(0, 0, 0, W_CacheLumpName("ENDPIC", PU_CACHE)) end if
  else
    _F_DrawTiledFlat(finale_flat)
  end if
end function



