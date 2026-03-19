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

  Script: doomstat.ml
  Purpose: Contains Doom engine module logic for this subsystem.
*/
import doomdata
import d_net
import d_player

const MAX_DM_STARTS = 10

gamemode = GameMode_t.indetermined

gamemission = GameMission_t.doom

language = Language_t.english

modifiedgame = false

nomonsters = false
respawnparm = false
fastparm = false
devparm = false

netgame = false
deathmatch = false

menuactive = false
paused = false
usergame = true
demoplayback = false
demorecording = false
singledemo = false

consoleplayer = 0
displayplayer = 0

players =[
Player_MakeDefault(),
Player_MakeDefault(),
Player_MakeDefault(),
Player_MakeDefault()
]
playeringame =[false, false, false, false]

startskill = skill_t.sk_medium
startepisode = 1
startmap = 1
autostart = false

gameskill = skill_t.sk_medium
gameepisode = 1
gamemap = 1

respawnmonsters = false

snd_SfxVolume = 8
snd_MusicVolume = 8
snd_MusicDevice = 0
snd_SfxDevice = 0
snd_DesiredMusicDevice = 0
snd_DesiredSfxDevice = 0

statusbaractive = true
automapactive = false
viewactive = true
nodrawers = false
noblit = false

gamestate = gamestate_t.GS_DEMOSCREEN
gametic = 0
wipegamestate = gamestate_t.GS_DEMOSCREEN

basedefault = "default.cfg"

precache = true
mouseSensitivity = 5
singletics = false
uncapped_render = true
render_lerp_frac = 1.0
interp_view = true
bodyqueslot = 0
totalkills = 0
totalitems = 0
totalsecret = 0

wminfo = void

deathmatchstarts =[]
deathmatch_p = void
playerstarts =[]

maxammo =[]



