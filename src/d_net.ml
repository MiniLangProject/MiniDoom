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

  Script: d_net.ml
  Purpose: Defines core Doom data types, shared state, and bootstrap flow.
*/
import d_player
import m_menu
import i_system
import i_video
import i_net
import g_game
import doomdef
import doomstat
import std.math

const DOOMCOM_ID = 0x12345678
const MAXNETNODES = 8
const BACKUPTICS = 12
const RESENDCOUNT = 10
const PL_DRONE = 0x80

const NCMD_EXIT = 0x80000000
const NCMD_RETRANSMIT = 0x40000000
const NCMD_SETUP = 0x20000000
const NCMD_KILL = 0x10000000
const NCMD_CHECKSUM = 0x0fffffff

/*
* Enum: command_t
* Purpose: Defines named constants for command type.
*/
enum command_t
  CMD_SEND = 1
  CMD_GET = 2
end enum

/*
* Struct: doomdata_t
* Purpose: Stores runtime data for doomdata type.
*/
struct doomdata_t
  checksum
  retransmitfrom
  starttic
  player
  numtics
  cmds
end struct

/*
* Struct: doomcom_t
* Purpose: Stores runtime data for doomcom type.
*/
struct doomcom_t
  id
  intnum
  command
  remotenode
  datalength

  numnodes
  ticdup
  extratics
  deathmatch
  savegame
  episode
  map
  skill

  consoleplayer
  numplayers
  angleoffset
  drone

  data
end struct

doomcom = void
netbuffer = void

localcmds =[]
netcmds =[]
nettics =[]
nodeingame =[]
remoteresend =[]
resendto =[]
resendcount =[]
nodeforplayer =[]

maketic = 0
lastnettic = 0
skiptics = 0
ticdup = 1
maxsend = 1
gametime = 0

reboundpacket = false
reboundstore = void

_dnet_exitmsg = ""
_dnet_oldentertics = -1
_dnet_oldnettics = 0
_dnet_frameon = 0
_dnet_frameskip =[false, false, false, false]
d_runtics_last = 0

/*
* Function: _DNet_DefaultCmds
* Purpose: Implements the _DNet_DefaultCmds routine for the internal module support.
*/
function _DNet_DefaultCmds()

  a =[]
  i = 0
  while i < BACKUPTICS
    a = a +[ticcmd_t(0, 0, 0, 0, 0, 0)]
    i = i + 1
  end while
  return a
end function

/*
* Function: _DNet_IsSeq
* Purpose: Implements the _DNet_IsSeq routine for the internal module support.
*/
function _DNet_IsSeq(v)
  t = typeof(v)
  return t == "array" or t == "list"
end function

/*
* Function: _DNet_ToInt
* Purpose: Implements the _DNet_ToInt routine for the internal module support.
*/
function _DNet_ToInt(v, fallback)
  if typeof(v) == "int" then return v end if
  if typeof(v) == "float" then
    if v >= 0 then return std.math.floor(v) end if
    return std.math.ceil(v)
  end if
  n = toNumber(v)
  if typeof(n) == "int" then return n end if
  if typeof(n) == "float" then
    if n >= 0 then return std.math.floor(n) end if
    return std.math.ceil(n)
  end if
  return fallback
end function

/*
* Function: _DNet_IDiv
* Purpose: Implements the _DNet_IDiv routine for the internal module support.
*/
function _DNet_IDiv(a, b)
  ai = _DNet_ToInt(a, 0)
  bi = _DNet_ToInt(b, 0)
  if bi == 0 then return 0 end if

  q = ai / bi
  if q >= 0 then return std.math.floor(q) end if
  return std.math.ceil(q)
end function

/*
* Function: _DNet_EnsureStateArrays
* Purpose: Implements the _DNet_EnsureStateArrays routine for the internal module support.
*/
function _DNet_EnsureStateArrays()
  global localcmds
  global netcmds
  global nettics
  global nodeingame
  global remoteresend
  global resendto
  global resendcount
  global nodeforplayer

  if not _DNet_IsSeq(localcmds) or len(localcmds) != BACKUPTICS then
    localcmds = _DNet_DefaultCmds()
  end if

  if not _DNet_IsSeq(netcmds) or len(netcmds) != MAXPLAYERS then
    netcmds =[]
    i = 0
    while i < MAXPLAYERS
      netcmds = netcmds +[_DNet_DefaultCmds()]
      i = i + 1
    end while
  end if

  if not _DNet_IsSeq(nettics) or len(nettics) != MAXNETNODES then
    nettics =[]
    nodeingame =[]
    remoteresend =[]
    resendto =[]
    resendcount =[]
    i = 0
    while i < MAXNETNODES
      nettics = nettics +[0]
      nodeingame = nodeingame +[false]
      remoteresend = remoteresend +[false]
      resendto = resendto +[0]
      resendcount = resendcount +[0]
      i = i + 1
    end while
  end if

  if not _DNet_IsSeq(nodeforplayer) or len(nodeforplayer) != MAXPLAYERS then
    nodeforplayer =[]
    i = 0
    while i < MAXPLAYERS
      nodeforplayer = nodeforplayer +[0]
      i = i + 1
    end while
  end if
end function

/*
* Function: _DNet_CopyCmd
* Purpose: Implements the _DNet_CopyCmd routine for the internal module support.
*/
function _DNet_CopyCmd(src)
  if src is void then return ticcmd_t(0, 0, 0, 0, 0, 0) end if
  return ticcmd_t(
  _DNet_ToInt(src.forwardmove, 0),
  _DNet_ToInt(src.sidemove, 0),
  _DNet_ToInt(src.angleturn, 0),
  _DNet_ToInt(src.consistancy, 0),
  _DNet_ToInt(src.chatchar, 0),
  _DNet_ToInt(src.buttons, 0)
)
end function

/*
* Function: _DNet_MakeStoreFromBuffer
* Purpose: Implements the _DNet_MakeStoreFromBuffer routine for the internal module support.
*/
function _DNet_MakeStoreFromBuffer()
  if netbuffer is void then return doomdata_t(0, 0, 0, 0, 0, _DNet_DefaultCmds()) end if
  cmdcopy = _DNet_DefaultCmds()
  i = 0
  while i < BACKUPTICS
    if _DNet_IsSeq(netbuffer.cmds) and i < len(netbuffer.cmds) then
      cmdcopy[i] = _DNet_CopyCmd(netbuffer.cmds[i])
    end if
    i = i + 1
  end while
  return doomdata_t(
  _DNet_ToInt(netbuffer.checksum, 0),
  _DNet_ToInt(netbuffer.retransmitfrom, 0),
  _DNet_ToInt(netbuffer.starttic, 0),
  _DNet_ToInt(netbuffer.player, 0),
  _DNet_ToInt(netbuffer.numtics, 0),
  cmdcopy
)
end function

/*
* Function: _DNet_CopyStoreToBuffer
* Purpose: Implements the _DNet_CopyStoreToBuffer routine for the internal module support.
*/
function _DNet_CopyStoreToBuffer(src)
  if src is void or netbuffer is void then return end if
  netbuffer.checksum = _DNet_ToInt(src.checksum, 0)
  netbuffer.retransmitfrom = _DNet_ToInt(src.retransmitfrom, 0)
  netbuffer.starttic = _DNet_ToInt(src.starttic, 0)
  netbuffer.player = _DNet_ToInt(src.player, 0)
  netbuffer.numtics = _DNet_ToInt(src.numtics, 0)
  if not _DNet_IsSeq(netbuffer.cmds) then
    netbuffer.cmds = _DNet_DefaultCmds()
  end if
  i = 0
  while i < BACKUPTICS
    if _DNet_IsSeq(src.cmds) and i < len(src.cmds) then
      netbuffer.cmds[i] = _DNet_CopyCmd(src.cmds[i])
    else
      netbuffer.cmds[i] = ticcmd_t(0, 0, 0, 0, 0, 0)
    end if
    i = i + 1
  end while
end function

/*
* Function: D_NetInitSinglePlayer
* Purpose: Initializes state and dependencies for the core game definitions.
*/
function D_NetInitSinglePlayer()
  global doomcom
  global netbuffer
  global maketic
  global lastnettic
  global skiptics
  global ticdup
  global maxsend
  global gametime
  global reboundpacket
  global reboundstore
  global _dnet_oldentertics
  global _dnet_oldnettics
  global _dnet_frameon
  global _dnet_frameskip

  d = doomdata_t(0, 0, 0, 0, 0, _DNet_DefaultCmds())
  c = doomcom_t(
  DOOMCOM_ID,
  0,
  0,
  -1,
  0,

  1,
  1,
  0,
  0,
  -1,
  1,
  1,
  2,

  0,
  1,
  0,
  0,

  d
)

  doomcom = c
  netbuffer = doomcom.data
  _DNet_EnsureStateArrays()

  maketic = 0
  lastnettic = 0
  skiptics = 0
  ticdup = 1
  maxsend = 1
  gametime = 0
  reboundpacket = false
  reboundstore = void
  _dnet_oldentertics = -1
  _dnet_oldnettics = 0
  _dnet_frameon = 0
  _dnet_frameskip =[false, false, false, false]

  netgame = false
  deathmatch = false
end function

/*
* Function: D_CheckNetGame
* Purpose: Evaluates conditions and returns a decision for the core game definitions.
*/
function D_CheckNetGame()
  global consoleplayer
  global displayplayer
  global deathmatch
  global ticdup
  global maxsend

  _DNet_EnsureStateArrays()
  i = 0
  while i < MAXNETNODES
    nodeingame[i] = false
    nettics[i] = 0
    remoteresend[i] = false
    resendto[i] = 0
    resendcount[i] = 0
    i = i + 1
  end while

  if typeof(I_InitNetwork) == "function" then I_InitNetwork() end if

  consoleplayer = 0
  displayplayer = 0

  if typeof(doomcom) == "struct" then
    if typeof(doomcom.consoleplayer) != "void" then consoleplayer = doomcom.consoleplayer end if
    if typeof(doomcom.numplayers) != "void" and doomcom.numplayers > 0 then
      if typeof(playeringame) == "array" then
        i = 0
        while i < MAXPLAYERS
          if i < doomcom.numplayers then
            playeringame[i] = true
          else
            playeringame[i] = false
          end if
          i = i + 1
        end while
      end if
    end if

    if typeof(doomcom.deathmatch) != "void" then
      deathmatch =(doomcom.deathmatch != 0)
    end if

    ticdup = _DNet_ToInt(doomcom.ticdup, 1)
    if ticdup < 1 then ticdup = 1 end if
    maxsend = _DNet_IDiv(BACKUPTICS, 2 * ticdup) - 1
    if maxsend < 1 then maxsend = 1 end if

    numn = _DNet_ToInt(doomcom.numnodes, 1)
    if numn < 1 then numn = 1 end if
    if numn > MAXNETNODES then numn = MAXNETNODES end if
    i = 0
    while i < numn
      nodeingame[i] = true
      i = i + 1
    end while
  end if
end function

/*
* Function: D_QuitNetGame
* Purpose: Implements the D_QuitNetGame routine for the core game definitions.
*/
function D_QuitNetGame()
  if (not netgame) or(not usergame) or consoleplayer == -1 or demoplayback then
    return
  end if

  if netbuffer is void then return end if

  netbuffer.player = consoleplayer
  netbuffer.numtics = 0

  i = 0
  while i < 4
    j = 1
    numn = 1
    if typeof(doomcom) == "struct" then numn = _DNet_ToInt(doomcom.numnodes, 1) end if
    if numn > MAXNETNODES then numn = MAXNETNODES end if
    while j < numn
      if _DNet_IsSeq(nodeingame) and j < len(nodeingame) and nodeingame[j] then
        HSendPacket(j, NCMD_EXIT)
      end if
      j = j + 1
    end while
    if typeof(I_WaitVBL) == "function" then I_WaitVBL(1) end if
    i = i + 1
  end while
end function

/*
* Function: NetUpdate
* Purpose: Advances per-tick logic for the engine module behavior.
*/
function NetUpdate()
  global gametime
  global maketic
  global skiptics

  _DNet_EnsureStateArrays()

  nowtime = 0
  if typeof(I_GetTime) == "function" then nowtime = I_GetTime() end if
  nowtime = _DNet_ToInt(nowtime, gametime)
  nowtime = _DNet_IDiv(nowtime, ticdup)
  newtics = nowtime - gametime
  gametime = nowtime

  if newtics > 0 then
    if skiptics <= newtics then
      newtics = newtics - skiptics
      skiptics = 0
    else
      skiptics = skiptics - newtics
      newtics = 0
    end if
  end if

  if newtics > 0 and netbuffer is not void then
    netbuffer.player = consoleplayer
    gameticdiv = _DNet_IDiv(gametic, ticdup)
    i = 0
    while i < newtics
      if typeof(I_StartTic) == "function" then I_StartTic() end if
      if typeof(D_ProcessEvents) == "function" then D_ProcessEvents() end if
      if maketic - gameticdiv >=(_DNet_IDiv(BACKUPTICS, 2) - 1) then
        break
      end if
      cmd = ticcmd_t(0, 0, 0, 0, 0, 0)
      if typeof(G_BuildTiccmd) == "function" then
        G_BuildTiccmd(cmd)
      end if
      localcmds[maketic % BACKUPTICS] = _DNet_CopyCmd(cmd)
      if consoleplayer >= 0 and consoleplayer < MAXPLAYERS then
        netcmds[consoleplayer][maketic % BACKUPTICS] = _DNet_CopyCmd(cmd)
        if _DNet_IsSeq(players) and consoleplayer < len(players) and players[consoleplayer] is not void then
          pl = players[consoleplayer]
          pl.cmd = _DNet_CopyCmd(cmd)
          players[consoleplayer] = pl
        end if
      end if
      maketic = maketic + 1
      i = i + 1
    end while
    nettics[0] = maketic
  end if

  if singletics then return end if

  if typeof(doomcom) == "struct" and netbuffer is not void then
    numn = _DNet_ToInt(doomcom.numnodes, 1)
    if numn < 1 then numn = 1 end if
    if numn > MAXNETNODES then numn = MAXNETNODES end if

    i = 0
    while i < numn
      if _DNet_IsSeq(nodeingame) and i < len(nodeingame) and nodeingame[i] then
        realstart = resendto[i]
        if realstart < 0 then realstart = 0 end if
        if realstart > maketic then realstart = maketic end if
        num = maketic - realstart
        if num > BACKUPTICS then num = BACKUPTICS end if

        netbuffer.starttic = realstart
        netbuffer.numtics = num
        resendto[i] = maketic - _DNet_ToInt(doomcom.extratics, 0)
        if resendto[i] < 0 then resendto[i] = 0 end if

        j = 0
        while j < num
          netbuffer.cmds[j] = _DNet_CopyCmd(localcmds[(realstart + j) % BACKUPTICS])
          j = j + 1
        end while

        if _DNet_IsSeq(remoteresend) and i < len(remoteresend) and remoteresend[i] then
          netbuffer.retransmitfrom = nettics[i]
          HSendPacket(i, NCMD_RETRANSMIT)
        else
          netbuffer.retransmitfrom = 0
          HSendPacket(i, 0)
        end if
      end if
      i = i + 1
    end while
  end if

  GetPackets()
end function

/*
* Function: _DNet_RunGameTics
* Purpose: Implements the _DNet_RunGameTics routine for the internal module support.
*/
function _DNet_RunGameTics(counts)
  global gametic

  ran = 0
  while counts > 0
    i = 0
    while i < ticdup
      if advancedemo and typeof(D_DoAdvanceDemo) == "function" then D_DoAdvanceDemo() end if
      if typeof(M_Ticker) == "function" then M_Ticker() end if
      if typeof(G_Ticker) == "function" then G_Ticker() end if
      gametic = gametic + 1
      ran = ran + 1

      if i != ticdup - 1 then
        buf = _DNet_IDiv(gametic, ticdup) % BACKUPTICS
        j = 0
        while j < MAXPLAYERS
          if _DNet_IsSeq(netcmds) and j < len(netcmds) and _DNet_IsSeq(netcmds[j]) and buf < len(netcmds[j]) then
            cmd = netcmds[j][buf]
            cmd.chatchar = 0
            if (cmd.buttons & buttoncode_t.BT_SPECIAL) != 0 then cmd.buttons = 0 end if
            netcmds[j][buf] = cmd
          end if
          j = j + 1
        end while
      end if

      i = i + 1
    end while
    NetUpdate()
    counts = counts - 1
  end while
  return ran
end function

/*
* Function: _DNet_TryRunTicsUncapped
* Purpose: Computes movement/collision behavior in the internal module support.
*/
function _DNet_TryRunTicsUncapped()
  global _dnet_oldentertics
  global d_runtics_last

  entertic = 0
  if typeof(I_GetTime) == "function" then entertic = I_GetTime() end if
  entertic = _DNet_ToInt(entertic, 0)
  entertic = _DNet_IDiv(entertic, ticdup)

  if _dnet_oldentertics < 0 then
    _dnet_oldentertics = entertic
  end if
  _dnet_oldentertics = entertic

  NetUpdate()

  lowtic = 2147483647
  numn = 1
  if typeof(doomcom) == "struct" then numn = _DNet_ToInt(doomcom.numnodes, 1) end if
  if numn < 1 then numn = 1 end if
  if numn > MAXNETNODES then numn = MAXNETNODES end if

  i = 0
  while i < numn
    if _DNet_IsSeq(nodeingame) and i < len(nodeingame) and nodeingame[i] then
      if nettics[i] < lowtic then lowtic = nettics[i] end if
    end if
    i = i + 1
  end while
  if lowtic == 2147483647 then lowtic = maketic end if

  availabletics = lowtic - _DNet_IDiv(gametic, ticdup)
  counts = availabletics
  if counts < 0 then counts = 0 end if
  if counts > 8 then counts = 8 end if

  d_runtics_last = _DNet_RunGameTics(counts)
end function

/*
* Function: TryRunTics
* Purpose: Computes movement/collision behavior in the engine module behavior.
*/
function TryRunTics()
  global _dnet_oldentertics
  global _dnet_oldnettics
  global _dnet_frameon
  global skiptics
  global gametime
  global d_runtics_last

  d_runtics_last = 0

  if typeof(uncapped_render) != "void" and uncapped_render and(not netgame) then
    _DNet_TryRunTicsUncapped()
    return
  end if

  entertic = 0
  if typeof(I_GetTime) == "function" then entertic = I_GetTime() end if
  entertic = _DNet_ToInt(entertic, 0)
  entertic = _DNet_IDiv(entertic, ticdup)

  if _dnet_oldentertics < 0 then
    _dnet_oldentertics = entertic
  end if

  realtics = entertic - _dnet_oldentertics
  _dnet_oldentertics = entertic

  NetUpdate()

  lowtic = 2147483647
  numn = 1
  if typeof(doomcom) == "struct" then numn = _DNet_ToInt(doomcom.numnodes, 1) end if
  if numn < 1 then numn = 1 end if
  if numn > MAXNETNODES then numn = MAXNETNODES end if
  i = 0
  while i < numn
    if _DNet_IsSeq(nodeingame) and i < len(nodeingame) and nodeingame[i] then
      if nettics[i] < lowtic then lowtic = nettics[i] end if
    end if
    i = i + 1
  end while
  if lowtic == 2147483647 then lowtic = maketic end if

  availabletics = lowtic - _DNet_IDiv(gametic, ticdup)
  counts = availabletics
  if realtics < availabletics - 1 then
    counts = realtics + 1
  else if realtics < availabletics then
    counts = realtics
  end if
  if counts < 1 then counts = 1 end if

  _dnet_frameon = _dnet_frameon + 1

  if not demoplayback then
    firstpl = -1
    i = 0
    while i < MAXPLAYERS
      if _DNet_IsSeq(playeringame) and i < len(playeringame) and playeringame[i] then
        firstpl = i
        break
      end if
      i = i + 1
    end while

    if firstpl >= 0 and consoleplayer != firstpl then
      node = 0
      if _DNet_IsSeq(nodeforplayer) and firstpl < len(nodeforplayer) then
        node = nodeforplayer[firstpl]
      end if
      if node >= 0 and node < len(nettics) then
        if nettics[0] <= nettics[node] then gametime = gametime - 1 end if
        idx = _dnet_frameon & 3
        _dnet_frameskip[idx] =(_dnet_oldnettics > nettics[node])
        _dnet_oldnettics = nettics[0]
        if _dnet_frameskip[0] and _dnet_frameskip[1] and _dnet_frameskip[2] and _dnet_frameskip[3] then
          skiptics = 1
        end if
      end if
    end if
  end if

  while lowtic < _DNet_IDiv(gametic, ticdup) + counts
    NetUpdate()
    lowtic = 2147483647
    i = 0
    while i < numn
      if _DNet_IsSeq(nodeingame) and i < len(nodeingame) and nodeingame[i] and nettics[i] < lowtic then
        lowtic = nettics[i]
      end if
      i = i + 1
    end while
    if lowtic == 2147483647 then lowtic = maketic end if

    now2 = 0
    if typeof(I_GetTime) == "function" then now2 = I_GetTime() end if
    now2 = _DNet_IDiv(_DNet_ToInt(now2, 0), ticdup)
    if now2 - entertic >= 20 then
      if typeof(M_Ticker) == "function" then M_Ticker() end if
      d_runtics_last = 0
      return
    end if
  end while

  d_runtics_last = _DNet_RunGameTics(counts)
end function

/*
* Function: NetbufferSize
* Purpose: Implements the NetbufferSize routine for the engine module behavior.
*/
function NetbufferSize()
  if netbuffer is void then return 0 end if
  n = _DNet_ToInt(netbuffer.numtics, 0)
  if n < 0 then n = 0 end if
  if n > BACKUPTICS then n = BACKUPTICS end if

  return 5 + n * 6
end function

/*
* Function: NetbufferChecksum
* Purpose: Evaluates conditions and returns a decision for the engine module behavior.
*/
function NetbufferChecksum()
  if netbuffer is void then return 0 end if

  c = 0x1234567
  c = c + _DNet_ToInt(netbuffer.retransmitfrom, 0) * 3
  c = c + _DNet_ToInt(netbuffer.starttic, 0) * 5
  c = c + _DNet_ToInt(netbuffer.player, 0) * 7
  n = _DNet_ToInt(netbuffer.numtics, 0)
  c = c + n * 11

  if n < 0 then n = 0 end if
  if n > BACKUPTICS then n = BACKUPTICS end if

  i = 0
  while i < n
    if _DNet_IsSeq(netbuffer.cmds) and i < len(netbuffer.cmds) then
      cmd = netbuffer.cmds[i]
      s = _DNet_ToInt(cmd.forwardmove, 0) + _DNet_ToInt(cmd.sidemove, 0) + _DNet_ToInt(cmd.angleturn, 0) + _DNet_ToInt(cmd.consistancy, 0) + _DNet_ToInt(cmd.chatchar, 0) + _DNet_ToInt(cmd.buttons, 0)
      c = c + s *(i + 1)
    end if
    i = i + 1
  end while

  return c & NCMD_CHECKSUM
end function

/*
* Function: ExpandTics
* Purpose: Implements the ExpandTics routine for the engine module behavior.
*/
function ExpandTics(low)
  if typeof(low) != "int" then return 0 end if
  low = low & 255
  delta = low -(maketic & 255)
  if delta >= -64 and delta <= 64 then
    return (maketic &(~255)) + low
  end if
  if delta > 64 then
    return (maketic &(~255)) - 256 + low
  end if
  if delta < -64 then
    return (maketic &(~255)) + 256 + low
  end if
  return low
end function

/*
* Function: HSendPacket
* Purpose: Implements the HSendPacket routine for the engine module behavior.
*/
function HSendPacket(node, flags)
  if netbuffer is void then return false end if
  netbuffer.checksum = NetbufferChecksum() | flags

  if node == 0 then
    global reboundstore
    reboundstore = _DNet_MakeStoreFromBuffer()
    global reboundpacket
    reboundpacket = true
    return true
  end if

  if demoplayback then return false end if
  if not netgame then return false end if
  if typeof(doomcom) != "struct" then return false end if

  doomcom.command = command_t.CMD_SEND
  doomcom.remotenode = node
  doomcom.datalength = NetbufferSize()
  if typeof(I_NetCmd) == "function" then I_NetCmd() end if
  return true
end function

/*
* Function: HGetPacket
* Purpose: Reads or updates state used by the engine module behavior.
*/
function HGetPacket()
  if reboundpacket then
    _DNet_CopyStoreToBuffer(reboundstore)
    if typeof(doomcom) == "struct" then
      doomcom.remotenode = 0
      doomcom.datalength = NetbufferSize()
    end if
    global reboundpacket
    reboundpacket = false
    return true
  end if

  if not netgame then return false end if
  if demoplayback then return false end if
  if typeof(doomcom) != "struct" then return false end if

  doomcom.command = command_t.CMD_GET
  if typeof(I_NetCmd) == "function" then I_NetCmd() end if
  if _DNet_ToInt(doomcom.remotenode, -1) == -1 then return false end if
  if _DNet_ToInt(doomcom.datalength, 0) != NetbufferSize() then return false end if
  if NetbufferChecksum() !=(_DNet_ToInt(netbuffer.checksum, 0) & NCMD_CHECKSUM) then return false end if
  return true
end function

/*
* Function: GetPackets
* Purpose: Reads or updates state used by the engine module behavior.
*/
function GetPackets()
  while HGetPacket()
    if (_DNet_ToInt(netbuffer.checksum, 0) & NCMD_SETUP) != 0 then
      continue
    end if

    netconsole = _DNet_ToInt(netbuffer.player, 0) &(~PL_DRONE)
    netnode = 0
    if typeof(doomcom) == "struct" then netnode = _DNet_ToInt(doomcom.remotenode, -1) end if
    if netnode < 0 or netnode >= MAXNETNODES then continue end if
    if netconsole < 0 or netconsole >= MAXPLAYERS then continue end if

    realstart = ExpandTics(_DNet_ToInt(netbuffer.starttic, 0))
    realend = realstart + _DNet_ToInt(netbuffer.numtics, 0)

    if (_DNet_ToInt(netbuffer.checksum, 0) & NCMD_EXIT) != 0 then
      if not nodeingame[netnode] then continue end if
      nodeingame[netnode] = false
      if _DNet_IsSeq(playeringame) and netconsole < len(playeringame) then
        playeringame[netconsole] = false
      end if
      global _dnet_exitmsg
      _dnet_exitmsg = "Player " +(netconsole + 1) + " left the game"
      if _DNet_IsSeq(players) and consoleplayer >= 0 and consoleplayer < len(players) and players[consoleplayer] is not void then
        p = players[consoleplayer]
        p.message = _dnet_exitmsg
        players[consoleplayer] = p
      end if
      if demorecording and typeof(G_CheckDemoStatus) == "function" then
        G_CheckDemoStatus()
      end if
      continue
    end if

    if (_DNet_ToInt(netbuffer.checksum, 0) & NCMD_KILL) != 0 then
      if typeof(I_Error) == "function" then I_Error("Killed by network driver") end if
      continue
    end if

    nodeforplayer[netconsole] = netnode

    if resendcount[netnode] <= 0 and((_DNet_ToInt(netbuffer.checksum, 0) & NCMD_RETRANSMIT) != 0) then
      resendto[netnode] = ExpandTics(_DNet_ToInt(netbuffer.retransmitfrom, 0))
      resendcount[netnode] = RESENDCOUNT
    else
      resendcount[netnode] = resendcount[netnode] - 1
    end if

    if realend == nettics[netnode] then continue end if
    if realend < nettics[netnode] then continue end if
    if realstart > nettics[netnode] then
      remoteresend[netnode] = true
      continue
    end if

    remoteresend[netnode] = false
    start = nettics[netnode] - realstart
    src = start
    while nettics[netnode] < realend
      if _DNet_IsSeq(netbuffer.cmds) and src >= 0 and src < len(netbuffer.cmds) then
        netcmds[netconsole][nettics[netnode] % BACKUPTICS] = _DNet_CopyCmd(netbuffer.cmds[src])
      end if
      nettics[netnode] = nettics[netnode] + 1
      src = src + 1
    end while
  end while
end function

/*
* Function: CheckAbort
* Purpose: Evaluates conditions and returns a decision for the engine module behavior.
*/
function CheckAbort()
  stoptic = 0
  if typeof(I_GetTime) == "function" then stoptic = _DNet_ToInt(I_GetTime(), 0) + 2 end if
  while typeof(I_GetTime) == "function" and _DNet_ToInt(I_GetTime(), 0) < stoptic
    if typeof(I_StartTic) == "function" then I_StartTic() end if
  end while

  if typeof(I_StartTic) == "function" then I_StartTic() end if
  while eventtail != eventhead
    ev = events[eventtail]
    if ev.type == evtype_t.ev_keydown and ev.data1 == KEY_ESCAPE then
      if typeof(I_Error) == "function" then I_Error("Network game synchronization aborted.") end if
      return true
    end if
    eventtail =(eventtail + 1) &(MAXEVENTS - 1)
  end while
  return false
end function

/*
* Function: D_ArbitrateNetStart
* Purpose: Starts runtime behavior in the core game definitions.
*/
function D_ArbitrateNetStart()
  autostart = true
  if typeof(doomcom) != "struct" then return end if
  if _DNet_ToInt(doomcom.numnodes, 1) <= 1 then return end if

  if _DNet_ToInt(doomcom.consoleplayer, 0) != 0 then
    tries = 0
    while tries < 64
      if CheckAbort() then return end if
      if HGetPacket() and((_DNet_ToInt(netbuffer.checksum, 0) & NCMD_SETUP) != 0) then
        startskill = _DNet_ToInt(netbuffer.retransmitfrom, startskill) & 15
        deathmatch =((_DNet_ToInt(netbuffer.retransmitfrom, 0) & 0xc0) >> 6) != 0
        nomonsters =(_DNet_ToInt(netbuffer.retransmitfrom, 0) & 0x20) != 0
        respawnparm =(_DNet_ToInt(netbuffer.retransmitfrom, 0) & 0x10) != 0
        startmap = _DNet_ToInt(netbuffer.starttic, startmap) & 0x3f
        startepisode = _DNet_ToInt(netbuffer.starttic, startepisode) >> 6
        return
      end if
      tries = tries + 1
    end while
    return
  end if

  i = 0
  numn = _DNet_ToInt(doomcom.numnodes, 1)
  while i < numn
    netbuffer.retransmitfrom = startskill
    if deathmatch then netbuffer.retransmitfrom = netbuffer.retransmitfrom | 0x40 end if
    if nomonsters then netbuffer.retransmitfrom = netbuffer.retransmitfrom | 0x20 end if
    if respawnparm then netbuffer.retransmitfrom = netbuffer.retransmitfrom | 0x10 end if
    netbuffer.starttic = startepisode * 64 + startmap
    netbuffer.player = VERSION
    netbuffer.numtics = 0
    HSendPacket(i, NCMD_SETUP)
    i = i + 1
  end while
end function



