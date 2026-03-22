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

  Script: d_main.ml
  Purpose: Defines core Doom data types, shared state, and bootstrap flow.
*/
import d_event
import doomdef
import doomstat
import dstrings
import sounds
import z_zone
import w_wad
import s_sound
import v_video
import f_finale
import f_wipe
import m_argv
import m_misc
import m_menu
import mp_platform
import i_system
import i_sound
import i_video
import g_game
import hu_stuff
import wi_stuff
import st_stuff
import am_map
import p_setup
import r_local
import tables
import std.fs as fs
import std.time

const MAXWADFILES = 20
wadfiles =[]

/*
* Function: D_AddFile
* Purpose: Implements the D_AddFile routine for the core game definitions.
*/
function D_AddFile(file)
  global wadfiles

  if typeof(file) == "bytes" then
    file = decodeZ(file)
  end if
  if typeof(file) != "string" or len(file) == 0 then return end if

  i = 0
  while i < len(wadfiles)
    if wadfiles[i] == file then
      return
    end if
    i = i + 1
  end while

  if len(wadfiles) >= MAXWADFILES then
    if typeof(I_Error) == "function" then I_Error("D_AddFile: too many wads") end if
    return
  end if
  wadfiles = wadfiles +[file]
end function

events = void
eventhead = 0
eventtail = 0

advancedemo = false
demosequence = -1
pagetic = 0
pagename = "TITLEPIC"

_d_profile_render = false
_d_prof_t0 = 0
_d_prof_frames = 0
_d_prof_r_ms = 0
_d_prof_st_ms = 0
_d_prof_hu_ms = 0
_d_prof_am_ms = 0
_d_prof_other_ms = 0
_d_prof_vid_ms = 0

/*
* Function: _D_TimeMs
* Purpose: Implements the _D_TimeMs routine for the internal module support.
*/
function inline _D_TimeMs()
  t = std.time.ticks()
  if typeof(t) != "int" then return 0 end if
  return t
end function

/*
* Function: _D_ProfileAdd
* Purpose: Implements the _D_ProfileAdd routine for the internal module support.
*/
function _D_ProfileAdd(slot, delta)
  global _d_prof_r_ms
  global _d_prof_st_ms
  global _d_prof_hu_ms
  global _d_prof_am_ms
  global _d_prof_other_ms
  global _d_prof_vid_ms

  if slot == 0 then
    _d_prof_r_ms = _d_prof_r_ms + delta
  else if slot == 1 then
    _d_prof_st_ms = _d_prof_st_ms + delta
  else if slot == 2 then
    _d_prof_hu_ms = _d_prof_hu_ms + delta
  else if slot == 3 then
    _d_prof_am_ms = _d_prof_am_ms + delta
  else if slot == 4 then
    _d_prof_other_ms = _d_prof_other_ms + delta
  else
    _d_prof_vid_ms = _d_prof_vid_ms + delta
  end if
end function

/*
* Function: _D_DrawMPDebugOverlay
* Purpose: Renders multiplayer debug telemetry text overlay when MP runtime is active.
*/
function _D_DrawMPDebugOverlay()
  if typeof(MP_PlatformGetDebugOverlayText) != "function" then return end if
  txt = MP_PlatformGetDebugOverlayText()
  if typeof(D_NetMPDebugOverlayText) == "function" then
    dtxt = D_NetMPDebugOverlayText()
    if typeof(dtxt) == "string" and dtxt != "" then
      if txt == "" then
        txt = dtxt
      else
        txt = txt + "\n" + dtxt
      end if
    end if
  end if
  if typeof(txt) != "string" or txt == "" then return end if
  if typeof(M_WriteText) == "function" then
    M_WriteText(2, 2, txt)
  end if
end function

/*
* Function: _D_IDiv
* Purpose: Implements the _D_IDiv routine for the internal module support.
*/
function inline _D_IDiv(a, b)
  if typeof(a) != "int" or typeof(b) != "int" or b == 0 then return 0 end if
  q = a / b
  if q >= 0 then return std.math.floor(q) end if
  return std.math.ceil(q)
end function

/*
* Function: _D_ProfileFlushMaybe
* Purpose: Implements the _D_ProfileFlushMaybe routine for the internal module support.
*/
function _D_ProfileFlushMaybe()
  global _d_prof_t0
  global _d_prof_frames
  global _d_prof_r_ms
  global _d_prof_st_ms
  global _d_prof_hu_ms
  global _d_prof_am_ms
  global _d_prof_other_ms
  global _d_prof_vid_ms

  if not _d_profile_render then return end if

  now = _D_TimeMs()
  if _d_prof_t0 == 0 then
    _d_prof_t0 = now
    return
  end if

  elapsed = now - _d_prof_t0
  if elapsed < 1000 then return end if

  fps = 0
  if elapsed > 0 then fps = _D_IDiv(_d_prof_frames * 1000, elapsed) end if
  print "PROFILE render: fps=" + fps + " r=" + _d_prof_r_ms + "ms st=" + _d_prof_st_ms + "ms hu=" + _d_prof_hu_ms + "ms am=" + _d_prof_am_ms + "ms other=" + _d_prof_other_ms + "ms vid=" + _d_prof_vid_ms + "ms"

  _d_prof_t0 = now
  _d_prof_frames = 0
  _d_prof_r_ms = 0
  _d_prof_st_ms = 0
  _d_prof_hu_ms = 0
  _d_prof_am_ms = 0
  _d_prof_other_ms = 0
  _d_prof_vid_ms = 0
end function

/*
* Function: _D_InitEventQueue
* Purpose: Initializes state and dependencies for the internal module support.
*/
function _D_InitEventQueue()
  global events
  global eventhead
  global eventtail

  if typeof(events) == "array" then return end if
  events =[]
  i = 0
  while i < MAXEVENTS
    events = events +[event_t(evtype_t.ev_keydown, 0, 0, 0)]
    i = i + 1
  end while
  eventhead = 0
  eventtail = 0
end function

/*
* Function: D_PostEvent
* Purpose: Implements the D_PostEvent routine for the core game definitions.
*/
function D_PostEvent(ev)
  global eventhead

  _D_InitEventQueue()
  if ev is void then return end if

  events[eventhead] = ev
  eventhead =(eventhead + 1) &(MAXEVENTS - 1)
end function

/*
* Function: D_ProcessEvents
* Purpose: Implements the D_ProcessEvents routine for the core game definitions.
*/
function D_ProcessEvents()
  global eventtail

  _D_InitEventQueue()

  if gamemode == GameMode_t.commercial then
    if typeof(W_CheckNumForName) == "function" then
      if W_CheckNumForName("map01") < 0 then
        return
      end if
    end if
  end if

  while eventtail != eventhead
    ev = events[eventtail]

    if typeof(M_Responder) == "function" then
      if M_Responder(ev) then
        eventtail =(eventtail + 1) &(MAXEVENTS - 1)
        continue
      end if
    end if

    if typeof(G_Responder) == "function" then
      G_Responder(ev)
    end if

    eventtail =(eventtail + 1) &(MAXEVENTS - 1)
  end while
end function

/*
* Function: D_PageTicker
* Purpose: Advances per-tick logic for the core game definitions.
*/
function D_PageTicker()
  global pagetic

  if pagetic > 0 then
    pagetic = pagetic - 1
  end if
  if pagetic <= 0 then
    D_AdvanceDemo()
  end if
end function

/*
* Function: D_PageDrawer
* Purpose: Draws or renders output for the core game definitions.
*/
function D_PageDrawer()
  name = "TITLEPIC"
  if typeof(pagename) == "string" and len(pagename) > 0 then
    name = pagename
  end if

  if typeof(W_CheckNumForName) == "function" and typeof(W_CacheLumpName) == "function" and typeof(V_DrawPatch) == "function" then
    if W_CheckNumForName(name) != -1 then
      V_DrawPatch(0, 0, 0, W_CacheLumpName(name, PU_CACHE))
      return
    end if
  end if

  if typeof(screens) == "array" and len(screens) > 0 and typeof(screens[0]) == "bytes" then
    fb = screens[0]
    for i = 0 to(SCREENWIDTH * SCREENHEIGHT) - 1
      fb[i] = 0
    end for
  end if
end function

/*
* Function: D_AdvanceDemo
* Purpose: Implements the D_AdvanceDemo routine for the core game definitions.
*/
function D_AdvanceDemo()
  global advancedemo

  advancedemo = true
end function

/*
* Function: D_DoAdvanceDemo
* Purpose: Implements the D_DoAdvanceDemo routine for the core game definitions.
*/
function D_DoAdvanceDemo()
  global advancedemo
  global demosequence
  global usergame
  global paused
  global gameaction
  global gamestate
  global pagetic
  global pagename

  if typeof(players) == "array" and typeof(consoleplayer) == "int" and consoleplayer >= 0 and consoleplayer < len(players) and typeof(players[consoleplayer]) == "struct" then
    cp = players[consoleplayer]
    cp.playerstate = playerstate_t.PST_LIVE
    players[consoleplayer] = cp
  end if
  advancedemo = false
  usergame = false
  paused = false
  gameaction = gameaction_t.ga_nothing

  if gamemode == GameMode_t.retail then
    demosequence =(demosequence + 1) % 7
  else
    demosequence =(demosequence + 1) % 6
  end if

  if demosequence == 0 then
    if gamemode == GameMode_t.commercial then
      pagetic = 35 * 11
    else
      pagetic = 170
    end if
    gamestate = gamestate_t.GS_DEMOSCREEN
    pagename = "TITLEPIC"
    if typeof(S_StartMusic) == "function" then
      if gamemode == GameMode_t.commercial then
        S_StartMusic(musicenum_t.mus_dm2ttl)
      else
        S_StartMusic(musicenum_t.mus_intro)
      end if
    end if
    return
  end if

  if demosequence == 1 then
    if typeof(G_DeferedPlayDemo) == "function" then G_DeferedPlayDemo("demo1") end if
    return
  end if

  if demosequence == 2 then
    pagetic = 200
    gamestate = gamestate_t.GS_DEMOSCREEN
    pagename = "CREDIT"
    return
  end if

  if demosequence == 3 then
    if typeof(G_DeferedPlayDemo) == "function" then G_DeferedPlayDemo("demo2") end if
    return
  end if

  if demosequence == 4 then
    gamestate = gamestate_t.GS_DEMOSCREEN
    if gamemode == GameMode_t.commercial then
      pagetic = 35 * 11
      pagename = "TITLEPIC"
      if typeof(S_StartMusic) == "function" then
        S_StartMusic(musicenum_t.mus_dm2ttl)
      end if
    else
      pagetic = 200
      if gamemode == GameMode_t.retail then
        pagename = "CREDIT"
      else
        pagename = "HELP2"
      end if
    end if
    return
  end if

  if demosequence == 5 then
    if typeof(G_DeferedPlayDemo) == "function" then G_DeferedPlayDemo("demo3") end if
    return
  end if

  if demosequence == 6 then
    if typeof(G_DeferedPlayDemo) == "function" then G_DeferedPlayDemo("demo4") end if
    return
  end if
end function

/*
* Function: D_StartTitle
* Purpose: Starts runtime behavior in the core game definitions.
*/
function D_StartTitle()
  global demosequence
  global pagename
  global pagetic
  global gamestate
  global gameaction

  gameaction = gameaction_t.ga_nothing
  gamestate = gamestate_t.GS_DEMOSCREEN
  demosequence = -1
  pagename = "TITLEPIC"
  pagetic = 0
  D_AdvanceDemo()
end function

/*
* Function: _D_ParseWadFilesFromArgs
* Purpose: Implements the _D_ParseWadFilesFromArgs routine for the internal module support.
*/
function _D_ParseWadFilesFromArgs()

  i = M_CheckParm("-iwad")
  if i != 0 and i < myargc - 1 then
    D_AddFile(myargv[i + 1])
  end if

  if len(wadfiles) == 0 then
    D_AddFile("doom.wad")
  end if

  i = M_CheckParm("-file")
  if i != 0 then
    j = i + 1
    while j < myargc
      a = myargv[j]

      if typeof(a) == "string" and len(a) > 0 and bytes(a)[0] == 45 then
        break
      end if
      D_AddFile(a)
      j = j + 1
    end while
  end if
end function

/*
* Function: _D_AddDemoLmpFromArgs
* Purpose: Implements the _D_AddDemoLmpFromArgs routine for the internal module support.
*/
function inline _D_AddDemoLmpFromArgs(flag)
  p = M_CheckParm(flag)
  if p == 0 or p >= myargc - 1 then return end if
  name = myargv[p + 1]
  if typeof(name) != "string" or len(name) == 0 then return end if
  if _D_StrContains(_D_ToLowerAscii(name), ".lmp") then
    D_AddFile(name)
  else
    D_AddFile(name + ".lmp")
  end if
end function

/*
* Function: _D_FileReadable
* Purpose: Implements the _D_FileReadable routine for the internal module support.
*/
function inline _D_FileReadable(path)
  if typeof(path) != "string" or len(path) == 0 then return false end if
  if not fs.exists(path) then return false end if
  if not fs.isFile(path) then return false end if

  return true
end function

/*
* Function: _D_ToLowerAscii
* Purpose: Implements the _D_ToLowerAscii routine for the internal module support.
*/
function _D_ToLowerAscii(s)
  if typeof(s) != "string" then return "" end if
  b = bytes(s)
  i = 0
  while i < len(b)
    if b[i] >= 65 and b[i] <= 90 then b[i] = b[i] + 32 end if
    i = i + 1
  end while
  return decode(b)
end function

/*
* Function: _D_StrContains
* Purpose: Implements the _D_StrContains routine for the internal module support.
*/
function _D_StrContains(haystack, needle)
  if typeof(haystack) != "string" or typeof(needle) != "string" then return false end if
  hb = bytes(haystack)
  nb = bytes(needle)
  if len(nb) == 0 then return true end if
  if len(nb) > len(hb) then return false end if

  i = 0
  while i <= len(hb) - len(nb)
    ok = true
    j = 0
    while j < len(nb)
      if hb[i + j] != nb[j] then
        ok = false
        break
      end if
      j = j + 1
    end while
    if ok then return true end if
    i = i + 1
  end while
  return false
end function

/*
* Function: _D_IsResponseTokenByte
* Purpose: Reads or updates state used by the internal module support.
*/
function inline _D_IsResponseTokenByte(c)
  return c >= 33 and c <= 122
end function

/*
* Function: _D_ParseResponseArgs
* Purpose: Implements the _D_ParseResponseArgs routine for the internal module support.
*/
function _D_ParseResponseArgs(data)
  argsOut =[]
  if typeof(data) != "bytes" then return argsOut end if

  k = 0
  while k < len(data)
    while k < len(data) and(data[k] <= 32 or data[k] > 122)
      k = k + 1
    end while
    if k >= len(data) then break end if

    start = k
    while k < len(data) and _D_IsResponseTokenByte(data[k])
      k = k + 1
    end while

    if k > start then
      argsOut = argsOut +[decode(slice(data, start, k - start))]
    end if
  end while

  return argsOut
end function

/*
* Function: IdentifyVersion
* Purpose: Implements the IdentifyVersion routine for the engine module behavior.
*/
function IdentifyVersion()
  global gamemode
  global language

  p = M_CheckParm("-iwad")
  if p != 0 and p < myargc - 1 then
    iw = myargv[p + 1]
    if typeof(iw) == "string" and len(iw) > 0 then
      D_AddFile(iw)
      low = _D_ToLowerAscii(iw)
      if _D_StrContains(low, "doom2") or _D_StrContains(low, "plutonia") or _D_StrContains(low, "tnt") then
        gamemode = GameMode_t.commercial
      else if _D_StrContains(low, "doomu") then
        gamemode = GameMode_t.retail
      else if _D_StrContains(low, "doom1") then
        gamemode = GameMode_t.shareware
      else
        gamemode = GameMode_t.registered
      end if
      return
    end if
  end if

  candidates =[
  ["doom2f.wad", GameMode_t.commercial],
  ["doom2.wad", GameMode_t.commercial],
  ["plutonia.wad", GameMode_t.commercial],
  ["tnt.wad", GameMode_t.commercial],
  ["doomu.wad", GameMode_t.retail],
  ["doom.wad", GameMode_t.registered],
  ["doom1.wad", GameMode_t.shareware]
]

  i = 0
  while i < len(candidates)
    path = candidates[i][0]
    mode = candidates[i][1]
    if _D_FileReadable(path) then
      gamemode = mode
      D_AddFile(path)
      if path == "doom2f.wad" then language = Language_t.french end if
      return
    end if
    i = i + 1
  end while

  gamemode = GameMode_t.indetermined
end function

/*
* Function: FindResponseFile
* Purpose: Implements the FindResponseFile routine for the engine module behavior.
*/
function FindResponseFile()
  global myargv
  global myargc

  i = 1
  while i < myargc
    a = myargv[i]
    if typeof(a) == "string" and len(a) > 1 then
      ab = bytes(a)
      if ab[0] == 64 then
        fn = decode(slice(ab, 1, len(ab) - 1))
        if not _D_FileReadable(fn) then
          I_Error("No such response file: " + fn)
          return
        end if

        print "Found response file " + fn + "!"
        filebytesTry = try(fs.readAllBytes(fn))
        if typeof(filebytesTry) == "error" then
          I_Error("Couldn't read response file: " + fn)
          return
        end if
        filebytes = filebytesTry
        if typeof(filebytes) != "bytes" then
          I_Error("Couldn't read response file: " + fn)
          return
        end if

        moreargs =[]
        k = i + 1
        while k < myargc
          moreargs = moreargs +[myargv[k]]
          k = k + 1
        end while

        firstargv = "doom"
        if myargc > 0 and typeof(myargv[0]) == "string" then firstargv = myargv[0] end if
        newargv =[firstargv]

        rsp = _D_ParseResponseArgs(filebytes)
        k = 0
        while k < len(rsp)
          newargv = newargv +[rsp[k]]
          k = k + 1
        end while

        k = 0
        while k < len(moreargs)
          newargv = newargv +[moreargs[k]]
          k = k + 1
        end while

        myargv = newargv
        myargc = len(newargv)

        print myargc + " command-line args:"
        k = 1
        while k < myargc
          print myargv[k]
          k = k + 1
        end while

        return
      end if
    end if
    i = i + 1
  end while
end function

/*
* Function: D_DoomMain
* Purpose: Implements the D_DoomMain routine for the core game definitions.
*/
function D_DoomMain()
  global wadfiles
  global devparm
  global _d_profile_render
  global uncapped_render
  global interp_view
  global nomonsters
  global respawnparm
  global fastparm
  global deathmatch
  global startskill
  global startepisode
  global startmap
  global autostart
  global singledemo

  wadfiles =[]
  FindResponseFile()
  IdentifyVersion()

  devparm =(M_CheckParm("-devparm") != 0)
  _d_profile_render =(M_CheckParm("-profile-render") != 0 or M_CheckParm("--profile-render") != 0)
  if M_CheckParm("-capped") != 0 then
    uncapped_render = false
  end if
  if M_CheckParm("-uncapped") != 0 then
    uncapped_render = true
  end if
  if M_CheckParm("-interpview") != 0 then
    interp_view = true
  end if
  if M_CheckParm("-nointerpview") != 0 then
    interp_view = false
  end if
  nomonsters =(M_CheckParm("-nomonsters") != 0)
  respawnparm =(M_CheckParm("-respawn") != 0)
  fastparm =(M_CheckParm("-fast") != 0)
  if M_CheckParm("-altdeath") != 0 then
    deathmatch = 2
  else if M_CheckParm("-deathmatch") != 0 then
    deathmatch = 1
  end if

  if typeof(M_LoadDefaults) == "function" then M_LoadDefaults() end if

  if typeof(Tables_Init) == "function" then Tables_Init() end if

  _D_ParseWadFilesFromArgs()
  _D_AddDemoLmpFromArgs("-playdemo")
  _D_AddDemoLmpFromArgs("-timedemo")

  if typeof(V_Init) == "function" then V_Init() end if
  if devparm then print "D_DoomMain: V_Init done" end if
  if typeof(Z_Init) == "function" then Z_Init() end if
  if typeof(W_InitMultipleFiles) == "function" then
    W_InitMultipleFiles(wadfiles)
    if devparm then print "D_DoomMain: numlumps=" + numlumps end if
  end if

  if typeof(M_Init) == "function" then M_Init() end if
  if devparm then print "D_DoomMain: M_Init done" end if
  if typeof(R_Init) == "function" then R_Init() end if
  if devparm then print "D_DoomMain: R_Init done" end if
  if typeof(P_Init) == "function" then P_Init() end if
  if devparm then print "D_DoomMain: P_Init done" end if
  if typeof(I_Init) == "function" then I_Init() end if

  if typeof(D_CheckNetGame) == "function" then D_CheckNetGame() end if

  if typeof(S_Init) == "function" then

    if typeof(snd_SfxVolume) != "void" and typeof(snd_MusicVolume) != "void" then
      S_Init(snd_SfxVolume, snd_MusicVolume)
    else
      S_Init(8, 8)
    end if
  end if

  if typeof(HU_Init) == "function" then HU_Init() end if
  if typeof(ST_Init) == "function" then ST_Init() end if

  startskill = skill_t.sk_medium
  startepisode = 1
  startmap = 1
  autostart = false

  pSkill = M_CheckParm("-skill")
  if pSkill != 0 and pSkill < myargc - 1 then
    s = toNumber(myargv[pSkill + 1])
    if typeof(s) == "int" then
      if s < 1 then s = 1 end if
      if s > 5 then s = 5 end if
      startskill = s - 1
      autostart = true
    end if
  end if

  pEpisode = M_CheckParm("-episode")
  if pEpisode != 0 and pEpisode < myargc - 1 then
    e = toNumber(myargv[pEpisode + 1])
    if typeof(e) == "int" then
      if e < 1 then e = 1 end if
      startepisode = e
      startmap = 1
      autostart = true
    end if
  end if

  pWarp = M_CheckParm("-warp")
  if pWarp != 0 and pWarp < myargc - 1 then
    if gamemode == GameMode_t.commercial then
      m = toNumber(myargv[pWarp + 1])
      if typeof(m) == "int" then
        if m < 1 then m = 1 end if
        startmap = m
        autostart = true
      end if
    else
      e = toNumber(myargv[pWarp + 1])
      m = void
      if pWarp < myargc - 2 then
        m = toNumber(myargv[pWarp + 2])
      end if
      if typeof(e) == "int" and typeof(m) == "int" then
        if e < 1 then e = 1 end if
        if m < 1 then m = 1 end if
        startepisode = e
        startmap = m
        autostart = true
      else if typeof(e) == "int" then
        if e < 1 then e = 1 end if
        startepisode = 1
        startmap = e
        autostart = true
      end if
    end if
  end if

  pRecord = M_CheckParm("-record")
  if pRecord != 0 and pRecord < myargc - 1 then
    if typeof(G_RecordDemo) == "function" then
      G_RecordDemo(myargv[pRecord + 1])
      autostart = true
    end if
  end if

  pLoad = M_CheckParm("-loadgame")
  if pLoad != 0 and pLoad < myargc - 1 then
    slot = toNumber(myargv[pLoad + 1])
    if typeof(slot) == "int" then
      if slot < 0 then slot = 0 end if
      if slot > 9 then slot = 9 end if
      if M_CheckParm("-cdrom") != 0 then
        G_LoadGame("c:\\doomdata\\" + SAVEGAMENAME + slot + ".dsg")
      else
        G_LoadGame(SAVEGAMENAME + slot + ".dsg")
      end if
    end if
  end if

  pPlayDemo = M_CheckParm("-playdemo")
  if pPlayDemo != 0 and pPlayDemo < myargc - 1 then
    if typeof(G_DeferedPlayDemo) == "function" then
      singledemo = true
      G_DeferedPlayDemo(myargv[pPlayDemo + 1])
    end if
  end if

  pTimeDemo = M_CheckParm("-timedemo")
  if pTimeDemo != 0 and pTimeDemo < myargc - 1 then
    if typeof(G_TimeDemo) == "function" then
      G_TimeDemo(myargv[pTimeDemo + 1])
    end if
  end if

  if gameaction == gameaction_t.ga_playdemo or gameaction == gameaction_t.ga_loadgame then

  else if autostart and typeof(G_InitNew) == "function" then
    G_InitNew(startskill, startepisode, startmap)
  else

    D_StartTitle()
  end if
  if devparm then print "D_DoomMain: entering loop" end if

  D_DoomLoop()
end function

/*
* Function: D_Display
* Purpose: Implements the D_Display routine for the core game definitions.
*/
function D_Display()
  global _d_profile_render
  global _d_prof_frames
  global wipegamestate

  if typeof(nodrawers) != "void" and nodrawers then
    return
  end if

  profiling = _d_profile_render

  if advancedemo then
    D_DoAdvanceDemo()
  end if

  levelRefresh = false
  if typeof(setsizeneeded) != "void" and setsizeneeded and typeof(R_ExecuteSetViewSize) == "function" then
    R_ExecuteSetViewSize()
    if typeof(R_FillBackScreen) == "function" then R_FillBackScreen() end if
    levelRefresh = true
  end if

  wipe = false
  if gamestate != wipegamestate then
    wipe = true
    levelRefresh = true
    if typeof(wipe_StartScreen) == "function" then
      wipe_StartScreen(0, 0, SCREENWIDTH, SCREENHEIGHT)
    end if
  end if

  if gamestate == gamestate_t.GS_LEVEL then

    if typeof(R_RenderPlayerView) == "function" then
      if profiling then
        t0 = _D_TimeMs()
        if typeof(players) == "array" and displayplayer < len(players) then
          R_RenderPlayerView(players[displayplayer])
        else
          R_RenderPlayerView(void)
        end if
        _D_ProfileAdd(0, _D_TimeMs() - t0)
      else
        if typeof(players) == "array" and displayplayer < len(players) then
          R_RenderPlayerView(players[displayplayer])
        else
          R_RenderPlayerView(void)
        end if
      end if
    end if

    if typeof(R_DrawViewBorder) == "function" and typeof(viewheight) == "int" and viewheight != SCREENHEIGHT then
      if not automapactive then
        R_DrawViewBorder()
      end if
    end if

    if typeof(ST_Drawer) == "function" then
      st_fullscreen = false
      if typeof(viewheight) == "int" then
        st_fullscreen =(viewheight == SCREENHEIGHT)
      end if
      if profiling then
        t0 = _D_TimeMs()
        ST_Drawer(st_fullscreen, levelRefresh)
        _D_ProfileAdd(1, _D_TimeMs() - t0)
      else
        ST_Drawer(st_fullscreen, levelRefresh)
      end if
    end if
    if typeof(HU_Drawer) == "function" then
      if profiling then
        t0 = _D_TimeMs()
        HU_Drawer()
        _D_ProfileAdd(2, _D_TimeMs() - t0)
      else
        HU_Drawer()
      end if
    end if
    if typeof(AM_Drawer) == "function" then
      if profiling then
        t0 = _D_TimeMs()
        AM_Drawer()
        _D_ProfileAdd(3, _D_TimeMs() - t0)
      else
        AM_Drawer()
      end if
    end if

  else if gamestate == gamestate_t.GS_INTERMISSION then
    if typeof(WI_Drawer) == "function" then
      if profiling then
        t0 = _D_TimeMs()
        WI_Drawer()
        _D_ProfileAdd(4, _D_TimeMs() - t0)
      else
        WI_Drawer()
      end if
    end if
  else if gamestate == gamestate_t.GS_FINALE then
    if typeof(F_Drawer) == "function" then
      if profiling then
        t0 = _D_TimeMs()
        F_Drawer()
        _D_ProfileAdd(4, _D_TimeMs() - t0)
      else
        F_Drawer()
      end if
    end if
  else

    if profiling then
      t0 = _D_TimeMs()
      D_PageDrawer()
      _D_ProfileAdd(4, _D_TimeMs() - t0)
    else
      D_PageDrawer()
    end if
  end if

  if typeof(I_UpdateNoBlit) == "function" then I_UpdateNoBlit() end if
  if typeof(M_Drawer) == "function" then M_Drawer() end if
  mpAuthoritative = false
  if typeof(MP_PlatformIsHosting) == "function" and MP_PlatformIsHosting() then mpAuthoritative = true end if
  if typeof(MP_PlatformIsClientConnected) == "function" and MP_PlatformIsClientConnected() then mpAuthoritative = true end if
  // TryRunTics already runs NetUpdate in authoritative MP mode; avoid duplicate per-frame network ticks here.
  if (not mpAuthoritative) and typeof(NetUpdate) == "function" then NetUpdate() end if

  wipegamestate = gamestate

  if not wipe then
    if typeof(I_FinishUpdate) == "function" then
      if profiling then
        t0 = _D_TimeMs()
        I_FinishUpdate()
        _D_ProfileAdd(5, _D_TimeMs() - t0)
      else
        I_FinishUpdate()
      end if
    end if

    if profiling then
      _d_prof_frames = _d_prof_frames + 1
      _D_ProfileFlushMaybe()
    end if
    return
  end if

  if typeof(wipe_EndScreen) != "function" or typeof(wipe_ScreenWipe) != "function" or typeof(I_GetTime) != "function" then
    if typeof(I_FinishUpdate) == "function" then
      if profiling then
        t0 = _D_TimeMs()
        I_FinishUpdate()
        _D_ProfileAdd(5, _D_TimeMs() - t0)
      else
        I_FinishUpdate()
      end if
    end if
    if profiling then
      _d_prof_frames = _d_prof_frames + 1
      _D_ProfileFlushMaybe()
    end if
    return
  end if

  wipe_EndScreen(0, 0, SCREENWIDTH, SCREENHEIGHT)
  wipestart = I_GetTime() - 1
  done = false
  tics = 1
  while not done
    waitGuard = 0
    while true
      nowtime = I_GetTime()
      tics = nowtime - wipestart
      if tics > 0 then
        wipestart = nowtime
        break
      end if

      if typeof(I_WaitVBL) == "function" then
        I_WaitVBL(1)
      else
        std.time.sleep(1)
      end if
      waitGuard = waitGuard + 1
      if waitGuard > 2000 then

        wipestart = I_GetTime()
        tics = 1
        break
      end if
    end while

    done = wipe_ScreenWipe(wipe_Melt, 0, 0, SCREENWIDTH, SCREENHEIGHT, tics)

    if typeof(I_UpdateNoBlit) == "function" then I_UpdateNoBlit() end if
    if typeof(M_Drawer) == "function" then M_Drawer() end if
    if typeof(I_FinishUpdate) == "function" then
      if profiling then
        t0 = _D_TimeMs()
        I_FinishUpdate()
        _D_ProfileAdd(5, _D_TimeMs() - t0)
      else
        I_FinishUpdate()
      end if
    end if
  end while

  if profiling then
    _d_prof_frames = _d_prof_frames + 1
    _D_ProfileFlushMaybe()
  end if
end function

/*
* Function: D_DoomLoop
* Purpose: Implements the D_DoomLoop routine for the core game definitions.
*/
function D_DoomLoop()

  global render_lerp_frac

  if typeof(demorecording) != "void" and demorecording and typeof(G_BeginRecording) == "function" then
    G_BeginRecording()
  end if

  if typeof(I_InitGraphics) == "function" then
    I_InitGraphics()
  end if

  if typeof(I_SetPalette) == "function" and typeof(W_CheckNumForName) == "function" and typeof(W_CacheLumpName) == "function" then
    if W_CheckNumForName("PLAYPAL") != -1 then
      I_SetPalette(W_CacheLumpName("PLAYPAL", PU_CACHE))
    end if
  end if

  debugTicks = 0
  while true
    if typeof(I_StartFrame) == "function" then I_StartFrame() end if

    if typeof(TryRunTics) == "function" then
      TryRunTics()
    else
      if typeof(I_StartTic) == "function" then I_StartTic() end if
      D_ProcessEvents()
      if typeof(G_Ticker) == "function" then G_Ticker() end if
    end if

    if typeof(S_UpdateSounds) == "function" then
      if typeof(players) == "array" and typeof(consoleplayer) == "int" and consoleplayer >= 0 and consoleplayer < len(players) and typeof(players[consoleplayer]) == "struct" then
        S_UpdateSounds(players[consoleplayer].mo)
      else
        S_UpdateSounds(void)
      end if
    end if

    if typeof(uncapped_render) != "void" and uncapped_render and typeof(I_GetTimeFrac) == "function" then
      render_lerp_frac = I_GetTimeFrac()
      if render_lerp_frac < 0 then render_lerp_frac = 0 end if
      if render_lerp_frac > 1 then render_lerp_frac = 1 end if
    else
      render_lerp_frac = 1.0
    end if

    D_Display()

    if typeof(I_UpdateSound) == "function" then I_UpdateSound() end if
    if typeof(I_SubmitSound) == "function" then I_SubmitSound() end if

    if devparm then
      debugTicks = debugTicks + 1
      if debugTicks >= 200 then
        print "D_DoomLoop: devparm debug stop after 200 frames"
        return
      end if
    end if
  end while
end function



