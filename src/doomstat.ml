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

//! Owns the mutable session, map, player, renderer, demo, and command-line state shared by the Doom runtime.

import doomdata
import d_net
import d_player

/// Defines the maximum max dm starts accepted by the doomstat subsystem.
const MAX_DM_STARTS = 10

/// Exposes `GameMode_t.indetermined` through the legacy `gamemode` alias.
gamemode = GameMode_t.indetermined

/// Exposes `GameMission_t.doom` through the legacy `gamemission` alias.
gamemission = GameMission_t.doom

/// Exposes `Language_t.english` through the legacy `language` alias.
language = Language_t.english

/// Tracks whether modifiedgame is active in the doomstat subsystem.
modifiedgame = false

/// Tracks whether nomonsters is active in the doomstat subsystem.
nomonsters = false
/// Tracks whether respawnparm is active in the doomstat subsystem.
respawnparm = false
/// Tracks whether fastparm is active in the doomstat subsystem.
fastparm = false
/// Tracks whether devparm is active in the doomstat subsystem.
devparm = false

/// Tracks whether netgame is active in the doomstat subsystem.
netgame = false
/// Tracks whether deathmatch is active in the doomstat subsystem.
deathmatch = false

/// Tracks whether menuactive is active in the doomstat subsystem.
menuactive = false
/// Tracks whether paused is active in the doomstat subsystem.
paused = false
// Console utility toggles are session state rather than renderer or parser state.
/// Tracks whether consolefreeze is active in the doomstat subsystem.
consolefreeze = false
/// Tracks whether console show fps is active in the doomstat subsystem.
console_show_fps = false
/// Tracks whether usergame is active in the doomstat subsystem.
usergame = true
/// Tracks whether demoplayback is active in the doomstat subsystem.
demoplayback = false
/// Tracks whether demorecording is active in the doomstat subsystem.
demorecording = false
/// Tracks whether singledemo is active in the doomstat subsystem.
singledemo = false

/// Tracks the mutable consoleplayer value used by the doomstat subsystem.
consoleplayer = 0
/// Tracks the mutable displayplayer value used by the doomstat subsystem.
displayplayer = 0

/// Stores the players collection used by the doomstat subsystem.
players =[
Player_MakeDefault(),
Player_MakeDefault(),
Player_MakeDefault(),
Player_MakeDefault()
]
/// Stores the playeringame collection used by the doomstat subsystem.
playeringame =[false, false, false, false]

/// Exposes `skill_t.sk_medium` through the legacy `startskill` alias.
startskill = skill_t.sk_medium
/// Tracks the mutable startepisode value used by the doomstat subsystem.
startepisode = 1
/// Tracks the mutable startmap value used by the doomstat subsystem.
startmap = 1
/// Tracks whether autostart is active in the doomstat subsystem.
autostart = false

/// Exposes `skill_t.sk_medium` through the legacy `gameskill` alias.
gameskill = skill_t.sk_medium
/// Tracks the mutable gameepisode value used by the doomstat subsystem.
gameepisode = 1
/// Tracks the mutable gamemap value used by the doomstat subsystem.
gamemap = 1

/// Tracks whether respawnmonsters is active in the doomstat subsystem.
respawnmonsters = false

/// Tracks the mutable snd sfx volume value used by the doomstat subsystem.
snd_SfxVolume = 8
/// Tracks the mutable snd music volume value used by the doomstat subsystem.
snd_MusicVolume = 8
/// Tracks the mutable snd music device value used by the doomstat subsystem.
snd_MusicDevice = 0
/// Tracks the mutable snd sfx device value used by the doomstat subsystem.
snd_SfxDevice = 0
/// Tracks the mutable snd desired music device value used by the doomstat subsystem.
snd_DesiredMusicDevice = 0
/// Tracks the mutable snd desired sfx device value used by the doomstat subsystem.
snd_DesiredSfxDevice = 0

/// Tracks whether statusbaractive is active in the doomstat subsystem.
statusbaractive = true
/// Tracks whether automapactive is active in the doomstat subsystem.
automapactive = false
/// Tracks whether viewactive is active in the doomstat subsystem.
viewactive = true
/// Tracks whether nodrawers is active in the doomstat subsystem.
nodrawers = false
/// Tracks whether noblit is active in the doomstat subsystem.
noblit = false

/// Exposes `gamestate_t.GS_DEMOSCREEN` through the legacy `gamestate` alias.
gamestate = gamestate_t.GS_DEMOSCREEN
/// Tracks the mutable gametic value used by the doomstat subsystem.
gametic = 0
/// Exposes `gamestate_t.GS_DEMOSCREEN` through the legacy `wipegamestate` alias.
wipegamestate = gamestate_t.GS_DEMOSCREEN

/// Stores the mutable basedefault text used by the doomstat subsystem.
basedefault = "default.cfg"

/// Tracks whether precache is active in the doomstat subsystem.
precache = true
/// Tracks the mutable mouse sensitivity value used by the doomstat subsystem.
mouseSensitivity = 5
/// Tracks whether singletics is active in the doomstat subsystem.
singletics = false
/// Tracks whether uncapped render is active in the doomstat subsystem.
uncapped_render = true
/// Tracks the mutable render lerp frac value used by the doomstat subsystem.
render_lerp_frac = 1.0
/// Tracks whether interp view is active in the doomstat subsystem.
interp_view = true
/// Tracks the mutable bodyqueslot value used by the doomstat subsystem.
bodyqueslot = 0
/// Tracks the mutable totalkills value used by the doomstat subsystem.
totalkills = 0
/// Tracks the mutable totalitems value used by the doomstat subsystem.
totalitems = 0
/// Tracks the mutable totalsecret value used by the doomstat subsystem.
totalsecret = 0

/// Holds the optional wminfo resource used by the doomstat subsystem.
wminfo = void

/// Stores the deathmatchstarts collection used by the doomstat subsystem.
deathmatchstarts =[]
/// Holds the optional deathmatch p resource used by the doomstat subsystem.
deathmatch_p = void
/// Stores the playerstarts collection used by the doomstat subsystem.
playerstarts =[]

/// Stores the maxammo collection used by the doomstat subsystem.
maxammo =[]



