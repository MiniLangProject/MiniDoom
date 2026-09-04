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

//! Owns console animation, history, input capture, scrolling, and drawing while delegating command execution.

import d_event
import doomdef
import doomstat
import v_video
import hu_lib
import console_cmd
import std.time
import std.math
import std.string as str

/// Defines cui panel height for the console ui subsystem.
const CUI_PANEL_HEIGHT = 68
/// Defines cui animation ms for the console ui subsystem.
const CUI_ANIMATION_MS = 200
/// Defines the maximum cui max log lines accepted by the console ui subsystem.
const CUI_MAX_LOG_LINES = 256
/// Defines the maximum cui max history accepted by the console ui subsystem.
const CUI_MAX_HISTORY = 32
/// Defines the maximum cui max input accepted by the console ui subsystem.
const CUI_MAX_INPUT = 60
/// Defines cui visible lines for the console ui subsystem.
const CUI_VISIBLE_LINES = 5
/// Defines cui line step for the console ui subsystem.
const CUI_LINE_STEP = 9
/// Defines the Doom palette selection for cui background color.
const CUI_BACKGROUND_COLOR = 0
/// Defines the Doom palette selection for cui border color.
const CUI_BORDER_COLOR = 176

/// Tracks whether cui initialized is active in the console ui subsystem.
/// @internal
_cui_initialized = false
/// Stores the cui font collection used by the console ui subsystem.
/// @internal
_cui_font =[]
/// Tracks the mutable cui font start value used by the console ui subsystem.
/// @internal
_cui_font_start = 33
/// Stores the cui log collection used by the console ui subsystem.
/// @internal
_cui_log =[]
/// Stores the cui history collection used by the console ui subsystem.
/// @internal
_cui_history =[]
/// Stores the mutable cui input text used by the console ui subsystem.
/// @internal
_cui_input = ""
/// Tracks the mutable cui history pos value used by the console ui subsystem.
/// @internal
_cui_history_pos = 0
/// Tracks the mutable cui scroll value used by the console ui subsystem.
/// @internal
_cui_scroll = 0
/// Tracks whether cui wanted open is active in the console ui subsystem.
/// @internal
_cui_wanted_open = false
/// Tracks the mutable cui height value used by the console ui subsystem.
/// @internal
_cui_height = 0
/// Tracks the mutable cui anim start height value used by the console ui subsystem.
/// @internal
_cui_anim_start_height = 0
/// Tracks the mutable cui anim target height value used by the console ui subsystem.
/// @internal
_cui_anim_target_height = 0
/// Tracks the mutable cui anim started value used by the console ui subsystem.
/// @internal
_cui_anim_started = 0
/// Tracks the mutable cui anim duration value used by the console ui subsystem.
/// @internal
_cui_anim_duration = CUI_ANIMATION_MS
/// Tracks whether cui pause owned is active in the console ui subsystem.
/// @internal
_cui_pause_owned = false
/// Tracks whether cui pause restore is active in the console ui subsystem.
/// @internal
_cui_pause_restore = false
/// Holds the optional cui fps line resource used by the console ui subsystem.
/// @internal
_cui_fps_line = void
/// Tracks the mutable cui fps value value used by the console ui subsystem.
/// @internal
_cui_fps_value = -1
/// Tracks whether cui shift down is active in the console ui subsystem.
/// @internal
_cui_shift_down = false

/// Divides animation integers with truncation toward zero and a safe zero-divisor fallback.
/// @param a First input operand.
/// @param b Second input operand.
/// @internal
function inline _CUI_IDiv(a, b)
  if typeof(a) != "int" or typeof(b) != "int" or b == 0 then return 0 end if
  q = a / b
  if q >= 0 then return std.math.floor(q) end if
  return std.math.ceil(q)
end function

/// Returns a non-negative animation distance.
/// @param v Value consumed by the operation.
/// @internal
function inline _CUI_Abs(v)
  if v < 0 then return - v end if
  return v
end function

/// Initializes bounded console collections and seeds the first informational log line exactly once.
function CUI_Init()
  global _cui_initialized
  global _cui_log
  global _cui_history
  global _cui_history_pos

  if _cui_initialized then return end if
  _cui_initialized = true
  _cui_log =["READY - TYPE HELP OR CHEATS"]
  _cui_history =[]
  _cui_history_pos = 0
end function

/// Receives the already cached STCFN HUD font so console text exactly matches one-line game messages.
/// @param font Font value supplied to `CUI_SetFont`.
/// @param startchar Startchar value supplied to `CUI_SetFont`.
function CUI_SetFont(font, startchar)
  global _cui_font
  global _cui_font_start
  global _cui_fps_line
  global _cui_fps_value

  CUI_Init()
  if typeof(font) == "array" then _cui_font = font end if
  if typeof(startchar) == "int" then _cui_font_start = startchar end if
  _cui_fps_line = void
  _cui_fps_value = -1
end function

/// Splits and appends chronological system, error, chat, or command text to bounded scrollback.
/// @param message Message text or payload to process.
function CUI_Log(message)
  global _cui_log
  global _cui_scroll

  CUI_Init()
  if typeof(message) != "string" or message == "" then return end if

  lines = str.split(message, "\n")
  i = 0
  while i < len(lines)
    if typeof(lines[i]) == "string" and lines[i] != "" then
      _cui_log = _cui_log +[lines[i]]
    end if
    i = i + 1
  end while
  if len(_cui_log) > CUI_MAX_LOG_LINES then
    _cui_log = slice(_cui_log, len(_cui_log) - CUI_MAX_LOG_LINES, CUI_MAX_LOG_LINES)
  end if
  _cui_scroll = 0
end function

/// Clears console scrollback without altering command history or current input.
function CUI_ClearLog()
  global _cui_log
  global _cui_scroll
  _cui_log =[]
  _cui_scroll = 0
end function

/// Computes the oldest valid viewport offset for the fixed visible line count.
/// @internal
function inline _CUI_MaxScroll()
  n = len(_cui_log) - CUI_VISIBLE_LINES
  if n < 0 then return 0 end if
  return n
end function

/// Replaces the editable command text with a bounded history entry.
/// @param text Text to process.
/// @internal
function _CUI_SetInput(text)
  global _cui_input
  if typeof(text) != "string" then
    _cui_input = ""
    return
  end if
  if len(text) > CUI_MAX_INPUT then
    _cui_input = stringSlice(text, 0, CUI_MAX_INPUT)
  else
    _cui_input = text
  end if
end function

/// Restores the pause state that existed before the console began capturing input.
/// @internal
function _CUI_ReleasePause()
  global paused
  global _cui_pause_owned

  if not _cui_pause_owned then return end if
  paused = _cui_pause_restore
  _cui_pause_owned = false
end function

/// Advances the time-based slide and releases the owned pause only after the closing panel fully exits.
/// @internal
function _CUI_UpdateAnimation()
  global _cui_height

  if _cui_height == _cui_anim_target_height then return end if
  now = std.time.ticks()
  if typeof(now) != "int" then
    _cui_height = _cui_anim_target_height
  else
    elapsed = now - _cui_anim_started
    if elapsed >= _cui_anim_duration then
      _cui_height = _cui_anim_target_height
    else if elapsed <= 0 then
      _cui_height = _cui_anim_start_height
    else
      delta = _cui_anim_target_height - _cui_anim_start_height
      _cui_height = _cui_anim_start_height + _CUI_IDiv(delta * elapsed, _cui_anim_duration)
    end if
  end if

  if _cui_height <= 0 and not _cui_wanted_open then
    _cui_height = 0
    _CUI_ReleasePause()
  end if
end function

/// Starts a reversible constant-speed slide and acquires or eventually restores the gameplay pause.
/// @param openConsole Open console value supplied to `CUI_SetOpen`.
function CUI_SetOpen(openConsole)
  global paused
  global _cui_wanted_open
  global _cui_anim_start_height
  global _cui_anim_target_height
  global _cui_anim_started
  global _cui_anim_duration
  global _cui_pause_owned
  global _cui_pause_restore
  global _cui_shift_down

  CUI_Init()
  _CUI_UpdateAnimation()
  wanted = false
  if typeof(openConsole) == "bool" then wanted = openConsole end if
  if wanted == _cui_wanted_open and _cui_height == _cui_anim_target_height then return end if

  _cui_wanted_open = wanted
  if not wanted then _cui_shift_down = false end if
  if wanted and not _cui_pause_owned then
    _cui_pause_restore = paused
    _cui_pause_owned = true
    paused = true
    if typeof(G_ClearInputState) == "function" then G_ClearInputState() end if
  end if

  _cui_anim_start_height = _cui_height
  if wanted then _cui_anim_target_height = CUI_PANEL_HEIGHT else _cui_anim_target_height = 0 end if
  distance = _CUI_Abs(_cui_anim_target_height - _cui_anim_start_height)
  _cui_anim_duration = _CUI_IDiv(CUI_ANIMATION_MS * distance, CUI_PANEL_HEIGHT)
  if _cui_anim_duration < 1 then _cui_anim_duration = 1 end if
  _cui_anim_started = std.time.ticks()
end function

/// Reverses the current console target while preserving in-flight animation continuity.
function CUI_Toggle()
  CUI_SetOpen(not _cui_wanted_open)
end function

/// Reports whether visible or animating console UI must consume all gameplay input.
function CUI_IsCapturing()
  _CUI_UpdateAnimation()
  return _cui_wanted_open or _cui_height > 0
end function

/// Adds one submitted command to bounded navigation history, avoiding adjacent duplicates.
/// @param command Command value supplied to `_CUI_RecordHistory`.
/// @internal
function _CUI_RecordHistory(command)
  global _cui_history
  global _cui_history_pos

  if command == "" then return end if
  if len(_cui_history) == 0 or _cui_history[len(_cui_history) - 1] != command then
    _cui_history = _cui_history +[command]
    if len(_cui_history) > CUI_MAX_HISTORY then
      _cui_history = slice(_cui_history, len(_cui_history) - CUI_MAX_HISTORY, CUI_MAX_HISTORY)
    end if
  end if
  _cui_history_pos = len(_cui_history)
end function

/// Sends the current line across the parser boundary and applies only the returned UI requests.
/// @internal
function _CUI_Submit()
  global _cui_input

  command = _cui_input
  _cui_input = ""
  if command == "" then return end if

  _CUI_RecordHistory(command)
  CUI_Log("> " + command)
  result = CCMD_Execute(command)
  if result is void then
    CUI_Log("COMMAND FAILED")
    return
  end if
  if result.clearLog then CUI_ClearLog() end if
  if typeof(result.message) == "string" and result.message != "" then CUI_Log(result.message) end if
  if result.closeConsole then CUI_SetOpen(false) end if
end function

/// Loads the preceding submitted command into the editable line.
/// @internal
function _CUI_HistoryUp()
  global _cui_history_pos
  if len(_cui_history) == 0 then return end if
  if _cui_history_pos > 0 then _cui_history_pos = _cui_history_pos - 1 end if
  _CUI_SetInput(_cui_history[_cui_history_pos])
end function

/// Loads the following submitted command or returns to a blank newest entry.
/// @internal
function _CUI_HistoryDown()
  global _cui_history_pos
  if len(_cui_history) == 0 then return end if
  if _cui_history_pos < len(_cui_history) - 1 then
    _cui_history_pos = _cui_history_pos + 1
    _CUI_SetInput(_cui_history[_cui_history_pos])
  else
    _cui_history_pos = len(_cui_history)
    _CUI_SetInput("")
  end if
end function

/// Toggles on tilde/O-umlaut, edits commands, scrolls output, and consumes every event while captured.
/// @param ev Input event to process.
function CUI_Responder(ev)
  global _cui_input
  global _cui_scroll
  global _cui_shift_down

  if ev is void then return false end if
  if ev.data1 == KEY_RSHIFT then
    if not CUI_IsCapturing() then return false end if
    _cui_shift_down = ev.type == evtype_t.ev_keydown
    return true
  end if
  if ev.type == evtype_t.ev_keydown and ev.data1 == KEY_CONSOLE then
    CUI_Toggle()
    return true
  end if
  if not CUI_IsCapturing() then return false end if
  if not _cui_wanted_open or ev.type != evtype_t.ev_keydown then return true end if

  key = ev.data1
  if key == KEY_ESCAPE then
    CUI_SetOpen(false)
  else if key == KEY_ENTER then
    _CUI_Submit()
  else if key == KEY_BACKSPACE then
    if len(_cui_input) > 0 then _cui_input = stringSlice(_cui_input, 0, len(_cui_input) - 1) end if
  else if key == KEY_UPARROW then
    _CUI_HistoryUp()
  else if key == KEY_DOWNARROW then
    _CUI_HistoryDown()
  else if key == KEY_PAGEUP then
    _cui_scroll = _cui_scroll + CUI_VISIBLE_LINES
    if _cui_scroll > _CUI_MaxScroll() then _cui_scroll = _CUI_MaxScroll() end if
  else if key == KEY_PAGEDOWN then
    _cui_scroll = _cui_scroll - CUI_VISIBLE_LINES
    if _cui_scroll < 0 then _cui_scroll = 0 end if
  else if typeof(key) == "int" and key >= 32 and key <= 126 and len(_cui_input) < CUI_MAX_INPUT then
    if _cui_shift_down and key >= 97 and key <= 122 then key = key - 32 end if
    _cui_input = _cui_input + decode(bytes([key]))
  end if
  return true
end function

/// Draws one clipped STCFN text line at logical coordinates with an optional underscore cursor.
/// @param x Horizontal map- or screen-space coordinate.
/// @param y Vertical map- or screen-space coordinate.
/// @param text Text to process.
/// @param cursor Cursor value supplied to `_CUI_DrawText`.
/// @internal
function _CUI_DrawText(x, y, text, cursor)
  if typeof(_cui_font) != "array" or len(_cui_font) == 0 then return end if
  if typeof(text) != "string" then return end if

  line = hu_textline_t(0, 0, 0, 0, bytes(HU_MAXLINELENGTH + 1, 0), 0, 0)
  HUlib_initTextLine(line, x, y, _cui_font, _cui_font_start)
  data = bytes(text)
  i = 0
  while i < len(data) and i < HU_MAXLINELENGTH
    HUlib_addCharToTextLine(line, data[i])
    i = i + 1
  end while
  HUlib_drawTextLine(line, cursor)
end function

/// Reuses one text widget until the sampled FPS changes, keeping the closed-console overlay inexpensive.
/// @param y Vertical map- or screen-space coordinate.
/// @internal
function _CUI_DrawFPS(y)
  global _cui_fps_line
  global _cui_fps_value

  if not console_show_fps then return end if
  fps = 0
  if typeof(I_GetFPS) == "function" then fps = I_GetFPS() end if
  if _cui_fps_line is void or fps != _cui_fps_value then
    _cui_fps_value = fps
    _cui_fps_line = hu_textline_t(0, 0, 0, 0, bytes(HU_MAXLINELENGTH + 1, 0), 0, 0)
    HUlib_initTextLine(_cui_fps_line, 260, y, _cui_font, _cui_font_start)
    label = bytes("FPS " + fps)
    i = 0
    while i < len(label)
      HUlib_addCharToTextLine(_cui_fps_line, label[i])
      i = i + 1
    end while
  else
    _cui_fps_line.y = y
  end if
  HUlib_drawTextLine(_cui_fps_line, false)
end function

/// Renders the animated translucent panel, scrollback, separator, input line, and optional FPS counter.
function CUI_Drawer()
  CUI_Init()
  _CUI_UpdateAnimation()

  // Console glyphs already pass through the scaled logical overlay, so per-glyph HD preparation is redundant.
  if typeof(V_SetHighresPatchOverlayEnabled) == "function" then V_SetHighresPatchOverlayEnabled(false) end if

  if _cui_height > 0 then
    originY = _cui_height - CUI_PANEL_HEIGHT
    V_DrawDitheredOverlayRect(0, 0, SCREENWIDTH, _cui_height, CUI_BACKGROUND_COLOR)
    V_DrawSolidOverlayRect(0, _cui_height - 1, SCREENWIDTH, 1, CUI_BORDER_COLOR)
    V_DrawSolidOverlayRect(0, originY + 55, SCREENWIDTH, 1, CUI_BORDER_COLOR)

    _CUI_DrawText(4, originY + 2, "MINIDOOM CONSOLE", false)

    newest = len(_cui_log) - 1 - _cui_scroll
    row = 0
    while row < CUI_VISIBLE_LINES
      idx = newest -(CUI_VISIBLE_LINES - 1 - row)
      if idx >= 0 and idx < len(_cui_log) then
        _CUI_DrawText(4, originY + 11 + row * CUI_LINE_STEP, _cui_log[idx], false)
      end if
      row = row + 1
    end while

    _CUI_DrawText(4, originY + 58, "> " + _cui_input, true)
    _CUI_DrawFPS(originY + 2)
  else
    _CUI_DrawFPS(2)
  end if
  if typeof(V_SetHighresPatchOverlayEnabled) == "function" then V_SetHighresPatchOverlayEnabled(true) end if
end function
