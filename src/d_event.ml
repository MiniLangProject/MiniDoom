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

  Script: d_event.ml
  Purpose: Defines normalized input events, queued game actions, and button-bit constants shared by responders and the game loop.
*/
import doomtype

/*
* Enum: evtype_t
* Purpose: Distinguishes keyboard, mouse, joystick, and quit events as they pass through the responder chain.
*/
enum evtype_t
  ev_keydown
  ev_keyup
  ev_mouse
  ev_joystick
end enum

/*
* Struct: event_t
* Purpose: Carries one normalized input event and its three device-specific payload values through the responder chain.
*/
struct event_t
  type
  data1
  data2
  data3
end struct

/*
* Enum: gameaction_t
* Purpose: Identifies deferred high-level transitions such as loading levels, saving games, screenshots, and demo playback.
*/
enum gameaction_t
  ga_nothing
  ga_loadlevel
  ga_newgame
  ga_loadgame
  ga_savegame
  ga_playdemo
  ga_completed
  ga_victory
  ga_worlddone
  ga_screenshot
end enum

/*
* Enum: buttoncode_t
* Purpose: Assigns tic-command button bits and encodings, including weapon changes, special commands, pause, and save slots.
*/
enum buttoncode_t
  BT_ATTACK = 1
  BT_USE = 2

  BT_SPECIAL = 128
  BT_SPECIALMASK = 3

  BT_CHANGE = 4
  BT_WEAPONMASK = 8 + 16 + 32
  BT_WEAPONSHIFT = 3

  BTS_PAUSE = 1
  BTS_SAVEGAME = 2

  BTS_SAVEMASK = 4 + 8 + 16
  BTS_SAVESHIFT = 2
end enum

const MAXEVENTS = 64



