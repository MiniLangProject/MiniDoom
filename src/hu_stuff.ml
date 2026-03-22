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

  Script: hu_stuff.ml
  Purpose: Implements in-game HUD text and messaging behaviors.
*/
import d_event
import doomdef
import z_zone
import m_swap
import hu_lib
import w_wad
import s_sound
import doomstat
import dstrings
import d_englsh
import sounds
import m_menu
import mp_platform

const HU_FONTSTART = 33
const HU_FONTEND = 95
const HU_FONTSIZE =(HU_FONTEND - HU_FONTSTART + 1)

const HU_BROADCAST = 5
const HU_MPMSG_CHAT = 7
const HU_MPCHAT_MAXBYTES = 120

const HU_MSGREFRESH = KEY_ENTER
const HU_MSGX = 0
const HU_MSGY = 0
const HU_MSGWIDTH = 64
const HU_MSGHEIGHT = 1
const HU_MSGTIMEOUT = 4 * TICRATE

const HU_INPUTTOGGLE = 116
const HU_INPUTX = HU_MSGX

const HU_TITLEX = 0
chat_macros =[
HUSTR_CHATMACRO0,
HUSTR_CHATMACRO1,
HUSTR_CHATMACRO2,
HUSTR_CHATMACRO3,
HUSTR_CHATMACRO4,
HUSTR_CHATMACRO5,
HUSTR_CHATMACRO6,
HUSTR_CHATMACRO7,
HUSTR_CHATMACRO8,
HUSTR_CHATMACRO9
]

player_names =[HUSTR_PLRGREEN, HUSTR_PLRINDIGO, HUSTR_PLRBROWN, HUSTR_PLRRED]

mapnames =[
HUSTR_E1M1, HUSTR_E1M2, HUSTR_E1M3, HUSTR_E1M4, HUSTR_E1M5, HUSTR_E1M6, HUSTR_E1M7, HUSTR_E1M8, HUSTR_E1M9,
HUSTR_E2M1, HUSTR_E2M2, HUSTR_E2M3, HUSTR_E2M4, HUSTR_E2M5, HUSTR_E2M6, HUSTR_E2M7, HUSTR_E2M8, HUSTR_E2M9,
HUSTR_E3M1, HUSTR_E3M2, HUSTR_E3M3, HUSTR_E3M4, HUSTR_E3M5, HUSTR_E3M6, HUSTR_E3M7, HUSTR_E3M8, HUSTR_E3M9,
HUSTR_E4M1, HUSTR_E4M2, HUSTR_E4M3, HUSTR_E4M4, HUSTR_E4M5, HUSTR_E4M6, HUSTR_E4M7, HUSTR_E4M8, HUSTR_E4M9
]

mapnames2 =[
HUSTR_1, HUSTR_2, HUSTR_3, HUSTR_4, HUSTR_5, HUSTR_6, HUSTR_7, HUSTR_8, HUSTR_9, HUSTR_10, HUSTR_11, HUSTR_12, HUSTR_13, HUSTR_14, HUSTR_15, HUSTR_16,
HUSTR_17, HUSTR_18, HUSTR_19, HUSTR_20, HUSTR_21, HUSTR_22, HUSTR_23, HUSTR_24, HUSTR_25, HUSTR_26, HUSTR_27, HUSTR_28, HUSTR_29, HUSTR_30, HUSTR_31, HUSTR_32
]

mapnamesp =[
PHUSTR_1, PHUSTR_2, PHUSTR_3, PHUSTR_4, PHUSTR_5, PHUSTR_6, PHUSTR_7, PHUSTR_8, PHUSTR_9, PHUSTR_10, PHUSTR_11, PHUSTR_12, PHUSTR_13, PHUSTR_14, PHUSTR_15, PHUSTR_16,
PHUSTR_17, PHUSTR_18, PHUSTR_19, PHUSTR_20, PHUSTR_21, PHUSTR_22, PHUSTR_23, PHUSTR_24, PHUSTR_25, PHUSTR_26, PHUSTR_27, PHUSTR_28, PHUSTR_29, PHUSTR_30, PHUSTR_31, PHUSTR_32
]

mapnamest =[
THUSTR_1, THUSTR_2, THUSTR_3, THUSTR_4, THUSTR_5, THUSTR_6, THUSTR_7, THUSTR_8, THUSTR_9, THUSTR_10, THUSTR_11, THUSTR_12, THUSTR_13, THUSTR_14, THUSTR_15, THUSTR_16,
THUSTR_17, THUSTR_18, THUSTR_19, THUSTR_20, THUSTR_21, THUSTR_22, THUSTR_23, THUSTR_24, THUSTR_25, THUSTR_26, THUSTR_27, THUSTR_28, THUSTR_29, THUSTR_30, THUSTR_31, THUSTR_32
]

frenchKeyMap =[
0,
1, 2, 3, 4, 5, 6, 7, 8, 9, 10,
11, 12, 13, 14, 15, 16, 17, 18, 19, 20,
21, 22, 23, 24, 25, 26, 27, 28, 29, 30,
31,
32, 33, 34, 35, 36, 37, 38, 37, 40, 41, 42, 43, 59, 45, 58, 33,
48, 49, 50, 51, 52, 53, 54, 55, 56, 57, 58, 77, 60, 61, 62, 63,
64, 81, 66, 67, 68, 69, 70, 71, 72, 73, 74, 75, 76, 44, 78, 79,
80, 65, 82, 83, 84, 85, 86, 90, 88, 89, 87, 94, 92, 36, 94, 95,
64, 81, 66, 67, 68, 69, 70, 71, 72, 73, 74, 75, 76, 44, 78, 79,
80, 65, 82, 83, 84, 85, 86, 90, 88, 89, 87, 94, 92, 36, 94, 127
]

hu_font =[]

chat_char = 0
plr = void

w_title = hu_textline_t(0, 0, 0, 0, bytes(HU_MAXLINELENGTH + 1, 0), 0, 0)
w_message = hu_stext_t([], 0, 0,[false], false)
w_chat = hu_itext_t(hu_textline_t(0, 0, 0, 0, bytes(HU_MAXLINELENGTH + 1, 0), 0, 0), 0,[false], false)
w_inputbuffer =[]

always_off = false
always_off_ref =[false]
chat_dest =[0, 0, 0, 0]
destination_keys =[0, 0, 0, 0]

message_on = false
message_on_ref =[false]
message_dontfuckwithme = false
message_nottobefuckedwith = false
message_counter = 0

chat_on = false
chat_on_ref =[false]

headsupactive = false
hu_started = false

shiftxform =[]
shiftdown = false
altdown = false
num_nobrainers = 0
_hu_lastmessage = ""
_hu_local_chat_dest = HU_BROADCAST

/*
* Function: _HU_ToInt
* Purpose: Implements the _HU_ToInt routine for the internal module support.
*/
function _HU_ToInt(v, fallback)
  if typeof(v) == "int" then return v end if
  n = toNumber(v)
  if typeof(n) == "int" then return n end if
  if typeof(n) == "float" then
    if n >= 0 then return std.math.floor(n) end if
    return std.math.ceil(n)
  end if
  return fallback
end function

/*
* Function: _HU_SetMessageOn
* Purpose: Reads or updates state used by the internal module support.
*/
function _HU_SetMessageOn(v)
  global message_on
  global message_on_ref
  message_on = v
  if typeof(message_on_ref) == "array" and len(message_on_ref) > 0 then
    message_on_ref[0] = v
  end if
end function

/*
* Function: _HU_SetChatOn
* Purpose: Reads or updates state used by the internal module support.
*/
function _HU_SetChatOn(v)
  global chat_on
  global chat_on_ref
  chat_on = v
  if typeof(chat_on_ref) == "array" and len(chat_on_ref) > 0 then
    chat_on_ref[0] = v
  end if
end function

/*
* Function: _HU_FontHeight
* Purpose: Implements the _HU_FontHeight routine for the internal module support.
*/
function _HU_FontHeight()
  if typeof(hu_font) == "array" and len(hu_font) > 0 and hu_font[0] is not void then
    return RDefs_I16LE(hu_font[0], 2)
  end if
  return 8
end function

/*
* Function: _HU_KeyCodeFromString
* Purpose: Implements the _HU_KeyCodeFromString routine for the internal module support.
*/
function _HU_KeyCodeFromString(s)
  if typeof(s) != "string" or len(s) == 0 then return 0 end if
  b = bytes(s)
  if len(b) <= 0 then return 0 end if
  return b[0]
end function

/*
* Function: _HU_ShowMessagesEnabled
* Purpose: Implements the _HU_ShowMessagesEnabled routine for the internal module support.
*/
function _HU_ShowMessagesEnabled()
  if typeof(showMessages) == "int" then return showMessages != 0 end if
  return true
end function

/*
* Function: _HU_MPUsePacketChat
* Purpose: Returns true when chat should use dedicated multiplayer packets.
*/
function _HU_MPUsePacketChat()
  return netgame
end function

/*
* Function: _HU_MPSendChatMessage
* Purpose: Sends one complete chat line to the host as one packet.
*/
function _HU_MPSendChatMessage(dest, msg)
  if not _HU_MPUsePacketChat() then return false end if
  if typeof(msg) != "string" then return false end if
  m = str.trim(msg)
  if m == "" then return false end if
  if typeof(MP_PlatformSendChatMessage) != "function" then return false end if
  return MP_PlatformSendChatMessage(m)
end function

/*
* Function: _HU_PlayerName
* Purpose: Implements the _HU_PlayerName routine for the internal module support.
*/
function _HU_PlayerName(idx)
  if idx >= 0 and idx < len(player_names) then return player_names[idx] end if
  return ""
end function

/*
* Function: _HU_ITextString
* Purpose: Implements the _HU_ITextString routine for the internal module support.
*/
function _HU_ITextString(it)
  if it is void or it.l is void then return "" end if
  if typeof(it.l.l) != "bytes" then return "" end if
  n = _HU_ToInt(it.l.len, 0)
  if n < 0 then n = 0 end if
  if n > len(it.l.l) then n = len(it.l.l) end if
  return decode(slice(it.l.l, 0, n))
end function

/*
* Function: _HU_BuildBaseShiftMap
* Purpose: Implements the _HU_BuildBaseShiftMap routine for the internal module support.
*/
function _HU_BuildBaseShiftMap()
  m =[]
  i = 0
  while i < 128
    m = m +[i]
    i = i + 1
  end while
  i = 97
  while i <= 122
    m[i] = i - 32
    i = i + 1
  end while
  return m
end function

/*
* Function: _HU_BuildEnglishShiftMap
* Purpose: Implements the _HU_BuildEnglishShiftMap routine for the internal module support.
*/
function _HU_BuildEnglishShiftMap()
  m = _HU_BuildBaseShiftMap()

  m[39] = 34
  m[44] = 60
  m[45] = 95
  m[46] = 62
  m[47] = 63

  m[48] = 41
  m[49] = 33
  m[50] = 64
  m[51] = 35
  m[52] = 36
  m[53] = 37
  m[54] = 94
  m[55] = 38
  m[56] = 42
  m[57] = 40

  m[59] = 58
  m[61] = 43
  m[92] = 33
  m[96] = 39

  return m
end function

/*
* Function: _HU_BuildFrenchShiftMap
* Purpose: Implements the _HU_BuildFrenchShiftMap routine for the internal module support.
*/
function _HU_BuildFrenchShiftMap()
  m = _HU_BuildBaseShiftMap()

  m[39] = 34
  m[44] = 63
  m[45] = 95
  m[46] = 62
  m[47] = 63
  m[59] = 46
  m[61] = 43
  m[92] = 33
  m[96] = 39

  return m
end function

/*
* Function: _HU_ShiftChar
* Purpose: Implements the _HU_ShiftChar routine for the internal module support.
*/
function _HU_ShiftChar(c)
  if typeof(c) != "int" then return c end if
  if typeof(shiftxform) == "array" and c >= 0 and c < len(shiftxform) then
    return shiftxform[c]
  end if
  return c
end function

/*
* Function: _HU_CurrentPlayer
* Purpose: Implements the _HU_CurrentPlayer routine for the internal module support.
*/
function _HU_CurrentPlayer()
  if typeof(players) != "array" then return void end if
  if typeof(consoleplayer) != "int" then return void end if
  if consoleplayer < 0 or consoleplayer >= len(players) then return void end if
  return players[consoleplayer]
end function

/*
* Function: _HU_PopCurrentPlayerMessage
* Purpose: Reads and clears current player HUD message from authoritative player state.
*/
function _HU_PopCurrentPlayerMessage()
  global plr

  cp = _HU_ToInt(consoleplayer, -1)
  if typeof(players) == "array" and cp >= 0 and cp < len(players) and typeof(players[cp]) == "struct" then
    p = players[cp]
    plr = p
    if p.message is not void then
      msg = p.message
      p.message = void
      players[cp] = p
      plr = p
      return msg
    end if
  end if

  if plr is not void and plr.message is not void then
    msg = plr.message
    plr.message = void
    return msg
  end if

  return void
end function

/*
* Function: _HU_MapTitle
* Purpose: Implements the _HU_MapTitle routine for the internal module support.
*/
function _HU_MapTitle()
  if gamemode == GameMode_t.shareware or gamemode == GameMode_t.registered or gamemode == GameMode_t.retail then
    idx =(gameepisode - 1) * 9 + gamemap - 1
    if idx >= 0 and idx < len(mapnames) then return mapnames[idx] end if
    return "NEWLEVEL"
  end if

  if gamemode == GameMode_t.commercial then
    idx = gamemap - 1
    if gamemission == GameMission_t.pack_plut then
      if idx >= 0 and idx < len(mapnamesp) then return mapnamesp[idx] end if
    else if gamemission == GameMission_t.pack_tnt then
      if idx >= 0 and idx < len(mapnamest) then return mapnamest[idx] end if
    end if
    if idx >= 0 and idx < len(mapnames2) then return mapnames2[idx] end if
  end if

  return ""
end function

/*
* Function: _HU_InitDestinationKeys
* Purpose: Initializes state and dependencies for the internal module support.
*/
function _HU_InitDestinationKeys()
  destination_keys =[
  _HU_KeyCodeFromString(HUSTR_KEYGREEN),
  _HU_KeyCodeFromString(HUSTR_KEYINDIGO),
  _HU_KeyCodeFromString(HUSTR_KEYBROWN),
  _HU_KeyCodeFromString(HUSTR_KEYRED)
]
  return destination_keys
end function

/*
* Function: _HU_EnsureInputBuffers
* Purpose: Implements the _HU_EnsureInputBuffers routine for the internal module support.
*/
function _HU_EnsureInputBuffers()
  global w_inputbuffer
  w_inputbuffer =[]
  i = 0
  while i < MAXPLAYERS
    ib = hu_itext_t(hu_textline_t(0, 0, 0, 0, bytes(HU_MAXLINELENGTH + 1, 0), 0, 0), 0, always_off_ref, true)
    HUlib_initIText(ib, 0, 0, 0, 0, always_off_ref)
    w_inputbuffer = w_inputbuffer +[ib]
    i = i + 1
  end while
end function

/*
* Function: HU_Init
* Purpose: Initializes state and dependencies for the HUD subsystem.
*/
function HU_Init()
  global hu_font
  global shiftxform
  global message_on_ref
  global chat_on_ref

  HUlib_init()

  message_on_ref =[false]
  chat_on_ref =[false]

  if language == Language_t.french then
    shiftxform = _HU_BuildFrenchShiftMap()
  else
    shiftxform = _HU_BuildEnglishShiftMap()
  end if

  hu_font =[]
  i = 0
  while i < HU_FONTSIZE
    lumpname = "STCFN"
    n = HU_FONTSTART + i
    if n < 100 then lumpname = lumpname + "0" end if
    if n < 10 then lumpname = lumpname + "0" end if
    lumpname = lumpname + n
    if typeof(W_CheckNumForName) == "function" and W_CheckNumForName(lumpname) >= 0 then
      hu_font = hu_font +[W_CacheLumpName(lumpname, PU_STATIC)]
    else
      hu_font = hu_font +[void]
    end if
    i = i + 1
  end while
end function

/*
* Function: HU_Stop
* Purpose: Stops or tears down runtime behavior in the HUD subsystem.
*/
function HU_Stop()
  global headsupactive
  global hu_started
  headsupactive = false
  hu_started = false
  _HU_SetChatOn(false)
end function

/*
* Function: HU_Start
* Purpose: Starts runtime behavior in the HUD subsystem.
*/
function HU_Start()
  global w_message
  global w_chat
  global w_title
  global plr
  global headsupactive
  global hu_started
  global message_dontfuckwithme
  global message_nottobefuckedwith
  global num_nobrainers
  global chat_dest

  if headsupactive then HU_Stop() end if

  plr = _HU_CurrentPlayer()
  _HU_SetMessageOn(false)
  _HU_SetChatOn(false)
  message_dontfuckwithme = false
  message_nottobefuckedwith = false
  num_nobrainers = 0
  chat_dest =[0, 0, 0, 0]

  w_message = hu_stext_t([], 0, 0, message_on_ref, true)
  HUlib_initSText(w_message, HU_MSGX, HU_MSGY, HU_MSGHEIGHT, hu_font, HU_FONTSTART, message_on_ref)

  w_title = hu_textline_t(0, 0, 0, 0, bytes(HU_MAXLINELENGTH + 1, 0), 0, 0)
  HUlib_initTextLine(w_title, HU_TITLEX, 167 - _HU_FontHeight(), hu_font, HU_FONTSTART)
  title = _HU_MapTitle()
  tb = bytes(title)
  i = 0
  while i < len(tb)
    HUlib_addCharToTextLine(w_title, tb[i])
    i = i + 1
  end while

  inputY = HU_MSGY + HU_MSGHEIGHT *(_HU_FontHeight() + 1)
  w_chat = hu_itext_t(hu_textline_t(0, 0, 0, 0, bytes(HU_MAXLINELENGTH + 1, 0), 0, 0), 0, chat_on_ref, true)
  HUlib_initIText(w_chat, HU_INPUTX, inputY, hu_font, HU_FONTSTART, chat_on_ref)

  _HU_EnsureInputBuffers()
  _HU_InitDestinationKeys()

  headsupactive = true
  hu_started = true
end function

/*
* Function: HU_Drawer
* Purpose: Draws or renders output for the HUD subsystem.
*/
function HU_Drawer()
  if not headsupactive then return end if
  HUlib_drawSText(w_message)
  HUlib_drawIText(w_chat)
  if automapactive then HUlib_drawTextLine(w_title, false) end if
end function

/*
* Function: HU_Erase
* Purpose: Implements the HU_Erase routine for the HUD subsystem.
*/
function HU_Erase()
  HUlib_eraseSText(w_message)
  HUlib_eraseIText(w_chat)
  HUlib_eraseTextLine(w_title)
end function

/*
* Function: HU_NetAddMessage
* Purpose: Pushes one network-originated chat/feed line directly into HUD message area.
*/
function HU_NetAddMessage(msg)
  global message_counter
  global message_nottobefuckedwith
  global message_dontfuckwithme
  global plr
  if typeof(msg) != "string" or msg == "" then return end if

  if headsupactive then
    HUlib_addMessageToSText(w_message, 0, msg)
    _HU_SetMessageOn(true)
    message_counter = HU_MSGTIMEOUT
    message_nottobefuckedwith = true
    message_dontfuckwithme = false
    return
  end if

  cp = _HU_ToInt(consoleplayer, -1)
  if typeof(players) == "array" and cp >= 0 and cp < len(players) and typeof(players[cp]) == "struct" then
    p = players[cp]
    p.message = msg
    players[cp] = p
    plr = p
    return
  end if

  if plr is not void then
    plr.message = msg
  end if
end function

/*
* Function: HU_Ticker
* Purpose: Advances per-tick logic for the HUD subsystem.
*/
function HU_Ticker()
  global message_counter
  global message_nottobefuckedwith
  global message_dontfuckwithme

  if not headsupactive then return end if

  if message_counter != 0 then
    message_counter = message_counter - 1
    if message_counter == 0 then
      _HU_SetMessageOn(false)
      message_nottobefuckedwith = false
    end if
  end if

  allowMessage = (_HU_ShowMessagesEnabled() or message_dontfuckwithme) and((not message_nottobefuckedwith) or message_dontfuckwithme)
  if allowMessage then
    msg = _HU_PopCurrentPlayerMessage()
    if msg is not void then
      HUlib_addMessageToSText(w_message, 0, msg)
      _HU_SetMessageOn(true)
      message_counter = HU_MSGTIMEOUT
      message_nottobefuckedwith = message_dontfuckwithme
      message_dontfuckwithme = false
    end if
  end if

  if _HU_MPUsePacketChat() and typeof(MP_PlatformPollChatLine) == "function" then
    loops = 0
    while loops < 8
      line = MP_PlatformPollChatLine()
      if typeof(line) != "string" or line == "" then break end if
      HU_NetAddMessage(line)
      loops = loops + 1
    end while
  end if

end function

/*
* Function: ForeignTranslation
* Purpose: Implements the ForeignTranslation routine for the engine module behavior.
*/
function ForeignTranslation(ch)
  if language != Language_t.french then return ch end if
  if typeof(ch) != "int" then return ch end if
  if ch < 0 or ch >= 128 then return ch end if
  if len(frenchKeyMap) != 128 then return ch end if
  return frenchKeyMap[ch]
end function

/*
* Function: HU_Responder
* Purpose: Implements the HU_Responder routine for the HUD subsystem.
*/
function HU_Responder(ev)
  global shiftdown
  global altdown
  global num_nobrainers
  global _hu_lastmessage
  global _hu_local_chat_dest

  if ev is void then return false end if

  key = _HU_ToInt(ev.data1, 0)
  if key == KEY_RSHIFT then
    shiftdown = ev.type == evtype_t.ev_keydown
    return false
  end if
  if key == KEY_RALT or key == KEY_LALT then
    altdown = ev.type == evtype_t.ev_keydown
    return false
  end if

  if ev.type != evtype_t.ev_keydown then return false end if

  numplayers = 0
  i = 0
  while i < MAXPLAYERS
    if i < len(playeringame) and playeringame[i] then numplayers = numplayers + 1 end if
    i = i + 1
  end while

  eatkey = false
  if not chat_on then
    if key == HU_MSGREFRESH then
      _HU_SetMessageOn(true)
      message_counter = HU_MSGTIMEOUT
      eatkey = true
    else if netgame and key == HU_INPUTTOGGLE then
      eatkey = true
      _HU_SetChatOn(true)
      HUlib_resetIText(w_chat)
      _hu_local_chat_dest = HU_BROADCAST
    else if netgame and numplayers > 2 then
      i = 0
      while i < MAXPLAYERS
        if i < len(destination_keys) and key == destination_keys[i] then
          if i < len(playeringame) and playeringame[i] and i != consoleplayer then
            eatkey = true
            _HU_SetChatOn(true)
            HUlib_resetIText(w_chat)
            _hu_local_chat_dest = i + 1
            break
          else if i == consoleplayer then
            num_nobrainers = num_nobrainers + 1
            if plr is not void then
              if num_nobrainers < 3 then
                plr.message = HUSTR_TALKTOSELF1
              else if num_nobrainers < 6 then
                plr.message = HUSTR_TALKTOSELF2
              else if num_nobrainers < 9 then
                plr.message = HUSTR_TALKTOSELF3
              else if num_nobrainers < 32 then
                plr.message = HUSTR_TALKTOSELF4
              else
                plr.message = HUSTR_TALKTOSELF5
              end if
            end if
          end if
        end if
        i = i + 1
      end while
    end if
  else
    c = key
    if altdown then
      c = c - 48
      if c < 0 or c > 9 then return false end if
      macromessage = chat_macros[c]

      _HU_MPSendChatMessage(_hu_local_chat_dest, macromessage)

      _HU_SetChatOn(false)
      _hu_lastmessage = macromessage
      eatkey = true
    else
      if language == Language_t.french then c = ForeignTranslation(c) end if
      if shiftdown or(c >= 97 and c <= 122) then c = _HU_ShiftChar(c) end if

      eatkey = HUlib_keyInIText(w_chat, c)

      if c == KEY_ENTER then
        _HU_SetChatOn(false)
        if _HU_ToInt(w_chat.l.len, 0) > 0 then
          _hu_lastmessage = _HU_ITextString(w_chat)
          _HU_MPSendChatMessage(_hu_local_chat_dest, _hu_lastmessage)
        end if
      else if c == KEY_ESCAPE then
        _HU_SetChatOn(false)
      end if
    end if
  end if

  return eatkey
end function



