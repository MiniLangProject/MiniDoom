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

//! Runs legacy lockstep networking and host-authoritative input, snapshot, phase, stats, and chat replication.

import d_player
import m_menu
import i_system
import i_video
import i_net
import g_game
import doomdef
import doomstat
import mp_platform
import p_mobj
import p_maputl
import p_tick
import r_state
import info
import s_sound
import sounds
import std.math

/// Defines doomcom id for the d net subsystem.
const DOOMCOM_ID = 0x12345678
/// Defines the maximum maxnetnodes accepted by the d net subsystem.
const MAXNETNODES = 8
/// Defines backuptics for the d net subsystem.
const BACKUPTICS = 12
/// Defines resendcount for the d net subsystem.
const RESENDCOUNT = 10
/// Defines pl drone for the d net subsystem.
const PL_DRONE = 0x80

/// Defines ncmd exit for the d net subsystem.
const NCMD_EXIT = 0x80000000
/// Defines ncmd retransmit for the d net subsystem.
const NCMD_RETRANSMIT = 0x40000000
/// Defines ncmd setup for the d net subsystem.
const NCMD_SETUP = 0x20000000
/// Defines ncmd kill for the d net subsystem.
const NCMD_KILL = 0x10000000
/// Defines ncmd checksum for the d net subsystem.
const NCMD_CHECKSUM = 0x0fffffff

/// Selects whether the platform driver transmits the current packet or polls for one received packet.
enum command_t
  /// Represents cmd send in `command_t`
  CMD_SEND = 1
  /// Represents cmd get in `command_t`
  CMD_GET = 2
end enum

/// Holds one legacy lockstep packet header plus its bounded ring of tic commands.
struct doomdata_t
  /// Stores checksum for `doomdata_t`
  checksum
  /// Stores retransmitfrom for `doomdata_t`
  retransmitfrom
  /// Stores starttic for `doomdata_t`
  starttic
  /// Stores player for `doomdata_t`
  player
  /// Stores numtics for `doomdata_t`
  numtics
  /// Stores cmds for `doomdata_t`
  cmds
end struct

/// Mirrors the classic network-driver control block and negotiated session metadata.
struct doomcom_t
  /// Stores id for `doomcom_t`
  id
  /// Stores intnum for `doomcom_t`
  intnum
  /// Stores command for `doomcom_t`
  command
  /// Stores remotenode for `doomcom_t`
  remotenode
  /// Stores datalength for `doomcom_t`
  datalength

  /// Stores numnodes for `doomcom_t`
  numnodes
  /// Stores ticdup for `doomcom_t`
  ticdup
  /// Stores extratics for `doomcom_t`
  extratics
  /// Stores deathmatch for `doomcom_t`
  deathmatch
  /// Stores savegame for `doomcom_t`
  savegame
  /// Stores episode for `doomcom_t`
  episode
  /// Stores map for `doomcom_t`
  map
  /// Stores skill for `doomcom_t`
  skill

  /// Stores consoleplayer for `doomcom_t`
  consoleplayer
  /// Stores numplayers for `doomcom_t`
  numplayers
  /// Stores angleoffset for `doomcom_t`
  angleoffset
  /// Stores drone for `doomcom_t`
  drone

  /// Payload owned or referenced by this record stored by `doomcom_t`
  data
end struct

/// Holds the optional doomcom resource used by the d net subsystem.
doomcom = void
/// Holds the optional netbuffer resource used by the d net subsystem.
netbuffer = void

/// Stores the localcmds collection used by the d net subsystem.
localcmds =[]
/// Stores the netcmds collection used by the d net subsystem.
netcmds =[]
/// Stores the nettics collection used by the d net subsystem.
nettics =[]
/// Stores the nodeingame collection used by the d net subsystem.
nodeingame =[]
/// Stores the remoteresend collection used by the d net subsystem.
remoteresend =[]
/// Stores the resendto collection used by the d net subsystem.
resendto =[]
/// Stores the resendcount collection used by the d net subsystem.
resendcount =[]
/// Stores the nodeforplayer collection used by the d net subsystem.
nodeforplayer =[]

/// Tracks the mutable maketic value used by the d net subsystem.
maketic = 0
/// Tracks the mutable lastnettic value used by the d net subsystem.
lastnettic = 0
/// Tracks the mutable skiptics value used by the d net subsystem.
skiptics = 0
/// Tracks the mutable ticdup value used by the d net subsystem.
ticdup = 1
/// Tracks the mutable maxsend value used by the d net subsystem.
maxsend = 1
/// Tracks the mutable gametime value used by the d net subsystem.
gametime = 0

/// Tracks whether reboundpacket is active in the d net subsystem.
reboundpacket = false
/// Holds the optional reboundstore resource used by the d net subsystem.
reboundstore = void

/// Stores the mutable dnet exitmsg text used by the d net subsystem.
/// @internal
_dnet_exitmsg = ""
/// Tracks the mutable dnet oldentertics value used by the d net subsystem.
/// @internal
_dnet_oldentertics = -1
/// Tracks the mutable dnet oldnettics value used by the d net subsystem.
/// @internal
_dnet_oldnettics = 0
/// Tracks the mutable dnet frameon value used by the d net subsystem.
/// @internal
_dnet_frameon = 0
/// Stores the dnet frameskip collection used by the d net subsystem.
/// @internal
_dnet_frameskip =[false, false, false, false]
/// Tracks the mutable d runtics last value used by the d net subsystem.
d_runtics_last = 0

/// Defines dnet mpmsg input for the d net subsystem.
/// @internal
const _DNET_MPMSG_INPUT = 1
/// Defines dnet mpmsg snapshot for the d net subsystem.
/// @internal
const _DNET_MPMSG_SNAPSHOT = 2
/// Defines dnet mpmsg phase for the d net subsystem.
/// @internal
const _DNET_MPMSG_PHASE = 3
/// Defines dnet mpmsg feed for the d net subsystem.
/// @internal
const _DNET_MPMSG_FEED = 4
/// Defines dnet mpmsg wistats for the d net subsystem.
/// @internal
const _DNET_MPMSG_WISTATS = 5
/// Defines dnet mpmsg wistats req for the d net subsystem.
/// @internal
const _DNET_MPMSG_WISTATS_REQ = 6
/// Defines dnet mpmsg chat for the d net subsystem.
/// @internal
const _DNET_MPMSG_CHAT = 7
/// Defines dnet mpmsg name for the d net subsystem.
/// @internal
const _DNET_MPMSG_NAME = 8
/// Defines dnet mpmsg sound for the d net subsystem.
/// @internal
const _DNET_MPMSG_SOUND = 201
/// Defines dnet mp chat broadcast for the d net subsystem.
/// @internal
const _DNET_MP_CHAT_BROADCAST = 5
/// Defines dnet mp chat cooldown tics for the d net subsystem.
/// @internal
const _DNET_MP_CHAT_COOLDOWN_TICS = 4
/// Defines dnet mp snapshot interval for the d net subsystem.
/// @internal
const _DNET_MP_SNAPSHOT_INTERVAL = 1
/// Defines dnet mp full snapshot period for the d net subsystem.
/// @internal
const _DNET_MP_FULL_SNAPSHOT_PERIOD = 35
/// Defines dnet mp input keepalive tics for the d net subsystem.
/// @internal
const _DNET_MP_INPUT_KEEPALIVE_TICS = 1
/// Defines dnet mp input active redundant copies for the d net subsystem.
/// @internal
const _DNET_MP_INPUT_ACTIVE_REDUNDANT_COPIES = 2
/// Defines dnet mp remote cmd stale tics for the d net subsystem.
/// @internal
const _DNET_MP_REMOTE_CMD_STALE_TICS = 6
/// Defines dnet mp phase interval for the d net subsystem.
/// @internal
const _DNET_MP_PHASE_INTERVAL = 4
/// Defines dnet mp wistats retry tics for the d net subsystem.
/// @internal
const _DNET_MP_WISTATS_RETRY_TICS = 12
/// Defines the maximum dnet mp wistats max retries accepted by the d net subsystem.
/// @internal
const _DNET_MP_WISTATS_MAX_RETRIES = 3
/// Defines dnet mp wistats req cooldown tics for the d net subsystem.
/// @internal
const _DNET_MP_WISTATS_REQ_COOLDOWN_TICS = 4
/// Defines dnet mp wistats base row bytes for the d net subsystem.
/// @internal
const _DNET_MP_WISTATS_BASE_ROW_BYTES = 24
/// Defines dnet mp name bytes for the d net subsystem.
/// @internal
const _DNET_MP_NAME_BYTES = 26
/// Defines dnet mp wistats row bytes for the d net subsystem.
/// @internal
const _DNET_MP_WISTATS_ROW_BYTES = _DNET_MP_WISTATS_BASE_ROW_BYTES + _DNET_MP_NAME_BYTES
/// Defines dnet mp wistats broadcast interval for the d net subsystem.
/// @internal
const _DNET_MP_WISTATS_BROADCAST_INTERVAL = 18
/// Defines the maximum dnet mp max actors per snapshot accepted by the d net subsystem.
/// @internal
const _DNET_MP_MAX_ACTORS_PER_SNAPSHOT = 20
/// Defines dnet mp actor pool per snapshot for the d net subsystem.
/// @internal
const _DNET_MP_ACTOR_POOL_PER_SNAPSHOT = 80
/// Defines the maximum dnet mp max removed per snapshot accepted by the d net subsystem.
/// @internal
const _DNET_MP_MAX_REMOVED_PER_SNAPSHOT = 96
/// Defines the maximum dnet mp max sectors per snapshot accepted by the d net subsystem.
/// @internal
const _DNET_MP_MAX_SECTORS_PER_SNAPSHOT = 8
/// Defines the maximum dnet mp max sides per snapshot accepted by the d net subsystem.
/// @internal
const _DNET_MP_MAX_SIDES_PER_SNAPSHOT = 8
/// Defines dnet mp player row bytes for the d net subsystem.
/// @internal
const _DNET_MP_PLAYER_ROW_BYTES = 88
/// Defines dnet mp client stale grace sweeps for the d net subsystem.
/// @internal
const _DNET_MP_CLIENT_STALE_GRACE_SWEEPS = 2
/// Defines dnet mp remove resend count for the d net subsystem.
/// @internal
const _DNET_MP_REMOVE_RESEND_COUNT = 3
/// Defines dnet mp actor candidate multiplier for the d net subsystem.
/// @internal
const _DNET_MP_ACTOR_CANDIDATE_MULTIPLIER = 6
/// Defines dnet mp static heartbeat fulls for the d net subsystem.
/// @internal
const _DNET_MP_STATIC_HEARTBEAT_FULLS = 8
/// Defines the maximum dnet mp removed queue max accepted by the d net subsystem.
/// @internal
const _DNET_MP_REMOVED_QUEUE_MAX = 4096
/// Defines dnet mp relevance distance for the d net subsystem.
/// @internal
const _DNET_MP_RELEVANCE_DISTANCE = 1536 * FRACUNIT
/// Defines dnet mp relevance missile bonus for the d net subsystem.
/// @internal
const _DNET_MP_RELEVANCE_MISSILE_BONUS = 768 * FRACUNIT
/// Defines dnet mp relevance special bonus for the d net subsystem.
/// @internal
const _DNET_MP_RELEVANCE_SPECIAL_BONUS = 384 * FRACUNIT
/// Defines dnet mp relevance view bonus for the d net subsystem.
/// @internal
const _DNET_MP_RELEVANCE_VIEW_BONUS = 2048 * FRACUNIT
/// Defines dnet mp relevance view halfangle for the d net subsystem.
/// @internal
const _DNET_MP_RELEVANCE_VIEW_HALFANGLE = 0x20000000
// Keep below transport frame size (_MPPLAT_RECV_MAX=1400, minus 9-byte MP frame header with checksum).
/// Defines dnet mp payload budget for the d net subsystem.
/// @internal
const _DNET_MP_PAYLOAD_BUDGET = 1391
/// Defines dnet mp join fullsync burst tics for the d net subsystem.
/// @internal
const _DNET_MP_JOIN_FULLSYNC_BURST_TICS = 70
/// Defines the dnet mp client interp num count used by the d net subsystem.
/// @internal
const _DNET_MP_CLIENT_INTERP_NUM = 1
/// Defines dnet mp client interp den for the d net subsystem.
/// @internal
const _DNET_MP_CLIENT_INTERP_DEN = 3
/// Defines dnet mp client hard snap dist for the d net subsystem.
/// @internal
const _DNET_MP_CLIENT_HARD_SNAP_DIST = 128 * FRACUNIT
/// Defines the maximum dnet mp client max extrap missile accepted by the d net subsystem.
/// @internal
const _DNET_MP_CLIENT_MAX_EXTRAP_MISSILE = 4
/// Defines the maximum dnet mp client max extrap mobile accepted by the d net subsystem.
/// @internal
const _DNET_MP_CLIENT_MAX_EXTRAP_MOBILE = 2
/// Defines the maximum dnet mp client extrap abs vel max mobile accepted by the d net subsystem.
/// @internal
const _DNET_MP_CLIENT_EXTRAP_ABS_VEL_MAX_MOBILE = 12 * FRACUNIT
/// Defines the maximum dnet mp client extrap abs vel max missile accepted by the d net subsystem.
/// @internal
const _DNET_MP_CLIENT_EXTRAP_ABS_VEL_MAX_MISSILE = 24 * FRACUNIT

/// Tracks the mutable dnet mp last snapshot tic value used by the d net subsystem.
/// @internal
_dnet_mp_last_snapshot_tic = 0
/// Tracks the mutable dnet mp last input seq value used by the d net subsystem.
/// @internal
_dnet_mp_last_input_seq = 0
/// Tracks the mutable dnet mp last input send tic value used by the d net subsystem.
/// @internal
_dnet_mp_last_input_send_tic = 0
/// Holds the optional dnet mp last input cmd resource used by the d net subsystem.
/// @internal
_dnet_mp_last_input_cmd = void
/// Stores the dnet mp remote cmds collection used by the d net subsystem.
/// @internal
_dnet_mp_remote_cmds = []
/// Stores the dnet mp remote cmd valid collection used by the d net subsystem.
/// @internal
_dnet_mp_remote_cmd_valid = []
/// Stores the dnet mp remote cmd tic collection used by the d net subsystem.
/// @internal
_dnet_mp_remote_cmd_tic = []
/// Stores the dnet mp remote input last seq collection used by the d net subsystem.
/// @internal
_dnet_mp_remote_input_last_seq = []
/// Stores the dnet mp host input active logged collection used by the d net subsystem.
/// @internal
_dnet_mp_host_input_active_logged = []
/// Tracks the mutable dnet mp last phase tic value used by the d net subsystem.
/// @internal
_dnet_mp_last_phase_tic = 0
/// Holds the optional dnet mp host last phase key resource used by the d net subsystem.
/// @internal
_dnet_mp_host_last_phase_key = void
/// Tracks the mutable dnet mp host last wistats tic value used by the d net subsystem.
/// @internal
_dnet_mp_host_last_wistats_tic = 0
/// Stores the dnet mp host last wistats req tic collection used by the d net subsystem.
/// @internal
_dnet_mp_host_last_wistats_req_tic = []
/// Tracks the mutable dnet mp client last phase tick value used by the d net subsystem.
/// @internal
_dnet_mp_client_last_phase_tick = 0
/// Stores the dnet mp host last frags collection used by the d net subsystem.
/// @internal
_dnet_mp_host_last_frags = []
/// Stores the dnet mp host last chat tic collection used by the d net subsystem.
/// @internal
_dnet_mp_host_last_chat_tic = []
/// Stores the dnet mp host actor ids collection used by the d net subsystem.
/// @internal
_dnet_mp_host_actor_ids = []
/// Stores the dnet mp host actor nodes collection used by the d net subsystem.
/// @internal
_dnet_mp_host_actor_nodes = []
/// Stores the dnet mp host actor refs collection used by the d net subsystem.
/// @internal
_dnet_mp_host_actor_refs = []
/// Stores the dnet mp host last actor sig collection used by the d net subsystem.
/// @internal
_dnet_mp_host_last_actor_sig = []
/// Stores the dnet mp host actor miss collection used by the d net subsystem.
/// @internal
_dnet_mp_host_actor_miss = []
/// Tracks the mutable dnet mp host actor seen value used by the d net subsystem.
/// @internal
_dnet_mp_host_actor_seen = bytes(0, 0)
/// Tracks the mutable dnet mp host actor active count value used by the d net subsystem.
/// @internal
_dnet_mp_host_actor_active_count = 0
/// Stores the dnet mp host removed ids collection used by the d net subsystem.
/// @internal
_dnet_mp_host_removed_ids = []
/// Tracks the mutable dnet mp host next actor id value used by the d net subsystem.
/// @internal
_dnet_mp_host_next_actor_id = 1
/// Tracks the mutable dnet mp host actor cursor value used by the d net subsystem.
/// @internal
_dnet_mp_host_actor_cursor = 0
/// Tracks the mutable dnet mp host sector cursor value used by the d net subsystem.
/// @internal
_dnet_mp_host_sector_cursor = 0
/// Stores the dnet mp host last player sig collection used by the d net subsystem.
/// @internal
_dnet_mp_host_last_player_sig = []
/// Stores the dnet mp host last sector floor collection used by the d net subsystem.
/// @internal
_dnet_mp_host_last_sector_floor = []
/// Stores the dnet mp host last sector ceiling collection used by the d net subsystem.
/// @internal
_dnet_mp_host_last_sector_ceiling = []
/// Stores the dnet mp host last sector light collection used by the d net subsystem.
/// @internal
_dnet_mp_host_last_sector_light = []
/// Stores the dnet mp host last sector special collection used by the d net subsystem.
/// @internal
_dnet_mp_host_last_sector_special = []
/// Tracks the mutable dnet mp host side cursor value used by the d net subsystem.
/// @internal
_dnet_mp_host_side_cursor = 0
/// Stores the dnet mp host last side top collection used by the d net subsystem.
/// @internal
_dnet_mp_host_last_side_top = []
/// Stores the dnet mp host last side bottom collection used by the d net subsystem.
/// @internal
_dnet_mp_host_last_side_bottom = []
/// Stores the dnet mp host last side mid collection used by the d net subsystem.
/// @internal
_dnet_mp_host_last_side_mid = []
/// Stores the dnet mp host slot fullsync burst collection used by the d net subsystem.
/// @internal
_dnet_mp_host_slot_fullsync_burst = []
/// Holds the optional dnet mp host cached wistats resource used by the d net subsystem.
/// @internal
_dnet_mp_host_cached_wistats = void
/// Stores the dnet mp client actor ids collection used by the d net subsystem.
/// @internal
_dnet_mp_client_actor_ids = []
/// Stores the dnet mp client actor refs collection used by the d net subsystem.
/// @internal
_dnet_mp_client_actor_refs = []
/// Stores the dnet mp client actor miss collection used by the d net subsystem.
/// @internal
_dnet_mp_client_actor_miss = []
/// Stores the dnet mp client actor tx collection used by the d net subsystem.
/// @internal
_dnet_mp_client_actor_tx = []
/// Stores the dnet mp client actor ty collection used by the d net subsystem.
/// @internal
_dnet_mp_client_actor_ty = []
/// Stores the dnet mp client actor tz collection used by the d net subsystem.
/// @internal
_dnet_mp_client_actor_tz = []
/// Stores the dnet mp client actor tang collection used by the d net subsystem.
/// @internal
_dnet_mp_client_actor_tang = []
/// Stores the dnet mp client actor vx collection used by the d net subsystem.
/// @internal
_dnet_mp_client_actor_vx = []
/// Stores the dnet mp client actor vy collection used by the d net subsystem.
/// @internal
_dnet_mp_client_actor_vy = []
/// Stores the dnet mp client actor vz collection used by the d net subsystem.
/// @internal
_dnet_mp_client_actor_vz = []
/// Stores the dnet mp client actor last snap tic collection used by the d net subsystem.
/// @internal
_dnet_mp_client_actor_last_snap_tic = []
/// Stores the dnet mp client actor kind collection used by the d net subsystem.
/// @internal
_dnet_mp_client_actor_kind = []
/// Stores the dnet mp client player tx collection used by the d net subsystem.
/// @internal
_dnet_mp_client_player_tx = []
/// Stores the dnet mp client player ty collection used by the d net subsystem.
/// @internal
_dnet_mp_client_player_ty = []
/// Stores the dnet mp client player tz collection used by the d net subsystem.
/// @internal
_dnet_mp_client_player_tz = []
/// Stores the dnet mp client player tang collection used by the d net subsystem.
/// @internal
_dnet_mp_client_player_tang = []
/// Stores the dnet mp client player vx collection used by the d net subsystem.
/// @internal
_dnet_mp_client_player_vx = []
/// Stores the dnet mp client player vy collection used by the d net subsystem.
/// @internal
_dnet_mp_client_player_vy = []
/// Stores the dnet mp client player vz collection used by the d net subsystem.
/// @internal
_dnet_mp_client_player_vz = []
/// Stores the dnet mp client player last snap tic collection used by the d net subsystem.
/// @internal
_dnet_mp_client_player_last_snap_tic = []
/// Tracks the mutable dnet mp client last smooth tic value used by the d net subsystem.
/// @internal
_dnet_mp_client_last_smooth_tic = -1
/// Tracks the mutable dnet mp client last snapshot tick value used by the d net subsystem.
/// @internal
_dnet_mp_client_last_snapshot_tick = 0
/// Holds the optional dnet mp client pending snapshot resource used by the d net subsystem.
/// @internal
_dnet_mp_client_pending_snapshot = void
/// Tracks whether dnet mp client world bootstrapped is active in the d net subsystem.
/// @internal
_dnet_mp_client_world_bootstrapped = false
/// Tracks the mutable dnet mp client ui tic value used by the d net subsystem.
/// @internal
_dnet_mp_client_ui_tic = -1
/// Tracks whether dnet mp client wait wistats is active in the d net subsystem.
/// @internal
_dnet_mp_client_wait_wistats = false
/// Tracks whether dnet mp client have wistats is active in the d net subsystem.
/// @internal
_dnet_mp_client_have_wistats = false
/// Tracks the mutable dnet mp client wistats last tick value used by the d net subsystem.
/// @internal
_dnet_mp_client_wistats_last_tick = 0
/// Tracks the mutable dnet mp client wistats next req tic value used by the d net subsystem.
/// @internal
_dnet_mp_client_wistats_next_req_tic = 0
/// Tracks the mutable dnet mp client wistats req count value used by the d net subsystem.
/// @internal
_dnet_mp_client_wistats_req_count = 0
/// Stores the mutable dnet mp client wistats error text used by the d net subsystem.
/// @internal
_dnet_mp_client_wistats_error = ""
/// Holds the optional dnet mp client cached wistats resource used by the d net subsystem.
/// @internal
_dnet_mp_client_cached_wistats = void
/// Tracks whether dnet mp client local pickups armed is active in the d net subsystem.
/// @internal
_dnet_mp_client_local_pickups_armed = false
/// Tracks the mutable dnet mp client seen players value used by the d net subsystem.
/// @internal
_dnet_mp_client_seen_players = bytes(MAXPLAYERS, 0)
/// Tracks the mutable dnet mp client claimed actors value used by the d net subsystem.
/// @internal
_dnet_mp_client_claimed_actors = bytes(0, 0)
/// Tracks whether dnet mp was authoritative is active in the d net subsystem.
/// @internal
_dnet_mp_was_authoritative = false
/// Tracks whether dnet mp was client is active in the d net subsystem.
/// @internal
_dnet_mp_was_client = false
/// Tracks whether dnet mp local name announced is active in the d net subsystem.
/// @internal
_dnet_mp_local_name_announced = false
/// Tracks the mutable dnet mp dbg snap calls value used by the d net subsystem.
/// @internal
_dnet_mp_dbg_snap_calls = 0
/// Tracks the mutable dnet mp dbg snap skip not host value used by the d net subsystem.
/// @internal
_dnet_mp_dbg_snap_skip_not_host = 0
/// Tracks the mutable dnet mp dbg snap skip not level value used by the d net subsystem.
/// @internal
_dnet_mp_dbg_snap_skip_not_level = 0
/// Tracks the mutable dnet mp dbg snap skip nosend value used by the d net subsystem.
/// @internal
_dnet_mp_dbg_snap_skip_nosend = 0
/// Tracks the mutable dnet mp dbg snap skip rate value used by the d net subsystem.
/// @internal
_dnet_mp_dbg_snap_skip_rate = 0
/// Tracks the mutable dnet mp dbg snap built value used by the d net subsystem.
/// @internal
_dnet_mp_dbg_snap_built = 0
/// Tracks the mutable dnet mp dbg snap targets value used by the d net subsystem.
/// @internal
_dnet_mp_dbg_snap_targets = 0
/// Tracks the mutable dnet mp dbg snap sent value used by the d net subsystem.
/// @internal
_dnet_mp_dbg_snap_sent = 0
/// Tracks the mutable dnet mp dbg unknown payload drop value used by the d net subsystem.
/// @internal
_dnet_mp_dbg_unknown_payload_drop = 0
/// Tracks the mutable dnet mp snap cache tick value used by the d net subsystem.
/// @internal
_dnet_mp_snap_cache_tick = -1
/// Tracks whether dnet mp snap cache force all is active in the d net subsystem.
/// @internal
_dnet_mp_snap_cache_force_all = false
/// Stores the dnet mp snap cache player rows collection used by the d net subsystem.
/// @internal
_dnet_mp_snap_cache_player_rows = []
/// Stores the dnet mp snap cache actor ids collection used by the d net subsystem.
/// @internal
_dnet_mp_snap_cache_actor_ids = []
/// Stores the dnet mp snap cache actor refs collection used by the d net subsystem.
/// @internal
_dnet_mp_snap_cache_actor_refs = []
/// Stores the dnet mp snap cache removed ids collection used by the d net subsystem.
/// @internal
_dnet_mp_snap_cache_removed_ids = []
/// Stores the dnet mp snap cache sector rows collection used by the d net subsystem.
/// @internal
_dnet_mp_snap_cache_sector_rows = []
/// Stores the dnet mp snap cache side rows collection used by the d net subsystem.
/// @internal
_dnet_mp_snap_cache_side_rows = []

/// Allocates a full BACKUPTICS command ring initialized to neutral input.
/// @internal
function inline _DNet_DefaultCmds()
  a = array(BACKUPTICS)
  i = 0
  while i < BACKUPTICS
    a[i] = ticcmd_t(0, 0, 0, 0, 0, 0)
    i = i + 1
  end while
  return a
end function

/// Accepts arrays and lists wherever network codecs require indexed sequence access.
/// @param v Value consumed by the operation.
/// @internal
function inline _DNet_IsSeq(v)
  t = typeof(v)
  return t == "array" or t == "list"
end function

/// Converts source to int values for the network game.
/// @param v Value consumed by the operation.
/// @param fallback Value returned when the requested conversion or lookup is unavailable.
/// @internal
function inline _DNet_ToInt(v, fallback)
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

/// Normalizes enum/int values to a bounded integer enum index.
/// @param v Value consumed by the operation.
/// @param limit Limit value supplied to `_DNet_EnumIndex`.
/// @internal
function inline _DNet_EnumIndex(v, limit)
  vi = _DNet_ToInt(v, -1)
  if vi >= 0 then
    if typeof(limit) == "int" and limit > 0 and vi >= limit then return -1 end if
    return vi
  end if
  if typeof(v) != "enum" then return -1 end if
  if typeof(limit) != "int" or limit <= 0 then return -1 end if

  i = 0
  while i < limit
    if v == i then return i end if
    i = i + 1
  end while
  return -1
end function

/// Returns a quotient truncated toward zero for tic math, with invalid operands mapped to zero.
/// @param a First input operand.
/// @param b Second input operand.
/// @internal
function inline _DNet_IDiv(a, b)
  ai = _DNet_ToInt(a, 0)
  bi = _DNet_ToInt(b, 0)
  if bi == 0 then return 0 end if

  q = ai / bi
  if q >= 0 then return std.math.floor(q) end if
  return std.math.ceil(q)
end function

/// Resolves a runtime state value to its authoritative state index for snapshot serialization.
/// @param s S value supplied to `_DNet_StateIndex`.
/// @internal
function _DNet_StateIndex(s)
  idx = _DNet_ToInt(Info_StateIndex(s), -1)
  if idx >= 0 then return idx end if
  if typeof(s) != "struct" then return idx end if
  if typeof(states) != "array" then return idx end if

  i = 0
  while i < len(states)
    cand = states[i]
    if typeof(cand) == "struct" and cand == s then return i end if
    i = i + 1
  end while

  sspr = _DNet_ToInt(s.sprite, -2147483648)
  sfrm = _DNet_ToInt(s.frame, -2147483648)
  stic = _DNet_ToInt(s.tics, -2147483648)
  snxt = _DNet_ToInt(s.nextstate, -2147483648)
  sm1 = _DNet_ToInt(s.misc1, -2147483648)
  sm2 = _DNet_ToInt(s.misc2, -2147483648)

  i = 0
  while i < len(states)
    cand = states[i]
    if typeof(cand) == "struct" then
      if _DNet_ToInt(cand.sprite, -2147483648) == sspr and _DNet_ToInt(cand.frame, -2147483648) == sfrm and _DNet_ToInt(cand.tics, -2147483648) == stic and _DNet_ToInt(cand.nextstate, -2147483648) == snxt and _DNet_ToInt(cand.misc1, -2147483648) == sm1 and _DNet_ToInt(cand.misc2, -2147483648) == sm2 then
        return i
      end if
    end if
    i = i + 1
  end while

  return idx
end function

/// Restores all legacy lockstep rings to protocol sizes before packet/tic access.
/// @internal
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
    netcmds = array(MAXPLAYERS)
    i = 0
    while i < MAXPLAYERS
      netcmds[i] = _DNet_DefaultCmds()
      i = i + 1
    end while
  end if

  if not _DNet_IsSeq(nettics) or len(nettics) != MAXNETNODES then
    nettics = array(MAXNETNODES, 0)
    nodeingame = array(MAXNETNODES, false)
    remoteresend = array(MAXNETNODES, false)
    resendto = array(MAXNETNODES, 0)
    resendcount = array(MAXNETNODES, 0)
  end if

  if not _DNet_IsSeq(nodeforplayer) or len(nodeforplayer) != MAXPLAYERS then
    nodeforplayer = array(MAXPLAYERS, 0)
  end if
end function

/// Copies a tic command by value so ring-buffer reuse cannot mutate queued input.
/// @param src Src value supplied to `_DNet_CopyCmd`.
/// @internal
function inline _DNet_CopyCmd(src)
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

/// Returns true when multiplayer platform is currently hosting.
/// @internal
function inline _DNet_MPIsHost()
  if typeof(MP_PlatformIsHosting) != "function" then return false end if
  return MP_PlatformIsHosting()
end function

/// Returns true when multiplayer platform is currently connected as client.
/// @internal
function inline _DNet_MPIsClient()
  if typeof(MP_PlatformIsClientConnected) != "function" then return false end if
  return MP_PlatformIsClientConnected()
end function

/// Returns true while host-authoritative multiplayer runtime is active.
/// @internal
function inline _DNet_MPIsAuthoritative()
  return _DNet_MPIsHost() or _DNet_MPIsClient()
end function

/// Writes a 16-bit unsigned integer into byte buffer.
/// @param buf Buf value supplied to `_DNet_MPWriteU16`.
/// @param off Zero-based byte or element offset.
/// @param v Value consumed by the operation.
/// @internal
function inline _DNet_MPWriteU16(buf, off, v)
  if typeof(buf) != "bytes" then return end if
  if off < 0 or off + 1 >= len(buf) then return end if
  x = _DNet_ToInt(v, 0)
  if x < 0 then x = 0 end if
  x = x & 65535
  buf[off] = x & 255
  buf[off + 1] = (x >> 8) & 255
end function

/// Writes a 16-bit signed integer into byte buffer.
/// @param buf Buf value supplied to `_DNet_MPWriteI16`.
/// @param off Zero-based byte or element offset.
/// @param v Value consumed by the operation.
/// @internal
function inline _DNet_MPWriteI16(buf, off, v)
  if typeof(buf) != "bytes" then return end if
  if off < 0 or off + 1 >= len(buf) then return end if
  x = _DNet_ToInt(v, 0)
  if x < -32768 then x = -32768 end if
  if x > 32767 then x = 32767 end if
  if x < 0 then x = x + 65536 end if
  buf[off] = x & 255
  buf[off + 1] = (x >> 8) & 255
end function

/// Writes a 32-bit unsigned integer into byte buffer.
/// @param buf Buf value supplied to `_DNet_MPWriteU32`.
/// @param off Zero-based byte or element offset.
/// @param v Value consumed by the operation.
/// @internal
function inline _DNet_MPWriteU32(buf, off, v)
  if typeof(buf) != "bytes" then return end if
  if off < 0 or off + 3 >= len(buf) then return end if
  x = _DNet_ToInt(v, 0)
  if x < 0 then x = x + 4294967296 end if
  buf[off] = x & 255
  buf[off + 1] = (x >> 8) & 255
  buf[off + 2] = (x >> 16) & 255
  buf[off + 3] = (x >> 24) & 255
end function

/// Writes a 32-bit signed integer into byte buffer.
/// @param buf Buf value supplied to `_DNet_MPWriteI32`.
/// @param off Zero-based byte or element offset.
/// @param v Value consumed by the operation.
/// @internal
function inline _DNet_MPWriteI32(buf, off, v)
  _DNet_MPWriteU32(buf, off, _DNet_ToInt(v, 0))
end function

/// Reads a 16-bit unsigned integer from byte buffer.
/// @param buf Buf value supplied to `_DNet_MPReadU16`.
/// @param off Zero-based byte or element offset.
/// @internal
function inline _DNet_MPReadU16(buf, off)
  b0 = buf[off] & 255
  b1 = buf[off + 1] & 255
  return b0 | (b1 << 8)
end function

/// Reads a 16-bit signed integer from byte buffer.
/// @param buf Buf value supplied to `_DNet_MPReadI16`.
/// @param off Zero-based byte or element offset.
/// @internal
function inline _DNet_MPReadI16(buf, off)
  x = _DNet_MPReadU16(buf, off)
  if x >= 32768 then x = x - 65536 end if
  return x
end function

/// Reads a 32-bit unsigned integer from byte buffer.
/// @param buf Buf value supplied to `_DNet_MPReadU32`.
/// @param off Zero-based byte or element offset.
/// @internal
function inline _DNet_MPReadU32(buf, off)
  b0 = buf[off] & 255
  b1 = buf[off + 1] & 255
  b2 = buf[off + 2] & 255
  b3 = buf[off + 3] & 255
  x = b0 | (b1 << 8) | (b2 << 16) | (b3 << 24)
  if x < 0 then x = x + 4294967296 end if
  return x
end function

/// Reads a 32-bit signed integer from byte buffer.
/// @param buf Buf value supplied to `_DNet_MPReadI32`.
/// @param off Zero-based byte or element offset.
/// @internal
function inline _DNet_MPReadI32(buf, off)
  b0 = buf[off] & 255
  b1 = buf[off + 1] & 255
  b2 = buf[off + 2] & 255
  b3 = buf[off + 3] & 255
  x = b0 | (b1 << 8) | (b2 << 16) | (b3 << 24)
  if x >= 2147483648 then x = x - 4294967296 end if
  return x
end function

/// Returns true when input sequence a is newer than b (uint32 wrap-around aware).
/// @param a First input operand.
/// @param b Second input operand.
/// @internal
function inline _DNet_MPSeqIsNewer(a, b)
  aa = _DNet_ToInt(a, 0)
  bb = _DNet_ToInt(b, -1)
  if bb < 0 then return true end if
  if aa == bb then return false end if
  diff = aa - bb
  if diff < 0 then diff = diff + 4294967296 end if
  diff = diff & 4294967295
  return diff > 0 and diff < 2147483648
end function

/// Clears host/client authoritative replication caches.
/// @internal
function _DNet_MPResetRuntime()
  global _dnet_mp_last_snapshot_tic
  global _dnet_mp_last_input_seq
  global _dnet_mp_last_input_send_tic
  global _dnet_mp_last_input_cmd
  global _dnet_mp_remote_cmds
  global _dnet_mp_remote_cmd_valid
  global _dnet_mp_remote_cmd_tic
  global _dnet_mp_remote_input_last_seq
  global _dnet_mp_host_input_active_logged
  global _dnet_mp_last_phase_tic
  global _dnet_mp_host_last_phase_key
  global _dnet_mp_host_last_wistats_tic
  global _dnet_mp_host_last_wistats_req_tic
  global _dnet_mp_client_last_phase_tick
  global _dnet_mp_host_last_frags
  global _dnet_mp_host_last_chat_tic
  global _dnet_mp_host_actor_ids
  global _dnet_mp_host_actor_nodes
  global _dnet_mp_host_actor_refs
  global _dnet_mp_host_last_actor_sig
  global _dnet_mp_host_actor_miss
  global _dnet_mp_host_actor_seen
  global _dnet_mp_host_actor_active_count
  global _dnet_mp_host_removed_ids
  global _dnet_mp_host_next_actor_id
  global _dnet_mp_host_actor_cursor
  global _dnet_mp_host_sector_cursor
  global _dnet_mp_host_last_player_sig
  global _dnet_mp_host_last_sector_floor
  global _dnet_mp_host_last_sector_ceiling
  global _dnet_mp_host_last_sector_light
  global _dnet_mp_host_last_sector_special
  global _dnet_mp_host_side_cursor
  global _dnet_mp_host_last_side_top
  global _dnet_mp_host_last_side_bottom
  global _dnet_mp_host_last_side_mid
  global _dnet_mp_host_slot_fullsync_burst
  global _dnet_mp_host_cached_wistats
  global _dnet_mp_client_actor_ids
  global _dnet_mp_client_actor_refs
  global _dnet_mp_client_actor_miss
  global _dnet_mp_client_actor_tx
  global _dnet_mp_client_actor_ty
  global _dnet_mp_client_actor_tz
  global _dnet_mp_client_actor_tang
  global _dnet_mp_client_actor_vx
  global _dnet_mp_client_actor_vy
  global _dnet_mp_client_actor_vz
  global _dnet_mp_client_actor_last_snap_tic
  global _dnet_mp_client_actor_kind
  global _dnet_mp_client_player_tx
  global _dnet_mp_client_player_ty
  global _dnet_mp_client_player_tz
  global _dnet_mp_client_player_tang
  global _dnet_mp_client_player_vx
  global _dnet_mp_client_player_vy
  global _dnet_mp_client_player_vz
  global _dnet_mp_client_player_last_snap_tic
  global _dnet_mp_client_last_smooth_tic
  global _dnet_mp_client_last_snapshot_tick
  global _dnet_mp_client_pending_snapshot
  global _dnet_mp_client_world_bootstrapped
  global _dnet_mp_client_ui_tic
  global _dnet_mp_client_wait_wistats
  global _dnet_mp_client_have_wistats
  global _dnet_mp_client_wistats_last_tick
  global _dnet_mp_client_wistats_next_req_tic
  global _dnet_mp_client_wistats_req_count
  global _dnet_mp_client_wistats_error
  global _dnet_mp_client_cached_wistats
  global _dnet_mp_client_local_pickups_armed
  global _dnet_mp_client_seen_players
  global _dnet_mp_client_claimed_actors
  global _dnet_mp_was_authoritative
  global _dnet_mp_was_client
  global _dnet_mp_local_name_announced
  global _dnet_mp_dbg_snap_calls
  global _dnet_mp_dbg_snap_skip_not_host
  global _dnet_mp_dbg_snap_skip_not_level
  global _dnet_mp_dbg_snap_skip_nosend
  global _dnet_mp_dbg_snap_skip_rate
  global _dnet_mp_dbg_snap_built
  global _dnet_mp_dbg_snap_targets
  global _dnet_mp_dbg_snap_sent
  global _dnet_mp_dbg_unknown_payload_drop
  global _dnet_mp_snap_cache_tick
  global _dnet_mp_snap_cache_force_all
  global _dnet_mp_snap_cache_player_rows
  global _dnet_mp_snap_cache_actor_ids
  global _dnet_mp_snap_cache_actor_refs
  global _dnet_mp_snap_cache_removed_ids
  global _dnet_mp_snap_cache_sector_rows
  global _dnet_mp_snap_cache_side_rows

  _dnet_mp_last_snapshot_tic = 0
  _dnet_mp_last_input_seq = 0
  _dnet_mp_last_input_send_tic = 0
  _dnet_mp_last_input_cmd = void
  _dnet_mp_remote_cmds = array(MAXPLAYERS)
  _dnet_mp_remote_cmd_valid = array(MAXPLAYERS, false)
  _dnet_mp_remote_cmd_tic = array(MAXPLAYERS, 0)
  _dnet_mp_remote_input_last_seq = array(MAXPLAYERS, -1)
  _dnet_mp_host_input_active_logged = array(MAXPLAYERS, false)
  _dnet_mp_last_phase_tic = 0
  _dnet_mp_host_last_phase_key = void
  _dnet_mp_host_last_wistats_tic = 0
  _dnet_mp_host_last_wistats_req_tic = array(MAXPLAYERS, -1000000)
  _dnet_mp_client_last_phase_tick = 0
  _dnet_mp_host_last_frags = array(MAXPLAYERS)
  _dnet_mp_host_last_chat_tic = array(MAXPLAYERS, -1000000)
  _dnet_mp_host_slot_fullsync_burst = array(MAXPLAYERS, 0)
  i = 0
  while i < MAXPLAYERS
    _dnet_mp_remote_cmds[i] = ticcmd_t(0, 0, 0, 0, 0, 0)
    _dnet_mp_host_last_frags[i] = array(MAXPLAYERS, 0)
    i = i + 1
  end while

  _dnet_mp_host_actor_ids = []
  _dnet_mp_host_actor_nodes = []
  _dnet_mp_host_actor_refs = []
  _dnet_mp_host_last_actor_sig = []
  _dnet_mp_host_actor_miss = []
  _dnet_mp_host_actor_seen = bytes(0, 0)
  _dnet_mp_host_actor_active_count = 0
  _dnet_mp_host_removed_ids = []
  _dnet_mp_host_next_actor_id = 1
  _dnet_mp_host_actor_cursor = 0
  _dnet_mp_host_sector_cursor = 0
  _dnet_mp_host_last_player_sig = array(MAXPLAYERS, 0)
  _dnet_mp_host_last_sector_floor = []
  _dnet_mp_host_last_sector_ceiling = []
  _dnet_mp_host_last_sector_light = []
  _dnet_mp_host_last_sector_special = []
  _dnet_mp_host_side_cursor = 0
  _dnet_mp_host_last_side_top = []
  _dnet_mp_host_last_side_bottom = []
  _dnet_mp_host_last_side_mid = []
  _dnet_mp_host_cached_wistats = void
  _dnet_mp_client_actor_ids = []
  _dnet_mp_client_actor_refs = []
  _dnet_mp_client_actor_miss = []
  _dnet_mp_client_actor_tx = []
  _dnet_mp_client_actor_ty = []
  _dnet_mp_client_actor_tz = []
  _dnet_mp_client_actor_tang = []
  _dnet_mp_client_actor_vx = []
  _dnet_mp_client_actor_vy = []
  _dnet_mp_client_actor_vz = []
  _dnet_mp_client_actor_last_snap_tic = []
  _dnet_mp_client_actor_kind = []
  _dnet_mp_client_player_tx = []
  _dnet_mp_client_player_ty = []
  _dnet_mp_client_player_tz = []
  _dnet_mp_client_player_tang = []
  _dnet_mp_client_player_vx = []
  _dnet_mp_client_player_vy = []
  _dnet_mp_client_player_vz = []
  _dnet_mp_client_player_last_snap_tic = []
  _dnet_mp_client_last_smooth_tic = -1
  _dnet_mp_client_last_snapshot_tick = 0
  _dnet_mp_client_pending_snapshot = void
  _dnet_mp_client_world_bootstrapped = false
  _dnet_mp_client_ui_tic = -1
  _dnet_mp_client_wait_wistats = false
  _dnet_mp_client_have_wistats = false
  _dnet_mp_client_wistats_last_tick = 0
  _dnet_mp_client_wistats_next_req_tic = 0
  _dnet_mp_client_wistats_req_count = 0
  _dnet_mp_client_wistats_error = ""
  _dnet_mp_client_cached_wistats = void
  _dnet_mp_client_local_pickups_armed = false
  _dnet_mp_client_seen_players = bytes(MAXPLAYERS, 0)
  _dnet_mp_client_claimed_actors = bytes(0, 0)
  _dnet_mp_was_authoritative = false
  _dnet_mp_was_client = false
  _dnet_mp_local_name_announced = false
  _dnet_mp_dbg_snap_calls = 0
  _dnet_mp_dbg_snap_skip_not_host = 0
  _dnet_mp_dbg_snap_skip_not_level = 0
  _dnet_mp_dbg_snap_skip_nosend = 0
  _dnet_mp_dbg_snap_skip_rate = 0
  _dnet_mp_dbg_snap_built = 0
  _dnet_mp_dbg_snap_targets = 0
  _dnet_mp_dbg_snap_sent = 0
  _dnet_mp_dbg_unknown_payload_drop = 0
  _dnet_mp_snap_cache_tick = -1
  _dnet_mp_snap_cache_force_all = false
  _dnet_mp_snap_cache_player_rows = []
  _dnet_mp_snap_cache_actor_ids = []
  _dnet_mp_snap_cache_actor_refs = []
  _dnet_mp_snap_cache_removed_ids = []
  _dnet_mp_snap_cache_sector_rows = []
  _dnet_mp_snap_cache_side_rows = []
end function

/// Returns authoritative d_net snapshot diagnostics for on-screen overlay.
function D_NetMPDebugOverlayText()
  if _DNet_MPIsClient() then
    if typeof(_dnet_mp_client_wistats_error) == "string" and _dnet_mp_client_wistats_error != "" then
      return _dnet_mp_client_wistats_error
    end if
    if _dnet_mp_client_wait_wistats then
      left = _DNET_MP_WISTATS_MAX_RETRIES - _DNet_ToInt(_dnet_mp_client_wistats_req_count, 0)
      if left < 0 then left = 0 end if
      return "MP waiting intermission stats (" + left + " retries left)"
    end if
    return ""
  end if
  if not _DNet_MPIsAuthoritative() then return "" end if
  txt = "DNET snap c=" + _DNet_ToInt(_dnet_mp_dbg_snap_calls, 0)
  txt = txt + " b=" + _DNet_ToInt(_dnet_mp_dbg_snap_built, 0)
  txt = txt + " t=" + _DNet_ToInt(_dnet_mp_dbg_snap_targets, 0)
  txt = txt + " s=" + _DNet_ToInt(_dnet_mp_dbg_snap_sent, 0)
  txt = txt + " sk=" + _DNet_ToInt(_dnet_mp_dbg_snap_skip_not_host, 0) + "/" + _DNet_ToInt(_dnet_mp_dbg_snap_skip_not_level, 0) + "/" + _DNet_ToInt(_dnet_mp_dbg_snap_skip_nosend, 0) + "/" + _DNet_ToInt(_dnet_mp_dbg_snap_skip_rate, 0)
  txt = txt + " act=" + _DNet_ToInt(_dnet_mp_host_actor_active_count, 0) + "/" + len(_dnet_mp_host_actor_ids) + "/" + len(_dnet_mp_host_removed_ids)
  txt = txt + " uk=" + _DNet_ToInt(_dnet_mp_dbg_unknown_payload_drop, 0)
  if typeof(gamestate) == "int" then
    txt = txt + " gs=" + gamestate
  end if
  return txt
end function

/// Returns currently active multiplayer slots with host slot always present.
/// @internal
function inline _DNet_MPActiveSlots()
  if typeof(MP_PlatformGetActiveSlots) == "function" then
    s = MP_PlatformGetActiveSlots()
    if _DNet_IsSeq(s) and len(s) > 0 then return s end if
  end if
  return [0]
end function

/// Checks if slot is present in active slot list.
/// @param active Whether the requested state should be active.
/// @param slot Slot value supplied to `_DNet_MPSlotActive`.
/// @internal
function inline _DNet_MPSlotActive(active, slot)
  if not _DNet_IsSeq(active) then return false end if
  i = 0
  while i < len(active)
    if _DNet_ToInt(active[i], -1) == slot then return true end if
    i = i + 1
  end while
  return false
end function

/// Resolves a readable player name for HUD/event messages.
/// @param slot Slot value supplied to `_DNet_MPPlayerName`.
/// @internal
function inline _DNet_MPPlayerName(slot)
  s = _DNet_ToInt(slot, 0)
  if s < 0 then s = 0 end if
  if s >= MAXPLAYERS then s = MAXPLAYERS - 1 end if
  if typeof(MP_PlatformGetPlayerNameBySlot) == "function" then
    nm = MP_PlatformGetPlayerNameBySlot(s)
    if typeof(nm) == "string" and nm != "" then return nm end if
  end if
  return "Player " + (s + 1)
end function

/// Returns a fixed-size 4-entry frag row copied from arbitrary source sequence.
/// @param src Src value supplied to `_DNet_MPCopyFrags4`.
/// @internal
function inline _DNet_MPCopyFrags4(src)
  fr = [0, 0, 0, 0]
  if _DNet_IsSeq(src) then
    if len(src) > 0 then fr[0] = _DNet_ToInt(src[0], 0) end if
    if len(src) > 1 then fr[1] = _DNet_ToInt(src[1], 0) end if
    if len(src) > 2 then fr[2] = _DNet_ToInt(src[2], 0) end if
    if len(src) > 3 then fr[3] = _DNet_ToInt(src[3], 0) end if
  end if
  return fr
end function

/// Writes one fixed-width null-terminated ASCII player name field.
/// @param payload Payload value supplied to `_DNet_MPWriteFixedName`.
/// @param off Zero-based byte or element offset.
/// @param width Width of the target in pixels or map units.
/// @param name Resource or object name to resolve.
/// @internal
function _DNet_MPWriteFixedName(payload, off, width, name)
  if typeof(payload) != "bytes" then return end if
  o = _DNet_ToInt(off, 0)
  w = _DNet_ToInt(width, 0)
  if w <= 0 then return end if
  if o < 0 then o = 0 end if
  if o + w > len(payload) then return end if

  i = 0
  while i < w
    payload[o + i] = 0
    i = i + 1
  end while

  if typeof(name) != "string" or name == "" then return end if
  src = bytes(name)
  if typeof(src) != "bytes" or len(src) == 0 then return end if
  lim = w - 1
  if lim < 0 then lim = 0 end if
  i = 0
  while i < len(src) and i < lim
    c = src[i] & 255
    if c < 32 or c > 126 then c = 32 end if
    payload[o + i] = c
    i = i + 1
  end while
end function

/// Reads one fixed-width null-terminated ASCII player name field.
/// @param payload Payload value supplied to `_DNet_MPReadFixedName`.
/// @param off Zero-based byte or element offset.
/// @param width Width of the target in pixels or map units.
/// @internal
function _DNet_MPReadFixedName(payload, off, width)
  if typeof(payload) != "bytes" then return "" end if
  o = _DNet_ToInt(off, 0)
  w = _DNet_ToInt(width, 0)
  if w <= 0 then return "" end if
  if o < 0 or o >= len(payload) then return "" end if
  if o + w > len(payload) then w = len(payload) - o end if
  if w <= 0 then return "" end if

  n = 0
  i = 0
  while i < w
    c = payload[o + i] & 255
    if c == 0 then break end if
    n = n + 1
    i = i + 1
  end while
  if n <= 0 then return "" end if

  tmp = bytes(n, 0)
  i = 0
  while i < n
    c = payload[o + i] & 255
    if c < 32 or c > 126 then c = 32 end if
    tmp[i] = c
    i = i + 1
  end while
  s = decode(tmp)
  if typeof(s) != "string" then return "" end if
  return s
end function

/// Builds one intermission player row from current authoritative runtime player state.
/// @param slot Slot value supplied to `_DNet_MPMakeWBRowForSlot`.
/// @internal
function _DNet_MPMakeWBRowForSlot(slot)
  s = _DNet_ToInt(slot, 0)
  if s < 0 then s = 0 end if
  if s >= MAXPLAYERS then s = MAXPLAYERS - 1 end if

  ingame = false
  if _DNet_IsSeq(playeringame) and s < len(playeringame) then
    if typeof(playeringame[s]) == "bool" then
      ingame = playeringame[s]
    else
      ingame = _DNet_ToInt(playeringame[s], 0) != 0
    end if
  end if

  skills = 0
  sitems = 0
  ssecret = 0
  stime = _DNet_ToInt(leveltime, 0)
  score = 0
  fr = [0, 0, 0, 0]

  if _DNet_IsSeq(players) and s < len(players) and typeof(players[s]) == "struct" then
    pp = players[s]
    skills = _DNet_ToInt(pp.killcount, 0)
    sitems = _DNet_ToInt(pp.itemcount, 0)
    ssecret = _DNet_ToInt(pp.secretcount, 0)
    fr = _DNet_MPCopyFrags4(pp.frags)

    // MiniLang may hold gameplay-updated player counters on the mobj-owned player view.
    // Merge those values so intermission stats stay authoritative for remote clients, too.
    if typeof(pp.mo) == "struct" and typeof(pp.mo.player) == "struct" then
      mp = pp.mo.player
      mskills = _DNet_ToInt(mp.killcount, skills)
      msitems = _DNet_ToInt(mp.itemcount, sitems)
      mssecret = _DNet_ToInt(mp.secretcount, ssecret)
      mfr = _DNet_MPCopyFrags4(mp.frags)

      if mskills != 0 or skills == 0 then skills = mskills end if
      if msitems != 0 or sitems == 0 then sitems = msitems end if
      if mssecret != 0 or ssecret == 0 then ssecret = mssecret end if
      if _DNet_ToInt(mfr[0], 0) != 0 or _DNet_ToInt(mfr[1], 0) != 0 or _DNet_ToInt(mfr[2], 0) != 0 or _DNet_ToInt(mfr[3], 0) != 0 then
        fr = mfr
      end if
    end if
  end if

  return wbplayerstruct_t(ingame, skills, sitems, ssecret, stime, fr, score)
end function

/// Builds a complete intermission stats struct from wminfo with runtime fallback.
/// @internal
function _DNet_MPBuildIntermissionWB()
  epsd = _DNet_ToInt(gameepisode, 1) - 1
  didsecret = false
  last = _DNet_ToInt(gamemap, 1) - 1
  nextv = _DNet_ToInt(gamemap, 1)
  maxkills = _DNet_ToInt(totalkills, 1)
  maxitems = _DNet_ToInt(totalitems, 1)
  maxsecret = _DNet_ToInt(totalsecret, 1)
  maxfrags = 0
  partime = 0
  pnum = _DNet_ToInt(consoleplayer, 0)
  if pnum < 0 then pnum = 0 end if
  if pnum >= MAXPLAYERS then pnum = MAXPLAYERS - 1 end if

  plyr = array(MAXPLAYERS)
  i = 0
  while i < MAXPLAYERS
    plyr[i] = _DNet_MPMakeWBRowForSlot(i)
    i = i + 1
  end while

  if typeof(wminfo) == "struct" then
    epsd = _DNet_ToInt(wminfo.epsd, epsd)
    if typeof(wminfo.didsecret) == "bool" then
      didsecret = wminfo.didsecret
    else
      didsecret = _DNet_ToInt(wminfo.didsecret, 0) != 0
    end if
    last = _DNet_ToInt(wminfo.last, last)
    nextv = _DNet_ToInt(wminfo.next, nextv)
    maxkills = _DNet_ToInt(wminfo.maxkills, maxkills)
    maxitems = _DNet_ToInt(wminfo.maxitems, maxitems)
    maxsecret = _DNet_ToInt(wminfo.maxsecret, maxsecret)
    maxfrags = _DNet_ToInt(wminfo.maxfrags, maxfrags)
    partime = _DNet_ToInt(wminfo.partime, partime)
    pnum = _DNet_ToInt(wminfo.pnum, pnum)
    if pnum < 0 then pnum = 0 end if
    if pnum >= MAXPLAYERS then pnum = MAXPLAYERS - 1 end if

    if _DNet_IsSeq(wminfo.plyr) then
      i = 0
      while i < MAXPLAYERS and i < len(wminfo.plyr)
        if typeof(wminfo.plyr[i]) == "struct" then
          rr = _DNet_MPMakeWBRowForSlot(i)
          rp = wminfo.plyr[i]
          rin = _DNet_ToInt(rr.inum, 0) != 0
          if typeof(rp.inum) == "bool" then
            rin = rp.inum
          else
            // Keep runtime inum when exported row carries default/invalid marker.
            rpIn = _DNet_ToInt(rp.inum, -1)
            if rpIn >= 0 then rin = rpIn != 0 end if
          end if
          rskills = _DNet_ToInt(rr.skills, 0)
          rsitems = _DNet_ToInt(rr.sitems, 0)
          rssecret = _DNet_ToInt(rr.ssecret, 0)
          rstime = _DNet_ToInt(rr.stime, _DNet_ToInt(leveltime, 0))
          rscore = _DNet_ToInt(rr.score, 0)
          rfr = _DNet_MPCopyFrags4(rr.frags)
          pskills = _DNet_ToInt(rp.skills, rskills)
          psitems = _DNet_ToInt(rp.sitems, rsitems)
          pssecret = _DNet_ToInt(rp.ssecret, rssecret)
          pstime = _DNet_ToInt(rp.stime, rstime)
          pscore = _DNet_ToInt(rp.score, rscore)
          pfr = _DNet_MPCopyFrags4(rp.frags)

          // If exported row is default-zero but runtime has real values, keep runtime values.
          if pskills == 0 and rskills != 0 then pskills = rskills end if
          if psitems == 0 and rsitems != 0 then psitems = rsitems end if
          if pssecret == 0 and rssecret != 0 then pssecret = rssecret end if
          if pstime <= 0 and rstime > 0 then pstime = rstime end if
          if pscore == 0 and rscore != 0 then pscore = rscore end if
          if _DNet_ToInt(pfr[0], 0) == 0 and _DNet_ToInt(pfr[1], 0) == 0 and _DNet_ToInt(pfr[2], 0) == 0 and _DNet_ToInt(pfr[3], 0) == 0 then
            if _DNet_ToInt(rfr[0], 0) != 0 or _DNet_ToInt(rfr[1], 0) != 0 or _DNet_ToInt(rfr[2], 0) != 0 or _DNet_ToInt(rfr[3], 0) != 0 then
              pfr = rfr
            end if
          end if

          plyr[i] = wbplayerstruct_t(
          rin,
          pskills,
          psitems,
          pssecret,
          pstime,
          pfr,
          pscore
        )
        end if
        i = i + 1
      end while
    end if
  end if

  if maxkills <= 0 then maxkills = 1 end if
  if maxitems <= 0 then maxitems = 1 end if
  if maxsecret <= 0 then maxsecret = 1 end if

  return wbstartstruct_t(
  epsd,
  didsecret,
  last,
  nextv,
  maxkills,
  maxitems,
  maxsecret,
  maxfrags,
  partime,
  pnum,
  plyr
)
end function

/// Compares one intermission row for gameplay-relevant stat changes.
/// @param a First input operand.
/// @param b Second input operand.
/// @internal
function inline _DNet_MPWBRowChanged(a, b)
  if typeof(a) != "struct" and typeof(b) != "struct" then return false end if
  if typeof(a) != "struct" or typeof(b) != "struct" then return true end if

  ain = false
  if typeof(a.inum) == "bool" then
    ain = a.inum
  else
    ain = _DNet_ToInt(a.inum, 0) != 0
  end if
  bin = false
  if typeof(b.inum) == "bool" then
    bin = b.inum
  else
    bin = _DNet_ToInt(b.inum, 0) != 0
  end if
  if ain != bin then return true end if

  if _DNet_ToInt(a.skills, 0) != _DNet_ToInt(b.skills, 0) then return true end if
  if _DNet_ToInt(a.sitems, 0) != _DNet_ToInt(b.sitems, 0) then return true end if
  if _DNet_ToInt(a.ssecret, 0) != _DNet_ToInt(b.ssecret, 0) then return true end if
  if _DNet_ToInt(a.score, 0) != _DNet_ToInt(b.score, 0) then return true end if

  af = _DNet_MPCopyFrags4(a.frags)
  bf = _DNet_MPCopyFrags4(b.frags)
  if _DNet_ToInt(af[0], 0) != _DNet_ToInt(bf[0], 0) then return true end if
  if _DNet_ToInt(af[1], 0) != _DNet_ToInt(bf[1], 0) then return true end if
  if _DNet_ToInt(af[2], 0) != _DNet_ToInt(bf[2], 0) then return true end if
  if _DNet_ToInt(af[3], 0) != _DNet_ToInt(bf[3], 0) then return true end if
  return false
end function

/// Detects whether a newer WI stats packet requires intermission state refresh.
/// @param oldwb Oldwb value supplied to `_DNet_MPWBStatsChanged`.
/// @param newwb Newwb value supplied to `_DNet_MPWBStatsChanged`.
/// @internal
function inline _DNet_MPWBStatsChanged(oldwb, newwb)
  if typeof(oldwb) != "struct" and typeof(newwb) != "struct" then return false end if
  if typeof(oldwb) != "struct" or typeof(newwb) != "struct" then return true end if

  if _DNet_ToInt(oldwb.maxkills, 0) != _DNet_ToInt(newwb.maxkills, 0) then return true end if
  if _DNet_ToInt(oldwb.maxitems, 0) != _DNet_ToInt(newwb.maxitems, 0) then return true end if
  if _DNet_ToInt(oldwb.maxsecret, 0) != _DNet_ToInt(newwb.maxsecret, 0) then return true end if
  if _DNet_ToInt(oldwb.maxfrags, 0) != _DNet_ToInt(newwb.maxfrags, 0) then return true end if

  i = 0
  while i < MAXPLAYERS
    oa = void
    na = void
    if _DNet_IsSeq(oldwb.plyr) and i < len(oldwb.plyr) then oa = oldwb.plyr[i] end if
    if _DNet_IsSeq(newwb.plyr) and i < len(newwb.plyr) then na = newwb.plyr[i] end if
    if _DNet_MPWBRowChanged(oa, na) then return true end if
    i = i + 1
  end while
  return false
end function

/// Serializes host intermission stats so clients can render exact percentages and icons.
/// @internal
function _DNet_MPBuildWIStatsPacket()
  global _dnet_mp_host_cached_wistats
  wb = void
  if typeof(_dnet_mp_host_cached_wistats) == "struct" then
    wb = _dnet_mp_host_cached_wistats
  else
    wb = _DNet_MPBuildIntermissionWB()
    if typeof(wb) == "struct" then _dnet_mp_host_cached_wistats = wb end if
  end if
  if typeof(wb) != "struct" then return void end if

  rowCount = MAXPLAYERS
  size = 36 + rowCount * _DNET_MP_WISTATS_ROW_BYTES
  payload = bytes(size, 0)
  payload[0] = _DNET_MPMSG_WISTATS
  flags = 0
  if wb.didsecret then flags = flags | 1 end if
  payload[1] = flags & 255
  _DNet_MPWriteI16(payload, 2, _DNet_ToInt(wb.epsd, 0))
  _DNet_MPWriteI16(payload, 4, _DNet_ToInt(wb.last, 0))
  _DNet_MPWriteI16(payload, 6, _DNet_ToInt(wb.next, 0))
  payload[8] = _DNet_ToInt(wb.pnum, 0) & 255
  payload[9] = rowCount & 255
  payload[10] = _DNet_MPPhaseCode() & 255
  payload[11] = 0
  maxk = _DNet_ToInt(wb.maxkills, _DNet_ToInt(totalkills, 1))
  maxi = _DNet_ToInt(wb.maxitems, _DNet_ToInt(totalitems, 1))
  maxs = _DNet_ToInt(wb.maxsecret, _DNet_ToInt(totalsecret, 1))
  if maxk <= 0 then maxk = _DNet_ToInt(totalkills, 1) end if
  if maxi <= 0 then maxi = _DNet_ToInt(totalitems, 1) end if
  if maxs <= 0 then maxs = _DNet_ToInt(totalsecret, 1) end if
  if maxk <= 0 then maxk = 1 end if
  if maxi <= 0 then maxi = 1 end if
  if maxs <= 0 then maxs = 1 end if
  _DNet_MPWriteI32(payload, 12, maxk)
  _DNet_MPWriteI32(payload, 16, maxi)
  _DNet_MPWriteI32(payload, 20, maxs)
  _DNet_MPWriteI32(payload, 24, _DNet_ToInt(wb.partime, 0))
  _DNet_MPWriteI32(payload, 28, _DNet_ToInt(wb.maxfrags, 0))
  _DNet_MPWriteU32(payload, 32, _DNet_ToInt(gametic, 0))

  off = 36
  i = 0
  while i < rowCount
    liveRow = _DNet_MPMakeWBRowForSlot(i)
    row = liveRow
    if _DNet_IsSeq(wb.plyr) and i < len(wb.plyr) and typeof(wb.plyr[i]) == "struct" then
      row = wb.plyr[i]
      if _DNet_ToInt(row.skills, 0) == 0 and _DNet_ToInt(liveRow.skills, 0) != 0 then row.skills = _DNet_ToInt(liveRow.skills, 0) end if
      if _DNet_ToInt(row.sitems, 0) == 0 and _DNet_ToInt(liveRow.sitems, 0) != 0 then row.sitems = _DNet_ToInt(liveRow.sitems, 0) end if
      if _DNet_ToInt(row.ssecret, 0) == 0 and _DNet_ToInt(liveRow.ssecret, 0) != 0 then row.ssecret = _DNet_ToInt(liveRow.ssecret, 0) end if
      if _DNet_ToInt(row.stime, 0) <= 0 and _DNet_ToInt(liveRow.stime, 0) > 0 then row.stime = _DNet_ToInt(liveRow.stime, 0) end if
      lfr = _DNet_MPCopyFrags4(liveRow.frags)
      rfr0 = _DNet_MPCopyFrags4(row.frags)
      if _DNet_ToInt(rfr0[0], 0) == 0 and _DNet_ToInt(rfr0[1], 0) == 0 and _DNet_ToInt(rfr0[2], 0) == 0 and _DNet_ToInt(rfr0[3], 0) == 0 then
        if _DNet_ToInt(lfr[0], 0) != 0 or _DNet_ToInt(lfr[1], 0) != 0 or _DNet_ToInt(lfr[2], 0) != 0 or _DNet_ToInt(lfr[3], 0) != 0 then
          row.frags = lfr
        end if
      end if
    end if
    rin = false
    if typeof(row.inum) == "bool" then
      rin = row.inum
    else
      rin = _DNet_ToInt(row.inum, 0) != 0
    end if
    rfr = _DNet_MPCopyFrags4(row.frags)

    payload[off] = i & 255
    if rin then
      payload[off + 1] = 1
    else
      payload[off + 1] = 0
    end if
    _DNet_MPWriteI16(payload, off + 2, _DNet_ToInt(row.skills, 0))
    _DNet_MPWriteI16(payload, off + 4, _DNet_ToInt(row.sitems, 0))
    _DNet_MPWriteI16(payload, off + 6, _DNet_ToInt(row.ssecret, 0))
    _DNet_MPWriteI32(payload, off + 8, _DNet_ToInt(row.stime, 0))
    _DNet_MPWriteI16(payload, off + 12, _DNet_ToInt(rfr[0], 0))
    _DNet_MPWriteI16(payload, off + 14, _DNet_ToInt(rfr[1], 0))
    _DNet_MPWriteI16(payload, off + 16, _DNet_ToInt(rfr[2], 0))
    _DNet_MPWriteI16(payload, off + 18, _DNet_ToInt(rfr[3], 0))
    _DNet_MPWriteI32(payload, off + 20, _DNet_ToInt(row.score, 0))
    pname = ""
    if typeof(MP_PlatformGetPlayerNameBySlot) == "function" then
      pname = MP_PlatformGetPlayerNameBySlot(i)
    end if
    _DNet_MPWriteFixedName(payload, off + _DNET_MP_WISTATS_BASE_ROW_BYTES, _DNET_MP_NAME_BYTES, pname)
    off = off + _DNET_MP_WISTATS_ROW_BYTES
    i = i + 1
  end while

  return payload
end function

/// Sends a full intermission stats packet to one client slot.
/// @param slot Slot value supplied to `_DNet_MPHostSendWIStatsTo`.
/// @internal
function inline _DNet_MPHostSendWIStatsTo(slot)
  if not _DNet_MPIsHost() then return false end if
  if typeof(MP_PlatformNetSend) != "function" then return false end if
  s = _DNet_ToInt(slot, -1)
  if s <= 0 or s >= MAXPLAYERS then return false end if
  payload = _DNet_MPBuildWIStatsPacket()
  if typeof(payload) != "bytes" then return false end if
  return MP_PlatformNetSend(s, payload)
end function

/// Broadcasts intermission stats snapshot to all connected clients.
/// @internal
function _DNet_MPHostBroadcastWIStats()
  global _dnet_mp_host_last_wistats_tic
  if not _DNet_MPIsHost() then return end if
  slots = _DNet_MPActiveSlots()
  i = 0
  while i < len(slots)
    s = _DNet_ToInt(slots[i], -1)
    if s > 0 and s < MAXPLAYERS then
      _DNet_MPHostSendWIStatsTo(s)
    end if
    i = i + 1
  end while
  _dnet_mp_host_last_wistats_tic = _DNet_ToInt(gametic, 0)
end function

/// Handles one client request for intermission stats retransmission.
/// @param node Node value supplied to `_DNet_MPHostHandleWIStatsRequest`.
/// @param payload Payload value supplied to `_DNet_MPHostHandleWIStatsRequest`.
/// @internal
function inline _DNet_MPHostHandleWIStatsRequest(node, payload)
  global _dnet_mp_host_last_wistats_req_tic
  if not _DNet_MPIsHost() then return end if
  if typeof(payload) != "bytes" or len(payload) != 6 then return end if
  if (payload[0] & 255) != _DNET_MPMSG_WISTATS_REQ then return end if
  slot = _DNet_ToInt(node, -1)
  if slot < 1 or slot >= MAXPLAYERS then return end if
  if (payload[1] & 255) != slot then return end if
  nowtic = _DNet_ToInt(gametic, 0)
  if _DNet_IsSeq(_dnet_mp_host_last_wistats_req_tic) and slot < len(_dnet_mp_host_last_wistats_req_tic) then
    if nowtic - _DNet_ToInt(_dnet_mp_host_last_wistats_req_tic[slot], -1000000) < _DNET_MP_WISTATS_REQ_COOLDOWN_TICS then return end if
    _dnet_mp_host_last_wistats_req_tic[slot] = nowtic
  end if
  _DNet_MPHostSendWIStatsTo(slot)
end function

/// Collapses stale multiplayer clocks/slots after transport loss and returns to a defined title state.
/// @param wasClient Was client value supplied to `_DNet_MPReturnToOffline`.
/// @internal
function _DNet_MPReturnToOffline(wasClient)
  global usergame
  global paused
  role = "HOST"
  if wasClient then role = "CLIENT" end if
  if typeof(D_NetInitSinglePlayer) == "function" then D_NetInitSinglePlayer() end if
  usergame = false
  paused = false
  if typeof(M_ClearMenus) == "function" then M_ClearMenus() end if
  if typeof(D_StartTitle) == "function" then D_StartTitle() end if
  line = "MPTEST " + role + "_OFFLINE active=0 console=0 state=title"
  if typeof(_MMENU_MPStatus) == "function" then
    _MMENU_MPStatus(line)
  else
    print line
  end if
end function

/// Sends one client-side intermission stats request to the host.
/// @internal
function inline _DNet_MPSendWIStatsRequest()
  if not _DNet_MPIsClient() then return false end if
  if typeof(MP_PlatformNetSend) != "function" then return false end if
  payload = bytes(6, 0)
  payload[0] = _DNET_MPMSG_WISTATS_REQ
  payload[1] = _DNet_ToInt(consoleplayer, 0) & 255
  _DNet_MPWriteU32(payload, 2, _DNet_ToInt(gametic, 0))
  return MP_PlatformNetSend(0, payload)
end function

/// Applies host intermission stats packet to client WI runtime state.
/// @param payload Payload value supplied to `_DNet_MPClientApplyWIStats`.
/// @internal
function _DNet_MPClientApplyWIStats(payload)
  global _dnet_mp_client_wait_wistats
  global _dnet_mp_client_have_wistats
  global _dnet_mp_client_wistats_last_tick
  global _dnet_mp_client_wistats_next_req_tic
  global _dnet_mp_client_wistats_req_count
  global _dnet_mp_client_wistats_error
  global _dnet_mp_client_cached_wistats
  global consoleplayer
  global displayplayer
  global wminfo
  global gamestate
  global gameaction
  oldwb = wminfo
  wasHave = _dnet_mp_client_have_wistats
  if typeof(payload) != "bytes" or len(payload) < 32 then return end if
  if (payload[0] & 255) != _DNET_MPMSG_WISTATS then return end if

  rowCount = payload[9] & 255
  if rowCount < 0 then rowCount = 0 end if
  if rowCount > MAXPLAYERS then rowCount = MAXPLAYERS end if
  needOldLegacy = 32 + rowCount * _DNET_MP_WISTATS_BASE_ROW_BYTES
  needNewLegacy = 36 + rowCount * _DNET_MP_WISTATS_BASE_ROW_BYTES
  needNewNamed = 36 + rowCount * _DNET_MP_WISTATS_ROW_BYTES
  hasNamedRows = len(payload) == needNewNamed
  hasNew = len(payload) == needNewLegacy or hasNamedRows
  if (not hasNew) and len(payload) != needOldLegacy then return end if
  rowBytes = _DNET_MP_WISTATS_BASE_ROW_BYTES
  if hasNamedRows then rowBytes = _DNET_MP_WISTATS_ROW_BYTES end if

  maxfrags = 0
  offBase = 32
  statsTick = _DNet_MPReadU32(payload, 28)
  if hasNew then
    maxfrags = _DNet_MPReadI32(payload, 28)
    statsTick = _DNet_MPReadU32(payload, 32)
    offBase = 36
  end if
  lastTick = _DNet_ToInt(_dnet_mp_client_wistats_last_tick, 0)
  if _dnet_mp_client_have_wistats and statsTick <= lastTick then return end if

  epsd = _DNet_MPReadI16(payload, 2)
  last = _DNet_MPReadI16(payload, 4)
  nextv = _DNet_MPReadI16(payload, 6)
  maxkills = _DNet_MPReadI32(payload, 12)
  maxitems = _DNet_MPReadI32(payload, 16)
  maxsecret = _DNet_MPReadI32(payload, 20)
  partime = _DNet_MPReadI32(payload, 24)
  didsecret = (payload[1] & 1) != 0

  pnum = _DNet_ToInt(consoleplayer, 0)
  if typeof(MP_PlatformGetLocalPlayerSlot) == "function" then
    pnum = _DNet_ToInt(MP_PlatformGetLocalPlayerSlot(), pnum)
  end if
  if pnum < 0 then pnum = 0 end if
  if pnum >= MAXPLAYERS then pnum = MAXPLAYERS - 1 end if
  consoleplayer = pnum
  displayplayer = pnum

  plyr = array(MAXPLAYERS)
  i = 0
  while i < MAXPLAYERS
    plyr[i] = _DNet_MPMakeWBRowForSlot(i)
    i = i + 1
  end while

  off = offBase
  i = 0
  while i < rowCount
    if off + rowBytes > len(payload) then break end if
    slot = payload[off] & 255
    rin = (payload[off + 1] & 255) != 0
    skills = _DNet_MPReadI16(payload, off + 2)
    sitems = _DNet_MPReadI16(payload, off + 4)
    ssecret = _DNet_MPReadI16(payload, off + 6)
    stime = _DNet_MPReadI32(payload, off + 8)
    fr0 = _DNet_MPReadI16(payload, off + 12)
    fr1 = _DNet_MPReadI16(payload, off + 14)
    fr2 = _DNet_MPReadI16(payload, off + 16)
    fr3 = _DNet_MPReadI16(payload, off + 18)
    score = _DNet_MPReadI32(payload, off + 20)
    if slot >= 0 and slot < MAXPLAYERS then
      plyr[slot] = wbplayerstruct_t(rin, skills, sitems, ssecret, stime, [fr0, fr1, fr2, fr3], score)
      if rowBytes > _DNET_MP_WISTATS_BASE_ROW_BYTES and typeof(MP_PlatformSetPlayerNameBySlot) == "function" then
        pname = _DNet_MPReadFixedName(payload, off + _DNET_MP_WISTATS_BASE_ROW_BYTES, _DNET_MP_NAME_BYTES)
        if pname != "" then MP_PlatformSetPlayerNameBySlot(slot, pname) end if
      end if
    end if
    off = off + rowBytes
    i = i + 1
  end while

  wb = wbstartstruct_t(epsd, didsecret, last, nextv, maxkills, maxitems, maxsecret, maxfrags, partime, pnum, plyr)
  _dnet_mp_client_cached_wistats = wb
  _dnet_mp_client_wistats_last_tick = statsTick
  _dnet_mp_client_have_wistats = true
  _dnet_mp_client_wait_wistats = false
  _dnet_mp_client_wistats_req_count = 0
  _dnet_mp_client_wistats_next_req_tic = _DNet_ToInt(gametic, 0) + _DNET_MP_WISTATS_RETRY_TICS
  _dnet_mp_client_wistats_error = ""
  wminfo = wb

  if gamestate == gamestate_t.GS_INTERMISSION and typeof(WI_Start) == "function" then
    // Restart intermission only when stats become available first time
    // or when payload materially changed since initial snapshot.
    restartWi = (not wasHave)
    if wasHave and _DNet_MPWBStatsChanged(oldwb, wb) then restartWi = true end if
    if restartWi then
      WI_Start(wb)
      gamestate = gamestate_t.GS_INTERMISSION
      gameaction = gameaction_t.ga_nothing
    end if
  end if
end function

/// Runs bounded request/retry logic until client received host intermission stats.
/// @internal
function _DNet_MPClientUpdateWIStatsSync()
  global _dnet_mp_client_wait_wistats
  global _dnet_mp_client_have_wistats
  global _dnet_mp_client_wistats_next_req_tic
  global _dnet_mp_client_wistats_req_count
  global _dnet_mp_client_wistats_error
  if not _DNet_MPIsClient() then return end if
  if not _dnet_mp_client_wait_wistats then return end if
  if _dnet_mp_client_have_wistats then
    _dnet_mp_client_wait_wistats = false
    return
  end if
  if gamestate != gamestate_t.GS_INTERMISSION then return end if

  nowtic = _DNet_ToInt(gametic, 0)
  if nowtic < _DNet_ToInt(_dnet_mp_client_wistats_next_req_tic, 0) then return end if

  req = _DNet_ToInt(_dnet_mp_client_wistats_req_count, 0)
  if req >= _DNET_MP_WISTATS_MAX_RETRIES then
    _dnet_mp_client_wait_wistats = false
    if _dnet_mp_client_wistats_error == "" then
      _dnet_mp_client_wistats_error = "MP error: intermission stats sync timeout"
    end if
    return
  end if

  _DNet_MPSendWIStatsRequest()
  req = req + 1
  _dnet_mp_client_wistats_req_count = req
  _dnet_mp_client_wistats_next_req_tic = nowtic + _DNET_MP_WISTATS_RETRY_TICS
end function

/// Builds a small gameplay event packet (kill feed, etc.).
/// @param code Code value supplied to `_DNet_MPBuildFeedPacket`.
/// @param a First input operand.
/// @param b Second input operand.
/// @internal
function inline _DNet_MPBuildFeedPacket(code, a, b)
  payload = bytes(4, 0)
  payload[0] = _DNET_MPMSG_FEED
  payload[1] = _DNet_ToInt(code, 0) & 255
  payload[2] = _DNet_ToInt(a, 0) & 255
  payload[3] = _DNet_ToInt(b, 0) & 255
  return payload
end function

/// Normalizes chat text to printable ASCII and trims packet size.
/// @param msg Msg value supplied to `_DNet_MPNormalizeChatText`.
/// @internal
function _DNet_MPNormalizeChatText(msg)
  if typeof(msg) != "string" then return "" end if
  src = bytes(msg)
  if len(src) <= 0 then return "" end if

  outb = bytes(len(src), 0)
  n = 0
  i = 0
  while i < len(src)
    c = src[i] & 255
    if c >= 32 and c <= 126 then
      if n < len(outb) then
        outb[n] = c
        n = n + 1
      end if
    end if
    i = i + 1
  end while
  if n <= 0 then return "" end if
  if n > 120 then n = 120 end if
  return decode(slice(outb, 0, n))
end function

/// Builds one authoritative multiplayer chat packet.
/// @param senderSlot Sender slot value supplied to `_DNet_MPBuildChatPacket`.
/// @param dest Dest value supplied to `_DNet_MPBuildChatPacket`.
/// @param msg Msg value supplied to `_DNet_MPBuildChatPacket`.
/// @internal
function _DNet_MPBuildChatPacket(senderSlot, dest, msg)
  txt = _DNet_MPNormalizeChatText(msg)
  mb = bytes(txt)
  n = len(mb)
  payload = bytes(4 + n, 0)
  payload[0] = _DNET_MPMSG_CHAT
  payload[1] = _DNet_ToInt(senderSlot, 0) & 255
  payload[2] = _DNet_ToInt(dest, _DNET_MP_CHAT_BROADCAST) & 255
  payload[3] = n & 255
  i = 0
  while i < n
    payload[4 + i] = mb[i]
    i = i + 1
  end while
  return payload
end function

/// Broadcasts one host-authoritative kill message to all connected clients.
/// @param killer Killer value supplied to `_DNet_MPHostBroadcastKillFeed`.
/// @param victim Victim value supplied to `_DNet_MPHostBroadcastKillFeed`.
/// @internal
function _DNet_MPHostBroadcastKillFeed(killer, victim)
  if not _DNet_MPIsHost() then return end if
  msg = _DNet_MPPlayerName(killer) + " killed " + _DNet_MPPlayerName(victim)
  if _DNet_IsSeq(players) and consoleplayer >= 0 and consoleplayer < len(players) and typeof(players[consoleplayer]) == "struct" then
    p = players[consoleplayer]
    p.message = msg
    players[consoleplayer] = p
  end if

  if typeof(MP_PlatformNetSend) != "function" then return end if
  payload = _DNet_MPBuildFeedPacket(1, killer, victim)
  slots = _DNet_MPActiveSlots()
  i = 0
  while i < len(slots)
    s = _DNet_ToInt(slots[i], -1)
    if s > 0 then
      MP_PlatformNetSend(s, payload)
    end if
    i = i + 1
  end while
end function

/// Broadcasts one host-authoritative telefrag message to all connected clients.
/// @param killer Killer value supplied to `_DNet_MPHostBroadcastTelefragFeed`.
/// @param victim Victim value supplied to `_DNet_MPHostBroadcastTelefragFeed`.
/// @internal
function _DNet_MPHostBroadcastTelefragFeed(killer, victim)
  if not _DNet_MPIsHost() then return end if
  msg = _DNet_MPPlayerName(killer) + " telefragged " + _DNet_MPPlayerName(victim)
  if _DNet_IsSeq(players) and consoleplayer >= 0 and consoleplayer < len(players) and typeof(players[consoleplayer]) == "struct" then
    p = players[consoleplayer]
    p.message = msg
    players[consoleplayer] = p
  end if

  if typeof(MP_PlatformNetSend) != "function" then return end if
  payload = _DNet_MPBuildFeedPacket(2, killer, victim)
  slots = _DNet_MPActiveSlots()
  i = 0
  while i < len(slots)
    s = _DNet_ToInt(slots[i], -1)
    if s > 0 then
      MP_PlatformNetSend(s, payload)
    end if
    i = i + 1
  end while
end function

/// Applies one authoritative multiplayer chat message on the local HUD.
/// @param payload Payload value supplied to `_DNet_MPClientApplyChat`.
/// @internal
function inline _DNet_MPClientApplyChat(payload)
  if typeof(payload) != "bytes" or len(payload) < 4 then return end if
  if (payload[0] & 255) != _DNET_MPMSG_CHAT then return end if
  sender = payload[1] & 255
  dest = payload[2] & 255
  n = payload[3] & 255
  if n > 120 or len(payload) != 4 + n then return end if
  localSlot = _DNet_ToInt(consoleplayer, 0)
  recipient = dest - 1
  if dest != _DNET_MP_CHAT_BROADCAST and sender != localSlot and recipient != localSlot then return end if
  if n <= 0 then return end if
  txt = _DNet_MPNormalizeChatText(decode(slice(payload, 4, n)))
  if txt == "" then return end if
  if typeof(_MPPlatform_LogEvent) == "function" then
    _MPPlatform_LogEvent("MPTEST CHAT_RECEIVED sender=" + sender + " dest=" + dest + " length=" + len(bytes(txt)))
  end if
  msg = _DNet_MPPlayerName(sender) + ": " + txt
  HU_NetAddMessage(msg)
end function

/// Displays and routes a validated chat line to its sender and optional private recipient.
/// @param sender Sender value supplied to `_DNet_MPHostRelayChat`.
/// @param dest Dest value supplied to `_DNet_MPHostRelayChat`.
/// @param txt Txt value supplied to `_DNet_MPHostRelayChat`.
/// @internal
function _DNet_MPHostRelayChat(sender, dest, txt)
  if not _DNet_MPIsHost() then return false end if
  if sender < 0 or sender >= MAXPLAYERS then return false end if
  recipient = dest - 1
  if dest != _DNET_MP_CHAT_BROADCAST and (recipient < 0 or recipient >= MAXPLAYERS) then return false end if
  clean = _DNet_MPNormalizeChatText(txt)
  if clean == "" then return false end if
  if typeof(_MPPlatform_LogEvent) == "function" then
    _MPPlatform_LogEvent("MPTEST CHAT_RELAY sender=" + sender + " dest=" + dest + " length=" + len(bytes(clean)))
  end if

  localSlot = _DNet_ToInt(consoleplayer, 0)
  if dest == _DNET_MP_CHAT_BROADCAST or sender == localSlot or recipient == localSlot then
    HU_NetAddMessage(_DNet_MPPlayerName(sender) + ": " + clean)
  end if

  if typeof(MP_PlatformNetSend) != "function" then return true end if
  outp = _DNet_MPBuildChatPacket(sender, dest, clean)
  slots = _DNet_MPActiveSlots()
  i = 0
  while i < len(slots)
    s = _DNet_ToInt(slots[i], -1)
    if s > 0 and s < MAXPLAYERS then
      if dest == _DNET_MP_CHAT_BROADCAST or s == sender or s == recipient then
        MP_PlatformNetSend(s, outp)
      end if
    end if
    i = i + 1
  end while
  return true
end function

/// Validates and relays one client chat packet as authoritative chat event.
/// @param node Node value supplied to `_DNet_MPHostHandleChatPacket`.
/// @param payload Payload value supplied to `_DNet_MPHostHandleChatPacket`.
/// @internal
function _DNet_MPHostHandleChatPacket(node, payload)
  global _dnet_mp_host_last_chat_tic
  payloadSender = -1
  payloadDest = -1
  payloadLength = -1
  if typeof(payload) == "bytes" then
    if len(payload) > 1 then payloadSender = payload[1] & 255 end if
    if len(payload) > 2 then payloadDest = payload[2] & 255 end if
    if len(payload) > 3 then payloadLength = payload[3] & 255 end if
  end if
  if typeof(_MPPlatform_LogEvent) == "function" then
    _MPPlatform_LogEvent("MPTEST CHAT_HOST_RX node=" + _DNet_ToInt(node, -1) + " payload_sender=" + payloadSender + " dest=" + payloadDest + " length=" + payloadLength)
  end if
  if not _DNet_MPIsHost() then return end if
  if typeof(payload) != "bytes" or len(payload) < 4 then return end if
  if (payload[0] & 255) != _DNET_MPMSG_CHAT then return end if

  sender = _DNet_ToInt(node, -1)
  if sender < 1 or sender >= MAXPLAYERS then return end if
  if (payload[1] & 255) != sender then return end if

  dest = payload[2] & 255
  n = payload[3] & 255
  if n > 120 or len(payload) != 4 + n then return end if
  if n <= 0 then return end if
  txt = _DNet_MPNormalizeChatText(decode(slice(payload, 4, n)))
  if txt == "" then return end if
  nowtic = _DNet_ToInt(gametic, 0)
  if _DNet_IsSeq(_dnet_mp_host_last_chat_tic) and sender < len(_dnet_mp_host_last_chat_tic) then
    if nowtic - _DNet_ToInt(_dnet_mp_host_last_chat_tic[sender], -1000000) < _DNET_MP_CHAT_COOLDOWN_TICS then return end if
    _dnet_mp_host_last_chat_tic[sender] = nowtic
  end if
  _DNet_MPHostRelayChat(sender, dest, txt)
end function

/// Sends local HUD chat through the authoritative packet channel, preserving private destinations.
/// @param dest Dest value supplied to `D_NetMPSendChat`.
/// @param msg Msg value supplied to `D_NetMPSendChat`.
function D_NetMPSendChat(dest, msg)
  if not _DNet_MPIsAuthoritative() then return false end if
  sender = _DNet_ToInt(consoleplayer, 0)
  if sender < 0 or sender >= MAXPLAYERS then return false end if
  clean = _DNet_MPNormalizeChatText(msg)
  if clean == "" then return false end if
  recipient = _DNet_ToInt(dest, _DNET_MP_CHAT_BROADCAST) - 1
  if dest != _DNET_MP_CHAT_BROADCAST and (recipient < 0 or recipient >= MAXPLAYERS) then return false end if
  if _DNet_MPIsHost() then
    return _DNet_MPHostRelayChat(sender, dest, clean)
  end if
  if typeof(MP_PlatformNetSend) != "function" then return false end if
  sent = MP_PlatformNetSend(0, _DNet_MPBuildChatPacket(sender, dest, clean))
  ok = 0
  if sent then ok = 1 end if
  if typeof(_MPPlatform_LogEvent) == "function" then
    _MPPlatform_LogEvent("MPTEST CHAT_SENT sender=" + sender + " dest=" + dest + " length=" + len(bytes(clean)) + " ok=" + ok)
  end if
  return sent
end function

/// Encodes one sanitized player-name update in a compact fixed-protocol packet.
/// @param slot Slot value supplied to `_DNet_MPBuildNamePacket`.
/// @param name Resource or object name to resolve.
/// @internal
function _DNet_MPBuildNamePacket(slot, name)
  clean = MP_SanitizeName(name)
  nb = bytes(clean)
  n = len(nb)
  if n > MP_MAX_NAME_LEN then n = MP_MAX_NAME_LEN end if
  payload = bytes(3 + n, 0)
  payload[0] = _DNET_MPMSG_NAME
  payload[1] = _DNet_ToInt(slot, 0) & 255
  payload[2] = n & 255
  i = 0
  while i < n
    payload[3 + i] = nb[i]
    i = i + 1
  end while
  return payload
end function

/// Validates a name packet's declared length and returns its canonical player name.
/// @param payload Payload value supplied to `_DNet_MPReadNamePacket`.
/// @internal
function _DNet_MPReadNamePacket(payload)
  if typeof(payload) != "bytes" or len(payload) < 4 then return "" end if
  if (payload[0] & 255) != _DNET_MPMSG_NAME then return "" end if
  n = payload[2] & 255
  if n <= 0 or n > MP_MAX_NAME_LEN or len(payload) != 3 + n then return "" end if
  return MP_SanitizeName(decode(slice(payload, 3, n)))
end function

/// Broadcasts one host-approved slot name to every connected multiplayer client.
/// @param slot Slot value supplied to `_DNet_MPHostBroadcastName`.
/// @param name Resource or object name to resolve.
/// @internal
function _DNet_MPHostBroadcastName(slot, name)
  if not _DNet_MPIsHost() or typeof(MP_PlatformNetSend) != "function" then return false end if
  payload = _DNet_MPBuildNamePacket(slot, name)
  slots = _DNet_MPActiveSlots()
  sentAny = false
  i = 0
  while i < len(slots)
    s = _DNet_ToInt(slots[i], -1)
    if s > 0 and s < MAXPLAYERS then
      if MP_PlatformNetSend(s, payload) then sentAny = true end if
    end if
    i = i + 1
  end while
  return sentAny
end function

/// Refreshes the complete small slot-name table so newly joined clients learn existing peers immediately.
/// @internal
function _DNet_MPHostBroadcastAllNames()
  if not _DNet_MPIsHost() then return end if
  _DNet_MPHostBroadcastName(0, _DNet_MPPlayerName(0))
  slots = _DNet_MPActiveSlots()
  i = 0
  while i < len(slots)
    slot = _DNet_ToInt(slots[i], -1)
    if slot > 0 and slot < MAXPLAYERS then
      _DNet_MPHostBroadcastName(slot, _DNet_MPPlayerName(slot))
    end if
    i = i + 1
  end while
end function

/// Applies one authoritative rename and reports changes made by another player.
/// @param payload Payload value supplied to `_DNet_MPClientApplyName`.
/// @internal
function _DNet_MPClientApplyName(payload)
  if not _DNet_MPIsClient() then return end if
  clean = _DNet_MPReadNamePacket(payload)
  if clean == "" then return end if
  slot = payload[1] & 255
  if slot < 0 or slot >= MAXPLAYERS then return end if
  old = _DNet_MPPlayerName(slot)
  if typeof(MP_PlatformSetPlayerNameBySlot) == "function" then
    MP_PlatformSetPlayerNameBySlot(slot, clean)
  end if
  if slot == _DNet_ToInt(consoleplayer, 0) then MP_SetPlayerName(clean) end if
  if typeof(_MPPlatform_LogEvent) == "function" then
    _MPPlatform_LogEvent("MPTEST NAME_RECEIVED slot=" + slot + " name=" + clean)
  end if
  if slot != _DNet_ToInt(consoleplayer, 0) and old != clean and typeof(HU_NetAddMessage) == "function" then
    HU_NetAddMessage(old + " is now " + clean)
  end if
end function

/// Authenticates a client rename by its transport slot, updates the peer table, and relays it.
/// @param node Node value supplied to `_DNet_MPHostHandleNamePacket`.
/// @param payload Payload value supplied to `_DNet_MPHostHandleNamePacket`.
/// @internal
function _DNet_MPHostHandleNamePacket(node, payload)
  if not _DNet_MPIsHost() then return end if
  sender = _DNet_ToInt(node, -1)
  if sender < 1 or sender >= MAXPLAYERS then return end if
  if typeof(payload) != "bytes" or len(payload) < 4 then return end if
  if (payload[1] & 255) != sender then return end if
  clean = _DNet_MPReadNamePacket(payload)
  if clean == "" then return end if

  old = _DNet_MPPlayerName(sender)
  if typeof(MP_PlatformSetPlayerNameBySlot) != "function" then return end if
  if not MP_PlatformSetPlayerNameBySlot(sender, clean) then return end if
  if typeof(_MPPlatform_LogEvent) == "function" then
    _MPPlatform_LogEvent("MPTEST NAME_RELAY slot=" + sender + " name=" + clean)
  end if
  if old != clean and typeof(HU_NetAddMessage) == "function" then
    HU_NetAddMessage(old + " is now " + clean)
  end if
  _DNet_MPHostBroadcastAllNames()
end function

/// Changes the local persistent name and propagates it through an active authoritative session.
/// @param name Resource or object name to resolve.
function D_NetMPSetPlayerName(name)
  clean = MP_SanitizeName(name)
  MP_SetPlayerName(clean)

  if not _DNet_MPIsAuthoritative() then return clean end if
  slot = _DNet_ToInt(consoleplayer, 0)
  if slot < 0 or slot >= MAXPLAYERS then slot = 0 end if
  if typeof(MP_PlatformSetPlayerNameBySlot) == "function" then
    MP_PlatformSetPlayerNameBySlot(slot, clean)
  end if

  if _DNet_MPIsHost() then
    _DNet_MPHostBroadcastAllNames()
    if typeof(_MPPlatform_LogEvent) == "function" then
      _MPPlatform_LogEvent("MPTEST NAME_RELAY slot=" + slot + " name=" + clean)
    end if
  else if _DNet_MPIsClient() and typeof(MP_PlatformNetSend) == "function" then
    sent = MP_PlatformNetSend(0, _DNet_MPBuildNamePacket(slot, clean))
    ok = 0
    if sent then ok = 1 end if
    if typeof(_MPPlatform_LogEvent) == "function" then
      _MPPlatform_LogEvent("MPTEST NAME_SENT slot=" + slot + " name=" + clean + " ok=" + ok)
    end if
  end if
  return clean
end function

/// Detects teleport-stomp frags so feed can use telefrag wording.
/// @param killer Killer value supplied to `_DNet_MPHostIsLikelyTelefrag`.
/// @param victim Victim value supplied to `_DNet_MPHostIsLikelyTelefrag`.
/// @internal
function _DNet_MPHostIsLikelyTelefrag(killer, victim)
  if killer < 0 or killer >= MAXPLAYERS or victim < 0 or victim >= MAXPLAYERS then return false end if
  if killer == victim then return false end if
  if not _DNet_IsSeq(players) then return false end if
  if killer >= len(players) or victim >= len(players) then return false end if
  if typeof(players[killer]) != "struct" or typeof(players[victim]) != "struct" then return false end if
  km = players[killer].mo
  vm = players[victim].mo
  if typeof(km) != "struct" or typeof(vm) != "struct" then return false end if
  if _DNet_ToInt(km.reactiontime, 0) <= 0 then return false end if
  dx = _DNet_ToInt(km.x, 0) - _DNet_ToInt(vm.x, 0)
  dy = _DNet_ToInt(km.y, 0) - _DNet_ToInt(vm.y, 0)
  if _DNet_MPAbs32(dx) > (8 * FRACUNIT) then return false end if
  if _DNet_MPAbs32(dy) > (8 * FRACUNIT) then return false end if
  if _DNet_ToInt(vm.health, 0) > 0 and _DNet_ToInt(players[victim].health, 0) > 0 then return false end if
  return true
end function

/// Detects host-side frag matrix increments and emits kill feed events.
/// @internal
function _DNet_MPHostCheckFragFeed()
  global _dnet_mp_host_last_frags
  if not _DNet_MPIsHost() then return end if
  if not _DNet_IsSeq(players) then return end if
  if not _DNet_IsSeq(_dnet_mp_host_last_frags) or len(_dnet_mp_host_last_frags) < MAXPLAYERS then
    _dnet_mp_host_last_frags = array(MAXPLAYERS)
  end if

  i = 0
  while i < MAXPLAYERS
    if not _DNet_IsSeq(_dnet_mp_host_last_frags[i]) or len(_dnet_mp_host_last_frags[i]) < MAXPLAYERS then
      _dnet_mp_host_last_frags[i] = array(MAXPLAYERS, 0)
    end if
    i = i + 1
  end while

  killer = 0
  while killer < MAXPLAYERS
    curFrags = void
    if killer < len(players) and typeof(players[killer]) == "struct" and _DNet_IsSeq(players[killer].frags) then
      curFrags = players[killer].frags
    end if
    victim = 0
    while victim < MAXPLAYERS
      prev = _DNet_ToInt(_dnet_mp_host_last_frags[killer][victim], 0)
      cur = 0
      if _DNet_IsSeq(curFrags) and victim < len(curFrags) then cur = _DNet_ToInt(curFrags[victim], 0) end if
      if cur > prev then
        d = cur - prev
        while d > 0
          if _DNet_MPHostIsLikelyTelefrag(killer, victim) then
            _DNet_MPHostBroadcastTelefragFeed(killer, victim)
          else
            _DNet_MPHostBroadcastKillFeed(killer, victim)
          end if
          d = d - 1
        end while
      end if
      _dnet_mp_host_last_frags[killer][victim] = cur
      victim = victim + 1
    end while
    killer = killer + 1
  end while
end function

/// Maps Doom gamestate to compact phase code used by phase sync packets.
/// @internal
function inline _DNet_MPPhaseCode()
  if gamestate == gamestate_t.GS_LEVEL then return 0 end if
  if gamestate == gamestate_t.GS_INTERMISSION then return 1 end if
  if gamestate == gamestate_t.GS_FINALE then return 2 end if
  return 3
end function

/// Resolves the next map number while host is in intermission.
/// @internal
function inline _DNet_MPIntermissionNextMap()
  nextMap = _DNet_ToInt(gamemap, 1)
  if gamestate == gamestate_t.GS_INTERMISSION and typeof(wminfo) == "struct" and typeof(wminfo.next) == "int" then
    nextMap = _DNet_ToInt(wminfo.next, 0) + 1
  end if
  if nextMap < 1 then nextMap = 1 end if
  if nextMap > 255 then nextMap = 255 end if
  return nextMap
end function

/// Builds a compact host phase packet for client flow synchronization.
/// @internal
function _DNet_MPBuildPhasePacket()
  payload = bytes(16, 0)
  payload[0] = _DNET_MPMSG_PHASE
  payload[1] = _DNet_MPPhaseCode() & 255
  payload[2] = _DNet_ToInt(gameepisode, 1) & 255
  payload[3] = _DNet_ToInt(gamemap, 1) & 255
  payload[4] = _DNet_MPIntermissionNextMap() & 255
  payload[5] = _DNet_ToInt(gameskill, 0) & 255
  flags = 0
  if deathmatch then flags = flags | 1 end if
  if secretexit then flags = flags | 2 end if
  payload[6] = flags & 255
  payload[7] = 0
  _DNet_MPWriteU32(payload, 8, _DNet_ToInt(gametic, 0))
  _DNet_MPWriteU32(payload, 12, _DNet_ToInt(leveltime, 0))
  return payload
end function

/// Periodically sends host game phase packets to keep clients flow-synchronized.
/// @param force Force value supplied to `_DNet_MPHostMaybeSendPhase`.
/// @internal
function _DNet_MPHostMaybeSendPhase(force)
  global _dnet_mp_last_phase_tic
  global _dnet_mp_host_last_phase_key
  global _dnet_mp_host_last_wistats_tic
  global _dnet_mp_host_cached_wistats
  if not _DNet_MPIsHost() then return end if
  if typeof(MP_PlatformNetSend) != "function" then return end if

  phase = _DNet_MPPhaseCode()
  ep = _DNet_ToInt(gameepisode, 1)
  mp = _DNet_ToInt(gamemap, 1)
  nx = _DNet_MPIntermissionNextMap()
  sk = _DNet_ToInt(gameskill, 0)
  fg = 0
  if deathmatch then fg = fg | 1 end if
  if secretexit then fg = fg | 2 end if
  key = [phase, ep, mp, nx, sk, fg]

  changed = true
  if _DNet_IsSeq(_dnet_mp_host_last_phase_key) and len(_dnet_mp_host_last_phase_key) >= 6 then
    changed = false
    i = 0
    while i < 6
      if _DNet_ToInt(_dnet_mp_host_last_phase_key[i], 0) != _DNet_ToInt(key[i], 0) then
        changed = true
        break
      end if
      i = i + 1
    end while
  end if

  gt = _DNet_ToInt(gametic, 0)
  if (not force) and (not changed) and(gt - _DNet_ToInt(_dnet_mp_last_phase_tic, 0) < _DNET_MP_PHASE_INTERVAL) then
    return
  end if

  payload = _DNet_MPBuildPhasePacket()
  if changed and phase == 1 and _DNet_IsSeq(players) then
    pi = 0
    while pi < MAXPLAYERS and pi < len(players)
      if typeof(players[pi]) == "struct" then
        pp = players[pi]
        pp.attackdown = true
        pp.usedown = true
        pp.cmd = ticcmd_t(0, 0, 0, 0, 0, 0)
        players[pi] = pp
      end if
      pi = pi + 1
    end while
  end if
  slots = _DNet_MPActiveSlots()
  i = 0
  while i < len(slots)
    s = _DNet_ToInt(slots[i], -1)
    if s > 0 then
      MP_PlatformNetSend(s, payload)
    end if
    i = i + 1
  end while
  _dnet_mp_host_last_phase_key = key
  _dnet_mp_last_phase_tic = gt
  if phase == 1 then
    if changed or force or typeof(_dnet_mp_host_cached_wistats) != "struct" then
      wb = _DNet_MPBuildIntermissionWB()
      if typeof(wb) == "struct" then _dnet_mp_host_cached_wistats = wb end if
    end if
    if changed or force or (gt - _DNet_ToInt(_dnet_mp_host_last_wistats_tic, 0) >= _DNET_MP_WISTATS_BROADCAST_INTERVAL) then
      _DNet_MPHostBroadcastWIStats()
    end if
  end if
end function

/// Returns true when level state is initialized enough for authoritative snapshots.
/// @internal
function _DNet_MPLevelReady()
  if gamestate == gamestate_t.GS_LEVEL then return true end if
  if not _DNet_IsSeq(sectors) or len(sectors) <= 0 then return false end if
  if not _DNet_IsSeq(players) or not _DNet_IsSeq(playeringame) then return false end if
  i = 0
  while i < MAXPLAYERS and i < len(players) and i < len(playeringame)
    if playeringame[i] and typeof(players[i]) == "struct" and typeof(players[i].mo) == "struct" then
      return true
    end if
    i = i + 1
  end while
  return false
end function

/// Checks whether thinker owner is a currently valid non-player mobj for replication.
/// @param mo Map object affected by the operation.
/// @internal
function inline _DNet_MPActorUsable(mo)
  if typeof(mo) != "struct" then return false end if
  if mo.player is not void then return false end if
  ty = _DNet_ToInt(mo.type, -1)
  if ty < 0 then return false end if
  // Skip short-lived visual-only effects on the wire; clients render these locally from gameplay events.
  if ty == mobjtype_t.MT_PUFF or ty == mobjtype_t.MT_BLOOD or ty == mobjtype_t.MT_SMOKE or ty == mobjtype_t.MT_TFOG or ty == mobjtype_t.MT_IFOG then
    return false
  end if
  // Host traversal already guarantees a live thinker node; do not reject on stale copied thinker fields.
  if typeof(mo.state) != "struct" and mo.state is not void then return false end if
  return true
end function

/// Returns true when thinker node is a mobj thinker callback.
/// @param node Node value supplied to `_DNet_MPThinkerIsMobj`.
/// @internal
function inline _DNet_MPThinkerIsMobj(node)
  if typeof(node) != "struct" then return false end if
  if node.func is void then return false end if
  if typeof(node.func) != "struct" then return false end if
  if typeof(node.func.acp1) != "function" then return false end if
  return node.func.acp1 == P_MobjThinker
end function

/// Locates host-side actor registry slot by stable actor key.
/// @param nodeKey Stable key identifying the network node.
/// @internal
function inline _DNet_MPHostFindActorIndex(nodeKey)
  if nodeKey <= 0 then return -1 end if
  i = 0
  while i < len(_dnet_mp_host_actor_ids) and i < len(_dnet_mp_host_actor_nodes)
    if _DNet_ToInt(_dnet_mp_host_actor_nodes[i], 0) == nodeKey and _DNet_ToInt(_dnet_mp_host_actor_ids[i], 0) > 0 then return i end if
    i = i + 1
  end while
  return -1
end function

/// Returns reusable host registry slot whose actor id was cleared.
/// @internal
function inline _DNet_MPHostFindFreeActorSlot()
  i = 0
  while i < len(_dnet_mp_host_actor_ids)
    if _DNet_ToInt(_dnet_mp_host_actor_ids[i], 0) <= 0 then return i end if
    i = i + 1
  end while
  return -1
end function

/// Finds an existing host actor slot by tight type/pose match as fallback when thinker key is missing.
/// @param owner Owner value supplied to `_DNet_MPHostFindActorIndexByPose`.
/// @internal
function _DNet_MPHostFindActorIndexByPose(owner)
  if typeof(owner) != "struct" then return -1 end if
  ox = _DNet_ToInt(owner.x, 0)
  oy = _DNet_ToInt(owner.y, 0)
  oz = _DNet_ToInt(owner.z, 0)
  ot = _DNet_ToInt(owner.type, -1)
  limit = 4 * FRACUNIT
  i = 0
  while i < len(_dnet_mp_host_actor_ids) and i < len(_dnet_mp_host_actor_refs)
    if _DNet_ToInt(_dnet_mp_host_actor_ids[i], 0) > 0 then
      ref = _dnet_mp_host_actor_refs[i]
      if _DNet_MPActorUsable(ref) and _DNet_ToInt(ref.type, -1) == ot then
        dx = _DNet_MPAbs32(_DNet_ToInt(ref.x, 0) - ox)
        dy = _DNet_MPAbs32(_DNet_ToInt(ref.y, 0) - oy)
        dz = _DNet_MPAbs32(_DNet_ToInt(ref.z, 0) - oz)
        if dx <= limit and dy <= limit and dz <= limit then return i end if
      end if
    end if
    i = i + 1
  end while
  return -1
end function

/// Queues one removed actor id for multiple snapshots to tolerate UDP packet loss.
/// @param idv Idv value supplied to `_DNet_MPHostQueueRemovedId`.
/// @internal
function inline _DNet_MPHostQueueRemovedId(idv)
  global _dnet_mp_host_removed_ids
  rid = _DNet_ToInt(idv, 0)
  if rid <= 0 then return end if
  n = _DNET_MP_REMOVE_RESEND_COUNT
  if n < 1 then n = 1 end if
  _dnet_mp_host_removed_ids = _dnet_mp_host_removed_ids + array(n, rid)
  qlen = len(_dnet_mp_host_removed_ids)
  if qlen > _DNET_MP_REMOVED_QUEUE_MAX then
    keep = _DNET_MP_REMOVED_QUEUE_MAX
    start = qlen - keep
    trim = array(keep, 0)
    i = 0
    while i < keep
      trim[i] = _DNet_ToInt(_dnet_mp_host_removed_ids[start + i], 0)
      i = i + 1
    end while
    _dnet_mp_host_removed_ids = trim
  end if
end function

/// Updates host-side actor registry and tracks removed actor ids.
/// @internal
function _DNet_MPHostRefreshActorRegistry()
  global _dnet_mp_host_actor_ids
  global _dnet_mp_host_actor_nodes
  global _dnet_mp_host_actor_refs
  global _dnet_mp_host_last_actor_sig
  global _dnet_mp_host_actor_miss
  global _dnet_mp_host_actor_seen
  global _dnet_mp_host_actor_active_count
  global _dnet_mp_host_removed_ids
  global _dnet_mp_host_actor_cursor

  if typeof(thinkercap) != "struct" then return end if
  if thinkercap.next is void then return end if

  if not _DNet_IsSeq(_dnet_mp_host_actor_nodes) then _dnet_mp_host_actor_nodes = [] end if
  if not _DNet_IsSeq(_dnet_mp_host_actor_refs) then _dnet_mp_host_actor_refs = [] end if
  if not _DNet_IsSeq(_dnet_mp_host_last_actor_sig) then _dnet_mp_host_last_actor_sig = [] end if
  if not _DNet_IsSeq(_dnet_mp_host_actor_miss) then _dnet_mp_host_actor_miss = [] end if
  // Keep parallel host actor arrays aligned; registry keys are thinker nodes.
  needHostActors = len(_dnet_mp_host_actor_ids)
  if len(_dnet_mp_host_actor_nodes) < needHostActors then
    _dnet_mp_host_actor_nodes = _dnet_mp_host_actor_nodes + array(needHostActors - len(_dnet_mp_host_actor_nodes), 0)
  end if
  if len(_dnet_mp_host_actor_refs) < needHostActors then
    _dnet_mp_host_actor_refs = _dnet_mp_host_actor_refs + array(needHostActors - len(_dnet_mp_host_actor_refs))
  end if
  if len(_dnet_mp_host_last_actor_sig) < needHostActors then
    _dnet_mp_host_last_actor_sig = _dnet_mp_host_last_actor_sig + array(needHostActors - len(_dnet_mp_host_last_actor_sig), 0)
  end if
  if len(_dnet_mp_host_actor_miss) < needHostActors then
    _dnet_mp_host_actor_miss = _dnet_mp_host_actor_miss + array(needHostActors - len(_dnet_mp_host_actor_miss), 0)
  end if

  seenCount = len(_dnet_mp_host_actor_ids)
  if typeof(_dnet_mp_host_actor_seen) != "bytes" or len(_dnet_mp_host_actor_seen) < seenCount then
    _dnet_mp_host_actor_seen = bytes(seenCount, 0)
  else
    si = 0
    while si < seenCount
      _dnet_mp_host_actor_seen[si] = 0
      si = si + 1
    end while
  end if
  seen = _dnet_mp_host_actor_seen

  cur = thinkercap.next
  guard = 0
  while cur != thinkercap and guard < 131072
    if typeof(cur) != "struct" then break end if
    nxt = cur.next
    if nxt is void then break end if
    if _DNet_MPThinkerIsMobj(cur) then
      owner = void
      if typeof(cur.owner) == "struct" then
        owner = cur.owner
      end if
      if typeof(owner) != "struct" and typeof(P_ResolveThinkerOwner) == "function" then
        o = P_ResolveThinkerOwner(cur)
        if typeof(o) == "struct" then owner = o end if
      end if
      if typeof(owner) != "struct" and typeof(_PM_ResolveThinkerOwner) == "function" then
        o2 = _PM_ResolveThinkerOwner(cur)
        if typeof(o2) == "struct" then owner = o2 end if
      end if
      if typeof(owner) == "struct" and _DNet_MPActorUsable(owner) then
        key = 0
        // Prefer thinker registration id: it is bound to the live thinker node and survives mobj state changes.
        if typeof(_PM_ResolveThinkerId) == "function" then
          key = _DNet_ToInt(_PM_ResolveThinkerId(cur), 0)
        end if
        if key <= 0 then
          key = _DNet_ToInt(owner.mpuid, 0)
        end if
        if key <= 0 then
          cur = nxt
          guard = guard + 1
          continue
        end if
        // Keep owner mpuid synchronized to chosen registry key so fallback path cannot flip ids.
        if _DNet_ToInt(owner.mpuid, 0) != key then owner.mpuid = key end if
        idx = _DNet_MPHostFindActorIndex(key)
        if idx < 0 then
          // Keep replicated actor id stable by deriving it directly from the actor key.
          aid = key
          if aid <= 0 then aid = 1 end if
          freeIdx = _DNet_MPHostFindFreeActorSlot()
          if freeIdx >= 0 then
            idx = freeIdx
            _dnet_mp_host_actor_ids[idx] = aid
            _dnet_mp_host_actor_nodes[idx] = key
            _dnet_mp_host_actor_refs[idx] = owner
            if idx < len(_dnet_mp_host_last_actor_sig) then _dnet_mp_host_last_actor_sig[idx] = 0 end if
            if idx < len(_dnet_mp_host_actor_miss) then _dnet_mp_host_actor_miss[idx] = 0 end if
            if idx < len(seen) then seen[idx] = 1 end if
          else
            _dnet_mp_host_actor_ids = _dnet_mp_host_actor_ids + [aid]
            _dnet_mp_host_actor_nodes = _dnet_mp_host_actor_nodes + [key]
            _dnet_mp_host_actor_refs = _dnet_mp_host_actor_refs + [owner]
            _dnet_mp_host_last_actor_sig = _dnet_mp_host_last_actor_sig + [0]
            _dnet_mp_host_actor_miss = _dnet_mp_host_actor_miss + [0]
            // New rows may extend past current seen-buffer length this tick.
            // They are treated as seen in the cleanup pass below.
          end if
        else
          _dnet_mp_host_actor_nodes[idx] = key
          _dnet_mp_host_actor_refs[idx] = owner
          if idx < len(_dnet_mp_host_actor_miss) then _dnet_mp_host_actor_miss[idx] = 0 end if
          if idx < len(seen) then seen[idx] = 1 end if
        end if
      end if
    end if
    cur = nxt
    guard = guard + 1
  end while

  activeCount = 0
  i = 0
  while i < len(_dnet_mp_host_actor_ids) and i < len(_dnet_mp_host_actor_nodes) and i < len(_dnet_mp_host_actor_refs)
    idv = _DNet_ToInt(_dnet_mp_host_actor_ids[i], 0)
    ref = _dnet_mp_host_actor_refs[i]
    wasSeen = true
    if i < len(seen) then wasSeen = (seen[i] != 0) end if
    if idv > 0 then
      if wasSeen and _DNet_MPActorUsable(ref) then
        if i < len(_dnet_mp_host_actor_miss) then _dnet_mp_host_actor_miss[i] = 0 end if
      else
        miss = 1
        if i < len(_dnet_mp_host_actor_miss) then
          miss = _DNet_ToInt(_dnet_mp_host_actor_miss[i], 0) + 1
          _dnet_mp_host_actor_miss[i] = miss
        end if
        // Avoid transient resolver gaps causing remove/recreate id churn.
        if miss > 8 then
          _DNet_MPHostQueueRemovedId(idv)
          _dnet_mp_host_actor_ids[i] = 0
          _dnet_mp_host_actor_nodes[i] = 0
          _dnet_mp_host_actor_refs[i] = 0
          if i < len(_dnet_mp_host_last_actor_sig) then _dnet_mp_host_last_actor_sig[i] = 0 end if
          if i < len(_dnet_mp_host_actor_miss) then _dnet_mp_host_actor_miss[i] = 0 end if
        end if
      end if
      if _DNet_ToInt(_dnet_mp_host_actor_ids[i], 0) > 0 then activeCount = activeCount + 1 end if
    end if
    i = i + 1
  end while
  _dnet_mp_host_actor_active_count = activeCount

  totalRows = len(_dnet_mp_host_actor_ids)
  holes = totalRows - activeCount
  if activeCount <= 0 and totalRows > 0 then
    _dnet_mp_host_actor_ids = []
    _dnet_mp_host_actor_nodes = []
    _dnet_mp_host_actor_refs = []
    _dnet_mp_host_last_actor_sig = []
    _dnet_mp_host_actor_miss = []
    _dnet_mp_host_actor_cursor = 0
    return
  end if

  // Keep host registry bounded: transients (missiles/puffs) create churn and would otherwise
  // leave tombstone rows forever, slowing every host tick over long sessions.
  if totalRows > 1024 and holes > 256 and holes * 2 > totalRows then
    compactIds = array(activeCount, 0)
    compactNodes = array(activeCount, 0)
    compactRefs = array(activeCount)
    compactSig = array(activeCount, 0)
    compactMiss = array(activeCount, 0)
    dst = 0
    i = 0
    while i < totalRows and dst < activeCount
      idv = _DNet_ToInt(_dnet_mp_host_actor_ids[i], 0)
      if idv > 0 then
        compactIds[dst] = idv
        if i < len(_dnet_mp_host_actor_nodes) then compactNodes[dst] = _DNet_ToInt(_dnet_mp_host_actor_nodes[i], 0) end if
        if i < len(_dnet_mp_host_actor_refs) then compactRefs[dst] = _dnet_mp_host_actor_refs[i] end if
        if i < len(_dnet_mp_host_last_actor_sig) then compactSig[dst] = _DNet_ToInt(_dnet_mp_host_last_actor_sig[i], 0) end if
        if i < len(_dnet_mp_host_actor_miss) then compactMiss[dst] = _DNet_ToInt(_dnet_mp_host_actor_miss[i], 0) end if
        dst = dst + 1
      end if
      i = i + 1
    end while
    _dnet_mp_host_actor_ids = compactIds
    _dnet_mp_host_actor_nodes = compactNodes
    _dnet_mp_host_actor_refs = compactRefs
    _dnet_mp_host_last_actor_sig = compactSig
    _dnet_mp_host_actor_miss = compactMiss
    if _dnet_mp_host_actor_cursor >= len(_dnet_mp_host_actor_ids) then _dnet_mp_host_actor_cursor = 0 end if
  end if
end function

/// Returns rotating subset of changed host actors for snapshot payloads.
/// @param maxCount Number of max to process.
/// @param forceAll Force all value supplied to `_DNet_MPHostCollectActorChunk`.
/// @param snapshotTick Snapshot tick value supplied to `_DNet_MPHostCollectActorChunk`.
/// @internal
function _DNet_MPHostCollectActorChunk(maxCount, forceAll, snapshotTick)
  global _dnet_mp_host_actor_cursor
  global _dnet_mp_host_last_actor_sig
  global _dnet_mp_host_actor_miss
  prioIds = []
  prioRefs = []
  outIds = []
  outRefs = []
  if maxCount <= 0 then return [outIds, outRefs] end if

  total = len(_dnet_mp_host_actor_ids)
  if total <= 0 then
    _dnet_mp_host_actor_cursor = 0
    return [outIds, outRefs]
  end if

  cursor = _DNet_ToInt(_dnet_mp_host_actor_cursor, 0)
  if cursor < 0 then cursor = 0 end if
  if cursor >= total then cursor = 0 end if
  take = maxCount
  if take > total then take = total end if
  prioIds = array(take, 0)
  prioRefs = array(take)
  outIds = array(take, 0)
  outRefs = array(take)
  prioCount = 0
  outCount = 0
  scanBudget = total
  if not forceAll then
    scanBudget = maxCount * _DNET_MP_ACTOR_CANDIDATE_MULTIPLIER
    if scanBudget < maxCount then scanBudget = maxCount end if
    if scanBudget > total then scanBudget = total end if
  end if

  scanned = 0
  while scanned < scanBudget and (prioCount + outCount) < take
    src = (cursor + scanned) % total
    idv = _DNet_ToInt(_dnet_mp_host_actor_ids[src], 0)
    if idv > 0 then
      miss = 0
      if _DNet_IsSeq(_dnet_mp_host_actor_miss) and src < len(_dnet_mp_host_actor_miss) then
        miss = _DNet_ToInt(_dnet_mp_host_actor_miss[src], 0)
      end if
      ref = _dnet_mp_host_actor_refs[src]
      if miss == 0 and _DNet_MPActorUsable(ref) then
        key = _DNet_MPActorStateKey(ref)
        prevKey = 0
        if src < len(_dnet_mp_host_last_actor_sig) then
          prevKey = _DNet_ToInt(_dnet_mp_host_last_actor_sig[src], 0)
        end if
        changed = prevKey != key
        if forceAll and(not changed) then
          // Full snapshots (especially right after join) must stream static actors immediately.
          changed = true
        else if(not changed) and(not forceAll) and _DNet_MPActorIsStaticForSync(ref) and _DNet_MPStaticActorHeartbeatHit(idv, snapshotTick) then
          // Re-publish stable pickups/corpses/decor periodically so clients that missed initial burst can recover.
          changed = true
        end if
        if changed then
          isPriority = false
          if (_DNet_ToInt(ref.flags, 0) & mobjflag_t.MF_MISSILE) != 0 then isPriority = true end if
          if isPriority then
            if prioCount < take then
              prioIds[prioCount] = idv
              prioRefs[prioCount] = ref
              prioCount = prioCount + 1
            end if
          else
            if outCount < take then
              outIds[outCount] = idv
              outRefs[outCount] = ref
              outCount = outCount + 1
            end if
          end if
          if src < len(_dnet_mp_host_last_actor_sig) then
            _dnet_mp_host_last_actor_sig[src] = key
          end if
        end if
      end if
    end if
    scanned = scanned + 1
  end while

  step = scanned
  if forceAll then
    // During full-sync bursts we must rotate through the full registry window,
    // otherwise the same leading chunk keeps repeating and static actors never arrive.
    step = take
    if step < 1 then step = 1 end if
  end if
  _dnet_mp_host_actor_cursor = (cursor + step) % total
  mergedCount = prioCount + outCount
  if mergedCount > take then mergedCount = take end if
  mergedIds = array(mergedCount, 0)
  mergedRefs = array(mergedCount)
  m = 0
  i = 0
  while i < prioCount and m < mergedCount
    mergedIds[m] = prioIds[i]
    mergedRefs[m] = prioRefs[i]
    m = m + 1
    i = i + 1
  end while
  i = 0
  while i < outCount and m < mergedCount
    mergedIds[m] = outIds[i]
    mergedRefs[m] = outRefs[i]
    m = m + 1
    i = i + 1
  end while
  return [mergedIds, mergedRefs]
end function

/// Forces one host actor id to be considered dirty for next snapshot selection.
/// @param aid Aid value supplied to `_DNet_MPHostInvalidateActorSigById`.
/// @internal
function inline _DNet_MPHostInvalidateActorSigById(aid)
  global _dnet_mp_host_actor_ids
  global _dnet_mp_host_last_actor_sig
  if aid <= 0 then return end if
  i = 0
  while i < len(_dnet_mp_host_actor_ids) and i < len(_dnet_mp_host_last_actor_sig)
    if _DNet_ToInt(_dnet_mp_host_actor_ids[i], 0) == aid then
      _dnet_mp_host_last_actor_sig[i] = 0
      return
    end if
    i = i + 1
  end while
end function

/// Re-queues actor rows trimmed by packet budget so they are retried next snapshots.
/// @param actorIds Actor ids value supplied to `_DNet_MPHostRequeueDroppedActorRows`.
/// @param startIdx Start idx value supplied to `_DNet_MPHostRequeueDroppedActorRows`.
/// @internal
function _DNet_MPHostRequeueDroppedActorRows(actorIds, startIdx)
  if not _DNet_IsSeq(actorIds) then return end if
  start = _DNet_ToInt(startIdx, 0)
  if start < 0 then start = 0 end if
  i = start
  while i < len(actorIds)
    aid = _DNet_ToInt(actorIds[i], 0)
    if aid > 0 then _DNet_MPHostInvalidateActorSigById(aid) end if
    i = i + 1
  end while
end function

/// Prioritizes client-relevant actor updates over non-relevant updates for one target slot.
/// @param slot Slot value supplied to `_DNet_MPHostSelectActorsForSlot`.
/// @param actorIds Actor ids value supplied to `_DNet_MPHostSelectActorsForSlot`.
/// @param actorRefs Actor refs value supplied to `_DNet_MPHostSelectActorsForSlot`.
/// @param maxCount Number of max to process.
/// @param forceAll Force all value supplied to `_DNet_MPHostSelectActorsForSlot`.
/// @param snapshotTick Snapshot tick value supplied to `_DNet_MPHostSelectActorsForSlot`.
/// @internal
function _DNet_MPHostSelectActorsForSlot(slot, actorIds, actorRefs, maxCount, forceAll, snapshotTick)
  nearIds = []
  nearRefs = []
  farIds = []
  farRefs = []
  outIds = []
  outRefs = []
  take = _DNet_ToInt(maxCount, 0)
  if take <= 0 then return [outIds, outRefs] end if
  if not _DNet_IsSeq(actorIds) or not _DNet_IsSeq(actorRefs) then return [outIds, outRefs] end if

  total = len(actorIds)
  if len(actorRefs) < total then total = len(actorRefs) end if
  nearIds = array(total, 0)
  nearRefs = array(total)
  farIds = array(total, 0)
  farRefs = array(total)
  nearCount = 0
  farCount = 0

  i = 0
  while i < total
    mo = actorRefs[i]
    if _DNet_MPHostActorRelevantForSlot(slot, mo) then
      nearIds[nearCount] = actorIds[i]
      nearRefs[nearCount] = mo
      nearCount = nearCount + 1
    else
      farIds[farCount] = actorIds[i]
      farRefs[farCount] = mo
      farCount = farCount + 1
    end if
    i = i + 1
  end while

  outCap = take
  if total < outCap then outCap = total end if
  outIds = array(outCap, 0)
  outRefs = array(outCap)
  outCount = 0
  if nearCount > 0 then
    nearStart = (_DNet_ToInt(snapshotTick, 0) + _DNet_ToInt(slot, 0)) % nearCount
    i = 0
    while i < nearCount and outCount < outCap
      idx = (nearStart + i) % nearCount
      outIds[outCount] = nearIds[idx]
      outRefs[outCount] = nearRefs[idx]
      outCount = outCount + 1
      i = i + 1
    end while
  end if

  left = outCap - outCount
  if left > 0 and farCount > 0 then
    farQuota = left
    if not forceAll then
      // Keep most bandwidth for visible/relevant actors.
      farQuota = _DNet_IDiv(take, 4)
      if farQuota < 1 then farQuota = 1 end if
      if farQuota > left then farQuota = left end if
    end if
    start = (_DNet_ToInt(snapshotTick, 0) + _DNet_ToInt(slot, 0)) % farCount
    j = 0
    while j < farQuota and j < farCount and outCount < outCap
      idx = (start + j) % farCount
      outIds[outCount] = farIds[idx]
      outRefs[outCount] = farRefs[idx]
      outCount = outCount + 1
      j = j + 1
    end while
  end if

  if outCount == outCap then return [outIds, outRefs] end if
  trimmedIds = array(outCount, 0)
  trimmedRefs = array(outCount)
  i = 0
  while i < outCount
    trimmedIds[i] = outIds[i]
    trimmedRefs[i] = outRefs[i]
    i = i + 1
  end while
  return [trimmedIds, trimmedRefs]
end function

/// Returns and removes removed actor ids for snapshot notification.
/// @param maxCount Number of max to process.
/// @internal
function _DNet_MPHostPopRemovedIds(maxCount)
  global _dnet_mp_host_removed_ids
  removed = []
  if maxCount <= 0 then return removed end if
  if not _DNet_IsSeq(_dnet_mp_host_removed_ids) then return removed end if

  total = len(_dnet_mp_host_removed_ids)
  if total <= 0 then return removed end if
  take = maxCount
  if take > total then take = total end if
  removed = array(take, 0)
  keep = array(total, 0)
  removedUsed = 0
  keepUsed = 0
  i = 0
  while i < total
    rid = _DNet_ToInt(_dnet_mp_host_removed_ids[i], 0)
    alreadyEmitted = false
    j = 0
    while j < removedUsed
      if _DNet_ToInt(removed[j], 0) == rid then
        alreadyEmitted = true
        break
      end if
      j = j + 1
    end while
    // At most one copy of an id belongs in a datagram. Remaining copies stay
    // queued so the removal is repeated in later UDP snapshots.
    if rid > 0 and (not alreadyEmitted) and removedUsed < take then
      removed[removedUsed] = rid
      removedUsed = removedUsed + 1
    else if rid > 0 then
      keep[keepUsed] = rid
      keepUsed = keepUsed + 1
    end if
    i = i + 1
  end while

  trimmedRemoved = array(removedUsed, 0)
  i = 0
  while i < removedUsed
    trimmedRemoved[i] = removed[i]
    i = i + 1
  end while
  trimmedKeep = array(keepUsed, 0)
  i = 0
  while i < keepUsed
    trimmedKeep[i] = keep[i]
    i = i + 1
  end while
  _dnet_mp_host_removed_ids = trimmedKeep
  return trimmedRemoved
end function

/// Initializes host-side sector cache used for delta snapshots.
/// @internal
function _DNet_MPHostEnsureSectorCache()
  global _dnet_mp_host_last_sector_floor
  global _dnet_mp_host_last_sector_ceiling
  global _dnet_mp_host_last_sector_light
  global _dnet_mp_host_last_sector_special
  global _dnet_mp_host_sector_cursor

  n = _DNet_ToInt(numsectors, 0)
  if n < 0 then n = 0 end if
  if n == 0 or typeof(sectors) != "array" then
    _dnet_mp_host_last_sector_floor = []
    _dnet_mp_host_last_sector_ceiling = []
    _dnet_mp_host_last_sector_light = []
    _dnet_mp_host_last_sector_special = []
    _dnet_mp_host_sector_cursor = 0
    return
  end if

  if len(_dnet_mp_host_last_sector_floor) == n and len(_dnet_mp_host_last_sector_ceiling) == n and len(_dnet_mp_host_last_sector_light) == n and len(_dnet_mp_host_last_sector_special) == n then
    return
  end if

  _dnet_mp_host_last_sector_floor = array(n, 0)
  _dnet_mp_host_last_sector_ceiling = array(n, 0)
  _dnet_mp_host_last_sector_light = array(n, 0)
  _dnet_mp_host_last_sector_special = array(n, 0)
  i = 0
  while i < n and i < len(sectors)
    sec = sectors[i]
    _dnet_mp_host_last_sector_floor[i] = _DNet_ToInt(sec.floorheight, 0)
    _dnet_mp_host_last_sector_ceiling[i] = _DNet_ToInt(sec.ceilingheight, 0)
    _dnet_mp_host_last_sector_light[i] = _DNet_ToInt(sec.lightlevel, 0)
    _dnet_mp_host_last_sector_special[i] = _DNet_ToInt(sec.special, 0)
    i = i + 1
  end while
  _dnet_mp_host_sector_cursor = 0
end function

/// Collects a rotating subset of changed sector dynamics for snapshots.
/// @param maxCount Number of max to process.
/// @param forceAll Force all value supplied to `_DNet_MPHostCollectSectorChanges`.
/// @internal
function _DNet_MPHostCollectSectorChanges(maxCount, forceAll)
  global _dnet_mp_host_sector_cursor
  rows = []
  rowCount = 0
  if maxCount <= 0 then return rows end if
  if typeof(sectors) != "array" then return rows end if
  _DNet_MPHostEnsureSectorCache()

  n = _DNet_ToInt(numsectors, 0)
  if n <= 0 then n = len(sectors) end if
  if n > len(sectors) then n = len(sectors) end if
  if n <= 0 then return rows end if

  cursor = _DNet_ToInt(_dnet_mp_host_sector_cursor, 0)
  if cursor < 0 then cursor = 0 end if
  if cursor >= n then cursor = 0 end if

  scanLimit = maxCount * 8
  if forceAll then scanLimit = n end if
  if scanLimit < maxCount then scanLimit = maxCount end if
  if scanLimit > n then scanLimit = n end if
  rowsCap = maxCount
  if rowsCap > scanLimit then rowsCap = scanLimit end if
  if rowsCap < 0 then rowsCap = 0 end if
  rows = array(rowsCap)

  scanned = 0
  i = cursor
  while scanned < scanLimit and rowCount < maxCount
    sec = sectors[i]
    f = _DNet_ToInt(sec.floorheight, 0)
    c = _DNet_ToInt(sec.ceilingheight, 0)
    l = _DNet_ToInt(sec.lightlevel, 0)
    sp = _DNet_ToInt(sec.special, 0)

    changed = forceAll
    if not changed then
      if i >= len(_dnet_mp_host_last_sector_floor) then
        changed = true
      else if _dnet_mp_host_last_sector_floor[i] != f or _dnet_mp_host_last_sector_ceiling[i] != c or _dnet_mp_host_last_sector_light[i] != l or _dnet_mp_host_last_sector_special[i] != sp then
        changed = true
      end if
    end if

    if changed then
      if rowCount < len(rows) then
        rows[rowCount] = [i, f, c, l, sp]
        rowCount = rowCount + 1
      end if
      _dnet_mp_host_last_sector_floor[i] = f
      _dnet_mp_host_last_sector_ceiling[i] = c
      _dnet_mp_host_last_sector_light[i] = l
      _dnet_mp_host_last_sector_special[i] = sp
    end if

    i = i + 1
    if i >= n then i = 0 end if
    scanned = scanned + 1
  end while
  _dnet_mp_host_sector_cursor = i
  if rowCount < len(rows) then
    trimmed = array(rowCount)
    j = 0
    while j < rowCount
      trimmed[j] = rows[j]
      j = j + 1
    end while
    rows = trimmed
  end if
  return rows
end function

/// Initializes host-side sidedef texture cache used for switch and wall texture replication.
/// @internal
function _DNet_MPHostEnsureSideCache()
  global _dnet_mp_host_last_side_top
  global _dnet_mp_host_last_side_bottom
  global _dnet_mp_host_last_side_mid
  global _dnet_mp_host_side_cursor

  n = _DNet_ToInt(numsides, 0)
  if n < 0 then n = 0 end if
  if n == 0 or typeof(sides) != "array" then
    _dnet_mp_host_last_side_top = []
    _dnet_mp_host_last_side_bottom = []
    _dnet_mp_host_last_side_mid = []
    _dnet_mp_host_side_cursor = 0
    return
  end if
  if n > len(sides) then n = len(sides) end if

  if len(_dnet_mp_host_last_side_top) == n and len(_dnet_mp_host_last_side_bottom) == n and len(_dnet_mp_host_last_side_mid) == n then
    return
  end if

  _dnet_mp_host_last_side_top = array(n, 0)
  _dnet_mp_host_last_side_bottom = array(n, 0)
  _dnet_mp_host_last_side_mid = array(n, 0)
  i = 0
  while i < n
    sd = sides[i]
    _dnet_mp_host_last_side_top[i] = _DNet_ToInt(sd.toptexture, 0)
    _dnet_mp_host_last_side_bottom[i] = _DNet_ToInt(sd.bottomtexture, 0)
    _dnet_mp_host_last_side_mid[i] = _DNet_ToInt(sd.midtexture, 0)
    i = i + 1
  end while
  _dnet_mp_host_side_cursor = 0
end function

/// Collects changed sidedef textures so clients see switch/button state transitions.
/// @param maxCount Number of max to process.
/// @param forceAll Force all value supplied to `_DNet_MPHostCollectSideChanges`.
/// @internal
function _DNet_MPHostCollectSideChanges(maxCount, forceAll)
  global _dnet_mp_host_side_cursor
  rows = []
  rowCount = 0
  if maxCount <= 0 then return rows end if
  if typeof(sides) != "array" then return rows end if
  _DNet_MPHostEnsureSideCache()

  n = _DNet_ToInt(numsides, 0)
  if n <= 0 then n = len(sides) end if
  if n > len(sides) then n = len(sides) end if
  if n <= 0 then return rows end if

  cursor = _DNet_ToInt(_dnet_mp_host_side_cursor, 0)
  if cursor < 0 then cursor = 0 end if
  if cursor >= n then cursor = 0 end if

  scanLimit = maxCount * 8
  if forceAll then scanLimit = n end if
  if scanLimit < maxCount then scanLimit = maxCount end if
  if scanLimit > n then scanLimit = n end if
  rowsCap = maxCount
  if rowsCap > scanLimit then rowsCap = scanLimit end if
  if rowsCap < 0 then rowsCap = 0 end if
  rows = array(rowsCap)

  scanned = 0
  i = cursor
  while scanned < scanLimit and rowCount < maxCount
    sd = sides[i]
    tt = _DNet_ToInt(sd.toptexture, 0)
    bt = _DNet_ToInt(sd.bottomtexture, 0)
    mt = _DNet_ToInt(sd.midtexture, 0)

    changed = forceAll
    if not changed then
      if i >= len(_dnet_mp_host_last_side_top) then
        changed = true
      else if _dnet_mp_host_last_side_top[i] != tt or _dnet_mp_host_last_side_bottom[i] != bt or _dnet_mp_host_last_side_mid[i] != mt then
        changed = true
      end if
    end if

    if changed then
      if rowCount < len(rows) then
        rows[rowCount] = [i, tt, bt, mt]
        rowCount = rowCount + 1
      end if
      _dnet_mp_host_last_side_top[i] = tt
      _dnet_mp_host_last_side_bottom[i] = bt
      _dnet_mp_host_last_side_mid[i] = mt
    end if

    i = i + 1
    if i >= n then i = 0 end if
    scanned = scanned + 1
  end while
  _dnet_mp_host_side_cursor = i
  if rowCount < len(rows) then
    trimmed = array(rowCount)
    j = 0
    while j < rowCount
      trimmed[j] = rows[j]
      j = j + 1
    end while
    rows = trimmed
  end if
  return rows
end function

/// Ensures player slot contains a valid player struct.
/// @param slot Slot value supplied to `_DNet_MPEnsurePlayerStruct`.
/// @internal
function inline _DNet_MPEnsurePlayerStruct(slot)
  if slot < 0 or slot >= MAXPLAYERS then return void end if
  if not _DNet_IsSeq(players) or slot >= len(players) then return void end if
  p = players[slot]
  if typeof(p) != "struct" then
    p = Player_MakeDefault()
    players[slot] = p
  end if
  return p
end function

/// Returns true if a player struct already carries any weapon ownership flag.
/// @param p Object or data record consumed by the operation.
/// @internal
function inline _DNet_MPPlayerHasAnyOwnedWeapon(p)
  if typeof(p) != "struct" then return false end if
  if not _DNet_IsSeq(p.weaponowned) then return false end if
  wi = 0
  while wi < NUMWEAPONS and wi < len(p.weaponowned)
    if p.weaponowned[wi] then return true end if
    wi = wi + 1
  end while
  return false
end function

/// Schedules an immediate full-snapshot burst for a newly active remote slot.
/// @param slot Slot value supplied to `_DNet_MPHostMarkSlotFullsync`.
/// @internal
function inline _DNet_MPHostMarkSlotFullsync(slot)
  global _dnet_mp_host_slot_fullsync_burst
  s = _DNet_ToInt(slot, -1)
  if s <= 0 or s >= MAXPLAYERS then return end if
  if len(_dnet_mp_host_slot_fullsync_burst) < MAXPLAYERS then
    _dnet_mp_host_slot_fullsync_burst = _dnet_mp_host_slot_fullsync_burst + array(MAXPLAYERS - len(_dnet_mp_host_slot_fullsync_burst), 0)
  end if
  _dnet_mp_host_slot_fullsync_burst[s] = _DNET_MP_JOIN_FULLSYNC_BURST_TICS
end function

/// Toggles slot active state and removes stale mobjs on deactivate.
/// @param slot Slot value supplied to `_DNet_MPSetPlayerSlotActive`.
/// @param active Whether the requested state should be active.
/// @internal
function _DNet_MPSetPlayerSlotActive(slot, active)
  global _dnet_mp_remote_cmds
  global _dnet_mp_remote_cmd_valid
  global _dnet_mp_remote_cmd_tic
  global _dnet_mp_remote_input_last_seq
  global _dnet_mp_host_slot_fullsync_burst
  if slot < 0 or slot >= MAXPLAYERS then return end if
  if _DNet_IsSeq(playeringame) and slot < len(playeringame) then
    playeringame[slot] = active
  end if
  if not active then
    if _DNet_IsSeq(_dnet_mp_remote_cmds) and slot < len(_dnet_mp_remote_cmds) then
      _dnet_mp_remote_cmds[slot] = ticcmd_t(0, 0, 0, 0, 0, 0)
    end if
    if _DNet_IsSeq(_dnet_mp_remote_cmd_valid) and slot < len(_dnet_mp_remote_cmd_valid) then
      _dnet_mp_remote_cmd_valid[slot] = false
    end if
    if _DNet_IsSeq(_dnet_mp_remote_cmd_tic) and slot < len(_dnet_mp_remote_cmd_tic) then
      _dnet_mp_remote_cmd_tic[slot] = 0
    end if
    if _DNet_IsSeq(_dnet_mp_remote_input_last_seq) and slot < len(_dnet_mp_remote_input_last_seq) then
      _dnet_mp_remote_input_last_seq[slot] = -1
    end if
    if _DNet_IsSeq(_dnet_mp_host_slot_fullsync_burst) and slot < len(_dnet_mp_host_slot_fullsync_burst) then
      _dnet_mp_host_slot_fullsync_burst[slot] = 0
    end if
    if _DNet_MPIsClient() then
      _DNet_MPClientResetPlayerMotionSlot(slot)
    end if
  end if
  if (not active) and _DNet_IsSeq(players) and slot < len(players) then
    p = players[slot]
    if typeof(p) == "struct" and p.mo is not void and typeof(P_RemoveMobj) == "function" then
      P_RemoveMobj(p.mo)
    end if
    players[slot] = Player_MakeDefault()
  end if
end function

/// Finds client-side actor proxy registry index by replicated id.
/// @param idv Idv value supplied to `_DNet_MPClientFindActorIndex`.
/// @internal
function inline _DNet_MPClientFindActorIndex(idv)
  i = 0
  while i < len(_dnet_mp_client_actor_ids)
    if _DNet_ToInt(_dnet_mp_client_actor_ids[i], 0) == idv then return i end if
    i = i + 1
  end while
  return -1
end function

/// Finds a client actor proxy whose local mobj mpuid already matches replicated actor id.
/// @param aid Aid value supplied to `_DNet_MPClientFindActorByUidField`.
/// @internal
function inline _DNet_MPClientFindActorByUidField(aid)
  i = 0
  while i < len(_dnet_mp_client_actor_refs)
    mo = _dnet_mp_client_actor_refs[i]
    if typeof(mo) == "struct" and _DNet_ToInt(mo.mpuid, 0) == aid then
      return i
    end if
    i = i + 1
  end while
  return -1
end function

/// Returns reusable client registry slot whose actor id was cleared.
/// @internal
function inline _DNet_MPClientFindFreeActorSlot()
  i = 0
  while i < len(_dnet_mp_client_actor_ids) and i < len(_dnet_mp_client_actor_refs)
    if _DNet_ToInt(_dnet_mp_client_actor_ids[i], 0) <= 0 then return i end if
    ref = _dnet_mp_client_actor_refs[i]
    if typeof(ref) != "struct" then return i end if
    i = i + 1
  end while
  return -1
end function

/// Returns sign of integer value (-1, 0, +1).
/// @param v Value consumed by the operation.
/// @internal
function inline _DNet_MPSign32(v)
  if v < 0 then return -1 end if
  if v > 0 then return 1 end if
  return 0
end function

/// Returns shortest signed angular delta (to-from) in Doom angle space.
/// @param toAng To ang value supplied to `_DNet_MPAngleDeltaSigned`.
/// @param fromAng From ang value supplied to `_DNet_MPAngleDeltaSigned`.
/// @internal
function inline _DNet_MPAngleDeltaSigned(toAng, fromAng)
  d = _DNet_ToInt(toAng, 0) - _DNet_ToInt(fromAng, 0)
  if d > 2147483647 then d = d - 4294967296 end if
  if d < -2147483648 then d = d + 4294967296 end if
  return d
end function

/// Clamps value into [-limit, +limit].
/// @param v Value consumed by the operation.
/// @param limit Limit value supplied to `_DNet_MPClampAbs`.
/// @internal
function inline _DNet_MPClampAbs(v, limit)
  lim = _DNet_ToInt(limit, 0)
  if lim < 0 then lim = -lim end if
  if lim <= 0 then return 0 end if
  vv = _DNet_ToInt(v, 0)
  if vv > lim then return lim end if
  if vv < -lim then return -lim end if
  return vv
end function

/// Ensures client-side actor smoothing arrays have capacity for one slot index.
/// @param idx Zero-based element or table index.
/// @internal
function inline _DNet_MPClientEnsureActorMotionSlot(idx)
  global _dnet_mp_client_actor_tx
  global _dnet_mp_client_actor_ty
  global _dnet_mp_client_actor_tz
  global _dnet_mp_client_actor_tang
  global _dnet_mp_client_actor_vx
  global _dnet_mp_client_actor_vy
  global _dnet_mp_client_actor_vz
  global _dnet_mp_client_actor_last_snap_tic
  global _dnet_mp_client_actor_kind
  if idx < 0 then return end if
  need = idx + 1
  cur = len(_dnet_mp_client_actor_tx)
  if cur >= need then return end if
  grow = need - cur
  ext = array(grow, 0)
  _dnet_mp_client_actor_tx = _dnet_mp_client_actor_tx + ext
  _dnet_mp_client_actor_ty = _dnet_mp_client_actor_ty + ext
  _dnet_mp_client_actor_tz = _dnet_mp_client_actor_tz + ext
  _dnet_mp_client_actor_tang = _dnet_mp_client_actor_tang + ext
  _dnet_mp_client_actor_vx = _dnet_mp_client_actor_vx + ext
  _dnet_mp_client_actor_vy = _dnet_mp_client_actor_vy + ext
  _dnet_mp_client_actor_vz = _dnet_mp_client_actor_vz + ext
  _dnet_mp_client_actor_last_snap_tic = _dnet_mp_client_actor_last_snap_tic + ext
  _dnet_mp_client_actor_kind = _dnet_mp_client_actor_kind + ext
end function

/// Ensures client-side remote player smoothing arrays are sized for MAXPLAYERS.
/// @internal
function inline _DNet_MPClientEnsurePlayerMotionSlots()
  global _dnet_mp_client_player_tx
  global _dnet_mp_client_player_ty
  global _dnet_mp_client_player_tz
  global _dnet_mp_client_player_tang
  global _dnet_mp_client_player_vx
  global _dnet_mp_client_player_vy
  global _dnet_mp_client_player_vz
  global _dnet_mp_client_player_last_snap_tic
  cur = len(_dnet_mp_client_player_tx)
  if cur >= MAXPLAYERS then return end if
  grow = MAXPLAYERS - cur
  ext = array(grow, 0)
  _dnet_mp_client_player_tx = _dnet_mp_client_player_tx + ext
  _dnet_mp_client_player_ty = _dnet_mp_client_player_ty + ext
  _dnet_mp_client_player_tz = _dnet_mp_client_player_tz + ext
  _dnet_mp_client_player_tang = _dnet_mp_client_player_tang + ext
  _dnet_mp_client_player_vx = _dnet_mp_client_player_vx + ext
  _dnet_mp_client_player_vy = _dnet_mp_client_player_vy + ext
  _dnet_mp_client_player_vz = _dnet_mp_client_player_vz + ext
  _dnet_mp_client_player_last_snap_tic = _dnet_mp_client_player_last_snap_tic + ext
end function

/// Clears remote player smoothing state for one slot.
/// @param slot Slot value supplied to `_DNet_MPClientResetPlayerMotionSlot`.
/// @internal
function inline _DNet_MPClientResetPlayerMotionSlot(slot)
  _DNet_MPClientEnsurePlayerMotionSlots()
  s = _DNet_ToInt(slot, -1)
  if s < 0 or s >= MAXPLAYERS then return end if
  _dnet_mp_client_player_tx[s] = 0
  _dnet_mp_client_player_ty[s] = 0
  _dnet_mp_client_player_tz[s] = 0
  _dnet_mp_client_player_tang[s] = 0
  _dnet_mp_client_player_vx[s] = 0
  _dnet_mp_client_player_vy[s] = 0
  _dnet_mp_client_player_vz[s] = 0
  _dnet_mp_client_player_last_snap_tic[s] = 0
end function

/// Stores remote player target pose and velocity estimate from authoritative snapshots.
/// @param slot Slot value supplied to `_DNet_MPClientTrackPlayerSnapshot`.
/// @param px Horizontal coordinate or vector component represented by px.
/// @param py Vertical coordinate or vector component represented by py.
/// @param pz Pz value supplied to `_DNet_MPClientTrackPlayerSnapshot`.
/// @param pang Pang value supplied to `_DNet_MPClientTrackPlayerSnapshot`.
/// @param snapTick Snap tick value supplied to `_DNet_MPClientTrackPlayerSnapshot`.
/// @param hardSnap Hard snap value supplied to `_DNet_MPClientTrackPlayerSnapshot`.
/// @internal
function _DNet_MPClientTrackPlayerSnapshot(slot, px, py, pz, pang, snapTick, hardSnap)
  _DNet_MPClientEnsurePlayerMotionSlots()
  s = _DNet_ToInt(slot, -1)
  if s < 0 or s >= MAXPLAYERS then return end if

  prevTick = _DNet_ToInt(_dnet_mp_client_player_last_snap_tic[s], 0)
  prevX = _DNet_ToInt(_dnet_mp_client_player_tx[s], px)
  prevY = _DNet_ToInt(_dnet_mp_client_player_ty[s], py)
  prevZ = _DNet_ToInt(_dnet_mp_client_player_tz[s], pz)
  if hardSnap then
    prevTick = 0
    prevX = px
    prevY = py
    prevZ = pz
  end if

  vx = 0
  vy = 0
  vz = 0
  dt = _DNet_ToInt(snapTick, 0) - prevTick
  if dt > 0 and prevTick > 0 then
    vx = _DNet_IDiv(px - prevX, dt)
    vy = _DNet_IDiv(py - prevY, dt)
    vz = _DNet_IDiv(pz - prevZ, dt)
    vx = _DNet_MPClampAbs(vx, _DNET_MP_CLIENT_EXTRAP_ABS_VEL_MAX_MOBILE)
    vy = _DNet_MPClampAbs(vy, _DNET_MP_CLIENT_EXTRAP_ABS_VEL_MAX_MOBILE)
    vz = _DNet_MPClampAbs(vz, _DNET_MP_CLIENT_EXTRAP_ABS_VEL_MAX_MOBILE)
  end if

  _dnet_mp_client_player_tx[s] = px
  _dnet_mp_client_player_ty[s] = py
  _dnet_mp_client_player_tz[s] = pz
  _dnet_mp_client_player_tang[s] = pang
  _dnet_mp_client_player_vx[s] = vx
  _dnet_mp_client_player_vy[s] = vy
  _dnet_mp_client_player_vz[s] = vz
  _dnet_mp_client_player_last_snap_tic[s] = _DNet_ToInt(snapTick, 0)
end function

/// Classifies actor replication behavior: 0 static, 1 mobile, 2 fast/effect (missile-like).
/// @param atype Atype value supplied to `_DNet_MPClientClassifyActor`.
/// @param flags Bit flags that control the operation.
/// @param mo Map object affected by the operation.
/// @internal
function inline _DNet_MPClientClassifyActor(atype, flags, mo)
  fl = _DNet_ToInt(flags, 0)
  if (fl & mobjflag_t.MF_MISSILE) != 0 then return 2 end if
  if typeof(mo) == "struct" and mo.player is not void then return 1 end if
  ty = _DNet_ToInt(atype, -1)
  if ty == mobjtype_t.MT_PUFF or ty == mobjtype_t.MT_BLOOD or ty == mobjtype_t.MT_SMOKE or ty == mobjtype_t.MT_TFOG or ty == mobjtype_t.MT_IFOG then
    return 2
  end if
  if (fl & mobjflag_t.MF_SPECIAL) != 0 then return 0 end if
  if (fl & mobjflag_t.MF_CORPSE) != 0 then return 0 end if
  if (fl & mobjflag_t.MF_COUNTKILL) == 0 and (fl & mobjflag_t.MF_SHOOTABLE) == 0 then return 0 end if
  return 1
end function

/// Stores target pose and velocity estimate for one replicated actor snapshot.
/// @param idx Zero-based element or table index.
/// @param mo Map object affected by the operation.
/// @param atype Atype value supplied to `_DNet_MPClientTrackActorSnapshot`.
/// @param afl Afl value supplied to `_DNet_MPClientTrackActorSnapshot`.
/// @param ax Horizontal coordinate or vector component represented by ax.
/// @param ay Vertical coordinate or vector component represented by ay.
/// @param az Az value supplied to `_DNet_MPClientTrackActorSnapshot`.
/// @param aang Aang value supplied to `_DNet_MPClientTrackActorSnapshot`.
/// @param snapTick Snap tick value supplied to `_DNet_MPClientTrackActorSnapshot`.
/// @param spawnedNow Spawned now value supplied to `_DNet_MPClientTrackActorSnapshot`.
/// @internal
function _DNet_MPClientTrackActorSnapshot(idx, mo, atype, afl, ax, ay, az, aang, snapTick, spawnedNow)
  global _dnet_mp_client_actor_tx
  global _dnet_mp_client_actor_ty
  global _dnet_mp_client_actor_tz
  global _dnet_mp_client_actor_tang
  global _dnet_mp_client_actor_vx
  global _dnet_mp_client_actor_vy
  global _dnet_mp_client_actor_vz
  global _dnet_mp_client_actor_last_snap_tic
  global _dnet_mp_client_actor_kind

  if idx < 0 then return end if
  _DNet_MPClientEnsureActorMotionSlot(idx)
  if idx >= len(_dnet_mp_client_actor_tx) then return end if

  prevTick = _DNet_ToInt(_dnet_mp_client_actor_last_snap_tic[idx], 0)
  prevX = _DNet_ToInt(_dnet_mp_client_actor_tx[idx], ax)
  prevY = _DNet_ToInt(_dnet_mp_client_actor_ty[idx], ay)
  prevZ = _DNet_ToInt(_dnet_mp_client_actor_tz[idx], az)
  if spawnedNow then
    prevTick = 0
    prevX = ax
    prevY = ay
    prevZ = az
  end if
  kind = _DNet_MPClientClassifyActor(atype, afl, mo)
  velLimit = 0
  if kind == 2 then
    velLimit = _DNET_MP_CLIENT_EXTRAP_ABS_VEL_MAX_MISSILE
  else if kind == 1 then
    velLimit = _DNET_MP_CLIENT_EXTRAP_ABS_VEL_MAX_MOBILE
  end if

  vx = 0
  vy = 0
  vz = 0
  dt = _DNet_ToInt(snapTick, 0) - prevTick
  if dt > 0 and prevTick > 0 then
    vx = _DNet_IDiv(ax - prevX, dt)
    vy = _DNet_IDiv(ay - prevY, dt)
    vz = _DNet_IDiv(az - prevZ, dt)
    if velLimit > 0 then
      vx = _DNet_MPClampAbs(vx, velLimit)
      vy = _DNet_MPClampAbs(vy, velLimit)
      vz = _DNet_MPClampAbs(vz, velLimit)
    else
      vx = 0
      vy = 0
      vz = 0
    end if
  end if

  _dnet_mp_client_actor_tx[idx] = ax
  _dnet_mp_client_actor_ty[idx] = ay
  _dnet_mp_client_actor_tz[idx] = az
  _dnet_mp_client_actor_tang[idx] = aang
  _dnet_mp_client_actor_vx[idx] = vx
  _dnet_mp_client_actor_vy[idx] = vy
  _dnet_mp_client_actor_vz[idx] = vz
  _dnet_mp_client_actor_last_snap_tic[idx] = _DNet_ToInt(snapTick, 0)
  _dnet_mp_client_actor_kind[idx] = kind
end function

/// Client-side actor smoothing using interpolation with bounded short extrapolation.
/// @internal
function _DNet_MPClientAdvanceActors()
  global _dnet_mp_client_actor_refs
  global _dnet_mp_client_actor_ids
  global _dnet_mp_client_actor_tx
  global _dnet_mp_client_actor_ty
  global _dnet_mp_client_actor_tz
  global _dnet_mp_client_actor_tang
  global _dnet_mp_client_actor_vx
  global _dnet_mp_client_actor_vy
  global _dnet_mp_client_actor_vz
  global _dnet_mp_client_actor_last_snap_tic
  global _dnet_mp_client_actor_kind
  global _dnet_mp_client_last_smooth_tic
  if not _DNet_MPIsClient() then return end if
  if gamestate != gamestate_t.GS_LEVEL then return end if

  nowtic = _DNet_ToInt(gametic, 0)
  if nowtic <= _DNet_ToInt(_dnet_mp_client_last_smooth_tic, -1) then return end if
  _dnet_mp_client_last_smooth_tic = nowtic
  i = 0
  while i < len(_dnet_mp_client_actor_ids) and i < len(_dnet_mp_client_actor_refs)
    idv = _DNet_ToInt(_dnet_mp_client_actor_ids[i], 0)
    mo = _dnet_mp_client_actor_refs[i]
    if idv > 0 and typeof(mo) == "struct" then
      _DNet_MPClientEnsureActorMotionSlot(i)
      if i < len(_dnet_mp_client_actor_tx) then
        tx = _DNet_ToInt(_dnet_mp_client_actor_tx[i], _DNet_ToInt(mo.x, 0))
        ty = _DNet_ToInt(_dnet_mp_client_actor_ty[i], _DNet_ToInt(mo.y, 0))
        tz = _DNet_ToInt(_dnet_mp_client_actor_tz[i], _DNet_ToInt(mo.z, 0))
        tang = _DNet_ToInt(_dnet_mp_client_actor_tang[i], _DNet_ToInt(mo.angle, 0))
        lt = _DNet_ToInt(_dnet_mp_client_actor_last_snap_tic[i], 0)
        kind = _DNet_ToInt(_dnet_mp_client_actor_kind[i], 0)
        if lt > 0 and nowtic > lt then
          miss = nowtic - lt
          extraMax = 0
          if kind == 2 then
            extraMax = _DNET_MP_CLIENT_MAX_EXTRAP_MISSILE
          else if kind == 1 then
            extraMax = _DNET_MP_CLIENT_MAX_EXTRAP_MOBILE
          end if
          if miss > 0 and miss <= extraMax then
            tx = tx + _DNet_ToInt(_dnet_mp_client_actor_vx[i], 0)
            ty = ty + _DNet_ToInt(_dnet_mp_client_actor_vy[i], 0)
            tz = tz + _DNet_ToInt(_dnet_mp_client_actor_vz[i], 0)
            _dnet_mp_client_actor_tx[i] = tx
            _dnet_mp_client_actor_ty[i] = ty
            _dnet_mp_client_actor_tz[i] = tz
          end if
        end if

        cx = _DNet_ToInt(mo.x, 0)
        cy = _DNet_ToInt(mo.y, 0)
        cz = _DNet_ToInt(mo.z, 0)
        dx = tx - cx
        dy = ty - cy
        dz = tz - cz

        hard = false
        if _DNet_MPAbs32(dx) > _DNET_MP_CLIENT_HARD_SNAP_DIST then hard = true end if
        if _DNet_MPAbs32(dy) > _DNET_MP_CLIENT_HARD_SNAP_DIST then hard = true end if
        if _DNet_MPAbs32(dz) > _DNET_MP_CLIENT_HARD_SNAP_DIST then hard = true end if

        nx = cx
        ny = cy
        nz = cz
        if hard then
          nx = tx
          ny = ty
          nz = tz
        else
          sx = _DNet_IDiv(dx * _DNET_MP_CLIENT_INTERP_NUM, _DNET_MP_CLIENT_INTERP_DEN)
          sy = _DNet_IDiv(dy * _DNET_MP_CLIENT_INTERP_NUM, _DNET_MP_CLIENT_INTERP_DEN)
          sz = _DNet_IDiv(dz * _DNET_MP_CLIENT_INTERP_NUM, _DNET_MP_CLIENT_INTERP_DEN)
          if sx == 0 and dx != 0 then sx = _DNet_MPSign32(dx) end if
          if sy == 0 and dy != 0 then sy = _DNet_MPSign32(dy) end if
          if sz == 0 and dz != 0 then sz = _DNet_MPSign32(dz) end if
          nx = cx + sx
          ny = cy + sy
          nz = cz + sz
        end if

        moved = nx != cx or ny != cy or nz != cz
        if moved then
          needRelink = true
          newsub = void
          if typeof(R_PointInSubsector) == "function" then
            newsub = R_PointInSubsector(nx, ny)
            if newsub is not void and mo.subsector is not void and newsub == mo.subsector then
              needRelink = false
            end if
          end if
          if needRelink and typeof(P_UnsetThingPosition) == "function" then P_UnsetThingPosition(mo) end if
          mo.x = nx
          mo.y = ny
          mo.z = nz
          mo.angle = tang
          if needRelink and typeof(P_SetThingPosition) == "function" then
            P_SetThingPosition(mo)
          else if newsub is not void then
            mo.subsector = newsub
          end if
          if mo.subsector is not void and mo.subsector.sector is not void then
            mo.floorz = _DNet_ToInt(mo.subsector.sector.floorheight, 0)
            mo.ceilingz = _DNet_ToInt(mo.subsector.sector.ceilingheight, 0)
          end if
        else
          mo.angle = tang
        end if
        _dnet_mp_client_actor_refs[i] = mo
      end if
    end if
    i = i + 1
  end while
end function

/// Client-side smoothing for remote player movement and turning.
/// @internal
function _DNet_MPClientAdvancePlayers()
  global _dnet_mp_client_player_tx
  global _dnet_mp_client_player_ty
  global _dnet_mp_client_player_tz
  global _dnet_mp_client_player_tang
  global _dnet_mp_client_player_vx
  global _dnet_mp_client_player_vy
  global _dnet_mp_client_player_vz
  global _dnet_mp_client_player_last_snap_tic
  if not _DNet_MPIsClient() then return end if
  if gamestate != gamestate_t.GS_LEVEL then return end if
  _DNet_MPClientEnsurePlayerMotionSlots()

  nowtic = _DNet_ToInt(gametic, 0)
  s = 0
  while s < MAXPLAYERS
    if s != _DNet_ToInt(consoleplayer, 0) and _DNet_IsSeq(playeringame) and s < len(playeringame) and playeringame[s] and _DNet_IsSeq(players) and s < len(players) and typeof(players[s]) == "struct" then
      p = players[s]
      mo = p.mo
      if typeof(mo) == "struct" then
        tx = _DNet_ToInt(_dnet_mp_client_player_tx[s], _DNet_ToInt(mo.x, 0))
        ty = _DNet_ToInt(_dnet_mp_client_player_ty[s], _DNet_ToInt(mo.y, 0))
        tz = _DNet_ToInt(_dnet_mp_client_player_tz[s], _DNet_ToInt(mo.z, 0))
        tang = _DNet_ToInt(_dnet_mp_client_player_tang[s], _DNet_ToInt(mo.angle, 0))
        lt = _DNet_ToInt(_dnet_mp_client_player_last_snap_tic[s], 0)
        if lt > 0 and nowtic > lt then
          miss = nowtic - lt
          if miss > 0 and miss <= _DNET_MP_CLIENT_MAX_EXTRAP_MOBILE then
            tx = tx + _DNet_ToInt(_dnet_mp_client_player_vx[s], 0)
            ty = ty + _DNet_ToInt(_dnet_mp_client_player_vy[s], 0)
            tz = tz + _DNet_ToInt(_dnet_mp_client_player_vz[s], 0)
            _dnet_mp_client_player_tx[s] = tx
            _dnet_mp_client_player_ty[s] = ty
            _dnet_mp_client_player_tz[s] = tz
          end if
        end if

        cx = _DNet_ToInt(mo.x, 0)
        cy = _DNet_ToInt(mo.y, 0)
        cz = _DNet_ToInt(mo.z, 0)
        dx = tx - cx
        dy = ty - cy
        dz = tz - cz
        hard = false
        if _DNet_MPAbs32(dx) > _DNET_MP_CLIENT_HARD_SNAP_DIST then hard = true end if
        if _DNet_MPAbs32(dy) > _DNET_MP_CLIENT_HARD_SNAP_DIST then hard = true end if
        if _DNet_MPAbs32(dz) > _DNET_MP_CLIENT_HARD_SNAP_DIST then hard = true end if

        nx = cx
        ny = cy
        nz = cz
        if hard then
          nx = tx
          ny = ty
          nz = tz
        else
          sx = _DNet_IDiv(dx * _DNET_MP_CLIENT_INTERP_NUM, _DNET_MP_CLIENT_INTERP_DEN)
          sy = _DNet_IDiv(dy * _DNET_MP_CLIENT_INTERP_NUM, _DNET_MP_CLIENT_INTERP_DEN)
          sz = _DNet_IDiv(dz * _DNET_MP_CLIENT_INTERP_NUM, _DNET_MP_CLIENT_INTERP_DEN)
          if sx == 0 and dx != 0 then sx = _DNet_MPSign32(dx) end if
          if sy == 0 and dy != 0 then sy = _DNet_MPSign32(dy) end if
          if sz == 0 and dz != 0 then sz = _DNet_MPSign32(dz) end if
          nx = cx + sx
          ny = cy + sy
          nz = cz + sz
        end if

        cang = _DNet_ToInt(mo.angle, 0)
        nang = cang
        ad = _DNet_MPAngleDeltaSigned(tang, cang)
        if hard then
          nang = tang
        else
          astep = _DNet_IDiv(ad * _DNET_MP_CLIENT_INTERP_NUM, _DNET_MP_CLIENT_INTERP_DEN)
          if astep == 0 and ad != 0 then astep = _DNet_MPSign32(ad) end if
          nang = cang + astep
        end if

        moved = nx != cx or ny != cy or nz != cz
        if moved then
          needRelink = true
          newsub = void
          if typeof(R_PointInSubsector) == "function" then
            newsub = R_PointInSubsector(nx, ny)
            if newsub is not void and mo.subsector is not void and newsub == mo.subsector then
              needRelink = false
            end if
          end if
          if needRelink and typeof(P_UnsetThingPosition) == "function" then P_UnsetThingPosition(mo) end if
          mo.x = nx
          mo.y = ny
          mo.z = nz
          mo.angle = nang
          if needRelink and typeof(P_SetThingPosition) == "function" then
            P_SetThingPosition(mo)
          else if newsub is not void then
            mo.subsector = newsub
          end if
          if mo.subsector is not void and mo.subsector.sector is not void then
            mo.floorz = _DNet_ToInt(mo.subsector.sector.floorheight, 0)
            mo.ceilingz = _DNet_ToInt(mo.subsector.sector.ceilingheight, 0)
          end if
        else
          mo.angle = nang
        end if
        p.mo = mo
        players[s] = p
      end if
    end if
    s = s + 1
  end while
end function

/// Returns integer absolute value for authoritative snapshot math.
/// @param v Value consumed by the operation.
/// @internal
function inline _DNet_MPAbs32(v)
  if v < 0 then return -v end if
  return v
end function

/// Computes Doom-style fast 2D distance approximation for relevance filtering.
/// @param dx Horizontal coordinate or vector component represented by dx.
/// @param dy Vertical coordinate or vector component represented by dy.
/// @internal
function inline _DNet_MPApproxDist2D(dx, dy)
  adx = _DNet_MPAbs32(dx)
  ady = _DNet_MPAbs32(dy)
  mn = adx
  if ady < mn then mn = ady end if
  return adx + ady - (mn >> 1)
end function

/// Normalizes signed int values into unsigned 32-bit angle space.
/// @param v Value consumed by the operation.
/// @internal
function inline _DNet_MPU32(v)
  return _DNet_ToInt(v, 0) & 0xFFFFFFFF
end function

/// Returns shortest unsigned absolute angle delta (0..0x80000000).
/// @param a First input operand.
/// @param b Second input operand.
/// @internal
function inline _DNet_MPAngleAbsDelta(a, b)
  ua = _DNet_MPU32(a)
  ub = _DNet_MPU32(b)
  d = ua - ub
  if d < 0 then d = -d end if
  if d > 2147483648 then d = 4294967296 - d end if
  return d
end function

/// Returns true when an actor is relevant enough for a specific client slot snapshot.
/// @param slot Slot value supplied to `_DNet_MPHostActorRelevantForSlot`.
/// @param mo Map object affected by the operation.
/// @internal
function inline _DNet_MPHostActorRelevantForSlot(slot, mo)
  if typeof(mo) != "struct" then return false end if

  s = _DNet_ToInt(slot, -1)
  if s < 1 or s >= MAXPLAYERS then return true end if
  if not _DNet_IsSeq(players) or s >= len(players) then return true end if
  p = players[s]
  if typeof(p) != "struct" or typeof(p.mo) != "struct" then return true end if

  px = _DNet_ToInt(p.mo.x, 0)
  py = _DNet_ToInt(p.mo.y, 0)
  mx = _DNet_ToInt(mo.x, 0)
  my = _DNet_ToInt(mo.y, 0)
  approx = _DNet_MPApproxDist2D(mx - px, my - py)

  limit = _DNET_MP_RELEVANCE_DISTANCE
  flags = _DNet_ToInt(mo.flags, 0)
  if (flags & mobjflag_t.MF_MISSILE) != 0 then
    limit = limit + _DNET_MP_RELEVANCE_MISSILE_BONUS
  end if
  if (flags & mobjflag_t.MF_SPECIAL) != 0 then
    limit = limit + _DNET_MP_RELEVANCE_SPECIAL_BONUS
  end if

  if approx <= limit then return true end if

  // Client-view based relevance: keep visible actors even when outside near radius.
  viewLimit = limit + _DNET_MP_RELEVANCE_VIEW_BONUS
  if approx <= viewLimit then
    toang = R_PointToAngle2(px, py, mx, my)
    pview = _DNet_ToInt(p.mo.angle, 0)
    if _DNet_MPAngleAbsDelta(toang, pview) <= _DNET_MP_RELEVANCE_VIEW_HALFANGLE then
      return true
    end if
  end if

  // Keep actors actively targeting/near this player even when slightly outside base radius.
  if typeof(mo.target) == "struct" then
    tx = _DNet_ToInt(mo.target.x, 0)
    ty = _DNet_ToInt(mo.target.y, 0)
    tdist = _DNet_MPApproxDist2D(tx - px, ty - py)
    if tdist <= (512 * FRACUNIT) then return true end if
  end if

  return false
end function

/// Detects mostly-static actor classes (pickups/corpses/decor) that can be heartbeated less often.
/// @param mo Map object affected by the operation.
/// @internal
function inline _DNet_MPActorIsStaticForSync(mo)
  if typeof(mo) != "struct" then return false end if

  flags = _DNet_ToInt(mo.flags, 0)
  if (flags & mobjflag_t.MF_MISSILE) != 0 then return false end if
  if mo.player is not void then return false end if

  ty = _DNet_ToInt(mo.type, -1)
  if ty == mobjtype_t.MT_PUFF or ty == mobjtype_t.MT_BLOOD or ty == mobjtype_t.MT_SMOKE or ty == mobjtype_t.MT_TFOG or ty == mobjtype_t.MT_IFOG then
    return false
  end if

  if _DNet_ToInt(mo.momx, 0) != 0 or _DNet_ToInt(mo.momy, 0) != 0 or _DNet_ToInt(mo.momz, 0) != 0 then
    return false
  end if

  if (flags & mobjflag_t.MF_SPECIAL) != 0 then return true end if
  if (flags & mobjflag_t.MF_CORPSE) != 0 then return true end if
  if (flags & mobjflag_t.MF_COUNTKILL) == 0 and (flags & mobjflag_t.MF_SHOOTABLE) == 0 then return true end if
  return false
end function

/// Spreads static actor heartbeat replication across full snapshots.
/// @param idv Idv value supplied to `_DNet_MPStaticActorHeartbeatHit`.
/// @param snapshotTick Snapshot tick value supplied to `_DNet_MPStaticActorHeartbeatHit`.
/// @internal
function inline _DNet_MPStaticActorHeartbeatHit(idv, snapshotTick)
  n = _DNET_MP_STATIC_HEARTBEAT_FULLS
  if n <= 1 then return true end if
  // Only pulse on full-snapshot boundaries to avoid re-sending the same static set every tick.
  if (_DNet_ToInt(snapshotTick, 0) % _DNET_MP_FULL_SNAPSHOT_PERIOD) != 0 then return false end if
  fullIdx = _DNet_IDiv(_DNet_ToInt(snapshotTick, 0), _DNET_MP_FULL_SNAPSHOT_PERIOD)
  if fullIdx < 0 then fullIdx = 0 end if
  return ((_DNet_ToInt(idv, 0) + fullIdx) % n) == 0
end function

/// Compares two compact snapshot keys for player/actor delta detection.
/// @param a First input operand.
/// @param b Second input operand.
/// @internal
function inline _DNet_MPStateKeyEquals(a, b)
  if not _DNet_IsSeq(a) or not _DNet_IsSeq(b) then return false end if
  if len(a) != len(b) then return false end if
  i = 0
  while i < len(a)
    if _DNet_ToInt(a[i], -2147483647) != _DNet_ToInt(b[i], -2147483647) then return false end if
    i = i + 1
  end while
  return true
end function

/// Returns per-actor stale miss threshold so short-lived effects are culled quickly.
/// @param baseLimit Base limit value supplied to `_DNet_MPClientActorMissLimit`.
/// @param mo Map object affected by the operation.
/// @internal
function inline _DNet_MPClientActorMissLimit(baseLimit, mo)
  limit = _DNet_ToInt(baseLimit, 3)
  if limit < 1 then limit = 1 end if
  if typeof(mo) != "struct" then return limit end if

  flags = _DNet_ToInt(mo.flags, 0)
  if (flags & mobjflag_t.MF_MISSILE) != 0 then
    if limit > 1 then limit = 1 end if
    return limit
  end if

  ty = _DNet_ToInt(mo.type, -1)
  if ty == mobjtype_t.MT_PUFF or ty == mobjtype_t.MT_BLOOD or ty == mobjtype_t.MT_SMOKE or ty == mobjtype_t.MT_TFOG or ty == mobjtype_t.MT_IFOG then
    if limit > 1 then limit = 1 end if
    return limit
  end if
  if _DNet_MPActorIsStaticForSync(mo) then
    staticLimit = _DNET_MP_STATIC_HEARTBEAT_FULLS + _DNET_MP_CLIENT_STALE_GRACE_SWEEPS + 2
    if staticLimit < 3 then staticLimit = 3 end if
    if staticLimit > 60 then staticLimit = 60 end if
    if limit < staticLimit then limit = staticLimit end if
  end if
  return limit
end function

/// Computes how many full-snapshot misses an actor can accumulate before client-side stale removal.
/// @internal
function _DNet_MPClientStaleMissLimit()
  active = 0
  i = 0
  while i < len(_dnet_mp_client_actor_ids) and i < len(_dnet_mp_client_actor_refs)
    idv = _DNet_ToInt(_dnet_mp_client_actor_ids[i], 0)
    ref = _dnet_mp_client_actor_refs[i]
    if idv > 0 and typeof(ref) == "struct" then
      active = active + 1
    end if
    i = i + 1
  end while

  rowsPerSweep = _DNET_MP_MAX_ACTORS_PER_SNAPSHOT
  if rowsPerSweep <= 0 then rowsPerSweep = 1 end if

  sweeps = _DNet_IDiv(active + rowsPerSweep - 1, rowsPerSweep)
  if sweeps < 1 then sweeps = 1 end if
  // Require one complete full-snapshot sweep plus configurable grace sweeps.
  limit = sweeps + _DNET_MP_CLIENT_STALE_GRACE_SWEEPS
  if limit < 3 then limit = 3 end if
  if limit > 60 then limit = 60 end if
  return limit
end function

/// Builds compact actor state key used to suppress unchanged actor replication.
/// @param mo Map object affected by the operation.
/// @internal
function inline _DNet_MPActorStateKey(mo)
  if typeof(mo) != "struct" then return 0 end if
  st = _DNet_ToInt(_DNet_StateIndex(mo.state), 0)
  if st < 0 then st = 0 end if

  // Fast integer signature (LCG-style mix) to avoid per-actor list allocations every snapshot tick.
  sig = 216613626
  sig = ((sig * 1103515245) + 12345 + _DNet_ToInt(mo.type, 0)) & 2147483647
  sig = ((sig * 1103515245) + 12345 + _DNet_ToInt(mo.x, 0)) & 2147483647
  sig = ((sig * 1103515245) + 12345 + _DNet_ToInt(mo.y, 0)) & 2147483647
  sig = ((sig * 1103515245) + 12345 + _DNet_ToInt(mo.z, 0)) & 2147483647
  sig = ((sig * 1103515245) + 12345 + _DNet_ToInt(mo.angle, 0)) & 2147483647
  sig = ((sig * 1103515245) + 12345 + _DNet_ToInt(mo.sprite, 0)) & 2147483647
  sig = ((sig * 1103515245) + 12345 + _DNet_ToInt(mo.frame, 0)) & 2147483647
  sig = ((sig * 1103515245) + 12345 + st) & 2147483647
  sig = ((sig * 1103515245) + 12345 + _DNet_ToInt(mo.health, 0)) & 2147483647
  sig = ((sig * 1103515245) + 12345 + _DNet_ToInt(mo.flags, 0)) & 2147483647
  return sig
end function

/// Finds closest existing client actor proxy by type/position for id-churn recovery.
/// @param atype Atype value supplied to `_DNet_MPClientFindActorByPose`.
/// @param ax Horizontal coordinate or vector component represented by ax.
/// @param ay Vertical coordinate or vector component represented by ay.
/// @param az Az value supplied to `_DNet_MPClientFindActorByPose`.
/// @param claimed Claimed value supplied to `_DNet_MPClientFindActorByPose`.
/// @internal
function _DNet_MPClientFindActorByPose(atype, ax, ay, az, claimed)
  bestIdx = -1
  bestScore = 0
  // Delta snapshots can arrive every tick; keep the rebind window tight to avoid cross-binding nearby actors.
  limit = 24 * FRACUNIT
  i = 0
  while i < len(_dnet_mp_client_actor_ids) and i < len(_dnet_mp_client_actor_refs)
    already = false
    if _DNet_IsSeq(claimed) and i < len(claimed) then already = claimed[i] != 0 end if
    if not already and _DNet_ToInt(_dnet_mp_client_actor_ids[i], 0) > 0 then
      mo = _dnet_mp_client_actor_refs[i]
      if typeof(mo) == "struct" and _DNet_ToInt(mo.type, -1) == atype then
        dx = _DNet_MPAbs32(_DNet_ToInt(mo.x, 0) - ax)
        dy = _DNet_MPAbs32(_DNet_ToInt(mo.y, 0) - ay)
        dz = _DNet_MPAbs32(_DNet_ToInt(mo.z, 0) - az)
        if dx <= limit and dy <= limit and dz <= limit then
          score = dx + dy + dz
          if bestIdx < 0 or score < bestScore then
            bestIdx = i
            bestScore = score
          end if
        end if
      end if
    end if
    i = i + 1
  end while
  return bestIdx
end function

/// Finds already-claimed actor proxy with exact replicated pose/state to suppress duplicate spawns.
/// @param atype Atype value supplied to `_DNet_MPClientFindClaimedActorExact`.
/// @param ax Horizontal coordinate or vector component represented by ax.
/// @param ay Vertical coordinate or vector component represented by ay.
/// @param az Az value supplied to `_DNet_MPClientFindClaimedActorExact`.
/// @param aang Aang value supplied to `_DNet_MPClientFindClaimedActorExact`.
/// @param aspr Aspr value supplied to `_DNet_MPClientFindClaimedActorExact`.
/// @param afrm Afrm value supplied to `_DNet_MPClientFindClaimedActorExact`.
/// @param astate Astate value supplied to `_DNet_MPClientFindClaimedActorExact`.
/// @param claimed Claimed value supplied to `_DNet_MPClientFindClaimedActorExact`.
/// @internal
function _DNet_MPClientFindClaimedActorExact(atype, ax, ay, az, aang, aspr, afrm, astate, claimed)
  i = 0
  while i < len(_dnet_mp_client_actor_ids) and i < len(_dnet_mp_client_actor_refs)
    isClaimed = false
    if _DNet_IsSeq(claimed) and i < len(claimed) then isClaimed = claimed[i] != 0 end if
    if isClaimed and _DNet_ToInt(_dnet_mp_client_actor_ids[i], 0) > 0 then
      mo = _dnet_mp_client_actor_refs[i]
      if typeof(mo) == "struct" and _DNet_ToInt(mo.type, -1) == atype then
        if _DNet_ToInt(mo.x, 0) == ax and _DNet_ToInt(mo.y, 0) == ay and _DNet_ToInt(mo.z, 0) == az and _DNet_ToInt(mo.angle, 0) == aang and _DNet_ToInt(mo.sprite, 0) == aspr and _DNet_ToInt(mo.frame, 0) == afrm then
          curState = _DNet_ToInt(_DNet_StateIndex(mo.state), 0)
          if curState == astate then return i end if
        end if
      end if
    end if
    i = i + 1
  end while
  return -1
end function

/// Binds replicated actor id to one proxy slot and clears previous conflicting mapping.
/// @param idx Zero-based element or table index.
/// @param aid Aid value supplied to `_DNet_MPClientBindActorId`.
/// @internal
function inline _DNet_MPClientBindActorId(idx, aid)
  if idx < 0 then return end if
  old = _DNet_MPClientFindActorIndex(aid)
  if old >= 0 and old != idx then
    _DNet_MPClientRemoveActorAt(old)
  end if
  if idx >= 0 and idx < len(_dnet_mp_client_actor_ids) then
    _dnet_mp_client_actor_ids[idx] = aid
  end if
end function

/// Removes one client-side replicated actor proxy.
/// @param idx Zero-based element or table index.
/// @internal
function inline _DNet_MPClientRemoveActorAt(idx)
  global _dnet_mp_client_actor_ids
  global _dnet_mp_client_actor_refs
  global _dnet_mp_client_actor_miss
  global _dnet_mp_client_actor_tx
  global _dnet_mp_client_actor_ty
  global _dnet_mp_client_actor_tz
  global _dnet_mp_client_actor_tang
  global _dnet_mp_client_actor_vx
  global _dnet_mp_client_actor_vy
  global _dnet_mp_client_actor_vz
  global _dnet_mp_client_actor_last_snap_tic
  global _dnet_mp_client_actor_kind
  if idx < 0 or idx >= len(_dnet_mp_client_actor_ids) or idx >= len(_dnet_mp_client_actor_refs) then return end if
  mo = _dnet_mp_client_actor_refs[idx]
  if typeof(mo) == "struct" and typeof(P_RemoveMobj) == "function" then
    P_RemoveMobj(mo)
  end if
  _dnet_mp_client_actor_ids[idx] = 0
  _dnet_mp_client_actor_refs[idx] = 0
  if _DNet_IsSeq(_dnet_mp_client_actor_miss) and idx < len(_dnet_mp_client_actor_miss) then
    _dnet_mp_client_actor_miss[idx] = 0
  end if
  if _DNet_IsSeq(_dnet_mp_client_actor_tx) and idx < len(_dnet_mp_client_actor_tx) then _dnet_mp_client_actor_tx[idx] = 0 end if
  if _DNet_IsSeq(_dnet_mp_client_actor_ty) and idx < len(_dnet_mp_client_actor_ty) then _dnet_mp_client_actor_ty[idx] = 0 end if
  if _DNet_IsSeq(_dnet_mp_client_actor_tz) and idx < len(_dnet_mp_client_actor_tz) then _dnet_mp_client_actor_tz[idx] = 0 end if
  if _DNet_IsSeq(_dnet_mp_client_actor_tang) and idx < len(_dnet_mp_client_actor_tang) then _dnet_mp_client_actor_tang[idx] = 0 end if
  if _DNet_IsSeq(_dnet_mp_client_actor_vx) and idx < len(_dnet_mp_client_actor_vx) then _dnet_mp_client_actor_vx[idx] = 0 end if
  if _DNet_IsSeq(_dnet_mp_client_actor_vy) and idx < len(_dnet_mp_client_actor_vy) then _dnet_mp_client_actor_vy[idx] = 0 end if
  if _DNet_IsSeq(_dnet_mp_client_actor_vz) and idx < len(_dnet_mp_client_actor_vz) then _dnet_mp_client_actor_vz[idx] = 0 end if
  if _DNet_IsSeq(_dnet_mp_client_actor_last_snap_tic) and idx < len(_dnet_mp_client_actor_last_snap_tic) then _dnet_mp_client_actor_last_snap_tic[idx] = 0 end if
  if _DNet_IsSeq(_dnet_mp_client_actor_kind) and idx < len(_dnet_mp_client_actor_kind) then _dnet_mp_client_actor_kind[idx] = 0 end if
end function

/// Clears client-side local non-player thinkers before authoritative actor replication takes over.
/// @internal
function _DNet_MPClientBootstrapWorld()
  global _dnet_mp_client_actor_ids
  global _dnet_mp_client_actor_refs
  global _dnet_mp_client_actor_miss
  global _dnet_mp_client_actor_tx
  global _dnet_mp_client_actor_ty
  global _dnet_mp_client_actor_tz
  global _dnet_mp_client_actor_tang
  global _dnet_mp_client_actor_vx
  global _dnet_mp_client_actor_vy
  global _dnet_mp_client_actor_vz
  global _dnet_mp_client_actor_last_snap_tic
  global _dnet_mp_client_actor_kind
  global _dnet_mp_client_player_tx
  global _dnet_mp_client_player_ty
  global _dnet_mp_client_player_tz
  global _dnet_mp_client_player_tang
  global _dnet_mp_client_player_vx
  global _dnet_mp_client_player_vy
  global _dnet_mp_client_player_vz
  global _dnet_mp_client_player_last_snap_tic
  global _dnet_mp_client_last_smooth_tic
  _dnet_mp_client_actor_ids = []
  _dnet_mp_client_actor_refs = []
  _dnet_mp_client_actor_miss = []
  _dnet_mp_client_actor_tx = []
  _dnet_mp_client_actor_ty = []
  _dnet_mp_client_actor_tz = []
  _dnet_mp_client_actor_tang = []
  _dnet_mp_client_actor_vx = []
  _dnet_mp_client_actor_vy = []
  _dnet_mp_client_actor_vz = []
  _dnet_mp_client_actor_last_snap_tic = []
  _dnet_mp_client_actor_kind = []
  _dnet_mp_client_player_tx = []
  _dnet_mp_client_player_ty = []
  _dnet_mp_client_player_tz = []
  _dnet_mp_client_player_tang = []
  _dnet_mp_client_player_vx = []
  _dnet_mp_client_player_vy = []
  _dnet_mp_client_player_vz = []
  _dnet_mp_client_player_last_snap_tic = []
  _dnet_mp_client_last_smooth_tic = -1
  if typeof(thinkercap) != "struct" then return end if
  if thinkercap.next is void then return end if

  cur = thinkercap.next
  guard = 0
  while cur != thinkercap and guard < 131072
    if typeof(cur) != "struct" then break end if
    nxt = cur.next
    if nxt is void then break end if
    if _DNet_MPThinkerIsMobj(cur) then
      owner = cur
      if typeof(P_ResolveThinkerOwner) == "function" then
        o = P_ResolveThinkerOwner(cur)
        if typeof(o) == "struct" then owner = o end if
      end if
      if _DNet_MPActorUsable(owner) and typeof(P_RemoveMobj) == "function" then
        P_RemoveMobj(owner)
      end if
    end if
    cur = nxt
    guard = guard + 1
  end while
end function

/// Returns true when two ticcmd structs carry the same gameplay input values.
/// @param a First input operand.
/// @param b Second input operand.
/// @internal
function inline _DNet_MPCmdEquals(a, b)
  if typeof(a) != "struct" or typeof(b) != "struct" then return false end if
  if _DNet_ToInt(a.forwardmove, 0) != _DNet_ToInt(b.forwardmove, 0) then return false end if
  if _DNet_ToInt(a.sidemove, 0) != _DNet_ToInt(b.sidemove, 0) then return false end if
  if _DNet_ToInt(a.angleturn, 0) != _DNet_ToInt(b.angleturn, 0) then return false end if
  if _DNet_ToInt(a.buttons, 0) != _DNet_ToInt(b.buttons, 0) then return false end if
  if _DNet_ToInt(a.consistancy, 0) != _DNet_ToInt(b.consistancy, 0) then return false end if
  if _DNet_ToInt(a.chatchar, 0) != _DNet_ToInt(b.chatchar, 0) then return false end if
  return true
end function

/// Sends one client input command to authoritative host.
/// @param cmd Cmd value supplied to `_DNet_MPSendInputCmd`.
/// @internal
function _DNet_MPSendInputCmd(cmd)
  global _dnet_mp_last_input_seq
  global _dnet_mp_last_input_send_tic
  global _dnet_mp_last_input_cmd
  if not _DNet_MPIsClient() then return end if
  if typeof(MP_PlatformNetSend) != "function" then return end if

  sendNow = true
  nowtic = _DNet_ToInt(gametic, 0)
  if typeof(_dnet_mp_last_input_cmd) == "struct" and _DNet_MPCmdEquals(_dnet_mp_last_input_cmd, cmd) then
    sendNow = false
    delta = nowtic - _DNet_ToInt(_dnet_mp_last_input_send_tic, 0)
    if delta < 0 then delta = _DNET_MP_INPUT_KEEPALIVE_TICS end if
    if delta >= _DNET_MP_INPUT_KEEPALIVE_TICS then sendNow = true end if
  end if
  if not sendNow then return end if

  seq = _DNet_ToInt(_dnet_mp_last_input_seq, 0) + 1
  _dnet_mp_last_input_seq = seq

  slot = _DNet_ToInt(consoleplayer, 0)
  if slot < 0 then slot = 0 end if
  if slot >= MAXPLAYERS then slot = MAXPLAYERS - 1 end if

  payload = bytes(18, 0)
  payload[0] = _DNET_MPMSG_INPUT
  payload[1] = slot & 255
  _DNet_MPWriteU32(payload, 2, seq)
  _DNet_MPWriteI16(payload, 6, _DNet_ToInt(cmd.forwardmove, 0))
  _DNet_MPWriteI16(payload, 8, _DNet_ToInt(cmd.sidemove, 0))
  _DNet_MPWriteI16(payload, 10, _DNet_ToInt(cmd.angleturn, 0))
  _DNet_MPWriteU16(payload, 12, _DNet_ToInt(cmd.buttons, 0))
  _DNet_MPWriteI16(payload, 14, _DNet_ToInt(cmd.consistancy, 0))
  _DNet_MPWriteI16(payload, 16, _DNet_ToInt(cmd.chatchar, 0))
  if MP_PlatformNetSend(0, payload) then
    activeCmd = false
    if _DNet_ToInt(cmd.forwardmove, 0) != 0 then activeCmd = true end if
    if _DNet_ToInt(cmd.sidemove, 0) != 0 then activeCmd = true end if
    if _DNet_ToInt(cmd.angleturn, 0) != 0 then activeCmd = true end if
    if _DNet_ToInt(cmd.buttons, 0) != 0 then activeCmd = true end if
    if _DNet_ToInt(cmd.chatchar, 0) != 0 then activeCmd = true end if
    if activeCmd and _DNET_MP_INPUT_ACTIVE_REDUNDANT_COPIES > 1 then
      dup = 1
      while dup < _DNET_MP_INPUT_ACTIVE_REDUNDANT_COPIES
        MP_PlatformNetSend(0, payload)
        dup = dup + 1
      end while
    end if
    _dnet_mp_last_input_send_tic = nowtic
    _dnet_mp_last_input_cmd = _DNet_CopyCmd(cmd)
  end if
end function

/// Applies one client input payload to host-side remote command cache.
/// @param node Node value supplied to `_DNet_MPHostHandleInputPacket`.
/// @param payload Payload value supplied to `_DNet_MPHostHandleInputPacket`.
/// @internal
function _DNet_MPHostHandleInputPacket(node, payload)
  global _dnet_mp_remote_cmds
  global _dnet_mp_remote_cmd_valid
  global _dnet_mp_remote_cmd_tic
  global _dnet_mp_remote_input_last_seq
  global _dnet_mp_host_input_active_logged

  if typeof(payload) != "bytes" or len(payload) != 18 then return end if
  slot = _DNet_ToInt(node, -1)
  // The transport-assigned node is the authenticated player slot. Never fall
  // back to the untrusted slot byte carried by the client payload.
  if slot < 1 or slot >= MAXPLAYERS then return end if
  if (payload[1] & 255) != slot then return end if
  seq = _DNet_MPReadU32(payload, 2)
  lastSeq = -1
  if _DNet_IsSeq(_dnet_mp_remote_input_last_seq) and slot < len(_dnet_mp_remote_input_last_seq) then
    lastSeq = _DNet_ToInt(_dnet_mp_remote_input_last_seq[slot], -1)
  end if
  if not _DNet_MPSeqIsNewer(seq, lastSeq) then return end if

  forward = _DNet_MPReadI16(payload, 6)
  side = _DNet_MPReadI16(payload, 8)
  if forward > MAXPLMOVE then forward = MAXPLMOVE end if
  if forward < -MAXPLMOVE then forward = -MAXPLMOVE end if
  if side > MAXPLMOVE then side = MAXPLMOVE end if
  if side < -MAXPLMOVE then side = -MAXPLMOVE end if
  // Remote peers may attack/use/change weapons, but cannot issue local-only
  // pause/save commands through BT_SPECIAL.
  buttons = _DNet_MPReadU16(payload, 12) & 127
  cmd = ticcmd_t(
  forward,
  side,
  _DNet_MPReadI16(payload, 10),
  _DNet_MPReadI16(payload, 14),
  _DNet_MPReadI16(payload, 16),
  buttons
 )

  nonNeutral = forward != 0 or side != 0 or _DNet_ToInt(cmd.angleturn, 0) != 0 or buttons != 0 or _DNet_ToInt(cmd.chatchar, 0) != 0
  if nonNeutral and _DNet_IsSeq(_dnet_mp_host_input_active_logged) and slot < len(_dnet_mp_host_input_active_logged) and not _dnet_mp_host_input_active_logged[slot] then
    _dnet_mp_host_input_active_logged[slot] = true
    if typeof(_MPPlatform_LogEvent) == "function" then _MPPlatform_LogEvent("MPTEST INPUT_ACTIVE slot=" + slot) end if
  end if

  if _DNet_IsSeq(_dnet_mp_remote_input_last_seq) and slot < len(_dnet_mp_remote_input_last_seq) then
    _dnet_mp_remote_input_last_seq[slot] = seq
  end if
  if slot < len(_dnet_mp_remote_cmds) then _dnet_mp_remote_cmds[slot] = cmd end if
  if slot < len(_dnet_mp_remote_cmd_valid) then _dnet_mp_remote_cmd_valid[slot] = true end if
  if slot < len(_dnet_mp_remote_cmd_tic) then _dnet_mp_remote_cmd_tic[slot] = _DNet_ToInt(gametic, 0) end if
  if slot < len(nodeforplayer) then nodeforplayer[slot] = slot end if
  _DNet_MPSetPlayerSlotActive(slot, true)
  _DNet_MPEnsureHostSlotMobj(slot)
  if _DNet_IsSeq(players) and slot < len(players) then
    p = _DNet_MPEnsurePlayerStruct(slot)
    if typeof(p) == "struct" then
      p.cmd = _DNet_CopyCmd(cmd)
      if typeof(p.health) != "int" then p.health = 100 end if
      if typeof(p.mo) == "struct" and _DNet_ToInt(cmd.forwardmove, 0) == 0 and _DNet_ToInt(cmd.sidemove, 0) == 0 then
        stidx = _DNet_StateIndex(p.mo.state)
        run0 = _DNet_StateIndex(statenum_t.S_PLAY_RUN1)
        if run0 >= 0 and stidx >= run0 and stidx < run0 + 4 and typeof(P_SetMobjState) == "function" then
          P_SetMobjState(p.mo, statenum_t.S_PLAY)
        end if
      end if
      players[slot] = p
    end if
  end if
end function

/// Spawns missing remote player mobjs on host when late-joining clients become active.
/// @param slot Slot value supplied to `_DNet_MPEnsureHostSlotMobj`.
/// @internal
function _DNet_MPEnsureHostSlotMobj(slot)
  if gamestate != gamestate_t.GS_LEVEL then return end if
  if slot < 0 or slot >= MAXPLAYERS then return end if
  if not _DNet_IsSeq(playeringame) or slot >= len(playeringame) or not playeringame[slot] then return end if
  if not _DNet_IsSeq(players) or slot >= len(players) then return end if

  p = _DNet_MPEnsurePlayerStruct(slot)
  if typeof(p) != "struct" then return end if
  if typeof(p.mo) == "struct" then
    stale = false
    if p.mo.thinker is void then
      stale = true
    else if typeof(p.mo.thinker) != "struct" then
      stale = true
    else if p.mo.thinker.func is not void and typeof(p.mo.thinker.func) == "struct" and _DNet_ToInt(p.mo.thinker.func.acv, 0) == -1 then
      stale = true
    end if
    if p.mo.subsector is void then
      stale = true
    end if
    if not stale then return end if
    oldmo = p.mo
    if typeof(oldmo) == "struct" and typeof(P_RemoveMobj) == "function" then
      P_RemoveMobj(oldmo)
    end if
    p.mo = void
    players[slot] = p
  end if

  // Keep carried loadout across map transitions; only force reborn for explicit reborn state
  // or freshly initialized slots that do not own any weapon yet.
  needsRebornLoadout = false
  if p.playerstate == playerstate_t.PST_REBORN then
    needsRebornLoadout = true
  else if not _DNet_MPPlayerHasAnyOwnedWeapon(p) then
    needsRebornLoadout = true
  end if
  if needsRebornLoadout then
    p.playerstate = playerstate_t.PST_REBORN
  else
    p.playerstate = playerstate_t.PST_LIVE
  end if
  players[slot] = p

  hasMapStart = false
  if typeof(playerstarts) == "array" and slot < len(playerstarts) and playerstarts[slot] is not void then
    st0 = playerstarts[slot]
    if typeof(st0) == "struct" then
      stType = _DNet_ToInt(st0.type, 0)
      hasMapStart = stType >= 1 and stType <= MAXPLAYERS
    end if
  end if
  if hasMapStart and typeof(P_SpawnPlayer) == "function" then
    st = playerstarts[slot]
    st = mapthing_t(_DNet_ToInt(st.x, 0), _DNet_ToInt(st.y, 0), _DNet_ToInt(st.angle, 0), slot + 1, _DNet_ToInt(st.options, 0))
    P_SpawnPlayer(st)
  end if
  pslot = void
  if _DNet_IsSeq(players) and slot < len(players) then
    pslot = players[slot]
  end if
  if typeof(pslot) == "struct" and pslot.mo is void and deathmatch and typeof(G_DeathMatchSpawnPlayer) == "function" then
    G_DeathMatchSpawnPlayer(slot)
  end if
  pslot = void
  if _DNet_IsSeq(players) and slot < len(players) then
    pslot = players[slot]
  end if
  if typeof(pslot) == "struct" and pslot.mo is void and typeof(P_SpawnPlayer) == "function" then
    sx = 0
    sy = 0
    sang = 0
    if _DNet_IsSeq(players) and len(players) > 0 and typeof(players[0]) == "struct" and typeof(players[0].mo) == "struct" then
      sx = _DNet_ToInt(players[0].mo.x, 0)
      sy = _DNet_ToInt(players[0].mo.y, 0)
      sang = _DNet_ToInt(players[0].mo.angle, 0)
    else if typeof(playerstarts) == "array" and len(playerstarts) > 0 and playerstarts[0] is not void then
      sx = _DNet_ToInt(playerstarts[0].x, 0) << FRACBITS
      sy = _DNet_ToInt(playerstarts[0].y, 0) << FRACBITS
      sang = _DNet_ToInt(playerstarts[0].angle, 0)
    end if
    sx = sx + ((64 * slot) << FRACBITS)
    sy = sy + ((48 * slot) << FRACBITS)
    mthing = mapthing_t(_DNet_IDiv(sx, FRACUNIT), _DNet_IDiv(sy, FRACUNIT), sang, slot + 1, 0)
    P_SpawnPlayer(mthing)
  end if
  pslot = void
  if _DNet_IsSeq(players) and slot < len(players) then
    pslot = players[slot]
  end if
  if typeof(pslot) == "struct" and pslot.mo is void and typeof(P_SpawnMobj) == "function" then
    sx = 0
    sy = 0
    sz = ONFLOORZ
    if _DNet_IsSeq(players) and len(players) > 0 and typeof(players[0]) == "struct" and typeof(players[0].mo) == "struct" then
      sx = _DNet_ToInt(players[0].mo.x, 0) + ((64 * slot) * FRACUNIT)
      sy = _DNet_ToInt(players[0].mo.y, 0) + ((48 * slot) * FRACUNIT)
    else if typeof(playerstarts) == "array" and len(playerstarts) > 0 and playerstarts[0] is not void then
      sx = (_DNet_ToInt(playerstarts[0].x, 0) << FRACBITS) + ((64 * slot) * FRACUNIT)
      sy = (_DNet_ToInt(playerstarts[0].y, 0) << FRACBITS) + ((48 * slot) * FRACUNIT)
    end if
    mo = P_SpawnMobj(sx, sy, sz, mobjtype_t.MT_PLAYER)
    if typeof(mo) == "struct" then
      p2 = players[slot]
      if typeof(p2) != "struct" then
        p2 = Player_MakeDefault()
      end if
      mo.player = p2
      mo.health = _DNet_ToInt(p2.health, 100)
      mo.angle = 0
      p2.mo = mo
      p2.playerstate = playerstate_t.PST_LIVE
      p2.viewheight = VIEWHEIGHT
      p2.viewz = _DNet_ToInt(mo.z, 0) + VIEWHEIGHT
      if slot > 0 then
        mo.flags = _DNet_ToInt(mo.flags, 0) | (slot << mobjflag_t.MF_TRANSSHIFT)
      end if
      players[slot] = p2
    end if
  end if
end function

/// Synchronizes host player slot activity with platform peer list.
/// @internal
function _DNet_MPHostApplyActiveSlots()
  active = _DNet_MPActiveSlots()
  i = 0
  while i < MAXPLAYERS
    want = _DNet_MPSlotActive(active, i)
    if i == 0 then want = true end if
    was = false
    if _DNet_IsSeq(playeringame) and i < len(playeringame) then
      if typeof(playeringame[i]) == "bool" then
        was = playeringame[i]
      else
        was = _DNet_ToInt(playeringame[i], 0) != 0
      end if
    end if
    _DNet_MPSetPlayerSlotActive(i, want)
    if want and i < len(nodeforplayer) then nodeforplayer[i] = i end if
    if want and(not was) then _DNet_MPHostMarkSlotFullsync(i) end if
    if want then
      _DNet_MPEnsureHostSlotMobj(i)
      if gamestate == gamestate_t.GS_LEVEL and _DNet_IsSeq(players) and i < len(players) then
        p = _DNet_MPEnsurePlayerStruct(i)
        if typeof(p) == "struct" and typeof(p.mo) != "struct" and typeof(P_SpawnMobj) == "function" then
          sx = 0
          sy = 0
          sz = ONFLOORZ
          if typeof(playerstarts) == "array" and i >= 0 and i < len(playerstarts) and typeof(playerstarts[i]) == "struct" and _DNet_ToInt(playerstarts[i].type, 0) >= 1 then
            sx = _DNet_ToInt(playerstarts[i].x, 0) << FRACBITS
            sy = _DNet_ToInt(playerstarts[i].y, 0) << FRACBITS
          else if typeof(playerstarts) == "array" and len(playerstarts) > 0 and typeof(playerstarts[0]) == "struct" then
            sx = (_DNet_ToInt(playerstarts[0].x, 0) << FRACBITS) + ((64 * i) * FRACUNIT)
            sy = (_DNet_ToInt(playerstarts[0].y, 0) << FRACBITS) + ((48 * i) * FRACUNIT)
          else if _DNet_IsSeq(players) and len(players) > 0 and typeof(players[0]) == "struct" and typeof(players[0].mo) == "struct" then
            sx = _DNet_ToInt(players[0].mo.x, 0) + ((64 * i) * FRACUNIT)
            sy = _DNet_ToInt(players[0].mo.y, 0) + ((48 * i) * FRACUNIT)
          end if
          mo = P_SpawnMobj(sx, sy, sz, mobjtype_t.MT_PLAYER)
          if typeof(mo) == "struct" then
            mo.player = p
            if i > 0 then
              mo.flags = _DNet_ToInt(mo.flags, 0) | (i << mobjflag_t.MF_TRANSSHIFT)
            end if
            p.mo = mo
            p.playerstate = playerstate_t.PST_LIVE
            p.health = _DNet_ToInt(mo.health, 100)
            p.viewheight = VIEWHEIGHT
            p.viewz = _DNet_ToInt(mo.z, 0) + VIEWHEIGHT
            players[i] = p
          end if
        end if
      end if
    end if
    i = i + 1
  end while
end function

/// Builds one server snapshot payload for client replication.
/// @param forceAll Force all value supplied to `_DNet_MPBuildSnapshotPacket`.
/// @param snapshotTick Snapshot tick value supplied to `_DNet_MPBuildSnapshotPacket`.
/// @internal
function _DNet_MPBuildSnapshotPacket(forceAll, snapshotTick)
  global _dnet_mp_host_last_player_sig
  global _dnet_mp_host_removed_ids
  global _dnet_mp_host_last_sector_floor
  global _dnet_mp_host_last_sector_ceiling
  global _dnet_mp_host_last_sector_light
  global _dnet_mp_host_last_sector_special
  global _dnet_mp_host_last_side_top
  global _dnet_mp_host_last_side_bottom
  global _dnet_mp_host_last_side_mid
  global _dnet_mp_snap_cache_tick
  global _dnet_mp_snap_cache_force_all
  global _dnet_mp_snap_cache_player_rows
  global _dnet_mp_snap_cache_actor_ids
  global _dnet_mp_snap_cache_actor_refs
  global _dnet_mp_snap_cache_removed_ids
  global _dnet_mp_snap_cache_sector_rows
  global _dnet_mp_snap_cache_side_rows

  if not _DNet_IsSeq(_dnet_mp_host_last_player_sig) then _dnet_mp_host_last_player_sig = [] end if
  if len(_dnet_mp_host_last_player_sig) < MAXPLAYERS then
    _dnet_mp_host_last_player_sig = _dnet_mp_host_last_player_sig + array(MAXPLAYERS - len(_dnet_mp_host_last_player_sig), 0)
  end if

  cacheValid = _DNet_ToInt(_dnet_mp_snap_cache_tick, -1) == _DNet_ToInt(snapshotTick, 0)
  if cacheValid then
    if (forceAll and(not _dnet_mp_snap_cache_force_all)) or((not forceAll) and _dnet_mp_snap_cache_force_all) then
      cacheValid = false
    end if
  end if
  builtNow = not cacheValid

  playerRows = []
  actorIds = []
  actorRefs = []
  removedIds = []
  sectorRows = []
  sideRows = []

  if not cacheValid then
    slot = 0
    while slot < MAXPLAYERS
    if _DNet_MPIsHost() then
      _DNet_MPEnsureHostSlotMobj(slot)
    end if
    p = _DNet_MPEnsurePlayerStruct(slot)
    mo = void
    if typeof(p) == "struct" then mo = p.mo end if

    alive = false
    ingame = false
    if _DNet_IsSeq(playeringame) and slot < len(playeringame) then ingame = playeringame[slot] end if
    if ingame and typeof(mo) != "struct" and _DNet_MPIsHost() then
      _DNet_MPEnsureHostSlotMobj(slot)
      p = _DNet_MPEnsurePlayerStruct(slot)
      mo = void
      if typeof(p) == "struct" then mo = p.mo end if
    end if
    if typeof(p) == "struct" and _DNet_ToInt(p.health, 0) > 0 then alive = true end if
    if typeof(p) == "struct" and p.playerstate == playerstate_t.PST_DEAD then alive = false end if
    if ingame and typeof(mo) != "struct" then
      // Never advertise an ingame slot without a valid player mobj pose.
      ingame = false
      alive = false
    end if
    if typeof(p) == "struct" and typeof(mo) == "struct" and typeof(p.cmd) == "struct" then
      if _DNet_ToInt(p.cmd.forwardmove, 0) == 0 and _DNet_ToInt(p.cmd.sidemove, 0) == 0 then
        stidx = _DNet_StateIndex(mo.state)
        run0 = _DNet_StateIndex(statenum_t.S_PLAY_RUN1)
        if run0 >= 0 and stidx >= run0 and stidx < run0 + 4 and typeof(P_SetMobjState) == "function" then
          P_SetMobjState(mo, statenum_t.S_PLAY)
        end if
      end if
    end if

    px = 0
    py = 0
    pz = 0
    pang = 0
    mspr = 0
    mfrm = 0
    mstate = 0
    mflags = 0
    if typeof(mo) == "struct" then
      px = _DNet_ToInt(mo.x, 0)
      py = _DNet_ToInt(mo.y, 0)
      pz = _DNet_ToInt(mo.z, 0)
      pang = _DNet_ToInt(mo.angle, 0)
      mspr = _DNet_ToInt(mo.sprite, 0)
      mfrm = _DNet_ToInt(mo.frame, 0)
      mstate = _DNet_ToInt(_DNet_StateIndex(mo.state), 0)
      if mstate < 0 then mstate = 0 end if
      mflags = _DNet_ToInt(mo.flags, 0)
    end if

    phealth = 0
    parmor = 0
    pweapon = 0
    pkill = 0
    pitem = 0
    psecret = 0
    pcards = 0
    pweapons = 0
    pdamage = 0
    pbonus = 0
    pattack = 0
    fr0 = 0
    fr1 = 0
    fr2 = 0
    fr3 = 0
    a0 = 0
    a1 = 0
    a2 = 0
    a3 = 0
    wstate = 65535
    wtics = 0
    wsx = 0
    wsy = 0
    fstate = 65535
    ftics = 0
    fsx = 0
    fsy = 0
    if typeof(p) == "struct" then
      phealth = _DNet_ToInt(p.health, 0)
      parmor = _DNet_ToInt(p.armorpoints, 0)
      pweapon = _DNet_EnumIndex(p.readyweapon, NUMWEAPONS)
      if pweapon < 0 then pweapon = 0 end if
      pkill = _DNet_ToInt(p.killcount, 0)
      pitem = _DNet_ToInt(p.itemcount, 0)
      psecret = _DNet_ToInt(p.secretcount, 0)
      pdamage = _DNet_ToInt(p.damagecount, 0)
      pbonus = _DNet_ToInt(p.bonuscount, 0)
      if p.attackdown then pattack = 1 end if
      if _DNet_IsSeq(p.ammo) then
        if len(p.ammo) > 0 then a0 = _DNet_ToInt(p.ammo[0], 0) end if
        if len(p.ammo) > 1 then a1 = _DNet_ToInt(p.ammo[1], 0) end if
        if len(p.ammo) > 2 then a2 = _DNet_ToInt(p.ammo[2], 0) end if
        if len(p.ammo) > 3 then a3 = _DNet_ToInt(p.ammo[3], 0) end if
      end if
      if _DNet_IsSeq(p.cards) then
        ci = 0
        while ci < NUMCARDS and ci < len(p.cards) and ci < 16
          if p.cards[ci] then pcards = pcards | (1 << ci) end if
          ci = ci + 1
        end while
      end if
      if _DNet_IsSeq(p.weaponowned) then
        wi = 0
        while wi < NUMWEAPONS and wi < len(p.weaponowned) and wi < 16
          if p.weaponowned[wi] then pweapons = pweapons | (1 << wi) end if
          wi = wi + 1
        end while
      end if
      if _DNet_IsSeq(p.frags) then
        if len(p.frags) > 0 then fr0 = _DNet_ToInt(p.frags[0], 0) end if
        if len(p.frags) > 1 then fr1 = _DNet_ToInt(p.frags[1], 0) end if
        if len(p.frags) > 2 then fr2 = _DNet_ToInt(p.frags[2], 0) end if
        if len(p.frags) > 3 then fr3 = _DNet_ToInt(p.frags[3], 0) end if
      end if
      if _DNet_IsSeq(p.psprites) then
        if len(p.psprites) > 0 and typeof(p.psprites[0]) == "struct" then
          wps = p.psprites[0]
          wstate = _DNet_ToInt(_DNet_StateIndex(wps.state), 65535)
          if wstate < 0 then wstate = 65535 end if
          wtics = _DNet_ToInt(wps.tics, 0)
          wsx = _DNet_ToInt(wps.sx, 0)
          wsy = _DNet_ToInt(wps.sy, 0)
        end if
        if len(p.psprites) > 1 and typeof(p.psprites[1]) == "struct" then
          fps = p.psprites[1]
          fstate = _DNet_ToInt(_DNet_StateIndex(fps.state), 65535)
          if fstate < 0 then fstate = 65535 end if
          ftics = _DNet_ToInt(fps.tics, 0)
          fsx = _DNet_ToInt(fps.sx, 0)
          fsy = _DNet_ToInt(fps.sy, 0)
        end if
      end if
    end if

    pflags = 0
    if alive then pflags = pflags | 1 end if
    if ingame then pflags = pflags | 2 end if
    rowKey = [
    pflags,
    px, py, pz, pang,
    phealth, parmor, pweapon,
    pkill, pitem, psecret,
    a0, a1, a2, a3, pcards, pweapons,
    fr0, fr1, fr2, fr3,
    mspr, mfrm, mstate, mflags,
    pdamage, pbonus, pattack,
    wstate, wtics, wsx, wsy,
    fstate, ftics, fsx, fsy
  ]
    prevKey = _dnet_mp_host_last_player_sig[slot]
    changed = forceAll or (not _DNet_MPStateKeyEquals(prevKey, rowKey))
    if changed then
      playerRows = playerRows + [[slot, pflags, px, py, pz, pang, phealth, parmor, pweapon, a0, a1, a2, a3, pcards, pweapons, mspr, mfrm, mstate, mflags, pdamage, pbonus, pattack, wstate, wtics, wsx, wsy, fstate, ftics, fsx, fsy, pkill, pitem, psecret, fr0, fr1, fr2, fr3]]
      _dnet_mp_host_last_player_sig[slot] = rowKey
    end if
    slot = slot + 1
    end while

    _DNet_MPHostRefreshActorRegistry()
    actorPool = _DNET_MP_ACTOR_POOL_PER_SNAPSHOT
    if actorPool < _DNET_MP_MAX_ACTORS_PER_SNAPSHOT then actorPool = _DNET_MP_MAX_ACTORS_PER_SNAPSHOT end if
    actorPair = _DNet_MPHostCollectActorChunk(actorPool, forceAll, snapshotTick)
    actorIds = []
    actorRefs = []
    if _DNet_IsSeq(actorPair) and len(actorPair) >= 2 then
      if _DNet_IsSeq(actorPair[0]) then actorIds = actorPair[0] end if
      if _DNet_IsSeq(actorPair[1]) then actorRefs = actorPair[1] end if
    end if
    removedIds = _DNet_MPHostPopRemovedIds(_DNET_MP_MAX_REMOVED_PER_SNAPSHOT)
    sectorRows = _DNet_MPHostCollectSectorChanges(_DNET_MP_MAX_SECTORS_PER_SNAPSHOT, forceAll)
    sideRows = _DNet_MPHostCollectSideChanges(_DNET_MP_MAX_SIDES_PER_SNAPSHOT, forceAll)

    _dnet_mp_snap_cache_tick = _DNet_ToInt(snapshotTick, 0)
    _dnet_mp_snap_cache_force_all = forceAll
    _dnet_mp_snap_cache_player_rows = playerRows
    _dnet_mp_snap_cache_actor_ids = actorIds
    _dnet_mp_snap_cache_actor_refs = actorRefs
    _dnet_mp_snap_cache_removed_ids = removedIds
    _dnet_mp_snap_cache_sector_rows = sectorRows
    _dnet_mp_snap_cache_side_rows = sideRows
  else
    playerRows = _dnet_mp_snap_cache_player_rows
    actorIds = _dnet_mp_snap_cache_actor_ids
    actorRefs = _dnet_mp_snap_cache_actor_refs
    removedIds = _dnet_mp_snap_cache_removed_ids
    sectorRows = _dnet_mp_snap_cache_sector_rows
    sideRows = _dnet_mp_snap_cache_side_rows
  end if

  if not _DNet_IsSeq(playerRows) then playerRows = [] end if
  if not _DNet_IsSeq(actorIds) then actorIds = [] end if
  if not _DNet_IsSeq(actorRefs) then actorRefs = [] end if
  if not _DNet_IsSeq(removedIds) then removedIds = [] end if
  if not _DNet_IsSeq(sectorRows) then sectorRows = [] end if
  if not _DNet_IsSeq(sideRows) then sideRows = [] end if

  playerCount = len(playerRows)
  actorCount = len(actorIds)
  if len(actorRefs) < actorCount then actorCount = len(actorRefs) end if
  removedCount = len(removedIds)
  sectorCount = len(sectorRows)
  sideCount = len(sideRows)
  if playerCount > 255 then playerCount = 255 end if
  if actorCount > 255 then actorCount = 255 end if
  if removedCount > 255 then removedCount = 255 end if
  if sectorCount > 255 then sectorCount = 255 end if
  if sideCount > 255 then sideCount = 255 end if
  if (not forceAll) and playerCount == 0 and actorCount == 0 and removedCount == 0 and sectorCount == 0 and sideCount == 0 then
    return void
  end if

  // One actor row uses 34 bytes:
  // id(4), type(2), x/y/z/angle(16), sprite/frame/state(6), health(2), flags(4)
  // One player row uses _DNET_MP_PLAYER_ROW_BYTES bytes.
  // Counts retain their fixed offsets (6..10); leveltime follows them so the
  // client receives the map-local clock independently from global gametic.
  size = 15 + playerCount * _DNET_MP_PLAYER_ROW_BYTES + actorCount * 34 + removedCount * 4 + sectorCount * 14 + sideCount * 8
  minSideKeep = 0
  if sideCount > 0 then minSideKeep = 1 end if
  if forceAll then
    // For full snapshots, keep at least one sidedef row whenever possible (switch/button visual state).
    while size > _DNET_MP_PAYLOAD_BUDGET and actorCount > 0
      actorCount = actorCount - 1
      size = size - 34
    end while
    while size > _DNET_MP_PAYLOAD_BUDGET and removedCount > 0
      removedCount = removedCount - 1
      size = size - 4
    end while
    while size > _DNET_MP_PAYLOAD_BUDGET and sectorCount > 0
      sectorCount = sectorCount - 1
      size = size - 14
    end while
    while size > _DNET_MP_PAYLOAD_BUDGET and sideCount > minSideKeep
      sideCount = sideCount - 1
      size = size - 8
    end while
    while size > _DNET_MP_PAYLOAD_BUDGET and sideCount > 0
      sideCount = sideCount - 1
      size = size - 8
    end while
  else
    while size > _DNET_MP_PAYLOAD_BUDGET and actorCount > 0
      actorCount = actorCount - 1
      size = size - 34
    end while
    while size > _DNET_MP_PAYLOAD_BUDGET and removedCount > 0
      removedCount = removedCount - 1
      size = size - 4
    end while
    while size > _DNET_MP_PAYLOAD_BUDGET and sectorCount > 0
      sectorCount = sectorCount - 1
      size = size - 14
    end while
    while size > _DNET_MP_PAYLOAD_BUDGET and sideCount > minSideKeep
      sideCount = sideCount - 1
      size = size - 8
    end while
    while size > _DNET_MP_PAYLOAD_BUDGET and sideCount > 0
      sideCount = sideCount - 1
      size = size - 8
    end while
  end if

  if builtNow and actorCount < len(actorIds) then
    // Actor rows selected this tick but trimmed by packet budget must be marked dirty again.
    // Otherwise unchanged static actors can remain unsent for long periods.
    _DNet_MPHostRequeueDroppedActorRows(actorIds, actorCount)

    trimmedActorIds = array(actorCount, 0)
    trimmedActorRefs = array(actorCount)
    i = 0
    while i < actorCount
      trimmedActorIds[i] = _DNet_ToInt(actorIds[i], 0)
      if i < len(actorRefs) then trimmedActorRefs[i] = actorRefs[i] end if
      i = i + 1
    end while
    actorIds = trimmedActorIds
    actorRefs = trimmedActorRefs
    if _DNet_ToInt(_dnet_mp_snap_cache_tick, -1) == _DNet_ToInt(snapshotTick, 0) then
      _dnet_mp_snap_cache_actor_ids = actorIds
      _dnet_mp_snap_cache_actor_refs = actorRefs
    end if
  end if

  // If geometry rows were trimmed for payload budget, mark them dirty again so they
  // get retransmitted on following snapshots (prevents lost switch/sector states).
  if builtNow and sectorCount < len(sectorRows) then
    i = sectorCount
    while i < len(sectorRows)
      row = sectorRows[i]
      if _DNet_IsSeq(row) and len(row) >= 1 then
        sidx = _DNet_ToInt(row[0], -1)
        if sidx >= 0 then
          if sidx < len(_dnet_mp_host_last_sector_floor) then _dnet_mp_host_last_sector_floor[sidx] = -2147483648 end if
          if sidx < len(_dnet_mp_host_last_sector_ceiling) then _dnet_mp_host_last_sector_ceiling[sidx] = -2147483648 end if
          if sidx < len(_dnet_mp_host_last_sector_light) then _dnet_mp_host_last_sector_light[sidx] = -2147483648 end if
          if sidx < len(_dnet_mp_host_last_sector_special) then _dnet_mp_host_last_sector_special[sidx] = -2147483648 end if
        end if
      end if
      i = i + 1
    end while

    trimmedSectorRows = array(sectorCount)
    i = 0
    while i < sectorCount
      trimmedSectorRows[i] = sectorRows[i]
      i = i + 1
    end while
    sectorRows = trimmedSectorRows
    if _DNet_ToInt(_dnet_mp_snap_cache_tick, -1) == _DNet_ToInt(snapshotTick, 0) then
      _dnet_mp_snap_cache_sector_rows = sectorRows
    end if
  end if

  if builtNow and sideCount < len(sideRows) then
    i = sideCount
    while i < len(sideRows)
      row = sideRows[i]
      if _DNet_IsSeq(row) and len(row) >= 1 then
        sdidx = _DNet_ToInt(row[0], -1)
        if sdidx >= 0 then
          if sdidx < len(_dnet_mp_host_last_side_top) then _dnet_mp_host_last_side_top[sdidx] = -2147483648 end if
          if sdidx < len(_dnet_mp_host_last_side_bottom) then _dnet_mp_host_last_side_bottom[sdidx] = -2147483648 end if
          if sdidx < len(_dnet_mp_host_last_side_mid) then _dnet_mp_host_last_side_mid[sdidx] = -2147483648 end if
        end if
      end if
      i = i + 1
    end while

    trimmedSideRows = array(sideCount)
    i = 0
    while i < sideCount
      trimmedSideRows[i] = sideRows[i]
      i = i + 1
    end while
    sideRows = trimmedSideRows
    if _DNet_ToInt(_dnet_mp_snap_cache_tick, -1) == _DNet_ToInt(snapshotTick, 0) then
      _dnet_mp_snap_cache_side_rows = sideRows
    end if
  end if

  // Prevent dropped remove notifications: anything that does not fit gets re-queued for next snapshots.
  if builtNow and removedCount < len(removedIds) then
    overflowCount = len(removedIds) - removedCount
    if overflowCount < 0 then overflowCount = 0 end if
    overflow = array(overflowCount, 0)
    overflowUsed = 0
    i = removedCount
    while i < len(removedIds)
      rid = _DNet_ToInt(removedIds[i], 0)
      if rid > 0 and overflowUsed < len(overflow) then
        overflow[overflowUsed] = rid
        overflowUsed = overflowUsed + 1
      end if
      i = i + 1
    end while
    if overflowUsed > 0 then
      keepq = array(overflowUsed)
      i = 0
      while i < overflowUsed
        keepq[i] = overflow[i]
        i = i + 1
      end while
      if _DNet_IsSeq(_dnet_mp_host_removed_ids) then
        keepExtra = len(_dnet_mp_host_removed_ids)
        if keepExtra > 0 then
          keepq = keepq + array(keepExtra, 0)
          i = 0
          while i < keepExtra
            keepq[overflowUsed + i] = _DNet_ToInt(_dnet_mp_host_removed_ids[i], 0)
            i = i + 1
          end while
        end if
      end if
      _dnet_mp_host_removed_ids = keepq
    end if

    trimmedRemoved = array(removedCount, 0)
    i = 0
    while i < removedCount
      trimmedRemoved[i] = _DNet_ToInt(removedIds[i], 0)
      i = i + 1
    end while
    removedIds = trimmedRemoved
    if _DNet_ToInt(_dnet_mp_snap_cache_tick, -1) == _DNet_ToInt(snapshotTick, 0) then
      _dnet_mp_snap_cache_removed_ids = removedIds
    end if
  end if
  payload = bytes(size, 0)
  off = 0
  payload[off] = _DNET_MPMSG_SNAPSHOT
  off = off + 1
  flags = 0
  if forceAll then flags = flags | 1 end if
  payload[off] = flags
  off = off + 1
  _DNet_MPWriteU32(payload, off, snapshotTick)
  off = off + 4
  payload[off] = playerCount & 255
  off = off + 1
  payload[off] = actorCount & 255
  off = off + 1
  payload[off] = removedCount & 255
  off = off + 1
  payload[off] = sectorCount & 255
  off = off + 1
  payload[off] = sideCount & 255
  off = off + 1
  _DNet_MPWriteU32(payload, off, _DNet_ToInt(leveltime, 0))
  off = off + 4

  i = 0
  while i < playerCount
    row = playerRows[i]
    slot = _DNet_ToInt(row[0], 0)
    pflags = _DNet_ToInt(row[1], 0)
    px = _DNet_ToInt(row[2], 0)
    py = _DNet_ToInt(row[3], 0)
    pz = _DNet_ToInt(row[4], 0)
    pang = _DNet_ToInt(row[5], 0)
    phealth = _DNet_ToInt(row[6], 0)
    parmor = _DNet_ToInt(row[7], 0)
    pweapon = _DNet_ToInt(row[8], 0)
    a0 = _DNet_ToInt(row[9], 0)
    a1 = _DNet_ToInt(row[10], 0)
    a2 = _DNet_ToInt(row[11], 0)
    a3 = _DNet_ToInt(row[12], 0)
    pcards = _DNet_ToInt(row[13], 0)
    pweapons = _DNet_ToInt(row[14], 0)
    mspr = _DNet_ToInt(row[15], 0)
    mfrm = _DNet_ToInt(row[16], 0)
    mstate = _DNet_ToInt(row[17], 0)
    mflags = _DNet_ToInt(row[18], 0)
    pdamage = _DNet_ToInt(row[19], 0)
    pbonus = _DNet_ToInt(row[20], 0)
    pattack = _DNet_ToInt(row[21], 0)
    wstate = _DNet_ToInt(row[22], 0)
    wtics = _DNet_ToInt(row[23], 0)
    wsx = _DNet_ToInt(row[24], 0)
    wsy = _DNet_ToInt(row[25], 0)
    fstate = _DNet_ToInt(row[26], 0)
    ftics = _DNet_ToInt(row[27], 0)
    fsx = _DNet_ToInt(row[28], 0)
    fsy = _DNet_ToInt(row[29], 0)
    pkill = _DNet_ToInt(row[30], 0)
    pitem = _DNet_ToInt(row[31], 0)
    psecret = _DNet_ToInt(row[32], 0)
    fr0 = _DNet_ToInt(row[33], 0)
    fr1 = _DNet_ToInt(row[34], 0)
    fr2 = _DNet_ToInt(row[35], 0)
    fr3 = _DNet_ToInt(row[36], 0)

    payload[off] = slot & 255
    off = off + 1
    payload[off] = pflags & 255
    off = off + 1
    _DNet_MPWriteI32(payload, off, px)
    off = off + 4
    _DNet_MPWriteI32(payload, off, py)
    off = off + 4
    _DNet_MPWriteI32(payload, off, pz)
    off = off + 4
    _DNet_MPWriteI32(payload, off, pang)
    off = off + 4
    _DNet_MPWriteI16(payload, off, phealth)
    off = off + 2
    _DNet_MPWriteI16(payload, off, parmor)
    off = off + 2
    payload[off] = pweapon & 255
    off = off + 1
    _DNet_MPWriteU16(payload, off, a0)
    off = off + 2
    _DNet_MPWriteU16(payload, off, a1)
    off = off + 2
    _DNet_MPWriteU16(payload, off, a2)
    off = off + 2
    _DNet_MPWriteU16(payload, off, a3)
    off = off + 2
    _DNet_MPWriteU16(payload, off, pcards)
    off = off + 2
    _DNet_MPWriteU16(payload, off, pweapons)
    off = off + 2
    _DNet_MPWriteU16(payload, off, mspr)
    off = off + 2
    _DNet_MPWriteU16(payload, off, mfrm)
    off = off + 2
    _DNet_MPWriteU16(payload, off, mstate)
    off = off + 2
    _DNet_MPWriteU32(payload, off, mflags)
    off = off + 4
    _DNet_MPWriteI16(payload, off, pdamage)
    off = off + 2
    _DNet_MPWriteI16(payload, off, pbonus)
    off = off + 2
    payload[off] = pattack & 255
    off = off + 1
    _DNet_MPWriteU16(payload, off, wstate)
    off = off + 2
    _DNet_MPWriteI16(payload, off, wtics)
    off = off + 2
    _DNet_MPWriteI32(payload, off, wsx)
    off = off + 4
    _DNet_MPWriteI32(payload, off, wsy)
    off = off + 4
    _DNet_MPWriteU16(payload, off, fstate)
    off = off + 2
    _DNet_MPWriteI16(payload, off, ftics)
    off = off + 2
    _DNet_MPWriteI32(payload, off, fsx)
    off = off + 4
    _DNet_MPWriteI32(payload, off, fsy)
    off = off + 4
    _DNet_MPWriteI16(payload, off, pkill)
    off = off + 2
    _DNet_MPWriteI16(payload, off, pitem)
    off = off + 2
    _DNet_MPWriteI16(payload, off, psecret)
    off = off + 2
    _DNet_MPWriteI16(payload, off, fr0)
    off = off + 2
    _DNet_MPWriteI16(payload, off, fr1)
    off = off + 2
    _DNet_MPWriteI16(payload, off, fr2)
    off = off + 2
    _DNet_MPWriteI16(payload, off, fr3)
    off = off + 2
    i = i + 1
  end while

  i = 0
  while i < actorCount and i < len(actorRefs)
    aid = _DNet_ToInt(actorIds[i], 0)
    mo = actorRefs[i]
    payloadType = 0
    x = 0
    y = 0
    z = 0
    ang = 0
    spr = 0
    frm = 0
    st = 0
    hp = 0
    fl = 0
    if typeof(mo) == "struct" then
      payloadType = _DNet_ToInt(mo.type, 0)
      x = _DNet_ToInt(mo.x, 0)
      y = _DNet_ToInt(mo.y, 0)
      z = _DNet_ToInt(mo.z, 0)
      ang = _DNet_ToInt(mo.angle, 0)
      spr = _DNet_ToInt(mo.sprite, 0)
      frm = _DNet_ToInt(mo.frame, 0)
      st = _DNet_ToInt(_DNet_StateIndex(mo.state), 0)
      if st < 0 then st = 0 end if
      hp = _DNet_ToInt(mo.health, 0)
      fl = _DNet_ToInt(mo.flags, 0)
    end if

    _DNet_MPWriteU32(payload, off, aid)
    off = off + 4
    _DNet_MPWriteU16(payload, off, payloadType)
    off = off + 2
    _DNet_MPWriteI32(payload, off, x)
    off = off + 4
    _DNet_MPWriteI32(payload, off, y)
    off = off + 4
    _DNet_MPWriteI32(payload, off, z)
    off = off + 4
    _DNet_MPWriteI32(payload, off, ang)
    off = off + 4
    _DNet_MPWriteU16(payload, off, spr)
    off = off + 2
    _DNet_MPWriteU16(payload, off, frm)
    off = off + 2
    _DNet_MPWriteU16(payload, off, st)
    off = off + 2
    _DNet_MPWriteI16(payload, off, hp)
    off = off + 2
    _DNet_MPWriteU32(payload, off, fl)
    off = off + 4
    i = i + 1
  end while

  i = 0
  while i < removedCount
    _DNet_MPWriteU32(payload, off, _DNet_ToInt(removedIds[i], 0))
    off = off + 4
    i = i + 1
  end while

  i = 0
  while i < sectorCount
    row = sectorRows[i]
    if _DNet_IsSeq(row) and len(row) >= 5 then
      _DNet_MPWriteU16(payload, off, _DNet_ToInt(row[0], 0))
      off = off + 2
      _DNet_MPWriteI32(payload, off, _DNet_ToInt(row[1], 0))
      off = off + 4
      _DNet_MPWriteI32(payload, off, _DNet_ToInt(row[2], 0))
      off = off + 4
      _DNet_MPWriteU16(payload, off, _DNet_ToInt(row[3], 0))
      off = off + 2
      _DNet_MPWriteU16(payload, off, _DNet_ToInt(row[4], 0))
      off = off + 2
    end if
    i = i + 1
  end while

  i = 0
  while i < sideCount
    row = sideRows[i]
    if _DNet_IsSeq(row) and len(row) >= 4 then
      _DNet_MPWriteU16(payload, off, _DNet_ToInt(row[0], 0))
      off = off + 2
      _DNet_MPWriteU16(payload, off, _DNet_ToInt(row[1], 0))
      off = off + 2
      _DNet_MPWriteU16(payload, off, _DNet_ToInt(row[2], 0))
      off = off + 2
      _DNet_MPWriteU16(payload, off, _DNet_ToInt(row[3], 0))
      off = off + 2
    end if
    i = i + 1
  end while

  return payload
end function

/// Computes adaptive snapshot cadence based on active replicated actor load.
/// @internal
function inline _DNet_MPHostSnapshotInterval()
  interval = _DNET_MP_SNAPSHOT_INTERVAL
  active = _DNet_ToInt(_dnet_mp_host_actor_active_count, 0)

  // Adapt cadence to actor load.
  if active >= 512 then
    interval = 3
  else if active >= 384 then
    interval = 2
  end if

  // Adapt cadence to number of remote peers.
  peers = 0
  slots = _DNet_MPActiveSlots()
  if _DNet_IsSeq(slots) then
    i = 0
    while i < len(slots)
      s = _DNet_ToInt(slots[i], -1)
      if s >= 1 and s < MAXPLAYERS then peers = peers + 1 end if
      i = i + 1
    end while
  end if
  if peers >= 3 and active >= 384 and interval < 2 then
    interval = 2
  end if

  if interval < 1 then interval = 1 end if
  if interval > 3 then interval = 3 end if
  return interval
end function

/// Sends periodic world snapshots from authoritative host to all clients.
/// @param forceAll Force all value supplied to `_DNet_MPHostMaybeSendSnapshot`.
/// @internal
function _DNet_MPHostMaybeSendSnapshot(forceAll)
  global _dnet_mp_last_snapshot_tic
  global _dnet_mp_host_slot_fullsync_burst
  global _dnet_mp_host_removed_ids
  global _dnet_mp_dbg_snap_calls
  global _dnet_mp_dbg_snap_skip_not_host
  global _dnet_mp_dbg_snap_skip_not_level
  global _dnet_mp_dbg_snap_skip_nosend
  global _dnet_mp_dbg_snap_skip_rate
  global _dnet_mp_dbg_snap_built
  global _dnet_mp_dbg_snap_targets
  global _dnet_mp_dbg_snap_sent
  _dnet_mp_dbg_snap_calls = _DNet_ToInt(_dnet_mp_dbg_snap_calls, 0) + 1
  if not _DNet_MPIsHost() then
    _dnet_mp_dbg_snap_skip_not_host = _DNet_ToInt(_dnet_mp_dbg_snap_skip_not_host, 0) + 1
    return
  end if
  if gamestate != gamestate_t.GS_LEVEL or not _DNet_MPLevelReady() then
    _dnet_mp_dbg_snap_skip_not_level = _DNet_ToInt(_dnet_mp_dbg_snap_skip_not_level, 0) + 1
    return
  end if
  if typeof(MP_PlatformNetSend) != "function" then
    _dnet_mp_dbg_snap_skip_nosend = _DNet_ToInt(_dnet_mp_dbg_snap_skip_nosend, 0) + 1
    return
  end if
  _DNet_MPHostApplyActiveSlots()
  active = _DNet_MPActiveSlots()
  hasRemote = false
  i = 0
  while i < len(active)
    slot = _DNet_ToInt(active[i], -1)
    if slot >= 1 and slot < MAXPLAYERS then
      hasRemote = true
      break
    end if
    i = i + 1
  end while
  if not hasRemote then
    if _DNet_IsSeq(_dnet_mp_host_removed_ids) and len(_dnet_mp_host_removed_ids) > 0 then
      _dnet_mp_host_removed_ids = []
    end if
    return
  end if

  gt = _DNet_ToInt(gametic, 0)
  snapInterval = _DNet_MPHostSnapshotInterval()
  if snapInterval < 1 then snapInterval = 1 end if
  if (not forceAll) and (gt - _DNet_ToInt(_dnet_mp_last_snapshot_tic, 0) < snapInterval) then
    _dnet_mp_dbg_snap_skip_rate = _DNet_ToInt(_dnet_mp_dbg_snap_skip_rate, 0) + 1
    return
  end if
  remoteSlots = []
  needFullRows = []
  anyNeedFull = forceAll
  allNeedFull = true
  i = 0
  while i < len(active)
    slot = _DNet_ToInt(active[i], -1)
    if slot >= 1 and slot < MAXPLAYERS then
      needFull = forceAll
      if (not needFull) and _DNet_IsSeq(_dnet_mp_host_slot_fullsync_burst) and slot < len(_dnet_mp_host_slot_fullsync_burst) then
        if _DNet_ToInt(_dnet_mp_host_slot_fullsync_burst[slot], 0) > 0 then
          needFull = true
        end if
      end if
      remoteSlots = remoteSlots + [slot]
      if needFull then
        needFullRows = needFullRows + [1]
        anyNeedFull = true
      else
        needFullRows = needFullRows + [0]
        allNeedFull = false
      end if
    end if
    i = i + 1
  end while

  payloadFull = void
  payloadDelta = void
  if anyNeedFull then
    payloadFull = _DNet_MPBuildSnapshotPacket(true, gt)
    if typeof(payloadFull) == "bytes" then
      _dnet_mp_dbg_snap_built = _DNet_ToInt(_dnet_mp_dbg_snap_built, 0) + 1
    end if
  end if
  if (not forceAll) and (not allNeedFull) then
    if anyNeedFull then
      // Building a full packet consumes the global delta caches. Reuse that
      // packet for established clients during a join burst so they cannot miss
      // changes removed from a subsequently built delta packet.
      payloadDelta = payloadFull
    else
      payloadDelta = _DNet_MPBuildSnapshotPacket(false, gt)
      if typeof(payloadDelta) == "bytes" then
        _dnet_mp_dbg_snap_built = _DNet_ToInt(_dnet_mp_dbg_snap_built, 0) + 1
      end if
    end if
  end if

  i = 0
  while i < len(remoteSlots)
    slot = _DNet_ToInt(remoteSlots[i], -1)
    if slot >= 1 and slot < MAXPLAYERS then
      needFull = false
      if i < len(needFullRows) then needFull = needFullRows[i] != 0 end if
      payload = payloadDelta
      if needFull then payload = payloadFull end if
      _dnet_mp_dbg_snap_targets = _DNet_ToInt(_dnet_mp_dbg_snap_targets, 0) + 1
      if typeof(payload) == "bytes" then
        if MP_PlatformNetSend(slot, payload) then
          _dnet_mp_dbg_snap_sent = _DNet_ToInt(_dnet_mp_dbg_snap_sent, 0) + 1
          if needFull and _DNet_IsSeq(_dnet_mp_host_slot_fullsync_burst) and slot < len(_dnet_mp_host_slot_fullsync_burst) then
            left = _DNet_ToInt(_dnet_mp_host_slot_fullsync_burst[slot], 0)
            if left > 0 then _dnet_mp_host_slot_fullsync_burst[slot] = left - 1 end if
          end if
        end if
      end if
    end if
    i = i + 1
  end while
  _dnet_mp_last_snapshot_tic = gt
end function

/// Applies one host kill-feed packet on client HUD.
/// @param payload Payload value supplied to `_DNet_MPClientApplyFeed`.
/// @internal
function _DNet_MPClientApplyFeed(payload)
  if typeof(payload) != "bytes" or len(payload) < 4 then return end if
  if (payload[0] & 255) != _DNET_MPMSG_FEED then return end if
  code = payload[1] & 255
  killer = payload[2] & 255
  victim = payload[3] & 255
  msg = ""
  if code == 1 then
    msg = _DNet_MPPlayerName(killer) + " killed " + _DNet_MPPlayerName(victim)
  else if code == 2 then
    msg = _DNet_MPPlayerName(killer) + " telefragged " + _DNet_MPPlayerName(victim)
  else
    return
  end if
  if _DNet_IsSeq(players) and consoleplayer >= 0 and consoleplayer < len(players) and typeof(players[consoleplayer]) == "struct" then
    p = players[consoleplayer]
    p.message = msg
    players[consoleplayer] = p
  end if
end function

/// Applies host phase sync packets (level/intermission/finale) on client.
/// @param payload Payload value supplied to `_DNet_MPClientApplyPhase`.
/// @internal
function _DNet_MPClientApplyPhase(payload)
  global _dnet_mp_client_last_phase_tick
  global _dnet_mp_client_last_snapshot_tick
  global _dnet_mp_client_world_bootstrapped
  global _dnet_mp_client_pending_snapshot
  global _dnet_mp_client_actor_ids
  global _dnet_mp_client_actor_refs
  global _dnet_mp_client_actor_miss
  global _dnet_mp_client_player_tx
  global _dnet_mp_client_player_ty
  global _dnet_mp_client_player_tz
  global _dnet_mp_client_player_tang
  global _dnet_mp_client_player_vx
  global _dnet_mp_client_player_vy
  global _dnet_mp_client_player_vz
  global _dnet_mp_client_player_last_snap_tic
  global _dnet_mp_client_ui_tic
  global _dnet_mp_client_wait_wistats
  global _dnet_mp_client_have_wistats
  global _dnet_mp_client_wistats_last_tick
  global _dnet_mp_client_wistats_next_req_tic
  global _dnet_mp_client_wistats_req_count
  global _dnet_mp_client_wistats_error
  global _dnet_mp_client_cached_wistats
  global deathmatch
  global consoleplayer
  global displayplayer
  global gameepisode
  global gamemap
  global gameskill
  global secretexit
  global gamestate
  global gameaction
  global wminfo
  if typeof(payload) != "bytes" or len(payload) < 16 then return end if
  if (payload[0] & 255) != _DNET_MPMSG_PHASE then return end if

  hostTick = _DNet_MPReadU32(payload, 8)
  if hostTick < _DNet_ToInt(_dnet_mp_client_last_phase_tick, 0) then return end if
  _dnet_mp_client_last_phase_tick = hostTick

  phase = payload[1] & 255
  ep = payload[2] & 255
  mp = payload[3] & 255
  nxt = payload[4] & 255
  sk = payload[5] & 255
  flags = payload[6] & 255

  if ep < 1 then ep = 1 end if
  if mp < 1 then mp = 1 end if
  if nxt < 1 then nxt = mp end if
  prevEp = _DNet_ToInt(gameepisode, 1)
  prevMap = _DNet_ToInt(gamemap, 1)
  prevState = gamestate
  mapChanged = prevEp != ep or prevMap != mp

  deathmatch = (flags & 1) != 0
  secretexit = (flags & 2) != 0

  if phase == 0 then
    loaded = false
    if prevState == gamestate_t.GS_INTERMISSION or gamestate != gamestate_t.GS_LEVEL or mapChanged then
      if typeof(G_InitNew) == "function" then
        G_InitNew(sk, ep, mp)
        loaded = true
      end if
    end if
    gameepisode = ep
    gamemap = mp
    gameskill = sk
    if loaded then
      _dnet_mp_client_world_bootstrapped = false
      _dnet_mp_client_pending_snapshot = void
      _dnet_mp_client_last_snapshot_tick = 0
      _dnet_mp_client_actor_ids = []
      _dnet_mp_client_actor_refs = []
      _dnet_mp_client_actor_miss = []
      _dnet_mp_client_player_tx = []
      _dnet_mp_client_player_ty = []
      _dnet_mp_client_player_tz = []
      _dnet_mp_client_player_tang = []
      _dnet_mp_client_player_vx = []
      _dnet_mp_client_player_vy = []
      _dnet_mp_client_player_vz = []
      _dnet_mp_client_player_last_snap_tic = []
      _dnet_mp_client_ui_tic = -1
      _dnet_mp_client_wait_wistats = false
      _dnet_mp_client_have_wistats = false
      _dnet_mp_client_wistats_last_tick = -1
      _dnet_mp_client_wistats_next_req_tic = 0
      _dnet_mp_client_wistats_req_count = 0
      _dnet_mp_client_wistats_error = ""
      _dnet_mp_client_cached_wistats = void
      // Reset dead client-side player proxies so the next map always starts from host-authoritative live state.
      i = 0
      while i < MAXPLAYERS and _DNet_IsSeq(players) and i < len(players)
        if typeof(players[i]) == "struct" then
          p = players[i]
          wasDead = (p.playerstate == playerstate_t.PST_DEAD) or (_DNet_ToInt(p.health, 0) <= 0)
          if wasDead then
            if typeof(p.mo) == "struct" and typeof(P_RemoveMobj) == "function" then P_RemoveMobj(p.mo) end if
            p.mo = void
            // Keep level-transition inventory semantics; do not trigger reborn loadout reset.
            p.playerstate = playerstate_t.PST_LIVE
            if _DNet_ToInt(p.health, 0) < 100 then p.health = 100 end if
            p.damagecount = 0
            p.bonuscount = 0
            players[i] = p
          end if
        end if
        i = i + 1
      end while
    end if
    if gamestate != gamestate_t.GS_LEVEL then gamestate = gamestate_t.GS_LEVEL end if
    gameaction = gameaction_t.ga_nothing
    return
  end if

  if phase == 1 then
    localSlot = _DNet_ToInt(consoleplayer, 0)
    if typeof(MP_PlatformGetLocalPlayerSlot) == "function" then
      localSlot = _DNet_ToInt(MP_PlatformGetLocalPlayerSlot(), localSlot)
    end if
    if localSlot < 0 then localSlot = 0 end if
    if localSlot >= MAXPLAYERS then localSlot = MAXPLAYERS - 1 end if
    consoleplayer = localSlot
    displayplayer = localSlot
    gameepisode = ep
    gamemap = mp
    gameskill = sk
    if typeof(wminfo) == "struct" then
      wi = wminfo
      wi.next = nxt - 1
      wminfo = wi
    end if
    gamestate = gamestate_t.GS_INTERMISSION
    gameaction = gameaction_t.ga_nothing
    _dnet_mp_client_pending_snapshot = void
    if prevState == gamestate_t.GS_INTERMISSION and(not mapChanged) then
      // Ignore periodic host phase refresh while already in this intermission.
      return
    end if
    i = 0
    while i < MAXPLAYERS and _DNet_IsSeq(players) and i < len(players)
      if typeof(players[i]) == "struct" then
        p = players[i]
        p.attackdown = true
        p.usedown = true
        p.cmd = ticcmd_t(0, 0, 0, 0, 0, 0)
        players[i] = p
      end if
      i = i + 1
    end while
    _dnet_mp_client_ui_tic = -1
    _dnet_mp_client_wistats_last_tick = -1
    _dnet_mp_client_wistats_req_count = 0
    _dnet_mp_client_wistats_next_req_tic = _DNet_ToInt(gametic, 0)
    _dnet_mp_client_wistats_error = ""
    _dnet_mp_client_have_wistats = false
    _dnet_mp_client_wait_wistats = true
    if typeof(WI_End) == "function" then WI_End() end if
    _DNet_MPClientUpdateWIStatsSync()
    return
  end if

  if phase == 2 then
    gameepisode = ep
    gamemap = mp
    gameskill = sk
    if gamestate != gamestate_t.GS_FINALE and typeof(F_StartFinale) == "function" then
      F_StartFinale()
    end if
    gamestate = gamestate_t.GS_FINALE
    gameaction = gameaction_t.ga_nothing
    _dnet_mp_client_pending_snapshot = void
    _dnet_mp_client_wait_wistats = false
    _dnet_mp_client_have_wistats = false
    _dnet_mp_client_wistats_last_tick = -1
    _dnet_mp_client_wistats_req_count = 0
    _dnet_mp_client_wistats_next_req_tic = 0
    _dnet_mp_client_wistats_error = ""
    _dnet_mp_client_cached_wistats = void
  end if
end function

/// Applies one authoritative world snapshot on client runtime.
/// @param payload Payload value supplied to `_DNet_MPClientApplySnapshot`.
/// @internal
function _DNet_MPClientApplySnapshot(payload)
  global _dnet_mp_client_last_snapshot_tick
  global _dnet_mp_client_pending_snapshot
  global _dnet_mp_client_world_bootstrapped
  global _dnet_mp_client_actor_miss
  global _dnet_mp_client_actor_ids
  global _dnet_mp_client_actor_refs
  global _dnet_mp_client_local_pickups_armed
  global _dnet_mp_client_seen_players
  global _dnet_mp_client_claimed_actors
  global gametic
  global leveltime
  global gamestate
  if typeof(payload) != "bytes" or len(payload) < 15 then return end if
  if len(payload) > _DNET_MP_PAYLOAD_BUDGET then return end if
  if (payload[0] & 255) != _DNET_MPMSG_SNAPSHOT then return end if
  if gamestate != gamestate_t.GS_LEVEL then
    _dnet_mp_client_pending_snapshot = payload
    return
  end if
  if not _DNet_MPLevelReady() then
    _dnet_mp_client_pending_snapshot = payload
    return
  end if
  _dnet_mp_client_pending_snapshot = void

  flags = payload[1] & 255
  snapTick = _DNet_MPReadU32(payload, 2)
  pcount = payload[6] & 255
  acount = payload[7] & 255
  rcount = payload[8] & 255
  scount = payload[9] & 255
  sdcount = payload[10] & 255
  // Keep in sync with _DNet_MPBuildSnapshotPacket row sizes.
  need = 15 + pcount * _DNET_MP_PLAYER_ROW_BYTES + acount * 34 + rcount * 4 + scount * 14 + sdcount * 8
  // Datagram payloads are exact-sized. Reject malformed trailing/truncated
  // snapshots before advancing clocks, otherwise one corrupt high tick can
  // make all later valid snapshots appear stale.
  if len(payload) != need then return end if
  if snapTick <= _DNet_ToInt(_dnet_mp_client_last_snapshot_tick, 0) then return end if
  hostLevelTime = _DNet_MPReadU32(payload, 11)
  _dnet_mp_client_last_snapshot_tick = snapTick
  gametic = snapTick
  leveltime = hostLevelTime

  if (not _dnet_mp_client_world_bootstrapped) and(acount > 0 or rcount > 0) then
    _DNet_MPClientBootstrapWorld()
    _dnet_mp_client_world_bootstrapped = true
  end if

  if typeof(_dnet_mp_client_seen_players) != "bytes" or len(_dnet_mp_client_seen_players) < MAXPLAYERS then
    _dnet_mp_client_seen_players = bytes(MAXPLAYERS, 0)
  else
    i = 0
    while i < MAXPLAYERS
      _dnet_mp_client_seen_players[i] = 0
      i = i + 1
    end while
  end if
  claimedNeed = len(_dnet_mp_client_actor_ids) + acount + 4
  if typeof(_dnet_mp_client_claimed_actors) != "bytes" or len(_dnet_mp_client_claimed_actors) < claimedNeed then
    _dnet_mp_client_claimed_actors = bytes(claimedNeed, 0)
  else
    i = 0
    while i < claimedNeed
      _dnet_mp_client_claimed_actors[i] = 0
      i = i + 1
    end while
  end if
  seenPlayers = _dnet_mp_client_seen_players
  claimedActors = _dnet_mp_client_claimed_actors

  off = 15
  i = 0
  while i < pcount
    slot = payload[off] & 255
    off = off + 1
    pflags = payload[off] & 255
    off = off + 1
    px = _DNet_MPReadI32(payload, off)
    off = off + 4
    py = _DNet_MPReadI32(payload, off)
    off = off + 4
    pz = _DNet_MPReadI32(payload, off)
    off = off + 4
    pang = _DNet_MPReadI32(payload, off)
    off = off + 4
    phealth = _DNet_MPReadI16(payload, off)
    off = off + 2
    parmor = _DNet_MPReadI16(payload, off)
    off = off + 2
    pweapon = payload[off] & 255
    off = off + 1
    a0 = _DNet_MPReadU16(payload, off)
    off = off + 2
    a1 = _DNet_MPReadU16(payload, off)
    off = off + 2
    a2 = _DNet_MPReadU16(payload, off)
    off = off + 2
    a3 = _DNet_MPReadU16(payload, off)
    off = off + 2
    pcards = _DNet_MPReadU16(payload, off)
    off = off + 2
    pweapons = _DNet_MPReadU16(payload, off)
    off = off + 2
    mspr = _DNet_MPReadU16(payload, off)
    off = off + 2
    mfrm = _DNet_MPReadU16(payload, off)
    off = off + 2
    mstate = _DNet_MPReadU16(payload, off)
    off = off + 2
    mflags = _DNet_MPReadU32(payload, off)
    off = off + 4
    pdamage = _DNet_MPReadI16(payload, off)
    off = off + 2
    pbonus = _DNet_MPReadI16(payload, off)
    off = off + 2
    pattack = payload[off] & 255
    off = off + 1
    wstate = _DNet_MPReadU16(payload, off)
    off = off + 2
    wtics = _DNet_MPReadI16(payload, off)
    off = off + 2
    wsx = _DNet_MPReadI32(payload, off)
    off = off + 4
    wsy = _DNet_MPReadI32(payload, off)
    off = off + 4
    fstate = _DNet_MPReadU16(payload, off)
    off = off + 2
    ftics = _DNet_MPReadI16(payload, off)
    off = off + 2
    fsx = _DNet_MPReadI32(payload, off)
    off = off + 4
    fsy = _DNet_MPReadI32(payload, off)
    off = off + 4
    pkill = _DNet_MPReadI16(payload, off)
    off = off + 2
    pitem = _DNet_MPReadI16(payload, off)
    off = off + 2
    psecret = _DNet_MPReadI16(payload, off)
    off = off + 2
    fr0 = _DNet_MPReadI16(payload, off)
    off = off + 2
    fr1 = _DNet_MPReadI16(payload, off)
    off = off + 2
    fr2 = _DNet_MPReadI16(payload, off)
    off = off + 2
    fr3 = _DNet_MPReadI16(payload, off)
    off = off + 2

    if slot >= 0 and slot < MAXPLAYERS then
      seenPlayers[slot] = 1
      ingame = (pflags & 2) != 0
      invalidPose = (px == 0 and py == 0 and pz == 0 and pang == 0 and mspr == 0 and mfrm == 0 and mstate == 0)
      if slot == consoleplayer and not ingame then
        // Keep local player slot alive when host temporarily omits/invalidates local pose.
        _DNet_MPSetPlayerSlotActive(slot, true)
        ingame = true
      else
        _DNet_MPSetPlayerSlotActive(slot, ingame)
      end if
      if ingame then
        p = _DNet_MPEnsurePlayerStruct(slot)
        if typeof(p) == "struct" then
          localPickup = false
          localWeaponPickup = false
          if slot == consoleplayer and _dnet_mp_client_local_pickups_armed then
            oldHealth = _DNet_ToInt(p.health, 0)
            oldArmor = _DNet_ToInt(p.armorpoints, 0)
            oldItem = _DNet_ToInt(p.itemcount, 0)
            oldA0 = 0
            oldA1 = 0
            oldA2 = 0
            oldA3 = 0
            if _DNet_IsSeq(p.ammo) then
              if len(p.ammo) > 0 then oldA0 = _DNet_ToInt(p.ammo[0], 0) end if
              if len(p.ammo) > 1 then oldA1 = _DNet_ToInt(p.ammo[1], 0) end if
              if len(p.ammo) > 2 then oldA2 = _DNet_ToInt(p.ammo[2], 0) end if
              if len(p.ammo) > 3 then oldA3 = _DNet_ToInt(p.ammo[3], 0) end if
            end if
            if phealth > oldHealth or parmor > oldArmor or pitem > oldItem or a0 > oldA0 or a1 > oldA1 or a2 > oldA2 or a3 > oldA3 then
              localPickup = true
            end if
            if _DNet_IsSeq(p.cards) then
              ciOld = 0
              while ciOld < NUMCARDS and ciOld < len(p.cards) and ciOld < 16
                bit = 1 << ciOld
                if (pcards & bit) != 0 and not p.cards[ciOld] then
                  localPickup = true
                end if
                ciOld = ciOld + 1
              end while
            end if
            if _DNet_IsSeq(p.weaponowned) then
              wiOld = 0
              while wiOld < NUMWEAPONS and wiOld < len(p.weaponowned) and wiOld < 16
                bit = 1 << wiOld
                if (pweapons & bit) != 0 and not p.weaponowned[wiOld] then
                  localPickup = true
                  localWeaponPickup = true
                end if
                wiOld = wiOld + 1
              end while
            end if
          end if
          mo = p.mo
          playerSpawnedNow = false
          keepLocalPose = (slot == consoleplayer) and invalidPose and (typeof(mo) == "struct") and (mo.subsector is not void)
          if (not keepLocalPose) and mo is void and typeof(P_SpawnMobj) == "function" then
            sx = px
            sy = py
            sz = pz
            if invalidPose then
              sz = ONFLOORZ
              if typeof(playerstarts) == "array" and slot >= 0 and slot < len(playerstarts) and typeof(playerstarts[slot]) == "struct" and _DNet_ToInt(playerstarts[slot].type, 0) >= 1 then
                sx = _DNet_ToInt(playerstarts[slot].x, 0) << FRACBITS
                sy = _DNet_ToInt(playerstarts[slot].y, 0) << FRACBITS
              else if typeof(playerstarts) == "array" and len(playerstarts) > 0 and typeof(playerstarts[0]) == "struct" then
                sx = (_DNet_ToInt(playerstarts[0].x, 0) << FRACBITS) + ((64 * slot) * FRACUNIT)
                sy = (_DNet_ToInt(playerstarts[0].y, 0) << FRACBITS) + ((48 * slot) * FRACUNIT)
              end if
            end if
            mo = P_SpawnMobj(sx, sy, sz, mobjtype_t.MT_PLAYER)
            if typeof(mo) == "struct" then
              playerSpawnedNow = true
              mo.player = p
              p.mo = mo
            end if
          end if
          if (not keepLocalPose) and typeof(mo) == "struct" then
            if slot == consoleplayer then
              moved = _DNet_ToInt(mo.x, 0) != px or _DNet_ToInt(mo.y, 0) != py or _DNet_ToInt(mo.z, 0) != pz
              if moved and typeof(P_UnsetThingPosition) == "function" then P_UnsetThingPosition(mo) end if
              if moved then
                mo.x = px
                mo.y = py
                mo.z = pz
              end if
              mo.angle = pang
              if moved and typeof(P_SetThingPosition) == "function" then P_SetThingPosition(mo) end if
              if moved and mo.subsector is not void and mo.subsector.sector is not void then
                mo.floorz = _DNet_ToInt(mo.subsector.sector.floorheight, 0)
                mo.ceilingz = _DNet_ToInt(mo.subsector.sector.ceilingheight, 0)
              end if
            else
              hardPlayer = playerSpawnedNow
              if not hardPlayer then
                if _DNet_MPAbs32(_DNet_ToInt(mo.x, 0) - px) > _DNET_MP_CLIENT_HARD_SNAP_DIST then hardPlayer = true end if
                if _DNet_MPAbs32(_DNet_ToInt(mo.y, 0) - py) > _DNET_MP_CLIENT_HARD_SNAP_DIST then hardPlayer = true end if
                if _DNet_MPAbs32(_DNet_ToInt(mo.z, 0) - pz) > _DNET_MP_CLIENT_HARD_SNAP_DIST then hardPlayer = true end if
              end if
              if hardPlayer then
                moved = _DNet_ToInt(mo.x, 0) != px or _DNet_ToInt(mo.y, 0) != py or _DNet_ToInt(mo.z, 0) != pz
                if moved and typeof(P_UnsetThingPosition) == "function" then P_UnsetThingPosition(mo) end if
                if moved then
                  mo.x = px
                  mo.y = py
                  mo.z = pz
                end if
                mo.angle = pang
                if moved and typeof(P_SetThingPosition) == "function" then P_SetThingPosition(mo) end if
                if moved and mo.subsector is not void and mo.subsector.sector is not void then
                  mo.floorz = _DNet_ToInt(mo.subsector.sector.floorheight, 0)
                  mo.ceilingz = _DNet_ToInt(mo.subsector.sector.ceilingheight, 0)
                end if
              end if
              _DNet_MPClientTrackPlayerSnapshot(slot, px, py, pz, pang, snapTick, hardPlayer)
            end if
            mo.sprite = mspr
            mo.frame = mfrm
            mo.flags = mflags
            mo.health = phealth
            if typeof(states) == "array" and mstate >= 0 and mstate < len(states) then
              mo.state = states[mstate]
              mo.tics = 1
            end if
            p.mo = mo
          end if

          p.health = phealth
          p.armorpoints = parmor
          p.readyweapon = pweapon
          p.killcount = pkill
          p.itemcount = pitem
          p.secretcount = psecret
          p.damagecount = pdamage
          p.bonuscount = pbonus
          p.attackdown = pattack != 0
          p.attacker = void
          p.viewheight = VIEWHEIGHT
          p.deltaviewheight = 0
          p.bob = 0
          if _DNet_IsSeq(p.ammo) then
            if len(p.ammo) > 0 then p.ammo[0] = a0 end if
            if len(p.ammo) > 1 then p.ammo[1] = a1 end if
            if len(p.ammo) > 2 then p.ammo[2] = a2 end if
            if len(p.ammo) > 3 then p.ammo[3] = a3 end if
          end if
          if _DNet_IsSeq(p.cards) then
            ci = 0
            while ci < NUMCARDS and ci < len(p.cards) and ci < 16
              p.cards[ci] = (pcards & (1 << ci)) != 0
              ci = ci + 1
            end while
          end if
          if _DNet_IsSeq(p.weaponowned) then
            wi = 0
            while wi < NUMWEAPONS and wi < len(p.weaponowned) and wi < 16
              p.weaponowned[wi] = (pweapons & (1 << wi)) != 0
              wi = wi + 1
            end while
          end if
          if _DNet_IsSeq(p.frags) then
            if len(p.frags) > 0 then p.frags[0] = fr0 end if
            if len(p.frags) > 1 then p.frags[1] = fr1 end if
            if len(p.frags) > 2 then p.frags[2] = fr2 end if
            if len(p.frags) > 3 then p.frags[3] = fr3 end if
          end if
          vz = pz + VIEWHEIGHT
          if keepLocalPose and typeof(p.mo) == "struct" then
            vz = _DNet_ToInt(p.mo.z, 0) + VIEWHEIGHT
          end if
          if typeof(p.mo) == "struct" then
            maxView = _DNet_ToInt(p.mo.ceilingz, vz) - (4 * FRACUNIT)
            if vz > maxView then vz = maxView end if
          end if
          p.viewz = vz
          if (not _DNet_IsSeq(p.psprites) or len(p.psprites) < 2) and typeof(P_SetupPsprites) == "function" then
            P_SetupPsprites(p)
          end if
          if _DNet_IsSeq(p.psprites) then
            if len(p.psprites) > 0 and typeof(p.psprites[0]) == "struct" then
              psp = p.psprites[0]
              if typeof(states) == "array" and wstate >= 0 and wstate < len(states) then
                psp.state = states[wstate]
              else
                psp.state = void
              end if
              psp.tics = wtics
              psp.sx = wsx
              psp.sy = wsy
              p.psprites[0] = psp
            end if
            if len(p.psprites) > 1 and typeof(p.psprites[1]) == "struct" then
              psp2 = p.psprites[1]
              if typeof(states) == "array" and fstate >= 0 and fstate < len(states) then
                psp2.state = states[fstate]
              else
                psp2.state = void
              end if
              psp2.tics = ftics
              psp2.sx = fsx
              psp2.sy = fsy
              p.psprites[1] = psp2
            end if
          end if
          if (pflags & 1) != 0 then
            p.playerstate = playerstate_t.PST_LIVE
          else
            p.playerstate = playerstate_t.PST_DEAD
          end if
          players[slot] = p
          if slot == consoleplayer then
            if not _dnet_mp_client_local_pickups_armed then
              _dnet_mp_client_local_pickups_armed = true
            else if localPickup and typeof(S_StartSound) == "function" then
              if localWeaponPickup then
                S_StartSound(void, sfxenum_t.sfx_wpnup)
              else
                S_StartSound(void, sfxenum_t.sfx_itemup)
              end if
            end if
          end if
        end if
      end if
    end if
    i = i + 1
  end while

  i = 0
  while i < acount
    aid = _DNet_MPReadU32(payload, off)
    off = off + 4
    atype = _DNet_MPReadU16(payload, off)
    off = off + 2
    ax = _DNet_MPReadI32(payload, off)
    off = off + 4
    ay = _DNet_MPReadI32(payload, off)
    off = off + 4
    az = _DNet_MPReadI32(payload, off)
    off = off + 4
    aang = _DNet_MPReadI32(payload, off)
    off = off + 4
    aspr = _DNet_MPReadU16(payload, off)
    off = off + 2
    afrm = _DNet_MPReadU16(payload, off)
    off = off + 2
    astate = _DNet_MPReadU16(payload, off)
    off = off + 2
    ahp = _DNet_MPReadI16(payload, off)
    off = off + 2
    afl = _DNet_MPReadU32(payload, off)
    off = off + 4

    idx = _DNet_MPClientFindActorIndex(aid)
    mo = void
    spawnedNow = false
    if idx >= 0 and idx < len(_dnet_mp_client_actor_refs) then
      mo = _dnet_mp_client_actor_refs[idx]
      if typeof(mo) != "struct" or _DNet_ToInt(mo.type, -1) != atype then
        _DNet_MPClientRemoveActorAt(idx)
        mo = void
        idx = -1
      end if
    end if
    if idx < 0 then
      idx4 = _DNet_MPClientFindActorByUidField(aid)
      if idx4 >= 0 and idx4 < len(_dnet_mp_client_actor_refs) then
        idx = idx4
        mo = _dnet_mp_client_actor_refs[idx]
        _DNet_MPClientBindActorId(idx, aid)
      end if
    end if
    if idx < 0 then
      idx2 = _DNet_MPClientFindActorByPose(atype, ax, ay, az, claimedActors)
      if idx2 >= 0 and idx2 < len(_dnet_mp_client_actor_refs) then
        idx = idx2
        mo = _dnet_mp_client_actor_refs[idx]
        _DNet_MPClientBindActorId(idx, aid)
      else
        idx3 = _DNet_MPClientFindClaimedActorExact(atype, ax, ay, az, aang, aspr, afrm, astate, claimedActors)
        if idx3 >= 0 and idx3 < len(_dnet_mp_client_actor_refs) then
          idx = idx3
          mo = _dnet_mp_client_actor_refs[idx]
          _DNet_MPClientBindActorId(idx, aid)
        end if
      end if
    end if
    if mo is void and typeof(P_SpawnMobj) == "function" then
      mo = P_SpawnMobj(ax, ay, az, atype)
      if typeof(mo) == "struct" then
        spawnedNow = true
        mo.mpuid = aid
        if idx < 0 then
          freeIdx = _DNet_MPClientFindFreeActorSlot()
          if freeIdx >= 0 and freeIdx < len(_dnet_mp_client_actor_ids) and freeIdx < len(_dnet_mp_client_actor_refs) then
            idx = freeIdx
            _DNet_MPClientBindActorId(idx, aid)
            _dnet_mp_client_actor_refs[idx] = mo
          else
            _dnet_mp_client_actor_ids = _dnet_mp_client_actor_ids + [aid]
            _dnet_mp_client_actor_refs = _dnet_mp_client_actor_refs + [mo]
            idx = len(_dnet_mp_client_actor_ids) - 1
          end if
        else
          _DNet_MPClientBindActorId(idx, aid)
          _dnet_mp_client_actor_refs[idx] = mo
        end if
      end if
    end if
    if typeof(mo) == "struct" then
      mo.mpuid = aid
      hardSnap = spawnedNow
      if not hardSnap then
        if _DNet_MPAbs32(_DNet_ToInt(mo.x, 0) - ax) > _DNET_MP_CLIENT_HARD_SNAP_DIST then hardSnap = true end if
        if _DNet_MPAbs32(_DNet_ToInt(mo.y, 0) - ay) > _DNET_MP_CLIENT_HARD_SNAP_DIST then hardSnap = true end if
        if _DNet_MPAbs32(_DNet_ToInt(mo.z, 0) - az) > _DNET_MP_CLIENT_HARD_SNAP_DIST then hardSnap = true end if
      end if
      if hardSnap then
        moved = _DNet_ToInt(mo.x, 0) != ax or _DNet_ToInt(mo.y, 0) != ay or _DNet_ToInt(mo.z, 0) != az
        if moved and typeof(P_UnsetThingPosition) == "function" then P_UnsetThingPosition(mo) end if
        if moved then
          mo.x = ax
          mo.y = ay
          mo.z = az
        end if
        mo.angle = aang
        if moved and typeof(P_SetThingPosition) == "function" then P_SetThingPosition(mo) end if
        if moved and mo.subsector is not void and mo.subsector.sector is not void then
          mo.floorz = _DNet_ToInt(mo.subsector.sector.floorheight, 0)
          mo.ceilingz = _DNet_ToInt(mo.subsector.sector.ceilingheight, 0)
        end if
      end if
      mo.sprite = aspr
      mo.frame = afrm
      mo.flags = afl
      mo.health = ahp
      if typeof(states) == "array" and astate >= 0 and astate < len(states) then
        mo.state = states[astate]
        mo.tics = 1
      end if
      if idx >= 0 and idx < len(_dnet_mp_client_actor_refs) then
        _dnet_mp_client_actor_refs[idx] = mo
      end if
      if idx >= 0 then
        _DNet_MPClientTrackActorSnapshot(idx, mo, atype, afl, ax, ay, az, aang, snapTick, spawnedNow or hardSnap)
        if idx < len(claimedActors) then
          claimedActors[idx] = 1
        end if
        if len(_dnet_mp_client_actor_miss) <= idx then
          missGrow = (idx + 1) - len(_dnet_mp_client_actor_miss)
          _dnet_mp_client_actor_miss = _dnet_mp_client_actor_miss + array(missGrow, 0)
        end if
        _dnet_mp_client_actor_miss[idx] = 0
      end if
    end if
    i = i + 1
  end while

  i = 0
  while i < rcount
    rid = _DNet_MPReadU32(payload, off)
    off = off + 4
    idx = _DNet_MPClientFindActorIndex(rid)
    if idx >= 0 then _DNet_MPClientRemoveActorAt(idx) end if
    i = i + 1
  end while

  i = 0
  while i < scount
    sidx = _DNet_MPReadU16(payload, off)
    off = off + 2
    sf = _DNet_MPReadI32(payload, off)
    off = off + 4
    sc = _DNet_MPReadI32(payload, off)
    off = off + 4
    sl = _DNet_MPReadU16(payload, off)
    off = off + 2
    ss = _DNet_MPReadU16(payload, off)
    off = off + 2
    if typeof(sectors) == "array" and sidx >= 0 and sidx < len(sectors) then
      sec = sectors[sidx]
      sec.floorheight = sf
      sec.ceilingheight = sc
      sec.lightlevel = sl
      sec.special = ss
      sectors[sidx] = sec
    end if
    i = i + 1
  end while

  i = 0
  while i < sdcount
    sdidx = _DNet_MPReadU16(payload, off)
    off = off + 2
    sdt = _DNet_MPReadU16(payload, off)
    off = off + 2
    sdb = _DNet_MPReadU16(payload, off)
    off = off + 2
    sdm = _DNet_MPReadU16(payload, off)
    off = off + 2
    if typeof(sides) == "array" and sdidx >= 0 and sdidx < len(sides) then
      sd = sides[sdidx]
      sd.toptexture = sdt
      sd.bottomtexture = sdb
      sd.midtexture = sdm
      sides[sdidx] = sd
    end if
    i = i + 1
  end while

  // Only run stale pruning from full snapshots; delta snapshots intentionally omit unchanged actors/players.
  if (flags & 1) != 0 then
    missLimit = _DNet_MPClientStaleMissLimit()
    i = 0
    while i < len(_dnet_mp_client_actor_ids) and i < len(_dnet_mp_client_actor_refs)
      if len(_dnet_mp_client_actor_miss) <= i then
        missGrow2 = (i + 1) - len(_dnet_mp_client_actor_miss)
        _dnet_mp_client_actor_miss = _dnet_mp_client_actor_miss + array(missGrow2, 0)
      end if
      idv = _DNet_ToInt(_dnet_mp_client_actor_ids[i], 0)
      if idv <= 0 then
        _dnet_mp_client_actor_miss[i] = 0
        i = i + 1
        continue
      end if
      claimed = false
      if i < len(claimedActors) then claimed = claimedActors[i] != 0 end if
      if claimed then
        _dnet_mp_client_actor_miss[i] = 0
      else
        miss = _DNet_ToInt(_dnet_mp_client_actor_miss[i], 0) + 1
        _dnet_mp_client_actor_miss[i] = miss
        actorLimit = missLimit
        if i < len(_dnet_mp_client_actor_refs) then
          actorLimit = _DNet_MPClientActorMissLimit(missLimit, _dnet_mp_client_actor_refs[i])
        end if
        if miss > actorLimit then
          _DNet_MPClientRemoveActorAt(i)
        end if
      end if
      i = i + 1
    end while

    i = 0
    while i < MAXPLAYERS
      if (i != consoleplayer) and _DNet_IsSeq(playeringame) and i < len(playeringame) and playeringame[i] and seenPlayers[i] == 0 then
        _DNet_MPSetPlayerSlotActive(i, false)
      end if
      i = i + 1
    end while
  end if
end function

/// Pumps and routes authoritative multiplayer packets for host/client.
/// @internal
function _DNet_MPDrainAuthoritativePackets()
  global _dnet_mp_dbg_unknown_payload_drop
  if not _DNet_MPIsAuthoritative() then return end if
  if typeof(MP_PlatformPump) == "function" then MP_PlatformPump() end if

  latestSnap = void
  latestPhase = void
  latestWIStats = void
  snapApplied = 0
  // Apply several actor/player snapshot deltas per pump to avoid starving rotating actor slices.
  snapApplyBudget = 20
  drained = 0
  while true
    if drained >= 128 then break end if
    pkt = void
    if typeof(MP_PlatformNetRecv) == "function" then pkt = MP_PlatformNetRecv() end if
    if not _DNet_IsSeq(pkt) or len(pkt) < 2 then break end if
    drained = drained + 1
    node = _DNet_ToInt(pkt[0], -1)
    payload = pkt[1]
    if typeof(payload) != "bytes" or len(payload) <= 0 then continue end if
    kind = payload[0] & 255
    if _DNet_MPIsHost() then
      if kind == _DNET_MPMSG_INPUT then _DNet_MPHostHandleInputPacket(node, payload) end if
      if kind == _DNET_MPMSG_WISTATS_REQ then _DNet_MPHostHandleWIStatsRequest(node, payload) end if
      if kind == _DNET_MPMSG_CHAT then _DNet_MPHostHandleChatPacket(node, payload) end if
      if kind == _DNET_MPMSG_NAME then _DNet_MPHostHandleNamePacket(node, payload) end if
      if kind != _DNET_MPMSG_INPUT and kind != _DNET_MPMSG_WISTATS_REQ and kind != _DNET_MPMSG_CHAT and kind != _DNET_MPMSG_NAME then
        _dnet_mp_dbg_unknown_payload_drop = _DNet_ToInt(_dnet_mp_dbg_unknown_payload_drop, 0) + 1
      end if
    else if _DNet_MPIsClient() then
      if kind == _DNET_MPMSG_SNAPSHOT then
        // Snapshot coalescing must not drop geometry/switch deltas.
        // Also apply a bounded number of actor/player-only snapshots each pump so
        // rotating actor replication (especially static objects) is not starved.
        criticalSnap = false
        if len(payload) >= 11 then
          sflags = payload[1] & 255
          rcount = payload[8] & 255
          scount = payload[9] & 255
          sdcount = payload[10] & 255
          if (sflags & 1) != 0 or rcount > 0 or scount > 0 or sdcount > 0 then
            criticalSnap = true
          end if
        end if
        if criticalSnap then
          _DNet_MPClientApplySnapshot(payload)
        else if snapApplied < snapApplyBudget then
          _DNet_MPClientApplySnapshot(payload)
          snapApplied = snapApplied + 1
        else
          latestSnap = payload
        end if
      end if
      if kind == _DNET_MPMSG_PHASE then latestPhase = payload end if
      if kind == _DNET_MPMSG_FEED then _DNet_MPClientApplyFeed(payload) end if
      if kind == _DNET_MPMSG_CHAT then _DNet_MPClientApplyChat(payload) end if
      if kind == _DNET_MPMSG_NAME then _DNet_MPClientApplyName(payload) end if
      if kind == _DNET_MPMSG_WISTATS then latestWIStats = payload end if
      if kind == _DNET_MPMSG_SOUND then
        if typeof(S_NetRecvPacket) == "function" then S_NetRecvPacket(payload) end if
      else if kind != _DNET_MPMSG_SNAPSHOT and kind != _DNET_MPMSG_PHASE and kind != _DNET_MPMSG_FEED and kind != _DNET_MPMSG_CHAT and kind != _DNET_MPMSG_NAME and kind != _DNET_MPMSG_WISTATS then
        _dnet_mp_dbg_unknown_payload_drop = _DNet_ToInt(_dnet_mp_dbg_unknown_payload_drop, 0) + 1
      end if
    end if
  end while

  if _DNet_MPIsClient() and typeof(latestPhase) == "bytes" then
    _DNet_MPClientApplyPhase(latestPhase)
  end if
  if _DNet_MPIsClient() and typeof(latestWIStats) == "bytes" then
    _DNet_MPClientApplyWIStats(latestWIStats)
  end if
  if _DNet_MPIsClient() and typeof(latestSnap) == "bytes" then
    _DNet_MPClientApplySnapshot(latestSnap)
  end if
end function

/// Takes an atomic value-copy snapshot of the mutable legacy netbuffer.
/// @internal
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

/// Commits a decoded packet store into netbuffer only after validation succeeds.
/// @param src Src value supplied to `_DNet_CopyStoreToBuffer`.
/// @internal
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

/// Rebuilds Doom networking, slot ownership, and tic queues as one local player after startup or transport
/// loss.
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
  global consoleplayer
  global displayplayer
  global localcmds

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

  // Slot zero is the only valid owner offline; clearing all peer state prevents a
  // disconnected client slot from leaking into the next title/menu-launched game.
  consoleplayer = 0
  displayplayer = 0
  i = 0
  while i < MAXPLAYERS
    if _DNet_IsSeq(playeringame) and i < len(playeringame) then playeringame[i] = (i == 0) end if
    if _DNet_IsSeq(nodeforplayer) and i < len(nodeforplayer) then nodeforplayer[i] = 0 end if
    if _DNet_IsSeq(netcmds) and i < len(netcmds) then netcmds[i] = _DNet_DefaultCmds() end if
    i = i + 1
  end while
  i = 0
  while i < MAXNETNODES
    if _DNet_IsSeq(nettics) and i < len(nettics) then nettics[i] = 0 end if
    if _DNet_IsSeq(nodeingame) and i < len(nodeingame) then nodeingame[i] = (i == 0) end if
    if _DNet_IsSeq(remoteresend) and i < len(remoteresend) then remoteresend[i] = false end if
    if _DNet_IsSeq(resendto) and i < len(resendto) then resendto[i] = 0 end if
    if _DNet_IsSeq(resendcount) and i < len(resendcount) then resendcount[i] = 0 end if
    i = i + 1
  end while
  localcmds = _DNet_DefaultCmds()

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
  _DNet_MPResetRuntime()
end function

/// Resets legacy/authoritative network clocks and initializes the platform network driver once.
function D_CheckNetGame()
  global consoleplayer
  global displayplayer
  global deathmatch
  global ticdup
  global maxsend

  _DNet_EnsureStateArrays()
  _DNet_MPResetRuntime()
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

/// Repeats a legacy exit notification to every active remote node before local shutdown.
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

/// Pumps authoritative packets, samples local input, and fills per-player ticcmd rings without simulating
/// clients.
function NetUpdate()
  global gametime
  global maketic
  global skiptics
  global netgame
  global deathmatch
  global _dnet_mp_was_authoritative
  global _dnet_mp_was_client
  global _dnet_mp_local_name_announced

  _DNet_EnsureStateArrays()

  isClientNow = _DNet_MPIsClient()
  mpAuth = _DNet_MPIsHost() or isClientNow
  if (not mpAuth) and _dnet_mp_was_authoritative then
    disconnectedClient = _dnet_mp_was_client
    _dnet_mp_was_authoritative = false
    _dnet_mp_was_client = false
    _DNet_MPReturnToOffline(disconnectedClient)
    return
  else if mpAuth then
    _dnet_mp_was_authoritative = true
    _dnet_mp_was_client = isClientNow
  end if
  if mpAuth then
    netgame = true
    _DNet_MPDrainAuthoritativePackets()
    // The pump may close a timed-out transport synchronously. Transition now,
    // before stale MP globals feed another input/simulation pass.
    if not _DNet_MPIsAuthoritative() then
      disconnectedClient = _dnet_mp_was_client
      _dnet_mp_was_authoritative = false
      _dnet_mp_was_client = false
      _DNet_MPReturnToOffline(disconnectedClient)
      return
    end if
    modeFallback = 0
    if deathmatch then modeFallback = 1 end if
    if typeof(MP_PlatformGetSessionMode) == "function" then
      sessionMode = _DNet_ToInt(MP_PlatformGetSessionMode(), modeFallback)
      deathmatch = (sessionMode == 1)
    end if
    localSlot = _DNet_ToInt(consoleplayer, 0)
    if typeof(MP_PlatformGetLocalPlayerSlot) == "function" then
      localSlot = _DNet_ToInt(MP_PlatformGetLocalPlayerSlot(), localSlot)
    end if
    if localSlot < 0 then localSlot = 0 end if
    if localSlot >= MAXPLAYERS then localSlot = 0 end if
    consoleplayer = localSlot
    displayplayer = localSlot
    // Announce once after the authoritative slot is known. Besides filling the
    // initial cache, this uses the same host-validated path as the NAME command.
    if not _dnet_mp_local_name_announced then
      D_NetMPSetPlayerName(MP_GetPlayerName())
      _dnet_mp_local_name_announced = true
    end if
    if _DNet_MPIsHost() then _DNet_MPHostApplyActiveSlots() end if
    if typeof(doomcom) == "struct" then
      doomcom.numnodes = 1
      doomcom.consoleplayer = localSlot
      if deathmatch then
        doomcom.deathmatch = 1
      else
        doomcom.deathmatch = 0
      end if
      if typeof(MP_PlatformGetNumPlayers) == "function" then
        doomcom.numplayers = _DNet_ToInt(MP_PlatformGetNumPlayers(), 1)
      end if
    end if
    if _DNet_IsSeq(nodeingame) and len(nodeingame) > 0 then
      i = 0
      while i < len(nodeingame)
        nodeingame[i] = false
        i = i + 1
      end while
      nodeingame[0] = true
    end if
    if _DNet_MPIsHost() then
      _DNet_MPHostCheckFragFeed()
      _DNet_MPHostMaybeSendPhase(false)
    end if
    if _DNet_MPIsClient() then
      _DNet_MPSetPlayerSlotActive(localSlot, true)
      _DNet_MPEnsureHostSlotMobj(localSlot)
      if typeof(_dnet_mp_client_pending_snapshot) == "bytes" and _DNet_MPLevelReady() then
        _DNet_MPClientApplySnapshot(_dnet_mp_client_pending_snapshot)
      end if
      _DNet_MPClientUpdateWIStatsSync()
      _DNet_MPClientAdvancePlayers()
      _DNet_MPClientAdvanceActors()
    end if
  end if

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
        // In authoritative client mode, gametic does not advance locally; keep producing input commands.
        if not _DNet_MPIsClient() then
          break
        end if
      end if
      cmd = ticcmd_t(0, 0, 0, 0, 0, 0)
      if typeof(G_BuildTiccmd) == "function" then
        G_BuildTiccmd(cmd)
      end if
      localcmds[maketic % BACKUPTICS] = _DNet_CopyCmd(cmd)
      if consoleplayer >= 0 and consoleplayer < MAXPLAYERS then
        netcmds[consoleplayer][maketic % BACKUPTICS] = _DNet_CopyCmd(cmd)
        if _DNet_IsSeq(players) and consoleplayer < len(players) and typeof(players[consoleplayer]) == "struct" then
          pl = players[consoleplayer]
          pl.cmd = _DNet_CopyCmd(cmd)
          players[consoleplayer] = pl
        end if
      end if

      if mpAuth then
        if _DNet_MPIsHost() then
          rslot = 0
          while rslot < MAXPLAYERS
            if rslot != consoleplayer and _DNet_IsSeq(playeringame) and rslot < len(playeringame) and playeringame[rslot] then
              rcmd = ticcmd_t(0, 0, 0, 0, 0, 0)
              if rslot < len(_dnet_mp_remote_cmds) and rslot < len(_dnet_mp_remote_cmd_valid) and _dnet_mp_remote_cmd_valid[rslot] then
                cmdAge = 0
                if _DNet_IsSeq(_dnet_mp_remote_cmd_tic) and rslot < len(_dnet_mp_remote_cmd_tic) then
                  // Reception stamps are in authoritative gametic units; using
                  // maketic here makes valid input expire early after stalls.
                  cmdAge = _DNet_ToInt(gametic, 0) - _DNet_ToInt(_dnet_mp_remote_cmd_tic[rslot], 0)
                end if
                if cmdAge < 0 then cmdAge = 0 end if
                if cmdAge <= _DNET_MP_REMOTE_CMD_STALE_TICS then
                  rcmd = _DNet_CopyCmd(_dnet_mp_remote_cmds[rslot])
                else
                  _dnet_mp_remote_cmd_valid[rslot] = false
                  if _DNet_IsSeq(players) and rslot < len(players) and typeof(players[rslot]) == "struct" and typeof(players[rslot].mo) == "struct" then
                    stidx = _DNet_StateIndex(players[rslot].mo.state)
                    run0 = _DNet_StateIndex(statenum_t.S_PLAY_RUN1)
                    if run0 >= 0 and stidx >= run0 and stidx < run0 + 4 and typeof(P_SetMobjState) == "function" then
                      P_SetMobjState(players[rslot].mo, statenum_t.S_PLAY)
                    end if
                  end if
                end if
              end if
              if _DNet_ToInt(rcmd.forwardmove, 0) == 0 and _DNet_ToInt(rcmd.sidemove, 0) == 0 then
                if _DNet_IsSeq(players) and rslot < len(players) and typeof(players[rslot]) == "struct" and typeof(players[rslot].mo) == "struct" then
                  stidx = _DNet_StateIndex(players[rslot].mo.state)
                  run0 = _DNet_StateIndex(statenum_t.S_PLAY_RUN1)
                  if run0 >= 0 and stidx >= run0 and stidx < run0 + 4 and typeof(P_SetMobjState) == "function" then
                    P_SetMobjState(players[rslot].mo, statenum_t.S_PLAY)
                  end if
                end if
              end if
              netcmds[rslot][maketic % BACKUPTICS] = _DNet_CopyCmd(rcmd)
              if _DNet_IsSeq(players) and rslot < len(players) and typeof(players[rslot]) == "struct" then
                rp = players[rslot]
                rp.cmd = _DNet_CopyCmd(rcmd)
                players[rslot] = rp
              end if
            end if
            rslot = rslot + 1
          end while
        else if _DNet_MPIsClient() then
          _DNet_MPSendInputCmd(cmd)
        end if
      end if

      maketic = maketic + 1
      i = i + 1
    end while
    nettics[0] = maketic
  end if

  if mpAuth then
    _DNet_MPDrainAuthoritativePackets()
    if not _DNet_MPIsAuthoritative() then
      disconnectedClient = _dnet_mp_was_client
      _dnet_mp_was_authoritative = false
      _dnet_mp_was_client = false
      _DNet_MPReturnToOffline(disconnectedClient)
      return
    end if
  end if

  if singletics then return end if

  if mpAuth then
    return
  end if

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

/// Runs a bounded number of host/legacy simulation tics and emits host snapshots after each authoritative tic.
/// @param counts Counts value supplied to `_DNet_RunGameTics`.
/// @internal
function _DNet_RunGameTics(counts)
  global gametic

  ran = 0
  while counts > 0
    i = 0
    while i < ticdup
      if advancedemo and typeof(D_DoAdvanceDemo) == "function" then D_DoAdvanceDemo() end if
        if typeof(M_Ticker) == "function" then M_Ticker() end if
        if typeof(G_Ticker) == "function" then G_Ticker() end if
        if _DNet_MPIsHost() then _DNet_MPHostApplyActiveSlots() end if
        gametic = gametic + 1
        if _DNet_MPIsHost() then
          forceSnap = (gametic % _DNET_MP_FULL_SNAPSHOT_PERIOD) == 0
          _DNet_MPHostMaybeSendSnapshot(forceSnap)
        end if
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

/// Drains every locally available tic for uncapped single-player rendering while preserving network clocks.
/// @internal
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

/// Schedules host/legacy simulation or client-only UI/interpolation ticks from wall-clock and network
/// availability.
function TryRunTics()
  global _dnet_oldentertics
  global _dnet_oldnettics
  global _dnet_frameon
  global skiptics
  global gametime
  global d_runtics_last
  global _dnet_mp_client_ui_tic
  global _dnet_mp_client_wait_wistats
  global _dnet_mp_client_have_wistats
  global gameaction

  d_runtics_last = 0

  if _DNet_MPIsClient() then
    NetUpdate()
    walltic = 0
    if typeof(I_GetTime) == "function" then walltic = I_GetTime() end if
    walltic = _DNet_IDiv(_DNet_ToInt(walltic, 0), ticdup)
    nowtic = walltic
    if gamestate == gamestate_t.GS_LEVEL then
      // During gameplay keep UI clock at least in sync with authoritative snapshot ticks.
      snapTic = _DNet_ToInt(gametic, 0)
      if snapTic > nowtic then nowtic = snapTic end if
    else
      // Non-level states must never stall because gametic stopped advancing.
      if _DNet_ToInt(_dnet_mp_client_ui_tic, -1) > nowtic then
        _dnet_mp_client_ui_tic = nowtic - 1
      end if
    end if
    if _DNet_ToInt(_dnet_mp_client_ui_tic, -1) < 0 then
      _dnet_mp_client_ui_tic = nowtic - 1
    end if
    steps = nowtic - _DNet_ToInt(_dnet_mp_client_ui_tic, 0)
    if steps < 0 then steps = 0 end if
    if steps > 8 then steps = 8 end if

    i = 0
    while i < steps
      if typeof(gameaction) != "void" and gameaction != gameaction_t.ga_nothing then
        if gameaction == gameaction_t.ga_screenshot and typeof(G_ProcessGameActionOnly) == "function" then
          G_ProcessGameActionOnly()
        else
          gameaction = gameaction_t.ga_nothing
        end if
      end if
      if gamestate == gamestate_t.GS_LEVEL then
        if typeof(ST_Ticker) == "function" then ST_Ticker() end if
        if typeof(HU_Ticker) == "function" then HU_Ticker() end if
        if typeof(AM_Ticker) == "function" then AM_Ticker() end if
      else if gamestate == gamestate_t.GS_INTERMISSION then
        if _dnet_mp_client_wait_wistats and(not _dnet_mp_client_have_wistats) then
          _DNet_MPClientUpdateWIStatsSync()
        else
          if typeof(WI_Ticker) == "function" then WI_Ticker() end if
        end if
      else if gamestate == gamestate_t.GS_FINALE then
        if typeof(F_Ticker) == "function" then F_Ticker() end if
      else
        if typeof(D_PageTicker) == "function" then D_PageTicker() end if
      end if
      if typeof(M_Ticker) == "function" then M_Ticker() end if
      _dnet_mp_client_ui_tic = _DNet_ToInt(_dnet_mp_client_ui_tic, 0) + 1
      i = i + 1
    end while
    if steps == 0 and typeof(M_Ticker) == "function" then
      M_Ticker()
    end if
    d_runtics_last = steps
    if d_runtics_last <= 0 then d_runtics_last = 1 end if
    return
  end if

  if (not _DNet_MPIsHost()) and typeof(uncapped_render) != "void" and uncapped_render and(not netgame) then
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
  if _DNet_MPIsHost() then
    // Host must stay tied to real elapsed tics; forcing >=1 per frame overclocks server simulation.
    if counts < 0 then counts = 0 end if
    if counts > 8 then counts = 8 end if
  else
    if counts < 1 then counts = 1 end if
  end if

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
      mpActive = false
      if typeof(MP_PlatformIsHosting) == "function" and MP_PlatformIsHosting() then mpActive = true end if
      if typeof(MP_PlatformIsClientConnected) == "function" and MP_PlatformIsClientConnected() then mpActive = true end if
      if mpActive then
        targettic = _DNet_IDiv(gametic, ticdup) + counts
        j = 0
        while j < numn
          if _DNet_IsSeq(nodeingame) and j < len(nodeingame) and nodeingame[j] and nettics[j] < targettic then
            nettics[j] = targettic
          end if
          j = j + 1
        end while
        break
      end if
      if typeof(M_Ticker) == "function" then M_Ticker() end if
      d_runtics_last = 0
      return
    end if
  end while

  if counts > 0 then
    d_runtics_last = _DNet_RunGameTics(counts)
  else
    d_runtics_last = 0
  end if
end function

/// Computes the encoded byte count for the current bounded legacy packet.
function inline NetbufferSize()
  if netbuffer is void then return 0 end if
  n = _DNet_ToInt(netbuffer.numtics, 0)
  if n < 0 then n = 0 end if
  if n > BACKUPTICS then n = BACKUPTICS end if

  return 5 + n * 6
end function

/// Computes the legacy Doom packet checksum over header fields and the transmitted ticcmd rows.
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

/// Expands an 8-bit wire tic into the closest plausible absolute game tic.
/// @param low Low value supplied to `ExpandTics`.
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

/// Controls hSend Packet transitions in the network game system.
/// @param node Node value supplied to `HSendPacket`.
/// @param flags Bit flags that control the operation.
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

/// Receives one legacy packet, verifies checksum/length, and exposes its source node.
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

/// Drains validated legacy packets, updates resend windows, and copies new remote commands into rings.
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

    // MiniDoom transport sends full 32-bit tics, so no 8-bit ExpandTics reconstruction is needed.
    realstart = _DNet_ToInt(netbuffer.starttic, 0)
    realend = realstart + _DNet_ToInt(netbuffer.numtics, 0)

    if (_DNet_ToInt(netbuffer.checksum, 0) & NCMD_EXIT) != 0 then
      if not nodeingame[netnode] then continue end if
      nodeingame[netnode] = false
      if _DNet_IsSeq(playeringame) and netconsole < len(playeringame) then
        playeringame[netconsole] = false
      end if
      global _dnet_exitmsg
      _dnet_exitmsg = "Player " +(netconsole + 1) + " left the game"
      if _DNet_IsSeq(players) and consoleplayer >= 0 and consoleplayer < len(players) and typeof(players[consoleplayer]) == "struct" then
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
      resendto[netnode] = _DNet_ToInt(netbuffer.retransmitfrom, 0)
      resendcount[netnode] = RESENDCOUNT
    else
      resendcount[netnode] = resendcount[netnode] - 1
    end if

    if realend == nettics[netnode] then continue end if
    if realend < nettics[netnode] then continue end if
    if realstart > nettics[netnode] then
      gap = realstart - nettics[netnode]
      // Late join / large history gap: skip old missing tics to avoid permanent lockstep deadlock.
      if gap > BACKUPTICS then
        nettics[netnode] = realstart
      else
        remoteresend[netnode] = true
        continue
      end if
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

/// Pumps input during net-start waits and aborts synchronization when Escape is pressed.
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

/// Exchanges legacy startup settings so every node begins with the console node's map and rules.
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



