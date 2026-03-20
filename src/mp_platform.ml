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

  Script: mp_platform.ml
  Purpose: Implements UDP multiplayer host/join handshake and runtime packet pump.
*/

import mp_state
import doomstat
import std.net as net
import std.time as time
import std.string as str
import std.math

_mp_platform_last_error = ""
_mp_platform_last_status = ""

const _MPPLAT_ROLE_NONE = 0
const _MPPLAT_ROLE_HOST = 1
const _MPPLAT_ROLE_CLIENT = 2

const _MPPLAT_PROTO = "MDMP1"
const _MPPLAT_REQ = "REQ"
const _MPPLAT_ACC = "ACC"
const _MPPLAT_DEN = "DEN"
const _MPPLAT_PING = "PING"
const _MPPLAT_PONG = "PONG"
const _MPPLAT_LEAVE = "LEAVE"
const _MPPLAT_GAME_MAGIC0 = 77
const _MPPLAT_GAME_MAGIC1 = 68
const _MPPLAT_GAME_MAGIC2 = 71
const _MPPLAT_GAME_MAGIC3 = 49

const _MPPLAT_RECV_MAX = 1400
const _MPPLAT_TIMEOUT_MS = 2500
const _MPPLAT_WOULDBLOCK = 10035
const _MPPLAT_TIMEDOUT = 10060
const _MPPLAT_HOST_PEER_TIMEOUT_MS = 30000
const _MPPLAT_CLIENT_PING_INTERVAL_MS = 1000
const _MPPLAT_HOST_PING_INTERVAL_MS = 1000
const _MPPLAT_FIONBIO = 0x8004667E
const _MPPLAT_FIONREAD = 0x4004667F
const _MPPLAT_MAX_PLAYERS = 4
const _MPPLAT_SO_RCVTIMEO = 0x1006
const _MPPLAT_GAME_QUEUE_CHUNK = 256
const _MPPLAT_GAME_QUEUE_MAX = 2048
const _MPPLAT_AF_INET = 2
const _MPPLAT_SOCK_DGRAM = 2
const _MPPLAT_IPPROTO_UDP = 17
const _MPPLAT_SOCKET_ERROR = -1

/*
* Struct: _mp_peer_t
* Purpose: Tracks a connected remote multiplayer peer endpoint on host side.
*/
struct _mp_peer_t
  ip
  port
  name
  slot
  peerid
  ingame
  lastSeenMs
  pingSeq
  lastPingTxMs
  lastPongMs
  rttMs
  pingSentCount
  pongRecvCount
  gameInCount
  gameOutCount
end struct

_mp_role = _MPPLAT_ROLE_NONE
_mp_sock = void

_mp_host_mode_cfg = MP_MODE_COOP
_mp_host_map_cfg = "MAP01"
_mp_host_skill_cfg = MP_SKILL_MEDIUM
_mp_host_max_players_cfg = 4
_mp_host_frag_limit_cfg = 0
_mp_host_time_limit_cfg = 0
_mp_host_next_peer_id = 2
_mp_host_peers = []

_mp_client_host = ""
_mp_client_host_name = ""
_mp_client_port = 0
_mp_client_peer_id = 0
_mp_client_slot = 1
_mp_client_last_ping_ms = 0
_mp_client_ping_seq = 0
_mp_client_last_ping_tx_ms = 0
_mp_client_last_pong_ms = 0
_mp_client_rtt_ms = -1
_mp_client_ping_sent = 0
_mp_client_pong_recv = 0
_mp_client_game_in = 0
_mp_client_game_out = 0
_mp_client_slot_names = []
_mp_debug_send_attempt = 0
_mp_debug_send_ok = 0
_mp_debug_send_idxfail = 0
_mp_debug_send_err = 0
_mp_game_queue_nodes = []
_mp_game_queue_payloads = []
_mp_game_queue_head = 0
_mp_game_queue_tail = 0
_mp_game_queue_dropped = 0

/*
* Function: ioctlsocket
* Purpose: Toggles socket mode (blocking/non-blocking) for UDP polling.
*/
extern function ioctlsocket(s as ptr, cmd as i32, argp as bytes) from "ws2_32.dll" returns int
extern function setsockopt(s as ptr, level as int, optname as int, optval as bytes, optlen as int) from "ws2_32.dll" symbol "setsockopt" returns int
extern function socket(af as int, type as int, protocol as int) from "ws2_32.dll" returns ptr
extern function bind(s as ptr, addr as bytes, addrlen as int) from "ws2_32.dll" returns int
extern function closesocket(s as ptr) from "ws2_32.dll" returns int

/*
* Function: _MPPlatform_ToInt
* Purpose: Converts mixed numeric values to stable integer values.
*/
function inline _MPPlatform_ToInt(v, fallback)
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
* Function: _MPPlatform_WaitPulse
* Purpose: Keeps GUI/audio responsive while host/join control flow waits on network I/O.
*/
function inline _MPPlatform_WaitPulse()
  if typeof(I_LoadingPulse) == "function" then
    I_LoadingPulse()
  else
    if typeof(I_UpdateNoBlit) == "function" then I_UpdateNoBlit() end if
    if typeof(I_UpdateSound) == "function" then I_UpdateSound() end if
    if typeof(I_SubmitSound) == "function" then I_SubmitSound() end if
  end if
end function

/*
* Function: _MPPlatform_ToBytesCopy
* Purpose: Normalizes bytes/array payload values to an owned bytes buffer.
*/
function _MPPlatform_ToBytesCopy(v)
  if typeof(v) == "bytes" then
    n = len(v)
    bufCopy = bytes(n, 0)
    i = 0
    while i < n
      bufCopy[i] = v[i] & 255
      i = i + 1
    end while
    return bufCopy
  end if
  if typeof(v) == "array" or typeof(v) == "list" then
    n = len(v)
    bufCopy = bytes(n, 0)
    i = 0
    while i < n
      bufCopy[i] = _MPPlatform_ToInt(v[i], 0) & 255
      i = i + 1
    end while
    return bufCopy
  end if
  return void
end function

/*
* Function: _MPPlatform_PeerIngame
* Purpose: Returns true when peer ingame marker is truthy (bool true or non-zero int).
*/
function inline _MPPlatform_PeerIngame(p)
  if typeof(p) != "struct" then return false end if
  if typeof(p.ingame) == "bool" then return p.ingame end if
  if typeof(p.ingame) == "int" then return p.ingame != 0 end if
  if typeof(p.ingame) == "float" then return p.ingame != 0 end if
  return false
end function

/*
* Function: _MPPlatform_EnsurePeerTelemetry
* Purpose: Ensures host peer struct has telemetry fields initialized.
*/
function _MPPlatform_EnsurePeerTelemetry(p)
  if typeof(p) != "struct" then return p end if
  if typeof(p.pingSeq) != "int" then p.pingSeq = 0 end if
  if typeof(p.lastPingTxMs) != "int" then p.lastPingTxMs = 0 end if
  if typeof(p.lastPongMs) != "int" then p.lastPongMs = 0 end if
  if typeof(p.rttMs) != "int" then p.rttMs = -1 end if
  if typeof(p.pingSentCount) != "int" then p.pingSentCount = 0 end if
  if typeof(p.pongRecvCount) != "int" then p.pongRecvCount = 0 end if
  if typeof(p.gameInCount) != "int" then p.gameInCount = 0 end if
  if typeof(p.gameOutCount) != "int" then p.gameOutCount = 0 end if
  return p
end function

/*
* Function: _MPPlatform_QueueDepth
* Purpose: Returns queued gameplay packet count waiting for d_net consumption.
*/
function inline _MPPlatform_QueueDepth()
  if typeof(_mp_game_queue_payloads) != "array" then return 0 end if
  head = _MPPlatform_ToInt(_mp_game_queue_head, 0)
  tail = _MPPlatform_ToInt(_mp_game_queue_tail, len(_mp_game_queue_payloads))
  if head < 0 then head = 0 end if
  if tail < head then return 0 end if
  n = tail - head
  if n < 0 then n = 0 end if
  return n
end function

/*
* Function: _MPPlatform_SetStatus
* Purpose: Stores latest status string for menu/UI display.
*/
function _MPPlatform_SetStatus(msg)
  global _mp_platform_last_status
  if typeof(msg) != "string" then
    _mp_platform_last_status = ""
  else
    _mp_platform_last_status = msg
    _MPPlatform_PushConsoleMessage(msg)
  end if
end function

/*
* Function: _MPPlatform_PushConsoleMessage
* Purpose: Sends a short HUD message to the local console player when available.
*/
function _MPPlatform_PushConsoleMessage(msg)
  if typeof(msg) != "string" or msg == "" then return end if
  if typeof(players) != "array" then return end if
  cp = _MPPlatform_ToInt(consoleplayer, -1)
  if cp < 0 or cp >= len(players) then return end if
  p = players[cp]
  if typeof(p) != "struct" then return end if
  p.message = msg
  players[cp] = p
end function

/*
* Function: MP_PlatformGetLastStatus
* Purpose: Returns latest multiplayer runtime status string.
*/
function MP_PlatformGetLastStatus()
  return _mp_platform_last_status
end function

/*
* Function: MP_PlatformGetSessionMode
* Purpose: Returns server-confirmed multiplayer mode for active session.
*/
function MP_PlatformGetSessionMode()
  return _mp_host_mode_cfg
end function

/*
* Function: MP_PlatformGetSessionSkill
* Purpose: Returns server-confirmed multiplayer skill for active session.
*/
function MP_PlatformGetSessionSkill()
  return _mp_host_skill_cfg
end function

/*
* Function: MP_PlatformGetSessionMap
* Purpose: Returns server-confirmed map token for active session.
*/
function MP_PlatformGetSessionMap()
  return _mp_host_map_cfg
end function

/*
* Function: MP_PlatformGetDebugOverlayText
* Purpose: Returns multiplayer debug text for in-game overlay rendering.
*/
function MP_PlatformGetDebugOverlayText()
  if _mp_role == _MPPLAT_ROLE_NONE then return "" end if

  if _mp_role == _MPPLAT_ROLE_CLIENT then
    txt = "MP CLIENT slot=" + _MPPlatform_ToInt(_mp_client_slot, 1)
    txt = txt + " ping=" + _MPPlatform_ToInt(_mp_client_rtt_ms, -1) + "ms"
    txt = txt + " p=" + _MPPlatform_ToInt(_mp_client_pong_recv, 0) + "/" + _MPPlatform_ToInt(_mp_client_ping_sent, 0)
    txt = txt + " g=" + _MPPlatform_ToInt(_mp_client_game_in, 0) + "/" + _MPPlatform_ToInt(_mp_client_game_out, 0)
    txt = txt + " s=" + _MPPlatform_ToInt(_mp_debug_send_ok, 0) + "/" + _MPPlatform_ToInt(_mp_debug_send_attempt, 0)
    txt = txt + " q=" + _MPPlatform_QueueDepth() + "/" + _MPPLAT_GAME_QUEUE_MAX + " d=" + _MPPlatform_ToInt(_mp_game_queue_dropped, 0)
    return txt
  end if

  if _mp_role == _MPPLAT_ROLE_HOST then
    txt = "MP HOST peers=" + len(_mp_host_peers)
    if typeof(MP_PlatformGetActiveSlots) == "function" then
      act = MP_PlatformGetActiveSlots()
      if typeof(act) == "array" and len(act) > 0 then
        txt = txt + " act="
        ai = 0
        while ai < len(act)
          txt = txt + _MPPlatform_ToInt(act[ai], -1)
          if ai + 1 < len(act) then txt = txt + "," end if
          ai = ai + 1
        end while
      end if
    end if
    i = 0
    shown = 0
    while i < len(_mp_host_peers)
      p = _mp_host_peers[i]
      if typeof(p) == "struct" then
        p = _MPPlatform_EnsurePeerTelemetry(p)
        nm = p.name
        if typeof(nm) != "string" or nm == "" then nm = "Player" end if
        if len(nm) > 8 then
          nmb = bytes(nm)
          nm = decode(slice(nmb, 0, 8))
        end if
        txt = txt + "\nS" + _MPPlatform_ToInt(p.slot, 0) + " " + nm
        txt = txt + " ping=" + _MPPlatform_ToInt(p.rttMs, -1) + "ms"
        txt = txt + " p=" + _MPPlatform_ToInt(p.pongRecvCount, 0) + "/" + _MPPlatform_ToInt(p.pingSentCount, 0)
        txt = txt + " g=" + _MPPlatform_ToInt(p.gameInCount, 0) + "/" + _MPPlatform_ToInt(p.gameOutCount, 0)
        shown = shown + 1
        if shown >= 3 then break end if
      end if
      i = i + 1
    end while
    txt = txt + "\nSEND " + _MPPlatform_ToInt(_mp_debug_send_ok, 0) + "/" + _MPPlatform_ToInt(_mp_debug_send_attempt, 0) + " f=" + _MPPlatform_ToInt(_mp_debug_send_idxfail, 0) + "/" + _MPPlatform_ToInt(_mp_debug_send_err, 0)
    return txt
  end if

  return ""
end function

/*
* Function: MP_PlatformIsClientConnected
* Purpose: Returns true when local runtime has an active client connection.
*/
function inline MP_PlatformIsClientConnected()
  return _mp_role == _MPPLAT_ROLE_CLIENT
end function

/*
* Function: MP_PlatformGetLocalPlayerSlot
* Purpose: Returns local player slot index used by Doom net layer.
*/
function inline MP_PlatformGetLocalPlayerSlot()
  if _mp_role == _MPPLAT_ROLE_HOST then return 0 end if
  if _mp_role == _MPPLAT_ROLE_CLIENT then
    s = _MPPlatform_ToInt(_mp_client_slot, 1)
    if s < 1 or s >= _MPPLAT_MAX_PLAYERS then s = 1 end if
    return s
  end if
  return 0
end function

/*
* Function: _MPPlatform_InitClientSlotNames
* Purpose: Initializes deterministic client-side slot name cache.
*/
function _MPPlatform_InitClientSlotNames(localName)
  global _mp_client_slot_names
  nmLocal = MP_SanitizeName(localName)
  if nmLocal == "" then nmLocal = "Player" end if
  nmHost = MP_SanitizeName(_mp_client_host_name)
  if nmHost == "" then nmHost = "Host" end if
  sLocal = _MPPlatform_ToInt(_mp_client_slot, 1)
  if sLocal < 1 or sLocal >= _MPPLAT_MAX_PLAYERS then sLocal = 1 end if

  names = array(_MPPLAT_MAX_PLAYERS)
  i = 0
  while i < _MPPLAT_MAX_PLAYERS
    nm = ""
    if i == 0 then
      nm = nmHost
    else if i == sLocal then
      nm = nmLocal
    end if
    names[i] = nm
    i = i + 1
  end while
  _mp_client_slot_names = names
end function

/*
* Function: MP_PlatformSetPlayerNameBySlot
* Purpose: Updates one authoritative slot name pushed by host snapshots/intermission packets.
*/
function MP_PlatformSetPlayerNameBySlot(slot, name)
  global _mp_client_slot_names
  s = _MPPlatform_ToInt(slot, -1)
  if s < 0 or s >= _MPPLAT_MAX_PLAYERS then return false end if
  nm = MP_SanitizeName(name)
  if nm == "" then return false end if
  if typeof(_mp_client_slot_names) != "array" or len(_mp_client_slot_names) != _MPPLAT_MAX_PLAYERS then
    _MPPlatform_InitClientSlotNames(MP_GetPlayerName())
  end if
  if s >= 0 and s < len(_mp_client_slot_names) then
    _mp_client_slot_names[s] = nm
    return true
  end if
  return false
end function

/*
* Function: MP_PlatformGetPlayerNameBySlot
* Purpose: Resolves player display name for a given Doom slot index.
*/
function MP_PlatformGetPlayerNameBySlot(slot)
  s = _MPPlatform_ToInt(slot, -1)
  if s < 0 then s = 0 end if
  if s >= _MPPLAT_MAX_PLAYERS then s = _MPPLAT_MAX_PLAYERS - 1 end if

  if _mp_role == _MPPLAT_ROLE_HOST then
    if s == 0 then
      nm0 = MP_GetPlayerName()
      if typeof(nm0) == "string" and nm0 != "" then return nm0 end if
      return "Host"
    end if
    idx = _MPPlatform_FindHostPeerBySlot(s)
    if idx >= 0 and idx < len(_mp_host_peers) then
      p = _mp_host_peers[idx]
      if typeof(p) == "struct" and typeof(p.name) == "string" and p.name != "" then return p.name end if
    end if
  else if _mp_role == _MPPLAT_ROLE_CLIENT then
    if typeof(_mp_client_slot_names) == "array" and s >= 0 and s < len(_mp_client_slot_names) then
      nms = _mp_client_slot_names[s]
      if typeof(nms) == "string" and nms != "" then return nms end if
    end if
    if s == _MPPlatform_ToInt(_mp_client_slot, 1) then
      nmc = MP_GetPlayerName()
      if typeof(nmc) == "string" and nmc != "" then return nmc end if
      return "Player"
    end if
    if s == 0 then
      hnm = _mp_client_host_name
      if typeof(hnm) == "string" and hnm != "" then return hnm end if
      return "Host"
    end if
  end if

  return "Player " + (s + 1)
end function

/*
* Function: MP_PlatformGetNodeCount
* Purpose: Returns active doom net node count for local multiplayer role.
*/
function MP_PlatformGetNodeCount()
  if _mp_role == _MPPLAT_ROLE_HOST then
    maxNode = 0
    i = 0
    while i < len(_mp_host_peers)
      p = _mp_host_peers[i]
      if typeof(p) == "struct" then
        s = _MPPlatform_ToInt(p.slot, 0)
        active = true
        if active and s > maxNode then maxNode = s end if
      end if
      i = i + 1
    end while
    return maxNode + 1
  end if
  if _mp_role == _MPPLAT_ROLE_CLIENT then
    s = _MPPlatform_ToInt(_mp_client_slot, 1)
    if s < 1 or s >= _MPPLAT_MAX_PLAYERS then s = 1 end if
    return s + 1
  end if
  return 1
end function

/*
* Function: MP_PlatformGetNumPlayers
* Purpose: Returns known active player count for local multiplayer role.
*/
function MP_PlatformGetNumPlayers()
  if _mp_role == _MPPLAT_ROLE_HOST then
    n = 1
    i = 0
    while i < len(_mp_host_peers)
      p = _mp_host_peers[i]
      if typeof(p) == "struct" then n = n + 1 end if
      i = i + 1
    end while
    return n
  end if
  if _mp_role == _MPPLAT_ROLE_CLIENT then
    if typeof(playeringame) == "array" and len(playeringame) > 0 then
      n = 0
      i = 0
      while i < len(playeringame)
        if typeof(playeringame[i]) == "bool" then
          if playeringame[i] then n = n + 1 end if
        else if _MPPlatform_ToInt(playeringame[i], 0) != 0 then
          n = n + 1
        end if
        i = i + 1
      end while
      if n < 2 then n = 2 end if
      if n > _MPPLAT_MAX_PLAYERS then n = _MPPLAT_MAX_PLAYERS end if
      return n
    end if
    return 2
  end if
  return 1
end function

/*
* Function: MP_PlatformGetActiveSlots
* Purpose: Returns array of currently active player slots (always includes host slot 0).
*/
function MP_PlatformGetActiveSlots()
  if _mp_role == _MPPLAT_ROLE_HOST then
    slots = array(_MPPLAT_MAX_PLAYERS, 0)
    count = 1
    i = 0
    while i < len(_mp_host_peers)
      p = _mp_host_peers[i]
      if typeof(p) == "struct" then
        s = _MPPlatform_ToInt(p.slot, -1)
        active = true
        if active and s >= 1 and s < _MPPLAT_MAX_PLAYERS and count < len(slots) then
          slots[count] = s
          count = count + 1
        end if
      end if
      i = i + 1
    end while
    activeSlots = array(count, 0)
    i = 0
    while i < count
      activeSlots[i] = slots[i]
      i = i + 1
    end while
    return activeSlots
  end if
  if _mp_role == _MPPLAT_ROLE_CLIENT then
    s = _MPPlatform_ToInt(_mp_client_slot, 1)
    if s < 1 or s >= _MPPLAT_MAX_PLAYERS then s = 1 end if
    slots = array(_MPPLAT_MAX_PLAYERS, 0)
    count = 1
    if typeof(playeringame) == "array" and len(playeringame) > 0 then
      i = 1
      while i < len(playeringame) and i < _MPPLAT_MAX_PLAYERS
        active = false
        if typeof(playeringame[i]) == "bool" then
          active = playeringame[i]
        else
          active = _MPPlatform_ToInt(playeringame[i], 0) != 0
        end if
        if active and count < len(slots) then
          slots[count] = i
          count = count + 1
        end if
        i = i + 1
      end while
      hasLocal = false
      i = 0
      while i < count
        if _MPPlatform_ToInt(slots[i], -1) == s then
          hasLocal = true
          break
        end if
        i = i + 1
      end while
      if not hasLocal and count < len(slots) then
        slots[count] = s
        count = count + 1
      end if
      activeSlots = array(count, 0)
      i = 0
      while i < count
        activeSlots[i] = slots[i]
        i = i + 1
      end while
      return activeSlots
    end if
    return [0, s]
  end if
  return [0]
end function

/*
* Function: _MPPlatform_SanitizeField
* Purpose: Removes wire-delimiter/control bytes from textual packet fields.
*/
function _MPPlatform_SanitizeField(s0)
  if typeof(s0) != "string" then return "" end if
  s0 = str.replaceAll(s0, "|", "/")
  s0 = str.replaceAll(s0, "\r", " ")
  s0 = str.replaceAll(s0, "\n", " ")
  return s0
end function

/*
* Function: _MPPlatform_CloseSocketOnly
* Purpose: Closes active UDP socket if currently open.
*/
function _MPPlatform_CloseSocketOnly()
  global _mp_sock
  if typeof(_mp_sock) == "int" or typeof(_mp_sock) == "ptr" then
    net.close(_mp_sock)
  end if
  _mp_sock = void
end function

/*
* Function: _MPPlatform_SetNonBlocking
* Purpose: Configures UDP socket to non-blocking mode.
*/
function _MPPlatform_SetNonBlocking(sock, enabled)
  arg = bytes(4, 0)
  if enabled then arg[0] = 1 end if
  rc = ioctlsocket(sock, _MPPLAT_FIONBIO, arg)
  return rc == 0
end function

/*
* Function: _MPPlatform_SockAddrAny
* Purpose: Builds an IPv4 INADDR_ANY sockaddr_in buffer for local UDP bind checks.
*/
function _MPPlatform_SockAddrAny(port)
  p = _MPPlatform_ToInt(port, 0)
  if p < 0 then p = 0 end if
  if p > 65535 then p = 65535 end if
  a = bytes(16, 0)
  a[0] = _MPPLAT_AF_INET & 255
  a[1] = (_MPPLAT_AF_INET >> 8) & 255
  a[2] = (p >> 8) & 255
  a[3] = p & 255
  return a
end function

/*
* Function: _MPPlatform_CanBindUdpPort
* Purpose: Performs a non-throwing raw WinSock bind probe so host start can fail gracefully.
*/
function _MPPlatform_CanBindUdpPort(port)
  if typeof(net.init) == "function" then
    if not net.init() then return false end if
  end if
  s = socket(_MPPLAT_AF_INET, _MPPLAT_SOCK_DGRAM, _MPPLAT_IPPROTO_UDP)
  if typeof(s) != "int" and typeof(s) != "ptr" then return false end if
  addr = _MPPlatform_SockAddrAny(port)
  rc = bind(s, addr, len(addr))
  closesocket(s)
  return rc == 0
end function

/*
* Function: _MPPlatform_SetRecvTimeout
* Purpose: Configures socket receive timeout in milliseconds.
*/
function _MPPlatform_SetRecvTimeout(sock, timeoutMs)
  t = _MPPlatform_ToInt(timeoutMs, 1)
  if t < 1 then t = 1 end if
  if t > 2000 then t = 2000 end if
  b = bytes(4, 0)
  b[0] = t & 255
  b[1] = (t >> 8) & 255
  b[2] = (t >> 16) & 255
  b[3] = (t >> 24) & 255
  rc = setsockopt(sock, net.SOL_SOCKET, _MPPLAT_SO_RCVTIMEO, b, 4)
  return rc == 0
end function

/*
* Function: _MPPlatform_PendingBytes
* Purpose: Returns pending receive bytes count for the socket, or -1 on failure.
*/
function _MPPlatform_PendingBytes(sock)
  arg = bytes(4, 0)
  rc = ioctlsocket(sock, _MPPLAT_FIONREAD, arg)
  if rc != 0 then return -1 end if
  return arg[0] | (arg[1] << 8) | (arg[2] << 16) | (arg[3] << 24)
end function

/*
* Function: _MPPlatform_IsWouldBlockError
* Purpose: Checks whether a net error maps to WSAEWOULDBLOCK.
*/
function _MPPlatform_IsWouldBlockError(v)
  if typeof(v) != "error" then return false end if
  code = net.lastError()
  return code == _MPPLAT_WOULDBLOCK or code == _MPPLAT_TIMEDOUT
end function

/*
* Function: _MPPlatform_SendFields
* Purpose: Encodes and sends a textual UDP packet with field separators.
*/
function _MPPlatform_SendFields(sock, ip, port, fields)
  msg = str.join(fields, "|")
  return net.udpSendTo(sock, ip, port, bytes(msg))
end function

/*
* Function: _MPPlatform_FindHostPeerIndex
* Purpose: Finds existing host peer entry by ip/port tuple.
*/
function _MPPlatform_FindHostPeerIndex(ip, port)
  if typeof(_mp_host_peers) != "array" then return -1 end if
  i = 0
  while i < len(_mp_host_peers)
    p = _mp_host_peers[i]
    if typeof(p) == "struct" and p.ip == ip and _MPPlatform_ToInt(p.port, -1) == port then
      return i
    end if
    i = i + 1
  end while
  return -1
end function

/*
* Function: _MPPlatform_IsPeerIdUsed
* Purpose: Checks whether a host peer id is already occupied.
*/
function _MPPlatform_IsPeerIdUsed(pid)
  if pid == 1 then return true end if
  i = 0
  while i < len(_mp_host_peers)
    p = _mp_host_peers[i]
    if typeof(p) == "struct" and _MPPlatform_ToInt(p.peerid, 0) == pid then return true end if
    i = i + 1
  end while
  return false
end function

/*
* Function: _MPPlatform_IsSlotUsed
* Purpose: Checks whether a host player slot index is already used by a peer.
*/
function _MPPlatform_IsSlotUsed(slot)
  if slot < 1 or slot >= _MPPLAT_MAX_PLAYERS then return true end if
  i = 0
  while i < len(_mp_host_peers)
    p = _mp_host_peers[i]
    if typeof(p) == "struct" and _MPPlatform_ToInt(p.slot, 0) == slot then return true end if
    i = i + 1
  end while
  return false
end function

/*
* Function: _MPPlatform_AllocHostSlot
* Purpose: Allocates a free player slot [1..MAXPLAYERS-1] for a joining client.
*/
function _MPPlatform_AllocHostSlot()
  s = 1
  while s < _MPPLAT_MAX_PLAYERS
    if not _MPPlatform_IsSlotUsed(s) then return s end if
    s = s + 1
  end while
  return 0
end function

/*
* Function: _MPPlatform_FindHostPeerBySlot
* Purpose: Returns host peer index for a given slot, or -1 if not found.
*/
function inline _MPPlatform_FindHostPeerBySlot(slot)
  i = 0
  while i < len(_mp_host_peers)
    p = _mp_host_peers[i]
    if typeof(p) == "struct" and _MPPlatform_ToInt(p.slot, 0) == slot then return i end if
    i = i + 1
  end while
  return -1
end function

/*
* Function: _MPPlatform_QueueEnsureCapacity
* Purpose: Grows game packet queue storage in chunks so enqueue stays O(1) in steady state.
*/
function _MPPlatform_QueueEnsureCapacity(required)
  global _mp_game_queue_nodes
  global _mp_game_queue_payloads

  need = _MPPlatform_ToInt(required, 0)
  if need <= 0 then return end if
  if typeof(_mp_game_queue_nodes) != "array" then _mp_game_queue_nodes = [] end if
  if typeof(_mp_game_queue_payloads) != "array" then _mp_game_queue_payloads = [] end if

  cap = len(_mp_game_queue_nodes)
  payCap = len(_mp_game_queue_payloads)
  if payCap < cap then
    _mp_game_queue_payloads = _mp_game_queue_payloads + array(cap - payCap, 0)
    payCap = cap
  end if
  if cap < payCap then
    _mp_game_queue_nodes = _mp_game_queue_nodes + array(payCap - cap, 0)
    cap = payCap
  end if

  if cap < need then
    grow = need - cap
    rem = grow % _MPPLAT_GAME_QUEUE_CHUNK
    if rem != 0 then grow = grow + (_MPPLAT_GAME_QUEUE_CHUNK - rem) end if
    _mp_game_queue_nodes = _mp_game_queue_nodes + array(grow, 0)
    _mp_game_queue_payloads = _mp_game_queue_payloads + array(grow, 0)
  end if
end function

/*
* Function: _MPPlatform_QueueGamePacket
* Purpose: Enqueues gameplay packet payload for d_net/i_net processing.
*/
function _MPPlatform_QueueGamePacket(node, payload)
  global _mp_game_queue_nodes
  global _mp_game_queue_payloads
  global _mp_game_queue_head
  global _mp_game_queue_tail
  global _mp_game_queue_dropped
  p = payload
  if typeof(p) != "bytes" then
    p = _MPPlatform_ToBytesCopy(payload)
  end if
  if typeof(p) != "bytes" then return end if
  if typeof(_mp_game_queue_nodes) != "array" then _mp_game_queue_nodes = [] end if
  if typeof(_mp_game_queue_payloads) != "array" then _mp_game_queue_payloads = [] end if
  if typeof(_mp_game_queue_head) != "int" then _mp_game_queue_head = 0 end if
  if typeof(_mp_game_queue_tail) != "int" then _mp_game_queue_tail = 0 end if
  if _mp_game_queue_head < 0 then _mp_game_queue_head = 0 end if
  if _mp_game_queue_tail < _mp_game_queue_head then _mp_game_queue_tail = _mp_game_queue_head end if

  cap = len(_mp_game_queue_nodes)
  if _mp_game_queue_head > 0 and _mp_game_queue_tail >= cap then
    live = _mp_game_queue_tail - _mp_game_queue_head
    if live < 0 then live = 0 end if
    i = 0
    while i < live
      _mp_game_queue_nodes[i] = _mp_game_queue_nodes[_mp_game_queue_head + i]
      _mp_game_queue_payloads[i] = _mp_game_queue_payloads[_mp_game_queue_head + i]
      i = i + 1
    end while
    while i < _mp_game_queue_tail
      _mp_game_queue_nodes[i] = 0
      _mp_game_queue_payloads[i] = 0
      i = i + 1
    end while
    _mp_game_queue_head = 0
    _mp_game_queue_tail = live
    cap = len(_mp_game_queue_nodes)
  end if

  need = _mp_game_queue_tail + 1
  if need > cap then
    _MPPlatform_QueueEnsureCapacity(need)
    cap = len(_mp_game_queue_nodes)
  end if
  if _mp_game_queue_tail < 0 or _mp_game_queue_tail >= cap then return end if

  // Hard queue cap to prevent unbounded growth under burst load.
  while _MPPlatform_QueueDepth() >= _MPPLAT_GAME_QUEUE_MAX
    if _mp_game_queue_head < 0 then _mp_game_queue_head = 0 end if
    if _mp_game_queue_head >= _mp_game_queue_tail then
      _mp_game_queue_head = 0
      _mp_game_queue_tail = 0
      break
    end if
    if _mp_game_queue_head < len(_mp_game_queue_nodes) then _mp_game_queue_nodes[_mp_game_queue_head] = 0 end if
    if _mp_game_queue_head < len(_mp_game_queue_payloads) then _mp_game_queue_payloads[_mp_game_queue_head] = 0 end if
    _mp_game_queue_head = _mp_game_queue_head + 1
    _mp_game_queue_dropped = _MPPlatform_ToInt(_mp_game_queue_dropped, 0) + 1
  end while

  if _mp_game_queue_head >= _mp_game_queue_tail then
    _mp_game_queue_head = 0
    _mp_game_queue_tail = 0
  end if

  if _mp_game_queue_tail >= len(_mp_game_queue_nodes) then
    cap = len(_mp_game_queue_nodes)
    if _mp_game_queue_head > 0 and _mp_game_queue_tail >= cap then
      live = _mp_game_queue_tail - _mp_game_queue_head
      if live < 0 then live = 0 end if
      i = 0
      while i < live
        _mp_game_queue_nodes[i] = _mp_game_queue_nodes[_mp_game_queue_head + i]
        _mp_game_queue_payloads[i] = _mp_game_queue_payloads[_mp_game_queue_head + i]
        i = i + 1
      end while
      while i < _mp_game_queue_tail
        _mp_game_queue_nodes[i] = 0
        _mp_game_queue_payloads[i] = 0
        i = i + 1
      end while
      _mp_game_queue_head = 0
      _mp_game_queue_tail = live
      cap = len(_mp_game_queue_nodes)
    end if
    need = _mp_game_queue_tail + 1
    if need > cap then
      _MPPlatform_QueueEnsureCapacity(need)
    end if
    if _mp_game_queue_tail < 0 or _mp_game_queue_tail >= len(_mp_game_queue_nodes) then return end if
  end if

  _mp_game_queue_nodes[_mp_game_queue_tail] = node
  _mp_game_queue_payloads[_mp_game_queue_tail] = p
  _mp_game_queue_tail = _mp_game_queue_tail + 1
end function

/*
* Function: _MPPlatform_PopGamePacket
* Purpose: Dequeues one gameplay packet as [node,payload], or void when empty.
*/
function _MPPlatform_PopGamePacket()
  global _mp_game_queue_nodes
  global _mp_game_queue_payloads
  global _mp_game_queue_head
  global _mp_game_queue_tail
  if typeof(_mp_game_queue_nodes) != "array" or typeof(_mp_game_queue_payloads) != "array" then return end if
  if typeof(_mp_game_queue_head) != "int" then _mp_game_queue_head = 0 end if
  if typeof(_mp_game_queue_tail) != "int" then _mp_game_queue_tail = 0 end if
  if len(_mp_game_queue_nodes) <= 0 or len(_mp_game_queue_payloads) <= 0 then
    _mp_game_queue_head = 0
    _mp_game_queue_tail = 0
    return
  end if

  if _mp_game_queue_head < 0 then _mp_game_queue_head = 0 end if
  if _mp_game_queue_tail < 0 then _mp_game_queue_tail = 0 end if
  if _mp_game_queue_head > _mp_game_queue_tail then _mp_game_queue_head = _mp_game_queue_tail end if
  if _mp_game_queue_tail > len(_mp_game_queue_nodes) then _mp_game_queue_tail = len(_mp_game_queue_nodes) end if
  if _mp_game_queue_tail > len(_mp_game_queue_payloads) then _mp_game_queue_tail = len(_mp_game_queue_payloads) end if
  if _mp_game_queue_head >= _mp_game_queue_tail then
    _mp_game_queue_head = 0
    _mp_game_queue_tail = 0
    return
  end if

  node = _mp_game_queue_nodes[_mp_game_queue_head]
  payload = _mp_game_queue_payloads[_mp_game_queue_head]
  _mp_game_queue_nodes[_mp_game_queue_head] = 0
  _mp_game_queue_payloads[_mp_game_queue_head] = 0
  _mp_game_queue_head = _mp_game_queue_head + 1

  if _mp_game_queue_head >= _mp_game_queue_tail then
    _mp_game_queue_head = 0
    _mp_game_queue_tail = 0
  else if _mp_game_queue_head >= _MPPLAT_GAME_QUEUE_CHUNK and (_mp_game_queue_head * 2) >= _mp_game_queue_tail then
    live = _mp_game_queue_tail - _mp_game_queue_head
    if live < 0 then live = 0 end if
    i = 0
    while i < live
      _mp_game_queue_nodes[i] = _mp_game_queue_nodes[_mp_game_queue_head + i]
      _mp_game_queue_payloads[i] = _mp_game_queue_payloads[_mp_game_queue_head + i]
      i = i + 1
    end while
    while i < _mp_game_queue_tail
      _mp_game_queue_nodes[i] = 0
      _mp_game_queue_payloads[i] = 0
      i = i + 1
    end while
    _mp_game_queue_head = 0
    _mp_game_queue_tail = live
  end if

  return [node, payload]
end function

/*
* Function: _MPPlatform_IsGamePacket
* Purpose: Checks whether payload uses MiniDoom gameplay UDP frame format.
*/
function inline _MPPlatform_IsGamePacket(payload)
  if typeof(payload) != "bytes" then return false end if
  if len(payload) < 7 then return false end if
  return (payload[0] & 255) == _MPPLAT_GAME_MAGIC0 and (payload[1] & 255) == _MPPLAT_GAME_MAGIC1 and (payload[2] & 255) == _MPPLAT_GAME_MAGIC2 and (payload[3] & 255) == _MPPLAT_GAME_MAGIC3
end function

/*
* Function: _MPPlatform_GameChecksum16
* Purpose: Computes a lightweight 16-bit checksum across gameplay payload bytes.
*/
function inline _MPPlatform_GameChecksum16(payload, n)
  if typeof(payload) != "bytes" then return 0 end if
  lim = _MPPlatform_ToInt(n, 0)
  if lim < 0 then lim = 0 end if
  if lim > len(payload) then lim = len(payload) end if
  sum = 0
  i = 0
  while i < lim
    sum = (sum + (payload[i] & 255)) & 65535
    // Rotate-left by one bit after each byte to spread bit patterns.
    sum = ((sum << 1) & 65535) | ((sum >> 15) & 1)
    i = i + 1
  end while
  return sum & 65535
end function

/*
* Function: _MPPlatform_UnwrapGamePayload
* Purpose: Decodes gameplay frame and returns payload bytes.
*/
function _MPPlatform_UnwrapGamePayload(packet)
  if not _MPPlatform_IsGamePacket(packet) then return end if
  declared = (packet[5] & 255) | ((packet[6] & 255) << 8)
  if declared < 0 then return end if
  if 7 + declared > len(packet) then return end if
  // New frame format appends checksum16 (little-endian) after payload.
  hasChecksum = (7 + declared + 2) <= len(packet)
  expectedCsum = 0
  if hasChecksum then
    expectedCsum = (packet[7 + declared] & 255) | ((packet[7 + declared + 1] & 255) << 8)
  end if
  bufCopy = bytes(declared, 0)
  i = 0
  while i < declared
    bufCopy[i] = packet[7 + i] & 255
    i = i + 1
  end while
  if hasChecksum then
    actualCsum = _MPPlatform_GameChecksum16(bufCopy, declared)
    if actualCsum != expectedCsum then return end if
  end if
  return bufCopy
end function

/*
* Function: _MPPlatform_WrapGamePayload
* Purpose: Encodes gameplay payload in MiniDoom gameplay UDP frame format.
*/
function _MPPlatform_WrapGamePayload(localSlot, payload)
  if typeof(payload) != "bytes" then return bytes(0) end if
  n = len(payload)
  if n > 65535 then n = 65535 end if
  packet = bytes(9 + n, 0)
  packet[0] = _MPPLAT_GAME_MAGIC0
  packet[1] = _MPPLAT_GAME_MAGIC1
  packet[2] = _MPPLAT_GAME_MAGIC2
  packet[3] = _MPPLAT_GAME_MAGIC3
  packet[4] = localSlot & 255
  packet[5] = n & 255
  packet[6] = (n >> 8) & 255
  i = 0
  while i < n
    packet[7 + i] = payload[i]
    i = i + 1
  end while
  csum = _MPPlatform_GameChecksum16(payload, n)
  packet[7 + n] = csum & 255
  packet[7 + n + 1] = (csum >> 8) & 255
  return packet
end function

/*
* Function: _MPPlatform_AllocHostPeerId
* Purpose: Allocates next available host-side peer id for a joining client.
*/
function _MPPlatform_AllocHostPeerId()
  global _mp_host_next_peer_id
  pid = _MPPlatform_ToInt(_mp_host_next_peer_id, 2)
  if pid < 2 then pid = 2 end if

  tries = 0
  while tries < 252
    if not _MPPlatform_IsPeerIdUsed(pid) then
      _mp_host_next_peer_id = pid + 1
      if _mp_host_next_peer_id > 255 then _mp_host_next_peer_id = 2 end if
      return pid
    end if
    pid = pid + 1
    if pid > 255 then pid = 2 end if
    tries = tries + 1
  end while
  return 0
end function

/*
* Function: _MPPlatform_UpsertHostPeer
* Purpose: Creates or refreshes host peer entry and returns assigned peer id.
*/
function _MPPlatform_UpsertHostPeer(ip, port, name)
  global _mp_host_peers
  nowMs = _MPPlatform_ToInt(time.ticks(), 0)
  idx = _MPPlatform_FindHostPeerIndex(ip, port)
  if idx >= 0 and idx < len(_mp_host_peers) then
    p = _mp_host_peers[idx]
    p = _MPPlatform_EnsurePeerTelemetry(p)
    p.lastSeenMs = nowMs
    if typeof(name) == "string" and name != "" then p.name = name end if
    _mp_host_peers[idx] = p
    return _MPPlatform_ToInt(p.slot, 0)
  end if

  if len(_mp_host_peers) + 1 >= _MPPlatform_ToInt(_mp_host_max_players_cfg, 4) then
    return 0
  end if

  pid = _MPPlatform_AllocHostPeerId()
  if pid <= 0 then return 0 end if
  slot = _MPPlatform_AllocHostSlot()
  if slot <= 0 then return 0 end if

  peer = _mp_peer_t(ip, port, name, slot, pid, true, nowMs, 0, 0, 0, -1, 0, 0, 0, 0)
  _mp_host_peers = _mp_host_peers + [peer]
  _MPPlatform_SetStatus(name + " connected (" + ip + ":" + port + ")")
  return slot
end function

/*
* Function: _MPPlatform_RemoveHostPeerByIndex
* Purpose: Removes host peer entry and emits leave status if requested.
*/
function _MPPlatform_RemoveHostPeerByIndex(idx, withMessage)
  global _mp_host_peers
  if idx < 0 or idx >= len(_mp_host_peers) then return false end if
  keep = []
  i = 0
  while i < len(_mp_host_peers)
    if i != idx then
      keep = keep + [_mp_host_peers[i]]
    else if withMessage then
      p = _mp_host_peers[i]
      nm = "Player"
      if typeof(p) == "struct" and typeof(p.name) == "string" and p.name != "" then nm = p.name end if
      _MPPlatform_SetStatus(nm + " left")
    end if
    i = i + 1
  end while
  _mp_host_peers = keep
  return true
end function

/*
* Function: _MPPlatform_HostSendDeny
* Purpose: Sends a host-side join denial packet with optional server hash context.
*/
function _MPPlatform_HostSendDeny(ip, port, reasonCode, reasonText, includeHash)
  fields = [_MPPLAT_PROTO, _MPPLAT_DEN, reasonCode, _MPPlatform_SanitizeField(reasonText)]
  if includeHash then fields = fields + [mp_iwad_fnv1a_hex] end if
  _MPPlatform_SendFields(_mp_sock, ip, port, fields)
end function

/*
* Function: _MPPlatform_HostSendAccept
* Purpose: Sends an accept packet with server-authoritative lobby settings.
*/
function _MPPlatform_HostSendAccept(ip, port, slot, peerId)
  hostName = MP_SanitizeName(MP_GetPlayerName())
  if hostName == "" then hostName = "Host" end if
  fields = [
  _MPPLAT_PROTO,
  _MPPLAT_ACC,
  peerId,
  slot,
  _MPPlatform_ToInt(_mp_host_mode_cfg, MP_MODE_COOP),
  _MPPlatform_SanitizeField(_mp_host_map_cfg),
  _MPPlatform_ToInt(_mp_host_skill_cfg, MP_SKILL_MEDIUM),
  _MPPlatform_ToInt(_mp_host_frag_limit_cfg, 0),
  _MPPlatform_ToInt(_mp_host_time_limit_cfg, 0),
  _MPPlatform_SanitizeField(hostName),
  mp_iwad_fnv1a_hex
]
  _MPPlatform_SendFields(_mp_sock, ip, port, fields)
end function

/*
* Function: _MPPlatform_HostHandlePacket
* Purpose: Processes host-side incoming UDP packet for join/ping flow.
*/
function _MPPlatform_HostHandlePacket(payload, peerIp, peerPort)
  if typeof(payload) != "bytes" then return end if
  text = decode(payload)
  if typeof(text) != "string" or text == "" then return end if
  parts = str.split(text, "|")
  if typeof(parts) != "array" or len(parts) < 2 then return end if
  if parts[0] != _MPPLAT_PROTO then return end if

  mtype = parts[1]
  if mtype == _MPPLAT_REQ then
    if len(parts) < 10 then
      _MPPlatform_HostSendDeny(peerIp, peerPort, 6, "Malformed connect request.", false)
      return
    end if

    pname = MP_SanitizeName(parts[2])
    clientSha = parts[3]
    if pname == "" then
      _MPPlatform_HostSendDeny(peerIp, peerPort, 4, "Invalid player name.", false)
      return
    end if

    if typeof(mp_iwad_fnv1a_hex) != "string" or mp_iwad_fnv1a_hex == "" then
      _MPPlatform_HostSendDeny(peerIp, peerPort, 6, "Server missing IWAD fingerprint.", false)
      return
    end if

    if clientSha != mp_iwad_fnv1a_hex then
      _MPPlatform_HostSendDeny(peerIp, peerPort, 3, "WAD fingerprint mismatch.", true)
      return
    end if

    assignedSlot = _MPPlatform_UpsertHostPeer(peerIp, peerPort, pname)
    if assignedSlot <= 0 then
      _MPPlatform_HostSendDeny(peerIp, peerPort, 2, "Server full.", false)
      return
    end if

    peerSlot = assignedSlot
    peerId = 0
    idxPeer = _MPPlatform_FindHostPeerIndex(peerIp, peerPort)
    if idxPeer >= 0 and idxPeer < len(_mp_host_peers) then
      p = _mp_host_peers[idxPeer]
      if typeof(p) == "struct" then
        peerSlot = _MPPlatform_ToInt(p.slot, peerSlot)
        peerId = _MPPlatform_ToInt(p.peerid, 0)
      end if
    end if
    if peerId <= 0 then peerId = peerSlot end if

    _MPPlatform_HostSendAccept(peerIp, peerPort, peerSlot, peerId)
    return
  end if

  if mtype == _MPPLAT_PING then
    idx = _MPPlatform_FindHostPeerIndex(peerIp, peerPort)
    seq = 0
    if len(parts) >= 3 then seq = _MPPlatform_ToInt(parts[2], 0) end if
    if idx >= 0 and idx < len(_mp_host_peers) then
      p = _MPPlatform_EnsurePeerTelemetry(_mp_host_peers[idx])
      p.lastSeenMs = _MPPlatform_ToInt(time.ticks(), 0)
      _mp_host_peers[idx] = p
    end if
    _MPPlatform_SendFields(_mp_sock, peerIp, peerPort, [_MPPLAT_PROTO, _MPPLAT_PONG, seq])
    return
  end if

  if mtype == _MPPLAT_PONG then
    idx = _MPPlatform_FindHostPeerIndex(peerIp, peerPort)
    if idx >= 0 and idx < len(_mp_host_peers) then
      nowMs = _MPPlatform_ToInt(time.ticks(), 0)
      p = _MPPlatform_EnsurePeerTelemetry(_mp_host_peers[idx])
      p.lastSeenMs = nowMs
      p.lastPongMs = nowMs
      p.pongRecvCount = _MPPlatform_ToInt(p.pongRecvCount, 0) + 1
      if len(parts) >= 3 then
        seq = _MPPlatform_ToInt(parts[2], 0)
        if seq == _MPPlatform_ToInt(p.pingSeq, 0) and _MPPlatform_ToInt(p.lastPingTxMs, 0) > 0 then
          rtt = nowMs - _MPPlatform_ToInt(p.lastPingTxMs, nowMs)
          if rtt < 0 then rtt = 0 end if
          p.rttMs = rtt
        end if
      end if
      _mp_host_peers[idx] = p
    end if
    return
  end if

  if mtype == _MPPLAT_LEAVE then
    idx = _MPPlatform_FindHostPeerIndex(peerIp, peerPort)
    if idx >= 0 then _MPPlatform_RemoveHostPeerByIndex(idx, true) end if
  end if
end function

/*
* Function: _MPPlatform_ClientHandlePacket
* Purpose: Processes runtime client-side maintenance packets after join.
*/
function _MPPlatform_ClientHandlePacket(payload, peerIp, peerPort)
  global _mp_client_last_ping_ms
  global _mp_client_last_pong_ms
  global _mp_client_pong_recv
  global _mp_client_rtt_ms
  if peerIp != _mp_client_host or peerPort != _mp_client_port then return end if
  if typeof(payload) != "bytes" then return end if
  text = decode(payload)
  if typeof(text) != "string" or text == "" then return end if
  parts = str.split(text, "|")
  if typeof(parts) != "array" or len(parts) < 2 then return end if
  if parts[0] != _MPPLAT_PROTO then return end if

  mtype = parts[1]
  if mtype == _MPPLAT_DEN then
    reason = "Disconnected by host."
    if len(parts) >= 4 and typeof(parts[3]) == "string" and parts[3] != "" then reason = parts[3] end if
    _MPPlatform_SetError(reason)
    _MPPlatform_SetStatus(reason)
    MP_PlatformShutdown()
    return
  end if

  if mtype == _MPPLAT_PONG then
    nowMs = _MPPlatform_ToInt(time.ticks(), 0)
    _mp_client_last_ping_ms = nowMs
    _mp_client_last_pong_ms = nowMs
    _mp_client_pong_recv = _MPPlatform_ToInt(_mp_client_pong_recv, 0) + 1
    if len(parts) >= 3 then
      seq = _MPPlatform_ToInt(parts[2], 0)
      if seq == _MPPlatform_ToInt(_mp_client_ping_seq, 0) and _MPPlatform_ToInt(_mp_client_last_ping_tx_ms, 0) > 0 then
        rtt = nowMs - _MPPlatform_ToInt(_mp_client_last_ping_tx_ms, nowMs)
        if rtt < 0 then rtt = 0 end if
        _mp_client_rtt_ms = rtt
      end if
    end if
    return
  end if

  if mtype == _MPPLAT_PING then
    seq = 0
    if len(parts) >= 3 then seq = _MPPlatform_ToInt(parts[2], 0) end if
    _MPPlatform_SendFields(_mp_sock, _mp_client_host, _mp_client_port, [_MPPLAT_PROTO, _MPPLAT_PONG, seq])
  end if
end function

/*
* Function: _MPPlatform_ExpireHostPeers
* Purpose: Removes host peers that timed out and emits status updates.
*/
function _MPPlatform_ExpireHostPeers()
  global _mp_host_peers
  nowMs = _MPPlatform_ToInt(time.ticks(), 0)
  keep = []
  i = 0
  while i < len(_mp_host_peers)
    p = _mp_host_peers[i]
    if typeof(p) == "struct" then
      age = nowMs - _MPPlatform_ToInt(p.lastSeenMs, nowMs)
      if age <= _MPPLAT_HOST_PEER_TIMEOUT_MS then
        keep = keep + [p]
      else
        nm = p.name
        if typeof(nm) != "string" or nm == "" then nm = "Player" end if
        if typeof(p.ip) == "string" and p.ip != "" and _MPPlatform_ToInt(p.port, 0) > 0 then
          _MPPlatform_HostSendDeny(p.ip, _MPPlatform_ToInt(p.port, 0), 7, "Connection timed out.", false)
        end if
        _MPPlatform_SetStatus(nm + " left (timeout)")
      end if
    end if
    i = i + 1
  end while
  _mp_host_peers = keep
end function

/*
* Function: MP_PlatformPump
* Purpose: Processes non-blocking UDP packets for host/client maintenance.
*/
function MP_PlatformPump()
  global _mp_client_last_ping_ms
  global _mp_client_ping_seq
  global _mp_client_last_ping_tx_ms
  global _mp_client_ping_sent
  global _mp_client_game_in
  if _mp_role == _MPPLAT_ROLE_NONE then return end if
  if typeof(_mp_sock) != "int" and typeof(_mp_sock) != "ptr" then return end if

  loops = 0
  while loops < 48
    pkt = net.udpRecvFrom(_mp_sock, _MPPLAT_RECV_MAX)
    if typeof(pkt) == "error" then
      if _MPPlatform_IsWouldBlockError(pkt) then
        break
      end if
      _MPPlatform_SetError("UDP receive failed (" + net.lastError() + ")")
      break
    end if

    if typeof(pkt) == "array" and len(pkt) >= 3 then
      payload = _MPPlatform_ToBytesCopy(pkt[0])
      peerIp = pkt[1]
      peerPort = _MPPlatform_ToInt(pkt[2], 0)
      if typeof(payload) != "bytes" then
        loops = loops + 1
        continue
      end if
      if _MPPlatform_IsGamePacket(payload) then
        gp = _MPPlatform_UnwrapGamePayload(payload)
        if typeof(gp) == "bytes" then
          if _mp_role == _MPPLAT_ROLE_HOST then
            idx = _MPPlatform_FindHostPeerIndex(peerIp, peerPort)
            if idx < 0 then
              slotHdr = payload[4] & 255
              if slotHdr >= 1 and slotHdr < _MPPLAT_MAX_PLAYERS then
                idx = _MPPlatform_FindHostPeerBySlot(slotHdr)
              end if
            end if
            if idx >= 0 and idx < len(_mp_host_peers) then
              p = _MPPlatform_EnsurePeerTelemetry(_mp_host_peers[idx])
              // Keep endpoint fresh even if client source tuple changed after handshake.
              p.ip = peerIp
              p.port = peerPort
              active = _MPPlatform_PeerIngame(p)
              justActivated = false
              if not active then
                p.ingame = true
                justActivated = true
              end if
              p.lastSeenMs = _MPPlatform_ToInt(time.ticks(), 0)
              _mp_host_peers[idx] = p
              if justActivated then
                nm = p.name
                if typeof(nm) != "string" or nm == "" then nm = "Player" end if
                _MPPlatform_SetStatus(nm + " entered game")
              end if
              p.gameInCount = _MPPlatform_ToInt(p.gameInCount, 0) + 1
              _MPPlatform_QueueGamePacket(_MPPlatform_ToInt(p.slot, 0), gp)
            end if
          else if _mp_role == _MPPLAT_ROLE_CLIENT then
            if peerIp == _mp_client_host and peerPort == _mp_client_port then
              _mp_client_game_in = _MPPlatform_ToInt(_mp_client_game_in, 0) + 1
              _MPPlatform_QueueGamePacket(1, gp)
            end if
          end if
        end if
        loops = loops + 1
        continue
      end if
      if _mp_role == _MPPLAT_ROLE_HOST then
        _MPPlatform_HostHandlePacket(payload, peerIp, peerPort)
      else if _mp_role == _MPPLAT_ROLE_CLIENT then
        _MPPlatform_ClientHandlePacket(payload, peerIp, peerPort)
      end if
    end if
    loops = loops + 1
  end while

  if _mp_role == _MPPLAT_ROLE_HOST then
    nowMs = _MPPlatform_ToInt(time.ticks(), 0)
    i = 0
    while i < len(_mp_host_peers)
      p = _mp_host_peers[i]
      if typeof(p) == "struct" then
        p = _MPPlatform_EnsurePeerTelemetry(p)
        if nowMs - _MPPlatform_ToInt(p.lastPingTxMs, 0) >= _MPPLAT_HOST_PING_INTERVAL_MS then
          seq = _MPPlatform_ToInt(p.pingSeq, 0) + 1
          p.pingSeq = seq
          p.lastPingTxMs = nowMs
          p.pingSentCount = _MPPlatform_ToInt(p.pingSentCount, 0) + 1
          _MPPlatform_SendFields(_mp_sock, p.ip, _MPPlatform_ToInt(p.port, 0), [_MPPLAT_PROTO, _MPPLAT_PING, seq])
        end if
        _mp_host_peers[i] = p
      end if
      i = i + 1
    end while
    _MPPlatform_ExpireHostPeers()
    return
  end if

  if _mp_role == _MPPLAT_ROLE_CLIENT then
    nowMs = _MPPlatform_ToInt(time.ticks(), 0)
    if nowMs - _mp_client_last_ping_ms >= _MPPLAT_CLIENT_PING_INTERVAL_MS then
      _mp_client_ping_seq = _MPPlatform_ToInt(_mp_client_ping_seq, 0) + 1
      _mp_client_last_ping_tx_ms = nowMs
      _mp_client_ping_sent = _MPPlatform_ToInt(_mp_client_ping_sent, 0) + 1
      _mp_client_last_ping_ms = nowMs
      _MPPlatform_SendFields(_mp_sock, _mp_client_host, _mp_client_port, [_MPPLAT_PROTO, _MPPLAT_PING, _mp_client_ping_seq])
    end if
  end if
end function

/*
* Function: MP_PlatformShutdown
* Purpose: Shuts down multiplayer UDP runtime state and closes sockets.
*/
function MP_PlatformShutdown()
  global _mp_role
  global _mp_host_peers
  global _mp_host_next_peer_id
  global _mp_client_host
  global _mp_client_host_name
  global _mp_client_port
  global _mp_client_peer_id
  global _mp_client_slot
  global _mp_client_last_ping_ms
  global _mp_client_ping_seq
  global _mp_client_last_ping_tx_ms
  global _mp_client_last_pong_ms
  global _mp_client_rtt_ms
  global _mp_client_ping_sent
  global _mp_client_pong_recv
  global _mp_client_game_in
  global _mp_client_game_out
  global _mp_client_slot_names
  global _mp_debug_send_attempt
  global _mp_debug_send_ok
  global _mp_debug_send_idxfail
  global _mp_debug_send_err
  global _mp_game_queue_nodes
  global _mp_game_queue_payloads
  global _mp_game_queue_head
  global _mp_game_queue_tail

  if _mp_role == _MPPLAT_ROLE_CLIENT and (typeof(_mp_sock) == "int" or typeof(_mp_sock) == "ptr") and _mp_client_host != "" and _mp_client_port > 0 then
    _MPPlatform_SendFields(_mp_sock, _mp_client_host, _mp_client_port, [_MPPLAT_PROTO, _MPPLAT_LEAVE])
  end if

  _MPPlatform_CloseSocketOnly()
  _mp_role = _MPPLAT_ROLE_NONE
  _mp_host_peers = []
  _mp_host_next_peer_id = 2
  _mp_client_host = ""
  _mp_client_host_name = ""
  _mp_client_port = 0
  _mp_client_peer_id = 0
  _mp_client_slot = 1
  _mp_client_last_ping_ms = 0
  _mp_client_ping_seq = 0
  _mp_client_last_ping_tx_ms = 0
  _mp_client_last_pong_ms = 0
  _mp_client_rtt_ms = -1
  _mp_client_ping_sent = 0
  _mp_client_pong_recv = 0
  _mp_client_game_in = 0
  _mp_client_game_out = 0
  _mp_client_slot_names = []
  _mp_debug_send_attempt = 0
  _mp_debug_send_ok = 0
  _mp_debug_send_idxfail = 0
  _mp_debug_send_err = 0
  _mp_game_queue_nodes = []
  _mp_game_queue_payloads = []
  _mp_game_queue_head = 0
  _mp_game_queue_tail = 0
  _mp_game_queue_dropped = 0
end function

/*
* Function: MP_PlatformIsHosting
* Purpose: Reports whether local runtime is currently acting as UDP host.
*/
function inline MP_PlatformIsHosting()
  return _mp_role == _MPPLAT_ROLE_HOST
end function

/*
* Function: MP_PlatformNetSend
* Purpose: Sends a gameplay packet payload to a Doom remote node.
*/
function MP_PlatformNetSend(node, payload)
  global _mp_client_game_out
  global _mp_debug_send_attempt
  global _mp_debug_send_ok
  global _mp_debug_send_idxfail
  global _mp_debug_send_err
  if (typeof(_mp_sock) != "int" and typeof(_mp_sock) != "ptr") or typeof(payload) != "bytes" then return false end if
  n = _MPPlatform_ToInt(node, -1)
  if n < 0 then return false end if
  _mp_debug_send_attempt = _MPPlatform_ToInt(_mp_debug_send_attempt, 0) + 1

  localSlot = MP_PlatformGetLocalPlayerSlot()
  frame = _MPPlatform_WrapGamePayload(localSlot, payload)

  if _mp_role == _MPPLAT_ROLE_HOST then
    idx = _MPPlatform_FindHostPeerBySlot(n)
    if idx < 0 or idx >= len(_mp_host_peers) then
      _mp_debug_send_idxfail = _MPPlatform_ToInt(_mp_debug_send_idxfail, 0) + 1
      return false
    end if
    p = _MPPlatform_EnsurePeerTelemetry(_mp_host_peers[idx])
    sent = net.udpSendTo(_mp_sock, p.ip, _MPPlatform_ToInt(p.port, 0), frame)
    if typeof(sent) != "error" then
      p.gameOutCount = _MPPlatform_ToInt(p.gameOutCount, 0) + 1
      _mp_host_peers[idx] = p
      _mp_debug_send_ok = _MPPlatform_ToInt(_mp_debug_send_ok, 0) + 1
      return true
    end if
    _mp_debug_send_err = _MPPlatform_ToInt(_mp_debug_send_err, 0) + 1
    return typeof(sent) != "error"
  end if

  if _mp_role == _MPPLAT_ROLE_CLIENT then
    if n <= 0 then return false end if
    sent = net.udpSendTo(_mp_sock, _mp_client_host, _mp_client_port, frame)
    if typeof(sent) != "error" then
      _mp_client_game_out = _MPPlatform_ToInt(_mp_client_game_out, 0) + 1
      _mp_debug_send_ok = _MPPlatform_ToInt(_mp_debug_send_ok, 0) + 1
      return true
    end if
    _mp_debug_send_err = _MPPlatform_ToInt(_mp_debug_send_err, 0) + 1
    return typeof(sent) != "error"
  end if

  return false
end function

/*
* Function: MP_PlatformNetRecv
* Purpose: Pops one queued gameplay packet as [node,payload], or void if none.
*/
function inline MP_PlatformNetRecv()
  if _mp_role == _MPPLAT_ROLE_NONE then return end if
  return _MPPlatform_PopGamePacket()
end function

/*
* Function: _MPPlatform_SetError
* Purpose: Stores user-facing error text for multiplayer host/join operations.
*/
function _MPPlatform_SetError(msg)
  global _mp_platform_last_error
  if typeof(msg) != "string" then
    _mp_platform_last_error = ""
  else
    _mp_platform_last_error = msg
  end if
end function

/*
* Function: MP_PlatformGetLastError
* Purpose: Returns the last multiplayer platform error message.
*/
function MP_PlatformGetLastError()
  return _mp_platform_last_error
end function

/*
* Function: MP_PlatformHostGame
* Purpose: Starts a non-blocking UDP host endpoint for join handshakes.
*/
function MP_PlatformHostGame(port, mode, skill, mapname, maxPlayers, fragLimit, timeLimit)
  global _mp_sock
  global _mp_role
  global _mp_host_mode_cfg
  global _mp_host_map_cfg
  global _mp_host_skill_cfg
  global _mp_host_max_players_cfg
  global _mp_host_frag_limit_cfg
  global _mp_host_time_limit_cfg
  global _mp_host_next_peer_id
  global _mp_host_peers
  global _mp_client_host
  global _mp_client_host_name
  global _mp_client_port
  global _mp_client_peer_id
  global _mp_client_slot
  global _mp_client_last_ping_ms
  global _mp_client_ping_seq
  global _mp_client_last_ping_tx_ms
  global _mp_client_last_pong_ms
  global _mp_client_rtt_ms
  global _mp_client_ping_sent
  global _mp_client_pong_recv
  global _mp_client_game_in
  global _mp_client_game_out
  global _mp_client_slot_names
  global _mp_debug_send_attempt
  global _mp_debug_send_ok
  global _mp_debug_send_idxfail
  global _mp_debug_send_err
  global _mp_game_queue_nodes
  global _mp_game_queue_payloads
  global _mp_game_queue_head
  global _mp_game_queue_tail
  global _mp_game_queue_dropped
  MP_ClampSettings()
  if mp_iwad_fnv1a_hex == "" then
    _MPPlatform_SetError("MP host failed: missing IWAD fingerprint.")
    return false
  end if

  p = _MPPlatform_ToInt(port, MP_DEFAULT_PORT)
  if p < 1 then p = 1 end if
  if p > 65535 then p = 65535 end if

  m = _MPPlatform_ToInt(mode, MP_MODE_COOP)
  if m != MP_MODE_DEATHMATCH then m = MP_MODE_COOP end if
  sk = _MPPlatform_ToInt(skill, MP_SKILL_MEDIUM)
  if sk < MP_SKILL_BABY then sk = MP_SKILL_BABY end if
  if sk > MP_SKILL_NIGHTMARE then sk = MP_SKILL_NIGHTMARE end if
  maxP = _MPPlatform_ToInt(maxPlayers, 4)
  if maxP < 2 then maxP = 2 end if
  if maxP > _MPPLAT_MAX_PLAYERS then maxP = _MPPLAT_MAX_PLAYERS end if
  frag = _MPPlatform_ToInt(fragLimit, 0)
  if frag < 0 then frag = 0 end if
  timeL = _MPPlatform_ToInt(timeLimit, 0)
  if timeL < 0 then timeL = 0 end if
  mapToken = _MPPlatform_SanitizeField(mapname)
  if mapToken == "" then mapToken = MP_GetSelectedMap() end if

  MP_PlatformShutdown()
  if not _MPPlatform_CanBindUdpPort(p) then
    _MPPlatform_SetError("MP host failed: UDP port " + p + " is unavailable.")
    return false
  end if
  s = net.udpOpen()
  if typeof(s) == "error" then
    _MPPlatform_SetError("MP host failed: udpOpen failed (" + net.lastError() + ")")
    return false
  end if

  b = net.udpBind(s, p)
  if typeof(b) == "error" then
    net.close(s)
    _MPPlatform_SetError("MP host failed: bind on UDP port " + p + " failed (" + net.lastError() + ")")
    return false
  end if

  nbOk = _MPPlatform_SetNonBlocking(s, true)
  if not nbOk then
    net.close(s)
    _MPPlatform_SetError("MP host failed: could not enable non-blocking UDP mode.")
    return false
  end if
  _MPPlatform_SetRecvTimeout(s, 2)

  _mp_sock = s
  _mp_role = _MPPLAT_ROLE_HOST
  _mp_host_mode_cfg = m
  _mp_host_map_cfg = mapToken
  _mp_host_skill_cfg = sk
  _mp_host_max_players_cfg = maxP
  _mp_host_frag_limit_cfg = frag
  _mp_host_time_limit_cfg = timeL
  _mp_host_next_peer_id = 2
  _mp_host_peers = []
  _mp_client_host = ""
  _mp_client_host_name = ""
  _mp_client_port = 0
  _mp_client_peer_id = 0
  _mp_client_slot = 1
  _mp_client_last_ping_ms = _MPPlatform_ToInt(time.ticks(), 0)
  _mp_client_ping_seq = 0
  _mp_client_last_ping_tx_ms = 0
  _mp_client_last_pong_ms = 0
  _mp_client_rtt_ms = -1
  _mp_client_ping_sent = 0
  _mp_client_pong_recv = 0
  _mp_client_game_in = 0
  _mp_client_game_out = 0
  _mp_client_slot_names = []
  _mp_debug_send_attempt = 0
  _mp_debug_send_ok = 0
  _mp_debug_send_idxfail = 0
  _mp_debug_send_err = 0
  _mp_game_queue_nodes = []
  _mp_game_queue_payloads = []
  _mp_game_queue_head = 0
  _mp_game_queue_tail = 0
  _mp_game_queue_dropped = 0

  _MPPlatform_SetError("")
  _MPPlatform_SetStatus("Hosting UDP on port " + p + " (" + mapToken + ")")
  return true
end function

/*
* Function: MP_PlatformJoinGame
* Purpose: Sends UDP join request and waits with timeout for host response.
*/
function MP_PlatformJoinGame(host, port, playerName)
  global _mp_sock
  global _mp_role
  global _mp_client_host
  global _mp_client_host_name
  global _mp_client_port
  global _mp_client_peer_id
  global _mp_client_slot
  global _mp_client_last_ping_ms
  global _mp_client_ping_seq
  global _mp_client_last_ping_tx_ms
  global _mp_client_last_pong_ms
  global _mp_client_rtt_ms
  global _mp_client_ping_sent
  global _mp_client_pong_recv
  global _mp_client_game_in
  global _mp_client_game_out
  global _mp_client_slot_names
  global _mp_debug_send_attempt
  global _mp_debug_send_ok
  global _mp_debug_send_idxfail
  global _mp_debug_send_err
  global _mp_host_mode_cfg
  global _mp_host_map_cfg
  global _mp_host_skill_cfg
  global _mp_host_frag_limit_cfg
  global _mp_host_time_limit_cfg
  global _mp_game_queue_nodes
  global _mp_game_queue_payloads
  global _mp_game_queue_head
  global _mp_game_queue_tail
  global _mp_game_queue_dropped
  MP_ClampSettings()
  if mp_iwad_fnv1a_hex == "" then
    _MPPlatform_SetError("MP join failed: missing IWAD fingerprint.")
    return false
  end if

  h = host
  if typeof(h) != "string" then h = "" end if
  h = str.trim(h)
  if h == "" then
    _MPPlatform_SetError("MP join failed: host address is empty.")
    return false
  end if

  p = _MPPlatform_ToInt(port, MP_DEFAULT_PORT)
  if p < 1 then p = 1 end if
  if p > 65535 then p = 65535 end if

  nm = MP_SanitizeName(playerName)
  if nm == "" then nm = "Player" end if

  MP_PlatformShutdown()
  s = net.udpOpen()
  if typeof(s) == "error" then
    _MPPlatform_SetError("MP join failed: udpOpen failed (" + net.lastError() + ")")
    return false
  end if
  nbOk = _MPPlatform_SetNonBlocking(s, true)
  if not nbOk then
    net.close(s)
    _MPPlatform_SetError("MP join failed: could not enable non-blocking UDP mode.")
    return false
  end if
  _MPPlatform_SetRecvTimeout(s, 2)

  req = [
  _MPPLAT_PROTO,
  _MPPLAT_REQ,
  _MPPlatform_SanitizeField(nm),
  mp_iwad_fnv1a_hex,
  MP_MODE_COOP,
  _MPPlatform_SanitizeField(MP_GetSelectedMap()),
  MP_SKILL_MEDIUM,
  4,
  0,
  0
]
  sent = _MPPlatform_SendFields(s, h, p, req)
  if typeof(sent) == "error" then
    net.close(s)
    _MPPlatform_SetError("MP join failed: send request failed (" + net.lastError() + ")")
    return false
  end if

  t0 = _MPPlatform_ToInt(time.ticks(), 0)
  while _MPPlatform_ToInt(time.ticks(), 0) - t0 < _MPPLAT_TIMEOUT_MS
    _MPPlatform_WaitPulse()
    pkt = net.udpRecvFrom(s, _MPPLAT_RECV_MAX)
    if typeof(pkt) == "error" then
      if _MPPlatform_IsWouldBlockError(pkt) then
        _MPPlatform_WaitPulse()
        time.sleep(10)
        continue
      end if
      net.close(s)
      _MPPlatform_SetError("MP join failed: receive failed (" + net.lastError() + ")")
      return false
    end if

    if typeof(pkt) != "array" or len(pkt) < 3 then
      continue
    end if

    payload = _MPPlatform_ToBytesCopy(pkt[0])
    peerIp = pkt[1]
    peerPort = _MPPlatform_ToInt(pkt[2], 0)
    if typeof(payload) != "bytes" then continue end if

    text = decode(payload)
    if typeof(text) != "string" or text == "" then continue end if
    parts = str.split(text, "|")
    if typeof(parts) != "array" or len(parts) < 2 then continue end if
    if parts[0] != _MPPLAT_PROTO then continue end if

    mtype = parts[1]
    if mtype == _MPPLAT_DEN then
      reason = "Join denied by host."
      if len(parts) >= 4 and typeof(parts[3]) == "string" and parts[3] != "" then reason = parts[3] end if
      if len(parts) >= 5 and typeof(parts[4]) == "string" and parts[4] != "" and parts[4] != mp_iwad_fnv1a_hex then
        reason = reason + " (server WAD differs)"
      end if
      net.close(s)
      _MPPlatform_SetError(reason)
      return false
    end if

    if mtype == _MPPLAT_ACC then
      if len(parts) < 9 then
        net.close(s)
        _MPPlatform_SetError("MP join failed: malformed accept packet.")
        return false
      end if

      part_peer = 2
      part_slot = 3
      part_mode = 4
      part_map = 5
      part_skill = 6
      part_frag = 7
      part_time = 8
      part_host_name = 9
      part_hash = 10
      if len(parts) < 11 then
        part_host_name = -1
        part_hash = 9
      end if
      if len(parts) < 10 then
        // Legacy accept packet without explicit slot field.
        part_slot = -1
        part_mode = 3
        part_map = 4
        part_skill = 5
        part_frag = 6
        part_time = 7
        part_host_name = -1
        part_hash = 8
      end if

      if parts[part_hash] != mp_iwad_fnv1a_hex then
        net.close(s)
        _MPPlatform_SetError("MP join rejected: host WAD fingerprint does not match local IWAD.")
        return false
      end if

      _mp_sock = s
      _mp_role = _MPPLAT_ROLE_CLIENT
      _mp_client_host = peerIp
      _mp_client_host_name = "Host"
      if part_host_name >= 0 and part_host_name < len(parts) then
        hostName = MP_SanitizeName(parts[part_host_name])
        if hostName != "" then _mp_client_host_name = hostName end if
      end if
      _mp_client_port = peerPort
      _mp_client_peer_id = _MPPlatform_ToInt(parts[part_peer], 0)
      _mp_client_slot = 1
      if part_slot >= 0 then
        _mp_client_slot = _MPPlatform_ToInt(parts[part_slot], 1)
      end if
      if _mp_client_slot < 1 or _mp_client_slot >= _MPPLAT_MAX_PLAYERS then _mp_client_slot = 1 end if
      _mp_client_last_ping_ms = _MPPlatform_ToInt(time.ticks(), 0)
      _mp_client_ping_seq = 0
      _mp_client_last_ping_tx_ms = 0
      _mp_client_last_pong_ms = 0
      _mp_client_rtt_ms = -1
      _mp_client_ping_sent = 0
      _mp_client_pong_recv = 0
      _mp_client_game_in = 0
      _mp_client_game_out = 0
      _MPPlatform_InitClientSlotNames(nm)
      _mp_debug_send_attempt = 0
      _mp_debug_send_ok = 0
      _mp_debug_send_idxfail = 0
      _mp_debug_send_err = 0
      _mp_host_mode_cfg = _MPPlatform_ToInt(parts[part_mode], MP_MODE_COOP)
      _mp_host_map_cfg = _MPPlatform_SanitizeField(parts[part_map])
      _mp_host_skill_cfg = _MPPlatform_ToInt(parts[part_skill], MP_SKILL_MEDIUM)
      _mp_host_frag_limit_cfg = _MPPlatform_ToInt(parts[part_frag], 0)
      _mp_host_time_limit_cfg = _MPPlatform_ToInt(parts[part_time], 0)
      _mp_game_queue_nodes = []
      _mp_game_queue_payloads = []
      _mp_game_queue_head = 0
      _mp_game_queue_tail = 0
      _mp_game_queue_dropped = 0

      _MPPlatform_SetError("")
      _MPPlatform_SetStatus("Connected to " + peerIp + ":" + peerPort + " as " + nm)
      return true
    end if
  end while

  net.close(s)
  _MPPlatform_SetError("MP join failed: host did not respond (timeout).")
  return false
end function
