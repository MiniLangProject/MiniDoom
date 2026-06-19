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
import i_gl
import g_game
import hu_stuff
import wi_stuff
import st_stuff
import am_map
import p_setup
import r_local
import r_gl
import r_upscaled
import r_hires
import hdwad_builder
import tables
import std.fs as fs
import std.math
import std.time

const MAXWADFILES = 20
wadfiles =[]

/*
* Function: D_AddFile
* Purpose: Adds file entries to the Doom core.
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
_d_prof_tick_ms = 0
_d_prof_player_ms = 0
_d_prof_thinker_ms = 0
_d_prof_special_ms = 0
_d_prof_tics = 0
_d_prof_thinkers = 0
_d_prof_mobj_thinkers = 0
_d_prof_gl_dyn_ms = 0
_d_prof_gl_cache_ms = 0
_d_prof_gl_sky_ms = 0
_d_prof_gl_boundary_ms = 0
_d_prof_gl_depth_ms = 0
_d_prof_gl_flats_ms = 0
_d_prof_gl_walls_ms = 0
_d_prof_gl_sprites_ms = 0
_d_prof_gl_masked_ms = 0
_d_prof_gl_weapon_ms = 0
const D_PROFILE_LOG_PATH = "minidoom_profile.log"
d_force_wipe = false
_d_hdwad_status_text = ""
_d_hdwad_progress_start_ms = 0
_d_hdwad_progress_total = 0
_d_hdwad_progress_done = 0
_d_hdwad_progress_phase_base = 0
_d_hdwad_progress_phase_span = 0
_d_hdwad_progress_phase_done = 0
_d_hdwad_progress_phase_expected = 1
_d_hdwad_progress_last_draw_ms = 0

/*
* Function: D_ForceWipe
* Purpose: Provides wipe helper behavior for the Doom core.
*/
function D_ForceWipe()
  global d_force_wipe
  d_force_wipe = true
end function

/*
* Function: _D_TimeMs
* Purpose: Provides milliseconds helper behavior for the Doom core.
*/
function inline _D_TimeMs()
  t = std.time.ticks()
  if typeof(t) != "int" then return 0 end if
  return t
end function

/*
* Function: _D_ProfileAdd
* Purpose: Provides add helper behavior for the Doom core.
*/
function _D_ProfileAdd(slot, delta)
  global _d_prof_r_ms
  global _d_prof_st_ms
  global _d_prof_hu_ms
  global _d_prof_am_ms
  global _d_prof_other_ms
  global _d_prof_vid_ms
  global _d_prof_tick_ms
  global _d_prof_player_ms
  global _d_prof_thinker_ms
  global _d_prof_special_ms

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
  else if slot == 5 then
    _d_prof_vid_ms = _d_prof_vid_ms + delta
  else if slot == 6 then
    _d_prof_tick_ms = _d_prof_tick_ms + delta
  else if slot == 7 then
    _d_prof_player_ms = _d_prof_player_ms + delta
  else if slot == 8 then
    _d_prof_thinker_ms = _d_prof_thinker_ms + delta
  else
    _d_prof_special_ms = _d_prof_special_ms + delta
  end if
end function

/*
* Function: _D_ProfileGameTick
* Purpose: Counts one executed game tic for runtime profiling.
*/
function _D_ProfileGameTick()
  global _d_prof_tics
  if _d_profile_render then _d_prof_tics = _d_prof_tics + 1 end if
end function

/*
* Function: _D_ProfileThinker
* Purpose: Counts thinker execution and separates mobj thinkers for gameplay profiling.
*/
function _D_ProfileThinker(isMobj)
  global _d_prof_thinkers
  global _d_prof_mobj_thinkers
  if not _d_profile_render then return end if
  _d_prof_thinkers = _d_prof_thinkers + 1
  if typeof(isMobj) == "bool" and isMobj then _d_prof_mobj_thinkers = _d_prof_mobj_thinkers + 1 end if
end function

/*
* Function: _D_ProfileLog
* Purpose: Writes profiler output to stdout and to a log file for windows-subsystem builds.
*/
function _D_ProfileLog(line)
  if typeof(line) != "string" then return end if
  print line
  if typeof(fs.appendAllText) == "function" then
    fs.appendAllText(D_PROFILE_LOG_PATH, line + "\n")
  end if
end function

/*
* Function: _D_ProfileGLAdd
* Purpose: Accumulates fine-grained OpenGL renderer timings for the profile log.
*/
function _D_ProfileGLAdd(slot, delta)
  global _d_prof_gl_dyn_ms
  global _d_prof_gl_cache_ms
  global _d_prof_gl_sky_ms
  global _d_prof_gl_boundary_ms
  global _d_prof_gl_depth_ms
  global _d_prof_gl_flats_ms
  global _d_prof_gl_walls_ms
  global _d_prof_gl_sprites_ms
  global _d_prof_gl_masked_ms
  global _d_prof_gl_weapon_ms

  if not _d_profile_render then return end if
  if typeof(delta) != "int" then return end if
  if slot == 0 then
    _d_prof_gl_dyn_ms = _d_prof_gl_dyn_ms + delta
  else if slot == 1 then
    _d_prof_gl_cache_ms = _d_prof_gl_cache_ms + delta
  else if slot == 2 then
    _d_prof_gl_sky_ms = _d_prof_gl_sky_ms + delta
  else if slot == 3 then
    _d_prof_gl_boundary_ms = _d_prof_gl_boundary_ms + delta
  else if slot == 4 then
    _d_prof_gl_depth_ms = _d_prof_gl_depth_ms + delta
  else if slot == 5 then
    _d_prof_gl_flats_ms = _d_prof_gl_flats_ms + delta
  else if slot == 6 then
    _d_prof_gl_walls_ms = _d_prof_gl_walls_ms + delta
  else if slot == 7 then
    _d_prof_gl_sprites_ms = _d_prof_gl_sprites_ms + delta
  else if slot == 8 then
    _d_prof_gl_masked_ms = _d_prof_gl_masked_ms + delta
  else
    _d_prof_gl_weapon_ms = _d_prof_gl_weapon_ms + delta
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
* Purpose: Performs integer division with Doom core rounding and guard rules.
*/
function inline _D_IDiv(a, b)
  if typeof(a) != "int" or typeof(b) != "int" or b == 0 then return 0 end if
  q = a / b
  if q >= 0 then return std.math.floor(q) end if
  return std.math.ceil(q)
end function

/*
* Function: _D_ProfileFlushMaybe
* Purpose: Provides flush maybe helper behavior for the Doom core.
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
  global _d_prof_tick_ms
  global _d_prof_player_ms
  global _d_prof_thinker_ms
  global _d_prof_special_ms
  global _d_prof_tics
  global _d_prof_thinkers
  global _d_prof_mobj_thinkers
  global _d_prof_gl_dyn_ms
  global _d_prof_gl_cache_ms
  global _d_prof_gl_sky_ms
  global _d_prof_gl_boundary_ms
  global _d_prof_gl_depth_ms
  global _d_prof_gl_flats_ms
  global _d_prof_gl_walls_ms
  global _d_prof_gl_sprites_ms
  global _d_prof_gl_masked_ms
  global _d_prof_gl_weapon_ms

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
  tps = 0
  if elapsed > 0 then tps = _D_IDiv(_d_prof_tics * 1000, elapsed) end if
  _D_ProfileLog("PROFILE frame: fps=" + fps + " tics=" + _d_prof_tics + " tps=" + tps + " tick=" + _d_prof_tick_ms + "ms render=" + _d_prof_r_ms + "ms st=" + _d_prof_st_ms + "ms hu=" + _d_prof_hu_ms + "ms am=" + _d_prof_am_ms + "ms other=" + _d_prof_other_ms + "ms vid=" + _d_prof_vid_ms + "ms")
  _D_ProfileLog("PROFILE game: player=" + _d_prof_player_ms + "ms thinkers=" + _d_prof_thinker_ms + "ms specials=" + _d_prof_special_ms + "ms thinker_calls=" + _d_prof_thinkers + " mobj_calls=" + _d_prof_mobj_thinkers)
  _D_ProfileLog("PROFILE gl: dyn=" + _d_prof_gl_dyn_ms + "ms cache=" + _d_prof_gl_cache_ms + "ms sky=" + _d_prof_gl_sky_ms + "ms boundary=" + _d_prof_gl_boundary_ms + "ms depth=" + _d_prof_gl_depth_ms + "ms flats=" + _d_prof_gl_flats_ms + "ms walls=" + _d_prof_gl_walls_ms + "ms sprites=" + _d_prof_gl_sprites_ms + "ms masked=" + _d_prof_gl_masked_ms + "ms weapon=" + _d_prof_gl_weapon_ms + "ms")

  _d_prof_t0 = now
  _d_prof_frames = 0
  _d_prof_r_ms = 0
  _d_prof_st_ms = 0
  _d_prof_hu_ms = 0
  _d_prof_am_ms = 0
  _d_prof_other_ms = 0
  _d_prof_vid_ms = 0
  _d_prof_tick_ms = 0
  _d_prof_player_ms = 0
  _d_prof_thinker_ms = 0
  _d_prof_special_ms = 0
  _d_prof_tics = 0
  _d_prof_thinkers = 0
  _d_prof_mobj_thinkers = 0
  _d_prof_gl_dyn_ms = 0
  _d_prof_gl_cache_ms = 0
  _d_prof_gl_sky_ms = 0
  _d_prof_gl_boundary_ms = 0
  _d_prof_gl_depth_ms = 0
  _d_prof_gl_flats_ms = 0
  _d_prof_gl_walls_ms = 0
  _d_prof_gl_sprites_ms = 0
  _d_prof_gl_masked_ms = 0
  _d_prof_gl_weapon_ms = 0
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
* Purpose: Processes event events for the Doom core.
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
* Purpose: Processes events events for the Doom core.
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
* Purpose: Advances page Ticker logic during the Doom core tick.
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
* Purpose: Draws page Drawer output for the Doom core renderer.
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
* Purpose: Runs demo behavior for the Doom core.
*/
function D_AdvanceDemo()
  global advancedemo

  advancedemo = true
end function

/*
* Function: D_DoAdvanceDemo
* Purpose: Runs advance demo behavior for the Doom core.
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
* Purpose: Parses parse Wad Files From Args input into Doom core runtime data.
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
* Function: _D_ArgValue
* Purpose: Provides value helper behavior for the Doom core.
*/
function _D_ArgValue(flag)
  p = M_CheckParm(flag)
  if p == 0 or p >= myargc - 1 then return "" end if
  v = myargv[p + 1]
  if typeof(v) == "string" then return v end if
  return ""
end function

/*
* Function: _D_IsWadPath
* Purpose: Checks WAD path conditions for the Doom core.
*/
function _D_IsWadPath(path)
  if typeof(path) != "string" then return false end if
  b = bytes(path)
  if len(b) < 4 then return false end if
  dot = b[len(b) - 4]
  a = b[len(b) - 3]
  c = b[len(b) - 2]
  d = b[len(b) - 1]
  if dot >= 97 and dot <= 122 then dot = dot - 32 end if
  if a >= 97 and a <= 122 then a = a - 32 end if
  if c >= 97 and c <= 122 then c = c - 32 end if
  if d >= 97 and d <= 122 then d = d - 32 end if
  return dot == 46 and a == 87 and c == 65 and d == 68
end function

/*
* Function: _D_HDWADPathForWad
* Purpose: Provides path for WAD helper behavior for the Doom core.
*/
function _D_HDWADPathForWad(wad)
  return wad + ".hdwad"
end function

/*
* Function: _D_DigitAt
* Purpose: Provides at helper behavior for the Doom core.
*/
function _D_DigitAt(s, idx)
  if typeof(s) != "string" then return -1 end if
  b = bytes(s)
  if idx < 0 or idx >= len(b) then return -1 end if
  c = b[idx]
  if c < 48 or c > 57 then return -1 end if
  return c - 48
end function

/*
* Function: _D_MapNameFor
* Purpose: Provides name for helper behavior for the Doom core.
*/
function _D_MapNameFor(episode, map)
  if gamemode == GameMode_t.commercial then
    if map == 1 then return "MAP01" end if
    if map == 2 then return "MAP02" end if
    if map == 3 then return "MAP03" end if
    if map == 4 then return "MAP04" end if
    if map == 5 then return "MAP05" end if
    if map == 6 then return "MAP06" end if
    if map == 7 then return "MAP07" end if
    if map == 8 then return "MAP08" end if
    if map == 9 then return "MAP09" end if
    if map == 10 then return "MAP10" end if
    if map == 11 then return "MAP11" end if
    if map == 12 then return "MAP12" end if
    if map == 13 then return "MAP13" end if
    if map == 14 then return "MAP14" end if
    if map == 15 then return "MAP15" end if
    if map == 16 then return "MAP16" end if
    if map == 17 then return "MAP17" end if
    if map == 18 then return "MAP18" end if
    if map == 19 then return "MAP19" end if
    if map == 20 then return "MAP20" end if
    if map == 21 then return "MAP21" end if
    if map == 22 then return "MAP22" end if
    if map == 23 then return "MAP23" end if
    if map == 24 then return "MAP24" end if
    if map == 25 then return "MAP25" end if
    if map == 26 then return "MAP26" end if
    if map == 27 then return "MAP27" end if
    if map == 28 then return "MAP28" end if
    if map == 29 then return "MAP29" end if
    if map == 30 then return "MAP30" end if
    if map == 31 then return "MAP31" end if
    if map == 32 then return "MAP32" end if
    return "MAP01"
  end if
  if episode == 1 and map == 1 then return "E1M1" end if
  if episode == 1 and map == 2 then return "E1M2" end if
  if episode == 1 and map == 3 then return "E1M3" end if
  if episode == 1 and map == 4 then return "E1M4" end if
  if episode == 1 and map == 5 then return "E1M5" end if
  if episode == 1 and map == 6 then return "E1M6" end if
  if episode == 1 and map == 7 then return "E1M7" end if
  if episode == 1 and map == 8 then return "E1M8" end if
  if episode == 1 and map == 9 then return "E1M9" end if
  if episode == 2 and map == 1 then return "E2M1" end if
  if episode == 2 and map == 2 then return "E2M2" end if
  if episode == 2 and map == 3 then return "E2M3" end if
  if episode == 2 and map == 4 then return "E2M4" end if
  if episode == 2 and map == 5 then return "E2M5" end if
  if episode == 2 and map == 6 then return "E2M6" end if
  if episode == 2 and map == 7 then return "E2M7" end if
  if episode == 2 and map == 8 then return "E2M8" end if
  if episode == 2 and map == 9 then return "E2M9" end if
  if episode == 3 and map == 1 then return "E3M1" end if
  if episode == 3 and map == 2 then return "E3M2" end if
  if episode == 3 and map == 3 then return "E3M3" end if
  if episode == 3 and map == 4 then return "E3M4" end if
  if episode == 3 and map == 5 then return "E3M5" end if
  if episode == 3 and map == 6 then return "E3M6" end if
  if episode == 3 and map == 7 then return "E3M7" end if
  if episode == 3 and map == 8 then return "E3M8" end if
  if episode == 3 and map == 9 then return "E3M9" end if
  if episode == 4 and map == 1 then return "E4M1" end if
  if episode == 4 and map == 2 then return "E4M2" end if
  if episode == 4 and map == 3 then return "E4M3" end if
  if episode == 4 and map == 4 then return "E4M4" end if
  if episode == 4 and map == 5 then return "E4M5" end if
  if episode == 4 and map == 6 then return "E4M6" end if
  if episode == 4 and map == 7 then return "E4M7" end if
  if episode == 4 and map == 8 then return "E4M8" end if
  if episode == 4 and map == 9 then return "E4M9" end if
  return "E1M1"
end function

/*
* Function: _D_GeomNameForMapName
* Purpose: Provides name for map name helper behavior for the Doom core.
*/
function _D_GeomNameForMapName(mapName)
  return mapName + "GL"
end function

/*
* Function: _D_IsMapMarkerName
* Purpose: Checks map marker name conditions for the Doom core.
*/
function _D_IsMapMarkerName(name)
  if typeof(name) != "string" then return false end if
  b = bytes(name)
  if len(b) == 5 and b[0] == 77 and b[1] == 65 and b[2] == 80 then
    return _D_DigitAt(name, 3) >= 0 and _D_DigitAt(name, 4) >= 0
  end if
  if len(b) == 4 and b[0] == 69 and b[2] == 77 then
    return _D_DigitAt(name, 1) >= 0 and _D_DigitAt(name, 3) >= 0
  end if
  return false
end function

/*
* Function: _D_MapPairsFromLumps
* Purpose: Provides pairs from lumps helper behavior for the Doom core.
*/
function _D_MapPairsFromLumps(lumps)
  maps =[]
  if typeof(lumps) != "array" then return maps end if
  i = 0
  while i < len(lumps)
    l = lumps[i]
    if l is not void and typeof(l.name) == "string" and _D_IsMapMarkerName(l.name) then
      if gamemode == GameMode_t.commercial then
        map = _D_DigitAt(l.name, 3) * 10 + _D_DigitAt(l.name, 4)
        maps = maps +[[1, map, l.name]]
      else
        ep = _D_DigitAt(l.name, 1)
        map = _D_DigitAt(l.name, 3)
        maps = maps +[[ep, map, l.name]]
      end if
    end if
    i = i + 1
  end while
  return maps
end function

/*
* Function: _D_ReadHDWADLumpNames
* Purpose: Reads HDWAD lump names data for the Doom core.
*/
function _D_ReadHDWADLumpNames(path)
  names =[]
  if typeof(path) != "string" or not fs.exists(path) or not fs.isFile(path) then return names end if
  dataTry = try(fs.readAllBytes(path))
  if typeof(dataTry) == "error" then return names end if
  data = dataTry
  if typeof(data) != "bytes" or len(data) < 28 then return names end if
  if data[0] != 77 or data[1] != 68 or data[2] != 72 or data[3] != 68 then return names end if
  version = data[4] +(data[5] << 8) +(data[6] << 16) +(data[7] << 24)
  if version != 6 then return names end if
  lumpCount = data[12] +(data[13] << 8) +(data[14] << 16) +(data[15] << 24)
  imageCount = data[16] +(data[17] << 8) +(data[18] << 16) +(data[19] << 24)
  lumpDirOfs = data[20] +(data[21] << 8) +(data[22] << 16) +(data[23] << 24)
  imageDirOfs = data[24] +(data[25] << 8) +(data[26] << 16) +(data[27] << 24)
  if lumpCount <= 0 or imageCount <= 0 then return names end if
  if lumpDirOfs < 28 or lumpDirOfs + lumpCount * 16 > len(data) then return names end if
  if imageDirOfs < 28 or imageDirOfs + imageCount * 40 > len(data) then return names end if
  i = 0
  while i < lumpCount
    off = lumpDirOfs + i * 16 + 8
    names = names +[decodeZ(slice(data, off, 8))]
    i = i + 1
  end while
  return names
end function

/*
* Function: _D_NameInList
* Purpose: Provides in list helper behavior for the Doom core.
*/
function _D_NameInList(names, name)
  if typeof(names) != "array" then return false end if
  i = 0
  while i < len(names)
    if names[i] == name then return true end if
    i = i + 1
  end while
  return false
end function

/*
* Function: _D_HDWADLooksComplete
* Purpose: Provides looks complete helper behavior for the Doom core.
*/
function _D_HDWADLooksComplete(path)
  names = _D_ReadHDWADLumpNames(path)
  if len(names) == 0 then return false end if
  mapCount = 0
  i = 0
  while i < len(names)
    n = names[i]
    if _D_IsMapMarkerName(n) then
      mapCount = mapCount + 1
      if not _D_NameInList(names, _D_GeomNameForMapName(n)) then return false end if
    end if
    i = i + 1
  end while
  return mapCount > 0
end function

/*
* Function: _D_HDWADScaleFromArgs
* Purpose: Provides scale from args helper behavior for the Doom core.
*/
function _D_HDWADScaleFromArgs()
  return 3
end function

/*
* Function: _D_HDWADFontLump
* Purpose: Builds the STCFN lump name used for HDWAD loading text.
*/
function _D_HDWADFontLump(code)
  h = _D_IDiv(code, 100) % 10
  t = _D_IDiv(code, 10) % 10
  o = code % 10
  return "STCFN" + h + t + o
end function

/*
* Function: _D_HDWADTextByte
* Purpose: Normalizes one byte for the HDWAD loading font.
*/
function inline _D_HDWADTextByte(c)
  if c >= 97 and c <= 122 then return c - 32 end if
  return c
end function

/*
* Function: _D_HDWADPatchWidth
* Purpose: Reads a Doom patch width without depending on renderer init.
*/
function inline _D_HDWADPatchWidth(patch)
  if typeof(patch) != "bytes" or len(patch) < 2 then return 0 end if
  v = patch[0] +(patch[1] << 8)
  if v >= 32768 then v = v - 65536 end if
  return v
end function

/*
* Function: _D_HDWADTextWidth
* Purpose: Measures loading text using Doom STCFN font patches.
*/
function _D_HDWADTextWidth(text)
  if typeof(text) != "string" then return 0 end if
  b = bytes(text)
  w = 0
  i = 0
  while i < len(b)
    c = _D_HDWADTextByte(b[i])
    if c == 0 or c == 10 then break end if
    if c == 32 then
      w = w + 4
    else
      name = _D_HDWADFontLump(c)
      if typeof(W_CheckNumForName) == "function" and W_CheckNumForName(name) != -1 then
        patch = W_CacheLumpName(name, PU_CACHE)
        w = w + _D_HDWADPatchWidth(patch)
      else
        w = w + 4
      end if
    end if
    i = i + 1
  end while
  return w
end function

/*
* Function: _D_HDWADDrawText
* Purpose: Draws centered loading text with Doom STCFN font patches.
*/
function _D_HDWADDrawText(text, y)
  if typeof(text) != "string" then return end if
  b = bytes(text)
  x = 160 - _D_IDiv(_D_HDWADTextWidth(text), 2)
  if x < 0 then x = 0 end if
  i = 0
  while i < len(b)
    c = _D_HDWADTextByte(b[i])
    if c == 0 or c == 10 then break end if
    if c == 32 then
      x = x + 4
    else
      name = _D_HDWADFontLump(c)
      if typeof(W_CheckNumForName) == "function" and W_CheckNumForName(name) != -1 then
        patch = W_CacheLumpName(name, PU_CACHE)
        V_DrawPatchDirect(x, y, 0, patch)
        x = x + _D_HDWADPatchWidth(patch)
      else
        x = x + 4
      end if
    end if
    i = i + 1
  end while
end function

/*
* Function: _D_HDWADDurationText
* Purpose: Formats a millisecond duration for the HDWAD loading progress line.
*/
function _D_HDWADDurationText(ms)
  if typeof(ms) != "int" or ms <= 0 then return "--" end if
  sec = _D_IDiv(ms + 999, 1000)
  if sec < 1 then sec = 1 end if
  min = _D_IDiv(sec, 60)
  rem = sec % 60
  if min > 0 then return ("" + min) + "m " + rem + "s" end if
  return ("" + sec) + "s"
end function

/*
* Function: _D_HDWADProgressLine
* Purpose: Builds the second HDWAD loading line with percent and remaining time.
*/
function _D_HDWADProgressLine()
  if _d_hdwad_progress_total <= 0 then return "" end if
  done = _d_hdwad_progress_done
  if done < 0 then done = 0 end if
  if done > _d_hdwad_progress_total then done = _d_hdwad_progress_total end if
  pct = _D_IDiv(done * 100, _d_hdwad_progress_total)
  if pct < 0 then pct = 0 end if
  if pct > 100 then pct = 100 end if

  eta = "--"
  now = _D_TimeMs()
  elapsed = now - _d_hdwad_progress_start_ms
  if done > 0 and done < _d_hdwad_progress_total and elapsed > 0 then
    remaining = _D_IDiv(elapsed * (_d_hdwad_progress_total - done), done)
    eta = _D_HDWADDurationText(remaining)
  else if done >= _d_hdwad_progress_total then
    eta = "0s"
  end if
  return ("" + pct) + "%  REMAINING " + eta
end function

/*
* Function: _D_HDWADDrawLoadingScreen
* Purpose: Presents TITLEPIC with centered Doom-font HDWAD progress text.
*/
function _D_HDWADDrawLoadingScreen(text)
  if typeof(screens) != "array" or len(screens) == 0 or typeof(screens[0]) != "bytes" then return end if
  if typeof(V_ClearHighresOverlay) == "function" then V_ClearHighresOverlay() end if
  if typeof(V_ClearOverlayMask) == "function" then V_ClearOverlayMask() end if
  if typeof(I_SetPalette) == "function" and typeof(W_CheckNumForName) == "function" and W_CheckNumForName("PLAYPAL") != -1 then
    I_SetPalette(W_CacheLumpName("PLAYPAL", PU_CACHE))
  end if
  if typeof(W_CheckNumForName) == "function" and W_CheckNumForName("TITLEPIC") != -1 then
    V_DrawPatch(0, 0, 0, W_CacheLumpName("TITLEPIC", PU_CACHE))
  else
    fillBytes(screens[0], 0, SCREENWIDTH * SCREENHEIGHT, 0)
  end if
  _D_HDWADDrawText(text, 88)
  progress = _D_HDWADProgressLine()
  if progress != "" then _D_HDWADDrawText(progress, 104) end if
  if typeof(V_EndOverlayMask) == "function" then V_EndOverlayMask() end if
  if typeof(I_FinishUpdate) == "function" then I_FinishUpdate() end if
end function

/*
* Function: _D_HDWADProgressReset
* Purpose: Clears HDWAD loading progress state.
*/
function _D_HDWADProgressReset()
  global _d_hdwad_status_text
  global _d_hdwad_progress_start_ms
  global _d_hdwad_progress_total
  global _d_hdwad_progress_done
  global _d_hdwad_progress_phase_base
  global _d_hdwad_progress_phase_span
  global _d_hdwad_progress_phase_done
  global _d_hdwad_progress_phase_expected
  global _d_hdwad_progress_last_draw_ms

  _d_hdwad_status_text = ""
  _d_hdwad_progress_start_ms = 0
  _d_hdwad_progress_total = 0
  _d_hdwad_progress_done = 0
  _d_hdwad_progress_phase_base = 0
  _d_hdwad_progress_phase_span = 0
  _d_hdwad_progress_phase_done = 0
  _d_hdwad_progress_phase_expected = 1
  _d_hdwad_progress_last_draw_ms = 0
end function

/*
* Function: _D_HDWADSetProgressPhase
* Purpose: Starts a weighted HDWAD generation phase.
*/
function _D_HDWADSetProgressPhase(text, basePct, spanPct, expectedUnits)
  global _d_hdwad_progress_start_ms
  global _d_hdwad_progress_total
  global _d_hdwad_progress_done
  global _d_hdwad_progress_phase_base
  global _d_hdwad_progress_phase_span
  global _d_hdwad_progress_phase_done
  global _d_hdwad_progress_phase_expected

  if _d_hdwad_progress_start_ms <= 0 then _d_hdwad_progress_start_ms = _D_TimeMs() end if
  _d_hdwad_progress_total = 10000
  _d_hdwad_progress_phase_base = basePct * 100
  _d_hdwad_progress_phase_span = spanPct * 100
  _d_hdwad_progress_phase_done = 0
  _d_hdwad_progress_phase_expected = expectedUnits
  if _d_hdwad_progress_phase_expected <= 0 then _d_hdwad_progress_phase_expected = 1 end if
  _d_hdwad_progress_done = _d_hdwad_progress_phase_base
  _D_HDWADStatus(text)
end function

/*
* Function: _D_HDWADFinishProgressPhase
* Purpose: Completes the current weighted HDWAD generation phase.
*/
function _D_HDWADFinishProgressPhase()
  global _d_hdwad_progress_done
  global _d_hdwad_progress_phase_done
  _d_hdwad_progress_phase_done = _d_hdwad_progress_phase_expected
  _d_hdwad_progress_done = _d_hdwad_progress_phase_base + _d_hdwad_progress_phase_span
  if _d_hdwad_progress_done > _d_hdwad_progress_total then _d_hdwad_progress_done = _d_hdwad_progress_total end if
  if _d_hdwad_status_text != "" then _D_HDWADDrawLoadingScreen(_d_hdwad_status_text) end if
end function

/*
* Function: D_HDWADProgressStep
* Purpose: Advances the visible HDWAD generation progress from builder callbacks.
*/
function D_HDWADProgressStep(units)
  global _d_hdwad_progress_done
  global _d_hdwad_progress_phase_done
  global _d_hdwad_progress_last_draw_ms

  if typeof(units) != "int" or units <= 0 then units = 1 end if
  if _d_hdwad_progress_total <= 0 or _d_hdwad_progress_phase_span <= 0 then
    if typeof(I_LoadingPulse) == "function" then I_LoadingPulse() end if
    return
  end if

  _d_hdwad_progress_phase_done = _d_hdwad_progress_phase_done + units
  if _d_hdwad_progress_phase_done > _d_hdwad_progress_phase_expected then _d_hdwad_progress_phase_done = _d_hdwad_progress_phase_expected end if
  _d_hdwad_progress_done = _d_hdwad_progress_phase_base + _D_IDiv(_d_hdwad_progress_phase_span * _d_hdwad_progress_phase_done, _d_hdwad_progress_phase_expected)
  if _d_hdwad_progress_done > _d_hdwad_progress_total then _d_hdwad_progress_done = _d_hdwad_progress_total end if

  now = _D_TimeMs()
  if _d_hdwad_progress_last_draw_ms == 0 or now - _d_hdwad_progress_last_draw_ms >= 250 then
    _d_hdwad_progress_last_draw_ms = now
    if _d_hdwad_status_text != "" then
      _D_HDWADDrawLoadingScreen(_d_hdwad_status_text)
    else if typeof(I_LoadingPulse) == "function" then
      I_LoadingPulse()
    end if
  else if typeof(I_LoadingPulse) == "function" then
    I_LoadingPulse()
  end if
end function

/*
* Function: _D_HDWADStatus
* Purpose: Shows the current HDWAD generation phase in the application title.
*/
function _D_HDWADStatus(text)
  global _d_hdwad_status_text
  if typeof(text) != "string" then text = "" end if
  _d_hdwad_status_text = text
  titleText = text
  progress = _D_HDWADProgressLine()
  if titleText != "" and progress != "" then titleText = titleText + " " + progress end if
  if typeof(I_SetLoadingStatus) == "function" then I_SetLoadingStatus(titleText) end if
  if text != "" then
    _D_HDWADDrawLoadingScreen(text)
  else if typeof(I_LoadingPulse) == "function" then
    I_LoadingPulse()
  end if
  if text == "" then _D_HDWADProgressReset() end if
end function

/*
* Function: _D_GenerateHDWADCacheAfterInit
* Purpose: Initializes generate HDWADCache After Init state for the Doom core system.
*/
function _D_GenerateHDWADCacheAfterInit()
  global wadfiles
  global gameepisode
  global gamemap
  global gameskill
  global gamestate
  global precache

  if M_CheckParm("-nohdwad") != 0 or M_CheckParm("--nohdwad") != 0 then return end if
  if M_CheckParm("-hdwad") != 0 or M_CheckParm("--hdwad") != 0 then return end if
  if typeof(IGL_WantsOpenGL) == "function" and not IGL_WantsOpenGL() then return end if
  if typeof(wadfiles) != "array" or len(wadfiles) == 0 then return end if

  wad = wadfiles[0]
  if typeof(wad) != "string" or not _D_IsWadPath(wad) then return end if
  hd = _D_HDWADPathForWad(wad)
  rebuild = M_CheckParm("-rebuildhdwad") != 0 or M_CheckParm("--rebuildhdwad") != 0
  if (not rebuild) and fs.exists(hd) and fs.isFile(hd) and _D_HDWADLooksComplete(hd) then return false end if

  if typeof(I_InitGraphics) == "function" then I_InitGraphics() end if
  _D_HDWADProgressReset()
  _D_HDWADSetProgressPhase("Generating HDWAD...", 0, 5, 1)

  loaded = HDB_LoadWadForBuild(wad)
  if loaded is void then
    print "HDWAD: cannot generate cache because original WAD is missing or invalid: " + wad
    _D_HDWADStatus("")
    return false
  end if
  D_HDWADProgressStep(1)
  _D_HDWADFinishProgressPhase()

  wadData = loaded[0]
  lumps = loaded[1]
  maps = _D_MapPairsFromLumps(lumps)
  scale = _D_HDWADScaleFromArgs()

  print "HDWAD: generating complete cache " + hd
  imageUnits = 1
  if typeof(HDB_EstimateImageProgressUnits) == "function" then imageUnits = HDB_EstimateImageProgressUnits(wadData, lumps, scale) end if
  _D_HDWADSetProgressPhase("Generating HDWAD graphics...", 5, 60, imageUnits)
  images = HDB_BuildImages(wadData, lumps, scale)
  _D_HDWADFinishProgressPhase()
  if len(images) == 0 then
    print "HDWAD: no HD images generated"
    _D_HDWADStatus("")
    return false
  end if

  oldEpisode = gameepisode
  oldMap = gamemap
  oldSkill = gameskill
  oldState = gamestate
  oldPrecache = precache
  precache = false

  extraNames =[]
  extraDatas =[]
  geometryUnits = len(maps)
  if geometryUnits < 1 then geometryUnits = 1 end if
  _D_HDWADSetProgressPhase("Generating HDWAD geometry...", 65, 25, geometryUnits)
  i = 0
  while i < len(maps)
    mp = maps[i]
    ep = mp[0]
    map = mp[1]
    print "HDWAD: building GL geometry " + mp[2]
    _D_HDWADStatus("Generating HDWAD geometry " + mp[2] + "...")
    P_SetupLevel(ep, map, 0, skill_t.sk_medium)
    geom = RGL_BuildCurrentMapGeometryLump()
    if typeof(geom) == "array" and len(geom) >= 2 and typeof(geom[0]) == "string" and typeof(geom[1]) == "bytes" then
      extraNames = extraNames +[geom[0]]
      extraDatas = extraDatas +[geom[1]]
    end if
    D_HDWADProgressStep(1)
    i = i + 1
  end while
  _D_HDWADFinishProgressPhase()

  precache = oldPrecache
  gameepisode = oldEpisode
  gamemap = oldMap
  gameskill = oldSkill
  gamestate = oldState

  _D_HDWADSetProgressPhase("Writing HDWAD...", 90, 5, 1)
  if not HDB_WriteHDWAD(hd, wadData, lumps, images, extraNames, extraDatas, scale) then
    _D_HDWADStatus("")
    return false
  end if
  D_HDWADProgressStep(1)
  _D_HDWADFinishProgressPhase()

  _D_HDWADSetProgressPhase("Loading HDWAD...", 95, 5, 1)
  wadfiles =[wad]
  W_InitMultipleFiles(wadfiles)
  if typeof(RU_Init) == "function" then RU_Init(hd) end if
  if typeof(RH_Init) == "function" then RH_Init() end if
  M_Init()
  R_Init()
  P_Init()
  D_HDWADProgressStep(1)
  _D_HDWADFinishProgressPhase()
  _D_HDWADStatus("")
  return true
end function

/*
* Function: _D_AddDemoLmpFromArgs
* Purpose: Adds demo lump from args entries to the Doom core.
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
* Purpose: Reads file Readable data from the Doom core data stream.
*/
function inline _D_FileReadable(path)
  if typeof(path) != "string" or len(path) == 0 then return false end if
  if not fs.exists(path) then return false end if
  if not fs.isFile(path) then return false end if

  return true
end function

/*
* Function: _D_ToLowerAscii
* Purpose: Converts lower ASCII values for the Doom core.
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
* Purpose: Provides contains helper behavior for the Doom core.
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
* Purpose: Checks response token byte conditions for the Doom core.
*/
function inline _D_IsResponseTokenByte(c)
  return c >= 33 and c <= 122
end function

/*
* Function: _D_ParseResponseArgs
* Purpose: Parses parse Response Args input into Doom core runtime data.
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
* Purpose: Provides version helper behavior for the Doom core.
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
* Purpose: Computes response file values for the Doom core.
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
* Purpose: Runs the main Doom core entry point.
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
  if _d_profile_render and typeof(fs.writeAllText) == "function" then
    fs.writeAllText(D_PROFILE_LOG_PATH, "MiniDoom profile log\n")
  end if
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
  if typeof(RU_Init) == "function" then
    iw = ""
    if typeof(wadfiles) == "array" and len(wadfiles) > 0 then iw = wadfiles[0] end if
    RU_Init(iw)
  end if
  if typeof(RH_Init) == "function" then RH_Init() end if
  if typeof(M_Init) == "function" then M_Init() end if
  if devparm then print "D_DoomMain: M_Init done" end if
  if typeof(R_Init) == "function" then R_Init() end if
  if devparm then print "D_DoomMain: R_Init done" end if
  if typeof(P_Init) == "function" then P_Init() end if
  if devparm then print "D_DoomMain: P_Init done" end if
  _D_GenerateHDWADCacheAfterInit()
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
* Purpose: Draws display output for the Doom core.
*/
function D_Display()
  global _d_profile_render
  global _d_prof_frames
  global wipegamestate
  global d_force_wipe

  if typeof(nodrawers) != "void" and nodrawers then
    return
  end if

  profiling = _d_profile_render
  keepStatusOverlay = false
  if gamestate == gamestate_t.GS_LEVEL and typeof(IGL_IsActive) == "function" and IGL_IsActive() then
    if typeof(viewheight) == "int" and viewheight < SCREENHEIGHT then keepStatusOverlay = true end if
  end if
  if keepStatusOverlay and typeof(V_ClearHighresOverlayKeepLogicalY) == "function" then
    V_ClearHighresOverlayKeepLogicalY(ST_Y)
  else if typeof(V_ClearHighresOverlay) == "function" then
    V_ClearHighresOverlay()
  end if

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
  if gamestate != wipegamestate or d_force_wipe then
    wipe = true
    d_force_wipe = false
    levelRefresh = true
    if typeof(wipe_StartScreen) == "function" then
      wipe_StartScreen(0, 0, SCREENWIDTH, SCREENHEIGHT)
    end if
  end if

  glWipeToLevel = false
  if wipe and typeof(IGL_IsActive) == "function" and IGL_IsActive() then
    glWipeToLevel = true
  end if
  if glWipeToLevel and typeof(I_BeginHDWipe) == "function" then
    if not I_BeginHDWipe() then
      glWipeToLevel = false
    end if
  end if
  forceSoftwareWipe = false
  if wipe and gamestate == gamestate_t.GS_LEVEL and not glWipeToLevel then
    forceSoftwareWipe = true
  end if
  if typeof(RGL_SetForceSoftware) == "function" then RGL_SetForceSoftware(forceSoftwareWipe) end if
  if typeof(RH_SetForceLogical) == "function" then RH_SetForceLogical(forceSoftwareWipe) end if
  if typeof(I_SetForceSoftwarePresent) == "function" then I_SetForceSoftwarePresent(forceSoftwareWipe or glWipeToLevel) end if
  if forceSoftwareWipe and typeof(R_SetViewSize) == "function" then
    R_SetViewSize(setblocks, setdetail)
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
  if typeof(I_CaptureLogicalOverlayBase) == "function" then I_CaptureLogicalOverlayBase() end if
  if typeof(V_ClearOverlayMask) == "function" then V_ClearOverlayMask() end if
  if (not forceSoftwareWipe) and (not glWipeToLevel) and typeof(M_Drawer) == "function" then M_Drawer() end if
  if typeof(V_EndOverlayMask) == "function" then V_EndOverlayMask() end if
  mpAuthoritative = false
  if typeof(MP_PlatformIsHosting) == "function" and MP_PlatformIsHosting() then mpAuthoritative = true end if
  if typeof(MP_PlatformIsClientConnected) == "function" and MP_PlatformIsClientConnected() then mpAuthoritative = true end if
  // TryRunTics already runs NetUpdate in authoritative MP mode; avoid duplicate per-frame network ticks here.
  if (not mpAuthoritative) and typeof(NetUpdate) == "function" then NetUpdate() end if

  wipegamestate = gamestate

  if not wipe then
    if typeof(RGL_SetForceSoftware) == "function" then RGL_SetForceSoftware(false) end if
    if typeof(RH_SetForceLogical) == "function" then RH_SetForceLogical(false) end if
    if typeof(I_SetForceSoftwarePresent) == "function" then I_SetForceSoftwarePresent(false) end if
    if forceSoftwareWipe and typeof(R_SetViewSize) == "function" then
      R_SetViewSize(setblocks, setdetail)
    end if
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
    if typeof(RGL_SetForceSoftware) == "function" then RGL_SetForceSoftware(false) end if
    if typeof(RH_SetForceLogical) == "function" then RH_SetForceLogical(false) end if
    if typeof(I_SetForceSoftwarePresent) == "function" then I_SetForceSoftwarePresent(false) end if
    if forceSoftwareWipe and typeof(R_SetViewSize) == "function" then
      R_SetViewSize(setblocks, setdetail)
    end if
    if profiling then
      _d_prof_frames = _d_prof_frames + 1
      _D_ProfileFlushMaybe()
    end if
    return
  end if

  if glWipeToLevel and typeof(I_PrepareHDWipeEnd) == "function" and typeof(I_HDScreenWipe) == "function" and I_PrepareHDWipeEnd() then
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

      done = I_HDScreenWipe(tics)
      if typeof(I_UpdateNoBlit) == "function" then I_UpdateNoBlit() end if
      if typeof(I_UpdateSound) == "function" then I_UpdateSound() end if
      if typeof(I_SubmitSound) == "function" then I_SubmitSound() end if
    end while

    if typeof(RGL_SetForceSoftware) == "function" then RGL_SetForceSoftware(false) end if
    if typeof(RH_SetForceLogical) == "function" then RH_SetForceLogical(false) end if
    if typeof(I_SetForceSoftwarePresent) == "function" then I_SetForceSoftwarePresent(false) end if
    if profiling then
      _d_prof_frames = _d_prof_frames + 1
      _D_ProfileFlushMaybe()
    end if
    return
  end if

  if glWipeToLevel and typeof(I_CaptureGLFrameToScreen) == "function" then
    if not I_CaptureGLFrameToScreen() then
      glWipeToLevel = false
      forceSoftwareWipe = true
      if typeof(RGL_SetForceSoftware) == "function" then RGL_SetForceSoftware(true) end if
      if typeof(RH_SetForceLogical) == "function" then RH_SetForceLogical(true) end if
      if typeof(R_SetViewSize) == "function" then R_SetViewSize(setblocks, setdetail) end if
      if typeof(R_RenderPlayerView) == "function" then
        if typeof(players) == "array" and displayplayer < len(players) then
          R_RenderPlayerView(players[displayplayer])
        else
          R_RenderPlayerView(void)
        end if
      end if
      if typeof(ST_Drawer) == "function" then ST_Drawer(false, true) end if
      if typeof(HU_Drawer) == "function" then HU_Drawer() end if
    end if
  end if

  if glWipeToLevel and typeof(wipe_EndScreenFromBuffer) == "function" and typeof(screens) == "array" and len(screens) > 0 then
    wipe_EndScreenFromBuffer(0, 0, SCREENWIDTH, SCREENHEIGHT, screens[0])
  else
    wipe_EndScreen(0, 0, SCREENWIDTH, SCREENHEIGHT)
  end if
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
    if (not forceSoftwareWipe) and (not glWipeToLevel) and typeof(M_Drawer) == "function" then M_Drawer() end if
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

  if typeof(RGL_SetForceSoftware) == "function" then RGL_SetForceSoftware(false) end if
  if typeof(RH_SetForceLogical) == "function" then RH_SetForceLogical(false) end if
  if typeof(I_SetForceSoftwarePresent) == "function" then I_SetForceSoftwarePresent(false) end if
  if forceSoftwareWipe and typeof(R_SetViewSize) == "function" then
    R_SetViewSize(setblocks, setdetail)
  end if

  if profiling then
    _d_prof_frames = _d_prof_frames + 1
    _D_ProfileFlushMaybe()
  end if
end function

/*
* Function: D_DoomLoop
* Purpose: Provides loop helper behavior for the Doom core.
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
      if _d_profile_render then
        t0 = _D_TimeMs()
        TryRunTics()
        _D_ProfileAdd(6, _D_TimeMs() - t0)
      else
        TryRunTics()
      end if
    else
      if typeof(I_StartTic) == "function" then I_StartTic() end if
      D_ProcessEvents()
      if typeof(G_Ticker) == "function" then
        if _d_profile_render then
          t0 = _D_TimeMs()
          G_Ticker()
          _D_ProfileAdd(6, _D_TimeMs() - t0)
        else
          G_Ticker()
        end if
      end if
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



