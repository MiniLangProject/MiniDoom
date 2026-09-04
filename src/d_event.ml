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

//! Defines normalized input events, queued game actions, and button-bit constants shared by responders and the
//! game loop.

import doomtype

/// Distinguishes keyboard, mouse, joystick, and quit events as they pass through the responder chain.
enum evtype_t
  /// Represents ev keydown in `evtype_t`
  ev_keydown
  /// Represents ev keyup in `evtype_t`
  ev_keyup
  /// Represents ev mouse in `evtype_t`
  ev_mouse
  /// Represents ev joystick in `evtype_t`
  ev_joystick
end enum

/// Carries one normalized input event and its three device-specific payload values through the responder chain.
struct event_t
  /// Kind discriminator for this record stored by `event_t`
  type
  /// Stores data1 for `event_t`
  data1
  /// Stores data2 for `event_t`
  data2
  /// Stores data3 for `event_t`
  data3
end struct

/// Identifies deferred high-level transitions such as loading levels, saving games, screenshots, and demo
/// playback.
enum gameaction_t
  /// Represents ga nothing in `gameaction_t`
  ga_nothing
  /// Represents ga loadlevel in `gameaction_t`
  ga_loadlevel
  /// Represents ga newgame in `gameaction_t`
  ga_newgame
  /// Represents ga loadgame in `gameaction_t`
  ga_loadgame
  /// Represents ga savegame in `gameaction_t`
  ga_savegame
  /// Represents ga playdemo in `gameaction_t`
  ga_playdemo
  /// Represents ga completed in `gameaction_t`
  ga_completed
  /// Represents ga victory in `gameaction_t`
  ga_victory
  /// Represents ga worlddone in `gameaction_t`
  ga_worlddone
  /// Represents ga screenshot in `gameaction_t`
  ga_screenshot
end enum

/// Assigns tic-command button bits and encodings, including weapon changes, special commands, pause, and save
/// slots.
enum buttoncode_t
  /// Represents bt attack in `buttoncode_t`
  BT_ATTACK = 1
  /// Represents bt use in `buttoncode_t`
  BT_USE = 2

  /// Represents bt special in `buttoncode_t`
  BT_SPECIAL = 128
  /// Represents bt specialmask in `buttoncode_t`
  BT_SPECIALMASK = 3

  /// Represents bt change in `buttoncode_t`
  BT_CHANGE = 4
  /// Represents bt weaponmask in `buttoncode_t`
  BT_WEAPONMASK = 8 + 16 + 32
  /// Represents bt weaponshift in `buttoncode_t`
  BT_WEAPONSHIFT = 3

  /// Represents bts pause in `buttoncode_t`
  BTS_PAUSE = 1
  /// Represents bts savegame in `buttoncode_t`
  BTS_SAVEGAME = 2

  /// Represents bts savemask in `buttoncode_t`
  BTS_SAVEMASK = 4 + 8 + 16
  /// Represents bts saveshift in `buttoncode_t`
  BTS_SAVESHIFT = 2
end enum

/// Defines the maximum maxevents accepted by the d event subsystem.
const MAXEVENTS = 64



