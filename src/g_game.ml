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

  Script: g_game.ml
  Purpose: Implements high-level game loop control, transitions, and session state.
*/
import doomdef
import d_event
import doomdef
import doomstat
import z_zone
import f_finale
import m_argv
import m_misc
import m_menu
import m_random
import i_system
import i_video
import p_setup
import p_saveg
import p_tick
import d_main
import wi_stuff
import hu_stuff
import st_stuff
import am_map
import v_video
import w_wad
import p_local
import s_sound
import dstrings
import sounds
import r_data
import r_sky
import g_game
import std.math

/*
* Function: G_DeathMatchSpawnPlayer
* Purpose: Creates and initializes runtime objects for the game flow.
*/
function G_DeathMatchSpawnPlayer(playernum)
  if typeof(playernum) != "int" then return end if
  if playernum < 0 or playernum >= MAXPLAYERS then return end if

  startCount = 0
  if typeof(deathmatch_p) == "int" then
    startCount = deathmatch_p
  else if typeof(deathmatchstarts) == "array" then
    startCount = len(deathmatchstarts)
  end if

  if startCount < 4 then
    I_Error("Only " + startCount + " deathmatch spots, 4 required")
    return
  end if

  selections = 20
  while selections > 0
    i = 0
    if startCount > 0 then
      i = P_Random() % startCount
    end if

    mthing = void
    if typeof(deathmatchstarts) == "array" and i >= 0 and i < len(deathmatchstarts) then
      mthing = deathmatchstarts[i]
    end if

    if mthing is not void and G_CheckSpot(playernum, mthing) then
      if typeof(players) == "array" and playernum < len(players) and typeof(players[playernum]) == "struct" and players[playernum].mo is not void then
        P_RemoveMobj(players[playernum].mo)
      end if

      spawn = mapthing_t(mthing.x, mthing.y, mthing.angle, playernum + 1, mthing.options)
      if typeof(P_SpawnPlayer) == "function" then P_SpawnPlayer(spawn) end if
      return
    end if

    selections = selections - 1
  end while

  if typeof(P_SpawnPlayer) == "function" and typeof(playerstarts) == "array" and playernum < len(playerstarts) then
    P_SpawnPlayer(playerstarts[playernum])
  end if
end function

/*
* Function: G_InitNew
* Purpose: Initializes state and dependencies for the game flow.
*/
function G_InitNew(skill, episode, map)
  global gameskill
  global gameepisode
  global gamemap
  global gamestate
  global usergame
  global paused
  global demoplayback
  global automapactive
  global viewactive

  gameskill = skill
  gameepisode = episode
  gamemap = map

  if typeof(playeringame) == "array" and len(playeringame) > 0 then
    playeringame[0] = true
  end if

  if typeof(players) == "array" then
    i = 0
    while i < MAXPLAYERS and i < len(players)
      if typeof(players[i]) != "struct" then
        players[i] = Player_MakeDefault()
      end if
      players[i].playerstate = playerstate_t.PST_REBORN
      i = i + 1
    end while
  end if

  // Match Doom startup semantics when a new level session begins.
  usergame = true
  paused = false
  demoplayback = false
  automapactive = false
  viewactive = true

  _G_ShowLoadingFrame("Loading E" + episode + "M" + map + "...")

  if typeof(P_SetupLevel) == "function" then
    P_SetupLevel(episode, map, 1, skill)
  end if
  if typeof(I_SetLoadingStatus) == "function" then I_SetLoadingStatus("") end if

  gamestate = gamestate_t.GS_LEVEL
end function

/*
* Function: G_DeferedInitNew
* Purpose: Initializes state and dependencies for the game flow.
*/
function G_DeferedInitNew(skill, episode, map)
  global _G_defSkill
  global _G_defEpisode
  global _G_defMap
  global gameaction

  _G_defSkill = skill
  _G_defEpisode = episode
  _G_defMap = map
  gameaction = gameaction_t.ga_newgame
end function

/*
* Function: G_DeferedPlayDemo
* Purpose: Implements the G_DeferedPlayDemo routine for the game flow.
*/
function G_DeferedPlayDemo(demo)
  global _G_defDemo
  global gameaction

  _G_defDemo = demo
  gameaction = gameaction_t.ga_playdemo
end function

/*
* Function: G_LoadGame
* Purpose: Loads and prepares data required by the game flow.
*/
function G_LoadGame(name)
  global _G_loadName
  global gameaction

  _G_loadName = name
  gameaction = gameaction_t.ga_loadgame
end function

const VERSIONSIZE = 16

_G_pars =[
[0],
[0, 30, 75, 120, 90, 165, 180, 180, 30, 165],
[0, 90, 90, 90, 120, 90, 360, 240, 30, 170],
[0, 90, 45, 90, 150, 90, 90, 165, 30, 135]
]

_G_cpars =[
30, 90, 120, 120, 90, 150, 120, 120, 270, 90,
210, 150, 150, 150, 210, 150, 420, 150, 210, 150,
240, 150, 180, 150, 150, 300, 330, 420, 300, 180,
120, 30
]

/*
* Function: _G_ParTimeTics
* Purpose: Implements the _G_ParTimeTics routine for the internal module support.
*/
function _G_ParTimeTics(episode, map)
  if typeof(map) != "int" then return 0 end if

  if gamemode == GameMode_t.commercial then
    idx = map - 1
    if idx >= 0 and idx < len(_G_cpars) then
      return 35 * _G_cpars[idx]
    end if
    return 0
  end if

  if typeof(episode) == "int" and episode >= 0 and episode < len(_G_pars) then
    row = _G_pars[episode]
    if (typeof(row) == "array" or typeof(row) == "list") and map >= 0 and map < len(row) then
      return 35 * row[map]
    end if
  end if

  return 0
end function

/*
* Function: _G_CopyFrags
* Purpose: Implements the _G_CopyFrags routine for the internal module support.
*/
function _G_CopyFrags(fr)
  arr =[0, 0, 0, 0]
  if typeof(fr) != "array" and typeof(fr) != "list" then return arr end if
  i = 0
  while i < MAXPLAYERS and i < len(arr) and i < len(fr)
    if typeof(fr[i]) == "int" then arr[i] = fr[i] end if
    i = i + 1
  end while
  return arr
end function

/*
* Function: _G_SaveFileName
* Purpose: Implements the _G_SaveFileName routine for the internal module support.
*/
function _G_SaveFileName(slot)
  s = slot
  if typeof(s) != "int" then s = 0 end if
  if M_CheckParm("-cdrom") != 0 then
    return "c:\\doomdata\\" + SAVEGAMENAME + s + ".dsg"
  end if
  return SAVEGAMENAME + s + ".dsg"
end function

/*
* Function: G_DoLoadGame
* Purpose: Loads and prepares data required by the game flow.
*/
function G_DoLoadGame()
  global gameaction
  global gameskill
  global gameepisode
  global gamemap
  global leveltime
  global savebuffer
  global save_p

  holder =[void]
  length = M_ReadFile(_G_loadName, holder)
  if length <= 0 or holder[0] is void then
    gameaction = gameaction_t.ga_nothing
    return
  end if

  savebuffer = holder[0]
  save_p = 0
  _ = _PSV_ReadFixedString(SAVESTRINGSIZE)
  vcheck = _PSV_ReadFixedString(VERSIONSIZE)
  if vcheck !=("version " + VERSION) then
    gameaction = gameaction_t.ga_nothing
    return
  end if

  gameskill = _PSV_ReadU8()
  gameepisode = _PSV_ReadU8()
  gamemap = _PSV_ReadU8()
  for i = 0 to MAXPLAYERS - 1
    if typeof(playeringame) == "array" and i < len(playeringame) then
      playeringame[i] =(_PSV_ReadU8() != 0)
    else
      _ = _PSV_ReadU8()
    end if
  end for

  G_InitNew(gameskill, gameepisode, gamemap)

  a = _PSV_ReadU8()
  b = _PSV_ReadU8()
  c = _PSV_ReadU8()
  leveltime =(a << 16) +(b << 8) + c

  P_UnArchivePlayers()
  P_UnArchiveWorld()
  P_UnArchiveThinkers()
  P_UnArchiveSpecials()

  if _PSV_ReadU8() != 0x1d then
    I_Error("Bad savegame")
  end if

  if typeof(setsizeneeded) != "void" and setsizeneeded and typeof(R_ExecuteSetViewSize) == "function" then
    R_ExecuteSetViewSize()
  end if
  if typeof(R_FillBackScreen) == "function" then R_FillBackScreen() end if

  global gameaction

  if typeof(devparm) != "void" and devparm then
    print "G_DoLoadGame: " + _G_loadName
  end if
  gameaction = gameaction_t.ga_nothing
end function

/*
* Function: G_CmdChecksum
* Purpose: Evaluates conditions and returns a decision for the game flow.
*/
function G_CmdChecksum(cmd)
  if cmd is void then return 0 end if
  s = 0
  if typeof(cmd.forwardmove) == "int" then s = s + cmd.forwardmove end if
  if typeof(cmd.sidemove) == "int" then s = s + cmd.sidemove end if
  if typeof(cmd.angleturn) == "int" then s = s + cmd.angleturn end if
  if typeof(cmd.buttons) == "int" then s = s + cmd.buttons end if
  return s & 0xFFFF
end function

/*
* Function: G_InitPlayer
* Purpose: Initializes state and dependencies for the game flow.
*/
function G_InitPlayer(playernum)
  if typeof(players) != "array" then return end if
  if typeof(playernum) != "int" or playernum < 0 or playernum >= len(players) then return end if

  p = players[playernum]
  if p is void then return end if
  p.playerstate = playerstate_t.PST_LIVE
  if typeof(p.health) == "int" and p.health <= 0 then p.health = MAXHEALTH end if
  players[playernum] = p
end function

/*
* Function: G_PlayerFinishLevel
* Purpose: Implements the G_PlayerFinishLevel routine for the game flow.
*/
function G_PlayerFinishLevel(playernum)
  if typeof(players) != "array" then return end if
  if typeof(playernum) != "int" or playernum < 0 or playernum >= len(players) then return end if
  p = players[playernum]
  if typeof(p) != "struct" then return end if

  // Keep inventory/armor/weapons across levels, but guarantee playable health floor on next spawn.
  if typeof(p.health) != "int" then
    p.health = MAXHEALTH
  else if p.health < MAXHEALTH then
    p.health = MAXHEALTH
  end if
  p.playerstate = playerstate_t.PST_LIVE

  pw =[]
  i = 0
  while i < NUMPOWERS
    pw = pw +[0]
    i = i + 1
  end while
  p.powers = pw

  cd =[]
  i = 0
  while i < NUMCARDS
    cd = cd +[false]
    i = i + 1
  end while
  p.cards = cd
  p.mo = void
  players[playernum] = p
end function

/*
* Function: G_PlayerReborn
* Purpose: Implements the G_PlayerReborn routine for the game flow.
*/
function G_PlayerReborn(playernum)
  if typeof(players) != "array" then return end if
  if typeof(playernum) != "int" or playernum < 0 or playernum >= len(players) then return end if

  oldp = players[playernum]
  oldFrags =[]
  keepKills = 0
  keepItems = 0
  keepSecrets = 0
  if oldp is not void then
    if typeof(oldp.frags) == "array" or typeof(oldp.frags) == "list" then
      i = 0
      while i < len(oldp.frags)
        oldFrags = oldFrags +[oldp.frags[i]]
        i = i + 1
      end while
    end if
    if typeof(oldp.killcount) == "int" then keepKills = oldp.killcount end if
    if typeof(oldp.itemcount) == "int" then keepItems = oldp.itemcount end if
    if typeof(oldp.secretcount) == "int" then keepSecrets = oldp.secretcount end if
  end if

  p = Player_MakeDefault()
  p.usedown = true
  p.attackdown = true
  p.playerstate = playerstate_t.PST_LIVE
  p.health = MAXHEALTH
  p.readyweapon = weapontype_t.wp_pistol
  p.pendingweapon = weapontype_t.wp_pistol

  if typeof(p.weaponowned) != "array" and typeof(p.weaponowned) != "list" then
    p.weaponowned =[]
  end if
  i = 0
  while i < NUMWEAPONS
    if i < len(p.weaponowned) then
      p.weaponowned[i] = false
    else
      p.weaponowned = p.weaponowned +[false]
    end if
    i = i + 1
  end while
  wi_fist = 0
  wi_pistol = 1
  if wi_fist < len(p.weaponowned) then p.weaponowned[wi_fist] = true end if
  if wi_pistol < len(p.weaponowned) then p.weaponowned[wi_pistol] = true end if

  if typeof(p.ammo) != "array" and typeof(p.ammo) != "list" then p.ammo =[] end if
  if typeof(p.maxammo) != "array" and typeof(p.maxammo) != "list" then p.maxammo =[] end if
  i = 0
  while i < NUMAMMO
    if i < len(p.ammo) then
      p.ammo[i] = 0
    else
      p.ammo = p.ammo +[0]
    end if
    if i < len(p.maxammo) then
      p.maxammo[i] = 0
    else
      p.maxammo = p.maxammo +[0]
    end if
    i = i + 1
  end while

  ai_clip = 0
  if ai_clip < len(p.ammo) then p.ammo[ai_clip] = 50 end if

  defaults =[200, 50, 300, 50]
  i = 0
  while i < NUMAMMO and i < len(p.maxammo)
    mv = 0
    if typeof(maxammo) == "array" or typeof(maxammo) == "list" then
      if i < len(maxammo) and typeof(maxammo[i]) == "int" then mv = maxammo[i] end if
    end if
    if mv <= 0 and i < len(defaults) then mv = defaults[i] end if
    p.maxammo[i] = mv
    i = i + 1
  end while

  i = 0
  while i < len(oldFrags)
    if i < len(p.frags) then
      p.frags[i] = oldFrags[i]
    end if
    i = i + 1
  end while
  p.killcount = keepKills
  p.itemcount = keepItems
  p.secretcount = keepSecrets

  players[playernum] = p
end function

/*
* Function: G_CheckSpot
* Purpose: Evaluates conditions and returns a decision for the game flow.
*/
function G_CheckSpot(playernum, mthing)
  playernum = playernum
  mthing = mthing
  return true
end function

/*
* Function: G_DoLoadLevel
* Purpose: Loads and prepares data required by the game flow.
*/
function G_DoLoadLevel()
  global gamestate
  global gameaction

  _G_ShowLoadingFrame("Loading E" + gameepisode + "M" + gamemap + "...")

  if typeof(P_SetupLevel) == "function" then
    P_SetupLevel(gameepisode, gamemap, 0, gameskill)
  end if
  if typeof(I_SetLoadingStatus) == "function" then I_SetLoadingStatus("") end if
  gamestate = gamestate_t.GS_LEVEL
  gameaction = gameaction_t.ga_nothing
end function

/*
* Function: _G_ShowLoadingFrame
* Purpose: Loads and prepares data required by the internal module support.
*/
function _G_ShowLoadingFrame(text)
  if typeof(I_SetLoadingStatus) == "function" then
    I_SetLoadingStatus(text)
  end if

  if typeof(screens) == "array" and len(screens) > 0 and typeof(screens[0]) == "bytes" then
    if typeof(V_DrawPatch) == "function" and typeof(W_CheckNumForName) == "function" and typeof(W_CacheLumpName) == "function" and W_CheckNumForName("TITLEPIC") != -1 then
      V_DrawPatch(0, 0, 0, W_CacheLumpName("TITLEPIC", PU_CACHE))
    else
      fb = screens[0]
      i = 0
      while i < len(fb)
        fb[i] = 0
        i = i + 1
      end while
    end if
  end if

  if typeof(I_LoadingPulse) == "function" then
    I_LoadingPulse()
  else if typeof(I_FinishUpdate) == "function" then
    I_FinishUpdate()
  end if
end function

/*
* Function: G_DoReborn
* Purpose: Implements the G_DoReborn routine for the game flow.
*/
function G_DoReborn(playernum)
  global gameaction
  if not netgame then
    // Single-player death restarts the map from scratch.
    gameaction = gameaction_t.ga_loadlevel
    return
  end if

  if typeof(players) == "array" and playernum >= 0 and playernum < len(players) and typeof(players[playernum]) == "struct" and typeof(players[playernum].mo) == "struct" then
    players[playernum].mo.player = void
  end if

  if deathmatch then
    if typeof(G_DeathMatchSpawnPlayer) == "function" then
      G_DeathMatchSpawnPlayer(playernum)
    end if
    return
  end if

  if typeof(playerstarts) == "array" and playernum >= 0 and playernum < len(playerstarts) and playerstarts[playernum] is not void and typeof(G_CheckSpot) == "function" and G_CheckSpot(playernum, playerstarts[playernum]) then
    if typeof(P_SpawnPlayer) == "function" then
      P_SpawnPlayer(playerstarts[playernum])
    end if
    return
  end if

  i = 0
  while i < MAXPLAYERS
    if typeof(playerstarts) == "array" and i >= 0 and i < len(playerstarts) and playerstarts[i] is not void and typeof(G_CheckSpot) == "function" and G_CheckSpot(playernum, playerstarts[i]) then
      st = playerstarts[i]
      fake = mapthing_t(st.x, st.y, st.angle, playernum + 1, st.options)
      if typeof(P_SpawnPlayer) == "function" then
        P_SpawnPlayer(fake)
      end if
      return
    end if
    i = i + 1
  end while

  if typeof(playerstarts) == "array" and playernum >= 0 and playernum < len(playerstarts) and playerstarts[playernum] is not void and typeof(P_SpawnPlayer) == "function" then
    P_SpawnPlayer(playerstarts[playernum])
  end if
end function

/*
* Function: G_DoCompleted
* Purpose: Implements the G_DoCompleted routine for the game flow.
*/
function G_DoCompleted()
  global players
  global playeringame
  global consoleplayer
  global automapactive
  global gameaction
  global gamestate
  global viewactive
  global secretexit
  global wminfo

  gameaction = gameaction_t.ga_nothing

  i = 0
  while i < MAXPLAYERS
    if typeof(playeringame) == "array" and i < len(playeringame) and playeringame[i] then
      G_PlayerFinishLevel(i)
    end if
    i = i + 1
  end while

  if automapactive and typeof(AM_Stop) == "function" then AM_Stop() end if

  if gamemode != GameMode_t.commercial and gamemap == 8 then
    gameaction = gameaction_t.ga_victory
    return
  end if

  if gamemode != GameMode_t.commercial and gamemap == 9 then
    i = 0
    while i < MAXPLAYERS
      if typeof(players) == "array" and i < len(players) and typeof(players[i]) == "struct" then
        p = players[i]
        p.didsecret = true
        players[i] = p
      end if
      i = i + 1
    end while
  end if

  didsecret = false
  if typeof(players) == "array" and consoleplayer >= 0 and consoleplayer < len(players) and typeof(players[consoleplayer]) == "struct" then
    if typeof(players[consoleplayer].didsecret) == "bool" then
      didsecret = players[consoleplayer].didsecret
    else if players[consoleplayer].didsecret then
      didsecret = true
    end if
  end if

  next0 = gamemap
  if gamemode == GameMode_t.commercial then
    if secretexit then
      if gamemap == 15 then
        next0 = 30
      else if gamemap == 31 then
        next0 = 31
      end if
    else
      if gamemap == 31 or gamemap == 32 then
        next0 = 15
      else
        next0 = gamemap
      end if
    end if
  else
    if secretexit then
      next0 = 8
    else if gamemap == 9 then
      if gameepisode == 1 then
        next0 = 3
      else if gameepisode == 2 then
        next0 = 5
      else if gameepisode == 3 then
        next0 = 6
      else if gameepisode == 4 then
        next0 = 2
      end if
    else
      next0 = gamemap
    end if
  end if

  plyr =[]
  i = 0
  while i < MAXPLAYERS
    ingame = false
    if typeof(playeringame) == "array" and i < len(playeringame) then
      ingame = playeringame[i]
    end if

    skills = 0
    sitems = 0
    ssecret = 0
    stime = leveltime
    fr =[0, 0, 0, 0]
    if typeof(players) == "array" and i < len(players) and typeof(players[i]) == "struct" then
      if typeof(players[i].killcount) == "int" then skills = players[i].killcount end if
      if typeof(players[i].itemcount) == "int" then sitems = players[i].itemcount end if
      if typeof(players[i].secretcount) == "int" then ssecret = players[i].secretcount end if
      fr = _G_CopyFrags(players[i].frags)
    end if

    plyr = plyr +[wbplayerstruct_t(ingame, skills, sitems, ssecret, stime, fr, 0)]
    i = i + 1
  end while

  wminfo = wbstartstruct_t(
  gameepisode - 1,
  didsecret,
  gamemap - 1,
  next0,
  totalkills,
  totalitems,
  totalsecret,
  0,
  _G_ParTimeTics(gameepisode, gamemap),
  consoleplayer,
  plyr
)

  if typeof(WI_Start) == "function" then
    WI_Start(wminfo)
  end if
  gamestate = gamestate_t.GS_INTERMISSION
  viewactive = false
  automapactive = false
  gameaction = gameaction_t.ga_nothing
end function

/*
* Function: G_DoWorldDone
* Purpose: Implements the G_DoWorldDone routine for the game flow.
*/
function G_DoWorldDone()
  global gamemap
  global wminfo
  global gamestate
  global viewactive
  global secretexit
  global gameaction

  if wminfo is not void and typeof(wminfo.next) == "int" then
    gamemap = wminfo.next + 1
  else
    gamemap = gamemap + 1
  end if
  gameaction = gameaction_t.ga_nothing
  gamestate = gamestate_t.GS_LEVEL
  viewactive = true
  secretexit = false
  G_DoLoadLevel()
end function

/*
* Function: G_DoSaveGame
* Purpose: Implements the G_DoSaveGame routine for the game flow.
*/
function G_DoSaveGame()
  global gameaction
  global savebuffer
  global save_p

  name = _G_SaveFileName(_G_saveSlot)
  _PSave_EnsureBuffer(131072)

  desc = _G_saveDesc
  if typeof(desc) != "string" then desc = "" end if
  _PSV_WriteFixedString(desc, SAVESTRINGSIZE)
  _PSV_WriteFixedString("version " + VERSION, VERSIONSIZE)

  _PSV_WriteU8(gameskill)
  _PSV_WriteU8(gameepisode)
  _PSV_WriteU8(gamemap)
  for i = 0 to MAXPLAYERS - 1
    ingame = false
    if typeof(playeringame) == "array" and i < len(playeringame) then ingame = playeringame[i] end if
    if ingame then _PSV_WriteU8(1) else _PSV_WriteU8(0) end if
  end for
  _PSV_WriteU8((leveltime >> 16) & 255)
  _PSV_WriteU8((leveltime >> 8) & 255)
  _PSV_WriteU8(leveltime & 255)

  P_ArchivePlayers()
  P_ArchiveWorld()
  P_ArchiveThinkers()
  P_ArchiveSpecials()
  _PSV_WriteU8(0x1d)

  length = save_p
  ok = M_WriteFile(name, savebuffer, length)
  if ok and typeof(players) == "array" and consoleplayer >= 0 and consoleplayer < len(players) and typeof(players[consoleplayer]) == "struct" then
    cp = players[consoleplayer]
    if typeof(GGSAVED) == "string" then
      cp.message = GGSAVED
    else
      cp.message = "game saved."
    end if
    players[consoleplayer] = cp
  end if
  global _G_saveDesc
  _G_saveDesc = ""

  if typeof(devparm) != "void" and devparm then
    print "SaveGame slot=" + _G_saveSlot + " desc=" + desc + " file=" + name + " bytes=" + length
  end if
  if typeof(R_FillBackScreen) == "function" then R_FillBackScreen() end if
  gameaction = gameaction_t.ga_nothing
end function

/*
* Function: G_DoNewGame
* Purpose: Implements the G_DoNewGame routine for the game flow.
*/
function G_DoNewGame()
  global gameaction
  G_InitNew(_G_defSkill, _G_defEpisode, _G_defMap)
  gameaction = gameaction_t.ga_nothing
end function

/*
* Function: G_DoPlayDemo
* Purpose: Implements the G_DoPlayDemo routine for the game flow.
*/
function G_DoPlayDemo()
  global gameaction
  global demobuffer
  global _G_demo_p
  global demoplayback
  global netdemo
  global netgame
  global deathmatch
  global respawnparm
  global fastparm
  global nomonsters
  global consoleplayer
  global usergame
  global precache

  gameaction = gameaction_t.ga_nothing

  if typeof(_G_defDemo) != "string" or _G_defDemo == "" then
    return
  end if

  lump = W_CheckNumForName(_G_defDemo)
  if lump < 0 then
    return
  end if

  demobuffer = W_CacheLumpName(_G_defDemo, PU_STATIC)
  _G_demo_p = 0
  if typeof(demobuffer) != "bytes" or len(demobuffer) < 1 then
    return
  end if

  if _G_DemoReadU8() != VERSION then
    print "Demo is from a different game version: " + _G_defDemo
    return
  end if

  skill = _G_DemoReadU8()
  episode = _G_DemoReadU8()
  map = _G_DemoReadU8()
  deathmatch =(_G_DemoReadU8() != 0)
  respawnparm =(_G_DemoReadU8() != 0)
  fastparm =(_G_DemoReadU8() != 0)
  nomonsters =(_G_DemoReadU8() != 0)
  consoleplayer = _G_DemoReadU8()
  if consoleplayer < 0 or consoleplayer >= MAXPLAYERS then consoleplayer = 0 end if

  for i = 0 to MAXPLAYERS - 1
    b = _G_DemoReadU8()
    if typeof(playeringame) == "array" and i < len(playeringame) then
      playeringame[i] =(b != 0)
    end if
  end for

  if typeof(playeringame) == "array" and len(playeringame) > 1 and playeringame[1] then
    netgame = true
    netdemo = true
  else
    netgame = false
    netdemo = false
  end if

  precacheOld = precache
  precache = false
  G_InitNew(skill, episode, map)
  precache = precacheOld

  usergame = false
  demoplayback = true
  gameaction = gameaction_t.ga_nothing
end function

/*
* Function: G_SaveGame
* Purpose: Implements the G_SaveGame routine for the game flow.
*/
function G_SaveGame(slot, description)
  global _G_saveSlot
  global _G_saveDesc
  global gameaction

  _G_saveSlot = slot
  _G_saveDesc = description
  gameaction = gameaction_t.ga_savegame
end function

/*
* Function: _G_DemoReadU8
* Purpose: Implements the _G_DemoReadU8 routine for the internal module support.
*/
function _G_DemoReadU8()
  if typeof(demobuffer) != "bytes" or _G_demo_p < 0 or _G_demo_p >= len(demobuffer) then
    global _G_demo_p
    _G_demo_p = _G_demo_p + 1
    return 0
  end if
  b = demobuffer[_G_demo_p]
  _G_demo_p = _G_demo_p + 1
  return b
end function

/*
* Function: _G_DemoWriteU8
* Purpose: Implements the _G_DemoWriteU8 routine for the internal module support.
*/
function _G_DemoWriteU8(v)
  if typeof(demobuffer) != "bytes" then return end if
  if _G_demo_p < 0 or _G_demo_p >= len(demobuffer) then return end if
  b = v
  if b < 0 then
    b = b % 256
    if b < 0 then b = b + 256 end if
  end if
  demobuffer[_G_demo_p] = b & 255
  global _G_demo_p
  _G_demo_p = _G_demo_p + 1
end function

/*
* Function: G_ReadDemoTiccmd
* Purpose: Implements the G_ReadDemoTiccmd routine for the game flow.
*/
function G_ReadDemoTiccmd(cmd)
  if cmd is void then return end if
  if typeof(demobuffer) != "bytes" or len(demobuffer) == 0 then return end if
  if _G_demo_p >= len(demobuffer) then
    G_CheckDemoStatus()
    return
  end if

  if demobuffer[_G_demo_p] == DEMOMARKER then
    G_CheckDemoStatus()
    return
  end if

  fwd = _G_DemoReadU8()
  side = _G_DemoReadU8()
  if fwd >= 128 then fwd = fwd - 256 end if
  if side >= 128 then side = side - 256 end if

  cmd.forwardmove = fwd
  cmd.sidemove = side
  cmd.angleturn = _G_DemoReadU8() << 8
  cmd.buttons = _G_DemoReadU8()
end function

/*
* Function: G_WriteDemoTiccmd
* Purpose: Implements the G_WriteDemoTiccmd routine for the game flow.
*/
function G_WriteDemoTiccmd(cmd)
  if cmd is void then return end if
  if not demorecording then return end if

  if _G_KeyIsDown(113) then
    G_CheckDemoStatus()
    return
  end if

  if _G_demo_p > _G_demoend - 16 then
    G_CheckDemoStatus()
    return
  end if

  _G_DemoWriteU8(cmd.forwardmove)
  _G_DemoWriteU8(cmd.sidemove)
  _G_DemoWriteU8((cmd.angleturn + 128) >> 8)
  _G_DemoWriteU8(cmd.buttons)
end function

/*
* Function: G_RecordDemo
* Purpose: Implements the G_RecordDemo routine for the game flow.
*/
function G_RecordDemo(name)
  global usergame
  global demoname
  global demobuffer
  global _G_demoend
  global _G_demo_p
  global demorecording

  if typeof(name) != "string" then return end if

  usergame = false
  demoname = name + ".lmp"

  maxsize = 0x20000
  parm = M_CheckParm("-maxdemo")
  if parm != 0 and typeof(myargv) == "array" and parm + 1 < len(myargv) then
    n = toNumber(myargv[parm + 1])
    if typeof(n) == "int" and n > 0 then
      maxsize = n * 1024
    end if
  end if

  demobuffer = bytes(maxsize, 0)
  _G_demo_p = 0
  _G_demoend = maxsize
  demorecording = true
end function

/*
* Function: G_BeginRecording
* Purpose: Implements the G_BeginRecording routine for the game flow.
*/
function G_BeginRecording()
  if typeof(demobuffer) != "bytes" or len(demobuffer) == 0 then
    global demobuffer
    demobuffer = bytes(0x20000, 0)
    global _G_demoend
    _G_demoend = len(demobuffer)
  end if

  global _G_demo_p
  _G_demo_p = 0
  _G_DemoWriteU8(VERSION)
  _G_DemoWriteU8(gameskill)
  _G_DemoWriteU8(gameepisode)
  _G_DemoWriteU8(gamemap)
  if deathmatch then _G_DemoWriteU8(1) else _G_DemoWriteU8(0) end if
  if respawnparm then _G_DemoWriteU8(1) else _G_DemoWriteU8(0) end if
  if fastparm then _G_DemoWriteU8(1) else _G_DemoWriteU8(0) end if
  if nomonsters then _G_DemoWriteU8(1) else _G_DemoWriteU8(0) end if
  _G_DemoWriteU8(consoleplayer)
  for i = 0 to MAXPLAYERS - 1
    ingame = false
    if typeof(playeringame) == "array" and i < len(playeringame) then ingame = playeringame[i] end if
    if ingame then _G_DemoWriteU8(1) else _G_DemoWriteU8(0) end if
  end for
end function

/*
* Function: G_PlayDemo
* Purpose: Implements the G_PlayDemo routine for the game flow.
*/
function G_PlayDemo(name)
  global demoplayback
  global _G_defDemo
  global gameaction

  demoplayback = true
  _G_defDemo = name
  gameaction = gameaction_t.ga_playdemo
end function

/*
* Function: G_TimeDemo
* Purpose: Implements the G_TimeDemo routine for the game flow.
*/
function G_TimeDemo(name)
  global nodrawers
  global noblit
  global timingdemo
  global singletics
  global _G_defDemo
  global gameaction

  nodrawers =(M_CheckParm("-nodraw") != 0)
  noblit =(M_CheckParm("-noblit") != 0)
  timingdemo = true
  singletics = true
  _G_defDemo = name
  gameaction = gameaction_t.ga_playdemo
end function

/*
* Function: G_CheckDemoStatus
* Purpose: Evaluates conditions and returns a decision for the game flow.
*/
function G_CheckDemoStatus()
  global demorecording
  global demoplayback

  demorecording = false
  demoplayback = false
  return true
end function

/*
* Function: G_ExitLevel
* Purpose: Implements the G_ExitLevel routine for the game flow.
*/
function G_ExitLevel()
  global gameaction
  global secretexit

  secretexit = false
  gameaction = gameaction_t.ga_completed
end function

/*
* Function: G_SecretExitLevel
* Purpose: Implements the G_SecretExitLevel routine for the game flow.
*/
function G_SecretExitLevel()
  global gameaction
  global secretexit

  if gamemode == GameMode_t.commercial and typeof(W_CheckNumForName) == "function" and W_CheckNumForName("map31") < 0 then
    secretexit = false
  else
    secretexit = true
  end if
  gameaction = gameaction_t.ga_completed
end function

/*
* Function: G_WorldDone
* Purpose: Implements the G_WorldDone routine for the game flow.
*/
function G_WorldDone()
  global players
  global consoleplayer
  global secretexit
  global gameaction

  if secretexit and typeof(players) == "array" and consoleplayer >= 0 and consoleplayer < len(players) and typeof(players[consoleplayer]) == "struct" then
    cp = players[consoleplayer]
    cp.didsecret = true
    players[consoleplayer] = cp
  end if

  gameaction = gameaction_t.ga_worlddone
  if gamemode == GameMode_t.commercial then
    if gamemap == 6 or gamemap == 11 or gamemap == 20 or gamemap == 30 or(secretexit and(gamemap == 15 or gamemap == 31)) then
      if typeof(F_StartFinale) == "function" then F_StartFinale() end if
    end if
  end if
end function

/*
* Function: G_ProcessPendingGameAction
* Purpose: Executes deferred game actions without advancing world simulation.
*/
function G_ProcessPendingGameAction()
  global gameaction

  if typeof(gameaction) == "void" then
    gameaction = gameaction_t.ga_nothing
  end if

  if gameaction != gameaction_t.ga_nothing then
    if gameaction == gameaction_t.ga_newgame then
      G_DoNewGame()
    else if gameaction == gameaction_t.ga_loadgame then
      G_DoLoadGame()
    else if gameaction == gameaction_t.ga_savegame then
      G_DoSaveGame()
    else if gameaction == gameaction_t.ga_playdemo then
      G_DoPlayDemo()
    else if gameaction == gameaction_t.ga_completed then
      G_DoCompleted()
    else if gameaction == gameaction_t.ga_worlddone then
      G_DoWorldDone()
    else if gameaction == gameaction_t.ga_victory then
      if typeof(F_StartFinale) == "function" then F_StartFinale() end if
    else if gameaction == gameaction_t.ga_screenshot then
      if typeof(M_ScreenShot) == "function" then M_ScreenShot() end if
    else

    end if

    gameaction = gameaction_t.ga_nothing
  end if
end function

/*
* Function: G_ProcessGameActionOnly
* Purpose: Processes deferred game actions while skipping gameplay tick simulation.
*/
function G_ProcessGameActionOnly()
  G_ProcessPendingGameAction()
end function

/*
* Function: G_Ticker
* Purpose: Advances per-tick logic for the game flow.
*/
function G_Ticker()
  global demoplayback
  global gamestate

  G_ProcessPendingGameAction()

  // Netgame respawns are driven by playerstate transition set in P_DeathThink.
  if netgame and typeof(playeringame) == "array" and typeof(players) == "array" then
    i = 0
    while i < MAXPLAYERS and i < len(playeringame) and i < len(players)
      if playeringame[i] and typeof(players[i]) == "struct" and players[i].playerstate == playerstate_t.PST_REBORN then
        G_DoReborn(i)
      end if
      i = i + 1
    end while
  end if

  if gamestate == gamestate_t.GS_LEVEL then
    if typeof(P_Ticker) == "function" then P_Ticker() end if
    if typeof(ST_Ticker) == "function" then ST_Ticker() end if
    if typeof(HU_Ticker) == "function" then HU_Ticker() end if
  else if gamestate == gamestate_t.GS_INTERMISSION then
    if typeof(WI_Ticker) == "function" then WI_Ticker() end if
  else if gamestate == gamestate_t.GS_FINALE then
    if typeof(F_Ticker) == "function" then F_Ticker() end if
  else

    if typeof(D_PageTicker) == "function" then D_PageTicker() end if
  end if

end function

/*
* Function: _G_EnsureInputState
* Purpose: Implements the _G_EnsureInputState routine for the internal module support.
*/
function _G_EnsureInputState()
  global _G_keydown
  global _G_mousebuttons
  global _G_joybuttons

  if typeof(_G_keydown) != "bytes" or len(_G_keydown) < 256 then
    _G_keydown = bytes(256, 0)
  end if

  if typeof(_G_mousebuttons) != "array" or len(_G_mousebuttons) < 3 then
    _G_mousebuttons =[0, 0, 0]
  end if

  if typeof(_G_joybuttons) != "array" or len(_G_joybuttons) < 4 then
    _G_joybuttons =[0, 0, 0, 0]
  end if
end function

/*
* Function: _G_IDiv
* Purpose: Implements the _G_IDiv routine for the internal module support.
*/
function _G_IDiv(a, b)
  if typeof(a) != "int" or typeof(b) != "int" or b == 0 then return 0 end if
  q = a / b
  if q >= 0 then return std.math.floor(q) end if
  return std.math.ceil(q)
end function

/*
* Function: _G_KeyIndex
* Purpose: Implements the _G_KeyIndex routine for the internal module support.
*/
function _G_KeyIndex(k)
  if typeof(k) != "int" then return -1 end if
  if k < 0 or k >= 256 then return -1 end if
  return k
end function

/*
* Function: _G_KeyIsDown
* Purpose: Implements the _G_KeyIsDown routine for the internal module support.
*/
function _G_KeyIsDown(k)
  _G_EnsureInputState()
  idx = _G_KeyIndex(k)
  if idx < 0 then return false end if
  return (_G_keydown[idx] != 0)
end function

/*
* Function: _G_ButtonIsDown
* Purpose: Implements the _G_ButtonIsDown routine for the internal module support.
*/
function _G_ButtonIsDown(arr, idx)
  if typeof(arr) != "array" then return false end if
  if typeof(idx) != "int" then return false end if
  if idx < 0 or idx >= len(arr) then return false end if
  return (arr[idx] != 0)
end function

/*
* Function: _G_InitDevInputTweaks
* Purpose: Initializes state and dependencies for the internal module support.
*/
function _G_InitDevInputTweaks()
  global _G_devInputInit
  global _G_devAutoForward
  global _G_devAutoTurn
  global _G_devAutoFire
  global _G_devAutoUse
  global _G_devAutoUseTicker

  if _G_devInputInit then return end if
  _G_devInputInit = true
  _G_devAutoForward = false
  _G_devAutoTurn = false
  _G_devAutoFire = false
  _G_devAutoUse = false
  _G_devAutoUseTicker = 0
  if typeof(M_CheckParm) == "function" then
    if M_CheckParm("-autofwd") or M_CheckParm("--autofwd") then
      _G_devAutoForward = true
      print "G_BuildTiccmd: -autofwd enabled (dev movement helper)"
    end if
    if M_CheckParm("-autoturn") or M_CheckParm("--autoturn") then
      _G_devAutoTurn = true
      print "G_BuildTiccmd: -autoturn enabled (dev turn helper)"
    end if
    if M_CheckParm("-autofire") or M_CheckParm("--autofire") then
      _G_devAutoFire = true
      print "G_BuildTiccmd: -autofire enabled (dev fire helper)"
    end if
    if M_CheckParm("-autouse") or M_CheckParm("--autouse") then
      _G_devAutoUse = true
      print "G_BuildTiccmd: -autouse enabled (dev use helper)"
    end if
  end if
end function

/*
* Function: G_Responder
* Purpose: Implements the G_Responder routine for the game flow.
*/
function G_Responder(ev)
  global sendpause
  global _G_mousex
  global _G_mousey
  global _G_joyxmove
  global _G_joyymove
  global displayplayer

  if ev is void then return false end if
  _G_EnsureInputState()

  if gamestate == gamestate_t.GS_LEVEL and ev.type == evtype_t.ev_keydown and ev.data1 == KEY_F12 and(singledemo or(not deathmatch)) then
    if typeof(playeringame) == "array" and len(playeringame) > 0 then
      loop
        displayplayer = displayplayer + 1
        if displayplayer >= MAXPLAYERS then displayplayer = 0 end if
        while (displayplayer < len(playeringame) and not playeringame[displayplayer]) and displayplayer != consoleplayer
        end loop
      end if
      return true
    end if

    if gameaction == gameaction_t.ga_nothing and(not singledemo) and(demoplayback or gamestate == gamestate_t.GS_DEMOSCREEN) then
      if ev.type == evtype_t.ev_keydown or(ev.type == evtype_t.ev_mouse and ev.data1 != 0) or(ev.type == evtype_t.ev_joystick and ev.data1 != 0) then
        if typeof(M_StartControlPanel) == "function" then M_StartControlPanel() end if
        return true
      end if
      return false
    end if

    if gamestate == gamestate_t.GS_LEVEL then
      if typeof(HU_Responder) == "function" and HU_Responder(ev) then return true end if
      if typeof(ST_Responder) == "function" and ST_Responder(ev) then return true end if
      if typeof(AM_Responder) == "function" and AM_Responder(ev) then return true end if
    end if

    if gamestate == gamestate_t.GS_FINALE then
      if typeof(F_Responder) == "function" and F_Responder(ev) then return true end if
    end if

    if ev.type == evtype_t.ev_keydown then
      if ev.data1 == KEY_PAUSE then
        sendpause = true
        return true
      end if
      idx = _G_KeyIndex(ev.data1)
      if idx >= 0 then _G_keydown[idx] = 1 end if
      return true
    end if

    if ev.type == evtype_t.ev_keyup then
      idx = _G_KeyIndex(ev.data1)
      if idx >= 0 then _G_keydown[idx] = 0 end if
      return false
    end if

    if ev.type == evtype_t.ev_mouse then
      _G_mousebuttons[0] = ev.data1 & 1
      _G_mousebuttons[1] = ev.data1 & 2
      _G_mousebuttons[2] = ev.data1 & 4
      _G_mousex = _G_IDiv(ev.data2 *(mouseSensitivity + 5), 10)
      _G_mousey = _G_IDiv(ev.data3 *(mouseSensitivity + 5), 10)
      return true
    end if

    if ev.type == evtype_t.ev_joystick then
      _G_joybuttons[0] = ev.data1 & 1
      _G_joybuttons[1] = ev.data1 & 2
      _G_joybuttons[2] = ev.data1 & 4
      _G_joybuttons[3] = ev.data1 & 8
      _G_joyxmove = ev.data2
      _G_joyymove = ev.data3
      return true
    end if

    return false
  end function

  /*
  * Function: G_ScreenShot
  * Purpose: Implements the G_ScreenShot routine for the game flow.
  */
  function G_ScreenShot()
    global gameaction

    gameaction = gameaction_t.ga_screenshot
  end function

  /*
  * Function: G_BuildTiccmd
  * Purpose: Implements the G_BuildTiccmd routine for the game flow.
  */
  function G_BuildTiccmd(cmd)
    global _G_turnheld
    global _G_mousex
    global _G_mousey
    global _G_dclicks
    global sendpause
    global sendsave
    global _G_devPrintTicker
    global _G_devAutoUseTicker

    if cmd is void then return end if

    _G_EnsureInputState()
    _G_InitDevInputTweaks()

    cmd.forwardmove = 0
    cmd.sidemove = 0
    cmd.angleturn = 0
    cmd.consistancy = 0
    if typeof(HU_dequeueChatChar) == "function" then
      cc = HU_dequeueChatChar()
      if typeof(cc) != "int" then cc = 0 end if
      cmd.chatchar = cc
    else
      cmd.chatchar = 0
    end if
    cmd.buttons = 0

    strafe = _G_KeyIsDown(key_strafe) or _G_ButtonIsDown(_G_mousebuttons, mousebstrafe) or _G_ButtonIsDown(_G_joybuttons, joybstrafe)
    speed = 0
    if _G_KeyIsDown(key_speed) or _G_ButtonIsDown(_G_joybuttons, joybspeed) then
      speed = 1
    end if

    forward = 0
    side = 0

    if _G_joyxmove < 0 or _G_joyxmove > 0 or _G_KeyIsDown(key_right) or _G_KeyIsDown(key_left) then
      _G_turnheld = _G_turnheld + 1
    else
      _G_turnheld = 0
    end if

    tspeed = speed
    if _G_turnheld < SLOWTURNTICS then tspeed = 2 end if

    if strafe then
      if _G_KeyIsDown(key_right) then side = side + sidemove[speed] end if
      if _G_KeyIsDown(key_left) then side = side - sidemove[speed] end if
      if _G_joyxmove > 0 then side = side + sidemove[speed] end if
      if _G_joyxmove < 0 then side = side - sidemove[speed] end if
    else
      if _G_KeyIsDown(key_right) then cmd.angleturn = cmd.angleturn - angleturn[tspeed] end if
      if _G_KeyIsDown(key_left) then cmd.angleturn = cmd.angleturn + angleturn[tspeed] end if
      if _G_joyxmove > 0 then cmd.angleturn = cmd.angleturn - angleturn[tspeed] end if
      if _G_joyxmove < 0 then cmd.angleturn = cmd.angleturn + angleturn[tspeed] end if
    end if
    if _G_devAutoTurn then cmd.angleturn = cmd.angleturn + angleturn[1] end if

    if _G_KeyIsDown(key_up) or _G_KeyIsDown(119) then forward = forward + forwardmove[speed] end if
    if _G_KeyIsDown(key_down) or _G_KeyIsDown(115) then forward = forward - forwardmove[speed] end if
    if _G_devAutoForward then forward = forward + forwardmove[speed] end if
    if _G_joyymove < 0 then forward = forward + forwardmove[speed] end if
    if _G_joyymove > 0 then forward = forward - forwardmove[speed] end if
    if _G_KeyIsDown(key_straferight) or _G_KeyIsDown(100) then side = side + sidemove[speed] end if
    if _G_KeyIsDown(key_strafeleft) or _G_KeyIsDown(97) then side = side - sidemove[speed] end if

    if _G_KeyIsDown(key_fire) or _G_ButtonIsDown(_G_mousebuttons, mousebfire) or _G_ButtonIsDown(_G_joybuttons, joybfire) then
      cmd.buttons = cmd.buttons | buttoncode_t.BT_ATTACK
    end if
    if _G_devAutoFire then
      cmd.buttons = cmd.buttons | buttoncode_t.BT_ATTACK
    end if

    if _G_KeyIsDown(key_use) or _G_ButtonIsDown(_G_joybuttons, joybuse) then
      cmd.buttons = cmd.buttons | buttoncode_t.BT_USE
      _G_dclicks = 0
    end if
    if _G_devAutoUse then
      _G_devAutoUseTicker = _G_devAutoUseTicker + 1
      if _G_devAutoUseTicker >= 12 then
        cmd.buttons = cmd.buttons | buttoncode_t.BT_USE
        _G_dclicks = 0
        _G_devAutoUseTicker = 0
      end if
    end if

    for i = 0 to NUMWEAPONS - 2
      if _G_KeyIsDown(49 + i) then
        cmd.buttons = cmd.buttons | buttoncode_t.BT_CHANGE
        cmd.buttons = cmd.buttons |(i << buttoncode_t.BT_WEAPONSHIFT)
        break
      end if
    end for

    if _G_ButtonIsDown(_G_mousebuttons, mousebforward) then
      forward = forward + forwardmove[speed]
    end if

    forward = forward + _G_mousey
    if strafe then
      side = side + _G_mousex * 2
    else
      cmd.angleturn = cmd.angleturn - _G_mousex * 8
    end if

    _G_mousex = 0
    _G_mousey = 0

    if forward > MAXPLMOVE then forward = MAXPLMOVE end if
    if forward < -MAXPLMOVE then forward = -MAXPLMOVE end if
    if side > MAXPLMOVE then side = MAXPLMOVE end if
    if side < -MAXPLMOVE then side = -MAXPLMOVE end if

    deadLocal = false
    if typeof(players) == "array" and consoleplayer >= 0 and consoleplayer < len(players) and typeof(players[consoleplayer]) == "struct" then
      lp = players[consoleplayer]
      if lp.playerstate == playerstate_t.PST_DEAD then deadLocal = true end if
      if typeof(lp.health) == "int" and lp.health <= 0 then deadLocal = true end if
      if lp.mo is not void and typeof(lp.mo.health) == "int" and lp.mo.health <= 0 then deadLocal = true end if
    end if
    if deadLocal then
      forward = 0
      side = 0
      cmd.angleturn = 0
    end if

    cmd.forwardmove = cmd.forwardmove + forward
    cmd.sidemove = cmd.sidemove + side

    if sendpause then
      sendpause = false
      cmd.buttons = buttoncode_t.BT_SPECIAL | buttoncode_t.BTS_PAUSE
    end if

    if sendsave then
      sendsave = false
      cmd.buttons = buttoncode_t.BT_SPECIAL | buttoncode_t.BTS_SAVEGAME |(_G_saveSlot << buttoncode_t.BTS_SAVESHIFT)
    end if

    if _G_devAutoForward then
      _G_devPrintTicker = _G_devPrintTicker + 1
      if _G_devPrintTicker >= 35 then _G_devPrintTicker = 0 end if
    end if
  end function

  gameaction = gameaction_t.ga_nothing
  secretexit = false

  _G_defSkill = skill_t.sk_medium
  _G_defEpisode = 1
  _G_defMap = 1
  _G_defDemo = ""
  _G_loadName = ""
  _G_saveSlot = 0
  _G_saveDesc = ""
  _G_demo_p = 0
  _G_demoend = 0
  demoname = ""
  demobuffer = void
  netdemo = false
  timingdemo = false
  starttime = 0

  const NUMKEYS = 256
  const SLOWTURNTICS = 6
  const TURBOTHRESHOLD = 0x32
  const DEMOMARKER = 0x80

  forwardmove =[0x19, 0x32]
  sidemove =[0x18, 0x28]
  angleturn =[640, 1280, 320]
  MAXPLMOVE = 0x32

  key_right = KEY_RIGHTARROW
  key_left = KEY_LEFTARROW
  key_up = KEY_UPARROW
  key_down = KEY_DOWNARROW
  key_strafeleft = 44
  key_straferight = 46
  key_fire = KEY_RCTRL
  key_use = 32
  key_strafe = KEY_RALT
  key_speed = KEY_RSHIFT

  mousebfire = 0
  mousebstrafe = 1
  mousebforward = 2

  joybfire = 0
  joybstrafe = 1
  joybuse = 3
  joybspeed = 2

  sendpause = false
  sendsave = false

  _G_keydown = bytes(NUMKEYS, 0)
  _G_turnheld = 0
  _G_mousebuttons =[0, 0, 0]
  _G_mousex = 0
  _G_mousey = 0
  _G_joybuttons =[0, 0, 0, 0]
  _G_joyxmove = 0
  _G_joyymove = 0
  _G_devInputInit = false
  _G_devAutoForward = false
  _G_devAutoTurn = false
  _G_devAutoFire = false
  _G_devAutoUse = false
  _G_devAutoUseTicker = 0
  _G_devPrintTicker = 0
  _G_dclicks = 0



