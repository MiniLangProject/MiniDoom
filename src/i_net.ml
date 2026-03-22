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

  Script: i_net.ml
  Purpose: Implements platform integration for input, timing, video, audio, and OS services.
*/
import i_system
import d_event
import d_net
import m_argv
import doomstat
import mp_platform
import std.math

const _INET_MAGIC0 = 68
const _INET_MAGIC1 = 78
const _INET_MAGIC2 = 69
const _INET_MAGIC3 = 84

/*
* Function: _INet_ToInt
* Purpose: Converts values to integers with deterministic rounding.
*/
function _INet_ToInt(v, fallback)
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
* Function: _INet_WriteI32LE
* Purpose: Writes a signed 32-bit integer to a byte buffer.
*/
function inline _INet_WriteI32LE(buf, off, v)
  x = _INet_ToInt(v, 0)
  if x < 0 then x = x + 4294967296 end if
  buf[off] = x & 255
  buf[off + 1] = (x >> 8) & 255
  buf[off + 2] = (x >> 16) & 255
  buf[off + 3] = (x >> 24) & 255
end function

/*
* Function: _INet_ReadI32LE
* Purpose: Reads a signed 32-bit integer from a byte buffer.
*/
function inline _INet_ReadI32LE(buf, off)
  b0 = buf[off] & 255
  b1 = buf[off + 1] & 255
  b2 = buf[off + 2] & 255
  b3 = buf[off + 3] & 255
  x = b0 | (b1 << 8) | (b2 << 16) | (b3 << 24)
  if x >= 2147483648 then x = x - 4294967296 end if
  return x
end function

/*
* Function: _INet_EncodeDoomData
* Purpose: Serializes doomdata struct into network payload bytes.
*/
function _INet_EncodeDoomData(d)
  n = 0
  if typeof(d) == "struct" then n = _INet_ToInt(d.numtics, 0) end if
  if n < 0 then n = 0 end if
  if n > BACKUPTICS then n = BACKUPTICS end if

  packet = bytes(24 + n * 24, 0)
  packet[0] = _INET_MAGIC0
  packet[1] = _INET_MAGIC1
  packet[2] = _INET_MAGIC2
  packet[3] = _INET_MAGIC3
  if typeof(d) == "struct" then
    _INet_WriteI32LE(packet, 4, d.checksum)
    _INet_WriteI32LE(packet, 8, d.retransmitfrom)
    _INet_WriteI32LE(packet, 12, d.starttic)
    _INet_WriteI32LE(packet, 16, d.player)
    _INet_WriteI32LE(packet, 20, n)
  end if

  i = 0
  while i < n
    base = 24 + i * 24
    c = ticcmd_t(0, 0, 0, 0, 0, 0)
    if typeof(d) == "struct" and (typeof(d.cmds) == "array" or typeof(d.cmds) == "list") and i < len(d.cmds) and d.cmds[i] is not void then
      c = d.cmds[i]
    end if
    _INet_WriteI32LE(packet, base + 0, c.forwardmove)
    _INet_WriteI32LE(packet, base + 4, c.sidemove)
    _INet_WriteI32LE(packet, base + 8, c.angleturn)
    _INet_WriteI32LE(packet, base + 12, c.consistancy)
    _INet_WriteI32LE(packet, base + 16, c.chatchar)
    _INet_WriteI32LE(packet, base + 20, c.buttons)
    i = i + 1
  end while
  return packet
end function

/*
* Function: _INet_DecodeToNetbuffer
* Purpose: Deserializes payload bytes into global netbuffer fields.
*/
function _INet_DecodeToNetbuffer(payload)
  if typeof(payload) != "bytes" then return false end if
  if len(payload) < 24 then return false end if
  if (payload[0] & 255) != _INET_MAGIC0 or (payload[1] & 255) != _INET_MAGIC1 or (payload[2] & 255) != _INET_MAGIC2 or (payload[3] & 255) != _INET_MAGIC3 then
    return false
  end if
  if netbuffer is void then return false end if

  netbuffer.checksum = _INet_ReadI32LE(payload, 4)
  netbuffer.retransmitfrom = _INet_ReadI32LE(payload, 8)
  netbuffer.starttic = _INet_ReadI32LE(payload, 12)
  netbuffer.player = _INet_ReadI32LE(payload, 16)
  n = _INet_ReadI32LE(payload, 20)
  if n < 0 then n = 0 end if
  if n > BACKUPTICS then n = BACKUPTICS end if
  if len(payload) < 24 + n * 24 then return false end if
  netbuffer.numtics = n

  if typeof(netbuffer.cmds) != "array" or len(netbuffer.cmds) != BACKUPTICS then
    netbuffer.cmds = _DNet_DefaultCmds()
  end if

  i = 0
  while i < BACKUPTICS
    if i < n then
      base = 24 + i * 24
      netbuffer.cmds[i] = ticcmd_t(
      _INet_ReadI32LE(payload, base + 0),
      _INet_ReadI32LE(payload, base + 4),
      _INet_ReadI32LE(payload, base + 8),
      _INet_ReadI32LE(payload, base + 12),
      _INet_ReadI32LE(payload, base + 16),
      _INet_ReadI32LE(payload, base + 20)
    )
    else
      netbuffer.cmds[i] = ticcmd_t(0, 0, 0, 0, 0, 0)
    end if
    i = i + 1
  end while

  return true
end function

/*
* Function: _INet_SlotIsActive
* Purpose: Returns whether a slot index exists in the active slot list.
*/
function _INet_SlotIsActive(activeSlots, slot)
  if typeof(activeSlots) != "array" then return false end if
  i = 0
  while i < len(activeSlots)
    if _INet_ToInt(activeSlots[i], -1) == slot then return true end if
    i = i + 1
  end while
  return false
end function

/*
* Function: _INet_EnsureSlotMobj
* Purpose: Ensures active player slots have a spawned mobj in running level.
*/
function _INet_EnsureSlotMobj(slot)
  if gamestate != gamestate_t.GS_LEVEL then return end if
  if slot < 0 or slot >= MAXPLAYERS then return end if
  if typeof(playeringame) != "array" or slot >= len(playeringame) or not playeringame[slot] then return end if
  if typeof(players) != "array" or slot >= len(players) then return end if

  p = players[slot]
  if typeof(p) != "struct" then
    p = Player_MakeDefault()
    players[slot] = p
  end if

  if p.mo is void then
    p.playerstate = playerstate_t.PST_REBORN
    players[slot] = p
    didSpawn = false
    if typeof(playerstarts) == "array" and slot < len(playerstarts) and playerstarts[slot] is not void and typeof(P_SpawnPlayer) == "function" then
      P_SpawnPlayer(playerstarts[slot])
      didSpawn = true
    end if
    // In coop, never call deathmatch-only spawn path (it can I_Error on maps with few DM starts).
    if not didSpawn and deathmatch and typeof(G_DeathMatchSpawnPlayer) == "function" then
      G_DeathMatchSpawnPlayer(slot)
      didSpawn = true
    end if
    if not didSpawn and typeof(P_SpawnPlayer) == "function" then
      sx = 0
      sy = 0
      sang = 0
      if typeof(playerstarts) == "array" and len(playerstarts) > 0 and typeof(playerstarts[0]) == "struct" then
        sx = _INet_ToInt(playerstarts[0].x, 0)
        sy = _INet_ToInt(playerstarts[0].y, 0)
        sang = _INet_ToInt(playerstarts[0].angle, 0)
      end if
      // Spread late-joiners near start 0 if map has no dedicated coop starts.
      sx = sx + (64 * slot)
      sy = sy + (48 * slot)
      P_SpawnPlayer(mapthing_t(sx, sy, sang, slot + 1, 0))
    end if
  end if
end function

/*
* Function: _INet_RemoveSlotMobj
* Purpose: Removes mobj for inactive player slots.
*/
function inline _INet_RemoveSlotMobj(slot)
  if slot < 0 or slot >= MAXPLAYERS then return end if
  if typeof(players) != "array" or slot >= len(players) then return end if
  p = players[slot]
  if typeof(p) != "struct" then return end if
  if p.mo is not void and typeof(P_RemoveMobj) == "function" then
    P_RemoveMobj(p.mo)
    p.mo = void
    players[slot] = p
  end if
end function

/*
* Function: _INet_SyncRuntimeFromPlatform
* Purpose: Synchronizes doom net runtime globals from mp platform role/state.
*/
function _INet_SyncRuntimeFromPlatform()
  global nodeingame
  global nodeforplayer
  global playeringame
  global nettics
  global resendto
  global resendcount
  global remoteresend
  global maketic
  if typeof(doomcom) != "struct" then return end if

  if typeof(MP_PlatformPump) == "function" then MP_PlatformPump() end if

  isHost = false
  isClient = false
  if typeof(MP_PlatformIsHosting) == "function" then isHost = MP_PlatformIsHosting() end if
  if typeof(MP_PlatformIsClientConnected) == "function" then isClient = MP_PlatformIsClientConnected() end if
  if (not isHost) and (not isClient) then return end if

  nodes = 1
  playersCount = 1
  slot = 0
  if typeof(MP_PlatformGetNodeCount) == "function" then nodes = _INet_ToInt(MP_PlatformGetNodeCount(), 1) end if
  if typeof(MP_PlatformGetNumPlayers) == "function" then playersCount = _INet_ToInt(MP_PlatformGetNumPlayers(), 1) end if
  if typeof(MP_PlatformGetLocalPlayerSlot) == "function" then slot = _INet_ToInt(MP_PlatformGetLocalPlayerSlot(), 0) end if
  if nodes < 1 then nodes = 1 end if
  if nodes > MAXNETNODES then nodes = MAXNETNODES end if
  if playersCount < 1 then playersCount = 1 end if
  if playersCount > MAXPLAYERS then playersCount = MAXPLAYERS end if
  if slot < 0 then slot = 0 end if
  if slot >= MAXPLAYERS then slot = 0 end if

  doomcom.numnodes = nodes
  doomcom.numplayers = playersCount
  doomcom.consoleplayer = slot
  consoleplayer = slot
  displayplayer = slot
  netgame = true

  activeSlots = [0]
  if typeof(MP_PlatformGetActiveSlots) == "function" then
    s = MP_PlatformGetActiveSlots()
    if typeof(s) == "array" and len(s) > 0 then activeSlots = s end if
  end if

  prevNodes = []
  if typeof(nodeingame) == "array" then
    i = 0
    while i < len(nodeingame)
      prevNodes = prevNodes + [nodeingame[i]]
      i = i + 1
    end while
  end if

  if typeof(nodeingame) == "array" then
    i = 0
    while i < len(nodeingame)
      nodeingame[i] = false
      i = i + 1
    end while
    i = 0
    while i < len(activeSlots)
      n = _INet_ToInt(activeSlots[i], -1)
      if n >= 0 and n < len(nodeingame) then nodeingame[n] = true end if
      i = i + 1
    end while

    // Bootstrap newly active nodes to current tic to avoid lockstep stall immediately after join.
    if typeof(nettics) == "array" then
      i = 0
      while i < len(nodeingame) and i < len(nettics)
        wasActive = false
        if i < len(prevNodes) and prevNodes[i] then wasActive = true end if
        if nodeingame[i] and (not wasActive) then
          mt = _INet_ToInt(maketic, 0)
          nettics[i] = mt
          if typeof(resendto) == "array" and i < len(resendto) then resendto[i] = mt end if
          if typeof(resendcount) == "array" and i < len(resendcount) then resendcount[i] = 0 end if
          if typeof(remoteresend) == "array" and i < len(remoteresend) then remoteresend[i] = false end if
        end if
        i = i + 1
      end while
    end if
  end if

  if typeof(playeringame) == "array" then
    i = 0
    while i < len(playeringame)
      wasActive = playeringame[i]
      nowActive = _INet_SlotIsActive(activeSlots, i)
      playeringame[i] = nowActive
      if nowActive then
        _INet_EnsureSlotMobj(i)
      else if wasActive and i != consoleplayer then
        _INet_RemoveSlotMobj(i)
      end if
      i = i + 1
    end while
  end if

end function

/*
* Function: I_InitNetwork
* Purpose: Initializes state and dependencies for the platform layer.
*/
function I_InitNetwork()

  if typeof(D_NetInitSinglePlayer) == "function" then
    D_NetInitSinglePlayer()
  end if
end function

/*
* Function: I_NetCmd
* Purpose: Implements the I_NetCmd routine for the platform layer.
*/
function I_NetCmd()
  _INet_SyncRuntimeFromPlatform()
  if typeof(doomcom) != "struct" then return end if

  cmd = doomcom.command
  if cmd == command_t.CMD_GET then
    pkt = void
    if typeof(MP_PlatformNetRecv) == "function" then pkt = MP_PlatformNetRecv() end if
    if typeof(pkt) == "array" and len(pkt) >= 2 and _INet_DecodeToNetbuffer(pkt[1]) then
      doomcom.remotenode = _INet_ToInt(pkt[0], -1)
      doomcom.datalength = NetbufferSize()
      return
    end if
    doomcom.remotenode = -1
    doomcom.datalength = 0
    return
  end if

  if cmd == command_t.CMD_SEND then
    node = _INet_ToInt(doomcom.remotenode, -1)
    if node >= 0 and typeof(MP_PlatformNetSend) == "function" and typeof(doomcom.data) == "struct" then
      payload = _INet_EncodeDoomData(doomcom.data)
      MP_PlatformNetSend(node, payload)
    end if
    return
  end if
end function

/*
* Function: UDPsocket
* Purpose: Implements the UDPsocket routine for the engine module behavior.
*/
function UDPsocket()
  return -1
end function

/*
* Function: BindToLocalPort
* Purpose: Implements the BindToLocalPort routine for the engine module behavior.
*/
function BindToLocalPort(sock, port)
  sock = sock
  port = port
  return false
end function

/*
* Function: PacketSend
* Purpose: Implements the PacketSend routine for the engine module behavior.
*/
function PacketSend(sock, node, data, length)
  sock = sock
  node = node
  data = data
  length = length
  return false
end function

/*
* Function: PacketGet
* Purpose: Reads or updates state used by the engine module behavior.
*/
function PacketGet(sock, nodeOut, dataOut, lengthOut)
  sock = sock
  if typeof(nodeOut) == "array" and len(nodeOut) > 0 then nodeOut[0] = -1 end if
  if typeof(lengthOut) == "array" and len(lengthOut) > 0 then lengthOut[0] = 0 end if
  dataOut = dataOut
  return false
end function

/*
* Function: GetLocalAddress
* Purpose: Reads or updates state used by the engine module behavior.
*/
function GetLocalAddress()
  return "127.0.0.1"
end function



