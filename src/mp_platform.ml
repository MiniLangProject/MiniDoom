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

//! Implements UDP multiplayer host/join handshake and runtime packet pump.


import mp_state
import doomstat
import std.net as net
import std.time as time
import std.string as str
import std.math
import std.fs as fs
#if TARGET_OS == "linux"
import platform_linux
#endif

/// Stores the mutable mp platform last error text used by the mp platform subsystem.
/// @internal
_mp_platform_last_error = ""
/// Stores the mutable mp platform last status text used by the mp platform subsystem.
/// @internal
_mp_platform_last_status = ""
/// Stores the mutable mp platform event log path text used by the mp platform subsystem.
/// @internal
_mp_platform_event_log_path = ""

/// Defines mpplat role none for the mp platform subsystem.
/// @internal
const _MPPLAT_ROLE_NONE = 0
/// Defines mpplat role host for the mp platform subsystem.
/// @internal
const _MPPLAT_ROLE_HOST = 1
/// Defines mpplat role client for the mp platform subsystem.
/// @internal
const _MPPLAT_ROLE_CLIENT = 2

/// Defines the mpplat proto text used by the mp platform subsystem.
/// @internal
const _MPPLAT_PROTO = "MDMP1"
/// Defines the mpplat req text used by the mp platform subsystem.
/// @internal
const _MPPLAT_REQ = "REQ"
/// Defines the mpplat acc text used by the mp platform subsystem.
/// @internal
const _MPPLAT_ACC = "ACC"
/// Defines the mpplat den text used by the mp platform subsystem.
/// @internal
const _MPPLAT_DEN = "DEN"
/// Defines the mpplat ping text used by the mp platform subsystem.
/// @internal
const _MPPLAT_PING = "PING"
/// Defines the mpplat pong text used by the mp platform subsystem.
/// @internal
const _MPPLAT_PONG = "PONG"
/// Defines the mpplat leave text used by the mp platform subsystem.
/// @internal
const _MPPLAT_LEAVE = "LEAVE"
/// Defines mpplat game magic0 for the mp platform subsystem.
/// @internal
const _MPPLAT_GAME_MAGIC0 = 77
/// Defines mpplat game magic1 for the mp platform subsystem.
/// @internal
const _MPPLAT_GAME_MAGIC1 = 68
/// Defines mpplat game magic2 for the mp platform subsystem.
/// @internal
const _MPPLAT_GAME_MAGIC2 = 71
/// Defines mpplat game magic3 for the mp platform subsystem.
/// @internal
const _MPPLAT_GAME_MAGIC3 = 49

/// Defines the maximum mpplat recv max accepted by the mp platform subsystem.
/// @internal
const _MPPLAT_RECV_MAX = 1400
/// Defines the maximum mpplat game payload max accepted by the mp platform subsystem.
/// @internal
const _MPPLAT_GAME_PAYLOAD_MAX = 1391
/// Defines the maximum mpplat control max accepted by the mp platform subsystem.
/// @internal
const _MPPLAT_CONTROL_MAX = 512
/// Defines mpplat timeout ms for the mp platform subsystem.
/// @internal
const _MPPLAT_TIMEOUT_MS = 2500
#if TARGET_OS == "windows"
/// Defines mpplat wouldblock for the mp platform subsystem.
/// @internal
const _MPPLAT_WOULDBLOCK = 10035
/// Defines mpplat timedout for the mp platform subsystem.
/// @internal
const _MPPLAT_TIMEDOUT = 10060
#else
/// Defines mpplat wouldblock for the mp platform subsystem.
/// @internal
const _MPPLAT_WOULDBLOCK = 11
/// Defines mpplat timedout for the mp platform subsystem.
/// @internal
const _MPPLAT_TIMEDOUT = 110
#endif
/// Defines mpplat host peer timeout ms for the mp platform subsystem.
/// @internal
const _MPPLAT_HOST_PEER_TIMEOUT_MS = 30000
/// Defines mpplat client host timeout ms for the mp platform subsystem.
/// @internal
const _MPPLAT_CLIENT_HOST_TIMEOUT_MS = 10000
/// Defines mpplat client ping interval ms for the mp platform subsystem.
/// @internal
const _MPPLAT_CLIENT_PING_INTERVAL_MS = 1000
/// Defines mpplat host ping interval ms for the mp platform subsystem.
/// @internal
const _MPPLAT_HOST_PING_INTERVAL_MS = 1000
/// Defines mpplat fionbio for the mp platform subsystem.
/// @internal
const _MPPLAT_FIONBIO = 0x8004667E
/// Defines the maximum mpplat max players accepted by the mp platform subsystem.
/// @internal
const _MPPLAT_MAX_PLAYERS = 4
/// Defines mpplat so rcvtimeo for the mp platform subsystem.
/// @internal
const _MPPLAT_SO_RCVTIMEO = 0x1006
/// Defines mpplat game queue chunk for the mp platform subsystem.
/// @internal
const _MPPLAT_GAME_QUEUE_CHUNK = 256
/// Defines the maximum mpplat game queue max accepted by the mp platform subsystem.
/// @internal
const _MPPLAT_GAME_QUEUE_MAX = 2048
/// Defines the maximum mpplat pump max packets accepted by the mp platform subsystem.
/// @internal
const _MPPLAT_PUMP_MAX_PACKETS = 192
/// Defines the minimum mpplat pump min packets accepted by the mp platform subsystem.
/// @internal
const _MPPLAT_PUMP_MIN_PACKETS = 48
/// Defines mpplat pump budget ms for the mp platform subsystem.
/// @internal
const _MPPLAT_PUMP_BUDGET_MS = 4

/// Tracks a connected remote multiplayer peer endpoint on host side.
/// @internal
struct _mp_peer_t
  /// Stores ip for `_mp_peer_t`
  ip
  /// Stores port for `_mp_peer_t`
  port
  /// Stable resource or object name stored by `_mp_peer_t`
  name
  /// Stores slot for `_mp_peer_t`
  slot
  /// Stores peerid for `_mp_peer_t`
  peerid
  /// Stores ingame for `_mp_peer_t`
  ingame
  /// Stores last seen ms for `_mp_peer_t`
  lastSeenMs
  /// Stores ping seq for `_mp_peer_t`
  pingSeq
  /// Stores last ping tx ms for `_mp_peer_t`
  lastPingTxMs
  /// Stores last pong ms for `_mp_peer_t`
  lastPongMs
  /// Stores rtt ms for `_mp_peer_t`
  rttMs
  /// Stores ping sent count for `_mp_peer_t`
  pingSentCount
  /// Stores pong recv count for `_mp_peer_t`
  pongRecvCount
  /// Stores game in count for `_mp_peer_t`
  gameInCount
  /// Stores game out count for `_mp_peer_t`
  gameOutCount
end struct

/// Selects an optional per-process diagnostics file used by CLI loopback tests and support logs.
/// @param path Filesystem path to process.
function MP_PlatformSetEventLogPath(path)
  global _mp_platform_event_log_path
  if typeof(path) != "string" then
    _mp_platform_event_log_path = ""
  else
    _mp_platform_event_log_path = path
  end if
end function

/// Emits one machine-readable transport event to stdout and the configured process-local log.
/// @param line Map line or text line affected by the operation.
/// @internal
function _MPPlatform_LogEvent(line)
  global _mp_platform_event_log_path
  if typeof(line) != "string" or line == "" then return end if
  print line
  if _mp_platform_event_log_path != "" and typeof(fs.appendAllText) == "function" then
    appendTry = try(fs.appendAllText(_mp_platform_event_log_path, line + "\n"))
    attempts = 1
    // A test/support reader can briefly contend with Windows append-open.
    // Retry that transient sharing failure before declaring the path dead.
    while typeof(appendTry) == "error" and attempts < 4
      time.sleep(2)
      appendTry = try(fs.appendAllText(_mp_platform_event_log_path, line + "\n"))
      attempts = attempts + 1
    end while
    if typeof(appendTry) == "error" then
      _mp_platform_event_log_path = ""
      // CLI setup owns a second reference to the same log path. Its writer is
      // a final synchronous fallback so a terminal disconnect event is not
      // lost merely because this append-open collided with a reader.
      if typeof(_MMENU_MPStatus) == "function" then
        _MMENU_MPStatus(line)
      else
        print "MPTEST LOG_DISABLED status=write_error"
      end if
    end if
  end if
end function

/// Tracks the mutable mp role value used by the mp platform subsystem.
/// @internal
_mp_role = _MPPLAT_ROLE_NONE
/// Holds the optional mp sock resource used by the mp platform subsystem.
/// @internal
_mp_sock = void

/// Tracks the mutable mp host mode cfg value used by the mp platform subsystem.
/// @internal
_mp_host_mode_cfg = MP_MODE_COOP
/// Stores the mutable mp host map cfg text used by the mp platform subsystem.
/// @internal
_mp_host_map_cfg = "MAP01"
/// Tracks the mutable mp host skill cfg value used by the mp platform subsystem.
/// @internal
_mp_host_skill_cfg = MP_SKILL_MEDIUM
/// Tracks the mutable mp host max players cfg value used by the mp platform subsystem.
/// @internal
_mp_host_max_players_cfg = 4
/// Tracks the mutable mp host frag limit cfg value used by the mp platform subsystem.
/// @internal
_mp_host_frag_limit_cfg = 0
/// Tracks the mutable mp host time limit cfg value used by the mp platform subsystem.
/// @internal
_mp_host_time_limit_cfg = 0
/// Tracks the mutable mp host next peer id value used by the mp platform subsystem.
/// @internal
_mp_host_next_peer_id = 2
/// Stores the mp host peers collection used by the mp platform subsystem.
/// @internal
_mp_host_peers = []

/// Stores the mutable mp client host text used by the mp platform subsystem.
/// @internal
_mp_client_host = ""
/// Stores the mutable mp client host name text used by the mp platform subsystem.
/// @internal
_mp_client_host_name = ""
/// Tracks the mutable mp client port value used by the mp platform subsystem.
/// @internal
_mp_client_port = 0
/// Tracks the mutable mp client peer id value used by the mp platform subsystem.
/// @internal
_mp_client_peer_id = 0
/// Tracks the mutable mp client slot value used by the mp platform subsystem.
/// @internal
_mp_client_slot = 1
/// Tracks the mutable mp client last ping ms value used by the mp platform subsystem.
/// @internal
_mp_client_last_ping_ms = 0
/// Tracks the mutable mp client ping seq value used by the mp platform subsystem.
/// @internal
_mp_client_ping_seq = 0
/// Tracks the mutable mp client last ping tx ms value used by the mp platform subsystem.
/// @internal
_mp_client_last_ping_tx_ms = 0
/// Tracks the mutable mp client last pong ms value used by the mp platform subsystem.
/// @internal
_mp_client_last_pong_ms = 0
/// Tracks the mutable mp client last seen ms value used by the mp platform subsystem.
/// @internal
_mp_client_last_seen_ms = 0
/// Tracks the mutable mp client rtt ms value used by the mp platform subsystem.
/// @internal
_mp_client_rtt_ms = -1
/// Tracks the mutable mp client ping sent value used by the mp platform subsystem.
/// @internal
_mp_client_ping_sent = 0
/// Tracks the mutable mp client pong recv value used by the mp platform subsystem.
/// @internal
_mp_client_pong_recv = 0
/// Tracks the mutable mp client game in value used by the mp platform subsystem.
/// @internal
_mp_client_game_in = 0
/// Tracks the mutable mp client game out value used by the mp platform subsystem.
/// @internal
_mp_client_game_out = 0
/// Stores the mp client slot names collection used by the mp platform subsystem.
/// @internal
_mp_client_slot_names = []
/// Tracks the mutable mp debug send attempt value used by the mp platform subsystem.
/// @internal
_mp_debug_send_attempt = 0
/// Tracks the mutable mp debug send ok value used by the mp platform subsystem.
/// @internal
_mp_debug_send_ok = 0
/// Tracks the mutable mp debug send idxfail value used by the mp platform subsystem.
/// @internal
_mp_debug_send_idxfail = 0
/// Tracks the mutable mp debug send err value used by the mp platform subsystem.
/// @internal
_mp_debug_send_err = 0
/// Stores the mp game queue nodes collection used by the mp platform subsystem.
/// @internal
_mp_game_queue_nodes = []
/// Stores the mp game queue payloads collection used by the mp platform subsystem.
/// @internal
_mp_game_queue_payloads = []
/// Tracks the mutable mp game queue head value used by the mp platform subsystem.
/// @internal
_mp_game_queue_head = 0
/// Tracks the mutable mp game queue tail value used by the mp platform subsystem.
/// @internal
_mp_game_queue_tail = 0
/// Tracks the mutable mp game queue dropped value used by the mp platform subsystem.
/// @internal
_mp_game_queue_dropped = 0

#if TARGET_OS == "windows"
/// Toggles socket mode (blocking/non-blocking) for UDP polling.
/// @param s `ptr` value supplied as s to `ioctlsocket`.
/// @param cmd `i32` value supplied as cmd to `ioctlsocket`.
/// @param argp `bytes` value supplied as argp to `ioctlsocket`.
/// @returns Result returned by the native `ioctlsocket` binding as `int`.
extern function ioctlsocket(s as ptr, cmd as i32, argp as bytes) from "ws2_32.dll" returns int
/// Configures the receive timeout on the owned WinSock UDP handle.
/// @param s `ptr` value supplied as s to `setsockopt`.
/// @param level `int` value supplied as level to `setsockopt`.
/// @param optname `int` value supplied as optname to `setsockopt`.
/// @param optval `bytes` value supplied as optval to `setsockopt`.
/// @param optlen `int` value supplied as optlen to `setsockopt`.
/// @returns Result returned by the native `setsockopt` binding as `int`.

extern function setsockopt(s as ptr, level as int, optname as int, optval as bytes, optlen as int) from "ws2_32.dll" symbol "setsockopt" returns int
#endif
/// Converts mixed numeric values to stable integer values.
/// @param v Value consumed by the operation.
/// @param fallback Value returned when the requested conversion or lookup is unavailable.
/// @internal
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

/// Keeps GUI/audio responsive while host/join control flow waits on network I/O.
/// @internal
function inline _MPPlatform_WaitPulse()
  if typeof(I_LoadingPulse) == "function" then
    I_LoadingPulse()
  else
    if typeof(I_UpdateNoBlit) == "function" then I_UpdateNoBlit() end if
    if typeof(I_UpdateSound) == "function" then I_UpdateSound() end if
    if typeof(I_SubmitSound) == "function" then I_SubmitSound() end if
  end if
end function

/// Normalizes bytes/array payload values to bytes (fast-path avoids copy for bytes).
/// @param v Value consumed by the operation.
/// @internal
function inline _MPPlatform_ToBytesCopy(v)
  if typeof(v) == "bytes" then
    return v
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

/// Returns true when peer ingame marker is truthy (bool true or non-zero int).
/// @param p Object or data record consumed by the operation.
/// @internal
function inline _MPPlatform_PeerIngame(p)
  if typeof(p) != "struct" then return false end if
  if typeof(p.ingame) == "bool" then return p.ingame end if
  if typeof(p.ingame) == "int" then return p.ingame != 0 end if
  if typeof(p.ingame) == "float" then return p.ingame != 0 end if
  return false
end function

/// Ensures host peer struct has telemetry fields initialized.
/// @param p Object or data record consumed by the operation.
/// @internal
function inline _MPPlatform_EnsurePeerTelemetry(p)
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

/// Returns queued gameplay packet count waiting for d_net consumption.
/// @internal
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

/// Stores latest status string for menu/UI display.
/// @param msg Msg value supplied to `_MPPlatform_SetStatus`.
/// @internal
function inline _MPPlatform_SetStatus(msg)
  global _mp_platform_last_status
  if typeof(msg) != "string" then
    _mp_platform_last_status = ""
  else
    _mp_platform_last_status = msg
    _MPPlatform_PushConsoleMessage(msg)
  end if
end function

/// Sends a short HUD message to the local console player when available.
/// @param msg Msg value supplied to `_MPPlatform_PushConsoleMessage`.
/// @internal
function inline _MPPlatform_PushConsoleMessage(msg)
  if typeof(msg) != "string" or msg == "" then return end if
  if typeof(players) != "array" then return end if
  cp = _MPPlatform_ToInt(consoleplayer, -1)
  if cp < 0 or cp >= len(players) then return end if
  p = players[cp]
  if typeof(p) != "struct" then return end if
  p.message = msg
  players[cp] = p
end function

/// Returns latest multiplayer runtime status string.
function MP_PlatformGetLastStatus()
  return _mp_platform_last_status
end function

/// Returns server-confirmed multiplayer mode for active session.
function MP_PlatformGetSessionMode()
  return _mp_host_mode_cfg
end function

/// Returns server-confirmed multiplayer skill for active session.
function MP_PlatformGetSessionSkill()
  return _mp_host_skill_cfg
end function

/// Returns server-confirmed map token for active session.
function MP_PlatformGetSessionMap()
  return _mp_host_map_cfg
end function

/// Returns multiplayer debug text for in-game overlay rendering.
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

/// Returns true when local runtime has an active client connection.
function inline MP_PlatformIsClientConnected()
  return _mp_role == _MPPLAT_ROLE_CLIENT
end function

/// Returns local player slot index used by Doom net layer.
function inline MP_PlatformGetLocalPlayerSlot()
  if _mp_role == _MPPLAT_ROLE_HOST then return 0 end if
  if _mp_role == _MPPLAT_ROLE_CLIENT then
    s = _MPPlatform_ToInt(_mp_client_slot, 1)
    if s < 1 or s >= _MPPLAT_MAX_PLAYERS then s = 1 end if
    return s
  end if
  return 0
end function

/// Initializes deterministic client-side slot name cache.
/// @param localName Local name value supplied to `_MPPlatform_InitClientSlotNames`.
/// @internal
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

/// Updates one checked slot name in the host peer table or client-side authoritative cache.
/// @param slot Slot value supplied to `MP_PlatformSetPlayerNameBySlot`.
/// @param name Resource or object name to resolve.
function MP_PlatformSetPlayerNameBySlot(slot, name)
  global _mp_client_slot_names
  global _mp_host_peers
  s = _MPPlatform_ToInt(slot, -1)
  if s < 0 or s >= _MPPLAT_MAX_PLAYERS then return false end if
  nm = MP_SanitizeName(name)
  if nm == "" then return false end if

  if _mp_role == _MPPLAT_ROLE_HOST then
    if s == 0 then
      MP_SetPlayerName(nm)
      return true
    end if
    idx = _MPPlatform_FindHostPeerBySlot(s)
    if idx < 0 or idx >= len(_mp_host_peers) then return false end if
    peer = _mp_host_peers[idx]
    if typeof(peer) != "struct" then return false end if
    peer.name = nm
    _mp_host_peers[idx] = peer
    return true
  end if

  if typeof(_mp_client_slot_names) != "array" or len(_mp_client_slot_names) != _MPPLAT_MAX_PLAYERS then
    _MPPlatform_InitClientSlotNames(MP_GetPlayerName())
  end if
  if s >= 0 and s < len(_mp_client_slot_names) then
    _mp_client_slot_names[s] = nm
    return true
  end if
  return false
end function

/// Resolves player display name for a given Doom slot index.
/// @param slot Slot value supplied to `MP_PlatformGetPlayerNameBySlot`.
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

/// Returns active doom net node count for local multiplayer role.
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

/// Returns known active player count for local multiplayer role.
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

/// Returns array of currently active player slots (always includes host slot 0).
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

/// Removes wire-delimiter/control bytes from textual packet fields.
/// @param s0 S0 value supplied to `_MPPlatform_SanitizeField`.
/// @internal
function inline _MPPlatform_SanitizeField(s0)
  if typeof(s0) != "string" then return "" end if
  s0 = str.replaceAll(s0, "|", "/")
  s0 = str.replaceAll(s0, "\r", " ")
  s0 = str.replaceAll(s0, "\n", " ")
  return s0
end function

/// Closes active UDP socket if currently open.
/// @internal
function inline _MPPlatform_CloseSocketOnly()
  global _mp_sock
  if typeof(_mp_sock) == "int" or typeof(_mp_sock) == "ptr" then
    net.close(_mp_sock)
  end if
  _mp_sock = void
end function

/// Configures UDP socket to non-blocking mode.
/// @param sock Sock value supplied to `_MPPlatform_SetNonBlocking`.
/// @param enabled Whether the requested feature should be enabled.
/// @internal
function inline _MPPlatform_SetNonBlocking(sock, enabled)
  arg = bytes(4, 0)
  if enabled then arg[0] = 1 end if
  rc = ioctlsocket(sock, _MPPLAT_FIONBIO, arg)
  return rc == 0
end function

/// Configures socket receive timeout in milliseconds.
/// @param sock Sock value supplied to `_MPPlatform_SetRecvTimeout`.
/// @param timeoutMs Timeout ms value supplied to `_MPPlatform_SetRecvTimeout`.
/// @internal
function inline _MPPlatform_SetRecvTimeout(sock, timeoutMs)
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

/// Checks whether a net error maps to WSAEWOULDBLOCK.
/// @param v Value consumed by the operation.
/// @internal
function inline _MPPlatform_IsWouldBlockError(v)
  if typeof(v) != "error" then return false end if
  code = net.lastError()
  return code == _MPPLAT_WOULDBLOCK or code == _MPPLAT_TIMEDOUT
end function

/// Encodes and sends a textual UDP packet with field separators.
/// @param sock Sock value supplied to `_MPPlatform_SendFields`.
/// @param ip Ip value supplied to `_MPPlatform_SendFields`.
/// @param port Port value supplied to `_MPPlatform_SendFields`.
/// @param fields Fields value supplied to `_MPPlatform_SendFields`.
/// @internal
function inline _MPPlatform_SendFields(sock, ip, port, fields)
  if typeof(fields) != "array" and typeof(fields) != "list" then return error(1, "control fields must be a sequence") end if
  textFields = array(len(fields), "")
  i = 0
  while i < len(fields)
    field = fields[i]
    if typeof(field) == "string" then
      textFields[i] = field
    else if typeof(field) == "int" or typeof(field) == "float" or typeof(field) == "bool" then
      textFields[i] = "" + field
    else
      return error(1, "control field has unsupported type")
    end if
    i = i + 1
  end while
  msg = str.join(textFields, "|")
  if typeof(msg) != "string" then return error(1, "control packet encoding failed") end if
  wire = bytes(msg)
  if typeof(wire) != "bytes" then return error(1, "control packet byte encoding failed") end if
  if len(wire) > _MPPLAT_CONTROL_MAX then return error(1, "control packet exceeds wire limit") end if
  return net.udpSendTo(sock, ip, port, wire)
end function

/// Validates dotted-decimal IPv4 input and returns the canonical form used by udpRecvFrom endpoints.
/// @param value Value consumed by the operation.
/// @internal
function _MPPlatform_NormalizeIPv4(value)
  if typeof(value) != "string" then return "" end if
  input = str.trim(value)
  parts = str.split(input, ".")
  if typeof(parts) != "array" or len(parts) != 4 then return "" end if
  output = ""
  i = 0
  while i < 4
    segment = parts[i]
    if typeof(segment) != "string" then return "" end if
    raw = bytes(segment)
    if len(raw) < 1 or len(raw) > 3 then return "" end if
    valuePart = 0
    j = 0
    while j < len(raw)
      digit = raw[j]
      if digit < 48 or digit > 57 then return "" end if
      valuePart = valuePart * 10 + (digit - 48)
      if valuePart > 255 then return "" end if
      j = j + 1
    end while
    if i > 0 then output = output + "." end if
    output = output + valuePart
    i = i + 1
  end while
  return output
end function

/// Finds existing host peer entry by ip/port tuple.
/// @param ip Ip value supplied to `_MPPlatform_FindHostPeerIndex`.
/// @param port Port value supplied to `_MPPlatform_FindHostPeerIndex`.
/// @internal
function inline _MPPlatform_FindHostPeerIndex(ip, port)
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

/// Checks whether a host peer id is already occupied.
/// @param pid Pid value supplied to `_MPPlatform_IsPeerIdUsed`.
/// @internal
function inline _MPPlatform_IsPeerIdUsed(pid)
  if pid == 1 then return true end if
  i = 0
  while i < len(_mp_host_peers)
    p = _mp_host_peers[i]
    if typeof(p) == "struct" and _MPPlatform_ToInt(p.peerid, 0) == pid then return true end if
    i = i + 1
  end while
  return false
end function

/// Checks whether a host player slot index is already used by a peer.
/// @param slot Slot value supplied to `_MPPlatform_IsSlotUsed`.
/// @internal
function inline _MPPlatform_IsSlotUsed(slot)
  if slot < 1 or slot >= _MPPLAT_MAX_PLAYERS then return true end if
  i = 0
  while i < len(_mp_host_peers)
    p = _mp_host_peers[i]
    if typeof(p) == "struct" and _MPPlatform_ToInt(p.slot, 0) == slot then return true end if
    i = i + 1
  end while
  return false
end function

/// Allocates a free player slot [1..MAXPLAYERS-1] for a joining client.
/// @internal
function inline _MPPlatform_AllocHostSlot()
  s = 1
  while s < _MPPLAT_MAX_PLAYERS
    if not _MPPlatform_IsSlotUsed(s) then return s end if
    s = s + 1
  end while
  return 0
end function

/// Returns host peer index for a given slot, or -1 if not found.
/// @param slot Slot value supplied to `_MPPlatform_FindHostPeerBySlot`.
/// @internal
function inline _MPPlatform_FindHostPeerBySlot(slot)
  i = 0
  while i < len(_mp_host_peers)
    p = _mp_host_peers[i]
    if typeof(p) == "struct" and _MPPlatform_ToInt(p.slot, 0) == slot then return i end if
    i = i + 1
  end while
  return -1
end function

/// Grows game packet queue storage in chunks so enqueue stays O(1) in steady state.
/// @param required Required value supplied to `_MPPlatform_QueueEnsureCapacity`.
/// @internal
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

/// Enqueues gameplay packet payload for d_net/i_net processing.
/// @param node Node value supplied to `_MPPlatform_QueueGamePacket`.
/// @param payload Payload value supplied to `_MPPlatform_QueueGamePacket`.
/// @internal
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

  // Drop one chunk of stale backlog at a time.  This admits fresh snapshots
  // while amortizing compaction over 256 future enqueues instead of copying
  // roughly 2K entries for every datagram once the queue is full.
  if _MPPlatform_QueueDepth() >= _MPPLAT_GAME_QUEUE_MAX then
    dropCount = _MPPLAT_GAME_QUEUE_CHUNK
    depth = _MPPlatform_QueueDepth()
    if dropCount > depth then dropCount = depth end if
    i = 0
    while i < dropCount
      off = _mp_game_queue_head + i
      if off >= 0 and off < len(_mp_game_queue_nodes) then _mp_game_queue_nodes[off] = 0 end if
      if off >= 0 and off < len(_mp_game_queue_payloads) then _mp_game_queue_payloads[off] = 0 end if
      i = i + 1
    end while
    _mp_game_queue_head = _mp_game_queue_head + dropCount
    _mp_game_queue_dropped = _MPPlatform_ToInt(_mp_game_queue_dropped, 0) + dropCount
  end if

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

/// Dequeues one gameplay packet as [node,payload], or void when empty.
/// @internal
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

/// Checks whether payload uses MiniDoom gameplay UDP frame format.
/// @param payload Payload value supplied to `_MPPlatform_IsGamePacket`.
/// @internal
function inline _MPPlatform_IsGamePacket(payload)
  if typeof(payload) != "bytes" then return false end if
  if len(payload) < 7 then return false end if
  return (payload[0] & 255) == _MPPLAT_GAME_MAGIC0 and (payload[1] & 255) == _MPPLAT_GAME_MAGIC1 and (payload[2] & 255) == _MPPLAT_GAME_MAGIC2 and (payload[3] & 255) == _MPPLAT_GAME_MAGIC3
end function

/// Computes a lightweight 16-bit checksum across gameplay payload bytes.
/// @param payload Payload value supplied to `_MPPlatform_GameChecksum16`.
/// @param n Number of values to process.
/// @internal
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

/// Decodes gameplay frame and returns payload bytes.
/// @param packet Packet value supplied to `_MPPlatform_UnwrapGamePayload`.
/// @internal
function _MPPlatform_UnwrapGamePayload(packet)
  if not _MPPlatform_IsGamePacket(packet) then return end if
  declared = (packet[5] & 255) | ((packet[6] & 255) << 8)
  if declared < 0 or declared > _MPPLAT_GAME_PAYLOAD_MAX then return end if
  // MDG1 always carries exactly one checksum after the declared payload.
  if len(packet) != 9 + declared then return end if
  expectedCsum = (packet[7 + declared] & 255) | ((packet[7 + declared + 1] & 255) << 8)
  bufCopy = bytes(declared, 0)
  i = 0
  while i < declared
    bufCopy[i] = packet[7 + i] & 255
    i = i + 1
  end while
  actualCsum = _MPPlatform_GameChecksum16(bufCopy, declared)
  if actualCsum != expectedCsum then return end if
  return bufCopy
end function

/// Encodes gameplay payload in MiniDoom gameplay UDP frame format.
/// @param localSlot Local slot value supplied to `_MPPlatform_WrapGamePayload`.
/// @param payload Payload value supplied to `_MPPlatform_WrapGamePayload`.
/// @internal
function _MPPlatform_WrapGamePayload(localSlot, payload)
  if typeof(payload) != "bytes" then return end if
  n = len(payload)
  if n < 0 or n > _MPPLAT_GAME_PAYLOAD_MAX then return end if
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

/// Allocates next available host-side peer id for a joining client.
/// @internal
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

/// Creates or refreshes a host peer entry and returns its assigned player slot (1..3).
/// @param ip Ip value supplied to `_MPPlatform_UpsertHostPeer`.
/// @param port Port value supplied to `_MPPlatform_UpsertHostPeer`.
/// @param name Resource or object name to resolve.
/// @internal
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

  peer = _mp_peer_t(ip, port, name, slot, pid, false, nowMs, 0, 0, 0, -1, 0, 0, 0, 0)
  _mp_host_peers = _mp_host_peers + [peer]
  _MPPlatform_SetStatus(name + " connected (" + ip + ":" + port + ")")
  _MPPlatform_LogEvent("MPTEST PEER_JOINED slot=" + slot + " active=" + (len(_mp_host_peers) + 1) + " name=" + _MPPlatform_SanitizeField(name))
  return slot
end function

/// Removes host peer entry and emits leave status if requested.
/// @param idx Zero-based element or table index.
/// @param withMessage With message value supplied to `_MPPlatform_RemoveHostPeerByIndex`.
/// @internal
function _MPPlatform_RemoveHostPeerByIndex(idx, withMessage)
  global _mp_host_peers
  if idx < 0 or idx >= len(_mp_host_peers) then return false end if
  keep = array(len(_mp_host_peers))
  keepCount = 0
  i = 0
  while i < len(_mp_host_peers)
    if i != idx then
      keep[keepCount] = _mp_host_peers[i]
      keepCount = keepCount + 1
    else if withMessage then
      p = _mp_host_peers[i]
      nm = "Player"
      if typeof(p) == "struct" and typeof(p.name) == "string" and p.name != "" then nm = p.name end if
      _MPPlatform_SetStatus(nm + " left")
      slotLeft = 0
      if typeof(p) == "struct" then slotLeft = _MPPlatform_ToInt(p.slot, 0) end if
      _MPPlatform_LogEvent("MPTEST PEER_LEFT slot=" + slotLeft + " active=" + len(_mp_host_peers))
    end if
    i = i + 1
  end while
  if keepCount < len(keep) then
    trimmed = array(keepCount)
    i = 0
    while i < keepCount
      trimmed[i] = keep[i]
      i = i + 1
    end while
    keep = trimmed
  end if
  _mp_host_peers = keep
  return true
end function

/// Sends a host-side join denial packet with optional server hash context.
/// @param ip Ip value supplied to `_MPPlatform_HostSendDeny`.
/// @param port Port value supplied to `_MPPlatform_HostSendDeny`.
/// @param reasonCode Reason code value supplied to `_MPPlatform_HostSendDeny`.
/// @param reasonText Reason text value supplied to `_MPPlatform_HostSendDeny`.
/// @param includeHash Include hash value supplied to `_MPPlatform_HostSendDeny`.
/// @internal
function inline _MPPlatform_HostSendDeny(ip, port, reasonCode, reasonText, includeHash)
  fields = [_MPPLAT_PROTO, _MPPLAT_DEN, reasonCode, _MPPlatform_SanitizeField(reasonText)]
  if includeHash then fields = fields + [mp_iwad_fnv1a_hex] end if
  _MPPlatform_SendFields(_mp_sock, ip, port, fields)
end function

/// Sends an accept packet with server-authoritative lobby settings.
/// @param ip Ip value supplied to `_MPPlatform_HostSendAccept`.
/// @param port Port value supplied to `_MPPlatform_HostSendAccept`.
/// @param slot Slot value supplied to `_MPPlatform_HostSendAccept`.
/// @param peerId Peer id value supplied to `_MPPlatform_HostSendAccept`.
/// @internal
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

/// Processes host-side incoming UDP packet for join/ping flow.
/// @param payload Payload value supplied to `_MPPlatform_HostHandlePacket`.
/// @param peerIp Peer ip value supplied to `_MPPlatform_HostHandlePacket`.
/// @param peerPort Peer port value supplied to `_MPPlatform_HostHandlePacket`.
/// @internal
function _MPPlatform_HostHandlePacket(payload, peerIp, peerPort)
  if typeof(payload) != "bytes" then return end if
  if len(payload) <= 0 or len(payload) > _MPPLAT_CONTROL_MAX then return end if
  text = decode(payload)
  if typeof(text) != "string" or text == "" then return end if
  parts = str.split(text, "|")
  if typeof(parts) != "array" or len(parts) < 2 then return end if
  if parts[0] != _MPPLAT_PROTO then return end if

  mtype = parts[1]
  if mtype == _MPPLAT_REQ then
    if len(parts) != 10 then
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
    if idx < 0 or idx >= len(_mp_host_peers) or len(parts) != 3 then return end if
    seq = 0
    seq = _MPPlatform_ToInt(parts[2], 0)
    p = _MPPlatform_EnsurePeerTelemetry(_mp_host_peers[idx])
    p.lastSeenMs = _MPPlatform_ToInt(time.ticks(), 0)
    _mp_host_peers[idx] = p
    _MPPlatform_SendFields(_mp_sock, peerIp, peerPort, [_MPPLAT_PROTO, _MPPLAT_PONG, seq])
    return
  end if

  if mtype == _MPPLAT_PONG then
    idx = _MPPlatform_FindHostPeerIndex(peerIp, peerPort)
    if len(parts) == 3 and idx >= 0 and idx < len(_mp_host_peers) then
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
    if len(parts) != 2 then return end if
    idx = _MPPlatform_FindHostPeerIndex(peerIp, peerPort)
    if idx >= 0 then _MPPlatform_RemoveHostPeerByIndex(idx, true) end if
    return
  end if

end function

/// Processes runtime client-side maintenance packets after join.
/// @param payload Payload value supplied to `_MPPlatform_ClientHandlePacket`.
/// @param peerIp Peer ip value supplied to `_MPPlatform_ClientHandlePacket`.
/// @param peerPort Peer port value supplied to `_MPPlatform_ClientHandlePacket`.
/// @internal
function _MPPlatform_ClientHandlePacket(payload, peerIp, peerPort)
  global _mp_client_last_ping_ms
  global _mp_client_last_pong_ms
  global _mp_client_pong_recv
  global _mp_client_rtt_ms
  global _mp_client_last_seen_ms
  if peerIp != _mp_client_host or peerPort != _mp_client_port then return end if
  if typeof(payload) != "bytes" then return end if
  if len(payload) <= 0 or len(payload) > _MPPLAT_CONTROL_MAX then return end if
  text = decode(payload)
  if typeof(text) != "string" or text == "" then return end if
  parts = str.split(text, "|")
  if typeof(parts) != "array" or len(parts) < 2 then return end if
  if parts[0] != _MPPLAT_PROTO then return end if

  mtype = parts[1]
  if mtype == _MPPLAT_DEN then
    if len(parts) != 4 and len(parts) != 5 then return end if
    _mp_client_last_seen_ms = _MPPlatform_ToInt(time.ticks(), 0)
    reason = "Disconnected by host."
    if len(parts) >= 4 and typeof(parts[3]) == "string" and parts[3] != "" then reason = parts[3] end if
    disconnectStatus = "host_closed"
    if _MPPlatform_ToInt(parts[2], 0) == 7 then disconnectStatus = "timeout" end if
    _MPPlatform_SetError(reason)
    _MPPlatform_SetStatus(reason)
    _MPPlatform_LogEvent("MPTEST CLIENT_DISCONNECTED status=" + disconnectStatus + " reason=" + _MPPlatform_SanitizeField(reason))
    MP_PlatformShutdown()
    return
  end if

  if mtype == _MPPLAT_PONG then
    if len(parts) != 3 then return end if
    nowMs = _MPPlatform_ToInt(time.ticks(), 0)
    _mp_client_last_seen_ms = nowMs
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
    if len(parts) != 3 then return end if
    _mp_client_last_seen_ms = _MPPlatform_ToInt(time.ticks(), 0)
    seq = 0
    if len(parts) >= 3 then seq = _MPPlatform_ToInt(parts[2], 0) end if
    _MPPlatform_SendFields(_mp_sock, _mp_client_host, _mp_client_port, [_MPPLAT_PROTO, _MPPLAT_PONG, seq])
    return
  end if

end function

/// Removes host peers that timed out and emits status updates.
/// @internal
function _MPPlatform_ExpireHostPeers()
  global _mp_host_peers
  nowMs = _MPPlatform_ToInt(time.ticks(), 0)
  keep = array(len(_mp_host_peers))
  keepCount = 0
  timedOutSlots = array(len(_mp_host_peers), 0)
  timedOutCount = 0
  i = 0
  while i < len(_mp_host_peers)
    p = _mp_host_peers[i]
    if typeof(p) == "struct" then
      age = nowMs - _MPPlatform_ToInt(p.lastSeenMs, nowMs)
      if age <= _MPPLAT_HOST_PEER_TIMEOUT_MS then
        keep[keepCount] = p
        keepCount = keepCount + 1
      else
        nm = p.name
        if typeof(nm) != "string" or nm == "" then nm = "Player" end if
        if typeof(p.ip) == "string" and p.ip != "" and _MPPlatform_ToInt(p.port, 0) > 0 then
          _MPPlatform_HostSendDeny(p.ip, _MPPlatform_ToInt(p.port, 0), 7, "Connection timed out.", false)
        end if
        _MPPlatform_SetStatus(nm + " left (timeout)")
        timedOutSlots[timedOutCount] = _MPPlatform_ToInt(p.slot, 0)
        timedOutCount = timedOutCount + 1
      end if
    end if
    i = i + 1
  end while
  if keepCount < len(keep) then
    trimmed = array(keepCount)
    i = 0
    while i < keepCount
      trimmed[i] = keep[i]
      i = i + 1
    end while
    keep = trimmed
  end if
  _mp_host_peers = keep
  i = 0
  while i < timedOutCount
    _MPPlatform_LogEvent("MPTEST PEER_TIMEOUT slot=" + timedOutSlots[i] + " active=" + (keepCount + 1))
    i = i + 1
  end while
end function

/// Processes non-blocking UDP packets for host/client maintenance.
function MP_PlatformPump()
  global _mp_client_last_ping_ms
  global _mp_client_ping_seq
  global _mp_client_last_ping_tx_ms
  global _mp_client_ping_sent
  global _mp_client_game_in
  global _mp_client_last_seen_ms
  if _mp_role == _MPPLAT_ROLE_NONE then return end if
  if typeof(_mp_sock) != "int" and typeof(_mp_sock) != "ptr" then return end if

  startMs = _MPPlatform_ToInt(time.ticks(), 0)
  maxLoops = _MPPLAT_PUMP_MAX_PACKETS
  loops = 0
  while loops < maxLoops
    if loops >= _MPPLAT_PUMP_MIN_PACKETS then
      elapsed = _MPPlatform_ToInt(time.ticks(), 0) - startMs
      if elapsed >= _MPPLAT_PUMP_BUDGET_MS and _MPPlatform_QueueDepth() < (_MPPLAT_GAME_QUEUE_MAX >> 2) then
        break
      end if
    end if
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
            if idx >= 0 and idx < len(_mp_host_peers) then
              p = _MPPlatform_EnsurePeerTelemetry(_mp_host_peers[idx])
              // A gameplay frame is authenticated by the accepted source tuple
              // and must also claim the slot assigned during the handshake.
              if (payload[4] & 255) == _MPPlatform_ToInt(p.slot, -1) then
                active = _MPPlatform_PeerIngame(p)
                justActivated = false
                if not active then
                  p.ingame = true
                  justActivated = true
                end if
                p.lastSeenMs = _MPPlatform_ToInt(time.ticks(), 0)
                p.gameInCount = _MPPlatform_ToInt(p.gameInCount, 0) + 1
                _mp_host_peers[idx] = p
                if justActivated then
                  nm = p.name
                  if typeof(nm) != "string" or nm == "" then nm = "Player" end if
                  _MPPlatform_SetStatus(nm + " entered game")
                  _MPPlatform_LogEvent("MPTEST PEER_ACTIVE slot=" + _MPPlatform_ToInt(p.slot, 0) + " name=" + _MPPlatform_SanitizeField(nm))
                end if
                _MPPlatform_QueueGamePacket(_MPPlatform_ToInt(p.slot, 0), gp)
              end if
            end if
          else if _mp_role == _MPPLAT_ROLE_CLIENT then
            if peerIp == _mp_client_host and peerPort == _mp_client_port and (payload[4] & 255) == 0 then
              firstHostFrame = _MPPlatform_ToInt(_mp_client_game_in, 0) == 0
              _mp_client_game_in = _MPPlatform_ToInt(_mp_client_game_in, 0) + 1
              _mp_client_last_seen_ms = _MPPlatform_ToInt(time.ticks(), 0)
              _MPPlatform_QueueGamePacket(0, gp)
              if firstHostFrame then
                _MPPlatform_LogEvent("MPTEST CLIENT_ACTIVE slot=" + _MPPlatform_ToInt(_mp_client_slot, 1))
              end if
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
    if _mp_client_last_seen_ms > 0 and nowMs - _mp_client_last_seen_ms > _MPPLAT_CLIENT_HOST_TIMEOUT_MS then
      reason = "Disconnected: host timed out."
      _MPPlatform_SetError(reason)
      _MPPlatform_SetStatus(reason)
      _MPPlatform_LogEvent("MPTEST CLIENT_DISCONNECTED status=timeout reason=" + reason)
      MP_PlatformShutdown()
      return
    end if
    if nowMs - _mp_client_last_ping_ms >= _MPPLAT_CLIENT_PING_INTERVAL_MS then
      _mp_client_ping_seq = _MPPlatform_ToInt(_mp_client_ping_seq, 0) + 1
      _mp_client_last_ping_tx_ms = nowMs
      _mp_client_ping_sent = _MPPlatform_ToInt(_mp_client_ping_sent, 0) + 1
      _mp_client_last_ping_ms = nowMs
      _MPPlatform_SendFields(_mp_sock, _mp_client_host, _mp_client_port, [_MPPLAT_PROTO, _MPPLAT_PING, _mp_client_ping_seq])
    end if
  end if
end function

/// Shuts down multiplayer UDP runtime state and closes sockets.
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
  global _mp_client_last_seen_ms
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

  if _mp_role == _MPPLAT_ROLE_HOST and (typeof(_mp_sock) == "int" or typeof(_mp_sock) == "ptr") then
    i = 0
    while i < len(_mp_host_peers)
      p = _mp_host_peers[i]
      if typeof(p) == "struct" and typeof(p.ip) == "string" and _MPPlatform_ToInt(p.port, 0) > 0 then
        _MPPlatform_HostSendDeny(p.ip, _MPPlatform_ToInt(p.port, 0), 8, "Host shut down.", false)
      end if
      i = i + 1
    end while
  else if _mp_role == _MPPLAT_ROLE_CLIENT and (typeof(_mp_sock) == "int" or typeof(_mp_sock) == "ptr") and _mp_client_host != "" and _mp_client_port > 0 then
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
  _mp_client_last_seen_ms = 0
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

/// Reports whether local runtime is currently acting as UDP host.
function inline MP_PlatformIsHosting()
  return _mp_role == _MPPLAT_ROLE_HOST
end function

/// Sends a gameplay packet payload to a Doom remote node.
/// @param node Node value supplied to `MP_PlatformNetSend`.
/// @param payload Payload value supplied to `MP_PlatformNetSend`.
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
  if typeof(frame) != "bytes" then
    _mp_debug_send_err = _MPPlatform_ToInt(_mp_debug_send_err, 0) + 1
    return false
  end if

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
    // Clients use a star topology: Doom node 0 is always the host.
    if n != 0 then return false end if
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

/// Pops one queued gameplay packet as [node,payload], or void if none.
function inline MP_PlatformNetRecv()
  if _mp_role == _MPPLAT_ROLE_NONE then return end if
  return _MPPlatform_PopGamePacket()
end function

/// Stores user-facing error text for multiplayer host/join operations.
/// @param msg Msg value supplied to `_MPPlatform_SetError`.
/// @internal
function inline _MPPlatform_SetError(msg)
  global _mp_platform_last_error
  if typeof(msg) != "string" then
    _mp_platform_last_error = ""
  else
    _mp_platform_last_error = msg
  end if
end function

/// Returns the last multiplayer platform error message.
function MP_PlatformGetLastError()
  return _mp_platform_last_error
end function

/// Starts a non-blocking UDP host endpoint for join handshakes.
/// @param port Port value supplied to `MP_PlatformHostGame`.
/// @param mode Mode value supplied to `MP_PlatformHostGame`.
/// @param skill Skill value supplied to `MP_PlatformHostGame`.
/// @param mapname Mapname value supplied to `MP_PlatformHostGame`.
/// @param maxPlayers Max players value supplied to `MP_PlatformHostGame`.
/// @param fragLimit Frag limit value supplied to `MP_PlatformHostGame`.
/// @param timeLimit Time limit value supplied to `MP_PlatformHostGame`.
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
  global _mp_client_last_seen_ms
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
  _mp_client_last_seen_ms = 0
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

/// Sends UDP join request and waits with timeout for host response.
/// @param host Host value supplied to `MP_PlatformJoinGame`.
/// @param port Port value supplied to `MP_PlatformJoinGame`.
/// @param playerName Player name value supplied to `MP_PlatformJoinGame`.
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
  global _mp_client_last_seen_ms
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

  h = _MPPlatform_NormalizeIPv4(host)
  if h == "" then
    _MPPlatform_SetError("MP join failed: host must be a numeric IPv4 address.")
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
    // std.net accepts numeric IPv4 only; ignore forged/stale replies from any
    // endpoint other than the address to which this request was sent.
    if peerIp != h or peerPort != p then continue end if
    if len(payload) <= 0 or len(payload) > _MPPLAT_CONTROL_MAX then continue end if

    text = decode(payload)
    if typeof(text) != "string" or text == "" then continue end if
    parts = str.split(text, "|")
    if typeof(parts) != "array" or len(parts) < 2 then continue end if
    if parts[0] != _MPPLAT_PROTO then continue end if

    mtype = parts[1]
    if mtype == _MPPLAT_DEN then
      if len(parts) != 4 and len(parts) != 5 then continue end if
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
      if len(parts) != 11 then
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

      if parts[part_hash] != mp_iwad_fnv1a_hex then
        net.close(s)
        _MPPlatform_SetError("MP join rejected: host WAD fingerprint does not match local IWAD.")
        return false
      end if

      acceptedPeerId = _MPPlatform_ToInt(parts[part_peer], 0)
      acceptedSlot = _MPPlatform_ToInt(parts[part_slot], 0)
      acceptedMode = _MPPlatform_ToInt(parts[part_mode], -1)
      acceptedSkill = _MPPlatform_ToInt(parts[part_skill], -1)
      acceptedFrag = _MPPlatform_ToInt(parts[part_frag], -1)
      acceptedTime = _MPPlatform_ToInt(parts[part_time], -1)
      acceptedMap = _MPPlatform_SanitizeField(parts[part_map])
      if acceptedPeerId < 2 or acceptedPeerId > 255 or acceptedSlot < 1 or acceptedSlot >= _MPPLAT_MAX_PLAYERS or (acceptedMode != MP_MODE_COOP and acceptedMode != MP_MODE_DEATHMATCH) or acceptedSkill < MP_SKILL_BABY or acceptedSkill > MP_SKILL_NIGHTMARE or acceptedFrag < 0 or acceptedTime < 0 or acceptedMap == "" then
        net.close(s)
        _MPPlatform_SetError("MP join failed: invalid values in accept packet.")
        return false
      end if

      _mp_sock = s
      _mp_role = _MPPLAT_ROLE_CLIENT
      _mp_client_host = peerIp
      _mp_client_host_name = "Host"
      hostName = MP_SanitizeName(parts[part_host_name])
      if hostName != "" then _mp_client_host_name = hostName end if
      _mp_client_port = peerPort
      _mp_client_peer_id = acceptedPeerId
      _mp_client_slot = acceptedSlot
      nowMs = _MPPlatform_ToInt(time.ticks(), 0)
      _mp_client_last_ping_ms = nowMs
      _mp_client_ping_seq = 0
      _mp_client_last_ping_tx_ms = 0
      _mp_client_last_pong_ms = 0
      _mp_client_last_seen_ms = nowMs
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
      _mp_host_mode_cfg = acceptedMode
      _mp_host_map_cfg = acceptedMap
      _mp_host_skill_cfg = acceptedSkill
      _mp_host_frag_limit_cfg = acceptedFrag
      _mp_host_time_limit_cfg = acceptedTime
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
